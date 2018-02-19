Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from rnd-relay.smtp.broadcom.com ([192.19.229.170]:47988 "EHLO
        rnd-relay.smtp.broadcom.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S932336AbeBSXOd (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 19 Feb 2018 18:14:33 -0500
From: Arend van Spriel <arend.vanspriel@broadcom.com>
To: Kalle Valo <kvalo@codeaurora.org>
Cc: linux-wireless@vger.kernel.org,
        Arend van Spriel <arend.vanspriel@broadcom.com>
Subject: [PATCH 3/8] brcmfmac: call brcmf_attach() just before calling brcmf_bus_started()
Date: Tue, 20 Feb 2018 00:14:20 +0100
Message-Id: <1519082065-10128-4-git-send-email-arend.vanspriel@broadcom.com> (sfid-20180220_001446_004824_45A67F33)
In-Reply-To: <1519082065-10128-1-git-send-email-arend.vanspriel@broadcom.com>
References: <1519082065-10128-1-git-send-email-arend.vanspriel@broadcom.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Now we can move brcmf_attach() until after the firmware has been downloaded
to the device. Make the call just before brcmf_bus_started().

Reviewed-by: Hante Meuleman <hante.meuleman@broadcom.com>
Reviewed-by: Pieter-Paul Giesberts <pieter-paul.giesberts@broadcom.com>
Reviewed-by: Franky Lin <franky.lin@broadcom.com>
Signed-off-by: Arend van Spriel <arend.vanspriel@broadcom.com>
---
 .../wireless/broadcom/brcm80211/brcmfmac/core.c    |  6 ++++
 .../wireless/broadcom/brcm80211/brcmfmac/sdio.c    | 34 +++++++++++-----------
 2 files changed, 23 insertions(+), 17 deletions(-)

diff --git a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/core.c b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/core.c
index 6dd6da7..e553d1a 100644
--- a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/core.c
+++ b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/core.c
@@ -1190,6 +1190,12 @@ void brcmf_bus_change_state(struct brcmf_bus *bus, enum brcmf_bus_state state)
 	int ifidx;
 
 	brcmf_dbg(TRACE, "%d -> %d\n", bus->state, state);
+
+	if (!drvr) {
+		brcmf_dbg(INFO, "ignoring transition, bus not attached yet\n");
+		return;
+	}
+
 	bus->state = state;
 
 	if (state == BRCMF_BUS_UP) {
diff --git a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/sdio.c b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/sdio.c
index 9ea525e..0f1e452 100644
--- a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/sdio.c
+++ b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/sdio.c
@@ -4048,9 +4048,6 @@ static void brcmf_sdio_firmware_callback(struct device *dev, int err,
 	if (err)
 		goto fail;
 
-	if (!bus_if->drvr)
-		return;
-
 	/* try to download image and nvram to the dongle */
 	bus->alp_only = true;
 	err = brcmf_sdio_download_firmware(bus, code, nvram, nvram_len);
@@ -4126,11 +4123,28 @@ static void brcmf_sdio_firmware_callback(struct device *dev, int err,
 
 	sdio_release_host(sdiodev->func1);
 
+	/* Assign bus interface call back */
+	sdiodev->bus_if->dev = sdiodev->dev;
+	sdiodev->bus_if->ops = &brcmf_sdio_bus_ops;
+	sdiodev->bus_if->chip = bus->ci->chip;
+	sdiodev->bus_if->chiprev = bus->ci->chiprev;
+
+	/* Attach to the common layer, reserve hdr space */
+	err = brcmf_attach(sdiodev->dev, sdiodev->settings);
+	if (err != 0) {
+		brcmf_err("brcmf_attach failed\n");
+		goto fail;
+	}
+
+	brcmf_sdio_debugfs_create(bus);
+
 	err = brcmf_bus_started(dev);
 	if (err != 0) {
 		brcmf_err("dongle is not responding\n");
 		goto fail;
 	}
+
+	/* ready */
 	return;
 
 release:
@@ -4199,22 +4213,9 @@ struct brcmf_sdio *brcmf_sdio_probe(struct brcmf_sdio_dev *sdiodev)
 	bus->dpc_triggered = false;
 	bus->dpc_running = false;
 
-	/* Assign bus interface call back */
-	bus->sdiodev->bus_if->dev = bus->sdiodev->dev;
-	bus->sdiodev->bus_if->ops = &brcmf_sdio_bus_ops;
-	bus->sdiodev->bus_if->chip = bus->ci->chip;
-	bus->sdiodev->bus_if->chiprev = bus->ci->chiprev;
-
 	/* default sdio bus header length for tx packet */
 	bus->tx_hdrlen = SDPCM_HWHDR_LEN + SDPCM_SWHDR_LEN;
 
-	/* Attach to the common layer, reserve hdr space */
-	ret = brcmf_attach(bus->sdiodev->dev, bus->sdiodev->settings);
-	if (ret != 0) {
-		brcmf_err("brcmf_attach failed\n");
-		goto fail;
-	}
-
 	/* Query the F2 block size, set roundup accordingly */
 	bus->blocksize = bus->sdiodev->func2->cur_blksize;
 	bus->roundup = min(max_roundup, bus->blocksize);
@@ -4239,7 +4240,6 @@ struct brcmf_sdio *brcmf_sdio_probe(struct brcmf_sdio_dev *sdiodev)
 	/* SR state */
 	bus->sr_enabled = false;
 
-	brcmf_sdio_debugfs_create(bus);
 	brcmf_dbg(INFO, "completed!!\n");
 
 	ret = brcmf_fw_map_chip_to_name(bus->ci->chip, bus->ci->chiprev,
-- 
1.9.1
