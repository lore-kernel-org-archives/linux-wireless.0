Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from emh03.mail.saunalahti.fi ([62.142.5.109]:56218 "EHLO
	emh03.mail.saunalahti.fi" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751355AbYBJPKw (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 10 Feb 2008 10:10:52 -0500
From: Kalle Valo <kalle.valo@iki.fi>
Subject: [PATCH 03/12] Convert DBG_TX levels to use at76_dbg_dump()
To: linux-wireless@vger.kernel.org
Cc: Pavel Roskin <proski@gnu.org>
Date: Sun, 10 Feb 2008 17:00:11 +0200
Message-ID: <20080210150011.17592.16484.stgit@tikku> (sfid-20080210_151057_082208_60CB744E)
In-Reply-To: <20080210145733.17592.61729.stgit@tikku>
References: <20080210145733.17592.61729.stgit@tikku>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Signed-off-by: Kalle Valo <kalle.valo@iki.fi>
---

 drivers/net/wireless/at76_usb.c |   30 ++++++++++++++----------------
 1 files changed, 14 insertions(+), 16 deletions(-)


diff --git a/drivers/net/wireless/at76_usb.c b/drivers/net/wireless/at76_usb.c
index d2fe698..80b90a3 100644
--- a/drivers/net/wireless/at76_usb.c
+++ b/drivers/net/wireless/at76_usb.c
@@ -1592,11 +1592,10 @@ static int at76_tx_mgmt(struct at76_priv *priv, struct at76_tx_buffer *txbuf)
 		printk(KERN_ERR "%s: URB status %d, but mgmt is pending\n",
 		       priv->netdev->name, urb_status);
 
-	at76_dbg(DBG_TX_MGMT,
-		 "%s: tx mgmt: wlen %d tx_rate %d pad %d %s",
-		 priv->netdev->name, le16_to_cpu(txbuf->wlength),
-		 txbuf->tx_rate, txbuf->padding,
-		 hex2str(txbuf->packet, le16_to_cpu(txbuf->wlength)));
+	at76_dbg_dump(DBG_TX_MGMT, txbuf->packet, le16_to_cpu(txbuf->wlength),
+		      "%s: tx mgmt: wlen %d tx_rate %d pad %d",
+		      priv->netdev->name, le16_to_cpu(txbuf->wlength),
+		      txbuf->tx_rate, txbuf->padding);
 
 	/* txbuf was not consumed above -> send mgmt msg immediately */
 	memcpy(priv->bulk_out_buffer, txbuf,
@@ -1668,8 +1667,9 @@ static int at76_auth_req(struct at76_priv *priv, struct bss_info *bss,
 		 priv->netdev->name, mac2str(mgmt->addr3),
 		 le16_to_cpu(req->algorithm), le16_to_cpu(req->transaction));
 	if (seq_nr == 3)
-		at76_dbg(DBG_TX_MGMT, "%s: AuthReq challenge: %s ...",
-			 priv->netdev->name, hex2str(req->info_element, 18));
+		at76_dbg_dump(DBG_TX_MGMT, req->info_element, 18,
+			      "%s: AuthReq challenge:",
+			      priv->netdev->name);
 
 	/* either send immediately (if no data tx is pending
 	   or put it in pending list */
@@ -3208,15 +3208,13 @@ static int at76_tx(struct sk_buff *skb, struct net_device *netdev)
 	tx_buffer->padding = at76_calc_padding(wlen);
 	submit_len = wlen + AT76_TX_HDRLEN + tx_buffer->padding;
 
-	at76_dbg(DBG_TX_DATA_CONTENT, "%s skb->data %s", priv->netdev->name,
-		 hex2str(skb->data, 32));
-	at76_dbg(DBG_TX_DATA, "%s tx: wlen 0x%x pad 0x%x rate %d hdr %s",
-		 priv->netdev->name,
-		 le16_to_cpu(tx_buffer->wlength),
-		 tx_buffer->padding, tx_buffer->tx_rate,
-		 hex2str(i802_11_hdr, sizeof(*i802_11_hdr)));
-	at76_dbg(DBG_TX_DATA_CONTENT, "%s payload %s", priv->netdev->name,
-		 hex2str(payload, 48));
+	at76_dbg_dump(DBG_TX_DATA, i802_11_hdr, sizeof(*i802_11_hdr),
+		      "%s tx: wlen 0x%x pad 0x%x rate %d hdr",
+		      priv->netdev->name,
+		      le16_to_cpu(tx_buffer->wlength),
+		      tx_buffer->padding, tx_buffer->tx_rate);
+	at76_dbg_dump(DBG_TX_DATA_CONTENT, tx_buffer, submit_len,
+		      "%s tx: tx_buffer", priv->netdev->name);
 
 	/* send stuff */
 	netif_stop_queue(netdev);

