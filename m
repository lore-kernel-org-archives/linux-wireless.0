Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wolverine02.qualcomm.com ([199.106.114.251]:4692 "EHLO
	wolverine02.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933607Ab1JYOJF (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 25 Oct 2011 10:09:05 -0400
From: Vasanthakumar Thiagarajan <vthiagar@qca.qualcomm.com>
To: <kvalo@qca.qualcomm.com>
CC: <linux-wireless@vger.kernel.org>
Subject: [PATCH V2 19/31] ath6kl: Remove net_device from ath6kl
Date: Tue, 25 Oct 2011 19:34:14 +0530
Message-ID: <1319551466-29070-20-git-send-email-vthiagar@qca.qualcomm.com> (sfid-20111025_160909_390590_C490F3DE)
In-Reply-To: <1319551466-29070-1-git-send-email-vthiagar@qca.qualcomm.com>
References: <1319551466-29070-1-git-send-email-vthiagar@qca.qualcomm.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Use one which is available in vif structure instead.

Signed-off-by: Vasanthakumar Thiagarajan <vthiagar@qca.qualcomm.com>
---
 drivers/net/wireless/ath/ath6kl/cfg80211.c |    1 -
 drivers/net/wireless/ath/ath6kl/core.h     |    1 -
 drivers/net/wireless/ath/ath6kl/init.c     |    6 +++---
 drivers/net/wireless/ath/ath6kl/main.c     |    6 +++---
 drivers/net/wireless/ath/ath6kl/txrx.c     |   16 ++++++++--------
 5 files changed, 14 insertions(+), 16 deletions(-)

diff --git a/drivers/net/wireless/ath/ath6kl/cfg80211.c b/drivers/net/wireless/ath/ath6kl/cfg80211.c
index e870c9c..636b64e 100644
--- a/drivers/net/wireless/ath/ath6kl/cfg80211.c
+++ b/drivers/net/wireless/ath/ath6kl/cfg80211.c
@@ -2115,7 +2115,6 @@ struct net_device *ath6kl_interface_add(struct ath6kl *ar, char *name,
 	vif->wdev.iftype = type;
 	vif->fw_vif_idx = fw_vif_idx;
 	ar->wdev = &vif->wdev;
-	ar->net_dev = ndev;
 
 	init_netdev(ndev);
 
diff --git a/drivers/net/wireless/ath/ath6kl/core.h b/drivers/net/wireless/ath/ath6kl/core.h
index 3fb8898..4db0b15 100644
--- a/drivers/net/wireless/ath/ath6kl/core.h
+++ b/drivers/net/wireless/ath/ath6kl/core.h
@@ -446,7 +446,6 @@ enum ath6kl_dev_state {
 
 struct ath6kl {
 	struct device *dev;
-	struct net_device *net_dev;
 	struct wiphy *wiphy;
 	struct ath6kl_bmi bmi;
 	const struct ath6kl_hif_ops *hif_ops;
diff --git a/drivers/net/wireless/ath/ath6kl/init.c b/drivers/net/wireless/ath/ath6kl/init.c
index fb78a2a..a874665 100644
--- a/drivers/net/wireless/ath/ath6kl/init.c
+++ b/drivers/net/wireless/ath/ath6kl/init.c
@@ -521,7 +521,7 @@ void ath6kl_core_free(struct ath6kl *ar)
 
 int ath6kl_unavail_ev(struct ath6kl *ar)
 {
-	ath6kl_destroy(ar->net_dev, 1);
+	ath6kl_destroy(ar->vif->ndev, 1);
 
 	return 0;
 }
@@ -1417,7 +1417,7 @@ static int ath6kl_init(struct ath6kl *ar)
 
 
 	ath6kl_dbg(ATH6KL_DBG_TRC, "%s: name=%s dev=0x%p, ar=0x%p\n",
-			__func__, ar->net_dev->name, ar->net_dev, ar);
+			__func__, ndev->name, ndev, ar);
 
 	/*
 	 * The reason we have to wait for the target here is that the
@@ -1579,8 +1579,8 @@ err_wq:
 
 void ath6kl_stop_txrx(struct ath6kl *ar)
 {
-	struct net_device *ndev = ar->net_dev;
 	struct ath6kl_vif *vif = ar->vif;
+	struct net_device *ndev = vif->ndev;
 
 	if (!ndev)
 		return;
diff --git a/drivers/net/wireless/ath/ath6kl/main.c b/drivers/net/wireless/ath/ath6kl/main.c
index 19b64ae..023624d 100644
--- a/drivers/net/wireless/ath/ath6kl/main.c
+++ b/drivers/net/wireless/ath/ath6kl/main.c
@@ -938,7 +938,7 @@ void ath6kl_deep_sleep_enable(struct ath6kl *ar)
 
 	switch (vif->sme_state) {
 	case SME_CONNECTING:
-		cfg80211_connect_result(ar->net_dev, vif->bssid, NULL, 0,
+		cfg80211_connect_result(vif->ndev, vif->bssid, NULL, 0,
 					NULL, 0,
 					WLAN_STATUS_UNSPECIFIED_FAILURE,
 					GFP_KERNEL);
@@ -950,7 +950,7 @@ void ath6kl_deep_sleep_enable(struct ath6kl *ar)
 		 * suspend, why? Need to send disconnected event in that
 		 * state.
 		 */
-		cfg80211_disconnected(ar->net_dev, 0, NULL, 0, GFP_KERNEL);
+		cfg80211_disconnected(vif->ndev, 0, NULL, 0, GFP_KERNEL);
 		break;
 	}
 
@@ -995,7 +995,7 @@ static const char *get_hw_id_string(u32 id)
 void ath6kl_ready_event(void *devt, u8 *datap, u32 sw_ver, u32 abi_ver)
 {
 	struct ath6kl *ar = devt;
-	struct net_device *dev = ar->net_dev;
+	struct net_device *dev = ar->vif->ndev;
 
 	memcpy(dev->dev_addr, datap, ETH_ALEN);
 	ath6kl_dbg(ATH6KL_DBG_TRC, "%s: mac addr = %pM\n",
diff --git a/drivers/net/wireless/ath/ath6kl/txrx.c b/drivers/net/wireless/ath/ath6kl/txrx.c
index 50ff9a4..7e2d601 100644
--- a/drivers/net/wireless/ath/ath6kl/txrx.c
+++ b/drivers/net/wireless/ath/ath6kl/txrx.c
@@ -478,7 +478,7 @@ stop_net_queues:
 	spin_lock_bh(&ar->lock);
 	set_bit(NETQ_STOPPED, &vif->flags);
 	spin_unlock_bh(&ar->lock);
-	netif_stop_queue(ar->net_dev);
+	netif_stop_queue(vif->ndev);
 
 	return HTC_SEND_FULL_KEEP;
 }
@@ -619,7 +619,7 @@ void ath6kl_tx_complete(void *context, struct list_head *packet_queue)
 
 	if (test_bit(CONNECTED, &vif->flags)) {
 		if (!flushing)
-			netif_wake_queue(ar->net_dev);
+			netif_wake_queue(vif->ndev);
 	}
 
 	if (wake_event)
@@ -1086,12 +1086,12 @@ void ath6kl_rx(struct htc_target *target, struct htc_packet *packet)
 	ath6kl_dbg_dump(ATH6KL_DBG_RAW_BYTES, __func__, "rx ",
 			skb->data, skb->len);
 
-	skb->dev = ar->net_dev;
+	skb->dev = vif->ndev;
 
 	if (!test_bit(WMI_ENABLED, &ar->flag)) {
 		if (EPPING_ALIGNMENT_PAD > 0)
 			skb_pull(skb, EPPING_ALIGNMENT_PAD);
-		ath6kl_deliver_frames_to_nw_stack(ar->net_dev, skb);
+		ath6kl_deliver_frames_to_nw_stack(vif->ndev, skb);
 		return;
 	}
 
@@ -1174,7 +1174,7 @@ void ath6kl_rx(struct htc_target *target, struct htc_packet *packet)
 				while ((skbuff = skb_dequeue(&conn->psq))
 				       != NULL) {
 					spin_unlock_bh(&conn->psq_lock);
-					ath6kl_data_tx(skbuff, ar->net_dev);
+					ath6kl_data_tx(skbuff, vif->ndev);
 					spin_lock_bh(&conn->psq_lock);
 				}
 				spin_unlock_bh(&conn->psq_lock);
@@ -1230,7 +1230,7 @@ void ath6kl_rx(struct htc_target *target, struct htc_packet *packet)
 		return;
 	}
 
-	if (!(ar->net_dev->flags & IFF_UP)) {
+	if (!(vif->ndev->flags & IFF_UP)) {
 		dev_kfree_skb(skb);
 		return;
 	}
@@ -1261,7 +1261,7 @@ void ath6kl_rx(struct htc_target *target, struct htc_packet *packet)
 			}
 		}
 		if (skb1)
-			ath6kl_data_tx(skb1, ar->net_dev);
+			ath6kl_data_tx(skb1, vif->ndev);
 
 		if (skb == NULL) {
 			/* nothing to deliver up the stack */
@@ -1277,7 +1277,7 @@ void ath6kl_rx(struct htc_target *target, struct htc_packet *packet)
 		/* aggregation code will handle the skb */
 		return;
 
-	ath6kl_deliver_frames_to_nw_stack(ar->net_dev, skb);
+	ath6kl_deliver_frames_to_nw_stack(vif->ndev, skb);
 }
 
 static void aggr_timeout(unsigned long arg)
-- 
1.7.0.4

