Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-we0-f181.google.com ([74.125.82.181]:53488 "EHLO
	mail-we0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759065AbbA3Mdi (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 30 Jan 2015 07:33:38 -0500
Received: by mail-we0-f181.google.com with SMTP id k48so26899648wev.12
        for <linux-wireless@vger.kernel.org>; Fri, 30 Jan 2015 04:33:37 -0800 (PST)
From: Michal Kazior <michal.kazior@tieto.com>
To: ath10k@lists.infradead.org
Cc: linux-wireless@vger.kernel.org,
	Michal Kazior <michal.kazior@tieto.com>
Subject: [PATCH v2 6/7] ath10k: implement tx pause wmi event
Date: Fri, 30 Jan 2015 13:31:25 +0100
Message-Id: <1422621086-28970-7-git-send-email-michal.kazior@tieto.com> (sfid-20150130_133348_898829_DDF12574)
In-Reply-To: <1422621086-28970-1-git-send-email-michal.kazior@tieto.com>
References: <1422607287-12289-1-git-send-email-michal.kazior@tieto.com>
 <1422621086-28970-1-git-send-email-michal.kazior@tieto.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

qca6174 wmi-tlv firmware defines a new wmi event
for host tx pausing (i.e. stop/wake tx queues).

Map these events to ath10k/mac80211 tx queue
control.

This is important for multi-channel throughput
performance.

Signed-off-by: Michal Kazior <michal.kazior@tieto.com>
---

Notes:
    v2:
     * s/thourghput/throughput/ in commit log

 drivers/net/wireless/ath/ath10k/mac.c     | 12 +++++
 drivers/net/wireless/ath/ath10k/wmi-tlv.c | 86 +++++++++++++++++++++++++++++++
 drivers/net/wireless/ath/ath10k/wmi-tlv.h | 42 +++++++++++++++
 3 files changed, 140 insertions(+)

diff --git a/drivers/net/wireless/ath/ath10k/mac.c b/drivers/net/wireless/ath/ath10k/mac.c
index 92355f1..9dab8cb 100644
--- a/drivers/net/wireless/ath/ath10k/mac.c
+++ b/drivers/net/wireless/ath/ath10k/mac.c
@@ -3488,6 +3488,14 @@ err:
 	return ret;
 }
 
+static void ath10k_mac_vif_tx_unlock_all(struct ath10k_vif *arvif)
+{
+	int i;
+
+	for (i = 0; i < BITS_PER_LONG; i++)
+		ath10k_mac_vif_tx_unlock(arvif, i);
+}
+
 static void ath10k_remove_interface(struct ieee80211_hw *hw,
 				    struct ieee80211_vif *vif)
 {
@@ -3540,6 +3548,10 @@ static void ath10k_remove_interface(struct ieee80211_hw *hw,
 			ath10k_warn(ar, "failed to recalc monitor: %d\n", ret);
 	}
 
+	spin_lock_bh(&ar->htt.tx_lock);
+	ath10k_mac_vif_tx_unlock_all(arvif);
+	spin_unlock_bh(&ar->htt.tx_lock);
+
 	mutex_unlock(&ar->conf_mutex);
 }
 
diff --git a/drivers/net/wireless/ath/ath10k/wmi-tlv.c b/drivers/net/wireless/ath/ath10k/wmi-tlv.c
index 0e36b34..3763359 100644
--- a/drivers/net/wireless/ath/ath10k/wmi-tlv.c
+++ b/drivers/net/wireless/ath/ath10k/wmi-tlv.c
@@ -16,6 +16,7 @@
  */
 #include "core.h"
 #include "debug.h"
+#include "mac.h"
 #include "hw.h"
 #include "wmi.h"
 #include "wmi-ops.h"
@@ -62,6 +63,8 @@ static const struct wmi_tlv_policy wmi_tlv_policies[] = {
 		= { .min_len = sizeof(struct wmi_tlv_bcn_tx_status_ev) },
 	[WMI_TLV_TAG_STRUCT_DIAG_DATA_CONTAINER_EVENT]
 		= { .min_len = sizeof(struct wmi_tlv_diag_data_ev) },
+	[WMI_TLV_TAG_STRUCT_TX_PAUSE_EVENT]
+		= { .min_len = sizeof(struct wmi_tlv_tx_pause_ev) },
 };
 
 static int
@@ -296,6 +299,86 @@ static int ath10k_wmi_tlv_event_diag(struct ath10k *ar,
 	return 0;
 }
 
+static int ath10k_wmi_tlv_event_tx_pause(struct ath10k *ar,
+					 struct sk_buff *skb)
+{
+	const void **tb;
+	const struct wmi_tlv_tx_pause_ev *ev;
+	int ret, vdev_id;
+	u32 pause_id, action, vdev_map, peer_id, tid_map;
+	struct ath10k_vif *arvif;
+
+	tb = ath10k_wmi_tlv_parse_alloc(ar, skb->data, skb->len, GFP_ATOMIC);
+	if (IS_ERR(tb)) {
+		ret = PTR_ERR(tb);
+		ath10k_warn(ar, "failed to parse tlv: %d\n", ret);
+		return ret;
+	}
+
+	ev = tb[WMI_TLV_TAG_STRUCT_TX_PAUSE_EVENT];
+	if (!ev) {
+		kfree(tb);
+		return -EPROTO;
+	}
+
+	pause_id = __le32_to_cpu(ev->pause_id);
+	action = __le32_to_cpu(ev->action);
+	vdev_map = __le32_to_cpu(ev->vdev_map);
+	peer_id = __le32_to_cpu(ev->peer_id);
+	tid_map = __le32_to_cpu(ev->tid_map);
+
+	ath10k_dbg(ar, ATH10K_DBG_WMI,
+		   "wmi tlv tx pause pause_id %u action %u vdev_map 0x%08x peer_id %u tid_map 0x%08x\n",
+		   pause_id, action, vdev_map, peer_id, tid_map);
+
+	for (vdev_id = 0; vdev_map; vdev_id++) {
+		if (!(vdev_map & BIT(vdev_id)))
+			continue;
+
+		vdev_map &= ~BIT(vdev_id);
+
+		spin_lock_bh(&ar->htt.tx_lock);
+		spin_lock_bh(&ar->data_lock);
+
+		arvif = ath10k_get_arvif(ar, vdev_id);
+		if (!arvif) {
+			ath10k_warn(ar, "failed to find arvif for vdev %i for tx pause event\n",
+				    vdev_id);
+			spin_unlock_bh(&ar->data_lock);
+			spin_unlock_bh(&ar->htt.tx_lock);
+			continue;
+		}
+
+		/* FIXME: Some pause_id aren't vdev orinted. Instead they are
+		 * peer_id oriented (mostly for AP mode scenarios).
+		 */
+		if (pause_id == WMI_TLV_TX_PAUSE_ID_MCC ||
+		    pause_id == WMI_TLV_TX_PAUSE_ID_P2P_CLI_NOA ||
+		    pause_id == WMI_TLV_TX_PAUSE_ID_P2P_GO_PS ||
+		    pause_id == WMI_TLV_TX_PAUSE_ID_AP_PS ||
+		    pause_id == WMI_TLV_TX_PAUSE_ID_IBSS_PS) {
+			switch (action) {
+			case WMI_TLV_TX_PAUSE_ACTION_STOP:
+				ath10k_mac_vif_tx_lock(arvif, pause_id);
+				break;
+			case WMI_TLV_TX_PAUSE_ACTION_WAKE:
+				ath10k_mac_vif_tx_unlock(arvif, pause_id);
+				break;
+			default:
+				ath10k_warn(ar, "received unknown tx pause action %d on vdev %i, ignoring\n",
+					    action, vdev_id);
+				break;
+			}
+		}
+
+		spin_unlock_bh(&ar->data_lock);
+		spin_unlock_bh(&ar->htt.tx_lock);
+	}
+
+	kfree(tb);
+	return 0;
+}
+
 /***********/
 /* TLV ops */
 /***********/
@@ -417,6 +500,9 @@ static void ath10k_wmi_tlv_op_rx(struct ath10k *ar, struct sk_buff *skb)
 	case WMI_TLV_DIAG_EVENTID:
 		ath10k_wmi_tlv_event_diag(ar, skb);
 		break;
+	case WMI_TLV_TX_PAUSE_EVENTID:
+		ath10k_wmi_tlv_event_tx_pause(ar, skb);
+		break;
 	default:
 		ath10k_warn(ar, "Unknown eventid: %d\n", id);
 		break;
diff --git a/drivers/net/wireless/ath/ath10k/wmi-tlv.h b/drivers/net/wireless/ath/ath10k/wmi-tlv.h
index a05952a..3abc85f 100644
--- a/drivers/net/wireless/ath/ath10k/wmi-tlv.h
+++ b/drivers/net/wireless/ath/ath10k/wmi-tlv.h
@@ -1443,6 +1443,48 @@ struct wmi_tlv_adaptive_qcs {
 	__le32 enable;
 } __packed;
 
+/**
+ * wmi_tlv_tx_pause_id - firmware tx queue pause reason types
+ *
+ * @WMI_TLV_TX_PAUSE_ID_MCC: used for by multi-channel firmware scheduler.
+ *		Only vdev_map is valid.
+ * @WMI_TLV_TX_PAUSE_ID_AP_PEER_PS: peer in AP mode is asleep.
+ *		Only peer_id is valid.
+ * @WMI_TLV_TX_PAUSE_ID_AP_PEER_UAPSD: Only peer_id and tid_map are valid.
+ * @WMI_TLV_TX_PAUSE_ID_P2P_CLI_NOA: Only vdev_map is valid.
+ * @WMI_TLV_TX_PAUSE_ID_P2P_GO_PS: Only vdev_map is valid.
+ * @WMI_TLV_TX_PAUSE_ID_STA_ADD_BA: Only peer_id and tid_map are valid.
+ * @WMI_TLV_TX_PAUSE_ID_AP_PS: When all peers are asleep in AP mode. Only
+ *		vdev_map is valid.
+ * @WMI_TLV_TX_PAUSE_ID_IBSS_PS: When all peers are asleep in IBSS mode. Only
+ *		vdev_map is valid.
+ * @WMI_TLV_TX_PAUSE_ID_HOST: Host itself requested tx pause.
+ */
+enum wmi_tlv_tx_pause_id {
+	WMI_TLV_TX_PAUSE_ID_MCC = 1,
+	WMI_TLV_TX_PAUSE_ID_AP_PEER_PS = 2,
+	WMI_TLV_TX_PAUSE_ID_AP_PEER_UAPSD = 3,
+	WMI_TLV_TX_PAUSE_ID_P2P_CLI_NOA = 4,
+	WMI_TLV_TX_PAUSE_ID_P2P_GO_PS = 5,
+	WMI_TLV_TX_PAUSE_ID_STA_ADD_BA = 6,
+	WMI_TLV_TX_PAUSE_ID_AP_PS = 7,
+	WMI_TLV_TX_PAUSE_ID_IBSS_PS = 8,
+	WMI_TLV_TX_PAUSE_ID_HOST = 21,
+};
+
+enum wmi_tlv_tx_pause_action {
+	WMI_TLV_TX_PAUSE_ACTION_STOP,
+	WMI_TLV_TX_PAUSE_ACTION_WAKE,
+};
+
+struct wmi_tlv_tx_pause_ev {
+	__le32 pause_id;
+	__le32 action;
+	__le32 vdev_map;
+	__le32 peer_id;
+	__le32 tid_map;
+} __packed;
+
 void ath10k_wmi_tlv_attach(struct ath10k *ar);
 
 #endif
-- 
1.8.5.3

