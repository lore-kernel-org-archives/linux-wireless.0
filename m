Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga02.intel.com ([134.134.136.20]:17743 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755095AbYBNSnb (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 14 Feb 2008 13:43:31 -0500
From: Reinette Chatre <reinette.chatre@intel.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org,
	Reinette Chatre <reinette.chatre@intel.com>,
	Tomas Winkler <tomas.winkler@intel.com>,
	Richard Scherping <richard@scherping.de>
Subject: [PATCH] iwlwifi: only check for association id when associating with AP
Date: Thu, 14 Feb 2008 10:40:28 -0800
Message-Id: <1203014428-24115-1-git-send-email-reinette.chatre@intel.com> (sfid-20080214_184338_856592_7225A3C4)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

There is no association process in IBSS mode - so testing the
association id is not needed.

Signed-off-by: Reinette Chatre <reinette.chatre@intel.com>
Signed-off-by: Tomas Winkler <tomas.winkler@intel.com>
CC: Richard Scherping <richard@scherping.de>
---
This fixes ad-hoc mode.

 drivers/net/wireless/iwlwifi/iwl3945-base.c |    3 ++-
 drivers/net/wireless/iwlwifi/iwl4965-base.c |    2 +-
 2 files changed, 3 insertions(+), 2 deletions(-)

diff --git a/drivers/net/wireless/iwlwifi/iwl3945-base.c b/drivers/net/wireless/iwlwifi/iwl3945-base.c
index c0d99ca..6b5b6de 100644
--- a/drivers/net/wireless/iwlwifi/iwl3945-base.c
+++ b/drivers/net/wireless/iwlwifi/iwl3945-base.c
@@ -2806,7 +2806,8 @@ static int iwl3945_tx_skb(struct iwl3945_priv *priv,
 #endif
 
 	/* drop all data frame if we are not associated */
-	if ((!iwl3945_is_associated(priv) || !priv->assoc_id) &&
+	if ((!iwl3945_is_associated(priv) ||
+	     ((priv->iw_mode == IEEE80211_IF_TYPE_STA) && !priv->assoc_id)) &&
 	    ((fc & IEEE80211_FCTL_FTYPE) == IEEE80211_FTYPE_DATA)) {
 		IWL_DEBUG_DROP("Dropping - !iwl3945_is_associated\n");
 		goto drop_unlock;
diff --git a/drivers/net/wireless/iwlwifi/iwl4965-base.c b/drivers/net/wireless/iwlwifi/iwl4965-base.c
index 3fa0bb4..ca03a9b 100644
--- a/drivers/net/wireless/iwlwifi/iwl4965-base.c
+++ b/drivers/net/wireless/iwlwifi/iwl4965-base.c
@@ -2932,7 +2932,7 @@ static int iwl4965_tx_skb(struct iwl4965_priv *priv,
 	/* drop all data frame if we are not associated */
 	if (((fc & IEEE80211_FCTL_FTYPE) == IEEE80211_FTYPE_DATA) &&
 	   (!iwl4965_is_associated(priv) ||
-	    !priv->assoc_id ||
+	    ((priv->iw_mode == IEEE80211_IF_TYPE_STA) && !priv->assoc_id) ||
 	    !priv->assoc_station_added)) {
 		IWL_DEBUG_DROP("Dropping - !iwl4965_is_associated\n");
 		goto drop_unlock;
-- 
1.5.3.4

