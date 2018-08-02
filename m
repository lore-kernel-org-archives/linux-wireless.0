Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pg1-f194.google.com ([209.85.215.194]:36877 "EHLO
        mail-pg1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726125AbeHBFkr (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 2 Aug 2018 01:40:47 -0400
Received: by mail-pg1-f194.google.com with SMTP id n7-v6so452578pgq.4
        for <linux-wireless@vger.kernel.org>; Wed, 01 Aug 2018 20:51:42 -0700 (PDT)
From: Sushant Kumar Mishra <sushant2k1513@gmail.com>
To: Kalle Valo <kvalo@codeaurora.org>
Cc: linux-wireless@vger.kernel.org,
        Siva Rebbagondla <siva.rebbagondla@redpinesignals.com>,
        Sanjay Kumar Konduri <sanjay.konduri@redpinesignals.com>,
        Prameela Rani Garnepudi <prameela.j04cs@gmail.com>,
        Sushant Kumar Mishra <sushant.mishra@redpinesignals.com>
Subject: [PATCH v3 2/2] rsi: add support for hardware scan offload
Date: Thu,  2 Aug 2018 09:00:46 +0530
Message-Id: <1533180646-8028-2-git-send-email-sushant2k1513@gmail.com> (sfid-20180802_055144_512337_A1BAAF95)
In-Reply-To: <1533180646-8028-1-git-send-email-sushant2k1513@gmail.com>
References: <1533180646-8028-1-git-send-email-sushant2k1513@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Prameela Rani Garnepudi <prameela.j04cs@gmail.com>

With the current approach of scanning, roaming delays are observed.
Firmware has support for back ground scanning. To get this advantage,
mac80211 hardware scan is implemented, which decides type of scan to
do based on connected state.

When station is in not connected state, this returns operation not
supported(-EPERM) to trigger software scan in mac80211. In case of
connected state background scan will be triggered.

Signed-off-by: Prameela Rani Garnepudi <prameela.j04cs@gmail.com>
Signed-off-by: Siva Rebbagondla <siva.rebbagondla@redpinesignals.com>
Signed-off-by: Sushant Kumar Mishra <sushant.mishra@redpinesignals.com>
---
changes in v3: replaced rsi_prepare_probe_request() with ieee80211_probereq_get() [Kvalo]
changes in v2: Nothing
---
 drivers/net/wireless/rsi/rsi_91x_hal.c      |   3 +
 drivers/net/wireless/rsi/rsi_91x_mac80211.c |  67 ++++++++++++++
 drivers/net/wireless/rsi/rsi_91x_main.c     |   1 +
 drivers/net/wireless/rsi/rsi_91x_mgmt.c     | 133 ++++++++++++++++++++++++++++
 drivers/net/wireless/rsi/rsi_main.h         |  22 +++++
 drivers/net/wireless/rsi/rsi_mgmt.h         |  35 ++++++++
 6 files changed, 261 insertions(+)

diff --git a/drivers/net/wireless/rsi/rsi_91x_hal.c b/drivers/net/wireless/rsi/rsi_91x_hal.c
index 27e6baf..f91b9b7 100644
--- a/drivers/net/wireless/rsi/rsi_91x_hal.c
+++ b/drivers/net/wireless/rsi/rsi_91x_hal.c
@@ -102,6 +102,9 @@ int rsi_prepare_mgmt_desc(struct rsi_common *common, struct sk_buff *skb)
 	mgmt_desc->frame_type = TX_DOT11_MGMT;
 	mgmt_desc->header_len = MIN_802_11_HDR_LEN;
 	mgmt_desc->xtend_desc_size = header_size - FRAME_DESC_SZ;
+
+	if (ieee80211_is_probe_req(wh->frame_control))
+		mgmt_desc->frame_info = cpu_to_le16(RSI_INSERT_SEQ_IN_FW);
 	mgmt_desc->frame_info |= cpu_to_le16(RATE_INFO_ENABLE);
 	if (is_broadcast_ether_addr(wh->addr1))
 		mgmt_desc->frame_info |= cpu_to_le16(RSI_BROADCAST_PKT);
diff --git a/drivers/net/wireless/rsi/rsi_91x_mac80211.c b/drivers/net/wireless/rsi/rsi_91x_mac80211.c
index 4e510cb..0fc5f36 100644
--- a/drivers/net/wireless/rsi/rsi_91x_mac80211.c
+++ b/drivers/net/wireless/rsi/rsi_91x_mac80211.c
@@ -229,6 +229,68 @@ static void rsi_register_rates_channels(struct rsi_hw *adapter, int band)
 	/* sbands->ht_cap.mcs.rx_highest = 0x82; */
 }
 
+static int rsi_mac80211_hw_scan_start(struct ieee80211_hw *hw,
+				      struct ieee80211_vif *vif,
+				      struct ieee80211_scan_request *hw_req)
+{
+	struct cfg80211_scan_request *scan_req = &hw_req->req;
+	struct rsi_hw *adapter = hw->priv;
+	struct rsi_common *common = adapter->priv;
+	struct ieee80211_bss_conf *bss = &vif->bss_conf;
+
+	rsi_dbg(INFO_ZONE, "***** Hardware scan start *****\n");
+
+	if (common->fsm_state != FSM_MAC_INIT_DONE)
+		return -ENODEV;
+
+	if ((common->wow_flags & RSI_WOW_ENABLED) ||
+	    scan_req->n_channels == 0)
+		return -EINVAL;
+
+	/* Scan already in progress. So return */
+	if (common->bgscan_en)
+		return -EBUSY;
+
+	/* If not yet connected return, in order
+	 * to start sw_scan from mac80211
+	 */
+	if (!bss->assoc)
+		return -EPERM;
+
+	mutex_lock(&common->mutex);
+	common->hwscan = scan_req;
+	if (!rsi_send_bgscan_params(common, RSI_START_BGSCAN)) {
+		if (!rsi_send_bgscan_probe_req(common, vif)) {
+			rsi_dbg(INFO_ZONE, "Background scan started...\n");
+			common->bgscan_en = true;
+		}
+	}
+	mutex_unlock(&common->mutex);
+
+	return 0;
+}
+
+static void rsi_mac80211_cancel_hw_scan(struct ieee80211_hw *hw,
+					struct ieee80211_vif *vif)
+{
+	struct rsi_hw *adapter = hw->priv;
+	struct rsi_common *common = adapter->priv;
+	struct cfg80211_scan_info info;
+
+	rsi_dbg(INFO_ZONE, "***** Hardware scan stop *****\n");
+	mutex_lock(&common->mutex);
+
+	if (common->bgscan_en) {
+		if (!rsi_send_bgscan_params(common, RSI_STOP_BGSCAN))
+			common->bgscan_en = false;
+		info.aborted = false;
+		ieee80211_scan_completed(adapter->hw, &info);
+		rsi_dbg(INFO_ZONE, "Back ground scan cancelled\b\n");
+	}
+	common->hwscan = NULL;
+	mutex_unlock(&common->mutex);
+}
+
 /**
  * rsi_mac80211_detach() - This function is used to de-initialize the
  *			   Mac80211 stack.
@@ -1917,6 +1979,8 @@ static const struct ieee80211_ops mac80211_ops = {
 	.suspend = rsi_mac80211_suspend,
 	.resume  = rsi_mac80211_resume,
 #endif
+	.hw_scan = rsi_mac80211_hw_scan_start,
+	.cancel_hw_scan = rsi_mac80211_cancel_hw_scan,
 };
 
 /**
@@ -1999,6 +2063,9 @@ int rsi_mac80211_attach(struct rsi_common *common)
 	common->max_stations = wiphy->max_ap_assoc_sta;
 	rsi_dbg(ERR_ZONE, "Max Stations Allowed = %d\n", common->max_stations);
 	hw->sta_data_size = sizeof(struct rsi_sta);
+
+	wiphy->max_scan_ssids = RSI_MAX_SCAN_SSIDS;
+	wiphy->max_scan_ie_len = RSI_MAX_SCAN_IE_LEN;
 	wiphy->flags = WIPHY_FLAG_REPORTS_OBSS;
 	wiphy->flags |= WIPHY_FLAG_AP_UAPSD;
 	wiphy->features |= NL80211_FEATURE_INACTIVITY_TIMER;
diff --git a/drivers/net/wireless/rsi/rsi_91x_main.c b/drivers/net/wireless/rsi/rsi_91x_main.c
index 01d99ed..ca3a55e 100644
--- a/drivers/net/wireless/rsi/rsi_91x_main.c
+++ b/drivers/net/wireless/rsi/rsi_91x_main.c
@@ -328,6 +328,7 @@ struct rsi_hw *rsi_91x_init(u16 oper_mode)
 	}
 
 	rsi_default_ps_params(adapter);
+	init_bgscan_params(common);
 	spin_lock_init(&adapter->ps_lock);
 	timer_setup(&common->roc_timer, rsi_roc_timeout, 0);
 	init_completion(&common->wlan_init_completion);
diff --git a/drivers/net/wireless/rsi/rsi_91x_mgmt.c b/drivers/net/wireless/rsi/rsi_91x_mgmt.c
index 1095df7..4042414 100644
--- a/drivers/net/wireless/rsi/rsi_91x_mgmt.c
+++ b/drivers/net/wireless/rsi/rsi_91x_mgmt.c
@@ -15,6 +15,7 @@
  */
 
 #include <linux/etherdevice.h>
+#include <linux/timer.h>
 #include "rsi_mgmt.h"
 #include "rsi_common.h"
 #include "rsi_ps.h"
@@ -236,6 +237,18 @@ static void rsi_set_default_parameters(struct rsi_common *common)
 	common->dtim_cnt = RSI_DTIM_COUNT;
 }
 
