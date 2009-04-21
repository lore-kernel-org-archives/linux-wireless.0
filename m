Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp3.dnainternet.fi ([87.94.96.71]:40992 "EHLO
	smtp3.dnainternet.fi" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753065AbZDUQsN (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 21 Apr 2009 12:48:13 -0400
From: Jussi Kivilinna <jussi.kivilinna@mbnet.fi>
Subject: [PATCH 1/2] rndis_wlan: fix initialization order for workqueue&workers
To: linux-wireless@vger.kernel.org
Cc: linville@tuxdriver.com
Date: Tue, 21 Apr 2009 19:48:07 +0300
Message-ID: <20090421164807.3635.43002.stgit@fate.lan> (sfid-20090421_184817_926987_CBB73CBA)
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

rndis_wext_link_change() might be called from rndis_command() at
initialization stage and priv->workqueue/priv->work have not been
initialized yet. This causes invalid opcode at rndis_wext_bind on
some brands of bcm4320.

Fix by initializing workqueue/workers in rndis_wext_bind() before
rndis_command is used.

Signed-off-by: Jussi Kivilinna <jussi.kivilinna@mbnet.fi>
---

 drivers/net/wireless/rndis_wlan.c |   17 ++++++++++++-----
 1 files changed, 12 insertions(+), 5 deletions(-)

diff --git a/drivers/net/wireless/rndis_wlan.c b/drivers/net/wireless/rndis_wlan.c
index 109e603..d8b2e6a 100644
--- a/drivers/net/wireless/rndis_wlan.c
+++ b/drivers/net/wireless/rndis_wlan.c
@@ -2384,6 +2384,12 @@ static int rndis_wext_bind(struct usbnet *usbdev, struct usb_interface *intf)
 	mutex_init(&priv->command_lock);
 	spin_lock_init(&priv->stats_lock);
 
+	/* because rndis_command() sleeps we need to use workqueue */
+	priv->workqueue = create_singlethread_workqueue("rndis_wlan");
+	INIT_WORK(&priv->work, rndis_wext_worker);
+	INIT_DELAYED_WORK(&priv->stats_work, rndis_update_wireless_stats);
+	INIT_DELAYED_WORK(&priv->scan_work, rndis_get_scan_results);
+
 	/* try bind rndis_host */
 	retval = generic_rndis_bind(usbdev, intf, FLAG_RNDIS_PHYM_WIRELESS);
 	if (retval < 0)
@@ -2454,17 +2460,18 @@ static int rndis_wext_bind(struct usbnet *usbdev, struct usb_interface *intf)
 	disassociate(usbdev, 1);
 	netif_carrier_off(usbdev->net);
 
-	/* because rndis_command() sleeps we need to use workqueue */
-	priv->workqueue = create_singlethread_workqueue("rndis_wlan");
-	INIT_DELAYED_WORK(&priv->stats_work, rndis_update_wireless_stats);
 	queue_delayed_work(priv->workqueue, &priv->stats_work,
 		round_jiffies_relative(STATS_UPDATE_JIFFIES));
-	INIT_DELAYED_WORK(&priv->scan_work, rndis_get_scan_results);
-	INIT_WORK(&priv->work, rndis_wext_worker);
 
 	return 0;
 
 fail:
+	cancel_delayed_work_sync(&priv->stats_work);
+	cancel_delayed_work_sync(&priv->scan_work);
+	cancel_work_sync(&priv->work);
+	flush_workqueue(priv->workqueue);
+	destroy_workqueue(priv->workqueue);
+
 	kfree(priv);
 	return retval;
 }

