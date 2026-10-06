Received: from sipsolutions.net (s3.sipsolutions.net [168.119.38.16])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3FD553D953B
	for <linux-wireless@vger.kernel.org>; Tue,  6 Oct 2026 10:07:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=168.119.38.16
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791281230; cv=none; b=eOTl5QXUyjlmpW2U/i8djRQrzKufPgcWIGb6XigN2N2qDaacsq4WnQGenslS7+FJnzsCb/Ytff5zOpUJfQ2HKvQd/tf77P3S8pccqJKAHWDS/SUnZ8v1VP+hqnlJ8BzsjnVXJjB3qCEb1a6GS69PFskyju7YYzvlLbEMt1EBSR8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791281230; c=relaxed/simple;
	bh=wUjhA+pqr3evuS0mWGnnatk9+h1P2ixfyluBq/YLw4Y=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=X+hRq/fz6XrM04A8Kutp1HW05J+IY3tRcTd8n1HW1Ji52NzcsN9SPYhbnPQWwJWjQ96UNCq3c1hfUTHE7LMyJ8UPoC9dJa/Y5xbWYI2aUlPkPseC9B4UJHPXfF5f50Y3Tw/BxzCbTP+LM975XZUXGd6z4FlHrsFHZEtsIiwRTi4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=permerror header.from=sipsolutions.net; spf=pass smtp.mailfrom=sipsolutions.net; dkim=pass (2048-bit key) header.d=sipsolutions.net header.i=@sipsolutions.net header.b=MBjxv+xd; arc=none smtp.client-ip=168.119.38.16
Authentication-Results: smtp.subspace.kernel.org; dmarc=permerror header.from=sipsolutions.net
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=sipsolutions.net
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=sipsolutions.net header.i=@sipsolutions.net header.b="MBjxv+xd"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=sipsolutions.net; s=mail; h=Content-Transfer-Encoding:MIME-Version:
	References:In-Reply-To:Message-ID:Date:Subject:Cc:To:From:Content-Type:Sender
	:Reply-To:Content-ID:Content-Description:Resent-Date:Resent-From:Resent-To:
	Resent-Cc:Resent-Message-ID; bh=+NvKnPFuDUf5aoWLD1Ei1pfR6cXM/znyWSiBHT165Ho=;
	t=1791281229; x=1792490829; b=MBjxv+xd4ijCJRtpwcwkTWDXe9DTvYtO9bN+NdV4gUrAPes
	ESpr8rJUW9+FQB4cmbeyRYSG9qmLfEuIqrxFB4bX3FLDVfq2ijLhhHJzDiZlEbCv+Z5QhijukDl2c
	J2lea7POxAt+36rLs7efrLquiAYmXd0cpNpjHLHvBHPbxcCKXXlwnI1G5t4M2VlogVw0uIDrjmOmb
	V+MiSdykEywEwBGfF5z0V/zfZEjgKvSbZzQT08MyzPYSq22pr+M90i2szs43Faqu6nV9SCPKAhHAJ
	eNIGW6LGjhqbwuRuCBXRPCId86vBu4nFt9CkFwLxzIGMSqkh6sb2huVJkSuLwKLg==;
Received: by sipsolutions.net with esmtpsa (TLS1.3:ECDHE_X25519__ECDSA_SECP256R1_SHA256__AES_256_GCM:256)
	(Exim 4.98.2)
	(envelope-from <johannes@sipsolutions.net>)
	id 1xE24f-00000006XqW-2KNS;
	Tue, 06 Oct 2026 12:07:06 +0200
From: Johannes Berg <johannes@sipsolutions.net>
To: linux-wireless@vger.kernel.org
Cc: Johannes Berg <johannes.berg@intel.com>
Subject: [PATCH wireless-next v3 05/19] wifi: nl80211: don't take rtnl for most dumps
Date: Tue,  6 Oct 2026 12:04:03 +0200
Message-ID: <20261006120655.37954ad94c77.Ica4719b0054c949abf2528d9c4c13a5d6b7a1a49@changeid>
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
index 9958098af14f..a3c8252420e7 100644
--- a/net/wireless/nl80211.c
+++ b/net/wireless/nl80211.c
@@ -1304,6 +1304,8 @@ static int nl80211_prepare_wdev_dump(struct netlink_callback *cb,
 				     struct wireless_dev **wdev,
 				     struct nlattr **attrbuf)
 {
+	struct net *netns = sock_net(cb->skb->sk);
+	u32 wdev_id;
 	int err;
 
 	if (!cb->args[0]) {
@@ -1325,61 +1327,38 @@ static int nl80211_prepare_wdev_dump(struct netlink_callback *cb,
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

