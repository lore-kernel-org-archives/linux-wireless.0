Received: from sipsolutions.net (s3.sipsolutions.net [168.119.38.16])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DBD6046AA6B
	for <linux-wireless@vger.kernel.org>; Mon,  5 Oct 2026 10:05:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=168.119.38.16
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791194738; cv=none; b=iDMQ71cLc8wh0aAqB5Gp1t++0HdVOiKs0Ulm7J9D6vRgAu6Xc7mgG0wpgRBJNv+Xlc8UKO/lH9Pn05z1sEKPJZVED0tsIWn3OOldGiOMGS3GnAE29+UblNtn9Mp81YipMwwuT9j2OChtbnmEO+PlrOgs7zbSWUVTSN0ukfE6uCw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791194738; c=relaxed/simple;
	bh=oUAexl9i8mrklulXo6ovQyz6RUKmXQ+5ECgREdjHXr8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=gflLhm5E3Ytp2hOI6z0m3+nAEglil531PCz+80THHmuRROLfObORYfge+5MxQxl8uyukXutddvkAAyfGYyLePCnL89I9wS+Jcn2XVl0ThS+ZBukR0o9Wi31Us4wI9g0rYBaKB5zZXlFzFo2Y3YucwTuMjb3D8wGa3G8fw2xRkU4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=permerror header.from=sipsolutions.net; spf=pass smtp.mailfrom=sipsolutions.net; dkim=pass (2048-bit key) header.d=sipsolutions.net header.i=@sipsolutions.net header.b=lkGq4uLS; arc=none smtp.client-ip=168.119.38.16
Authentication-Results: smtp.subspace.kernel.org; dmarc=permerror header.from=sipsolutions.net
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=sipsolutions.net
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=sipsolutions.net header.i=@sipsolutions.net header.b="lkGq4uLS"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=sipsolutions.net; s=mail; h=Content-Transfer-Encoding:MIME-Version:
	References:In-Reply-To:Message-ID:Date:Subject:Cc:To:From:Content-Type:Sender
	:Reply-To:Content-ID:Content-Description:Resent-Date:Resent-From:Resent-To:
	Resent-Cc:Resent-Message-ID; bh=5YPc5ejYt5eEKsfdxaRVoDzlHIBDTHKOkGdsySK9+6o=;
	t=1791194735; x=1792404335; b=lkGq4uLS1GeSrrC7NAkmHT6goYYDibYn1RD+MDvGNnC0Mfh
	molpjJsLEYeWmC8T+xkpzcfBrUlYCjRqwhFt+sYWz7pPYuvj5bidu7Tuy+SMe4gfJkGN5Jth8RP9n
	oK5fe9DotNsleqhohQo5GrPZrZ5UylHJ+/vpfABKbTZTTMhhpVyUnMVpLqFx0RgjGfDzeVQnqtdyB
	wo6Ad93aCv+zKdOnOGK/O/W82gdg+K89MAv5qeXFaV6TOCLhZqWbQo+oL7Hkb2DO668sARz5Iq72w
	456epZnmfJGOUEHSikKA6PeQoOAhwPteJRjVyEfUB99tO0BDoAxkgD90zjNvayRQ==;
Received: by sipsolutions.net with esmtpsa (TLS1.3:ECDHE_X25519__ECDSA_SECP256R1_SHA256__AES_256_GCM:256)
	(Exim 4.98.2)
	(envelope-from <johannes@sipsolutions.net>)
	id 1xDfZc-00000005Bml-1t0Q;
	Mon, 05 Oct 2026 12:05:32 +0200
From: Johannes Berg <johannes@sipsolutions.net>
To: linux-wireless@vger.kernel.org
Cc: Johannes Berg <johannes.berg@intel.com>
Subject: [PATCH wireless-next v2 02/18] wifi: nl80211: allow device lookup under RCU
Date: Mon,  5 Oct 2026 12:03:29 +0200
Message-ID: <20261005120526.bad3c1e80ea5.I07b7ce5a69391d5168dc31c598b5079917a29bff@changeid>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20261005100525.1991059-20-johannes@sipsolutions.net>
References: <20261005100525.1991059-20-johannes@sipsolutions.net>
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Johannes Berg <johannes.berg@intel.com>

We already modify our wiphy/wdev lists in RCU-safe ways,
so we can do lookups in RCU critical sections. Prepare
more of the code to be able to do that.

Signed-off-by: Johannes Berg <johannes.berg@intel.com>
---
 net/wireless/core.c    |  6 +++---
 net/wireless/nl80211.c | 32 +++++++++++++++++---------------
 2 files changed, 20 insertions(+), 18 deletions(-)

diff --git a/net/wireless/core.c b/net/wireless/core.c
index 805b0958daa8..a6bba5e83f0d 100644
--- a/net/wireless/core.c
+++ b/net/wireless/core.c
@@ -57,13 +57,13 @@ module_param(cfg80211_disable_40mhz_24ghz, bool, 0644);
 MODULE_PARM_DESC(cfg80211_disable_40mhz_24ghz,
 		 "Disable 40MHz support in the 2.4GHz band");
 
