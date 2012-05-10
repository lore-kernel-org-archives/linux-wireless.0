Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:53324 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755627Ab2EJTZa (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 10 May 2012 15:25:30 -0400
Message-ID: <1336677923.4334.32.camel@jlt3.sipsolutions.net> (sfid-20120510_212533_579328_AC017809)
Subject: [PATCH] cfg80211: fix cfg80211_can_beacon_sec_chan prototype
From: Johannes Berg <johannes@sipsolutions.net>
To: John Linville <linville@tuxdriver.com>
Cc: linux-wireless <linux-wireless@vger.kernel.org>
Date: Thu, 10 May 2012 21:25:23 +0200
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Johannes Berg <johannes.berg@intel.com>

It should return bool, not int. The function even
does return true/false.

Signed-off-by: Johannes Berg <johannes.berg@intel.com>
---
 include/net/cfg80211.h |    6 +++---
 net/wireless/chan.c    |    2 +-
 2 files changed, 4 insertions(+), 4 deletions(-)

--- a/include/net/cfg80211.h	2012-05-10 20:43:44.000000000 +0200
+++ b/include/net/cfg80211.h	2012-05-10 20:44:39.000000000 +0200
@@ -3365,9 +3365,9 @@ void cfg80211_report_obss_beacon(struct
  * @chan: main channel
  * @channel_type: HT mode
  */
-int cfg80211_can_beacon_sec_chan(struct wiphy *wiphy,
-				 struct ieee80211_channel *chan,
-				 enum nl80211_channel_type channel_type);
+bool cfg80211_can_beacon_sec_chan(struct wiphy *wiphy,
+				  struct ieee80211_channel *chan,
+				  enum nl80211_channel_type channel_type);
 
 /*
  * cfg80211_ch_switch_notify - update wdev channel and notify userspace
--- a/net/wireless/chan.c	2012-05-10 20:43:36.000000000 +0200
+++ b/net/wireless/chan.c	2012-05-10 20:43:56.000000000 +0200
@@ -45,7 +45,7 @@ rdev_freq_to_chan(struct cfg80211_regist
 	return chan;
 }
 
-int cfg80211_can_beacon_sec_chan(struct wiphy *wiphy,
+bool cfg80211_can_beacon_sec_chan(struct wiphy *wiphy,
 				  struct ieee80211_channel *chan,
 				  enum nl80211_channel_type channel_type)
 {


