Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:44672 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932621Ab2AEPdi (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 5 Jan 2012 10:33:38 -0500
Message-Id: <20120105153228.762826182@sipsolutions.net> (sfid-20120105_163341_188923_D51A75DD)
Date: Thu, 05 Jan 2012 16:30:47 +0100
From: Johannes Berg <johannes@sipsolutions.net>
To: John Linville <linville@tuxdriver.com>
Cc: linux-wireless@vger.kernel.org
Subject: [PATCH 4/8] mac80211: add NOTEXIST station state
References: <20120105153043.568616380@sipsolutions.net>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Johannes Berg <johannes.berg@intel.com>

This will be used by drivers later if they
need to have stations inserted all the time,
in mac80211 has no purpose, is never used
and sta_state starts out in NONE.

Signed-off-by: Johannes Berg <johannes.berg@intel.com>
---
 net/mac80211/sta_info.c |    2 ++
 net/mac80211/sta_info.h |    1 +
 2 files changed, 3 insertions(+)

--- a/net/mac80211/sta_info.h	2012-01-04 14:13:16.000000000 +0100
+++ b/net/mac80211/sta_info.h	2012-01-04 14:19:42.000000000 +0100
@@ -77,6 +77,7 @@ enum ieee80211_sta_info_flags {
 
 enum ieee80211_sta_state {
 	/* NOTE: These need to be ordered correctly! */
+	IEEE80211_STA_NOTEXIST,
 	IEEE80211_STA_NONE,
 	IEEE80211_STA_AUTH,
 	IEEE80211_STA_ASSOC,
--- a/net/mac80211/sta_info.c	2012-01-04 14:13:16.000000000 +0100
+++ b/net/mac80211/sta_info.c	2012-01-04 14:19:42.000000000 +0100
@@ -295,6 +295,8 @@ struct sta_info *sta_info_alloc(struct i
 	sta->sdata = sdata;
 	sta->last_rx = jiffies;
 
+	sta->sta_state = IEEE80211_STA_NONE;
+
 	do_posix_clock_monotonic_gettime(&uptime);
 	sta->last_connected = uptime.tv_sec;
 	ewma_init(&sta->avg_signal, 1024, 8);


