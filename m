Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from youngberry.canonical.com ([91.189.89.112]:34221 "EHLO
        youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S933808AbeALR1T (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 12 Jan 2018 12:27:19 -0500
From: Colin King <colin.king@canonical.com>
To: Kalle Valo <kvalo@qca.qualcomm.com>, ath10k@lists.infradead.org,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org
Cc: kernel-janitors@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH] ath10k: remove redundant -ve check against u32 integer size
Date: Fri, 12 Jan 2018 17:27:13 +0000
Message-Id: <20180112172713.28252-1-colin.king@canonical.com> (sfid-20180112_182936_506136_F57FE12D)
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Colin Ian King <colin.king@canonical.com>

Variable section_table.size is a u32 and so cannot be less than
zero, hence the less than zero check is redundant and can be
removed.

Detected by CoverityScan, CID#1463855 ("Unsigned compared against 0")

Signed-off-by: Colin Ian King <colin.king@canonical.com>
---
 drivers/net/wireless/ath/ath10k/pci.c | 3 ---
 1 file changed, 3 deletions(-)

diff --git a/drivers/net/wireless/ath/ath10k/pci.c b/drivers/net/wireless/ath/ath10k/pci.c
index f6a23f2d0335..355db6a0fcf3 100644
--- a/drivers/net/wireless/ath/ath10k/pci.c
+++ b/drivers/net/wireless/ath/ath10k/pci.c
@@ -1478,9 +1478,6 @@ static int ath10k_pci_dump_memory_section(struct ath10k *ar,
 	if (!mem_region || !buf)
 		return 0;
 
-	if (mem_region->section_table.size < 0)
-		return 0;
-
 	cur_section = &mem_region->section_table.sections[0];
 
 	if (mem_region->start > cur_section->start) {
-- 
2.15.1
