Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pd0-f176.google.com ([209.85.192.176]:33937 "EHLO
	mail-pd0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750807Ab3LAH04 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 1 Dec 2013 02:26:56 -0500
Received: by mail-pd0-f176.google.com with SMTP id w10so16081110pde.35
        for <linux-wireless@vger.kernel.org>; Sat, 30 Nov 2013 23:26:55 -0800 (PST)
From: Ujjal Roy <royujjal@gmail.com>
To: "'John W. Linville" <linville@tuxdriver.com>
Cc: ' <linux-wireless@vger.kernel.org>,
	'Johannes Berg <johannes@sipsolutions.net>
Subject: [PATCH] cfg80211: fix WARN_ON for re-association to the expired BSS
Date: Sun,  1 Dec 2013 12:56:50 +0530
Message-Id: <1385882810-7005-1-git-send-email-royujjal@gmail.com> (sfid-20131201_082717_657543_D0C08508)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

cfg80211 allows re-association in managed mode and if a user
wants to re-associate to the same AP network after the time
period of IEEE80211_SCAN_RESULT_EXPIRE, cfg80211 warns with
the following message on receiving the connect result event.

------------[ cut here ]------------
WARNING: CPU: 0 PID: 13984 at net/wireless/sme.c:658
         __cfg80211_connect_result+0x3a6/0x3e0 [cfg80211]()
Call Trace:
 [<ffffffff81747a41>] dump_stack+0x46/0x58
 [<ffffffff81045847>] warn_slowpath_common+0x87/0xb0
 [<ffffffff81045885>] warn_slowpath_null+0x15/0x20
 [<ffffffffa05345f6>] __cfg80211_connect_result+0x3a6/0x3e0 [cfg80211]
 [<ffffffff8107168b>] ? update_rq_clock+0x2b/0x50
 [<ffffffff81078c01>] ? update_curr+0x1/0x160
 [<ffffffffa05133d2>] cfg80211_process_wdev_events+0xb2/0x1c0 [cfg80211]
 [<ffffffff81079303>] ? pick_next_task_fair+0x63/0x170
 [<ffffffffa0513518>] cfg80211_process_rdev_events+0x38/0x90 [cfg80211]
 [<ffffffffa050f03d>] cfg80211_event_work+0x1d/0x30 [cfg80211]
 [<ffffffff8105f21f>] process_one_work+0x17f/0x420
 [<ffffffff8105f90a>] worker_thread+0x11a/0x370
 [<ffffffff8105f7f0>] ? rescuer_thread+0x2f0/0x2f0
 [<ffffffff8106638b>] kthread+0xbb/0xc0
 [<ffffffff810662d0>] ? kthread_create_on_node+0x120/0x120
 [<ffffffff817574bc>] ret_from_fork+0x7c/0xb0
 [<ffffffff810662d0>] ? kthread_create_on_node+0x120/0x120
---[ end trace 61f3bddc9c4981f7 ]---

The reason is that, in connect result event cfg80211 unholds
the BSS to which the device is associated (and was held so
far). So, for the event with status successful, when cfg80211
wants to get that BSS from the device's BSS list it gets a
NULL BSS because the BSS has been expired and unheld already.

Fix this by searching and saving the BSS before it gets unhold
by the cfg80211. Use that saved BSS and hold it again when the
assiciation is successful.

Signed-off-by: Ujjal Roy <royujjal@gmail.com>
---
 net/wireless/sme.c | 11 +++++++----
 1 file changed, 7 insertions(+), 4 deletions(-)

diff --git a/net/wireless/sme.c b/net/wireless/sme.c
index 65f8008..5eeb8e0 100644
--- a/net/wireless/sme.c
+++ b/net/wireless/sme.c
@@ -589,6 +589,7 @@ void __cfg80211_connect_result(struct net_device *dev, const u8 *bssid,
 			       struct cfg80211_bss *bss)
 {
 	struct wireless_dev *wdev = dev->ieee80211_ptr;
+	struct cfg80211_bss *save_bss = NULL;
 	const u8 *country_ie;
 #ifdef CONFIG_CFG80211_WEXT
 	union iwreq_data wrqu;
@@ -632,6 +633,11 @@ void __cfg80211_connect_result(struct net_device *dev, const u8 *bssid,
 	}
 #endif
 
+	if (!bss)
+		save_bss = cfg80211_get_bss(wdev->wiphy, NULL, bssid,
+					    wdev->ssid, wdev->ssid_len,
+					    WLAN_CAPABILITY_ESS,
+					    WLAN_CAPABILITY_ESS);
 	if (wdev->current_bss) {
 		cfg80211_unhold_bss(wdev->current_bss);
 		cfg80211_put_bss(wdev->wiphy, &wdev->current_bss->pub);
@@ -651,10 +657,7 @@ void __cfg80211_connect_result(struct net_device *dev, const u8 *bssid,
 
 	if (!bss) {
 		WARN_ON_ONCE(!wiphy_to_dev(wdev->wiphy)->ops->connect);
-		bss = cfg80211_get_bss(wdev->wiphy, NULL, bssid,
-				       wdev->ssid, wdev->ssid_len,
-				       WLAN_CAPABILITY_ESS,
-				       WLAN_CAPABILITY_ESS);
+		bss = save_bss;
 		if (WARN_ON(!bss))
 			return;
 		cfg80211_hold_bss(bss_from_pub(bss));
-- 
1.8.3.1

