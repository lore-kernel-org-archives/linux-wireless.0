Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx1.redhat.com ([66.187.233.31]:48672 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1760974AbXKTWri (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 20 Nov 2007 17:47:38 -0500
Subject: [PATCH 3/6] libertas: reset devices upon disconnect rather than
	module unloading
From: Dan Williams <dcbw@redhat.com>
To: "John W. Linville" <linville@tuxdriver.com>
Cc: linux-wireless@vger.kernel.org,
	Andres Salomon <dilinger@debian.org>
Content-Type: text/plain
Date: Tue, 20 Nov 2007 17:43:55 -0500
Message-Id: <1195598635.32309.28.camel@localhost.localdomain> (sfid-20071120_224741_813247_5324F90E)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Andres Salomon <dilinger@debian.org>

1) Do not reset libertas devices upon module unload.  We're unloading
the module, we're not killing off devices.
2) Instead, reset libertas devices inside if_usb_disconnect, as we're
killing off interfaces and so on.
3) Resetting via disconnect callback means we no longer need to keep
track of probed libertas devices; kill off that list (and its wonderful
lack of locking..), as well.

Drop a useless comment as well.

Signed-off-by: Andres Salomon <dilinger@debian.org>
Signed-off-by: Dan Williams <dcbw@redhat.com>

diff --git a/drivers/net/wireless/libertas/if_usb.c b/drivers/net/wireless/libertas/if_usb.c
index f7d2b46..4d4f757 100644
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
 static char *lbs_fw_name = "usb8388.bin";
 module_param_named(fw_name, lbs_fw_name, charp, 0644);
 
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
 	if (lbs_start_card(priv))
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
 		lbs_adapter *adapter = priv->adapter;
 
@@ -290,6 +276,10 @@ static void if_usb_disconnect(struct usb_interface *intf)
 		lbs_remove_card(priv);
 	}
 
+	/* this is (apparently?) necessary for future usage of the device */
+	lbs_prepare_and_send_command(priv, CMD_802_11_RESET, CMD_ACT_HALT,
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
-		lbs_prepare_and_send_command(cardp->priv, CMD_802_11_RESET,
-		                                  CMD_ACT_HALT, 0, 0, NULL);
-	}
-
-	/* API unregisters the driver from USB subsystem */
 	usb_deregister(&if_usb_driver);
 
 	lbs_deb_leave(LBS_DEB_MAIN);
diff --git a/drivers/net/wireless/libertas/if_usb.h b/drivers/net/wireless/libertas/if_usb.h
index 9b42308..f53ddb2 100644
--- a/drivers/net/wireless/libertas/if_usb.h
+++ b/drivers/net/wireless/libertas/if_usb.h
@@ -1,8 +1,6 @@
 #ifndef _LBS_IF_USB_H
 #define _LBS_IF_USB_H
 
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

