Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from investici.nine.ch ([217.150.252.179]:28801 "EHLO
	confino.investici.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751209Ab2GHQJ6 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 8 Jul 2012 12:09:58 -0400
From: Antonio Quartulli <ordex@autistici.org>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: linux-wireless@vger.kernel.org,
	Antonio Quartulli <ordex@autistici.org>
Subject: [PATCH] nl/cfg/mac80211: use BIT(x) instead of (1 << x)
Date: Sun,  8 Jul 2012 18:10:05 +0200
Message-Id: <1341763805-7386-1-git-send-email-ordex@autistici.org> (sfid-20120708_181003_708762_1961FE59)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

The kernel libraries provide the BIT(x) macro than can be used instead of
shifting 1 to the left by x position. This patch substitute all the shifting
operation with this macro.

Signed-off-by: Antonio Quartulli <ordex@autistici.org>
---
 net/mac80211/agg-tx.c              |    2 +-
 net/mac80211/iface.c               |    2 +-
 net/mac80211/main.c                |    6 +++---
 net/mac80211/mesh_hwmp.c           |    8 ++++----
 net/mac80211/mesh_pathtbl.c        |    6 +++---
 net/mac80211/mlme.c                |    2 +-
 net/mac80211/rate.c                |   10 +++++-----
 net/mac80211/rc80211_pid.h         |    2 +-
 net/mac80211/rx.c                  |   16 ++++++++--------
 net/mac80211/sta_info.c            |    4 ++--
 net/mac80211/status.c              |    8 ++++----
 net/mac80211/tkip.c                |    4 ++--
 net/mac80211/tx.c                  |    6 +++---
 net/wireless/core.c                |    2 +-
 net/wireless/lib80211_crypt_ccmp.c |    4 ++--
 net/wireless/lib80211_crypt_tkip.c |    4 ++--
 net/wireless/nl80211.c             |   14 +++++++-------
 net/wireless/radiotap.c            |    4 ++--
 net/wireless/scan.c                |    2 +-
 net/wireless/sme.c                 |    2 +-
 net/wireless/util.c                |    2 +-
 net/wireless/wext-compat.c         |    4 ++--
 22 files changed, 57 insertions(+), 57 deletions(-)

diff --git a/net/mac80211/agg-tx.c b/net/mac80211/agg-tx.c
index 5cc1bf7..a0b0607 100644
--- a/net/mac80211/agg-tx.c
+++ b/net/mac80211/agg-tx.c
@@ -97,7 +97,7 @@ static void ieee80211_send_addba_request(struct ieee80211_sub_if_data *sdata,
 	mgmt->u.action.u.addba_req.action_code = WLAN_ACTION_ADDBA_REQ;
 
 	mgmt->u.action.u.addba_req.dialog_token = dialog_token;
-	capab = (u16)(1 << 1);		/* bit 1 aggregation policy */
+	capab = (u16)BIT(1);		/* bit 1 aggregation policy */
 	capab |= (u16)(tid << 2); 	/* bit 5:2 TID number */
 	capab |= (u16)(agg_size << 6);	/* bit 15:6 max size of aggergation */
 
diff --git a/net/mac80211/iface.c b/net/mac80211/iface.c
index fbef7a1..1920e30 100644
--- a/net/mac80211/iface.c
+++ b/net/mac80211/iface.c
@@ -1432,7 +1432,7 @@ int ieee80211_if_add(struct ieee80211_local *local, const char *name,
 		struct ieee80211_supported_band *sband;
 		sband = local->hw.wiphy->bands[i];
 		sdata->rc_rateidx_mask[i] =
-			sband ? (1 << sband->n_bitrates) - 1 : 0;
+			sband ? BIT(sband->n_bitrates) - 1 : 0;
 		if (sband)
 			memcpy(sdata->rc_rateidx_mcs_mask[i],
 			       sband->ht_cap.mcs.rx_mask,
diff --git a/net/mac80211/main.c b/net/mac80211/main.c
index c794101..e190523 100644
--- a/net/mac80211/main.c
+++ b/net/mac80211/main.c
@@ -76,13 +76,13 @@ void ieee80211_configure_filter(struct ieee80211_local *local)
 	spin_unlock_bh(&local->filter_lock);
 
 	/* be a bit nasty */
-	new_flags |= (1<<31);
+	new_flags |= BIT(31);
 
 	drv_configure_filter(local, changed_flags, &new_flags, mc);
 
-	WARN_ON(new_flags & (1<<31));
+	WARN_ON(new_flags & BIT(31));
 
-	local->filter_flags = new_flags & ~(1<<31);
+	local->filter_flags = new_flags & ~BIT(31);
 }
 
 static void ieee80211_reconfig_filter(struct work_struct *work)
diff --git a/net/mac80211/mesh_hwmp.c b/net/mac80211/mesh_hwmp.c
index fb7b6a1..9798c7a 100644
--- a/net/mac80211/mesh_hwmp.c
+++ b/net/mac80211/mesh_hwmp.c
@@ -47,7 +47,7 @@ static inline u32 u16_field_get(u8 *preq_elem, int offset, bool ae)
 }
 
 /* HWMP IE processing macros */
-#define AE_F			(1<<6)
+#define AE_F			BIT(6)
 #define AE_F_SET(x)		(*x & AE_F)
 #define PREQ_IE_FLAGS(x)	(*(x))
 #define PREQ_IE_HOPCOUNT(x)	(*(x + 1))
@@ -320,9 +320,9 @@ static u32 airtime_link_metric_get(struct ieee80211_local *local,
 {
 	struct rate_info rinfo;
 	/* This should be adjusted for each device */
-	int device_constant = 1 << ARITH_SHIFT;
+	int device_constant = BIT(ARITH_SHIFT);
 	int test_frame_len = TEST_FRAME_LEN << ARITH_SHIFT;
-	int s_unit = 1 << ARITH_SHIFT;
+	int s_unit = BIT(ARITH_SHIFT);
 	int rate, err;
 	u32 tx_time, estimated_retx;
 	u64 result;
@@ -341,7 +341,7 @@ static u32 airtime_link_metric_get(struct ieee80211_local *local,
 	 * 1Mbps. This will be corrected on tx_time computation.
 	 */
 	tx_time = (device_constant + 10 * test_frame_len / rate);
-	estimated_retx = ((1 << (2 * ARITH_SHIFT)) / (s_unit - err));
+	estimated_retx = (BIT(2 * ARITH_SHIFT) / (s_unit - err));
 	result = (tx_time * estimated_retx) >> (2 * ARITH_SHIFT) ;
 	return (u32)result;
 }
diff --git a/net/mac80211/mesh_pathtbl.c b/net/mac80211/mesh_pathtbl.c
index c9ae931..1f55a2e 100644
--- a/net/mac80211/mesh_pathtbl.c
+++ b/net/mac80211/mesh_pathtbl.c
@@ -84,7 +84,7 @@ static struct mesh_table *mesh_table_alloc(int size_order)
 		return NULL;
 
 	newtbl->hash_buckets = kzalloc(sizeof(struct hlist_head) *
-			(1 << size_order), GFP_ATOMIC);
+			BIT(size_order), GFP_ATOMIC);
 
 	if (!newtbl->hash_buckets) {
 		kfree(newtbl);
@@ -92,7 +92,7 @@ static struct mesh_table *mesh_table_alloc(int size_order)
 	}
 
 	newtbl->hashwlock = kmalloc(sizeof(spinlock_t) *
-			(1 << size_order), GFP_ATOMIC);
+			BIT(size_order), GFP_ATOMIC);
 	if (!newtbl->hashwlock) {
 		kfree(newtbl->hash_buckets);
 		kfree(newtbl);
@@ -100,7 +100,7 @@ static struct mesh_table *mesh_table_alloc(int size_order)
 	}
 
 	newtbl->size_order = size_order;
-	newtbl->hash_mask = (1 << size_order) - 1;
+	newtbl->hash_mask = BIT(size_order) - 1;
 	atomic_set(&newtbl->entries,  0);
 	get_random_bytes(&newtbl->hash_rnd,
 			sizeof(newtbl->hash_rnd));
diff --git a/net/mac80211/mlme.c b/net/mac80211/mlme.c
index f49f14f..fecfb32 100644
--- a/net/mac80211/mlme.c
+++ b/net/mac80211/mlme.c
@@ -168,7 +168,7 @@ void ieee80211_sta_reset_conn_monitor(struct ieee80211_sub_if_data *sdata)
 
 static int ecw2cw(int ecw)
 {
-	return (1 << ecw) - 1;
+	return BIT(ecw) - 1;
 }
 
 static u32 ieee80211_config_ht_tx(struct ieee80211_sub_if_data *sdata,
diff --git a/net/mac80211/rate.c b/net/mac80211/rate.c
index 3313c11..b3fc593 100644
--- a/net/mac80211/rate.c
+++ b/net/mac80211/rate.c
@@ -219,11 +219,11 @@ static void rc_send_low_broadcast(s8 *idx, u32 basic_rates,
 		return; /* assume basic rates unknown and accept rate */
 	if (*idx < 0)
 		return;
-	if (basic_rates & (1 << *idx))
+	if (basic_rates & BIT(*idx))
 		return; /* selected rate is a basic rate */
 
 	for (i = *idx + 1; i <= sband->n_bitrates; i++) {
-		if (basic_rates & (1 << i)) {
+		if (basic_rates & BIT(i)) {
 			*idx = i;
 			return;
 		}
@@ -296,7 +296,7 @@ static bool rate_idx_match_legacy_mask(struct ieee80211_tx_rate *rate,
 
 	/* See whether the selected rate or anything below it is allowed. */
 	for (j = rate->idx; j >= 0; j--) {
-		if (mask & (1 << j)) {
+		if (mask & BIT(j)) {
 			/* Okay, found a suitable rate. Use it. */
 			rate->idx = j;
 			return true;
@@ -305,7 +305,7 @@ static bool rate_idx_match_legacy_mask(struct ieee80211_tx_rate *rate,
 
 	/* Try to find a higher rate that would be allowed */
 	for (j = rate->idx + 1; j < n_bitrates; j++) {
-		if (mask & (1 << j)) {
+		if (mask & BIT(j)) {
 			/* Okay, found a suitable rate. Use it. */
 			rate->idx = j;
 			return true;
@@ -463,7 +463,7 @@ void rate_control_get_rate(struct ieee80211_sub_if_data *sdata,
 	mask = sdata->rc_rateidx_mask[info->band];
 	memcpy(mcs_mask, sdata->rc_rateidx_mcs_mask[info->band],
 	       sizeof(mcs_mask));
-	if (mask != (1 << txrc->sband->n_bitrates) - 1) {
+	if (mask != BIT(txrc->sband->n_bitrates) - 1) {
 		if (sta) {
 			/* Filter out rates that the STA does not support */
 			mask &= sta->sta.supp_rates[info->band];
diff --git a/net/mac80211/rc80211_pid.h b/net/mac80211/rc80211_pid.h
index 19111c7..3b64c5d 100644
--- a/net/mac80211/rc80211_pid.h
+++ b/net/mac80211/rc80211_pid.h
@@ -15,7 +15,7 @@
 
 /* Exponential averaging smoothness (used for I part of PID controller) */
 #define RC_PID_SMOOTHING_SHIFT		3
-#define RC_PID_SMOOTHING		(1 << RC_PID_SMOOTHING_SHIFT)
+#define RC_PID_SMOOTHING		BIT(RC_PID_SMOOTHING_SHIFT)
 
 /* Sharpening factor (used for D part of PID controller) */
 #define RC_PID_SHARPENING_FACTOR	0
diff --git a/net/mac80211/rx.c b/net/mac80211/rx.c
index 839cac8..438c33d 100644
--- a/net/mac80211/rx.c
+++ b/net/mac80211/rx.c
@@ -115,10 +115,10 @@ ieee80211_add_rx_radiotap_header(struct ieee80211_local *local,
 
 	/* radiotap header, set always present flags */
 	rthdr->it_present =
-		cpu_to_le32((1 << IEEE80211_RADIOTAP_FLAGS) |
-			    (1 << IEEE80211_RADIOTAP_CHANNEL) |
-			    (1 << IEEE80211_RADIOTAP_ANTENNA) |
-			    (1 << IEEE80211_RADIOTAP_RX_FLAGS));
+		cpu_to_le32(BIT(IEEE80211_RADIOTAP_FLAGS) |
+			    BIT(IEEE80211_RADIOTAP_CHANNEL) |
+			    BIT(IEEE80211_RADIOTAP_ANTENNA) |
+			    BIT(IEEE80211_RADIOTAP_RX_FLAGS));
 	rthdr->it_len = cpu_to_le16(rtap_len);
 
 	pos = (unsigned char *)(rthdr+1);
@@ -129,7 +129,7 @@ ieee80211_add_rx_radiotap_header(struct ieee80211_local *local,
 	if (status->flag & RX_FLAG_MACTIME_MPDU) {
 		put_unaligned_le64(status->mactime, pos);
 		rthdr->it_present |=
-			cpu_to_le32(1 << IEEE80211_RADIOTAP_TSFT);
+			cpu_to_le32(BIT(IEEE80211_RADIOTAP_TSFT));
 		pos += 8;
 	}
 
@@ -152,7 +152,7 @@ ieee80211_add_rx_radiotap_header(struct ieee80211_local *local,
 		 */
 		*pos = 0;
 	} else {
-		rthdr->it_present |= cpu_to_le32(1 << IEEE80211_RADIOTAP_RATE);
+		rthdr->it_present |= cpu_to_le32(BIT(IEEE80211_RADIOTAP_RATE));
 		*pos = rate->bitrate / 5;
 	}
 	pos++;
@@ -181,7 +181,7 @@ ieee80211_add_rx_radiotap_header(struct ieee80211_local *local,
 	    !(status->flag & RX_FLAG_NO_SIGNAL_VAL)) {
 		*pos = status->signal;
 		rthdr->it_present |=
-			cpu_to_le32(1 << IEEE80211_RADIOTAP_DBM_ANTSIGNAL);
+			cpu_to_le32(BIT(IEEE80211_RADIOTAP_DBM_ANTSIGNAL));
 		pos++;
 	}
 
@@ -203,7 +203,7 @@ ieee80211_add_rx_radiotap_header(struct ieee80211_local *local,
 	pos += 2;
 
 	if (status->flag & RX_FLAG_HT) {
-		rthdr->it_present |= cpu_to_le32(1 << IEEE80211_RADIOTAP_MCS);
+		rthdr->it_present |= cpu_to_le32(BIT(IEEE80211_RADIOTAP_MCS));
 		*pos++ = local->hw.radiotap_mcs_details;
 		*pos = 0;
 		if (status->flag & RX_FLAG_SHORT_GI)
diff --git a/net/mac80211/sta_info.c b/net/mac80211/sta_info.c
index 06fa75c..59068b2 100644
--- a/net/mac80211/sta_info.c
+++ b/net/mac80211/sta_info.c
@@ -443,7 +443,7 @@ static inline void __bss_tim_set(struct ieee80211_if_ap *bss, u16 aid)
 	 * This format has been mandated by the IEEE specifications,
 	 * so this line may not be changed to use the __set_bit() format.
 	 */
-	bss->tim[aid / 8] |= (1 << (aid % 8));
+	bss->tim[aid / 8] |= BIT(aid % 8);
 }
 
 static inline void __bss_tim_clear(struct ieee80211_if_ap *bss, u16 aid)
@@ -452,7 +452,7 @@ static inline void __bss_tim_clear(struct ieee80211_if_ap *bss, u16 aid)
 	 * This format has been mandated by the IEEE specifications,
 	 * so this line may not be changed to use the __clear_bit() format.
 	 */
-	bss->tim[aid / 8] &= ~(1 << (aid % 8));
+	bss->tim[aid / 8] &= ~BIT(aid % 8);
 }
 
 static unsigned long ieee80211_tids_for_ac(int ac)
diff --git a/net/mac80211/status.c b/net/mac80211/status.c
index 2ed2f27..109db50 100644
--- a/net/mac80211/status.c
+++ b/net/mac80211/status.c
@@ -266,8 +266,8 @@ static void ieee80211_add_tx_radiotap_header(struct ieee80211_supported_band
 	memset(rthdr, 0, rtap_len);
 	rthdr->it_len = cpu_to_le16(rtap_len);
 	rthdr->it_present =
-		cpu_to_le32((1 << IEEE80211_RADIOTAP_TX_FLAGS) |
-			    (1 << IEEE80211_RADIOTAP_DATA_RETRIES));
+		cpu_to_le32(BIT(IEEE80211_RADIOTAP_TX_FLAGS) |
+			    BIT(IEEE80211_RADIOTAP_DATA_RETRIES));
 	pos = (unsigned char *)(rthdr + 1);
 
 	/*
@@ -279,7 +279,7 @@ static void ieee80211_add_tx_radiotap_header(struct ieee80211_supported_band
 	/* IEEE80211_RADIOTAP_RATE */
 	if (info->status.rates[0].idx >= 0 &&
 	    !(info->status.rates[0].flags & IEEE80211_TX_RC_MCS)) {
-		rthdr->it_present |= cpu_to_le32(1 << IEEE80211_RADIOTAP_RATE);
+		rthdr->it_present |= cpu_to_le32(BIT(IEEE80211_RADIOTAP_RATE));
 		*pos = sband->bitrates[info->status.rates[0].idx].bitrate / 5;
 		/* padding for tx flags */
 		pos += 2;
@@ -308,7 +308,7 @@ static void ieee80211_add_tx_radiotap_header(struct ieee80211_supported_band
 	/* IEEE80211_TX_RC_MCS */
 	if (info->status.rates[0].idx >= 0 &&
 	    info->status.rates[0].flags & IEEE80211_TX_RC_MCS) {
-		rthdr->it_present |= cpu_to_le32(1 << IEEE80211_RADIOTAP_MCS);
+		rthdr->it_present |= cpu_to_le32(BIT(IEEE80211_RADIOTAP_MCS));
 		pos[0] = IEEE80211_RADIOTAP_MCS_HAVE_MCS |
 			 IEEE80211_RADIOTAP_MCS_HAVE_GI |
 			 IEEE80211_RADIOTAP_MCS_HAVE_BW;
diff --git a/net/mac80211/tkip.c b/net/mac80211/tkip.c
index 57e14d5..ec1b78e 100644
--- a/net/mac80211/tkip.c
+++ b/net/mac80211/tkip.c
@@ -147,7 +147,7 @@ u8 *ieee80211_tkip_add_iv(u8 *pos, struct ieee80211_key *key)
 	lockdep_assert_held(&key->u.tkip.txlock);
 
 	pos = write_tkip_iv(pos, key->u.tkip.tx.iv16);
-	*pos++ = (key->conf.keyidx << 6) | (1 << 5) /* Ext IV */;
+	*pos++ = (key->conf.keyidx << 6) | BIT(5) /* Ext IV */;
 	put_unaligned_le32(key->u.tkip.tx.iv32, pos);
 	return pos + 4;
 }
@@ -261,7 +261,7 @@ int ieee80211_tkip_decrypt_data(struct crypto_cipher *tfm,
 	iv32 = get_unaligned_le32(pos + 4);
 	pos += 8;
 
-	if (!(keyid & (1 << 5)))
+	if (!(keyid & BIT(5)))
 		return TKIP_DECRYPT_NO_EXT_IV;
 
 	if ((keyid >> 6) != key->conf.keyidx)
diff --git a/net/mac80211/tx.c b/net/mac80211/tx.c
index c9d2175..49cbb2b 100644
--- a/net/mac80211/tx.c
+++ b/net/mac80211/tx.c
@@ -620,7 +620,7 @@ ieee80211_tx_h_rate_ctrl(struct ieee80211_tx_data *tx)
 	txrc.skb = tx->skb;
 	txrc.reported_rate.idx = -1;
 	txrc.rate_idx_mask = tx->sdata->rc_rateidx_mask[tx->channel->band];
-	if (txrc.rate_idx_mask == (1 << sband->n_bitrates) - 1)
+	if (txrc.rate_idx_mask == BIT(sband->n_bitrates) - 1)
 		txrc.max_rate_idx = -1;
 	else
 		txrc.max_rate_idx = fls(txrc.rate_idx_mask) - 1;
@@ -2448,7 +2448,7 @@ struct sk_buff *ieee80211_beacon_get_tim(struct ieee80211_hw *hw,
 	txrc.skb = skb;
 	txrc.reported_rate.idx = -1;
 	txrc.rate_idx_mask = sdata->rc_rateidx_mask[band];
-	if (txrc.rate_idx_mask == (1 << sband->n_bitrates) - 1)
+	if (txrc.rate_idx_mask == BIT(sband->n_bitrates) - 1)
 		txrc.max_rate_idx = -1;
 	else
 		txrc.max_rate_idx = fls(txrc.rate_idx_mask) - 1;
@@ -2528,7 +2528,7 @@ struct sk_buff *ieee80211_pspoll_get(struct ieee80211_hw *hw,
 	pspoll->aid = cpu_to_le16(ifmgd->aid);
 
 	/* aid in PS-Poll has its two MSBs each set to 1 */
-	pspoll->aid |= cpu_to_le16(1 << 15 | 1 << 14);
+	pspoll->aid |= cpu_to_le16(BIT(15) | BIT(14));
 
 	memcpy(pspoll->bssid, ifmgd->bssid, ETH_ALEN);
 	memcpy(pspoll->ta, vif->addr, ETH_ALEN);
diff --git a/net/wireless/core.c b/net/wireless/core.c
index eb60410..e955d5c 100644
--- a/net/wireless/core.c
+++ b/net/wireless/core.c
@@ -453,7 +453,7 @@ int wiphy_register(struct wiphy *wiphy)
 
 	/* sanity check ifmodes */
 	WARN_ON(!ifmodes);
-	ifmodes &= ((1 << NUM_NL80211_IFTYPES) - 1) & ~1;
+	ifmodes &= (BIT(NUM_NL80211_IFTYPES) - 1) & ~1;
 	if (WARN_ON(ifmodes != wiphy->interface_modes))
 		wiphy->interface_modes = ifmodes;
 
diff --git a/net/wireless/lib80211_crypt_ccmp.c b/net/wireless/lib80211_crypt_ccmp.c
index 1526c21..0a4aedf 100644
--- a/net/wireless/lib80211_crypt_ccmp.c
+++ b/net/wireless/lib80211_crypt_ccmp.c
@@ -206,7 +206,7 @@ static int lib80211_ccmp_hdr(struct sk_buff *skb, int hdr_len,
 	*pos++ = key->tx_pn[5];
 	*pos++ = key->tx_pn[4];
 	*pos++ = 0;
-	*pos++ = (key->key_idx << 6) | (1 << 5) /* Ext IV included */ ;
+	*pos++ = (key->key_idx << 6) | BIT(5) /* Ext IV included */ ;
 	*pos++ = key->tx_pn[3];
 	*pos++ = key->tx_pn[2];
 	*pos++ = key->tx_pn[1];
@@ -303,7 +303,7 @@ static int lib80211_ccmp_decrypt(struct sk_buff *skb, int hdr_len, void *priv)
 	hdr = (struct ieee80211_hdr *)skb->data;
 	pos = skb->data + hdr_len;
 	keyidx = pos[3];
-	if (!(keyidx & (1 << 5))) {
+	if (!(keyidx & BIT(5))) {
 		net_dbg_ratelimited("CCMP: received packet without ExtIV flag from %pM\n",
 				    hdr->addr2);
 		key->dot11RSNAStatsCCMPFormatErrors++;
diff --git a/net/wireless/lib80211_crypt_tkip.c b/net/wireless/lib80211_crypt_tkip.c
index d475cfc..a514ec6 100644
--- a/net/wireless/lib80211_crypt_tkip.c
+++ b/net/wireless/lib80211_crypt_tkip.c
@@ -335,7 +335,7 @@ static int lib80211_tkip_hdr(struct sk_buff *skb, int hdr_len,
 	*pos++ = *rc4key;
 	*pos++ = *(rc4key + 1);
 	*pos++ = *(rc4key + 2);
-	*pos++ = (tkey->key_idx << 6) | (1 << 5) /* Ext IV included */ ;
+	*pos++ = (tkey->key_idx << 6) | BIT(5) /* Ext IV included */ ;
 	*pos++ = tkey->tx_iv32 & 0xff;
 	*pos++ = (tkey->tx_iv32 >> 8) & 0xff;
 	*pos++ = (tkey->tx_iv32 >> 16) & 0xff;
@@ -427,7 +427,7 @@ static int lib80211_tkip_decrypt(struct sk_buff *skb, int hdr_len, void *priv)
 
 	pos = skb->data + hdr_len;
 	keyidx = pos[3];
-	if (!(keyidx & (1 << 5))) {
+	if (!(keyidx & BIT(5))) {
 		net_dbg_ratelimited("TKIP: received packet without ExtIV flag from %pM\n",
 				    hdr->addr2);
 		return -2;
diff --git a/net/wireless/nl80211.c b/net/wireless/nl80211.c
index 2a5cdb6..ea9b588 100644
--- a/net/wireless/nl80211.c
+++ b/net/wireless/nl80211.c
@@ -1793,7 +1793,7 @@ static int parse_monitor_flags(struct nlattr *nla, u32 *mntrflags)
 
 	for (flag = 1; flag <= NL80211_MNTR_FLAG_MAX; flag++)
 		if (flags[flag])
-			*mntrflags |= (1<<flag);
+			*mntrflags |= BIT(flag);
 
 	return 0;
 }
@@ -1918,7 +1918,7 @@ static int nl80211_new_interface(struct sk_buff *skb, struct genl_info *info)
 	}
 
 	if (!rdev->ops->add_virtual_intf ||
-	    !(rdev->wiphy.interface_modes & (1 << type)))
+	    !(rdev->wiphy.interface_modes & BIT(type)))
 		return -EOPNOTSUPP;
 
 	if (info->attrs[NL80211_ATTR_4ADDR]) {
@@ -2603,7 +2603,7 @@ static int parse_station_flags(struct genl_info *info,
 
 	for (flag = 1; flag <= NL80211_STA_FLAG_MAX; flag++) {
 		if (flags[flag]) {
-			params->sta_flags_set |= (1<<flag);
+			params->sta_flags_set |= BIT(flag);
 
 			/* no longer support new API additions in old API */
 			if (flag > NL80211_STA_FLAG_MAX_OLD_API)
@@ -3663,7 +3663,7 @@ static int nl80211_parse_mesh_config(struct genl_info *info,
 do {\
 	if (table[attr_num]) {\
 		cfg->param = nla_fn(table[attr_num]); \
-		mask |= (1 << (attr_num - 1)); \
+		mask |= BIT(attr_num - 1); \
 	} \
 } while (0);\
 
@@ -4175,7 +4175,7 @@ static int nl80211_trigger_scan(struct sk_buff *skb, struct genl_info *info)
 	for (i = 0; i < IEEE80211_NUM_BANDS; i++)
 		if (wiphy->bands[i])
 			request->rates[i] =
-				(1 << wiphy->bands[i]->n_bitrates) - 1;
+				BIT(wiphy->bands[i]->n_bitrates) - 1;
 
 	if (info->attrs[NL80211_ATTR_SCAN_SUPP_RATES]) {
 		nla_for_each_nested(attr,
@@ -5784,7 +5784,7 @@ static u32 rateset_to_mask(struct ieee80211_supported_band *sband,
 			struct ieee80211_rate *srate =
 				&sband->bitrates[ridx];
 			if (rate == srate->bitrate) {
-				mask |= 1 << ridx;
+				mask |= BIT(ridx);
 				break;
 			}
 		}
@@ -5852,7 +5852,7 @@ static int nl80211_set_tx_bitrate_mask(struct sk_buff *skb,
 	for (i = 0; i < IEEE80211_NUM_BANDS; i++) {
 		sband = rdev->wiphy.bands[i];
 		mask.control[i].legacy =
-			sband ? (1 << sband->n_bitrates) - 1 : 0;
+			sband ? BIT(sband->n_bitrates) - 1 : 0;
 		if (sband)
 			memcpy(mask.control[i].mcs,
 			       sband->ht_cap.mcs.rx_mask,
diff --git a/net/wireless/radiotap.c b/net/wireless/radiotap.c
index c4ad795..10c6484 100644
--- a/net/wireless/radiotap.c
+++ b/net/wireless/radiotap.c
@@ -117,9 +117,9 @@ int ieee80211_radiotap_iterator_init(
 
 	/* find payload start allowing for extended bitmap(s) */
 
-	if (iterator->_bitmap_shifter & (1<<IEEE80211_RADIOTAP_EXT)) {
+	if (iterator->_bitmap_shifter & BIT(IEEE80211_RADIOTAP_EXT)) {
 		while (get_unaligned_le32(iterator->_arg) &
-					(1 << IEEE80211_RADIOTAP_EXT)) {
+					BIT(IEEE80211_RADIOTAP_EXT)) {
 			iterator->_arg += sizeof(uint32_t);
 
 			/*
diff --git a/net/wireless/scan.c b/net/wireless/scan.c
index af2b1ca..adb9d8f 100644
--- a/net/wireless/scan.c
+++ b/net/wireless/scan.c
@@ -1021,7 +1021,7 @@ int cfg80211_wext_siwscan(struct net_device *dev,
 
 	for (i = 0; i < IEEE80211_NUM_BANDS; i++)
 		if (wiphy->bands[i])
-			creq->rates[i] = (1 << wiphy->bands[i]->n_bitrates) - 1;
+			creq->rates[i] = BIT(wiphy->bands[i]->n_bitrates) - 1;
 
 	rdev->scan_req = creq;
 	err = rdev->ops->scan(wiphy, dev, creq);
diff --git a/net/wireless/sme.c b/net/wireless/sme.c
index f7e937f..7d7fea4 100644
--- a/net/wireless/sme.c
+++ b/net/wireless/sme.c
@@ -124,7 +124,7 @@ static int cfg80211_conn_scan(struct wireless_dev *wdev)
 					continue;
 				request->channels[i++] = channel;
 			}
-			request->rates[band] = (1 << bands->n_bitrates) - 1;
+			request->rates[band] = BIT(bands->n_bitrates) - 1;
 		}
 		n_channels = i;
 	}
diff --git a/net/wireless/util.c b/net/wireless/util.c
index e31f1db..2121e7f 100644
--- a/net/wireless/util.c
+++ b/net/wireless/util.c
@@ -813,7 +813,7 @@ int cfg80211_change_iface(struct cfg80211_registered_device *rdev,
 		return -EOPNOTSUPP;
 
 	if (!rdev->ops->change_virtual_intf ||
-	    !(rdev->wiphy.interface_modes & (1 << ntype)))
+	    !(rdev->wiphy.interface_modes & BIT(ntype)))
 		return -EOPNOTSUPP;
 
 	/* if it's part of a bridge, reject changing type to station/ibss */
diff --git a/net/wireless/wext-compat.c b/net/wireless/wext-compat.c
index 7df42f5..3eb6bd4 100644
--- a/net/wireless/wext-compat.c
+++ b/net/wireless/wext-compat.c
@@ -1253,12 +1253,12 @@ static int cfg80211_wext_siwrate(struct net_device *dev,
 		for (ridx = 0; ridx < sband->n_bitrates; ridx++) {
 			struct ieee80211_rate *srate = &sband->bitrates[ridx];
 			if (fixed == srate->bitrate) {
-				mask.control[band].legacy = 1 << ridx;
+				mask.control[band].legacy = BIT(ridx);
 				match = true;
 				break;
 			}
 			if (srate->bitrate <= maxrate) {
-				mask.control[band].legacy |= 1 << ridx;
+				mask.control[band].legacy |= BIT(ridx);
 				match = true;
 			}
 		}
-- 
1.7.9.4

