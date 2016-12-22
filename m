Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wolverine02.qualcomm.com ([199.106.114.251]:60727 "EHLO
        wolverine02.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S933423AbcLVXDV (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 22 Dec 2016 18:03:21 -0500
From: <ryanhsu@qca.qualcomm.com>
To: <ath10k@lists.infradead.org>, <linux-wireless@vger.kernel.org>
CC: <ryanhsu@qca.qualcomm.com>
Subject: [PATCH] ath10k: ignore configuring the incorrect board_id
Date: Thu, 22 Dec 2016 15:02:37 -0800
Message-ID: <1482447757-23577-1-git-send-email-ryanhsu@qca.qualcomm.com> (sfid-20161223_000324_375825_E9764934)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Ryan Hsu <ryanhsu@qca.qualcomm.com>

With command to get board_id from otp, in the case of following

  boot get otp board id result 0x00000000 board_id 0 chip_id 0
  boot using board name 'bus=pci,bmi-chip-id=0,bmi-board-id=0"
  ...
  failed to fetch board data for bus=pci,bmi-chip-id=0,bmi-board-id=0 from
  ath10k/QCA6174/hw3.0/board-2.bin

The invalid board_id=0 will be used as index to search in the board-2.bin.

Ignore the case with board_id=0, as it means the otp is not carrying
the board id information.

Signed-off-by: Ryan Hsu <ryanhsu@qca.qualcomm.com>
---
 drivers/net/wireless/ath/ath10k/core.c | 5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

diff --git a/drivers/net/wireless/ath/ath10k/core.c b/drivers/net/wireless/ath/ath10k/core.c
index 749e381..1bf67ad 100644
--- a/drivers/net/wireless/ath/ath10k/core.c
+++ b/drivers/net/wireless/ath/ath10k/core.c
@@ -694,8 +694,11 @@ static int ath10k_core_get_board_id_from_otp(struct ath10k *ar)
 		   "boot get otp board id result 0x%08x board_id %d chip_id %d\n",
 		   result, board_id, chip_id);
 
-	if ((result & ATH10K_BMI_BOARD_ID_STATUS_MASK) != 0)
+	if ((result & ATH10K_BMI_BOARD_ID_STATUS_MASK) != 0 ||
+	    (board_id == 0)) {
+		ath10k_warn(ar, "board id is not exist in otp, ignore it\n");
 		return -EOPNOTSUPP;
+	}
 
 	ar->id.bmi_ids_valid = true;
 	ar->id.bmi_board_id = board_id;
-- 
1.9.1
