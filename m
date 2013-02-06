Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mms1.broadcom.com ([216.31.210.17]:1353 "EHLO mms1.broadcom.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753869Ab3BFRmg (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 6 Feb 2013 12:42:36 -0500
From: "Arend van Spriel" <arend@broadcom.com>
To: "John W. Linville" <linville@tuxdriver.com>
cc: "Linux Wireless List" <linux-wireless@vger.kernel.org>,
	"Arend van Spriel" <arend@broadcom.com>
Subject: [PATCH 10/12] brcmfmac: add chip information to the bus
 interface
Date: Wed, 6 Feb 2013 18:40:45 +0100
Message-ID: <1360172447-2424-11-git-send-email-arend@broadcom.com> (sfid-20130206_184248_413202_A7D810D9)
In-Reply-To: <1360172447-2424-1-git-send-email-arend@broadcom.com>
References: <1360172447-2424-1-git-send-email-arend@broadcom.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Extend the bus interface with chip identifier and revision. This
will be used when certain devices need special handling in the
driver.

Reviewed-by: Hante Meuleman <meuleman@broadcom.com>
Reviewed-by: Pieter-Paul Giesberts <pieterpg@broadcom.com>
Reviewed-by: Piotr Haber <phaber@broadcom.com>
Signed-off-by: Arend van Spriel <arend@broadcom.com>
---
 drivers/net/wireless/brcm80211/brcmfmac/dhd_bus.h  |    4 ++++
 drivers/net/wireless/brcm80211/brcmfmac/dhd_sdio.c |    2 ++
 drivers/net/wireless/brcm80211/brcmfmac/usb.c      |    2 ++
 3 files changed, 8 insertions(+)

diff --git a/drivers/net/wireless/brcm80211/brcmfmac/dhd_bus.h b/drivers/net/wireless/brcm80211/brcmfmac/dhd_bus.h
index 6af7c9d..ad25c34 100644
--- a/drivers/net/wireless/brcm80211/brcmfmac/dhd_bus.h
+++ b/drivers/net/wireless/brcm80211/brcmfmac/dhd_bus.h
@@ -64,6 +64,8 @@ struct brcmf_bus_ops {
  * @dstats: dongle-based statistical data.
  * @align: alignment requirement for the bus.
  * @dcmd_list: bus/device specific dongle initialization commands.
+ * @chip: device identifier of the dongle chip.
+ * @chiprev: revision of the dongle chip.
  */
 struct brcmf_bus {
 	union {
@@ -76,6 +78,8 @@ struct brcmf_bus {
 	uint maxctl;
 	unsigned long tx_realloc;
 	u8 align;
+	u32 chip;
+	u32 chiprev;
 	struct list_head dcmd_list;
 
 	struct brcmf_bus_ops *ops;
diff --git a/drivers/net/wireless/brcm80211/brcmfmac/dhd_sdio.c b/drivers/net/wireless/brcm80211/brcmfmac/dhd_sdio.c
index d424dd6..04680c5 100644
--- a/drivers/net/wireless/brcm80211/brcmfmac/dhd_sdio.c
+++ b/drivers/net/wireless/brcm80211/brcmfmac/dhd_sdio.c
@@ -3927,6 +3927,8 @@ void *brcmf_sdbrcm_probe(u32 regsva, struct brcmf_sdio_dev *sdiodev)
 	/* Assign bus interface call back */
 	bus->sdiodev->bus_if->dev = bus->sdiodev->dev;
 	bus->sdiodev->bus_if->ops = &brcmf_sdio_bus_ops;
+	bus->sdiodev->bus_if->chip = bus->ci->chip;
+	bus->sdiodev->bus_if->chiprev = bus->ci->chiprev;
 
 	/* Attach to the brcmf/OS/network interface */
 	ret = brcmf_attach(SDPCM_RESERVE, bus->sdiodev->dev);
diff --git a/drivers/net/wireless/brcm80211/brcmfmac/usb.c b/drivers/net/wireless/brcm80211/brcmfmac/usb.c
index 06f7339..a55994d 100644
--- a/drivers/net/wireless/brcm80211/brcmfmac/usb.c
+++ b/drivers/net/wireless/brcm80211/brcmfmac/usb.c
@@ -1250,6 +1250,8 @@ static int brcmf_usb_probe_cb(struct brcmf_usbdev_info *devinfo)
 	bus->bus_priv.usb = bus_pub;
 	dev_set_drvdata(dev, bus);
 	bus->ops = &brcmf_usb_bus_ops;
+	bus->chip = bus_pub->devid;
+	bus->chiprev = bus_pub->chiprev;
 
 	/* Attach to the common driver interface */
 	ret = brcmf_attach(0, dev);
-- 
1.7.10.4


