Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from rtits2.realtek.com ([211.75.126.72]:33531 "EHLO
        rtits2.realtek.com.tw" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752163AbeDJCwr (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 9 Apr 2018 22:52:47 -0400
From: <pkshih@realtek.com>
To: <kvalo@codeaurora.org>
CC: <Larry.Finger@lwfinger.net>, <linux-wireless@vger.kernel.org>
Subject: [PATCH v3 1/9] rtlwifi: btcoex: Add 8822b1ant coex files
Date: Tue, 10 Apr 2018 10:52:18 +0800
Message-ID: <20180410025226.5236-2-pkshih@realtek.com> (sfid-20180410_045304_902154_D240314B)
In-Reply-To: <20180410025226.5236-1-pkshih@realtek.com>
References: <20180410025226.5236-1-pkshih@realtek.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Ping-Ke Shih <pkshih@realtek.com>

This file supports 8822be WiFi module with two physical antenna that
means one antenna will share with BT.

Signed-off-by: Ping-Ke Shih <pkshih@realtek.com>
---
 .../realtek/rtlwifi/btcoexist/halbtc8822b1ant.c    | 5301 ++++++++++++++++++++
 .../realtek/rtlwifi/btcoexist/halbtc8822b1ant.h    |  413 ++
 2 files changed, 5714 insertions(+)
 create mode 100644 drivers/net/wireless/realtek/rtlwifi/btcoexist/halbtc8822b1ant.c
 create mode 100644 drivers/net/wireless/realtek/rtlwifi/btcoexist/halbtc8822b1ant.h

diff --git a/drivers/net/wireless/realtek/rtlwifi/btcoexist/halbtc8822b1ant.c b/drivers/net/wireless/realtek/rtlwifi/btcoexist/halbtc8822b1ant.c
new file mode 100644
index 000000000000..7350a5dcdc99
--- /dev/null
+++ b/drivers/net/wireless/realtek/rtlwifi/btcoexist/halbtc8822b1ant.c
@@ -0,0 +1,5301 @@
+/******************************************************************************
+ *
+ * Copyright(c) 2016 - 2017 Realtek Corporation.
+ *
+ * This program is free software; you can redistribute it and/or modify it
+ * under the terms of version 2 of the GNU General Public License as
+ * published by the Free Software Foundation.
+ *
+ * This program is distributed in the hope that it will be useful, but WITHOUT
+ * ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or
+ * FITNESS FOR A PARTICULAR PURPOSE. See the GNU General Public License for
+ * more details.
+ *
+ *****************************************************************************/
+
+#include "halbt_precomp.h"
+
+static struct coex_dm_8822b_1ant	glcoex_dm_8822b_1ant;
+static struct coex_dm_8822b_1ant	*coex_dm = &glcoex_dm_8822b_1ant;
+static struct coex_sta_8822b_1ant	glcoex_sta_8822b_1ant;
+static struct coex_sta_8822b_1ant	*coex_sta = &glcoex_sta_8822b_1ant;
+static struct rfe_type_8822b_1ant	gl_rfe_type_8822b_1ant;
+static struct rfe_type_8822b_1ant	*rfe_type = &gl_rfe_type_8822b_1ant;
+
+static const char *const glbt_info_src_8822b_1ant[] = {
+	"BT Info[wifi fw]",
+	"BT Info[bt rsp]",
+	"BT Info[bt auto report]",
+};
+
+static const u32 glcoex_ver_date_8822b_1ant = 20180112;
+static const u32 glcoex_ver_8822b_1ant = 0x59;
+static const u32 glcoex_ver_btdesired_8822b_1ant = 0x56;
+
+static u8 halbtc8822b1ant_wifi_rssi_state(struct btc_coexist *btcoexist,
+					  u8 *pprewifi_rssi_state, u8 level_num,
+					  u8 rssi_thresh, u8 rssi_thresh1)
+{
+	struct rtl_priv *rtlpriv = btcoexist->adapter;
+	s32 wifi_rssi = 0;
+	u8 wifi_rssi_state = *pprewifi_rssi_state;
+
+	btcoexist->btc_get(btcoexist, BTC_GET_S4_WIFI_RSSI, &wifi_rssi);
+
+	if (level_num == 2) {
+		if ((*pprewifi_rssi_state == BTC_RSSI_STATE_LOW) ||
+		    (*pprewifi_rssi_state == BTC_RSSI_STATE_STAY_LOW)) {
+			if (wifi_rssi >= (rssi_thresh +
+					  BTC_RSSI_COEX_THRESH_TOL_8822B_1ANT))
+				wifi_rssi_state = BTC_RSSI_STATE_HIGH;
+			else
+				wifi_rssi_state = BTC_RSSI_STATE_STAY_LOW;
+		} else {
+			if (wifi_rssi < rssi_thresh)
+				wifi_rssi_state = BTC_RSSI_STATE_LOW;
+			else
+				wifi_rssi_state = BTC_RSSI_STATE_STAY_HIGH;
+		}
+	} else if (level_num == 3) {
+		if (rssi_thresh > rssi_thresh1) {
+			RT_TRACE(rtlpriv, COMP_BT_COEXIST, DBG_LOUD,
+				 "[BTCoex], wifi RSSI thresh error!!\n");
+			return *pprewifi_rssi_state;
+		}
+
+		if ((*pprewifi_rssi_state == BTC_RSSI_STATE_LOW) ||
+		    (*pprewifi_rssi_state == BTC_RSSI_STATE_STAY_LOW)) {
+			if (wifi_rssi >= (rssi_thresh +
+					  BTC_RSSI_COEX_THRESH_TOL_8822B_1ANT))
+				wifi_rssi_state = BTC_RSSI_STATE_MEDIUM;
+			else
+				wifi_rssi_state = BTC_RSSI_STATE_STAY_LOW;
+		} else if ((*pprewifi_rssi_state == BTC_RSSI_STATE_MEDIUM) ||
+			   (*pprewifi_rssi_state ==
+			    BTC_RSSI_STATE_STAY_MEDIUM)) {
+			if (wifi_rssi >= (rssi_thresh1 +
+					  BTC_RSSI_COEX_THRESH_TOL_8822B_1ANT))
+				wifi_rssi_state = BTC_RSSI_STATE_HIGH;
+			else if (wifi_rssi < rssi_thresh)
+				wifi_rssi_state = BTC_RSSI_STATE_LOW;
+			else
+				wifi_rssi_state = BTC_RSSI_STATE_STAY_MEDIUM;
+		} else {
+			if (wifi_rssi < rssi_thresh1)
+				wifi_rssi_state = BTC_RSSI_STATE_MEDIUM;
+			else
+				wifi_rssi_state = BTC_RSSI_STATE_STAY_HIGH;
+		}
+	}
+
+	*pprewifi_rssi_state = wifi_rssi_state;
+
+	return wifi_rssi_state;
+}
+
+/* rx agg size setting :
+ * 1:      true / don't care / don't care
+ * max: false / false / don't care
+ * 7:     false / true / 7
+ */
+
+static void halbtc8822b1ant_limited_rx(struct btc_coexist *btcoexist,
+				       bool force_exec,
+				       bool rej_ap_agg_pkt,
+				       bool bt_ctrl_agg_buf_size,
+				       u8 agg_buf_size)
+{
+	bool reject_rx_agg = rej_ap_agg_pkt;
+	bool bt_ctrl_rx_agg_size = bt_ctrl_agg_buf_size;
+	u8 rx_agg_size = agg_buf_size;
+
+	/* ============================================ */
+	/*	Rx Aggregation related setting */
+	/* ============================================ */
+	btcoexist->btc_set(btcoexist, BTC_SET_BL_TO_REJ_AP_AGG_PKT,
+			   &reject_rx_agg);
+	/* decide BT control aggregation buf size or not */
+	btcoexist->btc_set(btcoexist, BTC_SET_BL_BT_CTRL_AGG_SIZE,
+			   &bt_ctrl_rx_agg_size);
+	/* aggregation buf size, only work when BT control Rx aggregation size*/
+	btcoexist->btc_set(btcoexist, BTC_SET_U1_AGG_BUF_SIZE, &rx_agg_size);
+	/* real update aggregation setting */
+	btcoexist->btc_set(btcoexist, BTC_SET_ACT_AGGREGATE_CTRL, NULL);
+}
+
+static void halbtc8822b1ant_query_bt_info(struct btc_coexist *btcoexist)
+{
+	struct rtl_priv *rtlpriv = btcoexist->adapter;
+	u8 h2c_parameter[1] = {0};
+
+	if (coex_sta->bt_disabled) {
+		RT_TRACE(rtlpriv, COMP_BT_COEXIST, DBG_LOUD,
+			 "[BTCoex], No query BT info because BT is disabled!\n");
+		return;
+	}
+
+	h2c_parameter[0] |= BIT(0); /* trigger */
+
+	btcoexist->btc_fill_h2c(btcoexist, 0x61, 1, h2c_parameter);
+
+	RT_TRACE(rtlpriv, COMP_BT_COEXIST, DBG_LOUD,
+		 "[BTCoex], WL query BT info!!\n");
+}
+
+static void halbtc8822b1ant_monitor_bt_ctr(struct btc_coexist *btcoexist)
+{
+	struct rtl_priv *rtlpriv = btcoexist->adapter;
+	u32	reg_hp_txrx, reg_lp_txrx, u32tmp;
+	u32	reg_hp_tx = 0, reg_hp_rx = 0, reg_lp_tx = 0, reg_lp_rx = 0;
+	static u8	num_of_bt_counter_chk, cnt_slave, cnt_autoslot_hang;
+	struct btc_bt_link_info *bt_link_info = &btcoexist->bt_link_info;
+
+	reg_hp_txrx = 0x770;
+	reg_lp_txrx = 0x774;
+
+	u32tmp = btcoexist->btc_read_4byte(btcoexist, reg_hp_txrx);
+	reg_hp_tx = u32tmp & MASKLWORD;
+	reg_hp_rx = (u32tmp & MASKHWORD) >> 16;
+
+	u32tmp = btcoexist->btc_read_4byte(btcoexist, reg_lp_txrx);
+	reg_lp_tx = u32tmp & MASKLWORD;
+	reg_lp_rx = (u32tmp & MASKHWORD) >> 16;
+
+	coex_sta->high_priority_tx = reg_hp_tx;
+	coex_sta->high_priority_rx = reg_hp_rx;
+	coex_sta->low_priority_tx = reg_lp_tx;
+	coex_sta->low_priority_rx = reg_lp_rx;
+
+	RT_TRACE(rtlpriv, COMP_BT_COEXIST, DBG_LOUD,
+		 "[BTCoex], Hi-Pri Rx/Tx: %d/%d, Lo-Pri Rx/Tx: %d/%d\n",
+		 reg_hp_rx, reg_hp_tx, reg_lp_rx, reg_lp_tx);
+
+	/* reset counter */
+	btcoexist->btc_write_1byte(btcoexist, 0x76e, 0xc);
+
+	if (coex_sta->low_priority_tx > 1150 &&
+	    !coex_sta->c2h_bt_inquiry_page)
+		coex_sta->pop_event_cnt++;
+
+	if (coex_sta->low_priority_rx >= 1150 &&
+	    coex_sta->low_priority_rx >= coex_sta->low_priority_tx &&
+	    !coex_sta->under_ips && !coex_sta->c2h_bt_inquiry_page &&
+	    coex_sta->bt_link_exist) {
+		if (cnt_slave >= 3) {
+			bt_link_info->slave_role = true;
+			cnt_slave = 3;
+		} else {
+			cnt_slave++;
+		}
+	} else {
+		if (cnt_slave == 0) {
+			bt_link_info->slave_role = false;
+			cnt_slave = 0;
+		} else {
+			cnt_slave--;
+		}
+	}
+
+	if (coex_sta->is_tdma_btautoslot) {
+		if (coex_sta->low_priority_tx >= 1300 &&
+		    coex_sta->low_priority_rx <= 150) {
+			if (cnt_autoslot_hang >= 2) {
+				coex_sta->is_tdma_btautoslot_hang = true;
+				cnt_autoslot_hang = 2;
+			} else {
+				cnt_autoslot_hang++;
+			}
+		} else {
+			if (cnt_autoslot_hang == 0) {
+				coex_sta->is_tdma_btautoslot_hang = false;
+				cnt_autoslot_hang = 0;
+			} else {
+				cnt_autoslot_hang--;
+			}
+		}
+	}
+
+	if (bt_link_info->hid_only) {
+		if (coex_sta->low_priority_tx > 50)
+			coex_sta->is_hid_low_pri_tx_overhead = true;
+		else
+			coex_sta->is_hid_low_pri_tx_overhead = false;
+	}
+
+	if (coex_sta->high_priority_tx == 0 &&
+	    coex_sta->high_priority_rx == 0 &&
+	    coex_sta->low_priority_tx == 0 &&
+	    coex_sta->low_priority_rx == 0) {
+		num_of_bt_counter_chk++;
+
+		if (num_of_bt_counter_chk >= 3) {
+			halbtc8822b1ant_query_bt_info(btcoexist);
+			num_of_bt_counter_chk = 0;
+		}
+	}
+}
+
+static void halbtc8822b1ant_monitor_wifi_ctr(struct btc_coexist *btcoexist)
+{
+	s32	wifi_rssi = 0;
+	bool	wifi_busy = false, wifi_under_b_mode = false, wifi_scan = false;
+	static u8 wl_noisy_count0, wl_noisy_count1 = 3, wl_noisy_count2;
+	u32	cnt_cck;
+	static u8 cnt_ccklocking;
+	u8	h2c_parameter[1] = {0};
+	struct btc_bt_link_info *bt_link_info = &btcoexist->bt_link_info;
+
+	/* Only enable for windows becaus 8821cu H2C 0x69 unknown fail @linux */
+	if (btcoexist->chip_interface != BTC_INTF_USB) {
+		/*send h2c to query WL FW dbg info  */
+		if ((coex_dm->cur_ps_tdma_on && coex_sta->force_lps_ctrl) ||
+		    (coex_sta->acl_busy && bt_link_info->a2dp_exist)) {
+			h2c_parameter[0] = 0x8;
+			btcoexist->btc_fill_h2c(btcoexist, 0x69, 1,
+						h2c_parameter);
+		}
+	}
+
+	btcoexist->btc_get(btcoexist, BTC_GET_BL_WIFI_BUSY, &wifi_busy);
+	btcoexist->btc_get(btcoexist, BTC_GET_S4_WIFI_RSSI, &wifi_rssi);
+	btcoexist->btc_get(btcoexist, BTC_GET_BL_WIFI_UNDER_B_MODE,
+			   &wifi_under_b_mode);
+
+	btcoexist->btc_get(btcoexist, BTC_GET_BL_WIFI_SCAN, &wifi_scan);
+
+	coex_sta->crc_ok_cck =
+		btcoexist->btc_phydm_query_phy_counter(btcoexist,
+						       DM_INFO_CRC32_OK_CCK);
+	coex_sta->crc_ok_11g =
+	    btcoexist->btc_phydm_query_phy_counter(btcoexist,
+						   DM_INFO_CRC32_OK_LEGACY);
+	coex_sta->crc_ok_11n =
+		btcoexist->btc_phydm_query_phy_counter(btcoexist,
+						       DM_INFO_CRC32_OK_HT);
+	coex_sta->crc_ok_11n_vht =
+		btcoexist->btc_phydm_query_phy_counter(btcoexist,
+						       DM_INFO_CRC32_OK_VHT);
+
+	coex_sta->crc_err_cck =
+	    btcoexist->btc_phydm_query_phy_counter(btcoexist,
+						   DM_INFO_CRC32_ERROR_CCK);
+	coex_sta->crc_err_11g =
+	  btcoexist->btc_phydm_query_phy_counter(btcoexist,
+						 DM_INFO_CRC32_ERROR_LEGACY);
+	coex_sta->crc_err_11n =
+	    btcoexist->btc_phydm_query_phy_counter(btcoexist,
+						   DM_INFO_CRC32_ERROR_HT);
+	coex_sta->crc_err_11n_vht =
+	    btcoexist->btc_phydm_query_phy_counter(btcoexist,
+						    DM_INFO_CRC32_ERROR_VHT);
+
+	/* CCK lock identification */
+	if (coex_sta->cck_lock)
+		cnt_ccklocking++;
+	else if (cnt_ccklocking != 0)
+		cnt_ccklocking--;
+
+	if (cnt_ccklocking >= 3) {
+		cnt_ccklocking = 3;
+		coex_sta->cck_lock_ever = true;
+	}
+
+	/* WiFi environment noisy identification */
+	cnt_cck = coex_sta->crc_ok_cck + coex_sta->crc_err_cck;
+
+	if (!wifi_busy && !coex_sta->cck_lock) {
+		if (cnt_cck > 250) {
+			if (wl_noisy_count2 < 3)
+				wl_noisy_count2++;
+
+			if (wl_noisy_count2 == 3) {
+				wl_noisy_count0 = 0;
+				wl_noisy_count1 = 0;
+			}
+
+		} else if (cnt_cck < 50) {
+			if (wl_noisy_count0 < 3)
+				wl_noisy_count0++;
+
+			if (wl_noisy_count0 == 3) {
+				wl_noisy_count1 = 0;
+				wl_noisy_count2 = 0;
+			}
+
+		} else {
+			if (wl_noisy_count1 < 3)
+				wl_noisy_count1++;
+
+			if (wl_noisy_count1 == 3) {
+				wl_noisy_count0 = 0;
+				wl_noisy_count2 = 0;
+			}
+		}
+
+		if (wl_noisy_count2 == 3)
+			coex_sta->wl_noisy_level = 2;
+		else if (wl_noisy_count1 == 3)
+			coex_sta->wl_noisy_level = 1;
+		else
+			coex_sta->wl_noisy_level = 0;
+	}
+}
+
+static bool
+halbtc8822b1ant_is_wifibt_status_changed(struct btc_coexist *btcoexist)
+{
+	struct rtl_priv *rtlpriv = btcoexist->adapter;
+	static bool pre_wifi_busy, pre_under_4way,
+		       pre_bt_hs_on, pre_rf4ce_enabled,
+		       pre_bt_off, pre_bt_slave,
+		       pre_hid_low_pri_tx_overhead,
+		       pre_wifi_under_lps, pre_bt_setup_link;
+	static u8 pre_hid_busy_num, pre_wl_noisy_level;
+	bool wifi_busy = false, under_4way = false, bt_hs_on = false,
+		rf4ce_enabled = false;
+	bool wifi_connected = false;
+	struct btc_bt_link_info *bt_link_info = &btcoexist->bt_link_info;
+	static u8 cnt_wifi_busytoidle;
+	u32 wifi_link_status = 0, num_of_wifi_link = 0;
+	static u32 pre_num_of_wifi_link;
+
+	btcoexist->btc_get(btcoexist, BTC_GET_BL_WIFI_CONNECTED,
+			   &wifi_connected);
+	btcoexist->btc_get(btcoexist, BTC_GET_BL_WIFI_BUSY, &wifi_busy);
+	btcoexist->btc_get(btcoexist, BTC_GET_BL_HS_OPERATION, &bt_hs_on);
+	btcoexist->btc_get(btcoexist, BTC_GET_BL_WIFI_4_WAY_PROGRESS,
+			   &under_4way);
+	btcoexist->btc_get(btcoexist, BTC_GET_U4_WIFI_LINK_STATUS,
+			   &wifi_link_status);
+
+	if (wifi_busy) {
+		coex_sta->gl_wifi_busy = true;
+		cnt_wifi_busytoidle = 3;
+	} else {
+		if (coex_sta->gl_wifi_busy && cnt_wifi_busytoidle > 0)
+			cnt_wifi_busytoidle--;
+		else if (cnt_wifi_busytoidle == 0)
+			coex_sta->gl_wifi_busy = false;
+	}
+
+	if (coex_sta->bt_disabled != pre_bt_off) {
+		pre_bt_off = coex_sta->bt_disabled;
+
+		if (coex_sta->bt_disabled)
+			RT_TRACE(rtlpriv, COMP_BT_COEXIST, DBG_LOUD,
+				 "[BTCoex], BT is disabled !!\n");
+		else
+			RT_TRACE(rtlpriv, COMP_BT_COEXIST, DBG_LOUD,
+				 "[BTCoex], BT is enabled !!\n");
+
+		coex_sta->bt_coex_supported_feature = 0;
+		coex_sta->bt_coex_supported_version = 0;
+		coex_sta->bt_ble_scan_type = 0;
+		coex_sta->bt_ble_scan_para[0] = 0;
+		coex_sta->bt_ble_scan_para[1] = 0;
+		coex_sta->bt_ble_scan_para[2] = 0;
+		coex_sta->bt_reg_vendor_ac = 0xffff;
+		coex_sta->bt_reg_vendor_ae = 0xffff;
+		coex_sta->legacy_forbidden_slot = 0;
+		coex_sta->le_forbidden_slot = 0;
+		coex_sta->bt_a2dp_vendor_id = 0;
+		coex_sta->bt_a2dp_device_name = 0;
+		return true;
+	}
+
+	num_of_wifi_link = wifi_link_status >> 16;
+
+	if (num_of_wifi_link != pre_num_of_wifi_link) {
+		pre_num_of_wifi_link = num_of_wifi_link;
+		return true;
+	}
+
+	btcoexist->btc_get(btcoexist, BTC_GET_BL_RF4CE_CONNECTED,
+			   &rf4ce_enabled);
+
+	if (rf4ce_enabled != pre_rf4ce_enabled) {
+		pre_rf4ce_enabled = rf4ce_enabled;
+
+		if (rf4ce_enabled)
+			RT_TRACE(rtlpriv, COMP_BT_COEXIST, DBG_LOUD,
+				 "[BTCoex], rf4ce is enabled !!\n");
+		else
+			RT_TRACE(rtlpriv, COMP_BT_COEXIST, DBG_LOUD,
+				 "[BTCoex], rf4ce is disabled !!\n");
+
+		return true;
+	}
+
+	if (wifi_connected) {
+		if (wifi_busy != pre_wifi_busy) {
+			pre_wifi_busy = wifi_busy;
+			return true;
+		}
+		if (under_4way != pre_under_4way) {
+			pre_under_4way = under_4way;
+			return true;
+		}
+		if (bt_hs_on != pre_bt_hs_on) {
+			pre_bt_hs_on = bt_hs_on;
+			return true;
+		}
+		if (coex_sta->wl_noisy_level != pre_wl_noisy_level) {
+			pre_wl_noisy_level = coex_sta->wl_noisy_level;
+			return true;
+		}
+		if (coex_sta->under_lps != pre_wifi_under_lps) {
+			pre_wifi_under_lps = coex_sta->under_lps;
+			if (coex_sta->under_lps)
+				return true;
+		}
+	}
+
+	if (!coex_sta->bt_disabled) {
+		if (coex_sta->hid_busy_num != pre_hid_busy_num) {
+			pre_hid_busy_num = coex_sta->hid_busy_num;
+			return true;
+		}
+
+		if (bt_link_info->slave_role != pre_bt_slave) {
+			pre_bt_slave = bt_link_info->slave_role;
+			return true;
+		}
+
+		if (pre_hid_low_pri_tx_overhead !=
+		    coex_sta->is_hid_low_pri_tx_overhead) {
+			pre_hid_low_pri_tx_overhead =
+				coex_sta->is_hid_low_pri_tx_overhead;
+			return true;
+		}
+
+		if (pre_bt_setup_link != coex_sta->is_setup_link) {
+			pre_bt_setup_link = coex_sta->is_setup_link;
+			return true;
+		}
+	}
+
+	return false;
+}
+
+static void halbtc8822b1ant_update_bt_link_info(struct btc_coexist *btcoexist)
+{
+	struct rtl_priv *rtlpriv = btcoexist->adapter;
+	struct btc_bt_link_info *bt_link_info = &btcoexist->bt_link_info;
+	bool bt_hs_on = false;
+	bool bt_busy = false;
+	u32 val = 0;
+	static u8 pre_num_of_profile, cur_num_of_profile, cnt;
+	bool increase_scan_dev_num = false;
+
+	if (coex_sta->is_ble_scan_toggle) {
+		u32 *p = NULL;
+		u8 scantype;
+
+		RT_TRACE(rtlpriv, COMP_BT_COEXIST, DBG_LOUD,
+			 "[BTCoex], BT ext info bit4 check, query BLE Scan type!!\n");
+		coex_sta->bt_ble_scan_type =
+			btcoexist->btc_get_ble_scan_type_from_bt(btcoexist);
+
+		if ((coex_sta->bt_ble_scan_type & 0x1) == 0x1) {
+			p = &coex_sta->bt_ble_scan_para[0];
+			scantype = 0x1;
+		}
+
+		if ((coex_sta->bt_ble_scan_type & 0x2) == 0x2) {
+			p = &coex_sta->bt_ble_scan_para[1];
+			scantype = 0x2;
+		}
+
+		if ((coex_sta->bt_ble_scan_type & 0x4) == 0x4) {
+			p = &coex_sta->bt_ble_scan_para[2];
+			scantype = 0x4;
+		}
+
+		if (p)
+			*p = btcoexist->btc_get_ble_scan_para_from_bt(btcoexist,
+								      scantype);
+	}
+
+	coex_sta->num_of_profile = 0;
+
+	/* set link exist status */
+	if (!(coex_sta->bt_info & BT_INFO_8822B_1ANT_B_CONNECTION)) {
+		coex_sta->bt_link_exist = false;
+		coex_sta->pan_exist = false;
+		coex_sta->a2dp_exist = false;
+		coex_sta->hid_exist = false;
+		coex_sta->sco_exist = false;
+		coex_sta->msft_mr_exist = false;
+	} else { /* connection exists */
+		coex_sta->bt_link_exist = true;
+		if (coex_sta->bt_info & BT_INFO_8822B_1ANT_B_FTP) {
+			coex_sta->pan_exist = true;
+			coex_sta->num_of_profile++;
+		} else {
+			coex_sta->pan_exist = false;
+		}
+
+		if (coex_sta->bt_info & BT_INFO_8822B_1ANT_B_A2DP) {
+			coex_sta->a2dp_exist = true;
+			coex_sta->num_of_profile++;
+		} else {
+			coex_sta->a2dp_exist = false;
+		}
+
+		if (coex_sta->bt_info & BT_INFO_8822B_1ANT_B_HID) {
+			coex_sta->hid_exist = true;
+			coex_sta->num_of_profile++;
+		} else {
+			coex_sta->hid_exist = false;
+		}
+
+		if (coex_sta->bt_info & BT_INFO_8822B_1ANT_B_SCO_ESCO) {
+			coex_sta->sco_exist = true;
+			coex_sta->num_of_profile++;
+		} else {
+			coex_sta->sco_exist = false;
+		}
+
+		if (coex_sta->hid_busy_num == 0 &&
+		    coex_sta->hid_pair_cnt > 0)
+			coex_sta->msft_mr_exist = true;
+		else
+			coex_sta->msft_mr_exist = false;
+	}
+
+	btcoexist->btc_get(btcoexist, BTC_GET_BL_HS_OPERATION, &bt_hs_on);
+
+	bt_link_info->bt_link_exist = coex_sta->bt_link_exist;
+	bt_link_info->sco_exist = coex_sta->sco_exist;
+	bt_link_info->a2dp_exist = coex_sta->a2dp_exist;
+	bt_link_info->pan_exist = coex_sta->pan_exist;
+	bt_link_info->hid_exist = coex_sta->hid_exist;
+	bt_link_info->acl_busy = coex_sta->acl_busy;
+
+	/* work around for HS mode. */
+	if (bt_hs_on) {
+		bt_link_info->pan_exist = true;
+		bt_link_info->bt_link_exist = true;
+	}
+
+	/* check if Sco only */
+	if (bt_link_info->sco_exist && !bt_link_info->a2dp_exist &&
+	    !bt_link_info->pan_exist && !bt_link_info->hid_exist)
+		bt_link_info->sco_only = true;
+	else
+		bt_link_info->sco_only = false;
+
+	/* check if A2dp only */
+	if (!bt_link_info->sco_exist && bt_link_info->a2dp_exist &&
+	    !bt_link_info->pan_exist && !bt_link_info->hid_exist)
+		bt_link_info->a2dp_only = true;
+	else
+		bt_link_info->a2dp_only = false;
+
+	/* check if Pan only */
+	if (!bt_link_info->sco_exist && !bt_link_info->a2dp_exist &&
+	    bt_link_info->pan_exist && !bt_link_info->hid_exist)
+		bt_link_info->pan_only = true;
+	else
+		bt_link_info->pan_only = false;
+
+	/* check if Hid only */
+	if (!bt_link_info->sco_exist && !bt_link_info->a2dp_exist &&
+	    !bt_link_info->pan_exist && bt_link_info->hid_exist)
+		bt_link_info->hid_only = true;
+	else
+		bt_link_info->hid_only = false;
+
+	if (coex_sta->bt_info & BT_INFO_8822B_1ANT_B_INQ_PAGE) {
+		coex_dm->bt_status = BT_8822B_1ANT_BT_STATUS_INQ_PAGE;
+		RT_TRACE(rtlpriv, COMP_BT_COEXIST, DBG_LOUD,
+			 "[BTCoex], BtInfoNotify(), BT Inq/page!!!\n");
+	} else if (!(coex_sta->bt_info & BT_INFO_8822B_1ANT_B_CONNECTION)) {
+		coex_dm->bt_status = BT_8822B_1ANT_BT_STATUS_NCONNECTED_IDLE;
+		RT_TRACE(rtlpriv, COMP_BT_COEXIST, DBG_LOUD,
+			 "[BTCoex], BtInfoNotify(), BT Non-Connected idle!!!\n");
+	} else if (coex_sta->bt_info == BT_INFO_8822B_1ANT_B_CONNECTION) {
+		/* connection exists but no busy */
+
+		if (coex_sta->msft_mr_exist) {
+			coex_dm->bt_status = BT_8822B_1ANT_BT_STATUS_ACL_BUSY;
+			RT_TRACE(rtlpriv, COMP_BT_COEXIST, DBG_LOUD,
+				 "[BTCoex], BtInfoNotify(),  BT ACL busy!!\n");
+		} else {
+			coex_dm->bt_status =
+				BT_8822B_1ANT_BT_STATUS_CONNECTED_IDLE;
+			RT_TRACE(rtlpriv, COMP_BT_COEXIST, DBG_LOUD,
+				 "[BTCoex], BtInfoNotify(), BT Connected-idle!!!\n");
+		}
+	} else if (((coex_sta->bt_info & BT_INFO_8822B_1ANT_B_SCO_ESCO) ||
+		    (coex_sta->bt_info & BT_INFO_8822B_1ANT_B_SCO_BUSY)) &&
+		   (coex_sta->bt_info & BT_INFO_8822B_1ANT_B_ACL_BUSY)) {
+		coex_dm->bt_status = BT_8822B_1ANT_BT_STATUS_ACL_SCO_BUSY;
+		RT_TRACE(rtlpriv, COMP_BT_COEXIST, DBG_LOUD,
+			 "[BTCoex], BtInfoNotify(), BT ACL SCO busy!!!\n");
+	} else if ((coex_sta->bt_info & BT_INFO_8822B_1ANT_B_SCO_ESCO) ||
+		   (coex_sta->bt_info & BT_INFO_8822B_1ANT_B_SCO_BUSY)) {
+		coex_dm->bt_status = BT_8822B_1ANT_BT_STATUS_SCO_BUSY;
+		RT_TRACE(rtlpriv, COMP_BT_COEXIST, DBG_LOUD,
+			 "[BTCoex], BtInfoNotify(), BT SCO busy!!!\n");
+	} else if (coex_sta->bt_info & BT_INFO_8822B_1ANT_B_ACL_BUSY) {
+		coex_dm->bt_status = BT_8822B_1ANT_BT_STATUS_ACL_BUSY;
+		RT_TRACE(rtlpriv, COMP_BT_COEXIST, DBG_LOUD,
+			 "[BTCoex], BtInfoNotify(), BT ACL busy!!!\n");
+	} else {
+		coex_dm->bt_status = BT_8822B_1ANT_BT_STATUS_MAX;
+		RT_TRACE(rtlpriv, COMP_BT_COEXIST, DBG_LOUD,
+			 "[BTCoex], BtInfoNotify(), BT Non-Defined state!!!\n");
+	}
+
+	if (coex_dm->bt_status == BT_8822B_1ANT_BT_STATUS_ACL_BUSY ||
+	    coex_dm->bt_status == BT_8822B_1ANT_BT_STATUS_SCO_BUSY ||
+	    coex_dm->bt_status == BT_8822B_1ANT_BT_STATUS_ACL_SCO_BUSY) {
+		bt_busy = true;
+		increase_scan_dev_num = true;
+	} else {
+		bt_busy = false;
+		increase_scan_dev_num = false;
+	}
+
+	btcoexist->btc_set(btcoexist, BTC_SET_BL_BT_TRAFFIC_BUSY, &bt_busy);
+	btcoexist->btc_set(btcoexist, BTC_SET_BL_INC_SCAN_DEV_NUM,
+			   &increase_scan_dev_num);
+
+	cur_num_of_profile = coex_sta->num_of_profile;
+
+	if (cur_num_of_profile != pre_num_of_profile)
+		cnt = 2;
+
+	if (bt_link_info->a2dp_exist) {
+		if ((coex_sta->bt_a2dp_vendor_id == 0 &&
+		     coex_sta->bt_a2dp_device_name == 0) ||
+		    cur_num_of_profile != pre_num_of_profile) {
+			btcoexist->btc_get(btcoexist, BTC_GET_U4_BT_DEVICE_INFO,
+					   &val);
+
+			RT_TRACE(rtlpriv, COMP_BT_COEXIST, DBG_LOUD,
+				 "[BTCoex], BtInfoNotify(), get BT DEVICE_INFO = %x\n",
+				 val);
+
+			coex_sta->bt_a2dp_vendor_id = (u8)(val & 0xff);
+			coex_sta->bt_a2dp_device_name = (val & 0xffffff00) >> 8;
+		}
+
+		if ((coex_sta->legacy_forbidden_slot == 0 &&
+		     coex_sta->le_forbidden_slot == 0) ||
+		    cur_num_of_profile != pre_num_of_profile || cnt > 0) {
+			if (cnt > 0)
+				cnt--;
+
+			btcoexist->btc_get(btcoexist,
+					   BTC_GET_U4_BT_FORBIDDEN_SLOT_VAL,
+					   &val);
+
+			RT_TRACE(rtlpriv, COMP_BT_COEXIST, DBG_LOUD,
+				 "[BTCoex], BtInfoNotify(), get BT FORBIDDEN_SLOT_VAL = %x\n",
+				 val);
+
+			coex_sta->legacy_forbidden_slot = (u16)(val & 0xffff);
+			coex_sta->le_forbidden_slot =
+				(u16)((val & 0xffff0000) >> 16);
+		}
+	}
+
+	pre_num_of_profile = coex_sta->num_of_profile;
+}
+
+static void
+halbtc8822b1ant_update_wifi_ch_info(struct btc_coexist *btcoexist, u8 type)
+{
+	struct rtl_priv *rtlpriv = btcoexist->adapter;
+	u8 h2c_parameter[3] = {0}, i;
+	u32 wifi_bw;
+	u8 wifi_central_chnl = 0;
+	u8 wifi_5g_chnl[19] = {120, 124, 128, 132, 136, 140, 144, 149, 153, 157,
+			       118, 126, 134, 142, 151, 159, 122, 138, 155};
+	u8 bt_skip_cneter_chanl[19] = {2, 8,  17, 26, 34, 42, 51, 62, 71, 77,
+				       2, 12, 29, 46, 66, 76, 10, 37, 68};
+	u8 bt_skip_span[19] = {4, 8,  8,  10, 8,  10, 8,  8,  10, 4,
+			       4, 16, 16, 16, 16, 4,  20, 34, 20};
+	bool wifi_under_5g = false;
+
+	btcoexist->btc_get(btcoexist, BTC_GET_U4_WIFI_BW, &wifi_bw);
+	btcoexist->btc_get(btcoexist, BTC_GET_BL_WIFI_UNDER_5G, &wifi_under_5g);
+
+	if (type == BTC_MEDIA_CONNECT) {
+		btcoexist->btc_get(btcoexist, BTC_GET_U1_WIFI_CENTRAL_CHNL,
+				   &wifi_central_chnl);
+		coex_sta->wl_center_channel = wifi_central_chnl;
+
+		if (!wifi_under_5g) {
+			h2c_parameter[0] = 0x1;
+			h2c_parameter[1] = wifi_central_chnl;
+
+			if (wifi_bw == BTC_WIFI_BW_HT40)
+				h2c_parameter[2] = 0x30;
+			else
+				h2c_parameter[2] = 0x30;
+		} else { /* for 5G  */
+
+			for (i = 0; i <= 18; i++) {
+				if (wifi_central_chnl == wifi_5g_chnl[i])
+					break;
+			}
+
+			if (i <= 18) {
+				h2c_parameter[0] = 0x3;
+				h2c_parameter[1] = bt_skip_cneter_chanl[i];
+				h2c_parameter[2] = bt_skip_span[i];
+			}
+		}
+	}
+
+	coex_dm->wifi_chnl_info[0] = h2c_parameter[0];
+	coex_dm->wifi_chnl_info[1] = h2c_parameter[1];
+	coex_dm->wifi_chnl_info[2] = h2c_parameter[2];
+
+	btcoexist->btc_fill_h2c(btcoexist, 0x66, 3, h2c_parameter);
+
+	RT_TRACE(rtlpriv, COMP_BT_COEXIST, DBG_LOUD,
+		 "[BTCoex], para[0:2] = 0x%x 0x%x 0x%x\n", h2c_parameter[0],
+		 h2c_parameter[1], h2c_parameter[2]);
+}
+
+static u8 halbtc8822b1ant_action_algorithm(struct btc_coexist *btcoexist)
+{
+	struct rtl_priv *rtlpriv = btcoexist->adapter;
+	struct btc_bt_link_info *bt_link_info = &btcoexist->bt_link_info;
+	bool bt_hs_on = false;
+	u8 algorithm = BT_8822B_1ANT_COEX_UNDEFINED;
+	u8 num_of_diff_profile = 0;
+
+	btcoexist->btc_get(btcoexist, BTC_GET_BL_HS_OPERATION, &bt_hs_on);
+
+	if (!bt_link_info->bt_link_exist) {
+		RT_TRACE(rtlpriv, COMP_BT_COEXIST, DBG_LOUD,
+			 "[BTCoex], No BT link exists!!!\n");
+		return algorithm;
+	}
+
+	if (bt_link_info->sco_exist)
+		num_of_diff_profile++;
+	if (bt_link_info->hid_exist)
+		num_of_diff_profile++;
+	if (bt_link_info->pan_exist)
+		num_of_diff_profile++;
+	if (bt_link_info->a2dp_exist)
+		num_of_diff_profile++;
+
+	if (num_of_diff_profile == 1) {
+		if (bt_link_info->sco_exist) {
+			RT_TRACE(rtlpriv, COMP_BT_COEXIST, DBG_LOUD,
+				 "[BTCoex], BT Profile = SCO only\n");
+			algorithm = BT_8822B_1ANT_COEX_SCO;
+		} else {
+			if (bt_link_info->hid_exist) {
+				RT_TRACE(rtlpriv, COMP_BT_COEXIST, DBG_LOUD,
+					 "[BTCoex], BT Profile = HID only\n");
+				algorithm = BT_8822B_1ANT_COEX_HID;
+			} else if (bt_link_info->a2dp_exist) {
+				RT_TRACE(rtlpriv, COMP_BT_COEXIST, DBG_LOUD,
+					 "[BTCoex], BT Profile = A2DP only\n");
+				algorithm = BT_8822B_1ANT_COEX_A2DP;
+			} else if (bt_link_info->pan_exist) {
+				if (bt_hs_on) {
+					RT_TRACE(rtlpriv, COMP_BT_COEXIST,
+						 DBG_LOUD,
+						    "[BTCoex], BT Profile = PAN(HS) only\n");
+					algorithm =
+						BT_8822B_1ANT_COEX_PANHS;
+				} else {
+					RT_TRACE(rtlpriv, COMP_BT_COEXIST,
+						 DBG_LOUD,
+						    "[BTCoex], BT Profile = PAN(EDR) only\n");
+					algorithm = BT_8822B_1ANT_COEX_PAN;
+				}
+			}
+		}
+	} else if (num_of_diff_profile == 2) {
+		if (bt_link_info->sco_exist) {
+			if (bt_link_info->hid_exist) {
+				RT_TRACE(rtlpriv, COMP_BT_COEXIST, DBG_LOUD,
+					 "[BTCoex], BT Profile = SCO + HID\n");
+				algorithm = BT_8822B_1ANT_COEX_HID;
+			} else if (bt_link_info->a2dp_exist) {
+				RT_TRACE(rtlpriv, COMP_BT_COEXIST, DBG_LOUD,
+					 "[BTCoex], BT Profile = SCO + A2DP ==> SCO\n");
+				algorithm = BT_8822B_1ANT_COEX_SCO;
+			} else if (bt_link_info->pan_exist) {
+				if (bt_hs_on) {
+					RT_TRACE(rtlpriv, COMP_BT_COEXIST,
+						 DBG_LOUD,
+						    "[BTCoex], BT Profile = SCO + PAN(HS)\n");
+					algorithm = BT_8822B_1ANT_COEX_SCO;
+				} else {
+					RT_TRACE(rtlpriv, COMP_BT_COEXIST,
+						 DBG_LOUD,
+						    "[BTCoex], BT Profile = SCO + PAN(EDR)\n");
+					algorithm = BT_8822B_1ANT_COEX_PAN_HID;
+				}
+			}
+		} else {
+			if (bt_link_info->hid_exist &&
+			    bt_link_info->a2dp_exist) {
+				RT_TRACE(rtlpriv, COMP_BT_COEXIST, DBG_LOUD,
+					 "[BTCoex], BT Profile = HID + A2DP\n");
+				algorithm = BT_8822B_1ANT_COEX_HID_A2DP;
+			} else if (bt_link_info->hid_exist &&
+				   bt_link_info->pan_exist) {
+				if (bt_hs_on) {
+					RT_TRACE(rtlpriv, COMP_BT_COEXIST,
+						 DBG_LOUD,
+						    "[BTCoex], BT Profile = HID + PAN(HS)\n");
+					algorithm =
+						BT_8822B_1ANT_COEX_HID_A2DP;
+				} else {
+					RT_TRACE(rtlpriv, COMP_BT_COEXIST,
+						 DBG_LOUD,
+						    "[BTCoex], BT Profile = HID + PAN(EDR)\n");
+					algorithm = BT_8822B_1ANT_COEX_PAN_HID;
+				}
+			} else if (bt_link_info->pan_exist &&
+				   bt_link_info->a2dp_exist) {
+				if (bt_hs_on) {
+					RT_TRACE(rtlpriv, COMP_BT_COEXIST,
+						 DBG_LOUD,
+						    "[BTCoex], BT Profile = A2DP + PAN(HS)\n");
+					algorithm =
+						BT_8822B_1ANT_COEX_A2DP_PANHS;
+				} else {
+					RT_TRACE(rtlpriv, COMP_BT_COEXIST,
+						 DBG_LOUD,
+						    "[BTCoex], BT Profile = A2DP + PAN(EDR)\n");
+					algorithm = BT_8822B_1ANT_COEX_PAN_A2DP;
+				}
+			}
+		}
+	} else if (num_of_diff_profile == 3) {
+		if (bt_link_info->sco_exist) {
+			if (bt_link_info->hid_exist &&
+			    bt_link_info->a2dp_exist) {
+				RT_TRACE(rtlpriv, COMP_BT_COEXIST, DBG_LOUD,
+					 "[BTCoex], BT Profile = SCO + HID + A2DP ==> HID\n");
+				algorithm = BT_8822B_1ANT_COEX_HID;
+			} else if (bt_link_info->hid_exist &&
+				   bt_link_info->pan_exist) {
+				if (bt_hs_on) {
+					RT_TRACE(rtlpriv, COMP_BT_COEXIST,
+						 DBG_LOUD,
+						    "[BTCoex], BT Profile = SCO + HID + PAN(HS)\n");
+					algorithm =
+						BT_8822B_1ANT_COEX_HID_A2DP;
+				} else {
+					RT_TRACE(rtlpriv, COMP_BT_COEXIST,
+						 DBG_LOUD,
+						    "[BTCoex], BT Profile = SCO + HID + PAN(EDR)\n");
+					algorithm = BT_8822B_1ANT_COEX_PAN_HID;
+				}
+			} else if (bt_link_info->pan_exist &&
+				   bt_link_info->a2dp_exist) {
+				if (bt_hs_on) {
+					RT_TRACE(rtlpriv, COMP_BT_COEXIST,
+						 DBG_LOUD,
+						    "[BTCoex], BT Profile = SCO + A2DP + PAN(HS)\n");
+					algorithm = BT_8822B_1ANT_COEX_SCO;
+				} else {
+					RT_TRACE(rtlpriv, COMP_BT_COEXIST,
+						 DBG_LOUD,
+						    "[BTCoex], BT Profile = SCO + A2DP + PAN(EDR) ==> HID\n");
+					algorithm = BT_8822B_1ANT_COEX_PAN_HID;
+				}
+			}
+		} else {
+			if (bt_link_info->hid_exist &&
+			    bt_link_info->pan_exist &&
+			    bt_link_info->a2dp_exist) {
+				if (bt_hs_on) {
+					RT_TRACE(rtlpriv, COMP_BT_COEXIST,
+						 DBG_LOUD,
+						    "[BTCoex], BT Profile = HID + A2DP + PAN(HS)\n");
+					algorithm =
+						BT_8822B_1ANT_COEX_HID_A2DP;
+				} else {
+					RT_TRACE(rtlpriv, COMP_BT_COEXIST,
+						 DBG_LOUD,
+						    "[BTCoex], BT Profile = HID + A2DP + PAN(EDR)\n");
+					algorithm =
+						BT_8822B_1ANT_COEX_HID_A2DP_PAN;
+				}
+			}
+		}
+	} else if (num_of_diff_profile >= 3) {
+		if (bt_link_info->sco_exist) {
+			if (bt_link_info->hid_exist &&
+			    bt_link_info->pan_exist &&
+			    bt_link_info->a2dp_exist) {
+				if (bt_hs_on) {
+					RT_TRACE(rtlpriv, COMP_BT_COEXIST,
+						 DBG_LOUD,
+						    "[BTCoex], Error!!! BT Profile = SCO + HID + A2DP + PAN(HS)\n");
+
+				} else {
+					RT_TRACE(rtlpriv, COMP_BT_COEXIST,
+						 DBG_LOUD,
+						    "[BTCoex], BT Profile = SCO + HID + A2DP + PAN(EDR)==>PAN(EDR)+HID\n");
+					algorithm = BT_8822B_1ANT_COEX_PAN_HID;
+				}
+			}
+		}
+	}
+
+	return algorithm;
+}
+
+static void halbtc8822b1ant_low_penalty_ra(struct btc_coexist *btcoexist,
+					   bool force_exec,
+					   bool low_penalty_ra)
+{
+	coex_dm->cur_low_penalty_ra = low_penalty_ra;
+
+	if (!force_exec) {
+		if (coex_dm->pre_low_penalty_ra == coex_dm->cur_low_penalty_ra)
+			return;
+	}
+
+	if (low_penalty_ra)
+		btcoexist->btc_phydm_modify_ra_pcr_threshold(btcoexist, 0, 10);
+	else
+		btcoexist->btc_phydm_modify_ra_pcr_threshold(btcoexist, 0, 0);
+
+	coex_dm->pre_low_penalty_ra = coex_dm->cur_low_penalty_ra;
+}
+
+static void halbtc8822b1ant_mimo_ps(struct btc_coexist *btcoexist,
+				    bool force_exec, u8 state)
+{
+	struct rtl_priv *rtlpriv = btcoexist->adapter;
+	static u8 pre_state;
+
+	if (!force_exec) {
+		if (state == pre_state)
+			return;
+	}
+
+	pre_state = state;
+
+	RT_TRACE(rtlpriv, COMP_BT_COEXIST, DBG_LOUD,
+		 "[BTCoex], %s(), state = %d\n", __func__, state);
+
+	btcoexist->btc_set(btcoexist, BTC_SET_MIMO_PS_MODE, &state);
+}
+
+static void halbtc8822b1ant_write_score_board(struct btc_coexist *btcoexist,
+					      u16 bitpos, bool state)
+{
+	struct rtl_priv *rtlpriv = btcoexist->adapter;
+	static u16 originalval = 0x8002, preval;
+
+	if (state)
+		originalval = originalval | bitpos;
+	else
+		originalval = originalval & (~bitpos);
+
+	coex_sta->score_board_WB = originalval;
+
+	if (originalval != preval) {
+		preval = originalval;
+		btcoexist->btc_write_2byte(btcoexist, 0xaa, originalval);
+	} else {
+		RT_TRACE(rtlpriv, COMP_BT_COEXIST, DBG_LOUD,
+			 "[BTCoex], %s: return for nochange\n", __func__);
+	}
+}
+
+static void halbtc8822b1ant_read_score_board(struct btc_coexist *btcoexist,
+					     u16 *score_board_val)
+{
+	*score_board_val =
+		(btcoexist->btc_read_2byte(btcoexist, 0xaa)) & 0x7fff;
+}
+
+static void halbtc8822b1ant_post_state_to_bt(struct btc_coexist *btcoexist,
+					     u16 type, bool state)
+{
+	halbtc8822b1ant_write_score_board(btcoexist, (u16)type, state);
+}
+
+static void halbtc8822b1ant_adjust_wl_tx_power(struct btc_coexist *btcoexist,
+					       bool force_exec,
+					       u8 fw_dac_swing_lvl)
+{
+	coex_dm->cur_fw_dac_swing_lvl = fw_dac_swing_lvl;
+
+	if (!force_exec) {
+		if (coex_dm->pre_fw_dac_swing_lvl ==
+		    coex_dm->cur_fw_dac_swing_lvl)
+			return;
+	}
+
+	btcoexist->btc_write_1byte_bitmask(btcoexist, 0xc5b, 0xff,
+					   fw_dac_swing_lvl);
+	btcoexist->btc_write_1byte_bitmask(btcoexist, 0xe5b, 0xff,
+					   fw_dac_swing_lvl);
+
+	coex_dm->pre_fw_dac_swing_lvl = coex_dm->cur_fw_dac_swing_lvl;
+}
+
+static void halbtc8822b1ant_adjust_bt_tx_power(struct btc_coexist *btcoexist,
+					       bool force_exec,
+					       u8 dec_bt_pwr_lvl)
+{
+	u8 h2c_parameter[1] = {0};
+
+	coex_dm->cur_bt_dec_pwr_lvl = dec_bt_pwr_lvl;
+
+	if (!force_exec) {
+		if (coex_dm->pre_bt_dec_pwr_lvl == coex_dm->cur_bt_dec_pwr_lvl)
+			return;
+	}
+
+	h2c_parameter[0] = 0 - dec_bt_pwr_lvl;
+
+	btcoexist->btc_fill_h2c(btcoexist, 0x62, 1, h2c_parameter);
+
+	coex_dm->pre_bt_dec_pwr_lvl = coex_dm->cur_bt_dec_pwr_lvl;
+}
+
+static void halbtc8822b1ant_adjust_wl_rx_gain(struct btc_coexist *btcoexist,
+					      bool force_exec,
+					      bool agc_table_en)
+{
+	struct rtl_priv *rtlpriv = btcoexist->adapter;
+	u32 rx_gain_value_enable[] = {
+		0xff000003, 0xea240003, 0xe9260003, 0xe8280003, 0xe72a0003,
+		0xe62c0003, 0xaf2e0003, 0xae300003, 0xad320003, 0xac340003,
+		0xab360003, 0x8d380003, 0x8c3a0003, 0x8b3c0003, 0x8a3e0003,
+		0x6e400003, 0x6d420003, 0x6c440003, 0x6b460003, 0x6a480003,
+		0x694a0003, 0x684c0003, 0x674e0003, 0x66500003, 0x65520003,
+		0x64540003, 0x64560003, 0x007e0403};
+
+	u32 rx_gain_value_disable[] = {
+		0xff000003, 0xeb240003, 0xea260003, 0xe9280003, 0xe82a0003,
+		0xe72c0003, 0xe62e0003, 0xe5300003, 0xc8320003, 0xc7340003,
+		0xc6360003, 0xc5380003, 0xc43a0003, 0xc33c0003, 0xc23e0003,
+		0xc1400003, 0xc0420003, 0xa5440003, 0xa4460003, 0xa3480003,
+		0xa24a0003, 0xa14c0003, 0x834e0003, 0x82500003, 0x81520003,
+		0x80540003, 0x65560003, 0x007e0403};
+
+	u8 i;
+
+	coex_dm->cur_agc_table_en = agc_table_en;
+
+	if (!force_exec) {
+		if (coex_dm->pre_agc_table_en == coex_dm->cur_agc_table_en)
+			return;
+	}
+
+	if (agc_table_en) {
+		RT_TRACE(rtlpriv, COMP_BT_COEXIST, DBG_LOUD,
+			 "[BTCoex], BB Agc Table On!\n");
+
+		for (i = 0; i < ARRAY_SIZE(rx_gain_value_enable); i++) {
+			btcoexist->btc_write_4byte(btcoexist, 0x81c,
+						   rx_gain_value_enable[i]);
+
+			if (rx_gain_value_enable[i] == 0x007e0403)
+				break;
+		}
+
+	} else {
+		RT_TRACE(rtlpriv, COMP_BT_COEXIST, DBG_LOUD,
+			 "[BTCoex], BB Agc Table Off!\n");
+
+		for (i = 0; i < ARRAY_SIZE(rx_gain_value_disable); i++) {
+			btcoexist->btc_write_4byte(btcoexist, 0x81c,
+						   rx_gain_value_disable[i]);
+
+			if (rx_gain_value_disable[i] == 0x007e0403)
+				break;
+		}
+	}
+
+	coex_dm->pre_agc_table_en = coex_dm->cur_agc_table_en;
+}
+
+static void halbtc8822b1ant_adjust_bt_rx_gain(struct btc_coexist *btcoexist,
+					      bool force_exec,
+					      bool rx_gain_en)
+{
+	/* use scoreboard[4] to notify BT Rx gain table change   */
+	halbtc8822b1ant_post_state_to_bt(btcoexist,
+					 BT_8822B_1ANT_SCBD_RXGAIN,
+					 rx_gain_en);
+}
+
+static void
+halbtc8822b1ant_monitor_bt_enable_disable(struct btc_coexist *btcoexist)
+{
+	struct rtl_priv *rtlpriv = btcoexist->adapter;
+	static u32 bt_disable_cnt;
+	bool bt_active = true, bt_disabled = false, wifi_under_5g = false;
+	u16 u16tmp;
+
+	/* This function check if bt is disabled */
+
+	/* Read BT on/off status from scoreboard[1],
+	 * enable this only if BT patch support this feature
+	 */
+	halbtc8822b1ant_read_score_board(btcoexist, &u16tmp);
+
+	bt_active = u16tmp & BIT(1);
+
+	if (bt_active) {
+		bt_disable_cnt = 0;
+		bt_disabled = false;
+		btcoexist->btc_set(btcoexist, BTC_SET_BL_BT_DISABLE,
+				   &bt_disabled);
+	} else {
+		bt_disable_cnt++;
+		if (bt_disable_cnt >= 2) {
+			bt_disabled = true;
+			bt_disable_cnt = 2;
+		}
+
+		btcoexist->btc_set(btcoexist, BTC_SET_BL_BT_DISABLE,
+				   &bt_disabled);
+	}
+
+	btcoexist->btc_get(btcoexist, BTC_GET_BL_WIFI_UNDER_5G, &wifi_under_5g);
+
+	if ((wifi_under_5g) || (bt_disabled))
+		halbtc8822b1ant_low_penalty_ra(btcoexist, NORMAL_EXEC, false);
+	else
+		halbtc8822b1ant_low_penalty_ra(btcoexist, NORMAL_EXEC, true);
+
+	if (coex_sta->bt_disabled != bt_disabled) {
+		RT_TRACE(rtlpriv, COMP_BT_COEXIST, DBG_LOUD,
+			 "[BTCoex], BT is from %s to %s!!\n",
+			 (coex_sta->bt_disabled ? "disabled" : "enabled"),
+			 (bt_disabled ? "disabled" : "enabled"));
+		coex_sta->bt_disabled = bt_disabled;
+
+		/*for win10 RS3 BT disable->enable trigger wifi scan issue   */
+		if (!coex_sta->bt_disabled) {
+			coex_sta->is_bt_reenable = true;
+			coex_sta->cnt_bt_reenable = 15;
+		} else {
+			coex_sta->is_bt_reenable = false;
+			coex_sta->cnt_bt_reenable = 0;
+		}
+	}
+}
+
+static void halbtc8822b1ant_enable_gnt_to_gpio(struct btc_coexist *btcoexist,
+					       bool isenable)
+{
+	static u8 bit_val[5] = {0, 0, 0, 0, 0};
+	static bool state;
+
+	if (!btcoexist->dbg_mode_1ant)
+		return;
+
+	if (state == isenable)
+		return;
+
+	state = isenable;
+
+	if (isenable) {
+		/* enable GNT_WL, GNT_BT to GPIO for debug */
+		btcoexist->btc_write_1byte_bitmask(btcoexist, 0x73, 0x8, 0x1);
+
+		/* store original value */
+		bit_val[0] = (btcoexist->btc_read_1byte(btcoexist, 0x66) &
+			      BIT(4)) >> 4; /*0x66[4] */
+		bit_val[1] = (btcoexist->btc_read_1byte(btcoexist, 0x67) &
+			      BIT(0)); /*0x66[8] */
+		bit_val[2] = (btcoexist->btc_read_1byte(btcoexist, 0x42) &
+			      BIT(3)) >> 3; /*0x40[19] */
+		bit_val[3] = (btcoexist->btc_read_1byte(btcoexist, 0x65) &
+			      BIT(7)) >> 7; /*0x64[15] */
+		bit_val[4] = (btcoexist->btc_read_1byte(btcoexist, 0x72) &
+			      BIT(2)) >> 2; /*0x70[18] */
+
+		/*  switch GPIO Mux */
+		btcoexist->btc_write_1byte_bitmask(btcoexist, 0x66, BIT(4),
+						   0x0); /*0x66[4] = 0 */
+		btcoexist->btc_write_1byte_bitmask(btcoexist, 0x67, BIT(0),
+						   0x0); /*0x66[8] = 0 */
+		btcoexist->btc_write_1byte_bitmask(btcoexist, 0x42, BIT(3),
+						   0x0); /*0x40[19] = 0 */
+		btcoexist->btc_write_1byte_bitmask(btcoexist, 0x65, BIT(7),
+						   0x0); /*0x64[15] = 0 */
+		btcoexist->btc_write_1byte_bitmask(btcoexist, 0x72, BIT(2),
+						   0x0); /*0x70[18] = 0 */
+
+	} else {
+		btcoexist->btc_write_1byte_bitmask(btcoexist, 0x73, 0x8, 0x0);
+
+		/*  Restore original value  */
+		/*  switch GPIO Mux */
+		btcoexist->btc_write_1byte_bitmask(btcoexist, 0x66, BIT(4),
+						   bit_val[0]); /*0x66[4] = 0 */
+		btcoexist->btc_write_1byte_bitmask(btcoexist, 0x67, BIT(0),
+						   bit_val[1]); /*0x66[8] = 0 */
+		btcoexist->btc_write_1byte_bitmask(btcoexist, 0x42, BIT(3),
+						   bit_val[2]); /*0x40[19] = 0*/
+		btcoexist->btc_write_1byte_bitmask(btcoexist, 0x65, BIT(7),
+						   bit_val[3]); /*0x64[15] = 0*/
+		btcoexist->btc_write_1byte_bitmask(btcoexist, 0x72, BIT(2),
+						   bit_val[4]); /*0x70[18] = 0*/
+	}
+}
+
+static
+u32 halbtc8822b1ant_ltecoex_read_reg(struct btc_coexist *btcoexist,
+				     u16 reg_addr)
+{
+	u32 delay_count = 0;
+
+	/* wait for ready bit before access 0x1700 */
+	while (1) {
+		if ((btcoexist->btc_read_1byte(btcoexist, 0x1703) &
+		     BIT(5)) == 0) {
+			mdelay(10);
+			delay_count++;
+			if (delay_count >= 10) {
+				delay_count = 0;
+				break;
+			}
+		} else {
+			break;
+		}
+	}
+
+	btcoexist->btc_write_4byte(btcoexist, 0x1700, 0x800F0000 | reg_addr);
+
+	return btcoexist->btc_read_4byte(btcoexist, 0x1708); /* get read data */
+}
+
+static
+void halbtc8822b1ant_ltecoex_write_reg(struct btc_coexist *btcoexist,
+				       u16 reg_addr, u32 bit_mask,
+				       u32 reg_value)
+{
+	u32 val, i = 0, bitpos = 0, delay_count = 0;
+
+	if (bit_mask == 0x0)
+		return;
+
+	if (bit_mask == 0xffffffff) {
+		/* wait for ready bit before access 0x1700/0x1704 */
+		while (1) {
+			if ((btcoexist->btc_read_1byte(btcoexist, 0x1703) &
+			     BIT(5)) == 0) {
+				mdelay(10);
+				delay_count++;
+				if (delay_count >= 10) {
+					delay_count = 0;
+					break;
+				}
+			} else {
+				break;
+			}
+		}
+
+		btcoexist->btc_write_4byte(btcoexist, 0x1704,
+					   reg_value); /* put write data */
+
+		btcoexist->btc_write_4byte(btcoexist, 0x1700,
+					   0xc00F0000 | reg_addr);
+	} else {
+		for (i = 0; i <= 31; i++) {
+			if (((bit_mask >> i) & 0x1) == 0x1) {
+				bitpos = i;
+				break;
+			}
+		}
+
+		/* read back register value before write */
+		val = halbtc8822b1ant_ltecoex_read_reg(btcoexist, reg_addr);
+		val = (val & (~bit_mask)) | (reg_value << bitpos);
+
+		/* wait for ready bit before access 0x1700/0x1704 */
+		while (1) {
+			if ((btcoexist->btc_read_1byte(btcoexist, 0x1703) &
+			     BIT(5)) == 0) {
+				mdelay(10);
+				delay_count++;
+				if (delay_count >= 10) {
+					delay_count = 0;
+					break;
+				}
+			} else {
+				break;
+			}
+		}
+
+		btcoexist->btc_write_4byte(btcoexist, 0x1704,
+					   val); /* put write data */
+
+		btcoexist->btc_write_4byte(btcoexist, 0x1700,
+					   0xc00F0000 | reg_addr);
+	}
+}
+
+static
+void halbtc8822b1ant_ltecoex_enable(struct btc_coexist *btcoexist,
+				    bool enable)
+{
+	u8 val;
+
+	val = (enable) ? 1 : 0;
+	/* 0x38[7] */
+	halbtc8822b1ant_ltecoex_write_reg(btcoexist, 0x38, 0x80, val);
+}
+
+static
+void hallbtc882b1ant_ltecoex_ctrl_owner(struct btc_coexist *btcoexist,
+					bool wifi_control)
+{
+	u8 val;
+
+	val = (wifi_control) ? 1 : 0;
+	/* 0x70[26] */
+	btcoexist->btc_write_1byte_bitmask(btcoexist, 0x73, 0x4, val);
+}
+
+static void halbtc8822b1ant_set_gnt_bt(struct btc_coexist *btcoexist,
+				       u8 control_block, u8 sw_control,
+				       u8 state)
+{
+	u32 val = 0, bit_mask;
+
+	state = state & 0x1;
+	/*LTE indirect 0x38=0xccxx (sw : gnt_wl=1,sw gnt_bt=1)
+	 *0x38=0xddxx (sw : gnt_bt=1 , sw gnt_wl=0)
+	 *0x38=0x55xx(hw pta :gnt_wl /gnt_bt )
+	 */
+	val = (sw_control) ? ((state << 1) | 0x1) : 0;
+
+	switch (control_block) {
+	case BT_8822B_1ANT_GNT_BLOCK_RFC_BB:
+	default:
+		/* 0x38[15:14] */
+		bit_mask = 0xc000;
+		halbtc8822b1ant_ltecoex_write_reg(btcoexist, 0x38,
+						  bit_mask, val);
+		/* 0x38[11:10] */
+		bit_mask = 0x0c00;
+		halbtc8822b1ant_ltecoex_write_reg(btcoexist, 0x38,
+						  bit_mask, val);
+		break;
+	case BT_8822B_1ANT_GNT_BLOCK_RFC:
+		/* 0x38[15:14] */
+		bit_mask = 0xc000;
+		halbtc8822b1ant_ltecoex_write_reg(btcoexist, 0x38,
+						  bit_mask, val);
+		break;
+	case BT_8822B_1ANT_GNT_BLOCK_BB:
+		/* 0x38[11:10] */
+		bit_mask = 0x0c00;
+		halbtc8822b1ant_ltecoex_write_reg(btcoexist, 0x38,
+						  bit_mask, val);
+		break;
+	}
+}
+
+static void halbtc8822b1ant_set_gnt_wl(struct btc_coexist *btcoexist,
+				       u8 control_block, u8 sw_control,
+				       u8 state)
+{
+	u32 val = 0, bit_mask;
+	/*LTE indirect 0x38=0xccxx (sw : gnt_wl=1,sw gnt_bt=1)
+	 *0x38=0xddxx (sw : gnt_bt=1 , sw gnt_wl=0)
+	 *0x38=0x55xx(hw pta :gnt_wl /gnt_bt )
+	 */
+
+	state = state & 0x1;
+	val = (sw_control) ? ((state << 1) | 0x1) : 0;
+
+	switch (control_block) {
+	case BT_8822B_1ANT_GNT_BLOCK_RFC_BB:
+	default:
+		/* 0x38[13:12] */
+		bit_mask = 0x3000;
+		halbtc8822b1ant_ltecoex_write_reg(btcoexist, 0x38,
+						  bit_mask, val);
+		/* 0x38[9:8] */
+		bit_mask = 0x0300;
+		halbtc8822b1ant_ltecoex_write_reg(btcoexist, 0x38,
+						  bit_mask, val);
+		break;
+	case BT_8822B_1ANT_GNT_BLOCK_RFC:
+		/* 0x38[13:12] */
+		bit_mask = 0x3000;
+		halbtc8822b1ant_ltecoex_write_reg(btcoexist, 0x38,
+						  bit_mask, val);
+		break;
+	case BT_8822B_1ANT_GNT_BLOCK_BB:
+		/* 0x38[9:8] */
+		bit_mask = 0x0300;
+		halbtc8822b1ant_ltecoex_write_reg(btcoexist, 0x38,
+						  bit_mask, val);
+		break;
+	}
+}
+
+static
+void hallbtc882b1ant_ltecoex_table(struct btc_coexist *btcoexist,
+				   u8 table_type, u16 table_content)
+{
+	u16 reg_addr = 0x0000;
+
+	switch (table_type) {
+	case BT_8822B_1ANT_CTT_WL_VS_LTE:
+		reg_addr = 0xa0;
+		break;
+	case BT_8822B_1ANT_CTT_BT_VS_LTE:
+		reg_addr = 0xa4;
+		break;
+	}
+
+	if (reg_addr == 0x0000)
+		return;
+
+	/* 0xa0[15:0] or 0xa4[15:0] */
+	halbtc8822b1ant_ltecoex_write_reg(btcoexist, reg_addr, 0xffff,
+					  table_content);
+}
+
+static
+void halbtc8822b1ant_set_coex_table(struct btc_coexist *btcoexist, u32 val0x6c0,
+				    u32 val0x6c4, u32 val0x6c8, u8 val0x6cc)
+{
+	btcoexist->btc_write_4byte(btcoexist, 0x6c0, val0x6c0);
+
+	btcoexist->btc_write_4byte(btcoexist, 0x6c4, val0x6c4);
+
+	btcoexist->btc_write_4byte(btcoexist, 0x6c8, val0x6c8);
+
+	btcoexist->btc_write_1byte(btcoexist, 0x6cc, val0x6cc);
+}
+
+static
+void halbtc8822b1ant_coex_table(struct btc_coexist *btcoexist,
+				bool force_exec, u32 val0x6c0, u32 val0x6c4,
+				u32 val0x6c8, u8 val0x6cc)
+{
+	coex_dm->cur_val0x6c0 = val0x6c0;
+	coex_dm->cur_val0x6c4 = val0x6c4;
+	coex_dm->cur_val0x6c8 = val0x6c8;
+	coex_dm->cur_val0x6cc = val0x6cc;
+
+	if (!force_exec) {
+		if (coex_dm->pre_val0x6c0 == coex_dm->cur_val0x6c0 &&
+		    coex_dm->pre_val0x6c4 == coex_dm->cur_val0x6c4 &&
+		    coex_dm->pre_val0x6c8 == coex_dm->cur_val0x6c8 &&
+		    coex_dm->pre_val0x6cc == coex_dm->cur_val0x6cc)
+			return;
+	}
+	halbtc8822b1ant_set_coex_table(btcoexist, val0x6c0, val0x6c4, val0x6c8,
+				       val0x6cc);
+
+	coex_dm->pre_val0x6c0 = coex_dm->cur_val0x6c0;
+	coex_dm->pre_val0x6c4 = coex_dm->cur_val0x6c4;
+	coex_dm->pre_val0x6c8 = coex_dm->cur_val0x6c8;
+	coex_dm->pre_val0x6cc = coex_dm->cur_val0x6cc;
+}
+
+static
+void halbtc8822b1ant_coex_table_type(struct btc_coexist *btcoexist,
+				     bool force_exec, u8 type)
+{
+	u32 break_table;
+	u8 select_table;
+
+	coex_sta->coex_table_type = type;
+
+	if (coex_sta->concurrent_rx_mode_on) {
+		/* set WL hi-pri can break BT */
+		break_table = 0xf0ffffff;
+		/* set Tx response = Hi-Pri (ex: Transmitting ACK,BA,CTS) */
+		select_table = 0xb;
+	} else {
+		break_table = 0xffffff;
+		select_table = 0x3;
+	}
+
+	switch (type) {
+	case 0:
+		halbtc8822b1ant_coex_table(btcoexist, force_exec, 0x55555555,
+					   0x55555555, break_table,
+					   select_table);
+		break;
+	case 1:
+		halbtc8822b1ant_coex_table(btcoexist, force_exec, 0x55555555,
+					   0x5a5a5a5a, break_table,
+					   select_table);
+		break;
+	case 2:
+		halbtc8822b1ant_coex_table(btcoexist, force_exec, 0xaa5a5a5a,
+					   0xaa5a5a5a, break_table,
+					   select_table);
+		break;
+	case 3:
+		halbtc8822b1ant_coex_table(btcoexist, force_exec, 0x55555555,
+					   0xaa5a5a5a, break_table,
+					   select_table);
+		break;
+	case 4:
+		halbtc8822b1ant_coex_table(btcoexist, force_exec, 0xaa555555,
+					   0xaa5a5a5a, break_table,
+					   select_table);
+		break;
+	case 5:
+		halbtc8822b1ant_coex_table(btcoexist, force_exec, 0x5a5a5a5a,
+					   0x5a5a5a5a, break_table,
+					   select_table);
+		break;
+	case 6:
+		halbtc8822b1ant_coex_table(btcoexist, force_exec, 0x55555555,
+					   0xaa5a5a5a, break_table,
+					   select_table);
+		break;
+	case 7:
+		halbtc8822b1ant_coex_table(btcoexist, force_exec, 0xaaaaaaaa,
+					   0xaaaaaaaa, break_table,
+					   select_table);
+		break;
+	case 8:
+		halbtc8822b1ant_coex_table(btcoexist, force_exec, 0xffffffff,
+					   0xffffffff, break_table,
+					   select_table);
+		break;
+	case 9:
+		halbtc8822b1ant_coex_table(btcoexist, force_exec, 0x5a5a5555,
+					   0xaaaa5a5a, break_table,
+					   select_table);
+		break;
+	case 10:
+		halbtc8822b1ant_coex_table(btcoexist, force_exec, 0xaaaa5aaa,
+					   0xaaaa5aaa, break_table,
+					   select_table);
+		break;
+	case 11:
+		halbtc8822b1ant_coex_table(btcoexist, force_exec, 0xa5a55555,
+					   0xaaaa5a5a, break_table,
+					   select_table);
+		break;
+	case 12:
+		halbtc8822b1ant_coex_table(btcoexist, force_exec, 0xaaaaa5aa,
+					   0xaaaaa5aa, break_table,
+					   select_table);
+		break;
+	case 13:
+		halbtc8822b1ant_coex_table(btcoexist, force_exec, 0xaa5555aa,
+					   0xaa5a5a5a, break_table,
+					   select_table);
+		break;
+	case 14:
+		halbtc8822b1ant_coex_table(btcoexist, force_exec, 0xaa5555aa,
+					   0x5a5a5a5a, break_table,
+					   select_table);
+		break;
+	case 15:
+		halbtc8822b1ant_coex_table(btcoexist, force_exec, 0x55555555,
+					   0xaaaa55aa, break_table,
+					   select_table);
+		break;
+	case 16:
+		halbtc8822b1ant_coex_table(btcoexist, force_exec, 0x5a5a555a,
+					   0x5a5a555a, break_table,
+					   select_table);
+		break;
+	case 17:
+		halbtc8822b1ant_coex_table(btcoexist, force_exec, 0xaaaa55aa,
+					   0xaaaa55aa, break_table,
+					   select_table);
+		break;
+	case 18:
+		halbtc8822b1ant_coex_table(btcoexist, force_exec, 0x55555555,
+					   0x5aaa5a5a, break_table,
+					   select_table);
+		break;
+	case 19:
+		halbtc8822b1ant_coex_table(btcoexist, force_exec, 0xa5555555,
+					   0xaaaa5aaa, break_table,
+					   select_table);
+		break;
+	case 20:
+		halbtc8822b1ant_coex_table(btcoexist, force_exec, 0x55555555,
+					   0xaaaa5aaa, break_table,
+					   select_table);
+		break;
+	case 21:
+		halbtc8822b1ant_coex_table(btcoexist, force_exec, 0x55555555,
+					   0xaaaa5afa, break_table,
+					   select_table);
+		break;
+	case 22:
+		halbtc8822b1ant_coex_table(btcoexist, force_exec, 0xaaffffaa,
+					   0xfafafafa, break_table,
+					   select_table);
+		break;
+	case 23:
+		halbtc8822b1ant_coex_table(btcoexist, force_exec, 0xffff55ff,
+					   0xfafafafa, break_table,
+					   select_table);
+		break;
+	case 24:
+		halbtc8822b1ant_coex_table(btcoexist, force_exec, 0x55555555,
+					   0xfafafafa, break_table,
+					   select_table);
+		break;
+	case 25:
+		halbtc8822b1ant_coex_table(btcoexist, force_exec, 0xffffffff,
+					   0xaa5a5a5a, break_table,
+					   select_table);
+		break;
+	default:
+		break;
+	}
+}
+
+static
+void halbtc8822b1ant_set_fw_ignore_wlan_act(struct btc_coexist *btcoexist,
+					    bool enable)
+{
+	u8 h2c_parameter[1] = {0};
+
+	if (enable)
+		h2c_parameter[0] |= BIT(0); /* function enable */
+
+	btcoexist->btc_fill_h2c(btcoexist, 0x63, 1, h2c_parameter);
+}
+
+static
+void halbtc8822b1ant_ignore_wlan_act(struct btc_coexist *btcoexist,
+				     bool force_exec, bool enable)
+{
+	coex_dm->cur_ignore_wlan_act = enable;
+
+	if (!force_exec) {
+		if (coex_dm->pre_ignore_wlan_act ==
+		    coex_dm->cur_ignore_wlan_act) {
+			coex_dm->pre_ignore_wlan_act =
+				coex_dm->cur_ignore_wlan_act;
+			return;
+		}
+	}
+
+	halbtc8822b1ant_set_fw_ignore_wlan_act(btcoexist, enable);
+
+	coex_dm->pre_ignore_wlan_act = coex_dm->cur_ignore_wlan_act;
+}
+
+static
+void halbtc8822b1ant_set_lps_rpwm(struct btc_coexist *btcoexist, u8 lps_val,
+				  u8 rpwm_val)
+{
+	u8 lps = lps_val;
+	u8 rpwm = rpwm_val;
+
+	btcoexist->btc_set(btcoexist, BTC_SET_U1_LPS_VAL, &lps);
+	btcoexist->btc_set(btcoexist, BTC_SET_U1_RPWM_VAL, &rpwm);
+}
+
+static
+void halbtc8822b1ant_lps_rpwm(struct btc_coexist *btcoexist, bool force_exec,
+			      u8 lps_val, u8 rpwm_val)
+{
+	coex_dm->cur_lps = lps_val;
+	coex_dm->cur_rpwm = rpwm_val;
+
+	if (!force_exec) {
+		if (coex_dm->pre_lps == coex_dm->cur_lps &&
+		    coex_dm->pre_rpwm == coex_dm->cur_rpwm)
+			return;
+	}
+	halbtc8822b1ant_set_lps_rpwm(btcoexist, lps_val, rpwm_val);
+
+	coex_dm->pre_lps = coex_dm->cur_lps;
+	coex_dm->pre_rpwm = coex_dm->cur_rpwm;
+}
+
+static void
+halbtc8822b1ant_ps_tdma_check(struct btc_coexist *btcoexist,
+			      bool new_ps_state)
+{
+	u8 lps_mode = 0x0;
+	u8 h2c_parameter[5] = {0x8, 0, 0, 0, 0};
+
+	btcoexist->btc_get(btcoexist, BTC_GET_U1_LPS_MODE, &lps_mode);
+
+	if (lps_mode) { /* already under LPS state */
+		if (new_ps_state) {
+			/* keep state under LPS, do nothing. */
+		} else {
+			/* will leave LPS state, turn off psTdma first */
+
+			btcoexist->btc_fill_h2c(btcoexist, 0x60, 5,
+						h2c_parameter);
+		}
+	} else { /* NO PS state */
+		if (new_ps_state) {
+			/* will enter LPS state, turn off psTdma first */
+
+			btcoexist->btc_fill_h2c(btcoexist, 0x60, 5,
+						h2c_parameter);
+		} else {
+			/* keep state under NO PS state, do nothing. */
+		}
+	}
+}
+
+static bool
+halbtc8822b1ant_power_save_state(struct btc_coexist *btcoexist,
+				 u8 ps_type, u8 lps_val, u8 rpwm_val)
+{
+	bool low_pwr_disable = false, result = true;
+
+	switch (ps_type) {
+	case BTC_PS_WIFI_NATIVE:
+		/* recover to original 32k low power setting */
+		coex_sta->force_lps_ctrl = false;
+		low_pwr_disable = false;
+		/* btcoexist->btc_set(btcoexist,
+		 * over to original 32k low power setting
+		 */
+
+		btcoexist->btc_set(btcoexist, BTC_SET_ACT_PRE_NORMAL_LPS, NULL);
+		break;
+	case BTC_PS_LPS_ON:
+
+		coex_sta->force_lps_ctrl = true;
+		halbtc8822b1ant_ps_tdma_check(btcoexist, true);
+		halbtc8822b1ant_lps_rpwm(btcoexist, NORMAL_EXEC, lps_val,
+					 rpwm_val);
+		/* when coex force to enter LPS, do not enter 32k low power. */
+		low_pwr_disable = true;
+		btcoexist->btc_set(btcoexist, BTC_SET_ACT_DISABLE_LOW_POWER,
+				   &low_pwr_disable);
+		/* power save must executed before psTdma. */
+		btcoexist->btc_set(btcoexist, BTC_SET_ACT_ENTER_LPS, NULL);
+
+		break;
+	case BTC_PS_LPS_OFF:
+
+		coex_sta->force_lps_ctrl = true;
+		halbtc8822b1ant_ps_tdma_check(btcoexist, false);
+		result = btcoexist->btc_set(btcoexist, BTC_SET_ACT_LEAVE_LPS,
+					    NULL);
+
+		break;
+	default:
+		break;
+	}
+
+	return result;
+}
+
+static
+void halbtc8822b1ant_set_fw_pstdma(struct btc_coexist *btcoexist, u8 byte1,
+				   u8 byte2, u8 byte3, u8 byte4, u8 byte5)
+{
+	struct rtl_priv *rtlpriv = btcoexist->adapter;
+	u8 h2c_parameter[5] = {0};
+	u8 real_byte1 = byte1, real_byte5 = byte5;
+	bool ap_enable = false, result = false;
+	struct btc_bt_link_info *bt_link_info = &btcoexist->bt_link_info;
+	u8 ps_type = BTC_PS_WIFI_NATIVE;
+
+	if (byte5 & BIT(2))
+		coex_sta->is_tdma_btautoslot = true;
+	else
+		coex_sta->is_tdma_btautoslot = false;
+
+	/* release bt-auto slot for auto-slot hang is detected!! */
+	if (coex_sta->is_tdma_btautoslot)
+		if (coex_sta->is_tdma_btautoslot_hang ||
+		    bt_link_info->slave_role)
+			byte5 = byte5 & 0xfb;
+
+	btcoexist->btc_get(btcoexist, BTC_GET_BL_WIFI_AP_MODE_ENABLE,
+			   &ap_enable);
+
+	if ((ap_enable) && (byte1 & BIT(4) && !(byte1 & BIT(5)))) {
+		RT_TRACE(rtlpriv, COMP_BT_COEXIST, DBG_LOUD,
+			 "[BTCoex], %s == FW for 1Ant AP mode\n", __func__);
+
+		real_byte1 &= ~BIT(4);
+		real_byte1 |= BIT(5);
+
+		real_byte5 |= BIT(5);
+		real_byte5 &= ~BIT(6);
+
+		ps_type = BTC_PS_WIFI_NATIVE;
+		halbtc8822b1ant_power_save_state(btcoexist, ps_type, 0x0, 0x0);
+
+	} else if (byte1 & BIT(4) && !(byte1 & BIT(5))) {
+		RT_TRACE(rtlpriv, COMP_BT_COEXIST, DBG_LOUD,
+			 "[BTCoex], %s == Force LPS (byte1 = 0x%x)\n",
+			 __func__, byte1);
+
+		ps_type = BTC_PS_LPS_OFF;
+		if (!halbtc8822b1ant_power_save_state(btcoexist, ps_type, 0x50,
+						      0x4))
+			result = true;
+	} else {
+		RT_TRACE(rtlpriv, COMP_BT_COEXIST, DBG_LOUD,
+			 "[BTCoex], %s == native power save (byte1 = 0x%x)\n",
+			 __func__, byte1);
+
+		ps_type = BTC_PS_WIFI_NATIVE;
+		halbtc8822b1ant_power_save_state(btcoexist, ps_type, 0x0, 0x0);
+	}
+
+	coex_sta->is_set_ps_state_fail = result;
+
+	if (!coex_sta->is_set_ps_state_fail) {
+		h2c_parameter[0] = real_byte1;
+		h2c_parameter[1] = byte2;
+		h2c_parameter[2] = byte3;
+		h2c_parameter[3] = byte4;
+		h2c_parameter[4] = real_byte5;
+
+		coex_dm->ps_tdma_para[0] = real_byte1;
+		coex_dm->ps_tdma_para[1] = byte2;
+		coex_dm->ps_tdma_para[2] = byte3;
+		coex_dm->ps_tdma_para[3] = byte4;
+		coex_dm->ps_tdma_para[4] = real_byte5;
+
+		btcoexist->btc_fill_h2c(btcoexist, 0x60, 5, h2c_parameter);
+
+	} else {
+		coex_sta->cnt_set_ps_state_fail++;
+		RT_TRACE(rtlpriv, COMP_BT_COEXIST, DBG_LOUD,
+			 "[BTCoex], %s == Force Leave LPS Fail (cnt = %d)\n",
+			 __func__, coex_sta->cnt_set_ps_state_fail);
+	}
+
+	if (ps_type == BTC_PS_WIFI_NATIVE)
+		btcoexist->btc_set(btcoexist, BTC_SET_ACT_POST_NORMAL_LPS,
+				   NULL);
+}
+
+static
+void halbtc8822b1ant_ps_tdma(struct btc_coexist *btcoexist, bool force_exec,
+			     bool turn_on, u8 type)
+{
+	struct rtl_priv *rtlpriv = btcoexist->adapter;
+	struct btc_bt_link_info *bt_link_info = &btcoexist->bt_link_info;
+	bool wifi_busy = false;
+	static u8 tdma_byte4_modify, pre_ps_tdma_byte4_modify;
+	static bool pre_wifi_busy;
+
+	coex_dm->cur_ps_tdma_on = turn_on;
+	coex_dm->cur_ps_tdma = type;
+
+	btcoexist->btc_get(btcoexist, BTC_GET_BL_WIFI_BUSY, &wifi_busy);
+
+	if (wifi_busy != pre_wifi_busy) {
+		force_exec = true;
+		pre_wifi_busy = wifi_busy;
+	}
+
+	/* 0x778 = 0x1 at wifi slot (no blocking BT Low-Pri pkts) */
+	if (bt_link_info->slave_role)
+		tdma_byte4_modify = 0x1;
+	else
+		tdma_byte4_modify = 0x0;
+
+	if (pre_ps_tdma_byte4_modify != tdma_byte4_modify) {
+		force_exec = true;
+		pre_ps_tdma_byte4_modify = tdma_byte4_modify;
+	}
+
+	if (!force_exec) {
+		if (coex_dm->pre_ps_tdma_on == coex_dm->cur_ps_tdma_on &&
+		    coex_dm->pre_ps_tdma == coex_dm->cur_ps_tdma) {
+			RT_TRACE(rtlpriv, COMP_BT_COEXIST, DBG_LOUD,
+				 "[BTCoex], Skip TDMA because no change TDMA(%s, %d)\n",
+				 (coex_dm->cur_ps_tdma_on ? "on" : "off"),
+				 coex_dm->cur_ps_tdma);
+			return;
+		}
+	}
+
+	if (coex_dm->cur_ps_tdma_on) {
+		RT_TRACE(rtlpriv, COMP_BT_COEXIST, DBG_LOUD,
+			 "[BTCoex], ********** TDMA(on, %d) **********\n",
+			 coex_dm->cur_ps_tdma);
+
+		/* enable TBTT nterrupt */
+		btcoexist->btc_write_1byte_bitmask(btcoexist, 0x550, 0x8, 0x1);
+	} else {
+		RT_TRACE(rtlpriv, COMP_BT_COEXIST, DBG_LOUD,
+			 "[BTCoex], ********** TDMA(off, %d) **********\n",
+			 coex_dm->cur_ps_tdma);
+	}
+
+	if (turn_on) {
+		/* enable TBTT nterrupt */
+		btcoexist->btc_write_1byte_bitmask(btcoexist, 0x550, 0x8, 0x1);
+
+		switch (type) {
+		default:
+			halbtc8822b1ant_set_fw_pstdma(btcoexist, 0x61, 0x35,
+						      0x03, 0x11, 0x11);
+			break;
+		case 1:
+			halbtc8822b1ant_set_fw_pstdma(btcoexist, 0x61, 0x3a,
+						      0x03, 0x11, 0x10);
+			break;
+		case 3:
+			halbtc8822b1ant_set_fw_pstdma(btcoexist, 0x51, 0x30,
+						      0x03, 0x10, 0x50);
+			break;
+		case 4:
+			halbtc8822b1ant_set_fw_pstdma(btcoexist, 0x51, 0x21,
+						      0x03, 0x10, 0x50);
+			break;
+		case 5:
+			halbtc8822b1ant_set_fw_pstdma(btcoexist, 0x61, 0x15,
+						      0x3, 0x11, 0x11);
+			break;
+		case 6:
+			halbtc8822b1ant_set_fw_pstdma(btcoexist, 0x61, 0x20,
+						      0x3, 0x11, 0x11);
+			break;
+		case 7:
+			halbtc8822b1ant_set_fw_pstdma(btcoexist, 0x51, 0x10,
+						      0x03, 0x10,
+						      0x54 | tdma_byte4_modify);
+			break;
+		case 8:
+			halbtc8822b1ant_set_fw_pstdma(btcoexist, 0x51, 0x10,
+						      0x03, 0x10,
+						      0x14 | tdma_byte4_modify);
+			break;
+		case 10:
+			halbtc8822b1ant_set_fw_pstdma(btcoexist, 0x51, 0x4a,
+						      0x03, 0x10, 0x50);
+			break;
+		case 11:
+			halbtc8822b1ant_set_fw_pstdma(btcoexist, 0x61, 0x25,
+						      0x03, 0x11, 0x11);
+			break;
+		case 12:
+			halbtc8822b1ant_set_fw_pstdma(btcoexist, 0x51, 0x30,
+						      0x03, 0x10,
+						      0x50 | tdma_byte4_modify);
+			break;
+		case 13:
+			halbtc8822b1ant_set_fw_pstdma(btcoexist, 0x51, 0x10,
+						      0x07, 0x10, 0x54);
+			break;
+		case 14:
+			halbtc8822b1ant_set_fw_pstdma(btcoexist, 0x51, 0x15,
+						      0x03, 0x10,
+						      0x50 | tdma_byte4_modify);
+			break;
+		case 15:
+			halbtc8822b1ant_set_fw_pstdma(btcoexist, 0x51, 0x20,
+						      0x03, 0x10,
+						      0x10 | tdma_byte4_modify);
+			break;
+		case 17:
+			halbtc8822b1ant_set_fw_pstdma(btcoexist, 0x61, 0x10,
+						      0x03, 0x11,
+						      0x14 | tdma_byte4_modify);
+			break;
+		case 18:
+			halbtc8822b1ant_set_fw_pstdma(btcoexist, 0x51, 0x30,
+						      0x03, 0x10, 0x50);
+			break;
+		case 20:
+			halbtc8822b1ant_set_fw_pstdma(btcoexist, 0x61, 0x30,
+						      0x03, 0x11, 0x10);
+			break;
+		case 21:
+			halbtc8822b1ant_set_fw_pstdma(btcoexist, 0x61, 0x30,
+						      0x03, 0x11, 0x10);
+			break;
+		case 22:
+			halbtc8822b1ant_set_fw_pstdma(btcoexist, 0x61, 0x25,
+						      0x03, 0x11, 0x10);
+			break;
+		case 25:
+			halbtc8822b1ant_set_fw_pstdma(btcoexist, 0x51, 0x3a,
+						      0x3, 0x11, 0x50);
+			break;
+		case 26:
+			halbtc8822b1ant_set_fw_pstdma(btcoexist, 0x51, 0x10,
+						      0x03, 0x10, 0x55);
+			break;
+		case 27:
+			halbtc8822b1ant_set_fw_pstdma(btcoexist, 0x61, 0x10,
+						      0x03, 0x11, 0x15);
+			break;
+		case 32:
+			halbtc8822b1ant_set_fw_pstdma(btcoexist, 0x61, 0x35,
+						      0x3, 0x11, 0x11);
+			break;
+		case 33:
+			halbtc8822b1ant_set_fw_pstdma(btcoexist, 0x61, 0x35,
+						      0x03, 0x11, 0x10);
+			break;
+		case 36:
+			halbtc8822b1ant_set_fw_pstdma(btcoexist, 0x61, 0x48,
+						      0x03, 0x11, 0x10);
+			break;
+		case 41:
+			halbtc8822b1ant_set_fw_pstdma(btcoexist, 0x51, 0x45,
+						      0x3, 0x11, 0x11);
+			break;
+		case 42:
+			halbtc8822b1ant_set_fw_pstdma(btcoexist, 0x51, 0x1e,
+						      0x3, 0x10,
+						      0x14 | tdma_byte4_modify);
+			break;
+		case 43:
+			halbtc8822b1ant_set_fw_pstdma(btcoexist, 0x51, 0x45,
+						      0x3, 0x10, 0x14);
+			break;
+		case 44:
+			halbtc8822b1ant_set_fw_pstdma(btcoexist, 0x51, 0x25,
+						      0x3, 0x10, 0x10);
+			break;
+		case 45:
+			halbtc8822b1ant_set_fw_pstdma(btcoexist, 0x51, 0x29,
+						      0x3, 0x10, 0x10);
+			break;
+		case 46:
+			halbtc8822b1ant_set_fw_pstdma(btcoexist, 0x51, 0x1a,
+						      0x3, 0x10, 0x10);
+			break;
+		case 47:
+			halbtc8822b1ant_set_fw_pstdma(btcoexist, 0x51, 0x32,
+						      0x3, 0x10, 0x10);
+			break;
+		case 48:
+			halbtc8822b1ant_set_fw_pstdma(btcoexist, 0x51, 0x29,
+						      0x3, 0x10, 0x10);
+			break;
+		case 49:
+			halbtc8822b1ant_set_fw_pstdma(btcoexist, 0x55, 0x10,
+						      0x3, 0x10, 0x54);
+			break;
+		case 50:
+			halbtc8822b1ant_set_fw_pstdma(btcoexist, 0x51, 0x4a,
+						      0x3, 0x10, 0x10);
+			break;
+		case 51:
+			halbtc8822b1ant_set_fw_pstdma(btcoexist, 0x61, 0x35,
+						      0x3, 0x10, 0x11);
+			break;
+		case 52:
+			halbtc8822b1ant_set_fw_pstdma(btcoexist, 0x51, 0x0a,
+						      0x3, 0x10, 0x10);
+			break;
+		case 105:
+			halbtc8822b1ant_set_fw_pstdma(btcoexist, 0x51, 0x3f,
+						      0x3, 0x10, 0x50);
+			break;
+		}
+	} else {
+		switch (type) {
+		case 0:
+		default: /* Software control, Antenna at BT side */
+			halbtc8822b1ant_set_fw_pstdma(btcoexist, 0x0, 0x0, 0x0,
+						      0x0, 0x0);
+			break;
+		case 8: /* PTA Control */
+			halbtc8822b1ant_set_fw_pstdma(btcoexist, 0x8, 0x0, 0x0,
+						      0x0, 0x0);
+			break;
+		case 9: /* Software control, Antenna at WiFi side */
+			halbtc8822b1ant_set_fw_pstdma(btcoexist, 0x0, 0x0, 0x0,
+						      0x0, 0x0);
+			break;
+		case 10: /* under 5G , 0x778=1*/
+			halbtc8822b1ant_set_fw_pstdma(btcoexist, 0x0, 0x0, 0x0,
+						      0x0, 0x0);
+			break;
+		}
+	}
+
+	if (!coex_sta->is_set_ps_state_fail) {
+		/* update pre state */
+		coex_dm->pre_ps_tdma_on = coex_dm->cur_ps_tdma_on;
+		coex_dm->pre_ps_tdma = coex_dm->cur_ps_tdma;
+	}
+}
+
+/* rf4 type by efuse, and for ant at main aux inverse use,
+ * because is 2x2, and control types are the same, does not need
+ */
+
+static void halbtc8822b1ant_set_rfe_type(struct btc_coexist *btcoexist)
+{
+	struct btc_board_info *board_info = &btcoexist->board_info;
+
+	/* Ext switch buffer mux */
+	btcoexist->btc_write_1byte(btcoexist, 0x974, 0xff);
+	btcoexist->btc_write_1byte_bitmask(btcoexist, 0x1991, 0x3, 0x0);
+	btcoexist->btc_write_1byte_bitmask(btcoexist, 0xcbe, 0x8, 0x0);
+
+	/* the following setup should be got from Efuse in the future */
+	rfe_type->rfe_module_type = board_info->rfe_type;
+
+	rfe_type->ext_ant_switch_ctrl_polarity = 0;
+	rfe_type->ext_ant_switch_exist = true;
+	rfe_type->ext_ant_switch_type = BT_8822B_1ANT_SWITCH_USE_SPDT;
+}
+
+/*anttenna control by bb mac bt antdiv pta to write 0x4c 0xcb4,0xcbd*/
+
+static
+void hallbtc882b1ant_set_ant_switch(struct btc_coexist *btcoexist,
+				    bool force_exec, u8 ctrl_type,
+				    u8 pos_type)
+{
+	struct rtl_priv *rtlpriv = btcoexist->adapter;
+	bool switch_polarity_inverse;
+	u8 regval_0xcbd = 0, regval_0x64;
+	u32 u32tmp1 = 0, u32tmp2 = 0, u32tmp3 = 0;
+
+	/* Ext switch buffer mux */
+	btcoexist->btc_write_1byte(btcoexist, 0x974, 0xff);
+	btcoexist->btc_write_1byte_bitmask(btcoexist, 0x1991, 0x3, 0x0);
+	btcoexist->btc_write_1byte_bitmask(btcoexist, 0xcbe, 0x8, 0x0);
+
+	if (!rfe_type->ext_ant_switch_exist)
+		return;
+
+	coex_dm->cur_ext_ant_switch_status = (ctrl_type << 8) + pos_type;
+
+	if (!force_exec) {
+		if (coex_dm->pre_ext_ant_switch_status ==
+		    coex_dm->cur_ext_ant_switch_status)
+			return;
+	}
+
+	coex_dm->pre_ext_ant_switch_status = coex_dm->cur_ext_ant_switch_status;
+
+	/* swap control polarity if use different switch control polarity*/
+	/* Normal switch polarity for SPDT,
+	 * 0xcbd[1:0] = 2b'01 => Ant to BTG, WLA
+	 * 0xcbd[1:0] = 2b'10 => Ant to WLG
+	 */
+	switch_polarity_inverse = (rfe_type->ext_ant_switch_ctrl_polarity == 1);
+
+	switch (pos_type) {
+	default:
+	case BT_8822B_1ANT_SWITCH_TO_BT:
+	case BT_8822B_1ANT_SWITCH_TO_NOCARE:
+	case BT_8822B_1ANT_SWITCH_TO_WLA:
+	case BT_8822B_1ANT_SWITCH_TO_S0WLG_S1BT:
+
+		break;
+	case BT_8822B_1ANT_SWITCH_TO_WLG:
+
+		break;
+	}
+
+	if (rfe_type->ext_ant_switch_type ==
+	    BT_8822B_1ANT_SWITCH_USE_SPDT) {
+		switch (ctrl_type) {
+		default:
+		case BT_8822B_1ANT_SWITCH_CTRL_BY_BBSW:
+			/*  0x4c[23] = 0 */
+			btcoexist->btc_write_1byte_bitmask(btcoexist, 0x4e,
+							   0x80, 0x0);
+			/* 0x4c[24] = 1 */
+			btcoexist->btc_write_1byte_bitmask(btcoexist, 0x4f,
+							   0x01, 0x1);
+			/* BB SW, DPDT use RFE_ctrl8 and RFE_ctrl9 as ctrl pin*/
+			btcoexist->btc_write_1byte_bitmask(btcoexist, 0xcb4,
+							   0xff, 0x77);
+
+			/* 0xcbd[1:0] = 2b'01 for no switch_polarity_inverse,
+			 * ANTSWB =1, ANTSW =0
+			 */
+			if (pos_type ==
+			    BT_8822B_1ANT_SWITCH_TO_S0WLG_S1BT)
+				regval_0xcbd = 0x3;
+			else if (pos_type ==
+				 BT_8822B_1ANT_SWITCH_TO_WLG)
+				regval_0xcbd =
+					(!switch_polarity_inverse ? 0x2 : 0x1);
+			else
+				regval_0xcbd =
+					(!switch_polarity_inverse ? 0x1 : 0x2);
+			btcoexist->btc_write_1byte_bitmask(btcoexist, 0xcbd,
+							   0x3, regval_0xcbd);
+
+			break;
+		case BT_8822B_1ANT_SWITCH_CTRL_BY_PTA:
+			/* 0x4c[23] = 0 */
+			btcoexist->btc_write_1byte_bitmask(btcoexist, 0x4e,
+							   0x80, 0x0);
+			/* 0x4c[24] = 1 */
+			btcoexist->btc_write_1byte_bitmask(btcoexist, 0x4f,
+							   0x01, 0x1);
+			/* PTA,  DPDT use RFE_ctrl8 and RFE_ctrl9 as ctrl pin */
+			btcoexist->btc_write_1byte_bitmask(btcoexist, 0xcb4,
+							   0xff, 0x66);
+
+			/* 0xcbd[1:0] = 2b'10 for no switch_polarity_inverse,
+			 * ANTSWB =1, ANTSW =0  @ GNT_BT=1
+			 */
+			regval_0xcbd = (!switch_polarity_inverse ? 0x2 : 0x1);
+			btcoexist->btc_write_1byte_bitmask(btcoexist, 0xcbd,
+							   0x3, regval_0xcbd);
+
+			break;
+		case BT_8822B_1ANT_SWITCH_CTRL_BY_ANTDIV:
+			/* 0x4c[23] = 0 */
+			btcoexist->btc_write_1byte_bitmask(btcoexist, 0x4e,
+							   0x80, 0x0);
+			/* 0x4c[24] = 1 */
+			btcoexist->btc_write_1byte_bitmask(btcoexist, 0x4f,
+							   0x01, 0x1);
+			btcoexist->btc_write_1byte_bitmask(btcoexist, 0xcb4,
+							   0xff, 0x88);
+
+			/* no regval_0xcbd setup required, because
+			 * antenna switch control value by antenna diversity
+			 */
+
+			break;
+		case BT_8822B_1ANT_SWITCH_CTRL_BY_MAC:
+			/*  0x4c[23] = 1 */
+			btcoexist->btc_write_1byte_bitmask(btcoexist, 0x4e,
+							   0x80, 0x1);
+
+			/* 0x64[0] = 1b'0 for no switch_polarity_inverse,
+			 * DPDT_SEL_N =1, DPDT_SEL_P =0
+			 */
+			regval_0x64 = (!switch_polarity_inverse ? 0x0 : 0x1);
+			btcoexist->btc_write_1byte_bitmask(btcoexist, 0x64, 0x1,
+							   regval_0x64);
+			break;
+		case BT_8822B_1ANT_SWITCH_CTRL_BY_BT:
+			/* 0x4c[23] = 0 */
+			btcoexist->btc_write_1byte_bitmask(btcoexist, 0x4e,
+							   0x80, 0x0);
+			/* 0x4c[24] = 0 */
+			btcoexist->btc_write_1byte_bitmask(btcoexist, 0x4f,
+							   0x01, 0x0);
+
+			/* no setup required, because antenna switch control
+			 * value by BT vendor 0xac[1:0]
+			 */
+			break;
+		}
+	}
+
+	u32tmp1 = btcoexist->btc_read_4byte(btcoexist, 0xcbc);
+	u32tmp2 = btcoexist->btc_read_4byte(btcoexist, 0x4c);
+	u32tmp3 = btcoexist->btc_read_4byte(btcoexist, 0x64) & 0xff;
+
+	RT_TRACE(rtlpriv, COMP_BT_COEXIST, DBG_LOUD,
+		 "[BTCoex], (After Ext Ant switch setup) 0xcbc = 0x%08x, 0x4c = 0x%08x, 0x64= 0x%02x\n",
+		 u32tmp1, u32tmp2, u32tmp3);
+}
+
+/* set gnt_wl gnt_bt control by sw high low, or
+ * hwpta while in power on, ini, wlan off, wlan only, wl2g non-currrent,
+ * wl2g current, wl5g
+ */
+
+static
+void halbtc8822b1ant_set_ant_path(struct btc_coexist *btcoexist,
+				  u8 ant_pos_type, bool force_exec, u8 phase)
+
+{
+	struct rtl_priv *rtlpriv = btcoexist->adapter;
+	u8 u8tmp = 0;
+	u32 u32tmp1 = 0;
+	u32 u32tmp2 = 0, u32tmp3 = 0;
+
+	u32tmp1 = halbtc8822b1ant_ltecoex_read_reg(btcoexist, 0x38);
+
+	/* To avoid indirect access fail  */
+	if (((u32tmp1 & 0xf000) >> 12) != ((u32tmp1 & 0x0f00) >> 8)) {
+		force_exec = true;
+		coex_sta->gnt_error_cnt++;
+
+		RT_TRACE(rtlpriv, COMP_BT_COEXIST, DBG_LOUD,
+			 "[BTCoex],(Before Ant Setup) 0x38= 0x%x\n",
+			 u32tmp1);
+	}
+
+	/* Ext switch buffer mux */
+	btcoexist->btc_write_1byte(btcoexist, 0x974, 0xff);
+	btcoexist->btc_write_1byte_bitmask(btcoexist, 0x1991, 0x3, 0x0);
+	btcoexist->btc_write_1byte_bitmask(btcoexist, 0xcbe, 0x8, 0x0);
+
+	coex_dm->cur_ant_pos_type = (ant_pos_type << 8) + phase;
+
+	if (!force_exec) {
+		if (coex_dm->cur_ant_pos_type == coex_dm->pre_ant_pos_type)
+			return;
+	}
+
+	coex_dm->pre_ant_pos_type = coex_dm->cur_ant_pos_type;
+
+	if (btcoexist->dbg_mode_1ant) {
+		u32tmp1 = halbtc8822b1ant_ltecoex_read_reg(btcoexist, 0x38);
+		u32tmp2 = halbtc8822b1ant_ltecoex_read_reg(btcoexist, 0x54);
+		u32tmp3 = btcoexist->btc_read_4byte(btcoexist, 0xcb4);
+
+		u8tmp = btcoexist->btc_read_1byte(btcoexist, 0x73);
+
+		RT_TRACE(rtlpriv, COMP_BT_COEXIST, DBG_LOUD,
+			 "[BTCoex], ********** (Before Ant Setup) 0xcb4 = 0x%x, 0x73 = 0x%x, 0x38= 0x%x, 0x54= 0x%x**********\n",
+			 u32tmp3, u8tmp, u32tmp1, u32tmp2);
+	}
+
+	switch (phase) {
+	case BT_8822B_1ANT_PHASE_POWERON:
+		RT_TRACE(rtlpriv, COMP_BT_COEXIST, DBG_LOUD,
+			 "[BTCoex], ********** (set_ant_path - 1ANT_PHASE_COEX_POWERON) **********\n");
+
+		/* set Path control owner to BT at power-on step */
+		hallbtc882b1ant_ltecoex_ctrl_owner(btcoexist,
+						   BT_8822B_1ANT_PCO_BTSIDE);
+
+		/* set GNT_BT to SW high */
+		halbtc8822b1ant_set_gnt_bt(btcoexist,
+					   BT_8822B_1ANT_GNT_BLOCK_RFC_BB,
+					   BT_8822B_1ANT_GNT_CTRL_BY_SW,
+					   BT_8822B_1ANT_SIG_STA_SET_TO_HIGH);
+		/* Set GNT_WL to SW high */
+		halbtc8822b1ant_set_gnt_wl(btcoexist,
+					   BT_8822B_1ANT_GNT_BLOCK_RFC_BB,
+					   BT_8822B_1ANT_GNT_CTRL_BY_SW,
+					   BT_8822B_1ANT_SIG_STA_SET_TO_HIGH);
+
+		if (ant_pos_type == BTC_ANT_PATH_AUTO)
+			ant_pos_type = BTC_ANT_PATH_BT;
+
+		coex_sta->run_time_state = false;
+		break;
+	case BT_8822B_1ANT_PHASE_INIT:
+		RT_TRACE(rtlpriv, COMP_BT_COEXIST, DBG_LOUD,
+			 "[BTCoex], ********** (set_ant_path - 1ANT_PHASE_COEX_INIT) **********\n");
+
+		halbtc8822b1ant_ltecoex_enable(btcoexist, 0x0);
+
+		hallbtc882b1ant_ltecoex_table(btcoexist,
+					      BT_8822B_1ANT_CTT_WL_VS_LTE,
+						       0xffff);
+
+		hallbtc882b1ant_ltecoex_table(btcoexist,
+					      BT_8822B_1ANT_CTT_BT_VS_LTE,
+					      0xffff);
+
+		/* set GNT_BT to SW high */
+		halbtc8822b1ant_set_gnt_bt(btcoexist,
+					   BT_8822B_1ANT_GNT_BLOCK_RFC_BB,
+					   BT_8822B_1ANT_GNT_CTRL_BY_SW,
+					   BT_8822B_1ANT_SIG_STA_SET_TO_HIGH);
+
+		/* set GNT_WL to SW low */
+		halbtc8822b1ant_set_gnt_wl(btcoexist,
+					   BT_8822B_1ANT_GNT_BLOCK_RFC_BB,
+					   BT_8822B_1ANT_GNT_CTRL_BY_SW,
+					   BT_8822B_1ANT_SIG_STA_SET_TO_LOW);
+
+		/* set Path control owner to WL at initial step */
+		hallbtc882b1ant_ltecoex_ctrl_owner(btcoexist,
+						   BT_8822B_1ANT_PCO_WLSIDE);
+
+		coex_sta->run_time_state = false;
+
+		if (ant_pos_type == BTC_ANT_PATH_AUTO)
+			ant_pos_type = BTC_ANT_PATH_BT;
+
+		break;
+	case BT_8822B_1ANT_PHASE_WONLY:
+		RT_TRACE(rtlpriv, COMP_BT_COEXIST, DBG_LOUD,
+			 "[BTCoex], ********** (set_ant_path - 1ANT_PHASE_WLANONLY_INIT) **********\n");
+
+		halbtc8822b1ant_ltecoex_enable(btcoexist, 0x0);
+
+		hallbtc882b1ant_ltecoex_table(btcoexist,
+					      BT_8822B_1ANT_CTT_WL_VS_LTE,
+					      0xffff);
+
+		hallbtc882b1ant_ltecoex_table(btcoexist,
+					      BT_8822B_1ANT_CTT_BT_VS_LTE,
+					      0xffff);
+
+		/* set GNT_BT to SW Low */
+		halbtc8822b1ant_set_gnt_bt(btcoexist,
+					   BT_8822B_1ANT_GNT_BLOCK_RFC_BB,
+					   BT_8822B_1ANT_GNT_CTRL_BY_SW,
+					   BT_8822B_1ANT_SIG_STA_SET_TO_LOW);
+
+		/* Set GNT_WL to SW high */
+		halbtc8822b1ant_set_gnt_wl(btcoexist,
+					   BT_8822B_1ANT_GNT_BLOCK_RFC_BB,
+					   BT_8822B_1ANT_GNT_CTRL_BY_SW,
+					   BT_8822B_1ANT_SIG_STA_SET_TO_HIGH);
+
+		/* set Path control owner to WL at initial step */
+		hallbtc882b1ant_ltecoex_ctrl_owner(btcoexist,
+						   BT_8822B_1ANT_PCO_WLSIDE);
+
+		coex_sta->run_time_state = false;
+
+		if (ant_pos_type == BTC_ANT_PATH_AUTO)
+			ant_pos_type = BTC_ANT_PATH_WIFI;
+
+		break;
+	case BT_8822B_1ANT_PHASE_WOFF:
+		RT_TRACE(rtlpriv, COMP_BT_COEXIST, DBG_LOUD,
+			 "[BTCoex], ********** (set_ant_path - 1ANT_PHASE_WLAN_OFF) **********\n");
+
+		/* Disable LTE Coex Function in WiFi side */
+		halbtc8822b1ant_ltecoex_enable(btcoexist, 0x0);
+
+		/* set Path control owner to BT */
+		hallbtc882b1ant_ltecoex_ctrl_owner(btcoexist,
+						   BT_8822B_1ANT_PCO_BTSIDE);
+
+		/* Set Ext Ant Switch to BT control at wifi off step */
+		hallbtc882b1ant_set_ant_switch(btcoexist, FORCE_EXEC,
+					       BT_8822B_1ANT_SWITCH_CTRL_BY_BT,
+					       BT_8822B_1ANT_SWITCH_TO_NOCARE);
+
+		coex_sta->run_time_state = false;
+
+		break;
+	case BT_8822B_1ANT_PHASE_2G:
+		RT_TRACE(rtlpriv, COMP_BT_COEXIST, DBG_LOUD,
+			 "[BTCoex], ********** (set_ant_path - 1ANT_PHASE_2G_RUNTIME) **********\n");
+
+		/* set GNT_BT to PTA */
+		halbtc8822b1ant_set_gnt_bt(btcoexist,
+					   BT_8822B_1ANT_GNT_BLOCK_RFC_BB,
+					   BT_8822B_1ANT_GNT_CTRL_BY_PTA,
+					   BT_8822B_1ANT_SIG_STA_SET_BY_HW);
+
+		/* Set GNT_WL to PTA */
+		halbtc8822b1ant_set_gnt_wl(btcoexist,
+					   BT_8822B_1ANT_GNT_BLOCK_RFC_BB,
+					   BT_8822B_1ANT_GNT_CTRL_BY_PTA,
+					   BT_8822B_1ANT_SIG_STA_SET_BY_HW);
+
+		/* set Path control owner to WL at runtime step */
+		hallbtc882b1ant_ltecoex_ctrl_owner(btcoexist,
+						   BT_8822B_1ANT_PCO_WLSIDE);
+
+		coex_sta->run_time_state = true;
+
+		if (ant_pos_type == BTC_ANT_PATH_AUTO)
+			ant_pos_type = BTC_ANT_PATH_PTA;
+
+		break;
+	case BT_8822B_1ANT_PHASE_5G:
+	case BT_8822B_1ANT_PHASE_2G_WL:
+	case BT_8822B_1ANT_PHASE_2G_BT:
+
+		RT_TRACE(rtlpriv, COMP_BT_COEXIST, DBG_LOUD,
+			 "[BTCoex], ********** (set_ant_path - %d)\n",
+			 phase);
+
+		/* set GNT_BT to SW Hi */
+		halbtc8822b1ant_set_gnt_bt(btcoexist,
+					   BT_8822B_1ANT_GNT_BLOCK_RFC_BB,
+					   BT_8822B_1ANT_GNT_CTRL_BY_SW,
+					   BT_8822B_1ANT_SIG_STA_SET_TO_HIGH);
+
+		/* Set GNT_WL to SW Hi */
+		halbtc8822b1ant_set_gnt_wl(btcoexist,
+					   BT_8822B_1ANT_GNT_BLOCK_RFC_BB,
+					   BT_8822B_1ANT_GNT_CTRL_BY_SW,
+					   BT_8822B_1ANT_SIG_STA_SET_TO_HIGH);
+
+		/* set Path control owner to WL at runtime step */
+		hallbtc882b1ant_ltecoex_ctrl_owner(btcoexist,
+						   BT_8822B_1ANT_PCO_WLSIDE);
+
+		coex_sta->run_time_state = true;
+
+		if (phase == BT_8822B_1ANT_PHASE_2G_WL)
+			ant_pos_type = BTC_ANT_PATH_WIFI;
+		else if (phase == BT_8822B_1ANT_PHASE_2G_BT)
+			ant_pos_type = BTC_ANT_PATH_BT;
+		if (ant_pos_type == BTC_ANT_PATH_AUTO)
+			ant_pos_type = BTC_ANT_PATH_WIFI5G;
+
+		break;
+	case BT_8822B_1ANT_PHASE_BTMP:
+		RT_TRACE(rtlpriv, COMP_BT_COEXIST, DBG_LOUD,
+			 "[BTCoex], ********** (set_ant_path - 1ANT_PHASE_BTMPMODE) **********\n");
+
+		/* Disable LTE Coex Function in WiFi side */
+		halbtc8822b1ant_ltecoex_enable(btcoexist, 0x0);
+
+		/* set GNT_BT to SW Hi */
+		halbtc8822b1ant_set_gnt_bt(btcoexist,
+					   BT_8822B_1ANT_GNT_BLOCK_RFC_BB,
+					   BT_8822B_1ANT_GNT_CTRL_BY_SW,
+					   BT_8822B_1ANT_SIG_STA_SET_TO_HIGH);
+
+		/* Set GNT_WL to SW Lo */
+		halbtc8822b1ant_set_gnt_wl(btcoexist,
+					   BT_8822B_1ANT_GNT_BLOCK_RFC_BB,
+					   BT_8822B_1ANT_GNT_CTRL_BY_SW,
+					   BT_8822B_1ANT_SIG_STA_SET_TO_LOW);
+
+		/* set Path control owner to WL */
+		hallbtc882b1ant_ltecoex_ctrl_owner(btcoexist,
+						   BT_8822B_1ANT_PCO_WLSIDE);
+
+		coex_sta->run_time_state = false;
+
+		/* Set Ext Ant Switch to BT side at BT MP mode */
+		if (ant_pos_type == BTC_ANT_PATH_AUTO)
+			ant_pos_type = BTC_ANT_PATH_BT;
+
+		break;
+	case BT_8822B_1ANT_PHASE_MCC:
+		RT_TRACE(rtlpriv, COMP_BT_COEXIST, DBG_LOUD,
+			 "[BTCoex], (set_ant_path - 1ANT_PHASE_MCC_DUALBAND_RUNTIME)\n");
+
+		/* set GNT_BT to PTA */
+		halbtc8822b1ant_set_gnt_bt(btcoexist,
+					   BT_8822B_1ANT_GNT_BLOCK_RFC_BB,
+					   BT_8822B_1ANT_GNT_CTRL_BY_PTA,
+					   BT_8822B_1ANT_SIG_STA_SET_BY_HW);
+
+		/* Set GNT_WL to PTA */
+		halbtc8822b1ant_set_gnt_wl(btcoexist,
+					   BT_8822B_1ANT_GNT_BLOCK_RFC_BB,
+					   BT_8822B_1ANT_GNT_CTRL_BY_PTA,
+					   BT_8822B_1ANT_SIG_STA_SET_BY_HW);
+
+		/* set Path control owner to WL at runtime step */
+		hallbtc882b1ant_ltecoex_ctrl_owner(btcoexist,
+						   BT_8822B_1ANT_PCO_WLSIDE);
+
+		coex_sta->run_time_state = true;
+
+		if (ant_pos_type == BTC_ANT_PATH_AUTO)
+			ant_pos_type = BTC_ANT_PATH_PTA;
+
+		break;
+	}
+
+	if (phase != BT_8822B_1ANT_PHASE_WOFF &&
+	    phase != BT_8822B_1ANT_PHASE_MCC) {
+		u8 ctrl_type, pos_type;
+
+		switch (ant_pos_type) {
+		case BTC_ANT_PATH_WIFI:
+			if (phase == BT_8822B_1ANT_PHASE_2G_WL) {
+				ctrl_type = BT_8822B_1ANT_SWITCH_CTRL_BY_BBSW;
+				pos_type = BT_8822B_1ANT_SWITCH_TO_S0WLG_S1BT;
+			} else {
+				ctrl_type = BT_8822B_1ANT_SWITCH_CTRL_BY_BBSW;
+				pos_type = BT_8822B_1ANT_SWITCH_TO_WLG;
+			}
+			break;
+		case BTC_ANT_PATH_WIFI5G:
+			ctrl_type = BT_8822B_1ANT_SWITCH_CTRL_BY_BBSW;
+			pos_type = BT_8822B_1ANT_SWITCH_TO_WLA;
+			break;
+		case BTC_ANT_PATH_BT:
+			ctrl_type = BT_8822B_1ANT_SWITCH_CTRL_BY_BBSW;
+			pos_type = BT_8822B_1ANT_SWITCH_TO_BT;
+			break;
+		default:
+		case BTC_ANT_PATH_PTA:
+			ctrl_type = BT_8822B_1ANT_SWITCH_CTRL_BY_PTA;
+			pos_type = BT_8822B_1ANT_SWITCH_TO_NOCARE;
+			break;
+		}
+
+		hallbtc882b1ant_set_ant_switch(btcoexist, force_exec,
+					       ctrl_type, pos_type);
+	}
+
+	if (btcoexist->dbg_mode_1ant) {
+		u32tmp1 = halbtc8822b1ant_ltecoex_read_reg(btcoexist, 0x38);
+		u32tmp2 = halbtc8822b1ant_ltecoex_read_reg(btcoexist, 0x54);
+		u32tmp3 = btcoexist->btc_read_4byte(btcoexist, 0xcbd);
+
+		u8tmp = btcoexist->btc_read_1byte(btcoexist, 0x73);
+
+		RT_TRACE(rtlpriv, COMP_BT_COEXIST, DBG_LOUD,
+			 "[BTCoex], (After Ant Setup) 0xcbd = 0x%x, 0x73 = 0x%x, 0x38= 0x%x, 0x54= 0x%x\n",
+			 u32tmp3, u8tmp, u32tmp1, u32tmp2);
+	}
+}
+
+static bool halbtc8822b1ant_is_common_action(struct btc_coexist *btcoexist)
+{
+	struct rtl_priv *rtlpriv = btcoexist->adapter;
+	bool common = false, wifi_connected = false, wifi_busy = false;
+
+	btcoexist->btc_get(btcoexist, BTC_GET_BL_WIFI_CONNECTED,
+			   &wifi_connected);
+	btcoexist->btc_get(btcoexist, BTC_GET_BL_WIFI_BUSY, &wifi_busy);
+
+	if (!wifi_connected &&
+	    coex_dm->bt_status == BT_8822B_1ANT_BT_STATUS_NCONNECTED_IDLE) {
+		RT_TRACE(rtlpriv, COMP_BT_COEXIST, DBG_LOUD,
+			 "[BTCoex], Wifi non connected-idle + BT non connected-idle!!\n");
+		common = true;
+	} else if (wifi_connected &&
+		   (coex_dm->bt_status ==
+		    BT_8822B_1ANT_BT_STATUS_NCONNECTED_IDLE)) {
+		RT_TRACE(rtlpriv, COMP_BT_COEXIST, DBG_LOUD,
+			 "[BTCoex], Wifi connected + BT non connected-idle!!\n");
+		common = true;
+	} else if (!wifi_connected &&
+		   (BT_8822B_1ANT_BT_STATUS_CONNECTED_IDLE ==
+		    coex_dm->bt_status)) {
+		RT_TRACE(rtlpriv, COMP_BT_COEXIST, DBG_LOUD,
+			 "[BTCoex], Wifi non connected-idle + BT connected-idle!!\n");
+		common = true;
+	} else if (wifi_connected &&
+		   (BT_8822B_1ANT_BT_STATUS_CONNECTED_IDLE ==
+		    coex_dm->bt_status)) {
+		RT_TRACE(rtlpriv, COMP_BT_COEXIST, DBG_LOUD,
+			 "[BTCoex], Wifi connected + BT connected-idle!!\n");
+		common = true;
+	} else if (!wifi_connected &&
+		   (BT_8822B_1ANT_BT_STATUS_CONNECTED_IDLE !=
+		    coex_dm->bt_status)) {
+		RT_TRACE(rtlpriv, COMP_BT_COEXIST, DBG_LOUD,
+			 "[BTCoex], Wifi non connected-idle + BT Busy!!\n");
+		common = true;
+	} else {
+		if (wifi_busy) {
+			RT_TRACE(rtlpriv, COMP_BT_COEXIST, DBG_LOUD,
+				 "[BTCoex], Wifi Connected-Busy + BT Busy!!\n");
+		} else {
+			RT_TRACE(rtlpriv, COMP_BT_COEXIST, DBG_LOUD,
+				 "[BTCoex], Wifi Connected-Idle + BT Busy!!\n");
+		}
+
+		common = false;
+	}
+
+	return common;
+}
+
+static void halbtc8822b1ant_action_bt_whql_test(struct btc_coexist *btcoexist)
+{
+	struct rtl_priv *rtlpriv = btcoexist->adapter;
+
+	RT_TRACE(rtlpriv, COMP_BT_COEXIST, DBG_LOUD,
+		 "[BTCoex],action_bt_whck_test\n");
+
+	halbtc8822b1ant_adjust_wl_tx_power(btcoexist, NORMAL_EXEC, 0xd8);
+	halbtc8822b1ant_adjust_bt_tx_power(btcoexist, NORMAL_EXEC, 0);
+	halbtc8822b1ant_adjust_wl_rx_gain(btcoexist, NORMAL_EXEC, false);
+	halbtc8822b1ant_adjust_bt_rx_gain(btcoexist, NORMAL_EXEC, false);
+
+	halbtc8822b1ant_coex_table_type(btcoexist, NORMAL_EXEC, 0);
+	halbtc8822b1ant_ps_tdma(btcoexist, NORMAL_EXEC, false, 8);
+
+	halbtc8822b1ant_set_ant_path(btcoexist, BTC_ANT_PATH_AUTO, NORMAL_EXEC,
+				     BT_8822B_1ANT_PHASE_2G);
+}
+
+static void halbtc8822b1ant_action_bt_relink(struct btc_coexist *btcoexist)
+{
+	struct btc_bt_link_info *bt_link_info = &btcoexist->bt_link_info;
+
+	if ((!coex_sta->is_bt_multi_link && !bt_link_info->pan_exist) ||
+	    (bt_link_info->a2dp_exist && bt_link_info->hid_exist)) {
+		halbtc8822b1ant_adjust_wl_tx_power(btcoexist, NORMAL_EXEC,
+						   0xd8);
+		halbtc8822b1ant_adjust_bt_tx_power(btcoexist, NORMAL_EXEC, 0);
+		halbtc8822b1ant_adjust_wl_rx_gain(btcoexist, NORMAL_EXEC,
+						  false);
+		halbtc8822b1ant_adjust_bt_rx_gain(btcoexist, NORMAL_EXEC,
+						  false);
+
+		halbtc8822b1ant_coex_table_type(btcoexist, NORMAL_EXEC, 0);
+		halbtc8822b1ant_ps_tdma(btcoexist, NORMAL_EXEC, false, 8);
+	}
+}
+
+static void halbtc8822b1ant_action_bt_idle(struct btc_coexist *btcoexist)
+{
+	bool wifi_busy = false;
+
+	btcoexist->btc_get(btcoexist, BTC_GET_BL_WIFI_BUSY, &wifi_busy);
+
+	halbtc8822b1ant_adjust_wl_tx_power(btcoexist, NORMAL_EXEC, 0xd8);
+	halbtc8822b1ant_adjust_bt_tx_power(btcoexist, NORMAL_EXEC, 0);
+	halbtc8822b1ant_adjust_wl_rx_gain(btcoexist, NORMAL_EXEC, false);
+	halbtc8822b1ant_adjust_bt_rx_gain(btcoexist, NORMAL_EXEC, false);
+
+	if (!wifi_busy) {
+		halbtc8822b1ant_coex_table_type(btcoexist, NORMAL_EXEC, 23);
+		halbtc8822b1ant_ps_tdma(btcoexist, NORMAL_EXEC, true, 32);
+
+	} else { /* if wl busy */
+
+		if (BT_8822B_1ANT_BT_STATUS_NCONNECTED_IDLE ==
+		    coex_dm->bt_status) {
+			halbtc8822b1ant_coex_table_type(btcoexist, NORMAL_EXEC,
+							23);
+			halbtc8822b1ant_ps_tdma(btcoexist, NORMAL_EXEC, true,
+						33);
+		} else {
+			halbtc8822b1ant_coex_table_type(btcoexist, NORMAL_EXEC,
+							23);
+			halbtc8822b1ant_ps_tdma(btcoexist, NORMAL_EXEC, true,
+						32);
+		}
+	}
+}
+
+/*"""bt inquiry"""" + wifi any + bt any*/
+
+static void halbtc8822b1ant_action_bt_inquiry(struct btc_coexist *btcoexist)
+{
+	struct rtl_priv *rtlpriv = btcoexist->adapter;
+	struct btc_bt_link_info *bt_link_info = &btcoexist->bt_link_info;
+	bool wifi_connected = false, wifi_busy = false, bt_busy = false;
+	bool wifi_scan = false, link = false, roam = false;
+
+	RT_TRACE(rtlpriv, COMP_BT_COEXIST, DBG_LOUD,
+		 "[BTCoex], ********** (bt inquiry) **********\n");
+
+	halbtc8822b1ant_adjust_wl_tx_power(btcoexist, NORMAL_EXEC, 0xd8);
+	halbtc8822b1ant_adjust_bt_tx_power(btcoexist, NORMAL_EXEC, 0);
+	halbtc8822b1ant_adjust_wl_rx_gain(btcoexist, NORMAL_EXEC, false);
+	halbtc8822b1ant_adjust_bt_rx_gain(btcoexist, NORMAL_EXEC, false);
+
+	btcoexist->btc_get(btcoexist, BTC_GET_BL_WIFI_CONNECTED,
+			   &wifi_connected);
+	btcoexist->btc_get(btcoexist, BTC_GET_BL_WIFI_BUSY, &wifi_busy);
+	btcoexist->btc_set(btcoexist, BTC_SET_BL_BT_TRAFFIC_BUSY, &bt_busy);
+	btcoexist->btc_get(btcoexist, BTC_GET_BL_WIFI_SCAN, &wifi_scan);
+	btcoexist->btc_get(btcoexist, BTC_GET_BL_WIFI_LINK, &link);
+	btcoexist->btc_get(btcoexist, BTC_GET_BL_WIFI_ROAM, &roam);
+
+	RT_TRACE(rtlpriv, COMP_BT_COEXIST, DBG_LOUD,
+		 "[BTCoex], ********** scan = %d,  link =%d, roam = %d**********\n",
+		 wifi_scan, link, roam);
+
+	if (link || roam || coex_sta->wifi_is_high_pri_task) {
+		RT_TRACE(rtlpriv, COMP_BT_COEXIST, DBG_LOUD,
+			 "[BTCoex], ********** (bt inquiry wifi connect or scan ) **********\n");
+
+		halbtc8822b1ant_coex_table_type(btcoexist, NORMAL_EXEC, 6);
+		halbtc8822b1ant_ps_tdma(btcoexist, NORMAL_EXEC, true, 1);
+
+	} else if ((wifi_scan) && (coex_sta->bt_create_connection)) {
+		halbtc8822b1ant_coex_table_type(btcoexist, NORMAL_EXEC, 1);
+		halbtc8822b1ant_ps_tdma(btcoexist, NORMAL_EXEC, true, 22);
+
+	} else if ((!wifi_connected) && (!wifi_scan)) {
+		RT_TRACE(rtlpriv, COMP_BT_COEXIST, DBG_LOUD,
+			 "[BTCoex], ********** (bt inquiry wifi non connect) **********\n");
+
+		halbtc8822b1ant_coex_table_type(btcoexist, NORMAL_EXEC, 0);
+		halbtc8822b1ant_ps_tdma(btcoexist, NORMAL_EXEC, false, 8);
+
+	} else if ((bt_link_info->a2dp_exist) && (bt_link_info->pan_exist)) {
+		halbtc8822b1ant_coex_table_type(btcoexist, NORMAL_EXEC, 4);
+		halbtc8822b1ant_ps_tdma(btcoexist, NORMAL_EXEC, true, 22);
+	} else if (bt_link_info->a2dp_exist) {
+		halbtc8822b1ant_coex_table_type(btcoexist, NORMAL_EXEC, 23);
+		halbtc8822b1ant_ps_tdma(btcoexist, NORMAL_EXEC, true, 32);
+	} else if (wifi_scan) {
+		halbtc8822b1ant_coex_table_type(btcoexist, NORMAL_EXEC, 4);
+		halbtc8822b1ant_ps_tdma(btcoexist, NORMAL_EXEC, true, 20);
+	} else if (wifi_busy) {
+		/*aaaa->55aa for bt connect while wl busy*/
+		halbtc8822b1ant_coex_table_type(btcoexist, NORMAL_EXEC, 23);
+		halbtc8822b1ant_ps_tdma(btcoexist, NORMAL_EXEC, true, 32);
+	} else {
+		RT_TRACE(rtlpriv, COMP_BT_COEXIST, DBG_LOUD,
+			 "[BTCoex], ********** (bt inquiry wifi connect) **********\n");
+
+		halbtc8822b1ant_coex_table_type(btcoexist, NORMAL_EXEC, 23);
+		halbtc8822b1ant_ps_tdma(btcoexist, NORMAL_EXEC, true, 32);
+	}
+}
+
+static
+void halbtc8822b1ant_action_bt_sco_hid_busy(struct btc_coexist *btcoexist)
+{
+	struct btc_bt_link_info *bt_link_info = &btcoexist->bt_link_info;
+	bool wifi_connected = false, wifi_busy = false;
+	u32 wifi_bw = 1;
+
+	halbtc8822b1ant_adjust_wl_tx_power(btcoexist, NORMAL_EXEC, 0xd8);
+	halbtc8822b1ant_adjust_bt_tx_power(btcoexist, NORMAL_EXEC, 0);
+	halbtc8822b1ant_adjust_wl_rx_gain(btcoexist, NORMAL_EXEC, false);
+	halbtc8822b1ant_adjust_bt_rx_gain(btcoexist, NORMAL_EXEC, false);
+
+	btcoexist->btc_get(btcoexist, BTC_GET_BL_WIFI_CONNECTED,
+			   &wifi_connected);
+	btcoexist->btc_get(btcoexist, BTC_GET_U4_WIFI_BW, &wifi_bw);
+	btcoexist->btc_get(btcoexist, BTC_GET_BL_WIFI_BUSY, &wifi_busy);
+
+	if (coex_sta->msft_mr_exist) {
+		halbtc8822b1ant_coex_table_type(btcoexist, NORMAL_EXEC, 8);
+		halbtc8822b1ant_ps_tdma(btcoexist, NORMAL_EXEC, false, 8);
+
+	} else if (bt_link_info->sco_exist) {
+		if (coex_sta->is_bt_multi_link) {
+			halbtc8822b1ant_coex_table_type(btcoexist, NORMAL_EXEC,
+							1);
+			halbtc8822b1ant_ps_tdma(btcoexist, NORMAL_EXEC, true,
+						25);
+		} else {
+			halbtc8822b1ant_coex_table_type(btcoexist, NORMAL_EXEC,
+							5);
+			halbtc8822b1ant_ps_tdma(btcoexist, NORMAL_EXEC, true,
+						5);
+		}
+	} else if (coex_sta->is_hid_rcu) {
+		halbtc8822b1ant_coex_table_type(btcoexist, NORMAL_EXEC, 3);
+
+		if (wifi_busy)
+			halbtc8822b1ant_ps_tdma(btcoexist, NORMAL_EXEC, true,
+						36);
+		else
+			halbtc8822b1ant_ps_tdma(btcoexist, NORMAL_EXEC, true,
+						6);
+	} else {
+		if (coex_sta->is_hid_low_pri_tx_overhead) {
+			if (coex_sta->hid_busy_num < 2)
+				halbtc8822b1ant_coex_table_type(btcoexist,
+								NORMAL_EXEC, 1);
+			else
+				halbtc8822b1ant_coex_table_type(btcoexist,
+								NORMAL_EXEC, 6);
+			halbtc8822b1ant_ps_tdma(btcoexist, NORMAL_EXEC, true,
+						18);
+		} else if (coex_sta->hid_busy_num < 2) {
+			halbtc8822b1ant_coex_table_type(btcoexist, NORMAL_EXEC,
+							1);
+			halbtc8822b1ant_ps_tdma(btcoexist, NORMAL_EXEC, true,
+						11);
+		} else if (wifi_bw == 0) { /* if 11bg mode */
+			halbtc8822b1ant_coex_table_type(btcoexist, NORMAL_EXEC,
+							11);
+			halbtc8822b1ant_ps_tdma(btcoexist, NORMAL_EXEC, true,
+						11);
+		} else {
+			halbtc8822b1ant_coex_table_type(btcoexist, NORMAL_EXEC,
+							6);
+			halbtc8822b1ant_ps_tdma(btcoexist, NORMAL_EXEC, true,
+						11);
+		}
+	}
+}
+
+static void halbtc8822b1ant_action_bt_mr(struct btc_coexist *btcoexist)
+{
+	struct rtl_priv *rtlpriv = btcoexist->adapter;
+
+	RT_TRACE(rtlpriv, COMP_BT_COEXIST, DBG_LOUD,
+		 "[BTCoex], RunCoexistMechanism(), microsoft MR!!\n");
+
+	if (coex_sta->wl_center_channel <= 14) {
+		halbtc8822b1ant_set_ant_path(btcoexist,
+					     BTC_ANT_PATH_AUTO, NORMAL_EXEC,
+					     BT_8822B_1ANT_PHASE_2G_WL);
+
+		halbtc8822b1ant_action_bt_sco_hid_busy(btcoexist);
+
+		/* Enter MIMO Power Save, 0:enable */
+		halbtc8822b1ant_mimo_ps(btcoexist, NORMAL_EXEC, 0);
+	} else {
+		halbtc8822b1ant_set_ant_path(btcoexist, BTC_ANT_PATH_AUTO,
+					     NORMAL_EXEC,
+					     BT_8822B_1ANT_PHASE_5G);
+
+		halbtc8822b1ant_action_bt_sco_hid_busy(btcoexist);
+
+		/* No MIMO Power Save, 3:disable */
+		halbtc8822b1ant_mimo_ps(btcoexist, NORMAL_EXEC, 3);
+	}
+}
+
+static void halbtc8822b1ant_action_rf4ce(struct btc_coexist *btcoexist)
+{
+	halbtc8822b1ant_adjust_wl_tx_power(btcoexist, NORMAL_EXEC, 0xd8);
+	halbtc8822b1ant_adjust_bt_tx_power(btcoexist, NORMAL_EXEC, 0);
+	halbtc8822b1ant_adjust_wl_rx_gain(btcoexist, NORMAL_EXEC, false);
+	halbtc8822b1ant_adjust_bt_rx_gain(btcoexist, NORMAL_EXEC, false);
+
+	halbtc8822b1ant_coex_table_type(btcoexist, NORMAL_EXEC, 1);
+	halbtc8822b1ant_ps_tdma(btcoexist, NORMAL_EXEC, true, 50);
+}
+
+static void halbtc8822b1ant_action_wifi_under5g(struct btc_coexist *btcoexist)
+{
+	struct rtl_priv *rtlpriv = btcoexist->adapter;
+
+	RT_TRACE(rtlpriv, COMP_BT_COEXIST, DBG_LOUD,
+		 "[BTCoex], under 5g start\n");
+
+	halbtc8822b1ant_adjust_wl_tx_power(btcoexist, NORMAL_EXEC, 0xd8);
+	halbtc8822b1ant_adjust_bt_tx_power(btcoexist, NORMAL_EXEC, 0);
+	halbtc8822b1ant_adjust_wl_rx_gain(btcoexist, NORMAL_EXEC, false);
+	halbtc8822b1ant_adjust_bt_rx_gain(btcoexist, NORMAL_EXEC, false);
+
+	halbtc8822b1ant_set_ant_path(btcoexist, BTC_ANT_PATH_AUTO, FORCE_EXEC,
+				     BT_8822B_1ANT_PHASE_5G);
+
+	halbtc8822b1ant_coex_table_type(btcoexist, NORMAL_EXEC, 0);
+	halbtc8822b1ant_ps_tdma(btcoexist, NORMAL_EXEC, false, 8);
+}
+
+static void halbtc8822b1ant_action_wifi_only(struct btc_coexist *btcoexist)
+{
+	struct rtl_priv *rtlpriv = btcoexist->adapter;
+	bool wifi_under_5g = false, rf4ce_enabled = false,
+		wifi_connected = false;
+
+	halbtc8822b1ant_adjust_wl_tx_power(btcoexist, NORMAL_EXEC, 0xd8);
+	halbtc8822b1ant_adjust_bt_tx_power(btcoexist, NORMAL_EXEC, 0);
+	halbtc8822b1ant_adjust_wl_rx_gain(btcoexist, NORMAL_EXEC, false);
+	halbtc8822b1ant_adjust_bt_rx_gain(btcoexist, NORMAL_EXEC, false);
+
+	btcoexist->btc_get(btcoexist, BTC_GET_BL_RF4CE_CONNECTED,
+			   &rf4ce_enabled);
+	btcoexist->btc_get(btcoexist, BTC_GET_BL_WIFI_UNDER_5G, &wifi_under_5g);
+	btcoexist->btc_get(btcoexist, BTC_GET_BL_WIFI_CONNECTED,
+			   &wifi_connected);
+
+	if ((rf4ce_enabled) && (wifi_connected)) {
+		RT_TRACE(rtlpriv, COMP_BT_COEXIST, DBG_LOUD,
+			 "[BTCoex], ********** (wlan only -- rf4ce enable ) **********\n");
+		halbtc8822b1ant_action_rf4ce(btcoexist);
+	} else {
+		RT_TRACE(rtlpriv, COMP_BT_COEXIST, DBG_LOUD,
+			 "[BTCoex], ********** (wlan only -- under 2g ) **********\n");
+
+		halbtc8822b1ant_coex_table_type(btcoexist, FORCE_EXEC, 0);
+		halbtc8822b1ant_ps_tdma(btcoexist, FORCE_EXEC, false, 8);
+
+		halbtc8822b1ant_set_ant_path(btcoexist, BTC_ANT_PATH_AUTO,
+					     FORCE_EXEC,
+					     BT_8822B_1ANT_PHASE_2G);
+	}
+}
+
+static
+void halbtc8822b1ant_action_wifi_native_lps(struct btc_coexist *btcoexist)
+{
+	halbtc8822b1ant_adjust_wl_tx_power(btcoexist, NORMAL_EXEC, 0xd8);
+	halbtc8822b1ant_adjust_bt_tx_power(btcoexist, NORMAL_EXEC, 0);
+	halbtc8822b1ant_adjust_wl_rx_gain(btcoexist, NORMAL_EXEC, false);
+	halbtc8822b1ant_adjust_bt_rx_gain(btcoexist, NORMAL_EXEC, false);
+
+	halbtc8822b1ant_coex_table_type(btcoexist, NORMAL_EXEC, 5);
+	halbtc8822b1ant_ps_tdma(btcoexist, NORMAL_EXEC, false, 8);
+}
+
+static
+void halbtc8822b1ant_action_wifi_multi_port(struct btc_coexist *btcoexist,
+					    u8 multi_port_type)
+{
+	struct rtl_priv *rtlpriv = btcoexist->adapter;
+	struct btc_bt_link_info *bt_link_info = &btcoexist->bt_link_info;
+	bool miracast_plus_bt = false;
+	u8 phase;
+
+	RT_TRACE(rtlpriv, COMP_BT_COEXIST, DBG_LOUD,
+		 "[BTCoex],action_wifi_multi_port\n");
+
+	if (bt_link_info->bt_link_exist)
+		miracast_plus_bt = true;
+	else
+		miracast_plus_bt = false;
+
+	btcoexist->btc_set(btcoexist, BTC_SET_BL_MIRACAST_PLUS_BT,
+			   &miracast_plus_bt);
+
+	halbtc8822b1ant_adjust_wl_tx_power(btcoexist, NORMAL_EXEC, 0xd8);
+	halbtc8822b1ant_adjust_bt_tx_power(btcoexist, NORMAL_EXEC, 0);
+	halbtc8822b1ant_adjust_wl_rx_gain(btcoexist, NORMAL_EXEC, false);
+	halbtc8822b1ant_adjust_bt_rx_gain(btcoexist, NORMAL_EXEC, false);
+
+	if (multi_port_type == BTC_MULTIPORT_MCC_2BAND)
+		phase = BT_8822B_1ANT_PHASE_MCC;
+	else
+		phase = BT_8822B_1ANT_PHASE_2G;
+	halbtc8822b1ant_set_ant_path(btcoexist, BTC_ANT_PATH_AUTO, NORMAL_EXEC,
+				     phase);
+
+	/*  for A2DP + miracast + DL   */
+	if (multi_port_type == BTC_MULTIPORT_MCC_2BAND) {
+		halbtc8822b1ant_coex_table_type(btcoexist, NORMAL_EXEC, 25);
+		halbtc8822b1ant_ps_tdma(btcoexist, NORMAL_EXEC, false, 8);
+	} else if (multi_port_type == BTC_MULTIPORT_SCC) {
+		if (bt_link_info->a2dp_exist) {
+			halbtc8822b1ant_coex_table_type(btcoexist, NORMAL_EXEC,
+							1);
+			halbtc8822b1ant_ps_tdma(btcoexist, NORMAL_EXEC, true,
+						17);
+		} else if (bt_link_info->pan_exist) {
+			halbtc8822b1ant_coex_table_type(btcoexist, NORMAL_EXEC,
+							1);
+			halbtc8822b1ant_ps_tdma(btcoexist, NORMAL_EXEC, true,
+						33);
+		} else {
+			halbtc8822b1ant_coex_table_type(btcoexist, NORMAL_EXEC,
+							8);
+			halbtc8822b1ant_ps_tdma(btcoexist, NORMAL_EXEC, false,
+						8);
+		}
+	} else { /*BTC_MULTIPORT_MCC_DUAL_CHANNEL*/
+		if (!bt_link_info->pan_exist)
+			halbtc8822b1ant_coex_table_type(btcoexist, NORMAL_EXEC,
+							8);
+		else
+			halbtc8822b1ant_coex_table_type(btcoexist, NORMAL_EXEC,
+							5);
+
+		halbtc8822b1ant_ps_tdma(btcoexist, NORMAL_EXEC, false, 8);
+	}
+}
+
+static void halbtc8822b1ant_action_wifi_linkscan(struct btc_coexist *btcoexist)
+{
+	struct btc_bt_link_info *bt_link_info = &btcoexist->bt_link_info;
+
+	halbtc8822b1ant_adjust_wl_tx_power(btcoexist, NORMAL_EXEC, 0xd8);
+	halbtc8822b1ant_adjust_bt_tx_power(btcoexist, NORMAL_EXEC, 0);
+	halbtc8822b1ant_adjust_wl_rx_gain(btcoexist, NORMAL_EXEC, false);
+	halbtc8822b1ant_adjust_bt_rx_gain(btcoexist, NORMAL_EXEC, false);
+
+	if (bt_link_info->pan_exist) {
+		halbtc8822b1ant_coex_table_type(btcoexist, NORMAL_EXEC, 1);
+		halbtc8822b1ant_ps_tdma(btcoexist, NORMAL_EXEC, true, 22);
+	} else if (bt_link_info->a2dp_exist) {
+		halbtc8822b1ant_coex_table_type(btcoexist, NORMAL_EXEC, 1);
+		halbtc8822b1ant_ps_tdma(btcoexist, NORMAL_EXEC, true, 27);
+	} else {
+		halbtc8822b1ant_coex_table_type(btcoexist, NORMAL_EXEC, 1);
+		halbtc8822b1ant_ps_tdma(btcoexist, NORMAL_EXEC, true, 21);
+	}
+}
+
+static void
+halbtc8822b1ant_action_wifi_bt_acl_busy(struct btc_coexist *btcoexist)
+{
+	struct rtl_priv *rtlpriv = btcoexist->adapter;
+	struct btc_bt_link_info *bt_link_info = &btcoexist->bt_link_info;
+	bool wifi_busy = false, wifi_turbo = false;
+	u32 wifi_bw = 1;
+	static u8 prewifi_rssi_state = BTC_RSSI_STATE_LOW;
+	u8 wifi_rssi_state;
+	static u8 prewifi_rssi_state2 = BTC_RSSI_STATE_LOW;
+	u8 wifi_rssi_state2;
+	u8 iot_peer = BTC_IOT_PEER_UNKNOWN;
+	u8 coex_type;
+	u8 tdma_type;
+
+	btcoexist->btc_get(btcoexist, BTC_GET_U4_WIFI_BW, &wifi_bw);
+	btcoexist->btc_get(btcoexist, BTC_GET_BL_WIFI_BUSY, &wifi_busy);
+	btcoexist->btc_get(btcoexist, BTC_GET_U1_AP_NUM,
+			   &coex_sta->scan_ap_num);
+	btcoexist->btc_get(btcoexist, BTC_GET_U1_IOT_PEER, &iot_peer);
+
+	if (!wifi_busy)
+		wifi_busy = coex_sta->gl_wifi_busy;
+
+	RT_TRACE(rtlpriv, COMP_BT_COEXIST, DBG_LOUD,
+		 "############# [BTCoex],  scan_ap_num = %d, wl_noisy_level = %d\n",
+		 coex_sta->scan_ap_num, coex_sta->wl_noisy_level);
+
+	if (wifi_busy && coex_sta->wl_noisy_level == 0)
+		wifi_turbo = true;
+
+	wifi_rssi_state =
+		halbtc8822b1ant_wifi_rssi_state(btcoexist, &prewifi_rssi_state,
+						2, 40, 0);
+
+	wifi_rssi_state2 =
+		halbtc8822b1ant_wifi_rssi_state(btcoexist, &prewifi_rssi_state2,
+						2, 42, 0);
+	if (btcoexist->board_info.customer_id == RT_CID_LENOVO_CHINA &&
+	    coex_sta->scan_ap_num <= 10 &&
+	    iot_peer == BTC_IOT_PEER_ATHEROS) {
+		if ((bt_link_info->a2dp_only &&
+		     coex_sta->is_bt_multi_link &&
+		     coex_sta->hid_pair_cnt == 0) ||
+		    (bt_link_info->a2dp_exist && bt_link_info->pan_exist)) {
+			/* OPP may disappear during CPT_for_WiFi test */
+			/* for CPT_for_WiFi   */
+			u8 lvl;
+
+			if (BTC_RSSI_LOW(wifi_rssi_state2)) {
+				lvl = 20;
+
+				if (wifi_busy) {
+					coex_type = 22;
+					tdma_type = 105;
+				} else {
+					coex_type = 23;
+					tdma_type = 13;
+				}
+			} else { /* for CPT_for_BT   */
+				lvl = 0;
+				coex_type = 24;
+				tdma_type = 13;
+			}
+
+			halbtc8822b1ant_adjust_bt_tx_power(btcoexist,
+							   NORMAL_EXEC, lvl);
+			halbtc8822b1ant_coex_table_type(btcoexist, NORMAL_EXEC,
+							coex_type);
+			halbtc8822b1ant_ps_tdma(btcoexist, NORMAL_EXEC, true,
+						tdma_type);
+			return;
+		}
+	}
+
+	halbtc8822b1ant_adjust_bt_tx_power(btcoexist, NORMAL_EXEC, 0);
+
+	if (bt_link_info->a2dp_exist && coex_sta->is_bt_a2dp_sink) {
+		coex_type = 6;
+		tdma_type = 12;
+	} else if (bt_link_info->a2dp_only) { /* A2DP		 */
+
+		if (wifi_turbo)
+			coex_type = 19;
+		else
+			coex_type = 4;
+
+		if (coex_sta->connect_ap_period_cnt > 0)
+			tdma_type = 26;
+		else
+			tdma_type = 7;
+	} else if ((bt_link_info->a2dp_exist && bt_link_info->pan_exist) ||
+		   (bt_link_info->hid_exist && bt_link_info->a2dp_exist &&
+		    bt_link_info->pan_exist)) { /* A2DP+PAN(OPP,FTP),
+						 * HID+A2DP+PAN(OPP,FTP)
+						 */
+		if (bt_link_info->hid_exist)
+			coex_type = 1;
+		else if (wifi_turbo)
+			coex_type = 19;
+		else
+			coex_type = 4;
+
+		if (wifi_busy)
+			tdma_type = 13;
+		else
+			tdma_type = 14;
+	} else if (bt_link_info->hid_exist &&
+		   bt_link_info->a2dp_exist) { /* HID+A2DP */
+
+		if (wifi_bw == 0) { /* if 11bg mode */
+			if (coex_sta->hid_busy_num < 2)
+				/* for 2/18-4/18 HID lag @ Asus */
+				coex_type = 1;
+			else
+				coex_type = 21;
+
+			tdma_type = 7;
+		} else {
+			coex_type = 1;
+			tdma_type = 7;
+		}
+		/* PAN(OPP,FTP), HID+PAN(OPP,FTP) */
+	} else if ((bt_link_info->pan_only) ||
+		   (bt_link_info->hid_exist && bt_link_info->pan_exist)) {
+		if (bt_link_info->pan_only &&
+		    btcoexist->board_info.customer_id == RT_CID_LENOVO_CHINA &&
+		    wifi_busy && BTC_RSSI_HIGH(wifi_rssi_state2)) {
+			coex_type = 4;
+			tdma_type = 10;
+		} else {
+			if (coex_sta->cck_lock_ever) {
+				if (bt_link_info->hid_exist &&
+				    coex_sta->hid_busy_num < 2)
+					coex_type = 14;
+				else
+					coex_type = 13;
+			} else if (bt_link_info->hid_exist) {
+				if (coex_sta->hid_busy_num < 2)
+					coex_type = 1;
+				else
+					coex_type = 3;
+			} else if (wifi_turbo) {
+				coex_type = 19;
+			} else {
+				coex_type = 4;
+			}
+
+			if (!wifi_busy)
+				tdma_type = 4;
+			else
+				tdma_type = 3;
+		}
+	} else {
+		/* BT no-profile busy (0x9) */
+		coex_type = 4;
+		tdma_type = 33;
+	}
+
+	halbtc8822b1ant_coex_table_type(btcoexist, NORMAL_EXEC, coex_type);
+	halbtc8822b1ant_ps_tdma(btcoexist, NORMAL_EXEC, true, tdma_type);
+}
+
+/* wifi connected input point:
+ * to set different ps and tdma case (+bt different case)
+ */
+
+/*wifi not connected + bt action*/
+
+static
+void halbtc8822b1ant_action_wifi_not_connected(struct btc_coexist *btcoexist)
+{
+	struct rtl_priv *rtlpriv = btcoexist->adapter;
+
+	RT_TRACE(rtlpriv, COMP_BT_COEXIST, DBG_LOUD,
+		 "[BTCoex], ********** (wifi not connect) **********\n");
+
+	halbtc8822b1ant_adjust_wl_tx_power(btcoexist, NORMAL_EXEC, 0xd8);
+	halbtc8822b1ant_adjust_bt_tx_power(btcoexist, NORMAL_EXEC, 0);
+	halbtc8822b1ant_adjust_wl_rx_gain(btcoexist, NORMAL_EXEC, false);
+	halbtc8822b1ant_adjust_bt_rx_gain(btcoexist, NORMAL_EXEC, false);
+
+	/* tdma and coex table */
+	halbtc8822b1ant_coex_table_type(btcoexist, NORMAL_EXEC, 0);
+	halbtc8822b1ant_ps_tdma(btcoexist, FORCE_EXEC, false, 8);
+
+	halbtc8822b1ant_set_ant_path(btcoexist, BTC_ANT_PATH_AUTO, NORMAL_EXEC,
+				     BT_8822B_1ANT_PHASE_2G);
+}
+
+static void halbtc8822b1ant_action_wifi_connected(struct btc_coexist *btcoexist)
+{
+	struct rtl_priv *rtlpriv = btcoexist->adapter;
+	struct btc_bt_link_info *bt_link_info = &btcoexist->bt_link_info;
+	bool wifi_busy = false, rf4ce_enabled = false;
+	bool wifi_under_5g = false;
+
+	RT_TRACE(rtlpriv, COMP_BT_COEXIST, DBG_LOUD,
+		 "[BTCoex], CoexForWifiConnect()===>\n");
+
+	btcoexist->btc_get(btcoexist, BTC_GET_BL_RF4CE_CONNECTED,
+			   &rf4ce_enabled);
+	btcoexist->btc_get(btcoexist, BTC_GET_BL_WIFI_UNDER_5G, &wifi_under_5g);
+	RT_TRACE(rtlpriv, COMP_BT_COEXIST, DBG_LOUD,
+		 "[BTCoex], CoexForWifiConnect(), return for wifi is under 2g<===\n");
+
+	halbtc8822b1ant_set_ant_path(btcoexist, BTC_ANT_PATH_AUTO, NORMAL_EXEC,
+				     BT_8822B_1ANT_PHASE_2G);
+
+	btcoexist->btc_get(btcoexist, BTC_GET_BL_WIFI_BUSY, &wifi_busy);
+
+	if (coex_dm->bt_status == BT_8822B_1ANT_BT_STATUS_ACL_BUSY ||
+	    coex_dm->bt_status == BT_8822B_1ANT_BT_STATUS_ACL_SCO_BUSY) {
+		if (bt_link_info->hid_only) /* HID only */
+			halbtc8822b1ant_action_bt_sco_hid_busy(btcoexist);
+		else
+			halbtc8822b1ant_action_wifi_bt_acl_busy(btcoexist);
+
+	} else if (coex_dm->bt_status == BT_8822B_1ANT_BT_STATUS_SCO_BUSY) {
+		halbtc8822b1ant_action_bt_sco_hid_busy(btcoexist);
+	} else if (rf4ce_enabled) {
+		halbtc8822b1ant_action_rf4ce(btcoexist);
+	} else {
+		halbtc8822b1ant_action_bt_idle(btcoexist);
+	}
+}
+
+static
+void halbtc8822b1ant_run_sw_coexist_mechanism(struct btc_coexist *btcoexist)
+{
+	struct rtl_priv *rtlpriv = btcoexist->adapter;
+	u8 algorithm = 0;
+
+	RT_TRACE(rtlpriv, COMP_BT_COEXIST, DBG_LOUD,
+		 "[BTCoex], ********** (run sw coex mech) **********\n");
+	algorithm = halbtc8822b1ant_action_algorithm(btcoexist);
+	coex_dm->cur_algorithm = algorithm;
+
+	if (halbtc8822b1ant_is_common_action(btcoexist)) {
+	} else {
+		switch (coex_dm->cur_algorithm) {
+		case BT_8822B_1ANT_COEX_SCO:
+			RT_TRACE(rtlpriv, COMP_BT_COEXIST, DBG_LOUD,
+				 "[BTCoex], Action algorithm = SCO.\n");
+			break;
+		case BT_8822B_1ANT_COEX_HID:
+			RT_TRACE(rtlpriv, COMP_BT_COEXIST, DBG_LOUD,
+				 "[BTCoex], Action algorithm = HID.\n");
+			break;
+		case BT_8822B_1ANT_COEX_A2DP:
+			RT_TRACE(rtlpriv, COMP_BT_COEXIST, DBG_LOUD,
+				 "[BTCoex], Action algorithm = A2DP.\n");
+			break;
+		case BT_8822B_1ANT_COEX_A2DP_PANHS:
+			RT_TRACE(rtlpriv, COMP_BT_COEXIST, DBG_LOUD,
+				 "[BTCoex], Action algorithm = A2DP+PAN(HS).\n");
+			break;
+		case BT_8822B_1ANT_COEX_PAN:
+			RT_TRACE(rtlpriv, COMP_BT_COEXIST, DBG_LOUD,
+				 "[BTCoex], Action algorithm = PAN(EDR).\n");
+			break;
+		case BT_8822B_1ANT_COEX_PANHS:
+			RT_TRACE(rtlpriv, COMP_BT_COEXIST, DBG_LOUD,
+				 "[BTCoex], Action algorithm = HS mode.\n");
+			break;
+		case BT_8822B_1ANT_COEX_PAN_A2DP:
+			RT_TRACE(rtlpriv, COMP_BT_COEXIST, DBG_LOUD,
+				 "[BTCoex], Action algorithm = PAN+A2DP.\n");
+			break;
+		case BT_8822B_1ANT_COEX_PAN_HID:
+			RT_TRACE(rtlpriv, COMP_BT_COEXIST, DBG_LOUD,
+				 "[BTCoex], Action algorithm = PAN(EDR)+HID.\n");
+			break;
+		case BT_8822B_1ANT_COEX_HID_A2DP_PAN:
+			RT_TRACE(rtlpriv, COMP_BT_COEXIST, DBG_LOUD,
+				 "[BTCoex], Action algorithm = HID+A2DP+PAN.\n");
+			break;
+		case BT_8822B_1ANT_COEX_HID_A2DP:
+			RT_TRACE(rtlpriv, COMP_BT_COEXIST, DBG_LOUD,
+				 "[BTCoex], Action algorithm = HID+A2DP.\n");
+			break;
+		default:
+			RT_TRACE(rtlpriv, COMP_BT_COEXIST, DBG_LOUD,
+				 "[BTCoex], Action algorithm = coexist All Off!!\n");
+			break;
+		}
+		coex_dm->pre_algorithm = coex_dm->cur_algorithm;
+	}
+}
+
+static void halbtc8822b1ant_run_coexist_mechanism(struct btc_coexist *btcoexist)
+{
+	struct rtl_priv *rtlpriv = btcoexist->adapter;
+	struct btc_bt_link_info *bt_link_info = &btcoexist->bt_link_info;
+	bool wifi_connected = false;
+	u8 mcc_dualband = BTC_MULTIPORT_SCC;
+	u32 wifi_link_status = 0;
+	u32 num_of_wifi_link = 0, wifi_bw;
+	u8 iot_peer = BTC_IOT_PEER_UNKNOWN;
+	bool wifi_under_5g = false;
+	bool scan = false, link = false, roam = false, under_4way = false;
+	u8 wifi_central_chnl = 0;
+
+	btcoexist->btc_get(btcoexist, BTC_GET_BL_WIFI_SCAN, &scan);
+	btcoexist->btc_get(btcoexist, BTC_GET_BL_WIFI_LINK, &link);
+	btcoexist->btc_get(btcoexist, BTC_GET_BL_WIFI_ROAM, &roam);
+	btcoexist->btc_get(btcoexist, BTC_GET_BL_WIFI_4_WAY_PROGRESS,
+			   &under_4way);
+
+	btcoexist->btc_get(btcoexist, BTC_GET_U4_WIFI_BW, &wifi_bw);
+	btcoexist->btc_get(btcoexist, BTC_GET_BL_WIFI_CONNECTED,
+			   &wifi_connected);
+
+	btcoexist->btc_get(btcoexist, BTC_GET_U1_WIFI_CENTRAL_CHNL,
+			   &wifi_central_chnl);
+	coex_sta->wl_center_channel = wifi_central_chnl;
+
+	RT_TRACE(rtlpriv, COMP_BT_COEXIST, DBG_LOUD,
+		 "[BTCoex], RunCoexistMechanism()===>\n");
+
+	if (btcoexist->manual_control) {
+		RT_TRACE(rtlpriv, COMP_BT_COEXIST, DBG_LOUD,
+			 "[BTCoex], RunCoexistMechanism(), return for Manual CTRL <===\n");
+		return;
+	}
+
+	if (btcoexist->stop_coex_dm) {
+		RT_TRACE(rtlpriv, COMP_BT_COEXIST, DBG_LOUD,
+			 "[BTCoex], RunCoexistMechanism(), return for Stop Coex DM <===\n");
+		return;
+	}
+
+	if (coex_sta->under_ips) {
+		RT_TRACE(rtlpriv, COMP_BT_COEXIST, DBG_LOUD,
+			 "[BTCoex], RunCoexistMechanism(), wifi is under IPS !!!\n");
+		return;
+	}
+
+	if (!coex_sta->run_time_state) {
+		RT_TRACE(rtlpriv, COMP_BT_COEXIST, DBG_LOUD,
+			 "[BTCoex], RunCoexistMechanism(), return for run_time_state = false !!!\n");
+		return;
+	}
+
+	if (coex_sta->freeze_coexrun_by_btinfo) {
+		RT_TRACE(rtlpriv, COMP_BT_COEXIST, DBG_LOUD,
+			 "[BTCoex], RunCoexistMechanism(), return for freeze_coexrun_by_btinfo\n");
+		return;
+	}
+
+	if (coex_sta->msft_mr_exist && wifi_connected) {
+		RT_TRACE(rtlpriv, COMP_BT_COEXIST, DBG_LOUD,
+			 "[BTCoex], RunCoexistMechanism(), microsoft MR!!\n");
+
+		halbtc8822b1ant_action_bt_mr(btcoexist);
+		return;
+	}
+
+	/* No MIMO Power Save, 3:disable */
+	halbtc8822b1ant_mimo_ps(btcoexist, NORMAL_EXEC, 3);
+
+	btcoexist->btc_get(btcoexist, BTC_GET_BL_WIFI_DUAL_BAND_CONNECTED,
+			   &mcc_dualband);
+	if (mcc_dualband == BTC_MULTIPORT_MCC_2BAND) {
+		RT_TRACE(rtlpriv, COMP_BT_COEXIST, DBG_LOUD,
+			 "[BTCoex], RunCoexistMechanism(), mcc dual band!!\n");
+
+		halbtc8822b1ant_action_wifi_multi_port(btcoexist,
+						       BTC_MULTIPORT_MCC_2BAND);
+		return;
+	}
+
+	btcoexist->btc_get(btcoexist, BTC_GET_BL_WIFI_UNDER_5G, &wifi_under_5g);
+	if (wifi_under_5g &&
+	    coex_sta->switch_band_notify_to != BTC_SWITCH_TO_24G &&
+	    coex_sta->switch_band_notify_to != BTC_SWITCH_TO_24G_NOFORSCAN) {
+		halbtc8822b1ant_action_wifi_under5g(btcoexist);
+
+		RT_TRACE(rtlpriv, COMP_BT_COEXIST, DBG_LOUD,
+			 "[BTCoex], WiFi is under 5G!!!\n");
+		return;
+	}
+
+	RT_TRACE(rtlpriv, COMP_BT_COEXIST, DBG_LOUD,
+		 "[BTCoex], WiFi is under 2G!!!\n");
+
+	halbtc8822b1ant_set_ant_path(btcoexist, BTC_ANT_PATH_AUTO,
+				     NORMAL_EXEC,
+				     BT_8822B_1ANT_PHASE_2G);
+
+	if (coex_sta->under_lps && !coex_sta->force_lps_ctrl &&
+	    !coex_sta->acl_busy) {
+		RT_TRACE(rtlpriv, COMP_BT_COEXIST, DBG_LOUD,
+			 "[BTCoex], RunCoexistMechanism(), wifi is under LPS !!!\n");
+		halbtc8822b1ant_action_wifi_native_lps(btcoexist);
+		return;
+	}
+
+	if (coex_sta->bt_whck_test) {
+		RT_TRACE(rtlpriv, COMP_BT_COEXIST, DBG_LOUD,
+			 "[BTCoex], BT is under WHCK TEST!!!\n");
+		halbtc8822b1ant_action_bt_whql_test(btcoexist);
+		return;
+	}
+
+	if (coex_sta->bt_disabled) {
+		RT_TRACE(rtlpriv, COMP_BT_COEXIST, DBG_LOUD,
+			 "[BTCoex], BT is disabled !!!\n");
+		halbtc8822b1ant_action_wifi_only(btcoexist);
+		return;
+	}
+
+	if (coex_sta->c2h_bt_inquiry_page) {
+		RT_TRACE(rtlpriv, COMP_BT_COEXIST, DBG_LOUD,
+			 "[BTCoex], BT is under inquiry/page scan !!\n");
+		halbtc8822b1ant_action_bt_inquiry(btcoexist);
+		return;
+	}
+
+	if (coex_sta->is_setup_link && coex_sta->bt_relink_downcount != 0) {
+		RT_TRACE(rtlpriv, COMP_BT_COEXIST, DBG_LOUD,
+			 "[BTCoex], BT is re-link !!!\n");
+		halbtc8822b1ant_action_bt_relink(btcoexist);
+		return;
+	}
+
+	btcoexist->btc_get(btcoexist, BTC_GET_U4_WIFI_LINK_STATUS,
+			   &wifi_link_status);
+
+	num_of_wifi_link = wifi_link_status >> 16;
+
+	if (num_of_wifi_link >= 2 || wifi_link_status & WIFI_P2P_GO_CONNECTED) {
+		RT_TRACE(rtlpriv, COMP_BT_COEXIST, DBG_LOUD,
+			 "############# [BTCoex],  Multi-Port num_of_wifi_link = %d, wifi_link_status = 0x%x\n",
+			 num_of_wifi_link, wifi_link_status);
+
+		if (scan || link || roam || under_4way) {
+			RT_TRACE(rtlpriv, COMP_BT_COEXIST, DBG_LOUD,
+				 "[BTCoex], scan = %d, link = %d, roam = %d 4way = %d!!!\n",
+				 scan, link, roam, under_4way);
+
+			RT_TRACE(rtlpriv, COMP_BT_COEXIST, DBG_LOUD,
+				 "[BTCoex], wifi is under linkscan process + Multi-Port !!\n");
+
+			halbtc8822b1ant_action_wifi_linkscan(btcoexist);
+		} else {
+			halbtc8822b1ant_action_wifi_multi_port(btcoexist,
+							       mcc_dualband);
+		}
+
+		return;
+	}
+
+	if (bt_link_info->bt_link_exist && wifi_connected) {
+		btcoexist->btc_get(btcoexist, BTC_GET_U1_IOT_PEER, &iot_peer);
+
+		if (iot_peer == BTC_IOT_PEER_CISCO) {
+			if (wifi_bw == BTC_WIFI_BW_HT40)
+				halbtc8822b1ant_limited_rx(btcoexist,
+							   NORMAL_EXEC, false,
+							   true, 0x10);
+			else
+				halbtc8822b1ant_limited_rx(btcoexist,
+							   NORMAL_EXEC, false,
+							   true, 0x8);
+		}
+	}
+
+	/* just print debug message */
+	halbtc8822b1ant_run_sw_coexist_mechanism(btcoexist);
+
+	if (coex_dm->bt_status == BT_8822B_1ANT_BT_STATUS_NCONNECTED_IDLE ||
+	    coex_dm->bt_status == BT_8822B_1ANT_BT_STATUS_CONNECTED_IDLE) {
+		RT_TRACE(rtlpriv, COMP_BT_COEXIST, DBG_LOUD,
+			 "############# [BTCoex],  BT Is idle\n");
+		halbtc8822b1ant_action_bt_idle(btcoexist);
+		return;
+	}
+
+	if (scan || link || roam || under_4way) {
+		RT_TRACE(rtlpriv, COMP_BT_COEXIST, DBG_LOUD,
+			 "[BTCoex], scan = %d, link = %d, roam = %d 4way = %d!!!\n",
+			 scan, link, roam, under_4way);
+
+		RT_TRACE(rtlpriv, COMP_BT_COEXIST, DBG_LOUD,
+			 "[BTCoex], wifi is under linkscan process!!\n");
+
+		halbtc8822b1ant_action_wifi_linkscan(btcoexist);
+	} else if (wifi_connected) {
+		RT_TRACE(rtlpriv, COMP_BT_COEXIST, DBG_LOUD,
+			 "[BTCoex], wifi is under connected!!\n");
+
+		halbtc8822b1ant_action_wifi_connected(btcoexist);
+	} else {
+		RT_TRACE(rtlpriv, COMP_BT_COEXIST, DBG_LOUD,
+			 "[BTCoex], wifi is under not-connected!!\n");
+
+		halbtc8822b1ant_action_wifi_not_connected(btcoexist);
+	}
+}
+
+static void halbtc8822b1ant_init_coex_dm(struct btc_coexist *btcoexist)
+{
+	/* force to reset coex mechanism */
+
+	halbtc8822b1ant_low_penalty_ra(btcoexist, NORMAL_EXEC, false);
+
+	/* sw all off */
+	coex_sta->pop_event_cnt = 0;
+	coex_sta->cnt_remote_name_req = 0;
+	coex_sta->cnt_reinit = 0;
+	coex_sta->cnt_setup_link = 0;
+	coex_sta->cnt_ign_wlan_act = 0;
+	coex_sta->cnt_page = 0;
+	coex_sta->cnt_role_switch = 0;
+	coex_sta->switch_band_notify_to = BTC_NOT_SWITCH;
+
+	coex_sta->pop_event_cnt = 0;
+
+	halbtc8822b1ant_query_bt_info(btcoexist);
+}
+
+static void halbtc8822b1ant_init_hw_config(struct btc_coexist *btcoexist,
+					   bool back_up, bool wifi_only)
+{
+	struct rtl_priv *rtlpriv = btcoexist->adapter;
+	u8 u8tmp = 0, i = 0;
+	u32 u32tmp1 = 0, u32tmp2 = 0, u32tmp3 = 0;
+
+	RT_TRACE(rtlpriv, COMP_BT_COEXIST, DBG_LOUD,
+		 "[BTCoex], 1Ant Init HW Config!!\n");
+
+	u32tmp3 = btcoexist->btc_read_4byte(btcoexist, 0xcbc);
+	u32tmp1 = halbtc8822b1ant_ltecoex_read_reg(btcoexist, 0x38);
+	u32tmp2 = halbtc8822b1ant_ltecoex_read_reg(btcoexist, 0x54);
+
+	RT_TRACE(rtlpriv, COMP_BT_COEXIST, DBG_LOUD,
+		 "[BTCoex], ********** (Before Init HW config) 0xcbc = 0x%x, 0x38= 0x%x, 0x54= 0x%x**********\n",
+		 u32tmp3, u32tmp1, u32tmp2);
+
+	coex_sta->bt_coex_supported_feature = 0;
+	coex_sta->bt_coex_supported_version = 0;
+	coex_sta->bt_ble_scan_type = 0;
+	coex_sta->bt_ble_scan_para[0] = 0;
+	coex_sta->bt_ble_scan_para[1] = 0;
+	coex_sta->bt_ble_scan_para[2] = 0;
+	coex_sta->bt_reg_vendor_ac = 0xffff;
+	coex_sta->bt_reg_vendor_ae = 0xffff;
+	coex_sta->isolation_btween_wb = BT_8822B_1ANT_DEFAULT_ISOLATION;
+	coex_sta->gnt_error_cnt = 0;
+	coex_sta->bt_relink_downcount = 0;
+	coex_sta->is_set_ps_state_fail = false;
+	coex_sta->cnt_set_ps_state_fail = 0;
+
+	for (i = 0; i <= 9; i++)
+		coex_sta->bt_afh_map[i] = 0;
+
+	/* Setup RF front end type */
+	halbtc8822b1ant_set_rfe_type(btcoexist);
+
+	if (rfe_type->rfe_module_type == 2 ||
+	    rfe_type->rfe_module_type == 4)
+		halbtc8822b1ant_post_state_to_bt(btcoexist,
+						 BT_8822B_1ANT_SCBD_EXTFEM,
+						 true);
+	else
+		halbtc8822b1ant_post_state_to_bt(btcoexist,
+						 BT_8822B_1ANT_SCBD_EXTFEM,
+						 false);
+
+	/* 0xf0[15:12] --> Chip Cut information */
+	coex_sta->cut_version =
+		(btcoexist->btc_read_1byte(btcoexist, 0xf1) & 0xf0) >> 4;
+
+	/* enable TBTT nterrupt */
+	btcoexist->btc_write_1byte_bitmask(btcoexist, 0x550, 0x8, 0x1);
+
+	/* BT report packet sample rate	 */
+	/* 0x790[5:0]=0x5 */
+	u8tmp = btcoexist->btc_read_1byte(btcoexist, 0x790);
+	u8tmp &= 0xc0;
+	u8tmp |= 0x5;
+	btcoexist->btc_write_1byte(btcoexist, 0x790, u8tmp);
+
+	/* Enable BT counter statistics */
+	btcoexist->btc_write_1byte(btcoexist, 0x778, 0x1);
+
+	/* Enable PTA (3-wire function form BT side) */
+	btcoexist->btc_write_1byte_bitmask(btcoexist, 0x40, 0x20, 0x1);
+	btcoexist->btc_write_1byte_bitmask(btcoexist, 0x41, 0x02, 0x1);
+
+	/* Enable PTA (tx/rx signal form WiFi side) */
+	btcoexist->btc_write_1byte_bitmask(btcoexist, 0x4c6, 0x10, 0x1);
+	/*GNT_BT=1 while select both */
+	btcoexist->btc_write_1byte_bitmask(btcoexist, 0x763, 0x10, 0x1);
+
+	halbtc8822b1ant_enable_gnt_to_gpio(btcoexist, true);
+
+	/* PTA parameter */
+	halbtc8822b1ant_coex_table_type(btcoexist, FORCE_EXEC, 0);
+	halbtc8822b1ant_ps_tdma(btcoexist, FORCE_EXEC, false, 8);
+
+	/* Antenna config */
+	if (coex_sta->is_rf_state_off) {
+		halbtc8822b1ant_set_ant_path(btcoexist, BTC_ANT_PATH_AUTO,
+					     FORCE_EXEC,
+					     BT_8822B_1ANT_PHASE_WOFF);
+
+		btcoexist->stop_coex_dm = true;
+
+		RT_TRACE(rtlpriv, COMP_BT_COEXIST, DBG_LOUD,
+			 "[BTCoex], **********  %s (RF Off)**********\n",
+			 __func__);
+	} else if (wifi_only) {
+		coex_sta->concurrent_rx_mode_on = false;
+		halbtc8822b1ant_set_ant_path(btcoexist, BTC_ANT_PATH_WIFI,
+					     FORCE_EXEC,
+					     BT_8822B_1ANT_PHASE_WONLY);
+		btcoexist->stop_coex_dm = true;
+	} else {
+		coex_sta->concurrent_rx_mode_on = true;
+
+		halbtc8822b1ant_set_ant_path(btcoexist, BTC_ANT_PATH_AUTO,
+					     FORCE_EXEC,
+					     BT_8822B_1ANT_PHASE_INIT);
+		btcoexist->stop_coex_dm = false;
+	}
+
+	u32tmp3 = btcoexist->btc_read_4byte(btcoexist, 0xcbc);
+	u32tmp1 = halbtc8822b1ant_ltecoex_read_reg(btcoexist, 0x38);
+	u32tmp2 = halbtc8822b1ant_ltecoex_read_reg(btcoexist, 0x54);
+
+	RT_TRACE(rtlpriv, COMP_BT_COEXIST, DBG_LOUD,
+		 "[BTCoex], ********** (After Init HW config) 0xcbc = 0x%x, 0x38= 0x%x, 0x54= 0x%x**********\n",
+		 u32tmp3, u32tmp1, u32tmp2);
+}
+
+void ex_btc8822b1ant_power_on_setting(struct btc_coexist *btcoexist)
+{
+	struct rtl_priv *rtlpriv = btcoexist->adapter;
+	struct btc_board_info *board_info = &btcoexist->board_info;
+	u8 u8tmp = 0x0;
+	u16 u16tmp = 0x0;
+
+	RT_TRACE(rtlpriv, COMP_BT_COEXIST, DBG_LOUD,
+		 "xxxxxxxxxxxxxxxx Execute 8822b 1-Ant PowerOn Setting!! xxxxxxxxxxxxxxxx\n");
+
+	btcoexist->stop_coex_dm = true;
+	coex_sta->is_rf_state_off = false;
+
+	/* enable BB, REG_SYS_FUNC_EN such that we can write 0x948 correctly. */
+	u16tmp = btcoexist->btc_read_2byte(btcoexist, 0x2);
+	btcoexist->btc_write_2byte(btcoexist, 0x2, u16tmp | BIT(0) | BIT(1));
+
+	/* Setup RF front end type */
+	halbtc8822b1ant_set_rfe_type(btcoexist);
+
+	/* Set Antenna Path to BT side */
+	halbtc8822b1ant_set_ant_path(btcoexist, BTC_ANT_PATH_AUTO, FORCE_EXEC,
+				     BT_8822B_1ANT_PHASE_POWERON);
+
+	/* set WLAN_ACT = 0 */
+	/* btcoexist->btc_write_1byte(btcoexist, 0x76e, 0x4); */
+
+	/* SD1 Chunchu red x issue */
+	btcoexist->btc_write_1byte(btcoexist, 0xff1a, 0x0);
+
+	halbtc8822b1ant_enable_gnt_to_gpio(btcoexist, true);
+
+	/* S0 or S1 setting and Local register setting
+	 * (By the setting fw can get ant number, S0/S1, ... info)
+	 */
+	/* Local setting bit define */
+	/*	BIT0: "0" for no antenna inverse; "1" for antenna inverse  */
+	/*	BIT1: "0" for internal switch; "1" for external switch */
+	/*	BIT2: "0" for one antenna; "1" for two antenna */
+	/* NOTE: here default all internal switch and 1-antenna ==>
+	 *       BIT1=0 and BIT2=0
+	 */
+
+	u8tmp = 0;
+	board_info->btdm_ant_pos = BTC_ANTENNA_AT_MAIN_PORT;
+
+	if (btcoexist->chip_interface == BTC_INTF_PCI)
+		btcoexist->btc_write_local_reg_1byte(btcoexist, 0x3e0, u8tmp);
+	else if (btcoexist->chip_interface == BTC_INTF_USB)
+		btcoexist->btc_write_local_reg_1byte(btcoexist, 0xfe08, u8tmp);
+	else if (btcoexist->chip_interface == BTC_INTF_SDIO)
+		btcoexist->btc_write_local_reg_1byte(btcoexist, 0x60, u8tmp);
+
+	RT_TRACE(rtlpriv, COMP_BT_COEXIST, DBG_LOUD,
+		 "[BTCoex], **********  LTE coex Reg 0x38 (Power-On) = 0x%x\n",
+		 halbtc8822b1ant_ltecoex_read_reg(btcoexist, 0x38));
+
+	RT_TRACE(rtlpriv, COMP_BT_COEXIST, DBG_LOUD,
+		 "[BTCoex], **********  MAC Reg 0x70/ BB Reg 0xcbc (Power-On) = 0x%x / 0x%x\n",
+		 btcoexist->btc_read_4byte(btcoexist, 0x70),
+		 btcoexist->btc_read_4byte(btcoexist, 0xcbc));
+}
+
+void ex_btc8822b1ant_pre_load_firmware(struct btc_coexist *btcoexist) {}
+
+void ex_btc8822b1ant_init_hw_config(struct btc_coexist *btcoexist,
+				    bool wifi_only)
+{
+	struct rtl_priv *rtlpriv = btcoexist->adapter;
+
+	RT_TRACE(rtlpriv, COMP_BT_COEXIST, DBG_LOUD,
+		 "[BTCoex], ********** (ini hw config) **********\n");
+
+	halbtc8822b1ant_init_hw_config(btcoexist, true, wifi_only);
+	btcoexist->stop_coex_dm = false;
+}
+
+void ex_btc8822b1ant_init_coex_dm(struct btc_coexist *btcoexist)
+{
+	struct rtl_priv *rtlpriv = btcoexist->adapter;
+
+	RT_TRACE(rtlpriv, COMP_BT_COEXIST, DBG_LOUD,
+		 "[BTCoex], Coex Mechanism Init!!\n");
+
+	btcoexist->stop_coex_dm = false;
+	btcoexist->auto_report_1ant = true;
+	btcoexist->dbg_mode_1ant = false;
+
+	halbtc8822b1ant_init_coex_dm(btcoexist);
+
+	halbtc8822b1ant_query_bt_info(btcoexist);
+}
+
+void ex_btc8822b1ant_display_simple_coex_info(struct btc_coexist *btcoexist,
+					      struct seq_file *m)
+{
+	struct btc_board_info *board_info = &btcoexist->board_info;
+	struct btc_bt_link_info *bt_link_info = &btcoexist->bt_link_info;
+	u32 bt_patch_ver = 0, bt_coex_ver = 0;
+	static u8 cnt;
+
+	seq_puts(m, "\n _____[BT Coexist info]____");
+
+	if (btcoexist->manual_control) {
+		seq_puts(m, "\n __[Under Manual Control]_");
+		seq_puts(m, "\n _________________________");
+	}
+	if (btcoexist->stop_coex_dm) {
+		seq_puts(m, "\n ____[Coex is STOPPED]____");
+		seq_puts(m, "\n _________________________");
+	}
+
+	if (!coex_sta->bt_disabled) {
+		if (coex_sta->bt_coex_supported_feature == 0) {
+			u32 * const p = &coex_sta->bt_coex_supported_feature;
+
+			btcoexist->btc_get(btcoexist,
+					   BTC_GET_U4_SUPPORTED_FEATURE, p);
+		}
+
+		if (coex_sta->bt_coex_supported_version == 0 ||
+		    coex_sta->bt_coex_supported_version == 0xffff) {
+			u32 * const p = &coex_sta->bt_coex_supported_version;
+
+			btcoexist->btc_get(btcoexist,
+					   BTC_GET_U4_SUPPORTED_VERSION, p);
+		}
+
+		if (coex_sta->bt_reg_vendor_ac == 0xffff)
+			coex_sta->bt_reg_vendor_ac = (u16)
+				(btcoexist->btc_get_bt_reg(btcoexist, 3, 0xac) &
+				 0xffff);
+
+		if (coex_sta->bt_reg_vendor_ae == 0xffff)
+			coex_sta->bt_reg_vendor_ae = (u16)
+				(btcoexist->btc_get_bt_reg(btcoexist, 3, 0xae) &
+				 0xffff);
+
+		btcoexist->btc_get(btcoexist, BTC_GET_U4_BT_PATCH_VER,
+				   &bt_patch_ver);
+		btcoexist->bt_info.bt_get_fw_ver = bt_patch_ver;
+
+		if (coex_sta->num_of_profile > 0) {
+			cnt++;
+
+			if (cnt >= 3) {
+				u8 * const p = &coex_sta->bt_afh_map[0];
+
+				btcoexist->btc_get_bt_afh_map_from_bt(btcoexist,
+								      0, p);
+				cnt = 0;
+			}
+		}
+	}
+
+	/* BT coex. info. */
+	seq_printf(m,
+		   "\n %-35s = %d/ %d/ %s / %d",
+		   "Ant PG Num/ Mech/ Pos/ RFE", board_info->pg_ant_num,
+		   board_info->btdm_ant_num,
+		   (board_info->btdm_ant_pos ==
+		    BTC_ANTENNA_AT_MAIN_PORT ? "Main" : "Aux"),
+		   rfe_type->rfe_module_type);
+
+	bt_coex_ver = ((coex_sta->bt_coex_supported_version & 0xff00) >> 8);
+
+	seq_printf(m,
+		   "\n %-35s = %d_%02x/ 0x%02x/ 0x%02x (%s)",
+		   "CoexVer WL/  BT_Desired/ BT_Report",
+		   glcoex_ver_date_8822b_1ant, glcoex_ver_8822b_1ant,
+		   glcoex_ver_btdesired_8822b_1ant, bt_coex_ver,
+		   (bt_coex_ver == 0xff ?
+			 "Unknown" :
+			 (coex_sta->bt_disabled ?
+			  "BT-disable" :
+			  (bt_coex_ver >= glcoex_ver_btdesired_8822b_1ant ?
+				   "Match" :
+				   "Mis-Match"))));
+
+	/* BT Status */
+	seq_printf(m, "\n %-35s = %s", "BT status",
+		   ((coex_sta->bt_disabled) ?
+			 ("disabled") :
+			 ((coex_sta->c2h_bt_inquiry_page) ?
+			  ("inquiry/page") :
+			  ((BT_8822B_1ANT_BT_STATUS_NCONNECTED_IDLE ==
+			    coex_dm->bt_status) ?
+				   "non-connected idle" :
+				   ((coex_dm->bt_status ==
+				     BT_8822B_1ANT_BT_STATUS_CONNECTED_IDLE) ?
+					    "connected-idle" :
+					    "busy")))));
+
+	/* HW Settings */
+	seq_printf(m, "\n %-35s = %d/ %d",
+		   "0x770(Hi-pri rx/tx)", coex_sta->high_priority_rx,
+		   coex_sta->high_priority_tx);
+
+	seq_printf(m, "\n %-35s = %d/ %d %s",
+		   "0x774(Lo-pri rx/tx)", coex_sta->low_priority_rx,
+		   coex_sta->low_priority_tx,
+		   (bt_link_info->slave_role ?
+			    "(Slave!!)" :
+			    (coex_sta->is_tdma_btautoslot_hang ?
+				     "(auto-slot hang!!)" :
+				     "")));
+}
+
+void ex_btc8822b1ant_display_coex_info(struct btc_coexist *btcoexist,
+				       struct seq_file *m)
+{
+	struct btc_board_info *board_info = &btcoexist->board_info;
+	struct btc_bt_link_info *bt_link_info = &btcoexist->bt_link_info;
+	u8 u8tmp[4], i, ps_tdma_case = 0;
+	u16 u16tmp[4];
+	u32 u32tmp[4];
+	u32 fa_ofdm, fa_cck, cca_ofdm, cca_cck;
+	u32 fw_ver = 0, bt_patch_ver = 0, bt_coex_ver = 0;
+	static u8 pop_report_in_10s;
+	u32 phyver = 0;
+	bool lte_coex_on = false;
+	static u8 cnt;
+
+	seq_puts(m, "\n ============[BT Coexist info]============");
+
+	if (btcoexist->manual_control) {
+		seq_puts(m,
+			 "\n ============[Under Manual Control]============");
+		seq_puts(m, "\n ==========================================");
+	}
+	if (btcoexist->stop_coex_dm) {
+		seq_puts(m, "\n ============[Coex is STOPPED]============");
+		seq_puts(m, "\n ==========================================");
+	}
+
+	if (!coex_sta->bt_disabled) {
+		if (coex_sta->bt_coex_supported_feature == 0) {
+			u32 * const p = &coex_sta->bt_coex_supported_feature;
+
+			btcoexist->btc_get(btcoexist,
+					   BTC_GET_U4_SUPPORTED_FEATURE, p);
+		}
+
+		if (coex_sta->bt_coex_supported_version == 0 ||
+		    coex_sta->bt_coex_supported_version == 0xffff) {
+			u32 * const p = &coex_sta->bt_coex_supported_version;
+
+			btcoexist->btc_get(btcoexist,
+					   BTC_GET_U4_SUPPORTED_VERSION, p);
+		}
+
+		if (coex_sta->bt_reg_vendor_ac == 0xffff)
+			coex_sta->bt_reg_vendor_ac = (u16)
+				(btcoexist->btc_get_bt_reg(btcoexist, 3, 0xac) &
+				 0xffff);
+
+		if (coex_sta->bt_reg_vendor_ae == 0xffff)
+			coex_sta->bt_reg_vendor_ae = (u16)
+				(btcoexist->btc_get_bt_reg(btcoexist, 3, 0xae) &
+				 0xffff);
+
+		btcoexist->btc_get(btcoexist, BTC_GET_U4_BT_PATCH_VER,
+				   &bt_patch_ver);
+		btcoexist->bt_info.bt_get_fw_ver = bt_patch_ver;
+
+		if (coex_sta->num_of_profile > 0) {
+			cnt++;
+
+			if (cnt >= 3) {
+				u8 * const p = &coex_sta->bt_afh_map[0];
+
+				btcoexist->btc_get_bt_afh_map_from_bt(btcoexist,
+								      0, p);
+				cnt = 0;
+			}
+		}
+	}
+
+	seq_printf(m, "\n %-35s = %d/ %d/ %s / %d",
+		   "Ant PG Num/ Mech/ Pos/ RFE", board_info->pg_ant_num,
+		   board_info->btdm_ant_num,
+		   (board_info->btdm_ant_pos == BTC_ANTENNA_AT_MAIN_PORT ?
+			    "Main" :
+			    "Aux"),
+		   rfe_type->rfe_module_type);
+
+	bt_patch_ver = btcoexist->bt_info.bt_get_fw_ver;
+	btcoexist->btc_get(btcoexist, BTC_GET_U4_WIFI_FW_VER, &fw_ver);
+	phyver = btcoexist->btc_get_bt_phydm_version(btcoexist);
+
+	bt_coex_ver = ((coex_sta->bt_coex_supported_version & 0xff00) >> 8);
+
+	seq_printf(m,
+		   "\n %-35s = %d_%02x/ 0x%02x/ 0x%02x (%s)",
+		   "CoexVer WL/  BT_Desired/ BT_Report",
+		   glcoex_ver_date_8822b_1ant, glcoex_ver_8822b_1ant,
+		   glcoex_ver_btdesired_8822b_1ant, bt_coex_ver,
+		   (bt_coex_ver == 0xff ?
+			 "Unknown" :
+			 (coex_sta->bt_disabled ?
+			  "BT-disable" :
+			  (bt_coex_ver >= glcoex_ver_btdesired_8822b_1ant ?
+				   "Match" :
+				   "Mis-Match"))));
+
+	seq_printf(m, "\n %-35s = 0x%x/ 0x%x/ v%d/ %c",
+		   "W_FW/ B_FW/ Phy/ Kt", fw_ver, bt_patch_ver, phyver,
+		   coex_sta->cut_version + 65);
+
+	seq_printf(m,
+		   "\n %-35s = %02x %02x %02x (RF-Ch = %d)", "AFH Map to BT",
+		   coex_dm->wifi_chnl_info[0], coex_dm->wifi_chnl_info[1],
+		   coex_dm->wifi_chnl_info[2], coex_sta->wl_center_channel);
+
+	/* wifi status */
+	seq_printf(m, "\n %-35s",
+		   "============[Wifi Status]============");
+	btcoexist->btc_disp_dbg_msg(btcoexist, BTC_DBG_DISP_WIFI_STATUS, m);
+
+	seq_printf(m, "\n %-35s",
+		   "============[BT Status]============");
+
+	pop_report_in_10s++;
+	seq_printf(m, "\n %-35s = %s/ %ddBm/ %d/ %d",
+		   "BT status/ rssi/ retryCnt/ popCnt",
+		   ((coex_sta->bt_disabled) ? ("disabled") :
+		    ((coex_sta->c2h_bt_inquiry_page) ?
+			  ("inquiry-page") :
+			  ((BT_8822B_1ANT_BT_STATUS_NCONNECTED_IDLE ==
+			    coex_dm->bt_status) ?
+				   "non-connecte-idle" :
+				   ((coex_dm->bt_status ==
+				     BT_8822B_1ANT_BT_STATUS_CONNECTED_IDLE) ?
+					    "connected-idle" :
+					    "busy")))),
+		coex_sta->bt_rssi - 100, coex_sta->bt_retry_cnt,
+		coex_sta->pop_event_cnt);
+
+	if (pop_report_in_10s >= 5) {
+		coex_sta->pop_event_cnt = 0;
+		pop_report_in_10s = 0;
+	}
+
+	if (coex_sta->num_of_profile != 0)
+		seq_printf(m,
+			   "\n %-35s = %s%s%s%s%s%s (multilink = %d)",
+			   "Profiles", ((bt_link_info->a2dp_exist) ?
+						((coex_sta->is_bt_a2dp_sink) ?
+							 "A2DP sink," :
+							 "A2DP,") :
+						""),
+			   ((bt_link_info->sco_exist) ? "HFP," : ""),
+			   ((bt_link_info->hid_exist) ?
+				    ((coex_sta->is_hid_rcu) ?
+					     "HID(RCU)" :
+					     ((coex_sta->hid_busy_num >= 2) ?
+						      "HID(4/18)," :
+						      "HID(2/18),")) :
+				    ""),
+			   ((bt_link_info->pan_exist) ?
+				    ((coex_sta->is_bt_opp_exist) ? "OPP," :
+								   "PAN,") :
+				    ""),
+			   ((coex_sta->voice_over_HOGP) ? "Voice," : ""),
+			   ((coex_sta->msft_mr_exist) ? "MR" : ""),
+			   coex_sta->is_bt_multi_link);
+	else
+		seq_printf(m, "\n %-35s = %s",
+			   "Profiles",
+			   (coex_sta->msft_mr_exist) ? "MR" : "None");
+
+	if (bt_link_info->a2dp_exist) {
+		seq_printf(m, "\n %-35s = %s/ %d/ %s",
+			   "A2DP Rate/Bitpool/Auto_Slot",
+			   ((coex_sta->is_A2DP_3M) ? "3M" : "No_3M"),
+			   coex_sta->a2dp_bit_pool,
+			   ((coex_sta->is_autoslot) ? "On" : "Off"));
+
+		seq_printf(m,
+			   "\n %-35s = 0x%x/ 0x%x/ %d/ %d",
+			   "V_ID/D_name/FBSlot_Legacy/FBSlot_Le",
+			   coex_sta->bt_a2dp_vendor_id,
+			   coex_sta->bt_a2dp_device_name,
+			   coex_sta->legacy_forbidden_slot,
+			   coex_sta->le_forbidden_slot);
+	}
+
+	if (bt_link_info->hid_exist) {
+		seq_printf(m, "\n %-35s = %d",
+			   "HID PairNum", coex_sta->hid_pair_cnt);
+	}
+
+	seq_printf(m, "\n %-35s = %s/ %d/ %s/ 0x%x",
+		   "Role/RoleSwCnt/IgnWlact/Feature",
+		   ((bt_link_info->slave_role) ? "Slave" : "Master"),
+		   coex_sta->cnt_role_switch,
+		   ((coex_dm->cur_ignore_wlan_act) ? "Yes" : "No"),
+		   coex_sta->bt_coex_supported_feature);
+
+	if ((coex_sta->bt_ble_scan_type & 0x7) != 0x0) {
+		seq_printf(m,
+			   "\n %-35s = 0x%x/ 0x%x/ 0x%x/ 0x%x",
+			   "BLEScan Type/TV/Init/Ble",
+			   coex_sta->bt_ble_scan_type,
+			   (coex_sta->bt_ble_scan_type & 0x1 ?
+				    coex_sta->bt_ble_scan_para[0] :
+				    0x0),
+			   (coex_sta->bt_ble_scan_type & 0x2 ?
+				    coex_sta->bt_ble_scan_para[1] :
+				    0x0),
+			   (coex_sta->bt_ble_scan_type & 0x4 ?
+				    coex_sta->bt_ble_scan_para[2] :
+				    0x0));
+	}
+
+	seq_printf(m, "\n %-35s = %d/ %d/ %d/ %d/ %d",
+		   "ReInit/ReLink/IgnWlact/Page/NameReq", coex_sta->cnt_reinit,
+		   coex_sta->cnt_setup_link, coex_sta->cnt_ign_wlan_act,
+		   coex_sta->cnt_page, coex_sta->cnt_remote_name_req);
+
+	halbtc8822b1ant_read_score_board(btcoexist, &u16tmp[0]);
+
+	if (coex_sta->bt_reg_vendor_ae == 0xffff ||
+	    coex_sta->bt_reg_vendor_ac == 0xffff)
+		seq_printf(m,
+			   "\n %-35s = x/ x/ 0x%04x",
+			   "0xae[4]/0xac[1:0]/Scoreboard(B->W)", u16tmp[0]);
+	else
+		seq_printf(m,
+			   "\n %-35s = 0x%x/ 0x%x/ 0x%04x",
+			   "0xae[4]/0xac[1:0]/Scoreboard(B->W)",
+			   (int)((coex_sta->bt_reg_vendor_ae & BIT(4)) >> 4),
+			   coex_sta->bt_reg_vendor_ac & 0x3, u16tmp[0]);
+
+	if (coex_sta->num_of_profile > 0) {
+		seq_printf(m,
+			   "\n %-35s = %02x%02x%02x%02x %02x%02x%02x%02x %02x%02x",
+			   "AFH MAP", coex_sta->bt_afh_map[0],
+			   coex_sta->bt_afh_map[1], coex_sta->bt_afh_map[2],
+			   coex_sta->bt_afh_map[3], coex_sta->bt_afh_map[4],
+			   coex_sta->bt_afh_map[5], coex_sta->bt_afh_map[6],
+			   coex_sta->bt_afh_map[7], coex_sta->bt_afh_map[8],
+			   coex_sta->bt_afh_map[9]);
+	}
+
+	for (i = 0; i < BT_INFO_SRC_8822B_1ANT_MAX; i++) {
+		if (coex_sta->bt_info_c2h_cnt[i]) {
+			seq_printf(m,
+				   "\n %-35s = %02x %02x %02x %02x %02x %02x %02x (%d)",
+				   glbt_info_src_8822b_1ant[i],
+				   coex_sta->bt_info_c2h[i][0],
+				   coex_sta->bt_info_c2h[i][1],
+				   coex_sta->bt_info_c2h[i][2],
+				   coex_sta->bt_info_c2h[i][3],
+				   coex_sta->bt_info_c2h[i][4],
+				   coex_sta->bt_info_c2h[i][5],
+				   coex_sta->bt_info_c2h[i][6],
+				   coex_sta->bt_info_c2h_cnt[i]);
+		}
+	}
+
+	if (btcoexist->manual_control)
+		seq_printf(m, "\n %-35s",
+			   "============[mechanisms] (before Manual)============");
+	else
+		seq_printf(m, "\n %-35s",
+			   "============[Mechanisms]============");
+
+	ps_tdma_case = coex_dm->cur_ps_tdma;
+	seq_printf(m,
+		   "\n %-35s = %02x %02x %02x %02x %02x (case-%d, %s)",
+		   "TDMA", coex_dm->ps_tdma_para[0], coex_dm->ps_tdma_para[1],
+		   coex_dm->ps_tdma_para[2], coex_dm->ps_tdma_para[3],
+		   coex_dm->ps_tdma_para[4], ps_tdma_case,
+		   (coex_dm->cur_ps_tdma_on ? "TDMA On" : "TDMA Off"));
+
+	u32tmp[0] = btcoexist->btc_read_4byte(btcoexist, 0x6c0);
+	u32tmp[1] = btcoexist->btc_read_4byte(btcoexist, 0x6c4);
+	u32tmp[2] = btcoexist->btc_read_4byte(btcoexist, 0x6c8);
+	seq_printf(m,
+		   "\n %-35s = %d/ 0x%x/ 0x%x/ 0x%x",
+		   "Table/0x6c0/0x6c4/0x6c8", coex_sta->coex_table_type,
+		   u32tmp[0], u32tmp[1], u32tmp[2]);
+
+	u8tmp[0] = btcoexist->btc_read_1byte(btcoexist, 0x778);
+	u32tmp[0] = btcoexist->btc_read_4byte(btcoexist, 0x6cc);
+	seq_printf(m, "\n %-35s = 0x%x/ 0x%x/ 0x%04x",
+		   "0x778/0x6cc/Scoreboard(W->B)", u8tmp[0], u32tmp[0],
+		   coex_sta->score_board_WB);
+
+	seq_printf(m, "\n %-35s = %s/ %s/ %s/ %d/ %d",
+		   "AntDiv/BtCtrlLPS/LPRA/PsFail/g_busy",
+		   ((board_info->ant_div_cfg) ? "On" : "Off"),
+		   ((coex_sta->force_lps_ctrl) ? "On" : "Off"),
+		   ((coex_dm->cur_low_penalty_ra) ? "On" : "Off"),
+		   coex_sta->cnt_set_ps_state_fail, coex_sta->gl_wifi_busy);
+
+	seq_printf(m, "\n %-35s = %d/ %d/ %d/ %d/ %d",
+		   "Null All/Retry/Ack/BT_Empty/BT_Late",
+		   coex_sta->wl_fw_dbg_info[1], coex_sta->wl_fw_dbg_info[2],
+		   coex_sta->wl_fw_dbg_info[3], coex_sta->wl_fw_dbg_info[4],
+		   coex_sta->wl_fw_dbg_info[5]);
+
+	u32tmp[0] = halbtc8822b1ant_ltecoex_read_reg(btcoexist, 0x38);
+	lte_coex_on = ((u32tmp[0] & BIT(7)) >> 7) ? true : false;
+
+	if (lte_coex_on) {
+		u32tmp[0] = halbtc8822b1ant_ltecoex_read_reg(btcoexist, 0xa0);
+		u32tmp[1] = halbtc8822b1ant_ltecoex_read_reg(btcoexist, 0xa4);
+
+		seq_printf(m, "\n %-35s = 0x%x/ 0x%x",
+			   "LTE Coex Table W_L/B_L", u32tmp[0] & 0xffff,
+			   u32tmp[1] & 0xffff);
+
+		u32tmp[0] = halbtc8822b1ant_ltecoex_read_reg(btcoexist, 0xa8);
+		u32tmp[1] = halbtc8822b1ant_ltecoex_read_reg(btcoexist, 0xac);
+		u32tmp[2] = halbtc8822b1ant_ltecoex_read_reg(btcoexist, 0xb0);
+		u32tmp[3] = halbtc8822b1ant_ltecoex_read_reg(btcoexist, 0xb4);
+
+		seq_printf(m,
+			   "\n %-35s = 0x%x/ 0x%x/ 0x%x/ 0x%x",
+			   "LTE Break Table W_L/B_L/L_W/L_B",
+			   u32tmp[0] & 0xffff, u32tmp[1] & 0xffff,
+			   u32tmp[2] & 0xffff, u32tmp[3] & 0xffff);
+	}
+
+	/* Hw setting		 */
+	seq_printf(m, "\n %-35s",
+		   "============[Hw setting]============");
+
+	u32tmp[0] = halbtc8822b1ant_ltecoex_read_reg(btcoexist, 0x38);
+	u32tmp[1] = halbtc8822b1ant_ltecoex_read_reg(btcoexist, 0x54);
+	u8tmp[0] = btcoexist->btc_read_1byte(btcoexist, 0x73);
+
+	seq_printf(m, "\n %-35s = %s/ %s",
+		   "LTE Coex/Path Owner", ((lte_coex_on) ? "On" : "Off"),
+		   ((u8tmp[0] & BIT(2)) ? "WL" : "BT"));
+
+	if (lte_coex_on) {
+		seq_printf(m,
+			   "\n %-35s = %d/ %d/ %d/ %d",
+			   "LTE 3Wire/OPMode/UART/UARTMode",
+			   (int)((u32tmp[0] & BIT(6)) >> 6),
+			   (int)((u32tmp[0] & (BIT(5) | BIT(4))) >> 4),
+			   (int)((u32tmp[0] & BIT(3)) >> 3),
+			   (int)(u32tmp[0] & (BIT(2) | BIT(1) | BIT(0))));
+
+		seq_printf(m, "\n %-35s = %d/ %d",
+			   "LTE_Busy/UART_Busy",
+			   (int)((u32tmp[1] & BIT(1)) >> 1),
+			   (int)(u32tmp[1] & BIT(0)));
+	}
+	seq_printf(m,
+		   "\n %-35s = %s (BB:%s)/ %s (BB:%s)/ %s (gnt_err = %d)",
+		   "GNT_WL_Ctrl/GNT_BT_Ctrl/Dbg",
+		   ((u32tmp[0] & BIT(12)) ? "SW" : "HW"),
+		   ((u32tmp[0] & BIT(8)) ? "SW" : "HW"),
+		   ((u32tmp[0] & BIT(14)) ? "SW" : "HW"),
+		   ((u32tmp[0] & BIT(10)) ? "SW" : "HW"),
+		   ((u8tmp[0] & BIT(3)) ? "On" : "Off"),
+		   coex_sta->gnt_error_cnt);
+
+	seq_printf(m, "\n %-35s = %d/ %d",
+		   "GNT_WL/GNT_BT", (int)((u32tmp[1] & BIT(2)) >> 2),
+		   (int)((u32tmp[1] & BIT(3)) >> 3));
+
+	u32tmp[0] = btcoexist->btc_read_4byte(btcoexist, 0xcb0);
+	u32tmp[1] = btcoexist->btc_read_4byte(btcoexist, 0xcb4);
+	u8tmp[0] = btcoexist->btc_read_1byte(btcoexist, 0xcba);
+	u8tmp[1] = btcoexist->btc_read_1byte(btcoexist, 0xcbd);
+	u8tmp[2] = btcoexist->btc_read_1byte(btcoexist, 0xc58);
+
+	seq_printf(m,
+		   "\n %-35s = 0x%04x/ 0x%04x/ 0x%02x/ 0x%02x/ 0x%02x %s",
+		   "0xcb0/0xcb4/0xcb8[23:16]/0xcbd/0xc58", u32tmp[0], u32tmp[1],
+		   u8tmp[0], u8tmp[1], u8tmp[2],
+		   ((u8tmp[1] & 0x1) == 0x1 ? "(BT_WL5G)" : "(WL2G)"));
+
+	u32tmp[0] = btcoexist->btc_read_4byte(btcoexist, 0x4c);
+	u8tmp[2] = btcoexist->btc_read_1byte(btcoexist, 0x64);
+	u8tmp[0] = btcoexist->btc_read_1byte(btcoexist, 0x4c6);
+	u8tmp[1] = btcoexist->btc_read_1byte(btcoexist, 0x40);
+
+	seq_printf(m,
+		   "\n %-35s = 0x%x/ 0x%x/ 0x%x/ 0x%x",
+		   "4c[24:23]/64[0]/4c6[4]/40[5]",
+		   (int)(u32tmp[0] & (BIT(24) | BIT(23))) >> 23, u8tmp[2] & 0x1,
+		   (int)((u8tmp[0] & BIT(4)) >> 4),
+		   (int)((u8tmp[1] & BIT(5)) >> 5));
+
+	u32tmp[0] = btcoexist->btc_read_4byte(btcoexist, 0x550);
+	u8tmp[0] = btcoexist->btc_read_1byte(btcoexist, 0x522);
+	u8tmp[1] = btcoexist->btc_read_1byte(btcoexist, 0x953);
+	u8tmp[2] = btcoexist->btc_read_1byte(btcoexist, 0xc50);
+
+	seq_printf(m,
+		   "\n %-35s = 0x%x/ 0x%x/ %s/ 0x%x",
+		   "0x550/0x522/4-RxAGC/0xc50", u32tmp[0], u8tmp[0],
+		   (u8tmp[1] & 0x2) ? "On" : "Off", u8tmp[2]);
+
+	fa_ofdm = btcoexist->btc_phydm_query_phy_counter(btcoexist,
+							 DM_INFO_FA_OFDM);
+	fa_cck = btcoexist->btc_phydm_query_phy_counter(btcoexist,
+							DM_INFO_FA_CCK);
+	cca_ofdm = btcoexist->btc_phydm_query_phy_counter(btcoexist,
+							  DM_INFO_CCA_OFDM);
+	cca_cck = btcoexist->btc_phydm_query_phy_counter(btcoexist,
+							 DM_INFO_CCA_CCK);
+
+	seq_printf(m,
+		   "\n %-35s = 0x%x/ 0x%x/ 0x%x/ 0x%x",
+		   "CCK-CCA/CCK-FA/OFDM-CCA/OFDM-FA", cca_cck, fa_cck, cca_ofdm,
+		   fa_ofdm);
+
+	seq_printf(m,
+		   "\n %-35s = %d/ %d/ %d/ %d (Rx_rate Data/RTS= %d/%d)",
+		   "CRC_OK CCK/11g/11n/11ac", coex_sta->crc_ok_cck,
+		   coex_sta->crc_ok_11g, coex_sta->crc_ok_11n,
+		   coex_sta->crc_ok_11n_vht, coex_sta->wl_rx_rate,
+		   coex_sta->wl_rts_rx_rate);
+
+	seq_printf(m, "\n %-35s = %d/ %d/ %d/ %d",
+		   "CRC_Err CCK/11g/11n/11ac", coex_sta->crc_err_cck,
+		   coex_sta->crc_err_11g, coex_sta->crc_err_11n,
+		   coex_sta->crc_err_11n_vht);
+
+	seq_printf(m, "\n %-35s = %s/ %s/ %s/ %s/ %d",
+		   "HiPr/ Locking/ warn/ Locked/ Noisy",
+		   (coex_sta->wifi_is_high_pri_task ? "Yes" : "No"),
+		   (coex_sta->cck_lock ? "Yes" : "No"),
+		   (coex_sta->cck_lock_warn ? "Yes" : "No"),
+		   (coex_sta->cck_lock_ever ? "Yes" : "No"),
+		   coex_sta->wl_noisy_level);
+
+	seq_printf(m, "\n %-35s = %d/ %d",
+		   "0x770(Hi-pri rx/tx)", coex_sta->high_priority_rx,
+		   coex_sta->high_priority_tx);
+
+	seq_printf(m, "\n %-35s = %d/ %d %s",
+		   "0x774(Lo-pri rx/tx)", coex_sta->low_priority_rx,
+		   coex_sta->low_priority_tx,
+		   (bt_link_info->slave_role ?
+			    "(Slave!!)" :
+			    (coex_sta->is_tdma_btautoslot_hang ?
+				     "(auto-slot hang!!)" :
+				     "")));
+
+	btcoexist->btc_disp_dbg_msg(btcoexist, BTC_DBG_DISP_COEX_STATISTICS, m);
+}
+
+void ex_btc8822b1ant_ips_notify(struct btc_coexist *btcoexist, u8 type)
+{
+	struct rtl_priv *rtlpriv = btcoexist->adapter;
+
+	if (btcoexist->manual_control || btcoexist->stop_coex_dm)
+		return;
+
+	if (type == BTC_IPS_ENTER) {
+		RT_TRACE(rtlpriv, COMP_BT_COEXIST, DBG_LOUD,
+			 "[BTCoex], IPS ENTER notify\n");
+		coex_sta->under_ips = true;
+
+		/* Write WL "Active" in Score-board for LPS off */
+		halbtc8822b1ant_post_state_to_bt(btcoexist,
+						 BT_8822B_1ANT_SCBD_ACTIVE |
+						 BT_8822B_1ANT_SCBD_ONOFF |
+						 BT_8822B_1ANT_SCBD_SCAN |
+						 BT_8822B_1ANT_SCBD_UNDERTEST |
+						 BT_8822B_1ANT_SCBD_RXGAIN,
+						 false);
+
+		halbtc8822b1ant_set_ant_path(btcoexist, BTC_ANT_PATH_AUTO,
+					     FORCE_EXEC,
+					     BT_8822B_1ANT_PHASE_WOFF);
+
+		halbtc8822b1ant_coex_table_type(btcoexist, NORMAL_EXEC, 0);
+		halbtc8822b1ant_ps_tdma(btcoexist, NORMAL_EXEC, false, 0);
+	} else if (type == BTC_IPS_LEAVE) {
+		RT_TRACE(rtlpriv, COMP_BT_COEXIST, DBG_LOUD,
+			 "[BTCoex], IPS LEAVE notify\n");
+		halbtc8822b1ant_post_state_to_bt(btcoexist,
+						 BT_8822B_1ANT_SCBD_ACTIVE |
+						 BT_8822B_1ANT_SCBD_ONOFF,
+						 true);
+
+		/*leave IPS : run ini hw config (exclude wifi only)*/
+		halbtc8822b1ant_init_hw_config(btcoexist, false, false);
+		/*sw all off*/
+		halbtc8822b1ant_init_coex_dm(btcoexist);
+
+		coex_sta->under_ips = false;
+	}
+}
+
+void ex_btc8822b1ant_lps_notify(struct btc_coexist *btcoexist, u8 type)
+{
+	struct rtl_priv *rtlpriv = btcoexist->adapter;
+	static bool pre_force_lps_on;
+
+	if (btcoexist->manual_control || btcoexist->stop_coex_dm)
+		return;
+
+	if (type == BTC_LPS_ENABLE) {
+		const u16 type_is_active = BT_8822B_1ANT_SCBD_ACTIVE;
+
+		RT_TRACE(rtlpriv, COMP_BT_COEXIST, DBG_LOUD,
+			 "[BTCoex], LPS ENABLE notify\n");
+		coex_sta->under_lps = true;
+
+		if (coex_sta->force_lps_ctrl) { /* LPS No-32K */
+			/* Write WL "Active" in Score-board for PS-TDMA */
+			pre_force_lps_on = true;
+			halbtc8822b1ant_post_state_to_bt(btcoexist,
+							 type_is_active,
+							 true);
+		} else {
+			/* LPS-32K, need check if this h2c 0x71 can work??
+			 * (2015/08/28)
+			 */
+			/* Write WL "Non-Active" in Score-board for Native-PS */
+			pre_force_lps_on = false;
+			halbtc8822b1ant_post_state_to_bt(btcoexist,
+							 type_is_active,
+							 false);
+
+			halbtc8822b1ant_action_wifi_native_lps(btcoexist);
+		}
+	} else if (type == BTC_LPS_DISABLE) {
+		RT_TRACE(rtlpriv, COMP_BT_COEXIST, DBG_LOUD,
+			 "[BTCoex], LPS DISABLE notify\n");
+		coex_sta->under_lps = false;
+
+		/* Write WL "Active" in Score-board for LPS off */
+		halbtc8822b1ant_post_state_to_bt(btcoexist,
+						 BT_8822B_1ANT_SCBD_ACTIVE,
+						 true);
+
+		if (!pre_force_lps_on && !coex_sta->force_lps_ctrl)
+			halbtc8822b1ant_query_bt_info(btcoexist);
+	}
+}
+
+void ex_btc8822b1ant_scan_notify(struct btc_coexist *btcoexist, u8 type)
+{
+	struct rtl_priv *rtlpriv = btcoexist->adapter;
+	bool wifi_connected = false;
+	bool wifi_under_5g = false;
+
+	if (btcoexist->manual_control || btcoexist->stop_coex_dm)
+		return;
+
+	coex_sta->freeze_coexrun_by_btinfo = false;
+
+	btcoexist->btc_get(btcoexist, BTC_GET_BL_WIFI_CONNECTED,
+			   &wifi_connected);
+
+	if (wifi_connected)
+		RT_TRACE(rtlpriv, COMP_BT_COEXIST, DBG_LOUD,
+			 "[BTCoex], ********** WL connected before SCAN\n");
+	else
+		RT_TRACE(rtlpriv, COMP_BT_COEXIST, DBG_LOUD,
+			 "[BTCoex], **********  WL is not connected before SCAN\n");
+
+	if (type == BTC_SCAN_START || type == BTC_SCAN_START_2G) {
+		halbtc8822b1ant_post_state_to_bt(btcoexist,
+						 BT_8822B_1ANT_SCBD_ACTIVE |
+						 BT_8822B_1ANT_SCBD_SCAN |
+						 BT_8822B_1ANT_SCBD_ONOFF,
+						 true);
+
+		halbtc8822b1ant_query_bt_info(btcoexist);
+	}
+
+	btcoexist->btc_get(btcoexist, BTC_GET_BL_WIFI_UNDER_5G, &wifi_under_5g);
+
+	if (type == BTC_SCAN_START && wifi_under_5g) {
+		RT_TRACE(rtlpriv, COMP_BT_COEXIST, DBG_LOUD,
+			 "[BTCoex], SCAN START notify (5G)\n");
+
+		halbtc8822b1ant_set_ant_path(btcoexist, BTC_ANT_PATH_AUTO,
+					     FORCE_EXEC,
+					     BT_8822B_1ANT_PHASE_5G);
+		halbtc8822b1ant_run_coexist_mechanism(btcoexist);
+	} else if (type == BTC_SCAN_START_2G || type == BTC_SCAN_START) {
+		RT_TRACE(rtlpriv, COMP_BT_COEXIST, DBG_LOUD,
+			 "[BTCoex], SCAN START notify (2G)\n");
+
+		if (!wifi_connected)
+			coex_sta->wifi_is_high_pri_task = true;
+
+		/* Force antenna setup for no scan result issue */
+		halbtc8822b1ant_set_ant_path(btcoexist, BTC_ANT_PATH_AUTO,
+					     FORCE_EXEC,
+					     BT_8822B_1ANT_PHASE_2G);
+
+		halbtc8822b1ant_run_coexist_mechanism(btcoexist);
+	} else {
+		btcoexist->btc_get(btcoexist, BTC_GET_U1_AP_NUM,
+				   &coex_sta->scan_ap_num);
+
+		RT_TRACE(rtlpriv, COMP_BT_COEXIST, DBG_LOUD,
+			 "[BTCoex], SCAN FINISH notify  (Scan-AP = %d)\n",
+			 coex_sta->scan_ap_num);
+
+		coex_sta->wifi_is_high_pri_task = false;
+
+		halbtc8822b1ant_run_coexist_mechanism(btcoexist);
+	}
+}
+
+void ex_btc8822b1ant_scan_notify_without_bt(struct btc_coexist *btcoexist,
+					    u8 type)
+{
+	bool wifi_under_5g = false;
+
+	btcoexist->btc_get(btcoexist, BTC_GET_BL_WIFI_UNDER_5G, &wifi_under_5g);
+
+	if (type == BTC_SCAN_START) {
+		if (wifi_under_5g)
+			btcoexist->btc_write_1byte_bitmask(btcoexist, 0xcbd,
+							   0x3, 1);
+		else /* under 2.4G */
+			btcoexist->btc_write_1byte_bitmask(btcoexist, 0xcbd,
+							   0x3, 2);
+	} else if (type == BTC_SCAN_START_2G) {
+		btcoexist->btc_write_1byte_bitmask(btcoexist, 0xcbd, 0x3, 2);
+	}
+}
+
+void ex_btc8822b1ant_switchband_notify(struct btc_coexist *btcoexist,
+				       u8 type)
+{
+	struct rtl_priv *rtlpriv = btcoexist->adapter;
+
+	if (btcoexist->manual_control || btcoexist->stop_coex_dm)
+		return;
+
+	coex_sta->switch_band_notify_to = type;
+
+	if (type == BTC_SWITCH_TO_5G) {
+		RT_TRACE(rtlpriv, COMP_BT_COEXIST, DBG_LOUD,
+			 "[BTCoex], switchband_notify --- BTC_SWITCH_TO_5G\n");
+
+		halbtc8822b1ant_run_coexist_mechanism(btcoexist);
+	} else if (type == BTC_SWITCH_TO_24G_NOFORSCAN) {
+		RT_TRACE(rtlpriv, COMP_BT_COEXIST, DBG_LOUD,
+			 "[BTCoex], switchband_notify --- BTC_SWITCH_TO_24G_NOFORSCAN\n");
+
+		halbtc8822b1ant_run_coexist_mechanism(btcoexist);
+	} else {
+		RT_TRACE(rtlpriv, COMP_BT_COEXIST, DBG_LOUD,
+			 "[BTCoex], switchband_notify --- BTC_SWITCH_TO_2G\n");
+
+		ex_btc8822b1ant_scan_notify(btcoexist, BTC_SCAN_START_2G);
+	}
+
+	coex_sta->switch_band_notify_to = BTC_NOT_SWITCH;
+}
+
+void
+ex_btc8822b1ant_switchband_notify_without_bt(struct btc_coexist *btcoexist,
+					     u8 type)
+{
+	if (type == BTC_SWITCH_TO_5G)
+		btcoexist->btc_write_1byte_bitmask(btcoexist, 0xcbd, 0x3, 1);
+	else if (type == BTC_SWITCH_TO_24G_NOFORSCAN)
+		btcoexist->btc_write_1byte_bitmask(btcoexist, 0xcbd, 0x3, 2);
+	else
+		ex_btc8822b1ant_scan_notify_without_bt(btcoexist,
+						       BTC_SCAN_START_2G);
+}
+
+void ex_btc8822b1ant_connect_notify(struct btc_coexist *btcoexist, u8 type)
+{
+	struct rtl_priv *rtlpriv = btcoexist->adapter;
+
+	if (btcoexist->manual_control || btcoexist->stop_coex_dm)
+		return;
+
+	halbtc8822b1ant_post_state_to_bt(btcoexist,
+					 BT_8822B_1ANT_SCBD_ACTIVE |
+					 BT_8822B_1ANT_SCBD_SCAN |
+					 BT_8822B_1ANT_SCBD_ONOFF,
+					 true);
+
+	if (type == BTC_ASSOCIATE_5G_START ||
+	    type == BTC_ASSOCIATE_5G_FINISH) {
+		if (type == BTC_ASSOCIATE_5G_START)
+			RT_TRACE(rtlpriv, COMP_BT_COEXIST, DBG_LOUD,
+				 "[BTCoex], connect_notify ---  5G start\n");
+		else
+			RT_TRACE(rtlpriv, COMP_BT_COEXIST, DBG_LOUD,
+				 "[BTCoex], connect_notify ---  5G finish\n");
+
+		halbtc8822b1ant_set_ant_path(btcoexist, BTC_ANT_PATH_AUTO,
+					     FORCE_EXEC,
+					     BT_8822B_1ANT_PHASE_5G);
+
+		halbtc8822b1ant_run_coexist_mechanism(btcoexist);
+	} else if (type == BTC_ASSOCIATE_START) {
+		coex_sta->wifi_is_high_pri_task = true;
+		coex_dm->arp_cnt = 0;
+		coex_sta->connect_ap_period_cnt = 2;
+
+		RT_TRACE(rtlpriv, COMP_BT_COEXIST, DBG_LOUD,
+			 "[BTCoex], CONNECT START notify (2G)\n");
+
+		/* Force antenna setup for no scan result issue */
+		halbtc8822b1ant_set_ant_path(btcoexist, BTC_ANT_PATH_AUTO,
+					     FORCE_EXEC,
+					     BT_8822B_1ANT_PHASE_2G);
+
+		halbtc8822b1ant_run_coexist_mechanism(btcoexist);
+
+		/* To keep TDMA case during connect process,
+		 * to avoid changed by Btinfo and runcoexmechanism
+		 */
+		coex_sta->freeze_coexrun_by_btinfo = true;
+	} else {
+		coex_sta->wifi_is_high_pri_task = false;
+		coex_sta->freeze_coexrun_by_btinfo = false;
+
+		RT_TRACE(rtlpriv, COMP_BT_COEXIST, DBG_LOUD,
+			 "[BTCoex], CONNECT FINISH notify (2G)\n");
+
+		halbtc8822b1ant_run_coexist_mechanism(btcoexist);
+	}
+}
+
+void ex_btc8822b1ant_media_status_notify(struct btc_coexist *btcoexist,
+					 u8 type)
+{
+	struct rtl_priv *rtlpriv = btcoexist->adapter;
+	bool wifi_under_b_mode = false;
+	bool wifi_under_5g = false;
+
+	if (btcoexist->manual_control || btcoexist->stop_coex_dm)
+		return;
+
+	btcoexist->btc_get(btcoexist, BTC_GET_BL_WIFI_UNDER_5G, &wifi_under_5g);
+
+	if (type == BTC_MEDIA_CONNECT) {
+		halbtc8822b1ant_post_state_to_bt(btcoexist,
+						 BT_8822B_1ANT_SCBD_ACTIVE,
+						 true);
+
+		if (wifi_under_5g) {
+			RT_TRACE(rtlpriv, COMP_BT_COEXIST, DBG_LOUD,
+				 "[BTCoex], media_status_notify --- 5G\n");
+
+			halbtc8822b1ant_set_ant_path(btcoexist,
+						     BTC_ANT_PATH_AUTO,
+						     FORCE_EXEC,
+						     BT_8822B_1ANT_PHASE_5G);
+
+			halbtc8822b1ant_run_coexist_mechanism(btcoexist);
+		} else {
+			RT_TRACE(rtlpriv, COMP_BT_COEXIST, DBG_LOUD,
+				 "[BTCoex], media_status_notify --- 2G\n");
+
+			/* Force antenna setup for no scan result issue */
+			halbtc8822b1ant_set_ant_path(btcoexist,
+						     BTC_ANT_PATH_AUTO,
+						     FORCE_EXEC,
+						     BT_8822B_1ANT_PHASE_2G);
+
+			btcoexist->btc_get(btcoexist,
+					   BTC_GET_BL_WIFI_UNDER_B_MODE,
+					   &wifi_under_b_mode);
+
+			/* Set CCK Tx/Rx high Pri except 11b mode */
+			if (wifi_under_b_mode) {
+				RT_TRACE(rtlpriv, COMP_BT_COEXIST, DBG_LOUD,
+					 "[BTCoex], media status notity --- under b mode\n");
+				btcoexist->btc_write_1byte(btcoexist, 0x6cd,
+							   0x00); /* CCK Tx */
+				btcoexist->btc_write_1byte(btcoexist, 0x6cf,
+							   0x00); /* CCK Rx */
+			} else {
+				RT_TRACE(rtlpriv, COMP_BT_COEXIST, DBG_LOUD,
+					 "[BTCoex], media status notity --- under b mode\n");
+				btcoexist->btc_write_1byte(btcoexist, 0x6cd,
+							   0x00); /* CCK Tx */
+				btcoexist->btc_write_1byte(btcoexist, 0x6cf,
+							   0x10); /* CCK Rx */
+			}
+
+			halbtc8822b1ant_run_coexist_mechanism(btcoexist);
+		}
+	} else {
+		RT_TRACE(rtlpriv, COMP_BT_COEXIST, DBG_LOUD,
+			 "[BTCoex], media disconnect notify\n");
+		coex_dm->arp_cnt = 0;
+
+		halbtc8822b1ant_post_state_to_bt(btcoexist,
+						 BT_8822B_1ANT_SCBD_ACTIVE,
+						 false);
+
+		btcoexist->btc_write_1byte(btcoexist, 0x6cd, 0x0); /* CCK Tx */
+		btcoexist->btc_write_1byte(btcoexist, 0x6cf, 0x0); /* CCK Rx */
+
+		coex_sta->cck_lock_ever = false;
+		coex_sta->cck_lock_warn = false;
+		coex_sta->cck_lock = false;
+
+		halbtc8822b1ant_run_coexist_mechanism(btcoexist);
+	}
+
+	halbtc8822b1ant_update_wifi_ch_info(btcoexist, type);
+}
+
+void ex_btc8822b1ant_specific_packet_notify(struct btc_coexist *btcoexist,
+					    u8 type)
+{
+	struct rtl_priv *rtlpriv = btcoexist->adapter;
+	bool under_4way = false, wifi_under_5g = false;
+
+	if (btcoexist->manual_control || btcoexist->stop_coex_dm)
+		return;
+
+	btcoexist->btc_get(btcoexist, BTC_GET_BL_WIFI_UNDER_5G, &wifi_under_5g);
+	if (wifi_under_5g) {
+		RT_TRACE(rtlpriv, COMP_BT_COEXIST, DBG_LOUD,
+			 "[BTCoex], 5g special packet notify\n");
+
+		halbtc8822b1ant_run_coexist_mechanism(btcoexist);
+		return;
+	}
+
+	btcoexist->btc_get(btcoexist, BTC_GET_BL_WIFI_4_WAY_PROGRESS,
+			   &under_4way);
+
+	if (under_4way) {
+		RT_TRACE(rtlpriv, COMP_BT_COEXIST, DBG_LOUD,
+			 "[BTCoex], specific Packet ---- under_4way!!\n");
+
+		coex_sta->wifi_is_high_pri_task = true;
+		coex_sta->specific_pkt_period_cnt = 2;
+	} else if (type == BTC_PACKET_ARP) {
+		coex_dm->arp_cnt++;
+
+		if (coex_sta->wifi_is_high_pri_task) {
+			RT_TRACE(rtlpriv, COMP_BT_COEXIST, DBG_LOUD,
+				 "[BTCoex], specific Packet ARP notify -cnt = %d\n",
+				 coex_dm->arp_cnt);
+		}
+
+	} else {
+		RT_TRACE(rtlpriv, COMP_BT_COEXIST, DBG_LOUD,
+			 "[BTCoex], specific Packet DHCP or EAPOL notify [Type = %d]\n",
+			 type);
+
+		coex_sta->wifi_is_high_pri_task = true;
+		coex_sta->specific_pkt_period_cnt = 2;
+	}
+
+	if (coex_sta->wifi_is_high_pri_task) {
+		halbtc8822b1ant_post_state_to_bt(btcoexist,
+						 BT_8822B_1ANT_SCBD_SCAN,
+						 true);
+		halbtc8822b1ant_run_coexist_mechanism(btcoexist);
+	}
+}
+
+void ex_btc8822b1ant_bt_info_notify(struct btc_coexist *btcoexist,
+				    u8 *tmp_buf, u8 length)
+{
+	struct rtl_priv *rtlpriv = btcoexist->adapter;
+	u8 i, rsp_source = 0;
+	bool wifi_connected = false;
+	bool wifi_scan = false, wifi_link = false, wifi_roam = false,
+		wifi_busy = false;
+	static bool is_scoreboard_scan;
+	const u16 type_is_scan = BT_8822B_1ANT_SCBD_SCAN;
+
+	rsp_source = tmp_buf[0] & 0xf;
+	if (rsp_source >= BT_INFO_SRC_8822B_1ANT_MAX)
+		rsp_source = BT_INFO_SRC_8822B_1ANT_WIFI_FW;
+	coex_sta->bt_info_c2h_cnt[rsp_source]++;
+
+	RT_TRACE(rtlpriv, COMP_BT_COEXIST, DBG_LOUD,
+		 "[BTCoex], Bt_info[%d], len=%d, data=[", rsp_source,
+		 length);
+
+	if (rsp_source == BT_INFO_SRC_8822B_1ANT_BT_RSP ||
+	    rsp_source == BT_INFO_SRC_8822B_1ANT_BT_ACTIVE_SEND) {
+		if (coex_sta->bt_disabled) {
+			coex_sta->bt_disabled = false;
+			coex_sta->is_bt_reenable = true;
+			coex_sta->cnt_bt_reenable = 15;
+
+			RT_TRACE(rtlpriv, COMP_BT_COEXIST, DBG_LOUD,
+				 "[BTCoex], BT enable detected by bt_info\n");
+		}
+	}
+
+	for (i = 0; i < length; i++) {
+		coex_sta->bt_info_c2h[rsp_source][i] = tmp_buf[i];
+
+		if (i == length - 1) {
+			/* last one */
+			RT_TRACE(rtlpriv, COMP_BT_COEXIST, DBG_LOUD,
+				 "0x%02x]\n",
+				 tmp_buf[i]);
+		} else {
+			/* normal */
+			RT_TRACE(rtlpriv, COMP_BT_COEXIST, DBG_LOUD,
+				 "0x%02x, ",
+				 tmp_buf[i]);
+		}
+	}
+
+	coex_sta->bt_info = coex_sta->bt_info_c2h[rsp_source][1];
+	coex_sta->bt_info_ext = coex_sta->bt_info_c2h[rsp_source][4];
+	coex_sta->bt_info_ext2 = coex_sta->bt_info_c2h[rsp_source][5];
+
+	if (rsp_source != BT_INFO_SRC_8822B_1ANT_WIFI_FW) {
+		/* if 0xff, it means BT is under WHCK test */
+		coex_sta->bt_whck_test =
+			((coex_sta->bt_info == 0xff) ? true : false);
+
+		coex_sta->bt_create_connection =
+			((coex_sta->bt_info_c2h[rsp_source][2] & 0x80) ? true :
+									 false);
+
+		/* unit: %, value-100 to translate to unit: dBm */
+		coex_sta->bt_rssi =
+			coex_sta->bt_info_c2h[rsp_source][3] * 2 + 10;
+
+		coex_sta->c2h_bt_remote_name_req =
+			((coex_sta->bt_info_c2h[rsp_source][2] & 0x20) ? true :
+									 false);
+
+		coex_sta->is_A2DP_3M =
+			((coex_sta->bt_info_c2h[rsp_source][2] & 0x10) ? true :
+									 false);
+
+		coex_sta->acl_busy =
+			((coex_sta->bt_info_c2h[rsp_source][1] & 0x8) ? true :
+									false);
+
+		coex_sta->voice_over_HOGP =
+			((coex_sta->bt_info_ext & 0x10) ? true : false);
+
+		coex_sta->c2h_bt_inquiry_page =
+			((coex_sta->bt_info & BT_INFO_8822B_1ANT_B_INQ_PAGE) ?
+				 true :
+				 false);
+
+		coex_sta->a2dp_bit_pool =
+			(((coex_sta->bt_info_c2h[rsp_source][1] & 0x49) ==
+			  0x49) ?
+				 (coex_sta->bt_info_c2h[rsp_source][6] & 0x7f) :
+				 0);
+
+		coex_sta->is_bt_a2dp_sink =
+			(coex_sta->bt_info_c2h[rsp_source][6] & 0x80) ? true :
+									false;
+
+		coex_sta->bt_retry_cnt =
+			coex_sta->bt_info_c2h[rsp_source][2] & 0xf;
+
+		coex_sta->is_autoslot = coex_sta->bt_info_ext2 & 0x8;
+
+		coex_sta->forbidden_slot = coex_sta->bt_info_ext2 & 0x7;
+
+		coex_sta->hid_busy_num = (coex_sta->bt_info_ext2 & 0x30) >> 4;
+
+		coex_sta->hid_pair_cnt = (coex_sta->bt_info_ext2 & 0xc0) >> 6;
+
+		coex_sta->is_bt_opp_exist =
+			(coex_sta->bt_info_ext2 & 0x1) ? true : false;
+
+		if (coex_sta->bt_retry_cnt >= 1)
+			coex_sta->pop_event_cnt++;
+
+		if (coex_sta->c2h_bt_remote_name_req)
+			coex_sta->cnt_remote_name_req++;
+
+		if (coex_sta->bt_info_ext & BIT(1))
+			coex_sta->cnt_reinit++;
+
+		if (coex_sta->bt_info_ext & BIT(2)) {
+			coex_sta->cnt_setup_link++;
+			coex_sta->is_setup_link = true;
+
+			if (coex_sta->is_bt_reenable)
+				coex_sta->bt_relink_downcount = 8;
+			else
+				coex_sta->bt_relink_downcount = 2;
+			RT_TRACE(rtlpriv, COMP_BT_COEXIST, DBG_LOUD,
+				 "[BTCoex], Re-Link start in BT info!!\n");
+		}
+
+		if (coex_sta->bt_info_ext & BIT(3))
+			coex_sta->cnt_ign_wlan_act++;
+
+		if (coex_sta->bt_info_ext & BIT(6))
+			coex_sta->cnt_role_switch++;
+
+		if (coex_sta->bt_info_ext & BIT(7))
+			coex_sta->is_bt_multi_link = true;
+		else
+			coex_sta->is_bt_multi_link = false;
+
+		if (coex_sta->bt_info_ext & BIT(0))
+			coex_sta->is_hid_rcu = true;
+		else
+			coex_sta->is_hid_rcu = false;
+
+		if (coex_sta->bt_info_ext & BIT(5))
+			coex_sta->is_ble_scan_toggle = true;
+		else
+			coex_sta->is_ble_scan_toggle = false;
+
+		if (coex_sta->bt_create_connection) {
+			coex_sta->cnt_page++;
+
+			btcoexist->btc_get(btcoexist, BTC_GET_BL_WIFI_BUSY,
+					   &wifi_busy);
+			btcoexist->btc_get(btcoexist, BTC_GET_BL_WIFI_SCAN,
+					   &wifi_scan);
+			btcoexist->btc_get(btcoexist, BTC_GET_BL_WIFI_LINK,
+					   &wifi_link);
+			btcoexist->btc_get(btcoexist, BTC_GET_BL_WIFI_ROAM,
+					   &wifi_roam);
+
+			if (wifi_link || wifi_roam || wifi_scan ||
+			    coex_sta->wifi_is_high_pri_task || wifi_busy) {
+				is_scoreboard_scan = true;
+				halbtc8822b1ant_post_state_to_bt(btcoexist,
+								 type_is_scan,
+								 true);
+
+			} else {
+				halbtc8822b1ant_post_state_to_bt(btcoexist,
+								 type_is_scan,
+								 false);
+			}
+		} else {
+			if (is_scoreboard_scan) {
+				halbtc8822b1ant_post_state_to_bt(btcoexist,
+								 type_is_scan,
+								 false);
+				is_scoreboard_scan = false;
+			}
+		}
+
+		/* Here we need to resend some wifi info to BT */
+		/* because bt is reset and loss of the info. */
+
+		if (!btcoexist->manual_control &&
+		    !btcoexist->stop_coex_dm) {
+			btcoexist->btc_get(btcoexist, BTC_GET_BL_WIFI_CONNECTED,
+					   &wifi_connected);
+
+			/*  Re-Init */
+			if ((coex_sta->bt_info_ext & BIT(1))) {
+				u8 type;
+
+				RT_TRACE(rtlpriv, COMP_BT_COEXIST, DBG_LOUD,
+					 "[BTCoex], BT ext info bit1 check, send wifi BW&Chnl to BT!!\n");
+				if (wifi_connected)
+					type = BTC_MEDIA_CONNECT;
+				else
+					type = BTC_MEDIA_DISCONNECT;
+				halbtc8822b1ant_update_wifi_ch_info(btcoexist,
+								    type);
+			}
+
+			/*	If Ignore_WLanAct && not SetUp_Link */
+			if ((coex_sta->bt_info_ext & BIT(3)) &&
+			    (!(coex_sta->bt_info_ext & BIT(2)))) {
+				RT_TRACE(rtlpriv, COMP_BT_COEXIST, DBG_LOUD,
+					 "[BTCoex], BT ext info bit3 check, set BT NOT to ignore Wlan active!!\n");
+				halbtc8822b1ant_ignore_wlan_act(btcoexist,
+								FORCE_EXEC,
+								false);
+			}
+		}
+	}
+
+	halbtc8822b1ant_update_bt_link_info(btcoexist);
+
+	halbtc8822b1ant_run_coexist_mechanism(btcoexist);
+}
+
+void ex_btc8822b1ant_wl_fwdbginfo_notify(struct btc_coexist *btcoexist,
+					 u8 *tmp_buf, u8 length)
+{
+	struct rtl_priv *rtlpriv = btcoexist->adapter;
+	u8 i = 0;
+	static u8 tmp_buf_pre[10] = {0, 0, 0, 0, 0, 0, 0, 0, 0, 0};
+
+	RT_TRACE(rtlpriv, COMP_BT_COEXIST, DBG_LOUD,
+		 "[BTCoex], WiFi Fw Dbg info = %d %d %d %d %d %d (len = %d)\n",
+		 tmp_buf[0], tmp_buf[1], tmp_buf[2], tmp_buf[3], tmp_buf[4],
+		 tmp_buf[5], length);
+
+	if (tmp_buf[0] == 0x8) {
+		for (i = 1; i <= 5; i++) {
+			coex_sta->wl_fw_dbg_info[i] =
+				(tmp_buf[i] >= tmp_buf_pre[i]) ?
+					(tmp_buf[i] - tmp_buf_pre[i]) :
+					(255 - tmp_buf_pre[i] + tmp_buf[i]);
+
+			tmp_buf_pre[i] = tmp_buf[i];
+		}
+	}
+}
+
+void ex_btc8822b1ant_rx_rate_change_notify(struct btc_coexist *btcoexist,
+					   bool is_data_frame,
+					   u8 btc_rate_id)
+{
+	struct rtl_priv *rtlpriv = btcoexist->adapter;
+	bool wifi_connected = false;
+
+	btcoexist->btc_get(btcoexist, BTC_GET_BL_WIFI_CONNECTED,
+			   &wifi_connected);
+
+	if (is_data_frame) {
+		coex_sta->wl_rx_rate = btc_rate_id;
+
+		RT_TRACE(rtlpriv, COMP_BT_COEXIST, DBG_LOUD,
+			 "[BTCoex], rx_rate_change_notify data rate id = %d, RTS_Rate = %d\n",
+			 coex_sta->wl_rx_rate, coex_sta->wl_rts_rx_rate);
+	} else {
+		coex_sta->wl_rts_rx_rate = btc_rate_id;
+
+		RT_TRACE(rtlpriv, COMP_BT_COEXIST, DBG_LOUD,
+			 "[BTCoex], rts_rate_change_notify RTS rate id = %d, RTS_Rate = %d\n",
+			 coex_sta->wl_rts_rx_rate, coex_sta->wl_rts_rx_rate);
+	}
+
+	if (wifi_connected &&
+	    (coex_dm->bt_status == BT_8822B_1ANT_BT_STATUS_ACL_BUSY ||
+	     coex_dm->bt_status == BT_8822B_1ANT_BT_STATUS_ACL_SCO_BUSY ||
+	     coex_dm->bt_status == BT_8822B_1ANT_BT_STATUS_SCO_BUSY)) {
+		if (coex_sta->wl_rx_rate == BTC_CCK_5_5 ||
+		    coex_sta->wl_rx_rate == BTC_OFDM_6 ||
+		    coex_sta->wl_rx_rate == BTC_MCS_0) {
+			coex_sta->cck_lock_warn = true;
+
+			RT_TRACE(rtlpriv, COMP_BT_COEXIST, DBG_LOUD,
+				 "[BTCoex], cck lock warning...\n");
+		} else if ((coex_sta->wl_rx_rate == BTC_CCK_1) ||
+			   (coex_sta->wl_rx_rate == BTC_CCK_2) ||
+			   (coex_sta->wl_rts_rx_rate == BTC_CCK_1) ||
+			   (coex_sta->wl_rts_rx_rate == BTC_CCK_2)) {
+			coex_sta->cck_lock = true;
+
+			RT_TRACE(rtlpriv, COMP_BT_COEXIST, DBG_LOUD,
+				 "[BTCoex], cck locking...\n");
+		} else {
+			coex_sta->cck_lock_warn = false;
+			coex_sta->cck_lock = false;
+
+			RT_TRACE(rtlpriv, COMP_BT_COEXIST, DBG_LOUD,
+				 "[BTCoex], cck unlock...\n");
+		}
+	} else {
+		if (coex_dm->bt_status ==
+		     BT_8822B_1ANT_BT_STATUS_CONNECTED_IDLE ||
+		    coex_dm->bt_status ==
+		     BT_8822B_1ANT_BT_STATUS_NCONNECTED_IDLE) {
+			coex_sta->cck_lock_warn = false;
+			coex_sta->cck_lock = false;
+		}
+	}
+}
+
+void ex_btc8822b1ant_rf_status_notify(struct btc_coexist *btcoexist, u8 type)
+{
+	struct rtl_priv *rtlpriv = btcoexist->adapter;
+
+	RT_TRACE(rtlpriv, COMP_BT_COEXIST, DBG_LOUD,
+		 "[BTCoex], RF Status notify\n");
+
+	if (type == BTC_RF_ON) {
+		RT_TRACE(rtlpriv, COMP_BT_COEXIST, DBG_LOUD,
+			 "[BTCoex], RF is turned ON!!\n");
+		btcoexist->stop_coex_dm = false;
+		coex_sta->is_rf_state_off = false;
+
+	} else if (type == BTC_RF_OFF) {
+		RT_TRACE(rtlpriv, COMP_BT_COEXIST, DBG_LOUD,
+			 "[BTCoex], RF is turned OFF!!\n");
+
+		halbtc8822b1ant_post_state_to_bt(btcoexist,
+						 BT_8822B_1ANT_SCBD_ACTIVE |
+						 BT_8822B_1ANT_SCBD_ONOFF |
+						 BT_8822B_1ANT_SCBD_SCAN |
+						 BT_8822B_1ANT_SCBD_UNDERTEST,
+						 false);
+
+		halbtc8822b1ant_ps_tdma(btcoexist, FORCE_EXEC, false, 0);
+
+		halbtc8822b1ant_set_ant_path(btcoexist, BTC_ANT_PATH_AUTO,
+					     FORCE_EXEC,
+					     BT_8822B_1ANT_PHASE_WOFF);
+		/* for test : s3 bt disppear , fail rate 1/600*/
+
+		halbtc8822b1ant_ignore_wlan_act(btcoexist, FORCE_EXEC, true);
+
+		btcoexist->stop_coex_dm = true;
+		coex_sta->is_rf_state_off = true;
+	}
+}
+
+void ex_btc8822b1ant_halt_notify(struct btc_coexist *btcoexist)
+{
+	struct rtl_priv *rtlpriv = btcoexist->adapter;
+
+	RT_TRACE(rtlpriv, COMP_BT_COEXIST, DBG_LOUD,
+		 "[BTCoex], Halt notify\n");
+
+	halbtc8822b1ant_post_state_to_bt(btcoexist,
+					 BT_8822B_1ANT_SCBD_ACTIVE |
+					 BT_8822B_1ANT_SCBD_ONOFF |
+					 BT_8822B_1ANT_SCBD_SCAN |
+					 BT_8822B_1ANT_SCBD_UNDERTEST |
+					 BT_8822B_1ANT_SCBD_RXGAIN,
+					 false);
+
+	halbtc8822b1ant_set_ant_path(btcoexist, BTC_ANT_PATH_AUTO, FORCE_EXEC,
+				     BT_8822B_1ANT_PHASE_WOFF);
+
+	halbtc8822b1ant_ignore_wlan_act(btcoexist, FORCE_EXEC, true);
+
+	ex_btc8822b1ant_media_status_notify(btcoexist, BTC_MEDIA_DISCONNECT);
+
+	halbtc8822b1ant_ps_tdma(btcoexist, FORCE_EXEC, false, 0);
+
+	btcoexist->stop_coex_dm = true;
+}
+
+void ex_btc8822b1ant_pnp_notify(struct btc_coexist *btcoexist, u8 pnp_state)
+{
+	struct rtl_priv *rtlpriv = btcoexist->adapter;
+	bool wifi_under_5g = false;
+
+	RT_TRACE(rtlpriv, COMP_BT_COEXIST, DBG_LOUD, "[BTCoex], Pnp notify\n");
+
+	btcoexist->btc_get(btcoexist, BTC_GET_BL_WIFI_UNDER_5G, &wifi_under_5g);
+
+	if (pnp_state == BTC_WIFI_PNP_SLEEP ||
+	    pnp_state == BTC_WIFI_PNP_SLEEP_KEEP_ANT) {
+		u8 phase;
+
+		RT_TRACE(rtlpriv, COMP_BT_COEXIST, DBG_LOUD,
+			 "[BTCoex], Pnp notify to SLEEP\n");
+
+		halbtc8822b1ant_post_state_to_bt(btcoexist,
+						 BT_8822B_1ANT_SCBD_ACTIVE |
+						 BT_8822B_1ANT_SCBD_ONOFF |
+						 BT_8822B_1ANT_SCBD_SCAN |
+						 BT_8822B_1ANT_SCBD_UNDERTEST |
+						 BT_8822B_1ANT_SCBD_RXGAIN,
+						 false);
+
+		if (pnp_state == BTC_WIFI_PNP_SLEEP_KEEP_ANT) {
+			if (wifi_under_5g)
+				phase = BT_8822B_1ANT_PHASE_5G;
+			else
+				phase = BT_8822B_1ANT_PHASE_2G;
+		} else {
+			phase = BT_8822B_1ANT_PHASE_WOFF;
+		}
+		halbtc8822b1ant_set_ant_path(btcoexist, BTC_ANT_PATH_AUTO,
+					     FORCE_EXEC, phase);
+
+		btcoexist->stop_coex_dm = true;
+	} else if (pnp_state == BTC_WIFI_PNP_WAKE_UP) {
+		RT_TRACE(rtlpriv, COMP_BT_COEXIST, DBG_LOUD,
+			 "[BTCoex], Pnp notify to WAKE UP\n");
+	}
+}
+
+void ex_btc8822b1ant_coex_dm_reset(struct btc_coexist *btcoexist)
+{
+	struct rtl_priv *rtlpriv = btcoexist->adapter;
+
+	RT_TRACE(rtlpriv, COMP_BT_COEXIST, DBG_LOUD,
+		 "[BTCoex], *****************Coex DM Reset*****************\n");
+
+	halbtc8822b1ant_init_hw_config(btcoexist, false, false);
+	halbtc8822b1ant_init_coex_dm(btcoexist);
+}
+
+void ex_btc8822b1ant_periodical(struct btc_coexist *btcoexist)
+{
+	struct rtl_priv *rtlpriv = btcoexist->adapter;
+	bool bt_relink_finish = false;
+
+	RT_TRACE(rtlpriv, COMP_BT_COEXIST, DBG_LOUD,
+		 "[BTCoex], ==========================Periodical===========================\n");
+
+	if (!btcoexist->auto_report_1ant)
+		halbtc8822b1ant_query_bt_info(btcoexist);
+
+	halbtc8822b1ant_monitor_bt_ctr(btcoexist);
+	halbtc8822b1ant_monitor_wifi_ctr(btcoexist);
+
+	halbtc8822b1ant_monitor_bt_enable_disable(btcoexist);
+
+	if (coex_sta->bt_relink_downcount != 0) {
+		coex_sta->bt_relink_downcount--;
+
+		if (coex_sta->bt_relink_downcount == 0) {
+			coex_sta->is_setup_link = false;
+			bt_relink_finish = true;
+		}
+	}
+
+	/* for 4-way, DHCP, EAPOL packet */
+	if (coex_sta->specific_pkt_period_cnt > 0) {
+		coex_sta->specific_pkt_period_cnt--;
+
+		if (coex_sta->specific_pkt_period_cnt == 0 &&
+		    coex_sta->wifi_is_high_pri_task)
+			coex_sta->wifi_is_high_pri_task = false;
+
+		RT_TRACE(rtlpriv, COMP_BT_COEXIST, DBG_LOUD,
+			 "[BTCoex], ***************** Hi-Pri Task = %s*****************\n",
+			 (coex_sta->wifi_is_high_pri_task ? "Yes" : "No"));
+	}
+
+	/*for A2DP glitch during connecting AP*/
+	if (coex_sta->connect_ap_period_cnt > 0)
+		coex_sta->connect_ap_period_cnt--;
+
+	if (coex_sta->cnt_bt_reenable > 0) {
+		coex_sta->cnt_bt_reenable--;
+		if (coex_sta->cnt_bt_reenable == 0) {
+			coex_sta->is_bt_reenable = false;
+
+			RT_TRACE(rtlpriv, COMP_BT_COEXIST, DBG_LOUD,
+				 "[BTCoex], BT renable 30s finish!!\n");
+		}
+	}
+
+	if (halbtc8822b1ant_is_wifibt_status_changed(btcoexist) ||
+	    bt_relink_finish || coex_sta->is_set_ps_state_fail)
+		halbtc8822b1ant_run_coexist_mechanism(btcoexist);
+}
+
+void ex_btc8822b1ant_antenna_detection(struct btc_coexist *btcoexist,
+				       u32 cent_freq, u32 offset, u32 span,
+				       u32 seconds)
+{
+}
+
+void ex_btc8822b1ant_antenna_isolation(struct btc_coexist *btcoexist,
+				       u32 cent_freq, u32 offset, u32 span,
+				       u32 seconds)
+{
+}
+
+void ex_btc8822b1ant_psd_scan(struct btc_coexist *btcoexist, u32 cent_freq,
+			      u32 offset, u32 span, u32 seconds)
+{
+}
+
+void ex_btc8822b1ant_display_ant_detection(struct btc_coexist *btcoexist) {}
+
+void ex_btc8822b1ant_dbg_control(struct btc_coexist *btcoexist, u8 op_code,
+				 u8 op_len, u8 *pdata)
+{
+}
diff --git a/drivers/net/wireless/realtek/rtlwifi/btcoexist/halbtc8822b1ant.h b/drivers/net/wireless/realtek/rtlwifi/btcoexist/halbtc8822b1ant.h
new file mode 100644
index 000000000000..49955f5aeb38
--- /dev/null
+++ b/drivers/net/wireless/realtek/rtlwifi/btcoexist/halbtc8822b1ant.h
@@ -0,0 +1,413 @@
+/******************************************************************************
+ *
+ * Copyright(c) 2016 - 2017 Realtek Corporation.
+ *
+ * This program is free software; you can redistribute it and/or modify it
+ * under the terms of version 2 of the GNU General Public License as
+ * published by the Free Software Foundation.
+ *
+ * This program is distributed in the hope that it will be useful, but WITHOUT
+ * ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or
+ * FITNESS FOR A PARTICULAR PURPOSE. See the GNU General Public License for
+ * more details.
+ *
+ *****************************************************************************/
+
+/* *******************************************
+ * The following is for 8822B 1ANT BT Co-exist definition
+ * ********************************************/
+#define BT_INFO_8822B_1ANT_B_FTP	BIT(7)
+#define BT_INFO_8822B_1ANT_B_A2DP	BIT(6)
+#define BT_INFO_8822B_1ANT_B_HID	BIT(5)
+#define BT_INFO_8822B_1ANT_B_SCO_BUSY	BIT(4)
+#define BT_INFO_8822B_1ANT_B_ACL_BUSY	BIT(3)
+#define BT_INFO_8822B_1ANT_B_INQ_PAGE	BIT(2)
+#define BT_INFO_8822B_1ANT_B_SCO_ESCO	BIT(1)
+#define BT_INFO_8822B_1ANT_B_CONNECTION	BIT(0)
+
+#define BTC_RSSI_COEX_THRESH_TOL_8822B_1ANT	2
+
+#define BT_8822B_1ANT_WIFI_NOISY_THRESH	150 /* max: 255 */
+#define BT_8822B_1ANT_DEFAULT_ISOLATION	15 /*  unit: dB */
+
+enum bt_8822b_1ant_signal_state {
+	BT_8822B_1ANT_SIG_STA_SET_TO_LOW	= 0x0,
+	BT_8822B_1ANT_SIG_STA_SET_BY_HW		= 0x0,
+	BT_8822B_1ANT_SIG_STA_SET_TO_HIGH	= 0x1,
+	BT_8822B_1ANT_SIG_STA_MAX
+};
+
+enum bt_8822b_1ant_path_ctrl_owner {
+	BT_8822B_1ANT_PCO_BTSIDE	= 0x0,
+	BT_8822B_1ANT_PCO_WLSIDE	= 0x1,
+	BT_8822B_1ANT_PCO_MAX
+};
+
+enum bt_8822b_1ant_gnt_ctrl_type {
+	BT_8822B_1ANT_GNT_CTRL_BY_PTA	= 0x0,
+	BT_8822B_1ANT_GNT_CTRL_BY_SW	= 0x1,
+	BT_8822B_1ANT_GNT_CTRL_MAX
+};
+
+enum bt_8822b_1ant_gnt_ctrl_block {
+	BT_8822B_1ANT_GNT_BLOCK_RFC_BB	= 0x0,
+	BT_8822B_1ANT_GNT_BLOCK_RFC	= 0x1,
+	BT_8822B_1ANT_GNT_BLOCK_BB	= 0x2,
+	BT_8822B_1ANT_GNT_BLOCK_MAX
+};
+
+enum bt_8822b_1ant_lte_coex_table_type {
+	BT_8822B_1ANT_CTT_WL_VS_LTE	= 0x0,
+	BT_8822B_1ANT_CTT_BT_VS_LTE	= 0x1,
+	BT_8822B_1ANT_CTT_MAX
+};
+
+enum bt_8822b_1ant_lte_break_table_type {
+	BT_8822B_1ANT_LBTT_WL_BREAK_LTE	= 0x0,
+	BT_8822B_1ANT_LBTT_BT_BREAK_LTE	= 0x1,
+	BT_8822B_1ANT_LBTT_LTE_BREAK_WL	= 0x2,
+	BT_8822B_1ANT_LBTT_LTE_BREAK_BT	= 0x3,
+	BT_8822B_1ANT_LBTT_MAX
+};
+
+enum bt_info_src_8822b_1ant {
+	BT_INFO_SRC_8822B_1ANT_WIFI_FW		= 0x0,
+	BT_INFO_SRC_8822B_1ANT_BT_RSP		= 0x1,
+	BT_INFO_SRC_8822B_1ANT_BT_ACTIVE_SEND	= 0x2,
+	BT_INFO_SRC_8822B_1ANT_MAX
+};
+
+enum bt_8822b_1ant_bt_status {
+	BT_8822B_1ANT_BT_STATUS_NCONNECTED_IDLE	= 0x0,
+	BT_8822B_1ANT_BT_STATUS_CONNECTED_IDLE		= 0x1,
+	BT_8822B_1ANT_BT_STATUS_INQ_PAGE		= 0x2,
+	BT_8822B_1ANT_BT_STATUS_ACL_BUSY		= 0x3,
+	BT_8822B_1ANT_BT_STATUS_SCO_BUSY		= 0x4,
+	BT_8822B_1ANT_BT_STATUS_ACL_SCO_BUSY		= 0x5,
+	BT_8822B_1ANT_BT_STATUS_MAX
+};
+
+enum bt_8822b_1ant_wifi_status {
+	BT_8822B_1ANT_WIFI_STATUS_NCONNECTED_IDLE		= 0x0,
+	BT_8822B_1ANT_WIFI_STATUS_NCONNECTED_SCAN	= 0x1,
+	BT_8822B_1ANT_WIFI_STATUS_CONNECTED_SCAN		= 0x2,
+	BT_8822B_1ANT_WIFI_STATUS_CONNECTED_SPECIFIC_PKT	= 0x3,
+	BT_8822B_1ANT_WIFI_STATUS_CONNECTED_IDLE		= 0x4,
+	BT_8822B_1ANT_WIFI_STATUS_CONNECTED_BUSY		= 0x5,
+	BT_8822B_1ANT_WIFI_STATUS_MAX
+};
+
+enum bt_8822b_1ant_coex_algo {
+	BT_8822B_1ANT_COEX_UNDEFINED		= 0x0,
+	BT_8822B_1ANT_COEX_SCO			= 0x1,
+	BT_8822B_1ANT_COEX_HID			= 0x2,
+	BT_8822B_1ANT_COEX_A2DP			= 0x3,
+	BT_8822B_1ANT_COEX_A2DP_PANHS		= 0x4,
+	BT_8822B_1ANT_COEX_PAN			= 0x5,
+	BT_8822B_1ANT_COEX_PANHS		= 0x6,
+	BT_8822B_1ANT_COEX_PAN_A2DP		= 0x7,
+	BT_8822B_1ANT_COEX_PAN_HID		= 0x8,
+	BT_8822B_1ANT_COEX_HID_A2DP_PAN		= 0x9,
+	BT_8822B_1ANT_COEX_HID_A2DP		= 0xa,
+	BT_8822B_1ANT_COEX_NOPROFILEBUSY	= 0xb,
+	BT_8822B_1ANT_COEX_A2DPSINK		= 0xc,
+	BT_8822B_1ANT_COEX_MAX
+};
+
+enum bt_8822b_1ant_ext_ant_switch_type {
+	BT_8822B_1ANT_SWITCH_USE_SPDT	= 0x0,
+	BT_8822B_1ANT_SWITCH_USE_SP3T	= 0x1,
+	BT_8822B_1ANT_SWITCH_MAX
+};
+
+enum bt_8822b_1ant_ext_ant_switch_ctrl_type {
+	BT_8822B_1ANT_SWITCH_CTRL_BY_BBSW	= 0x0,
+	BT_8822B_1ANT_SWITCH_CTRL_BY_PTA	= 0x1,
+	BT_8822B_1ANT_SWITCH_CTRL_BY_ANTDIV	= 0x2,
+	BT_8822B_1ANT_SWITCH_CTRL_BY_MAC	= 0x3,
+	BT_8822B_1ANT_SWITCH_CTRL_BY_BT		= 0x4,
+	BT_8822B_1ANT_SWITCH_CTRL_MAX
+};
+
+enum bt_8822b_1ant_ext_ant_switch_pos_type {
+	BT_8822B_1ANT_SWITCH_TO_BT		= 0x0,
+	BT_8822B_1ANT_SWITCH_TO_WLG		= 0x1,
+	BT_8822B_1ANT_SWITCH_TO_WLA		= 0x2,
+	BT_8822B_1ANT_SWITCH_TO_NOCARE		= 0x3,
+	BT_8822B_1ANT_SWITCH_TO_S0WLG_S1BT	= 0x4,
+	BT_8822B_1ANT_SWITCH_TO_MAX
+};
+
+enum bt_8822b_1ant_phase {
+	BT_8822B_1ANT_PHASE_INIT		= 0x0,
+	BT_8822B_1ANT_PHASE_WONLY		= 0x1,
+	BT_8822B_1ANT_PHASE_WOFF		= 0x2,
+	BT_8822B_1ANT_PHASE_2G			= 0x3,
+	BT_8822B_1ANT_PHASE_5G			= 0x4,
+	BT_8822B_1ANT_PHASE_BTMP		= 0x5,
+	BT_8822B_1ANT_PHASE_POWERON		= 0x6,
+	BT_8822B_1ANT_PHASE_2G_WL		= 0x7,
+	BT_8822B_1ANT_PHASE_2G_BT		= 0x8,
+	BT_8822B_1ANT_PHASE_MCC			= 0x9,
+	BT_8822B_1ANT_PHASE_2G_WLBT		= 0xa,
+	BT_8822B_1ANT_PHASE_MAX
+};
+
+/*ADD SCOREBOARD TO FIX BT LPS 32K ISSUE WHILE WL BUSY*/
+enum bt_8822b_1ant_scoreboard {
+	BT_8822B_1ANT_SCBD_ACTIVE		= BIT(0),
+	BT_8822B_1ANT_SCBD_ONOFF		= BIT(1),
+	BT_8822B_1ANT_SCBD_SCAN			= BIT(2),
+	BT_8822B_1ANT_SCBD_UNDERTEST		= BIT(3),
+	BT_8822B_1ANT_SCBD_RXGAIN		= BIT(4),
+	BT_8822B_1ANT_SCBD_WLBUSY		= BIT(6),
+	BT_8822B_1ANT_SCBD_EXTFEM		= BIT(8),
+	BT_8822B_1ANT_SCBD_CQDDR		= BIT(10)
+};
+
+struct coex_dm_8822b_1ant {
+	/* hw setting */
+	u32	pre_ant_pos_type;
+	u32	cur_ant_pos_type;
+	/* fw mechanism */
+	bool cur_ignore_wlan_act;
+	bool pre_ignore_wlan_act;
+	u8	pre_ps_tdma;
+	u8	cur_ps_tdma;
+	u8	ps_tdma_para[5];
+	u8	ps_tdma_du_adj_type;
+	bool auto_tdma_adjust;
+	bool pre_ps_tdma_on;
+	bool cur_ps_tdma_on;
+	bool pre_bt_auto_report;
+	bool cur_bt_auto_report;
+	u8	pre_lps;
+	u8	cur_lps;
+	u8	pre_rpwm;
+	u8	cur_rpwm;
+	u8	pre_bt_dec_pwr_lvl;
+	u8	cur_bt_dec_pwr_lvl;
+	u8	pre_fw_dac_swing_lvl;
+	u8	cur_fw_dac_swing_lvl;
+
+	/* sw mechanism */
+	bool pre_low_penalty_ra;
+	bool cur_low_penalty_ra;
+	u32	pre_val0x6c0;
+	u32	cur_val0x6c0;
+	u32	pre_val0x6c4;
+	u32	cur_val0x6c4;
+	u32	pre_val0x6c8;
+	u32	cur_val0x6c8;
+	u8	pre_val0x6cc;
+	u8	cur_val0x6cc;
+
+	/* algorithm related */
+	u8	pre_algorithm;
+	u8	cur_algorithm;
+	u8	bt_status;
+	u8	wifi_chnl_info[3];
+
+	u32	arp_cnt;
+
+	u32	pre_ext_ant_switch_status;
+	u32	cur_ext_ant_switch_status;
+
+	bool pre_agc_table_en;
+	bool cur_agc_table_en;
+};
+
+struct coex_sta_8822b_1ant {
+	bool bt_disabled;
+	bool bt_link_exist;
+	bool sco_exist;
+	bool a2dp_exist;
+	bool hid_exist;
+	bool pan_exist;
+	bool msft_mr_exist;
+	u8	num_of_profile;
+
+	bool under_lps;
+	bool under_ips;
+	u32	specific_pkt_period_cnt;
+	u32	high_priority_tx;
+	u32	high_priority_rx;
+	u32	low_priority_tx;
+	u32	low_priority_rx;
+	bool is_hi_pri_rx_overhead;
+	s8	bt_rssi;
+	u8	pre_bt_rssi_state;
+	u8	pre_wifi_rssi_state[4];
+	u8	bt_info_c2h[BT_INFO_SRC_8822B_1ANT_MAX][10];
+	u32	bt_info_c2h_cnt[BT_INFO_SRC_8822B_1ANT_MAX];
+	bool bt_whck_test;
+	bool c2h_bt_inquiry_page;
+	bool c2h_bt_remote_name_req;
+	bool c2h_bt_page; /* Add for win8.1 page out issue */
+	bool wifi_is_high_pri_task; /* Add for win8.1 page out issue */
+
+	u8	bt_info_ext;
+	u8	bt_info_ext2;
+	u32	pop_event_cnt;
+	u8	scan_ap_num;
+	u8	bt_retry_cnt;
+
+	u32	crc_ok_cck;
+	u32	crc_ok_11g;
+	u32	crc_ok_11n;
+	u32	crc_ok_11n_vht;
+
+	u32	crc_err_cck;
+	u32	crc_err_11g;
+	u32	crc_err_11n;
+	u32	crc_err_11n_vht;
+
+	bool cck_lock;
+	bool cck_lock_ever;
+	bool cck_lock_warn;
+
+	u8	coex_table_type;
+
+	bool force_lps_ctrl;
+
+	bool concurrent_rx_mode_on;
+
+	u16	score_board;
+	u8	isolation_btween_wb; /* 0~ 50 */
+
+	u8	a2dp_bit_pool;
+	u8	cut_version;
+	bool acl_busy;
+	bool bt_create_connection;
+
+	u32	bt_coex_supported_feature;
+	u32	bt_coex_supported_version;
+
+	u8	bt_ble_scan_type;
+	u32	bt_ble_scan_para[3];
+
+	bool run_time_state;
+	bool freeze_coexrun_by_btinfo;
+
+	bool is_A2DP_3M;
+	bool voice_over_HOGP;
+	u8	bt_info;
+	bool is_autoslot;
+	u8	forbidden_slot;
+	u8	hid_busy_num;
+	u8	hid_pair_cnt;
+
+	u32	cnt_remote_name_req;
+	u32	cnt_setup_link;
+	u32	cnt_reinit;
+	u32	cnt_ign_wlan_act;
+	u32	cnt_page;
+	u32	cnt_role_switch;
+
+	u16	bt_reg_vendor_ac;
+	u16	bt_reg_vendor_ae;
+
+	bool is_setup_link;
+	u8	wl_noisy_level;
+	u32	gnt_error_cnt;
+	u8	bt_afh_map[10];
+	u8	bt_relink_downcount;
+	bool is_tdma_btautoslot;
+	bool is_tdma_btautoslot_hang;
+
+	u8	switch_band_notify_to;
+	bool is_rf_state_off;
+
+	bool is_hid_low_pri_tx_overhead;
+	bool is_bt_multi_link;
+	bool is_bt_a2dp_sink;
+
+	bool is_set_ps_state_fail;
+	u8	cnt_set_ps_state_fail;
+
+	u8	wl_fw_dbg_info[10];
+	u8	wl_rx_rate;
+	u8	wl_rts_rx_rate;
+	u8	wl_center_channel;
+
+	u16	score_board_WB;
+	bool is_hid_rcu;
+	u16	legacy_forbidden_slot;
+	u16	le_forbidden_slot;
+	u8	bt_a2dp_vendor_id;
+	u32	bt_a2dp_device_name;
+	bool is_ble_scan_toggle;
+
+	bool is_bt_opp_exist;
+	bool gl_wifi_busy;
+
+	bool is_mimo_ps;
+	u8	connect_ap_period_cnt;
+	bool is_bt_reenable;
+	u8	cnt_bt_reenable;
+};
+
+struct rfe_type_8822b_1ant {
+	u8	rfe_module_type;
+	bool ext_ant_switch_exist;
+	u8	ext_ant_switch_type;
+	/*  iF 0: ANTSW(rfe_sel9)=0, ANTSWB(rfe_sel8)=1 =>  Ant to BT/5G */
+	u8	ext_ant_switch_ctrl_polarity;
+};
+
+/* *******************************************
+ * The following is interface which will notify coex module.
+ * ********************************************/
+void ex_btc8822b1ant_power_on_setting(struct btc_coexist *btcoexist);
+void ex_btc8822b1ant_pre_load_firmware(struct btc_coexist *btcoexist);
+void ex_btc8822b1ant_init_hw_config(struct btc_coexist *btcoexist,
+				    bool wifi_only);
+void ex_btc8822b1ant_init_coex_dm(struct btc_coexist *btcoexist);
+void ex_btc8822b1ant_ips_notify(struct btc_coexist *btcoexist, u8 type);
+void ex_btc8822b1ant_lps_notify(struct btc_coexist *btcoexist, u8 type);
+void ex_btc8822b1ant_scan_notify(struct btc_coexist *btcoexist, u8 type);
+void ex_btc8822b1ant_scan_notify_without_bt(struct btc_coexist *btcoexist,
+					    u8 type);
+void ex_btc8822b1ant_switchband_notify(struct btc_coexist *btcoexist,
+				       u8 type);
+void
+ex_btc8822b1ant_switchband_notify_without_bt(struct btc_coexist *btcoexist,
+					     u8 type);
+void ex_btc8822b1ant_connect_notify(struct btc_coexist *btcoexist, u8 type);
+void ex_btc8822b1ant_media_status_notify(struct btc_coexist *btcoexist,
+					 u8 type);
+void ex_btc8822b1ant_specific_packet_notify(struct btc_coexist *btcoexist,
+					    u8 type);
+void ex_btc8822b1ant_bt_info_notify(struct btc_coexist *btcoexist,
+				    u8 *tmp_buf, u8 length);
+void ex_btc8822b1ant_wl_fwdbginfo_notify(struct btc_coexist *btcoexist,
+					 u8 *tmp_buf, u8 length);
+void ex_btc8822b1ant_rx_rate_change_notify(struct btc_coexist *btcoexist,
+					   bool is_data_frame,
+					   u8 btc_rate_id);
+void ex_btc8822b1ant_rf_status_notify(struct btc_coexist *btcoexist,
+				      u8 type);
+void ex_btc8822b1ant_halt_notify(struct btc_coexist *btcoexist);
+void ex_btc8822b1ant_pnp_notify(struct btc_coexist *btcoexist, u8 pnp_state);
+void ex_halbtc8822b1ant_score_board_status_notify(struct btc_coexist *btcoexist,
+						  u8 *tmp_buf, u8 length);
+void ex_btc8822b1ant_coex_dm_reset(struct btc_coexist *btcoexist);
+void ex_btc8822b1ant_periodical(struct btc_coexist *btcoexist);
+void ex_btc8822b1ant_display_simple_coex_info(struct btc_coexist *btcoexist,
+					      struct seq_file *m);
+
+void ex_btc8822b1ant_display_coex_info(struct btc_coexist *btcoexist,
+				       struct seq_file *m);
+void ex_btc8822b1ant_antenna_detection(struct btc_coexist *btcoexist,
+				       u32 cent_freq, u32 offset, u32 span,
+				       u32 seconds);
+void ex_btc8822b1ant_antenna_isolation(struct btc_coexist *btcoexist,
+				       u32 cent_freq, u32 offset, u32 span,
+				       u32 seconds);
+
+void ex_btc8822b1ant_psd_scan(struct btc_coexist *btcoexist, u32 cent_freq,
+			      u32 offset, u32 span, u32 seconds);
+void ex_btc8822b1ant_display_ant_detection(struct btc_coexist *btcoexist);
+
+void ex_btc8822b1ant_dbg_control(struct btc_coexist *btcoexist, u8 op_code,
+				 u8 op_len, u8 *pdata);
-- 
2.15.1
