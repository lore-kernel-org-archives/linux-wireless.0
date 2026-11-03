Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=46.4.11.11
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793723049;
	b=l/kczSKcphrf3Eml4inNvkQnwSUhkhpuXPVILDptINuzSxt8bDqzsdYWTCEN1jct/iCT
	 bX8tQG/Vsj0jAJwN0H8j3LlPGkj166CHK1pJhaFo4sXqVj53bKMQ8RTp/Ve7LVOOMTbn8
	 sXYpd2/4iPpWRRPJwMSmjlwt8UH7jf8f6ncYE0UH6b81CBQHhjTNWDM5wyBmOx5nK1Jgc
	 hHADxnEo+8m3x7m/OmMEpU/D2bNUDKDpmARMXem/sUcJ99qW2/ygV0fkmltf/IyZPeKsf
	 OVN347tOHMw3hA5uUZhAz8CEwwFElVC3iYquYN+52HF/siQcvuHb+ZU6ilFIY/JaoiA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793723049;
	h=DMARC-Filter:DKIM-Signature:Received:From:To:Cc:Subject:Date:
	 Message-ID:X-Mailer:In-Reply-To:References:MIME-Version:
	 Content-Transfer-Encoding;
	bh=YONAzz7gfQUeanKTI/fJPuBHz1iNkIkxTU6BRLU3gqo=;
	b=X16DiUprfpnkghlGTPp+9OCFvqayzbwHVyhX6p5HcFNLfHzeG+Cga5WJu9wSH9E/0cOI
	 xtLMYr978ssNOS7ns50I6uQ8pYNwryFrFSgLsy27SSP/Y68+S75h89jLTrORW6t1O1tx3
	 U7DTYyYQuJ26Hi/YkVXSzQbp++6yTF+7VMqS9TFt9EEgTHZf7fg2NOcFDWz1JxdbbVhd/
	 mdEuDaFKyY22XIjMajwEnk0BE7MCFEh2iOcSCTkTKxiKWbd5AzmxCt3P6JPSsL86+E8YL
	 oy904xv9gl65btCzKr/qpolHGln0Weqt3F9svdA2t8S8qblhBLEqqcBUCXMGfonsj0g==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=nbd.name;
	spf=pass smtp.mailfrom=nbd.name;
	dkim=pass header.d=nbd.name header.i=@nbd.name header.a=rsa-sha256 header.s=20160729 header.b="Rtf76V//";
	arc=none smtp.remote-ip=46.4.11.11
Received: from nbd.name (nbd.name [46.4.11.11])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange ECDHE (prime256v1) server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 54C8D606D81B
	for <linux-wireless@vger.kernel.org>; Tue,  3 Nov 2026 16:24:08 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 54C8D606D81B
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=nbd.name
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=nbd.name
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=nbd.name header.i=@nbd.name header.a=rsa-sha256 header.s=20160729 header.b=Rtf76V//
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=nbd.name;
	s=20160729; h=Content-Transfer-Encoding:MIME-Version:References:In-Reply-To:
	Message-ID:Date:Subject:Cc:To:From:Sender:Reply-To:Content-Type:Content-ID:
	Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
	:Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
	List-Post:List-Owner:List-Archive;
	bh=YONAzz7gfQUeanKTI/fJPuBHz1iNkIkxTU6BRLU3gqo=; b=Rtf76V//OOWZpHXlYznWSLIfHa
	3Ka9KbmCkZPRkKnlqlNu08z2fIilKxqXUyUuHWghaTjmcb+QXogj96TQqAlH3omeUpOfWqTzy0lXs
	nRebC8+jC7Uucnuyf4ljLUdesnqTijPpvqWASKRWsiQj8nuC9Iz4YF5Zs6RuSfXwNYuA=;
Received: from p200300cadf12920000000000000005bb.dip0.t-ipconnect.de ([2003:ca:df12:9200::5bb] helo=localhost.localdomain)
	by ds12 with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
	(Exim 4.96)
	(envelope-from <nbd@nbd.name>)
	id 1xOHIn-00FDFp-1D;
	Tue, 03 Nov 2026 17:24:01 +0100
From: Felix Fietkau <nbd@nbd.name>
To: linux-wireless@vger.kernel.org
Cc: johannes@sipsolutions.net
Subject: [PATCH wireless-next 13/18] wifi: mac80211: add the sta_set_scs driver op
Date: Tue,  3 Nov 2026 17:23:46 +0100
Message-ID: <8dd882fa6ee0b64df5f55830847d8ebe83da5308.1793722802.git-series.nbd@nbd.name>
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

