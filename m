Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wolverine01.qualcomm.com ([199.106.114.254]:20758 "EHLO
	wolverine01.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753718Ab2ICHUc (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 3 Sep 2012 03:20:32 -0400
From: Vasanthakumar Thiagarajan <vthiagar@qca.qualcomm.com>
To: <kvalo@qca.qualcomm.com>
CC: <linux-wireless@vger.kernel.org>, <ath6kl-devel@qualcomm.com>
Subject: [PATCH 3/4] ath6kl: Add a bit to ath6kl_dev_state for recovery cleanup state
Date: Mon, 3 Sep 2012 12:49:36 +0530
Message-ID: <1346656777-15197-3-git-send-email-vthiagar@qca.qualcomm.com> (sfid-20120903_092035_559941_B3AEBE47)
In-Reply-To: <1346656777-15197-1-git-send-email-vthiagar@qca.qualcomm.com>
References: <1346656777-15197-1-git-send-email-vthiagar@qca.qualcomm.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Add a bit in ath6kl_dev_state to maintian the run time state
of firmware recovery configuration. This would help to have
user configuration in fw_recovery which will be added in
a separate patch.

Signed-off-by: Vasanthakumar Thiagarajan <vthiagar@qca.qualcomm.com>
---
 drivers/net/wireless/ath/ath6kl/core.h     |    2 +-
 drivers/net/wireless/ath/ath6kl/recovery.c |   12 +++++++-----
 2 files changed, 8 insertions(+), 6 deletions(-)

diff --git a/drivers/net/wireless/ath/ath6kl/core.h b/drivers/net/wireless/ath/ath6kl/core.h
index ac90b31..40a7b19 100644
--- a/drivers/net/wireless/ath/ath6kl/core.h
+++ b/drivers/net/wireless/ath/ath6kl/core.h
@@ -641,6 +641,7 @@ enum ath6kl_dev_state {
 	SKIP_SCAN,
 	ROAM_TBL_PEND,
 	FIRST_BOOT,
+	RECOVERY_CLEANUP,
 };
 
 enum ath6kl_state {
@@ -807,7 +808,6 @@ struct ath6kl {
 	bool wiphy_registered;
 
 	struct ath6kl_fw_recovery {
-		bool enable;
 		struct work_struct recovery_work;
 		unsigned long err_reason;
 		unsigned long hb_poll;
diff --git a/drivers/net/wireless/ath/ath6kl/recovery.c b/drivers/net/wireless/ath/ath6kl/recovery.c
index 1a82e8b..98b6aa0 100644
--- a/drivers/net/wireless/ath/ath6kl/recovery.c
+++ b/drivers/net/wireless/ath/ath6kl/recovery.c
@@ -46,7 +46,8 @@ void ath6kl_recovery_err_notify(struct ath6kl *ar, enum ath6kl_fw_err reason)
 
 	set_bit(reason, &ar->fw_recovery.err_reason);
 
-	if (ar->fw_recovery.enable && ar->state != ATH6KL_STATE_RECOVERY)
+	if (!test_bit(RECOVERY_CLEANUP, &ar->flag) &&
+	    ar->state != ATH6KL_STATE_RECOVERY)
 		queue_work(ar->ath6kl_wq, &ar->fw_recovery.recovery_work);
 }
 
@@ -61,7 +62,8 @@ static void ath6kl_recovery_hb_timer(unsigned long data)
 	struct ath6kl *ar = (struct ath6kl *) data;
 	int err;
 
-	if (!ar->fw_recovery.enable || (ar->state == ATH6KL_STATE_RECOVERY))
+	if (test_bit(RECOVERY_CLEANUP, &ar->flag) ||
+	    (ar->state == ATH6KL_STATE_RECOVERY))
 		return;
 
 	if (ar->fw_recovery.hb_pending)
@@ -94,7 +96,7 @@ void ath6kl_recovery_init(struct ath6kl *ar)
 {
 	struct ath6kl_fw_recovery *recovery = &ar->fw_recovery;
 
-	recovery->enable = true;
+	clear_bit(RECOVERY_CLEANUP, &ar->flag);
 	INIT_WORK(&recovery->recovery_work, ath6kl_recovery_work);
 	recovery->seq_num = 0;
 	recovery->hb_misscnt = 0;
@@ -110,7 +112,7 @@ void ath6kl_recovery_init(struct ath6kl *ar)
 
 void ath6kl_recovery_cleanup(struct ath6kl *ar)
 {
-	ar->fw_recovery.enable = false;
+	set_bit(RECOVERY_CLEANUP, &ar->flag);
 
 	del_timer_sync(&ar->fw_recovery.hb_timer);
 	cancel_work_sync(&ar->fw_recovery.recovery_work);
@@ -133,7 +135,7 @@ void ath6kl_recovery_suspend(struct ath6kl *ar)
 
 void ath6kl_recovery_resume(struct ath6kl *ar)
 {
-	ar->fw_recovery.enable = true;
+	clear_bit(RECOVERY_CLEANUP, &ar->flag);
 
 	if (!ar->fw_recovery.hb_poll)
 		return;
-- 
1.7.0.4

