Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wolverine01.qualcomm.com ([199.106.114.254]:22642 "EHLO
	wolverine01.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753660Ab2H2OLN (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 29 Aug 2012 10:11:13 -0400
From: Vasanthakumar Thiagarajan <vthiagar@qca.qualcomm.com>
To: <kvalo@qca.qualcomm.com>
CC: <linux-wireless@vger.kernel.org>, <ath6kl-devel@qualcomm.com>
Subject: [PATCH 4/4] ath6kl: Recover from "wmi ctrl ep is full" condition
Date: Wed, 29 Aug 2012 19:40:28 +0530
Message-ID: <1346249428-24741-4-git-send-email-vthiagar@qca.qualcomm.com> (sfid-20120829_161123_231449_C489A5F0)
In-Reply-To: <1346249428-24741-1-git-send-email-vthiagar@qca.qualcomm.com>
References: <1346249428-24741-1-git-send-email-vthiagar@qca.qualcomm.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

In some error conditions, fw pauses HTC pipes which would
result in control endpoint full condition. When we hit this
case, most of the time the device will be unusable. Re-initialize
the target to recover from this situation.

Signed-off-by: Vasanthakumar Thiagarajan <vthiagar@qca.qualcomm.com>
---
 drivers/net/wireless/ath/ath6kl/core.h     |    1 +
 drivers/net/wireless/ath/ath6kl/recovery.c |    2 ++
 drivers/net/wireless/ath/ath6kl/txrx.c     |    1 +
 3 files changed, 4 insertions(+), 0 deletions(-)

diff --git a/drivers/net/wireless/ath/ath6kl/core.h b/drivers/net/wireless/ath/ath6kl/core.h
index b2cbecf..ac90b31 100644
--- a/drivers/net/wireless/ath/ath6kl/core.h
+++ b/drivers/net/wireless/ath/ath6kl/core.h
@@ -660,6 +660,7 @@ enum ath6kl_state {
 enum ath6kl_fw_err {
 	ATH6KL_FW_ASSERT,
 	ATH6KL_FW_HB_RESP_FAILURE,
+	ATH6KL_FW_EP_FULL,
 };
 
 struct ath6kl {
diff --git a/drivers/net/wireless/ath/ath6kl/recovery.c b/drivers/net/wireless/ath/ath6kl/recovery.c
index 9161d84..26e0816 100644
--- a/drivers/net/wireless/ath/ath6kl/recovery.c
+++ b/drivers/net/wireless/ath/ath6kl/recovery.c
@@ -30,6 +30,8 @@ static void ath6kl_recovery_work(struct work_struct *work)
 	ath6kl_init_hw_restart(ar);
 
 	ar->state = ATH6KL_STATE_ON;
+	clear_bit(WMI_CTRL_EP_FULL, &ar->flag);
+
 	ar->fw_recovery.err_reason = 0;
 
 	if (ar->fw_recovery.enable)
diff --git a/drivers/net/wireless/ath/ath6kl/txrx.c b/drivers/net/wireless/ath/ath6kl/txrx.c
index cbe1a9d..e867193 100644
--- a/drivers/net/wireless/ath/ath6kl/txrx.c
+++ b/drivers/net/wireless/ath/ath6kl/txrx.c
@@ -594,6 +594,7 @@ enum htc_send_full_action ath6kl_tx_queue_full(struct htc_target *target,
 		 */
 		set_bit(WMI_CTRL_EP_FULL, &ar->flag);
 		ath6kl_err("wmi ctrl ep is full\n");
+		ath6kl_recovery_err_notify(ar, ATH6KL_FW_EP_FULL);
 		return action;
 	}
 
-- 
1.7.0.4

