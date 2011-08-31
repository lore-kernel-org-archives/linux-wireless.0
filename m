Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wolverine01.qualcomm.com ([199.106.114.254]:45027 "EHLO
	wolverine01.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752296Ab1HaKS0 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 31 Aug 2011 06:18:26 -0400
From: Vasanthakumar Thiagarajan <vthiagar@qca.qualcomm.com>
To: <kvalo@qca.qualcomm.com>
CC: <linux-wireless@vger.kernel.org>, <kvalo@adurom.com>
Subject: [PATCH 2/2] ath6kl: Fix endianness in requesting chip register read
Date: Wed, 31 Aug 2011 15:48:15 +0530
Message-ID: <1314785895-18808-2-git-send-email-vthiagar@qca.qualcomm.com> (sfid-20110831_121830_028475_98057E94)
In-Reply-To: <1314785895-18808-1-git-send-email-vthiagar@qca.qualcomm.com>
References: <1314785895-18808-1-git-send-email-vthiagar@qca.qualcomm.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Need to make sure the chip address for which we need the value
si endian safe.

Signed-off-by: Vasanthakumar Thiagarajan <vthiagar@qca.qualcomm.com>
---
 drivers/net/wireless/ath/ath6kl/main.c |   14 +++++++++-----
 1 files changed, 9 insertions(+), 5 deletions(-)

diff --git a/drivers/net/wireless/ath/ath6kl/main.c b/drivers/net/wireless/ath/ath6kl/main.c
index 0bcfd46..528a347 100644
--- a/drivers/net/wireless/ath/ath6kl/main.c
+++ b/drivers/net/wireless/ath/ath6kl/main.c
@@ -177,8 +177,8 @@ void ath6kl_free_cookie(struct ath6kl *ar, struct ath6kl_cookie *cookie)
 static int ath6kl_set_addrwin_reg(struct ath6kl *ar, u32 reg_addr, u32 addr)
 {
 	int status;
-	u8 addr_val[4];
 	s32 i;
+	__le32 addr_val;
 
 	/*
 	 * Write bytes 1,2,3 of the register to set the upper address bytes,
@@ -188,16 +188,18 @@ static int ath6kl_set_addrwin_reg(struct ath6kl *ar, u32 reg_addr, u32 addr)
 	for (i = 1; i <= 3; i++) {
 		/*
 		 * Fill the buffer with the address byte value we want to
-		 * hit 4 times.
+		 * hit 4 times. No need to worry about endianness as the
+		 * same byte is copied to all four bytes of addr_val at
+		 * any time.
 		 */
-		memset(addr_val, ((u8 *)&addr)[i], 4);
+		memset((u8 *)&addr_val, ((u8 *)&addr)[i], 4);
 
 		/*
 		 * Hit each byte of the register address with a 4-byte
 		 * write operation to the same address, this is a harmless
 		 * operation.
 		 */
-		status = hif_read_write_sync(ar, reg_addr + i, addr_val,
+		status = hif_read_write_sync(ar, reg_addr + i, (u8 *)&addr_val,
 					     4, HIF_WR_SYNC_BYTE_FIX);
 		if (status)
 			break;
@@ -215,7 +217,9 @@ static int ath6kl_set_addrwin_reg(struct ath6kl *ar, u32 reg_addr, u32 addr)
 	 * cycle to start, the extra 3 byte write to bytes 1,2,3 has no
 	 * effect since we are writing the same values again
 	 */
-	status = hif_read_write_sync(ar, reg_addr, (u8 *)(&addr),
+	addr_val = cpu_to_le32(addr);
+	status = hif_read_write_sync(ar, reg_addr,
+				     (u8 *)&(addr_val),
 				     4, HIF_WR_SYNC_BYTE_INC);
 
 	if (status) {
-- 
1.7.0.4

