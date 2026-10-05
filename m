Received: from sipsolutions.net (s3.sipsolutions.net [168.119.38.16])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2AF444749CB
	for <linux-wireless@vger.kernel.org>; Mon,  5 Oct 2026 10:05:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=168.119.38.16
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791194742; cv=none; b=lbIBVzstfledsBtzW4QyvwsXubkN8nEhZwYErAhMmIAXnPNYb2GLTqYoCJZIWENZUcbnNqtklBORxS2RZeuCZechHYBfCFM7Yu1osOu+DX+u8TeVzpiGwqvPmycJM8WLTkvTuhKFWZJMhU/rP1R3nnQSOSoMM30kcLwfUPn/boQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791194742; c=relaxed/simple;
	bh=131l8xM1vGOGl0sAH5RY4+ox7rdood5Si7mIS9fLc8o=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=In+aEbH4kIw8rkUpRl9TeiJrpa6Ih35CDroUoYvJ6oRAZ0gOaw2N229Khko+FGO9NGarxtsaz3Y5SN0WC7/TWNNJcLylsVyo/cJdt3jZ7bUXBYnBVLeMdMebZIVE5VH1AI6j9WvYAV8TOHvewUtG90LDD9UeBdjg6Pv8LAoqEn8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=permerror header.from=sipsolutions.net; spf=pass smtp.mailfrom=sipsolutions.net; dkim=pass (2048-bit key) header.d=sipsolutions.net header.i=@sipsolutions.net header.b=aqa1bKtB; arc=none smtp.client-ip=168.119.38.16
Authentication-Results: smtp.subspace.kernel.org; dmarc=permerror header.from=sipsolutions.net
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=sipsolutions.net
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=sipsolutions.net header.i=@sipsolutions.net header.b="aqa1bKtB"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=sipsolutions.net; s=mail; h=Content-Transfer-Encoding:MIME-Version:
	References:In-Reply-To:Message-ID:Date:Subject:Cc:To:From:Content-Type:Sender
	:Reply-To:Content-ID:Content-Description:Resent-Date:Resent-From:Resent-To:
	Resent-Cc:Resent-Message-ID; bh=WVKZi5IH92243U+UCZkkd+RGNkr0/QFG5/udCLWQj+M=;
	t=1791194738; x=1792404338; b=aqa1bKtBm/0Lr8fzBayjaPelFkSs2xxOXJVBsFJInM32xL8
	240Tc4rqBy6PR0t7D+f9ybjuSNq7XkEZQco34atNenl9MLwQhx27THxBVm5DXDp5uDbRljyPpcdDm
	LmKMKGVDmPw8iS6M6BVpNiw2gtpD66JEZxeTm0S5DMfv7E9T9XGCWEv5r6rXFycl1iTLtt0iXcwtE
	QMy48HFVV2Nn/6AuzWYMlRcmR3UJG3iool2YqCKrEzO4WXEmud3IxaK+KG8oS3AAWOCsCMg/RSv9v
	1ERQRu7hfUwJsJyBX0hdVrs2fgGsWFlJ3nHWnfdaUvv16dquuipOEvKnGZbHu/zg==;
Received: by sipsolutions.net with esmtpsa (TLS1.3:ECDHE_X25519__ECDSA_SECP256R1_SHA256__AES_256_GCM:256)
	(Exim 4.98.2)
	(envelope-from <johannes@sipsolutions.net>)
	id 1xDfZe-00000005Bml-1vCO;
	Mon, 05 Oct 2026 12:05:34 +0200
From: Johannes Berg <johannes@sipsolutions.net>
To: linux-wireless@vger.kernel.org
Cc: Johannes Berg <johannes.berg@intel.com>
Subject: [PATCH wireless-next v2 04/18] wifi: nl80211: don't take rtnl for most dumps
Date: Mon,  5 Oct 2026 12:03:31 +0200
Message-ID: <20261005120526.3efdedc48477.Ica4719b0054c949abf2528d9c4c13a5d6b7a1a49@changeid>
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

