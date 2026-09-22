Received: from nbd.name (nbd.name [46.4.11.11])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A87F85326C7
	for <linux-wireless@vger.kernel.org>; Tue, 22 Sep 2026 10:18:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=46.4.11.11
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790072338; cv=none; b=ht2NPNbtXrNFgetFxMN7u6VX9D2hq9P1oUHWXpyavk3iRIZ1u7+V+GonRBGdun4xzCgp2nfrwHJ8eZoGQGLTKREyhtJ3zkuSx1sp9mTYfkCKInTZb84idqF8J8sjRHxfoKGi1hBk1m+cdLJNukzZL4u2Yha2VD5awqD4z32ZWxI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790072338; c=relaxed/simple;
	bh=JevgZS4dvY9mT8iA7hAoedPxNkJVdd9m5WLZZ3rT4cs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=TcybNyJjrSvHhaASQUVU+haH9lbBt8LbEIp1hshMFTYmPzbMtVl6ey/gkjd/5OD214PYxUkf0/LaklkPTJPRKSnrCF/y+lOAcgqy4ynY6QhZnNgXKM+lorn5rpYePqVHcyVfUeQrNmiRoGrAtjacUFYNV/NKYI+ZDwAd2PxtxU8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=nbd.name; spf=pass smtp.mailfrom=nbd.name; dkim=pass (1024-bit key) header.d=nbd.name header.i=@nbd.name header.b=EGBHGunI; arc=none smtp.client-ip=46.4.11.11
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=nbd.name
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=nbd.name
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=nbd.name header.i=@nbd.name header.b="EGBHGunI"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=nbd.name;
	s=20160729; h=Content-Transfer-Encoding:MIME-Version:References:In-Reply-To:
	Message-ID:Date:Subject:Cc:To:From:Sender:Reply-To:Content-Type:Content-ID:
	Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
	:Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
	List-Post:List-Owner:List-Archive;
	bh=7GEAB8JkChTEn1+Zr3yrgR5kVy+Gl4sI8og4wGh0yJA=; b=EGBHGunIj5fAmmuMtiIu+klFMV
	YizJVbq+V9U3dizoSYKfkmGsId9z+A17LtIiz5q1krH8AzglpIa3xXz4qXLmry1M6hQyue/2GvHll
	Awq/eJWpbuylo5OiYnkyIbgc8/7Bk3VQnXfS0sgabPgWj8no4zNV2ixvHdBA7tWe4hhE=;
Received: from p200300cadf12010000000000000005bb.dip0.t-ipconnect.de ([2003:ca:df12:100::5bb] helo=localhost.localdomain)
	by ds12 with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
	(Exim 4.96)
	(envelope-from <nbd@nbd.name>)
	id 1x8xaN-0080aD-1a;
	Tue, 22 Sep 2026 12:18:51 +0200
From: Felix Fietkau <nbd@nbd.name>
To: linux-wireless@vger.kernel.org
Cc: vivek.chettri@oss.qualcomm.com,
	bhagavathi.pillai@oss.qualcomm.com,
	ripan.deuri@oss.qualcomm.com
Subject: [RFC PATCH 3/5] wifi: mac80211: add the flow offload flush op
Date: Tue, 22 Sep 2026 12:18:46 +0200
Message-ID: <6312d3f5c1a4cda48a72d5e5bb6b9a6070411688.1790072192.git-series.nbd@nbd.name>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <cover.cadd8c50b95a5843991b4ea42462910882ab0982.1790072192.git-series.nbd@nbd.name>
References: <cover.cadd8c50b95a5843991b4ea42462910882ab0982.1790072192.git-series.nbd@nbd.name>
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

A driver that uses ieee80211_sta_flow_prio() stores the result in its
hardware flow entries. Once the SCS or MSCS rules of a station change,
those entries are stale. Add a driver op that is called after each rule
change, so that the driver can drop the entries of the station and
query again when the flows are added back.

Signed-off-by: Felix Fietkau <nbd@nbd.name>
---
 include/net/mac80211.h    | 13 +++++++++++++
 net/mac80211/driver-ops.h | 19 +++++++++++++++++++
 net/mac80211/scs.c        |  4 ++++
 net/mac80211/trace.h      |  7 +++++++
 4 files changed, 43 insertions(+)

diff --git a/include/net/mac80211.h b/include/net/mac80211.h
index d0ac8493889a..010165043c4d 100644
--- a/include/net/mac80211.h
+++ b/include/net/mac80211.h
@@ -5110,6 +5110,19 @@ struct ieee80211_ops {
 			   struct ieee80211_sta *sta,
 			   struct cfg80211_scs_desc * const *desc,
 			   struct cfg80211_scs_result *res, u8 n_desc);
+	/**
+	 * @flow_offload_flush:
+	 * Called after the SCS or MSCS rules of a station changed. Any
+	 * priority that ieee80211_sta_flow_prio() returned for the station
+	 * before is stale, so the driver must drop the hardware flow entries
+	 * that use it. Optional, only needed by drivers that use
+	 * ieee80211_sta_flow_prio().
+	 *
+	 * Called with the wiphy mutex held. This callback may sleep.
+	 */
+	void (*flow_offload_flush)(struct ieee80211_hw *hw,
+				   struct ieee80211_vif *vif,
+				   struct ieee80211_sta *sta);
 	int (*set_tid_config)(struct ieee80211_hw *hw,
 			      struct ieee80211_vif *vif,
 			      struct ieee80211_sta *sta,
diff --git a/net/mac80211/driver-ops.h b/net/mac80211/driver-ops.h
index f7684e8db025..903d8c728a23 100644
--- a/net/mac80211/driver-ops.h
+++ b/net/mac80211/driver-ops.h
@@ -1578,6 +1578,25 @@ static inline int drv_sta_set_scs(struct ieee80211_local *local,
 	return ret;
 }
 
+static inline void drv_flow_offload_flush(struct ieee80211_local *local,
+					  struct ieee80211_sub_if_data *sdata,
+					  struct sta_info *sta)
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
+	local->ops->flow_offload_flush(&local->hw, &sdata->vif, &sta->sta);
+	trace_drv_return_void(local);
+}
+
 static inline int drv_set_tid_config(struct ieee80211_local *local,
 				     struct ieee80211_sub_if_data *sdata,
 				     struct ieee80211_sta *sta,
diff --git a/net/mac80211/scs.c b/net/mac80211/scs.c
index 519f85c897ff..ec7004265b4f 100644
--- a/net/mac80211/scs.c
+++ b/net/mac80211/scs.c
@@ -504,6 +504,8 @@ int ieee80211_set_scs(struct wiphy *wiphy, struct net_device *dev,
 	if (old)
 		kvfree_rcu(old, rcu_head);
 
+	drv_flow_offload_flush(sdata->local, sdata, sta);
+
 	return 0;
 
 free:
@@ -564,6 +566,8 @@ int ieee80211_set_mscs(struct wiphy *wiphy, struct net_device *dev,
 		kfree_rcu(old, rcu_head);
 	}
 
+	drv_flow_offload_flush(sdata->local, sdata, sta);
+
 	return 0;
 }
 
diff --git a/net/mac80211/trace.h b/net/mac80211/trace.h
index 1e6026306fb2..58cbb53ac0e4 100644
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
