Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-gw1-out.broadcom.com ([216.31.210.62]:40693 "EHLO
	mail-gw1-out.broadcom.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757257AbbJ2Tnu (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 29 Oct 2015 15:43:50 -0400
From: Arend van Spriel <arend@broadcom.com>
To: Kalle Valo <kvalo@codeaurora.org>
CC: linux-wireless <linux-wireless@vger.kernel.org>,
	Hante Meuleman <meuleman@broadcom.com>,
	Arend van Spriel <arend@broadcom.com>
Subject: [PATCH 2/9] brcmfmac: Simplify and fix usage of brcmf_ifname.
Date: Thu, 29 Oct 2015 20:33:12 +0100
Message-ID: <1446147199-21671-3-git-send-email-arend@broadcom.com> (sfid-20151029_204355_511229_CF9C501A)
In-Reply-To: <1446147199-21671-1-git-send-email-arend@broadcom.com>
References: <1446147199-21671-1-git-send-email-arend@broadcom.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Hante Meuleman <meuleman@broadcom.com>

brcmf_ifname is a debug function to return a name related to an ifp,
but is using a rather complex implementation. It was also used
wrongly from bcdc as it did not use the bsscfgidx as it was supposed
to, but bssidx. This patch fixes that bug and simplifies
brcmf_ifname.

Reviewed-by: Arend Van Spriel <arend@broadcom.com>
Reviewed-by: Pieter-Paul Giesberts <pieterpg@broadcom.com>
Signed-off-by: Hante Meuleman <meuleman@broadcom.com>
Signed-off-by: Arend van Spriel <arend@broadcom.com>
---
 drivers/net/wireless/brcm80211/brcmfmac/bcdc.c | 10 ++++++----
 drivers/net/wireless/brcm80211/brcmfmac/core.c | 19 ++++++-------------
 drivers/net/wireless/brcm80211/brcmfmac/core.h |  2 +-
 3 files changed, 13 insertions(+), 18 deletions(-)

diff --git a/drivers/net/wireless/brcm80211/brcmfmac/bcdc.c b/drivers/net/wireless/brcm80211/brcmfmac/bcdc.c
index 288c84e..6af658e 100644
--- a/drivers/net/wireless/brcm80211/brcmfmac/bcdc.c
+++ b/drivers/net/wireless/brcm80211/brcmfmac/bcdc.c
@@ -187,7 +187,8 @@ retry:
 		goto retry;
 	if (id != bcdc->reqid) {
 		brcmf_err("%s: unexpected request id %d (expected %d)\n",
-			  brcmf_ifname(drvr, ifidx), id, bcdc->reqid);
+			  brcmf_ifname(brcmf_get_ifp(drvr, ifidx)), id,
+			  bcdc->reqid);
 		ret = -EINVAL;
 		goto done;
 	}
@@ -234,7 +235,8 @@ brcmf_proto_bcdc_set_dcmd(struct brcmf_pub *drvr, int ifidx, uint cmd,
 
 	if (id != bcdc->reqid) {
 		brcmf_err("%s: unexpected request id %d (expected %d)\n",
-			  brcmf_ifname(drvr, ifidx), id, bcdc->reqid);
+			  brcmf_ifname(brcmf_get_ifp(drvr, ifidx)), id,
+			  bcdc->reqid);
 		ret = -EINVAL;
 		goto done;
 	}
@@ -298,13 +300,13 @@ brcmf_proto_bcdc_hdrpull(struct brcmf_pub *drvr, bool do_fws,
 	if (((h->flags & BCDC_FLAG_VER_MASK) >> BCDC_FLAG_VER_SHIFT) !=
 	    BCDC_PROTO_VER) {
 		brcmf_err("%s: non-BCDC packet received, flags 0x%x\n",
-			  brcmf_ifname(drvr, tmp_if->ifidx), h->flags);
+			  brcmf_ifname(tmp_if), h->flags);
 		return -EBADE;
 	}
 
 	if (h->flags & BCDC_FLAG_SUM_GOOD) {
 		brcmf_dbg(BCDC, "%s: BDC rcv, good checksum, flags 0x%x\n",
-			  brcmf_ifname(drvr, tmp_if->ifidx), h->flags);
+			  brcmf_ifname(tmp_if), h->flags);
 		pktbuf->ip_summed = CHECKSUM_UNNECESSARY;
 	}
 
diff --git a/drivers/net/wireless/brcm80211/brcmfmac/core.c b/drivers/net/wireless/brcm80211/brcmfmac/core.c
index b5ab98e..76b66bc 100644
--- a/drivers/net/wireless/brcm80211/brcmfmac/core.c
+++ b/drivers/net/wireless/brcm80211/brcmfmac/core.c
@@ -66,20 +66,13 @@ static int brcmf_p2p_enable;
 module_param_named(p2pon, brcmf_p2p_enable, int, 0);
 MODULE_PARM_DESC(p2pon, "enable legacy p2p management functionality");
 
-char *brcmf_ifname(struct brcmf_pub *drvr, int ifidx)
+char *brcmf_ifname(struct brcmf_if *ifp)
 {
-	if (ifidx < 0 || ifidx >= BRCMF_MAX_IFS) {
-		brcmf_err("ifidx %d out of range\n", ifidx);
-		return "<if_bad>";
-	}
-
-	if (drvr->iflist[ifidx] == NULL) {
-		brcmf_err("null i/f %d\n", ifidx);
+	if (!ifp)
 		return "<if_null>";
-	}
 
-	if (drvr->iflist[ifidx]->ndev)
-		return drvr->iflist[ifidx]->ndev->name;
+	if (ifp->ndev)
+		return ifp->ndev->name;
 
 	return "<if_none>";
 }
@@ -237,14 +230,14 @@ static netdev_tx_t brcmf_netdev_start_xmit(struct sk_buff *skb,
 		struct sk_buff *skb2;
 
 		brcmf_dbg(INFO, "%s: insufficient headroom\n",
-			  brcmf_ifname(drvr, ifp->bssidx));
+			  brcmf_ifname(ifp));
 		drvr->bus_if->tx_realloc++;
 		skb2 = skb_realloc_headroom(skb, drvr->hdrlen);
 		dev_kfree_skb(skb);
 		skb = skb2;
 		if (skb == NULL) {
 			brcmf_err("%s: skb_realloc_headroom failed\n",
-				  brcmf_ifname(drvr, ifp->bssidx));
+				  brcmf_ifname(ifp));
 			ret = -ENOMEM;
 			goto done;
 		}
diff --git a/drivers/net/wireless/brcm80211/brcmfmac/core.h b/drivers/net/wireless/brcm80211/brcmfmac/core.h
index 2f9101b..673d697 100644
--- a/drivers/net/wireless/brcm80211/brcmfmac/core.h
+++ b/drivers/net/wireless/brcm80211/brcmfmac/core.h
@@ -205,7 +205,7 @@ struct brcmf_skb_reorder_data {
 int brcmf_netdev_wait_pend8021x(struct brcmf_if *ifp);
 
 /* Return pointer to interface name */
-char *brcmf_ifname(struct brcmf_pub *drvr, int idx);
+char *brcmf_ifname(struct brcmf_if *ifp);
 struct brcmf_if *brcmf_get_ifp(struct brcmf_pub *drvr, int ifidx);
 int brcmf_net_attach(struct brcmf_if *ifp, bool rtnl_locked);
 struct brcmf_if *brcmf_add_if(struct brcmf_pub *drvr, s32 bssidx, s32 ifidx,
-- 
1.9.1

