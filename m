Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pg0-f66.google.com ([74.125.83.66]:33031 "EHLO
        mail-pg0-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751060AbdAQW46 (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 17 Jan 2017 17:56:58 -0500
Received: by mail-pg0-f66.google.com with SMTP id 194so9039143pgd.0
        for <linux-wireless@vger.kernel.org>; Tue, 17 Jan 2017 14:56:58 -0800 (PST)
From: gavinli@thegavinli.com
To: arend.vanspriel@broadcom.com, franky.lin@broadcom.com,
        hante.meuleman@broadcom.com, linux-wireless@vger.kernel.org,
        brcm80211-dev-list.pdl@broadcom.com
Cc: stable@vger.kernel.org, Gavin Li <git@thegavinli.com>
Subject: [PATCH] brcmfmac: fix incorrect event channel deduction
Date: Tue, 17 Jan 2017 14:50:00 -0800
Message-Id: <20170117225000.6394-1-gavinli@thegavinli.com> (sfid-20170117_235712_314592_5B7A845A)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Gavin Li <git@thegavinli.com>

brcmf_sdio_fromevntchan() was being called on the the data frame
rather than the software header, causing some frames to be
mischaracterized as on the event channel rather than the data channel.

This fixes a major performance regression (due to dropped packets).

Fixes: c56caa9db8ab ("brcmfmac: screening firmware event packet")
Signed-off-by: Gavin Li <git@thegavinli.com>
Cc: <stable@vger.kernel.org> [4.6+]
---
 drivers/net/wireless/broadcom/brcm80211/brcmfmac/sdio.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/sdio.c b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/sdio.c
index dfb0658713d9..d2219885071f 100644
--- a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/sdio.c
+++ b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/sdio.c
@@ -1661,7 +1661,7 @@ static u8 brcmf_sdio_rxglom(struct brcmf_sdio *bus, u8 rxseq)
 					   pfirst->len, pfirst->next,
 					   pfirst->prev);
 			skb_unlink(pfirst, &bus->glom);
-			if (brcmf_sdio_fromevntchan(pfirst->data))
+			if (brcmf_sdio_fromevntchan(&dptr[SDPCM_HWHDR_LEN]))
 				brcmf_rx_event(bus->sdiodev->dev, pfirst);
 			else
 				brcmf_rx_frame(bus->sdiodev->dev, pfirst,
-- 
2.11.0
