Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mms1.broadcom.com ([216.31.210.17]:1732 "EHLO mms1.broadcom.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753709Ab1JBRPC (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Sun, 2 Oct 2011 13:15:02 -0400
From: "Franky Lin" <frankyl@broadcom.com>
To: gregkh@suse.de
cc: devel@linuxdriverproject.org, linux-wireless@vger.kernel.org
Subject: [PATCH 14/20] staging: brcm80211: removed unused fullmac
 spinlock
Date: Sun, 2 Oct 2011 10:14:39 -0700
Message-ID: <1317575685-3156-15-git-send-email-frankyl@broadcom.com> (sfid-20111002_191547_171641_6476364E)
In-Reply-To: <1317575685-3156-1-git-send-email-frankyl@broadcom.com>
References: <1317575685-3156-1-git-send-email-frankyl@broadcom.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Roland Vossen <rvossen@broadcom.com>

Usage of spinlock depended on module parameters that are going to
be removed in a subsequent patch. Parameter wlc->threads_only is
always 'true'.

Reviewed-by: Pieter-Paul Giesberts <pieterpg@broadcom.com>
Reviewed-by: Arend van Spriel <arend@broadcom.com>
Reviewed-by: Franky Lin <frankyl@broadcom.com>
Signed-off-by: Franky Lin <frankyl@broadcom.com>
---
 drivers/staging/brcm80211/brcmfmac/dhd_sdio.c |   58 +++++++++----------------
 1 files changed, 20 insertions(+), 38 deletions(-)

diff --git a/drivers/staging/brcm80211/brcmfmac/dhd_sdio.c b/drivers/staging/brcm80211/brcmfmac/dhd_sdio.c
index 0def6e3..198d544 100644
--- a/drivers/staging/brcm80211/brcmfmac/dhd_sdio.c
+++ b/drivers/staging/brcm80211/brcmfmac/dhd_sdio.c
@@ -655,7 +655,6 @@ struct brcmf_bus {
 
 	bool threads_only;
 	struct semaphore sdsem;
-	spinlock_t sdlock;
 
 	const char *fw_name;
 	const struct firmware *firmware;
@@ -812,22 +811,6 @@ static void brcmf_sdbrcm_pktfree2(struct brcmf_bus *bus, struct sk_buff *pkt)
 		brcmu_pkt_buf_free_skb(pkt);
 }
 
-static void brcmf_sdbrcm_sdlock(struct brcmf_bus *bus)
-{
-	if (bus->threads_only)
-		down(&bus->sdsem);
-	else
-		spin_lock_bh(&bus->sdlock);
-}
-
-static void brcmf_sdbrcm_sdunlock(struct brcmf_bus *bus)
-{
-	if (bus->threads_only)
-		up(&bus->sdsem);
-	else
-		spin_unlock_bh(&bus->sdlock);
-}
-
 /* Turn backplane clock on or off */
 static int brcmf_sdbrcm_htclk(struct brcmf_bus *bus, bool on, bool pendok)
 {
@@ -1622,9 +1605,9 @@ static u8 brcmf_sdbrcm_rxglom(struct brcmf_bus *bus, u8 rxseq)
 #endif				/* BCMDBG */
 		}
 		if (num) {
-			brcmf_sdbrcm_sdunlock(bus);
+			up(&bus->sdsem);
 			brcmf_rx_frame(bus->drvr, ifidx, save_pfirst, num);
-			brcmf_sdbrcm_sdlock(bus);
+			down(&bus->sdsem);
 		}
 
 		bus->rxglomframes++;
@@ -2225,9 +2208,9 @@ deliver:
 		}
 
 		/* Unlock during rx call */
-		brcmf_sdbrcm_sdunlock(bus);
+		up(&bus->sdsem);
 		brcmf_rx_frame(bus->drvr, ifidx, pkt, 1);
-		brcmf_sdbrcm_sdlock(bus);
+		down(&bus->sdsem);
 	}
 	rxcount = maxframes - rxleft;
 #ifdef BCMDBG
