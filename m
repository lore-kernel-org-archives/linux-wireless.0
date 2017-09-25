Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pg0-f68.google.com ([74.125.83.68]:36712 "EHLO
        mail-pg0-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S932395AbdIYN1N (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 25 Sep 2017 09:27:13 -0400
Received: by mail-pg0-f68.google.com with SMTP id d8so4864510pgt.3
        for <linux-wireless@vger.kernel.org>; Mon, 25 Sep 2017 06:27:13 -0700 (PDT)
From: Amitkumar Karwar <amitkarwar@gmail.com>
To: Kalle Valo <kvalo@codeaurora.org>
Cc: linux-wireless@vger.kernel.org,
        Amitkumar Karwar <amit.karwar@redpinesignals.com>,
        Prameela Rani Garnepudi <prameela.j04cs@gmail.com>,
        Karun Eagalapati <karun256@gmail.com>
Subject: [PATCH 1/3] rsi: sdio: add WOWLAN support for S3 suspend state
Date: Mon, 25 Sep 2017 18:51:35 +0530
Message-Id: <1506345695-4654-1-git-send-email-amitkarwar@gmail.com> (sfid-20170925_152948_994634_C055207A)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Karun Eagalapati <karun256@gmail.com>

WoWLAN is supported in RS9113 device through GPIO pin2.
wowlan config frame is internally sent to firmware in mac80211
suspend handler. Also beacon miss threshold and keep-alive time
values are increased to avoid un-necessary disconnection with AP.

Signed-off-by: Karun Eagalapati <karun256@gmail.com>
Signed-off-by: Amitkumar Karwar <amit.karwar@redpinesignals.com>
---
 drivers/net/wireless/rsi/Kconfig            |   7 ++
 drivers/net/wireless/rsi/rsi_91x_core.c     |   9 +-
 drivers/net/wireless/rsi/rsi_91x_mac80211.c | 125 ++++++++++++++++++++++++++++
 drivers/net/wireless/rsi/rsi_91x_mgmt.c     |  66 +++++++++++++--
 drivers/net/wireless/rsi/rsi_91x_sdio.c     |  11 +++
 drivers/net/wireless/rsi/rsi_common.h       |   3 +
 drivers/net/wireless/rsi/rsi_main.h         |  12 ++-
 drivers/net/wireless/rsi/rsi_mgmt.h         |  37 +++++++-
 8 files changed, 258 insertions(+), 12 deletions(-)

diff --git a/drivers/net/wireless/rsi/Kconfig b/drivers/net/wireless/rsi/Kconfig
index 7c5e4ca..0882b4e 100644
--- a/drivers/net/wireless/rsi/Kconfig
+++ b/drivers/net/wireless/rsi/Kconfig
@@ -42,4 +42,11 @@ config RSI_USB
 	  This option enables the USB bus support in rsi drivers.
 	  Select M (recommended), if you have a RSI 1x1 wireless module.
 
+config RSI_WOW
+	bool "Redpine Signals WOWLAN support"
+	depends on RSI_SDIO && RSI_91X
+	default y
+	---help---
+	 Say Y, if you would like to enable wowlan support for RSI module.
+
 endif # WLAN_VENDOR_RSI
diff --git a/drivers/net/wireless/rsi/rsi_91x_core.c b/drivers/net/wireless/rsi/rsi_91x_core.c
index bc18a19..2a081a4 100644
--- a/drivers/net/wireless/rsi/rsi_91x_core.c
+++ b/drivers/net/wireless/rsi/rsi_91x_core.c
@@ -379,7 +379,14 @@ void rsi_core_xmit(struct rsi_common *common, struct sk_buff *skb)
 		rsi_dbg(ERR_ZONE, "%s: FSM state not open\n", __func__);
 		goto xmit_fail;
 	}
-
+#ifdef CONFIG_RSI_WOW
+	if (common->wow_flags & RSI_WOW_ENABLED) {
+		rsi_dbg(ERR_ZONE,
+			"%s: Blocking Tx_packets when WOWLAN is enabled\n",
+			__func__);
+		goto xmit_fail;
+	}
+#endif
 	info = IEEE80211_SKB_CB(skb);
 	tx_params = (struct skb_info *)info->driver_data;
 	wh = (struct ieee80211_hdr *)&skb->data[0];
diff --git a/drivers/net/wireless/rsi/rsi_91x_mac80211.c b/drivers/net/wireless/rsi/rsi_91x_mac80211.c
index b1f5dbb..c6b2ce5 100644
--- a/drivers/net/wireless/rsi/rsi_91x_mac80211.c
+++ b/drivers/net/wireless/rsi/rsi_91x_mac80211.c
@@ -1746,6 +1746,124 @@ static int rsi_mac80211_cancel_roc(struct ieee80211_hw *hw)
 	return 0;
 }
 
