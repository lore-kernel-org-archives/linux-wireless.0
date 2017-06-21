Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wr0-f170.google.com ([209.85.128.170]:35069 "EHLO
        mail-wr0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751083AbdFUVSV (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 21 Jun 2017 17:18:21 -0400
Received: by mail-wr0-f170.google.com with SMTP id k67so1765360wrc.2
        for <linux-wireless@vger.kernel.org>; Wed, 21 Jun 2017 14:18:21 -0700 (PDT)
Subject: Re: [PATCH] wireless: brcmfmac: initialize oob irq data before
 request_irq()
To: =?UTF-8?B?TWljaGHFgiBNaXJvc8WCYXc=?= <mirq-linux@rere.qmqm.pl>,
        linux-wireless@vger.kernel.org, brcm80211-dev-list.pdl@broadcom.com
Cc: Franky Lin <franky.lin@broadcom.com>,
        Hante Meuleman <hante.meuleman@broadcom.com>,
        Kalle Valo <kvalo@codeaurora.org>
References: <b6d30eb2d883c011d50200cfdb8c44462e1939a4.1497369605.git.mirq-linux@rere.qmqm.pl>
From: Arend van Spriel <arend.vanspriel@broadcom.com>
Message-ID: <e25543b3-4aa9-53f8-3b19-a44bb66beff1@broadcom.com> (sfid-20170621_231825_846980_CBA75DF7)
Date: Wed, 21 Jun 2017 23:18:18 +0200
MIME-Version: 1.0
In-Reply-To: <b6d30eb2d883c011d50200cfdb8c44462e1939a4.1497369605.git.mirq-linux@rere.qmqm.pl>
Content-Type: text/plain; charset=utf-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 13-06-17 18:02, Michał Mirosław wrote:
> This fixes spin-forever in irq handler when IRQ is already asserted
> at request_irq() time.

With all the patchwork misery flying by I almost forgot to respond to
this. We suspect you are covering up a hardware issue here. At the time
of the request_irq() the device configuration for OOB is not yet done
and as such it is an input which makes the OOB line floating.

Can you tell me what platform you are seeing the spin-forever issue.
Could it be that is does not have a proper pull-up/down on the OOB irq line.

Could you try whether moving the request_irq() and enable_irq_wake()
calls further down after device configuration (see below) solve your
issue. Still it would be better to fix the hardware.

Regards,
Arend

diff --git a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/bcmsdh.c
b/drivers
index 9b970dc..e57a211 100644
--- a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/bcmsdh.c
+++ b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/bcmsdh.c
@@ -114,26 +114,11 @@ int brcmf_sdiod_intr_register(struct
brcmf_sdio_dev *sdiod
        if (pdata->oob_irq_supported) {
                brcmf_dbg(SDIO, "Enter, register OOB IRQ %d\n",
                          pdata->oob_irq_nr);
-               ret = request_irq(pdata->oob_irq_nr,
brcmf_sdiod_oob_irqhandler,
-                                 pdata->oob_irq_flags, "brcmf_oob_intr",
-                                 &sdiodev->func[1]->dev);
-               if (ret != 0) {
-                       brcmf_err("request_irq failed %d\n", ret);
-                       return ret;
-               }
-               sdiodev->oob_irq_requested = true;
                spin_lock_init(&sdiodev->irq_en_lock);
                spin_lock_irqsave(&sdiodev->irq_en_lock, flags);
                sdiodev->irq_en = true;
                spin_unlock_irqrestore(&sdiodev->irq_en_lock, flags);

-               ret = enable_irq_wake(pdata->oob_irq_nr);
-               if (ret != 0) {
-                       brcmf_err("enable_irq_wake failed %d\n", ret);
-                       return ret;
-               }
-               sdiodev->irq_wake = true;
-
                sdio_claim_host(sdiodev->func[1]);

                if (sdiodev->bus_if->chip == BRCM_CC_43362_CHIP_ID) {
@@ -161,6 +146,22 @@ int brcmf_sdiod_intr_register(struct brcmf_sdio_dev
*sdiode
                brcmf_sdiod_regwb(sdiodev, SDIO_CCCR_BRCM_SEPINT, data,
&ret);

                sdio_release_host(sdiodev->func[1]);
+
+               ret = request_irq(pdata->oob_irq_nr,
brcmf_sdiod_oob_irqhandler,
+                                 pdata->oob_irq_flags, "brcmf_oob_intr",
+                                 &sdiodev->func[1]->dev);
+               if (ret != 0) {
+                       brcmf_err("request_irq failed %d\n", ret);
+                       return ret;
+               }
+               sdiodev->oob_irq_requested = true;
+
+               ret = enable_irq_wake(pdata->oob_irq_nr);
+               if (ret != 0) {
+                       brcmf_err("enable_irq_wake failed %d\n", ret);
+                       return ret;
+               }
+               sdiodev->irq_wake = true;
        } else {
                brcmf_dbg(SDIO, "Entering\n");
                sdio_claim_host(sdiodev->func[1]);
