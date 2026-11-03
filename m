Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=46.4.11.11
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793723049;
	b=KTW37FE3tFdPmEwbGjadp8ia4eMnqVvxGqasyqO/X2SBbkrEbqrYoKkYwkvcGtYzBkVg
	 l+NW7p3KGNEUxfFSCV/A4zo4N1A44A0hTNB04ItsTbCBPEvSKWOYLy8mjFyX/B7DrmVQ1
	 OfFlfO6ELUGxnnN21vsqQnvN5qufjdYxuwhbbzAPb9cL0gwxvwYUNQA3Nd9uLJRwyo+tV
	 ZdHCA8uP3WwvuNb9cHCJO0L6qywNntvY1neBNeYkIvPpIAF5SA0xBYP3VOD2XgyIYAS6y
	 Vvb+1q+3V5IZmnzQHLOiRVFLX+ztuYJX2EQyvZuVmLB6cLP012RiE1hEHpHIxrUGggA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793723049;
	h=DMARC-Filter:DKIM-Signature:Received:From:To:Cc:Subject:Date:
	 Message-ID:X-Mailer:In-Reply-To:References:MIME-Version:
	 Content-Transfer-Encoding;
	bh=87SJ0MxgR93zjjprBXVb//+rOY1+S5pVp592lCMfKSA=;
	b=KpQEVpa0S+UaRWiaW6QGHe4Ws8vbxoBbJYndKGI2Nk0s9ojLRFUfZJ6Lg6qdiTFSnCBq
	 tjfq9DOine3Pdve2//1fxjHWyRRppwSALBC1lOG07WmtT69LjF6Ds0oxGNBfDRTh6YunR
	 +PGQIx8NQ4/pHNvMBKID/058iOj3P6yAScFlxrOvBipraZ0RFhvZXsUEYWb9thw5p37kH
	 +5gY35nXFXIQ8jE8BWxxwvdQyvnsX63A6j2VMJ5JEK7B0TAY5UwsIteOLCHrjeuPML9fs
	 TP3avadgDC/5pjUr96tLDnbmWY8e8zER4FI0X8LKwJ3s7PkzdfwZW+tAZxI/7mik+TA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=nbd.name;
	spf=pass smtp.mailfrom=nbd.name;
	dkim=pass header.d=nbd.name header.i=@nbd.name header.a=rsa-sha256 header.s=20160729 header.b=d+sN1CsU;
	arc=none smtp.remote-ip=46.4.11.11
Received: from nbd.name (nbd.name [46.4.11.11])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange ECDHE (prime256v1) server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 53AB0606D817
	for <linux-wireless@vger.kernel.org>; Tue,  3 Nov 2026 16:24:08 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 53AB0606D817
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=nbd.name
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=nbd.name
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=nbd.name header.i=@nbd.name header.a=rsa-sha256 header.s=20160729 header.b=d+sN1CsU
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=nbd.name;
	s=20160729; h=Content-Transfer-Encoding:MIME-Version:References:In-Reply-To:
	Message-ID:Date:Subject:Cc:To:From:Sender:Reply-To:Content-Type:Content-ID:
	Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
	:Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
	List-Post:List-Owner:List-Archive;
	bh=87SJ0MxgR93zjjprBXVb//+rOY1+S5pVp592lCMfKSA=; b=d+sN1CsUN21wEeqGN0nUphMovb
	DA1P3clzLBgRXDJWx6oEd4C5EkV3gmUlg8+Gqcq5fKgShhrfiC8Krx8uUMDxWMguxE6YLKg0mAniq
	K4A3VJI/0O0ChLH5sP7q0Jn+me6f3Umf6XS+hcOqXJP57FlFfdhGq98Fl4dlV2Ns4W08=;
Received: from p200300cadf12920000000000000005bb.dip0.t-ipconnect.de ([2003:ca:df12:9200::5bb] helo=localhost.localdomain)
	by ds12 with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
	(Exim 4.96)
	(envelope-from <nbd@nbd.name>)
	id 1xOHIm-00FDFp-2c;
	Tue, 03 Nov 2026 17:24:00 +0100
From: Felix Fietkau <nbd@nbd.name>
To: linux-wireless@vger.kernel.org
Cc: johannes@sipsolutions.net
Subject: [PATCH wireless-next 10/18] wifi: mac80211: add SCS and MSCS rule storage
Date: Tue,  3 Nov 2026 17:23:43 +0100
Message-ID: <8a329e14a53ca436d016d4a774f1adea9cfee44f.1793722802.git-series.nbd@nbd.name>
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

