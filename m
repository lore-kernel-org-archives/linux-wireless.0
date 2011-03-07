Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-yx0-f174.google.com ([209.85.213.174]:37337 "EHLO
	mail-yx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755232Ab1CGCPi (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 6 Mar 2011 21:15:38 -0500
Received: by yxs7 with SMTP id 7so1453196yxs.19
        for <linux-wireless@vger.kernel.org>; Sun, 06 Mar 2011 18:15:37 -0800 (PST)
From: Sujith <m.sujith@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Message-ID: <19828.16321.43903.393153@gargle.gargle.HOWL>
Date: Mon, 7 Mar 2011 07:45:29 +0530
To: linux-wireless@vger.kernel.org
CC: ath9k-devel@lists.ath9k.org
Subject: [RFC 26/34] ath9k_htc: Use helper functions for TX processing
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Sujith Manoharan <Sujith.Manoharan@atheros.com>

Signed-off-by: Sujith Manoharan <Sujith.Manoharan@atheros.com>
---
 drivers/net/wireless/ath/ath9k/htc_drv_txrx.c |  137 +++++++++++++------------
 1 files changed, 73 insertions(+), 64 deletions(-)

diff --git a/drivers/net/wireless/ath/ath9k/htc_drv_txrx.c b/drivers/net/wireless/ath/ath9k/htc_drv_txrx.c
index ee5b3e2..944440c 100644
--- a/drivers/net/wireless/ath/ath9k/htc_drv_txrx.c
+++ b/drivers/net/wireless/ath/ath9k/htc_drv_txrx.c
@@ -325,8 +325,8 @@ send:
 	return htc_send(priv->htc, skb);
 }
 
-static bool ath9k_htc_check_tx_aggr(struct ath9k_htc_priv *priv,
-				    struct ath9k_htc_sta *ista, u8 tid)
+static inline bool __ath9k_htc_check_tx_aggr(struct ath9k_htc_priv *priv,
+					     struct ath9k_htc_sta *ista, u8 tid)
 {
 	bool ret = false;
 
@@ -338,89 +338,98 @@ static bool ath9k_htc_check_tx_aggr(struct ath9k_htc_priv *priv,
 	return ret;
 }
 
-void ath9k_tx_tasklet(unsigned long data)
+static void ath9k_htc_check_tx_aggr(struct ath9k_htc_priv *priv,
+				    struct ieee80211_vif *vif,
+				    struct sk_buff *skb)
 {
-	struct ath9k_htc_priv *priv = (struct ath9k_htc_priv *)data;
-	struct ath9k_htc_tx_ctl *tx_ctl;
-	struct ieee80211_vif *vif;
 	struct ieee80211_sta *sta;
 	struct ieee80211_hdr *hdr;
-	struct ieee80211_tx_info *tx_info;
-	struct sk_buff *skb = NULL;
 	__le16 fc;
-	bool txok;
-	int slot;
 
-	while ((skb = skb_dequeue(&priv->tx.tx_queue)) != NULL) {
+	hdr = (struct ieee80211_hdr *) skb->data;
+	fc = hdr->frame_control;
 
-		slot = strip_drv_header(priv, skb);
-		if (slot < 0) {
-			dev_kfree_skb_any(skb);
-			continue;
-		}
+	rcu_read_lock();
 
-		tx_ctl = HTC_SKB_CB(skb);
-		hdr = (struct ieee80211_hdr *) skb->data;
-		fc = hdr->frame_control;
-		tx_info = IEEE80211_SKB_CB(skb);
-		vif = tx_info->control.vif;
-		txok = tx_ctl->txok;
+	sta = ieee80211_find_sta(vif, hdr->addr1);
+	if (!sta) {
+		rcu_read_unlock();
+		return;
+	}
 
-		memset(&tx_info->status, 0, sizeof(tx_info->status));
+	if (sta && conf_is_ht(&priv->hw->conf) &&
+	    !(skb->protocol == cpu_to_be16(ETH_P_PAE))) {
+		if (ieee80211_is_data_qos(fc)) {
+			u8 *qc, tid;
+			struct ath9k_htc_sta *ista;
 
-		/*
-		 * URB submission failed for this frame, it never reached
-		 * the target.
-		 */
-		if (!txok)
-			goto send_mac80211;
+			qc = ieee80211_get_qos_ctl(hdr);
+			tid = qc[0] & 0xf;
+			ista = (struct ath9k_htc_sta *)sta->drv_priv;
+			if (__ath9k_htc_check_tx_aggr(priv, ista, tid)) {
+				ieee80211_start_tx_ba_session(sta, tid, 0);
+				spin_lock_bh(&priv->tx.tx_lock);
+				ista->tid_state[tid] = AGGR_PROGRESS;
+				spin_unlock_bh(&priv->tx.tx_lock);
+			}
+		}
+	}
 
-		tx_info->flags |= IEEE80211_TX_STAT_ACK;
+	rcu_read_unlock();
+}
 
-		if (!vif)
-			goto send_mac80211;
+static void ath9k_htc_tx_process(struct ath9k_htc_priv *priv,
+				 struct sk_buff *skb)
+{
+	struct ieee80211_vif *vif;
+	struct ath9k_htc_tx_ctl *tx_ctl;
+	struct ieee80211_tx_info *tx_info;
+	bool txok;
+	int slot;
 
-		rcu_read_lock();
+	slot = strip_drv_header(priv, skb);
+	if (slot < 0) {
+		dev_kfree_skb_any(skb);
+		return;
+	}
 
-		sta = ieee80211_find_sta(vif, hdr->addr1);
-		if (!sta) {
-			rcu_read_unlock();
-			goto send_mac80211;
-		}
+	tx_ctl = HTC_SKB_CB(skb);
+	txok = tx_ctl->txok;
+	tx_info = IEEE80211_SKB_CB(skb);
+	vif = tx_info->control.vif;
 
-		/* Check if we need to start aggregation */
+	memset(&tx_info->status, 0, sizeof(tx_info->status));
 
-		if (sta && conf_is_ht(&priv->hw->conf) &&
-		    !(skb->protocol == cpu_to_be16(ETH_P_PAE))) {
-			if (ieee80211_is_data_qos(fc)) {
-				u8 *qc, tid;
-				struct ath9k_htc_sta *ista;
+	/*
+	 * URB submission failed for this frame, it never reached
+	 * the target.
+	 */
+	if (!txok || !vif)
+		goto send_mac80211;
 
-				qc = ieee80211_get_qos_ctl(hdr);
-				tid = qc[0] & 0xf;
-				ista = (struct ath9k_htc_sta *)sta->drv_priv;
+	tx_info->flags |= IEEE80211_TX_STAT_ACK;
 
-				if (ath9k_htc_check_tx_aggr(priv, ista, tid)) {
-					ieee80211_start_tx_ba_session(sta, tid, 0);
-					spin_lock_bh(&priv->tx.tx_lock);
-					ista->tid_state[tid] = AGGR_PROGRESS;
-					spin_unlock_bh(&priv->tx.tx_lock);
-				}
-			}
-		}
+	ath9k_htc_check_tx_aggr(priv, vif, skb);
 
-		rcu_read_unlock();
+send_mac80211:
+	spin_lock_bh(&priv->tx.tx_lock);
+	if (WARN_ON(--priv->tx.queued_cnt < 0))
+		priv->tx.queued_cnt = 0;
+	spin_unlock_bh(&priv->tx.tx_lock);
 
-	send_mac80211:
-		spin_lock_bh(&priv->tx.tx_lock);
-		if (WARN_ON(--priv->tx.queued_cnt < 0))
-			priv->tx.queued_cnt = 0;
-		spin_unlock_bh(&priv->tx.tx_lock);
+	ath9k_htc_tx_clear_slot(priv, slot);
+
+	/* Send status to mac80211 */
+	ieee80211_tx_status(priv->hw, skb);
+}
 
-		ath9k_htc_tx_clear_slot(priv, slot);
+void ath9k_tx_tasklet(unsigned long data)
+{
+	struct ath9k_htc_priv *priv = (struct ath9k_htc_priv *)data;
+	struct sk_buff *skb = NULL;
 
-		/* Send status to mac80211 */
-		ieee80211_tx_status(priv->hw, skb);
+	while ((skb = skb_dequeue(&priv->tx.tx_queue)) != NULL) {
+		ath9k_htc_tx_process(priv, skb);
 	}
 
 	/* Wake TX queues if needed */
-- 
1.7.4.1

