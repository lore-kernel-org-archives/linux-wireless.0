Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:52074 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760009Ab3BMQzr (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 13 Feb 2013 11:55:47 -0500
From: Johannes Berg <johannes@sipsolutions.net>
To: linux-wireless@vger.kernel.org
Cc: Johannes Berg <johannes.berg@intel.com>
Subject: [PATCH] mac80211: use spin_lock_bh() for tim_lock
Date: Wed, 13 Feb 2013 17:55:42 +0100
Message-Id: <1360774542-15342-1-git-send-email-johannes@sipsolutions.net> (sfid-20130213_175550_826130_2593D4AD)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Johannes Berg <johannes.berg@intel.com>

There's no need to use _irqsave() as the lock
is never used in interrupt context.

This also fixes a problem in the iwlwifi MVM
driver that calls spin_unlock_bh() within its
set_tim() callback.

Signed-off-by: Johannes Berg <johannes.berg@intel.com>
---
 net/mac80211/sta_info.c | 5 ++---
 net/mac80211/tx.c       | 6 ++----
 2 files changed, 4 insertions(+), 7 deletions(-)

diff --git a/net/mac80211/sta_info.c b/net/mac80211/sta_info.c
index 07b312e..8c91154 100644
--- a/net/mac80211/sta_info.c
+++ b/net/mac80211/sta_info.c
@@ -573,7 +573,6 @@ void sta_info_recalc_tim(struct sta_info *sta)
 {
 	struct ieee80211_local *local = sta->local;
 	struct ps_data *ps;
-	unsigned long flags;
 	bool indicate_tim = false;
 	u8 ignore_for_tim = sta->sta.uapsd_queues;
 	int ac;
@@ -630,7 +629,7 @@ void sta_info_recalc_tim(struct sta_info *sta)
 	}
 
  done:
-	spin_lock_irqsave(&local->tim_lock, flags);
+	spin_lock_bh(&local->tim_lock);
 
 	if (indicate_tim)
 		__bss_tim_set(ps->tim, id);
@@ -643,7 +642,7 @@ void sta_info_recalc_tim(struct sta_info *sta)
 		local->tim_in_locked_section = false;
 	}
 
-	spin_unlock_irqrestore(&local->tim_lock, flags);
+	spin_unlock_bh(&local->tim_lock);
 }
 
 static bool sta_info_buffer_expired(struct sta_info *sta, struct sk_buff *skb)
diff --git a/net/mac80211/tx.c b/net/mac80211/tx.c
index eef720d..6fdab27 100644
--- a/net/mac80211/tx.c
+++ b/net/mac80211/tx.c
@@ -2365,11 +2365,9 @@ static int ieee80211_beacon_add_tim(struct ieee80211_sub_if_data *sdata,
 	if (local->tim_in_locked_section) {
 		__ieee80211_beacon_add_tim(sdata, ps, skb);
 	} else {
-		unsigned long flags;
-
-		spin_lock_irqsave(&local->tim_lock, flags);
+		spin_lock(&local->tim_lock);
 		__ieee80211_beacon_add_tim(sdata, ps, skb);
-		spin_unlock_irqrestore(&local->tim_lock, flags);
+		spin_unlock(&local->tim_lock);
 	}
 
 	return 0;
-- 
1.8.0

