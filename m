Received: from sipsolutions.net (s3.sipsolutions.net [168.119.38.16])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9AF2E431A44
	for <linux-wireless@vger.kernel.org>; Sun, 11 Oct 2026 09:33:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=168.119.38.16
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791711200; cv=none; b=e8qx8a7Bscbe30h2Qfmkc70RIV6/V1nMUaC/iJAY8MP2Ly/2G1ablmbkAo2dfeZNSuC6Xv49aBgcs+NkZ35xekinufcf7ajPO8YqITKMt5CpJpLVk4Du/3gt/QBlbOvdYTJI/R1h1w1rLWwjBzKcKJd/gi5VDOiz180VMBK9LB0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791711200; c=relaxed/simple;
	bh=xZisp2yLPjsQAwxX2Yq+P/XqXxlIBKC80ReUUfcNgaY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=gBiwknFZDEM2zqFK0zMm8boOcPJxI3i28PNLbo58YgHdDJoRqgi5XlVxQLBqc7RtgZ9LKwIrlYf4vX/RKkIR6c0zfLYtgTJnnNSZym/1Jjh2LVyvTAmz7K+DYmKDi7e/I4trJaRka4Lh5+iccAzxsjLKt9CoDyJAfDjuWI6TONU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=permerror header.from=sipsolutions.net; spf=pass smtp.mailfrom=sipsolutions.net; dkim=pass (2048-bit key) header.d=sipsolutions.net header.i=@sipsolutions.net header.b=JurxJ2Bm; arc=none smtp.client-ip=168.119.38.16
Authentication-Results: smtp.subspace.kernel.org; dmarc=permerror header.from=sipsolutions.net
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=sipsolutions.net
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=sipsolutions.net header.i=@sipsolutions.net header.b="JurxJ2Bm"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=sipsolutions.net; s=mail; h=Content-Transfer-Encoding:MIME-Version:
	References:In-Reply-To:Message-ID:Date:Subject:Cc:To:From:Content-Type:Sender
	:Reply-To:Content-ID:Content-Description:Resent-Date:Resent-From:Resent-To:
	Resent-Cc:Resent-Message-ID; bh=7k9+JJ/kWFK+mbZramzHFmuF9o8VewWhoLwvmdi6JEY=;
	t=1791711198; x=1792920798; b=JurxJ2BmNvgi1afKSCyQPyyjPfAO0aRoLopphCjd8cqY+RC
	F1fOhWmmO/w8KhpEBRd1Ta8vft2GHHebhwpQUGZPeF1li9vf0jXel5j+Qwos4PKio5oasWHIVKm5u
	zD2WqVDUBR8VYWo1SpHK2pFTfqKxO2Fn36lHpNLIIllmlt0aYEU0yTjFz3f1qZppBXim9DbsYUc+n
	RsOVw3c/FmgmLVUWr5ibDR+JWDA+JgrrKuko1fgkTPt7vBh5sA+FrFkLs0S53tDfI+OVQUNJw/Eu8
	BEBPhhm8lf8YfUzrGIWDaXENTypC+VNcrd0LAisttw8G+jItHMtS3sAaZn4Hek9w==;
Received: by sipsolutions.net with esmtpsa (TLS1.3:ECDHE_X25519__ECDSA_SECP256R1_SHA256__AES_256_GCM:256)
	(Exim 4.98.2)
	(envelope-from <johannes@sipsolutions.net>)
	id 1xFpvg-0000000Dk5j-00gP;
	Sun, 11 Oct 2026 11:33:16 +0200
From: Johannes Berg <johannes@sipsolutions.net>
To: linux-wireless@vger.kernel.org
Cc: Johannes Berg <johannes.berg@intel.com>
Subject: [PATCH wireless-next v2 06/10] wifi: cfg80211: protect wiphy names with cfg80211_mutex
Date: Sun, 11 Oct 2026 11:31:29 +0200
Message-ID: <20261011113308.6cedefb201f4.I03ffe79f337b61ea8f91b91532d3dfb9497e0438@changeid>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261011093308.49945-12-johannes@sipsolutions.net>
References: <20261011093308.49945-12-johannes@sipsolutions.net>
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Johannes Berg <johannes.berg@intel.com>

The RTNL is only used for wiphy names to serialize checking
for name collisions and setting the name, across all wiphys.
Since the wiphy list can be walked under the cfg80211_mutex,
use that instead.

In nl80211_set_wiphy() this requires taking it before the
wiphy mutex, and then the RTNL is no longer needed there at
all if the netdev is looked up under RCU. Since the netns of
the wiphy and its netdevs is now also stable under the
cfg80211_mutex, only the netdev unregistering needs to be
handled, by looking up the wdev again under the wiphy mutex.

Assisted-by: LLM
Signed-off-by: Johannes Berg <johannes.berg@intel.com>
---
 net/wireless/core.c    | 10 ++++-----
 net/wireless/nl80211.c | 47 ++++++++++++++++++++++++++++--------------
 2 files changed, 37 insertions(+), 20 deletions(-)

