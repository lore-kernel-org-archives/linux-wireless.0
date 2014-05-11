Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mout.gmx.net ([212.227.17.21]:62255 "EHLO mout.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757929AbaEKIF2 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Sun, 11 May 2014 04:05:28 -0400
From: Oleksij Rempel <linux@rempel-privat.de>
To: ath9k-devel@venema.h4ckr.net, linville@tuxdriver.com,
	linux-wireless@vger.kernel.org
Cc: Oleksij Rempel <linux@rempel-privat.de>
Subject: [PATCH 01/10] ath9k-common: create common-debug and move modal_eeprom to cmn
Date: Sun, 11 May 2014 10:04:31 +0200
Message-Id: <1399795480-7459-2-git-send-email-linux@rempel-privat.de> (sfid-20140511_100540_471978_944AB680)
In-Reply-To: <1399795480-7459-1-git-send-email-linux@rempel-privat.de>
References: <1399795480-7459-1-git-send-email-linux@rempel-privat.de>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Signed-off-by: Oleksij Rempel <linux@rempel-privat.de>
---
 drivers/net/wireless/ath/ath9k/Makefile       |  3 +-
 drivers/net/wireless/ath/ath9k/common-debug.c | 53 +++++++++++++++++++++++++++
 drivers/net/wireless/ath/ath9k/common-debug.h | 18 +++++++++
 drivers/net/wireless/ath/ath9k/common.h       |  1 +
 drivers/net/wireless/ath/ath9k/debug.c        | 33 ++---------------
 5 files changed, 77 insertions(+), 31 deletions(-)
 create mode 100644 drivers/net/wireless/ath/ath9k/common-debug.c
 create mode 100644 drivers/net/wireless/ath/ath9k/common-debug.h

diff --git a/drivers/net/wireless/ath/ath9k/Makefile b/drivers/net/wireless/ath/ath9k/Makefile
index 8e1c7b0..8fcd586 100644
--- a/drivers/net/wireless/ath/ath9k/Makefile
+++ b/drivers/net/wireless/ath/ath9k/Makefile
@@ -53,7 +53,8 @@ obj-$(CONFIG_ATH9K_HW) += ath9k_hw.o
 obj-$(CONFIG_ATH9K_COMMON) += ath9k_common.o
 ath9k_common-y:=	common.o \
 			common-init.o \
-			common-beacon.o
+			common-beacon.o \
+			common-debug.o
 
 ath9k_htc-y +=	htc_hst.o \
 		hif_usb.o \
diff --git a/drivers/net/wireless/ath/ath9k/common-debug.c b/drivers/net/wireless/ath/ath9k/common-debug.c
new file mode 100644
index 0000000..da5efdb
--- /dev/null
+++ b/drivers/net/wireless/ath/ath9k/common-debug.c
@@ -0,0 +1,53 @@
+/*
+ * Copyright (c) 2008-2011 Atheros Communications Inc.
+ *
+ * Permission to use, copy, modify, and/or distribute this software for any
+ * purpose with or without fee is hereby granted, provided that the above
+ * copyright notice and this permission notice appear in all copies.
+ *
+ * THE SOFTWARE IS PROVIDED "AS IS" AND THE AUTHOR DISCLAIMS ALL WARRANTIES
+ * WITH REGARD TO THIS SOFTWARE INCLUDING ALL IMPLIED WARRANTIES OF
+ * MERCHANTABILITY AND FITNESS. IN NO EVENT SHALL THE AUTHOR BE LIABLE FOR
+ * ANY SPECIAL, DIRECT, INDIRECT, OR CONSEQUENTIAL DAMAGES OR ANY DAMAGES
+ * WHATSOEVER RESULTING FROM LOSS OF USE, DATA OR PROFITS, WHETHER IN AN
+ * ACTION OF CONTRACT, NEGLIGENCE OR OTHER TORTIOUS ACTION, ARISING OUT OF
+ * OR IN CONNECTION WITH THE USE OR PERFORMANCE OF THIS SOFTWARE.
+ */
+
+#include "common.h"
+
+static ssize_t read_file_modal_eeprom(struct file *file, char __user *user_buf,
+				      size_t count, loff_t *ppos)
+{
+	struct ath_hw *ah = file->private_data;
+	u32 len = 0, size = 6000;
+	char *buf;
+	size_t retval;
+
+	buf = kzalloc(size, GFP_KERNEL);
+	if (buf == NULL)
+		return -ENOMEM;
+
+	len = ah->eep_ops->dump_eeprom(ah, false, buf, len, size);
+
+	retval = simple_read_from_buffer(user_buf, count, ppos, buf, len);
+	kfree(buf);
+
+	return retval;
+}
+
+static const struct file_operations fops_modal_eeprom = {
+	.read = read_file_modal_eeprom,
+	.open = simple_open,
+	.owner = THIS_MODULE,
+	.llseek = default_llseek,
+};
+
+
+void ath9k_cmn_debug_modal_eeprom(struct dentry *debugfs_phy,
+				  struct ath_hw *ah)
+{
+	debugfs_create_file("modal_eeprom", S_IRUSR, debugfs_phy, ah,
+			    &fops_modal_eeprom);
+}
+EXPORT_SYMBOL(ath9k_cmn_debug_modal_eeprom);
diff --git a/drivers/net/wireless/ath/ath9k/common-debug.h b/drivers/net/wireless/ath/ath9k/common-debug.h
new file mode 100644
index 0000000..062c007
--- /dev/null
+++ b/drivers/net/wireless/ath/ath9k/common-debug.h
@@ -0,0 +1,18 @@
+/*
+ * Copyright (c) 2008-2011 Atheros Communications Inc.
+ *
+ * Permission to use, copy, modify, and/or distribute this software for any
+ * purpose with or without fee is hereby granted, provided that the above
+ * copyright notice and this permission notice appear in all copies.
+ *
+ * THE SOFTWARE IS PROVIDED "AS IS" AND THE AUTHOR DISCLAIMS ALL WARRANTIES
+ * WITH REGARD TO THIS SOFTWARE INCLUDING ALL IMPLIED WARRANTIES OF
+ * MERCHANTABILITY AND FITNESS. IN NO EVENT SHALL THE AUTHOR BE LIABLE FOR
+ * ANY SPECIAL, DIRECT, INDIRECT, OR CONSEQUENTIAL DAMAGES OR ANY DAMAGES
+ * WHATSOEVER RESULTING FROM LOSS OF USE, DATA OR PROFITS, WHETHER IN AN
+ * ACTION OF CONTRACT, NEGLIGENCE OR OTHER TORTIOUS ACTION, ARISING OUT OF
+ * OR IN CONNECTION WITH THE USE OR PERFORMANCE OF THIS SOFTWARE.
+ */
+
+void ath9k_cmn_debug_modal_eeprom(struct dentry *debugfs_phy,
+				  struct ath_hw *ah);
diff --git a/drivers/net/wireless/ath/ath9k/common.h b/drivers/net/wireless/ath/ath9k/common.h
index ca38116..ffc454b 100644
--- a/drivers/net/wireless/ath/ath9k/common.h
+++ b/drivers/net/wireless/ath/ath9k/common.h
@@ -23,6 +23,7 @@
 
 #include "common-init.h"
 #include "common-beacon.h"
+#include "common-debug.h"
 
 /* Common header for Atheros 802.11n base driver cores */
 
diff --git a/drivers/net/wireless/ath/ath9k/debug.c b/drivers/net/wireless/ath/ath9k/debug.c
index 780ff1b..1825a49 100644
--- a/drivers/net/wireless/ath/ath9k/debug.c
+++ b/drivers/net/wireless/ath/ath9k/debug.c
@@ -1296,34 +1296,6 @@ static const struct file_operations fops_base_eeprom = {
 	.llseek = default_llseek,
 };
 
-static ssize_t read_file_modal_eeprom(struct file *file, char __user *user_buf,
-				      size_t count, loff_t *ppos)
-{
-	struct ath_softc *sc = file->private_data;
-	struct ath_hw *ah = sc->sc_ah;
-	u32 len = 0, size = 6000;
-	char *buf;
-	size_t retval;
-
-	buf = kzalloc(size, GFP_KERNEL);
-	if (buf == NULL)
-		return -ENOMEM;
-
-	len = ah->eep_ops->dump_eeprom(ah, false, buf, len, size);
-
-	retval = simple_read_from_buffer(user_buf, count, ppos, buf, len);
-	kfree(buf);
-
-	return retval;
-}
-
-static const struct file_operations fops_modal_eeprom = {
-	.read = read_file_modal_eeprom,
-	.open = simple_open,
-	.owner = THIS_MODULE,
-	.llseek = default_llseek,
-};
-
 #ifdef CONFIG_ATH9K_BTCOEX_SUPPORT
 static ssize_t read_file_btcoex(struct file *file, char __user *user_buf,
 				size_t count, loff_t *ppos)
@@ -1549,8 +1521,9 @@ int ath9k_init_debug(struct ath_hw *ah)
 			    &fops_dump_nfcal);
 	debugfs_create_file("base_eeprom", S_IRUSR, sc->debug.debugfs_phy, sc,
 			    &fops_base_eeprom);
-	debugfs_create_file("modal_eeprom", S_IRUSR, sc->debug.debugfs_phy, sc,
-			    &fops_modal_eeprom);
+
+	ath9k_cmn_debug_modal_eeprom(sc->debug.debugfs_phy, sc->sc_ah);
+
 	debugfs_create_u32("gpio_mask", S_IRUSR | S_IWUSR,
 			   sc->debug.debugfs_phy, &sc->sc_ah->gpio_mask);
 	debugfs_create_u32("gpio_val", S_IRUSR | S_IWUSR,
-- 
1.9.1

