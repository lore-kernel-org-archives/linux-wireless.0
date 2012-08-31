Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ie0-f174.google.com ([209.85.223.174]:35421 "EHLO
	mail-ie0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754878Ab2HaUjw (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 31 Aug 2012 16:39:52 -0400
Received: by mail-ie0-f174.google.com with SMTP id e11so2019210iej.19
        for <linux-wireless@vger.kernel.org>; Fri, 31 Aug 2012 13:39:52 -0700 (PDT)
From: Larry Finger <Larry.Finger@lwfinger.net>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org,
	Larry Finger <Larry.Finger@lwfinger.net>
Subject: [PATCH 3/3 V2] rtlwifi: Update header file
Date: Fri, 31 Aug 2012 15:39:01 -0500
Message-Id: <1346445541-5251-4-git-send-email-Larry.Finger@lwfinger.net> (sfid-20120831_223955_685504_44F1B57A)
In-Reply-To: <1346445541-5251-1-git-send-email-Larry.Finger@lwfinger.net>
References: <1346445541-5251-1-git-send-email-Larry.Finger@lwfinger.net>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

The latest version of the vendor driver for the rtlwifi family
includes many changes. This patch incorporates the difference
in the main header file.

Signed-off-by: Larry Finger <Larry.Finger@lwfinger.net>
---
 drivers/net/wireless/rtlwifi/wifi.h |   92 ++++++++++++++++++++++++++++++++++-
 1 file changed, 91 insertions(+), 1 deletion(-)

diff --git a/drivers/net/wireless/rtlwifi/wifi.h b/drivers/net/wireless/rtlwifi/wifi.h
index d4bc785..f1b6bc6 100644
--- a/drivers/net/wireless/rtlwifi/wifi.h
+++ b/drivers/net/wireless/rtlwifi/wifi.h
@@ -135,7 +135,7 @@ enum hardware_type {
 	HARDWARE_TYPE_RTL8192CU,
 	HARDWARE_TYPE_RTL8192DE,
 	HARDWARE_TYPE_RTL8192DU,
-	HARDWARE_TYPE_RTL8723E,
+	HARDWARE_TYPE_RTL8723AE,
 	HARDWARE_TYPE_RTL8723U,
 
 	/* keep it last */
@@ -389,6 +389,7 @@ enum rt_enc_alg {
 	RSERVED_ENCRYPTION = 3,
 	AESCCMP_ENCRYPTION = 4,
 	WEP104_ENCRYPTION = 5,
+	AESCMAC_ENCRYPTION = 6,	/*IEEE802.11w */
 };
 
 enum rtl_hal_state {
@@ -873,6 +874,7 @@ struct rtl_phy {
 	u32 adda_backup[16];
 	u32 iqk_mac_backup[IQK_MAC_REG_NUM];
 	u32 iqk_bb_backup[10];
+	bool iqk_initialized;
 
 	/* Dual mac */
 	bool need_iqk;
@@ -910,6 +912,8 @@ struct rtl_phy {
 #define RTL_AGG_OPERATIONAL			3
 #define RTL_AGG_OFF				0
 #define RTL_AGG_ON				1
+#define RTL_RX_AGG_START			1
+#define RTL_RX_AGG_STOP				0
 #define RTL_AGG_EMPTYING_HW_QUEUE_ADDBA		2
 #define RTL_AGG_EMPTYING_HW_QUEUE_DELBA		3
 
@@ -920,6 +924,7 @@ struct rtl_ht_agg {
 	u64 bitmap;
 	u32 rate_n_flags;
 	u8 agg_state;
+	u8 rx_agg_state;
 };
 
 struct rtl_tid_data {
@@ -927,11 +932,19 @@ struct rtl_tid_data {
 	struct rtl_ht_agg agg;
 };
 
+struct rssi_sta {
+	long undecorated_smoothed_pwdb;
+};
+
 struct rtl_sta_info {
+	struct list_head list;
 	u8 ratr_index;
 	u8 wireless_mode;
 	u8 mimo_ps;
 	struct rtl_tid_data tids[MAX_TID_COUNT];
+
+	/* just used for ap adhoc or mesh*/
+	struct rssi_sta rssi_stat;
 } __packed;
 
 struct rtl_priv;
@@ -1034,6 +1047,11 @@ struct rtl_mac {
 struct rtl_hal {
 	struct ieee80211_hw *hw;
 
+	bool up_first_time;
+	bool first_init;
+	bool being_init_adapter;
+	bool bbrf_ready;
+
 	enum intf_type interface;
 	u16 hw_type;		/*92c or 92d or 92s and so on */
 	u8 ic_class;
@@ -1048,6 +1066,7 @@ struct rtl_hal {
 	u16 fw_subversion;
 	bool h2c_setinprogress;
 	u8 last_hmeboxnum;
+	bool fw_ready;
 	/*Reserve page start offset except beacon in TxQ. */
 	u8 fw_rsvdpage_startoffset;
 	u8 h2c_txcmd_seq;
@@ -1083,6 +1102,8 @@ struct rtl_hal {
 	bool load_imrandiqk_setting_for2g;
 
 	bool disable_amsdu_8k;
+	bool master_of_dmsp;
+	bool slave_of_dmsp;
 };
 
 struct rtl_security {
@@ -1144,6 +1165,9 @@ struct rtl_dm {
 	bool disable_tx_int;
 	char ofdm_index[2];
 	char cck_index;
+
+	/* DMSP */
+	bool supp_phymode_switch;
 };
 
 #define	EFUSE_MAX_LOGICAL_SIZE			256
@@ -1337,6 +1361,10 @@ struct rtl_stats {
 };
 
 struct rt_link_detect {
+	/* count for roaming */
+	u32 bcn_rx_inperiod;
+	u32 roam_times;
+
 	u32 num_tx_in4period[4];
 	u32 num_rx_in4period[4];
 
@@ -1344,6 +1372,8 @@ struct rt_link_detect {
 	u32 num_rx_inperiod;
 
 	bool busytraffic;
+	bool tx_busy_traffic;
+	bool rx_busy_traffic;
 	bool higher_busytraffic;
 	bool higher_busyrxtraffic;
 
@@ -1455,7 +1485,12 @@ struct rtl_hal_ops {
 			  u32 regaddr, u32 bitmask);
 	void (*set_rfreg) (struct ieee80211_hw *hw, enum radio_path rfpath,
 			   u32 regaddr, u32 bitmask, u32 data);
+	void (*allow_all_destaddr)(struct ieee80211_hw *hw,
+		bool allow_all_da, bool write_into_reg);
 	void (*linked_set_reg) (struct ieee80211_hw *hw);
+	void (*check_switch_to_dmdp) (struct ieee80211_hw *hw);
+	void (*dualmac_easy_concurrent) (struct ieee80211_hw *hw);
+	void (*dualmac_switch_to_dmdp) (struct ieee80211_hw *hw);
 	bool (*phy_rf6052_config) (struct ieee80211_hw *hw);
 	void (*phy_rf6052_set_cck_txpower) (struct ieee80211_hw *hw,
 					    u8 *powerlevel);
@@ -1475,6 +1510,8 @@ struct rtl_intf_ops {
 	void (*read_efuse_byte)(struct ieee80211_hw *hw, u16 _offset, u8 *pbuf);
 	int (*adapter_start) (struct ieee80211_hw *hw);
 	void (*adapter_stop) (struct ieee80211_hw *hw);
+	bool (*check_buddy_priv)(struct ieee80211_hw *hw,
+				 struct rtl_priv **buddy_priv);
 
 	int (*adapter_tx) (struct ieee80211_hw *hw,
 			   struct ieee80211_sta *sta,
@@ -1559,11 +1596,16 @@ struct rtl_locks {
 	spinlock_t h2c_lock;
 	spinlock_t rf_ps_lock;
 	spinlock_t rf_lock;
+	spinlock_t lps_lock;
 	spinlock_t waitq_lock;
+	spinlock_t entry_list_lock;
 	spinlock_t usb_lock;
 
 	/*Dual mac*/
 	spinlock_t cck_and_rw_pagea_lock;
+
+	/*Easy concurrent*/
+	spinlock_t check_sendpkt_lock;
 };
 
 struct rtl_works {
@@ -1571,6 +1613,7 @@ struct rtl_works {
 
 	/*timer */
 	struct timer_list watchdog_timer;
+	struct timer_list dualmac_easyconcurrent_retrytimer;
 
 	/*task */
 	struct tasklet_struct irq_tasklet;
@@ -1598,6 +1641,31 @@ struct rtl_debug {
 	char proc_name[20];
 };
 
+#define MIMO_PS_STATIC			0
+#define MIMO_PS_DYNAMIC			1
+#define MIMO_PS_NOLIMIT			3
+
+struct rtl_dualmac_easy_concurrent_ctl {
+	enum band_type currentbandtype_backfordmdp;
+	bool close_bbandrf_for_dmsp;
+	bool change_to_dmdp;
+	bool change_to_dmsp;
+	bool switch_in_process;
+};
+
+struct rtl_dmsp_ctl {
+	bool activescan_for_slaveofdmsp;
+	bool scan_for_anothermac_fordmsp;
+	bool scan_for_itself_fordmsp;
+	bool writedig_for_anothermacofdmsp;
+	u32 curdigvalue_for_anothermacofdmsp;
+	bool changecckpdstate_for_anothermacofdmsp;
+	u8 curcckpdstate_for_anothermacofdmsp;
+	bool changetxhighpowerlvl_for_anothermacofdmsp;
+	u8 curtxhighlvl_for_anothermacofdmsp;
+	long rssivalmin_for_anothermacofdmsp;
+};
+
 struct ps_t {
 	u8 pre_ccastate;
 	u8 cur_ccasate;
@@ -1657,8 +1725,20 @@ struct dig_t {
 	char backoffval_range_min;
 };
 
+struct rtl_global_var {
+	/* from this list we can get
+	 * other adapter's rtl_priv */
+	struct list_head glb_priv_list;
+	spinlock_t glb_list_lock;
+};
+
 struct rtl_priv {
 	struct completion firmware_loading_complete;
+	struct list_head list;
+	struct rtl_priv *buddy_priv;
+	struct rtl_global_var *glb_var;
+	struct rtl_dualmac_easy_concurrent_ctl easy_concurrent_ctl;
+	struct rtl_dmsp_ctl dmsp_ctl;
 	struct rtl_locks locks;
 	struct rtl_works works;
 	struct rtl_mac mac80211;
@@ -1679,6 +1759,9 @@ struct rtl_priv {
 
 	struct rtl_rate_priv *rate_priv;
 
+	/* sta entry list for ap adhoc or mesh */
+	struct list_head entry_list;
+
 	struct rtl_debug dbg;
 	int max_fw_size;
 
@@ -2105,4 +2188,11 @@ static inline struct ieee80211_sta *get_sta(struct ieee80211_hw *hw,
 	return ieee80211_find_sta(vif, bssid);
 }
 
+static inline struct ieee80211_sta *rtl_find_sta(struct ieee80211_hw *hw,
+		u8 *mac_addr)
+{
+	struct rtl_mac *mac = rtl_mac(rtl_priv(hw));
+	return ieee80211_find_sta(mac->vif, mac_addr);
+}
+
 #endif
-- 
1.7.10.4

