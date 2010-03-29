Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.atheros.com ([12.36.123.2]:50323 "EHLO mail.atheros.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754263Ab0C2KRA (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 29 Mar 2010 06:17:00 -0400
Received: from mail.atheros.com ([10.10.20.105])
	by sidewinder.atheros.com
	for <linux-wireless@vger.kernel.org>; Mon, 29 Mar 2010 03:17:00 -0700
From: Sujith <Sujith.Manoharan@atheros.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Message-ID: <19376.33495.822065.322256@gargle.gargle.HOWL>
Date: Mon, 29 Mar 2010 16:07:11 +0530
To: <linville@tuxdriver.com>
CC: <linux-wireless@vger.kernel.org>
Subject: [PATCH 2/7] ath9k_htc: Fix bug in aggregation initiation
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Accessing the sta pointer in TX completion without
approprate RCU protection is wrong. Fix this.

Also, RCU protection is needed when the station's
aggregation state is updated. Handle this properly.

Signed-off-by: Sujith <Sujith.Manoharan@atheros.com>
---
 drivers/net/wireless/ath/ath9k/htc_drv_main.c |   25 ++++++++++++-------------
 drivers/net/wireless/ath/ath9k/htc_drv_txrx.c |   14 ++++++++++++--
 2 files changed, 24 insertions(+), 15 deletions(-)

diff --git a/drivers/net/wireless/ath/ath9k/htc_drv_main.c b/drivers/net/wireless/ath/ath9k/htc_drv_main.c
index e5f78c7..90b13ed 100644
--- a/drivers/net/wireless/ath/ath9k/htc_drv_main.c
+++ b/drivers/net/wireless/ath/ath9k/htc_drv_main.c
@@ -412,32 +412,31 @@ static int ath9k_htc_aggr_oper(struct ath9k_htc_priv *priv,
 	if (tid > ATH9K_HTC_MAX_TID)
 		return -EINVAL;
 
+	memset(&aggr, 0, sizeof(struct ath9k_htc_target_aggr));
+
 	rcu_read_lock();
+
+	/* Check if we are able to retrieve the station */
 	sta = ieee80211_find_sta(vif, sta_addr);
-	if (sta) {
-		ista = (struct ath9k_htc_sta *) sta->drv_priv;
-	} else {
+	if (!sta) {
 		rcu_read_unlock();
 		return -EINVAL;
 	}
 
-	if (!ista) {
-		rcu_read_unlock();
-		return -EINVAL;
-	}
+	ista = (struct ath9k_htc_sta *) sta->drv_priv;
 
-	memset(&aggr, 0, sizeof(struct ath9k_htc_target_aggr));
+	if (oper)
+		ista->tid_state[tid] = AGGR_START;
+	else
+		ista->tid_state[tid] = AGGR_STOP;
 
 	aggr.sta_index = ista->index;
+
 	rcu_read_unlock();
+
 	aggr.tidno = tid;
 	aggr.aggr_enable = oper;
 
-	if (oper)
-		ista->tid_state[tid] = AGGR_START;
-	else
-		ista->tid_state[tid] = AGGR_STOP;
-
 	WMI_CMD_BUF(WMI_TX_AGGR_ENABLE_CMDID, &aggr);
 	if (ret)
 		ath_print(common, ATH_DBG_CONFIG,
diff --git a/drivers/net/wireless/ath/ath9k/htc_drv_txrx.c b/drivers/net/wireless/ath/ath9k/htc_drv_txrx.c
index 94e299f..8383656 100644
--- a/drivers/net/wireless/ath/ath9k/htc_drv_txrx.c
+++ b/drivers/net/wireless/ath/ath9k/htc_drv_txrx.c
@@ -188,10 +188,20 @@ void ath9k_tx_tasklet(unsigned long data)
 		hdr = (struct ieee80211_hdr *) skb->data;
 		fc = hdr->frame_control;
 		tx_info = IEEE80211_SKB_CB(skb);
-		sta = tx_info->control.sta;
+
+		memset(&tx_info->status, 0, sizeof(tx_info->status));
 
 		rcu_read_lock();
 
+		sta = ieee80211_find_sta(priv->vif, hdr->addr1);
+		if (!sta) {
+			rcu_read_unlock();
+			ieee80211_tx_status(priv->hw, skb);
+			continue;
+		}
+
+		/* Check if we need to start aggregation */
+
 		if (sta && conf_is_ht(&priv->hw->conf) &&
 		    (priv->op_flags & OP_TXAGGR)
 		    && !(skb->protocol == cpu_to_be16(ETH_P_PAE))) {
@@ -213,7 +223,7 @@ void ath9k_tx_tasklet(unsigned long data)
 
 		rcu_read_unlock();
 
-		memset(&tx_info->status, 0, sizeof(tx_info->status));
+		/* Send status to mac80211 */
 		ieee80211_tx_status(priv->hw, skb);
 	}
 }
-- 
1.7.0.3

