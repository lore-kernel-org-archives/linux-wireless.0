Received: from nbd.name (nbd.name [46.4.11.11])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AF9B65275AA
	for <linux-wireless@vger.kernel.org>; Tue, 22 Sep 2026 10:13:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=46.4.11.11
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790072035; cv=none; b=B4jgYA2v2swz0gRtD/HA3e6nPRbuoOYVrD6/v6zNn42kgelnjVp5hu0ks36tt45xfAZ4Nb7zL4FRrQIrCvvOmzi+trZx/lbT0idk+Td3NMUf1HeBWyMZxTLIl5LQy3c7wN2Vc+fPNF49SFi8ajHd9Jd7aBrntglZPquteJIXUm8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790072035; c=relaxed/simple;
	bh=wtDnofHN5+YH0hbuHkXBqIKOiToJbqWAOpMC+zulZ3E=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=lk+XirJs8c/PB2HanaESilu2lIofNW+9vtR4PmR9eU6azOfgCXQayzmwBCjRm6BpEYDFkoK6OratKt5DfEm4+ThgOzXnt8JbHcVY4CdKF53Nu6fyDQLkii9ypOJFkBMuF/Wu36AVZVhwTxB0Pst5CMLVFeqFftnQNgLeIGNpPwY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=nbd.name; spf=pass smtp.mailfrom=nbd.name; dkim=pass (1024-bit key) header.d=nbd.name header.i=@nbd.name header.b=EcED2+9h; arc=none smtp.client-ip=46.4.11.11
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=nbd.name
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=nbd.name
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=nbd.name header.i=@nbd.name header.b="EcED2+9h"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=nbd.name;
	s=20160729; h=Content-Transfer-Encoding:MIME-Version:References:In-Reply-To:
	Message-ID:Date:Subject:Cc:To:From:Sender:Reply-To:Content-Type:Content-ID:
	Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
	:Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
	List-Post:List-Owner:List-Archive;
	bh=Mtl4FcOzh+nEzaH651DTq6nwYNNYR9lQKw/C6pHJAxg=; b=EcED2+9hpHi1fW2TCZ1hLlaIDG
	vMTo/JjC+OQ1F6Pq293qlAELW93tmBNVWashtsX7k4YWMUTZHxyw9piebDf5HwUotguVEXhZuSWrG
	fHAEzIjlCVtNAPVaPeDTvQZdKnh4lE65/8h35xROp8A1es9fLAnaXEpOIBYKlLMo06Rw=;
Received: from p200300cadf12010000000000000005bb.dip0.t-ipconnect.de ([2003:ca:df12:100::5bb] helo=localhost.localdomain)
	by ds12 with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
	(Exim 4.96)
	(envelope-from <nbd@nbd.name>)
	id 1x8xVV-00807z-0B;
	Tue, 22 Sep 2026 12:13:49 +0200
From: Felix Fietkau <nbd@nbd.name>
To: linux-wireless@vger.kernel.org
Cc: johannes@sipsolutions.net,
	vivek.chettri@oss.qualcomm.com,
	bhagavathi.pillai@oss.qualcomm.com,
	ripan.deuri@oss.qualcomm.com
Subject: [RFC PATCH v2 11/16] wifi: mac80211: learn MSCS flows on receive
Date: Tue, 22 Sep 2026 12:13:38 +0200
Message-ID: <14dc90c0cf1f6b932937adac2c18fd2b8a15cc33.1790071773.git-series.nbd@nbd.name>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <cover.5f82cb9d25f8f1b63e1994e64a6e9dac538e0ac8.1790071773.git-series.nbd@nbd.name>
References: <cover.5f82cb9d25f8f1b63e1994e64a6e9dac538e0ac8.1790071773.git-series.nbd@nbd.name>
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

An AP with an MSCS mirrors the uplink priority of a flow onto its
downlink. Record the priority of individually addressed frames from
the station, for the user priorities that its request selected, on
both the regular and the 802.3 decapsulated receive path.

The key is built for the reverse direction at learn time, so that the
transmit path can look it up as is. Entries live in one rhashtable per
AP BSS, keyed by the station and the tuple, so that a flow of one
station never matches another one. A per station list holds the
entries for teardown and expiry.

A learned priority is only valid for the stream timeout of the
request, so a delayed work drops idle entries and reschedules itself
for the next expiry. Installing a new MSCS purges the old entries,
because their keys were built with the old classifier layout.

