Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mms1.broadcom.com ([216.31.210.17]:3969 "EHLO mms1.broadcom.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757882Ab2BIUJ1 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 9 Feb 2012 15:09:27 -0500
From: "Arend van Spriel" <arend@broadcom.com>
To: linville@tuxdriver.com
cc: linux-wireless@vger.kernel.org,
	"Arend van Spriel" <arend@broadcom.com>
Subject: [PATCH 08/15] brcm80211: fmac: use specific types in struct
 brcmf_bus
Date: Thu, 9 Feb 2012 21:09:02 +0100
Message-ID: <1328818149-4826-9-git-send-email-arend@broadcom.com> (sfid-20120209_211004_325909_8E5CB9D5)
In-Reply-To: <1328818149-4826-1-git-send-email-arend@broadcom.com>
References: <1328818149-4826-1-git-send-email-arend@broadcom.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

The fields bus_priv and drvr are defined as void pointer. It is
preferred to have specific types for compiler type checking. To
prepare for other bus types the bus_priv field is defined as a
union containing the sdio bus private structure reference.

Reviewed-by: Pieter-Paul Giesberts <pieterpg@broadcom.com>
Reviewed-by: Franky (Zhenhui) Lin <frankyl@broadcom.com>
Signed-off-by: Arend van Spriel <arend@broadcom.com>
---
 .../net/wireless/brcm80211/brcmfmac/bcmsdh_sdmmc.c |    4 ++--
 drivers/net/wireless/brcm80211/brcmfmac/dhd_bus.h  |    7 +++++--
 drivers/net/wireless/brcm80211/brcmfmac/dhd_sdio.c |   10 +++++-----
 3 files changed, 12 insertions(+), 9 deletions(-)

diff --git a/drivers/net/wireless/brcm80211/brcmfmac/bcmsdh_sdmmc.c b/drivers/net/wireless/brcm80211/brcmfmac/bcmsdh_sdmmc.c
index b698a76..1d2b74d 100644
--- a/drivers/net/wireless/brcm80211/brcmfmac/bcmsdh_sdmmc.c
+++ b/drivers/net/wireless/brcm80211/brcmfmac/bcmsdh_sdmmc.c
@@ -489,7 +489,7 @@ static int brcmf_ops_sdio_probe(struct sdio_func *func,
 		sdiodev->func[0] = func->card->sdio_func[0];
 		sdiodev->func[1] = func;
 		sdiodev->bus_if = bus_if;
-		bus_if->bus_priv = sdiodev;
+		bus_if->bus_priv.sdio = sdiodev;
 		bus_if->type = SDIO_BUS;
 		bus_if->align = BRCMF_SDALIGN;
 		dev_set_drvdata(&func->card->dev, sdiodev);
@@ -530,7 +530,7 @@ static void brcmf_ops_sdio_remove(struct sdio_func *func)
 
 	if (func->num == 2) {
 		bus_if = dev_get_drvdata(&func->dev);
-		sdiodev = bus_if->bus_priv;
+		sdiodev = bus_if->bus_priv.sdio;
 		brcmf_dbg(TRACE, "F2 found, calling brcmf_sdio_remove...\n");
 		brcmf_sdio_remove(sdiodev);
 		dev_set_drvdata(&func->card->dev, NULL);
diff --git a/drivers/net/wireless/brcm80211/brcmfmac/dhd_bus.h b/drivers/net/wireless/brcm80211/brcmfmac/dhd_bus.h
index ad9be24..567a966 100644
--- a/drivers/net/wireless/brcm80211/brcmfmac/dhd_bus.h
+++ b/drivers/net/wireless/brcm80211/brcmfmac/dhd_bus.h
@@ -39,8 +39,11 @@ struct dngl_stats {
 /* interface structure between common and bus layer */
 struct brcmf_bus {
 	u8 type;		/* bus type */
-	void *bus_priv;		/* pointer to bus private structure */
-	void *drvr;		/* pointer to driver pub structure brcmf_pub */
+	union {
+		/* pointer to sdio private structure */
+		struct brcmf_sdio_dev *sdio;
+	} bus_priv;
+	struct brcmf_pub *drvr;	/* pointer to driver pub structure brcmf_pub */
 	enum brcmf_bus_state state;
 	uint maxctl;		/* Max size rxctl request from proto to bus */
 	bool drvr_up;		/* Status flag of driver up/down */
diff --git a/drivers/net/wireless/brcm80211/brcmfmac/dhd_sdio.c b/drivers/net/wireless/brcm80211/brcmfmac/dhd_sdio.c
index 6e4b5e8..b20029e 100644
--- a/drivers/net/wireless/brcm80211/brcmfmac/dhd_sdio.c
+++ b/drivers/net/wireless/brcm80211/brcmfmac/dhd_sdio.c
@@ -2277,7 +2277,7 @@ static void brcmf_sdbrcm_bus_stop(struct device *dev)
 	uint retries;
 	int err;
 	struct brcmf_bus *bus_if = dev_get_drvdata(dev);
-	struct brcmf_sdio_dev *sdiodev = bus_if->bus_priv;
+	struct brcmf_sdio_dev *sdiodev = bus_if->bus_priv.sdio;
 	struct brcmf_sdio *bus = sdiodev->bus;
 
 	brcmf_dbg(TRACE, "Enter\n");
@@ -2627,7 +2627,7 @@ static int brcmf_sdbrcm_bus_txdata(struct device *dev, struct sk_buff *pkt)
 	int ret = -EBADE;
 	uint datalen, prec;
 	struct brcmf_bus *bus_if = dev_get_drvdata(dev);
-	struct brcmf_sdio_dev *sdiodev = bus_if->bus_priv;
+	struct brcmf_sdio_dev *sdiodev = bus_if->bus_priv.sdio;
 	struct brcmf_sdio *bus = sdiodev->bus;
 
 	brcmf_dbg(TRACE, "Enter\n");
@@ -2869,7 +2869,7 @@ brcmf_sdbrcm_bus_txctl(struct device *dev, unsigned char *msg, uint msglen)
 	u8 doff = 0;
 	int ret = -1;
 	struct brcmf_bus *bus_if = dev_get_drvdata(dev);
-	struct brcmf_sdio_dev *sdiodev = bus_if->bus_priv;
+	struct brcmf_sdio_dev *sdiodev = bus_if->bus_priv.sdio;
 	struct brcmf_sdio *bus = sdiodev->bus;
 
 	brcmf_dbg(TRACE, "Enter\n");
@@ -2978,7 +2978,7 @@ brcmf_sdbrcm_bus_rxctl(struct device *dev, unsigned char *msg, uint msglen)
 	uint rxlen = 0;
 	bool pending;
 	struct brcmf_bus *bus_if = dev_get_drvdata(dev);
-	struct brcmf_sdio_dev *sdiodev = bus_if->bus_priv;
+	struct brcmf_sdio_dev *sdiodev = bus_if->bus_priv.sdio;
 	struct brcmf_sdio *bus = sdiodev->bus;
 
 	brcmf_dbg(TRACE, "Enter\n");
@@ -3389,7 +3389,7 @@ brcmf_sdbrcm_download_firmware(struct brcmf_sdio *bus)
 static int brcmf_sdbrcm_bus_init(struct device *dev)
 {
 	struct brcmf_bus *bus_if = dev_get_drvdata(dev);
-	struct brcmf_sdio_dev *sdiodev = bus_if->bus_priv;
+	struct brcmf_sdio_dev *sdiodev = bus_if->bus_priv.sdio;
 	struct brcmf_sdio *bus = sdiodev->bus;
 	unsigned long timeout;
 	uint retries = 0;
-- 
1.7.5.4


