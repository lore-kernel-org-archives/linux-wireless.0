Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:18903 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756063Ab1KRIVu (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 18 Nov 2011 03:21:50 -0500
Received: from int-mx10.intmail.prod.int.phx2.redhat.com (int-mx10.intmail.prod.int.phx2.redhat.com [10.5.11.23])
	by mx1.redhat.com (8.14.4/8.14.4) with ESMTP id pAI8LnC0032299
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=OK)
	for <linux-wireless@vger.kernel.org>; Fri, 18 Nov 2011 03:21:50 -0500
From: Stanislaw Gruszka <sgruszka@redhat.com>
To: linux-wireless@vger.kernel.org
Cc: Stanislaw Gruszka <sgruszka@redhat.com>
Subject: [PATCH 29/77] iwlegacy: merge iwl-4965-led.c into 4965.c
Date: Fri, 18 Nov 2011 09:21:51 +0100
Message-Id: <1321604559-10707-29-git-send-email-sgruszka@redhat.com> (sfid-20111118_092155_699794_064451F5)
In-Reply-To: <1321604559-10707-1-git-send-email-sgruszka@redhat.com>
References: <1321604559-10707-1-git-send-email-sgruszka@redhat.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Signed-off-by: Stanislaw Gruszka <sgruszka@redhat.com>
---
 drivers/net/wireless/iwlegacy/4965-mac.c     |    1 -
 drivers/net/wireless/iwlegacy/4965.c         |   31 +++++++++++-
 drivers/net/wireless/iwlegacy/Makefile       |    2 +-
 drivers/net/wireless/iwlegacy/iwl-4965-led.c |   73 --------------------------
 drivers/net/wireless/iwlegacy/iwl-4965-led.h |   33 ------------
 drivers/net/wireless/iwlegacy/iwl-4965.h     |    2 +
 6 files changed, 33 insertions(+), 109 deletions(-)
 delete mode 100644 drivers/net/wireless/iwlegacy/iwl-4965-led.c
 delete mode 100644 drivers/net/wireless/iwlegacy/iwl-4965-led.h

diff --git a/drivers/net/wireless/iwlegacy/4965-mac.c b/drivers/net/wireless/iwlegacy/4965-mac.c
index df86431..4a8ad8d 100644
--- a/drivers/net/wireless/iwlegacy/4965-mac.c
+++ b/drivers/net/wireless/iwlegacy/4965-mac.c
@@ -58,7 +58,6 @@
 #include "iwl-sta.h"
 #include "iwl-4965-calib.h"
 #include "iwl-4965.h"
-#include "iwl-4965-led.h"
 
 
 /******************************************************************************
diff --git a/drivers/net/wireless/iwlegacy/4965.c b/drivers/net/wireless/iwlegacy/4965.c
index bdfb3a6..8f68b94 100644
--- a/drivers/net/wireless/iwlegacy/4965.c
+++ b/drivers/net/wireless/iwlegacy/4965.c
@@ -44,10 +44,39 @@
 #include "iwl-helpers.h"
 #include "iwl-4965-calib.h"
 #include "iwl-sta.h"
-#include "iwl-4965-led.h"
 #include "iwl-4965.h"
 #include "iwl-4965-debugfs.h"
 
+/* Send led command */
+static int
+il4965_send_led_cmd(struct il_priv *il, struct il_led_cmd *led_cmd)
+{
+	struct il_host_cmd cmd = {
+		.id = REPLY_LEDS_CMD,
+		.len = sizeof(struct il_led_cmd),
+		.data = led_cmd,
+		.flags = CMD_ASYNC,
+		.callback = NULL,
+	};
+	u32 reg;
+
+	reg = _il_rd(il, CSR_LED_REG);
+	if (reg != (reg & CSR_LED_BSM_CTRL_MSK))
+		_il_wr(il, CSR_LED_REG, reg & CSR_LED_BSM_CTRL_MSK);
+
+	return il_send_cmd(il, &cmd);
+}
+
+/* Set led register off */
+void il4965_led_enable(struct il_priv *il)
+{
+	_il_wr(il, CSR_LED_REG, CSR_LED_REG_TRUN_ON);
+}
+
+const struct il_led_ops il4965_led_ops = {
+	.cmd = il4965_send_led_cmd,
+};
+
 static int il4965_send_tx_power(struct il_priv *il);
 static int il4965_hw_get_temperature(struct il_priv *il);
 
