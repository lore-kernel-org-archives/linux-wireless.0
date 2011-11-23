Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mms2.broadcom.com ([216.31.210.18]:4808 "EHLO mms2.broadcom.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759552Ab1KWBWP (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 22 Nov 2011 20:22:15 -0500
From: "Franky Lin" <frankyl@broadcom.com>
To: linville@tuxdriver.com
cc: linux-wireless@vger.kernel.org
Subject: [PATCH 01/24] brcm80211: fmac: cleanup receive path using
 proper skb_queue functions
Date: Tue, 22 Nov 2011 17:21:36 -0800
Message-ID: <1322011319-24863-2-git-send-email-frankyl@broadcom.com> (sfid-20111123_022222_588210_B9A46802)
In-Reply-To: <1322011319-24863-1-git-send-email-frankyl@broadcom.com>
References: <1322011319-24863-1-git-send-email-frankyl@broadcom.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Arend van Spriel <arend@broadcom.com>

In the receive path there was still code using the next pointer to
access all packets in skb_queue. This patch fixes that.

Reported-by: Johannes Berg <johannes@sipsolutions.net>
Reviewed-by: Pieter-Paul Giesberts <pieterpg@broadcom.com>
Reviewed-by: Franky (Zhenhui) Lin <frankyl@broadcom.com>
Reviewed-by: Alwin Beukers <alwin@broadcom.com>
Signed-off-by: Arend van Spriel <arend@broadcom.com>
Signed-off-by: Franky Lin <frankyl@broadcom.com>
---
 drivers/net/wireless/brcm80211/brcmfmac/dhd.h      |   11 ++++-
 .../net/wireless/brcm80211/brcmfmac/dhd_linux.c    |   15 ++----
 drivers/net/wireless/brcm80211/brcmfmac/dhd_sdio.c |   52 ++++++++------------
 3 files changed, 36 insertions(+), 42 deletions(-)

diff --git a/drivers/net/wireless/brcm80211/brcmfmac/dhd.h b/drivers/net/wireless/brcm80211/brcmfmac/dhd.h
index 6da519e..7962f64 100644
--- a/drivers/net/wireless/brcm80211/brcmfmac/dhd.h
+++ b/drivers/net/wireless/brcm80211/brcmfmac/dhd.h
@@ -699,7 +699,16 @@ extern bool brcmf_c_prec_enq(struct brcmf_pub *drvr, struct pktq *q,
 
 /* Receive frame for delivery to OS.  Callee disposes of rxp. */
 extern void brcmf_rx_frame(struct brcmf_pub *drvr, int ifidx,
-			 struct sk_buff *rxp, int numpkt);
+			   struct sk_buff_head *rxlist);
+static inline void brcmf_rx_packet(struct brcmf_pub *drvr, int ifidx,
+				   struct sk_buff *pkt)
+{
+	struct sk_buff_head q;
+
+	skb_queue_head_init(&q);
+	skb_queue_tail(&q, pkt);
+	brcmf_rx_frame(drvr, ifidx, &q);
+}
 
 /* Return pointer to interface name */
 extern char *brcmf_ifname(struct brcmf_pub *drvr, int idx);
diff --git a/drivers/net/wireless/brcm80211/brcmfmac/dhd_linux.c b/drivers/net/wireless/brcm80211/brcmfmac/dhd_linux.c
index 719fd93..9721174 100644
--- a/drivers/net/wireless/brcm80211/brcmfmac/dhd_linux.c
+++ b/drivers/net/wireless/brcm80211/brcmfmac/dhd_linux.c
@@ -397,26 +397,21 @@ static int brcmf_host_event(struct brcmf_info *drvr_priv, int *ifidx,
 	return bcmerror;
 }
 
-void brcmf_rx_frame(struct brcmf_pub *drvr, int ifidx, struct sk_buff *skb,
-		  int numpkt)
+void brcmf_rx_frame(struct brcmf_pub *drvr, int ifidx,
+		    struct sk_buff_head *skb_list)
 {
 	struct brcmf_info *drvr_priv = drvr->info;
 	unsigned char *eth;
 	uint len;
 	void *data;
-	struct sk_buff *pnext, *save_pktbuf;
-	int i;
+	struct sk_buff *skb, *pnext;
 	struct brcmf_if *ifp;
 	struct brcmf_event_msg event;
 
 	brcmf_dbg(TRACE, "Enter\n");
 
-	save_pktbuf = skb;
-
-	for (i = 0; skb && i < numpkt; i++, skb = pnext) {
-
-		pnext = skb->next;
-		skb->next = NULL;
+	skb_queue_walk_safe(skb_list, skb, pnext) {
+		skb_unlink(skb, skb_list);
 
 		/* Get the protocol, maintain skb around eth_type_trans()
 		 * The main reason for this hack is for the limitation of
diff --git a/drivers/net/wireless/brcm80211/brcmfmac/dhd_sdio.c b/drivers/net/wireless/brcm80211/brcmfmac/dhd_sdio.c
index 22913af..10b9247 100644
--- a/drivers/net/wireless/brcm80211/brcmfmac/dhd_sdio.c
+++ b/drivers/net/wireless/brcm80211/brcmfmac/dhd_sdio.c
@@ -1120,7 +1120,7 @@ static u8 brcmf_sdbrcm_rxglom(struct brcmf_bus *bus, u8 rxseq)
 	u8 *dptr, num = 0;
 
 	u16 sublen, check;
-	struct sk_buff *pfirst, *plast, *pnext, *save_pfirst;
+	struct sk_buff *pfirst, *pnext;
 
 	int errcode;
 	u8 chan, seq, doff, sfdoff;
@@ -1137,7 +1137,7 @@ static u8 brcmf_sdbrcm_rxglom(struct brcmf_bus *bus, u8 rxseq)
 
 	/* If there's a descriptor, generate the packet chain */
 	if (bus->glomd) {
-		pfirst = plast = pnext = NULL;
+		pfirst = pnext = NULL;
 		dlen = (u16) (bus->glomd->len);
 		dptr = bus->glomd->data;
 		if (!dlen || (dlen & 1)) {
@@ -1338,10 +1338,14 @@ static u8 brcmf_sdbrcm_rxglom(struct brcmf_bus *bus, u8 rxseq)
 		/* Remove superframe header, remember offset */
 		skb_pull(pfirst, doff);
 		sfdoff = doff;
+		num = 0;
 
 		/* Validate all the subframe headers */
-		for (num = 0, pnext = pfirst; pnext && !errcode;
-		     num++, pnext = pnext->next) {
+		skb_queue_walk(&bus->glom, pnext) {
+			/* leave when invalid subframe is found */
+			if (errcode)
+				break;
+
 			dptr = (u8 *) (pnext->data);
 			dlen = (u16) (pnext->len);
 			sublen = get_unaligned_le16(dptr);
@@ -1374,6 +1378,8 @@ static u8 brcmf_sdbrcm_rxglom(struct brcmf_bus *bus, u8 rxseq)
 					  num, doff, sublen, SDPCM_HDRLEN);
 				errcode = -1;
 			}
+			/* increase the subframe count */
+			num++;
 		}
 
 		if (errcode) {
@@ -1394,13 +1400,8 @@ static u8 brcmf_sdbrcm_rxglom(struct brcmf_bus *bus, u8 rxseq)
 		}
 
 		/* Basic SD framing looks ok - process each packet (header) */
-		save_pfirst = pfirst;
-		plast = NULL;
-
-		for (num = 0; pfirst; rxseq++, pfirst = pnext) {
-			pnext = pfirst->next;
-			pfirst->next = NULL;
 
+		skb_queue_walk_safe(&bus->glom, pfirst, pnext) {
 			dptr = (u8 *) (pfirst->data);
 			sublen = get_unaligned_le16(dptr);
 			chan = SDPCM_PACKET_CHANNEL(&dptr[SDPCM_FRAMETAG_LEN]);
@@ -1420,6 +1421,8 @@ static u8 brcmf_sdbrcm_rxglom(struct brcmf_bus *bus, u8 rxseq)
 				bus->rx_badseq++;
 				rxseq = seq;
 			}
+			rxseq++;
+
 #ifdef BCMDBG
 			if (BRCMF_BYTES_ON() && BRCMF_DATA_ON()) {
 				printk(KERN_DEBUG "Rx Subframe Data:\n");
@@ -1432,36 +1435,22 @@ static u8 brcmf_sdbrcm_rxglom(struct brcmf_bus *bus, u8 rxseq)
 			skb_pull(pfirst, doff);
 
 			if (pfirst->len == 0) {
+				skb_unlink(pfirst, &bus->glom);
 				brcmu_pkt_buf_free_skb(pfirst);
-				if (plast)
-					plast->next = pnext;
-				else
-					save_pfirst = pnext;
-
 				continue;
 			} else if (brcmf_proto_hdrpull(bus->drvr, &ifidx,
 						       pfirst) != 0) {
 				brcmf_dbg(ERROR, "rx protocol error\n");
 				bus->drvr->rx_errors++;
+				skb_unlink(pfirst, &bus->glom);
 				brcmu_pkt_buf_free_skb(pfirst);
-				if (plast)
-					plast->next = pnext;
-				else
-					save_pfirst = pnext;
-
 				continue;
 			}
 
-			/* this packet will go up, link back into
-				 chain and count it */
-			pfirst->next = pnext;
-			plast = pfirst;
-			num++;
-
 #ifdef BCMDBG
 			if (BRCMF_GLOM_ON()) {
 				brcmf_dbg(GLOM, "subframe %d to stack, %p (%p/%d) nxt/lnk %p/%p\n",
-					  num, pfirst, pfirst->data,
+					  bus->glom.qlen, pfirst, pfirst->data,
 					  pfirst->len, pfirst->next,
 					  pfirst->prev);
 				print_hex_dump_bytes("", DUMP_PREFIX_OFFSET,
@@ -1470,14 +1459,15 @@ static u8 brcmf_sdbrcm_rxglom(struct brcmf_bus *bus, u8 rxseq)
 			}
 #endif				/* BCMDBG */
 		}
-		if (num) {
+		/* sent any remaining packets up */
+		if (bus->glom.qlen) {
 			up(&bus->sdsem);
-			brcmf_rx_frame(bus->drvr, ifidx, save_pfirst, num);
+			brcmf_rx_frame(bus->drvr, ifidx, &bus->glom);
 			down(&bus->sdsem);
 		}
 
 		bus->rxglomframes++;
-		bus->rxglompkts += num;
+		bus->rxglompkts += bus->glom.qlen;
 	}
 	return num;
 }
@@ -2075,7 +2065,7 @@ deliver:
 
 		/* Unlock during rx call */
 		up(&bus->sdsem);
-		brcmf_rx_frame(bus->drvr, ifidx, pkt, 1);
+		brcmf_rx_packet(bus->drvr, ifidx, pkt);
 		down(&bus->sdsem);
 	}
 	rxcount = maxframes - rxleft;
-- 
1.7.5.4


