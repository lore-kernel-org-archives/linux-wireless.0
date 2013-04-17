Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mms2.broadcom.com ([216.31.210.18]:4884 "EHLO mms2.broadcom.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S966751Ab3DQT03 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 17 Apr 2013 15:26:29 -0400
From: "Arend van Spriel" <arend@broadcom.com>
To: "John W. Linville" <linville@tuxdriver.com>
cc: linux-wireless <linux-wireless@vger.kernel.org>,
	"Arend van Spriel" <arend@broadcom.com>
Subject: [PATCH 10/10] brcmfmac: stop dequeue upon sk_buff commit
 failure
Date: Wed, 17 Apr 2013 21:25:58 +0200
Message-ID: <1366226758-20641-11-git-send-email-arend@broadcom.com> (sfid-20130417_212633_807323_03D1F8FC)
In-Reply-To: <1366226758-20641-1-git-send-email-arend@broadcom.com>
References: <1366226758-20641-1-git-send-email-arend@broadcom.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

In the dequeue worker the function brcmf_commit_skb() is called.
However, instead of increment the credit count upon success it
should break the for loop upon failure. Otherwise, it will result
in an endless loop.

Reviewed-by: Hante Meuleman <meuleman@broadcom.com>
Reviewed-by: Pieter-Paul Giesberts <pieterpg@broadcom.com>
Signed-off-by: Arend van Spriel <arend@broadcom.com>
---
 drivers/net/wireless/brcm80211/brcmfmac/fwsignal.c |    5 ++---
 1 file changed, 2 insertions(+), 3 deletions(-)

diff --git a/drivers/net/wireless/brcm80211/brcmfmac/fwsignal.c b/drivers/net/wireless/brcm80211/brcmfmac/fwsignal.c
index 25eaa13..8ae7da8 100644
--- a/drivers/net/wireless/brcm80211/brcmfmac/fwsignal.c
+++ b/drivers/net/wireless/brcm80211/brcmfmac/fwsignal.c
@@ -1850,10 +1850,9 @@ static void brcmf_fws_dequeue_worker(struct work_struct *worker)
 			  fws->fifo_credit[fifo]);
 		for (credit = 0; credit < fws->fifo_credit[fifo]; /* nop */) {
 			skb = brcmf_fws_deq(fws, fifo);
-			if (!skb)
+			if (!skb || brcmf_fws_commit_skb(fws, fifo, skb))
 				break;
-			if (!brcmf_fws_commit_skb(fws, fifo, skb) &&
-			    brcmf_skbcb(skb)->if_flags &
+			if (brcmf_skbcb(skb)->if_flags &
 			    BRCMF_SKB_IF_FLAGS_CREDITCHECK_MASK)
 				credit++;
 		}
-- 
1.7.10.4


