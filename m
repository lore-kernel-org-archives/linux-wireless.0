Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-lpp01m010-f46.google.com ([209.85.215.46]:42482 "EHLO
	mail-lpp01m010-f46.google.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752433Ab2AKNWv (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 11 Jan 2012 08:22:51 -0500
Received: by lago2 with SMTP id o2so270957lag.19
        for <linux-wireless@vger.kernel.org>; Wed, 11 Jan 2012 05:22:50 -0800 (PST)
From: Pontus Fuchs <pontus.fuchs@gmail.com>
To: coelho@ti.com
Cc: linux-wireless@vger.kernel.org
Subject: [PATCH] wl12xx: Make sure HW is available in sched scan ops
Date: Wed, 11 Jan 2012 14:22:42 +0100
Message-Id: <1326288162-9113-1-git-send-email-pontus.fuchs@gmail.com> (sfid-20120111_142255_273049_85258F52)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

The sched_scan_(stop|start) ops fails to check for WL1271_STATE_OFF.
This can lead to a race where the driver tries to access the HW
while it's off.

Fix this by checking for WL1271_STATE_OFF before accessing the HW.

Signed-off-by: Pontus Fuchs <pontus.fuchs@gmail.com>
---
 drivers/net/wireless/wl12xx/main.c |    8 ++++++++
 1 files changed, 8 insertions(+), 0 deletions(-)

diff --git a/drivers/net/wireless/wl12xx/main.c b/drivers/net/wireless/wl12xx/main.c
index d5f55a1..915d56c 100644
--- a/drivers/net/wireless/wl12xx/main.c
+++ b/drivers/net/wireless/wl12xx/main.c
@@ -3105,6 +3105,11 @@ static int wl1271_op_sched_scan_start(struct ieee80211_hw *hw,
 
 	mutex_lock(&wl->mutex);
 
+	if (wl->state == WL1271_STATE_OFF) {
+		ret = -EAGAIN;
+		goto out;
+	}
+
 	ret = wl1271_ps_elp_wakeup(wl);
 	if (ret < 0)
 		goto out;
@@ -3136,6 +3141,9 @@ static void wl1271_op_sched_scan_stop(struct ieee80211_hw *hw,
 
 	mutex_lock(&wl->mutex);
 
+	if (wl->state == WL1271_STATE_OFF)
+		goto out;
+
 	ret = wl1271_ps_elp_wakeup(wl);
 	if (ret < 0)
 		goto out;
-- 
1.7.5.4

