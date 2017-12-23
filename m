Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from szxga06-in.huawei.com ([45.249.212.32]:47215 "EHLO huawei.com"
        rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org with ESMTP
        id S1750928AbdLWLLQ (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Sat, 23 Dec 2017 06:11:16 -0500
From: Yisheng Xie <xieyisheng1@huawei.com>
To: <linux-kernel@vger.kernel.org>, <gregkh@linuxfoundation.org>
CC: <ysxie@foxmail.com>, Yisheng Xie <xieyisheng1@huawei.com>,
        Kalle Valo <kvalo@codeaurora.org>,
        <linux-wireless@vger.kernel.org>, <netdev@vger.kernel.org>
Subject: [PATCH v3 25/27] wireless: replace devm_ioremap_nocache with devm_ioremap
Date: Sat, 23 Dec 2017 19:02:27 +0800
Message-ID: <1514026947-33753-1-git-send-email-xieyisheng1@huawei.com> (sfid-20171223_121138_260394_22C2FB64)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Default ioremap is ioremap_nocache, so devm_ioremap has the same
function with devm_ioremap_nocache, which can just be killed to
save the size of devres.o

This patch is to use use devm_ioremap instead of devm_ioremap_nocache,
which should not have any function change but prepare for killing
devm_ioremap_nocache.

Cc: Kalle Valo <kvalo@codeaurora.org>
Cc: linux-wireless@vger.kernel.org
Cc: netdev@vger.kernel.org
Signed-off-by: Yisheng Xie <xieyisheng1@huawei.com>
---
 drivers/net/wireless/ath/ath9k/ahb.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/wireless/ath/ath9k/ahb.c b/drivers/net/wireless/ath/ath9k/ahb.c
index 2bd982c..6e13e62 100644
--- a/drivers/net/wireless/ath/ath9k/ahb.c
+++ b/drivers/net/wireless/ath/ath9k/ahb.c
@@ -91,7 +91,7 @@ static int ath_ahb_probe(struct platform_device *pdev)
 		return -ENXIO;
 	}
 
-	mem = devm_ioremap_nocache(&pdev->dev, res->start, resource_size(res));
+	mem = devm_ioremap(&pdev->dev, res->start, resource_size(res));
 	if (mem == NULL) {
 		dev_err(&pdev->dev, "ioremap failed\n");
 		return -ENOMEM;
-- 
1.8.3.1
