Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-gw3-out.broadcom.com ([216.31.210.64]:6410 "EHLO
	mail-gw3-out.broadcom.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754638AbaAFLk7 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 6 Jan 2014 06:40:59 -0500
From: Arend van Spriel <arend@broadcom.com>
To: "John W. Linville" <linville@tuxdriver.com>
CC: linux-wireless <linux-wireless@vger.kernel.org>,
	Arend van Spriel <arend@broadcom.com>
Subject: [PATCH 15/15] mmc: add SDIO identifiers for Broadcom WLAN devices
Date: Mon, 6 Jan 2014 12:40:50 +0100
Message-ID: <1389008450-28529-16-git-send-email-arend@broadcom.com> (sfid-20140106_124134_241030_4FF37BD1)
In-Reply-To: <1389008450-28529-1-git-send-email-arend@broadcom.com>
References: <1389008450-28529-1-git-send-email-arend@broadcom.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

The SDIO identifier for Broadcom WLAN devices were defined in the
brcmfmac SDIO driver. Moving the definitions in MMC header file
seems common sense.

Reviewed-by: Hante Meuleman <meuleman@broadcom.com>
Reviewed-by: Pieter-Paul Giesberts <pieterpg@broadcom.com>
Signed-off-by: Arend van Spriel <arend@broadcom.com>
---
 drivers/net/wireless/brcm80211/brcmfmac/bcmsdh.c    |    2 --
 drivers/net/wireless/brcm80211/brcmfmac/sdio_chip.c |    1 +
 drivers/net/wireless/brcm80211/brcmfmac/sdio_chip.h |    8 --------
 include/linux/mmc/sdio_ids.h                        |    9 +++++++++
 4 files changed, 10 insertions(+), 10 deletions(-)

diff --git a/drivers/net/wireless/brcm80211/brcmfmac/bcmsdh.c b/drivers/net/wireless/brcm80211/brcmfmac/bcmsdh.c
index 07015e1..68dd999 100644
--- a/drivers/net/wireless/brcm80211/brcmfmac/bcmsdh.c
+++ b/drivers/net/wireless/brcm80211/brcmfmac/bcmsdh.c
@@ -47,8 +47,6 @@
 
 #define SDIOH_API_ACCESS_RETRY_LIMIT	2
 
-#define SDIO_VENDOR_ID_BROADCOM		0x02d0
-
 #define DMA_ALIGN_MASK	0x03
 
 #define SDIO_FUNC1_BLOCKSIZE		64
diff --git a/drivers/net/wireless/brcm80211/brcmfmac/sdio_chip.c b/drivers/net/wireless/brcm80211/brcmfmac/sdio_chip.c
index 6aa6ba0..a0b8409 100644
--- a/drivers/net/wireless/brcm80211/brcmfmac/sdio_chip.c
+++ b/drivers/net/wireless/brcm80211/brcmfmac/sdio_chip.c
@@ -19,6 +19,7 @@
 #include <linux/netdevice.h>
 #include <linux/mmc/card.h>
 #include <linux/mmc/sdio_func.h>
+#include <linux/mmc/sdio_ids.h>
 #include <linux/ssb/ssb_regs.h>
 #include <linux/bcma/bcma.h>
 
diff --git a/drivers/net/wireless/brcm80211/brcmfmac/sdio_chip.h b/drivers/net/wireless/brcm80211/brcmfmac/sdio_chip.h
index d0f4b45..7ea424e 100644
--- a/drivers/net/wireless/brcm80211/brcmfmac/sdio_chip.h
+++ b/drivers/net/wireless/brcm80211/brcmfmac/sdio_chip.h
@@ -54,14 +54,6 @@
 
 #define BRCMF_MAX_CORENUM	6
 
-/* SDIO device ID */
-#define SDIO_DEVICE_ID_BROADCOM_43143		43143
-#define SDIO_DEVICE_ID_BROADCOM_43241		0x4324
-#define SDIO_DEVICE_ID_BROADCOM_4329		0x4329
-#define SDIO_DEVICE_ID_BROADCOM_4330		0x4330
-#define SDIO_DEVICE_ID_BROADCOM_4334		0x4334
-#define SDIO_DEVICE_ID_BROADCOM_4335_4339	0x4335
-
 struct chip_core_info {
 	u16 id;
 	u16 rev;
diff --git a/include/linux/mmc/sdio_ids.h b/include/linux/mmc/sdio_ids.h
index 9f03fee..d883662 100644
--- a/include/linux/mmc/sdio_ids.h
+++ b/include/linux/mmc/sdio_ids.h
@@ -23,6 +23,15 @@
 /*
  * Vendors and devices.  Sort key: vendor first, device next.
  */
+#define SDIO_VENDOR_ID_BROADCOM			0x02d0
+#define SDIO_DEVICE_ID_BROADCOM_43143		43143
+#define SDIO_DEVICE_ID_BROADCOM_43241		0x4324
+#define SDIO_DEVICE_ID_BROADCOM_4329		0x4329
+#define SDIO_DEVICE_ID_BROADCOM_4330		0x4330
+#define SDIO_DEVICE_ID_BROADCOM_4334		0x4334
+#define SDIO_DEVICE_ID_BROADCOM_4335_4339	0x4335
+#define SDIO_DEVICE_ID_BROADCOM_43362		43362
+
 #define SDIO_VENDOR_ID_INTEL			0x0089
 #define SDIO_DEVICE_ID_INTEL_IWMC3200WIMAX	0x1402
 #define SDIO_DEVICE_ID_INTEL_IWMC3200WIFI	0x1403
-- 
1.7.10.4

