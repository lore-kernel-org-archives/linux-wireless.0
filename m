Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wolverine02.qualcomm.com ([199.106.114.251]:55938 "EHLO
	wolverine02.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755798Ab1LGPHU (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 7 Dec 2011 10:07:20 -0500
From: Vasanthakumar Thiagarajan <vthiagar@qca.qualcomm.com>
To: <linville@tuxdriver.com>
CC: <johannes@sipsolutions.net>, <linux-wireless@vger.kernel.org>
Subject: [PATCH] cfg80211: Fix race in bss timeout
Date: Wed, 7 Dec 2011 20:41:27 +0530
Message-ID: <1323270687-5989-1-git-send-email-vthiagar@qca.qualcomm.com> (sfid-20111207_160723_669361_ECA81500)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

It is quite possible to run into a race in bss timeout where
the drivers see the bss entry just before notifying cfg80211
of a roaming event but it got timed out by the time rdev->event_work
got scehduled from cfg80211_wq. This would result in the following
WARN-ON() along with the failure to notify the user space of
the roaming. The other situation which is happening with ath6kl
that runs into issue is when the driver reports roam to same AP
event where the AP bss entry already got expired. To fix this,
move cfg80211_get_bss() from __cfg80211_roamed() to cfg80211_roamed().

[158645.538384] WARNING: at net/wireless/sme.c:586
__cfg80211_roamed+0xc2/0x1b1()
[158645.538810] Call Trace:
[158645.538838]  [<c1033527>] warn_slowpath_common+0x65/0x7a
[158645.538917]  [<c14cfacf>] ? __cfg80211_roamed+0xc2/0x1b1
[158645.538946]  [<c103354b>] warn_slowpath_null+0xf/0x13
[158645.539055]  [<c14cfacf>] __cfg80211_roamed+0xc2/0x1b1
[158645.539086]  [<c14beb5b>] cfg80211_process_rdev_events+0x153/0x1cc
[158645.539166]  [<c14bd57b>] cfg80211_event_work+0x26/0x36
[158645.539195]  [<c10482ae>] process_one_work+0x219/0x38b
[158645.539273]  [<c14bd555>] ? wiphy_new+0x419/0x419
[158645.539301]  [<c10486cb>] worker_thread+0xf6/0x1bf
[158645.539379]  [<c10485d5>] ? rescuer_thread+0x1b5/0x1b5
[158645.539407]  [<c104b3e2>] kthread+0x62/0x67
[158645.539484]  [<c104b380>] ? __init_kthread_worker+0x42/0x42
[158645.539514]  [<c151309a>] kernel_thread_helper+0x6/0xd

Reported-by: Kalle Valo <kvalo@qca.qualcomm.com>
Signed-off-by: Vasanthakumar Thiagarajan <vthiagar@qca.qualcomm.com>
---
 net/wireless/core.h |    6 +---
 net/wireless/sme.c  |   66 ++++++++++++++++++++++++++++++++++-----------------
 net/wireless/util.c |    6 ++--
 3 files changed, 49 insertions(+), 29 deletions(-)

diff --git a/net/wireless/core.h b/net/wireless/core.h
index 1c7d4df..11ff6bb 100644
--- a/net/wireless/core.h
+++ b/net/wireless/core.h
@@ -249,12 +249,11 @@ struct cfg80211_event {
 			u16 status;
 		} cr;
 		struct {
-			struct ieee80211_channel *channel;
-			u8 bssid[ETH_ALEN];
 			const u8 *req_ie;
 			const u8 *resp_ie;
 			size_t req_ie_len;
 			size_t resp_ie_len;
+			struct cfg80211_bss *bss;
 		} rm;
 		struct {
 			const u8 *ie;
@@ -397,8 +396,7 @@ int cfg80211_disconnect(struct cfg80211_registered_device *rdev,
 			struct net_device *dev, u16 reason,
 			bool wextev);
 void __cfg80211_roamed(struct wireless_dev *wdev,
-		       struct ieee80211_channel *channel,
-		       const u8 *bssid,
+		       struct cfg80211_bss *bss,
 		       const u8 *req_ie, size_t req_ie_len,
 		       const u8 *resp_ie, size_t resp_ie_len);
 int cfg80211_mgd_wext_connect(struct cfg80211_registered_device *rdev,
diff --git a/net/wireless/sme.c b/net/wireless/sme.c
index 0acfdc9..1857e96 100644
--- a/net/wireless/sme.c
+++ b/net/wireless/sme.c
@@ -551,44 +551,41 @@ void cfg80211_connect_result(struct net_device *dev, const u8 *bssid,
 EXPORT_SYMBOL(cfg80211_connect_result);
 
 void __cfg80211_roamed(struct wireless_dev *wdev,
-		       struct ieee80211_channel *channel,
-		       const u8 *bssid,
+		       struct cfg80211_bss *bss,
 		       const u8 *req_ie, size_t req_ie_len,
 		       const u8 *resp_ie, size_t resp_ie_len)
 {
-	struct cfg80211_bss *bss;
 #ifdef CONFIG_CFG80211_WEXT
 	union iwreq_data wrqu;
 #endif
+	struct cfg80211_registered_device *dev = wiphy_to_dev(wdev->wiphy);
+	u8 bssid[ETH_ALEN];
 
 	ASSERT_WDEV_LOCK(wdev);
 
 	if (WARN_ON(wdev->iftype != NL80211_IFTYPE_STATION &&
 		    wdev->iftype != NL80211_IFTYPE_P2P_CLIENT))
-		return;
+		goto out;
 
 	if (wdev->sme_state != CFG80211_SME_CONNECTED)
-		return;
+		goto out;
 
 	/* internal error -- how did we get to CONNECTED w/o BSS? */
 	if (WARN_ON(!wdev->current_bss)) {
-		return;
+		goto out;
 	}
 
 	cfg80211_unhold_bss(wdev->current_bss);
 	cfg80211_put_bss(&wdev->current_bss->pub);
 	wdev->current_bss = NULL;
 
-	bss = cfg80211_get_bss(wdev->wiphy, channel, bssid,
-			       wdev->ssid, wdev->ssid_len,
-			       WLAN_CAPABILITY_ESS, WLAN_CAPABILITY_ESS);
-
-	if (WARN_ON(!bss))
-		return;
-
 	cfg80211_hold_bss(bss_from_pub(bss));
 	wdev->current_bss = bss_from_pub(bss);
 
+	spin_lock_bh(&dev->bss_lock);
+	memcpy(bssid, bss->bssid, ETH_ALEN);
+	spin_unlock_bh(&dev->bss_lock);
+
 	nl80211_send_roamed(wiphy_to_dev(wdev->wiphy), wdev->netdev, bssid,
 			    req_ie, req_ie_len, resp_ie, resp_ie_len,
 			    GFP_KERNEL);
@@ -615,40 +612,65 @@ void __cfg80211_roamed(struct wireless_dev *wdev,
 	wdev->wext.prev_bssid_valid = true;
 	wireless_send_event(wdev->netdev, SIOCGIWAP, &wrqu, NULL);
 #endif
+
+	return;
+out:
+	if (bss)
+		cfg80211_put_bss(bss);
 }
 
-void cfg80211_roamed(struct net_device *dev,
-		     struct ieee80211_channel *channel,
-		     const u8 *bssid,
-		     const u8 *req_ie, size_t req_ie_len,
-		     const u8 *resp_ie, size_t resp_ie_len, gfp_t gfp)
+static void cfg80211_roamed_bss(struct net_device *dev,
+				struct cfg80211_bss *bss, const u8 *req_ie,
+				size_t req_ie_len, const u8 *resp_ie,
+				size_t resp_ie_len, gfp_t gfp)
 {
 	struct wireless_dev *wdev = dev->ieee80211_ptr;
 	struct cfg80211_registered_device *rdev = wiphy_to_dev(wdev->wiphy);
 	struct cfg80211_event *ev;
 	unsigned long flags;
 
-	CFG80211_DEV_WARN_ON(wdev->sme_state != CFG80211_SME_CONNECTED);
 
 	ev = kzalloc(sizeof(*ev) + req_ie_len + resp_ie_len, gfp);
-	if (!ev)
+	if (!ev) {
+		cfg80211_put_bss(bss);
 		return;
+	}
 
 	ev->type = EVENT_ROAMED;
-	ev->rm.channel = channel;
-	memcpy(ev->rm.bssid, bssid, ETH_ALEN);
 	ev->rm.req_ie = ((u8 *)ev) + sizeof(*ev);
 	ev->rm.req_ie_len = req_ie_len;
 	memcpy((void *)ev->rm.req_ie, req_ie, req_ie_len);
 	ev->rm.resp_ie = ((u8 *)ev) + sizeof(*ev) + req_ie_len;
 	ev->rm.resp_ie_len = resp_ie_len;
 	memcpy((void *)ev->rm.resp_ie, resp_ie, resp_ie_len);
+	ev->rm.bss = bss;
 
 	spin_lock_irqsave(&wdev->event_lock, flags);
 	list_add_tail(&ev->list, &wdev->event_list);
 	spin_unlock_irqrestore(&wdev->event_lock, flags);
 	queue_work(cfg80211_wq, &rdev->event_work);
 }
+
+void cfg80211_roamed(struct net_device *dev,
+		     struct ieee80211_channel *channel,
+		     const u8 *bssid,
+		     const u8 *req_ie, size_t req_ie_len,
+		     const u8 *resp_ie, size_t resp_ie_len, gfp_t gfp)
+{
+	struct wireless_dev *wdev = dev->ieee80211_ptr;
+	struct cfg80211_bss *bss;
+
+	CFG80211_DEV_WARN_ON(wdev->sme_state != CFG80211_SME_CONNECTED);
+
+	bss = cfg80211_get_bss(wdev->wiphy, channel, bssid, wdev->ssid,
+			       wdev->ssid_len, WLAN_CAPABILITY_ESS,
+			       WLAN_CAPABILITY_ESS);
+	if (WARN_ON(!bss))
+		return;
+
+	cfg80211_roamed_bss(dev, bss, req_ie, req_ie_len, resp_ie,
+			    resp_ie_len, gfp);
+}
 EXPORT_SYMBOL(cfg80211_roamed);
 
 void __cfg80211_disconnected(struct net_device *dev, const u8 *ie,
diff --git a/net/wireless/util.c b/net/wireless/util.c
index 4dde429..afda051 100644
--- a/net/wireless/util.c
+++ b/net/wireless/util.c
@@ -752,9 +752,9 @@ static void cfg80211_process_wdev_events(struct wireless_dev *wdev)
 				NULL);
 			break;
 		case EVENT_ROAMED:
-			__cfg80211_roamed(wdev, ev->rm.channel, ev->rm.bssid,
-					  ev->rm.req_ie, ev->rm.req_ie_len,
-					  ev->rm.resp_ie, ev->rm.resp_ie_len);
+			__cfg80211_roamed(wdev, ev->rm.bss, ev->rm.req_ie,
+					  ev->rm.req_ie_len, ev->rm.resp_ie,
+					  ev->rm.resp_ie_len);
 			break;
 		case EVENT_DISCONNECTED:
 			__cfg80211_disconnected(wdev->netdev,
-- 
1.7.0.4

