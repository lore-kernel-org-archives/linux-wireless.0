Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mms2.broadcom.com ([216.31.210.18]:4840 "EHLO mms2.broadcom.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759579Ab1KWBWP (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 22 Nov 2011 20:22:15 -0500
From: "Franky Lin" <frankyl@broadcom.com>
To: linville@tuxdriver.com
cc: linux-wireless@vger.kernel.org
Subject: [PATCH 22/24] brcm80211: fmac: change function bus_init
 parameter
Date: Tue, 22 Nov 2011 17:21:57 -0800
Message-ID: <1322011319-24863-23-git-send-email-frankyl@broadcom.com> (sfid-20111123_022223_202215_41B6B61F)
In-Reply-To: <1322011319-24863-1-git-send-email-frankyl@broadcom.com>
References: <1322011319-24863-1-git-send-email-frankyl@broadcom.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Change parameter to device pointer for bus layer interface function
brcmf_sdbrcm_bus_init. This is part of the fullmac bus interface
refactoring.

Reviewed-by: Pieter-Paul Giesberts <pieterpg@broadcom.com>
Reviewed-by: Arend van Spriel <arend@broadcom.com>
Signed-off-by: Franky Lin <frankyl@broadcom.com>
---
 drivers/net/wireless/brcm80211/brcmfmac/dhd_bus.h  |    2 +-
 .../net/wireless/brcm80211/brcmfmac/dhd_linux.c    |    2 +-
 drivers/net/wireless/brcm80211/brcmfmac/dhd_sdio.c |   12 +++++++-----
 3 files changed, 9 insertions(+), 7 deletions(-)

diff --git a/drivers/net/wireless/brcm80211/brcmfmac/dhd_bus.h b/drivers/net/wireless/brcm80211/brcmfmac/dhd_bus.h
index c73679e..cfcf5a9 100644
--- a/drivers/net/wireless/brcm80211/brcmfmac/dhd_bus.h
+++ b/drivers/net/wireless/brcm80211/brcmfmac/dhd_bus.h
@@ -34,7 +34,7 @@ extern struct device *brcmf_bus_get_device(struct brcmf_sdio *bus);
 extern void brcmf_sdbrcm_bus_stop(struct brcmf_sdio *bus);
 
 /* Initialize bus module: prepare for communication w/dongle */
-extern int brcmf_sdbrcm_bus_init(struct brcmf_pub *drvr);
+extern int brcmf_sdbrcm_bus_init(struct device *dev);
 
 /* Send a data frame to the dongle.  Callee disposes of txp. */
 extern int brcmf_sdbrcm_bus_txdata(struct device *dev, struct sk_buff *txp);
diff --git a/drivers/net/wireless/brcm80211/brcmfmac/dhd_linux.c b/drivers/net/wireless/brcm80211/brcmfmac/dhd_linux.c
index 1cfe9f3..f8c0ae4 100644
--- a/drivers/net/wireless/brcm80211/brcmfmac/dhd_linux.c
+++ b/drivers/net/wireless/brcm80211/brcmfmac/dhd_linux.c
@@ -993,7 +993,7 @@ int brcmf_bus_start(struct brcmf_pub *drvr)
 	brcmf_dbg(TRACE, "\n");
 
 	/* Bring up the bus */
-	ret = brcmf_sdbrcm_bus_init(&drvr_priv->pub);
+	ret = brcmf_sdbrcm_bus_init(drvr_priv->pub.dev);
 	if (ret != 0) {
 		brcmf_dbg(ERROR, "brcmf_sdbrcm_bus_init failed %d\n", ret);
 		return ret;
diff --git a/drivers/net/wireless/brcm80211/brcmfmac/dhd_sdio.c b/drivers/net/wireless/brcm80211/brcmfmac/dhd_sdio.c
index f80151b..8c00014 100644
--- a/drivers/net/wireless/brcm80211/brcmfmac/dhd_sdio.c
+++ b/drivers/net/wireless/brcm80211/brcmfmac/dhd_sdio.c
@@ -3408,9 +3408,11 @@ void brcmf_sdbrcm_bus_stop(struct brcmf_sdio *bus)
 	up(&bus->sdsem);
 }
 
-int brcmf_sdbrcm_bus_init(struct brcmf_pub *drvr)
+int brcmf_sdbrcm_bus_init(struct device *dev)
 {
-	struct brcmf_sdio *bus = drvr->bus;
+	struct brcmf_bus *bus_if = dev_get_drvdata(dev);
+	struct brcmf_sdio_dev *sdiodev = bus_if->bus_priv;
+	struct brcmf_sdio *bus = sdiodev->bus;
 	unsigned long timeout;
 	uint retries = 0;
 	u8 ready, enable;
@@ -3420,7 +3422,7 @@ int brcmf_sdbrcm_bus_init(struct brcmf_pub *drvr)
 	brcmf_dbg(TRACE, "Enter\n");
 
 	/* try to download image and nvram to the dongle */
-	if (drvr->bus_if->state == BRCMF_BUS_DOWN) {
+	if (bus_if->state == BRCMF_BUS_DOWN) {
 		if (!(brcmf_sdbrcm_download_firmware(bus)))
 			return -1;
 	}
@@ -3486,7 +3488,7 @@ int brcmf_sdbrcm_bus_init(struct brcmf_pub *drvr)
 				       SBSDIO_WATERMARK, 8, &err);
 
 		/* Set bus state according to enable result */
-		drvr->bus_if->state = BRCMF_BUS_DATA;
+		bus_if->state = BRCMF_BUS_DATA;
 	}
 
 	else {
@@ -3501,7 +3503,7 @@ int brcmf_sdbrcm_bus_init(struct brcmf_pub *drvr)
 			       SBSDIO_FUNC1_CHIPCLKCSR, saveclk, &err);
 
 	/* If we didn't come up, turn off backplane clock */
-	if (drvr->bus_if->state != BRCMF_BUS_DATA)
+	if (bus_if->state != BRCMF_BUS_DATA)
 		brcmf_sdbrcm_clkctl(bus, CLK_NONE, false);
 
 exit:
-- 
1.7.5.4


