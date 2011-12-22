Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from server19320154104.serverpool.info ([193.201.54.104]:55518 "EHLO
	hauke-m.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752951Ab1LVUrr (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 22 Dec 2011 15:47:47 -0500
From: Hauke Mehrtens <hauke@hauke-m.de>
To: mcgrof@gmail.com, mcgrof@qca.qualcomm.com
Cc: linux-wireless@vger.kernel.org, Hauke Mehrtens <hauke@hauke-m.de>
Subject: [PATCH 2/6] compat-wireless: remove platform_device_id for kernel < 2.6.30
Date: Thu, 22 Dec 2011 21:47:26 +0100
Message-Id: <1324586850-5212-3-git-send-email-hauke@hauke-m.de> (sfid-20111222_214752_110745_6C4A4FF5)
In-Reply-To: <1324586850-5212-1-git-send-email-hauke@hauke-m.de>
References: <1324586850-5212-1-git-send-email-hauke@hauke-m.de>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Kernel < 2.6.30 do not support struct platform_device_id, so remove it
for them and hope that the probing will reject an invalid device.

Signed-off-by: Hauke Mehrtens <hauke@hauke-m.de>
---
 patches/45-remove-platform-id-table.patch |   23 +++++++++++++++++++++++
 1 files changed, 23 insertions(+), 0 deletions(-)
 create mode 100644 patches/45-remove-platform-id-table.patch

diff --git a/patches/45-remove-platform-id-table.patch b/patches/45-remove-platform-id-table.patch
new file mode 100644
index 0000000..aa96ecb
--- /dev/null
+++ b/patches/45-remove-platform-id-table.patch
@@ -0,0 +1,23 @@
+--- a/drivers/net/wireless/wl12xx/main.c
++++ b/drivers/net/wireless/wl12xx/main.c
+@@ -5321,16 +5321,20 @@ static int __devexit wl12xx_remove(struc
+ 	return 0;
+ }
+ 
++#if LINUX_VERSION_CODE >= KERNEL_VERSION(2,6,30)
+ static const struct platform_device_id wl12xx_id_table[] __devinitconst = {
+ 	{ "wl12xx", 0 },
+ 	{  } /* Terminating Entry */
+ };
+ MODULE_DEVICE_TABLE(platform, wl12xx_id_table);
++#endif
+ 
+ static struct platform_driver wl12xx_driver = {
+ 	.probe		= wl12xx_probe,
+ 	.remove		= __devexit_p(wl12xx_remove),
++#if LINUX_VERSION_CODE >= KERNEL_VERSION(2,6,30)
+ 	.id_table	= wl12xx_id_table,
++#endif
+ 	.driver = {
+ 		.name	= "wl12xx_driver",
+ 		.owner	= THIS_MODULE,
-- 
1.7.5.4

