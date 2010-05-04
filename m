Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wy0-f174.google.com ([74.125.82.174]:58373 "EHLO
	mail-wy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754465Ab0EDVzD (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 4 May 2010 17:55:03 -0400
Received: by mail-wy0-f174.google.com with SMTP id 20so2797546wye.19
        for <linux-wireless@vger.kernel.org>; Tue, 04 May 2010 14:55:02 -0700 (PDT)
From: David Kilroy <kilroyd@googlemail.com>
To: linux-wireless@vger.kernel.org
Cc: orinoco-devel@lists.sourceforge.net, linville@tuxdriver.com,
	David Kilroy <kilroyd@googlemail.com>
Subject: [RFC] orinoco: use SKB tail for MIC
Date: Tue,  4 May 2010 22:54:42 +0100
Message-Id: <1273010082-15871-3-git-send-email-kilroyd@googlemail.com>
In-Reply-To: <1273010082-15871-1-git-send-email-kilroyd@googlemail.com>
References: <1273010082-15871-1-git-send-email-kilroyd@googlemail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

The interface is much neater if we can append the calculated MIC to
the SKB which gets blatted to the hardware wholesale.

Unfortunately, this doesn't work very well. Without spare padding, we
never seem to have any tailroom, and even we ask for extra tailroom
it's not guaranteed.

We could probably call pskb_expand_skb or something to get the tailroom.
But should we really be doing that on the majority of packets?

Signed-off-by: David Kilroy <kilroyd@googlemail.com>
---
 drivers/net/wireless/orinoco/main.c        |   42 ++++++++-------------------
 drivers/net/wireless/orinoco/orinoco.h     |    3 +-
 drivers/net/wireless/orinoco/orinoco_usb.c |   16 +----------
 3 files changed, 15 insertions(+), 46 deletions(-)

diff --git a/drivers/net/wireless/orinoco/main.c b/drivers/net/wireless/orinoco/main.c
index 3b9a5fb..95e9edb 100644
--- a/drivers/net/wireless/orinoco/main.c
+++ b/drivers/net/wireless/orinoco/main.c
@@ -367,8 +367,7 @@ EXPORT_SYMBOL(orinoco_change_mtu);
 int orinoco_process_xmit_skb(struct sk_buff *skb,
 			     struct net_device *dev,
 			     struct orinoco_private *priv,
-			     int *tx_control,
-			     u8 *mic_buf)
+			     int *tx_control)
 {
 	struct orinoco_tkip_key *key;
 	struct ethhdr *eh;
@@ -414,15 +413,18 @@ int orinoco_process_xmit_skb(struct sk_buff *skb,
 	/* Calculate Michael MIC */
 	if (do_mic) {
 		size_t len = skb->len - ETH_HLEN;
-		u8 *mic = &mic_buf[0];
+		u8 *mic;
 
-		/* Have to write to an even address, so copy the spare
-		 * byte across */
-		if (skb->len % 2) {
-			*mic = skb->data[skb->len - 1];
-			mic++;
+		if (skb_tailroom(skb) < MICHAEL_MIC_LEN) {
+			if (net_ratelimit())
+				printk(KERN_ERR "%s: Insufficient tailroom (%d) for MIC (%d)\n",
+				       dev->name,
+				       skb_tailroom(skb), MICHAEL_MIC_LEN);
+			return -ENOMEM;
 		}
 
+		mic = skb_put(skb, MICHAEL_MIC_LEN);
+
 		orinoco_mic(priv->tx_tfm_mic, key->tx_mic,
 			    eh->h_dest, eh->h_source, 0 /* priority */,
 			    skb->data + ETH_HLEN,
@@ -442,7 +444,6 @@ static netdev_tx_t orinoco_xmit(struct sk_buff *skb, struct net_device *dev)
 	u16 txfid = priv->txfid;
 	int tx_control;
 	unsigned long flags;
-	u8 mic_buf[MICHAEL_MIC_LEN+1];
 
 	if (!netif_running(dev)) {
 		printk(KERN_ERR "%s: Tx on stopped device!\n",
@@ -476,8 +477,7 @@ static netdev_tx_t orinoco_xmit(struct sk_buff *skb, struct net_device *dev)
 
 	tx_control = HERMES_TXCTRL_TX_OK | HERMES_TXCTRL_TX_EX;
 
-	err = orinoco_process_xmit_skb(skb, dev, priv, &tx_control,
-				       &mic_buf[0]);
+	err = orinoco_process_xmit_skb(skb, dev, priv, &tx_control);
 	if (err)
 		goto drop;
 
@@ -530,23 +530,6 @@ static netdev_tx_t orinoco_xmit(struct sk_buff *skb, struct net_device *dev)
 		goto busy;
 	}
 
-	if (tx_control & HERMES_TXCTRL_MIC) {
-		size_t offset = HERMES_802_3_OFFSET + skb->len;
-		size_t len = MICHAEL_MIC_LEN;
-
-		if (offset % 2) {
-			offset--;
-			len++;
-		}
-		err = hw->ops->bap_pwrite(hw, USER_BAP, &mic_buf[0], len,
-					  txfid, offset);
-		if (err) {
-			printk(KERN_ERR "%s: Error %d writing MIC to BAP\n",
-			       dev->name, err);
-			goto busy;
-		}
-	}
-
 	/* Finally, we actually initiate the send */
 	netif_stop_queue(dev);
 
@@ -2277,8 +2260,9 @@ int orinoco_if_add(struct orinoco_private *priv,
 
 	/* we use the default eth_mac_addr for setting the MAC addr */
 
-	/* Reserve space in skb for the SNAP header */
+	/* Reserve space in skb for the SNAP header, and MIC */
 	dev->needed_headroom = ENCAPS_OVERHEAD;
+	dev->needed_tailroom = MICHAEL_MIC_LEN;
 
 	netif_carrier_off(dev);
 
diff --git a/drivers/net/wireless/orinoco/orinoco.h b/drivers/net/wireless/orinoco/orinoco.h
index a6da86e..5ea3de8 100644
--- a/drivers/net/wireless/orinoco/orinoco.h
+++ b/drivers/net/wireless/orinoco/orinoco.h
@@ -203,8 +203,7 @@ extern void __orinoco_ev_rx(struct net_device *dev, hermes_t *hw);
 int orinoco_process_xmit_skb(struct sk_buff *skb,
 			     struct net_device *dev,
 			     struct orinoco_private *priv,
-			     int *tx_control,
-			     u8 *mic);
+			     int *tx_control);
 
 /* Common ndo functions exported for reuse by orinoco_usb */
 int orinoco_open(struct net_device *dev);
diff --git a/drivers/net/wireless/orinoco/orinoco_usb.c b/drivers/net/wireless/orinoco/orinoco_usb.c
index 78f089b..dabea30 100644
--- a/drivers/net/wireless/orinoco/orinoco_usb.c
+++ b/drivers/net/wireless/orinoco/orinoco_usb.c
@@ -67,7 +67,6 @@
 #include <linux/wireless.h>
 #include <linux/firmware.h>
 
-#include "mic.h"
 #include "orinoco.h"
 
 #ifndef URB_ASYNC_UNLINK
@@ -1199,7 +1198,6 @@ static netdev_tx_t ezusb_xmit(struct sk_buff *skb, struct net_device *dev)
 	struct orinoco_private *priv = ndev_priv(dev);
 	struct net_device_stats *stats = &priv->stats;
 	struct ezusb_priv *upriv = priv->card;
-	u8 mic[MICHAEL_MIC_LEN+1];
 	int err = 0;
 	int tx_control;
 	unsigned long flags;
@@ -1247,8 +1245,7 @@ static netdev_tx_t ezusb_xmit(struct sk_buff *skb, struct net_device *dev)
 
 	tx_control = 0;
 
-	err = orinoco_process_xmit_skb(skb, dev, priv, &tx_control,
-				       &mic[0]);
+	err = orinoco_process_xmit_skb(skb, dev, priv, &tx_control);
 	if (err)
 		goto drop;
 
@@ -1261,17 +1258,6 @@ static netdev_tx_t ezusb_xmit(struct sk_buff *skb, struct net_device *dev)
 	memcpy(buf, skb->data, skb->len);
 	buf += skb->len;
 
-	if (tx_control & HERMES_TXCTRL_MIC) {
-		u8 *m = mic;
-		/* Mic has been offset so it can be copied to an even
-		 * address. We're copying eveything anyway, so we
-		 * don't need to copy that first byte. */
-		if (skb->len % 2)
-			m++;
-		memcpy(buf, m, MICHAEL_MIC_LEN);
-		buf += MICHAEL_MIC_LEN;
-	}
-
 	/* Finally, we actually initiate the send */
 	netif_stop_queue(dev);
 
-- 
1.6.4.4

