Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga11.intel.com ([192.55.52.93]:14249 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932573Ab0DPVwo (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 16 Apr 2010 17:52:44 -0400
From: Reinette Chatre <reinette.chatre@intel.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org,
	ipw3945-devel@lists.sourceforge.net,
	Wey-Yi Guy <wey-yi.w.guy@intel.com>,
	Reinette Chatre <reinette.chatre@intel.com>
Subject: [PATCH 14/21] iwlwifi: PA type for 6000g2 series
Date: Fri, 16 Apr 2010 14:52:31 -0700
Message-Id: <1271454758-14351-15-git-send-email-reinette.chatre@intel.com>
In-Reply-To: <1271454758-14351-1-git-send-email-reinette.chatre@intel.com>
References: <1271454758-14351-1-git-send-email-reinette.chatre@intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Wey-Yi Guy <wey-yi.w.guy@intel.com>

For 6000g2 series of NICs, PA type is determined by uCode, driver do not
have to set the register for internal/external PA. It is a workaround
just for 6000 series NICs.

Signed-off-by: Wey-Yi Guy <wey-yi.w.guy@intel.com>
Signed-off-by: Reinette Chatre <reinette.chatre@intel.com>
---
 drivers/net/wireless/iwlwifi/iwl-6000.c |    4 ++--
 drivers/net/wireless/iwlwifi/iwl-agn.c  |    8 ++++----
 drivers/net/wireless/iwlwifi/iwl-dev.h  |    2 +-
 3 files changed, 7 insertions(+), 7 deletions(-)

diff --git a/drivers/net/wireless/iwlwifi/iwl-6000.c b/drivers/net/wireless/iwlwifi/iwl-6000.c
index 7b695e7..7da23d3 100644
--- a/drivers/net/wireless/iwlwifi/iwl-6000.c
+++ b/drivers/net/wireless/iwlwifi/iwl-6000.c
@@ -379,7 +379,7 @@ static const struct iwl_ops iwl6050_ops = {
 /*
  * "i": Internal configuration, use internal Power Amplifier
  */
-struct iwl_cfg iwl6000g2i_2agn_cfg = {
+struct iwl_cfg iwl6000g2_2agn_cfg = {
 	.name = "6000 Series 2x2 AGN Gen2",
 	.fw_name_pre = IWL6000G2_FW_PRE,
 	.ucode_api_max = IWL6000G2_UCODE_API_MAX,
@@ -397,7 +397,7 @@ struct iwl_cfg iwl6000g2i_2agn_cfg = {
 	.pll_cfg_val = 0,
 	.set_l0s = true,
 	.use_bsm = false,
-	.pa_type = IWL_PA_INTERNAL,
+	.pa_type = IWL_PA_SYSTEM,
 	.max_ll_items = OTP_MAX_LL_ITEMS_6x00,
 	.shadow_ram_support = true,
 	.ht_greenfield_support = true,
diff --git a/drivers/net/wireless/iwlwifi/iwl-agn.c b/drivers/net/wireless/iwlwifi/iwl-agn.c
index 8ac1546..1f3c5d5 100644
--- a/drivers/net/wireless/iwlwifi/iwl-agn.c
+++ b/drivers/net/wireless/iwlwifi/iwl-agn.c
@@ -3798,10 +3798,10 @@ static DEFINE_PCI_DEVICE_TABLE(iwl_hw_card_ids) = {
 	{IWL_PCI_DEVICE(0x4239, 0x1316, iwl6000i_2abg_cfg)},
 
 /* 6x00 Series Gen2 */
-	{IWL_PCI_DEVICE(0x0082, 0x1201, iwl6000g2i_2agn_cfg)},
-	{IWL_PCI_DEVICE(0x0082, 0x1301, iwl6000g2i_2agn_cfg)},
-	{IWL_PCI_DEVICE(0x0082, 0x1321, iwl6000g2i_2agn_cfg)},
-	{IWL_PCI_DEVICE(0x0085, 0x1311, iwl6000g2i_2agn_cfg)},
+	{IWL_PCI_DEVICE(0x0082, 0x1201, iwl6000g2_2agn_cfg)},
+	{IWL_PCI_DEVICE(0x0082, 0x1301, iwl6000g2_2agn_cfg)},
+	{IWL_PCI_DEVICE(0x0082, 0x1321, iwl6000g2_2agn_cfg)},
+	{IWL_PCI_DEVICE(0x0085, 0x1311, iwl6000g2_2agn_cfg)},
 
 /* 6x50 WiFi/WiMax Series */
 	{IWL_PCI_DEVICE(0x0087, 0x1301, iwl6050_2agn_cfg)},
diff --git a/drivers/net/wireless/iwlwifi/iwl-dev.h b/drivers/net/wireless/iwlwifi/iwl-dev.h
index ff4b47c..bdc60aa 100644
--- a/drivers/net/wireless/iwlwifi/iwl-dev.h
+++ b/drivers/net/wireless/iwlwifi/iwl-dev.h
@@ -58,7 +58,7 @@ extern struct iwl_cfg iwl5100_abg_cfg;
 extern struct iwl_cfg iwl5150_agn_cfg;
 extern struct iwl_cfg iwl5150_abg_cfg;
 extern struct iwl_cfg iwl6000i_2agn_cfg;
-extern struct iwl_cfg iwl6000g2i_2agn_cfg;
+extern struct iwl_cfg iwl6000g2_2agn_cfg;
 extern struct iwl_cfg iwl6000i_2abg_cfg;
 extern struct iwl_cfg iwl6000i_2bg_cfg;
 extern struct iwl_cfg iwl6000_3agn_cfg;
-- 
1.6.3.3

