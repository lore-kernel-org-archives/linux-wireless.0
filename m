Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from fmmailgate03.web.de ([217.72.192.234]:40746 "EHLO
	fmmailgate03.web.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750759AbZGDR23 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 4 Jul 2009 13:28:29 -0400
From: Christian Lamparter <chunkeey@web.de>
To: Larry Finger <Larry.Finger@lwfinger.net>
Subject: Re: [WIP] p54: deal with allocation failures in rx path
Date: Sat, 4 Jul 2009 19:28:31 +0200
Cc: "linux-wireless" <linux-wireless@vger.kernel.org>,
	Johannes Berg <johannes@sipsolutions.net>
References: <200907040053.05654.chunkeey@web.de> <200907041211.49115.chunkeey@web.de> <4A4F85EE.5090007@lwfinger.net>
In-Reply-To: <4A4F85EE.5090007@lwfinger.net>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Message-Id: <200907041928.32269.chunkeey@web.de>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Saturday 04 July 2009 18:40:14 Larry Finger wrote:
> I have logged the usb transfers, but not yet analyzed them.
great!

> This time I got a new failure - I hit this warning at
>            net/mac80211/tx.c:1299
>                         retries++;
>                         if (WARN(retries > 10, "tx refused but queue
> active\n"))
>                                 goto drop;
>                         goto retry;
> 

> If I have analyzed this correctly, I hit this section of
> p54_tx_qos_accounting_alloc at drivers/net/wireless/p54/txrx.c:204.
> I'm running the splitup patches.
> 
>         if (unlikely(queue->len > queue->limit &&
> IS_QOS_QUEUE(p54_queue))) {
>                 spin_unlock_irqrestore(&priv->tx_stats_lock, flags);
>                 return -ENOSPC;
>         }
> 
> Any suggestions on debugging this would be appreciated.
---
diff --git a/drivers/net/wireless/p54/txrx.c b/drivers/net/wireless/p54/txrx.c
index ea074a6..69fc70a 100644
--- a/drivers/net/wireless/p54/txrx.c
+++ b/drivers/net/wireless/p54/txrx.c
@@ -25,6 +25,7 @@
 #include "p54.h"
 #include "lmac.h"
 
+#define P54_MM_DEBUG
 #ifdef P54_MM_DEBUG
 static void p54_dump_tx_queue(struct p54_common *priv)
 {
@@ -200,7 +201,18 @@ static int p54_tx_qos_accounting_alloc(struct p54_common *priv,
 
 	spin_lock_irqsave(&priv->tx_stats_lock, flags);
 	if (unlikely(queue->len > queue->limit && IS_QOS_QUEUE(p54_queue))) {
+		u16 ac_queue = p54_queue - P54_QUEUE_DATA;
+		int i;
+
+		printk(KERN_DEBUG "TX queue stats\n");
+		for (i = 0; i < 8; i++)
+			printk(KERN_DEBUG "\ttxq[%d]: used %d [of %d] => %s\n",
+			       i, priv->tx_stats[i].len,
+			       priv->tx_stats[i].limit,
+			       ieee80211_queue_stopped(priv->hw, ac_queue) ?
+			       "stopped" : "running");
 		spin_unlock_irqrestore(&priv->tx_stats_lock, flags);
+		p54_dump_tx_queue(priv);
 		return -ENOSPC;
 	}
 
---
let's hope the queue .len count does not turn negative!

regards,
	Chr
