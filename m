Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:5972 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756571Ab1KRIV7 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 18 Nov 2011 03:21:59 -0500
Received: from int-mx09.intmail.prod.int.phx2.redhat.com (int-mx09.intmail.prod.int.phx2.redhat.com [10.5.11.22])
	by mx1.redhat.com (8.14.4/8.14.4) with ESMTP id pAI8Lx5q022670
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=OK)
	for <linux-wireless@vger.kernel.org>; Fri, 18 Nov 2011 03:21:59 -0500
From: Stanislaw Gruszka <sgruszka@redhat.com>
To: linux-wireless@vger.kernel.org
Cc: Stanislaw Gruszka <sgruszka@redhat.com>
Subject: [PATCH 31/77] iwlegacy: merge iwl-4965-eeprom.c into 4965.c
Date: Fri, 18 Nov 2011 09:21:53 +0100
Message-Id: <1321604559-10707-31-git-send-email-sgruszka@redhat.com> (sfid-20111118_092204_479977_8204283F)
In-Reply-To: <1321604559-10707-1-git-send-email-sgruszka@redhat.com>
References: <1321604559-10707-1-git-send-email-sgruszka@redhat.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Signed-off-by: Stanislaw Gruszka <sgruszka@redhat.com>
---
 drivers/net/wireless/iwlegacy/4965.c            |   74 +++++++++++
 drivers/net/wireless/iwlegacy/Makefile          |    2 +-
 drivers/net/wireless/iwlegacy/iwl-4965-eeprom.c |  150 -----------------------
 3 files changed, 75 insertions(+), 151 deletions(-)
 delete mode 100644 drivers/net/wireless/iwlegacy/iwl-4965-eeprom.c

diff --git a/drivers/net/wireless/iwlegacy/4965.c b/drivers/net/wireless/iwlegacy/4965.c
index 8f68b94..a4b42cc 100644
--- a/drivers/net/wireless/iwlegacy/4965.c
+++ b/drivers/net/wireless/iwlegacy/4965.c
@@ -47,6 +47,80 @@
 #include "iwl-4965.h"
 #include "iwl-4965-debugfs.h"
 
+/******************************************************************************
+ *
+ * EEPROM related functions
+ *
+******************************************************************************/
+
+/*
+ * The device's EEPROM semaphore prevents conflicts between driver and uCode
+ * when accessing the EEPROM; each access is a series of pulses to/from the
+ * EEPROM chip, not a single event, so even reads could conflict if they
+ * weren't arbitrated by the semaphore.
+ */
+int il4965_eeprom_acquire_semaphore(struct il_priv *il)
+{
+	u16 count;
+	int ret;
+
+	for (count = 0; count < EEPROM_SEM_RETRY_LIMIT; count++) {
+		/* Request semaphore */
+		il_set_bit(il, CSR_HW_IF_CONFIG_REG,
+			    CSR_HW_IF_CONFIG_REG_BIT_EEPROM_OWN_SEM);
+
+		/* See if we got it */
+		ret = _il_poll_bit(il, CSR_HW_IF_CONFIG_REG,
+				CSR_HW_IF_CONFIG_REG_BIT_EEPROM_OWN_SEM,
+				CSR_HW_IF_CONFIG_REG_BIT_EEPROM_OWN_SEM,
+				EEPROM_SEM_TIMEOUT);
+		if (ret >= 0)
+			return ret;
+	}
+
+	return ret;
+}
+
+void il4965_eeprom_release_semaphore(struct il_priv *il)
+{
+	il_clear_bit(il, CSR_HW_IF_CONFIG_REG,
+		CSR_HW_IF_CONFIG_REG_BIT_EEPROM_OWN_SEM);
+
+}
+
+int il4965_eeprom_check_version(struct il_priv *il)
+{
+	u16 eeprom_ver;
+	u16 calib_ver;
+
+	eeprom_ver = il_eeprom_query16(il, EEPROM_VERSION);
+	calib_ver = il_eeprom_query16(il,
+			EEPROM_4965_CALIB_VERSION_OFFSET);
+
+	if (eeprom_ver < il->cfg->eeprom_ver ||
+	    calib_ver < il->cfg->eeprom_calib_ver)
+		goto err;
+
+	IL_INFO("device EEPROM VER=0x%x, CALIB=0x%x\n",
+		 eeprom_ver, calib_ver);
+
+	return 0;
+err:
+	IL_ERR("Unsupported (too old) EEPROM VER=0x%x < 0x%x "
+		  "CALIB=0x%x < 0x%x\n",
+		  eeprom_ver, il->cfg->eeprom_ver,
+		  calib_ver,  il->cfg->eeprom_calib_ver);
+	return -EINVAL;
+
+}
+
+void il4965_eeprom_get_mac(const struct il_priv *il, u8 *mac)
+{
+	const u8 *addr = il_eeprom_query_addr(il,
+					EEPROM_MAC_ADDRESS);
+	memcpy(mac, addr, ETH_ALEN);
+}
+
 /* Send led command */
 static int
 il4965_send_led_cmd(struct il_priv *il, struct il_led_cmd *led_cmd)
diff --git a/drivers/net/wireless/iwlegacy/Makefile b/drivers/net/wireless/iwlegacy/Makefile
index da83c69..2776845 100644
--- a/drivers/net/wireless/iwlegacy/Makefile
+++ b/drivers/net/wireless/iwlegacy/Makefile
@@ -11,7 +11,7 @@ obj-$(CONFIG_IWL4965)	+= iwl4965.o
 iwl4965-objs		:= 4965.o 4965-mac.o iwl-4965-rs.o
 iwl4965-objs		+= iwl-4965-ucode.o iwl-4965-tx.o
 iwl4965-objs		+= iwl-4965-lib.o iwl-4965-rx.o iwl-4965-calib.o
