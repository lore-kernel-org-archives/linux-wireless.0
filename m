Received: from sipsolutions.net (s3.sipsolutions.net [168.119.38.16])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C23A348F858
	for <linux-wireless@vger.kernel.org>; Sun,  4 Oct 2026 19:01:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=168.119.38.16
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791140507; cv=none; b=JRrb9ViIJS7TwdZ3PIbRICeFKBmupyZLkLVsZ9xg3kMz/5kvrECFWtaxvjurhrcHwyHbwij45bO4nEzVJ+BusG6zvfWs8bPyD/r1JoDBqeyfO/GEj3xxjcY6v2zzPWLcDzqmC3wLV7vjIiw56bacI1XumxqbTX80jW6ewX1HEqs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791140507; c=relaxed/simple;
	bh=ZImduSlsVVviiRj1SMWtPtbgpxzGgxPrIHEPKK4IuAU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=tsaXdZS/bryulq679kmiwQF5W+SErBNkmuC6m8RT13DkJhJz3FKnVAfSCUJk41+HYdqnLo3Wj6AGgnPcEHciNNlR/yzu9P8cIRyjSWJow6g3gg0JLN7KANTY9jvPzqAaa9g5Xm0K576jP4wbZnNFC/W/pkbMK9eJk8GQjskn6pE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=permerror header.from=sipsolutions.net; spf=pass smtp.mailfrom=sipsolutions.net; dkim=pass (2048-bit key) header.d=sipsolutions.net header.i=@sipsolutions.net header.b=ElsnH4ai; arc=none smtp.client-ip=168.119.38.16
Authentication-Results: smtp.subspace.kernel.org; dmarc=permerror header.from=sipsolutions.net
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=sipsolutions.net
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=sipsolutions.net header.i=@sipsolutions.net header.b="ElsnH4ai"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=sipsolutions.net; s=mail; h=Content-Transfer-Encoding:MIME-Version:
	References:In-Reply-To:Message-ID:Date:Subject:Cc:To:From:Content-Type:Sender
	:Reply-To:Content-ID:Content-Description:Resent-Date:Resent-From:Resent-To:
	Resent-Cc:Resent-Message-ID; bh=X7GDeB3OChzuFmjCuLVSZDsO0LU9Dx5DbPLzB32mqWM=;
	t=1791140504; x=1792350104; b=ElsnH4aiyuWnbsx4pBlsNnnG1Rx8IemCuEesdBgmneDkziN
	xoPZsPVjNSTmIWMSOI9HyopP4bK5ImBk6BhK04Kivinm8O4usAH+4rcPKy/qtpMiRDKSKYygb0Hhr
	z49qZKpntBp/1IM30Ng72QskOR0/rjyJjxHg0TBgyCihQ+9qjTm67zc195L1Ptl/8NGIXpDO4x/Ew
	Myt22M8yzaO+heo9bnbItHzzJe3LhYdnPXpKZmtOHi/Sm9NIymcJjOaeEKllMT+VCr0TPsfJlysd0
	L67FsL+RPZzOSmAVZseP49SJqGub7obeLtpy+W+jpnZRPdT58Fdex9cQrMAA990Q==;
Received: by sipsolutions.net with esmtpsa (TLS1.3:ECDHE_X25519__ECDSA_SECP256R1_SHA256__AES_256_GCM:256)
	(Exim 4.98.2)
	(envelope-from <johannes@sipsolutions.net>)
	id 1xDRSs-00000004Jlo-3xf6;
	Sun, 04 Oct 2026 21:01:39 +0200
