Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mms2.broadcom.com ([216.31.210.18]:4193 "EHLO mms2.broadcom.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932106Ab3GVKqa (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 22 Jul 2013 06:46:30 -0400
From: "Arend van Spriel" <arend@broadcom.com>
To: "John W. Linville" <linville@tuxdriver.com>
cc: linux-wireless <linux-wireless@vger.kernel.org>,
	"Arend van Spriel" <arend@broadcom.com>
Subject: [PATCH for-3.11 1/2] brcmfmac: decrement pending 8021x count
 upon tx failure
Date: Mon, 22 Jul 2013 12:46:23 +0200
Message-ID: <1374489984-18250-2-git-send-email-arend@broadcom.com> (sfid-20130722_124635_315134_0F510666)
In-Reply-To: <1374489984-18250-1-git-send-email-arend@broadcom.com>
References: <1374489984-18250-1-git-send-email-arend@broadcom.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

If the transmit fails because there are no hanger slots or
any other reason and the packet was an EAPOL packet the
pending coutner should be decreased although it was not
transmitted so the driver does not end up in a dead-lock.

Reviewed-by: Hante Meuleman <meuleman@broadcom.com>
Reviewed-by: Pieter-Paul Giesberts <pieterpg@broadcom.com>
Signed-off-by: Arend van Spriel <arend@broadcom.com>
---
 drivers/net/wireless/brcm80211/brcmfmac/fwsignal.c |    8 +++++++-
 1 file changed, 7 insertions(+), 1 deletion(-)

diff --git a/drivers/net/wireless/brcm80211/brcmfmac/fwsignal.c b/drivers/net/wireless/brcm80211/brcmfmac/fwsignal.c
index f0d9f7f..29b1f24 100644
--- a/drivers/net/wireless/brcm80211/brcmfmac/fwsignal.c
+++ b/drivers/net/wireless/brcm80211/brcmfmac/fwsignal.c
@@ -1744,13 +1744,14 @@ int brcmf_fws_process_skb(struct brcmf_if *ifp, struct sk_buff *skb)
 	ulong flags;
 	int fifo = BRCMF_FWS_FIFO_BCMC;
 	bool multicast = is_multicast_ether_addr(eh->h_dest);
+	bool pae = eh->h_proto == htons(ETH_P_PAE);
 
 	/* determine the priority */
 	if (!skb->priority)
 		skb->priority = cfg80211_classify8021d(skb);
 
 	drvr->tx_multicast += !!multicast;
-	if (ntohs(eh->h_proto) == ETH_P_PAE)
+	if (pae)
 		atomic_inc(&ifp->pend_8021x_cnt);
 
 	if (!brcmf_fws_fc_active(fws)) {
@@ -1781,6 +1782,11 @@ int brcmf_fws_process_skb(struct brcmf_if *ifp, struct sk_buff *skb)
 		brcmf_fws_schedule_deq(fws);
 	} else {
 		brcmf_err("drop skb: no hanger slot\n");
+		if (pae) {
+			atomic_dec(&ifp->pend_8021x_cnt);
+			if (waitqueue_active(&ifp->pend_8021x_wait))
+				wake_up(&ifp->pend_8021x_wait);
+		}
 		brcmu_pkt_buf_free_skb(skb);
 	}
 	brcmf_fws_unlock(drvr, flags);
-- 
1.7.10.4


