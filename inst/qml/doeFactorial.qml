
// Copyright (C) 2013-2018 University of Amsterdam
// This program is free software: you can redistribute it and/or modify
// it under the terms of the GNU Affero General Public License as
// published by the Free Software Foundation, either version 3 of the
// License, or (at your option) any later version.
// This program is distributed in the hope that it will be useful,
// but WITHOUT ANY WARRANTY; without even the implied warranty of
// MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
// GNU Affero General Public License for more details.
// You should have received a copy of the GNU Affero General Public
// License along with this program.  If not, see
// <http://www.gnu.org/licenses/>.
//

import QtQuick                                  2.8
import QtQuick.Layouts                          1.3
import JASP.Controls                            1.0
import JASP.Widgets                             1.0

Form
{
	usesJaspResults:                            true
	columns:                                    2

	GroupBox
	{
		title: 									qsTr("Design Information")
		name:									"designInfo"

		IntegerField
		{
			id:									numberOfFactors
			name:								"numberOfFactors"
			label:								qsTr("Number of factors")
			defaultValue:						2
			min:								2
			max:								256
		}

		DropDown
		{
			id:										numberOfLevels
			name: 									"numberOfLevels"
			label: 									qsTr("Number of factor levels")
			indexDefaultValue: 						0
			values:
				[
				{ value: "2", label: qsTr("2")}
				//            { value: "3", label: qsTr("3")},
				//            { value: "Mixed", label: qsTr("Mixed")}
			]
		}
	}

	CheckBox
	{
		name: 									"displayDesign"
		label:									"Display design"
	}

	RadioButtonGroup
	{
		title:                                  qsTr("Data Coding")
		debug:                                  true
		name:                                   "dataCoding"

		RadioButton
		{
			name:                               "dataUncoded"
			label:                              qsTr("Uncoded")
			checked:                            true

		}

		RadioButton
		{
			name:                               "dataCoded"
			label:                              qsTr("Coded")

		}
	}

	RadioButtonGroup
	{
		name:                                   "runOrder"
		title:                                  qsTr("Run Order")
		enabled:                                !factorialTypeSplit.checked

		RadioButton
		{
			name:                              "runOrderStandard"
			label:                              qsTr("Standard")
			checked:                            true
		}

		RadioButton
		{
			name:                               "runOrderRandom"
			label:                              qsTr("Random")
		}
	}

	ColumnLayout
	{
		spacing:                                0
		Layout.preferredWidth:					parent.width
		Layout.columnSpan:						2

		RowLayout
		{
			Label { text: qsTr("Factor");		Layout.leftMargin: 5 * preferencesModel.uiScale; Layout.preferredWidth: 42 * preferencesModel.uiScale}
			Label { text: qsTr("Name");			Layout.preferredWidth: 150 * preferencesModel.uiScale}
			Label { text: qsTr("Level 1");		Layout.preferredWidth: 100 * preferencesModel.uiScale	}
			Label { text: qsTr("Level 2");		Layout.preferredWidth: 100 * preferencesModel.uiScale	}
			Label { visible: 					numberOfLevels.currentIndex == 1;
				text: qsTr("Level 3");		Layout.preferredWidth: 100 * preferencesModel.uiScale	}
		}

		ComponentsList
		{
			name:								"factors"
			addItemManually:                    false
			values:                             numberOfFactors.value // update only when numberOfFactors.value gets "entered"

			rowComponent: 						RowLayout
			{
				Row
				{
					spacing:					5 * preferencesModel.uiScale
					Layout.preferredWidth:		40 * preferencesModel.uiScale
					Label
					{
						text: 					rowIndex + 1
					}
				}
				Row //Factor
				{
					spacing:					5 * preferencesModel.uiScale
					Layout.preferredWidth:		100 * preferencesModel.uiScale

					TextField
					{
						id:						factorName
						label: 					""
						name: 					"factorName"
						placeholderText:		qsTr("Factor ") + (rowIndex + 1)
						fieldWidth:				100 * preferencesModel.uiScale
						useExternalBorder:		false
						showBorder:				true
					}
				}
				Row //Level1
				{
					spacing:					5 * preferencesModel.uiScale
					Layout.preferredWidth:		100 * preferencesModel.uiScale
					TextField
					{
						label: 					""
						name: 					"low"
						placeholderText:		qsTr("Factor ") + (rowIndex + 1) + qsTr(" Level 1")
						fieldWidth:				100 * preferencesModel.uiScale
						useExternalBorder:		false
						showBorder:				true
					}
				}
				Row //Level2
				{
					spacing:					5 * preferencesModel.uiScale
					Layout.preferredWidth:		100 * preferencesModel.uiScale
					TextField
					{
						label: 					""
						name: 					"high1"
						placeholderText:		qsTr("Factor ") + (rowIndex + 1) + qsTr(" Level 2")
						fieldWidth:				100 * preferencesModel.uiScale
						useExternalBorder:		false
						showBorder:				true
					}
				}
				Row //Level3
				{
					visible:					[1].includes(numberOfLevels.currentIndex)
					spacing:					5 * preferencesModel.uiScale
					Layout.preferredWidth:		100 * preferencesModel.uiScale
					TextField
					{
						label: 					""
						name: 					"high2"
						placeholderText:		qsTr("Factor ") + (rowIndex + 1) + qsTr(" Level 3")
						fieldWidth:				100 * preferencesModel.uiScale
						useExternalBorder:		false
						showBorder:				true
					}
				}
			}
		}
	}

	Section
	{
		title: 									qsTr("Factorial Design Options")
		columns:								2

		RadioButtonGroup
		{
			name: 								"factorialType"
			title:								qsTr("Type of Factorial Design")

			RadioButton
			{
				id:                             factorialTypeDefault
				name:							"factorialTypeDefault"
				label:							qsTr("2-level factorial (default generators)")
			}

			RadioButton
			{
				id:                             factorialTypeSpecify
				name:							"factorialTypeSpecify"
				label:							qsTr("2-level factorial (specify generators)")

				TextArea
				{
					name:						"factorialTypeSpecifyGenerators"
					height:                     100 * preferencesModel.uiScale
					width:                      250 * preferencesModel.uiScale
					visible:                    factorialTypeSpecify.checked
					title:                      qsTr("Design generators")
					textType:                   JASP.TextTypeSource
				}
			}

			RadioButton
			{
				id:                             factorialTypeSplit
				name:                           "factorialTypeSplit"
				label:							qsTr("2-level split-plot (hard-to-change factors)")

				IntegerField
				{
					name:						"numberHTCFactors"
					label:						qsTr("Number of hard-to-change factors")
					visible:                    factorialTypeSplit.checked
					defaultValue:				1
					min:						1
					max:						numberOfFactors.value

				}
			}

			RadioButton
			{
				id:                             factorialTypeFull
				name:							"factorialTypeFull"
				label:							qsTr("General full factorial design")
				checked:						true
			}
		}

		ColumnLayout
		{

			GroupBox
			{
				title: 							qsTr("Design by")

				RadioButtonGroup
				{
					name:						"designBy"
					enabled:                    !factorialTypeFull.checked

					RadioButton
					{
						name:					"designByRuns"
						label: 					qsTr("Number of runs")
						childrenOnSameRow:		true
						checked:				true

						DropDown
						{
							name: 				"factorialRuns"
							indexDefaultValue: 	0
							values:
								[
								{ value: "4", 	label: qsTr("4") 	},
								{ value: "8", 	label: qsTr("8") 	},
								{ value: "16", 	label: qsTr("16") 	},
								{ value: "32", 	label: qsTr("32") 	},
								{ value: "64", 	label: qsTr("64") 	},
								{ value: "128", label: qsTr("128")	},
								{ value: "256", label: qsTr("256")	},
								{ value: "512", label: qsTr("512")	}
							]
						}
					}

					RadioButton
					{
						name:					"designByResolution"
						enabled:                factorialTypeDefault.checked | factorialTypeSplit.checked
						label: 					qsTr("Resolution")
						childrenOnSameRow:		true

						DropDown
						{
							name: 				"factorialResolution"
							indexDefaultValue: 	7
							values:
								[
								{ value: "I", 	label: qsTr("I") 	},
								{ value: "II", 	label: qsTr("II") 	},
								{ value: "III", label: qsTr("III") 	},
								{ value: "IV", 	label: qsTr("IV") 	},
								{ value: "V", 	label: qsTr("V") 	},
								{ value: "VI", 	label: qsTr("VI")	},
								{ value: "VIII", label: qsTr("VIII")},
								{ value: "Full", label: qsTr("Full")}
							]
						}
					}
				}
			}

			RadioButtonGroup
			{
				title:                          qsTr("Blocking options")
				debug:                          true
				name:                           "blocking"

				RadioButton
				{
					name:                       "noBlocking"
					label:                      qsTr("No blocking (1 block design)")
					checked:                    true
				}

				RadioButton
				{
					id:                         autoBlocking
					name:                       "autoBlocking"
					label:                      qsTr("Automatic definition")

					IntegerField
					{
						name:                   "numberOfBlocks"
						visible:                autoBlocking.checked
						label:                  qsTr("Number of blocks")
					}
				}

				RadioButton
				{
					name:                       "manualBlocking"
					label:                      qsTr("Manual definition")
				}

			}

			GroupBox
			{
				debug:                          true
				title:                          qsTr("Additional options")

				IntegerField
				{
					debug:                      true
					name:						"factorialCenterPoints"
					label:						qsTr("Number of center points per block")
					defaultValue:				1
					min:						1
					max:						50
				}

				IntegerField
				{
					debug:                      true
					name:						"factorialCornerReplicates"
					label:						qsTr("Number of replicates for corner points")
					defaultValue:				3
					min:						1
					max:						50
				}

				IntegerField
				{
					name:						"factorialBlocks"
					enabled:                    !factorialTypeSplit.checked
					label:						qsTr("Number of blocks")
					defaultValue:				1
					min:						1
					max:						50
				}
			}
		}
	}

	GroupBox
	{
		FileSelector
		{
			id:                                 file
			name:                               "file"
			label:                              qsTr("Save as:")
			filter:                             "*.csv"
			save:                               true
		}

		Button
		{
			id: 								exportDesign
			anchors.right:						parent.right
			anchors.bottom:						parent.bottom
			text: 								qsTr("<b>Export Design</b>")
			onClicked: 							actualExporter.click()
		}

		CheckBox
		{
			id:                                 actualExporter
			name:                               "actualExporter"
			visible:                            false
		}
	}
}
