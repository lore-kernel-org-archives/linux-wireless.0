Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from [91.227.64.183] ([91.227.64.183]:54102 "EHLO rere.qmqm.pl"
        rhost-flags-FAIL-FAIL-OK-OK) by vger.kernel.org with ESMTP
        id S1752264AbdFMQHL (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 13 Jun 2017 12:07:11 -0400
Date: Tue, 13 Jun 2017 18:02:03 +0200
Message-Id: <b6d30eb2d883c011d50200cfdb8c44462e1939a4.1497369605.git.mirq-linux@rere.qmqm.pl> (sfid-20170613_180715_206218_13ED0AE0)
From: =?UTF-8?q?Micha=C5=82=20Miros=C5=82aw?= <mirq-linux@rere.qmqm.pl>
Subject: [PATCH] wireless: brcmfmac: initialize oob irq data before
 request_irq()
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
To: linux-wireless@vger.kernel.org, brcm80211-dev-list.pdl@broadcom.com
Cc: Arend van Spriel <arend.vanspriel@broadcom.com>,
        Franky Lin <franky.lin@broadcom.com>,
        Hante Meuleman <hante.meuleman@broadcom.com>,
        Kalle Valo <kvalo@codeaurora.org>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This fixes spin-forever in irq handler when IRQ is already asserted
at request_irq() time.

Signed-off-by: Michał Mirosław <mirq-linux@rere.qmqm.pl>
---
 drivers/net/wireless/broadcom/brcm80211/brcmfmac/bcmsdh.c | 8 +++-----
 1 file changed, 3 insertions(+), 5 deletions(-)

diff --git a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/bcmsdh.c b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/bcmsdh.c
index 9b970dc2b922a..c653a72e3dead 100644
--- a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/bcmsdh.c
+++ b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/bcmsdh.c
@@ -108,12 +108,14 @@ int brcmf_sdiod_intr_register(struct brcmf_sdio_dev *sdiodev)
 	int ret = 0;
 	u8 data;
 	u32 addr, gpiocontrol;
-	unsigned long flags;
 
 	pdata = &sdiodev->settings->bus.sdio;
 	if (pdata->oob_irq_supported) {
 		brcmf_dbg(SDIO, "Enter, register OOB IRQ %d\n",
 			  pdata->oob_irq_nr);
+		spin_lock_init(&sdiodev->irq_en_lock);
+		sdiodev->irq_en = true;
+
 		ret = request_irq(pdata->oob_irq_nr, brcmf_sdiod_oob_irqhandler,
 				  pdata->oob_irq_flags, "brcmf_oob_intr",
 				  &sdiodev->func[1]->dev);
@@ -122,10 +124,6 @@ int brcmf_sdiod_intr_register(struct brcmf_sdio_dev *sdiodev)
 			return ret;
 		}
 		sdiodev->oob_irq_requested = true;
-		spin_lock_init(&sdiodev->irq_en_lock);
-		spin_lock_irqsave(&sdiodev->irq_en_lock, flags);
-		sdiodev->irq_en = true;
-		spin_unlock_irqrestore(&sdiodev->irq_en_lock, flags);
 
 		ret = enable_irq_wake(pdata->oob_irq_nr);
 		if (ret != 0) {
-- 
2.11.0
