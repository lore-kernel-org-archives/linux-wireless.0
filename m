Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-gw3-out.broadcom.com ([216.31.210.64]:24208 "EHLO
	mail-gw3-out.broadcom.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753125AbaJ1N7y (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 28 Oct 2014 09:59:54 -0400
From: Arend van Spriel <arend@broadcom.com>
To: "John W. Linville" <linville@tuxdriver.com>
CC: linux-wireless <linux-wireless@vger.kernel.org>,
	Hante Meuleman <meuleman@broadcom.com>,
	Arend van Spriel <arend@broadcom.com>
Subject: [PATCH 10/16] brcmfmac: (clean) Rename files dhd_dbg to debug
Date: Tue, 28 Oct 2014 14:56:13 +0100
Message-ID: <1414504579-12562-11-git-send-email-arend@broadcom.com> (sfid-20141028_150009_778317_0DABC288)
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
 drivers/net/wireless/brcm80211/brcmfmac/Makefile               | 2 +-
 drivers/net/wireless/brcm80211/brcmfmac/bcdc.c                 | 2 +-
 drivers/net/wireless/brcm80211/brcmfmac/bcmsdh.c               | 2 +-
 drivers/net/wireless/brcm80211/brcmfmac/btcoex.c               | 2 +-
 drivers/net/wireless/brcm80211/brcmfmac/chip.c                 | 2 +-
 drivers/net/wireless/brcm80211/brcmfmac/{dhd_dbg.c => debug.c} | 2 +-
 drivers/net/wireless/brcm80211/brcmfmac/{dhd_dbg.h => debug.h} | 6 +++---
 drivers/net/wireless/brcm80211/brcmfmac/dhd_bus.h              | 2 +-
 drivers/net/wireless/brcm80211/brcmfmac/dhd_common.c           | 2 +-
 drivers/net/wireless/brcm80211/brcmfmac/dhd_linux.c            | 2 +-
 drivers/net/wireless/brcm80211/brcmfmac/dhd_sdio.c             | 2 +-
 drivers/net/wireless/brcm80211/brcmfmac/feature.c              | 2 +-
 drivers/net/wireless/brcm80211/brcmfmac/firmware.c             | 2 +-
 drivers/net/wireless/brcm80211/brcmfmac/flowring.c             | 2 +-
 drivers/net/wireless/brcm80211/brcmfmac/fweh.c                 | 2 +-
 drivers/net/wireless/brcm80211/brcmfmac/fwil.c                 | 2 +-
 drivers/net/wireless/brcm80211/brcmfmac/fwsignal.c             | 2 +-
 drivers/net/wireless/brcm80211/brcmfmac/msgbuf.c               | 2 +-
 drivers/net/wireless/brcm80211/brcmfmac/of.c                   | 2 +-
 drivers/net/wireless/brcm80211/brcmfmac/p2p.c                  | 2 +-
 drivers/net/wireless/brcm80211/brcmfmac/pcie.c                 | 2 +-
 drivers/net/wireless/brcm80211/brcmfmac/proto.c                | 2 +-
 drivers/net/wireless/brcm80211/brcmfmac/usb.c                  | 2 +-
 drivers/net/wireless/brcm80211/brcmfmac/vendor.c               | 2 +-
 drivers/net/wireless/brcm80211/brcmfmac/wl_cfg80211.c          | 2 +-
 25 files changed, 27 insertions(+), 27 deletions(-)
 rename drivers/net/wireless/brcm80211/brcmfmac/{dhd_dbg.c => debug.c} (99%)
 rename drivers/net/wireless/brcm80211/brcmfmac/{dhd_dbg.h => debug.h} (98%)

diff --git a/drivers/net/wireless/brcm80211/brcmfmac/Makefile b/drivers/net/wireless/brcm80211/brcmfmac/Makefile
index 90a977f..1da9042 100644
--- a/drivers/net/wireless/brcm80211/brcmfmac/Makefile
+++ b/drivers/net/wireless/brcm80211/brcmfmac/Makefile
@@ -50,7 +50,7 @@ brcmfmac-$(CONFIG_BRCMFMAC_USB) += \
 brcmfmac-$(CONFIG_BRCMFMAC_PCIE) += \
 		pcie.o
 brcmfmac-$(CONFIG_BRCMDBG) += \
-		dhd_dbg.o
+		debug.o
 brcmfmac-$(CONFIG_BRCM_TRACING) += \
 		tracepoint.o
 brcmfmac-$(CONFIG_OF) += \
diff --git a/drivers/net/wireless/brcm80211/brcmfmac/bcdc.c b/drivers/net/wireless/brcm80211/brcmfmac/bcdc.c
index a159ff3..11d3dfa 100644
--- a/drivers/net/wireless/brcm80211/brcmfmac/bcdc.c
+++ b/drivers/net/wireless/brcm80211/brcmfmac/bcdc.c
@@ -28,7 +28,7 @@
 #include "dhd.h"
 #include "dhd_bus.h"
 #include "fwsignal.h"
-#include "dhd_dbg.h"
+#include "debug.h"
 #include "tracepoint.h"
 #include "proto.h"
 #include "bcdc.h"
diff --git a/drivers/net/wireless/brcm80211/brcmfmac/bcmsdh.c b/drivers/net/wireless/brcm80211/brcmfmac/bcmsdh.c
index 79b2c7e..8c0dfea 100644
--- a/drivers/net/wireless/brcm80211/brcmfmac/bcmsdh.c
+++ b/drivers/net/wireless/brcm80211/brcmfmac/bcmsdh.c
@@ -42,7 +42,7 @@
 #include <soc.h>
 #include "chip.h"
 #include "dhd_bus.h"
-#include "dhd_dbg.h"
+#include "debug.h"
 #include "sdio_host.h"
 #include "of.h"
 
diff --git a/drivers/net/wireless/brcm80211/brcmfmac/btcoex.c b/drivers/net/wireless/brcm80211/brcmfmac/btcoex.c
index a29ac49..a2f7e2c 100644
--- a/drivers/net/wireless/brcm80211/brcmfmac/btcoex.c
+++ b/drivers/net/wireless/brcm80211/brcmfmac/btcoex.c
@@ -21,7 +21,7 @@
 #include <brcmu_utils.h>
 #include <defs.h>
 #include <dhd.h>
-#include <dhd_dbg.h>
+#include "debug.h"
 #include "fwil.h"
 #include "fwil_types.h"
 #include "btcoex.h"
diff --git a/drivers/net/wireless/brcm80211/brcmfmac/chip.c b/drivers/net/wireless/brcm80211/brcmfmac/chip.c
index 95efde8..ddae0b5 100644
--- a/drivers/net/wireless/brcm80211/brcmfmac/chip.c
+++ b/drivers/net/wireless/brcm80211/brcmfmac/chip.c
@@ -25,7 +25,7 @@
 #include <brcm_hw_ids.h>
 #include <brcmu_utils.h>
 #include <chipcommon.h>
-#include "dhd_dbg.h"
+#include "debug.h"
 #include "chip.h"
 
 /* SOC Interconnect types (aka chip types) */
diff --git a/drivers/net/wireless/brcm80211/brcmfmac/dhd_dbg.c b/drivers/net/wireless/brcm80211/brcmfmac/debug.c
similarity index 99%
rename from drivers/net/wireless/brcm80211/brcmfmac/dhd_dbg.c
rename to drivers/net/wireless/brcm80211/brcmfmac/debug.c
index be9f4f8..27e5108 100644
--- a/drivers/net/wireless/brcm80211/brcmfmac/dhd_dbg.c
+++ b/drivers/net/wireless/brcm80211/brcmfmac/debug.c
@@ -21,7 +21,7 @@
 #include <brcmu_utils.h>
 #include "dhd.h"
 #include "dhd_bus.h"
-#include "dhd_dbg.h"
+#include "debug.h"
 
 static struct dentry *root_folder;
 
diff --git a/drivers/net/wireless/brcm80211/brcmfmac/dhd_dbg.h b/drivers/net/wireless/brcm80211/brcmfmac/debug.h
similarity index 98%
rename from drivers/net/wireless/brcm80211/brcmfmac/dhd_dbg.h
rename to drivers/net/wireless/brcm80211/brcmfmac/debug.h
index dec40d3..eb0b8c4 100644
--- a/drivers/net/wireless/brcm80211/brcmfmac/dhd_dbg.h
+++ b/drivers/net/wireless/brcm80211/brcmfmac/debug.h
@@ -14,8 +14,8 @@
  * CONNECTION WITH THE USE OR PERFORMANCE OF THIS SOFTWARE.
  */
 
-#ifndef _BRCMF_DBG_H_
-#define _BRCMF_DBG_H_
+#ifndef BRCMFMAC_DEBUG_H
+#define BRCMFMAC_DEBUG_H
 
 /* message levels */
 #define BRCMF_TRACE_VAL		0x00000002
@@ -133,4 +133,4 @@ int brcmf_debugfs_add_entry(struct brcmf_pub *drvr, const char *fn,
 }
 #endif
 
-#endif				/* _BRCMF_DBG_H_ */
+#endif /* BRCMFMAC_DEBUG_H */
diff --git a/drivers/net/wireless/brcm80211/brcmfmac/dhd_bus.h b/drivers/net/wireless/brcm80211/brcmfmac/dhd_bus.h
index 80e73a1..0421cfe 100644
--- a/drivers/net/wireless/brcm80211/brcmfmac/dhd_bus.h
+++ b/drivers/net/wireless/brcm80211/brcmfmac/dhd_bus.h
@@ -17,7 +17,7 @@
 #ifndef _BRCMF_BUS_H_
 #define _BRCMF_BUS_H_
 
-#include "dhd_dbg.h"
+#include "debug.h"
 
 /* IDs of the 6 default common rings of msgbuf protocol */
 #define BRCMF_H2D_MSGRING_CONTROL_SUBMIT	0
diff --git a/drivers/net/wireless/brcm80211/brcmfmac/dhd_common.c b/drivers/net/wireless/brcm80211/brcmfmac/dhd_common.c
index 98bc222..78ada88 100644
--- a/drivers/net/wireless/brcm80211/brcmfmac/dhd_common.c
+++ b/drivers/net/wireless/brcm80211/brcmfmac/dhd_common.c
@@ -21,7 +21,7 @@
 #include <brcmu_utils.h>
 #include "dhd.h"
 #include "dhd_bus.h"
-#include "dhd_dbg.h"
+#include "debug.h"
 #include "fwil.h"
 #include "fwil_types.h"
 #include "tracepoint.h"
diff --git a/drivers/net/wireless/brcm80211/brcmfmac/dhd_linux.c b/drivers/net/wireless/brcm80211/brcmfmac/dhd_linux.c
index fb10439..2522e68 100644
--- a/drivers/net/wireless/brcm80211/brcmfmac/dhd_linux.c
+++ b/drivers/net/wireless/brcm80211/brcmfmac/dhd_linux.c
@@ -24,7 +24,7 @@
 
 #include "dhd.h"
 #include "dhd_bus.h"
-#include "dhd_dbg.h"
+#include "debug.h"
 #include "fwil_types.h"
 #include "p2p.h"
 #include "wl_cfg80211.h"
diff --git a/drivers/net/wireless/brcm80211/brcmfmac/dhd_sdio.c b/drivers/net/wireless/brcm80211/brcmfmac/dhd_sdio.c
index 079187c..4fc2f52 100644
--- a/drivers/net/wireless/brcm80211/brcmfmac/dhd_sdio.c
+++ b/drivers/net/wireless/brcm80211/brcmfmac/dhd_sdio.c
@@ -97,7 +97,7 @@ struct rte_console {
 #include <chipcommon.h>
 
 #include "dhd_bus.h"
-#include "dhd_dbg.h"
+#include "debug.h"
 #include "tracepoint.h"
 
 #define TXQLEN		2048	/* bulk tx queue length */
diff --git a/drivers/net/wireless/brcm80211/brcmfmac/feature.c b/drivers/net/wireless/brcm80211/brcmfmac/feature.c
index 4eb6a41..86b854e 100644
--- a/drivers/net/wireless/brcm80211/brcmfmac/feature.c
+++ b/drivers/net/wireless/brcm80211/brcmfmac/feature.c
@@ -19,7 +19,7 @@
 #include <brcm_hw_ids.h>
 #include "dhd.h"
 #include "dhd_bus.h"
-#include "dhd_dbg.h"
+#include "debug.h"
 #include "fwil.h"
 #include "feature.h"
 
diff --git a/drivers/net/wireless/brcm80211/brcmfmac/firmware.c b/drivers/net/wireless/brcm80211/brcmfmac/firmware.c
index 8ea9f28..0f157f1 100644
--- a/drivers/net/wireless/brcm80211/brcmfmac/firmware.c
+++ b/drivers/net/wireless/brcm80211/brcmfmac/firmware.c
@@ -20,7 +20,7 @@
 #include <linux/firmware.h>
 #include <linux/module.h>
 
-#include "dhd_dbg.h"
+#include "debug.h"
 #include "firmware.h"
 
 char brcmf_firmware_path[BRCMF_FW_PATH_LEN];
diff --git a/drivers/net/wireless/brcm80211/brcmfmac/flowring.c b/drivers/net/wireless/brcm80211/brcmfmac/flowring.c
index 1faa929..15a2cc5 100644
--- a/drivers/net/wireless/brcm80211/brcmfmac/flowring.c
+++ b/drivers/net/wireless/brcm80211/brcmfmac/flowring.c
@@ -20,7 +20,7 @@
 #include <brcmu_utils.h>
 
 #include "dhd.h"
-#include "dhd_dbg.h"
+#include "debug.h"
 #include "dhd_bus.h"
 #include "proto.h"
 #include "flowring.h"
diff --git a/drivers/net/wireless/brcm80211/brcmfmac/fweh.c b/drivers/net/wireless/brcm80211/brcmfmac/fweh.c
index 44fc85f..ce98ce5 100644
--- a/drivers/net/wireless/brcm80211/brcmfmac/fweh.c
+++ b/drivers/net/wireless/brcm80211/brcmfmac/fweh.c
@@ -19,7 +19,7 @@
 #include "brcmu_utils.h"
 
 #include "dhd.h"
-#include "dhd_dbg.h"
+#include "debug.h"
 #include "tracepoint.h"
 #include "fwsignal.h"
 #include "fweh.h"
diff --git a/drivers/net/wireless/brcm80211/brcmfmac/fwil.c b/drivers/net/wireless/brcm80211/brcmfmac/fwil.c
index dccbdc1..424146c 100644
--- a/drivers/net/wireless/brcm80211/brcmfmac/fwil.c
+++ b/drivers/net/wireless/brcm80211/brcmfmac/fwil.c
@@ -24,7 +24,7 @@
 #include <brcmu_wifi.h>
 #include "dhd.h"
 #include "dhd_bus.h"
-#include "dhd_dbg.h"
+#include "debug.h"
 #include "tracepoint.h"
 #include "fwil.h"
 #include "proto.h"
diff --git a/drivers/net/wireless/brcm80211/brcmfmac/fwsignal.c b/drivers/net/wireless/brcm80211/brcmfmac/fwsignal.c
index 183f08d..5a3cf64 100644
--- a/drivers/net/wireless/brcm80211/brcmfmac/fwsignal.c
+++ b/drivers/net/wireless/brcm80211/brcmfmac/fwsignal.c
@@ -27,7 +27,7 @@
 #include <brcmu_utils.h>
 #include <brcmu_wifi.h>
 #include "dhd.h"
-#include "dhd_dbg.h"
+#include "debug.h"
 #include "dhd_bus.h"
 #include "fwil.h"
 #include "fwil_types.h"
diff --git a/drivers/net/wireless/brcm80211/brcmfmac/msgbuf.c b/drivers/net/wireless/brcm80211/brcmfmac/msgbuf.c
index 11cc051..87924d3 100644
--- a/drivers/net/wireless/brcm80211/brcmfmac/msgbuf.c
+++ b/drivers/net/wireless/brcm80211/brcmfmac/msgbuf.c
@@ -25,7 +25,7 @@
 #include <brcmu_wifi.h>
 
 #include "dhd.h"
-#include "dhd_dbg.h"
+#include "debug.h"
 #include "proto.h"
 #include "msgbuf.h"
 #include "commonring.h"
diff --git a/drivers/net/wireless/brcm80211/brcmfmac/of.c b/drivers/net/wireless/brcm80211/brcmfmac/of.c
index f05f527..875060c 100644
--- a/drivers/net/wireless/brcm80211/brcmfmac/of.c
+++ b/drivers/net/wireless/brcm80211/brcmfmac/of.c
@@ -21,7 +21,7 @@
 #include <linux/mmc/sdio_func.h>
 
 #include <defs.h>
-#include "dhd_dbg.h"
+#include "debug.h"
 #include "sdio_host.h"
 
 void brcmf_of_probe(struct brcmf_sdio_dev *sdiodev)
diff --git a/drivers/net/wireless/brcm80211/brcmfmac/p2p.c b/drivers/net/wireless/brcm80211/brcmfmac/p2p.c
index d54c58a..7459c25 100644
--- a/drivers/net/wireless/brcm80211/brcmfmac/p2p.c
+++ b/drivers/net/wireless/brcm80211/brcmfmac/p2p.c
@@ -22,7 +22,7 @@
 #include <brcmu_utils.h>
 #include <defs.h>
 #include <dhd.h>
-#include <dhd_dbg.h>
+#include "debug.h"
 #include "fwil.h"
 #include "fwil_types.h"
 #include "p2p.h"
diff --git a/drivers/net/wireless/brcm80211/brcmfmac/pcie.c b/drivers/net/wireless/brcm80211/brcmfmac/pcie.c
index 8c0632e..d8fe7ab 100644
--- a/drivers/net/wireless/brcm80211/brcmfmac/pcie.c
+++ b/drivers/net/wireless/brcm80211/brcmfmac/pcie.c
@@ -30,7 +30,7 @@
 #include <brcmu_wifi.h>
 #include <brcm_hw_ids.h>
 
-#include "dhd_dbg.h"
+#include "debug.h"
 #include "dhd_bus.h"
 #include "commonring.h"
 #include "msgbuf.h"
diff --git a/drivers/net/wireless/brcm80211/brcmfmac/proto.c b/drivers/net/wireless/brcm80211/brcmfmac/proto.c
index 62b9407..f96b932 100644
--- a/drivers/net/wireless/brcm80211/brcmfmac/proto.c
+++ b/drivers/net/wireless/brcm80211/brcmfmac/proto.c
@@ -22,7 +22,7 @@
 #include <brcmu_wifi.h>
 #include "dhd.h"
 #include "dhd_bus.h"
-#include "dhd_dbg.h"
+#include "debug.h"
 #include "proto.h"
 #include "bcdc.h"
 #include "msgbuf.h"
diff --git a/drivers/net/wireless/brcm80211/brcmfmac/usb.c b/drivers/net/wireless/brcm80211/brcmfmac/usb.c
index 3f12b60..4eb9b2c 100644
--- a/drivers/net/wireless/brcm80211/brcmfmac/usb.c
+++ b/drivers/net/wireless/brcm80211/brcmfmac/usb.c
@@ -24,8 +24,8 @@
 #include <brcm_hw_ids.h>
 #include <brcmu_wifi.h>
 #include <dhd_bus.h>
-#include <dhd_dbg.h>
 
+#include "debug.h"
 #include "firmware.h"
 #include "usb.h"
 
diff --git a/drivers/net/wireless/brcm80211/brcmfmac/vendor.c b/drivers/net/wireless/brcm80211/brcmfmac/vendor.c
index 5960d82..f204c83 100644
--- a/drivers/net/wireless/brcm80211/brcmfmac/vendor.c
+++ b/drivers/net/wireless/brcm80211/brcmfmac/vendor.c
@@ -22,7 +22,7 @@
 #include "fwil_types.h"
 #include "dhd.h"
 #include "p2p.h"
-#include "dhd_dbg.h"
+#include "debug.h"
 #include "wl_cfg80211.h"
 #include "vendor.h"
 #include "fwil.h"
diff --git a/drivers/net/wireless/brcm80211/brcmfmac/wl_cfg80211.c b/drivers/net/wireless/brcm80211/brcmfmac/wl_cfg80211.c
index fcadbe3..50bc6a0 100644
--- a/drivers/net/wireless/brcm80211/brcmfmac/wl_cfg80211.c
+++ b/drivers/net/wireless/brcm80211/brcmfmac/wl_cfg80211.c
@@ -27,7 +27,7 @@
 #include <defs.h>
 #include <brcmu_wifi.h>
 #include "dhd.h"
-#include "dhd_dbg.h"
+#include "debug.h"
 #include "tracepoint.h"
 #include "fwil_types.h"
 #include "p2p.h"
-- 
1.9.1

