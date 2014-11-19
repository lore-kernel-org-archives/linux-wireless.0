Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([5.9.151.49]:39962 "EHLO sipsolutions.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755862AbaKSRfL (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 19 Nov 2014 12:35:11 -0500
From: Johannes Berg <johannes@sipsolutions.net>
To: linux-wireless@vger.kernel.org
Cc: Johannes Berg <johannes.berg@intel.com>
Subject: [PATCH 2/4] mac80211: rcu-ify scan and scheduled scan request pointers
Date: Wed, 19 Nov 2014 18:35:03 +0100
Message-Id: <1416418505-7359-3-git-send-email-johannes@sipsolutions.net> (sfid-20141119_183524_287956_37EBA359)
In-Reply-To: <1416418505-7359-1-git-send-email-johannes@sipsolutions.net>
References: <1416418505-7359-1-git-send-email-johannes@sipsolutions.net>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Johannes Berg <johannes.berg@intel.com>

In order to use the scan and scheduled scan request pointers during
RX to check for randomisation, make them accessible using RCU.

Change-Id: Ic3674042303055a26900c8aaca9490a70a389392
Signed-off-by: Johannes Berg <johannes.berg@intel.com>
Reviewed-on: https://gerrit.rds.intel.com/r/47601
Reviewed-by: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
Tested-by: IWL Jenkins
---
 net/mac80211/ieee80211_i.h |  4 +--
 net/mac80211/scan.c        | 79 ++++++++++++++++++++++++++++------------------
 net/mac80211/util.c        |  7 ++--
 3 files changed, 56 insertions(+), 34 deletions(-)

diff --git a/net/mac80211/ieee80211_i.h b/net/mac80211/ieee80211_i.h
index 34168c21bf06..dd27180060b9 100644
--- a/net/mac80211/ieee80211_i.h
+++ b/net/mac80211/ieee80211_i.h
@@ -1238,7 +1238,7 @@ struct ieee80211_local {
 	unsigned long scanning;
 	struct cfg80211_ssid scan_ssid;
 	struct cfg80211_scan_request *int_scan_req;
-	struct cfg80211_scan_request *scan_req;
+	struct cfg80211_scan_request __rcu *scan_req;
 	struct ieee80211_scan_request *hw_scan_req;
 	struct cfg80211_chan_def scan_chandef;
 	enum ieee80211_band hw_scan_band;
@@ -1248,7 +1248,7 @@ struct ieee80211_local {
 
 	struct work_struct sched_scan_stopped_work;
 	struct ieee80211_sub_if_data __rcu *sched_scan_sdata;
-	struct cfg80211_sched_scan_request *sched_scan_req;
+	struct cfg80211_sched_scan_request __rcu *sched_scan_req;
 
 	unsigned long leave_oper_channel_time;
 	enum mac80211_scan_state next_scan_state;
diff --git a/net/mac80211/scan.c b/net/mac80211/scan.c
index d23c8d90c3b4..e75e64b8042c 100644
--- a/net/mac80211/scan.c
+++ b/net/mac80211/scan.c
@@ -234,11 +234,14 @@ ieee80211_prepare_scan_chandef(struct cfg80211_chan_def *chandef,
 /* return false if no more work */
 static bool ieee80211_prep_hw_scan(struct ieee80211_local *local)
 {
-	struct cfg80211_scan_request *req = local->scan_req;
+	struct cfg80211_scan_request *req;
 	struct cfg80211_chan_def chandef;
 	u8 bands_used = 0;
 	int i, ielen, n_chans;
 
+	req = rcu_dereference_protected(local->scan_req,
+					lockdep_is_held(&local->mtx));
+
 	if (test_bit(SCAN_HW_CANCELLED, &local->scanning))
 		return false;
 
@@ -290,6 +293,7 @@ static void __ieee80211_scan_completed(struct ieee80211_hw *hw, bool aborted)
 	struct ieee80211_local *local = hw_to_local(hw);
 	bool hw_scan = local->ops->hw_scan;
 	bool was_scanning = local->scanning;
+	struct cfg80211_scan_request *scan_req;
 
 	lockdep_assert_held(&local->mtx);
 
@@ -322,9 +326,12 @@ static void __ieee80211_scan_completed(struct ieee80211_hw *hw, bool aborted)
 	kfree(local->hw_scan_req);
 	local->hw_scan_req = NULL;
 
-	if (local->scan_req != local->int_scan_req)
-		cfg80211_scan_done(local->scan_req, aborted);
-	local->scan_req = NULL;
+	scan_req = rcu_dereference_protected(local->scan_req,
+					     lockdep_is_held(&local->mtx));
+
+	if (scan_req != local->int_scan_req)
+		cfg80211_scan_done(scan_req, aborted);
+	RCU_INIT_POINTER(local->scan_req, NULL);
 	RCU_INIT_POINTER(local->scan_sdata, NULL);
 
 	local->scanning = 0;
@@ -440,23 +447,26 @@ static void ieee80211_scan_state_send_probe(struct ieee80211_local *local,
 {
 	int i;
 	struct ieee80211_sub_if_data *sdata;
+	struct cfg80211_scan_request *scan_req;
 	enum ieee80211_band band = local->hw.conf.chandef.chan->band;
 	u32 tx_flags;
 
+	scan_req = rcu_dereference_protected(local->scan_req,
+					     lockdep_is_held(&local->mtx));
+
 	tx_flags = IEEE80211_TX_INTFL_OFFCHAN_TX_OK;
-	if (local->scan_req->no_cck)
+	if (scan_req->no_cck)
 		tx_flags |= IEEE80211_TX_CTL_NO_CCK_RATE;
 
 	sdata = rcu_dereference_protected(local->scan_sdata,
 					  lockdep_is_held(&local->mtx));
 
-	for (i = 0; i < local->scan_req->n_ssids; i++)
+	for (i = 0; i < scan_req->n_ssids; i++)
 		ieee80211_send_probe_req(
 			sdata, NULL,
-			local->scan_req->ssids[i].ssid,
-			local->scan_req->ssids[i].ssid_len,
-			local->scan_req->ie, local->scan_req->ie_len,
-			local->scan_req->rates[band], false,
+			scan_req->ssids[i].ssid, scan_req->ssids[i].ssid_len,
+			scan_req->ie, scan_req->ie_len,
+			scan_req->rates[band], false,
 			tx_flags, local->hw.conf.chandef.chan, true);
 
 	/*
@@ -480,7 +490,7 @@ static int __ieee80211_start_scan(struct ieee80211_sub_if_data *sdata,
 
 	if (!ieee80211_can_scan(local, sdata)) {
 		/* wait for the work to finish/time out */
-		local->scan_req = req;
+		rcu_assign_pointer(local->scan_req, req);
 		rcu_assign_pointer(local->scan_sdata, sdata);
 		return 0;
 	}
@@ -530,7 +540,7 @@ static int __ieee80211_start_scan(struct ieee80211_sub_if_data *sdata,
 		 */
 	}
 
-	local->scan_req = req;
+	rcu_assign_pointer(local->scan_req, req);
 	rcu_assign_pointer(local->scan_sdata, sdata);
 
 	if (local->ops->hw_scan) {
@@ -558,7 +568,7 @@ static int __ieee80211_start_scan(struct ieee80211_sub_if_data *sdata,
 
 		if ((req->channels[0]->flags &
 		     IEEE80211_CHAN_NO_IR) ||
-		    !local->scan_req->n_ssids) {
+		    !req->n_ssids) {
 			next_delay = IEEE80211_PASSIVE_CHANNEL_TIME;
 		} else {
 			ieee80211_scan_state_send_probe(local, &next_delay);
@@ -617,6 +627,7 @@ static void ieee80211_scan_state_decision(struct ieee80211_local *local,
 	struct ieee80211_sub_if_data *sdata;
 	struct ieee80211_channel *next_chan;
 	enum mac80211_scan_state next_scan_state;
+	struct cfg80211_scan_request *scan_req;
 
 	/*
 	 * check if at least one STA interface is associated,
@@ -641,7 +652,10 @@ static void ieee80211_scan_state_decision(struct ieee80211_local *local,
 	}
 	mutex_unlock(&local->iflist_mtx);
 
-	next_chan = local->scan_req->channels[local->scan_channel_idx];
+	scan_req = rcu_dereference_protected(local->scan_req,
+					     lockdep_is_held(&local->mtx));
+
+	next_chan = scan_req->channels[local->scan_channel_idx];
 
 	/*
 	 * we're currently scanning a different channel, let's
@@ -656,7 +670,7 @@ static void ieee80211_scan_state_decision(struct ieee80211_local *local,
 				 local->leave_oper_channel_time + HZ / 8);
 
 	if (associated && !tx_empty) {
-		if (local->scan_req->flags & NL80211_SCAN_FLAG_LOW_PRIORITY)
+		if (scan_req->flags & NL80211_SCAN_FLAG_LOW_PRIORITY)
 			next_scan_state = SCAN_ABORT;
 		else
 			next_scan_state = SCAN_SUSPEND;
@@ -677,14 +691,18 @@ static void ieee80211_scan_state_set_channel(struct ieee80211_local *local,
 	int skip;
 	struct ieee80211_channel *chan;
 	enum nl80211_bss_scan_width oper_scan_width;
+	struct cfg80211_scan_request *scan_req;
+
+	scan_req = rcu_dereference_protected(local->scan_req,
+					     lockdep_is_held(&local->mtx));
 
 	skip = 0;
-	chan = local->scan_req->channels[local->scan_channel_idx];
+	chan = scan_req->channels[local->scan_channel_idx];
 
 	local->scan_chandef.chan = chan;
 	local->scan_chandef.center_freq1 = chan->center_freq;
 	local->scan_chandef.center_freq2 = 0;
-	switch (local->scan_req->scan_width) {
+	switch (scan_req->scan_width) {
 	case NL80211_BSS_CHAN_WIDTH_5:
 		local->scan_chandef.width = NL80211_CHAN_WIDTH_5;
 		break;
@@ -698,7 +716,7 @@ static void ieee80211_scan_state_set_channel(struct ieee80211_local *local,
 		oper_scan_width = cfg80211_chandef_to_scan_width(
 					&local->_oper_chandef);
 		if (chan == local->_oper_chandef.chan &&
-		    oper_scan_width == local->scan_req->scan_width)
+		    oper_scan_width == scan_req->scan_width)
 			local->scan_chandef = local->_oper_chandef;
 		else
 			local->scan_chandef.width = NL80211_CHAN_WIDTH_20_NOHT;
@@ -727,8 +745,7 @@ static void ieee80211_scan_state_set_channel(struct ieee80211_local *local,
 	 *
 	 * In any case, it is not necessary for a passive scan.
 	 */
-	if (chan->flags & IEEE80211_CHAN_NO_IR ||
-	    !local->scan_req->n_ssids) {
+	if (chan->flags & IEEE80211_CHAN_NO_IR || !scan_req->n_ssids) {
 		*next_delay = IEEE80211_PASSIVE_CHANNEL_TIME;
 		local->next_scan_state = SCAN_DECISION;
 		return;
@@ -777,6 +794,7 @@ void ieee80211_scan_work(struct work_struct *work)
 	struct ieee80211_local *local =
 		container_of(work, struct ieee80211_local, scan_work.work);
 	struct ieee80211_sub_if_data *sdata;
+	struct cfg80211_scan_request *scan_req;
 	unsigned long next_delay = 0;
 	bool aborted;
 
@@ -784,6 +802,8 @@ void ieee80211_scan_work(struct work_struct *work)
 
 	sdata = rcu_dereference_protected(local->scan_sdata,
 					  lockdep_is_held(&local->mtx));
+	scan_req = rcu_dereference_protected(local->scan_req,
+					     lockdep_is_held(&local->mtx));
 
 	/* When scanning on-channel, the first-callback means completed. */
 	if (test_bit(SCAN_ONCHANNEL_SCANNING, &local->scanning)) {
@@ -796,20 +816,19 @@ void ieee80211_scan_work(struct work_struct *work)
 		goto out_complete;
 	}
 
-	if (!sdata || !local->scan_req)
+	if (!sdata || !scan_req)
 		goto out;
 
 	if (!local->scanning) {
-		struct cfg80211_scan_request *req = local->scan_req;
 		int rc;
 
-		local->scan_req = NULL;
+		RCU_INIT_POINTER(local->scan_req, NULL);
 		RCU_INIT_POINTER(local->scan_sdata, NULL);
 
-		rc = __ieee80211_start_scan(sdata, req);
+		rc = __ieee80211_start_scan(sdata, scan_req);
 		if (rc) {
 			/* need to complete scan in cfg80211 */
-			local->scan_req = req;
+			rcu_assign_pointer(local->scan_req, scan_req);
 			aborted = true;
 			goto out_complete;
 		} else
@@ -829,7 +848,7 @@ void ieee80211_scan_work(struct work_struct *work)
 		switch (local->next_scan_state) {
 		case SCAN_DECISION:
 			/* if no more bands/channels left, complete scan */
-			if (local->scan_channel_idx >= local->scan_req->n_channels) {
+			if (local->scan_channel_idx >= scan_req->n_channels) {
 				aborted = false;
 				goto out_complete;
 			}
@@ -1043,7 +1062,7 @@ int __ieee80211_request_sched_scan_start(struct ieee80211_sub_if_data *sdata,
 	ret = drv_sched_scan_start(local, sdata, req, &sched_scan_ies);
 	if (ret == 0) {
 		rcu_assign_pointer(local->sched_scan_sdata, sdata);
-		local->sched_scan_req = req;
+		rcu_assign_pointer(local->sched_scan_req, req);
 	}
 
 	kfree(ie);
@@ -1052,7 +1071,7 @@ out:
 	if (ret) {
 		/* Clean in case of failure after HW restart or upon resume. */
 		RCU_INIT_POINTER(local->sched_scan_sdata, NULL);
-		local->sched_scan_req = NULL;
+		RCU_INIT_POINTER(local->sched_scan_req, NULL);
 	}
 
 	return ret;
@@ -1090,7 +1109,7 @@ int ieee80211_request_sched_scan_stop(struct ieee80211_sub_if_data *sdata)
 	}
 
 	/* We don't want to restart sched scan anymore. */
-	local->sched_scan_req = NULL;
+	RCU_INIT_POINTER(local->sched_scan_req, NULL);
 
 	if (rcu_access_pointer(local->sched_scan_sdata)) {
 		ret = drv_sched_scan_stop(local, sdata);
@@ -1125,7 +1144,7 @@ void ieee80211_sched_scan_end(struct ieee80211_local *local)
 	RCU_INIT_POINTER(local->sched_scan_sdata, NULL);
 
 	/* If sched scan was aborted by the driver. */
-	local->sched_scan_req = NULL;
+	RCU_INIT_POINTER(local->sched_scan_req, NULL);
 
 	mutex_unlock(&local->mtx);
 
diff --git a/net/mac80211/util.c b/net/mac80211/util.c
index 745a8a9cbbb5..0ad534abc008 100644
--- a/net/mac80211/util.c
+++ b/net/mac80211/util.c
@@ -1721,6 +1721,7 @@ int ieee80211_reconfig(struct ieee80211_local *local)
 	int res, i;
 	bool reconfig_due_to_wowlan = false;
 	struct ieee80211_sub_if_data *sched_scan_sdata;
+	struct cfg80211_sched_scan_request *sched_scan_req;
 	bool sched_scan_stopped = false;
 
 #ifdef CONFIG_PM
@@ -2011,13 +2012,15 @@ int ieee80211_reconfig(struct ieee80211_local *local)
 	mutex_lock(&local->mtx);
 	sched_scan_sdata = rcu_dereference_protected(local->sched_scan_sdata,
 						lockdep_is_held(&local->mtx));
-	if (sched_scan_sdata && local->sched_scan_req)
+	sched_scan_req = rcu_dereference_protected(local->sched_scan_req,
+						lockdep_is_held(&local->mtx));
+	if (sched_scan_sdata && sched_scan_req)
 		/*
 		 * Sched scan stopped, but we don't want to report it. Instead,
 		 * we're trying to reschedule.
 		 */
 		if (__ieee80211_request_sched_scan_start(sched_scan_sdata,
-							 local->sched_scan_req))
+							 sched_scan_req))
 			sched_scan_stopped = true;
 	mutex_unlock(&local->mtx);
 
-- 
2.1.1

