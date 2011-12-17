Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mms1.broadcom.com ([216.31.210.17]:2350 "EHLO mms1.broadcom.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1760947Ab1LQChb (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 16 Dec 2011 21:37:31 -0500
From: "Franky Lin" <frankyl@broadcom.com>
To: linville@tuxdriver.com
cc: linux-wireless@vger.kernel.org
Subject: [PATCH 24/30] brcm80211: fmac: abstract bus_init interface
 function pointer
Date: Fri, 16 Dec 2011 18:37:14 -0800
Message-ID: <1324089440-8957-25-git-send-email-frankyl@broadcom.com> (sfid-20111217_035945_869497_85C8E8AC)
In-Reply-To: <1324089440-8957-1-git-send-email-frankyl@broadcom.com>
References: <1324089440-8957-1-git-send-email-frankyl@broadcom.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Abstract bus layer brcmf_bus_init function pointer for common
layer. This patch is part of the fullmac bus interface refactoring.

Reviewed-by: Pieter-Paul Giesberts <pieterpg@broadcom.com>
Reviewed-by: Arend van Spriel <arend@broadcom.com>
Reviewed-by: Alwin Beukers <alwin@broadcom.com>
Signed-off-by: Franky Lin <frankyl@broadcom.com>
---
 drivers/net/wireless/brcm80211/brcmfmac/dhd_bus.h  |    5 ++---
 .../net/wireless/brcm80211/brcmfmac/dhd_linux.c    |    2 +-
 drivers/net/wireless/brcm80211/brcmfmac/dhd_sdio.c |    3 ++-
 3 files changed, 5 insertions(+), 5 deletions(-)

diff --git a/drivers/net/wireless/brcm80211/brcmfmac/dhd_bus.h b/drivers/net/wireless/brcm80211/brcmfmac/dhd_bus.h
index dc022e3..5d5f2af 100644
--- a/drivers/net/wireless/brcm80211/brcmfmac/dhd_bus.h
+++ b/drivers/net/wireless/brcm80211/brcmfmac/dhd_bus.h
@@ -51,6 +51,8 @@ struct brcmf_bus {
 	/* interface functions pointers */
 	/* Stop bus module: clear pending frames, disable data flow */
 	void (*brcmf_bus_stop)(struct device *);
+	/* Initialize bus module: prepare for communication w/dongle */
+	int (*brcmf_bus_init)(struct device *);
 };
 
 /*
@@ -97,9 +99,6 @@ extern int brcmf_add_if(struct device *dev, int ifidx,
 /*
  * Exported from brcmf bus module (brcmf_usb, brcmf_sdio)
  */
-/* Initialize bus module: prepare for communication w/dongle */
-extern int brcmf_sdbrcm_bus_init(struct device *dev);
-
 /* Send a data frame to the dongle.  Callee disposes of txp. */
 extern int brcmf_sdbrcm_bus_txdata(struct device *dev, struct sk_buff *txp);
 
diff --git a/drivers/net/wireless/brcm80211/brcmfmac/dhd_linux.c b/drivers/net/wireless/brcm80211/brcmfmac/dhd_linux.c
index 6c398c4..62b4575 100644
--- a/drivers/net/wireless/brcm80211/brcmfmac/dhd_linux.c
+++ b/drivers/net/wireless/brcm80211/brcmfmac/dhd_linux.c
@@ -971,7 +971,7 @@ int brcmf_bus_start(struct device *dev)
 	brcmf_dbg(TRACE, "\n");
 
 	/* Bring up the bus */
-	ret = brcmf_sdbrcm_bus_init(dev);
+	ret = bus_if->brcmf_bus_init(dev);
 	if (ret != 0) {
 		brcmf_dbg(ERROR, "brcmf_sdbrcm_bus_init failed %d\n", ret);
 		return ret;
diff --git a/drivers/net/wireless/brcm80211/brcmfmac/dhd_sdio.c b/drivers/net/wireless/brcm80211/brcmfmac/dhd_sdio.c
index 7817ede..5089b64 100644
--- a/drivers/net/wireless/brcm80211/brcmfmac/dhd_sdio.c
+++ b/drivers/net/wireless/brcm80211/brcmfmac/dhd_sdio.c
@@ -3423,7 +3423,7 @@ brcmf_sdbrcm_download_firmware(struct brcmf_sdio *bus)
 	return ret;
 }
 
-int brcmf_sdbrcm_bus_init(struct device *dev)
+static int brcmf_sdbrcm_bus_init(struct device *dev)
 {
 	struct brcmf_bus *bus_if = dev_get_drvdata(dev);
 	struct brcmf_sdio_dev *sdiodev = bus_if->bus_priv;
@@ -3954,6 +3954,7 @@ void *brcmf_sdbrcm_probe(u32 regsva, struct brcmf_sdio_dev *sdiodev)
 
 	/* Assign bus interface call back */
 	bus->sdiodev->bus_if->brcmf_bus_stop = brcmf_sdbrcm_bus_stop;
+	bus->sdiodev->bus_if->brcmf_bus_init = brcmf_sdbrcm_bus_init;
 	/* Attach to the brcmf/OS/network interface */
 	ret = brcmf_attach(SDPCM_RESERVE, bus->sdiodev->dev);
 	if (ret != 0) {
-- 
1.7.5.4


