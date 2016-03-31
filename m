Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga14.intel.com ([192.55.52.115]:42141 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757293AbcCaRE0 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 31 Mar 2016 13:04:26 -0400
From: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
To: johannes@sipsolutions.net
Cc: linux-wireless@vger.kernel.org,
	Johannes Berg <johannes.berg@intel.com>
Subject: [PATCH 09/10] mac80211: add fast-rx path
Date: Thu, 31 Mar 2016 20:02:10 +0300
Message-Id: <1459443731-4614-9-git-send-email-emmanuel.grumbach@intel.com> (sfid-20160331_190432_925790_4C62F2BC)
In-Reply-To: <1459443731-4614-1-git-send-email-emmanuel.grumbach@intel.com>
References: <1459443731-4614-1-git-send-email-emmanuel.grumbach@intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Johannes Berg <johannes.berg@intel.com>

The regular RX path has a lot of code, but with a few
assumptions on the hardware it's possible to reduce the
amount of code significantly. Currently the assumptions
on the driver are the following:
 * hardware/driver reordering buffer (if supporting aggregation)
 * hardware/driver decryption & PN checking (if using encryption)
 * hardware/driver did de-duplication
 * hardware/driver did A-MSDU deaggregation
 * AP_LINK_PS is used (in AP mode)
 * no client powersave handling in mac80211 (in client mode)

of which some are actually checked per packet:
 * de-duplication
 * PN checking
 * decryption
and additionally packets must
 * not be A-MSDU (have been deaggregated by driver/device)
 * be data packets
 * not be fragmented
 * be unicast
 * have RFC 1042 header

Additionally dynamically we assume:
 * no encryption or CCMP/GCMP, TKIP/WEP/other not allowed
 * station must be authorized
 * 4-addr format not enabled

Some data needed for the RX path is cached in a new per-station
"fast_rx" structure, so that we only need to look at this and
the packet, no other memory when processing packets on the fast
RX path.

After doing the above per-packet checks, the data path collapses
down to a pretty simple conversion function taking advantage of
the data cached in the small fast_rx struct.

This should speed up the RX processing, and will make it easier
to reason about parallelizing RX (for which statistics will need
to be per-CPU still.)

Signed-off-by: Johannes Berg <johannes.berg@intel.com>
---
 include/linux/ieee80211.h  |  10 ++
 net/mac80211/cfg.c         |  10 +-
 net/mac80211/ieee80211_i.h |   4 +
 net/mac80211/key.c         |   1 +
 net/mac80211/mlme.c        |   7 +
 net/mac80211/rx.c          | 344 +++++++++++++++++++++++++++++++++++++++++++++
 net/mac80211/sta_info.c    |   2 +
 net/mac80211/sta_info.h    |  34 +++++
 8 files changed, 409 insertions(+), 3 deletions(-)

diff --git a/include/linux/ieee80211.h b/include/linux/ieee80211.h
index bf9706c..113bfc4 100644
--- a/include/linux/ieee80211.h
+++ b/include/linux/ieee80211.h
@@ -638,6 +638,16 @@ static inline bool ieee80211_is_first_frag(__le16 seq_ctrl)
 	return (seq_ctrl & cpu_to_le16(IEEE80211_SCTL_FRAG)) == 0;
 }
 
