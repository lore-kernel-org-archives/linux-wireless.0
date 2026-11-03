Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=46.4.11.11
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793723050;
	b=VhMw6tt+rcIUfYCxKK1NGDWqwntzBk9bt/cpzCOxWeqeVWJhwNKHTwJjwcMmxVPPFERH
	 mVu0DYOJm6IPih3U2ooI4T5WlrS5M5lRR2y0GQuKWg9aAIC0cg0Bo2P1a2OSUIMB2zshb
	 SS2AhnSf7fHyyLiyT5zzfRNoKBkWRLO7iJql+lXB5BDcSFodqAD3QMJvWApUZIjYtzV5V
	 MBXKjzxuNbBW3En5k+UCEj/+lDsUSeR3hyVXc+da6130x8cBgaER867GA/nYKCyi0bNAu
	 R/zXtKXWyNWnYyo5CktiCdhU2PT8aYT0HiYRy0AlHtXRJw7n/tAeYYh31dp4SDGIfKg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793723050;
	h=DMARC-Filter:DKIM-Signature:Received:From:To:Cc:Subject:Date:
	 Message-ID:X-Mailer:In-Reply-To:References:MIME-Version:
	 Content-Transfer-Encoding;
	bh=njYbfhV71sREdqxneP7m0DlbMShTTnBr9Y8gp5/iIRw=;
	b=MyvpBNZG22vosErOYp/q94vpkIeRb0Md9lp0UUqO6qRbVd5j8ycXJWGZcVCw0SOs2KkJ
	 KIGxS0ArppVIBgZmCkAleybo8pqh15kJYfxfAl0ds/FPBT0b3RfUImspp6lL9+4Z+2r6T
	 gnnP9re7OwQYnjc4QDKQtWo15d7Es0Fq4pW9M6WBg7RymGMxDqnMciYxFvfKYW0I7bEIf
	 BvtGYiKvAtoJipqILpYVxXCMzMNHAo12cXOKbFW0GZ6DA/GV2ENOrfEgZdcc3yWVnKOjp
	 0khqkJsv1Dy5KgRXsJgjuoBmhUHEeEY/T+P1orWtn7HaiUXUbV191QSOZOIC1Gy9bwg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=nbd.name;
	spf=pass smtp.mailfrom=nbd.name;
	dkim=pass header.d=nbd.name header.i=@nbd.name header.a=rsa-sha256 header.s=20160729 header.b=iVCgKXmO;
	arc=none smtp.remote-ip=46.4.11.11
Received: from nbd.name (nbd.name [46.4.11.11])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange ECDHE (prime256v1) server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 11C49606A335
	for <linux-wireless@vger.kernel.org>; Tue,  3 Nov 2026 16:24:09 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 11C49606A335
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=nbd.name
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=nbd.name
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=nbd.name header.i=@nbd.name header.a=rsa-sha256 header.s=20160729 header.b=iVCgKXmO
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=nbd.name;
	s=20160729; h=Content-Transfer-Encoding:MIME-Version:References:In-Reply-To:
	Message-ID:Date:Subject:Cc:To:From:Sender:Reply-To:Content-Type:Content-ID:
	Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
	:Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
	List-Post:List-Owner:List-Archive;
	bh=njYbfhV71sREdqxneP7m0DlbMShTTnBr9Y8gp5/iIRw=; b=iVCgKXmOOYgD53woLe0VlzRqId
	T5+fKw9GzcmLqPygCzs3tywKizpJhxSPfcFyAsmJgIyA9gvMzXG4jBfIu8IlLuFYbwnPUsxHaLoQ5
	AnYzFY0jtn6xy5g/dLtHm13gDVept1oSfnPXdUzgrBoH/xOF1w3VOska7GHSM8oBxmBw=;
Received: from p200300cadf12920000000000000005bb.dip0.t-ipconnect.de ([2003:ca:df12:9200::5bb] helo=localhost.localdomain)
	by ds12 with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
	(Exim 4.96)
	(envelope-from <nbd@nbd.name>)
	id 1xOHIo-00FDFp-0Y;
	Tue, 03 Nov 2026 17:24:02 +0100
