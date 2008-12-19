Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga11.intel.com ([192.55.52.93]:33262 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752591AbYLSCpP (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 18 Dec 2008 21:45:15 -0500
From: Zhu Yi <yi.zhu@intel.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org,
	ipw3945-devel@lists.sourceforge.net,
	"Kolekar, Abhijeet" <abhijeet.kolekar@intel.com>,
	Zhu Yi <yi.zhu@intel.com>
Subject: [PATCH 18/43] iwl3945: include iwl-core.h
Date: Fri, 19 Dec 2008 10:37:18 +0800
Message-Id: <1229654263-21454-19-git-send-email-yi.zhu@intel.com> (sfid-20081219_034550_847478_99C41BAA)
In-Reply-To: <1229654263-21454-18-git-send-email-yi.zhu@intel.com>
References: <1229654263-21454-1-git-send-email-yi.zhu@intel.com>
 <1229654263-21454-2-git-send-email-yi.zhu@intel.com>
 <1229654263-21454-3-git-send-email-yi.zhu@intel.com>
 <1229654263-21454-4-git-send-email-yi.zhu@intel.com>
 <1229654263-21454-5-git-send-email-yi.zhu@intel.com>
 <1229654263-21454-6-git-send-email-yi.zhu@intel.com>
 <1229654263-21454-7-git-send-email-yi.zhu@intel.com>
 <1229654263-21454-8-git-send-email-yi.zhu@intel.com>
 <1229654263-21454-9-git-send-email-yi.zhu@intel.com>
 <1229654263-21454-10-git-send-email-yi.zhu@intel.com>
 <1229654263-21454-11-git-send-email-yi.zhu@intel.com>
 <1229654263-21454-12-git-send-email-yi.zhu@intel.com>
 <1229654263-21454-13-git-send-email-yi.zhu@intel.com>
 <1229654263-21454-14-git-send-email-yi.zhu@intel.com>
 <1229654263-21454-15-git-send-email-yi.zhu@intel.com>
 <1229654263-21454-16-git-send-email-yi.zhu@intel.com>
 <1229654263-21454-17-git-send-email-yi.zhu@intel.com>
 <1229654263-21454-18-git-send-email-yi.zhu@intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Kolekar, Abhijeet <abhijeet.kolekar@intel.com>

Use iwl-core.h instead of iwl-3945-core.h.

Signed-off-by: Abhijeet Kolekar <abhijeet.kolekar@intel.com>
Signed-off-by: Zhu Yi <yi.zhu@intel.com>
---
 drivers/net/wireless/iwlwifi/iwl-3945-core.h |  104 --------------------------
 drivers/net/wireless/iwlwifi/iwl-3945.c      |    2 +-
 drivers/net/wireless/iwlwifi/iwl-core.h      |   30 ++++++++
 drivers/net/wireless/iwlwifi/iwl3945-base.c  |   52 +-------------
 4 files changed, 32 insertions(+), 156 deletions(-)
 delete mode 100644 drivers/net/wireless/iwlwifi/iwl-3945-core.h

diff --git a/drivers/net/wireless/iwlwifi/iwl-3945-core.h b/drivers/net/wireless/iwlwifi/iwl-3945-core.h
deleted file mode 100644
index 6f46355..0000000
--- a/drivers/net/wireless/iwlwifi/iwl-3945-core.h
+++ /dev/null
@@ -1,104 +0,0 @@
-/******************************************************************************
- *
- * This file is provided under a dual BSD/GPLv2 license.  When using or
- * redistributing this file, you may do so under either license.
- *
- * GPL LICENSE SUMMARY
- *
- * Copyright(c) 2008 Intel Corporation. All rights reserved.
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
- * Copyright(c) 2005 - 2008 Intel Corporation. All rights reserved.
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
-#ifndef __iwl_3945_dev_h__
-#define __iwl_3945_dev_h__
-
-#define IWL_PCI_DEVICE(dev, subdev, cfg) \
-	.vendor = PCI_VENDOR_ID_INTEL,  .device = (dev), \
-	.subvendor = PCI_ANY_ID, .subdevice = (subdev), \
-	.driver_data = (kernel_ulong_t)&(cfg)
-
-#define IWL_SKU_G       0x1
-#define IWL_SKU_A       0x2
-
-/**
- * struct iwl_3945_cfg
- * @fw_name_pre: Firmware filename prefix. The api version and extension
- * 	(.ucode) will be added to filename before loading from disk. The
- * 	filename is constructed as fw_name_pre<api>.ucode.
- * @ucode_api_max: Highest version of uCode API supported by driver.
- * @ucode_api_min: Lowest version of uCode API supported by driver.
- *
- * We enable the driver to be backward compatible wrt API version. The
- * driver specifies which APIs it supports (with @ucode_api_max being the
- * highest and @ucode_api_min the lowest). Firmware will only be loaded if
- * it has a supported API version. The firmware's API version will be
- * stored in @iwl_priv, enabling the driver to make runtime changes based
- * on firmware version used.
- *
- * For example,
- * if (IWL_UCODE_API(priv->ucode_ver) >= 2) {
- * 	Driver interacts with Firmware API version >= 2.
- * } else {
- * 	Driver interacts with Firmware API version 1.
- * }
- */
-struct iwl_3945_cfg {
-	const char *name;
-	const char *fw_name_pre;
-	const unsigned int ucode_api_max;
-	const unsigned int ucode_api_min;
-	unsigned int sku;
-};
-
-#endif /* __iwl_dev_h__ */
diff --git a/drivers/net/wireless/iwlwifi/iwl-3945.c b/drivers/net/wireless/iwlwifi/iwl-3945.c
index d4f49fd..bb75eaf 100644
--- a/drivers/net/wireless/iwlwifi/iwl-3945.c
+++ b/drivers/net/wireless/iwlwifi/iwl-3945.c
@@ -38,11 +38,11 @@
 #include <asm/unaligned.h>
 #include <net/mac80211.h>
 
-#include "iwl-3945-core.h"
 #include "iwl-3945-fh.h"
 #include "iwl-commands.h"
 #include "iwl-3945.h"
 #include "iwl-helpers.h"
+#include "iwl-core.h"
 #include "iwl-agn-rs.h"
 
 #define IWL_DECLARE_RATE_INFO(r, ip, in, rp, rn, pp, np)    \
diff --git a/drivers/net/wireless/iwlwifi/iwl-core.h b/drivers/net/wireless/iwlwifi/iwl-core.h
index 7c3a20a..a3cc43d 100644
--- a/drivers/net/wireless/iwlwifi/iwl-core.h
+++ b/drivers/net/wireless/iwlwifi/iwl-core.h
@@ -205,6 +205,36 @@ struct iwl_cfg {
 	const struct iwl_mod_params *mod_params;
 };
 
+/**
+ * struct iwl_3945_cfg
+ * @fw_name_pre: Firmware filename prefix. The api version and extension
+ * 	(.ucode) will be added to filename before loading from disk. The
+ * 	filename is constructed as fw_name_pre<api>.ucode.
+ * @ucode_api_max: Highest version of uCode API supported by driver.
+ * @ucode_api_min: Lowest version of uCode API supported by driver.
+ *
+ * We enable the driver to be backward compatible wrt API version. The
+ * driver specifies which APIs it supports (with @ucode_api_max being the
+ * highest and @ucode_api_min the lowest). Firmware will only be loaded if
+ * it has a supported API version. The firmware's API version will be
+ * stored in @iwl_priv, enabling the driver to make runtime changes based
+ * on firmware version used.
+ *
+ * For example,
+ * if (IWL_UCODE_API(priv->ucode_ver) >= 2) {
+ * 	Driver interacts with Firmware API version >= 2.
+ * } else {
+ * 	Driver interacts with Firmware API version 1.
+ * }
+ */
+struct iwl_3945_cfg {
+	const char *name;
+	const char *fw_name_pre;
+	const unsigned int ucode_api_max;
+	const unsigned int ucode_api_min;
+	unsigned int sku;
+};
+
 /***************************
  *   L i b                 *
  ***************************/
diff --git a/drivers/net/wireless/iwlwifi/iwl3945-base.c b/drivers/net/wireless/iwlwifi/iwl3945-base.c
index f62fd6a..2f1d434 100644
--- a/drivers/net/wireless/iwlwifi/iwl3945-base.c
+++ b/drivers/net/wireless/iwlwifi/iwl3945-base.c
@@ -48,11 +48,11 @@
 
 #define DRV_NAME	"iwl3945"
 
-#include "iwl-3945-core.h"
 #include "iwl-commands.h"
 #include "iwl-3945.h"
 #include "iwl-3945-fh.h"
 #include "iwl-helpers.h"
+#include "iwl-core.h"
 #include "iwl-dev.h"
 
 static int iwl3945_tx_queue_update_write_ptr(struct iwl3945_priv *priv,
@@ -492,56 +492,6 @@ static inline int iwl3945_is_ready_rf(struct iwl3945_priv *priv)
 /*************** HOST COMMAND QUEUE FUNCTIONS   *****/
 
 #define IWL_CMD(x) case x: return #x
-
-static const char *get_cmd_string(u8 cmd)
-{
-	switch (cmd) {
-		IWL_CMD(REPLY_ALIVE);
-		IWL_CMD(REPLY_ERROR);
-		IWL_CMD(REPLY_RXON);
-		IWL_CMD(REPLY_RXON_ASSOC);
-		IWL_CMD(REPLY_QOS_PARAM);
-		IWL_CMD(REPLY_RXON_TIMING);
-		IWL_CMD(REPLY_ADD_STA);
-		IWL_CMD(REPLY_REMOVE_STA);
-		IWL_CMD(REPLY_REMOVE_ALL_STA);
-		IWL_CMD(REPLY_3945_RX);
-		IWL_CMD(REPLY_TX);
-		IWL_CMD(REPLY_RATE_SCALE);
-		IWL_CMD(REPLY_LEDS_CMD);
-		IWL_CMD(REPLY_TX_LINK_QUALITY_CMD);
-		IWL_CMD(RADAR_NOTIFICATION);
-		IWL_CMD(REPLY_QUIET_CMD);
-		IWL_CMD(REPLY_CHANNEL_SWITCH);
-		IWL_CMD(CHANNEL_SWITCH_NOTIFICATION);
-		IWL_CMD(REPLY_SPECTRUM_MEASUREMENT_CMD);
-		IWL_CMD(SPECTRUM_MEASURE_NOTIFICATION);
-		IWL_CMD(POWER_TABLE_CMD);
-		IWL_CMD(PM_SLEEP_NOTIFICATION);
-		IWL_CMD(PM_DEBUG_STATISTIC_NOTIFIC);
-		IWL_CMD(REPLY_SCAN_CMD);
-		IWL_CMD(REPLY_SCAN_ABORT_CMD);
-		IWL_CMD(SCAN_START_NOTIFICATION);
-		IWL_CMD(SCAN_RESULTS_NOTIFICATION);
-		IWL_CMD(SCAN_COMPLETE_NOTIFICATION);
-		IWL_CMD(BEACON_NOTIFICATION);
-		IWL_CMD(REPLY_TX_BEACON);
-		IWL_CMD(WHO_IS_AWAKE_NOTIFICATION);
-		IWL_CMD(QUIET_NOTIFICATION);
-		IWL_CMD(REPLY_TX_PWR_TABLE_CMD);
-		IWL_CMD(MEASURE_ABORT_NOTIFICATION);
-		IWL_CMD(REPLY_BT_CONFIG);
-		IWL_CMD(REPLY_STATISTICS_CMD);
-		IWL_CMD(STATISTICS_NOTIFICATION);
-		IWL_CMD(REPLY_CARD_STATE_CMD);
-		IWL_CMD(CARD_STATE_NOTIFICATION);
-		IWL_CMD(MISSED_BEACONS_NOTIFICATION);
-	default:
-		return "UNKNOWN";
-
-	}
-}
-
 #define HOST_COMPLETE_TIMEOUT (HZ / 2)
 
 /**
-- 
1.5.3.6

