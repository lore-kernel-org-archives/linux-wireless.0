Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-gw3-out.broadcom.com ([216.31.210.64]:3267 "EHLO
	mail-gw3-out.broadcom.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753009AbbJ2Tne (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 29 Oct 2015 15:43:34 -0400
From: Arend van Spriel <arend@broadcom.com>
To: Kalle Valo <kvalo@codeaurora.org>
CC: linux-wireless <linux-wireless@vger.kernel.org>,
	Hante Meuleman <meuleman@broadcom.com>,
	Arend van Spriel <arend@broadcom.com>
Subject: [PATCH 3/9] brcmfmac: Remove unnecessary check from start_xmit.
Date: Thu, 29 Oct 2015 20:33:13 +0100
Message-ID: <1446147199-21671-4-git-send-email-arend@broadcom.com> (sfid-20151029_204339_594461_2EBCC893)
In-Reply-To: <1446147199-21671-1-git-send-email-arend@broadcom.com>
References: <1446147199-21671-1-git-send-email-arend@broadcom.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Hante Meuleman <meuleman@broadcom.com>

The brcmf_netdev_start_xmit checks if the ndev is still valid by
checking if it still exists in database. This check is not needed
and therefor removed.

Reviewed-by: Arend Van Spriel <arend@broadcom.com>
Reviewed-by: Pieter-Paul Giesberts <pieterpg@broadcom.com>
Signed-off-by: Hante Meuleman <meuleman@broadcom.com>
Signed-off-by: Arend van Spriel <arend@broadcom.com>
---
 drivers/net/wireless/brcm80211/brcmfmac/core.c | 8 --------
 1 file changed, 8 deletions(-)

diff --git a/drivers/net/wireless/brcm80211/brcmfmac/core.c b/drivers/net/wireless/brcm80211/brcmfmac/core.c
index 76b66bc..b743a83 100644
--- a/drivers/net/wireless/brcm80211/brcmfmac/core.c
+++ b/drivers/net/wireless/brcm80211/brcmfmac/core.c
@@ -217,14 +217,6 @@ static netdev_tx_t brcmf_netdev_start_xmit(struct sk_buff *skb,
 		goto done;
 	}
 
-	if (!drvr->iflist[ifp->bssidx]) {
-		brcmf_err("bad ifidx %d\n", ifp->bssidx);
-		netif_stop_queue(ndev);
-		dev_kfree_skb(skb);
-		ret = -ENODEV;
-		goto done;
-	}
-
 	/* Make sure there's enough room for any header */
 	if (skb_headroom(skb) < drvr->hdrlen) {
 		struct sk_buff *skb2;
-- 
1.9.1

