Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-gw2-out.broadcom.com ([216.31.210.63]:58839 "EHLO
	mail-gw2-out.broadcom.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751510AbaJ1OBK (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 28 Oct 2014 10:01:10 -0400
From: Arend van Spriel <arend@broadcom.com>
To: "John W. Linville" <linville@tuxdriver.com>
CC: linux-wireless <linux-wireless@vger.kernel.org>,
	Hante Meuleman <meuleman@broadcom.com>,
	Arend van Spriel <arend@broadcom.com>
Subject: [PATCH 15/16] brcmfmac: (clean) Rename sdio related files.
Date: Tue, 28 Oct 2014 14:56:18 +0100
Message-ID: <1414504579-12562-16-git-send-email-arend@broadcom.com> (sfid-20141028_150122_935984_5E892737)
In-Reply-To: <1414504579-12562-1-git-send-email-arend@broadcom.com>
References: <1414504579-12562-1-git-send-email-arend@broadcom.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Hante Meuleman <meuleman@broadcom.com>

Rename sdio_host.h to sdio.h and dhd_sdio.c to sdio.c.

Reviewed-by: Arend Van Spriel <arend@broadcom.com>
Reviewed-by: Pieter-Paul Giesberts <pieterpg@broadcom.com>
Signed-off-by: Hante Meuleman <meuleman@broadcom.com>
Signed-off-by: Arend van Spriel <arend@broadcom.com>
---
 drivers/net/wireless/brcm80211/brcmfmac/Makefile                | 2 +-
 drivers/net/wireless/brcm80211/brcmfmac/bcdc.c                  | 2 +-
 drivers/net/wireless/brcm80211/brcmfmac/btcoex.c                | 2 +-
 drivers/net/wireless/brcm80211/brcmfmac/cfg80211.c              | 2 +-
 drivers/net/wireless/brcm80211/brcmfmac/common.c                | 2 +-
 drivers/net/wireless/brcm80211/brcmfmac/commonring.c            | 2 +-
 drivers/net/wireless/brcm80211/brcmfmac/{dhd_linux.c => core.c} | 2 +-
 drivers/net/wireless/brcm80211/brcmfmac/{dhd.h => core.h}       | 6 +++---
 drivers/net/wireless/brcm80211/brcmfmac/debug.c                 | 2 +-
 drivers/net/wireless/brcm80211/brcmfmac/feature.c               | 2 +-
 drivers/net/wireless/brcm80211/brcmfmac/flowring.c              | 2 +-
 drivers/net/wireless/brcm80211/brcmfmac/fweh.c                  | 2 +-
 drivers/net/wireless/brcm80211/brcmfmac/fwil.c                  | 2 +-
 drivers/net/wireless/brcm80211/brcmfmac/fwsignal.c              | 2 +-
 drivers/net/wireless/brcm80211/brcmfmac/msgbuf.c                | 2 +-
 drivers/net/wireless/brcm80211/brcmfmac/p2p.c                   | 2 +-
 drivers/net/wireless/brcm80211/brcmfmac/proto.c                 | 2 +-
 drivers/net/wireless/brcm80211/brcmfmac/vendor.c                | 2 +-
 18 files changed, 20 insertions(+), 20 deletions(-)
 rename drivers/net/wireless/brcm80211/brcmfmac/{dhd_linux.c => core.c} (99%)
 rename drivers/net/wireless/brcm80211/brcmfmac/{dhd.h => core.h} (98%)

diff --git a/drivers/net/wireless/brcm80211/brcmfmac/Makefile b/drivers/net/wireless/brcm80211/brcmfmac/Makefile
index 40ba46b..dc4c750 100644
--- a/drivers/net/wireless/brcm80211/brcmfmac/Makefile
+++ b/drivers/net/wireless/brcm80211/brcmfmac/Makefile
@@ -31,7 +31,7 @@ brcmfmac-objs += \
 		p2p.o \
 		proto.o \
 		common.o \
-		dhd_linux.o \
+		core.o \
 		firmware.o \
 		feature.o \
 		btcoex.o \
diff --git a/drivers/net/wireless/brcm80211/brcmfmac/bcdc.c b/drivers/net/wireless/brcm80211/brcmfmac/bcdc.c
index d5a2d94..8e0e91c 100644
--- a/drivers/net/wireless/brcm80211/brcmfmac/bcdc.c
+++ b/drivers/net/wireless/brcm80211/brcmfmac/bcdc.c
@@ -25,7 +25,7 @@
 #include <brcmu_utils.h>
 #include <brcmu_wifi.h>
 
-#include "dhd.h"
+#include "core.h"
 #include "bus.h"
 #include "fwsignal.h"
 #include "debug.h"
diff --git a/drivers/net/wireless/brcm80211/brcmfmac/btcoex.c b/drivers/net/wireless/brcm80211/brcmfmac/btcoex.c
index e324414..0445163 100644
--- a/drivers/net/wireless/brcm80211/brcmfmac/btcoex.c
+++ b/drivers/net/wireless/brcm80211/brcmfmac/btcoex.c
@@ -20,7 +20,7 @@
 #include <brcmu_wifi.h>
 #include <brcmu_utils.h>
 #include <defs.h>
-#include <dhd.h>
+#include "core.h"
 #include "debug.h"
 #include "fwil.h"
 #include "fwil_types.h"
diff --git a/drivers/net/wireless/brcm80211/brcmfmac/cfg80211.c b/drivers/net/wireless/brcm80211/brcmfmac/cfg80211.c
index 0390e57..8822f2b 100644
--- a/drivers/net/wireless/brcm80211/brcmfmac/cfg80211.c
+++ b/drivers/net/wireless/brcm80211/brcmfmac/cfg80211.c
@@ -26,7 +26,7 @@
 #include <brcmu_utils.h>
 #include <defs.h>
 #include <brcmu_wifi.h>
-#include "dhd.h"
+#include "core.h"
 #include "debug.h"
 #include "tracepoint.h"
 #include "fwil_types.h"
diff --git a/drivers/net/wireless/brcm80211/brcmfmac/common.c b/drivers/net/wireless/brcm80211/brcmfmac/common.c
index 75642e4..183cec9 100644
--- a/drivers/net/wireless/brcm80211/brcmfmac/common.c
+++ b/drivers/net/wireless/brcm80211/brcmfmac/common.c
@@ -19,7 +19,7 @@
 #include <linux/netdevice.h>
 #include <brcmu_wifi.h>
 #include <brcmu_utils.h>
-#include "dhd.h"
+#include "core.h"
 #include "bus.h"
 #include "debug.h"
 #include "fwil.h"
diff --git a/drivers/net/wireless/brcm80211/brcmfmac/commonring.c b/drivers/net/wireless/brcm80211/brcmfmac/commonring.c
index c6d65b8..77656c7 100644
--- a/drivers/net/wireless/brcm80211/brcmfmac/commonring.c
+++ b/drivers/net/wireless/brcm80211/brcmfmac/commonring.c
@@ -19,7 +19,7 @@
 #include <brcmu_utils.h>
 #include <brcmu_wifi.h>
 
-#include "dhd.h"
+#include "core.h"
 #include "commonring.h"
 
 
diff --git a/drivers/net/wireless/brcm80211/brcmfmac/dhd_linux.c b/drivers/net/wireless/brcm80211/brcmfmac/core.c
similarity index 99%
rename from drivers/net/wireless/brcm80211/brcmfmac/dhd_linux.c
rename to drivers/net/wireless/brcm80211/brcmfmac/core.c
index 53650b9..f407665 100644
--- a/drivers/net/wireless/brcm80211/brcmfmac/dhd_linux.c
+++ b/drivers/net/wireless/brcm80211/brcmfmac/core.c
@@ -22,7 +22,7 @@
 #include <brcmu_utils.h>
 #include <brcmu_wifi.h>
 
-#include "dhd.h"
+#include "core.h"
 #include "bus.h"
 #include "debug.h"
 #include "fwil_types.h"
diff --git a/drivers/net/wireless/brcm80211/brcmfmac/dhd.h b/drivers/net/wireless/brcm80211/brcmfmac/core.h
similarity index 98%
rename from drivers/net/wireless/brcm80211/brcmfmac/dhd.h
rename to drivers/net/wireless/brcm80211/brcmfmac/core.h
index 5e4317d..7df22bd 100644
--- a/drivers/net/wireless/brcm80211/brcmfmac/dhd.h
+++ b/drivers/net/wireless/brcm80211/brcmfmac/core.h
@@ -18,8 +18,8 @@
  * Common types *
  */
 
-#ifndef _BRCMF_H_
-#define _BRCMF_H_
+#ifndef BRCMFMAC_CORE_H
+#define BRCMFMAC_CORE_H
 
 #include "fweh.h"
 
@@ -186,4 +186,4 @@ void brcmf_netif_rx(struct brcmf_if *ifp, struct sk_buff *skb);
 /* Sets dongle media info (drv_version, mac address). */
 int brcmf_c_preinit_dcmds(struct brcmf_if *ifp);
 
-#endif				/* _BRCMF_H_ */
+#endif /* BRCMFMAC_CORE_H */
diff --git a/drivers/net/wireless/brcm80211/brcmfmac/debug.c b/drivers/net/wireless/brcm80211/brcmfmac/debug.c
index 340b104..9b473d5 100644
--- a/drivers/net/wireless/brcm80211/brcmfmac/debug.c
+++ b/drivers/net/wireless/brcm80211/brcmfmac/debug.c
@@ -19,7 +19,7 @@
 
 #include <brcmu_wifi.h>
 #include <brcmu_utils.h>
-#include "dhd.h"
+#include "core.h"
 #include "bus.h"
 #include "debug.h"
 
diff --git a/drivers/net/wireless/brcm80211/brcmfmac/feature.c b/drivers/net/wireless/brcm80211/brcmfmac/feature.c
index d4be4c4..931f68a 100644
--- a/drivers/net/wireless/brcm80211/brcmfmac/feature.c
+++ b/drivers/net/wireless/brcm80211/brcmfmac/feature.c
@@ -17,7 +17,7 @@
 #include <linux/netdevice.h>
 
 #include <brcm_hw_ids.h>
-#include "dhd.h"
+#include "core.h"
 #include "bus.h"
 #include "debug.h"
 #include "fwil.h"
diff --git a/drivers/net/wireless/brcm80211/brcmfmac/flowring.c b/drivers/net/wireless/brcm80211/brcmfmac/flowring.c
index e9cb550..44f3a84 100644
--- a/drivers/net/wireless/brcm80211/brcmfmac/flowring.c
+++ b/drivers/net/wireless/brcm80211/brcmfmac/flowring.c
@@ -19,7 +19,7 @@
 #include <linux/etherdevice.h>
 #include <brcmu_utils.h>
 
-#include "dhd.h"
+#include "core.h"
 #include "debug.h"
 #include "bus.h"
 #include "proto.h"
diff --git a/drivers/net/wireless/brcm80211/brcmfmac/fweh.c b/drivers/net/wireless/brcm80211/brcmfmac/fweh.c
index ce98ce5..7338b33 100644
--- a/drivers/net/wireless/brcm80211/brcmfmac/fweh.c
+++ b/drivers/net/wireless/brcm80211/brcmfmac/fweh.c
@@ -18,7 +18,7 @@
 #include "brcmu_wifi.h"
 #include "brcmu_utils.h"
 
-#include "dhd.h"
+#include "core.h"
 #include "debug.h"
 #include "tracepoint.h"
 #include "fwsignal.h"
diff --git a/drivers/net/wireless/brcm80211/brcmfmac/fwil.c b/drivers/net/wireless/brcm80211/brcmfmac/fwil.c
index 70db41f..51f88c1 100644
--- a/drivers/net/wireless/brcm80211/brcmfmac/fwil.c
+++ b/drivers/net/wireless/brcm80211/brcmfmac/fwil.c
@@ -22,7 +22,7 @@
 #include <linux/netdevice.h>
 #include <brcmu_utils.h>
 #include <brcmu_wifi.h>
-#include "dhd.h"
+#include "core.h"
 #include "bus.h"
 #include "debug.h"
 #include "tracepoint.h"
diff --git a/drivers/net/wireless/brcm80211/brcmfmac/fwsignal.c b/drivers/net/wireless/brcm80211/brcmfmac/fwsignal.c
index 6d33331..f0dda0e 100644
--- a/drivers/net/wireless/brcm80211/brcmfmac/fwsignal.c
+++ b/drivers/net/wireless/brcm80211/brcmfmac/fwsignal.c
@@ -26,7 +26,7 @@
 
 #include <brcmu_utils.h>
 #include <brcmu_wifi.h>
-#include "dhd.h"
+#include "core.h"
 #include "debug.h"
 #include "bus.h"
 #include "fwil.h"
diff --git a/drivers/net/wireless/brcm80211/brcmfmac/msgbuf.c b/drivers/net/wireless/brcm80211/brcmfmac/msgbuf.c
index 18e1770..02d39ce 100644
--- a/drivers/net/wireless/brcm80211/brcmfmac/msgbuf.c
+++ b/drivers/net/wireless/brcm80211/brcmfmac/msgbuf.c
@@ -24,7 +24,7 @@
 #include <brcmu_utils.h>
 #include <brcmu_wifi.h>
 
-#include "dhd.h"
+#include "core.h"
 #include "debug.h"
 #include "proto.h"
 #include "msgbuf.h"
diff --git a/drivers/net/wireless/brcm80211/brcmfmac/p2p.c b/drivers/net/wireless/brcm80211/brcmfmac/p2p.c
index ae504b4..effb48e 100644
--- a/drivers/net/wireless/brcm80211/brcmfmac/p2p.c
+++ b/drivers/net/wireless/brcm80211/brcmfmac/p2p.c
@@ -21,7 +21,7 @@
 #include <brcmu_wifi.h>
 #include <brcmu_utils.h>
 #include <defs.h>
-#include <dhd.h>
+#include "core.h"
 #include "debug.h"
 #include "fwil.h"
 #include "fwil_types.h"
diff --git a/drivers/net/wireless/brcm80211/brcmfmac/proto.c b/drivers/net/wireless/brcm80211/brcmfmac/proto.c
index 5e83b2b..26b68c3 100644
--- a/drivers/net/wireless/brcm80211/brcmfmac/proto.c
+++ b/drivers/net/wireless/brcm80211/brcmfmac/proto.c
@@ -20,7 +20,7 @@
 #include <linux/netdevice.h>
 
 #include <brcmu_wifi.h>
-#include "dhd.h"
+#include "core.h"
 #include "bus.h"
 #include "debug.h"
 #include "proto.h"
diff --git a/drivers/net/wireless/brcm80211/brcmfmac/vendor.c b/drivers/net/wireless/brcm80211/brcmfmac/vendor.c
index b86a083..222f26a 100644
--- a/drivers/net/wireless/brcm80211/brcmfmac/vendor.c
+++ b/drivers/net/wireless/brcm80211/brcmfmac/vendor.c
@@ -20,7 +20,7 @@
 
 #include <brcmu_wifi.h>
 #include "fwil_types.h"
-#include "dhd.h"
+#include "core.h"
 #include "p2p.h"
 #include "debug.h"
 #include "cfg80211.h"
-- 
1.9.1

