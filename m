Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga01.intel.com ([192.55.52.88]:23006 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S965041AbbLHOGj (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 8 Dec 2015 09:06:39 -0500
From: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
To: johannes@sipsolutions.net
Cc: linux-wireless@vger.kernel.org,
	Johannes Berg <johannes.berg@intel.com>
Subject: [PATCH 7/9] mac80211: suppress unchanged "limiting TX power" messages
Date: Tue,  8 Dec 2015 16:04:37 +0200
Message-Id: <1449583479-26658-8-git-send-email-emmanuel.grumbach@intel.com> (sfid-20151208_150644_827798_FB165183)
In-Reply-To: <1449583479-26658-1-git-send-email-emmanuel.grumbach@intel.com>
References: <1449583479-26658-1-git-send-email-emmanuel.grumbach@intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Johannes Berg <johannes.berg@intel.com>

When the AP is advertising limited TX power, the message can be
printed over and over again. Suppress it when the power level
isn't changing.

This fixes https://bugzilla.kernel.org/show_bug.cgi?id=106011

Signed-off-by: Johannes Berg <johannes.berg@intel.com>
---
 net/mac80211/mlme.c | 15 ++++++++++-----
 1 file changed, 10 insertions(+), 5 deletions(-)

diff --git a/net/mac80211/mlme.c b/net/mac80211/mlme.c
index 62c8e4f..31d5881 100644
--- a/net/mac80211/mlme.c
+++ b/net/mac80211/mlme.c
@@ -1379,21 +1379,26 @@ static u32 ieee80211_handle_pwr_constr(struct ieee80211_sub_if_data *sdata,
 	 */
 	if (has_80211h_pwr &&
 	    (!has_cisco_pwr || pwr_level_80211h <= pwr_level_cisco)) {
+		new_ap_level = pwr_level_80211h;
+
+		if (sdata->ap_power_level == new_ap_level)
+			return 0;
+
 		sdata_dbg(sdata,
 			  "Limiting TX power to %d (%d - %d) dBm as advertised by %pM\n",
 			  pwr_level_80211h, chan_pwr, pwr_reduction_80211h,
 			  sdata->u.mgd.bssid);
-		new_ap_level = pwr_level_80211h;
 	} else {  /* has_cisco_pwr is always true here. */
+		new_ap_level = pwr_level_cisco;
+
+		if (sdata->ap_power_level == new_ap_level)
+			return 0;
+
 		sdata_dbg(sdata,
 			  "Limiting TX power to %d dBm as advertised by %pM\n",
 			  pwr_level_cisco, sdata->u.mgd.bssid);
-		new_ap_level = pwr_level_cisco;
 	}
 
-	if (sdata->ap_power_level == new_ap_level)
-		return 0;
-
 	sdata->ap_power_level = new_ap_level;
 	if (__ieee80211_recalc_txpower(sdata))
 		return BSS_CHANGED_TXPOWER;
-- 
2.5.0

