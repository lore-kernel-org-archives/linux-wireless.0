Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from pne-smtpout4-sn2.hy.skanova.net ([81.228.8.154]:49048 "EHLO
	pne-smtpout4-sn2.hy.skanova.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752393AbYATAN7 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 19 Jan 2008 19:13:59 -0500
From: Jussi Kivilinna <jussi.kivilinna@mbnet.fi>
Subject: [PATCH 02/14] [cdc_ether] Hardwire CDC descriptors when missing
To: linux-wireless@vger.kernel.org
Cc: bjd@jooz.net, dbrownell@users.sourceforge.net,
	netdev@vger.kernel.org
Date: Sun, 20 Jan 2008 02:13:53 +0200
Message-ID: <20080120001353.25718.38880.stgit@fate.lan> (sfid-20080120_001402_238896_D9A37DB6)
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Bjorge Dijkstra <bjd@jooz.net>

Just as ActiveSync devices, some regular RNDIS devices also lack
the CDC descriptors (e.g. devices based on BCM4320 WLAN chip).
This patch hardwires the CDC descriptors for all RNDIS style devices
when they are missing.

Signed-off-by: Bjorge Dijkstra <bjd@jooz.net>
Signed-off-by: Jussi Kivilinna <jussi.kivilinna@mbnet.fi>
---

 drivers/net/usb/cdc_ether.c |   10 +++++-----
 1 files changed, 5 insertions(+), 5 deletions(-)

diff --git a/drivers/net/usb/cdc_ether.c b/drivers/net/usb/cdc_ether.c
index a42acc3..97c17bb 100644
--- a/drivers/net/usb/cdc_ether.c
+++ b/drivers/net/usb/cdc_ether.c
@@ -228,15 +228,16 @@ next_desc:
 		buf += buf [0];
 	}
 
-	/* Microsoft ActiveSync based RNDIS devices lack the CDC descriptors,
-	 * so we'll hard-wire the interfaces and not check for descriptors.
+	/* Microsoft ActiveSync based and some regular RNDIS devices lack the
+	 * CDC descriptors, so we'll hard-wire the interfaces and not check
+	 * for descriptors.
 	 */
-	if (is_activesync(&intf->cur_altsetting->desc) && !info->u) {
+	if (rndis && !info->u) {
 		info->control = usb_ifnum_to_if(dev->udev, 0);
 		info->data = usb_ifnum_to_if(dev->udev, 1);
 		if (!info->control || !info->data) {
 			dev_dbg(&intf->dev,
-				"activesync: master #0/%p slave #1/%p\n",
+				"rndis: master #0/%p slave #1/%p\n",
 				info->control,
 				info->data);
 			goto bad_desc;
@@ -316,7 +317,6 @@ void usbnet_cdc_unbind(struct usbnet *dev, struct usb_interface *intf)
 }
 EXPORT_SYMBOL_GPL(usbnet_cdc_unbind);
 
-
 /*-------------------------------------------------------------------------
  *
  * Communications Device Class, Ethernet Control model

