Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:52063 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758256Ab2GFVFg (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 6 Jul 2012 17:05:36 -0400
From: Johannes Berg <johannes@sipsolutions.net>
To: linux-wireless@vger.kernel.org
Cc: Johannes Berg <johannes.berg@intel.com>
Subject: [RFC 1/3] mac80211: make scan_sdata pointer usable with RCU
Date: Fri,  6 Jul 2012 23:05:31 +0200
Message-Id: <1341608733-7503-2-git-send-email-johannes@sipsolutions.net> (sfid-20120706_230541_009879_89203C90)
In-Reply-To: <1341608733-7503-1-git-send-email-johannes@sipsolutions.net>
References: <1341608733-7503-1-git-send-email-johannes@sipsolutions.net>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Johannes Berg <johannes.berg@intel.com>

Making the scan_sdata pointer usable with RCU makes
it possible to dereference it in the RX path to see
if a received frame actually matches the interface
that is scanning. This is just preparations, making
the pointer __rcu.

Signed-off-by: Johannes Berg <johannes.berg@intel.com>
---
 net/mac80211/ieee80211_i.h |    2 +-
 net/mac80211/iface.c       |    9 +++++----
 net/mac80211/scan.c        |   33 ++++++++++++++++++++++++---------
 3 files changed, 30 insertions(+), 14 deletions(-)

diff --git a/net/mac80211/ieee80211_i.h b/net/mac80211/ieee80211_i.h
index b0830ae..da66a73 100644
--- a/net/mac80211/ieee80211_i.h
+++ b/net/mac80211/ieee80211_i.h
@@ -974,7 +974,7 @@ struct ieee80211_local {
 	unsigned long leave_oper_channel_time;
 	enum mac80211_scan_state next_scan_state;
 	struct delayed_work scan_work;
-	struct ieee80211_sub_if_data *scan_sdata;
+	struct ieee80211_sub_if_data __rcu *scan_sdata;
 	enum nl80211_channel_type _oper_channel_type;
 	struct ieee80211_channel *oper_channel, *csa_channel;
 
diff --git a/net/mac80211/iface.c b/net/mac80211/iface.c
index c4c20cf7..43e1052 100644
--- a/net/mac80211/iface.c
+++ b/net/mac80211/iface.c
@@ -112,10 +112,11 @@ static u32 __ieee80211_recalc_idle(struct ieee80211_local *local)
 		}
 	}
 
