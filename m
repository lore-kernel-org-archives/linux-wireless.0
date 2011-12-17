Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mms2.broadcom.com ([216.31.210.18]:1137 "EHLO mms2.broadcom.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1761007Ab1LQChl (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 16 Dec 2011 21:37:41 -0500
From: "Franky Lin" <frankyl@broadcom.com>
To: linville@tuxdriver.com
cc: linux-wireless@vger.kernel.org
Subject: [PATCH 22/30] brcm80211: fmac: abstract bus_stop interface
 function pointer
Date: Fri, 16 Dec 2011 18:37:12 -0800
Message-ID: <1324089440-8957-23-git-send-email-frankyl@broadcom.com> (sfid-20111217_035945_440534_739A873B)
In-Reply-To: <1324089440-8957-1-git-send-email-frankyl@broadcom.com>
References: <1324089440-8957-1-git-send-email-frankyl@broadcom.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Common layer should use interface function pointer stored in
brcmf_bus to invoke corresponding interface function in bus layer.
This patch is part of the fullmac bus interface refactoring.

Reviewed-by: Pieter-Paul Giesberts <pieterpg@broadcom.com>
Reviewed-by: Arend van Spriel <arend@broadcom.com>
Reviewed-by: Alwin Beukers <alwin@broadcom.com>
Signed-off-by: Franky Lin <frankyl@broadcom.com>
---
 drivers/net/wireless/brcm80211/brcmfmac/dhd.h      |    4 +
 drivers/net/wireless/brcm80211/brcmfmac/dhd_bus.h  |    4 -
 .../net/wireless/brcm80211/brcmfmac/dhd_linux.c    |    2 +-
 drivers/net/wireless/brcm80211/brcmfmac/dhd_sdio.c |  164 ++++++++++----------
 4 files changed, 88 insertions(+), 86 deletions(-)

diff --git a/drivers/net/wireless/brcm80211/brcmfmac/dhd.h b/drivers/net/wireless/brcm80211/brcmfmac/dhd.h
index 30cc417..d3407f7 100644
--- a/drivers/net/wireless/brcm80211/brcmfmac/dhd.h
+++ b/drivers/net/wireless/brcm80211/brcmfmac/dhd.h
@@ -581,6 +581,10 @@ struct brcmf_bus {
 	unsigned long tx_realloc;	/* Tx packets realloced for headroom */
 	struct dngl_stats dstats;	/* Stats for dongle-based data */
 	u8 align;		/* bus alignment requirement */
+
+	/* interface functions pointers */
+	/* Stop bus module: clear pending frames, disable data flow */
+	void (*brcmf_bus_stop)(struct device *);
 };
 
 /* Forward decls for struct brcmf_pub (see below) */
diff --git a/drivers/net/wireless/brcm80211/brcmfmac/dhd_bus.h b/drivers/net/wireless/brcm80211/brcmfmac/dhd_bus.h
index 413ba21..25c1bc3 100644
--- a/drivers/net/wireless/brcm80211/brcmfmac/dhd_bus.h
+++ b/drivers/net/wireless/brcm80211/brcmfmac/dhd_bus.h
@@ -20,10 +20,6 @@
 /*
  * Exported from brcmf bus module (brcmf_usb, brcmf_sdio)
  */
-
-/* Stop bus module: clear pending frames, disable data flow */
-extern void brcmf_sdbrcm_bus_stop(struct device *dev);
-
 /* Initialize bus module: prepare for communication w/dongle */
 extern int brcmf_sdbrcm_bus_init(struct device *dev);
 
diff --git a/drivers/net/wireless/brcm80211/brcmfmac/dhd_linux.c b/drivers/net/wireless/brcm80211/brcmfmac/dhd_linux.c
index 70f0b31..6c398c4 100644
--- a/drivers/net/wireless/brcm80211/brcmfmac/dhd_linux.c
+++ b/drivers/net/wireless/brcm80211/brcmfmac/dhd_linux.c
@@ -1089,7 +1089,7 @@ static void brcmf_bus_detach(struct brcmf_pub *drvr)
 		brcmf_proto_stop(drvr);
 
 		/* Stop the bus module */
-		brcmf_sdbrcm_bus_stop(drvr->dev);
+		drvr->bus_if->brcmf_bus_stop(drvr->dev);
 	}
 }
 
