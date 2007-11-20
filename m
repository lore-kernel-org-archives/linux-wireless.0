Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx1.redhat.com ([66.187.233.31]:48681 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1760977AbXKTWrq (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 20 Nov 2007 17:47:46 -0500
Subject: [PATCH 4/6] libertas: nuke useless variable usbdriver_name and
	useless comments
From: Dan Williams <dcbw@redhat.com>
To: "John W. Linville" <linville@tuxdriver.com>
Cc: linux-wireless@vger.kernel.org,
	Andres Salomon <dilinger@debian.org>
Content-Type: text/plain
Date: Tue, 20 Nov 2007 17:44:04 -0500
Message-Id: <1195598644.32309.29.camel@localhost.localdomain> (sfid-20071120_224749_052954_8A0340BC)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Andres Salomon <dilinger@debian.org>

I think it was pretty obvious what fields in if_usb_driver are...

Signed-off-by: Andres Salomon <dilinger@debian.org>
Signed-off-by: Dan Williams <dcbw@redhat.com>

diff --git a/drivers/net/wireless/libertas/if_usb.c b/drivers/net/wireless/libertas/if_usb.c
index 4d4f757..043a33d 100644
--- a/drivers/net/wireless/libertas/if_usb.c
+++ b/drivers/net/wireless/libertas/if_usb.c
@@ -17,8 +17,6 @@
 
 #define MESSAGE_HEADER_LEN	4
 
-static const char usbdriver_name[] = "usb8xxx";
-
 static char *lbs_fw_name = "usb8388.bin";
 module_param_named(fw_name, lbs_fw_name, charp, 0644);
 
@@ -998,13 +996,9 @@ static int if_usb_resume(struct usb_interface *intf)
 #endif
 
 static struct usb_driver if_usb_driver = {
-	/* driver name */
-	.name = usbdriver_name,
-	/* probe function name */
+	.name = DRV_NAME,
 	.probe = if_usb_probe,
-	/* disconnect function  name */
 	.disconnect = if_usb_disconnect,
-	/* device signature table */
 	.id_table = if_usb_table,
 	.suspend = if_usb_suspend,
 	.resume = if_usb_resume,

