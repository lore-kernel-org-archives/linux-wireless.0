Received: from nbd.name (nbd.name [46.4.11.11])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AFA75530E1B
	for <linux-wireless@vger.kernel.org>; Tue, 22 Sep 2026 10:13:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=46.4.11.11
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790072034; cv=none; b=bnOzVDikwyagVvuqnJGnPcZOkvkemuby/Nx+PTT8zUmVFTJDGrtvyDIGMu/YNRs9Qtw7WH9q/Iibl48AEaXuTW0oZvxcdlLqXY0qGE5qUUskjOA9mZg7k9mwVqoeW0nSGoUTC3vORiWTeOqO+SkbE8zO55kq8sU0tWjWpBTGhhA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790072034; c=relaxed/simple;
	bh=SCLzE9lUJLH1OxYiJ2bhGlmK9kU9ueXiA4AtCYGuh8o=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=FTPUU1zT/PmuwPEVSNlWFAcrcbkPqrMASz+1uUE5mnhnAY8dlJVlXNAOXNn3A/VoffmkjLdq5/gCbLXu/RqfeqFLCjdF2P7FZhCPHf+E+tzIHRvSD2EHXt8zIPKfD2sdSgJgp7GrZz0WyagbG5VpwSNYCnMEJv4F6HP1hTxVd0A=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=nbd.name; spf=pass smtp.mailfrom=nbd.name; dkim=pass (1024-bit key) header.d=nbd.name header.i=@nbd.name header.b=SLKH6lJf; arc=none smtp.client-ip=46.4.11.11
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=nbd.name
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=nbd.name
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=nbd.name header.i=@nbd.name header.b="SLKH6lJf"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=nbd.name;
	s=20160729; h=Content-Transfer-Encoding:MIME-Version:References:In-Reply-To:
	Message-ID:Date:Subject:Cc:To:From:Sender:Reply-To:Content-Type:Content-ID:
	Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
	:Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
	List-Post:List-Owner:List-Archive;
	bh=7I7T7CpuSM2AhIbIik0ukOULXAWGv8njlBu4N+HOMsI=; b=SLKH6lJfNc7e30B6Gf3az0cTpz
	Vy4PNDnSf9bmXC9aAc0Fjbw5zuWehLtHTXfoQilsDAShT5fWkgiBwDhj84tTSrulHEVwFsBnOIONm
	g07dUcbgvwa7nenDmJIITTwNItbGAVCUCEI7p774vx62d0cCkZlTe9MK1Wt00wKNvNyQ=;
Received: from p200300cadf12010000000000000005bb.dip0.t-ipconnect.de ([2003:ca:df12:100::5bb] helo=localhost.localdomain)
	by ds12 with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
	(Exim 4.96)
	(envelope-from <nbd@nbd.name>)
	id 1x8xVV-00807z-2G;
	Tue, 22 Sep 2026 12:13:49 +0200
From: Felix Fietkau <nbd@nbd.name>
To: linux-wireless@vger.kernel.org
Cc: johannes@sipsolutions.net,
	vivek.chettri@oss.qualcomm.com,
	bhagavathi.pillai@oss.qualcomm.com,
	ripan.deuri@oss.qualcomm.com
Subject: [RFC PATCH v2 13/16] wifi: mac80211: add the sta_set_scs driver op
Date: Tue, 22 Sep 2026 12:13:40 +0200
Message-ID: <15e4778d5f03bcd162d446c474149e1ec14b07f6.1790071773.git-series.nbd@nbd.name>
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

Pass the SCS descriptors of a request to the driver and let it answer
each of them. This is the only path by which the QoS Characteristics
element reaches a driver.

The classifier runs in software whatever the driver answers, but only
the driver can schedule a stream according to its traffic description.
A driver therefore declines a descriptor only when it cannot serve the
traffic description. mac80211 then leaves that descriptor out of the
set, and a declined change keeps the rule of that SCSID. Without the
op, or before the station is uploaded, mac80211 declines every
descriptor that carries a traffic description.

After a hardware restart the device lost every stream, so each stored
rule is passed to the driver again as an add. A refusal at that point
changes nothing, since the acceptance already went out to the peer.

