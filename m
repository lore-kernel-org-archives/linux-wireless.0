Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-yx0-f174.google.com ([209.85.213.174]:56232 "EHLO
	mail-yx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753046Ab1AUDEz (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 20 Jan 2011 22:04:55 -0500
Received: by yxt3 with SMTP id 3so402107yxt.19
        for <linux-wireless@vger.kernel.org>; Thu, 20 Jan 2011 19:04:55 -0800 (PST)
From: Sujith <m.sujith@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Message-ID: <19768.63400.912018.285601@gargle.gargle.HOWL>
Date: Fri, 21 Jan 2011 08:34:08 +0530
To: linux-wireless@vger.kernel.org
CC: ath9k-devel@lists.ath9k.org
Subject: [RFC/WIP 33/33] ath9k_htc: Drain packets on station removal
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Sujith Manoharan <Sujith.Manoharan@atheros.com>

When a station entry is removed, there could still be
pending packets destined for that station in the HIF layer.
Sending these to the target is not necessary, so drain them
in the driver itself.

Signed-off-by: Sujith Manoharan <Sujith.Manoharan@atheros.com>
---
 drivers/net/wireless/ath/ath9k/hif_usb.c      |   34 +++++++++++++++++++++++++
 drivers/net/wireless/ath/ath9k/htc.h          |    1 +
 drivers/net/wireless/ath/ath9k/htc_drv_main.c |    3 ++
 drivers/net/wireless/ath/ath9k/htc_drv_txrx.c |    8 ++++++
 drivers/net/wireless/ath/ath9k/htc_hst.c      |    5 +++
 drivers/net/wireless/ath/ath9k/htc_hst.h      |    2 +
 6 files changed, 53 insertions(+), 0 deletions(-)

diff --git a/drivers/net/wireless/ath/ath9k/hif_usb.c b/drivers/net/wireless/ath/ath9k/hif_usb.c
index 2c96960..9384e83 100644
--- a/drivers/net/wireless/ath/ath9k/hif_usb.c
+++ b/drivers/net/wireless/ath/ath9k/hif_usb.c
@@ -352,6 +352,39 @@ static void hif_usb_stop(void *hif_handle, u8 pipe_id)
 	}
 }
 
