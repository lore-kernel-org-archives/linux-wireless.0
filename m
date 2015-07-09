Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-lb0-f174.google.com ([209.85.217.174]:34341 "EHLO
	mail-lb0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751651AbbGILIy (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 9 Jul 2015 07:08:54 -0400
Received: by lbnk3 with SMTP id k3so72935401lbn.1
        for <linux-wireless@vger.kernel.org>; Thu, 09 Jul 2015 04:08:52 -0700 (PDT)
From: Michal Kazior <michal.kazior@tieto.com>
To: ath10k@lists.infradead.org
Cc: linux-wireless@vger.kernel.org,
	Michal Kazior <michal.kazior@tieto.com>
Subject: [PATCH 5/6] ath10k: fix per-vif queue locking
Date: Thu,  9 Jul 2015 13:08:38 +0200
Message-Id: <1436440119-30231-6-git-send-email-michal.kazior@tieto.com> (sfid-20150709_130902_643820_592712E8)
In-Reply-To: <1436440119-30231-1-git-send-email-michal.kazior@tieto.com>
References: <1436440119-30231-1-git-send-email-michal.kazior@tieto.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Whenever any vdev was supposed to be paused all Tx
queues were stopped (except offchannel) instead of
only these associated with the given vdev.

This caused subtle issues with
multi-channel/multi-vif scenarios, e.g.
authentication of station vif could sometimes fail
depending on fw tx pause request timing.

Fixes: b4aa539dd8f2 ("ath10k: implement tx pause wmi event")
Signed-off-by: Michal Kazior <michal.kazior@tieto.com>
---
 drivers/net/wireless/ath/ath10k/mac.c     | 47 +++++++++----------------------
 drivers/net/wireless/ath/ath10k/mac.h     |  6 ++--
 drivers/net/wireless/ath/ath10k/wmi-tlv.c | 32 +++++++++++++++++----
 3 files changed, 44 insertions(+), 41 deletions(-)

diff --git a/drivers/net/wireless/ath/ath10k/mac.c b/drivers/net/wireless/ath/ath10k/mac.c
index e25e6a8f44a5..0ef568c36db9 100644
--- a/drivers/net/wireless/ath/ath10k/mac.c
+++ b/drivers/net/wireless/ath/ath10k/mac.c
@@ -3034,38 +3034,16 @@ static void ath10k_mac_vif_handle_tx_pause(struct ath10k_vif *arvif,
 
 	lockdep_assert_held(&ar->htt.tx_lock);
 
-	switch (pause_id) {
-	case WMI_TLV_TX_PAUSE_ID_MCC:
-	case WMI_TLV_TX_PAUSE_ID_P2P_CLI_NOA:
-	case WMI_TLV_TX_PAUSE_ID_P2P_GO_PS:
-	case WMI_TLV_TX_PAUSE_ID_AP_PS:
-	case WMI_TLV_TX_PAUSE_ID_IBSS_PS:
-		switch (action) {
-		case WMI_TLV_TX_PAUSE_ACTION_STOP:
-			ath10k_mac_vif_tx_lock(arvif, pause_id);
-			break;
-		case WMI_TLV_TX_PAUSE_ACTION_WAKE:
-			ath10k_mac_vif_tx_unlock(arvif, pause_id);
-			break;
-		default:
-			ath10k_warn(ar, "received unknown tx pause action %d on vdev %i, ignoring\n",
-				    action, arvif->vdev_id);
-			break;
-		}
+	switch (action) {
+	case WMI_TLV_TX_PAUSE_ACTION_STOP:
+		ath10k_mac_vif_tx_lock(arvif, pause_id);
+		break;
+	case WMI_TLV_TX_PAUSE_ACTION_WAKE:
+		ath10k_mac_vif_tx_unlock(arvif, pause_id);
 		break;
-	case WMI_TLV_TX_PAUSE_ID_AP_PEER_PS:
-	case WMI_TLV_TX_PAUSE_ID_AP_PEER_UAPSD:
-	case WMI_TLV_TX_PAUSE_ID_STA_ADD_BA:
-	case WMI_TLV_TX_PAUSE_ID_HOST:
 	default:
-		/* FIXME: Some pause_ids aren't vdev specific. Instead they
-		 * target peer_id and tid. Implementing these could improve
-		 * traffic scheduling fairness across multiple connected
-		 * stations in AP/IBSS modes.
-		 */
-		ath10k_dbg(ar, ATH10K_DBG_MAC,
-			   "mac ignoring unsupported tx pause vdev %i id %d\n",
-			   arvif->vdev_id, pause_id);
+		ath10k_warn(ar, "received unknown tx pause action %d on vdev %i, ignoring\n",
+			    action, arvif->vdev_id);
 		break;
 	}
 }
@@ -3082,12 +3060,15 @@ static void ath10k_mac_handle_tx_pause_iter(void *data, u8 *mac,
 	struct ath10k_vif *arvif = ath10k_vif_to_arvif(vif);
 	struct ath10k_mac_tx_pause *arg = data;
 
+	if (arvif->vdev_id != arg->vdev_id)
+		return;
+
 	ath10k_mac_vif_handle_tx_pause(arvif, arg->pause_id, arg->action);
 }
 
-void ath10k_mac_handle_tx_pause(struct ath10k *ar, u32 vdev_id,
-				enum wmi_tlv_tx_pause_id pause_id,
-				enum wmi_tlv_tx_pause_action action)
+void ath10k_mac_handle_tx_pause_vdev(struct ath10k *ar, u32 vdev_id,
+				     enum wmi_tlv_tx_pause_id pause_id,
+				     enum wmi_tlv_tx_pause_action action)
 {
 	struct ath10k_mac_tx_pause arg = {
 		.vdev_id = vdev_id,
diff --git a/drivers/net/wireless/ath/ath10k/mac.h b/drivers/net/wireless/ath/ath10k/mac.h
index b291f063705c..e3cefe4c7cfd 100644
--- a/drivers/net/wireless/ath/ath10k/mac.h
+++ b/drivers/net/wireless/ath/ath10k/mac.h
@@ -61,9 +61,9 @@ int ath10k_mac_vif_chan(struct ieee80211_vif *vif,
 
 void ath10k_mac_handle_beacon(struct ath10k *ar, struct sk_buff *skb);
 void ath10k_mac_handle_beacon_miss(struct ath10k *ar, u32 vdev_id);
-void ath10k_mac_handle_tx_pause(struct ath10k *ar, u32 vdev_id,
-				enum wmi_tlv_tx_pause_id pause_id,
-				enum wmi_tlv_tx_pause_action action);
+void ath10k_mac_handle_tx_pause_vdev(struct ath10k *ar, u32 vdev_id,
+				     enum wmi_tlv_tx_pause_id pause_id,
+				     enum wmi_tlv_tx_pause_action action);
 
 u8 ath10k_mac_hw_rate_to_idx(const struct ieee80211_supported_band *sband,
 			     u8 hw_rate);
diff --git a/drivers/net/wireless/ath/ath10k/wmi-tlv.c b/drivers/net/wireless/ath/ath10k/wmi-tlv.c
index ced35a1e0675..4189d4a90ce0 100644
--- a/drivers/net/wireless/ath/ath10k/wmi-tlv.c
+++ b/drivers/net/wireless/ath/ath10k/wmi-tlv.c
@@ -377,12 +377,34 @@ static int ath10k_wmi_tlv_event_tx_pause(struct ath10k *ar,
 		   "wmi tlv tx pause pause_id %u action %u vdev_map 0x%08x peer_id %u tid_map 0x%08x\n",
 		   pause_id, action, vdev_map, peer_id, tid_map);
 
-	for (vdev_id = 0; vdev_map; vdev_id++) {
-		if (!(vdev_map & BIT(vdev_id)))
-			continue;
+	switch (pause_id) {
+	case WMI_TLV_TX_PAUSE_ID_MCC:
+	case WMI_TLV_TX_PAUSE_ID_P2P_CLI_NOA:
+	case WMI_TLV_TX_PAUSE_ID_P2P_GO_PS:
+	case WMI_TLV_TX_PAUSE_ID_AP_PS:
+	case WMI_TLV_TX_PAUSE_ID_IBSS_PS:
+		for (vdev_id = 0; vdev_map; vdev_id++) {
+			if (!(vdev_map & BIT(vdev_id)))
+				continue;
 
-		vdev_map &= ~BIT(vdev_id);
-		ath10k_mac_handle_tx_pause(ar, vdev_id, pause_id, action);
+			vdev_map &= ~BIT(vdev_id);
+			ath10k_mac_handle_tx_pause_vdev(ar, vdev_id, pause_id,
+							action);
+		}
+		break;
+	case WMI_TLV_TX_PAUSE_ID_AP_PEER_PS:
+	case WMI_TLV_TX_PAUSE_ID_AP_PEER_UAPSD:
+	case WMI_TLV_TX_PAUSE_ID_STA_ADD_BA:
+	case WMI_TLV_TX_PAUSE_ID_HOST:
+		ath10k_dbg(ar, ATH10K_DBG_MAC,
+			   "mac ignoring unsupported tx pause id %d\n",
+			   pause_id);
+		break;
+	default:
+		ath10k_dbg(ar, ATH10K_DBG_MAC,
+			   "mac ignoring unknown tx pause vdev %d\n",
+			   pause_id);
+		break;
 	}
 
 	kfree(tb);
-- 
2.1.4

