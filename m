Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.queued.net ([207.210.101.209]:1114 "EHLO mail.queued.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932375AbXKPSfO convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 16 Nov 2007 13:35:14 -0500
Date: Fri, 16 Nov 2007 13:12:11 -0500
From: Andres Salomon <dilinger@queued.net>
To: libertas-dev@lists.infradead.org
Cc: linux-wireless@vger.kernel.org,
	Marcelo Tosatti <marcelo@kvack.org>,
	David Woodhouse <dwmw2@infradead.org>,
	akpm@linux-foundation.org
Subject: [PATCH 3/4] libertas: reset devices upon disconnect rather than
 module unloading
Message-ID: <20071116131211.7442f21e@ephemeral> (sfid-20071116_183536_592922_684012D8)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

>From c211b9b3a13b9eccbd4d51020fff8eba04ba55a5 Mon Sep 17 00:00:00 2001
From: Andres Salomon <dilinger@debian.org>
Date: Fri, 16 Nov 2007 12:48:07 -0500
Subject: [PATCH] libertas: reset devices upon disconnect rather than module unloading

1) Do not reset libertas devices upon module unload.  We're unloading
the module, we're not killing off devices.
2) Instead, reset libertas devices inside if_usb_disconnect, as we're
killing off interfaces and so on.
3) Resetting via disconnect callback means we no longer need to keep
track of probed libertas devices; kill off that list (and its wonderful
lack of locking..), as well.

Drop a useless comment as well.

Signed-off-by: Andres Salomon <dilinger@debian.org>
---
 drivers/net/wireless/libertas/if_usb.c |   26 ++++----------------------
 drivers/net/wireless/libertas/if_usb.h |    3 ---
 2 files changed, 4 insertions(+), 25 deletions(-)

diff --git a/drivers/net/wireless/libertas/if_usb.c b/drivers/net/wireless/libertas/if_usb.c
index fab0d0c..f5cf964 100644
--- a/drivers/net/wireless/libertas/if_usb.c
+++ b/drivers/net/wireless/libertas/if_usb.c
@@ -5,7 +5,6 @@
 #include <linux/moduleparam.h>
 #include <linux/firmware.h>
 #include <linux/netdevice.h>
-#include <linux/list.h>
 #include <linux/usb.h>
 
 #define DRV_NAME "usb8xxx"
@@ -23,15 +22,6 @@ static const char usbdriver_name[] = "usb8xxx";
 static char *libertas_fw_name = "usb8388.bin";
 module_param_named(fw_name, libertas_fw_name, charp, 0644);
 
-/*
- * We need to send a RESET command to all USB devices before
- * we tear down the USB connection. Otherwise we would not
- * be able to re-init device the device if the module gets
- * loaded again. This is a list of all initialized USB devices,
- * for the reset code see if_usb_reset_device()
-*/
-static LIST_HEAD(usb_devices);
-
 static struct usb_device_id if_usb_table[] = {
 	/* Enter the device signature inside */
 	{ USB_DEVICE(0x1286, 0x2001) },
@@ -244,8 +234,6 @@ static int if_usb_probe(struct usb_interface *intf,
 	if (libertas_start_card(priv))
 		goto err_start_card;
 
-	list_add_tail(&cardp->list, &usb_devices);
-
 	usb_get_dev(udev);
 	usb_set_intfdata(intf, cardp);
 
@@ -279,8 +267,6 @@ static void if_usb_disconnect(struct usb_interface *intf)
 	/* Update Surprise removed to TRUE */
 	cardp->surprise_removed = 1;
 
-	list_del(&cardp->list);
-
 	if (priv) {
 		wlan_adapter *adapter = priv->adapter;
 
@@ -290,6 +276,10 @@ static void if_usb_disconnect(struct usb_interface *intf)
 		libertas_remove_card(priv);
 	}
 
+	/* this is (apparently?) necessary for future usage of the device */
+	libertas_prepare_and_send_command(priv, CMD_802_11_RESET, CMD_ACT_HALT,
+			0, 0, NULL);
+
 	/* Unlink and free urb */
 	if_usb_free(cardp);
 
@@ -1034,16 +1024,8 @@ static int __init if_usb_init_module(void)
 
 static void __exit if_usb_exit_module(void)
 {
-	struct usb_card_rec *cardp, *cardp_temp;
-
 	lbs_deb_enter(LBS_DEB_MAIN);
 
-	list_for_each_entry_safe(cardp, cardp_temp, &usb_devices, list) {
-		libertas_prepare_and_send_command(cardp->priv, CMD_802_11_RESET,
-		                                  CMD_ACT_HALT, 0, 0, NULL);
-	}
-
-	/* API unregisters the driver from USB subsystem */
 	usb_deregister(&if_usb_driver);
 
 	lbs_deb_leave(LBS_DEB_MAIN);
diff --git a/drivers/net/wireless/libertas/if_usb.h b/drivers/net/wireless/libertas/if_usb.h
index e07a10e..55bbb52 100644
--- a/drivers/net/wireless/libertas/if_usb.h
+++ b/drivers/net/wireless/libertas/if_usb.h
@@ -1,8 +1,6 @@
 #ifndef _LIBERTAS_IF_USB_H
 #define _LIBERTAS_IF_USB_H
 
-#include <linux/list.h>
-
 /**
   * This file contains definition for USB interface.
   */
@@ -44,7 +42,6 @@ struct read_cb_info {
 
 /** USB card description structure*/
 struct usb_card_rec {
-	struct list_head list;
 	struct net_device *eth_dev;
 	struct usb_device *udev;
 	struct urb *rx_urb, *tx_urb;
-- 
1.5.3.4

