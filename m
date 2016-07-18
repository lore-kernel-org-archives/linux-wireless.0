Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pf0-f193.google.com ([209.85.192.193]:36423 "EHLO
	mail-pf0-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752184AbcGRXYw (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 18 Jul 2016 19:24:52 -0400
Received: by mail-pf0-f193.google.com with SMTP id y134so115278pfg.3
        for <linux-wireless@vger.kernel.org>; Mon, 18 Jul 2016 16:24:51 -0700 (PDT)
From: Florian Fainelli <f.fainelli@gmail.com>
To: brcm80211-dev-list.pdl@broadcom.com
Cc: linux-wireless@vger.kernel.org, pieterpg@broadcom.com,
	kvalo@codeaurora.org, arend.vanspriel@broadcom.com,
	hante.meuleman@broadcom.com,
	Florian Fainelli <f.fainelli@gmail.com>
Subject: [PATCH 1/4] brcmfmac: Fix glob_skb leak in brcmf_sdiod_recv_chain
Date: Mon, 18 Jul 2016 16:24:34 -0700
Message-Id: <1468884277-18606-2-git-send-email-f.fainelli@gmail.com> (sfid-20160719_012455_952544_28D191D5)
In-Reply-To: <1468884277-18606-1-git-send-email-f.fainelli@gmail.com>
References: <1468884277-18606-1-git-send-email-f.fainelli@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

In case brcmf_sdiod_recv_chain() cannot complete a succeful call to
brcmf_sdiod_buffrw, we would be leaking glom_skb and not free it as we
should, fix this.

Reported-by: coverity (CID 1164856)
Fixes: a413e39a38573 ("brcmfmac: fix brcmf_sdcard_recv_chain() for host without sg support")
Signed-off-by: Florian Fainelli <f.fainelli@gmail.com>
---
 drivers/net/wireless/broadcom/brcm80211/brcmfmac/bcmsdh.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/bcmsdh.c b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/bcmsdh.c
index c4b89d27e2e8..f549c25608d6 100644
--- a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/bcmsdh.c
+++ b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/bcmsdh.c
@@ -726,8 +726,10 @@ int brcmf_sdiod_recv_chain(struct brcmf_sdio_dev *sdiodev,
 			return -ENOMEM;
 		err = brcmf_sdiod_buffrw(sdiodev, SDIO_FUNC_2, false, addr,
 					 glom_skb);
-		if (err)
+		if (err) {
+			brcmu_pkt_buf_free_skb(glom_skb);
 			goto done;
+		}
 
 		skb_queue_walk(pktq, skb) {
 			memcpy(skb->data, glom_skb->data, skb->len);
-- 
2.7.4