+/**
+ * ieee80211_is_frag - check if a frame is a fragment
+ * @hdr: 802.11 header of the frame
+ */
+static inline bool ieee80211_is_frag(struct ieee80211_hdr *hdr)
+{
+	return ieee80211_has_morefrags(hdr->frame_control) ||
+	       hdr->seq_ctrl & cpu_to_le16(IEEE80211_SCTL_FRAG);
+}
+
 struct ieee80211s_hdr {
 	u8 flags;
 	u8 ttl;
diff --git a/net/mac80211/cfg.c b/net/mac80211/cfg.c
index 62a90f2..484bcdb 100644
--- a/net/mac80211/cfg.c
+++ b/net/mac80211/cfg.c
@@ -65,11 +65,13 @@ static int ieee80211_change_iface(struct wiphy *wiphy,
 		return ret;
 
 	if (type == NL80211_IFTYPE_AP_VLAN &&
-	    params && params->use_4addr == 0)
+	    params && params->use_4addr == 0) {
 		RCU_INIT_POINTER(sdata->u.vlan.sta, NULL);
-	else if (type == NL80211_IFTYPE_STATION &&
-		 params && params->use_4addr >= 0)
+		ieee80211_check_fast_rx_iface(sdata);
+	} else if (type == NL80211_IFTYPE_STATION &&
+		   params && params->use_4addr >= 0) {
 		sdata->u.mgd.use_4addr = params->use_4addr;
+	}
 
 	if (sdata->vif.type == NL80211_IFTYPE_MONITOR && flags) {
 		struct ieee80211_local *local = sdata->local;
@@ -1367,6 +1369,7 @@ static int ieee80211_change_station(struct wiphy *wiphy,
 
 			rcu_assign_pointer(vlansdata->u.vlan.sta, sta);
 			new_4addr = true;
+			ieee80211_check_fast_rx_iface(vlansdata);
 		}
 
 		if (sta->sdata->vif.type == NL80211_IFTYPE_AP_VLAN &&
@@ -1889,6 +1892,7 @@ static int ieee80211_change_bss(struct wiphy *wiphy,
 			sdata->flags |= IEEE80211_SDATA_DONT_BRIDGE_PACKETS;
 		else
 			sdata->flags &= ~IEEE80211_SDATA_DONT_BRIDGE_PACKETS;
+		ieee80211_check_fast_rx_iface(sdata);
 	}
 
 	if (params->ht_opmode >= 0) {
diff --git a/net/mac80211/ieee80211_i.h b/net/mac80211/ieee80211_i.h
index 0008f28..d0f6534 100644
--- a/net/mac80211/ieee80211_i.h
+++ b/net/mac80211/ieee80211_i.h
@@ -1496,6 +1496,10 @@ u64 ieee80211_mgmt_tx_cookie(struct ieee80211_local *local);
 int ieee80211_attach_ack_skb(struct ieee80211_local *local, struct sk_buff *skb,
 			     u64 *cookie, gfp_t gfp);
 
+void ieee80211_check_fast_rx(struct sta_info *sta);
+void ieee80211_check_fast_rx_iface(struct ieee80211_sub_if_data *sdata);
+void ieee80211_clear_fast_rx(struct sta_info *sta);
+
 /* STA code */
 void ieee80211_sta_setup_sdata(struct ieee80211_sub_if_data *sdata);
 int ieee80211_mgd_auth(struct ieee80211_sub_if_data *sdata,
diff --git a/net/mac80211/key.c b/net/mac80211/key.c
index 3df7b03..edd6f29 100644
--- a/net/mac80211/key.c
+++ b/net/mac80211/key.c
@@ -338,6 +338,7 @@ static void ieee80211_key_replace(struct ieee80211_sub_if_data *sdata,
 		} else {
 			rcu_assign_pointer(sta->gtk[idx], new);
 		}
+		ieee80211_check_fast_rx(sta);
 	} else {
 		defunikey = old &&
 			old == key_mtx_dereference(sdata->local,
diff --git a/net/mac80211/mlme.c b/net/mac80211/mlme.c
index 219e34d..34e8846 100644
--- a/net/mac80211/mlme.c
+++ b/net/mac80211/mlme.c
@@ -2221,6 +2221,7 @@ static void ieee80211_mgd_probe_ap_send(struct ieee80211_sub_if_data *sdata)
 	const u8 *ssid;
 	u8 *dst = ifmgd->associated->bssid;
 	u8 unicast_limit = max(1, max_probe_tries - 3);
+	struct sta_info *sta;
 
 	/*
 	 * Try sending broadcast probe requests for the last three
@@ -2239,6 +2240,12 @@ static void ieee80211_mgd_probe_ap_send(struct ieee80211_sub_if_data *sdata)
 	 */
 	ifmgd->probe_send_count++;
 
+	mutex_lock(&sdata->local->sta_mtx);
+	sta = sta_info_get(sdata, dst);
+	if (!WARN_ON(!sta))
+		ieee80211_check_fast_rx(sta);
+	mutex_unlock(&sdata->local->sta_mtx);
+
 	if (ieee80211_hw_check(&sdata->local->hw, REPORTS_TX_ACK_STATUS)) {
 		ifmgd->nullfunc_failed = false;
 		ieee80211_send_nullfunc(sdata->local, sdata, false);
diff --git a/net/mac80211/rx.c b/net/mac80211/rx.c
index 1511bd1..9bdb009 100644
--- a/net/mac80211/rx.c
+++ b/net/mac80211/rx.c
@@ -3489,6 +3489,335 @@ static bool ieee80211_accept_frame(struct ieee80211_rx_data *rx)
 	return false;
 }
 
+void ieee80211_check_fast_rx(struct sta_info *sta)
+{
+	struct ieee80211_sub_if_data *sdata = sta->sdata;
+	struct ieee80211_local *local = sdata->local;
+	struct ieee80211_key *key;
+	struct ieee80211_fast_rx fastrx = {
+		.dev = sdata->dev,
+		.vif_type = sdata->vif.type,
+		.control_port_protocol = sdata->control_port_protocol,
+	}, *old, *new = NULL;
+	bool assign = false;
+
+	/* use sparse to check that we don't return without updating */
+	__acquire(check_fast_rx);
+
+	BUILD_BUG_ON(sizeof(fastrx.rfc1042_hdr) != sizeof(rfc1042_header));
+	BUILD_BUG_ON(sizeof(fastrx.rfc1042_hdr) != ETH_ALEN);
+	ether_addr_copy(fastrx.rfc1042_hdr, rfc1042_header);
+	ether_addr_copy(fastrx.vif_addr, sdata->vif.addr);
+
+	/* fast-rx doesn't do reordering */
+	if (ieee80211_hw_check(&local->hw, AMPDU_AGGREGATION) &&
+	    !ieee80211_hw_check(&local->hw, SUPPORTS_REORDERING_BUFFER))
+		goto clear;
+
+	switch (sdata->vif.type) {
+	case NL80211_IFTYPE_STATION:
+		/* 4-addr is harder to deal with, later maybe */
+		if (sdata->u.mgd.use_4addr)
+			goto clear;
+		/* software powersave is a huge mess, avoid all of it */
+		if (ieee80211_hw_check(&local->hw, PS_NULLFUNC_STACK))
+			goto clear;
+		if (ieee80211_hw_check(&local->hw, SUPPORTS_PS) &&
+		    !ieee80211_hw_check(&local->hw, SUPPORTS_DYNAMIC_PS))
+			goto clear;
+		if (sta->sta.tdls) {
+			fastrx.da_offs = offsetof(struct ieee80211_hdr, addr1);
+			fastrx.sa_offs = offsetof(struct ieee80211_hdr, addr2);
+			fastrx.expected_ds_bits = 0;
+		} else {
+			fastrx.sta_notify = sdata->u.mgd.probe_send_count > 0;
+			fastrx.da_offs = offsetof(struct ieee80211_hdr, addr1);
+			fastrx.sa_offs = offsetof(struct ieee80211_hdr, addr3);
+			fastrx.expected_ds_bits =
+				cpu_to_le16(IEEE80211_FCTL_FROMDS);
+		}
+		break;
+	case NL80211_IFTYPE_AP_VLAN:
+	case NL80211_IFTYPE_AP:
+		/* parallel-rx requires this, at least with calls to
+		 * ieee80211_sta_ps_transition()
+		 */
+		if (!ieee80211_hw_check(&local->hw, AP_LINK_PS))
+			goto clear;
+		fastrx.da_offs = offsetof(struct ieee80211_hdr, addr3);
+		fastrx.sa_offs = offsetof(struct ieee80211_hdr, addr2);
+		fastrx.expected_ds_bits = cpu_to_le16(IEEE80211_FCTL_TODS);
+
+		fastrx.internal_forward =
+			!(sdata->flags & IEEE80211_SDATA_DONT_BRIDGE_PACKETS) &&
+			(sdata->vif.type != NL80211_IFTYPE_AP_VLAN ||
+			 !sdata->u.vlan.sta);
+		break;
+	default:
+		goto clear;
+	}
+
+	if (!test_sta_flag(sta, WLAN_STA_AUTHORIZED))
+		goto clear;
+
+	rcu_read_lock();
+	key = rcu_dereference(sta->ptk[sta->ptk_idx]);
+	if (key) {
+		switch (key->conf.cipher) {
+		case WLAN_CIPHER_SUITE_TKIP:
+			/* we don't want to deal with MMIC in fast-rx */
+			goto clear_rcu;
+		case WLAN_CIPHER_SUITE_CCMP:
+		case WLAN_CIPHER_SUITE_CCMP_256:
+		case WLAN_CIPHER_SUITE_GCMP:
+		case WLAN_CIPHER_SUITE_GCMP_256:
+			break;
+		default:
+			/* we also don't want to deal with WEP or cipher scheme
+			 * since those require looking up the key idx in the
+			 * frame, rather than assuming the PTK is used
+			 * (we need to revisit this once we implement the real
+			 * PTK index, which is now valid in the spec, but we
+			 * haven't implemented that part yet)
+			 */
+			goto clear_rcu;
+		}
+
+		fastrx.key = true;
+		fastrx.icv_len = key->conf.icv_len;
+	}
+
+	assign = true;
+ clear_rcu:
+	rcu_read_unlock();
+ clear:
+	__release(check_fast_rx);
+
+	if (assign)
+		new = kmemdup(&fastrx, sizeof(fastrx), GFP_KERNEL);
+
+	spin_lock_bh(&sta->lock);
+	old = rcu_dereference_protected(sta->fast_rx, true);
+	rcu_assign_pointer(sta->fast_rx, new);
+	spin_unlock_bh(&sta->lock);
+
+	if (old)
+		kfree_rcu(old, rcu_head);
+}
+
+void ieee80211_clear_fast_rx(struct sta_info *sta)
+{
+	struct ieee80211_fast_rx *old;
+
+	spin_lock_bh(&sta->lock);
+	old = rcu_dereference_protected(sta->fast_rx, true);
+	RCU_INIT_POINTER(sta->fast_rx, NULL);
+	spin_unlock_bh(&sta->lock);
+
+	if (old)
+		kfree_rcu(old, rcu_head);
+}
+
+void ieee80211_check_fast_rx_iface(struct ieee80211_sub_if_data *sdata)
+{
+	struct ieee80211_local *local = sdata->local;
+	struct sta_info *sta;
+
+	mutex_lock(&local->sta_mtx);
+
+	list_for_each_entry_rcu(sta, &local->sta_list, list) {
+		if (sdata != sta->sdata &&
+		    (!sta->sdata->bss || sta->sdata->bss != sdata->bss))
+			continue;
+		ieee80211_check_fast_rx(sta);
+	}
+
+	mutex_unlock(&local->sta_mtx);
+}
+
+static bool ieee80211_invoke_fast_rx(struct ieee80211_rx_data *rx,
+				     struct ieee80211_fast_rx *fast_rx)
+{
+	struct sk_buff *skb = rx->skb;
+	struct ieee80211_hdr *hdr = (void *)skb->data;
+	struct ieee80211_rx_status *status = IEEE80211_SKB_RXCB(skb);
+	struct sta_info *sta = rx->sta;
+	int orig_len = skb->len;
+	int snap_offs = ieee80211_hdrlen(hdr->frame_control);
+	struct {
+		u8 snap[sizeof(rfc1042_header)];
+		__be16 proto;
+	} *payload __aligned(2);
+	struct {
+		u8 da[ETH_ALEN];
+		u8 sa[ETH_ALEN];
+	} addrs __aligned(2);
+
+	/* for parallel-rx, we need to have DUP_VALIDATED, otherwise we write
+	 * to a common data structure; drivers can implement that per queue
+	 * but we don't have that information in mac80211
+	 */
+	if (!(status->flag & RX_FLAG_DUP_VALIDATED))
+		return false;
+
+#define FAST_RX_CRYPT_FLAGS	(RX_FLAG_PN_VALIDATED | RX_FLAG_DECRYPTED)
+
+	/* If using encryption, we also need to have:
+	 *  - PN_VALIDATED: similar, but the implementation is tricky
+	 *  - DECRYPTED: necessary for PN_VALIDATED
+	 */
+	if (fast_rx->key &&
+	    (status->flag & FAST_RX_CRYPT_FLAGS) != FAST_RX_CRYPT_FLAGS)
+		return false;
+
+	/* we don't deal with A-MSDU deaggregation here */
+	if (status->rx_flags & IEEE80211_RX_AMSDU)
+		return false;
+
+	if (unlikely(!ieee80211_is_data_present(hdr->frame_control)))
+		return false;
+
+	if (unlikely(ieee80211_is_frag(hdr)))
+		return false;
+
+	/* Since our interface address cannot be multicast, this
+	 * implicitly also rejects multicast frames without the
+	 * explicit check.
+	 *
+	 * We shouldn't get any *data* frames not addressed to us
+	 * (AP mode will accept multicast *management* frames), but
+	 * punting here will make it go through the full checks in
+	 * ieee80211_accept_frame().
+	 */
+	if (!ether_addr_equal(fast_rx->vif_addr, hdr->addr1))
+		return false;
+
+	if ((hdr->frame_control & cpu_to_le16(IEEE80211_FCTL_FROMDS |
+					      IEEE80211_FCTL_TODS)) !=
+	    fast_rx->expected_ds_bits)
+		goto drop;
+
+	/* assign the key to drop unencrypted frames (later)
+	 * and strip the IV/MIC if necessary
+	 */
+	if (fast_rx->key && !(status->flag & RX_FLAG_IV_STRIPPED)) {
+		/* GCMP header length is the same */
+		snap_offs += IEEE80211_CCMP_HDR_LEN;
+	}
+
+	if (!pskb_may_pull(skb, snap_offs + sizeof(*payload)))
+		goto drop;
+	payload = (void *)(skb->data + snap_offs);
+
+	if (!ether_addr_equal(payload->snap, fast_rx->rfc1042_hdr))
+		return false;
+
+	/* Don't handle these here since they require special code.
+	 * Accept AARP and IPX even though they should come with a
+	 * bridge-tunnel header - but if we get them this way then
+	 * there's little point in discarding them.
+	 */
+	if (unlikely(payload->proto == cpu_to_be16(ETH_P_TDLS) ||
+		     payload->proto == fast_rx->control_port_protocol))
+		return false;
+
+	/* after this point, don't punt to the slowpath! */
+
+	if (rx->key && !(status->flag & RX_FLAG_MIC_STRIPPED) &&
+	    pskb_trim(skb, skb->len - fast_rx->icv_len))
+		goto drop;
+
+	if (unlikely(fast_rx->sta_notify)) {
+		ieee80211_sta_rx_notify(rx->sdata, hdr);
+		fast_rx->sta_notify = false;
+	}
+
+	/* statistics part of ieee80211_rx_h_sta_process() */
+	sta->rx_stats.last_rx = jiffies;
+	sta->rx_stats.last_rate = sta_stats_encode_rate(status);
+
+	sta->rx_stats.fragments++;
+
+	if (!(status->flag & RX_FLAG_NO_SIGNAL_VAL)) {
+		sta->rx_stats.last_signal = status->signal;
+		ewma_signal_add(&sta->rx_stats_avg.signal, -status->signal);
+	}
+
+	if (status->chains) {
+		int i;
+
+		sta->rx_stats.chains = status->chains;
+		for (i = 0; i < ARRAY_SIZE(status->chain_signal); i++) {
+			int signal = status->chain_signal[i];
+
+			if (!(status->chains & BIT(i)))
+				continue;
+
+			sta->rx_stats.chain_signal_last[i] = signal;
+			ewma_signal_add(&sta->rx_stats_avg.chain_signal[i],
+					-signal);
+		}
+	}
+	/* end of statistics */
+
+	if (rx->key && !ieee80211_has_protected(hdr->frame_control))
+		goto drop;
+
+	/* do the header conversion - first grab the addresses */
+	ether_addr_copy(addrs.da, skb->data + fast_rx->da_offs);
+	ether_addr_copy(addrs.sa, skb->data + fast_rx->sa_offs);
+	/* remove the SNAP but leave the ethertype */
+	skb_pull(skb, snap_offs + sizeof(rfc1042_header));
+	/* push the addresses in front */
+	memcpy(skb_push(skb, sizeof(addrs)), &addrs, sizeof(addrs));
+
+	skb->dev = fast_rx->dev;
+
+	ieee80211_rx_stats(fast_rx->dev, skb->len);
+
+	/* The seqno index has the same property as needed
+	 * for the rx_msdu field, i.e. it is IEEE80211_NUM_TIDS
+	 * for non-QoS-data frames. Here we know it's a data
+	 * frame, so count MSDUs.
+	 */
+	u64_stats_update_begin(&sta->rx_stats.syncp);
+	sta->rx_stats.msdu[rx->seqno_idx]++;
+	sta->rx_stats.bytes += orig_len;
+	u64_stats_update_end(&sta->rx_stats.syncp);
+
+	if (fast_rx->internal_forward) {
+		struct sta_info *dsta = sta_info_get(rx->sdata, skb->data);
+
+		if (dsta) {
+			/*
+			 * Send to wireless media and increase priority by 256
+			 * to keep the received priority instead of
+			 * reclassifying the frame (see cfg80211_classify8021d).
+			 */
+			skb->priority += 256;
+			skb->protocol = htons(ETH_P_802_3);
+			skb_reset_network_header(skb);
+			skb_reset_mac_header(skb);
+			dev_queue_xmit(skb);
+			return true;
+		}
+	}
+
+	/* deliver to local stack */
+	skb->protocol = eth_type_trans(skb, fast_rx->dev);
+	memset(skb->cb, 0, sizeof(skb->cb));
+	if (rx->napi)
+		napi_gro_receive(rx->napi, skb);
+	else
+		netif_receive_skb(skb);
+
+	return true;
+ drop:
+	dev_kfree_skb(skb);
+	sta->rx_stats.dropped++;
+	return true;
+}
+
 /*
  * This function returns whether or not the SKB
  * was destined for RX processing or not, which,
@@ -3503,6 +3832,21 @@ static bool ieee80211_prepare_and_rx_handle(struct ieee80211_rx_data *rx,
 
 	rx->skb = skb;
 
+	/* See if we can do fast-rx; if we have to copy we already lost,
+	 * so punt in that case. We should never have to deliver a data
+	 * frame to multiple interfaces anyway.
+	 *
+	 * We skip the ieee80211_accept_frame() call and do the necessary
+	 * checking inside ieee80211_invoke_fast_rx().
+	 */
+	if (consume && rx->sta) {
+		struct ieee80211_fast_rx *fast_rx;
+
+		fast_rx = rcu_dereference(rx->sta->fast_rx);
+		if (fast_rx && ieee80211_invoke_fast_rx(rx, fast_rx))
+			return true;
+	}
+
 	if (!ieee80211_accept_frame(rx))
 		return false;
 
diff --git a/net/mac80211/sta_info.c b/net/mac80211/sta_info.c
index f097a5e..877e983 100644
--- a/net/mac80211/sta_info.c
+++ b/net/mac80211/sta_info.c
@@ -1874,6 +1874,7 @@ int sta_info_move_state(struct sta_info *sta,
 				atomic_dec(&sta->sdata->bss->num_mcast_sta);
 			clear_bit(WLAN_STA_AUTHORIZED, &sta->_flags);
 			ieee80211_clear_fast_xmit(sta);
+			ieee80211_clear_fast_rx(sta);
 		}
 		break;
 	case IEEE80211_STA_AUTHORIZED:
@@ -1884,6 +1885,7 @@ int sta_info_move_state(struct sta_info *sta,
 				atomic_inc(&sta->sdata->bss->num_mcast_sta);
 			set_bit(WLAN_STA_AUTHORIZED, &sta->_flags);
 			ieee80211_check_fast_xmit(sta);
+			ieee80211_check_fast_rx(sta);
 		}
 		break;
 	default:
diff --git a/net/mac80211/sta_info.h b/net/mac80211/sta_info.h
index cbce43f..6ee37e3 100644
--- a/net/mac80211/sta_info.h
+++ b/net/mac80211/sta_info.h
@@ -286,6 +286,38 @@ struct ieee80211_fast_tx {
 };
 
 /**
+ * struct ieee80211_fast_rx - RX fastpath information
+ * @dev: netdevice for reporting the SKB
+ * @vif_type: (P2P-less) interface type of the original sdata (sdata->vif.type)
+ * @vif_addr: interface address
+ * @rfc1042_hdr: copy of the RFC 1042 SNAP header (to have in cache)
+ * @control_port_protocol: control port protocol copied from sdata
+ * @expected_ds_bits: from/to DS bits expected
+ * @icv_len: length of the MIC if present
+ * @key: bool indicating encryption is expected (key is set)
+ * @sta_notify: notify the MLME code (once)
+ * @internal_forward: forward froms internally on AP/VLAN type interfaces
+ * @da_offs: offset of the DA in the header (for header conversion)
+ * @sa_offs: offset of the SA in the header (for header conversion)
+ * @rcu_head: RCU head for freeing this structure
+ */
+struct ieee80211_fast_rx {
+	struct net_device *dev;
+	enum nl80211_iftype vif_type;
+	u8 vif_addr[ETH_ALEN] __aligned(2);
+	u8 rfc1042_hdr[6] __aligned(2);
+	__be16 control_port_protocol;
+	__le16 expected_ds_bits;
+	u8 icv_len;
+	u8 key:1,
+	   sta_notify:1,
+	   internal_forward:1;
+	u8 da_offs, sa_offs;
+
+	struct rcu_head rcu_head;
+};
+
+/**
  * struct mesh_sta - mesh STA information
  * @plink_lock: serialize access to plink fields
  * @llid: Local link ID
@@ -391,6 +423,7 @@ DECLARE_EWMA(signal, 1024, 8)
  * @cipher_scheme: optional cipher scheme for this station
  * @reserved_tid: reserved TID (if any, otherwise IEEE80211_TID_UNRESERVED)
  * @fast_tx: TX fastpath information
+ * @fast_rx: RX fastpath information
  * @tdls_chandef: a TDLS peer can have a wider chandef that is compatible to
  *	the BSS one.
  * @tx_stats: TX statistics
@@ -414,6 +447,7 @@ struct sta_info {
 	spinlock_t lock;
 
 	struct ieee80211_fast_tx __rcu *fast_tx;
+	struct ieee80211_fast_rx __rcu *fast_rx;
 
 #ifdef CONFIG_MAC80211_MESH
 	struct mesh_sta *mesh;
-- 
2.5.0

