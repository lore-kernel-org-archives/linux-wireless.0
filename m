Received: from sipsolutions.net (s3.sipsolutions.net [168.119.38.16])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AB0F63B27E7
	for <linux-wireless@vger.kernel.org>; Tue,  6 Oct 2026 10:07:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=168.119.38.16
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791281241; cv=none; b=oIoDJ/m6zFTEeZ0Ygurl7J56nAlzyqVQP+fM2CSf3r3wscgB8/GqeVp26hm3TlD8QIJWEHkwn2ixv0uXZ+GwVGK2djhk+yDieR3d3yqAK7ZZ2ur3PZbMyREr5xQhsHXkm9s2FSnvOUxUpSLjMHuUEHHcKls68WBilnSeoaKcIq8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791281241; c=relaxed/simple;
	bh=LkCOEJF5FgzvsFSUJjXHMus5m7IQ9X5p9nAkK4YYpP8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=GXKij4x7yaIVoss9VnR27/M9wcSoUs86qmoP+J7DZKeaJRJQLgTYz+itpDAVtcedAP9bCnWuwBS5ER48cGeNhcwx/GPSkIbgN8+FdV6JOjFLik6XcjmpE/OJQ7DZu7GjyCSQcPpoFmQra53b+3sz0NnRYcP9Xn85a/trHThPXPI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=permerror header.from=sipsolutions.net; spf=pass smtp.mailfrom=sipsolutions.net; dkim=pass (2048-bit key) header.d=sipsolutions.net header.i=@sipsolutions.net header.b=rN+8VcIi; arc=none smtp.client-ip=168.119.38.16
Authentication-Results: smtp.subspace.kernel.org; dmarc=permerror header.from=sipsolutions.net
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=sipsolutions.net
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=sipsolutions.net header.i=@sipsolutions.net header.b="rN+8VcIi"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=sipsolutions.net; s=mail; h=Content-Transfer-Encoding:MIME-Version:
	References:In-Reply-To:Message-ID:Date:Subject:Cc:To:From:Content-Type:Sender
	:Reply-To:Content-ID:Content-Description:Resent-Date:Resent-From:Resent-To:
	Resent-Cc:Resent-Message-ID; bh=dAn4I9kX4xl9XS/b6iJjU0TX0X0zcSGQlyE71y7fhhE=;
	t=1791281238; x=1792490838; b=rN+8VcIicqqkSAoisTojf0yvbRu47MYwNnryN/UOPWqsmz/
	qAKQOfu97IAm5dQp9zCXV7xej1d7Gx0HKestOdKTfxcndT6qBz2lg2bkL2FQz8OnW51CnBoWQQGDs
	uUpfBFbhn4pJ8z9vROJhXtPlFziRyO2tv05U4BovFw+vYwbHhu7nqaQLqxI8szyDQtRfS+foX8nWq
	IQ8iAom0T1RJjHPIIa9tE6C+g8u9PrmtlWsKTfm8/IyHRPb+hL3HKtd/m5Ub5gljbfZMnD+rgXFWi
	rSpx30b+ha3JFJifxLMOfi598dnMJLjI5wM2NwG/ps28b/QIByAe5wqBMjgnRx+w==;
Received: by sipsolutions.net with esmtpsa (TLS1.3:ECDHE_X25519__ECDSA_SECP256R1_SHA256__AES_256_GCM:256)
	(Exim 4.98.2)
	(envelope-from <johannes@sipsolutions.net>)
	id 1xE24q-00000006XqW-0Aq1;
	Tue, 06 Oct 2026 12:07:16 +0200
From: Johannes Berg <johannes@sipsolutions.net>
To: linux-wireless@vger.kernel.org
Cc: Johannes Berg <johannes.berg@intel.com>
Subject: [PATCH wireless-next v3 19/19] wifi: cfg80211: regulatory: stop using RTNL
Date: Tue,  6 Oct 2026 12:04:17 +0200
Message-ID: <20261006120655.df1d3d28cfa2.I637dbd328886b52bed511fb798172a2d57521263@changeid>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20261006100655.2687533-21-johannes@sipsolutions.net>
References: <20261006100655.2687533-21-johannes@sipsolutions.net>
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Johannes Berg <johannes.berg@intel.com>

