Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from fmmailgate03.web.de ([217.72.192.234]:38829 "EHLO
	fmmailgate03.web.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754145AbZGFNSM (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 6 Jul 2009 09:18:12 -0400
From: Christian Lamparter <chunkeey@web.de>
To: "linux-wireless" <linux-wireless@vger.kernel.org>
Subject: [PATCH] p54: fix queue stall due to underrun
Date: Mon, 6 Jul 2009 15:18:13 +0200
Cc: "John W. Linville" <linville@tuxdriver.com>,
	Larry Finger <Larry.Finger@lwfinger.net>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Message-Id: <200907061518.13368.chunkeey@web.de>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Larry Finger discovered a weird behavior under load.
In essence, the queue's length count under runs,
which in turn renders the associated ac queue unusable.

Reported-by: Larry Finger <Larry.Finger@lwfinger.net>
Signed-off-by: Christian Lamparter <chunkeey@web.de>
---
diff --git a/drivers/net/wireless/p54/txrx.c b/drivers/net/wireless/p54/txrx.c
index ea074a6..01eadb1 100644
--- a/drivers/net/wireless/p54/txrx.c
+++ b/drivers/net/wireless/p54/txrx.c
@@ -199,7 +199,7 @@ static int p54_tx_qos_accounting_alloc(struct p54_common *priv,
 	queue = &priv->tx_stats[p54_queue];
 
 	spin_lock_irqsave(&priv->tx_stats_lock, flags);
-	if (unlikely(queue->len > queue->limit && IS_QOS_QUEUE(p54_queue))) {
+	if (unlikely(queue->len >= queue->limit && IS_QOS_QUEUE(p54_queue))) {
 		spin_unlock_irqrestore(&priv->tx_stats_lock, flags);
 		return -ENOSPC;
 	}
@@ -222,8 +222,11 @@ static void p54_tx_qos_accounting_free(struct p54_common *priv,
 	if (skb && IS_DATA_FRAME(skb)) {
 		struct p54_hdr *hdr = (void *) skb->data;
 		struct p54_tx_data *data = (void *) hdr->data;
+		unsigned long flags;
 
+		spin_lock_irqsave(&priv->tx_stats_lock, flags);
 		priv->tx_stats[data->hw_queue].len--;
+		spin_unlock_irqrestore(&priv->tx_stats_lock, flags);
 	}
 	p54_wake_queues(priv);
 }
@@ -504,7 +507,6 @@ static void p54_rx_eeprom_readback(struct p54_common *priv,
 
 	priv->eeprom = NULL;
 	tmp = p54_find_and_unlink_skb(priv, hdr->req_id);
-	p54_tx_qos_accounting_free(priv, tmp);
 	dev_kfree_skb_any(tmp);
 	complete(&priv->eeprom_comp);
 }
@@ -531,7 +533,6 @@ static void p54_rx_stats(struct p54_common *priv, struct sk_buff *skb)
 	priv->noise = p54_rssi_to_dbm(priv, le32_to_cpu(stats->noise));
 
 	tmp = p54_find_and_unlink_skb(priv, hdr->req_id);
-	p54_tx_qos_accounting_free(priv, tmp);
 	dev_kfree_skb_any(tmp);
 }
 
