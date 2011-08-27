Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-gw0-f46.google.com ([74.125.83.46]:43115 "EHLO
	mail-gw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751039Ab1H0S0S (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 27 Aug 2011 14:26:18 -0400
Received: by gwaa12 with SMTP id a12so3742882gwa.19
        for <linux-wireless@vger.kernel.org>; Sat, 27 Aug 2011 11:26:17 -0700 (PDT)
From: Larry Finger <Larry.Finger@lwfinger.net>
Cc: Larry Finger <Larry.Finger@lwfinger.net>,
	linux-wireless@vger.kernel.org
Subject: [PATCH] b43: Fix smatch warning
Date: Sat, 27 Aug 2011 13:26:00 -0500
Message-Id: <1314469560-28255-1-git-send-email-Larry.Finger@lwfinger.net> (sfid-20110827_202623_767222_ADBD0B9E)
To: linville@tuxdriver.com
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

  CHECK   drivers/net/wireless/b43/main.c
drivers/net/wireless/b43/main.c +4115 b43_wireless_core_stop(7) warn: variable dereferenced before check 'dev'

Signed-off-by: Larry Finger <Larry.Finger@lwfinger.net>
---

John,

This is next material.

Larry
---

 drivers/net/wireless/b43/main.c |    3 ++-
 1 files changed, 2 insertions(+), 1 deletions(-)

diff --git a/drivers/net/wireless/b43/main.c b/drivers/net/wireless/b43/main.c
index 0628901..2680684 100644
--- a/drivers/net/wireless/b43/main.c
+++ b/drivers/net/wireless/b43/main.c
@@ -4131,13 +4131,14 @@ out_unlock:
  * because the core might be gone away while we unlocked the mutex. */
 static struct b43_wldev * b43_wireless_core_stop(struct b43_wldev *dev)
 {
-	struct b43_wl *wl = dev->wl;
+	struct b43_wl *wl;
 	struct b43_wldev *orig_dev;
 	u32 mask;
 
 redo:
 	if (!dev || b43_status(dev) < B43_STAT_STARTED)
 		return dev;
+	wl = dev->wl;
 
 	/* Cancel work. Unlock to avoid deadlocks. */
 	mutex_unlock(&wl->mutex);
-- 
1.7.3.4