@@ -2257,10 +2240,10 @@ brcmf_sdbrcm_send_buf(struct brcmf_bus *bus, u32 addr, uint fn, uint flags,
 static void
 brcmf_sdbrcm_wait_for_event(struct brcmf_bus *bus, bool *lockvar)
 {
-	brcmf_sdbrcm_sdunlock(bus);
+	up(&bus->sdsem);
 	wait_event_interruptible_timeout(bus->ctrl_wait,
 					 (*lockvar == false), HZ * 2);
-	brcmf_sdbrcm_sdlock(bus);
+	down(&bus->sdsem);
 	return;
 }
 
@@ -2407,9 +2390,9 @@ static int brcmf_sdbrcm_txpkt(struct brcmf_bus *bus, struct sk_buff *pkt,
 done:
 	/* restore pkt buffer pointer before calling tx complete routine */
 	skb_pull(pkt, SDPCM_HDRLEN + pad);
-	brcmf_sdbrcm_sdunlock(bus);
+	up(&bus->sdsem);
 	brcmf_txcomplete(bus->drvr, pkt, ret != 0);
-	brcmf_sdbrcm_sdlock(bus);
+	down(&bus->sdsem);
 
 	if (free_pkt)
 		brcmu_pkt_buf_free_skb(pkt);
@@ -2487,7 +2470,7 @@ static bool brcmf_sdbrcm_dpc(struct brcmf_bus *bus)
 	/* Start with leftover status bits */
 	intstatus = bus->intstatus;
 
-	brcmf_sdbrcm_sdlock(bus);
+	down(&bus->sdsem);
 
 	/* If waiting for HTAVAIL, check status */
 	if (bus->clkstate == CLK_PENDING) {
@@ -2711,7 +2694,7 @@ clkwait:
 		brcmf_sdbrcm_clkctl(bus, CLK_NONE, false);
 	}
 
-	brcmf_sdbrcm_sdunlock(bus);
+	up(&bus->sdsem);
 
 	return resched;
 }
@@ -3048,7 +3031,7 @@ brcmf_sdbrcm_bus_txctl(struct brcmf_bus *bus, unsigned char *msg, uint msglen)
 	/* precondition: IS_ALIGNED((unsigned long)frame, 2) */
 
 	/* Need to lock here to protect txseq and SDIO tx calls */
-	brcmf_sdbrcm_sdlock(bus);
+	down(&bus->sdsem);
 
 	bus_wake(bus);
 
@@ -3110,7 +3093,7 @@ brcmf_sdbrcm_bus_txctl(struct brcmf_bus *bus, unsigned char *msg, uint msglen)
 		brcmf_sdbrcm_clkctl(bus, CLK_NONE, true);
 	}
 
-	brcmf_sdbrcm_sdunlock(bus);
+	up(&bus->sdsem);
 
 	if (ret)
 		bus->drvr->tx_ctlerrs++;
@@ -3135,11 +3118,11 @@ brcmf_sdbrcm_bus_rxctl(struct brcmf_bus *bus, unsigned char *msg, uint msglen)
 	/* Wait until control frame is available */
 	timeleft = brcmf_sdbrcm_ioctl_resp_wait(bus, &bus->rxlen, &pending);
 
-	brcmf_sdbrcm_sdlock(bus);
+	down(&bus->sdsem);
 	rxlen = bus->rxlen;
 	memcpy(msg, bus->rxctl, min(msglen, rxlen));
 	bus->rxlen = 0;
-	brcmf_sdbrcm_sdunlock(bus);
+	up(&bus->sdsem);
 
 	if (rxlen) {
 		brcmf_dbg(CTL, "resumed on rxctl frame, got %d expected %d\n",
@@ -3677,7 +3660,7 @@ void brcmf_sdbrcm_bus_stop(struct brcmf_bus *bus, bool enforce_mutex)
 	brcmf_dbg(TRACE, "Enter\n");
 
 	if (enforce_mutex)
-		brcmf_sdbrcm_sdlock(bus);
+		down(&bus->sdsem);
 
 	bus_wake(bus);
 
@@ -3749,7 +3732,7 @@ void brcmf_sdbrcm_bus_stop(struct brcmf_bus *bus, bool enforce_mutex)
 	bus->tx_seq = bus->rx_seq = 0;
 
 	if (enforce_mutex)
-		brcmf_sdbrcm_sdunlock(bus);
+		up(&bus->sdsem);
 }
 
 int brcmf_sdbrcm_bus_init(struct brcmf_pub *drvr, bool enforce_mutex)
@@ -3777,7 +3760,7 @@ int brcmf_sdbrcm_bus_init(struct brcmf_pub *drvr, bool enforce_mutex)
 	brcmf_sdbrcm_wd_timer(bus, BRCMF_WD_POLL_MS);
 
 	if (enforce_mutex)
-		brcmf_sdbrcm_sdlock(bus);
+		down(&bus->sdsem);
 
 	/* Make sure backplane clock is on, needed to generate F2 interrupt */
 	brcmf_sdbrcm_clkctl(bus, CLK_AVAIL, false);
@@ -3851,7 +3834,7 @@ int brcmf_sdbrcm_bus_init(struct brcmf_pub *drvr, bool enforce_mutex)
 
 exit:
 	if (enforce_mutex)
-		brcmf_sdbrcm_sdunlock(bus);
+		up(&bus->sdsem);
 
 	return ret;
 }
@@ -3904,7 +3887,7 @@ static bool brcmf_sdbrcm_bus_watchdog(struct brcmf_pub *drvr)
 	if (bus->sleeping)
 		return false;
 
-	brcmf_sdbrcm_sdlock(bus);
+	down(&bus->sdsem);
 
 	/* Poll period: check device if appropriate. */
 	if (bus->poll && (++bus->polltick >= bus->pollrate)) {
@@ -3969,7 +3952,7 @@ static bool brcmf_sdbrcm_bus_watchdog(struct brcmf_pub *drvr)
 		}
 	}
 
-	brcmf_sdbrcm_sdunlock(bus);
+	up(&bus->sdsem);
 
 	return bus->ipend;
 }
@@ -4562,7 +4545,6 @@ void *brcmf_sdbrcm_probe(u16 bus_no, u16 slot, u16 func, uint bustype,
 		sema_init(&bus->sdsem, 1);
 	} else {
 		bus->threads_only = false;
-		spin_lock_init(&bus->sdlock);
 	}
 
 	if (brcmf_dpc_prio >= 0) {
-- 
1.7.1


