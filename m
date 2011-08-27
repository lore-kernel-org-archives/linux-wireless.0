Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-gy0-f174.google.com ([209.85.160.174]:50376 "EHLO
	mail-gy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751439Ab1H0UyK (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 27 Aug 2011 16:54:10 -0400
Received: by gya6 with SMTP id 6so3783791gya.19
        for <linux-wireless@vger.kernel.org>; Sat, 27 Aug 2011 13:54:09 -0700 (PDT)
From: Larry Finger <Larry.Finger@lwfinger.net>
Cc: Larry Finger <Larry.Finger@lwfinger.net>,
	linux-wireless@vger.kernel.org
Subject: [PATCH V2] b43: Fix swatch warning
Date: Sat, 27 Aug 2011 15:53:42 -0500
Message-Id: <1314478422-11429-1-git-send-email-Larry.Finger@lwfinger.net> (sfid-20110827_225437_362095_3E45C5D3)
To: linville@tuxdriver.com
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Swatch reports the following warning for main.c:

  CHECK   drivers/net/wireless/b43/main.c
drivers/net/wireless/b43/main.c +4115 b43_wireless_core_stop(7) warn: variable dereferenced before check 'dev'

After analysis, this is not a bug, but a false warning. Nonetheless,
a cleanup is in order to prevent some future janitor proposing
the wrong fix, as I did in my original patch.

Signed-off-by: Larry Finger <Larry.Finger@lwfinger.net>
---
V2 - Fix the warning without introducing a bug.

John,

As this is not a bug, please consider it for next.

Larry
---

 drivers/net/wireless/b43/main.c |    5 ++++-
 1 files changed, 4 insertions(+), 1 deletions(-)

diff --git a/drivers/net/wireless/b43/main.c b/drivers/net/wireless/b43/main.c
index 0628901..517be17 100644
--- a/drivers/net/wireless/b43/main.c
+++ b/drivers/net/wireless/b43/main.c
@@ -4131,10 +4131,13 @@ out_unlock:
  * because the core might be gone away while we unlocked the mutex. */
 static struct b43_wldev * b43_wireless_core_stop(struct b43_wldev *dev)
 {
-	struct b43_wl *wl = dev->wl;
+	struct b43_wl *wl;
 	struct b43_wldev *orig_dev;
 	u32 mask;
 
+	if (!dev)
+		return NULL;
+	wl = dev->wl;
 redo:
 	if (!dev || b43_status(dev) < B43_STAT_STARTED)
 		return dev;
-- 
1.7.3.4

