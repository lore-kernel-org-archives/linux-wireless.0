Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx1.redhat.com ([66.187.233.31]:48667 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1760556AbXKTWra (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 20 Nov 2007 17:47:30 -0500
Subject: [PATCH 2/6] libertas: mark module_init/exit functions as
	__init/__exit
From: Dan Williams <dcbw@redhat.com>
To: "John W. Linville" <linville@tuxdriver.com>
Cc: linux-wireless@vger.kernel.org,
	Andres Salomon <dilinger@debian.org>
Content-Type: text/plain
Date: Tue, 20 Nov 2007 17:43:45 -0500
Message-Id: <1195598625.32309.27.camel@localhost.localdomain> (sfid-20071120_224733_747192_C29988E9)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Andres Salomon <dilinger@debian.org>

Signed-off-by: Andres Salomon <dilinger@debian.org>
Signed-off-by: Dan Williams <dcbw@redhat.com>


diff --git a/drivers/net/wireless/libertas/if_sdio.c b/drivers/net/wireless/libertas/if_sdio.c
index d89f673..13b3a91 100644
--- a/drivers/net/wireless/libertas/if_sdio.c
+++ b/drivers/net/wireless/libertas/if_sdio.c
@@ -1048,7 +1048,7 @@ static struct sdio_driver if_sdio_driver = {
 /* Module functions                                                */
 /*******************************************************************/
 
-static int if_sdio_init_module(void)
+static int __init if_sdio_init_module(void)
 {
 	int ret = 0;
 
@@ -1064,7 +1064,7 @@ static int if_sdio_init_module(void)
 	return ret;
 }
 
-static void if_sdio_exit_module(void)
+static void __exit if_sdio_exit_module(void)
 {
 	lbs_deb_enter(LBS_DEB_SDIO);
 
diff --git a/drivers/net/wireless/libertas/if_usb.c b/drivers/net/wireless/libertas/if_usb.c
index 6d19d26..f7d2b46 100644
--- a/drivers/net/wireless/libertas/if_usb.c
+++ b/drivers/net/wireless/libertas/if_usb.c
@@ -1020,7 +1020,7 @@ static struct usb_driver if_usb_driver = {
 	.resume = if_usb_resume,
 };
 
-static int if_usb_init_module(void)
+static int __init if_usb_init_module(void)
 {
 	int ret = 0;
 
@@ -1032,7 +1032,7 @@ static int if_usb_init_module(void)
 	return ret;
 }
 
-static void if_usb_exit_module(void)
+static void __exit if_usb_exit_module(void)
 {
 	struct usb_card_rec *cardp, *cardp_temp;
 
diff --git a/drivers/net/wireless/libertas/main.c b/drivers/net/wireless/libertas/main.c
index 0a4f202..959e898 100644
--- a/drivers/net/wireless/libertas/main.c
+++ b/drivers/net/wireless/libertas/main.c
@@ -1514,7 +1514,7 @@ int lbs_reset_device(lbs_private *priv)
 }
 EXPORT_SYMBOL_GPL(lbs_reset_device);
 
-static int lbs_init_module(void)
+static int __init lbs_init_module(void)
 {
 	lbs_deb_enter(LBS_DEB_MAIN);
 	lbs_debugfs_init();
@@ -1522,7 +1522,7 @@ static int lbs_init_module(void)
 	return 0;
 }
 
-static void lbs_exit_module(void)
+static void __exit lbs_exit_module(void)
 {
 	lbs_deb_enter(LBS_DEB_MAIN);
 

