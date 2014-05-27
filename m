Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-gw2-out.broadcom.com ([216.31.210.63]:34771 "EHLO
	mail-gw2-out.broadcom.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751985AbaE0K4f (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 27 May 2014 06:56:35 -0400
From: Arend van Spriel <arend@broadcom.com>
To: "John W. Linville" <linville@tuxdriver.com>
CC: linux-wireless <linux-wireless@vger.kernel.org>,
	Arend van Spriel <arend@broadcom.com>
Subject: [PATCH 04/16] brcmfmac: remove .init() callback for internal bus interface
Date: Tue, 27 May 2014 12:56:16 +0200
Message-ID: <1401188188-16492-5-git-send-email-arend@broadcom.com> (sfid-20140527_132147_614557_4FDA5DF1)
In-Reply-To: <1401188188-16492-1-git-send-email-arend@broadcom.com>
References: <1401188188-16492-1-git-send-email-arend@broadcom.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

The .init() callback was the first function called by the common
bus function brcmf_bus_start(). Given that it is not really
necessary and the bus layer can call it before calling the
brcmf_bus_start() function.

Reviewed-by: Daniel (Deognyoun) Kim <dekim@broadcom.com>
Reviewed-by: Franky Lin <frankyl@broadcom.com>
Reviewed-by: Hante Meuleman <meuleman@broadcom.com>
Reviewed-by: Pieter-Paul Giesberts <pieterpg@broadcom.com>
Signed-off-by: Arend van Spriel <arend@broadcom.com>
---
 drivers/net/wireless/brcm80211/brcmfmac/dhd_bus.h  |    6 ------
 .../net/wireless/brcm80211/brcmfmac/dhd_linux.c    |    7 -------
 drivers/net/wireless/brcm80211/brcmfmac/dhd_sdio.c |    5 ++++-
 drivers/net/wireless/brcm80211/brcmfmac/usb.c      |    7 ++++++-
 4 files changed, 10 insertions(+), 15 deletions(-)

diff --git a/drivers/net/wireless/brcm80211/brcmfmac/dhd_bus.h b/drivers/net/wireless/brcm80211/brcmfmac/dhd_bus.h
index c5dcd82..7735328 100644
--- a/drivers/net/wireless/brcm80211/brcmfmac/dhd_bus.h
+++ b/drivers/net/wireless/brcm80211/brcmfmac/dhd_bus.h
@@ -63,7 +63,6 @@ struct brcmf_bus_dcmd {
  */
 struct brcmf_bus_ops {
 	int (*preinit)(struct device *dev);
-	int (*init)(struct device *dev);
 	void (*stop)(struct device *dev);
 	int (*txdata)(struct device *dev, struct sk_buff *skb);
 	int (*txctl)(struct device *dev, unsigned char *msg, uint len);
@@ -114,11 +113,6 @@ static inline int brcmf_bus_preinit(struct brcmf_bus *bus)
 	return bus->ops->preinit(bus->dev);
 }
 
-static inline int brcmf_bus_init(struct brcmf_bus *bus)
-{
-	return bus->ops->init(bus->dev);
-}
-
 static inline void brcmf_bus_stop(struct brcmf_bus *bus)
 {
 	bus->ops->stop(bus->dev);
diff --git a/drivers/net/wireless/brcm80211/brcmfmac/dhd_linux.c b/drivers/net/wireless/brcm80211/brcmfmac/dhd_linux.c
index 4cacc3d..09dd8c1 100644
--- a/drivers/net/wireless/brcm80211/brcmfmac/dhd_linux.c
+++ b/drivers/net/wireless/brcm80211/brcmfmac/dhd_linux.c
@@ -916,13 +916,6 @@ int brcmf_bus_start(struct device *dev)
 
 	brcmf_dbg(TRACE, "\n");
 
-	/* Bring up the bus */
-	ret = brcmf_bus_init(bus_if);
-	if (ret != 0) {
-		brcmf_err("brcmf_sdbrcm_bus_init failed %d\n", ret);
-		return ret;
-	}
-
 	/* add primary networking interface */
 	ifp = brcmf_add_if(drvr, 0, 0, "wlan%d", NULL);
 	if (IS_ERR(ifp))
diff --git a/drivers/net/wireless/brcm80211/brcmfmac/dhd_sdio.c b/drivers/net/wireless/brcm80211/brcmfmac/dhd_sdio.c
index 13c89a0..494371c 100644
--- a/drivers/net/wireless/brcm80211/brcmfmac/dhd_sdio.c
+++ b/drivers/net/wireless/brcm80211/brcmfmac/dhd_sdio.c
@@ -4020,7 +4020,6 @@ brcmf_sdio_watchdog(unsigned long data)
 static struct brcmf_bus_ops brcmf_sdio_bus_ops = {
 	.stop = brcmf_sdio_bus_stop,
 	.preinit = brcmf_sdio_bus_preinit,
-	.init = brcmf_sdio_bus_init,
 	.txdata = brcmf_sdio_bus_txdata,
 	.txctl = brcmf_sdio_bus_txctl,
 	.rxctl = brcmf_sdio_bus_rxctl,
@@ -4150,6 +4149,10 @@ struct brcmf_sdio *brcmf_sdio_probe(struct brcmf_sdio_dev *sdiodev)
 	brcmf_sdio_debugfs_create(bus);
 	brcmf_dbg(INFO, "completed!!\n");
 
+	ret = brcmf_sdio_bus_init(sdiodev->dev);
+	if (ret)
+		goto fail;
+
 	/* if firmware path present try to download and bring up bus */
 	ret = brcmf_bus_start(bus->sdiodev->dev);
 	if (ret != 0) {
diff --git a/drivers/net/wireless/brcm80211/brcmfmac/usb.c b/drivers/net/wireless/brcm80211/brcmfmac/usb.c
index 3ce0e7c..1c846c5 100644
--- a/drivers/net/wireless/brcm80211/brcmfmac/usb.c
+++ b/drivers/net/wireless/brcm80211/brcmfmac/usb.c
@@ -1222,7 +1222,6 @@ error:
 
 static struct brcmf_bus_ops brcmf_usb_bus_ops = {
 	.txdata = brcmf_usb_tx,
-	.init = brcmf_usb_up,
 	.stop = brcmf_usb_down,
 	.txctl = brcmf_usb_tx_ctlpkt,
 	.rxctl = brcmf_usb_rx_ctlpkt,
@@ -1263,6 +1262,12 @@ static int brcmf_usb_probe_cb(struct brcmf_usbdev_info *devinfo)
 		goto fail;
 	}
 
+	ret = brcmf_usb_up(dev);
+	if (ret) {
+		brcmf_detach(dev);
+		goto fail;
+	}
+
 	ret = brcmf_bus_start(dev);
 	if (ret) {
 		brcmf_err("dongle is not responding\n");
-- 
1.7.9.5