From: Felix Fietkau <nbd@nbd.name>
To: linux-wireless@vger.kernel.org
Cc: johannes@sipsolutions.net
Subject: [PATCH wireless-next 17/18] wifi: mac80211: add the flow offload flush op
Date: Tue,  3 Nov 2026 17:23:50 +0100
Message-ID: <12e77958f030c0dbe80cc2fc16cfd978c0fc8855.1793722802.git-series.nbd@nbd.name>
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

A driver that uses ieee80211_sta_flow_prio() stores the result in its
hardware flow entries. Once the SCS or MSCS rules of a station or the
QoS map of its interface change, those entries are stale. Add a driver
op that is called after each such change, so that the driver can drop
the entries of the station and query again when the flows are added
back.

A learned MSCS priority also changes an answer, but only for one flow.
In that case the op gets a struct ieee80211_flow_match for the flow, so
that the driver drops only the matching entries.

The first user, flow offload with mtk_eth_soc on mt7996, follows in a
separate series.

Signed-off-by: Felix Fietkau <nbd@nbd.name>
---
 include/net/mac80211.h     | 34 ++++++++++++++-
 net/mac80211/cfg.c         |  6 ++-
 net/mac80211/driver-ops.h  | 20 ++++++++-
 net/mac80211/ieee80211_i.h |  1 +-
 net/mac80211/scs.c         | 97 ++++++++++++++++++++++++++++++++++++---
 net/mac80211/sta_info.h    |  3 +-
 net/mac80211/trace.h       |  7 +++-
 7 files changed, 162 insertions(+), 6 deletions(-)

