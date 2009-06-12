Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga02.intel.com ([134.134.136.20]:6527 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756855AbZFLUPx (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 12 Jun 2009 16:15:53 -0400
From: Reinette Chatre <reinette.chatre@intel.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org,
	ipw3945-devel@lists.sourceforge.net,
	Wey-Yi Guy <wey-yi.w.guy@intel.com>,
	Reinette Chatre <reinette.chatre@intel.com>
Subject: [PATCH 4/8 v2.6.31 and w-t ] iwlwifi: check for channel location for 40MHz
Date: Fri, 12 Jun 2009 13:22:51 -0700
Message-Id: <1244838175-15491-5-git-send-email-reinette.chatre@intel.com>
In-Reply-To: <1244838175-15491-4-git-send-email-reinette.chatre@intel.com>
References: <1244838175-15491-1-git-send-email-reinette.chatre@intel.com>
 <1244838175-15491-2-git-send-email-reinette.chatre@intel.com>
 <1244838175-15491-3-git-send-email-reinette.chatre@intel.com>
 <1244838175-15491-4-git-send-email-reinette.chatre@intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Wey-Yi Guy <wey-yi.w.guy@intel.com>

for both mixed and pure 40MHz, need to check for valid channel location.
if the specified channel not allow the channel location requested
(ABOVE, BELOW), then reject the Fat channel access

This fixes http://www.intellinuxwireless.org/bugzilla/show_bug.cgi?id=1988

Signed-off-by: Wey-Yi Guy <wey-yi.w.guy@intel.com>
Signed-off-by: Reinette Chatre <reinette.chatre@intel.com>
---
 drivers/net/wireless/iwlwifi/iwl-core.c |   10 +++-------
 1 files changed, 3 insertions(+), 7 deletions(-)

diff --git a/drivers/net/wireless/iwlwifi/iwl-core.c b/drivers/net/wireless/iwlwifi/iwl-core.c
index b122eed..6ab0716 100644
--- a/drivers/net/wireless/iwlwifi/iwl-core.c
+++ b/drivers/net/wireless/iwlwifi/iwl-core.c
@@ -629,13 +629,9 @@ u8 iwl_is_fat_tx_allowed(struct iwl_priv *priv,
 		if (!sta_ht_inf->ht_supported)
 			return 0;
 	}
-
-	if (iwl_ht_conf->ht_protection == IEEE80211_HT_OP_MODE_PROTECTION_20MHZ)
-		return 1;
-	else
-		return iwl_is_channel_extension(priv, priv->band,
-				le16_to_cpu(priv->staging_rxon.channel),
-				iwl_ht_conf->extension_chan_offset);
+	return iwl_is_channel_extension(priv, priv->band,
+			le16_to_cpu(priv->staging_rxon.channel),
+			iwl_ht_conf->extension_chan_offset);
 }
 EXPORT_SYMBOL(iwl_is_fat_tx_allowed);
 
-- 
1.5.6.3

