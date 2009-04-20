Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from xc.sipsolutions.net ([83.246.72.84]:55147 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754778AbZDTMvX (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 20 Apr 2009 08:51:23 -0400
Subject: [PATCH] nl80211: Add set/get for frag/rts threshold and retry
 limits
From: Johannes Berg <johannes@sipsolutions.net>
To: John Linville <linville@tuxdriver.com>
Cc: Jouni Malinen <j@w1.fi>,
	linux-wireless <linux-wireless@vger.kernel.org>
Content-Type: text/plain
Date: Mon, 20 Apr 2009 14:50:44 +0200
Message-Id: <1240231844.28218.5.camel@johannes.local> (sfid-20090420_145129_948735_CD34FA3C)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Jouni Malinen <j@w1.fi>

Add new nl80211 attributes that can be used with NL80211_CMD_SET_WIPHY
and NL80211_CMD_GET_WIPHY to manage fragmentation/RTS threshold and
retry limits.

Since these values are stored in struct wiphy, remove the local copy
from mac80211 where feasible (frag & rts threshold). The retry limits
are currently needed in struct ieee80211_conf, but these could be
eventually removed since the driver should have access to the values
in struct wiphy.

Johannes: Rebase, and additionally move the wext handlers to cfg80211
and correct the retry wext handler to use wireless extensions v21 (retry
long/short rather than min/max).

Signed-off-by: Jouni Malinen <j@w1.fi>
Signed-off-by: Johannes Berg <johannes@sipsolutions.net>
---
 include/linux/nl80211.h    |   24 ++++++
 include/net/cfg80211.h     |   50 ++++++++++++++
 net/mac80211/cfg.c         |   27 +++++++
 net/mac80211/debugfs.c     |    8 +-
 net/mac80211/ieee80211_i.h |    3 
 net/mac80211/main.c        |    6 -
 net/mac80211/tx.c          |    9 +-
 net/mac80211/util.c        |    2 
 net/mac80211/wext.c        |  138 +--------------------------------------
 net/wireless/core.c        |   10 ++
 net/wireless/nl80211.c     |   95 +++++++++++++++++++++++++++
 net/wireless/wext-compat.c |  158 +++++++++++++++++++++++++++++++++++++++++++++
 12 files changed, 379 insertions(+), 151 deletions(-)

v2: make set_wiphy_params() a notification function that does not return
    an error code (too complex to figure out what to do on error and not
    much of a problem if the new values are left in struct wiphy)
v3: (Johannes -- no userspace API/ABI changes)
    * actually make set_wiphy_params() have an error return again
    * rebase
    * wext handlers moved & wext v21

--- wireless-testing.orig/include/linux/nl80211.h	2009-04-20 12:06:13.000000000 +0200
+++ wireless-testing/include/linux/nl80211.h	2009-04-20 14:04:31.000000000 +0200
@@ -46,8 +46,10 @@
  *	to get a list of all present wiphys.
  * @NL80211_CMD_SET_WIPHY: set wiphy parameters, needs %NL80211_ATTR_WIPHY or
  *	%NL80211_ATTR_IFINDEX; can be used to set %NL80211_ATTR_WIPHY_NAME,
- *	%NL80211_ATTR_WIPHY_TXQ_PARAMS, %NL80211_ATTR_WIPHY_FREQ, and/or
- *	%NL80211_ATTR_WIPHY_CHANNEL_TYPE.
+ *	%NL80211_ATTR_WIPHY_TXQ_PARAMS, %NL80211_ATTR_WIPHY_FREQ,
+ *	%NL80211_ATTR_WIPHY_CHANNEL_TYPE, %NL80211_ATTR_WIPHY_RETRY_SHORT,
+ *	%NL80211_ATTR_WIPHY_RETRY_LONG, %NL80211_ATTR_WIPHY_FRAG_THRESHOLD,
+ *	and/or %NL80211_ATTR_WIPHY_RTS_THRESHOLD.
  * @NL80211_CMD_NEW_WIPHY: Newly created wiphy, response to get request
  *	or rename notification. Has attributes %NL80211_ATTR_WIPHY and
  *	%NL80211_ATTR_WIPHY_NAME.
@@ -337,6 +339,18 @@ enum nl80211_commands {
  *	NL80211_CHAN_HT20 = HT20 only
  *	NL80211_CHAN_HT40MINUS = secondary channel is below the primary channel
  *	NL80211_CHAN_HT40PLUS = secondary channel is above the primary channel
+ * @NL80211_ATTR_WIPHY_RETRY_SHORT: TX retry limit for frames whose length is
+ *	less than or equal to the RTS threshold; allowed range: 1..255;
+ *	dot11ShortRetryLimit; u8
+ * @NL80211_ATTR_WIPHY_RETRY_LONG: TX retry limit for frames whose length is
+ *	greater than the RTS threshold; allowed range: 1..255;
+ *	dot11ShortLongLimit; u8
+ * @NL80211_ATTR_WIPHY_FRAG_THRESHOLD: fragmentation threshold, i.e., maximum
+ *	length in octets for frames; allowed range: 256..8000, disable
+ *	fragmentation with (u32)-1; dot11FragmentationThreshold; u32
+ * @NL80211_ATTR_WIPHY_RTS_THRESHOLD: RTS threshold (TX frames with length
+ *	larger than or equal to this use RTS/CTS handshake); allowed range:
+ *	0..65536, disable with (u32)-1; dot11RTSThreshold; u32
  *
  * @NL80211_ATTR_IFINDEX: network interface index of the device to operate on
  * @NL80211_ATTR_IFNAME: network interface name
@@ -565,6 +579,12 @@ enum nl80211_attrs {
 
 	NL80211_ATTR_FREQ_FIXED,
 
+
+	NL80211_ATTR_WIPHY_RETRY_SHORT,
+	NL80211_ATTR_WIPHY_RETRY_LONG,
+	NL80211_ATTR_WIPHY_FRAG_THRESHOLD,
+	NL80211_ATTR_WIPHY_RTS_THRESHOLD,
+
 	/* add attributes here, update the policy in nl80211.c */
 
 	__NL80211_ATTR_AFTER_LAST,
--- wireless-testing.orig/include/net/cfg80211.h	2009-04-20 13:44:41.000000000 +0200
+++ wireless-testing/include/net/cfg80211.h	2009-04-20 14:27:59.000000000 +0200
@@ -744,6 +744,20 @@ struct cfg80211_ibss_params {
 };
 
 /**
+ * enum wiphy_params_flags - set_wiphy_params bitfield values
+ * WIPHY_PARAM_RETRY_SHORT: wiphy->retry_short has changed
+ * WIPHY_PARAM_RETRY_LONG: wiphy->retry_long has changed
+ * WIPHY_PARAM_FRAG_THRESHOLD: wiphy->frag_threshold has changed
+ * WIPHY_PARAM_RTS_THRESHOLD: wiphy->rts_threshold has changed
+ */
+enum wiphy_params_flags {
+	WIPHY_PARAM_RETRY_SHORT		= 1 << 0,
+	WIPHY_PARAM_RETRY_LONG		= 1 << 1,
+	WIPHY_PARAM_FRAG_THRESHOLD	= 1 << 2,
+	WIPHY_PARAM_RTS_THRESHOLD	= 1 << 3,
+};
+
+/**
  * struct cfg80211_ops - backend description for wireless configuration
  *
  * This struct is registered by fullmac card drivers and/or wireless stacks
@@ -823,6 +837,11 @@ struct cfg80211_ibss_params {
  *	cfg80211_ibss_joined(), also call that function when changing BSSID due
  *	to a merge.
  * @leave_ibss: Leave the IBSS.
+ *
+ * @set_wiphy_params: Notify that wiphy parameters have changed;
+ *	@changed bitfield (see &enum wiphy_params_flags) describes which values
+ *	have changed. The actual parameter values are available in
+ *	struct wiphy. If returning an error, no value should be changed.
  */
 struct cfg80211_ops {
 	int	(*suspend)(struct wiphy *wiphy);
@@ -912,6 +931,8 @@ struct cfg80211_ops {
 	int	(*join_ibss)(struct wiphy *wiphy, struct net_device *dev,
 			     struct cfg80211_ibss_params *params);
 	int	(*leave_ibss)(struct wiphy *wiphy, struct net_device *dev);
+
+	int	(*set_wiphy_params)(struct wiphy *wiphy, u32 changed);
 };
 
 /*
@@ -945,6 +966,11 @@ struct cfg80211_ops {
  * @signal_type: signal type reported in &struct cfg80211_bss.
  * @cipher_suites: supported cipher suites
  * @n_cipher_suites: number of supported cipher suites
+ * @retry_short: Retry limit for short frames (dot11ShortRetryLimit)
+ * @retry_long: Retry limit for long frames (dot11LongRetryLimit)
+ * @frag_threshold: Fragmentation threshold (dot11FragmentationThreshold);
+ *	-1 = fragmentation disabled, only odd values >= 256 used
+ * @rts_threshold: RTS threshold (dot11RTSThreshold); -1 = RTS/CTS disabled
  */
 struct wiphy {
 	/* assign these fields before you register the wiphy */
@@ -967,6 +993,11 @@ struct wiphy {
 	int n_cipher_suites;
 	const u32 *cipher_suites;
 
+	u8 retry_short;
+	u8 retry_long;
+	u32 frag_threshold;
+	u32 rts_threshold;
+
 	/* If multiple wiphys are registered and you're handed e.g.
 	 * a regular netdev with assigned ieee80211_ptr, you won't
 	 * know whether it points to a wiphy your driver has registered
@@ -1345,6 +1376,25 @@ int cfg80211_ibss_wext_giwap(struct net_
 struct ieee80211_channel *cfg80211_wext_freq(struct wiphy *wiphy,
 					     struct iw_freq *freq);
 
+int cfg80211_wext_siwrts(struct net_device *dev,
+			 struct iw_request_info *info,
+			 struct iw_param *rts, char *extra);
+int cfg80211_wext_giwrts(struct net_device *dev,
+			 struct iw_request_info *info,
+			 struct iw_param *rts, char *extra);
+int cfg80211_wext_siwfrag(struct net_device *dev,
+			  struct iw_request_info *info,
+			  struct iw_param *frag, char *extra);
+int cfg80211_wext_giwfrag(struct net_device *dev,
+			  struct iw_request_info *info,
+			  struct iw_param *frag, char *extra);
+int cfg80211_wext_siwretry(struct net_device *dev,
+			   struct iw_request_info *info,
+			   struct iw_param *retry, char *extra);
+int cfg80211_wext_giwretry(struct net_device *dev,
+			   struct iw_request_info *info,
+			   struct iw_param *retry, char *extra);
+
 /*
  * callbacks for asynchronous cfg80211 methods, notification
  * functions and BSS handling helpers
--- wireless-testing.orig/net/mac80211/cfg.c	2009-04-20 12:06:13.000000000 +0200
+++ wireless-testing/net/mac80211/cfg.c	2009-04-20 14:11:15.000000000 +0200
@@ -1297,6 +1297,32 @@ static int ieee80211_leave_ibss(struct w
 	return ieee80211_ibss_leave(sdata);
 }
 
+static int ieee80211_set_wiphy_params(struct wiphy *wiphy, u32 changed)
+{
+	struct ieee80211_local *local = wiphy_priv(wiphy);
+
+	if (changed & WIPHY_PARAM_RTS_THRESHOLD) {
+		int err;
+
+		if (local->ops->set_rts_threshold) {
+			err = local->ops->set_rts_threshold(
+				local_to_hw(local), wiphy->rts_threshold);
+			if (err)
+				return err;
+		}
+	}
+
+	if (changed & WIPHY_PARAM_RETRY_SHORT)
+		local->hw.conf.short_frame_max_tx_count = wiphy->retry_short;
+	if (changed & WIPHY_PARAM_RETRY_LONG)
+		local->hw.conf.long_frame_max_tx_count = wiphy->retry_long;
+	if (changed &
+	    (WIPHY_PARAM_RETRY_SHORT | WIPHY_PARAM_RETRY_LONG))
+		ieee80211_hw_config(local, IEEE80211_CONF_CHANGE_RETRY_LIMITS);
+
+	return 0;
+}
+
 struct cfg80211_ops mac80211_config_ops = {
 	.add_virtual_intf = ieee80211_add_iface,
 	.del_virtual_intf = ieee80211_del_iface,
@@ -1335,4 +1361,5 @@ struct cfg80211_ops mac80211_config_ops 
 	.disassoc = ieee80211_disassoc,
 	.join_ibss = ieee80211_join_ibss,
 	.leave_ibss = ieee80211_leave_ibss,
+	.set_wiphy_params = ieee80211_set_wiphy_params,
 };
--- wireless-testing.orig/net/wireless/nl80211.c	2009-04-20 12:06:13.000000000 +0200
+++ wireless-testing/net/wireless/nl80211.c	2009-04-20 14:08:34.000000000 +0200
@@ -61,6 +61,10 @@ static struct nla_policy nl80211_policy[
 	[NL80211_ATTR_WIPHY_TXQ_PARAMS] = { .type = NLA_NESTED },
 	[NL80211_ATTR_WIPHY_FREQ] = { .type = NLA_U32 },
 	[NL80211_ATTR_WIPHY_CHANNEL_TYPE] = { .type = NLA_U32 },
+	[NL80211_ATTR_WIPHY_RETRY_SHORT] = { .type = NLA_U8 },
+	[NL80211_ATTR_WIPHY_RETRY_LONG] = { .type = NLA_U8 },
+	[NL80211_ATTR_WIPHY_FRAG_THRESHOLD] = { .type = NLA_U32 },
+	[NL80211_ATTR_WIPHY_RTS_THRESHOLD] = { .type = NLA_U32 },
 
 	[NL80211_ATTR_IFTYPE] = { .type = NLA_U32 },
 	[NL80211_ATTR_IFINDEX] = { .type = NLA_U32 },
@@ -204,6 +208,16 @@ static int nl80211_send_wiphy(struct sk_
 
 	NLA_PUT_U32(msg, NL80211_ATTR_WIPHY, dev->wiphy_idx);
 	NLA_PUT_STRING(msg, NL80211_ATTR_WIPHY_NAME, wiphy_name(&dev->wiphy));
+
+	NLA_PUT_U8(msg, NL80211_ATTR_WIPHY_RETRY_SHORT,
+		   dev->wiphy.retry_short);
+	NLA_PUT_U8(msg, NL80211_ATTR_WIPHY_RETRY_LONG,
+		   dev->wiphy.retry_long);
+	NLA_PUT_U32(msg, NL80211_ATTR_WIPHY_FRAG_THRESHOLD,
+		    dev->wiphy.frag_threshold);
+	NLA_PUT_U32(msg, NL80211_ATTR_WIPHY_RTS_THRESHOLD,
+		    dev->wiphy.rts_threshold);
+
 	NLA_PUT_U8(msg, NL80211_ATTR_MAX_NUM_SCAN_SSIDS,
 		   dev->wiphy.max_scan_ssids);
 	NLA_PUT_U16(msg, NL80211_ATTR_MAX_SCAN_IE_LEN,
@@ -416,6 +430,9 @@ static int nl80211_set_wiphy(struct sk_b
 	struct cfg80211_registered_device *rdev;
 	int result = 0, rem_txq_params = 0;
 	struct nlattr *nl_txq_params;
+	u32 changed;
+	u8 retry_short = 0, retry_long = 0;
+	u32 frag_threshold = 0, rts_threshold = 0;
 
 	rtnl_lock();
 
@@ -530,6 +547,84 @@ static int nl80211_set_wiphy(struct sk_b
 			goto bad_res;
 	}
 
+	changed = 0;
+
+	if (info->attrs[NL80211_ATTR_WIPHY_RETRY_SHORT]) {
+		retry_short = nla_get_u8(
+			info->attrs[NL80211_ATTR_WIPHY_RETRY_SHORT]);
+		if (retry_short == 0) {
+			result = -EINVAL;
+			goto bad_res;
+		}
+		changed |= WIPHY_PARAM_RETRY_SHORT;
+	}
+
+	if (info->attrs[NL80211_ATTR_WIPHY_RETRY_LONG]) {
+		retry_long = nla_get_u8(
+			info->attrs[NL80211_ATTR_WIPHY_RETRY_LONG]);
+		if (retry_long == 0) {
+			result = -EINVAL;
+			goto bad_res;
+		}
+		changed |= WIPHY_PARAM_RETRY_LONG;
+	}
+
+	if (info->attrs[NL80211_ATTR_WIPHY_FRAG_THRESHOLD]) {
+		frag_threshold = nla_get_u32(
+			info->attrs[NL80211_ATTR_WIPHY_FRAG_THRESHOLD]);
+		if (frag_threshold < 256) {
+			result = -EINVAL;
+			goto bad_res;
+		}
+		if (frag_threshold != (u32) -1) {
+			/*
+			 * Fragments (apart from the last one) are required to
+			 * have even length. Make the fragmentation code
+			 * simpler by stripping LSB should someone try to use
+			 * odd threshold value.
+			 */
+			frag_threshold &= ~0x1;
+		}
+		changed |= WIPHY_PARAM_FRAG_THRESHOLD;
+	}
+
+	if (info->attrs[NL80211_ATTR_WIPHY_RTS_THRESHOLD]) {
+		rts_threshold = nla_get_u32(
+			info->attrs[NL80211_ATTR_WIPHY_RTS_THRESHOLD]);
+		changed |= WIPHY_PARAM_RTS_THRESHOLD;
+	}
+
+	if (changed) {
+		u8 old_retry_short, old_retry_long;
+		u32 old_frag_threshold, old_rts_threshold;
+
+		if (!rdev->ops->set_wiphy_params) {
+			result = -EOPNOTSUPP;
+			goto bad_res;
+		}
+
+		old_retry_short = rdev->wiphy.retry_short;
+		old_retry_long = rdev->wiphy.retry_long;
+		old_frag_threshold = rdev->wiphy.frag_threshold;
+		old_rts_threshold = rdev->wiphy.rts_threshold;
+
+		if (changed & WIPHY_PARAM_RETRY_SHORT)
+			rdev->wiphy.retry_short = retry_short;
+		if (changed & WIPHY_PARAM_RETRY_LONG)
+			rdev->wiphy.retry_long = retry_long;
+		if (changed & WIPHY_PARAM_FRAG_THRESHOLD)
+			rdev->wiphy.frag_threshold = frag_threshold;
+		if (changed & WIPHY_PARAM_RTS_THRESHOLD)
+			rdev->wiphy.rts_threshold = rts_threshold;
+
+		result = rdev->ops->set_wiphy_params(&rdev->wiphy, changed);
+		if (result) {
+			rdev->wiphy.retry_short = old_retry_short;
+			rdev->wiphy.retry_long = old_retry_long;
+			rdev->wiphy.frag_threshold = old_frag_threshold;
+			rdev->wiphy.rts_threshold = old_rts_threshold;
+		}
+	}
 
  bad_res:
 	mutex_unlock(&rdev->mtx);
--- wireless-testing.orig/net/mac80211/debugfs.c	2009-04-18 23:47:32.000000000 +0200
+++ wireless-testing/net/mac80211/debugfs.c	2009-04-20 14:04:31.000000000 +0200
@@ -52,13 +52,13 @@ static const struct file_operations name
 DEBUGFS_READONLY_FILE(frequency, 20, "%d",
 		      local->hw.conf.channel->center_freq);
 DEBUGFS_READONLY_FILE(rts_threshold, 20, "%d",
-		      local->rts_threshold);
+		      local->hw.wiphy->rts_threshold);
 DEBUGFS_READONLY_FILE(fragmentation_threshold, 20, "%d",
-		      local->fragmentation_threshold);
+		      local->hw.wiphy->frag_threshold);
 DEBUGFS_READONLY_FILE(short_retry_limit, 20, "%d",
-		      local->hw.conf.short_frame_max_tx_count);
+		      local->hw.wiphy->retry_short);
 DEBUGFS_READONLY_FILE(long_retry_limit, 20, "%d",
-		      local->hw.conf.long_frame_max_tx_count);
+		      local->hw.wiphy->retry_long);
 DEBUGFS_READONLY_FILE(total_ps_buffered, 20, "%d",
 		      local->total_ps_buffered);
 DEBUGFS_READONLY_FILE(wep_iv, 20, "%#08x",
--- wireless-testing.orig/net/mac80211/ieee80211_i.h	2009-04-20 13:43:05.000000000 +0200
+++ wireless-testing/net/mac80211/ieee80211_i.h	2009-04-20 14:04:31.000000000 +0200
@@ -643,9 +643,6 @@ struct ieee80211_local {
 
 	struct rate_control_ref *rate_ctrl;
 
-	int rts_threshold;
-	int fragmentation_threshold;
-
 	struct crypto_blkcipher *wep_tx_tfm;
 	struct crypto_blkcipher *wep_rx_tfm;
 	u32 wep_iv;
--- wireless-testing.orig/net/mac80211/main.c	2009-04-20 12:06:13.000000000 +0200
+++ wireless-testing/net/mac80211/main.c	2009-04-20 14:04:31.000000000 +0200
@@ -776,10 +776,8 @@ struct ieee80211_hw *ieee80211_alloc_hw(
 	/* set up some defaults */
 	local->hw.queues = 1;
 	local->hw.max_rates = 1;
-	local->rts_threshold = IEEE80211_MAX_RTS_THRESHOLD;
-	local->fragmentation_threshold = IEEE80211_MAX_FRAG_THRESHOLD;
-	local->hw.conf.long_frame_max_tx_count = 4;
-	local->hw.conf.short_frame_max_tx_count = 7;
+	local->hw.conf.long_frame_max_tx_count = wiphy->retry_long;
+	local->hw.conf.short_frame_max_tx_count = wiphy->retry_short;
 	local->hw.conf.radio_enabled = true;
 
 	INIT_LIST_HEAD(&local->interfaces);
--- wireless-testing.orig/net/mac80211/tx.c	2009-04-20 12:06:13.000000000 +0200
+++ wireless-testing/net/mac80211/tx.c	2009-04-20 14:04:31.000000000 +0200
@@ -500,7 +500,7 @@ ieee80211_tx_h_rate_ctrl(struct ieee8021
 	sband = tx->local->hw.wiphy->bands[tx->channel->band];
 
 	len = min_t(int, tx->skb->len + FCS_LEN,
-			 tx->local->fragmentation_threshold);
+			 tx->local->hw.wiphy->frag_threshold);
 
 	/* set up the tx rate control struct we give the RC algo */
 	txrc.hw = local_to_hw(tx->local);
@@ -511,8 +511,7 @@ ieee80211_tx_h_rate_ctrl(struct ieee8021
 	txrc.max_rate_idx = tx->sdata->max_ratectrl_rateidx;
 
 	/* set up RTS protection if desired */
-	if (tx->local->rts_threshold < IEEE80211_MAX_RTS_THRESHOLD &&
-	    len > tx->local->rts_threshold) {
+	if (len > tx->local->hw.wiphy->rts_threshold) {
 		txrc.rts = rts = true;
 	}
 
@@ -754,7 +753,7 @@ ieee80211_tx_h_fragment(struct ieee80211
 	struct sk_buff *skb = tx->skb;
 	struct ieee80211_tx_info *info = IEEE80211_SKB_CB(skb);
 	struct ieee80211_hdr *hdr = (void *)skb->data;
-	int frag_threshold = tx->local->fragmentation_threshold;
+	int frag_threshold = tx->local->hw.wiphy->frag_threshold;
 	int hdrlen;
 	int fragnum;
 
@@ -1072,7 +1071,7 @@ __ieee80211_tx_prepare(struct ieee80211_
 
 	if (tx->flags & IEEE80211_TX_FRAGMENTED) {
 		if ((tx->flags & IEEE80211_TX_UNICAST) &&
-		    skb->len + FCS_LEN > local->fragmentation_threshold &&
+		    skb->len + FCS_LEN > local->hw.wiphy->frag_threshold &&
 		    !(info->flags & IEEE80211_TX_CTL_AMPDU))
 			tx->flags |= IEEE80211_TX_FRAGMENTED;
 		else
--- wireless-testing.orig/net/mac80211/util.c	2009-04-20 12:06:13.000000000 +0200
+++ wireless-testing/net/mac80211/util.c	2009-04-20 14:04:31.000000000 +0200
@@ -1046,7 +1046,7 @@ int ieee80211_reconfig(struct ieee80211_
 
 	/* setup RTS threshold */
 	if (local->ops->set_rts_threshold)
-		local->ops->set_rts_threshold(hw, local->rts_threshold);
+		local->ops->set_rts_threshold(hw, hw->wiphy->rts_threshold);
 
 	/* reconfigure hardware */
 	ieee80211_hw_config(local, ~0);
--- wireless-testing.orig/net/mac80211/wext.c	2009-04-20 12:06:13.000000000 +0200
+++ wireless-testing/net/mac80211/wext.c	2009-04-20 14:26:47.000000000 +0200
@@ -472,132 +472,6 @@ static int ieee80211_ioctl_giwtxpower(st
 	return 0;
 }
 
-static int ieee80211_ioctl_siwrts(struct net_device *dev,
-				  struct iw_request_info *info,
-				  struct iw_param *rts, char *extra)
-{
-	struct ieee80211_local *local = wdev_priv(dev->ieee80211_ptr);
-
-	if (rts->disabled)
-		local->rts_threshold = IEEE80211_MAX_RTS_THRESHOLD;
-	else if (!rts->fixed)
-		/* if the rts value is not fixed, then take default */
-		local->rts_threshold = IEEE80211_MAX_RTS_THRESHOLD;
-	else if (rts->value < 0 || rts->value > IEEE80211_MAX_RTS_THRESHOLD)
-		return -EINVAL;
-	else
-		local->rts_threshold = rts->value;
-
-	/* If the wlan card performs RTS/CTS in hardware/firmware,
-	 * configure it here */
-
-	if (local->ops->set_rts_threshold)
-		local->ops->set_rts_threshold(local_to_hw(local),
-					     local->rts_threshold);
-
-	return 0;
-}
-
-static int ieee80211_ioctl_giwrts(struct net_device *dev,
-				  struct iw_request_info *info,
-				  struct iw_param *rts, char *extra)
-{
-	struct ieee80211_local *local = wdev_priv(dev->ieee80211_ptr);
-
-	rts->value = local->rts_threshold;
-	rts->disabled = (rts->value >= IEEE80211_MAX_RTS_THRESHOLD);
-	rts->fixed = 1;
-
-	return 0;
-}
-
-
-static int ieee80211_ioctl_siwfrag(struct net_device *dev,
-				   struct iw_request_info *info,
-				   struct iw_param *frag, char *extra)
-{
-	struct ieee80211_local *local = wdev_priv(dev->ieee80211_ptr);
-
-	if (frag->disabled)
-		local->fragmentation_threshold = IEEE80211_MAX_FRAG_THRESHOLD;
-	else if (!frag->fixed)
-		local->fragmentation_threshold = IEEE80211_MAX_FRAG_THRESHOLD;
-	else if (frag->value < 256 ||
-		 frag->value > IEEE80211_MAX_FRAG_THRESHOLD)
-		return -EINVAL;
-	else {
-		/* Fragment length must be even, so strip LSB. */
-		local->fragmentation_threshold = frag->value & ~0x1;
-	}
-
-	return 0;
-}
-
-static int ieee80211_ioctl_giwfrag(struct net_device *dev,
-				   struct iw_request_info *info,
-				   struct iw_param *frag, char *extra)
-{
-	struct ieee80211_local *local = wdev_priv(dev->ieee80211_ptr);
-
-	frag->value = local->fragmentation_threshold;
-	frag->disabled = (frag->value >= IEEE80211_MAX_FRAG_THRESHOLD);
-	frag->fixed = 1;
-
-	return 0;
-}
-
-
-static int ieee80211_ioctl_siwretry(struct net_device *dev,
-				    struct iw_request_info *info,
-				    struct iw_param *retry, char *extra)
-{
-	struct ieee80211_local *local = wdev_priv(dev->ieee80211_ptr);
-
-	if (retry->disabled ||
-	    (retry->flags & IW_RETRY_TYPE) != IW_RETRY_LIMIT)
-		return -EINVAL;
-
-	if (retry->flags & IW_RETRY_MAX) {
-		local->hw.conf.long_frame_max_tx_count = retry->value;
-	} else if (retry->flags & IW_RETRY_MIN) {
-		local->hw.conf.short_frame_max_tx_count = retry->value;
-	} else {
-		local->hw.conf.long_frame_max_tx_count = retry->value;
-		local->hw.conf.short_frame_max_tx_count = retry->value;
-	}
-
-	ieee80211_hw_config(local, IEEE80211_CONF_CHANGE_RETRY_LIMITS);
-
-	return 0;
-}
-
-
-static int ieee80211_ioctl_giwretry(struct net_device *dev,
-				    struct iw_request_info *info,
-				    struct iw_param *retry, char *extra)
-{
-	struct ieee80211_local *local = wdev_priv(dev->ieee80211_ptr);
-
-	retry->disabled = 0;
-	if (retry->flags == 0 || retry->flags & IW_RETRY_MIN) {
-		/* first return min value, iwconfig will ask max value
-		 * later if needed */
-		retry->flags |= IW_RETRY_LIMIT;
-		retry->value = local->hw.conf.short_frame_max_tx_count;
-		if (local->hw.conf.long_frame_max_tx_count !=
-		    local->hw.conf.short_frame_max_tx_count)
-			retry->flags |= IW_RETRY_MIN;
-		return 0;
-	}
-	if (retry->flags & IW_RETRY_MAX) {
-		retry->flags = IW_RETRY_LIMIT | IW_RETRY_MAX;
-		retry->value = local->hw.conf.long_frame_max_tx_count;
-	}
-
-	return 0;
-}
-
-
 static int ieee80211_ioctl_siwencode(struct net_device *dev,
 				     struct iw_request_info *info,
 				     struct iw_point *erq, char *keybuf)
@@ -1050,14 +924,14 @@ static const iw_handler ieee80211_handle
 	(iw_handler) NULL,				/* -- hole -- */
 	(iw_handler) ieee80211_ioctl_siwrate,		/* SIOCSIWRATE */
 	(iw_handler) ieee80211_ioctl_giwrate,		/* SIOCGIWRATE */
-	(iw_handler) ieee80211_ioctl_siwrts,		/* SIOCSIWRTS */
-	(iw_handler) ieee80211_ioctl_giwrts,		/* SIOCGIWRTS */
-	(iw_handler) ieee80211_ioctl_siwfrag,		/* SIOCSIWFRAG */
-	(iw_handler) ieee80211_ioctl_giwfrag,		/* SIOCGIWFRAG */
+	(iw_handler) cfg80211_wext_siwrts,		/* SIOCSIWRTS */
+	(iw_handler) cfg80211_wext_giwrts,		/* SIOCGIWRTS */
+	(iw_handler) cfg80211_wext_siwfrag,		/* SIOCSIWFRAG */
+	(iw_handler) cfg80211_wext_giwfrag,		/* SIOCGIWFRAG */
 	(iw_handler) ieee80211_ioctl_siwtxpower,	/* SIOCSIWTXPOW */
 	(iw_handler) ieee80211_ioctl_giwtxpower,	/* SIOCGIWTXPOW */
-	(iw_handler) ieee80211_ioctl_siwretry,		/* SIOCSIWRETRY */
-	(iw_handler) ieee80211_ioctl_giwretry,		/* SIOCGIWRETRY */
+	(iw_handler) cfg80211_wext_siwretry,		/* SIOCSIWRETRY */
+	(iw_handler) cfg80211_wext_giwretry,		/* SIOCGIWRETRY */
 	(iw_handler) ieee80211_ioctl_siwencode,		/* SIOCSIWENCODE */
 	(iw_handler) ieee80211_ioctl_giwencode,		/* SIOCGIWENCODE */
 	(iw_handler) ieee80211_ioctl_siwpower,		/* SIOCSIWPOWER */
--- wireless-testing.orig/net/wireless/core.c	2009-04-20 13:43:14.000000000 +0200
+++ wireless-testing/net/wireless/core.c	2009-04-20 14:04:31.000000000 +0200
@@ -273,6 +273,16 @@ struct wiphy *wiphy_new(struct cfg80211_
 	drv->wiphy.dev.class = &ieee80211_class;
 	drv->wiphy.dev.platform_data = drv;
 
+	/*
+	 * Initialize wiphy parameters to IEEE 802.11 MIB default values.
+	 * Fragmentation and RTS threshold are disabled by default with the
+	 * special -1 value.
+	 */
+	drv->wiphy.retry_short = 7;
+	drv->wiphy.retry_long = 4;
+	drv->wiphy.frag_threshold = (u32) -1;
+	drv->wiphy.rts_threshold = (u32) -1;
+
 	return &drv->wiphy;
 }
 EXPORT_SYMBOL(wiphy_new);
--- wireless-testing.orig/net/wireless/wext-compat.c	2009-04-20 14:12:54.000000000 +0200
+++ wireless-testing/net/wireless/wext-compat.c	2009-04-20 14:47:57.000000000 +0200
@@ -314,3 +314,161 @@ struct ieee80211_channel *cfg80211_wext_
 
 }
 EXPORT_SYMBOL(cfg80211_wext_freq);
+
+int cfg80211_wext_siwrts(struct net_device *dev,
+			 struct iw_request_info *info,
+			 struct iw_param *rts, char *extra)
+{
+	struct wireless_dev *wdev = dev->ieee80211_ptr;
+	struct cfg80211_registered_device *rdev = wiphy_to_dev(wdev->wiphy);
+	u32 orts = wdev->wiphy->rts_threshold;
+	int err;
+
+	if (rts->disabled || !rts->fixed)
+		wdev->wiphy->rts_threshold = (u32) -1;
+	else if (rts->value < 0)
+		return -EINVAL;
+	else
+		wdev->wiphy->rts_threshold = rts->value;
+
+	err = rdev->ops->set_wiphy_params(wdev->wiphy,
+					  WIPHY_PARAM_RTS_THRESHOLD);
+	if (err)
+		wdev->wiphy->rts_threshold = orts;
+
+	return err;
+}
+EXPORT_SYMBOL(cfg80211_wext_siwrts);
+
+int cfg80211_wext_giwrts(struct net_device *dev,
+			 struct iw_request_info *info,
+			 struct iw_param *rts, char *extra)
+{
+	struct wireless_dev *wdev = dev->ieee80211_ptr;
+
+	rts->value = wdev->wiphy->rts_threshold;
+	rts->disabled = rts->value == (u32) -1;
+	rts->fixed = 1;
+
+	return 0;
+}
+EXPORT_SYMBOL(cfg80211_wext_giwrts);
+
+int cfg80211_wext_siwfrag(struct net_device *dev,
+			  struct iw_request_info *info,
+			  struct iw_param *frag, char *extra)
+{
+	struct wireless_dev *wdev = dev->ieee80211_ptr;
+	struct cfg80211_registered_device *rdev = wiphy_to_dev(wdev->wiphy);
+	u32 ofrag = wdev->wiphy->frag_threshold;
+	int err;
+
+	if (frag->disabled || !frag->fixed)
+		wdev->wiphy->frag_threshold = (u32) -1;
+	else if (frag->value < 256)
+		return -EINVAL;
+	else {
+		/* Fragment length must be even, so strip LSB. */
+		wdev->wiphy->frag_threshold = frag->value & ~0x1;
+	}
+
+	err = rdev->ops->set_wiphy_params(wdev->wiphy,
+					  WIPHY_PARAM_FRAG_THRESHOLD);
+	if (err)
+		wdev->wiphy->frag_threshold = ofrag;
+
+	return err;
+}
+EXPORT_SYMBOL(cfg80211_wext_siwfrag);
+
+int cfg80211_wext_giwfrag(struct net_device *dev,
+			  struct iw_request_info *info,
+			  struct iw_param *frag, char *extra)
+{
+	struct wireless_dev *wdev = dev->ieee80211_ptr;
+
+	frag->value = wdev->wiphy->frag_threshold;
+	frag->disabled = frag->value == (u32) -1;
+	frag->fixed = 1;
+
+	return 0;
+}
+EXPORT_SYMBOL(cfg80211_wext_giwfrag);
+
+int cfg80211_wext_siwretry(struct net_device *dev,
+			   struct iw_request_info *info,
+			   struct iw_param *retry, char *extra)
+{
+	struct wireless_dev *wdev = dev->ieee80211_ptr;
+	struct cfg80211_registered_device *rdev = wiphy_to_dev(wdev->wiphy);
+	u32 changed = 0;
+	u8 olong = wdev->wiphy->retry_long;
+	u8 oshort = wdev->wiphy->retry_short;
+	int err;
+
+	if (retry->disabled ||
+	    (retry->flags & IW_RETRY_TYPE) != IW_RETRY_LIMIT)
+		return -EINVAL;
+
+	printk(KERN_DEBUG "long = %#x\n", IW_RETRY_LONG);
+	printk(KERN_DEBUG "short = %#x\n", IW_RETRY_SHORT);
+	printk(KERN_DEBUG "flags = %#x\n", retry->flags);
+
+	if (retry->flags & IW_RETRY_LONG) {
+		wdev->wiphy->retry_long = retry->value;
+		changed |= WIPHY_PARAM_RETRY_LONG;
+	} else if (retry->flags & IW_RETRY_SHORT) {
+		wdev->wiphy->retry_short = retry->value;
+		changed |= WIPHY_PARAM_RETRY_SHORT;
+	} else {
+		wdev->wiphy->retry_short = retry->value;
+		wdev->wiphy->retry_long = retry->value;
+		changed |= WIPHY_PARAM_RETRY_LONG;
+		changed |= WIPHY_PARAM_RETRY_SHORT;
+	}
+
+	if (!changed)
+		return 0;
+
+	err = rdev->ops->set_wiphy_params(wdev->wiphy, changed);
+	if (err) {
+		wdev->wiphy->retry_short = oshort;
+		wdev->wiphy->retry_long = olong;
+	}
+
+	return err;
+}
+EXPORT_SYMBOL(cfg80211_wext_siwretry);
+
+int cfg80211_wext_giwretry(struct net_device *dev,
+			   struct iw_request_info *info,
+			   struct iw_param *retry, char *extra)
+{
+	struct wireless_dev *wdev = dev->ieee80211_ptr;
+
+	retry->disabled = 0;
+
+	if (retry->flags == 0 || (retry->flags & IW_RETRY_SHORT)) {
+		/*
+		 * First return short value, iwconfig will ask long value
+		 * later if needed
+		 */
+		retry->flags |= IW_RETRY_LIMIT;
+		retry->value = wdev->wiphy->retry_short;
+		if (wdev->wiphy->retry_long != wdev->wiphy->retry_short)
+			retry->flags |= IW_RETRY_LONG;
+
+		printk(KERN_DEBUG "return %#x (%d)\n", retry->flags, retry->value);
+
+		return 0;
+	}
+
+	if (retry->flags & IW_RETRY_LONG) {
+		retry->flags = IW_RETRY_LIMIT | IW_RETRY_LONG;
+		retry->value = wdev->wiphy->retry_long;
+		printk(KERN_DEBUG "return %#x (%d)\n", retry->flags, retry->value);
+	}
+
+	return 0;
+}
+EXPORT_SYMBOL(cfg80211_wext_giwretry);


