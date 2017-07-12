Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from lpdvrndsmtp01.broadcom.com ([192.19.229.170]:44534 "EHLO
        rnd-relay.smtp.broadcom.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1750959AbdGLJcw (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 12 Jul 2017 05:32:52 -0400
From: Arend van Spriel <arend.vanspriel@broadcom.com>
To: Kalle Valo <kvalo@codeaurora.org>
Cc: linux-wireless@vger.kernel.org,
        Arend van Spriel <arend.vanspriel@broadcom.com>
Subject: [PATCH for-4.13] brcmfmac: fix regression in brcmf_sdio_txpkt_hdalign()
Date: Wed, 12 Jul 2017 10:32:48 +0100
Message-Id: <1499851968-18768-1-git-send-email-arend.vanspriel@broadcom.com> (sfid-20170712_113256_219829_F853847D)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Recent change in brcmf_sdio_txpkt_hdalign() changed the
behavior and now always returns 0. This resulted in a
regression which basically renders the device useless.

Fixes: 270a6c1f65fe ("brcmfmac: rework headroom check in .start_xmit()")
Reported-by: S. Gilles <sgilles@math.umd.edu>
Tested-by: S. Gilles <sgilles@math.umd.edu>
Signed-off-by: Arend van Spriel <arend.vanspriel@broadcom.com>
---
 drivers/net/wireless/broadcom/brcm80211/brcmfmac/sdio.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/sdio.c b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/sdio.c
index fbcbb43..c3ecec6 100644
--- a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/sdio.c
+++ b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/sdio.c
@@ -2053,12 +2053,13 @@ static int brcmf_sdio_txpkt_hdalign(struct brcmf_sdio *bus, struct sk_buff *pkt)
 				atomic_inc(&stats->pktcow_failed);
 				return -ENOMEM;
 			}
+			head_pad = 0;
 		}
 		skb_push(pkt, head_pad);
 		dat_buf = (u8 *)(pkt->data);
 	}
 	memset(dat_buf, 0, head_pad + bus->tx_hdrlen);
-	return 0;
+	return head_pad;
 }
 
 /**
-- 
1.9.1
