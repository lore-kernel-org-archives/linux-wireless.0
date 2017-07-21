Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-oi0-f65.google.com ([209.85.218.65]:38833 "EHLO
        mail-oi0-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750769AbdGUEYw (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 21 Jul 2017 00:24:52 -0400
Received: by mail-oi0-f65.google.com with SMTP id p188so3925803oia.5
        for <linux-wireless@vger.kernel.org>; Thu, 20 Jul 2017 21:24:51 -0700 (PDT)
From: Larry Finger <Larry.Finger@lwfinger.net>
To: kvalo@codeaurora.org
Cc: linux-wireless@vger.kernel.org, Ping-Ke Shih <pkshih@realtek.com>,
        Larry Finger <Larry.Finger@lwfinger.net>,
        Yan-Hsuan Chuang <yhchuang@realtek.com>,
        Birming Chiu <birming@realtek.com>,
        Shaofu <shaofu@realtek.com>, Steven Ting <steventing@realtek.com>
Subject: [PATCH 03/10] rtlwifi: Add phydm structure to main header file
Date: Thu, 20 Jul 2017 23:24:33 -0500
Message-Id: <20170721042440.15839-4-Larry.Finger@lwfinger.net> (sfid-20170721_062509_524816_C41FCFE7)
In-Reply-To: <20170721042440.15839-1-Larry.Finger@lwfinger.net>
References: <20170721042440.15839-1-Larry.Finger@lwfinger.net>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Ping-Ke Shih <pkshih@realtek.com>

Add structure and ops to interact between phydm and other modules.

Signed-off-by: Ping-Ke Shih <pkshih@realtek.com>
Signed-off-by: Larry Finger <Larry.Finger@lwfinger.net>
Cc: Yan-Hsuan Chuang <yhchuang@realtek.com>
Cc: Birming Chiu <birming@realtek.com>
Cc: Shaofu <shaofu@realtek.com>
Cc: Steven Ting <steventing@realtek.com>
---
 drivers/net/wireless/realtek/rtlwifi/wifi.h | 135 +++++++++++++++++++++++++++-
 1 file changed, 134 insertions(+), 1 deletion(-)

diff --git a/drivers/net/wireless/realtek/rtlwifi/wifi.h b/drivers/net/wireless/realtek/rtlwifi/wifi.h
index 42e77e07bbb3..597f12025e6b 100644
--- a/drivers/net/wireless/realtek/rtlwifi/wifi.h
+++ b/drivers/net/wireless/realtek/rtlwifi/wifi.h
@@ -1327,8 +1327,20 @@ struct rtl_ht_agg {
 };
 
 struct rssi_sta {
+	/* for old dm */
 	long undec_sm_pwdb;
 	long undec_sm_cck;
+
+	/* for new phydm_mod */
+	s32 undecorated_smoothed_pwdb;
+	s32 undecorated_smoothed_cck;
+	s32 undecorated_smoothed_ofdm;
+	u8 ofdm_pkt;
+	u8 cck_pkt;
+	u16 cck_sum_power;
+	u8 is_send_rssi;
+	u64 packet_map;
+	u8 valid_bit;
 };
 
 struct rtl_tid_data {
@@ -2590,6 +2602,21 @@ struct rtl_btc_ops {
 	void (*btc_get_ampdu_cfg)(struct rtl_priv *rtlpriv, u8 *reject_agg,
 				  u8 *ctrl_agg_size, u8 *agg_size);
 	bool (*btc_is_bt_lps_on)(struct rtl_priv *rtlpriv);
+	/* ops for phydm cb */
+	u8 (*get_txpower_index)(struct ieee80211_hw *hw, u8 path,
+				u8 rate, u8 bandwidth, u8 channel);
+	void (*set_tx_power_index_by_rs)(struct ieee80211_hw *hw,
+					 u8 channel, u8 path,
+					 enum rate_section rs);
+	void (*store_tx_power_by_rate)(struct ieee80211_hw *hw,
+				       u32 band, u32 rfpath,
+				       u32 txnum, u32 regaddr,
+				       u32 bitmask, u32 data);
+	void (*phy_set_txpower_limit)(struct ieee80211_hw *hw, u8 *pregulation,
+				      u8 *pband, u8 *pbandwidth,
+				      u8 *prate_section, u8 *prf_path,
+				      u8 *pchannel, u8 *ppower_limit);
+
 };
 
 struct proxim {
@@ -2619,6 +2646,110 @@ struct rtl_scan_list {
 	struct list_head list;	/* sort by age */
 };
 
+struct rtl_phydm_params {
+	u8 mp_chip;	/* 1: MP chip, 0: test chip */
+	u8 fab_ver;	/* 0: TSMC, 1: UMC, ...*/
+	u8 cut_ver;	/* 0: A, 1: B, ..., 10: K */
+	u8 efuse0x3d7;	/* default: 0xff */
+	u8 efuse0x3d8;	/* default: 0xff */
+};
+
+struct rtl_phydm_ops {
+	/* init/deinit priv */
+	int (*phydm_init_priv)(struct rtl_priv *rtlpriv,
+			       struct rtl_phydm_params *params);
+	int (*phydm_deinit_priv)(struct rtl_priv *rtlpriv);
+	bool (*phydm_load_txpower_by_rate)(struct rtl_priv *rtlpriv);
+	bool (*phydm_load_txpower_limit)(struct rtl_priv *rtlpriv);
+
+	/* init hw */
+	int  (*phydm_init_dm)(struct rtl_priv *rtlpriv);
+	int  (*phydm_deinit_dm)(struct rtl_priv *rtlpriv);
+	int  (*phydm_reset_dm)(struct rtl_priv *rtlpriv);
+	bool (*phydm_parameter_init)(struct rtl_priv *rtlpriv, bool post);
+	bool (*phydm_phy_bb_config)(struct rtl_priv *rtlpriv);
+	bool (*phydm_phy_rf_config)(struct rtl_priv *rtlpriv);
+	bool (*phydm_phy_mac_config)(struct rtl_priv *rtlpriv);
+	bool (*phydm_trx_mode)(struct rtl_priv *rtlpriv,
+			       enum radio_mask tx_path, enum radio_mask rx_path,
+			       bool is_tx2_path);
+
+	/* watchdog */
+	bool (*phydm_watchdog)(struct rtl_priv *rtlpriv);
+
+	/* channel */
+	bool (*phydm_switch_band)(struct rtl_priv *rtlpriv, u8 central_ch);
+	bool (*phydm_switch_channel)(struct rtl_priv *rtlpriv, u8 central_ch);
+	bool (*phydm_switch_bandwidth)(struct rtl_priv *rtlpriv,
+				       u8 primary_ch_idx,
+				       enum ht_channel_width width);
+	bool (*phydm_iq_calibrate)(struct rtl_priv *rtlpriv);
+	bool (*phydm_clear_txpowertracking_state)(struct rtl_priv *rtlpriv);
+	bool (*phydm_pause_dig)(struct rtl_priv *rtlpriv, bool pause);
+
+	/* read/write reg */
+	u32  (*phydm_read_rf_reg)(struct rtl_priv *rtlpriv,
+				  enum radio_path rfpath,
+				  u32 addr, u32 mask);
+	bool (*phydm_write_rf_reg)(struct rtl_priv *rtlpriv,
+				   enum radio_path rfpath,
+				   u32 addr, u32 mask, u32 data);
+	u8   (*phydm_read_txagc)(struct rtl_priv *rtlpriv,
+				 enum radio_path rfpath, u8 hw_rate);
+	bool (*phydm_write_txagc)(struct rtl_priv *rtlpriv, u32 power_index,
+				  enum radio_path rfpath, u8 hw_rate);
+
+	/* RX */
+	bool (*phydm_c2h_content_parsing)(struct rtl_priv *rtlpriv, u8 cmd_id,
+					  u8 cmd_len, u8 *content);
+	bool (*phydm_query_phy_status)(struct rtl_priv *rtlpriv, u8 *phystrpt,
+				       struct ieee80211_hdr *hdr,
+				       struct rtl_stats *pstatus);
+
+	/* TX */
+	u8 (*phydm_rate_id_mapping)(struct rtl_priv *rtlpriv,
+				    enum wireless_mode wireless_mode,
+				    enum rf_type rf_type,
+				    enum ht_channel_width bw);
+	bool (*phydm_get_ra_bitmap)(struct rtl_priv *rtlpriv,
+				    enum wireless_mode wireless_mode,
+				    enum rf_type rf_type,
+				    enum ht_channel_width bw,
+				    u8 tx_rate_level, /* 0~6 */
+				    u32 *tx_bitmap_msb,
+				    u32 *tx_bitmap_lsb);
+
+	/* STA */
+	bool (*phydm_add_sta)(struct rtl_priv *rtlpriv,
+			      struct ieee80211_sta *sta);
+	bool (*phydm_del_sta)(struct rtl_priv *rtlpriv,
+			      struct ieee80211_sta *sta);
+
+	/* BTC */
+	u32  (*phydm_get_version)(struct rtl_priv *rtlpriv);
+	bool (*phydm_modify_ra_pcr_threshold)(struct rtl_priv *rtlpriv,
+					      u8 ra_offset_direction,
+					      u8 ra_threshold_offset);
+	u32  (*phydm_query_counter)(struct rtl_priv *rtlpriv,
+				    const char *info_type);
+
+	/* debug */
+	bool (*phydm_debug_cmd)(struct rtl_priv *rtlpriv, char *in, u32 in_len,
+				char *out, u32 out_len);
+
+};
+
+struct rtl_phydm {
+	struct rtl_phydm_ops *ops;/* phydm ops (phydm_mod.ko own this object) */
+	void *internal;	/* internal context of phydm, i.e. PHY_DM_STRUCT */
+
+	u8 adaptivity_en;
+	/* debug */
+	u16 forced_data_rate;
+	u8 forced_igi_lb;
+	u8 antenna_test;
+};
+
 struct rtl_priv {
 	struct ieee80211_hw *hw;
 	struct completion firmware_loading_complete;
@@ -2697,6 +2828,9 @@ struct rtl_priv {
 	/*for bt coexist use*/
 	struct bt_coexist_info btcoexist;
 
+	/* phydm for newer IC. (e.g. 8822B) */
+	struct rtl_phydm phydm;
+
 	/* separate 92ee from other ICs,
 	 * 92ee use new trx flow.
 	 */
@@ -2718,7 +2852,6 @@ struct rtl_priv {
 #define rtl_efuse(rtlpriv)	(&((rtlpriv)->efuse))
 #define rtl_psc(rtlpriv)	(&((rtlpriv)->psc))
 
-
 /***************************************
     Bluetooth Co-existence Related
 ****************************************/
-- 
2.12.3
