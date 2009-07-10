Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from xc.sipsolutions.net ([83.246.72.84]:53333 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751056AbZGJN3j (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 10 Jul 2009 09:29:39 -0400
Subject: [PATCH v3] mac80211: monitor the connection
From: Johannes Berg <johannes@sipsolutions.net>
To: John Linville <linville@tuxdriver.com>
Cc: Kalle Valo <kalle.valo@iki.fi>,
	linux-wireless <linux-wireless@vger.kernel.org>
In-Reply-To: <1247186507.1905.14.camel@johannes.local>
References: <1247186507.1905.14.camel@johannes.local>
Content-Type: text/plain
Date: Fri, 10 Jul 2009 15:29:03 +0200
Message-Id: <1247232543.1905.23.camel@johannes.local>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

With the recent MLME rework I accidentally removed the connection
monitoring code. In order to add it back, this patch will add new
code to monitor both for beacon loss and for the connection actually
working, with possibly separate triggers.

When no unicast frames have been received from the AP for (currently)
two seconds, we will send the AP a probe request. Also, when we don't
see beacons from the AP for two seconds, we do the same (but those
times need not be the same due to the way the code is now written).

Additionally, clean up the parameters to the ieee80211_set_disassoc()
function that I need here, those are all useless except sdata.

Signed-off-by: Johannes Berg <johannes@sipsolutions.net>
---
v2: print a message when this happens
v3: don't run beacon monitoring when device does it (IEEE80211_HW_BEACON_FILTER)

 net/mac80211/ieee80211_i.h |   20 ++-
 net/mac80211/mlme.c        |  257 ++++++++++++++++++++++++++++++++++++---------
 net/mac80211/rx.c          |   22 +--
 3 files changed, 227 insertions(+), 72 deletions(-)

--- wireless-testing.orig/net/mac80211/mlme.c	2009-07-09 22:08:56.000000000 +0200
+++ wireless-testing/net/mac80211/mlme.c	2009-07-10 15:27:31.000000000 +0200
@@ -31,8 +31,23 @@
 #define IEEE80211_AUTH_MAX_TRIES 3
 #define IEEE80211_ASSOC_TIMEOUT (HZ / 5)
 #define IEEE80211_ASSOC_MAX_TRIES 3
-#define IEEE80211_MONITORING_INTERVAL (2 * HZ)
-#define IEEE80211_PROBE_WAIT (HZ / 5)
+
+/*
+ * beacon loss detection timeout
+ * XXX: should depend on beacon interval
+ */
+#define IEEE80211_BEACON_LOSS_TIME	(2 * HZ)
+/*
+ * Time the connection can be idle before we probe
+ * it to see if we can still talk to the AP.
+ */
+#define IEEE80211_CONNECTION_IDLE_TIME	(2 * HZ)
+/*
+ * Time we wait for a probe response after sending
+ * a probe request because of beacon loss or for
+ * checking the connection still works.
+ */
+#define IEEE80211_PROBE_WAIT		(HZ / 5)
 
 #define TMR_RUNNING_TIMER	0
 #define TMR_RUNNING_CHANSW	1
@@ -92,6 +107,15 @@ static void run_again(struct ieee80211_i
 		mod_timer(&ifmgd->timer, timeout);
 }
 
+static void mod_beacon_timer(struct ieee80211_sub_if_data *sdata)
+{
+	if (sdata->local->hw.flags & IEEE80211_HW_BEACON_FILTER)
+		return;
+
+	mod_timer(&sdata->u.mgd.bcn_mon_timer,
+		  round_jiffies_up(jiffies + IEEE80211_BEACON_LOSS_TIME));
+}
+
 static int ecw2cw(int ecw)
 {
 	return (1 << ecw) - 1;
@@ -666,7 +690,8 @@ void ieee80211_recalc_ps(struct ieee8021
 
 	if (count == 1 && found->u.mgd.powersave &&
 	    found->u.mgd.associated && list_empty(&found->u.mgd.work_list) &&
-	    !(found->u.mgd.flags & IEEE80211_STA_PROBEREQ_POLL)) {
+	    !(found->u.mgd.flags & (IEEE80211_STA_BEACON_POLL |
+	    			    IEEE80211_STA_CONNECTION_POLL))) {
 		s32 beaconint_us;
 
 		if (latency < 0)
@@ -872,6 +897,10 @@ static void ieee80211_set_associated(str
 	sdata->u.mgd.associated = bss;
 	memcpy(sdata->u.mgd.bssid, bss->cbss.bssid, ETH_ALEN);
 
+	/* just to be sure */
+	sdata->u.mgd.flags &= ~(IEEE80211_STA_CONNECTION_POLL |
+				IEEE80211_STA_BEACON_POLL);
+
 	ieee80211_led_assoc(local, 1);
 
 	sdata->vif.bss_conf.assoc = 1;
@@ -983,16 +1012,21 @@ ieee80211_authenticate(struct ieee80211_
 	return RX_MGMT_NONE;
 }
 
-static void ieee80211_set_disassoc(struct ieee80211_sub_if_data *sdata,
-				   const u8 *bssid, bool deauth)
+static void ieee80211_set_disassoc(struct ieee80211_sub_if_data *sdata)
 {
 	struct ieee80211_if_managed *ifmgd = &sdata->u.mgd;
 	struct ieee80211_local *local = sdata->local;
 	struct sta_info *sta;
 	u32 changed = 0, config_changed = 0;
+	u8 bssid[ETH_ALEN];
 
 	ASSERT_MGD_MTX(ifmgd);
 
+	if (WARN_ON(!ifmgd->associated))
+		return;
+
+	memcpy(bssid, ifmgd->associated->cbss.bssid, ETH_ALEN);
+
 	ifmgd->associated = NULL;
 	memset(ifmgd->bssid, 0, ETH_ALEN);
 
@@ -1112,32 +1146,22 @@ void ieee80211_sta_rx_notify(struct ieee
 	 * from AP because we know that the connection is working both ways
 	 * at that time. But multicast frames (and hence also beacons) must
 	 * be ignored here, because we need to trigger the timer during
-	 * data idle periods for sending the periodical probe request to
-	 * the AP.
+	 * data idle periods for sending the periodic probe request to the
+	 * AP we're connected to.
 	 */
-	if (!is_multicast_ether_addr(hdr->addr1))
-		mod_timer(&sdata->u.mgd.timer,
-			  jiffies + IEEE80211_MONITORING_INTERVAL);
+	if (is_multicast_ether_addr(hdr->addr1))
+		return;
+
+	mod_timer(&sdata->u.mgd.conn_mon_timer,
+		  round_jiffies_up(jiffies + IEEE80211_CONNECTION_IDLE_TIME));
 }
 
-void ieee80211_beacon_loss_work(struct work_struct *work)
+static void ieee80211_mgd_probe_ap(struct ieee80211_sub_if_data *sdata,
+				   bool beacon)
 {
-	struct ieee80211_sub_if_data *sdata =
-		container_of(work, struct ieee80211_sub_if_data,
-			     u.mgd.beacon_loss_work);
 	struct ieee80211_if_managed *ifmgd = &sdata->u.mgd;
 	const u8 *ssid;
-
-	/*
-	 * The driver has already reported this event and we have
-	 * already sent a probe request. Maybe the AP died and the
-	 * driver keeps reporting until we disassociate... We have
-	 * to ignore that because otherwise we would continually
-	 * reset the timer and never check whether we received a
-	 * probe response!
-	 */
-	if (ifmgd->flags & IEEE80211_STA_PROBEREQ_POLL)
-		return;
+	bool already = false;
 
 	mutex_lock(&ifmgd->mtx);
 
@@ -1145,12 +1169,35 @@ void ieee80211_beacon_loss_work(struct w
 		goto out;
 
 #ifdef CONFIG_MAC80211_VERBOSE_DEBUG
-	if (net_ratelimit())
-		printk(KERN_DEBUG "%s: driver reports beacon loss from AP "
+	if (beacon && net_ratelimit())
+		printk(KERN_DEBUG "%s: detected beacon loss from AP "
 		       "- sending probe request\n", sdata->dev->name);
 #endif
 
-	ifmgd->flags |= IEEE80211_STA_PROBEREQ_POLL;
+	/*
+	 * The driver/our work has already reported this event or the
+	 * connection monitoring has kicked in and we have already sent
+	 * a probe request. Or maybe the AP died and the driver keeps
+	 * reporting until we disassociate...
+	 *
+	 * In either case we have to ignore the current call to this
+	 * function (except for setting the correct probe reason bit)
+	 * because otherwise we would reset the timer every time and
+	 * never check whether we received a probe response!
+	 */
+	if (ifmgd->flags & (IEEE80211_STA_BEACON_POLL |
+			    IEEE80211_STA_CONNECTION_POLL))
+		already = true;
+
+	if (beacon)
+		ifmgd->flags |= IEEE80211_STA_BEACON_POLL;
+	else
+		ifmgd->flags |= IEEE80211_STA_CONNECTION_POLL;
+
+	if (already)
+		goto out;
+
+	ifmgd->probe_timeout = jiffies + IEEE80211_PROBE_WAIT;
 
 	mutex_lock(&sdata->local->iflist_mtx);
 	ieee80211_recalc_ps(sdata->local, -1);
@@ -1160,11 +1207,21 @@ void ieee80211_beacon_loss_work(struct w
 	ieee80211_send_probe_req(sdata, ifmgd->associated->cbss.bssid,
 				 ssid + 2, ssid[1], NULL, 0);
 
-	run_again(ifmgd, jiffies + IEEE80211_PROBE_WAIT);
+	run_again(ifmgd, ifmgd->probe_timeout);
+
  out:
 	mutex_unlock(&ifmgd->mtx);
 }
 
+void ieee80211_beacon_loss_work(struct work_struct *work)
+{
+	struct ieee80211_sub_if_data *sdata =
+		container_of(work, struct ieee80211_sub_if_data,
+			     u.mgd.beacon_loss_work);
+
+	ieee80211_mgd_probe_ap(sdata, true);
+}
+
 void ieee80211_beacon_loss(struct ieee80211_vif *vif)
 {
 	struct ieee80211_sub_if_data *sdata = vif_to_sdata(vif);
@@ -1278,7 +1335,7 @@ ieee80211_rx_mgmt_deauth(struct ieee8021
 			sdata->dev->name, bssid, reason_code);
 
 	if (!wk) {
-		ieee80211_set_disassoc(sdata, bssid, true);
+		ieee80211_set_disassoc(sdata);
 	} else {
 		list_del(&wk->list);
 		kfree(wk);
@@ -1311,7 +1368,7 @@ ieee80211_rx_mgmt_disassoc(struct ieee80
 	printk(KERN_DEBUG "%s: disassociated (Reason: %u)\n",
 			sdata->dev->name, reason_code);
 
-	ieee80211_set_disassoc(sdata, ifmgd->associated->cbss.bssid, false);
+	ieee80211_set_disassoc(sdata);
 	return RX_MGMT_CFG80211_DISASSOC;
 }
 
@@ -1412,9 +1469,6 @@ ieee80211_rx_mgmt_assoc_resp(struct ieee
 			return RX_MGMT_NONE;
 		}
 
-		/* update new sta with its last rx activity */
-		sta->last_rx = jiffies;
-
 		set_sta_flags(sta, WLAN_STA_AUTH | WLAN_STA_ASSOC |
 				   WLAN_STA_ASSOC_AP);
 		if (!(ifmgd->flags & IEEE80211_STA_CONTROL_PORT))
@@ -1517,10 +1571,11 @@ ieee80211_rx_mgmt_assoc_resp(struct ieee
 	ieee80211_set_associated(sdata, wk->bss, changed);
 
 	/*
-	 * initialise the time of last beacon to be the association time,
-	 * otherwise beacon loss check will trigger immediately
+	 * Start timer to probe the connection to the AP now.
+	 * Also start the timer that will detect beacon loss.
 	 */
-	ifmgd->last_beacon = jiffies;
+	ieee80211_sta_rx_notify(sdata, (struct ieee80211_hdr *)mgmt);
+	mod_beacon_timer(sdata);
 
 	list_del(&wk->list);
 	kfree(wk);
@@ -1604,11 +1659,22 @@ static void ieee80211_rx_mgmt_probe_resp
 
 	if (ifmgd->associated &&
 	    memcmp(mgmt->bssid, ifmgd->associated->cbss.bssid, ETH_ALEN) == 0 &&
-	    ifmgd->flags & IEEE80211_STA_PROBEREQ_POLL) {
-		ifmgd->flags &= ~IEEE80211_STA_PROBEREQ_POLL;
+	    ifmgd->flags & (IEEE80211_STA_BEACON_POLL |
+	    		    IEEE80211_STA_CONNECTION_POLL)) {
+		ifmgd->flags &= ~(IEEE80211_STA_CONNECTION_POLL |
+				  IEEE80211_STA_BEACON_POLL);
 		mutex_lock(&sdata->local->iflist_mtx);
 		ieee80211_recalc_ps(sdata->local, -1);
 		mutex_unlock(&sdata->local->iflist_mtx);
+		/*
+		 * We've received a probe response, but are not sure whether
+		 * we have or will be receiving any beacons or data, so let's
+		 * schedule the timers again, just in case.
+		 */
+		mod_beacon_timer(sdata);
+		mod_timer(&ifmgd->conn_mon_timer,
+			  round_jiffies_up(jiffies +
+					   IEEE80211_CONNECTION_IDLE_TIME));
 	}
 }
 
@@ -1658,27 +1724,41 @@ static void ieee80211_rx_mgmt_beacon(str
 	if (rx_status->freq != local->hw.conf.channel->center_freq)
 		return;
 
-	if (WARN_ON(!ifmgd->associated))
+	/*
+	 * We might have received a number of frames, among them a
+	 * disassoc frame and a beacon...
+	 */
+	if (!ifmgd->associated)
 		return;
 
 	bssid = ifmgd->associated->cbss.bssid;
 
-	if (WARN_ON(memcmp(bssid, mgmt->bssid, ETH_ALEN) != 0))
+	/*
+	 * And in theory even frames from a different AP we were just
+	 * associated to a split-second ago!
+	 */
+	if (memcmp(bssid, mgmt->bssid, ETH_ALEN) != 0)
 		return;
 
-	if (ifmgd->flags & IEEE80211_STA_PROBEREQ_POLL) {
+	if (ifmgd->flags & IEEE80211_STA_BEACON_POLL) {
 #ifdef CONFIG_MAC80211_VERBOSE_DEBUG
 		if (net_ratelimit()) {
 			printk(KERN_DEBUG "%s: cancelling probereq poll due "
 			       "to a received beacon\n", sdata->dev->name);
 		}
 #endif
-		ifmgd->flags &= ~IEEE80211_STA_PROBEREQ_POLL;
+		ifmgd->flags &= ~IEEE80211_STA_BEACON_POLL;
 		mutex_lock(&local->iflist_mtx);
 		ieee80211_recalc_ps(local, -1);
 		mutex_unlock(&local->iflist_mtx);
 	}
 
+	/*
+	 * Push the beacon loss detection into the future since
+	 * we are processing a beacon from the AP just now.
+	 */
+	mod_beacon_timer(sdata);
+
 	ncrc = crc32_be(0, (void *)&mgmt->u.beacon.beacon_int, 4);
 	ncrc = ieee802_11_parse_elems_crc(mgmt->u.beacon.variable,
 					  len - baselen, &elems,
@@ -1980,6 +2060,37 @@ static void ieee80211_sta_work(struct wo
 	/* then process the rest of the work */
 	mutex_lock(&ifmgd->mtx);
 
+	if (ifmgd->flags & (IEEE80211_STA_BEACON_POLL |
+			    IEEE80211_STA_CONNECTION_POLL) &&
+	    ifmgd->associated) {
+		if (time_is_after_jiffies(ifmgd->probe_timeout))
+			run_again(ifmgd, ifmgd->probe_timeout);
+		else {
+			u8 bssid[ETH_ALEN];
+			/*
+			 * We actually lost the connection ... or did we?
+			 * Let's make sure!
+			 */
+			ifmgd->flags &= ~(IEEE80211_STA_CONNECTION_POLL |
+					  IEEE80211_STA_BEACON_POLL);
+			memcpy(bssid, ifmgd->associated->cbss.bssid, ETH_ALEN);
+			printk(KERN_DEBUG "No probe response from AP %pM"
+				" after %dms, disconnecting.\n",
+				bssid, (1000 * IEEE80211_PROBE_WAIT)/HZ);
+			ieee80211_set_disassoc(sdata);
+			mutex_unlock(&ifmgd->mtx);
+			/*
+			 * must be outside lock due to cfg80211,
+			 * but that's not a problem.
+			 */
+			ieee80211_send_deauth_disassoc(sdata, bssid,
+					IEEE80211_STYPE_DEAUTH,
+					WLAN_REASON_DISASSOC_DUE_TO_INACTIVITY,
+					NULL);
+			mutex_lock(&ifmgd->mtx);
+		}
+	}
+
 	list_for_each_entry(wk, &ifmgd->work_list, list) {
 		if (wk->state != IEEE80211_MGD_STATE_IDLE) {
 			anybusy = true;
@@ -2067,15 +2178,51 @@ static void ieee80211_sta_work(struct wo
 	ieee80211_recalc_idle(local);
 }
 
+static void ieee80211_sta_bcn_mon_timer(unsigned long data)
+{
+	struct ieee80211_sub_if_data *sdata =
+		(struct ieee80211_sub_if_data *) data;
+	struct ieee80211_local *local = sdata->local;
+
+	if (local->quiescing)
+		return;
+
+	queue_work(sdata->local->hw.workqueue,
+		   &sdata->u.mgd.beacon_loss_work);
+}
+
+static void ieee80211_sta_conn_mon_timer(unsigned long data)
+{
+	struct ieee80211_sub_if_data *sdata =
+		(struct ieee80211_sub_if_data *) data;
+	struct ieee80211_if_managed *ifmgd = &sdata->u.mgd;
+	struct ieee80211_local *local = sdata->local;
+
+	if (local->quiescing)
+		return;
+
+	queue_work(local->hw.workqueue, &ifmgd->monitor_work);
+}
+
+static void ieee80211_sta_monitor_work(struct work_struct *work)
+{
+	struct ieee80211_sub_if_data *sdata =
+		container_of(work, struct ieee80211_sub_if_data,
+			     u.mgd.monitor_work);
+
+	ieee80211_mgd_probe_ap(sdata, false);
+}
+
 static void ieee80211_restart_sta_timer(struct ieee80211_sub_if_data *sdata)
 {
 	if (sdata->vif.type == NL80211_IFTYPE_STATION) {
-		/*
-		 * Need to update last_beacon to avoid beacon loss
-		 * test to trigger.
-		 */
-		sdata->u.mgd.last_beacon = jiffies;
+		sdata->u.mgd.flags &= ~(IEEE80211_STA_BEACON_POLL |
+					IEEE80211_STA_CONNECTION_POLL);
 
+		/* let's probe the connection once */
+		queue_work(sdata->local->hw.workqueue,
+			   &sdata->u.mgd.monitor_work);
+		/* and do all the other regular work too */
 		queue_work(sdata->local->hw.workqueue,
 			   &sdata->u.mgd.work);
 	}
@@ -2100,6 +2247,11 @@ void ieee80211_sta_quiesce(struct ieee80
 	cancel_work_sync(&ifmgd->chswitch_work);
 	if (del_timer_sync(&ifmgd->chswitch_timer))
 		set_bit(TMR_RUNNING_CHANSW, &ifmgd->timers_running);
+
+	cancel_work_sync(&ifmgd->monitor_work);
+	/* these will just be re-established on connection */
+	del_timer_sync(&ifmgd->conn_mon_timer);
+	del_timer_sync(&ifmgd->bcn_mon_timer);
 }
 
 void ieee80211_sta_restart(struct ieee80211_sub_if_data *sdata)
@@ -2120,10 +2272,15 @@ void ieee80211_sta_setup_sdata(struct ie
 
 	ifmgd = &sdata->u.mgd;
 	INIT_WORK(&ifmgd->work, ieee80211_sta_work);
+	INIT_WORK(&ifmgd->monitor_work, ieee80211_sta_monitor_work);
 	INIT_WORK(&ifmgd->chswitch_work, ieee80211_chswitch_work);
 	INIT_WORK(&ifmgd->beacon_loss_work, ieee80211_beacon_loss_work);
 	setup_timer(&ifmgd->timer, ieee80211_sta_timer,
 		    (unsigned long) sdata);
+	setup_timer(&ifmgd->bcn_mon_timer, ieee80211_sta_bcn_mon_timer,
+		    (unsigned long) sdata);
+	setup_timer(&ifmgd->conn_mon_timer, ieee80211_sta_conn_mon_timer,
+		    (unsigned long) sdata);
 	setup_timer(&ifmgd->chswitch_timer, ieee80211_chswitch_timer,
 		    (unsigned long) sdata);
 	skb_queue_head_init(&ifmgd->skb_queue);
@@ -2323,7 +2480,7 @@ int ieee80211_mgd_deauth(struct ieee8021
 
 	if (ifmgd->associated && &ifmgd->associated->cbss == req->bss) {
 		bssid = req->bss->bssid;
-		ieee80211_set_disassoc(sdata, bssid, true);
+		ieee80211_set_disassoc(sdata);
 	} else list_for_each_entry(wk, &ifmgd->work_list, list) {
 		if (&wk->bss->cbss == req->bss) {
 			bssid = req->bss->bssid;
@@ -2365,7 +2522,7 @@ int ieee80211_mgd_disassoc(struct ieee80
 		return -ENOLINK;
 	}
 
-	ieee80211_set_disassoc(sdata, req->bss->bssid, false);
+	ieee80211_set_disassoc(sdata);
 
 	mutex_unlock(&ifmgd->mtx);
 
--- wireless-testing.orig/net/mac80211/ieee80211_i.h	2009-07-09 22:06:30.000000000 +0200
+++ wireless-testing/net/mac80211/ieee80211_i.h	2009-07-09 22:14:41.000000000 +0200
@@ -256,12 +256,13 @@ struct ieee80211_mgd_work {
 
 /* flags used in struct ieee80211_if_managed.flags */
 enum ieee80211_sta_flags {
-	IEEE80211_STA_PROBEREQ_POLL	= BIT(3),
-	IEEE80211_STA_CONTROL_PORT	= BIT(4),
-	IEEE80211_STA_WMM_ENABLED	= BIT(5),
-	IEEE80211_STA_DISABLE_11N	= BIT(6),
-	IEEE80211_STA_CSA_RECEIVED	= BIT(7),
-	IEEE80211_STA_MFP_ENABLED	= BIT(8),
+	IEEE80211_STA_BEACON_POLL	= BIT(0),
+	IEEE80211_STA_CONNECTION_POLL	= BIT(1),
+	IEEE80211_STA_CONTROL_PORT	= BIT(2),
+	IEEE80211_STA_WMM_ENABLED	= BIT(3),
+	IEEE80211_STA_DISABLE_11N	= BIT(4),
+	IEEE80211_STA_CSA_RECEIVED	= BIT(5),
+	IEEE80211_STA_MFP_ENABLED	= BIT(6),
 };
 
 /* flags for MLME request */
@@ -271,11 +272,16 @@ enum ieee80211_sta_request {
 
 struct ieee80211_if_managed {
 	struct timer_list timer;
+	struct timer_list conn_mon_timer;
+	struct timer_list bcn_mon_timer;
 	struct timer_list chswitch_timer;
 	struct work_struct work;
+	struct work_struct monitor_work;
 	struct work_struct chswitch_work;
 	struct work_struct beacon_loss_work;
 
+	unsigned long probe_timeout;
+
 	struct mutex mtx;
 	struct ieee80211_bss *associated;
 	struct list_head work_list;
@@ -292,8 +298,6 @@ struct ieee80211_if_managed {
 
 	unsigned long request;
 
-	unsigned long last_beacon;
-
 	unsigned int flags;
 
 	u32 beacon_crc;
--- wireless-testing.orig/net/mac80211/rx.c	2009-07-09 22:06:29.000000000 +0200
+++ wireless-testing/net/mac80211/rx.c	2009-07-10 11:37:22.000000000 +0200
@@ -833,28 +833,22 @@ ieee80211_rx_h_sta_process(struct ieee80
 	if (!sta)
 		return RX_CONTINUE;
 
-	/* Update last_rx only for IBSS packets which are for the current
-	 * BSSID to avoid keeping the current IBSS network alive in cases where
-	 * other STAs are using different BSSID. */
+	/*
+	 * Update last_rx only for IBSS packets which are for the current
+	 * BSSID to avoid keeping the current IBSS network alive in cases
+	 * where other STAs start using different BSSID.
+	 */
 	if (rx->sdata->vif.type == NL80211_IFTYPE_ADHOC) {
 		u8 *bssid = ieee80211_get_bssid(hdr, rx->skb->len,
 						NL80211_IFTYPE_ADHOC);
 		if (compare_ether_addr(bssid, rx->sdata->u.ibss.bssid) == 0)
 			sta->last_rx = jiffies;
-	} else
-	if (!is_multicast_ether_addr(hdr->addr1) ||
-	    rx->sdata->vif.type == NL80211_IFTYPE_STATION) {
-		/* Update last_rx only for unicast frames in order to prevent
-		 * the Probe Request frames (the only broadcast frames from a
-		 * STA in infrastructure mode) from keeping a connection alive.
+	} else if (!is_multicast_ether_addr(hdr->addr1)) {
+		/*
 		 * Mesh beacons will update last_rx when if they are found to
 		 * match the current local configuration when processed.
 		 */
-		if (rx->sdata->vif.type == NL80211_IFTYPE_STATION &&
-		    ieee80211_is_beacon(hdr->frame_control)) {
-			rx->sdata->u.mgd.last_beacon = jiffies;
-		} else
-			sta->last_rx = jiffies;
+		sta->last_rx = jiffies;
 	}
 
 	if (!(rx->flags & IEEE80211_RX_RA_MATCH))


