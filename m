Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mms2.broadcom.com ([216.31.210.18]:3812 "EHLO mms2.broadcom.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754336Ab1ILKPY (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 12 Sep 2011 06:15:24 -0400
From: "Roland Vossen" <rvossen@broadcom.com>
To: gregkh@suse.de
cc: devel@linuxdriverproject.org, linux-wireless@vger.kernel.org
Subject: [PATCH 05/20] staging: brcm80211: cleaned up fullmac macro's
Date: Mon, 12 Sep 2011 12:14:49 +0200
Message-ID: <1315822504-24210-6-git-send-email-rvossen@broadcom.com> (sfid-20110912_121558_457618_EC74AE88)
In-Reply-To: <1315822504-24210-1-git-send-email-rvossen@broadcom.com>
References: <1315822504-24210-1-git-send-email-rvossen@broadcom.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Substituted/moved/removed macro's.

Reported-by: Johannes Berg <johannes@sipsolutions.net>
Signed-off-by: Roland Vossen <rvossen@broadcom.com>
Reviewed-by: Arend van Spriel <arend@broadcom.com>
Reviewed-by: Franky Lin <frankyl@broadcom.com>
---
 drivers/staging/brcm80211/brcmfmac/dhd.h         |    6 --
 drivers/staging/brcm80211/brcmfmac/dhd_cdc.c     |   18 +++--
 drivers/staging/brcm80211/brcmfmac/dhd_common.c  |    4 +
 drivers/staging/brcm80211/brcmfmac/dhd_sdio.c    |  104 +++++++++-------------
 drivers/staging/brcm80211/brcmfmac/sdio_host.h   |    3 -
 drivers/staging/brcm80211/brcmfmac/wl_cfg80211.c |  105 +++++++++++++---------
 drivers/staging/brcm80211/brcmfmac/wl_cfg80211.h |   38 +++++++--
 7 files changed, 150 insertions(+), 128 deletions(-)

diff --git a/drivers/staging/brcm80211/brcmfmac/dhd.h b/drivers/staging/brcm80211/brcmfmac/dhd.h
index 4d06d87..a1262a6 100644
--- a/drivers/staging/brcm80211/brcmfmac/dhd.h
+++ b/drivers/staging/brcm80211/brcmfmac/dhd.h
@@ -83,10 +83,6 @@
 #define	WLC_PHY_TYPE_LCN	8
 #define	WLC_PHY_TYPE_NULL	0xf
 
-#define BRCMF_PKT_FILTER_FIXED_LEN	offsetof(struct brcmf_pkt_filter, u)
-#define BRCMF_PKT_FILTER_PATTERN_FIXED_LEN	\
-	offsetof(struct brcmf_pkt_filter_pattern, mask_and_pattern)
-
 #define BRCMF_EVENTING_MASK_LEN	16
 
 #define TOE_TX_CSUM_OL		0x00000001
@@ -478,8 +474,6 @@ struct brcmf_assoc_params {
 	/* list of chanspecs */
 	u16 chanspec_list[1];
 };
-#define BRCMF_ASSOC_PARAMS_FIXED_SIZE \
-	(sizeof(struct brcmf_assoc_params) - sizeof(u16))
 
 /* used for join with or without a specific bssid and channel list */
 struct brcmf_join_params {
diff --git a/drivers/staging/brcm80211/brcmfmac/dhd_cdc.c b/drivers/staging/brcm80211/brcmfmac/dhd_cdc.c
index 1ac8057..eacbe31 100644
--- a/drivers/staging/brcm80211/brcmfmac/dhd_cdc.c
+++ b/drivers/staging/brcm80211/brcmfmac/dhd_cdc.c
@@ -338,11 +338,15 @@ done:
 	return ret;
 }
 
-#define PKTSUMNEEDED(skb) \
-		(((struct sk_buff *)(skb))->ip_summed == CHECKSUM_PARTIAL)
-#define PKTSETSUMGOOD(skb, x) \
-		(((struct sk_buff *)(skb))->ip_summed = \
-		((x) ? CHECKSUM_UNNECESSARY : CHECKSUM_NONE))
+static bool pkt_sum_needed(struct sk_buff *skb)
+{
+	return skb->ip_summed == CHECKSUM_PARTIAL;
+}
+
+static void pkt_set_sum_good(struct sk_buff *skb, bool x)
+{
+	skb->ip_summed = (x ? CHECKSUM_UNNECESSARY : CHECKSUM_NONE);
+}
 
 void brcmf_proto_dump(struct brcmf_pub *drvr, struct brcmu_strbuf *strbuf)
 {
@@ -363,7 +367,7 @@ void brcmf_proto_hdrpush(struct brcmf_pub *drvr, int ifidx,
 	h = (struct brcmf_proto_bdc_header *)(pktbuf->data);
 
 	h->flags = (BDC_PROTO_VER << BDC_FLAG_VER_SHIFT);
-	if (PKTSUMNEEDED(pktbuf))
+	if (pkt_sum_needed(pktbuf))
 		h->flags |= BDC_FLAG_SUM_NEEDED;
 
 	h->priority = (pktbuf->priority & BDC_PRIORITY_MASK);
@@ -405,7 +409,7 @@ int brcmf_proto_hdrpull(struct brcmf_pub *drvr, int *ifidx,
 	if (h->flags & BDC_FLAG_SUM_GOOD) {
 		brcmf_dbg(INFO, "%s: BDC packet received with good rx-csum, flags 0x%x\n",
 			  brcmf_ifname(drvr, *ifidx), h->flags);
-		PKTSETSUMGOOD(pktbuf, true);
+		pkt_set_sum_good(pktbuf, true);
 	}
 
 	pktbuf->priority = h->priority & BDC_PRIORITY_MASK;
diff --git a/drivers/staging/brcm80211/brcmfmac/dhd_common.c b/drivers/staging/brcm80211/brcmfmac/dhd_common.c
index 1a5f730..ba7a982 100644
--- a/drivers/staging/brcm80211/brcmfmac/dhd_common.c
+++ b/drivers/staging/brcm80211/brcmfmac/dhd_common.c
@@ -35,6 +35,10 @@ int brcmf_msg_level;
 
 #define MSGTRACE_VERSION	1
 
+#define BRCMF_PKT_FILTER_FIXED_LEN	offsetof(struct brcmf_pkt_filter, u)
+#define BRCMF_PKT_FILTER_PATTERN_FIXED_LEN	\
+	offsetof(struct brcmf_pkt_filter_pattern, mask_and_pattern)
+
 #ifdef BCMDBG
 static const char brcmf_version[] =
 	"Dongle Host Driver, version " BRCMF_VERSION_STR "\nCompiled on "
diff --git a/drivers/staging/brcm80211/brcmfmac/dhd_sdio.c b/drivers/staging/brcm80211/brcmfmac/dhd_sdio.c
index 8e4e0d0..aadc5bb 100644
--- a/drivers/staging/brcm80211/brcmfmac/dhd_sdio.c
+++ b/drivers/staging/brcm80211/brcmfmac/dhd_sdio.c
@@ -322,29 +322,6 @@ struct rte_console {
 
 #define SDPCM_GLOMDESC(p)	(((u8 *)p)[1] & 0x80)
 
-/* For TEST_CHANNEL packets, define another 4-byte header */
-#define SDPCM_TEST_HDRLEN	4	/*
-					 * Generally: Cmd(1), Ext(1), Len(2);
-					 * Semantics of Ext byte depend on
-					 * command. Len is current or requested
-					 * frame length, not including test
-					 * header; sent little-endian.
-					 */
-#define SDPCM_TEST_DISCARD	0x01	/* Receiver discards. Ext:pattern id. */
-#define SDPCM_TEST_ECHOREQ	0x02	/* Echo request. Ext:pattern id. */
-#define SDPCM_TEST_ECHORSP	0x03	/* Echo response. Ext:pattern id. */
-#define SDPCM_TEST_BURST	0x04	/*
-					 * Receiver to send a burst.
-					 * Ext is a frame count
-					 */
-#define SDPCM_TEST_SEND		0x05	/*
-					 * Receiver sets send mode.
-					 * Ext is boolean on/off
-					 */
-
-/* Handy macro for filling in datagen packets with a pattern */
-#define SDPCM_TEST_FILL(byteno, id)	((u8)(id + byteno))
-
 /*
  * Shared structure between dongle and the host.
  * The structure contains pointers to trap or assert information.
@@ -355,7 +332,6 @@ struct rte_console {
 #define SDPCM_SHARED_ASSERT        0x0200
 #define SDPCM_SHARED_TRAP          0x0400
 
-
 /* Space for header read, limit for data packets */
 #define MAX_HDR_READ	(1 << 6)
 #define MAX_RX_DATASZ	2048
@@ -425,9 +401,11 @@ struct rte_console {
 /*
  * Conversion of 802.1D priority to precedence level
  */
-#define PRIO2PREC(prio) \
-	(((prio) == PRIO_8021D_NONE || (prio) == PRIO_8021D_BE) ? \
-	((prio^2)) : (prio))
+static uint prio2prec(u32 prio)
+{
+	return (prio == PRIO_8021D_NONE || prio == PRIO_8021D_BE) ?
+	       (prio^2) : prio;
+}
 
 /*
  * Core reg address translation.
@@ -809,15 +787,15 @@ static bool forcealign;
 
 #define ALIGNMENT  4
 
-#define PKTALIGN(_p, _len, _align)				\
-	do {								\
-		uint datalign;						\
-		datalign = (unsigned long)((_p)->data);			\
-		datalign = roundup(datalign, (_align)) - datalign;	\
-		if (datalign)						\
-			skb_pull((_p), datalign);			\
-		__skb_trim((_p), (_len));				\
-	} while (0)
+static void pkt_align(struct sk_buff *p, int len, int align)
+{
+	uint datalign;
+	datalign = (unsigned long)(p->data);
+	datalign = roundup(datalign, (align)) - datalign;
+	if (datalign)
+		skb_pull(p, datalign);
+	__skb_trim(p, len);
+}
 
 /* Limit on rounding up frames */
 static const uint max_roundup = 512;
@@ -826,9 +804,11 @@ static const uint max_roundup = 512;
 static bool brcmf_readahead;
 
 /* To check if there's window offered */
-#define DATAOK(bus) \
-	(((u8)(bus->tx_max - bus->tx_seq) != 0) && \
-	(((u8)(bus->tx_max - bus->tx_seq) & 0x80) == 0))
+static bool data_ok(struct brcmf_bus *bus)
+{
+	return (u8)(bus->tx_max - bus->tx_seq) != 0 &&
+	       ((u8)(bus->tx_max - bus->tx_seq) & 0x80) == 0;
+}
 
 /*
  * Reads a register in the SDIO hardware block. This block occupies a series of
@@ -1232,11 +1212,11 @@ static int brcmf_sdbrcm_bussleep(struct brcmf_bus *bus, bool sleep)
 	return 0;
 }
 
-#define BUS_WAKE(bus) \
-	do { \
-		if ((bus)->sleeping) \
-			brcmf_sdbrcm_bussleep((bus), false); \
-	} while (0);
+static void bus_wake(struct brcmf_bus *bus)
+{
+	if (bus->sleeping)
+		brcmf_sdbrcm_bussleep(bus, false);
+}
 
 /* Writes a HW/SW header into the packet and sends it. */
 /* Assumes: (a) header space already there, (b) caller holds lock */
@@ -1275,7 +1255,7 @@ static int brcmf_sdbrcm_txpkt(struct brcmf_bus *bus, struct sk_buff *pkt,
 				goto done;
 			}
 
-			PKTALIGN(new, pkt->len, BRCMF_SDALIGN);
+			pkt_align(new, pkt->len, BRCMF_SDALIGN);
 			memcpy(new->data, pkt->data, pkt->len);
 			if (free_pkt)
 				brcmu_pkt_buf_free_skb(pkt);
@@ -1401,12 +1381,12 @@ int brcmf_sdbrcm_bus_txdata(struct brcmf_bus *bus, struct sk_buff *pkt)
 	skb_push(pkt, SDPCM_HDRLEN);
 	/* precondition: IS_ALIGNED((unsigned long)(pkt->data), 2) */
 
-	prec = PRIO2PREC((pkt->priority & PRIOMASK));
+	prec = prio2prec((pkt->priority & PRIOMASK));
 
 	/* Check for existing queue, current flow-control,
 			 pending event, or pending clock */
 	if (brcmf_deferred_tx || bus->fcstate || pktq_len(&bus->txq)
-	    || bus->dpc_sched || (!DATAOK(bus))
+	    || bus->dpc_sched || (!data_ok(bus))
 	    || (bus->flowcontrol & NBITVAL(prec))
 	    || (bus->clkstate != CLK_AVAIL)) {
 		brcmf_dbg(TRACE, "deferring pktq len %d\n",
@@ -1444,7 +1424,7 @@ int brcmf_sdbrcm_bus_txdata(struct brcmf_bus *bus, struct sk_buff *pkt)
 		brcmf_sdbrcm_sdlock(bus);
 
 		/* Otherwise, send it now */
-		BUS_WAKE(bus);
+		bus_wake(bus);
 		/* Make sure back plane ht clk is on, no pending allowed */
 		brcmf_sdbrcm_clkctl(bus, CLK_AVAIL, true);
 
@@ -1484,7 +1464,7 @@ static uint brcmf_sdbrcm_sendfromq(struct brcmf_bus *bus, uint maxframes)
 	tx_prec_map = ~bus->flowcontrol;
 
 	/* Send frames until the limit or some other event */
-	for (cnt = 0; (cnt < maxframes) && DATAOK(bus); cnt++) {
+	for (cnt = 0; (cnt < maxframes) && data_ok(bus); cnt++) {
 		spin_lock_bh(&bus->txqlock);
 		pkt = brcmu_pktq_mdeq(&bus->txq, tx_prec_map, &prec_out);
 		if (pkt == NULL) {
@@ -1573,7 +1553,7 @@ brcmf_sdbrcm_bus_txctl(struct brcmf_bus *bus, unsigned char *msg, uint msglen)
 	/* Need to lock here to protect txseq and SDIO tx calls */
 	brcmf_sdbrcm_sdlock(bus);
 
-	BUS_WAKE(bus);
+	bus_wake(bus);
 
 	/* Make sure backplane clock is on */
 	brcmf_sdbrcm_clkctl(bus, CLK_AVAIL, false);
@@ -1591,7 +1571,7 @@ brcmf_sdbrcm_bus_txctl(struct brcmf_bus *bus, unsigned char *msg, uint msglen)
 	put_unaligned_le32(swheader, frame + SDPCM_FRAMETAG_LEN);
 	put_unaligned_le32(0, frame + SDPCM_FRAMETAG_LEN + sizeof(swheader));
 
-	if (!DATAOK(bus)) {
+	if (!data_ok(bus)) {
 		brcmf_dbg(INFO, "No bus credit bus->tx_max %d, bus->tx_seq %d\n",
 			  bus->tx_max, bus->tx_seq);
 		bus->ctrl_frame_stat = true;
@@ -2364,7 +2344,7 @@ static int brcmf_sdbrcm_doiovar(struct brcmf_bus *bus,
 
 	/* Request clock to allow SDIO accesses */
 	if (!bus->drvr->dongle_reset) {
-		BUS_WAKE(bus);
+		bus_wake(bus);
 		brcmf_sdbrcm_clkctl(bus, CLK_AVAIL, false);
 	}
 
@@ -2899,7 +2879,7 @@ brcmf_sdbrcm_bus_iovar_op(struct brcmf_pub *drvr, const char *name,
 	if (vi == NULL) {
 		brcmf_sdbrcm_sdlock(bus);
 
-		BUS_WAKE(bus);
+		bus_wake(bus);
 
 		/* Turn on clock in case SD command needs backplane */
 		brcmf_sdbrcm_clkctl(bus, CLK_AVAIL, false);
@@ -2956,7 +2936,7 @@ void brcmf_sdbrcm_bus_stop(struct brcmf_bus *bus, bool enforce_mutex)
 	if (enforce_mutex)
 		brcmf_sdbrcm_sdlock(bus);
 
-	BUS_WAKE(bus);
+	bus_wake(bus);
 
 	/* Enable clock for device interrupts */
 	brcmf_sdbrcm_clkctl(bus, CLK_AVAIL, false);
@@ -3358,7 +3338,7 @@ static u8 brcmf_sdbrcm_rxglom(struct brcmf_bus *bus, u8 rxseq)
 			}
 
 			/* Adhere to start alignment requirements */
-			PKTALIGN(pnext, sublen, BRCMF_SDALIGN);
+			pkt_align(pnext, sublen, BRCMF_SDALIGN);
 		}
 
 		/* If all allocations succeeded, save packet chain
@@ -3748,7 +3728,7 @@ brcmf_sdbrcm_readframes(struct brcmf_bus *bus, uint maxframes, bool *finished)
 					  len, rdlen, rxseq);
 				continue;
 			} else {
-				PKTALIGN(pkt, rdlen, BRCMF_SDALIGN);
+				pkt_align(pkt, rdlen, BRCMF_SDALIGN);
 				rxbuf = (u8 *) (pkt->data);
 				/* Read the entire frame */
 				sdret = brcmf_sdcard_recv_buf(bus->sdiodev,
@@ -4052,7 +4032,7 @@ brcmf_sdbrcm_readframes(struct brcmf_bus *bus, uint maxframes, bool *finished)
 
 		/* Leave room for what we already read, and align remainder */
 		skb_pull(pkt, firstread);
-		PKTALIGN(pkt, rdlen, BRCMF_SDALIGN);
+		pkt_align(pkt, rdlen, BRCMF_SDALIGN);
 
 		/* Read the remaining frame data */
 		sdret = brcmf_sdcard_recv_buf(bus->sdiodev, bus->sdiodev->sbwad,
@@ -4287,7 +4267,7 @@ static bool brcmf_sdbrcm_dpc(struct brcmf_bus *bus)
 		}
 	}
 
-	BUS_WAKE(bus);
+	bus_wake(bus);
 
 	/* Make sure backplane clock is on */
 	brcmf_sdbrcm_clkctl(bus, CLK_AVAIL, true);
@@ -4377,7 +4357,7 @@ static bool brcmf_sdbrcm_dpc(struct brcmf_bus *bus)
 	bus->intstatus = intstatus;
 
 clkwait:
-	if (DATAOK(bus) && bus->ctrl_frame_stat &&
+	if (data_ok(bus) && bus->ctrl_frame_stat &&
 		(bus->clkstate == CLK_AVAIL)) {
 		int ret, i;
 
@@ -4425,7 +4405,7 @@ clkwait:
 	/* Send queued frames (limit 1 if rx may still be pending) */
 	else if ((bus->clkstate == CLK_AVAIL) && !bus->fcstate &&
 		 brcmu_pktq_mlen(&bus->txq, ~bus->flowcontrol) && txlimit
-		 && DATAOK(bus)) {
+		 && data_ok(bus)) {
 		framecnt = rxdone ? txlimit : min(txlimit, brcmf_txminmax);
 		framecnt = brcmf_sdbrcm_sendfromq(bus, framecnt);
 		txlimit -= framecnt;
@@ -4446,7 +4426,7 @@ clkwait:
 		resched = true;
 	} else if (bus->intstatus || bus->ipend ||
 		(!bus->fcstate && brcmu_pktq_mlen(&bus->txq, ~bus->flowcontrol)
-		 && DATAOK(bus)) || PKT_AVAILABLE()) {
+		 && data_ok(bus)) || PKT_AVAILABLE()) {
 		resched = true;
 	}
 
@@ -4605,7 +4585,7 @@ static int brcmf_sdbrcm_bus_console_in(struct brcmf_pub *drvr,
 	}
 
 	/* Request clock to allow SDIO accesses */
-	BUS_WAKE(bus);
+	bus_wake(bus);
 	/* No pend allowed since txpkt is called later, ht clk has to be on */
 	brcmf_sdbrcm_clkctl(bus, CLK_AVAIL, false);
 
diff --git a/drivers/staging/brcm80211/brcmfmac/sdio_host.h b/drivers/staging/brcm80211/brcmfmac/sdio_host.h
index 67368b9..ddb6656 100644
--- a/drivers/staging/brcm80211/brcmfmac/sdio_host.h
+++ b/drivers/staging/brcm80211/brcmfmac/sdio_host.h
@@ -202,9 +202,6 @@ brcmf_sdcard_recv_buf(struct brcmf_sdio_dev *sdiodev, u32 addr, uint fn,
 /* Async request (vs. sync request) */
 #define SDIO_REQ_ASYNC	0x4
 
-/* Pending (non-error) return code */
-#define BCME_PENDING	1
-
 /* Read/write to memory block (F1, no FIFO) via CMD53 (sync only).
  *   rw:       read or write (0/1)
  *   addr:     direct SDIO address
diff --git a/drivers/staging/brcm80211/brcmfmac/wl_cfg80211.c b/drivers/staging/brcm80211/brcmfmac/wl_cfg80211.c
index c8e47ff..dd56baa 100644
--- a/drivers/staging/brcm80211/brcmfmac/wl_cfg80211.c
+++ b/drivers/staging/brcm80211/brcmfmac/wl_cfg80211.c
@@ -34,6 +34,9 @@
 #include "dhd.h"
 #include "wl_cfg80211.h"
 
+#define BRCMF_ASSOC_PARAMS_FIXED_SIZE \
+	(sizeof(struct brcmf_assoc_params) - sizeof(u16))
+
 static struct sdio_func *cfg80211_sdio_func;
 static struct brcmf_cfg80211_dev *cfg80211_dev;
 static const u8 ether_bcast[ETH_ALEN] = {255, 255, 255, 255, 255, 255};
@@ -309,25 +312,22 @@ static int
 brcmf_debugfs_add_netdev_params(struct brcmf_cfg80211_priv *cfg_priv);
 static void brcmf_debugfs_remove_netdev(struct brcmf_cfg80211_priv *cfg_priv);
 
-#define WL_PRIV_GET()							\
-	({								\
-	struct brcmf_cfg80211_iface *ci = brcmf_get_drvdata(cfg80211_dev); \
-	if (unlikely(!ci)) {						\
-		WL_ERR("wl_cfg80211_dev is unavailable\n");		\
-		BUG();							\
-	}								\
-	ci->cfg_priv;							\
-})
-
-#define CHECK_SYS_UP()							\
-do {									\
-	struct brcmf_cfg80211_priv *cfg_priv = wiphy_to_cfg(wiphy);	\
-	if (unlikely(!test_bit(WL_STATUS_READY, &cfg_priv->status))) {	\
-		WL_INFO("device is not ready : status (%d)\n",		\
-			(int)cfg_priv->status);				\
-		return -EIO;						\
-	}								\
-} while (0)
+static struct brcmf_cfg80211_priv *brcmf_priv_get(void)
+{
+	struct brcmf_cfg80211_iface *ci = brcmf_get_drvdata(cfg80211_dev);
+	return ci->cfg_priv;
+}
+
+static bool check_sys_up(struct wiphy *wiphy)
+{
+	struct brcmf_cfg80211_priv *cfg_priv = wiphy_to_cfg(wiphy);
+	if (!test_bit(WL_STATUS_READY, &cfg_priv->status)) {
+		WL_INFO("device is not ready : status (%d)\n",
+			(int)cfg_priv->status);
+		return false;
+	}
+	return true;
+}
 
 #define CHAN2G(_channel, _freq, _flags) {			\
 	.band			= IEEE80211_BAND_2GHZ,		\
@@ -560,7 +560,8 @@ brcmf_cfg80211_change_iface(struct wiphy *wiphy, struct net_device *ndev,
 	s32 err = 0;
 
 	WL_TRACE("Enter\n");
-	CHECK_SYS_UP();
+	if (!check_sys_up(wiphy))
+		return -EIO;
 
 	switch (type) {
 	case NL80211_IFTYPE_MONITOR:
@@ -815,7 +816,8 @@ brcmf_cfg80211_scan(struct wiphy *wiphy, struct net_device *ndev,
 
 	WL_TRACE("Enter\n");
 
-	CHECK_SYS_UP();
+	if (!check_sys_up(wiphy))
+		return -EIO;
 
 	err = __brcmf_cfg80211_scan(wiphy, ndev, request, NULL);
 	if (unlikely(err))
@@ -910,7 +912,8 @@ static s32 brcmf_cfg80211_set_wiphy_params(struct wiphy *wiphy, u32 changed)
 	s32 err = 0;
 
 	WL_TRACE("Enter\n");
-	CHECK_SYS_UP();
+	if (!check_sys_up(wiphy))
+		return -EIO;
 
 	if (changed & WIPHY_PARAM_RTS_THRESHOLD &&
 	    (cfg_priv->conf->rts_threshold != wiphy->rts_threshold)) {
@@ -958,7 +961,8 @@ brcmf_cfg80211_join_ibss(struct wiphy *wiphy, struct net_device *dev,
 	s32 bcnprd;
 
 	WL_TRACE("Enter\n");
-	CHECK_SYS_UP();
+	if (!check_sys_up(wiphy))
+		return -EIO;
 
 	if (params->ssid)
 		WL_CONN("SSID: %s\n", params->ssid);
@@ -1099,7 +1103,8 @@ brcmf_cfg80211_leave_ibss(struct wiphy *wiphy, struct net_device *dev)
 	s32 err = 0;
 
 	WL_TRACE("Enter\n");
-	CHECK_SYS_UP();
+	if (!check_sys_up(wiphy))
+		return -EIO;
 
 	brcmf_link_down(cfg_priv);
 
@@ -1372,7 +1377,8 @@ brcmf_cfg80211_connect(struct wiphy *wiphy, struct net_device *dev,
 	s32 err = 0;
 
 	WL_TRACE("Enter\n");
-	CHECK_SYS_UP();
+	if (!check_sys_up(wiphy))
+		return -EIO;
 
 	if (unlikely(!sme->ssid)) {
 		WL_ERR("Invalid ssid\n");
@@ -1459,7 +1465,8 @@ brcmf_cfg80211_disconnect(struct wiphy *wiphy, struct net_device *dev,
 	s32 err = 0;
 
 	WL_TRACE("Enter. Reason code = %d\n", reason_code);
-	CHECK_SYS_UP();
+	if (!check_sys_up(wiphy))
+		return -EIO;
 
 	clear_bit(WL_STATUS_CONNECTED, &cfg_priv->status);
 
@@ -1489,7 +1496,8 @@ brcmf_cfg80211_set_tx_power(struct wiphy *wiphy,
 	s32 disable = 0;
 
 	WL_TRACE("Enter\n");
-	CHECK_SYS_UP();
+	if (!check_sys_up(wiphy))
+		return -EIO;
 
 	switch (type) {
 	case NL80211_TX_POWER_AUTOMATIC:
@@ -1541,7 +1549,8 @@ static s32 brcmf_cfg80211_get_tx_power(struct wiphy *wiphy, s32 *dbm)
 	s32 err = 0;
 
 	WL_TRACE("Enter\n");
-	CHECK_SYS_UP();
+	if (!check_sys_up(wiphy))
+		return -EIO;
 
 	err = brcmf_dev_intvar_get(ndev, "qtxpower", &txpwrdbm);
 	if (unlikely(err)) {
@@ -1567,7 +1576,8 @@ brcmf_cfg80211_config_default_key(struct wiphy *wiphy, struct net_device *dev,
 
 	WL_TRACE("Enter\n");
 	WL_CONN("key index (%d)\n", key_idx);
-	CHECK_SYS_UP();
+	if (!check_sys_up(wiphy))
+		return -EIO;
 
 	err = brcmf_dev_ioctl(dev, BRCMF_C_GET_WSEC, &wsec, sizeof(wsec));
 	if (unlikely(err)) {
@@ -1690,7 +1700,8 @@ brcmf_cfg80211_add_key(struct wiphy *wiphy, struct net_device *dev,
 
 	WL_TRACE("Enter\n");
 	WL_CONN("key index (%d)\n", key_idx);
-	CHECK_SYS_UP();
+	if (!check_sys_up(wiphy))
+		return -EIO;
 
 	if (mac_addr) {
 		WL_TRACE("Exit");
@@ -1781,7 +1792,9 @@ brcmf_cfg80211_del_key(struct wiphy *wiphy, struct net_device *dev,
 	s32 wsec;
 
 	WL_TRACE("Enter\n");
-	CHECK_SYS_UP();
+	if (!check_sys_up(wiphy))
+		return -EIO;
+
 	memset(&key, 0, sizeof(key));
 
 	key.index = (u32) key_idx;
@@ -1850,7 +1863,8 @@ brcmf_cfg80211_get_key(struct wiphy *wiphy, struct net_device *dev,
 
 	WL_TRACE("Enter\n");
 	WL_CONN("key index (%d)\n", key_idx);
-	CHECK_SYS_UP();
+	if (!check_sys_up(wiphy))
+		return -EIO;
 
 	memset(&key, 0, sizeof(key));
 	key.index = key_idx;
@@ -1904,7 +1918,6 @@ brcmf_cfg80211_config_default_mgmt_key(struct wiphy *wiphy,
 {
 	WL_INFO("Not supported\n");
 
-	CHECK_SYS_UP();
 	return -EOPNOTSUPP;
 }
 
@@ -1920,7 +1933,8 @@ brcmf_cfg80211_get_station(struct wiphy *wiphy, struct net_device *dev,
 	u8 *bssid = brcmf_read_prof(cfg_priv, WL_PROF_BSSID);
 
 	WL_TRACE("Enter\n");
-	CHECK_SYS_UP();
+	if (!check_sys_up(wiphy))
+		return -EIO;
 
 	if (unlikely
 	    (memcmp(mac, bssid, ETH_ALEN))) {
@@ -2017,7 +2031,8 @@ brcmf_cfg80211_set_bitrate_mask(struct wiphy *wiphy, struct net_device *dev,
 	s32 err = 0;
 
 	WL_TRACE("Enter\n");
-	CHECK_SYS_UP();
+	if (!check_sys_up(wiphy))
+		return -EIO;
 
 	/* addr param is always NULL. ignore it */
 	/* Get current rateset */
@@ -2171,7 +2186,8 @@ brcmf_cfg80211_set_pmksa(struct wiphy *wiphy, struct net_device *dev,
 	int i;
 
 	WL_TRACE("Enter\n");
-	CHECK_SYS_UP();
+	if (!check_sys_up(wiphy))
+		return -EIO;
 
 	for (i = 0; i < pmkids->npmkid; i++)
 		if (!memcmp(pmksa->bssid, pmkids->pmkid[i].BSSID, ETH_ALEN))
@@ -2205,7 +2221,9 @@ brcmf_cfg80211_del_pmksa(struct wiphy *wiphy, struct net_device *dev,
 	int i;
 
 	WL_TRACE("Enter\n");
-	CHECK_SYS_UP();
+	if (!check_sys_up(wiphy))
+		return -EIO;
+
 	memcpy(&pmkid.pmkid[0].BSSID, pmksa->bssid, ETH_ALEN);
 	memcpy(&pmkid.pmkid[0].PMKID, pmksa->pmkid, WLAN_PMKID_LEN);
 
@@ -2250,7 +2268,8 @@ brcmf_cfg80211_flush_pmksa(struct wiphy *wiphy, struct net_device *dev)
 	s32 err = 0;
 
 	WL_TRACE("Enter\n");
-	CHECK_SYS_UP();
+	if (!check_sys_up(wiphy))
+		return -EIO;
 
 	memset(cfg_priv->pmk_list, 0, sizeof(*cfg_priv->pmk_list));
 	err = brcmf_update_pmklist(dev, cfg_priv->pmk_list, err);
@@ -2358,7 +2377,7 @@ wiphy_new_out:
 
 static void brcmf_free_wdev(struct brcmf_cfg80211_priv *cfg_priv)
 {
-	struct wireless_dev *wdev = cfg_to_wdev(cfg_priv);
+	struct wireless_dev *wdev = cfg_priv->wdev;
 
 	if (unlikely(!wdev)) {
 		WL_ERR("wdev is invalid\n");
@@ -2367,7 +2386,7 @@ static void brcmf_free_wdev(struct brcmf_cfg80211_priv *cfg_priv)
 	wiphy_unregister(wdev->wiphy);
 	wiphy_free(wdev->wiphy);
 	kfree(wdev);
-	cfg_to_wdev(cfg_priv) = NULL;
+	cfg_priv->wdev = NULL;
 }
 
 static s32 brcmf_inform_bss(struct brcmf_cfg80211_priv *cfg_priv)
@@ -3460,7 +3479,7 @@ void brcmf_cfg80211_detach(void)
 {
 	struct brcmf_cfg80211_priv *cfg_priv;
 
-	cfg_priv = WL_PRIV_GET();
+	cfg_priv = brcmf_priv_get();
 
 	wl_deinit_priv(cfg_priv);
 	brcmf_free_wdev(cfg_priv);
@@ -3937,7 +3956,7 @@ s32 brcmf_cfg80211_up(void)
 	struct brcmf_cfg80211_priv *cfg_priv;
 	s32 err = 0;
 
-	cfg_priv = WL_PRIV_GET();
+	cfg_priv = brcmf_priv_get();
 	mutex_lock(&cfg_priv->usr_sync);
 	err = __brcmf_cfg80211_up(cfg_priv);
 	mutex_unlock(&cfg_priv->usr_sync);
@@ -3950,7 +3969,7 @@ s32 brcmf_cfg80211_down(void)
 	struct brcmf_cfg80211_priv *cfg_priv;
 	s32 err = 0;
 
-	cfg_priv = WL_PRIV_GET();
+	cfg_priv = brcmf_priv_get();
 	mutex_lock(&cfg_priv->usr_sync);
 	err = __brcmf_cfg80211_down(cfg_priv);
 	mutex_unlock(&cfg_priv->usr_sync);
diff --git a/drivers/staging/brcm80211/brcmfmac/wl_cfg80211.h b/drivers/staging/brcm80211/brcmfmac/wl_cfg80211.h
index 98cd47d..cfbf50d 100644
--- a/drivers/staging/brcm80211/brcmfmac/wl_cfg80211.h
+++ b/drivers/staging/brcm80211/brcmfmac/wl_cfg80211.h
@@ -319,15 +319,39 @@ struct brcmf_cfg80211_priv {
 	u8 ci[0] __aligned(NETDEV_ALIGN);
 };
 
-#define cfg_to_wiphy(w) (w->wdev->wiphy)
-#define wiphy_to_cfg(w) ((struct brcmf_cfg80211_priv *)(wiphy_priv(w)))
-#define cfg_to_wdev(w) (w->wdev)
-#define wdev_to_cfg(w) ((struct brcmf_cfg80211_priv *)(wdev_priv(w)))
-#define cfg_to_ndev(w) (w->wdev->netdev)
-#define ndev_to_cfg(n) (wdev_to_cfg(n->ieee80211_ptr))
+static inline struct wiphy *cfg_to_wiphy(struct brcmf_cfg80211_priv *w)
+{
+	return w->wdev->wiphy;
+}
+
+static inline struct brcmf_cfg80211_priv *wiphy_to_cfg(struct wiphy *w)
+{
+	return (struct brcmf_cfg80211_priv *)(wiphy_priv(w));
+}
+
+static inline struct brcmf_cfg80211_priv *wdev_to_cfg(struct wireless_dev *wd)
+{
+	return (struct brcmf_cfg80211_priv *)(wdev_priv(wd));
+}
+
+static inline struct net_device *cfg_to_ndev(struct brcmf_cfg80211_priv *cfg)
+{
+	return cfg->wdev->netdev;
+}
+
+static inline struct brcmf_cfg80211_priv *ndev_to_cfg(struct net_device *ndev)
+{
+	return wdev_to_cfg(ndev->ieee80211_ptr);
+}
+
 #define iscan_to_cfg(i) ((struct brcmf_cfg80211_priv *)(i->data))
 #define cfg_to_iscan(w) (w->iscan)
-#define cfg_to_conn(w) (&w->conn_info)
+
+static inline struct
+brcmf_cfg80211_connect_info *cfg_to_conn(struct brcmf_cfg80211_priv *cfg)
+{
+	return &cfg->conn_info;
+}
 
 static inline struct brcmf_bss_info *next_bss(struct brcmf_scan_results *list,
 					   struct brcmf_bss_info *bss)
-- 
1.7.4.1


