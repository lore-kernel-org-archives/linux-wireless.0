Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga14.intel.com ([143.182.124.37]:4198 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754658AbZCFVsE (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 6 Mar 2009 16:48:04 -0500
From: Reinette Chatre <reinette.chatre@intel.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org,
	ipw3945-devel@lists.sourceforge.net,
	Abhijeet Kolekar <abhijeet.kolekar@intel.com>,
	Reinette Chatre <reinette.chatre@intel.com>
Subject: [PATCH 1/2] iwl3945: add test for new association
Date: Fri,  6 Mar 2009 13:52:54 -0800
Message-Id: <1236376375-27927-2-git-send-email-reinette.chatre@intel.com> (sfid-20090306_224807_433970_AFCAB17A)
In-Reply-To: <1236376375-27927-1-git-send-email-reinette.chatre@intel.com>
References: <1236376375-27927-1-git-send-email-reinette.chatre@intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Abhijeet Kolekar <abhijeet.kolekar@intel.com>

Add check for new association to ease reading.

Signed-off-by: Abhijeet Kolekar <abhijeet.kolekar@intel.com>
Signed-off-by: Reinette Chatre <reinette.chatre@intel.com>
---
 drivers/net/wireless/iwlwifi/iwl3945-base.c |    8 ++++----
 1 files changed, 4 insertions(+), 4 deletions(-)

diff --git a/drivers/net/wireless/iwlwifi/iwl3945-base.c b/drivers/net/wireless/iwlwifi/iwl3945-base.c
index f75309c..e5c6295 100644
--- a/drivers/net/wireless/iwlwifi/iwl3945-base.c
+++ b/drivers/net/wireless/iwlwifi/iwl3945-base.c
@@ -328,6 +328,8 @@ static int iwl3945_commit_rxon(struct iwl_priv *priv)
 	struct iwl3945_rxon_cmd *active_rxon = (void *)&priv->active_rxon;
 	struct iwl3945_rxon_cmd *staging_rxon = (void *)&priv->staging_rxon;
 	int rc = 0;
+	bool new_assoc =
+		!!(priv->staging_rxon.filter_flags & RXON_FILTER_ASSOC_MSK);
 
 	if (!iwl_is_alive(priv))
 		return -1;
@@ -366,8 +368,7 @@ static int iwl3945_commit_rxon(struct iwl_priv *priv)
 	 * an RXON_ASSOC and the new config wants the associated mask enabled,
 	 * we must clear the associated from the active configuration
 	 * before we apply the new config */
-	if (iwl_is_associated(priv) &&
-	    (staging_rxon->filter_flags & RXON_FILTER_ASSOC_MSK)) {
+	if (iwl_is_associated(priv) && new_assoc) {
 		IWL_DEBUG_INFO(priv, "Toggling associated bit on current RXON\n");
 		active_rxon->filter_flags &= ~RXON_FILTER_ASSOC_MSK;
 
@@ -395,8 +396,7 @@ static int iwl3945_commit_rxon(struct iwl_priv *priv)
 		       "* with%s RXON_FILTER_ASSOC_MSK\n"
 		       "* channel = %d\n"
 		       "* bssid = %pM\n",
-		       ((priv->staging_rxon.filter_flags &
-			 RXON_FILTER_ASSOC_MSK) ? "" : "out"),
+		       (new_assoc ? "" : "out"),
 		       le16_to_cpu(staging_rxon->channel),
 		       staging_rxon->bssid_addr);
 
-- 
1.5.6.3

