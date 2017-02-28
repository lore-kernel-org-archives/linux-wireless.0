Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from youngberry.canonical.com ([91.189.89.112]:45252 "EHLO
        youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751497AbdB1LwS (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 28 Feb 2017 06:52:18 -0500
From: Colin King <colin.king@canonical.com>
To: Kalle Valo <kvalo@qca.qualcomm.com>, ath10k@lists.infradead.org,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org
Cc: kernel-janitors@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH] ath10k: remove redundant error check
Date: Tue, 28 Feb 2017 11:14:39 +0000
Message-Id: <20170228111439.19546-1-colin.king@canonical.com> (sfid-20170228_125309_498658_93031159)
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Colin Ian King <colin.king@canonical.com>

The check on ret for an error is redundant because it is already been
checked for non-zero earlier on and ret is never non-zero at this point.
Fix this by removing the redundant check and error message.

Detected by CoverityScan, CID#1357170 ("Logically Dead Code")

Signed-off-by: Colin Ian King <colin.king@canonical.com>
---
 drivers/net/wireless/ath/ath10k/pci.c | 6 ------
 1 file changed, 6 deletions(-)

diff --git a/drivers/net/wireless/ath/ath10k/pci.c b/drivers/net/wireless/ath/ath10k/pci.c
index 6094372..52896c2 100644
--- a/drivers/net/wireless/ath/ath10k/pci.c
+++ b/drivers/net/wireless/ath/ath10k/pci.c
@@ -970,12 +970,6 @@ static int ath10k_pci_diag_read_mem(struct ath10k *ar, u32 address, void *data,
 		}
 
 		remaining_bytes -= nbytes;
-
-		if (ret) {
-			ath10k_warn(ar, "failed to read diag value at 0x%x: %d\n",
-				    address, ret);
-			break;
-		}
 		memcpy(data, data_buf, nbytes);
 
 		address += nbytes;
-- 
2.10.2
