Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from ms5.Sony.CO.JP ([211.125.136.201]:54589 "EHLO ms5.sony.co.jp"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750893AbYE3H1u (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 30 May 2008 03:27:50 -0400
Received: from mta6.sony.co.jp (mta6.Sony.CO.JP [137.153.71.9])
 by ms5.sony.co.jp (R8/Sony) with ESMTP id m4U7RmZv003516
 for <linux-wireless@vger.kernel.org>; Fri, 30 May 2008 16:27:48 +0900 (JST)
Received: from mta6.sony.co.jp (localhost [127.0.0.1])
 by mta6.sony.co.jp (R8/Sony) with ESMTP id m4U7RmIr012351
 for <linux-wireless@vger.kernel.org>; Fri, 30 May 2008 16:27:48 +0900 (JST)
Received: from smail1.sm.sony.co.jp (smail1.sm.sony.co.jp [43.11.253.1])
 by mta6.sony.co.jp (R8/Sony) with ESMTP id m4U7Rlbb012344
 for <linux-wireless@vger.kernel.org>; Fri, 30 May 2008 16:27:48 +0900 (JST)
Date: Fri, 30 May 2008 16:27:42 +0900
From: Masakazu Mokuno <mokuno@sm.sony.co.jp>
To: linux-wireless@vger.kernel.org
Subject: [PATCH 2/3] PS3: gelic: Kill the static bounce buffer
Cc: geoffrey.levand@am.sony.com,
	Geert Uytterhoeven <Geert.Uytterhoeven@sonycom.com>
In-Reply-To: <20080530132951.4720.40F06B3A@sm.sony.co.jp>
References: <20080530132951.4720.40F06B3A@sm.sony.co.jp>
Message-Id: <20080530162321.4739.40F06B3A@sm.sony.co.jp> (sfid-20080530_092810_386244_78F1D518)
MIME-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

As the bounce buffer is allocaetd dynamically, kill the static bounce buffer.

Signed-off-by: Masakazu Mokuno <mokuno@sm.sony.co.jp>
---
 drivers/net/ps3_gelic_wireless.c |    9 ---------
 drivers/net/ps3_gelic_wireless.h |    3 ---
 2 files changed, 12 deletions(-)

--- a/drivers/net/ps3_gelic_wireless.c
+++ b/drivers/net/ps3_gelic_wireless.c
@@ -2472,16 +2472,9 @@ static struct net_device *gelic_wl_alloc
 	BUILD_BUG_ON(PAGE_SIZE <
 		     sizeof(struct gelic_eurus_scan_info) *
 		     GELIC_EURUS_MAX_SCAN);
-	wl->buf = (void *)get_zeroed_page(GFP_KERNEL);
-	if (!wl->buf) {
-		pr_info("%s:buffer allocation failed\n", __func__);
-		goto fail_getpage;
-	}
 	pr_debug("%s:end\n", __func__);
 	return netdev;
 
-fail_getpage:
-	destroy_workqueue(wl->event_queue);
 fail_event_workqueue:
 	destroy_workqueue(wl->eurus_cmd_queue);
 fail_cmd_workqueue:
@@ -2500,8 +2493,6 @@ static void gelic_wl_free(struct gelic_w
 
 	pr_debug("%s: <-\n", __func__);
 
-	free_page((unsigned long)wl->buf);
-
 	pr_debug("%s: destroy queues\n", __func__);
 	destroy_workqueue(wl->eurus_cmd_queue);
 	destroy_workqueue(wl->event_queue);
--- a/drivers/net/ps3_gelic_wireless.h
+++ b/drivers/net/ps3_gelic_wireless.h
@@ -288,9 +288,6 @@ struct gelic_wl_info {
 	u8 active_bssid[ETH_ALEN]; /* associated bssid */
 	unsigned int essid_len;
 
-	/* buffer for hypervisor IO */
-	void *buf;
-
 	struct iw_public_data wireless_data;
 	struct iw_statistics iwstat;
 };

