Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=46.4.11.11
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793723049;
	b=zKFO8G8+w3TtgAKvqZSlRNjGW+kOdY/A1W6znrA+fpSiYQ/mZdVR5YVgZF4+rXEKGa4Q
	 gXXPSKnQ0WcLaEwMWCkfU7l6kPsW5vm2d0LNr3sMwmOmMFNl+ZljgJoRZ5pAaoS0fQMAi
	 gfuLpSlsROtietT9WnOLSs8uv6mkoNiTav/Rsd/qnOf7P02W3UQHLOEM5BMigGusPGu08
	 3vvxsxIA2B8KmesKs1drsRYL73G4qQTyM+OYT8D3AkqVXYEYaF8hfM2I49qJD5HathkFx
	 xO5oFNdLIdonPNqsYlA0FyLOjzUrAAIHy/Pmn048YgEviRU5Xc9+ukiOZQ3DpclYmfQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793723049;
	h=DMARC-Filter:DKIM-Signature:Received:From:To:Cc:Subject:Date:
	 Message-ID:X-Mailer:In-Reply-To:References:MIME-Version:
	 Content-Transfer-Encoding;
	bh=fz/97brDSe2AUMycTTv1RGMexBq/up2YItI0JuSlkAE=;
	b=2uxCFsDx5nUdjMeEEhWGOJ1jKWAJW081B9qD2vmPA0R0vx2WGlUkoYp5+YPbyykokWXu
	 m72CFb6Vtm/hlNQFROt7PQpxvuClTqUNnaOJxAKkpd4h8PtIoMaqiZG1IfoBXUtLg4pPq
	 btbGhfO2gKfC/49vOfugvJ5tzIT2k8K9yINbcANYNiQUOxMMhn/Ulkr0ZtlvIOoRU8tho
	 KDzTMQnoMkxmLwN75pa/vQocaWReUtBJ0lXn12OI+p6owAO3CAfPd/3e1ecfj9okHozSl
	 Sp8WxPIKM9mgZ+ExhBEr5mE36moT5ifgaa9FGqezDo99EsIbos2cP5siJAKrWcIs2tg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=nbd.name;
	spf=pass smtp.mailfrom=nbd.name;
	dkim=pass header.d=nbd.name header.i=@nbd.name header.a=rsa-sha256 header.s=20160729 header.b=SnZr3GDu;
	arc=none smtp.remote-ip=46.4.11.11
Received: from nbd.name (nbd.name [46.4.11.11])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange ECDHE (prime256v1) server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 225DC606D835
	for <linux-wireless@vger.kernel.org>; Tue,  3 Nov 2026 16:24:09 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 225DC606D835
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=nbd.name
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=nbd.name
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=nbd.name header.i=@nbd.name header.a=rsa-sha256 header.s=20160729 header.b=SnZr3GDu
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=nbd.name;
	s=20160729; h=Content-Transfer-Encoding:MIME-Version:References:In-Reply-To:
	Message-ID:Date:Subject:Cc:To:From:Sender:Reply-To:Content-Type:Content-ID:
	Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
	:Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
	List-Post:List-Owner:List-Archive;
	bh=fz/97brDSe2AUMycTTv1RGMexBq/up2YItI0JuSlkAE=; b=SnZr3GDuSYoZX/bCoyQa8AcDQv
	O/rEXYmZWobYH/N6yn06+5QSd3uEcMOce8Jl5v152UJnswnFGh+Y+wLCNydhTPu9dpKx90wpS+/r6
	/oB90yqqSdQ9qHMyH7Af1JqGCUiqmvAzfzjcopSyc4mzbfjqPD1OCe9pPxZbSaB90m/s=;
Received: from p200300cadf12920000000000000005bb.dip0.t-ipconnect.de ([2003:ca:df12:9200::5bb] helo=localhost.localdomain)
	by ds12 with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
	(Exim 4.96)
	(envelope-from <nbd@nbd.name>)
	id 1xOHIo-00FDFp-1H;
	Tue, 03 Nov 2026 17:24:02 +0100
From: Felix Fietkau <nbd@nbd.name>
To: linux-wireless@vger.kernel.org
Cc: johannes@sipsolutions.net
Subject: [PATCH wireless-next 18/18] wifi: mac80211: keep learned MSCS entries of offloaded flows
Date: Tue,  3 Nov 2026 17:23:51 +0100
Message-ID: <d58722c6dd68211f443251df4b82f58014208213.1793722802.git-series.nbd@nbd.name>
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