Now we have cfg80211_mutex everywhere along with wiphy mutex
for per-device bits, so don't need RTNL any more. Remove it
from the regulatory code.

Also, wiphy_apply_custom_regulatory() no longer needs the RTNL,
and get_wiphy_regdom() can no longer rely on it.

Signed-off-by: Johannes Berg <johannes.berg@intel.com>
---
v3: protect reg notifier with wiphy mutex
---
 drivers/net/wireless/ath/ath12k/reg.c     |   2 -
 drivers/net/wireless/realtek/rtw89/regd.c |   3 -
 include/net/cfg80211.h                    |   9 +-
 net/wireless/chan.c                       |   2 +-
 net/wireless/core.c                       |  12 +--
 net/wireless/mlme.c                       |   3 -
 net/wireless/nl80211.c                    |  11 +-
 net/wireless/reg.c                        | 117 ++++++++++------------
 8 files changed, 67 insertions(+), 92 deletions(-)

diff --git a/drivers/net/wireless/ath/ath12k/reg.c b/drivers/net/wireless/ath/ath12k/reg.c
index d7065fa73c50..7cf3dbc4fc8a 100644
--- a/drivers/net/wireless/ath/ath12k/reg.c
+++ b/drivers/net/wireless/ath/ath12k/reg.c
@@ -124,9 +124,7 @@ ath12k_reg_notifier(struct wiphy *wiphy, struct regulatory_request *request)
 					    "failed set INIT Country code: %d\n", ret);
 		}
 
-		wiphy_lock(wiphy);
 		ath12k_mac_11d_scan_stop(ar);
-		wiphy_unlock(wiphy);
 
 		ar->regdom_set_by_user = true;
 	}