Signed-off-by: Felix Fietkau <nbd@nbd.name>
---
 include/net/mac80211.h     |  28 +++++++++-
 net/mac80211/driver-ops.h  |  26 ++++++++-
 net/mac80211/ieee80211_i.h |   1 +-
 net/mac80211/scs.c         | 124 ++++++++++++++++++++++++++++++--------
 net/mac80211/trace.h       |  27 ++++++++-
 net/mac80211/util.c        |   2 +-
 6 files changed, 184 insertions(+), 24 deletions(-)

diff --git a/include/net/mac80211.h b/include/net/mac80211.h
index d6f3c5855910..c65ebbb3265c 100644
--- a/include/net/mac80211.h
+++ b/include/net/mac80211.h
@@ -5082,6 +5082,34 @@ struct ieee80211_ops {
 			  struct cfg80211_pmsr_request *request);
 	void (*abort_pmsr)(struct ieee80211_hw *hw, struct ieee80211_vif *vif,
 			   struct cfg80211_pmsr_request *request);
+	/**
+	 * @sta_set_scs:
+	 * Called with the SCS descriptors that a station requested, after
+	 * cfg80211 validated them. Optional, only reached when the wiphy
+	 * advertises %NL80211_EXT_FEATURE_SCS. Without it, every descriptor
+	 * with a QoS Characteristics element is declined.
+	 *
+	 * - The results arrive zeroed, which means accepted. Write only
+	 *   refusals, in the result entry of the same index.
+	 * - Decline a descriptor only when its traffic description cannot
+	 *   be served. mac80211 classifies frames in software either way.
+	 * - A declined add or change keeps the previous descriptor of that
+	 *   SCSID. An accepted one without a traffic description replaces
+	 *   the device state of that SCSID.
+	 * - A removal only drops driver state, the result is ignored. A
+	 *   station going away drops its rules without a call.
+	 * - After a hardware restart every stored rule is passed again as
+	 *   an add, one per call, and the result is ignored.
+	 * - A negative return fails the whole request and leaves the rule
+	 *   set unchanged, so the driver must leave the device as it was.
+	 * - The descriptors belong to the MLD, not to one link.
+	 *
+	 * Called with the wiphy mutex held. This callback may sleep.
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
index 569c8ad314b4..e0a7e9bb75a0 100644
--- a/net/mac80211/ieee80211_i.h
+++ b/net/mac80211/ieee80211_i.h
@@ -2224,6 +2224,7 @@ int ieee80211_set_scs(struct wiphy *wiphy, struct net_device *dev,
 		      struct cfg80211_scs_result *res, u8 n_desc);
 int ieee80211_set_mscs(struct wiphy *wiphy, struct net_device *dev,
 		       const u8 *peer, struct cfg80211_mscs_desc *desc);
+void ieee80211_sta_scs_reconfig(struct sta_info *sta);
 void ieee80211_sta_scs_free(struct sta_info *sta);
 bool ieee80211_flow_classify(struct sta_info *sta, struct sk_buff *skb);
 void ieee80211_flow_learn(struct ieee80211_rx_data *rx);
diff --git a/net/mac80211/scs.c b/net/mac80211/scs.c
index 22d8ae711d06..076e97cddbf1 100644
--- a/net/mac80211/scs.c
+++ b/net/mac80211/scs.c
@@ -6,6 +6,7 @@
  */
 #include <linux/ieee80211.h>
 #include <net/cfg80211.h>
+#include "driver-ops.h"
 #include "ieee80211_i.h"
 #include "sta_info.h"
 
