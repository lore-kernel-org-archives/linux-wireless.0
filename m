Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-oi0-f67.google.com ([209.85.218.67]:34674 "EHLO
        mail-oi0-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752758AbcLKFpm (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Sun, 11 Dec 2016 00:45:42 -0500
Received: by mail-oi0-f67.google.com with SMTP id m75so7285725oig.1
        for <linux-wireless@vger.kernel.org>; Sat, 10 Dec 2016 21:45:42 -0800 (PST)
From: Larry Finger <Larry.Finger@lwfinger.net>
To: kvalo@codeaurora.org
Cc: devel@driverdev.osuosl.org, linux-wireless@vger.kernel.org,
        Larry Finger <Larry.Finger@lwfinger.net>,
        Ping-Ke Shih <pkshih@realtek.com>
Subject: [PATCH 06/14] rtlwifi_new: rtl8192ee: Remove all instances of DBG_EMERG
Date: Sat, 10 Dec 2016 23:45:07 -0600
Message-Id: <20161211054523.7119-11-Larry.Finger@lwfinger.net> (sfid-20161211_070932_334341_5022354C)
In-Reply-To: <20161211054523.7119-1-Larry.Finger@lwfinger.net>
References: <20161211054523.7119-1-Larry.Finger@lwfinger.net>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This is a step toward eliminating the RT_TRACE macros. Those calls that
have DBG_EMERG as the level are always logged, and they represent error
conditions, thus they are replaced with pr_err().

Signed-off-by: Larry Finger <Larry.Finger@lwfinger.net>
Cc: Ping-Ke Shih <pkshih@realtek.com>
---
 .../net/wireless/realtek/rtlwifi/rtl8192ee/fw.c    | 21 ++++++++-------------
 .../net/wireless/realtek/rtlwifi/rtl8192ee/hw.c    | 11 ++++-------
 .../net/wireless/realtek/rtlwifi/rtl8192ee/phy.c   | 22 +++++++++-------------
 .../net/wireless/realtek/rtlwifi/rtl8192ee/rf.c    |  3 +--
 .../net/wireless/realtek/rtlwifi/rtl8192ee/sw.c    |  8 +++-----
 5 files changed, 25 insertions(+), 40 deletions(-)

diff --git a/drivers/net/wireless/realtek/rtlwifi/rtl8192ee/fw.c b/drivers/net/wireless/realtek/rtlwifi/rtl8192ee/fw.c
index 9dfd74b..2959746 100644
--- a/drivers/net/wireless/realtek/rtlwifi/rtl8192ee/fw.c
+++ b/drivers/net/wireless/realtek/rtlwifi/rtl8192ee/fw.c
@@ -122,10 +122,8 @@ static void _rtl92ee_write_fw(struct ieee80211_hw *hw,
 	pagenums = size / FW_8192C_PAGE_SIZE;
 	remainsize = size % FW_8192C_PAGE_SIZE;
 
-	if (pagenums > 8) {
-		RT_TRACE(rtlpriv, COMP_ERR, DBG_EMERG,
-			 "Page numbers should not greater then 8\n");
-	}
+	if (pagenums > 8)
+		pr_err("Page numbers should not greater then 8\n");
 
 	for (page = 0; page < pagenums; page++) {
 		offset = page * FW_8192C_PAGE_SIZE;
@@ -155,14 +153,13 @@ static int _rtl92ee_fw_free_to_go(struct ieee80211_hw *hw)
 		 (!(value32 & FWDL_CHKSUM_RPT)));
 
 	if (counter >= FW_8192C_POLLING_TIMEOUT_COUNT) {
-		RT_TRACE(rtlpriv, COMP_ERR, DBG_EMERG,
-			 "chksum report faill ! REG_MCUFWDL:0x%08x .\n",
-			  value32);
+		pr_err("chksum report fail! REG_MCUFWDL:0x%08x\n",
+		       value32);
 		goto exit;
 	}
 
 	RT_TRACE(rtlpriv, COMP_FW, DBG_TRACE,
-		 "Checksum report OK ! REG_MCUFWDL:0x%08x .\n", value32);
+		 "Checksum report OK! REG_MCUFWDL:0x%08x\n", value32);
 
 	value32 = rtl_read_dword(rtlpriv, REG_MCUFWDL);
 	value32 |= MCUFWDL_RDY;
@@ -186,9 +183,8 @@ static int _rtl92ee_fw_free_to_go(struct ieee80211_hw *hw)
 
 	} while (counter++ < FW_8192C_POLLING_TIMEOUT_COUNT);
 
-	RT_TRACE(rtlpriv, COMP_ERR, DBG_EMERG,
-		 "Polling FW ready fail!! REG_MCUFWDL:0x%08x. count = %d\n",
-		 value32, counter);
+	pr_err("Polling FW ready fail!! REG_MCUFWDL:0x%08x. count = %d\n",
+	       value32, counter);
 
 exit:
 	return err;
@@ -241,8 +237,7 @@ int rtl92ee_download_fw(struct ieee80211_hw *hw, bool buse_wake_on_wlan_fw)
 
 	err = _rtl92ee_fw_free_to_go(hw);
 	if (err) {
-		RT_TRACE(rtlpriv, COMP_ERR, DBG_EMERG,
-			 "Firmware is not ready to run!\n");
+		pr_err("Firmware is not ready to run!\n");
 	} else {
 		RT_TRACE(rtlpriv, COMP_FW, DBG_LOUD ,
 			 "Firmware is ready to run!\n");
diff --git a/drivers/net/wireless/realtek/rtlwifi/rtl8192ee/hw.c b/drivers/net/wireless/realtek/rtlwifi/rtl8192ee/hw.c
index 00b211b..f731f96 100644
--- a/drivers/net/wireless/realtek/rtlwifi/rtl8192ee/hw.c
+++ b/drivers/net/wireless/realtek/rtlwifi/rtl8192ee/hw.c
@@ -1320,7 +1320,7 @@ int rtl92ee_hw_init(struct ieee80211_hw *hw)
 		rtl_write_byte(rtlpriv, 0x65, 1);
 	}
 	if (!rtstatus) {
-		RT_TRACE(rtlpriv, COMP_ERR, DBG_EMERG, "Init MAC failed\n");
+		pr_err("Init MAC failed\n");
 		err = 1;
 		return err;
 	}
@@ -1485,8 +1485,7 @@ static int _rtl92ee_set_media_status(struct ieee80211_hw *hw,
 			 "Set Network type to AP!\n");
 		break;
 	default:
-		RT_TRACE(rtlpriv, COMP_ERR, DBG_EMERG,
-			 "Network type %d not support!\n", type);
+		pr_err("Network type %d not support!\n", type);
 		return 1;
 	}
 
