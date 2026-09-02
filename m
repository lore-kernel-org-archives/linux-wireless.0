Received: from nbd.name (nbd.name [46.4.11.11])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C63AA38644D
	for <linux-wireless@vger.kernel.org>; Wed,  2 Sep 2026 08:46:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=46.4.11.11
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788338779; cv=none; b=DLUkH5Jg1wbgaKde8w2aTdcqRlB9dwY1Pt+g+eI0XRP2kbQLuq6DDsWHB37G7bvCeyd7344AYPveeXgX4bJpLNhFhB8QhBpnWfu2nyJOk3VA7OmQMe4/KNAuL3W8FJfcVaklON5PL/adjpx3E/F2QHibFsFWFpf5nPmW/PFBilw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788338779; c=relaxed/simple;
	bh=taog7Cem6+1aXAah4MU3BggaW0Z5MU/cixDAbbjH9yU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=HhNqVWSsLnG7sD4Kgke+KfFCr3AK+PL1M82IgnFFqx7vaJzLmUdk18nXBOZx4pnj5sDYosTK+D5/CS7lZO07iu8WfkKGbiZuC6rAd2uVC3inGtXlgUbDTmmKqk1UhhTdfdyp8iG4DIWXt9hHBWWeMXxfs543NFRkII1tvJ4yqg4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=nbd.name; spf=pass smtp.mailfrom=nbd.name; dkim=pass (1024-bit key) header.d=nbd.name header.i=@nbd.name header.b=kzaSvbQg; arc=none smtp.client-ip=46.4.11.11
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=nbd.name
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=nbd.name
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=nbd.name header.i=@nbd.name header.b="kzaSvbQg"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=nbd.name;
	s=20160729; h=Content-Transfer-Encoding:MIME-Version:References:In-Reply-To:
	Message-ID:Date:Subject:Cc:To:From:Sender:Reply-To:Content-Type:Content-ID:
	Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
	:Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
	List-Post:List-Owner:List-Archive;
	bh=EUH2aVMZPAUEzn0Zj1FXeQbfQRfLbMOwCaHk1VWp0Ps=; b=kzaSvbQgXrv7dQRrmW5s5WNZmS
	uYRk1j/Ptts24Aao079yDgNnKieqkvibMnCvk2FXQbS/jzxtocSYXANwOX4gXNNMRv+8DsEnogB6A
	HzkhxqrCyyOivjiukRNJ+q2Cs/jO+dTMhZcbsFHoSq6cY2e+2ZL3ZXmxeEpgOZBhZA8c=;
Received: from p200300cadf14d1000000000000000162.dip0.t-ipconnect.de ([2003:ca:df14:d100::162] helo=localhost.localdomain)
	by ds12 with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
	(Exim 4.96)
	(envelope-from <nbd@nbd.name>)
	id 1x1gbn-00Cwkn-0D;
	Wed, 02 Sep 2026 10:46:15 +0200
From: Felix Fietkau <nbd@nbd.name>
To: linux-wireless@vger.kernel.org
Cc: johannes@sipsolutions.net
Subject: [RFC PATCH 08/15] wifi: mac80211: add SCS and MSCS rule storage
Date: Wed,  2 Sep 2026 10:46:03 +0200
Message-ID: <4f4886f09b8b980fa18e2e92d10675388c318248.1788338716.git-series.nbd@nbd.name>
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

Implement the set_scs and set_mscs cfg80211 ops.

A request edits the rule set of one station, so the result mixes its
descriptors with those of earlier requests. mac80211 therefore rebuilds
the set whole, into one allocation that owns every rule it holds. That
gives the set a single lifetime and keeps the ownership rule simple.

An accepted removal answers with TCLAS_PROCESSING_TERMINATED, which the
standard reserves for it.