Implement the set_scs and set_mscs cfg80211 ops and store the result
per station under RCU, for the transmit and receive paths that follow.
Only an AP classifies the downlink, so both ops refuse other interface
types.

A request edits the rule set of one station, so the result combines
its descriptors with those of earlier requests. The set is rebuilt and
replaced as a whole, so that a reader sees either the old or the new
set.

A station keeps a list of MSCS, identified by the client address and
the configured flag. An MSCS without a client applies to the station
itself. The MSCS that the station requested come first in the list, so
that they take precedence over a configured one, as Wi-Fi EasyMesh
requires.

Signed-off-by: Felix Fietkau <nbd@nbd.name>
---
 net/mac80211/Makefile      |   3 +-
 net/mac80211/cfg.c         |   2 +-
 net/mac80211/ieee80211_i.h |   8 +-
 net/mac80211/scs.c         | 275 ++++++++++++++++++++++++++++++++++++++-
 net/mac80211/sta_info.c    |   2 +-
 net/mac80211/sta_info.h    |  49 +++++++-
 6 files changed, 338 insertions(+), 1 deletion(-)
 create mode 100644 net/mac80211/scs.c

diff --git a/net/mac80211/Makefile b/net/mac80211/Makefile
index 36f1e3e2222b..8f8729e44c5f 100644
--- a/net/mac80211/Makefile
+++ b/net/mac80211/Makefile
@@ -35,7 +35,8 @@ mac80211-y := \
 	tdls.o \
 	ocb.o \
 	airtime.o \
-	eht.o uhr.o nan.o
+	eht.o uhr.o nan.o \
+	scs.o
 
 mac80211-$(CONFIG_MAC80211_LEDS) += led.o
 mac80211-$(CONFIG_MAC80211_DEBUGFS) += \
