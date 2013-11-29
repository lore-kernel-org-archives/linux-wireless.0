Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mms2.broadcom.com ([216.31.210.18]:4320 "EHLO mms2.broadcom.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753355Ab3K2LZk (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 29 Nov 2013 06:25:40 -0500
From: "Arend van Spriel" <arend@broadcom.com>
To: "John W. Linville" <linville@tuxdriver.com>
cc: linux-wireless <linux-wireless@vger.kernel.org>,
	"Hante Meuleman" <meuleman@broadcom.com>,
	"Arend van Spriel" <arend@broadcom.com>
Subject: [PATCH 07/19] brcmfmac: removed dhd_proto.h.
Date: Fri, 29 Nov 2013 12:25:12 +0100
Message-ID: <1385724324-6361-8-git-send-email-arend@broadcom.com> (sfid-20131129_123808_025541_0D998FAB)
In-Reply-To: <1385724324-6361-1-git-send-email-arend@broadcom.com>
References: <1385724324-6361-1-git-send-email-arend@broadcom.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Hante Meuleman <meuleman@broadcom.com>

dhd_proto.h was cleaned up and prototypes were moved to dhd.h.
dhd_proto.h was removed. This is a step in cleaning and
restucturing protocol layer.

Reviewed-by: Arend Van Spriel <arend@broadcom.com>
Reviewed-by: Pieter-Paul Giesberts <pieterpg@broadcom.com>
Signed-off-by: Hante Meuleman <meuleman@broadcom.com>
Signed-off-by: Arend van Spriel <arend@broadcom.com>
---
 drivers/net/wireless/brcm80211/brcmfmac/bcdc.c     |    1 -
 drivers/net/wireless/brcm80211/brcmfmac/dhd.h      |   15 ++++++++
 .../net/wireless/brcm80211/brcmfmac/dhd_common.c   |    1 -
 .../net/wireless/brcm80211/brcmfmac/dhd_linux.c    |    1 -
 .../net/wireless/brcm80211/brcmfmac/dhd_proto.h    |   39 --------------------
 drivers/net/wireless/brcm80211/brcmfmac/fwsignal.c |    1 -
 6 files changed, 15 insertions(+), 43 deletions(-)
 delete mode 100644 drivers/net/wireless/brcm80211/brcmfmac/dhd_proto.h

diff --git a/drivers/net/wireless/brcm80211/brcmfmac/bcdc.c b/drivers/net/wireless/brcm80211/brcmfmac/bcdc.c
index 42aaf10..59c6c05 100644
--- a/drivers/net/wireless/brcm80211/brcmfmac/bcdc.c
+++ b/drivers/net/wireless/brcm80211/brcmfmac/bcdc.c
@@ -26,7 +26,6 @@
 #include <brcmu_wifi.h>
 
 #include "dhd.h"
-#include "dhd_proto.h"
 #include "dhd_bus.h"
 #include "fwsignal.h"
 #include "dhd_dbg.h"
diff --git a/drivers/net/wireless/brcm80211/brcmfmac/dhd.h b/drivers/net/wireless/brcm80211/brcmfmac/dhd.h
index 899a2ad..dc2ebef 100644
--- a/drivers/net/wireless/brcm80211/brcmfmac/dhd.h
+++ b/drivers/net/wireless/brcm80211/brcmfmac/dhd.h
@@ -635,6 +635,18 @@ int brcmf_netdev_wait_pend8021x(struct net_device *ndev);
 /* Return pointer to interface name */
 char *brcmf_ifname(struct brcmf_pub *drvr, int idx);
 
+/* Linkage, sets prot link and updates hdrlen in pub */
+int brcmf_proto_attach(struct brcmf_pub *drvr);
+
+/* Unlink, frees allocated protocol memory (including brcmf_proto) */
+void brcmf_proto_detach(struct brcmf_pub *drvr);
+
+/* Add any protocol-specific data header.
+ * Caller must reserve prot_hdrlen prepend space.
+ */
+void brcmf_proto_hdrpush(struct brcmf_pub *, int ifidx, u8 offset,
+			 struct sk_buff *txp);
+
 /* Query dongle */
 int brcmf_proto_cdc_query_dcmd(struct brcmf_pub *drvr, int ifidx, uint cmd,
 			       void *buf, uint len);
@@ -655,4 +667,7 @@ u32 brcmf_get_chip_info(struct brcmf_if *ifp);
 void brcmf_txfinalize(struct brcmf_pub *drvr, struct sk_buff *txp,
 		      bool success);
 
+/* Sets dongle media info (drv_version, mac address). */
+int brcmf_c_preinit_dcmds(struct brcmf_if *ifp);
+
 #endif				/* _BRCMF_H_ */
diff --git a/drivers/net/wireless/brcm80211/brcmfmac/dhd_common.c b/drivers/net/wireless/brcm80211/brcmfmac/dhd_common.c
index 5c0c919..6017633 100644
--- a/drivers/net/wireless/brcm80211/brcmfmac/dhd_common.c
+++ b/drivers/net/wireless/brcm80211/brcmfmac/dhd_common.c
@@ -21,7 +21,6 @@
 #include <brcmu_utils.h>
 #include "dhd.h"
 #include "dhd_bus.h"
-#include "dhd_proto.h"
 #include "dhd_dbg.h"
 #include "fwil.h"
 #include "tracepoint.h"
diff --git a/drivers/net/wireless/brcm80211/brcmfmac/dhd_linux.c b/drivers/net/wireless/brcm80211/brcmfmac/dhd_linux.c
index c34ca70..c626938 100644
--- a/drivers/net/wireless/brcm80211/brcmfmac/dhd_linux.c
+++ b/drivers/net/wireless/brcm80211/brcmfmac/dhd_linux.c
@@ -24,7 +24,6 @@
 
 #include "dhd.h"
 #include "dhd_bus.h"
-#include "dhd_proto.h"
 #include "dhd_dbg.h"
 #include "fwil_types.h"
 #include "p2p.h"
diff --git a/drivers/net/wireless/brcm80211/brcmfmac/dhd_proto.h b/drivers/net/wireless/brcm80211/brcmfmac/dhd_proto.h
deleted file mode 100644
index d633362..0000000
--- a/drivers/net/wireless/brcm80211/brcmfmac/dhd_proto.h
+++ /dev/null
@@ -1,39 +0,0 @@
-/*
- * Copyright (c) 2010 Broadcom Corporation
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
-#ifndef _BRCMF_PROTO_H_
-#define _BRCMF_PROTO_H_
-
-/*
- * Exported from the brcmf protocol module (brcmf_cdc)
- */
-
-/* Linkage, sets prot link and updates hdrlen in pub */
-int brcmf_proto_attach(struct brcmf_pub *drvr);
-
-/* Unlink, frees allocated protocol memory (including brcmf_proto) */
-void brcmf_proto_detach(struct brcmf_pub *drvr);
-
-/* Add any protocol-specific data header.
- * Caller must reserve prot_hdrlen prepend space.
- */
-void brcmf_proto_hdrpush(struct brcmf_pub *, int ifidx, u8 offset,
-			 struct sk_buff *txp);
-
-/* Sets dongle media info (drv_version, mac address). */
-int brcmf_c_preinit_dcmds(struct brcmf_if *ifp);
-
-#endif				/* _BRCMF_PROTO_H_ */
diff --git a/drivers/net/wireless/brcm80211/brcmfmac/fwsignal.c b/drivers/net/wireless/brcm80211/brcmfmac/fwsignal.c
index 296dbf1..b96ee3a 100644
--- a/drivers/net/wireless/brcm80211/brcmfmac/fwsignal.c
+++ b/drivers/net/wireless/brcm80211/brcmfmac/fwsignal.c
@@ -27,7 +27,6 @@
 #include <brcmu_utils.h>
 #include <brcmu_wifi.h>
 #include "dhd.h"
-#include "dhd_proto.h"
 #include "dhd_dbg.h"
 #include "dhd_bus.h"
 #include "fwil.h"
-- 
1.7.10.4


