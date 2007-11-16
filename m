Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.queued.net ([207.210.101.209]:1117 "EHLO mail.queued.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932433AbXKPSfQ (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 16 Nov 2007 13:35:16 -0500
Date: Fri, 16 Nov 2007 13:12:17 -0500
From: Andres Salomon <dilinger@queued.net>
To: libertas-dev@lists.infradead.org
Cc: linux-wireless@vger.kernel.org,
	Marcelo Tosatti <marcelo@kvack.org>,
	David Woodhouse <dwmw2@infradead.org>,
	akpm@linux-foundation.org
Subject: [PATCH 4/4] libertas: nuke useless variable usbdriver_name and
 useless comments
Message-ID: <20071116131217.4f9efe72@ephemeral> (sfid-20071116_183542_843047_7C5535E9)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


I think it was pretty obvious what fields in if_usb_driver are...

Signed-off-by: Andres Salomon <dilinger@debian.org>
---
 drivers/net/wireless/libertas/if_usb.c |    8 +-------
 1 files changed, 1 insertions(+), 7 deletions(-)

diff --git a/drivers/net/wireless/libertas/if_usb.c b/drivers/net/wireless/libertas/if_usb.c
index e9aad16..f7bafc3 100644
--- a/drivers/net/wireless/libertas/if_usb.c
+++ b/drivers/net/wireless/libertas/if_usb.c
@@ -18,8 +18,6 @@
 
 #define MESSAGE_HEADER_LEN	4
 
-static const char usbdriver_name[] = "usb8xxx";
-
 static char *libertas_fw_name = "usb8388.bin";
 module_param_named(fw_name, libertas_fw_name, charp, 0644);
 
@@ -1099,13 +1097,9 @@ static int if_usb_resume(struct usb_interface *intf)
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
-- 
1.5.3.4

