Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from sypressi.dnainternet.net ([83.102.40.135]:33315 "EHLO
	sypressi.dnainternet.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759066AbZFPO00 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 16 Jun 2009 10:26:26 -0400
From: Jussi Kivilinna <jussi.kivilinna@mbnet.fi>
Subject: [PATCH 2/3] usbnet: Add stop function pointer to 'struct rndis_data'.
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org,
	Jussi Kivilinna <jussi.kivilinna@mbnet.fi>,
	David Brownell <dbrownell@users.sourceforge.net>
Date: Tue, 16 Jun 2009 17:17:27 +0300
Message-ID: <20090616141727.23639.22861.stgit@fate.lan>
In-Reply-To: <20090616141721.23639.15379.stgit@fate.lan>
References: <20090616141721.23639.15379.stgit@fate.lan>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Allow minidriver to know that netdev has stopped. This is to let
wireless turn off radio when usbnet dev is stopped.

Signed-off-by: Jussi Kivilinna <jussi.kivilinna@mbnet.fi>
CC: David Brownell <dbrownell@users.sourceforge.net>
---

 drivers/net/usb/usbnet.c   |   14 ++++++++++++++
 include/linux/usb/usbnet.h |    3 +++
 2 files changed, 17 insertions(+), 0 deletions(-)

diff --git a/drivers/net/usb/usbnet.c b/drivers/net/usb/usbnet.c
index f3a2fce..80251f0 100644
--- a/drivers/net/usb/usbnet.c
+++ b/drivers/net/usb/usbnet.c
@@ -544,7 +544,9 @@ EXPORT_SYMBOL_GPL(usbnet_unlink_rx_urbs);
 int usbnet_stop (struct net_device *net)
 {
 	struct usbnet		*dev = netdev_priv(net);
+	struct driver_info	*info = dev->driver_info;
 	int			temp;
+	int			retval;
 	DECLARE_WAIT_QUEUE_HEAD_ONSTACK (unlink_wakeup);
 	DECLARE_WAITQUEUE (wait, current);
 
@@ -556,6 +558,18 @@ int usbnet_stop (struct net_device *net)
 			dev->stats.rx_errors, dev->stats.tx_errors
 			);
 
+	/* allow minidriver to stop correctly (wireless devices to turn off
+	 * radio etc) */
+	if (info->stop) {
+		retval = info->stop(dev);
+		if (retval < 0 && netif_msg_ifdown(dev))
+			devinfo(dev,
+				"stop fail (%d) usbnet usb-%s-%s, %s",
+				retval,
+				dev->udev->bus->bus_name, dev->udev->devpath,
+				info->description);
+	}
+
 	// ensure there are no more active urbs
 	add_wait_queue (&unlink_wakeup, &wait);
 	dev->wait = &unlink_wakeup;
diff --git a/include/linux/usb/usbnet.h b/include/linux/usb/usbnet.h
index 36fabb9..e219fa2 100644
--- a/include/linux/usb/usbnet.h
+++ b/include/linux/usb/usbnet.h
@@ -98,6 +98,9 @@ struct driver_info {
 	/* reset device ... can sleep */
 	int	(*reset)(struct usbnet *);
 
+	/* stop device ... can sleep */
+	int	(*stop)(struct usbnet *);
+
 	/* see if peer is connected ... can sleep */
 	int	(*check_connect)(struct usbnet *);
 