+#ifdef CONFIG_RSI_WOW
+static const struct wiphy_wowlan_support rsi_wowlan_support = {
+	.flags = WIPHY_WOWLAN_ANY |
+		 WIPHY_WOWLAN_MAGIC_PKT |
+		 WIPHY_WOWLAN_DISCONNECT |
+		 WIPHY_WOWLAN_GTK_REKEY_FAILURE  |
+		 WIPHY_WOWLAN_SUPPORTS_GTK_REKEY |
+		 WIPHY_WOWLAN_EAP_IDENTITY_REQ   |
+		 WIPHY_WOWLAN_4WAY_HANDSHAKE,
+};
+
+static u16 rsi_wow_map_triggers(struct rsi_common *common,
+				struct cfg80211_wowlan *wowlan)
+{
+	u16 wow_triggers = 0;
+
+	rsi_dbg(INFO_ZONE, "Mapping wowlan triggers\n");
+
+	if (wowlan->any)
+		wow_triggers |= RSI_WOW_ANY;
+	if (wowlan->magic_pkt)
+		wow_triggers |= RSI_WOW_MAGIC_PKT;
+	if (wowlan->disconnect)
+		wow_triggers |= RSI_WOW_DISCONNECT;
+	if (wowlan->gtk_rekey_failure || wowlan->eap_identity_req ||
+	    wowlan->four_way_handshake)
+		wow_triggers |= RSI_WOW_GTK_REKEY;
+
+	return wow_triggers;
+}
+
+int rsi_config_wowlan(struct rsi_hw *adapter, struct cfg80211_wowlan *wowlan)
+{
+	struct rsi_common *common = adapter->priv;
+	u16 triggers = 0;
+	u16 rx_filter_word = 0;
+	struct ieee80211_bss_conf *bss = &adapter->vifs[0]->bss_conf;
+
+	rsi_dbg(INFO_ZONE, "Config WoWLAN to device\n");
+
+	if (WARN_ON(!wowlan)) {
+		rsi_dbg(ERR_ZONE, "WoW triggers not enabled\n");
+		return -EINVAL;
+	}
+
+	triggers = rsi_wow_map_triggers(common, wowlan);
+	if (!triggers) {
+		rsi_dbg(ERR_ZONE, "%s:No valid WoW triggers\n", __func__);
+		return -EINVAL;
+	}
+	if (!bss->assoc) {
+		rsi_dbg(ERR_ZONE,
+			"Cannot configure WoWLAN (Station not connected)\n");
+		common->wow_flags |= RSI_WOW_NO_CONNECTION;
+		return 0;
+	}
+	rsi_dbg(INFO_ZONE, "TRIGGERS %x\n", triggers);
+	rsi_send_wowlan_request(common, triggers, 1);
+
+	/**
+	 * Increase the beacon_miss threshold & keep-alive timers in
+	 * vap_update frame
+	 */
+	rsi_send_vap_dynamic_update(common);
+
+	rx_filter_word = (ALLOW_DATA_ASSOC_PEER | DISALLOW_BEACONS);
+	rsi_send_rx_filter_frame(common, rx_filter_word);
+	common->wow_flags |= RSI_WOW_ENABLED;
+
+	return 0;
+}
+#endif
+
+#ifdef CONFIG_PM
+static int rsi_mac80211_suspend(struct ieee80211_hw *hw,
+				struct cfg80211_wowlan *wowlan)
+{
+#ifdef CONFIG_RSI_WOW
+	struct rsi_hw *adapter = hw->priv;
+	struct rsi_common *common = adapter->priv;
+
+	rsi_dbg(INFO_ZONE, "%s: mac80211 suspend\n", __func__);
+	mutex_lock(&common->mutex);
+	if (rsi_config_wowlan(adapter, wowlan)) {
+		rsi_dbg(ERR_ZONE, "Failed to configure WoWLAN\n");
+		mutex_unlock(&common->mutex);
+		return 1;
+	}
+	mutex_unlock(&common->mutex);
+#endif
+	return 0;
+}
+
+static int rsi_mac80211_resume(struct ieee80211_hw *hw)
+{
+#ifdef CONFIG_RSI_WOW
+	u16 rx_filter_word = 0;
+	struct rsi_hw *adapter = hw->priv;
+	struct rsi_common *common = adapter->priv;
+
+	common->wow_flags = 0;
+#endif
+
+	rsi_dbg(INFO_ZONE, "%s: mac80211 resume\n", __func__);
+#ifdef CONFIG_RSI_WOW
+	mutex_lock(&common->mutex);
+	rsi_send_wowlan_request(common, 0, 0);
+
+	rx_filter_word = (ALLOW_DATA_ASSOC_PEER | ALLOW_CTRL_ASSOC_PEER |
+			  ALLOW_MGMT_ASSOC_PEER);
+	rsi_send_rx_filter_frame(common, rx_filter_word);
+	mutex_unlock(&common->mutex);
+#endif
+	return 0;
+}
+
+#endif
+
 static const struct ieee80211_ops mac80211_ops = {
 	.tx = rsi_mac80211_tx,
 	.start = rsi_mac80211_start,
@@ -1767,6 +1885,10 @@ static const struct ieee80211_ops mac80211_ops = {
 	.rfkill_poll = rsi_mac80211_rfkill_poll,
 	.remain_on_channel = rsi_mac80211_roc,
 	.cancel_remain_on_channel = rsi_mac80211_cancel_roc,
+#ifdef CONFIG_PM
+	.suspend = rsi_mac80211_suspend,
+	.resume  = rsi_mac80211_resume,
+#endif
 };
 
 /**
@@ -1850,6 +1972,9 @@ int rsi_mac80211_attach(struct rsi_common *common)
 	wiphy->features |= NL80211_FEATURE_INACTIVITY_TIMER;
 	wiphy->reg_notifier = rsi_reg_notify;
 
+#ifdef CONFIG_RSI_WOW
+	wiphy->wowlan = &rsi_wowlan_support;
+#endif
 	wiphy_ext_feature_set(wiphy, NL80211_EXT_FEATURE_CQM_RSSI_LIST);
 
 	/* Wi-Fi direct parameters */
diff --git a/drivers/net/wireless/rsi/rsi_91x_mgmt.c b/drivers/net/wireless/rsi/rsi_91x_mgmt.c
index 4b94190..84ac0fa 100644
--- a/drivers/net/wireless/rsi/rsi_91x_mgmt.c
+++ b/drivers/net/wireless/rsi/rsi_91x_mgmt.c
@@ -1094,9 +1094,21 @@ int rsi_send_vap_dynamic_update(struct rsi_common *common)
 	dynamic_frame->desc_dword0.frame_type = VAP_DYNAMIC_UPDATE;
 	dynamic_frame->desc_dword2.pkt_info =
 					cpu_to_le32(common->rts_threshold);
-	/* Beacon miss threshold */
-	dynamic_frame->frame_body.keep_alive_period =
+#ifdef CONFIG_RSI_WOW
+	if (common->wow_flags & RSI_WOW_ENABLED) {
+		/* Beacon miss threshold */
+		dynamic_frame->desc_dword3.token =
+					cpu_to_le16(RSI_BCN_MISS_THRESHOLD);
+		dynamic_frame->frame_body.keep_alive_period =
+					cpu_to_le16(RSI_WOW_KEEPALIVE);
+	} else {
+		dynamic_frame->frame_body.keep_alive_period =
+					cpu_to_le16(RSI_DEF_KEEPALIVE);
+	}
+#else
+		dynamic_frame->frame_body.keep_alive_period =
 					cpu_to_le16(RSI_DEF_KEEPALIVE);
+#endif
 	dynamic_frame->desc_dword3.sta_id = 0; /* vap id */
 
 	skb_put(skb, sizeof(struct rsi_dynamic_s));
@@ -1340,13 +1352,13 @@ void rsi_inform_bss_status(struct rsi_common *common,
 	} else {
 		if (opmode == RSI_OPMODE_STA)
 			common->hw_data_qs_blocked = true;
-		rsi_hal_send_sta_notify_frame(common,
-					      opmode,
-					      STA_DISCONNECTED,
-					      addr,
-					      qos_enable,
-					      aid, sta_id,
-					      vif);
+#ifdef CONFIG_RSI_WOW
+		if (!(common->wow_flags & RSI_WOW_ENABLED))
+#endif
+			rsi_hal_send_sta_notify_frame(common, opmode,
+						      STA_DISCONNECTED, addr,
+						      qos_enable, aid, sta_id,
+						      vif);
 		if (opmode == RSI_OPMODE_STA)
 			rsi_send_block_unblock_frame(common, true);
 	}
@@ -1589,6 +1601,42 @@ static int rsi_send_beacon(struct rsi_common *common)
 	return 0;
 }
 
