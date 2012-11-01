Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-qc0-f174.google.com ([209.85.216.174]:41872 "EHLO
	mail-qc0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751182Ab2KAB7O (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 31 Oct 2012 21:59:14 -0400
Received: by mail-qc0-f174.google.com with SMTP id o22so1421121qcr.19
        for <linux-wireless@vger.kernel.org>; Wed, 31 Oct 2012 18:59:13 -0700 (PDT)
MIME-Version: 1.0
Date: Thu, 1 Nov 2012 09:59:13 +0800
Message-ID: <CAPgLHd9H=Y7+VhgpPhFyk8dzVecH=8zCSPrw6He_QQDUyGEm9g@mail.gmail.com> (sfid-20121101_025928_968278_F69AF835)
Subject: [PATCH -next] ar5523: use module_usb_driver to simplify the code
From: Wei Yongjun <weiyj.lk@gmail.com>
To: pontus.fuchs@gmail.com, linville@tuxdriver.com
Cc: yongjun_wei@trendmicro.com.cn, linux-wireless@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Wei Yongjun <yongjun_wei@trendmicro.com.cn>

Use the module_usb_driver() macro to make the code simpler
by eliminating module_init and module_exit calls.

dpatch engine is used to auto generate this patch.
(https://github.com/weiyj/dpatch)

Signed-off-by: Wei Yongjun <yongjun_wei@trendmicro.com.cn>
---
 drivers/net/wireless/ath/ar5523/ar5523.c | 13 +------------
 1 file changed, 1 insertion(+), 12 deletions(-)

diff --git a/drivers/net/wireless/ath/ar5523/ar5523.c b/drivers/net/wireless/ath/ar5523/ar5523.c
index f782b6e..402e6d3 100644
--- a/drivers/net/wireless/ath/ar5523/ar5523.c
+++ b/drivers/net/wireless/ath/ar5523/ar5523.c
@@ -1789,18 +1789,7 @@ static struct usb_driver ar5523_driver = {
 	.disconnect	= ar5523_disconnect,
 };
 
-static int __init ar5523_init(void)
-{
-	return usb_register(&ar5523_driver);
-}
-
-static void __exit ar5523_exit(void)
-{
-	usb_deregister(&ar5523_driver);
-}
+module_usb_driver(ar5523_driver);
 
 MODULE_LICENSE("Dual BSD/GPL");
 MODULE_FIRMWARE(AR5523_FIRMWARE_FILE);
-
-module_init(ar5523_init);
-module_exit(ar5523_exit);


