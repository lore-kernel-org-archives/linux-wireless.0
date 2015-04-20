Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-lb0-f172.google.com ([209.85.217.172]:32991 "EHLO
	mail-lb0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754247AbbDTJ1E (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 20 Apr 2015 05:27:04 -0400
Received: by lbbzk7 with SMTP id zk7so125832231lbb.0
        for <linux-wireless@vger.kernel.org>; Mon, 20 Apr 2015 02:27:03 -0700 (PDT)
From: Michal Kazior <michal.kazior@tieto.com>
To: ath10k@lists.infradead.org
Cc: linux-wireless@vger.kernel.org,
	Michal Kazior <michal.kazior@tieto.com>
Subject: [PATCH] ath10k: fix qca61x4 hw2.1 support
Date: Mon, 20 Apr 2015 09:20:41 +0000
Message-Id: <1429521641-21993-1-git-send-email-michal.kazior@tieto.com> (sfid-20150420_112712_026900_3180F6E5)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

During initialization firmware does some sort of
memory switch between DRAM and IRAM. If
configuration value for bank switching isn't
correct device crashes during init.

The new value prevents firmware 11.0.0.302 (and
possibly others) for qca61x4 hw2.1 from crashing
during init.

Signed-off-by: Michal Kazior <michal.kazior@tieto.com>
---
 drivers/net/wireless/ath/ath10k/pci.c | 5 ++---
 1 file changed, 2 insertions(+), 3 deletions(-)

diff --git a/drivers/net/wireless/ath/ath10k/pci.c b/drivers/net/wireless/ath/ath10k/pci.c
index 262a84f67f62..b1e522ccb525 100644
--- a/drivers/net/wireless/ath/ath10k/pci.c
+++ b/drivers/net/wireless/ath/ath10k/pci.c
@@ -1539,12 +1539,11 @@ static int ath10k_pci_get_num_banks(struct ath10k *ar)
 		switch (MS(ar->chip_id, SOC_CHIP_ID_REV)) {
 		case QCA6174_HW_1_0_CHIP_ID_REV:
 		case QCA6174_HW_1_1_CHIP_ID_REV:
+		case QCA6174_HW_2_1_CHIP_ID_REV:
+		case QCA6174_HW_2_2_CHIP_ID_REV:
 			return 3;
 		case QCA6174_HW_1_3_CHIP_ID_REV:
 			return 2;
-		case QCA6174_HW_2_1_CHIP_ID_REV:
-		case QCA6174_HW_2_2_CHIP_ID_REV:
-			return 6;
 		case QCA6174_HW_3_0_CHIP_ID_REV:
 		case QCA6174_HW_3_1_CHIP_ID_REV:
 		case QCA6174_HW_3_2_CHIP_ID_REV:
-- 
2.1.4

