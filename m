Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.hevs.ch ([153.109.23.15]:35438 "EHLO mail.hevs.ch"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756557AbXJOGwB (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 15 Oct 2007 02:52:01 -0400
From: Marc Pignat <marc.pignat@hevs.ch>
To: linux-wireless@vger.kernel.org
Subject: [PATCH] zd1211rw, fix oops when ejecting install media
Date: Mon, 15 Oct 2007 08:51:52 +0200
Cc: dsd@gentoo.org, kune@deine-taler.de, linux-kernel@vger.kernel.org
MIME-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Message-Id: <200710150851.52995.marc.pignat@hevs.ch> (sfid-20071015_075213_776743_F91893E6)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

The disconnect function can dereference the net_device structure before it is
allocated. This is the case when ejecting the device installer.

Signed-off-by: Marc Pignat <marc.pignat@hevs.ch>

---

Hello!

Patch against 2.6.23.
This patch fixes the bug I've submitted to linux-wireless friday in the
"zd1211rw on 2.6.23 oops ejecting device" thread.

Regards

Marc

--- drivers/net/wireless/zd1211rw/zd_usb.c.orig	2007-10-15 08:29:16.000000000 +0200
+++ drivers/net/wireless/zd1211rw/zd_usb.c	2007-10-15 08:29:32.000000000 +0200
@@ -1041,14 +1041,17 @@ error:
 static void disconnect(struct usb_interface *intf)
 {
 	struct net_device *netdev = zd_intf_to_netdev(intf);
-	struct zd_mac *mac = zd_netdev_mac(netdev);
-	struct zd_usb *usb = &mac->chip.usb;
+	struct zd_mac *mac;
+	struct zd_usb *usb;
 
 	/* Either something really bad happened, or we're just dealing with
 	 * a DEVICE_INSTALLER. */
 	if (netdev == NULL)
 		return;
 
+	mac = zd_netdev_mac(netdev);
+	usb = &mac->chip.usb;
+
 	dev_dbg_f(zd_usb_dev(usb), "\n");
 
 	zd_netdev_disconnect(netdev);


