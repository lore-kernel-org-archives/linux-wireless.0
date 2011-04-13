Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-iw0-f174.google.com ([209.85.214.174]:35840 "EHLO
	mail-iw0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752781Ab1DMFxE (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 13 Apr 2011 01:53:04 -0400
Received: by mail-iw0-f174.google.com with SMTP id 34so276432iwn.19
        for <linux-wireless@vger.kernel.org>; Tue, 12 Apr 2011 22:53:04 -0700 (PDT)
From: Sujith <m.sujith@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Message-ID: <19877.15057.560019.733234@gargle.gargle.HOWL>
Date: Wed, 13 Apr 2011 11:25:29 +0530
To: linville@tuxdriver.com
CC: linux-wireless@vger.kernel.org, ath9k-devel@lists.ath9k.org
Subject: [PATCH 25/40] ath9k_htc: Fix TX queue management
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Sujith Manoharan <Sujith.Manoharan@atheros.com>

Handle queue start/stop properly by maintaining
a counter to check if the pending frame count has
exceeded the threshold. Otherwise, packets would be
dropped needlessly. While at it, use a simple flag
to track queue status and use helper functions too.

Signed-off-by: Sujith Manoharan <Sujith.Manoharan@atheros.com>
---
 drivers/net/wireless/ath/ath9k/htc.h            |   13 ++++++--
 drivers/net/wireless/ath/ath9k/htc_drv_beacon.c |    4 ++
 drivers/net/wireless/ath/ath9k/htc_drv_gpio.c   |    2 +-
 drivers/net/wireless/ath/ath9k/htc_drv_main.c   |   21 +++++-------
 drivers/net/wireless/ath/ath9k/htc_drv_txrx.c   |   39 +++++++++++++++++------
 5 files changed, 52 insertions(+), 27 deletions(-)

diff --git a/drivers/net/wireless/ath/ath9k/htc.h b/drivers/net/wireless/ath/ath9k/htc.h
index 3185fe7..fc4c466 100644
--- a/drivers/net/wireless/ath/ath9k/htc.h
+++ b/drivers/net/wireless/ath/ath9k/htc.h
@@ -262,11 +262,16 @@ struct ath9k_htc_rx {
 	spinlock_t rxbuflock;
 };
 
-struct ath9k_htc_tx {
-	bool tx_queues_stop;
-	spinlock_t tx_lock;
+#define ATH9K_HTC_TX_RESERVE   10
+#define ATH9K_HTC_TX_THRESHOLD (MAX_TX_BUF_NUM - ATH9K_HTC_TX_RESERVE)
+
+#define ATH9K_HTC_OP_TX_QUEUES_STOP BIT(0)
 
+struct ath9k_htc_tx {
+	u8 flags;
+	int queued_cnt;
 	struct sk_buff_head tx_queue;
+	spinlock_t tx_lock;
 };
 
 struct ath9k_htc_tx_ctl {
@@ -532,6 +537,8 @@ int ath9k_htc_cabq_setup(struct ath9k_htc_priv *priv);
 int get_hw_qnum(u16 queue, int *hwq_map);
 int ath_htc_txq_update(struct ath9k_htc_priv *priv, int qnum,
 		       struct ath9k_tx_queue_info *qinfo);
+void ath9k_htc_check_stop_queues(struct ath9k_htc_priv *priv);
+void ath9k_htc_check_wake_queues(struct ath9k_htc_priv *priv);
 
 int ath9k_rx_init(struct ath9k_htc_priv *priv);
 void ath9k_rx_cleanup(struct ath9k_htc_priv *priv);
diff --git a/drivers/net/wireless/ath/ath9k/htc_drv_beacon.c b/drivers/net/wireless/ath/ath9k/htc_drv_beacon.c
index 713def1..de37d46 100644
--- a/drivers/net/wireless/ath/ath9k/htc_drv_beacon.c
+++ b/drivers/net/wireless/ath/ath9k/htc_drv_beacon.c
@@ -326,6 +326,10 @@ static void ath9k_htc_send_buffered(struct ath9k_htc_priv *priv,
 			ath_dbg(common, ATH_DBG_FATAL,
 				"Failed to send CAB frame\n");
 			dev_kfree_skb_any(skb);
+		} else {
+			spin_lock_bh(&priv->tx.tx_lock);
+			priv->tx.queued_cnt++;
+			spin_unlock_bh(&priv->tx.tx_lock);
 		}
 	next:
 		skb = ieee80211_get_buffered_bc(priv->hw, vif);
diff --git a/drivers/net/wireless/ath/ath9k/htc_drv_gpio.c b/drivers/net/wireless/ath/ath9k/htc_drv_gpio.c
index 1f6df4a..92e4b31 100644
--- a/drivers/net/wireless/ath/ath9k/htc_drv_gpio.c
+++ b/drivers/net/wireless/ath/ath9k/htc_drv_gpio.c
@@ -399,7 +399,7 @@ void ath9k_htc_radio_enable(struct ieee80211_hw *hw)
 	/* Start TX */
 	htc_start(priv->htc);
 	spin_lock_bh(&priv->tx.tx_lock);
-	priv->tx.tx_queues_stop = false;
+	priv->tx.flags &= ~ATH9K_HTC_OP_TX_QUEUES_STOP;
 	spin_unlock_bh(&priv->tx.tx_lock);
 	ieee80211_wake_queues(hw);
 
diff --git a/drivers/net/wireless/ath/ath9k/htc_drv_main.c b/drivers/net/wireless/ath/ath9k/htc_drv_main.c
index ff3a495..6901136 100644
--- a/drivers/net/wireless/ath/ath9k/htc_drv_main.c
+++ b/drivers/net/wireless/ath/ath9k/htc_drv_main.c
@@ -833,6 +833,7 @@ static void ath9k_htc_tx(struct ieee80211_hw *hw, struct sk_buff *skb)
 {
 	struct ieee80211_hdr *hdr;
 	struct ath9k_htc_priv *priv = hw->priv;
+	struct ath_common *common = ath9k_hw_common(priv->ah);
 	int padpos, padsize, ret;
 
 	hdr = (struct ieee80211_hdr *) skb->data;
@@ -841,28 +842,22 @@ static void ath9k_htc_tx(struct ieee80211_hw *hw, struct sk_buff *skb)
 	padpos = ath9k_cmn_padpos(hdr->frame_control);
 	padsize = padpos & 3;
 	if (padsize && skb->len > padpos) {
-		if (skb_headroom(skb) < padsize)
+		if (skb_headroom(skb) < padsize) {
+			ath_dbg(common, ATH_DBG_XMIT, "No room for padding\n");
 			goto fail_tx;
+		}
 		skb_push(skb, padsize);
 		memmove(skb->data, skb->data + padsize, padpos);
 	}
 
 	ret = ath9k_htc_tx_start(priv, skb, false);
 	if (ret != 0) {
-		if (ret == -ENOMEM) {
-			ath_dbg(ath9k_hw_common(priv->ah), ATH_DBG_XMIT,
-				"Stopping TX queues\n");
-			ieee80211_stop_queues(hw);
-			spin_lock_bh(&priv->tx.tx_lock);
-			priv->tx.tx_queues_stop = true;
-			spin_unlock_bh(&priv->tx.tx_lock);
-		} else {
-			ath_dbg(ath9k_hw_common(priv->ah), ATH_DBG_XMIT,
-				"Tx failed\n");
-		}
+		ath_dbg(common, ATH_DBG_XMIT, "Tx failed\n");
 		goto fail_tx;
 	}
 
+	ath9k_htc_check_stop_queues(priv);
+
 	return;
 
 fail_tx:
@@ -924,7 +919,7 @@ static int ath9k_htc_start(struct ieee80211_hw *hw)
 	htc_start(priv->htc);
 
 	spin_lock_bh(&priv->tx.tx_lock);
-	priv->tx.tx_queues_stop = false;
+	priv->tx.flags &= ~ATH9K_HTC_OP_TX_QUEUES_STOP;
 	spin_unlock_bh(&priv->tx.tx_lock);
 
 	ieee80211_wake_queues(hw);
diff --git a/drivers/net/wireless/ath/ath9k/htc_drv_txrx.c b/drivers/net/wireless/ath/ath9k/htc_drv_txrx.c
index 6f7987d..1cbe194 100644
--- a/drivers/net/wireless/ath/ath9k/htc_drv_txrx.c
+++ b/drivers/net/wireless/ath/ath9k/htc_drv_txrx.c
@@ -53,6 +53,29 @@ int get_hw_qnum(u16 queue, int *hwq_map)
 	}
 }
 
+void ath9k_htc_check_stop_queues(struct ath9k_htc_priv *priv)
+{
+	spin_lock_bh(&priv->tx.tx_lock);
+	priv->tx.queued_cnt++;
+	if ((priv->tx.queued_cnt >= ATH9K_HTC_TX_THRESHOLD) &&
+	    !(priv->tx.flags & ATH9K_HTC_OP_TX_QUEUES_STOP)) {
+		priv->tx.flags |= ATH9K_HTC_OP_TX_QUEUES_STOP;
+		ieee80211_stop_queues(priv->hw);
+	}
+	spin_unlock_bh(&priv->tx.tx_lock);
+}
+
+void ath9k_htc_check_wake_queues(struct ath9k_htc_priv *priv)
+{
+	spin_lock_bh(&priv->tx.tx_lock);
+	if ((priv->tx.queued_cnt < ATH9K_HTC_TX_THRESHOLD) &&
+	    (priv->tx.flags & ATH9K_HTC_OP_TX_QUEUES_STOP)) {
+		priv->tx.flags &= ~ATH9K_HTC_OP_TX_QUEUES_STOP;
+		ieee80211_wake_queues(priv->hw);
+	}
+	spin_unlock_bh(&priv->tx.tx_lock);
+}
+
 int ath_htc_txq_update(struct ath9k_htc_priv *priv, int qnum,
 		       struct ath9k_tx_queue_info *qinfo)
 {
@@ -302,21 +325,17 @@ void ath9k_tx_tasklet(unsigned long data)
 		rcu_read_unlock();
 
 	send_mac80211:
+		spin_lock_bh(&priv->tx.tx_lock);
+		if (WARN_ON(--priv->tx.queued_cnt < 0))
+			priv->tx.queued_cnt = 0;
+		spin_unlock_bh(&priv->tx.tx_lock);
+
 		/* Send status to mac80211 */
 		ieee80211_tx_status(priv->hw, skb);
 	}
 
 	/* Wake TX queues if needed */
-	spin_lock_bh(&priv->tx.tx_lock);
-	if (priv->tx.tx_queues_stop) {
-		priv->tx.tx_queues_stop = false;
-		spin_unlock_bh(&priv->tx.tx_lock);
-		ath_dbg(ath9k_hw_common(priv->ah), ATH_DBG_XMIT,
-			"Waking up TX queues\n");
-		ieee80211_wake_queues(priv->hw);
-		return;
-	}
-	spin_unlock_bh(&priv->tx.tx_lock);
+	ath9k_htc_check_wake_queues(priv);
 }
 
 void ath9k_htc_txep(void *drv_priv, struct sk_buff *skb,
-- 
1.7.4.4

