Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-oi0-f67.google.com ([209.85.218.67]:33592 "EHLO
        mail-oi0-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752275AbcLKFpj (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Sun, 11 Dec 2016 00:45:39 -0500
Received: by mail-oi0-f67.google.com with SMTP id f201so7294114oib.0
        for <linux-wireless@vger.kernel.org>; Sat, 10 Dec 2016 21:45:39 -0800 (PST)
From: Larry Finger <Larry.Finger@lwfinger.net>
To: kvalo@codeaurora.org
Cc: devel@driverdev.osuosl.org, linux-wireless@vger.kernel.org,
        Larry Finger <Larry.Finger@lwfinger.net>,
        Ping-Ke Shih <pkshih@realtek.com>
Subject: [PATCH 04/14] rtlwifi_new: rtl8723be: Remove all instances of DBG_EMERG
Date: Sat, 10 Dec 2016 23:45:03 -0600
Message-Id: <20161211054523.7119-7-Larry.Finger@lwfinger.net> (sfid-20161211_070933_223863_021BABED)
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
 drivers/net/wireless/realtek/rtlwifi/rtl8723be/fw.c  |  9 +++------
 drivers/net/wireless/realtek/rtlwifi/rtl8723be/hw.c  | 16 ++++++----------
 drivers/net/wireless/realtek/rtlwifi/rtl8723be/led.c |  6 ++----
 drivers/net/wireless/realtek/rtlwifi/rtl8723be/phy.c | 18 +++++++-----------
 drivers/net/wireless/realtek/rtlwifi/rtl8723be/rf.c  |  3 +--
 drivers/net/wireless/realtek/rtlwifi/rtl8723be/sw.c  |  8 +++-----
 6 files changed, 22 insertions(+), 38 deletions(-)

diff --git a/drivers/net/wireless/realtek/rtlwifi/rtl8723be/fw.c b/drivers/net/wireless/realtek/rtlwifi/rtl8723be/fw.c
index 6b03c7f..71d1e89 100644
--- a/drivers/net/wireless/realtek/rtlwifi/rtl8723be/fw.c
+++ b/drivers/net/wireless/realtek/rtlwifi/rtl8723be/fw.c
@@ -97,8 +97,7 @@ static void _rtl8723be_fill_h2c_command(struct ieee80211_hw *hw, u8 element_id,
 	while (!bwrite_sucess) {
 		wait_writeh2c_limmit--;
 		if (wait_writeh2c_limmit == 0) {
-			RT_TRACE(rtlpriv, COMP_ERR, DBG_EMERG,
-				 "Write H2C fail because no trigger for FW INT!\n");
+			pr_err("Write H2C fail because no trigger for FW INT!\n");
 			break;
 		}
 
@@ -121,8 +120,7 @@ static void _rtl8723be_fill_h2c_command(struct ieee80211_hw *hw, u8 element_id,
 			box_extreg = REG_HMEBOX_EXT_3;
 			break;
 		default:
-			RT_TRACE(rtlpriv, COMP_ERR, DBG_EMERG,
-				 "switch case %#x not processed\n", boxnum);
+			pr_err("switch case %#x not processed\n", boxnum);
 			break;
 		}
 
@@ -194,8 +192,7 @@ static void _rtl8723be_fill_h2c_command(struct ieee80211_hw *hw, u8 element_id,
 			}
 			break;
 		default:
-			RT_TRACE(rtlpriv, COMP_ERR, DBG_EMERG,
-				 "switch case %#x not processed\n", cmd_len);
+			pr_err("switch case %#x not processed\n", cmd_len);
 			break;
 		}
 
diff --git a/drivers/net/wireless/realtek/rtlwifi/rtl8723be/hw.c b/drivers/net/wireless/realtek/rtlwifi/rtl8723be/hw.c
index 56a1ae4..ae2a38e 100644
--- a/drivers/net/wireless/realtek/rtlwifi/rtl8723be/hw.c
+++ b/drivers/net/wireless/realtek/rtlwifi/rtl8723be/hw.c
@@ -747,9 +747,8 @@ static bool _rtl8723be_llt_write(struct ieee80211_hw *hw, u32 address, u32 data)
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
@@ -1383,7 +1382,7 @@ int rtl8723be_hw_init(struct ieee80211_hw *hw)
 	}
 	rtstatus = _rtl8723be_init_mac(hw);
 	if (!rtstatus) {
-		RT_TRACE(rtlpriv, COMP_ERR, DBG_EMERG, "Init MAC failed\n");
+		pr_err("Init MAC failed\n");
 		err = 1;
 		goto exit;
 	}
@@ -1532,8 +1531,7 @@ static int _rtl8723be_set_media_status(struct ieee80211_hw *hw,
 			 "Set Network type to AP!\n");
 		break;
 	default:
-		RT_TRACE(rtlpriv, COMP_ERR, DBG_EMERG,
-			 "Network type %d not support!\n", type);
+		pr_err("Network type %d not support!\n", type);
 		return 1;
 	}
 
@@ -2247,7 +2245,7 @@ void rtl8723be_read_eeprom_info(struct ieee80211_hw *hw)
 		rtlefuse->autoload_failflag = false;
 		_rtl8723be_read_adapter_info(hw, false);
 	} else {
-		RT_TRACE(rtlpriv, COMP_ERR, DBG_EMERG, "Autoload ERR!!\n");
+		pr_err("Autoload ERR!!\n");
 	}
 	_rtl8723be_hal_customized_behavior(hw);
 }
