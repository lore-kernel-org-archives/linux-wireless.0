Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mms2.broadcom.com ([216.31.210.18]:3784 "EHLO mms2.broadcom.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758821Ab1FALq3 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 1 Jun 2011 07:46:29 -0400
From: "Roland Vossen" <rvossen@broadcom.com>
To: gregkh@suse.de
cc: devel@linuxdriverproject.org, linux-wireless@vger.kernel.org
Subject: [PATCH 22/83] staging: brcm80211: removed 'hnd' from filenames
Date: Wed, 1 Jun 2011 13:45:07 +0200
Message-ID: <1306928768-7501-22-git-send-email-rvossen@broadcom.com> (sfid-20110601_134926_572336_90D90EC2)
In-Reply-To: <1306928768-7501-1-git-send-email-rvossen@broadcom.com>
References: <1306928768-7501-1-git-send-email-rvossen@broadcom.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Cleanup. 'hnd' is a company specific acronym.

Signed-off-by: Roland Vossen <rvossen@broadcom.com>
Reviewed-by: Arend van Spriel <arend@broadcom.com>
---
 drivers/staging/brcm80211/brcmfmac/bcmsdh.c        |    2 +-
 drivers/staging/brcm80211/brcmfmac/dhd_sdio.c      |    8 ++++----
 .../brcmfmac/{hndrte_armtrap.h => rte_armtrap.h}   |    0
 .../brcmfmac/{hndrte_cons.h => rte_cons.h}         |    0
 drivers/staging/brcm80211/brcmsmac/Makefile        |    2 +-
 drivers/staging/brcm80211/brcmsmac/aiutils.c       |    2 +-
 .../{include/hnddma.h => brcmsmac/bcmdma.h}        |    0
 drivers/staging/brcm80211/brcmsmac/bcmotp.c        |    2 +-
 drivers/staging/brcm80211/brcmsmac/bcmsrom.c       |    2 +-
 .../staging/brcm80211/brcmsmac/{hnddma.c => dma.c} |    6 +++---
 drivers/staging/brcm80211/brcmsmac/nicpci.c        |    2 +-
 drivers/staging/brcm80211/brcmsmac/nvram.c         |    2 +-
 .../staging/brcm80211/brcmsmac/phy/wlc_phy_cmn.c   |    2 +-
 .../staging/brcm80211/brcmsmac/phy/wlc_phy_lcn.c   |    2 +-
 drivers/staging/brcm80211/brcmsmac/phy/wlc_phy_n.c |    2 +-
 .../brcm80211/brcmsmac/phy/wlc_phytbl_lcn.c        |    2 +-
 .../staging/brcm80211/brcmsmac/phy/wlc_phytbl_n.c  |    2 +-
 drivers/staging/brcm80211/brcmsmac/wl_mac80211.c   |    2 +-
 drivers/staging/brcm80211/brcmsmac/wlc_alloc.c     |    2 +-
 drivers/staging/brcm80211/brcmsmac/wlc_ampdu.c     |    4 ++--
 drivers/staging/brcm80211/brcmsmac/wlc_antsel.c    |    2 +-
 drivers/staging/brcm80211/brcmsmac/wlc_bmac.c      |    4 ++--
 drivers/staging/brcm80211/brcmsmac/wlc_channel.c   |    2 +-
 drivers/staging/brcm80211/brcmsmac/wlc_main.c      |    4 ++--
 drivers/staging/brcm80211/brcmsmac/wlc_phy_shim.c  |    4 ++--
 drivers/staging/brcm80211/brcmsmac/wlc_rate.c      |    2 +-
 drivers/staging/brcm80211/brcmsmac/wlc_stf.c       |    2 +-
 .../brcm80211/include/{hndsoc.h => bcmsoc.h}       |    0
 .../brcm80211/include/{sbhnddma.h => sbdma.h}      |    0
 29 files changed, 33 insertions(+), 33 deletions(-)
 rename drivers/staging/brcm80211/brcmfmac/{hndrte_armtrap.h => rte_armtrap.h} (100%)
 rename drivers/staging/brcm80211/brcmfmac/{hndrte_cons.h => rte_cons.h} (100%)
 rename drivers/staging/brcm80211/{include/hnddma.h => brcmsmac/bcmdma.h} (100%)
 rename drivers/staging/brcm80211/brcmsmac/{hnddma.c => dma.c} (99%)
 rename drivers/staging/brcm80211/include/{hndsoc.h => bcmsoc.h} (100%)
 rename drivers/staging/brcm80211/include/{sbhnddma.h => sbdma.h} (100%)

diff --git a/drivers/staging/brcm80211/brcmfmac/bcmsdh.c b/drivers/staging/brcm80211/brcmfmac/bcmsdh.c
index 3750fcf..e11c615 100644
--- a/drivers/staging/brcm80211/brcmfmac/bcmsdh.c
+++ b/drivers/staging/brcm80211/brcmfmac/bcmsdh.c
@@ -21,7 +21,7 @@
 #include <bcmdefs.h>
 #include <bcmdevs.h>
 #include <bcmutils.h>
-#include <hndsoc.h>
+#include <bcmsoc.h>
 
 #include <bcmsdh.h>		/* BRCM API for SDIO
 			 clients (such as wl, dhd) */
diff --git a/drivers/staging/brcm80211/brcmfmac/dhd_sdio.c b/drivers/staging/brcm80211/brcmfmac/dhd_sdio.c
index 7b94613..9593cff 100644
--- a/drivers/staging/brcm80211/brcmfmac/dhd_sdio.c
+++ b/drivers/staging/brcm80211/brcmfmac/dhd_sdio.c
@@ -29,13 +29,13 @@
 #include <bcmutils.h>
 #include <bcmdevs.h>
 
-#include <hndsoc.h>
+#include <bcmsoc.h>
 #ifdef DHD_DEBUG
-#include <hndrte_armtrap.h>
-#include <hndrte_cons.h>
+#include <rte_armtrap.h>
+#include <rte_cons.h>
 #endif				/* DHD_DEBUG */
 #include <sbchipc.h>
-#include <sbhnddma.h>
+#include <sbdma.h>
 
 #include <sdio.h>
 #include <sbsdio.h>
diff --git a/drivers/staging/brcm80211/brcmfmac/hndrte_armtrap.h b/drivers/staging/brcm80211/brcmfmac/rte_armtrap.h
similarity index 100%
rename from drivers/staging/brcm80211/brcmfmac/hndrte_armtrap.h
rename to drivers/staging/brcm80211/brcmfmac/rte_armtrap.h
diff --git a/drivers/staging/brcm80211/brcmfmac/hndrte_cons.h b/drivers/staging/brcm80211/brcmfmac/rte_cons.h
similarity index 100%
rename from drivers/staging/brcm80211/brcmfmac/hndrte_cons.h
rename to drivers/staging/brcm80211/brcmfmac/rte_cons.h
diff --git a/drivers/staging/brcm80211/brcmsmac/Makefile b/drivers/staging/brcm80211/brcmsmac/Makefile
index 8d75fe1..4356a29 100644
--- a/drivers/staging/brcm80211/brcmsmac/Makefile
+++ b/drivers/staging/brcm80211/brcmsmac/Makefile
@@ -49,7 +49,7 @@ BRCMSMAC_OFILES := \
 	phy/wlc_phy_qmath.o \
 	bcmotp.o \
 	bcmsrom.o \
-	hnddma.o \
+	dma.o \
 	nicpci.o \
 	nvram.o
 
diff --git a/drivers/staging/brcm80211/brcmsmac/aiutils.c b/drivers/staging/brcm80211/brcmsmac/aiutils.c
index a61185f..73587b3 100644
--- a/drivers/staging/brcm80211/brcmsmac/aiutils.c
+++ b/drivers/staging/brcm80211/brcmsmac/aiutils.c
@@ -22,7 +22,7 @@
 #include <linux/pci.h>
 #include <bcmutils.h>
 #include <aiutils.h>
-#include <hndsoc.h>
+#include <bcmsoc.h>
 #include <sbchipc.h>
 #include <pcicfg.h>
 #include <bcmdevs.h>
diff --git a/drivers/staging/brcm80211/include/hnddma.h b/drivers/staging/brcm80211/brcmsmac/bcmdma.h
similarity index 100%
rename from drivers/staging/brcm80211/include/hnddma.h
rename to drivers/staging/brcm80211/brcmsmac/bcmdma.h
diff --git a/drivers/staging/brcm80211/brcmsmac/bcmotp.c b/drivers/staging/brcm80211/brcmsmac/bcmotp.c
index d09628b..f025641 100644
--- a/drivers/staging/brcm80211/brcmsmac/bcmotp.c
+++ b/drivers/staging/brcm80211/brcmsmac/bcmotp.c
@@ -25,7 +25,7 @@
 #include <bcmdevs.h>
 #include <bcmutils.h>
 #include <aiutils.h>
-#include <hndsoc.h>
+#include <bcmsoc.h>
 #include <sbchipc.h>
 #include <bcmotp.h>
 
diff --git a/drivers/staging/brcm80211/brcmsmac/bcmsrom.c b/drivers/staging/brcm80211/brcmsmac/bcmsrom.c
index bbfc642..9de10fe 100644
--- a/drivers/staging/brcm80211/brcmsmac/bcmsrom.c
+++ b/drivers/staging/brcm80211/brcmsmac/bcmsrom.c
@@ -21,7 +21,7 @@
 #include <linux/pci.h>
 #include <stdarg.h>
 #include <bcmutils.h>
-#include <hndsoc.h>
+#include <bcmsoc.h>
 #include <sbchipc.h>
 #include <bcmdevs.h>
 #include <pcicfg.h>
diff --git a/drivers/staging/brcm80211/brcmsmac/hnddma.c b/drivers/staging/brcm80211/brcmsmac/dma.c
similarity index 99%
rename from drivers/staging/brcm80211/brcmsmac/hnddma.c
rename to drivers/staging/brcm80211/brcmsmac/dma.c
index f607315..6fde51f 100644
--- a/drivers/staging/brcm80211/brcmsmac/hnddma.c
+++ b/drivers/staging/brcm80211/brcmsmac/dma.c
@@ -20,12 +20,12 @@
 #include <linux/pci.h>
 #include <bcmdefs.h>
 #include <bcmdevs.h>
-#include <hndsoc.h>
+#include <bcmsoc.h>
 #include <bcmutils.h>
 #include <aiutils.h>
 
-#include <sbhnddma.h>
-#include <hnddma.h>
+#include <sbdma.h>
+#include <bcmdma.h>
 
 #if defined(__mips__)
 #include <asm/addrspace.h>
diff --git a/drivers/staging/brcm80211/brcmsmac/nicpci.c b/drivers/staging/brcm80211/brcmsmac/nicpci.c
index 18b844a..51d56b6 100644
--- a/drivers/staging/brcm80211/brcmsmac/nicpci.c
+++ b/drivers/staging/brcm80211/brcmsmac/nicpci.c
@@ -21,7 +21,7 @@
 #include <bcmutils.h>
 #include <bcmnvram.h>
 #include <aiutils.h>
-#include <hndsoc.h>
+#include <bcmsoc.h>
 #include <bcmdevs.h>
 #include <sbchipc.h>
 #include <pci_core.h>
diff --git a/drivers/staging/brcm80211/brcmsmac/nvram.c b/drivers/staging/brcm80211/brcmsmac/nvram.c
index 085ec0b..65fee2f 100644
--- a/drivers/staging/brcm80211/brcmsmac/nvram.c
+++ b/drivers/staging/brcm80211/brcmsmac/nvram.c
@@ -21,7 +21,7 @@
 #include <bcmnvram.h>
 #include <sbchipc.h>
 #include <bcmdevs.h>
-#include <hndsoc.h>
+#include <bcmsoc.h>
 
 #define NVR_MSG(x)
 
diff --git a/drivers/staging/brcm80211/brcmsmac/phy/wlc_phy_cmn.c b/drivers/staging/brcm80211/brcmsmac/phy/wlc_phy_cmn.c
index 07a5bcb..22ba415 100644
--- a/drivers/staging/brcm80211/brcmsmac/phy/wlc_phy_cmn.c
+++ b/drivers/staging/brcm80211/brcmsmac/phy/wlc_phy_cmn.c
@@ -27,7 +27,7 @@
 #include <bcmnvram.h>
 #include <sbchipc.h>
 #include <bcmdevs.h>
-#include <sbhnddma.h>
+#include <sbdma.h>
 
 #include <wlc_phy_int.h>
 #include <wlc_phyreg_n.h>
diff --git a/drivers/staging/brcm80211/brcmsmac/phy/wlc_phy_lcn.c b/drivers/staging/brcm80211/brcmsmac/phy/wlc_phy_lcn.c
index b8864c5..b5ec9ae 100644
--- a/drivers/staging/brcm80211/brcmsmac/phy/wlc_phy_lcn.c
+++ b/drivers/staging/brcm80211/brcmsmac/phy/wlc_phy_lcn.c
@@ -25,7 +25,7 @@
 #include <bcmnvram.h>
 
 #include <bcmdevs.h>
-#include <sbhnddma.h>
+#include <sbdma.h>
 
 #include "wlc_phy_radio.h"
 #include "wlc_phy_int.h"
diff --git a/drivers/staging/brcm80211/brcmsmac/phy/wlc_phy_n.c b/drivers/staging/brcm80211/brcmsmac/phy/wlc_phy_n.c
index 7127509..123bd6a 100644
--- a/drivers/staging/brcm80211/brcmsmac/phy/wlc_phy_n.c
+++ b/drivers/staging/brcm80211/brcmsmac/phy/wlc_phy_n.c
@@ -25,7 +25,7 @@
 #include <wlc_pmu.h>
 
 #include <bcmdevs.h>
-#include <sbhnddma.h>
+#include <sbdma.h>
 
 #include <wlc_phy_radio.h>
 #include <wlc_phy_int.h>
diff --git a/drivers/staging/brcm80211/brcmsmac/phy/wlc_phytbl_lcn.c b/drivers/staging/brcm80211/brcmsmac/phy/wlc_phytbl_lcn.c
index 81c59b0..e9d8661 100644
--- a/drivers/staging/brcm80211/brcmsmac/phy/wlc_phytbl_lcn.c
+++ b/drivers/staging/brcm80211/brcmsmac/phy/wlc_phytbl_lcn.c
@@ -15,7 +15,7 @@
  */
 
 #include <linux/types.h>
-#include <sbhnddma.h>
+#include <sbdma.h>
 #include <wlc_phy_int.h>
 #include <wlc_phytbl_lcn.h>
 
diff --git a/drivers/staging/brcm80211/brcmsmac/phy/wlc_phytbl_n.c b/drivers/staging/brcm80211/brcmsmac/phy/wlc_phytbl_n.c
index 742df99..e4a15c4 100644
--- a/drivers/staging/brcm80211/brcmsmac/phy/wlc_phytbl_n.c
+++ b/drivers/staging/brcm80211/brcmsmac/phy/wlc_phytbl_n.c
@@ -16,7 +16,7 @@
 
 #include <linux/kernel.h>
 
-#include <sbhnddma.h>
+#include <sbdma.h>
 #include <wlc_phy_int.h>
 #include <wlc_phytbl_n.h>
 
diff --git a/drivers/staging/brcm80211/brcmsmac/wl_mac80211.c b/drivers/staging/brcm80211/brcmsmac/wl_mac80211.c
index 590d65b..f58272a 100644
--- a/drivers/staging/brcm80211/brcmsmac/wl_mac80211.c
+++ b/drivers/staging/brcm80211/brcmsmac/wl_mac80211.c
@@ -32,7 +32,7 @@
 #include <bcmutils.h>
 #include <bcmnvram.h>
 #include <pcicfg.h>
-#include <sbhnddma.h>
+#include <sbdma.h>
 
 #include "phy/wlc_phy_int.h"
 #include "d11.h"
diff --git a/drivers/staging/brcm80211/brcmsmac/wlc_alloc.c b/drivers/staging/brcm80211/brcmsmac/wlc_alloc.c
index 3b04e02..8a4875d 100644
--- a/drivers/staging/brcm80211/brcmsmac/wlc_alloc.c
+++ b/drivers/staging/brcm80211/brcmsmac/wlc_alloc.c
@@ -19,7 +19,7 @@
 #include <bcmdefs.h>
 #include <bcmutils.h>
 #include <aiutils.h>
-#include <sbhnddma.h>
+#include <sbdma.h>
 
 #include "d11.h"
 #include "wlc_types.h"
diff --git a/drivers/staging/brcm80211/brcmsmac/wlc_ampdu.c b/drivers/staging/brcm80211/brcmsmac/wlc_ampdu.c
index c83896b..53ca0ff 100644
--- a/drivers/staging/brcm80211/brcmsmac/wlc_ampdu.c
+++ b/drivers/staging/brcm80211/brcmsmac/wlc_ampdu.c
@@ -19,8 +19,8 @@
 #include <bcmdefs.h>
 #include <bcmutils.h>
 #include <aiutils.h>
-#include <sbhnddma.h>
-#include <hnddma.h>
+#include <sbdma.h>
+#include <bcmdma.h>
 #include <d11.h>
 
 #include "wlc_types.h"
diff --git a/drivers/staging/brcm80211/brcmsmac/wlc_antsel.c b/drivers/staging/brcm80211/brcmsmac/wlc_antsel.c
index efdc62a..d26a520 100644
--- a/drivers/staging/brcm80211/brcmsmac/wlc_antsel.c
+++ b/drivers/staging/brcm80211/brcmsmac/wlc_antsel.c
@@ -25,7 +25,7 @@
 #include <bcmnvram.h>
 #include <aiutils.h>
 #include <bcmdevs.h>
-#include <sbhnddma.h>
+#include <sbdma.h>
 
 #include "d11.h"
 #include "wlc_rate.h"
diff --git a/drivers/staging/brcm80211/brcmsmac/wlc_bmac.c b/drivers/staging/brcm80211/brcmsmac/wlc_bmac.c
index f98f0fd..492fb3e 100644
--- a/drivers/staging/brcm80211/brcmsmac/wlc_bmac.c
+++ b/drivers/staging/brcm80211/brcmsmac/wlc_bmac.c
@@ -33,8 +33,8 @@
 #include <sbconfig.h>
 #include <sbchipc.h>
 #include <pcicfg.h>
-#include <sbhnddma.h>
-#include <hnddma.h>
+#include <sbdma.h>
+#include <bcmdma.h>
 
 #include "wlc_types.h"
 #include "wlc_pmu.h"
diff --git a/drivers/staging/brcm80211/brcmsmac/wlc_channel.c b/drivers/staging/brcm80211/brcmsmac/wlc_channel.c
index 9e29339..0b980ac 100644
--- a/drivers/staging/brcm80211/brcmsmac/wlc_channel.c
+++ b/drivers/staging/brcm80211/brcmsmac/wlc_channel.c
@@ -23,7 +23,7 @@
 #include <bcmutils.h>
 #include <bcmnvram.h>
 #include <aiutils.h>
-#include <sbhnddma.h>
+#include <sbdma.h>
 
 #include "wlc_types.h"
 #include "d11.h"
diff --git a/drivers/staging/brcm80211/brcmsmac/wlc_main.c b/drivers/staging/brcm80211/brcmsmac/wlc_main.c
index 54b5b79..c63920c 100644
--- a/drivers/staging/brcm80211/brcmsmac/wlc_main.c
+++ b/drivers/staging/brcm80211/brcmsmac/wlc_main.c
@@ -27,8 +27,8 @@
 #include <aiutils.h>
 #include <pcicfg.h>
 #include <bcmsrom.h>
-#include <sbhnddma.h>
-#include <hnddma.h>
+#include <sbdma.h>
+#include <bcmdma.h>
 
 #include "wlc_pmu.h"
 #include "d11.h"
diff --git a/drivers/staging/brcm80211/brcmsmac/wlc_phy_shim.c b/drivers/staging/brcm80211/brcmsmac/wlc_phy_shim.c
index c33b61b..3a80706 100644
--- a/drivers/staging/brcm80211/brcmsmac/wlc_phy_shim.c
+++ b/drivers/staging/brcm80211/brcmsmac/wlc_phy_shim.c
@@ -33,8 +33,8 @@
 #include <sbconfig.h>
 #include <sbchipc.h>
 #include <pcicfg.h>
-#include <sbhnddma.h>
-#include <hnddma.h>
+#include <sbdma.h>
+#include <bcmdma.h>
 #include <wlc_pmu.h>
 
 #include "wlc_types.h"
diff --git a/drivers/staging/brcm80211/brcmsmac/wlc_rate.c b/drivers/staging/brcm80211/brcmsmac/wlc_rate.c
index 6c9574a..4b84cc1 100644
--- a/drivers/staging/brcm80211/brcmsmac/wlc_rate.c
+++ b/drivers/staging/brcm80211/brcmsmac/wlc_rate.c
@@ -20,7 +20,7 @@
 #include <bcmdefs.h>
 #include <bcmutils.h>
 #include <aiutils.h>
-#include <sbhnddma.h>
+#include <sbdma.h>
 
 #include "wlc_types.h"
 #include "d11.h"
diff --git a/drivers/staging/brcm80211/brcmsmac/wlc_stf.c b/drivers/staging/brcm80211/brcmsmac/wlc_stf.c
index ca1b8aa..cd051d9 100644
--- a/drivers/staging/brcm80211/brcmsmac/wlc_stf.c
+++ b/drivers/staging/brcm80211/brcmsmac/wlc_stf.c
@@ -24,7 +24,7 @@
 #include <aiutils.h>
 #include <bcmwifi.h>
 #include <bcmnvram.h>
-#include <sbhnddma.h>
+#include <sbdma.h>
 
 #include "wlc_types.h"
 #include "d11.h"
diff --git a/drivers/staging/brcm80211/include/hndsoc.h b/drivers/staging/brcm80211/include/bcmsoc.h
similarity index 100%
rename from drivers/staging/brcm80211/include/hndsoc.h
rename to drivers/staging/brcm80211/include/bcmsoc.h
diff --git a/drivers/staging/brcm80211/include/sbhnddma.h b/drivers/staging/brcm80211/include/sbdma.h
similarity index 100%
rename from drivers/staging/brcm80211/include/sbhnddma.h
rename to drivers/staging/brcm80211/include/sbdma.h
-- 
1.7.4.1


