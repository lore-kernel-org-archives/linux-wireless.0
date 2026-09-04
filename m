Received: from sipsolutions.net (s3.sipsolutions.net [168.119.38.16])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7576D4EE86A
	for <linux-wireless@vger.kernel.org>; Fri,  4 Sep 2026 15:02:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=168.119.38.16
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788534152; cv=none; b=VRiO3oIVUz0QCeTKW97kV2iQhC4L8wAMAU7zzbUqaCbbdGFNXT0ymeni0wyHe5py08uVgaPCSqGrAGfDoTUQ/PQ4s5/AqpDdlD46IbSw4uF/Y0AhOStMffeQiQP/gsySBbxKPzSFhyiHEbzUadG67pAuTAX5T/JJ7rhdbwUuy6Y=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788534152; c=relaxed/simple;
	bh=Up0U3WQJvGeB4pSC8wVCVxzjDzUqyrY4qfXpHOkddPI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=IhxgJwZbDpj4Yqw0N/yX4nqMyLN3Iw/IHy0F5AdWPc/LVnctwBEgCmMyja79intkM5wwyq++aW0kfQn5bdihrLG1kZwjfYjRISpFQ6yGdfBSrSpUiT//EPntmdG7d72xbiHjSzKXjiDk7cSzIYsQMR8JtJcTBIf4CPtH9XPGaGA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=permerror header.from=sipsolutions.net; spf=pass smtp.mailfrom=sipsolutions.net; dkim=pass (2048-bit key) header.d=sipsolutions.net header.i=@sipsolutions.net header.b=noMBJzuA; arc=none smtp.client-ip=168.119.38.16
Authentication-Results: smtp.subspace.kernel.org; dmarc=permerror header.from=sipsolutions.net
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=sipsolutions.net
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=sipsolutions.net header.i=@sipsolutions.net header.b="noMBJzuA"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=sipsolutions.net; s=mail; h=Content-Transfer-Encoding:MIME-Version:
	References:In-Reply-To:Message-ID:Date:Subject:Cc:To:From:Content-Type:Sender
	:Reply-To:Content-ID:Content-Description:Resent-Date:Resent-From:Resent-To:
	Resent-Cc:Resent-Message-ID; bh=594B2mk4pXGuBwOBHTEzwXPrBL9I97b+iXC+SspINt8=;
	t=1788534150; x=1789743750; b=noMBJzuA7fTmClXAdD8zlSzFrNIki3hgqQeqJO3kyMhGmmZ
	regSZj5y1vhiGD9VCkKxVHUgkUNmCbWA4NLnPfBDpaZqu6QZmBq9JcC1Yycag1QNuLuFLHdW/6odG
	u3kpHt196D4sEEiKQw5xdh7BPgJOW546zeX8iNQyAB5McUVKwjzTqXBuQrZSC+RlzGAS8i7FZor2X
	/ObakutypNmHAYoi6xmDpteFEh5lnn64NnCi1EYbjWRhRlx/4mhLUqduC/nYW7n35mmOsRlEnINeE
	T5kuyosItalLDJ/HikDdG+zMf24O3XhjKzyhpyI9NvoWf0DZxpLQNibQHzx+FN6Q==;
Received: by sipsolutions.net with esmtpsa (TLS1.3:ECDHE_X25519__ECDSA_SECP256R1_SHA256__AES_256_GCM:256)
	(Exim 4.98.2)
	(envelope-from <johannes@sipsolutions.net>)
	id 1x2VQw-00000001Sh8-40Dz;
	Fri, 04 Sep 2026 17:02:27 +0200
From: Johannes Berg <johannes@sipsolutions.net>
To: linux-wireless@vger.kernel.org
Cc: Johannes Berg <johannes.berg@intel.com>,
	syzbot+c5f8a81e794d4a4f2014@syzkaller.appspotmail.com
Subject: [PATCH wireless 4/4] wifi: cfg80211: get the wiphy out of a dying network namespace
Date: Fri,  4 Sep 2026 17:02:02 +0200
Message-ID: <20260904170220.7f3edc6d9992.I5e57921011244d3d8ef14d89e738aa19a5d972a0@changeid>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260904150220.427345-6-johannes@sipsolutions.net>
References: <20260904150220.427345-6-johannes@sipsolutions.net>
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Johannes Berg <johannes.berg@intel.com>

When a network namespace is destroyed, cfg80211_pernet_exit() moves any
wiphy back to the initial namespace, and just warns if that fails. But
moving an interface can fail (due to allocation failures), and then the
wiphy is left behind with a garbage netns pointer:

  Kernel mode fault at addr 0x30
  genlmsg_multicast_netns.constprop.0+0x46/0xcf [cfg80211]
  nl80211_notify_wiphy+0xcd/0xe8 [cfg80211]
  wiphy_unregister+0x169/0x3fc [cfg80211]

