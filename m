Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=168.119.38.16
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793719767;
	b=uLcFlyihDfwn/PNYnfhtJ87furf8AuryFimOa5fMtW1nZ3VWZCJ/nHGUdBS5Iy6C8cX2
	 06GTRTaNmfjoRiCBHU74Fx+Uve0egyZaqMtn3i6b7d1y8rlafMZxKS/WWaJQADuGJBcdo
	 b9jdT817eveyS56KH3+e99r9WY1R/ZQhDnzJbEUeoTv05I7qhyQWpmhX4I/40X1b44ZKR
	 YZGQ8+viTOGsR5DVg6GO/3+4drzLMfEEvbeXV64SGjO+DSxL3fYSL1KBL4o8t1MpSUgX0
	 RnD8H77+xqgSaoXIrbr/SQGQwGYNAW/8MKiwaGafplgixNIi0NbeGIfs8s9lmFJdcOg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793719767;
	h=DKIM-Signature:Received:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:MIME-Version:Content-Transfer-Encoding;
	bh=GaSMP98+50pJlKtmlfKHGcyaG4Gy5JTOYvSxNo4hAvQ=;
	b=XaPOXm6yPSUT32bVrB7L9B4GM0o1YhZ2+5bloUnU+h9hTHVAiJt+Su28IYGv31hosJn0
	 dWOhDihFZ4VfaPKZZV3MR3NmeurZB+QKcqZTBE8fefBHooelXxKCrC90pO4DjAvPxeLvv
	 MJ2HqCcgILT+bX6ghTqsZ7C32cuQeigsrZFZrTJtzTM7kZ49l08E4+RzPoSxHRkn7KUcb
	 k1BJSAT54dtu1Q5gnnhQLr84m4JcqGi8xKjkNOhiALBey0P9ycj6b8INpzBR4z/bD4n9i
	 Ii3+JSC+vIh8nm8PiQN9GcX8V//zy287lmyrJXxScLD8YU3giC0G3YCShoe4Xb+NNXQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=permerror header.from=sipsolutions.net;
	spf=pass smtp.mailfrom=sipsolutions.net;
	dkim=pass header.d=sipsolutions.net header.i=@sipsolutions.net header.a=rsa-sha256 header.s=mail header.b=Gdf7jaf7;
	arc=none smtp.remote-ip=168.119.38.16
Received: from sipsolutions.net (s3.sipsolutions.net [168.119.38.16])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange ECDHE (prime256v1) server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B7589606A327
	for <linux-wireless@vger.kernel.org>; Tue,  3 Nov 2026 15:29:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=permerror header.from=sipsolutions.net
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=sipsolutions.net
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=sipsolutions.net header.i=@sipsolutions.net header.a=rsa-sha256 header.s=mail header.b=Gdf7jaf7
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=sipsolutions.net; s=mail; h=Content-Transfer-Encoding:MIME-Version:
	References:In-Reply-To:Message-ID:Date:Subject:Cc:To:From:Content-Type:Sender
	:Reply-To:Content-ID:Content-Description:Resent-Date:Resent-From:Resent-To:
	Resent-Cc:Resent-Message-ID; bh=GaSMP98+50pJlKtmlfKHGcyaG4Gy5JTOYvSxNo4hAvQ=;
	t=1793719766; x=1794929366; b=Gdf7jaf7e3/mL+gKWBhhDt12bL2DWOBl1kemrer1rWLc8zC
	j3gJJxw8YSx6LucZoZLN5+gd04x1EESIYoa5z+hNv7m7V9WQVGIOqoygAIddze7gHEWFno1KdS3A2
	ojzx0ly09nIx0ca0gsTiGB97pEKi/R5q84v+OLdh5OCkd4d+4pWNAiKiaBwSht4MoMTG7ANG9YYd9
	BFnbMDBhvDE4jwFuYwbucQIRs2ld32th08167UCzNiOgtuNSRN4r2yKJCYM6xY2MlvOvnx6ySB5mQ
	WJM72wQbu9MU2dPNj+n7yQ1D6SrBhyMxDD5hdi8WfAt3p4JBZMiYYSVPlEljksGg==;
