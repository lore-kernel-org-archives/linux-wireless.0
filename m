Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.bugwerft.de ([46.23.86.59]:35578 "EHLO mail.bugwerft.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1752535AbeEPOIl (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 16 May 2018 10:08:41 -0400
From: Daniel Mack <daniel@zonque.org>
To: linux-wireless@vger.kernel.org
Cc: wcn36xx@lists.infradead.org, kvalo@codeaurora.org,
        rfried@codeaurora.org, bjorn.andersson@linaro.org,
        nicolas.dechesne@linaro.org, loic.poulain@linaro.org,
        Daniel Mack <daniel@zonque.org>
Subject: [PATCH 06/10] wcn36xx: consider CTRL_EOP bit when looking for valid descriptors
Date: Wed, 16 May 2018 16:08:16 +0200
Message-Id: <20180516140820.1636-7-daniel@zonque.org> (sfid-20180516_160844_081953_25895A56)
In-Reply-To: <20180516140820.1636-1-daniel@zonque.org>
References: <20180516140820.1636-1-daniel@zonque.org>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

In reap_tx_dxes(), when we iterate over the linked descriptors, only
consider such valid that have WCN36xx_DXE_CTRL_EOP set.

This is what the prima downstream driver is doing as well.

Signed-off-by: Daniel Mack <daniel@zonque.org>
---
 drivers/net/wireless/ath/wcn36xx/dxe.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/drivers/net/wireless/ath/wcn36xx/dxe.c b/drivers/net/wireless/ath/wcn36xx/dxe.c
index 8c64e05ca3b7..06cfe8d311f3 100644
--- a/drivers/net/wireless/ath/wcn36xx/dxe.c
+++ b/drivers/net/wireless/ath/wcn36xx/dxe.c
@@ -370,7 +370,9 @@ static void reap_tx_dxes(struct wcn36xx *wcn, struct wcn36xx_dxe_ch *ch)
 	do {
 		if (READ_ONCE(ctl->desc->ctrl) & WCN36xx_DXE_CTRL_VLD)
 			break;
-		if (ctl->skb) {
+
+		if (ctl->skb &&
+		    READ_ONCE(ctl->desc->ctrl) & WCN36xx_DXE_CTRL_EOP) {
 			dma_unmap_single(wcn->dev, ctl->desc->src_addr_l,
 					 ctl->skb->len, DMA_TO_DEVICE);
 			info = IEEE80211_SKB_CB(ctl->skb);
-- 
2.14.3
