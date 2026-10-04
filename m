Received: from sipsolutions.net (s3.sipsolutions.net [168.119.38.16])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C248D48FF85
	for <linux-wireless@vger.kernel.org>; Sun,  4 Oct 2026 19:01:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=168.119.38.16
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791140501; cv=none; b=QlcTBGL7tT86zIUbK2Kp9tm/DKmR1t2TlykrTmrPxWhKKoCvUzMM4s6aJzGs/ET0SWijcjpCGFiDQbeSdLOD3yNMwI0AGnDFc1H5+V6M7XWjy86PisgJtdc6v3D6wV1KqW4J6bKsNg0t60xl1PK5jwy3NWInqOrQjXFCkRPvsms=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791140501; c=relaxed/simple;
	bh=N0hVPIzz6xrJzryXZ+pGUCooFVVuWiOCeCemUldJrWQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=EyPK7wdB7QpngTgvBiKnT/CMKYey8dURQZCES1PJTI5+PVdiL8y4eh+cTvFvOtmPVDCwPY2FRi+XCoc2+wfuqWqtrGUKsrbEN1F9+F8BQo7MNgNA1r/gvA+CpfW/GVsEYqFKkIASDCxFANUDIF67Yc3bt7SLRluWyYxa2OiXkYs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=permerror header.from=sipsolutions.net; spf=pass smtp.mailfrom=sipsolutions.net; dkim=pass (2048-bit key) header.d=sipsolutions.net header.i=@sipsolutions.net header.b=cfxsO1Cn; arc=none smtp.client-ip=168.119.38.16
Authentication-Results: smtp.subspace.kernel.org; dmarc=permerror header.from=sipsolutions.net
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=sipsolutions.net
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=sipsolutions.net header.i=@sipsolutions.net header.b="cfxsO1Cn"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=sipsolutions.net; s=mail; h=Content-Transfer-Encoding:MIME-Version:
	References:In-Reply-To:Message-ID:Date:Subject:Cc:To:From:Content-Type:Sender
	:Reply-To:Content-ID:Content-Description:Resent-Date:Resent-From:Resent-To:
	Resent-Cc:Resent-Message-ID; bh=tIwzAX2c+700jiBZzXEgfRdlM4nyyaD3QtQor1vYvLE=;
	t=1791140493; x=1792350093; b=cfxsO1CniGJnqgt6wfBgA2l7WOwY5pFs4VjAUUa2pP/b2xX
	ZjWhs51IoR4qRDrAftn9FaK9pC1+2T/QoNk1r+FFbyZGpqwQznplW5PuTvhrQJwjyLnF2IbRGUw0A
	LFmcrB9azK4KI/8Xr2T88fzVYyqCdabEhzQN/KvC7+xNDgjPmIEdca1BTdxhIx5Ap0xVfE9RF4p+t
	jZo+HAoa/G9P3pbxDNucVHPJwwEFcBEb7VU588NWlsiPRZ0GyE1wdYL1/Ida8u8OoQ8qiP1liiG83
	qHdF9wmP+DGVdnRXddLNBaFuX9xpz/598ovsGZ3bcxJ8t/NsCfOXNoG6mG8og6uA==;
Received: by sipsolutions.net with esmtpsa (TLS1.3:ECDHE_X25519__ECDSA_SECP256R1_SHA256__AES_256_GCM:256)
	(Exim 4.98.2)
	(envelope-from <johannes@sipsolutions.net>)
	id 1xDRSi-00000004Jlo-0a4K;
	Sun, 04 Oct 2026 21:01:28 +0200
From: Johannes Berg <johannes@sipsolutions.net>
To: linux-wireless@vger.kernel.org
Cc: Johannes Berg <johannes.berg@intel.com>
Subject: [PATCH wireless-next 04/18] wifi: nl80211: don't take rtnl for most dumps
Date: Sun,  4 Oct 2026 21:01:18 +0200
Message-ID: <20261004210122.889c44085a49.Ica4719b0054c949abf2528d9c4c13a5d6b7a1a49@changeid>
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
index a40dcdf18cad..d76b1fa54d64 100644
--- a/net/wireless/nl80211.c
+++ b/net/wireless/nl80211.c
@@ -1300,6 +1300,8 @@ static int nl80211_prepare_wdev_dump(struct netlink_callback *cb,
 				     struct wireless_dev **wdev,
 				     struct nlattr **attrbuf)
 {
+	struct net *netns = sock_net(cb->skb->sk);
+	u32 wdev_id;
 	int err;
 
 	if (!cb->args[0]) {
@@ -1321,61 +1323,38 @@ static int nl80211_prepare_wdev_dump(struct netlink_callback *cb,
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

