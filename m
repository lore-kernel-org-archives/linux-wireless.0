Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga01.intel.com ([192.55.52.88]:43814 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754640AbYICDbM (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 2 Sep 2008 23:31:12 -0400
From: Zhu Yi <yi.zhu@intel.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org,
	Mohamed Abbas <mohamed.abbas@intel.com>,
	Tomas Winkler <tomas.winkler@intel.com>,
	Zhu Yi <yi.zhu@intel.com>
Subject: [PATCH 13/39] iwlwifi: void full rxon on rx chain changes
Date: Wed,  3 Sep 2008 11:26:33 +0800
Message-Id: <1220412419-15404-14-git-send-email-yi.zhu@intel.com> (sfid-20080903_053121_605141_467267E1)
In-Reply-To: <1220412419-15404-13-git-send-email-yi.zhu@intel.com>
References: <1220412419-15404-1-git-send-email-yi.zhu@intel.com>
 <1220412419-15404-2-git-send-email-yi.zhu@intel.com>
 <1220412419-15404-3-git-send-email-yi.zhu@intel.com>
 <1220412419-15404-4-git-send-email-yi.zhu@intel.com>
 <1220412419-15404-5-git-send-email-yi.zhu@intel.com>
 <1220412419-15404-6-git-send-email-yi.zhu@intel.com>
 <1220412419-15404-7-git-send-email-yi.zhu@intel.com>
 <1220412419-15404-8-git-send-email-yi.zhu@intel.com>
 <1220412419-15404-9-git-send-email-yi.zhu@intel.com>
 <1220412419-15404-10-git-send-email-yi.zhu@intel.com>
 <1220412419-15404-11-git-send-email-yi.zhu@intel.com>
 <1220412419-15404-12-git-send-email-yi.zhu@intel.com>
 <1220412419-15404-13-git-send-email-yi.zhu@intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Mohamed Abbas <mohamed.abbas@intel.com>

Rx chain might change during power save transitions but it doesn't
requires full rxon.

Signed-off-by: Mohamed Abbas <mohamed.abbas@intel.com
Signed-off-by: Tomas Winkler <tomas.winkler@intel.com>
Signed-off-by: Zhu Yi <yi.zhu@intel.com>
---
 drivers/net/wireless/iwlwifi/iwl-agn.c |    7 +++----
 1 files changed, 3 insertions(+), 4 deletions(-)

diff --git a/drivers/net/wireless/iwlwifi/iwl-agn.c b/drivers/net/wireless/iwlwifi/iwl-agn.c
index d436f70..e903aeb 100644
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