@@ -2584,9 +2582,7 @@ void rtl8723be_set_key(struct ieee80211_hw *hw, u32 key_index,
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
diff --git a/drivers/net/wireless/realtek/rtlwifi/rtl8723be/led.c b/drivers/net/wireless/realtek/rtlwifi/rtl8723be/led.c
index 497913e..193125b 100644
--- a/drivers/net/wireless/realtek/rtlwifi/rtl8723be/led.c
+++ b/drivers/net/wireless/realtek/rtlwifi/rtl8723be/led.c
@@ -57,8 +57,7 @@ void rtl8723be_sw_led_on(struct ieee80211_hw *hw, struct rtl_led *pled)
 		rtl_write_byte(rtlpriv, REG_LEDCFG1, ledcfg & 0x10);
 		break;
 	default:
-		RT_TRACE(rtlpriv, COMP_ERR, DBG_EMERG,
-			 "switch case %#x not processed\n", pled->ledpin);
+		pr_err("switch case %#x not processed\n", pled->ledpin);
 		break;
 	}
 	pled->ledon = true;
@@ -99,8 +98,7 @@ void rtl8723be_sw_led_off(struct ieee80211_hw *hw, struct rtl_led *pled)
 
 		break;
 	default:
-		RT_TRACE(rtlpriv, COMP_ERR, DBG_EMERG,
-			 "switch case %#x not processed\n", pled->ledpin);
+		pr_err("switch case %#x not processed\n", pled->ledpin);
 		break;
 	}
 	pled->ledon = false;
diff --git a/drivers/net/wireless/realtek/rtlwifi/rtl8723be/phy.c b/drivers/net/wireless/realtek/rtlwifi/rtl8723be/phy.c
index b4e0a58..8c2b497 100644
--- a/drivers/net/wireless/realtek/rtlwifi/rtl8723be/phy.c
+++ b/drivers/net/wireless/realtek/rtlwifi/rtl8723be/phy.c
@@ -467,7 +467,7 @@ static bool _rtl8723be_phy_bb8723b_config_parafile(struct ieee80211_hw *hw)
 	rtstatus = _rtl8723be_phy_config_bb_with_headerfile(hw,
 						BASEBAND_CONFIG_PHY_REG);
 	if (!rtstatus) {
-		RT_TRACE(rtlpriv, COMP_ERR, DBG_EMERG, "Write BB Reg Fail!!\n");
+		pr_err("Write BB Reg Fail!!\n");
 		return false;
 	}
 	_rtl8723be_phy_init_tx_power_by_rate(hw);
@@ -478,13 +478,13 @@ static bool _rtl8723be_phy_bb8723b_config_parafile(struct ieee80211_hw *hw)
 	}
 	phy_txpower_by_rate_config(hw);
 	if (!rtstatus) {
-		RT_TRACE(rtlpriv, COMP_ERR, DBG_EMERG, "BB_PG Reg Fail!!\n");
+		pr_err("BB_PG Reg Fail!!\n");
 		return false;
 	}
 	rtstatus = _rtl8723be_phy_config_bb_with_headerfile(hw,
 						BASEBAND_CONFIG_AGC_TAB);
 	if (!rtstatus) {
-		RT_TRACE(rtlpriv, COMP_ERR, DBG_EMERG, "AGC Table Fail\n");
+		pr_err("AGC Table Fail\n");
 		return false;
 	}
 	rtlphy->cck_high_power = (bool)(rtl_get_bbreg(hw,
@@ -1249,8 +1249,7 @@ void rtl8723be_phy_scan_operation_backup(struct ieee80211_hw *hw, u8 operation)
 						      (u8 *)&iotype);
 			break;
 		default:
-			RT_TRACE(rtlpriv, COMP_ERR, DBG_EMERG,
-				 "Unknown Scan Backup operation.\n");
+			pr_err("Unknown Scan Backup operation.\n");
 			break;
 		}
 	}
