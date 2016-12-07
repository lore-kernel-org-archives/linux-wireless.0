Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wm0-f49.google.com ([74.125.82.49]:36376 "EHLO
        mail-wm0-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S932192AbcLGRIM (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 7 Dec 2016 12:08:12 -0500
Received: by mail-wm0-f49.google.com with SMTP id g23so177904871wme.1
        for <linux-wireless@vger.kernel.org>; Wed, 07 Dec 2016 09:08:11 -0800 (PST)
From: Bartosz Markowski <bartosz.markowski@tieto.com>
To: ath10k@lists.infradead.org
Cc: linux-wireless@vger.kernel.org,
        Bartosz Markowski <bartosz.markowski@tieto.com>
Subject: [PATCH 1/5] ath10k: fix IRAM banks number for QCA9377
Date: Wed,  7 Dec 2016 18:07:30 +0100
Message-Id: <1481130454-27244-1-git-send-email-bartosz.markowski@tieto.com> (sfid-20161207_180815_776042_24AF00BC)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

QCA9377 firmware shall alloc 4 IRAM banks

Signed-off-by: Bartosz Markowski <bartosz.markowski@tieto.com>
---
 drivers/net/wireless/ath/ath10k/pci.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/wireless/ath/ath10k/pci.c b/drivers/net/wireless/ath/ath10k/pci.c
index 0457e315d336..983f65bbb7fb 100644
--- a/drivers/net/wireless/ath/ath10k/pci.c
+++ b/drivers/net/wireless/ath/ath10k/pci.c
@@ -1973,7 +1973,7 @@ static int ath10k_pci_get_num_banks(struct ath10k *ar)
 		}
 		break;
 	case QCA9377_1_0_DEVICE_ID:
-		return 2;
+		return 4;
 	}
 
 	ath10k_warn(ar, "unknown number of banks, assuming 1\n");
-- 
2.1.2
