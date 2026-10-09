Received: from sipsolutions.net (s3.sipsolutions.net [168.119.38.16])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 08913511E68
	for <linux-wireless@vger.kernel.org>; Fri,  9 Oct 2026 18:14:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=168.119.38.16
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791569680; cv=none; b=V8E8R0JhJkA5TJYy34mxHElEv0M4tG0rrG9e0JhVP2qSu4jCU4fvSSAI6evur4hPwvGGaW7tXNga+REreq7Z2oBoPgcyL4AR3xofEsKX8/13sxLZPPkHfPDULmnnsI4ac66CIOHozoez0ivbDgp95D+GQtsgn8htwfN4Naf/oIY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791569680; c=relaxed/simple;
	bh=hnjp891sptfGn5qEO9W36ExThTZttcmmvyJTv6hfdPQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=JjEGf2aHvxT5wleUFb2rgCQxKrx7GFowUWCw413+KSkGf2zTXtJZBn6wLgi6qmecx3TDDYSXD597chYLR6nlDyq4ljIz6QqRoIQKVmHt+/zs+N6NxftHIZg/SBDC/fIpSMIIiR3cv3c75O47fNfIRm1J5kSVLm/Iu7kXn6SwSxY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=permerror header.from=sipsolutions.net; spf=pass smtp.mailfrom=sipsolutions.net; dkim=pass (2048-bit key) header.d=sipsolutions.net header.i=@sipsolutions.net header.b=ficOHAnc; arc=none smtp.client-ip=168.119.38.16
Authentication-Results: smtp.subspace.kernel.org; dmarc=permerror header.from=sipsolutions.net
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=sipsolutions.net
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=sipsolutions.net header.i=@sipsolutions.net header.b="ficOHAnc"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=sipsolutions.net; s=mail; h=Content-Transfer-Encoding:MIME-Version:
	References:In-Reply-To:Message-ID:Date:Subject:Cc:To:From:Content-Type:Sender
	:Reply-To:Content-ID:Content-Description:Resent-Date:Resent-From:Resent-To:
	Resent-Cc:Resent-Message-ID; bh=KdMxkMlbfpJz05CaKZYzNHoLhsvtg7LNEbM5Y7/h+TU=;
	t=1791569679; x=1792779279; b=ficOHAncCwTOGCCuhzTth7lnix3WbXfzsqJ5f65HgldRva0
	MvwfULWssSCLnVfBKZeG/Q/QHEy728WqU/PTcBmgJSyDvhcw2fVTDAeV0NzJv7igpg5tyRo7rAdRw
	U0muUwv8eXNaVTZIiniTX0wwPvIuHGs5WOloZ/DTxOn7M8PvkeCfXwEeCf98P0sH5nZay7Eau+ZZP
	MzuijAMD8iHFLwlN1HUsgN1mUM8gOJVIF9WEYBu+GJb/KhYHxsBCn8wm8f2PkTkwysk4u6nQDbuix
	o6hTRspFwaVQ1LnW4zUgWppwsxR7pn1a9d+hwiBQhKVWLApKQURs7Ve86i4XkN0A==;
Received: by sipsolutions.net with esmtpsa (TLS1.3:ECDHE_X25519__ECDSA_SECP256R1_SHA256__AES_256_GCM:256)
	(Exim 4.98.2)
	(envelope-from <johannes@sipsolutions.net>)
	id 1xFF75-0000000AtGH-2DFn;
	Fri, 09 Oct 2026 20:14:36 +0200
From: Johannes Berg <johannes@sipsolutions.net>
To: linux-wireless@vger.kernel.org
Cc: Johannes Berg <johannes.berg@intel.com>
Subject: [PATCH wireless-next 16/17] wifi: mac80211: refactor station statistics
Date: Fri,  9 Oct 2026 20:10:15 +0200
Message-ID: <20261009201417.32dfeaa3c44d.I7ea45bf80dd493311670f8fdd018b5c4b770a4be@changeid>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261009181416.335754-19-johannes@sipsolutions.net>
References: <20261009181416.335754-19-johannes@sipsolutions.net>
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Johannes Berg <johannes.berg@intel.com>

Refactor the code a bit to pass around link-STA pointers
instead of looking them up again and again. This will
simplify the next changes, since otherwise all of these
lookups would have to be converted to RCU-safe ones. It
also simplifies the code generally.

Signed-off-by: Johannes Berg <johannes.berg@intel.com>
---
 net/mac80211/sta_info.c | 87 ++++++++++++++++++-----------------------
 1 file changed, 39 insertions(+), 48 deletions(-)

diff --git a/net/mac80211/sta_info.c b/net/mac80211/sta_info.c
index 9252aaa39895..d761847b70b3 100644
--- a/net/mac80211/sta_info.c
+++ b/net/mac80211/sta_info.c
@@ -2547,20 +2547,11 @@ void ieee80211_sta_update_pending_airtime(struct ieee80211_local *local,
 }
 
 static struct ieee80211_sta_rx_stats *
