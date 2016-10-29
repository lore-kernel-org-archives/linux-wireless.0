Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wolverine02.qualcomm.com ([199.106.114.251]:12629 "EHLO
        wolverine02.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751512AbcJ2Fvr (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Sat, 29 Oct 2016 01:51:47 -0400
From: Maya Erez <qca_merez@qca.qualcomm.com>
To: Kalle Valo <kvalo@codeaurora.org>
Cc: Lior David <qca_liord@qca.qualcomm.com>,
        linux-wireless@vger.kernel.org, wil6210@qca.qualcomm.com,
        Maya Erez <qca_merez@qca.qualcomm.com>
Subject: [PATCH 3/7] wil6210: fix deadlock when using fw_no_recovery option
Date: Sat, 29 Oct 2016 08:51:23 +0300
Message-Id: <1477720287-17606-4-git-send-email-qca_merez@qca.qualcomm.com> (sfid-20161029_075152_925085_E0E2C382)
In-Reply-To: <1477720287-17606-1-git-send-email-qca_merez@qca.qualcomm.com>
References: <1477720287-17606-1-git-send-email-qca_merez@qca.qualcomm.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Lior David <qca_liord@qca.qualcomm.com>

When FW crashes with no_fw_recovery option, driver
waits for manual recovery with wil->mutex held, this
can easily create deadlocks.
Fix the problem by moving the wait outside the lock.

Signed-off-by: Lior David <qca_liord@qca.qualcomm.com>
Signed-off-by: Maya Erez <qca_merez@qca.qualcomm.com>
---
 drivers/net/wireless/ath/wil6210/main.c | 15 ++++++++-------
 1 file changed, 8 insertions(+), 7 deletions(-)

diff --git a/drivers/net/wireless/ath/wil6210/main.c b/drivers/net/wireless/ath/wil6210/main.c
index b04ff87..a9bbd0b 100644
--- a/drivers/net/wireless/ath/wil6210/main.c
+++ b/drivers/net/wireless/ath/wil6210/main.c
@@ -388,18 +388,19 @@ static void wil_fw_error_worker(struct work_struct *work)
 
 	wil->last_fw_recovery = jiffies;
 
+	wil_info(wil, "fw error recovery requested (try %d)...\n",
+		 wil->recovery_count);
+	if (!no_fw_recovery)
+		wil->recovery_state = fw_recovery_running;
+	if (wil_wait_for_recovery(wil) != 0)
+		return;
+
 	mutex_lock(&wil->mutex);
 	switch (wdev->iftype) {
 	case NL80211_IFTYPE_STATION:
 	case NL80211_IFTYPE_P2P_CLIENT:
 	case NL80211_IFTYPE_MONITOR:
-		wil_info(wil, "fw error recovery requested (try %d)...\n",
-			 wil->recovery_count);
-		if (!no_fw_recovery)
-			wil->recovery_state = fw_recovery_running;
-		if (0 != wil_wait_for_recovery(wil))
-			break;
-
+		/* silent recovery, upper layers will see disconnect */
 		__wil_down(wil);
 		__wil_up(wil);
 		break;
-- 
1.9.1