Signed-off-by: Felix Fietkau <nbd@nbd.name>
---
 net/mac80211/Makefile      |   3 +-
 net/mac80211/cfg.c         |   2 +-
 net/mac80211/ieee80211_i.h |   8 +-
 net/mac80211/scs.c         | 220 ++++++++++++++++++++++++++++++++++++++-
 net/mac80211/sta_info.c    |   1 +-
 net/mac80211/sta_info.h    |  38 +++++++-
 6 files changed, 271 insertions(+), 1 deletion(-)
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
index 23f4f9ec86d0..aea6bce2afa6 100644
--- a/net/mac80211/cfg.c
+++ b/net/mac80211/cfg.c
@@ -6059,6 +6059,8 @@ const struct cfg80211_ops mac80211_config_ops = {
 	.end_cac = ieee80211_end_cac,
 	.channel_switch = ieee80211_channel_switch,
 	.set_qos_map = ieee80211_set_qos_map,
+	.set_scs = ieee80211_set_scs,
+	.set_mscs = ieee80211_set_mscs,
 	.set_ap_chanwidth = ieee80211_set_ap_chanwidth,
 	.add_tx_ts = ieee80211_add_tx_ts,
 	.del_tx_ts = ieee80211_del_tx_ts,
diff --git a/net/mac80211/ieee80211_i.h b/net/mac80211/ieee80211_i.h
index 5761e9621491..31a630e68a2b 100644
--- a/net/mac80211/ieee80211_i.h
+++ b/net/mac80211/ieee80211_i.h
@@ -2204,6 +2204,14 @@ void ieee80211_recalc_txpower(struct ieee80211_link_data *link,
 			      bool update_bss);
 void ieee80211_recalc_offload(struct ieee80211_local *local);
 
+/* SCS and MSCS */
+int ieee80211_set_scs(struct wiphy *wiphy, struct net_device *dev,
+		      const u8 *peer, struct cfg80211_scs_desc * const *desc,
+		      struct cfg80211_scs_result *res, u8 n_desc);
+int ieee80211_set_mscs(struct wiphy *wiphy, struct net_device *dev,
+		       const u8 *peer, struct cfg80211_mscs_desc *desc);
+void ieee80211_sta_scs_free(struct sta_info *sta);
+
 /* link handling */
 void ieee80211_link_setup(struct ieee80211_link_data *link);
 void ieee80211_link_init(struct ieee80211_sub_if_data *sdata,
diff --git a/net/mac80211/scs.c b/net/mac80211/scs.c
new file mode 100644
index 000000000000..d2daefb8e90c
--- /dev/null
+++ b/net/mac80211/scs.c
@@ -0,0 +1,220 @@
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
+static size_t ieee80211_scs_rule_size(const struct cfg80211_scs_desc *desc)
+{
+	return ALIGN(struct_size(desc, tclas, desc->n_tclas) +
+		     desc->qos_char_len, __alignof__(*desc));
+}
+
+/* Copy one rule to @pos and return the aligned octet after it */
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
+/*
+ * One request is an edit of the rule set, so the result mixes descriptors of
+ * this request with descriptors of earlier ones. @rule therefore holds a mix
+ * of pointers into the old set and pointers the caller owns, and the block
+ * built from it owns a copy of every one of them.
+ */
+static struct ieee80211_scs_sta *
+ieee80211_scs_sta_build(struct cfg80211_scs_desc * const *rule, u8 n_rules)
+{
+	struct ieee80211_scs_sta *scs;
+	size_t head, size;
+	void *pos;
+	u8 i;
+
+	if (!n_rules)
+		return NULL;
+
+	head = ALIGN(struct_size(scs, rule, n_rules), __alignof__(**rule));
+
+	size = head;
+	for (i = 0; i < n_rules; i++)
+		size += ieee80211_scs_rule_size(rule[i]);
+
+	/*
+	 * A station may hold 255 rules of 255 classifiers, which is past what
+	 * the page allocator hands out in one piece.
+	 */
+	scs = kvzalloc(size, GFP_KERNEL);
+	if (!scs)
+		return ERR_PTR(-ENOMEM);
+
+	/* Set before the array is filled, for __counted_by() */
+	scs->n_rules = n_rules;
+
+	pos = (void *)scs + head;
+	for (i = 0; i < n_rules; i++) {
+		scs->rule[i] = pos;
+		pos = ieee80211_scs_rule_copy(rule[i], pos);
+	}
+
+	return scs;
+}
+
+int ieee80211_set_scs(struct wiphy *wiphy, struct net_device *dev,
+		      const u8 *peer, struct cfg80211_scs_desc * const *desc,
+		      struct cfg80211_scs_result *res, u8 n_desc)
+{
+	struct ieee80211_sub_if_data *sdata = IEEE80211_DEV_TO_SUB_IF(dev);
+	struct ieee80211_scs_sta *scs, *old;
+	struct cfg80211_scs_desc **rule;
+	struct sta_info *sta;
+	u8 i, n_rules = 0;
+
+	lockdep_assert_wiphy(wiphy);
+
+	sta = sta_info_get_bss(sdata, peer);
+	if (!sta)
+		return -ENOENT;
+
+	old = wiphy_dereference(wiphy, sta->scs);
+
+	/*
+	 * Every rule carries an SCSID of its own and an SCSID is 1 to 255, so
+	 * this bounds the working array, and the resulting set with it.
+	 */
+	rule = kcalloc((old ? old->n_rules : 0) + n_desc, sizeof(*rule),
+		       GFP_KERNEL);
+	if (!rule)
+		return -ENOMEM;
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
+			/* 11.25.2 answers any removal with its own status */
+			res[i].status = WLAN_STATUS_TCLAS_PROCESSING_TERMINATED;
+
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
+	scs = ieee80211_scs_sta_build(rule, n_rules);
+	kfree(rule);
+	if (IS_ERR(scs))
+		return PTR_ERR(scs);
+
+	rcu_assign_pointer(sta->scs, scs);
+	if (old)
+		kvfree_rcu(old, rcu_head);
+
+	return 0;
+}
+
+int ieee80211_set_mscs(struct wiphy *wiphy, struct net_device *dev,
+		       const u8 *peer, struct cfg80211_mscs_desc *desc)
+{
+	struct ieee80211_sub_if_data *sdata = IEEE80211_DEV_TO_SUB_IF(dev);
+	struct ieee80211_mscs_sta *mscs = NULL, *old;
+	struct sta_info *sta;
+	u32 tu;
+
+	lockdep_assert_wiphy(wiphy);
+
+	sta = sta_info_get_bss(sdata, peer);
+	if (!sta)
+		return -ENOENT;
+
+	if (desc->req_type != NL80211_SCS_REQ_REMOVE) {
+		mscs = kzalloc_obj(*mscs);
+		if (!mscs)
+			return -ENOMEM;
+
+		mscs->layout = desc->fields;
+		mscs->up_bitmap = desc->up_bitmap;
+		mscs->up_limit = desc->up_limit;
+
+		/*
+		 * The field is a u32 of TUs, up to about 50 days, which
+		 * jiffies arithmetic cannot carry: time_after_eq() needs the
+		 * difference to stay well inside the wrap. 11.25.3 only
+		 * permits dropping a variable once the timeout has passed and
+		 * nowhere requires keeping one until then, so capping is a
+		 * choice about usefulness rather than conformance, and an idle
+		 * hour leaves nothing worth keeping. A short timeout rounds
+		 * down to nothing at a low HZ, and zero would mean never, so
+		 * keep a jiffy.
+		 */
+		tu = min(desc->stream_timeout, IEEE80211_MSCS_TIMEOUT_MAX_TU);
+		mscs->timeout = max(1UL, usecs_to_jiffies(tu * 1024));
+	}
+
+	old = wiphy_dereference(wiphy, sta->mscs);
+	rcu_assign_pointer(sta->mscs, mscs);
+	if (old)
+		kfree_rcu(old, rcu_head);
+
+	return 0;
+}
+
+void ieee80211_sta_scs_free(struct sta_info *sta)
+{
+	struct ieee80211_mscs_sta *mscs;
+	struct ieee80211_scs_sta *scs;
+
+	scs = rcu_dereference_raw(sta->scs);
+	RCU_INIT_POINTER(sta->scs, NULL);
+	kvfree(scs);
+
+	mscs = rcu_dereference_raw(sta->mscs);
+	RCU_INIT_POINTER(sta->mscs, NULL);
+	kfree(mscs);
+}
diff --git a/net/mac80211/sta_info.c b/net/mac80211/sta_info.c
index fdf00cbf49d8..e14d78b002f1 100644
--- a/net/mac80211/sta_info.c
+++ b/net/mac80211/sta_info.c
@@ -508,6 +508,7 @@ void sta_info_free(struct ieee80211_local *local, struct sta_info *sta)
 	kfree(sta->mesh);
 #endif
 
+	ieee80211_sta_scs_free(sta);
 	sta_info_free_link(&sta->deflink);
 	kfree(sta);
 }
diff --git a/net/mac80211/sta_info.h b/net/mac80211/sta_info.h
index ee0d32877c5b..2682b3095474 100644
--- a/net/mac80211/sta_info.h
+++ b/net/mac80211/sta_info.h
@@ -635,6 +635,39 @@ struct ieee80211_sta_removed_link_stats {
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
+ * struct ieee80211_mscs_sta - the MSCS of one station
+ *
+ * @rcu_head: for freeing
+ * @layout: classifier parameters, a bitmap of &enum cfg80211_flow_field
+ * @up_bitmap: user priorities that the AP learns from, one bit each
+ * @up_limit: ceiling for the assigned user priority
+ * @timeout: minimum lifetime of a learned value, in jiffies
+ */
+struct ieee80211_mscs_sta {
+	struct rcu_head rcu_head;
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
@@ -694,6 +727,8 @@ struct ieee80211_sta_removed_link_stats {
  *
  * @fast_tx: TX fastpath information
  * @fast_rx: RX fastpath information
+ * @scs: SCS rule set, or %NULL
+ * @mscs: MSCS parameters, or %NULL
  * @tdls_chandef: a TDLS peer can have a wider chandef that is compatible to
  *	the BSS one.
  * @frags: fragment cache
@@ -730,6 +765,9 @@ struct sta_info {
 	struct ieee80211_fast_tx __rcu *fast_tx;
 	struct ieee80211_fast_rx __rcu *fast_rx;
 
+	struct ieee80211_scs_sta __rcu *scs;
+	struct ieee80211_mscs_sta __rcu *mscs;
+
 #ifdef CONFIG_MAC80211_MESH
 	struct mesh_sta *mesh;
 #endif
-- 
git-series 0.9.1
