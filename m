Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([5.9.151.49]:47611 "EHLO sipsolutions.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754120AbbDQPP5 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 17 Apr 2015 11:15:57 -0400
From: Johannes Berg <johannes@sipsolutions.net>
To: linux-wireless@vger.kernel.org
Cc: Johannes Berg <johannes.berg@intel.com>
Subject: [PATCH 01/11] mac80211: add TX fastpath
Date: Fri, 17 Apr 2015 17:15:41 +0200
Message-Id: <1429283751-5104-1-git-send-email-johannes@sipsolutions.net> (sfid-20150417_171606_577624_82458E43)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Johannes Berg <johannes.berg@intel.com>

In order to speed up mac80211's TX path, add the "fast-xmit" cache
that will cache the data frame 802.11 header and other data to be
able to build the frame more quickly. This cache is rebuilt when
external triggers imply changes, but a lot of the checks done per
packet today are simplified away to the check for the cache.

There's also a more detailed description in the code.

Signed-off-by: Johannes Berg <johannes.berg@intel.com>
---
 include/net/mac80211.h     |   6 +-
 net/mac80211/cfg.c         |   9 +-
 net/mac80211/chan.c        |   6 +
 net/mac80211/ieee80211_i.h |   5 +
 net/mac80211/key.c         |   2 +
 net/mac80211/rx.c          |   2 +
 net/mac80211/sta_info.c    |   4 +
 net/mac80211/sta_info.h    |  27 +++
 net/mac80211/tx.c          | 404 ++++++++++++++++++++++++++++++++++++++++++++-
 9 files changed, 462 insertions(+), 3 deletions(-)

diff --git a/include/net/mac80211.h b/include/net/mac80211.h
index 38a5fd790366..9001bd685b1e 100644
--- a/include/net/mac80211.h
+++ b/include/net/mac80211.h
@@ -1796,6 +1796,10 @@ struct ieee80211_txq {
  *	the driver returns 1. This also forces the driver to advertise its
  *	supported cipher suites.
  *
+ * @IEEE80211_HW_SUPPORT_FAST_XMIT: The driver/hardware supports fast-xmit,
+ *	this currently requires only the ability to calculate the duration
+ *	for frames.
+ *
  * @IEEE80211_HW_QUEUE_CONTROL: The driver wants to control per-interface
  *	queue mapping in order to use different queues (not just one per AC)
  *	for different virtual interfaces. See the doc section on HW queue
@@ -1844,7 +1848,7 @@ enum ieee80211_hw_flags {
 	IEEE80211_HW_WANT_MONITOR_VIF			= 1<<14,
 	IEEE80211_HW_NO_AUTO_VIF			= 1<<15,
 	IEEE80211_HW_SW_CRYPTO_CONTROL			= 1<<16,
-	/* free slots */
+	IEEE80211_HW_SUPPORT_FAST_XMIT			= 1<<17,
 	IEEE80211_HW_REPORTS_TX_ACK_STATUS		= 1<<18,
 	IEEE80211_HW_CONNECTION_MONITOR			= 1<<19,
 	IEEE80211_HW_QUEUE_CONTROL			= 1<<20,
diff --git a/net/mac80211/cfg.c b/net/mac80211/cfg.c
index 265e42721a66..4aa5e893cbaa 100644
--- a/net/mac80211/cfg.c
+++ b/net/mac80211/cfg.c
@@ -137,6 +137,9 @@ static int ieee80211_set_noack_map(struct wiphy *wiphy,
 	struct ieee80211_sub_if_data *sdata = IEEE80211_DEV_TO_SUB_IF(dev);
 
 	sdata->noack_map = noack_map;
+
+	ieee80211_check_fast_xmit_iface(sdata);
+
 	return 0;
 }
 
@@ -2099,10 +2102,14 @@ static int ieee80211_set_wiphy_params(struct wiphy *wiphy, u32 changed)
 	int err;
 
 	if (changed & WIPHY_PARAM_FRAG_THRESHOLD) {
+		ieee80211_check_fast_xmit_all(local);
+
 		err = drv_set_frag_threshold(local, wiphy->frag_threshold);
 
-		if (err)
+		if (err) {
+			ieee80211_check_fast_xmit_all(local);
 			return err;
+		}
 	}
 
 	if ((changed & WIPHY_PARAM_COVERAGE_CLASS) ||
diff --git a/net/mac80211/chan.c b/net/mac80211/chan.c
index 5bcd4e5589d3..7e9b62475400 100644
--- a/net/mac80211/chan.c
+++ b/net/mac80211/chan.c
@@ -664,6 +664,8 @@ out:
 		ieee80211_bss_info_change_notify(sdata,
 						 BSS_CHANGED_IDLE);
 
+	ieee80211_check_fast_xmit_iface(sdata);
+
 	return ret;
 }
 
@@ -1030,6 +1032,8 @@ ieee80211_vif_use_reserved_reassign(struct ieee80211_sub_if_data *sdata)
 	if (sdata->vif.type == NL80211_IFTYPE_AP)
 		__ieee80211_vif_copy_chanctx_to_vlans(sdata, false);
 
+	ieee80211_check_fast_xmit_iface(sdata);
+
 	if (ieee80211_chanctx_refcount(local, old_ctx) == 0)
 		ieee80211_free_chanctx(local, old_ctx);
 
@@ -1376,6 +1380,8 @@ static int ieee80211_vif_use_reserved_switch(struct ieee80211_local *local)
 				__ieee80211_vif_copy_chanctx_to_vlans(sdata,
 								      false);
 
+			ieee80211_check_fast_xmit_iface(sdata);
+
 			sdata->radar_required = sdata->reserved_radar_required;
 
 			if (sdata->vif.bss_conf.chandef.width !=
diff --git a/net/mac80211/ieee80211_i.h b/net/mac80211/ieee80211_i.h
index ab46ab4a7249..09a15a855c5a 100644
--- a/net/mac80211/ieee80211_i.h
+++ b/net/mac80211/ieee80211_i.h
@@ -1651,6 +1651,11 @@ struct sk_buff *
 ieee80211_build_data_template(struct ieee80211_sub_if_data *sdata,
 			      struct sk_buff *skb, u32 info_flags);
 
+void ieee80211_check_fast_xmit(struct sta_info *sta, gfp_t gfp);
+void ieee80211_check_fast_xmit_all(struct ieee80211_local *local);
+void ieee80211_check_fast_xmit_iface(struct ieee80211_sub_if_data *sdata);
+void ieee80211_clear_fast_xmit(struct sta_info *sta);
+
 /* HT */
 void ieee80211_apply_htcap_overrides(struct ieee80211_sub_if_data *sdata,
 				     struct ieee80211_sta_ht_cap *ht_cap);
diff --git a/net/mac80211/key.c b/net/mac80211/key.c
index 2291cd730091..ac7eb9201ac1 100644
--- a/net/mac80211/key.c
+++ b/net/mac80211/key.c
@@ -229,6 +229,7 @@ static void __ieee80211_set_default_key(struct ieee80211_sub_if_data *sdata,
 
 	if (uni) {
 		rcu_assign_pointer(sdata->default_unicast_key, key);
+		ieee80211_check_fast_xmit_iface(sdata);
 		drv_set_default_unicast_key(sdata->local, sdata, idx);
 	}
 
@@ -298,6 +299,7 @@ static void ieee80211_key_replace(struct ieee80211_sub_if_data *sdata,
 		if (pairwise) {
 			rcu_assign_pointer(sta->ptk[idx], new);
 			sta->ptk_idx = idx;
+			ieee80211_check_fast_xmit(sta, GFP_KERNEL);
 		} else {
 			rcu_assign_pointer(sta->gtk[idx], new);
 			sta->gtk_idx = idx;
diff --git a/net/mac80211/rx.c b/net/mac80211/rx.c
index bc59c8a20a39..3d890643af2e 100644
--- a/net/mac80211/rx.c
+++ b/net/mac80211/rx.c
@@ -1199,6 +1199,8 @@ static void sta_ps_start(struct sta_info *sta)
 	ps_dbg(sdata, "STA %pM aid %d enters power save mode\n",
 	       sta->sta.addr, sta->sta.aid);
 
+	ieee80211_clear_fast_xmit(sta);
+
 	if (!sta->sta.txq[0])
 		return;
 
diff --git a/net/mac80211/sta_info.c b/net/mac80211/sta_info.c
index 0800e02cce05..21462e3e68c9 100644
--- a/net/mac80211/sta_info.c
+++ b/net/mac80211/sta_info.c
@@ -1201,6 +1201,8 @@ void ieee80211_sta_ps_deliver_wakeup(struct sta_info *sta)
 	ps_dbg(sdata,
 	       "STA %pM aid %d sending %d filtered/%d PS frames since STA not sleeping anymore\n",
 	       sta->sta.addr, sta->sta.aid, filtered, buffered);
+
+	ieee80211_check_fast_xmit(sta, GFP_ATOMIC);
 }
 
 static void ieee80211_send_null_response(struct ieee80211_sub_if_data *sdata,
@@ -1720,6 +1722,7 @@ int sta_info_move_state(struct sta_info *sta,
 			     !sta->sdata->u.vlan.sta))
 				atomic_dec(&sta->sdata->bss->num_mcast_sta);
 			clear_bit(WLAN_STA_AUTHORIZED, &sta->_flags);
+			ieee80211_clear_fast_xmit(sta);
 		}
 		break;
 	case IEEE80211_STA_AUTHORIZED:
@@ -1729,6 +1732,7 @@ int sta_info_move_state(struct sta_info *sta,
 			     !sta->sdata->u.vlan.sta))
 				atomic_inc(&sta->sdata->bss->num_mcast_sta);
 			set_bit(WLAN_STA_AUTHORIZED, &sta->_flags);
+			ieee80211_check_fast_xmit(sta, GFP_KERNEL);
 		}
 		break;
 	default:
diff --git a/net/mac80211/sta_info.h b/net/mac80211/sta_info.h
index a875b92c7acf..e365f6213702 100644
--- a/net/mac80211/sta_info.h
+++ b/net/mac80211/sta_info.h
@@ -240,6 +240,30 @@ struct sta_ampdu_mlme {
 #define IEEE80211_TID_UNRESERVED	0xff
 
 /**
+ * struct ieee80211_fast_tx - TX fastpath information
+ * @key: key to use for hw crypto
+ * @hdr: the 802.11 header to put with the frame
+ * @hdr_len: actual 802.11 header length
+ * @sa_offs: offset of the SA
+ * @da_offs: offset of the DA
+ * @pn_offs: offset where to put PN for crypto (or 0 if not needed)
+ * @band: band this will be transmitted on, for tx_info
+ * @rcu_head: RCU head to free this struct
+ *
+ * Try to keep this struct small so it fits into a single cacheline.
+ */
+struct ieee80211_fast_tx {
+	struct ieee80211_key *key;
+	u8 hdr[30 + 2 + IEEE80211_CCMP_HDR_LEN +
+	       sizeof(rfc1042_header)];
+	u8 hdr_len;
+	u8 sa_offs, da_offs, pn_offs;
+	u8 band;
+
+	struct rcu_head rcu_head;
+};
+
+/**
  * struct sta_info - STA information
  *
  * This structure collects information about a station that
@@ -337,6 +361,7 @@ struct sta_ampdu_mlme {
  *	using IEEE80211_NUM_TID entry for non-QoS frames
  * @rx_msdu: MSDUs received from this station, using IEEE80211_NUM_TID
  *	entry for non-QoS frames
+ * @fast_tx: TX fastpath information
  */
 struct sta_info {
 	/* General information, mostly static */
@@ -354,6 +379,8 @@ struct sta_info {
 	spinlock_t rate_ctrl_lock;
 	spinlock_t lock;
 
+	struct ieee80211_fast_tx __rcu *fast_tx;
+
 	struct work_struct drv_deliver_wk;
 
 	u16 listen_interval;
diff --git a/net/mac80211/tx.c b/net/mac80211/tx.c
index 667111ee6a20..d5bfa6c4afd0 100644
--- a/net/mac80211/tx.c
+++ b/net/mac80211/tx.c
@@ -1600,7 +1600,7 @@ static int ieee80211_skb_resize(struct ieee80211_sub_if_data *sdata,
 	if (skb_cloned(skb) &&
 	    (!(local->hw.flags & IEEE80211_HW_SUPPORTS_CLONED_SKBS) ||
 	     !skb_clone_writable(skb, ETH_HLEN) ||
-	     sdata->crypto_tx_tailroom_needed_cnt))
+	     (may_encrypt && sdata->crypto_tx_tailroom_needed_cnt)))
 		I802_DEBUG_INC(local->tx_expand_skb_head_cloned);
 	else if (head_need || tail_need)
 		I802_DEBUG_INC(local->tx_expand_skb_head);
@@ -2387,6 +2387,398 @@ static struct sk_buff *ieee80211_build_hdr(struct ieee80211_sub_if_data *sdata,
 	return ERR_PTR(ret);
 }
 
+/*
+ * fast-xmit overview
+ *
+ * The core idea of this fast-xmit is to remove per-packet checks by checking
+ * them out of band. ieee80211_check_fast_xmit() implements the out-of-band
+ * checks that are needed to get the sta->fast_tx pointer assigned, after which
+ * much less work can be done per packet. For example, fragmentation must be
+ * disabled or the fast_tx pointer will not be set. All the conditions are seen
+ * in the code here.
+ *
+ * Once assigned, the fast_tx data structure also caches the per-packet 802.11
+ * header and other data to aid packet processing in ieee80211_xmit_fast().
+ *
+ * The most difficult part of this is that when any of these assumptions
+ * change, an external trigger (i.e. a call to ieee80211_clear_fast_xmit(),
+ * ieee80211_check_fast_xmit() or friends) is required to reset the data,
+ * since the per-packet code no longer checks the conditions. This is reflected
+ * by the calls to these functions throughout the rest of the code, and must be
+ * maintained if any of the TX path checks change.
+ */
+
+void ieee80211_check_fast_xmit(struct sta_info *sta, gfp_t gfp)
+{
+	struct ieee80211_fast_tx build = {}, *fast_tx, *old;
+	struct ieee80211_local *local = sta->local;
+	struct ieee80211_sub_if_data *sdata = sta->sdata;
+	struct ieee80211_hdr *hdr = (void *)build.hdr;
+	struct ieee80211_chanctx_conf *chanctx_conf;
+	__le16 fc;
+
+	if (!(local->hw.flags & IEEE80211_HW_SUPPORT_FAST_XMIT))
+		return;
+
+	ieee80211_clear_fast_xmit(sta);
+
+	if (local->hw.flags & IEEE80211_HW_SUPPORTS_PS &&
+	    !(local->hw.flags & IEEE80211_HW_SUPPORTS_DYNAMIC_PS) &&
+	    sdata->vif.type == NL80211_IFTYPE_STATION)
+		return;
+
+	if (!test_sta_flag(sta, WLAN_STA_AUTHORIZED))
+		return;
+
+	if (test_sta_flag(sta, WLAN_STA_PS_STA) ||
+	    test_sta_flag(sta, WLAN_STA_PS_DRIVER) ||
+	    test_sta_flag(sta, WLAN_STA_PS_DELIVER))
+		return;
+
+	if (sdata->noack_map)
+		return;
+
+	/* fast-xmit doesn't handle fragmentation at all */
+	if (local->hw.wiphy->frag_threshold != (u32)-1)
+		return;
+
+	rcu_read_lock();
+	chanctx_conf = rcu_dereference(sdata->vif.chanctx_conf);
+	if (!chanctx_conf) {
+		rcu_read_unlock();
+		return;
+	}
+	build.band = chanctx_conf->def.chan->band;
+	rcu_read_unlock();
+
+	fc = cpu_to_le16(IEEE80211_FTYPE_DATA | IEEE80211_STYPE_DATA);
+
+	switch (sdata->vif.type) {
+	case NL80211_IFTYPE_STATION:
+		if (test_sta_flag(sta, WLAN_STA_TDLS_PEER)) {
+			/* DA SA BSSID */
+			build.da_offs = offsetof(struct ieee80211_hdr, addr1);
+			build.sa_offs = offsetof(struct ieee80211_hdr, addr2);
+			memcpy(hdr->addr3, sdata->u.mgd.bssid, ETH_ALEN);
+			build.hdr_len = 24;
+			break;
+		}
+
+		if (sdata->u.mgd.use_4addr) {
+			/* non-regular ethertype cannot use the fastpath */
+			fc |= cpu_to_le16(IEEE80211_FCTL_FROMDS |
+					  IEEE80211_FCTL_TODS);
+			/* RA TA DA SA */
+			memcpy(hdr->addr1, sdata->u.mgd.bssid, ETH_ALEN);
+			memcpy(hdr->addr2, sdata->vif.addr, ETH_ALEN);
+			build.da_offs = offsetof(struct ieee80211_hdr, addr3);
+			build.sa_offs = offsetof(struct ieee80211_hdr, addr4);
+			build.hdr_len = 30;
+			break;
+		}
+		fc |= cpu_to_le16(IEEE80211_FCTL_TODS);
+		/* BSSID SA DA */
+		memcpy(hdr->addr1, sdata->u.mgd.bssid, ETH_ALEN);
+		build.da_offs = offsetof(struct ieee80211_hdr, addr3);
+		build.sa_offs = offsetof(struct ieee80211_hdr, addr2);
+		build.hdr_len = 24;
+		break;
+	case NL80211_IFTYPE_AP_VLAN:
+		if (sdata->wdev.use_4addr) {
+			fc |= cpu_to_le16(IEEE80211_FCTL_FROMDS |
+					  IEEE80211_FCTL_TODS);
+			/* RA TA DA SA */
+			memcpy(hdr->addr1, sta->sta.addr, ETH_ALEN);
+			memcpy(hdr->addr2, sdata->vif.addr, ETH_ALEN);
+			build.da_offs = offsetof(struct ieee80211_hdr, addr3);
+			build.sa_offs = offsetof(struct ieee80211_hdr, addr4);
+			build.hdr_len = 30;
+			break;
+		}
+		/* fall through */
+	case NL80211_IFTYPE_AP:
+		fc |= cpu_to_le16(IEEE80211_FCTL_FROMDS);
+		/* DA BSSID SA */
+		build.da_offs = offsetof(struct ieee80211_hdr, addr1);
+		memcpy(hdr->addr2, sdata->vif.addr, ETH_ALEN);
+		build.sa_offs = offsetof(struct ieee80211_hdr, addr3);
+		build.hdr_len = 24;
+		break;
+	default:
+		/* not handled on fast-xmit */
+		return;
+	}
+
+	if (sta->sta.wme) {
+		build.hdr_len += 2;
+		fc |= cpu_to_le16(IEEE80211_STYPE_QOS_DATA);
+	}
+
+	build.key = rcu_access_pointer(sta->ptk[sta->ptk_idx]);
+	if (!build.key)
+		build.key = rcu_access_pointer(sdata->default_unicast_key);
+	if (build.key) {
+		bool gen_iv, iv_spc;
+
+		gen_iv = build.key->conf.flags & IEEE80211_KEY_FLAG_GENERATE_IV;
+		iv_spc = build.key->conf.flags & IEEE80211_KEY_FLAG_PUT_IV_SPACE;
+
+		/* don't handle software crypto */
+		if (!(build.key->flags & KEY_FLAG_UPLOADED_TO_HARDWARE))
+			return;
+
+		switch (build.key->conf.cipher) {
+		case WLAN_CIPHER_SUITE_CCMP:
+		case WLAN_CIPHER_SUITE_CCMP_256:
+			/* add fixed key ID */
+			if (gen_iv) {
+				(build.hdr + build.hdr_len)[3] =
+					0x20 | (build.key->conf.keyidx << 6);
+				build.pn_offs = build.hdr_len;
+			}
+			if (gen_iv || iv_spc)
+				build.hdr_len += IEEE80211_CCMP_HDR_LEN;
+			break;
+		case WLAN_CIPHER_SUITE_GCMP:
+		case WLAN_CIPHER_SUITE_GCMP_256:
+			/* add fixed key ID */
+			if (gen_iv) {
+				(build.hdr + build.hdr_len)[3] =
+					0x20 | (build.key->conf.keyidx << 6);
+				build.pn_offs = build.hdr_len;
+			}
+			if (gen_iv || iv_spc)
+				build.hdr_len += IEEE80211_GCMP_HDR_LEN;
+			break;
+		default:
+			/* don't do fast-xmit for these ciphers (yet) */
+			return;
+		}
+
+		fc |= cpu_to_le16(IEEE80211_FCTL_PROTECTED);
+	}
+
+	hdr->frame_control = fc;
+
+	memcpy(build.hdr + build.hdr_len,
+	       rfc1042_header,  sizeof(rfc1042_header));
+	build.hdr_len += sizeof(rfc1042_header);
+
+	fast_tx = kmemdup(&build, sizeof(build), gfp);
+	/* if the kmemdup fails, continue w/o fast_tx */
+	if (!fast_tx)
+		return;
+
+	spin_lock_bh(&sta->lock);
+	/* we might have raced against another call to this function */
+	old = rcu_dereference_protected(sta->fast_tx,
+					lockdep_is_held(&sta->lock));
+	rcu_assign_pointer(sta->fast_tx, fast_tx);
+	spin_unlock_bh(&sta->lock);
+	if (old)
+		kfree_rcu(old, rcu_head);
+}
+
+void ieee80211_check_fast_xmit_all(struct ieee80211_local *local)
+{
+	struct sta_info *sta;
+
+	rcu_read_lock();
+	list_for_each_entry_rcu(sta, &local->sta_list, list)
+		ieee80211_check_fast_xmit(sta, GFP_ATOMIC);
+	rcu_read_unlock();
+}
+
+void ieee80211_check_fast_xmit_iface(struct ieee80211_sub_if_data *sdata)
+{
+	struct ieee80211_local *local = sdata->local;
+	struct sta_info *sta;
+
+	rcu_read_lock();
+
+	list_for_each_entry_rcu(sta, &local->sta_list, list) {
+		if (sdata != sta->sdata &&
+		    (!sta->sdata->bss || sta->sdata->bss != sdata->bss))
+			continue;
+		ieee80211_check_fast_xmit(sta, GFP_ATOMIC);
+	}
+
+	rcu_read_unlock();
+}
+
+void ieee80211_clear_fast_xmit(struct sta_info *sta)
+{
+	struct ieee80211_fast_tx *fast_tx;
+
+	spin_lock_bh(&sta->lock);
+	fast_tx = rcu_dereference_protected(sta->fast_tx,
+					    lockdep_is_held(&sta->lock));
+	RCU_INIT_POINTER(sta->fast_tx, NULL);
+	spin_unlock_bh(&sta->lock);
+
+	if (fast_tx)
+		kfree_rcu(fast_tx, rcu_head);
+}
+
+static bool ieee80211_xmit_fast(struct ieee80211_sub_if_data *sdata,
+				struct net_device *dev, struct sta_info *sta,
+				struct ieee80211_fast_tx *fast_tx,
+				struct sk_buff *skb)
+{
+	struct ieee80211_local *local = sdata->local;
+	u16 ethertype = (skb->data[12] << 8) | skb->data[13];
+	int extra_head = fast_tx->hdr_len - (ETH_HLEN - 2);
+	int hw_headroom = sdata->local->hw.extra_tx_headroom;
+	struct ethhdr eth;
+	struct ieee80211_tx_info *info = IEEE80211_SKB_CB(skb);
+	struct ieee80211_hdr *hdr = (void *)fast_tx->hdr;
+	struct ieee80211_tx_data tx;
+	ieee80211_tx_result r;
+	struct tid_ampdu_tx *tid_tx = NULL;
+	u8 tid = IEEE80211_NUM_TIDS;
+
+	/* control port protocol needs a lot of special handling */
+	if (cpu_to_be16(ethertype) == sdata->control_port_protocol)
+		return false;
+
+	/* only RFC 1042 SNAP */
+	if (ethertype < ETH_P_802_3_MIN)
+		return false;
+
+	/* don't handle TX status request here either */
+	if (skb->sk && skb_shinfo(skb)->tx_flags & SKBTX_WIFI_STATUS)
+		return false;
+
+	if (hdr->frame_control & cpu_to_le16(IEEE80211_STYPE_QOS_DATA)) {
+		tid = skb->priority & IEEE80211_QOS_CTL_TAG1D_MASK;
+		tid_tx = rcu_dereference(sta->ampdu_mlme.tid_tx[tid]);
+		if (tid_tx &&
+		    !test_bit(HT_AGG_STATE_OPERATIONAL, &tid_tx->state))
+			return false;
+	}
+
+	/* after this point (skb is modified) we cannot return false */
+
+	if (skb_shared(skb)) {
+		struct sk_buff *tmp_skb = skb;
+
+		skb = skb_clone(skb, GFP_ATOMIC);
+		kfree_skb(tmp_skb);
+
+		if (!skb)
+			return true;
+	}
+
+	dev->stats.tx_packets++;
+	dev->stats.tx_bytes += skb->len + extra_head;
+	dev->trans_start = jiffies;
+
+	/* will not be crypto-handled beyond what we do here, so use false
+	 * as the may-encrypt argument for the resize to not account for
+	 * more room than we already have in 'extra_head'
+	 */
+	if (unlikely(ieee80211_skb_resize(sdata, skb,
+					  max_t(int, extra_head + hw_headroom -
+						     skb_headroom(skb), 0),
+					  false))) {
+		kfree_skb(skb);
+		return true;
+	}
+
+	memcpy(&eth, skb->data, ETH_HLEN - 2);
+	hdr = (void *)skb_push(skb, extra_head);
+	memcpy(skb->data, fast_tx->hdr, fast_tx->hdr_len);
+	memcpy(skb->data + fast_tx->da_offs, eth.h_dest, ETH_ALEN);
+	memcpy(skb->data + fast_tx->sa_offs, eth.h_source, ETH_ALEN);
+
+	memset(info, 0, sizeof(*info));
+	info->band = fast_tx->band;
+	info->control.vif = &sdata->vif;
+	info->flags = IEEE80211_TX_CTL_FIRST_FRAGMENT |
+		      IEEE80211_TX_CTL_DONTFRAG |
+		      (tid_tx ? IEEE80211_TX_CTL_AMPDU : 0);
+
+	if (hdr->frame_control & cpu_to_le16(IEEE80211_STYPE_QOS_DATA)) {
+		*ieee80211_get_qos_ctl(hdr) = tid;
+		hdr->seq_ctrl = ieee80211_tx_next_seq(sta, tid);
+	} else {
+		info->flags |= IEEE80211_TX_CTL_ASSIGN_SEQ;
+		hdr->seq_ctrl = cpu_to_le16(sdata->sequence_number);
+		sdata->sequence_number += 0x10;
+	}
+
+	sta->tx_msdu[tid]++;
+
+	info->hw_queue = sdata->vif.hw_queue[skb_get_queue_mapping(skb)];
+
+	__skb_queue_head_init(&tx.skbs);
+
+	tx.flags = IEEE80211_TX_UNICAST;
+	tx.local = local;
+	tx.sdata = sdata;
+	tx.sta = sta;
+	tx.key = fast_tx->key;
+
+	if (fast_tx->key)
+		info->control.hw_key = &fast_tx->key->conf;
+
+	if (!(local->hw.flags & IEEE80211_HW_HAS_RATE_CONTROL)) {
+		tx.skb = skb;
+		r = ieee80211_tx_h_rate_ctrl(&tx);
+		skb = tx.skb;
+		tx.skb = NULL;
+
+		if (r != TX_CONTINUE) {
+			if (r != TX_QUEUED)
+				kfree_skb(skb);
+			return true;
+		}
+	}
+
+	/* statistics normally done by ieee80211_tx_h_stats (but that
+	 * has to consider fragmentation, so is more complex)
+	 */
+	sta->tx_fragments++;
+	sta->tx_bytes[skb_get_queue_mapping(skb)] += skb->len;
+	sta->tx_packets[skb_get_queue_mapping(skb)]++;
+
+	if (fast_tx->pn_offs) {
+		u64 pn;
+		u8 *crypto_hdr = skb->data + fast_tx->pn_offs;
+
+		switch (fast_tx->key->conf.cipher) {
+		case WLAN_CIPHER_SUITE_CCMP:
+		case WLAN_CIPHER_SUITE_CCMP_256:
+			pn = atomic64_inc_return(&fast_tx->key->u.ccmp.tx_pn);
+			crypto_hdr[0] = pn;
+			crypto_hdr[1] = pn >> 8;
+			crypto_hdr[4] = pn >> 16;
+			crypto_hdr[5] = pn >> 24;
+			crypto_hdr[6] = pn >> 32;
+			crypto_hdr[7] = pn >> 40;
+			break;
+		case WLAN_CIPHER_SUITE_GCMP:
+		case WLAN_CIPHER_SUITE_GCMP_256:
+			pn = atomic64_inc_return(&fast_tx->key->u.gcmp.tx_pn);
+			crypto_hdr[0] = pn;
+			crypto_hdr[1] = pn >> 8;
+			crypto_hdr[4] = pn >> 16;
+			crypto_hdr[5] = pn >> 24;
+			crypto_hdr[6] = pn >> 32;
+			crypto_hdr[7] = pn >> 40;
+			break;
+		}
+	}
+
+	if (sdata->vif.type == NL80211_IFTYPE_AP_VLAN)
+		sdata = container_of(sdata->bss,
+				     struct ieee80211_sub_if_data, u.ap);
+
+	__skb_queue_tail(&tx.skbs, skb);
+	ieee80211_tx_frags(local, &sdata->vif, &sta->sta, &tx.skbs, false);
+	return true;
+}
+
 void __ieee80211_subif_start_xmit(struct sk_buff *skb,
 				  struct net_device *dev,
 				  u32 info_flags)
@@ -2406,6 +2798,16 @@ void __ieee80211_subif_start_xmit(struct sk_buff *skb,
 		goto out;
 	}
 
+	if (!IS_ERR_OR_NULL(sta)) {
+		struct ieee80211_fast_tx *fast_tx;
+
+		fast_tx = rcu_dereference(sta->fast_tx);
+
+		if (fast_tx &&
+		    ieee80211_xmit_fast(sdata, dev, sta, fast_tx, skb))
+			goto out;
+	}
+
 	skb = ieee80211_build_hdr(sdata, skb, info_flags, sta);
 	if (IS_ERR(skb))
 		goto out;
-- 
2.1.4

