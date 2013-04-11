Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mms1.broadcom.com ([216.31.210.17]:4995 "EHLO mms1.broadcom.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754735Ab3DKL3Z (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 11 Apr 2013 07:29:25 -0400
From: "Arend van Spriel" <arend@broadcom.com>
To: "John W. Linville" <linville@tuxdriver.com>
cc: linux-wireless <linux-wireless@vger.kernel.org>,
	"Arend van Spriel" <arend@broadcom.com>
Subject: [PATCH 15/15] brcmfmac: remove ifidx variable from
 brcmf_fws_process_skb()
Date: Thu, 11 Apr 2013 13:29:00 +0200
Message-ID: <1365679740-25679-16-git-send-email-arend@broadcom.com> (sfid-20130411_132941_724400_BFAEFA3A)
In-Reply-To: <1365679740-25679-1-git-send-email-arend@broadcom.com>
References: <1365679740-25679-1-git-send-email-arend@broadcom.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

The value can be obtained from the struct brcmf_if object pointer
and it is used only twice.

Reviewed-by: Hante Meuleman <meuleman@broadcom.com>
Reviewed-by: Pieter-Paul Giesberts <pieterpg@broadcom.com>
Signed-off-by: Arend van Spriel <arend@broadcom.com>
---
 drivers/net/wireless/brcm80211/brcmfmac/fwsignal.c |    5 ++---
 1 file changed, 2 insertions(+), 3 deletions(-)

diff --git a/drivers/net/wireless/brcm80211/brcmfmac/fwsignal.c b/drivers/net/wireless/brcm80211/brcmfmac/fwsignal.c
index 9b1f4ef..c03ecb8 100644
--- a/drivers/net/wireless/brcm80211/brcmfmac/fwsignal.c
+++ b/drivers/net/wireless/brcm80211/brcmfmac/fwsignal.c
@@ -1718,7 +1718,6 @@ int brcmf_fws_process_skb(struct brcmf_if *ifp, struct sk_buff *skb)
 	struct brcmf_skbuff_cb *skcb = brcmf_skbcb(skb);
 	struct ethhdr *eh = (struct ethhdr *)(skb->data);
 	ulong flags;
-	u8 ifidx = ifp->ifidx;
 	int fifo = BRCMF_FWS_FIFO_BCMC;
 	bool multicast = is_multicast_ether_addr(eh->h_dest);
 
@@ -1732,7 +1731,7 @@ int brcmf_fws_process_skb(struct brcmf_if *ifp, struct sk_buff *skb)
 
 	if (!brcmf_fws_fc_active(drvr->fws)) {
 		/* If the protocol uses a data header, apply it */
-		brcmf_proto_hdrpush(drvr, ifidx, 0, skb);
+		brcmf_proto_hdrpush(drvr, ifp->ifidx, 0, skb);
 
 		/* Use bus module to send data frame */
 		return brcmf_bus_txdata(drvr->bus_if, skb);
@@ -1742,7 +1741,7 @@ int brcmf_fws_process_skb(struct brcmf_if *ifp, struct sk_buff *skb)
 	skcb->if_flags = 0;
 	skcb->mac = brcmf_fws_find_mac_desc(drvr->fws, ifp, eh->h_dest);
 	skcb->state = BRCMF_FWS_SKBSTATE_NEW;
-	brcmf_skb_if_flags_set_field(skb, INDEX, ifidx);
+	brcmf_skb_if_flags_set_field(skb, INDEX, ifp->ifidx);
 	if (!multicast)
 		fifo = brcmf_fws_prio2fifo[skb->priority];
 	brcmf_skb_if_flags_set_field(skb, FIFO, fifo);
-- 
1.7.10.4


