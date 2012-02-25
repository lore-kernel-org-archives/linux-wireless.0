Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pz0-f46.google.com ([209.85.210.46]:34915 "EHLO
	mail-pz0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932150Ab2BYETs (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 24 Feb 2012 23:19:48 -0500
Received: by mail-pz0-f46.google.com with SMTP id d14so3190091dae.19
        for <linux-wireless@vger.kernel.org>; Fri, 24 Feb 2012 20:19:47 -0800 (PST)
From: "Luis R. Rodriguez" <rodrigue@qca.qualcomm.com>
To: linux-wireless@vger.kernel.org
Cc: hauke@hauke-m.de, nbd@nbd.name, linville@tuxdriver.com,
	"Luis R. Rodriguez" <mcgrof@frijolero.org>
Subject: [PATCH 4/4] compat: fix compat_firmware class for all kernels
Date: Fri, 24 Feb 2012 20:19:29 -0800
Message-Id: <1330143569-30296-5-git-send-email-rodrigue@qca.qualcomm.com> (sfid-20120225_051951_353364_ADB8A7F9)
In-Reply-To: <1330143569-30296-1-git-send-email-rodrigue@qca.qualcomm.com>
References: <1330143569-30296-1-git-send-email-rodrigue@qca.qualcomm.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Luis R. Rodriguez <mcgrof@frijolero.org>

Instead of ifdef checks on the to_dev() just simply rename it
to avoid clashes. This fixes compiling against all supported
kernels on compat.

mcgrof@tux ~/compat (git::master)$ ckmake
Trying kernel                  3.3.0-030300rc2-generic  [OK]
Trying kernel                     3.2.2-030202-generic  [OK]
Trying kernel                    3.1.10-030110-generic  [OK]
Trying kernel                    3.0.18-030018-generic  [OK]
Trying kernel                  2.6.39-02063904-generic  [OK]
Trying kernel                         2.6.38-8-generic  [OK]
Trying kernel                        2.6.38-13-generic  [OK]
Trying kernel                        2.6.38-12-generic  [OK]
Trying kernel                        2.6.38-11-generic  [OK]
Trying kernel                        2.6.38-10-generic  [OK]
Trying kernel                  2.6.38-02063808-generic  [OK]
Trying kernel                  2.6.37-02063706-generic  [OK]
Trying kernel                  2.6.36-02063604-generic  [OK]
Trying kernel                  2.6.35-02063512-generic  [OK]
Trying kernel                  2.6.34-02063410-generic  [OK]
Trying kernel                  2.6.33-02063305-generic  [OK]
Trying kernel                  2.6.32-02063255-generic  [OK]
Trying kernel                        2.6.31-22-generic  [OK]
Trying kernel                  2.6.31-02063113-generic  [OK]
Trying kernel                  2.6.30-02063010-generic  [OK]
Trying kernel                  2.6.29-02062906-generic  [OK]
Trying kernel                  2.6.28-02062810-generic  [OK]
Trying kernel                    2.6.27-020627-generic  [OK]
Trying kernel                    2.6.26-020626-generic  [OK]
Trying kernel                    2.6.25-020625-generic  [OK]
Trying kernel                    2.6.24-020624-generic  [OK]

Signed-off-by: Luis R. Rodriguez <mcgrof@frijolero.org>
---
 compat/compat_firmware_class.c |    9 +++------
 1 files changed, 3 insertions(+), 6 deletions(-)

diff --git a/compat/compat_firmware_class.c b/compat/compat_firmware_class.c
index b085677..eb97dfc 100644
--- a/compat/compat_firmware_class.c
+++ b/compat/compat_firmware_class.c
@@ -21,10 +21,7 @@
 #include <linux/firmware.h>
 #include <linux/slab.h>
 
-#ifdef to_dev
-#undef to_dev
-#define to_dev(obj) container_of(obj, struct device, kobj)
-#endif
+#define compat_firmware_to_dev(obj) container_of(obj, struct device, kobj)
 
 MODULE_AUTHOR("Manuel Estrada Sainz");
 MODULE_DESCRIPTION("Multi purpose firmware loading support");
@@ -327,7 +324,7 @@ static ssize_t firmware_data_read(struct kobject *kobj,
 				  char *buffer, loff_t offset, size_t count)
 #endif
 {
-	struct device *dev = to_dev(kobj);
+	struct device *dev = compat_firmware_to_dev(kobj);
 	struct firmware_priv *fw_priv = to_firmware_priv(dev);
 	struct firmware *fw;
 	ssize_t ret_count;
@@ -426,7 +423,7 @@ static ssize_t firmware_data_write(struct kobject *kobj,
 				   char *buffer, loff_t offset, size_t count)
 #endif
 {
-	struct device *dev = to_dev(kobj);
+	struct device *dev = compat_firmware_to_dev(kobj);
 	struct firmware_priv *fw_priv = to_firmware_priv(dev);
 	struct firmware *fw;
 	ssize_t retval;
-- 
1.7.4.15.g7811d

