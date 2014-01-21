Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pd0-f169.google.com ([209.85.192.169]:54514 "EHLO
	mail-pd0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753624AbaAUJVg (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 21 Jan 2014 04:21:36 -0500
Received: by mail-pd0-f169.google.com with SMTP id v10so7972682pde.28
        for <linux-wireless@vger.kernel.org>; Tue, 21 Jan 2014 01:21:36 -0800 (PST)
From: Chun-Yeow Yeoh <yeohchunyeow@gmail.com>
To: ath10k@lists.infradead.org
Cc: linux-wireless@vger.kernel.org, kvalo@qca.qualcomm.com,
	Chun-Yeow Yeoh <yeohchunyeow@gmail.com>
Subject: [PATCH] ath10k: fix the printing of 10.x FW version when FW crashed
Date: Tue, 21 Jan 2014 17:21:21 +0800
Message-Id: <1390296081-22788-1-git-send-email-yeohchunyeow@gmail.com> (sfid-20140121_102141_550701_DB0E9AAE)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

10.x FW has no structure member sw_version_1. Thus,
both fw_version_release and fw_version_build are not
available. The provided fw_version_major is also wrong.
Fix this by using the fw_version from struct wiphy.

Signed-off-by: Chun-Yeow Yeoh <yeohchunyeow@gmail.com>
---
 drivers/net/wireless/ath/ath10k/pci.c |    4 +---
 1 file changed, 1 insertion(+), 3 deletions(-)

diff --git a/drivers/net/wireless/ath/ath10k/pci.c b/drivers/net/wireless/ath/ath10k/pci.c
index 29fd197..9179c88 100644
--- a/drivers/net/wireless/ath/ath10k/pci.c
+++ b/drivers/net/wireless/ath/ath10k/pci.c
@@ -833,9 +833,7 @@ static void ath10k_pci_hif_dump_area(struct ath10k *ar)
 	ath10k_err("firmware crashed!\n");
 	ath10k_err("hardware name %s version 0x%x\n",
 		   ar->hw_params.name, ar->target_version);
-	ath10k_err("firmware version: %u.%u.%u.%u\n", ar->fw_version_major,
-		   ar->fw_version_minor, ar->fw_version_release,
-		   ar->fw_version_build);
+	ath10k_err("firmware version: %s\n", ar->hw->wiphy->fw_version);
 
 	host_addr = host_interest_item_address(HI_ITEM(hi_failure_state));
 	ret = ath10k_pci_diag_read_mem(ar, host_addr,
-- 
1.7.9.5

