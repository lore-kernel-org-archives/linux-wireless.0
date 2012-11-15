Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from youngberry.canonical.com ([91.189.89.112]:58946 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1767908Ab2KOOI4 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 15 Nov 2012 09:08:56 -0500
From: Seth Forshee <seth.forshee@canonical.com>
To: Arend van Spriel <arend@broadcom.com>,
	linux-wireless@vger.kernel.org
Cc: "John W. Linville" <linville@tuxdriver.com>,
	"Franky (Zhenhui) Lin" <frankyl@broadcom.com>,
	Brett Rudley <brudley@broadcom.com>,
	Roland Vossen <rvossen@broadcom.com>,
	Kan Yan <kanyan@broadcom.com>, brcm80211-dev-list@broadcom.com,
	Daniel Wagner <wagi@monom.org>,
	Seth Forshee <seth.forshee@canonical.com>
Subject: [PATCH v2 19/22] brcmsmac: Improve tx trace and debug support
Date: Thu, 15 Nov 2012 08:08:09 -0600
Message-Id: <1352988492-21340-20-git-send-email-seth.forshee@canonical.com> (sfid-20121115_150904_547814_4F485D72)
In-Reply-To: <1352988492-21340-1-git-send-email-seth.forshee@canonical.com>
References: <1352988492-21340-1-git-send-email-seth.forshee@canonical.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Add the brcmsmac_tx trace system for tx debugging. Existing code to dump
tx status and descriptors are converted to using tracepoints, allowing
for more efficient collection and post-processing of this data. These
tracepoints are placed to collect data for all tx frames instead of only
on errors. Logging of tx errors is also improved.

Acked-by: Arend van Spriel <arend@broadcom.com>
Signed-off-by: Seth Forshee <seth.forshee@canonical.com>
---
 drivers/net/wireless/brcm80211/brcmsmac/ampdu.c    |   11 +-
 .../brcm80211/brcmsmac/brcms_trace_events.h        |   53 ++++
 drivers/net/wireless/brcm80211/brcmsmac/main.c     |  271 +++-----------------
 drivers/net/wireless/brcm80211/brcmsmac/main.h     |    9 -
 4 files changed, 94 insertions(+), 250 deletions(-)

diff --git a/drivers/net/wireless/brcm80211/brcmsmac/ampdu.c b/drivers/net/wireless/brcm80211/brcmsmac/ampdu.c
index 56d2d6b..1de94f3 100644
--- a/drivers/net/wireless/brcm80211/brcmsmac/ampdu.c
+++ b/drivers/net/wireless/brcm80211/brcmsmac/ampdu.c
@@ -22,6 +22,7 @@
 #include "main.h"
 #include "ampdu.h"
 #include "debug.h"
+#include "brcms_trace_events.h"
 
 /* max number of mpdus in an ampdu */
 #define AMPDU_MAX_MPDU			32
@@ -930,12 +931,6 @@ brcms_c_ampdu_dotxstatus_complete(struct ampdu_info *ampdu, struct scb *scb,
 			brcms_err(wlc->hw->d11core,
 				  "%s: ampdu tx phy error (0x%x)\n",
 				  __func__, txs->phyerr);
-
-			if (brcm_msg_level & BRCM_DL_INFO) {
-				brcmu_prpkt("txpkt (AMPDU)", p);
-				brcms_c_print_txdesc((struct d11txh *) p->data);
-			}
-			brcms_c_print_txstatus(txs);
 		}
 	}
 