+/* requires RCU or rtnl */
 struct cfg80211_registered_device *cfg80211_rdev_by_wiphy_idx(int wiphy_idx)
 {
 	struct cfg80211_registered_device *result = NULL, *rdev;
 
-	ASSERT_RTNL();
-
-	for_each_rdev(rdev) {
+	list_for_each_entry_rcu(rdev, &cfg80211_rdev_list, list,
+				lockdep_rtnl_is_held()) {
 		if (rdev->wiphy_idx == wiphy_idx) {
 			result = rdev;
 			break;
diff --git a/net/wireless/nl80211.c b/net/wireless/nl80211.c
index a182404557e0..ee4d0112d6b8 100644
--- a/net/wireless/nl80211.c
+++ b/net/wireless/nl80211.c
@@ -63,7 +63,7 @@ static const struct genl_multicast_group nl80211_mcgrps[] = {
 #endif
 };
 
-/* returns ERR_PTR values */
+/* returns ERR_PTR values, requires RCU or rtnl if rdev is %NULL */
 static struct wireless_dev *
 __cfg80211_wdev_from_attrs(struct cfg80211_registered_device *rdev,
 			   struct net *netns, struct nlattr **attrs)
@@ -105,9 +105,8 @@ __cfg80211_wdev_from_attrs(struct cfg80211_registered_device *rdev,
 		return result ?: ERR_PTR(-ENODEV);
 	}
 
-	ASSERT_RTNL();
-
-	for_each_rdev(rdev) {
+	list_for_each_entry_rcu(rdev, &cfg80211_rdev_list, list,
+				lockdep_rtnl_is_held()) {
 		struct wireless_dev *wdev;
 
 		if (wiphy_net(&rdev->wiphy) != netns)
@@ -116,7 +115,8 @@ __cfg80211_wdev_from_attrs(struct cfg80211_registered_device *rdev,
 		if (have_wdev_id && rdev->wiphy_idx != wiphy_idx)
 			continue;
 
-		list_for_each_entry(wdev, &rdev->wiphy.wdev_list, list) {
+		list_for_each_entry_rcu(wdev, &rdev->wiphy.wdev_list, list,
+					lockdep_rtnl_is_held()) {
 			if (have_ifidx && wdev->netdev &&
 			    wdev->netdev->ifindex == ifidx) {
 				result = wdev;
@@ -137,14 +137,13 @@ __cfg80211_wdev_from_attrs(struct cfg80211_registered_device *rdev,
 	return ERR_PTR(-ENODEV);
 }
 
+/* requires RCU or rtnl */
 static struct cfg80211_registered_device *
 __cfg80211_rdev_from_attrs(struct net *netns, struct nlattr **attrs)
 {
 	struct cfg80211_registered_device *rdev = NULL, *tmp;
 	struct net_device *netdev;
 
-	ASSERT_RTNL();
-
 	if (!attrs[NL80211_ATTR_WIPHY] &&
 	    !attrs[NL80211_ATTR_IFINDEX] &&
 	    !attrs[NL80211_ATTR_WDEV])
@@ -162,7 +161,8 @@ __cfg80211_rdev_from_attrs(struct net *netns, struct nlattr **attrs)
 		tmp = cfg80211_rdev_by_wiphy_idx(wdev_id >> 32);
 		if (tmp) {
 			/* make sure wdev exists */
-			list_for_each_entry(wdev, &tmp->wiphy.wdev_list, list) {
+			list_for_each_entry_rcu(wdev, &tmp->wiphy.wdev_list,
+						list, lockdep_rtnl_is_held()) {
 				if (wdev->identifier != (u32)wdev_id)
 					continue;
 				found = true;
@@ -181,14 +181,16 @@ __cfg80211_rdev_from_attrs(struct net *netns, struct nlattr **attrs)
 	if (attrs[NL80211_ATTR_IFINDEX]) {
 		int ifindex = nla_get_u32(attrs[NL80211_ATTR_IFINDEX]);
 
-		netdev = __dev_get_by_index(netns, ifindex);
-		if (netdev) {
-			if (netdev->ieee80211_ptr)
-				tmp = wiphy_to_rdev(
-					netdev->ieee80211_ptr->wiphy);
-			else
-				tmp = NULL;
+		/* RCU required for dev_get_by_index_rcu() if we have RTNL */
+		rcu_read_lock();
+		netdev = dev_get_by_index_rcu(netns, ifindex);
+		if (netdev && netdev->ieee80211_ptr)
+			tmp = wiphy_to_rdev(netdev->ieee80211_ptr->wiphy);
+		else
+			tmp = NULL;
+		rcu_read_unlock();
 
+		if (netdev) {
 			/* not wireless device -- return error */
 			if (!tmp)
 				return ERR_PTR(-EINVAL);
-- 
2.55.0

