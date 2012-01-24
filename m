Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from charlotte.tuxdriver.com ([70.61.120.58]:50474 "EHLO
	smtp.tuxdriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756163Ab2AXUQP (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 24 Jan 2012 15:16:15 -0500
From: "John W. Linville" <linville@tuxdriver.com>
To: linux-wireless@vger.kernel.org
Cc: "John W. Linville" <linville@tuxdriver.com>
Subject: [PATCH] orinoco_usb: remove version definition
Date: Tue, 24 Jan 2012 15:04:14 -0500
Message-Id: <1327435454-27495-1-git-send-email-linville@tuxdriver.com> (sfid-20120124_211619_547734_E7122D5A)
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Avoids this:

  CC [M]  drivers/net/wireless/orinoco/orinoco_usb.o
drivers/net/wireless/orinoco/orinoco_usb.c:1759:13: warning: ‘version’ defined but not used

Signed-off-by: John W. Linville <linville@tuxdriver.com>
---
 drivers/net/wireless/orinoco/orinoco_usb.c |    5 -----
 1 files changed, 0 insertions(+), 5 deletions(-)

diff --git a/drivers/net/wireless/orinoco/orinoco_usb.c b/drivers/net/wireless/orinoco/orinoco_usb.c
index ae8ce56..f634d45 100644
--- a/drivers/net/wireless/orinoco/orinoco_usb.c
+++ b/drivers/net/wireless/orinoco/orinoco_usb.c
@@ -1754,11 +1754,6 @@ static struct usb_driver orinoco_driver = {
 	.id_table = ezusb_table,
 };
 
-/* Can't be declared "const" or the whole __initdata section will
- * become const */
-static char version[] __initdata = DRIVER_NAME " " DRIVER_VERSION
-	" (Manuel Estrada Sainz)";
-
 module_usb_driver(orinoco_driver);
 
 MODULE_AUTHOR("Manuel Estrada Sainz");
-- 
1.7.4.4

