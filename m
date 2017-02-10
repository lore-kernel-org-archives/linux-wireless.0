Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wolverine02.qualcomm.com ([199.106.114.251]:45907 "EHLO
        wolverine02.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753486AbdBJU14 (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 10 Feb 2017 15:27:56 -0500
From: <ryanhsu@qca.qualcomm.com>
To: <ath10k@lists.infradead.org>, <linux-wireless@vger.kernel.org>
CC: <ryanhsu@qca.qualcomm.com>
Subject: [PATCH] ath10k: fix the garage chars in board file name creation
Date: Fri, 10 Feb 2017 12:27:09 -0800
Message-ID: <1486758429-18665-1-git-send-email-ryanhsu@qca.qualcomm.com> (sfid-20170210_212805_877911_CE55B78D)
MIME-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Ryan Hsu <ryanhsu@qca.qualcomm.com>

The variant[] string will be valid only if the bdf_ext is set.

The string memory needs to be null-terminated to avoid the undefined garbage
appended by the subsequent board file name creation.

ath10k_pci 0000:04:00.0: failed to fetch board data for
"bus=pci,vendor=168c,device=003e,subsystem-vendor=168c,subsystem-device=3363��P�����"
from ath10k/QCA6174/hw3.0/board-2.bin

Fixes: f2593cb1b291 ("ath10k: Search SMBIOS for OEM board file extension")
Reported-by: Kalle Valo <kvalo@qca.qualcomm.com>
Signed-off-by: Ryan Hsu <ryanhsu@qca.qualcomm.com>
---
 drivers/net/wireless/ath/ath10k/core.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/wireless/ath/ath10k/core.c b/drivers/net/wireless/ath/ath10k/core.c
index c27e7ea..014a87e 100644
--- a/drivers/net/wireless/ath/ath10k/core.c
+++ b/drivers/net/wireless/ath/ath10k/core.c
@@ -1122,7 +1122,7 @@ static int ath10k_core_create_board_name(struct ath10k *ar, char *name,
 					 size_t name_len)
 {
 	/* strlen(',variant=') + strlen(ar->id.bdf_ext) */
-	char variant[9 + ATH10K_SMBIOS_BDF_EXT_STR_LENGTH];
+	char variant[9 + ATH10K_SMBIOS_BDF_EXT_STR_LENGTH] = { 0 };
 
 	if (ar->id.bmi_ids_valid) {
 		scnprintf(name, name_len,
-- 
1.9.1
