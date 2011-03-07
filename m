Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-yw0-f46.google.com ([209.85.213.46]:64006 "EHLO
	mail-yw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755208Ab1CGCP6 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 6 Mar 2011 21:15:58 -0500
Received: by mail-yw0-f46.google.com with SMTP id 3so1451731ywj.19
        for <linux-wireless@vger.kernel.org>; Sun, 06 Mar 2011 18:15:58 -0800 (PST)
From: Sujith <m.sujith@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Message-ID: <19828.16341.823258.534553@gargle.gargle.HOWL>
Date: Mon, 7 Mar 2011 07:45:49 +0530
To: linux-wireless@vger.kernel.org
CC: ath9k-devel@lists.ath9k.org
Subject: [RFC 29/34] ath9k_htc: Drain packets on station removal
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Sujith Manoharan <Sujith.Manoharan@atheros.com>

When a station entry is removed, there could still be
pending packets destined for that station in the HIF layer.
Sending these to the target is not necessary, so drain them
in the driver itself.

Signed-off-by: Sujith Manoharan <Sujith.Manoharan@atheros.com>
---
 drivers/net/wireless/ath/ath9k/hif_usb.c      |   35 +++++++++++++++++++++++++
 drivers/net/wireless/ath/ath9k/htc.h          |    1 +
 drivers/net/wireless/ath/ath9k/htc_drv_main.c |    3 ++
 drivers/net/wireless/ath/ath9k/htc_drv_txrx.c |    8 +++++
 drivers/net/wireless/ath/ath9k/htc_hst.c      |    5 +++
 drivers/net/wireless/ath/ath9k/htc_hst.h      |    2 +
 6 files changed, 54 insertions(+), 0 deletions(-)

diff --git a/drivers/net/wireless/ath/ath9k/hif_usb.c b/drivers/net/wireless/ath/ath9k/hif_usb.c
index 405a09d..4fb9585 100644
--- a/drivers/net/wireless/ath/ath9k/hif_usb.c
+++ b/drivers/net/wireless/ath/ath9k/hif_usb.c
@@ -365,6 +365,40 @@ static int hif_usb_send(void *hif_handle, u8 pipe_id, struct sk_buff *skb)
 	return ret;
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
+static void hif_usb_sta_drain(void *hif_handle, u8 idx)
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
+			ath9k_htc_txcompletion_cb(hif_dev->htc_handle,
+						  skb, false);
+			hif_dev->tx.tx_skb_cnt--;
+			TX_STAT_INC(skb_failed);
+		}
+	}
+
+	spin_unlock_irqrestore(&hif_dev->tx.tx_lock, flags);
+}
+
 static struct ath9k_htc_hif hif_usb = {
 	.transport = ATH9K_HIF_USB,
 	.name = "ath9k_hif_usb",
@@ -374,6 +408,7 @@ static struct ath9k_htc_hif hif_usb = {
 
 	.start = hif_usb_start,
 	.stop = hif_usb_stop,
+	.sta_drain = hif_usb_sta_drain,
 	.send = hif_usb_send,
 };
 
diff --git a/drivers/net/wireless/ath/ath9k/htc.h b/drivers/net/wireless/ath/ath9k/htc.h
index fc8730e..5c17745 100644
--- a/drivers/net/wireless/ath/ath9k/htc.h
+++ b/drivers/net/wireless/ath/ath9k/htc.h
@@ -277,6 +277,7 @@ struct ath9k_htc_tx_ctl {
 	u8 type; /* ATH9K_HTC_* */
 	u8 epid;
 	u8 txok;
+	u8 sta_idx;
 };
 
 static inline struct ath9k_htc_tx_ctl *HTC_SKB_CB(struct sk_buff *skb)
diff --git a/drivers/net/wireless/ath/ath9k/htc_drv_main.c b/drivers/net/wireless/ath/ath9k/htc_drv_main.c
index fb9ff11..ae85cc4 100644
--- a/drivers/net/wireless/ath/ath9k/htc_drv_main.c
+++ b/drivers/net/wireless/ath/ath9k/htc_drv_main.c
@@ -1303,10 +1303,13 @@ static int ath9k_htc_sta_remove(struct ieee80211_hw *hw,
 				struct ieee80211_sta *sta)
 {
 	struct ath9k_htc_priv *priv = hw->priv;
+	struct ath9k_htc_sta *ista;
 	int ret;
 
 	mutex_lock(&priv->mutex);
 	ath9k_htc_ps_wakeup(priv);
+	ista = (struct ath9k_htc_sta *) sta->drv_priv;
+	htc_sta_drain(priv->htc, ista->index);
 	ret = ath9k_htc_remove_station(priv, vif, sta);
 	ath9k_htc_ps_restore(priv);
 	mutex_unlock(&priv->mutex);
diff --git a/drivers/net/wireless/ath/ath9k/htc_drv_txrx.c b/drivers/net/wireless/ath/ath9k/htc_drv_txrx.c
index 9e0c34b..0790070 100644
--- a/drivers/net/wireless/ath/ath9k/htc_drv_txrx.c
+++ b/drivers/net/wireless/ath/ath9k/htc_drv_txrx.c
@@ -248,6 +248,14 @@ int ath9k_htc_tx_start(struct ath9k_htc_priv *priv,
 		tx_hdr.vif_idx = vif_idx;
 		tx_hdr.cookie = slot;
 
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
index 7ced8ab..5c76352 100644
--- a/drivers/net/wireless/ath/ath9k/htc_hst.c
+++ b/drivers/net/wireless/ath/ath9k/htc_hst.c
@@ -310,6 +310,11 @@ void htc_start(struct htc_target *target)
 	target->hif->start(target->hif_dev);
 }
 
+void htc_sta_drain(struct htc_target *target, u8 idx)
+{
+	target->hif->sta_drain(target->hif_dev, idx);
+}
+
 void ath9k_htc_txcompletion_cb(struct htc_target *htc_handle,
 			       struct sk_buff *skb, bool txok)
 {
diff --git a/drivers/net/wireless/ath/ath9k/htc_hst.h b/drivers/net/wireless/ath/ath9k/htc_hst.h
index 191e3c0..cb9174a 100644
--- a/drivers/net/wireless/ath/ath9k/htc_hst.h
+++ b/drivers/net/wireless/ath/ath9k/htc_hst.h
@@ -35,6 +35,7 @@ struct ath9k_htc_hif {
 
 	void (*start) (void *hif_handle);
 	void (*stop) (void *hif_handle);
+	void (*sta_drain) (void *hif_handle, u8 idx);
 	int (*send) (void *hif_handle, u8 pipe, struct sk_buff *buf);
 };
 
@@ -209,6 +210,7 @@ int htc_send_epid(struct htc_target *target, struct sk_buff *skb,
 		  enum htc_endpoint_id epid);
 void htc_stop(struct htc_target *target);
 void htc_start(struct htc_target *target);
+void htc_sta_drain(struct htc_target *target, u8 idx);
 
 void ath9k_htc_rx_msg(struct htc_target *htc_handle,
 		      struct sk_buff *skb, u32 len, u8 pipe_id);
-- 
1.7.4.1

