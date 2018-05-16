Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.bugwerft.de ([46.23.86.59]:35530 "EHLO mail.bugwerft.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751671AbeEPOIe (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 16 May 2018 10:08:34 -0400
From: Daniel Mack <daniel@zonque.org>
To: linux-wireless@vger.kernel.org
Cc: wcn36xx@lists.infradead.org, kvalo@codeaurora.org,
        rfried@codeaurora.org, bjorn.andersson@linaro.org,
        nicolas.dechesne@linaro.org, loic.poulain@linaro.org,
        Daniel Mack <daniel@zonque.org>
Subject: [PATCH 02/10] wcn36xx: set DMA mask explicitly
Date: Wed, 16 May 2018 16:08:12 +0200
Message-Id: <20180516140820.1636-3-daniel@zonque.org> (sfid-20180516_160859_509573_DAB1ED79)
In-Reply-To: <20180516140820.1636-1-daniel@zonque.org>
References: <20180516140820.1636-1-daniel@zonque.org>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

The device takes 32-bit addresses only, so inform the DMA API about it.
This is the default on msm8016, so that doesn't change anything, but
it's best practice to be explicit.

Signed-off-by: Daniel Mack <daniel@zonque.org>
---
 drivers/net/wireless/ath/wcn36xx/main.c | 6 ++++++
 1 file changed, 6 insertions(+)

diff --git a/drivers/net/wireless/ath/wcn36xx/main.c b/drivers/net/wireless/ath/wcn36xx/main.c
index e3b91b3b38ef..e6330ad372b3 100644
--- a/drivers/net/wireless/ath/wcn36xx/main.c
+++ b/drivers/net/wireless/ath/wcn36xx/main.c
@@ -1309,6 +1309,12 @@ static int wcn36xx_probe(struct platform_device *pdev)
 	mutex_init(&wcn->hal_mutex);
 	mutex_init(&wcn->scan_lock);
 
+	ret = dma_set_mask_and_coherent(wcn->dev, DMA_BIT_MASK(32));
+	if (ret < 0) {
+		wcn36xx_err("failed to set DMA mask: %d\n", ret);
+		goto out_wq;
+	}
+
 	INIT_WORK(&wcn->scan_work, wcn36xx_hw_scan_worker);
 
 	wcn->smd_channel = qcom_wcnss_open_channel(wcnss, "WLAN_CTRL", wcn36xx_smd_rsp_process, hw);
-- 
2.14.3