diff --git a/drivers/net/wireless/brcm80211/brcmfmac/dhd_sdio.c b/drivers/net/wireless/brcm80211/brcmfmac/dhd_sdio.c
index 129cfd6..7817ede 100644
--- a/drivers/net/wireless/brcm80211/brcmfmac/dhd_sdio.c
+++ b/drivers/net/wireless/brcm80211/brcmfmac/dhd_sdio.c
@@ -2303,6 +2303,87 @@ static uint brcmf_sdbrcm_sendfromq(struct brcmf_sdio *bus, uint maxframes)
 	return cnt;
 }
 
+static void brcmf_sdbrcm_bus_stop(struct device *dev)
+{
+	u32 local_hostintmask;
+	u8 saveclk;
+	uint retries;
+	int err;
+	struct brcmf_bus *bus_if = dev_get_drvdata(dev);
+	struct brcmf_sdio_dev *sdiodev = bus_if->bus_priv;
+	struct brcmf_sdio *bus = sdiodev->bus;
+
+	brcmf_dbg(TRACE, "Enter\n");
+
+	if (bus->watchdog_tsk) {
+		send_sig(SIGTERM, bus->watchdog_tsk, 1);
+		kthread_stop(bus->watchdog_tsk);
+		bus->watchdog_tsk = NULL;
+	}
+
+	if (bus->dpc_tsk && bus->dpc_tsk != current) {
+		send_sig(SIGTERM, bus->dpc_tsk, 1);
+		kthread_stop(bus->dpc_tsk);
+		bus->dpc_tsk = NULL;
+	}
+
+	down(&bus->sdsem);
+
+	bus_wake(bus);
+
+	/* Enable clock for device interrupts */
+	brcmf_sdbrcm_clkctl(bus, CLK_AVAIL, false);
+
+	/* Disable and clear interrupts at the chip level also */
+	w_sdreg32(bus, 0, offsetof(struct sdpcmd_regs, hostintmask), &retries);
+	local_hostintmask = bus->hostintmask;
+	bus->hostintmask = 0;
+
+	/* Change our idea of bus state */
+	bus->sdiodev->bus_if->state = BRCMF_BUS_DOWN;
+
+	/* Force clocks on backplane to be sure F2 interrupt propagates */
+	saveclk = brcmf_sdcard_cfg_read(bus->sdiodev, SDIO_FUNC_1,
+					SBSDIO_FUNC1_CHIPCLKCSR, &err);
+	if (!err) {
+		brcmf_sdcard_cfg_write(bus->sdiodev, SDIO_FUNC_1,
+				       SBSDIO_FUNC1_CHIPCLKCSR,
+				       (saveclk | SBSDIO_FORCE_HT), &err);
+	}
+	if (err)
+		brcmf_dbg(ERROR, "Failed to force clock for F2: err %d\n", err);
+
+	/* Turn off the bus (F2), free any pending packets */
+	brcmf_dbg(INTR, "disable SDIO interrupts\n");
+	brcmf_sdcard_cfg_write(bus->sdiodev, SDIO_FUNC_0, SDIO_CCCR_IOEx,
+			 SDIO_FUNC_ENABLE_1, NULL);
+
+	/* Clear any pending interrupts now that F2 is disabled */
+	w_sdreg32(bus, local_hostintmask,
+		  offsetof(struct sdpcmd_regs, intstatus), &retries);
+
+	/* Turn off the backplane clock (only) */
+	brcmf_sdbrcm_clkctl(bus, CLK_SDONLY, false);
+
+	/* Clear the data packet queues */
+	brcmu_pktq_flush(&bus->txq, true, NULL, NULL);
+
+	/* Clear any held glomming stuff */
+	if (bus->glomd)
+		brcmu_pkt_buf_free_skb(bus->glomd);
+	brcmf_sdbrcm_free_glom(bus);
+
+	/* Clear rx control and wake any waiters */
+	bus->rxlen = 0;
+	brcmf_sdbrcm_dcmd_resp_wake(bus);
+
+	/* Reset some F2 state stuff */
+	bus->rxskip = false;
+	bus->tx_seq = bus->rx_seq = 0;
+
+	up(&bus->sdsem);
+}
+
 static bool brcmf_sdbrcm_dpc(struct brcmf_sdio *bus)
 {
 	u32 intstatus, newstatus = 0;
@@ -3342,87 +3423,6 @@ brcmf_sdbrcm_download_firmware(struct brcmf_sdio *bus)
 	return ret;
 }
 
