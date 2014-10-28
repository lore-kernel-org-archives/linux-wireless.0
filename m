Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-gw3-out.broadcom.com ([216.31.210.64]:22845 "EHLO
	mail-gw3-out.broadcom.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753418AbaJ1OA0 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 28 Oct 2014 10:00:26 -0400
From: Arend van Spriel <arend@broadcom.com>
To: "John W. Linville" <linville@tuxdriver.com>
CC: linux-wireless <linux-wireless@vger.kernel.org>,
	Hante Meuleman <meuleman@broadcom.com>,
	Arend van Spriel <arend@broadcom.com>
Subject: [PATCH 11/16] brcmfmac: (clean) Rename dhd_bus.h in bus.h
Date: Tue, 28 Oct 2014 14:56:14 +0100
Message-ID: <1414504579-12562-12-git-send-email-arend@broadcom.com> (sfid-20141028_150032_670086_7C828843)
In-Reply-To: <1414504579-12562-1-git-send-email-arend@broadcom.com>
References: <1414504579-12562-1-git-send-email-arend@broadcom.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Hante Meuleman <meuleman@broadcom.com>

Reviewed-by: Arend Van Spriel <arend@broadcom.com>
Reviewed-by: Pieter-Paul Giesberts <pieterpg@broadcom.com>
Signed-off-by: Hante Meuleman <meuleman@broadcom.com>
Signed-off-by: Arend van Spriel <arend@broadcom.com>
---
 drivers/net/wireless/brcm80211/brcmfmac/bcdc.c               | 2 +-
 drivers/net/wireless/brcm80211/brcmfmac/bcmsdh.c             | 2 +-
 drivers/net/wireless/brcm80211/brcmfmac/{dhd_bus.h => bus.h} | 9 ++++-----
 drivers/net/wireless/brcm80211/brcmfmac/debug.c              | 2 +-
 drivers/net/wireless/brcm80211/brcmfmac/dhd_common.c         | 2 +-
 drivers/net/wireless/brcm80211/brcmfmac/dhd_linux.c          | 2 +-
 drivers/net/wireless/brcm80211/brcmfmac/dhd_sdio.c           | 2 +-
 drivers/net/wireless/brcm80211/brcmfmac/feature.c            | 2 +-
 drivers/net/wireless/brcm80211/brcmfmac/flowring.c           | 2 +-
 drivers/net/wireless/brcm80211/brcmfmac/fwil.c               | 2 +-
 drivers/net/wireless/brcm80211/brcmfmac/fwsignal.c           | 2 +-
 drivers/net/wireless/brcm80211/brcmfmac/msgbuf.c             | 2 +-
 drivers/net/wireless/brcm80211/brcmfmac/pcie.c               | 2 +-
 drivers/net/wireless/brcm80211/brcmfmac/proto.c              | 2 +-
 drivers/net/wireless/brcm80211/brcmfmac/usb.c                | 3 +--
 drivers/net/wireless/brcm80211/brcmfmac/wl_cfg80211.c        | 2 +-
 16 files changed, 19 insertions(+), 21 deletions(-)
 rename drivers/net/wireless/brcm80211/brcmfmac/{dhd_bus.h => bus.h} (98%)

diff --git a/drivers/net/wireless/brcm80211/brcmfmac/bcdc.c b/drivers/net/wireless/brcm80211/brcmfmac/bcdc.c
index 11d3dfa..d5a2d94 100644
--- a/drivers/net/wireless/brcm80211/brcmfmac/bcdc.c
+++ b/drivers/net/wireless/brcm80211/brcmfmac/bcdc.c
@@ -26,7 +26,7 @@
 #include <brcmu_wifi.h>
 
 #include "dhd.h"
-#include "dhd_bus.h"
+#include "bus.h"
 #include "fwsignal.h"
 #include "debug.h"
 #include "tracepoint.h"
diff --git a/drivers/net/wireless/brcm80211/brcmfmac/bcmsdh.c b/drivers/net/wireless/brcm80211/brcmfmac/bcmsdh.c
index 8c0dfea..969bdd6 100644
--- a/drivers/net/wireless/brcm80211/brcmfmac/bcmsdh.c
+++ b/drivers/net/wireless/brcm80211/brcmfmac/bcmsdh.c
@@ -41,7 +41,7 @@
 #include <chipcommon.h>
 #include <soc.h>
 #include "chip.h"
-#include "dhd_bus.h"
+#include "bus.h"
 #include "debug.h"
 #include "sdio_host.h"
 #include "of.h"
diff --git a/drivers/net/wireless/brcm80211/brcmfmac/dhd_bus.h b/drivers/net/wireless/brcm80211/brcmfmac/bus.h
similarity index 98%
rename from drivers/net/wireless/brcm80211/brcmfmac/dhd_bus.h
rename to drivers/net/wireless/brcm80211/brcmfmac/bus.h
index 0421cfe..ef344e4 100644
--- a/drivers/net/wireless/brcm80211/brcmfmac/dhd_bus.h
+++ b/drivers/net/wireless/brcm80211/brcmfmac/bus.h
@@ -14,8 +14,8 @@
  * CONNECTION WITH THE USE OR PERFORMANCE OF THIS SOFTWARE.
  */
 
-#ifndef _BRCMF_BUS_H_
-#define _BRCMF_BUS_H_
+#ifndef BRCMFMAC_BUS_H
+#define BRCMFMAC_BUS_H
 
 #include "debug.h"
 
@@ -227,8 +227,7 @@ void brcmf_txflowblock(struct device *dev, bool state);
 void brcmf_txcomplete(struct device *dev, struct sk_buff *txp, bool success);
 
 int brcmf_bus_start(struct device *dev);
-s32 brcmf_iovar_data_set(struct device *dev, char *name, void *data,
-				u32 len);
+s32 brcmf_iovar_data_set(struct device *dev, char *name, void *data, u32 len);
 void brcmf_bus_add_txhdrlen(struct device *dev, uint len);
 
 #ifdef CONFIG_BRCMFMAC_SDIO
@@ -241,4 +240,4 @@ void brcmf_usb_exit(void);
 void brcmf_usb_register(void);
 #endif
 
-#endif				/* _BRCMF_BUS_H_ */
+#endif /* BRCMFMAC_BUS_H */
diff --git a/drivers/net/wireless/brcm80211/brcmfmac/debug.c b/drivers/net/wireless/brcm80211/brcmfmac/debug.c
index 27e5108..340b104 100644
--- a/drivers/net/wireless/brcm80211/brcmfmac/debug.c
+++ b/drivers/net/wireless/brcm80211/brcmfmac/debug.c
@@ -20,7 +20,7 @@
 #include <brcmu_wifi.h>
 #include <brcmu_utils.h>
 #include "dhd.h"
-#include "dhd_bus.h"
+#include "bus.h"
 #include "debug.h"
 
 static struct dentry *root_folder;
diff --git a/drivers/net/wireless/brcm80211/brcmfmac/dhd_common.c b/drivers/net/wireless/brcm80211/brcmfmac/dhd_common.c
index 78ada88..7723994 100644
--- a/drivers/net/wireless/brcm80211/brcmfmac/dhd_common.c
+++ b/drivers/net/wireless/brcm80211/brcmfmac/dhd_common.c
@@ -20,7 +20,7 @@
 #include <brcmu_wifi.h>
 #include <brcmu_utils.h>
 #include "dhd.h"
-#include "dhd_bus.h"
+#include "bus.h"
 #include "debug.h"
 #include "fwil.h"
 #include "fwil_types.h"
diff --git a/drivers/net/wireless/brcm80211/brcmfmac/dhd_linux.c b/drivers/net/wireless/brcm80211/brcmfmac/dhd_linux.c
index 2522e68..8dbf2c1 100644
--- a/drivers/net/wireless/brcm80211/brcmfmac/dhd_linux.c
+++ b/drivers/net/wireless/brcm80211/brcmfmac/dhd_linux.c
@@ -23,7 +23,7 @@
 #include <brcmu_wifi.h>
 
 #include "dhd.h"
-#include "dhd_bus.h"
+#include "bus.h"
 #include "debug.h"
 #include "fwil_types.h"
 #include "p2p.h"
diff --git a/drivers/net/wireless/brcm80211/brcmfmac/dhd_sdio.c b/drivers/net/wireless/brcm80211/brcmfmac/dhd_sdio.c
index 4fc2f52..224e922 100644
--- a/drivers/net/wireless/brcm80211/brcmfmac/dhd_sdio.c
+++ b/drivers/net/wireless/brcm80211/brcmfmac/dhd_sdio.c
@@ -96,7 +96,7 @@ struct rte_console {
 #endif				/* DEBUG */
 #include <chipcommon.h>
 
-#include "dhd_bus.h"
+#include "bus.h"
 #include "debug.h"
 #include "tracepoint.h"
 
diff --git a/drivers/net/wireless/brcm80211/brcmfmac/feature.c b/drivers/net/wireless/brcm80211/brcmfmac/feature.c
index 86b854e..d4be4c4 100644
--- a/drivers/net/wireless/brcm80211/brcmfmac/feature.c
+++ b/drivers/net/wireless/brcm80211/brcmfmac/feature.c
@@ -18,7 +18,7 @@
 
 #include <brcm_hw_ids.h>
 #include "dhd.h"
-#include "dhd_bus.h"
+#include "bus.h"
 #include "debug.h"
 #include "fwil.h"
 #include "feature.h"
diff --git a/drivers/net/wireless/brcm80211/brcmfmac/flowring.c b/drivers/net/wireless/brcm80211/brcmfmac/flowring.c
index 15a2cc5..e9cb550 100644
--- a/drivers/net/wireless/brcm80211/brcmfmac/flowring.c
+++ b/drivers/net/wireless/brcm80211/brcmfmac/flowring.c
@@ -21,7 +21,7 @@
 
 #include "dhd.h"
 #include "debug.h"
-#include "dhd_bus.h"
+#include "bus.h"
 #include "proto.h"
 #include "flowring.h"
 #include "msgbuf.h"
diff --git a/drivers/net/wireless/brcm80211/brcmfmac/fwil.c b/drivers/net/wireless/brcm80211/brcmfmac/fwil.c
index 424146c..70db41f 100644
--- a/drivers/net/wireless/brcm80211/brcmfmac/fwil.c
+++ b/drivers/net/wireless/brcm80211/brcmfmac/fwil.c
@@ -23,7 +23,7 @@
 #include <brcmu_utils.h>
 #include <brcmu_wifi.h>
 #include "dhd.h"
-#include "dhd_bus.h"
+#include "bus.h"
 #include "debug.h"
 #include "tracepoint.h"
 #include "fwil.h"
diff --git a/drivers/net/wireless/brcm80211/brcmfmac/fwsignal.c b/drivers/net/wireless/brcm80211/brcmfmac/fwsignal.c
index 5a3cf64..dbd52cc 100644
--- a/drivers/net/wireless/brcm80211/brcmfmac/fwsignal.c
+++ b/drivers/net/wireless/brcm80211/brcmfmac/fwsignal.c
@@ -28,7 +28,7 @@
 #include <brcmu_wifi.h>
 #include "dhd.h"
 #include "debug.h"
-#include "dhd_bus.h"
+#include "bus.h"
 #include "fwil.h"
 #include "fwil_types.h"
 #include "fweh.h"
diff --git a/drivers/net/wireless/brcm80211/brcmfmac/msgbuf.c b/drivers/net/wireless/brcm80211/brcmfmac/msgbuf.c
index 87924d3..18e1770 100644
--- a/drivers/net/wireless/brcm80211/brcmfmac/msgbuf.c
+++ b/drivers/net/wireless/brcm80211/brcmfmac/msgbuf.c
@@ -30,7 +30,7 @@
 #include "msgbuf.h"
 #include "commonring.h"
 #include "flowring.h"
-#include "dhd_bus.h"
+#include "bus.h"
 #include "tracepoint.h"
 
 
diff --git a/drivers/net/wireless/brcm80211/brcmfmac/pcie.c b/drivers/net/wireless/brcm80211/brcmfmac/pcie.c
index d8fe7ab..b0ae799 100644
--- a/drivers/net/wireless/brcm80211/brcmfmac/pcie.c
+++ b/drivers/net/wireless/brcm80211/brcmfmac/pcie.c
@@ -31,7 +31,7 @@
 #include <brcm_hw_ids.h>
 
 #include "debug.h"
-#include "dhd_bus.h"
+#include "bus.h"
 #include "commonring.h"
 #include "msgbuf.h"
 #include "pcie.h"
diff --git a/drivers/net/wireless/brcm80211/brcmfmac/proto.c b/drivers/net/wireless/brcm80211/brcmfmac/proto.c
index f96b932..5e83b2b 100644
--- a/drivers/net/wireless/brcm80211/brcmfmac/proto.c
+++ b/drivers/net/wireless/brcm80211/brcmfmac/proto.c
@@ -21,7 +21,7 @@
 
 #include <brcmu_wifi.h>
 #include "dhd.h"
-#include "dhd_bus.h"
+#include "bus.h"
 #include "debug.h"
 #include "proto.h"
 #include "bcdc.h"
diff --git a/drivers/net/wireless/brcm80211/brcmfmac/usb.c b/drivers/net/wireless/brcm80211/brcmfmac/usb.c
index 4eb9b2c..5265aa7 100644
--- a/drivers/net/wireless/brcm80211/brcmfmac/usb.c
+++ b/drivers/net/wireless/brcm80211/brcmfmac/usb.c
@@ -23,8 +23,7 @@
 #include <brcmu_utils.h>
 #include <brcm_hw_ids.h>
 #include <brcmu_wifi.h>
-#include <dhd_bus.h>
-
+#include "bus.h"
 #include "debug.h"
 #include "firmware.h"
 #include "usb.h"
diff --git a/drivers/net/wireless/brcm80211/brcmfmac/wl_cfg80211.c b/drivers/net/wireless/brcm80211/brcmfmac/wl_cfg80211.c
index 50bc6a0..2560dff 100644
--- a/drivers/net/wireless/brcm80211/brcmfmac/wl_cfg80211.c
+++ b/drivers/net/wireless/brcm80211/brcmfmac/wl_cfg80211.c
@@ -37,7 +37,7 @@
 #include "fwil.h"
 #include "proto.h"
 #include "vendor.h"
-#include "dhd_bus.h"
+#include "bus.h"
 
 #define BRCMF_SCAN_IE_LEN_MAX		2048
 #define BRCMF_PNO_VERSION		2
-- 
1.9.1

