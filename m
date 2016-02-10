Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-qg0-f54.google.com ([209.85.192.54]:33569 "EHLO
	mail-qg0-f54.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753096AbcBJQ7O (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 10 Feb 2016 11:59:14 -0500
From: Anton Protopopov <a.s.protopopov@gmail.com>
To: Kalle Valo <kvalo@qca.qualcomm.com>
Cc: ath10k@lists.infradead.org, linux-wireless@vger.kernel.org,
	netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
	Anton Protopopov <a.s.protopopov@gmail.com>
Subject: [PATCH] ath10k: fix erroneous return value
Date: Wed, 10 Feb 2016 11:58:55 -0500
Message-Id: <1455123535-26751-1-git-send-email-a.s.protopopov@gmail.com> (sfid-20160210_180059_169983_2BA3C5DF)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

The ath10k_pci_hif_exchange_bmi_msg() function may return the positive
value EIO instead of -EIO in case of error.

Signed-off-by: Anton Protopopov <a.s.protopopov@gmail.com>
---
 drivers/net/wireless/ath/ath10k/pci.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/wireless/ath/ath10k/pci.c b/drivers/net/wireless/ath/ath10k/pci.c
index ee925c6..526acde 100644
--- a/drivers/net/wireless/ath/ath10k/pci.c
+++ b/drivers/net/wireless/ath/ath10k/pci.c
@@ -1756,7 +1756,7 @@ static int ath10k_pci_hif_exchange_bmi_msg(struct ath10k *ar,
 					    DMA_FROM_DEVICE);
 		ret = dma_mapping_error(ar->dev, resp_paddr);
 		if (ret) {
-			ret = EIO;
+			ret = -EIO;
 			goto err_req;
 		}
 
-- 
2.6.5

