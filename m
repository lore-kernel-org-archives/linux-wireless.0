Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from 128-177-27-249.ip.openhosting.com ([128.177.27.249]:57805 "EHLO
	jmalinen.user.openhosting.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755535Ab0AFLJ1 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 6 Jan 2010 06:09:27 -0500
Date: Wed, 6 Jan 2010 13:09:08 +0200
From: Jouni Malinen <jouni.malinen@atheros.com>
To: "John W. Linville" <linville@tuxdriver.com>,
	Johannes Berg <johannes@sipsolutions.net>
Cc: linux-wireless@vger.kernel.org, Jouni Malinen <j@w1.fi>
Subject: [PATCH v2 2/3] cfg80211/mac80211: Use more generic bitrate mask
 for rate control
Message-ID: <20100106110908.GA3129@jm.kir.nu>
References: <20091229105932.GC18493@jm.kir.nu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <20091229105932.GC18493@jm.kir.nu>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Extend struct cfg80211_bitrate_mask to actually use a bitfield mask
instead of just a single fixed or maximum rate index. This change
itself does not modify the behavior (except for debugfs files), but it
prepares cfg80211 and mac80211 for a new nl80211 command for setting
which rates can be used in TX rate control.

Since frames are now going through the rate control algorithm
unconditionally, the internal IEEE80211_TX_INTFL_RCALGO flag can now
be removed. The RC implementations can use the rate_idx_mask value to
optimize their behavior if only a single rate is enabled.

The old max_rate_idx in struct ieee80211_tx_rate_control is maintained
(but commented as deprecated) for backwards compatibility with existing
RC implementations. Once these implementations have been updated to
use the more generic rate_idx_mask, the max_rate_idx value can be
removed.

Signed-off-by: Jouni Malinen <jouni.malinen@atheros.com>

---
 include/net/cfg80211.h        |   13 +-------
 include/net/mac80211.h        |    8 ++---
 net/mac80211/cfg.c            |   32 ++-------------------
 net/mac80211/debugfs_netdev.c |   22 ++++++++------
 net/mac80211/ieee80211_i.h    |    4 +-
 net/mac80211/iface.c          |    8 ++++-
 net/mac80211/rate.c           |   63 ++++++++++++++++++++++++++++++++++--------
 net/mac80211/rate.h           |    5 ---
 net/mac80211/tx.c             |   12 ++++++--
 net/wireless/wext-compat.c    |   34 ++++++++++++++++++++--
 10 files changed, 122 insertions(+), 79 deletions(-)

v2: Fixed the rate index enforcing code to allow changes to a lower
rate, too (previously, only higher rates were considered). This fixes
the existing behavior of maximum rate which can be set, e.g., with
"iwconfig wlan0 rate 24M auto"
(patches 1/3 and 3/3 remain unchanged)


--- uml.orig/net/mac80211/ieee80211_i.h	2010-01-06 12:09:53.000000000 +0200
+++ uml/net/mac80211/ieee80211_i.h	2010-01-06 12:11:11.000000000 +0200
@@ -494,8 +494,8 @@ struct ieee80211_sub_if_data {
 	 */
 	struct ieee80211_if_ap *bss;
 
-	int force_unicast_rateidx; /* forced TX rateidx for unicast frames */
-	int max_ratectrl_rateidx; /* max TX rateidx for rate control */
+	/* bitmap of allowed (non-MCS) rate indexes for rate control */
+	u32 rc_rateidx_mask[IEEE80211_NUM_BANDS];
 
 	union {
 		struct ieee80211_if_ap ap;
--- uml.orig/include/net/cfg80211.h	2010-01-06 12:09:53.000000000 +0200
+++ uml/include/net/cfg80211.h	2010-01-06 12:11:11.000000000 +0200
@@ -856,20 +856,11 @@ enum tx_power_setting {
  * cfg80211_bitrate_mask - masks for bitrate control
  */
 struct cfg80211_bitrate_mask {
-/*
- * As discussed in Berlin, this struct really
- * should look like this:
-
 	struct {
 		u32 legacy;
-		u8 mcs[IEEE80211_HT_MCS_MASK_LEN];
+		/* TODO: add support for masking MCS rates; e.g.: */
+		/* u8 mcs[IEEE80211_HT_MCS_MASK_LEN]; */
 	} control[IEEE80211_NUM_BANDS];
-
- * Since we can always fix in-kernel users, let's keep
- * it simpler for now:
- */
-	u32 fixed;   /* fixed bitrate, 0 == not fixed */
-	u32 maxrate; /* in kbps, 0 == no limit */
 };
 /**
  * struct cfg80211_pmksa - PMK Security Association
--- uml.orig/include/net/mac80211.h	2010-01-06 12:11:08.000000000 +0200
+++ uml/include/net/mac80211.h	2010-01-06 12:11:11.000000000 +0200
@@ -255,9 +255,6 @@ struct ieee80211_bss_conf {
  * @IEEE80211_TX_CTL_RATE_CTRL_PROBE: internal to mac80211, can be
  *	set by rate control algorithms to indicate probe rate, will
  *	be cleared for fragmented frames (except on the last fragment)
- * @IEEE80211_TX_INTFL_RCALGO: mac80211 internal flag, do not test or
- *	set this flag in the driver; indicates that the rate control
- *	algorithm was used and should be notified of TX status
  * @IEEE80211_TX_INTFL_NEED_TXPROCESSING: completely internal to mac80211,
  *	used to indicate that a pending frame requires TX processing before
  *	it can be sent out.
@@ -287,7 +284,6 @@ enum mac80211_tx_control_flags {
 	IEEE80211_TX_STAT_AMPDU			= BIT(10),
 	IEEE80211_TX_STAT_AMPDU_NO_BACK		= BIT(11),
 	IEEE80211_TX_CTL_RATE_CTRL_PROBE	= BIT(12),
-	IEEE80211_TX_INTFL_RCALGO		= BIT(13),
 	IEEE80211_TX_INTFL_NEED_TXPROCESSING	= BIT(14),
 	IEEE80211_TX_INTFL_RETRIED		= BIT(15),
 	IEEE80211_TX_INTFL_DONT_ENCRYPT		= BIT(16),
@@ -2292,6 +2288,9 @@ enum rate_control_changed {
  * @short_preamble: whether mac80211 will request short-preamble transmission
  *	if the selected rate supports it
  * @max_rate_idx: user-requested maximum rate (not MCS for now)
+ *	(deprecated; this will be removed once drivers get updated to use
+ *	rate_idx_mask)
+ * @rate_idx_mask: user-requested rate mask (not MCS for now)
  * @skb: the skb that will be transmitted, the control information in it needs
  *	to be filled in
  * @ap: whether this frame is sent out in AP mode
@@ -2304,6 +2303,7 @@ struct ieee80211_tx_rate_control {
 	struct ieee80211_tx_rate reported_rate;
 	bool rts, short_preamble;
 	u8 max_rate_idx;
+	u32 rate_idx_mask;
 	bool ap;
 };
 
--- uml.orig/net/mac80211/debugfs_netdev.c	2010-01-06 12:09:53.000000000 +0200
+++ uml/net/mac80211/debugfs_netdev.c	2010-01-06 12:11:11.000000000 +0200
@@ -127,8 +127,10 @@ __IEEE80211_IF_FILE(name, ieee80211_if_w
 
 /* common attributes */
 IEEE80211_IF_FILE(drop_unencrypted, drop_unencrypted, DEC);
-IEEE80211_IF_FILE(force_unicast_rateidx, force_unicast_rateidx, DEC);
-IEEE80211_IF_FILE(max_ratectrl_rateidx, max_ratectrl_rateidx, DEC);
+IEEE80211_IF_FILE(rc_rateidx_mask_2ghz, rc_rateidx_mask[IEEE80211_BAND_2GHZ],
+		  HEX);
+IEEE80211_IF_FILE(rc_rateidx_mask_5ghz, rc_rateidx_mask[IEEE80211_BAND_5GHZ],
+		  HEX);
 
 /* STA attributes */
 IEEE80211_IF_FILE(bssid, u.mgd.bssid, MAC);
@@ -264,8 +266,8 @@ IEEE80211_IF_FILE(dot11MeshHWMPRootMode,
 static void add_sta_files(struct ieee80211_sub_if_data *sdata)
 {
 	DEBUGFS_ADD(drop_unencrypted, sta);
-	DEBUGFS_ADD(force_unicast_rateidx, sta);
-	DEBUGFS_ADD(max_ratectrl_rateidx, sta);
+	DEBUGFS_ADD(rc_rateidx_mask_2ghz, sta);
+	DEBUGFS_ADD(rc_rateidx_mask_5ghz, sta);
 
 	DEBUGFS_ADD(bssid, sta);
 	DEBUGFS_ADD(aid, sta);
@@ -275,8 +277,8 @@ static void add_sta_files(struct ieee802
 static void add_ap_files(struct ieee80211_sub_if_data *sdata)
 {
 	DEBUGFS_ADD(drop_unencrypted, ap);
-	DEBUGFS_ADD(force_unicast_rateidx, ap);
-	DEBUGFS_ADD(max_ratectrl_rateidx, ap);
+	DEBUGFS_ADD(rc_rateidx_mask_2ghz, ap);
+	DEBUGFS_ADD(rc_rateidx_mask_5ghz, ap);
 
 	DEBUGFS_ADD(num_sta_ps, ap);
 	DEBUGFS_ADD(dtim_count, ap);
@@ -286,8 +288,8 @@ static void add_ap_files(struct ieee8021
 static void add_wds_files(struct ieee80211_sub_if_data *sdata)
 {
 	DEBUGFS_ADD(drop_unencrypted, wds);
-	DEBUGFS_ADD(force_unicast_rateidx, wds);
-	DEBUGFS_ADD(max_ratectrl_rateidx, wds);
+	DEBUGFS_ADD(rc_rateidx_mask_2ghz, wds);
+	DEBUGFS_ADD(rc_rateidx_mask_5ghz, wds);
 
 	DEBUGFS_ADD(peer, wds);
 }
@@ -295,8 +297,8 @@ static void add_wds_files(struct ieee802
 static void add_vlan_files(struct ieee80211_sub_if_data *sdata)
 {
 	DEBUGFS_ADD(drop_unencrypted, vlan);
-	DEBUGFS_ADD(force_unicast_rateidx, vlan);
-	DEBUGFS_ADD(max_ratectrl_rateidx, vlan);
+	DEBUGFS_ADD(rc_rateidx_mask_2ghz, vlan);
+	DEBUGFS_ADD(rc_rateidx_mask_5ghz, vlan);
 }
 
 static void add_monitor_files(struct ieee80211_sub_if_data *sdata)
--- uml.orig/net/mac80211/iface.c	2010-01-06 12:10:17.000000000 +0200
+++ uml/net/mac80211/iface.c	2010-01-06 12:11:11.000000000 +0200
@@ -856,8 +856,12 @@ int ieee80211_if_add(struct ieee80211_lo
 
 	INIT_LIST_HEAD(&sdata->key_list);
 
-	sdata->force_unicast_rateidx = -1;
-	sdata->max_ratectrl_rateidx = -1;
+	for (i = 0; i < IEEE80211_NUM_BANDS; i++) {
+		struct ieee80211_supported_band *sband;
+		sband = local->hw.wiphy->bands[i];
+		sdata->rc_rateidx_mask[i] =
+			sband ? (1 << sband->n_bitrates) - 1 : 0;
+	}
 
 	/* setup type-dependent data */
 	ieee80211_setup_sdata(sdata, type);
--- uml.orig/net/mac80211/rate.c	2010-01-06 12:11:08.000000000 +0200
+++ uml/net/mac80211/rate.c	2010-01-06 12:11:11.000000000 +0200
@@ -249,6 +249,38 @@ bool rate_control_send_low(struct ieee80
 }
 EXPORT_SYMBOL(rate_control_send_low);
 
+static void rate_idx_match_mask(struct ieee80211_tx_rate *rate,
+				int n_bitrates, u32 mask)
+{
+	int j;
+
+	/* See whether the selected rate or anything below it is allowed. */
+	for (j = rate->idx; j >= 0; j--) {
+		if (mask & (1 << j)) {
+			/* Okay, found a suitable rate. Use it. */
+			rate->idx = j;
+			return;
+		}
+	}
+
+	/* Try to find a higher rate that would be allowed */
+	for (j = rate->idx + 1; j < n_bitrates; j++) {
+		if (mask & (1 << j)) {
+			/* Okay, found a suitable rate. Use it. */
+			rate->idx = j;
+			return;
+		}
+	}
+
+	/*
+	 * Uh.. No suitable rate exists. This should not really happen with
+	 * sane TX rate mask configurations. However, should someone manage to
+	 * configure supported rates and TX rate mask in incompatible way,
+	 * allow the frame to be transmitted with whatever the rate control
+	 * selected.
+	 */
+}
+
 void rate_control_get_rate(struct ieee80211_sub_if_data *sdata,
 			   struct sta_info *sta,
 			   struct ieee80211_tx_rate_control *txrc)
@@ -258,6 +290,7 @@ void rate_control_get_rate(struct ieee80
 	struct ieee80211_sta *ista = NULL;
 	struct ieee80211_tx_info *info = IEEE80211_SKB_CB(txrc->skb);
 	int i;
+	u32 mask;
 
 	if (sta) {
 		ista = &sta->sta;
@@ -270,23 +303,31 @@ void rate_control_get_rate(struct ieee80
 		info->control.rates[i].count = 1;
 	}
 
-	if (sta && sdata->force_unicast_rateidx > -1) {
-		info->control.rates[0].idx = sdata->force_unicast_rateidx;
-	} else {
-		ref->ops->get_rate(ref->priv, ista, priv_sta, txrc);
-		info->flags |= IEEE80211_TX_INTFL_RCALGO;
-	}
+	ref->ops->get_rate(ref->priv, ista, priv_sta, txrc);
 
 	/*
-	 * try to enforce the maximum rate the user wanted
+	 * Try to enforce the rateidx mask the user wanted. skip this if the
+	 * default mask (allow all rates) is used to save some processing for
+	 * the common case.
 	 */
-	if (sdata->max_ratectrl_rateidx > -1)
+	mask = sdata->rc_rateidx_mask[info->band];
+	if (mask != (1 << txrc->sband->n_bitrates) - 1) {
+		if (sta) {
+			/* Filter out rates that the STA does not support */
+			mask &= sta->sta.supp_rates[info->band];
+		}
+		/*
+		 * Make sure the rate index selected for each TX rate is
+		 * included in the configured mask and change the rate indexes
+		 * if needed.
+		 */
 		for (i = 0; i < IEEE80211_TX_MAX_RATES; i++) {
+			/* Rate masking supports only legacy rates for now */
 			if (info->control.rates[i].flags & IEEE80211_TX_RC_MCS)
 				continue;
-			info->control.rates[i].idx =
-				min_t(s8, info->control.rates[i].idx,
-				      sdata->max_ratectrl_rateidx);
+			rate_idx_match_mask(&info->control.rates[i],
+					    txrc->sband->n_bitrates, mask);
+		}
 	}
 
 	BUG_ON(info->control.rates[0].idx < 0);
--- uml.orig/net/mac80211/tx.c	2010-01-06 12:11:08.000000000 +0200
+++ uml/net/mac80211/tx.c	2010-01-06 12:11:11.000000000 +0200
@@ -519,7 +519,11 @@ ieee80211_tx_h_rate_ctrl(struct ieee8021
 	txrc.bss_conf = &tx->sdata->vif.bss_conf;
 	txrc.skb = tx->skb;
 	txrc.reported_rate.idx = -1;
-	txrc.max_rate_idx = tx->sdata->max_ratectrl_rateidx;
+	txrc.rate_idx_mask = tx->sdata->rc_rateidx_mask[tx->channel->band];
+	if (txrc.rate_idx_mask == (1 << sband->n_bitrates) - 1)
+		txrc.max_rate_idx = -1;
+	else
+		txrc.max_rate_idx = fls(txrc.rate_idx_mask) - 1;
 	txrc.ap = tx->sdata->vif.type == NL80211_IFTYPE_AP;
 
 	/* set up RTS protection if desired */
@@ -2178,7 +2182,11 @@ struct sk_buff *ieee80211_beacon_get_tim
 	txrc.bss_conf = &sdata->vif.bss_conf;
 	txrc.skb = skb;
 	txrc.reported_rate.idx = -1;
-	txrc.max_rate_idx = sdata->max_ratectrl_rateidx;
+	txrc.rate_idx_mask = sdata->rc_rateidx_mask[band];
+	if (txrc.rate_idx_mask == (1 << sband->n_bitrates) - 1)
+		txrc.max_rate_idx = -1;
+	else
+		txrc.max_rate_idx = fls(txrc.rate_idx_mask) - 1;
 	txrc.ap = true;
 	rate_control_get_rate(sdata, NULL, &txrc);
 
--- uml.orig/net/wireless/wext-compat.c	2010-01-06 12:09:53.000000000 +0200
+++ uml/net/wireless/wext-compat.c	2010-01-06 12:11:11.000000000 +0200
@@ -1204,21 +1204,47 @@ int cfg80211_wext_siwrate(struct net_dev
 	struct wireless_dev *wdev = dev->ieee80211_ptr;
 	struct cfg80211_registered_device *rdev = wiphy_to_dev(wdev->wiphy);
 	struct cfg80211_bitrate_mask mask;
+	u32 fixed, maxrate;
+	struct ieee80211_supported_band *sband;
+	int band, ridx;
+	bool match = false;
 
 	if (!rdev->ops->set_bitrate_mask)
 		return -EOPNOTSUPP;
 
-	mask.fixed = 0;
-	mask.maxrate = 0;
+	memset(&mask, 0, sizeof(mask));
+	fixed = 0;
+	maxrate = 0;
 
 	if (rate->value < 0) {
 		/* nothing */
 	} else if (rate->fixed) {
-		mask.fixed = rate->value / 1000; /* kbps */
+		fixed = rate->value / 100000;
 	} else {
-		mask.maxrate = rate->value / 1000; /* kbps */
+		maxrate = rate->value / 100000;
 	}
 
+	for (band = 0; band < IEEE80211_NUM_BANDS; band++) {
+		sband = wdev->wiphy->bands[band];
+		if (sband == NULL)
+			continue;
+		for (ridx = 0; ridx < sband->n_bitrates; ridx++) {
+			struct ieee80211_rate *srate = &sband->bitrates[ridx];
+			if (fixed == srate->bitrate) {
+				mask.control[band].legacy = 1 << ridx;
+				match = true;
+				break;
+			}
+			if (srate->bitrate <= maxrate) {
+				mask.control[band].legacy |= 1 << ridx;
+				match = true;
+			}
+		}
+	}
+
+	if (!match)
+		return -EINVAL;
+
 	return rdev->ops->set_bitrate_mask(wdev->wiphy, dev, NULL, &mask);
 }
 EXPORT_SYMBOL_GPL(cfg80211_wext_siwrate);
--- uml.orig/net/mac80211/rate.h	2010-01-06 12:09:53.000000000 +0200
+++ uml/net/mac80211/rate.h	2010-01-06 12:11:11.000000000 +0200
@@ -44,10 +44,7 @@ static inline void rate_control_tx_statu
 	struct rate_control_ref *ref = local->rate_ctrl;
 	struct ieee80211_sta *ista = &sta->sta;
 	void *priv_sta = sta->rate_ctrl_priv;
-	struct ieee80211_tx_info *info = IEEE80211_SKB_CB(skb);
-
-	if (likely(info->flags & IEEE80211_TX_INTFL_RCALGO))
-		ref->ops->tx_status(ref->priv, sband, ista, priv_sta, skb);
+	ref->ops->tx_status(ref->priv, sband, ista, priv_sta, skb);
 }
 
 
--- uml.orig/net/mac80211/cfg.c	2010-01-06 12:09:53.000000000 +0200
+++ uml/net/mac80211/cfg.c	2010-01-06 12:11:11.000000000 +0200
@@ -1399,8 +1399,6 @@ static int ieee80211_set_bitrate_mask(st
 	struct ieee80211_sub_if_data *sdata = IEEE80211_DEV_TO_SUB_IF(dev);
 	struct ieee80211_local *local = wdev_priv(dev->ieee80211_ptr);
 	int i;
-	u32 target_rate;
-	struct ieee80211_supported_band *sband;
 
 	/*
 	 * This _could_ be supported by providing a hook for
@@ -1410,35 +1408,11 @@ static int ieee80211_set_bitrate_mask(st
 	if (local->hw.flags & IEEE80211_HW_HAS_RATE_CONTROL)
 		return -EOPNOTSUPP;
 
-	sband = local->hw.wiphy->bands[local->hw.conf.channel->band];
 
-	/*
-	 * target_rate = -1, rate->fixed = 0 means auto only, so use all rates
-	 * target_rate = X, rate->fixed = 1 means only rate X
-	 * target_rate = X, rate->fixed = 0 means all rates <= X
-	 */
-	sdata->max_ratectrl_rateidx = -1;
-	sdata->force_unicast_rateidx = -1;
-
-	if (mask->fixed)
-		target_rate = mask->fixed / 100;
-	else if (mask->maxrate)
-		target_rate = mask->maxrate / 100;
-	else
-		return 0;
-
-	for (i = 0; i< sband->n_bitrates; i++) {
-		if (target_rate != sband->bitrates[i].bitrate)
-			continue;
-
-		/* requested bitrate found */
-		sdata->max_ratectrl_rateidx = i;
-		if (mask->fixed)
-			sdata->force_unicast_rateidx = i;
-		return 0;
-	}
+	for (i = 0; i < IEEE80211_NUM_BANDS; i++)
+		sdata->rc_rateidx_mask[i] = mask->control[i].legacy;
 
-	return -EINVAL;
+	return 0;
 }
 
 static int ieee80211_remain_on_channel(struct wiphy *wiphy,


-- 
Jouni Malinen                                            PGP id EFC895FA
