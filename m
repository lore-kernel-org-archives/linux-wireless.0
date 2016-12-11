Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-oi0-f65.google.com ([209.85.218.65]:35021 "EHLO
        mail-oi0-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752924AbcLKFpr (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Sun, 11 Dec 2016 00:45:47 -0500
Received: by mail-oi0-f65.google.com with SMTP id v84so7251852oie.2
        for <linux-wireless@vger.kernel.org>; Sat, 10 Dec 2016 21:45:46 -0800 (PST)
From: Larry Finger <Larry.Finger@lwfinger.net>
To: kvalo@codeaurora.org
Cc: devel@driverdev.osuosl.org, linux-wireless@vger.kernel.org,
        Larry Finger <Larry.Finger@lwfinger.net>,
        Ping-Ke Shih <pkshih@realtek.com>
Subject: [PATCH 09/14] rtlwifi_new: rtl8192de: Remove all instances of DBG_EMERG
Date: Sat, 10 Dec 2016 23:45:13 -0600
Message-Id: <20161211054523.7119-17-Larry.Finger@lwfinger.net> (sfid-20161211_064551_051391_95AFF1BD)
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
 .../net/wireless/realtek/rtlwifi/rtl8192de/fw.c    | 19 ++++--------
 .../net/wireless/realtek/rtlwifi/rtl8192de/hw.c    | 34 ++++++++--------------
 .../net/wireless/realtek/rtlwifi/rtl8192de/led.c   |  6 ++--
 .../net/wireless/realtek/rtlwifi/rtl8192de/phy.c   | 31 ++++++++------------
 .../net/wireless/realtek/rtlwifi/rtl8192de/rf.c    |  3 +-
 .../net/wireless/realtek/rtlwifi/rtl8192de/sw.c    |  8 ++---
 6 files changed, 36 insertions(+), 65 deletions(-)

diff --git a/drivers/net/wireless/realtek/rtlwifi/rtl8192de/fw.c b/drivers/net/wireless/realtek/rtlwifi/rtl8192de/fw.c
index 452de25..5b33bed 100644
--- a/drivers/net/wireless/realtek/rtlwifi/rtl8192de/fw.c
+++ b/drivers/net/wireless/realtek/rtlwifi/rtl8192de/fw.c
@@ -126,8 +126,7 @@ static void _rtl92d_write_fw(struct ieee80211_hw *hw,
 	pagenums = size / FW_8192D_PAGE_SIZE;
 	remainSize = size % FW_8192D_PAGE_SIZE;
 	if (pagenums > 8) {
-		RT_TRACE(rtlpriv, COMP_ERR, DBG_EMERG,
-			 "Page numbers should not greater then 8\n");
+		pr_err("Page numbers should not greater then 8\n");
 	}
 	for (page = 0; page < pagenums; page++) {
 		offset = page * FW_8192D_PAGE_SIZE;
@@ -153,9 +152,7 @@ static int _rtl92d_fw_free_to_go(struct ieee80211_hw *hw)
 	} while ((counter++ < FW_8192D_POLLING_TIMEOUT_COUNT) &&
 		 (!(value32 & FWDL_ChkSum_rpt)));
 	if (counter >= FW_8192D_POLLING_TIMEOUT_COUNT) {
-		RT_TRACE(rtlpriv, COMP_ERR, DBG_EMERG,
-			 "chksum report faill ! REG_MCUFWDL:0x%08x\n",
-			 value32);
+		pr_err("chksum report fail! REG_MCUFWDL:0x%08x\n", value32);
 		return -EIO;
 	}
 	RT_TRACE(rtlpriv, COMP_FW, DBG_TRACE,
@@ -327,8 +324,7 @@ int rtl92d_download_fw(struct ieee80211_hw *hw)
 	rtl_write_byte(rtlpriv, 0x1f, value);
 	spin_unlock_irqrestore(&globalmutex_for_fwdownload, flags);
 	if (err) {
-		RT_TRACE(rtlpriv, COMP_ERR, DBG_EMERG,
-			 "fw is not ready to run!\n");
+		pr_err("fw is not ready to run!\n");
 		goto exit;
 	} else {
 		RT_TRACE(rtlpriv, COMP_FW, DBG_TRACE, "fw is ready to run!\n");
@@ -407,8 +403,7 @@ static void _rtl92d_fill_h2c_command(struct ieee80211_hw *hw,
 	while (!bwrite_success) {
 		wait_writeh2c_limmit--;
 		if (wait_writeh2c_limmit == 0) {
-			RT_TRACE(rtlpriv, COMP_ERR, DBG_EMERG,
-				 "Write H2C fail because no trigger for FW INT!\n");
+			pr_err("Write H2C fail because no trigger for FW INT!\n");
 			break;
 		}
 		boxnum = rtlhal->last_hmeboxnum;
@@ -430,8 +425,7 @@ static void _rtl92d_fill_h2c_command(struct ieee80211_hw *hw,
 			box_extreg = REG_HMEBOX_EXT_3;
 			break;
 		default:
-			RT_TRACE(rtlpriv, COMP_ERR, DBG_EMERG,
-				 "switch case %#x not processed\n", boxnum);
+			pr_err("switch case %#x not processed\n", boxnum);
 			break;
 		}
 		isfw_read = _rtl92d_check_fw_read_last_h2c(hw, boxnum);
@@ -507,8 +501,7 @@ static void _rtl92d_fill_h2c_command(struct ieee80211_hw *hw,
 					       boxcontent[idx]);
 			break;
 		default:
-			RT_TRACE(rtlpriv, COMP_ERR, DBG_EMERG,
-				 "switch case %#x not processed\n", cmd_len);
+			pr_err("switch case %#x not processed\n", cmd_len);
 			break;
 		}
 		bwrite_success = true;
diff --git a/drivers/net/wireless/realtek/rtlwifi/rtl8192de/hw.c b/drivers/net/wireless/realtek/rtlwifi/rtl8192de/hw.c
index fcb14c5..2c92c33 100644
--- a/drivers/net/wireless/realtek/rtlwifi/rtl8192de/hw.c
+++ b/drivers/net/wireless/realtek/rtlwifi/rtl8192de/hw.c
@@ -163,8 +163,7 @@ void rtl92de_get_hw_reg(struct ieee80211_hw *hw, u8 variable, u8 *val)
 	case HAL_DEF_WOWLAN:
 		break;
 	default:
-		RT_TRACE(rtlpriv, COMP_ERR, DBG_EMERG,
-			 "switch case %#x not processed\n", variable);
+		pr_err("switch case %#x not processed\n", variable);
 		break;
 	}
 }
@@ -358,9 +357,8 @@ void rtl92de_set_hw_reg(struct ieee80211_hw *hw, u8 variable, u8 *val)
 				acm_ctrl &= (~ACMHW_VOQEN);
 				break;
 			default:
-				RT_TRACE(rtlpriv, COMP_ERR, DBG_EMERG,
-					 "switch case %#x not processed\n",
-					 e_aci);
+				pr_err("switch case %#x not processed\n",
+				       e_aci);
 				break;
 			}
 		}
@@ -500,8 +498,7 @@ void rtl92de_set_hw_reg(struct ieee80211_hw *hw, u8 variable, u8 *val)
 		break;
 	}
 	default:
-		RT_TRACE(rtlpriv, COMP_ERR, DBG_EMERG,
-			 "switch case %#x not processed\n", variable);
+		pr_err("switch case %#x not processed\n", variable);
 		break;
 	}
 }
