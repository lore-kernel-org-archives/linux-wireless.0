Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mms1.broadcom.com ([216.31.210.17]:3441 "EHLO mms1.broadcom.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752257Ab2IMTMZ (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 13 Sep 2012 15:12:25 -0400
From: "Arend van Spriel" <arend@broadcom.com>
To: "John W. Linville" <linville@tuxdriver.com>
cc: "Linux Wireless List" <linux-wireless@vger.kernel.org>,
	"Franky Lin" <frankyl@broadcom.com>,
	"Arend van Spriel" <arend@broadcom.com>
Subject: [PATCH 03/10] brcmfmac: use atomic variable for interrupt
 pending flag
Date: Thu, 13 Sep 2012 21:11:59 +0200
Message-ID: <1347563526-12513-4-git-send-email-arend@broadcom.com> (sfid-20120913_211231_108309_FE32A2BA)
In-Reply-To: <1347563526-12513-1-git-send-email-arend@broadcom.com>
References: <1347563526-12513-1-git-send-email-arend@broadcom.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Franky Lin <frankyl@broadcom.com>

Interrupt pending flag used in SDIO bus layer could be used in
multiple processes in different context. Use atomic_t make sure
every interrupt is handled.

Reviewed-by: Hante Meuleman <meuleman@broadcom.com>
Reviewed-by: Pieter-Paul Giesberts <pieterpg@broadcom.com>
Reviewed-by: Arend van Spriel <arend@broadcom.com>
Signed-off-by: Franky Lin <frankyl@broadcom.com>
Signed-off-by: Arend van Spriel <arend@broadcom.com>
---
 drivers/net/wireless/brcm80211/brcmfmac/dhd_sdio.c |   18 +++++++++---------
 1 file changed, 9 insertions(+), 9 deletions(-)

diff --git a/drivers/net/wireless/brcm80211/brcmfmac/dhd_sdio.c b/drivers/net/wireless/brcm80211/brcmfmac/dhd_sdio.c
index 2ca9e8c..b0794e8 100644
--- a/drivers/net/wireless/brcm80211/brcmfmac/dhd_sdio.c
+++ b/drivers/net/wireless/brcm80211/brcmfmac/dhd_sdio.c
@@ -531,7 +531,7 @@ struct brcmf_sdio {
 
 	bool intr;		/* Use interrupts */
 	bool poll;		/* Use polling */
-	bool ipend;		/* Device interrupt is pending */
+	atomic_t ipend;		/* Device interrupt is pending */
 	uint spurious;		/* Count of spurious interrupts */
 	uint pollrate;		/* Ticks between device polls */
 	uint polltick;		/* Tick counter */
@@ -2151,7 +2151,7 @@ static uint brcmf_sdbrcm_sendfromq(struct brcmf_sdio *bus, uint maxframes)
 			if (ret != 0)
 				break;
 			if (intstatus & bus->hostintmask)
-				bus->ipend = true;
+				atomic_set(&bus->ipend, 1);
 		}
 	}
 
@@ -2249,7 +2249,7 @@ static inline void brcmf_sdbrcm_clrintr(struct brcmf_sdio *bus)
 	unsigned long flags;
 
 	spin_lock_irqsave(&bus->sdiodev->irq_en_lock, flags);
-	if (!bus->sdiodev->irq_en && !bus->ipend) {
+	if (!bus->sdiodev->irq_en && !atomic_read(&bus->ipend)) {
 		enable_irq(bus->sdiodev->irq);
 		bus->sdiodev->irq_en = true;
 	}
@@ -2332,8 +2332,8 @@ static bool brcmf_sdbrcm_dpc(struct brcmf_sdio *bus)
 		goto clkwait;
 
 	/* Pending interrupt indicates new device status */
-	if (bus->ipend) {
-		bus->ipend = false;
+	if (atomic_read(&bus->ipend) > 0) {
+		atomic_set(&bus->ipend, 0);
 		err = r_sdreg32(bus, &newstatus,
 				offsetof(struct sdpcmd_regs, intstatus));
 		bus->sdcnt.f1regdata++;
@@ -2478,7 +2478,7 @@ clkwait:
 	} else if (bus->clkstate == CLK_PENDING) {
 		brcmf_dbg(INFO, "rescheduled due to CLK_PENDING awaiting I_CHIPACTIVE interrupt\n");
 		resched = true;
-	} else if (bus->intstatus || bus->ipend ||
+	} else if (bus->intstatus || atomic_read(&bus->ipend) > 0 ||
 		(!bus->fcstate && brcmu_pktq_mlen(&bus->txq, ~bus->flowcontrol)
 		 && data_ok(bus)) || PKT_AVAILABLE()) {
 		resched = true;
@@ -3692,7 +3692,7 @@ void brcmf_sdbrcm_isr(void *arg)
 	}
 	/* Count the interrupt call */
 	bus->sdcnt.intrcount++;
-	bus->ipend = true;
+	atomic_set(&bus->ipend, 1);
 
 	/* Disable additional interrupts (is this needed now)? */
 	if (!bus->intr)
@@ -3740,7 +3740,7 @@ static bool brcmf_sdbrcm_bus_watchdog(struct brcmf_sdio *bus)
 				 schedule the DPC */
 			if (intstatus) {
 				bus->sdcnt.pollcnt++;
-				bus->ipend = true;
+				atomic_set(&bus->ipend, 1);
 
 				bus->dpc_sched = true;
 				if (bus->dpc_tsk) {
@@ -3784,7 +3784,7 @@ static bool brcmf_sdbrcm_bus_watchdog(struct brcmf_sdio *bus)
 
 	up(&bus->sdsem);
 
-	return bus->ipend;
+	return (atomic_read(&bus->ipend) > 0);
 }
 
 static bool brcmf_sdbrcm_chipmatch(u16 chipid)
-- 
1.7.9.5


