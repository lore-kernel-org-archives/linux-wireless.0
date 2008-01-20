Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from pne-smtpout4-sn2.hy.skanova.net ([81.228.8.154]:49048 "EHLO
	pne-smtpout4-sn2.hy.skanova.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754037AbYATAOV (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 19 Jan 2008 19:14:21 -0500
From: Jussi Kivilinna <jussi.kivilinna@mbnet.fi>
Subject: [PATCH 06/14] [usbnet] Use wlan device name for RNDIS wireless devices
To: linux-wireless@vger.kernel.org
Cc: bjd@jooz.net, dbrownell@users.sourceforge.net,
	netdev@vger.kernel.org
Date: Sun, 20 Jan 2008 02:14:15 +0200
Message-ID: <20080120001415.25718.1762.stgit@fate.lan> (sfid-20080120_001424_715940_75418ADA)
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Use wlan device name for RNDIS wireless devices.

Signed-off-by: Jussi Kivilinna <jussi.kivilinna@mbnet.fi>
Signed-off-by: Bjorge Dijkstra <bjd@jooz.net>
---

 drivers/net/usb/usbnet.c |    3 +++
 drivers/net/usb/usbnet.h |    2 ++
 2 files changed, 5 insertions(+), 0 deletions(-)

diff --git a/drivers/net/usb/usbnet.c b/drivers/net/usb/usbnet.c
index 8ed1fc5..a2a2d5e 100644
--- a/drivers/net/usb/usbnet.c
+++ b/drivers/net/usb/usbnet.c
@@ -1204,6 +1204,9 @@ usbnet_probe (struct usb_interface *udev, const struct usb_device_id *prod)
 		if ((dev->driver_info->flags & FLAG_ETHER) != 0
 				&& (net->dev_addr [0] & 0x02) == 0)
 			strcpy (net->name, "eth%d");
+		/* WLAN devices should always be named "wlan%d" */
+		if ((dev->driver_info->flags & FLAG_WLAN) != 0)
+			strcpy(net->name, "wlan%d");
 
 		/* maybe the remote can't receive an Ethernet MTU */
 		if (net->mtu > (dev->hard_mtu - net->hard_header_len))
diff --git a/drivers/net/usb/usbnet.h b/drivers/net/usb/usbnet.h
index 1fae434..29ab92e 100644
--- a/drivers/net/usb/usbnet.h
+++ b/drivers/net/usb/usbnet.h
@@ -87,6 +87,8 @@ struct driver_info {
 #define FLAG_ETHER	0x0020		/* maybe use "eth%d" names */
 
 #define FLAG_FRAMING_AX 0x0040		/* AX88772/178 packets */
+#define FLAG_WLAN	0x0080		/* use "wlan%d" names */
+
 
 	/* init device ... can sleep, or cause probe() failure */
 	int	(*bind)(struct usbnet *, struct usb_interface *);

