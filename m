Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from c60.cesmail.net ([216.154.195.49]:39822 "EHLO c60.cesmail.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751276AbXI3SkQ (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Sun, 30 Sep 2007 14:40:16 -0400
From: Pavel Roskin <proski@gnu.org>
Subject: [PATCH 15/26] at76_usb: Clean reserved tx area for mgmt frames like  it's done for data
To: John Linville <linville@tuxdriver.com>
Cc: linux-wireless@vger.kernel.org
Date: Sun, 30 Sep 2007 14:40:15 -0400
Message-ID: <20070930184014.23921.7327.stgit@tt.roinet.com>
In-Reply-To: <20070930183409.23921.97762.stgit@tt.roinet.com>
References: <20070930183409.23921.97762.stgit@tt.roinet.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Signed-off-by: Pavel Roskin <proski@gnu.org>
---

 drivers/net/wireless/at76_usb.c |    3 ++-
 1 files changed, 2 insertions(+), 1 deletions(-)


diff --git a/drivers/net/wireless/at76_usb.c b/drivers/net/wireless/at76_usb.c
index 0c9252e..1488a60 100644
--- a/drivers/net/wireless/at76_usb.c
+++ b/drivers/net/wireless/at76_usb.c
@@ -1529,6 +1529,7 @@ static int at76_tx_mgmt(struct at76_priv *priv, struct at76_tx_buffer *txbuf)
 
 	txbuf->tx_rate = TX_RATE_1MBIT;
 	txbuf->padding = at76_calc_padding(le16_to_cpu(txbuf->wlength));
+	memset(txbuf->reserved, 0, sizeof(txbuf->reserved));
 
 	if (priv->next_mgmt_bulk)
 		printk(KERN_ERR "%s: URB status %d, but mgmt is pending\n",
@@ -3144,7 +3145,7 @@ static int at76_tx(struct sk_buff *skb, struct net_device *netdev)
 	   seems to choose the highest rate set with CMD_STARTUP in
 	   basic_rate_set replacing this value */
 
-	memset(tx_buffer->reserved, 0, 4);
+	memset(tx_buffer->reserved, 0, sizeof(tx_buffer->reserved));
 
 	tx_buffer->padding = at76_calc_padding(wlen);
 	submit_len = wlen + AT76_TX_HDRLEN + tx_buffer->padding;
