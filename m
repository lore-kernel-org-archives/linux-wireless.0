Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mms3.broadcom.com ([216.31.210.19]:2829 "EHLO MMS3.broadcom.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753625Ab1JSKv0 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 19 Oct 2011 06:51:26 -0400
From: "Arend van Spriel" <arend@broadcom.com>
To: linville@tuxdriver.com
cc: linux-wireless@vger.kernel.org,
	"Arend van Spriel" <arend@broadcom.com>
Subject: [PATCH v2 15/15] brcm80211: fmac: use sk_buff list for handling
 frames in receive path
Date: Wed, 19 Oct 2011 12:51:09 +0200
Message-ID: <1319021469-5117-1-git-send-email-arend@broadcom.com> (sfid-20111019_125131_201628_061DBBB6)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

The functions in the receive patch of the fullmac now use sk_buff
list and skb_queue_xx() functions instead of dealing with list pointers
in the sk_buff directly.

Reported-by: Johannes Berg <johannes@sipsolutions.net>
Reviewed-by: Franky (Zhenhui) Lin <frankyl@broadcom.com>
Reviewed-by: Roland Vossen <rvossen@broadcom.com>
Signed-off-by: Arend van Spriel <arend@broadcom.com>
---
John,

An issue popped up in our nightly testing. This has been fixed in this
patch replacing the orginal patch sent yesterday with message id:

Message-ID: <1318939391-19495-16-git-send-email-arend@broadcom.com>

Gr. AvS
---
 drivers/net/wireless/brcm80211/brcmfmac/dhd_sdio.c |   62 ++++++++++---------
 1 files changed, 33 insertions(+), 29 deletions(-)

diff --git a/drivers/net/wireless/brcm80211/brcmfmac/dhd_sdio.c b/drivers/net/wireless/brcm80211/brcmfmac/dhd_sdio.c
index 5ca7ae2..c6825f2 100644
--- a/drivers/net/wireless/brcm80211/brcmfmac/dhd_sdio.c
+++ b/drivers/net/wireless/brcm80211/brcmfmac/dhd_sdio.c
@@ -574,7 +574,7 @@ struct brcmf_bus {
 	uint txminmax;
 
 	struct sk_buff *glomd;	/* Packet containing glomming descriptor */
-	struct sk_buff *glom;	/* Packet chain for glommed superframe */
+	struct sk_buff_head glom; /* Packet list for glommed superframe */
 	uint glomerr;		/* Glom packet read errors */
 
 	u8 *rxbuf;		/* Buffer for receiving control packets */
@@ -1229,16 +1229,17 @@ static uint brcmf_sdbrcm_glom_from_buf(struct brcmf_bus *bus, uint len)
 	struct sk_buff *p;
 	u8 *buf;
 
-	p = bus->glom;
 	buf = bus->dataptr;
 
 	/* copy the data */
-	for (; p && len; p = p->next) {
+	skb_queue_walk(&bus->glom, p) {
 		n = min_t(uint, p->len, len);
 		memcpy(p->data, buf, n);
 		buf += n;
 		len -= n;
 		ret += n;
+		if (!len)
+			break;
 	}
 
 	return ret;
@@ -1262,7 +1263,8 @@ static u8 brcmf_sdbrcm_rxglom(struct brcmf_bus *bus, u8 rxseq)
 	/* If packets, issue read(s) and send up packet chain */
 	/* Return sequence numbers consumed? */
 
-	brcmf_dbg(TRACE, "start: glomd %p glom %p\n", bus->glomd, bus->glom);
+	brcmf_dbg(TRACE, "start: glomd %p glom %p\n",
+		  bus->glomd, skb_peek(&bus->glom));
 
 	/* If there's a descriptor, generate the packet chain */
 	if (bus->glomd) {
@@ -1309,12 +1311,7 @@ static u8 brcmf_sdbrcm_rxglom(struct brcmf_bus *bus, u8 rxseq)
 					  num, sublen);
 				break;
 			}
-			if (!pfirst) {
-				pfirst = plast = pnext;
-			} else {
-				plast->next = pnext;
-				plast = pnext;
-			}
+			skb_queue_tail(&bus->glom, pnext);
 
 			/* Adhere to start alignment requirements */
 			pkt_align(pnext, sublen, BRCMF_SDALIGN);
@@ -1330,12 +1327,13 @@ static u8 brcmf_sdbrcm_rxglom(struct brcmf_bus *bus, u8 rxseq)
 				brcmf_dbg(GLOM, "glomdesc mismatch: nextlen %d glomdesc %d rxseq %d\n",
 					  bus->nextlen, totlen, rxseq);
 			}
-			bus->glom = pfirst;
 			pfirst = pnext = NULL;
 		} else {
-			if (pfirst)
-				brcmu_pkt_buf_free_skb(pfirst);
-			bus->glom = NULL;
+			if (!skb_queue_empty(&bus->glom))
+				skb_queue_walk_safe(&bus->glom, pfirst, pnext) {
+					skb_unlink(pfirst, &bus->glom);
+					brcmu_pkt_buf_free_skb(pfirst);
+				}
 			num = 0;
 		}
 
