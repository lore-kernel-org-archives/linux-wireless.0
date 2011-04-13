Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-iw0-f174.google.com ([209.85.214.174]:35840 "EHLO
	mail-iw0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752863Ab1DMFxz (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 13 Apr 2011 01:53:55 -0400
Received: by mail-iw0-f174.google.com with SMTP id 34so276432iwn.19
        for <linux-wireless@vger.kernel.org>; Tue, 12 Apr 2011 22:53:55 -0700 (PDT)
From: Sujith <m.sujith@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Message-ID: <19877.15106.914901.75458@gargle.gargle.HOWL>
Date: Wed, 13 Apr 2011 11:26:18 +0530
To: linville@tuxdriver.com
CC: linux-wireless@vger.kernel.org, ath9k-devel@lists.ath9k.org
Subject: [PATCH 33/40] ath9k_htc: Add support for TX completion
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Sujith Manoharan <Sujith.Manoharan@atheros.com>

Now that the infrastructure is in place, process WMI
TX status events and complete packets.

Signed-off-by: Sujith Manoharan <Sujith.Manoharan@atheros.com>
---
 drivers/net/wireless/ath/ath9k/htc.h          |   14 ++-
 drivers/net/wireless/ath/ath9k/htc_drv_init.c |    2 +-
 drivers/net/wireless/ath/ath9k/htc_drv_txrx.c |  208 ++++++++++++++++++++++---
 drivers/net/wireless/ath/ath9k/wmi.c          |   10 ++
 drivers/net/wireless/ath/ath9k/wmi.h          |    4 +-
 5 files changed, 207 insertions(+), 31 deletions(-)

diff --git a/drivers/net/wireless/ath/ath9k/htc.h b/drivers/net/wireless/ath/ath9k/htc.h
index 41823fd..6c103ed 100644
--- a/drivers/net/wireless/ath/ath9k/htc.h
+++ b/drivers/net/wireless/ath/ath9k/htc.h
@@ -266,11 +266,17 @@ struct ath9k_htc_rx {
 #define ATH9K_HTC_TX_THRESHOLD (MAX_TX_BUF_NUM - ATH9K_HTC_TX_RESERVE)
 
 #define ATH9K_HTC_OP_TX_QUEUES_STOP BIT(0)
+#define ATH9K_HTC_OP_TX_DRAIN       BIT(1)
 
 struct ath9k_htc_tx {
 	u8 flags;
 	int queued_cnt;
-	struct sk_buff_head tx_queue;
+	struct sk_buff_head mgmt_ep_queue;
+	struct sk_buff_head cab_ep_queue;
+	struct sk_buff_head data_be_queue;
+	struct sk_buff_head data_bk_queue;
+	struct sk_buff_head data_vi_queue;
+	struct sk_buff_head data_vo_queue;
 	struct sk_buff_head tx_failed;
 	DECLARE_BITMAP(tx_slot, MAX_TX_BUF_NUM);
 	spinlock_t tx_lock;
@@ -465,8 +471,8 @@ struct ath9k_htc_priv {
 
 	struct tasklet_struct swba_tasklet;
 	struct tasklet_struct rx_tasklet;
-	struct tasklet_struct tx_tasklet;
 	struct delayed_work ani_work;
+	struct tasklet_struct tx_failed_tasklet;
 	struct work_struct ps_work;
 	struct work_struct fatal_work;
 
@@ -533,7 +539,6 @@ void ath9k_htc_start_ani(struct ath9k_htc_priv *priv);
 void ath9k_htc_stop_ani(struct ath9k_htc_priv *priv);
 
 int ath9k_tx_init(struct ath9k_htc_priv *priv);
-void ath9k_tx_tasklet(unsigned long data);
 int ath9k_htc_tx_start(struct ath9k_htc_priv *priv,
 		       struct sk_buff *skb, u8 slot, bool is_cab);
 void ath9k_tx_cleanup(struct ath9k_htc_priv *priv);
@@ -547,6 +552,9 @@ void ath9k_htc_check_wake_queues(struct ath9k_htc_priv *priv);
 int ath9k_htc_tx_get_slot(struct ath9k_htc_priv *priv);
 void ath9k_htc_tx_clear_slot(struct ath9k_htc_priv *priv, int slot);
 void ath9k_htc_tx_drain(struct ath9k_htc_priv *priv);
+void ath9k_htc_txstatus(struct ath9k_htc_priv *priv, void *wmi_event);
+void ath9k_htc_tx_failed(struct ath9k_htc_priv *priv);
+void ath9k_tx_failed_tasklet(unsigned long data);
 
 int ath9k_rx_init(struct ath9k_htc_priv *priv);
 void ath9k_rx_cleanup(struct ath9k_htc_priv *priv);
diff --git a/drivers/net/wireless/ath/ath9k/htc_drv_init.c b/drivers/net/wireless/ath/ath9k/htc_drv_init.c
index c270da7..afceeaa 100644
--- a/drivers/net/wireless/ath/ath9k/htc_drv_init.c
+++ b/drivers/net/wireless/ath/ath9k/htc_drv_init.c
@@ -678,7 +678,7 @@ static int ath9k_init_priv(struct ath9k_htc_priv *priv,
 	mutex_init(&priv->htc_pm_lock);
 	tasklet_init(&priv->rx_tasklet, ath9k_rx_tasklet,
 		     (unsigned long)priv);
-	tasklet_init(&priv->tx_tasklet, ath9k_tx_tasklet,
+	tasklet_init(&priv->tx_failed_tasklet, ath9k_tx_failed_tasklet,
 		     (unsigned long)priv);
 	INIT_DELAYED_WORK(&priv->ani_work, ath9k_htc_ani_work);
 	INIT_WORK(&priv->ps_work, ath9k_ps_work);
diff --git a/drivers/net/wireless/ath/ath9k/htc_drv_txrx.c b/drivers/net/wireless/ath/ath9k/htc_drv_txrx.c
index 0790070..a9b6bb1 100644
--- a/drivers/net/wireless/ath/ath9k/htc_drv_txrx.c
+++ b/drivers/net/wireless/ath/ath9k/htc_drv_txrx.c
@@ -99,8 +99,8 @@ void ath9k_htc_tx_clear_slot(struct ath9k_htc_priv *priv, int slot)
 	spin_unlock_bh(&priv->tx.tx_lock);
 }
 
-static enum htc_endpoint_id get_htc_epid(struct ath9k_htc_priv *priv,
-					 u16 qnum)
+static inline enum htc_endpoint_id get_htc_epid(struct ath9k_htc_priv *priv,
+						u16 qnum)
 {
 	enum htc_endpoint_id epid;
 
@@ -127,6 +127,30 @@ static enum htc_endpoint_id get_htc_epid(struct ath9k_htc_priv *priv,
 	return epid;
 }
 
+static inline struct sk_buff_head*
+get_htc_epid_queue(struct ath9k_htc_priv *priv, u8 epid)
+{
+	struct ath_common *common = ath9k_hw_common(priv->ah);
+	struct sk_buff_head *epid_queue = NULL;
+
+	if (epid == priv->mgmt_ep)
+		epid_queue = &priv->tx.mgmt_ep_queue;
+	else if (epid == priv->cab_ep)
+		epid_queue = &priv->tx.cab_ep_queue;
+	else if (epid == priv->data_be_ep)
+		epid_queue = &priv->tx.data_be_queue;
+	else if (epid == priv->data_bk_ep)
+		epid_queue = &priv->tx.data_bk_queue;
+	else if (epid == priv->data_vi_ep)
+		epid_queue = &priv->tx.data_vi_queue;
+	else if (epid == priv->data_vo_ep)
+		epid_queue = &priv->tx.data_vo_queue;
+	else
+		ath_err(common, "Invalid EPID: %d\n", epid);
+
+	return epid_queue;
+}
+
 /*
  * Removes the driver header and returns the TX slot number
  */
@@ -387,11 +411,15 @@ static void ath9k_htc_check_tx_aggr(struct ath9k_htc_priv *priv,
 }
 
 static void ath9k_htc_tx_process(struct ath9k_htc_priv *priv,
-				 struct sk_buff *skb)
+				 struct sk_buff *skb,
+				 struct __wmi_event_txstatus *txs)
 {
 	struct ieee80211_vif *vif;
 	struct ath9k_htc_tx_ctl *tx_ctl;
 	struct ieee80211_tx_info *tx_info;
+	struct ieee80211_tx_rate *rate;
+	struct ieee80211_conf *cur_conf = &priv->hw->conf;
+	struct ieee80211_supported_band *sband;
 	bool txok;
 	int slot;
 
@@ -405,6 +433,8 @@ static void ath9k_htc_tx_process(struct ath9k_htc_priv *priv,
 	txok = tx_ctl->txok;
 	tx_info = IEEE80211_SKB_CB(skb);
 	vif = tx_info->control.vif;
+	rate = &tx_info->status.rates[0];
+	sband = priv->hw->wiphy->bands[cur_conf->channel->band];
 
 	memset(&tx_info->status, 0, sizeof(tx_info->status));
 
@@ -412,10 +442,32 @@ static void ath9k_htc_tx_process(struct ath9k_htc_priv *priv,
 	 * URB submission failed for this frame, it never reached
 	 * the target.
 	 */
-	if (!txok || !vif)
+	if (!txok || !vif || !txs)
 		goto send_mac80211;
 
-	tx_info->flags |= IEEE80211_TX_STAT_ACK;
+	if (txs->ts_flags & ATH9K_HTC_TXSTAT_ACK)
+		tx_info->flags |= IEEE80211_TX_STAT_ACK;
+
+	if (txs->ts_flags & ATH9K_HTC_TXSTAT_FILT)
+		tx_info->flags |= IEEE80211_TX_STAT_TX_FILTERED;
+
+	if (txs->ts_flags & ATH9K_HTC_TXSTAT_RTC_CTS)
+		rate->flags |= IEEE80211_TX_RC_USE_RTS_CTS;
+
+	rate->count = 1;
+	rate->idx = MS(txs->ts_rate, ATH9K_HTC_TXSTAT_RATE);
+
+	if (txs->ts_flags & ATH9K_HTC_TXSTAT_MCS) {
+		rate->flags |= IEEE80211_TX_RC_MCS;
+
+		if (txs->ts_flags & ATH9K_HTC_TXSTAT_CW40)
+			rate->flags |= IEEE80211_TX_RC_40_MHZ_WIDTH;
+		if (txs->ts_flags & ATH9K_HTC_TXSTAT_SGI)
+			rate->flags |= IEEE80211_TX_RC_SHORT_GI;
+	} else {
+		if (cur_conf->channel->band == IEEE80211_BAND_5GHZ)
+			rate->idx += 4; /* No CCK rates */
+	}
 
 	ath9k_htc_check_tx_aggr(priv, vif, skb);
 
@@ -431,37 +483,130 @@ send_mac80211:
 	ieee80211_tx_status(priv->hw, skb);
 }
 
+static inline void ath9k_htc_tx_drainq(struct ath9k_htc_priv *priv,
+				       struct sk_buff_head *queue)
+{
+	struct sk_buff *skb;
+
+	while ((skb = skb_dequeue(queue)) != NULL) {
+		ath9k_htc_tx_process(priv, skb, NULL);
+	}
+}
+
 void ath9k_htc_tx_drain(struct ath9k_htc_priv *priv)
 {
-	struct sk_buff *skb = NULL;
+	spin_lock_bh(&priv->tx.tx_lock);
+	priv->tx.flags |= ATH9K_HTC_OP_TX_DRAIN;
+	spin_unlock_bh(&priv->tx.tx_lock);
 
 	/*
 	 * Ensure that all pending TX frames are flushed,
-	 * and that the TX completion tasklet is killed.
+	 * and that the TX completion/failed tasklets is killed.
 	 */
 	htc_stop(priv->htc);
-	tasklet_kill(&priv->tx_tasklet);
+	tasklet_kill(&priv->wmi->wmi_event_tasklet);
+	tasklet_kill(&priv->tx_failed_tasklet);
 
-	while ((skb = skb_dequeue(&priv->tx.tx_queue)) != NULL) {
-		ath9k_htc_tx_process(priv, skb);
-	}
+	ath9k_htc_tx_drainq(priv, &priv->tx.mgmt_ep_queue);
+	ath9k_htc_tx_drainq(priv, &priv->tx.cab_ep_queue);
+	ath9k_htc_tx_drainq(priv, &priv->tx.data_be_queue);
+	ath9k_htc_tx_drainq(priv, &priv->tx.data_bk_queue);
+	ath9k_htc_tx_drainq(priv, &priv->tx.data_vi_queue);
+	ath9k_htc_tx_drainq(priv, &priv->tx.data_vo_queue);
+	ath9k_htc_tx_drainq(priv, &priv->tx.tx_failed);
 
-	while ((skb = skb_dequeue(&priv->tx.tx_failed)) != NULL) {
-		ath9k_htc_tx_process(priv, skb);
-	}
+	spin_lock_bh(&priv->tx.tx_lock);
+	priv->tx.flags &= ~ATH9K_HTC_OP_TX_DRAIN;
+	spin_unlock_bh(&priv->tx.tx_lock);
 }
 
-void ath9k_tx_tasklet(unsigned long data)
+void ath9k_tx_failed_tasklet(unsigned long data)
 {
 	struct ath9k_htc_priv *priv = (struct ath9k_htc_priv *)data;
-	struct sk_buff *skb = NULL;
 
-	while ((skb = skb_dequeue(&priv->tx.tx_queue)) != NULL) {
-		ath9k_htc_tx_process(priv, skb);
+	spin_lock_bh(&priv->tx.tx_lock);
+	if (priv->tx.flags & ATH9K_HTC_OP_TX_DRAIN) {
+		spin_unlock_bh(&priv->tx.tx_lock);
+		return;
 	}
+	spin_unlock_bh(&priv->tx.tx_lock);
 
-	while ((skb = skb_dequeue(&priv->tx.tx_failed)) != NULL) {
-		ath9k_htc_tx_process(priv, skb);
+	ath9k_htc_tx_drainq(priv, &priv->tx.tx_failed);
+}
+
+static inline bool check_cookie(struct ath9k_htc_priv *priv,
+				struct sk_buff *skb,
+				u8 cookie, u8 epid)
+{
+	u8 fcookie = 0;
+
+	if (epid == priv->mgmt_ep) {
+		struct tx_mgmt_hdr *hdr;
+		hdr = (struct tx_mgmt_hdr *) skb->data;
+		fcookie = hdr->cookie;
+	} else if ((epid == priv->data_bk_ep) ||
+		   (epid == priv->data_be_ep) ||
+		   (epid == priv->data_vi_ep) ||
+		   (epid == priv->data_vo_ep) ||
+		   (epid == priv->cab_ep)) {
+		struct tx_frame_hdr *hdr;
+		hdr = (struct tx_frame_hdr *) skb->data;
+		fcookie = hdr->cookie;
+	}
+
+	if (fcookie == cookie)
+		return true;
+
+	return false;
+}
+
+static struct sk_buff* ath9k_htc_tx_get_packet(struct ath9k_htc_priv *priv,
+					       struct __wmi_event_txstatus *txs)
+{
+	struct ath_common *common = ath9k_hw_common(priv->ah);
+	struct sk_buff_head *epid_queue;
+	struct sk_buff *skb, *tmp;
+	unsigned long flags;
+	u8 epid = MS(txs->ts_rate, ATH9K_HTC_TXSTAT_EPID);
+
+	epid_queue = get_htc_epid_queue(priv, epid);
+	if (!epid_queue)
+		return NULL;
+
+	spin_lock_irqsave(&epid_queue->lock, flags);
+	skb_queue_walk_safe(epid_queue, skb, tmp) {
+		if (check_cookie(priv, skb, txs->cookie, epid)) {
+			__skb_unlink(skb, epid_queue);
+			spin_unlock_irqrestore(&epid_queue->lock, flags);
+			return skb;
+		}
+	}
+	spin_unlock_irqrestore(&epid_queue->lock, flags);
+
+	ath_dbg(common, ATH_DBG_XMIT,
+		"No matching packet for cookie: %d, epid: %d\n",
+		txs->cookie, epid);
+
+	return NULL;
+}
+
+void ath9k_htc_txstatus(struct ath9k_htc_priv *priv, void *wmi_event)
+{
+	struct wmi_event_txstatus *txs = (struct wmi_event_txstatus *)wmi_event;
+	struct __wmi_event_txstatus *__txs;
+	struct sk_buff *skb;
+	int i;
+
+	for (i = 0; i < txs->cnt; i++) {
+		WARN_ON(txs->cnt > HTC_MAX_TX_STATUS);
+
+		__txs = &txs->txstatus[i];
+
+		skb = ath9k_htc_tx_get_packet(priv, __txs);
+		if (!skb)
+			continue;
+
+		ath9k_htc_tx_process(priv, skb, __txs);
 	}
 
 	/* Wake TX queues if needed */
@@ -473,21 +618,34 @@ void ath9k_htc_txep(void *drv_priv, struct sk_buff *skb,
 {
 	struct ath9k_htc_priv *priv = (struct ath9k_htc_priv *) drv_priv;
 	struct ath9k_htc_tx_ctl *tx_ctl;
+	struct sk_buff_head *epid_queue;
 
 	tx_ctl = HTC_SKB_CB(skb);
 	tx_ctl->txok = txok;
 
-	if (txok)
-		skb_queue_tail(&priv->tx.tx_queue, skb);
-	else
+	if (!txok) {
 		skb_queue_tail(&priv->tx.tx_failed, skb);
+		tasklet_schedule(&priv->tx_failed_tasklet);
+		return;
+	}
+
+	epid_queue = get_htc_epid_queue(priv, ep_id);
+	if (!epid_queue) {
+		dev_kfree_skb_any(skb);
+		return;
+	}
 
-	tasklet_schedule(&priv->tx_tasklet);
+	skb_queue_tail(epid_queue, skb);
 }
 
 int ath9k_tx_init(struct ath9k_htc_priv *priv)
 {
-	skb_queue_head_init(&priv->tx.tx_queue);
+	skb_queue_head_init(&priv->tx.mgmt_ep_queue);
+	skb_queue_head_init(&priv->tx.cab_ep_queue);
+	skb_queue_head_init(&priv->tx.data_be_queue);
+	skb_queue_head_init(&priv->tx.data_bk_queue);
+	skb_queue_head_init(&priv->tx.data_vi_queue);
+	skb_queue_head_init(&priv->tx.data_vo_queue);
 	skb_queue_head_init(&priv->tx.tx_failed);
 	return 0;
 }
diff --git a/drivers/net/wireless/ath/ath9k/wmi.c b/drivers/net/wireless/ath/ath9k/wmi.c
index e66f6c3..3f5a4d1 100644
--- a/drivers/net/wireless/ath/ath9k/wmi.c
+++ b/drivers/net/wireless/ath/ath9k/wmi.c
@@ -163,6 +163,16 @@ void ath9k_wmi_event_tasklet(unsigned long data)
 			wmi->drv_priv->debug.txrate = be32_to_cpu(txrate);
 #endif
 			break;
+		case WMI_TXSTATUS_EVENTID:
+			spin_lock_bh(&priv->tx.tx_lock);
+			if (priv->tx.flags & ATH9K_HTC_OP_TX_DRAIN) {
+				spin_unlock_bh(&priv->tx.tx_lock);
+				break;
+			}
+			spin_unlock_bh(&priv->tx.tx_lock);
+
+			ath9k_htc_txstatus(priv, wmi_event);
+			break;
 		default:
 			break;
 		}
diff --git a/drivers/net/wireless/ath/ath9k/wmi.h b/drivers/net/wireless/ath/ath9k/wmi.h
index 8c877dc..44b1738 100644
--- a/drivers/net/wireless/ath/ath9k/wmi.h
+++ b/drivers/net/wireless/ath/ath9k/wmi.h
@@ -45,9 +45,9 @@ struct wmi_event_swba {
 /*
  * 64 - HTC header - WMI header - 1 / txstatus
  * And some other hdr. space is also accounted for.
- * 13 seems to be the magic number.
+ * 12 seems to be the magic number.
  */
-#define HTC_MAX_TX_STATUS 13
+#define HTC_MAX_TX_STATUS 12
 
 #define ATH9K_HTC_TXSTAT_ACK        BIT(0)
 #define ATH9K_HTC_TXSTAT_FILT       BIT(1)
-- 
1.7.4.4

