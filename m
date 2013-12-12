Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-gw1-out.broadcom.com ([216.31.210.62]:61735 "EHLO
	mail-gw1-out.broadcom.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751519Ab3LLK7P (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 12 Dec 2013 05:59:15 -0500
From: Arend van Spriel <arend@broadcom.com>
To: "John W. Linville" <linville@tuxdriver.com>
CC: linux-wireless <linux-wireless@vger.kernel.org>,
	Hante Meuleman <meuleman@broadcom.com>,
	Arend van Spriel <arend@broadcom.com>
Subject: [PATCH 14/18] brcmfmac: Add definition of new protocol layer msgbuf.
Date: Thu, 12 Dec 2013 11:59:02 +0100
Message-ID: <1386845946-9859-15-git-send-email-arend@broadcom.com> (sfid-20131212_115924_355628_B7504C14)
In-Reply-To: <1386845946-9859-1-git-send-email-arend@broadcom.com>
References: <1386845946-9859-1-git-send-email-arend@broadcom.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Hante Meuleman <meuleman@broadcom.com>

A new protocol layer msgbuf will be added in the future. This
change makes it possible to select the desired layer by the
bus driver. USB and SDIO will select BCDC. At the moment
nothing is being done with this information.

Reviewed-by: Arend Van Spriel <arend@broadcom.com>
Reviewed-by: Franky (Zhenhui) Lin <frankyl@broadcom.com>
Reviewed-by: Pieter-Paul Giesberts <pieterpg@broadcom.com>
Signed-off-by: Hante Meuleman <meuleman@broadcom.com>
Signed-off-by: Arend van Spriel <arend@broadcom.com>
---
 drivers/net/wireless/brcm80211/brcmfmac/bcmsdh.c  |    1 +
 drivers/net/wireless/brcm80211/brcmfmac/dhd_bus.h |    8 ++++++++
 drivers/net/wireless/brcm80211/brcmfmac/usb.c     |    1 +
 3 files changed, 10 insertions(+)

diff --git a/drivers/net/wireless/brcm80211/brcmfmac/bcmsdh.c b/drivers/net/wireless/brcm80211/brcmfmac/bcmsdh.c
index 5ff34e6..9c41438 100644
--- a/drivers/net/wireless/brcm80211/brcmfmac/bcmsdh.c
+++ b/drivers/net/wireless/brcm80211/brcmfmac/bcmsdh.c
@@ -1036,6 +1036,7 @@ static int brcmf_ops_sdio_probe(struct sdio_func *func,
 
 	sdiodev->bus_if = bus_if;
 	bus_if->bus_priv.sdio = sdiodev;
+	bus_if->proto_type = BRCMF_PROTO_BCDC;
 	dev_set_drvdata(&func->dev, bus_if);
 	dev_set_drvdata(&sdiodev->func[1]->dev, bus_if);
 	sdiodev->dev = &sdiodev->func[1]->dev;
diff --git a/drivers/net/wireless/brcm80211/brcmfmac/dhd_bus.h b/drivers/net/wireless/brcm80211/brcmfmac/dhd_bus.h
index 6a54905..5c12a076 100644
--- a/drivers/net/wireless/brcm80211/brcmfmac/dhd_bus.h
+++ b/drivers/net/wireless/brcm80211/brcmfmac/dhd_bus.h
@@ -24,6 +24,12 @@ enum brcmf_bus_state {
 	BRCMF_BUS_DATA		/* Ready for frame transfers */
 };
 
+/* The level of bus communication with the dongle */
+enum brcmf_bus_protocol_type {
+	BRCMF_PROTO_BCDC,
+	BRCMF_PROTO_MSGBUF
+};
+
 struct brcmf_bus_dcmd {
 	char *name;
 	char *param;
@@ -65,6 +71,7 @@ struct brcmf_bus_ops {
  * struct brcmf_bus - interface structure between common and bus layer
  *
  * @bus_priv: pointer to private bus device.
+ * @proto_type: protocol type, bcdc or msgbuf
  * @dev: device pointer of bus device.
  * @drvr: public driver information.
  * @state: operational state of the bus interface.
@@ -80,6 +87,7 @@ struct brcmf_bus {
 		struct brcmf_sdio_dev *sdio;
 		struct brcmf_usbdev *usb;
 	} bus_priv;
+	enum brcmf_bus_protocol_type proto_type;
 	struct device *dev;
 	struct brcmf_pub *drvr;
 	enum brcmf_bus_state state;
diff --git a/drivers/net/wireless/brcm80211/brcmfmac/usb.c b/drivers/net/wireless/brcm80211/brcmfmac/usb.c
index 51c4de0..c345c32 100644
--- a/drivers/net/wireless/brcm80211/brcmfmac/usb.c
+++ b/drivers/net/wireless/brcm80211/brcmfmac/usb.c
@@ -1253,6 +1253,7 @@ static int brcmf_usb_probe_cb(struct brcmf_usbdev_info *devinfo)
 	bus->ops = &brcmf_usb_bus_ops;
 	bus->chip = bus_pub->devid;
 	bus->chiprev = bus_pub->chiprev;
+	bus->proto_type = BRCMF_PROTO_BCDC;
 
 	/* Attach to the common driver interface */
 	ret = brcmf_attach(dev);
-- 
1.7.10.4

