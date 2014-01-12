Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-oa0-f42.google.com ([209.85.219.42]:34348 "EHLO
	mail-oa0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751344AbaALVMD (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 12 Jan 2014 16:12:03 -0500
From: Larry Finger <Larry.Finger@lwfinger.net>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org,
	Larry Finger <Larry.Finger@lwfinger.net>,
	netdev@vger.kernel.org, Stable <stable@vger.kernel.org>
Subject: [PATCH 3/3 V2] b43legacy: Fix unload oops if firmware is not available
Date: Sun, 12 Jan 2014 15:11:39 -0600
Message-Id: <1389561099-17181-4-git-send-email-Larry.Finger@lwfinger.net> (sfid-20140112_221218_433235_073A0F8E)
In-Reply-To: <1389561099-17181-1-git-send-email-Larry.Finger@lwfinger.net>
References: <1389561099-17181-1-git-send-email-Larry.Finger@lwfinger.net>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

The asyncronous firmware load uses a completion struct to hold firmware
processing until the user-space routines are up and running. There is.
however, a problem in that the waiter is nevered canceled during teardown.
As a result, unloading the driver when firmware is not available causes an oops.

Signed-off-by: Larry Finger <Larry.Finger@lwfinger.net>
Cc: Stable <stable@vger.kernel.org>
---
V2 - Addresses the comments of Ben Hutchings and removes the race condition.

 drivers/net/wireless/b43legacy/main.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/net/wireless/b43legacy/main.c b/drivers/net/wireless/b43legacy/main.c
index 5726688..349c776 100644
--- a/drivers/net/wireless/b43legacy/main.c
+++ b/drivers/net/wireless/b43legacy/main.c
@@ -3919,6 +3919,7 @@ static void b43legacy_remove(struct ssb_device *dev)
 	 * as the ieee80211 unreg will destroy the workqueue. */
 	cancel_work_sync(&wldev->restart_work);
 	cancel_work_sync(&wl->firmware_load);
+	complete(&wldev->fw_load_complete);
 
 	B43legacy_WARN_ON(!wl);
 	if (!wldev->fw.ucode)
-- 
1.8.4