diff --git a/net/mac80211/cfg.c b/net/mac80211/cfg.c
index 6e466f8e1653..e3bbe2aa0522 100644
--- a/net/mac80211/cfg.c
+++ b/net/mac80211/cfg.c
@@ -6344,6 +6344,8 @@ const struct cfg80211_ops mac80211_config_ops = {
 	.end_cac = ieee80211_end_cac,
 	.channel_switch = ieee80211_channel_switch,
 	.set_qos_map = ieee80211_set_qos_map,
+	.set_scs = ieee80211_set_scs,
+	.set_mscs = ieee80211_set_mscs,
 	.set_ap_chanwidth = ieee80211_set_ap_chanwidth,
 	.add_tx_ts = ieee80211_add_tx_ts,
 	.del_tx_ts = ieee80211_del_tx_ts,
diff --git a/net/mac80211/ieee80211_i.h b/net/mac80211/ieee80211_i.h
index 9906a62ee99c..e16ced6cbd58 100644
--- a/net/mac80211/ieee80211_i.h
+++ b/net/mac80211/ieee80211_i.h
@@ -2259,6 +2259,14 @@ void ieee80211_recalc_txpower(struct ieee80211_link_data *link,
 			      bool update_bss);
 void ieee80211_recalc_offload(struct ieee80211_local *local);
 
+/* SCS and MSCS */
+int ieee80211_set_scs(struct wiphy *wiphy, struct net_device *dev,
+		      const u8 *peer, struct cfg80211_scs_desc * const *desc,
+		      u16 *status, u8 n_desc);
+int ieee80211_set_mscs(struct wiphy *wiphy, struct net_device *dev,
+		       const u8 *peer, struct cfg80211_mscs_desc *desc);
+void ieee80211_sta_scs_free(struct sta_info *sta);
+
 /* link handling */
 void ieee80211_link_setup(struct ieee80211_link_data *link);
 void ieee80211_link_init(struct ieee80211_sub_if_data *sdata,
diff --git a/net/mac80211/scs.c b/net/mac80211/scs.c
new file mode 100644
index 000000000000..e1f4c45dfc30
--- /dev/null
+++ b/net/mac80211/scs.c
@@ -0,0 +1,275 @@
+// SPDX-License-Identifier: GPL-2.0-only
+/*
+ * Stream classification service (SCS) and mirrored SCS (MSCS)
+ *
+ * Copyright (C) 2026 Felix Fietkau <nbd@nbd.name>
+ */
+#include <linux/ieee80211.h>
+#include <net/cfg80211.h>
+#include "ieee80211_i.h"
+#include "sta_info.h"
+
+/* An hour, in TUs of 1024 microseconds */
+#define IEEE80211_MSCS_TIMEOUT_MAX_TU	3515625
+
+#define IEEE80211_MSCS_MAX		16
+
+static size_t ieee80211_scs_rule_size(const struct cfg80211_scs_desc *desc)
+{
+	return ALIGN(struct_size(desc, tclas, desc->n_tclas) +
+		     desc->qos_char_len, __alignof__(*desc));
+}
+
+static void *ieee80211_scs_rule_copy(const struct cfg80211_scs_desc *src,
+				     void *pos)
+{
+	size_t len = struct_size(src, tclas, src->n_tclas);
+	struct cfg80211_scs_desc *dst = pos;
+
+	memcpy(dst, src, len);
+	pos += len;
+
+	if (src->qos_char_len) {
+		memcpy(pos, src->qos_char, src->qos_char_len);
+		dst->qos_char = pos;
+	} else {
+		dst->qos_char = NULL;
+	}
+
+	return PTR_ALIGN(pos + src->qos_char_len, __alignof__(*dst));
+}
+
+static u8 ieee80211_scs_rule_find(struct cfg80211_scs_desc * const *rule,
+				  u8 n_rules, u8 id)
+{
+	u8 i;
+
+	for (i = 0; i < n_rules; i++)
+		if (rule[i]->id == id)
+			break;
+
+	return i;
+}
+
+static size_t ieee80211_scs_sta_head(unsigned int n_rules)
+{
+	struct ieee80211_scs_sta *scs;
+
+	return ALIGN(struct_size(scs, rule, n_rules),
+		     __alignof__(struct cfg80211_scs_desc));
+}
+
+/*
+ * Size for every rule that can end up in the set, so that nothing can fail
+ * once the request is applied.
+ */
+static size_t ieee80211_scs_sta_size(const struct ieee80211_scs_sta *old,
+				     struct cfg80211_scs_desc * const *desc,
+				     u8 n_desc, unsigned int n_alloc)
+{
+	size_t size = ieee80211_scs_sta_head(n_alloc);
+	unsigned int i;
+
+	for (i = 0; old && i < old->n_rules; i++)
+		size += ieee80211_scs_rule_size(old->rule[i]);
+
+	for (i = 0; i < n_desc; i++)
+		size += ieee80211_scs_rule_size(desc[i]);
+
+	return size;
+}
+
+/*
+ * @rule points into the old set and into the request, so copy each rule.
+ * The block was sized for @n_alloc rules.
+ */
+static void ieee80211_scs_sta_fill(struct ieee80211_scs_sta *scs,
+				   struct cfg80211_scs_desc * const *rule,
+				   u8 n_rules, unsigned int n_alloc)
+{
+	void *pos = (void *)scs + ieee80211_scs_sta_head(n_alloc);
+	u8 i;
+
+	/* Set before the array is filled, for __counted_by() */
+	scs->n_rules = n_rules;
+
+	for (i = 0; i < n_rules; i++) {
+		scs->rule[i] = pos;
+		pos = ieee80211_scs_rule_copy(rule[i], pos);
+	}
+}
+
+int ieee80211_set_scs(struct wiphy *wiphy, struct net_device *dev,
+		      const u8 *peer, struct cfg80211_scs_desc * const *desc,
+		      u16 *status, u8 n_desc)
+{
+	struct ieee80211_sub_if_data *sdata = IEEE80211_DEV_TO_SUB_IF(dev);
+	struct ieee80211_scs_sta *scs, *old;
+	struct cfg80211_scs_desc **rule;
+	struct sta_info *sta;
+	unsigned int n_alloc;
+	u8 i, n_rules = 0;
+
+	lockdep_assert_wiphy(wiphy);
+
+	/* Only an AP classifies the downlink */
+	if (!sdata->bss)
+		return -EOPNOTSUPP;
+
+	sta = sta_info_get_bss(sdata, peer);
+	if (!sta)
+		return -ENOENT;
+
+	old = wiphy_dereference(wiphy, sta->scs);
+
+	/* One rule per SCSID bounds the size of the new set */
+	n_alloc = (old ? old->n_rules : 0) + n_desc;
+
+	rule = kcalloc(n_alloc, sizeof(*rule), GFP_KERNEL);
+	if (!rule)
+		return -ENOMEM;
+
+	/* 255 rules with 255 classifiers each exceed what kmalloc hands out */
+	scs = kvzalloc(ieee80211_scs_sta_size(old, desc, n_desc, n_alloc),
+		       GFP_KERNEL);
+	if (!scs) {
+		kfree(rule);
+		return -ENOMEM;
+	}
+
+	if (old) {
+		n_rules = old->n_rules;
+		memcpy(rule, old->rule, n_rules * sizeof(*rule));
+	}
+
+	for (i = 0; i < n_desc; i++) {
+		u8 at = ieee80211_scs_rule_find(rule, n_rules, desc[i]->id);
+
+		if (desc[i]->req_type == NL80211_SCS_REQ_REMOVE) {
+			if (at < n_rules) {
+				n_rules--;
+				memmove(&rule[at], &rule[at + 1],
+					(n_rules - at) * sizeof(*rule));
+			}
+
+			continue;
+		}
+
+		if (at < n_rules)
+			rule[at] = desc[i];
+		else
+			rule[n_rules++] = desc[i];
+	}
+
+	if (n_rules) {
+		ieee80211_scs_sta_fill(scs, rule, n_rules, n_alloc);
+	} else {
+		kvfree(scs);
+		scs = NULL;
+	}
+
+	kfree(rule);
+
+	rcu_assign_pointer(sta->scs, scs);
+	if (old)
+		kvfree_rcu(old, rcu_head);
+
+	return 0;
+}
+
+static struct ieee80211_mscs_sta *
+ieee80211_mscs_find(struct sta_info *sta, const u8 *client, bool configured)
+{
+	struct ieee80211_mscs_sta *mscs;
+
+	lockdep_assert_wiphy(sta->local->hw.wiphy);
+
+	list_for_each_entry(mscs, &sta->mscs, list)
+		if (mscs->configured == configured &&
+		    ether_addr_equal(mscs->client, client))
+			return mscs;
+
+	return NULL;
+}
+
+int ieee80211_set_mscs(struct wiphy *wiphy, struct net_device *dev,
+		       const u8 *peer, struct cfg80211_mscs_desc *desc)
+{
+	struct ieee80211_sub_if_data *sdata = IEEE80211_DEV_TO_SUB_IF(dev);
+	struct ieee80211_mscs_sta *mscs, *old;
+	struct sta_info *sta;
+	const u8 *client;
+	u32 tu;
+
+	lockdep_assert_wiphy(wiphy);
+
+	sta = sta_info_get_bss(sdata, peer);
+	if (!sta)
+		return -ENOENT;
+
+	client = is_zero_ether_addr(desc->client) ? sta->sta.addr : desc->client;
+	old = ieee80211_mscs_find(sta, client, desc->configured);
+
+	if (desc->req_type == NL80211_SCS_REQ_REMOVE) {
+		if (!old)
+			return 0;
+
+		list_del_rcu(&old->list);
+		sta->n_mscs--;
+		kfree_rcu(old, rcu_head);
+
+		return 0;
+	}
+
+	if (!old && sta->n_mscs >= IEEE80211_MSCS_MAX)
+		return -ENOSPC;
+
+	mscs = kzalloc_obj(*mscs);
+	if (!mscs)
+		return -ENOMEM;
+
+	ether_addr_copy(mscs->client, client);
+	mscs->configured = desc->configured;
+	mscs->layout = desc->fields;
+	mscs->up_bitmap = desc->up_bitmap;
+	mscs->up_limit = desc->up_limit;
+
+	/*
+	 * Cap at an hour to keep tu * 1024 within the unsigned int that
+	 * usecs_to_jiffies() takes. A timeout of zero jiffies would expire an
+	 * entry at the next collection.
+	 */
+	tu = min(desc->stream_timeout, IEEE80211_MSCS_TIMEOUT_MAX_TU);
+	mscs->timeout = max(1UL, usecs_to_jiffies(tu * 1024));
+
+	if (old) {
+		list_replace_rcu(&old->list, &mscs->list);
+		kfree_rcu(old, rcu_head);
+	} else {
+		/* The station's own requests take precedence (EasyMesh 20.2.5) */
+		if (mscs->configured)
+			list_add_tail_rcu(&mscs->list, &sta->mscs);
+		else
+			list_add_rcu(&mscs->list, &sta->mscs);
+
+		sta->n_mscs++;
+	}
+
+	return 0;
+}
+
+void ieee80211_sta_scs_free(struct sta_info *sta)
+{
+	struct ieee80211_mscs_sta *mscs, *tmp;
+	struct ieee80211_scs_sta *scs;
+
+	/* Nothing can reach the station any more, so no lock is needed */
+	scs = rcu_dereference_raw(sta->scs);
+	RCU_INIT_POINTER(sta->scs, NULL);
+	kvfree(scs);
+
+	list_for_each_entry_safe(mscs, tmp, &sta->mscs, list) {
+		list_del(&mscs->list);
+		kfree(mscs);
+	}
+}
diff --git a/net/mac80211/sta_info.c b/net/mac80211/sta_info.c
index 23166fc39729..f16ae997cee8 100644
--- a/net/mac80211/sta_info.c
+++ b/net/mac80211/sta_info.c
@@ -508,6 +508,7 @@ void sta_info_free(struct ieee80211_local *local, struct sta_info *sta)
 	kfree(sta->mesh);
 #endif
 
+	ieee80211_sta_scs_free(sta);
 	sta_info_free_link(&sta->deflink);
 	kfree(sta);
 }
@@ -662,6 +663,7 @@ __sta_info_alloc(struct ieee80211_sub_if_data *sdata,
 	sta->sta.cur = &sta->sta.deflink.agg;
 
 	spin_lock_init(&sta->lock);
+	INIT_LIST_HEAD(&sta->mscs);
 	spin_lock_init(&sta->ps_lock);
 	INIT_WORK(&sta->drv_deliver_wk, sta_deliver_ps_frames);
 	wiphy_work_init(&sta->ampdu_mlme.work, ieee80211_ba_session_work);
diff --git a/net/mac80211/sta_info.h b/net/mac80211/sta_info.h
index 8c6a9fee6b29..b9ff5e117115 100644
--- a/net/mac80211/sta_info.h
+++ b/net/mac80211/sta_info.h
@@ -637,6 +637,47 @@ struct ieee80211_sta_removed_link_stats {
 };
 
 /**
+ * struct ieee80211_scs_sta - the SCS rule set of one station
+ *
+ * @rcu_head: for freeing
+ * @n_rules: number of entries in @rule
+ * @rule: the active descriptors, in the order they were installed
+ *
+ * One allocation holds this structure, the descriptors it points to and their
+ * QoS Characteristics octets, so the whole set has one lifetime.
+ */
+struct ieee80211_scs_sta {
+	struct rcu_head rcu_head;
+	u8 n_rules;
+	struct cfg80211_scs_desc *rule[] __counted_by(n_rules);
+};
+
+/**
+ * struct ieee80211_mscs_sta - one MSCS of a station
+ *
+ * @list: linkage in &sta_info.mscs
+ * @rcu_head: for freeing
+ * @client: the host whose flows are mirrored, the station's own address
+ *	unless the MSCS names a host behind a 4-address station
+ * @configured: the AP configured the MSCS on behalf of the network, not at
+ *	the request of the station
+ * @layout: classifier parameters, a bitmap of &enum cfg80211_flow_field
+ * @up_bitmap: user priorities that the AP learns from, one bit each
+ * @up_limit: ceiling for the assigned user priority
+ * @timeout: minimum lifetime of a learned value, in jiffies
+ */
+struct ieee80211_mscs_sta {
+	struct list_head list;
+	struct rcu_head rcu_head;
+	u8 client[ETH_ALEN];
+	bool configured;
+	u32 layout;
+	u8 up_bitmap;
+	u8 up_limit;
+	unsigned long timeout;
+};
+
+/**
  * struct sta_info - STA information
  *
  * This structure collects information about a station that
@@ -696,6 +737,10 @@ struct ieee80211_sta_removed_link_stats {
  *
  * @fast_tx: TX fastpath information
  * @fast_rx: RX fastpath information
+ * @scs: SCS rule set, or %NULL
+ * @mscs: the MSCS list, an RCU list that the wiphy mutex protects. Those that
+ *	the station requested come before the configured ones.
+ * @n_mscs: number of entries in @mscs
  * @tdls_chandef: a TDLS peer can have a wider chandef that is compatible to
  *	the BSS one.
  * @frags: fragment cache
@@ -732,6 +777,10 @@ struct sta_info {
 	struct ieee80211_fast_tx __rcu *fast_tx;
 	struct ieee80211_fast_rx __rcu *fast_rx;
 
+	struct ieee80211_scs_sta __rcu *scs;
+	struct list_head mscs;
+	u8 n_mscs;
+
 #ifdef CONFIG_MAC80211_MESH
 	struct mesh_sta *mesh;
 #endif
-- 
git-series 0.9.1
