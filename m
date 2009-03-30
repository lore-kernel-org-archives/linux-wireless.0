Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from fmmailgate03.web.de ([217.72.192.234]:49547 "EHLO
	fmmailgate03.web.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750913AbZC3Nz2 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 30 Mar 2009 09:55:28 -0400
From: Christian Lamparter <chunkeey@web.de>
To: linux-wireless@vger.kernel.org,
	"John W. Linville" <linville@tuxdriver.com>,
	Max Filippov <jcmvbkbc@gmail.com>
Subject: [PATCH] p54spi: fix locking warning in p54spi_op_tx
Date: Mon, 30 Mar 2009 15:55:24 +0200
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Message-Id: <200903301555.24267.chunkeey@web.de> (sfid-20090330_155531_235392_49DD89C6)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This patch fixes the following waring:
> ------------[ cut here ]------------
>WARNING: at kernel/softirq.c:138 local_bh_enable+0x54/0xbc()
>Modules linked in: p54spi
>[<c0034ff8>] (dump_stack+0x0/0x14)
>[<c005b1a4>] (warn_on_slowpath+0x0/0x68)
>[<c00604c8>] (local_bh_enable+0x0/0xbc)
>[<bf000000>] (p54spi_op_tx+0x0/0x4c [p54spi])
>[<c01a4d34>] (p54_sta_unlock+0x0/0x78)

p54spi_op_tx needs to be called from different locking contexts.
Therefore we have to protect the linked list with irqsave spinlocks.

Reported-by: Max Filippov <jcmvbkbc@gmail.com>
Signed-off-by: Christian Lamparter <chunkeey@web.de>
---
diff --git a/drivers/net/wireless/p54/p54spi.c b/drivers/net/wireless/p54/p54spi.c
index 155f453..5202312 100644
--- a/drivers/net/wireless/p54/p54spi.c
+++ b/drivers/net/wireless/p54/p54spi.c
@@ -469,9 +469,10 @@ static int p54spi_wq_tx(struct p54s_priv *priv)
 	struct ieee80211_tx_info *info;
 	struct p54_tx_info *minfo;
 	struct p54s_tx_info *dinfo;
+	unsigned long flags;
 	int ret = 0;
 
-	spin_lock_bh(&priv->tx_lock);
+	spin_lock_irqsave(&priv->tx_lock, flags);
 
 	while (!list_empty(&priv->tx_pending)) {
 		entry = list_entry(priv->tx_pending.next,
@@ -479,7 +480,7 @@ static int p54spi_wq_tx(struct p54s_priv *priv)
 
 		list_del_init(&entry->tx_list);
 
-		spin_unlock_bh(&priv->tx_lock);
+		spin_unlock_irqrestore(&priv->tx_lock, flags);
 
 		dinfo = container_of((void *) entry, struct p54s_tx_info,
 				     tx_list);
@@ -491,16 +492,14 @@ static int p54spi_wq_tx(struct p54s_priv *priv)
 
 		ret = p54spi_tx_frame(priv, skb);
 
-		spin_lock_bh(&priv->tx_lock);
-
 		if (ret < 0) {
 			p54_free_skb(priv->hw, skb);
-			goto out;
+			return ret;
 		}
-	}
 
-out:
-	spin_unlock_bh(&priv->tx_lock);
+		spin_lock_irqsave(&priv->tx_lock, flags);
+	}
+	spin_unlock_irqrestore(&priv->tx_lock, flags);
 	return ret;
 }
 
@@ -510,12 +509,13 @@ static void p54spi_op_tx(struct ieee80211_hw *dev, struct sk_buff *skb)
 	struct ieee80211_tx_info *info = IEEE80211_SKB_CB(skb);
 	struct p54_tx_info *mi = (struct p54_tx_info *) info->rate_driver_data;
 	struct p54s_tx_info *di = (struct p54s_tx_info *) mi->data;
+	unsigned long flags;
 
 	BUILD_BUG_ON(sizeof(*di) > sizeof((mi->data)));
 
-	spin_lock_bh(&priv->tx_lock);
+	spin_lock_irqsave(&priv->tx_lock, flags);
 	list_add_tail(&di->tx_list, &priv->tx_pending);
-	spin_unlock_bh(&priv->tx_lock);
+	spin_unlock_irqrestore(&priv->tx_lock, flags);
 
 	queue_work(priv->hw->workqueue, &priv->work);
 }
@@ -616,6 +616,7 @@ out:
 static void p54spi_op_stop(struct ieee80211_hw *dev)
 {
 	struct p54s_priv *priv = dev->priv;
+	unsigned long flags;
 
 	if (mutex_lock_interruptible(&priv->mutex)) {
 		/* FIXME: how to handle this error? */
@@ -627,9 +628,9 @@ static void p54spi_op_stop(struct ieee80211_hw *dev)
 	cancel_work_sync(&priv->work);
 
 	p54spi_power_off(priv);
-	spin_lock_bh(&priv->tx_lock);
+	spin_lock_irqsave(&priv->tx_lock, flags);
 	INIT_LIST_HEAD(&priv->tx_pending);
-	spin_unlock_bh(&priv->tx_lock);
+	spin_unlock_irqrestore(&priv->tx_lock, flags);
 
 	priv->fw_state = FW_STATE_OFF;
 	mutex_unlock(&priv->mutex);