diff --git a/drivers/net/wireless/iwlegacy/Makefile b/drivers/net/wireless/iwlegacy/Makefile
index cd8ac73..b909352 100644
--- a/drivers/net/wireless/iwlegacy/Makefile
+++ b/drivers/net/wireless/iwlegacy/Makefile
@@ -8,7 +8,7 @@ iwl-legacy-objs += $(iwl-legacy-m)
 
 # 4965
 obj-$(CONFIG_IWL4965)	+= iwl4965.o
-iwl4965-objs		:= 4965.o 4965-mac.o iwl-4965-rs.o iwl-4965-led.o
+iwl4965-objs		:= 4965.o 4965-mac.o iwl-4965-rs.o
 iwl4965-objs		+= iwl-4965-ucode.o iwl-4965-tx.o
 iwl4965-objs		+= iwl-4965-lib.o iwl-4965-rx.o iwl-4965-calib.o
 iwl4965-objs		+= iwl-4965-sta.o iwl-4965-eeprom.o
diff --git a/drivers/net/wireless/iwlegacy/iwl-4965-led.c b/drivers/net/wireless/iwlegacy/iwl-4965-led.c
deleted file mode 100644
index 4854157..0000000
--- a/drivers/net/wireless/iwlegacy/iwl-4965-led.c
+++ /dev/null
@@ -1,73 +0,0 @@
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
-#include "iwl-dev.h"
-#include "iwl-core.h"
-#include "iwl-io.h"
-#include "iwl-4965-led.h"
-
-/* Send led command */
-static int
-il4965_send_led_cmd(struct il_priv *il, struct il_led_cmd *led_cmd)
-{
-	struct il_host_cmd cmd = {
-		.id = REPLY_LEDS_CMD,
-		.len = sizeof(struct il_led_cmd),
-		.data = led_cmd,
-		.flags = CMD_ASYNC,
-		.callback = NULL,
-	};
-	u32 reg;
-
-	reg = _il_rd(il, CSR_LED_REG);
-	if (reg != (reg & CSR_LED_BSM_CTRL_MSK))
-		_il_wr(il, CSR_LED_REG, reg & CSR_LED_BSM_CTRL_MSK);
-
-	return il_send_cmd(il, &cmd);
-}
-
-/* Set led register off */
-void il4965_led_enable(struct il_priv *il)
-{
-	_il_wr(il, CSR_LED_REG, CSR_LED_REG_TRUN_ON);
-}
-
-const struct il_led_ops il4965_led_ops = {
-	.cmd = il4965_send_led_cmd,
-};
diff --git a/drivers/net/wireless/iwlegacy/iwl-4965-led.h b/drivers/net/wireless/iwlegacy/iwl-4965-led.h
deleted file mode 100644
index e804fe1..0000000
--- a/drivers/net/wireless/iwlegacy/iwl-4965-led.h
+++ /dev/null
@@ -1,33 +0,0 @@
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
-#ifndef __il_4965_led_h__
-#define __il_4965_led_h__
-
-extern const struct il_led_ops il4965_led_ops;
-void il4965_led_enable(struct il_priv *il);
-
-#endif /* __il_4965_led_h__ */
diff --git a/drivers/net/wireless/iwlegacy/iwl-4965.h b/drivers/net/wireless/iwlegacy/iwl-4965.h
index 8076bbe..c0bb45b 100644
--- a/drivers/net/wireless/iwlegacy/iwl-4965.h
+++ b/drivers/net/wireless/iwlegacy/iwl-4965.h
@@ -279,4 +279,6 @@ int il4965_mac_sta_add(struct ieee80211_hw *hw,
 void il4965_mac_channel_switch(struct ieee80211_hw *hw,
 			       struct ieee80211_channel_switch *ch_switch);
 
+void il4965_led_enable(struct il_priv *il);
+
 #endif /* __il_4965_h__ */
-- 
1.7.1

