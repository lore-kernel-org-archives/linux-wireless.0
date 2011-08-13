Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga01.intel.com ([192.55.52.88]:30543 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751722Ab1HMQ57 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Sat, 13 Aug 2011 12:57:59 -0400
From: Wey-Yi Guy <wey-yi.w.guy@intel.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org,
	Johannes Berg <johannes.berg@intel.com>
Subject: [PATCH 09/13] mac80211: remove offchannel_tx API
Date: Sat, 13 Aug 2011 09:18:03 -0700
Message-Id: <1313252287-22858-9-git-send-email-wey-yi.w.guy@intel.com> (sfid-20110813_185813_689743_D35187DA)
In-Reply-To: <1313252287-22858-1-git-send-email-wey-yi.w.guy@intel.com>
References: <1313252287-22858-1-git-send-email-wey-yi.w.guy@intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Johannes Berg <johannes.berg@intel.com>

For iwlwifi, I decided not to use this API since
it just increased the complexity for little gain.
Since nobody else intends to use it, let's kill
it again. If anybody later needs to have it, we
can always revive it then.

Signed-off-by: Johannes Berg <johannes.berg@intel.com>
---
 include/net/mac80211.h     |   10 ----------
 net/mac80211/cfg.c         |   39 ---------------------------------------
 net/mac80211/driver-ops.h  |   31 -------------------------------
 net/mac80211/ieee80211_i.h |    1 -
 net/mac80211/status.c      |    3 ---
 5 files changed, 0 insertions(+), 84 deletions(-)

diff --git a/include/net/mac80211.h b/include/net/mac80211.h
index 9259e97..6c846df 100644
--- a/include/net/mac80211.h
+++ b/include/net/mac80211.h
@@ -1896,11 +1896,6 @@ enum ieee80211_tx_sync_type {
  *	ieee80211_remain_on_channel_expired(). This callback may sleep.
  * @cancel_remain_on_channel: Requests that an ongoing off-channel period is
  *	aborted before it expires. This callback may sleep.
- * @offchannel_tx: Transmit frame on another channel, wait for a response
- *	and return. Reliable TX status must be reported for the frame. If the
- *	return value is 1, then the @remain_on_channel will be used with a
- *	regular transmission (if supported.)
- * @offchannel_tx_cancel_wait: cancel wait associated with offchannel TX
  *
  * @set_ringparam: Set tx and rx ring sizes.
  *
@@ -2019,11 +2014,6 @@ struct ieee80211_ops {
 				 enum nl80211_channel_type channel_type,
 				 int duration);
 	int (*cancel_remain_on_channel)(struct ieee80211_hw *hw);
-	int (*offchannel_tx)(struct ieee80211_hw *hw, struct sk_buff *skb,
-			     struct ieee80211_channel *chan,
-			     enum nl80211_channel_type channel_type,
-			     unsigned int wait);
-	int (*offchannel_tx_cancel_wait)(struct ieee80211_hw *hw);
 	int (*set_ringparam)(struct ieee80211_hw *hw, u32 tx, u32 rx);
 	void (*get_ringparam)(struct ieee80211_hw *hw,
 			      u32 *tx, u32 *tx_max, u32 *rx, u32 *rx_max);
diff --git a/net/mac80211/cfg.c b/net/mac80211/cfg.c
index 3d1b091..c1fa577 100644
--- a/net/mac80211/cfg.c
+++ b/net/mac80211/cfg.c
@@ -1898,33 +1898,6 @@ static int ieee80211_mgmt_tx(struct wiphy *wiphy, struct net_device *dev,
 
 	*cookie = (unsigned long) skb;
 
-	if (is_offchan && local->ops->offchannel_tx) {
-		int ret;
-
-		IEEE80211_SKB_CB(skb)->band = chan->band;
-
-		mutex_lock(&local->mtx);
-
-		if (local->hw_offchan_tx_cookie) {
-			mutex_unlock(&local->mtx);
-			return -EBUSY;
-		}
-
-		/* TODO: bitrate control, TX processing? */
-		ret = drv_offchannel_tx(local, skb, chan, channel_type, wait);
-
-		if (ret == 0)
-			local->hw_offchan_tx_cookie = *cookie;
-		mutex_unlock(&local->mtx);
-
-		/*
-		 * Allow driver to return 1 to indicate it wants to have the
-		 * frame transmitted with a remain_on_channel + regular TX.
-		 */
-		if (ret != 1)
-			return ret;
-	}
-
 	if (is_offchan && local->ops->remain_on_channel) {
 		unsigned int duration;
 		int ret;
@@ -2011,18 +1984,6 @@ static int ieee80211_mgmt_tx_cancel_wait(struct wiphy *wiphy,
 
 	mutex_lock(&local->mtx);
 
-	if (local->ops->offchannel_tx_cancel_wait &&
-	    local->hw_offchan_tx_cookie == cookie) {
-		ret = drv_offchannel_tx_cancel_wait(local);
-
-		if (!ret)
-			local->hw_offchan_tx_cookie = 0;
-
-		mutex_unlock(&local->mtx);
-
-		return ret;
-	}
-
 	if (local->ops->cancel_remain_on_channel) {
 		cookie ^= 2;
 		ret = ieee80211_cancel_remain_on_channel_hw(local, cookie);
diff --git a/net/mac80211/driver-ops.h b/net/mac80211/driver-ops.h
index 1425380..9001ff3 100644
--- a/net/mac80211/driver-ops.h
+++ b/net/mac80211/driver-ops.h
@@ -590,37 +590,6 @@ static inline int drv_cancel_remain_on_channel(struct ieee80211_local *local)
 	return ret;
 }
 
-static inline int drv_offchannel_tx(struct ieee80211_local *local,
-				    struct sk_buff *skb,
-				    struct ieee80211_channel *chan,
-				    enum nl80211_channel_type channel_type,
-				    unsigned int wait)
-{
-	int ret;
-
-	might_sleep();
-
-	trace_drv_offchannel_tx(local, skb, chan, channel_type, wait);
-	ret = local->ops->offchannel_tx(&local->hw, skb, chan,
-					channel_type, wait);
-	trace_drv_return_int(local, ret);
-
-	return ret;
-}
-
-static inline int drv_offchannel_tx_cancel_wait(struct ieee80211_local *local)
-{
-	int ret;
-
-	might_sleep();
-
-	trace_drv_offchannel_tx_cancel_wait(local);
-	ret = local->ops->offchannel_tx_cancel_wait(&local->hw);
-	trace_drv_return_int(local, ret);
-
-	return ret;
-}
-
 static inline int drv_set_ringparam(struct ieee80211_local *local,
 				    u32 tx, u32 rx)
 {
diff --git a/net/mac80211/ieee80211_i.h b/net/mac80211/ieee80211_i.h
index 400c09b..286ac5d 100644
--- a/net/mac80211/ieee80211_i.h
+++ b/net/mac80211/ieee80211_i.h
@@ -1002,7 +1002,6 @@ struct ieee80211_local {
 	unsigned int hw_roc_duration;
 	u32 hw_roc_cookie;
 	bool hw_roc_for_tx;
-	unsigned long hw_offchan_tx_cookie;
 
 	/* dummy netdev for use w/ NAPI */
 	struct net_device napi_dev;
diff --git a/net/mac80211/status.c b/net/mac80211/status.c
index 1658efa..a89cca3 100644
--- a/net/mac80211/status.c
+++ b/net/mac80211/status.c
@@ -345,9 +345,6 @@ void ieee80211_tx_status(struct ieee80211_hw *hw, struct sk_buff *skb)
 			local->hw_roc_skb_for_status = NULL;
 		}
 
-		if (cookie == local->hw_offchan_tx_cookie)
-			local->hw_offchan_tx_cookie = 0;
-
 		cfg80211_mgmt_tx_status(
 			skb->dev, cookie, skb->data, skb->len,
 			!!(info->flags & IEEE80211_TX_STAT_ACK), GFP_ATOMIC);
-- 
1.7.0.4

