Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from senator.holtmann.net ([87.106.208.187]:50921 "EHLO
	mail.holtmann.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758290Ab2JXSpg (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 24 Oct 2012 14:45:36 -0400
From: Marcel Holtmann <marcel@holtmann.org>
To: Samuel Ortiz <sameo@linux.intel.com>
Cc: linux-wireless@vger.kernel.org
Subject: [PATCH 2/3] NFC: Move pn544.h to linux/platform_data/
Date: Wed, 24 Oct 2012 11:45:26 -0700
Message-Id: <1351104326-5206-1-git-send-email-marcel@holtmann.org> (sfid-20121024_204539_365460_F21166E7)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

The pn544.h just provides the platform data struct and defines and
nothing else. So move it to to linux/platform_data/ now.

Signed-off-by: Marcel Holtmann <marcel@holtmann.org>
---
 drivers/nfc/pn544_hci.c             |  2 +-
 include/linux/nfc/pn544.h           | 44 -------------------------------------
 include/linux/platform_data/pn544.h | 44 +++++++++++++++++++++++++++++++++++++
 3 files changed, 45 insertions(+), 45 deletions(-)
 delete mode 100644 include/linux/nfc/pn544.h
 create mode 100644 include/linux/platform_data/pn544.h

diff --git a/drivers/nfc/pn544_hci.c b/drivers/nfc/pn544_hci.c
index c9c8570..ae5d5f7 100644
--- a/drivers/nfc/pn544_hci.c
+++ b/drivers/nfc/pn544_hci.c
@@ -31,7 +31,7 @@
 #include <net/nfc/hci.h>
 #include <net/nfc/llc.h>
 
-#include <linux/nfc/pn544.h>
+#include <linux/platform_data/pn544.h>
 
 #define DRIVER_DESC "HCI NFC driver for PN544"
 
diff --git a/include/linux/nfc/pn544.h b/include/linux/nfc/pn544.h
deleted file mode 100644
index 713bfd7..0000000
--- a/include/linux/nfc/pn544.h
+++ /dev/null
@@ -1,44 +0,0 @@
-/*
- * Driver include for the PN544 NFC chip.
- *
- * Copyright (C) Nokia Corporation
- *
- * Author: Jari Vanhala <ext-jari.vanhala@nokia.com>
- * Contact: Matti Aaltoenn <matti.j.aaltonen@nokia.com>
- *
- * This program is free software; you can redistribute it and/or
- * modify it under the terms of the GNU General Public License
- * version 2 as published by the Free Software Foundation.
- *
- * This program is distributed in the hope that it will be useful,
- * but WITHOUT ANY WARRANTY; without even the implied warranty of
- * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.	See the
- * GNU General Public License for more details.
- *
- * You should have received a copy of the GNU General Public License
- * along with this program; if not, write to the Free Software
- * Foundation, Inc., 59 Temple Place, Suite 330, Boston, MA 02111-1307 USA
- */
-
-#ifndef _PN544_H_
-#define _PN544_H_
-
-#include <linux/i2c.h>
-
-enum {
-	NFC_GPIO_ENABLE,
-	NFC_GPIO_FW_RESET,
-	NFC_GPIO_IRQ
-};
-
-/* board config */
-struct pn544_nfc_platform_data {
-	int (*request_resources) (struct i2c_client *client);
-	void (*free_resources) (void);
-	void (*enable) (int fw);
-	int (*test) (void);
-	void (*disable) (void);
-	int (*get_gpio)(int type);
-};
-
-#endif /* _PN544_H_ */
diff --git a/include/linux/platform_data/pn544.h b/include/linux/platform_data/pn544.h
new file mode 100644
index 0000000..713bfd7
--- /dev/null
+++ b/include/linux/platform_data/pn544.h
@@ -0,0 +1,44 @@
+/*
+ * Driver include for the PN544 NFC chip.
+ *
+ * Copyright (C) Nokia Corporation
+ *
+ * Author: Jari Vanhala <ext-jari.vanhala@nokia.com>
+ * Contact: Matti Aaltoenn <matti.j.aaltonen@nokia.com>
+ *
+ * This program is free software; you can redistribute it and/or
+ * modify it under the terms of the GNU General Public License
+ * version 2 as published by the Free Software Foundation.
+ *
+ * This program is distributed in the hope that it will be useful,
+ * but WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.	See the
+ * GNU General Public License for more details.
+ *
+ * You should have received a copy of the GNU General Public License
+ * along with this program; if not, write to the Free Software
+ * Foundation, Inc., 59 Temple Place, Suite 330, Boston, MA 02111-1307 USA
+ */
+
+#ifndef _PN544_H_
+#define _PN544_H_
+
+#include <linux/i2c.h>
+
+enum {
+	NFC_GPIO_ENABLE,
+	NFC_GPIO_FW_RESET,
+	NFC_GPIO_IRQ
+};
+
+/* board config */
+struct pn544_nfc_platform_data {
+	int (*request_resources) (struct i2c_client *client);
+	void (*free_resources) (void);
+	void (*enable) (int fw);
+	int (*test) (void);
+	void (*disable) (void);
+	int (*get_gpio)(int type);
+};
+
+#endif /* _PN544_H_ */
-- 
1.7.11.7

