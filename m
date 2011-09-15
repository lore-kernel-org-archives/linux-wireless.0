Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wolverine01.qualcomm.com ([199.106.114.254]:30666 "EHLO
	wolverine01.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754732Ab1IOH5w (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 15 Sep 2011 03:57:52 -0400
From: Vivek Natarajan <nataraja@qca.qualcomm.com>
To: <kvalo@qca.qualcomm.com>
CC: <linux-wireless@vger.kernel.org>,
	Vasanthakumar Thiagarajan <vthiagar@qca.qualcomm.com>
Subject: [PATCH] ath6kl: Deinitialize wiphy on error.
Date: Thu, 15 Sep 2011 13:27:46 +0530
Message-ID: <1316073466-3971-1-git-send-email-nataraja@qca.qualcomm.com> (sfid-20110915_095755_283620_54BD6B4C)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This fixes the panic observed on card removal.

CC: Vasanthakumar Thiagarajan <vthiagar@qca.qualcomm.com>
Signed-off-by: Vivek Natarajan <nataraja@qca.qualcomm.com>
---
 drivers/net/wireless/ath/ath6kl/sdio.c |    7 +++++--
 1 files changed, 5 insertions(+), 2 deletions(-)

diff --git a/drivers/net/wireless/ath/ath6kl/sdio.c b/drivers/net/wireless/ath/ath6kl/sdio.c
index 0cce801..18154ff 100644
--- a/drivers/net/wireless/ath/ath6kl/sdio.c
+++ b/drivers/net/wireless/ath/ath6kl/sdio.c
@@ -25,6 +25,7 @@
 #include "hif-ops.h"
 #include "target.h"
 #include "debug.h"
+#include "cfg80211.h"
 
 struct ath6kl_sdio {
 	struct sdio_func *func;
@@ -816,7 +817,7 @@ static int ath6kl_sdio_probe(struct sdio_func *func,
 			ath6kl_err("Failed to enable 4-bit async irq mode %d\n",
 				   ret);
 			sdio_release_host(func);
-			goto err_dma;
+			goto err_sdio;
 		}
 
 		ath6kl_dbg(ATH6KL_DBG_TRC, "4-bit async irq mode enabled\n");
@@ -829,7 +830,7 @@ static int ath6kl_sdio_probe(struct sdio_func *func,
 
 	ret = ath6kl_sdio_power_on(ar_sdio);
 	if (ret)
-		goto err_dma;
+		goto err_sdio;
 
 	sdio_claim_host(func);
 
@@ -853,6 +854,8 @@ static int ath6kl_sdio_probe(struct sdio_func *func,
 
 err_off:
 	ath6kl_sdio_power_off(ar_sdio);
+err_sdio:
+	ath6kl_cfg80211_deinit(ar_sdio->ar);
 err_dma:
 	kfree(ar_sdio->dma_buffer);
 err_hif:
-- 
1.7.1

