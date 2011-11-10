Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mms3.broadcom.com ([216.31.210.19]:1214 "EHLO MMS3.broadcom.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750814Ab1KJTaw (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 10 Nov 2011 14:30:52 -0500
From: "Arend van Spriel" <arend@broadcom.com>
To: linville@tuxdriver.com
cc: linux-wireless@vger.kernel.org,
	"Franky Lin" <frankyl@broadcom.com>,
	"Arend van Spriel" <arend@broadcom.com>
Subject: [PATCH 17/19] brcm80211: fmac: stop using hard coded
 firmware/nvram name
Date: Thu, 10 Nov 2011 20:30:32 +0100
Message-ID: <1320953434-16859-19-git-send-email-arend@broadcom.com> (sfid-20111110_203124_930897_3054CAC9)
In-Reply-To: <1320953434-16859-1-git-send-email-arend@broadcom.com>
References: <1320953434-16859-1-git-send-email-arend@broadcom.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Franky Lin <frankyl@broadcom.com>

The nvram file contains info for firmware which varies with different
hardware designs. Current nvram file in Linux firmware repository is
for a internal development board. It is not applicable for any exsisting
end-user product. Every device with a fullmac support wifi dongle
should have its own nvram file in the system. Similar rule can be applied
to the dongle firmware. This patch remove the hard coded firmware/nvram
name in the driver. The paths of firmware and nvram file must be
passed to the driver through module parameter during or configured
in kernel option.

Reviewed-by: Pieter-Paul Giesberts <pieterpg@broadcom.com>
Reviewed-by: Arend van Spriel <arend@broadcom.com
Signed-off-by: Franky Lin <frankyl@broadcom.com>
Signed-off-by: Arend van Spriel <arend@broadcom.com>
---
 drivers/net/wireless/brcm80211/Kconfig             |   14 +++++++++++
 drivers/net/wireless/brcm80211/brcmfmac/bcmchip.h  |   25 --------------------
 .../net/wireless/brcm80211/brcmfmac/dhd_linux.c    |    2 -
 drivers/net/wireless/brcm80211/brcmfmac/dhd_sdio.c |   19 +++++++--------
 4 files changed, 23 insertions(+), 37 deletions(-)
 delete mode 100644 drivers/net/wireless/brcm80211/brcmfmac/bcmchip.h

diff --git a/drivers/net/wireless/brcm80211/Kconfig b/drivers/net/wireless/brcm80211/Kconfig
index 2069fc8..a41d485 100644
--- a/drivers/net/wireless/brcm80211/Kconfig
+++ b/drivers/net/wireless/brcm80211/Kconfig
@@ -28,6 +28,20 @@ config BRCMFMAC
 	  wireless extensions subsystem.  If you choose to build a module,
 	  it'll be called brcmfmac.ko.
 
+config BRCMFMAC_FW_PATH
+	depends on BRCMFMAC
+	string "BRCMFMAC firmware path"
+	---help---
+	  Path to the firmware file for brcmfmac. It need to be in the format
+	  need to be recognized by system uevent helper.
+
+config BRCMFMAC_NV_PATH
+	depends on BRCMFMAC
+	string "BRCMFMAC nvram path"
+	---help---
+	  Path to the nvram file for brcmfmac. It need to be in the format
+	  need to be recognized by system uevent helper.
+
 config BRCMDBG
 	bool "Broadcom driver debug functions"
 	depends on BRCMSMAC || BRCMFMAC
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
index 719fd93..c7d0088 100644
--- a/drivers/net/wireless/brcm80211/brcmfmac/dhd_linux.c
+++ b/drivers/net/wireless/brcm80211/brcmfmac/dhd_linux.c
@@ -43,7 +43,6 @@
 #include "dhd_proto.h"
 #include "dhd_dbg.h"
 #include "wl_cfg80211.h"
-#include "bcmchip.h"
 
 MODULE_AUTHOR("Broadcom Corporation");
 MODULE_DESCRIPTION("Broadcom 802.11n wireless LAN fullmac driver.");
@@ -605,7 +604,6 @@ static void brcmf_ethtool_get_drvinfo(struct net_device *ndev,
 
 	sprintf(info->driver, KBUILD_MODNAME);
 	sprintf(info->version, "%lu", drvr_priv->pub.drv_version);
-	sprintf(info->fw_version, "%s", BCM4329_FW_NAME);
 	sprintf(info->bus_info, "%s",
 		dev_name(brcmf_bus_get_device(drvr_priv->pub.bus)));
 }
diff --git a/drivers/net/wireless/brcm80211/brcmfmac/dhd_sdio.c b/drivers/net/wireless/brcm80211/brcmfmac/dhd_sdio.c
index d8a521a..a7fc542 100644
--- a/drivers/net/wireless/brcm80211/brcmfmac/dhd_sdio.c
+++ b/drivers/net/wireless/brcm80211/brcmfmac/dhd_sdio.c
@@ -91,7 +91,6 @@ struct rte_console {
 #include "dhd_bus.h"
 #include "dhd_proto.h"
 #include "dhd_dbg.h"
-#include <bcmchip.h>
 
 #define TXQLEN		2048	/* bulk tx queue length */
 #define TXHI		(TXQLEN - 256)	/* turn on flow control above TXHI */
@@ -562,9 +561,7 @@ struct brcmf_bus {
 
 	struct semaphore sdsem;
 
-	const char *fw_name;
 	const struct firmware *firmware;
-	const char *nv_name;
 	u32 fw_ptr;
 };
 
@@ -579,6 +576,13 @@ static int qcount[NUMPRIO];
 static int tx_packets[NUMPRIO];
 #endif				/* BCMDBG */
 
+static char brcmf_fw_path[PATH_MAX] = CONFIG_BRCMFMAC_FW_PATH;
+static char brcmf_nv_path[PATH_MAX] = CONFIG_BRCMFMAC_NV_PATH;
+module_param_string(fw_path, brcmf_fw_path, PATH_MAX, 0440);
+MODULE_PARM_DESC(fw_path, "path to the firmware for wifi dongle");
+module_param_string(nv_path, brcmf_nv_path, PATH_MAX, 0440);
+MODULE_PARM_DESC(nv_path, "path to the nvram file for wifi dongle");
+
 #define SDIO_DRIVE_STRENGTH	6	/* in milliamps */
 
 #define RETRYCHAN(chan) ((chan) == SDPCM_EVENT_CHANNEL)
@@ -3165,9 +3169,6 @@ static int brcmf_sdbrcm_get_image(char *buf, int len, struct brcmf_bus *bus)
 	return len;
 }
 
-MODULE_FIRMWARE(BCM4329_FW_NAME);
-MODULE_FIRMWARE(BCM4329_NV_NAME);
-
 static int brcmf_sdbrcm_download_code_file(struct brcmf_bus *bus)
 {
 	int offset = 0;
@@ -3177,8 +3178,7 @@ static int brcmf_sdbrcm_download_code_file(struct brcmf_bus *bus)
 
 	brcmf_dbg(INFO, "Enter\n");
 
-	bus->fw_name = BCM4329_FW_NAME;
-	ret = request_firmware(&bus->firmware, bus->fw_name,
+	ret = request_firmware(&bus->firmware, brcmf_fw_path,
 			       &bus->sdiodev->func[2]->dev);
 	if (ret) {
 		brcmf_dbg(ERROR, "Fail to request firmware %d\n", ret);
@@ -3275,8 +3275,7 @@ static int brcmf_sdbrcm_download_nvram(struct brcmf_bus *bus)
 	char *bufp;
 	int ret;
 
-	bus->nv_name = BCM4329_NV_NAME;
-	ret = request_firmware(&bus->firmware, bus->nv_name,
+	ret = request_firmware(&bus->firmware, brcmf_nv_path,
 			       &bus->sdiodev->func[2]->dev);
 	if (ret) {
 		brcmf_dbg(ERROR, "Fail to request nvram %d\n", ret);
-- 
1.7.5.4