diff --git a/drivers/net/wireless/realtek/rtw89/regd.c b/drivers/net/wireless/realtek/rtw89/regd.c
index b9a5ce218b1d..983b42e193b5 100644
--- a/drivers/net/wireless/realtek/rtw89/regd.c
+++ b/drivers/net/wireless/realtek/rtw89/regd.c
@@ -898,7 +898,6 @@ void rtw89_regd_notifier(struct wiphy *wiphy, struct regulatory_request *request
 	struct ieee80211_hw *hw = wiphy_to_ieee80211_hw(wiphy);
 	struct rtw89_dev *rtwdev = hw->priv;
 
-	wiphy_lock(wiphy);
 	rtw89_leave_ps_mode(rtwdev);
 
 	if (rtwdev->regulatory.programmed)
@@ -916,8 +915,6 @@ void rtw89_regd_notifier(struct wiphy *wiphy, struct regulatory_request *request
 	rtw89_regd_apply_policy_ant_gain(rtwdev);
 
 	rtw89_core_set_chip_txpwr(rtwdev);
-
-	wiphy_unlock(wiphy);
 }
 
 /* Maximum Transmit Power field (@raw) can be EIRP or PSD.
diff --git a/include/net/cfg80211.h b/include/net/cfg80211.h
index 120bc91a4e79..378fa52bfbab 100644
--- a/include/net/cfg80211.h
+++ b/include/net/cfg80211.h
@@ -6362,7 +6362,8 @@ struct wiphy_nan_capa {
  * @mtx: mutex for the data (structures) of this device
  * @reg_notifier: the driver's regulatory notification callback,
  *	note that if your driver uses wiphy_apply_custom_regulatory()
- *	the reg_notifier's request can be passed as NULL
+ *	the reg_notifier's request can be passed as NULL.
+ *	This is called under wiphy mutex.
  * @regd: the driver's regulatory domain, if one was requested via
  *	the regulatory_hint() API. This can be used by the driver
  *	on the reg_notifier() if it chooses to ignore future
@@ -8160,9 +8161,9 @@ int regulatory_set_wiphy_regd(struct wiphy *wiphy,
  * @wiphy: the wireless device we want to process the regulatory domain on
  * @rd: the regulatory domain information to use for this wiphy
  *
- * This functions requires the RTNL and the wiphy mutex to be held and
- * applies the new regdomain synchronously to this wiphy. For more details
- * see regulatory_set_wiphy_regd().
+ * This functions requires the wiphy mutex to be held and applies the new
+ * regdomain synchronously to this wiphy. For more details see
+ * regulatory_set_wiphy_regd().
  *
  * Return: 0 on success. -EINVAL, -EPERM
  */
diff --git a/net/wireless/chan.c b/net/wireless/chan.c
index c743b6fb7e30..9183cd19dbdc 100644
--- a/net/wireless/chan.c
+++ b/net/wireless/chan.c
@@ -1243,7 +1243,7 @@ bool cfg80211_any_wiphy_oper_chan(struct wiphy *wiphy,
 {
 	struct cfg80211_registered_device *rdev;
 
-	ASSERT_RTNL();
+	lockdep_assert_held(&cfg80211_mutex);
 
 	if (!(chan->flags & IEEE80211_CHAN_RADAR))
 		return false;
diff --git a/net/wireless/core.c b/net/wireless/core.c
index 75d5727d8673..01b077909179 100644
--- a/net/wireless/core.c
+++ b/net/wireless/core.c
@@ -560,15 +560,11 @@ static void cfg80211_propagate_radar_detect_wk(struct work_struct *work)
 	rdev = container_of(work, struct cfg80211_registered_device,
 			    propagate_radar_detect_wk);
 
-	rtnl_lock();
-	mutex_lock(&cfg80211_mutex);
+	guard(mutex)(&cfg80211_mutex);
 
 	regulatory_propagate_dfs_state(&rdev->wiphy, &rdev->radar_chandef,
 				       NL80211_DFS_UNAVAILABLE,
 				       NL80211_RADAR_DETECTED);
-
-	mutex_unlock(&cfg80211_mutex);
-	rtnl_unlock();
 }
 
 static void cfg80211_propagate_cac_done_wk(struct work_struct *work)
@@ -578,15 +574,11 @@ static void cfg80211_propagate_cac_done_wk(struct work_struct *work)
 	rdev = container_of(work, struct cfg80211_registered_device,
 			    propagate_cac_done_wk);
 
-	rtnl_lock();
-	mutex_lock(&cfg80211_mutex);
+	guard(mutex)(&cfg80211_mutex);
 
 	regulatory_propagate_dfs_state(&rdev->wiphy, &rdev->cac_done_chandef,
 				       NL80211_DFS_AVAILABLE,
 				       NL80211_RADAR_CAC_FINISHED);
-
-	mutex_unlock(&cfg80211_mutex);
-	rtnl_unlock();
 }
 
 static void cfg80211_wiphy_work(struct work_struct *work)
diff --git a/net/wireless/mlme.c b/net/wireless/mlme.c
index 082590d859e9..96fd14f2a305 100644
--- a/net/wireless/mlme.c
+++ b/net/wireless/mlme.c
@@ -1119,7 +1119,6 @@ void cfg80211_dfs_channels_update_work(struct work_struct *work)
 			    dfs_update_channels_wk);
 	wiphy = &rdev->wiphy;
 
-	rtnl_lock();
 	mutex_lock(&cfg80211_mutex);
 	wiphy_lock(wiphy);
 	for (bandid = 0; bandid < NUM_NL80211_BANDS; bandid++) {
@@ -1135,7 +1134,6 @@ void cfg80211_dfs_channels_update_work(struct work_struct *work)
 				   HZ);
 		wiphy_unlock(wiphy);
 		mutex_unlock(&cfg80211_mutex);
-		rtnl_unlock();
 		return;
 	}
 
@@ -1202,7 +1200,6 @@ void cfg80211_dfs_channels_update_work(struct work_struct *work)
 					       expired[i].event);
 	}
 	mutex_unlock(&cfg80211_mutex);
-	rtnl_unlock();
 
 	kvfree(expired);
 