@@ -948,6 +943,8 @@ brcms_c_ampdu_dotxstatus_complete(struct ampdu_info *ampdu, struct scb *scb,
 		h = (struct ieee80211_hdr *)(plcp + D11_PHY_HDR_LEN);
 		seq = le16_to_cpu(h->seq_ctrl) >> SEQNUM_SHIFT;
 
+		trace_brcms_txdesc(&wlc->hw->d11core->dev, txh, sizeof(*txh));
+
 		if (tot_mpdu == 0) {
 			mcs = plcp[0] & MIMO_PLCP_MCS_MASK;
 			mimoantsel = le16_to_cpu(txh->ABI_MimoAntSel);
@@ -1077,6 +1074,8 @@ brcms_c_ampdu_dotxstatus(struct ampdu_info *ampdu, struct scb *scb,
 		while (p) {
 			tx_info = IEEE80211_SKB_CB(p);
 			txh = (struct d11txh *) p->data;
+			trace_brcms_txdesc(&wlc->hw->d11core->dev, txh,
+					   sizeof(*txh));
 			mcl = le16_to_cpu(txh->MacTxControlLow);
 			brcmu_pkt_buf_free_skb(p);
 			/* break out if last packet of ampdu */
diff --git a/drivers/net/wireless/brcm80211/brcmsmac/brcms_trace_events.h b/drivers/net/wireless/brcm80211/brcmsmac/brcms_trace_events.h
index a9aed1f..96a962a 100644
--- a/drivers/net/wireless/brcm80211/brcmsmac/brcms_trace_events.h
+++ b/drivers/net/wireless/brcm80211/brcmsmac/brcms_trace_events.h
@@ -18,6 +18,8 @@
 
 #define __TRACE_BRCMSMAC_H
 
+#include <linux/types.h>
+#include <linux/device.h>
 #include <linux/tracepoint.h>
 #include "mac80211_if.h"
 
@@ -84,6 +86,57 @@ TRACE_EVENT(brcms_dpc,
 );
 
 #undef TRACE_SYSTEM
+#define TRACE_SYSTEM brcmsmac_tx
+
+TRACE_EVENT(brcms_txdesc,
+	TP_PROTO(const struct device *dev,
+		 void *txh, size_t txh_len),
+	TP_ARGS(dev, txh, txh_len),
+	TP_STRUCT__entry(
+		__string(dev, dev_name(dev))
+		__dynamic_array(u8, txh, txh_len)
+	),
+	TP_fast_assign(
+		__assign_str(dev, dev_name(dev));
+		memcpy(__get_dynamic_array(txh), txh, txh_len);
+	),
+	TP_printk("[%s] txdesc", __get_str(dev))
+);
+
+TRACE_EVENT(brcms_txstatus,
+	TP_PROTO(const struct device *dev, u16 framelen, u16 frameid,
+		 u16 status, u16 lasttxtime, u16 sequence, u16 phyerr,
+		 u16 ackphyrxsh),
+	TP_ARGS(dev, framelen, frameid, status, lasttxtime, sequence, phyerr,
+		ackphyrxsh),
+	TP_STRUCT__entry(
+		__string(dev, dev_name(dev))
+		__field(u16, framelen)
+		__field(u16, frameid)
+		__field(u16, status)
+		__field(u16, lasttxtime)
+		__field(u16, sequence)
+		__field(u16, phyerr)
+		__field(u16, ackphyrxsh)
+	),
+	TP_fast_assign(
+		__assign_str(dev, dev_name(dev));
+		__entry->framelen = framelen;
+		__entry->frameid = frameid;
+		__entry->status = status;
+		__entry->lasttxtime = lasttxtime;
+		__entry->sequence = sequence;
+		__entry->phyerr = phyerr;
+		__entry->ackphyrxsh = ackphyrxsh;
+	),
+	TP_printk("[%s] FrameId %#04x TxStatus %#04x LastTxTime %#04x "
+		  "Seq %#04x PHYTxStatus %#04x RxAck %#04x",
+		  __get_str(dev), __entry->frameid, __entry->status,
+		  __entry->lasttxtime, __entry->sequence, __entry->phyerr,
+		  __entry->ackphyrxsh)
+);
+
+#undef TRACE_SYSTEM
 #define TRACE_SYSTEM brcmsmac_msg
 
 #define MAX_MSG_LEN	100
diff --git a/drivers/net/wireless/brcm80211/brcmsmac/main.c b/drivers/net/wireless/brcm80211/brcmsmac/main.c
index 58e1f01..289f283 100644
--- a/drivers/net/wireless/brcm80211/brcmsmac/main.c
+++ b/drivers/net/wireless/brcm80211/brcmsmac/main.c
@@ -36,6 +36,7 @@
 #include "soc.h"
 #include "dma.h"
 #include "debug.h"
+#include "brcms_trace_events.h"
 
 /* watchdog timer, in unit of ms */
 #define TIMER_INTERVAL_WATCHDOG		1000
@@ -862,7 +863,7 @@ brcms_c_dotxstatus(struct brcms_c_info *wlc, struct tx_status *txs)
 	struct sk_buff *p = NULL;
 	uint queue = NFIFO;
 	struct dma_pub *dma = NULL;
-	struct d11txh *txh;
+	struct d11txh *txh = NULL;
 	struct scb *scb = NULL;
 	bool free_pdu;
 	int tx_rts, tx_frame_count, tx_rts_count;
@@ -875,6 +876,10 @@ brcms_c_dotxstatus(struct brcms_c_info *wlc, struct tx_status *txs)
 	int i;
 	bool fatal = true;
 
+	trace_brcms_txstatus(&wlc->hw->d11core->dev, txs->framelen,
+			     txs->frameid, txs->status, txs->lasttxtime,
+			     txs->sequence, txs->phyerr, txs->ackphyrxsh);
+
 	/* discard intermediate indications for ucode with one legitimate case:
 	 *   e.g. if "useRTS" is set. ucode did a successful rts/cts exchange,
 	 *   but the subsequent tx of DATA failed. so it will start rts/cts
@@ -888,29 +893,30 @@ brcms_c_dotxstatus(struct brcms_c_info *wlc, struct tx_status *txs)
 	}
 
 	queue = txs->frameid & TXFID_QUEUE_MASK;
-	if (queue >= NFIFO)
+	if (queue >= NFIFO) {
+		brcms_err(wlc->hw->d11core, "queue %u >= NFIFO\n", queue);
 		goto out;
+	}
 
 	dma = wlc->hw->di[queue];
 
 	p = dma_getnexttxp(wlc->hw->di[queue], DMA_RANGE_TRANSMITTED);
-	if (p == NULL)
+	if (p == NULL) {
+		brcms_err(wlc->hw->d11core, "dma_getnexttxp returned null!\n");
 		goto out;
+	}
 
 	txh = (struct d11txh *) (p->data);
 	mcl = le16_to_cpu(txh->MacTxControlLow);
 
-	if (txs->phyerr) {
-		if (brcm_msg_level & BRCM_DL_INFO) {
-			brcms_err(wlc->hw->d11core, "phyerr 0x%x, rate 0x%x\n",
-				  txs->phyerr, txh->MainRates);
-			brcms_c_print_txdesc(txh);
-		}
-		brcms_c_print_txstatus(txs);
-	}
+	if (txs->phyerr)
+		brcms_err(wlc->hw->d11core, "phyerr 0x%x, rate 0x%x\n",
+			  txs->phyerr, txh->MainRates);
 
-	if (txs->frameid != le16_to_cpu(txh->TxFrameID))
+	if (txs->frameid != le16_to_cpu(txh->TxFrameID)) {
+		brcms_err(wlc->hw->d11core, "frameid != txh->TxFrameID\n");
 		goto out;
+	}
 	tx_info = IEEE80211_SKB_CB(p);
 	h = (struct ieee80211_hdr *)((u8 *) (txh + 1) + D11_PHY_HDR_LEN);
 
@@ -923,11 +929,20 @@ brcms_c_dotxstatus(struct brcms_c_info *wlc, struct tx_status *txs)
 		goto out;
 	}
 
+	/*
+	 * brcms_c_ampdu_dotxstatus() will trace tx descriptors for AMPDU
+	 * frames; this traces them for the rest.
+	 */
+	trace_brcms_txdesc(&wlc->hw->d11core->dev, txh, sizeof(*txh));
+
 	supr_status = txs->status & TX_STATUS_SUPR_MASK;
-	if (supr_status == TX_STATUS_SUPR_BADCH)
+	if (supr_status == TX_STATUS_SUPR_BADCH) {
+		unsigned xfts = le16_to_cpu(txh->XtraFrameTypes);
 		brcms_dbg_tx(wlc->hw->d11core,
-			     "Pkt tx suppressed, possibly channel %d\n",
+			     "Pkt tx suppressed, dest chan %u, current %d\n",
+			     (xfts >> XFTS_CHANNEL_SHIFT) & 0xff,
 			     CHSPEC_CHANNEL(wlc->default_bss->chanspec));
+	}
 
 	tx_rts = le16_to_cpu(txh->MacTxControlLow) & TXC_SENDRTS;
 	tx_frame_count =
@@ -1018,8 +1033,13 @@ brcms_c_dotxstatus(struct brcms_c_info *wlc, struct tx_status *txs)
 	fatal = false;
 
  out:
-	if (fatal && p)
-		brcmu_pkt_buf_free_skb(p);
+	if (fatal) {
+		if (txh)
+			trace_brcms_txdesc(&wlc->hw->d11core->dev, txh,
+					   sizeof(*txh));
+		if (p)
+			brcmu_pkt_buf_free_skb(p);
+	}
 
 	if (dma && queue < NFIFO) {
 		u16 ac_queue = brcms_fifo_to_ac(queue);
@@ -1049,8 +1069,6 @@ brcms_b_txstatus(struct brcms_hardware *wlc_hw, bool bound, bool *fatal)
 	 */
 	uint max_tx_num = bound ? TXSBND : -1;
 
-	brcms_dbg_tx(core, "wl%d\n", wlc_hw->unit);
-
 	txs = &txstatus;
 	core = wlc_hw->d11core;
 	*fatal = false;
@@ -5662,45 +5680,6 @@ int brcms_c_module_unregister(struct brcms_pub *pub, const char *name,
 	return -ENODATA;
 }
 
-void brcms_c_print_txstatus(struct tx_status *txs)
-{
-	pr_debug("\ntxpkt (MPDU) Complete\n");
-
-	pr_debug("FrameID: %04x   TxStatus: %04x\n", txs->frameid, txs->status);
-
-	pr_debug("[15:12]  %d  frame attempts\n",
-		  (txs->status & TX_STATUS_FRM_RTX_MASK) >>
-		 TX_STATUS_FRM_RTX_SHIFT);
-	pr_debug(" [11:8]  %d  rts attempts\n",
-		 (txs->status & TX_STATUS_RTS_RTX_MASK) >>
-		 TX_STATUS_RTS_RTX_SHIFT);
-	pr_debug("    [7]  %d  PM mode indicated\n",
-		 txs->status & TX_STATUS_PMINDCTD ? 1 : 0);
-	pr_debug("    [6]  %d  intermediate status\n",
-		 txs->status & TX_STATUS_INTERMEDIATE ? 1 : 0);
-	pr_debug("    [5]  %d  AMPDU\n",
-		 txs->status & TX_STATUS_AMPDU ? 1 : 0);
-	pr_debug("  [4:2]  %d  Frame Suppressed Reason (%s)\n",
-		 (txs->status & TX_STATUS_SUPR_MASK) >> TX_STATUS_SUPR_SHIFT,
-		 (const char *[]) {
-			"None",
-			"PMQ Entry",
-			"Flush request",
-			"Previous frag failure",
-			"Channel mismatch",
-			"Lifetime Expiry",
-			"Underflow"
-		 } [(txs->status & TX_STATUS_SUPR_MASK) >>
-		    TX_STATUS_SUPR_SHIFT]);
-	pr_debug("    [1]  %d  acked\n",
-		 txs->status & TX_STATUS_ACK_RCV ? 1 : 0);
-
-	pr_debug("LastTxTime: %04x Seq: %04x PHYTxStatus: %04x RxAckRSSI: %04x RxAckSQ: %04x\n",
-		 txs->lasttxtime, txs->sequence, txs->phyerr,
-		 (txs->ackphyrxsh & PRXS1_JSSI_MASK) >> PRXS1_JSSI_SHIFT,
-		 (txs->ackphyrxsh & PRXS1_SQ_MASK) >> PRXS1_SQ_SHIFT);
-}
-
 static bool brcms_c_chipmatch_pci(struct bcma_device *core)
 {
 	struct pci_dev *pcidev = core->bus->host_pci;
@@ -5749,184 +5728,6 @@ bool brcms_c_chipmatch(struct bcma_device *core)
 	}
 }
 
-#if defined(DEBUG)
-void brcms_c_print_txdesc(struct d11txh *txh)
-{
-	u16 mtcl = le16_to_cpu(txh->MacTxControlLow);
-	u16 mtch = le16_to_cpu(txh->MacTxControlHigh);
-	u16 mfc = le16_to_cpu(txh->MacFrameControl);
-	u16 tfest = le16_to_cpu(txh->TxFesTimeNormal);
-	u16 ptcw = le16_to_cpu(txh->PhyTxControlWord);
-	u16 ptcw_1 = le16_to_cpu(txh->PhyTxControlWord_1);
-	u16 ptcw_1_Fbr = le16_to_cpu(txh->PhyTxControlWord_1_Fbr);
-	u16 ptcw_1_Rts = le16_to_cpu(txh->PhyTxControlWord_1_Rts);
-	u16 ptcw_1_FbrRts = le16_to_cpu(txh->PhyTxControlWord_1_FbrRts);
-	u16 mainrates = le16_to_cpu(txh->MainRates);
-	u16 xtraft = le16_to_cpu(txh->XtraFrameTypes);
-	u8 *iv = txh->IV;
-	u8 *ra = txh->TxFrameRA;
-	u16 tfestfb = le16_to_cpu(txh->TxFesTimeFallback);
-	u8 *rtspfb = txh->RTSPLCPFallback;
-	u16 rtsdfb = le16_to_cpu(txh->RTSDurFallback);
-	u8 *fragpfb = txh->FragPLCPFallback;
-	u16 fragdfb = le16_to_cpu(txh->FragDurFallback);
-	u16 mmodelen = le16_to_cpu(txh->MModeLen);
-	u16 mmodefbrlen = le16_to_cpu(txh->MModeFbrLen);
-	u16 tfid = le16_to_cpu(txh->TxFrameID);
-	u16 txs = le16_to_cpu(txh->TxStatus);
-	u16 mnmpdu = le16_to_cpu(txh->MaxNMpdus);
-	u16 mabyte = le16_to_cpu(txh->MaxABytes_MRT);
-	u16 mabyte_f = le16_to_cpu(txh->MaxABytes_FBR);
-	u16 mmbyte = le16_to_cpu(txh->MinMBytes);
-
-	u8 *rtsph = txh->RTSPhyHeader;
-	struct ieee80211_rts rts = txh->rts_frame;
-
-	/* add plcp header along with txh descriptor */
-	brcmu_dbg_hex_dump(txh, sizeof(struct d11txh) + 48,
-			   "Raw TxDesc + plcp header:\n");
-
-	pr_debug("TxCtlLow: %04x ", mtcl);
-	pr_debug("TxCtlHigh: %04x ", mtch);
-	pr_debug("FC: %04x ", mfc);
-	pr_debug("FES Time: %04x\n", tfest);
-	pr_debug("PhyCtl: %04x%s ", ptcw,
-	       (ptcw & PHY_TXC_SHORT_HDR) ? " short" : "");
-	pr_debug("PhyCtl_1: %04x ", ptcw_1);
-	pr_debug("PhyCtl_1_Fbr: %04x\n", ptcw_1_Fbr);
-	pr_debug("PhyCtl_1_Rts: %04x ", ptcw_1_Rts);
-	pr_debug("PhyCtl_1_Fbr_Rts: %04x\n", ptcw_1_FbrRts);
-	pr_debug("MainRates: %04x ", mainrates);
-	pr_debug("XtraFrameTypes: %04x ", xtraft);
-	pr_debug("\n");
-
-	print_hex_dump_bytes("SecIV:", DUMP_PREFIX_OFFSET, iv, sizeof(txh->IV));
-	print_hex_dump_bytes("RA:", DUMP_PREFIX_OFFSET,
-			     ra, sizeof(txh->TxFrameRA));
-
-	pr_debug("Fb FES Time: %04x ", tfestfb);
-	print_hex_dump_bytes("Fb RTS PLCP:", DUMP_PREFIX_OFFSET,
-			     rtspfb, sizeof(txh->RTSPLCPFallback));
-	pr_debug("RTS DUR: %04x ", rtsdfb);
-	print_hex_dump_bytes("PLCP:", DUMP_PREFIX_OFFSET,
-			     fragpfb, sizeof(txh->FragPLCPFallback));
-	pr_debug("DUR: %04x", fragdfb);
-	pr_debug("\n");
-
-	pr_debug("MModeLen: %04x ", mmodelen);
-	pr_debug("MModeFbrLen: %04x\n", mmodefbrlen);
-
-	pr_debug("FrameID:     %04x\n", tfid);
-	pr_debug("TxStatus:    %04x\n", txs);
-
-	pr_debug("MaxNumMpdu:  %04x\n", mnmpdu);
-	pr_debug("MaxAggbyte:  %04x\n", mabyte);
-	pr_debug("MaxAggbyte_fb:  %04x\n", mabyte_f);
-	pr_debug("MinByte:     %04x\n", mmbyte);
-
-	print_hex_dump_bytes("RTS PLCP:", DUMP_PREFIX_OFFSET,
-			     rtsph, sizeof(txh->RTSPhyHeader));
-	print_hex_dump_bytes("RTS Frame:", DUMP_PREFIX_OFFSET,
-			     (u8 *)&rts, sizeof(txh->rts_frame));
-	pr_debug("\n");
-}
-#endif				/* defined(DEBUG) */
-
-#if defined(DEBUG)
-static int
-brcms_c_format_flags(const struct brcms_c_bit_desc *bd, u32 flags, char *buf,
-		     int len)
-{
-	int i;
-	char *p = buf;
-	char hexstr[16];
-	int slen = 0, nlen = 0;
-	u32 bit;
-	const char *name;
-
-	if (len < 2 || !buf)
-		return 0;
-
-	buf[0] = '\0';
-
-	for (i = 0; flags != 0; i++) {
-		bit = bd[i].bit;
-		name = bd[i].name;
-		if (bit == 0 && flags != 0) {
-			/* print any unnamed bits */
-			snprintf(hexstr, 16, "0x%X", flags);
-			name = hexstr;
-			flags = 0;	/* exit loop */
-		} else if ((flags & bit) == 0)
-			continue;
-		flags &= ~bit;
-		nlen = strlen(name);
-		slen += nlen;
-		/* count btwn flag space */
-		if (flags != 0)
-			slen += 1;
-		/* need NULL char as well */
-		if (len <= slen)
-			break;
-		/* copy NULL char but don't count it */
-		strncpy(p, name, nlen + 1);
-		p += nlen;
-		/* copy btwn flag space and NULL char */
-		if (flags != 0)
-			p += snprintf(p, 2, " ");
-		len -= slen;
-	}
-
-	/* indicate the str was too short */
-	if (flags != 0) {
-		if (len < 2)
-			p -= 2 - len;	/* overwrite last char */
-		p += snprintf(p, 2, ">");
-	}
-
-	return (int)(p - buf);
-}
-#endif				/* defined(DEBUG) */
-
-#if defined(DEBUG)
-void brcms_c_print_rxh(struct d11rxhdr *rxh)
-{
-	u16 len = rxh->RxFrameSize;
-	u16 phystatus_0 = rxh->PhyRxStatus_0;
-	u16 phystatus_1 = rxh->PhyRxStatus_1;
-	u16 phystatus_2 = rxh->PhyRxStatus_2;
-	u16 phystatus_3 = rxh->PhyRxStatus_3;
-	u16 macstatus1 = rxh->RxStatus1;
-	u16 macstatus2 = rxh->RxStatus2;
-	char flagstr[64];
-	char lenbuf[20];
-	static const struct brcms_c_bit_desc macstat_flags[] = {
-		{RXS_FCSERR, "FCSErr"},
-		{RXS_RESPFRAMETX, "Reply"},
-		{RXS_PBPRES, "PADDING"},
-		{RXS_DECATMPT, "DeCr"},
-		{RXS_DECERR, "DeCrErr"},
-		{RXS_BCNSENT, "Bcn"},
-		{0, NULL}
-	};
-
-	brcmu_dbg_hex_dump(rxh, sizeof(struct d11rxhdr), "Raw RxDesc:\n");
-
-	brcms_c_format_flags(macstat_flags, macstatus1, flagstr, 64);
-
-	snprintf(lenbuf, sizeof(lenbuf), "0x%x", len);
-
-	pr_debug("RxFrameSize:     %6s (%d)%s\n", lenbuf, len,
-	       (rxh->PhyRxStatus_0 & PRXS0_SHORTH) ? " short preamble" : "");
-	pr_debug("RxPHYStatus:     %04x %04x %04x %04x\n",
-	       phystatus_0, phystatus_1, phystatus_2, phystatus_3);
-	pr_debug("RxMACStatus:     %x %s\n", macstatus1, flagstr);
-	pr_debug("RXMACaggtype:    %x\n",
-	       (macstatus2 & RXS_AGGTYPE_MASK));
-	pr_debug("RxTSFTime:       %04x\n", rxh->RxTSFTime);
-}
-#endif				/* defined(DEBUG) */
-
 u16 brcms_b_rate_shm_offset(struct brcms_hardware *wlc_hw, u8 rate)
 {
 	u16 table_ptr;
diff --git a/drivers/net/wireless/brcm80211/brcmsmac/main.h b/drivers/net/wireless/brcm80211/brcmsmac/main.h
index 8a58cc1..fb44774 100644
--- a/drivers/net/wireless/brcm80211/brcmsmac/main.h
+++ b/drivers/net/wireless/brcm80211/brcmsmac/main.h
@@ -612,18 +612,9 @@ struct brcms_bss_cfg {
 
 extern int brcms_c_txfifo(struct brcms_c_info *wlc, uint fifo,
 			   struct sk_buff *p);
-extern void brcms_c_print_txstatus(struct tx_status *txs);
 extern int brcms_b_xmtfifo_sz_get(struct brcms_hardware *wlc_hw, uint fifo,
 		   uint *blocks);
 
-#if defined(DEBUG)
-extern void brcms_c_print_txdesc(struct d11txh *txh);
-#else
-static inline void brcms_c_print_txdesc(struct d11txh *txh)
-{
-}
-#endif
-
 extern int brcms_c_set_gmode(struct brcms_c_info *wlc, u8 gmode, bool config);
 extern void brcms_c_mac_promisc(struct brcms_c_info *wlc, uint filter_flags);
 extern u16 brcms_c_calc_lsig_len(struct brcms_c_info *wlc, u32 ratespec,
-- 
1.7.9.5

