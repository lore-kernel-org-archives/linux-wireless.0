Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.atheros.com ([12.36.123.2]:50327 "EHLO mail.atheros.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754263Ab0C2KRG (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 29 Mar 2010 06:17:06 -0400
Received: from mail.atheros.com ([10.10.20.108])
	by sidewinder.atheros.com
	for <linux-wireless@vger.kernel.org>; Mon, 29 Mar 2010 03:17:06 -0700
From: Sujith <Sujith.Manoharan@atheros.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Message-ID: <19376.33501.864630.259002@gargle.gargle.HOWL>
Date: Mon, 29 Mar 2010 16:07:17 +0530
To: <linville@tuxdriver.com>
CC: <linux-wireless@vger.kernel.org>
Subject: [PATCH 5/7] ath9k_htc: Handle TX queue overflow
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Stop/restart TX queues when the internal SKB
queue is full. This helps handle TX better
under heavy load.

Signed-off-by: Sujith <Sujith.Manoharan@atheros.com>
---
 drivers/net/wireless/ath/ath9k/htc.h          |    3 +++
 drivers/net/wireless/ath/ath9k/htc_drv_init.c |    1 +
 drivers/net/wireless/ath/ath9k/htc_drv_main.c |   23 ++++++++++++++++++++---
 drivers/net/wireless/ath/ath9k/htc_drv_txrx.c |   12 ++++++++++++
 4 files changed, 36 insertions(+), 3 deletions(-)

diff --git a/drivers/net/wireless/ath/ath9k/htc.h b/drivers/net/wireless/ath/ath9k/htc.h
index 698e6f1..e09c6c2 100644
--- a/drivers/net/wireless/ath/ath9k/htc.h
+++ b/drivers/net/wireless/ath/ath9k/htc.h
@@ -349,6 +349,9 @@ struct ath9k_htc_priv {
 	struct sk_buff *beacon;
 	spinlock_t beacon_lock;
 
+	bool tx_queues_stop;
+	spinlock_t tx_lock;
+
 	struct ieee80211_vif *vif;
 	unsigned int rxfilter;
 	struct tasklet_struct wmi_tasklet;
diff --git a/drivers/net/wireless/ath/ath9k/htc_drv_init.c b/drivers/net/wireless/ath/ath9k/htc_drv_init.c
index 10c8760..3206eb0 100644
--- a/drivers/net/wireless/ath/ath9k/htc_drv_init.c
+++ b/drivers/net/wireless/ath/ath9k/htc_drv_init.c
@@ -449,6 +449,7 @@ static int ath9k_init_priv(struct ath9k_htc_priv *priv, u16 devid)
 
 	spin_lock_init(&priv->wmi->wmi_lock);
 	spin_lock_init(&priv->beacon_lock);
+	spin_lock_init(&priv->tx_lock);
 	mutex_init(&priv->mutex);
 	mutex_init(&priv->aggr_work.mutex);
 	tasklet_init(&priv->wmi_tasklet, ath9k_wmi_tasklet,
diff --git a/drivers/net/wireless/ath/ath9k/htc_drv_main.c b/drivers/net/wireless/ath/ath9k/htc_drv_main.c
index 90b13ed..63f032d 100644
--- a/drivers/net/wireless/ath/ath9k/htc_drv_main.c
+++ b/drivers/net/wireless/ath/ath9k/htc_drv_main.c
@@ -994,7 +994,7 @@ static int ath9k_htc_tx(struct ieee80211_hw *hw, struct sk_buff *skb)
 {
 	struct ieee80211_hdr *hdr;
 	struct ath9k_htc_priv *priv = hw->priv;
-	int padpos, padsize;
+	int padpos, padsize, ret;
 
 	hdr = (struct ieee80211_hdr *) skb->data;
 
@@ -1008,8 +1008,19 @@ static int ath9k_htc_tx(struct ieee80211_hw *hw, struct sk_buff *skb)
 		memmove(skb->data, skb->data + padsize, padpos);
 	}
 
-	if (ath9k_htc_tx_start(priv, skb) != 0) {
-		ath_print(ath9k_hw_common(priv->ah), ATH_DBG_XMIT, "Tx failed");
+	ret = ath9k_htc_tx_start(priv, skb);
+	if (ret != 0) {
+		if (ret == -ENOMEM) {
+			ath_print(ath9k_hw_common(priv->ah), ATH_DBG_XMIT,
+				  "Stopping TX queues\n");
+			ieee80211_stop_queues(hw);
+			spin_lock_bh(&priv->tx_lock);
+			priv->tx_queues_stop = true;
+			spin_unlock_bh(&priv->tx_lock);
+		} else {
+			ath_print(ath9k_hw_common(priv->ah), ATH_DBG_XMIT,
+				  "Tx failed");
+		}
 		goto fail_tx;
 	}
 
@@ -1074,6 +1085,12 @@ static int ath9k_htc_start(struct ieee80211_hw *hw)
 	priv->op_flags &= ~OP_INVALID;
 	htc_start(priv->htc);
 
+	spin_lock_bh(&priv->tx_lock);
+	priv->tx_queues_stop = false;
+	spin_unlock_bh(&priv->tx_lock);
+
+	ieee80211_wake_queues(hw);
+
 mutex_unlock:
 	mutex_unlock(&priv->mutex);
 	return ret;
diff --git a/drivers/net/wireless/ath/ath9k/htc_drv_txrx.c b/drivers/net/wireless/ath/ath9k/htc_drv_txrx.c
index 8383656..befe574 100644
--- a/drivers/net/wireless/ath/ath9k/htc_drv_txrx.c
+++ b/drivers/net/wireless/ath/ath9k/htc_drv_txrx.c
@@ -226,6 +226,18 @@ void ath9k_tx_tasklet(unsigned long data)
 		/* Send status to mac80211 */
 		ieee80211_tx_status(priv->hw, skb);
 	}
+
+	/* Wake TX queues if needed */
+	spin_lock_bh(&priv->tx_lock);
+	if (priv->tx_queues_stop) {
+		priv->tx_queues_stop = false;
+		spin_unlock_bh(&priv->tx_lock);
+		ath_print(ath9k_hw_common(priv->ah), ATH_DBG_XMIT,
+			  "Waking up TX queues\n");
+		ieee80211_wake_queues(priv->hw);
+		return;
+	}
+	spin_unlock_bh(&priv->tx_lock);
 }
 
 void ath9k_htc_txep(void *drv_priv, struct sk_buff *skb,
-- 
1.7.0.3

