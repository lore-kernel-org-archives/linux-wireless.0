Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:16211 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756571Ab1KRIWB (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 18 Nov 2011 03:22:01 -0500
Received: from int-mx02.intmail.prod.int.phx2.redhat.com (int-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.12])
	by mx1.redhat.com (8.14.4/8.14.4) with ESMTP id pAI8M1sn022674
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=OK)
	for <linux-wireless@vger.kernel.org>; Fri, 18 Nov 2011 03:22:01 -0500
From: Stanislaw Gruszka <sgruszka@redhat.com>
To: linux-wireless@vger.kernel.org
Cc: Stanislaw Gruszka <sgruszka@redhat.com>
Subject: [PATCH 32/77] iwlegacy: merge iwl-4965-ucode.c into 4965.c
Date: Fri, 18 Nov 2011 09:21:54 +0100
Message-Id: <1321604559-10707-32-git-send-email-sgruszka@redhat.com> (sfid-20111118_092207_099945_0701D288)
In-Reply-To: <1321604559-10707-1-git-send-email-sgruszka@redhat.com>
References: <1321604559-10707-1-git-send-email-sgruszka@redhat.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Signed-off-by: Stanislaw Gruszka <sgruszka@redhat.com>
---
 drivers/net/wireless/iwlegacy/4965.c           |  125 ++++++++++++++++++
 drivers/net/wireless/iwlegacy/Makefile         |    2 +-
 drivers/net/wireless/iwlegacy/iwl-4965-ucode.c |  166 ------------------------
 3 files changed, 126 insertions(+), 167 deletions(-)
 delete mode 100644 drivers/net/wireless/iwlegacy/iwl-4965-ucode.c

diff --git a/drivers/net/wireless/iwlegacy/4965.c b/drivers/net/wireless/iwlegacy/4965.c
index a4b42cc..752564d 100644
--- a/drivers/net/wireless/iwlegacy/4965.c
+++ b/drivers/net/wireless/iwlegacy/4965.c
@@ -47,6 +47,131 @@
 #include "iwl-4965.h"
 #include "iwl-4965-debugfs.h"
 
