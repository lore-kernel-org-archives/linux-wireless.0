Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mms1.broadcom.com ([216.31.210.17]:2081 "EHLO mms1.broadcom.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758065Ab1F2XtW (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 29 Jun 2011 19:49:22 -0400
From: "Franky Lin" <frankyl@broadcom.com>
To: gregkh@suse.de
cc: devel@linuxdriverproject.org, linux-wireless@vger.kernel.org
Subject: [PATCH 038/119] staging: brcm80211: remove extern function
 prototypes from c files
Date: Wed, 29 Jun 2011 16:47:02 -0700
Message-ID: <1309391303-22741-39-git-send-email-frankyl@broadcom.com> (sfid-20110630_015230_436632_5A9DC9D6)
In-Reply-To: <1309391303-22741-1-git-send-email-frankyl@broadcom.com>
References: <1309391303-22741-1-git-send-email-frankyl@broadcom.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Arend van Spriel <arend@broadcom.com>

It is not recommended to specify function prototypes in c sources
using the extern keyword. Several occurrences have been removed or
placed in a header file or simply removed as it was already present
in a header file.

Signed-off-by: Arend van Spriel <arend@broadcom.com>
Reviewed-by: Roland Vossen <rvossen@broadcom.com>
Reviewed-by: Franky Lin <frankyl@broadcom.com>
---
 drivers/staging/brcm80211/brcmfmac/dhd.h       |    6 ++++++
 drivers/staging/brcm80211/brcmfmac/dhd_cdc.c   |    2 --
 drivers/staging/brcm80211/brcmfmac/dhd_linux.c |   14 +++-----------
 drivers/staging/brcm80211/brcmfmac/dhd_proto.h |    5 +++++
 drivers/staging/brcm80211/brcmfmac/dhd_sdio.c  |    3 ---
 5 files changed, 14 insertions(+), 16 deletions(-)

diff --git a/drivers/staging/brcm80211/brcmfmac/dhd.h b/drivers/staging/brcm80211/brcmfmac/dhd.h
index 4bedf41..4fcdf9d 100644
--- a/drivers/staging/brcm80211/brcmfmac/dhd.h
+++ b/drivers/staging/brcm80211/brcmfmac/dhd.h
@@ -1021,6 +1021,12 @@ extern int dhd_bus_start(dhd_pub_t *dhdp);
 extern void dhd_wait_for_event(dhd_pub_t *dhd, bool * lockvar);
 extern void dhd_wait_event_wakeup(dhd_pub_t *dhd);
 
+#ifdef PKT_FILTER_SUPPORT
+extern void dhd_pktfilter_offload_set(dhd_pub_t *dhd, char *arg);
+extern void dhd_pktfilter_offload_enable(dhd_pub_t *dhd, char *arg, int enable,
+					 int master_mode);
+#endif
+
 #ifdef BCMDBG
 #define ASSERT(exp) \
 	  do { if (!(exp)) osl_assert(#exp, __FILE__, __LINE__); } while (0)
diff --git a/drivers/staging/brcm80211/brcmfmac/dhd_cdc.c b/drivers/staging/brcm80211/brcmfmac/dhd_cdc.c
index c77c86c..1d94438 100644
--- a/drivers/staging/brcm80211/brcmfmac/dhd_cdc.c
+++ b/drivers/staging/brcm80211/brcmfmac/dhd_cdc.c
@@ -84,8 +84,6 @@ struct bdc_header {
 int wifi_get_mac_addr(unsigned char *buf);
 #endif
 
-extern int dhd_preinit_ioctls(dhd_pub_t *dhd);
-
 /* Packet alignment for most efficient SDIO (can change based on platform) */
 #ifndef DHD_SDALIGN
 #define DHD_SDALIGN	32
diff --git a/drivers/staging/brcm80211/brcmfmac/dhd_linux.c b/drivers/staging/brcm80211/brcmfmac/dhd_linux.c
index f80295e..ed4a296 100644
--- a/drivers/staging/brcm80211/brcmfmac/dhd_linux.c
+++ b/drivers/staging/brcm80211/brcmfmac/dhd_linux.c
@@ -32,6 +32,9 @@
 #include <linux/fs.h>
 #include <linux/uaccess.h>
 #include <net/cfg80211.h>
+#if defined(CONFIG_HAS_EARLYSUSPEND)
+#include <linux/earlysuspend.h>
+#endif
 #include <defs.h>
 #include <brcmu_utils.h>
 #include <brcmu_wifi.h>
@@ -183,17 +186,6 @@ MODULE_DESCRIPTION("Broadcom 802.11n wireless LAN fullmac driver.");
 MODULE_SUPPORTED_DEVICE("Broadcom 802.11n WLAN fullmac cards");
 MODULE_LICENSE("Dual BSD/GPL");
 
-#if defined(CONFIG_HAS_EARLYSUSPEND)
-#include <linux/earlysuspend.h>
-extern int dhdcdc_set_ioctl(dhd_pub_t *dhd, int ifidx, uint cmd, void *buf,
-			    uint len);
-#endif		/* defined(CONFIG_HAS_EARLYSUSPEND) */
-
-#ifdef PKT_FILTER_SUPPORT
-extern void dhd_pktfilter_offload_set(dhd_pub_t *dhd, char *arg);
-extern void dhd_pktfilter_offload_enable(dhd_pub_t *dhd, char *arg, int enable,
-					 int master_mode);
-#endif
 
 /* Interface control information */
 typedef struct dhd_if {
diff --git a/drivers/staging/brcm80211/brcmfmac/dhd_proto.h b/drivers/staging/brcm80211/brcmfmac/dhd_proto.h
index 188b588..f75eb1c 100644
--- a/drivers/staging/brcm80211/brcmfmac/dhd_proto.h
+++ b/drivers/staging/brcm80211/brcmfmac/dhd_proto.h
@@ -71,6 +71,11 @@ extern int dhd_ioctl(dhd_pub_t *dhd_pub, dhd_ioctl_t *ioc, void *buf,
 
 extern int dhd_preinit_ioctls(dhd_pub_t *dhd);
 
+#if defined(CONFIG_HAS_EARLYSUSPEND)
+extern int dhdcdc_set_ioctl(dhd_pub_t *dhd, int ifidx, uint cmd, void *buf,
+			    uint len);
+#endif		/* defined(CONFIG_HAS_EARLYSUSPEND) */
+
 /********************************
  * For version-string expansion *
  */
diff --git a/drivers/staging/brcm80211/brcmfmac/dhd_sdio.c b/drivers/staging/brcm80211/brcmfmac/dhd_sdio.c
index e253cb5..19ac421 100644
--- a/drivers/staging/brcm80211/brcmfmac/dhd_sdio.c
+++ b/drivers/staging/brcm80211/brcmfmac/dhd_sdio.c
@@ -654,9 +654,6 @@ static int tx_packets[NUMPRIO];
 /* Deferred transmit */
 const uint dhd_deferred_tx = 1;
 
-extern uint dhd_watchdog_ms;
-extern void dhd_os_wd_timer(void *bus, uint wdtick);
-
 /* Tx/Rx bounds */
 uint dhd_txbound;
 uint dhd_rxbound;
-- 
1.7.1


