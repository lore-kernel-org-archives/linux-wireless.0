Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wi0-f177.google.com ([209.85.212.177]:34572 "EHLO
	mail-wi0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753709AbbGBIfi (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 2 Jul 2015 04:35:38 -0400
From: Raphael Poggi <poggi.raph@gmail.com>
To: kvalo@codeaurora.org, luca@coelho.fi
Cc: linux-wireless@vger.kernel.org, linux-kernel@vger.kernel.org,
	Raphael Poggi <poggi.raph@gmail.com>
Subject: [PATCH] wlcore: sdio: return correct error code
Date: Thu,  2 Jul 2015 10:34:49 +0200
Message-Id: <1435826089-83970-1-git-send-email-poggi.raph@gmail.com> (sfid-20150702_103602_505197_98DA19E4)
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

When wlcore_probe_of failed, return the correct error code instead of ENOMEM

Signed-off-by: Raphaël Poggi <poggi.raph@gmail.com>
---
 drivers/net/wireless/ti/wlcore/sdio.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/net/wireless/ti/wlcore/sdio.c b/drivers/net/wireless/ti/wlcore/sdio.c
index ea7e07a..c172da5 100644
--- a/drivers/net/wireless/ti/wlcore/sdio.c
+++ b/drivers/net/wireless/ti/wlcore/sdio.c
@@ -293,7 +293,8 @@ static int wl1271_probe(struct sdio_func *func,
 	/* Use block mode for transferring over one block size of data */
 	func->card->quirks |= MMC_QUIRK_BLKSZ_FOR_BYTE_MODE;
 
-	if (wlcore_probe_of(&func->dev, &irq, &pdev_data))
+	ret = wlcore_probe_of(&func->dev, &irq, &pdev_data);
+	if (ret)
 		goto out_free_glue;
 
 	/* if sdio can keep power while host is suspended, enable wow */
-- 
2.1.0

