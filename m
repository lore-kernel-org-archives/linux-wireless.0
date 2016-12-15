Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-oi0-f65.google.com ([209.85.218.65]:35179 "EHLO
        mail-oi0-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1755942AbcLOSYC (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 15 Dec 2016 13:24:02 -0500
Received: by mail-oi0-f65.google.com with SMTP id v84so7054861oie.2
        for <linux-wireless@vger.kernel.org>; Thu, 15 Dec 2016 10:23:30 -0800 (PST)
From: Larry Finger <Larry.Finger@lwfinger.net>
To: kvalo@codeaurora.org
Cc: devel@driverdev.osuosl.org, linux-wireless@vger.kernel.org,
        Larry Finger <Larry.Finger@lwfinger.net>,
        Ping-Ke Shih <pkshih@realtek.com>
Subject: [PATCH 03/14 V2] rtlwifi: rtl8821ae: Remove all instances of DBG_EMERG
Date: Thu, 15 Dec 2016 12:22:59 -0600
Message-Id: <20161215182310.13713-4-Larry.Finger@lwfinger.net> (sfid-20161215_192412_182601_C766A941)
In-Reply-To: <20161215182310.13713-1-Larry.Finger@lwfinger.net>
References: <20161215182310.13713-1-Larry.Finger@lwfinger.net>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This is a step toward eliminating the RT_TRACE macros. Those calls that
have DBG_EMERG as the level are always logged, and they represent error
conditions, thus they are replaced with pr_err().

Signed-off-by: Larry Finger <Larry.Finger@lwfinger.net>
Cc: Ping-Ke Shih <pkshih@realtek.com>
---
V2 - eliminate some files that should not have been sent, and remove the
     module name from the format. It is already specified by a pr_fmt().
---
 .../net/wireless/realtek/rtlwifi/rtl8821ae/dm.c    |  3 +-
 .../net/wireless/realtek/rtlwifi/rtl8821ae/fw.c    | 11 ++----
 .../net/wireless/realtek/rtlwifi/rtl8821ae/hw.c    | 15 +++-----
 .../net/wireless/realtek/rtlwifi/rtl8821ae/phy.c   | 43 ++++++++--------------
 .../net/wireless/realtek/rtlwifi/rtl8821ae/rf.c    |  5 +--
 .../net/wireless/realtek/rtlwifi/rtl8821ae/sw.c    | 14 +++----
 6 files changed, 33 insertions(+), 58 deletions(-)

diff --git a/drivers/net/wireless/realtek/rtlwifi/rtl8821ae/dm.c b/drivers/net/wireless/realtek/rtlwifi/rtl8821ae/dm.c
index bdfd444..32900c5 100644
--- a/drivers/net/wireless/realtek/rtlwifi/rtl8821ae/dm.c
+++ b/drivers/net/wireless/realtek/rtlwifi/rtl8821ae/dm.c
@@ -604,8 +604,7 @@ static void rtl8821ae_dm_find_minimum_rssi(struct ieee80211_hw *hw)
 	if ((mac->link_state < MAC80211_LINKED) &&
 	    (rtlpriv->dm.entry_min_undec_sm_pwdb == 0)) {
 		rtl_dm_dig->min_undec_pwdb_for_dm = 0;
-		RT_TRACE(rtlpriv, COMP_BB_POWERSAVING, DBG_LOUD,
-			 "Not connected to any\n");
+		pr_debug("rtl8821ae: Not connected to any AP\n");
 	}
 	if (mac->link_state >= MAC80211_LINKED) {
 		if (mac->opmode == NL80211_IFTYPE_AP ||
diff --git a/drivers/net/wireless/realtek/rtlwifi/rtl8821ae/fw.c b/drivers/net/wireless/realtek/rtlwifi/rtl8821ae/fw.c
index c70face..602ac86 100644
--- a/drivers/net/wireless/realtek/rtlwifi/rtl8821ae/fw.c
+++ b/drivers/net/wireless/realtek/rtlwifi/rtl8821ae/fw.c
@@ -125,8 +125,7 @@ static void _rtl8821ae_write_fw(struct ieee80211_hw *hw,
 	remainsize = size % FW_8821AE_PAGE_SIZE;
 
 	if (pagenums > 8) {
-		RT_TRACE(rtlpriv, COMP_ERR, DBG_EMERG,
-			 "Page numbers should not greater then 8\n");
+		pr_err("Page numbers should not greater then 8\n");
 	}
 
 	for (page = 0; page < pagenums; page++) {
@@ -162,8 +161,8 @@ static int _rtl8821ae_fw_free_to_go(struct ieee80211_hw *hw)
 		goto exit;
 	}
 
-	RT_TRACE(rtlpriv, COMP_FW, DBG_EMERG,
-		 "Checksum report OK ! REG_MCUFWDL:0x%08x .\n", value32);
+	pr_err("Checksum report OK! REG_MCUFWDL:0x%08x\n",
+	       value32);
 
 	value32 = rtl_read_dword(rtlpriv, REG_MCUFWDL);
 	value32 |= MCUFWDL_RDY;
@@ -186,9 +184,8 @@ static int _rtl8821ae_fw_free_to_go(struct ieee80211_hw *hw)
 		udelay(FW_8821AE_POLLING_DELAY);
 	} while (counter++ < FW_8821AE_POLLING_TIMEOUT_COUNT);
 
-	RT_TRACE(rtlpriv, COMP_ERR, DBG_EMERG,
-		 "Polling FW ready fail!! REG_MCUFWDL:0x%08x .\n",
-		 value32);
+	pr_err("Polling FW ready fail!! REG_MCUFWDL:0x%08x .\n",
+	       value32);
 
 exit:
 	return err;
diff --git a/drivers/net/wireless/realtek/rtlwifi/rtl8821ae/hw.c b/drivers/net/wireless/realtek/rtlwifi/rtl8821ae/hw.c
index b6dc2f3..3932a5d 100644
--- a/drivers/net/wireless/realtek/rtlwifi/rtl8821ae/hw.c
+++ b/drivers/net/wireless/realtek/rtlwifi/rtl8821ae/hw.c
@@ -822,9 +822,8 @@ static bool _rtl8821ae_llt_write(struct ieee80211_hw *hw, u32 address, u32 data)
 			break;
 
 		if (count > POLLING_LLT_THRESHOLD) {
-			RT_TRACE(rtlpriv, COMP_ERR, DBG_EMERG,
-				 "Failed to polling write LLT done at address %d!\n",
-				 address);
+			pr_err("Failed to polling write LLT done at address %d!\n",
+			       address);
 			status = false;
 			break;
 		}
@@ -1927,7 +1926,7 @@ int rtl8821ae_hw_init(struct ieee80211_hw *hw)
 
 	rtstatus = _rtl8821ae_init_mac(hw);
 	if (rtstatus != true) {
-		RT_TRACE(rtlpriv, COMP_ERR, DBG_EMERG, "Init MAC failed\n");
+		pr_err("Init MAC failed\n");
 		err = 1;
 		return err;
 	}
@@ -2174,8 +2173,7 @@ static int _rtl8821ae_set_media_status(struct ieee80211_hw *hw,
 			 "Set Network type to AP!\n");
 		break;
 	default:
-		RT_TRACE(rtlpriv, COMP_ERR, DBG_EMERG,
-			 "Network type %d not support!\n", type);
+		pr_err("Network type %d not support!\n", type);
 		return 1;
 	}
 
@@ -3274,7 +3272,7 @@ void rtl8821ae_read_eeprom_info(struct ieee80211_hw *hw)
 		rtlefuse->autoload_failflag = false;
 		_rtl8821ae_read_adapter_info(hw, false);
 	} else {
-		RT_TRACE(rtlpriv, COMP_ERR, DBG_EMERG, "Autoload ERR!!\n");
+		pr_err("Autoload ERR!!\n");
 	}
 	/*hal_ReadRFType_8812A()*/
 	/* _rtl8821ae_hal_customized_behavior(hw); */
@@ -3949,8 +3947,7 @@ void rtl8821ae_set_key(struct ieee80211_hw *hw, u32 key_index,
 				if (mac->opmode == NL80211_IFTYPE_AP) {
 					entry_id = rtl_cam_get_free_entry(hw, p_macaddr);
 					if (entry_id >=  TOTAL_CAM_ENTRY) {
-						RT_TRACE(rtlpriv, COMP_SEC, DBG_EMERG,
-							 "Can not find free hwsecurity cam entry\n");
+						pr_err("an not find free hwsecurity cam entry\n");
 						return;
 					}
 				} else {
diff --git a/drivers/net/wireless/realtek/rtlwifi/rtl8821ae/phy.c b/drivers/net/wireless/realtek/rtlwifi/rtl8821ae/phy.c
index bd1a546..42c2802 100644
--- a/drivers/net/wireless/realtek/rtlwifi/rtl8821ae/phy.c
+++ b/drivers/net/wireless/realtek/rtlwifi/rtl8821ae/phy.c
@@ -215,7 +215,6 @@ void rtl8821ae_phy_set_rf_reg(struct ieee80211_hw *hw,
 static u32 _rtl8821ae_phy_rf_serial_read(struct ieee80211_hw *hw,
 					 enum radio_path rfpath, u32 offset)
 {
-	struct rtl_priv *rtlpriv = rtl_priv(hw);
 	struct rtl_hal *rtlhal = rtl_hal(rtl_priv(hw));
 	bool is_pi_mode = false;
 	u32 retvalue = 0;
@@ -223,7 +222,7 @@ static u32 _rtl8821ae_phy_rf_serial_read(struct ieee80211_hw *hw,
 	/* 2009/06/17 MH We can not execute IO for power
 	save or other accident mode.*/
 	if (RT_CANNOT_IO(hw)) {
-		RT_TRACE(rtlpriv, COMP_ERR, DBG_EMERG, "return all one\n");
+		pr_err("return all one\n");
 		return 0xFFFFFFFF;
 	}
 	/* <20120809, Kordan> CCA OFF(when entering),
@@ -284,7 +283,7 @@ static void _rtl8821ae_phy_rf_serial_write(struct ieee80211_hw *hw,
 	u32 newoffset;
 
 	if (RT_CANNOT_IO(hw)) {
-		RT_TRACE(rtlpriv, COMP_ERR, DBG_EMERG, "stop\n");
+		pr_err("stop\n");
 		return;
 	}
 	offset &= 0xff;
@@ -1665,7 +1664,7 @@ static bool _rtl8821ae_phy_bb8821a_config_parafile(struct ieee80211_hw *hw)
 	rtstatus = _rtl8821ae_phy_config_bb_with_headerfile(hw,
 						       BASEBAND_CONFIG_PHY_REG);
 	if (rtstatus != true) {
-		RT_TRACE(rtlpriv, COMP_ERR, DBG_EMERG, "Write BB Reg Fail!!\n");
+		pr_err("Write BB Reg Fail!!\n");
 		return false;
 	}
 	_rtl8821ae_phy_init_tx_power_by_rate(hw);
@@ -1674,7 +1673,7 @@ static bool _rtl8821ae_phy_bb8821a_config_parafile(struct ieee80211_hw *hw)
 						    BASEBAND_CONFIG_PHY_REG);
 	}
 	if (rtstatus != true) {
-		RT_TRACE(rtlpriv, COMP_ERR, DBG_EMERG, "BB_PG Reg Fail!!\n");
+		pr_err("BB_PG Reg Fail!!\n");
 		return false;
 	}
 
@@ -1688,7 +1687,7 @@ static bool _rtl8821ae_phy_bb8821a_config_parafile(struct ieee80211_hw *hw)
 						BASEBAND_CONFIG_AGC_TAB);
 
 	if (rtstatus != true) {
-		RT_TRACE(rtlpriv, COMP_ERR, DBG_EMERG, "AGC Table Fail\n");
+		pr_err("AGC Table Fail\n");
 		return false;
 	}
 	rtlphy->cck_high_power = (bool)(rtl_get_bbreg(hw,
@@ -2064,8 +2063,7 @@ bool rtl8812ae_phy_config_rf_with_headerfile(struct ieee80211_hw *hw,
 		break;
 	case RF90_PATH_C:
 	case RF90_PATH_D:
-		RT_TRACE(rtlpriv, COMP_ERR, DBG_EMERG,
-			 "switch case %#x not processed\n", rfpath);
+		pr_err("switch case %#x not processed\n", rfpath);
 		break;
 	}
 	return true;
@@ -2132,8 +2130,7 @@ bool rtl8821ae_phy_config_rf_with_headerfile(struct ieee80211_hw *hw,
 	case RF90_PATH_B:
 	case RF90_PATH_C:
 	case RF90_PATH_D:
-		RT_TRACE(rtlpriv, COMP_ERR, DBG_EMERG,
-			 "switch case %#x not processed\n", rfpath);
+		pr_err("switch case %#x not processed\n", rfpath);
 		break;
 	}
 	return true;
@@ -3336,8 +3333,7 @@ void rtl8821ae_phy_scan_operation_backup(struct ieee80211_hw *hw, u8 operation)
 						      (u8 *)&iotype);
 			break;
 		default:
-			RT_TRACE(rtlpriv, COMP_ERR, DBG_EMERG,
-				 "Unknown Scan Backup operation.\n");
+			pr_err("Unknown Scan Backup operation.\n");
 			break;
 		}
 	}
@@ -3378,8 +3374,7 @@ static u8 _rtl8821ae_phy_get_secondary_chnl(struct rtl_priv *rtlpriv)
 		else if (mac->cur_80_prime_sc == PRIME_CHNL_OFFSET_UPPER)
 			sc_set_40 = VHT_DATA_SC_40_UPPER_OF_80MHZ;
 		else
-			RT_TRACE(rtlpriv, COMP_ERR, DBG_EMERG,
-				"SCMapping: Not Correct Primary40MHz Setting\n");
+			pr_err("SCMapping: Not Correct Primary40MHz Setting\n");
 
 		if ((mac->cur_40_prime_sc == PRIME_CHNL_OFFSET_LOWER) &&
 			(mac->cur_80_prime_sc == HAL_PRIME_CHNL_OFFSET_LOWER))
@@ -3394,16 +3389,14 @@ static u8 _rtl8821ae_phy_get_secondary_chnl(struct rtl_priv *rtlpriv)
 			(mac->cur_80_prime_sc == HAL_PRIME_CHNL_OFFSET_UPPER))
 			sc_set_20 = VHT_DATA_SC_20_UPPERST_OF_80MHZ;
 		else
-			RT_TRACE(rtlpriv, COMP_ERR, DBG_EMERG,
-				"SCMapping: Not Correct Primary40MHz Setting\n");
+			pr_err("SCMapping: Not Correct Primary40MHz Setting\n");
 	} else if (rtlphy->current_chan_bw == HT_CHANNEL_WIDTH_20_40) {
 		if (mac->cur_40_prime_sc == PRIME_CHNL_OFFSET_UPPER)
 			sc_set_20 = VHT_DATA_SC_20_UPPER_OF_80MHZ;
 		else if (mac->cur_40_prime_sc == PRIME_CHNL_OFFSET_LOWER)
 			sc_set_20 = VHT_DATA_SC_20_LOWER_OF_80MHZ;
 		else
-			RT_TRACE(rtlpriv, COMP_ERR, DBG_EMERG,
-			 "SCMapping: Not Correct Primary40MHz Setting\n");
+			pr_err("SCMapping: Not Correct Primary40MHz Setting\n");
 	}
 	return (sc_set_40 << 4) | sc_set_20;
 }
@@ -3479,8 +3472,8 @@ void rtl8821ae_phy_set_bw_mode_callback(struct ieee80211_hw *hw)
 
 		break;
 	default:
-		RT_TRACE(rtlpriv, COMP_ERR, DBG_EMERG,
-			 "unknown bandwidth: %#X\n", rtlphy->current_chan_bw);
+		pr_err("unknown bandwidth: %#X\n",
+		       rtlphy->current_chan_bw);
 		break;
 	}
 
@@ -4660,8 +4652,8 @@ bool rtl8821ae_phy_set_io_cmd(struct ieee80211_hw *hw, enum io_type iotype)
 			postprocessing = true;
 			break;
 		default:
-			RT_TRACE(rtlpriv, COMP_ERR, DBG_EMERG,
-				 "switch case %#x not processed\n", iotype);
+			pr_err("switch case %#x not processed\n",
+			       iotype);
 			break;
 		}
 	} while (false);
@@ -4704,9 +4695,8 @@ static void rtl8821ae_phy_set_io(struct ieee80211_hw *hw)
 	case IO_CMD_PAUSE_BAND1_DM_BY_SCAN:
 		break;
 	default:
-		RT_TRACE(rtlpriv, COMP_ERR, DBG_EMERG,
-			 "switch case %#x not processed\n",
-			 rtlphy->current_io_type);
+		pr_err("switch case %#x not processed\n",
+		       rtlphy->current_io_type);
 		break;
 	}
 	rtlphy->set_io_inprogress = false;
@@ -4811,8 +4801,8 @@ static bool _rtl8821ae_phy_set_rf_power_state(struct ieee80211_hw *hw,
 		}
 		break;
 	default:
-		RT_TRACE(rtlpriv, COMP_ERR, DBG_EMERG,
-			 "switch case %#x not processed\n", rfpwr_state);
+		pr_err("switch case %#x not processed\n",
+		       rfpwr_state);
 		bresult = false;
 		break;
 	}
diff --git a/drivers/net/wireless/realtek/rtlwifi/rtl8821ae/rf.c b/drivers/net/wireless/realtek/rtlwifi/rtl8821ae/rf.c
index c6ab957..95489f4 100644
--- a/drivers/net/wireless/realtek/rtlwifi/rtl8821ae/rf.c
+++ b/drivers/net/wireless/realtek/rtlwifi/rtl8821ae/rf.c
@@ -34,8 +34,6 @@ static bool _rtl8821ae_phy_rf6052_config_parafile(struct ieee80211_hw *hw);
 
 void rtl8821ae_phy_rf6052_set_bandwidth(struct ieee80211_hw *hw, u8 bandwidth)
 {
-	struct rtl_priv *rtlpriv = rtl_priv(hw);
-
 	switch (bandwidth) {
 	case HT_CHANNEL_WIDTH_20:
 		rtl_set_rfreg(hw, RF90_PATH_A, RF_CHNLBW, BIT(11)|BIT(10), 3);
@@ -50,8 +48,7 @@ void rtl8821ae_phy_rf6052_set_bandwidth(struct ieee80211_hw *hw, u8 bandwidth)
 		rtl_set_rfreg(hw, RF90_PATH_B, RF_CHNLBW, BIT(11)|BIT(10), 0);
 		break;
 	default:
-		RT_TRACE(rtlpriv, COMP_ERR, DBG_EMERG,
-			 "unknown bandwidth: %#X\n", bandwidth);
+		pr_err("unknown bandwidth: %#X\n", bandwidth);
 		break;
 	}
 }
diff --git a/drivers/net/wireless/realtek/rtlwifi/rtl8821ae/sw.c b/drivers/net/wireless/realtek/rtlwifi/rtl8821ae/sw.c
index 297938e..8ec7ab2 100644
--- a/drivers/net/wireless/realtek/rtlwifi/rtl8821ae/sw.c
+++ b/drivers/net/wireless/realtek/rtlwifi/rtl8821ae/sw.c
@@ -192,14 +192,12 @@ int rtl8821ae_init_sw_vars(struct ieee80211_hw *hw)
 	/* for firmware buf */
 	rtlpriv->rtlhal.pfirmware = vzalloc(0x8000);
 	if (!rtlpriv->rtlhal.pfirmware) {
-		RT_TRACE(rtlpriv, COMP_ERR, DBG_EMERG,
-			 "Can't alloc buffer for fw.\n");
+		pr_err("Can't alloc buffer for fw.\n");
 		return 1;
 	}
 	rtlpriv->rtlhal.wowlan_firmware = vzalloc(0x8000);
 	if (!rtlpriv->rtlhal.wowlan_firmware) {
-		RT_TRACE(rtlpriv, COMP_ERR, DBG_EMERG,
-			 "Can't alloc buffer for wowlan fw.\n");
+		pr_err("Can't alloc buffer for wowlan fw.\n");
 		return 1;
 	}
 
@@ -218,8 +216,7 @@ int rtl8821ae_init_sw_vars(struct ieee80211_hw *hw)
 				      rtlpriv->io.dev, GFP_KERNEL, hw,
 				      rtl_fw_cb);
 	if (err) {
-		RT_TRACE(rtlpriv, COMP_ERR, DBG_EMERG,
-			 "Failed to request normal firmware!\n");
+		pr_err("Failed to request normal firmware!\n");
 		return 1;
 	}
 	/*load wowlan firmware*/
@@ -229,8 +226,7 @@ int rtl8821ae_init_sw_vars(struct ieee80211_hw *hw)
 				      rtlpriv->io.dev, GFP_KERNEL, hw,
 				      rtl_wowlan_fw_cb);
 	if (err) {
-		RT_TRACE(rtlpriv, COMP_ERR, DBG_EMERG,
-			 "Failed to request wowlan firmware!\n");
+		pr_err("Failed to request wowlan firmware!\n");
 		return 1;
 	}
 	return 0;
@@ -313,7 +309,7 @@ static struct rtl_mod_params rtl8821ae_mod_params = {
 	.fwctrl_lps = true,
 	.msi_support = true,
 	.int_clear = true,
-	.debug = DBG_EMERG,
+	.debug = 0,
 	.disable_watchdog = 0,
 };
 
-- 
2.10.2
