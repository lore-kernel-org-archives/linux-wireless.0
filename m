Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from emh07.mail.saunalahti.fi ([62.142.5.117]:42157 "EHLO
	emh07.mail.saunalahti.fi" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755845Ab2CYOPm (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 25 Mar 2012 10:15:42 -0400
From: Kalle Valo <kvalo@qca.qualcomm.com>
To: kvalo@qca.qualcomm.com
Cc: linux-wireless@vger.kernel.org, ath6kl-devel@qualcomm.com
Subject: [PATCH v2 1/9] ath6kl: set ram reserved size only for ar6003
Date: Sun, 25 Mar 2012 17:15:21 +0300
Message-Id: <1332684929-6405-2-git-send-email-kvalo@qca.qualcomm.com> (sfid-20120325_161619_595598_201E58AB)
In-Reply-To: <1332684929-6405-1-git-send-email-kvalo@qca.qualcomm.com>
References: <1332684929-6405-1-git-send-email-kvalo@qca.qualcomm.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Ram reserved size is not needed with ar6004.

Signed-off-by: Kalle Valo <kvalo@qca.qualcomm.com>
---
 drivers/net/wireless/ath/ath6kl/init.c |   22 ++++++++++++----------
 1 files changed, 12 insertions(+), 10 deletions(-)

diff --git a/drivers/net/wireless/ath/ath6kl/init.c b/drivers/net/wireless/ath/ath6kl/init.c
index 03cae14..1b97f26 100644
--- a/drivers/net/wireless/ath/ath6kl/init.c
+++ b/drivers/net/wireless/ath/ath6kl/init.c
@@ -539,18 +539,20 @@ int ath6kl_configure_target(struct ath6kl *ar)
 	 * but possible in theory.
 	 */
 
-	param = ar->hw.board_ext_data_addr;
-	ram_reserved_size = ar->hw.reserved_ram_size;
+	if (ar->target_type == TARGET_TYPE_AR6003) {
+		param = ar->hw.board_ext_data_addr;
+		ram_reserved_size = ar->hw.reserved_ram_size;
 
-	if (ath6kl_bmi_write_hi32(ar, hi_board_ext_data, param) != 0) {
-		ath6kl_err("bmi_write_memory for hi_board_ext_data failed\n");
-		return -EIO;
-	}
+		if (ath6kl_bmi_write_hi32(ar, hi_board_ext_data, param) != 0) {
+			ath6kl_err("bmi_write_memory for hi_board_ext_data failed\n");
+			return -EIO;
+		}
 
-	if (ath6kl_bmi_write_hi32(ar, hi_end_ram_reserve_sz,
-				  ram_reserved_size) != 0) {
-		ath6kl_err("bmi_write_memory for hi_end_ram_reserve_sz failed\n");
-		return -EIO;
+		if (ath6kl_bmi_write_hi32(ar, hi_end_ram_reserve_sz,
+					  ram_reserved_size) != 0) {
+			ath6kl_err("bmi_write_memory for hi_end_ram_reserve_sz failed\n");
+			return -EIO;
+		}
 	}
 
 	/* set the block size for the target */
-- 
1.7.1

