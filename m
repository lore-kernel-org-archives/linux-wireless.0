Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wolverine01.qualcomm.com ([199.106.114.254]:46201 "EHLO
	wolverine01.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752109Ab1IBNq0 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 2 Sep 2011 09:46:26 -0400
From: Vasanthakumar Thiagarajan <vthiagar@qca.qualcomm.com>
To: <kvalo@qca.qualcomm.com>
CC: <linux-wireless@vger.kernel.org>
Subject: [PATCH 2/3] ath6kl: Fix endianness in register write
Date: Fri, 2 Sep 2011 19:16:12 +0530
Message-ID: <1314971173-8966-2-git-send-email-vthiagar@qca.qualcomm.com> (sfid-20110902_154630_564493_2B7F6B8B)
In-Reply-To: <1314971173-8966-1-git-send-email-vthiagar@qca.qualcomm.com>
References: <1314971173-8966-1-git-send-email-vthiagar@qca.qualcomm.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Signed-off-by: Vasanthakumar Thiagarajan <vthiagar@qca.qualcomm.com>
---
 drivers/net/wireless/ath/ath6kl/core.h |    2 +-
 drivers/net/wireless/ath/ath6kl/main.c |   10 ++++++----
 2 files changed, 7 insertions(+), 5 deletions(-)

diff --git a/drivers/net/wireless/ath/ath6kl/core.h b/drivers/net/wireless/ath/ath6kl/core.h
index e69cd5b..ae2f591 100644
--- a/drivers/net/wireless/ath/ath6kl/core.h
+++ b/drivers/net/wireless/ath/ath6kl/core.h
@@ -523,7 +523,7 @@ enum htc_send_full_action ath6kl_tx_queue_full(struct htc_target *target,
 					       struct htc_packet *packet);
 void ath6kl_stop_txrx(struct ath6kl *ar);
 void ath6kl_cleanup_amsdu_rxbufs(struct ath6kl *ar);
-int ath6kl_diag_write32(struct ath6kl *ar, u32 address, u32 value);
+int ath6kl_diag_write32(struct ath6kl *ar, u32 address, __le32 value);
 int ath6kl_diag_write(struct ath6kl *ar, u32 address, void *data, u32 length);
 int ath6kl_diag_read32(struct ath6kl *ar, u32 address, u32 *value);
 int ath6kl_diag_read(struct ath6kl *ar, u32 address, void *data, u32 length);
diff --git a/drivers/net/wireless/ath/ath6kl/main.c b/drivers/net/wireless/ath/ath6kl/main.c
index 48e9c2e..3cefca6 100644
--- a/drivers/net/wireless/ath/ath6kl/main.c
+++ b/drivers/net/wireless/ath/ath6kl/main.c
@@ -261,7 +261,7 @@ int ath6kl_diag_read32(struct ath6kl *ar, u32 address, u32 *value)
  * Write to the ATH6KL through its diagnostic window. No cooperation from
  * the Target is required for this.
  */
-int ath6kl_diag_write32(struct ath6kl *ar, u32 address, u32 value)
+int ath6kl_diag_write32(struct ath6kl *ar, u32 address, __le32 value)
 {
 	int ret;
 
@@ -298,7 +298,8 @@ int ath6kl_diag_read(struct ath6kl *ar, u32 address, void *data, u32 length)
 
 int ath6kl_diag_write(struct ath6kl *ar, u32 address, void *data, u32 length)
 {
-	u32 count, *buf = data;
+	u32 count;
+	__le32 *buf = data;
 	int ret;
 
 	if (WARN_ON(length % 4))
@@ -397,13 +398,14 @@ static void ath6kl_reset_device(struct ath6kl *ar, u32 target_type,
 {
 	int status = 0;
 	u32 address;
-	u32 data;
+	__le32 data;
 
 	if (target_type != TARGET_TYPE_AR6003 &&
 		target_type != TARGET_TYPE_AR6004)
 		return;
 
-	data = cold_reset ? RESET_CONTROL_COLD_RST : RESET_CONTROL_MBOX_RST;
+	data = cold_reset ? cpu_to_le32(RESET_CONTROL_COLD_RST) :
+			    cpu_to_le32(RESET_CONTROL_MBOX_RST);
 
 	switch (target_type) {
 	case TARGET_TYPE_AR6003:
-- 
1.7.0.4

