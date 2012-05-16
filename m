Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:41665 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759243Ab2EPVzC (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 16 May 2012 17:55:02 -0400
Message-Id: <20120516215038.507974917@sipsolutions.net> (sfid-20120516_235515_816000_6122D543)
Date: Wed, 16 May 2012 23:50:17 +0200
From: Johannes Berg <johannes@sipsolutions.net>
To: John Linville <linville@tuxdriver.com>
Cc: linux-wireless@vger.kernel.org
Subject: [PATCH 3/7] cfg80211: simplify cfg80211_can_beacon_sec_chan API
References: <20120516215014.379333357@sipsolutions.net>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Johannes Berg <johannes.berg@intel.com>

Change cfg80211_can_beacon_sec_chan() to return true
if there is no secondary channel to simplify all the
current users of it. They all check the channel type
before calling the function because it returns false
if there's no secondary channel.

Also actually document the return value.

Signed-off-by: Johannes Berg <johannes.berg@intel.com>
---
 include/net/cfg80211.h |    5 ++++-
 net/mac80211/ibss.c    |    3 +--
 net/wireless/chan.c    |   22 ++++++----------------
 3 files changed, 11 insertions(+), 19 deletions(-)

--- a/include/net/cfg80211.h	2012-05-15 20:14:52.000000000 +0200
+++ b/include/net/cfg80211.h	2012-05-15 20:14:53.000000000 +0200
@@ -3359,11 +3359,14 @@ void cfg80211_report_obss_beacon(struct
 				 const u8 *frame, size_t len,
 				 int freq, int sig_dbm, gfp_t gfp);
 
-/*
+/**
  * cfg80211_can_beacon_sec_chan - test if ht40 on extension channel can be used
  * @wiphy: the wiphy
  * @chan: main channel
  * @channel_type: HT mode
+ *
+ * This function returns true if there is no secondary channel or the secondary
+ * channel can be used for beaconing (i.e. is not a radar channel etc.)
  */
 bool cfg80211_can_beacon_sec_chan(struct wiphy *wiphy,
 				  struct ieee80211_channel *chan,
--- a/net/mac80211/ibss.c	2012-05-15 20:14:44.000000000 +0200
+++ b/net/mac80211/ibss.c	2012-05-15 20:14:53.000000000 +0200
@@ -82,8 +82,7 @@ static void __ieee80211_sta_join_ibss(st
 
 	local->oper_channel = chan;
 	channel_type = ifibss->channel_type;
-	if (channel_type > NL80211_CHAN_HT20 &&
-	    !cfg80211_can_beacon_sec_chan(local->hw.wiphy, chan, channel_type))
+	if (!cfg80211_can_beacon_sec_chan(local->hw.wiphy, chan, channel_type))
 		channel_type = NL80211_CHAN_HT20;
 	if (!ieee80211_set_channel_type(local, sdata, channel_type)) {
 		/* can only fail due to HT40+/- mismatch */
--- a/net/wireless/chan.c	2012-05-15 20:14:52.000000000 +0200
+++ b/net/wireless/chan.c	2012-05-15 20:14:53.000000000 +0200
@@ -60,7 +60,7 @@ bool cfg80211_can_beacon_sec_chan(struct
 		diff = -20;
 		break;
 	default:
-		return false;
+		return true;
 	}
 
 	sec_chan = ieee80211_get_channel(wiphy, chan->center_freq + diff);
@@ -107,21 +107,11 @@ int cfg80211_set_freq(struct cfg80211_re
 		     wdev->iftype == NL80211_IFTYPE_AP ||
 		     wdev->iftype == NL80211_IFTYPE_AP_VLAN ||
 		     wdev->iftype == NL80211_IFTYPE_MESH_POINT ||
-		     wdev->iftype == NL80211_IFTYPE_P2P_GO)) {
-		switch (channel_type) {
-		case NL80211_CHAN_HT40PLUS:
-		case NL80211_CHAN_HT40MINUS:
-			if (!cfg80211_can_beacon_sec_chan(&rdev->wiphy, chan,
-							  channel_type)) {
-				printk(KERN_DEBUG
-				       "cfg80211: Secondary channel not "
-				       "allowed to initiate communication\n");
-				return -EINVAL;
-			}
-			break;
-		default:
-			break;
-		}
+		     wdev->iftype == NL80211_IFTYPE_P2P_GO) &&
+	    !cfg80211_can_beacon_sec_chan(&rdev->wiphy, chan, channel_type)) {
+		printk(KERN_DEBUG
+		       "cfg80211: Secondary channel not allowed to beacon\n");
+		return -EINVAL;
 	}
 
 	result = rdev->ops->set_channel(&rdev->wiphy,


