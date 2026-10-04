Received: from sipsolutions.net (s3.sipsolutions.net [168.119.38.16])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1C7C14908B0
	for <linux-wireless@vger.kernel.org>; Sun,  4 Oct 2026 19:01:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=168.119.38.16
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791140496; cv=none; b=R9hPs02rtSgLpAs01J0JFiKBBfiELIP4mISzHlJBojm3lNviduxokuh6H4nnPfRIKPBvemPJjo0fwAbDH6sguz0RbMyqFbYLLnfqpIk8TaoNc2Ig+AF7MrAd2abCzWdUj2Cf3MFK8BKa9zehThddcgxcZzsuBqqy0Zv8qIDPybc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791140496; c=relaxed/simple;
	bh=Ggx7YCPV8DiBKUJQw/ld6e89HhPDQ/Esh93gyIlfgTc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=KvvueRzUMHH9BGwUr7W88N/WJOte2bNwbc8TNQywxHOP8FH4WltVv6JD5xCWIqhDu3Mygms+96RY70S3WtBKW3T6DgYihavGSsYUyzYDWXi9fFUYMqDaxBJPcfsbaYuRyHDUnH6fOY2bYYv0yYN+yaKjCqF0Wq8ZxsX3UGgNgfQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=permerror header.from=sipsolutions.net; spf=pass smtp.mailfrom=sipsolutions.net; dkim=pass (2048-bit key) header.d=sipsolutions.net header.i=@sipsolutions.net header.b=OwDF7Ec8; arc=none smtp.client-ip=168.119.38.16
Authentication-Results: smtp.subspace.kernel.org; dmarc=permerror header.from=sipsolutions.net
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=sipsolutions.net
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=sipsolutions.net header.i=@sipsolutions.net header.b="OwDF7Ec8"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=sipsolutions.net; s=mail; h=Content-Transfer-Encoding:MIME-Version:
	References:In-Reply-To:Message-ID:Date:Subject:Cc:To:From:Content-Type:Sender
	:Reply-To:Content-ID:Content-Description:Resent-Date:Resent-From:Resent-To:
	Resent-Cc:Resent-Message-ID; bh=+A9XeHp9X/IoG4iSejLfuSqCFefG/c0Q3yQV/5qQFWI=;
	t=1791140493; x=1792350093; b=OwDF7Ec8ROV+FhOfKMQamvhFSefG5Pk0aEFG4XueWcYhsev
	Q/vCMxcr9V3Dlh5zN7CIc6ARDpIWLPhoA/6VTM1hVb5IIOQsWkd+mi3pU7bL8TAVR+jl6vW59UpCX
	mVG7XKULZIr2KFAeLDgQIKX9t6w6c43/RNmSjxsxoKfwGbyOPUlRI7j0jNpTMyxCKPq0HI4a4taQv
	adHIrACzSwskZB8ptn2q8tBYKfmvDjNWhEw8a7RYWLwQgfBHaF7COuxD6/wwip0TqiBn8ltQe86+O
	s+g6nFW+GwkIM366lEPfB1hF3uW9xqmUbhs+8kJojBspLKJEctWDbAiMM+sDFPow==;
Received: by sipsolutions.net with esmtpsa (TLS1.3:ECDHE_X25519__ECDSA_SECP256R1_SHA256__AES_256_GCM:256)
	(Exim 4.98.2)
	(envelope-from <johannes@sipsolutions.net>)
	id 1xDRSh-00000004Jlo-1JE9;
	Sun, 04 Oct 2026 21:01:27 +0200
From: Johannes Berg <johannes@sipsolutions.net>
To: linux-wireless@vger.kernel.org
Cc: Johannes Berg <johannes.berg@intel.com>
Subject: [PATCH wireless-next 03/18] wifi: nl80211: avoid rtnl for commands that don't want it
Date: Sun,  4 Oct 2026 21:01:17 +0200
Message-ID: <20261004210122.3b67fb1a6a69.I9c4f85fb60160f377a24c1b8e5173966744e5f09@changeid>
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

We currently always take the RTNL for the lookup only
to drop it again if the command doesn't want it, but
now that we can do lookups with RCU, do that unless
the command still wants RTNL anyway.

This basically just means looking up under RCU, then
holding a reference briefly, and checking state (and
link IDs) under the wiphy mutex when it's acquired to
avoid races on unregistration etc.

Commands that don't want either mutex can only work
with netdevs since wdevs could go away, so warn on
others. None such can exist since there are no flags
for it, and I noted there it wouldn't be valid.

Signed-off-by: Johannes Berg <johannes.berg@intel.com>
---
 net/wireless/core.c    |   5 +-
 net/wireless/nl80211.c | 144 ++++++++++++++++++++++++++++++++++-------
 2 files changed, 123 insertions(+), 26 deletions(-)

