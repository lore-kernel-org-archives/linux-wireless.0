Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:43714 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758511Ab0D3SIj (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 30 Apr 2010 14:08:39 -0400
Subject: [PATCH] mac80211: fix ieee80211_find_sta[_by_hw]
From: Johannes Berg <johannes@sipsolutions.net>
To: John Linville <linville@tuxdriver.com>
Cc: linux-wireless <linux-wireless@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Date: Fri, 30 Apr 2010 13:48:36 +0200
Message-ID: <1272628116.3541.1.camel@jlt3.sipsolutions.net>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Both of these functions can currently return
a station pointer that, to the driver, is
invalid (in IBSS mode only) because adding
the station failed. Check for that, and also
make ieee80211_find_sta() properly use the
per interface station search.

Signed-off-by: Johannes Berg <johannes.berg@intel.com>
---
As far as I can tell these problems do not matter
to any drivers currently, so should be good for .35
only even though it fixes a bug introduced in .34
with the sleeping station management.

 net/mac80211/sta_info.c |   17 +++++++++++++----
 1 files changed, 13 insertions(+), 4 deletions(-)

diff --git a/net/mac80211/sta_info.c b/net/mac80211/sta_info.c
index 3de7a22..7301975 100644
--- a/net/mac80211/sta_info.c
+++ b/net/mac80211/sta_info.c
@@ -855,8 +855,12 @@ struct ieee80211_sta *ieee80211_find_sta_by_hw(struct ieee80211_hw *hw,
 	struct sta_info *sta, *nxt;
 
 	/* Just return a random station ... first in list ... */
-	for_each_sta_info(hw_to_local(hw), addr, sta, nxt)
+	for_each_sta_info(hw_to_local(hw), addr, sta, nxt) {
+		if (!sta->uploaded)
+			return NULL;
 		return &sta->sta;
+	}
+
 	return NULL;
 }
 EXPORT_SYMBOL_GPL(ieee80211_find_sta_by_hw);
@@ -864,14 +868,19 @@ EXPORT_SYMBOL_GPL(ieee80211_find_sta_by_hw);
 struct ieee80211_sta *ieee80211_find_sta(struct ieee80211_vif *vif,
 					 const u8 *addr)
 {
-	struct ieee80211_sub_if_data *sdata;
+	struct sta_info *sta;
 
 	if (!vif)
 		return NULL;
 
-	sdata = vif_to_sdata(vif);
+	sta = sta_info_get_bss(vif_to_sdata(vif), addr);
+	if (!sta)
+		return NULL;
+
+	if (!sta->uploaded)
+		return NULL;
 
-	return ieee80211_find_sta_by_hw(&sdata->local->hw, addr);
+	return &sta->sta;
 }
 EXPORT_SYMBOL(ieee80211_find_sta);
 
-- 
1.7.0.5



