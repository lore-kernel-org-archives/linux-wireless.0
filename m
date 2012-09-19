Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:44240 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755968Ab2ISKH5 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 19 Sep 2012 06:07:57 -0400
From: Johannes Berg <johannes@sipsolutions.net>
To: linux-wireless@vger.kernel.org
Cc: Johannes Berg <johannes.berg@intel.com>
Subject: [PATCH 2/3] mac80211: don't send delBA when removing stations
Date: Wed, 19 Sep 2012 12:08:32 +0200
Message-Id: <1348049313-7650-3-git-send-email-johannes@sipsolutions.net> (sfid-20120919_120805_148102_024AB7FD)
In-Reply-To: <1348049313-7650-1-git-send-email-johannes@sipsolutions.net>
References: <1348049313-7650-1-git-send-email-johannes@sipsolutions.net>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Johannes Berg <johannes.berg@intel.com>

When a station is removed and we stop the aggregation
sessions, it's not useful to send delBA since this is
due to us or the station disassociating or dropping
the connection in some other way, so change that.

Signed-off-by: Johannes Berg <johannes.berg@intel.com>
---
 net/mac80211/sta_info.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/net/mac80211/sta_info.c b/net/mac80211/sta_info.c
index 9c8cd8b..797dd36 100644
--- a/net/mac80211/sta_info.c
+++ b/net/mac80211/sta_info.c
@@ -738,7 +738,7 @@ int __must_check __sta_info_destroy(struct sta_info *sta)
 	 * will be sufficient.
 	 */
 	set_sta_flag(sta, WLAN_STA_BLOCK_BA);
-	ieee80211_sta_tear_down_BA_sessions(sta, true);
+	ieee80211_sta_tear_down_BA_sessions(sta, false);
 
 	ret = sta_info_hash_del(local, sta);
 	if (ret)
-- 
1.7.10.4

