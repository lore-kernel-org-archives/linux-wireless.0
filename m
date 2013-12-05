Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from plane.gmane.org ([80.91.229.3]:46023 "EHLO plane.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932452Ab3LEOAL (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 5 Dec 2013 09:00:11 -0500
Received: from list by plane.gmane.org with local (Exim 4.69)
	(envelope-from <glkwg-linux-wireless@m.gmane.org>)
	id 1VoZTI-0002H6-L2
	for linux-wireless@vger.kernel.org; Thu, 05 Dec 2013 15:00:04 +0100
Received: from gw.alumnux.com ([121.243.14.254])
        by main.gmane.org with esmtp (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-wireless@vger.kernel.org>; Thu, 05 Dec 2013 15:00:04 +0100
Received: from royujjal by gw.alumnux.com with local (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-wireless@vger.kernel.org>; Thu, 05 Dec 2013 15:00:04 +0100
To: linux-wireless@vger.kernel.org
From: Ujjal Roy <royujjal@gmail.com>
Subject: Re: [PATCH v2] cfg80211: fix =?utf-8?b?V0FSTl9PTg==?= for re-association to the expired BSS
Date: Thu, 5 Dec 2013 13:51:02 +0000 (UTC)
Message-ID: <loom.20131205T144715-166@post.gmane.org> (sfid-20131205_150018_406122_FEF13CCB)
References: <1385883096-7143-1-git-send-email-royujjal@gmail.com>  (sfid-20131201_083145_260096_779C94CC) <1386081014.4393.31.camel@jlt4.sipsolutions.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Johannes Berg <johannes@...> writes:

> In an unsuccessful result case, this leaks the BSS struct. I'd prefer to
> reshuffle the code a bit to not need a separate save_bss variable, but I
> don't immediately see an easy way to do that.
> 
> johannes
>

Thanks for pointing out the issue. The modified patch is here.
---

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

Fix it by reshuffling the code.

Signed-off-by: Ujjal Roy <royujjal@gmail.com>
---
 net/wireless/sme.c | 22 ++++++++++++----------
 1 file changed, 12 insertions(+), 10 deletions(-)

diff --git a/net/wireless/sme.c b/net/wireless/sme.c
index 65f8008..d3c5bd7 100644
--- a/net/wireless/sme.c
+++ b/net/wireless/sme.c
@@ -632,6 +632,16 @@ void __cfg80211_connect_result(struct net_device *dev, 
const u8 *bssid,
 	}
 #endif
 
+	if (!bss && (status == WLAN_STATUS_SUCCESS)) {
+		WARN_ON_ONCE(!wiphy_to_dev(wdev->wiphy)->ops->connect);
+		bss = cfg80211_get_bss(wdev->wiphy, NULL, bssid,
+				       wdev->ssid, wdev->ssid_len,
+				       WLAN_CAPABILITY_ESS,
+				       WLAN_CAPABILITY_ESS);
+		if (bss)
+			cfg80211_hold_bss(bss_from_pub(bss));
+	}
+
 	if (wdev->current_bss) {
 		cfg80211_unhold_bss(wdev->current_bss);
 		cfg80211_put_bss(wdev->wiphy, &wdev->current_bss->pub);
@@ -649,16 +659,8 @@ void __cfg80211_connect_result(struct net_device *dev, 
const u8 *bssid,
 		return;
 	}
 
-	if (!bss) {
-		WARN_ON_ONCE(!wiphy_to_dev(wdev->wiphy)->ops->connect);
-		bss = cfg80211_get_bss(wdev->wiphy, NULL, bssid,
-				       wdev->ssid, wdev->ssid_len,
-				       WLAN_CAPABILITY_ESS,
-				       WLAN_CAPABILITY_ESS);
-		if (WARN_ON(!bss))
-			return;
-		cfg80211_hold_bss(bss_from_pub(bss));
-	}
+	if (WARN_ON(!bss))
+		return;
 
 	wdev->current_bss = bss_from_pub(bss);
 
-- 
1.8.1.4

> --
> To unsubscribe from this list: send the line "unsubscribe linux-wireless" 
in
> the body of a message to majordomo@...
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 
> 



