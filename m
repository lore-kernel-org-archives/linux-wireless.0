Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-bw0-f209.google.com ([209.85.218.209]:45081 "EHLO
	mail-bw0-f209.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933109Ab0CKPpb (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 11 Mar 2010 10:45:31 -0500
Received: by mail-bw0-f209.google.com with SMTP id 1so156999bwz.21
        for <linux-wireless@vger.kernel.org>; Thu, 11 Mar 2010 07:45:30 -0800 (PST)
From: Grazvydas Ignotas <notasas@gmail.com>
To: linux-wireless@vger.kernel.org
Cc: Kalle Valo <kalle.valo@iki.fi>,
	Grazvydas Ignotas <notasas@gmail.com>
Subject: [PATCH 4/4] wl1251: fix potential crash
Date: Thu, 11 Mar 2010 17:45:26 +0200
Message-Id: <1268322326-16721-1-git-send-email-notasas@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

In case debugfs does not init for some reason (or is disabled
on older kernels) driver does not allocate stats.fw_stats
structure, but tries to clear it later and trips on a NULL
pointer:

Unable to handle kernel NULL pointer dereference at virtual address
00000000
PC is at __memzero+0x24/0x80
Backtrace:
[<bf0ddb88>] (wl1251_debugfs_reset+0x0/0x30 [wl1251])
[<bf0d6a2c>] (wl1251_op_stop+0x0/0x12c [wl1251])
[<bf0bc228>] (ieee80211_stop_device+0x0/0x74 [mac80211])
[<bf0b0d10>] (ieee80211_stop+0x0/0x4ac [mac80211])
[<c02deeac>] (dev_close+0x0/0xb4)
[<c02deac0>] (dev_change_flags+0x0/0x184)
[<c031f478>] (devinet_ioctl+0x0/0x704)
[<c0320720>] (inet_ioctl+0x0/0x100)

Add a NULL pointer check to fix this.

Signed-off-by: Grazvydas Ignotas <notasas@gmail.com>
---
 drivers/net/wireless/wl12xx/wl1251_debugfs.c |    3 ++-
 1 files changed, 2 insertions(+), 1 deletions(-)

diff --git a/drivers/net/wireless/wl12xx/wl1251_debugfs.c b/drivers/net/wireless/wl12xx/wl1251_debugfs.c
index 0ccba57..05e4d68 100644
--- a/drivers/net/wireless/wl12xx/wl1251_debugfs.c
+++ b/drivers/net/wireless/wl12xx/wl1251_debugfs.c
@@ -466,7 +466,8 @@ out:
 
 void wl1251_debugfs_reset(struct wl1251 *wl)
 {
-	memset(wl->stats.fw_stats, 0, sizeof(*wl->stats.fw_stats));
+	if (wl->stats.fw_stats != NULL)
+		memset(wl->stats.fw_stats, 0, sizeof(*wl->stats.fw_stats));
 	wl->stats.retry_count = 0;
 	wl->stats.excessive_retries = 0;
 }
-- 
1.6.3.3

