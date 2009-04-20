Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga11.intel.com ([192.55.52.93]:12239 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756690AbZDTVbH (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 20 Apr 2009 17:31:07 -0400
From: Reinette Chatre <reinette.chatre@intel.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org,
	ipw3945-devel@lists.sourceforge.net,
	Mohamed Abbas <mohamed.abbas@intel.com>,
	Reinette Chatre <reinette.chatre@intel.com>
Subject: [PATCH 11/11] iwlwifi: allow config if device not ready
Date: Mon, 20 Apr 2009 14:37:04 -0700
Message-Id: <1240263424-8495-12-git-send-email-reinette.chatre@intel.com> (sfid-20090420_233346_160130_723B6241)
In-Reply-To: <1240263424-8495-11-git-send-email-reinette.chatre@intel.com>
References: <1240263424-8495-1-git-send-email-reinette.chatre@intel.com>
 <1240263424-8495-2-git-send-email-reinette.chatre@intel.com>
 <1240263424-8495-3-git-send-email-reinette.chatre@intel.com>
 <1240263424-8495-4-git-send-email-reinette.chatre@intel.com>
 <1240263424-8495-5-git-send-email-reinette.chatre@intel.com>
 <1240263424-8495-6-git-send-email-reinette.chatre@intel.com>
 <1240263424-8495-7-git-send-email-reinette.chatre@intel.com>
 <1240263424-8495-8-git-send-email-reinette.chatre@intel.com>
 <1240263424-8495-9-git-send-email-reinette.chatre@intel.com>
 <1240263424-8495-10-git-send-email-reinette.chatre@intel.com>
 <1240263424-8495-11-git-send-email-reinette.chatre@intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Mohamed Abbas <mohamed.abbas@intel.com>

Allow user to config the device all the time but only allow commiting
these changes to card if the card is up and running.

Signed-off-by: Mohamed Abbas <mohamed.abbas@intel.com>
Signed-off-by: Reinette Chatre <reinette.chatre@intel.com>
---
 drivers/net/wireless/iwlwifi/iwl-core.c |   11 +++++------
 1 files changed, 5 insertions(+), 6 deletions(-)

diff --git a/drivers/net/wireless/iwlwifi/iwl-core.c b/drivers/net/wireless/iwlwifi/iwl-core.c
index bf7ad51..3dec2d2 100644
--- a/drivers/net/wireless/iwlwifi/iwl-core.c
+++ b/drivers/net/wireless/iwlwifi/iwl-core.c
@@ -2474,12 +2474,6 @@ int iwl_mac_config(struct ieee80211_hw *hw, u32 changed)
 
 	mutex_lock(&priv->mutex);
 
-	if (!iwl_is_ready(priv)) {
-		IWL_DEBUG_MAC80211(priv, "leave - not ready\n");
-		ret = -EIO;
-		goto out;
-	}
-
 	IWL_DEBUG_MAC80211(priv, "enter to channel %d changed 0x%X\n",
 					conf->channel->hw_value, changed);
 
@@ -2574,6 +2568,11 @@ int iwl_mac_config(struct ieee80211_hw *hw, u32 changed)
 		goto out;
 	}
 
+	if (!iwl_is_ready(priv)) {
+		IWL_DEBUG_MAC80211(priv, "leave - not ready\n");
+		goto out;
+	}
+
 	if (scan_active)
 		goto out;
 
-- 
1.5.6.3

