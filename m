Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mms2.broadcom.com ([216.31.210.18]:1816 "EHLO mms2.broadcom.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1162011Ab3DEI6J (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 5 Apr 2013 04:58:09 -0400
From: "Arend van Spriel" <arend@broadcom.com>
To: "John W. Linville" <linville@tuxdriver.com>
cc: linux-wireless <linux-wireless@vger.kernel.org>,
	"Arend van Spriel" <arend@broadcom.com>
Subject: [PATCH 06/16] brcmfmac: add hexadecimal trace of message
 payload
Date: Fri, 5 Apr 2013 10:57:44 +0200
Message-ID: <1365152274-4252-7-git-send-email-arend@broadcom.com> (sfid-20130405_111305_532501_08EA252E)
In-Reply-To: <1365152274-4252-1-git-send-email-arend@broadcom.com>
References: <1365152274-4252-1-git-send-email-arend@broadcom.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Adds a trace function used in brcmf_dbg_hex_dump() which adds the
raw binary data to the trace. It requires trace-cmd plugin to see
this data.

Reviewed-by: Piotr Haber <phaber@broadcom.com>
Signed-off-by: Arend van Spriel <arend@broadcom.com>
---
 drivers/net/wireless/brcm80211/brcmfmac/dhd_dbg.h     |    1 +
 drivers/net/wireless/brcm80211/brcmfmac/dhd_sdio.c    |    1 +
 drivers/net/wireless/brcm80211/brcmfmac/fweh.c        |    1 +
 drivers/net/wireless/brcm80211/brcmfmac/fwil.c        |    1 +
 drivers/net/wireless/brcm80211/brcmfmac/tracepoint.h  |   14 ++++++++++++++
 drivers/net/wireless/brcm80211/brcmfmac/wl_cfg80211.c |    1 +
 6 files changed, 19 insertions(+)

diff --git a/drivers/net/wireless/brcm80211/brcmfmac/dhd_dbg.h b/drivers/net/wireless/brcm80211/brcmfmac/dhd_dbg.h
index d259ae5..009c87b 100644
--- a/drivers/net/wireless/brcm80211/brcmfmac/dhd_dbg.h
+++ b/drivers/net/wireless/brcm80211/brcmfmac/dhd_dbg.h
@@ -93,6 +93,7 @@ do {								\
 
 #define brcmf_dbg_hex_dump(test, data, len, fmt, ...)			\
 do {									\
+	trace_brcmf_hexdump((void *)data, len);				\
 	if (test)							\
 		brcmu_dbg_hex_dump(data, len, fmt, ##__VA_ARGS__);	\
 } while (0)
diff --git a/drivers/net/wireless/brcm80211/brcmfmac/dhd_sdio.c b/drivers/net/wireless/brcm80211/brcmfmac/dhd_sdio.c
index 5d5c02c..c1cab40 100644
--- a/drivers/net/wireless/brcm80211/brcmfmac/dhd_sdio.c
+++ b/drivers/net/wireless/brcm80211/brcmfmac/dhd_sdio.c
@@ -94,6 +94,7 @@ struct rte_console {
 
 #include "dhd_bus.h"
 #include "dhd_dbg.h"
+#include "tracepoint.h"
 
 #define TXQLEN		2048	/* bulk tx queue length */
 #define TXHI		(TXQLEN - 256)	/* turn on flow control above TXHI */
diff --git a/drivers/net/wireless/brcm80211/brcmfmac/fweh.c b/drivers/net/wireless/brcm80211/brcmfmac/fweh.c
index dad9414..01d39a9 100644
--- a/drivers/net/wireless/brcm80211/brcmfmac/fweh.c
+++ b/drivers/net/wireless/brcm80211/brcmfmac/fweh.c
@@ -20,6 +20,7 @@
 
 #include "dhd.h"
 #include "dhd_dbg.h"
+#include "tracepoint.h"
 #include "fwsignal.h"
 #include "fweh.h"
 #include "fwil.h"
diff --git a/drivers/net/wireless/brcm80211/brcmfmac/fwil.c b/drivers/net/wireless/brcm80211/brcmfmac/fwil.c
index 8d1def9..04f3959 100644
--- a/drivers/net/wireless/brcm80211/brcmfmac/fwil.c
+++ b/drivers/net/wireless/brcm80211/brcmfmac/fwil.c
@@ -25,6 +25,7 @@
 #include "dhd.h"
 #include "dhd_bus.h"
 #include "dhd_dbg.h"
+#include "tracepoint.h"
 #include "fwil.h"
 
 
diff --git a/drivers/net/wireless/brcm80211/brcmfmac/tracepoint.h b/drivers/net/wireless/brcm80211/brcmfmac/tracepoint.h
index 35efc7a..9df1f7a 100644
--- a/drivers/net/wireless/brcm80211/brcmfmac/tracepoint.h
+++ b/drivers/net/wireless/brcm80211/brcmfmac/tracepoint.h
@@ -73,6 +73,20 @@ TRACE_EVENT(brcmf_dbg,
 	TP_printk("%s: %s", __get_str(func), __get_str(msg))
 );
 
+TRACE_EVENT(brcmf_hexdump,
+	TP_PROTO(void *data, size_t len),
+	TP_ARGS(data, len),
+	TP_STRUCT__entry(
+		__field(unsigned long, len)
+		__dynamic_array(u8, hdata, len)
+	),
+	TP_fast_assign(
+		__entry->len = len;
+		memcpy(__get_dynamic_array(hdata), data, len);
+	),
+	TP_printk("hexdump [length=%lu]", __entry->len)
+);
+
 #ifdef CONFIG_BRCM_TRACING
 
 #undef TRACE_INCLUDE_PATH
diff --git a/drivers/net/wireless/brcm80211/brcmfmac/wl_cfg80211.c b/drivers/net/wireless/brcm80211/brcmfmac/wl_cfg80211.c
index c7459ae..beba7f6 100644
--- a/drivers/net/wireless/brcm80211/brcmfmac/wl_cfg80211.c
+++ b/drivers/net/wireless/brcm80211/brcmfmac/wl_cfg80211.c
@@ -26,6 +26,7 @@
 #include <brcmu_wifi.h>
 #include "dhd.h"
 #include "dhd_dbg.h"
+#include "tracepoint.h"
 #include "fwil_types.h"
 #include "p2p.h"
 #include "wl_cfg80211.h"
-- 
1.7.10.4


