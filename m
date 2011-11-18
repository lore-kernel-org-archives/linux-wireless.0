Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:46340 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756675Ab1KRIWy (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 18 Nov 2011 03:22:54 -0500
Received: from int-mx09.intmail.prod.int.phx2.redhat.com (int-mx09.intmail.prod.int.phx2.redhat.com [10.5.11.22])
	by mx1.redhat.com (8.14.4/8.14.4) with ESMTP id pAI8MrXN026341
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=OK)
	for <linux-wireless@vger.kernel.org>; Fri, 18 Nov 2011 03:22:53 -0500
From: Stanislaw Gruszka <sgruszka@redhat.com>
To: linux-wireless@vger.kernel.org
Cc: Stanislaw Gruszka <sgruszka@redhat.com>
Subject: [PATCH 58/77] iwlegacy: merge iwl-power.h into common.h
Date: Fri, 18 Nov 2011 09:22:20 +0100
Message-Id: <1321604559-10707-58-git-send-email-sgruszka@redhat.com> (sfid-20111118_092358_601313_E6EF99C9)
In-Reply-To: <1321604559-10707-1-git-send-email-sgruszka@redhat.com>
References: <1321604559-10707-1-git-send-email-sgruszka@redhat.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Signed-off-by: Stanislaw Gruszka <sgruszka@redhat.com>
---
 drivers/net/wireless/iwlegacy/3945.h      |    1 -
 drivers/net/wireless/iwlegacy/commands.h  |    2 +
 drivers/net/wireless/iwlegacy/common.c    |    1 -
 drivers/net/wireless/iwlegacy/common.h    |   11 +++++-
 drivers/net/wireless/iwlegacy/iwl-power.h |   55 -----------------------------
 5 files changed, 12 insertions(+), 58 deletions(-)
 delete mode 100644 drivers/net/wireless/iwlegacy/iwl-power.h

diff --git a/drivers/net/wireless/iwlegacy/3945.h b/drivers/net/wireless/iwlegacy/3945.h
index 726ca2c..22166bd 100644
--- a/drivers/net/wireless/iwlegacy/3945.h
+++ b/drivers/net/wireless/iwlegacy/3945.h
@@ -37,7 +37,6 @@ extern const struct pci_device_id il3945_hw_card_ids[];
 #include "common.h"
 #include "iwl-prph.h"
 #include "iwl-debug.h"
-#include "iwl-power.h"
 #include "iwl-led.h"
 #include "iwl-eeprom.h"
 
diff --git a/drivers/net/wireless/iwlegacy/commands.h b/drivers/net/wireless/iwlegacy/commands.h
index 2f64ed3..9eb7a83 100644
--- a/drivers/net/wireless/iwlegacy/commands.h
+++ b/drivers/net/wireless/iwlegacy/commands.h
@@ -64,6 +64,8 @@
 #ifndef __il_commands_h__
 #define __il_commands_h__
 
+#include <linux/ieee80211.h>
+
 struct il_priv;
 
 /* uCode version contains 4 values: Major/Minor/API/Serial */
diff --git a/drivers/net/wireless/iwlegacy/common.c b/drivers/net/wireless/iwlegacy/common.c
index 4258bf6..3b8d47c 100644
--- a/drivers/net/wireless/iwlegacy/common.c
+++ b/drivers/net/wireless/iwlegacy/common.c
@@ -43,7 +43,6 @@
 #include "iwl-eeprom.h"
 #include "iwl-debug.h"
 #include "common.h"
-#include "iwl-power.h"
 
 const char *il_get_cmd_string(u8 cmd)
 {
diff --git a/drivers/net/wireless/iwlegacy/common.h b/drivers/net/wireless/iwlegacy/common.h
index 2e66929..65c593d 100644
--- a/drivers/net/wireless/iwlegacy/common.h
+++ b/drivers/net/wireless/iwlegacy/common.h
@@ -33,12 +33,12 @@
 #include <linux/wait.h>
 #include <net/ieee80211_radiotap.h>
 
+#include "commands.h"
 #include "iwl-eeprom.h"
 #include "csr.h"
 #include "iwl-prph.h"
 #include "iwl-debug.h"
 #include "iwl-led.h"
-#include "iwl-power.h"
 
 struct il_host_cmd;
 struct il_cmd;
@@ -938,6 +938,13 @@ struct il_rxon_context {
 	} ht;
 };
 
+struct il_power_mgr {
+	struct il_powertable_cmd sleep_cmd;
+	struct il_powertable_cmd sleep_cmd_next;
+	int debug_sleep_level_override;
+	bool pci_pm;
+};
+
 struct il_priv {
 
 	/* ieee device used by generic ieee processing code */
@@ -2996,4 +3003,6 @@ extern int il3945_rate_control_register(void);
 extern void il4965_rate_control_unregister(void);
 extern void il3945_rate_control_unregister(void);
 
+extern int il_power_update_mode(struct il_priv *il, bool force);
+extern void il_power_initialize(struct il_priv *il);
 #endif /* __il_core_h__ */
diff --git a/drivers/net/wireless/iwlegacy/iwl-power.h b/drivers/net/wireless/iwlegacy/iwl-power.h
deleted file mode 100644
index c0ae3fa..0000000
--- a/drivers/net/wireless/iwlegacy/iwl-power.h
+++ /dev/null
@@ -1,55 +0,0 @@
-/******************************************************************************
- *
- * Copyright(c) 2007 - 2011 Intel Corporation. All rights reserved.
- *
- * Portions of this file are derived from the ipw3945 project, as well
- * as portions of the ieee80211 subsystem header files.
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
- *****************************************************************************/
-#ifndef __il_power_setting_h__
-#define __il_power_setting_h__
-
-#include "commands.h"
-
-enum il_power_level {
-	IL_POWER_IDX_1,
-	IL_POWER_IDX_2,
-	IL_POWER_IDX_3,
-	IL_POWER_IDX_4,
-	IL_POWER_IDX_5,
-	IL_POWER_NUM
-};
-
-struct il_power_mgr {
-	struct il_powertable_cmd sleep_cmd;
-	struct il_powertable_cmd sleep_cmd_next;
-	int debug_sleep_level_override;
-	bool pci_pm;
-};
-
-int
-il_power_set_mode(struct il_priv *il, struct il_powertable_cmd *cmd,
-		       bool force);
-int il_power_update_mode(struct il_priv *il, bool force);
-void il_power_initialize(struct il_priv *il);
-
-#endif  /* __il_power_setting_h__ */
-- 
1.7.1

