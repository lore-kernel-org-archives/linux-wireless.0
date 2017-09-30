Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pf0-f193.google.com ([209.85.192.193]:34559 "EHLO
        mail-pf0-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752178AbdI3Rit (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Sat, 30 Sep 2017 13:38:49 -0400
Received: by mail-pf0-f193.google.com with SMTP id g65so1769766pfe.1
        for <linux-wireless@vger.kernel.org>; Sat, 30 Sep 2017 10:38:49 -0700 (PDT)
From: silexcommon@gmail.com
To: ath10k@lists.infradead.org
Cc: linux-wireless@vger.kernel.org,
        Alagu Sankar <alagusankar@silex-india.com>
Subject: [PATCH 11/11] ath10k_sdio: hif start once addition
Date: Sat, 30 Sep 2017 23:07:48 +0530
Message-Id: <1506793068-27445-12-git-send-email-alagusankar@silex-india.com> (sfid-20170930_193811_719044_5E78B23D)
In-Reply-To: <1506793068-27445-1-git-send-email-alagusankar@silex-india.com>
References: <1506793068-27445-1-git-send-email-alagusankar@silex-india.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Alagu Sankar <alagusankar@silex-india.com>

sdio hif interface uses the start_once optimization to avoid unnecessary
firmware downloading. simulate hif_stop in sdio as core_stop does not
handle this due to start_once optimization.

Signed-off-by: Alagu Sankar <alagusankar@silex-india.com>
---
 drivers/net/wireless/ath/ath10k/sdio.c | 6 ++++++
 1 file changed, 6 insertions(+)

diff --git a/drivers/net/wireless/ath/ath10k/sdio.c b/drivers/net/wireless/ath/ath10k/sdio.c
index 11fbf6e..c6f23a9 100644
--- a/drivers/net/wireless/ath/ath10k/sdio.c
+++ b/drivers/net/wireless/ath/ath10k/sdio.c
@@ -2255,6 +2255,12 @@ static void ath10k_sdio_remove(struct sdio_func *func)
 	cancel_work_sync(&ar_sdio->wr_async_work);
 	ath10k_core_unregister(ar);
 	ath10k_core_destroy(ar);
+
+	if (ar->is_started && ar->hw_params.start_once) {
+		ath10k_hif_stop(ar);
+		ath10k_hif_power_down(ar);
+	}
+
 	kfree(ar_sdio->dma_buffer);
 	kfree(ar_sdio->vsg_buffer);
 }
-- 
1.9.1
