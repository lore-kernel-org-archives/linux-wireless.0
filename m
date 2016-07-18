Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pa0-f65.google.com ([209.85.220.65]:35012 "EHLO
	mail-pa0-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751825AbcGRXYx (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 18 Jul 2016 19:24:53 -0400
Received: by mail-pa0-f65.google.com with SMTP id cf3so110443pad.2
        for <linux-wireless@vger.kernel.org>; Mon, 18 Jul 2016 16:24:53 -0700 (PDT)
From: Florian Fainelli <f.fainelli@gmail.com>
To: brcm80211-dev-list.pdl@broadcom.com
Cc: linux-wireless@vger.kernel.org, pieterpg@broadcom.com,
	kvalo@codeaurora.org, arend.vanspriel@broadcom.com,
	hante.meuleman@broadcom.com,
	Florian Fainelli <f.fainelli@gmail.com>
Subject: [PATCH 2/4] brcmsmac: Free packet if dma_mapping_error() fails in dma_rxfill
Date: Mon, 18 Jul 2016 16:24:35 -0700
Message-Id: <1468884277-18606-3-git-send-email-f.fainelli@gmail.com> (sfid-20160719_012459_771675_2455F819)
In-Reply-To: <1468884277-18606-1-git-send-email-f.fainelli@gmail.com>
References: <1468884277-18606-1-git-send-email-f.fainelli@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

In case dma_mapping_error() returns an error in dma_rxfill, we would be
leaking a packet that we allocated with brcmu_pkt_buf_get_skb().

Reported-by: coverity (CID 1081819)
Fixes: 67d0cf50bd32 ("brcmsmac: Fix WARNING caused by lack of calls to dma_mapping_error()")
Signed-off-by: Florian Fainelli <f.fainelli@gmail.com>
---
 drivers/net/wireless/broadcom/brcm80211/brcmsmac/dma.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/drivers/net/wireless/broadcom/brcm80211/brcmsmac/dma.c b/drivers/net/wireless/broadcom/brcm80211/brcmsmac/dma.c
index 796f5f9d5d5a..b7df576bb84d 100644
--- a/drivers/net/wireless/broadcom/brcm80211/brcmsmac/dma.c
+++ b/drivers/net/wireless/broadcom/brcm80211/brcmsmac/dma.c
@@ -1079,8 +1079,10 @@ bool dma_rxfill(struct dma_pub *pub)
 
 		pa = dma_map_single(di->dmadev, p->data, di->rxbufsize,
 				    DMA_FROM_DEVICE);
-		if (dma_mapping_error(di->dmadev, pa))
+		if (dma_mapping_error(di->dmadev, pa)) {
+			brcmu_pkt_buf_free_skb(p);
 			return false;
+		}
 
 		/* save the free packet pointer */
 		di->rxp[rxout] = p;
-- 
2.7.4

