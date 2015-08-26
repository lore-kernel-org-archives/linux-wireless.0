Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-gw3-out.broadcom.com ([216.31.210.64]:41368 "EHLO
	mail-gw3-out.broadcom.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752289AbbHZUPM (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 26 Aug 2015 16:15:12 -0400
From: Arend van Spriel <arend@broadcom.com>
To: Kalle Valo <kvalo@codeaurora.org>
CC: linux-wireless <linux-wireless@vger.kernel.org>,
	Arend van Spriel <arend@broadcom.com>
Subject: [PATCH 01/12] brcmfmac: consolidate ifp lookup in driver core
Date: Wed, 26 Aug 2015 22:14:53 +0200
Message-ID: <1440620104-2715-2-git-send-email-arend@broadcom.com> (sfid-20150826_223108_811185_26D783D9)
In-Reply-To: <1440620104-2715-1-git-send-email-arend@broadcom.com>
References: <1440620104-2715-1-git-send-email-arend@broadcom.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

In rx path the firmware provide an interface index which is used to
map to a struct brcmf_if instance. However, this involves some trick
that is done in two places. This is changed by having driver core
providing brcmf_get_ifp() function.

Reviewed-by: Hante Meuleman <meuleman@broadcom.com>
Reviewed-by: Franky (Zhenhui) Lin <frankyl@broadcom.com>
Reviewed-by: Pieter-Paul Giesberts <pieterpg@broadcom.com>
Signed-off-by: Arend van Spriel <arend@broadcom.com>
---
 drivers/net/wireless/brcm80211/brcmfmac/bcdc.c   | 25 ++++++++++--------------
 drivers/net/wireless/brcm80211/brcmfmac/core.c   | 19 ++++++++++++++++++
 drivers/net/wireless/brcm80211/brcmfmac/core.h   |  2 +-
 drivers/net/wireless/brcm80211/brcmfmac/msgbuf.c | 12 ++----------
 4 files changed, 32 insertions(+), 26 deletions(-)

diff --git a/drivers/net/wireless/brcm80211/brcmfmac/bcdc.c b/drivers/net/wireless/brcm80211/brcmfmac/bcdc.c
index 8e0e91c..83aa6a0 100644
--- a/drivers/net/wireless/brcm80211/brcmfmac/bcdc.c
+++ b/drivers/net/wireless/brcm80211/brcmfmac/bcdc.c
@@ -276,6 +276,7 @@ brcmf_proto_bcdc_hdrpull(struct brcmf_pub *drvr, bool do_fws, u8 *ifidx,
 			 struct sk_buff *pktbuf)
 {
 	struct brcmf_proto_bcdc_header *h;
+	struct brcmf_if *ifp;
 
 	brcmf_dbg(BCDC, "Enter\n");
 
@@ -289,30 +290,21 @@ brcmf_proto_bcdc_hdrpull(struct brcmf_pub *drvr, bool do_fws, u8 *ifidx,
 	trace_brcmf_bcdchdr(pktbuf->data);
 	h = (struct brcmf_proto_bcdc_header *)(pktbuf->data);
 
-	*ifidx = BCDC_GET_IF_IDX(h);
-	if (*ifidx >= BRCMF_MAX_IFS) {
-		brcmf_err("rx data ifnum out of range (%d)\n", *ifidx);
+	ifp = brcmf_get_ifp(drvr, BCDC_GET_IF_IDX(h));
+	if (IS_ERR_OR_NULL(ifp)) {
+		brcmf_dbg(INFO, "no matching ifp found\n");
 		return -EBADE;
 	}
-	/* The ifidx is the idx to map to matching netdev/ifp. When receiving
-	 * events this is easy because it contains the bssidx which maps
-	 * 1-on-1 to the netdev/ifp. But for data frames the ifidx is rcvd.
-	 * bssidx 1 is used for p2p0 and no data can be received or
-	 * transmitted on it. Therefor bssidx is ifidx + 1 if ifidx > 0
-	 */
-	if (*ifidx)
-		(*ifidx)++;
-
 	if (((h->flags & BCDC_FLAG_VER_MASK) >> BCDC_FLAG_VER_SHIFT) !=
 	    BCDC_PROTO_VER) {
 		brcmf_err("%s: non-BCDC packet received, flags 0x%x\n",
-			  brcmf_ifname(drvr, *ifidx), h->flags);
+			  brcmf_ifname(drvr, ifp->ifidx), h->flags);
 		return -EBADE;
 	}
 
 	if (h->flags & BCDC_FLAG_SUM_GOOD) {
 		brcmf_dbg(BCDC, "%s: BDC rcv, good checksum, flags 0x%x\n",
-			  brcmf_ifname(drvr, *ifidx), h->flags);
+			  brcmf_ifname(drvr, ifp->ifidx), h->flags);
 		pktbuf->ip_summed = CHECKSUM_UNNECESSARY;
 	}
 
@@ -320,12 +312,15 @@ brcmf_proto_bcdc_hdrpull(struct brcmf_pub *drvr, bool do_fws, u8 *ifidx,
 
 	skb_pull(pktbuf, BCDC_HEADER_LEN);
 	if (do_fws)
-		brcmf_fws_hdrpull(drvr, *ifidx, h->data_offset << 2, pktbuf);
+		brcmf_fws_hdrpull(drvr, ifp->ifidx, h->data_offset << 2,
+				  pktbuf);
 	else
 		skb_pull(pktbuf, h->data_offset << 2);
 
 	if (pktbuf->len == 0)
 		return -ENODATA;
+
+	*ifidx = ifp->ifidx;
 	return 0;
 }
 
diff --git a/drivers/net/wireless/brcm80211/brcmfmac/core.c b/drivers/net/wireless/brcm80211/brcmfmac/core.c
index fe9d3fb..1747d59 100644
--- a/drivers/net/wireless/brcm80211/brcmfmac/core.c
+++ b/drivers/net/wireless/brcm80211/brcmfmac/core.c
@@ -83,6 +83,25 @@ char *brcmf_ifname(struct brcmf_pub *drvr, int ifidx)
 	return "<if_none>";
 }
 
+struct brcmf_if *brcmf_get_ifp(struct brcmf_pub *drvr, int ifidx)
+{
+	if (ifidx < 0 || ifidx >= BRCMF_MAX_IFS) {
+		brcmf_err("ifidx %d out of range\n", ifidx);
+		return ERR_PTR(-ERANGE);
+	}
+
+	/* The ifidx is the idx to map to matching netdev/ifp. When receiving
+	 * events this is easy because it contains the bssidx which maps
+	 * 1-on-1 to the netdev/ifp. But for data frames the ifidx is rcvd.
+	 * bssidx 1 is used for p2p0 and no data can be received or
+	 * transmitted on it. Therefor bssidx is ifidx + 1 if ifidx > 0
+	 */
+	if (ifidx)
+		ifidx++;
+
+	return drvr->iflist[ifidx];
+}
+
 static void _brcmf_set_multicast_list(struct work_struct *work)
 {
 	struct brcmf_if *ifp;
diff --git a/drivers/net/wireless/brcm80211/brcmfmac/core.h b/drivers/net/wireless/brcm80211/brcmfmac/core.h
index 7463041..1dc5b96 100644
--- a/drivers/net/wireless/brcm80211/brcmfmac/core.h
+++ b/drivers/net/wireless/brcm80211/brcmfmac/core.h
@@ -202,7 +202,7 @@ int brcmf_netdev_wait_pend8021x(struct brcmf_if *ifp);
 
 /* Return pointer to interface name */
 char *brcmf_ifname(struct brcmf_pub *drvr, int idx);
-
+struct brcmf_if *brcmf_get_ifp(struct brcmf_pub *drvr, int ifidx);
 int brcmf_net_attach(struct brcmf_if *ifp, bool rtnl_locked);
 struct brcmf_if *brcmf_add_if(struct brcmf_pub *drvr, s32 bssidx, s32 ifidx,
 			      char *name, u8 *mac_addr);
diff --git a/drivers/net/wireless/brcm80211/brcmfmac/msgbuf.c b/drivers/net/wireless/brcm80211/brcmfmac/msgbuf.c
index 7b2136c..1271d1d 100644
--- a/drivers/net/wireless/brcm80211/brcmfmac/msgbuf.c
+++ b/drivers/net/wireless/brcm80211/brcmfmac/msgbuf.c
@@ -1081,16 +1081,8 @@ brcmf_msgbuf_rx_skb(struct brcmf_msgbuf *msgbuf, struct sk_buff *skb,
 {
 	struct brcmf_if *ifp;
 
-	/* The ifidx is the idx to map to matching netdev/ifp. When receiving
-	 * events this is easy because it contains the bssidx which maps
-	 * 1-on-1 to the netdev/ifp. But for data frames the ifidx is rcvd.
-	 * bssidx 1 is used for p2p0 and no data can be received or
-	 * transmitted on it. Therefor bssidx is ifidx + 1 if ifidx > 0
-	 */
-	if (ifidx)
-		(ifidx)++;
-	ifp = msgbuf->drvr->iflist[ifidx];
-	if (!ifp || !ifp->ndev) {
+	ifp = brcmf_get_ifp(msgbuf->drvr, ifidx);
+	if (IS_ERR_OR_NULL(ifp) || !ifp->ndev) {
 		brcmf_err("Received pkt for invalid ifidx %d\n", ifidx);
 		brcmu_pkt_buf_free_skb(skb);
 		return;
-- 
1.9.1

