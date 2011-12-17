Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mms1.broadcom.com ([216.31.210.17]:2354 "EHLO mms1.broadcom.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1760960Ab1LQChb (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 16 Dec 2011 21:37:31 -0500
From: "Franky Lin" <frankyl@broadcom.com>
To: linville@tuxdriver.com
cc: linux-wireless@vger.kernel.org
Subject: [PATCH 26/30] brcm80211: fmac: abstract ctrl frames interface
 function pointers
Date: Fri, 16 Dec 2011 18:37:16 -0800
Message-ID: <1324089440-8957-27-git-send-email-frankyl@broadcom.com> (sfid-20111217_035944_969374_B0497EE1)
In-Reply-To: <1324089440-8957-1-git-send-email-frankyl@broadcom.com>
References: <1324089440-8957-1-git-send-email-frankyl@broadcom.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Abstract bus layer brcmf_bus_txctl/brcmf_bus_rxctl function
pointers for common layer. This patch is part of the fullmac bus
interface refactoring.

Reviewed-by: Pieter-Paul Giesberts <pieterpg@broadcom.com>
Reviewed-by: Arend van Spriel <arend@broadcom.com>
Reviewed-by: Alwin Beukers <alwin@broadcom.com>
Signed-off-by: Franky Lin <frankyl@broadcom.com>
---
 drivers/net/wireless/brcm80211/brcmfmac/dhd_bus.h  |   17 +++++------------
 drivers/net/wireless/brcm80211/brcmfmac/dhd_cdc.c  |    7 ++++---
 drivers/net/wireless/brcm80211/brcmfmac/dhd_sdio.c |    6 ++++--
 3 files changed, 13 insertions(+), 17 deletions(-)

diff --git a/drivers/net/wireless/brcm80211/brcmfmac/dhd_bus.h b/drivers/net/wireless/brcm80211/brcmfmac/dhd_bus.h
index d5e0ec3..ad9be24 100644
--- a/drivers/net/wireless/brcm80211/brcmfmac/dhd_bus.h
+++ b/drivers/net/wireless/brcm80211/brcmfmac/dhd_bus.h
@@ -55,6 +55,11 @@ struct brcmf_bus {
 	int (*brcmf_bus_init)(struct device *);
 	/* Send a data frame to the dongle.  Callee disposes of txp. */
 	int (*brcmf_bus_txdata)(struct device *, struct sk_buff *);
+	/* Send/receive a control message to/from the dongle.
+	 * Expects caller to enforce a single outstanding transaction.
+	 */
+	int (*brcmf_bus_txctl)(struct device *, unsigned char *, uint);
+	int (*brcmf_bus_rxctl)(struct device *, unsigned char *, uint);
 };
 
 /*
@@ -97,16 +102,4 @@ extern int brcmf_bus_start(struct device *dev);
 
 extern int brcmf_add_if(struct device *dev, int ifidx,
 			char *name, u8 *mac_addr);
-
-/*
- * Exported from brcmf bus module (brcmf_usb, brcmf_sdio)
- */
-/* Send/receive a control message to/from the dongle.
- * Expects caller to enforce a single outstanding transaction.
- */
-extern int
-brcmf_sdbrcm_bus_txctl(struct device *dev, unsigned char *msg, uint msglen);
-
-extern int
-brcmf_sdbrcm_bus_rxctl(struct device *dev, unsigned char *msg, uint msglen);
 #endif				/* _BRCMF_BUS_H_ */
diff --git a/drivers/net/wireless/brcm80211/brcmfmac/dhd_cdc.c b/drivers/net/wireless/brcm80211/brcmfmac/dhd_cdc.c
index 65c948e..ac8d1f4 100644
--- a/drivers/net/wireless/brcm80211/brcmfmac/dhd_cdc.c
+++ b/drivers/net/wireless/brcm80211/brcmfmac/dhd_cdc.c
@@ -117,8 +117,9 @@ static int brcmf_proto_cdc_msg(struct brcmf_pub *drvr)
 		len = CDC_MAX_MSG_SIZE;
 
 	/* Send request */
-	return brcmf_sdbrcm_bus_txctl(drvr->dev, (unsigned char *)&prot->msg,
-				      len);
+	return drvr->bus_if->brcmf_bus_txctl(drvr->dev,
+					     (unsigned char *)&prot->msg,
+					     len);
 }
 
 static int brcmf_proto_cdc_cmplt(struct brcmf_pub *drvr, u32 id, u32 len)
@@ -129,7 +130,7 @@ static int brcmf_proto_cdc_cmplt(struct brcmf_pub *drvr, u32 id, u32 len)
 	brcmf_dbg(TRACE, "Enter\n");
 
 	do {
-		ret = brcmf_sdbrcm_bus_rxctl(drvr->dev,
+		ret = drvr->bus_if->brcmf_bus_rxctl(drvr->dev,
 				(unsigned char *)&prot->msg,
 				len + sizeof(struct brcmf_proto_cdc_dcmd));
 		if (ret < 0)
diff --git a/drivers/net/wireless/brcm80211/brcmfmac/dhd_sdio.c b/drivers/net/wireless/brcm80211/brcmfmac/dhd_sdio.c
index 6a30950..800007f 100644
--- a/drivers/net/wireless/brcm80211/brcmfmac/dhd_sdio.c
+++ b/drivers/net/wireless/brcm80211/brcmfmac/dhd_sdio.c
@@ -2892,7 +2892,7 @@ static int brcmf_tx_frame(struct brcmf_sdio *bus, u8 *frame, u16 len)
 	return ret;
 }
 
-int
+static int
 brcmf_sdbrcm_bus_txctl(struct device *dev, unsigned char *msg, uint msglen)
 {
 	u8 *frame;
@@ -3010,7 +3010,7 @@ brcmf_sdbrcm_bus_txctl(struct device *dev, unsigned char *msg, uint msglen)
 	return ret ? -EIO : 0;
 }
 
-int
+static int
 brcmf_sdbrcm_bus_rxctl(struct device *dev, unsigned char *msg, uint msglen)
 {
 	int timeleft;
@@ -3956,6 +3956,8 @@ void *brcmf_sdbrcm_probe(u32 regsva, struct brcmf_sdio_dev *sdiodev)
 	bus->sdiodev->bus_if->brcmf_bus_stop = brcmf_sdbrcm_bus_stop;
 	bus->sdiodev->bus_if->brcmf_bus_init = brcmf_sdbrcm_bus_init;
 	bus->sdiodev->bus_if->brcmf_bus_txdata = brcmf_sdbrcm_bus_txdata;
+	bus->sdiodev->bus_if->brcmf_bus_txctl = brcmf_sdbrcm_bus_txctl;
+	bus->sdiodev->bus_if->brcmf_bus_rxctl = brcmf_sdbrcm_bus_rxctl;
 	/* Attach to the brcmf/OS/network interface */
 	ret = brcmf_attach(SDPCM_RESERVE, bus->sdiodev->dev);
 	if (ret != 0) {
-- 
1.7.5.4


