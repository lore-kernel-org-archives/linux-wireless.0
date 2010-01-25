Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:57759 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752556Ab0AYMh2 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 25 Jan 2010 07:37:28 -0500
Received: by sipsolutions.net with esmtpsa (TLS1.0:DHE_RSA_AES_256_CBC_SHA1:32)
	(Exim 4.71)
	(envelope-from <johannes@sipsolutions.net>)
	id 1NZOC5-0004bH-Gn
	for linux-wireless@vger.kernel.org; Mon, 25 Jan 2010 13:37:26 +0100
Subject: [RFC] mac80211: wait for beacon before associating
From: Johannes Berg <johannes@sipsolutions.net>
To: linux-wireless@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Date: Mon, 25 Jan 2010 13:37:24 +0100
Message-ID: <1264423044.23766.39.camel@johannes.local>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This patch makes mac80211 wait for a beacon
before associating to have proper information
from it, in particular the DTIM period. It
also makes it not probe the AP if it already
has a probe response, so that only one of
probing and waiting for beacon can be done,
one of them must have been received to know
about the BSS.

Note that I don't think this helps the
synchronisation issue Kalle pointed out since
we do not tell the driver about the bssid, in
fact in this patch I explicitly open up the
filters to receive the beacon.

The default timeout is 112.5% of the beacon
interval, so a single lost beacon could cause
the association to fail, I'm not sure if that
is desirable or if the default timeout should
be longer.
---
This requires "mac80211: track work started through callbacks"

 drivers/net/wireless/mac80211_hwsim.c |    4 -
 net/mac80211/ieee80211_i.h            |    2 
 net/mac80211/main.c                   |    2 
 net/mac80211/mlme.c                   |   45 +++++++++++++++++---
 net/mac80211/work.c                   |   73 ++++++++++++++++++++++++++++++----
 5 files changed, 109 insertions(+), 17 deletions(-)

--- wireless-testing.orig/net/mac80211/mlme.c	2010-01-25 12:52:58.000000000 +0100
+++ wireless-testing/net/mac80211/mlme.c	2010-01-25 13:28:29.000000000 +0100
@@ -27,10 +27,6 @@
 #include "rate.h"
 #include "led.h"
 
-#define IEEE80211_AUTH_TIMEOUT (HZ / 5)
-#define IEEE80211_AUTH_MAX_TRIES 3
-#define IEEE80211_ASSOC_TIMEOUT (HZ / 5)
-#define IEEE80211_ASSOC_MAX_TRIES 3
 #define IEEE80211_MAX_PROBE_TRIES 5
 
 /*
@@ -1823,7 +1819,11 @@ int ieee80211_mgd_auth(struct ieee80211_
 	wk->probe_auth.algorithm = auth_alg;
 	wk->probe_auth.privacy = req->bss->capability & WLAN_CAPABILITY_PRIVACY;
 
-	wk->type = IEEE80211_WORK_DIRECT_PROBE;
+	/* if we already have a probe, don't probe again */
+	if (req->bss->proberesp_ies)
+		wk->type = IEEE80211_WORK_AUTH;
+	else
+		wk->type = IEEE80211_WORK_DIRECT_PROBE;
 	wk->chan = req->bss->channel;
 	wk->sdata = sdata;
 	wk->done = ieee80211_probe_auth_done;
@@ -1862,6 +1862,32 @@ static enum work_done_result ieee80211_a
 	return WORK_DONE_DESTROY;
 }
 
