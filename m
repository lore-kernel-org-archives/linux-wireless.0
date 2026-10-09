Received: from sipsolutions.net (s3.sipsolutions.net [168.119.38.16])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 58CD55013AB
	for <linux-wireless@vger.kernel.org>; Fri,  9 Oct 2026 18:14:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=168.119.38.16
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791569681; cv=none; b=IeR2If/vuCsohPG5lFXoXaTtZ1YR7Vtndsd3f+T7lp8g0g9ZwkVDN0CWB3neOtu3o3Qq3sgRvtEl4BUxDKkzpZ1TjNM0cRDVIOnDxtpeW9+hb3h+f8xm2NMSzXNOQealNV3XhFS8qG8he8q6AOhnyrNflAKOdhmQgcmLP8EUyUY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791569681; c=relaxed/simple;
	bh=eKrsVCas+R5QFBIQKD2nXlp19PvhwFd6MKtaWL8r23Y=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=OyXSMTDAjkia6CBc/0VVKsjqPszfkUa8z2mji1h7AtmEDx1vCQaUFPJmmhdxsuqTPNYFWUNZM2g3z75jFvtRG2Oo9fgrxIPrmUiiIJ6QU3kX7pqnNpe9gFoZcK995RfooPVtZm20GRKxmEySbcTt0MeLjq3o7r9NhyAbQQCAS80=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=permerror header.from=sipsolutions.net; spf=pass smtp.mailfrom=sipsolutions.net; dkim=pass (2048-bit key) header.d=sipsolutions.net header.i=@sipsolutions.net header.b=OpI9oul1; arc=none smtp.client-ip=168.119.38.16
Authentication-Results: smtp.subspace.kernel.org; dmarc=permerror header.from=sipsolutions.net
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=sipsolutions.net
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=sipsolutions.net header.i=@sipsolutions.net header.b="OpI9oul1"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=sipsolutions.net; s=mail; h=Content-Transfer-Encoding:MIME-Version:
	References:In-Reply-To:Message-ID:Date:Subject:Cc:To:From:Content-Type:Sender
	:Reply-To:Content-ID:Content-Description:Resent-Date:Resent-From:Resent-To:
	Resent-Cc:Resent-Message-ID; bh=cKf4pr6hgqesil4xsNfW7LK8w7tsiKtElT3cHPkXX4Q=;
	t=1791569679; x=1792779279; b=OpI9oul1xosVW7H4Z8ftWEqri8lx1yi3CcpIyyRBcPQpob1
	gbmCcoIIz3Ahkt3qxsMpfgS63JC0i+cQ47dhFXTo+N9dXWNYYwSUetqgxd5gTp0dePD15HXs3omE4
	7GA/qc0Sv4b83+bu6XXN3dSHCM55YrlKn2LIXuF8fOfxUv8w/2iPoUhO0yCIr/7wyuc72A1gqDYvP
	Xm6o7ChF+Fs17flZDDLRZyyO0Sd0qvHekM0f6Ttv0O2qWpct5ElLMwFjTPWzqBzuVXfGSZyFoW7V9
	rD3Pf/imnwhysxqBnnwNkDZfXaKZ5fNnvqekuILNs/DmybFEe+W2/dQ8slFoSgrQ==;
Received: by sipsolutions.net with esmtpsa (TLS1.3:ECDHE_X25519__ECDSA_SECP256R1_SHA256__AES_256_GCM:256)
	(Exim 4.98.2)
	(envelope-from <johannes@sipsolutions.net>)
	id 1xFF76-0000000AtGH-3k9W;
	Fri, 09 Oct 2026 20:14:37 +0200
From: Johannes Berg <johannes@sipsolutions.net>
To: linux-wireless@vger.kernel.org
Cc: Johannes Berg <johannes.berg@intel.com>
Subject: [PATCH wireless-next 17/17] wifi: mac80211: implement unlocked STA statistics
Date: Fri,  9 Oct 2026 20:10:16 +0200
Message-ID: <20261009201417.706683ff9d81.Ieb92e4c6599a198a116fa6a4f7944219c6d32932@changeid>
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