The number of learned entries is limited to 64 per station.

Signed-off-by: Felix Fietkau <nbd@nbd.name>
---
 net/mac80211/ieee80211_i.h |   7 +-
 net/mac80211/iface.c       |  11 +-
 net/mac80211/rx.c          |   5 +-
 net/mac80211/scs.c         | 242 +++++++++++++++++++++++++++++++++++++-
 net/mac80211/sta_info.h    |  40 ++++++-
 5 files changed, 303 insertions(+), 2 deletions(-)

diff --git a/net/mac80211/ieee80211_i.h b/net/mac80211/ieee80211_i.h
index 47d703688478..569c8ad314b4 100644
--- a/net/mac80211/ieee80211_i.h
+++ b/net/mac80211/ieee80211_i.h
@@ -345,6 +345,10 @@ struct ieee80211_if_ap {
 
 	bool multicast_to_unicast;
 	bool active;
+
+	/* learned MSCS entries of every station of this BSS, and its VLANs */
+	struct rhashtable flow_tbl;
+	struct wiphy_delayed_work flow_gc_work;
 };
 
 struct ieee80211_if_vlan {
@@ -2222,6 +2226,9 @@ int ieee80211_set_mscs(struct wiphy *wiphy, struct net_device *dev,
 		       const u8 *peer, struct cfg80211_mscs_desc *desc);
 void ieee80211_sta_scs_free(struct sta_info *sta);
 bool ieee80211_flow_classify(struct sta_info *sta, struct sk_buff *skb);
+void ieee80211_flow_learn(struct ieee80211_rx_data *rx);
+int ieee80211_flow_tbl_init(struct ieee80211_sub_if_data *sdata);
+void ieee80211_flow_tbl_destroy(struct ieee80211_sub_if_data *sdata);
 
 /* link handling */
 void ieee80211_link_setup(struct ieee80211_link_data *link);
diff --git a/net/mac80211/iface.c b/net/mac80211/iface.c
index 8535dd478633..7e1f97e1bfcd 100644
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
@@ -1435,6 +1437,10 @@ int ieee80211_do_open(struct wireless_dev *wdev, bool coming_up)
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
@@ -1469,7 +1475,7 @@ int ieee80211_do_open(struct wireless_dev *wdev, bool coming_up)
 			 * no need to worry about AP_VLAN/NAN_DATA cleanup since
 			 * in that case we can't have open_count == 0
 			 */
-			return res;
+			goto err_flow_tbl;
 		}
 		ieee80211_led_radio(local, true);
 		ieee80211_mod_tpt_led_trig(local,
@@ -1645,6 +1651,9 @@ int ieee80211_do_open(struct wireless_dev *wdev, bool coming_up)
 		list_del(&sdata->u.vlan.list);
 	/* Might not be initialized yet, but it is harmless */
 	sdata->bss = NULL;
+ err_flow_tbl:
+	if (sdata->vif.type == NL80211_IFTYPE_AP)
+		ieee80211_flow_tbl_destroy(sdata);
 	return res;
 }
 
diff --git a/net/mac80211/rx.c b/net/mac80211/rx.c
index b3990b7a7299..fb7450715d2d 100644
--- a/net/mac80211/rx.c
+++ b/net/mac80211/rx.c
@@ -2790,6 +2790,9 @@ ieee80211_deliver_skb(struct ieee80211_rx_data *rx)
 		u64_stats_update_end(&rx->link_sta->rx_stats.syncp);
 	}
 