-iwl4965-objs		+= iwl-4965-sta.o iwl-4965-eeprom.o
+iwl4965-objs		+= iwl-4965-sta.o
 iwl4965-$(CONFIG_IWLEGACY_DEBUGFS) += iwl-4965-debugfs.o
 
 # 3945
diff --git a/drivers/net/wireless/iwlegacy/iwl-4965-eeprom.c b/drivers/net/wireless/iwlegacy/iwl-4965-eeprom.c
deleted file mode 100644
index a519257..0000000
--- a/drivers/net/wireless/iwlegacy/iwl-4965-eeprom.c
+++ /dev/null
@@ -1,150 +0,0 @@
-/******************************************************************************
- *
- * This file is provided under a dual BSD/GPLv2 license.  When using or
- * redistributing this file, you may do so under either license.
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
- * BSD LICENSE
- *
- * Copyright(c) 2005 - 2011 Intel Corporation. All rights reserved.
- * All rights reserved.
- *
- * Redistribution and use in source and binary forms, with or without
- * modification, are permitted provided that the following conditions
- * are met:
- *
- *  * Redistributions of source code must retain the above copyright
- *    notice, this list of conditions and the following disclaimer.
- *  * Redistributions in binary form must reproduce the above copyright
- *    notice, this list of conditions and the following disclaimer in
- *    the documentation and/or other materials provided with the
- *    distribution.
- *  * Neither the name Intel Corporation nor the names of its
- *    contributors may be used to endorse or promote products derived
- *    from this software without specific prior written permission.
- *
- * THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS
- * "AS IS" AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT
- * LIMITED TO, THE IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR
- * A PARTICULAR PURPOSE ARE DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT
- * OWNER OR CONTRIBUTORS BE LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL,
- * SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT
- * LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; LOSS OF USE,
- * DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON ANY
- * THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT
- * (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE
- * OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
- *****************************************************************************/
-
-
-#include <linux/kernel.h>
-#include <linux/module.h>
-#include <linux/slab.h>
-#include <linux/init.h>
-
-#include <net/mac80211.h>
-
-#include "iwl-commands.h"
-#include "iwl-dev.h"
-#include "iwl-core.h"
-#include "iwl-debug.h"
-#include "iwl-4965.h"
-#include "iwl-io.h"
-
-/******************************************************************************
- *
- * EEPROM related functions
- *
-******************************************************************************/
-
-/*
- * The device's EEPROM semaphore prevents conflicts between driver and uCode
- * when accessing the EEPROM; each access is a series of pulses to/from the
- * EEPROM chip, not a single event, so even reads could conflict if they
- * weren't arbitrated by the semaphore.
- */
-int il4965_eeprom_acquire_semaphore(struct il_priv *il)
-{
-	u16 count;
-	int ret;
-
-	for (count = 0; count < EEPROM_SEM_RETRY_LIMIT; count++) {
-		/* Request semaphore */
-		il_set_bit(il, CSR_HW_IF_CONFIG_REG,
-			    CSR_HW_IF_CONFIG_REG_BIT_EEPROM_OWN_SEM);
-
-		/* See if we got it */
-		ret = _il_poll_bit(il, CSR_HW_IF_CONFIG_REG,
-				CSR_HW_IF_CONFIG_REG_BIT_EEPROM_OWN_SEM,
-				CSR_HW_IF_CONFIG_REG_BIT_EEPROM_OWN_SEM,
-				EEPROM_SEM_TIMEOUT);
-		if (ret >= 0)
-			return ret;
-	}
-
-	return ret;
-}
-
-void il4965_eeprom_release_semaphore(struct il_priv *il)
-{
-	il_clear_bit(il, CSR_HW_IF_CONFIG_REG,
-		CSR_HW_IF_CONFIG_REG_BIT_EEPROM_OWN_SEM);
-
-}
-
-int il4965_eeprom_check_version(struct il_priv *il)
-{
-	u16 eeprom_ver;
-	u16 calib_ver;
-
-	eeprom_ver = il_eeprom_query16(il, EEPROM_VERSION);
-	calib_ver = il_eeprom_query16(il,
-			EEPROM_4965_CALIB_VERSION_OFFSET);
-
-	if (eeprom_ver < il->cfg->eeprom_ver ||
-	    calib_ver < il->cfg->eeprom_calib_ver)
-		goto err;
-
-	IL_INFO("device EEPROM VER=0x%x, CALIB=0x%x\n",
-		 eeprom_ver, calib_ver);
-
-	return 0;
-err:
-	IL_ERR("Unsupported (too old) EEPROM VER=0x%x < 0x%x "
-		  "CALIB=0x%x < 0x%x\n",
-		  eeprom_ver, il->cfg->eeprom_ver,
-		  calib_ver,  il->cfg->eeprom_calib_ver);
-	return -EINVAL;
-
-}
-
-void il4965_eeprom_get_mac(const struct il_priv *il, u8 *mac)
-{
-	const u8 *addr = il_eeprom_query_addr(il,
-					EEPROM_MAC_ADDRESS);
-	memcpy(mac, addr, ETH_ALEN);
-}
-- 
1.7.1