+#define IL_AC_UNSET -1
+
+/**
+ * il_verify_inst_sparse - verify runtime uCode image in card vs. host,
+ *   using sample data 100 bytes apart.  If these sample points are good,
+ *   it's a pretty good bet that everything between them is good, too.
+ */
+static int
+il4965_verify_inst_sparse(struct il_priv *il, __le32 *image, u32 len)
+{
+	u32 val;
+	int ret = 0;
+	u32 errcnt = 0;
+	u32 i;
+
+	D_INFO("ucode inst image size is %u\n", len);
+
+	for (i = 0; i < len; i += 100, image += 100/sizeof(u32)) {
+		/* read data comes through single port, auto-incr addr */
+		/* NOTE: Use the debugless read so we don't flood kernel log
+		 * if IL_DL_IO is set */
+		il_wr(il, HBUS_TARG_MEM_RADDR,
+			i + IL4965_RTC_INST_LOWER_BOUND);
+		val = _il_rd(il, HBUS_TARG_MEM_RDAT);
+		if (val != le32_to_cpu(*image)) {
+			ret = -EIO;
+			errcnt++;
+			if (errcnt >= 3)
+				break;
+		}
+	}
+
+	return ret;
+}
+
+/**
+ * il4965_verify_inst_full - verify runtime uCode image in card vs. host,
+ *     looking at all data.
+ */
+static int il4965_verify_inst_full(struct il_priv *il, __le32 *image,
+				 u32 len)
+{
+	u32 val;
+	u32 save_len = len;
+	int ret = 0;
+	u32 errcnt;
+
+	D_INFO("ucode inst image size is %u\n", len);
+
+	il_wr(il, HBUS_TARG_MEM_RADDR,
+			   IL4965_RTC_INST_LOWER_BOUND);
+
+	errcnt = 0;
+	for (; len > 0; len -= sizeof(u32), image++) {
+		/* read data comes through single port, auto-incr addr */
+		/* NOTE: Use the debugless read so we don't flood kernel log
+		 * if IL_DL_IO is set */
+		val = _il_rd(il, HBUS_TARG_MEM_RDAT);
+		if (val != le32_to_cpu(*image)) {
+			IL_ERR("uCode INST section is invalid at "
+				  "offset 0x%x, is 0x%x, s/b 0x%x\n",
+				  save_len - len, val, le32_to_cpu(*image));
+			ret = -EIO;
+			errcnt++;
+			if (errcnt >= 20)
+				break;
+		}
+	}
+
+	if (!errcnt)
+		D_INFO(
+		    "ucode image in INSTRUCTION memory is good\n");
+
+	return ret;
+}
+
+/**
+ * il4965_verify_ucode - determine which instruction image is in SRAM,
+ *    and verify its contents
+ */
+int il4965_verify_ucode(struct il_priv *il)
+{
+	__le32 *image;
+	u32 len;
+	int ret;
+
+	/* Try bootstrap */
+	image = (__le32 *)il->ucode_boot.v_addr;
+	len = il->ucode_boot.len;
+	ret = il4965_verify_inst_sparse(il, image, len);
+	if (!ret) {
+		D_INFO("Bootstrap uCode is good in inst SRAM\n");
+		return 0;
+	}
+
+	/* Try initialize */
+	image = (__le32 *)il->ucode_init.v_addr;
+	len = il->ucode_init.len;
+	ret = il4965_verify_inst_sparse(il, image, len);
+	if (!ret) {
+		D_INFO("Initialize uCode is good in inst SRAM\n");
+		return 0;
+	}
+
+	/* Try runtime/protocol */
+	image = (__le32 *)il->ucode_code.v_addr;
+	len = il->ucode_code.len;
+	ret = il4965_verify_inst_sparse(il, image, len);
+	if (!ret) {
+		D_INFO("Runtime uCode is good in inst SRAM\n");
+		return 0;
+	}
+
+	IL_ERR("NO VALID UCODE IMAGE IN INSTRUCTION SRAM!!\n");
+
+	/* Since nothing seems to match, show first several data entries in
+	 * instruction SRAM, so maybe visual inspection will give a clue.
+	 * Selection of bootstrap image (vs. other images) is arbitrary. */
+	image = (__le32 *)il->ucode_boot.v_addr;
+	len = il->ucode_boot.len;
+	ret = il4965_verify_inst_full(il, image, len);
+
+	return ret;
+}
+
 /******************************************************************************
  *
  * EEPROM related functions
diff --git a/drivers/net/wireless/iwlegacy/Makefile b/drivers/net/wireless/iwlegacy/Makefile
index 2776845..43daa07 100644
--- a/drivers/net/wireless/iwlegacy/Makefile
+++ b/drivers/net/wireless/iwlegacy/Makefile
@@ -9,7 +9,7 @@ iwl-legacy-objs += $(iwl-legacy-m)
 # 4965
 obj-$(CONFIG_IWL4965)	+= iwl4965.o
 iwl4965-objs		:= 4965.o 4965-mac.o iwl-4965-rs.o
-iwl4965-objs		+= iwl-4965-ucode.o iwl-4965-tx.o
+iwl4965-objs		+= iwl-4965-tx.o
 iwl4965-objs		+= iwl-4965-lib.o iwl-4965-rx.o iwl-4965-calib.o
 iwl4965-objs		+= iwl-4965-sta.o
 iwl4965-$(CONFIG_IWLEGACY_DEBUGFS) += iwl-4965-debugfs.o
diff --git a/drivers/net/wireless/iwlegacy/iwl-4965-ucode.c b/drivers/net/wireless/iwlegacy/iwl-4965-ucode.c
deleted file mode 100644
index 633caf5..0000000
--- a/drivers/net/wireless/iwlegacy/iwl-4965-ucode.c
+++ /dev/null
@@ -1,166 +0,0 @@
-/******************************************************************************
- *
- * GPL LICENSE SUMMARY
- *
- * Copyright(c) 2008 - 2011 Intel Corporation. All rights reserved.
- *
- * This program is free software; you can redistribute it and/or modify
- * it under the terms of version 2 of the GNU General Public License as
- * published by the Free Software Foundation.
- *
- * This program is distributed in the hope that it will be useful, but
- * WITHOUT ANY WARRANTY; without even the implied warranty of
- * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
- * General Public License for more details.
- *
- * You should have received a copy of the GNU General Public License
- * along with this program; if not, write to the Free Software
- * Foundation, Inc., 51 Franklin Street, Fifth Floor, Boston, MA 02110,
- * USA
- *
- * The full GNU General Public License is included in this distribution
- * in the file called LICENSE.GPL.
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
-#include <linux/sched.h>
-
-#include "iwl-dev.h"
-#include "iwl-core.h"
-#include "iwl-io.h"
-#include "iwl-helpers.h"
-#include "iwl-4965-hw.h"
-#include "iwl-4965.h"
-#include "iwl-4965-calib.h"
-
-#define IL_AC_UNSET -1
-
-/**
- * il_verify_inst_sparse - verify runtime uCode image in card vs. host,
- *   using sample data 100 bytes apart.  If these sample points are good,
- *   it's a pretty good bet that everything between them is good, too.
- */
-static int
-il4965_verify_inst_sparse(struct il_priv *il, __le32 *image, u32 len)
-{
-	u32 val;
-	int ret = 0;
-	u32 errcnt = 0;
-	u32 i;
-
-	D_INFO("ucode inst image size is %u\n", len);
-
-	for (i = 0; i < len; i += 100, image += 100/sizeof(u32)) {
-		/* read data comes through single port, auto-incr addr */
-		/* NOTE: Use the debugless read so we don't flood kernel log
-		 * if IL_DL_IO is set */
-		il_wr(il, HBUS_TARG_MEM_RADDR,
-			i + IL4965_RTC_INST_LOWER_BOUND);
-		val = _il_rd(il, HBUS_TARG_MEM_RDAT);
-		if (val != le32_to_cpu(*image)) {
-			ret = -EIO;
-			errcnt++;
-			if (errcnt >= 3)
-				break;
-		}
-	}
-
-	return ret;
-}
-
-/**
- * il4965_verify_inst_full - verify runtime uCode image in card vs. host,
- *     looking at all data.
- */
-static int il4965_verify_inst_full(struct il_priv *il, __le32 *image,
-				 u32 len)
-{
-	u32 val;
-	u32 save_len = len;
-	int ret = 0;
-	u32 errcnt;
-
-	D_INFO("ucode inst image size is %u\n", len);
-
-	il_wr(il, HBUS_TARG_MEM_RADDR,
-			   IL4965_RTC_INST_LOWER_BOUND);
-
-	errcnt = 0;
-	for (; len > 0; len -= sizeof(u32), image++) {
-		/* read data comes through single port, auto-incr addr */
-		/* NOTE: Use the debugless read so we don't flood kernel log
-		 * if IL_DL_IO is set */
-		val = _il_rd(il, HBUS_TARG_MEM_RDAT);
-		if (val != le32_to_cpu(*image)) {
-			IL_ERR("uCode INST section is invalid at "
-				  "offset 0x%x, is 0x%x, s/b 0x%x\n",
-				  save_len - len, val, le32_to_cpu(*image));
-			ret = -EIO;
-			errcnt++;
-			if (errcnt >= 20)
-				break;
-		}
-	}
-
-	if (!errcnt)
-		D_INFO(
-		    "ucode image in INSTRUCTION memory is good\n");
-
-	return ret;
-}
-
-/**
- * il4965_verify_ucode - determine which instruction image is in SRAM,
- *    and verify its contents
- */
-int il4965_verify_ucode(struct il_priv *il)
-{
-	__le32 *image;
-	u32 len;
-	int ret;
-
-	/* Try bootstrap */
-	image = (__le32 *)il->ucode_boot.v_addr;
-	len = il->ucode_boot.len;
-	ret = il4965_verify_inst_sparse(il, image, len);
-	if (!ret) {
-		D_INFO("Bootstrap uCode is good in inst SRAM\n");
-		return 0;
-	}
-
-	/* Try initialize */
-	image = (__le32 *)il->ucode_init.v_addr;
-	len = il->ucode_init.len;
-	ret = il4965_verify_inst_sparse(il, image, len);
-	if (!ret) {
-		D_INFO("Initialize uCode is good in inst SRAM\n");
-		return 0;
-	}
-
-	/* Try runtime/protocol */
-	image = (__le32 *)il->ucode_code.v_addr;
-	len = il->ucode_code.len;
-	ret = il4965_verify_inst_sparse(il, image, len);
-	if (!ret) {
-		D_INFO("Runtime uCode is good in inst SRAM\n");
-		return 0;
-	}
-
-	IL_ERR("NO VALID UCODE IMAGE IN INSTRUCTION SRAM!!\n");
-
-	/* Since nothing seems to match, show first several data entries in
-	 * instruction SRAM, so maybe visual inspection will give a clue.
-	 * Selection of bootstrap image (vs. other images) is arbitrary. */
-	image = (__le32 *)il->ucode_boot.v_addr;
-	len = il->ucode_boot.len;
-	ret = il4965_verify_inst_full(il, image, len);
-
-	return ret;
-}
-- 
1.7.1

