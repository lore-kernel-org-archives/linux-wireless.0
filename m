Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-bk0-f51.google.com ([209.85.214.51]:36538 "EHLO
	mail-bk0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750737Ab3J3FYk (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 30 Oct 2013 01:24:40 -0400
Received: by mail-bk0-f51.google.com with SMTP id e11so267988bkh.38
        for <linux-wireless@vger.kernel.org>; Tue, 29 Oct 2013 22:24:39 -0700 (PDT)
MIME-Version: 1.0
Date: Wed, 30 Oct 2013 13:24:39 +0800
Message-ID: <CAPgLHd9o1oGjjM=9B2H0tB41t8Kinp_1Djp6aA=sW5Eo5M7jfA@mail.gmail.com> (sfid-20131030_062443_769166_F87A121B)
Subject: [PATCH -next] ath10k: fix possible memory leak in ath10k_pci_probe()
From: Wei Yongjun <weiyj.lk@gmail.com>
To: kvalo@qca.qualcomm.com, linville@tuxdriver.com
Cc: yongjun_wei@trendmicro.com.cn, ath10k@lists.infradead.org,
	linux-wireless@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Wei Yongjun <yongjun_wei@trendmicro.com.cn>

memory is malloced in ath10k_pci_probe() and should be freed before
leaving from the error handling cases, otherwise it will cause
memory leak.

Signed-off-by: Wei Yongjun <yongjun_wei@trendmicro.com.cn>
---
 drivers/net/wireless/ath/ath10k/pci.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/wireless/ath/ath10k/pci.c b/drivers/net/wireless/ath/ath10k/pci.c
index dff23d9..af01631 100644
--- a/drivers/net/wireless/ath/ath10k/pci.c
+++ b/drivers/net/wireless/ath/ath10k/pci.c
@@ -2470,7 +2470,7 @@ static int ath10k_pci_probe(struct pci_dev *pdev,
 	ret = ath10k_do_pci_wake(ar);
 	if (ret) {
 		ath10k_err("Failed to get chip id: %d\n", ret);
-		return ret;
+		goto err_iomap;
 	}
 
 	chip_id = ath10k_pci_read32(ar,