@@ -1291,8 +1290,7 @@ void rtl8723be_phy_set_bw_mode_callback(struct ieee80211_hw *hw)
 		rtl_write_byte(rtlpriv, REG_RRSR + 2, reg_prsr_rsc);
 		break;
 	default:
-		RT_TRACE(rtlpriv, COMP_ERR, DBG_EMERG,
-			 "unknown bandwidth: %#X\n", rtlphy->current_chan_bw);
+		pr_err("unknown bandwidth: %#X\n", rtlphy->current_chan_bw);
 		break;
 	}
 
@@ -1316,8 +1314,7 @@ void rtl8723be_phy_set_bw_mode_callback(struct ieee80211_hw *hw)
 			       HAL_PRIME_CHNL_OFFSET_LOWER) ? 2 : 1);
 		break;
 	default:
-		RT_TRACE(rtlpriv, COMP_ERR, DBG_EMERG,
-			 "unknown bandwidth: %#X\n", rtlphy->current_chan_bw);
+		pr_err("unknown bandwidth: %#X\n", rtlphy->current_chan_bw);
 		break;
 	}
 	rtl8723be_phy_rf6052_set_bandwidth(hw, rtlphy->current_chan_bw);
@@ -1462,8 +1459,7 @@ static bool _rtl8723be_phy_sw_chnl_step_by_step(struct ieee80211_hw *hw,
 			currentcmd = &postcommoncmd[*step];
 			break;
 		default:
-			RT_TRACE(rtlpriv, COMP_ERR, DBG_EMERG,
-				 "Invalid 'stage' = %d, Check it!\n", *stage);
+			pr_err("Invalid 'stage' = %d, Check it!\n", *stage);
 			return true;
 		}
 
diff --git a/drivers/net/wireless/realtek/rtlwifi/rtl8723be/rf.c b/drivers/net/wireless/realtek/rtlwifi/rtl8723be/rf.c
index 78f4f18..4849145 100644
--- a/drivers/net/wireless/realtek/rtlwifi/rtl8723be/rf.c
+++ b/drivers/net/wireless/realtek/rtlwifi/rtl8723be/rf.c
@@ -51,8 +51,7 @@ void rtl8723be_phy_rf6052_set_bandwidth(struct ieee80211_hw *hw, u8 bandwidth)
 			      rtlphy->rfreg_chnlval[0]);
 		break;
 	default:
-		RT_TRACE(rtlpriv, COMP_ERR, DBG_EMERG,
-			 "unknown bandwidth: %#X\n", bandwidth);
+		pr_err("unknown bandwidth: %#X\n", bandwidth);
 		break;
 	}
 }
diff --git a/drivers/net/wireless/realtek/rtlwifi/rtl8723be/sw.c b/drivers/net/wireless/realtek/rtlwifi/rtl8723be/sw.c
index 847644d..dd42c1a 100644
--- a/drivers/net/wireless/realtek/rtlwifi/rtl8723be/sw.c
+++ b/drivers/net/wireless/realtek/rtlwifi/rtl8723be/sw.c
@@ -179,8 +179,7 @@ int rtl8723be_init_sw_vars(struct ieee80211_hw *hw)
 	/* for firmware buf */
 	rtlpriv->rtlhal.pfirmware = vzalloc(0x8000);
 	if (!rtlpriv->rtlhal.pfirmware) {
-		RT_TRACE(rtlpriv, COMP_ERR, DBG_EMERG,
-			 "Can't alloc buffer for fw.\n");
+		pr_err("Can't alloc buffer for fw.\n");
 		return 1;
 	}
 
@@ -190,8 +189,7 @@ int rtl8723be_init_sw_vars(struct ieee80211_hw *hw)
 				      rtlpriv->io.dev, GFP_KERNEL, hw,
 				      rtl_fw_cb);
 	if (err) {
-		RT_TRACE(rtlpriv, COMP_ERR, DBG_EMERG,
-			 "Failed to request firmware!\n");
+		pr_err("Failed to request firmware!\n");
 		return 1;
 	}
 	return 0;
@@ -273,7 +271,7 @@ static struct rtl_mod_params rtl8723be_mod_params = {
 	.fwctrl_lps = true,
 	.msi_support = false,
 	.disable_watchdog = false,
-	.debug = DBG_EMERG,
+	.debug = 0,
 	.ant_sel = 0,
 };
 
-- 
2.10.2
