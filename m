Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:59353 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756138Ab2FVRSs (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 22 Jun 2012 13:18:48 -0400
From: Johannes Berg <johannes@sipsolutions.net>
To: linux-wireless@vger.kernel.org
Cc: Johannes Berg <johannes.berg@intel.com>
Subject: [PATCH 2/6] mac80211: two small verbose debug cleanups
Date: Fri, 22 Jun 2012 19:18:41 +0200
Message-Id: <1340385525-14487-3-git-send-email-johannes@sipsolutions.net> (sfid-20120622_191855_591436_CFFAFDD7)
In-Reply-To: <1340385525-14487-1-git-send-email-johannes@sipsolutions.net>
References: <1340385525-14487-1-git-send-email-johannes@sipsolutions.net>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Johannes Berg <johannes.berg@intel.com>

Two instances of CONFIG_MAC80211_VERBOSE_DEBUG
should be different, fix them.

Signed-off-by: Johannes Berg <johannes.berg@intel.com>
---
 net/mac80211/ibss.c   |    2 +-
 net/mac80211/status.c |    2 +-
 2 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/net/mac80211/ibss.c b/net/mac80211/ibss.c
index ff46ff4..8931110 100644
--- a/net/mac80211/ibss.c
+++ b/net/mac80211/ibss.c
@@ -261,7 +261,7 @@ static struct sta_info *ieee80211_ibss_finish_sta(struct sta_info *sta,
 
 	memcpy(addr, sta->sta.addr, ETH_ALEN);
 
-#ifdef CONFIG_MAC80211_VERBOSE_DEBUG
+#ifdef CONFIG_MAC80211_IBSS_DEBUG
 	wiphy_debug(sdata->local->hw.wiphy,
 		    "Adding new IBSS station %pM (dev=%s)\n",
 		    addr, sdata->name);
diff --git a/net/mac80211/status.c b/net/mac80211/status.c
index 6b4f425..51a6d1e 100644
--- a/net/mac80211/status.c
+++ b/net/mac80211/status.c
@@ -155,7 +155,7 @@ static void ieee80211_handle_filtered_frame(struct ieee80211_local *local,
 		return;
 	}
 
-#ifdef CONFIG_MAC80211_VERBOSE_DEBUG
+#ifdef CONFIG_MAC80211_VERBOSE_PS_DEBUG
 	if (net_ratelimit())
 		wiphy_debug(local->hw.wiphy,
 			    "dropped TX filtered frame, queue_len=%d PS=%d @%lu\n",
-- 
1.7.10

