Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=46.4.11.11
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793723049;
	b=yGKbMfX9YzIKv2OplIQer8QPC7Wsrtp12lxys0SQg98PLkqnHJlSg/9C9nAi2Jv5aRLQ
	 w9blAyeRQoyppMrPpaKShjA6bcQNcPOUveYLHy68f0h9qA2UrR6VlR4km17ISIQP6Plmr
	 ZLrMSEllL1Ni3NlWvVc0Rdci89UU0Fo734BsmOU5R/EAXk59Y/bF1n7KLniem8+MP7Zt/
	 T2/E8yAyhUKxh79i3wJRoxUUUXMymAXRdaYQYqyVu/6/e7H4UHhq4F698th+cBEAADCMM
	 pAmSU3/BnQZBLSn3bQYVffSYY4AB2BFsCm7vMffWoiIQiJuTiw6uoy5pyYzD2vqVpng==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793723049;
	h=DMARC-Filter:DKIM-Signature:Received:From:To:Cc:Subject:Date:
	 Message-ID:X-Mailer:In-Reply-To:References:MIME-Version:
	 Content-Transfer-Encoding;
	bh=N9xBl8BpLumfa7UGJt9vDnSouptyM900hqiSNgHnyHo=;
	b=k9rWHl8jLH+MWZp9poEmCmMRsW6ndINWMuDuMh+dRfrcGUOiqxyZ/SPMGFLLLyWqBrbJ
	 d2Ci1Hl7xfAOCiV8r6i5EYNhnSJNHzap+eWtMYDXK/WfDUqk1unEKfGbhgbstZBOGt3g3
	 gMjAHWMXKnTAgAoATjFAo2KWd2UwdDBFMOkxJWp8pnp35iVsJ2YO9RtnEPuC/Lfq/T34C
	 YFIDFNKS1WGI2yF9bqjfVlTFIZiguSSPEiJTHHOhZyHoA3k+N1YB/ui5wxxVlDG+O2eX+
	 qAc57gzhc7D7W+E9J8bqEPudDFVzq8eGSUwAAC8OUZbFR5Q/3eE3whZxH+s7x9BLrzw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=nbd.name;
	spf=pass smtp.mailfrom=nbd.name;
	dkim=pass header.d=nbd.name header.i=@nbd.name header.a=rsa-sha256 header.s=20160729 header.b=e9wuGX75;
	arc=none smtp.remote-ip=46.4.11.11
Received: from nbd.name (nbd.name [46.4.11.11])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange ECDHE (prime256v1) server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 53B16606D81A
	for <linux-wireless@vger.kernel.org>; Tue,  3 Nov 2026 16:24:08 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 53B16606D81A
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=nbd.name
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=nbd.name
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=nbd.name header.i=@nbd.name header.a=rsa-sha256 header.s=20160729 header.b=e9wuGX75
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=nbd.name;
	s=20160729; h=Content-Transfer-Encoding:MIME-Version:References:In-Reply-To:
	Message-ID:Date:Subject:Cc:To:From:Sender:Reply-To:Content-Type:Content-ID:
	Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
	:Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
	List-Post:List-Owner:List-Archive;
	bh=N9xBl8BpLumfa7UGJt9vDnSouptyM900hqiSNgHnyHo=; b=e9wuGX752HLewKmrbD+Lbm7JS3
	+4WSKbxUhYxSwSb7RzyT7cPCpoAfCYVR4frliUHWqAN3qpLnjyaTRO0erHPjJXG57yz7R2rfpJ7q8
	QRkaTxInPXt58ka2OZu205ACi/SeYSTqjtukLFsoorc1bRLZ4Qc3PyOWdErI9ghlZlgM=;
Received: from p200300cadf12920000000000000005bb.dip0.t-ipconnect.de ([2003:ca:df12:9200::5bb] helo=localhost.localdomain)
	by ds12 with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
	(Exim 4.96)
	(envelope-from <nbd@nbd.name>)
	id 1xOHIn-00FDFp-0b;
	Tue, 03 Nov 2026 17:24:01 +0100
