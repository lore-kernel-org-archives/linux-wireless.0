Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from c60.cesmail.net ([216.154.195.49]:16429 "EHLO c60.cesmail.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751539AbXIAEff (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Sat, 1 Sep 2007 00:35:35 -0400
Received: from dv.roinet.com (static-72-92-88-10.phlapa.fios.verizon.net [72.92.88.10])
	by relay.cesmail.net (Postfix) with ESMTP id 429D4618FE1
	for <linux-wireless@vger.kernel.org>; Sat,  1 Sep 2007 00:35:35 -0400 (EDT)
From: Pavel Roskin <proski@gnu.org>
Subject: [PATCH 14/35] Fix incorrect queue management in at76_tx_mgmt()
To: linux-wireless@vger.kernel.org
Date: Sat, 01 Sep 2007 00:35:34 -0400
Message-ID: <20070901043534.2498.20302.stgit@dv.roinet.com>
In-Reply-To: <20070901043233.2498.95850.stgit@dv.roinet.com>
References: <20070901043233.2498.95850.stgit@dv.roinet.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

The old pending buffer should be freed, not the new one.  No need to set
txbuf to NULL.

Signed-off-by: Pavel Roskin <proski@gnu.org>
---

 drivers/net/wireless/at76_usb.c |   17 +++++++----------
 1 files changed, 7 insertions(+), 10 deletions(-)


diff --git a/drivers/net/wireless/at76_usb.c b/drivers/net/wireless/at76_usb.c
index f49fb3d..cabef24 100644
--- a/drivers/net/wireless/at76_usb.c
+++ b/drivers/net/wireless/at76_usb.c
@@ -1600,7 +1600,7 @@ static void at76_tx_callback(struct urb *urb)
 static int at76_tx_mgmt(struct at76_priv *priv, struct at76_tx_buffer *txbuf)
 {
 	unsigned long flags;
-	int ret = 0;
+	int ret;
 	int urb_status;
 	void *oldbuf = NULL;
 
@@ -1611,9 +1611,9 @@ static int at76_tx_mgmt(struct at76_priv *priv, struct at76_tx_buffer *txbuf)
 
 	urb_status = priv->tx_urb->status;
 	if (urb_status == -EINPROGRESS) {
-		oldbuf = priv->next_mgmt_bulk;	/* to kfree below */
+		/* cannot transmit now, put in the queue */
+		oldbuf = priv->next_mgmt_bulk;
 		priv->next_mgmt_bulk = txbuf;
-		txbuf = NULL;
 	}
 	spin_unlock_irqrestore(&priv->mgmt_spinlock, flags);
 
@@ -1621,15 +1621,12 @@ static int at76_tx_mgmt(struct at76_priv *priv, struct at76_tx_buffer *txbuf)
 		/* a data/mgmt tx is already pending in the URB -
 		   if this is no error in some situations we must
 		   implement a queue or silently modify the old msg */
-		err("%s: %s removed pending mgmt buffer %s",
-		    priv->netdev->name, __func__,
-		    hex2str(priv->next_mgmt_bulk, 64));
-		kfree(priv->next_mgmt_bulk);
+		err("%s: %s removed pending mgmt buffer %s", priv->netdev->name,
+		    __func__, hex2str(oldbuf, 64));
+		kfree(oldbuf);
+		return 0;
 	}
 
-	if (!txbuf)
-		return ret;
-
 	txbuf->tx_rate = 0;
 	txbuf->padding = at76_calc_padding(le16_to_cpu(txbuf->wlength));
 
