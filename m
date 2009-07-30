Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from saarni.dnainternet.net ([83.102.40.136]:38786 "EHLO
	saarni.dnainternet.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751354AbZG3QvJ (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 30 Jul 2009 12:51:09 -0400
From: Jussi Kivilinna <jussi.kivilinna@mbnet.fi>
Subject: [PATCH 02/10] rndis_wlan: stop workers on rndis_wlan_stop() and
	restore on rndis_wlan_reset()
To: linux-wireless@vger.kernel.org
Cc: linville@tuxdriver.com, Jussi Kivilinna <jussi.kivilinna@mbnet.fi>
Date: Thu, 30 Jul 2009 19:41:26 +0300
Message-ID: <20090730164126.28317.20258.stgit@fate.lan>
In-Reply-To: <20090730164120.28317.53313.stgit@fate.lan>
References: <20090730164120.28317.53313.stgit@fate.lan>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Driver doesn't need to poll statistics/link status when stopped.

Signed-off-by: Jussi Kivilinna <jussi.kivilinna@mbnet.fi>
---

 drivers/net/wireless/rndis_wlan.c |   23 +++++++++++++++++++----
 1 files changed, 19 insertions(+), 4 deletions(-)

diff --git a/drivers/net/wireless/rndis_wlan.c b/drivers/net/wireless/rndis_wlan.c
index 76c5ec6..3c7c620 100644
--- a/drivers/net/wireless/rndis_wlan.c
+++ b/drivers/net/wireless/rndis_wlan.c
@@ -2457,9 +2457,6 @@ static int rndis_wlan_bind(struct usbnet *usbdev, struct usb_interface *intf)
 	disassociate(usbdev, 1);
 	netif_carrier_off(usbdev->net);
 
-	queue_delayed_work(priv->workqueue, &priv->stats_work,
-		round_jiffies_relative(STATS_UPDATE_JIFFIES));
-
 	return 0;
 
 fail:
@@ -2499,15 +2496,33 @@ static void rndis_wlan_unbind(struct usbnet *usbdev, struct usb_interface *intf)
 
 static int rndis_wlan_reset(struct usbnet *usbdev)
 {
+	struct rndis_wlan_private *priv = get_rndis_wlan_priv(usbdev);
+
 	devdbg(usbdev, "rndis_wlan_reset");
+
+	queue_delayed_work(priv->workqueue, &priv->stats_work,
+		round_jiffies_relative(STATS_UPDATE_JIFFIES));
+
 	return deauthenticate(usbdev);
 }
 
 
 static int rndis_wlan_stop(struct usbnet *usbdev)
 {
+	struct rndis_wlan_private *priv = get_rndis_wlan_priv(usbdev);
+	int retval;
+
 	devdbg(usbdev, "rndis_wlan_stop");
-	return disassociate(usbdev, 0);
+
+	retval = disassociate(usbdev, 0);
+
+	priv->work_pending = 0;
+	cancel_delayed_work_sync(&priv->stats_work);
+	cancel_delayed_work_sync(&priv->scan_work);
+	cancel_work_sync(&priv->work);
+	flush_workqueue(priv->workqueue);
+
+	return retval;
 }
 
 

