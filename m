Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga02.intel.com ([134.134.136.20]:42648 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753397AbZFLUPw (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 12 Jun 2009 16:15:52 -0400
From: Reinette Chatre <reinette.chatre@intel.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org,
	ipw3945-devel@lists.sourceforge.net,
	Wey-Yi Guy <wey-yi.w.guy@intel.com>,
	Reinette Chatre <reinette.chatre@intel.com>
Subject: [PATCH 2/8 v2.6.31 and w-t ] iwlwifi: checking for 40MHz mode
Date: Fri, 12 Jun 2009 13:22:49 -0700
Message-Id: <1244838175-15491-3-git-send-email-reinette.chatre@intel.com>
In-Reply-To: <1244838175-15491-2-git-send-email-reinette.chatre@intel.com>
References: <1244838175-15491-1-git-send-email-reinette.chatre@intel.com>
 <1244838175-15491-2-git-send-email-reinette.chatre@intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Wey-Yi Guy <wey-yi.w.guy@intel.com>

when checking for 40MHz, compare ht_protection to
IEEE80211_HT_OP_MODE_PROTECTION_20MHZ. ht_protection is not a bit-mask
field

Signed-off-by: Wey-Yi Guy <wey-yi.w.guy@intel.com>
Signed-off-by: Reinette Chatre <reinette.chatre@intel.com>
---
 drivers/net/wireless/iwlwifi/iwl-core.c |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/net/wireless/iwlwifi/iwl-core.c b/drivers/net/wireless/iwlwifi/iwl-core.c
index e05faa0..b2875fe 100644
--- a/drivers/net/wireless/iwlwifi/iwl-core.c
+++ b/drivers/net/wireless/iwlwifi/iwl-core.c
@@ -630,7 +630,7 @@ u8 iwl_is_fat_tx_allowed(struct iwl_priv *priv,
 			return 0;
 	}
 
-	if (iwl_ht_conf->ht_protection & IEEE80211_HT_OP_MODE_PROTECTION_20MHZ)
+	if (iwl_ht_conf->ht_protection == IEEE80211_HT_OP_MODE_PROTECTION_20MHZ)
 		return 1;
 	else
 		return iwl_is_channel_extension(priv, priv->band,
@@ -826,7 +826,7 @@ void iwl_set_rxon_ht(struct iwl_priv *priv, struct iwl_ht_info *ht_info)
 			 RXON_FLG_CTRL_CHANNEL_LOC_HI_MSK);
 	if (iwl_is_fat_tx_allowed(priv, NULL)) {
 		/* pure 40 fat */
-		if (rxon->flags & RXON_FLG_FAT_PROT_MSK)
+		if (ht_info->ht_protection == IEEE80211_HT_OP_MODE_PROTECTION_20MHZ)
 			rxon->flags |= RXON_FLG_CHANNEL_MODE_PURE_40;
 		else {
 			/* Note: control channel is opposite of extension channel */
-- 
1.5.6.3