A learned entry expires when no uplink frame of the flow reached
mac80211 for the stream timeout. Once the uplink is offloaded, its
frames no longer reach the CPU, so an active flow looks idle and its
entry is dropped, while the hardware keeps forwarding the downlink
with the learned priority. The standard allows an AP to keep a learned
value past the stream timeout.

Add a driver op that reports when the hardware last forwarded a frame
of a flow, like the lastused value of a flow_cls_offload stats request.
Before an entry expires, ask the driver and refresh the entry from the
answer, so that it lives as long as the hardware forwards the flow.

An MSCS mirrors the user priority that the station uses, and the
station can change it for a flow at any time. While the uplink stays
offloaded, mac80211 does not see the change, and the downlink keeps the
old priority. When the hardware keeps an entry alive, also drop the
flow from the hardware, so that its next uplink frames reach mac80211.
A changed priority is thus learned within one stream timeout. When an
offloaded entry expires, drop the flow from the hardware as well, since
its hardware entries still carry the learned priority.

The first user, flow offload with mtk_eth_soc on mt7996, follows in a
separate series.

Signed-off-by: Felix Fietkau <nbd@nbd.name>
---
 include/net/mac80211.h    | 28 +++++++++++++++++++++++++++-
 net/mac80211/driver-ops.h | 29 +++++++++++++++++++++++++++++
 net/mac80211/scs.c        | 39 ++++++++++++++++++++++++++++++++++++++-
 net/mac80211/trace.h      |  7 +++++++
 4 files changed, 101 insertions(+), 2 deletions(-)

