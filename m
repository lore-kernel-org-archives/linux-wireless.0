Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:59450 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751716AbYKFPeR (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 6 Nov 2008 10:34:17 -0500
Message-ID: <49130E75.1000903@suse.de> (sfid-20081106_163437_493434_35704301)
Date: Thu, 06 Nov 2008 16:34:13 +0100
From: Frank Seidel <fseidel@suse.de>
MIME-Version: 1.0
To: linux-wireless@vger.kernel.org
Cc: "David S. Miller" <davem@davemloft.net>,
	James Ketrenos <jketreno@linux.intel.com>
Subject: Problem with Kernel Oops in ipw2200
Content-Type: multipart/mixed;
 boundary="------------070908070404080406040100"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This is a multi-part message in MIME format.
--------------070908070404080406040100
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: 7bit

Hi,

after getting this bug
https://bugzilla.novell.com/show_bug.cgi?id=397390
i tried to reproduce this and even got a kernel Oops
in ipw2200 (ipw_tx_skb) after about 15 Minutes pinging
through a wpa enterprise connection.

After some tests i came up with the attaced patch that
fixes the issue for me here, but is probably the wrong
way to go as this is my first attempt in the wireless network
area.
Ever suggestion is very appreciated.

Thanks,
Frank

--------------070908070404080406040100
Content-Type: text/x-patch;
 name="ipw2200_panic_fix.patch"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
 filename="ipw2200_panic_fix.patch"

From: Frank Seidel <fseidel@suse.de>
Subject: fix panic on reauth
Patch-mainline: not yet
References: bnc#397390

This is mainly a rework/partly revocation of the patch
from David S. Miller <davem@davemloft.net>
commit 521c4d96e0840ecce25b956e00f416ed499ef2ba

Signed-off-by: Frank Seidel <fseidel@suse.de>

---
 drivers/net/wireless/ipw2200.c |   23 ++++++++++++++++++++++-
 1 file changed, 22 insertions(+), 1 deletion(-)

--- a/drivers/net/wireless/ipw2200.c
+++ b/drivers/net/wireless/ipw2200.c
@@ -10153,8 +10153,14 @@ static  void init_sys_config(struct ipw_
 
 static int ipw_net_open(struct net_device *dev)
 {
+	struct ipw_priv *priv = ieee80211_priv(dev);
 	IPW_DEBUG_INFO("dev->open\n");
-	netif_start_queue(dev);
+	/* we should be verifying the device is ready to be opened */
+	mutex_lock(&priv->mutex);
+	if (!(priv->status & STATUS_RF_KILL_MASK) &&
+	    (priv->status & STATUS_ASSOCIATED))
+		netif_start_queue(dev);
+	mutex_unlock(&priv->mutex);
 	return 0;
 }
 
@@ -10474,6 +10480,13 @@ static int ipw_net_hard_start_xmit(struc
 	IPW_DEBUG_TX("dev->xmit(%d bytes)\n", txb->payload_size);
 	spin_lock_irqsave(&priv->lock, flags);
 
+	if (!(priv->status & STATUS_ASSOCIATED)) {
+		IPW_DEBUG_INFO("Tx attempt while not associated.\n");
+		priv->ieee->stats.tx_carrier_errors++;
+		netif_stop_queue(dev);
+		goto fail_unlock;
+	}
+
 #ifdef CONFIG_IPW2200_PROMISCUOUS
 	if (rtap_iface && netif_running(priv->prom_net_dev))
 		ipw_handle_promiscuous_tx(priv, txb);
@@ -10485,6 +10498,10 @@ static int ipw_net_hard_start_xmit(struc
 	spin_unlock_irqrestore(&priv->lock, flags);
 
 	return ret;
+
+      fail_unlock:
+	spin_unlock_irqrestore(&priv->lock, flags);
+	return 1;
 }
 
 static struct net_device_stats *ipw_net_get_stats(struct net_device *dev)
@@ -10685,6 +10702,10 @@ static void ipw_link_up(struct ipw_priv
 	priv->last_packet_time = 0;
 
 	netif_carrier_on(priv->net_dev);
+	if (netif_queue_stopped(priv->net_dev)) {
+		IPW_DEBUG_NOTIF("waking queue\n");
+		netif_wake_queue(priv->net_dev);
+	}
 
 	cancel_delayed_work(&priv->request_scan);
 	cancel_delayed_work(&priv->request_direct_scan);

--------------070908070404080406040100--
