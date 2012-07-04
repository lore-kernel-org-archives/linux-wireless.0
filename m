Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:41907 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933181Ab2GDKxu (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 4 Jul 2012 06:53:50 -0400
From: Johannes Berg <johannes@sipsolutions.net>
To: linux-wireless@vger.kernel.org
Cc: Johannes Berg <johannes.berg@intel.com>
Subject: [PATCH] mac80211: fix crash with single-queue drivers
Date: Wed,  4 Jul 2012 12:53:45 +0200
Message-Id: <1341399225-12604-1-git-send-email-johannes@sipsolutions.net> (sfid-20120704_125354_863223_72112624)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Johannes Berg <johannes.berg@intel.com>

Larry (and some others I think) reported that with
single-queue drivers mac80211 crashes when waking
the queues. This happens because we allocate just
a single queue for each virtual interface in case
the driver doesn't have at least 4 queues, but the
code stopping/waking the virtual interface queues
wasn't taking this into account.

Reported-by: Larry Finger <Larry.Finger@lwfinger.net>
Signed-off-by: Johannes Berg <johannes.berg@intel.com>
---
 net/mac80211/util.c |   12 ++++++++++--
 1 file changed, 10 insertions(+), 2 deletions(-)

diff --git a/net/mac80211/util.c b/net/mac80211/util.c
index 26d2103..8f34d2f 100644
--- a/net/mac80211/util.c
+++ b/net/mac80211/util.c
@@ -268,6 +268,10 @@ EXPORT_SYMBOL(ieee80211_ctstoself_duration);
 void ieee80211_propagate_queue_wake(struct ieee80211_local *local, int queue)
 {
 	struct ieee80211_sub_if_data *sdata;
+	int n_acs = IEEE80211_NUM_ACS;
+
+	if (local->hw.queues < IEEE80211_NUM_ACS)
+		n_acs = 1;
 
 	list_for_each_entry_rcu(sdata, &local->interfaces, list) {
 		int ac;
@@ -282,7 +286,7 @@ void ieee80211_propagate_queue_wake(struct ieee80211_local *local, int queue)
 		    local->queue_stop_reasons[sdata->vif.cab_queue] != 0)
 			continue;
 
-		for (ac = 0; ac < IEEE80211_NUM_ACS; ac++) {
+		for (ac = 0; ac < n_acs; ac++) {
 			int ac_queue = sdata->vif.hw_queue[ac];
 
 			if (ac_queue == queue ||
@@ -344,6 +348,7 @@ static void __ieee80211_stop_queue(struct ieee80211_hw *hw, int queue,
 {
 	struct ieee80211_local *local = hw_to_local(hw);
 	struct ieee80211_sub_if_data *sdata;
+	int n_acs = IEEE80211_NUM_ACS;
 
 	trace_stop_queue(local, queue, reason);
 
@@ -355,6 +360,9 @@ static void __ieee80211_stop_queue(struct ieee80211_hw *hw, int queue,
 
 	__set_bit(reason, &local->queue_stop_reasons[queue]);
 
+	if (local->hw.queues < IEEE80211_NUM_ACS)
+		n_acs = 1;
+
 	rcu_read_lock();
 	list_for_each_entry_rcu(sdata, &local->interfaces, list) {
 		int ac;
@@ -362,7 +370,7 @@ static void __ieee80211_stop_queue(struct ieee80211_hw *hw, int queue,
 		if (!sdata->dev)
 			continue;
 
-		for (ac = 0; ac < IEEE80211_NUM_ACS; ac++) {
+		for (ac = 0; ac < n_acs; ac++) {
 			if (sdata->vif.hw_queue[ac] == queue ||
 			    sdata->vif.cab_queue == queue)
 				netif_stop_subqueue(sdata->dev, ac);
-- 
1.7.10

