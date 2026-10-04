Received: from sipsolutions.net (s3.sipsolutions.net [168.119.38.16])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0F10E48F84A
	for <linux-wireless@vger.kernel.org>; Sun,  4 Oct 2026 19:01:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=168.119.38.16
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791140502; cv=none; b=QYt+cRHKucr5O8sfgJI1J4wsdQ2YFAjUDUuE4mELxhOsudKZZ35Ljv94UGGoKo6A8QMnnhX0GSMHOr62CsF0lrnbRMQccIKpvCDHgMIbUiWh5U3PmyTCm6Ti9wjmTfhPwfV8mn1pI6BGC7NKlJBAJw2VzCkauAC40Be1roK9qNk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791140502; c=relaxed/simple;
	bh=zKhpK3nPqredb576qpHwCPVhjTU3ErAz0fz+ITsCGMI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=pV2ncBFozlvE02qOufk7+9SXFEd1246bmKAQU0/yubpSVYOzCRFWAHIwLCrJv8hAz/x6WyaQ9Lpd4C15a3r218MCrdIioJFC+2MPDhMr6trNEha/CP8u1UuZbtcZoUie0SmRa2wEQl20vQAp/2F8DcFVRjY8zZz+7u5CSOn5qz8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=permerror header.from=sipsolutions.net; spf=pass smtp.mailfrom=sipsolutions.net; dkim=pass (2048-bit key) header.d=sipsolutions.net header.i=@sipsolutions.net header.b=qIAgvcs1; arc=none smtp.client-ip=168.119.38.16
Authentication-Results: smtp.subspace.kernel.org; dmarc=permerror header.from=sipsolutions.net
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=sipsolutions.net
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=sipsolutions.net header.i=@sipsolutions.net header.b="qIAgvcs1"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=sipsolutions.net; s=mail; h=Content-Transfer-Encoding:MIME-Version:
	References:In-Reply-To:Message-ID:Date:Subject:Cc:To:From:Content-Type:Sender
	:Reply-To:Content-ID:Content-Description:Resent-Date:Resent-From:Resent-To:
	Resent-Cc:Resent-Message-ID; bh=SM0xOJR50EeLcB+gRp8v+nSHyZP1X7RL332XXVlJNEc=;
	t=1791140498; x=1792350098; b=qIAgvcs12hwUyfpL0En/dyaf1PPMhIXfxUtZhoTY/H2Ug33
	FSnBQkpw0YRx0zHYxEPy8Lv4DGGT6NSkE3omy7m72Hz3UhtLu7rJoHX/08k1YeXCFv1RS34btAJdo
	HvQx7swRvV0YVI+D3/4ye1mHKHgoluEMWQO+daF4O5BlYWHJoITqeFZsQUml5mR5okKkkzUa2glWw
	IzPPckW5XRysZeg4uI63ks9p59hbplwux47zz3FB1USvW092bopAIvFnCaprrxRFqIKuIvF/oKGuC
	NKfD2TyI0IJL3PEdL1EF4oUzUhBLS/vcWysd9odI7Q+pP9gr/BmqT+vsAlb+ibyA==;
Received: by sipsolutions.net with esmtpsa (TLS1.3:ECDHE_X25519__ECDSA_SECP256R1_SHA256__AES_256_GCM:256)
	(Exim 4.98.2)
	(envelope-from <johannes@sipsolutions.net>)
	id 1xDRSm-00000004Jlo-3CwI;
	Sun, 04 Oct 2026 21:01:33 +0200
From: Johannes Berg <johannes@sipsolutions.net>
To: linux-wireless@vger.kernel.org
Cc: Johannes Berg <johannes.berg@intel.com>
Subject: [PATCH wireless-next 11/18] wifi: cfg80211: allow walking wiphy list under cfg80211_mutex
Date: Sun,  4 Oct 2026 21:01:25 +0200
Message-ID: <20261004210122.3f25b8184938.I1a0c57a5d2238203b6252b189a7ca16d042888a7@changeid>
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

for_each_rdev() now requires RTNL, but we can relax that and
allow any of RTNL, cfg80211_mutex and RCU, and then use it
in quite a few more places.

Signed-off-by: Johannes Berg <johannes.berg@intel.com>
---
 net/wireless/core.c    | 16 +++++-----------
 net/wireless/core.h    | 11 +++--------
 net/wireless/nl80211.c | 11 +++++------
 net/wireless/reg.c     |  2 +-
 4 files changed, 14 insertions(+), 26 deletions(-)

diff --git a/net/wireless/core.c b/net/wireless/core.c
index e12d8b301a37..4e167c8c05b0 100644
--- a/net/wireless/core.c
+++ b/net/wireless/core.c
@@ -59,20 +59,16 @@ module_param(cfg80211_disable_40mhz_24ghz, bool, 0644);
 MODULE_PARM_DESC(cfg80211_disable_40mhz_24ghz,
 		 "Disable 40MHz support in the 2.4GHz band");
 
