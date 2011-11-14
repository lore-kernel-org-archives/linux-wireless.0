Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from emh07.mail.saunalahti.fi ([62.142.5.117]:51191 "EHLO
	emh07.mail.saunalahti.fi" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753660Ab1KNRan (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 14 Nov 2011 12:30:43 -0500
Subject: [PATCH 03/10] ath6kl: add board address to struct ath6kl_hw
To: kvalo@qca.qualcomm.com
From: Kalle Valo <kvalo@qca.qualcomm.com>
Cc: linux-wireless@vger.kernel.org
Date: Mon, 14 Nov 2011 19:30:39 +0200
Message-ID: <20111114173039.29925.47227.stgit@localhost6.localdomain6> (sfid-20111114_183045_437793_AC8C7520)
In-Reply-To: <20111114172836.29925.4134.stgit@localhost6.localdomain6>
References: <20111114172836.29925.4134.stgit@localhost6.localdomain6>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This is to make it configurable by firmware IEs. Also determine if we need
to write or read the board address to the chip by checking if board address
is set or not.

Signed-off-by: Kalle Valo <kvalo@qca.qualcomm.com>
---
 drivers/net/wireless/ath/ath6kl/core.h   |    1 +
 drivers/net/wireless/ath/ath6kl/init.c   |   10 ++++------
 drivers/net/wireless/ath/ath6kl/target.h |    3 ---
 3 files changed, 5 insertions(+), 9 deletions(-)

diff --git a/drivers/net/wireless/ath/ath6kl/core.h b/drivers/net/wireless/ath/ath6kl/core.h
index f5a8334..83167be 100644
--- a/drivers/net/wireless/ath/ath6kl/core.h
+++ b/drivers/net/wireless/ath/ath6kl/core.h
@@ -548,6 +548,7 @@ struct ath6kl {
 		u32 app_start_override_addr;
 		u32 board_ext_data_addr;
 		u32 reserved_ram_size;
+		u32 board_addr;
 	} hw;
 
 	u16 conf_flags;
diff --git a/drivers/net/wireless/ath/ath6kl/init.c b/drivers/net/wireless/ath/ath6kl/init.c
index 77444d1..bed468d 100644
--- a/drivers/net/wireless/ath/ath6kl/init.c
+++ b/drivers/net/wireless/ath/ath6kl/init.c
@@ -57,6 +57,7 @@ static const struct ath6kl_hw hw_list[] = {
 		.app_load_addr			= 0x1234,
 		.board_ext_data_addr		= 0x437000,
 		.reserved_ram_size		= 19456,
+		.board_addr			= 0x433900,
 	},
 	{
 		.id				= AR6004_REV2_VERSION,
@@ -64,6 +65,7 @@ static const struct ath6kl_hw hw_list[] = {
 		.app_load_addr			= 0x1234,
 		.board_ext_data_addr		= 0x437000,
 		.reserved_ram_size		= 11264,
+		.board_addr			= 0x43d400,
 	},
 };
 
@@ -1031,12 +1033,8 @@ static int ath6kl_upload_board_file(struct ath6kl *ar)
 	 * For AR6004, host determine Target RAM address for
 	 * writing board data.
 	 */
-	if (ar->target_type == TARGET_TYPE_AR6004) {
-		if (ar->version.target_ver == AR6004_REV1_VERSION)
-			board_address = AR6004_REV1_BOARD_DATA_ADDRESS;
-		else
-			board_address = AR6004_REV2_BOARD_DATA_ADDRESS;
-
+	if (ar->hw.board_addr != 0) {
+		board_address = ar->hw.board_addr;
 		ath6kl_bmi_write(ar,
 				ath6kl_get_hi_item_addr(ar,
 				HI_ITEM(hi_board_data)),
diff --git a/drivers/net/wireless/ath/ath6kl/target.h b/drivers/net/wireless/ath/ath6kl/target.h
index ece0f13..108a723 100644
--- a/drivers/net/wireless/ath/ath6kl/target.h
+++ b/drivers/net/wireless/ath/ath6kl/target.h
@@ -334,9 +334,6 @@ struct host_interest {
 	(((target_type) == TARGET_TYPE_AR6003) ? AR6003_VTOP(vaddr) : \
 	(((target_type) == TARGET_TYPE_AR6004) ? AR6004_VTOP(vaddr) : 0))
 
-#define AR6004_REV1_BOARD_DATA_ADDRESS          0x433900
-#define AR6004_REV2_BOARD_DATA_ADDRESS          0x43d400
-
 #define ATH6KL_FWLOG_PAYLOAD_SIZE		1500
 
 struct ath6kl_dbglog_buf {

