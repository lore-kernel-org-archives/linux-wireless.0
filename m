Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mtaout02-winn.ispmail.ntl.com ([81.103.221.48]:58980 "EHLO
	mtaout02-winn.ispmail.ntl.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753164Ab1EBUil (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 2 May 2011 16:38:41 -0400
From: Daniel Drake <dsd@laptop.org>
To: linville@tuxdriver.com
To: dcbw@redhat.com
Cc: linux-wireless@vger.kernel.org
Cc: libertas-dev@lists.infradead.org
Cc: bhutchings@solarflare.com
Subject: [PATCH] libertas: remove tx_timeout handler
Message-Id: <20110502203816.6AAAD9D401C@zog.reactivated.net> (sfid-20110502_223844_333411_4080316C)
Date: Mon,  2 May 2011 21:38:16 +0100 (BST)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

As described at http://marc.info/?l=linux-netdev&m=130428493104730&w=2
libertas frequently generates spurious tx timeouts, because the tx
queue is brought down for extended periods during scanning. The net
layer takes a look and incorrectly assumes the queue has been down for
several seconds, and generates a tx_timeout.

One way to fix this is to bump the trans_start counter while scanning
so that the network layer knows that the device is still alive, but
I think the tx_timeout handler is implemented wrongly here and not of
any real use, so I vote to remove it.

As explained at http://marc.info/?l=linux-wireless&m=130430311115755&w=2
the watchdog is primarily meant to deal with lockup on the hardware TX
path (detected by the tx queue being stopped for an extended period of
time), but this is unlikely to happen with libertas. In this case, the tx
queue is stopped only while waiting for lbs_thread to send the queued frame
to the driver, and lbs_thread wakes up the queue immediately after, even
if the frame could not be sent correctly.

So, the only hardware-related possibility that this catches is if
hw_host_to_card hangs - this is something I have never seen. And if it
were to happen, nothing done by lbs_tx_timeout would actually wake up
lbs_thread any quicker than otherwise.

Removing this oddly-behaving spuriously-firing tx_timeout handler should
fix an occasional kernel crash during resume
(http://dev.laptop.org/ticket/10748)

Signed-off-by: Daniel Drake <dsd@laptop.org>
---
 drivers/net/wireless/libertas/main.c |   23 -----------------------
 1 files changed, 0 insertions(+), 23 deletions(-)

diff --git a/drivers/net/wireless/libertas/main.c b/drivers/net/wireless/libertas/main.c
index ca8149c..8e5e7af 100644
--- a/drivers/net/wireless/libertas/main.c
+++ b/drivers/net/wireless/libertas/main.c
@@ -147,28 +147,6 @@ static int lbs_eth_stop(struct net_device *dev)
 	return 0;
 }
 
-static void lbs_tx_timeout(struct net_device *dev)
-{
-	struct lbs_private *priv = dev->ml_priv;
-
-	lbs_deb_enter(LBS_DEB_TX);
-
-	lbs_pr_err("tx watch dog timeout\n");
-
-	dev->trans_start = jiffies; /* prevent tx timeout */
-
-	if (priv->currenttxskb)
-		lbs_send_tx_feedback(priv, 0);
-
-	/* XX: Shouldn't we also call into the hw-specific driver
-	   to kick it somehow? */
-	lbs_host_to_card_done(priv);
-
-	/* FIXME: reset the card */
-
-	lbs_deb_leave(LBS_DEB_TX);
-}
-
 void lbs_host_to_card_done(struct lbs_private *priv)
 {
 	unsigned long flags;
@@ -785,7 +763,6 @@ static const struct net_device_ops lbs_netdev_ops = {
 	.ndo_stop		= lbs_eth_stop,
 	.ndo_start_xmit		= lbs_hard_start_xmit,
 	.ndo_set_mac_address	= lbs_set_mac_address,
-	.ndo_tx_timeout 	= lbs_tx_timeout,
 	.ndo_set_multicast_list = lbs_set_multicast_list,
 	.ndo_change_mtu		= eth_change_mtu,
 	.ndo_validate_addr	= eth_validate_addr,
-- 
1.7.4.4

