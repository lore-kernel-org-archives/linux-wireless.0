Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:49161 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755599Ab2KHNII (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 8 Nov 2012 08:08:08 -0500
From: Johannes Berg <johannes@sipsolutions.net>
To: linux-wireless@vger.kernel.org
Cc: Johannes Berg <johannes.berg@intel.com>
Subject: [PATCH] mac80211: don't send null data packet when not associated
Date: Thu,  8 Nov 2012 14:08:42 +0100
Message-Id: <1352380122-18384-1-git-send-email-johannes@sipsolutions.net> (sfid-20121108_140826_775231_430ADDB3)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Johannes Berg <johannes.berg@intel.com>

On resume or firmware recovery, mac80211 sends a null
data packet to see if the AP is still around and hasn't
disconnected us. However, it always does this even if
it wasn't even connected before, leading to a warning
in the new channel context code. Fix this by checking
that it's associated.

Change-Id: I8b77a0b3d3ece9ed509b688711c43aeb5be74348
Signed-off-by: Johannes Berg <johannes.berg@intel.com>
---
 net/mac80211/util.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/net/mac80211/util.c b/net/mac80211/util.c
index 527364f..ba601a8 100644
--- a/net/mac80211/util.c
+++ b/net/mac80211/util.c
@@ -1550,6 +1550,8 @@ int ieee80211_reconfig(struct ieee80211_local *local)
 		list_for_each_entry(sdata, &local->interfaces, list) {
 			if (sdata->vif.type != NL80211_IFTYPE_STATION)
 				continue;
+			if (!sdata->u.mgd.associated)
+				continue;
 
 			ieee80211_send_nullfunc(local, sdata, 0);
 		}
-- 
1.8.0