diff --git a/net/wireless/nl80211.c b/net/wireless/nl80211.c
index dd66a3146097..48f5584d7c2b 100644
--- a/net/wireless/nl80211.c
+++ b/net/wireless/nl80211.c
@@ -63,7 +63,7 @@ static const struct genl_multicast_group nl80211_mcgrps[] = {
 #endif
 };
 
-/* returns ERR_PTR values, requires RCU/cfg80211_mutex/RTNL if rdev is %NULL */
+/* returns ERR_PTR values, requires RCU/cfg80211_mutex if rdev is %NULL */
 static struct wireless_dev *
 __cfg80211_wdev_from_attrs(struct cfg80211_registered_device *rdev,
 			   struct net *netns, struct nlattr **attrs)
@@ -136,7 +136,7 @@ __cfg80211_wdev_from_attrs(struct cfg80211_registered_device *rdev,
 	return ERR_PTR(-ENODEV);
 }
 
-/* requires RCU/cfg80211_mutex/RTNL */
+/* requires RCU/cfg80211_mutex */
 static struct cfg80211_registered_device *
 __cfg80211_rdev_from_attrs(struct net *netns, struct nlattr **attrs)
 {
@@ -11049,7 +11049,6 @@ static int nl80211_set_reg(struct sk_buff *skb, struct genl_info *info)
 			return -EINVAL;
 	}
 
-	rtnl_lock();
 	mutex_lock(&cfg80211_mutex);
 	if (!reg_is_valid_request(alpha2)) {
 		r = -EINVAL;
@@ -11099,7 +11098,6 @@ static int nl80211_set_reg(struct sk_buff *skb, struct genl_info *info)
 	kfree(rd);
  out:
 	mutex_unlock(&cfg80211_mutex);
-	rtnl_unlock();
 	return r;
 }
 #endif /* CONFIG_CFG80211_CRDA_SUPPORT */
@@ -21203,7 +21201,10 @@ static bool nl80211_reg_change_event_fill(struct sk_buff *msg,
 	}
 
 	if (request->wiphy_idx != WIPHY_IDX_INVALID) {
-		struct wiphy *wiphy = wiphy_idx_to_wiphy(request->wiphy_idx);
+		struct wiphy *wiphy;
+
+		guard(rcu)();
+		wiphy = wiphy_idx_to_wiphy(request->wiphy_idx);
 
 		if (wiphy &&
 		    nla_put_u32(msg, NL80211_ATTR_WIPHY, request->wiphy_idx))
diff --git a/net/wireless/reg.c b/net/wireless/reg.c
index 7ac770a90a4b..4efb35baeb3e 100644
--- a/net/wireless/reg.c
+++ b/net/wireless/reg.c
@@ -129,20 +129,18 @@ static void reg_process_hint(struct regulatory_request *reg_request);
 static const struct ieee80211_regdomain *get_cfg80211_regdom(void)
 {
 	return rcu_dereference_check(cfg80211_regdomain,
-				     lockdep_is_held(&cfg80211_mutex) ||
-				     lockdep_rtnl_is_held());
+				     lockdep_is_held(&cfg80211_mutex));
 }
 
 /*
  * Returns the regulatory domain associated with the wiphy.
  *
- * Requires any of RTNL, wiphy mutex or RCU protection.
+ * Requires the wiphy mutex or RCU protection.
  */
 const struct ieee80211_regdomain *get_wiphy_regdom(struct wiphy *wiphy)
 {
 	return rcu_dereference_check(wiphy->regd,
-				     lockdep_is_held(&wiphy->mtx) ||
-				     lockdep_rtnl_is_held());
+				     lockdep_is_held(&wiphy->mtx));
 }
 EXPORT_SYMBOL(get_wiphy_regdom);
 
@@ -207,8 +205,7 @@ static void rcu_free_regdom(const struct ieee80211_regdomain *r)
 static struct regulatory_request *get_last_request(void)
 {
 	return rcu_dereference_check(last_request,
-				     lockdep_is_held(&cfg80211_mutex) ||
-				     lockdep_rtnl_is_held());
+				     lockdep_is_held(&cfg80211_mutex));
 }
 
 /* Used to queue up regulatory hints */
