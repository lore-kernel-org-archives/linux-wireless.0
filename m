Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-gw1-out.broadcom.com ([216.31.210.62]:22792 "EHLO
	mail-gw1-out.broadcom.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759946AbbAYTbt (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 25 Jan 2015 14:31:49 -0500
From: Arend van Spriel <arend@broadcom.com>
To: Kalle Valo <kvalo@codeaurora.org>
CC: linux-wireless <linux-wireless@vger.kernel.org>,
	Hante Meuleman <meuleman@broadcom.com>,
	Arend van Spriel <arend@broadcom.com>
Subject: [PATCH 06/14] brcmfmac: SDIO: avoid using bus state for private states.
Date: Sun, 25 Jan 2015 20:31:35 +0100
Message-ID: <1422214303-7816-7-git-send-email-arend@broadcom.com> (sfid-20150125_203229_372829_52AA8A31)
In-Reply-To: <1422214303-7816-1-git-send-email-arend@broadcom.com>
References: <1422214303-7816-1-git-send-email-arend@broadcom.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Hante Meuleman <meuleman@broadcom.com>

Each bus driver is maintaing an exported bus state indicating
if upper layers can or cannot send data. SDIO is using this state
also for more private states. This makes handling the states and
state changes complex. This patch minimises the exposed states
and makes SDIO keep track of an internal state where necessary.

Reviewed-by: Arend Van Spriel <arend@broadcom.com>
Reviewed-by: Franky (Zhenhui) Lin <frankyl@broadcom.com>
Reviewed-by: Pieter-Paul Giesberts <pieterpg@broadcom.com>
Reviewed-by: Daniel (Deognyoun) Kim <dekim@broadcom.com>
Signed-off-by: Hante Meuleman <meuleman@broadcom.com>
Signed-off-by: Arend van Spriel <arend@broadcom.com>
---
 drivers/net/wireless/brcm80211/brcmfmac/bcmsdh.c | 17 +++++----
 drivers/net/wireless/brcm80211/brcmfmac/bus.h    | 14 +-------
 drivers/net/wireless/brcm80211/brcmfmac/core.c   |  6 ++--
 drivers/net/wireless/brcm80211/brcmfmac/fwil.c   |  2 +-
 drivers/net/wireless/brcm80211/brcmfmac/pcie.c   |  2 +-
 drivers/net/wireless/brcm80211/brcmfmac/sdio.c   | 45 +++++++++---------------
 drivers/net/wireless/brcm80211/brcmfmac/sdio.h   |  8 +++++
 drivers/net/wireless/brcm80211/brcmfmac/usb.c    |  2 +-
 8 files changed, 43 insertions(+), 53 deletions(-)

diff --git a/drivers/net/wireless/brcm80211/brcmfmac/bcmsdh.c b/drivers/net/wireless/brcm80211/brcmfmac/bcmsdh.c
index 9afaeb6..7944224 100644
--- a/drivers/net/wireless/brcm80211/brcmfmac/bcmsdh.c
+++ b/drivers/net/wireless/brcm80211/brcmfmac/bcmsdh.c
@@ -269,6 +269,12 @@ static int brcmf_sdiod_request_data(struct brcmf_sdio_dev *sdiodev, u8 fn,
 	return ret;
 }
 
+static void brcmf_sdiod_nomedium_state(struct brcmf_sdio_dev *sdiodev)
+{
+	sdiodev->state = BRCMF_STATE_NOMEDIUM;
+	brcmf_bus_change_state(sdiodev->bus_if, BRCMF_BUS_DOWN);
+}
+
 static int brcmf_sdiod_regrw_helper(struct brcmf_sdio_dev *sdiodev, u32 addr,
 				   u8 regsz, void *data, bool write)
 {
@@ -276,7 +282,7 @@ static int brcmf_sdiod_regrw_helper(struct brcmf_sdio_dev *sdiodev, u32 addr,
 	s32 retry = 0;
 	int ret;
 
-	if (sdiodev->bus_if->state == BRCMF_BUS_NOMEDIUM)
+	if (sdiodev->state == BRCMF_STATE_NOMEDIUM)
 		return -ENOMEDIUM;
 
 	/*
@@ -302,7 +308,7 @@ static int brcmf_sdiod_regrw_helper(struct brcmf_sdio_dev *sdiodev, u32 addr,
 		 retry++ < SDIOH_API_ACCESS_RETRY_LIMIT);
 
 	if (ret == -ENOMEDIUM)
-		brcmf_bus_change_state(sdiodev->bus_if, BRCMF_BUS_NOMEDIUM);
+		brcmf_sdiod_nomedium_state(sdiodev);
 	else if (ret != 0) {
 		/*
 		 * SleepCSR register access can fail when
@@ -325,7 +331,7 @@ brcmf_sdiod_set_sbaddr_window(struct brcmf_sdio_dev *sdiodev, u32 address)
 	int err = 0, i;
 	u8 addr[3];
 
-	if (sdiodev->bus_if->state == BRCMF_BUS_NOMEDIUM)
+	if (sdiodev->state == BRCMF_STATE_NOMEDIUM)
 		return -ENOMEDIUM;
 
 	addr[0] = (address >> 8) & SBSDIO_SBADDRLOW_MASK;
@@ -454,7 +460,7 @@ static int brcmf_sdiod_buffrw(struct brcmf_sdio_dev *sdiodev, uint fn,
 		err = sdio_readsb(sdiodev->func[fn], ((u8 *)(pkt->data)), addr,
 				  req_sz);
 	if (err == -ENOMEDIUM)
-		brcmf_bus_change_state(sdiodev->bus_if, BRCMF_BUS_NOMEDIUM);
+		brcmf_sdiod_nomedium_state(sdiodev);
 	return err;
 }
 
@@ -589,8 +595,7 @@ static int brcmf_sdiod_sglist_rw(struct brcmf_sdio_dev *sdiodev, uint fn,
 
 		ret = mmc_cmd.error ? mmc_cmd.error : mmc_dat.error;
 		if (ret == -ENOMEDIUM) {
-			brcmf_bus_change_state(sdiodev->bus_if,
-					       BRCMF_BUS_NOMEDIUM);
+			brcmf_sdiod_nomedium_state(sdiodev);
 			break;
 		} else if (ret != 0) {
 			brcmf_err("CMD53 sg block %s failed %d\n",
diff --git a/drivers/net/wireless/brcm80211/brcmfmac/bus.h b/drivers/net/wireless/brcm80211/brcmfmac/bus.h
index ef344e4..55d36ff 100644
--- a/drivers/net/wireless/brcm80211/brcmfmac/bus.h
+++ b/drivers/net/wireless/brcm80211/brcmfmac/bus.h
@@ -33,11 +33,8 @@
 
 /* The level of bus communication with the dongle */
 enum brcmf_bus_state {
-	BRCMF_BUS_UNKNOWN,	/* Not determined yet */
-	BRCMF_BUS_NOMEDIUM,	/* No medium access to dongle */
 	BRCMF_BUS_DOWN,		/* Not ready for frame transfers */
-	BRCMF_BUS_LOAD,		/* Download access only (CPU reset) */
-	BRCMF_BUS_DATA		/* Ready for frame transfers */
+	BRCMF_BUS_UP		/* Ready for frame transfers */
 };
 
 /* The level of bus communication with the dongle */
@@ -188,18 +185,9 @@ void brcmf_bus_wowl_config(struct brcmf_bus *bus, bool enabled)
 		bus->ops->wowl_config(bus->dev, enabled);
 }
 
-static inline bool brcmf_bus_ready(struct brcmf_bus *bus)
-{
-	return bus->state == BRCMF_BUS_LOAD || bus->state == BRCMF_BUS_DATA;
-}
-
 static inline void brcmf_bus_change_state(struct brcmf_bus *bus,
 					  enum brcmf_bus_state new_state)
 {
-	/* NOMEDIUM is permanent */
-	if (bus->state == BRCMF_BUS_NOMEDIUM)
-		return;
-
 	brcmf_dbg(TRACE, "%d -> %d\n", bus->state, new_state);
 	bus->state = new_state;
 }
diff --git a/drivers/net/wireless/brcm80211/brcmfmac/core.c b/drivers/net/wireless/brcm80211/brcmfmac/core.c
index e2a9e33..ff8c97b 100644
--- a/drivers/net/wireless/brcm80211/brcmfmac/core.c
+++ b/drivers/net/wireless/brcm80211/brcmfmac/core.c
@@ -197,7 +197,7 @@ static netdev_tx_t brcmf_netdev_start_xmit(struct sk_buff *skb,
 	brcmf_dbg(DATA, "Enter, idx=%d\n", ifp->bssidx);
 
 	/* Can the device send data? */
-	if (drvr->bus_if->state != BRCMF_BUS_DATA) {
+	if (drvr->bus_if->state != BRCMF_BUS_UP) {
 		brcmf_err("xmit rejected state=%d\n", drvr->bus_if->state);
 		netif_stop_queue(ndev);
 		dev_kfree_skb(skb);
@@ -637,7 +637,7 @@ static int brcmf_netdev_open(struct net_device *ndev)
 	brcmf_dbg(TRACE, "Enter, idx=%d\n", ifp->bssidx);
 
 	/* If bus is not ready, can't continue */
-	if (bus_if->state != BRCMF_BUS_DATA) {
+	if (bus_if->state != BRCMF_BUS_UP) {
 		brcmf_err("failed bus is not ready\n");
 		return -EAGAIN;
 	}
@@ -964,7 +964,7 @@ int brcmf_bus_start(struct device *dev)
 		p2p_ifp = NULL;
 
 	/* signal bus ready */
-	brcmf_bus_change_state(bus_if, BRCMF_BUS_DATA);
+	brcmf_bus_change_state(bus_if, BRCMF_BUS_UP);
 
 	/* Bus is ready, do any initialization */
 	ret = brcmf_c_preinit_dcmds(ifp);
diff --git a/drivers/net/wireless/brcm80211/brcmfmac/fwil.c b/drivers/net/wireless/brcm80211/brcmfmac/fwil.c
index 03f2c40..dcfa0bb 100644
--- a/drivers/net/wireless/brcm80211/brcmfmac/fwil.c
+++ b/drivers/net/wireless/brcm80211/brcmfmac/fwil.c
@@ -109,7 +109,7 @@ brcmf_fil_cmd_data(struct brcmf_if *ifp, u32 cmd, void *data, u32 len, bool set)
 	struct brcmf_pub *drvr = ifp->drvr;
 	s32 err;
 
-	if (drvr->bus_if->state != BRCMF_BUS_DATA) {
+	if (drvr->bus_if->state != BRCMF_BUS_UP) {
 		brcmf_err("bus is down. we have nothing to do.\n");
 		return -EIO;
 	}
diff --git a/drivers/net/wireless/brcm80211/brcmfmac/pcie.c b/drivers/net/wireless/brcm80211/brcmfmac/pcie.c
index e91fa9a..61c053a 100644
--- a/drivers/net/wireless/brcm80211/brcmfmac/pcie.c
+++ b/drivers/net/wireless/brcm80211/brcmfmac/pcie.c
@@ -1828,7 +1828,7 @@ static int brcmf_pcie_resume(struct pci_dev *pdev)
 				goto cleanup;
 			brcmf_dbg(PCIE, "Hot resume, continue....\n");
 			brcmf_pcie_select_core(devinfo, BCMA_CORE_PCIE2);
-			brcmf_bus_change_state(bus, BRCMF_BUS_DATA);
+			brcmf_bus_change_state(bus, BRCMF_BUS_UP);
 			brcmf_pcie_intr_enable(devinfo);
 			return 0;
 		}
diff --git a/drivers/net/wireless/brcm80211/brcmfmac/sdio.c b/drivers/net/wireless/brcm80211/brcmfmac/sdio.c
index 488a0f6..5e9d208 100644
--- a/drivers/net/wireless/brcm80211/brcmfmac/sdio.c
+++ b/drivers/net/wireless/brcm80211/brcmfmac/sdio.c
@@ -1909,7 +1909,7 @@ static uint brcmf_sdio_readframes(struct brcmf_sdio *bus, uint maxframes)
 	bus->rxpending = true;
 
 	for (rd->seq_num = bus->rx_seq, rxleft = maxframes;
-	     !bus->rxskip && rxleft && brcmf_bus_ready(bus->sdiodev->bus_if);
+	     !bus->rxskip && rxleft && bus->sdiodev->state == BRCMF_STATE_DATA;
 	     rd->seq_num++, rxleft--) {
 
 		/* Handle glomming separately */
@@ -2415,7 +2415,7 @@ static uint brcmf_sdio_sendfromq(struct brcmf_sdio *bus, uint maxframes)
 	}
 
 	/* Deflow-control stack if needed */
-	if ((bus->sdiodev->bus_if->state == BRCMF_BUS_DATA) &&
+	if ((bus->sdiodev->state == BRCMF_STATE_DATA) &&
 	    bus->txoff && (pktq_len(&bus->txq) < TXLOW)) {
 		bus->txoff = false;
 		brcmf_txflowblock(bus->sdiodev->dev, false);
@@ -2503,7 +2503,7 @@ static void brcmf_sdio_bus_stop(struct device *dev)
 		bus->watchdog_tsk = NULL;
 	}
 
-	if (bus_if->state == BRCMF_BUS_DOWN) {
+	if (sdiodev->state != BRCMF_STATE_NOMEDIUM) {
 		sdio_claim_host(sdiodev->func[1]);
 
 		/* Enable clock for device interrupts */
@@ -2756,7 +2756,7 @@ static void brcmf_sdio_dpc(struct brcmf_sdio *bus)
 		brcmf_sdio_sendfromq(bus, framecnt);
 	}
 
-	if (!brcmf_bus_ready(bus->sdiodev->bus_if) || (err != 0)) {
+	if ((bus->sdiodev->state != BRCMF_STATE_DATA) || (err != 0)) {
 		brcmf_err("failed backplane access over SDIO, halting operation\n");
 		atomic_set(&bus->intstatus, 0);
 	} else if (atomic_read(&bus->intstatus) ||
@@ -3411,8 +3411,8 @@ static int brcmf_sdio_download_firmware(struct brcmf_sdio *bus,
 		goto err;
 	}
 
-	/* Allow HT Clock now that the ARM is running. */
-	brcmf_bus_change_state(bus->sdiodev->bus_if, BRCMF_BUS_LOAD);
+	/* Allow full data communication using DPC from now on. */
+	bus->sdiodev->state = BRCMF_STATE_DATA;
 	bcmerror = 0;
 
 err:
@@ -3558,7 +3558,7 @@ void brcmf_sdio_isr(struct brcmf_sdio *bus)
 		return;
 	}
 
-	if (!brcmf_bus_ready(bus->sdiodev->bus_if)) {
+	if (bus->sdiodev->state != BRCMF_STATE_DATA) {
 		brcmf_err("bus is down. we have nothing to do\n");
 		return;
 	}
@@ -3581,10 +3581,6 @@ void brcmf_sdio_isr(struct brcmf_sdio *bus)
 
 static bool brcmf_sdio_bus_watchdog(struct brcmf_sdio *bus)
 {
-#ifdef DEBUG
-	struct brcmf_bus *bus_if = dev_get_drvdata(bus->sdiodev->dev);
-#endif	/* DEBUG */
-
 	brcmf_dbg(TIMER, "Enter\n");
 
 	/* Poll period: check device if appropriate. */
@@ -3628,7 +3624,7 @@ static bool brcmf_sdio_bus_watchdog(struct brcmf_sdio *bus)
 	}
 #ifdef DEBUG
 	/* Poll for console output periodically */
-	if (bus_if && bus_if->state == BRCMF_BUS_DATA &&
+	if (bus->sdiodev->state == BRCMF_STATE_DATA &&
 	    bus->console_interval != 0) {
 		bus->console.count += BRCMF_WD_POLL_MS;
 		if (bus->console.count >= bus->console_interval) {
@@ -3869,11 +3865,6 @@ brcmf_sdio_probe_attach(struct brcmf_sdio *bus)
 		goto fail;
 	}
 
-	/* SDIO register access works so moving
-	 * state from UNKNOWN to DOWN.
-	 */
-	brcmf_bus_change_state(bus->sdiodev->bus_if, BRCMF_BUS_DOWN);
-
 	bus->ci = brcmf_chip_attach(bus->sdiodev, &brcmf_sdio_buscore_ops);
 	if (IS_ERR(bus->ci)) {
 		brcmf_err("brcmf_chip_attach failed!\n");
@@ -4007,18 +3998,16 @@ static void brcmf_sdio_firmware_callback(struct device *dev,
 
 	brcmf_dbg(TRACE, "Enter: dev=%s\n", dev_name(dev));
 
-	/* try to download image and nvram to the dongle */
-	if (bus_if->state == BRCMF_BUS_DOWN) {
-		bus->alp_only = true;
-		err = brcmf_sdio_download_firmware(bus, code, nvram, nvram_len);
-		if (err)
-			goto fail;
-		bus->alp_only = false;
-	}
-
 	if (!bus_if->drvr)
 		return;
 
+	/* try to download image and nvram to the dongle */
+	bus->alp_only = true;
+	err = brcmf_sdio_download_firmware(bus, code, nvram, nvram_len);
+	if (err)
+		goto fail;
+	bus->alp_only = false;
+
 	/* Start the watchdog timer */
 	bus->sdcnt.tickcnt = 0;
 	brcmf_sdio_wd_timer(bus, BRCMF_WD_POLL_MS);
@@ -4254,7 +4243,7 @@ void brcmf_sdio_remove(struct brcmf_sdio *bus)
 			destroy_workqueue(bus->brcmf_wq);
 
 		if (bus->ci) {
-			if (bus->sdiodev->bus_if->state == BRCMF_BUS_DOWN) {
+			if (bus->sdiodev->state != BRCMF_STATE_NOMEDIUM) {
 				sdio_claim_host(bus->sdiodev->func[1]);
 				brcmf_sdio_clkctl(bus, CLK_AVAIL, false);
 				/* Leave the device in state where it is
@@ -4289,7 +4278,7 @@ void brcmf_sdio_wd_timer(struct brcmf_sdio *bus, uint wdtick)
 	}
 
 	/* don't start the wd until fw is loaded */
-	if (bus->sdiodev->bus_if->state != BRCMF_BUS_DATA)
+	if (bus->sdiodev->state != BRCMF_STATE_DATA)
 		return;
 
 	if (wdtick) {
diff --git a/drivers/net/wireless/brcm80211/brcmfmac/sdio.h b/drivers/net/wireless/brcm80211/brcmfmac/sdio.h
index 9c5d42d..ec2586a 100644
--- a/drivers/net/wireless/brcm80211/brcmfmac/sdio.h
+++ b/drivers/net/wireless/brcm80211/brcmfmac/sdio.h
@@ -155,6 +155,13 @@
 /* watchdog polling interval in ms */
 #define BRCMF_WD_POLL_MS	10
 
+/* The state of the bus */
+enum brcmf_sdio_state {
+	BRCMF_STATE_DOWN,	/* Device available, still initialising */
+	BRCMF_STATE_DATA,	/* Ready for data transfers, DPC enabled */
+	BRCMF_STATE_NOMEDIUM	/* No medium access to dongle possible */
+};
+
 struct brcmf_sdreg {
 	int func;
 	int offset;
@@ -187,6 +194,7 @@ struct brcmf_sdio_dev {
 	char fw_name[BRCMF_FW_PATH_LEN + BRCMF_FW_NAME_LEN];
 	char nvram_name[BRCMF_FW_PATH_LEN + BRCMF_FW_NAME_LEN];
 	bool wowl_enabled;
+	enum brcmf_sdio_state state;
 };
 
 /* sdio core registers */
diff --git a/drivers/net/wireless/brcm80211/brcmfmac/usb.c b/drivers/net/wireless/brcm80211/brcmfmac/usb.c
index 4572def..7e0c9e2 100644
--- a/drivers/net/wireless/brcm80211/brcmfmac/usb.c
+++ b/drivers/net/wireless/brcm80211/brcmfmac/usb.c
@@ -576,7 +576,7 @@ brcmf_usb_state_change(struct brcmf_usbdev_info *devinfo, int state)
 		brcmf_bus_change_state(bcmf_bus, BRCMF_BUS_DOWN);
 	} else if (state == BRCMFMAC_USB_STATE_UP) {
 		brcmf_dbg(USB, "DBUS is up\n");
-		brcmf_bus_change_state(bcmf_bus, BRCMF_BUS_DATA);
+		brcmf_bus_change_state(bcmf_bus, BRCMF_BUS_UP);
 	} else {
 		brcmf_dbg(USB, "DBUS current state=%d\n", state);
 	}
-- 
1.9.1

