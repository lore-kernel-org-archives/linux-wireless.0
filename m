Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wg0-f43.google.com ([74.125.82.43]:35209 "EHLO
	mail-wg0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754273AbbFPWnc (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 16 Jun 2015 18:43:32 -0400
Received: by wgbhy7 with SMTP id hy7so23046415wgb.2
        for <linux-wireless@vger.kernel.org>; Tue, 16 Jun 2015 15:43:31 -0700 (PDT)
From: Malcolm Priestley <tvboxspy@gmail.com>
To: gregkh@linuxfoundation.org
Cc: linux-wireless@vger.kernel.org,
	Malcolm Priestley <tvboxspy@gmail.com>
Subject: [PATCH 1/2] staging: vt6655: remove suspend struct notifier_block.
Date: Tue, 16 Jun 2015 23:43:11 +0100
Message-Id: <1434494592-2639-1-git-send-email-tvboxspy@gmail.com> (sfid-20150617_004336_180444_F2190F30)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

The only thing this does is vt6655_suspend which is already been called
upon suspend.

Remove function device_notify_reboot and structure device_notifier.

Signed-off-by: Malcolm Priestley <tvboxspy@gmail.com>
---
 drivers/staging/vt6655/device_main.c | 37 ------------------------------------
 1 file changed, 37 deletions(-)

diff --git a/drivers/staging/vt6655/device_main.c b/drivers/staging/vt6655/device_main.c
index 8dbde24..c393b73 100644
--- a/drivers/staging/vt6655/device_main.c
+++ b/drivers/staging/vt6655/device_main.c
@@ -148,15 +148,6 @@ static void device_free_info(struct vnt_private *pDevice);
 static bool device_get_pci_info(struct vnt_private *, struct pci_dev *pcid);
 static void device_print_info(struct vnt_private *pDevice);
 
-#ifdef CONFIG_PM
-static int device_notify_reboot(struct notifier_block *, unsigned long event, void *ptr);
-static struct notifier_block device_notifier = {
-	.notifier_call = device_notify_reboot,
-	.next = NULL,
-	.priority = 0,
-};
-#endif
-
 static void device_init_rd0_ring(struct vnt_private *pDevice);
 static void device_init_rd1_ring(struct vnt_private *pDevice);
 static void device_init_td0_ring(struct vnt_private *pDevice);
@@ -1892,42 +1883,14 @@ static int __init vt6655_init_module(void)
 	int ret;
 
 	ret = pci_register_driver(&device_driver);
-#ifdef CONFIG_PM
-	if (ret >= 0)
-		register_reboot_notifier(&device_notifier);
-#endif
 
 	return ret;
 }
 
 static void __exit vt6655_cleanup_module(void)
 {
-#ifdef CONFIG_PM
-	unregister_reboot_notifier(&device_notifier);
-#endif
 	pci_unregister_driver(&device_driver);
 }
 
 module_init(vt6655_init_module);
 module_exit(vt6655_cleanup_module);
-
-#ifdef CONFIG_PM
-static int
-device_notify_reboot(struct notifier_block *nb, unsigned long event, void *p)
-{
-	struct pci_dev *pdev = NULL;
-
-	switch (event) {
-	case SYS_DOWN:
-	case SYS_HALT:
-	case SYS_POWER_OFF:
-		for_each_pci_dev(pdev) {
-			if (pci_dev_driver(pdev) == &device_driver) {
-				if (pci_get_drvdata(pdev))
-					vt6655_suspend(pdev, PMSG_HIBERNATE);
-			}
-		}
-	}
-	return NOTIFY_DONE;
-}
-#endif
-- 
2.1.4

