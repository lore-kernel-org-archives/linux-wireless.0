Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-gw2-out.broadcom.com ([216.31.210.63]:9116 "EHLO
	mail-gw2-out.broadcom.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756208AbbHZUPT (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 26 Aug 2015 16:15:19 -0400
From: Arend van Spriel <arend@broadcom.com>
To: Kalle Valo <kvalo@codeaurora.org>
CC: linux-wireless <linux-wireless@vger.kernel.org>,
	Arend van Spriel <arend@broadcom.com>
Subject: [PATCH 10/12] brcmfmac: remove ifidx parameter from brcmf_fws_txstatus_suppressed()
Date: Wed, 26 Aug 2015 22:15:02 +0200
Message-ID: <1440620104-2715-11-git-send-email-arend@broadcom.com> (sfid-20150826_221530_293812_E3BA8C16)
In-Reply-To: <1440620104-2715-1-git-send-email-arend@broadcom.com>
References: <1440620104-2715-1-git-send-email-arend@broadcom.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

The brcmf_fws_txstatus_suppressed() function prototype specifies an
ifidx parameter which is not used within the function implementation.

Reviewed-by: Hante Meuleman <meuleman@broadcom.com>
Reviewed-by: Franky (Zhenhui) Lin <frankyl@broadcom.com>
Reviewed-by: Pieter-Paul Giesberts <pieterpg@broadcom.com>
Signed-off-by: Arend van Spriel <arend@broadcom.com>
---
 drivers/net/wireless/brcm80211/brcmfmac/fwsignal.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/net/wireless/brcm80211/brcmfmac/fwsignal.c b/drivers/net/wireless/brcm80211/brcmfmac/fwsignal.c
index dc4844c..ed12486 100644
--- a/drivers/net/wireless/brcm80211/brcmfmac/fwsignal.c
+++ b/drivers/net/wireless/brcm80211/brcmfmac/fwsignal.c
@@ -1398,7 +1398,7 @@ done:
 }
 
 static int brcmf_fws_txstatus_suppressed(struct brcmf_fws_info *fws, int fifo,
-					 struct sk_buff *skb, u8 ifidx,
+					 struct sk_buff *skb,
 					 u32 genbit, u16 seq)
 {
 	struct brcmf_fws_mac_descriptor *entry = brcmf_skbcb(skb)->mac;
@@ -1503,7 +1503,7 @@ brcmf_fws_txs_process(struct brcmf_fws_info *fws, u8 flags, u32 hslot,
 		return -EINVAL;
 	}
 	if (!remove_from_hanger)
-		ret = brcmf_fws_txstatus_suppressed(fws, fifo, skb, ifp->ifidx,
+		ret = brcmf_fws_txstatus_suppressed(fws, fifo, skb,
 						    genbit, seq);
 	if (remove_from_hanger || ret)
 		brcmf_txfinalize(ifp, skb, true);
-- 
1.9.1

