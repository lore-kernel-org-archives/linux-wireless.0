Received: from sipsolutions.net (s3.sipsolutions.net [168.119.38.16])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 72C074EE84E
	for <linux-wireless@vger.kernel.org>; Fri,  4 Sep 2026 15:02:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=168.119.38.16
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788534150; cv=none; b=dfBF0WqMZ8moojuKcu1oIwYHrTJ3zhYYpn40OgUtapbAJoQWaNjZXzrcfJRyoRdD0fMs5R4vxTqq3worYu80G77pgH9XFmCkmYJYAMq5X7ZXRsPa3Ay7LrkmeTLxML9c4fVcV1jxnhBfE6SmA1qqqd7s0qDqPcin3BEo6Z1HyCY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788534150; c=relaxed/simple;
	bh=iRkZ0BVMZyUgfU7eb+Nco73EiwuvOg0/1XZoJXKSOH0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=VJyyaGSzXm8ixUVyUmJ7/UExVTSwzFNbIMDuF0fo+qs59omlVXrFhAoxlmpSW7kP5ffE62LTlf8USubcxKgpi1rm+xTad32Zux5hWRMzrexROPNaMk8Zxuq/kI3rS1B7kfw6b97YYiyaUL68PrsomSQwrPDSeQlrXJWoBlVUgJA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=permerror header.from=sipsolutions.net; spf=pass smtp.mailfrom=sipsolutions.net; dkim=pass (2048-bit key) header.d=sipsolutions.net header.i=@sipsolutions.net header.b=X92eHdlA; arc=none smtp.client-ip=168.119.38.16
Authentication-Results: smtp.subspace.kernel.org; dmarc=permerror header.from=sipsolutions.net
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=sipsolutions.net
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=sipsolutions.net header.i=@sipsolutions.net header.b="X92eHdlA"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=sipsolutions.net; s=mail; h=Content-Transfer-Encoding:MIME-Version:
	References:In-Reply-To:Message-ID:Date:Subject:Cc:To:From:Content-Type:Sender
	:Reply-To:Content-ID:Content-Description:Resent-Date:Resent-From:Resent-To:
	Resent-Cc:Resent-Message-ID; bh=wBs/hOgmxEWIQoym03W3MDebOaHMH5CghfqTm1NyC90=;
	t=1788534148; x=1789743748; b=X92eHdlAUbcvlCM2Ci7vsmB0hpNFU/eRR0JxmxoTNAo0O/+
	x5HQ+Qn+c6FnWGwkn3XppgGYvZPENDanSkP4Wf8ltL2dUKoipgQWTjdw4g4bv5jThjrEK0I22toTk
	7Tn3omjvdkmoOzQNlRcpe60w2IvPiQ0uqDnaYZlFZjyEfyBHwpweOH1yMHnUnr2Mo9UAD+v2Q9RXj
	DGzeY1LJ5pV5nLFIIXhEeN12CKuCxRX/3MPljlsAvbgRy2wLWnZVq5D262RnHdn0iBfiB8A5Fiow5
	fWRPx9p06+VgWwJIqUjR4+2KuXCb50mmYTiDpWyZ6O82bPD1lmethHeGnZkXQH/Q==;
Received: by sipsolutions.net with esmtpsa (TLS1.3:ECDHE_X25519__ECDSA_SECP256R1_SHA256__AES_256_GCM:256)
	(Exim 4.98.2)
	(envelope-from <johannes@sipsolutions.net>)
	id 1x2VQv-00000001Sh8-2seK;
	Fri, 04 Sep 2026 17:02:25 +0200
From: Johannes Berg <johannes@sipsolutions.net>
To: linux-wireless@vger.kernel.org
Cc: Johannes Berg <johannes.berg@intel.com>,
	syzbot+3515319a302224e081b4@syzkaller.appspotmail.com
Subject: [PATCH wireless 2/4] wifi: cfg80211: undo netns switch if renaming the wiphy fails
Date: Fri,  4 Sep 2026 17:02:00 +0200
Message-ID: <20260904170220.7966cc705e33.Ib398351113bbd3cab85302467060cab378564421@changeid>
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

Once all the interfaces have been moved, cfg80211_switch_netns()
moves the wiphy itself by setting its network namespace and then
renaming it, which makes sysfs move it. The rename can fail (but
only on allocation failures), leaving things mixed up and hitting
the warning there.

Ignoring it isn't great, undo the move and let the change fail
in this case. If undo fails then WARN, then things would again
be stuck in two different network namespaces.

Assisted-by: LLM
Reported-by: syzbot+3515319a302224e081b4@syzkaller.appspotmail.com
Closes: https://syzkaller.appspot.com/bug?extid=3515319a302224e081b4
Fixes: 463d018323851 ("cfg80211: make aware of net namespaces")
Signed-off-by: Johannes Berg <johannes.berg@intel.com>
---
 net/wireless/core.c | 94 +++++++++++++++++++++++++--------------------
 1 file changed, 53 insertions(+), 41 deletions(-)

