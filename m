Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx0b-0016f401.pphosted.com ([67.231.156.173]:52887 "EHLO
        mx0b-0016f401.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1752956AbcIIK6a (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 9 Sep 2016 06:58:30 -0400
Received: from pps.filterd (m0045851.ppops.net [127.0.0.1])
        by mx0b-0016f401.pphosted.com (8.16.0.17/8.16.0.17) with SMTP id u89Asnix012195
        for <linux-wireless@vger.kernel.org>; Fri, 9 Sep 2016 03:58:29 -0700
Received: from sc-exch04.marvell.com ([199.233.58.184])
        by mx0b-0016f401.pphosted.com with ESMTP id 25bd9g4gf0-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-SHA384 bits=256 verify=NOT)
        for <linux-wireless@vger.kernel.org>; Fri, 09 Sep 2016 03:58:29 -0700
From: Amitkumar Karwar <akarwar@marvell.com>
To: <linux-wireless@vger.kernel.org>
CC: Amitkumar Karwar <akarwar@marvell.com>
Subject: [PATCH v2] mwifiex: handle error if IRQ request fails in mwifiex_sdio_of()
Date: Fri, 9 Sep 2016 16:27:58 +0530
Message-ID: <1473418678-14794-1-git-send-email-akarwar@marvell.com> (sfid-20160909_125834_972832_C6A3339A)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

When this failure occurs, we will clear card->plt_wake_cfg so that
device would initialize without wake up on external interrupt feature.
This feature specific code in suspend and resume handlers will be
skipped.

Signed-off-by: Amitkumar Karwar <akarwar@marvell.com>
Reviewed-by: Javier Martinez Canillas <javier@osg.samsung.com>
---
We were returning error in this failure case in v1 patch from Javier
Martinez Canillas. In v2, we allow device to initialize successfully.
---
 drivers/net/wireless/marvell/mwifiex/sdio.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/drivers/net/wireless/marvell/mwifiex/sdio.c b/drivers/net/wireless/marvell/mwifiex/sdio.c
index 6dba409..8718950 100644
--- a/drivers/net/wireless/marvell/mwifiex/sdio.c
+++ b/drivers/net/wireless/marvell/mwifiex/sdio.c
@@ -122,9 +122,11 @@ static int mwifiex_sdio_probe_of(struct device *dev, struct sdio_mmc_card *card)
 					       IRQF_TRIGGER_LOW,
 					       "wifi_wake", cfg);
 			if (ret) {
-				dev_err(dev,
+				dev_dbg(dev,
 					"Failed to request irq_wifi %d (%d)\n",
 					cfg->irq_wifi, ret);
+				card->plt_wake_cfg = NULL;
+				return 0;
 			}
 			disable_irq(cfg->irq_wifi);
 		}
-- 
1.9.1