Note that commit debac3a20dec ("net: Remove conflicting altnames for
dying netns in __dev_change_net_namespace().") fixed another path
that could reach it without allocation failures.

Remove interfaces that cannot be moved instead of failing the switch,
so that the wiphy always ends up in the initial namespace. In this
case the netdev core will unregister the interfaces anyway.

Assisted-by: LLM
Reported-by: syzbot+c5f8a81e794d4a4f2014@syzkaller.appspotmail.com
Closes: https://syzkaller.appspot.com/bug?extid=c5f8a81e794d4a4f2014
Fixes: 463d018323851 ("cfg80211: make aware of net namespaces")
Signed-off-by: Johannes Berg <johannes.berg@intel.com>
---
 net/wireless/core.c | 37 +++++++++++++++++++++++++------------
 1 file changed, 25 insertions(+), 12 deletions(-)

diff --git a/net/wireless/core.c b/net/wireless/core.c
index 9ee1c36f1262..25dd1a4d6b4e 100644
--- a/net/wireless/core.c
+++ b/net/wireless/core.c
@@ -168,20 +168,24 @@ static int cfg80211_switch_wdev_netns(struct wireless_dev *wdev,
 	return err;
 }
 
-int cfg80211_switch_netns(struct cfg80211_registered_device *rdev,
-			  struct net *net)
+static int __cfg80211_switch_netns(struct cfg80211_registered_device *rdev,
+				   struct net *net, bool force)
 {
 	struct net *old_net = wiphy_net(&rdev->wiphy);
-	struct wireless_dev *wdev;
+	struct wireless_dev *wdev, *tmp;
 	int err = 0;
 
-	if (!(rdev->wiphy.flags & WIPHY_FLAG_NETNS_OK))
-		return -EOPNOTSUPP;
-
-	list_for_each_entry(wdev, &rdev->wiphy.wdev_list, list) {
+	list_for_each_entry_safe(wdev, tmp, &rdev->wiphy.wdev_list, list) {
 		err = cfg80211_switch_wdev_netns(wdev, net);
-		if (err)
+		if (!err)
+			continue;
+		if (!force)
 			goto undo;
+		/* remove interfaces that fail to allow wiphy switching */
+		dev_close(wdev->netdev);
+		scoped_guard(wiphy, &rdev->wiphy)
+			cfg80211_unregister_wdev(wdev);
+		err = 0;
 	}
 
 	scoped_guard(wiphy, &rdev->wiphy) {
@@ -199,7 +203,7 @@ int cfg80211_switch_netns(struct cfg80211_registered_device *rdev,
 		/* this only fails on allocation failure */
 		err = device_rename(&rdev->wiphy.dev,
 				    dev_name(&rdev->wiphy.dev));
-		if (err)
+		if (err && !force)
 			wiphy_net_set(&rdev->wiphy, old_net);
 
 		nl80211_notify_wiphy(rdev, NL80211_CMD_NEW_WIPHY);
@@ -212,8 +216,8 @@ int cfg80211_switch_netns(struct cfg80211_registered_device *rdev,
 		}
 	}
 
-	if (!err)
-		return 0;
+	if (!err || force)
+		return err;
 
 	/* set to the last one to undo all of them */
 	wdev = list_entry(&rdev->wiphy.wdev_list, typeof(*wdev), list);
@@ -229,6 +233,15 @@ int cfg80211_switch_netns(struct cfg80211_registered_device *rdev,
 	return err;
 }
 
+int cfg80211_switch_netns(struct cfg80211_registered_device *rdev,
+			  struct net *net)
+{
+	if (!(rdev->wiphy.flags & WIPHY_FLAG_NETNS_OK))
+		return -EOPNOTSUPP;
+
+	return __cfg80211_switch_netns(rdev, net, false);
+}
+
 static void cfg80211_rfkill_poll(struct rfkill *rfkill, void *data)
 {
 	struct cfg80211_registered_device *rdev = data;
@@ -1882,7 +1895,7 @@ static void __net_exit cfg80211_pernet_exit(struct net *net)
 	rtnl_lock();
 	for_each_rdev(rdev) {
 		if (net_eq(wiphy_net(&rdev->wiphy), net))
-			WARN_ON(cfg80211_switch_netns(rdev, &init_net));
+			WARN_ON(__cfg80211_switch_netns(rdev, &init_net, true));
 	}
 	rtnl_unlock();
 }
-- 
2.55.0

