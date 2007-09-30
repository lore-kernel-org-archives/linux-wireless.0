Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from c60.cesmail.net ([216.154.195.49]:12794 "EHLO c60.cesmail.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751313AbXI3SkX (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Sun, 30 Sep 2007 14:40:23 -0400
From: Pavel Roskin <proski@gnu.org>
Subject: [PATCH 16/26] at76_usb: Remove unneeded memset() calls
To: John Linville <linville@tuxdriver.com>
Cc: linux-wireless@vger.kernel.org
Date: Sun, 30 Sep 2007 14:40:21 -0400
Message-ID: <20070930184021.23921.96665.stgit@tt.roinet.com>
In-Reply-To: <20070930183409.23921.97762.stgit@tt.roinet.com>
References: <20070930183409.23921.97762.stgit@tt.roinet.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Use kzalloc for bss table entries.  priv is already zeroized, no need to
do it again.

Signed-off-by: Pavel Roskin <proski@gnu.org>
---

 drivers/net/wireless/at76_usb.c |    5 +----
 1 files changed, 1 insertions(+), 4 deletions(-)


diff --git a/drivers/net/wireless/at76_usb.c b/drivers/net/wireless/at76_usb.c
index 1488a60..f470964 100644
--- a/drivers/net/wireless/at76_usb.c
+++ b/drivers/net/wireless/at76_usb.c
@@ -4284,14 +4284,13 @@ static void at76_rx_mgmt_beacon(struct at76_priv *priv,
 
 	if (!match) {
 		/* BSS not in the list - append it */
-		match = kmalloc(sizeof(struct bss_info), GFP_ATOMIC);
+		match = kzalloc(sizeof(struct bss_info), GFP_ATOMIC);
 		if (!match) {
 			at76_dbg(DBG_BSS_TABLE,
 				 "%s: cannot kmalloc new bss info (%zd byte)",
 				 priv->netdev->name, sizeof(struct bss_info));
 			goto exit;
 		}
-		memset(match, 0, sizeof(*match));
 		new_entry = 1;
 		list_add_tail(&match->list, &priv->bss_list);
 	}
@@ -5088,7 +5087,6 @@ static struct at76_priv *at76_alloc_new_device(struct usb_device *udev)
 	}
 
 	priv = netdev_priv(netdev);
-	memset(priv, 0, sizeof(*priv));
 
 	priv->udev = udev;
 	priv->netdev = netdev;
@@ -5223,7 +5221,6 @@ static int at76_init_new_device(struct at76_priv *priv,
 
 	priv->channel = DEF_CHANNEL;
 	priv->iw_mode = IW_MODE_INFRA;
-	memset(priv->essid, 0, IW_ESSID_MAX_SIZE);
 	priv->rts_threshold = DEF_RTS_THRESHOLD;
 	priv->frag_threshold = DEF_FRAG_THRESHOLD;
 	priv->short_retry_limit = DEF_SHORT_RETRY_LIMIT;
