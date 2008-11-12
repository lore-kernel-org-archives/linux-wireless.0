Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga01.intel.com ([192.55.52.88]:26494 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751695AbYKLVNt (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 12 Nov 2008 16:13:49 -0500
From: Reinette Chatre <reinette.chatre@intel.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org,
	ipw3945-devel@lists.sourceforge.net,
	"Chatre, Reinette" <reinette.chatre@intel.com>,
	Harvey Harrison <harvey.harrison@gmail.com>
Subject: [PATCH 4/8] iwlwifi: replace magic constants with define
Date: Wed, 12 Nov 2008 13:14:07 -0800
Message-Id: <1226524451-3417-5-git-send-email-reinette.chatre@intel.com> (sfid-20081112_221356_354860_E33F7FD4)
In-Reply-To: <1226524451-3417-4-git-send-email-reinette.chatre@intel.com>
References: <>
 <1226524451-3417-1-git-send-email-reinette.chatre@intel.com>
 <1226524451-3417-2-git-send-email-reinette.chatre@intel.com>
 <1226524451-3417-3-git-send-email-reinette.chatre@intel.com>
 <1226524451-3417-4-git-send-email-reinette.chatre@intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Chatre, Reinette <reinette.chatre@intel.com>

use IWL_CCK_RATES_MASK and IWL_OFDM_RATES_MASK instead of
their values directly.

Signed-off-by: Reinette Chatre <reinette.chatre@intel.com>
cc: Harvey Harrison <harvey.harrison@gmail.com>
---
 drivers/net/wireless/iwlwifi/iwl-agn.c      |    4 ++--
 drivers/net/wireless/iwlwifi/iwl3945-base.c |    4 ++--
 2 files changed, 4 insertions(+), 4 deletions(-)

diff --git a/drivers/net/wireless/iwlwifi/iwl-agn.c b/drivers/net/wireless/iwlwifi/iwl-agn.c
index b69d77d..d02f82e 100644
--- a/drivers/net/wireless/iwlwifi/iwl-agn.c
+++ b/drivers/net/wireless/iwlwifi/iwl-agn.c
@@ -467,9 +467,9 @@ static u8 iwl_rate_get_lowest_plcp(struct iwl_priv *priv)
 
 	/* Set rate mask*/
 	if (priv->staging_rxon.flags & RXON_FLG_BAND_24G_MSK)
-		rate_mask = priv->active_rate_basic & 0xF;
+		rate_mask = priv->active_rate_basic & IWL_CCK_RATES_MASK;
 	else
-		rate_mask = priv->active_rate_basic & 0xFF0;
+		rate_mask = priv->active_rate_basic & IWL_OFDM_RATES_MASK;
 
 	/* Find lowest valid rate */
 	for (i = IWL_RATE_1M_INDEX; i != IWL_RATE_INVALID;
diff --git a/drivers/net/wireless/iwlwifi/iwl3945-base.c b/drivers/net/wireless/iwlwifi/iwl3945-base.c
index bf55f34..bee42ef 100644
--- a/drivers/net/wireless/iwlwifi/iwl3945-base.c
+++ b/drivers/net/wireless/iwlwifi/iwl3945-base.c
@@ -1427,9 +1427,9 @@ static u8 iwl3945_rate_get_lowest_plcp(struct iwl3945_priv *priv)
 
 	/* Set rate mask*/
 	if (priv->staging_rxon.flags & RXON_FLG_BAND_24G_MSK)
-		rate_mask = priv->active_rate_basic & 0xF;
+		rate_mask = priv->active_rate_basic & IWL_CCK_RATES_MASK;
 	else
-		rate_mask = priv->active_rate_basic & 0xFF0;
+		rate_mask = priv->active_rate_basic & IWL_OFDM_RATES_MASK;
 
 	for (i = IWL_RATE_1M_INDEX; i != IWL_RATE_INVALID;
 	     i = iwl3945_rates[i].next_ieee) {
-- 
1.5.4.3

