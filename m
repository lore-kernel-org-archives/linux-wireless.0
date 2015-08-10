Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pd0-f179.google.com ([209.85.192.179]:32879 "EHLO
	mail-pd0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753083AbbHJIAz (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 10 Aug 2015 04:00:55 -0400
From: Shraddha Barke <shraddha.6596@gmail.com>
To: Oleg Drokin <oleg.drokin@intel.com>,
	Andreas Dilger <andreas.dilger@intel.com>,
	Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	Benjamin Romer <benjamin.romer@unisys.com>,
	Johnny Kim <johnny.kim@atmel.com>,
	Rachel Kim <rachel.kim@atmel.com>, HPDD-discuss@lists.01.org,
	linux-kernel@vger.kernel.org, linux-wireless@vger.kernel.org
Cc: Shraddha Barke <shraddha.6596@gmail.com>
Subject: [PATCH 1/3] Staging: wilc1000: Remove null check before kfree
Date: Mon, 10 Aug 2015 13:30:33 +0530
Message-Id: <1439193635-6063-1-git-send-email-shraddha.6596@gmail.com> (sfid-20150810_100240_056174_9745D1DB)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

kfree on NULL pointer is a no-op.

This patch uses the following semantic patch to find such an instance
where NULL check is present before kfree.

// <smpl>
@@ expression E; @@
- if (E != NULL) { kfree(E); }
+ kfree(E);
@@ expression E; @@
- if (E != NULL) { kfree(E); E = NULL; }
+ kfree(E);
+ E = NULL;
// </smpl>smpl>

Signed-off-by: Shraddha Barke <shraddha.6596@gmail.com>
---
 drivers/staging/wilc1000/linux_wlan.c | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/drivers/staging/wilc1000/linux_wlan.c b/drivers/staging/wilc1000/linux_wlan.c
index 3e55a8a..3dcd6e5 100644
--- a/drivers/staging/wilc1000/linux_wlan.c
+++ b/drivers/staging/wilc1000/linux_wlan.c
@@ -2343,8 +2343,7 @@ int mac_ioctl(struct net_device *ndev, struct ifreq *req, int cmd)
 
 done:
 
-	if (buff != NULL)
-		kfree(buff);
+	kfree(buff);
 
 	return s32Error;
 }
-- 
2.1.0

