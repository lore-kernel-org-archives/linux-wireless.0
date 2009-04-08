Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga11.intel.com ([192.55.52.93]:9750 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932356AbZDHSdq (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 8 Apr 2009 14:33:46 -0400
From: Reinette Chatre <reinette.chatre@intel.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org,
	ipw3945-devel@lists.sourceforge.net,
	Mohamed Abbas <mohamed.abbas@intel.com>,
	Reinette Chatre <reinette.chatre@intel.com>
Subject: [PATCH 3/6] iwlagn: Sync rxon active with changes
Date: Wed,  8 Apr 2009 11:39:29 -0700
Message-Id: <1239215972-1795-4-git-send-email-reinette.chatre@intel.com> (sfid-20090408_203406_169367_7869E52C)
In-Reply-To: <1239215972-1795-3-git-send-email-reinette.chatre@intel.com>
References: <1239215972-1795-1-git-send-email-reinette.chatre@intel.com>
 <1239215972-1795-2-git-send-email-reinette.chatre@intel.com>
 <1239215972-1795-3-git-send-email-reinette.chatre@intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Mohamed Abbas <mohamed.abbas@intel.com>

We need to sync rxon_active with changes after we commit rxon_assoc,
without rxon_active will still have the old data that cause
iwl_send_rxon_assoc to fail with no change in rxon command.

Signed-off-by: Mohamed Abbas <mohamed.abbas@intel.com>
Signed-off-by: Reinette Chatre <reinette.chatre@intel.com>
---
 drivers/net/wireless/iwlwifi/iwl-core.c |    8 +++++++-
 1 files changed, 7 insertions(+), 1 deletions(-)

diff --git a/drivers/net/wireless/iwlwifi/iwl-core.c b/drivers/net/wireless/iwlwifi/iwl-core.c
index 1b66272..3b34b18 100644
--- a/drivers/net/wireless/iwlwifi/iwl-core.c
+++ b/drivers/net/wireless/iwlwifi/iwl-core.c
@@ -2237,6 +2237,7 @@ void iwl_bss_info_changed(struct ieee80211_hw *hw,
 				     u32 changes)
 {
 	struct iwl_priv *priv = hw->priv;
+	int ret;
 
 	IWL_DEBUG_MAC80211(priv, "changes = 0x%X\n", changes);
 
@@ -2291,7 +2292,12 @@ void iwl_bss_info_changed(struct ieee80211_hw *hw,
 		}
 	} else if (changes && iwl_is_associated(priv) && priv->assoc_id) {
 			IWL_DEBUG_MAC80211(priv, "Associated Changes %d\n", changes);
-			iwl_send_rxon_assoc(priv);
+			ret = iwl_send_rxon_assoc(priv);
+			if (!ret)
+				/* Sync active_rxon with latest change. */
+				memcpy((void *)&priv->active_rxon,
+					&priv->staging_rxon,
+					sizeof(struct iwl_rxon_cmd));
 	}
 
 }
-- 
1.5.6.3