@@ -520,9 +517,8 @@ static bool _rtl92de_llt_write(struct ieee80211_hw *hw, u32 address, u32 data)
 		if (_LLT_NO_ACTIVE == _LLT_OP_VALUE(value))
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
@@ -920,7 +916,7 @@ int rtl92de_hw_init(struct ieee80211_hw *hw)
 	/* rtlpriv->intf_ops->disable_aspm(hw); */
 	rtstatus = _rtl92de_init_mac(hw);
 	if (!rtstatus) {
-		RT_TRACE(rtlpriv, COMP_ERR, DBG_EMERG, "Init MAC failed\n");
+		pr_err("Init MAC failed\n");
 		err = 1;
 		spin_unlock_irqrestore(&globalmutex_for_power_and_efuse, flags);
 		return err;
@@ -1119,11 +1115,8 @@ static int _rtl92de_set_media_status(struct ieee80211_hw *hw,
 			 "Set Network type to AP!\n");
 		break;
 	default:
-		RT_TRACE(rtlpriv, COMP_ERR, DBG_EMERG,
-			 "Network type %d not supported!\n", type);
+		pr_err("Network type %d not supported!\n", type);
 		return 1;
-		break;
-
 	}
 	rtl_write_byte(rtlpriv, MSR, bt_msr);
 	rtlpriv->cfg->ops->led_control(hw, ledaction);
