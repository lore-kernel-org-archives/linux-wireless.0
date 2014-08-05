Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail2.candelatech.com ([208.74.158.173]:36221 "EHLO
	mail2.candelatech.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753563AbaHEUti (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 5 Aug 2014 16:49:38 -0400
From: greearb@candelatech.com
To: linux-wireless@vger.kernel.org
Cc: ath10k@lists.infradead.org, Ben Greear <greearb@candelatech.com>
Subject: [PATCH] ath10k:  improve logging in firmware crash routine.
Date: Tue,  5 Aug 2014 13:49:32 -0700
Message-Id: <1407271772-14874-1-git-send-email-greearb@candelatech.com> (sfid-20140805_224947_724429_A15AA61D)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Ben Greear <greearb@candelatech.com>

Only print error message upon failure, and print more
details in case it does find an error.

Signed-off-by: Ben Greear <greearb@candelatech.com>
---

This is on top of the firmware crash reporting patches,
not sure it would apply clean until those get in.

 drivers/net/wireless/ath/ath10k/pci.c | 5 ++---
 1 file changed, 2 insertions(+), 3 deletions(-)

diff --git a/drivers/net/wireless/ath/ath10k/pci.c b/drivers/net/wireless/ath/ath10k/pci.c
index 24688b7..085c0c8 100644
--- a/drivers/net/wireless/ath/ath10k/pci.c
+++ b/drivers/net/wireless/ath/ath10k/pci.c
@@ -929,12 +929,11 @@ static void ath10k_pci_hif_dump_area(struct ath10k *ar)
 	ret = ath10k_pci_diag_read_mem(ar, host_addr,
 				       &reg_dump_area, sizeof(u32));
 	if (ret) {
-		ath10k_err("failed to read FW dump area address: %d\n", ret);
+		ath10k_err("failed to read FW dump area address: %d  (hostaddr 0x%08X  hi-failure-state 0x%08lX)\n",
+			   ret, host_addr, HI_ITEM(hi_failure_state));
 		goto exit;
 	}
 
-	ath10k_err("target register Dump Location: 0x%08X\n", reg_dump_area);
-
 	ret = ath10k_pci_diag_read_mem(ar, reg_dump_area,
 				       &reg_dump_values[0],
 				       REG_DUMP_COUNT_QCA988X * sizeof(u32));
-- 
1.7.11.7

