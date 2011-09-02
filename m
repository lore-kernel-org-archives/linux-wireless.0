Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wolverine02.qualcomm.com ([199.106.114.251]:26053 "EHLO
	wolverine02.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751836Ab1IBNqP (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 2 Sep 2011 09:46:15 -0400
From: Vasanthakumar Thiagarajan <vthiagar@qca.qualcomm.com>
To: <kvalo@qca.qualcomm.com>
CC: <linux-wireless@vger.kernel.org>
Subject: [PATCH 1/3] ath6kl: Make ath6kl_diag_write32() non-static
Date: Fri, 2 Sep 2011 19:16:11 +0530
Message-ID: <1314971173-8966-1-git-send-email-vthiagar@qca.qualcomm.com> (sfid-20110902_154618_901892_E752AC09)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

So that this can be called from debug.c when adding support
to write chip register.

Signed-off-by: Vasanthakumar Thiagarajan <vthiagar@qca.qualcomm.com>
---
 drivers/net/wireless/ath/ath6kl/core.h |    1 +
 drivers/net/wireless/ath/ath6kl/main.c |    2 +-
 2 files changed, 2 insertions(+), 1 deletions(-)

diff --git a/drivers/net/wireless/ath/ath6kl/core.h b/drivers/net/wireless/ath/ath6kl/core.h
index faf8015..e69cd5b 100644
--- a/drivers/net/wireless/ath/ath6kl/core.h
+++ b/drivers/net/wireless/ath/ath6kl/core.h
@@ -523,6 +523,7 @@ enum htc_send_full_action ath6kl_tx_queue_full(struct htc_target *target,
 					       struct htc_packet *packet);
 void ath6kl_stop_txrx(struct ath6kl *ar);
 void ath6kl_cleanup_amsdu_rxbufs(struct ath6kl *ar);
+int ath6kl_diag_write32(struct ath6kl *ar, u32 address, u32 value);
 int ath6kl_diag_write(struct ath6kl *ar, u32 address, void *data, u32 length);
 int ath6kl_diag_read32(struct ath6kl *ar, u32 address, u32 *value);
 int ath6kl_diag_read(struct ath6kl *ar, u32 address, void *data, u32 length);
diff --git a/drivers/net/wireless/ath/ath6kl/main.c b/drivers/net/wireless/ath/ath6kl/main.c
index bda14d1..48e9c2e 100644
--- a/drivers/net/wireless/ath/ath6kl/main.c
+++ b/drivers/net/wireless/ath/ath6kl/main.c
@@ -261,7 +261,7 @@ int ath6kl_diag_read32(struct ath6kl *ar, u32 address, u32 *value)
  * Write to the ATH6KL through its diagnostic window. No cooperation from
  * the Target is required for this.
  */
-static int ath6kl_diag_write32(struct ath6kl *ar, u32 address, u32 value)
+int ath6kl_diag_write32(struct ath6kl *ar, u32 address, u32 value)
 {
 	int ret;
 
-- 
1.7.0.4

