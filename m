Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga11.intel.com ([192.55.52.93]:33262 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752598AbYLSCpR (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 18 Dec 2008 21:45:17 -0500
From: Zhu Yi <yi.zhu@intel.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org,
	ipw3945-devel@lists.sourceforge.net,
	"Kolekar, Abhijeet" <abhijeet.kolekar@intel.com>,
	Zhu Yi <yi.zhu@intel.com>
Subject: [PATCH 19/43] iwl3945: replace iwl_3945_cfg with iwl_cfg
Date: Fri, 19 Dec 2008 10:37:19 +0800
Message-Id: <1229654263-21454-20-git-send-email-yi.zhu@intel.com> (sfid-20081219_034550_281547_A5237A18)
In-Reply-To: <1229654263-21454-19-git-send-email-yi.zhu@intel.com>
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
 <1229654263-21454-19-git-send-email-yi.zhu@intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Kolekar, Abhijeet <abhijeet.kolekar@intel.com>

The patch replaces iwl_3945_cfg with iwl_cfg for 3945.

Signed-off-by: Abhijeet Kolekar <abhijeet.kolekar@intel.com>
Signed-off-by: Zhu Yi <yi.zhu@intel.com>
---
 drivers/net/wireless/iwlwifi/iwl-3945.c     |    4 +-
 drivers/net/wireless/iwlwifi/iwl-3945.h     |    2 +-
 drivers/net/wireless/iwlwifi/iwl-core.h     |   30 ---------------------------
 drivers/net/wireless/iwlwifi/iwl3945-base.c |    2 +-
 4 files changed, 4 insertions(+), 34 deletions(-)

diff --git a/drivers/net/wireless/iwlwifi/iwl-3945.c b/drivers/net/wireless/iwlwifi/iwl-3945.c
index bb75eaf..528c094 100644
--- a/drivers/net/wireless/iwlwifi/iwl-3945.c
+++ b/drivers/net/wireless/iwlwifi/iwl-3945.c
@@ -2508,7 +2508,7 @@ void iwl3945_hw_cancel_deferred_work(struct iwl3945_priv *priv)
 	cancel_delayed_work(&priv->thermal_periodic);
 }
 
-static struct iwl_3945_cfg iwl3945_bg_cfg = {
+static struct iwl_cfg iwl3945_bg_cfg = {
 	.name = "3945BG",
 	.fw_name_pre = IWL3945_FW_PRE,
 	.ucode_api_max = IWL3945_UCODE_API_MAX,
@@ -2516,7 +2516,7 @@ static struct iwl_3945_cfg iwl3945_bg_cfg = {
 	.sku = IWL_SKU_G,
 };
 
-static struct iwl_3945_cfg iwl3945_abg_cfg = {
+static struct iwl_cfg iwl3945_abg_cfg = {
 	.name = "3945ABG",
 	.fw_name_pre = IWL3945_FW_PRE,
 	.ucode_api_max = IWL3945_UCODE_API_MAX,
diff --git a/drivers/net/wireless/iwlwifi/iwl-3945.h b/drivers/net/wireless/iwlwifi/iwl-3945.h
index 46bbd81..760482e 100644
--- a/drivers/net/wireless/iwlwifi/iwl-3945.h
+++ b/drivers/net/wireless/iwlwifi/iwl-3945.h
@@ -547,7 +547,7 @@ struct iwl3945_priv {
 	struct ieee80211_hw *hw;
 	struct ieee80211_channel *ieee_channels;
 	struct ieee80211_rate *ieee_rates;
-	struct iwl_3945_cfg *cfg; /* device configuration */
+	struct iwl_cfg *cfg; /* device configuration */
 
 	/* temporary frame storage list */
 	struct list_head free_frames;
diff --git a/drivers/net/wireless/iwlwifi/iwl-core.h b/drivers/net/wireless/iwlwifi/iwl-core.h
index a3cc43d..7c3a20a 100644
--- a/drivers/net/wireless/iwlwifi/iwl-core.h
+++ b/drivers/net/wireless/iwlwifi/iwl-core.h
@@ -205,36 +205,6 @@ struct iwl_cfg {
 	const struct iwl_mod_params *mod_params;
 };
 
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
 /***************************
  *   L i b                 *
  ***************************/
diff --git a/drivers/net/wireless/iwlwifi/iwl3945-base.c b/drivers/net/wireless/iwlwifi/iwl3945-base.c
index 2f1d434..6b6aceb 100644
--- a/drivers/net/wireless/iwlwifi/iwl3945-base.c
+++ b/drivers/net/wireless/iwlwifi/iwl3945-base.c
@@ -7735,7 +7735,7 @@ static int iwl3945_pci_probe(struct pci_dev *pdev, const struct pci_device_id *e
 	int err = 0;
 	struct iwl3945_priv *priv;
 	struct ieee80211_hw *hw;
-	struct iwl_3945_cfg *cfg = (struct iwl_3945_cfg *)(ent->driver_data);
+	struct iwl_cfg *cfg = (struct iwl_cfg *)(ent->driver_data);
 	unsigned long flags;
 	DECLARE_MAC_BUF(mac);
 
-- 
1.5.3.6