Most (wdev-related) dumps also take RTNL just for lookup.
Apply the same logic as for pre_doit() in the previous
commit to avoid the RTNL. Since I refactored the checks
there into a helper to use here, it even simplifies the
code.

Signed-off-by: Johannes Berg <johannes.berg@intel.com>
---
 net/wireless/nl80211.c | 67 +++++++++++++++---------------------------
 1 file changed, 23 insertions(+), 44 deletions(-)

diff --git a/net/wireless/nl80211.c b/net/wireless/nl80211.c
index 97411d806383..00b027620f17 100644
--- a/net/wireless/nl80211.c
+++ b/net/wireless/nl80211.c
@@ -1302,6 +1302,8 @@ static int nl80211_prepare_wdev_dump(struct netlink_callback *cb,
 				     struct wireless_dev **wdev,
 				     struct nlattr **attrbuf)
 {
+	struct net *netns = sock_net(cb->skb->sk);
+	u32 wdev_id;
 	int err;
 
 	if (!cb->args[0]) {
@@ -1323,61 +1325,38 @@ static int nl80211_prepare_wdev_dump(struct netlink_callback *cb,
 			return err;
 		}
 
-		rtnl_lock();
-		*wdev = __cfg80211_wdev_from_attrs(NULL, sock_net(cb->skb->sk),
-						   attrbuf);
+		rcu_read_lock();
+		*wdev = __cfg80211_wdev_from_attrs(NULL, netns, attrbuf);
 		kfree(attrbuf_free);
 		if (IS_ERR(*wdev)) {
-			rtnl_unlock();
+			rcu_read_unlock();
 			return PTR_ERR(*wdev);
 		}
 		*rdev = wiphy_to_rdev((*wdev)->wiphy);
-		mutex_lock(&(*rdev)->wiphy.mtx);
-		rtnl_unlock();
-		/* 0 is the first index - add 1 to parse only once */
-		cb->args[0] = (*rdev)->wiphy_idx + 1;
-		cb->args[1] = (*wdev)->identifier;
+		wdev_id = (*wdev)->identifier;
 	} else {
 		/* subtract the 1 again here */
-		struct wiphy *wiphy;
-		struct wireless_dev *tmp;
-
-		rtnl_lock();
-		wiphy = wiphy_idx_to_wiphy(cb->args[0] - 1);
-		if (!wiphy) {
-			rtnl_unlock();
+		rcu_read_lock();
+		*rdev = cfg80211_rdev_by_wiphy_idx(cb->args[0] - 1);
+		if (!*rdev) {
+			rcu_read_unlock();
 			return -ENODEV;
 		}
-
-		/*
-		 * The first invocation validated the wdev's netns against
-		 * the caller via __cfg80211_wdev_from_attrs(). The wiphy
-		 * may have moved netns between dumpit invocations (via
-		 * NL80211_CMD_SET_WIPHY_NETNS), so re-check here.
-		 */
-		if (!net_eq(wiphy_net(wiphy), sock_net(cb->skb->sk))) {
-			rtnl_unlock();
-			return -ENODEV;
-		}
-
-		*rdev = wiphy_to_rdev(wiphy);
-		*wdev = NULL;
-
-		list_for_each_entry(tmp, &(*rdev)->wiphy.wdev_list, list) {
-			if (tmp->identifier == cb->args[1]) {
-				*wdev = tmp;
-				break;
-			}
-		}
-
-		if (!*wdev) {
-			rtnl_unlock();
-			return -ENODEV;
-		}
-		mutex_lock(&(*rdev)->wiphy.mtx);
-		rtnl_unlock();
+		wdev_id = cb->args[1];
 	}
 
+	get_device(&(*rdev)->wiphy.dev);
+	rcu_read_unlock();
+
+	/* things may have changed since the lookup or the last dumpit call */
+	*wdev = nl80211_lock_and_recheck(*rdev, netns, wdev_id);
+	if (IS_ERR(*wdev))
+		return PTR_ERR(*wdev);
+
+	/* 0 is the first index - add 1 to parse only once */
+	cb->args[0] = (*rdev)->wiphy_idx + 1;
+	cb->args[1] = wdev_id;
+
 	return 0;
 }
 
-- 
2.55.0