@@ -2206,7 +2205,7 @@ void rtl92ee_read_eeprom_info(struct ieee80211_hw *hw)
 		rtlefuse->autoload_failflag = false;
 		_rtl92ee_read_adapter_info(hw);
 	} else {
-		RT_TRACE(rtlpriv, COMP_ERR, DBG_EMERG, "Autoload ERR!!\n");
+		pr_err("Autoload ERR!!\n");
 	}
 	_rtl92ee_hal_customized_behavior(hw);
 
@@ -2484,9 +2483,7 @@ void rtl92ee_set_key(struct ieee80211_hw *hw, u32 key_index,
 					entry_id = rtl_cam_get_free_entry(hw,
 								     p_macaddr);
 					if (entry_id >=  TOTAL_CAM_ENTRY) {
-						RT_TRACE(rtlpriv, COMP_SEC,
-							 DBG_EMERG,
-							 "Can not find free hw security cam entry\n");
+						pr_err("Can not find free hw security cam entry\n");
 						return;
 					}
 				} else {
diff --git a/drivers/net/wireless/realtek/rtlwifi/rtl8192ee/phy.c b/drivers/net/wireless/realtek/rtlwifi/rtl8192ee/phy.c
index c35ba76..9ced157 100644
--- a/drivers/net/wireless/realtek/rtlwifi/rtl8192ee/phy.c
+++ b/drivers/net/wireless/realtek/rtlwifi/rtl8192ee/phy.c
@@ -170,7 +170,7 @@ static u32 _rtl92ee_phy_rf_serial_read(struct ieee80211_hw *hw,
 	offset &= 0xff;
 	newoffset = offset;
 	if (RT_CANNOT_IO(hw)) {
-		RT_TRACE(rtlpriv, COMP_ERR, DBG_EMERG, "return all one\n");
+		pr_err("return all one\n");
 		return 0xFFFFFFFF;
 	}
 	tmplong = rtl_get_bbreg(hw, RFPGA0_XA_HSSIPARAMETER2, MASKDWORD);
@@ -214,7 +214,7 @@ static void _rtl92ee_phy_rf_serial_write(struct ieee80211_hw *hw,
 	struct bb_reg_def *pphyreg = &rtlphy->phyreg_def[rfpath];
 
 	if (RT_CANNOT_IO(hw)) {
-		RT_TRACE(rtlpriv, COMP_ERR, DBG_EMERG, "stop\n");
+		pr_err("stop\n");
 		return;
 	}
 	offset &= 0xff;
@@ -650,7 +650,7 @@ static bool _rtl92ee_phy_bb8192ee_config_parafile(struct ieee80211_hw *hw)
 
 	rtstatus = phy_config_bb_with_hdr_file(hw, BASEBAND_CONFIG_PHY_REG);
 	if (!rtstatus) {
-		RT_TRACE(rtlpriv, COMP_ERR, DBG_EMERG, "Write BB Reg Fail!!\n");
+		pr_err("Write BB Reg Fail!!\n");
 		return false;
 	}
 
@@ -662,12 +662,12 @@ static bool _rtl92ee_phy_bb8192ee_config_parafile(struct ieee80211_hw *hw)
 	}
 	_rtl92ee_phy_txpower_by_rate_configuration(hw);
 	if (!rtstatus) {
-		RT_TRACE(rtlpriv, COMP_ERR, DBG_EMERG, "BB_PG Reg Fail!!\n");
+		pr_err("BB_PG Reg Fail!!\n");
 		return false;
 	}
 	rtstatus = phy_config_bb_with_hdr_file(hw, BASEBAND_CONFIG_AGC_TAB);
 	if (!rtstatus) {
-		RT_TRACE(rtlpriv, COMP_ERR, DBG_EMERG, "AGC Table Fail\n");
+		pr_err("AGC Table Fail\n");
 		return false;
 	}
 	rtlphy->cck_high_power = (bool)(rtl_get_bbreg(hw,
@@ -1675,8 +1675,7 @@ void rtl92ee_phy_scan_operation_backup(struct ieee80211_hw *hw, u8 operation)
 						      (u8 *)&iotype);
 			break;
 		default:
-			RT_TRACE(rtlpriv, COMP_ERR, DBG_EMERG,
-				 "Unknown Scan Backup operation.\n");
+			pr_err("Unknown Scan Backup operation.\n");
 			break;
 		}
 	}
@@ -1717,8 +1716,7 @@ void rtl92ee_phy_set_bw_mode_callback(struct ieee80211_hw *hw)
 		rtl_write_byte(rtlpriv, REG_RRSR + 2, reg_prsr_rsc);
 		break;
 	default:
-		RT_TRACE(rtlpriv, COMP_ERR, DBG_EMERG,
-			 "unknown bandwidth: %#X\n", rtlphy->current_chan_bw);
+		pr_err("unknown bandwidth: %#X\n", rtlphy->current_chan_bw);
 		break;
 	}
 
