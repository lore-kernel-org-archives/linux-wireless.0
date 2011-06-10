Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ww0-f44.google.com ([74.125.82.44]:41063 "EHLO
	mail-ww0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753437Ab1FJHsn (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 10 Jun 2011 03:48:43 -0400
Received: by wwa36 with SMTP id 36so2492123wwa.1
        for <linux-wireless@vger.kernel.org>; Fri, 10 Jun 2011 00:48:42 -0700 (PDT)
From: Eliad Peller <eliad@wizery.com>
To: Luciano Coelho <coelho@ti.com>
Cc: <linux-wireless@vger.kernel.org>
Subject: [PATCH 1/3] wl12xx: configure suspend/resume only if associated/started
Date: Fri, 10 Jun 2011 10:49:17 +0300
Message-Id: <1307692159-11055-1-git-send-email-eliad@wizery.com> (sfid-20110610_094847_146804_4D473AE1)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Configure the device (to wowlan) only if the sta/ap
is associated/started.

Signed-off-by: Eliad Peller <eliad@wizery.com>
---
 drivers/net/wireless/wl12xx/main.c |   10 ++++++++--
 1 files changed, 8 insertions(+), 2 deletions(-)

diff --git a/drivers/net/wireless/wl12xx/main.c b/drivers/net/wireless/wl12xx/main.c
index 2c2251a..7017c23 100644
--- a/drivers/net/wireless/wl12xx/main.c
+++ b/drivers/net/wireless/wl12xx/main.c
@@ -1469,10 +1469,13 @@ static struct notifier_block wl1271_dev_notifier = {
 
 static int wl1271_configure_suspend_sta(struct wl1271 *wl)
 {
-	int ret;
+	int ret = 0;
 
 	mutex_lock(&wl->mutex);
 
+	if (!test_bit(WL1271_FLAG_STA_ASSOCIATED, &wl->flags))
+		goto out_unlock;
+
 	ret = wl1271_ps_elp_wakeup(wl);
 	if (ret < 0)
 		goto out_unlock;
@@ -1517,10 +1520,13 @@ out:
 
 static int wl1271_configure_suspend_ap(struct wl1271 *wl)
 {
-	int ret;
+	int ret = 0;
 
 	mutex_lock(&wl->mutex);
 
+	if (!test_bit(WL1271_FLAG_AP_STARTED, &wl->flags))
+		goto out_unlock;
+
 	ret = wl1271_ps_elp_wakeup(wl);
 	if (ret < 0)
 		goto out_unlock;
-- 
1.7.0.4

