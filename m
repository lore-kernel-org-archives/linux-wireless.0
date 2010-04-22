Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ww0-f46.google.com ([74.125.82.46]:37274 "EHLO
	mail-ww0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754772Ab0DVNy3 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 22 Apr 2010 09:54:29 -0400
Received: by wwb24 with SMTP id 24so4819406wwb.19
        for <linux-wireless@vger.kernel.org>; Thu, 22 Apr 2010 06:54:27 -0700 (PDT)
From: Grazvydas Ignotas <notasas@gmail.com>
To: "Luis R. Rodriguez" <mcgrof@gmail.com>
Cc: linux-wireless@vger.kernel.org,
	Grazvydas Ignotas <notasas@gmail.com>
Subject: [PATCH] compat: fix uevent_suppress on 2.6.29 or older kernels
Date: Thu, 22 Apr 2010 16:54:02 +0300
Message-Id: <1271944442-9214-1-git-send-email-notasas@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Missing uevent_suppress is causing two uevents instead of one, which is
confusing udev and sometimes causing firmware load to fail due to race
condition, so let's add it.

Signed-off-by: Grazvydas Ignotas <notasas@gmail.com>
---
 compat/compat_firmware_class.c |    6 +++++-
 1 files changed, 5 insertions(+), 1 deletions(-)

diff --git a/compat/compat_firmware_class.c b/compat/compat_firmware_class.c
index ce937a3..54ee8b9 100644
--- a/compat/compat_firmware_class.c
+++ b/compat/compat_firmware_class.c
@@ -432,6 +432,8 @@ static int fw_register_device(struct device **dev_p, const char *fw_name,
 	dev_set_drvdata(f_dev, fw_priv);
 #if (LINUX_VERSION_CODE >= KERNEL_VERSION(2,6,30))
 	dev_set_uevent_suppress(f_dev, 1);
+#else
+	f_dev->uevent_suppress = 1;
 #endif
 	retval = device_register(f_dev);
 	if (retval) {
@@ -479,9 +481,11 @@ static int fw_setup_device(struct firmware *fw, struct device **dev_p,
 		goto error_unreg;
 	}
 
-#if (LINUX_VERSION_CODE >= KERNEL_VERSION(2,6,30))
 	if (uevent)
+#if (LINUX_VERSION_CODE >= KERNEL_VERSION(2,6,30))
 		dev_set_uevent_suppress(f_dev, 0);
+#else
+		f_dev->uevent_suppress = 0;
 #endif
 	*dev_p = f_dev;
 	goto out;
-- 
1.7.0.2