Received: by sipsolutions.net with esmtpsa (TLS1.3:ECDHE_X25519__ECDSA_SECP256R1_SHA256__AES_256_GCM:256)
	(Exim 4.98.2)
	(envelope-from <johannes@sipsolutions.net>)
	id 1xOGRw-00000003eXZ-1Oz8;
	Tue, 03 Nov 2026 16:29:24 +0100
From: Johannes Berg <johannes@sipsolutions.net>
To: linux-wireless@vger.kernel.org
Cc: Johannes Berg <johannes.berg@intel.com>
Subject: [PATCH wireless-next 1/4] wifi: cfg80211: enable context analysis
Date: Tue,  3 Nov 2026 16:29:13 +0100
Message-ID: <20261103162920.d2b6b5aaf0ce.I9145b1503b1880d602ab98e93061e39e4dddf257@changeid>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261103152920.294873-6-johannes@sipsolutions.net>
References: <20261103152920.294873-6-johannes@sipsolutions.net>
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Post: <mailto:linux-wireless@vger.kernel.org>
List-Help: <mailto:linux-wireless+help@vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-wireless+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Johannes Berg <johannes.berg@intel.com>

Since sparse no longer does any sort of context analysis,
enable clang's. This is reasonably simple, mostly needs
to drop drop __acquire() annotations, and add a few that
clang can't see.

Signed-off-by: Johannes Berg <johannes.berg@intel.com>
---
 net/wireless/Makefile  |   2 +
 net/wireless/nl80211.c | 119 ++++++++++++++++++++++-------------------
 2 files changed, 67 insertions(+), 54 deletions(-)

diff --git a/net/wireless/Makefile b/net/wireless/Makefile
index a77fd5ba6368..411f5c255bed 100644
--- a/net/wireless/Makefile
+++ b/net/wireless/Makefile
@@ -2,6 +2,8 @@
 obj-$(CONFIG_CFG80211) += cfg80211.o
 obj-y += tests/
 
+CONTEXT_ANALYSIS := y
+
 obj-$(CONFIG_WEXT_CORE) += wext-core.o
 obj-$(CONFIG_WEXT_PROC) += wext-proc.o
 obj-$(CONFIG_WEXT_PRIV) += wext-priv.o
diff --git a/net/wireless/nl80211.c b/net/wireless/nl80211.c
index 2fc680382418..d8568b95bf43 100644
--- a/net/wireless/nl80211.c
+++ b/net/wireless/nl80211.c
@@ -230,11 +230,12 @@ cfg80211_get_dev_from_info(struct net *netns, struct genl_info *info)
  *
  * Returns with wiphy mutex held unless there was an error.
  */
