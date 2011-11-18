Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:38486 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756571Ab1KRIV6 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 18 Nov 2011 03:21:58 -0500
Received: from int-mx10.intmail.prod.int.phx2.redhat.com (int-mx10.intmail.prod.int.phx2.redhat.com [10.5.11.23])
	by mx1.redhat.com (8.14.4/8.14.4) with ESMTP id pAI8Lwfp026176
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=OK)
	for <linux-wireless@vger.kernel.org>; Fri, 18 Nov 2011 03:21:58 -0500
From: Stanislaw Gruszka <sgruszka@redhat.com>
To: linux-wireless@vger.kernel.org
Cc: Stanislaw Gruszka <sgruszka@redhat.com>
Subject: [PATCH 30/77] iwlegacy: merge iwl-3945-led.c into 3945.c
Date: Fri, 18 Nov 2011 09:21:52 +0100
Message-Id: <1321604559-10707-30-git-send-email-sgruszka@redhat.com> (sfid-20111118_092201_881503_6D5D3A3E)
In-Reply-To: <1321604559-10707-1-git-send-email-sgruszka@redhat.com>
References: <1321604559-10707-1-git-send-email-sgruszka@redhat.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Signed-off-by: Stanislaw Gruszka <sgruszka@redhat.com>
---
 drivers/net/wireless/iwlegacy/3945.c         |   20 ++++++++-
 drivers/net/wireless/iwlegacy/Makefile       |    2 +-
 drivers/net/wireless/iwlegacy/iwl-3945-led.c |   63 --------------------------
 drivers/net/wireless/iwlegacy/iwl-3945-led.h |   32 -------------
 4 files changed, 20 insertions(+), 97 deletions(-)
 delete mode 100644 drivers/net/wireless/iwlegacy/iwl-3945-led.c
 delete mode 100644 drivers/net/wireless/iwlegacy/iwl-3945-led.h

diff --git a/drivers/net/wireless/iwlegacy/3945.c b/drivers/net/wireless/iwlegacy/3945.c
index b6abf34..b41e60b 100644
--- a/drivers/net/wireless/iwlegacy/3945.c
+++ b/drivers/net/wireless/iwlegacy/3945.c
@@ -48,9 +48,27 @@
 #include "iwl-core.h"
 #include "iwl-helpers.h"
 #include "iwl-led.h"
-#include "iwl-3945-led.h"
 #include "iwl-3945-debugfs.h"
 