-sta_get_last_rx_stats(struct sta_info *sta, int link_id)
+sta_get_last_rx_stats(struct link_sta_info *link_sta_info)
 {
-	struct ieee80211_sta_rx_stats *stats;
-	struct link_sta_info *link_sta_info;
+	struct ieee80211_sta_rx_stats *stats = &link_sta_info->rx_stats;
 	int cpu;
 
-	if (link_id < 0)
-		link_sta_info = &sta->deflink;
-	else
-		link_sta_info = wiphy_dereference(sta->local->hw.wiphy,
-						  sta->link[link_id]);
-
-	stats = &link_sta_info->rx_stats;
-
 	if (!link_sta_info->pcpu_rx_stats)
 		return stats;
 
@@ -2576,6 +2567,19 @@ sta_get_last_rx_stats(struct sta_info *sta, int link_id)
 	return stats;
 }
 
+static unsigned long sta_link_last_active(struct link_sta_info *link_sta_info)
+{
+	struct ieee80211_sta_rx_stats *stats;
+
+	stats = sta_get_last_rx_stats(link_sta_info);
+
+	if (!link_sta_info->status_stats.last_ack ||
+	    time_after(stats->last_rx, link_sta_info->status_stats.last_ack))
+		return stats->last_rx;
+
+	return link_sta_info->status_stats.last_ack;
+}
+
 static void sta_stats_decode_rate(struct ieee80211_local *local, u32 rate,
 				  struct rate_info *rinfo)
 {
@@ -2653,10 +2657,11 @@ static void sta_stats_decode_rate(struct ieee80211_local *local, u32 rate,
 	}
 }
 
