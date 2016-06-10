Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-qk0-f193.google.com ([209.85.220.193]:34342 "EHLO
	mail-qk0-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750772AbcFJArH (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 9 Jun 2016 20:47:07 -0400
From: Bruno Herrera <bruherrera@gmail.com>
To: kvalo@codeaurora.org
Cc: poggi.raph@gmail.com, linux-wireless@vger.kernel.org,
	netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH] wlcore: sdio: Fix crash on wlcore_probe_of when failing to parse/map irq
Date: Thu,  9 Jun 2016 21:46:46 -0300
Message-Id: <1465519606-68129-1-git-send-email-bruherrera@gmail.com> (sfid-20160610_024732_158879_CFF02C0D)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

pdev_data pointer is being freed with kfree but the pointer is not dynamic allocated.

Signed-off-by: Bruno Herrera <bruherrera@gmail.com>
---
 drivers/net/wireless/ti/wlcore/sdio.c | 1 -
 1 file changed, 1 deletion(-)

diff --git a/drivers/net/wireless/ti/wlcore/sdio.c b/drivers/net/wireless/ti/wlcore/sdio.c
index c172da5..5839acb 100644
--- a/drivers/net/wireless/ti/wlcore/sdio.c
+++ b/drivers/net/wireless/ti/wlcore/sdio.c
@@ -241,7 +241,6 @@ static int wlcore_probe_of(struct device *dev, int *irq,
 	*irq = irq_of_parse_and_map(np, 0);
 	if (!*irq) {
 		dev_err(dev, "No irq in platform data\n");
-		kfree(pdev_data);
 		return -EINVAL;
 	}
 
-- 
2.7.4 (Apple Git-66)

