Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mms1.broadcom.com ([216.31.210.17]:2956 "EHLO mms1.broadcom.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751891Ab1GEWDM (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 5 Jul 2011 18:03:12 -0400
From: "Arend van Spriel" <arend@broadcom.com>
To: gregkh@suse.de
cc: devel@linuxdriverproject.org, linux-wireless@vger.kernel.org,
	"Roland Vossen" <rvossen@broadcom.com>,
	"Arend van Spriel" <arend@broadcom.com>
Subject: [PATCH 21/31] staging: brcm80211: merged dngl_stats.h into
 dhd.h
Date: Wed, 6 Jul 2011 00:02:48 +0200
Message-ID: <1309903378-29021-22-git-send-email-arend@broadcom.com> (sfid-20110706_000321_324031_A39AC3FC)
In-Reply-To: <1309903378-29021-1-git-send-email-arend@broadcom.com>
References: <1309903378-29021-1-git-send-email-arend@broadcom.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Roland Vossen <rvossen@broadcom.com>


Signed-off-by: Arend van Spriel <arend@broadcom.com>
---
 drivers/staging/brcm80211/brcmfmac/bcmsdh.c       |    1 -
 drivers/staging/brcm80211/brcmfmac/bcmsdh_sdmmc.c |    1 -
 drivers/staging/brcm80211/brcmfmac/dhd.h          |   12 ++++++++
 drivers/staging/brcm80211/brcmfmac/dhd_cdc.c      |    1 -
 drivers/staging/brcm80211/brcmfmac/dhd_common.c   |    1 -
 drivers/staging/brcm80211/brcmfmac/dhd_linux.c    |    1 -
 drivers/staging/brcm80211/brcmfmac/dhd_sdio.c     |    1 -
 drivers/staging/brcm80211/brcmfmac/dngl_stats.h   |   32 ---------------------
 drivers/staging/brcm80211/brcmfmac/wl_cfg80211.c  |    1 -
 9 files changed, 12 insertions(+), 39 deletions(-)
 delete mode 100644 drivers/staging/brcm80211/brcmfmac/dngl_stats.h

diff --git a/drivers/staging/brcm80211/brcmfmac/bcmsdh.c b/drivers/staging/brcm80211/brcmfmac/bcmsdh.c
index 5fdeeaf..23c2300 100644
--- a/drivers/staging/brcm80211/brcmfmac/bcmsdh.c
+++ b/drivers/staging/brcm80211/brcmfmac/bcmsdh.c
@@ -29,7 +29,6 @@
 #include <soc.h>
 #include "bcmsdbus.h"		/* common SDIO/controller interface */
 #include "sbsdio.h"		/* BRCM sdio device core */
-#include "dngl_stats.h"
 #include "dhd.h"
 #include "dhd_bus.h"
 #include "sdio_host.h"
diff --git a/drivers/staging/brcm80211/brcmfmac/bcmsdh_sdmmc.c b/drivers/staging/brcm80211/brcmfmac/bcmsdh_sdmmc.c
index d4a380c..40c93c4 100644
--- a/drivers/staging/brcm80211/brcmfmac/bcmsdh_sdmmc.c
+++ b/drivers/staging/brcm80211/brcmfmac/bcmsdh_sdmmc.c
@@ -31,7 +31,6 @@
 #include <brcmu_wifi.h>
 #include "sdio_host.h"
 #include "bcmsdbus.h"
-#include "dngl_stats.h"
 #include "dhd.h"
 #include "dhd_dbg.h"
 #include "wl_cfg80211.h"
diff --git a/drivers/staging/brcm80211/brcmfmac/dhd.h b/drivers/staging/brcm80211/brcmfmac/dhd.h
index 0a3c6e5..82bf04d 100644
--- a/drivers/staging/brcm80211/brcmfmac/dhd.h
+++ b/drivers/staging/brcm80211/brcmfmac/dhd.h
@@ -161,6 +161,18 @@ struct brcmf_event {
 	struct brcmf_event_msg msg;
 } __packed;
 
+struct dngl_stats {
+	unsigned long rx_packets;	/* total packets received */
+	unsigned long tx_packets;	/* total packets transmitted */
+	unsigned long rx_bytes;	/* total bytes received */
+	unsigned long tx_bytes;	/* total bytes transmitted */
+	unsigned long rx_errors;	/* bad packets received */
+	unsigned long tx_errors;	/* packet transmit problems */
+	unsigned long rx_dropped;	/* packets dropped by dongle */
+	unsigned long tx_dropped;	/* packets dropped by dongle */
+	unsigned long multicast;	/* multicast packets received */
+};
+
 #define BRCMF_E_SET_SSID			0
 #define BRCMF_E_JOIN				1
 #define BRCMF_E_START				2
diff --git a/drivers/staging/brcm80211/brcmfmac/dhd_cdc.c b/drivers/staging/brcm80211/brcmfmac/dhd_cdc.c
index d464606..345acab 100644
--- a/drivers/staging/brcm80211/brcmfmac/dhd_cdc.c
+++ b/drivers/staging/brcm80211/brcmfmac/dhd_cdc.c
@@ -22,7 +22,6 @@
 #include <brcmu_utils.h>
 #include <brcmu_wifi.h>
 
-#include "dngl_stats.h"
 #include "dhd.h"
 #include "dhd_proto.h"
 #include "dhd_bus.h"
diff --git a/drivers/staging/brcm80211/brcmfmac/dhd_common.c b/drivers/staging/brcm80211/brcmfmac/dhd_common.c
index 59c2726..c37128d 100644
--- a/drivers/staging/brcm80211/brcmfmac/dhd_common.c
+++ b/drivers/staging/brcm80211/brcmfmac/dhd_common.c
@@ -21,7 +21,6 @@
 #include <defs.h>
 #include <brcmu_wifi.h>
 #include <brcmu_utils.h>
-#include "dngl_stats.h"
 #include "dhd.h"
 #include "dhd_bus.h"
 #include "dhd_proto.h"
diff --git a/drivers/staging/brcm80211/brcmfmac/dhd_linux.c b/drivers/staging/brcm80211/brcmfmac/dhd_linux.c
index 1a7752d..43a5b14 100644
--- a/drivers/staging/brcm80211/brcmfmac/dhd_linux.c
+++ b/drivers/staging/brcm80211/brcmfmac/dhd_linux.c
@@ -33,7 +33,6 @@
 #include <brcmu_utils.h>
 #include <brcmu_wifi.h>
 
-#include "dngl_stats.h"
 #include "dhd.h"
 #include "dhd_bus.h"
 #include "dhd_proto.h"
diff --git a/drivers/staging/brcm80211/brcmfmac/dhd_sdio.c b/drivers/staging/brcm80211/brcmfmac/dhd_sdio.c
index 077cb49..6cb922f 100644
--- a/drivers/staging/brcm80211/brcmfmac/dhd_sdio.c
+++ b/drivers/staging/brcm80211/brcmfmac/dhd_sdio.c
@@ -152,7 +152,6 @@ struct rte_console {
 
 #include "sbsdio.h"
 
-#include "dngl_stats.h"
 #include "dhd.h"
 #include "dhd_bus.h"
 #include "dhd_proto.h"
diff --git a/drivers/staging/brcm80211/brcmfmac/dngl_stats.h b/drivers/staging/brcm80211/brcmfmac/dngl_stats.h
deleted file mode 100644
index 53a50f6..0000000
--- a/drivers/staging/brcm80211/brcmfmac/dngl_stats.h
+++ /dev/null
@@ -1,32 +0,0 @@
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
-#ifndef _dngl_stats_h_
-#define _dngl_stats_h_
-
-struct dngl_stats {
-	unsigned long rx_packets;	/* total packets received */
-	unsigned long tx_packets;	/* total packets transmitted */
-	unsigned long rx_bytes;	/* total bytes received */
-	unsigned long tx_bytes;	/* total bytes transmitted */
-	unsigned long rx_errors;	/* bad packets received */
-	unsigned long tx_errors;	/* packet transmit problems */
-	unsigned long rx_dropped;	/* packets dropped by dongle */
-	unsigned long tx_dropped;	/* packets dropped by dongle */
-	unsigned long multicast;	/* multicast packets received */
-};
-
-#endif				/* _dngl_stats_h_ */
diff --git a/drivers/staging/brcm80211/brcmfmac/wl_cfg80211.c b/drivers/staging/brcm80211/brcmfmac/wl_cfg80211.c
index f6118d1..821206d 100644
--- a/drivers/staging/brcm80211/brcmfmac/wl_cfg80211.c
+++ b/drivers/staging/brcm80211/brcmfmac/wl_cfg80211.c
@@ -31,7 +31,6 @@
 #include <brcmu_utils.h>
 #include <defs.h>
 #include <brcmu_wifi.h>
-#include "dngl_stats.h"
 #include "dhd.h"
 #include "wl_cfg80211.h"
 
-- 
1.7.4.1