Pass the SCS descriptors of a request to the driver and let it answer
each of them. This is the only path by which the QoS Characteristics
element reaches a driver.

The classifier runs in software whatever the driver answers, but only
the driver can schedule a stream according to its traffic description.
A driver therefore declines a descriptor only when it cannot serve the
traffic description. Without the op, or before the station is uploaded,
mac80211 declines every descriptor that carries a traffic description.

Signed-off-by: Felix Fietkau <nbd@nbd.name>
---
 include/net/mac80211.h     | 29 +++++++++++++++++++++-
 net/mac80211/driver-ops.h  | 26 +++++++++++++++++++-
 net/mac80211/ieee80211_i.h |  1 +-
 net/mac80211/scs.c         | 54 +++++++++++++++++++++++++++++++++++++--
 net/mac80211/trace.h       | 27 ++++++++++++++++++++-
 net/mac80211/util.c        |  2 +-
 6 files changed, 137 insertions(+), 2 deletions(-)

diff --git a/include/net/mac80211.h b/include/net/mac80211.h
index 0f1969c48646..9ed50c6fe679 100644
--- a/include/net/mac80211.h
+++ b/include/net/mac80211.h
@@ -5129,6 +5129,35 @@ struct ieee80211_ops {
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
+	 * - The @status entries arrive zeroed, which means accepted. Write
+	 *   only refusals, as IEEE status codes, at the index of the
+	 *   descriptor.
+	 * - Decline a descriptor only when its traffic description cannot
+	 *   be served. mac80211 classifies frames in software either way.
+	 * - A declined add or change keeps the previous descriptor of that
+	 *   SCSID. An accepted add or change without a traffic description
+	 *   ends the device stream of that SCSID.
+	 * - A removal only drops driver state, the status is ignored. A
+	 *   station going away drops its rules without a call.
+	 * - After a hardware restart every stored rule is passed again as
+	 *   an add, one per call, and the status is ignored.
+	 * - A negative return fails the whole request and leaves the rule
+	 *   set unchanged, so the driver must leave the device as it was.
+	 * - The descriptors belong to the MLD, not to one link.
+	 *
+	 * Called with the wiphy mutex held. This callback may sleep.
+	 */
+	int (*sta_set_scs)(struct ieee80211_hw *hw, struct ieee80211_vif *vif,
+			   struct ieee80211_sta *sta,
+			   struct cfg80211_scs_desc * const *desc,
+			   u16 *status, u8 n_desc);
 	int (*set_tid_config)(struct ieee80211_hw *hw,
 			      struct ieee80211_vif *vif,
 			      struct ieee80211_sta *sta,
diff --git a/net/mac80211/driver-ops.h b/net/mac80211/driver-ops.h
index 78230779e7fb..004e21ff334e 100644
--- a/net/mac80211/driver-ops.h
+++ b/net/mac80211/driver-ops.h
@@ -1543,6 +1543,32 @@ static inline void drv_del_nan_func(struct ieee80211_local *local,
 	trace_drv_return_void(local);
 }
 
+static inline int drv_sta_set_scs(struct ieee80211_local *local,
+				  struct ieee80211_sub_if_data *sdata,
+				  struct sta_info *sta,
+				  struct cfg80211_scs_desc * const *desc,
+				  u16 *status, u8 n_desc)
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
+				      status, n_desc);
+	trace_drv_return_int(local, ret);
+
+	return ret;
+}
+
 static inline int drv_set_tid_config(struct ieee80211_local *local,
 				     struct ieee80211_sub_if_data *sdata,
 				     struct ieee80211_sta *sta,
diff --git a/net/mac80211/ieee80211_i.h b/net/mac80211/ieee80211_i.h
index c52dcf2a28ba..41518764ee12 100644
--- a/net/mac80211/ieee80211_i.h
+++ b/net/mac80211/ieee80211_i.h
@@ -2270,6 +2270,7 @@ int ieee80211_set_scs(struct wiphy *wiphy, struct net_device *dev,
 		      u16 *status, u8 n_desc);
 int ieee80211_set_mscs(struct wiphy *wiphy, struct net_device *dev,
 		       const u8 *peer, struct cfg80211_mscs_desc *desc);
+void ieee80211_sta_scs_reconfig(struct sta_info *sta);
 void ieee80211_sta_scs_free(struct sta_info *sta);
 bool ieee80211_flow_classify(struct sta_info *sta, struct sk_buff *skb);
 void ieee80211_flow_learn(struct ieee80211_rx_data *rx);
diff --git a/net/mac80211/scs.c b/net/mac80211/scs.c
index 13560cdf5dd8..00c58eaa3057 100644
--- a/net/mac80211/scs.c
+++ b/net/mac80211/scs.c
@@ -6,6 +6,7 @@
  */
 #include <linux/ieee80211.h>
 #include <net/cfg80211.h>
+#include "driver-ops.h"
 #include "ieee80211_i.h"
 #include "sta_info.h"
 
@@ -40,6 +41,8 @@ static void *ieee80211_scs_rule_copy(const struct cfg80211_scs_desc *src,
 	struct cfg80211_scs_desc *dst = pos;
 
 	memcpy(dst, src, len);
+	/* A restart replays the stored rule to the driver as an add */
+	dst->req_type = NL80211_SCS_REQ_ADD;
 	pos += len;
 
 	if (src->qos_char_len) {
@@ -474,6 +477,7 @@ int ieee80211_set_scs(struct wiphy *wiphy, struct net_device *dev,
 	struct sta_info *sta;
 	unsigned int n_alloc;
 	u8 i, n_rules = 0;
+	int ret;
 
 	lockdep_assert_wiphy(wiphy);
 
@@ -498,8 +502,20 @@ int ieee80211_set_scs(struct wiphy *wiphy, struct net_device *dev,
 	scs = kvzalloc(ieee80211_scs_sta_size(old, desc, n_desc, n_alloc),
 		       GFP_KERNEL);
 	if (!scs) {
-		kfree(rule);
-		return -ENOMEM;
+		ret = -ENOMEM;
+		goto free;
+	}
+
+	if (sdata->local->ops->sta_set_scs && sta->uploaded) {
+		ret = drv_sta_set_scs(sdata->local, sdata, sta, desc, status,
+				      n_desc);
+		if (ret)
+			goto free;
+	} else {
+		/* Without a driver, no traffic description can be served */
+		for (i = 0; i < n_desc; i++)
+			if (desc[i]->qos_char)
+				status[i] = WLAN_STATUS_REQUEST_DECLINED;
 	}
 
 	if (old) {
@@ -520,6 +536,9 @@ int ieee80211_set_scs(struct wiphy *wiphy, struct net_device *dev,
 			continue;
 		}
 
+		if (status[i] != WLAN_STATUS_SUCCESS)
+			continue;
+
 		if (at < n_rules)
 			rule[at] = desc[i];
 		else
@@ -540,6 +559,12 @@ int ieee80211_set_scs(struct wiphy *wiphy, struct net_device *dev,
 		kvfree_rcu(old, rcu_head);
 
 	return 0;
+
+free:
+	kvfree(scs);
+	kfree(rule);
+
+	return ret;
 }
 
 static struct ieee80211_mscs_sta *
@@ -642,6 +667,31 @@ int ieee80211_set_mscs(struct wiphy *wiphy, struct net_device *dev,
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
+	/* One rule per call, so no status array has to be allocated */
+	for (i = 0; i < scs->n_rules; i++) {
+		u16 status = 0;
+
+		drv_sta_set_scs(local, sta->sdata, sta, &scs->rule[i], &status,
+				1);
+	}
+}
+
 void ieee80211_sta_scs_free(struct sta_info *sta)
 {
 	struct ieee80211_mscs_sta *mscs, *tmp;
diff --git a/net/mac80211/trace.h b/net/mac80211/trace.h
index ea46c3cca21a..4720ea912e5c 100644
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
index 44feb80274c6..7a9ff3a3d2e3 100644
--- a/net/mac80211/util.c
+++ b/net/mac80211/util.c
@@ -1766,6 +1766,8 @@ static void ieee80211_reconfig_stations(struct ieee80211_sub_if_data *sdata)
 		     state < sta->sta_state; state++)
 			WARN_ON(drv_sta_state(local, sta->sdata, sta, state,
 					      state + 1));
+
+		ieee80211_sta_scs_reconfig(sta);
 	}
 }
 
-- 
git-series 0.9.1