+/* Send led command */
+static int il3945_send_led_cmd(struct il_priv *il,
+				struct il_led_cmd *led_cmd)
+{
+	struct il_host_cmd cmd = {
+		.id = REPLY_LEDS_CMD,
+		.len = sizeof(struct il_led_cmd),
+		.data = led_cmd,
+		.flags = CMD_ASYNC,
+		.callback = NULL,
+	};
+
+	return il_send_cmd(il, &cmd);
+}
+
+const struct il_led_ops il3945_led_ops = {
+	.cmd = il3945_send_led_cmd,
+};
+
 #define IL_DECLARE_RATE_INFO(r, ip, in, rp, rn, pp, np)    \
 	[RATE_##r##M_IDX] = { RATE_##r##M_PLCP,   \
 				    RATE_##r##M_IEEE,   \
diff --git a/drivers/net/wireless/iwlegacy/Makefile b/drivers/net/wireless/iwlegacy/Makefile
index b909352..da83c69 100644
--- a/drivers/net/wireless/iwlegacy/Makefile
+++ b/drivers/net/wireless/iwlegacy/Makefile
@@ -16,7 +16,7 @@ iwl4965-$(CONFIG_IWLEGACY_DEBUGFS) += iwl-4965-debugfs.o
 
 # 3945
 obj-$(CONFIG_IWL3945)	+= iwl3945.o
-iwl3945-objs		:= 3945-mac.o 3945.o iwl-3945-rs.o iwl-3945-led.o
+iwl3945-objs		:= 3945-mac.o 3945.o iwl-3945-rs.o
 iwl3945-$(CONFIG_IWLEGACY_DEBUGFS) += iwl-3945-debugfs.o
 
 ccflags-y += -D__CHECK_ENDIAN__
diff --git a/drivers/net/wireless/iwlegacy/iwl-3945-led.c b/drivers/net/wireless/iwlegacy/iwl-3945-led.c
deleted file mode 100644
index 53ec463..0000000
--- a/drivers/net/wireless/iwlegacy/iwl-3945-led.c
+++ /dev/null
@@ -1,63 +0,0 @@
-/******************************************************************************
- *
- * Copyright(c) 2003 - 2011 Intel Corporation. All rights reserved.
- *
- * This program is free software; you can redistribute it and/or modify it
- * under the terms of version 2 of the GNU General Public License as
- * published by the Free Software Foundation.
- *
- * This program is distributed in the hope that it will be useful, but WITHOUT
- * ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or
- * FITNESS FOR A PARTICULAR PURPOSE.  See the GNU General Public License for
- * more details.
- *
- * You should have received a copy of the GNU General Public License along with
- * this program; if not, write to the Free Software Foundation, Inc.,
- * 51 Franklin Street, Fifth Floor, Boston, MA 02110, USA
- *
- * The full GNU General Public License is included in this distribution in the
- * file called LICENSE.
- *
- * Contact Information:
- *  Intel Linux Wireless <ilw@linux.intel.com>
- * Intel Corporation, 5200 N.E. Elam Young Parkway, Hillsboro, OR 97124-6497
- *
- *****************************************************************************/
-
-#include <linux/kernel.h>
-#include <linux/module.h>
-#include <linux/init.h>
-#include <linux/pci.h>
-#include <linux/dma-mapping.h>
-#include <linux/delay.h>
-#include <linux/skbuff.h>
-#include <linux/netdevice.h>
-#include <net/mac80211.h>
-#include <linux/etherdevice.h>
-#include <asm/unaligned.h>
-
-#include "iwl-commands.h"
-#include "iwl-3945.h"
-#include "iwl-core.h"
-#include "iwl-dev.h"
-#include "iwl-3945-led.h"
-
-
-/* Send led command */
-static int il3945_send_led_cmd(struct il_priv *il,
-				struct il_led_cmd *led_cmd)
-{
-	struct il_host_cmd cmd = {
-		.id = REPLY_LEDS_CMD,
-		.len = sizeof(struct il_led_cmd),
-		.data = led_cmd,
-		.flags = CMD_ASYNC,
-		.callback = NULL,
-	};
-
-	return il_send_cmd(il, &cmd);
-}
-
-const struct il_led_ops il3945_led_ops = {
-	.cmd = il3945_send_led_cmd,
-};
diff --git a/drivers/net/wireless/iwlegacy/iwl-3945-led.h b/drivers/net/wireless/iwlegacy/iwl-3945-led.h
deleted file mode 100644
index 369c72d..0000000
--- a/drivers/net/wireless/iwlegacy/iwl-3945-led.h
+++ /dev/null
@@ -1,32 +0,0 @@
-/******************************************************************************
- *
- * Copyright(c) 2003 - 2011 Intel Corporation. All rights reserved.
- *
- * This program is free software; you can redistribute it and/or modify it
- * under the terms of version 2 of the GNU General Public License as
- * published by the Free Software Foundation.
- *
- * This program is distributed in the hope that it will be useful, but WITHOUT
- * ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or
- * FITNESS FOR A PARTICULAR PURPOSE.  See the GNU General Public License for
- * more details.
- *
- * You should have received a copy of the GNU General Public License along with
- * this program; if not, write to the Free Software Foundation, Inc.,
- * 51 Franklin Street, Fifth Floor, Boston, MA 02110, USA
- *
- * The full GNU General Public License is included in this distribution in the
- * file called LICENSE.
- *
- * Contact Information:
- *  Intel Linux Wireless <ilw@linux.intel.com>
- * Intel Corporation, 5200 N.E. Elam Young Parkway, Hillsboro, OR 97124-6497
- *
- *****************************************************************************/
-
-#ifndef __il_3945_led_h__
-#define __il_3945_led_h__
-
-extern const struct il_led_ops il3945_led_ops;
-
-#endif /* __il_3945_led_h__ */
-- 
1.7.1

