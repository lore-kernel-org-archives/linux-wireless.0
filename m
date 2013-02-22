Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:58877 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756536Ab3BVL5Y (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 22 Feb 2013 06:57:24 -0500
From: Johannes Berg <johannes@sipsolutions.net>
To: linux-wireless@vger.kernel.org
Cc: Johannes Berg <johannes.berg@intel.com>
Subject: [PATCH 3.9] mac80211: fix tim_lock locking
Date: Fri, 22 Feb 2013 12:57:18 +0100
Message-Id: <1361534238-446-1-git-send-email-johannes@sipsolutions.net> (sfid-20130222_125727_237416_120590A3)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Johannes Berg <johannes.berg@intel.com>

The ieee80211_beacon_add_tim() function might be called
by drivers with BHs enabled, which causes a potential
deadlock if TX happens at the same time and attempts to
lock the tim_lock as well. Use spin_lock_bh to fix it.

Signed-off-by: Johannes Berg <johannes.berg@intel.com>
---
 net/mac80211/tx.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/net/mac80211/tx.c b/net/mac80211/tx.c
index 5b9602b..5800c7a 100644
--- a/net/mac80211/tx.c
+++ b/net/mac80211/tx.c
@@ -2360,9 +2360,9 @@ static int ieee80211_beacon_add_tim(struct ieee80211_sub_if_data *sdata,
 	if (local->tim_in_locked_section) {
 		__ieee80211_beacon_add_tim(sdata, ps, skb);
 	} else {
-		spin_lock(&local->tim_lock);
+		spin_lock_bh(&local->tim_lock);
 		__ieee80211_beacon_add_tim(sdata, ps, skb);
-		spin_unlock(&local->tim_lock);
+		spin_unlock_bh(&local->tim_lock);
 	}
 
 	return 0;
-- 
1.8.0