diff --git a/net/wireless/core.c b/net/wireless/core.c
index d648df6b8037..c9ad4f72e70d 100644
--- a/net/wireless/core.c
+++ b/net/wireless/core.c
@@ -94,7 +94,7 @@ static int cfg80211_dev_check_name(struct cfg80211_registered_device *rdev,
 	struct cfg80211_registered_device *rdev2;
 	int wiphy_idx, taken = -1, digits;
 
-	ASSERT_RTNL();
+	lockdep_assert_held(&cfg80211_mutex);
 
 	if (strlen(newname) > NL80211_WIPHY_NAME_MAXLEN)
 		return -EINVAL;
@@ -127,7 +127,7 @@ int cfg80211_dev_rename(struct cfg80211_registered_device *rdev,
 {
 	int result;
 
-	ASSERT_RTNL();
+	lockdep_assert_held(&cfg80211_mutex);
 	lockdep_assert_wiphy(&rdev->wiphy);
 
 	/* Ignore nop renames */
@@ -664,16 +664,16 @@ struct wiphy *wiphy_new_nm(const struct cfg80211_ops *ops, int sizeof_priv,
 	if (requested_name && requested_name[0]) {
 		int rv;
 
-		rtnl_lock();
+		mutex_lock(&cfg80211_mutex);
 		rv = cfg80211_dev_check_name(rdev, requested_name);
 
 		if (rv < 0) {
-			rtnl_unlock();
+			mutex_unlock(&cfg80211_mutex);
 			goto use_default_name;
 		}
 
 		rv = dev_set_name(&rdev->wiphy.dev, "%s", requested_name);
-		rtnl_unlock();
+		mutex_unlock(&cfg80211_mutex);
 		if (rv)
 			goto use_default_name;
 	} else {
diff --git a/net/wireless/nl80211.c b/net/wireless/nl80211.c
index bf64cafa02fc..48262db9d5e3 100644
--- a/net/wireless/nl80211.c
+++ b/net/wireless/nl80211.c
@@ -4299,17 +4299,18 @@ static int nl80211_set_wiphy(struct sk_buff *skb, struct genl_info *info)
 {
 	struct cfg80211_registered_device *rdev = NULL;
 	struct net_device *netdev = NULL;
-	struct wireless_dev *wdev;
+	struct wireless_dev *wdev = NULL;
 	int result = 0, rem_txq_params = 0;
 	struct nlattr *nl_txq_params;
-	u32 changed;
+	u32 changed, wdev_id = 0;
 	u8 retry_short = 0, retry_long = 0;
 	u32 frag_threshold = 0, rts_threshold = 0;
 	u8 coverage_class = 0;
 	u32 txq_limit = 0, txq_memory_limit = 0, txq_quantum = 0;
 	int radio_idx = -1;
 
-	rtnl_lock();
+	/* keeps the wiphy registered and its netns stable */
+	mutex_lock(&cfg80211_mutex);
 	/*
 	 * Try to find the wiphy and netdev. Normally this
 	 * function shouldn't need the netdev, but this is
@@ -4323,28 +4324,44 @@ static int nl80211_set_wiphy(struct sk_buff *skb, struct genl_info *info)
 	if (info->attrs[NL80211_ATTR_IFINDEX]) {
 		int ifindex = nla_get_u32(info->attrs[NL80211_ATTR_IFINDEX]);
 
-		netdev = __dev_get_by_index(genl_info_net(info), ifindex);
-		if (netdev && netdev->ieee80211_ptr)
+		rcu_read_lock();
+		netdev = dev_get_by_index_rcu(genl_info_net(info), ifindex);
+		if (netdev && netdev->ieee80211_ptr) {
 			rdev = wiphy_to_rdev(netdev->ieee80211_ptr->wiphy);
-		else
-			netdev = NULL;
+			wdev_id = netdev->ieee80211_ptr->identifier;
+		}
+		rcu_read_unlock();
 	}
 
-	if (!netdev) {
+	if (!rdev) {
+		/* RCU for the wdev list walk, cfg80211_mutex keeps rdev */
+		rcu_read_lock();
 		rdev = __cfg80211_rdev_from_attrs(genl_info_net(info),
 						  info->attrs);
+		rcu_read_unlock();
 		if (IS_ERR(rdev)) {
-			rtnl_unlock();
+			mutex_unlock(&cfg80211_mutex);
 			return PTR_ERR(rdev);
 		}
-		wdev = NULL;
-		netdev = NULL;
-		result = 0;
-	} else
-		wdev = netdev->ieee80211_ptr;
+	}
 
 	guard(wiphy)(&rdev->wiphy);
 
+	/* the netdev may have been unregistered after the lookup */
+	if (wdev_id) {
+		list_for_each_entry(wdev, &rdev->wiphy.wdev_list, list) {
+			if (wdev->identifier == wdev_id)
+				break;
+		}
+		if (list_entry_is_head(wdev, &rdev->wiphy.wdev_list, list)) {
+			mutex_unlock(&cfg80211_mutex);
+			return -ENODEV;
+		}
+		netdev = wdev->netdev;
+	} else {
+		netdev = NULL;
+	}
+
 	/*
 	 * end workaround code, by now the rdev is available
 	 * and locked, and wdev may or may not be NULL.
@@ -4353,7 +4370,7 @@ static int nl80211_set_wiphy(struct sk_buff *skb, struct genl_info *info)
 	if (info->attrs[NL80211_ATTR_WIPHY_NAME])
 		result = cfg80211_dev_rename(
 			rdev, nla_data(info->attrs[NL80211_ATTR_WIPHY_NAME]));
-	rtnl_unlock();
+	mutex_unlock(&cfg80211_mutex);
 
 	if (result)
 		return result;
-- 
2.56.0

