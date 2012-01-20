Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:60309 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752509Ab2ATM6s (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 20 Jan 2012 07:58:48 -0500
Message-Id: <20120120125740.726174716@sipsolutions.net> (sfid-20120120_135852_376595_1F0A30EF)
Date: Fri, 20 Jan 2012 13:55:20 +0100
From: Johannes Berg <johannes@sipsolutions.net>
To: John Linville <linville@tuxdriver.com>
Cc: linux-wireless@vger.kernel.org
Subject: [PATCH 04/11] mac80211: add NOTEXIST station state
References: <20120120125516.000124996@sipsolutions.net>
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

--- a/net/mac80211/sta_info.h	2012-01-20 13:54:16.000000000 +0100
+++ b/net/mac80211/sta_info.h	2012-01-20 13:54:19.000000000 +0100
@@ -77,6 +77,7 @@ enum ieee80211_sta_info_flags {
 
 enum ieee80211_sta_state {
 	/* NOTE: These need to be ordered correctly! */
+	IEEE80211_STA_NOTEXIST,
 	IEEE80211_STA_NONE,
 	IEEE80211_STA_AUTH,
 	IEEE80211_STA_ASSOC,
--- a/net/mac80211/sta_info.c	2012-01-20 13:54:19.000000000 +0100
+++ b/net/mac80211/sta_info.c	2012-01-20 13:54:19.000000000 +0100
@@ -293,6 +293,8 @@ struct sta_info *sta_info_alloc(struct i
 	sta->sdata = sdata;
 	sta->last_rx = jiffies;
 
+	sta->sta_state = IEEE80211_STA_NONE;
+
 	do_posix_clock_monotonic_gettime(&uptime);
 	sta->last_connected = uptime.tv_sec;
 	ewma_init(&sta->avg_signal, 1024, 8);


