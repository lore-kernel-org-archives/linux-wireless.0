Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from pne-smtpout3-sn1.fre.skanova.net ([81.228.11.120]:58351 "EHLO
	pne-smtpout3-sn1.fre.skanova.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755890AbYAYWuw (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 25 Jan 2008 17:50:52 -0500
From: Jussi Kivilinna <jussi.kivilinna@mbnet.fi>
Subject: [PATCH 02/14] [cdc_ether] Hardwire CDC descriptors when missing
To: linux-wireless@vger.kernel.org
Cc: netdev@vger.kernel.org, bjd@jooz.net, david-b@pacbell.net
Date: Sat, 26 Jan 2008 00:50:44 +0200
Message-ID: <20080125225044.11716.75749.stgit@fate.lan> (sfid-20080125_225057_122714_9DF0FFB8)
In-Reply-To: <20080125225032.11716.77713.stgit@fate.lan>
References: <20080125225032.11716.77713.stgit@fate.lan>
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

