Received: from nbd.name (nbd.name [46.4.11.11])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 782F83AA1B6
	for <linux-wireless@vger.kernel.org>; Wed,  2 Sep 2026 08:46:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=46.4.11.11
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788338781; cv=none; b=BGKWkqPPUfdb1sSYCg0ggZkJu7npToQvYk4f0YysrlgRFiHJEQwH2sCEb8/v7kCvqrkLFo8ESQFM9ljc4V+ZLN9MZ/O01n71VMNcFKcImhcwkE0eBqoA3tUkIEP0aNkWFViGXbE6ZWijDbWJWdh6GgxPAfde73jVA/q/MU02+Tw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788338781; c=relaxed/simple;
	bh=d/83WMqzMi/h0R+wy/Z7Kn0GdXFeGV17bQHjexQ5goc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=DDvWCxOjsnGKF3/YXG6eNyae6EhLkght+n3eV+IXo44YN9wFY5U1PQbNPgocurN3iywe7XxCDzzhSZhdltqLF2uaOAIInA5G3rkueaaFOX1tP1R75tSwD4/ri+J38fBrfh4V5o1CEiuLgRePYoKJ8Th57WwhwnQ0CtbWfNnpAAk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=nbd.name; spf=pass smtp.mailfrom=nbd.name; dkim=pass (1024-bit key) header.d=nbd.name header.i=@nbd.name header.b=CxbA1SC/; arc=none smtp.client-ip=46.4.11.11
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=nbd.name
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=nbd.name
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=nbd.name header.i=@nbd.name header.b="CxbA1SC/"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=nbd.name;
	s=20160729; h=Content-Transfer-Encoding:MIME-Version:References:In-Reply-To:
	Message-ID:Date:Subject:Cc:To:From:Sender:Reply-To:Content-Type:Content-ID:
	Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
	:Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
	List-Post:List-Owner:List-Archive;
	bh=xlpzcWL/2kqJy5CeKm6eDhJ+V8xGrGGrNyb/vqBlPl0=; b=CxbA1SC/V1FdbnOhC2sHdQuEjh
	kEhfGKAxZa924GcPdTlhsCy4PYOzTde3OvtUI5H2CM8vn3PWQiT17QzNneSwetS7wD4BixpcBtEPd
	k/XKWRRKc7KtXoqtzjPT/RNveGcczBH79WOZjHkWotdAPPQwMULgFTQnLECn2LLnGLNk=;
Received: from p200300cadf14d1000000000000000162.dip0.t-ipconnect.de ([2003:ca:df14:d100::162] helo=localhost.localdomain)
	by ds12 with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
	(Exim 4.96)
	(envelope-from <nbd@nbd.name>)
	id 1x1gbn-00Cwkn-2U;
	Wed, 02 Sep 2026 10:46:15 +0200
From: Felix Fietkau <nbd@nbd.name>
To: linux-wireless@vger.kernel.org
Cc: johannes@sipsolutions.net
Subject: [RFC PATCH 12/15] wifi: mac80211: add the sta_set_scs driver op
Date: Wed,  2 Sep 2026 10:46:07 +0200
Message-ID: <e1b373ba74facb4d24942d547cd77cf927a1ad9f.1788338716.git-series.nbd@nbd.name>
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

Hand the SCS descriptors of one request to the driver and let it answer
each of them. This is the only path by which the QoS Characteristics
element reaches a driver, which is its only consumer.

A driver declines a descriptor by writing a status into the result entry
of the same index, and mac80211 leaves that descriptor out of the set.
Only a driver can schedule a stream to what a traffic description asks
for, so accepting one it cannot serve would promise a station a guarantee
that nothing provides. 11.25.2 asks per SCSID, so the answer is per
descriptor too.

The reverse does not hold: classification runs in software whichever way
a driver answers, so a driver must not decline a descriptor merely
because it cannot offload the classifier.

Without the op, mac80211 declines every descriptor that carries a traffic
description for the same reason.