@@ -1742,8 +1740,7 @@ void rtl92ee_phy_set_bw_mode_callback(struct ieee80211_hw *hw)
 			       HAL_PRIME_CHNL_OFFSET_LOWER) ? 2 : 1);
 		break;
 	default:
-		RT_TRACE(rtlpriv, COMP_ERR, DBG_EMERG,
-			 "unknown bandwidth: %#X\n", rtlphy->current_chan_bw);
+		pr_err("unknown bandwidth: %#X\n", rtlphy->current_chan_bw);
 		break;
 	}
 	rtl92ee_phy_rf6052_set_bandwidth(hw, rtlphy->current_chan_bw);
@@ -1884,8 +1881,7 @@ static bool _rtl92ee_phy_sw_chnl_step_by_step(struct ieee80211_hw *hw,
 			currentcmd = &postcommoncmd[*step];
 			break;
 		default:
-			RT_TRACE(rtlpriv, COMP_ERR, DBG_EMERG,
-				 "Invalid 'stage' = %d, Check it!\n" , *stage);
+			pr_err("Invalid 'stage' = %d, Check it!\n", *stage);
 			return true;
 		}
 
diff --git a/drivers/net/wireless/realtek/rtlwifi/rtl8192ee/rf.c b/drivers/net/wireless/realtek/rtlwifi/rtl8192ee/rf.c
index 73716c0..bc76a91 100644
--- a/drivers/net/wireless/realtek/rtlwifi/rtl8192ee/rf.c
+++ b/drivers/net/wireless/realtek/rtlwifi/rtl8192ee/rf.c
@@ -55,8 +55,7 @@ void rtl92ee_phy_rf6052_set_bandwidth(struct ieee80211_hw *hw, u8 bandwidth)
 			      rtlphy->rfreg_chnlval[0]);
 		break;
 	default:
