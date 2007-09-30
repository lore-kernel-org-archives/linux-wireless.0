Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from c60.cesmail.net ([216.154.195.49]:34587 "EHLO c60.cesmail.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751276AbXI3SkK (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Sun, 30 Sep 2007 14:40:10 -0400
From: Pavel Roskin <proski@gnu.org>
Subject: [PATCH 14/26] at76_usb: Make it clear that management frames are sent  at 1Mbps
To: John Linville <linville@tuxdriver.com>
Cc: linux-wireless@vger.kernel.org
Date: Sun, 30 Sep 2007 14:40:08 -0400
Message-ID: <20070930184008.23921.31119.stgit@tt.roinet.com>
In-Reply-To: <20070930183409.23921.97762.stgit@tt.roinet.com>
References: <20070930183409.23921.97762.stgit@tt.roinet.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Signed-off-by: Pavel Roskin <proski@gnu.org>
---

 drivers/net/wireless/at76_usb.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)


diff --git a/drivers/net/wireless/at76_usb.c b/drivers/net/wireless/at76_usb.c
index 8d11988..0c9252e 100644
--- a/drivers/net/wireless/at76_usb.c
+++ b/drivers/net/wireless/at76_usb.c
@@ -1527,7 +1527,7 @@ static int at76_tx_mgmt(struct at76_priv *priv, struct at76_tx_buffer *txbuf)
 		return 0;
 	}
 
-	txbuf->tx_rate = 0;
+	txbuf->tx_rate = TX_RATE_1MBIT;
 	txbuf->padding = at76_calc_padding(le16_to_cpu(txbuf->wlength));
 
 	if (priv->next_mgmt_bulk)