diff --git a/net/wireless/core.c b/net/wireless/core.c
index 043bb57b0556..9ee1c36f1262 100644
--- a/net/wireless/core.c
+++ b/net/wireless/core.c
@@ -153,9 +153,25 @@ int cfg80211_dev_rename(struct cfg80211_registered_device *rdev,
 	return 0;
 }
 
+static int cfg80211_switch_wdev_netns(struct wireless_dev *wdev,
+				      struct net *net)
+{
+	int err;
+
+	if (!wdev->netdev)
+		return 0;
+
+	wdev->netdev->netns_immutable = false;
+	err = dev_change_net_namespace(wdev->netdev, net, "wlan%d");
+	wdev->netdev->netns_immutable = true;
+
+	return err;
+}
+
 int cfg80211_switch_netns(struct cfg80211_registered_device *rdev,
 			  struct net *net)
 {
+	struct net *old_net = wiphy_net(&rdev->wiphy);
 	struct wireless_dev *wdev;
 	int err = 0;
 
@@ -163,58 +179,54 @@ int cfg80211_switch_netns(struct cfg80211_registered_device *rdev,
 		return -EOPNOTSUPP;
 
 	list_for_each_entry(wdev, &rdev->wiphy.wdev_list, list) {
-		if (!wdev->netdev)
-			continue;
-		wdev->netdev->netns_immutable = false;
-		err = dev_change_net_namespace(wdev->netdev, net, "wlan%d");
-		wdev->netdev->netns_immutable = true;
+		err = cfg80211_switch_wdev_netns(wdev, net);
 		if (err)
-			break;
+			goto undo;
 	}
 
-	if (err) {
-		/* failed -- clean up to old netns */
-		net = wiphy_net(&rdev->wiphy);
-
-		list_for_each_entry_continue_reverse(wdev,
-						     &rdev->wiphy.wdev_list,
-						     list) {
+	scoped_guard(wiphy, &rdev->wiphy) {
+		list_for_each_entry(wdev, &rdev->wiphy.wdev_list, list) {
 			if (!wdev->netdev)
 				continue;
-			wdev->netdev->netns_immutable = false;
-			err = dev_change_net_namespace(wdev->netdev, net,
-							"wlan%d");
-			WARN_ON(err);
-			wdev->netdev->netns_immutable = true;
+			nl80211_notify_iface(rdev, wdev,
+					     NL80211_CMD_DEL_INTERFACE);
 		}
 
-		return err;
+		nl80211_notify_wiphy(rdev, NL80211_CMD_DEL_WIPHY);
+
+		wiphy_net_set(&rdev->wiphy, net);
+
+		/* this only fails on allocation failure */
+		err = device_rename(&rdev->wiphy.dev,
+				    dev_name(&rdev->wiphy.dev));
+		if (err)
+			wiphy_net_set(&rdev->wiphy, old_net);
+
+		nl80211_notify_wiphy(rdev, NL80211_CMD_NEW_WIPHY);
+
+		list_for_each_entry(wdev, &rdev->wiphy.wdev_list, list) {
+			if (!wdev->netdev)
+				continue;
+			nl80211_notify_iface(rdev, wdev,
+					     NL80211_CMD_NEW_INTERFACE);
+		}
 	}
 
-	guard(wiphy)(&rdev->wiphy);
+	if (!err)
+		return 0;
 
-	list_for_each_entry(wdev, &rdev->wiphy.wdev_list, list) {
-		if (!wdev->netdev)
-			continue;
-		nl80211_notify_iface(rdev, wdev, NL80211_CMD_DEL_INTERFACE);
-	}
+	/* set to the last one to undo all of them */
+	wdev = list_entry(&rdev->wiphy.wdev_list, typeof(*wdev), list);
+undo:
+	/*
+	 * Move back everything, if this fails again (allocation failures)
+	 * then things get stuck in different network namespaces.
+	 */
+	list_for_each_entry_continue_reverse(wdev, &rdev->wiphy.wdev_list,
+					     list)
+		WARN_ON(cfg80211_switch_wdev_netns(wdev, old_net));
 
-	nl80211_notify_wiphy(rdev, NL80211_CMD_DEL_WIPHY);
-
-	wiphy_net_set(&rdev->wiphy, net);
-
-	err = device_rename(&rdev->wiphy.dev, dev_name(&rdev->wiphy.dev));
-	WARN_ON(err);
-
-	nl80211_notify_wiphy(rdev, NL80211_CMD_NEW_WIPHY);
-
-	list_for_each_entry(wdev, &rdev->wiphy.wdev_list, list) {
-		if (!wdev->netdev)
-			continue;
-		nl80211_notify_iface(rdev, wdev, NL80211_CMD_NEW_INTERFACE);
-	}
-
-	return 0;
+	return err;
 }
 
 static void cfg80211_rfkill_poll(struct rfkill *rfkill, void *data)
-- 
2.55.0