-/* requires RCU or rtnl */
 struct cfg80211_registered_device *cfg80211_rdev_by_wiphy_idx(int wiphy_idx)
 {
-	struct cfg80211_registered_device *result = NULL, *rdev;
+	struct cfg80211_registered_device *rdev;
 
-	list_for_each_entry_rcu(rdev, &cfg80211_rdev_list, list,
-				lockdep_rtnl_is_held()) {
-		if (rdev->wiphy_idx == wiphy_idx) {
-			result = rdev;
-			break;
-		}
+	for_each_rdev(rdev) {
+		if (rdev->wiphy_idx == wiphy_idx)
+			return rdev;
 	}
 
-	return result;
+	return NULL;
 }
 
 int get_wiphy_idx(struct wiphy *wiphy)
@@ -86,8 +82,6 @@ struct wiphy *wiphy_idx_to_wiphy(int wiphy_idx)
 {
 	struct cfg80211_registered_device *rdev;
 
-	ASSERT_RTNL();
-
 	rdev = cfg80211_rdev_by_wiphy_idx(wiphy_idx);
 	if (!rdev)
 		return NULL;
diff --git a/net/wireless/core.h b/net/wireless/core.h
index 414ce31af60c..dfcb9ed5035b 100644
--- a/net/wireless/core.h
+++ b/net/wireless/core.h
@@ -182,15 +182,10 @@ extern struct workqueue_struct *cfg80211_wq;
 extern struct list_head cfg80211_rdev_list;
 extern int cfg80211_rdev_list_generation;
 
-/* This is constructed like this so it can be used in if/else */
-static inline int for_each_rdev_check_rtnl(void)
-{
-	ASSERT_RTNL();
-	return 0;
-}
 #define for_each_rdev(rdev)						\
-	if (for_each_rdev_check_rtnl()) {} else				\
-		list_for_each_entry(rdev, &cfg80211_rdev_list, list)
+	list_for_each_entry_rcu(rdev, &cfg80211_rdev_list, list,	\
+				lockdep_rtnl_is_held() ||		\
+				lockdep_is_held(&cfg80211_mutex))
 
 enum bss_source_type {
 	BSS_SOURCE_DIRECT = 0,
diff --git a/net/wireless/nl80211.c b/net/wireless/nl80211.c
index d90d383deb27..8f206e44ba71 100644
--- a/net/wireless/nl80211.c
+++ b/net/wireless/nl80211.c
@@ -63,7 +63,7 @@ static const struct genl_multicast_group nl80211_mcgrps[] = {
 #endif
 };
 
-/* returns ERR_PTR values, requires RCU or rtnl if rdev is %NULL */
+/* returns ERR_PTR values, requires RCU/cfg80211_mutex/RTNL if rdev is %NULL */
 static struct wireless_dev *
 __cfg80211_wdev_from_attrs(struct cfg80211_registered_device *rdev,
 			   struct net *netns, struct nlattr **attrs)
@@ -105,8 +105,7 @@ __cfg80211_wdev_from_attrs(struct cfg80211_registered_device *rdev,
 		return result ?: ERR_PTR(-ENODEV);
 	}
 
-	list_for_each_entry_rcu(rdev, &cfg80211_rdev_list, list,
-				lockdep_rtnl_is_held()) {
+	for_each_rdev(rdev) {
 		struct wireless_dev *wdev;
 
 		if (wiphy_net(&rdev->wiphy) != netns)
@@ -137,7 +136,7 @@ __cfg80211_wdev_from_attrs(struct cfg80211_registered_device *rdev,
 	return ERR_PTR(-ENODEV);
 }
 
-/* requires RCU or rtnl */
+/* requires RCU/cfg80211_mutex/RTNL */
 static struct cfg80211_registered_device *
 __cfg80211_rdev_from_attrs(struct net *netns, struct nlattr **attrs)
 {
@@ -10939,7 +10938,7 @@ static int nl80211_get_reg_dump(struct sk_buff *skb,
 
 	/* the global regdom is idx 0 */
 	reg_idx = 1;
-	list_for_each_entry_rcu(rdev, &cfg80211_rdev_list, list) {
+	for_each_rdev(rdev) {
 		regdom = get_wiphy_regdom(&rdev->wiphy);
 		if (!regdom)
 			continue;
@@ -23406,7 +23405,7 @@ static int nl80211_netlink_notify(struct notifier_block * nb,
 
 	rcu_read_lock();
 
-	list_for_each_entry_rcu(rdev, &cfg80211_rdev_list, list) {
+	for_each_rdev(rdev) {
 		struct cfg80211_sched_scan_request *sched_scan_req;
 
 		list_for_each_entry_rcu(sched_scan_req,
diff --git a/net/wireless/reg.c b/net/wireless/reg.c
index 6a2bdb3d9d5e..7248e36714fe 100644
--- a/net/wireless/reg.c
+++ b/net/wireless/reg.c
@@ -2525,7 +2525,7 @@ static void reg_check_chans_work(struct work_struct *work)
 
 	rcu_read_lock();
 
-	list_for_each_entry_rcu(rdev, &cfg80211_rdev_list, list)
+	for_each_rdev(rdev)
 		wiphy_work_queue(&rdev->wiphy, &rdev->reg_check_chans_wk);
 
 	rcu_read_unlock();
-- 
2.55.0

