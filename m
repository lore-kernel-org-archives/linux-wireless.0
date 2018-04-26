Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-lf0-f65.google.com ([209.85.215.65]:43401 "EHLO
        mail-lf0-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1756008AbeDZMgl (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 26 Apr 2018 08:36:41 -0400
Received: by mail-lf0-f65.google.com with SMTP id g12-v6so14394658lfb.10
        for <linux-wireless@vger.kernel.org>; Thu, 26 Apr 2018 05:36:40 -0700 (PDT)
From: Niklas Cassel <niklas.cassel@linaro.org>
To: Kalle Valo <kvalo@qca.qualcomm.com>
Cc: Niklas Cassel <niklas.cassel@linaro.org>,
        ath10k@lists.infradead.org, linux-wireless@vger.kernel.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH] ath10k: sdio: jump to correct label in error handling path
Date: Thu, 26 Apr 2018 14:35:02 +0200
Message-Id: <20180426123502.23962-1-niklas.cassel@linaro.org> (sfid-20180426_143711_870875_6FFF6508)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Jump to the correct label in error handling path.
At this point of execution create_singlethread_workqueue() has succeeded,
so it should be properly destroyed.

Jump label was renamed in commit ec2c64e20257 ("ath10k: sdio: fix memory
leak for probe allocations").
However, the bug was originally introduced in commit d96db25d2025
("ath10k: add initial SDIO support").

Fixes: d96db25d2025 ("ath10k: add initial SDIO support")
Signed-off-by: Niklas Cassel <niklas.cassel@linaro.org>
---
 drivers/net/wireless/ath/ath10k/sdio.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/wireless/ath/ath10k/sdio.c b/drivers/net/wireless/ath/ath10k/sdio.c
index 2d04c54a4153..d612ce8c9cff 100644
--- a/drivers/net/wireless/ath/ath10k/sdio.c
+++ b/drivers/net/wireless/ath/ath10k/sdio.c
@@ -2011,7 +2011,7 @@ static int ath10k_sdio_probe(struct sdio_func *func,
 		ret = -ENODEV;
 		ath10k_err(ar, "unsupported device id %u (0x%x)\n",
 			   dev_id_base, id->device);
-		goto err_core_destroy;
+		goto err_free_wq;
 	}
 
 	ar->id.vendor = id->vendor;
-- 
2.14.3
