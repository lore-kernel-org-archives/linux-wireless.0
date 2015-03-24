Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-la0-f50.google.com ([209.85.215.50]:36131 "EHLO
	mail-la0-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752146AbbCXMp6 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 24 Mar 2015 08:45:58 -0400
Received: by labe2 with SMTP id e2so83002928lab.3
        for <linux-wireless@vger.kernel.org>; Tue, 24 Mar 2015 05:45:56 -0700 (PDT)
From: Michal Kazior <michal.kazior@tieto.com>
To: ath10k@lists.infradead.org
Cc: linux-wireless@vger.kernel.org,
	Michal Kazior <michal.kazior@tieto.com>
Subject: [PATCH v5 5/7] ath10k: implement tx pause wmi event
Date: Tue, 24 Mar 2015 12:43:11 +0000
Message-Id: <1427200993-7550-6-git-send-email-michal.kazior@tieto.com> (sfid-20150324_134611_354620_8DE3DED5)
In-Reply-To: <1427200993-7550-1-git-send-email-michal.kazior@tieto.com>
References: <1427200993-7550-1-git-send-email-michal.kazior@tieto.com>
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
    
    v4:
     * use ieee80211_iterate_active_interfaces_atomic() instead of ar->arvifs

 drivers/net/wireless/ath/ath10k/mac.c     | 90 +++++++++++++++++++++++++++++++
 drivers/net/wireless/ath/ath10k/mac.h     |  8 +++
 drivers/net/wireless/ath/ath10k/wmi-tlv.c | 48 +++++++++++++++++
 drivers/net/wireless/ath/ath10k/wmi-tlv.h | 42 +++++++++++++++
 4 files changed, 188 insertions(+)

diff --git a/drivers/net/wireless/ath/ath10k/mac.c b/drivers/net/wireless/ath/ath10k/mac.c
index 182e0e54db4a..1d6191d89586 100644
--- a/drivers/net/wireless/ath/ath10k/mac.c
+++ b/drivers/net/wireless/ath/ath10k/mac.c
@@ -28,6 +28,7 @@
 #include "txrx.h"
 #include "testmode.h"
 #include "wmi.h"
+#include "wmi-tlv.h"
 #include "wmi-ops.h"
 #include "wow.h"
 
@@ -2906,6 +2907,83 @@ void ath10k_mac_vif_tx_unlock(struct ath10k_vif *arvif, int reason)
 	ieee80211_wake_queue(ar->hw, arvif->vdev_id);
 }
 
+static void ath10k_mac_vif_handle_tx_pause(struct ath10k_vif *arvif,
+					   enum wmi_tlv_tx_pause_id pause_id,
+					   enum wmi_tlv_tx_pause_action action)
+{
+	struct ath10k *ar = arvif->ar;
+
+	lockdep_assert_held(&ar->htt.tx_lock);
+
+	switch (pause_id) {
+	case WMI_TLV_TX_PAUSE_ID_MCC:
+	case WMI_TLV_TX_PAUSE_ID_P2P_CLI_NOA:
+	case WMI_TLV_TX_PAUSE_ID_P2P_GO_PS:
+	case WMI_TLV_TX_PAUSE_ID_AP_PS:
+	case WMI_TLV_TX_PAUSE_ID_IBSS_PS:
+		switch (action) {
+		case WMI_TLV_TX_PAUSE_ACTION_STOP:
+			ath10k_mac_vif_tx_lock(arvif, pause_id);
+			break;
+		case WMI_TLV_TX_PAUSE_ACTION_WAKE:
+			ath10k_mac_vif_tx_unlock(arvif, pause_id);
+			break;
+		default:
+			ath10k_warn(ar, "received unknown tx pause action %d on vdev %i, ignoring\n",
+				    action, arvif->vdev_id);
+			break;
+		}
+		break;
+	case WMI_TLV_TX_PAUSE_ID_AP_PEER_PS:
+	case WMI_TLV_TX_PAUSE_ID_AP_PEER_UAPSD:
+	case WMI_TLV_TX_PAUSE_ID_STA_ADD_BA:
+	case WMI_TLV_TX_PAUSE_ID_HOST:
+	default:
+		/* FIXME: Some pause_ids aren't vdev specific. Instead they
+		 * target peer_id and tid. Implementing these could improve
+		 * traffic scheduling fairness across multiple connected
+		 * stations in AP/IBSS modes.
+		 */
+		ath10k_dbg(ar, ATH10K_DBG_MAC,
+			   "mac ignoring unsupported tx pause vdev %i id %d\n",
+			   arvif->vdev_id, pause_id);
+		break;
+	}
+}
+
+struct ath10k_mac_tx_pause {
+	u32 vdev_id;
+	enum wmi_tlv_tx_pause_id pause_id;
+	enum wmi_tlv_tx_pause_action action;
+};
+
+static void ath10k_mac_handle_tx_pause_iter(void *data, u8 *mac,
+					    struct ieee80211_vif *vif)
+{
+	struct ath10k_vif *arvif = ath10k_vif_to_arvif(vif);
+	struct ath10k_mac_tx_pause *arg = data;
+
+	ath10k_mac_vif_handle_tx_pause(arvif, arg->pause_id, arg->action);
+}
+
+void ath10k_mac_handle_tx_pause(struct ath10k *ar, u32 vdev_id,
+				enum wmi_tlv_tx_pause_id pause_id,
+				enum wmi_tlv_tx_pause_action action)
+{
+	struct ath10k_mac_tx_pause arg = {
+		.vdev_id = vdev_id,
+		.pause_id = pause_id,
+		.action = action,
+	};
+
+	spin_lock_bh(&ar->htt.tx_lock);
+	ieee80211_iterate_active_interfaces_atomic(ar->hw,
+						   IEEE80211_IFACE_ITER_RESUME_ALL,
+						   ath10k_mac_handle_tx_pause_iter,
+						   &arg);
+	spin_unlock_bh(&ar->htt.tx_lock);
+}
+
 static u8 ath10k_tx_h_get_tid(struct ieee80211_hdr *hdr)
 {
 	if (ieee80211_is_mgmt(hdr->frame_control))
@@ -4161,6 +4239,14 @@ err:
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
@@ -4227,6 +4313,10 @@ static void ath10k_remove_interface(struct ieee80211_hw *hw,
 			ath10k_warn(ar, "failed to recalc monitor: %d\n", ret);
 	}
 
+	spin_lock_bh(&ar->htt.tx_lock);
+	ath10k_mac_vif_tx_unlock_all(arvif);
+	spin_unlock_bh(&ar->htt.tx_lock);
+
 	mutex_unlock(&ar->conf_mutex);
 }
 
