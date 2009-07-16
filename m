Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from fmmailgate03.web.de ([217.72.192.234]:59477 "EHLO
	fmmailgate03.web.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932897AbZGPSDX (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 16 Jul 2009 14:03:23 -0400
From: Christian Lamparter <chunkeey@web.de>
To: "linux-wireless" <linux-wireless@vger.kernel.org>
Subject: [PATCH 1/3] p54: remove useless code
Date: Thu, 16 Jul 2009 20:03:17 +0200
Cc: "John W. Linville" <linville@tuxdriver.com>,
	Larry Finger <Larry.Finger@lwfinger.net>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Message-Id: <200907162003.17639.chunkeey@web.de>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This patch removes some useless checks in recv/xmit code.

Acked-by: Larry Finger <Larry.Finger@lwfinger.net>
Signed-off-by: Christian Lamparter <chunkeey@web.de>
---
diff --git a/drivers/net/wireless/p54/txrx.c b/drivers/net/wireless/p54/txrx.c
index 01eadb1..416400c 100644
--- a/drivers/net/wireless/p54/txrx.c
+++ b/drivers/net/wireless/p54/txrx.c
@@ -87,9 +87,6 @@ static int p54_assign_address(struct p54_common *priv, struct sk_buff *skb)
 	u32 target_addr = priv->rx_start;
 	u16 len = priv->headroom + skb->len + priv->tailroom + 3;
 
-	if (unlikely(WARN_ON(!skb || !priv)))
-		return -EINVAL;
-
 	info = IEEE80211_SKB_CB(skb);
 	range = (void *) info->rate_driver_data;
 	len = (range->extra_len + len) & ~0x3;
@@ -111,11 +108,6 @@ static int p54_assign_address(struct p54_common *priv, struct sk_buff *skb)
 		range = (void *) info->rate_driver_data;
 		hole_size = range->start_addr - last_addr;
 
-		if (!entry->next) {
-			spin_unlock_irqrestore(&priv->tx_queue.lock, flags);
-			return -ENOSPC;
-		}
-
 		if (!target_skb && hole_size >= len) {
 			target_skb = entry->prev;
 			hole_size -= len;
@@ -153,9 +145,6 @@ static void p54_tx_pending(struct p54_common *priv)
 	struct sk_buff *skb;
 	int ret;
 
-	if (unlikely(WARN_ON(!priv)))
-		return ;
-
 	skb = skb_dequeue(&priv->tx_pending);
 	if (unlikely(!skb))
 		return ;
@@ -219,7 +208,7 @@ static int p54_tx_qos_accounting_alloc(struct p54_common *priv,
 static void p54_tx_qos_accounting_free(struct p54_common *priv,
 				       struct sk_buff *skb)
 {
-	if (skb && IS_DATA_FRAME(skb)) {
+	if (IS_DATA_FRAME(skb)) {
 		struct p54_hdr *hdr = (void *) skb->data;
 		struct p54_tx_data *data = (void *) hdr->data;
 		unsigned long flags;
@@ -266,9 +255,6 @@ static struct sk_buff *p54_find_and_unlink_skb(struct p54_common *priv,
 
 void p54_tx(struct p54_common *priv, struct sk_buff *skb)
 {
-	if (unlikely(WARN_ON(!priv)))
-		return ;
-
 	skb_queue_tail(&priv->tx_pending, skb);
 	p54_tx_pending(priv);
 }
