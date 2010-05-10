Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga02.intel.com ([134.134.136.20]:48051 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756239Ab0EJW2d (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 10 May 2010 18:28:33 -0400
From: Reinette Chatre <reinette.chatre@intel.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org,
	ipw3945-devel@lists.sourceforge.net,
	Johannes Berg <johannes.berg@intel.com>,
	Reinette Chatre <reinette.chatre@intel.com>
Subject: [PATCH 46/47] iwlwifi: remove pointless HT check
Date: Mon, 10 May 2010 15:28:17 -0700
Message-Id: <1273530498-11876-47-git-send-email-reinette.chatre@intel.com>
In-Reply-To: <1273530498-11876-1-git-send-email-reinette.chatre@intel.com>
References: <1273530498-11876-1-git-send-email-reinette.chatre@intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Johannes Berg <johannes.berg@intel.com>

Remove the check before invoking iwl_set_ht_add_station(),
since neither of the conditions in this check makes sense,
as either we pass in a NULL ht_info (first branch) or in
the IBSS case an ht_info with ht_enabled=false.

Signed-off-by: Johannes Berg <johannes.berg@intel.com>
Signed-off-by: Reinette Chatre <reinette.chatre@intel.com>
---
 drivers/net/wireless/iwlwifi/iwl-sta.c |   10 ++++++----
 1 files changed, 6 insertions(+), 4 deletions(-)

diff --git a/drivers/net/wireless/iwlwifi/iwl-sta.c b/drivers/net/wireless/iwlwifi/iwl-sta.c
index c15098e..85ed235 100644
--- a/drivers/net/wireless/iwlwifi/iwl-sta.c
+++ b/drivers/net/wireless/iwlwifi/iwl-sta.c
@@ -284,10 +284,12 @@ static u8 iwl_prep_station(struct iwl_priv *priv, const u8 *addr,
 	station->sta.sta.sta_id = sta_id;
 	station->sta.station_flags = 0;
 
-	/* BCAST station and IBSS stations do not work in HT mode */
-	if (sta_id != priv->hw_params.bcast_sta_id &&
-	    priv->iw_mode != NL80211_IFTYPE_ADHOC)
-		iwl_set_ht_add_station(priv, sta_id, ht_info);
+	/*
+	 * OK to call unconditionally, since local stations (IBSS BSSID
+	 * STA and broadcast STA) pass in a NULL ht_info, and mac80211
+	 * doesn't allow HT IBSS.
+	 */
+	iwl_set_ht_add_station(priv, sta_id, ht_info);
 
 	/* 3945 only */
 	rate = (priv->band == IEEE80211_BAND_5GHZ) ?
-- 
1.6.3.3

