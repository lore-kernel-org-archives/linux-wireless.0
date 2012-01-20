Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:60303 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752509Ab2ATM6n (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 20 Jan 2012 07:58:43 -0500
Message-Id: <20120120125740.332467077@sipsolutions.net> (sfid-20120120_135847_752407_4B44A8C5)
Date: Fri, 20 Jan 2012 13:55:17 +0100
From: Johannes Berg <johannes@sipsolutions.net>
To: John Linville <linville@tuxdriver.com>
Cc: linux-wireless@vger.kernel.org
Subject: [PATCH 01/11] mac80211: move managed mode station state
 modification
References: <20120120125516.000124996@sipsolutions.net>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Johannes Berg <johannes.berg@intel.com>

Move the station state modification right before insert,
this just makes the current code more readable (you can
tell that it's before insertion looking at a single
screenful of code) right now, but some upcoming changes
will require this.

Signed-off-by: Johannes Berg <johannes.berg@intel.com>
---
 net/mac80211/mlme.c |   28 ++++++++++++++--------------
 1 file changed, 14 insertions(+), 14 deletions(-)

--- a/net/mac80211/mlme.c	2012-01-20 13:54:17.000000000 +0100
+++ b/net/mac80211/mlme.c	2012-01-20 13:54:18.000000000 +0100
@@ -1587,20 +1587,6 @@ static bool ieee80211_assoc_success(stru
 		return false;
 	}
 
-	err = sta_info_move_state(sta, IEEE80211_STA_AUTH);
-	if (!err)
-		err = sta_info_move_state(sta, IEEE80211_STA_ASSOC);
-	if (!err && !(ifmgd->flags & IEEE80211_STA_CONTROL_PORT))
-		err = sta_info_move_state(sta, IEEE80211_STA_AUTHORIZED);
-	if (err) {
-		printk(KERN_DEBUG
-		       "%s: failed to move station %pM to desired state\n",
-		       sdata->name, sta->sta.addr);
-		WARN_ON(__sta_info_destroy(sta));
-		mutex_unlock(&sdata->local->sta_mtx);
-		return false;
-	}
-
 	rates = 0;
 	basic_rates = 0;
 	sband = local->hw.wiphy->bands[wk->chan->band];
@@ -1648,6 +1634,20 @@ static bool ieee80211_assoc_success(stru
 	if (elems.wmm_param)
 		set_sta_flag(sta, WLAN_STA_WME);
 
+	err = sta_info_move_state(sta, IEEE80211_STA_AUTH);
+	if (!err)
+		err = sta_info_move_state(sta, IEEE80211_STA_ASSOC);
+	if (!err && !(ifmgd->flags & IEEE80211_STA_CONTROL_PORT))
+		err = sta_info_move_state(sta, IEEE80211_STA_AUTHORIZED);
+	if (err) {
+		printk(KERN_DEBUG
+		       "%s: failed to move station %pM to desired state\n",
+		       sdata->name, sta->sta.addr);
+		WARN_ON(__sta_info_destroy(sta));
+		mutex_unlock(&sdata->local->sta_mtx);
+		return false;
+	}
+
 	/* sta_info_reinsert will also unlock the mutex lock */
 	err = sta_info_reinsert(sta);
 	sta = NULL;


