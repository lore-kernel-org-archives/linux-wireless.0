Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-lb0-f180.google.com ([209.85.217.180]:40149 "EHLO
	mail-lb0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753676AbbBZMZZ (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 26 Feb 2015 07:25:25 -0500
Received: by lbdu10 with SMTP id u10so10403235lbd.7
        for <linux-wireless@vger.kernel.org>; Thu, 26 Feb 2015 04:25:24 -0800 (PST)
From: Michal Kazior <michal.kazior@tieto.com>
To: ath10k@lists.infradead.org
Cc: linux-wireless@vger.kernel.org,
	Michal Kazior <michal.kazior@tieto.com>
Subject: [PATCH 2/2] ath10k: implement handling of p2p noa event
Date: Thu, 26 Feb 2015 13:23:18 +0100
Message-Id: <1424953398-18809-2-git-send-email-michal.kazior@tieto.com> (sfid-20150226_132530_140282_B5998751)
In-Reply-To: <1424953398-18809-1-git-send-email-michal.kazior@tieto.com>
References: <1424953398-18809-1-git-send-email-michal.kazior@tieto.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Since new wmi-tlv firmware doesn't have SWBA event
the only way to deliver P2P NoA information is
through a new dedicated event.

This fixes P2P GO Probe Responses to include P2P
NoA when appropriate on the new firmware.

Signed-off-by: Michal Kazior <michal.kazior@tieto.com>
---
 drivers/net/wireless/ath/ath10k/p2p.c     | 32 ++++++++++++++++++++++++
 drivers/net/wireless/ath/ath10k/p2p.h     |  2 ++
 drivers/net/wireless/ath/ath10k/wmi-tlv.c | 41 +++++++++++++++++++++++++++++++
 drivers/net/wireless/ath/ath10k/wmi-tlv.h |  4 +++
 4 files changed, 79 insertions(+)

diff --git a/drivers/net/wireless/ath/ath10k/p2p.c b/drivers/net/wireless/ath/ath10k/p2p.c
index 79d7485..c0b6ffa 100644
--- a/drivers/net/wireless/ath/ath10k/p2p.c
+++ b/drivers/net/wireless/ath/ath10k/p2p.c
@@ -16,6 +16,7 @@
 
 #include "core.h"
 #include "wmi.h"
+#include "mac.h"
 #include "p2p.h"
 
 static void ath10k_p2p_noa_ie_fill(u8 *data, size_t len,
@@ -122,3 +123,34 @@ void ath10k_p2p_noa_update(struct ath10k_vif *arvif,
 	__ath10k_p2p_noa_update(arvif, noa);
 	spin_unlock_bh(&ar->data_lock);
 }
+
+struct ath10k_p2p_noa_arg {
+	u32 vdev_id;
+	const struct wmi_p2p_noa_info *noa;
+};
+
+static void ath10k_p2p_noa_update_vdev_iter(void *data, u8 *mac,
+					    struct ieee80211_vif *vif)
+{
+	struct ath10k_vif *arvif = ath10k_vif_to_arvif(vif);
+	struct ath10k_p2p_noa_arg *arg = data;
+
+	if (arvif->vdev_id != arg->vdev_id)
+		return;
+
+	ath10k_p2p_noa_update(arvif, arg->noa);
+}
+
+void ath10k_p2p_noa_update_by_vdev_id(struct ath10k *ar, u32 vdev_id,
+				      const struct wmi_p2p_noa_info *noa)
+{
+	struct ath10k_p2p_noa_arg arg = {
+		.vdev_id = vdev_id,
+		.noa = noa,
+	};
+
+	ieee80211_iterate_active_interfaces_atomic(ar->hw,
+						   IEEE80211_IFACE_ITER_NORMAL,
+						   ath10k_p2p_noa_update_vdev_iter,
+						   &arg);
+}
diff --git a/drivers/net/wireless/ath/ath10k/p2p.h b/drivers/net/wireless/ath/ath10k/p2p.h
index 171d30d6..7be616e2 100644
--- a/drivers/net/wireless/ath/ath10k/p2p.h
+++ b/drivers/net/wireless/ath/ath10k/p2p.h
@@ -22,5 +22,7 @@ struct wmi_p2p_noa_info;
 
 void ath10k_p2p_noa_update(struct ath10k_vif *arvif,
 			   const struct wmi_p2p_noa_info *noa);
+void ath10k_p2p_noa_update_by_vdev_id(struct ath10k *ar, u32 vdev_id,
+				      const struct wmi_p2p_noa_info *noa);
 
 #endif
diff --git a/drivers/net/wireless/ath/ath10k/wmi-tlv.c b/drivers/net/wireless/ath/ath10k/wmi-tlv.c
index f34baa0..15728e0 100644
--- a/drivers/net/wireless/ath/ath10k/wmi-tlv.c
+++ b/drivers/net/wireless/ath/ath10k/wmi-tlv.c
@@ -20,6 +20,7 @@
 #include "wmi.h"
 #include "wmi-ops.h"
 #include "wmi-tlv.h"
+#include "p2p.h"
 
 /***************/
 /* TLV helpers */
@@ -62,6 +63,8 @@ static const struct wmi_tlv_policy wmi_tlv_policies[] = {
 		= { .min_len = sizeof(struct wmi_tlv_bcn_tx_status_ev) },
 	[WMI_TLV_TAG_STRUCT_DIAG_DATA_CONTAINER_EVENT]
 		= { .min_len = sizeof(struct wmi_tlv_diag_data_ev) },
+	[WMI_TLV_TAG_STRUCT_P2P_NOA_EVENT]
+		= { .min_len = sizeof(struct wmi_tlv_p2p_noa_ev) },
 };
 
 static int
@@ -296,6 +299,41 @@ static int ath10k_wmi_tlv_event_diag(struct ath10k *ar,
 	return 0;
 }
 
+static int ath10k_wmi_tlv_event_p2p_noa(struct ath10k *ar,
+					struct sk_buff *skb)
+{
+	const void **tb;
+	const struct wmi_tlv_p2p_noa_ev *ev;
+	const struct wmi_p2p_noa_info *noa;
+	int ret, vdev_id;
+
+	tb = ath10k_wmi_tlv_parse_alloc(ar, skb->data, skb->len, GFP_ATOMIC);
+	if (IS_ERR(tb)) {
+		ret = PTR_ERR(tb);
+		ath10k_warn(ar, "failed to parse tlv: %d\n", ret);
+		return ret;
+	}
+
+	ev = tb[WMI_TLV_TAG_STRUCT_P2P_NOA_EVENT];
+	noa = tb[WMI_TLV_TAG_STRUCT_P2P_NOA_INFO];
+
+	if (!ev || !noa) {
+		kfree(tb);
+		return -EPROTO;
+	}
+
+	vdev_id = __le32_to_cpu(ev->vdev_id);
+
+	ath10k_dbg(ar, ATH10K_DBG_WMI,
+		   "wmi tlv p2p noa vdev_id %i descriptors %hhu\n",
+		   vdev_id, noa->num_descriptors);
+
+	ath10k_p2p_noa_update_by_vdev_id(ar, vdev_id, noa);
+
+	kfree(tb);
+	return 0;
+}
+
 /***********/
 /* TLV ops */
 /***********/
@@ -417,6 +455,9 @@ static void ath10k_wmi_tlv_op_rx(struct ath10k *ar, struct sk_buff *skb)
 	case WMI_TLV_DIAG_EVENTID:
 		ath10k_wmi_tlv_event_diag(ar, skb);
 		break;
+	case WMI_TLV_P2P_NOA_EVENTID:
+		ath10k_wmi_tlv_event_p2p_noa(ar, skb);
+		break;
 	default:
 		ath10k_warn(ar, "Unknown eventid: %d\n", id);
 		break;
diff --git a/drivers/net/wireless/ath/ath10k/wmi-tlv.h b/drivers/net/wireless/ath/ath10k/wmi-tlv.h
index d7a31e1..352becb 100644
--- a/drivers/net/wireless/ath/ath10k/wmi-tlv.h
+++ b/drivers/net/wireless/ath/ath10k/wmi-tlv.h
@@ -1448,6 +1448,10 @@ struct wmi_tlv_stats_ev {
 	__le32 num_chan_stats;
 } __packed;
 
+struct wmi_tlv_p2p_noa_ev {
+	__le32 vdev_id;
+} __packed;
+
 void ath10k_wmi_tlv_attach(struct ath10k *ar);
 
 #endif
-- 
1.8.5.3

