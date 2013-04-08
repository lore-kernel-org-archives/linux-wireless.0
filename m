Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:52504 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1761474Ab3DHLMS (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 8 Apr 2013 07:12:18 -0400
From: Johannes Berg <johannes@sipsolutions.net>
To: linux-wireless@vger.kernel.org
Cc: Johannes Berg <johannes.berg@intel.com>
Subject: [PATCH] mac80211: fix LED in idle handling
Date: Mon,  8 Apr 2013 13:12:13 +0200
Message-Id: <1365419533-29479-1-git-send-email-johannes@sipsolutions.net> (sfid-20130408_131222_338412_5E2F2D26)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Johannes Berg <johannes.berg@intel.com>

feng xiangjun reports that my

commit 382a103b2b528a3085cde4ac56fc69d92a828b72
Author: Johannes Berg <johannes.berg@intel.com>
Date:   Fri Mar 22 22:30:09 2013 +0100

    mac80211: fix idle handling sequence

broke the wireless status LED. The reason is that
we now call ieee80211_idle_off() when the channel
context is assigned, and that doesn't recalculate
the LED state. Fix this by making that function a
wrapper around most of idle recalculation while
forcing active.

Reported-by: feng xiangjun <fengxj325@gmail.com>
Tested-by: feng xiangjun <fengxj325@gmail.com>
Signed-off-by: Johannes Berg <johannes.berg@intel.com>
---
 net/mac80211/iface.c | 27 +++++++++++++++++++--------
 1 file changed, 19 insertions(+), 8 deletions(-)

diff --git a/net/mac80211/iface.c b/net/mac80211/iface.c
index 58150f8..9ed49ad 100644
--- a/net/mac80211/iface.c
+++ b/net/mac80211/iface.c
@@ -78,7 +78,7 @@ void ieee80211_recalc_txpower(struct ieee80211_sub_if_data *sdata)
 		ieee80211_bss_info_change_notify(sdata, BSS_CHANGED_TXPOWER);
 }
 
-u32 ieee80211_idle_off(struct ieee80211_local *local)
+static u32 __ieee80211_idle_off(struct ieee80211_local *local)
 {
 	if (!(local->hw.conf.flags & IEEE80211_CONF_IDLE))
 		return 0;
@@ -87,7 +87,7 @@ u32 ieee80211_idle_off(struct ieee80211_local *local)
 	return IEEE80211_CONF_CHANGE_IDLE;
 }
 
-static u32 ieee80211_idle_on(struct ieee80211_local *local)
+static u32 __ieee80211_idle_on(struct ieee80211_local *local)
 {
 	if (local->hw.conf.flags & IEEE80211_CONF_IDLE)
 		return 0;
@@ -98,16 +98,18 @@ static u32 ieee80211_idle_on(struct ieee80211_local *local)
 	return IEEE80211_CONF_CHANGE_IDLE;
 }
 
-void ieee80211_recalc_idle(struct ieee80211_local *local)
+static u32 __ieee80211_recalc_idle(struct ieee80211_local *local,
+				   bool force_active)
 {
 	bool working = false, scanning, active;
 	unsigned int led_trig_start = 0, led_trig_stop = 0;
 	struct ieee80211_roc_work *roc;
-	u32 change;
 
 	lockdep_assert_held(&local->mtx);
 
-	active = !list_empty(&local->chanctx_list) || local->monitors;
+	active = force_active ||
+		 !list_empty(&local->chanctx_list) ||
+		 local->monitors;
 
 	if (!local->ops->remain_on_channel) {
 		list_for_each_entry(roc, &local->roc_list, list) {
@@ -132,9 +134,18 @@ void ieee80211_recalc_idle(struct ieee80211_local *local)
 	ieee80211_mod_tpt_led_trig(local, led_trig_start, led_trig_stop);
 
 	if (working || scanning || active)
-		change = ieee80211_idle_off(local);
-	else
-		change = ieee80211_idle_on(local);
+		return __ieee80211_idle_off(local);
+	return __ieee80211_idle_on(local);
+}
+
+u32 ieee80211_idle_off(struct ieee80211_local *local)
+{
+	return __ieee80211_recalc_idle(local, true);
+}
+
+void ieee80211_recalc_idle(struct ieee80211_local *local)
+{
+	u32 change = __ieee80211_recalc_idle(local, false);
 	if (change)
 		ieee80211_hw_config(local, change);
 }
-- 
1.8.0

