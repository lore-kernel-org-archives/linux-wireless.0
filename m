Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga02.intel.com ([134.134.136.20]:65350 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755782Ab0EJW21 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 10 May 2010 18:28:27 -0400
From: Reinette Chatre <reinette.chatre@intel.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org,
	ipw3945-devel@lists.sourceforge.net,
	Johannes Berg <johannes.berg@intel.com>,
	Reinette Chatre <reinette.chatre@intel.com>
Subject: [PATCH 27/47] iwlwifi: apply filter flags directly
Date: Mon, 10 May 2010 15:27:58 -0700
Message-Id: <1273530498-11876-28-git-send-email-reinette.chatre@intel.com>
In-Reply-To: <1273530498-11876-1-git-send-email-reinette.chatre@intel.com>
References: <1273530498-11876-1-git-send-email-reinette.chatre@intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Johannes Berg <johannes.berg@intel.com>

Since iwl_configure_filter can now sleep since
the mac80211 callback was changed, we can now
apply filter flags changes directly.

Also, while at it, make the code a bit more
generic with a local macro. There's no need
to check changed_flags since we apply all at
the same time anyway.

Signed-off-by: Johannes Berg <johannes.berg@intel.com>
Signed-off-by: Reinette Chatre <reinette.chatre@intel.com>
---
 drivers/net/wireless/iwlwifi/iwl-core.c |   52 +++++++++++++------------------
 1 files changed, 22 insertions(+), 30 deletions(-)

diff --git a/drivers/net/wireless/iwlwifi/iwl-core.c b/drivers/net/wireless/iwlwifi/iwl-core.c
index 5c6f254..246538a 100644
--- a/drivers/net/wireless/iwlwifi/iwl-core.c
+++ b/drivers/net/wireless/iwlwifi/iwl-core.c
@@ -1257,41 +1257,33 @@ void iwl_configure_filter(struct ieee80211_hw *hw,
 			  u64 multicast)
 {
 	struct iwl_priv *priv = hw->priv;
-	__le32 *filter_flags = &priv->staging_rxon.filter_flags;
+	__le32 filter_or = 0, filter_nand = 0;
+
+#define CHK(test, flag)	do { \
+	if (*total_flags & (test))		\
+		filter_or |= (flag);		\
+	else					\
+		filter_nand |= (flag);		\
+	} while (0)
 
 	IWL_DEBUG_MAC80211(priv, "Enter: changed: 0x%x, total: 0x%x\n",
 			changed_flags, *total_flags);
 
-	if (changed_flags & (FIF_OTHER_BSS | FIF_PROMISC_IN_BSS)) {
-		if (*total_flags & (FIF_OTHER_BSS | FIF_PROMISC_IN_BSS))
-			*filter_flags |= RXON_FILTER_PROMISC_MSK;
-		else
-			*filter_flags &= ~RXON_FILTER_PROMISC_MSK;
-	}
-	if (changed_flags & FIF_ALLMULTI) {
-		if (*total_flags & FIF_ALLMULTI)
-			*filter_flags |= RXON_FILTER_ACCEPT_GRP_MSK;
-		else
-			*filter_flags &= ~RXON_FILTER_ACCEPT_GRP_MSK;
-	}
-	if (changed_flags & FIF_CONTROL) {
-		if (*total_flags & FIF_CONTROL)
-			*filter_flags |= RXON_FILTER_CTL2HOST_MSK;
-		else
-			*filter_flags &= ~RXON_FILTER_CTL2HOST_MSK;
-	}
-	if (changed_flags & FIF_BCN_PRBRESP_PROMISC) {
-		if (*total_flags & FIF_BCN_PRBRESP_PROMISC)
-			*filter_flags |= RXON_FILTER_BCON_AWARE_MSK;
-		else
-			*filter_flags &= ~RXON_FILTER_BCON_AWARE_MSK;
-	}
+	CHK(FIF_OTHER_BSS | FIF_PROMISC_IN_BSS, RXON_FILTER_PROMISC_MSK);
+	CHK(FIF_ALLMULTI, RXON_FILTER_ACCEPT_GRP_MSK);
+	CHK(FIF_CONTROL, RXON_FILTER_CTL2HOST_MSK);
+	CHK(FIF_BCN_PRBRESP_PROMISC, RXON_FILTER_BCON_AWARE_MSK);
 
-	/* We avoid iwl_commit_rxon here to commit the new filter flags
-	 * since mac80211 will call ieee80211_hw_config immediately.
-	 * (mc_list is not supported at this time). Otherwise, we need to
-	 * queue a background iwl_commit_rxon work.
-	 */
+#undef CHK
+
+	mutex_lock(&priv->mutex);
+
+	priv->staging_rxon.filter_flags &= ~filter_nand;
+	priv->staging_rxon.filter_flags |= filter_or;
+
+	iwlcore_commit_rxon(priv);
+
+	mutex_unlock(&priv->mutex);
 
 	*total_flags &= FIF_OTHER_BSS | FIF_ALLMULTI | FIF_PROMISC_IN_BSS |
 			FIF_BCN_PRBRESP_PROMISC | FIF_CONTROL;
-- 
1.6.3.3