-	if (local->scan_sdata &&
-	    !(local->hw.flags & IEEE80211_HW_SCAN_WHILE_IDLE)) {
+	sdata = rcu_dereference_protected(local->scan_sdata,
+					  lockdep_is_held(&local->mtx));
+	if (sdata && !(local->hw.flags & IEEE80211_HW_SCAN_WHILE_IDLE)) {
 		scanning = true;
-		local->scan_sdata->vif.bss_conf.idle = false;
+		sdata->vif.bss_conf.idle = false;
 	}
 
 	list_for_each_entry(sdata, &local->interfaces, list) {
@@ -636,7 +637,7 @@ static void ieee80211_do_stop(struct ieee80211_sub_if_data *sdata,
 
 	clear_bit(SDATA_STATE_RUNNING, &sdata->state);
 
-	if (local->scan_sdata == sdata)
+	if (rcu_access_pointer(local->scan_sdata) == sdata)
 		ieee80211_scan_cancel(local);
 
 	/*
diff --git a/net/mac80211/scan.c b/net/mac80211/scan.c
index d1b4b9d..48d3219 100644
--- a/net/mac80211/scan.c
+++ b/net/mac80211/scan.c
@@ -294,7 +294,13 @@ static void __ieee80211_scan_completed(struct ieee80211_hw *hw, bool aborted,
 		return;
 
 	if (was_hw_scan && !aborted && ieee80211_prep_hw_scan(local)) {
-		int rc = drv_hw_scan(local, local->scan_sdata, local->hw_scan_req);
+		int rc;
+
+		rc = drv_hw_scan(local,
+			rcu_dereference_protected(local->scan_sdata,
+						  lockdep_is_held(&local->mtx)),
+			local->hw_scan_req);
+
 		if (rc == 0)
 			return;
 	}
@@ -395,7 +401,10 @@ void ieee80211_run_deferred_scan(struct ieee80211_local *local)
 	if (!local->scan_req || local->scanning)
 		return;
 
-	if (!ieee80211_can_scan(local, local->scan_sdata))
+	if (!ieee80211_can_scan(local,
+				rcu_dereference_protected(
+					local->scan_sdata,
+					lockdep_is_held(&local->mtx))))
 		return;
 
 	ieee80211_queue_delayed_work(&local->hw, &local->scan_work,
@@ -406,9 +415,12 @@ static void ieee80211_scan_state_send_probe(struct ieee80211_local *local,
 					    unsigned long *next_delay)
 {
 	int i;
-	struct ieee80211_sub_if_data *sdata = local->scan_sdata;
+	struct ieee80211_sub_if_data *sdata;
 	enum ieee80211_band band = local->hw.conf.channel->band;
 
+	sdata = rcu_dereference_protected(local->scan_sdata,
+					  lockdep_is_held(&local->mtx));;
+
 	for (i = 0; i < local->scan_req->n_ssids; i++)
 		ieee80211_send_probe_req(
 			sdata, NULL,
@@ -440,7 +452,7 @@ static int __ieee80211_start_scan(struct ieee80211_sub_if_data *sdata,
 	if (!ieee80211_can_scan(local, sdata)) {
 		/* wait for the work to finish/time out */
 		local->scan_req = req;
-		local->scan_sdata = sdata;
+		rcu_assign_pointer(local->scan_sdata, sdata);
 		return 0;
 	}
 
@@ -474,7 +486,7 @@ static int __ieee80211_start_scan(struct ieee80211_sub_if_data *sdata,
 	}
 
 	local->scan_req = req;
-	local->scan_sdata = sdata;
+	rcu_assign_pointer(local->scan_sdata, sdata);
 
 	if (local->ops->hw_scan) {
 		__set_bit(SCAN_HW_SCANNING, &local->scanning);
@@ -534,7 +546,7 @@ static int __ieee80211_start_scan(struct ieee80211_sub_if_data *sdata,
 		ieee80211_recalc_idle(local);
 
 		local->scan_req = NULL;
-		local->scan_sdata = NULL;
+		rcu_assign_pointer(local->scan_sdata, NULL);
 	}
 
 	return rc;
@@ -721,7 +733,8 @@ void ieee80211_scan_work(struct work_struct *work)
 
 	mutex_lock(&local->mtx);
 
-	sdata = local->scan_sdata;
+	sdata = rcu_dereference_protected(local->scan_sdata,
+					  lockdep_is_held(&local->mtx));
 
 	/* When scanning on-channel, the first-callback means completed. */
 	if (test_bit(SCAN_ONCHANNEL_SCANNING, &local->scanning)) {
@@ -742,7 +755,7 @@ void ieee80211_scan_work(struct work_struct *work)
 		int rc;
 
 		local->scan_req = NULL;
-		local->scan_sdata = NULL;
+		rcu_assign_pointer(local->scan_sdata, NULL);
 
 		rc = __ieee80211_start_scan(sdata, req);
 		if (rc) {
@@ -894,7 +907,9 @@ void ieee80211_scan_cancel(struct ieee80211_local *local)
 
 	if (test_bit(SCAN_HW_SCANNING, &local->scanning)) {
 		if (local->ops->cancel_hw_scan)
-			drv_cancel_hw_scan(local, local->scan_sdata);
+			drv_cancel_hw_scan(local,
+				rcu_dereference_protected(local->scan_sdata,
+						lockdep_is_held(&local->mtx)));
 		goto out;
 	}
 
-- 
1.7.10.4

