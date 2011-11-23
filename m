Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mms3.broadcom.com ([216.31.210.19]:1637 "EHLO MMS3.broadcom.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759511Ab1KWBWL (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 22 Nov 2011 20:22:11 -0500
From: "Franky Lin" <frankyl@broadcom.com>
To: linville@tuxdriver.com
cc: linux-wireless@vger.kernel.org
Subject: [PATCH 06/24] brcm80211: fmac: change firmware/nvram name to be
 more generic
Date: Tue, 22 Nov 2011 17:21:41 -0800
Message-ID: <1322011319-24863-7-git-send-email-frankyl@broadcom.com> (sfid-20111123_022300_940432_A153F292)
In-Reply-To: <1322011319-24863-1-git-send-email-frankyl@broadcom.com>
References: <1322011319-24863-1-git-send-email-frankyl@broadcom.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

The nvram file contains info for firmware which varies with different
hardware designs. Use more common firmware/nvram file names instead
of those in Linux firmware repository to avoid misunderstanding.

Signed-off-by: Franky Lin <frankyl@broadcom.com>
---
 drivers/net/wireless/brcm80211/brcmfmac/bcmchip.h  |   25 --------------------
 .../net/wireless/brcm80211/brcmfmac/dhd_linux.c    |    2 -
 drivers/net/wireless/brcm80211/brcmfmac/dhd_sdio.c |   17 +++++--------
 3 files changed, 7 insertions(+), 37 deletions(-)
 delete mode 100644 drivers/net/wireless/brcm80211/brcmfmac/bcmchip.h

diff --git a/drivers/net/wireless/brcm80211/brcmfmac/bcmchip.h b/drivers/net/wireless/brcm80211/brcmfmac/bcmchip.h
deleted file mode 100644
index cecb5e5..0000000
--- a/drivers/net/wireless/brcm80211/brcmfmac/bcmchip.h
+++ /dev/null
@@ -1,25 +0,0 @@
-/*
- * Copyright (c) 2011 Broadcom Corporation
- *
- * Permission to use, copy, modify, and/or distribute this software for any
- * purpose with or without fee is hereby granted, provided that the above
- * copyright notice and this permission notice appear in all copies.
- *
- * THE SOFTWARE IS PROVIDED "AS IS" AND THE AUTHOR DISCLAIMS ALL WARRANTIES
- * WITH REGARD TO THIS SOFTWARE INCLUDING ALL IMPLIED WARRANTIES OF
- * MERCHANTABILITY AND FITNESS. IN NO EVENT SHALL THE AUTHOR BE LIABLE FOR ANY
- * SPECIAL, DIRECT, INDIRECT, OR CONSEQUENTIAL DAMAGES OR ANY DAMAGES
- * WHATSOEVER RESULTING FROM LOSS OF USE, DATA OR PROFITS, WHETHER IN AN ACTION
- * OF CONTRACT, NEGLIGENCE OR OTHER TORTIOUS ACTION, ARISING OUT OF OR IN
- * CONNECTION WITH THE USE OR PERFORMANCE OF THIS SOFTWARE.
- */
-
-#ifndef _bcmchip_h_
-#define _bcmchip_h_
-
-/* bcm4329 */
-/* firmware name */
-#define BCM4329_FW_NAME			"brcm/bcm4329-fullmac-4.bin"
-#define BCM4329_NV_NAME			"brcm/bcm4329-fullmac-4.txt"
-
-#endif				/* _bcmchip_h_ */
diff --git a/drivers/net/wireless/brcm80211/brcmfmac/dhd_linux.c b/drivers/net/wireless/brcm80211/brcmfmac/dhd_linux.c
index 9721174..7af1413 100644
--- a/drivers/net/wireless/brcm80211/brcmfmac/dhd_linux.c
+++ b/drivers/net/wireless/brcm80211/brcmfmac/dhd_linux.c
@@ -43,7 +43,6 @@
 #include "dhd_proto.h"
 #include "dhd_dbg.h"
 #include "wl_cfg80211.h"
-#include "bcmchip.h"
 
 MODULE_AUTHOR("Broadcom Corporation");
 MODULE_DESCRIPTION("Broadcom 802.11n wireless LAN fullmac driver.");
@@ -600,7 +599,6 @@ static void brcmf_ethtool_get_drvinfo(struct net_device *ndev,
 
 	sprintf(info->driver, KBUILD_MODNAME);
 	sprintf(info->version, "%lu", drvr_priv->pub.drv_version);
-	sprintf(info->fw_version, "%s", BCM4329_FW_NAME);
 	sprintf(info->bus_info, "%s",
 		dev_name(brcmf_bus_get_device(drvr_priv->pub.bus)));
 }
diff --git a/drivers/net/wireless/brcm80211/brcmfmac/dhd_sdio.c b/drivers/net/wireless/brcm80211/brcmfmac/dhd_sdio.c
index a9b8272..1f3e319 100644
--- a/drivers/net/wireless/brcm80211/brcmfmac/dhd_sdio.c
+++ b/drivers/net/wireless/brcm80211/brcmfmac/dhd_sdio.c
@@ -91,7 +91,6 @@ struct rte_console {
 #include "dhd_bus.h"
 #include "dhd_proto.h"
 #include "dhd_dbg.h"
-#include <bcmchip.h>
 
 #define TXQLEN		2048	/* bulk tx queue length */
 #define TXHI		(TXQLEN - 256)	/* turn on flow control above TXHI */
@@ -310,6 +309,11 @@ struct rte_console {
 /* Flags for SDH calls */
 #define F2SYNC	(SDIO_REQ_4BYTE | SDIO_REQ_FIXED)
 
+#define BRCMFMAC_FW_NAME	"brcm/brcmfmac.bin"
+#define BRCMFMAC_NV_NAME	"brcm/brcmfmac.txt"
+MODULE_FIRMWARE(BRCMFMAC_FW_NAME);
+MODULE_FIRMWARE(BRCMFMAC_NV_NAME);
+
 /*
  * Conversion of 802.1D priority to precedence level
  */
@@ -562,9 +566,7 @@ struct brcmf_bus {
 
 	struct semaphore sdsem;
 
-	const char *fw_name;
 	const struct firmware *firmware;
-	const char *nv_name;
 	u32 fw_ptr;
 };
 
@@ -3125,9 +3127,6 @@ static int brcmf_sdbrcm_get_image(char *buf, int len, struct brcmf_bus *bus)
 	return len;
 }
 
-MODULE_FIRMWARE(BCM4329_FW_NAME);
-MODULE_FIRMWARE(BCM4329_NV_NAME);
-
 static int brcmf_sdbrcm_download_code_file(struct brcmf_bus *bus)
 {
 	int offset = 0;
@@ -3137,8 +3136,7 @@ static int brcmf_sdbrcm_download_code_file(struct brcmf_bus *bus)
 
 	brcmf_dbg(INFO, "Enter\n");
 
-	bus->fw_name = BCM4329_FW_NAME;
-	ret = request_firmware(&bus->firmware, bus->fw_name,
+	ret = request_firmware(&bus->firmware, BRCMFMAC_FW_NAME,
 			       &bus->sdiodev->func[2]->dev);
 	if (ret) {
 		brcmf_dbg(ERROR, "Fail to request firmware %d\n", ret);
@@ -3235,8 +3233,7 @@ static int brcmf_sdbrcm_download_nvram(struct brcmf_bus *bus)
 	char *bufp;
 	int ret;
 
-	bus->nv_name = BCM4329_NV_NAME;
-	ret = request_firmware(&bus->firmware, bus->nv_name,
+	ret = request_firmware(&bus->firmware, BRCMFMAC_NV_NAME,
 			       &bus->sdiodev->func[2]->dev);
 	if (ret) {
 		brcmf_dbg(ERROR, "Fail to request nvram %d\n", ret);
-- 
1.7.5.4


