Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mms1.broadcom.com ([216.31.210.17]:3471 "EHLO mms1.broadcom.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752054Ab2IMTMZ (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 13 Sep 2012 15:12:25 -0400
From: "Arend van Spriel" <arend@broadcom.com>
To: "John W. Linville" <linville@tuxdriver.com>
cc: "Linux Wireless List" <linux-wireless@vger.kernel.org>,
	"Franky Lin" <frankyl@broadcom.com>, "Wei Ni" <wni@nvidia.com>,
	"Stephen Warren" <swarren@wwwdotorg.org>,
	"Arend van Spriel" <arend@broadcom.com>
Subject: [PATCH 07/10] brcmfmac: clear status for in-band interrupt in
 brcmf_sdbrcm_isr
Date: Thu, 13 Sep 2012 21:12:03 +0200
Message-ID: <1347563526-12513-8-git-send-email-arend@broadcom.com> (sfid-20120913_212552_341949_19DF3178)
In-Reply-To: <1347563526-12513-1-git-send-email-arend@broadcom.com>
References: <1347563526-12513-1-git-send-email-arend@broadcom.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Franky Lin <frankyl@broadcom.com>

SDIO in-band interrupt is level sensitive according to SDIO standard.
When the register interrupt handler gets called by SDIO stack it is
running in non interrupt context and expected to clear the interrupt
from the dongle. Therefore in-band and out-of-band interrupt need to
be handled differently.

Cc: Wei Ni <wni@nvidia.com>
Cc: Stephen Warren <swarren@wwwdotorg.org>

Reported-by: Wei Ni <wni@nvidia.com>
Reviewed-by: Hante Meuleman <meuleman@broadcom.com>
Reviewed-by: Pieter-Paul Giesberts <pieterpg@broadcom.com>
Reviewed-by: Arend van Spriel <arend@broadcom.com>
Signed-off-by: Franky Lin <frankyl@broadcom.com>
Signed-off-by: Arend van Spriel <arend@broadcom.com>
---
 drivers/net/wireless/brcm80211/brcmfmac/bcmsdh.c   |    2 +-
 drivers/net/wireless/brcm80211/brcmfmac/dhd_sdio.c |   97 +++++++++++++-------
 .../net/wireless/brcm80211/brcmfmac/sdio_host.h    |    2 +
 3 files changed, 68 insertions(+), 33 deletions(-)

diff --git a/drivers/net/wireless/brcm80211/brcmfmac/bcmsdh.c b/drivers/net/wireless/brcm80211/brcmfmac/bcmsdh.c
index 0c1d08a..3b2c4c2 100644
--- a/drivers/net/wireless/brcm80211/brcmfmac/bcmsdh.c
+++ b/drivers/net/wireless/brcm80211/brcmfmac/bcmsdh.c
@@ -185,7 +185,7 @@ brcmf_sdcard_set_sbaddr_window(struct brcmf_sdio_dev *sdiodev, u32 address)
 	return err;
 }
 
