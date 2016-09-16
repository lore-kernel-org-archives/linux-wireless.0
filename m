Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pf0-f196.google.com ([209.85.192.196]:36788 "EHLO
        mail-pf0-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S932715AbcIPNFu (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 16 Sep 2016 09:05:50 -0400
Received: by mail-pf0-f196.google.com with SMTP id n24so3629527pfb.3
        for <linux-wireless@vger.kernel.org>; Fri, 16 Sep 2016 06:05:50 -0700 (PDT)
From: Wei Yongjun <weiyj.lk@gmail.com>
To: Kalle Valo <kvalo@qca.qualcomm.com>,
        Raja Mani <rmani@qti.qualcomm.com>
Cc: Wei Yongjun <weiyongjun1@huawei.com>, ath10k@lists.infradead.org,
        linux-wireless@vger.kernel.org
Subject: [PATCH -next] ath10k: fix error return code in ahb
Date: Fri, 16 Sep 2016 13:05:35 +0000
Message-Id: <1474031135-6963-1-git-send-email-weiyj.lk@gmail.com> (sfid-20160916_150601_636900_E955C50F)
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Wei Yongjun <weiyongjun1@huawei.com>

Fix to return a negative error code from the error handling case
instead of 0, as done elsewhere in function ath10k_ahb_probe() or
ath10k_ahb_resource_init().

Signed-off-by: Wei Yongjun <weiyongjun1@huawei.com>
---
 drivers/net/wireless/ath/ath10k/ahb.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/net/wireless/ath/ath10k/ahb.c b/drivers/net/wireless/ath/ath10k/ahb.c
index b99ad5d..6dc1c60 100644
--- a/drivers/net/wireless/ath/ath10k/ahb.c
+++ b/drivers/net/wireless/ath/ath10k/ahb.c
@@ -572,6 +572,7 @@ static int ath10k_ahb_resource_init(struct ath10k *ar)
 	ar_ahb->irq = platform_get_irq_byname(pdev, "legacy");
 	if (ar_ahb->irq < 0) {
 		ath10k_err(ar, "failed to get irq number: %d\n", ar_ahb->irq);
+		ret = ar_ahb->irq;
 		goto err_clock_deinit;
 	}
 
@@ -850,6 +851,7 @@ static int ath10k_ahb_probe(struct platform_device *pdev)
 	chip_id = ath10k_ahb_soc_read32(ar, SOC_CHIP_ID_ADDRESS);
 	if (chip_id == 0xffffffff) {
 		ath10k_err(ar, "failed to get chip id\n");
+		ret = -ENODEV;
 		goto err_halt_device;
 	}