-static struct wireless_dev *
-nl80211_lock_and_recheck(struct cfg80211_registered_device *rdev,
-			 struct net *netns, u32 wdev_id)
+static int nl80211_lock_and_recheck(struct cfg80211_registered_device *rdev,
+				    struct net *netns, u32 wdev_id,
+				    struct wireless_dev **wdev)
+	__cond_acquires(0, &rdev->wiphy.mtx)
 {
-	struct wireless_dev *wdev;
+	struct wireless_dev *tmp;
 
 	wiphy_lock(&rdev->wiphy);
 
@@ -242,7 +243,7 @@ nl80211_lock_and_recheck(struct cfg80211_registered_device *rdev,
 	    !net_eq(wiphy_net(&rdev->wiphy), netns)) {
 		wiphy_unlock(&rdev->wiphy);
 		put_device(&rdev->wiphy.dev);
-		return ERR_PTR(-ENODEV);
+		return -ENODEV;
 	}
 
 	/*
@@ -251,19 +252,22 @@ nl80211_lock_and_recheck(struct cfg80211_registered_device *rdev,
 	 */
 	put_device(&rdev->wiphy.dev);
 
-	if (!wdev_id)
-		return NULL;
+	if (!wdev_id) {
+		*wdev = NULL;
+		return 0;
+	}
 
-	list_for_each_entry(wdev, &rdev->wiphy.wdev_list, list) {
-		if (wdev->identifier != wdev_id)
+	list_for_each_entry(tmp, &rdev->wiphy.wdev_list, list) {
+		if (tmp->identifier != wdev_id)
 			continue;
-		if (wdev->netdev && !net_eq(dev_net(wdev->netdev), netns))
+		if (tmp->netdev && !net_eq(dev_net(tmp->netdev), netns))
 			break;
-		return wdev;
+		*wdev = tmp;
+		return 0;
 	}
 	wiphy_unlock(&rdev->wiphy);
 
-	return ERR_PTR(-ENODEV);
+	return -ENODEV;
 }
 
 /* like nl80211_lock_and_recheck() but under RCU, for wdev_hold() */
@@ -290,36 +294,51 @@ nl80211_wdev_by_id_rcu(struct cfg80211_registered_device *rdev,
 /*
  * Must have wdev_hold(), acquire the wiphy mutex. This has to
  * look up the wdev again (otherwise it could deadlock against
- * wdev removal), so it can return an error pointer.
+ * wdev removal), so it can return NULL.
  */
-static struct wireless_dev *
-__nl80211_lock_held_wdev(struct cfg80211_registered_device *rdev,
-			 struct net *netns, struct wireless_dev *wdev)
+static int __nl80211_lock_held_wdev(struct cfg80211_registered_device *rdev,
+				    struct net *netns,
+				    struct wireless_dev *wdev)
+	__cond_acquires(0, &rdev->wiphy.mtx)
 {
 	u32 wdev_id = wdev->identifier;
+	struct wireless_dev *tmp;
+	int err;
 
 	/* the wdev reference was keeping the wiphy alive */
 	get_device(&rdev->wiphy.dev);
 	wdev_put(wdev);
 
-	return nl80211_lock_and_recheck(rdev, netns, wdev_id);
+	err = nl80211_lock_and_recheck(rdev, netns, wdev_id, &tmp);
+	if (err)
+		return err;
+
+	if (WARN_ON(!tmp || tmp != wdev)) {
+		wiphy_unlock(&rdev->wiphy);
+		return -EINVAL;
+	}
+
+	return 0;
 }
 
-static struct wireless_dev *
-nl80211_lock_held_wdev(struct cfg80211_registered_device *rdev,
-		       struct genl_info *info, struct wireless_dev *wdev)
+static int nl80211_lock_held_wdev(struct cfg80211_registered_device *rdev,
+				  struct genl_info *info,
+				  struct wireless_dev *wdev)
+	__cond_acquires(0, &rdev->wiphy.mtx)
 {
+	int err;
+
 	info->user_ptr[1] = NULL;
-	wdev = __nl80211_lock_held_wdev(rdev, genl_info_net(info), wdev);
-	if (IS_ERR(wdev))
-		return wdev;
+	err = __nl80211_lock_held_wdev(rdev, genl_info_net(info), wdev);
+	if (err)
+		return err;
 
 	if (!wdev_running(wdev)) {
 		wiphy_unlock(&rdev->wiphy);
-		return ERR_PTR(-ENETDOWN);
+		return -ENETDOWN;
 	}
 
-	return wdev;
+	return 0;
 }
 
 static int validate_beacon_head(const struct nlattr *attr,
@@ -1358,6 +1377,7 @@ static int __nl80211_prepare_wdev_dump(struct netlink_callback *cb,
 				       struct cfg80211_registered_device **rdev,
 				       struct wireless_dev **wdev,
 				       struct nlattr **attrbuf, bool lock)
+	__cond_acquires(0, &(*rdev)->wiphy.mtx)
 {
 	struct net *netns = sock_net(cb->skb->sk);
 	u32 wdev_id;
@@ -1410,13 +1430,15 @@ static int __nl80211_prepare_wdev_dump(struct netlink_callback *cb,
 		if (!*wdev)
 			return -ENODEV;
 	} else {
+		int ret;
+
 		get_device(&(*rdev)->wiphy.dev);
 		rcu_read_unlock();
 
 		/* things may have changed since the lookup or last dumpit */
-		*wdev = nl80211_lock_and_recheck(*rdev, netns, wdev_id);
-		if (IS_ERR(*wdev))
-			return PTR_ERR(*wdev);
+		ret = nl80211_lock_and_recheck(*rdev, netns, wdev_id, wdev);
+		if (ret)
+			return ret;
 	}
 
 	/* 0 is the first index - add 1 to parse only once */
@@ -1430,6 +1452,7 @@ static int nl80211_prepare_wdev_dump(struct netlink_callback *cb,
 				     struct cfg80211_registered_device **rdev,
 				     struct wireless_dev **wdev,
 				     struct nlattr **attrbuf)
+	__cond_acquires(0, &(*rdev)->wiphy.mtx)
 {
 	return __nl80211_prepare_wdev_dump(cb, rdev, wdev, attrbuf, true);
 }
@@ -5381,6 +5404,8 @@ static int nl80211_new_interface(struct sk_buff *skb, struct genl_info *info)
 }
 
 static int nl80211_del_interface(struct sk_buff *skb, struct genl_info *info)
+	/* clang cannot see pre_doit acquiring it for us */
+	__must_hold(&((struct cfg80211_registered_device *)info->user_ptr[0])->wiphy.mtx)
 {
 	struct cfg80211_registered_device *rdev = info->user_ptr[0];
 	struct wireless_dev *wdev = info->user_ptr[1];
@@ -8958,6 +8983,7 @@ static int nl80211_fill_station_info(struct cfg80211_registered_device *rdev,
 
 static int nl80211_dump_station(struct sk_buff *skb,
 				struct netlink_callback *cb)
+	__context_unsafe("can't cope with the locked variable")
 {
 	struct cfg80211_registered_device *rdev;
 	struct wireless_dev *wdev;
@@ -9044,12 +9070,10 @@ static int nl80211_dump_station(struct sk_buff *skb,
 				memset(&ctx->sinfo, 0, sizeof(ctx->sinfo));
 
 				/* this fails if the wdev is being removed */
-				wdev = __nl80211_lock_held_wdev(rdev, netns,
-								wdev);
-				if (IS_ERR(wdev)) {
-					err = PTR_ERR(wdev);
+				err = __nl80211_lock_held_wdev(rdev, netns,
+							       wdev);
+				if (err)
 					goto out_err;
-				}
 
 				/* try again locked now */
 				locked = true;
@@ -9168,6 +9192,7 @@ static int nl80211_dump_station_done(struct netlink_callback *cb)
 }
 
 static int nl80211_get_station(struct sk_buff *skb, struct genl_info *info)
+	__context_unsafe("can't cope with the locked variable")
 {
 	struct cfg80211_registered_device *rdev = info->user_ptr[0];
 	struct wireless_dev *wdev = info->user_ptr[1];
@@ -9218,11 +9243,8 @@ static int nl80211_get_station(struct sk_buff *skb, struct genl_info *info)
 		/* the wdev pointer is only valid until unlocking after this */
 		info->user_ptr[1] = NULL;
 		/* can fail if the wdev is being removed */
-		wdev = __nl80211_lock_held_wdev(rdev, genl_info_net(info),
-						wdev);
-		if (IS_ERR(wdev)) {
-			err = PTR_ERR(wdev);
-		} else {
+		err = __nl80211_lock_held_wdev(rdev, genl_info_net(info), wdev);
+		if (!err) {
 			locked = true;
 			err = rdev_get_station(rdev, wdev, mac_addr, &sinfo);
 		}
@@ -10340,8 +10362,6 @@ static int nl80211_dump_mpath(struct sk_buff *skb,
 	err = nl80211_prepare_wdev_dump(cb, &rdev, &wdev, NULL);
 	if (err)
 		return err;
-	/* nl80211_prepare_wdev_dump acquired it in the successful case */
-	__acquire(&rdev->wiphy.mtx);
 
 	if (!rdev->ops->dump_mpath) {
 		err = -EOPNOTSUPP;
@@ -10540,8 +10560,6 @@ static int nl80211_dump_mpp(struct sk_buff *skb,
 	err = nl80211_prepare_wdev_dump(cb, &rdev, &wdev, NULL);
 	if (err)
 		return err;
-	/* nl80211_prepare_wdev_dump acquired it in the successful case */
-	__acquire(&rdev->wiphy.mtx);
 
 	if (!rdev->ops->dump_mpp) {
 		err = -EOPNOTSUPP;
@@ -13096,8 +13114,6 @@ static int nl80211_dump_scan(struct sk_buff *skb, struct netlink_callback *cb)
 		kfree(attrbuf);
 		return err;
 	}
-	/* nl80211_prepare_wdev_dump acquired it in the successful case */
-	__acquire(&rdev->wiphy.mtx);
 
 	dump_include_use_data =
 		attrbuf[NL80211_ATTR_BSS_DUMP_INCLUDE_USE_DATA];
@@ -13236,8 +13252,6 @@ static int nl80211_dump_survey(struct sk_buff *skb, struct netlink_callback *cb)
 		kfree(attrbuf);
 		return res;
 	}
-	/* nl80211_prepare_wdev_dump acquired it in the successful case */
-	__acquire(&rdev->wiphy.mtx);
 
 	/* prepare_wdev_dump parsed the attributes */
 	radio_stats = attrbuf[NL80211_ATTR_SURVEY_RADIO_STATS];
@@ -15440,10 +15454,8 @@ static int nl80211_tx_mgmt(struct sk_buff *skb, struct genl_info *info)
 	/* pre_doit didn't lock the wiphy mutex, try without */
 	err = cfg80211_mlme_mgmt_tx_unlocked(rdev, wdev, &params, cookie);
 	if (err == -EAGAIN) {
-		wdev = nl80211_lock_held_wdev(rdev, info, wdev);
-		if (IS_ERR(wdev)) {
-			err = PTR_ERR(wdev);
-		} else {
+		err = nl80211_lock_held_wdev(rdev, info, wdev);
+		if (!err) {
 			err = nl80211_tx_mgmt_locked(rdev, wdev, &params,
 						     cookie);
 			wiphy_unlock(&rdev->wiphy);
@@ -20137,6 +20149,7 @@ static bool nl80211_need_wdev_ref(u32 internal_flags)
 static int nl80211_pre_doit(const struct genl_split_ops *ops,
 			    struct sk_buff *skb,
 			    struct genl_info *info)
+	__context_unsafe("can't cope with the need_rtnl variable")
 {
 	struct cfg80211_registered_device *rdev = NULL;
 	struct net *netns = genl_info_net(info);
@@ -20206,11 +20219,9 @@ static int nl80211_pre_doit(const struct genl_split_ops *ops,
 			wiphy_lock(&rdev->wiphy);
 		} else {
 			/* without rtnl, things may have changed since lookup */
-			wdev = nl80211_lock_and_recheck(rdev, netns, wdev_id);
-			if (IS_ERR(wdev)) {
-				err = PTR_ERR(wdev);
+			err = nl80211_lock_and_recheck(rdev, netns, wdev_id, &wdev);
+			if (err)
 				goto out;
-			}
 		}
 		locked = true;
 	} else if (rdev && !need_rtnl) {
-- 
2.56.0

