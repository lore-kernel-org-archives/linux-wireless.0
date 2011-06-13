Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from emh07.mail.saunalahti.fi ([62.142.5.117]:56230 "EHLO
	emh07.mail.saunalahti.fi" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754983Ab1FMWhL (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 13 Jun 2011 18:37:11 -0400
Received: from saunalahti-vams (vs3-11.mail.saunalahti.fi [62.142.5.95])
	by emh07-2.mail.saunalahti.fi (Postfix) with SMTP id 86E8918CF73
	for <linux-wireless@vger.kernel.org>; Tue, 14 Jun 2011 01:37:10 +0300 (EEST)
Received: from localhost6.localdomain6 (a88-115-184-248.elisa-laajakaista.fi [88.115.184.248])
	by emh01.mail.saunalahti.fi (Postfix) with ESMTP id 57CC2402E
	for <linux-wireless@vger.kernel.org>; Tue, 14 Jun 2011 01:37:09 +0300 (EEST)
Subject: [PATCH v2 16/27] mac80211: rename ieee80211_work_type to
	mac80211_work_type
To: linux-wireless@vger.kernel.org
From: Kalle Valo <kvalo@adurom.com>
Date: Tue, 14 Jun 2011 01:37:03 +0300
Message-ID: <20110613223703.10517.65152.stgit@localhost6.localdomain6> (sfid-20110614_005723_321302_5FED1F30)
In-Reply-To: <20110613223029.10517.52197.stgit@localhost6.localdomain6>
References: <20110613223029.10517.52197.stgit@localhost6.localdomain6>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Signed-off-by: Kalle Valo <kvalo@adurom.com>
---
 net/mac80211/cfg.c        |    4 ++--
 net/mac80211/mac80211_i.h |   18 +++++++++---------
 net/mac80211/mlme.c       |   30 +++++++++++++++---------------
 net/mac80211/status.c     |    2 +-
 net/mac80211/work.c       |   34 +++++++++++++++++-----------------
 5 files changed, 44 insertions(+), 44 deletions(-)

diff --git a/net/mac80211/cfg.c b/net/mac80211/cfg.c
index 936ad16..a05bc6f 100644
--- a/net/mac80211/cfg.c
+++ b/net/mac80211/cfg.c
@@ -1976,7 +1976,7 @@ static int ieee80211_mgmt_tx(struct wiphy *wiphy, struct net_device *dev,
 		return -ENOMEM;
 	}
 
-	wk->type = IEEE80211_WORK_OFFCHANNEL_TX;
+	wk->type = MAC80211_WORK_OFFCHANNEL_TX;
 	wk->chan = chan;
 	wk->chan_type = channel_type;
 	wk->sdata = sdata;
@@ -2032,7 +2032,7 @@ static int ieee80211_mgmt_tx_cancel_wait(struct wiphy *wiphy,
 		if (wk->sdata != sdata)
 			continue;
 
-		if (wk->type != IEEE80211_WORK_OFFCHANNEL_TX)
+		if (wk->type != MAC80211_WORK_OFFCHANNEL_TX)
 			continue;
 
 		if (cookie != (unsigned long) wk->offchan_tx.frame)
diff --git a/net/mac80211/mac80211_i.h b/net/mac80211/mac80211_i.h
index 0a0cd8e..eb95457 100644
--- a/net/mac80211/mac80211_i.h
+++ b/net/mac80211/mac80211_i.h
@@ -257,14 +257,14 @@ struct mesh_preq_queue {
 	u8 flags;
 };
 
-enum ieee80211_work_type {
-	IEEE80211_WORK_ABORT,
-	IEEE80211_WORK_DIRECT_PROBE,
-	IEEE80211_WORK_AUTH,
-	IEEE80211_WORK_ASSOC_BEACON_WAIT,
-	IEEE80211_WORK_ASSOC,
-	IEEE80211_WORK_REMAIN_ON_CHANNEL,
-	IEEE80211_WORK_OFFCHANNEL_TX,
+enum mac80211_work_type {
+	MAC80211_WORK_ABORT,
+	MAC80211_WORK_DIRECT_PROBE,
+	MAC80211_WORK_AUTH,
+	MAC80211_WORK_ASSOC_BEACON_WAIT,
+	MAC80211_WORK_ASSOC,
+	MAC80211_WORK_REMAIN_ON_CHANNEL,
+	MAC80211_WORK_OFFCHANNEL_TX,
 };
 
 /**
@@ -293,7 +293,7 @@ struct ieee80211_work {
 	enum nl80211_channel_type chan_type;
 
 	unsigned long timeout;
-	enum ieee80211_work_type type;
+	enum mac80211_work_type type;
 
 	u8 filter_ta[ETH_ALEN];
 
diff --git a/net/mac80211/mlme.c b/net/mac80211/mlme.c
index dcf33eb..6902847 100644
--- a/net/mac80211/mlme.c
+++ b/net/mac80211/mlme.c
@@ -1965,8 +1965,8 @@ void ieee80211_sta_rx_queued_mgmt(struct ieee80211_sub_if_data *sdata,
 			if (wk->sdata != sdata)
 				continue;
 
-			if (wk->type != IEEE80211_WORK_ASSOC &&
-			    wk->type != IEEE80211_WORK_ASSOC_BEACON_WAIT)
+			if (wk->type != MAC80211_WORK_ASSOC &&
+			    wk->type != MAC80211_WORK_ASSOC_BEACON_WAIT)
 				continue;
 
 			if (memcmp(mgmt->bssid, wk->filter_ta, ETH_ALEN))
@@ -2276,7 +2276,7 @@ ieee80211_probe_auth_done(struct ieee80211_work *wk,
 		return WORK_DONE_DESTROY;
 	}
 
-	if (wk->type == IEEE80211_WORK_AUTH) {
+	if (wk->type == MAC80211_WORK_AUTH) {
 		cfg80211_send_rx_auth(wk->sdata->dev, skb->data, skb->len);
 		return WORK_DONE_DESTROY;
 	}
@@ -2285,7 +2285,7 @@ ieee80211_probe_auth_done(struct ieee80211_work *wk,
 	ieee80211_rx_mgmt_probe_resp(wk->sdata, skb);
 	mutex_unlock(&wk->sdata->u.mgd.mtx);
 
-	wk->type = IEEE80211_WORK_AUTH;
+	wk->type = MAC80211_WORK_AUTH;
 	wk->probe_auth.tries = 0;
 	return WORK_DONE_REQUEUE;
 }
@@ -2345,9 +2345,9 @@ int ieee80211_mgd_auth(struct ieee80211_sub_if_data *sdata,
 
 	/* if we already have a probe, don't probe again */
 	if (req->bss->proberesp_ies)
-		wk->type = IEEE80211_WORK_AUTH;
+		wk->type = MAC80211_WORK_AUTH;
 	else
-		wk->type = IEEE80211_WORK_DIRECT_PROBE;
+		wk->type = MAC80211_WORK_DIRECT_PROBE;
 	wk->chan = req->bss->channel;
 	wk->chan_type = NL80211_CHAN_NO_HT;
 	wk->sdata = sdata;
@@ -2370,7 +2370,7 @@ static enum work_done_result ieee80211_assoc_done(struct ieee80211_work *wk,
 		return WORK_DONE_DESTROY;
 	}
 
-	if (wk->type == IEEE80211_WORK_ASSOC_BEACON_WAIT) {
+	if (wk->type == MAC80211_WORK_ASSOC_BEACON_WAIT) {
 		mutex_lock(&wk->sdata->u.mgd.mtx);
 		rx_status = (void *) skb->cb;
 		ieee802_11_parse_elems(skb->data + 24 + 12, skb->len - 24 - 12, &elems);
@@ -2378,7 +2378,7 @@ static enum work_done_result ieee80211_assoc_done(struct ieee80211_work *wk,
 				      &elems, true);
 		mutex_unlock(&wk->sdata->u.mgd.mtx);
 
-		wk->type = IEEE80211_WORK_ASSOC;
+		wk->type = MAC80211_WORK_ASSOC;
 		/* not really done yet */
 		return WORK_DONE_REQUEUE;
 	}
@@ -2504,9 +2504,9 @@ int ieee80211_mgd_assoc(struct ieee80211_sub_if_data *sdata,
 	wk->done = ieee80211_assoc_done;
 	if (!bss->dtim_period &&
 	    sdata->local->hw.flags & IEEE80211_HW_NEED_DTIM_PERIOD)
-		wk->type = IEEE80211_WORK_ASSOC_BEACON_WAIT;
+		wk->type = MAC80211_WORK_ASSOC_BEACON_WAIT;
 	else
-		wk->type = IEEE80211_WORK_ASSOC;
+		wk->type = MAC80211_WORK_ASSOC;
 
 	if (req->use_mfp) {
 		ifmgd->mfp = IEEE80211_MFP_REQUIRED;
@@ -2555,16 +2555,16 @@ int ieee80211_mgd_deauth(struct ieee80211_sub_if_data *sdata,
 			if (wk->sdata != sdata)
 				continue;
 
-			if (wk->type != IEEE80211_WORK_DIRECT_PROBE &&
-			    wk->type != IEEE80211_WORK_AUTH &&
-			    wk->type != IEEE80211_WORK_ASSOC &&
-			    wk->type != IEEE80211_WORK_ASSOC_BEACON_WAIT)
+			if (wk->type != MAC80211_WORK_DIRECT_PROBE &&
+			    wk->type != MAC80211_WORK_AUTH &&
+			    wk->type != MAC80211_WORK_ASSOC &&
+			    wk->type != MAC80211_WORK_ASSOC_BEACON_WAIT)
 				continue;
 
 			if (memcmp(req->bss->bssid, wk->filter_ta, ETH_ALEN))
 				continue;
 
-			not_auth_yet = wk->type == IEEE80211_WORK_DIRECT_PROBE;
+			not_auth_yet = wk->type == MAC80211_WORK_DIRECT_PROBE;
 			list_del_rcu(&wk->list);
 			free_work(wk);
 			break;
diff --git a/net/mac80211/status.c b/net/mac80211/status.c
index 26d2c40..108e6b1 100644
--- a/net/mac80211/status.c
+++ b/net/mac80211/status.c
@@ -332,7 +332,7 @@ void ieee80211_tx_status(struct ieee80211_hw *hw, struct sk_buff *skb)
 
 		rcu_read_lock();
 		list_for_each_entry_rcu(wk, &local->work_list, list) {
-			if (wk->type != IEEE80211_WORK_OFFCHANNEL_TX)
+			if (wk->type != MAC80211_WORK_OFFCHANNEL_TX)
 				continue;
 			if (wk->offchan_tx.frame != skb)
 				continue;
diff --git a/net/mac80211/work.c b/net/mac80211/work.c
index a963b02..4168d4a 100644
--- a/net/mac80211/work.c
+++ b/net/mac80211/work.c
@@ -604,7 +604,7 @@ ieee80211_rx_mgmt_auth(struct ieee80211_work *wk,
 {
 	u16 auth_alg, auth_transaction, status_code;
 
-	if (wk->type != IEEE80211_WORK_AUTH)
+	if (wk->type != MAC80211_WORK_AUTH)
 		return WORK_ACT_MISMATCH;
 
 	if (len < 24 + 6)
@@ -656,7 +656,7 @@ ieee80211_rx_mgmt_assoc_resp(struct ieee80211_work *wk,
 	struct ieee802_11_elems elems;
 	u8 *pos;
 
-	if (wk->type != IEEE80211_WORK_ASSOC)
+	if (wk->type != MAC80211_WORK_ASSOC)
 		return WORK_ACT_MISMATCH;
 
 	/*
@@ -714,7 +714,7 @@ ieee80211_rx_mgmt_probe_resp(struct ieee80211_work *wk,
 
 	ASSERT_WORK_MTX(local);
 
-	if (wk->type != IEEE80211_WORK_DIRECT_PROBE)
+	if (wk->type != MAC80211_WORK_DIRECT_PROBE)
 		return WORK_ACT_MISMATCH;
 
 	if (len < 24 + 12)
@@ -737,7 +737,7 @@ ieee80211_rx_mgmt_beacon(struct ieee80211_work *wk,
 
 	ASSERT_WORK_MTX(local);
 
-	if (wk->type != IEEE80211_WORK_ASSOC_BEACON_WAIT)
+	if (wk->type != MAC80211_WORK_ASSOC_BEACON_WAIT)
 		return WORK_ACT_MISMATCH;
 
 	if (len < 24 + 12)
@@ -766,10 +766,10 @@ static void ieee80211_work_rx_queued_mgmt(struct mac80211_local *local,
 		const u8 *bssid = NULL;
 
 		switch (wk->type) {
-		case IEEE80211_WORK_DIRECT_PROBE:
-		case IEEE80211_WORK_AUTH:
-		case IEEE80211_WORK_ASSOC:
-		case IEEE80211_WORK_ASSOC_BEACON_WAIT:
+		case MAC80211_WORK_DIRECT_PROBE:
+		case MAC80211_WORK_AUTH:
+		case MAC80211_WORK_ASSOC:
+		case MAC80211_WORK_ASSOC_BEACON_WAIT:
 			bssid = wk->filter_ta;
 			break;
 		default:
@@ -1015,25 +1015,25 @@ static void ieee80211_work_work(struct work_struct *work)
 			/* nothing */
 			rma = WORK_ACT_NONE;
 			break;
-		case IEEE80211_WORK_ABORT:
+		case MAC80211_WORK_ABORT:
 			rma = WORK_ACT_TIMEOUT;
 			break;
-		case IEEE80211_WORK_DIRECT_PROBE:
+		case MAC80211_WORK_DIRECT_PROBE:
 			rma = ieee80211_direct_probe(wk);
 			break;
-		case IEEE80211_WORK_AUTH:
+		case MAC80211_WORK_AUTH:
 			rma = ieee80211_authenticate(wk);
 			break;
-		case IEEE80211_WORK_ASSOC:
+		case MAC80211_WORK_ASSOC:
 			rma = ieee80211_associate(wk);
 			break;
-		case IEEE80211_WORK_REMAIN_ON_CHANNEL:
+		case MAC80211_WORK_REMAIN_ON_CHANNEL:
 			rma = ieee80211_remain_on_channel_timeout(wk);
 			break;
-		case IEEE80211_WORK_OFFCHANNEL_TX:
+		case MAC80211_WORK_OFFCHANNEL_TX:
 			rma = ieee80211_offchannel_tx(wk);
 			break;
-		case IEEE80211_WORK_ASSOC_BEACON_WAIT:
+		case MAC80211_WORK_ASSOC_BEACON_WAIT:
 			rma = ieee80211_assoc_beacon_wait(wk);
 			break;
 		}
@@ -1155,7 +1155,7 @@ void ieee80211_work_purge(struct ieee80211_sub_if_data *sdata)
 		if (wk->sdata != sdata)
 			continue;
 		cleanup = true;
-		wk->type = IEEE80211_WORK_ABORT;
+		wk->type = MAC80211_WORK_ABORT;
 		wk->started = true;
 		wk->timeout = jiffies;
 	}
@@ -1236,7 +1236,7 @@ int ieee80211_wk_remain_on_channel(struct ieee80211_sub_if_data *sdata,
 	if (!wk)
 		return -ENOMEM;
 
-	wk->type = IEEE80211_WORK_REMAIN_ON_CHANNEL;
+	wk->type = MAC80211_WORK_REMAIN_ON_CHANNEL;
 	wk->chan = chan;
 	wk->chan_type = channel_type;
 	wk->sdata = sdata;

