Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga01.intel.com ([192.55.52.88]:22587 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752667AbYIQCOb (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 16 Sep 2008 22:14:31 -0400
From: Zhu Yi <yi.zhu@intel.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org,
	Emmanuel Grumbach <emmanuel.grumbach@intel.com>,
	Zhu Yi <yi.zhu@intel.com>
Subject: [PATCH] iwlwifi: remove HT flags from RXON when not in HT anymore
Date: Wed, 17 Sep 2008 10:10:05 +0800
Message-Id: <1221617405-14583-1-git-send-email-yi.zhu@intel.com> (sfid-20080917_041458_867336_C6FEBD5E)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Emmanuel Grumbach <emmanuel.grumbach@intel.com>

This patch removes the HT flags from RXON when moving from HT to legacy.
This avoids keeping those flags set and possibly miss configuring firmware.

If we are configured in HT, fat channel: channel 1 above, and move later
to legacy channel 11, we need to clear the FAT channel control flags in
RXON. If we don't, the firmware will understand this as channel 11 above
which is not possible due to regulatory constraints, leading to firmware
crash.

Signed-off-by: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
Reviewed-by: Tomas Winkler <tomas.winkler@intel.com>
Signed-off-by: Zhu Yi <yi.zhu@intel.com>
---
 drivers/net/wireless/iwlwifi/iwl-agn.c  |    3 +--
 drivers/net/wireless/iwlwifi/iwl-core.c |    8 +++++++-
 2 files changed, 8 insertions(+), 3 deletions(-)

diff --git a/drivers/net/wireless/iwlwifi/iwl-agn.c b/drivers/net/wireless/iwlwifi/iwl-agn.c
index 2652672..c31adf6 100644
--- a/drivers/net/wireless/iwlwifi/iwl-agn.c
+++ b/drivers/net/wireless/iwlwifi/iwl-agn.c
@@ -2504,8 +2504,7 @@ static void iwl4965_post_associate(struct iwl_priv *priv)
 
 	priv->staging_rxon.filter_flags |= RXON_FILTER_ASSOC_MSK;
 
-	if (priv->current_ht_config.is_ht)
-		iwl_set_rxon_ht(priv, &priv->current_ht_config);
+	iwl_set_rxon_ht(priv, &priv->current_ht_config);
 
 	iwl_set_rxon_chain(priv);
 	priv->staging_rxon.assoc_id = cpu_to_le16(priv->assoc_id);
diff --git a/drivers/net/wireless/iwlwifi/iwl-core.c b/drivers/net/wireless/iwlwifi/iwl-core.c
index 8203887..4c312c5 100644
--- a/drivers/net/wireless/iwlwifi/iwl-core.c
+++ b/drivers/net/wireless/iwlwifi/iwl-core.c
@@ -646,8 +646,14 @@ void iwl_set_rxon_ht(struct iwl_priv *priv, struct iwl_ht_info *ht_info)
 	struct iwl_rxon_cmd *rxon = &priv->staging_rxon;
 	u32 val;
 
-	if (!ht_info->is_ht)
+	if (!ht_info->is_ht) {
+		rxon->flags &= ~(RXON_FLG_CHANNEL_MODE_MIXED_MSK |
+			RXON_FLG_CHANNEL_MODE_PURE_40_MSK |
+			RXON_FLG_CTRL_CHANNEL_LOC_HI_MSK |
+			RXON_FLG_FAT_PROT_MSK |
+			RXON_FLG_HT_PROT_MSK);
 		return;
+	}
 
 	/* Set up channel bandwidth:  20 MHz only, or 20/40 mixed if fat ok */
 	if (iwl_is_fat_tx_allowed(priv, NULL))
-- 
1.5.3.6