+static enum work_done_result ieee80211_beacon_done(struct ieee80211_work *wk,
+						   struct sk_buff *skb)
+{
+	struct ieee80211_mgmt *mgmt;
+	struct ieee80211_rx_status *rx_status;
+	size_t baselen, len;
+	struct ieee802_11_elems elems;
+
+	if (!skb) {
+		cfg80211_send_assoc_timeout(wk->sdata->dev, wk->filter_ta);
+		return WORK_DONE_DESTROY;
+	}
+
+	mgmt = (void *)skb->data;
+	rx_status = (void *) skb->cb;
+	len = skb->len;
+	baselen = (u8 *) mgmt->u.beacon.variable - (u8 *) mgmt;
+
+	ieee802_11_parse_elems(mgmt->u.beacon.variable, len - baselen, &elems);
+	ieee80211_rx_bss_info(wk->sdata, mgmt, len, rx_status, &elems, true);
+
+	wk->type = IEEE80211_WORK_ASSOC;
+	wk->done = ieee80211_assoc_done;
+	return WORK_DONE_REQUEUE;
+}
+
 int ieee80211_mgd_assoc(struct ieee80211_sub_if_data *sdata,
 			struct cfg80211_assoc_request *req)
 {
@@ -1942,10 +1968,15 @@ int ieee80211_mgd_assoc(struct ieee80211
 	if (req->prev_bssid)
 		memcpy(wk->assoc.prev_bssid, req->prev_bssid, ETH_ALEN);
 
-	wk->type = IEEE80211_WORK_ASSOC;
+	if (req->bss->beacon_ies) {
+		wk->type = IEEE80211_WORK_ASSOC;
+		wk->done = ieee80211_assoc_done;
+	} else {
+		wk->type = IEEE80211_WORK_WAIT_BEACON;
+		wk->done = ieee80211_beacon_done;
+	}
 	wk->chan = req->bss->channel;
 	wk->sdata = sdata;
-	wk->done = ieee80211_assoc_done;
 
 	if (req->use_mfp) {
 		ifmgd->mfp = IEEE80211_MFP_REQUIRED;
--- wireless-testing.orig/net/mac80211/ieee80211_i.h	2010-01-25 12:53:11.000000000 +0100
+++ wireless-testing/net/mac80211/ieee80211_i.h	2010-01-25 13:01:59.000000000 +0100
@@ -240,6 +240,7 @@ enum ieee80211_work_type {
 	IEEE80211_WORK_AUTH,
 	IEEE80211_WORK_ASSOC,
 	IEEE80211_WORK_REMAIN_ON_CHANNEL,
+	IEEE80211_WORK_WAIT_BEACON,
 };
 
 /**
@@ -618,6 +619,7 @@ struct ieee80211_local {
 	struct timer_list work_timer;
 	struct work_struct work_work;
 	struct sk_buff_head work_skb_queue;
+	int bcnwait;
 
 	/*
 	 * private workqueue to mac80211. mac80211 makes this accessible
--- wireless-testing.orig/net/mac80211/main.c	2010-01-25 12:52:58.000000000 +0100
+++ wireless-testing/net/mac80211/main.c	2010-01-25 12:59:48.000000000 +0100
@@ -50,7 +50,7 @@ void ieee80211_configure_filter(struct i
 	if (atomic_read(&local->iff_allmultis))
 		new_flags |= FIF_ALLMULTI;
 
-	if (local->monitors || local->scanning)
+	if (local->monitors || local->scanning || local->bcnwait)
 		new_flags |= FIF_BCN_PRBRESP_PROMISC;
 
 	if (local->fif_fcsfail)
--- wireless-testing.orig/net/mac80211/work.c	2010-01-25 12:56:46.000000000 +0100
+++ wireless-testing/net/mac80211/work.c	2010-01-25 13:24:48.000000000 +0100
@@ -548,6 +548,37 @@ ieee80211_remain_on_channel_timeout(stru
 	return WORK_ACT_TIMEOUT;
 }
 
+static enum work_action __must_check
+ieee80211_wait_beacon(struct ieee80211_work *wk)
+{
+	struct cfg80211_bss *cbss =
+		container_of((void *)wk->assoc.bss, struct cfg80211_bss, priv);
+
+	if (WARN_ON(!wk->assoc.bss))
+		return WORK_ACT_TIMEOUT;
+
+	/*
+	 * First time we run, just configure the filters -- the
+	 * generic code will have switched to the right channel
+	 * on which we will have to wait for the beacon.
+	 */
+	if (!wk->started) {
+		u32 bcnint = cbss->beacon_interval;
+
+		wk->sdata->local->bcnwait++;
+		ieee80211_configure_filter(wk->sdata->local);
+		/* add 1/8th of the beacon interval */
+		wk->timeout = TU_TO_EXP_TIME(bcnint + (bcnint >> 3));
+		return WORK_ACT_NONE;
+	}
+
+	/*
+	 * Next time around we were unsuccessful waiting
+	 * for a beacon. Strange.
+	 */
+	return WORK_ACT_TIMEOUT;
+}
+
 static void ieee80211_auth_challenge(struct ieee80211_work *wk,
 				     struct ieee80211_mgmt *mgmt,
 				     size_t len)
@@ -671,8 +702,7 @@ ieee80211_rx_mgmt_assoc_resp(struct ieee
 
 static enum work_action __must_check
 ieee80211_rx_mgmt_probe_resp(struct ieee80211_work *wk,
-			     struct ieee80211_mgmt *mgmt, size_t len,
-			     struct ieee80211_rx_status *rx_status)
+			     struct ieee80211_mgmt *mgmt, size_t len)
 {
 	struct ieee80211_sub_if_data *sdata = wk->sdata;
 	struct ieee80211_local *local = sdata->local;
@@ -688,6 +718,29 @@ ieee80211_rx_mgmt_probe_resp(struct ieee
 	return WORK_ACT_DONE;
 }
 
+static enum work_action __must_check
+ieee80211_rx_mgmt_beacon(struct ieee80211_work *wk,
+			 struct ieee80211_mgmt *mgmt, size_t len,
+			 struct ieee80211_rx_status *rx_status)
+{
+	struct ieee80211_sub_if_data *sdata = wk->sdata;
+	struct ieee80211_local *local = sdata->local;
+	size_t baselen;
+
+	ASSERT_WORK_MTX(local);
+
+	baselen = (u8 *) mgmt->u.beacon.variable - (u8 *) mgmt;
+	if (baselen > len)
+		return WORK_ACT_NONE;
+
+	printk(KERN_DEBUG "%s: beacon received\n", sdata->name);
+
+	local->bcnwait--;
+	ieee80211_configure_filter(local);
+
+	return WORK_ACT_DONE;
+}
+
 static void ieee80211_work_rx_queued_mgmt(struct ieee80211_local *local,
 					  struct sk_buff *skb)
 {
@@ -710,6 +763,7 @@ static void ieee80211_work_rx_queued_mgm
 		case IEEE80211_WORK_DIRECT_PROBE:
 		case IEEE80211_WORK_AUTH:
 		case IEEE80211_WORK_ASSOC:
+		case IEEE80211_WORK_WAIT_BEACON:
 			bssid = wk->filter_ta;
 			break;
 		default:
@@ -725,8 +779,7 @@ static void ieee80211_work_rx_queued_mgm
 
 		switch (fc & IEEE80211_FCTL_STYPE) {
 		case IEEE80211_STYPE_PROBE_RESP:
-			rma = ieee80211_rx_mgmt_probe_resp(wk, mgmt, skb->len,
-							   rx_status);
+			rma = ieee80211_rx_mgmt_probe_resp(wk, mgmt, skb->len);
 			break;
 		case IEEE80211_STYPE_AUTH:
 			rma = ieee80211_rx_mgmt_auth(wk, mgmt, skb->len);
@@ -739,8 +792,12 @@ static void ieee80211_work_rx_queued_mgm
 			rma = ieee80211_rx_mgmt_assoc_resp(wk, mgmt,
 							   skb->len, true);
 			break;
+		case IEEE80211_STYPE_BEACON:
+			rma = ieee80211_rx_mgmt_beacon(wk, mgmt, skb->len,
+						       rx_status);
+			break;
 		default:
-			WARN_ON(1);
+			WARN(1, "unexpected frame type %#x", fc);
 		}
 		/*
 		 * We've processed this frame for that work, so it can't
@@ -881,6 +938,9 @@ static void ieee80211_work_work(struct w
 		case IEEE80211_WORK_REMAIN_ON_CHANNEL:
 			rma = ieee80211_remain_on_channel_timeout(wk);
 			break;
+		case IEEE80211_WORK_WAIT_BEACON:
+			rma = ieee80211_wait_beacon(wk);
+			break;
 		}
 
 		wk->started = started;
@@ -1025,8 +1085,7 @@ ieee80211_rx_result ieee80211_work_rx_mg
 		case IEEE80211_STYPE_PROBE_RESP:
 		case IEEE80211_STYPE_ASSOC_RESP:
 		case IEEE80211_STYPE_REASSOC_RESP:
-		case IEEE80211_STYPE_DEAUTH:
-		case IEEE80211_STYPE_DISASSOC:
+		case IEEE80211_STYPE_BEACON:
 			skb_queue_tail(&local->work_skb_queue, skb);
 			ieee80211_queue_work(&local->hw, &local->work_work);
 			return RX_QUEUED;
--- wireless-testing.orig/drivers/net/wireless/mac80211_hwsim.c	2010-01-25 13:26:12.000000000 +0100
+++ wireless-testing/drivers/net/wireless/mac80211_hwsim.c	2010-01-25 13:27:15.000000000 +0100
@@ -723,8 +723,8 @@ static void mac80211_hwsim_bss_info_chan
 	}
 
 	if (changed & BSS_CHANGED_ASSOC) {
-		printk(KERN_DEBUG "  %s: ASSOC: assoc=%d aid=%d\n",
-		       wiphy_name(hw->wiphy), info->assoc, info->aid);
+		printk(KERN_DEBUG "  %s: ASSOC: assoc=%d aid=%d dtimper=%d\n",
+		       wiphy_name(hw->wiphy), info->assoc, info->aid, info->dtim_period);
 		vp->assoc = info->assoc;
 		vp->aid = info->aid;
 	}


