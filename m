Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from rnd-relay.smtp.broadcom.com ([192.19.229.170]:47996 "EHLO
        rnd-relay.smtp.broadcom.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S932338AbeBSXOe (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 19 Feb 2018 18:14:34 -0500
From: Arend van Spriel <arend.vanspriel@broadcom.com>
To: Kalle Valo <kvalo@codeaurora.org>
Cc: linux-wireless@vger.kernel.org,
        Arend van Spriel <arend.vanspriel@broadcom.com>
Subject: [PATCH 2/8] brcmfmac: move allocation of control rx buffer to brcmf_sdio_bus_preinit()
Date: Tue, 20 Feb 2018 00:14:19 +0100
Message-Id: <1519082065-10128-3-git-send-email-arend.vanspriel@broadcom.com> (sfid-20180220_001442_412941_3D9E35A1)
In-Reply-To: <1519082065-10128-1-git-send-email-arend.vanspriel@broadcom.com>
References: <1519082065-10128-1-git-send-email-arend.vanspriel@broadcom.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Allocate the control rx buffer needed for firmware control interface
during brcmf_sdio_bus_preinit(). This relies on common layer setting
struct brcmf_bus::maxctl during brcmf_attach(). By moving the allocation
we can move brcmf_attach() in subsequent change.

Reviewed-by: Hante Meuleman <hante.meuleman@broadcom.com>
Reviewed-by: Pieter-Paul Giesberts <pieter-paul.giesberts@broadcom.com>
Reviewed-by: Franky Lin <franky.lin@broadcom.com>
Signed-off-by: Arend van Spriel <arend.vanspriel@broadcom.com>
---
 .../wireless/broadcom/brcm80211/brcmfmac/sdio.c    | 26 ++++++++++------------
 1 file changed, 12 insertions(+), 14 deletions(-)

diff --git a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/sdio.c b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/sdio.c
index 0868614..9ea525e 100644
--- a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/sdio.c
+++ b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/sdio.c
@@ -1707,7 +1707,6 @@ static int brcmf_sdio_dcmd_resp_wake(struct brcmf_sdio *bus)
 	int sdret;
 
 	brcmf_dbg(TRACE, "Enter\n");
-
 	if (bus->rxblen)
 		buf = vzalloc(bus->rxblen);
 	if (!buf)
@@ -3411,6 +3410,18 @@ static int brcmf_sdio_bus_preinit(struct device *dev)
 	u32 value;
 	int err;
 
+	/* maxctl provided by common layer */
+	if (WARN_ON(!bus_if->maxctl))
+		return -EINVAL;
+
+	/* Allocate control receive buffer */
+	bus_if->maxctl += bus->roundup;
+	value = roundup((bus_if->maxctl + SDPCM_HDRLEN), ALIGNMENT);
+	value += bus->head_align;
+	bus->rxbuf = kmalloc(value, GFP_ATOMIC);
+	if (bus->rxbuf)
+		bus->rxblen = value;
+
 	/* the commands below use the terms tx and rx from
 	 * a device perspective, ie. bus:txglom affects the
 	 * bus transfers from device to host.
@@ -4208,19 +4219,6 @@ struct brcmf_sdio *brcmf_sdio_probe(struct brcmf_sdio_dev *sdiodev)
 	bus->blocksize = bus->sdiodev->func2->cur_blksize;
 	bus->roundup = min(max_roundup, bus->blocksize);
 
-	/* Allocate buffers */
-	if (bus->sdiodev->bus_if->maxctl) {
-		bus->sdiodev->bus_if->maxctl += bus->roundup;
-		bus->rxblen =
-		    roundup((bus->sdiodev->bus_if->maxctl + SDPCM_HDRLEN),
-			    ALIGNMENT) + bus->head_align;
-		bus->rxbuf = kmalloc(bus->rxblen, GFP_ATOMIC);
-		if (!(bus->rxbuf)) {
-			brcmf_err("rxbuf allocation failed\n");
-			goto fail;
-		}
-	}
-
 	sdio_claim_host(bus->sdiodev->func1);
 
 	/* Disable F2 to clear any intermediate frame state on the dongle */
-- 
1.9.1
