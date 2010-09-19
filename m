Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from server19320154104.serverpool.info ([193.201.54.104]:59600 "EHLO
	hauke-m.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754773Ab0ISRmd (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Sun, 19 Sep 2010 13:42:33 -0400
From: Hauke Mehrtens <hauke@hauke-m.de>
To: lrodriguez@atheros.com
Cc: linux-wireless@vger.kernel.org, mcgrof@infradead.org,
	Hauke Mehrtens <hauke@hauke-m.de>,
	Kshitij Kulshreshtha <kkhere.geo@gmail.com>
Subject: [PATCH 3/4] compat: move pmcia backport code into compat-2.6.36.h
Date: Sun, 19 Sep 2010 19:42:10 +0200
Message-Id: <1284918131-32065-3-git-send-email-hauke@hauke-m.de>
In-Reply-To: <1284918131-32065-1-git-send-email-hauke@hauke-m.de>
References: <1284918131-32065-1-git-send-email-hauke@hauke-m.de>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

We have all out backport headers in include/linux/compat-2.6.XX.h also the pcmcia
part there.

CC: Kshitij Kulshreshtha <kkhere.geo@gmail.com>
Signed-off-by: Hauke Mehrtens <hauke@hauke-m.de>
---
 include/linux/compat-2.6.36.h |   29 +++++++++++++++++++++++++++++
 include/pcmcia/ds.h           |   36 ------------------------------------
 2 files changed, 29 insertions(+), 36 deletions(-)
 delete mode 100644 include/pcmcia/ds.h

diff --git a/include/linux/compat-2.6.36.h b/include/linux/compat-2.6.36.h
index 2df34d6..1d929d7 100644
--- a/include/linux/compat-2.6.36.h
+++ b/include/linux/compat-2.6.36.h
@@ -6,6 +6,8 @@
 #if (LINUX_VERSION_CODE < KERNEL_VERSION(2,6,36))
 
 #include <linux/usb.h>
+#include <pcmcia/cistpl.h>
+#include <pcmcia/ds.h>
 
 #define kparam_block_sysfs_write(a)
 #define kparam_unblock_sysfs_write(a)
@@ -27,6 +29,33 @@ extern struct urb *compat_usb_get_from_anchor(struct usb_anchor *anchor);
 extern void compat_usb_scuttle_anchored_urbs(struct usb_anchor *anchor);
 #endif
 
+/**
+ * pcmcia_read_config_byte() - read a byte from a card configuration register
+ *
+ * pcmcia_read_config_byte() reads a byte from a configuration register in
+ * attribute memory.
+ */
+static inline int pcmcia_read_config_byte(struct pcmcia_device *p_dev, off_t where, u8 *val)
+{
+        int ret;
+        conf_reg_t reg = { 0, CS_READ, where, 0 };
+        ret = pcmcia_access_configuration_register(p_dev, &reg);
+        *val = reg.Value;
+        return ret;
+}
+
+/**
+ * pcmcia_write_config_byte() - write a byte to a card configuration register
+ *
+ * pcmcia_write_config_byte() writes a byte to a configuration register in
+ * attribute memory.
+ */
+static inline int pcmcia_write_config_byte(struct pcmcia_device *p_dev, off_t where, u8 val)
+{
+	conf_reg_t reg = { 0, CS_WRITE, where, val };
+	return pcmcia_access_configuration_register(p_dev, &reg);
+}
+
 #endif /* (LINUX_VERSION_CODE < KERNEL_VERSION(2,6,36)) */
 
 #endif /* LINUX_26_36_COMPAT_H */
diff --git a/include/pcmcia/ds.h b/include/pcmcia/ds.h
deleted file mode 100644
index fc43703..0000000
--- a/include/pcmcia/ds.h
+++ /dev/null
@@ -1,36 +0,0 @@
-#ifndef _COMPAT_PCMCIA_DS_H
-#define _COMPAT_PCMCIA_DS_H
-#include <linux/version.h>
-
-#include_next <pcmcia/ds.h>
-
-#if LINUX_VERSION_CODE < KERNEL_VERSION(2,6,36)
-/**
- * pcmcia_read_config_byte() - read a byte from a card configuration register
- *
- * pcmcia_read_config_byte() reads a byte from a configuration register in
- * attribute memory.
- */
-static inline int pcmcia_read_config_byte(struct pcmcia_device *p_dev, off_t where, u8 *val)
-{
-        int ret;
-        conf_reg_t reg = { 0, CS_READ, where, 0 };
-        ret = pcmcia_access_configuration_register(p_dev, &reg);
-        *val = reg.Value;
-        return ret;
-}
-
-/**
- * pcmcia_write_config_byte() - write a byte to a card configuration register
- *
- * pcmcia_write_config_byte() writes a byte to a configuration register in
- * attribute memory.
- */
-static inline int pcmcia_write_config_byte(struct pcmcia_device *p_dev, off_t where, u8 val)
-{
-	conf_reg_t reg = { 0, CS_WRITE, where, val };
-	return pcmcia_access_configuration_register(p_dev, &reg);
-}
-#endif /* LINUX_VERSION_CODE < KERNEL_VERSION(2,6,36) */
-
-#endif
-- 
1.7.0.4

