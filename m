Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.queued.net ([207.210.101.209]:1115 "EHLO mail.queued.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932424AbXKPSfQ (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 16 Nov 2007 13:35:16 -0500
Date: Fri, 16 Nov 2007 13:12:07 -0500
From: Andres Salomon <dilinger@queued.net>
To: libertas-dev@lists.infradead.org,
	Marcelo Tosatti <marcelo@kvack.org>,
	David Woodhouse <dwmw2@infradead.org>,
	akpm@linux-foundation.org
Cc: linux-wireless@vger.kernel.org
Subject: [PATCH 2/4] libertas: mark module_init/exit functions as
 __init/__exit
Message-ID: <20071116131207.08f37ddc@ephemeral> (sfid-20071116_183537_952881_22EEE6DE)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Signed-off-by: Andres Salomon <dilinger@debian.org>
---
 drivers/net/wireless/libertas/if_usb.c |    4 ++--
 drivers/net/wireless/libertas/main.c   |    4 ++--
 2 files changed, 4 insertions(+), 4 deletions(-)

diff --git a/drivers/net/wireless/libertas/if_usb.c b/drivers/net/wireless/libertas/if_usb.c
index 3cf9379..d376155 100644
--- a/drivers/net/wireless/libertas/if_usb.c
+++ b/drivers/net/wireless/libertas/if_usb.c
@@ -1122,7 +1122,7 @@ static struct usb_driver if_usb_driver = {
 	.resume = if_usb_resume,
 };
 
-static int if_usb_init_module(void)
+static int __init if_usb_init_module(void)
 {
 	int ret = 0;
 
@@ -1134,7 +1134,7 @@ static int if_usb_init_module(void)
 	return ret;
 }
 
-static void if_usb_exit_module(void)
+static void __exit if_usb_exit_module(void)
 {
 	struct usb_card_rec *cardp, *cardp_temp;
 	int i = 0;
diff --git a/drivers/net/wireless/libertas/main.c b/drivers/net/wireless/libertas/main.c
index 071778d..5871f55 100644
--- a/drivers/net/wireless/libertas/main.c
+++ b/drivers/net/wireless/libertas/main.c
@@ -1638,7 +1638,7 @@ int libertas_reset_device(wlan_private *priv)
 }
 EXPORT_SYMBOL_GPL(libertas_reset_device);
 
-static int libertas_init_module(void)
+static int __init libertas_init_module(void)
 {
 	lbs_deb_enter(LBS_DEB_MAIN);
 	libertas_debugfs_init();
@@ -1646,7 +1646,7 @@ static int libertas_init_module(void)
 	return 0;
 }
 
-static void libertas_exit_module(void)
+static void __exit libertas_exit_module(void)
 {
 	lbs_deb_enter(LBS_DEB_MAIN);
 
-- 
1.5.3.4

