Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:48414 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751874Ab0KYJDg (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 25 Nov 2010 04:03:36 -0500
Message-Id: <20101125090254.644357121@sipsolutions.net>
Date: Thu, 25 Nov 2010 10:02:30 +0100
From: Johannes Berg <johannes@sipsolutions.net>
To: John Linville <linville@tuxdriver.com>
Cc: linux-wireless@vger.kernel.org,
	Johannes Berg <johannes.berg@intel.com>
Subject: [PATCH 2/2] mac80211: implement off-channel mgmt TX
References: <20101125090228.087298683@sipsolutions.net>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Johannes Berg <johannes.berg@intel.com>

This implements the new off-channel TX API
in mac80211 with a new work item type. The
operation doesn't add a new work item when
we're on the right channel and there's no
wait time so that for example p2p probe
responses will be transmitted without delay.

Signed-off-by: Johannes Berg <johannes.berg@intel.com>
---
 net/mac80211/cfg.c         |   93 ++++++++++++++++++++++++++++++++++++++++++---
 net/mac80211/ieee80211_i.h |    5 ++
 net/mac80211/status.c      |   15 ++++++-
 net/mac80211/work.c        |   22 ++++++++++
 4 files changed, 129 insertions(+), 6 deletions(-)

--- wireless-testing.orig/net/mac80211/cfg.c	2010-11-25 09:52:21.000000000 +0100
+++ wireless-testing/net/mac80211/cfg.c	2010-11-25 09:53:59.000000000 +0100
@@ -1551,6 +1551,28 @@ static int ieee80211_cancel_remain_on_ch
 	return ieee80211_wk_cancel_remain_on_channel(sdata, cookie);
 }
 
