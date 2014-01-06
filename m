Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-gw2-out.broadcom.com ([216.31.210.63]:5265 "EHLO
	mail-gw2-out.broadcom.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754407AbaAFLk6 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 6 Jan 2014 06:40:58 -0500
From: Arend van Spriel <arend@broadcom.com>
To: "John W. Linville" <linville@tuxdriver.com>
CC: linux-wireless <linux-wireless@vger.kernel.org>,
	Arend van Spriel <arend@broadcom.com>
Subject: [PATCH 05/15] brcmfmac: cleanup helper functions in sdio probe path
Date: Mon, 6 Jan 2014 12:40:40 +0100
Message-ID: <1389008450-28529-6-git-send-email-arend@broadcom.com> (sfid-20140106_124103_792840_BB1F1149)
In-Reply-To: <1389008450-28529-1-git-send-email-arend@broadcom.com>
References: <1389008450-28529-1-git-send-email-arend@broadcom.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Moving code from helper functions to the calling function
as it makes code easier to read.

Reviewed-by: Hante Meuleman <meuleman@broadcom.com>
Reviewed-by: Pieter-Paul Giesberts <pieterpg@broadcom.com>
Signed-off-by: Arend van Spriel <arend@broadcom.com>
---
 drivers/net/wireless/brcm80211/brcmfmac/dhd_sdio.c |   90 ++++++++------------
 1 file changed, 34 insertions(+), 56 deletions(-)

diff --git a/drivers/net/wireless/brcm80211/brcmfmac/dhd_sdio.c b/drivers/net/wireless/brcm80211/brcmfmac/dhd_sdio.c
index 27fbcbf..270cf9b 100644
--- a/drivers/net/wireless/brcm80211/brcmfmac/dhd_sdio.c
+++ b/drivers/net/wireless/brcm80211/brcmfmac/dhd_sdio.c
@@ -3750,22 +3750,6 @@ static void brcmf_sdio_dataworker(struct work_struct *work)
 	}
 }
 
-static bool brcmf_sdio_probe_malloc(struct brcmf_sdio *bus)
-{
-	brcmf_dbg(TRACE, "Enter\n");
-
-	if (bus->sdiodev->bus_if->maxctl) {
-		bus->rxblen =
-		    roundup((bus->sdiodev->bus_if->maxctl + SDPCM_HDRLEN),
-			    ALIGNMENT) + bus->head_align;
-		bus->rxbuf = kmalloc(bus->rxblen, GFP_ATOMIC);
-		if (!(bus->rxbuf))
-			return false;
-	}
-
-	return true;
-}
-
 static bool
 brcmf_sdio_probe_attach(struct brcmf_sdio *bus)
 {
@@ -3879,39 +3863,6 @@ fail:
 	return false;
 }
 
-static bool brcmf_sdio_probe_init(struct brcmf_sdio *bus)
-{
-	brcmf_dbg(TRACE, "Enter\n");
-
-	sdio_claim_host(bus->sdiodev->func[1]);
-
-	/* Disable F2 to clear any intermediate frame state on the dongle */
-	sdio_disable_func(bus->sdiodev->func[SDIO_FUNC_2]);
-
-	bus->sdiodev->bus_if->state = BRCMF_BUS_DOWN;
-	bus->rxflow = false;
-
-	/* Done with backplane-dependent accesses, can drop clock... */
-	brcmf_sdiod_regwb(bus->sdiodev, SBSDIO_FUNC1_CHIPCLKCSR, 0, NULL);
-
-	sdio_release_host(bus->sdiodev->func[1]);
-
-	/* ...and initialize clock/power states */
-	bus->clkstate = CLK_SDONLY;
-	bus->idletime = BRCMF_IDLE_INTERVAL;
-	bus->idleclock = BRCMF_IDLE_ACTIVE;
-
-	/* Query the F2 block size, set roundup accordingly */
-	bus->blocksize = bus->sdiodev->func[2]->cur_blksize;
-	bus->roundup = min(max_roundup, bus->blocksize);
-
-	/* SR state */
-	bus->sleeping = false;
-	bus->sr_enabled = false;
-
-	return true;
-}
-
 static int
 brcmf_sdio_watchdog_thread(void *data)
 {
@@ -4039,15 +3990,42 @@ struct brcmf_sdio *brcmf_sdio_probe(struct brcmf_sdio_dev *sdiodev)
 	}
 
 	/* Allocate buffers */
-	if (!(brcmf_sdio_probe_malloc(bus))) {
-		brcmf_err("brcmf_sdio_probe_malloc failed\n");
-		goto fail;
+	if (bus->sdiodev->bus_if->maxctl) {
+		bus->rxblen =
+		    roundup((bus->sdiodev->bus_if->maxctl + SDPCM_HDRLEN),
+			    ALIGNMENT) + bus->head_align;
+		bus->rxbuf = kmalloc(bus->rxblen, GFP_ATOMIC);
+		if (!(bus->rxbuf)) {
+			brcmf_err("rxbuf allocation failed\n");
+			goto fail;
+		}
 	}
 
-	if (!(brcmf_sdio_probe_init(bus))) {
-		brcmf_err("brcmf_sdio_probe_init failed\n");
-		goto fail;
-	}
+	sdio_claim_host(bus->sdiodev->func[1]);
+
+	/* Disable F2 to clear any intermediate frame state on the dongle */
+	sdio_disable_func(bus->sdiodev->func[SDIO_FUNC_2]);
+
+	bus->sdiodev->bus_if->state = BRCMF_BUS_DOWN;
+	bus->rxflow = false;
+
+	/* Done with backplane-dependent accesses, can drop clock... */
+	brcmf_sdiod_regwb(bus->sdiodev, SBSDIO_FUNC1_CHIPCLKCSR, 0, NULL);
+
+	sdio_release_host(bus->sdiodev->func[1]);
+
+	/* ...and initialize clock/power states */
+	bus->clkstate = CLK_SDONLY;
+	bus->idletime = BRCMF_IDLE_INTERVAL;
+	bus->idleclock = BRCMF_IDLE_ACTIVE;
+
+	/* Query the F2 block size, set roundup accordingly */
+	bus->blocksize = bus->sdiodev->func[2]->cur_blksize;
+	bus->roundup = min(max_roundup, bus->blocksize);
+
+	/* SR state */
+	bus->sleeping = false;
+	bus->sr_enabled = false;
 
 	brcmf_sdio_debugfs_create(bus);
 	brcmf_dbg(INFO, "completed!!\n");
-- 
1.7.10.4

