Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mms3.broadcom.com ([216.31.210.19]:1406 "EHLO mms3.broadcom.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759015Ab3E2QjT (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 29 May 2013 12:39:19 -0400
From: "Arend van Spriel" <arend@broadcom.com>
To: "John W. Linville" <linville@tuxdriver.com>
cc: linux-wireless <linux-wireless@vger.kernel.org>,
	"Arend van Spriel" <arend@broadcom.com>
Subject: [PATCH for 3.10 02/16] brcmfmac: remove fifo bitfield from
 brcmf_skbuff_cb::if_flags
Date: Wed, 29 May 2013 18:38:52 +0200
Message-ID: <1369845546-31950-3-git-send-email-arend@broadcom.com> (sfid-20130529_183931_799706_FA054B6F)
In-Reply-To: <1369845546-31950-1-git-send-email-arend@broadcom.com>
References: <1369845546-31950-1-git-send-email-arend@broadcom.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

The brcmf_skbuff_cb structure contain if_flags and htod fields. Both
have a bitfield defined to hold the fifo number. With a small code
change we get rid of the fifo bitfield in if_flags.

Reviewed-by: Hante Meuleman <meuleman@broadcom.com>
Reviewed-by: Pieter-Paul Giesberts <pieterpg@broadcom.com>
Signed-off-by: Arend van Spriel <arend@broadcom.com>
---
 drivers/net/wireless/brcm80211/brcmfmac/fwsignal.c |   11 +++--------
 1 file changed, 3 insertions(+), 8 deletions(-)

diff --git a/drivers/net/wireless/brcm80211/brcmfmac/fwsignal.c b/drivers/net/wireless/brcm80211/brcmfmac/fwsignal.c
index d6f05ae..bc2edc0 100644
--- a/drivers/net/wireless/brcm80211/brcmfmac/fwsignal.c
+++ b/drivers/net/wireless/brcm80211/brcmfmac/fwsignal.c
@@ -195,7 +195,6 @@ struct brcmf_skbuff_cb {
  *	b[9]   - packet is a tx packet.
  *	b[8]   - packet uses FIFO credit (non-pspoll).
  *	b[7]   - interface in AP mode.
- *	b[6:4] - AC FIFO number.
  *	b[3:0] - interface index.
  */
 #define BRCMF_SKB_IF_FLAGS_REQUESTED_MASK	0x0800
@@ -208,8 +207,6 @@ struct brcmf_skbuff_cb {
 #define BRCMF_SKB_IF_FLAGS_CREDITCHECK_SHIFT	8
 #define BRCMF_SKB_IF_FLAGS_IF_AP_MASK		0x0080
 #define BRCMF_SKB_IF_FLAGS_IF_AP_SHIFT		7
-#define BRCMF_SKB_IF_FLAGS_FIFO_MASK		0x0070
-#define BRCMF_SKB_IF_FLAGS_FIFO_SHIFT		4
 #define BRCMF_SKB_IF_FLAGS_INDEX_MASK		0x000f
 #define BRCMF_SKB_IF_FLAGS_INDEX_SHIFT		0
 
@@ -1608,7 +1605,8 @@ static int brcmf_fws_precommit_skb(struct brcmf_fws_info *fws, int fifo,
 }
 
 static void
-brcmf_fws_rollback_toq(struct brcmf_fws_info *fws, struct sk_buff *skb)
+brcmf_fws_rollback_toq(struct brcmf_fws_info *fws,
+		       struct sk_buff *skb, int fifo)
 {
 	/*
 	put the packet back to the head of queue
@@ -1622,11 +1620,9 @@ brcmf_fws_rollback_toq(struct brcmf_fws_info *fws, struct sk_buff *skb)
 	enum brcmf_fws_skb_state state;
 	struct sk_buff *pktout;
 	int rc = 0;
-	int fifo;
 	int hslot;
 	u8 ifidx;
 
-	fifo = brcmf_skb_if_flags_get_field(skb, FIFO);
 	state = brcmf_skbcb(skb)->state;
 	entry = brcmf_skbcb(skb)->mac;
 
@@ -1794,7 +1790,7 @@ static int brcmf_fws_commit_skb(struct brcmf_fws_info *fws, int fifo,
 	return rc;
 
 rollback:
-	brcmf_fws_rollback_toq(fws, skb);
+	brcmf_fws_rollback_toq(fws, skb, fifo);
 	return rc;
 }
 
@@ -1831,7 +1827,6 @@ int brcmf_fws_process_skb(struct brcmf_if *ifp, struct sk_buff *skb)
 	brcmf_skb_if_flags_set_field(skb, INDEX, ifp->ifidx);
 	if (!multicast)
 		fifo = brcmf_fws_prio2fifo[skb->priority];
-	brcmf_skb_if_flags_set_field(skb, FIFO, fifo);
 
 	brcmf_dbg(TRACE, "ea=%pM, multi=%d, fifo=%d\n", eh->h_dest,
 		  multicast, fifo);
-- 
1.7.10.4


