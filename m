Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from nbd.name ([46.4.11.11]:58595 "EHLO nbd.name"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753887Ab3DPLi7 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 16 Apr 2013 07:38:59 -0400
From: Felix Fietkau <nbd@openwrt.org>
To: linux-wireless@vger.kernel.org
Cc: johannes@sipsolutions.net, karl.beldan@gmail.com
Subject: [PATCH v2 3/5] mac80211: improve the rate control API
Date: Tue, 16 Apr 2013 13:38:44 +0200
Message-Id: <1366112326-92981-3-git-send-email-nbd@openwrt.org> (sfid-20130416_133913_699293_12C6BA43)
In-Reply-To: <1366112326-92981-1-git-send-email-nbd@openwrt.org>
References: <1366112326-92981-1-git-send-email-nbd@openwrt.org>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Allow rate control modules to pass a rate selection table to mac80211
and the driver. This allows drivers to fetch the most recent rate
selection from the sta pointer for already buffered frames. This allows
rate control to respond faster to sudden link changes and it is also a
step towards adding minstrel_ht support to drivers like iwlwifi.

When a driver sets IEEE80211_HW_SUPPORTS_RC_TABLE, mac80211 will not
fill info->control.rates with rates from the rate table (to preserve
explicit overrides by the rate control module). The driver then
explicitly calls ieee80211_get_tx_rates to merge overrides from
info->control.rates with defaults from the sta rate table.

Signed-off-by: Felix Fietkau <nbd@openwrt.org>
---
 include/net/mac80211.h     |  65 ++++++++++
 net/mac80211/ieee80211_i.h |   1 +
 net/mac80211/rate.c        | 317 ++++++++++++++++++++++++++++++++++++---------
 net/mac80211/tx.c          | 137 +++++---------------
 4 files changed, 358 insertions(+), 162 deletions(-)

diff --git a/include/net/mac80211.h b/include/net/mac80211.h
index 3cef0dd..2f6e2a6 100644
--- a/include/net/mac80211.h
+++ b/include/net/mac80211.h
@@ -561,6 +561,9 @@ enum mac80211_rate_control_flags {
 /* maximum number of rate stages */
 #define IEEE80211_TX_MAX_RATES	4
 
+/* maximum number of rate table entries */
+#define IEEE80211_TX_RATE_TABLE_SIZE	4
+
 /**
  * struct ieee80211_tx_rate - rate selection/status
  *
@@ -657,6 +660,7 @@ struct ieee80211_tx_info {
 					s8 rts_cts_rate_idx;
 					u8 use_rts:1;
 					u8 use_cts_prot:1;
+					u8 short_preamble:1;
 					/* 2 bytes free */
 				};
 				/* only needed before rate control */
@@ -678,6 +682,8 @@ struct ieee80211_tx_info {
 		struct {
 			struct ieee80211_tx_rate driver_rates[
 				IEEE80211_TX_MAX_RATES];
+			u8 pad[4];
+
 			void *rate_driver_data[
 				IEEE80211_TX_INFO_RATE_DRIVER_DATA_SIZE / sizeof(void *)];
 		};
@@ -1223,6 +1229,24 @@ enum ieee80211_sta_rx_bandwidth {
 };
 
 /**
+ * struct ieee80211_sta_rates - station rate selection table
+ *
+ * @rcu_head: RCU head used for freeing the table on update
+ * @rates: transmit rates/flags to be used by default.
+ *	Overriding entries per-packet is possible by using cb tx control.
+ */
+struct ieee80211_sta_rates {
+	struct rcu_head rcu_head;
+	struct {
+		u8 idx;
+		u8 count;
+		u8 count_cts;
+		u8 count_rts;
+		u16 flags;
+	} rate[IEEE80211_TX_RATE_TABLE_SIZE];
+};
+
+/**
  * struct ieee80211_sta - station table entry
  *
  * A station table entry represents a station we are possibly
@@ -1249,6 +1273,7 @@ enum ieee80211_sta_rx_bandwidth {
  *	notifications and capabilities. The value is only valid after
  *	the station moves to associated state.
  * @smps_mode: current SMPS mode (off, static or dynamic)
+ * @tx_rates: rate control selection table
  */
 struct ieee80211_sta {
 	u32 supp_rates[IEEE80211_NUM_BANDS];
@@ -1262,6 +1287,7 @@ struct ieee80211_sta {
 	u8 rx_nss;
 	enum ieee80211_sta_rx_bandwidth bandwidth;
 	enum ieee80211_smps_mode smps_mode;
+	struct ieee80211_sta_rates __rcu *rates;
 
 	/* must be last */
 	u8 drv_priv[0] __aligned(sizeof(void *));
@@ -1417,6 +1443,9 @@ struct ieee80211_tx_control {
  *	for different virtual interfaces. See the doc section on HW queue
  *	control for more details.
  *
+ * @IEEE80211_HW_SUPPORTS_RC_TABLE: The driver supports using a rate
+ *	selection table provided by the rate control algorithm.
+ *
  * @IEEE80211_HW_P2P_DEV_ADDR_FOR_INTF: Use the P2P Device address for any
  *	P2P Interface. This will be honoured even if more than one interface
  *	is supported.
@@ -1449,6 +1478,7 @@ enum ieee80211_hw_flags {
 	IEEE80211_HW_SUPPORTS_PER_STA_GTK		= 1<<21,
 	IEEE80211_HW_AP_LINK_PS				= 1<<22,
 	IEEE80211_HW_TX_AMPDU_SETUP_IN_HW		= 1<<23,
+	IEEE80211_HW_SUPPORTS_RC_TABLE			= 1<<24,
 	IEEE80211_HW_P2P_DEV_ADDR_FOR_INTF		= 1<<25,
 	IEEE80211_HW_TIMING_BEACON_ONLY			= 1<<26,
 };
@@ -3135,6 +3165,25 @@ void ieee80211_sta_set_buffered(struct ieee80211_sta *sta,
 				u8 tid, bool buffered);
 
 /**
+ * ieee80211_get_tx_rates - get the selected transmit rates for a packet
+ *
+ * Call this function in a driver with per-packet rate selection support
+ * to combine the rate info in the packet tx info with the most recent
+ * rate selection table for the station entry.
+ *
+ * @vif: &struct ieee80211_vif pointer from the add_interface callback.
+ * @sta: the receiver station to which this packet is sent.
+ * @skb: the frame to be transmitted.
+ * @dest: buffer for extracted rate/retry information
+ * @max_rates: maximum number of rates to fetch
+ */
+void ieee80211_get_tx_rates(struct ieee80211_vif *vif,
+			    struct ieee80211_sta *sta,
+			    struct sk_buff *skb,
+			    struct ieee80211_tx_rate *dest,
+			    int max_rates);
+
+/**
  * ieee80211_tx_status - transmit status callback
  *
  * Call this function for all transmitted frames after they have been
@@ -4210,6 +4259,22 @@ bool rate_usable_index_exists(struct ieee80211_supported_band *sband,
 	return false;
 }
 
+/**
+ * rate_control_set_rates - pass the sta rate selection to mac80211/driver
+ *
+ * When not doing a rate control probe to test rates, rate control should pass
+ * its rate selection to mac80211. If the driver supports receiving a station
+ * rate table, it will use it to ensure that frames are always sent based on
+ * the most recent rate control module decision.
+ *
+ * @hw: pointer as obtained from ieee80211_alloc_hw()
+ * @pubsta: &struct ieee80211_sta pointer to the target destination.
+ * @rates: new tx rate set to be used for this station.
+ */
+int rate_control_set_rates(struct ieee80211_hw *hw,
+			   struct ieee80211_sta *pubsta,
+			   struct ieee80211_sta_rates *rates);
+
 int ieee80211_rate_control_register(struct rate_control_ops *ops);
 void ieee80211_rate_control_unregister(struct rate_control_ops *ops);
 
diff --git a/net/mac80211/ieee80211_i.h b/net/mac80211/ieee80211_i.h
index 4f4a40e..8f99b1a 100644
--- a/net/mac80211/ieee80211_i.h
+++ b/net/mac80211/ieee80211_i.h
@@ -156,6 +156,7 @@ struct ieee80211_tx_data {
 	struct ieee80211_sub_if_data *sdata;
 	struct sta_info *sta;
 	struct ieee80211_key *key;
+	struct ieee80211_tx_rate rate;
 
 	unsigned int flags;
 };
diff --git a/net/mac80211/rate.c b/net/mac80211/rate.c
index 5d545dd..9c90167 100644
--- a/net/mac80211/rate.c
+++ b/net/mac80211/rate.c
@@ -252,6 +252,23 @@ rate_lowest_non_cck_index(struct ieee80211_supported_band *sband,
 	return 0;
 }
 
+static void __rate_control_send_low(struct ieee80211_hw *hw,
+				    struct ieee80211_supported_band *sband,
+				    struct ieee80211_sta *sta,
+				    struct ieee80211_tx_info *info)
+{
+	if ((sband->band != IEEE80211_BAND_2GHZ) ||
+	    !(info->flags & IEEE80211_TX_CTL_NO_CCK_RATE))
+		info->control.rates[0].idx = rate_lowest_index(sband, sta);
+	else
+		info->control.rates[0].idx =
+			rate_lowest_non_cck_index(sband, sta);
+
+	info->control.rates[0].count =
+		(info->flags & IEEE80211_TX_CTL_NO_ACK) ?
+		1 : hw->max_rate_tries;
+}
+
 
 bool rate_control_send_low(struct ieee80211_sta *sta,
 			   void *priv_sta,
@@ -262,16 +279,8 @@ bool rate_control_send_low(struct ieee80211_sta *sta,
 	int mcast_rate;
 
 	if (!sta || !priv_sta || rc_no_data_or_no_ack_use_min(txrc)) {
-		if ((sband->band != IEEE80211_BAND_2GHZ) ||
-		    !(info->flags & IEEE80211_TX_CTL_NO_CCK_RATE))
-			info->control.rates[0].idx =
-				rate_lowest_index(txrc->sband, sta);
-		else
-			info->control.rates[0].idx =
-				rate_lowest_non_cck_index(txrc->sband, sta);
-		info->control.rates[0].count =
-			(info->flags & IEEE80211_TX_CTL_NO_ACK) ?
-			1 : txrc->hw->max_rate_tries;
+		__rate_control_send_low(txrc->hw, sband, sta, info);
+
 		if (!sta && txrc->bss) {
 			mcast_rate = txrc->bss_conf->mcast_rate[sband->band];
 			if (mcast_rate > 0) {
@@ -355,7 +364,8 @@ static bool rate_idx_match_mcs_mask(struct ieee80211_tx_rate *rate,
 
 
 static void rate_idx_match_mask(struct ieee80211_tx_rate *rate,
-				struct ieee80211_tx_rate_control *txrc,
+				struct ieee80211_supported_band *sband,
+				enum nl80211_chan_width chan_width,
 				u32 mask,
 				u8 mcs_mask[IEEE80211_HT_MCS_MASK_LEN])
 {
@@ -375,27 +385,17 @@ static void rate_idx_match_mask(struct ieee80211_tx_rate *rate,
 				  IEEE80211_TX_RC_USE_SHORT_PREAMBLE);
 		alt_rate.count = rate->count;
 		if (rate_idx_match_legacy_mask(&alt_rate,
-					       txrc->sband->n_bitrates,
-					       mask)) {
+					       sband->n_bitrates, mask)) {
 			*rate = alt_rate;
 			return;
 		}
 	} else {
-		struct sk_buff *skb = txrc->skb;
-		struct ieee80211_hdr *hdr = (struct ieee80211_hdr *) skb->data;
-		__le16 fc;
-
 		/* handle legacy rates */
-		if (rate_idx_match_legacy_mask(rate, txrc->sband->n_bitrates,
-					       mask))
+		if (rate_idx_match_legacy_mask(rate, sband->n_bitrates, mask))
 			return;
 
 		/* if HT BSS, and we handle a data frame, also try HT rates */
-		if (txrc->bss_conf->chandef.width == NL80211_CHAN_WIDTH_20_NOHT)
-			return;
-
-		fc = hdr->frame_control;
-		if (!ieee80211_is_data(fc))
+		if (chan_width == NL80211_CHAN_WIDTH_20_NOHT)
 			return;
 
 		alt_rate.idx = 0;
@@ -408,7 +408,7 @@ static void rate_idx_match_mask(struct ieee80211_tx_rate *rate,
 
 		alt_rate.flags |= IEEE80211_TX_RC_MCS;
 
-		if (txrc->bss_conf->chandef.width == NL80211_CHAN_WIDTH_40)
+		if (chan_width == NL80211_CHAN_WIDTH_40)
 			alt_rate.flags |= IEEE80211_TX_RC_40_MHZ_WIDTH;
 
 		if (rate_idx_match_mcs_mask(&alt_rate, mcs_mask)) {
@@ -426,6 +426,220 @@ static void rate_idx_match_mask(struct ieee80211_tx_rate *rate,
 	 */
 }
 
+static void rate_fixup_ratelist(struct ieee80211_vif *vif,
+				struct ieee80211_supported_band *sband,
+				struct ieee80211_tx_info *info,
+				struct ieee80211_tx_rate *rates,
+				int max_rates)
+{
+	struct ieee80211_rate *rate;
+	bool inval = false;
+	int i;
+
+	/*
+	 * set up the RTS/CTS rate as the fastest basic rate
+	 * that is not faster than the data rate
+	 *
+	 * XXX: Should this check all retry rates?
+	 */
+	if (!(rates[0].flags & IEEE80211_TX_RC_MCS)) {
+		s8 baserate = 0;
+
+		rate = &sband->bitrates[rates[0].idx];
+
+		for (i = 0; i < sband->n_bitrates; i++) {
+			/* must be a basic rate */
+			if (!(vif->bss_conf.basic_rates & BIT(i)))
+				continue;
+			/* must not be faster than the data rate */
+			if (sband->bitrates[i].bitrate > rate->bitrate)
+				continue;
+			/* maximum */
+			if (sband->bitrates[baserate].bitrate <
+			     sband->bitrates[i].bitrate)
+				baserate = i;
+		}
+
+		info->control.rts_cts_rate_idx = baserate;
+	}
+
+	for (i = 0; i < max_rates; i++) {
+		/*
+		 * make sure there's no valid rate following
+		 * an invalid one, just in case drivers don't
+		 * take the API seriously to stop at -1.
+		 */
+		if (inval) {
+			rates[i].idx = -1;
+			continue;
+		}
+		if (rates[i].idx < 0) {
+			inval = true;
+			continue;
+		}
+
+		/*
+		 * For now assume MCS is already set up correctly, this
+		 * needs to be fixed.
+		 */
+		if (rates[i].flags & IEEE80211_TX_RC_MCS) {
+			WARN_ON(rates[i].idx > 76);
+
+			if (!(rates[i].flags & IEEE80211_TX_RC_USE_RTS_CTS) &&
+			    info->control.use_cts_prot)
+				rates[i].flags |=
+					IEEE80211_TX_RC_USE_CTS_PROTECT;
+			continue;
+		}
+
+		/* set up RTS protection if desired */
+		if (info->control.use_rts) {
+			rates[i].flags |= IEEE80211_TX_RC_USE_RTS_CTS;
+			info->control.use_cts_prot = false;
+		}
+
+		/* RC is busted */
+		if (WARN_ON_ONCE(rates[i].idx >= sband->n_bitrates)) {
+			rates[i].idx = -1;
+			continue;
+		}
+
+		rate = &sband->bitrates[rates[i].idx];
+
+		/* set up short preamble */
+		if (info->control.short_preamble &&
+		    rate->flags & IEEE80211_RATE_SHORT_PREAMBLE)
+			rates[i].flags |= IEEE80211_TX_RC_USE_SHORT_PREAMBLE;
+
+		/* set up G protection */
+		if (!(rates[i].flags & IEEE80211_TX_RC_USE_RTS_CTS) &&
+		    info->control.use_cts_prot &&
+		    rate->flags & IEEE80211_RATE_ERP_G)
+			rates[i].flags |= IEEE80211_TX_RC_USE_CTS_PROTECT;
+	}
+}
+
+
+static void rate_control_fill_sta_table(struct ieee80211_sta *sta,
+					struct ieee80211_tx_info *info,
+					struct ieee80211_tx_rate *rates,
+					int max_rates)
+{
+	struct ieee80211_sta_rates *ratetbl = NULL;
+	int i;
+
+	if (sta)
+		ratetbl = rcu_dereference(sta->rates);
+
+	/* Fill remaining rate slots with data from the sta rate table. */
+	max_rates = min_t(int, max_rates, IEEE80211_TX_RATE_TABLE_SIZE);
+	for (i = 0; i < max_rates; i++) {
+		if (i < ARRAY_SIZE(info->control.rates) &&
+		    info->control.rates[i].idx >= 0 &&
+		    info->control.rates[i].count) {
+			if (rates != info->control.rates)
+				rates[i] = info->control.rates[i];
+		} else if (ratetbl) {
+			rates[i].idx = ratetbl->rate[i].idx;
+			rates[i].flags = ratetbl->rate[i].flags;
+			if (info->control.use_rts)
+				rates[i].count = ratetbl->rate[i].count_rts;
+			else if (info->control.use_cts_prot)
+				rates[i].count = ratetbl->rate[i].count_cts;
+			else
+				rates[i].count = ratetbl->rate[i].count;
+		} else {
+			rates[i].idx = -1;
+			rates[i].count = 0;
+		}
+
+		if (rates[i].idx < 0 || !rates[i].count)
+			break;
+	}
+}
+
+static void rate_control_apply_mask(struct ieee80211_sub_if_data *sdata,
+				    struct ieee80211_sta *sta,
+				    struct ieee80211_supported_band *sband,
+				    struct ieee80211_tx_info *info,
+				    struct ieee80211_tx_rate *rates,
+				    int max_rates)
+{
+	enum nl80211_chan_width chan_width;
+	u8 mcs_mask[IEEE80211_HT_MCS_MASK_LEN];
+	bool has_mcs_mask;
+	u32 mask;
+	int i;
+
+	/*
+	 * Try to enforce the rateidx mask the user wanted. skip this if the
+	 * default mask (allow all rates) is used to save some processing for
+	 * the common case.
+	 */
+	mask = sdata->rc_rateidx_mask[info->band];
+	has_mcs_mask = sdata->rc_has_mcs_mask[info->band];
+	if (mask == (1 << sband->n_bitrates) - 1 && !has_mcs_mask)
+		return;
+
+	if (has_mcs_mask)
+		memcpy(mcs_mask, sdata->rc_rateidx_mcs_mask[info->band],
+		       sizeof(mcs_mask));
+	else
+		memset(mcs_mask, 0xff, sizeof(mcs_mask));
+
+	if (sta) {
+		/* Filter out rates that the STA does not support */
+		mask &= sta->supp_rates[info->band];
+		for (i = 0; i < sizeof(mcs_mask); i++)
+			mcs_mask[i] &= sta->ht_cap.mcs.rx_mask[i];
+	}
+
+	/*
+	 * Make sure the rate index selected for each TX rate is
+	 * included in the configured mask and change the rate indexes
+	 * if needed.
+	 */
+	chan_width = sdata->vif.bss_conf.chandef.width;
+	for (i = 0; i < max_rates; i++) {
+		/* Skip invalid rates */
+		if (rates[i].idx < 0)
+			break;
+
+		rate_idx_match_mask(&rates[i], sband, mask, chan_width,
+				    mcs_mask);
+	}
+}
+
+void ieee80211_get_tx_rates(struct ieee80211_vif *vif,
+			    struct ieee80211_sta *sta,
+			    struct sk_buff *skb,
+			    struct ieee80211_tx_rate *dest,
+			    int max_rates)
+{
+	struct ieee80211_sub_if_data *sdata;
+	struct ieee80211_hdr *hdr = (struct ieee80211_hdr *) skb->data;
+	struct ieee80211_tx_info *info = IEEE80211_SKB_CB(skb);
+	struct ieee80211_supported_band *sband;
+
+	rate_control_fill_sta_table(sta, info, dest, max_rates);
+
+	if (!vif)
+		return;
+
+	sdata = vif_to_sdata(vif);
+	sband = sdata->local->hw.wiphy->bands[info->band];
+
+	if (ieee80211_is_data(hdr->frame_control))
+		rate_control_apply_mask(sdata, sta, sband, info, dest, max_rates);
+
+	if (dest[0].idx < 0)
+		__rate_control_send_low(&sdata->local->hw, sband, sta, info);
+
+	if (sta)
+		rate_fixup_ratelist(vif, sband, info, dest, max_rates);
+}
+EXPORT_SYMBOL(ieee80211_get_tx_rates);
+
 void rate_control_get_rate(struct ieee80211_sub_if_data *sdata,
 			   struct sta_info *sta,
 			   struct ieee80211_tx_rate_control *txrc)
@@ -435,8 +649,6 @@ void rate_control_get_rate(struct ieee80211_sub_if_data *sdata,
 	struct ieee80211_sta *ista = NULL;
 	struct ieee80211_tx_info *info = IEEE80211_SKB_CB(txrc->skb);
 	int i;
-	u32 mask;
-	u8 mcs_mask[IEEE80211_HT_MCS_MASK_LEN];
 
 	if (sta && test_sta_flag(sta, WLAN_STA_RATE_CONTROL)) {
 		ista = &sta->sta;
@@ -454,40 +666,27 @@ void rate_control_get_rate(struct ieee80211_sub_if_data *sdata,
 
 	ref->ops->get_rate(ref->priv, ista, priv_sta, txrc);
 
-	/*
-	 * Try to enforce the rateidx mask the user wanted. skip this if the
-	 * default mask (allow all rates) is used to save some processing for
-	 * the common case.
-	 */
-	mask = sdata->rc_rateidx_mask[info->band];
-	if (mask != (1 << txrc->sband->n_bitrates) - 1 || txrc->rate_idx_mcs_mask) {
-		if (txrc->rate_idx_mcs_mask)
-			memcpy(mcs_mask, txrc->rate_idx_mcs_mask, sizeof(mcs_mask));
-		else
-			memset(mcs_mask, 0xff, sizeof(mcs_mask));
-
-		if (sta) {
-			/* Filter out rates that the STA does not support */
-			mask &= sta->sta.supp_rates[info->band];
-			for (i = 0; i < sizeof(mcs_mask); i++)
-				mcs_mask[i] &= sta->sta.ht_cap.mcs.rx_mask[i];
-		}
-		/*
-		 * Make sure the rate index selected for each TX rate is
-		 * included in the configured mask and change the rate indexes
-		 * if needed.
-		 */
-		for (i = 0; i < IEEE80211_TX_MAX_RATES; i++) {
-			/* Skip invalid rates */
-			if (info->control.rates[i].idx < 0)
-				break;
-			rate_idx_match_mask(&info->control.rates[i], txrc,
-					    mask, mcs_mask);
-		}
-	}
+	if (sdata->local->hw.flags & IEEE80211_HW_SUPPORTS_RC_TABLE)
+		return;
 
-	BUG_ON(info->control.rates[0].idx < 0);
+	ieee80211_get_tx_rates(&sdata->vif, ista, txrc->skb,
+			       info->control.rates,
+			       ARRAY_SIZE(info->control.rates));
+}
+
+int rate_control_set_rates(struct ieee80211_hw *hw,
+			   struct ieee80211_sta *pubsta,
+			   struct ieee80211_sta_rates *rates)
+{
+	struct ieee80211_sta_rates *old = rcu_dereference(pubsta->rates);
+
+	rcu_assign_pointer(pubsta->rates, rates);
+	if (old)
+		kfree_rcu(old, rcu_head);
+
+	return 0;
 }
+EXPORT_SYMBOL(rate_control_set_rates);
 
 int ieee80211_init_rate_ctrl_alg(struct ieee80211_local *local,
 				 const char *name)
diff --git a/net/mac80211/tx.c b/net/mac80211/tx.c
index ba2aa23..592aea8 100644
--- a/net/mac80211/tx.c
+++ b/net/mac80211/tx.c
@@ -48,15 +48,15 @@ static __le16 ieee80211_duration(struct ieee80211_tx_data *tx,
 	struct ieee80211_tx_info *info = IEEE80211_SKB_CB(skb);
 
 	/* assume HW handles this */
-	if (info->control.rates[0].flags & IEEE80211_TX_RC_MCS)
+	if (tx->rate.flags & IEEE80211_TX_RC_MCS)
 		return 0;
 
 	/* uh huh? */
-	if (WARN_ON_ONCE(info->control.rates[0].idx < 0))
+	if (WARN_ON_ONCE(tx->rate.idx < 0))
 		return 0;
 
 	sband = local->hw.wiphy->bands[info->band];
-	txrate = &sband->bitrates[info->control.rates[0].idx];
+	txrate = &sband->bitrates[tx->rate.idx];
 
 	erp = txrate->flags & IEEE80211_RATE_ERP_G;
 
@@ -617,11 +617,9 @@ ieee80211_tx_h_rate_ctrl(struct ieee80211_tx_data *tx)
 	struct ieee80211_tx_info *info = IEEE80211_SKB_CB(tx->skb);
 	struct ieee80211_hdr *hdr = (void *)tx->skb->data;
 	struct ieee80211_supported_band *sband;
-	struct ieee80211_rate *rate;
-	int i;
 	u32 len;
-	bool inval = false, rts = false, short_preamble = false;
 	struct ieee80211_tx_rate_control txrc;
+	struct ieee80211_sta_rates *ratetbl = NULL;
 	bool assoc = false;
 
 	memset(&txrc, 0, sizeof(txrc));
@@ -653,10 +651,10 @@ ieee80211_tx_h_rate_ctrl(struct ieee80211_tx_data *tx)
 
 	/* set up RTS protection if desired */
 	if (len > tx->local->hw.wiphy->rts_threshold) {
-		txrc.rts = rts = true;
+		txrc.rts = true;
 	}
 
-	info->control.use_rts = rts;
+	info->control.use_rts = txrc.rts;
 	info->control.use_cts_prot = tx->sdata->vif.bss_conf.use_cts_prot;
 
 	/*
@@ -668,7 +666,9 @@ ieee80211_tx_h_rate_ctrl(struct ieee80211_tx_data *tx)
 	if (tx->sdata->vif.bss_conf.use_short_preamble &&
 	    (ieee80211_is_data(hdr->frame_control) ||
 	     (tx->sta && test_sta_flag(tx->sta, WLAN_STA_SHORT_PREAMBLE))))
-		txrc.short_preamble = short_preamble = true;
+		txrc.short_preamble = true;
+
+	info->control.short_preamble = txrc.short_preamble;
 
 	if (tx->sta)
 		assoc = test_sta_flag(tx->sta, WLAN_STA_ASSOC);
@@ -692,16 +692,38 @@ ieee80211_tx_h_rate_ctrl(struct ieee80211_tx_data *tx)
 	 */
 	rate_control_get_rate(tx->sdata, tx->sta, &txrc);
 
-	if (unlikely(info->control.rates[0].idx < 0))
-		return TX_DROP;
+	if (tx->sta)
+		ratetbl = rcu_dereference(tx->sta->sta.rates);
+
+	if (unlikely(info->control.rates[0].idx < 0)) {
+		if (ratetbl) {
+			struct ieee80211_tx_rate rate = {
+				.idx = ratetbl->rate[0].idx,
+				.flags = ratetbl->rate[0].flags,
+				.count = ratetbl->rate[0].count
+			};
+
+			if (ratetbl->rate[0].idx < 0)
+				return TX_DROP;
+
+			tx->rate = rate;
+		} else {
+			return TX_DROP;
+		}
+	} else {
+		tx->rate = info->control.rates[0];
+	}
 
 	if (txrc.reported_rate.idx < 0) {
-		txrc.reported_rate = info->control.rates[0];
+		txrc.reported_rate = tx->rate;
 		if (tx->sta && ieee80211_is_data(hdr->frame_control))
 			tx->sta->last_tx_rate = txrc.reported_rate;
 	} else if (tx->sta)
 		tx->sta->last_tx_rate = txrc.reported_rate;
 
+	if (ratetbl)
+		return TX_CONTINUE;
+
 	if (unlikely(!info->control.rates[0].count))
 		info->control.rates[0].count = 1;
 
@@ -709,97 +731,6 @@ ieee80211_tx_h_rate_ctrl(struct ieee80211_tx_data *tx)
 			 (info->flags & IEEE80211_TX_CTL_NO_ACK)))
 		info->control.rates[0].count = 1;
 
-	if (is_multicast_ether_addr(hdr->addr1)) {
-		/*
-		 * XXX: verify the rate is in the basic rateset
-		 */
-		return TX_CONTINUE;
-	}
-
-	/*
-	 * set up the RTS/CTS rate as the fastest basic rate
-	 * that is not faster than the data rate
-	 *
-	 * XXX: Should this check all retry rates?
-	 */
-	if (!(info->control.rates[0].flags & IEEE80211_TX_RC_MCS)) {
-		s8 baserate = 0;
-
-		rate = &sband->bitrates[info->control.rates[0].idx];
-
-		for (i = 0; i < sband->n_bitrates; i++) {
-			/* must be a basic rate */
-			if (!(tx->sdata->vif.bss_conf.basic_rates & BIT(i)))
-				continue;
-			/* must not be faster than the data rate */
-			if (sband->bitrates[i].bitrate > rate->bitrate)
-				continue;
-			/* maximum */
-			if (sband->bitrates[baserate].bitrate <
-			     sband->bitrates[i].bitrate)
-				baserate = i;
-		}
-
-		info->control.rts_cts_rate_idx = baserate;
-	}
-
-	for (i = 0; i < IEEE80211_TX_MAX_RATES; i++) {
-		/*
-		 * make sure there's no valid rate following
-		 * an invalid one, just in case drivers don't
-		 * take the API seriously to stop at -1.
-		 */
-		if (inval) {
-			info->control.rates[i].idx = -1;
-			continue;
-		}
-		if (info->control.rates[i].idx < 0) {
-			inval = true;
-			continue;
-		}
-
-		/*
-		 * For now assume MCS is already set up correctly, this
-		 * needs to be fixed.
-		 */
-		if (info->control.rates[i].flags & IEEE80211_TX_RC_MCS) {
-			WARN_ON(info->control.rates[i].idx > 76);
-
-			if (!(info->control.rates[i].flags &
-			      IEEE80211_TX_RC_USE_RTS_CTS) &&
-			    tx->sdata->vif.bss_conf.use_cts_prot)
-				info->control.rates[i].flags |=
-					IEEE80211_TX_RC_USE_CTS_PROTECT;
-			continue;
-		}
-
-		/* set up RTS protection if desired */
-		if (rts)
-			info->control.rates[i].flags |=
-				IEEE80211_TX_RC_USE_RTS_CTS;
-
-		/* RC is busted */
-		if (WARN_ON_ONCE(info->control.rates[i].idx >=
-				 sband->n_bitrates)) {
-			info->control.rates[i].idx = -1;
-			continue;
-		}
-
-		rate = &sband->bitrates[info->control.rates[i].idx];
-
-		/* set up short preamble */
-		if (short_preamble &&
-		    rate->flags & IEEE80211_RATE_SHORT_PREAMBLE)
-			info->control.rates[i].flags |=
-				IEEE80211_TX_RC_USE_SHORT_PREAMBLE;
-
-		/* set up G protection */
-		if (!rts && tx->sdata->vif.bss_conf.use_cts_prot &&
-		    rate->flags & IEEE80211_RATE_ERP_G)
-			info->control.rates[i].flags |=
-				IEEE80211_TX_RC_USE_CTS_PROTECT;
-	}
-
 	return TX_CONTINUE;
 }
 
-- 
1.8.0.2

