Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ww0-f42.google.com ([74.125.82.42]:58647 "EHLO
	mail-ww0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932076Ab1LWM3W (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 23 Dec 2011 07:29:22 -0500
Received: by wgbds13 with SMTP id ds13so13517797wgb.1
        for <linux-wireless@vger.kernel.org>; Fri, 23 Dec 2011 04:29:21 -0800 (PST)
From: Eliad Peller <eliad@wizery.com>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: <linux-wireless@vger.kernel.org>
Subject: [PATCH 2/3] mac80211: move sta_state into sta->sta
Date: Fri, 23 Dec 2011 14:24:34 +0200
Message-Id: <1324643075-29385-3-git-send-email-eliad@wizery.com> (sfid-20111223_132929_032435_E3AE4F08)
In-Reply-To: <1324643075-29385-1-git-send-email-eliad@wizery.com>
References: <1324643075-29385-1-git-send-email-eliad@wizery.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Make the station state visible to the low-level drivers.
In the following patches the drivers will be notified
about each change in the station state.

Signed-off-by: Eliad Peller <eliad@wizery.com>
---
 include/net/mac80211.h  |   10 ++++++++++
 net/mac80211/sta_info.c |   20 ++++++++++----------
 net/mac80211/sta_info.h |   11 -----------
 3 files changed, 20 insertions(+), 21 deletions(-)

diff --git a/include/net/mac80211.h b/include/net/mac80211.h
index 2a7523e..053b14a 100644
--- a/include/net/mac80211.h
+++ b/include/net/mac80211.h
@@ -961,6 +961,14 @@ enum set_key_cmd {
 	SET_KEY, DISABLE_KEY,
 };
 
+enum ieee80211_sta_state {
+	/* NOTE: These need to be ordered correctly! */
+	IEEE80211_STA_NONE,
+	IEEE80211_STA_AUTH,
+	IEEE80211_STA_ASSOC,
+	IEEE80211_STA_AUTHORIZED,
+};
+
 /**
  * struct ieee80211_sta - station table entry
  *
@@ -981,6 +989,7 @@ enum set_key_cmd {
  * @uapsd_queues: bitmap of queues configured for uapsd. Only valid
  *	if wme is supported.
  * @max_sp: max Service Period. Only valid if wme is supported.
+ * @state: the current station state
  */
 struct ieee80211_sta {
 	u32 supp_rates[IEEE80211_NUM_BANDS];
@@ -990,6 +999,7 @@ struct ieee80211_sta {
 	bool wme;
 	u8 uapsd_queues;
 	u8 max_sp;
+	enum ieee80211_sta_state state;
 
 	/* must be last */
 	u8 drv_priv[0] __attribute__((__aligned__(sizeof(void *))));
diff --git a/net/mac80211/sta_info.c b/net/mac80211/sta_info.c
index 3d01abb..66e2de6 100644
--- a/net/mac80211/sta_info.c
+++ b/net/mac80211/sta_info.c
@@ -765,8 +765,8 @@ static int __must_check __sta_info_destroy(struct sta_info *sta)
 	if (sdata->vif.type == NL80211_IFTYPE_AP_VLAN)
 		RCU_INIT_POINTER(sdata->u.vlan.sta, NULL);
 
-	while (sta->sta_state > IEEE80211_STA_NONE)
-		sta_info_move_state(sta, sta->sta_state - 1);
+	while (sta->sta.state > IEEE80211_STA_NONE)
+		sta_info_move_state(sta, sta->sta.state - 1);
 
 	if (sta->uploaded) {
 		if (sdata->vif.type == NL80211_IFTYPE_AP_VLAN)
@@ -1407,28 +1407,28 @@ int sta_info_move_state_checked(struct sta_info *sta,
 {
 	might_sleep();
 
-	if (sta->sta_state == new_state)
+	if (sta->sta.state == new_state)
 		return 0;
 
 	switch (new_state) {
 	case IEEE80211_STA_NONE:
-		if (sta->sta_state == IEEE80211_STA_AUTH)
+		if (sta->sta.state == IEEE80211_STA_AUTH)
 			clear_bit(WLAN_STA_AUTH, &sta->_flags);
 		else
 			return -EINVAL;
 		break;
 	case IEEE80211_STA_AUTH:
-		if (sta->sta_state == IEEE80211_STA_NONE)
+		if (sta->sta.state == IEEE80211_STA_NONE)
 			set_bit(WLAN_STA_AUTH, &sta->_flags);
-		else if (sta->sta_state == IEEE80211_STA_ASSOC)
+		else if (sta->sta.state == IEEE80211_STA_ASSOC)
 			clear_bit(WLAN_STA_ASSOC, &sta->_flags);
 		else
 			return -EINVAL;
 		break;
 	case IEEE80211_STA_ASSOC:
-		if (sta->sta_state == IEEE80211_STA_AUTH) {
+		if (sta->sta.state == IEEE80211_STA_AUTH) {
 			set_bit(WLAN_STA_ASSOC, &sta->_flags);
-		} else if (sta->sta_state == IEEE80211_STA_AUTHORIZED) {
+		} else if (sta->sta.state == IEEE80211_STA_AUTHORIZED) {
 			if (sta->sdata->vif.type == NL80211_IFTYPE_AP)
 				atomic_dec(&sta->sdata->u.ap.num_sta_authorized);
 			clear_bit(WLAN_STA_AUTHORIZED, &sta->_flags);
@@ -1436,7 +1436,7 @@ int sta_info_move_state_checked(struct sta_info *sta,
 			return -EINVAL;
 		break;
 	case IEEE80211_STA_AUTHORIZED:
-		if (sta->sta_state == IEEE80211_STA_ASSOC) {
+		if (sta->sta.state == IEEE80211_STA_ASSOC) {
 			if (sta->sdata->vif.type == NL80211_IFTYPE_AP)
 				atomic_inc(&sta->sdata->u.ap.num_sta_authorized);
 			set_bit(WLAN_STA_AUTHORIZED, &sta->_flags);
@@ -1450,7 +1450,7 @@ int sta_info_move_state_checked(struct sta_info *sta,
 
 	printk(KERN_DEBUG "%s: moving STA %pM to state %d\n",
 		sta->sdata->name, sta->sta.addr, new_state);
-	sta->sta_state = new_state;
+	sta->sta.state = new_state;
 
 	return 0;
 }
diff --git a/net/mac80211/sta_info.h b/net/mac80211/sta_info.h
index 6f77f12..2f54cd0 100644
--- a/net/mac80211/sta_info.h
+++ b/net/mac80211/sta_info.h
@@ -73,14 +73,6 @@ enum ieee80211_sta_info_flags {
 	WLAN_STA_4ADDR_EVENT,
 };
 
-enum ieee80211_sta_state {
-	/* NOTE: These need to be ordered correctly! */
-	IEEE80211_STA_NONE,
-	IEEE80211_STA_AUTH,
-	IEEE80211_STA_ASSOC,
-	IEEE80211_STA_AUTHORIZED,
-};
-
 #define STA_TID_NUM 16
 #define ADDBA_RESP_INTERVAL HZ
 #define HT_AGG_MAX_RETRIES		15
@@ -274,7 +266,6 @@ struct sta_ampdu_mlme {
  * @dummy: indicate a dummy station created for receiving
  *	EAP frames before association
  * @sta: station information we share with the driver
- * @sta_state: duplicates information about station state (for debug)
  * @beacon_loss_count: number of times beacon loss has triggered
  */
 struct sta_info {
@@ -297,8 +288,6 @@ struct sta_info {
 
 	bool uploaded;
 
-	enum ieee80211_sta_state sta_state;
-
 	/* use the accessors defined below */
 	unsigned long _flags;
 
-- 
1.7.6.401.g6a319

