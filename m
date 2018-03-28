Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from rtits2.realtek.com ([211.75.126.72]:47360 "EHLO
        rtits2.realtek.com.tw" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752827AbeC1H17 (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 28 Mar 2018 03:27:59 -0400
From: <pkshih@realtek.com>
To: <kvalo@codeaurora.org>
CC: <Larry.Finger@lwfinger.net>, <linux-wireless@vger.kernel.org>
Subject: [PATCH 4/9] rtlwifi: btcoex: Add 8822b routine to btc interfaces
Date: Wed, 28 Mar 2018 15:27:36 +0800
Message-ID: <20180328072741.23349-5-pkshih@realtek.com> (sfid-20180328_092846_175099_EA02AE67)
In-Reply-To: <20180328072741.23349-1-pkshih@realtek.com>
References: <20180328072741.23349-1-pkshih@realtek.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Ping-Ke Shih <pkshih@realtek.com>

Add 8822b routines to run btcoex algorithm

Signed-off-by: Ping-Ke Shih <pkshih@realtek.com>
---
 .../realtek/rtlwifi/btcoexist/halbtcoutsrc.c       | 100 +++++++++++++++++++++
 1 file changed, 100 insertions(+)

diff --git a/drivers/net/wireless/realtek/rtlwifi/btcoexist/halbtcoutsrc.c b/drivers/net/wireless/realtek/rtlwifi/btcoexist/halbtcoutsrc.c
index 8b6b07a936f5..e0f9985582f9 100644
--- a/drivers/net/wireless/realtek/rtlwifi/btcoexist/halbtcoutsrc.c
+++ b/drivers/net/wireless/realtek/rtlwifi/btcoexist/halbtcoutsrc.c
@@ -1441,6 +1441,11 @@ void exhalbtc_power_on_setting(struct btc_coexist *btcoexist)
 			ex_btc8723b2ant_power_on_setting(btcoexist);
 		else if (btcoexist->board_info.btdm_ant_num == 1)
 			ex_btc8723b1ant_power_on_setting(btcoexist);
+	} else if (IS_HARDWARE_TYPE_8822B(btcoexist->adapter)) {
+		if (btcoexist->board_info.btdm_ant_num == 1)
+			ex_btc8822b1ant_power_on_setting(btcoexist);
+		else if (btcoexist->board_info.btdm_ant_num == 2)
+			ex_btc8822b2ant_power_on_setting(btcoexist);
 	}
 }
 
@@ -1454,6 +1459,11 @@ void exhalbtc_pre_load_firmware(struct btc_coexist *btcoexist)
 	if (IS_HARDWARE_TYPE_8723B(btcoexist->adapter)) {
 		if (btcoexist->board_info.btdm_ant_num == 2)
 			ex_btc8723b2ant_pre_load_firmware(btcoexist);
+	} else if (IS_HARDWARE_TYPE_8822B(btcoexist->adapter)) {
+		if (btcoexist->board_info.btdm_ant_num == 1)
+			ex_btc8822b1ant_pre_load_firmware(btcoexist);
+		else if (btcoexist->board_info.btdm_ant_num == 2)
+			ex_btc8822b2ant_pre_load_firmware(btcoexist);
 	}
 }
 
@@ -1479,11 +1489,21 @@ void exhalbtc_init_hw_config(struct btc_coexist *btcoexist, bool wifi_only)
 	} else if (IS_HARDWARE_TYPE_8192E(btcoexist->adapter)) {
 		if (btcoexist->board_info.btdm_ant_num == 2)
 			ex_btc8192e2ant_init_hwconfig(btcoexist);
+	} else if (IS_HARDWARE_TYPE_8822B(btcoexist->adapter)) {
+		if (btcoexist->board_info.btdm_ant_num == 1)
+			ex_btc8822b1ant_init_hw_config(btcoexist, wifi_only);
+		else if (btcoexist->board_info.btdm_ant_num == 2)
+			ex_btc8822b2ant_init_hw_config(btcoexist, wifi_only);
+
+		halbtc_set_default_port_id_cmd(btcoexist);
+		halbtc_send_wifi_port_id_cmd(btcoexist);
 	}
 }
 
 void exhalbtc_init_hw_config_wifi_only(struct wifi_only_cfg *wifionly_cfg)
 {
+	if (IS_HARDWARE_TYPE_8822B(wifionly_cfg->adapter))
+		ex_hal8822b_wifi_only_hw_config(wifionly_cfg);
 }
 
 void exhalbtc_init_coex_dm(struct btc_coexist *btcoexist)