-static int sta_set_rate_info_rx(struct sta_info *sta, struct rate_info *rinfo,
-				int link_id)
+static int sta_set_rate_info_rx(struct sta_info *sta,
+				struct link_sta_info *link_sta_info,
+				struct rate_info *rinfo)
 {
-	u32 rate = READ_ONCE(sta_get_last_rx_stats(sta, link_id)->last_rate);
+	u32 rate = READ_ONCE(sta_get_last_rx_stats(link_sta_info)->last_rate);
 
 	if (rate == STA_STATS_RATE_INVALID)
 		return -EINVAL;
@@ -2680,19 +2685,13 @@ static inline u64 sta_get_tidstats_msdu(struct ieee80211_sta_rx_stats *rxstats,
 }
 
 static void sta_set_tidstats(struct sta_info *sta,
+			     struct link_sta_info *link_sta_info,
 			     struct cfg80211_tid_stats *tidstats,
-			     int tid, int link_id)
+			     int tid, bool txq_stats)
 {
 	struct ieee80211_local *local = sta->local;
-	struct link_sta_info *link_sta_info;
 	int cpu;
 
-	if (link_id < 0)
-		link_sta_info = &sta->deflink;
-	else
-		link_sta_info = wiphy_dereference(sta->local->hw.wiphy,
-						  sta->link[link_id]);
-
 	if (!(tidstats->filled & BIT(NL80211_TID_STATS_RX_MSDU))) {
 		tidstats->rx_msdu +=
 			sta_get_tidstats_msdu(&link_sta_info->rx_stats,
@@ -2731,7 +2730,7 @@ static void sta_set_tidstats(struct sta_info *sta,
 			link_sta_info->status_stats.msdu_failed[tid];
 	}
 
-	if (link_id < 0 && tid < IEEE80211_NUM_TIDS) {
+	if (txq_stats && tid < IEEE80211_NUM_TIDS) {
 		spin_lock_bh(&local->fq.lock);
 
 		tidstats->filled |= BIT(NL80211_TID_STATS_TXQ_STATS);
@@ -2837,20 +2836,17 @@ static u32 sta_estimate_expected_throughput(struct sta_info *sta,
 }
 
 static void sta_set_link_sinfo(struct sta_info *sta,
+			       struct link_sta_info *link_sta_info,
 			       struct link_station_info *link_sinfo,
 			       struct ieee80211_link_data *link,
 			       bool tidstats)
 {
 	struct ieee80211_sub_if_data *sdata = sta->sdata;
 	struct ieee80211_sta_rx_stats *last_rxstats;
-	int i, ac, cpu, link_id = link->link_id;
-	struct link_sta_info *link_sta_info;
+	int i, ac, cpu;
 	u32 thr = 0;
 
-	last_rxstats = sta_get_last_rx_stats(sta, link_id);
-
-	link_sta_info = wiphy_dereference(sta->local->hw.wiphy,
-					  sta->link[link_id]);
+	last_rxstats = sta_get_last_rx_stats(link_sta_info);
 
 	/* do before driver, so beacon filtering drivers have a
 	 * chance to e.g. just add the number of filtered beacons
@@ -2876,8 +2872,7 @@ static void sta_set_link_sinfo(struct sta_info *sta,
 
 	link_sinfo->inactive_time =
 		jiffies_delta_to_msecs(jiffies -
-				       ieee80211_sta_last_active(sta,
-								 link_id));
+				       sta_link_last_active(link_sta_info));
 
 	if (!(link_sinfo->filled & (BIT_ULL(NL80211_STA_INFO_TX_BYTES64) |
 				    BIT_ULL(NL80211_STA_INFO_TX_BYTES)))) {
@@ -3025,8 +3020,8 @@ static void sta_set_link_sinfo(struct sta_info *sta,
 	}
 
 	if (!(link_sinfo->filled & BIT_ULL(NL80211_STA_INFO_RX_BITRATE))) {
-		if (sta_set_rate_info_rx(sta, &link_sinfo->rxrate,
-					 link_id) == 0)
+		if (sta_set_rate_info_rx(sta, link_sta_info,
+					 &link_sinfo->rxrate) == 0)
 			link_sinfo->filled |=
 				BIT_ULL(NL80211_STA_INFO_RX_BITRATE);
 	}
@@ -3034,8 +3029,8 @@ static void sta_set_link_sinfo(struct sta_info *sta,
 	if (tidstats && !cfg80211_link_sinfo_alloc_tid_stats(link_sinfo,
 							     GFP_KERNEL)) {
 		for (i = 0; i < IEEE80211_NUM_TIDS + 1; i++)
-			sta_set_tidstats(sta, &link_sinfo->pertid[i], i,
-					 link_id);
+			sta_set_tidstats(sta, link_sta_info,
+					 &link_sinfo->pertid[i], i, false);
 	}
 
 	if (sdata->vif.type == NL80211_IFTYPE_STATION) {
@@ -3091,7 +3086,7 @@ void sta_set_sinfo(struct sta_info *sta, struct station_info *sinfo,
 	int i, ac, cpu;
 	struct ieee80211_sta_rx_stats *last_rxstats;
 
-	last_rxstats = sta_get_last_rx_stats(sta, -1);
+	last_rxstats = sta_get_last_rx_stats(&sta->deflink);
 
 	sinfo->generation = sdata->local->sta_generation;
 
@@ -3119,7 +3114,7 @@ void sta_set_sinfo(struct sta_info *sta, struct station_info *sinfo,
 	sinfo->assoc_at = sta->assoc_at;
 	sinfo->inactive_time =
 		jiffies_delta_to_msecs(jiffies -
-				       ieee80211_sta_last_active(sta, -1));
+				       sta_link_last_active(&sta->deflink));
 
 	if (!(sinfo->filled & (BIT_ULL(NL80211_STA_INFO_TX_BYTES64) |
 			       BIT_ULL(NL80211_STA_INFO_TX_BYTES)))) {
@@ -3258,13 +3253,15 @@ void sta_set_sinfo(struct sta_info *sta, struct station_info *sinfo,
 
 	if (!(sinfo->filled & BIT_ULL(NL80211_STA_INFO_RX_BITRATE)) &&
 	    !sta->sta.valid_links) {
-		if (sta_set_rate_info_rx(sta, &sinfo->rxrate, -1) == 0)
+		if (sta_set_rate_info_rx(sta, &sta->deflink,
+					 &sinfo->rxrate) == 0)
 			sinfo->filled |= BIT_ULL(NL80211_STA_INFO_RX_BITRATE);
 	}
 
 	if (tidstats && !cfg80211_sinfo_alloc_tid_stats(sinfo, GFP_KERNEL)) {
 		for (i = 0; i < IEEE80211_NUM_TIDS + 1; i++)
-			sta_set_tidstats(sta, &sinfo->pertid[i], i, -1);
+			sta_set_tidstats(sta, &sta->deflink,
+					 &sinfo->pertid[i], i, true);
 	}
 
 #ifdef CONFIG_MAC80211_MESH
@@ -3367,7 +3364,8 @@ void sta_set_sinfo(struct sta_info *sta, struct station_info *sinfo,
 				sinfo->valid_links &= ~BIT(link_id);
 				continue;
 			}
-			sta_set_link_sinfo(sta, link_sinfo, link, tidstats);
+			sta_set_link_sinfo(sta, link_sta, link_sinfo, link,
+					   tidstats);
 			if (!thr &&
 			    (link_sinfo->filled & BIT_ULL(NL80211_STA_INFO_EXPECTED_THROUGHPUT)))
 				est_thr += link_sinfo->expected_throughput;
@@ -3400,22 +3398,15 @@ u32 sta_get_expected_throughput(struct sta_info *sta)
 
 unsigned long ieee80211_sta_last_active(struct sta_info *sta, int link_id)
 {
-	struct ieee80211_sta_rx_stats *stats;
 	struct link_sta_info *link_sta_info;
 
-	stats = sta_get_last_rx_stats(sta, link_id);
-
 	if (link_id < 0)
 		link_sta_info = &sta->deflink;
 	else
 		link_sta_info = wiphy_dereference(sta->local->hw.wiphy,
 						  sta->link[link_id]);
 
-	if (!link_sta_info->status_stats.last_ack ||
-	    time_after(stats->last_rx, link_sta_info->status_stats.last_ack))
-		return stats->last_rx;
-
-	return link_sta_info->status_stats.last_ack;
+	return sta_link_last_active(link_sta_info);
 }
 
 int ieee80211_sta_allocate_link(struct sta_info *sta, unsigned int link_id)
-- 
2.56.0

