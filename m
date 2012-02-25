Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:49528 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754544Ab2BYUoB (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 25 Feb 2012 15:44:01 -0500
Message-Id: <20120225204145.926436638@sipsolutions.net> (sfid-20120225_214406_891308_74B9B4D1)
Date: Sat, 25 Feb 2012 21:40:46 +0100
From: Johannes Berg <johannes@sipsolutions.net>
To: John Linville <linville@tuxdriver.com>
Cc: linux-wireless@vger.kernel.org
Subject: [PATCH 2/2] mac80211: fix sta_info_flush() return value
References: <20120225204044.168176239@sipsolutions.net>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Johannes Berg <johannes.berg@intel.com>

The comment for sta_info_flush() states
"Returns the number of removed STA entries"
but that isn't actually true. Consequently,
the warning when a station is still around
on interface removal can never trigger and
this delayed finding the timer issue the
previous patch fixed. Fix the return value
here to make that warning useful again.

Signed-off-by: Johannes Berg <johannes.berg@intel.com>
---
 net/mac80211/sta_info.c |    4 +++-
 1 files changed, 3 insertions(+), 1 deletions(-)

diff --git a/net/mac80211/sta_info.c b/net/mac80211/sta_info.c
index 4034ee6..98613c8 100644
--- a/net/mac80211/sta_info.c
+++ b/net/mac80211/sta_info.c
@@ -865,8 +865,10 @@ int sta_info_flush(struct ieee80211_local *local,
 
 	mutex_lock(&local->sta_mtx);
 	list_for_each_entry_safe(sta, tmp, &local->sta_list, list) {
-		if (!sdata || sdata == sta->sdata)
+		if (!sdata || sdata == sta->sdata) {
 			WARN_ON(__sta_info_destroy(sta));
+			ret++;
+		}
 	}
 	mutex_unlock(&local->sta_mtx);
 


