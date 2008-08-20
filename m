Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga11.intel.com ([192.55.52.93]:3175 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751601AbYHTCFM (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 19 Aug 2008 22:05:12 -0400
From: Zhu Yi <yi.zhu@intel.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org,
	Mohamed Abbas <mohamed.abbas@intel.com>,
	Tomas Winkler <tomas.winkler@intel.com>,
	Zhu Yi <yi.zhu@intel.com>
Subject: [PATCH 6/7] iwlwifi: void full rxon on rx chain changes
Date: Wed, 20 Aug 2008 10:01:32 +0800
Message-Id: <1219197693-21407-7-git-send-email-yi.zhu@intel.com> (sfid-20080820_040517_927606_836B392C)
In-Reply-To: <1219197693-21407-6-git-send-email-yi.zhu@intel.com>
References: <1219197693-21407-1-git-send-email-yi.zhu@intel.com>
 <1219197693-21407-2-git-send-email-yi.zhu@intel.com>
 <1219197693-21407-3-git-send-email-yi.zhu@intel.com>
 <1219197693-21407-4-git-send-email-yi.zhu@intel.com>
 <1219197693-21407-5-git-send-email-yi.zhu@intel.com>
 <1219197693-21407-6-git-send-email-yi.zhu@intel.com>
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
index b6e4546..9c18b2f 100644
--- a/drivers/net/wireless/iwlwifi/iwl-agn.c
+++ b/drivers/net/wireless/iwlwifi/iwl-agn.c
@@ -182,14 +182,14 @@ static int iwl4965_check_rxon_cmd(struct iwl_rxon_cmd *rxon)
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
@@ -208,7 +208,6 @@ static int iwl4965_full_rxon_required(struct iwl_priv *priv)
 	     priv->active_rxon.ofdm_ht_single_stream_basic_rates) ||
 	    (priv->staging_rxon.ofdm_ht_dual_stream_basic_rates !=
 	     priv->active_rxon.ofdm_ht_dual_stream_basic_rates) ||
-	    (priv->staging_rxon.rx_chain != priv->active_rxon.rx_chain) ||
 	    (priv->staging_rxon.assoc_id != priv->active_rxon.assoc_id))
 		return 1;
 
@@ -264,7 +263,7 @@ static int iwl4965_commit_rxon(struct iwl_priv *priv)
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

