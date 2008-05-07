Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from xc.sipsolutions.net ([83.246.72.84]:54491 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755187AbYEGVSt (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 7 May 2008 17:18:49 -0400
Subject: [PATCH] mac80211: fix queue constant confusion
From: Johannes Berg <johannes@sipsolutions.net>
To: John Linville <linville@tuxdriver.com>
Cc: linux-wireless <linux-wireless@vger.kernel.org>
Content-Type: text/plain
Date: Wed, 07 May 2008 23:18:09 +0200
Message-Id: <1210195089.3790.9.camel@johannes.berg> (sfid-20080507_231755_513323_318B6015)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

In commit 31ccc476b77234f6afb3 (mac80211: QoS related cleanups) I
accidentally changed these to use IEEE80211_MAX_AMPDU_QUEUES twice
which obviously is wrong, it should be IEEE80211_MAX_QUEUES once.
Currently harmless as they're both the same value anyway.

Signed-off-by: Johannes Berg <johannes@sipsolutions.net>
---
 net/mac80211/ieee80211_i.h |    4 ++--
 net/mac80211/wme.c         |   26 +++++++++++++++-----------
 2 files changed, 17 insertions(+), 13 deletions(-)

--- everything.orig/net/mac80211/ieee80211_i.h	2008-05-07 11:09:41.000000000 +0200
+++ everything/net/mac80211/ieee80211_i.h	2008-05-07 11:10:08.000000000 +0200
@@ -611,8 +611,8 @@ struct ieee80211_local {
 	struct sta_info *sta_hash[STA_HASH_SIZE];
 	struct timer_list sta_cleanup;
 
-	unsigned long state[IEEE80211_MAX_AMPDU_QUEUES + IEEE80211_MAX_AMPDU_QUEUES];
-	struct ieee80211_tx_stored_packet pending_packet[IEEE80211_MAX_AMPDU_QUEUES + IEEE80211_MAX_AMPDU_QUEUES];
+	unsigned long state[IEEE80211_MAX_QUEUES + IEEE80211_MAX_AMPDU_QUEUES];
+	struct ieee80211_tx_stored_packet pending_packet[IEEE80211_MAX_QUEUES + IEEE80211_MAX_AMPDU_QUEUES];
 	struct tasklet_struct tx_pending_tasklet;
 
 	/* number of interfaces with corresponding IFF_ flags */