From: Felix Fietkau <nbd@nbd.name>
To: linux-wireless@vger.kernel.org
Cc: johannes@sipsolutions.net
Subject: [PATCH wireless-next 12/18] wifi: mac80211: learn and apply MSCS flows
Date: Tue,  3 Nov 2026 17:23:45 +0100
Message-ID: <0f7fa2c185d2d9a1f1534c5b943efda83858edae.1793722802.git-series.nbd@nbd.name>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <cover.118d7c7b799f8ed35de51dc2aefef460bf69727b.1793722802.git-series.nbd@nbd.name>
References: <cover.118d7c7b799f8ed35de51dc2aefef460bf69727b.1793722802.git-series.nbd@nbd.name>
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Post: <mailto:linux-wireless@vger.kernel.org>
List-Help: <mailto:linux-wireless+help@vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-wireless+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

An AP with an MSCS mirrors the uplink priority of a flow onto its
downlink. Record the priority of individually addressed frames from
the station, for the user priorities that its request selected, on
both the regular and the 802.3 decapsulated receive path. On the
latter, the priority comes from the driver, so a driver that advertises
MSCS has to set it.

On transmit, look up the learned priority of an MSDU that no SCS
descriptor matched, and cap it with the User Priority Limit of the
request. SCS runs first, so an MSDU of an SCS stream keeps the priority
of that stream.

An MSCS with a client learns from uplink MSDUs whose source address is
its client, and applies to downlink MSDUs whose destination address is
its client. An MSCS without a client does the same for the address of
the station.

A learned priority is only valid for the stream timeout of the
request, so an entry that saw no frame for that long is dropped.

Signed-off-by: Felix Fietkau <nbd@nbd.name>
---
 include/net/mac80211.h     |   3 +-
 net/mac80211/ieee80211_i.h |   8 +-
 net/mac80211/iface.c       |  11 +-
 net/mac80211/rx.c          |   5 +-
 net/mac80211/scs.c         | 368 +++++++++++++++++++++++++++++++++++++-
 net/mac80211/sta_info.h    |  43 ++++-
 6 files changed, 429 insertions(+), 9 deletions(-)

