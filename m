Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wolverine01.qualcomm.com ([199.106.114.254]:63230 "EHLO
	wolverine01.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752264Ab1HaKST (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 31 Aug 2011 06:18:19 -0400
From: Vasanthakumar Thiagarajan <vthiagar@qca.qualcomm.com>
To: <kvalo@qca.qualcomm.com>
CC: <linux-wireless@vger.kernel.org>, <kvalo@adurom.com>
Subject: [PATCH 1/2] ath6kl: Fix endianness with chip register values
Date: Wed, 31 Aug 2011 15:48:14 +0530
Message-ID: <1314785895-18808-1-git-send-email-vthiagar@qca.qualcomm.com> (sfid-20110831_121823_465711_6EAB9C67)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Signed-off-by: Vasanthakumar Thiagarajan <vthiagar@qca.qualcomm.com>
---
 drivers/net/wireless/ath/ath6kl/main.c |   14 ++++++++++----
 1 files changed, 10 insertions(+), 4 deletions(-)

diff --git a/drivers/net/wireless/ath/ath6kl/main.c b/drivers/net/wireless/ath/ath6kl/main.c
index 5e807a9..0bcfd46 100644
--- a/drivers/net/wireless/ath/ath6kl/main.c
+++ b/drivers/net/wireless/ath/ath6kl/main.c
@@ -234,6 +234,7 @@ static int ath6kl_set_addrwin_reg(struct ath6kl *ar, u32 reg_addr, u32 addr)
 int ath6kl_diag_read32(struct ath6kl *ar, u32 address, u32 *value)
 {
 	int ret;
+	__le32 reg_val = 0;
 
 	/* set window register to start read cycle */
 	ret = ath6kl_set_addrwin_reg(ar, WINDOW_READ_ADDR_ADDRESS, address);
@@ -241,8 +242,10 @@ int ath6kl_diag_read32(struct ath6kl *ar, u32 address, u32 *value)
 		return ret;
 
 	/* read the data */
-	ret = hif_read_write_sync(ar, WINDOW_DATA_ADDRESS, (u8 *) value,
-				  sizeof(*value), HIF_RD_SYNC_BYTE_INC);
+	ret = hif_read_write_sync(ar, WINDOW_DATA_ADDRESS, (u8 *) &reg_val,
+				  sizeof(reg_val), HIF_RD_SYNC_BYTE_INC);
+	*value = le32_to_cpu(reg_val);
+
 	if (ret) {
 		ath6kl_warn("failed to read32 through diagnose window: %d\n",
 			    ret);
@@ -259,10 +262,13 @@ int ath6kl_diag_read32(struct ath6kl *ar, u32 address, u32 *value)
 static int ath6kl_diag_write32(struct ath6kl *ar, u32 address, u32 value)
 {
 	int ret;
+	__le32 reg_val;
+
+	reg_val = cpu_to_le32(value);
 
 	/* set write data */
-	ret = hif_read_write_sync(ar, WINDOW_DATA_ADDRESS, (u8 *) &value,
-				  sizeof(value), HIF_WR_SYNC_BYTE_INC);
+	ret = hif_read_write_sync(ar, WINDOW_DATA_ADDRESS, (u8 *) &reg_val,
+				  sizeof(reg_val), HIF_WR_SYNC_BYTE_INC);
 	if (ret) {
 		ath6kl_err("failed to write 0x%x during diagnose window to 0x%d\n",
 			   address, value);
-- 
1.7.0.4

