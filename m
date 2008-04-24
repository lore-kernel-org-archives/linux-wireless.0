Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga11.intel.com ([192.55.52.93]:51290 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754541AbYDXSzn (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 24 Apr 2008 14:55:43 -0400
From: Reinette Chatre <reinette.chatre@intel.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org,
	ipw3945-devel@lists.sourceforge.net,
	Tomas Winkler <tomas.winkler@intel.com>,
	Reinette Chatre <reinette.chatre@intel.com>
Subject: [PATCH 07/21] iwlwifi-5000: add ops infrastructure for 5000
Date: Thu, 24 Apr 2008 11:55:24 -0700
Message-Id: <1209063338-6572-8-git-send-email-reinette.chatre@intel.com> (sfid-20080424_205619_782029_6DA2AC3E)
In-Reply-To: <1209063338-6572-7-git-send-email-reinette.chatre@intel.com>
References: <1209063338-6572-1-git-send-email-reinette.chatre@intel.com>
 <1209063338-6572-2-git-send-email-reinette.chatre@intel.com>
 <1209063338-6572-3-git-send-email-reinette.chatre@intel.com>
 <1209063338-6572-4-git-send-email-reinette.chatre@intel.com>
 <1209063338-6572-5-git-send-email-reinette.chatre@intel.com>
 <1209063338-6572-6-git-send-email-reinette.chatre@intel.com>
 <1209063338-6572-7-git-send-email-reinette.chatre@intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Tomas Winkler <tomas.winkler@intel.com>

This patch adds handler framework for 5000 family HW

Signed-off-by: Tomas Winkler <tomas.winkler@intel.com>
Signed-off-by: Reinette Chatre <reinette.chatre@intel.com>
---
 drivers/net/wireless/iwlwifi/iwl-5000.c |   23 +++++++++++++++++++++++
 1 files changed, 23 insertions(+), 0 deletions(-)

diff --git a/drivers/net/wireless/iwlwifi/iwl-5000.c b/drivers/net/wireless/iwlwifi/iwl-5000.c
index 2314e31..3dd0b12 100644
--- a/drivers/net/wireless/iwlwifi/iwl-5000.c
+++ b/drivers/net/wireless/iwlwifi/iwl-5000.c
@@ -46,6 +46,26 @@
 
 #define IWL5000_UCODE_API  "-1"
 
+static struct iwl_hcmd_ops iwl5000_hcmd = {
+};
+
+static struct iwl_hcmd_utils_ops iwl5000_hcmd_utils = {
+};
+
+static struct iwl_lib_ops iwl5000_lib = {
+	.eeprom_ops = {
+		.verify_signature  = iwlcore_eeprom_verify_signature,
+		.acquire_semaphore = iwlcore_eeprom_acquire_semaphore,
+		.release_semaphore = iwlcore_eeprom_release_semaphore,
+	},
+};
+
+static struct iwl_ops iwl5000_ops = {
+	.lib = &iwl5000_lib,
+	.hcmd = &iwl5000_hcmd,
+	.utils = &iwl5000_hcmd_utils,
+};
+
 static struct iwl_mod_params iwl50_mod_params = {
 	.num_of_queues = IWL50_NUM_QUEUES,
 	.enable_qos = 1,
@@ -58,6 +78,7 @@ struct iwl_cfg iwl5300_agn_cfg = {
 	.name = "5300AGN",
 	.fw_name = "iwlwifi-5000" IWL5000_UCODE_API ".ucode",
 	.sku = IWL_SKU_A|IWL_SKU_G|IWL_SKU_N,
+	.ops = &iwl5000_ops,
 	.mod_params = &iwl50_mod_params,
 };
 
@@ -65,6 +86,7 @@ struct iwl_cfg iwl5100_agn_cfg = {
 	.name = "5100AGN",
 	.fw_name = "iwlwifi-5000" IWL5000_UCODE_API ".ucode",
 	.sku = IWL_SKU_A|IWL_SKU_G|IWL_SKU_N,
+	.ops = &iwl5000_ops,
 	.mod_params = &iwl50_mod_params,
 };
 
@@ -72,6 +94,7 @@ struct iwl_cfg iwl5350_agn_cfg = {
 	.name = "5350AGN",
 	.fw_name = "iwlwifi-5000" IWL5000_UCODE_API ".ucode",
 	.sku = IWL_SKU_A|IWL_SKU_G|IWL_SKU_N,
+	.ops = &iwl5000_ops,
 	.mod_params = &iwl50_mod_params,
 };
 
-- 
1.5.3.4

