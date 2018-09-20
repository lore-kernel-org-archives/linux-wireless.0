Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.codeaurora.org ([198.145.29.96]:43910 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726982AbeITKqI (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 20 Sep 2018 06:46:08 -0400
From: Govind Singh <govinds@codeaurora.org>
To: ath10k@lists.infradead.org
Cc: linux-wireless@vger.kernel.org,
        Govind Singh <govinds@codeaurora.org>
Subject: [PATCH 2/2] ath10k: Disable napi before resource cleanup to avoid "use after free"
Date: Thu, 20 Sep 2018 10:34:26 +0530
Message-Id: <20180920050426.4113-2-govinds@codeaurora.org> (sfid-20180920_070439_773640_CF12E29C)
In-Reply-To: <20180920050426.4113-1-govinds@codeaurora.org>
References: <20180920050426.4113-1-govinds@codeaurora.org>
MIME-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

CE buffers are cleaned up prior to napi disable and this is causing
NULL pointer dereference due to "use after free".

Disable napi before resource cleanup to avoid "use after free".

Signed-off-by: Govind Singh <govinds@codeaurora.org>
---
 drivers/net/wireless/ath/ath10k/snoc.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/wireless/ath/ath10k/snoc.c b/drivers/net/wireless/ath/ath10k/snoc.c
index dd043b858c8e..6da951eea345 100644
--- a/drivers/net/wireless/ath/ath10k/snoc.c
+++ b/drivers/net/wireless/ath/ath10k/snoc.c
@@ -911,9 +911,9 @@ static void ath10k_snoc_buffer_cleanup(struct ath10k *ar)
 static void ath10k_snoc_hif_stop(struct ath10k *ar)
 {
 	ath10k_snoc_irq_disable(ar);
-	ath10k_snoc_buffer_cleanup(ar);
 	napi_synchronize(&ar->napi);
 	napi_disable(&ar->napi);
+	ath10k_snoc_buffer_cleanup(ar);
 	ath10k_dbg(ar, ATH10K_DBG_BOOT, "boot hif stop\n");
 }
 
-- 
2.18.0
