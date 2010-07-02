Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga02.intel.com ([134.134.136.20]:62017 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754059Ab0GBSoI (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 2 Jul 2010 14:44:08 -0400
From: Wey-Yi Guy <wey-yi.w.guy@intel.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org,
	ipw3945-devel@lists.sourceforge.net,
	Reinette Chatre <reinette.chatre@intel.com>
Subject: [PATCH wireless-2.6] iwlwifi: remove key information during device restart
Date: Fri,  2 Jul 2010 11:45:16 -0700
Message-Id: <1278096316-2515-1-git-send-email-wey-yi.w.guy@intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Reinette Chatre <reinette.chatre@intel.com>

When there is a firmware error or the firmware is reloaded for some other
reason we currently clear all station information, including keys
associated with them. A problem is that we do not clear some other
information regarding keys that are not stored in the station structs.

The consequence of this is that when the device is reconfigured after the
firmware reload we can, among other things, run out of key indices.

This fixes:
https://bugzilla.kernel.org/show_bug.cgi?id=16232
http://bugzilla.intellinuxwireless.org/show_bug.cgi?id=2221

Signed-off-by: Reinette Chatre <reinette.chatre@intel.com>
Reviewed-by: Johannes Berg <johannes.berg@intel.com>
---
this patch is also available from wireless-2.6 branch on
 git://git.kernel.org/pub/scm/linux/kernel/git/iwlwifi/iwlwifi-2.6.git

 drivers/net/wireless/iwlwifi/iwl-sta.h |   11 +++++++++++
 1 files changed, 11 insertions(+), 0 deletions(-)

diff --git a/drivers/net/wireless/iwlwifi/iwl-sta.h b/drivers/net/wireless/iwlwifi/iwl-sta.h
index c2a453a..dc43ebd 100644
--- a/drivers/net/wireless/iwlwifi/iwl-sta.h
+++ b/drivers/net/wireless/iwlwifi/iwl-sta.h
@@ -97,6 +97,17 @@ static inline void iwl_clear_driver_stations(struct iwl_priv *priv)
 	spin_lock_irqsave(&priv->sta_lock, flags);
 	memset(priv->stations, 0, sizeof(priv->stations));
 	priv->num_stations = 0;
+
+	/*
+	 * Remove all key information that is not stored as part of station
+	 * information since mac80211 may not have had a
+	 * chance to remove all the keys. When device is reconfigured by
+	 * mac80211 after an error all keys will be reconfigured.
+	 */
+	priv->ucode_key_table = 0;
+	priv->key_mapping_key = 0;
+	memset(priv->wep_keys, 0, sizeof(priv->wep_keys));
+
 	spin_unlock_irqrestore(&priv->sta_lock, flags);
 }
 
-- 
1.7.0.4

