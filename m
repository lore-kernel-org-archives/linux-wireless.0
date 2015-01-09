Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([5.9.151.49]:46278 "EHLO sipsolutions.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757443AbbAIKto (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 9 Jan 2015 05:49:44 -0500
From: Johannes Berg <johannes@sipsolutions.net>
To: linux-wireless@vger.kernel.org
Cc: j@w1.fi, Johannes Berg <johannes.berg@intel.com>
Subject: [PATCH 2/2] mac80211: fix handling TIM IE when stations disconnect
Date: Fri,  9 Jan 2015 11:49:39 +0100
Message-Id: <1420800579-18723-2-git-send-email-johannes@sipsolutions.net> (sfid-20150109_114950_282481_DEB18313)
In-Reply-To: <1420800579-18723-1-git-send-email-johannes@sipsolutions.net>
References: <1420800579-18723-1-git-send-email-johannes@sipsolutions.net>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Johannes Berg <johannes.berg@intel.com>

When a station disconnects with frames still pending, we clear
the TIM bit, but too late - it's only cleared when the station
is already removed from the driver, and thus the driver can get
confused (and hwsim will loudly complain.)

Fix this by clearing the TIM bit earlier, when the station has
been unlinked but not removed from the driver yet. To do this,
refactor the TIM recalculation to in that case ignore traffic
and simply assume no pending traffic - this is correct for the
disconnected station even though the frames haven't been freed
yet at that point.

This patch isn't needed for current drivers though as they don't
check the station argument to the set_tim() operation and thus
don't really run into the possible confusion.

Reported-by: Jouni Malinen <j@w1.fi>
Signed-off-by: Johannes Berg <johannes.berg@intel.com>
---
 net/mac80211/sta_info.c | 16 +++++++++++++---
 1 file changed, 13 insertions(+), 3 deletions(-)

diff --git a/net/mac80211/sta_info.c b/net/mac80211/sta_info.c
index dc352fcdd469..79383ef0c264 100644
--- a/net/mac80211/sta_info.c
+++ b/net/mac80211/sta_info.c
@@ -116,7 +116,6 @@ static void __cleanup_single_sta(struct sta_info *sta)
 		clear_sta_flag(sta, WLAN_STA_PS_DELIVER);
 
 		atomic_dec(&ps->num_sta_ps);
-		sta_info_recalc_tim(sta);
 	}
 
 	for (ac = 0; ac < IEEE80211_NUM_ACS; ac++) {
@@ -625,7 +624,7 @@ static unsigned long ieee80211_tids_for_ac(int ac)
 	}
 }
 
-void sta_info_recalc_tim(struct sta_info *sta)
+static void __sta_info_recalc_tim(struct sta_info *sta, bool ignore_pending)
 {
 	struct ieee80211_local *local = sta->local;
 	struct ps_data *ps;
@@ -667,6 +666,9 @@ void sta_info_recalc_tim(struct sta_info *sta)
 	if (ignore_for_tim == BIT(IEEE80211_NUM_ACS) - 1)
 		ignore_for_tim = 0;
 
+	if (ignore_pending)
+		ignore_for_tim = BIT(IEEE80211_NUM_ACS) - 1;
+
 	for (ac = 0; ac < IEEE80211_NUM_ACS; ac++) {
 		unsigned long tids;
 
@@ -695,7 +697,7 @@ void sta_info_recalc_tim(struct sta_info *sta)
 	else
 		__bss_tim_clear(ps->tim, id);
 
-	if (local->ops->set_tim) {
+	if (local->ops->set_tim && !WARN_ON(sta->dead)) {
 		local->tim_in_locked_section = true;
 		drv_set_tim(local, &sta->sta, indicate_tim);
 		local->tim_in_locked_section = false;
@@ -705,6 +707,11 @@ out_unlock:
 	spin_unlock_bh(&local->tim_lock);
 }
 
+void sta_info_recalc_tim(struct sta_info *sta)
+{
+	__sta_info_recalc_tim(sta, false);
+}
+
 static bool sta_info_buffer_expired(struct sta_info *sta, struct sk_buff *skb)
 {
 	struct ieee80211_tx_info *info;
@@ -888,6 +895,9 @@ static void __sta_info_destroy_part2(struct sta_info *sta)
 	/* now keys can no longer be reached */
 	ieee80211_free_sta_keys(local, sta);
 
+	/* disable TIM bit - last chance to tell driver */
+	__sta_info_recalc_tim(sta, true);
+
 	sta->dead = true;
 
 	local->num_sta--;
-- 
2.1.1