diff --git a/net/wireless/core.c b/net/wireless/core.c
index a6bba5e83f0d..ed6b5d3c148e 100644
--- a/net/wireless/core.c
+++ b/net/wireless/core.c
@@ -1259,6 +1259,9 @@ int wiphy_register(struct wiphy *wiphy)
 	}
 
 	cfg80211_debugfs_rdev_add(rdev);
+
+	rdev->wiphy.registered = true;
+
 	nl80211_notify_wiphy(rdev, NL80211_CMD_NEW_WIPHY);
 	wiphy_unlock(&rdev->wiphy);
 
@@ -1305,8 +1308,6 @@ int wiphy_register(struct wiphy *wiphy)
 				break;
 		}
 	}
-
-	rdev->wiphy.registered = true;
 	rtnl_unlock();
 
 	res = rfkill_register(rdev->wiphy.rfkill);
diff --git a/net/wireless/nl80211.c b/net/wireless/nl80211.c
index ee4d0112d6b8..a40dcdf18cad 100644
--- a/net/wireless/nl80211.c
+++ b/net/wireless/nl80211.c
@@ -225,6 +225,46 @@ cfg80211_get_dev_from_info(struct net *netns, struct genl_info *info)
 	return __cfg80211_rdev_from_attrs(netns, info->attrs);
 }
 
+/*
+ * Lock the given wiphy, put the device and double-check it's
+ * still valid to use.
+ *
+ * Returns with wiphy mutex held unless there was an error.
+ */
+static struct wireless_dev *
+nl80211_lock_and_recheck(struct cfg80211_registered_device *rdev,
+			 struct net *netns, u32 wdev_id)
+{
+	struct wireless_dev *wdev;
+
+	wiphy_lock(&rdev->wiphy);
+
+	if (!rdev->wiphy.registered ||
+	    !net_eq(wiphy_net(&rdev->wiphy), netns) ||
+	    (wdev->netdev && !net_eq(dev_net(wdev->netdev), netns))) {
+		wiphy_unlock(&rdev->wiphy);
+		put_device(&rdev->wiphy.dev);
+		return ERR_PTR(-ENODEV);
+	}
+
+	/*
+	 * unregistration blocks on wiphy mutex,
+	 * so we don't need this now
+	 */
+	put_device(&rdev->wiphy.dev);
+
+	if (!wdev_id)
+		return NULL;
+
+	list_for_each_entry(wdev, &rdev->wiphy.wdev_list, list) {
+		if (wdev->identifier == wdev_id)
+			return wdev;
+	}
+	wiphy_unlock(&rdev->wiphy);
+
+	return ERR_PTR(-ENODEV);
+}
+
 static int validate_beacon_head(const struct nlattr *attr,
 				struct netlink_ext_ack *extack)
 {
@@ -19641,6 +19681,18 @@ nl80211_epcs_cfg(struct sk_buff *skb, struct genl_info *info)
 		 NL80211_FLAG_NO_WIPHY_MTX |		\
 		 NL80211_FLAG_NEED_RTNL)
 