@@ -479,7 +476,6 @@ static void reg_regdb_apply(struct work_struct *work)
 {
 	struct reg_regdb_apply_request *request;
 
-	rtnl_lock();
 	mutex_lock(&cfg80211_mutex);
 
 	mutex_lock(&reg_regdb_apply_mutex);
@@ -495,7 +491,6 @@ static void reg_regdb_apply(struct work_struct *work)
 	mutex_unlock(&reg_regdb_apply_mutex);
 
 	mutex_unlock(&cfg80211_mutex);
-	rtnl_unlock();
 }
 
 static DECLARE_WORK(reg_regdb_work, reg_regdb_apply);
@@ -532,12 +527,10 @@ static DECLARE_DELAYED_WORK(crda_timeout, crda_timeout_work);
 static void crda_timeout_work(struct work_struct *work)
 {
 	pr_debug("Timeout while waiting for CRDA to reply, restoring regulatory settings\n");
-	rtnl_lock();
 	mutex_lock(&cfg80211_mutex);
 	reg_crda_timeouts++;
 	restore_regulatory_settings(true, false);
 	mutex_unlock(&cfg80211_mutex);
-	rtnl_unlock();
 }
 
 static void cancel_crda_timeout(void)
@@ -985,7 +978,6 @@ static int query_regdb(const char *alpha2)
 	const struct fwdb_header *regdb;
 
 	regdb = rcu_dereference_protected(global_regdb,
-					  lockdep_rtnl_is_held() ||
 					  lockdep_is_held(&cfg80211_mutex));
 
 	if (IS_ERR(regdb))
@@ -1016,10 +1008,8 @@ static void regdb_fw_cb(const struct firmware *fw, void *context)
 		set_error = -EINVAL;
 	}
 
