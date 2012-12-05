Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mms2.broadcom.com ([216.31.210.18]:2498 "EHLO mms2.broadcom.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754156Ab2LEO0a (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 5 Dec 2012 09:26:30 -0500
From: "Arend van Spriel" <arend@broadcom.com>
To: "John W. Linville" <linville@tuxdriver.com>
cc: "Linux Wireless List" <linux-wireless@vger.kernel.org>,
	"Arend van Spriel" <arend@broadcom.com>
Subject: [PATCH 06/11] brcmfmac: consolidate debug macros in wl_cfg80211
Date: Wed, 5 Dec 2012 15:25:59 +0100
Message-ID: <1354717564-7183-7-git-send-email-arend@broadcom.com> (sfid-20121205_152645_792476_358197E2)
In-Reply-To: <1354717564-7183-1-git-send-email-arend@broadcom.com>
References: <1354717564-7183-1-git-send-email-arend@broadcom.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

The source file wl_cfg80211.c has its own debug macros and levels.
This patch maps the macros to the ones used in the rest of the
brcmfmac driver.

Reviewed-by: Hante Meuleman <meuleman@broadcom.com>
Reviewed-by: Pieter-Paul Giesberts <pieterpg@broadcom.com>
Signed-off-by: Arend van Spriel <arend@broadcom.com>
---
 drivers/net/wireless/brcm80211/brcmfmac/dhd_dbg.h  |    2 +
 .../net/wireless/brcm80211/brcmfmac/wl_cfg80211.c  |    2 -
 .../net/wireless/brcm80211/brcmfmac/wl_cfg80211.h  |   74 +++-----------------
 3 files changed, 10 insertions(+), 68 deletions(-)

diff --git a/drivers/net/wireless/brcm80211/brcmfmac/dhd_dbg.h b/drivers/net/wireless/brcm80211/brcmfmac/dhd_dbg.h
index eb1d8d5..3145456 100644
--- a/drivers/net/wireless/brcm80211/brcmfmac/dhd_dbg.h
+++ b/drivers/net/wireless/brcm80211/brcmfmac/dhd_dbg.h
@@ -31,6 +31,8 @@
 #define BRCMF_BTA_VAL	0x0800
 #define BRCMF_FIL_VAL	0x1000
 #define BRCMF_USB_VAL	0x2000
+#define BRCMF_SCAN_VAL	0x4000
+#define BRCMF_CONN_VAL	0x8000
 
 /* error messages are always logged */
 #define brcmf_err(fmt, ...)	pr_err("%s: " fmt, __func__, ##__VA_ARGS__)
diff --git a/drivers/net/wireless/brcm80211/brcmfmac/wl_cfg80211.c b/drivers/net/wireless/brcm80211/brcmfmac/wl_cfg80211.c
index 4ddd58f..b321813 100644
--- a/drivers/net/wireless/brcm80211/brcmfmac/wl_cfg80211.c
+++ b/drivers/net/wireless/brcm80211/brcmfmac/wl_cfg80211.c
@@ -87,8 +87,6 @@
 #define BRCMF_ASSOC_PARAMS_FIXED_SIZE \
 	(sizeof(struct brcmf_assoc_params_le) - sizeof(u16))
 
-static u32 brcmf_dbg_level = WL_DBG_ERR;
-
 static bool check_vif_up(struct brcmf_cfg80211_vif *vif)
 {
 	if (!test_bit(BRCMF_VIF_STATUS_READY, &vif->sme_state)) {
diff --git a/drivers/net/wireless/brcm80211/brcmfmac/wl_cfg80211.h b/drivers/net/wireless/brcm80211/brcmfmac/wl_cfg80211.h
index c163e4d..0e70520 100644
--- a/drivers/net/wireless/brcm80211/brcmfmac/wl_cfg80211.h
+++ b/drivers/net/wireless/brcm80211/brcmfmac/wl_cfg80211.h
@@ -17,72 +17,14 @@
 #ifndef _wl_cfg80211_h_
 #define _wl_cfg80211_h_
 
-#define WL_DBG_NONE		0
-#define WL_DBG_CONN		(1 << 5)
-#define WL_DBG_SCAN		(1 << 4)
-#define WL_DBG_TRACE		(1 << 3)
-#define WL_DBG_INFO		(1 << 1)
-#define WL_DBG_ERR		(1 << 0)
-#define WL_DBG_MASK		((WL_DBG_INFO | WL_DBG_ERR | WL_DBG_TRACE) | \
-				(WL_DBG_SCAN) | (WL_DBG_CONN))
-
-#define	WL_ERR(fmt, ...)					\
-do {								\
-	if (brcmf_dbg_level & WL_DBG_ERR) {			\
-		if (net_ratelimit()) {				\
-			pr_err("ERROR @%s : " fmt,		\
-			       __func__, ##__VA_ARGS__);	\
-		}						\
-	}							\
-} while (0)
-
-#if (defined DEBUG)
-#define	WL_INFO(fmt, ...)					\
-do {								\
-	if (brcmf_dbg_level & WL_DBG_INFO) {			\
-		if (net_ratelimit()) {				\
-			pr_err("INFO @%s : " fmt,		\
-			       __func__, ##__VA_ARGS__);	\
-		}						\
-	}							\
-} while (0)
-
-#define	WL_TRACE(fmt, ...)					\
-do {								\
-	if (brcmf_dbg_level & WL_DBG_TRACE) {			\
-		if (net_ratelimit()) {				\
-			pr_err("TRACE @%s : " fmt,		\
-			       __func__, ##__VA_ARGS__);	\
-		}						\
-	}							\
-} while (0)
-
-#define	WL_SCAN(fmt, ...)					\
-do {								\
-	if (brcmf_dbg_level & WL_DBG_SCAN) {			\
-		if (net_ratelimit()) {				\
-			pr_err("SCAN @%s : " fmt,		\
-			       __func__, ##__VA_ARGS__);	\
-		}						\
-	}							\
-} while (0)
-
-#define	WL_CONN(fmt, ...)					\
-do {								\
-	if (brcmf_dbg_level & WL_DBG_CONN) {			\
-		if (net_ratelimit()) {				\
-			pr_err("CONN @%s : " fmt,		\
-			       __func__, ##__VA_ARGS__);	\
-		}						\
-	}							\
-} while (0)
-
-#else /* (defined DEBUG) */
-#define	WL_INFO(fmt, args...)
-#define	WL_TRACE(fmt, args...)
-#define	WL_SCAN(fmt, args...)
-#define	WL_CONN(fmt, args...)
-#endif /* (defined DEBUG) */
+#include "dhd_dbg.h"
+
+#define	WL_ERR(fmt, ...)	brcmf_err(fmt, ##__VA_ARGS__)
+
+#define	WL_INFO(fmt, ...)	brcmf_dbg(INFO, fmt, ##__VA_ARGS__)
+#define	WL_TRACE(fmt, ...)	brcmf_dbg(TRACE, fmt, ##__VA_ARGS__)
+#define	WL_SCAN(fmt, ...)	brcmf_dbg(SCAN, fmt, ##__VA_ARGS__)
+#define	WL_CONN(fmt, ...)	brcmf_dbg(CONN, fmt, ##__VA_ARGS__)
 
 #define WL_NUM_SCAN_MAX			10
 #define WL_NUM_PMKIDS_MAX		MAXPMKID
-- 
1.7.9.5


