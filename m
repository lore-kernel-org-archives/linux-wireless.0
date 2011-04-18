Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga01.intel.com ([192.55.52.88]:32823 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754434Ab1DRRFh (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 18 Apr 2011 13:05:37 -0400
From: Wey-Yi Guy <wey-yi.w.guy@intel.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org,
	ipw3945-devel@lists.sourceforge.net,
	Wey-Yi Guy <wey-yi.w.guy@intel.com>
Subject: [PATCH 01/10] iwlagn: use direct call for led functions
Date: Mon, 18 Apr 2011 09:44:08 -0700
Message-Id: <1303145057-6545-2-git-send-email-wey-yi.w.guy@intel.com>
In-Reply-To: <1303145057-6545-1-git-send-email-wey-yi.w.guy@intel.com>
References: <1303145057-6545-1-git-send-email-wey-yi.w.guy@intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

After driver split, no need to call led functions through callback

Signed-off-by: Wey-Yi Guy <wey-yi.w.guy@intel.com>
---
 drivers/net/wireless/iwlwifi/Makefile      |    2 +-
 drivers/net/wireless/iwlwifi/iwl-1000.c    |    2 -
 drivers/net/wireless/iwlwifi/iwl-2000.c    |    5 --
 drivers/net/wireless/iwlwifi/iwl-5000.c    |    3 -
 drivers/net/wireless/iwlwifi/iwl-6000.c    |    5 --
 drivers/net/wireless/iwlwifi/iwl-agn-led.c |   73 ----------------------------
 drivers/net/wireless/iwlwifi/iwl-agn-led.h |   33 -------------
 drivers/net/wireless/iwlwifi/iwl-agn.c     |    1 -
 drivers/net/wireless/iwlwifi/iwl-core.h    |    1 -
 drivers/net/wireless/iwlwifi/iwl-led.c     |   26 ++++++++++-
 drivers/net/wireless/iwlwifi/iwl-led.h     |    1 +
 11 files changed, 27 insertions(+), 125 deletions(-)
 delete mode 100644 drivers/net/wireless/iwlwifi/iwl-agn-led.c
 delete mode 100644 drivers/net/wireless/iwlwifi/iwl-agn-led.h

diff --git a/drivers/net/wireless/iwlwifi/Makefile b/drivers/net/wireless/iwlwifi/Makefile
index 3652931..bb6a737 100644
--- a/drivers/net/wireless/iwlwifi/Makefile
+++ b/drivers/net/wireless/iwlwifi/Makefile
@@ -1,6 +1,6 @@
 # AGN
 obj-$(CONFIG_IWLAGN)	+= iwlagn.o
-iwlagn-objs		:= iwl-agn.o iwl-agn-rs.o iwl-agn-led.o
+iwlagn-objs		:= iwl-agn.o iwl-agn-rs.o
 iwlagn-objs		+= iwl-agn-ucode.o iwl-agn-tx.o
 iwlagn-objs		+= iwl-agn-lib.o iwl-agn-calib.o iwl-io.o
 iwlagn-objs		+= iwl-agn-tt.o iwl-agn-sta.o iwl-agn-eeprom.o
diff --git a/drivers/net/wireless/iwlwifi/iwl-1000.c b/drivers/net/wireless/iwlwifi/iwl-1000.c
index d1d7852..809117d 100644
--- a/drivers/net/wireless/iwlwifi/iwl-1000.c
+++ b/drivers/net/wireless/iwlwifi/iwl-1000.c
@@ -45,7 +45,6 @@
 #include "iwl-agn.h"
 #include "iwl-helpers.h"
 #include "iwl-agn-hw.h"
-#include "iwl-agn-led.h"
 #include "iwl-agn-debugfs.h"
 
 /* Highest firmware API version supported */
@@ -226,7 +225,6 @@ static const struct iwl_ops iwl1000_ops = {
 	.lib = &iwl1000_lib,
 	.hcmd = &iwlagn_hcmd,
 	.utils = &iwlagn_hcmd_utils,
-	.led = &iwlagn_led_ops,
 	.ieee80211_ops = &iwlagn_hw_ops,
 };
 
diff --git a/drivers/net/wireless/iwlwifi/iwl-2000.c b/drivers/net/wireless/iwlwifi/iwl-2000.c
index a31314f..0a330d1 100644
--- a/drivers/net/wireless/iwlwifi/iwl-2000.c
+++ b/drivers/net/wireless/iwlwifi/iwl-2000.c
@@ -46,7 +46,6 @@
 #include "iwl-helpers.h"
 #include "iwl-agn-hw.h"
 #include "iwl-6000-hw.h"
-#include "iwl-agn-led.h"
 #include "iwl-agn-debugfs.h"
 
 /* Highest firmware API version supported */
@@ -310,7 +309,6 @@ static const struct iwl_ops iwl2000_ops = {
 	.lib = &iwl2000_lib,
 	.hcmd = &iwlagn_hcmd,
 	.utils = &iwlagn_hcmd_utils,
-	.led = &iwlagn_led_ops,
 	.ieee80211_ops = &iwlagn_hw_ops,
 };
 
@@ -318,7 +316,6 @@ static const struct iwl_ops iwl2030_ops = {
 	.lib = &iwl2000_lib,
 	.hcmd = &iwlagn_bt_hcmd,
 	.utils = &iwlagn_hcmd_utils,
-	.led = &iwlagn_led_ops,
 	.ieee80211_ops = &iwlagn_hw_ops,
 };
 
@@ -326,7 +323,6 @@ static const struct iwl_ops iwl200_ops = {
 	.lib = &iwl2000_lib,
 	.hcmd = &iwlagn_hcmd,
 	.utils = &iwlagn_hcmd_utils,
-	.led = &iwlagn_led_ops,
 	.ieee80211_ops = &iwlagn_hw_ops,
 };
 
@@ -334,7 +330,6 @@ static const struct iwl_ops iwl230_ops = {
 	.lib = &iwl2000_lib,
 	.hcmd = &iwlagn_bt_hcmd,
 	.utils = &iwlagn_hcmd_utils,
-	.led = &iwlagn_led_ops,
 	.ieee80211_ops = &iwlagn_hw_ops,
 };
 
diff --git a/drivers/net/wireless/iwlwifi/iwl-5000.c b/drivers/net/wireless/iwlwifi/iwl-5000.c
index 7c28666..79dd45c 100644
--- a/drivers/net/wireless/iwlwifi/iwl-5000.c
+++ b/drivers/net/wireless/iwlwifi/iwl-5000.c
@@ -45,7 +45,6 @@
 #include "iwl-sta.h"
 #include "iwl-helpers.h"
 #include "iwl-agn.h"
-#include "iwl-agn-led.h"
 #include "iwl-agn-hw.h"
 #include "iwl-5000-hw.h"
 #include "iwl-agn-debugfs.h"
@@ -447,7 +446,6 @@ static const struct iwl_ops iwl5000_ops = {
 	.lib = &iwl5000_lib,
 	.hcmd = &iwlagn_hcmd,
 	.utils = &iwlagn_hcmd_utils,
-	.led = &iwlagn_led_ops,
 	.ieee80211_ops = &iwlagn_hw_ops,
 };
 
@@ -455,7 +453,6 @@ static const struct iwl_ops iwl5150_ops = {
 	.lib = &iwl5150_lib,
 	.hcmd = &iwlagn_hcmd,
 	.utils = &iwlagn_hcmd_utils,
-	.led = &iwlagn_led_ops,
 	.ieee80211_ops = &iwlagn_hw_ops,
 };
 
diff --git a/drivers/net/wireless/iwlwifi/iwl-6000.c b/drivers/net/wireless/iwlwifi/iwl-6000.c
index 0649813..a35338e 100644
--- a/drivers/net/wireless/iwlwifi/iwl-6000.c
+++ b/drivers/net/wireless/iwlwifi/iwl-6000.c
@@ -46,7 +46,6 @@
 #include "iwl-helpers.h"
 #include "iwl-agn-hw.h"
 #include "iwl-6000-hw.h"
-#include "iwl-agn-led.h"
 #include "iwl-agn-debugfs.h"
 
 /* Highest firmware API version supported */
@@ -397,7 +396,6 @@ static const struct iwl_ops iwl6000_ops = {
 	.lib = &iwl6000_lib,
 	.hcmd = &iwlagn_hcmd,
 	.utils = &iwlagn_hcmd_utils,
-	.led = &iwlagn_led_ops,
 	.ieee80211_ops = &iwlagn_hw_ops,
 };
 
@@ -405,7 +403,6 @@ static const struct iwl_ops iwl6050_ops = {
 	.lib = &iwl6000_lib,
 	.hcmd = &iwlagn_hcmd,
 	.utils = &iwlagn_hcmd_utils,
-	.led = &iwlagn_led_ops,
 	.nic = &iwl6050_nic_ops,
 	.ieee80211_ops = &iwlagn_hw_ops,
 };
@@ -414,7 +411,6 @@ static const struct iwl_ops iwl6150_ops = {
 	.lib = &iwl6000_lib,
 	.hcmd = &iwlagn_hcmd,
 	.utils = &iwlagn_hcmd_utils,
-	.led = &iwlagn_led_ops,
 	.nic = &iwl6150_nic_ops,
 	.ieee80211_ops = &iwlagn_hw_ops,
 };
@@ -423,7 +419,6 @@ static const struct iwl_ops iwl6030_ops = {
 	.lib = &iwl6030_lib,
 	.hcmd = &iwlagn_bt_hcmd,
 	.utils = &iwlagn_hcmd_utils,
-	.led = &iwlagn_led_ops,
 	.ieee80211_ops = &iwlagn_hw_ops,
 };
 
diff --git a/drivers/net/wireless/iwlwifi/iwl-agn-led.c b/drivers/net/wireless/iwlwifi/iwl-agn-led.c
deleted file mode 100644
index 4bb877e..0000000
--- a/drivers/net/wireless/iwlwifi/iwl-agn-led.c
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
-#include <linux/wireless.h>
-#include <net/mac80211.h>
-#include <linux/etherdevice.h>
-#include <asm/unaligned.h>
-
-#include "iwl-commands.h"
-#include "iwl-dev.h"
-#include "iwl-core.h"
-#include "iwl-io.h"
-#include "iwl-agn-led.h"
-
-/* Send led command */
-static int iwl_send_led_cmd(struct iwl_priv *priv, struct iwl_led_cmd *led_cmd)
-{
-	struct iwl_host_cmd cmd = {
-		.id = REPLY_LEDS_CMD,
-		.len = sizeof(struct iwl_led_cmd),
-		.data = led_cmd,
-		.flags = CMD_ASYNC,
-		.callback = NULL,
-	};
-	u32 reg;
-
-	reg = iwl_read32(priv, CSR_LED_REG);
-	if (reg != (reg & CSR_LED_BSM_CTRL_MSK))
-		iwl_write32(priv, CSR_LED_REG, reg & CSR_LED_BSM_CTRL_MSK);
-
-	return iwl_send_cmd(priv, &cmd);
-}
-
-/* Set led register off */
-void iwlagn_led_enable(struct iwl_priv *priv)
-{
-	iwl_write32(priv, CSR_LED_REG, CSR_LED_REG_TRUN_ON);
-}
-
-const struct iwl_led_ops iwlagn_led_ops = {
-	.cmd = iwl_send_led_cmd,
-};
diff --git a/drivers/net/wireless/iwlwifi/iwl-agn-led.h b/drivers/net/wireless/iwlwifi/iwl-agn-led.h
deleted file mode 100644
index c0b7611..0000000
--- a/drivers/net/wireless/iwlwifi/iwl-agn-led.h
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
-#ifndef __iwl_agn_led_h__
-#define __iwl_agn_led_h__
-
-extern const struct iwl_led_ops iwlagn_led_ops;
-void iwlagn_led_enable(struct iwl_priv *priv);
-
-#endif /* __iwl_agn_led_h__ */
diff --git a/drivers/net/wireless/iwlwifi/iwl-agn.c b/drivers/net/wireless/iwlwifi/iwl-agn.c
index 47a4cda..b4f7510 100644
--- a/drivers/net/wireless/iwlwifi/iwl-agn.c
+++ b/drivers/net/wireless/iwlwifi/iwl-agn.c
@@ -59,7 +59,6 @@
 #include "iwl-sta.h"
 #include "iwl-agn-calib.h"
 #include "iwl-agn.h"
-#include "iwl-agn-led.h"
 
 
 /******************************************************************************
diff --git a/drivers/net/wireless/iwlwifi/iwl-core.h b/drivers/net/wireless/iwlwifi/iwl-core.h
index 6988335..240abdf 100644
--- a/drivers/net/wireless/iwlwifi/iwl-core.h
+++ b/drivers/net/wireless/iwlwifi/iwl-core.h
@@ -217,7 +217,6 @@ struct iwl_ops {
 	const struct iwl_lib_ops *lib;
 	const struct iwl_hcmd_ops *hcmd;
 	const struct iwl_hcmd_utils_ops *utils;
-	const struct iwl_led_ops *led;
 	const struct iwl_nic_ops *nic;
 	const struct iwl_legacy_ops *legacy;
 	const struct ieee80211_ops *ieee80211_ops;
diff --git a/drivers/net/wireless/iwlwifi/iwl-led.c b/drivers/net/wireless/iwlwifi/iwl-led.c
index 0d90004..d798c2a 100644
--- a/drivers/net/wireless/iwlwifi/iwl-led.c
+++ b/drivers/net/wireless/iwlwifi/iwl-led.c
@@ -61,6 +61,12 @@ static const struct ieee80211_tpt_blink iwl_blink[] = {
 	{ .throughput = 300 * 1024 - 1, .blink_time = 50 },
 };
 
+/* Set led register off */
+void iwlagn_led_enable(struct iwl_priv *priv)
+{
+	iwl_write32(priv, CSR_LED_REG, CSR_LED_REG_TRUN_ON);
+}
+
 /*
  * Adjust led blink rate to compensate on a MAC Clock difference on every HW
  * Led blink rate analysis showed an average deviation of 20% on 5000 series
@@ -84,6 +90,24 @@ static inline u8 iwl_blink_compensation(struct iwl_priv *priv,
 	return (u8)((time * compensation) >> 6);
 }
 
+static int iwl_send_led_cmd(struct iwl_priv *priv, struct iwl_led_cmd *led_cmd)
+{
+	struct iwl_host_cmd cmd = {
+		.id = REPLY_LEDS_CMD,
+		.len = sizeof(struct iwl_led_cmd),
+		.data = led_cmd,
+		.flags = CMD_ASYNC,
+		.callback = NULL,
+	};
+	u32 reg;
+
+	reg = iwl_read32(priv, CSR_LED_REG);
+	if (reg != (reg & CSR_LED_BSM_CTRL_MSK))
+		iwl_write32(priv, CSR_LED_REG, reg & CSR_LED_BSM_CTRL_MSK);
+
+	return iwl_send_cmd(priv, &cmd);
+}
+
 /* Set led pattern command */
 static int iwl_led_cmd(struct iwl_priv *priv,
 		       unsigned long on,
@@ -108,7 +132,7 @@ static int iwl_led_cmd(struct iwl_priv *priv,
 	led_cmd.off = iwl_blink_compensation(priv, off,
 				priv->cfg->base_params->led_compensation);
 
-	ret = priv->cfg->ops->led->cmd(priv, &led_cmd);
+	ret = iwl_send_led_cmd(priv, &led_cmd);
 	if (!ret) {
 		priv->blink_on = on;
 		priv->blink_off = off;
diff --git a/drivers/net/wireless/iwlwifi/iwl-led.h b/drivers/net/wireless/iwlwifi/iwl-led.h
index 05b8e8f..1c93dfe 100644
--- a/drivers/net/wireless/iwlwifi/iwl-led.h
+++ b/drivers/net/wireless/iwlwifi/iwl-led.h
@@ -50,6 +50,7 @@ enum iwl_led_mode {
 	IWL_LED_BLINK,
 };
 
+void iwlagn_led_enable(struct iwl_priv *priv);
 void iwl_leds_init(struct iwl_priv *priv);
 void iwl_leds_exit(struct iwl_priv *priv);
 
-- 
1.7.0.4