diff --git a/include/net/mac80211.h b/include/net/mac80211.h
index dfdd85ef3ab7..0f1969c48646 100644
--- a/include/net/mac80211.h
+++ b/include/net/mac80211.h
@@ -1650,7 +1650,8 @@ ieee80211_tx_info_clear_status(struct ieee80211_tx_info *info)
  *	in &struct ieee80211_rx_status.  Note that if this value isn't
  *	known the frame shouldn't be reported.
  * @RX_FLAG_8023: the frame has an 802.3 header (decap offload performed by
- *	hardware or driver)
+ *	hardware or driver). With %NL80211_EXT_FEATURE_MSCS, the driver sets
+ *	skb->priority to the TID of a QoS Data frame.
  * @RX_FLAG_RADIOTAP_VHT: VHT radiotap data is present
  */
 enum mac80211_rx_flags {
diff --git a/net/mac80211/ieee80211_i.h b/net/mac80211/ieee80211_i.h
index 51777a0c3d51..c52dcf2a28ba 100644
--- a/net/mac80211/ieee80211_i.h
+++ b/net/mac80211/ieee80211_i.h
@@ -356,6 +356,11 @@ struct ieee80211_if_ap {
 
 	bool multicast_to_unicast;
 	bool active;
+
+	/* learned MSCS entries of every station of this BSS, and its VLANs */
+	struct rhashtable flow_tbl;
+	struct wiphy_delayed_work flow_gc_work;
+	atomic_t flow_gc_kick;
 };
 
 struct ieee80211_if_vlan {
@@ -2267,6 +2272,9 @@ int ieee80211_set_mscs(struct wiphy *wiphy, struct net_device *dev,
 		       const u8 *peer, struct cfg80211_mscs_desc *desc);
 void ieee80211_sta_scs_free(struct sta_info *sta);
 bool ieee80211_flow_classify(struct sta_info *sta, struct sk_buff *skb);
+void ieee80211_flow_learn(struct ieee80211_rx_data *rx);
+int ieee80211_flow_tbl_init(struct ieee80211_sub_if_data *sdata);
+void ieee80211_flow_tbl_destroy(struct ieee80211_sub_if_data *sdata);
 
 /* link handling */
 void ieee80211_link_setup(struct ieee80211_link_data *link);
diff --git a/net/mac80211/iface.c b/net/mac80211/iface.c
index 8bfd6bc9c9fe..16e883ca0a8c 100644
--- a/net/mac80211/iface.c
+++ b/net/mac80211/iface.c
@@ -542,6 +542,8 @@ static void ieee80211_do_stop(struct ieee80211_sub_if_data *sdata, bool going_do
 		atomic_dec(&local->iff_allmultis);
 
 	if (sdata->vif.type == NL80211_IFTYPE_AP) {
+		ieee80211_flow_tbl_destroy(sdata);
+
 		local->fif_pspoll--;
 		local->fif_probe_req--;
 	} else if (sdata->vif.type == NL80211_IFTYPE_ADHOC) {
@@ -1434,6 +1436,10 @@ int ieee80211_do_open(struct wireless_dev *wdev, bool coming_up)
 		break;
 		}
 	case NL80211_IFTYPE_AP:
+		res = ieee80211_flow_tbl_init(sdata);
+		if (res)
+			return res;
+		break;
 	case NL80211_IFTYPE_MESH_POINT:
 	case NL80211_IFTYPE_STATION:
 	case NL80211_IFTYPE_MONITOR:
@@ -1468,7 +1474,7 @@ int ieee80211_do_open(struct wireless_dev *wdev, bool coming_up)
 			 * no need to worry about AP_VLAN/NAN_DATA cleanup since
 			 * in that case we can't have open_count == 0
 			 */
-			return res;
+			goto err_flow_tbl;
 		}
 		ieee80211_led_radio(local, true);
 		ieee80211_mod_tpt_led_trig(local,
@@ -1644,6 +1650,9 @@ int ieee80211_do_open(struct wireless_dev *wdev, bool coming_up)
 		list_del(&sdata->u.vlan.list);
 	/* Might not be initialized yet, but it is harmless */
 	sdata->bss = NULL;
+ err_flow_tbl:
+	if (sdata->vif.type == NL80211_IFTYPE_AP)
+		ieee80211_flow_tbl_destroy(sdata);
 	return res;
 }
 
diff --git a/net/mac80211/rx.c b/net/mac80211/rx.c
index ee1f33178d26..86a4f73f2b8f 100644
--- a/net/mac80211/rx.c
+++ b/net/mac80211/rx.c
@@ -2769,6 +2769,9 @@ ieee80211_deliver_skb(struct ieee80211_rx_data *rx)
 		u64_stats_update_end(&rx->link_sta->rx_stats.syncp);
 	}
 
+	if (rx->sta)
+		ieee80211_flow_learn(rx);
+
 	if ((sdata->vif.type == NL80211_IFTYPE_AP ||
 	     sdata->vif.type == NL80211_IFTYPE_AP_VLAN) &&
 	    !(sdata->flags & IEEE80211_SDATA_DONT_BRIDGE_PACKETS) &&
@@ -4982,6 +4985,8 @@ static void ieee80211_rx_8023(struct ieee80211_rx_data *rx,
 	u64_stats_add(&stats->bytes, orig_len);
 	u64_stats_update_end(&stats->syncp);
 
+	ieee80211_flow_learn(rx);
+
 	if (fast_rx->internal_forward) {
 		struct sk_buff *xmit_skb = NULL;
 		if (is_multicast_ether_addr(da)) {
diff --git a/net/mac80211/scs.c b/net/mac80211/scs.c
index acbea95b97f6..13560cdf5dd8 100644
--- a/net/mac80211/scs.c
+++ b/net/mac80211/scs.c
@@ -13,6 +13,19 @@
 #define IEEE80211_MSCS_TIMEOUT_MAX_TU	3515625
 
 #define IEEE80211_MSCS_MAX		16
+#define IEEE80211_MSCS_ENTRIES_MAX	64
+
+/* The hashed bytes must hold no padding between the MSCS and the key */
+static_assert(offsetofend(struct ieee80211_flow_hkey, key) ==
+	      sizeof(struct ieee80211_mscs_sta *) +
+	      sizeof(struct cfg80211_flow_key));
+
+static const struct rhashtable_params flow_rht_params = {
+	.head_offset = offsetof(struct ieee80211_flow_entry, node),
+	.key_offset = offsetof(struct ieee80211_flow_entry, hkey),
+	.key_len = offsetofend(struct ieee80211_flow_hkey, key),
+	.automatic_shrinking = true,
+};
 
 static size_t ieee80211_scs_rule_size(const struct cfg80211_scs_desc *desc)
 {
@@ -99,6 +112,60 @@ static void ieee80211_scs_sta_fill(struct ieee80211_scs_sta *scs,
 	}
 }
 
+static bool ieee80211_mscs_lookup(struct sta_info *sta,
+				  struct ieee80211_mscs_sta *mscs,
+				  const struct cfg80211_flow_info *info,
+				  struct cfg80211_scs_verdict *verdict)
+{
+	struct ieee80211_flow_entry *entry;
+	struct ieee80211_flow_hkey hkey;
+
+	if (!(info->present & BIT(CFG80211_FLOW_F_ETH_DA)))
+		return false;
+
+	if (!ether_addr_equal(info->key.da, mscs->client))
+		return false;
+
+	hkey.mscs = mscs;
+	if (!cfg80211_flow_key_build(info, mscs->layout, CFG80211_FLOW_AS_IS,
+				     &hkey.key))
+		return false;
+
+	entry = rhashtable_lookup(&sta->sdata->bss->flow_tbl, &hkey,
+				  flow_rht_params);
+	if (!entry)
+		return false;
+
+	verdict->up = min_t(u8, READ_ONCE(entry->up), mscs->up_limit);
+	verdict->match = true;
+
+	return true;
+}
+
+static bool ieee80211_flow_lookup(struct sta_info *sta,
+				  const struct cfg80211_flow_info *info,
+				  struct cfg80211_scs_verdict *verdict)
+{
+	struct ieee80211_mscs_sta *mscs;
+	struct ieee80211_scs_sta *scs;
+
+	memset(verdict, 0, sizeof(*verdict));
+
+	scs = rcu_dereference(sta->scs);
+	if (scs) {
+		cfg80211_scs_evaluate(scs->rule, scs->n_rules, info, verdict);
+		if (verdict->match)
+			return true;
+	}
+
+	/* An SCS match takes precedence over the MSCS */
+	list_for_each_entry_rcu(mscs, &sta->mscs, list)
+		if (ieee80211_mscs_lookup(sta, mscs, info, verdict))
+			return true;
+
+	return false;
+}
+
 /**
  * ieee80211_flow_classify - give an MSDU the user priority of its stream
  *
@@ -112,17 +179,14 @@ bool ieee80211_flow_classify(struct sta_info *sta, struct sk_buff *skb)
 {
 	struct cfg80211_scs_verdict verdict;
 	struct cfg80211_flow_info info;
-	struct ieee80211_scs_sta *scs;
 
-	scs = rcu_dereference(sta->scs);
-	if (!scs)
+	if (!rcu_access_pointer(sta->scs) && list_empty(&sta->mscs))
 		return false;
 
 	if (!cfg80211_flow_parse(skb, &info))
 		return false;
 
-	cfg80211_scs_evaluate(scs->rule, scs->n_rules, &info, &verdict);
-	if (!verdict.match)
+	if (!ieee80211_flow_lookup(sta, &info, &verdict))
 		return false;
 
 	skb->priority = verdict.up;
@@ -130,6 +194,276 @@ bool ieee80211_flow_classify(struct sta_info *sta, struct sk_buff *skb)
 	return true;
 }
 
+static void ieee80211_flow_entry_free(struct ieee80211_if_ap *ap,
+				      struct ieee80211_flow_entry *entry)
+{
+	rhashtable_remove_fast(&ap->flow_tbl, &entry->node, flow_rht_params);
+	list_del(&entry->list);
+	kfree_rcu(entry, rcu_head);
+}
+
+/* The caller holds @mscs->lock unless nothing else can reach the list */
+static void ieee80211_flow_purge(struct ieee80211_if_ap *ap,
+				 struct ieee80211_mscs_sta *mscs)
+{
+	struct ieee80211_flow_entry *entry, *tmp;
+
+	list_for_each_entry_safe(entry, tmp, &mscs->entries, list)
+		ieee80211_flow_entry_free(ap, entry);
+
+	mscs->n_entries = 0;
+}
+
+static struct ieee80211_flow_entry *
+ieee80211_flow_expired_find(struct ieee80211_mscs_sta *mscs)
+{
+	struct ieee80211_flow_entry *entry;
+
+	lockdep_assert_held(&mscs->lock);
+
+	list_for_each_entry(entry, &mscs->entries, list)
+		if (time_after_eq(jiffies, READ_ONCE(entry->last_update) +
+					   mscs->timeout))
+			return entry;
+
+	return NULL;
+}
+
+/* Return the time until the next entry expires, zero when none is left */
+static unsigned long ieee80211_flow_gc_mscs(struct ieee80211_sub_if_data *sdata,
+					    struct ieee80211_mscs_sta *mscs)
+{
+	struct ieee80211_flow_entry *entry;
+	unsigned long delay = 0;
+	unsigned long now;
+
+	/*
+	 * Entries are freed only by this work and by an MSCS change, both under
+	 * the wiphy lock, so @entry stays valid outside the spinlock.
+	 */
+	while (true) {
+		spin_lock_bh(&mscs->lock);
+		entry = ieee80211_flow_expired_find(mscs);
+		spin_unlock_bh(&mscs->lock);
+		if (!entry)
+			break;
+
+		spin_lock_bh(&mscs->lock);
+		ieee80211_flow_entry_free(&sdata->u.ap, entry);
+		mscs->n_entries--;
+		spin_unlock_bh(&mscs->lock);
+	}
+
+	spin_lock_bh(&mscs->lock);
+
+	now = jiffies;
+	list_for_each_entry(entry, &mscs->entries, list) {
+		unsigned long dead = READ_ONCE(entry->last_update) +
+				     mscs->timeout;
+		unsigned long left = time_after(dead, now) ? dead - now : 1;
+
+		if (!delay || left < delay)
+			delay = left;
+	}
+
+	spin_unlock_bh(&mscs->lock);
+
+	return delay;
+}
+
+static unsigned long ieee80211_flow_gc_sta(struct ieee80211_sub_if_data *sdata,
+					   struct sta_info *sta)
+{
+	struct ieee80211_mscs_sta *mscs;
+	unsigned long delay = 0;
+
+	lockdep_assert_wiphy(sdata->local->hw.wiphy);
+
+	list_for_each_entry(mscs, &sta->mscs, list) {
+		unsigned long mscs_delay = ieee80211_flow_gc_mscs(sdata, mscs);
+
+		if (mscs_delay && (!delay || mscs_delay < delay))
+			delay = mscs_delay;
+	}
+
+	return delay;
+}
+
+static void ieee80211_flow_gc_work(struct wiphy *wiphy, struct wiphy_work *work)
+{
+	struct ieee80211_sub_if_data *sdata;
+	struct ieee80211_if_ap *ap;
+	unsigned long delay = 0;
+	struct sta_info *sta;
+	int kick;
+
+	ap = container_of(work, struct ieee80211_if_ap, flow_gc_work.work);
+	sdata = container_of(ap, struct ieee80211_sub_if_data, u.ap);
+	kick = atomic_read(&ap->flow_gc_kick);
+
+	list_for_each_entry(sta, &sdata->local->sta_list, list) {
+		unsigned long sta_delay;
+
+		if (sta->sdata->bss != ap)
+			continue;
+
+		sta_delay = ieee80211_flow_gc_sta(sdata, sta);
+		if (sta_delay && (!delay || sta_delay < delay))
+			delay = sta_delay;
+	}
+
+	if (delay)
+		wiphy_delayed_work_queue(wiphy, &ap->flow_gc_work, delay);
+
+	/* The requeue can replace the kick of an insert during the walk */
+	smp_mb();
+	if (atomic_read(&ap->flow_gc_kick) != kick)
+		wiphy_delayed_work_queue(wiphy, &ap->flow_gc_work, 1);
+}
+
+int ieee80211_flow_tbl_init(struct ieee80211_sub_if_data *sdata)
+{
+	wiphy_delayed_work_init(&sdata->u.ap.flow_gc_work,
+				ieee80211_flow_gc_work);
+
+	return rhashtable_init(&sdata->u.ap.flow_tbl, &flow_rht_params);
+}
+
+static void ieee80211_flow_tbl_free(void *ptr, void *arg)
+{
+	struct ieee80211_flow_entry *entry = ptr;
+
+	kfree(entry);
+}
+
+void ieee80211_flow_tbl_destroy(struct ieee80211_sub_if_data *sdata)
+{
+	wiphy_delayed_work_cancel(sdata->local->hw.wiphy,
+				  &sdata->u.ap.flow_gc_work);
+	rhashtable_free_and_destroy(&sdata->u.ap.flow_tbl,
+				    ieee80211_flow_tbl_free, NULL);
+}
+
+static void ieee80211_flow_insert(struct ieee80211_sub_if_data *sdata,
+				  struct ieee80211_mscs_sta *mscs,
+				  const struct ieee80211_flow_hkey *hkey, u8 up)
+{
+	struct ieee80211_flow_entry *entry, *other;
+	bool first;
+
+	entry = kzalloc_obj(*entry, GFP_ATOMIC);
+	if (!entry)
+		return;
+
+	entry->hkey.mscs = hkey->mscs;
+	entry->hkey.key = hkey->key;
+	entry->up = up;
+	entry->last_update = jiffies;
+
+	spin_lock_bh(&mscs->lock);
+
+	/* The MSCS may have been changed or removed, which emptied this list */
+	if (mscs->removed)
+		goto drop;
+
+	if (mscs->n_entries >= IEEE80211_MSCS_ENTRIES_MAX)
+		goto drop;
+
+	other = rhashtable_lookup_get_insert_fast(&sdata->bss->flow_tbl,
+						  &entry->node,
+						  flow_rht_params);
+	if (other) {
+		/* Concurrent insert of the same key, the last writer wins */
+		if (!IS_ERR(other)) {
+			WRITE_ONCE(other->up, up);
+			WRITE_ONCE(other->last_update, jiffies);
+		}
+
+		goto drop;
+	}
+
+	list_add_tail(&entry->list, &mscs->entries);
+	first = mscs->n_entries++ == 0;
+	spin_unlock_bh(&mscs->lock);
+
+	/* The work requeues itself while entries remain */
+	if (first) {
+		atomic_inc(&sdata->bss->flow_gc_kick);
+		/* Pairs with the smp_mb() at the end of the collection */
+		smp_mb__after_atomic();
+		wiphy_delayed_work_queue(sdata->local->hw.wiphy,
+					 &sdata->bss->flow_gc_work, 1);
+	}
+
+	return;
+
+drop:
+	spin_unlock_bh(&mscs->lock);
+	kfree(entry);
+}
+
+static void ieee80211_flow_learn_mscs(struct ieee80211_sub_if_data *sdata,
+				      struct ieee80211_mscs_sta *mscs,
+				      const struct cfg80211_flow_info *info,
+				      u8 up)
+{
+	struct ieee80211_flow_entry *entry;
+	struct ieee80211_flow_hkey hkey;
+
+	hkey.mscs = mscs;
+	if (!cfg80211_flow_key_build(info, mscs->layout,
+				     CFG80211_FLOW_MIRRORED, &hkey.key))
+		return;
+
+	entry = rhashtable_lookup(&sdata->bss->flow_tbl, &hkey,
+				  flow_rht_params);
+	if (entry) {
+		WRITE_ONCE(entry->up, up);
+		WRITE_ONCE(entry->last_update, jiffies);
+		return;
+	}
+
+	ieee80211_flow_insert(sdata, mscs, &hkey, up);
+}
+
+/**
+ * ieee80211_flow_learn - record the user priority of an uplink flow
+ *
+ * @rx: the received frame, in IEEE 802.3 format
+ *
+ * Every MSCS of the source address learns the frame. The key is built for
+ * the downlink direction, so that the transmit path can look it up as is.
+ */
+void ieee80211_flow_learn(struct ieee80211_rx_data *rx)
+{
+	struct ieee80211_sub_if_data *sdata = rx->sdata;
+	const struct ethhdr *eth = (void *)rx->skb->data;
+	struct ieee80211_mscs_sta *mscs;
+	struct cfg80211_flow_info info;
+	/* The TID from ieee80211_parse_qos(), or from a decap offload driver */
+	u32 up = rx->skb->priority;
+	bool parsed = false;
+
+	if (sdata->vif.type != NL80211_IFTYPE_AP &&
+	    sdata->vif.type != NL80211_IFTYPE_AP_VLAN)
+		return;
+
+	if (up > 7 || is_multicast_ether_addr(eth->h_dest))
+		return;
+
+	list_for_each_entry_rcu(mscs, &rx->sta->mscs, list) {
+		if (!(mscs->up_bitmap & BIT(up)) ||
+		    !ether_addr_equal(eth->h_source, mscs->client))
+			continue;
+
+		if (!parsed && !cfg80211_flow_parse(rx->skb, &info))
+			return;
+
+		parsed = true;
+		ieee80211_flow_learn_mscs(sdata, mscs, &info, up);
+	}
+}
+
 int ieee80211_set_scs(struct wiphy *wiphy, struct net_device *dev,
 		      const u8 *peer, struct cfg80211_scs_desc * const *desc,
 		      u16 *status, u8 n_desc)
@@ -223,6 +557,18 @@ ieee80211_mscs_find(struct sta_info *sta, const u8 *client, bool configured)
 	return NULL;
 }
 
+/* The caller took @mscs off the list of the station */
+static void ieee80211_mscs_free(struct ieee80211_if_ap *ap,
+				struct ieee80211_mscs_sta *mscs)
+{
+	spin_lock_bh(&mscs->lock);
+	mscs->removed = true;
+	ieee80211_flow_purge(ap, mscs);
+	spin_unlock_bh(&mscs->lock);
+
+	kfree_rcu(mscs, rcu_head);
+}
+
 int ieee80211_set_mscs(struct wiphy *wiphy, struct net_device *dev,
 		       const u8 *peer, struct cfg80211_mscs_desc *desc)
 {
@@ -234,6 +580,10 @@ int ieee80211_set_mscs(struct wiphy *wiphy, struct net_device *dev,
 
 	lockdep_assert_wiphy(wiphy);
 
+	/* Only an AP provides MSCS */
+	if (!sdata->bss)
+		return -EOPNOTSUPP;
+
 	sta = sta_info_get_bss(sdata, peer);
 	if (!sta)
 		return -ENOENT;
@@ -247,7 +597,7 @@ int ieee80211_set_mscs(struct wiphy *wiphy, struct net_device *dev,
 
 		list_del_rcu(&old->list);
 		sta->n_mscs--;
-		kfree_rcu(old, rcu_head);
+		ieee80211_mscs_free(sta->sdata->bss, old);
 
 		return 0;
 	}
@@ -273,9 +623,12 @@ int ieee80211_set_mscs(struct wiphy *wiphy, struct net_device *dev,
 	tu = min(desc->stream_timeout, IEEE80211_MSCS_TIMEOUT_MAX_TU);
 	mscs->timeout = max(1UL, usecs_to_jiffies(tu * 1024));
 
+	spin_lock_init(&mscs->lock);
+	INIT_LIST_HEAD(&mscs->entries);
+
 	if (old) {
 		list_replace_rcu(&old->list, &mscs->list);
-		kfree_rcu(old, rcu_head);
+		ieee80211_mscs_free(sta->sdata->bss, old);
 	} else {
 		/* The station's own requests take precedence (EasyMesh 20.2.5) */
 		if (mscs->configured)
@@ -301,6 +654,7 @@ void ieee80211_sta_scs_free(struct sta_info *sta)
 
 	list_for_each_entry_safe(mscs, tmp, &sta->mscs, list) {
 		list_del(&mscs->list);
+		ieee80211_flow_purge(sta->sdata->bss, mscs);
 		kfree(mscs);
 	}
 }
diff --git a/net/mac80211/sta_info.h b/net/mac80211/sta_info.h
index b9ff5e117115..50af2f7a024f 100644
--- a/net/mac80211/sta_info.h
+++ b/net/mac80211/sta_info.h
@@ -661,20 +661,63 @@ struct ieee80211_scs_sta {
  *	unless the MSCS names a host behind a 4-address station
  * @configured: the AP configured the MSCS on behalf of the network, not at
  *	the request of the station
+ * @removed: the MSCS left &sta_info.mscs, so no entry may be added
  * @layout: classifier parameters, a bitmap of &enum cfg80211_flow_field
  * @up_bitmap: user priorities that the AP learns from, one bit each
  * @up_limit: ceiling for the assigned user priority
  * @timeout: minimum lifetime of a learned value, in jiffies
+ * @lock: protects @removed, @entries and @n_entries
+ * @entries: the learned entries of this MSCS, for expiry and teardown
+ * @n_entries: number of entries in @entries
  */
 struct ieee80211_mscs_sta {
 	struct list_head list;
 	struct rcu_head rcu_head;
 	u8 client[ETH_ALEN];
 	bool configured;
+	bool removed;
 	u32 layout;
 	u8 up_bitmap;
 	u8 up_limit;
 	unsigned long timeout;
+
+	spinlock_t lock; /* protects @removed, @entries and @n_entries */
+	struct list_head entries;
+	u32 n_entries;
+};
+
+/**
+ * struct ieee80211_flow_hkey - what a learned entry is looked up by
+ *
+ * @mscs: the MSCS that learned it, so that a flow of one station or client
+ *	never answers for another
+ * @key: the masked tuple, in the downlink direction
+ *
+ * Not packed: the whole of it is compared, but a packed aggregate would force
+ * byte-wise access to @mscs.
+ */
+struct ieee80211_flow_hkey {
+	struct ieee80211_mscs_sta *mscs;
+	struct cfg80211_flow_key key;
+};
+
+/**
+ * struct ieee80211_flow_entry - the user priority learned for one flow
+ *
+ * @hkey: what it is looked up by
+ * @node: hash table linkage
+ * @list: linkage in &ieee80211_mscs_sta.entries
+ * @last_update: jiffies of the last uplink frame of this flow
+ * @up: the learned user priority
+ * @rcu_head: for freeing
+ */
+struct ieee80211_flow_entry {
+	struct ieee80211_flow_hkey hkey;
+	struct rhash_head node;
+	struct list_head list;
+	unsigned long last_update;
+	u8 up;
+	struct rcu_head rcu_head;
 };
 
 /**
-- 
git-series 0.9.1
