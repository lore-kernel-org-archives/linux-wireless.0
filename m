Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-gw2-out.broadcom.com ([216.31.210.63]:56115 "EHLO
	mail-gw2-out.broadcom.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752110AbbHZUPM (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 26 Aug 2015 16:15:12 -0400
From: Arend van Spriel <arend@broadcom.com>
To: Kalle Valo <kvalo@codeaurora.org>
CC: linux-wireless <linux-wireless@vger.kernel.org>,
	Arend van Spriel <arend@broadcom.com>
Subject: [PATCH 02/12] brcmfmac: make brcmf_proto_hdrpull() return struct brcmf_if instance
Date: Wed, 26 Aug 2015 22:14:54 +0200
Message-ID: <1440620104-2715-3-git-send-email-arend@broadcom.com> (sfid-20150826_221520_626887_2CC8E647)
In-Reply-To: <1440620104-2715-1-git-send-email-arend@broadcom.com>
References: <1440620104-2715-1-git-send-email-arend@broadcom.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Avoid spreading the ifidx in the driver, but have it return the
struct brcmf_if instance.

Reviewed-by: Hante Meuleman <meuleman@broadcom.com>
Reviewed-by: Franky (Zhenhui) Lin <frankyl@broadcom.com>
Reviewed-by: Pieter-Paul Giesberts <pieterpg@broadcom.com>
Signed-off-by: Arend van Spriel <arend@broadcom.com>
---
 drivers/net/wireless/brcm80211/brcmfmac/bcdc.c     | 18 +++++++++---------
 drivers/net/wireless/brcm80211/brcmfmac/core.c     | 14 ++++++--------
 drivers/net/wireless/brcm80211/brcmfmac/fwsignal.c | 11 ++++++-----
 drivers/net/wireless/brcm80211/brcmfmac/msgbuf.c   |  4 ++--
 drivers/net/wireless/brcm80211/brcmfmac/proto.h    | 18 ++++++++++++++----
 5 files changed, 37 insertions(+), 28 deletions(-)

diff --git a/drivers/net/wireless/brcm80211/brcmfmac/bcdc.c b/drivers/net/wireless/brcm80211/brcmfmac/bcdc.c
index 83aa6a0..aa5ed65 100644
--- a/drivers/net/wireless/brcm80211/brcmfmac/bcdc.c
+++ b/drivers/net/wireless/brcm80211/brcmfmac/bcdc.c
@@ -272,11 +272,11 @@ brcmf_proto_bcdc_hdrpush(struct brcmf_pub *drvr, int ifidx, u8 offset,
 }
 
 static int
-brcmf_proto_bcdc_hdrpull(struct brcmf_pub *drvr, bool do_fws, u8 *ifidx,
-			 struct sk_buff *pktbuf)
+brcmf_proto_bcdc_hdrpull(struct brcmf_pub *drvr, bool do_fws,
+			 struct sk_buff *pktbuf, struct brcmf_if **ifp)
 {
 	struct brcmf_proto_bcdc_header *h;
-	struct brcmf_if *ifp;
+	struct brcmf_if *tmp_if;
 
 	brcmf_dbg(BCDC, "Enter\n");
 
@@ -290,21 +290,21 @@ brcmf_proto_bcdc_hdrpull(struct brcmf_pub *drvr, bool do_fws, u8 *ifidx,
 	trace_brcmf_bcdchdr(pktbuf->data);
 	h = (struct brcmf_proto_bcdc_header *)(pktbuf->data);
 
-	ifp = brcmf_get_ifp(drvr, BCDC_GET_IF_IDX(h));
-	if (IS_ERR_OR_NULL(ifp)) {
+	tmp_if = brcmf_get_ifp(drvr, BCDC_GET_IF_IDX(h));
+	if (!tmp_if) {
 		brcmf_dbg(INFO, "no matching ifp found\n");
 		return -EBADE;
 	}
 	if (((h->flags & BCDC_FLAG_VER_MASK) >> BCDC_FLAG_VER_SHIFT) !=
 	    BCDC_PROTO_VER) {
 		brcmf_err("%s: non-BCDC packet received, flags 0x%x\n",
-			  brcmf_ifname(drvr, ifp->ifidx), h->flags);
+			  brcmf_ifname(drvr, tmp_if->ifidx), h->flags);
 		return -EBADE;
 	}
 
 	if (h->flags & BCDC_FLAG_SUM_GOOD) {
 		brcmf_dbg(BCDC, "%s: BDC rcv, good checksum, flags 0x%x\n",
-			  brcmf_ifname(drvr, ifp->ifidx), h->flags);
+			  brcmf_ifname(drvr, tmp_if->ifidx), h->flags);
 		pktbuf->ip_summed = CHECKSUM_UNNECESSARY;
 	}
 
@@ -312,7 +312,7 @@ brcmf_proto_bcdc_hdrpull(struct brcmf_pub *drvr, bool do_fws, u8 *ifidx,
 
 	skb_pull(pktbuf, BCDC_HEADER_LEN);
 	if (do_fws)
-		brcmf_fws_hdrpull(drvr, ifp->ifidx, h->data_offset << 2,
+		brcmf_fws_hdrpull(drvr, tmp_if->ifidx, h->data_offset << 2,
 				  pktbuf);
 	else
 		skb_pull(pktbuf, h->data_offset << 2);
@@ -320,7 +320,7 @@ brcmf_proto_bcdc_hdrpull(struct brcmf_pub *drvr, bool do_fws, u8 *ifidx,
 	if (pktbuf->len == 0)
 		return -ENODATA;
 
-	*ifidx = ifp->ifidx;
+	*ifp = tmp_if;
 	return 0;
 }
 
diff --git a/drivers/net/wireless/brcm80211/brcmfmac/core.c b/drivers/net/wireless/brcm80211/brcmfmac/core.c
index 1747d59..1f65ce8 100644
--- a/drivers/net/wireless/brcm80211/brcmfmac/core.c
+++ b/drivers/net/wireless/brcm80211/brcmfmac/core.c
@@ -87,7 +87,7 @@ struct brcmf_if *brcmf_get_ifp(struct brcmf_pub *drvr, int ifidx)
 {
 	if (ifidx < 0 || ifidx >= BRCMF_MAX_IFS) {
 		brcmf_err("ifidx %d out of range\n", ifidx);
-		return ERR_PTR(-ERANGE);
+		return NULL;
 	}
 
 	/* The ifidx is the idx to map to matching netdev/ifp. When receiving
@@ -539,17 +539,15 @@ void brcmf_rx_frame(struct device *dev, struct sk_buff *skb)
 	struct brcmf_bus *bus_if = dev_get_drvdata(dev);
 	struct brcmf_pub *drvr = bus_if->drvr;
 	struct brcmf_skb_reorder_data *rd;
-	u8 ifidx;
 	int ret;
 
 	brcmf_dbg(DATA, "Enter: %s: rxp=%p\n", dev_name(dev), skb);
 
 	/* process and remove protocol-specific header */
-	ret = brcmf_proto_hdrpull(drvr, true, &ifidx, skb);
-	ifp = drvr->iflist[ifidx];
+	ret = brcmf_proto_hdrpull(drvr, true, skb, &ifp);
 
 	if (ret || !ifp || !ifp->ndev) {
-		if ((ret != -ENODATA) && ifp)
+		if (ret != -ENODATA && ifp)
 			ifp->stats.rx_errors++;
 		brcmu_pkt_buf_free_skb(skb);
 		return;
@@ -592,17 +590,17 @@ void brcmf_txcomplete(struct device *dev, struct sk_buff *txp, bool success)
 {
 	struct brcmf_bus *bus_if = dev_get_drvdata(dev);
 	struct brcmf_pub *drvr = bus_if->drvr;
-	u8 ifidx;
+	struct brcmf_if *ifp;
 
 	/* await txstatus signal for firmware if active */
 	if (brcmf_fws_fc_active(drvr->fws)) {
 		if (!success)
 			brcmf_fws_bustxfail(drvr->fws, txp);
 	} else {
-		if (brcmf_proto_hdrpull(drvr, false, &ifidx, txp))
+		if (brcmf_proto_hdrpull(drvr, false, txp, &ifp))
 			brcmu_pkt_buf_free_skb(txp);
 		else
-			brcmf_txfinalize(drvr, txp, ifidx, success);
+			brcmf_txfinalize(drvr, txp, ifp->ifidx, success);
 	}
 }
 
diff --git a/drivers/net/wireless/brcm80211/brcmfmac/fwsignal.c b/drivers/net/wireless/brcm80211/brcmfmac/fwsignal.c
index 5017eaa..fd43873 100644
--- a/drivers/net/wireless/brcm80211/brcmfmac/fwsignal.c
+++ b/drivers/net/wireless/brcm80211/brcmfmac/fwsignal.c
@@ -1448,7 +1448,7 @@ brcmf_fws_txs_process(struct brcmf_fws_info *fws, u8 flags, u32 hslot,
 	struct sk_buff *skb;
 	struct brcmf_skbuff_cb *skcb;
 	struct brcmf_fws_mac_descriptor *entry = NULL;
-	u8 ifidx;
+	struct brcmf_if *ifp;
 
 	brcmf_dbg(DATA, "flags %d\n", flags);
 
@@ -1497,15 +1497,16 @@ brcmf_fws_txs_process(struct brcmf_fws_info *fws, u8 flags, u32 hslot,
 	}
 	brcmf_fws_macdesc_return_req_credit(skb);
 
-	if (brcmf_proto_hdrpull(fws->drvr, false, &ifidx, skb)) {
+	ret = brcmf_proto_hdrpull(fws->drvr, false, skb, &ifp);
+	if (ret) {
 		brcmu_pkt_buf_free_skb(skb);
 		return -EINVAL;
 	}
 	if (!remove_from_hanger)
-		ret = brcmf_fws_txstatus_suppressed(fws, fifo, skb, ifidx,
+		ret = brcmf_fws_txstatus_suppressed(fws, fifo, skb, ifp->ifidx,
 						    genbit, seq);
 	if (remove_from_hanger || ret)
-		brcmf_txfinalize(fws->drvr, skb, ifidx, true);
+		brcmf_txfinalize(fws->drvr, skb, ifp->ifidx, true);
 
 	return 0;
 }
@@ -1848,7 +1849,7 @@ static int brcmf_fws_commit_skb(struct brcmf_fws_info *fws, int fifo,
 		entry->transit_count--;
 		if (entry->suppressed)
 			entry->suppr_transit_count--;
-		brcmf_proto_hdrpull(fws->drvr, false, &ifidx, skb);
+		(void)brcmf_proto_hdrpull(fws->drvr, false, skb, NULL);
 		goto rollback;
 	}
 
diff --git a/drivers/net/wireless/brcm80211/brcmfmac/msgbuf.c b/drivers/net/wireless/brcm80211/brcmfmac/msgbuf.c
index 1271d1d..d582f69 100644
--- a/drivers/net/wireless/brcm80211/brcmfmac/msgbuf.c
+++ b/drivers/net/wireless/brcm80211/brcmfmac/msgbuf.c
@@ -522,7 +522,7 @@ static int brcmf_msgbuf_set_dcmd(struct brcmf_pub *drvr, int ifidx,
 
 
 static int brcmf_msgbuf_hdrpull(struct brcmf_pub *drvr, bool do_fws,
-				u8 *ifidx, struct sk_buff *skb)
+				struct sk_buff *skb, struct brcmf_if **ifp)
 {
 	return -ENODEV;
 }
@@ -1082,7 +1082,7 @@ brcmf_msgbuf_rx_skb(struct brcmf_msgbuf *msgbuf, struct sk_buff *skb,
 	struct brcmf_if *ifp;
 
 	ifp = brcmf_get_ifp(msgbuf->drvr, ifidx);
-	if (IS_ERR_OR_NULL(ifp) || !ifp->ndev) {
+	if (!ifp || !ifp->ndev) {
 		brcmf_err("Received pkt for invalid ifidx %d\n", ifidx);
 		brcmu_pkt_buf_free_skb(skb);
 		return;
diff --git a/drivers/net/wireless/brcm80211/brcmfmac/proto.h b/drivers/net/wireless/brcm80211/brcmfmac/proto.h
index 971172ff..d55119d 100644
--- a/drivers/net/wireless/brcm80211/brcmfmac/proto.h
+++ b/drivers/net/wireless/brcm80211/brcmfmac/proto.h
@@ -24,8 +24,8 @@ enum proto_addr_mode {
 
 
 struct brcmf_proto {
-	int (*hdrpull)(struct brcmf_pub *drvr, bool do_fws, u8 *ifidx,
-		       struct sk_buff *skb);
+	int (*hdrpull)(struct brcmf_pub *drvr, bool do_fws,
+		       struct sk_buff *skb, struct brcmf_if **ifp);
 	int (*query_dcmd)(struct brcmf_pub *drvr, int ifidx, uint cmd,
 			  void *buf, uint len);
 	int (*set_dcmd)(struct brcmf_pub *drvr, int ifidx, uint cmd, void *buf,
@@ -46,9 +46,19 @@ int brcmf_proto_attach(struct brcmf_pub *drvr);
 void brcmf_proto_detach(struct brcmf_pub *drvr);
 
 static inline int brcmf_proto_hdrpull(struct brcmf_pub *drvr, bool do_fws,
-				      u8 *ifidx, struct sk_buff *skb)
+				      struct sk_buff *skb,
+				      struct brcmf_if **ifp)
 {
-	return drvr->proto->hdrpull(drvr, do_fws, ifidx, skb);
+	struct brcmf_if *tmp = NULL;
+
+	/* assure protocol is always called with
+	 * non-null initialized pointer.
+	 */
+	if (ifp)
+		*ifp = NULL;
+	else
+		ifp = &tmp;
+	return drvr->proto->hdrpull(drvr, do_fws, skb, ifp);
 }
 static inline int brcmf_proto_query_dcmd(struct brcmf_pub *drvr, int ifidx,
 					 uint cmd, void *buf, uint len)
-- 
1.9.1

