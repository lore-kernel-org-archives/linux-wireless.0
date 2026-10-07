Received: from sipsolutions.net (s3.sipsolutions.net [168.119.38.16])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6ADC2363C48
	for <linux-wireless@vger.kernel.org>; Wed,  7 Oct 2026 16:11:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=168.119.38.16
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791389466; cv=none; b=ABYFQyZ/6i7rLG+K2Y8lMHl7xXJQbSdM7YuTGBZ0QAEhXXjG2Lfp6g/DA8QdnOTgsmrKehcAD+CosI1mOAtKA1/9PTHWMX3Pd84KZE1LfR107OLnVePPmS3j3hm3D8VMHUAQT1B/PU0c2lB4QPxbAKUar3uJsaPqXKqT4Ffil8c=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791389466; c=relaxed/simple;
	bh=S0FnPBi5k3AG7vcAtO3Zx3qFFTOKLRhXN5mj6i4ItIM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=R7LKp3pDZEmG28hkUXuqBPVfegxcHbtmjuYRMyRPdZYpH7/JpxYZp4LnOaxcubhBVabJmN5Jdes/hkJTEEOLEoz0zlIIkJ+1fsDO5lb0XxQ7XD8UBSup8rknwXmC0EMGu+w1vsc9KnyMlsMINQAzMnytZGnrgCkhqis1CsBGGLU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=permerror header.from=sipsolutions.net; spf=pass smtp.mailfrom=sipsolutions.net; dkim=pass (2048-bit key) header.d=sipsolutions.net header.i=@sipsolutions.net header.b=JRXRGKzY; arc=none smtp.client-ip=168.119.38.16
Authentication-Results: smtp.subspace.kernel.org; dmarc=permerror header.from=sipsolutions.net
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=sipsolutions.net
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=sipsolutions.net header.i=@sipsolutions.net header.b="JRXRGKzY"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=sipsolutions.net; s=mail; h=Content-Transfer-Encoding:MIME-Version:
	References:In-Reply-To:Message-ID:Date:Subject:Cc:To:From:Content-Type:Sender
	:Reply-To:Content-ID:Content-Description:Resent-Date:Resent-From:Resent-To:
	Resent-Cc:Resent-Message-ID; bh=UayRxc0dkO4FwO71TbtLObyi5UkSFugzr5kQwEJfSvA=;
	t=1791389465; x=1792599065; b=JRXRGKzYn/k2QWcMRlecSTxLaPWd6FU9TDVGMIZclyJHxA0
	2LR8J/Y1wcslQOpm3kHQI7YTKC9cMQtZ4yVv35fnj+5tjwINGrQh84PXzOsiPH1MNGL/cuyzelyGQ
	FYoQO81j30BoHLPqC0+aGnmWcNP/ibSNU+SnBBFebi1016gNxRHbpRvJM1TdbgqTGJfaF078UoJwB
	rNRhSY0BKz7tNJoH1FYEg0NpgJVZflroF/7Q2iInT/y2D11BTTYH/yN7YKVuNccBM/2jCe6i1lFlI
	y+flXeWv1z3+t6tMrzAabnSXFSQTqKIA89ympZ0MAUpuuuRQQQ9ncqMxEXkEExlg==;
Received: by sipsolutions.net with esmtpsa (TLS1.3:ECDHE_X25519__ECDSA_SECP256R1_SHA256__AES_256_GCM:256)
	(Exim 4.98.2)
	(envelope-from <johannes@sipsolutions.net>)
	id 1xEUEQ-00000008DV1-2PTc;
	Wed, 07 Oct 2026 18:11:02 +0200
From: Johannes Berg <johannes@sipsolutions.net>
To: linux-wireless@vger.kernel.org
Cc: Johannes Berg <johannes.berg@intel.com>
Subject: [RFC PATCH 4/4] wifi: ath12k: implement unlocked station statistics
Date: Wed,  7 Oct 2026 18:09:48 +0200
Message-ID: <20261007181056.a809081196f8.I25af744cd23ebd73142a6170798a9fff90dfe34e@changeid>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261007161056.340373-6-johannes@sipsolutions.net>
References: <20261007161056.340373-6-johannes@sipsolutions.net>
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Johannes Berg <johannes.berg@intel.com>

Most of the time we just return cached statistics, that
can be done unlocked. If querying the firmware is needed,
return -EAGAIN to fall back to the locked version.

