Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga14.intel.com ([192.55.52.115]:39368 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751759AbbLMLlq (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Sun, 13 Dec 2015 06:41:46 -0500
From: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
To: johannes@sipsolutions.net
Cc: linux-wireless@vger.kernel.org, Ilan Peer <ilan.peer@intel.com>,
	Emmanuel Grumbach <emmanuel.grumbach@intel.com>
Subject: [PATCH] mac80211: Recalc min chandef when station is associated
Date: Sun, 13 Dec 2015 13:41:43 +0200
Message-Id: <1450006903-3600-1-git-send-email-emmanuel.grumbach@intel.com> (sfid-20151213_124220_116415_ED701D45)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Ilan Peer <ilan.peer@intel.com>

The minimum chandef bandwidth calculation was done only in case
a new station was inserted (or when an existing station was removed).
However, it is possible that stations are inserted before they are
associated, e.g., when FULL_AP_CLIENT_STATE is supported and user
space adds stations unassociated.

Fix this by calling ieee80211_recalc_min_chandef() whenever
a station transitions in/out the associated state, and only
consider station marked as associated.

Signed-off-by: Ilan Peer <ilan.peer@intel.com>
Signed-off-by: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
---
 net/mac80211/chan.c     | 2 +-
 net/mac80211/sta_info.c | 9 +++++----
 2 files changed, 6 insertions(+), 5 deletions(-)

diff --git a/net/mac80211/chan.c b/net/mac80211/chan.c
index 1d1b9b7..2839811 100644
--- a/net/mac80211/chan.c
+++ b/net/mac80211/chan.c
@@ -231,7 +231,7 @@ ieee80211_get_max_required_bw(struct ieee80211_sub_if_data *sdata)
 		    !(sta->sdata->bss && sta->sdata->bss == sdata->bss))
 			continue;
 
-		if (!sta->uploaded)
+		if (!sta->uploaded || !test_sta_flag(sta, WLAN_STA_ASSOC))
 			continue;
 
 		max_bw = max(max_bw, ieee80211_get_sta_bw(&sta->sta));
diff --git a/net/mac80211/sta_info.c b/net/mac80211/sta_info.c
index 4402ad5..7e007cf 100644
--- a/net/mac80211/sta_info.c
+++ b/net/mac80211/sta_info.c
@@ -530,7 +530,6 @@ static int sta_info_insert_finish(struct sta_info *sta) __acquires(RCU)
 	/* accept BA sessions now */
 	clear_sta_flag(sta, WLAN_STA_BLOCK_BA);
 
-	ieee80211_recalc_min_chandef(sdata);
 	ieee80211_sta_debugfs_add(sta);
 	rate_control_add_sta_debugfs(sta);
 
@@ -941,7 +940,6 @@ static void __sta_info_destroy_part2(struct sta_info *sta)
 
 	rate_control_remove_sta_debugfs(sta);
 	ieee80211_sta_debugfs_remove(sta);
-	ieee80211_recalc_min_chandef(sdata);
 
 	cleanup_single_sta(sta);
 }
@@ -1808,14 +1806,17 @@ int sta_info_move_state(struct sta_info *sta,
 			clear_bit(WLAN_STA_AUTH, &sta->_flags);
 		break;
 	case IEEE80211_STA_AUTH:
-		if (sta->sta_state == IEEE80211_STA_NONE)
+		if (sta->sta_state == IEEE80211_STA_NONE) {
 			set_bit(WLAN_STA_AUTH, &sta->_flags);
-		else if (sta->sta_state == IEEE80211_STA_ASSOC)
+		} else if (sta->sta_state == IEEE80211_STA_ASSOC) {
 			clear_bit(WLAN_STA_ASSOC, &sta->_flags);
+			ieee80211_recalc_min_chandef(sta->sdata);
+		}
 		break;
 	case IEEE80211_STA_ASSOC:
 		if (sta->sta_state == IEEE80211_STA_AUTH) {
 			set_bit(WLAN_STA_ASSOC, &sta->_flags);
+			ieee80211_recalc_min_chandef(sta->sdata);
 		} else if (sta->sta_state == IEEE80211_STA_AUTHORIZED) {
 			if (sta->sdata->vif.type == NL80211_IFTYPE_AP ||
 			    (sta->sdata->vif.type == NL80211_IFTYPE_AP_VLAN &&
-- 
2.5.0

