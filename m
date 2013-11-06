Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mms3.broadcom.com ([216.31.210.19]:3233 "EHLO mms3.broadcom.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755765Ab3KFWHj (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 6 Nov 2013 17:07:39 -0500
From: "Arend van Spriel" <arend@broadcom.com>
To: "John W. Linville" <linville@tuxdriver.com>
cc: linux-wireless@vger.kernel.org,
	"Arend van Spriel" <arend@broadcom.com>
Subject: [PATCH 2/7] brcmfmac: add separate function for passing bus tx
 overhead
Date: Wed, 6 Nov 2013 23:07:17 +0100
Message-ID: <1383775642-647-3-git-send-email-arend@broadcom.com> (sfid-20131106_230749_378874_8FA63D5A)
In-Reply-To: <1383775642-647-1-git-send-email-arend@broadcom.com>
References: <1383775642-647-1-git-send-email-arend@broadcom.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

The common driver needs the packet overhead for the bus in order
to reserve headroom for sk_buffs. For the SDIO driver this depends
on firmware features so it is not possible to provide it in the
brcmf_attach() call.

Reviewed-by: Franky Lin <frankyl@broadcom.com>
Reviewed-by: Pieter-Paul Giesberts <pieterpg@broadcom.com>
Reviewed-by: Hante Meuleman <meuleman@broadcom.com>
Signed-off-by: Arend van Spriel <arend@broadcom.com>
---
 drivers/net/wireless/brcm80211/brcmfmac/dhd_bus.h   |  3 ++-
 drivers/net/wireless/brcm80211/brcmfmac/dhd_linux.c | 14 ++++++++++++--
 drivers/net/wireless/brcm80211/brcmfmac/dhd_sdio.c  |  4 +++-
 drivers/net/wireless/brcm80211/brcmfmac/usb.c       |  4 ++--
 4 files changed, 19 insertions(+), 6 deletions(-)

diff --git a/drivers/net/wireless/brcm80211/brcmfmac/dhd_bus.h b/drivers/net/wireless/brcm80211/brcmfmac/dhd_bus.h
index 7640d8a..392fc28 100644
--- a/drivers/net/wireless/brcm80211/brcmfmac/dhd_bus.h
+++ b/drivers/net/wireless/brcm80211/brcmfmac/dhd_bus.h
@@ -139,7 +139,7 @@ extern bool brcmf_c_prec_enq(struct device *dev, struct pktq *q,
 extern void brcmf_rx_frame(struct device *dev, struct sk_buff *rxp);
 
 /* Indication from bus module regarding presence/insertion of dongle. */
-extern int brcmf_attach(uint bus_hdrlen, struct device *dev);
+extern int brcmf_attach(struct device *dev);
 /* Indication from bus module regarding removal/absence of dongle */
 extern void brcmf_detach(struct device *dev);
 /* Indication from bus module that dongle should be reset */
@@ -152,6 +152,7 @@ extern void brcmf_txcomplete(struct device *dev, struct sk_buff *txp,
 			     bool success);
 
 extern int brcmf_bus_start(struct device *dev);
+extern void brcmf_bus_add_txhdrlen(struct device *dev, uint len);
 
 #ifdef CONFIG_BRCMFMAC_SDIO
 extern void brcmf_sdio_exit(void);
diff --git a/drivers/net/wireless/brcm80211/brcmfmac/dhd_linux.c b/drivers/net/wireless/brcm80211/brcmfmac/dhd_linux.c
index 64e9cff..0c4c230 100644
--- a/drivers/net/wireless/brcm80211/brcmfmac/dhd_linux.c
+++ b/drivers/net/wireless/brcm80211/brcmfmac/dhd_linux.c
@@ -1016,7 +1016,7 @@ void brcmf_del_if(struct brcmf_pub *drvr, s32 bssidx)
 	}
 }
 
