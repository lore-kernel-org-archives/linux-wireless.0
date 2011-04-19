Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mms2.broadcom.com ([216.31.210.18]:3817 "EHLO mms2.broadcom.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753232Ab1DSJBg (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 19 Apr 2011 05:01:36 -0400
From: "Roland Vossen" <rvossen@broadcom.com>
To: gregkh@suse.de
cc: devel@linuxdriverproject.org, linux-wireless@vger.kernel.org
Subject: [PATCH 5/5] staging: brcm80211: moved ASSERT logic to fullmac
 driver
Date: Tue, 19 Apr 2011 11:01:16 +0200
Message-ID: <1303203676-20165-6-git-send-email-rvossen@broadcom.com>
In-Reply-To: <1303203676-20165-1-git-send-email-rvossen@broadcom.com>
References: <1303203676-20165-1-git-send-email-rvossen@broadcom.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Code cleanup. Softmac driver does not use ASSERTs anymore.

Signed-off-by: Roland Vossen <rvossen@broadcom.com>
Reviewed-by: Arend van Spriel <arend@broadcom.com>
---
 drivers/staging/brcm80211/brcmfmac/bcmsdh.c        |    2 +
 drivers/staging/brcm80211/brcmfmac/bcmsdh_linux.c  |    3 +
 .../brcm80211/brcmfmac/bcmsdh_sdmmc_linux.c        |    3 +
 drivers/staging/brcm80211/brcmfmac/dhd.h           |   10 ++++
 drivers/staging/brcm80211/brcmfmac/dhd_pmu.c       |    3 +-
 drivers/staging/brcm80211/brcmfmac/wl_iw.c         |   50 ++++++++++++++++++++
 drivers/staging/brcm80211/include/bcmdefs.h        |    6 --
 drivers/staging/brcm80211/include/bcmutils.h       |   10 ----
 drivers/staging/brcm80211/util/bcmutils.c          |   50 --------------------
 9 files changed, 70 insertions(+), 67 deletions(-)

diff --git a/drivers/staging/brcm80211/brcmfmac/bcmsdh.c b/drivers/staging/brcm80211/brcmfmac/bcmsdh.c
index 282d711..5093564 100644
--- a/drivers/staging/brcm80211/brcmfmac/bcmsdh.c
+++ b/drivers/staging/brcm80211/brcmfmac/bcmsdh.c
@@ -30,6 +30,8 @@
 #include <sbsdio.h>		/* BRCM sdio device core */
 
 #include <sdio.h>		/* sdio spec */
+#include "dngl_stats.h"
+#include "dhd.h"
 
 #define SDIOH_API_ACCESS_RETRY_LIMIT	2
 const uint bcmsdh_msglevel = BCMSDH_ERROR_VAL;
diff --git a/drivers/staging/brcm80211/brcmfmac/bcmsdh_linux.c b/drivers/staging/brcm80211/brcmfmac/bcmsdh_linux.c
index c80d83d..b2968c8 100644
--- a/drivers/staging/brcm80211/brcmfmac/bcmsdh_linux.c
+++ b/drivers/staging/brcm80211/brcmfmac/bcmsdh_linux.c
@@ -43,6 +43,9 @@ extern void dhdsdio_isr(void *args);
 #include <linux/platform_device.h>
 #endif				/* CONFIG_MACH_SANDGATE2G */
 
+#include "dngl_stats.h"
+#include "dhd.h"
+
 /**
  * SDIO Host Controller info
  */
diff --git a/drivers/staging/brcm80211/brcmfmac/bcmsdh_sdmmc_linux.c b/drivers/staging/brcm80211/brcmfmac/bcmsdh_sdmmc_linux.c
index a91684e..2792a4d 100644
--- a/drivers/staging/brcm80211/brcmfmac/bcmsdh_sdmmc_linux.c
+++ b/drivers/staging/brcm80211/brcmfmac/bcmsdh_sdmmc_linux.c
@@ -27,6 +27,9 @@
 #include <linux/mmc/sdio_func.h>
 #include <linux/mmc/sdio_ids.h>
 
+#include "dngl_stats.h"
+#include "dhd.h"
+
 #if !defined(SDIO_VENDOR_ID_BROADCOM)
 #define SDIO_VENDOR_ID_BROADCOM		0x02d0
 #endif				/* !defined(SDIO_VENDOR_ID_BROADCOM) */
diff --git a/drivers/staging/brcm80211/brcmfmac/dhd.h b/drivers/staging/brcm80211/brcmfmac/dhd.h
index 60cf782..99c38dd 100644
--- a/drivers/staging/brcm80211/brcmfmac/dhd.h
+++ b/drivers/staging/brcm80211/brcmfmac/dhd.h
@@ -397,4 +397,14 @@ extern char nv_path[MOD_PARAM_PATHLEN];
 extern void dhd_wait_for_event(dhd_pub_t *dhd, bool * lockvar);
 extern void dhd_wait_event_wakeup(dhd_pub_t *dhd);
 
+extern u32 g_assert_type;
+
+#ifdef BCMDBG
+#define ASSERT(exp) \
+	  do { if (!(exp)) osl_assert(#exp, __FILE__, __LINE__); } while (0)
+extern void osl_assert(char *exp, char *file, int line);
+#else
+#define ASSERT(exp)	do {} while (0)
+#endif  /* defined(BCMDBG) */
+
 #endif				/* _dhd_h_ */
diff --git a/drivers/staging/brcm80211/brcmfmac/dhd_pmu.c b/drivers/staging/brcm80211/brcmfmac/dhd_pmu.c
index f7a1fe1..2318387 100644
--- a/drivers/staging/brcm80211/brcmfmac/dhd_pmu.c
+++ b/drivers/staging/brcm80211/brcmfmac/dhd_pmu.c
@@ -24,7 +24,8 @@
 #include <bcmdevs.h>
 #include <hndsoc.h>
 #include <sbchipc.h>
-
+#include "dngl_stats.h"
+#include "dhd.h"
 #include "dhd_pmu.h"
 #include "siutils_priv.h"
 
diff --git a/drivers/staging/brcm80211/brcmfmac/wl_iw.c b/drivers/staging/brcm80211/brcmfmac/wl_iw.c
index b49957f..7e7a935 100644
--- a/drivers/staging/brcm80211/brcmfmac/wl_iw.c
+++ b/drivers/staging/brcm80211/brcmfmac/wl_iw.c
@@ -119,6 +119,9 @@ iscan_info_t *g_iscan;
 
 static const u8 ether_bcast[ETH_ALEN] = {255, 255, 255, 255, 255, 255};
 
+/* Global ASSERT type flag */
+u32 g_assert_type;
+
 static void wl_iw_timerfunc(unsigned long data);
 static void wl_iw_set_event_mask(struct net_device *dev);
 static int wl_iw_iscan(iscan_info_t *iscan, wlc_ssid_t *ssid, u16 action);
@@ -3742,3 +3745,50 @@ void wl_iw_detach(void)
 
 	g_scan = NULL;
 }
+
+#if defined(BCMDBG)
+void osl_assert(char *exp, char *file, int line)
+{
+	char tempbuf[256];
+	char *basename;
+
+	basename = strrchr(file, '/');
+	/* skip the '/' */
+	if (basename)
+		basename++;
+
+	if (!basename)
+		basename = file;
+
+	snprintf(tempbuf, 256,
+		 "assertion \"%s\" failed: file \"%s\", line %d\n", exp,
+		 basename, line);
+
+	/*
+	 * Print assert message and give it time to
+	 * be written to /var/log/messages
+	 */
+	if (!in_interrupt()) {
+		const int delay = 3;
+		printk(KERN_ERR "%s", tempbuf);
+		printk(KERN_ERR "panic in %d seconds\n", delay);
+		set_current_state(TASK_INTERRUPTIBLE);
+		schedule_timeout(delay * HZ);
+	}
+
+	switch (g_assert_type) {
+	case 0:
+		panic(KERN_ERR "%s", tempbuf);
+		break;
+	case 1:
+		printk(KERN_ERR "%s", tempbuf);
+		BUG();
+		break;
+	case 2:
+		printk(KERN_ERR "%s", tempbuf);
+		break;
+	default:
+		break;
+	}
+}
+#endif				/* defined(BCMDBG) */
diff --git a/drivers/staging/brcm80211/include/bcmdefs.h b/drivers/staging/brcm80211/include/bcmdefs.h
index 854f14f..55631f3 100644
--- a/drivers/staging/brcm80211/include/bcmdefs.h
+++ b/drivers/staging/brcm80211/include/bcmdefs.h
@@ -108,12 +108,6 @@ typedef struct {
 
 #define BCMEXTRAHDROOM 172
 
-#ifdef BCMDBG
-#ifndef BCMDBG_ASSERT
-#define BCMDBG_ASSERT
-#endif	/* BCMDBG_ASSERT */
-#endif	/* BCMDBG */
-
 /* Macros for doing definition and get/set of bitfields
  * Usage example, e.g. a three-bit field (bits 4-6):
  *    #define <NAME>_M	BITFIELD_MASK(3)
diff --git a/drivers/staging/brcm80211/include/bcmutils.h b/drivers/staging/brcm80211/include/bcmutils.h
index 3a6d500..1408d15 100644
--- a/drivers/staging/brcm80211/include/bcmutils.h
+++ b/drivers/staging/brcm80211/include/bcmutils.h
@@ -257,16 +257,6 @@ extern struct sk_buff *pktq_mdeq(struct pktq *pq, uint prec_bmp, int *prec_out);
 #define REG_MAP(pa, size)       (void *)(0)
 #endif
 
-extern u32 g_assert_type;
-
-#if defined(BCMDBG_ASSERT)
-#define ASSERT(exp) \
-	  do { if (!(exp)) osl_assert(#exp, __FILE__, __LINE__); } while (0)
-extern void osl_assert(char *exp, char *file, int line);
-#else
-#define ASSERT(exp)	do {} while (0)
-#endif  /* defined(BCMDBG_ASSERT) */
-
 /* register access macros */
 #if defined(BCMSDIO)
 #ifdef BRCM_FULLMAC
diff --git a/drivers/staging/brcm80211/util/bcmutils.c b/drivers/staging/brcm80211/util/bcmutils.c
index 9d5e627..31be729 100644
--- a/drivers/staging/brcm80211/util/bcmutils.c
+++ b/drivers/staging/brcm80211/util/bcmutils.c
@@ -29,9 +29,6 @@
 #include <bcmdevs.h>
 #include <proto/802.11.h>
 
-/* Global ASSERT type flag */
-u32 g_assert_type;
-
 struct sk_buff *pkt_buf_get_skb(uint len)
 {
 	struct sk_buff *skb;
@@ -1017,50 +1014,3 @@ int bcm_bprintf(struct bcmstrbuf *b, const char *fmt, ...)
 
 	return r;
 }
-
-#if defined(BCMDBG_ASSERT)
-void osl_assert(char *exp, char *file, int line)
-{
-	char tempbuf[256];
-	char *basename;
-
-	basename = strrchr(file, '/');
-	/* skip the '/' */
-	if (basename)
-		basename++;
-
-	if (!basename)
-		basename = file;
-
-	snprintf(tempbuf, 256,
-		 "assertion \"%s\" failed: file \"%s\", line %d\n", exp,
-		 basename, line);
-
-	/*
-	 * Print assert message and give it time to
-	 * be written to /var/log/messages
-	 */
-	if (!in_interrupt()) {
-		const int delay = 3;
-		printk(KERN_ERR "%s", tempbuf);
-		printk(KERN_ERR "panic in %d seconds\n", delay);
-		set_current_state(TASK_INTERRUPTIBLE);
-		schedule_timeout(delay * HZ);
-	}
-
-	switch (g_assert_type) {
-	case 0:
-		panic(KERN_ERR "%s", tempbuf);
-		break;
-	case 1:
-		printk(KERN_ERR "%s", tempbuf);
-		BUG();
-		break;
-	case 2:
-		printk(KERN_ERR "%s", tempbuf);
-		break;
-	default:
-		break;
-	}
-}
-#endif				/* defined(BCMDBG_ASSERT) */
-- 
1.7.1