diff --git a/drivers/net/wireless/ath/ath10k/mac.h b/drivers/net/wireless/ath/ath10k/mac.h
index e6f6d119031d..e4cceb9f9052 100644
--- a/drivers/net/wireless/ath/ath10k/mac.h
+++ b/drivers/net/wireless/ath/ath10k/mac.h
@@ -23,6 +23,9 @@
 
 #define WEP_KEYID_SHIFT 6
 
+enum wmi_tlv_tx_pause_id;
+enum wmi_tlv_tx_pause_action;
+
 struct ath10k_generic_iter {
 	struct ath10k *ar;
 	int ret;
@@ -53,8 +56,13 @@ void ath10k_mac_vif_beacon_free(struct ath10k_vif *arvif);
 void ath10k_drain_tx(struct ath10k *ar);
 bool ath10k_mac_is_peer_wep_key_set(struct ath10k *ar, const u8 *addr,
 				    u8 keyidx);
+
 void ath10k_mac_handle_beacon(struct ath10k *ar, struct sk_buff *skb);
 void ath10k_mac_handle_beacon_miss(struct ath10k *ar, u32 vdev_id);
+void ath10k_mac_handle_tx_pause(struct ath10k *ar, u32 vdev_id,
+				enum wmi_tlv_tx_pause_id pause_id,
+				enum wmi_tlv_tx_pause_action action);
+
 
 u8 ath10k_mac_hw_rate_to_idx(const struct ieee80211_supported_band *sband,
 			     u8 hw_rate);
diff --git a/drivers/net/wireless/ath/ath10k/wmi-tlv.c b/drivers/net/wireless/ath/ath10k/wmi-tlv.c
index 04a83308778f..73cf3d00c2d0 100644
--- a/drivers/net/wireless/ath/ath10k/wmi-tlv.c
+++ b/drivers/net/wireless/ath/ath10k/wmi-tlv.c
@@ -16,6 +16,7 @@
  */
 #include "core.h"
 #include "debug.h"
+#include "mac.h"
 #include "hw.h"
 #include "mac.h"
 #include "wmi.h"
@@ -70,6 +71,8 @@ static const struct wmi_tlv_policy wmi_tlv_policies[] = {
 		= { .min_len = sizeof(struct wmi_tlv_roam_ev) },
 	[WMI_TLV_TAG_STRUCT_WOW_EVENT_INFO]
 		= { .min_len = sizeof(struct wmi_tlv_wow_event_info) },
+	[WMI_TLV_TAG_STRUCT_TX_PAUSE_EVENT]
+		= { .min_len = sizeof(struct wmi_tlv_tx_pause_ev) },
 };
 
 static int
@@ -339,6 +342,48 @@ static int ath10k_wmi_tlv_event_p2p_noa(struct ath10k *ar,
 		   vdev_id, noa->num_descriptors);
 
 	ath10k_p2p_noa_update_by_vdev_id(ar, vdev_id, noa);
+	kfree(tb);
+	return 0;
+}
+
+static int ath10k_wmi_tlv_event_tx_pause(struct ath10k *ar,
+					 struct sk_buff *skb)
+{
+	const void **tb;
+	const struct wmi_tlv_tx_pause_ev *ev;
+	int ret, vdev_id;
+	u32 pause_id, action, vdev_map, peer_id, tid_map;
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
+		ath10k_mac_handle_tx_pause(ar, vdev_id, pause_id, action);
+	}
 
 	kfree(tb);
 	return 0;
@@ -468,6 +513,9 @@ static void ath10k_wmi_tlv_op_rx(struct ath10k *ar, struct sk_buff *skb)
 	case WMI_TLV_P2P_NOA_EVENTID:
 		ath10k_wmi_tlv_event_p2p_noa(ar, skb);
 		break;
+	case WMI_TLV_TX_PAUSE_EVENTID:
+		ath10k_wmi_tlv_event_tx_pause(ar, skb);
+		break;
 	default:
 		ath10k_warn(ar, "Unknown eventid: %d\n", id);
 		break;
diff --git a/drivers/net/wireless/ath/ath10k/wmi-tlv.h b/drivers/net/wireless/ath/ath10k/wmi-tlv.h
index 8d41492f3aff..ad655c44afdb 100644
--- a/drivers/net/wireless/ath/ath10k/wmi-tlv.h
+++ b/drivers/net/wireless/ath/ath10k/wmi-tlv.h
@@ -1580,6 +1580,48 @@ struct wmi_tlv_adaptive_qcs {
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
2.1.4