-int brcmf_attach(uint bus_hdrlen, struct device *dev)
+int brcmf_attach(struct device *dev)
 {
 	struct brcmf_pub *drvr = NULL;
 	int ret = 0;
@@ -1031,7 +1031,7 @@ int brcmf_attach(uint bus_hdrlen, struct device *dev)
 	mutex_init(&drvr->proto_block);
 
 	/* Link to bus module */
-	drvr->hdrlen = bus_hdrlen;
+	drvr->hdrlen = 0;
 	drvr->bus_if = dev_get_drvdata(dev);
 	drvr->bus_if->drvr = drvr;
 
@@ -1138,6 +1138,16 @@ fail:
 	return 0;
 }
 
+void brcmf_bus_add_txhdrlen(struct device *dev, uint len)
+{
+	struct brcmf_bus *bus_if = dev_get_drvdata(dev);
+	struct brcmf_pub *drvr = bus_if->drvr;
+
+	if (drvr) {
+		drvr->hdrlen += len;
+	}
+}
+
 static void brcmf_bus_detach(struct brcmf_pub *drvr)
 {
 	brcmf_dbg(TRACE, "Enter\n");
diff --git a/drivers/net/wireless/brcm80211/brcmfmac/dhd_sdio.c b/drivers/net/wireless/brcm80211/brcmfmac/dhd_sdio.c
index b02953c..928983b 100644
--- a/drivers/net/wireless/brcm80211/brcmfmac/dhd_sdio.c
+++ b/drivers/net/wireless/brcm80211/brcmfmac/dhd_sdio.c
@@ -3983,7 +3983,7 @@ void *brcmf_sdbrcm_probe(u32 regsva, struct brcmf_sdio_dev *sdiodev)
 	bus->tx_hdrlen = SDPCM_HWHDR_LEN + SDPCM_SWHDR_LEN;
 
 	/* Attach to the common layer, reserve hdr space */
-	ret = brcmf_attach(bus->tx_hdrlen, bus->sdiodev->dev);
+	ret = brcmf_attach(bus->sdiodev->dev);
 	if (ret != 0) {
 		brcmf_err("brcmf_attach failed\n");
 		goto fail;
@@ -4027,6 +4027,8 @@ void *brcmf_sdbrcm_probe(u32 regsva, struct brcmf_sdio_dev *sdiodev)
 		list_add(&dlst->list, &bus->sdiodev->bus_if->dcmd_list);
 	}
 
+	brcmf_bus_add_txhdrlen(bus->sdiodev->dev, bus->tx_hdrlen);
+
 	/* if firmware path present try to download and bring up bus */
 	ret = brcmf_bus_start(bus->sdiodev->dev);
 	if (ret != 0) {
diff --git a/drivers/net/wireless/brcm80211/brcmfmac/usb.c b/drivers/net/wireless/brcm80211/brcmfmac/usb.c
index 422f44c..51c4de0 100644
--- a/drivers/net/wireless/brcm80211/brcmfmac/usb.c
+++ b/drivers/net/wireless/brcm80211/brcmfmac/usb.c
@@ -1255,7 +1255,7 @@ static int brcmf_usb_probe_cb(struct brcmf_usbdev_info *devinfo)
 	bus->chiprev = bus_pub->chiprev;
 
 	/* Attach to the common driver interface */
-	ret = brcmf_attach(0, dev);
+	ret = brcmf_attach(dev);
 	if (ret) {
 		brcmf_err("brcmf_attach failed\n");
 		goto fail;
@@ -1454,7 +1454,7 @@ static int brcmf_usb_resume(struct usb_interface *intf)
 	struct brcmf_usbdev_info *devinfo = brcmf_usb_get_businfo(&usb->dev);
 
 	brcmf_dbg(USB, "Enter\n");
-	if (!brcmf_attach(0, devinfo->dev))
+	if (!brcmf_attach(devinfo->dev))
 		return brcmf_bus_start(&usb->dev);
 
 	return 0;
-- 
1.8.1.3