-	rtnl_lock();
 	mutex_lock(&cfg80211_mutex);
 	regdb = rcu_dereference_protected(global_regdb,
-					  lockdep_rtnl_is_held() ||
 					  lockdep_is_held(&cfg80211_mutex));
 	if (regdb && !IS_ERR(regdb)) {
 		/* negative case - a bug
@@ -1044,7 +1034,6 @@ static void regdb_fw_cb(const struct firmware *fw, void *context)
 		restore_regulatory_settings(true, false);
 
 	mutex_unlock(&cfg80211_mutex);
-	rtnl_unlock();
 
 	kfree(context);
 
@@ -1098,10 +1087,8 @@ int reg_reload_regdb(void)
 		goto out;
 	}
 
-	rtnl_lock();
 	mutex_lock(&cfg80211_mutex);
 	old = rcu_replace_pointer(global_regdb, db,
-				  lockdep_rtnl_is_held() ||
 				  lockdep_is_held(&cfg80211_mutex));
 
 	/* reset regulatory domain */
@@ -1123,7 +1110,6 @@ int reg_reload_regdb(void)
 
 out_unlock:
 	mutex_unlock(&cfg80211_mutex);
-	rtnl_unlock();
 
 	if (!IS_ERR_OR_NULL(old)) {
 		synchronize_rcu();
@@ -2167,6 +2153,8 @@ static bool reg_is_world_roaming(struct wiphy *wiphy)
 static void reg_call_notifier(struct wiphy *wiphy,
 			      struct regulatory_request *request)
 {
+	lockdep_assert_wiphy(wiphy);
+
 	if (wiphy->reg_notifier)
 		wiphy->reg_notifier(wiphy, request);
 }
@@ -2227,10 +2215,10 @@ static void wiphy_update_new_beacon(struct wiphy *wiphy,
 
 	sband = wiphy->bands[reg_beacon->chan.band];
 
-	scoped_guard(wiphy, wiphy) {
-		for (i = 0; i < sband->n_channels; i++)
-			changed |= handle_reg_beacon(wiphy, i, reg_beacon);
-	}
+	guard(wiphy)(wiphy);
+
+	for (i = 0; i < sband->n_channels; i++)
+		changed |= handle_reg_beacon(wiphy, i, reg_beacon);
 
 	if (changed && wiphy->flags & WIPHY_FLAG_CHANNEL_CHANGE_ON_BEACON)
 		reg_call_notifier(wiphy, get_last_request());
@@ -2562,6 +2550,8 @@ static void wiphy_update_regulatory(struct wiphy *wiphy,
 	enum nl80211_band band;
 	struct regulatory_request *lr = get_last_request();
 
+	lockdep_assert_wiphy(wiphy);
+
 	if (ignore_reg_update(wiphy, initiator)) {
 		/*
 		 * Regulatory updates set by CORE are ignored for custom
@@ -2579,13 +2569,11 @@ static void wiphy_update_regulatory(struct wiphy *wiphy,
 	lr->dfs_region = get_cfg80211_regdom()->dfs_region;
 
 	/* the notifier is called below, so ignore beacon hint changes */
-	scoped_guard(wiphy, wiphy) {
-		for (band = 0; band < NUM_NL80211_BANDS; band++)
-			handle_band(wiphy, initiator, wiphy->bands[band]);
+	for (band = 0; band < NUM_NL80211_BANDS; band++)
+		handle_band(wiphy, initiator, wiphy->bands[band]);
 
-		reg_process_beacons(wiphy);
-		reg_process_ht_flags(wiphy);
-	}
+	reg_process_beacons(wiphy);
+	reg_process_ht_flags(wiphy);
 
 	reg_call_notifier(wiphy, lr);
 }
@@ -2593,12 +2581,14 @@ static void wiphy_update_regulatory(struct wiphy *wiphy,
 static void update_all_wiphy_regulatory(enum nl80211_reg_initiator initiator)
 {
 	struct cfg80211_registered_device *rdev;
-	struct wiphy *wiphy;
 
 	lockdep_assert_held(&cfg80211_mutex);
 
 	for_each_rdev(rdev) {
-		wiphy = &rdev->wiphy;
+		struct wiphy *wiphy = &rdev->wiphy;
+
+		guard(wiphy)(wiphy);
+
 		wiphy_update_regulatory(wiphy, initiator);
 	}
 
@@ -2712,13 +2702,11 @@ void wiphy_apply_custom_regulatory(struct wiphy *wiphy,
 	if (IS_ERR(new_regd))
 		return;
 
-	rtnl_lock();
 	scoped_guard(wiphy, wiphy) {
 		tmp = get_wiphy_regdom(wiphy);
 		rcu_assign_pointer(wiphy->regd, new_regd);
 		rcu_free_regdom(tmp);
 	}
-	rtnl_unlock();
 }
 EXPORT_SYMBOL(wiphy_apply_custom_regulatory);
 
@@ -3079,8 +3067,7 @@ static void wiphy_all_share_dfs_chan_state(struct wiphy *wiphy)
 	struct cfg80211_registered_device *rdev;
 
 	lockdep_assert_held(&cfg80211_mutex);
-
-	guard(wiphy)(wiphy);
+	lockdep_assert_wiphy(wiphy);
 
 	for_each_rdev(rdev) {
 		if (wiphy == &rdev->wiphy)
@@ -3132,6 +3119,8 @@ static void reg_process_hint(struct regulatory_request *reg_request)
 	 */
 	if (treatment == REG_REQ_ALREADY_SET && wiphy &&
 	    wiphy->regulatory_flags & REGULATORY_STRICT_REG) {
+		guard(wiphy)(wiphy);
+
 		wiphy_update_regulatory(wiphy, initiator);
 		wiphy_all_share_dfs_chan_state(wiphy);
 		reg_check_channels();
@@ -3146,13 +3135,16 @@ static void reg_process_hint(struct regulatory_request *reg_request)
 static void notify_self_managed_wiphys(struct regulatory_request *request)
 {
 	struct cfg80211_registered_device *rdev;
-	struct wiphy *wiphy;
 
 	for_each_rdev(rdev) {
-		wiphy = &rdev->wiphy;
+		struct wiphy *wiphy = &rdev->wiphy;
+
 		if (wiphy->regulatory_flags & REGULATORY_WIPHY_SELF_MANAGED &&
-		    request->initiator == NL80211_REGDOM_SET_BY_USER)
+		    request->initiator == NL80211_REGDOM_SET_BY_USER) {
+			guard(wiphy)(wiphy);
+
 			reg_call_notifier(wiphy, request);
+		}
 	}
 }
 
@@ -3231,7 +3223,6 @@ static void reg_process_self_managed_hint(struct wiphy *wiphy)
 	enum nl80211_band band;
 	struct regulatory_request request = {};
 
-	ASSERT_RTNL();
 	lockdep_assert_wiphy(wiphy);
 
 	spin_lock(&reg_requests_lock);
@@ -3279,13 +3270,11 @@ static void reg_process_self_managed_hints(void)
 
 static void reg_todo(struct work_struct *work)
 {
-	rtnl_lock();
-	mutex_lock(&cfg80211_mutex);
+	guard(mutex)(&cfg80211_mutex);
+
 	reg_process_pending_hints();
 	reg_process_pending_beacon_hints();
 	reg_process_self_managed_hints();
-	mutex_unlock(&cfg80211_mutex);
-	rtnl_unlock();
 }
 
 static void queue_regulatory_request(struct regulatory_request *request)
@@ -4155,7 +4144,7 @@ int regulatory_set_wiphy_regd_sync(struct wiphy *wiphy,
 {
 	int ret;
 
-	ASSERT_RTNL();
+	lockdep_assert_wiphy(wiphy);
 
 	ret = __regulatory_set_wiphy_regd(wiphy, rd);
 	if (ret)
@@ -4174,25 +4163,28 @@ void wiphy_regulatory_register(struct wiphy *wiphy)
 
 	lockdep_assert_held(&cfg80211_mutex);
 
-	/* self-managed devices ignore beacon hints and country IE */
-	if (wiphy->regulatory_flags & REGULATORY_WIPHY_SELF_MANAGED) {
-		wiphy->regulatory_flags |= REGULATORY_DISABLE_BEACON_HINTS |
-					   REGULATORY_COUNTRY_IE_IGNORE;
+	scoped_guard(wiphy, wiphy) {
+		/* self-managed devices ignore beacon hints and country IE */
+		if (wiphy->regulatory_flags & REGULATORY_WIPHY_SELF_MANAGED) {
+			wiphy->regulatory_flags |= REGULATORY_DISABLE_BEACON_HINTS |
+						   REGULATORY_COUNTRY_IE_IGNORE;
 
-		/*
-		 * The last request may have been received before this
-		 * registration call. Call the driver notifier if
-		 * initiator is USER.
-		 */
-		if (lr->initiator == NL80211_REGDOM_SET_BY_USER)
-			reg_call_notifier(wiphy, lr);
+			/*
+			 * The last request may have been received before this
+			 * registration call. Call the driver notifier if
+			 * initiator is USER.
+			 */
+			if (lr->initiator == NL80211_REGDOM_SET_BY_USER)
+				reg_call_notifier(wiphy, lr);
+		}
+
+		if (!reg_dev_ignore_cell_hint(wiphy))
+			reg_num_devs_support_basehint++;
+
+		wiphy_update_regulatory(wiphy, lr->initiator);
+		wiphy_all_share_dfs_chan_state(wiphy);
 	}
 
-	if (!reg_dev_ignore_cell_hint(wiphy))
-		reg_num_devs_support_basehint++;
-
-	wiphy_update_regulatory(wiphy, lr->initiator);
-	wiphy_all_share_dfs_chan_state(wiphy);
 	reg_process_self_managed_hints();
 }
 
@@ -4450,11 +4442,8 @@ void regulatory_exit(void)
 	cancel_delayed_work_sync(&reg_check_chans);
 
 	/* Lock to suppress warnings */
-	rtnl_lock();
-	mutex_lock(&cfg80211_mutex);
-	reset_regdomains(true, NULL);
-	mutex_unlock(&cfg80211_mutex);
-	rtnl_unlock();
+	scoped_guard(mutex, &cfg80211_mutex)
+		reset_regdomains(true, NULL);
 
 	dev_set_uevent_suppress(&reg_fdev->dev, true);
 
-- 
2.55.0

