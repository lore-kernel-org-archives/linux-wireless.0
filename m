Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pa0-f50.google.com ([209.85.220.50]:35759 "EHLO
	mail-pa0-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750954AbcEJGVh (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 10 May 2016 02:21:37 -0400
Received: by mail-pa0-f50.google.com with SMTP id iv1so1919875pac.2
        for <linux-wireless@vger.kernel.org>; Mon, 09 May 2016 23:21:36 -0700 (PDT)
From: Wei-Ning Huang <wnhuang@chromium.org>
To: Linux-Wireless <linux-wireless@vger.kernel.org>
Cc: LKML <linux-kernel@vger.kernel.org>,
	Wei-Ning Huang <wnhuang@chromium.org>
Subject: [PATCH] mwifiex: fixup error messages
Date: Tue, 10 May 2016 14:21:23 +0800
Message-Id: <1462861283-11103-1-git-send-email-wnhuang@chromium.org> (sfid-20160510_082156_606964_5AFD66CB)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Use dev_err instead of pr_err and add newline character at the end.

Signed-off-by: Wei-Ning Huang <wnhuang@chromium.org>
---
 drivers/net/wireless/marvell/mwifiex/sdio.c | 5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff --git a/drivers/net/wireless/marvell/mwifiex/sdio.c b/drivers/net/wireless/marvell/mwifiex/sdio.c
index 099722e..bdc51ff 100644
--- a/drivers/net/wireless/marvell/mwifiex/sdio.c
+++ b/drivers/net/wireless/marvell/mwifiex/sdio.c
@@ -104,7 +104,7 @@ static int mwifiex_sdio_probe_of(struct device *dev, struct sdio_mmc_card *card)
 
 	if (!dev->of_node ||
 	    !of_match_node(mwifiex_sdio_of_match_table, dev->of_node)) {
-		pr_err("sdio platform data not available");
+		dev_err(dev, "sdio platform data not available\n");
 		return -1;
 	}
 
@@ -115,7 +115,8 @@ static int mwifiex_sdio_probe_of(struct device *dev, struct sdio_mmc_card *card)
 	if (cfg && card->plt_of_node) {
 		cfg->irq_wifi = irq_of_parse_and_map(card->plt_of_node, 0);
 		if (!cfg->irq_wifi) {
-			dev_err(dev, "fail to parse irq_wifi from device tree");
+			dev_err(dev,
+				"fail to parse irq_wifi from device tree\n");
 		} else {
 			ret = devm_request_irq(dev, cfg->irq_wifi,
 					       mwifiex_wake_irq_wifi,
-- 
2.1.2