+static inline bool check_index(struct sk_buff *skb, u8 idx)
+{
+	struct ath9k_htc_tx_ctl *tx_ctl;
+
+	tx_ctl = HTC_SKB_CB(skb);
+
+	if ((tx_ctl->type == ATH9K_HTC_AMPDU) &&
+	    (tx_ctl->sta_idx == idx))
+		return true;
+
+	return false;
+}
+
+static void hif_usb_drain(void *hif_handle, u8 idx)
+{
+	struct hif_device_usb *hif_dev = (struct hif_device_usb *)hif_handle;
+	struct sk_buff *skb, *tmp;
+	unsigned long flags;
+
+	spin_lock_irqsave(&hif_dev->tx.tx_lock, flags);
+
+	skb_queue_walk_safe(&hif_dev->tx.tx_skb_queue, skb, tmp) {
+		if (check_index(skb, idx)) {
+			__skb_unlink(skb, &hif_dev->tx.tx_skb_queue);
+			hif_dev->tx.tx_skb_cnt--;
+			dev_kfree_skb_any(skb);
+			TX_STAT_INC(skb_dropped);
+		}
+	}
+
+	spin_unlock_irqrestore(&hif_dev->tx.tx_lock, flags);
+}
+
 static int hif_usb_send(void *hif_handle, u8 pipe_id, struct sk_buff *skb)
 {
 	struct hif_device_usb *hif_dev = (struct hif_device_usb *)hif_handle;
@@ -383,6 +416,7 @@ static struct ath9k_htc_hif hif_usb = {
 
 	.start = hif_usb_start,
 	.stop = hif_usb_stop,
+	.drain = hif_usb_drain,
 	.send = hif_usb_send,
 };
 
diff --git a/drivers/net/wireless/ath/ath9k/htc.h b/drivers/net/wireless/ath/ath9k/htc.h
index ec3511d..bbed402 100644
--- a/drivers/net/wireless/ath/ath9k/htc.h
+++ b/drivers/net/wireless/ath/ath9k/htc.h
@@ -288,6 +288,7 @@ struct ath9k_htc_rx {
 
 struct ath9k_htc_tx_ctl {
 	u8 type; /* ATH9K_HTC_* */
+	u8 sta_idx;
 };
 
 static inline struct ath9k_htc_tx_ctl *HTC_SKB_CB(struct sk_buff *skb)
diff --git a/drivers/net/wireless/ath/ath9k/htc_drv_main.c b/drivers/net/wireless/ath/ath9k/htc_drv_main.c
index a5476e8..d6bbd26 100644
--- a/drivers/net/wireless/ath/ath9k/htc_drv_main.c
+++ b/drivers/net/wireless/ath/ath9k/htc_drv_main.c
@@ -1279,10 +1279,13 @@ static int ath9k_htc_sta_remove(struct ieee80211_hw *hw,
 				struct ieee80211_sta *sta)
 {
 	struct ath9k_htc_priv *priv = hw->priv;
+	struct ath9k_htc_sta *ista;
 	int ret;
 
 	mutex_lock(&priv->mutex);
 	ath9k_htc_ps_wakeup(priv);
+	ista = (struct ath9k_htc_sta *) sta->drv_priv;
+	htc_drain(priv->htc, ista->index);
 	ret = ath9k_htc_remove_station(priv, vif, sta);
 	ath9k_htc_ps_restore(priv);
 	mutex_unlock(&priv->mutex);
diff --git a/drivers/net/wireless/ath/ath9k/htc_drv_txrx.c b/drivers/net/wireless/ath/ath9k/htc_drv_txrx.c
index 7357e70..6b31ebf 100644
--- a/drivers/net/wireless/ath/ath9k/htc_drv_txrx.c
+++ b/drivers/net/wireless/ath/ath9k/htc_drv_txrx.c
@@ -139,6 +139,14 @@ int ath9k_htc_tx_start(struct ath9k_htc_priv *priv,
 		tx_hdr.node_idx = sta_idx;
 		tx_hdr.vif_idx = vif_idx;
 
+		/*
+		 * This is a bit redundant but it helps to get
+		 * the per-packet index quickly when draining the
+		 * TX queue in the HIF layer. Otherwise we would
+		 * have to parse the packet contents ...
+		 */
+		tx_ctl->sta_idx = sta_idx;
+
 		if (tx_info->flags & IEEE80211_TX_CTL_AMPDU) {
 			tx_ctl->type = ATH9K_HTC_AMPDU;
 			tx_hdr.data_type = ATH9K_HTC_AMPDU;
diff --git a/drivers/net/wireless/ath/ath9k/htc_hst.c b/drivers/net/wireless/ath/ath9k/htc_hst.c
index 6ee53de..be92cbf 100644
--- a/drivers/net/wireless/ath/ath9k/htc_hst.c
+++ b/drivers/net/wireless/ath/ath9k/htc_hst.c
@@ -317,6 +317,11 @@ void htc_start(struct htc_target *target)
 	}
 }
 
+void htc_drain(struct htc_target *target, u8 idx)
+{
+	target->hif->drain(target->hif_dev, idx);
+}
+
 void ath9k_htc_txcompletion_cb(struct htc_target *htc_handle,
 			       struct sk_buff *skb, bool txok)
 {
diff --git a/drivers/net/wireless/ath/ath9k/htc_hst.h b/drivers/net/wireless/ath/ath9k/htc_hst.h
index 3531552..b1341ba 100644
--- a/drivers/net/wireless/ath/ath9k/htc_hst.h
+++ b/drivers/net/wireless/ath/ath9k/htc_hst.h
@@ -35,6 +35,7 @@ struct ath9k_htc_hif {
 
 	void (*start) (void *hif_handle, u8 pipe);
 	void (*stop) (void *hif_handle, u8 pipe);
+	void (*drain) (void *hif_handle, u8 idx);
 	int (*send) (void *hif_handle, u8 pipe, struct sk_buff *buf);
 };
 
@@ -208,6 +209,7 @@ int htc_send(struct htc_target *target, struct sk_buff *skb,
 	     enum htc_endpoint_id eid);
 void htc_stop(struct htc_target *target);
 void htc_start(struct htc_target *target);
+void htc_drain(struct htc_target *target, u8 idx);
 
 void ath9k_htc_rx_msg(struct htc_target *htc_handle,
 		      struct sk_buff *skb, u32 len, u8 pipe_id);
-- 
1.7.3.5

