Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from crystal.sipsolutions.net ([195.210.38.204]:45330 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752107AbXFVIwW (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 22 Jun 2007 04:52:22 -0400
Subject: [PATCH] mac80211: kill PRISM2_PARAM_CLEAR_KEYS
From: Johannes Berg <johannes@sipsolutions.net>
To: "John W. Linville" <linville@tuxdriver.com>
Cc: Jiri Benc <jbenc@suse.cz>,
	linux-wireless <linux-wireless@vger.kernel.org>
Content-Type: text/plain
Date: Fri, 22 Jun 2007 10:16:19 +0200
Message-Id: <1182500179.21939.67.camel@johannes.berg>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Not used anywhere, hence dead code. wpa_supplicant has its
own clear_keys routine.

Signed-off-by: Johannes Berg <johannes@sipsolutions.net>

---
 net/mac80211/hostapd_ioctl.h   |    1 
 net/mac80211/ieee80211_ioctl.c |   60 -----------------------------------------
 2 files changed, 61 deletions(-)

--- wireless-dev.orig/net/mac80211/hostapd_ioctl.h	2007-06-22 10:13:41.398632620 +0200
+++ wireless-dev/net/mac80211/hostapd_ioctl.h	2007-06-22 10:14:11.298632620 +0200
@@ -37,7 +37,6 @@ enum {
 	PRISM2_PARAM_PREAMBLE = 1003,
 	PRISM2_PARAM_SHORT_SLOT_TIME = 1006,
 	PRISM2_PARAM_NEXT_MODE = 1008,
-	PRISM2_PARAM_CLEAR_KEYS = 1009,
 	PRISM2_PARAM_RADIO_ENABLED = 1010,
 	PRISM2_PARAM_ANTENNA_MODE = 1013,
 	PRISM2_PARAM_PRIVACY_INVOKED = 1014,
--- wireless-dev.orig/net/mac80211/ieee80211_ioctl.c	2007-06-22 10:14:12.878632620 +0200
+++ wireless-dev/net/mac80211/ieee80211_ioctl.c	2007-06-22 10:14:26.388632620 +0200
@@ -1963,62 +1963,6 @@ static int ieee80211_ioctl_giwretry(stru
 	return 0;
 }
 
-static int ieee80211_ioctl_clear_keys(struct net_device *dev)
-{
-	struct ieee80211_local *local = wdev_priv(dev->ieee80211_ptr);
-	struct ieee80211_key_conf key;
-	int i;
-	u8 addr[ETH_ALEN];
-	struct ieee80211_key_conf *keyconf;
-	struct ieee80211_sub_if_data *sdata;
-	struct sta_info *sta;
-
-	memset(addr, 0xff, ETH_ALEN);
-	read_lock(&local->sub_if_lock);
-	list_for_each_entry(sdata, &local->sub_if_list, list) {
-		for (i = 0; i < NUM_DEFAULT_KEYS; i++) {
-			keyconf = NULL;
-			if (sdata->keys[i] &&
-			    !sdata->keys[i]->force_sw_encrypt &&
-			    local->ops->set_key &&
-			    (keyconf = ieee80211_key_data2conf(local,
-							       sdata->keys[i])))
-				local->ops->set_key(local_to_hw(local),
-						   DISABLE_KEY, addr,
-						   keyconf, 0);
-			kfree(keyconf);
-			ieee80211_key_free(sdata->keys[i]);
-			sdata->keys[i] = NULL;
-		}
-		sdata->default_key = NULL;
-	}
-	read_unlock(&local->sub_if_lock);
-
-	spin_lock_bh(&local->sta_lock);
-	list_for_each_entry(sta, &local->sta_list, list) {
-		keyconf = NULL;
-		if (sta->key && !sta->key->force_sw_encrypt &&
-		    local->ops->set_key &&
-		    (keyconf = ieee80211_key_data2conf(local, sta->key)))
-			local->ops->set_key(local_to_hw(local), DISABLE_KEY,
-					   sta->addr, keyconf, sta->aid);
-		kfree(keyconf);
-		ieee80211_key_free(sta->key);
-		sta->key = NULL;
-	}
-	spin_unlock_bh(&local->sta_lock);
-
-	memset(&key, 0, sizeof(key));
-	if (local->ops->set_key &&
-		    local->ops->set_key(local_to_hw(local), REMOVE_ALL_KEYS,
-				       NULL, &key, 0))
-		printk(KERN_DEBUG "%s: failed to remove hwaccel keys\n",
-		       dev->name);
-
-	return 0;
-}
-
-
 static void ieee80211_key_enable_hwaccel(struct ieee80211_local *local,
 					 struct ieee80211_key *key)
 {
@@ -2203,10 +2147,6 @@ static int ieee80211_ioctl_prism2_param(
 		local->next_mode = value;
 		break;
 
-	case PRISM2_PARAM_CLEAR_KEYS:
-		ret = ieee80211_ioctl_clear_keys(dev);
-		break;
-
 	case PRISM2_PARAM_RADIO_ENABLED:
 		ret = ieee80211_ioctl_set_radio_enabled(dev, value);
 		break;


