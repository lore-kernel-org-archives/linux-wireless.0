Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:36777 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756135Ab0LPOR3 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 16 Dec 2010 09:17:29 -0500
Received: by sipsolutions.net with esmtpsa (TLS1.0:RSA_AES_256_CBC_SHA1:32)
	(Exim 4.72)
	(envelope-from <johannes@sipsolutions.net>)
	id 1PTEe8-0001AQ-Qg
	for linux-wireless@vger.kernel.org; Thu, 16 Dec 2010 15:17:28 +0100
Message-Id: <20101216141633.369507239@sipsolutions.net>
Date: Thu, 16 Dec 2010 15:15:20 +0100
From: Johannes Berg <johannes@sipsolutions.net>
To: linux-wireless@vger.kernel.org
Subject: [RFC 2/2] mac80211: implement off-channel TX using hw r-o-c offload
References: <20101216141518.879668720@sipsolutions.net>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Johannes Berg <johannes.berg@intel.com>

When the driver has remain-on-channel offload,
implement off-channel transmission using that
primitive.

Signed-off-by: Johannes Berg <johannes.berg@intel.com>
---
 net/mac80211/cfg.c         |   59 +++++++++++++++++++++++++++++++++++++++++++++
 net/mac80211/ieee80211_i.h |    2 +
 net/mac80211/offchannel.c  |   30 +++++++++++++++-------
 3 files changed, 81 insertions(+), 10 deletions(-)

--- wireless-testing.orig/net/mac80211/cfg.c	2010-12-16 08:04:15.000000000 +0100
+++ wireless-testing/net/mac80211/cfg.c	2010-12-16 14:45:18.000000000 +0100
@@ -1610,6 +1610,7 @@ static int ieee80211_remain_on_channel(s
 		ret = ieee80211_remain_on_channel_hw(local, dev,
 						     chan, channel_type,
 						     duration, cookie);
+		local->hw_roc_for_tx = false;
 		mutex_unlock(&local->mtx);
 
 		return ret;
@@ -1749,6 +1750,49 @@ static int ieee80211_mgmt_tx(struct wiph
 
 	*cookie = (unsigned long) skb;
 
+	if (is_offchan && local->ops->remain_on_channel) {
+		unsigned int duration;
+		int ret;
+
+		mutex_lock(&local->mtx);
+		/*
+		 * If the duration is zero, then the driver
+		 * wouldn't actually do anything. Set it to
+		 * 100 for now.
+		 *
+		 * TODO: cancel the off-channel operation
+		 *       when we get the SKB's TX status and
+		 *       the wait time was zero before.
+		 */
+		duration = 100;
+		if (wait)
+			duration = wait;
+		ret = ieee80211_remain_on_channel_hw(local, dev, chan,
+						     channel_type,
+						     duration, cookie);
+		if (ret) {
+			kfree_skb(skb);
+			mutex_unlock(&local->mtx);
+			return ret;
+		}
+
+		local->hw_roc_for_tx = true;
+		local->hw_roc_duration = wait;
+
+		/*
+		 * queue up frame for transmission after
+		 * ieee80211_ready_on_channel call
+		 */
+
+		/* modify cookie to prevent API mismatches */
+		*cookie ^= 2;
+		IEEE80211_SKB_CB(skb)->flags |= IEEE80211_TX_CTL_TX_OFFCHAN;
+		local->hw_roc_skb = skb;
+		mutex_unlock(&local->mtx);
+
+		return 0;
+	}
+
 	/*
 	 * Can transmit right away if the channel was the
 	 * right one and there's no wait involved... If a
@@ -1789,6 +1833,21 @@ static int ieee80211_mgmt_tx_cancel_wait
 	int ret = -ENOENT;
 
 	mutex_lock(&local->mtx);
+
+	if (local->ops->cancel_remain_on_channel) {
+		cookie ^= 2;
+		ret = ieee80211_cancel_remain_on_channel_hw(local, cookie);
+
+		if (ret == 0) {
+			kfree_skb(local->hw_roc_skb);
+			local->hw_roc_skb = NULL;
+		}
+
+		mutex_unlock(&local->mtx);
+
+		return ret;
+	}
+
 	list_for_each_entry(wk, &local->work_list, list) {
 		if (wk->sdata != sdata)
 			continue;
--- wireless-testing.orig/net/mac80211/ieee80211_i.h	2010-12-16 08:04:15.000000000 +0100
+++ wireless-testing/net/mac80211/ieee80211_i.h	2010-12-16 14:39:27.000000000 +0100
@@ -940,10 +940,12 @@ struct ieee80211_local {
 
 	struct ieee80211_channel *hw_roc_channel;
 	struct net_device *hw_roc_dev;
+	struct sk_buff *hw_roc_skb;
 	struct work_struct hw_roc_start, hw_roc_done;
 	enum nl80211_channel_type hw_roc_channel_type;
 	unsigned int hw_roc_duration;
 	u32 hw_roc_cookie;
+	bool hw_roc_for_tx;
 
 	/* dummy netdev for use w/ NAPI */
 	struct net_device napi_dev;
--- wireless-testing.orig/net/mac80211/offchannel.c	2010-12-16 08:04:15.000000000 +0100
+++ wireless-testing/net/mac80211/offchannel.c	2010-12-16 14:41:08.000000000 +0100
@@ -196,6 +196,7 @@ static void ieee80211_hw_roc_start(struc
 {
 	struct ieee80211_local *local =
 		container_of(work, struct ieee80211_local, hw_roc_start);
+	struct ieee80211_sub_if_data *sdata;
 
 	mutex_lock(&local->mtx);
 
@@ -206,11 +207,19 @@ static void ieee80211_hw_roc_start(struc
 
 	ieee80211_recalc_idle(local);
 
-	cfg80211_ready_on_channel(local->hw_roc_dev, local->hw_roc_cookie,
-				  local->hw_roc_channel,
-				  local->hw_roc_channel_type,
-				  local->hw_roc_duration,
-				  GFP_KERNEL);
+	if (local->hw_roc_skb) {
+		sdata = IEEE80211_DEV_TO_SUB_IF(local->hw_roc_dev);
+		ieee80211_tx_skb(sdata, local->hw_roc_skb);
+		local->hw_roc_skb = NULL;
+	} else {
+		cfg80211_ready_on_channel(local->hw_roc_dev,
+					  local->hw_roc_cookie,
+					  local->hw_roc_channel,
+					  local->hw_roc_channel_type,
+					  local->hw_roc_duration,
+					  GFP_KERNEL);
+	}
+
 	mutex_unlock(&local->mtx);
 }
 
@@ -236,11 +245,12 @@ static void ieee80211_hw_roc_done(struct
 		return;
 	}
 
-	cfg80211_remain_on_channel_expired(local->hw_roc_dev,
-					   local->hw_roc_cookie,
-					   local->hw_roc_channel,
-					   local->hw_roc_channel_type,
-					   GFP_KERNEL);
+	if (!local->hw_roc_for_tx)
+		cfg80211_remain_on_channel_expired(local->hw_roc_dev,
+						   local->hw_roc_cookie,
+						   local->hw_roc_channel,
+						   local->hw_roc_channel_type,
+						   GFP_KERNEL);
 
 	local->hw_roc_channel = NULL;
 	local->hw_roc_cookie = 0;


