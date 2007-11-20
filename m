Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx1.redhat.com ([66.187.233.31]:48659 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752894AbXKTWrR (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 20 Nov 2007 17:47:17 -0500
Subject: [PATCH 1/6] libertas: drop useless default_fw_name variable
From: Dan Williams <dcbw@redhat.com>
To: "John W. Linville" <linville@tuxdriver.com>
Cc: linux-wireless@vger.kernel.org,
	Andres Salomon <dilinger@debian.org>
Content-Type: text/plain
Date: Tue, 20 Nov 2007 17:43:32 -0500
Message-Id: <1195598612.32309.26.camel@localhost.localdomain> (sfid-20071120_224721_872949_51FC43DA)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Andres Salomon <dilinger@debian.org>

Signed-off-by: Andres Salomon <dilinger@debian.org>
Signed-off-by: Dan Williams <dcbw@redhat.com>


diff --git a/drivers/net/wireless/libertas/if_usb.c b/drivers/net/wireless/libertas/if_usb.c
index 797d3fb..6d19d26 100644
--- a/drivers/net/wireless/libertas/if_usb.c
+++ b/drivers/net/wireless/libertas/if_usb.c
@@ -19,9 +19,8 @@
 #define MESSAGE_HEADER_LEN	4
 
 static const char usbdriver_name[] = "usb8xxx";
-static u8 *default_fw_name = "usb8388.bin";
 
-static char *lbs_fw_name;
+static char *lbs_fw_name = "usb8388.bin";
 module_param_named(fw_name, lbs_fw_name, charp, 0644);
 
 /*
@@ -1027,10 +1026,6 @@ static int if_usb_init_module(void)
 
 	lbs_deb_enter(LBS_DEB_MAIN);
 
-	if (lbs_fw_name == NULL) {
-		lbs_fw_name = default_fw_name;
-	}
-
 	ret = usb_register(&if_usb_driver);
 
 	lbs_deb_leave_args(LBS_DEB_MAIN, "ret %d", ret);

