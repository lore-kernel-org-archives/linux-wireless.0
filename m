Received: from nbd.name (nbd.name [46.4.11.11])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7786D3A1A54
	for <linux-wireless@vger.kernel.org>; Wed,  2 Sep 2026 08:46:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=46.4.11.11
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788338780; cv=none; b=fhOcnNt7tdx8r21PHESkE6MdyKOB720v844IbVOq8Us5oY2U9gEXw95wcqOQ3RzgHqICDpCktmKqimeqjN5kV/m7O//OIrVFe3v5v3VqRLpn9mVIU5cPQYdIh7xWBRobOwPf94ZQYN3ssNfKmIyV/8ZKpeMC0aAHWXw/9XQu50E=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788338780; c=relaxed/simple;
	bh=8/3fMV6c0h8Bvp0wMQ+aQHssScvRQ9kbRAg/Xh9iU94=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=FfNgPCKpQ/AAOKqmRxJbEV8xKDRwIAjDI+wSny5tjik8a8Ww+gXO1d9evnD3YznPhxoCGrYBkmCTCAA24t5NWB6n6CRalAbigragWPWWOyfF1Kb8PrzDG/0w8uaPjd5LqQNbM26Ksh4RTIzZRGdeXOCADVYswIxXPlOur8p5jYA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=nbd.name; spf=pass smtp.mailfrom=nbd.name; dkim=pass (1024-bit key) header.d=nbd.name header.i=@nbd.name header.b=qLEhG4JZ; arc=none smtp.client-ip=46.4.11.11
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=nbd.name
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=nbd.name
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=nbd.name header.i=@nbd.name header.b="qLEhG4JZ"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=nbd.name;
	s=20160729; h=Content-Transfer-Encoding:MIME-Version:References:In-Reply-To:
	Message-ID:Date:Subject:Cc:To:From:Sender:Reply-To:Content-Type:Content-ID:
	Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
	:Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
	List-Post:List-Owner:List-Archive;
	bh=zrLz5yI6glXAOQ8pmQcFJhvnDlUD+DisqJ/MBJqUJ34=; b=qLEhG4JZx6lBgd5qOT6kRPq41R
	kFGwKaV3v3vEGeY2kt9fMkvPP/9yJMM0v49F3CX8D2Sj0t4Qg9y2mKA+B+JsUbqEHvSign5JXmgIL
	hmNRhOsSmlG8MN1orM7cWMK4FSH1S0mdPKpVGINwT+UJJpXx/V9O/K4zH3ShQSx8XQb8=;
Received: from p200300cadf14d1000000000000000162.dip0.t-ipconnect.de ([2003:ca:df14:d100::162] helo=localhost.localdomain)
	by ds12 with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
	(Exim 4.96)
	(envelope-from <nbd@nbd.name>)
	id 1x1gbn-00Cwkn-1L;
	Wed, 02 Sep 2026 10:46:15 +0200
From: Felix Fietkau <nbd@nbd.name>
To: linux-wireless@vger.kernel.org
Cc: johannes@sipsolutions.net
Subject: [RFC PATCH 10/15] wifi: mac80211: learn MSCS flows on receive
Date: Wed,  2 Sep 2026 10:46:05 +0200
Message-ID: <764fa64e945a803a0c5810e9bac3a0d7cff54626.1788338716.git-series.nbd@nbd.name>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <cover.3af9ba310d9145a9dfd653b5a886feaba98e8884.1788338716.git-series.nbd@nbd.name>
References: <cover.3af9ba310d9145a9dfd653b5a886feaba98e8884.1788338716.git-series.nbd@nbd.name>
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

An AP mirrors the priority a station gives its own uplink onto the
downlink of the same flow, so the receive path records the flow UP from
individually addressed frames of the station whose user priority the
request named.

The key is built for the reverse direction, so the transmit path finds it
without a second layout. Entries live in one hash table per BSS, keyed by
the peer as well as the tuple, and a per station list carries what
teardown and the collector walk.

Signed-off-by: Felix Fietkau <nbd@nbd.name>
---
 net/mac80211/ieee80211_i.h |   7 +-
 net/mac80211/iface.c       |  12 +-
 net/mac80211/rx.c          |   5 +-
 net/mac80211/scs.c         | 286 +++++++++++++++++++++++++++++++++++++-
 net/mac80211/sta_info.h    |  40 +++++-
 5 files changed, 348 insertions(+), 2 deletions(-)

