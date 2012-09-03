Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wolverine01.qualcomm.com ([199.106.114.254]:20048 "EHLO
	wolverine01.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752208Ab2ICHUA (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 3 Sep 2012 03:20:00 -0400
From: Vasanthakumar Thiagarajan <vthiagar@qca.qualcomm.com>
To: <kvalo@qca.qualcomm.com>
CC: <linux-wireless@vger.kernel.org>, <ath6kl-devel@qualcomm.com>
Subject: [PATCH 1/4] ath6kl: Fix bug in scheduling hb_timer
Date: Mon, 3 Sep 2012 12:49:34 +0530
Message-ID: <1346656777-15197-1-git-send-email-vthiagar@qca.qualcomm.com> (sfid-20120903_092006_834051_5314C4E5)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

hb_timer should be scheduled only when hb_poll is non-zero.
But in ath6kl_recovery_work() the timer is scheduled based
on fw_recovery.enable instead which is wrong.

Signed-off-by: Vasanthakumar Thiagarajan <vthiagar@qca.qualcomm.com>
---
 drivers/net/wireless/ath/ath6kl/recovery.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/net/wireless/ath/ath6kl/recovery.c b/drivers/net/wireless/ath/ath6kl/recovery.c
index 03edeb8..c30df50 100644
--- a/drivers/net/wireless/ath/ath6kl/recovery.c
+++ b/drivers/net/wireless/ath/ath6kl/recovery.c
@@ -34,7 +34,7 @@ static void ath6kl_recovery_work(struct work_struct *work)
 
 	ar->fw_recovery.err_reason = 0;
 
-	if (ar->fw_recovery.enable)
+	if (ar->fw_recovery.hb_poll)
 		mod_timer(&ar->fw_recovery.hb_timer, jiffies +
 			  msecs_to_jiffies(ar->fw_recovery.hb_poll));
 }
-- 
1.7.0.4

