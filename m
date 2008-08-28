Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga09.intel.com ([134.134.136.24]:43471 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751530AbYH1J3H (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 28 Aug 2008 05:29:07 -0400
From: Zhu Yi <yi.zhu@intel.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org,
	Mohamed Abbas <mohamed.abbas@intel.com>,
	Tomas Winkler <tomas.winkler@intel.com>,
	Zhu Yi <yi.zhu@intel.com>
Subject: [PATCH 04/11] iwlwifi: remove false rxon if rx chain changes
Date: Thu, 28 Aug 2008 17:25:03 +0800
Message-Id: <1219915510-3647-5-git-send-email-yi.zhu@intel.com> (sfid-20080828_112914_669664_F8C51C0D)
In-Reply-To: <1219915510-3647-4-git-send-email-yi.zhu@intel.com>
References: <1219915510-3647-1-git-send-email-yi.zhu@intel.com>
 <1219915510-3647-2-git-send-email-yi.zhu@intel.com>
 <1219915510-3647-3-git-send-email-yi.zhu@intel.com>
 <1219915510-3647-4-git-send-email-yi.zhu@intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Mohamed Abbas <mohamed.abbas@intel.com>

Rx chain might change during power save transitions but it doesn't
requires full rxon. The patch avoids the rxon by removing the rx_chain
check.

Signed-off-by: Mohamed Abbas <mohamed.abbas@intel.com
Signed-off-by: Tomas Winkler <tomas.winkler@intel.com>
Signed-off-by: Zhu Yi <yi.zhu@intel.com>
---
 drivers/net/wireless/iwlwifi/iwl-agn.c |    7 +++----
 1 files changed, 3 insertions(+), 4 deletions(-)

diff --git a/drivers/net/wireless/iwlwifi/iwl-agn.c b/drivers/net/wireless/iwlwifi/iwl-agn.c
index 93af115..e35db85 100644
--- a/drivers/net/wireless/iwlwifi/iwl-agn.c
+++ b/drivers/net/wireless/iwlwifi/iwl-agn.c
@@ -181,14 +181,14 @@ static int iwl4965_check_rxon_cmd(struct iwl_rxon_cmd *rxon)
 }
 
 /**
- * iwl4965_full_rxon_required - check if full RXON (vs RXON_ASSOC) cmd is needed
+ * iwl_full_rxon_required - check if full RXON (vs RXON_ASSOC) cmd is needed
  * @priv: staging_rxon is compared to active_rxon
  *
  * If the RXON structure is changing enough to require a new tune,
  * or is clearing the RXON_FILTER_ASSOC_MSK, then return 1 to indicate that
  * a new tune (full RXON command, rather than RXON_ASSOC cmd) is required.
  */
-static int iwl4965_full_rxon_required(struct iwl_priv *priv)
+static int iwl_full_rxon_required(struct iwl_priv *priv)
 {
 
 	/* These items are only settable from the full RXON command */
@@ -207,7 +207,6 @@ static int iwl4965_full_rxon_required(struct iwl_priv *priv)
 	     priv->active_rxon.ofdm_ht_single_stream_basic_rates) ||
 	    (priv->staging_rxon.ofdm_ht_dual_stream_basic_rates !=
 	     priv->active_rxon.ofdm_ht_dual_stream_basic_rates) ||
-	    (priv->staging_rxon.rx_chain != priv->active_rxon.rx_chain) ||
 	    (priv->staging_rxon.assoc_id != priv->active_rxon.assoc_id))
 		return 1;
 
@@ -263,7 +262,7 @@ static int iwl4965_commit_rxon(struct iwl_priv *priv)
 	/* If we don't need to send a full RXON, we can use
 	 * iwl4965_rxon_assoc_cmd which is used to reconfigure filter
 	 * and other flags for the current radio configuration. */
-	if (!iwl4965_full_rxon_required(priv)) {
+	if (!iwl_full_rxon_required(priv)) {
 		ret = iwl_send_rxon_assoc(priv);
 		if (ret) {
 			IWL_ERROR("Error setting RXON_ASSOC (%d)\n", ret);
-- 
1.5.3.6

