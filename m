Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from emh04.mail.saunalahti.fi ([62.142.5.110]:33165 "EHLO
	emh04.mail.saunalahti.fi" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750894AbYFLRTI (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 12 Jun 2008 13:19:08 -0400
From: Jussi Kivilinna <jussi.kivilinna@mbnet.fi>
Subject: [PATCH] rndis_wlan: use kzalloc to allocate private data
To: linux-wireless@vger.kernel.org
Cc: linville@tuxdriver.com
Date: Thu, 12 Jun 2008 20:19:01 +0300
Message-ID: <20080612171901.15225.25655.stgit@nanoha.lan> (sfid-20080612_191912_613771_7F270C59)
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

rndis_wlan used kmalloc to allocate private data structure and leaving data
uninitialized, but later assumed to be set zero.

Signed-off-by: Jussi Kivilinna <jussi.kivilinna@mbnet.fi>
---

 drivers/net/wireless/rndis_wlan.c |    4 +---
 1 files changed, 1 insertions(+), 3 deletions(-)

diff --git a/drivers/net/wireless/rndis_wlan.c b/drivers/net/wireless/rndis_wlan.c
index 8505d8b..6eb487d 100644
--- a/drivers/net/wireless/rndis_wlan.c
+++ b/drivers/net/wireless/rndis_wlan.c
@@ -2522,7 +2522,7 @@ static int rndis_wext_bind(struct usbnet *usbdev, struct usb_interface *intf)
 	__le32 tmp;
 
 	/* allocate rndis private data */
-	priv = kmalloc(sizeof(struct rndis_wext_private), GFP_KERNEL);
+	priv = kzalloc(sizeof(struct rndis_wext_private), GFP_KERNEL);
 	if (!priv)
 		return -ENOMEM;
 
@@ -2530,8 +2530,6 @@ static int rndis_wext_bind(struct usbnet *usbdev, struct usb_interface *intf)
 	 * Otherwise we'll be in big trouble in rndis_wext_early_init().
 	 */
 	usbdev->driver_priv = priv;
-	memset(priv, 0, sizeof(*priv));
-	memset(priv->name, 0, sizeof(priv->name));
 	strcpy(priv->name, "IEEE802.11");
 	usbdev->net->wireless_handlers = &rndis_iw_handlers;
 	priv->usbdev = usbdev;

