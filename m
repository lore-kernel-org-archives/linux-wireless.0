Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from arrakis.dune.hu ([78.24.191.176]:47392 "EHLO arrakis.dune.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751136Ab3FEKyG (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 5 Jun 2013 06:54:06 -0400
From: Gabor Juhos <juhosg@openwrt.org>
To: John Linville <linville@tuxdriver.com>
Cc: linux-wireless@vger.kernel.org, users@rt2x00.serialmonkey.com,
	Gabor Juhos <juhosg@openwrt.org>
Subject: [PATCH 2/2] rt2x00: rt2800usb: nuke rt2800usb_ops_5592
Date: Wed,  5 Jun 2013 12:54:00 +0200
Message-Id: <1370429640-31565-2-git-send-email-juhosg@openwrt.org> (sfid-20130605_125410_728809_37BBAA4B)
In-Reply-To: <1370429640-31565-1-git-send-email-juhosg@openwrt.org>
References: <1370429640-31565-1-git-send-email-juhosg@openwrt.org>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

It is exactly the same like the generic rt2800usb_ops.
Remove the duplicate and use the generic ops for all
devices.

Signed-off-by: Gabor Juhos <juhosg@openwrt.org>
---
 drivers/net/wireless/rt2x00/rt2800usb.c |   30 +++++-------------------------
 1 file changed, 5 insertions(+), 25 deletions(-)

diff --git a/drivers/net/wireless/rt2x00/rt2800usb.c b/drivers/net/wireless/rt2x00/rt2800usb.c
index 57729a8..c065d43 100644
--- a/drivers/net/wireless/rt2x00/rt2800usb.c
+++ b/drivers/net/wireless/rt2x00/rt2800usb.c
@@ -924,23 +924,6 @@ static const struct rt2x00_ops rt2800usb_ops = {
 #endif /* CONFIG_RT2X00_LIB_DEBUGFS */
 };
 
-static const struct rt2x00_ops rt2800usb_ops_5592 = {
-	.name			= KBUILD_MODNAME,
-	.drv_data_size		= sizeof(struct rt2800_drv_data),
-	.max_ap_intf		= 8,
-	.eeprom_size		= EEPROM_SIZE,
-	.rf_size		= RF_SIZE,
-	.tx_queues		= NUM_TX_QUEUES,
-	.extra_tx_headroom	= rt2800usb_extra_tx_headroom,
-	.queue_init		= rt2800usb_queue_init,
-	.lib			= &rt2800usb_rt2x00_ops,
-	.drv			= &rt2800usb_rt2800_ops,
-	.hw			= &rt2800usb_mac80211_ops,
-#ifdef CONFIG_RT2X00_LIB_DEBUGFS
-	.debugfs		= &rt2800_rt2x00debug,
-#endif /* CONFIG_RT2X00_LIB_DEBUGFS */
-};
-
 /*
  * rt2800usb module information.
  */
@@ -1253,15 +1236,15 @@ static struct usb_device_id rt2800usb_device_table[] = {
 #endif
 #ifdef CONFIG_RT2800USB_RT55XX
 	/* Arcadyan */
-	{ USB_DEVICE(0x043e, 0x7a32), .driver_info = 5592 },
+	{ USB_DEVICE(0x043e, 0x7a32) },
 	/* AVM GmbH */
-	{ USB_DEVICE(0x057c, 0x8501), .driver_info = 5592 },
+	{ USB_DEVICE(0x057c, 0x8501) },
 	/* D-Link DWA-160-B2 */
-	{ USB_DEVICE(0x2001, 0x3c1a), .driver_info = 5592 },
+	{ USB_DEVICE(0x2001, 0x3c1a) },
 	/* Proware */
-	{ USB_DEVICE(0x043e, 0x7a13), .driver_info = 5592 },
+	{ USB_DEVICE(0x043e, 0x7a13) },
 	/* Ralink */
-	{ USB_DEVICE(0x148f, 0x5572), .driver_info = 5592 },
+	{ USB_DEVICE(0x148f, 0x5572) },
 #endif
 #ifdef CONFIG_RT2800USB_UNKNOWN
 	/*
@@ -1366,9 +1349,6 @@ MODULE_LICENSE("GPL");
 static int rt2800usb_probe(struct usb_interface *usb_intf,
 			   const struct usb_device_id *id)
 {
-	if (id->driver_info == 5592)
-		return rt2x00usb_probe(usb_intf, &rt2800usb_ops_5592);
-
 	return rt2x00usb_probe(usb_intf, &rt2800usb_ops);
 }
 
-- 
1.7.10