+static enum work_done_result
+ieee80211_offchan_tx_done(struct ieee80211_work *wk, struct sk_buff *skb)
+{
+	/*
+	 * Use the data embedded in the work struct for reporting
+	 * here so if the driver mangled the SKB before dropping
+	 * it (which is the only way we really should get here)
+	 * then we don't report mangled data.
+	 *
+	 * If there was no wait time, then by the time we get here
+	 * the driver will likely not have reported the status yet,
+	 * so in that case userspace will have to deal with it.
+	 */
+
+	if (wk->offchan_tx.wait && wk->offchan_tx.frame)
+		cfg80211_mgmt_tx_status(wk->sdata->dev,
+					(unsigned long) wk->offchan_tx.frame,
+					wk->ie, wk->ie_len, false, GFP_KERNEL);
+
+	return WORK_DONE_DESTROY;
+}
+
 static int ieee80211_mgmt_tx(struct wiphy *wiphy, struct net_device *dev,
 			     struct ieee80211_channel *chan, bool offchan,
 			     enum nl80211_channel_type channel_type,
@@ -1561,20 +1583,22 @@ static int ieee80211_mgmt_tx(struct wiph
 	struct ieee80211_local *local = sdata->local;
 	struct sk_buff *skb;
 	struct sta_info *sta;
+	struct ieee80211_work *wk;
 	const struct ieee80211_mgmt *mgmt = (void *)buf;
 	u32 flags = IEEE80211_TX_INTFL_NL80211_FRAME_TX |
 		    IEEE80211_TX_CTL_REQ_TX_STATUS;
-
-	if (offchan)
-		return -EOPNOTSUPP;
+	bool is_offchan = false;
 
 	/* Check that we are on the requested channel for transmission */
 	if (chan != local->tmp_channel &&
 	    chan != local->oper_channel)
-		return -EBUSY;
+		is_offchan = true;
 	if (channel_type_valid &&
 	    (channel_type != local->tmp_channel_type &&
 	     channel_type != local->_oper_channel_type))
+		is_offchan = true;
+
+	if (is_offchan && !offchan)
 		return -EBUSY;
 
 	switch (sdata->vif.type) {
@@ -1608,12 +1632,70 @@ static int ieee80211_mgmt_tx(struct wiph
 	IEEE80211_SKB_CB(skb)->flags = flags;
 
 	skb->dev = sdata->dev;
-	ieee80211_tx_skb(sdata, skb);
 
 	*cookie = (unsigned long) skb;
+
+	/*
+	 * Can transmit right away if the channel was the
+	 * right one and there's no wait involved... If a
+	 * wait is involved, we might otherwise not be on
+	 * the right channel for long enough!
+	 */
+	if (!is_offchan && !wait && !sdata->vif.bss_conf.idle) {
+		ieee80211_tx_skb(sdata, skb);
+		return 0;
+	}
+
+	wk = kzalloc(sizeof(*wk) + len, GFP_KERNEL);
+	if (!wk) {
+		kfree_skb(skb);
+		return -ENOMEM;
+	}
+
+	wk->type = IEEE80211_WORK_OFFCHANNEL_TX;
+	wk->chan = chan;
+	wk->sdata = sdata;
+	wk->done = ieee80211_offchan_tx_done;
+	wk->offchan_tx.frame = skb;
+	wk->offchan_tx.wait = wait;
+	wk->ie_len = len;
+	memcpy(wk->ie, buf, len);
+
+	ieee80211_add_work(wk);
 	return 0;
 }
 
+static int ieee80211_mgmt_tx_cancel_wait(struct wiphy *wiphy,
+					 struct net_device *dev,
+					 u64 cookie)
+{
+	struct ieee80211_sub_if_data *sdata = IEEE80211_DEV_TO_SUB_IF(dev);
+	struct ieee80211_local *local = sdata->local;
+	struct ieee80211_work *wk;
+	int ret = -ENOENT;
+
+	mutex_lock(&local->mtx);
+	list_for_each_entry(wk, &local->work_list, list) {
+		if (wk->sdata != sdata)
+			continue;
+
+		if (wk->type != IEEE80211_WORK_OFFCHANNEL_TX)
+			continue;
+
+		if (cookie != (unsigned long) wk->offchan_tx.frame)
+			continue;
+
+		wk->timeout = jiffies;
+
+		ieee80211_queue_work(&local->hw, &local->work_work);
+		ret = 0;
+		break;
+	}
+	mutex_unlock(&local->mtx);
+
+	return ret;
+}
+
 static void ieee80211_mgmt_frame_register(struct wiphy *wiphy,
 					  struct net_device *dev,
 					  u16 frame_type, bool reg)
@@ -1698,6 +1780,7 @@ struct cfg80211_ops mac80211_config_ops
 	.remain_on_channel = ieee80211_remain_on_channel,
 	.cancel_remain_on_channel = ieee80211_cancel_remain_on_channel,
 	.mgmt_tx = ieee80211_mgmt_tx,
+	.mgmt_tx_cancel_wait = ieee80211_mgmt_tx_cancel_wait,
 	.set_cqm_rssi_config = ieee80211_set_cqm_rssi_config,
 	.mgmt_frame_register = ieee80211_mgmt_frame_register,
 	.set_antenna = ieee80211_set_antenna,
--- wireless-testing.orig/net/mac80211/ieee80211_i.h	2010-11-25 09:52:22.000000000 +0100
+++ wireless-testing/net/mac80211/ieee80211_i.h	2010-11-25 09:53:59.000000000 +0100
@@ -260,6 +260,7 @@ enum ieee80211_work_type {
 	IEEE80211_WORK_ASSOC_BEACON_WAIT,
 	IEEE80211_WORK_ASSOC,
 	IEEE80211_WORK_REMAIN_ON_CHANNEL,
+	IEEE80211_WORK_OFFCHANNEL_TX,
 };
 
 /**
@@ -320,6 +321,10 @@ struct ieee80211_work {
 		struct {
 			u32 duration;
 		} remain;
+		struct {
+			struct sk_buff *frame;
+			u32 wait;
+		} offchan_tx;
 	};
 
 	int ie_len;
--- wireless-testing.orig/net/mac80211/work.c	2010-11-25 09:52:22.000000000 +0100
+++ wireless-testing/net/mac80211/work.c	2010-11-25 09:53:59.000000000 +0100
@@ -561,6 +561,25 @@ ieee80211_remain_on_channel_timeout(stru
 }
 
 static enum work_action __must_check
+ieee80211_offchannel_tx(struct ieee80211_work *wk)
+{
+	if (!wk->started) {
+		wk->timeout = jiffies + msecs_to_jiffies(wk->offchan_tx.wait);
+
+		/*
+		 * After this, offchan_tx.frame remains but now is no
+		 * longer a valid pointer -- we still need it as the
+		 * cookie for canceling this work.
+		 */
+		ieee80211_tx_skb(wk->sdata, wk->offchan_tx.frame);
+
+		return WORK_ACT_NONE;
+	}
+
+	return WORK_ACT_TIMEOUT;
+}
+
+static enum work_action __must_check
 ieee80211_assoc_beacon_wait(struct ieee80211_work *wk)
 {
 	if (wk->started)
@@ -955,6 +974,9 @@ static void ieee80211_work_work(struct w
 		case IEEE80211_WORK_REMAIN_ON_CHANNEL:
 			rma = ieee80211_remain_on_channel_timeout(wk);
 			break;
+		case IEEE80211_WORK_OFFCHANNEL_TX:
+			rma = ieee80211_offchannel_tx(wk);
+			break;
 		case IEEE80211_WORK_ASSOC_BEACON_WAIT:
 			rma = ieee80211_assoc_beacon_wait(wk);
 			break;
--- wireless-testing.orig/net/mac80211/status.c	2010-11-25 09:52:21.000000000 +0100
+++ wireless-testing/net/mac80211/status.c	2010-11-25 09:53:59.000000000 +0100
@@ -321,10 +321,23 @@ void ieee80211_tx_status(struct ieee8021
 					msecs_to_jiffies(10));
 	}
 
-	if (info->flags & IEEE80211_TX_INTFL_NL80211_FRAME_TX)
+	if (info->flags & IEEE80211_TX_INTFL_NL80211_FRAME_TX) {
+		struct ieee80211_work *wk;
+
+		rcu_read_lock();
+		list_for_each_entry_rcu(wk, &local->work_list, list) {
+			if (wk->type != IEEE80211_WORK_OFFCHANNEL_TX)
+				continue;
+			if (wk->offchan_tx.frame != skb)
+				continue;
+			wk->offchan_tx.frame = NULL;
+			break;
+		}
+		rcu_read_unlock();
 		cfg80211_mgmt_tx_status(
 			skb->dev, (unsigned long) skb, skb->data, skb->len,
 			!!(info->flags & IEEE80211_TX_STAT_ACK), GFP_ATOMIC);
+	}
 
 	/* this was a transmitted frame, but now we want to reuse it */
 	skb_orphan(skb);