@@ -39,6 +40,8 @@ static void *ieee80211_scs_rule_copy(const struct cfg80211_scs_desc *src,
 	struct cfg80211_scs_desc *dst = pos;
 
 	memcpy(dst, src, len);
+	/* A stored rule is always handed back to the driver as an install */
+	dst->req_type = NL80211_SCS_REQ_ADD;
 	pos += len;
 
 	if (src->qos_char_len) {
@@ -63,39 +66,52 @@ static u8 ieee80211_scs_rule_find(struct cfg80211_scs_desc * const *rule,
 	return i;
 }
 
-/* @rule points into the old set and into the request, so copy each rule */
-static struct ieee80211_scs_sta *
-ieee80211_scs_sta_build(struct cfg80211_scs_desc * const *rule, u8 n_rules)
+static size_t ieee80211_scs_sta_head(unsigned int n_rules)
 {
 	struct ieee80211_scs_sta *scs;
-	size_t head, size;
-	void *pos;
-	u8 i;
 
-	if (!n_rules)
-		return NULL;
+	return ALIGN(struct_size(scs, rule, n_rules),
+		     __alignof__(struct cfg80211_scs_desc));
+}
 
-	head = ALIGN(struct_size(scs, rule, n_rules), __alignof__(**rule));
+/*
+ * Size for every rule that can end up in the set, so that no allocation
+ * fails after the driver programmed the accepted descriptors.
+ */
+static size_t ieee80211_scs_sta_size(const struct ieee80211_scs_sta *old,
+				     struct cfg80211_scs_desc * const *desc,
+				     u8 n_desc, unsigned int n_alloc)
+{
+	size_t size = ieee80211_scs_sta_head(n_alloc);
+	unsigned int i;
 
-	size = head;
-	for (i = 0; i < n_rules; i++)
-		size += ieee80211_scs_rule_size(rule[i]);
+	for (i = 0; old && i < old->n_rules; i++)
+		size += ieee80211_scs_rule_size(old->rule[i]);
 
-	/* 255 rules with 255 classifiers each exceed what kmalloc hands out */
-	scs = kvzalloc(size, GFP_KERNEL);
-	if (!scs)
-		return ERR_PTR(-ENOMEM);
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
@@ -369,7 +385,9 @@ int ieee80211_set_scs(struct wiphy *wiphy, struct net_device *dev,
 	struct ieee80211_scs_sta *scs, *old;
 	struct cfg80211_scs_desc **rule;
 	struct sta_info *sta;
+	unsigned int n_alloc;
 	u8 i, n_rules = 0;
+	int ret;
 
 	lockdep_assert_wiphy(wiphy);
 
@@ -380,11 +398,32 @@ int ieee80211_set_scs(struct wiphy *wiphy, struct net_device *dev,
 	old = wiphy_dereference(wiphy, sta->scs);
 
 	/* One rule per SCSID bounds the size of the new set */
-	rule = kcalloc((old ? old->n_rules : 0) + n_desc, sizeof(*rule),
-		       GFP_KERNEL);
+	n_alloc = (old ? old->n_rules : 0) + n_desc;
+
+	rule = kcalloc(n_alloc, sizeof(*rule), GFP_KERNEL);
 	if (!rule)
 		return -ENOMEM;
 
+	/* 255 rules with 255 classifiers each exceed what kmalloc hands out */
+	scs = kvzalloc(ieee80211_scs_sta_size(old, desc, n_desc, n_alloc),
+		       GFP_KERNEL);
+	if (!scs) {
+		ret = -ENOMEM;
+		goto free;
+	}
+
+	if (sdata->local->ops->sta_set_scs && sta->uploaded) {
+		ret = drv_sta_set_scs(sdata->local, sdata, sta, desc, res,
+				      n_desc);
+		if (ret)
+			goto free;
+	} else {
+		/* Without a driver, no traffic description can be served */
+		for (i = 0; i < n_desc; i++)
+			if (desc[i]->qos_char)
+				res[i].status = WLAN_STATUS_REQUEST_DECLINED;
+	}
+
 	if (old) {
 		n_rules = old->n_rules;
 		memcpy(rule, old->rule, n_rules * sizeof(*rule));
@@ -406,22 +445,35 @@ int ieee80211_set_scs(struct wiphy *wiphy, struct net_device *dev,
 			continue;
 		}
 
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
@@ -478,6 +530,30 @@ int ieee80211_set_mscs(struct wiphy *wiphy, struct net_device *dev,
 	return 0;
 }
 
+/*
+ * A restarted device lost every stream, so program them again. A refusal
+ * changes nothing here: the rule stays and mac80211 keeps classifying for it.
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
+	/* One rule per call, so no result array has to be allocated */
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
index e2b5b2b21c34..c97a3e00e251 100644
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
