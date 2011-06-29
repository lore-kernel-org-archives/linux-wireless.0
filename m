Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mms1.broadcom.com ([216.31.210.17]:2083 "EHLO mms1.broadcom.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757985Ab1F2Xss (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 29 Jun 2011 19:48:48 -0400
From: "Franky Lin" <frankyl@broadcom.com>
To: gregkh@suse.de
cc: devel@linuxdriverproject.org, linux-wireless@vger.kernel.org
Subject: [PATCH 080/119] staging: brcm80211: move debug console related
 code to dhd_sdio.c
Date: Wed, 29 Jun 2011 16:47:44 -0700
Message-ID: <1309391303-22741-81-git-send-email-frankyl@broadcom.com> (sfid-20110630_015031_646811_D653C62D)
In-Reply-To: <1309391303-22741-1-git-send-email-frankyl@broadcom.com>
References: <1309391303-22741-1-git-send-email-frankyl@broadcom.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Debug console functionality is provided by dhd_sdio.c. So the related
variables and iovars should go there as well.

Signed-off-by: Franky Lin <frankyl@broadcom.com>
Reviewed-by: Roland Vossen <rvossen@broadcom.com>
Reviewed-by: Arend van Spriel <arend@broadcom.com>
---
 drivers/staging/brcm80211/brcmfmac/dhd.h        |    5 ---
 drivers/staging/brcm80211/brcmfmac/dhd_bus.h    |    6 ----
 drivers/staging/brcm80211/brcmfmac/dhd_common.c |   27 --------------------
 drivers/staging/brcm80211/brcmfmac/dhd_linux.c  |    6 ----
 drivers/staging/brcm80211/brcmfmac/dhd_sdio.c   |   31 ++++++++++++++++++++++-
 5 files changed, 30 insertions(+), 45 deletions(-)

diff --git a/drivers/staging/brcm80211/brcmfmac/dhd.h b/drivers/staging/brcm80211/brcmfmac/dhd.h
index 2c67df0..e7746f7 100644
--- a/drivers/staging/brcm80211/brcmfmac/dhd.h
+++ b/drivers/staging/brcm80211/brcmfmac/dhd.h
@@ -773,11 +773,6 @@ extern atomic_t brcmf_mmc_suspend;
  * Insmod parameters for debug/test
  */
 
-#if defined(BCMDBG)
-/* Console output poll interval */
-extern uint brcmf_console_ms;
-#endif				/* defined(BCMDBG) */
-
 /* Use interrupts */
 extern uint brcmf_intr;
 
diff --git a/drivers/staging/brcm80211/brcmfmac/dhd_bus.h b/drivers/staging/brcm80211/brcmfmac/dhd_bus.h
index 5bbe09d..eab5cdd 100644
--- a/drivers/staging/brcm80211/brcmfmac/dhd_bus.h
+++ b/drivers/staging/brcm80211/brcmfmac/dhd_bus.h
@@ -58,12 +58,6 @@ brcmf_sdbrcm_bus_txctl(struct dhd_bus *bus, unsigned char *msg, uint msglen);
 extern int
 brcmf_sdbrcm_bus_rxctl(struct dhd_bus *bus, unsigned char *msg, uint msglen);
 
-#ifdef BCMDBG
-/* Device console input function */
-extern int
-brcmf_sdbrcm_bus_console_in(dhd_pub_t *dhd, unsigned char *msg, uint msglen);
-#endif				/* BCMDBG */
-
 /* Deferred processing for the bus, return true requests reschedule */
 extern bool dhd_bus_dpc(struct dhd_bus *bus);
 extern void dhd_bus_isr(bool *InterruptRecognized,
diff --git a/drivers/staging/brcm80211/brcmfmac/dhd_common.c b/drivers/staging/brcm80211/brcmfmac/dhd_common.c
index 38a3502..8a32e88 100644
--- a/drivers/staging/brcm80211/brcmfmac/dhd_common.c
+++ b/drivers/staging/brcm80211/brcmfmac/dhd_common.c
@@ -53,10 +53,6 @@ enum {
 	IOV_BCMERRORSTR,
 	IOV_BCMERROR,
 	IOV_DUMP,
-#ifdef BCMDBG
-	IOV_CONS,
-	IOV_DCONSOLE_POLL,
-#endif
 	IOV_CLEARCOUNTS,
 	IOV_LOGDUMP,
 	IOV_LOGCAL,
@@ -79,12 +75,6 @@ const struct brcmu_iovar brcmf_iovars[] = {
 	,
 	{"dump", IOV_DUMP, 0, IOVT_BUFFER, DHD_IOCTL_MAXLEN}
 	,
-#ifdef BCMDBG
-	{"dconpoll", IOV_DCONSOLE_POLL, 0, IOVT_UINT32, 0}
-	,
-	{"cons", IOV_CONS, 0, IOVT_BUFFER, 0}
-	,
-#endif
 	{"clearcounts", IOV_CLEARCOUNTS, 0, IOVT_VOID, 0}
 	,
 	{"gpioob", IOV_GPIOOB, 0, IOVT_UINT32, 0}
@@ -238,23 +228,6 @@ brcmf_c_doiovar(dhd_pub_t *dhd_pub, const struct brcmu_iovar *vi, u32 actionid,
 		bcmerror = brcmf_c_dump(dhd_pub, arg, len);
 		break;
 
-#ifdef BCMDBG
-	case IOV_GVAL(IOV_DCONSOLE_POLL):
-		int_val = (s32) brcmf_console_ms;
-		memcpy(arg, &int_val, val_size);
-		break;
-
-	case IOV_SVAL(IOV_DCONSOLE_POLL):
-		brcmf_console_ms = (uint) int_val;
-		break;
-
-	case IOV_SVAL(IOV_CONS):
-		if (len > 0)
-			bcmerror = brcmf_sdbrcm_bus_console_in(dhd_pub, arg,
-							       len - 1);
-		break;
-#endif
-
 	case IOV_SVAL(IOV_CLEARCOUNTS):
 		dhd_pub->tx_packets = dhd_pub->rx_packets = 0;
 		dhd_pub->tx_errors = dhd_pub->rx_errors = 0;
diff --git a/drivers/staging/brcm80211/brcmfmac/dhd_linux.c b/drivers/staging/brcm80211/brcmfmac/dhd_linux.c
index abd829d..8491b4e 100644
--- a/drivers/staging/brcm80211/brcmfmac/dhd_linux.c
+++ b/drivers/staging/brcm80211/brcmfmac/dhd_linux.c
@@ -124,12 +124,6 @@ module_param(brcmf_msg_level, int, 0);
 uint brcmf_sysioc = true;
 module_param(brcmf_sysioc, uint, 0);
 
-#ifdef BCMDBG
-/* Console poll interval */
-uint brcmf_console_ms;
-module_param(brcmf_console_ms, uint, 0);
-#endif				/* BCMDBG */
-
 /* ARP offload agent mode : Enable ARP Host Auto-Reply
 and ARP Peer Auto-Reply */
 uint brcmf_arp_mode = 0xb;
diff --git a/drivers/staging/brcm80211/brcmfmac/dhd_sdio.c b/drivers/staging/brcm80211/brcmfmac/dhd_sdio.c
index aeef2dc..b79e5cd 100644
--- a/drivers/staging/brcm80211/brcmfmac/dhd_sdio.c
+++ b/drivers/staging/brcm80211/brcmfmac/dhd_sdio.c
@@ -659,6 +659,12 @@ module_param(brcmf_watchdog_prio, int, 0);
 uint brcmf_watchdog_ms = 10;
 module_param(brcmf_watchdog_ms, uint, 0);
 
+#ifdef BCMDBG
+/* Console poll interval */
+uint brcmf_console_ms;
+module_param(brcmf_console_ms, uint, 0);
+#endif		/* DHD_DEBUG */
+
 /* Tx/Rx bounds */
 uint brcmf_txbound;
 uint brcmf_rxbound;
@@ -757,6 +763,8 @@ static void brcmf_sdbrcm_sdtest_set(dhd_bus_t *bus, bool start);
 #endif
 
 #ifdef BCMDBG
+static int brcmf_sdbrcm_bus_console_in(dhd_pub_t *dhdp, unsigned char *msg,
+				       uint msglen);
 static int brcmf_sdbrcm_checkdied(dhd_bus_t *bus, u8 *data, uint size);
 static int brcmf_sdbrcm_mem_dump(dhd_bus_t *bus);
 #endif				/* BCMDBG  */
@@ -1665,6 +1673,8 @@ enum {
 	IOV_MEMSIZE,
 #ifdef BCMDBG
 	IOV_CHECKDIED,
+	IOV_CONS,
+	IOV_DCONSOLE_POLL,
 #endif
 	IOV_DOWNLOAD,
 	IOV_FORCEEVEN,
@@ -1710,6 +1720,10 @@ const struct brcmu_iovar dhdsdio_iovars[] = {
 	{"devreset", IOV_DEVRESET, 0, IOVT_BOOL, 0},
 	{"wdtick", IOV_WDTICK, 0, IOVT_UINT32, 0},
 #ifdef BCMDBG
+	{"cons", IOV_CONS, 0, IOVT_BUFFER, 0}
+	,
+	{"dconpoll", IOV_DCONSOLE_POLL, 0, IOVT_UINT32, 0}
+	,
 	{"sdreg", IOV_SDREG, 0, IOVT_BUFFER, sizeof(struct brcmf_sdreg)}
 	,
 	{"sbreg", IOV_SBREG, 0, IOVT_BUFFER, sizeof(struct brcmf_sdreg)}
@@ -2559,6 +2573,21 @@ brcmf_sdbrcm_doiovar(dhd_bus_t *bus, const struct brcmu_iovar *vi, u32 actionid,
 #endif				/* BCMDBG */
 
 #ifdef BCMDBG
+	case IOV_GVAL(IOV_DCONSOLE_POLL):
+		int_val = (s32) brcmf_console_ms;
+		memcpy(arg, &int_val, val_size);
+		break;
+
+	case IOV_SVAL(IOV_DCONSOLE_POLL):
+		brcmf_console_ms = (uint) int_val;
+		break;
+
+	case IOV_SVAL(IOV_CONS):
+		if (len > 0)
+			bcmerror = brcmf_sdbrcm_bus_console_in(bus->dhd,
+							       arg, len - 1);
+		break;
+
 	case IOV_GVAL(IOV_SDREG):
 		{
 			struct brcmf_sdreg *sd_ptr;
@@ -5100,7 +5129,7 @@ extern bool brcmf_sdbrcm_bus_watchdog(dhd_pub_t *dhdp)
 }
 
 #ifdef BCMDBG
-extern int brcmf_sdbrcm_bus_console_in(dhd_pub_t *dhdp, unsigned char *msg,
+static int brcmf_sdbrcm_bus_console_in(dhd_pub_t *dhdp, unsigned char *msg,
 				       uint msglen)
 {
 	dhd_bus_t *bus = dhdp->bus;
-- 
1.7.1


