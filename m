Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from sypressi.dnainternet.net ([83.102.40.135]:43265 "EHLO
	sypressi.dnainternet.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751006AbZG3Qrf (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 30 Jul 2009 12:47:35 -0400
From: Jussi Kivilinna <jussi.kivilinna@mbnet.fi>
Subject: [PATCH 01/10] usbnet: allow "minidriver" to prevent urb unlinking on
	usbnet_stop
To: linux-wireless@vger.kernel.org
Cc: linville@tuxdriver.com, Jussi Kivilinna <jussi.kivilinna@mbnet.fi>,
	David Brownell <dbrownell@users.sourceforge.net>
Date: Thu, 30 Jul 2009 19:41:20 +0300
Message-ID: <20090730164120.28317.53313.stgit@fate.lan>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

rndis_wlan devices freeze after running usbnet_stop several times. It appears
that firmware freezes in state where it does not respond to any RNDIS commands
and device have to be physically unplugged/replugged. This patch lets
minidrivers to disable unlink_urbs on usbnet_stop through new info flag.

Signed-off-by: Jussi Kivilinna <jussi.kivilinna@mbnet.fi>
Cc: David Brownell <dbrownell@users.sourceforge.net>
---

 drivers/net/usb/usbnet.c          |   32 ++++++++++++++++++--------------
 drivers/net/wireless/rndis_wlan.c |    9 ++++++---
 include/linux/usb/usbnet.h        |    1 +
 3 files changed, 25 insertions(+), 17 deletions(-)

diff --git a/drivers/net/usb/usbnet.c b/drivers/net/usb/usbnet.c
index 25e435c..af1fe46 100644
--- a/drivers/net/usb/usbnet.c
+++ b/drivers/net/usb/usbnet.c
@@ -601,21 +601,25 @@ int usbnet_stop (struct net_device *net)
 				info->description);
 	}
 
-	// ensure there are no more active urbs
-	add_wait_queue (&unlink_wakeup, &wait);
-	dev->wait = &unlink_wakeup;
-	temp = unlink_urbs (dev, &dev->txq) + unlink_urbs (dev, &dev->rxq);
-
-	// maybe wait for deletions to finish.
-	while (!skb_queue_empty(&dev->rxq)
-			&& !skb_queue_empty(&dev->txq)
-			&& !skb_queue_empty(&dev->done)) {
-		msleep(UNLINK_TIMEOUT_MS);
-		if (netif_msg_ifdown (dev))
-			devdbg (dev, "waited for %d urb completions", temp);
+	if (!(info->flags & FLAG_AVOID_UNLINK_URBS)) {
+		/* ensure there are no more active urbs */
+		add_wait_queue(&unlink_wakeup, &wait);
+		dev->wait = &unlink_wakeup;
+		temp = unlink_urbs(dev, &dev->txq) +
+			unlink_urbs(dev, &dev->rxq);
+
+		/* maybe wait for deletions to finish. */
+		while (!skb_queue_empty(&dev->rxq)
+				&& !skb_queue_empty(&dev->txq)
+				&& !skb_queue_empty(&dev->done)) {
+			msleep(UNLINK_TIMEOUT_MS);
+			if (netif_msg_ifdown(dev))
+				devdbg(dev, "waited for %d urb completions",
+					temp);
+		}
+		dev->wait = NULL;
+		remove_wait_queue(&unlink_wakeup, &wait);
 	}
-	dev->wait = NULL;
-	remove_wait_queue (&unlink_wakeup, &wait);
 
 	usb_kill_urb(dev->interrupt);
 
diff --git a/drivers/net/wireless/rndis_wlan.c b/drivers/net/wireless/rndis_wlan.c
index 09c0702..76c5ec6 100644
--- a/drivers/net/wireless/rndis_wlan.c
+++ b/drivers/net/wireless/rndis_wlan.c
@@ -2513,7 +2513,8 @@ static int rndis_wlan_stop(struct usbnet *usbdev)
 
 static const struct driver_info	bcm4320b_info = {
 	.description =	"Wireless RNDIS device, BCM4320b based",
-	.flags =	FLAG_WLAN | FLAG_FRAMING_RN | FLAG_NO_SETINT,
+	.flags =	FLAG_WLAN | FLAG_FRAMING_RN | FLAG_NO_SETINT |
+				FLAG_AVOID_UNLINK_URBS,
 	.bind =		rndis_wlan_bind,
 	.unbind =	rndis_wlan_unbind,
 	.status =	rndis_status,
@@ -2527,7 +2528,8 @@ static const struct driver_info	bcm4320b_info = {
 
 static const struct driver_info	bcm4320a_info = {
 	.description =	"Wireless RNDIS device, BCM4320a based",
-	.flags =	FLAG_WLAN | FLAG_FRAMING_RN | FLAG_NO_SETINT,
+	.flags =	FLAG_WLAN | FLAG_FRAMING_RN | FLAG_NO_SETINT |
+				FLAG_AVOID_UNLINK_URBS,
 	.bind =		rndis_wlan_bind,
 	.unbind =	rndis_wlan_unbind,
 	.status =	rndis_status,
@@ -2541,7 +2543,8 @@ static const struct driver_info	bcm4320a_info = {
 
 static const struct driver_info rndis_wlan_info = {
 	.description =	"Wireless RNDIS device",
-	.flags =	FLAG_WLAN | FLAG_FRAMING_RN | FLAG_NO_SETINT,
+	.flags =	FLAG_WLAN | FLAG_FRAMING_RN | FLAG_NO_SETINT |
+				FLAG_AVOID_UNLINK_URBS,
 	.bind =		rndis_wlan_bind,
 	.unbind =	rndis_wlan_unbind,
 	.status =	rndis_status,
diff --git a/include/linux/usb/usbnet.h b/include/linux/usb/usbnet.h
index 7c17b2e..c642f78 100644
--- a/include/linux/usb/usbnet.h
+++ b/include/linux/usb/usbnet.h
@@ -86,6 +86,7 @@ struct driver_info {
 
 #define FLAG_FRAMING_AX 0x0040		/* AX88772/178 packets */
 #define FLAG_WLAN	0x0080		/* use "wlan%d" names */
+#define FLAG_AVOID_UNLINK_URBS 0x0100	/* don't unlink urbs at usbnet_stop() */
 
 
 	/* init device ... can sleep, or cause probe() failure */

