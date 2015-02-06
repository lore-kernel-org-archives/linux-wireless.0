Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-gw2-out.broadcom.com ([216.31.210.63]:40404 "EHLO
	mail-gw2-out.broadcom.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755296AbbBFRgy (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 6 Feb 2015 12:36:54 -0500
From: Arend van Spriel <arend@broadcom.com>
To: Kalle Valo <kvalo@codeaurora.org>
CC: linux-wireless <linux-wireless@vger.kernel.org>,
	Arend van Spriel <arend@broadcom.com>
Subject: [PATCH 1/6] brcmfmac: use helper function for changing SDIO state
Date: Fri, 6 Feb 2015 18:36:42 +0100
Message-ID: <1423244207-9707-2-git-send-email-arend@broadcom.com> (sfid-20150206_183703_234725_B48A7CF6)
In-Reply-To: <1423244207-9707-1-git-send-email-arend@broadcom.com>
References: <1423244207-9707-1-git-send-email-arend@broadcom.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Changing the SDIO state of the driver involves changing the bus
interface state. Adding a helper function makes sure that knowledge
is in one place.

Reviewed-by: Hante Meuleman <meuleman@broadcom.com>
Reviewed-by: Daniel (Deognyoun) Kim <dekim@broadcom.com>
Reviewed-by: Franky (Zhenhui) Lin <frankyl@broadcom.com>
Reviewed-by: Pieter-Paul Giesberts <pieterpg@broadcom.com>
Signed-off-by: Arend van Spriel <arend@broadcom.com>
---
 drivers/net/wireless/brcm80211/brcmfmac/bcmsdh.c | 41 +++++++++++++++++-------
 drivers/net/wireless/brcm80211/brcmfmac/sdio.c   | 18 +++++------
 drivers/net/wireless/brcm80211/brcmfmac/sdio.h   | 21 ++++++++----
 3 files changed, 54 insertions(+), 26 deletions(-)

diff --git a/drivers/net/wireless/brcm80211/brcmfmac/bcmsdh.c b/drivers/net/wireless/brcm80211/brcmfmac/bcmsdh.c
index 7944224..1f7e2f2 100644
--- a/drivers/net/wireless/brcm80211/brcmfmac/bcmsdh.c
+++ b/drivers/net/wireless/brcm80211/brcmfmac/bcmsdh.c
@@ -197,6 +197,30 @@ int brcmf_sdiod_intr_unregister(struct brcmf_sdio_dev *sdiodev)
 	return 0;
 }
 
+void brcmf_sdiod_change_state(struct brcmf_sdio_dev *sdiodev,
+			      enum brcmf_sdiod_state state)
+{
+	if (sdiodev->state == BRCMF_SDIOD_NOMEDIUM ||
+	    state == sdiodev->state)
+		return;
+
+	brcmf_dbg(TRACE, "%d -> %d\n", sdiodev->state, state);
+	switch (sdiodev->state) {
+	case BRCMF_SDIOD_DATA:
+		/* any other state means bus interface is down */
+		brcmf_bus_change_state(sdiodev->bus_if, BRCMF_BUS_DOWN);
+		break;
+	case BRCMF_SDIOD_DOWN:
+		/* transition from DOWN to DATA means bus interface is up */
+		if (state == BRCMF_SDIOD_DATA)
+			brcmf_bus_change_state(sdiodev->bus_if, BRCMF_BUS_UP);
+		break;
+	default:
+		break;
+	}
+	sdiodev->state = state;
+}
+
 static inline int brcmf_sdiod_f0_writeb(struct sdio_func *func,
 					uint regaddr, u8 byte)
 {
@@ -269,12 +293,6 @@ static int brcmf_sdiod_request_data(struct brcmf_sdio_dev *sdiodev, u8 fn,
 	return ret;
 }
 
-static void brcmf_sdiod_nomedium_state(struct brcmf_sdio_dev *sdiodev)
-{
-	sdiodev->state = BRCMF_STATE_NOMEDIUM;
-	brcmf_bus_change_state(sdiodev->bus_if, BRCMF_BUS_DOWN);
-}
-
 static int brcmf_sdiod_regrw_helper(struct brcmf_sdio_dev *sdiodev, u32 addr,
 				   u8 regsz, void *data, bool write)
 {
@@ -282,7 +300,7 @@ static int brcmf_sdiod_regrw_helper(struct brcmf_sdio_dev *sdiodev, u32 addr,
 	s32 retry = 0;
 	int ret;
 
-	if (sdiodev->state == BRCMF_STATE_NOMEDIUM)
+	if (sdiodev->state == BRCMF_SDIOD_NOMEDIUM)
 		return -ENOMEDIUM;
 
 	/*
@@ -308,7 +326,7 @@ static int brcmf_sdiod_regrw_helper(struct brcmf_sdio_dev *sdiodev, u32 addr,
 		 retry++ < SDIOH_API_ACCESS_RETRY_LIMIT);
 
 	if (ret == -ENOMEDIUM)
-		brcmf_sdiod_nomedium_state(sdiodev);
+		brcmf_sdiod_change_state(sdiodev, BRCMF_SDIOD_NOMEDIUM);
 	else if (ret != 0) {
 		/*
 		 * SleepCSR register access can fail when
@@ -331,7 +349,7 @@ brcmf_sdiod_set_sbaddr_window(struct brcmf_sdio_dev *sdiodev, u32 address)
 	int err = 0, i;
 	u8 addr[3];
 
-	if (sdiodev->state == BRCMF_STATE_NOMEDIUM)
+	if (sdiodev->state == BRCMF_SDIOD_NOMEDIUM)
 		return -ENOMEDIUM;
 
 	addr[0] = (address >> 8) & SBSDIO_SBADDRLOW_MASK;
@@ -460,7 +478,7 @@ static int brcmf_sdiod_buffrw(struct brcmf_sdio_dev *sdiodev, uint fn,
 		err = sdio_readsb(sdiodev->func[fn], ((u8 *)(pkt->data)), addr,
 				  req_sz);
 	if (err == -ENOMEDIUM)
-		brcmf_sdiod_nomedium_state(sdiodev);
+		brcmf_sdiod_change_state(sdiodev, BRCMF_SDIOD_NOMEDIUM);
 	return err;
 }
 
@@ -595,7 +613,7 @@ static int brcmf_sdiod_sglist_rw(struct brcmf_sdio_dev *sdiodev, uint fn,
 
 		ret = mmc_cmd.error ? mmc_cmd.error : mmc_dat.error;
 		if (ret == -ENOMEDIUM) {
-			brcmf_sdiod_nomedium_state(sdiodev);
+			brcmf_sdiod_change_state(sdiodev, BRCMF_SDIOD_NOMEDIUM);
 			break;
 		} else if (ret != 0) {
 			brcmf_err("CMD53 sg block %s failed %d\n",
@@ -1050,6 +1068,7 @@ static int brcmf_ops_sdio_probe(struct sdio_func *func,
 		bus_if->wowl_supported = true;
 #endif
 
+	brcmf_sdiod_change_state(sdiodev, BRCMF_SDIOD_DOWN);
 	sdiodev->sleeping = false;
 	atomic_set(&sdiodev->suspend, false);
 	init_waitqueue_head(&sdiodev->idle_wait);
diff --git a/drivers/net/wireless/brcm80211/brcmfmac/sdio.c b/drivers/net/wireless/brcm80211/brcmfmac/sdio.c
index faec35c..6ba79d2 100644
--- a/drivers/net/wireless/brcm80211/brcmfmac/sdio.c
+++ b/drivers/net/wireless/brcm80211/brcmfmac/sdio.c
@@ -1909,7 +1909,7 @@ static uint brcmf_sdio_readframes(struct brcmf_sdio *bus, uint maxframes)
 	bus->rxpending = true;
 
 	for (rd->seq_num = bus->rx_seq, rxleft = maxframes;
-	     !bus->rxskip && rxleft && bus->sdiodev->state == BRCMF_STATE_DATA;
+	     !bus->rxskip && rxleft && bus->sdiodev->state == BRCMF_SDIOD_DATA;
 	     rd->seq_num++, rxleft--) {
 
 		/* Handle glomming separately */
@@ -2415,7 +2415,7 @@ static uint brcmf_sdio_sendfromq(struct brcmf_sdio *bus, uint maxframes)
 	}
 
 	/* Deflow-control stack if needed */
-	if ((bus->sdiodev->state == BRCMF_STATE_DATA) &&
+	if ((bus->sdiodev->state == BRCMF_SDIOD_DATA) &&
 	    bus->txoff && (pktq_len(&bus->txq) < TXLOW)) {
 		bus->txoff = false;
 		brcmf_txflowblock(bus->sdiodev->dev, false);
@@ -2503,7 +2503,7 @@ static void brcmf_sdio_bus_stop(struct device *dev)
 		bus->watchdog_tsk = NULL;
 	}
 
-	if (sdiodev->state != BRCMF_STATE_NOMEDIUM) {
+	if (sdiodev->state != BRCMF_SDIOD_NOMEDIUM) {
 		sdio_claim_host(sdiodev->func[1]);
 
 		/* Enable clock for device interrupts */
@@ -2755,7 +2755,7 @@ static void brcmf_sdio_dpc(struct brcmf_sdio *bus)
 		brcmf_sdio_sendfromq(bus, framecnt);
 	}
 
-	if ((bus->sdiodev->state != BRCMF_STATE_DATA) || (err != 0)) {
+	if ((bus->sdiodev->state != BRCMF_SDIOD_DATA) || (err != 0)) {
 		brcmf_err("failed backplane access over SDIO, halting operation\n");
 		atomic_set(&bus->intstatus, 0);
 	} else if (atomic_read(&bus->intstatus) ||
@@ -3411,7 +3411,7 @@ static int brcmf_sdio_download_firmware(struct brcmf_sdio *bus,
 	}
 
 	/* Allow full data communication using DPC from now on. */
-	bus->sdiodev->state = BRCMF_STATE_DATA;
+	brcmf_sdiod_change_state(bus->sdiodev, BRCMF_SDIOD_DATA);
 	bcmerror = 0;
 
 err:
@@ -3557,7 +3557,7 @@ void brcmf_sdio_isr(struct brcmf_sdio *bus)
 		return;
 	}
 
-	if (bus->sdiodev->state != BRCMF_STATE_DATA) {
+	if (bus->sdiodev->state != BRCMF_SDIOD_DATA) {
 		brcmf_err("bus is down. we have nothing to do\n");
 		return;
 	}
@@ -3623,7 +3623,7 @@ static bool brcmf_sdio_bus_watchdog(struct brcmf_sdio *bus)
 	}
 #ifdef DEBUG
 	/* Poll for console output periodically */
-	if (bus->sdiodev->state == BRCMF_STATE_DATA &&
+	if (bus->sdiodev->state == BRCMF_SDIOD_DATA &&
 	    bus->console_interval != 0) {
 		bus->console.count += BRCMF_WD_POLL_MS;
 		if (bus->console.count >= bus->console_interval) {
@@ -4242,7 +4242,7 @@ void brcmf_sdio_remove(struct brcmf_sdio *bus)
 			destroy_workqueue(bus->brcmf_wq);
 
 		if (bus->ci) {
-			if (bus->sdiodev->state != BRCMF_STATE_NOMEDIUM) {
+			if (bus->sdiodev->state != BRCMF_SDIOD_NOMEDIUM) {
 				sdio_claim_host(bus->sdiodev->func[1]);
 				brcmf_sdio_clkctl(bus, CLK_AVAIL, false);
 				/* Leave the device in state where it is
@@ -4277,7 +4277,7 @@ void brcmf_sdio_wd_timer(struct brcmf_sdio *bus, uint wdtick)
 	}
 
 	/* don't start the wd until fw is loaded */
-	if (bus->sdiodev->state != BRCMF_STATE_DATA)
+	if (bus->sdiodev->state != BRCMF_SDIOD_DATA)
 		return;
 
 	if (wdtick) {
diff --git a/drivers/net/wireless/brcm80211/brcmfmac/sdio.h b/drivers/net/wireless/brcm80211/brcmfmac/sdio.h
index ec2586a..a6cdc60 100644
--- a/drivers/net/wireless/brcm80211/brcmfmac/sdio.h
+++ b/drivers/net/wireless/brcm80211/brcmfmac/sdio.h
@@ -155,11 +155,17 @@
 /* watchdog polling interval in ms */
 #define BRCMF_WD_POLL_MS	10
 
-/* The state of the bus */
-enum brcmf_sdio_state {
-	BRCMF_STATE_DOWN,	/* Device available, still initialising */
-	BRCMF_STATE_DATA,	/* Ready for data transfers, DPC enabled */
-	BRCMF_STATE_NOMEDIUM	/* No medium access to dongle possible */
+/**
+ * enum brcmf_sdiod_state - the state of the bus.
+ *
+ * @BRCMF_SDIOD_DOWN: Device can be accessed, no DPC.
+ * @BRCMF_SDIOD_DATA: Ready for data transfers, DPC enabled.
+ * @BRCMF_SDIOD_NOMEDIUM: No medium access to dongle possible.
+ */
+enum brcmf_sdiod_state {
+	BRCMF_SDIOD_DOWN,
+	BRCMF_SDIOD_DATA,
+	BRCMF_SDIOD_NOMEDIUM
 };
 
 struct brcmf_sdreg {
@@ -194,7 +200,7 @@ struct brcmf_sdio_dev {
 	char fw_name[BRCMF_FW_PATH_LEN + BRCMF_FW_NAME_LEN];
 	char nvram_name[BRCMF_FW_PATH_LEN + BRCMF_FW_NAME_LEN];
 	bool wowl_enabled;
-	enum brcmf_sdio_state state;
+	enum brcmf_sdiod_state state;
 };
 
 /* sdio core registers */
@@ -345,4 +351,7 @@ void brcmf_sdio_isr(struct brcmf_sdio *bus);
 void brcmf_sdio_wd_timer(struct brcmf_sdio *bus, uint wdtick);
 void brcmf_sdio_wowl_config(struct device *dev, bool enabled);
 
+void brcmf_sdiod_change_state(struct brcmf_sdio_dev *sdiodev,
+			      enum brcmf_sdiod_state state);
+
 #endif /* BRCMFMAC_SDIO_H */
-- 
1.9.1

