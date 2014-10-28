Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-gw3-out.broadcom.com ([216.31.210.64]:17148 "EHLO
	mail-gw3-out.broadcom.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751419AbaJ1OBZ (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 28 Oct 2014 10:01:25 -0400
From: Arend van Spriel <arend@broadcom.com>
To: "John W. Linville" <linville@tuxdriver.com>
CC: linux-wireless <linux-wireless@vger.kernel.org>,
	Hante Meuleman <meuleman@broadcom.com>,
	Arend van Spriel <arend@broadcom.com>
Subject: [PATCH 16/16] brcmfmac: (clean) Move sdio related function.
Date: Tue, 28 Oct 2014 14:56:19 +0100
Message-ID: <1414504579-12562-17-git-send-email-arend@broadcom.com> (sfid-20141028_150129_630191_EB180CF6)
In-Reply-To: <1414504579-12562-1-git-send-email-arend@broadcom.com>
References: <1414504579-12562-1-git-send-email-arend@broadcom.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Hante Meuleman <meuleman@broadcom.com>

prec_enq is a sdio specific function. Move it to sdio.c.

Reviewed-by: Arend Van Spriel <arend@broadcom.com>
Reviewed-by: Pieter-Paul Giesberts <pieterpg@broadcom.com>
Signed-off-by: Hante Meuleman <meuleman@broadcom.com>
Signed-off-by: Arend van Spriel <arend@broadcom.com>
---
 drivers/net/wireless/brcm80211/brcmfmac/common.c | 51 ------------------------
 drivers/net/wireless/brcm80211/brcmfmac/core.h   |  1 -
 drivers/net/wireless/brcm80211/brcmfmac/sdio.c   | 46 ++++++++++++++++++++-
 3 files changed, 44 insertions(+), 54 deletions(-)

diff --git a/drivers/net/wireless/brcm80211/brcmfmac/common.c b/drivers/net/wireless/brcm80211/brcmfmac/common.c
index 183cec9..1861a13 100644
--- a/drivers/net/wireless/brcm80211/brcmfmac/common.c
+++ b/drivers/net/wireless/brcm80211/brcmfmac/common.c
@@ -33,57 +33,6 @@
 /* boost value for RSSI_DELTA in preferred join selection */
 #define BRCMF_JOIN_PREF_RSSI_BOOST	8
 
-
-bool brcmf_c_prec_enq(struct device *dev, struct pktq *q,
-		      struct sk_buff *pkt, int prec)
-{
-	struct sk_buff *p;
-	int eprec = -1;		/* precedence to evict from */
-	bool discard_oldest;
-	struct brcmf_bus *bus_if = dev_get_drvdata(dev);
-	struct brcmf_pub *drvr = bus_if->drvr;
-
-	/* Fast case, precedence queue is not full and we are also not
-	 * exceeding total queue length
-	 */
-	if (!pktq_pfull(q, prec) && !pktq_full(q)) {
-		brcmu_pktq_penq(q, prec, pkt);
-		return true;
-	}
-
-	/* Determine precedence from which to evict packet, if any */
-	if (pktq_pfull(q, prec)) {
-		eprec = prec;
-	} else if (pktq_full(q)) {
-		p = brcmu_pktq_peek_tail(q, &eprec);
-		if (eprec > prec)
-			return false;
-	}
-
-	/* Evict if needed */
-	if (eprec >= 0) {
-		/* Detect queueing to unconfigured precedence */
-		discard_oldest = ac_bitmap_tst(drvr->wme_dp, eprec);
-		if (eprec == prec && !discard_oldest)
-			return false;	/* refuse newer (incoming) packet */
-		/* Evict packet according to discard policy */
-		p = discard_oldest ? brcmu_pktq_pdeq(q, eprec) :
-			brcmu_pktq_pdeq_tail(q, eprec);
-		if (p == NULL)
-			brcmf_err("brcmu_pktq_penq() failed, oldest %d\n",
-				  discard_oldest);
-
-		brcmu_pkt_buf_free_skb(p);
-	}
-
-	/* Enqueue */
-	p = brcmu_pktq_penq(q, prec, pkt);
-	if (p == NULL)
-		brcmf_err("brcmu_pktq_penq() failed\n");
-
-	return p != NULL;
-}
-
 int brcmf_c_preinit_dcmds(struct brcmf_if *ifp)
 {
 	s8 eventmask[BRCMF_EVENTING_MASK_LEN];
diff --git a/drivers/net/wireless/brcm80211/brcmfmac/core.h b/drivers/net/wireless/brcm80211/brcmfmac/core.h
index 7df22bd..98228e9 100644
--- a/drivers/net/wireless/brcm80211/brcmfmac/core.h
+++ b/drivers/net/wireless/brcm80211/brcmfmac/core.h
@@ -83,7 +83,6 @@ struct brcmf_pub {
 	/* Internal brcmf items */
 	uint hdrlen;		/* Total BRCMF header length (proto + bus) */
 	uint rxsz;		/* Rx buffer size bus module should use */
-	u8 wme_dp;		/* wme discard priority */
 
 	/* Dongle media info */
 	char fwver[BRCMF_DRIVER_FIRMWARE_VERSION_LEN];
diff --git a/drivers/net/wireless/brcm80211/brcmfmac/sdio.c b/drivers/net/wireless/brcm80211/brcmfmac/sdio.c
index 73ac0c3..72e87b5 100644
--- a/drivers/net/wireless/brcm80211/brcmfmac/sdio.c
+++ b/drivers/net/wireless/brcm80211/brcmfmac/sdio.c
@@ -2763,6 +2763,48 @@ static struct pktq *brcmf_sdio_bus_gettxq(struct device *dev)
 	return &bus->txq;
 }
 
+static bool brcmf_sdio_prec_enq(struct pktq *q, struct sk_buff *pkt, int prec)
+{
+	struct sk_buff *p;
+	int eprec = -1;		/* precedence to evict from */
+
+	/* Fast case, precedence queue is not full and we are also not
+	 * exceeding total queue length
+	 */
+	if (!pktq_pfull(q, prec) && !pktq_full(q)) {
+		brcmu_pktq_penq(q, prec, pkt);
+		return true;
+	}
+
+	/* Determine precedence from which to evict packet, if any */
+	if (pktq_pfull(q, prec)) {
+		eprec = prec;
+	} else if (pktq_full(q)) {
+		p = brcmu_pktq_peek_tail(q, &eprec);
+		if (eprec > prec)
+			return false;
+	}
+
+	/* Evict if needed */
+	if (eprec >= 0) {
+		/* Detect queueing to unconfigured precedence */
+		if (eprec == prec)
+			return false;	/* refuse newer (incoming) packet */
+		/* Evict packet according to discard policy */
+		p = brcmu_pktq_pdeq_tail(q, eprec);
+		if (p == NULL)
+			brcmf_err("brcmu_pktq_pdeq_tail() failed\n");
+		brcmu_pkt_buf_free_skb(p);
+	}
+
+	/* Enqueue */
+	p = brcmu_pktq_penq(q, prec, pkt);
+	if (p == NULL)
+		brcmf_err("brcmu_pktq_penq() failed\n");
+
+	return p != NULL;
+}
+
 static int brcmf_sdio_bus_txdata(struct device *dev, struct sk_buff *pkt)
 {
 	int ret = -EBADE;
@@ -2788,7 +2830,7 @@ static int brcmf_sdio_bus_txdata(struct device *dev, struct sk_buff *pkt)
 	spin_lock_bh(&bus->txq_lock);
 	/* reset bus_flags in packet cb */
 	*(u16 *)(pkt->cb) = 0;
-	if (!brcmf_c_prec_enq(bus->sdiodev->dev, &bus->txq, pkt, prec)) {
+	if (!brcmf_sdio_prec_enq(&bus->txq, pkt, prec)) {
 		skb_pull(pkt, bus->tx_hdrlen);
 		brcmf_err("out of bus->txq !!!\n");
 		ret = -ENOSR;
@@ -2798,7 +2840,7 @@ static int brcmf_sdio_bus_txdata(struct device *dev, struct sk_buff *pkt)
 
 	if (pktq_len(&bus->txq) >= TXHI) {
 		bus->txoff = true;
-		brcmf_txflowblock(bus->sdiodev->dev, true);
+		brcmf_txflowblock(dev, true);
 	}
 	spin_unlock_bh(&bus->txq_lock);
 
-- 
1.9.1