@@ -1506,6 +1526,11 @@ void exhalbtc_init_coex_dm(struct btc_coexist *btcoexist)
 	} else if (IS_HARDWARE_TYPE_8192E(btcoexist->adapter)) {
 		if (btcoexist->board_info.btdm_ant_num == 2)
 			ex_btc8192e2ant_init_coex_dm(btcoexist);
+	} else if (IS_HARDWARE_TYPE_8822B(btcoexist->adapter)) {
+		if (btcoexist->board_info.btdm_ant_num == 1)
+			ex_btc8822b1ant_init_coex_dm(btcoexist);
+		else if (btcoexist->board_info.btdm_ant_num == 2)
+			ex_btc8822b2ant_init_coex_dm(btcoexist);
 	}
 
 	btcoexist->initilized = true;
@@ -1541,6 +1566,11 @@ void exhalbtc_ips_notify(struct btc_coexist *btcoexist, u8 type)
 	} else if (IS_HARDWARE_TYPE_8192E(btcoexist->adapter)) {
 		if (btcoexist->board_info.btdm_ant_num == 2)
 			ex_btc8192e2ant_ips_notify(btcoexist, ips_type);
+	} else if (IS_HARDWARE_TYPE_8822B(btcoexist->adapter)) {
+		if (btcoexist->board_info.btdm_ant_num == 1)
+			ex_btc8822b1ant_ips_notify(btcoexist, ips_type);
+		else if (btcoexist->board_info.btdm_ant_num == 2)
+			ex_btc8822b2ant_ips_notify(btcoexist, ips_type);
 	}
 
 	halbtc_normal_low_power(btcoexist);
@@ -1574,6 +1604,11 @@ void exhalbtc_lps_notify(struct btc_coexist *btcoexist, u8 type)
 	} else if (IS_HARDWARE_TYPE_8192E(btcoexist->adapter)) {
 		if (btcoexist->board_info.btdm_ant_num == 2)
 			ex_btc8192e2ant_lps_notify(btcoexist, lps_type);
+	} else if (IS_HARDWARE_TYPE_8822B(btcoexist->adapter)) {
+		if (btcoexist->board_info.btdm_ant_num == 1)
+			ex_btc8822b1ant_lps_notify(btcoexist, lps_type);
+		else if (btcoexist->board_info.btdm_ant_num == 2)
+			ex_btc8822b2ant_lps_notify(btcoexist, lps_type);
 	}
 }
 
@@ -1607,6 +1642,11 @@ void exhalbtc_scan_notify(struct btc_coexist *btcoexist, u8 type)
 	} else if (IS_HARDWARE_TYPE_8192E(btcoexist->adapter)) {
 		if (btcoexist->board_info.btdm_ant_num == 2)
 			ex_btc8192e2ant_scan_notify(btcoexist, scan_type);
+	} else if (IS_HARDWARE_TYPE_8822B(btcoexist->adapter)) {
+		if (btcoexist->board_info.btdm_ant_num == 1)
+			ex_btc8822b1ant_scan_notify(btcoexist, scan_type);
+		else if (btcoexist->board_info.btdm_ant_num == 2)
+			ex_btc8822b2ant_scan_notify(btcoexist, scan_type);
 	}
 
 	halbtc_normal_low_power(btcoexist);
@@ -1615,6 +1655,8 @@ void exhalbtc_scan_notify(struct btc_coexist *btcoexist, u8 type)
 void exhalbtc_scan_notify_wifi_only(struct wifi_only_cfg *wifionly_cfg,
 				    u8 is_5g)
 {
+	if (IS_HARDWARE_TYPE_8822B(wifionly_cfg->adapter))
+		ex_hal8822b_wifi_only_scannotify(wifionly_cfg, is_5g);
 }
 
 void exhalbtc_connect_notify(struct btc_coexist *btcoexist, u8 action)
