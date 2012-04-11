Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mms3.broadcom.com ([216.31.210.19]:3448 "EHLO MMS3.broadcom.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755094Ab2DKJxa (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 11 Apr 2012 05:53:30 -0400
From: "Arend van Spriel" <arend@broadcom.com>
To: "John W. Linville" <linville@tuxdriver.com>
cc: "Linux Wireless List" <linux-wireless@vger.kernel.org>,
	"Arend van Spriel" <arend@broadcom.com>
Subject: [PATCH 3/9] brcm80211: fmac: register primary net device with
 device mac address
Date: Wed, 11 Apr 2012 11:52:45 +0200
Message-ID: <1334137971-3972-4-git-send-email-arend@broadcom.com> (sfid-20120411_115345_037656_8C686E6D)
In-Reply-To: <1334137971-3972-1-git-send-email-arend@broadcom.com>
References: <1334137971-3972-1-git-send-email-arend@broadcom.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

The primary net device was registered with a primary mac address and
upon IFUP it was set to match the actual mac address from the device.
This patch changes that and moves the brcmf_add_if() call to the common
part of the driver.

Reviewed-by: Pieter-Paul Giesberts <pieterpg@broadcom.com>
Reviewed-by: Franky (Zhenhui) Lin <frankyl@broadcom.com>
Signed-off-by: Arend van Spriel <arend@broadcom.com>
---
 .../net/wireless/brcm80211/brcmfmac/dhd_linux.c    |    5 +++++
 drivers/net/wireless/brcm80211/brcmfmac/dhd_sdio.c |    6 ------
 drivers/net/wireless/brcm80211/brcmfmac/usb.c      |    8 --------
 3 files changed, 5 insertions(+), 14 deletions(-)

diff --git a/drivers/net/wireless/brcm80211/brcmfmac/dhd_linux.c b/drivers/net/wireless/brcm80211/brcmfmac/dhd_linux.c
index 07836a8..00b6270 100644
--- a/drivers/net/wireless/brcm80211/brcmfmac/dhd_linux.c
+++ b/drivers/net/wireless/brcm80211/brcmfmac/dhd_linux.c
@@ -1073,6 +1073,11 @@ int brcmf_bus_start(struct device *dev)
 	if (ret < 0)
 		return ret;
 
+	/* add primary networking interface */
+	ret = brcmf_add_if(dev, 0, "wlan%d", drvr->mac);
+	if (ret < 0)
+		return ret;
+
 	/* signal bus ready */
 	bus_if->state = BRCMF_BUS_DATA;
 	return 0;
diff --git a/drivers/net/wireless/brcm80211/brcmfmac/dhd_sdio.c b/drivers/net/wireless/brcm80211/brcmfmac/dhd_sdio.c
index 2bf5dda..a83fbea 100644
--- a/drivers/net/wireless/brcm80211/brcmfmac/dhd_sdio.c
+++ b/drivers/net/wireless/brcm80211/brcmfmac/dhd_sdio.c
@@ -3948,12 +3948,6 @@ void *brcmf_sdbrcm_probe(u32 regsva, struct brcmf_sdio_dev *sdiodev)
 		}
 	}
 
-	/* add interface and open for business */
-	if (brcmf_add_if(bus->sdiodev->dev, 0, "wlan%d", NULL)) {
-		brcmf_dbg(ERROR, "Add primary net device interface failed!!\n");
-		goto fail;
-	}
-
 	return bus;
 
 fail:
diff --git a/drivers/net/wireless/brcm80211/brcmfmac/usb.c b/drivers/net/wireless/brcm80211/brcmfmac/usb.c
index 8236422..1d67ecf 100644
--- a/drivers/net/wireless/brcm80211/brcmfmac/usb.c
+++ b/drivers/net/wireless/brcm80211/brcmfmac/usb.c
@@ -1383,14 +1383,6 @@ static int brcmf_usb_probe_cb(struct device *dev, const char *desc,
 		goto fail;
 	}
 
-	/* add interface and open for business */
-	ret = brcmf_add_if(dev, 0, "wlan%d", NULL);
-	if (ret) {
-		brcmf_dbg(ERROR, "Add primary net device interface failed!!\n");
-		brcmf_detach(dev);
-		goto fail;
-	}
-
 	return 0;
 fail:
 	/* Release resources in reverse order */
-- 
1.7.5.4