@@ -1732,7 +1725,7 @@ static void _rtl92de_efuse_update_chip_version(struct ieee80211_hw *hw)
 		break;
 	default:
 		chipver |= CHIP_92D_D_CUT;
-		RT_TRACE(rtlpriv, COMP_INIT, DBG_EMERG, "Unknown CUT!\n");
+		pr_err("Unknown CUT!\n");
 		break;
 	}
 	rtlpriv->rtlhal.version = chipver;
@@ -1816,7 +1809,7 @@ void rtl92de_read_eeprom_info(struct ieee80211_hw *hw)
 		rtlefuse->autoload_failflag = false;
 		_rtl92de_read_adapter_info(hw);
 	} else {
-		RT_TRACE(rtlpriv, COMP_ERR, DBG_EMERG, "Autoload ERR!!\n");
+		pr_err("Autoload ERR!!\n");
 	}
 	return;
 }
@@ -2169,8 +2162,7 @@ void rtl92de_set_key(struct ieee80211_hw *hw, u32 key_index,
 			enc_algo = CAM_AES;
 			break;
 		default:
-			RT_TRACE(rtlpriv, COMP_ERR, DBG_EMERG,
-				 "switch case %#x not processed\n", enc_algo);
+			pr_err("switch case %#x not processed\n", enc_algo);
 			enc_algo = CAM_TKIP;
 			break;
 		}
@@ -2186,9 +2178,7 @@ void rtl92de_set_key(struct ieee80211_hw *hw, u32 key_index,
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
diff --git a/drivers/net/wireless/realtek/rtlwifi/rtl8192de/led.c b/drivers/net/wireless/realtek/rtlwifi/rtl8192de/led.c
index c22b8a2..58ec4fc 100644
--- a/drivers/net/wireless/realtek/rtlwifi/rtl8192de/led.c
+++ b/drivers/net/wireless/realtek/rtlwifi/rtl8192de/led.c
@@ -66,8 +66,7 @@ void rtl92de_sw_led_on(struct ieee80211_hw *hw, struct rtl_led *pled)
 		rtl_write_byte(rtlpriv, REG_LEDCFG2, (ledcfg & 0x0f) | BIT(5));
 		break;
 	default:
-		RT_TRACE(rtlpriv, COMP_ERR, DBG_EMERG,
-			 "switch case %#x not processed\n", pled->ledpin);
+		pr_err("switch case %#x not processed\n", pled->ledpin);
 		break;
 	}
 	pled->ledon = true;
@@ -101,8 +100,7 @@ void rtl92de_sw_led_off(struct ieee80211_hw *hw, struct rtl_led *pled)
 		rtl_write_byte(rtlpriv, REG_LEDCFG2, (ledcfg | BIT(3)));
 		break;
 	default:
