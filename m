Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([18.85.46.34]:50996 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751695AbXLJRMZ (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 10 Dec 2007 12:12:25 -0500
In-Reply-To: <libertas-12345@shinybook.infradead.org>
To: John Linville <linville@tuxdriver.com>
Cc: Dan Williams <dcbw@redhat.com>, libertas-dev@lists.infradead.org,
	linux-wireless@vger.kernel.org
From: David Woodhouse <dwmw2@infradead.org>
Subject: [PATCH 33/48] libertas: kill internal tx queue for PS mode
Message-Id: <E1J1kpc-0006mm-SU@shinybook.infradead.org> (sfid-20071210_171230_223437_A51100B9)
Date: Mon, 10 Dec 2007 10:46:08 -0500
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Date: Sun, 9 Dec 2007 12:37:27 -0500

It was buggy as hell anyway, since it was just spewing packets at the
device when it wasn't necessarily ready for them (in the USB case, while
the URB was still busy).

We could probably do with a better way of flushing packets to the device
_immediately_, before we stick it back into sleep mode. But we can no
longer just dequeue packets directly, it seems.

Signed-off-by: David Woodhouse <dwmw2@infradead.org>
---
 drivers/net/wireless/libertas/decl.h |    2 -
 drivers/net/wireless/libertas/dev.h  |    5 ----
 drivers/net/wireless/libertas/main.c |    6 -----
 drivers/net/wireless/libertas/tx.c   |   40 ++-------------------------------
 4 files changed, 3 insertions(+), 50 deletions(-)

diff --git a/drivers/net/wireless/libertas/decl.h b/drivers/net/wireless/libertas/decl.h
index e255b19..b094514 100644
--- a/drivers/net/wireless/libertas/decl.h
+++ b/drivers/net/wireless/libertas/decl.h
@@ -62,8 +62,6 @@ void lbs_ps_sleep(struct lbs_private *priv, int wait_option);
 void lbs_ps_confirm_sleep(struct lbs_private *priv, u16 psmode);
 void lbs_ps_wakeup(struct lbs_private *priv, int wait_option);
 
-void lbs_tx_runqueue(struct lbs_private *priv);
-
 struct chan_freq_power *lbs_find_cfp_by_band_and_channel(
 	struct lbs_private *priv,
 	u8 band,
diff --git a/drivers/net/wireless/libertas/dev.h b/drivers/net/wireless/libertas/dev.h
index 21b0d38..a9c3adc 100644
--- a/drivers/net/wireless/libertas/dev.h
+++ b/drivers/net/wireless/libertas/dev.h
@@ -197,11 +197,6 @@ struct lbs_private {
 	/** Timers */
 	struct timer_list command_timer;
 
-	/* TX queue used in PS mode */
-	spinlock_t txqueue_lock;
-	struct sk_buff *tx_queue_ps[NR_TX_QUEUE];
-	unsigned int tx_queue_idx;
-
 	u8 hisregcpy;
 
 	/** current ssid/bssid related parameters*/
diff --git a/drivers/net/wireless/libertas/main.c b/drivers/net/wireless/libertas/main.c
index 2ff5f1b..c638995 100644
--- a/drivers/net/wireless/libertas/main.c
+++ b/drivers/net/wireless/libertas/main.c
@@ -914,8 +914,6 @@ static int lbs_thread(void *data)
 		 */
 		if (!list_empty(&priv->cmdpendingq))
 			wake_up_all(&priv->cmd_pending);
-
-		lbs_tx_runqueue(priv);
 	}
 
 	del_timer(&priv->command_timer);
@@ -1072,10 +1070,6 @@ static int lbs_init_adapter(struct lbs_private *priv)
 
 	mutex_init(&priv->lock);
 
-	memset(&priv->tx_queue_ps, 0, NR_TX_QUEUE*sizeof(struct sk_buff*));
-	priv->tx_queue_idx = 0;
-	spin_lock_init(&priv->txqueue_lock);
-
 	setup_timer(&priv->command_timer, command_timer_fn,
 	            (unsigned long)priv);
 
diff --git a/drivers/net/wireless/libertas/tx.c b/drivers/net/wireless/libertas/tx.c
index 4cb39d3..749535e 100644
--- a/drivers/net/wireless/libertas/tx.c
+++ b/drivers/net/wireless/libertas/tx.c
@@ -164,41 +164,6 @@ done:
 }
 
 
-void lbs_tx_runqueue(struct lbs_private *priv)
-{
-	int i;
-
-	spin_lock(&priv->txqueue_lock);
-	for (i = 0; i < priv->tx_queue_idx; i++) {
-		struct sk_buff *skb = priv->tx_queue_ps[i];
-		spin_unlock(&priv->txqueue_lock);
-		SendSinglePacket(priv, skb);
-		spin_lock(&priv->txqueue_lock);
-	}
-	priv->tx_queue_idx = 0;
-	spin_unlock(&priv->txqueue_lock);
-}
-
-static void lbs_tx_queue(struct lbs_private *priv, struct sk_buff *skb)
-{
-
-	spin_lock(&priv->txqueue_lock);
-
-	WARN_ON(priv->tx_queue_idx >= NR_TX_QUEUE);
-	priv->tx_queue_ps[priv->tx_queue_idx++] = skb;
-	if (priv->tx_queue_idx == NR_TX_QUEUE) {
-		netif_stop_queue(priv->dev);
-		if (priv->mesh_dev)
-			netif_stop_queue(priv->mesh_dev);
-	} else {
-		netif_start_queue(priv->dev);
-		if (priv->mesh_dev)
-			netif_start_queue(priv->mesh_dev);
-	}
-
-	spin_unlock(&priv->txqueue_lock);
-}
-
 /**
  *  @brief This function checks the conditions and sends packet to IF
  *  layer if everything is ok.
@@ -221,8 +186,9 @@ int lbs_process_tx(struct lbs_private *priv, struct sk_buff *skb)
 
 	if ((priv->psstate == PS_STATE_SLEEP) ||
 	    (priv->psstate == PS_STATE_PRE_SLEEP)) {
-		lbs_tx_queue(priv, skb);
-		return ret;
+		lbs_pr_alert("TX error: packet xmit in %ssleep mode\n",
+			     priv->psstate == PS_STATE_SLEEP?"":"pre-");
+		goto done;
 	}
 
 	ret = SendSinglePacket(priv, skb);
-- 
1.5.3.4

