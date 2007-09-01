Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from c60.cesmail.net ([216.154.195.49]:36251 "EHLO c60.cesmail.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751588AbXIAEfz (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Sat, 1 Sep 2007 00:35:55 -0400
Received: from dv.roinet.com (static-72-92-88-10.phlapa.fios.verizon.net [72.92.88.10])
	by relay.cesmail.net (Postfix) with ESMTP id C9847618FE1
	for <linux-wireless@vger.kernel.org>; Sat,  1 Sep 2007 00:35:46 -0400 (EDT)
From: Pavel Roskin <proski@gnu.org>
Subject: [PATCH 16/35] Don't disable and enable tasklets,  it doesn't work as expected
To: linux-wireless@vger.kernel.org
Date: Sat, 01 Sep 2007 00:35:46 -0400
Message-ID: <20070901043546.2498.56818.stgit@dv.roinet.com>
In-Reply-To: <20070901043233.2498.95850.stgit@dv.roinet.com>
References: <20070901043233.2498.95850.stgit@dv.roinet.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Bringing the interface down causes high CPU utilization.  Correct fix
should probably disable rx URB, not only the rx tasklet.

Signed-off-by: Pavel Roskin <proski@gnu.org>
---

 drivers/net/wireless/at76_usb.c |    5 -----
 1 files changed, 0 insertions(+), 5 deletions(-)


diff --git a/drivers/net/wireless/at76_usb.c b/drivers/net/wireless/at76_usb.c
index 5577606..218641e 100644
--- a/drivers/net/wireless/at76_usb.c
+++ b/drivers/net/wireless/at76_usb.c
@@ -3445,7 +3445,6 @@ static int at76_open(struct net_device *netdev)
 		goto error;
 	}
 
-	tasklet_enable(&priv->rx_tasklet);
 	schedule_delayed_work(&priv->dwork_restart, 0);
 
 	at76_dbg(DBG_PROC_ENTRY, "%s(): end", __func__);
@@ -3463,7 +3462,6 @@ static int at76_stop(struct net_device *netdev)
 	if (mutex_lock_interruptible(&priv->mtx))
 		return -EINTR;
 
-	tasklet_disable(&priv->rx_tasklet);
 	at76_quiesce(priv);
 
 	if (!priv->device_unplugged) {
@@ -5375,7 +5373,6 @@ static struct at76_priv *at76_alloc_new_device(struct usb_device *udev)
 
 	priv->rx_tasklet.func = at76_rx_tasklet;
 	priv->rx_tasklet.data = 0;
-	tasklet_disable(&priv->rx_tasklet);
 
 	priv->pm_mode = AT76_PM_OFF;
 	priv->pm_period = 0;
@@ -5535,8 +5532,6 @@ static void at76_delete_device(struct at76_priv *priv)
 	/* The device is gone, don't bother turning it off */
 	priv->device_unplugged = 1;
 
-	tasklet_kill(&priv->rx_tasklet);
-
 	if (priv->netdev_registered)
 		unregister_netdev(priv->netdev);
 
