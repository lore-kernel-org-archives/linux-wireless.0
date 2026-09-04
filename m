Received: from sipsolutions.net (s3.sipsolutions.net [168.119.38.16])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5E5C64D8D8F
	for <linux-wireless@vger.kernel.org>; Fri,  4 Sep 2026 14:56:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=168.119.38.16
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788533792; cv=none; b=payh+fLVajazqmjv7OX6Z6VJMYf5dzUNeoFMZ5Qc4nIGybGRk66tvnG2ddS6vDzTJAX4kTIsqa94OXoRAyL6iUU1g37SoQ8QQZklW/F5spGl974Goq8hBpUqyT2hC3BdEiVSW/wUN+EvfktuB7XH+NfUIC+ZuLiKT7NpfrLMOIo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788533792; c=relaxed/simple;
	bh=WILv+J/LYpVTpvxoP2u00bZQn8iq++m6vtcbwol2hzM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=HslussqwtAM7S9/vn074s8gG3B+bRWA1Gq200BkstYj4vxuTaKQJBgYs6vasd9qHKEeuXHt0Ef1e0itiz0m6genSuQrVh0Xkmnn/gO//026/agsViXQ6vjPWkuSlFBfxAP37IWfmP0zmq4M3lFVifKrfSrUKqSa4KsD257iJU9Q=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=permerror header.from=sipsolutions.net; spf=pass smtp.mailfrom=sipsolutions.net; dkim=pass (2048-bit key) header.d=sipsolutions.net header.i=@sipsolutions.net header.b=QoLZ7YMc; arc=none smtp.client-ip=168.119.38.16
Authentication-Results: smtp.subspace.kernel.org; dmarc=permerror header.from=sipsolutions.net
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=sipsolutions.net
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=sipsolutions.net header.i=@sipsolutions.net header.b="QoLZ7YMc"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=sipsolutions.net; s=mail; h=Content-Transfer-Encoding:MIME-Version:
	References:In-Reply-To:Message-ID:Date:Subject:Cc:To:From:Content-Type:Sender
	:Reply-To:Content-ID:Content-Description:Resent-Date:Resent-From:Resent-To:
	Resent-Cc:Resent-Message-ID; bh=dgBVd3r3ZAICiNTRg40+FPz8NMGmqZxZQddEBCyXHr0=;
	t=1788533790; x=1789743390; b=QoLZ7YMcL4Zu06edZlLPfv8+ChjAISWJLJti6Ps8yJlCQP4
	DGoz9myNd0RN8nW/S+UxgCjRxtS0P0WZvnyvXd4ybbG8fM7kbz0PPsrJFzI+fKVcREExbPqsDAq83
	f+AeVJK8T8hax7pbD/xu+JnEDVmz4E8FuVAUTk6vYHdO+/CYhm3y/GRTDtaprhsbq3GA2jhQJf+0x
	XLezNnomrn8FLXf67pC+I8i3HG9Fi3042Uyy0Xej3efKOXobbOAGEqx/zuHaK7GDyJxWIDni2g3SB
	zPTT2adoK+wwuGBjUeMBrurdobpQJ6XP87Kar5I6/cLLqgN2xEf2CSRWXqHoPaLA==;
Received: by sipsolutions.net with esmtpsa (TLS1.3:ECDHE_X25519__ECDSA_SECP256R1_SHA256__AES_256_GCM:256)
	(Exim 4.98.2)
	(envelope-from <johannes@sipsolutions.net>)
	id 1x2VL8-00000001SUL-0SX2;
	Fri, 04 Sep 2026 16:56:26 +0200
From: Johannes Berg <johannes@sipsolutions.net>
To: linux-wireless@vger.kernel.org
Cc: Johannes Berg <johannes.berg@intel.com>,
	syzbot+7f064ba1704c2466e36d@syzkaller.appspotmail.com