The driver answers before the set is published, and a declined change
keeps the descriptor it had, which 11.25.2 requires.

Signed-off-by: Felix Fietkau <nbd@nbd.name>
---
 include/net/mac80211.h     |  22 ++++++-
 net/mac80211/driver-ops.h  |  26 +++++++-
 net/mac80211/ieee80211_i.h |   1 +-
 net/mac80211/scs.c         | 142 +++++++++++++++++++++++++++++---------
 net/mac80211/trace.h       |  27 +++++++-
 net/mac80211/util.c        |   2 +-
 6 files changed, 189 insertions(+), 31 deletions(-)

diff --git a/include/net/mac80211.h b/include/net/mac80211.h
index 9d1fac6e8082..d9e4505ecb47 100644
--- a/include/net/mac80211.h
+++ b/include/net/mac80211.h
@@ -5083,6 +5083,28 @@ struct ieee80211_ops {
 			  struct cfg80211_pmsr_request *request);
 	void (*abort_pmsr)(struct ieee80211_hw *hw, struct ieee80211_vif *vif,
 			   struct cfg80211_pmsr_request *request);
+	/**
+	 * @sta_set_scs:
+	 * Called with the SCS descriptors one station requests, to answer each
+	 * in the result entry of the same index. Optional, and reached only
+	 * when the wiphy reports %NL80211_EXT_FEATURE_SCS; without it every
+	 * descriptor carrying a QoS Characteristics element is declined.
+	 *
+	 * - Results arrive zeroed, which is acceptance. Write only refusals.
+	 * - A negative return fails the whole request.
+	 * - Decline a traffic description that cannot be served, nothing else.
+	 *   A decline drops the descriptor whole, classifier included.
+	 * - A declined change keeps the previous descriptor of that SCSID.
+	 * - A removal is the cue to drop driver state. mac80211 answers it
+	 *   whatever the driver writes.
+	 * - A descriptor and its qos_char octets last only for the call.
+	 *
+	 * This callback may sleep.
+	 */
+	int (*sta_set_scs)(struct ieee80211_hw *hw, struct ieee80211_vif *vif,
+			   struct ieee80211_sta *sta,
+			   struct cfg80211_scs_desc * const *desc,
+			   struct cfg80211_scs_result *res, u8 n_desc);
 	int (*set_tid_config)(struct ieee80211_hw *hw,
 			      struct ieee80211_vif *vif,
 			      struct ieee80211_sta *sta,
diff --git a/net/mac80211/driver-ops.h b/net/mac80211/driver-ops.h
index f1c0b87fddd5..f7684e8db025 100644
--- a/net/mac80211/driver-ops.h
+++ b/net/mac80211/driver-ops.h
@@ -1552,6 +1552,32 @@ static inline void drv_del_nan_func(struct ieee80211_local *local,
 	trace_drv_return_void(local);
 }
 
+static inline int drv_sta_set_scs(struct ieee80211_local *local,
+				  struct ieee80211_sub_if_data *sdata,
+				  struct sta_info *sta,
+				  struct cfg80211_scs_desc * const *desc,
+				  struct cfg80211_scs_result *res, u8 n_desc)
+{
+	int ret;
+
+	might_sleep();
+	lockdep_assert_wiphy(local->hw.wiphy);
+
+	if (!local->ops->sta_set_scs || !sta->uploaded)
+		return 0;
+
+	sdata = get_bss_sdata(sdata);
+	if (!check_sdata_in_driver(sdata))
+		return -EIO;
+
+	trace_drv_sta_set_scs(local, sdata, &sta->sta, n_desc);
+	ret = local->ops->sta_set_scs(&local->hw, &sdata->vif, &sta->sta, desc,
+				      res, n_desc);
+	trace_drv_return_int(local, ret);
+
+	return ret;
+}
+
 static inline int drv_set_tid_config(struct ieee80211_local *local,
 				     struct ieee80211_sub_if_data *sdata,
 				     struct ieee80211_sta *sta,
diff --git a/net/mac80211/ieee80211_i.h b/net/mac80211/ieee80211_i.h
index b17fa83f2003..5990ea261a42 100644
--- a/net/mac80211/ieee80211_i.h
+++ b/net/mac80211/ieee80211_i.h
@@ -2214,6 +2214,7 @@ int ieee80211_set_scs(struct wiphy *wiphy, struct net_device *dev,
 		      struct cfg80211_scs_result *res, u8 n_desc);
 int ieee80211_set_mscs(struct wiphy *wiphy, struct net_device *dev,
 		       const u8 *peer, struct cfg80211_mscs_desc *desc);
+void ieee80211_sta_scs_reconfig(struct sta_info *sta);
 void ieee80211_sta_scs_free(struct sta_info *sta);
 bool ieee80211_flow_classify(struct sta_info *sta, struct sk_buff *skb);
 void ieee80211_flow_learn(struct ieee80211_rx_data *rx);
diff --git a/net/mac80211/scs.c b/net/mac80211/scs.c
index 439bbb2df923..794ce5c9a4c0 100644
--- a/net/mac80211/scs.c
+++ b/net/mac80211/scs.c
@@ -7,6 +7,7 @@
 #include <linux/ieee80211.h>
 #include <linux/module.h>
 #include <net/cfg80211.h>
+#include "driver-ops.h"
 #include "ieee80211_i.h"
 #include "sta_info.h"
 
@@ -48,6 +49,8 @@ static void *ieee80211_scs_rule_copy(const struct cfg80211_scs_desc *src,
 	struct cfg80211_scs_desc *dst = pos;
 
 	memcpy(dst, src, len);
+	/* A stored rule is in force, so handing it back is an install */
+	dst->req_type = NL80211_SCS_REQ_ADD;
 	pos += len;
 
 	if (src->qos_char_len) {
@@ -72,47 +75,57 @@ static u8 ieee80211_scs_rule_find(struct cfg80211_scs_desc * const *rule,
 	return i;
 }
 
+static size_t ieee80211_scs_sta_head(unsigned int n_rules)
+{
+	struct ieee80211_scs_sta *scs;
+
+	return ALIGN(struct_size(scs, rule, n_rules),
+		     __alignof__(struct cfg80211_scs_desc));
+}
+
 /*
- * One request is an edit of the rule set, so the result mixes descriptors of
- * this request with descriptors of earlier ones. @rule therefore holds a mix
- * of pointers into the old set and pointers the caller owns, and the block
- * built from it owns a copy of every one of them.
+ * Every rule that could end up in the set, counted before the driver is asked
+ * so that no allocation can fail once it has programmed what it accepted. A
+ * descriptor and the rule it would replace are both counted, because which of
+ * the two survives is the answer that has not been given yet.
  */
-static struct ieee80211_scs_sta *
-ieee80211_scs_sta_build(struct cfg80211_scs_desc * const *rule, u8 n_rules)
+static size_t ieee80211_scs_sta_size(const struct ieee80211_scs_sta *old,
+				     struct cfg80211_scs_desc * const *desc,
+				     u8 n_desc, unsigned int n_alloc)
 {
-	struct ieee80211_scs_sta *scs;
-	size_t head, size;
-	void *pos;
-	u8 i;
+	size_t size = ieee80211_scs_sta_head(n_alloc);
+	unsigned int i;
 
-	if (!n_rules)
-		return NULL;
+	for (i = 0; old && i < old->n_rules; i++)
+		size += ieee80211_scs_rule_size(old->rule[i]);
 
-	head = ALIGN(struct_size(scs, rule, n_rules), __alignof__(**rule));
+	for (i = 0; i < n_desc; i++)
+		size += ieee80211_scs_rule_size(desc[i]);
 
-	size = head;
-	for (i = 0; i < n_rules; i++)
-		size += ieee80211_scs_rule_size(rule[i]);
+	return size;
+}
 
-	/*
-	 * A station may hold 255 rules of 255 classifiers, which is past what
-	 * the page allocator hands out in one piece.
-	 */
-	scs = kvzalloc(size, GFP_KERNEL);
-	if (!scs)
-		return ERR_PTR(-ENOMEM);
+/*
+ * One request is an edit of the rule set, so the result mixes descriptors of
+ * this request with descriptors of earlier ones. @rule therefore holds a mix
+ * of pointers into the old set and pointers the caller owns, and the block
+ * built from it owns a copy of every one of them. It was sized for @n_alloc
+ * of them, which is what places the first copy.
+ */
+static void ieee80211_scs_sta_fill(struct ieee80211_scs_sta *scs,
+				   struct cfg80211_scs_desc * const *rule,
+				   u8 n_rules, unsigned int n_alloc)
+{
+	void *pos = (void *)scs + ieee80211_scs_sta_head(n_alloc);
+	u8 i;
 
 	/* Set before the array is filled, for __counted_by() */
 	scs->n_rules = n_rules;
 
-	pos = (void *)scs + head;
 	for (i = 0; i < n_rules; i++) {
 		scs->rule[i] = pos;
 		pos = ieee80211_scs_rule_copy(rule[i], pos);
 	}
-
-	return scs;
 }
 
 /**
@@ -412,7 +425,9 @@ int ieee80211_set_scs(struct wiphy *wiphy, struct net_device *dev,
 	struct ieee80211_scs_sta *scs, *old;
 	struct cfg80211_scs_desc **rule;
 	struct sta_info *sta;
+	unsigned int n_alloc;
 	u8 i, n_rules = 0;
+	int ret;
 
 	lockdep_assert_wiphy(wiphy);
 
@@ -426,11 +441,32 @@ int ieee80211_set_scs(struct wiphy *wiphy, struct net_device *dev,
 	 * Every rule carries an SCSID of its own and an SCSID is 1 to 255, so
 	 * this bounds the working array, and the resulting set with it.
 	 */
-	rule = kcalloc((old ? old->n_rules : 0) + n_desc, sizeof(*rule),
-		       GFP_KERNEL);
+	n_alloc = (old ? old->n_rules : 0) + n_desc;
+
+	rule = kcalloc(n_alloc, sizeof(*rule), GFP_KERNEL);
 	if (!rule)
 		return -ENOMEM;
 
+	scs = kvzalloc(ieee80211_scs_sta_size(old, desc, n_desc, n_alloc),
+		       GFP_KERNEL);
+	if (!scs) {
+		ret = -ENOMEM;
+		goto free;
+	}
+
+	/* Only what the driver takes is installed, so it answers first */
+	if (sdata->local->ops->sta_set_scs && sta->uploaded) {
+		ret = drv_sta_set_scs(sdata->local, sdata, sta, desc, res,
+				      n_desc);
+		if (ret)
+			goto free;
+	} else {
+		/* Only a driver reads a traffic description, so none is served */
+		for (i = 0; i < n_desc; i++)
+			if (desc[i]->qos_char)
+				res[i].status = WLAN_STATUS_REQUEST_DECLINED;
+	}
+
 	if (old) {
 		n_rules = old->n_rules;
 		memcpy(rule, old->rule, n_rules * sizeof(*rule));
@@ -452,22 +488,36 @@ int ieee80211_set_scs(struct wiphy *wiphy, struct net_device *dev,
 			continue;
 		}
 
+		/* 11.25.2 leaves a declined change with its earlier rule */
+		if (res[i].status != WLAN_STATUS_SUCCESS)
+			continue;
+
 		if (at < n_rules)
 			rule[at] = desc[i];
 		else
 			rule[n_rules++] = desc[i];
 	}
 
-	scs = ieee80211_scs_sta_build(rule, n_rules);
+	if (n_rules) {
+		ieee80211_scs_sta_fill(scs, rule, n_rules, n_alloc);
+	} else {
+		kvfree(scs);
+		scs = NULL;
+	}
+
 	kfree(rule);
-	if (IS_ERR(scs))
-		return PTR_ERR(scs);
 
 	rcu_assign_pointer(sta->scs, scs);
 	if (old)
 		kvfree_rcu(old, rcu_head);
 
 	return 0;
+
+free:
+	kvfree(scs);
+	kfree(rule);
+
+	return ret;
 }
 
 int ieee80211_set_mscs(struct wiphy *wiphy, struct net_device *dev,
@@ -536,6 +586,36 @@ int ieee80211_set_mscs(struct wiphy *wiphy, struct net_device *dev,
 	return 0;
 }
 
+/*
+ * A device that was restarted holds none of the streams it was serving, and
+ * 11.25.2 gives an AP no way to tell a station that one of its streams is
+ * gone, so the set goes down again. A refusal changes nothing at this point:
+ * the rule stays and mac80211 keeps classifying for it.
+ */
+void ieee80211_sta_scs_reconfig(struct sta_info *sta)
+{
+	struct ieee80211_local *local = sta->local;
+	struct ieee80211_scs_sta *scs;
+	u8 i;
+
+	lockdep_assert_wiphy(local->hw.wiphy);
+
+	scs = wiphy_dereference(local->hw.wiphy, sta->scs);
+	if (!scs)
+		return;
+
+	/*
+	 * One rule per call, so that the result the op insists on fits a local
+	 * and nothing here can fail. A path that cannot report a failure is
+	 * better off unable to have one.
+	 */
+	for (i = 0; i < scs->n_rules; i++) {
+		struct cfg80211_scs_result res = {};
+
+		drv_sta_set_scs(local, sta->sdata, sta, &scs->rule[i], &res, 1);
+	}
+}
+
 void ieee80211_sta_scs_free(struct sta_info *sta)
 {
 	struct ieee80211_mscs_sta *mscs;
diff --git a/net/mac80211/trace.h b/net/mac80211/trace.h
index 562a4964afa3..1e6026306fb2 100644
--- a/net/mac80211/trace.h
+++ b/net/mac80211/trace.h
@@ -1023,6 +1023,33 @@ DECLARE_EVENT_CLASS(sta_event,
 	)
 );
 
+TRACE_EVENT(drv_sta_set_scs,
+	TP_PROTO(struct ieee80211_local *local,
+		 struct ieee80211_sub_if_data *sdata,
+		 struct ieee80211_sta *sta, u8 n_desc),
+
+	TP_ARGS(local, sdata, sta, n_desc),
+
+	TP_STRUCT__entry(
+		LOCAL_ENTRY
+		VIF_ENTRY
+		STA_ENTRY
+		__field(u8, n_desc)
+	),
+
+	TP_fast_assign(
+		LOCAL_ASSIGN;
+		VIF_ASSIGN;
+		STA_ASSIGN;
+		__entry->n_desc = n_desc;
+	),
+
+	TP_printk(
+		LOCAL_PR_FMT  VIF_PR_FMT  STA_PR_FMT " %d descriptors",
+		LOCAL_PR_ARG, VIF_PR_ARG, STA_PR_ARG, __entry->n_desc
+	)
+);
+
 DEFINE_EVENT(sta_event, drv_sta_statistics,
 	TP_PROTO(struct ieee80211_local *local,
 		 struct ieee80211_sub_if_data *sdata,
diff --git a/net/mac80211/util.c b/net/mac80211/util.c
index a96078a6bfa2..7f347a3c6429 100644
--- a/net/mac80211/util.c
+++ b/net/mac80211/util.c
@@ -1744,6 +1744,8 @@ static void ieee80211_reconfig_stations(struct ieee80211_sub_if_data *sdata)
 		     state < sta->sta_state; state++)
 			WARN_ON(drv_sta_state(local, sta->sdata, sta, state,
 					      state + 1));
+
+		ieee80211_sta_scs_reconfig(sta);
 	}
 }
 
-- 
git-series 0.9.1