-void brcmf_sdbrcm_bus_stop(struct device *dev)
-{
-	u32 local_hostintmask;
-	u8 saveclk;
-	uint retries;
-	int err;
-	struct brcmf_bus *bus_if = dev_get_drvdata(dev);
-	struct brcmf_sdio_dev *sdiodev = bus_if->bus_priv;
-	struct brcmf_sdio *bus = sdiodev->bus;
-
-	brcmf_dbg(TRACE, "Enter\n");
-
-	if (bus->watchdog_tsk) {
-		send_sig(SIGTERM, bus->watchdog_tsk, 1);
-		kthread_stop(bus->watchdog_tsk);
-		bus->watchdog_tsk = NULL;
-	}
-
-	if (bus->dpc_tsk && bus->dpc_tsk != current) {
-		send_sig(SIGTERM, bus->dpc_tsk, 1);
-		kthread_stop(bus->dpc_tsk);
-		bus->dpc_tsk = NULL;
-	}
-
-	down(&bus->sdsem);
-
-	bus_wake(bus);
-
-	/* Enable clock for device interrupts */
-	brcmf_sdbrcm_clkctl(bus, CLK_AVAIL, false);
-
-	/* Disable and clear interrupts at the chip level also */
-	w_sdreg32(bus, 0, offsetof(struct sdpcmd_regs, hostintmask), &retries);
-	local_hostintmask = bus->hostintmask;
-	bus->hostintmask = 0;
-
-	/* Change our idea of bus state */
-	bus->sdiodev->bus_if->state = BRCMF_BUS_DOWN;
-
-	/* Force clocks on backplane to be sure F2 interrupt propagates */
-	saveclk = brcmf_sdcard_cfg_read(bus->sdiodev, SDIO_FUNC_1,
-					SBSDIO_FUNC1_CHIPCLKCSR, &err);
-	if (!err) {
-		brcmf_sdcard_cfg_write(bus->sdiodev, SDIO_FUNC_1,
-				       SBSDIO_FUNC1_CHIPCLKCSR,
-				       (saveclk | SBSDIO_FORCE_HT), &err);
-	}
-	if (err)
-		brcmf_dbg(ERROR, "Failed to force clock for F2: err %d\n", err);
-
-	/* Turn off the bus (F2), free any pending packets */
-	brcmf_dbg(INTR, "disable SDIO interrupts\n");
-	brcmf_sdcard_cfg_write(bus->sdiodev, SDIO_FUNC_0, SDIO_CCCR_IOEx,
-			 SDIO_FUNC_ENABLE_1, NULL);
-
-	/* Clear any pending interrupts now that F2 is disabled */
-	w_sdreg32(bus, local_hostintmask,
-		  offsetof(struct sdpcmd_regs, intstatus), &retries);
-
-	/* Turn off the backplane clock (only) */
-	brcmf_sdbrcm_clkctl(bus, CLK_SDONLY, false);
-
-	/* Clear the data packet queues */
-	brcmu_pktq_flush(&bus->txq, true, NULL, NULL);
-
-	/* Clear any held glomming stuff */
-	if (bus->glomd)
-		brcmu_pkt_buf_free_skb(bus->glomd);
-	brcmf_sdbrcm_free_glom(bus);
-
-	/* Clear rx control and wake any waiters */
-	bus->rxlen = 0;
-	brcmf_sdbrcm_dcmd_resp_wake(bus);
-
-	/* Reset some F2 state stuff */
-	bus->rxskip = false;
-	bus->tx_seq = bus->rx_seq = 0;
-
-	up(&bus->sdsem);
-}
-
 int brcmf_sdbrcm_bus_init(struct device *dev)
 {
 	struct brcmf_bus *bus_if = dev_get_drvdata(dev);
@@ -3952,6 +3952,8 @@ void *brcmf_sdbrcm_probe(u32 regsva, struct brcmf_sdio_dev *sdiodev)
 		bus->dpc_tsk = NULL;
 	}
 
+	/* Assign bus interface call back */
+	bus->sdiodev->bus_if->brcmf_bus_stop = brcmf_sdbrcm_bus_stop;
 	/* Attach to the brcmf/OS/network interface */
 	ret = brcmf_attach(SDPCM_RESERVE, bus->sdiodev->dev);
 	if (ret != 0) {
-- 
1.7.5.4