-		RT_TRACE(rtlpriv, COMP_ERR, DBG_EMERG,
-			 "switch case %#x not processed\n", pled->ledpin);
+		pr_err("switch case %#x not processed\n", pled->ledpin);
 		break;
 	}
 	pled->ledon = false;
diff --git a/drivers/net/wireless/realtek/rtlwifi/rtl8192de/phy.c b/drivers/net/wireless/realtek/rtlwifi/rtl8192de/phy.c
index b0dc189..155b295 100644
--- a/drivers/net/wireless/realtek/rtlwifi/rtl8192de/phy.c
+++ b/drivers/net/wireless/realtek/rtlwifi/rtl8192de/phy.c
@@ -716,7 +716,7 @@ static bool _rtl92d_phy_bb_config(struct ieee80211_hw *hw)
 	rtstatus = _rtl92d_phy_config_bb_with_headerfile(hw,
 		BASEBAND_CONFIG_PHY_REG);
 	if (!rtstatus) {
-		RT_TRACE(rtlpriv, COMP_ERR, DBG_EMERG, "Write BB Reg Fail!!\n");
+		pr_err("Write BB Reg Fail!!\n");
 		return false;
 	}
 
@@ -731,13 +731,13 @@ static bool _rtl92d_phy_bb_config(struct ieee80211_hw *hw)
 			BASEBAND_CONFIG_PHY_REG);
 	}
 	if (!rtstatus) {
-		RT_TRACE(rtlpriv, COMP_ERR, DBG_EMERG, "BB_PG Reg Fail!!\n");
+		pr_err("BB_PG Reg Fail!!\n");
 		return false;
 	}
 	rtstatus = _rtl92d_phy_config_bb_with_headerfile(hw,
 		BASEBAND_CONFIG_AGC_TAB);
 	if (!rtstatus) {
-		RT_TRACE(rtlpriv, COMP_ERR, DBG_EMERG, "AGC Table Fail\n");
+		pr_err("AGC Table Fail\n");
 		return false;
 	}
 	rtlphy->cck_high_power = (bool) (rtl_get_bbreg(hw,
@@ -833,8 +833,7 @@ bool rtl92d_phy_config_rf_with_headerfile(struct ieee80211_hw *hw,
 		break;
 	case RF90_PATH_C:
 	case RF90_PATH_D:
-		RT_TRACE(rtlpriv, COMP_ERR, DBG_EMERG,
-			 "switch case %#x not processed\n", rfpath);
+		pr_err("switch case %#x not processed\n", rfpath);
 		break;
 	}
 	return true;
@@ -987,8 +986,7 @@ void rtl92d_phy_set_bw_mode(struct ieee80211_hw *hw,
 		rtl_write_byte(rtlpriv, REG_RRSR + 2, reg_prsr_rsc);
 		break;
 	default:
-		RT_TRACE(rtlpriv, COMP_ERR, DBG_EMERG,
-			 "unknown bandwidth: %#X\n", rtlphy->current_chan_bw);
+		pr_err("unknown bandwidth: %#X\n", rtlphy->current_chan_bw);
 		break;
 	}
 	switch (rtlphy->current_chan_bw) {
@@ -1019,8 +1017,7 @@ void rtl92d_phy_set_bw_mode(struct ieee80211_hw *hw,
 			HAL_PRIME_CHNL_OFFSET_LOWER) ? 2 : 1);
 		break;
 	default:
-		RT_TRACE(rtlpriv, COMP_ERR, DBG_EMERG,
-			 "unknown bandwidth: %#X\n", rtlphy->current_chan_bw);
+		pr_err("unknown bandwidth: %#X\n", rtlphy->current_chan_bw);
 		break;
 
 	}
@@ -2842,9 +2839,8 @@ static bool _rtl92d_phy_sw_chnl_step_by_step(struct ieee80211_hw *hw,
 			rtl92d_phy_reload_iqk_setting(hw, channel);
 			break;
 		default:
-			RT_TRACE(rtlpriv, COMP_ERR, DBG_EMERG,
-				 "switch case %#x not processed\n",
-				 currentcmd->cmdid);
+			pr_err("switch case %#x not processed\n",
+			       currentcmd->cmdid);
 			break;
 		}
 		break;
@@ -2956,9 +2952,8 @@ static void rtl92d_phy_set_io(struct ieee80211_hw *hw)
 		rtl92d_dm_write_dig(hw);
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
@@ -2988,8 +2983,7 @@ bool rtl92d_phy_set_io_cmd(struct ieee80211_hw *hw, enum io_type iotype)
 			postprocessing = true;
 			break;
 		default:
-			RT_TRACE(rtlpriv, COMP_ERR, DBG_EMERG,
-				 "switch case %#x not processed\n", iotype);
+			pr_err("switch case %#x not processed\n", iotype);
 			break;
 		}
 	} while (false);
