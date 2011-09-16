Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mms2.broadcom.com ([216.31.210.18]:4649 "EHLO mms2.broadcom.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932134Ab1IPT2V (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 16 Sep 2011 15:28:21 -0400
From: "Franky Lin" <frankyl@broadcom.com>
To: gregkh@suse.de
cc: devel@linuxdriverproject.org, linux-wireless@vger.kernel.org
Subject: [PATCH 03/19] staging: brcm80211: remove fullmac module_param
 brcmf_deferred_tx
Date: Fri, 16 Sep 2011 12:27:52 -0700
Message-ID: <1316201288-29635-4-git-send-email-frankyl@broadcom.com> (sfid-20110916_212826_929956_5346E6B0)
In-Reply-To: <1316201288-29635-1-git-send-email-frankyl@broadcom.com>
References: <1316201288-29635-1-git-send-email-frankyl@broadcom.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Remove brcmf_deferred_tx as it should be always 1

Reported-by: Johannes Berg <johannes@sipsolutions.net>
Reviewed-by: Roland Vossen <rvossen@broadcom.com>
Reviewed-by: Arend van Spriel <arend@broadcom.com>
Signed-off-by: Franky Lin <frankyl@broadcom.com>
---
 drivers/staging/brcm80211/brcmfmac/dhd_sdio.c |   83 +++++++-----------------
 1 files changed, 24 insertions(+), 59 deletions(-)

diff --git a/drivers/staging/brcm80211/brcmfmac/dhd_sdio.c b/drivers/staging/brcm80211/brcmfmac/dhd_sdio.c
index 680b232..dade3ec 100644
--- a/drivers/staging/brcm80211/brcmfmac/dhd_sdio.c
+++ b/drivers/staging/brcm80211/brcmfmac/dhd_sdio.c
@@ -721,10 +721,6 @@ static int qcount[NUMPRIO];
 static int tx_packets[NUMPRIO];
 #endif				/* BCMDBG */
 
-/* Deferred transmit */
-uint brcmf_deferred_tx = 1;
-module_param(brcmf_deferred_tx, uint, 0);
-
 /* Watchdog thread priority, -1 to use kernel timer */
 int brcmf_watchdog_prio = 97;
 module_param(brcmf_watchdog_prio, int, 0);
@@ -2845,63 +2841,33 @@ int brcmf_sdbrcm_bus_txdata(struct brcmf_bus *bus, struct sk_buff *pkt)
 
 	/* Check for existing queue, current flow-control,
 			 pending event, or pending clock */
-	if (brcmf_deferred_tx || bus->fcstate || pktq_len(&bus->txq)
-	    || bus->dpc_sched || (!data_ok(bus))
-	    || (bus->flowcontrol & NBITVAL(prec))
-	    || (bus->clkstate != CLK_AVAIL)) {
-		brcmf_dbg(TRACE, "deferring pktq len %d\n",
-			  pktq_len(&bus->txq));
-		bus->fcqueued++;
-
-		/* Priority based enq */
-		spin_lock_bh(&bus->txqlock);
-		if (brcmf_c_prec_enq(bus->drvr, &bus->txq, pkt, prec) ==
-		    false) {
-			skb_pull(pkt, SDPCM_HDRLEN);
-			brcmf_txcomplete(bus->drvr, pkt, false);
-			brcmu_pkt_buf_free_skb(pkt);
-			brcmf_dbg(ERROR, "out of bus->txq !!!\n");
-			ret = -ENOSR;
-		} else {
-			ret = 0;
-		}
-		spin_unlock_bh(&bus->txqlock);
+	brcmf_dbg(TRACE, "deferring pktq len %d\n", pktq_len(&bus->txq));
+	bus->fcqueued++;
+
+	/* Priority based enq */
+	spin_lock_bh(&bus->txqlock);
+	if (brcmf_c_prec_enq(bus->drvr, &bus->txq, pkt, prec) == false) {
+		skb_pull(pkt, SDPCM_HDRLEN);
+		brcmf_txcomplete(bus->drvr, pkt, false);
+		brcmu_pkt_buf_free_skb(pkt);
+		brcmf_dbg(ERROR, "out of bus->txq !!!\n");
+		ret = -ENOSR;
+	} else {
+		ret = 0;
+	}
+	spin_unlock_bh(&bus->txqlock);
 
-		if (pktq_len(&bus->txq) >= TXHI)
-			brcmf_txflowcontrol(bus->drvr, 0, ON);
+	if (pktq_len(&bus->txq) >= TXHI)
+		brcmf_txflowcontrol(bus->drvr, 0, ON);
 
 #ifdef BCMDBG
-		if (pktq_plen(&bus->txq, prec) > qcount[prec])
-			qcount[prec] = pktq_plen(&bus->txq, prec);
+	if (pktq_plen(&bus->txq, prec) > qcount[prec])
+		qcount[prec] = pktq_plen(&bus->txq, prec);
 #endif
-		/* Schedule DPC if needed to send queued packet(s) */
-		if (brcmf_deferred_tx && !bus->dpc_sched) {
-			bus->dpc_sched = true;
-			brcmf_sdbrcm_sched_dpc(bus);
-		}
-	} else {
-		/* Lock: we're about to use shared data/code (and SDIO) */
-		brcmf_sdbrcm_sdlock(bus);
-
-		/* Otherwise, send it now */
-		bus_wake(bus);
-		/* Make sure back plane ht clk is on, no pending allowed */
-		brcmf_sdbrcm_clkctl(bus, CLK_AVAIL, true);
-
-		brcmf_dbg(TRACE, "calling txpkt\n");
-		ret = brcmf_sdbrcm_txpkt(bus, pkt, SDPCM_DATA_CHANNEL, true);
-		if (ret)
-			bus->drvr->tx_errors++;
-		else
-			bus->drvr->dstats.tx_bytes += datalen;
-
-		if (bus->idletime == BRCMF_IDLE_IMMEDIATE &&
-		    !bus->dpc_sched) {
-			bus->activity = false;
-			brcmf_sdbrcm_clkctl(bus, CLK_NONE, true);
-		}
-
-		brcmf_sdbrcm_sdunlock(bus);
+	/* Schedule DPC if needed to send queued packet(s) */
+	if (!bus->dpc_sched) {
+		bus->dpc_sched = true;
+		brcmf_sdbrcm_sched_dpc(bus);
 	}
 
 	return ret;
@@ -5013,8 +4979,7 @@ int brcmf_bus_register(void)
 			break;
 
 		/* If both watchdog and DPC are threads, TX must be deferred */
-		if ((brcmf_watchdog_prio >= 0) && (brcmf_dpc_prio >= 0)
-		    && brcmf_deferred_tx)
+		if (brcmf_watchdog_prio >= 0 && brcmf_dpc_prio >= 0)
 			break;
 
 		brcmf_dbg(ERROR, "Invalid module parameters.\n");
-- 
1.7.1


