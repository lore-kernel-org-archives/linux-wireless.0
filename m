Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from 128-177-27-249.ip.openhosting.com ([128.177.27.249]:46128 "EHLO
	jmalinen.user.openhosting.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751445AbZDQUMG (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 17 Apr 2009 16:12:06 -0400
Date: Fri, 17 Apr 2009 23:11:16 +0300
From: Jouni Malinen <j@w1.fi>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: "John W. Linville" <linville@tuxdriver.com>,
	linux-wireless@vger.kernel.org
Subject: [PATCH v2] nl80211: Add set/get for frag/rts threshold and retry
	limits
Message-ID: <20090417201115.GA27051@jm.kir.nu> (sfid-20090417_221522_297334_4A5818E1)
References: <20090417184629.GA9275@jm.kir.nu> <1239996573.5110.12.camel@johannes.local> <20090417193838.GA21250@jm.kir.nu> <1239997685.4543.1.camel@johannes.local>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1239997685.4543.1.camel@johannes.local>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Add new nl80211 attributes that can be used with NL80211_CMD_SET_WIPHY
and NL80211_CMD_GET_WIPHY to manage fragmentation/RTS threshold and
retry limits.

Since these values are stored in struct wiphy, remove the local copy
from mac80211 where feasible (frag & rts threshold). The retry limits
are currently needed in struct ieee80211_conf, but these could be
eventually removed since the driver should have access to the values
in struct wiphy.

Signed-off-by: Jouni Malinen <j@w1.fi>

---
 include/linux/nl80211.h    |   24 ++++++++++++-
 include/net/cfg80211.h     |   21 +++++++++++
 include/net/wireless.h     |   10 +++++
 net/mac80211/cfg.c         |   20 +++++++++++
 net/mac80211/debugfs.c     |    8 ++--
 net/mac80211/ieee80211_i.h |    3 -
 net/mac80211/main.c        |    6 +--
 net/mac80211/tx.c          |    9 ++---
 net/mac80211/util.c        |    2 -
 net/mac80211/wext.c        |   35 ++++++++++---------
 net/wireless/core.c        |   10 +++++
 net/wireless/nl80211.c     |   81 +++++++++++++++++++++++++++++++++++++++++++++
 12 files changed, 194 insertions(+), 35 deletions(-)

v2: make set_wiphy_params() a notification function that does not return
    an error code (too complex to figure out what to do on error and not
    much of a problem if the new values are left in struct wiphy)

--- uml.orig/include/linux/nl80211.h	2009-04-16 19:21:27.000000000 +0300
+++ uml/include/linux/nl80211.h	2009-04-17 22:59:46.000000000 +0300
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
@@ -325,6 +327,18 @@ enum nl80211_commands {
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
@@ -547,6 +561,12 @@ enum nl80211_attrs {
 
 	NL80211_ATTR_FREQ_BEFORE,
 	NL80211_ATTR_FREQ_AFTER,
+
+	NL80211_ATTR_WIPHY_RETRY_SHORT,
+	NL80211_ATTR_WIPHY_RETRY_LONG,
+	NL80211_ATTR_WIPHY_FRAG_THRESHOLD,
+	NL80211_ATTR_WIPHY_RTS_THRESHOLD,
+
 	/* add attributes here, update the policy in nl80211.c */
 
 	__NL80211_ATTR_AFTER_LAST,
--- uml.orig/include/net/cfg80211.h	2009-04-16 20:31:26.000000000 +0300
+++ uml/include/net/cfg80211.h	2009-04-17 23:06:40.000000000 +0300
@@ -658,6 +658,20 @@ struct cfg80211_disassoc_request {
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
@@ -732,6 +746,11 @@ struct cfg80211_disassoc_request {
  * @assoc: Request to (re)associate with the specified peer
  * @deauth: Request to deauthenticate from the specified peer
  * @disassoc: Request to disassociate from the specified peer
+ *
+ * @set_wiphy_params: Notify that wiphy parameters have changed;
+ *	@changed bitfield (see &enum wiphy_params_flags) describes which values
+ *	have changed. The actual parameter values are available in
+ *	struct wiphy.
  */
 struct cfg80211_ops {
 	int	(*suspend)(struct wiphy *wiphy);
@@ -817,6 +836,8 @@ struct cfg80211_ops {
 			  struct cfg80211_deauth_request *req);
 	int	(*disassoc)(struct wiphy *wiphy, struct net_device *dev,
 			    struct cfg80211_disassoc_request *req);
+
+	void	(*set_wiphy_params)(struct wiphy *wiphy, u32 changed);
 };
 
 /* temporary wext handlers */
--- uml.orig/net/mac80211/cfg.c	2009-04-16 21:10:53.000000000 +0300
+++ uml/net/mac80211/cfg.c	2009-04-17 23:06:57.000000000 +0300
@@ -1287,6 +1287,25 @@ static int ieee80211_disassoc(struct wip
 	return ieee80211_sta_disassociate(sdata, req->reason_code);
 }
 
+static void ieee80211_set_wiphy_params(struct wiphy *wiphy, u32 changed)
+{
+	struct ieee80211_local *local = wiphy_priv(wiphy);
+
+	if (changed & WIPHY_PARAM_RETRY_SHORT)
+		local->hw.conf.short_frame_max_tx_count = wiphy->retry_short;
+	if (changed & WIPHY_PARAM_RETRY_LONG)
+		local->hw.conf.long_frame_max_tx_count = wiphy->retry_long;
+	if (changed &
+	    (WIPHY_PARAM_RETRY_SHORT | WIPHY_PARAM_RETRY_LONG))
+		ieee80211_hw_config(local, IEEE80211_CONF_CHANGE_RETRY_LIMITS);
+
+	if (changed & WIPHY_PARAM_RTS_THRESHOLD) {
+		if (local->ops->set_rts_threshold)
+			local->ops->set_rts_threshold(local_to_hw(local),
+						      wiphy->rts_threshold);
+	}
+}
+
 struct cfg80211_ops mac80211_config_ops = {
 	.add_virtual_intf = ieee80211_add_iface,
 	.del_virtual_intf = ieee80211_del_iface,
@@ -1323,4 +1342,5 @@ struct cfg80211_ops mac80211_config_ops 
 	.assoc = ieee80211_assoc,
 	.deauth = ieee80211_deauth,
 	.disassoc = ieee80211_disassoc,
+	.set_wiphy_params = ieee80211_set_wiphy_params,
 };
--- uml.orig/net/wireless/nl80211.c	2009-04-16 20:26:25.000000000 +0300
+++ uml/net/wireless/nl80211.c	2009-04-17 23:05:47.000000000 +0300
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
@@ -203,6 +207,16 @@ static int nl80211_send_wiphy(struct sk_
 
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
@@ -414,6 +428,9 @@ static int nl80211_set_wiphy(struct sk_b
 	struct cfg80211_registered_device *rdev;
 	int result = 0, rem_txq_params = 0;
 	struct nlattr *nl_txq_params;
+	u32 changed;
+	u8 retry_short = 0, retry_long = 0;
+	u32 frag_threshold = 0, rts_threshold = 0;
 
 	rtnl_lock();
 
@@ -528,6 +545,70 @@ static int nl80211_set_wiphy(struct sk_b
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
+		if (!rdev->ops->set_wiphy_params) {
+			result = -EOPNOTSUPP;
+			goto bad_res;
+		}
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
+		rdev->ops->set_wiphy_params(&rdev->wiphy, changed);
+	}
 
  bad_res:
 	mutex_unlock(&rdev->mtx);
--- uml.orig/include/net/wireless.h	2009-04-17 20:32:43.000000000 +0300
+++ uml/include/net/wireless.h	2009-04-17 20:34:21.000000000 +0300
@@ -207,6 +207,11 @@ struct ieee80211_supported_band {
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
@@ -229,6 +234,11 @@ struct wiphy {
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
--- uml.orig/net/mac80211/debugfs.c	2009-04-17 21:06:18.000000000 +0300
+++ uml/net/mac80211/debugfs.c	2009-04-17 21:06:56.000000000 +0300
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
--- uml.orig/net/mac80211/ieee80211_i.h	2009-04-17 20:55:22.000000000 +0300
+++ uml/net/mac80211/ieee80211_i.h	2009-04-17 20:55:32.000000000 +0300
@@ -647,9 +647,6 @@ struct ieee80211_local {
 
 	struct rate_control_ref *rate_ctrl;
 
-	int rts_threshold;
-	int fragmentation_threshold;
-
 	struct crypto_blkcipher *wep_tx_tfm;
 	struct crypto_blkcipher *wep_rx_tfm;
 	u32 wep_iv;
--- uml.orig/net/mac80211/main.c	2009-04-17 20:41:22.000000000 +0300
+++ uml/net/mac80211/main.c	2009-04-17 20:56:29.000000000 +0300
@@ -775,10 +775,8 @@ struct ieee80211_hw *ieee80211_alloc_hw(
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
--- uml.orig/net/mac80211/tx.c	2009-04-17 21:03:25.000000000 +0300
+++ uml/net/mac80211/tx.c	2009-04-17 21:04:56.000000000 +0300
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
--- uml.orig/net/mac80211/util.c	2009-04-17 21:05:16.000000000 +0300
+++ uml/net/mac80211/util.c	2009-04-17 21:05:47.000000000 +0300
@@ -1025,7 +1025,7 @@ int ieee80211_reconfig(struct ieee80211_
 
 	/* setup RTS threshold */
 	if (local->ops->set_rts_threshold)
-		local->ops->set_rts_threshold(hw, local->rts_threshold);
+		local->ops->set_rts_threshold(hw, hw->wiphy->rts_threshold);
 
 	/* reconfigure hardware */
 	ieee80211_hw_config(local, ~0);
--- uml.orig/net/mac80211/wext.c	2009-04-17 20:56:15.000000000 +0300
+++ uml/net/mac80211/wext.c	2009-04-17 22:59:46.000000000 +0300
@@ -494,21 +494,21 @@ static int ieee80211_ioctl_siwrts(struct
 	struct ieee80211_local *local = wdev_priv(dev->ieee80211_ptr);
 
 	if (rts->disabled)
-		local->rts_threshold = IEEE80211_MAX_RTS_THRESHOLD;
+		local->hw.wiphy->rts_threshold = (u32) -1;
 	else if (!rts->fixed)
 		/* if the rts value is not fixed, then take default */
-		local->rts_threshold = IEEE80211_MAX_RTS_THRESHOLD;
-	else if (rts->value < 0 || rts->value > IEEE80211_MAX_RTS_THRESHOLD)
+		local->hw.wiphy->rts_threshold = (u32) -1;
+	else if (rts->value < 0)
 		return -EINVAL;
 	else
-		local->rts_threshold = rts->value;
+		local->hw.wiphy->rts_threshold = rts->value;
 
 	/* If the wlan card performs RTS/CTS in hardware/firmware,
 	 * configure it here */
 
 	if (local->ops->set_rts_threshold)
 		local->ops->set_rts_threshold(local_to_hw(local),
-					     local->rts_threshold);
+					     local->hw.wiphy->rts_threshold);
 
 	return 0;
 }
@@ -519,7 +519,7 @@ static int ieee80211_ioctl_giwrts(struct
 {
 	struct ieee80211_local *local = wdev_priv(dev->ieee80211_ptr);
 
-	rts->value = local->rts_threshold;
+	rts->value = local->hw.wiphy->rts_threshold;
 	rts->disabled = (rts->value >= IEEE80211_MAX_RTS_THRESHOLD);
 	rts->fixed = 1;
 
@@ -534,15 +534,14 @@ static int ieee80211_ioctl_siwfrag(struc
 	struct ieee80211_local *local = wdev_priv(dev->ieee80211_ptr);
 
 	if (frag->disabled)
-		local->fragmentation_threshold = IEEE80211_MAX_FRAG_THRESHOLD;
+		local->hw.wiphy->frag_threshold = (u32) -1;
 	else if (!frag->fixed)
-		local->fragmentation_threshold = IEEE80211_MAX_FRAG_THRESHOLD;
-	else if (frag->value < 256 ||
-		 frag->value > IEEE80211_MAX_FRAG_THRESHOLD)
+		local->hw.wiphy->frag_threshold = (u32) -1;
+	else if (frag->value < 256)
 		return -EINVAL;
 	else {
 		/* Fragment length must be even, so strip LSB. */
-		local->fragmentation_threshold = frag->value & ~0x1;
+		local->hw.wiphy->frag_threshold = frag->value & ~0x1;
 	}
 
 	return 0;
@@ -554,7 +553,7 @@ static int ieee80211_ioctl_giwfrag(struc
 {
 	struct ieee80211_local *local = wdev_priv(dev->ieee80211_ptr);
 
-	frag->value = local->fragmentation_threshold;
+	frag->value = local->hw.wiphy->frag_threshold;
 	frag->disabled = (frag->value >= IEEE80211_MAX_FRAG_THRESHOLD);
 	frag->fixed = 1;
 
@@ -573,10 +572,14 @@ static int ieee80211_ioctl_siwretry(stru
 		return -EINVAL;
 
 	if (retry->flags & IW_RETRY_MAX) {
+		local->hw.wiphy->retry_long = retry->value;
 		local->hw.conf.long_frame_max_tx_count = retry->value;
 	} else if (retry->flags & IW_RETRY_MIN) {
+		local->hw.wiphy->retry_short = retry->value;
 		local->hw.conf.short_frame_max_tx_count = retry->value;
 	} else {
+		local->hw.wiphy->retry_short = retry->value;
+		local->hw.wiphy->retry_long = retry->value;
 		local->hw.conf.long_frame_max_tx_count = retry->value;
 		local->hw.conf.short_frame_max_tx_count = retry->value;
 	}
@@ -598,15 +601,15 @@ static int ieee80211_ioctl_giwretry(stru
 		/* first return min value, iwconfig will ask max value
 		 * later if needed */
 		retry->flags |= IW_RETRY_LIMIT;
-		retry->value = local->hw.conf.short_frame_max_tx_count;
-		if (local->hw.conf.long_frame_max_tx_count !=
-		    local->hw.conf.short_frame_max_tx_count)
+		retry->value = local->hw.wiphy->retry_short;
+		if (local->hw.wiphy->retry_long !=
+		    local->hw.wiphy->retry_short)
 			retry->flags |= IW_RETRY_MIN;
 		return 0;
 	}
 	if (retry->flags & IW_RETRY_MAX) {
 		retry->flags = IW_RETRY_LIMIT | IW_RETRY_MAX;
-		retry->value = local->hw.conf.long_frame_max_tx_count;
+		retry->value = local->hw.wiphy->retry_long;
 	}
 
 	return 0;
--- uml.orig/net/wireless/core.c	2009-04-16 21:58:02.000000000 +0300
+++ uml/net/wireless/core.c	2009-04-17 20:42:35.000000000 +0300
@@ -274,6 +274,16 @@ struct wiphy *wiphy_new(struct cfg80211_
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

-- 
Jouni Malinen                                            PGP id EFC895FA
