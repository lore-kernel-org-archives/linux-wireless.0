Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-oi0-f67.google.com ([209.85.218.67]:35028 "EHLO
        mail-oi0-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753152AbcLKFpv (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Sun, 11 Dec 2016 00:45:51 -0500
Received: by mail-oi0-f67.google.com with SMTP id v84so7251888oie.2
        for <linux-wireless@vger.kernel.org>; Sat, 10 Dec 2016 21:45:50 -0800 (PST)
From: Larry Finger <Larry.Finger@lwfinger.net>
To: kvalo@codeaurora.org
Cc: devel@driverdev.osuosl.org, linux-wireless@vger.kernel.org,
        Larry Finger <Larry.Finger@lwfinger.net>,
        Ping-Ke Shih <pkshih@realtek.com>
Subject: [PATCH 11/14] rtlwifi: rtl8192ce: Remove all instances of DBG_EMERG
Date: Sat, 10 Dec 2016 23:45:18 -0600
Message-Id: <20161211054523.7119-22-Larry.Finger@lwfinger.net> (sfid-20161211_070932_622735_8FFA2072)
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
 .../net/wireless/realtek/rtlwifi/rtl8192ce/hw.c    | 36 ++++++++--------------
 .../net/wireless/realtek/rtlwifi/rtl8192ce/led.c   |  6 ++--
 .../net/wireless/realtek/rtlwifi/rtl8192ce/phy.c   | 13 +++-----
 .../net/wireless/realtek/rtlwifi/rtl8192ce/rf.c    |  3 +-
 .../net/wireless/realtek/rtlwifi/rtl8192ce/sw.c    |  8 ++---
 5 files changed, 24 insertions(+), 42 deletions(-)

diff --git a/drivers/net/wireless/realtek/rtlwifi/rtl8192ce/hw.c b/drivers/net/wireless/realtek/rtlwifi/rtl8192ce/hw.c
index ce07e5c..410d48bf 100644
--- a/drivers/net/wireless/realtek/rtlwifi/rtl8192ce/hw.c
+++ b/drivers/net/wireless/realtek/rtlwifi/rtl8192ce/hw.c
@@ -140,8 +140,7 @@ void rtl92ce_get_hw_reg(struct ieee80211_hw *hw, u8 variable, u8 *val)
 	case HAL_DEF_WOWLAN:
 		break;
 	default:
-		RT_TRACE(rtlpriv, COMP_ERR, DBG_EMERG,
-			 "switch case %#x not processed\n", variable);
+		pr_err("rtl8192ce: switch case %#x not processed\n", variable);
 		break;
 	}
 }
@@ -364,9 +363,8 @@ void rtl92ce_set_hw_reg(struct ieee80211_hw *hw, u8 variable, u8 *val)
 					acm_ctrl &= (~AcmHw_VoqEn);
 					break;
 				default:
-					RT_TRACE(rtlpriv, COMP_ERR, DBG_EMERG,
-						 "switch case %#x not processed\n",
-						 e_aci);
+					pr_err("rtl8192ce: switch case %#x not processed\n",
+					       e_aci);
 					break;
 				}
 			}
@@ -551,8 +549,7 @@ void rtl92ce_set_hw_reg(struct ieee80211_hw *hw, u8 variable, u8 *val)
 		rtl92c_fill_h2c_cmd(hw, H2C_92C_KEEP_ALIVE_CTRL, 2, array);
 		break; }
 	default:
-		RT_TRACE(rtlpriv, COMP_ERR, DBG_EMERG,
-			 "switch case %d not processed\n", variable);
+		pr_err("rtl8192ce: switch case %d not processed\n", variable);
 		break;
 	}
 }
@@ -573,9 +570,8 @@ static bool _rtl92ce_llt_write(struct ieee80211_hw *hw, u32 address, u32 data)
 			break;
 
 		if (count > POLLING_LLT_THRESHOLD) {
-			RT_TRACE(rtlpriv, COMP_ERR, DBG_EMERG,
-				 "Failed to polling write LLT done at address %d!\n",
-				 address);
+			pr_err("rtl8192ce: Failed to polling write LLT done at address %d!\n",
+			       address);
 			status = false;
 			break;
 		}
@@ -963,7 +959,7 @@ int rtl92ce_hw_init(struct ieee80211_hw *hw)
 	rtlpriv->intf_ops->disable_aspm(hw);
 	rtstatus = _rtl92ce_init_mac(hw);
 	if (!rtstatus) {
-		RT_TRACE(rtlpriv, COMP_ERR, DBG_EMERG, "Init MAC failed\n");
+		pr_err("rtl8192ce: Init MAC failed\n");
 		err = 1;
 		goto exit;
 	}
@@ -1128,8 +1124,7 @@ static enum version_8192c _rtl92ce_read_chip_version(struct ieee80211_hw *hw)
 		break;
 	}
 
