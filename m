Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga01.intel.com ([192.55.52.88]:2067 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752895Ab1HZGxi (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 26 Aug 2011 02:53:38 -0400
From: Wey-Yi Guy <wey-yi.w.guy@intel.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org, Wey-Yi Guy <wey-yi.w.guy@intel.com>
Subject: [PATCH 45/60] iwlagn: adding special "D" SKU for 2000 series
Date: Thu, 25 Aug 2011 23:11:17 -0700
Message-Id: <1314339092-20797-46-git-send-email-wey-yi.w.guy@intel.com> (sfid-20110826_085414_920098_E0DC9B5C)
In-Reply-To: <1314339092-20797-1-git-send-email-wey-yi.w.guy@intel.com>
References: <1314339092-20797-1-git-send-email-wey-yi.w.guy@intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

One more sku for 2000 series with different Subsystem ID

Signed-off-by: Wey-Yi Guy <wey-yi.w.guy@intel.com>
---
 drivers/net/wireless/iwlwifi/iwl-2000.c |    5 +++++
 drivers/net/wireless/iwlwifi/iwl-pci.c  |    1 +
 drivers/net/wireless/iwlwifi/iwl-pci.h  |    1 +
 3 files changed, 7 insertions(+), 0 deletions(-)

diff --git a/drivers/net/wireless/iwlwifi/iwl-2000.c b/drivers/net/wireless/iwlwifi/iwl-2000.c
index 75ded34..764d310 100644
--- a/drivers/net/wireless/iwlwifi/iwl-2000.c
+++ b/drivers/net/wireless/iwlwifi/iwl-2000.c
@@ -282,6 +282,11 @@ struct iwl_cfg iwl2000_2bg_cfg = {
 	IWL_DEVICE_2000,
 };
 
+struct iwl_cfg iwl2000_2bgn_d_cfg = {
+	.name = "2000D Series 2x2 BGN",
+	IWL_DEVICE_2000,
+};
+
 #define IWL_DEVICE_2030						\
 	.fw_name_pre = IWL2030_FW_PRE,				\
 	.ucode_api_max = IWL2030_UCODE_API_MAX,			\
diff --git a/drivers/net/wireless/iwlwifi/iwl-pci.c b/drivers/net/wireless/iwlwifi/iwl-pci.c
index 7210ff6..e41f53e 100644
--- a/drivers/net/wireless/iwlwifi/iwl-pci.c
+++ b/drivers/net/wireless/iwlwifi/iwl-pci.c
@@ -332,6 +332,7 @@ static DEFINE_PCI_DEVICE_TABLE(iwl_hw_card_ids) = {
 	{IWL_PCI_DEVICE(0x0890, 0x4026, iwl2000_2bg_cfg)},
 	{IWL_PCI_DEVICE(0x0891, 0x4226, iwl2000_2bg_cfg)},
 	{IWL_PCI_DEVICE(0x0890, 0x4426, iwl2000_2bg_cfg)},
+	{IWL_PCI_DEVICE(0x0890, 0x4822, iwl2000_2bgn_d_cfg)},
 
 /* 2x30 Series */
 	{IWL_PCI_DEVICE(0x0887, 0x4062, iwl2030_2bgn_cfg)},
diff --git a/drivers/net/wireless/iwlwifi/iwl-pci.h b/drivers/net/wireless/iwlwifi/iwl-pci.h
index be69276..c0aea9e 100644
--- a/drivers/net/wireless/iwlwifi/iwl-pci.h
+++ b/drivers/net/wireless/iwlwifi/iwl-pci.h
@@ -102,6 +102,7 @@ extern struct iwl_cfg iwl130_bgn_cfg;
 extern struct iwl_cfg iwl130_bg_cfg;
 extern struct iwl_cfg iwl2000_2bgn_cfg;
 extern struct iwl_cfg iwl2000_2bg_cfg;
+extern struct iwl_cfg iwl2000_2bgn_d_cfg;
 extern struct iwl_cfg iwl2030_2bgn_cfg;
 extern struct iwl_cfg iwl2030_2bg_cfg;
 extern struct iwl_cfg iwl6035_2agn_cfg;
-- 
1.7.0.4