@@ -3176,8 +3170,7 @@ bool rtl92d_phy_set_rf_power_state(struct ieee80211_hw *hw,
 		_rtl92d_phy_set_rfsleep(hw);
 		break;
 	default:
-		RT_TRACE(rtlpriv, COMP_ERR, DBG_EMERG,
-			 "switch case %#x not processed\n", rfpwr_state);
+		pr_err("switch case %#x not processed\n", rfpwr_state);
 		bresult = false;
 		break;
 	}
diff --git a/drivers/net/wireless/realtek/rtlwifi/rtl8192de/rf.c b/drivers/net/wireless/realtek/rtlwifi/rtl8192de/rf.c
index 9dc9e91..021d3c5 100644
--- a/drivers/net/wireless/realtek/rtlwifi/rtl8192de/rf.c
+++ b/drivers/net/wireless/realtek/rtlwifi/rtl8192de/rf.c
@@ -63,8 +63,7 @@ void rtl92d_phy_rf6052_set_bandwidth(struct ieee80211_hw *hw, u8 bandwidth)
 		}
 		break;
 	default:
-		RT_TRACE(rtlpriv, COMP_ERR, DBG_EMERG,
-			 "unknown bandwidth: %#X\n", bandwidth);
+		pr_err("unknown bandwidth: %#X\n", bandwidth);
 		break;
 	}
 }
diff --git a/drivers/net/wireless/realtek/rtlwifi/rtl8192de/sw.c b/drivers/net/wireless/realtek/rtlwifi/rtl8192de/sw.c
index 0d98b34..51463d7 100644
--- a/drivers/net/wireless/realtek/rtlwifi/rtl8192de/sw.c
+++ b/drivers/net/wireless/realtek/rtlwifi/rtl8192de/sw.c
@@ -171,8 +171,7 @@ static int rtl92d_init_sw_vars(struct ieee80211_hw *hw)
 	/* for firmware buf */
 	rtlpriv->rtlhal.pfirmware = vzalloc(0x8000);
 	if (!rtlpriv->rtlhal.pfirmware) {
-		RT_TRACE(rtlpriv, COMP_ERR, DBG_EMERG,
-			 "Can't alloc buffer for fw\n");
+		pr_err("Can't alloc buffer for fw\n");
 		return 1;
 	}
 
@@ -185,8 +184,7 @@ static int rtl92d_init_sw_vars(struct ieee80211_hw *hw)
 				      rtlpriv->io.dev, GFP_KERNEL, hw,
 				      rtl_fw_cb);
 	if (err) {
-		RT_TRACE(rtlpriv, COMP_ERR, DBG_EMERG,
-			 "Failed to request firmware!\n");
+		pr_err("Failed to request firmware!\n");
 		return 1;
 	}
 
@@ -256,7 +254,7 @@ static struct rtl_mod_params rtl92de_mod_params = {
 	.inactiveps = true,
 	.swctrl_lps = true,
 	.fwctrl_lps = false,
-	.debug = DBG_EMERG,
+	.debug = 0,
 };
 
 static const struct rtl_hal_cfg rtl92de_hal_cfg = {
-- 
2.10.2