+/*
+ * Note: a
+ *	SELECTOR(...,
+ *		 NL80211_FLAG_NO_WIPHY_MTX |
+ *		 NL80211_FLAG_NEED_WDEV)
+ * or
+ *	SELECTOR(..., NL80211_FLAG_NO_WIPHY_MTX)
+ *
+ * isn't valid - nothing would ensure the device stays around,
+ * need at least a netdev, the wiphy mutex, or RTNL.
+ */
+
 enum nl80211_internal_flags_selector {
 #define SELECTOR(_, name, value)	NL80211_IFL_SEL_##name,
 	INTERNAL_FLAG_SELECTORS(_)
@@ -19658,41 +19710,81 @@ static int nl80211_pre_doit(const struct genl_split_ops *ops,
 			    struct genl_info *info)
 {
 	struct cfg80211_registered_device *rdev = NULL;
+	struct net *netns = genl_info_net(info);
 	struct wireless_dev *wdev = NULL;
 	struct net_device *dev = NULL;
-	u32 internal_flags;
+	bool need_rtnl, locked = false;
+	u32 internal_flags, wdev_id = 0;
 	int err;
 
 	if (WARN_ON(ops->internal_flags >= ARRAY_SIZE(nl80211_internal_flags)))
 		return -EINVAL;
 
 	internal_flags = nl80211_internal_flags[ops->internal_flags];
+	need_rtnl = internal_flags & NL80211_FLAG_NEED_RTNL;
+
+	if (need_rtnl)
+		rtnl_lock();
+	else
+		rcu_read_lock();
 
-	rtnl_lock();
 	if (internal_flags & NL80211_FLAG_NEED_WIPHY) {
-		rdev = cfg80211_get_dev_from_info(genl_info_net(info), info);
+		rdev = cfg80211_get_dev_from_info(netns, info);
 		if (IS_ERR(rdev)) {
 			err = PTR_ERR(rdev);
-			goto out_unlock;
+			goto out_lookup;
 		}
-		info->user_ptr[0] = rdev;
 	} else if (internal_flags & NL80211_FLAG_NEED_NETDEV ||
 		   internal_flags & NL80211_FLAG_NEED_WDEV) {
-		wdev = __cfg80211_wdev_from_attrs(NULL, genl_info_net(info),
-						  info->attrs);
+		wdev = __cfg80211_wdev_from_attrs(NULL, netns, info->attrs);
 		if (IS_ERR(wdev)) {
 			err = PTR_ERR(wdev);
-			goto out_unlock;
+			goto out_lookup;
 		}
 
 		dev = wdev->netdev;
 		dev_hold(dev);
 		rdev = wiphy_to_rdev(wdev->wiphy);
+	}
 
+	if (!need_rtnl) {
+		if (rdev)
+			get_device(&rdev->wiphy.dev);
+		if (wdev)
+			wdev_id = wdev->identifier;
+		rcu_read_unlock();
+	}
+
+	if (rdev && !(internal_flags & NL80211_FLAG_NO_WIPHY_MTX)) {
+		if (need_rtnl) {
+			wiphy_lock(&rdev->wiphy);
+		} else {
+			/* without rtnl, things may have changed since lookup */
+			wdev = nl80211_lock_and_recheck(rdev, netns, wdev_id);
+			if (IS_ERR(wdev)) {
+				err = PTR_ERR(wdev);
+				goto out;
+			}
+		}
+		locked = true;
+	} else if (rdev && !need_rtnl) {
+		/*
+		 * Without any mutex need a netdev to keep it alive, see
+		 * also the note about selectors - the WARN can't happen
+		 * without wrong selectors and those don't exist.
+		 */
+		put_device(&rdev->wiphy.dev);
+		if (WARN_ON(!dev)) {
+			err = -EINVAL;
+			goto out;
+		}
+	}
+
+	if (wdev) {
 		if (internal_flags & NL80211_FLAG_NEED_NETDEV) {
 			if (!dev) {
 				err = -EINVAL;
-				goto out_unlock;
+				goto out;
 			}
 
 			info->user_ptr[1] = dev;
@@ -19703,10 +19795,8 @@ static int nl80211_pre_doit(const struct genl_split_ops *ops,
 		if (internal_flags & NL80211_FLAG_CHECK_NETDEV_UP &&
 		    !wdev_running(wdev)) {
 			err = -ENETDOWN;
-			goto out_unlock;
+			goto out;
 		}
-
-		info->user_ptr[0] = rdev;
 	}
 
 	if (internal_flags & NL80211_FLAG_MLO_VALID_LINK_ID) {
@@ -19714,7 +19804,7 @@ static int nl80211_pre_doit(const struct genl_split_ops *ops,
 
 		if (!wdev) {
 			err = -EINVAL;
-			goto out_unlock;
+			goto out;
 		}
 
 		/* MLO -> require valid link ID */
@@ -19722,13 +19812,13 @@ static int nl80211_pre_doit(const struct genl_split_ops *ops,
 		    (!link_id ||
 		     !(wdev->valid_links & BIT(nla_get_u8(link_id))))) {
 			err = -EINVAL;
-			goto out_unlock;
+			goto out;
 		}
 
 		/* non-MLO -> no link ID attribute accepted */
 		if (!wdev->valid_links && link_id) {
 			err = -EINVAL;
-			goto out_unlock;
+			goto out;
 		}
 	}
 
@@ -19736,22 +19826,28 @@ static int nl80211_pre_doit(const struct genl_split_ops *ops,
 		if (info->attrs[NL80211_ATTR_MLO_LINK_ID] ||
 		    (wdev && wdev->valid_links)) {
 			err = -EINVAL;
-			goto out_unlock;
+			goto out;
 		}
 	}
 
-	if (rdev && !(internal_flags & NL80211_FLAG_NO_WIPHY_MTX)) {
-		wiphy_lock(&rdev->wiphy);
-		/* we keep the mutex locked until post_doit */
+	info->user_ptr[0] = rdev;
+	/* we keep the mutex locked until post_doit */
+	if (locked)
 		__release(&rdev->wiphy.mtx);
-	}
-	if (!(internal_flags & NL80211_FLAG_NEED_RTNL))
-		rtnl_unlock();
 
 	return 0;
-out_unlock:
-	rtnl_unlock();
+out:
+	if (locked)
+		wiphy_unlock(&rdev->wiphy);
 	dev_put(dev);
+	if (need_rtnl)
+		rtnl_unlock();
+	return err;
+out_lookup:
+	if (need_rtnl)
+		rtnl_unlock();
+	else
+		rcu_read_unlock();
 	return err;
 }
 
-- 
2.55.0