Implement the new cfg80211 unlocked STA statistics. If
the driver has an operation, then we need to always do
the locked again, so return -EAGAIN unconditionally if
it has a locked but not atomic operation, but drivers
can implement the new atomic methods to provide needed
data atomically (and can also return -EAGAIN).

This should, given a driver without any ops or adding
the atomic ops, reduce wiphy mutex contention.

Signed-off-by: Johannes Berg <johannes.berg@intel.com>
---
 include/net/mac80211.h    |  18 ++++++
 net/mac80211/cfg.c        | 120 ++++++++++++++++++++++++++++----------
 net/mac80211/driver-ops.c |  76 ++++++++++++++++++++++++
 net/mac80211/driver-ops.h |  46 ++++-----------
 net/mac80211/sta_info.c   |  54 ++++++++++-------
 net/mac80211/sta_info.h   |  10 +++-
 6 files changed, 233 insertions(+), 91 deletions(-)

diff --git a/include/net/mac80211.h b/include/net/mac80211.h
index 2a61079e3975..a1a6409b44c1 100644
--- a/include/net/mac80211.h
+++ b/include/net/mac80211.h
@@ -4369,6 +4369,13 @@ struct ieee80211_prep_tx_info {
  *	Statistics that the driver doesn't fill will be filled by mac80211.
  *	The callback can sleep.
  *
+ * @sta_statistics_atomic: Like @sta_statistics, but called under RCU, so it
+ *	must be atomic. This is called instead of @sta_statistics if available,
+ *	but may return -EAGAIN to fall back to @sta_statistics with the wiphy
+ *	mutex held.
+ *	Note that it's not guaranteed this will always be called first, some
+ *	(internal) calls may call @sta_statistics directly.
+ *
  * @link_sta_statistics: Get link statistics for this station. For example with
  *	beacon filtering, the statistics kept by mac80211 might not be
  *	accurate, so let the driver pre-fill the statistics. The driver can
@@ -4378,6 +4385,9 @@ struct ieee80211_prep_tx_info {
  *	Statistics that the driver doesn't fill will be filled by mac80211.
  *	The callback can sleep.
  *
+ * @link_sta_statistics_atomic: Like @link_sta_statistics, with the same
+ *	locking/retry semantics as @sta_statistics_atomic. Must be atomic.
+ *
  * @conf_tx: Configure TX queue parameters (EDCF (aifs, cw_min, cw_max),
  *	bursting) for a hardware TX queue.
  *	Returns a negative error code on failure.
@@ -4883,6 +4893,10 @@ struct ieee80211_ops {
 			       struct ieee80211_vif *vif,
 			       struct ieee80211_sta *sta,
 			       struct station_info *sinfo);
+	int (*sta_statistics_atomic)(struct ieee80211_hw *hw,
+				     struct ieee80211_vif *vif,
+				     struct ieee80211_sta *sta,
+				     struct station_info *sinfo);
 	int (*conf_tx)(struct ieee80211_hw *hw,
 		       struct ieee80211_vif *vif,
 		       unsigned int link_id, u16 ac,
@@ -4898,6 +4912,10 @@ struct ieee80211_ops {
 				    struct ieee80211_vif *vif,
 				    struct ieee80211_link_sta *link_sta,
 				    struct link_station_info *link_sinfo);
+	int (*link_sta_statistics_atomic)(struct ieee80211_hw *hw,
+					  struct ieee80211_vif *vif,
+					  struct ieee80211_link_sta *link_sta,
+					  struct link_station_info *link_sinfo);
 
 	/**
 	 * @ampdu_action:
diff --git a/net/mac80211/cfg.c b/net/mac80211/cfg.c
index 0acbb2415a02..9608c07bcea7 100644
--- a/net/mac80211/cfg.c
+++ b/net/mac80211/cfg.c
@@ -1018,31 +1018,63 @@ void sta_set_rate_info_tx(struct sta_info *sta,
 		rinfo->flags |= RATE_INFO_FLAGS_SHORT_GI;
 }
 
+static int __ieee80211_dump_station(struct ieee80211_sub_if_data *sdata,
+				    int idx, u8 *mac,
+				    struct station_info *sinfo, bool locked)
+{
+	struct sta_info *sta;
+	int ret;
+
+	sta = sta_info_get_by_idx(sdata, idx);
+	if (!sta)
+		return -ENOENT;
+
+	memcpy(mac, sta->sta.addr, ETH_ALEN);
+	ret = __sta_set_sinfo(sta, sinfo, true, locked);
+	if (ret)
+		return ret;
+
+	/*
+	 * Add accumulated removed link data to sinfo data for
+	 * consistency for MLO
+	 */
+	if (sinfo->valid_links)
+		sta_set_accumulated_removed_links_sinfo(sta, sinfo);
+
+	return 0;
+}
+
 static int ieee80211_dump_station(struct wiphy *wiphy, struct wireless_dev *wdev,
 				  int idx, u8 *mac, struct station_info *sinfo)
 {
 	struct ieee80211_sub_if_data *sdata = IEEE80211_WDEV_TO_SUB_IF(wdev);
-	struct ieee80211_local *local = sdata->local;
-	struct sta_info *sta;
-	int ret = -ENOENT;
 
-	lockdep_assert_wiphy(local->hw.wiphy);
+	lockdep_assert_wiphy(sdata->local->hw.wiphy);
 
-	sta = sta_info_get_by_idx(sdata, idx);
-	if (sta) {
-		ret = 0;
-		memcpy(mac, sta->sta.addr, ETH_ALEN);
-		sta_set_sinfo(sta, sinfo, true);
+	return __ieee80211_dump_station(sdata, idx, mac, sinfo, true);
+}
 
-		/* Add accumulated removed link data to sinfo data for
-		 * consistency for MLO
-		 */
-		if (sinfo->valid_links)
-			sta_set_accumulated_removed_links_sinfo(sta, sinfo);
+/* driver must have atomic ops (or none), otherwise we need the mutex */
+static bool ieee80211_sta_stats_need_mtx(struct ieee80211_local *local)
+{
+	const struct ieee80211_ops *ops = local->ops;
 
-	}
+	return (ops->sta_statistics && !ops->sta_statistics_atomic) ||
+	       (ops->link_sta_statistics && !ops->link_sta_statistics_atomic);
+}
 
-	return ret;
+static int ieee80211_dump_station_unlocked(struct wiphy *wiphy,
+					   struct wireless_dev *wdev,
+					   int idx, u8 *mac,
+					   struct station_info *sinfo)
+{
+	struct ieee80211_sub_if_data *sdata = IEEE80211_WDEV_TO_SUB_IF(wdev);
+
+	if (ieee80211_sta_stats_need_mtx(sdata->local))
+		return -EAGAIN;
+
+	guard(rcu)();
+	return __ieee80211_dump_station(sdata, idx, mac, sinfo, false);
 }
 
 static int ieee80211_dump_survey(struct wiphy *wiphy, struct net_device *dev,
@@ -1053,30 +1085,54 @@ static int ieee80211_dump_survey(struct wiphy *wiphy, struct net_device *dev,
 	return drv_get_survey(local, idx, survey);
 }
 
+static int __ieee80211_get_station(struct ieee80211_sub_if_data *sdata,
+				   const u8 *mac, struct station_info *sinfo,
+				   bool locked)
+{
+	struct sta_info *sta;
+	int ret;
+
+	sta = sta_info_get_bss(sdata, mac);
+	if (!sta)
+		return -ENOENT;
+
+	ret = __sta_set_sinfo(sta, sinfo, true, locked);
+	if (ret)
+		return ret;
+
+	/*
+	 * Add accumulated removed link data to sinfo data for
+	 * consistency for MLO
+	 */
+	if (sinfo->valid_links)
+		sta_set_accumulated_removed_links_sinfo(sta, sinfo);
+
+	return 0;
+}
+
 static int ieee80211_get_station(struct wiphy *wiphy,
 				 struct wireless_dev *wdev,
 				 const u8 *mac, struct station_info *sinfo)
 {
 	struct ieee80211_sub_if_data *sdata = IEEE80211_WDEV_TO_SUB_IF(wdev);
-	struct ieee80211_local *local = sdata->local;
-	struct sta_info *sta;
-	int ret = -ENOENT;
 
-	lockdep_assert_wiphy(local->hw.wiphy);
+	lockdep_assert_wiphy(sdata->local->hw.wiphy);
 
-	sta = sta_info_get_bss(sdata, mac);
-	if (sta) {
-		ret = 0;
-		sta_set_sinfo(sta, sinfo, true);
+	return __ieee80211_get_station(sdata, mac, sinfo, true);
+}
 
-		/* Add accumulated removed link data to sinfo data for
-		 * consistency for MLO
-		 */
-		if (sinfo->valid_links)
-			sta_set_accumulated_removed_links_sinfo(sta, sinfo);
-	}
+static int ieee80211_get_station_unlocked(struct wiphy *wiphy,
+					  struct wireless_dev *wdev,
+					  const u8 *mac,
+					  struct station_info *sinfo)
+{
+	struct ieee80211_sub_if_data *sdata = IEEE80211_WDEV_TO_SUB_IF(wdev);
 
-	return ret;
+	if (ieee80211_sta_stats_need_mtx(sdata->local))
+		return -EAGAIN;
+
+	guard(rcu)();
+	return __ieee80211_get_station(sdata, mac, sinfo, false);
 }
 
 static int ieee80211_set_monitor_channel(struct wiphy *wiphy,
@@ -6273,7 +6329,9 @@ const struct cfg80211_ops mac80211_config_ops = {
 	.del_station = ieee80211_del_station,
 	.change_station = ieee80211_change_station,
 	.get_station = ieee80211_get_station,
+	.get_station_unlocked = ieee80211_get_station_unlocked,
 	.dump_station = ieee80211_dump_station,
+	.dump_station_unlocked = ieee80211_dump_station_unlocked,
 	.dump_survey = ieee80211_dump_survey,
 #ifdef CONFIG_MAC80211_MESH
 	.add_mpath = ieee80211_add_mpath,
diff --git a/net/mac80211/driver-ops.c b/net/mac80211/driver-ops.c
index 49753b73aba2..1f3e0765a8ab 100644
--- a/net/mac80211/driver-ops.c
+++ b/net/mac80211/driver-ops.c
@@ -633,3 +633,79 @@ int drv_change_sta_links(struct ieee80211_local *local,
 
 	return 0;
 }
+
+int drv_sta_statistics(struct ieee80211_local *local,
+		       struct ieee80211_sub_if_data *sdata,
+		       struct ieee80211_sta *sta,
+		       struct station_info *sinfo,
+		       bool locked)
+{
+	int ret;
+
+	sdata = get_bss_sdata(sdata);
+	if (!check_sdata_in_driver(sdata))
+		return 0;
+
+	trace_drv_sta_statistics(local, sdata, sta);
+
+	if (locked) {
+		might_sleep();
+		lockdep_assert_wiphy(local->hw.wiphy);
+
+		ret = 0;
+
+		if (local->ops->sta_statistics)
+			local->ops->sta_statistics(&local->hw,
+						   &sdata->vif,
+						   sta, sinfo);
+	} else {
+		ret = -EAGAIN;
+
+		if (local->ops->sta_statistics_atomic)
+			ret = local->ops->sta_statistics_atomic(&local->hw,
+								&sdata->vif,
+								sta, sinfo);
+	}
+
+	trace_drv_return_int(local, ret);
+
+	return ret;
+}
+
+int drv_link_sta_statistics(struct ieee80211_local *local,
+			    struct ieee80211_sub_if_data *sdata,
+			    struct ieee80211_link_sta *link_sta,
+			    struct link_station_info *link_sinfo,
+			    bool locked)
+{
+	int ret;
+
+	sdata = get_bss_sdata(sdata);
+	if (!check_sdata_in_driver(sdata))
+		return 0;
+
+	if (locked) {
+		might_sleep();
+		lockdep_assert_wiphy(local->hw.wiphy);
+
+		ret = 0;
+
+		if (local->ops->link_sta_statistics)
+			local->ops->link_sta_statistics(&local->hw,
+							&sdata->vif,
+							link_sta,
+							link_sinfo);
+	} else {
+		ret = -EAGAIN;
+
+		if (local->ops->sta_statistics_atomic)
+			ret = local->ops->link_sta_statistics_atomic(&local->hw,
+								     &sdata->vif,
+								     link_sta,
+								     link_sinfo);
+	}
+
+	trace_drv_return_int(local, ret);
+
+	return 0;
+}
diff --git a/net/mac80211/driver-ops.h b/net/mac80211/driver-ops.h
index accd89bbc1fb..83dd15f2daf6 100644
--- a/net/mac80211/driver-ops.h
+++ b/net/mac80211/driver-ops.h
@@ -617,42 +617,16 @@ static inline void drv_sta_rate_tbl_update(struct ieee80211_local *local,
 	trace_drv_return_void(local);
 }
 
-static inline void drv_sta_statistics(struct ieee80211_local *local,
-				      struct ieee80211_sub_if_data *sdata,
-				      struct ieee80211_sta *sta,
-				      struct station_info *sinfo)
-{
-	might_sleep();
-	lockdep_assert_wiphy(local->hw.wiphy);
-
-	sdata = get_bss_sdata(sdata);
-	if (!check_sdata_in_driver(sdata))
-		return;
-
-	trace_drv_sta_statistics(local, sdata, sta);
-	if (local->ops->sta_statistics)
-		local->ops->sta_statistics(&local->hw, &sdata->vif, sta, sinfo);
-	trace_drv_return_void(local);
-}
-
-static inline void drv_link_sta_statistics(struct ieee80211_local *local,
-					   struct ieee80211_sub_if_data *sdata,
-					   struct ieee80211_link_sta *link_sta,
-					   struct link_station_info *link_sinfo)
-{
-	might_sleep();
-	lockdep_assert_wiphy(local->hw.wiphy);
-
-	sdata = get_bss_sdata(sdata);
-	if (!check_sdata_in_driver(sdata))
-		return;
-
-	trace_drv_link_sta_statistics(local, sdata, link_sta);
-	if (local->ops->link_sta_statistics)
-		local->ops->link_sta_statistics(&local->hw, &sdata->vif,
-						link_sta, link_sinfo);
-	trace_drv_return_void(local);
-}
+int drv_sta_statistics(struct ieee80211_local *local,
+		       struct ieee80211_sub_if_data *sdata,
+		       struct ieee80211_sta *sta,
+		       struct station_info *sinfo,
+		       bool locked);
+int drv_link_sta_statistics(struct ieee80211_local *local,
+			    struct ieee80211_sub_if_data *sdata,
+			    struct ieee80211_link_sta *link_sta,
+			    struct link_station_info *link_sinfo,
+			    bool locked);
 
 int drv_conf_tx(struct ieee80211_local *local,
 		struct ieee80211_link_data *link, u16 ac,
diff --git a/net/mac80211/sta_info.c b/net/mac80211/sta_info.c
index d761847b70b3..5c95ffee257d 100644
--- a/net/mac80211/sta_info.c
+++ b/net/mac80211/sta_info.c
@@ -2822,7 +2822,7 @@ static u32 sta_estimate_expected_throughput(struct sta_info *sta,
 	u32 duration;
 	u8 band;
 
-	conf = sdata_dereference(bss_conf->chanctx_conf, sta->sdata);
+	conf = rcu_dereference_wiphy(hw->wiphy, bss_conf->chanctx_conf);
 	if (!conf)
 		return 0;
 	band = conf->def.chan->band;
@@ -2835,15 +2835,15 @@ static u32 sta_estimate_expected_throughput(struct sta_info *sta,
 	return ((1024 * USEC_PER_SEC) / duration) * 8;
 }
 
-static void sta_set_link_sinfo(struct sta_info *sta,
-			       struct link_sta_info *link_sta_info,
-			       struct link_station_info *link_sinfo,
-			       struct ieee80211_link_data *link,
-			       bool tidstats)
+static int sta_set_link_sinfo(struct sta_info *sta,
+			      struct link_sta_info *link_sta_info,
+			      struct link_station_info *link_sinfo,
+			      struct ieee80211_link_data *link,
+			      bool tidstats, bool locked)
 {
 	struct ieee80211_sub_if_data *sdata = sta->sdata;
 	struct ieee80211_sta_rx_stats *last_rxstats;
-	int i, ac, cpu;
+	int i, ac, cpu, ret;
 	u32 thr = 0;
 
 	last_rxstats = sta_get_last_rx_stats(link_sta_info);
@@ -2857,9 +2857,10 @@ static void sta_set_link_sinfo(struct sta_info *sta,
 
 	ether_addr_copy(link_sinfo->addr, link_sta_info->addr);
 
-	drv_link_sta_statistics(sta->local, sdata,
-				link_sta_info->pub,
-				link_sinfo);
+	ret = drv_link_sta_statistics(sta->local, sdata, link_sta_info->pub,
+				      link_sinfo, locked);
+	if (ret)
+		return ret;
 
 	link_sinfo->filled |= BIT_ULL(NL80211_STA_INFO_INACTIVE_TIME) |
 			 BIT_ULL(NL80211_STA_INFO_RX_DROP_MISC);
@@ -3027,7 +3028,7 @@ static void sta_set_link_sinfo(struct sta_info *sta,
 	}
 
 	if (tidstats && !cfg80211_link_sinfo_alloc_tid_stats(link_sinfo,
-							     GFP_KERNEL)) {
+							     GFP_ATOMIC)) {
 		for (i = 0; i < IEEE80211_NUM_TIDS + 1; i++)
 			sta_set_tidstats(sta, link_sta_info,
 					 &link_sinfo->pertid[i], i, false);
@@ -3075,15 +3076,17 @@ static void sta_set_link_sinfo(struct sta_info *sta,
 		link_sinfo->filled |=
 			BIT_ULL(NL80211_STA_INFO_ACK_SIGNAL_AVG);
 	}
+
+	return 0;
 }
 
-void sta_set_sinfo(struct sta_info *sta, struct station_info *sinfo,
-		   bool tidstats)
+int __sta_set_sinfo(struct sta_info *sta, struct station_info *sinfo,
+		    bool tidstats, bool locked)
 {
 	struct ieee80211_sub_if_data *sdata = sta->sdata;
 	struct ieee80211_local *local = sdata->local;
 	u32 thr = 0;
-	int i, ac, cpu;
+	int i, ac, cpu, ret;
 	struct ieee80211_sta_rx_stats *last_rxstats;
 
 	last_rxstats = sta_get_last_rx_stats(&sta->deflink);
@@ -3097,7 +3100,10 @@ void sta_set_sinfo(struct sta_info *sta, struct station_info *sinfo,
 	if (sdata->vif.type == NL80211_IFTYPE_STATION)
 		sinfo->rx_beacon = sdata->deflink.u.mgd.count_beacon_signal;
 
-	drv_sta_statistics(local, sdata, &sta->sta, sinfo);
+	ret = drv_sta_statistics(local, sdata, &sta->sta, sinfo, locked);
+	if (ret)
+		return ret;
+
 	sinfo->filled |= BIT_ULL(NL80211_STA_INFO_INACTIVE_TIME) |
 			 BIT_ULL(NL80211_STA_INFO_STA_FLAGS) |
 			 BIT_ULL(NL80211_STA_INFO_CONNECTED_TIME) |
@@ -3258,7 +3264,7 @@ void sta_set_sinfo(struct sta_info *sta, struct station_info *sinfo,
 			sinfo->filled |= BIT_ULL(NL80211_STA_INFO_RX_BITRATE);
 	}
 
-	if (tidstats && !cfg80211_sinfo_alloc_tid_stats(sinfo, GFP_KERNEL)) {
+	if (tidstats && !cfg80211_sinfo_alloc_tid_stats(sinfo, GFP_ATOMIC)) {
 		for (i = 0; i < IEEE80211_NUM_TIDS + 1; i++)
 			sta_set_tidstats(sta, &sta->deflink,
 					 &sinfo->pertid[i], i, true);
@@ -3355,17 +3361,19 @@ void sta_set_sinfo(struct sta_info *sta, struct station_info *sinfo,
 		for_each_valid_link(sinfo, link_id) {
 			struct link_station_info *link_sinfo = sinfo->links[link_id];
 
-			link_sta = wiphy_dereference(sta->local->hw.wiphy,
-						     sta->link[link_id]);
-			link = wiphy_dereference(sdata->local->hw.wiphy,
-						 sdata->link[link_id]);
+			link_sta = rcu_dereference_wiphy(sta->local->hw.wiphy,
+							 sta->link[link_id]);
+			link = rcu_dereference_wiphy(sdata->local->hw.wiphy,
+						     sdata->link[link_id]);
 
 			if (!link_sta || !link_sinfo || !link) {
 				sinfo->valid_links &= ~BIT(link_id);
 				continue;
 			}
-			sta_set_link_sinfo(sta, link_sta, link_sinfo, link,
-					   tidstats);
+			ret = sta_set_link_sinfo(sta, link_sta, link_sinfo, link,
+						 tidstats, locked);
+			if (ret)
+				return ret;
 			if (!thr &&
 			    (link_sinfo->filled & BIT_ULL(NL80211_STA_INFO_EXPECTED_THROUGHPUT)))
 				est_thr += link_sinfo->expected_throughput;
@@ -3375,6 +3383,8 @@ void sta_set_sinfo(struct sta_info *sta, struct station_info *sinfo,
 			sinfo->expected_throughput = est_thr;
 		}
 	}
+
+	return 0;
 }
 
 u32 sta_get_expected_throughput(struct sta_info *sta)
diff --git a/net/mac80211/sta_info.h b/net/mac80211/sta_info.h
index f409f6a3afa1..8942541375b2 100644
--- a/net/mac80211/sta_info.h
+++ b/net/mac80211/sta_info.h
@@ -989,8 +989,14 @@ static inline int sta_info_flush(struct ieee80211_sub_if_data *sdata,
 void sta_set_rate_info_tx(struct sta_info *sta,
 			  const struct ieee80211_tx_rate *rate,
 			  struct rate_info *rinfo);
-void sta_set_sinfo(struct sta_info *sta, struct station_info *sinfo,
-		   bool tidstats);
+int __sta_set_sinfo(struct sta_info *sta, struct station_info *sinfo,
+		    bool tidstats, bool locked);
+
+static inline void sta_set_sinfo(struct sta_info *sta,
+				 struct station_info *sinfo, bool tidstats)
+{
+	__sta_set_sinfo(sta, sinfo, tidstats, true);
+}
 
 void sta_set_accumulated_removed_links_sinfo(struct sta_info *sta,
 					     struct station_info *sinfo);
-- 
2.56.0

