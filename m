Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-gw3-out.broadcom.com ([216.31.210.64]:63245 "EHLO
	mail-gw3-out.broadcom.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932551AbcFCVbS (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 3 Jun 2016 17:31:18 -0400
From: Arend van Spriel <arend.vanspriel@broadcom.com>
To: Kalle Valo <kvalo@codeaurora.org>
Cc: linux-wireless <linux-wireless@vger.kernel.org>,
	Hante Meuleman <hante.meuleman@broadcom.com>,
	Arend van Spriel <arend.vanspriel@broadcom.com>
Subject: [PATCH 1/6] brcmfmac: fix skb priority handling
Date: Fri,  3 Jun 2016 23:31:07 +0200
Message-Id: <1464989472-29684-2-git-send-email-arend.vanspriel@broadcom.com> (sfid-20160603_233124_058724_9CC3F931)
In-Reply-To: <1464989472-29684-1-git-send-email-arend.vanspriel@broadcom.com>
References: <1464989472-29684-1-git-send-email-arend.vanspriel@broadcom.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Hante Meuleman <hante.meuleman@broadcom.com>

SKBs can come with a prioriy. Currently a priority of 0..7 is
assumed. But this assumption is incorrect. To fix this any
priority of 0 or higher then 7 will be adjusted by calling
cfg80211_classify8021d

Reviewed-by: Arend Van Spriel <arend@broadcom.com>
Reviewed-by: Franky Lin <franky.lin@broadcom.com>
Reviewed-by: Pieter-Paul Giesberts <pieter-paul.giesberts@broadcom.com>
Signed-off-by: Hante Meuleman <hante.meuleman@broadcom.com>
Signed-off-by: Arend van Spriel <arend.vanspriel@broadcom.com>
---
 drivers/net/wireless/broadcom/brcm80211/brcmfmac/fwsignal.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/fwsignal.c b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/fwsignal.c
index 5b30922..cd221ab 100644
--- a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/fwsignal.c
+++ b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/fwsignal.c
@@ -2101,7 +2101,7 @@ int brcmf_fws_process_skb(struct brcmf_if *ifp, struct sk_buff *skb)
 
 	brcmf_dbg(DATA, "tx proto=0x%X\n", ntohs(eh->h_proto));
 	/* determine the priority */
-	if (!skb->priority)
+	if ((skb->priority == 0) || (skb->priority > 7))
 		skb->priority = cfg80211_classify8021d(skb, NULL);
 
 	drvr->tx_multicast += !!multicast;
-- 
1.9.1

