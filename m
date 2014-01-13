Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-gw1-out.broadcom.com ([216.31.210.62]:46553 "EHLO
	mail-gw1-out.broadcom.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751251AbaAMVUi (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 13 Jan 2014 16:20:38 -0500
From: Arend van Spriel <arend@broadcom.com>
To: "John W. Linville" <linville@tuxdriver.com>
CC: linux-wireless <linux-wireless@vger.kernel.org>,
	Arend van Spriel <arend@broadcom.com>
Subject: [PATCH 8/8] brcmfmac: handle SDIO card removal
Date: Mon, 13 Jan 2014 22:20:29 +0100
Message-ID: <1389648029-23560-9-git-send-email-arend@broadcom.com> (sfid-20140113_222044_995765_AD82EF4D)
In-Reply-To: <1389648029-23560-1-git-send-email-arend@broadcom.com>
References: <1389648029-23560-1-git-send-email-arend@broadcom.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

When removing the card the driver still tries to access registers
in the device. This patch adds another state for the bus that
indicates the device is no longer reachable. This avoids errors
accessing it while cleaning up the driver.

Reviewed-by: Franky Lin <frankyl@broadcom.com>
Reviewed-by: Hante Meuleman <meuleman@broadcom.com>
Reviewed-by: Pieter-Paul Giesberts <pieterpg@broadcom.com>
Signed-off-by: Arend van Spriel <arend@broadcom.com>
---
 drivers/net/wireless/brcm80211/brcmfmac/bcmsdh.c   |   40 ++++---
 drivers/net/wireless/brcm80211/brcmfmac/dhd_bus.h  |   21 ++++
 .../net/wireless/brcm80211/brcmfmac/dhd_linux.c    |    4 +-
 drivers/net/wireless/brcm80211/brcmfmac/dhd_sdio.c |  120 ++++++++------------
 drivers/net/wireless/brcm80211/brcmfmac/usb.c      |    4 +-
 5 files changed, 102 insertions(+), 87 deletions(-)

diff --git a/drivers/net/wireless/brcm80211/brcmfmac/bcmsdh.c b/drivers/net/wireless/brcm80211/brcmfmac/bcmsdh.c
index 34c993d..fa35b23 100644
--- a/drivers/net/wireless/brcm80211/brcmfmac/bcmsdh.c
+++ b/drivers/net/wireless/brcm80211/brcmfmac/bcmsdh.c
@@ -287,6 +287,9 @@ static int brcmf_sdiod_regrw_helper(struct brcmf_sdio_dev *sdiodev, u32 addr,
 	s32 retry = 0;
 	int ret;
 
+	if (sdiodev->bus_if->state == BRCMF_BUS_NOMEDIUM)
+		return -ENOMEDIUM;
+
 	/*
 	 * figure out how to read the register based on address range
 	 * 0x00 ~ 0x7FF: function 0 CCCR and FBR
@@ -306,9 +309,12 @@ static int brcmf_sdiod_regrw_helper(struct brcmf_sdio_dev *sdiodev, u32 addr,
 			usleep_range(1000, 2000);
 		ret = brcmf_sdiod_request_data(sdiodev, func_num, addr, regsz,
 					       data, write);
-	} while (ret != 0 && retry++ < SDIOH_API_ACCESS_RETRY_LIMIT);
+	} while (ret != 0 && ret != -ENOMEDIUM &&
+		 retry++ < SDIOH_API_ACCESS_RETRY_LIMIT);
 
-	if (ret != 0)
+	if (ret == -ENOMEDIUM)
+		brcmf_bus_change_state(sdiodev->bus_if, BRCMF_BUS_NOMEDIUM);
+	else if (ret != 0)
 		brcmf_err("failed with %d\n", ret);
 
 	return ret;
@@ -320,6 +326,9 @@ brcmf_sdiod_set_sbaddr_window(struct brcmf_sdio_dev *sdiodev, u32 address)
 	int err = 0, i;
 	u8 addr[3];
 
+	if (sdiodev->bus_if->state == BRCMF_BUS_NOMEDIUM)
+		return -ENOMEDIUM;
+
 	addr[0] = (address >> 8) & SBSDIO_SBADDRLOW_MASK;
 	addr[1] = (address >> 16) & SBSDIO_SBADDRMID_MASK;
 	addr[2] = (address >> 24) & SBSDIO_SBADDRHIGH_MASK;
@@ -429,6 +438,7 @@ static int brcmf_sdiod_buffrw(struct brcmf_sdio_dev *sdiodev, uint fn,
 			     bool write, u32 addr, struct sk_buff *pkt)
 {
 	unsigned int req_sz;
+	int err;
 
 	brcmf_sdiod_pm_resume_wait(sdiodev, &sdiodev->request_buffer_wait);
 	if (brcmf_sdiod_pm_resume_error(sdiodev))
@@ -439,18 +449,18 @@ static int brcmf_sdiod_buffrw(struct brcmf_sdio_dev *sdiodev, uint fn,
 	req_sz &= (uint)~3;
 
 	if (write)
-		return sdio_memcpy_toio(sdiodev->func[fn], addr,
-					((u8 *)(pkt->data)),
-					req_sz);
+		err = sdio_memcpy_toio(sdiodev->func[fn], addr,
+				       ((u8 *)(pkt->data)), req_sz);
 	else if (fn == 1)
-		return sdio_memcpy_fromio(sdiodev->func[fn],
-					  ((u8 *)(pkt->data)),
-					  addr, req_sz);
+		err = sdio_memcpy_fromio(sdiodev->func[fn], ((u8 *)(pkt->data)),
+					 addr, req_sz);
 	else
 		/* function 2 read is FIFO operation */
-		return sdio_readsb(sdiodev->func[fn],
-				   ((u8 *)(pkt->data)), addr,
-				   req_sz);
+		err = sdio_readsb(sdiodev->func[fn], ((u8 *)(pkt->data)), addr,
+				  req_sz);
+	if (err == -ENOMEDIUM)
+		brcmf_bus_change_state(sdiodev->bus_if, BRCMF_BUS_NOMEDIUM);
+	return err;
 }
 
 /**
@@ -593,7 +603,11 @@ static int brcmf_sdiod_sglist_rw(struct brcmf_sdio_dev *sdiodev, uint fn,
 		mmc_wait_for_req(sdiodev->func[fn]->card->host, &mmc_req);
 
 		ret = mmc_cmd.error ? mmc_cmd.error : mmc_dat.error;
-		if (ret != 0) {
+		if (ret == -ENOMEDIUM) {
+			brcmf_bus_change_state(sdiodev->bus_if,
+					       BRCMF_BUS_NOMEDIUM);
+			break;
+		} else if (ret != 0) {
 			brcmf_err("CMD53 sg block %s failed %d\n",
 				  write ? "write" : "read", ret);
 			ret = -EIO;
@@ -852,8 +866,6 @@ int brcmf_sdiod_abort(struct brcmf_sdio_dev *sdiodev, uint fn)
 
 static int brcmf_sdiod_remove(struct brcmf_sdio_dev *sdiodev)
 {
-	sdiodev->bus_if->state = BRCMF_BUS_DOWN;
-
 	if (sdiodev->bus) {
 		brcmf_sdio_remove(sdiodev->bus);
 		sdiodev->bus = NULL;
diff --git a/drivers/net/wireless/brcm80211/brcmfmac/dhd_bus.h b/drivers/net/wireless/brcm80211/brcmfmac/dhd_bus.h
index 5c12a076..c453561 100644
--- a/drivers/net/wireless/brcm80211/brcmfmac/dhd_bus.h
+++ b/drivers/net/wireless/brcm80211/brcmfmac/dhd_bus.h
@@ -17,8 +17,12 @@
 #ifndef _BRCMF_BUS_H_
 #define _BRCMF_BUS_H_
 
+#include "dhd_dbg.h"
+
 /* The level of bus communication with the dongle */
 enum brcmf_bus_state {
+	BRCMF_BUS_UNKNOWN,	/* Not determined yet */
+	BRCMF_BUS_NOMEDIUM,	/* No medium access to dongle */
 	BRCMF_BUS_DOWN,		/* Not ready for frame transfers */
 	BRCMF_BUS_LOAD,		/* Download access only (CPU reset) */
 	BRCMF_BUS_DATA		/* Ready for frame transfers */
@@ -144,6 +148,23 @@ struct pktq *brcmf_bus_gettxq(struct brcmf_bus *bus)
 
 	return bus->ops->gettxq(bus->dev);
 }
+
+static inline bool brcmf_bus_ready(struct brcmf_bus *bus)
+{
+	return bus->state == BRCMF_BUS_LOAD || bus->state == BRCMF_BUS_DATA;
+}
+
+static inline void brcmf_bus_change_state(struct brcmf_bus *bus,
+					  enum brcmf_bus_state new_state)
+{
+	/* NOMEDIUM is permanent */
+	if (bus->state == BRCMF_BUS_NOMEDIUM)
+		return;
+
+	brcmf_dbg(TRACE, "%d -> %d\n", bus->state, new_state);
+	bus->state = new_state;
+}
+
 /*
  * interface functions from common layer
  */
diff --git a/drivers/net/wireless/brcm80211/brcmfmac/dhd_linux.c b/drivers/net/wireless/brcm80211/brcmfmac/dhd_linux.c
index af39eda..d4d966b 100644
--- a/drivers/net/wireless/brcm80211/brcmfmac/dhd_linux.c
+++ b/drivers/net/wireless/brcm80211/brcmfmac/dhd_linux.c
@@ -934,7 +934,7 @@ int brcmf_bus_start(struct device *dev)
 		p2p_ifp = NULL;
 
 	/* signal bus ready */
-	bus_if->state = BRCMF_BUS_DATA;
+	brcmf_bus_change_state(bus_if, BRCMF_BUS_DATA);
 
 	/* Bus is ready, do any initialization */
 	ret = brcmf_c_preinit_dcmds(ifp);
@@ -1029,6 +1029,8 @@ void brcmf_detach(struct device *dev)
 	/* stop firmware event handling */
 	brcmf_fweh_detach(drvr);
 
+	brcmf_bus_change_state(bus_if, BRCMF_BUS_DOWN);
+
 	/* make sure primary interface removed last */
 	for (i = BRCMF_MAX_IFS-1; i > -1; i--)
 		if (drvr->iflist[i]) {
diff --git a/drivers/net/wireless/brcm80211/brcmfmac/dhd_sdio.c b/drivers/net/wireless/brcm80211/brcmfmac/dhd_sdio.c
index ef24a1b..3e99189 100644
--- a/drivers/net/wireless/brcm80211/brcmfmac/dhd_sdio.c
+++ b/drivers/net/wireless/brcm80211/brcmfmac/dhd_sdio.c
@@ -1082,10 +1082,6 @@ static void brcmf_sdio_rxfail(struct brcmf_sdio *bus, bool abort, bool rtx)
 
 	/* Clear partial in any case */
 	bus->cur_read.len = 0;
-
-	/* If we can't reach the device, signal failure */
-	if (err)
-		bus->sdiodev->bus_if->state = BRCMF_BUS_DOWN;
 }
 
 /* return total length of buffer chain */
@@ -1682,8 +1678,7 @@ static uint brcmf_sdio_readframes(struct brcmf_sdio *bus, uint maxframes)
 	bus->rxpending = true;
 
 	for (rd->seq_num = bus->rx_seq, rxleft = maxframes;
-	     !bus->rxskip && rxleft &&
-	     bus->sdiodev->bus_if->state != BRCMF_BUS_DOWN;
+	     !bus->rxskip && rxleft && brcmf_bus_ready(bus->sdiodev->bus_if);
 	     rd->seq_num++, rxleft--) {
 
 		/* Handle glomming separately */
@@ -2232,39 +2227,37 @@ static void brcmf_sdio_bus_stop(struct device *dev)
 		bus->watchdog_tsk = NULL;
 	}
 
-	sdio_claim_host(bus->sdiodev->func[1]);
-
-	/* Enable clock for device interrupts */
-	brcmf_sdio_bus_sleep(bus, false, false);
+	if (bus_if->state == BRCMF_BUS_DOWN) {
+		sdio_claim_host(sdiodev->func[1]);
+
+		/* Enable clock for device interrupts */
+		brcmf_sdio_bus_sleep(bus, false, false);
+
+		/* Disable and clear interrupts at the chip level also */
+		w_sdreg32(bus, 0, offsetof(struct sdpcmd_regs, hostintmask));
+		local_hostintmask = bus->hostintmask;
+		bus->hostintmask = 0;
+
+		/* Force backplane clocks to assure F2 interrupt propagates */
+		saveclk = brcmf_sdiod_regrb(sdiodev, SBSDIO_FUNC1_CHIPCLKCSR,
+					    &err);
+		if (!err)
+			brcmf_sdiod_regwb(sdiodev, SBSDIO_FUNC1_CHIPCLKCSR,
+					  (saveclk | SBSDIO_FORCE_HT), &err);
+		if (err)
+			brcmf_err("Failed to force clock for F2: err %d\n",
+				  err);
 
-	/* Disable and clear interrupts at the chip level also */
-	w_sdreg32(bus, 0, offsetof(struct sdpcmd_regs, hostintmask));
-	local_hostintmask = bus->hostintmask;
-	bus->hostintmask = 0;
+		/* Turn off the bus (F2), free any pending packets */
+		brcmf_dbg(INTR, "disable SDIO interrupts\n");
+		sdio_disable_func(sdiodev->func[SDIO_FUNC_2]);
 
-	/* Change our idea of bus state */
-	bus->sdiodev->bus_if->state = BRCMF_BUS_DOWN;
+		/* Clear any pending interrupts now that F2 is disabled */
+		w_sdreg32(bus, local_hostintmask,
+			  offsetof(struct sdpcmd_regs, intstatus));
 
-	/* Force clocks on backplane to be sure F2 interrupt propagates */
-	saveclk = brcmf_sdiod_regrb(bus->sdiodev,
-				    SBSDIO_FUNC1_CHIPCLKCSR, &err);
-	if (!err) {
-		brcmf_sdiod_regwb(bus->sdiodev, SBSDIO_FUNC1_CHIPCLKCSR,
-				  (saveclk | SBSDIO_FORCE_HT), &err);
+		sdio_release_host(sdiodev->func[1]);
 	}
-	if (err)
-		brcmf_err("Failed to force clock for F2: err %d\n", err);
-
-	/* Turn off the bus (F2), free any pending packets */
-	brcmf_dbg(INTR, "disable SDIO interrupts\n");
-	sdio_disable_func(bus->sdiodev->func[SDIO_FUNC_2]);
-
-	/* Clear any pending interrupts now that F2 is disabled */
-	w_sdreg32(bus, local_hostintmask,
-		  offsetof(struct sdpcmd_regs, intstatus));
-
-	sdio_release_host(bus->sdiodev->func[1]);
-
 	/* Clear the data packet queues */
 	brcmu_pktq_flush(&bus->txq, true, NULL, NULL);
 
@@ -2354,20 +2347,11 @@ static void brcmf_sdio_dpc(struct brcmf_sdio *bus)
 		/* Check for inconsistent device control */
 		devctl = brcmf_sdiod_regrb(bus->sdiodev,
 					   SBSDIO_DEVICE_CTL, &err);
-		if (err) {
-			brcmf_err("error reading DEVCTL: %d\n", err);
-			bus->sdiodev->bus_if->state = BRCMF_BUS_DOWN;
-		}
 #endif				/* DEBUG */
 
 		/* Read CSR, if clock on switch to AVAIL, else ignore */
 		clkctl = brcmf_sdiod_regrb(bus->sdiodev,
 					   SBSDIO_FUNC1_CHIPCLKCSR, &err);
-		if (err) {
-			brcmf_err("error reading CSR: %d\n",
-				  err);
-			bus->sdiodev->bus_if->state = BRCMF_BUS_DOWN;
-		}
 
 		brcmf_dbg(SDIO, "DPC: PENDING, devctl 0x%02x clkctl 0x%02x\n",
 			  devctl, clkctl);
@@ -2375,19 +2359,9 @@ static void brcmf_sdio_dpc(struct brcmf_sdio *bus)
 		if (SBSDIO_HTAV(clkctl)) {
 			devctl = brcmf_sdiod_regrb(bus->sdiodev,
 						   SBSDIO_DEVICE_CTL, &err);
-			if (err) {
-				brcmf_err("error reading DEVCTL: %d\n",
-					  err);
-				bus->sdiodev->bus_if->state = BRCMF_BUS_DOWN;
-			}
 			devctl &= ~SBSDIO_DEVCTL_CA_INT_ONLY;
 			brcmf_sdiod_regwb(bus->sdiodev, SBSDIO_DEVICE_CTL,
 					  devctl, &err);
-			if (err) {
-				brcmf_err("error writing DEVCTL: %d\n",
-					  err);
-				bus->sdiodev->bus_if->state = BRCMF_BUS_DOWN;
-			}
 			bus->clkstate = CLK_AVAIL;
 		}
 	}
@@ -2522,9 +2496,8 @@ static void brcmf_sdio_dpc(struct brcmf_sdio *bus)
 		txlimit -= framecnt;
 	}
 
-	if ((bus->sdiodev->bus_if->state == BRCMF_BUS_DOWN) || (err != 0)) {
+	if (!brcmf_bus_ready(bus->sdiodev->bus_if) || (err != 0)) {
 		brcmf_err("failed backplane access over SDIO, halting operation\n");
-		bus->sdiodev->bus_if->state = BRCMF_BUS_DOWN;
 		atomic_set(&bus->intstatus, 0);
 	} else if (atomic_read(&bus->intstatus) ||
 		   atomic_read(&bus->ipend) > 0 ||
@@ -3356,7 +3329,7 @@ static int brcmf_sdio_download_firmware(struct brcmf_sdio *bus)
 	}
 
 	/* Allow HT Clock now that the ARM is running. */
-	bus->sdiodev->bus_if->state = BRCMF_BUS_LOAD;
+	brcmf_bus_change_state(bus->sdiodev->bus_if, BRCMF_BUS_LOAD);
 	bcmerror = 0;
 
 err:
@@ -3633,7 +3606,7 @@ void brcmf_sdio_isr(struct brcmf_sdio *bus)
 		return;
 	}
 
-	if (bus->sdiodev->bus_if->state == BRCMF_BUS_DOWN) {
+	if (!brcmf_bus_ready(bus->sdiodev->bus_if)) {
 		brcmf_err("bus is down. we have nothing to do\n");
 		return;
 	}
@@ -3644,7 +3617,6 @@ void brcmf_sdio_isr(struct brcmf_sdio *bus)
 	else
 		if (brcmf_sdio_intr_rstatus(bus)) {
 			brcmf_err("failed backplane access\n");
-			bus->sdiodev->bus_if->state = BRCMF_BUS_DOWN;
 		}
 
 	/* Disable additional interrupts (is this needed now)? */
@@ -3781,6 +3753,11 @@ brcmf_sdio_probe_attach(struct brcmf_sdio *bus)
 		goto fail;
 	}
 
+	/* SDIO register access works so moving
+	 * state from UNKNOWN to DOWN.
+	 */
+	brcmf_bus_change_state(bus->sdiodev->bus_if, BRCMF_BUS_DOWN);
+
 	if (brcmf_sdio_chip_attach(bus->sdiodev, &bus->ci)) {
 		brcmf_err("brcmf_sdio_chip_attach failed!\n");
 		goto fail;
@@ -4004,7 +3981,6 @@ struct brcmf_sdio *brcmf_sdio_probe(struct brcmf_sdio_dev *sdiodev)
 	/* Disable F2 to clear any intermediate frame state on the dongle */
 	sdio_disable_func(bus->sdiodev->func[SDIO_FUNC_2]);
 
-	bus->sdiodev->bus_if->state = BRCMF_BUS_DOWN;
 	bus->rxflow = false;
 
 	/* Done with backplane-dependent accesses, can drop clock... */
@@ -4060,16 +4036,20 @@ void brcmf_sdio_remove(struct brcmf_sdio *bus)
 		}
 
 		if (bus->ci) {
-			sdio_claim_host(bus->sdiodev->func[1]);
-			brcmf_sdio_clkctl(bus, CLK_AVAIL, false);
-			/* Leave the device in state where it is 'quiet'. This
-			 * is done by putting it in download_state which
-			 * essentially resets all necessary cores
-			 */
-			msleep(20);
-			brcmf_sdio_chip_enter_download(bus->sdiodev, bus->ci);
-			brcmf_sdio_clkctl(bus, CLK_NONE, false);
-			sdio_release_host(bus->sdiodev->func[1]);
+			if (bus->sdiodev->bus_if->state == BRCMF_BUS_DOWN) {
+				sdio_claim_host(bus->sdiodev->func[1]);
+				brcmf_sdio_clkctl(bus, CLK_AVAIL, false);
+				/* Leave the device in state where it is
+				 * 'quiet'. This is done by putting it in
+				 * download_state which essentially resets
+				 * all necessary cores.
+				 */
+				msleep(20);
+				brcmf_sdio_chip_enter_download(bus->sdiodev,
+							       bus->ci);
+				brcmf_sdio_clkctl(bus, CLK_NONE, false);
+				sdio_release_host(bus->sdiodev->func[1]);
+			}
 			brcmf_sdio_chip_detach(&bus->ci);
 		}
 
diff --git a/drivers/net/wireless/brcm80211/brcmfmac/usb.c b/drivers/net/wireless/brcm80211/brcmfmac/usb.c
index c345c32..24f65cd 100644
--- a/drivers/net/wireless/brcm80211/brcmfmac/usb.c
+++ b/drivers/net/wireless/brcm80211/brcmfmac/usb.c
@@ -522,10 +522,10 @@ brcmf_usb_state_change(struct brcmf_usbdev_info *devinfo, int state)
 	/* update state of upper layer */
 	if (state == BRCMFMAC_USB_STATE_DOWN) {
 		brcmf_dbg(USB, "DBUS is down\n");
-		bcmf_bus->state = BRCMF_BUS_DOWN;
+		brcmf_bus_change_state(bcmf_bus, BRCMF_BUS_DOWN);
 	} else if (state == BRCMFMAC_USB_STATE_UP) {
 		brcmf_dbg(USB, "DBUS is up\n");
-		bcmf_bus->state = BRCMF_BUS_DATA;
+		brcmf_bus_change_state(bcmf_bus, BRCMF_BUS_DATA);
 	} else {
 		brcmf_dbg(USB, "DBUS current state=%d\n", state);
 	}
-- 
1.7.10.4