+void init_bgscan_params(struct rsi_common *common)
+{
+	memset((u8 *)&common->bgscan, 0, sizeof(struct rsi_bgscan_params));
+	common->bgscan.bgscan_threshold = RSI_DEF_BGSCAN_THRLD;
+	common->bgscan.roam_threshold = RSI_DEF_ROAM_THRLD;
+	common->bgscan.bgscan_periodicity = RSI_BGSCAN_PERIODICITY;
+	common->bgscan.num_bgscan_channels = 0;
+	common->bgscan.two_probe = 1;
+	common->bgscan.active_scan_duration = RSI_ACTIVE_SCAN_TIME;
+	common->bgscan.passive_scan_duration = RSI_PASSIVE_SCAN_TIME;
+}
+
 /**
  * rsi_set_contention_vals() - This function sets the contention values for the
  *			       backoff procedure.
@@ -1628,6 +1641,107 @@ int rsi_send_wowlan_request(struct rsi_common *common, u16 flags,
 }
 #endif
 
+int rsi_send_bgscan_params(struct rsi_common *common, int enable)
+{
+	struct rsi_bgscan_params *params = &common->bgscan;
+	struct cfg80211_scan_request *scan_req = common->hwscan;
+	struct rsi_bgscan_config *bgscan;
+	struct sk_buff *skb;
+	u16 frame_len = sizeof(*bgscan);
+	u8 i;
+
+	rsi_dbg(MGMT_TX_ZONE, "%s: Sending bgscan params frame\n", __func__);
+
+	skb = dev_alloc_skb(frame_len);
+	if (!skb)
+		return -ENOMEM;
+	memset(skb->data, 0, frame_len);
+
+	bgscan = (struct rsi_bgscan_config *)skb->data;
+	rsi_set_len_qno(&bgscan->desc_dword0.len_qno,
+			(frame_len - FRAME_DESC_SZ), RSI_WIFI_MGMT_Q);
+	bgscan->desc_dword0.frame_type = BG_SCAN_PARAMS;
+	bgscan->bgscan_threshold = cpu_to_le16(params->bgscan_threshold);
+	bgscan->roam_threshold = cpu_to_le16(params->roam_threshold);
+	if (enable)
+		bgscan->bgscan_periodicity =
+			cpu_to_le16(params->bgscan_periodicity);
+	bgscan->active_scan_duration =
+			cpu_to_le16(params->active_scan_duration);
+	bgscan->passive_scan_duration =
+			cpu_to_le16(params->passive_scan_duration);
+	bgscan->two_probe = params->two_probe;
+
+	bgscan->num_bgscan_channels = scan_req->n_channels;
+	for (i = 0; i < bgscan->num_bgscan_channels; i++)
+		bgscan->channels2scan[i] =
+			cpu_to_le16(scan_req->channels[i]->hw_value);
+
+	skb_put(skb, frame_len);
+
+	return rsi_send_internal_mgmt_frame(common, skb);
+}
+
+/* This function sends the probe request to be used by firmware in
+ * background scan
+ */
+int rsi_send_bgscan_probe_req(struct rsi_common *common,
+			      struct ieee80211_vif *vif)
+{
+	struct cfg80211_scan_request *scan_req = common->hwscan;
+	struct rsi_bgscan_probe *bgscan;
+	struct sk_buff *skb;
+	struct sk_buff *probereq_skb;
+	u16 frame_len = sizeof(*bgscan);
+	size_t ssid_len = 0;
+	u8 *ssid = NULL;
+
+	rsi_dbg(MGMT_TX_ZONE,
+		"%s: Sending bgscan probe req frame\n", __func__);
+
+	if (common->priv->sc_nvifs <= 0)
+		return -ENODEV;
+
+	if (scan_req->n_ssids) {
+		ssid = scan_req->ssids[0].ssid;
+		ssid_len = scan_req->ssids[0].ssid_len;
+	}
+
+	skb = dev_alloc_skb(frame_len + MAX_BGSCAN_PROBE_REQ_LEN);
+	if (!skb)
+		return -ENOMEM;
+	memset(skb->data, 0, frame_len + MAX_BGSCAN_PROBE_REQ_LEN);
+
+	bgscan = (struct rsi_bgscan_probe *)skb->data;
+	bgscan->desc_dword0.frame_type = BG_SCAN_PROBE_REQ;
+	bgscan->flags = cpu_to_le16(HOST_BG_SCAN_TRIG);
+	if (common->band == NL80211_BAND_5GHZ) {
+		bgscan->mgmt_rate = cpu_to_le16(RSI_RATE_6);
+		bgscan->def_chan = cpu_to_le16(40);
+	} else {
+		bgscan->mgmt_rate = cpu_to_le16(RSI_RATE_1);
+		bgscan->def_chan = cpu_to_le16(11);
+	}
+	bgscan->channel_scan_time = cpu_to_le16(RSI_CHANNEL_SCAN_TIME);
+
+	probereq_skb = ieee80211_probereq_get(common->priv->hw, vif->addr, ssid,
+					      ssid_len, scan_req->ie_len);
+
+	memcpy(&skb->data[frame_len], probereq_skb->data, probereq_skb->len);
+
+	bgscan->probe_req_length = cpu_to_le16(probereq_skb->len);
+
+	rsi_set_len_qno(&bgscan->desc_dword0.len_qno,
+			(frame_len - FRAME_DESC_SZ + probereq_skb->len),
+			RSI_WIFI_MGMT_Q);
+
+	skb_put(skb, frame_len + probereq_skb->len);
+
+	dev_kfree_skb(probereq_skb);
+
+	return rsi_send_internal_mgmt_frame(common, skb);
+}
+
 /**
  * rsi_handle_ta_confirm_type() - This function handles the confirm frames.
  * @common: Pointer to the driver private structure.
@@ -1771,9 +1885,28 @@ static int rsi_handle_ta_confirm_type(struct rsi_common *common,
 			return 0;
 		}
 		break;
+
+	case SCAN_REQUEST:
+		rsi_dbg(INFO_ZONE, "Set channel confirm\n");
+		break;
+
 	case WAKEUP_SLEEP_REQUEST:
 		rsi_dbg(INFO_ZONE, "Wakeup/Sleep confirmation.\n");
 		return rsi_handle_ps_confirm(adapter, msg);
+
+	case BG_SCAN_PROBE_REQ:
+		rsi_dbg(INFO_ZONE, "BG scan complete event\n");
+		if (common->bgscan_en) {
+			struct cfg80211_scan_info info;
+
+			if (!rsi_send_bgscan_params(common, RSI_STOP_BGSCAN))
+				common->bgscan_en = 0;
+			info.aborted = false;
+			ieee80211_scan_completed(adapter->hw, &info);
+		}
+		rsi_dbg(INFO_ZONE, "Background scan completed\n");
+		break;
+
 	default:
 		rsi_dbg(INFO_ZONE, "%s: Invalid TA confirm pkt received\n",
 			__func__);
diff --git a/drivers/net/wireless/rsi/rsi_main.h b/drivers/net/wireless/rsi/rsi_main.h
index a084f22..cb0e46f8 100644
--- a/drivers/net/wireless/rsi/rsi_main.h
+++ b/drivers/net/wireless/rsi/rsi_main.h
@@ -164,6 +164,24 @@ struct transmit_q_stats {
 	u32 total_tx_pkt_freed[NUM_EDCA_QUEUES + 2];
 };
 
+#define MAX_BGSCAN_CHANNELS_DUAL_BAND	38
+#define MAX_BGSCAN_PROBE_REQ_LEN	0x64
+#define RSI_DEF_BGSCAN_THRLD		0x0
+#define RSI_DEF_ROAM_THRLD		0xa
+#define RSI_BGSCAN_PERIODICITY		0x1e
+#define RSI_ACTIVE_SCAN_TIME		0x14
+#define RSI_PASSIVE_SCAN_TIME		0x46
+#define RSI_CHANNEL_SCAN_TIME		20
+struct rsi_bgscan_params {
+	u16 bgscan_threshold;
+	u16 roam_threshold;
+	u16 bgscan_periodicity;
+	u8 num_bgscan_channels;
+	u8 two_probe;
+	u16 active_scan_duration;
+	u16 passive_scan_duration;
+};
+
 struct vif_priv {
 	bool is_ht;
 	bool sgi;
@@ -289,6 +307,10 @@ struct rsi_common {
 
 	bool eapol4_confirm;
 	void *bt_adapter;
+
+	struct cfg80211_scan_request *hwscan;
+	struct rsi_bgscan_params bgscan;
+	bool bgscan_en;
 };
 
 struct eepromrw_info {
diff --git a/drivers/net/wireless/rsi/rsi_mgmt.h b/drivers/net/wireless/rsi/rsi_mgmt.h
index 359fbdf..ea83faa 100644
--- a/drivers/net/wireless/rsi/rsi_mgmt.h
+++ b/drivers/net/wireless/rsi/rsi_mgmt.h
@@ -228,6 +228,9 @@
 #define RSI_MAX_TX_AGGR_FRMS		8
 #define RSI_MAX_RX_AGGR_FRMS		8
 
+#define RSI_MAX_SCAN_SSIDS		16
+#define RSI_MAX_SCAN_IE_LEN		256
+
 enum opmode {
 	RSI_OPMODE_UNSUPPORTED = -1,
 	RSI_OPMODE_AP = 0,
@@ -623,6 +626,34 @@ struct rsi_wowlan_req {
 	u16 host_sleep_status;
 } __packed;
 
+#define RSI_START_BGSCAN		1
+#define RSI_STOP_BGSCAN			0
+#define HOST_BG_SCAN_TRIG		BIT(4)
+struct rsi_bgscan_config {
+	struct rsi_cmd_desc_dword0 desc_dword0;
+	__le64 reserved;
+	__le32 reserved1;
+	__le16 bgscan_threshold;
+	__le16 roam_threshold;
+	__le16 bgscan_periodicity;
+	u8 num_bgscan_channels;
+	u8 two_probe;
+	__le16 active_scan_duration;
+	__le16 passive_scan_duration;
+	__le16 channels2scan[MAX_BGSCAN_CHANNELS_DUAL_BAND];
+} __packed;
+
+struct rsi_bgscan_probe {
+	struct rsi_cmd_desc_dword0 desc_dword0;
+	__le64 reserved;
+	__le32 reserved1;
+	__le16 mgmt_rate;
+	__le16 flags;
+	__le16 def_chan;
+	__le16 channel_scan_time;
+	__le16 probe_req_length;
+} __packed;
+
 static inline u32 rsi_get_queueno(u8 *addr, u16 offset)
 {
 	return (le16_to_cpu(*(__le16 *)&addr[offset]) & 0x7000) >> 12;
@@ -694,4 +725,8 @@ int rsi_send_wowlan_request(struct rsi_common *common, u16 flags,
 #endif
 int rsi_send_ps_request(struct rsi_hw *adapter, bool enable,
 			struct ieee80211_vif *vif);
+void init_bgscan_params(struct rsi_common *common);
+int rsi_send_bgscan_params(struct rsi_common *common, int enable);
+int rsi_send_bgscan_probe_req(struct rsi_common *common,
+			      struct ieee80211_vif *vif);
 #endif
-- 
2.5.5
