Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga14.intel.com ([143.182.124.37]:40544 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S934737AbZGQQac (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 17 Jul 2009 12:30:32 -0400
From: Reinette Chatre <reinette.chatre@intel.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org,
	ipw3945-devel@lists.sourceforge.net,
	Wey-Yi Guy <wey-yi.w.guy@intel.com>,
	Reinette Chatre <reinette.chatre@intel.com>
Subject: [PATCH 08/14] iwlwifi: checking unknown HW type
Date: Fri, 17 Jul 2009 09:30:21 -0700
Message-Id: <1247848227-24031-9-git-send-email-reinette.chatre@intel.com>
In-Reply-To: <1247848227-24031-8-git-send-email-reinette.chatre@intel.com>
References: <1247848227-24031-1-git-send-email-reinette.chatre@intel.com>
 <1247848227-24031-2-git-send-email-reinette.chatre@intel.com>
 <1247848227-24031-3-git-send-email-reinette.chatre@intel.com>
 <1247848227-24031-4-git-send-email-reinette.chatre@intel.com>
 <1247848227-24031-5-git-send-email-reinette.chatre@intel.com>
 <1247848227-24031-6-git-send-email-reinette.chatre@intel.com>
 <1247848227-24031-7-git-send-email-reinette.chatre@intel.com>
 <1247848227-24031-8-git-send-email-reinette.chatre@intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Wey-Yi Guy <wey-yi.w.guy@intel.com>

When deciding NVM type, if the HW type is unknown, report error and exit
with -ENOENT. This check should prevent incorrect behavior by assuming
the wrong NVM type.

Signed-off-by: Wey-Yi Guy <wey-yi.w.guy@intel.com>
Signed-off-by: Reinette Chatre <reinette.chatre@intel.com>
---
 drivers/net/wireless/iwlwifi/iwl-eeprom.c |    6 +++++-
 1 files changed, 5 insertions(+), 1 deletions(-)

diff --git a/drivers/net/wireless/iwlwifi/iwl-eeprom.c b/drivers/net/wireless/iwlwifi/iwl-eeprom.c
index 7d7554a..51eed72 100644
--- a/drivers/net/wireless/iwlwifi/iwl-eeprom.c
+++ b/drivers/net/wireless/iwlwifi/iwl-eeprom.c
@@ -159,6 +159,9 @@ static int iwlcore_get_nvm_type(struct iwl_priv *priv)
 
 	/* OTP only valid for CP/PP and after */
 	switch (priv->hw_rev & CSR_HW_REV_TYPE_MSK) {
+	case CSR_HW_REV_TYPE_NONE:
+		IWL_ERR(priv, "Unknown hardware type\n");
+		return -ENOENT;
 	case CSR_HW_REV_TYPE_3945:
 	case CSR_HW_REV_TYPE_4965:
 	case CSR_HW_REV_TYPE_5300:
@@ -266,7 +269,8 @@ int iwl_eeprom_init(struct iwl_priv *priv)
 	u32 otpgp;
 
 	priv->nvm_device_type = iwlcore_get_nvm_type(priv);
-
+	if (priv->nvm_device_type == -ENOENT)
+		return -ENOENT;
 	/* allocate eeprom */
 	if (priv->nvm_device_type == NVM_DEVICE_TYPE_OTP)
 		priv->cfg->eeprom_size =
-- 
1.5.6.3