diff --git a/net/mac80211/ieee80211_i.h b/net/mac80211/ieee80211_i.h
index ce2167c8a252..b17fa83f2003 100644
--- a/net/mac80211/ieee80211_i.h
+++ b/net/mac80211/ieee80211_i.h
@@ -336,6 +336,10 @@ struct ieee80211_if_ap {
 
 	bool multicast_to_unicast;
 	bool active;
+
+	/* learned MSCS entries of every station of this BSS, and its VLANs */
+	struct rhashtable flow_tbl;
+	struct wiphy_delayed_work flow_gc_work;
 };
 
 struct ieee80211_if_vlan {
@@ -2212,6 +2216,9 @@ int ieee80211_set_mscs(struct wiphy *wiphy, struct net_device *dev,
 		       const u8 *peer, struct cfg80211_mscs_desc *desc);
 void ieee80211_sta_scs_free(struct sta_info *sta);
 bool ieee80211_flow_classify(struct sta_info *sta, struct sk_buff *skb);
+void ieee80211_flow_learn(struct ieee80211_rx_data *rx);
+int ieee80211_flow_tbl_init(struct ieee80211_sub_if_data *sdata);
+void ieee80211_flow_tbl_destroy(struct ieee80211_sub_if_data *sdata);
 
 /* link handling */
 void ieee80211_link_setup(struct ieee80211_link_data *link);
diff --git a/net/mac80211/iface.c b/net/mac80211/iface.c
index 43460a705a6b..593e93f71c20 100644
--- a/net/mac80211/iface.c
+++ b/net/mac80211/iface.c
@@ -542,6 +542,9 @@ static void ieee80211_do_stop(struct ieee80211_sub_if_data *sdata, bool going_do
 		atomic_dec(&local->iff_allmultis);
 
 	if (sdata->vif.type == NL80211_IFTYPE_AP) {
+		/* every station is gone, so nothing can learn any more */
+		ieee80211_flow_tbl_destroy(sdata);
+
 		local->fif_pspoll--;
 		local->fif_probe_req--;
 	} else if (sdata->vif.type == NL80211_IFTYPE_ADHOC) {
@@ -1405,6 +1408,10 @@ int ieee80211_do_open(struct wireless_dev *wdev, bool coming_up)
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
@@ -1439,7 +1446,7 @@ int ieee80211_do_open(struct wireless_dev *wdev, bool coming_up)
 			 * no need to worry about AP_VLAN/NAN_DATA cleanup since
 			 * in that case we can't have open_count == 0
 			 */
-			return res;
+			goto err_flow_tbl;
 		}
 		ieee80211_led_radio(local, true);
 		ieee80211_mod_tpt_led_trig(local,
@@ -1611,6 +1618,9 @@ int ieee80211_do_open(struct wireless_dev *wdev, bool coming_up)
 		list_del(&sdata->u.vlan.list);
 	/* Might not be initialized yet, but it is harmless */
 	sdata->bss = NULL;
+ err_flow_tbl:
+	if (sdata->vif.type == NL80211_IFTYPE_AP)
+		ieee80211_flow_tbl_destroy(sdata);
 	return res;
 }
 
diff --git a/net/mac80211/rx.c b/net/mac80211/rx.c
index 5e26be8e27d8..bf249e66e069 100644
--- a/net/mac80211/rx.c
+++ b/net/mac80211/rx.c
@@ -2815,6 +2815,9 @@ ieee80211_deliver_skb(struct ieee80211_rx_data *rx)
 		u64_stats_update_end(&rx->link_sta->rx_stats.syncp);
 	}
 
+	if (rx->sta)
+		ieee80211_flow_learn(rx);
+
 	if ((sdata->vif.type == NL80211_IFTYPE_AP ||
 	     sdata->vif.type == NL80211_IFTYPE_AP_VLAN) &&
 	    !(sdata->flags & IEEE80211_SDATA_DONT_BRIDGE_PACKETS) &&
@@ -4980,6 +4983,8 @@ static void ieee80211_rx_8023(struct ieee80211_rx_data *rx,
 	u64_stats_add(&stats->bytes, orig_len);
 	u64_stats_update_end(&stats->syncp);
 
+	ieee80211_flow_learn(rx);
+
 	if (fast_rx->internal_forward) {
 		struct sk_buff *xmit_skb = NULL;
 		if (is_multicast_ether_addr(da)) {
diff --git a/net/mac80211/scs.c b/net/mac80211/scs.c
index ea92c0104d92..12730e836962 100644
--- a/net/mac80211/scs.c
+++ b/net/mac80211/scs.c
@@ -5,6 +5,7 @@
  * Copyright (C) 2026 Felix Fietkau <nbd@nbd.name>
  */
 #include <linux/ieee80211.h>
+#include <linux/module.h>
 #include <net/cfg80211.h>
 #include "ieee80211_i.h"
 #include "sta_info.h"
@@ -12,6 +13,27 @@
 /* An hour, in TUs of 1024 microseconds */
 #define IEEE80211_MSCS_TIMEOUT_MAX_TU	3515625
 
+/*
+ * Only the station itself can fill its own table, because every entry comes
+ * from one of its uplink frames, so the bound is per station and needs no
+ * admission rule. See bss_entries_limit in net/wireless/scan.c for the same
+ * shape of knob.
+ */
+static u32 mscs_entries_limit = 64;
+module_param(mscs_entries_limit, uint, 0644);
+MODULE_PARM_DESC(mscs_entries_limit, "limit on learned MSCS flows per station");
+
+/* The hash covers the peer and the key, and not the padding behind them */
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
@@ -124,6 +146,240 @@ bool ieee80211_flow_classify(struct sta_info *sta, struct sk_buff *skb)
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
+/* Drop everything one station learned, with @mscs->lock held if it can race */
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
+/*
+ * 9.4.2.242 calls the Stream Timeout a minimum for keeping a variable, so an
+ * entry is dropped once it has been idle for longer than that. Each run
+ * reports how long the earliest survivor has left, and the work sleeps for
+ * that; with nothing left it stops until a station learns again.
+ */
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
+		/* A survivor has at least one jiffy left, so zero means none */
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
+	/*
+	 * The station may have been given another MSCS since this one was
+	 * read, and that one took this list apart under the same lock.
+	 */
+	if (rcu_dereference(hkey->sta->mscs) != mscs)
+		goto drop;
+
+	if (mscs->n_entries >= mscs_entries_limit)
+		goto drop;
+
+	other = rhashtable_lookup_get_insert_fast(&sdata->bss->flow_tbl,
+						  &entry->node,
+						  flow_rht_params);
+	if (other) {
+		/*
+		 * Another CPU learned the same tuple first, which a coarse
+		 * mask makes ordinary. 11.25.3 item c) 3) discards the
+		 * previous value, so either writer may win. A resize gives an
+		 * error instead, and the next frame of the flow learns again.
+		 */
+		if (!IS_ERR(other))
+			WRITE_ONCE(other->up, up);
+
+		goto drop;
+	}
+
+	list_add_tail(&entry->list, &mscs->entries);
+	first = mscs->n_entries++ == 0;
+	spin_unlock_bh(&mscs->lock);
+
+	/*
+	 * The collector reschedules itself while any entry is left, so it only
+	 * has to be woken when a station fills an empty list. Waking it at once
+	 * rather than at this station's deadline is deliberate: the queue is a
+	 * mod_timer(), so a later deadline would displace an earlier one.
+	 */
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
+ * The AP mirrors the priority a station gives its own uplink onto the
+ * downlink of the same flow, so the key is built for the reverse direction
+ * and the transmit path finds it without a second layout.
+ */
+void ieee80211_flow_learn(struct ieee80211_rx_data *rx)
+{
+	struct ieee80211_sub_if_data *sdata = rx->sdata;
+	const struct ethhdr *eth = (void *)rx->skb->data;
+	struct ieee80211_flow_hkey hkey;
+	struct ieee80211_mscs_sta *mscs;
+	struct ieee80211_flow_entry *entry;
+	struct cfg80211_flow_info info;
+	/*
+	 * The TID that ieee80211_parse_qos() recorded, or for a frame the
+	 * device decapped, whatever the driver put there. The forwarding path
+	 * a few lines below the caller reads the same field.
+	 */
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
+	/*
+	 * 11.25.3 item c) learns from an individually addressed MSDU that the
+	 * station sent itself, and only for a user priority its request named.
+	 */
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
@@ -200,6 +456,10 @@ int ieee80211_set_mscs(struct wiphy *wiphy, struct net_device *dev,
 
 	lockdep_assert_wiphy(wiphy);
 
+	/* 11.25.3 makes MSCS a service an AP provides, so it needs a BSS */
+	if (!sdata->bss)
+		return -EOPNOTSUPP;
+
 	sta = sta_info_get_bss(sdata, peer);
 	if (!sta)
 		return -ENOENT;
@@ -226,12 +486,28 @@ int ieee80211_set_mscs(struct wiphy *wiphy, struct net_device *dev,
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
+		/*
+		 * The keys of the learned entries were built with the layout
+		 * that is going away, and 11.25.3 deletes the list of
+		 * UP{tuple} variables on a teardown, so they go either way. A
+		 * receive path that still holds the old MSCS takes the same
+		 * lock, sees that the station has moved on and adds nothing.
+		 */
+		spin_lock_bh(&old->lock);
+		ieee80211_flow_purge(sta->sdata->bss, old);
+		spin_unlock_bh(&old->lock);
+
 		kfree_rcu(old, rcu_head);
+	}
 
 	return 0;
 }
@@ -247,5 +523,13 @@ void ieee80211_sta_scs_free(struct sta_info *sta)
 
 	mscs = rcu_dereference_raw(sta->mscs);
 	RCU_INIT_POINTER(sta->mscs, NULL);
+	if (!mscs)
+		return;
+
+	/*
+	 * sta_info_free() runs a grace period after the station left the hash,
+	 * so nothing can reach this list any more and it needs no lock.
+	 */
+	ieee80211_flow_purge(sta->sdata->bss, mscs);
 	kfree(mscs);
 }
diff --git a/net/mac80211/sta_info.h b/net/mac80211/sta_info.h
index 2682b3095474..7c8978c142d4 100644
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
+	spinlock_t lock; /* protects the entry list and its count */
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
+ * struct ieee80211_flow_entry - one learned UP{tuple} variable
+ *
+ * @hkey: what it is looked up by, keep first
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
