Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:44670 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932621Ab2AEPdh (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 5 Jan 2012 10:33:37 -0500
Message-Id: <20120105153228.628678062@sipsolutions.net> (sfid-20120105_163339_258071_4D896C7D)
Date: Thu, 05 Jan 2012 16:30:46 +0100
From: Johannes Berg <johannes@sipsolutions.net>
To: John Linville <linville@tuxdriver.com>
Cc: linux-wireless@vger.kernel.org
Subject: [PATCH 3/8] mac80211: dont program keys for stations not uploaded
References: <20120105153043.568616380@sipsolutions.net>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Johannes Berg <johannes.berg@intel.com>

If a station couldn't be uploaded to the driver but
is still kept (only in IBSS mode) we still shouldn't
try to program the keys for it into hardware; fix
this bug by skipping the key upload in this case.

Signed-off-by: Johannes Berg <johannes.berg@intel.com>
---
 net/mac80211/key.c |   30 ++++++++++++++----------------
 1 file changed, 14 insertions(+), 16 deletions(-)

--- a/net/mac80211/key.c	2012-01-05 09:16:58.000000000 +0100
+++ b/net/mac80211/key.c	2012-01-05 15:22:12.000000000 +0100
@@ -54,14 +54,6 @@ static void assert_key_lock(struct ieee8
 	lockdep_assert_held(&local->key_mtx);
 }
 
-static struct ieee80211_sta *get_sta_for_key(struct ieee80211_key *key)
-{
-	if (key->sta)
-		return &key->sta->sta;
-
-	return NULL;
-}
-
 static void increment_tailroom_need_count(struct ieee80211_sub_if_data *sdata)
 {
 	/*
@@ -95,7 +87,7 @@ static void increment_tailroom_need_coun
 static int ieee80211_key_enable_hw_accel(struct ieee80211_key *key)
 {
 	struct ieee80211_sub_if_data *sdata;
-	struct ieee80211_sta *sta;
+	struct sta_info *sta;
 	int ret;
 
 	might_sleep();
@@ -105,7 +97,7 @@ static int ieee80211_key_enable_hw_accel
 
 	assert_key_lock(key->local);
 
-	sta = get_sta_for_key(key);
+	sta = key->sta;
 
 	/*
 	 * If this is a per-STA GTK, check if it
@@ -115,6 +107,9 @@ static int ieee80211_key_enable_hw_accel
 	    !(key->local->hw.flags & IEEE80211_HW_SUPPORTS_PER_STA_GTK))
 		goto out_unsupported;
 
+	if (sta && !sta->uploaded)
+		goto out_unsupported;
+
 	sdata = key->sdata;
 	if (sdata->vif.type == NL80211_IFTYPE_AP_VLAN) {
 		/*
@@ -125,7 +120,8 @@ static int ieee80211_key_enable_hw_accel
 			goto out_unsupported;
 	}
 
-	ret = drv_set_key(key->local, SET_KEY, sdata, sta, &key->conf);
+	ret = drv_set_key(key->local, SET_KEY, sdata,
+			  sta ? &sta->sta : NULL, &key->conf);
 
 	if (!ret) {
 		key->flags |= KEY_FLAG_UPLOADED_TO_HARDWARE;
@@ -144,7 +140,8 @@ static int ieee80211_key_enable_hw_accel
 	if (ret != -ENOSPC && ret != -EOPNOTSUPP)
 		wiphy_err(key->local->hw.wiphy,
 			  "failed to set key (%d, %pM) to hardware (%d)\n",
-			  key->conf.keyidx, sta ? sta->addr : bcast_addr, ret);
+			  key->conf.keyidx,
+			  sta ? sta->sta.addr : bcast_addr, ret);
 
  out_unsupported:
 	switch (key->conf.cipher) {
@@ -163,7 +160,7 @@ static int ieee80211_key_enable_hw_accel
 static void ieee80211_key_disable_hw_accel(struct ieee80211_key *key)
 {
 	struct ieee80211_sub_if_data *sdata;
-	struct ieee80211_sta *sta;
+	struct sta_info *sta;
 	int ret;
 
 	might_sleep();
@@ -176,7 +173,7 @@ static void ieee80211_key_disable_hw_acc
 	if (!(key->flags & KEY_FLAG_UPLOADED_TO_HARDWARE))
 		return;
 
-	sta = get_sta_for_key(key);
+	sta = key->sta;
 	sdata = key->sdata;
 
 	if (!((key->conf.flags & IEEE80211_KEY_FLAG_GENERATE_MMIC) ||
@@ -185,12 +182,13 @@ static void ieee80211_key_disable_hw_acc
 		increment_tailroom_need_count(sdata);
 
 	ret = drv_set_key(key->local, DISABLE_KEY, sdata,
-			  sta, &key->conf);
+			  sta ? &sta->sta : NULL, &key->conf);
 
 	if (ret)
 		wiphy_err(key->local->hw.wiphy,
 			  "failed to remove key (%d, %pM) from hardware (%d)\n",
-			  key->conf.keyidx, sta ? sta->addr : bcast_addr, ret);
+			  key->conf.keyidx,
+			  sta ? sta->sta.addr : bcast_addr, ret);
 
 	key->flags &= ~KEY_FLAG_UPLOADED_TO_HARDWARE;
 }


