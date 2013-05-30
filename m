Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-bk0-f43.google.com ([209.85.214.43]:33335 "EHLO
	mail-bk0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932568Ab3E3Lmz (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 30 May 2013 07:42:55 -0400
Received: by mail-bk0-f43.google.com with SMTP id jm2so85153bkc.16
        for <linux-wireless@vger.kernel.org>; Thu, 30 May 2013 04:42:54 -0700 (PDT)
MIME-Version: 1.0
Date: Thu, 30 May 2013 19:42:54 +0800
Message-ID: <CAPgLHd9e+T7UVET28Xe3RP05s2jVJdLx4TRtw3V635+HnKjnZA@mail.gmail.com> (sfid-20130530_134323_516370_5B1F96EA)
Subject: [PATCH -next] cw1200: use module_spi_driver to simplify the code
From: Wei Yongjun <weiyj.lk@gmail.com>
To: pizza@shaftnet.org, linville@tuxdriver.com
Cc: yongjun_wei@trendmicro.com.cn, linux-wireless@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Wei Yongjun <yongjun_wei@trendmicro.com.cn>

module_spi_driver() makes the code simpler by eliminating
boilerplate code.

Signed-off-by: Wei Yongjun <yongjun_wei@trendmicro.com.cn>
---
 drivers/net/wireless/cw1200/cw1200_spi.c | 15 +--------------
 1 file changed, 1 insertion(+), 14 deletions(-)

diff --git a/drivers/net/wireless/cw1200/cw1200_spi.c b/drivers/net/wireless/cw1200/cw1200_spi.c
index 04af685..1e6c58d 100644
--- a/drivers/net/wireless/cw1200/cw1200_spi.c
+++ b/drivers/net/wireless/cw1200/cw1200_spi.c
@@ -464,17 +464,4 @@ static struct spi_driver spi_driver = {
 	},
 };
 
-/* Init Module function -> Called by insmod */
-static int __init cw1200_spi_init(void)
-{
-	return spi_register_driver(&spi_driver);
-}
-
-/* Called at Driver Unloading */
-static void __exit cw1200_spi_exit(void)
-{
-	spi_unregister_driver(&spi_driver);
-}
-
-module_init(cw1200_spi_init);
-module_exit(cw1200_spi_exit);
+module_spi_driver(spi_driver);

