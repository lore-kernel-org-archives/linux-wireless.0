Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga11.intel.com ([192.55.52.93]:22725 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752235Ab0CYUoy (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 25 Mar 2010 16:44:54 -0400
From: Reinette Chatre <reinette.chatre@intel.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org,
	ipw3945-devel@lists.sourceforge.net,
	Wey-Yi Guy <wey-yi.w.guy@intel.com>,
	Reinette Chatre <reinette.chatre@intel.com>
Subject: [PATCH 03/22] iwlwifi: move ucode loading related code to separated file
Date: Thu, 25 Mar 2010 13:44:31 -0700
Message-Id: <1269549890-19195-4-git-send-email-reinette.chatre@intel.com>
In-Reply-To: <1269549890-19195-1-git-send-email-reinette.chatre@intel.com>
References: <1269549890-19195-1-git-send-email-reinette.chatre@intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Wey-Yi Guy <wey-yi.w.guy@intel.com>

Multiple iwlagn based devices shared the same ucode loading procedure.
Move loading related code from iwl-5000.c to iwl-agn-ucode.c file.

Signed-off-by: Wey-Yi Guy <wey-yi.w.guy@intel.com>
Signed-off-by: Reinette Chatre <reinette.chatre@intel.com>
---
 drivers/net/wireless/iwlwifi/Makefile        |    1 +
 drivers/net/wireless/iwlwifi/iwl-1000.c      |    2 +-
 drivers/net/wireless/iwlwifi/iwl-5000.c      |   54 +----------------
 drivers/net/wireless/iwlwifi/iwl-6000.c      |    4 +-
 drivers/net/wireless/iwlwifi/iwl-agn-ucode.c |   84 ++++++++++++++++++++++++++
 drivers/net/wireless/iwlwifi/iwl-agn.h       |    2 +
 6 files changed, 92 insertions(+), 55 deletions(-)
 create mode 100644 drivers/net/wireless/iwlwifi/iwl-agn-ucode.c

diff --git a/drivers/net/wireless/iwlwifi/Makefile b/drivers/net/wireless/iwlwifi/Makefile
index e31a5cc..cc4fe20 100644
--- a/drivers/net/wireless/iwlwifi/Makefile
+++ b/drivers/net/wireless/iwlwifi/Makefile
@@ -10,6 +10,7 @@ CFLAGS_iwl-devtrace.o := -I$(src)
 # AGN
 obj-$(CONFIG_IWLAGN)	+= iwlagn.o
 iwlagn-objs		:= iwl-agn.o iwl-agn-rs.o iwl-agn-led.o iwl-agn-ict.o
+iwlagn-objs		+= iwl-agn-ucode.o
 
 iwlagn-$(CONFIG_IWL4965) += iwl-4965.o
 iwlagn-$(CONFIG_IWL5000) += iwl-5000.o
diff --git a/drivers/net/wireless/iwlwifi/iwl-1000.c b/drivers/net/wireless/iwlwifi/iwl-1000.c
index 9e39289..ad61464 100644
--- a/drivers/net/wireless/iwlwifi/iwl-1000.c
+++ b/drivers/net/wireless/iwlwifi/iwl-1000.c
@@ -218,7 +218,7 @@ static struct iwl_lib_ops iwl1000_lib = {
 };
 
 static const struct iwl_ops iwl1000_ops = {
-	.ucode = &iwl5000_ucode,
+	.ucode = &iwlagn_ucode,
 	.lib = &iwl1000_lib,
 	.hcmd = &iwl5000_hcmd,
 	.utils = &iwl5000_hcmd_utils,
diff --git a/drivers/net/wireless/iwlwifi/iwl-5000.c b/drivers/net/wireless/iwlwifi/iwl-5000.c
index 2267cad..bbcb9c5 100644
--- a/drivers/net/wireless/iwlwifi/iwl-5000.c
+++ b/drivers/net/wireless/iwlwifi/iwl-5000.c
@@ -1348,45 +1348,6 @@ static int iwl5000_send_tx_ant_config(struct iwl_priv *priv, u8 valid_tx_ant)
 	}
 }
 
-
-#define IWL5000_UCODE_GET(item)						\
-static u32 iwl5000_ucode_get_##item(const struct iwl_ucode_header *ucode,\
-				    u32 api_ver)			\
-{									\
-	if (api_ver <= 2)						\
-		return le32_to_cpu(ucode->u.v1.item);			\
-	return le32_to_cpu(ucode->u.v2.item);				\
-}
-
-static u32 iwl5000_ucode_get_header_size(u32 api_ver)
-{
-	if (api_ver <= 2)
-		return UCODE_HEADER_SIZE(1);
-	return UCODE_HEADER_SIZE(2);
-}
-
-static u32 iwl5000_ucode_get_build(const struct iwl_ucode_header *ucode,
-				   u32 api_ver)
-{
-	if (api_ver <= 2)
-		return 0;
-	return le32_to_cpu(ucode->u.v2.build);
-}
-
-static u8 *iwl5000_ucode_get_data(const struct iwl_ucode_header *ucode,
-				  u32 api_ver)
-{
-	if (api_ver <= 2)
-		return (u8 *) ucode->u.v1.data;
-	return (u8 *) ucode->u.v2.data;
-}
-
-IWL5000_UCODE_GET(inst_size);
-IWL5000_UCODE_GET(data_size);
-IWL5000_UCODE_GET(init_size);
-IWL5000_UCODE_GET(init_data_size);
-IWL5000_UCODE_GET(boot_size);
-
 static int iwl5000_hw_channel_switch(struct iwl_priv *priv, u16 channel)
 {
 	struct iwl5000_channel_switch_cmd cmd;
@@ -1435,17 +1396,6 @@ struct iwl_hcmd_utils_ops iwl5000_hcmd_utils = {
 	.calc_rssi = iwl5000_calc_rssi,
 };
 
-struct iwl_ucode_ops iwl5000_ucode = {
-	.get_header_size = iwl5000_ucode_get_header_size,
-	.get_build = iwl5000_ucode_get_build,
-	.get_inst_size = iwl5000_ucode_get_inst_size,
-	.get_data_size = iwl5000_ucode_get_data_size,
-	.get_init_size = iwl5000_ucode_get_init_size,
-	.get_init_data_size = iwl5000_ucode_get_init_data_size,
-	.get_boot_size = iwl5000_ucode_get_boot_size,
-	.get_data = iwl5000_ucode_get_data,
-};
-
 struct iwl_lib_ops iwl5000_lib = {
 	.set_hw_params = iwl5000_hw_set_hw_params,
 	.txq_update_byte_cnt_tbl = iwl5000_txq_update_byte_cnt_tbl,
@@ -1562,7 +1512,7 @@ static struct iwl_lib_ops iwl5150_lib = {
 };
 
 static const struct iwl_ops iwl5000_ops = {
-	.ucode = &iwl5000_ucode,
+	.ucode = &iwlagn_ucode,
 	.lib = &iwl5000_lib,
 	.hcmd = &iwl5000_hcmd,
 	.utils = &iwl5000_hcmd_utils,
@@ -1570,7 +1520,7 @@ static const struct iwl_ops iwl5000_ops = {
 };
 
 static const struct iwl_ops iwl5150_ops = {
-	.ucode = &iwl5000_ucode,
+	.ucode = &iwlagn_ucode,
 	.lib = &iwl5150_lib,
 	.hcmd = &iwl5000_hcmd,
 	.utils = &iwl5000_hcmd_utils,
diff --git a/drivers/net/wireless/iwlwifi/iwl-6000.c b/drivers/net/wireless/iwlwifi/iwl-6000.c
index d757999..4026eb4 100644
--- a/drivers/net/wireless/iwlwifi/iwl-6000.c
+++ b/drivers/net/wireless/iwlwifi/iwl-6000.c
@@ -284,7 +284,7 @@ static struct iwl_lib_ops iwl6000_lib = {
 };
 
 static const struct iwl_ops iwl6000_ops = {
-	.ucode = &iwl5000_ucode,
+	.ucode = &iwlagn_ucode,
 	.lib = &iwl6000_lib,
 	.hcmd = &iwl5000_hcmd,
 	.utils = &iwl5000_hcmd_utils,
@@ -352,7 +352,7 @@ static struct iwl_lib_ops iwl6050_lib = {
 };
 
 static const struct iwl_ops iwl6050_ops = {
-	.ucode = &iwl5000_ucode,
+	.ucode = &iwlagn_ucode,
 	.lib = &iwl6050_lib,
 	.hcmd = &iwl5000_hcmd,
 	.utils = &iwl5000_hcmd_utils,
diff --git a/drivers/net/wireless/iwlwifi/iwl-agn-ucode.c b/drivers/net/wireless/iwlwifi/iwl-agn-ucode.c
new file mode 100644
index 0000000..67f15c0
--- /dev/null
+++ b/drivers/net/wireless/iwlwifi/iwl-agn-ucode.c
@@ -0,0 +1,84 @@
+/******************************************************************************
+ *
+ * GPL LICENSE SUMMARY
+ *
+ * Copyright(c) 2008 - 2010 Intel Corporation. All rights reserved.
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of version 2 of the GNU General Public License as
+ * published by the Free Software Foundation.
+ *
+ * This program is distributed in the hope that it will be useful, but
+ * WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
+ * General Public License for more details.
+ *
+ * You should have received a copy of the GNU General Public License
+ * along with this program; if not, write to the Free Software
+ * Foundation, Inc., 51 Franklin Street, Fifth Floor, Boston, MA 02110,
+ * USA
+ *
+ * The full GNU General Public License is included in this distribution
+ * in the file called LICENSE.GPL.
+ *
+ * Contact Information:
+ *  Intel Linux Wireless <ilw@linux.intel.com>
+ * Intel Corporation, 5200 N.E. Elam Young Parkway, Hillsboro, OR 97124-6497
+ *
+ *****************************************************************************/
+
+#include <linux/kernel.h>
+#include <linux/module.h>
+#include <linux/init.h>
+
+#include "iwl-dev.h"
+#include "iwl-core.h"
+
+#define IWL_UCODE_GET(item)						\
+static u32 iwlagn_ucode_get_##item(const struct iwl_ucode_header *ucode,\
+				    u32 api_ver)			\
+{									\
+	if (api_ver <= 2)						\
+		return le32_to_cpu(ucode->u.v1.item);			\
+	return le32_to_cpu(ucode->u.v2.item);				\
+}
+
+static u32 iwlagn_ucode_get_header_size(u32 api_ver)
+{
+	if (api_ver <= 2)
+		return UCODE_HEADER_SIZE(1);
+	return UCODE_HEADER_SIZE(2);
+}
+
+static u32 iwlagn_ucode_get_build(const struct iwl_ucode_header *ucode,
+				   u32 api_ver)
+{
+	if (api_ver <= 2)
+		return 0;
+	return le32_to_cpu(ucode->u.v2.build);
+}
+
+static u8 *iwlagn_ucode_get_data(const struct iwl_ucode_header *ucode,
+				  u32 api_ver)
+{
+	if (api_ver <= 2)
+		return (u8 *) ucode->u.v1.data;
+	return (u8 *) ucode->u.v2.data;
+}
+
+IWL_UCODE_GET(inst_size);
+IWL_UCODE_GET(data_size);
+IWL_UCODE_GET(init_size);
+IWL_UCODE_GET(init_data_size);
+IWL_UCODE_GET(boot_size);
+
+struct iwl_ucode_ops iwlagn_ucode = {
+	.get_header_size = iwlagn_ucode_get_header_size,
+	.get_build = iwlagn_ucode_get_build,
+	.get_inst_size = iwlagn_ucode_get_inst_size,
+	.get_data_size = iwlagn_ucode_get_data_size,
+	.get_init_size = iwlagn_ucode_get_init_size,
+	.get_init_data_size = iwlagn_ucode_get_init_data_size,
+	.get_boot_size = iwlagn_ucode_get_boot_size,
+	.get_data = iwlagn_ucode_get_data,
+};
diff --git a/drivers/net/wireless/iwlwifi/iwl-agn.h b/drivers/net/wireless/iwlwifi/iwl-agn.h
index 42c291b..a266649 100644
--- a/drivers/net/wireless/iwlwifi/iwl-agn.h
+++ b/drivers/net/wireless/iwlwifi/iwl-agn.h
@@ -65,6 +65,8 @@
 
 #include "iwl-dev.h"
 
+extern struct iwl_ucode_ops iwlagn_ucode;
+
 int iwl_reset_ict(struct iwl_priv *priv);
 void iwl_disable_ict(struct iwl_priv *priv);
 int iwl_alloc_isr_ict(struct iwl_priv *priv);
-- 
1.6.3.3