+	if (rx->sta)
+		ieee80211_flow_learn(rx);
+
 	if ((sdata->vif.type == NL80211_IFTYPE_AP ||
 	     sdata->vif.type == NL80211_IFTYPE_AP_VLAN) &&
 	    !(sdata->flags & IEEE80211_SDATA_DONT_BRIDGE_PACKETS) &&
@@ -4995,6 +4998,8 @@ static void ieee80211_rx_8023(struct ieee80211_rx_data *rx,
 	u64_stats_add(&stats->bytes, orig_len);
 	u64_stats_update_end(&stats->syncp);
 
+	ieee80211_flow_learn(rx);
+
 	if (fast_rx->internal_forward) {
 		struct sk_buff *xmit_skb = NULL;
 		if (is_multicast_ether_addr(da)) {
diff --git a/net/mac80211/scs.c b/net/mac80211/scs.c
index 89982e1f4b89..f0242ad43e91 100644
--- a/net/mac80211/scs.c
+++ b/net/mac80211/scs.c
@@ -12,6 +12,20 @@
 /* An hour, in TUs of 1024 microseconds */
 #define IEEE80211_MSCS_TIMEOUT_MAX_TU	3515625
 
+/* Limit on learned MSCS entries per station */
+#define IEEE80211_MSCS_ENTRIES_MAX	64
+
+/* The hashed bytes must hold no padding between the peer and the key */
+static_assert(offsetofend(struct ieee80211_flow_hkey, key) ==
+	      sizeof(struct sta_info *) + sizeof(struct cfg80211_flow_key));
+
+static const struct rhashtable_params flow_rht_params = {
+	.head_offset = offsetof(struct ieee80211_flow_entry, node),
+	.key_offset = offsetof(struct ieee80211_flow_entry, hkey),
+	.key_len = offsetofend(struct ieee80211_flow_hkey, key),
+	.automatic_shrinking = true,
+};
+
 static size_t ieee80211_scs_rule_size(const struct cfg80211_scs_desc *desc)
 {
 	return ALIGN(struct_size(desc, tclas, desc->n_tclas) +
@@ -115,6 +129,214 @@ bool ieee80211_flow_classify(struct sta_info *sta, struct sk_buff *skb)
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
+/* Return the time until the next entry expires, zero when none is left */
+static unsigned long ieee80211_flow_gc_sta(struct ieee80211_if_ap *ap,
+					   struct sta_info *sta)
+{
+	struct ieee80211_flow_entry *entry, *tmp;
+	struct ieee80211_mscs_sta *mscs;
+	unsigned long delay = 0;
+
+	mscs = wiphy_dereference(sta->local->hw.wiphy, sta->mscs);
+	if (!mscs)
+		return 0;
+
+	spin_lock_bh(&mscs->lock);
+
+	list_for_each_entry_safe(entry, tmp, &mscs->entries, list) {
+		unsigned long dead = READ_ONCE(entry->last_update) +
+				     mscs->timeout;
+
+		if (time_after_eq(jiffies, dead)) {
+			ieee80211_flow_entry_free(ap, entry);
+			mscs->n_entries--;
+			continue;
+		}
+
+		if (!delay || time_before(dead, jiffies + delay))
+			delay = dead - jiffies;
+	}
+
+	spin_unlock_bh(&mscs->lock);
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
+
+	ap = container_of(work, struct ieee80211_if_ap, flow_gc_work.work);
+	sdata = container_of(ap, struct ieee80211_sub_if_data, u.ap);
+
+	list_for_each_entry(sta, &sdata->local->sta_list, list) {
+		unsigned long sta_delay;
+
+		if (sta->sdata->bss != ap)
+			continue;
+
+		sta_delay = ieee80211_flow_gc_sta(ap, sta);
+		if (sta_delay && (!delay || sta_delay < delay))
+			delay = sta_delay;
+	}
+
+	if (delay)
+		wiphy_delayed_work_queue(wiphy, &ap->flow_gc_work, delay);
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
+	entry->hkey.sta = hkey->sta;
+	entry->hkey.key = hkey->key;
+	entry->up = up;
+	entry->last_update = jiffies;
+
+	spin_lock_bh(&mscs->lock);
+
+	/* Another MSCS may have been installed, which emptied this list */
+	if (rcu_dereference(hkey->sta->mscs) != mscs)
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
+	if (first)
+		wiphy_delayed_work_queue(sdata->local->hw.wiphy,
+					 &sdata->bss->flow_gc_work, 1);
+
+	return;
+
+drop:
+	spin_unlock_bh(&mscs->lock);
+	kfree(entry);
+}
+
+/**
+ * ieee80211_flow_learn - record the user priority of an uplink flow
+ *
+ * @rx: the received frame, in IEEE 802.3 format
+ *
+ * The key is built for the downlink direction, so that the transmit path
+ * can look it up as is.
+ */
+void ieee80211_flow_learn(struct ieee80211_rx_data *rx)
+{
+	struct ieee80211_sub_if_data *sdata = rx->sdata;
+	const struct ethhdr *eth = (void *)rx->skb->data;
+	struct ieee80211_flow_hkey hkey;
+	struct ieee80211_mscs_sta *mscs;
+	struct ieee80211_flow_entry *entry;
+	struct cfg80211_flow_info info;
+	/* The TID from ieee80211_parse_qos(), or from a decap offload driver */
+	u32 up = rx->skb->priority;
+
+	if (sdata->vif.type != NL80211_IFTYPE_AP &&
+	    sdata->vif.type != NL80211_IFTYPE_AP_VLAN)
+		return;
+
+	mscs = rcu_dereference(rx->sta->mscs);
+	if (!mscs)
+		return;
+
+	if (up > 7 || !(mscs->up_bitmap & BIT(up)))
+		return;
+
+	if (is_multicast_ether_addr(eth->h_dest) ||
+	    !ether_addr_equal(eth->h_source, rx->sta->addr))
+		return;
+
+	if (!cfg80211_flow_parse(rx->skb, &info))
+		return;
+
+	hkey.sta = rx->sta;
+	if (!cfg80211_flow_key_build(&info, mscs->layout,
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
 int ieee80211_set_scs(struct wiphy *wiphy, struct net_device *dev,
 		      const u8 *peer, struct cfg80211_scs_desc * const *desc,
 		      struct cfg80211_scs_result *res, u8 n_desc)
@@ -188,6 +410,10 @@ int ieee80211_set_mscs(struct wiphy *wiphy, struct net_device *dev,
 
 	lockdep_assert_wiphy(wiphy);
 
+	/* Only an AP provides MSCS */
+	if (!sdata->bss)
+		return -EOPNOTSUPP;
+
 	sta = sta_info_get_bss(sdata, peer);
 	if (!sta)
 		return -ENOENT;
@@ -208,12 +434,22 @@ int ieee80211_set_mscs(struct wiphy *wiphy, struct net_device *dev,
 		 */
 		tu = min(desc->stream_timeout, IEEE80211_MSCS_TIMEOUT_MAX_TU);
 		mscs->timeout = max(1UL, usecs_to_jiffies(tu * 1024));
+
+		spin_lock_init(&mscs->lock);
+		INIT_LIST_HEAD(&mscs->entries);
 	}
 
 	old = wiphy_dereference(wiphy, sta->mscs);
 	rcu_assign_pointer(sta->mscs, mscs);
-	if (old)
+
+	if (old) {
+		/* The entries were keyed with the old layout */
+		spin_lock_bh(&old->lock);
+		ieee80211_flow_purge(sta->sdata->bss, old);
+		spin_unlock_bh(&old->lock);
+
 		kfree_rcu(old, rcu_head);
+	}
 
 	return 0;
 }
@@ -230,5 +466,9 @@ void ieee80211_sta_scs_free(struct sta_info *sta)
 
 	mscs = rcu_dereference_raw(sta->mscs);
 	RCU_INIT_POINTER(sta->mscs, NULL);
+	if (!mscs)
+		return;
+
+	ieee80211_flow_purge(sta->sdata->bss, mscs);
 	kfree(mscs);
 }
diff --git a/net/mac80211/sta_info.h b/net/mac80211/sta_info.h
index 2682b3095474..6e65313fe4d9 100644
--- a/net/mac80211/sta_info.h
+++ b/net/mac80211/sta_info.h
@@ -658,6 +658,9 @@ struct ieee80211_scs_sta {
  * @up_bitmap: user priorities that the AP learns from, one bit each
  * @up_limit: ceiling for the assigned user priority
  * @timeout: minimum lifetime of a learned value, in jiffies
+ * @lock: protects @entries and @n_entries
+ * @entries: the learned entries of this station, for teardown
+ * @n_entries: number of entries in @entries
  */
 struct ieee80211_mscs_sta {
 	struct rcu_head rcu_head;
@@ -665,6 +668,43 @@ struct ieee80211_mscs_sta {
 	u8 up_bitmap;
 	u8 up_limit;
 	unsigned long timeout;
+
+	spinlock_t lock; /* protects @entries and @n_entries */
+	struct list_head entries;
+	u32 n_entries;
+};
+
+/**
+ * struct ieee80211_flow_hkey - what a learned entry is looked up by
+ *
+ * @sta: the peer, so that a flow of one station never answers for another
+ * @key: the masked tuple, in the downlink direction
+ *
+ * Not packed: the whole of it is compared, but a packed aggregate would force
+ * byte-wise access to @sta.
+ */
+struct ieee80211_flow_hkey {
+	struct sta_info *sta;
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