@@ -1347,17 +1345,17 @@ static u8 brcmf_sdbrcm_rxglom(struct brcmf_bus *bus, u8 rxseq)
 
 	/* Ok -- either we just generated a packet chain,
 		 or had one from before */
-	if (bus->glom) {
+	if (!skb_queue_empty(&bus->glom)) {
 		if (BRCMF_GLOM_ON()) {
 			brcmf_dbg(GLOM, "try superframe read, packet chain:\n");
-			for (pnext = bus->glom; pnext; pnext = pnext->next) {
+			skb_queue_walk(&bus->glom, pnext) {
 				brcmf_dbg(GLOM, "    %p: %p len 0x%04x (%d)\n",
 					  pnext, (u8 *) (pnext->data),
 					  pnext->len, pnext->len);
 			}
 		}
 
-		pfirst = bus->glom;
+		pfirst = skb_peek(&bus->glom);
 		dlen = (u16) brcmu_pkttotlen(pfirst);
 
 		/* Do an SDIO read for the superframe.  Configurable iovar to
@@ -1401,9 +1399,11 @@ static u8 brcmf_sdbrcm_rxglom(struct brcmf_bus *bus, u8 rxseq)
 			} else {
 				bus->glomerr = 0;
 				brcmf_sdbrcm_rxfail(bus, true, false);
-				brcmu_pkt_buf_free_skb(bus->glom);
 				bus->rxglomfail++;
-				bus->glom = NULL;
+				skb_queue_walk_safe(&bus->glom, pfirst, pnext) {
+					skb_unlink(pfirst, &bus->glom);
+					brcmu_pkt_buf_free_skb(pfirst);
+				}
 			}
 			return 0;
 		}
@@ -1524,9 +1524,11 @@ static u8 brcmf_sdbrcm_rxglom(struct brcmf_bus *bus, u8 rxseq)
 			} else {
 				bus->glomerr = 0;
 				brcmf_sdbrcm_rxfail(bus, true, false);
-				brcmu_pkt_buf_free_skb(bus->glom);
 				bus->rxglomfail++;
-				bus->glom = NULL;
+				skb_queue_walk_safe(&bus->glom, pfirst, pnext) {
+					skb_unlink(pfirst, &bus->glom);
+					brcmu_pkt_buf_free_skb(pfirst);
+				}
 			}
 			bus->nextlen = 0;
 			return 0;
@@ -1534,7 +1536,6 @@ static u8 brcmf_sdbrcm_rxglom(struct brcmf_bus *bus, u8 rxseq)
 
 		/* Basic SD framing looks ok - process each packet (header) */
 		save_pfirst = pfirst;
-		bus->glom = NULL;
 		plast = NULL;
 
 		for (num = 0; pfirst; rxseq++, pfirst = pnext) {
@@ -1871,10 +1872,10 @@ brcmf_sdbrcm_readframes(struct brcmf_bus *bus, uint maxframes, bool *finished)
 	     rxseq++, rxleft--) {
 
 		/* Handle glomming separately */
-		if (bus->glom || bus->glomd) {
+		if (bus->glomd || !skb_queue_empty(&bus->glom)) {
 			u8 cnt;
 			brcmf_dbg(GLOM, "calling rxglom: glomd %p, glom %p\n",
-				  bus->glomd, bus->glom);
+				  bus->glomd, skb_peek(&bus->glom));
 			cnt = brcmf_sdbrcm_rxglom(bus, rxseq);
 			brcmf_dbg(GLOM, "rxglom returned %d\n", cnt);
 			rxseq += cnt - 1;
@@ -3623,6 +3624,8 @@ void brcmf_sdbrcm_bus_stop(struct brcmf_bus *bus)
 	u8 saveclk;
 	uint retries;
 	int err;
+	struct sk_buff *cur;
+	struct sk_buff *next;
 
 	brcmf_dbg(TRACE, "Enter\n");
 
@@ -3682,11 +3685,11 @@ void brcmf_sdbrcm_bus_stop(struct brcmf_bus *bus)
 	/* Clear any held glomming stuff */
 	if (bus->glomd)
 		brcmu_pkt_buf_free_skb(bus->glomd);
-
-	if (bus->glom)
-		brcmu_pkt_buf_free_skb(bus->glom);
-
-	bus->glom = bus->glomd = NULL;
+	if (!skb_queue_empty(&bus->glom))
+		skb_queue_walk_safe(&bus->glom, cur, next) {
+			skb_unlink(cur, &bus->glom);
+			brcmu_pkt_buf_free_skb(cur);
+		}
 
 	/* Clear rx control and wake any waiters */
 	bus->rxlen = 0;
@@ -4461,6 +4464,7 @@ void *brcmf_sdbrcm_probe(u16 bus_no, u16 slot, u16 func, uint bustype,
 
 	bus->sdiodev = sdiodev;
 	sdiodev->bus = bus;
+	skb_queue_head_init(&bus->glom);
 	bus->txbound = BRCMF_TXBOUND;
 	bus->rxbound = BRCMF_RXBOUND;
 	bus->txminmax = BRCMF_TXMINMAX;
-- 
1.7.4.1


