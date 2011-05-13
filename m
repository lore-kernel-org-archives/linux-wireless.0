Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga03.intel.com ([143.182.124.21]:53515 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756686Ab1EMTiq (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 13 May 2011 15:38:46 -0400
From: Wey-Yi Guy <wey-yi.w.guy@intel.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org,
	ipw3945-devel@lists.sourceforge.net,
	Wey-Yi Guy <wey-yi.w.guy@intel.com>
Subject: [PATCH 13/13] iwlagn: remove unused old_assoc parameter
Date: Fri, 13 May 2011 12:13:30 -0700
Message-Id: <1305314010-18073-14-git-send-email-wey-yi.w.guy@intel.com> (sfid-20110513_213852_070295_CCEA1BF5)
In-Reply-To: <1305314010-18073-1-git-send-email-wey-yi.w.guy@intel.com>
References: <1305314010-18073-1-git-send-email-wey-yi.w.guy@intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

old_assoc not used, remove it

Signed-off-by: Wey-Yi Guy <wey-yi.w.guy@intel.com>
---
 drivers/net/wireless/iwlwifi/iwl-agn-rxon.c |    1 -
 1 files changed, 0 insertions(+), 1 deletions(-)

diff --git a/drivers/net/wireless/iwlwifi/iwl-agn-rxon.c b/drivers/net/wireless/iwlwifi/iwl-agn-rxon.c
index 7d40e2d..a95ad84 100644
--- a/drivers/net/wireless/iwlwifi/iwl-agn-rxon.c
+++ b/drivers/net/wireless/iwlwifi/iwl-agn-rxon.c
@@ -289,7 +289,6 @@ int iwlagn_commit_rxon(struct iwl_priv *priv, struct iwl_rxon_context *ctx)
 	/* cast away the const for active_rxon in this function */
 	struct iwl_rxon_cmd *active = (void *)&ctx->active;
 	bool new_assoc = !!(ctx->staging.filter_flags & RXON_FILTER_ASSOC_MSK);
-	bool old_assoc = !!(ctx->active.filter_flags & RXON_FILTER_ASSOC_MSK);
 	int ret;
 
 	lockdep_assert_held(&priv->mutex);
-- 
1.7.0.4

