Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pf0-f193.google.com ([209.85.192.193]:36377 "EHLO
        mail-pf0-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753080AbdHKNqH (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 11 Aug 2017 09:46:07 -0400
Received: by mail-pf0-f193.google.com with SMTP id t83so3532841pfj.3
        for <linux-wireless@vger.kernel.org>; Fri, 11 Aug 2017 06:46:06 -0700 (PDT)
From: Amitkumar Karwar <amitkarwar@gmail.com>
To: Kalle Valo <kvalo@codeaurora.org>
Cc: linux-wireless@vger.kernel.org,
        Amitkumar Karwar <amit.karwar@redpinesignals.com>,
        Prameela Rani Garnepudi <prameela.j04cs@gmail.com>
Subject: [PATCH 04/11] rsi: add beacon changes for AP mode
Date: Fri, 11 Aug 2017 19:11:22 +0530
Message-Id: <1502458889-9690-5-git-send-email-amitkarwar@gmail.com> (sfid-20170811_154612_890573_B4D946F4)
In-Reply-To: <1502458889-9690-1-git-send-email-amitkarwar@gmail.com>
References: <1502458889-9690-1-git-send-email-amitkarwar@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Prameela Rani Garnepudi <prameela.j04cs@gmail.com>

Mac80211 config parameter BEACON_ENABLE is handled. When VAP
capabilities frame with AP mode is configured to firmware, beacon
events start coming to host at each PreTBTT. At this time, beacon
is taken from mac80211, descriptor is prepared and send to firmware.

Signed-off-by: Prameela Rani Garnepudi <prameela.j04cs@gmail.com>
Signed-off-by: Amitkumar Karwar <amit.karwar@redpinesignals.com>
---
 drivers/net/wireless/rsi/rsi_91x_core.c     | 15 +++++--
 drivers/net/wireless/rsi/rsi_91x_hal.c      | 65 ++++++++++++++++++++++++++++-
 drivers/net/wireless/rsi/rsi_91x_mac80211.c | 12 ++++++
 drivers/net/wireless/rsi/rsi_91x_mgmt.c     | 48 ++++++++++++++++++---
 drivers/net/wireless/rsi/rsi_hal.h          |  2 +
 drivers/net/wireless/rsi/rsi_main.h         | 13 +++---
 drivers/net/wireless/rsi/rsi_mgmt.h         | 11 +++++
 7 files changed, 152 insertions(+), 14 deletions(-)

diff --git a/drivers/net/wireless/rsi/rsi_91x_core.c b/drivers/net/wireless/rsi/rsi_91x_core.c
index 88a1a56..6cfda86 100644
--- a/drivers/net/wireless/rsi/rsi_91x_core.c
+++ b/drivers/net/wireless/rsi/rsi_91x_core.c
@@ -16,6 +16,7 @@
 
 #include "rsi_mgmt.h"
 #include "rsi_common.h"
+#include "rsi_hal.h"
 
 /**
  * rsi_determine_min_weight_queue() - This function determines the queue with
@@ -136,6 +137,10 @@ static u8 rsi_core_determine_hal_queue(struct rsi_common *common)
 	u8 q_num = INVALID_QUEUE;
 	u8 ii = 0;
 
+	if (skb_queue_len(&common->tx_queue[MGMT_BEACON_Q])) {
+		q_num = MGMT_BEACON_Q;
+		return q_num;
+	}
 	if (skb_queue_len(&common->tx_queue[MGMT_SOFT_Q])) {
 		if (!common->mgmt_q_block)
 			q_num = MGMT_SOFT_Q;
@@ -291,10 +296,14 @@ void rsi_core_qos_processor(struct rsi_common *common)
 			break;
 		}
 
-		if (q_num == MGMT_SOFT_Q)
+		if (q_num == MGMT_SOFT_Q) {
 			status = rsi_send_mgmt_pkt(common, skb);
-		else
+		} else if (q_num == MGMT_BEACON_Q) {
+			status = rsi_send_pkt_to_bus(common, skb);
+			dev_kfree_skb(skb);
+		} else {
 			status = rsi_send_data_pkt(common, skb);
+		}
 
 		if (status) {
 			mutex_unlock(&common->tx_lock);
@@ -358,7 +367,7 @@ void rsi_core_xmit(struct rsi_common *common, struct sk_buff *skb)
 		tx_params->sta_id = 0;
 	}
 
-	if ((q_num != MGMT_SOFT_Q) &&
+	if ((q_num < MGMT_SOFT_Q) &&
 	    ((skb_queue_len(&common->tx_queue[q_num]) + 1) >=
 	     DATA_QUEUE_WATER_MARK)) {
 		rsi_dbg(ERR_ZONE, "%s: sw queue full\n", __func__);
diff --git a/drivers/net/wireless/rsi/rsi_91x_hal.c b/drivers/net/wireless/rsi/rsi_91x_hal.c
index 4addcc0..1ed7332 100644
--- a/drivers/net/wireless/rsi/rsi_91x_hal.c
+++ b/drivers/net/wireless/rsi/rsi_91x_hal.c
@@ -25,7 +25,15 @@ static struct ta_metadata metadata_flash_content[] = {
 	{"rsi/rs9113_wlan_qspi.rps", 0x00010000},
 };
 
-/*This function prepares descriptor for given management packet*/
+int rsi_send_pkt_to_bus(struct rsi_common *common, struct sk_buff *skb)
+{
+	struct rsi_hw *adapter = common->priv;
+	int status;
+
+	status = adapter->host_intf_ops->write_pkt(common->priv,
+						   skb->data, skb->len);
+	return status;
+}
 
 static int rsi_prepare_mgmt_desc(struct rsi_common *common, struct sk_buff *skb)
 {
@@ -306,6 +314,61 @@ int rsi_send_mgmt_pkt(struct rsi_common *common,
 	return status;
 }
 
+int rsi_prepare_beacon(struct rsi_common *common, struct sk_buff *skb)
+{
+	struct rsi_hw *adapter = (struct rsi_hw *)common->priv;
+	struct rsi_data_desc *bcn_frm;
+	struct ieee80211_hw *hw = common->priv->hw;
+	struct ieee80211_conf *conf = &hw->conf;
+	struct sk_buff *mac_bcn;
+	u8 vap_id = 0;
+	u16 tim_offset;
+
+	mac_bcn = ieee80211_beacon_get_tim(adapter->hw,
+					   adapter->vifs[adapter->sc_nvifs - 1],
+					   &tim_offset, NULL);
+	if (!mac_bcn) {
+		rsi_dbg(ERR_ZONE, "Failed to get beacon from mac80211\n");
+		return -EINVAL;
+	}
+
+	common->beacon_cnt++;
+	bcn_frm = (struct rsi_data_desc *)skb->data;
+	rsi_set_len_qno(&bcn_frm->len_qno, mac_bcn->len, RSI_WIFI_DATA_Q);
+	bcn_frm->header_len = MIN_802_11_HDR_LEN;
+	bcn_frm->frame_info = cpu_to_le16(RSI_DATA_DESC_MAC_BBP_INFO |
+					  RSI_DATA_DESC_NO_ACK_IND |
+					  RSI_DATA_DESC_BEACON_FRAME |
+					  RSI_DATA_DESC_INSERT_TSF |
+					  RSI_DATA_DESC_INSERT_SEQ_NO |
+					  RATE_INFO_ENABLE);
+	bcn_frm->rate_info = cpu_to_le16(vap_id << 14);
+	bcn_frm->qid_tid = BEACON_HW_Q;
+
+	if (conf_is_ht40_plus(conf)) {
+		bcn_frm->bbp_info = cpu_to_le16(LOWER_20_ENABLE);
+		bcn_frm->bbp_info |= cpu_to_le16(LOWER_20_ENABLE >> 12);
+	} else if (conf_is_ht40_minus(conf)) {
+		bcn_frm->bbp_info = cpu_to_le16(UPPER_20_ENABLE);
+		bcn_frm->bbp_info |= cpu_to_le16(UPPER_20_ENABLE >> 12);
+	}
+
+	if (common->band == NL80211_BAND_2GHZ)
+		bcn_frm->bbp_info |= cpu_to_le16(RSI_RATE_1);
+	else
+		bcn_frm->bbp_info |= cpu_to_le16(RSI_RATE_6);
+
+	if (mac_bcn->data[tim_offset + 2] == 0)
+		bcn_frm->frame_info |= cpu_to_le16(RSI_DATA_DESC_DTIM_BEACON);
+
+	memcpy(&skb->data[FRAME_DESC_SZ], mac_bcn->data, mac_bcn->len);
+	skb_put(skb, mac_bcn->len + FRAME_DESC_SZ);
+
+	dev_kfree_skb(mac_bcn);
+
+	return 0;
+}
+
 static void bl_cmd_timeout(unsigned long priv)
 {
 	struct rsi_hw *adapter = (struct rsi_hw *)priv;
diff --git a/drivers/net/wireless/rsi/rsi_91x_mac80211.c b/drivers/net/wireless/rsi/rsi_91x_mac80211.c
index 99446bb..6038a2f 100644
--- a/drivers/net/wireless/rsi/rsi_91x_mac80211.c
+++ b/drivers/net/wireless/rsi/rsi_91x_mac80211.c
@@ -652,6 +652,18 @@ static void rsi_mac80211_bss_info_changed(struct ieee80211_hw *hw,
 			common->cqm_info.rssi_thold,
 			common->cqm_info.rssi_hyst);
 	}
+
+	if ((changed & BSS_CHANGED_BEACON_ENABLED) &&
+	    (vif->type == NL80211_IFTYPE_AP)) {
+		if (bss->enable_beacon) {
+			rsi_dbg(INFO_ZONE, "===> BEACON ENABLED <===\n");
+			common->beacon_enabled = 1;
+		} else {
+			rsi_dbg(INFO_ZONE, "===> BEACON DISABLED <===\n");
+			common->beacon_enabled = 0;
+		}
+	}
+
 	mutex_unlock(&common->mutex);
 }
 
diff --git a/drivers/net/wireless/rsi/rsi_91x_mgmt.c b/drivers/net/wireless/rsi/rsi_91x_mgmt.c
index 233a418..e47fc0d 100644
--- a/drivers/net/wireless/rsi/rsi_91x_mgmt.c
+++ b/drivers/net/wireless/rsi/rsi_91x_mgmt.c
@@ -18,6 +18,7 @@
 #include "rsi_mgmt.h"
 #include "rsi_common.h"
 #include "rsi_ps.h"
+#include "rsi_hal.h"
 
 static struct bootup_params boot_params_20 = {
 	.magic_number = cpu_to_le16(0x5aa5),
@@ -1518,6 +1519,31 @@ int rsi_set_antenna(struct rsi_common *common, u8 antenna)
 	return rsi_send_internal_mgmt_frame(common, skb);
 }
 
+static int rsi_send_beacon(struct rsi_common *common)
+{
+	struct sk_buff *skb = NULL;
+	u8 dword_align_bytes = 0;
+
+	skb = dev_alloc_skb(MAX_MGMT_PKT_SIZE);
+	if (!skb)
+		return -ENOMEM;
+
+	memset(skb->data, 0, MAX_MGMT_PKT_SIZE);
+
+	dword_align_bytes = ((unsigned long)skb->data & 0x3f);
+	if (dword_align_bytes)
+		skb_pull(skb, (64 - dword_align_bytes));
+	if (rsi_prepare_beacon(common, skb)) {
+		rsi_dbg(ERR_ZONE, "Failed to prepare beacon\n");
+		return -EINVAL;
+	}
+	skb_queue_tail(&common->tx_queue[MGMT_BEACON_Q], skb);
+	rsi_set_event(&common->tx_thread.event);
+	rsi_dbg(DATA_TX_ZONE, "%s: Added to beacon queue\n", __func__);
+
+	return 0;
+}
+
 /**
  * rsi_handle_ta_confirm_type() - This function handles the confirm frames.
  * @common: Pointer to the driver private structure.
@@ -1722,21 +1748,33 @@ int rsi_mgmt_pkt_recv(struct rsi_common *common, u8 *msg)
 	rsi_dbg(FSM_ZONE, "%s: Msg Len: %d, Msg Type: %4x\n",
 		__func__, msg_len, msg_type);
 
-	if (msg_type == TA_CONFIRM_TYPE) {
+	switch (msg_type) {
+	case TA_CONFIRM_TYPE:
 		return rsi_handle_ta_confirm_type(common, msg);
-	} else if (msg_type == CARD_READY_IND) {
+	case CARD_READY_IND:
 		rsi_dbg(FSM_ZONE, "%s: Card ready indication received\n",
 			__func__);
 		return rsi_handle_card_ready(common, msg);
-	} else if (msg_type == TX_STATUS_IND) {
+	case TX_STATUS_IND:
 		if (msg[15] == PROBEREQ_CONFIRM) {
 			common->mgmt_q_block = false;
 			rsi_dbg(FSM_ZONE, "%s: Probe confirm received\n",
 				__func__);
 		}
-	} else if (msg_type == RX_DOT11_MGMT) {
+		break;
+	case BEACON_EVENT_IND:
+		rsi_dbg(INFO_ZONE, "Beacon event\n");
+		if (common->fsm_state != FSM_MAC_INIT_DONE)
+			return -1;
+		if (common->iface_down)
+			return -1;
+		if (!common->beacon_enabled)
+			return -1;
+		rsi_send_beacon(common);
+		break;
+	case RX_DOT11_MGMT:
 		return rsi_mgmt_pkt_to_core(common, msg, msg_len);
-	} else {
+	default:
 		rsi_dbg(INFO_ZONE, "Received packet type: 0x%x\n", msg_type);
 	}
 	return 0;
diff --git a/drivers/net/wireless/rsi/rsi_hal.h b/drivers/net/wireless/rsi/rsi_hal.h
index 00c6a0c..297f4ce 100644
--- a/drivers/net/wireless/rsi/rsi_hal.h
+++ b/drivers/net/wireless/rsi/rsi_hal.h
@@ -144,5 +144,7 @@ struct rsi_data_desc {
 } __packed;
 
 int rsi_hal_device_init(struct rsi_hw *adapter);
+int rsi_prepare_beacon(struct rsi_common *common, struct sk_buff *skb);
+int rsi_send_pkt_to_bus(struct rsi_common *common, struct sk_buff *skb);
 
 #endif
diff --git a/drivers/net/wireless/rsi/rsi_main.h b/drivers/net/wireless/rsi/rsi_main.h
index 9f5f33f..169e2f9 100644
--- a/drivers/net/wireless/rsi/rsi_main.h
+++ b/drivers/net/wireless/rsi/rsi_main.h
@@ -72,7 +72,7 @@ extern __printf(2, 3) void rsi_dbg(u32 zone, const char *fmt, ...);
 #define MULTICAST_WATER_MARK            200
 #define MAC_80211_HDR_FRAME_CONTROL     0
 #define WME_NUM_AC                      4
-#define NUM_SOFT_QUEUES                 5
+#define NUM_SOFT_QUEUES                 6
 #define MAX_HW_QUEUES                   12
 #define INVALID_QUEUE                   0xff
 #define MAX_CONTINUOUS_VO_PKTS          8
@@ -131,7 +131,8 @@ enum edca_queue {
 	BE_Q,
 	VI_Q,
 	VO_Q,
-	MGMT_SOFT_Q
+	MGMT_SOFT_Q,
+	MGMT_BEACON_Q
 };
 
 struct security_info {
@@ -148,8 +149,8 @@ struct wmm_qinfo {
 };
 
 struct transmit_q_stats {
-	u32 total_tx_pkt_send[NUM_EDCA_QUEUES + 1];
-	u32 total_tx_pkt_freed[NUM_EDCA_QUEUES + 1];
+	u32 total_tx_pkt_send[NUM_EDCA_QUEUES + 2];
+	u32 total_tx_pkt_freed[NUM_EDCA_QUEUES + 2];
 };
 
 struct vif_priv {
@@ -199,7 +200,7 @@ struct rsi_common {
 	struct version_info fw_ver;
 
 	struct rsi_thread tx_thread;
-	struct sk_buff_head tx_queue[NUM_EDCA_QUEUES + 1];
+	struct sk_buff_head tx_queue[NUM_EDCA_QUEUES + 2];
 	/* Mutex declaration */
 	struct mutex mutex;
 	/* Mutex used for tx thread */
@@ -263,6 +264,8 @@ struct rsi_common {
 	u8 dtim_cnt;
 
 	/* AP mode parameters */
+	u8 beacon_enabled;
+	u16 beacon_cnt;
 	struct rsi_sta stations[RSI_MAX_ASSOC_STAS + 1];
 	int num_stations;
 	int max_stations;
diff --git a/drivers/net/wireless/rsi/rsi_mgmt.h b/drivers/net/wireless/rsi/rsi_mgmt.h
index 9093ba6..a00aa10 100644
--- a/drivers/net/wireless/rsi/rsi_mgmt.h
+++ b/drivers/net/wireless/rsi/rsi_mgmt.h
@@ -49,6 +49,7 @@
 #define TA_CONFIRM_TYPE                 0x01
 #define RX_DOT11_MGMT                   0x02
 #define TX_STATUS_IND                   0x04
+#define BEACON_EVENT_IND		0x08
 #define PROBEREQ_CONFIRM                2
 #define CARD_READY_IND                  0x00
 
@@ -187,6 +188,16 @@
 	 IEEE80211_WMM_IE_STA_QOSINFO_AC_BE | \
 	 IEEE80211_WMM_IE_STA_QOSINFO_AC_BK)
 
+#define RSI_DATA_DESC_MAC_BBP_INFO	BIT(0)
+#define RSI_DATA_DESC_NO_ACK_IND	BIT(9)
+#define RSI_DATA_DESC_QOS_EN		BIT(12)
+#define RSI_DATA_DESC_NORMAL_FRAME	0x00
+#define RSI_DATA_DESC_DTIM_BEACON_GATED_FRAME	BIT(10)
+#define RSI_DATA_DESC_BEACON_FRAME	BIT(11)
+#define RSI_DATA_DESC_DTIM_BEACON	(BIT(10) | BIT(11))
+#define RSI_DATA_DESC_INSERT_TSF	BIT(15)
+#define RSI_DATA_DESC_INSERT_SEQ_NO	BIT(2)
+
 enum opmode {
 	AP_OPMODE = 0,
 	STA_OPMODE,
-- 
2.7.4