diff --git a/include/net/mac80211.h b/include/net/mac80211.h
index de570d72fd16..a719b688e170 100644
--- a/include/net/mac80211.h
+++ b/include/net/mac80211.h
@@ -4094,6 +4094,21 @@ struct ieee80211_prep_tx_info {
 };
 
 /**
+ * struct ieee80211_flow_match - selects the offloaded entries of one flow
+ *
+ * @key: the flow, in the direction to the station
+ * @fields: the parameters of @key that a hardware flow entry must match, a
+ *	bitmap of &enum cfg80211_flow_field
+ *
+ * Entries of the same flow in the direction from the station match as well,
+ * with the addresses and the ports of @key swapped.
+ */
+struct ieee80211_flow_match {
+	const struct cfg80211_flow_key *key;
+	u32 fields;
+};
+
+/**
  * struct ieee80211_ops - callbacks from mac80211 to the driver
  *
  * This structure contains various callbacks that the driver may
@@ -5158,6 +5173,25 @@ struct ieee80211_ops {
 			   struct ieee80211_sta *sta,
 			   struct cfg80211_scs_desc * const *desc,
 			   u16 *status, u8 n_desc);
+	/**
+	 * @flow_offload_flush:
+	 * Called after the SCS or MSCS rules of a station or the QoS map of
+	 * its interface changed, or after the learned MSCS priority of one
+	 * flow changed. Any priority that
+	 * ieee80211_sta_flow_prio() returned before is stale, so the driver
+	 * must drop the hardware flow entries that use it. With a %NULL
+	 * @match, every entry of the station is stale, otherwise only the
+	 * entries that @match selects. The entries in the direction from the
+	 * station are dropped as well, since mac80211 learns an MSCS priority
+	 * only from frames that it receives.
+	 * Optional, only needed by drivers that use ieee80211_sta_flow_prio().
+	 *
+	 * Called with the wiphy mutex held. This callback may sleep.
+	 */
+	void (*flow_offload_flush)(struct ieee80211_hw *hw,
+				   struct ieee80211_vif *vif,
+				   struct ieee80211_sta *sta,
+				   const struct ieee80211_flow_match *match);
 	int (*set_tid_config)(struct ieee80211_hw *hw,
 			      struct ieee80211_vif *vif,
 			      struct ieee80211_sta *sta,
diff --git a/net/mac80211/cfg.c b/net/mac80211/cfg.c
index e3bbe2aa0522..e3ce3e3b2af5 100644
--- a/net/mac80211/cfg.c
+++ b/net/mac80211/cfg.c
@@ -5376,6 +5376,7 @@ static int ieee80211_set_qos_map(struct wiphy *wiphy,
 {
 	struct ieee80211_sub_if_data *sdata = IEEE80211_DEV_TO_SUB_IF(dev);
 	struct mac80211_qos_map *new_qos_map, *old_qos_map;
+	struct sta_info *sta;
 
 	if (qos_map) {
 		new_qos_map = kzalloc_obj(*new_qos_map);
@@ -5392,6 +5393,11 @@ static int ieee80211_set_qos_map(struct wiphy *wiphy,
 	if (old_qos_map)
 		kfree_rcu(old_qos_map, rcu_head);
 
+	/* ieee80211_sta_flow_prio() falls back to the QoS map */
+	list_for_each_entry(sta, &sdata->local->sta_list, list)
+		if (sta->sdata == sdata)
+			drv_flow_offload_flush(sdata->local, sdata, sta, NULL);
+
 	return 0;
 }
 
diff --git a/net/mac80211/driver-ops.h b/net/mac80211/driver-ops.h
index 004e21ff334e..ff3c856b5e29 100644
--- a/net/mac80211/driver-ops.h
+++ b/net/mac80211/driver-ops.h
@@ -1569,6 +1569,26 @@ static inline int drv_sta_set_scs(struct ieee80211_local *local,
 	return ret;
 }
 
+static inline void
+drv_flow_offload_flush(struct ieee80211_local *local,
+		       struct ieee80211_sub_if_data *sdata, struct sta_info *sta,
+		       const struct ieee80211_flow_match *match)
+{
+	might_sleep();
+	lockdep_assert_wiphy(local->hw.wiphy);
+
+	if (!local->ops->flow_offload_flush || !sta->uploaded)
+		return;
+
+	sdata = get_bss_sdata(sdata);
+	if (!check_sdata_in_driver(sdata))
+		return;
+
+	trace_drv_flow_offload_flush(local, sdata, &sta->sta);
+	local->ops->flow_offload_flush(&local->hw, &sdata->vif, &sta->sta, match);
+	trace_drv_return_void(local);
+}
+
 static inline int drv_set_tid_config(struct ieee80211_local *local,
 				     struct ieee80211_sub_if_data *sdata,
 				     struct ieee80211_sta *sta,
diff --git a/net/mac80211/ieee80211_i.h b/net/mac80211/ieee80211_i.h
index 41518764ee12..600200b3ee04 100644
--- a/net/mac80211/ieee80211_i.h
+++ b/net/mac80211/ieee80211_i.h
@@ -361,6 +361,7 @@ struct ieee80211_if_ap {
 	struct rhashtable flow_tbl;
 	struct wiphy_delayed_work flow_gc_work;
 	atomic_t flow_gc_kick;
+	struct wiphy_work flow_flush_work;
 };
 
 struct ieee80211_if_vlan {
diff --git a/net/mac80211/scs.c b/net/mac80211/scs.c
index 986439035df8..d3b120770a83 100644
--- a/net/mac80211/scs.c
+++ b/net/mac80211/scs.c
@@ -367,10 +367,73 @@ static void ieee80211_flow_gc_work(struct wiphy *wiphy, struct wiphy_work *work)
 		wiphy_delayed_work_queue(wiphy, &ap->flow_gc_work, 1);
 }
 
+static void ieee80211_flow_flush_mscs(struct ieee80211_sub_if_data *sdata,
+				      struct sta_info *sta,
+				      struct ieee80211_mscs_sta *mscs)
+{
+	while (true) {
+		struct ieee80211_flow_match match = {
+			.fields = mscs->layout,
+		};
+		struct ieee80211_flow_entry *entry;
+		struct cfg80211_flow_key key;
+		bool found = false;
+
+		spin_lock_bh(&mscs->lock);
+		list_for_each_entry(entry, &mscs->entries, list) {
+			if (!READ_ONCE(entry->flush))
+				continue;
+
+			WRITE_ONCE(entry->flush, false);
+			key = entry->hkey.key;
+			found = true;
+			break;
+		}
+		spin_unlock_bh(&mscs->lock);
+
+		if (!found)
+			return;
+
+		match.key = &key;
+		drv_flow_offload_flush(sdata->local, sta->sdata, sta, &match);
+	}
+}
+
+static void ieee80211_flow_flush_sta(struct ieee80211_sub_if_data *sdata,
+				     struct sta_info *sta)
+{
+	struct ieee80211_mscs_sta *mscs;
+
+	lockdep_assert_wiphy(sdata->local->hw.wiphy);
+
+	list_for_each_entry(mscs, &sta->mscs, list)
+		ieee80211_flow_flush_mscs(sdata, sta, mscs);
+}
+
+static void ieee80211_flow_flush_work(struct wiphy *wiphy,
+				      struct wiphy_work *work)
+{
+	struct ieee80211_sub_if_data *sdata;
+	struct ieee80211_if_ap *ap;
+	struct sta_info *sta;
+
+	ap = container_of(work, struct ieee80211_if_ap, flow_flush_work);
+	sdata = container_of(ap, struct ieee80211_sub_if_data, u.ap);
+
+	list_for_each_entry(sta, &sdata->local->sta_list, list) {
+		if (sta->sdata->bss != ap)
+			continue;
+
+		ieee80211_flow_flush_sta(sdata, sta);
+	}
+}
+
 int ieee80211_flow_tbl_init(struct ieee80211_sub_if_data *sdata)
 {
 	wiphy_delayed_work_init(&sdata->u.ap.flow_gc_work,
 				ieee80211_flow_gc_work);
+	wiphy_work_init(&sdata->u.ap.flow_flush_work,
+			ieee80211_flow_flush_work);
 
 	return rhashtable_init(&sdata->u.ap.flow_tbl, &flow_rht_params);
 }
@@ -386,6 +449,7 @@ void ieee80211_flow_tbl_destroy(struct ieee80211_sub_if_data *sdata)
 {
 	wiphy_delayed_work_cancel(sdata->local->hw.wiphy,
 				  &sdata->u.ap.flow_gc_work);
+	wiphy_work_cancel(sdata->local->hw.wiphy, &sdata->u.ap.flow_flush_work);
 	rhashtable_free_and_destroy(&sdata->u.ap.flow_tbl,
 				    ieee80211_flow_tbl_free, NULL);
 }
@@ -395,6 +459,7 @@ static void ieee80211_flow_insert(struct ieee80211_sub_if_data *sdata,
 				  const struct ieee80211_flow_hkey *hkey, u8 up)
 {
 	struct ieee80211_flow_entry *entry, *other;
+	bool flush = false;
 	bool first;
 
 	entry = kzalloc_obj(*entry, GFP_ATOMIC);
@@ -405,6 +470,8 @@ static void ieee80211_flow_insert(struct ieee80211_sub_if_data *sdata,
 	entry->hkey.key = hkey->key;
 	entry->up = up;
 	entry->last_update = jiffies;
+	/* The hardware entries of this flow were bound without this priority */
+	entry->flush = true;
 
 	spin_lock_bh(&mscs->lock);
 
@@ -421,8 +488,11 @@ static void ieee80211_flow_insert(struct ieee80211_sub_if_data *sdata,
 	if (other) {
 		/* Concurrent insert of the same key, the last writer wins */
 		if (!IS_ERR(other)) {
+			flush = READ_ONCE(other->up) != up;
 			WRITE_ONCE(other->up, up);
 			WRITE_ONCE(other->last_update, jiffies);
+			if (flush)
+				WRITE_ONCE(other->flush, true);
 		}
 
 		goto drop;
@@ -441,11 +511,17 @@ static void ieee80211_flow_insert(struct ieee80211_sub_if_data *sdata,
 					 &sdata->bss->flow_gc_work, 1);
 	}
 
+	wiphy_work_queue(sdata->local->hw.wiphy, &sdata->bss->flow_flush_work);
+
 	return;
 
 drop:
 	spin_unlock_bh(&mscs->lock);
 	kfree(entry);
+
+	if (flush)
+		wiphy_work_queue(sdata->local->hw.wiphy,
+				 &sdata->bss->flow_flush_work);
 }
 
 static void ieee80211_flow_learn_mscs(struct ieee80211_sub_if_data *sdata,
@@ -463,13 +539,18 @@ static void ieee80211_flow_learn_mscs(struct ieee80211_sub_if_data *sdata,
 
 	entry = rhashtable_lookup(&sdata->bss->flow_tbl, &hkey,
 				  flow_rht_params);
-	if (entry) {
-		WRITE_ONCE(entry->up, up);
-		WRITE_ONCE(entry->last_update, jiffies);
+	if (!entry) {
+		ieee80211_flow_insert(sdata, mscs, &hkey, up);
 		return;
 	}
 
-	ieee80211_flow_insert(sdata, mscs, &hkey, up);
+	WRITE_ONCE(entry->last_update, jiffies);
+	if (READ_ONCE(entry->up) == up)
+		return;
+
+	WRITE_ONCE(entry->up, up);
+	WRITE_ONCE(entry->flush, true);
+	wiphy_work_queue(sdata->local->hw.wiphy, &sdata->bss->flow_flush_work);
 }
 
 /**
@@ -601,6 +682,8 @@ int ieee80211_set_scs(struct wiphy *wiphy, struct net_device *dev,
 	if (old)
 		kvfree_rcu(old, rcu_head);
 
+	drv_flow_offload_flush(sdata->local, sdata, sta, NULL);
+
 	return 0;
 
 free:
@@ -666,8 +749,7 @@ int ieee80211_set_mscs(struct wiphy *wiphy, struct net_device *dev,
 		list_del_rcu(&old->list);
 		sta->n_mscs--;
 		ieee80211_mscs_free(sta->sdata->bss, old);
-
-		return 0;
+		goto flush;
 	}
 
 	if (!old && sta->n_mscs >= IEEE80211_MSCS_MAX)
@@ -707,6 +789,9 @@ int ieee80211_set_mscs(struct wiphy *wiphy, struct net_device *dev,
 		sta->n_mscs++;
 	}
 
+flush:
+	drv_flow_offload_flush(sdata->local, sdata, sta, NULL);
+
 	return 0;
 }
 
diff --git a/net/mac80211/sta_info.h b/net/mac80211/sta_info.h
index 50af2f7a024f..acc961f94793 100644
--- a/net/mac80211/sta_info.h
+++ b/net/mac80211/sta_info.h
@@ -709,6 +709,8 @@ struct ieee80211_flow_hkey {
  * @list: linkage in &ieee80211_mscs_sta.entries
  * @last_update: jiffies of the last uplink frame of this flow
  * @up: the learned user priority
+ * @flush: the driver must drop the offloaded entries of this flow, since
+ *	@up is new or changed
  * @rcu_head: for freeing
  */
 struct ieee80211_flow_entry {
@@ -717,6 +719,7 @@ struct ieee80211_flow_entry {
 	struct list_head list;
 	unsigned long last_update;
 	u8 up;
+	bool flush;
 	struct rcu_head rcu_head;
 };
 
diff --git a/net/mac80211/trace.h b/net/mac80211/trace.h
index 4720ea912e5c..a3262182aae7 100644
--- a/net/mac80211/trace.h
+++ b/net/mac80211/trace.h
@@ -1050,6 +1050,13 @@ TRACE_EVENT(drv_sta_set_scs,
 	)
 );
 
+DEFINE_EVENT(sta_event, drv_flow_offload_flush,
+	TP_PROTO(struct ieee80211_local *local,
+		 struct ieee80211_sub_if_data *sdata,
+		 struct ieee80211_sta *sta),
+	TP_ARGS(local, sdata, sta)
+);
+
 DEFINE_EVENT(sta_event, drv_sta_statistics,
 	TP_PROTO(struct ieee80211_local *local,
 		 struct ieee80211_sub_if_data *sdata,
-- 
git-series 0.9.1
