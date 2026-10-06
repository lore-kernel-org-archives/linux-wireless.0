Received: from sipsolutions.net (s3.sipsolutions.net [168.119.38.16])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6A96D3D891C
	for <linux-wireless@vger.kernel.org>; Tue,  6 Oct 2026 10:07:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=168.119.38.16
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791281229; cv=none; b=AclPLQDf9iR5Ul4VouAK3Ue91USjvTWmy1kdE/hROp8ZBpGx9qxy2dzGu7gsb1WvXSCHpoYjPdhjBNGF/drATrWNyO/fmauxhtmz31K6bwysYKMDcssB9VxYC+EGjc2GfJR6qv1uk3xsvy9sMVvsLYRk873YfoLqG45wT0a1zEY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791281229; c=relaxed/simple;
	bh=kiCVAbTN1Hn3BUqe3KlpSH0LA472748CZNyK0/XW/WY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=HN3j0PRoI1Tz1XuAfEALfpmi/+ToW+1SpGLN/ImphT0wb+jM9nh3aW9Qyd3+zkN4k52ErcZ+FUbIppQ6JBvjnvQR3hZ7Rn8yIicqejTrt14K6jCs+4ICS/W1e2s0sD63NpFRRkxSb2atep0PILeCdqOLHAs5PCRSRBg/RkvzXqw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=permerror header.from=sipsolutions.net; spf=pass smtp.mailfrom=sipsolutions.net; dkim=pass (2048-bit key) header.d=sipsolutions.net header.i=@sipsolutions.net header.b=PQLts5Qr; arc=none smtp.client-ip=168.119.38.16
Authentication-Results: smtp.subspace.kernel.org; dmarc=permerror header.from=sipsolutions.net
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=sipsolutions.net
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=sipsolutions.net header.i=@sipsolutions.net header.b="PQLts5Qr"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=sipsolutions.net; s=mail; h=Content-Transfer-Encoding:MIME-Version:
	References:In-Reply-To:Message-ID:Date:Subject:Cc:To:From:Content-Type:Sender
	:Reply-To:Content-ID:Content-Description:Resent-Date:Resent-From:Resent-To:
	Resent-Cc:Resent-Message-ID; bh=OMo8sclXMdA5zUuYP7gWyAOTokgbjNJKrwUxXcMY6iI=;
	t=1791281227; x=1792490827; b=PQLts5QrJ8lDgu0CIRbrfPM0SmFJOIJBlPS3g5wf8Wr8YmC
	uyGw5Ew2pNkNM2rtn4x/65F0tOxeWGMdel44mQYocft/hqhvuEmFUssdaHrVJnpwoDCStmtq5P5oO
	qoz1FCL9icQfwnSiZSG8hdbzUC4fc+QmnGYYzy37V9CN3qFUMkFZhc0tbQMcySlrLSGRqX4Tic5dO
	w4OOflnQcB2a9ampGEsqz1AdikKFg6tuGQS8Qkh1v9LFF42P3+H8gor6kKjTl2D4TuK98czPiHsiF
	Pz69jm60lZJngFitfg8FPdIkCBbaJTMFJ5UoIZpBItaOuNv1kVzd0nmNbf1RjPyA==;
Received: by sipsolutions.net with esmtpsa (TLS1.3:ECDHE_X25519__ECDSA_SECP256R1_SHA256__AES_256_GCM:256)
	(Exim 4.98.2)
	(envelope-from <johannes@sipsolutions.net>)
	id 1xE24f-00000006XqW-002s;
	Tue, 06 Oct 2026 12:07:05 +0200
From: Johannes Berg <johannes@sipsolutions.net>
To: linux-wireless@vger.kernel.org
Cc: Johannes Berg <johannes.berg@intel.com>
Subject: [PATCH wireless-next v3 04/19] wifi: nl80211: avoid rtnl for commands that don't want it
Date: Tue,  6 Oct 2026 12:04:02 +0200
Message-ID: <20261006120655.ea80a5ecd9b8.I9c4f85fb60160f377a24c1b8e5173966744e5f09@changeid>
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
v2:
 - sync RTNL in !wdev_running()/netdev_running() corner case
 - fix wdev netns check
---
 net/wireless/core.c    |   5 +-
 net/wireless/nl80211.c | 153 ++++++++++++++++++++++++++++++++++-------
 2 files changed, 132 insertions(+), 26 deletions(-)

diff --git a/net/wireless/core.c b/net/wireless/core.c
index fb1e2070494f..270fb30e5265 100644
--- a/net/wireless/core.c
+++ b/net/wireless/core.c
@@ -1271,6 +1271,9 @@ int wiphy_register(struct wiphy *wiphy)
 	}
 
 	cfg80211_debugfs_rdev_add(rdev);
+
+	rdev->wiphy.registered = true;
+
 	nl80211_notify_wiphy(rdev, NL80211_CMD_NEW_WIPHY);
 	wiphy_unlock(&rdev->wiphy);
 
@@ -1317,8 +1320,6 @@ int wiphy_register(struct wiphy *wiphy)
 				break;
 		}
 	}
-
-	rdev->wiphy.registered = true;
 	rtnl_unlock();
 
 	res = rfkill_register(rdev->wiphy.rfkill);
diff --git a/net/wireless/nl80211.c b/net/wireless/nl80211.c
index 3f8576eaa47f..9958098af14f 100644
--- a/net/wireless/nl80211.c
+++ b/net/wireless/nl80211.c
@@ -225,6 +225,48 @@ cfg80211_get_dev_from_info(struct net *netns, struct genl_info *info)
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
+	    !net_eq(wiphy_net(&rdev->wiphy), netns)) {
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
+		if (wdev->identifier != wdev_id)
+			continue;
+		if (wdev->netdev && !net_eq(dev_net(wdev->netdev), netns))
+			break;
+		return wdev;
+	}
+	wiphy_unlock(&rdev->wiphy);
+
+	return ERR_PTR(-ENODEV);
+}
+
 static int validate_beacon_head(const struct nlattr *attr,
 				struct netlink_ext_ack *extack)
 {
@@ -19671,6 +19713,18 @@ nl80211_epcs_cfg(struct sk_buff *skb, struct genl_info *info)
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
@@ -19688,41 +19742,88 @@ static int nl80211_pre_doit(const struct genl_split_ops *ops,
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
+
+		/* RTM_NEWLINK is sent before NETDEV_UP, wait for dev_open() */
+		if (internal_flags & NL80211_FLAG_CHECK_NETDEV_UP && dev &&
+		    !READ_ONCE(wdev->is_running) && netif_running(dev)) {
+			rtnl_lock();
+			rtnl_unlock();
+		}
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
@@ -19733,10 +19834,8 @@ static int nl80211_pre_doit(const struct genl_split_ops *ops,
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
@@ -19744,7 +19843,7 @@ static int nl80211_pre_doit(const struct genl_split_ops *ops,
 
 		if (!wdev) {
 			err = -EINVAL;
-			goto out_unlock;
+			goto out;
 		}
 
 		/* MLO -> require valid link ID */
@@ -19752,13 +19851,13 @@ static int nl80211_pre_doit(const struct genl_split_ops *ops,
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
 
@@ -19766,22 +19865,28 @@ static int nl80211_pre_doit(const struct genl_split_ops *ops,
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