From: Johannes Berg <johannes@sipsolutions.net>
To: linux-wireless@vger.kernel.org
Cc: Johannes Berg <johannes.berg@intel.com>
Subject: [PATCH wireless-next 18/18] wifi: cfg80211: regulatory: stop using RTNL
Date: Sun,  4 Oct 2026 21:01:32 +0200
Message-ID: <20261004210122.928ddb69421b.I637dbd328886b52bed511fb798172a2d57521263@changeid>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20261004190122.1559001-20-johannes@sipsolutions.net>
References: <20261004190122.1559001-20-johannes@sipsolutions.net>
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
 include/net/cfg80211.h |  6 +++---
 net/wireless/chan.c    |  2 +-
 net/wireless/core.c    | 12 ++----------
 net/wireless/mlme.c    |  3 ---
 net/wireless/nl80211.c | 11 ++++++-----
 net/wireless/reg.c     | 37 +++++++++----------------------------
 6 files changed, 21 insertions(+), 50 deletions(-)

diff --git a/include/net/cfg80211.h b/include/net/cfg80211.h
index ef54cc64ddf0..76edfe5765c8 100644
--- a/include/net/cfg80211.h
+++ b/include/net/cfg80211.h
@@ -8146,9 +8146,9 @@ int regulatory_set_wiphy_regd(struct wiphy *wiphy,
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
index 4e167c8c05b0..dcade9e8c27c 100644
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
index f96a0238f1ca..c75bcefec15f 100644
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
@@ -11041,7 +11041,6 @@ static int nl80211_set_reg(struct sk_buff *skb, struct genl_info *info)
 			return -EINVAL;
 	}
 
-	rtnl_lock();
 	mutex_lock(&cfg80211_mutex);
 	if (!reg_is_valid_request(alpha2)) {
 		r = -EINVAL;
@@ -11091,7 +11090,6 @@ static int nl80211_set_reg(struct sk_buff *skb, struct genl_info *info)
 	kfree(rd);
  out:
 	mutex_unlock(&cfg80211_mutex);
-	rtnl_unlock();
 	return r;
 }
 #endif /* CONFIG_CFG80211_CRDA_SUPPORT */
@@ -21164,7 +21162,10 @@ static bool nl80211_reg_change_event_fill(struct sk_buff *msg,
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
index 7248e36714fe..40d43fc6f4b2 100644
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
@@ -1010,7 +1003,6 @@ static void regdb_fw_cb(const struct firmware *fw, void *context)
 		set_error = -EINVAL;
 	}
 
-	rtnl_lock();
 	mutex_lock(&cfg80211_mutex);
 	if (regdb && !IS_ERR(regdb)) {
 		/* negative case - a bug
@@ -1035,7 +1027,6 @@ static void regdb_fw_cb(const struct firmware *fw, void *context)
 		restore_regulatory_settings(true, false);
 
 	mutex_unlock(&cfg80211_mutex);
-	rtnl_unlock();
 
 	kfree(context);
 
@@ -1089,7 +1080,6 @@ int reg_reload_regdb(void)
 		goto out;
 	}
 
-	rtnl_lock();
 	mutex_lock(&cfg80211_mutex);
 	if (!IS_ERR_OR_NULL(regdb))
 		kfree(regdb);
@@ -1114,7 +1104,6 @@ int reg_reload_regdb(void)
 
 out_unlock:
 	mutex_unlock(&cfg80211_mutex);
-	rtnl_unlock();
  out:
 	release_firmware(fw);
 	return err;
@@ -2698,13 +2687,11 @@ void wiphy_apply_custom_regulatory(struct wiphy *wiphy,
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
 
@@ -3217,7 +3204,6 @@ static void reg_process_self_managed_hint(struct wiphy *wiphy)
 	enum nl80211_band band;
 	struct regulatory_request request = {};
 
-	ASSERT_RTNL();
 	lockdep_assert_wiphy(wiphy);
 
 	spin_lock(&reg_requests_lock);
@@ -3265,13 +3251,11 @@ static void reg_process_self_managed_hints(void)
 
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
@@ -4141,7 +4125,7 @@ int regulatory_set_wiphy_regd_sync(struct wiphy *wiphy,
 {
 	int ret;
 
-	ASSERT_RTNL();
+	lockdep_assert_wiphy(wiphy);
 
 	ret = __regulatory_set_wiphy_regd(wiphy, rd);
 	if (ret)
@@ -4435,11 +4419,8 @@ void regulatory_exit(void)
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