-	RT_TRACE(rtlpriv, COMP_INIT, DBG_EMERG,
-		 "Chip Version ID: %s\n", versionid);
+	pr_info("Chip Version ID: %s\n", versionid);
 
 	switch (version & 0x3) {
 	case CHIP_88C:
@@ -1143,8 +1138,7 @@ static enum version_8192c _rtl92ce_read_chip_version(struct ieee80211_hw *hw)
 		break;
 	default:
 		rtlphy->rf_type = RF_1T1R;
-		RT_TRACE(rtlpriv, COMP_ERR, DBG_EMERG,
-			 "ERROR RF_Type is set!!\n");
+		pr_err("rtl8192ce: ERROR RF_Type is set!!\n");
 		break;
 	}
 
@@ -1193,8 +1187,7 @@ static int _rtl92ce_set_media_status(struct ieee80211_hw *hw,
 			 "Set Network type to Mesh Point!\n");
 		break;
 	default:
-		RT_TRACE(rtlpriv, COMP_ERR, DBG_EMERG,
-			 "Network type %d not supported!\n", type);
+		pr_err("rtl8192ce: Network type %d not supported!\n", type);
 		return 1;
 
 	}
@@ -1780,7 +1773,7 @@ void rtl92ce_read_eeprom_info(struct ieee80211_hw *hw)
 		rtlefuse->autoload_failflag = false;
 		_rtl92ce_read_adapter_info(hw);
 	} else {
-		RT_TRACE(rtlpriv, COMP_ERR, DBG_EMERG, "Autoload ERR!!\n");
+		pr_err("rtl8192ce: Autoload ERR!!\n");
 	}
 	_rtl92ce_hal_customized_behavior(hw);
 }
@@ -2152,8 +2145,8 @@ void rtl92ce_set_key(struct ieee80211_hw *hw, u32 key_index,
 			enc_algo = CAM_AES;
 			break;
 		default:
-			RT_TRACE(rtlpriv, COMP_ERR, DBG_EMERG,
-				 "switch case %#x not processed\n", enc_algo);
+			pr_err("rtl8192ce: switch case %#x not processed\n",
+			       enc_algo);
 			enc_algo = CAM_TKIP;
 			break;
 		}
@@ -2171,9 +2163,7 @@ void rtl92ce_set_key(struct ieee80211_hw *hw, u32 key_index,
 					entry_id = rtl_cam_get_free_entry(hw,
 								 p_macaddr);
 					if (entry_id >=  TOTAL_CAM_ENTRY) {
-						RT_TRACE(rtlpriv, COMP_SEC,
-							 DBG_EMERG,
-							 "Can not find free hw security cam entry\n");
+						pr_err("rtl8192ce: Can not find free hw security cam entry\n");
 						return;
 					}
 				} else {
diff --git a/drivers/net/wireless/realtek/rtlwifi/rtl8192ce/led.c b/drivers/net/wireless/realtek/rtlwifi/rtl8192ce/led.c
index 833193b..b9d40be 100644
--- a/drivers/net/wireless/realtek/rtlwifi/rtl8192ce/led.c
+++ b/drivers/net/wireless/realtek/rtlwifi/rtl8192ce/led.c
@@ -57,8 +57,8 @@ void rtl92ce_sw_led_on(struct ieee80211_hw *hw, struct rtl_led *pled)
 		rtl_write_byte(rtlpriv, REG_LEDCFG2, (ledcfg & 0x0f) | BIT(5));
 		break;
 	default:
-		RT_TRACE(rtlpriv, COMP_ERR, DBG_EMERG,
-			 "switch case %#x not processed\n", pled->ledpin);
+		pr_err("rtl8192ce: switch case %#x not processed\n",
+		       pled->ledpin);
 		break;
 	}
 	pled->ledon = true;
@@ -92,8 +91,7 @@ void rtl92ce_sw_led_off(struct ieee80211_hw *hw, struct rtl_led *pled)
 		rtl_write_byte(rtlpriv, REG_LEDCFG2, (ledcfg | BIT(3)));
 		break;
 	default:
-		RT_TRACE(rtlpriv, COMP_ERR, DBG_EMERG,
-			 "switch case %#x not processed\n", pled->ledpin);
+		pr_info("switch case %#x not processed\n", pled->ledpin);
 		break;
 	}
 	pled->ledon = false;
diff --git a/drivers/net/wireless/realtek/rtlwifi/rtl8192ce/phy.c b/drivers/net/wireless/realtek/rtlwifi/rtl8192ce/phy.c
index d1b6a8f..4b67358 100644
--- a/drivers/net/wireless/realtek/rtlwifi/rtl8192ce/phy.c
+++ b/drivers/net/wireless/realtek/rtlwifi/rtl8192ce/phy.c
@@ -297,10 +297,10 @@ bool rtl92c_phy_config_rf_with_headerfile(struct ieee80211_hw *hw,
 		break;
 	case RF90_PATH_C:
 	case RF90_PATH_D:
-		RT_TRACE(rtlpriv, COMP_ERR, DBG_EMERG,
-			 "switch case %#x not processed\n", rfpath);
+		pr_info("Incorrect rfpath %#x\n", rfpath);
 		break;
 	default:
+		pr_info("switch case %#x not processed\n", rfpath);
 		break;
 	}
 	return true;
