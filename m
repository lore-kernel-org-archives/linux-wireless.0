Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.queued.net ([207.210.101.209]:1116 "EHLO mail.queued.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932465AbXKPSfQ (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 16 Nov 2007 13:35:16 -0500
Date: Fri, 16 Nov 2007 13:11:57 -0500
From: Andres Salomon <dilinger@queued.net>
To: libertas-dev@lists.infradead.org
Cc: linux-wireless@vger.kernel.org,
	Marcelo Tosatti <marcelo@kvack.org>,
	David Woodhouse <dwmw2@infradead.org>,
	akpm@linux-foundation.org
Subject: [PATCH 1/4] libertas: drop useless default_fw_name variable
Message-ID: <20071116131157.29c7227a@ephemeral> (sfid-20071116_183544_092853_F773CAFB)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

 Signed-off-by: Andres Salomon <dilinger@debian.org>

---
 drivers/net/wireless/libertas/if_usb.c |    7 +------
 1 files changed, 1 insertions(+), 6 deletions(-)

diff --git a/drivers/net/wireless/libertas/if_usb.c b/drivers/net/wireless/libertas/if_usb.c
index 063572f..3cf9379 100644
--- a/drivers/net/wireless/libertas/if_usb.c
+++ b/drivers/net/wireless/libertas/if_usb.c
@@ -20,9 +20,8 @@
 #define MESSAGE_HEADER_LEN	4
 
 static const char usbdriver_name[] = "usb8xxx";
-static u8 *default_fw_name = "usb8388.bin";
 
-static char *libertas_fw_name = NULL;
+static char *libertas_fw_name = "usb8388.bin";
 module_param_named(fw_name, libertas_fw_name, charp, 0644);
 
 /*
@@ -1129,10 +1128,6 @@ static int if_usb_init_module(void)
 
 	lbs_deb_enter(LBS_DEB_MAIN);
 
-	if (libertas_fw_name == NULL) {
-		libertas_fw_name = default_fw_name;
-	}
-
 	ret = usb_register(&if_usb_driver);
 
 	lbs_deb_leave_args(LBS_DEB_MAIN, "ret %d", ret);
-- 
1.5.3.4

