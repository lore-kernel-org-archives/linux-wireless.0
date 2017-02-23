Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-oi0-f65.google.com ([209.85.218.65]:36286 "EHLO
        mail-oi0-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751198AbdBWRUM (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 23 Feb 2017 12:20:12 -0500
Received: by mail-oi0-f65.google.com with SMTP id l128so1767522oia.3
        for <linux-wireless@vger.kernel.org>; Thu, 23 Feb 2017 09:20:11 -0800 (PST)
From: Larry Finger <Larry.Finger@lwfinger.net>
To: kvalo@codeaurora.org
Cc: linux-wireless@vger.kernel.org, Ping-Ke Shih <pkshih@realtek.com>,
        Larry Finger <Larry.Finger@lwfinger.net>
Subject: [PATCH 1/4] rtlwifi: Update 8821ae new phy parameters and its parser.
Date: Thu, 23 Feb 2017 11:19:54 -0600
Message-Id: <20170223171957.22500-2-Larry.Finger@lwfinger.net> (sfid-20170223_182201_218090_E79DB129)
In-Reply-To: <20170223171957.22500-1-Larry.Finger@lwfinger.net>
References: <20170223171957.22500-1-Larry.Finger@lwfinger.net>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Ping-Ke Shih <pkshih@realtek.com>

There are new PHY table values for the RTL8821AE. The changes require
new parsing code.

Signed-off-by: Ping-Ke Shih <pkshih@realtek.com>
Signed-off-by: Larry Finger <Larry.Finger@lwfinger.net>
---
 .../net/wireless/realtek/rtlwifi/rtl8821ae/phy.c   | 377 +++++++++------------
 .../net/wireless/realtek/rtlwifi/rtl8821ae/table.c |  55 +--
 .../net/wireless/realtek/rtlwifi/rtl8821ae/table.h |  13 +-
 drivers/net/wireless/realtek/rtlwifi/wifi.h        |  18 +
 4 files changed, 214 insertions(+), 249 deletions(-)

diff --git a/drivers/net/wireless/realtek/rtlwifi/rtl8821ae/phy.c b/drivers/net/wireless/realtek/rtlwifi/rtl8821ae/phy.c
index 8da874c..04c9c31 100644
--- a/drivers/net/wireless/realtek/rtlwifi/rtl8821ae/phy.c
+++ b/drivers/net/wireless/realtek/rtlwifi/rtl8821ae/phy.c
@@ -660,6 +660,88 @@ void rtl8821ae_phy_switch_wirelessband(struct ieee80211_hw *hw, u8 band)
 	return;
 }
 
+static bool _rtl8821ae_check_positive(struct ieee80211_hw *hw,
+				      const u32 condition1,
+				      const u32 condition2)
+{
+	struct rtl_priv *rtlpriv = rtl_priv(hw);
+	struct rtl_hal *rtlhal = rtl_hal(rtlpriv);
+	u32 cut_ver = ((rtlhal->version & CHIP_VER_RTL_MASK)
+					>> CHIP_VER_RTL_SHIFT);
+	u32 intf = (rtlhal->interface == INTF_USB ? BIT(1) : BIT(0));
+
+	u8  board_type = ((rtlhal->board_type & BIT(4)) >> 4) << 0 | /* _GLNA */
+			 ((rtlhal->board_type & BIT(3)) >> 3) << 1 | /* _GPA  */
+			 ((rtlhal->board_type & BIT(7)) >> 7) << 2 | /* _ALNA */
+			 ((rtlhal->board_type & BIT(6)) >> 6) << 3 | /* _APA  */
+			 ((rtlhal->board_type & BIT(2)) >> 2) << 4;  /* _BT   */
+
+	u32 cond1 = condition1, cond2 = condition2;
+	u32 driver1 = cut_ver << 24 |	/* CUT ver */
+		      0 << 20 |			/* interface 2/2 */
+		      0x04 << 16 |		/* platform */
+		      rtlhal->package_type << 12 |
+		      intf << 8 |			/* interface 1/2 */
+		      board_type;
+
+	u32 driver2 = rtlhal->type_glna <<  0 |
+		      rtlhal->type_gpa  <<  8 |
+		      rtlhal->type_alna << 16 |
+		      rtlhal->type_apa  << 24;
+
+	RT_TRACE(rtlpriv, COMP_INIT, DBG_TRACE,
+		 "===> [8812A] CheckPositive (cond1, cond2) = (0x%X 0x%X)\n",
+		 cond1, cond2);
+	RT_TRACE(rtlpriv, COMP_INIT, DBG_TRACE,
+		 "===> [8812A] CheckPositive (driver1, driver2) = (0x%X 0x%X)\n",
+		 driver1, driver2);
+
+	RT_TRACE(rtlpriv, COMP_INIT, DBG_TRACE,
+		 "	(Platform, Interface) = (0x%X, 0x%X)\n", 0x04, intf);
+	RT_TRACE(rtlpriv, COMP_INIT, DBG_TRACE,
+		 "	(Board, Package) = (0x%X, 0x%X)\n",
+		 rtlhal->board_type, rtlhal->package_type);
+
+	/*============== Value Defined Check ===============*/
+	/*QFN Type [15:12] and Cut Version [27:24] need to do value check*/
+
+	if (((cond1 & 0x0000F000) != 0) && ((cond1 & 0x0000F000) !=
+		(driver1 & 0x0000F000)))
+		return false;
+	if (((cond1 & 0x0F000000) != 0) && ((cond1 & 0x0F000000) !=
+		(driver1 & 0x0F000000)))
+		return false;
+
+	/*=============== Bit Defined Check ================*/
+	/* We don't care [31:28] */
+
+	cond1   &= 0x00FF0FFF;
+	driver1 &= 0x00FF0FFF;
+
+	if ((cond1 & driver1) == cond1) {
+		u32 mask = 0;
+
+		if ((cond1 & 0x0F) == 0) /* BoardType is DONTCARE*/
+			return true;
+
+		if ((cond1 & BIT(0)) != 0) /*GLNA*/
+			mask |= 0x000000FF;
+		if ((cond1 & BIT(1)) != 0) /*GPA*/
+			mask |= 0x0000FF00;
+		if ((cond1 & BIT(2)) != 0) /*ALNA*/
+			mask |= 0x00FF0000;
+		if ((cond1 & BIT(3)) != 0) /*APA*/
+			mask |= 0xFF000000;
+
+		/* BoardType of each RF path is matched*/
+		if ((cond2 & mask) == (driver2 & mask))
+			return true;
+		else
+			return false;
+	} else
+		return false;
+}
+
 static bool _rtl8821ae_check_condition(struct ieee80211_hw *hw,
 				       const u32 condition)
 {
@@ -1695,17 +1777,68 @@ static bool _rtl8821ae_phy_bb8821a_config_parafile(struct ieee80211_hw *hw)
 	return true;
 }
 
+static bool
+__rtl8821ae_phy_config_with_headerfile(struct ieee80211_hw *hw,
+				       u32 *array_table, u16 arraylen,
+				       void (*set_reg)(struct ieee80211_hw *hw,
+						       u32 regaddr, u32 data))
+{
+	#define COND_ELSE  2
+	#define COND_ENDIF 3
+
+	int i = 0;
+	u8 cond;
+	bool matched = true, skipped = false;
+
+	while ((i + 1) < arraylen) {
+		u32 v1 = array_table[i];
+		u32 v2 = array_table[i + 1];
+
+		if (v1 & (BIT(31) | BIT(30))) {/*positive & negative condition*/
+			if (v1 & BIT(31)) {/* positive condition*/
+				cond  = (u8)((v1 & (BIT(29) | BIT(28))) >> 28);
+				if (cond == COND_ENDIF) {/*end*/
+					matched = true;
+					skipped = false;
+				} else if (cond == COND_ELSE) /*else*/
+					matched = skipped ? false : true;
+				else {/*if , else if*/
+					if (skipped) {
+						matched = false;
+					} else {
+						if (_rtl8821ae_check_positive(
+								hw, v1, v2)) {
+							matched = true;
+							skipped = true;
+						} else {
+							matched = false;
+							skipped = false;
+						}
+					}
+				}
+			} else if (v1 & BIT(30)) { /*negative condition*/
+			/*do nothing*/
+			}
+		} else {
+			if (matched)
+				set_reg(hw, v1, v2);
+		}
+		i = i + 2;
+	}
+
+	return true;
+}
+
 static bool _rtl8821ae_phy_config_mac_with_headerfile(struct ieee80211_hw *hw)
 {
 	struct rtl_priv *rtlpriv = rtl_priv(hw);
 	struct rtl_hal *rtlhal = rtl_hal(rtlpriv);
-	u32 i, v1, v2;
 	u32 arraylength;
 	u32 *ptrarray;
 
 	RT_TRACE(rtlpriv, COMP_INIT, DBG_TRACE, "Read MAC_REG_Array\n");
 	if (rtlhal->hw_type == HARDWARE_TYPE_RTL8821AE) {
-		arraylength = RTL8821AEMAC_1T_ARRAYLEN;
+		arraylength = RTL8821AE_MAC_1T_ARRAYLEN;
 		ptrarray = RTL8821AE_MAC_REG_ARRAY;
 	} else {
 		arraylength = RTL8812AEMAC_1T_ARRAYLEN;
@@ -1713,37 +1846,9 @@ static bool _rtl8821ae_phy_config_mac_with_headerfile(struct ieee80211_hw *hw)
 	}
 	RT_TRACE(rtlpriv, COMP_INIT, DBG_LOUD,
 		 "Img: MAC_REG_ARRAY LEN %d\n", arraylength);
-	for (i = 0; i < arraylength; i += 2) {
-		v1 = ptrarray[i];
-		v2 = (u8)ptrarray[i + 1];
-		if (v1 < 0xCDCDCDCD) {
-			rtl_write_byte(rtlpriv, v1, (u8)v2);
-			continue;
-		} else {
-			if (!_rtl8821ae_check_condition(hw, v1)) {
-				/*Discard the following (offset, data) pairs*/
-				READ_NEXT_PAIR(ptrarray, v1, v2, i);
-				while (v2 != 0xDEAD &&
-				       v2 != 0xCDEF &&
-				       v2 != 0xCDCD && i < arraylength - 2) {
-					READ_NEXT_PAIR(ptrarray, v1, v2, i);
-				}
-				i -= 2; /* prevent from for-loop += 2*/
-			} else {/*Configure matched pairs and skip to end of if-else.*/
-				READ_NEXT_PAIR(ptrarray, v1, v2, i);
-				while (v2 != 0xDEAD &&
-				       v2 != 0xCDEF &&
-				       v2 != 0xCDCD && i < arraylength - 2) {
-					rtl_write_byte(rtlpriv, v1, v2);
-					READ_NEXT_PAIR(ptrarray, v1, v2, i);
-				}
 
-				while (v2 != 0xDEAD && i < arraylength - 2)
-					READ_NEXT_PAIR(ptrarray, v1, v2, i);
-			}
-		}
-	}
-	return true;
+	return __rtl8821ae_phy_config_with_headerfile(hw,
+			ptrarray, arraylength, rtl_write_byte_with_val32);
 }
 
 static bool _rtl8821ae_phy_config_bb_with_headerfile(struct ieee80211_hw *hw,
@@ -1751,111 +1856,33 @@ static bool _rtl8821ae_phy_config_bb_with_headerfile(struct ieee80211_hw *hw,
 {
 	struct rtl_priv *rtlpriv = rtl_priv(hw);
 	struct rtl_hal *rtlhal = rtl_hal(rtlpriv);
-	int i;
 	u32 *array_table;
 	u16 arraylen;
-	u32 v1 = 0, v2 = 0;
 
 	if (configtype == BASEBAND_CONFIG_PHY_REG) {
 		if (rtlhal->hw_type == HARDWARE_TYPE_RTL8812AE) {
 			arraylen = RTL8812AEPHY_REG_1TARRAYLEN;
 			array_table = RTL8812AE_PHY_REG_ARRAY;
 		} else {
-			arraylen = RTL8821AEPHY_REG_1TARRAYLEN;
+			arraylen = RTL8821AE_PHY_REG_1TARRAYLEN;
 			array_table = RTL8821AE_PHY_REG_ARRAY;
 		}
 
-		for (i = 0; i < arraylen; i += 2) {
-			v1 = array_table[i];
-			v2 = array_table[i + 1];
-			if (v1 < 0xCDCDCDCD) {
-				_rtl8821ae_config_bb_reg(hw, v1, v2);
-				continue;
-			} else {/*This line is the start line of branch.*/
-				if (!_rtl8821ae_check_condition(hw, v1)) {
-					/*Discard the following (offset, data) pairs*/
-					READ_NEXT_PAIR(array_table, v1, v2, i);
-					while (v2 != 0xDEAD &&
-					       v2 != 0xCDEF &&
-					       v2 != 0xCDCD &&
-					       i < arraylen - 2) {
-						READ_NEXT_PAIR(array_table, v1,
-								v2, i);
-					}
-
-					i -= 2; /* prevent from for-loop += 2*/
-				} else {/*Configure matched pairs and skip to end of if-else.*/
-					READ_NEXT_PAIR(array_table, v1, v2, i);
-					while (v2 != 0xDEAD &&
-					       v2 != 0xCDEF &&
-					       v2 != 0xCDCD &&
-					       i < arraylen - 2) {
-						_rtl8821ae_config_bb_reg(hw, v1,
-									 v2);
-						READ_NEXT_PAIR(array_table, v1,
-							       v2, i);
-					}
-
-					while (v2 != 0xDEAD &&
-					       i < arraylen - 2) {
-						READ_NEXT_PAIR(array_table, v1,
-							       v2, i);
-					}
-				}
-			}
-		}
+		return __rtl8821ae_phy_config_with_headerfile(hw,
+				array_table, arraylen,
+				_rtl8821ae_config_bb_reg);
 	} else if (configtype == BASEBAND_CONFIG_AGC_TAB) {
 		if (rtlhal->hw_type == HARDWARE_TYPE_RTL8812AE) {
 			arraylen = RTL8812AEAGCTAB_1TARRAYLEN;
 			array_table = RTL8812AE_AGC_TAB_ARRAY;
 		} else {
-			arraylen = RTL8821AEAGCTAB_1TARRAYLEN;
+			arraylen = RTL8821AE_AGC_TAB_1TARRAYLEN;
 			array_table = RTL8821AE_AGC_TAB_ARRAY;
 		}
 
-		for (i = 0; i < arraylen; i = i + 2) {
-			v1 = array_table[i];
-			v2 = array_table[i+1];
-			if (v1 < 0xCDCDCDCD) {
-				rtl_set_bbreg(hw, v1, MASKDWORD, v2);
-				udelay(1);
-				continue;
-			} else {/*This line is the start line of branch.*/
-				if (!_rtl8821ae_check_condition(hw, v1)) {
-					/*Discard the following (offset, data) pairs*/
-					READ_NEXT_PAIR(array_table, v1, v2, i);
-					while (v2 != 0xDEAD &&
-					       v2 != 0xCDEF &&
-					       v2 != 0xCDCD &&
-					       i < arraylen - 2) {
-						READ_NEXT_PAIR(array_table, v1,
-								v2, i);
-					}
-					i -= 2; /* prevent from for-loop += 2*/
-				} else {/*Configure matched pairs and skip to end of if-else.*/
-					READ_NEXT_PAIR(array_table, v1, v2, i);
-					while (v2 != 0xDEAD &&
-					       v2 != 0xCDEF &&
-					       v2 != 0xCDCD &&
-					       i < arraylen - 2) {
-						rtl_set_bbreg(hw, v1, MASKDWORD,
-							      v2);
-						udelay(1);
-						READ_NEXT_PAIR(array_table, v1,
-							       v2, i);
-					}
-
-					while (v2 != 0xDEAD &&
-						i < arraylen - 2) {
-						READ_NEXT_PAIR(array_table, v1,
-								v2, i);
-					}
-				}
-				RT_TRACE(rtlpriv, COMP_INIT, DBG_TRACE,
-					 "The agctab_array_table[0] is %x Rtl818EEPHY_REGArray[1] is %x\n",
-					  array_table[i],  array_table[i + 1]);
-			}
-		}
+		return __rtl8821ae_phy_config_with_headerfile(hw,
+				array_table, arraylen,
+				rtl_set_bbreg_with_dwmask);
 	}
 	return true;
 }
@@ -1916,7 +1943,7 @@ static bool _rtl8821ae_phy_config_bb_with_pgheaderfile(struct ieee80211_hw *hw,
 		arraylen = RTL8812AEPHY_REG_ARRAY_PGLEN;
 		array = RTL8812AE_PHY_REG_ARRAY_PG;
 	} else {
-		arraylen = RTL8821AEPHY_REG_ARRAY_PGLEN;
+		arraylen = RTL8821AE_PHY_REG_ARRAY_PGLEN;
 		array = RTL8821AE_PHY_REG_ARRAY_PG;
 	}
 
@@ -1980,12 +2007,10 @@ static bool _rtl8821ae_phy_config_bb_with_pgheaderfile(struct ieee80211_hw *hw,
 bool rtl8812ae_phy_config_rf_with_headerfile(struct ieee80211_hw *hw,
 					     enum radio_path rfpath)
 {
-	int i;
 	bool rtstatus = true;
 	u32 *radioa_array_table_a, *radioa_array_table_b;
 	u16 radioa_arraylen_a, radioa_arraylen_b;
 	struct rtl_priv *rtlpriv = rtl_priv(hw);
-	u32 v1 = 0, v2 = 0;
 
 	radioa_arraylen_a = RTL8812AE_RADIOA_1TARRAYLEN;
 	radioa_array_table_a = RTL8812AE_RADIOA_ARRAY;
@@ -1997,69 +2022,14 @@ bool rtl8812ae_phy_config_rf_with_headerfile(struct ieee80211_hw *hw,
 	rtstatus = true;
 	switch (rfpath) {
 	case RF90_PATH_A:
-		for (i = 0; i < radioa_arraylen_a; i = i + 2) {
-			v1 = radioa_array_table_a[i];
-			v2 = radioa_array_table_a[i+1];
-			if (v1 < 0xcdcdcdcd) {
-				_rtl8821ae_config_rf_radio_a(hw, v1, v2);
-				continue;
-			} else{/*This line is the start line of branch.*/
-				if (!_rtl8821ae_check_condition(hw, v1)) {
-					/*Discard the following (offset, data) pairs*/
-					READ_NEXT_PAIR(radioa_array_table_a, v1, v2, i);
-					while (v2 != 0xDEAD &&
-					       v2 != 0xCDEF &&
-					       v2 != 0xCDCD && i < radioa_arraylen_a-2)
-						READ_NEXT_PAIR(radioa_array_table_a, v1, v2, i);
-
-					i -= 2; /* prevent from for-loop += 2*/
-				} else {/*Configure matched pairs and skip to end of if-else.*/
-					READ_NEXT_PAIR(radioa_array_table_a, v1, v2, i);
-					while (v2 != 0xDEAD &&
-					       v2 != 0xCDEF &&
-					       v2 != 0xCDCD && i < radioa_arraylen_a - 2) {
-						_rtl8821ae_config_rf_radio_a(hw, v1, v2);
-						READ_NEXT_PAIR(radioa_array_table_a, v1, v2, i);
-					}
-
-					while (v2 != 0xDEAD && i < radioa_arraylen_a-2)
-						READ_NEXT_PAIR(radioa_array_table_a, v1, v2, i);
-
-				}
-			}
-		}
+		return __rtl8821ae_phy_config_with_headerfile(hw,
+				radioa_array_table_a, radioa_arraylen_a,
+				_rtl8821ae_config_rf_radio_a);
 		break;
 	case RF90_PATH_B:
-		for (i = 0; i < radioa_arraylen_b; i = i + 2) {
-			v1 = radioa_array_table_b[i];
-			v2 = radioa_array_table_b[i+1];
-			if (v1 < 0xcdcdcdcd) {
-				_rtl8821ae_config_rf_radio_b(hw, v1, v2);
-				continue;
-			} else{/*This line is the start line of branch.*/
-				if (!_rtl8821ae_check_condition(hw, v1)) {
-					/*Discard the following (offset, data) pairs*/
-					READ_NEXT_PAIR(radioa_array_table_b, v1, v2, i);
-					while (v2 != 0xDEAD &&
-					       v2 != 0xCDEF &&
-					       v2 != 0xCDCD && i < radioa_arraylen_b-2)
-						READ_NEXT_PAIR(radioa_array_table_b, v1, v2, i);
-
-					i -= 2; /* prevent from for-loop += 2*/
-				} else {/*Configure matched pairs and skip to end of if-else.*/
-					READ_NEXT_PAIR(radioa_array_table_b, v1, v2, i);
-					while (v2 != 0xDEAD &&
-					       v2 != 0xCDEF &&
-					       v2 != 0xCDCD && i < radioa_arraylen_b-2) {
-						_rtl8821ae_config_rf_radio_b(hw, v1, v2);
-						READ_NEXT_PAIR(radioa_array_table_b, v1, v2, i);
-					}
-
-					while (v2 != 0xDEAD && i < radioa_arraylen_b-2)
-						READ_NEXT_PAIR(radioa_array_table_b, v1, v2, i);
-				}
-			}
-		}
+		return __rtl8821ae_phy_config_with_headerfile(hw,
+				radioa_array_table_b, radioa_arraylen_b,
+				_rtl8821ae_config_rf_radio_b);
 		break;
 	case RF90_PATH_C:
 	case RF90_PATH_D:
@@ -2072,21 +2042,10 @@ bool rtl8812ae_phy_config_rf_with_headerfile(struct ieee80211_hw *hw,
 bool rtl8821ae_phy_config_rf_with_headerfile(struct ieee80211_hw *hw,
 						enum radio_path rfpath)
 {
-	#define READ_NEXT_RF_PAIR(v1, v2, i) \
-	do { \
-		i += 2; \
-		v1 = radioa_array_table[i]; \
-		v2 = radioa_array_table[i+1]; \
-	} \
-	while (0)
-
-	int i;
 	bool rtstatus = true;
 	u32 *radioa_array_table;
 	u16 radioa_arraylen;
 	struct rtl_priv *rtlpriv = rtl_priv(hw);
-	/* struct rtl_hal *rtlhal = rtl_hal(rtl_priv(hw)); */
-	u32 v1 = 0, v2 = 0;
 
 	radioa_arraylen = RTL8821AE_RADIOA_1TARRAYLEN;
 	radioa_array_table = RTL8821AE_RADIOA_ARRAY;
@@ -2096,35 +2055,9 @@ bool rtl8821ae_phy_config_rf_with_headerfile(struct ieee80211_hw *hw,
 	rtstatus = true;
 	switch (rfpath) {
 	case RF90_PATH_A:
-		for (i = 0; i < radioa_arraylen; i = i + 2) {
-			v1 = radioa_array_table[i];
-			v2 = radioa_array_table[i+1];
-			if (v1 < 0xcdcdcdcd)
-				_rtl8821ae_config_rf_radio_a(hw, v1, v2);
-			else{/*This line is the start line of branch.*/
-				if (!_rtl8821ae_check_condition(hw, v1)) {
-					/*Discard the following (offset, data) pairs*/
-					READ_NEXT_RF_PAIR(v1, v2, i);
-					while (v2 != 0xDEAD &&
-						v2 != 0xCDEF &&
-						v2 != 0xCDCD && i < radioa_arraylen - 2)
-						READ_NEXT_RF_PAIR(v1, v2, i);
-
-					i -= 2; /* prevent from for-loop += 2*/
-				} else {/*Configure matched pairs and skip to end of if-else.*/
-					READ_NEXT_RF_PAIR(v1, v2, i);
-					while (v2 != 0xDEAD &&
-					       v2 != 0xCDEF &&
-					       v2 != 0xCDCD && i < radioa_arraylen - 2) {
-						_rtl8821ae_config_rf_radio_a(hw, v1, v2);
-						READ_NEXT_RF_PAIR(v1, v2, i);
-					}
-
-					while (v2 != 0xDEAD && i < radioa_arraylen - 2)
-						READ_NEXT_RF_PAIR(v1, v2, i);
-				}
-			}
-		}
+		return __rtl8821ae_phy_config_with_headerfile(hw,
+			radioa_array_table, radioa_arraylen,
+			_rtl8821ae_config_rf_radio_a);
 		break;
 
 	case RF90_PATH_B:
diff --git a/drivers/net/wireless/realtek/rtlwifi/rtl8821ae/table.c b/drivers/net/wireless/realtek/rtlwifi/rtl8821ae/table.c
index 62a0fb7..64e69e5 100644
--- a/drivers/net/wireless/realtek/rtlwifi/rtl8821ae/table.c
+++ b/drivers/net/wireless/realtek/rtlwifi/rtl8821ae/table.c
@@ -449,6 +449,9 @@ u32 RTL8821AE_PHY_REG_ARRAY[] = {
 	0xCB8, 0x00508240,
 };
 
+u32 RTL8821AE_PHY_REG_1TARRAYLEN =
+	sizeof(RTL8821AE_PHY_REG_ARRAY) / sizeof(u32);
+
 u32 RTL8812AE_PHY_REG_ARRAY_PG[] = {
 	0, 0, 0, 0x00000c20, 0xffffffff, 0x34363840,
 	0, 0, 0, 0x00000c24, 0xffffffff, 0x42424444,
@@ -516,6 +519,9 @@ u32 RTL8821AE_PHY_REG_ARRAY_PG[] = {
 	1, 0, 0, 0x00000c44, 0x0000ffff, 0x00002022
 };
 
+u32 RTL8821AE_PHY_REG_ARRAY_PGLEN =
+		sizeof(RTL8821AE_PHY_REG_ARRAY_PG) / sizeof(u32);
+
 u32 RTL8812AE_RADIOA_ARRAY[] = {
 		0x000, 0x00010000,
 		0x018, 0x0001712A,
@@ -2285,16 +2291,16 @@ u32 RTL8821AE_RADIOA_ARRAY[] = {
 		0x0EF, 0x00000000,
 		0x0EF, 0x00000100,
 		0x034, 0x0000ADF3,
-		0x034, 0x00009DEF,
-		0x034, 0x00008DEC,
-		0x034, 0x00007DE9,
-		0x034, 0x00006CED,
-		0x034, 0x00005CE9,
-		0x034, 0x000044E9,
-		0x034, 0x000034E6,
-		0x034, 0x0000246A,
-		0x034, 0x00001467,
-		0x034, 0x00000068,
+		0x034, 0x00009DF0,
+		0x034, 0x00008D70,
+		0x034, 0x00007D6D,
+		0x034, 0x00006CEE,
+		0x034, 0x00005CCC,
+		0x034, 0x000044EC,
+		0x034, 0x000034AC,
+		0x034, 0x0000246D,
+		0x034, 0x0000106F,
+		0x034, 0x0000006C,
 		0x0EF, 0x00000000,
 		0x0ED, 0x00000010,
 		0x044, 0x0000ADF2,
@@ -2365,8 +2371,11 @@ u32 RTL8821AE_RADIOA_ARRAY[] = {
 		0x0FE, 0x00000000,
 		0x0FE, 0x00000000,
 		0x018, 0x0001712A,
+
 };
 
+u32 RTL8821AE_RADIOA_1TARRAYLEN = sizeof(RTL8821AE_RADIOA_ARRAY) / sizeof(u32);
+
 u32 RTL8812AE_MAC_REG_ARRAY[] = {
 		0x010, 0x0000000C,
 	0xFF0F0180, 0xABCD,
@@ -2578,6 +2587,8 @@ u32 RTL8821AE_MAC_REG_ARRAY[] = {
 		0x718, 0x00000040,
 };
 
+u32 RTL8821AE_MAC_1T_ARRAYLEN = sizeof(RTL8821AE_MAC_REG_ARRAY) / sizeof(u32);
+
 u32 RTL8812AE_AGC_TAB_ARRAY[] = {
 	0xFF0F07D8, 0xABCD,
 		0x81C, 0xFC000001,
@@ -3430,9 +3441,11 @@ u32 RTL8821AE_AGC_TAB_ARRAY[] = {
 		0x81C, 0x017E0101,
 		0xC50, 0x00000022,
 		0xC50, 0x00000020,
-
 };
 
+u32 RTL8821AE_AGC_TAB_1TARRAYLEN =
+	sizeof(RTL8821AE_AGC_TAB_ARRAY) / sizeof(u32);
+
 /******************************************************************************
 *                           TXPWR_LMT.TXT
 ******************************************************************************/
@@ -4284,9 +4297,9 @@ u8 *RTL8821AE_TXPWR_LMT[] = {
 	"FCC", "5G", "20M", "OFDM", "1T", "100", "32",
 	"ETSI", "5G", "20M", "OFDM", "1T", "100", "30",
 	"MKK", "5G", "20M", "OFDM", "1T", "100", "30",
-	"FCC", "5G", "20M", "OFDM", "1T", "114", "32",
-	"ETSI", "5G", "20M", "OFDM", "1T", "114", "30",
-	"MKK", "5G", "20M", "OFDM", "1T", "114", "30",
+	"FCC", "5G", "20M", "OFDM", "1T", "104", "32",
+	"ETSI", "5G", "20M", "OFDM", "1T", "104", "30",
+	"MKK", "5G", "20M", "OFDM", "1T", "104", "30",
 	"FCC", "5G", "20M", "OFDM", "1T", "108", "32",
 	"ETSI", "5G", "20M", "OFDM", "1T", "108", "30",
 	"MKK", "5G", "20M", "OFDM", "1T", "108", "30",
@@ -4356,9 +4369,9 @@ u8 *RTL8821AE_TXPWR_LMT[] = {
 	"FCC", "5G", "20M", "HT", "1T", "100", "32",
 	"ETSI", "5G", "20M", "HT", "1T", "100", "30",
 	"MKK", "5G", "20M", "HT", "1T", "100", "30",
-	"FCC", "5G", "20M", "HT", "1T", "114", "32",
-	"ETSI", "5G", "20M", "HT", "1T", "114", "30",
-	"MKK", "5G", "20M", "HT", "1T", "114", "30",
+	"FCC", "5G", "20M", "HT", "1T", "104", "32",
+	"ETSI", "5G", "20M", "HT", "1T", "104", "30",
+	"MKK", "5G", "20M", "HT", "1T", "104", "30",
 	"FCC", "5G", "20M", "HT", "1T", "108", "32",
 	"ETSI", "5G", "20M", "HT", "1T", "108", "30",
 	"MKK", "5G", "20M", "HT", "1T", "108", "30",
@@ -4428,9 +4441,9 @@ u8 *RTL8821AE_TXPWR_LMT[] = {
 	"FCC", "5G", "20M", "HT", "2T", "100", "28",
 	"ETSI", "5G", "20M", "HT", "2T", "100", "30",
 	"MKK", "5G", "20M", "HT", "2T", "100", "30",
-	"FCC", "5G", "20M", "HT", "2T", "114", "28",
-	"ETSI", "5G", "20M", "HT", "2T", "114", "30",
-	"MKK", "5G", "20M", "HT", "2T", "114", "30",
+	"FCC", "5G", "20M", "HT", "2T", "104", "28",
+	"ETSI", "5G", "20M", "HT", "2T", "104", "30",
+	"MKK", "5G", "20M", "HT", "2T", "104", "30",
 	"FCC", "5G", "20M", "HT", "2T", "108", "30",
 	"ETSI", "5G", "20M", "HT", "2T", "108", "30",
 	"MKK", "5G", "20M", "HT", "2T", "108", "30",
@@ -4570,3 +4583,5 @@ u8 *RTL8821AE_TXPWR_LMT[] = {
 	"ETSI", "5G", "80M", "VHT", "2T", "155", "30",
 	"MKK", "5G", "80M", "VHT", "2T", "155", "63"
 };
+
+u32 RTL8821AE_TXPWR_LMT_ARRAY_LEN = sizeof(RTL8821AE_TXPWR_LMT) / sizeof(u8 *);
diff --git a/drivers/net/wireless/realtek/rtlwifi/rtl8821ae/table.h b/drivers/net/wireless/realtek/rtlwifi/rtl8821ae/table.h
index 24bcff6..192057a 100644
--- a/drivers/net/wireless/realtek/rtlwifi/rtl8821ae/table.h
+++ b/drivers/net/wireless/realtek/rtlwifi/rtl8821ae/table.h
@@ -29,32 +29,31 @@
 #define __RTL8821AE_TABLE__H_
 
 #include <linux/types.h>
-#define  RTL8821AEPHY_REG_1TARRAYLEN	344
+extern u32 RTL8821AE_PHY_REG_1TARRAYLEN;
 extern u32 RTL8821AE_PHY_REG_ARRAY[];
 #define  RTL8812AEPHY_REG_1TARRAYLEN	490
 extern u32 RTL8812AE_PHY_REG_ARRAY[];
-#define RTL8821AEPHY_REG_ARRAY_PGLEN	90
+extern u32 RTL8821AE_PHY_REG_ARRAY_PGLEN;
 extern u32 RTL8821AE_PHY_REG_ARRAY_PG[];
 #define RTL8812AEPHY_REG_ARRAY_PGLEN	276
 extern u32 RTL8812AE_PHY_REG_ARRAY_PG[];
 /* #define	RTL8723BE_RADIOA_1TARRAYLEN	206 */
-/* extern u8 *RTL8821AE_TXPWR_LMT_ARRAY[]; */
 #define	RTL8812AE_RADIOA_1TARRAYLEN	1264
 extern u32 RTL8812AE_RADIOA_ARRAY[];
 #define	RTL8812AE_RADIOB_1TARRAYLEN	1240
 extern u32 RTL8812AE_RADIOB_ARRAY[];
-#define	RTL8821AE_RADIOA_1TARRAYLEN	1176
+extern u32 RTL8821AE_RADIOA_1TARRAYLEN;
 extern u32 RTL8821AE_RADIOA_ARRAY[];
-#define RTL8821AEMAC_1T_ARRAYLEN		194
+extern u32 RTL8821AE_MAC_1T_ARRAYLEN;
 extern u32 RTL8821AE_MAC_REG_ARRAY[];
 #define RTL8812AEMAC_1T_ARRAYLEN		214
 extern u32 RTL8812AE_MAC_REG_ARRAY[];
-#define RTL8821AEAGCTAB_1TARRAYLEN		382
+extern u32 RTL8821AE_AGC_TAB_1TARRAYLEN;
 extern u32 RTL8821AE_AGC_TAB_ARRAY[];
 #define RTL8812AEAGCTAB_1TARRAYLEN		1312
 extern u32 RTL8812AE_AGC_TAB_ARRAY[];
 #define RTL8812AE_TXPWR_LMT_ARRAY_LEN		3948
 extern u8 *RTL8812AE_TXPWR_LMT[];
-#define RTL8821AE_TXPWR_LMT_ARRAY_LEN		3948
+extern u32 RTL8821AE_TXPWR_LMT_ARRAY_LEN;
 extern u8 *RTL8821AE_TXPWR_LMT[];
 #endif
diff --git a/drivers/net/wireless/realtek/rtlwifi/wifi.h b/drivers/net/wireless/realtek/rtlwifi/wifi.h
index fbf8974..0019f11 100644
--- a/drivers/net/wireless/realtek/rtlwifi/wifi.h
+++ b/drivers/net/wireless/realtek/rtlwifi/wifi.h
@@ -1529,6 +1529,10 @@ struct rtl_hal {
 	u8 external_lna_2g;
 	u8 external_pa_5g;
 	u8 external_lna_5g;
+	u8 type_glna;
+	u8 type_gpa;
+	u8 type_alna;
+	u8 type_apa;
 	u8 rfe_type;
 
 	/*firmware */
@@ -2938,6 +2942,14 @@ static inline void rtl_write_byte(struct rtl_priv *rtlpriv, u32 addr, u8 val8)
 		rtlpriv->io.read8_sync(rtlpriv, addr);
 }
 
+static inline void rtl_write_byte_with_val32(struct ieee80211_hw *hw,
+					     u32 addr, u32 val8)
+{
+	struct rtl_priv *rtlpriv = rtl_priv(hw);
+
+	rtl_write_byte(rtlpriv, addr, (u8)val8);
+}
+
 static inline void rtl_write_word(struct rtl_priv *rtlpriv, u32 addr, u16 val16)
 {
 	rtlpriv->io.write16_async(rtlpriv, addr, val16);
@@ -2971,6 +2983,12 @@ static inline void rtl_set_bbreg(struct ieee80211_hw *hw, u32 regaddr,
 	rtlpriv->cfg->ops->set_bbreg(hw, regaddr, bitmask, data);
 }
 
+static inline void rtl_set_bbreg_with_dwmask(struct ieee80211_hw *hw,
+				 u32 regaddr, u32 data)
+{
+	rtl_set_bbreg(hw, regaddr, 0xffffffff, data);
+}
+
 static inline u32 rtl_get_rfreg(struct ieee80211_hw *hw,
 				enum radio_path rfpath, u32 regaddr,
 				u32 bitmask)
-- 
2.10.2
