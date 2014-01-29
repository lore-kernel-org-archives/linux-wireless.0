Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-gw2-out.broadcom.com ([216.31.210.63]:63709 "EHLO
	mail-gw2-out.broadcom.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752538AbaA2Ocd (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 29 Jan 2014 09:32:33 -0500
From: Arend van Spriel <arend@broadcom.com>
To: "John W. Linville" <linville@tuxdriver.com>
CC: linux-wireless <linux-wireless@vger.kernel.org>,
	Arend van Spriel <arend@broadcom.com>
Subject: [PATCH 05/14] brcmfmac: rename sdio_chip.[ch]
Date: Wed, 29 Jan 2014 15:32:15 +0100
Message-ID: <1391005944-3220-6-git-send-email-arend@broadcom.com> (sfid-20140129_160006_692688_5DFA1EB3)
In-Reply-To: <1391005944-3220-1-git-send-email-arend@broadcom.com>
References: <1391005944-3220-1-git-send-email-arend@broadcom.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Just renaming the file. This file will contain chip related functions
that are independent of the host interface type.

Reviewed-by: Franky (Zhenhui) Lin <frankyl@broadcom.com>
Reviewed-by: Hante Meuleman <meuleman@broadcom.com>
Reviewed-by: Pieter-Paul Giesberts <pieterpg@broadcom.com>
Reviewed-by: Daniel (Deognyoun) Kim <dekim@broadcom.com>
Signed-off-by: Arend van Spriel <arend@broadcom.com>
---
 drivers/net/wireless/brcm80211/brcmfmac/Makefile                |    4 ++--
 drivers/net/wireless/brcm80211/brcmfmac/bcmsdh.c                |    1 -
 drivers/net/wireless/brcm80211/brcmfmac/{sdio_chip.c => chip.c} |    4 ++--
 drivers/net/wireless/brcm80211/brcmfmac/{sdio_chip.h => chip.h} |    0
 drivers/net/wireless/brcm80211/brcmfmac/dhd_sdio.c              |    2 +-
 5 files changed, 5 insertions(+), 6 deletions(-)
 rename drivers/net/wireless/brcm80211/brcmfmac/{sdio_chip.c => chip.c} (99%)
 rename drivers/net/wireless/brcm80211/brcmfmac/{sdio_chip.h => chip.h} (100%)

diff --git a/drivers/net/wireless/brcm80211/brcmfmac/Makefile b/drivers/net/wireless/brcm80211/brcmfmac/Makefile
index 57cddee..1d2ceac 100644
--- a/drivers/net/wireless/brcm80211/brcmfmac/Makefile
+++ b/drivers/net/wireless/brcm80211/brcmfmac/Makefile
@@ -24,6 +24,7 @@ ccflags-y += -D__CHECK_ENDIAN__
 obj-$(CONFIG_BRCMFMAC) += brcmfmac.o
 brcmfmac-objs += \
 		wl_cfg80211.o \
+		chip.o \
 		fwil.o \
 		fweh.o \
 		fwsignal.o \
@@ -36,8 +37,7 @@ brcmfmac-objs += \
 		btcoex.o
 brcmfmac-$(CONFIG_BRCMFMAC_SDIO) += \
 		dhd_sdio.o \
-		bcmsdh.o \
-		sdio_chip.o
+		bcmsdh.o
 brcmfmac-$(CONFIG_BRCMFMAC_USB) += \
 		usb.o
 brcmfmac-$(CONFIG_BRCMDBG) += \
diff --git a/drivers/net/wireless/brcm80211/brcmfmac/bcmsdh.c b/drivers/net/wireless/brcm80211/brcmfmac/bcmsdh.c
index 9eb6f78..5711fd6 100644
--- a/drivers/net/wireless/brcm80211/brcmfmac/bcmsdh.c
+++ b/drivers/net/wireless/brcm80211/brcmfmac/bcmsdh.c
@@ -43,7 +43,6 @@
 #include "dhd_bus.h"
 #include "dhd_dbg.h"
 #include "sdio_host.h"
-#include "sdio_chip.h"
 
 #define SDIOH_API_ACCESS_RETRY_LIMIT	2
 
diff --git a/drivers/net/wireless/brcm80211/brcmfmac/sdio_chip.c b/drivers/net/wireless/brcm80211/brcmfmac/chip.c
similarity index 99%
rename from drivers/net/wireless/brcm80211/brcmfmac/sdio_chip.c
rename to drivers/net/wireless/brcm80211/brcmfmac/chip.c
index 1ce8cb7..37fd44a 100644
--- a/drivers/net/wireless/brcm80211/brcmfmac/sdio_chip.c
+++ b/drivers/net/wireless/brcm80211/brcmfmac/chip.c
@@ -30,7 +30,7 @@
 #include <soc.h>
 #include "dhd_dbg.h"
 #include "sdio_host.h"
-#include "sdio_chip.h"
+#include "chip.h"
 
 /* chip core base & ramsize */
 /* bcm4329 */
@@ -127,7 +127,7 @@ brcmf_sdio_sb_iscoreup(struct brcmf_sdio_dev *sdiodev,
 				    NULL);
 	regdata &= (SSB_TMSLOW_RESET | SSB_TMSLOW_REJECT |
 		    SSB_IMSTATE_REJECT | SSB_TMSLOW_CLOCK);
-	return (SSB_TMSLOW_CLOCK == regdata);
+	return SSB_TMSLOW_CLOCK == regdata;
 }
 
 static bool
diff --git a/drivers/net/wireless/brcm80211/brcmfmac/sdio_chip.h b/drivers/net/wireless/brcm80211/brcmfmac/chip.h
similarity index 100%
rename from drivers/net/wireless/brcm80211/brcmfmac/sdio_chip.h
rename to drivers/net/wireless/brcm80211/brcmfmac/chip.h
diff --git a/drivers/net/wireless/brcm80211/brcmfmac/dhd_sdio.c b/drivers/net/wireless/brcm80211/brcmfmac/dhd_sdio.c
index 090ce18..d78fffb 100644
--- a/drivers/net/wireless/brcm80211/brcmfmac/dhd_sdio.c
+++ b/drivers/net/wireless/brcm80211/brcmfmac/dhd_sdio.c
@@ -40,7 +40,7 @@
 #include <brcm_hw_ids.h>
 #include <soc.h>
 #include "sdio_host.h"
-#include "sdio_chip.h"
+#include "chip.h"
 #include "nvram.h"
 
 #define DCMD_RESP_TIMEOUT  2000	/* In milli second */
-- 
1.7.10.4

