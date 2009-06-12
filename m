Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga02.intel.com ([134.134.136.20]:20740 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756504AbZFLUPx (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 12 Jun 2009 16:15:53 -0400
From: Reinette Chatre <reinette.chatre@intel.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org,
	ipw3945-devel@lists.sourceforge.net,
	Abhijeet Kolekar <abhijeet.kolekar@intel.com>,
	Reinette Chatre <reinette.chatre@intel.com>
Subject: [PATCH 5/8 v2.6.31 and w-t ] iwlwifi/iwl3945: fix suspend resume association bug
Date: Fri, 12 Jun 2009 13:22:52 -0700
Message-Id: <1244838175-15491-6-git-send-email-reinette.chatre@intel.com>
In-Reply-To: <1244838175-15491-5-git-send-email-reinette.chatre@intel.com>
References: <1244838175-15491-1-git-send-email-reinette.chatre@intel.com>
 <1244838175-15491-2-git-send-email-reinette.chatre@intel.com>
 <1244838175-15491-3-git-send-email-reinette.chatre@intel.com>
 <1244838175-15491-4-git-send-email-reinette.chatre@intel.com>
 <1244838175-15491-5-git-send-email-reinette.chatre@intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Abhijeet Kolekar <abhijeet.kolekar@intel.com>

Patch fixes the following bugs at
http://www.intellinuxwireless.org/bugzilla/show_bug.cgi?id=2005
http://www.intellinuxwireless.org/bugzilla/show_bug.cgi?id=2007

If we suspend with an association and then resumed,
we need to synchronize the active rxon with staging rxon,
else we will get an error when iwl_alive_start try to commit
rxon and staging is set to channel 0. Before going to suspend
staging and active rxon are in sync. After resuming from the
suspend, iwl_mac_start is called and it clears the staging
rxon. Patch fixes the bug by not clearing the staging rxon
in iwl_mac_start.

Patch also adds similar fix to 3945.

Signed-off-by: Abhijeet Kolekar <abhijeet.kolekar@intel.com>
Signed-off-by: Reinette Chatre <reinette.chatre@intel.com>
---
 drivers/net/wireless/iwlwifi/iwl-agn.c      |    1 -
 drivers/net/wireless/iwlwifi/iwl3945-base.c |    4 +---
 2 files changed, 1 insertions(+), 4 deletions(-)

diff --git a/drivers/net/wireless/iwlwifi/iwl-agn.c b/drivers/net/wireless/iwlwifi/iwl-agn.c
index a5637c4..6d1519e 100644
--- a/drivers/net/wireless/iwlwifi/iwl-agn.c
+++ b/drivers/net/wireless/iwlwifi/iwl-agn.c
@@ -2152,7 +2152,6 @@ static int iwl_mac_start(struct ieee80211_hw *hw)
 	/* we should be verifying the device is ready to be opened */
 	mutex_lock(&priv->mutex);
 
-	memset(&priv->staging_rxon, 0, sizeof(struct iwl_rxon_cmd));
 	/* fetch ucode file from disk, alloc and copy to bus-master buffers ...
 	 * ucode filename and max sizes are card-specific. */
 
diff --git a/drivers/net/wireless/iwlwifi/iwl3945-base.c b/drivers/net/wireless/iwlwifi/iwl3945-base.c
index 83d3160..cb9bd4c 100644
--- a/drivers/net/wireless/iwlwifi/iwl3945-base.c
+++ b/drivers/net/wireless/iwlwifi/iwl3945-base.c
@@ -2498,8 +2498,7 @@ static void iwl3945_alive_start(struct iwl_priv *priv)
 		struct iwl3945_rxon_cmd *active_rxon =
 				(struct iwl3945_rxon_cmd *)(&priv->active_rxon);
 
-		memcpy(&priv->staging_rxon, &priv->active_rxon,
-		       sizeof(priv->staging_rxon));
+		priv->staging_rxon.filter_flags |= RXON_FILTER_ASSOC_MSK;
 		active_rxon->filter_flags &= ~RXON_FILTER_ASSOC_MSK;
 	} else {
 		/* Initialize our rx_config data */
@@ -3147,7 +3146,6 @@ static int iwl3945_mac_start(struct ieee80211_hw *hw)
 	/* we should be verifying the device is ready to be opened */
 	mutex_lock(&priv->mutex);
 
-	memset(&priv->staging_rxon, 0, sizeof(priv->staging_rxon));
 	/* fetch ucode file from disk, alloc and copy to bus-master buffers ...
 	 * ucode filename and max sizes are card-specific. */
 
-- 
1.5.6.3

