Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wolverine02.qualcomm.com ([199.106.114.251]:56625 "EHLO
	wolverine02.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751271AbcCJEza (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 9 Mar 2016 23:55:30 -0500
From: Raja Mani <rmani@qti.qualcomm.com>
To: <ath10k@lists.infradead.org>
CC: <linux-wireless@vger.kernel.org>,
	Raja Mani <rmani@qti.qualcomm.com>
Subject: [PATCH] ath10k: free cached fw bin contents when get board id fails
Date: Thu, 10 Mar 2016 10:25:07 +0530
Message-ID: <1457585707-11344-1-git-send-email-rmani@qti.qualcomm.com> (sfid-20160310_055540_229999_D719CBA8)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

ath10k_core_probe_fw() simply returns error without freeing
cached firmware file content when get board id operation fails.
Free cached fw bin data in failure case to avoid memory leak.

Fixes: db0984e51a18 ("ath10k: select board data based on BMI chip id and board id")
Signed-off-by: Raja Mani <rmani@qti.qualcomm.com>
---
 drivers/net/wireless/ath/ath10k/core.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/wireless/ath/ath10k/core.c b/drivers/net/wireless/ath/ath10k/core.c
index 4d31764..a76d8ac 100644
--- a/drivers/net/wireless/ath/ath10k/core.c
+++ b/drivers/net/wireless/ath/ath10k/core.c
@@ -1833,7 +1833,7 @@ static int ath10k_core_probe_fw(struct ath10k *ar)
 	if (ret && ret != -EOPNOTSUPP) {
 		ath10k_err(ar, "failed to get board id from otp: %d\n",
 			   ret);
-		return ret;
+		goto err_free_firmware_files;
 	}
 
 	ret = ath10k_core_fetch_board_file(ar);
-- 
1.8.1.2