diff --git a/include/net/mac80211.h b/include/net/mac80211.h
index a719b688e170..4d0b4a63acd8 100644
--- a/include/net/mac80211.h
+++ b/include/net/mac80211.h
@@ -4109,6 +4109,16 @@ struct ieee80211_flow_match {
 };
 
 /**
+ * struct ieee80211_flow_stats - activity of an offloaded flow
+ *
+ * @lastused: jiffies of the last frame of the flow that the hardware
+ *	forwarded, in either direction
+ */
+struct ieee80211_flow_stats {
+	unsigned long lastused;
+};
+
+/**
  * struct ieee80211_ops - callbacks from mac80211 to the driver
  *
  * This structure contains various callbacks that the driver may
@@ -5179,7 +5189,9 @@ struct ieee80211_ops {
 	 * its interface changed, or after the learned MSCS priority of one
 	 * flow changed. Any priority that
 	 * ieee80211_sta_flow_prio() returned before is stale, so the driver
-	 * must drop the hardware flow entries that use it. With a %NULL
+	 * must drop the hardware flow entries that use it. Also called for a
+	 * flow whose learned MSCS entry @flow_offload_stats kept alive or let
+	 * expire, so that its frames reach mac80211 again. With a %NULL
 	 * @match, every entry of the station is stale, otherwise only the
 	 * entries that @match selects. The entries in the direction from the
 	 * station are dropped as well, since mac80211 learns an MSCS priority
@@ -5192,6 +5204,20 @@ struct ieee80211_ops {
 				   struct ieee80211_vif *vif,
 				   struct ieee80211_sta *sta,
 				   const struct ieee80211_flow_match *match);
+	/**
+	 * @flow_offload_stats:
+	 * Report the activity of the hardware flow entries that @match
+	 * selects, in @stats. With more than one matching entry, report the
+	 * most recent use. Return 0, or -ENOENT when no entry matches.
+	 * Optional, only needed by drivers that use ieee80211_sta_flow_prio().
+	 *
+	 * Called with the wiphy mutex held. This callback may sleep.
+	 */
+	int (*flow_offload_stats)(struct ieee80211_hw *hw,
+				  struct ieee80211_vif *vif,
+				  struct ieee80211_sta *sta,
+				  const struct ieee80211_flow_match *match,
+				  struct ieee80211_flow_stats *stats);
 	int (*set_tid_config)(struct ieee80211_hw *hw,
 			      struct ieee80211_vif *vif,
 			      struct ieee80211_sta *sta,
diff --git a/net/mac80211/driver-ops.h b/net/mac80211/driver-ops.h
index ff3c856b5e29..c1a12d3876f2 100644
--- a/net/mac80211/driver-ops.h
+++ b/net/mac80211/driver-ops.h
@@ -1589,6 +1589,35 @@ drv_flow_offload_flush(struct ieee80211_local *local,
 	trace_drv_return_void(local);
 }
 
+static inline int
+drv_flow_offload_stats(struct ieee80211_local *local,
+		       struct ieee80211_sub_if_data *sdata, struct sta_info *sta,
+		       const struct ieee80211_flow_match *match,
+		       struct ieee80211_flow_stats *stats)
+{
+	int ret;
+
+	might_sleep();
+	lockdep_assert_wiphy(local->hw.wiphy);
+
+	if (!local->ops->flow_offload_stats)
+		return -EOPNOTSUPP;
+
+	if (!sta->uploaded)
+		return -ENOENT;
+
+	sdata = get_bss_sdata(sdata);
+	if (!check_sdata_in_driver(sdata))
+		return -EIO;
+
+	trace_drv_flow_offload_stats(local, sdata, &sta->sta);
+	ret = local->ops->flow_offload_stats(&local->hw, &sdata->vif, &sta->sta,
+					     match, stats);
+	trace_drv_return_int(local, ret);
+
+	return ret;
+}
+
 static inline int drv_set_tid_config(struct ieee80211_local *local,
 				     struct ieee80211_sub_if_data *sdata,
 				     struct ieee80211_sta *sta,
diff --git a/net/mac80211/scs.c b/net/mac80211/scs.c
index d3b120770a83..a02bd7c90b1f 100644
--- a/net/mac80211/scs.c
+++ b/net/mac80211/scs.c
@@ -275,8 +275,41 @@ ieee80211_flow_expired_find(struct ieee80211_mscs_sta *mscs)
 	return NULL;
 }
 
+/*
+ * An expired entry survives while the hardware still forwards its flow. The
+ * offloaded uplink frames do not reach the learn path, so the flow is dropped
+ * from the hardware, and a changed priority is learned from its next frames.
+ * An entry that does expire is dropped as well, since it carries the learned
+ * priority.
+ */
+static bool ieee80211_flow_entry_refresh(struct ieee80211_sub_if_data *sdata,
+					 struct sta_info *sta,
+					 struct ieee80211_mscs_sta *mscs,
+					 struct ieee80211_flow_entry *entry)
+{
+	struct ieee80211_flow_match match = {
+		.key = &entry->hkey.key,
+		.fields = mscs->layout,
+	};
+	struct ieee80211_flow_stats stats = {};
+	int err;
+
+	err = drv_flow_offload_stats(sdata->local, sta->sdata, sta, &match,
+				     &stats);
+	if (err != -ENOENT)
+		drv_flow_offload_flush(sdata->local, sta->sdata, sta, &match);
+
+	if (err || time_after_eq(jiffies, stats.lastused + mscs->timeout))
+		return false;
+
+	WRITE_ONCE(entry->last_update, stats.lastused);
+
+	return true;
+}
+
 /* Return the time until the next entry expires, zero when none is left */
 static unsigned long ieee80211_flow_gc_mscs(struct ieee80211_sub_if_data *sdata,
+					    struct sta_info *sta,
 					    struct ieee80211_mscs_sta *mscs)
 {
 	struct ieee80211_flow_entry *entry;
@@ -294,6 +327,9 @@ static unsigned long ieee80211_flow_gc_mscs(struct ieee80211_sub_if_data *sdata,
 		if (!entry)
 			break;
 
+		if (ieee80211_flow_entry_refresh(sdata, sta, mscs, entry))
+			continue;
+
 		spin_lock_bh(&mscs->lock);
 		ieee80211_flow_entry_free(&sdata->u.ap, entry);
 		mscs->n_entries--;
@@ -326,7 +362,8 @@ static unsigned long ieee80211_flow_gc_sta(struct ieee80211_sub_if_data *sdata,
 	lockdep_assert_wiphy(sdata->local->hw.wiphy);
 
 	list_for_each_entry(mscs, &sta->mscs, list) {
-		unsigned long mscs_delay = ieee80211_flow_gc_mscs(sdata, mscs);
+		unsigned long mscs_delay = ieee80211_flow_gc_mscs(sdata, sta,
+								  mscs);
 
 		if (mscs_delay && (!delay || mscs_delay < delay))
 			delay = mscs_delay;
diff --git a/net/mac80211/trace.h b/net/mac80211/trace.h
index a3262182aae7..063fb5722369 100644
--- a/net/mac80211/trace.h
+++ b/net/mac80211/trace.h
@@ -1057,6 +1057,13 @@ DEFINE_EVENT(sta_event, drv_flow_offload_flush,
 	TP_ARGS(local, sdata, sta)
 );
 
+DEFINE_EVENT(sta_event, drv_flow_offload_stats,
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
