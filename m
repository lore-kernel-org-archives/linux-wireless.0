Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga09.intel.com ([134.134.136.24]:22294 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754079AbYICDWw (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 2 Sep 2008 23:22:52 -0400
From: Zhu Yi <yi.zhu@intel.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org,
	Mohamed Abbas <mohamed.abbas@intel.com>,
	Tomas Winkler <tomas.winkler@intel.com>,
	Zhu Yi <yi.zhu@intel.com>
Subject: [PATCH 3/9] iwlwifi: remove false rxon if rx chain changes
Date: Wed,  3 Sep 2008 11:18:44 +0800
Message-Id: <1220411930-15216-4-git-send-email-yi.zhu@intel.com> (sfid-20080903_052305_107571_8D1ABC0C)
In-Reply-To: <1220411930-15216-3-git-send-email-yi.zhu@intel.com>
References: <1220411930-15216-1-git-send-email-yi.zhu@intel.com>
 <1220411930-15216-2-git-send-email-yi.zhu@intel.com>
 <1220411930-15216-3-git-send-email-yi.zhu@intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Mohamed Abbas <mohamed.abbas@intel.com>

Rx chain might change during power save transitions but it doesn't
require sending Full-ROXN command to the firmware. Full-RXON requires
reconnection to an AP and thus affects user experience. The patch
avoids the Full-RXON by removing the rx_chain modification check in
iwl_full_rxon_required function.

Signed-off-by: Mohamed Abbas <mohamed.abbas@intel.com
Signed-off-by: Tomas Winkler <tomas.winkler@intel.com>
Signed-off-by: Zhu Yi <yi.zhu@intel.com>
---
 drivers/net/wireless/iwlwifi/iwl-agn.c |    7 +++----
 1 files changed, 3 insertions(+), 4 deletions(-)

diff --git a/drivers/net/wireless/iwlwifi/iwl-agn.c b/drivers/net/wireless/iwlwifi/iwl-agn.c
index 2afa1fb..a5feb0c 100644
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