-static int
+int
 brcmf_sdio_regrw_helper(struct brcmf_sdio_dev *sdiodev, u32 addr,
 			void *data, bool write)
 {
diff --git a/drivers/net/wireless/brcm80211/brcmfmac/dhd_sdio.c b/drivers/net/wireless/brcm80211/brcmfmac/dhd_sdio.c
index 619f3cd..ff7e829 100644
--- a/drivers/net/wireless/brcm80211/brcmfmac/dhd_sdio.c
+++ b/drivers/net/wireless/brcm80211/brcmfmac/dhd_sdio.c
@@ -494,8 +494,8 @@ struct brcmf_sdio {
 	u32 ramsize;		/* Size of RAM in SOCRAM (bytes) */
 
 	u32 hostintmask;	/* Copy of Host Interrupt Mask */
-	u32 intstatus;	/* Intstatus bits (events) pending */
-	bool fcstate;		/* State of dongle flow-control */
+	atomic_t intstatus;	/* Intstatus bits (events) pending */
+	atomic_t fcstate;	/* State of dongle flow-control */
 
 	uint blocksize;		/* Block size of SDIO transfers */
 	uint roundup;		/* Max roundup limit */
@@ -2271,20 +2271,53 @@ static inline void brcmf_sdbrcm_adddpctsk(struct brcmf_sdio *bus)
 	spin_unlock_irqrestore(&bus->dpc_tl_lock, flags);
 }
 
+static int brcmf_sdio_intr_rstatus(struct brcmf_sdio *bus)
+{
+	u8 idx;
+	u32 addr;
+	unsigned long val;
+	int n, ret;
+
+	idx = brcmf_sdio_chip_getinfidx(bus->ci, BCMA_CORE_SDIO_DEV);
+	addr = bus->ci->c_inf[idx].base +
+	       offsetof(struct sdpcmd_regs, intstatus);
+
+	ret = brcmf_sdio_regrw_helper(bus->sdiodev, addr, &val, false);
+	bus->sdcnt.f1regdata++;
+	if (ret != 0)
+		val = 0;
+
+	val &= bus->hostintmask;
+	atomic_set(&bus->fcstate, !!(val & I_HMB_FC_STATE));
+
+	/* Clear interrupts */
+	if (val) {
+		ret = brcmf_sdio_regrw_helper(bus->sdiodev, addr, &val, true);
+		bus->sdcnt.f1regdata++;
+	}
+
+	if (ret) {
+		atomic_set(&bus->intstatus, 0);
+	} else if (val) {
+		for_each_set_bit(n, &val, 32)
+			set_bit(n, (unsigned long *)&bus->intstatus.counter);
+	}
+
+	return ret;
+}
+
 static void brcmf_sdbrcm_dpc(struct brcmf_sdio *bus)
 {
-	u32 intstatus, newstatus = 0;
+	u32 newstatus = 0;
+	unsigned long intstatus;
 	uint rxlimit = bus->rxbound;	/* Rx frames to read before resched */
 	uint txlimit = bus->txbound;	/* Tx frames to send before resched */
 	uint framecnt = 0;	/* Temporary counter of tx/rx frames */
 	bool rxdone = true;	/* Flag for no more read data */
-	int err = 0;
+	int err = 0, n;
 
 	brcmf_dbg(TRACE, "Enter\n");
 
-	/* Start with leftover status bits */
-	intstatus = bus->intstatus;
-
 	down(&bus->sdsem);
 
 	/* If waiting for HTAVAIL, check status */
@@ -2339,24 +2372,13 @@ static void brcmf_sdbrcm_dpc(struct brcmf_sdio *bus)
 	/* Pending interrupt indicates new device status */
 	if (atomic_read(&bus->ipend) > 0) {
 		atomic_set(&bus->ipend, 0);
-		err = r_sdreg32(bus, &newstatus,
-				offsetof(struct sdpcmd_regs, intstatus));
-		bus->sdcnt.f1regdata++;
-		if (err != 0)
-			newstatus = 0;
-		newstatus &= bus->hostintmask;
-		bus->fcstate = !!(newstatus & I_HMB_FC_STATE);
-		if (newstatus) {
-			err = w_sdreg32(bus, newstatus,
-					offsetof(struct sdpcmd_regs,
-						 intstatus));
-			bus->sdcnt.f1regdata++;
-		}
+		sdio_claim_host(bus->sdiodev->func[1]);
+		err = brcmf_sdio_intr_rstatus(bus);
+		sdio_release_host(bus->sdiodev->func[1]);
 	}
 
-	/* Merge new bits with previous */
-	intstatus |= newstatus;
-	bus->intstatus = 0;
+	/* Start with leftover status bits */
+	intstatus = atomic_xchg(&bus->intstatus, 0);
 
 	/* Handle flow-control change: read new state in case our ack
 	 * crossed another change interrupt.  If change still set, assume
@@ -2370,8 +2392,8 @@ static void brcmf_sdbrcm_dpc(struct brcmf_sdio *bus)
 		err = r_sdreg32(bus, &newstatus,
 				offsetof(struct sdpcmd_regs, intstatus));
 		bus->sdcnt.f1regdata += 2;
-		bus->fcstate =
-		    !!(newstatus & (I_HMB_FC_STATE | I_HMB_FC_CHANGE));
+		atomic_set(&bus->fcstate,
+			   !!(newstatus & (I_HMB_FC_STATE | I_HMB_FC_CHANGE)));
 		intstatus |= (newstatus & bus->hostintmask);
 	}
 
@@ -2416,7 +2438,10 @@ static void brcmf_sdbrcm_dpc(struct brcmf_sdio *bus)
 	}
 
 	/* Keep still-pending events for next scheduling */
-	bus->intstatus = intstatus;
+	if (intstatus) {
+		for_each_set_bit(n, &intstatus, 32)
+			set_bit(n, (unsigned long *)&bus->intstatus.counter);
+	}
 
 	brcmf_sdbrcm_clrintr(bus);
 
@@ -2461,7 +2486,7 @@ static void brcmf_sdbrcm_dpc(struct brcmf_sdio *bus)
 		brcmf_sdbrcm_wait_event_wakeup(bus);
 	}
 	/* Send queued frames (limit 1 if rx may still be pending) */
-	else if ((bus->clkstate == CLK_AVAIL) && !bus->fcstate &&
+	else if ((bus->clkstate == CLK_AVAIL) && !atomic_read(&bus->fcstate) &&
 		 brcmu_pktq_mlen(&bus->txq, ~bus->flowcontrol) && txlimit
 		 && data_ok(bus)) {
 		framecnt = rxdone ? txlimit : min(txlimit, bus->txminmax);
@@ -2472,10 +2497,12 @@ static void brcmf_sdbrcm_dpc(struct brcmf_sdio *bus)
 	if ((bus->sdiodev->bus_if->state == BRCMF_BUS_DOWN) || (err != 0)) {
 		brcmf_dbg(ERROR, "failed backplane access over SDIO, halting operation\n");
 		bus->sdiodev->bus_if->state = BRCMF_BUS_DOWN;
-		bus->intstatus = 0;
-	} else if (bus->intstatus || atomic_read(&bus->ipend) > 0 ||
-		(!bus->fcstate && brcmu_pktq_mlen(&bus->txq, ~bus->flowcontrol)
-		 && data_ok(bus)) || PKT_AVAILABLE()) {
+		atomic_set(&bus->intstatus, 0);
+	} else if (atomic_read(&bus->intstatus) ||
+		   atomic_read(&bus->ipend) > 0 ||
+		   (!atomic_read(&bus->fcstate) &&
+		    brcmu_pktq_mlen(&bus->txq, ~bus->flowcontrol) &&
+		    data_ok(bus)) || PKT_AVAILABLE()) {
 		brcmf_sdbrcm_adddpctsk(bus);
 	}
 
@@ -3640,7 +3667,13 @@ void brcmf_sdbrcm_isr(void *arg)
 	}
 	/* Count the interrupt call */
 	bus->sdcnt.intrcount++;
-	atomic_set(&bus->ipend, 1);
+	if (in_interrupt())
+		atomic_set(&bus->ipend, 1);
+	else
+		if (brcmf_sdio_intr_rstatus(bus)) {
+			brcmf_dbg(ERROR, "failed backplane access\n");
+			bus->sdiodev->bus_if->state = BRCMF_BUS_DOWN;
+		}
 
 	/* Disable additional interrupts (is this needed now)? */
 	if (!bus->intr)
diff --git a/drivers/net/wireless/brcm80211/brcmfmac/sdio_host.h b/drivers/net/wireless/brcm80211/brcmfmac/sdio_host.h
index 29bf78d2..0d30afd 100644
--- a/drivers/net/wireless/brcm80211/brcmfmac/sdio_host.h
+++ b/drivers/net/wireless/brcm80211/brcmfmac/sdio_host.h
@@ -174,6 +174,8 @@ extern void brcmf_sdio_regwb(struct brcmf_sdio_dev *sdiodev, u32 addr,
 			     u8 data, int *ret);
 extern void brcmf_sdio_regwl(struct brcmf_sdio_dev *sdiodev, u32 addr,
 			     u32 data, int *ret);
+extern int brcmf_sdio_regrw_helper(struct brcmf_sdio_dev *sdiodev, u32 addr,
+				   void *data, bool write);
 
 /* Buffer transfer to/from device (client) core via cmd53.
  *   fn:       function number
-- 
1.7.9.5


