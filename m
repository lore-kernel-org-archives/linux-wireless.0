Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga01.intel.com ([192.55.52.88]:7217 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752238Ab1HZGxd (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 26 Aug 2011 02:53:33 -0400
From: Wey-Yi Guy <wey-yi.w.guy@intel.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org, Wey-Yi Guy <wey-yi.w.guy@intel.com>
Subject: [PATCH 24/60] iwlagn: support small form factor SKU of 6205
Date: Thu, 25 Aug 2011 23:10:56 -0700
Message-Id: <1314339092-20797-25-git-send-email-wey-yi.w.guy@intel.com> (sfid-20110826_085459_355454_9E85A364)
In-Reply-To: <1314339092-20797-1-git-send-email-wey-yi.w.guy@intel.com>
References: <1314339092-20797-1-git-send-email-wey-yi.w.guy@intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Different subsystem ID

Signed-off-by: Wey-Yi Guy <wey-yi.w.guy@intel.com>
---
 drivers/net/wireless/iwlwifi/iwl-6000.c |    6 ++++++
 drivers/net/wireless/iwlwifi/iwl-agn.h  |    1 +
 drivers/net/wireless/iwlwifi/iwl-pci.c  |    1 +
 3 files changed, 8 insertions(+), 0 deletions(-)

diff --git a/drivers/net/wireless/iwlwifi/iwl-6000.c b/drivers/net/wireless/iwlwifi/iwl-6000.c
index 9487d9b..c2cba80 100644
--- a/drivers/net/wireless/iwlwifi/iwl-6000.c
+++ b/drivers/net/wireless/iwlwifi/iwl-6000.c
@@ -396,6 +396,12 @@ struct iwl_cfg iwl6005_2bg_cfg = {
 	IWL_DEVICE_6005,
 };
 
+struct iwl_cfg iwl6005_2agn_sff_cfg = {
+	.name = "Intel(R) Centrino(R) Advanced-N 6205S AGN",
+	IWL_DEVICE_6005,
+	.ht_params = &iwl6000_ht_params,
+};
+
 #define IWL_DEVICE_6030						\
 	.fw_name_pre = IWL6030_FW_PRE,				\
 	.ucode_api_max = IWL6000G2_UCODE_API_MAX,		\
diff --git a/drivers/net/wireless/iwlwifi/iwl-agn.h b/drivers/net/wireless/iwlwifi/iwl-agn.h
index ea2a5fe..d2fa77a 100644
--- a/drivers/net/wireless/iwlwifi/iwl-agn.h
+++ b/drivers/net/wireless/iwlwifi/iwl-agn.h
@@ -76,6 +76,7 @@ extern struct iwl_cfg iwl5150_abg_cfg;
 extern struct iwl_cfg iwl6005_2agn_cfg;
 extern struct iwl_cfg iwl6005_2abg_cfg;
 extern struct iwl_cfg iwl6005_2bg_cfg;
+extern struct iwl_cfg iwl6005_2agn_sff_cfg;
 extern struct iwl_cfg iwl1030_bgn_cfg;
 extern struct iwl_cfg iwl1030_bg_cfg;
 extern struct iwl_cfg iwl6030_2agn_cfg;
diff --git a/drivers/net/wireless/iwlwifi/iwl-pci.c b/drivers/net/wireless/iwlwifi/iwl-pci.c
index 4b99090..191c16a 100644
--- a/drivers/net/wireless/iwlwifi/iwl-pci.c
+++ b/drivers/net/wireless/iwlwifi/iwl-pci.c
@@ -260,6 +260,7 @@ static DEFINE_PCI_DEVICE_TABLE(iwl_hw_card_ids) = {
 	{IWL_PCI_DEVICE(0x0082, 0x1326, iwl6005_2abg_cfg)},
 	{IWL_PCI_DEVICE(0x0085, 0x1311, iwl6005_2agn_cfg)},
 	{IWL_PCI_DEVICE(0x0085, 0x1316, iwl6005_2abg_cfg)},
+	{IWL_PCI_DEVICE(0x0082, 0xC020, iwl6005_2agn_sff_cfg)},
 
 /* 6x30 Series */
 	{IWL_PCI_DEVICE(0x008A, 0x5305, iwl1030_bgn_cfg)},
-- 
1.7.0.4