Subject: [PATCH wireless 6/8] wifi: cfg80211: ibss: ref BSS entry for joined event
Date: Fri,  4 Sep 2026 16:55:06 +0200
Message-ID: <20260904165614.f49a213f0e49.I192bfe738750ebb5f2c4faa3019a428da64cd3ec@changeid>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260904145614.423902-10-johannes@sipsolutions.net>
References: <20260904145614.423902-10-johannes@sipsolutions.net>
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Johannes Berg <johannes.berg@intel.com>

When the IBSS is joined, we only record the BSSID/channel in the event
and look up the BSS entry when processing it. However, that's racy,
e.g. a new scan with NL80211_SCAN_FLAG_FLUSH can remove it, causing a
warning in the event work:

  !bss
  WARNING: net/wireless/ibss.c:37 at __cfg80211_ibss_joined+0x3d3/0x440
  Workqueue: cfg80211 cfg80211_event_work
   cfg80211_process_wdev_events+0x39f/0x5b0 net/wireless/util.c:1144
   cfg80211_process_rdev_events+0xa1/0x110 net/wireless/util.c:1179
   cfg80211_event_work+0x2f/0x40 net/wireless/core.c:393

Do the lookup early (the driver is expected to only join an IBSS that
has a BSS entry) and keep a reference to it.

Assisted-by: LLM
Fixes: 667503ddcb96 ("cfg80211: fix locking")
Reported-by: syzbot+7f064ba1704c2466e36d@syzkaller.appspotmail.com
Closes: https://syzkaller.appspot.com/bug?extid=7f064ba1704c2466e36d
Signed-off-by: Johannes Berg <johannes.berg@intel.com>
---
 net/wireless/core.h |  6 ++----
 net/wireless/ibss.c | 38 +++++++++++++++++++++-----------------
 net/wireless/util.c |  3 +--
 3 files changed, 24 insertions(+), 23 deletions(-)

