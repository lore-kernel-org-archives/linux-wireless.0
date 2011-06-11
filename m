Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga09.intel.com ([134.134.136.24]:1999 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758610Ab1FKOzn (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Sat, 11 Jun 2011 10:55:43 -0400
From: Wey-Yi Guy <wey-yi.w.guy@intel.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org,
	ipw3945-devel@lists.sourceforge.net,
	Wey-Yi Guy <wey-yi.w.guy@intel.com>
Subject: [PATCH 17/18] iwlagn: Sanity check for 11n capability
Date: Sat, 11 Jun 2011 07:25:51 -0700
Message-Id: <1307802352-16398-18-git-send-email-wey-yi.w.guy@intel.com> (sfid-20110611_165609_232607_5B8B9B90)
In-Reply-To: <1307802352-16398-1-git-send-email-wey-yi.w.guy@intel.com>
References: <1307802352-16398-1-git-send-email-wey-yi.w.guy@intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Make sure when we say 11n enable, we really support it.

Signed-off-by: Wey-Yi Guy <wey-yi.w.guy@intel.com>
---
 drivers/net/wireless/iwlwifi/iwl-agn-eeprom.c |    5 +++++
 1 files changed, 5 insertions(+), 0 deletions(-)

diff --git a/drivers/net/wireless/iwlwifi/iwl-agn-eeprom.c b/drivers/net/wireless/iwlwifi/iwl-agn-eeprom.c
index 512d8be..7745816 100644
--- a/drivers/net/wireless/iwlwifi/iwl-agn-eeprom.c
+++ b/drivers/net/wireless/iwlwifi/iwl-agn-eeprom.c
@@ -113,6 +113,11 @@ int iwl_eeprom_check_sku(struct iwl_priv *priv)
 	if (!priv->cfg->sku) {
 		/* not using sku overwrite */
 		priv->cfg->sku = iwl_eeprom_query16(priv, EEPROM_SKU_CAP);
+		if (priv->cfg->sku & EEPROM_SKU_CAP_11N_ENABLE &&
+		    !priv->cfg->ht_params) {
+			IWL_ERR(priv, "Invalid 11n configuration\n");
+			return -EINVAL;
+		}
 	}
 	if (!priv->cfg->sku) {
 		IWL_ERR(priv, "Invalid device sku\n");
-- 
1.7.0.4

