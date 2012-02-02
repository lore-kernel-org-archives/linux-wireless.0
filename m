Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga11.intel.com ([192.55.52.93]:22467 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753848Ab2BCAQv (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 2 Feb 2012 19:16:51 -0500
From: Wey-Yi Guy <wey-yi.w.guy@intel.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org,
	Emmanuel Grumbach <emmanuel.grumbach@intel.com>,
	Wey-Yi Guy <wey-yi.w.guy@intel.com>
Subject: [PATCH 03/28] iwlwifi: separate the APM from the EEPROM
Date: Thu,  2 Feb 2012 15:08:54 -0800
Message-Id: <1328224159-18134-4-git-send-email-wey-yi.w.guy@intel.com> (sfid-20120203_011745_221513_9AE4639F)
In-Reply-To: <1328224159-18134-1-git-send-email-wey-yi.w.guy@intel.com>
References: <1328224159-18134-1-git-send-email-wey-yi.w.guy@intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Emmanuel Grumbach <emmanuel.grumbach@intel.com>

There is no link between the two. Ensure that the NIC is on outside
the code of the EEPROM handling.

Signed-off-by: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
Signed-off-by: Wey-Yi Guy <wey-yi.w.guy@intel.com>
---
 drivers/net/wireless/iwlwifi/iwl-agn.c    |    4 ++++
 drivers/net/wireless/iwlwifi/iwl-eeprom.c |    4 ----
 2 files changed, 4 insertions(+), 4 deletions(-)

diff --git a/drivers/net/wireless/iwlwifi/iwl-agn.c b/drivers/net/wireless/iwlwifi/iwl-agn.c
index 9d9185f..f3bd6a3 100644
--- a/drivers/net/wireless/iwlwifi/iwl-agn.c
+++ b/drivers/net/wireless/iwlwifi/iwl-agn.c
@@ -1848,8 +1848,12 @@ int iwl_probe(struct iwl_bus *bus, const struct iwl_trans_ops *trans_ops,
 	/*****************
 	 * 4. Read EEPROM
 	 *****************/
+	/* switch the NIC on before accessing the EEPROM */
+	iwl_apm_init(priv);
 	/* Read the EEPROM */
 	err = iwl_eeprom_init(priv, hw_rev);
+	/* Reset chip to save power until we load uCode during "up". */
+	iwl_apm_stop(priv);
 	if (err) {
 		IWL_ERR(priv, "Unable to init EEPROM\n");
 		goto out_free_trans;
diff --git a/drivers/net/wireless/iwlwifi/iwl-eeprom.c b/drivers/net/wireless/iwlwifi/iwl-eeprom.c
index e27d9f5..ce214e0 100644
--- a/drivers/net/wireless/iwlwifi/iwl-eeprom.c
+++ b/drivers/net/wireless/iwlwifi/iwl-eeprom.c
@@ -676,8 +676,6 @@ int iwl_eeprom_init(struct iwl_priv *priv, u32 hw_rev)
 	}
 	e = (__le16 *)shrd->eeprom;
 
-	iwl_apm_init(priv);
-
 	ret = iwl_eeprom_verify_signature(trans(priv));
 	if (ret < 0) {
 		IWL_ERR(priv, "EEPROM not found, EEPROM_GP=0x%08x\n", gp);
@@ -758,8 +756,6 @@ done:
 err:
 	if (ret)
 		iwl_eeprom_free(priv->shrd);
-	/* Reset chip to save power until we load uCode during "up". */
-	iwl_apm_stop(priv);
 alloc_err:
 	return ret;
 }
-- 
1.7.0.4