diff --git a/net/wireless/core.h b/net/wireless/core.h
index a0c2b6ebe31f..85dfb3ac803b 100644
--- a/net/wireless/core.h
+++ b/net/wireless/core.h
@@ -290,8 +290,7 @@ struct cfg80211_event {
 			bool locally_generated;
 		} dc;
 		struct {
-			u8 bssid[ETH_ALEN];
-			struct ieee80211_channel *channel;
+			struct cfg80211_bss *bss;
 		} ij;
 		struct {
 			u8 peer_addr[ETH_ALEN];
@@ -354,8 +353,7 @@ int __cfg80211_join_ibss(struct cfg80211_registered_device *rdev,
 void cfg80211_clear_ibss(struct net_device *dev, bool nowext);
 int cfg80211_leave_ibss(struct cfg80211_registered_device *rdev,
 			struct net_device *dev, bool nowext);
-void __cfg80211_ibss_joined(struct net_device *dev, const u8 *bssid,
-			    struct ieee80211_channel *channel);
+void __cfg80211_ibss_joined(struct net_device *dev, struct cfg80211_bss *bss);
 int cfg80211_ibss_wext_join(struct cfg80211_registered_device *rdev,
 			    struct wireless_dev *wdev);
 
diff --git a/net/wireless/ibss.c b/net/wireless/ibss.c
index b1d748bdb504..7f6779d326b8 100644
--- a/net/wireless/ibss.c
+++ b/net/wireless/ibss.c
@@ -16,26 +16,18 @@
 #include "rdev-ops.h"
 
 
-void __cfg80211_ibss_joined(struct net_device *dev, const u8 *bssid,
-			    struct ieee80211_channel *channel)
+void __cfg80211_ibss_joined(struct net_device *dev, struct cfg80211_bss *bss)
 {
 	struct wireless_dev *wdev = dev->ieee80211_ptr;
-	struct cfg80211_bss *bss;
 #ifdef CONFIG_CFG80211_WEXT
 	union iwreq_data wrqu;
 #endif
 
 	if (WARN_ON(wdev->iftype != NL80211_IFTYPE_ADHOC))
-		return;
+		goto put_bss;
 
 	if (!wdev->u.ibss.ssid_len)
-		return;
-
-	bss = cfg80211_get_bss(wdev->wiphy, channel, bssid, NULL, 0,
-			       IEEE80211_BSS_TYPE_IBSS, IEEE80211_PRIVACY_ANY);
-
-	if (WARN_ON(!bss))
-		return;
+		goto put_bss;
 
 	if (wdev->u.ibss.current_bss) {
 		cfg80211_unhold_bss(wdev->u.ibss.current_bss);
@@ -43,17 +35,22 @@ void __cfg80211_ibss_joined(struct net_device *dev, const u8 *bssid,
 	}
 
 	cfg80211_hold_bss(bss_from_pub(bss));
+	/* the reference from the event is transferred to current_bss */
 	wdev->u.ibss.current_bss = bss_from_pub(bss);
 
 	cfg80211_upload_connect_keys(wdev);
 
-	nl80211_send_ibss_bssid(wiphy_to_rdev(wdev->wiphy), dev, bssid,
+	nl80211_send_ibss_bssid(wiphy_to_rdev(wdev->wiphy), dev, bss->bssid,
 				GFP_KERNEL);
 #ifdef CONFIG_CFG80211_WEXT
 	memset(&wrqu, 0, sizeof(wrqu));
-	memcpy(wrqu.ap_addr.sa_data, bssid, ETH_ALEN);
+	memcpy(wrqu.ap_addr.sa_data, bss->bssid, ETH_ALEN);
 	wireless_send_event(dev, SIOCGIWAP, &wrqu, NULL);
 #endif
+	return;
+
+put_bss:
+	cfg80211_put_bss(wdev->wiphy, bss);
 }
 
 void cfg80211_ibss_joined(struct net_device *dev, const u8 *bssid,
@@ -62,6 +59,7 @@ void cfg80211_ibss_joined(struct net_device *dev, const u8 *bssid,
 	struct wireless_dev *wdev = dev->ieee80211_ptr;
 	struct cfg80211_registered_device *rdev = wiphy_to_rdev(wdev->wiphy);
 	struct cfg80211_event *ev;
+	struct cfg80211_bss *bss;
 	unsigned long flags;
 
 	trace_cfg80211_ibss_joined(dev, bssid, channel);
@@ -69,13 +67,19 @@ void cfg80211_ibss_joined(struct net_device *dev, const u8 *bssid,
 	if (WARN_ON(!channel))
 		return;
 
-	ev = kzalloc_obj(*ev, gfp);
-	if (!ev)
+	bss = cfg80211_get_bss(wdev->wiphy, channel, bssid, NULL, 0,
+			       IEEE80211_BSS_TYPE_IBSS, IEEE80211_PRIVACY_ANY);
+	if (WARN_ON(!bss))
 		return;
 
+	ev = kzalloc_obj(*ev, gfp);
+	if (!ev) {
+		cfg80211_put_bss(wdev->wiphy, bss);
+		return;
+	}
+
 	ev->type = EVENT_IBSS_JOINED;
-	memcpy(ev->ij.bssid, bssid, ETH_ALEN);
-	ev->ij.channel = channel;
+	ev->ij.bss = bss;
 
 	spin_lock_irqsave(&wdev->event_lock, flags);
 	list_add_tail(&ev->list, &wdev->event_list);
diff --git a/net/wireless/util.c b/net/wireless/util.c
index 5429cf3cfd2f..f2464d2ce0d5 100644
--- a/net/wireless/util.c
+++ b/net/wireless/util.c
@@ -1235,8 +1235,7 @@ void cfg80211_process_wdev_events(struct wireless_dev *wdev)
 						!ev->dc.locally_generated);
 			break;
 		case EVENT_IBSS_JOINED:
-			__cfg80211_ibss_joined(wdev->netdev, ev->ij.bssid,
-					       ev->ij.channel);
+			__cfg80211_ibss_joined(wdev->netdev, ev->ij.bss);
 			break;
 		case EVENT_STOPPED:
 			/*
-- 
2.55.0

