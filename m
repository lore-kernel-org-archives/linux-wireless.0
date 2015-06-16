Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wg0-f46.google.com ([74.125.82.46]:35225 "EHLO
	mail-wg0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754853AbbFPWnd (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 16 Jun 2015 18:43:33 -0400
Received: by wgbhy7 with SMTP id hy7so23046852wgb.2
        for <linux-wireless@vger.kernel.org>; Tue, 16 Jun 2015 15:43:32 -0700 (PDT)
From: Malcolm Priestley <tvboxspy@gmail.com>
To: gregkh@linuxfoundation.org
Cc: linux-wireless@vger.kernel.org,
	Malcolm Priestley <tvboxspy@gmail.com>
Subject: [PATCH 2/2] staging: vt6655: use module_pci_driver helper
Date: Tue, 16 Jun 2015 23:43:12 +0100
Message-Id: <1434494592-2639-2-git-send-email-tvboxspy@gmail.com> (sfid-20150617_004337_736816_49486809)
In-Reply-To: <1434494592-2639-1-git-send-email-tvboxspy@gmail.com>
References: <1434494592-2639-1-git-send-email-tvboxspy@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Remove  vt6655_init_module and vt6655_cleanup_module and replace
module_pci_driver

Signed-off-by: Malcolm Priestley <tvboxspy@gmail.com>
---
 drivers/staging/vt6655/device_main.c | 17 +----------------
 1 file changed, 1 insertion(+), 16 deletions(-)

diff --git a/drivers/staging/vt6655/device_main.c b/drivers/staging/vt6655/device_main.c
index c393b73..0bfc939 100644
--- a/drivers/staging/vt6655/device_main.c
+++ b/drivers/staging/vt6655/device_main.c
@@ -1878,19 +1878,4 @@ static struct pci_driver device_driver = {
 #endif
 };
 
-static int __init vt6655_init_module(void)
-{
-	int ret;
-
-	ret = pci_register_driver(&device_driver);
-
-	return ret;
-}
-
-static void __exit vt6655_cleanup_module(void)
-{
-	pci_unregister_driver(&device_driver);
-}
-
-module_init(vt6655_init_module);
-module_exit(vt6655_cleanup_module);
+module_pci_driver(device_driver);
-- 
2.1.4