@@ -340,8 +340,7 @@ void rtl92ce_phy_set_bw_mode_callback(struct ieee80211_hw *hw)
 		rtl_write_byte(rtlpriv, REG_RRSR + 2, reg_prsr_rsc);
 		break;
 	default:
-		RT_TRACE(rtlpriv, COMP_ERR, DBG_EMERG,
-			 "unknown bandwidth: %#X\n", rtlphy->current_chan_bw);
+		pr_info("unknown bandwidth: %#X\n", rtlphy->current_chan_bw);
 		break;
 	}
 
@@ -365,8 +364,8 @@ void rtl92ce_phy_set_bw_mode_callback(struct ieee80211_hw *hw)
 			       HAL_PRIME_CHNL_OFFSET_LOWER) ? 2 : 1);
 		break;
 	default:
-		RT_TRACE(rtlpriv, COMP_ERR, DBG_EMERG,
-			 "unknown bandwidth: %#X\n", rtlphy->current_chan_bw);
+		pr_err("rtl8192ce: unknown bandwidth: %#X\n",
+		       rtlphy->current_chan_bw);
 		break;
 	}
 	rtl92ce_phy_rf6052_set_bandwidth(hw, rtlphy->current_chan_bw);
@@ -546,8 +544,8 @@ static bool _rtl92ce_phy_set_rf_power_state(struct ieee80211_hw *hw,
 			break;
 		}
 	default:
-		RT_TRACE(rtlpriv, COMP_ERR, DBG_EMERG,
-			 "switch case %#x not processed\n", rfpwr_state);
+		pr_err("rtl8192ce: switch case %#x not processed\n",
+		       rfpwr_state);
 		bresult = false;
 		break;
 	}
diff --git a/drivers/net/wireless/realtek/rtlwifi/rtl8192ce/rf.c b/drivers/net/wireless/realtek/rtlwifi/rtl8192ce/rf.c
index 7cae635..e68ed7f 100644
--- a/drivers/net/wireless/realtek/rtlwifi/rtl8192ce/rf.c
+++ b/drivers/net/wireless/realtek/rtlwifi/rtl8192ce/rf.c
@@ -51,8 +51,7 @@ void rtl92ce_phy_rf6052_set_bandwidth(struct ieee80211_hw *hw, u8 bandwidth)
 			      rtlphy->rfreg_chnlval[0]);
 		break;
 	default:
-		RT_TRACE(rtlpriv, COMP_ERR, DBG_EMERG,
-			 "unknown bandwidth: %#X\n", bandwidth);
+		pr_err("rtl8192ce: unknown bandwidth: %#X\n", bandwidth);
 		break;
 	}
 }
diff --git a/drivers/net/wireless/realtek/rtlwifi/rtl8192ce/sw.c b/drivers/net/wireless/realtek/rtlwifi/rtl8192ce/sw.c
index 691ddef..9bd2bff6 100644
--- a/drivers/net/wireless/realtek/rtlwifi/rtl8192ce/sw.c
+++ b/drivers/net/wireless/realtek/rtlwifi/rtl8192ce/sw.c
@@ -158,8 +158,7 @@ int rtl92c_init_sw_vars(struct ieee80211_hw *hw)
 	/* for firmware buf */
 	rtlpriv->rtlhal.pfirmware = vzalloc(0x4000);
 	if (!rtlpriv->rtlhal.pfirmware) {
-		RT_TRACE(rtlpriv, COMP_ERR, DBG_EMERG,
-			 "Can't alloc buffer for fw\n");
+		pr_err("rtl8192ce: Can't alloc buffer for fw\n");
 		return 1;
 	}
 
@@ -173,8 +172,7 @@ int rtl92c_init_sw_vars(struct ieee80211_hw *hw)
 				      rtlpriv->io.dev, GFP_KERNEL, hw,
 				      rtl_fw_cb);
 	if (err) {
-		RT_TRACE(rtlpriv, COMP_ERR, DBG_EMERG,
-			 "Failed to request firmware!\n");
+		pr_err("rtl8192ce: Failed to request firmware!\n");
 		return 1;
 	}
 
@@ -249,7 +247,7 @@ static struct rtl_mod_params rtl92ce_mod_params = {
 	.inactiveps = true,
 	.swctrl_lps = false,
 	.fwctrl_lps = true,
-	.debug = DBG_EMERG,
+	.debug = 0,
 };
 
 static const struct rtl_hal_cfg rtl92ce_hal_cfg = {
-- 
2.10.2
