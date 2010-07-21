Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:40377 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755035Ab0GUJab (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 21 Jul 2010 05:30:31 -0400
Subject: [PATCH] mac80211: proper IBSS locking
From: Johannes Berg <johannes@sipsolutions.net>
To: John Linville <linville@tuxdriver.com>
Cc: linux-wireless <linux-wireless@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Date: Wed, 21 Jul 2010 11:30:27 +0200
Message-ID: <1279704627.3707.9.camel@jlt3.sipsolutions.net>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Johannes Berg <johannes.berg@intel.com>

IBSS has never had locking, instead relying on some
memory barriers etc. That's hard to get right, and
I think we had it wrong too until the previous patch.
Since this is not performance sensitive, it doesn't
make sense to have the maintenance overhead of that,
so add proper locking.

Signed-off-by: Johannes Berg <johannes.berg@intel.com>
---
 net/mac80211/ibss.c        |   97 ++++++++++++++++++++++++---------------------
 net/mac80211/ieee80211_i.h |    7 ---
 2 files changed, 54 insertions(+), 50 deletions(-)

--- wireless-testing.orig/net/mac80211/ibss.c	2010-07-21 11:23:19.000000000 +0200
+++ wireless-testing/net/mac80211/ibss.c	2010-07-21 11:23:21.000000000 +0200
@@ -43,6 +43,8 @@ static void ieee80211_rx_mgmt_auth_ibss(
 {
 	u16 auth_alg, auth_transaction, status_code;
 
+	lockdep_assert_held(&sdata->u.ibss.mtx);
+
 	if (len < 24 + 6)
 		return;
 
@@ -78,6 +80,8 @@ static void __ieee80211_sta_join_ibss(st
 	u32 bss_change;
 	u8 supp_rates[IEEE80211_MAX_SUPP_RATES];
 
+	lockdep_assert_held(&ifibss->mtx);
+
 	/* Reset own TSF to allow time synchronization work. */
 	drv_reset_tsf(local);
 
@@ -205,6 +209,8 @@ static void ieee80211_sta_join_ibss(stru
 	int i, j;
 	u16 beacon_int = cbss->beacon_interval;
 
+	lockdep_assert_held(&sdata->u.ibss.mtx);
+
 	if (beacon_int < 10)
 		beacon_int = 10;
 
@@ -449,6 +455,8 @@ static int ieee80211_sta_active_ibss(str
 	int active = 0;
 	struct sta_info *sta;
 
+	lockdep_assert_held(&sdata->u.ibss.mtx);
+
 	rcu_read_lock();
 
 	list_for_each_entry_rcu(sta, &local->sta_list, list) {
@@ -473,6 +481,8 @@ static void ieee80211_sta_merge_ibss(str
 {
 	struct ieee80211_if_ibss *ifibss = &sdata->u.ibss;
 
+	lockdep_assert_held(&ifibss->mtx);
+
 	mod_timer(&ifibss->timer,
 		  round_jiffies(jiffies + IEEE80211_IBSS_MERGE_INTERVAL));
 
@@ -505,6 +515,8 @@ static void ieee80211_sta_create_ibss(st
 	u16 capability;
 	int i;
 
+	lockdep_assert_held(&ifibss->mtx);
+
 	if (ifibss->fixed_bssid) {
 		memcpy(bssid, ifibss->bssid, ETH_ALEN);
 	} else {
@@ -549,6 +561,8 @@ static void ieee80211_sta_find_ibss(stru
 	int active_ibss;
 	u16 capability;
 
+	lockdep_assert_held(&ifibss->mtx);
+
 	active_ibss = ieee80211_sta_active_ibss(sdata);
 #ifdef CONFIG_MAC80211_IBSS_DEBUG
 	printk(KERN_DEBUG "%s: sta_find_ibss (active_ibss=%d)\n",
@@ -637,6 +651,8 @@ static void ieee80211_rx_mgmt_probe_req(
 	struct ieee80211_mgmt *resp;
 	u8 *pos, *end;
 
+	lockdep_assert_held(&ifibss->mtx);
+
 	if (ifibss->state != IEEE80211_IBSS_MLME_JOINED ||
 	    len < 24 + 2 || !ifibss->presp)
 		return;
@@ -740,6 +756,8 @@ void ieee80211_ibss_rx_queued_mgmt(struc
 	mgmt = (struct ieee80211_mgmt *) skb->data;
 	fc = le16_to_cpu(mgmt->frame_control);
 
+	mutex_lock(&sdata->u.ibss.mtx);
+
 	switch (fc & IEEE80211_FCTL_STYPE) {
 	case IEEE80211_STYPE_PROBE_REQ:
 		ieee80211_rx_mgmt_probe_req(sdata, mgmt, skb->len);
@@ -756,14 +774,23 @@ void ieee80211_ibss_rx_queued_mgmt(struc
 		ieee80211_rx_mgmt_auth_ibss(sdata, mgmt, skb->len);
 		break;
 	}
+
+	mutex_unlock(&sdata->u.ibss.mtx);
 }
 
 void ieee80211_ibss_work(struct ieee80211_sub_if_data *sdata)
 {
 	struct ieee80211_if_ibss *ifibss = &sdata->u.ibss;
 
-	if (!test_and_clear_bit(IEEE80211_IBSS_REQ_RUN, &ifibss->request))
-		return;
+	mutex_lock(&ifibss->mtx);
+
+	/*
+	 * Work could be scheduled after scan or similar
+	 * when we aren't even joined (or trying) with a
+	 * network.
+	 */
+	if (!ifibss->ssid_len)
+		goto out;
 
 	switch (ifibss->state) {
 	case IEEE80211_IBSS_MLME_SEARCH:
@@ -776,15 +803,9 @@ void ieee80211_ibss_work(struct ieee8021
 		WARN_ON(1);
 		break;
 	}
-}
 
-static void ieee80211_queue_ibss_work(struct ieee80211_sub_if_data *sdata)
-{
-	struct ieee80211_if_ibss *ifibss = &sdata->u.ibss;
-	struct ieee80211_local *local = sdata->local;
-
-	set_bit(IEEE80211_IBSS_REQ_RUN, &ifibss->request);
-	ieee80211_queue_work(&local->hw, &sdata->work);
+ out:
+	mutex_unlock(&ifibss->mtx);
 }
 
 static void ieee80211_ibss_timer(unsigned long data)
@@ -799,7 +820,7 @@ static void ieee80211_ibss_timer(unsigne
 		return;
 	}
 
-	ieee80211_queue_ibss_work(sdata);
+	ieee80211_queue_work(&local->hw, &sdata->work);
 }
 
 #ifdef CONFIG_PM
@@ -828,6 +849,7 @@ void ieee80211_ibss_setup_sdata(struct i
 
 	setup_timer(&ifibss->timer, ieee80211_ibss_timer,
 		    (unsigned long) sdata);
+	mutex_init(&ifibss->mtx);
 }
 
 /* scan finished notification */
@@ -841,10 +863,8 @@ void ieee80211_ibss_notify_scan_complete
 			continue;
 		if (sdata->vif.type != NL80211_IFTYPE_ADHOC)
 			continue;
-		if (!sdata->u.ibss.ssid_len)
-			continue;
 		sdata->u.ibss.last_scan_completed = jiffies;
-		ieee80211_queue_ibss_work(sdata);
+		ieee80211_queue_work(&local->hw, &sdata->work);
 	}
 	mutex_unlock(&local->iflist_mtx);
 }
@@ -854,6 +874,17 @@ int ieee80211_ibss_join(struct ieee80211
 {
 	struct sk_buff *skb;
 
+	skb = dev_alloc_skb(sdata->local->hw.extra_tx_headroom +
+			    36 /* bitrates */ +
+			    34 /* SSID */ +
+			    3  /* DS params */ +
+			    4  /* IBSS params */ +
+			    params->ie_len);
+	if (!skb)
+		return -ENOMEM;
+
+	mutex_lock(&sdata->u.ibss.mtx);
+
 	if (params->bssid) {
 		memcpy(sdata->u.ibss.bssid, params->bssid, ETH_ALEN);
 		sdata->u.ibss.fixed_bssid = true;
@@ -882,35 +913,19 @@ int ieee80211_ibss_join(struct ieee80211
 			sdata->u.ibss.ie_len = params->ie_len;
 	}
 
-	skb = dev_alloc_skb(sdata->local->hw.extra_tx_headroom +
-			    36 /* bitrates */ +
-			    34 /* SSID */ +
-			    3  /* DS params */ +
-			    4  /* IBSS params */ +
-			    params->ie_len);
-	if (!skb)
-		return -ENOMEM;
-
 	sdata->u.ibss.skb = skb;
 	sdata->u.ibss.state = IEEE80211_IBSS_MLME_SEARCH;
 	sdata->u.ibss.ibss_join_req = jiffies;
 
 	memcpy(sdata->u.ibss.ssid, params->ssid, IEEE80211_MAX_SSID_LEN);
-
-	/*
-	 * The ssid_len setting below is used to see whether
-	 * we are active, and we need all other settings
-	 * before that may get visible.
-	 */
-	mb();
-
 	sdata->u.ibss.ssid_len = params->ssid_len;
 
 	ieee80211_recalc_idle(sdata->local);
 
-	set_bit(IEEE80211_IBSS_REQ_RUN, &sdata->u.ibss.request);
 	ieee80211_queue_work(&sdata->local->hw, &sdata->work);
 
+	mutex_unlock(&sdata->u.ibss.mtx);
+
 	return 0;
 }
 
@@ -921,7 +936,9 @@ int ieee80211_ibss_leave(struct ieee8021
 	struct ieee80211_local *local = sdata->local;
 	struct cfg80211_bss *cbss;
 	u16 capability;
-	int active_ibss = 0;
+	int active_ibss;
+
+	mutex_lock(&sdata->u.ibss.mtx);
 
 	active_ibss = ieee80211_sta_active_ibss(sdata);
 
@@ -959,19 +976,9 @@ int ieee80211_ibss_leave(struct ieee8021
 	memset(sdata->u.ibss.bssid, 0, ETH_ALEN);
 	sdata->u.ibss.ssid_len = 0;
 
-	/*
-	 * ssid_len indicates active or not, so needs to be visible to
-	 * everybody, especially ieee80211_ibss_notify_scan_completed,
-	 * so it won't restart the timer after we remove it here.
-	 */
-	mb();
-
 	del_timer_sync(&sdata->u.ibss.timer);
-	clear_bit(IEEE80211_IBSS_REQ_RUN, &sdata->u.ibss.request);
-	/*
-	 * Since the REQ_RUN bit is clear, the work won't do
-	 * anything if it runs after this.
-	 */
+
+	mutex_unlock(&sdata->u.ibss.mtx);
 
 	ieee80211_recalc_idle(sdata->local);
 
--- wireless-testing.orig/net/mac80211/ieee80211_i.h	2010-07-21 11:22:31.000000000 +0200
+++ wireless-testing/net/mac80211/ieee80211_i.h	2010-07-21 11:23:21.000000000 +0200
@@ -377,14 +377,11 @@ struct ieee80211_if_managed {
 	int last_cqm_event_signal;
 };
 
-enum ieee80211_ibss_request {
-	IEEE80211_IBSS_REQ_RUN	= 0,
-};
-
 struct ieee80211_if_ibss {
 	struct timer_list timer;
 
-	unsigned long request;
+	struct mutex mtx;
+
 	unsigned long last_scan_completed;
 
 	u32 basic_rates;