-		RT_TRACE(rtlpriv, COMP_ERR, DBG_EMERG,
-			 "unknown bandwidth: %#X\n", bandwidth);
+		pr_err("unknown bandwidth: %#X\n", bandwidth);
 		break;
 	}
 }
diff --git a/drivers/net/wireless/realtek/rtlwifi/rtl8192ee/sw.c b/drivers/net/wireless/realtek/rtlwifi/rtl8192ee/sw.c
index 46b605de3..eddc704 100644
--- a/drivers/net/wireless/realtek/rtlwifi/rtl8192ee/sw.c
+++ b/drivers/net/wireless/realtek/rtlwifi/rtl8192ee/sw.c
@@ -165,8 +165,7 @@ int rtl92ee_init_sw_vars(struct ieee80211_hw *hw)
 	/* for firmware buf */
 	rtlpriv->rtlhal.pfirmware = vzalloc(0x8000);
 	if (!rtlpriv->rtlhal.pfirmware) {
-		RT_TRACE(rtlpriv, COMP_ERR, DBG_EMERG,
-			 "Can't alloc buffer for fw\n");
+		pr_err("Can't alloc buffer for fw\n");
 		return 1;
 	}
 
@@ -179,8 +178,7 @@ int rtl92ee_init_sw_vars(struct ieee80211_hw *hw)
 				      rtlpriv->io.dev, GFP_KERNEL, hw,
 				      rtl_fw_cb);
 	if (err) {
-		RT_TRACE(rtlpriv, COMP_ERR, DBG_EMERG,
-			 "Failed to request firmware!\n");
+		pr_err("Failed to request firmware!\n");
 		return 1;
 	}
 
@@ -260,7 +258,7 @@ static struct rtl_mod_params rtl92ee_mod_params = {
 	.swctrl_lps = false,
 	.fwctrl_lps = true,
 	.msi_support = true,
-	.debug = DBG_EMERG,
+	.debug = 0,
 };
 
 static const struct rtl_hal_cfg rtl92ee_hal_cfg = {
-- 
2.10.2
