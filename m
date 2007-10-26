Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from ra.tuxdriver.com ([70.61.120.52]:3284 "EHLO ra.tuxdriver.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1764773AbXJZVFs (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 26 Oct 2007 17:05:48 -0400
From: "John W. Linville" <linville@tuxdriver.com>
To: stable@kernel.org
Cc: linux-wireless@vger.kernel.org, Marc Pignat <marc.pignat@hevs.ch>,
	"John W. Linville" <linville@tuxdriver.com>
Subject: [PATCH] zd1211rw, fix oops when ejecting install media
Date: Fri, 26 Oct 2007 17:04:39 -0400
Message-Id: <11934326832747-git-send-email-linville@tuxdriver.com> (sfid-20071026_220600_294339_D9B05AC8)
In-Reply-To: <11934326831563-git-send-email-linville@tuxdriver.com>
References: <11934326793639-git-send-email-linville@tuxdriver.com>
 <11934326801557-git-send-email-linville@tuxdriver.com>
 <11934326803769-git-send-email-linville@tuxdriver.com>
 <11934326803330-git-send-email-linville@tuxdriver.com>
 <11934326811535-git-send-email-linville@tuxdriver.com>
 <11934326813508-git-send-email-linville@tuxdriver.com>
 <1193432681145-git-send-email-linville@tuxdriver.com>
 <11934326812028-git-send-email-linville@tuxdriver.com>
 <11934326813245-git-send-email-linville@tuxdriver.com>
 <11934326823646-git-send-email-linville@tuxdriver.com>
 <11934326821301-git-send-email-linville@tuxdriver.com>
 <11934326823109-git-send-email-linville@tuxdriver.com>
 <11934326821662-git-send-email-linville@tuxdriver.com>
 <11934326831029-git-send-email-linville@tuxdriver.com>
 <11934326831563-git-send-email-linville@tuxdriver.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Marc Pignat <marc.pignat@hevs.ch>

The disconnect function can dereference the net_device structure when it
is never allocated. This is the case when ejecting the device installer.

Signed-off-by: Marc Pignat <marc.pignat@hevs.ch>
Acked-by: Daniel Drake <dsd@gentoo.org>
Signed-off-by: John W. Linville <linville@tuxdriver.com>
---
 drivers/net/wireless/zd1211rw/zd_usb.c |    7 +++++--
 1 files changed, 5 insertions(+), 2 deletions(-)

diff --git a/drivers/net/wireless/zd1211rw/zd_usb.c b/drivers/net/wireless/zd1211rw/zd_usb.c
index a9c339e..5326301 100644
--- a/drivers/net/wireless/zd1211rw/zd_usb.c
+++ b/drivers/net/wireless/zd1211rw/zd_usb.c
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
-- 
1.5.2.4

