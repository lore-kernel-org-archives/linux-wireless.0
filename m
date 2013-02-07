Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:55918 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755656Ab3BGQT7 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 7 Feb 2013 11:19:59 -0500
From: Johannes Berg <johannes@sipsolutions.net>
To: linux-wireless@vger.kernel.org
Cc: Johannes Berg <johannes.berg@intel.com>
Subject: [PATCH] mac80211: remove unused code to mark AP station authenticated
Date: Thu,  7 Feb 2013 17:20:21 +0100
Message-Id: <1360254021-23864-1-git-send-email-johannes@sipsolutions.net> (sfid-20130207_172008_833059_4995DCD4)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Johannes Berg <johannes.berg@intel.com>

When we get to association, the AP station already exists and
is marked authenticated, so moving it into IEEE80211_STA_AUTH
again is a NOP, remove it.

Signed-off-by: Johannes Berg <johannes.berg@intel.com>
---
 net/mac80211/mlme.c | 4 +---
 1 file changed, 1 insertion(+), 3 deletions(-)

diff --git a/net/mac80211/mlme.c b/net/mac80211/mlme.c
index 9a0993c..1acb307 100644
--- a/net/mac80211/mlme.c
+++ b/net/mac80211/mlme.c
@@ -2213,9 +2213,7 @@ static bool ieee80211_assoc_success(struct ieee80211_sub_if_data *sdata,
 	if (elems.wmm_param)
 		set_sta_flag(sta, WLAN_STA_WME);
 
-	err = sta_info_move_state(sta, IEEE80211_STA_AUTH);
-	if (!err)
-		err = sta_info_move_state(sta, IEEE80211_STA_ASSOC);
+	err = sta_info_move_state(sta, IEEE80211_STA_ASSOC);
 	if (!err && !(ifmgd->flags & IEEE80211_STA_CONTROL_PORT))
 		err = sta_info_move_state(sta, IEEE80211_STA_AUTHORIZED);
 	if (err) {
-- 
1.8.0