@@ -1655,6 +1697,11 @@ void exhalbtc_connect_notify(struct btc_coexist *btcoexist, u8 action)
 	} else if (IS_HARDWARE_TYPE_8192E(btcoexist->adapter)) {
 		if (btcoexist->board_info.btdm_ant_num == 2)
 			ex_btc8192e2ant_connect_notify(btcoexist, asso_type);
+	} else if (IS_HARDWARE_TYPE_8822B(btcoexist->adapter)) {
+		if (btcoexist->board_info.btdm_ant_num == 1)
+			ex_btc8822b1ant_connect_notify(btcoexist, asso_type_v2);
+		else if (btcoexist->board_info.btdm_ant_num == 2)
+			ex_btc8822b2ant_connect_notify(btcoexist, asso_type_v2);
 	}
 
 	halbtc_normal_low_power(btcoexist);
@@ -1691,6 +1738,11 @@ void exhalbtc_mediastatus_notify(struct btc_coexist *btcoexist,
 	} else if (IS_HARDWARE_TYPE_8192E(btcoexist->adapter)) {
 		if (btcoexist->board_info.btdm_ant_num == 2)
 			ex_btc8192e2ant_media_status_notify(btcoexist, status);
+	} else if (IS_HARDWARE_TYPE_8822B(btcoexist->adapter)) {
+		if (btcoexist->board_info.btdm_ant_num == 1)
+			ex_btc8822b1ant_media_status_notify(btcoexist, status);
+		else if (btcoexist->board_info.btdm_ant_num == 2)
+			ex_btc8822b2ant_media_status_notify(btcoexist, status);
 	}
 
 	halbtc_normal_low_power(btcoexist);
@@ -1737,6 +1789,13 @@ void exhalbtc_special_packet_notify(struct btc_coexist *btcoexist, u8 pkt_type)
 		if (btcoexist->board_info.btdm_ant_num == 2)
 			ex_btc8192e2ant_special_packet_notify(btcoexist,
 							      packet_type);
+	} else if (IS_HARDWARE_TYPE_8822B(btcoexist->adapter)) {
+		if (btcoexist->board_info.btdm_ant_num == 1)
+			ex_btc8822b1ant_specific_packet_notify(btcoexist,
+							       packet_type);
+		else if (btcoexist->board_info.btdm_ant_num == 2)
+			ex_btc8822b2ant_specific_packet_notify(btcoexist,
+							       packet_type);
 	}
 
 	halbtc_normal_low_power(btcoexist);
@@ -1769,6 +1828,13 @@ void exhalbtc_bt_info_notify(struct btc_coexist *btcoexist,
 		if (btcoexist->board_info.btdm_ant_num == 2)
 			ex_btc8192e2ant_bt_info_notify(btcoexist, tmp_buf,
 						       length);
+	} else if (IS_HARDWARE_TYPE_8822B(btcoexist->adapter)) {
+		if (btcoexist->board_info.btdm_ant_num == 1)
+			ex_btc8822b1ant_bt_info_notify(btcoexist, tmp_buf,
+						       length);
+		else if (btcoexist->board_info.btdm_ant_num == 2)
+			ex_btc8822b2ant_bt_info_notify(btcoexist, tmp_buf,
+						       length);
 	}
 
 	halbtc_normal_low_power(btcoexist);
@@ -1784,6 +1850,11 @@ void exhalbtc_rf_status_notify(struct btc_coexist *btcoexist, u8 type)
 		if (btcoexist->board_info.btdm_ant_num == 1)
 			ex_btc8723b1ant_rf_status_notify(btcoexist, type);
 	} else if (IS_HARDWARE_TYPE_8192E(btcoexist->adapter)) {
+	} else if (IS_HARDWARE_TYPE_8822B(btcoexist->adapter)) {
+		if (btcoexist->board_info.btdm_ant_num == 1)
+			ex_btc8822b1ant_rf_status_notify(btcoexist, type);
+		else if (btcoexist->board_info.btdm_ant_num == 2)
+			ex_btc8822b2ant_rf_status_notify(btcoexist, type);
 	}
 }
 