+#ifdef CONFIG_RSI_WOW
+int rsi_send_wowlan_request(struct rsi_common *common, u16 flags,
+			    u16 sleep_status)
+{
+	struct rsi_wowlan_req *cmd_frame;
+	struct sk_buff *skb;
+	u8 length;
+
+	rsi_dbg(ERR_ZONE, "%s: Sending wowlan request frame\n", __func__);
+
+	length = sizeof(*cmd_frame);
+	skb = dev_alloc_skb(length);
+	if (!skb)
+		return -ENOMEM;
+	memset(skb->data, 0, length);
+	cmd_frame = (struct rsi_wowlan_req *)skb->data;
+
+	rsi_set_len_qno(&cmd_frame->desc.desc_dword0.len_qno,
+			(length - FRAME_DESC_SZ),
+			RSI_WIFI_MGMT_Q);
+	cmd_frame->desc.desc_dword0.frame_type = WOWLAN_CONFIG_PARAMS;
+	cmd_frame->host_sleep_status = sleep_status;
+	if (common->secinfo.security_enable &&
+	    common->secinfo.gtk_cipher)
+		flags |= RSI_WOW_GTK_REKEY;
+	if (sleep_status)
+		cmd_frame->wow_flags = flags;
+	rsi_dbg(INFO_ZONE, "Host_Sleep_Status : %d Flags : %d\n",
+		cmd_frame->host_sleep_status, cmd_frame->wow_flags);
+
+	skb_put(skb, length);
+
+	return rsi_send_internal_mgmt_frame(common, skb);
+}
+#endif
+
 /**
  * rsi_handle_ta_confirm_type() - This function handles the confirm frames.
  * @common: Pointer to the driver private structure.
diff --git a/drivers/net/wireless/rsi/rsi_91x_sdio.c b/drivers/net/wireless/rsi/rsi_91x_sdio.c
index b3f8006..28efa17 100644
--- a/drivers/net/wireless/rsi/rsi_91x_sdio.c
+++ b/drivers/net/wireless/rsi/rsi_91x_sdio.c
@@ -1124,6 +1124,10 @@ static int rsi_sdio_enable_interrupts(struct sdio_func *pfunc)
 {
 	u8 data;
 	int ret;
+#ifdef CONFIG_RSI_WOW
+	struct rsi_hw *adapter = sdio_get_drvdata(pfunc);
+	struct rsi_common *common = adapter->priv;
+#endif
 
 	sdio_claim_host(pfunc);
 	ret = rsi_cmd52readbyte(pfunc->card, RSI_INT_ENABLE_REGISTER, &data);
@@ -1142,6 +1146,13 @@ static int rsi_sdio_enable_interrupts(struct sdio_func *pfunc)
 			__func__);
 		goto done;
 	}
+#ifdef CONFIG_RSI_WOW
+	if ((common->wow_flags & RSI_WOW_ENABLED) &&
+	    (common->wow_flags & RSI_WOW_NO_CONNECTION))
+		rsi_dbg(ERR_ZONE,
+			"##### Device can not wake up through WLAN\n");
+
+#endif
 
 	ret = rsi_cmd52readbyte(pfunc->card, RSI_INT_ENABLE_REGISTER, &data);
 	if (ret < 0) {
diff --git a/drivers/net/wireless/rsi/rsi_common.h b/drivers/net/wireless/rsi/rsi_common.h
index 272e18d..fce6fb6 100644
--- a/drivers/net/wireless/rsi/rsi_common.h
+++ b/drivers/net/wireless/rsi/rsi_common.h
@@ -83,6 +83,9 @@ u16 rsi_get_connected_channel(struct ieee80211_vif *vif);
 struct rsi_hw *rsi_91x_init(void);
 void rsi_91x_deinit(struct rsi_hw *adapter);
 int rsi_read_pkt(struct rsi_common *common, s32 rcv_pkt_len);
+#ifdef CONFIG_RSI_WOW
+int rsi_config_wowlan(struct rsi_hw *adapter, struct cfg80211_wowlan *wowlan);
+#endif
 struct rsi_sta *rsi_find_sta(struct rsi_common *common, u8 *mac_addr);
 struct ieee80211_vif *rsi_get_vif(struct rsi_hw *adapter, u8 *mac);
 void rsi_roc_timeout(unsigned long data);
diff --git a/drivers/net/wireless/rsi/rsi_main.h b/drivers/net/wireless/rsi/rsi_main.h
index a118b7a..768e697 100644
--- a/drivers/net/wireless/rsi/rsi_main.h
+++ b/drivers/net/wireless/rsi/rsi_main.h
@@ -66,6 +66,8 @@ extern __printf(2, 3) void rsi_dbg(u32 zone, const char *fmt, ...);
 #define FRAME_DESC_SZ                   16
 #define MIN_802_11_HDR_LEN              24
 #define RSI_DEF_KEEPALIVE               90
+#define RSI_WOW_KEEPALIVE                5
+#define RSI_BCN_MISS_THRESHOLD           24
 
 #define DATA_QUEUE_WATER_MARK           400
 #define MIN_DATA_QUEUE_WATER_MARK       300
@@ -108,6 +110,12 @@ extern __printf(2, 3) void rsi_dbg(u32 zone, const char *fmt, ...);
 	((_q) == VI_Q) ? IEEE80211_AC_VI : \
 	IEEE80211_AC_VO)
 
+#ifdef CONFIG_RSI_WOW
+/* WoWLAN flags */
+#define RSI_WOW_ENABLED			BIT(0)
+#define RSI_WOW_NO_CONNECTION		BIT(1)
+#endif
+
 #define RSI_DEV_9113		1
 
 struct version_info {
@@ -266,7 +274,9 @@ struct rsi_common {
 	u8 obm_ant_sel_val;
 	int tx_power;
 	u8 ant_in_use;
-
+#ifdef CONFIG_RSI_WOW
+	u8 wow_flags;
+#endif
 	u16 beacon_interval;
 	u8 dtim_cnt;
 
diff --git a/drivers/net/wireless/rsi/rsi_mgmt.h b/drivers/net/wireless/rsi/rsi_mgmt.h
index b9d0802..fe0e11d 100644
--- a/drivers/net/wireless/rsi/rsi_mgmt.h
+++ b/drivers/net/wireless/rsi/rsi_mgmt.h
@@ -45,6 +45,19 @@
 #define MAGIC_WORD                      0x5A
 #define WLAN_EEPROM_RFTYPE_ADDR		424
 
+#ifdef CONFIG_RSI_WOW
+/*WOWLAN RESUME WAKEUP TYPES*/
+#define RSI_UNICAST_MAGIC_PKT		BIT(0)
+#define RSI_BROADCAST_MAGICPKT		BIT(1)
+#define RSI_EAPOL_PKT			BIT(2)
+#define RSI_DISCONNECT_PKT		BIT(3)
+#define RSI_HW_BMISS_PKT		BIT(4)
+#define RSI_INSERT_SEQ_IN_FW		BIT(2)
+
+#define WOW_MAX_FILTERS_PER_LIST 16
+#define WOW_PATTERN_SIZE 256
+#endif
+
 /* Receive Frame Types */
 #define TA_CONFIRM_TYPE                 0x01
 #define RX_DOT11_MGMT                   0x02
@@ -201,6 +214,13 @@
 #define RSI_DATA_DESC_INSERT_TSF	BIT(15)
 #define RSI_DATA_DESC_INSERT_SEQ_NO	BIT(2)
 
+#ifdef CONFIG_PM
+#define RSI_WOW_ANY			BIT(1)
+#define RSI_WOW_GTK_REKEY		BIT(3)
+#define RSI_WOW_MAGIC_PKT		BIT(4)
+#define RSI_WOW_DISCONNECT		BIT(5)
+#endif
+
 enum opmode {
 	RSI_OPMODE_UNSUPPORTED = -1,
 	RSI_OPMODE_AP = 0,
@@ -262,7 +282,9 @@ enum cmd_frame_type {
 	ANT_SEL_FRAME = 0x20,
 	VAP_DYNAMIC_UPDATE = 0x27,
 	COMMON_DEV_CONFIG = 0x28,
-	RADIO_PARAMS_UPDATE = 0x29
+	RADIO_PARAMS_UPDATE = 0x29,
+	WOWLAN_CONFIG_PARAMS = 0x2B,
+	WOWLAN_WAKEUP_REASON = 0xc5
 };
 
 struct rsi_mac_frame {
@@ -581,6 +603,15 @@ struct rsi_request_ps {
 	__le16 ps_num_dtim_intervals;
 } __packed;
 
+#ifdef CONFIG_RSI_WOW
+struct rsi_wowlan_req {
+	struct rsi_cmd_desc desc;
+	u8 sourceid[ETH_ALEN];
+	u16 wow_flags;
+	u16 host_sleep_status;
+} __packed;
+#endif
+
 static inline u32 rsi_get_queueno(u8 *addr, u16 offset)
 {
 	return (le16_to_cpu(*(__le16 *)&addr[offset]) & 0x7000) >> 12;
@@ -641,6 +672,10 @@ int rsi_band_check(struct rsi_common *common, struct ieee80211_channel *chan);
 int rsi_send_rx_filter_frame(struct rsi_common *common, u16 rx_filter_word);
 int rsi_send_radio_params_update(struct rsi_common *common);
 int rsi_set_antenna(struct rsi_common *common, u8 antenna);
+#ifdef CONFIG_RSI_WOW
+int rsi_send_wowlan_request(struct rsi_common *common, u16 flags,
+			    u16 sleep_status);
+#endif
 int rsi_send_ps_request(struct rsi_hw *adapter, bool enable,
 			struct ieee80211_vif *vif);
 #endif
-- 
2.7.4
