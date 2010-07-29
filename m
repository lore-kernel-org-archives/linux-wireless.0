Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:47480 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753806Ab0G2OJP (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 29 Jul 2010 10:09:15 -0400
Subject: [PATCH] mac80211: allow drivers to request DTIM period
From: Johannes Berg <johannes@sipsolutions.net>
To: John Linville <linville@tuxdriver.com>
Cc: linux-wireless <linux-wireless@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Date: Thu, 29 Jul 2010 16:08:55 +0200
Message-ID: <1280412535.3823.11.camel@jlt3.sipsolutions.net>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Johannes Berg <johannes.berg@intel.com>

Some features require knowing the DTIM period
before associating. This implements the ability
to wait for a beacon in mac80211 before assoc
to provide this value. It is optional since
most likely not all drivers will need this.

Signed-off-by: Johannes Berg <johannes.berg@intel.com>
---
 include/net/mac80211.h     |    9 +++++++--
 net/mac80211/ieee80211_i.h |    1 +
 net/mac80211/mlme.c        |   32 +++++++++++++++++++++++++++++---
 net/mac80211/scan.c        |    4 ++++
 net/mac80211/work.c        |   43 +++++++++++++++++++++++++++++++++++++++++++
 5 files changed, 84 insertions(+), 5 deletions(-)

diff --git a/include/net/mac80211.h b/include/net/mac80211.h
index 20d372e..c0d9af7 100644
--- a/include/net/mac80211.h
+++ b/include/net/mac80211.h
@@ -194,7 +194,9 @@ enum ieee80211_bss_change {
  *	if the hardware cannot handle this it must set the
  *	IEEE80211_HW_2GHZ_SHORT_SLOT_INCAPABLE hardware flag
  * @dtim_period: num of beacons before the next DTIM, for beaconing,
- *	not valid in station mode (cf. hw conf ps_dtim_period)
+ *	valid in station mode only while @assoc is true and if also
+ *	requested by %IEEE80211_HW_NEED_DTIM_PERIOD (cf. also hw conf
+ *	@ps_dtim_period)
  * @timestamp: beacon timestamp
  * @beacon_int: beacon interval
  * @assoc_capability: capabilities taken from assoc resp
@@ -1024,6 +1026,9 @@ enum ieee80211_tkip_key_type {
  *	connection quality related parameters, such as the RSSI level and
  *	provide notifications if configured trigger levels are reached.
  *
+ * @IEEE80211_HW_NEED_DTIM_PERIOD:
+ *	This device needs to know the DTIM period for the BSS before
+ *	associating.
  */
 enum ieee80211_hw_flags {
 	IEEE80211_HW_HAS_RATE_CONTROL			= 1<<0,
@@ -1033,7 +1038,7 @@ enum ieee80211_hw_flags {
 	IEEE80211_HW_2GHZ_SHORT_PREAMBLE_INCAPABLE	= 1<<4,
 	IEEE80211_HW_SIGNAL_UNSPEC			= 1<<5,
 	IEEE80211_HW_SIGNAL_DBM				= 1<<6,
-	/* use this hole */
+	IEEE80211_HW_NEED_DTIM_PERIOD			= 1<<7,
 	IEEE80211_HW_SPECTRUM_MGMT			= 1<<8,
 	IEEE80211_HW_AMPDU_AGGREGATION			= 1<<9,
 	IEEE80211_HW_SUPPORTS_PS			= 1<<10,
diff --git a/net/mac80211/ieee80211_i.h b/net/mac80211/ieee80211_i.h
index ef47006..65e0ed6 100644
--- a/net/mac80211/ieee80211_i.h
+++ b/net/mac80211/ieee80211_i.h
@@ -238,6 +238,7 @@ enum ieee80211_work_type {
 	IEEE80211_WORK_ABORT,
 	IEEE80211_WORK_DIRECT_PROBE,
 	IEEE80211_WORK_AUTH,
+	IEEE80211_WORK_ASSOC_BEACON_WAIT,
 	IEEE80211_WORK_ASSOC,
 	IEEE80211_WORK_REMAIN_ON_CHANNEL,
 };
diff --git a/net/mac80211/mlme.c b/net/mac80211/mlme.c
index cf8d721..b6c163a 100644
--- a/net/mac80211/mlme.c
+++ b/net/mac80211/mlme.c
@@ -870,6 +870,11 @@ static void ieee80211_set_associated(struct ieee80211_sub_if_data *sdata,
 
 	ieee80211_led_assoc(local, 1);
 
+	if (local->hw.flags & IEEE80211_HW_NEED_DTIM_PERIOD)
+		bss_conf->dtim_period = bss->dtim_period;
+	else
+		bss_conf->dtim_period = 0;
+
 	bss_conf->assoc = 1;
 	/*
 	 * For now just always ask the driver to update the basic rateset
@@ -1751,7 +1756,8 @@ void ieee80211_sta_rx_queued_mgmt(struct ieee80211_sub_if_data *sdata,
 			if (wk->sdata != sdata)
 				continue;
 
-			if (wk->type != IEEE80211_WORK_ASSOC)
+			if (wk->type != IEEE80211_WORK_ASSOC &&
+			    wk->type != IEEE80211_WORK_ASSOC_BEACON_WAIT)
 				continue;
 
 			if (memcmp(mgmt->bssid, wk->filter_ta, ETH_ALEN))
@@ -2086,6 +2092,8 @@ static enum work_done_result ieee80211_assoc_done(struct ieee80211_work *wk,
 						  struct sk_buff *skb)
 {
 	struct ieee80211_mgmt *mgmt;
+	struct ieee80211_rx_status *rx_status;
+	struct ieee802_11_elems elems;
 	u16 status;
 
 	if (!skb) {
@@ -2093,6 +2101,19 @@ static enum work_done_result ieee80211_assoc_done(struct ieee80211_work *wk,
 		return WORK_DONE_DESTROY;
 	}
 
+	if (wk->type == IEEE80211_WORK_ASSOC_BEACON_WAIT) {
+		mutex_lock(&wk->sdata->u.mgd.mtx);
+		rx_status = (void *) skb->cb;
+		ieee802_11_parse_elems(skb->data + 24 + 12, skb->len - 24 - 12, &elems);
+		ieee80211_rx_bss_info(wk->sdata, (void *)skb->data, skb->len, rx_status,
+				      &elems, true);
+		mutex_unlock(&wk->sdata->u.mgd.mtx);
+
+		wk->type = IEEE80211_WORK_ASSOC;
+		/* not really done yet */
+		return WORK_DONE_REQUEUE;
+	}
+
 	mgmt = (void *)skb->data;
 	status = le16_to_cpu(mgmt->u.assoc_resp.status_code);
 
@@ -2206,10 +2227,14 @@ int ieee80211_mgd_assoc(struct ieee80211_sub_if_data *sdata,
 	if (req->prev_bssid)
 		memcpy(wk->assoc.prev_bssid, req->prev_bssid, ETH_ALEN);
 
-	wk->type = IEEE80211_WORK_ASSOC;
 	wk->chan = req->bss->channel;
 	wk->sdata = sdata;
 	wk->done = ieee80211_assoc_done;
+	if (!bss->dtim_period &&
+	    sdata->local->hw.flags & IEEE80211_HW_NEED_DTIM_PERIOD)
+		wk->type = IEEE80211_WORK_ASSOC_BEACON_WAIT;
+	else
+		wk->type = IEEE80211_WORK_ASSOC;
 
 	if (req->use_mfp) {
 		ifmgd->mfp = IEEE80211_MFP_REQUIRED;
@@ -2257,7 +2282,8 @@ int ieee80211_mgd_deauth(struct ieee80211_sub_if_data *sdata,
 
 			if (wk->type != IEEE80211_WORK_DIRECT_PROBE &&
 			    wk->type != IEEE80211_WORK_AUTH &&
-			    wk->type != IEEE80211_WORK_ASSOC)
+			    wk->type != IEEE80211_WORK_ASSOC &&
+			    wk->type != IEEE80211_WORK_ASSOC_BEACON_WAIT)
 				continue;
 
 			if (memcmp(req->bss->bssid, wk->filter_ta, ETH_ALEN))
diff --git a/net/mac80211/scan.c b/net/mac80211/scan.c
index 4dcbf8b..d3209f4 100644
--- a/net/mac80211/scan.c
+++ b/net/mac80211/scan.c
@@ -115,6 +115,10 @@ ieee80211_bss_info_update(struct ieee80211_local *local,
 		bss->dtim_period = tim_ie->dtim_period;
 	}
 
+	/* If the beacon had no TIM IE, or it was invalid, use 1 */
+	if (beacon && !bss->dtim_period)
+		bss->dtim_period = 1;
+
 	/* replace old supported rates if we get new values */
 	srlen = 0;
 	if (elems->supp_rates) {
diff --git a/net/mac80211/work.c b/net/mac80211/work.c
index c22a71c..81d4ad6 100644
--- a/net/mac80211/work.c
+++ b/net/mac80211/work.c
@@ -560,6 +560,22 @@ ieee80211_remain_on_channel_timeout(struct ieee80211_work *wk)
 	return WORK_ACT_TIMEOUT;
 }
 
+static enum work_action __must_check
+ieee80211_assoc_beacon_wait(struct ieee80211_work *wk)
+{
+	if (wk->started)
+		return WORK_ACT_TIMEOUT;
+
+	/*
+	 * Wait up to one beacon interval ...
+	 * should this be more if we miss one?
+	 */
+	printk(KERN_DEBUG "%s: waiting for beacon from %pM\n",
+	       wk->sdata->name, wk->filter_ta);
+	wk->timeout = TU_TO_EXP_TIME(wk->assoc.bss->beacon_interval);
+	return WORK_ACT_NONE;
+}
+
 static void ieee80211_auth_challenge(struct ieee80211_work *wk,
 				     struct ieee80211_mgmt *mgmt,
 				     size_t len)
@@ -709,6 +725,25 @@ ieee80211_rx_mgmt_probe_resp(struct ieee80211_work *wk,
 	return WORK_ACT_DONE;
 }
 
+static enum work_action __must_check
+ieee80211_rx_mgmt_beacon(struct ieee80211_work *wk,
+			 struct ieee80211_mgmt *mgmt, size_t len)
+{
+	struct ieee80211_sub_if_data *sdata = wk->sdata;
+	struct ieee80211_local *local = sdata->local;
+
+	ASSERT_WORK_MTX(local);
+
+	if (wk->type != IEEE80211_WORK_ASSOC_BEACON_WAIT)
+		return WORK_ACT_MISMATCH;
+
+	if (len < 24 + 12)
+		return WORK_ACT_NONE;
+
+	printk(KERN_DEBUG "%s: beacon received\n", sdata->name);
+	return WORK_ACT_DONE;
+}
+
 static void ieee80211_work_rx_queued_mgmt(struct ieee80211_local *local,
 					  struct sk_buff *skb)
 {
@@ -731,6 +766,7 @@ static void ieee80211_work_rx_queued_mgmt(struct ieee80211_local *local,
 		case IEEE80211_WORK_DIRECT_PROBE:
 		case IEEE80211_WORK_AUTH:
 		case IEEE80211_WORK_ASSOC:
+		case IEEE80211_WORK_ASSOC_BEACON_WAIT:
 			bssid = wk->filter_ta;
 			break;
 		default:
@@ -745,6 +781,9 @@ static void ieee80211_work_rx_queued_mgmt(struct ieee80211_local *local,
 			continue;
 
 		switch (fc & IEEE80211_FCTL_STYPE) {
+		case IEEE80211_STYPE_BEACON:
+			rma = ieee80211_rx_mgmt_beacon(wk, mgmt, skb->len);
+			break;
 		case IEEE80211_STYPE_PROBE_RESP:
 			rma = ieee80211_rx_mgmt_probe_resp(wk, mgmt, skb->len,
 							   rx_status);
@@ -916,6 +955,9 @@ static void ieee80211_work_work(struct work_struct *work)
 		case IEEE80211_WORK_REMAIN_ON_CHANNEL:
 			rma = ieee80211_remain_on_channel_timeout(wk);
 			break;
+		case IEEE80211_WORK_ASSOC_BEACON_WAIT:
+			rma = ieee80211_assoc_beacon_wait(wk);
+			break;
 		}
 
 		wk->started = started;
@@ -1065,6 +1107,7 @@ ieee80211_rx_result ieee80211_work_rx_mgmt(struct ieee80211_sub_if_data *sdata,
 		case IEEE80211_STYPE_PROBE_RESP:
 		case IEEE80211_STYPE_ASSOC_RESP:
 		case IEEE80211_STYPE_REASSOC_RESP:
+		case IEEE80211_STYPE_BEACON:
 			skb_queue_tail(&local->work_skb_queue, skb);
 			ieee80211_queue_work(&local->hw, &local->work_work);
 			return RX_QUEUED;
-- 
1.7.1