@@ -1829,6 +1900,11 @@ void exhalbtc_halt_notify(struct btc_coexist *btcoexist)
 	} else if (IS_HARDWARE_TYPE_8192E(btcoexist->adapter)) {
 		if (btcoexist->board_info.btdm_ant_num == 2)
 			ex_btc8192e2ant_halt_notify(btcoexist);
+	} else if (IS_HARDWARE_TYPE_8822B(btcoexist->adapter)) {
+		if (btcoexist->board_info.btdm_ant_num == 1)
+			ex_btc8822b1ant_halt_notify(btcoexist);
+		else if (btcoexist->board_info.btdm_ant_num == 2)
+			ex_btc8822b2ant_halt_notify(btcoexist);
 	}
 
 	btcoexist->binded = false;
@@ -1855,6 +1931,11 @@ void exhalbtc_pnp_notify(struct btc_coexist *btcoexist, u8 pnp_state)
 		else if (btcoexist->board_info.btdm_ant_num == 2)
 			ex_btc8821a2ant_pnp_notify(btcoexist, pnp_state);
 	} else if (IS_HARDWARE_TYPE_8192E(btcoexist->adapter)) {
+	} else if (IS_HARDWARE_TYPE_8822B(btcoexist->adapter)) {
+		if (btcoexist->board_info.btdm_ant_num == 1)
+			ex_btc8822b1ant_pnp_notify(btcoexist, pnp_state);
+		else if (btcoexist->board_info.btdm_ant_num == 2)
+			ex_btc8822b2ant_pnp_notify(btcoexist, pnp_state);
 	}
 }
 
@@ -1905,6 +1986,11 @@ void exhalbtc_periodical(struct btc_coexist *btcoexist)
 	} else if (IS_HARDWARE_TYPE_8192E(btcoexist->adapter)) {
 		if (btcoexist->board_info.btdm_ant_num == 2)
 			ex_btc8192e2ant_periodical(btcoexist);
+	} else if (IS_HARDWARE_TYPE_8822B(btcoexist->adapter)) {
+		if (btcoexist->board_info.btdm_ant_num == 1)
+			ex_btc8822b1ant_periodical(btcoexist);
+		else if (btcoexist->board_info.btdm_ant_num == 2)
+			ex_btc8822b2ant_periodical(btcoexist);
 	}
 
 	halbtc_normal_low_power(btcoexist);
@@ -2038,6 +2124,11 @@ void exhalbtc_display_bt_coex_info(struct btc_coexist *btcoexist,
 	} else if (IS_HARDWARE_TYPE_8192E(btcoexist->adapter)) {
 		if (btcoexist->board_info.btdm_ant_num == 2)
 			ex_btc8192e2ant_display_coex_info(btcoexist, m);
+	} else if (IS_HARDWARE_TYPE_8822B(btcoexist->adapter)) {
+		if (btcoexist->board_info.btdm_ant_num == 1)
+			ex_btc8822b1ant_display_coex_info(btcoexist, m);
+		else if (btcoexist->board_info.btdm_ant_num == 2)
+			ex_btc8822b2ant_display_coex_info(btcoexist, m);
 	}
 
 	halbtc_normal_low_power(btcoexist);
@@ -2053,10 +2144,19 @@ void exhalbtc_switch_band_notify(struct btc_coexist *btcoexist, u8 type)
 
 	halbtc_leave_low_power(btcoexist);
 
+	if (IS_HARDWARE_TYPE_8822B(btcoexist->adapter)) {
+		if (btcoexist->board_info.btdm_ant_num == 1)
+			ex_btc8822b1ant_switchband_notify(btcoexist, type);
+		else if (btcoexist->board_info.btdm_ant_num == 2)
+			ex_btc8822b2ant_switchband_notify(btcoexist, type);
+	}
+
 	halbtc_normal_low_power(btcoexist);
 }
 
 void exhalbtc_switch_band_notify_wifi_only(struct wifi_only_cfg *wifionly_cfg,
 					   u8 is_5g)
 {
+	if (IS_HARDWARE_TYPE_8822B(wifionly_cfg->adapter))
+		ex_hal8822b_wifi_only_switchbandnotify(wifionly_cfg, is_5g);
 }
-- 
2.15.1
