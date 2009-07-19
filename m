Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from fmmailgate01.web.de ([217.72.192.221]:55525 "EHLO
	fmmailgate01.web.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754110AbZGSDFj (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 18 Jul 2009 23:05:39 -0400
From: Christian Lamparter <chunkeey@web.de>
To: wireless <linux-wireless@vger.kernel.org>
Subject: [PATCH] cfg80211: double free in __cfg80211_scan_done
Date: Sun, 19 Jul 2009 05:05:37 +0200
Cc: "Luis R. Rodriguez" <lrodriguez@atheros.com>,
	Johannes Berg <johannes@sipsolutions.net>,
	"John W. Linville" <linville@tuxdriver.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Message-Id: <200907190505.37742.chunkeey@web.de>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This patch fixes a double free corruption in __cfg80211_scan_done:

 ================================================
 BUG kmalloc-512: Object already free
 ------------------------------------------------

 INFO: Allocated in load_elf_binary+0x18b/0x19af age=6
 INFO: Freed in load_elf_binary+0x104e/0x19af age=5 
 INFO: Slab 0xffffea0001bae4c0 objects=14 used=7
 INFO: Object 0xffff88007e8a9918 @offset=6424 fp=0xffff88007e8a9488

 Bytes b4 0xffff88007e8a9908:  00 00 00 00 00 00 00 00 5a 5a
 [...]
 Pid: 28705, comm: rmmod Tainted: P         C 2.6.31-rc2-wl #1
 Call Trace:
  [<ffffffff810da9f4>] print_trailer+0x14e/0x16e
  [<ffffffff810daa56>] object_err+0x42/0x61
  [<ffffffff810dbcd9>] __slab_free+0x2af/0x396
  [<ffffffffa0ec9694>] ? wiphy_unregister+0x92/0x142 [cfg80211]
  [<ffffffff810dd5e3>] kfree+0x13c/0x17a
  [<ffffffffa0ec9694>] ? wiphy_unregister+0x92/0x142 [cfg80211]
  [<ffffffffa0ec9694>] wiphy_unregister+0x92/0x142 [cfg80211]
  [<ffffffffa0eed163>] ieee80211_unregister_hw+0xc8/0xff [mac80211]
  [<ffffffffa0f3fbc8>] p54_unregister_common+0x31/0x66 [p54common]
  [...]
 FIX kmalloc-512: Object at 0xffff88007e8a9918 not freed

The code path which leads to the *funny* double free:

       request = rdev->scan_req;
       dev = dev_get_by_index(&init_net, request->ifidx); 
	/*
	 * the driver was unloaded recently and 
	 * therefore dev_get_by_index will return NULL!
	 */
        if (!dev)
                goto out;
	[...]
	rdev->scan_req = NULL; /* not executed... */
	[...]
 out:
        kfree(request);

Signed-off-by: Christian Lamparter <chunkeey@web.de>
---
huh, no one spotted that bug before?
---
diff --git a/net/wireless/scan.c b/net/wireless/scan.c
index 4f552c3..4ad8b4b 100644
--- a/net/wireless/scan.c
+++ b/net/wireless/scan.c
@@ -48,8 +48,6 @@ void __cfg80211_scan_done(struct work_struct *wk)
 	else
 		nl80211_send_scan_done(wiphy_to_dev(request->wiphy), dev);
 
-	wiphy_to_dev(request->wiphy)->scan_req = NULL;
-
 #ifdef CONFIG_WIRELESS_EXT
 	if (!request->aborted) {
 		memset(&wrqu, 0, sizeof(wrqu));
@@ -61,6 +59,7 @@ void __cfg80211_scan_done(struct work_struct *wk)
 	dev_put(dev);
 
  out:
+	rdev->scan_req = NULL;
 	cfg80211_unlock_rdev(rdev);
 	kfree(request);
 }
