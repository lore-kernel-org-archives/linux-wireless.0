Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.codeaurora.org ([198.145.29.96]:43842 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726982AbeITKqE (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 20 Sep 2018 06:46:04 -0400
From: Govind Singh <govinds@codeaurora.org>
To: ath10k@lists.infradead.org
Cc: linux-wireless@vger.kernel.org,
        Govind Singh <govinds@codeaurora.org>
Subject: [PATCH 1/2] ath10k: Move napi_enable to hif_start for consistent pairing
Date: Thu, 20 Sep 2018 10:34:25 +0530
Message-Id: <20180920050426.4113-1-govinds@codeaurora.org> (sfid-20180920_070437_036336_27B3FC0A)
MIME-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

There is unbalanced napi_{enable,disable}() behavior as they
are being called from hif_snoc_{power_up/stop).

The fix is to call napi_enable() from ath10k_snoc_hif_start()
so that it matches with napi_disable() being called from
ath10k_snoc_hif_stop().

Signed-off-by: Govind Singh <govinds@codeaurora.org>
---
 drivers/net/wireless/ath/ath10k/snoc.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/wireless/ath/ath10k/snoc.c b/drivers/net/wireless/ath/ath10k/snoc.c
index ed52a6308f76..dd043b858c8e 100644
--- a/drivers/net/wireless/ath/ath10k/snoc.c
+++ b/drivers/net/wireless/ath/ath10k/snoc.c
@@ -919,6 +919,7 @@ static void ath10k_snoc_hif_stop(struct ath10k *ar)
 
 static int ath10k_snoc_hif_start(struct ath10k *ar)
 {
+	napi_enable(&ar->napi);
 	ath10k_snoc_irq_enable(ar);
 	ath10k_snoc_rx_post(ar);
 
@@ -1017,7 +1018,6 @@ static int ath10k_snoc_hif_power_up(struct ath10k *ar)
 		goto err_wlan_enable;
 	}
 
-	napi_enable(&ar->napi);
 	return 0;
 
 err_wlan_enable:
-- 
2.18.0