Signed-off-by: Johannes Berg <johannes.berg@intel.com>
---
 drivers/net/wireless/ath/ath12k/mac.c      | 117 +++++++++++++++------
 drivers/net/wireless/ath/ath12k/mac.h      |   8 ++
 drivers/net/wireless/ath/ath12k/wifi7/hw.c |   2 +
 3 files changed, 94 insertions(+), 33 deletions(-)

diff --git a/drivers/net/wireless/ath/ath12k/mac.c b/drivers/net/wireless/ath/ath12k/mac.c
index 196b807210de..c8af44c333cb 100644
--- a/drivers/net/wireless/ath/ath12k/mac.c
+++ b/drivers/net/wireless/ath/ath12k/mac.c
@@ -920,7 +920,8 @@ struct ath12k *ath12k_get_ar_by_vif(struct ieee80211_hw *hw,
 	struct ath12k_hw *ah = ath12k_hw_to_ah(hw);
 	struct ath12k_link_vif *arvif;
 
-	lockdep_assert_wiphy(hw->wiphy);
+	/* also used under RCU for station statistics */
+	lockdep_assert(lockdep_is_held(&hw->wiphy->mtx) || rcu_read_lock_held());
 
 	/* If there is one pdev within ah, then we return
 	 * ar directly.
@@ -931,7 +932,7 @@ struct ath12k *ath12k_get_ar_by_vif(struct ieee80211_hw *hw,
 	if (!(ahvif->links_map & BIT(link_id)))
 		return NULL;
 
-	arvif = wiphy_dereference(hw->wiphy, ahvif->link[link_id]);
+	arvif = rcu_dereference_wiphy(hw->wiphy, ahvif->link[link_id]);
 	if (arvif && arvif->is_created)
 		return arvif->ar;
 
@@ -13737,10 +13738,11 @@ static void ath12k_mac_put_chain_rssi(struct station_info *sinfo,
 	}
 }
 
-void ath12k_mac_op_sta_statistics(struct ieee80211_hw *hw,
-				  struct ieee80211_vif *vif,
-				  struct ieee80211_sta *sta,
-				  struct station_info *sinfo)
+static int ath12k_mac_sta_statistics(struct ieee80211_hw *hw,
+				     struct ieee80211_vif *vif,
+				     struct ieee80211_sta *sta,
+				     struct station_info *sinfo,
+				     bool atomic)
 {
 	struct ath12k_sta *ahsta = ath12k_sta_to_ahsta(sta);
 	struct ath12k_dp_link_peer_rate_info rate_info = {};
@@ -13752,12 +13754,17 @@ void ath12k_mac_op_sta_statistics(struct ieee80211_hw *hw,
 	struct ath12k *ar;
 	bool db2dbm;
 
-	lockdep_assert_wiphy(hw->wiphy);
+	/* station interfaces query the firmware, which sleeps */
+	if (atomic && ahsta->ahvif->vdev_type == WMI_VDEV_TYPE_STA)
+		return -EAGAIN;
+
+	if (!atomic)
+		lockdep_assert_wiphy(hw->wiphy);
 
 	arsta = &ahsta->deflink;
 	ar = ath12k_get_ar_by_vif(hw, vif, arsta->link_id);
 	if (!ar)
-		return;
+		return 0;
 
 	dp = ath12k_ab_to_dp(ar->ab);
 	ath12k_dp_link_peer_get_sta_rate_info_stats(dp, arsta->addr, &rate_info);
@@ -13791,23 +13798,22 @@ void ath12k_mac_op_sta_statistics(struct ieee80211_hw *hw,
 	/* TODO: Use real NF instead of default one. */
 	signal = rate_info.rssi_comb;
 
-	params.pdev_id = ath12k_mac_get_target_pdev_id(ar);
-	params.vdev_id = 0;
-	params.stats_id = WMI_REQUEST_VDEV_STAT;
+	if (ahsta->ahvif->vdev_type == WMI_VDEV_TYPE_STA) {
+		params.pdev_id = ath12k_mac_get_target_pdev_id(ar);
+		params.vdev_id = 0;
+		params.stats_id = WMI_REQUEST_VDEV_STAT;
 
-	if (!signal &&
-	    ahsta->ahvif->vdev_type == WMI_VDEV_TYPE_STA &&
-	    !(ath12k_mac_get_fw_stats(ar, &params))) {
-		signal = arsta->rssi_beacon;
-		ath12k_fw_stats_reset(ar);
-	}
+		if (!signal && !ath12k_mac_get_fw_stats(ar, &params)) {
+			signal = arsta->rssi_beacon;
+			ath12k_fw_stats_reset(ar);
+		}
 
-	params.stats_id = WMI_REQUEST_RSSI_PER_CHAIN_STAT;
-	if (!(sinfo->filled & BIT_ULL(NL80211_STA_INFO_CHAIN_SIGNAL)) &&
-	    ahsta->ahvif->vdev_type == WMI_VDEV_TYPE_STA &&
-	    !(ath12k_mac_get_fw_stats(ar, &params))) {
-		ath12k_mac_put_chain_rssi(sinfo, arsta);
-		ath12k_fw_stats_reset(ar);
+		params.stats_id = WMI_REQUEST_RSSI_PER_CHAIN_STAT;
+		if (!(sinfo->filled & BIT_ULL(NL80211_STA_INFO_CHAIN_SIGNAL)) &&
+		    !ath12k_mac_get_fw_stats(ar, &params)) {
+			ath12k_mac_put_chain_rssi(sinfo, arsta);
+			ath12k_fw_stats_reset(ar);
+		}
 	}
 
 	spin_lock_bh(&ar->data_lock);
@@ -13830,7 +13836,7 @@ void ath12k_mac_op_sta_statistics(struct ieee80211_hw *hw,
 	peer = ath12k_dp_link_peer_find_by_addr(dp, arsta->addr);
 	if (!peer) {
 		spin_unlock_bh(&dp->dp_lock);
-		return;
+		return 0;
 	}
 
 	sinfo->tx_retries = peer->tx_retry_count;
@@ -13839,13 +13845,32 @@ void ath12k_mac_op_sta_statistics(struct ieee80211_hw *hw,
 	sinfo->filled |= BIT_ULL(NL80211_STA_INFO_TX_FAILED);
 
 	spin_unlock_bh(&dp->dp_lock);
+	return 0;
+}
+
+void ath12k_mac_op_sta_statistics(struct ieee80211_hw *hw,
+				  struct ieee80211_vif *vif,
+				  struct ieee80211_sta *sta,
+				  struct station_info *sinfo)
+{
+	ath12k_mac_sta_statistics(hw, vif, sta, sinfo, false);
 }
 EXPORT_SYMBOL(ath12k_mac_op_sta_statistics);
 
-void ath12k_mac_op_link_sta_statistics(struct ieee80211_hw *hw,
-				       struct ieee80211_vif *vif,
-				       struct ieee80211_link_sta *link_sta,
-				       struct link_station_info *link_sinfo)
+int ath12k_mac_op_sta_statistics_atomic(struct ieee80211_hw *hw,
+					struct ieee80211_vif *vif,
+					struct ieee80211_sta *sta,
+					struct station_info *sinfo)
+{
+	return ath12k_mac_sta_statistics(hw, vif, sta, sinfo, true);
+}
+EXPORT_SYMBOL(ath12k_mac_op_sta_statistics_atomic);
+
+static int ath12k_mac_link_sta_statistics(struct ieee80211_hw *hw,
+					  struct ieee80211_vif *vif,
+					  struct ieee80211_link_sta *link_sta,
+					  struct link_station_info *link_sinfo,
+					  bool atomic)
 {
 	struct ath12k_sta *ahsta = ath12k_sta_to_ahsta(link_sta->sta);
 	struct ath12k_fw_stats_req_params params = {};
@@ -13855,16 +13880,22 @@ void ath12k_mac_op_link_sta_statistics(struct ieee80211_hw *hw,
 	s8 signal;
 	bool db2dbm;
 
-	lockdep_assert_wiphy(hw->wiphy);
+	/* station interfaces query the firmware, which sleeps */
+	if (atomic && ahsta->ahvif->vdev_type == WMI_VDEV_TYPE_STA)
+		return -EAGAIN;
 
-	arsta = wiphy_dereference(hw->wiphy, ahsta->link[link_sta->link_id]);
+	if (!atomic)
+		lockdep_assert_wiphy(hw->wiphy);
+
+	arsta = rcu_dereference_wiphy(hw->wiphy,
+				      ahsta->link[link_sta->link_id]);
 
 	if (!arsta)
-		return;
+		return 0;
 
 	ar = ath12k_get_ar_by_vif(hw, vif, arsta->link_id);
 	if (!ar)
-		return;
+		return 0;
 
 	db2dbm = test_bit(WMI_TLV_SERVICE_HW_DB2DBM_CONVERSION_SUPPORT,
 			  ar->ab->wmi_ab.svc_map);
@@ -13873,7 +13904,7 @@ void ath12k_mac_op_link_sta_statistics(struct ieee80211_hw *hw,
 	peer = ath12k_dp_link_peer_find_by_addr(ar->ab->dp, arsta->addr);
 	if (!peer) {
 		spin_unlock_bh(&ar->ab->dp->dp_lock);
-		return;
+		return 0;
 	}
 
 	link_sinfo->rx_duration = peer->rx_duration;
@@ -13934,9 +13965,29 @@ void ath12k_mac_op_link_sta_statistics(struct ieee80211_hw *hw,
 			db2dbm ? signal : signal + ATH12K_DEFAULT_NOISE_FLOOR;
 		link_sinfo->filled |= BIT_ULL(NL80211_STA_INFO_SIGNAL);
 	}
+
+	return 0;
+}
+
+void ath12k_mac_op_link_sta_statistics(struct ieee80211_hw *hw,
+				       struct ieee80211_vif *vif,
+				       struct ieee80211_link_sta *link_sta,
+				       struct link_station_info *link_sinfo)
+{
+	ath12k_mac_link_sta_statistics(hw, vif, link_sta, link_sinfo, false);
 }
 EXPORT_SYMBOL(ath12k_mac_op_link_sta_statistics);
 
+int ath12k_mac_op_link_sta_statistics_atomic(struct ieee80211_hw *hw,
+					     struct ieee80211_vif *vif,
+					     struct ieee80211_link_sta *link_sta,
+					     struct link_station_info *link_sinfo)
+{
+	return ath12k_mac_link_sta_statistics(hw, vif, link_sta, link_sinfo,
+					      true);
+}
+EXPORT_SYMBOL(ath12k_mac_op_link_sta_statistics_atomic);
+
 int ath12k_mac_op_cancel_remain_on_channel(struct ieee80211_hw *hw,
 					   struct ieee80211_vif *vif)
 {
diff --git a/drivers/net/wireless/ath/ath12k/mac.h b/drivers/net/wireless/ath/ath12k/mac.h
index aba98afd4365..530672fd8da7 100644
--- a/drivers/net/wireless/ath/ath12k/mac.h
+++ b/drivers/net/wireless/ath/ath12k/mac.h
@@ -311,10 +311,18 @@ void ath12k_mac_op_sta_statistics(struct ieee80211_hw *hw,
 				  struct ieee80211_vif *vif,
 				  struct ieee80211_sta *sta,
 				  struct station_info *sinfo);
+int ath12k_mac_op_sta_statistics_atomic(struct ieee80211_hw *hw,
+					struct ieee80211_vif *vif,
+					struct ieee80211_sta *sta,
+					struct station_info *sinfo);
 void ath12k_mac_op_link_sta_statistics(struct ieee80211_hw *hw,
 				       struct ieee80211_vif *vif,
 				       struct ieee80211_link_sta *link_sta,
 				       struct link_station_info *link_sinfo);
+int ath12k_mac_op_link_sta_statistics_atomic(struct ieee80211_hw *hw,
+					     struct ieee80211_vif *vif,
+					     struct ieee80211_link_sta *link_sta,
+					     struct link_station_info *link_sinfo);
 int ath12k_mac_op_remain_on_channel(struct ieee80211_hw *hw,
 				    struct ieee80211_vif *vif,
 				    struct ieee80211_channel *chan,
diff --git a/drivers/net/wireless/ath/ath12k/wifi7/hw.c b/drivers/net/wireless/ath/ath12k/wifi7/hw.c
index aec7c652808c..8a721afa05a3 100644
--- a/drivers/net/wireless/ath/ath12k/wifi7/hw.c
+++ b/drivers/net/wireless/ath/ath12k/wifi7/hw.c
@@ -1207,7 +1207,9 @@ static const struct ieee80211_ops ath12k_ops_wifi7 = {
 	.get_survey			= ath12k_mac_op_get_survey,
 	.flush				= ath12k_mac_op_flush,
 	.sta_statistics			= ath12k_mac_op_sta_statistics,
+	.sta_statistics_atomic		= ath12k_mac_op_sta_statistics_atomic,
 	.link_sta_statistics		= ath12k_mac_op_link_sta_statistics,
+	.link_sta_statistics_atomic	= ath12k_mac_op_link_sta_statistics_atomic,
 	.remain_on_channel              = ath12k_mac_op_remain_on_channel,
 	.cancel_remain_on_channel       = ath12k_mac_op_cancel_remain_on_channel,
 	.change_sta_links               = ath12k_mac_op_change_sta_links,
-- 
2.56.0

