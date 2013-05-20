Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mout.gmx.net ([212.227.17.20]:56179 "EHLO mout.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755733Ab3ETTrd (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 20 May 2013 15:47:33 -0400
Received: from mailout-de.gmx.net ([10.1.76.1]) by mrigmx.server.lan
 (mrigmx002) with ESMTP (Nemesis) id 0LdKAB-1UEUi24Bu5-00iXBn for
 <linux-wireless@vger.kernel.org>; Mon, 20 May 2013 21:47:32 +0200
From: Peter Huewe <peterhuewe@gmx.de>
To: Luciano Coelho <coelho@ti.com>
Cc: "John W. Linville" <linville@tuxdriver.com>,
	Felipe Balbi <balbi@ti.com>, Ido Yariv <ido@wizery.com>,
	Arik Nemtsov <arik@wizery.com>, linux-wireless@vger.kernel.org,
	netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
	Peter Huewe <peterhuewe@gmx.de>
Subject: [PATCH] net/wireless/ti/wlcore/spi: Use module_spi_driver to register driver
Date: Mon, 20 May 2013 21:52:40 +0200
Message-Id: <1369079560-6101-1-git-send-email-peterhuewe@gmx.de> (sfid-20130520_214752_366112_3B56ADF1)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Removing some boilerplate by using module_spi_driver instead of calling
register and unregister in the otherwise empty init/exit functions

Signed-off-by: Peter Huewe <peterhuewe@gmx.de>
---
 drivers/net/wireless/ti/wlcore/spi.c | 14 +-------------
 1 file changed, 1 insertion(+), 13 deletions(-)

diff --git a/drivers/net/wireless/ti/wlcore/spi.c b/drivers/net/wireless/ti/wlcore/spi.c
index e264478..1b0cd98 100644
--- a/drivers/net/wireless/ti/wlcore/spi.c
+++ b/drivers/net/wireless/ti/wlcore/spi.c
@@ -434,19 +434,7 @@ static struct spi_driver wl1271_spi_driver = {
 	.remove		= wl1271_remove,
 };
 
-static int __init wl1271_init(void)
-{
-	return spi_register_driver(&wl1271_spi_driver);
-}
-
-static void __exit wl1271_exit(void)
-{
-	spi_unregister_driver(&wl1271_spi_driver);
-}
-
-module_init(wl1271_init);
-module_exit(wl1271_exit);
-
+module_spi_driver(wl1271_spi_driver);
 MODULE_LICENSE("GPL");
 MODULE_AUTHOR("Luciano Coelho <coelho@ti.com>");
 MODULE_AUTHOR("Juuso Oikarinen <juuso.oikarinen@nokia.com>");
-- 
1.8.1.5

