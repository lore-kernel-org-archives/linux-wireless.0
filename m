Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mms1.broadcom.com ([216.31.210.17]:2334 "EHLO mms1.broadcom.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1760821Ab1LQChb (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 16 Dec 2011 21:37:31 -0500
From: "Franky Lin" <frankyl@broadcom.com>
To: linville@tuxdriver.com
cc: linux-wireless@vger.kernel.org
Subject: [PATCH 29/30] brcm80211: fmac: exclude unnecessary header files
Date: Fri, 16 Dec 2011 18:37:19 -0800
Message-ID: <1324089440-8957-30-git-send-email-frankyl@broadcom.com> (sfid-20111217_033737_374487_BFE73FB7)
In-Reply-To: <1324089440-8957-1-git-send-email-frankyl@broadcom.com>
References: <1324089440-8957-1-git-send-email-frankyl@broadcom.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This patch removes some headers files include lines from sdio layer
code. This is part of the fullmac bus interface refactoring.

Reviewed-by: Pieter-Paul Giesberts <pieterpg@broadcom.com>
Reviewed-by: Arend van Spriel <arend@broadcom.com>
Reviewed-by: Alwin Beukers <alwin@broadcom.com>
Signed-off-by: Franky Lin <frankyl@broadcom.com>
---
 drivers/net/wireless/brcm80211/brcmfmac/bcmsdh.c   |    1 -
 .../net/wireless/brcm80211/brcmfmac/bcmsdh_sdmmc.c |    2 --
 drivers/net/wireless/brcm80211/brcmfmac/dhd_sdio.c |    2 --
 .../net/wireless/brcm80211/brcmfmac/sdio_chip.c    |    1 -
 4 files changed, 0 insertions(+), 6 deletions(-)

diff --git a/drivers/net/wireless/brcm80211/brcmfmac/bcmsdh.c b/drivers/net/wireless/brcm80211/brcmfmac/bcmsdh.c
index 32d72a0..4bc8d25 100644
--- a/drivers/net/wireless/brcm80211/brcmfmac/bcmsdh.c
+++ b/drivers/net/wireless/brcm80211/brcmfmac/bcmsdh.c
@@ -31,7 +31,6 @@
 #include <brcmu_utils.h>
 #include <brcmu_wifi.h>
 #include <soc.h>
-#include "dhd.h"
 #include "dhd_bus.h"
 #include "dhd_dbg.h"
 #include "sdio_host.h"
diff --git a/drivers/net/wireless/brcm80211/brcmfmac/bcmsdh_sdmmc.c b/drivers/net/wireless/brcm80211/brcmfmac/bcmsdh_sdmmc.c
index f17c818..9b8c0ed 100644
--- a/drivers/net/wireless/brcm80211/brcmfmac/bcmsdh_sdmmc.c
+++ b/drivers/net/wireless/brcm80211/brcmfmac/bcmsdh_sdmmc.c
@@ -31,9 +31,7 @@
 #include <brcmu_utils.h>
 #include <brcmu_wifi.h>
 #include "sdio_host.h"
-#include "dhd.h"
 #include "dhd_dbg.h"
-#include "wl_cfg80211.h"
 #include "dhd_bus.h"
 
 #define SDIO_VENDOR_ID_BROADCOM		0x02d0
diff --git a/drivers/net/wireless/brcm80211/brcmfmac/dhd_sdio.c b/drivers/net/wireless/brcm80211/brcmfmac/dhd_sdio.c
index a8e7ca5..5a002a2 100644
--- a/drivers/net/wireless/brcm80211/brcmfmac/dhd_sdio.c
+++ b/drivers/net/wireless/brcm80211/brcmfmac/dhd_sdio.c
@@ -87,9 +87,7 @@ struct rte_console {
 #endif				/* BCMDBG */
 #include <chipcommon.h>
 
-#include "dhd.h"
 #include "dhd_bus.h"
-#include "dhd_proto.h"
 #include "dhd_dbg.h"
 
 #define TXQLEN		2048	/* bulk tx queue length */
diff --git a/drivers/net/wireless/brcm80211/brcmfmac/sdio_chip.c b/drivers/net/wireless/brcm80211/brcmfmac/sdio_chip.c
index a6048d7..11b2d7c 100644
--- a/drivers/net/wireless/brcm80211/brcmfmac/sdio_chip.c
+++ b/drivers/net/wireless/brcm80211/brcmfmac/sdio_chip.c
@@ -26,7 +26,6 @@
 #include <brcmu_wifi.h>
 #include <brcmu_utils.h>
 #include <soc.h>
-#include "dhd.h"
 #include "dhd_dbg.h"
 #include "sdio_host.h"
 #include "sdio_chip.h"
-- 
1.7.5.4


