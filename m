Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mms2.broadcom.com ([216.31.210.18]:4518 "EHLO mms2.broadcom.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758215Ab1F2Xtf (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 29 Jun 2011 19:49:35 -0400
From: "Franky Lin" <frankyl@broadcom.com>
To: gregkh@suse.de
cc: devel@linuxdriverproject.org, linux-wireless@vger.kernel.org
Subject: [PATCH 044/119] staging: brcm80211: rename module parameters
Date: Wed, 29 Jun 2011 16:47:08 -0700
Message-ID: <1309391303-22741-45-git-send-email-frankyl@broadcom.com> (sfid-20110630_015300_230796_E52778C0)
In-Reply-To: <1309391303-22741-1-git-send-email-frankyl@broadcom.com>
References: <1309391303-22741-1-git-send-email-frankyl@broadcom.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Arend van Spriel <arend@broadcom.com>

Fullmac source is renamed to be consistent throughout the driver. This
commit renames the modules parameters for module loading.

Signed-off-by: Arend van Spriel <arend@broadcom.com>
Reviewed-by: Roland Vossen <rvossen@broadcom.com>
Reviewed-by: Franky Lin <frankyl@broadcom.com>
---
 drivers/staging/brcm80211/brcmfmac/dhd.h         |   40 ++++++------
 drivers/staging/brcm80211/brcmfmac/dhd_common.c  |   23 ++++---
 drivers/staging/brcm80211/brcmfmac/dhd_linux.c   |   78 +++++++++++-----------
 drivers/staging/brcm80211/brcmfmac/dhd_sdio.c    |   49 +++++++-------
 drivers/staging/brcm80211/brcmfmac/wl_cfg80211.c |    2 +-
 5 files changed, 97 insertions(+), 95 deletions(-)

diff --git a/drivers/staging/brcm80211/brcmfmac/dhd.h b/drivers/staging/brcm80211/brcmfmac/dhd.h
index 1145e5b..46381bb 100644
--- a/drivers/staging/brcm80211/brcmfmac/dhd.h
+++ b/drivers/staging/brcm80211/brcmfmac/dhd.h
@@ -775,57 +775,57 @@ extern atomic_t dhd_mmc_suspend;
  */
 
 /* Watchdog timer interval */
-extern uint dhd_watchdog_ms;
+extern uint brcmf_watchdog_ms;
 
 #if defined(DHD_DEBUG)
 /* Console output poll interval */
-extern uint dhd_console_ms;
+extern uint brcmf_console_ms;
 #endif				/* defined(DHD_DEBUG) */
 
 /* Use interrupts */
-extern uint dhd_intr;
+extern uint brcmf_intr;
 
 /* Use polling */
-extern uint dhd_poll;
+extern uint brcmf_poll;
 
 /* ARP offload agent mode */
-extern uint dhd_arp_mode;
+extern uint brcmf_arp_mode;
 
 /* ARP offload enable */
-extern uint dhd_arp_enable;
+extern uint brcmf_arp_enable;
 
 /* Pkt filte enable control */
-extern uint dhd_pkt_filter_enable;
+extern uint brcmf_pkt_filter_enable;
 
 /*  Pkt filter init setup */
-extern uint dhd_pkt_filter_init;
+extern uint brcmf_pkt_filter_init;
 
 /* Pkt filter mode control */
-extern uint dhd_master_mode;
+extern uint brcmf_master_mode;
 
 /* Roaming mode control */
-extern uint dhd_roam;
+extern uint brcmf_roam;
 
 /* Roaming mode control */
-extern uint dhd_radio_up;
+extern uint brcmf_radio_up;
 
 /* Initial idletime ticks (may be -1 for immediate idle, 0 for no idle) */
-extern int dhd_idletime;
-#define DHD_IDLETIME_TICKS 1
+extern int brcmf_idletime;
+#define BRCMF_IDLETIME_TICKS 1
 
 /* SDIO Drive Strength */
-extern uint dhd_sdiod_drive_strength;
+extern uint brcmf_sdiod_drive_strength;
 
 /* Override to force tx queueing all the time */
-extern uint dhd_force_tx_queueing;
+extern uint brcmf_force_tx_queueing;
 
 #ifdef SDTEST
 /* Echo packet generator (SDIO), pkts/s */
-extern uint dhd_pktgen;
+extern uint brcmf_pktgen;
 
 /* Echo packet len (0 => sawtooth, max 1800) */
-extern uint dhd_pktgen_len;
-#define MAX_PKTGEN_LEN 1800
+extern uint brcmf_pktgen_len;
+#define BRCMF_MAX_PKTGEN_LEN 1800
 #endif
 
 extern char brcmf_fw_path[MOD_PARAM_PATHLEN];
@@ -1032,7 +1032,7 @@ typedef struct dhd_ioctl {
 
 #ifdef SDTEST
 /* For pktgen iovar */
-typedef struct dhd_pktgen {
+typedef struct brcmf_pktgen {
 	uint version;		/* To allow structure change tracking */
 	uint freq;		/* Max ticks between tx/rx attempts */
 	uint count;		/* Test packets to send/rcv each attempt */
@@ -1045,7 +1045,7 @@ typedef struct dhd_pktgen {
 	uint numfail;		/* Count of test send failures */
 	uint mode;		/* Test mode (type of test packets) */
 	uint stop;		/* Stop after this many tx failures */
-} dhd_pktgen_t;
+} brcmf_pktgen_t;
 
 /* Version in case structure changes */
 #define DHD_PKTGEN_VERSION 2
diff --git a/drivers/staging/brcm80211/brcmfmac/dhd_common.c b/drivers/staging/brcm80211/brcmfmac/dhd_common.c
index b06d7e0..9d604a6 100644
--- a/drivers/staging/brcm80211/brcmfmac/dhd_common.c
+++ b/drivers/staging/brcm80211/brcmfmac/dhd_common.c
@@ -253,7 +253,7 @@ brcmf_c_doiovar(dhd_pub_t *dhd_pub, const struct brcmu_iovar *vi, u32 actionid,
 		break;
 
 	case IOV_GVAL(IOV_WDTICK):
-		int_val = (s32) dhd_watchdog_ms;
+		int_val = (s32) brcmf_watchdog_ms;
 		memcpy(arg, &int_val, val_size);
 		break;
 
@@ -271,12 +271,12 @@ brcmf_c_doiovar(dhd_pub_t *dhd_pub, const struct brcmu_iovar *vi, u32 actionid,
 
 #ifdef DHD_DEBUG
 	case IOV_GVAL(IOV_DCONSOLE_POLL):
-		int_val = (s32) dhd_console_ms;
+		int_val = (s32) brcmf_console_ms;
 		memcpy(arg, &int_val, val_size);
 		break;
 
 	case IOV_SVAL(IOV_DCONSOLE_POLL):
-		dhd_console_ms = (uint) int_val;
+		brcmf_console_ms = (uint) int_val;
 		break;
 
 	case IOV_SVAL(IOV_CONS):
@@ -1271,11 +1271,12 @@ int brcmf_c_preinit_ioctls(dhd_pub_t *dhd)
 
 	/* Enable/Disable build-in roaming to allowed ext supplicant to take
 		 of romaing */
-	brcmu_mkiovar("roam_off", (char *)&dhd_roam, 4, iovbuf, sizeof(iovbuf));
+	brcmu_mkiovar("roam_off", (char *)&brcmf_roam, 4,
+		      iovbuf, sizeof(iovbuf));
 	dhdcdc_set_ioctl(dhd, 0, BRCMF_C_SET_VAR, iovbuf, sizeof(iovbuf));
 
 	/* Force STA UP */
-	if (dhd_radio_up)
+	if (brcmf_radio_up)
 		dhdcdc_set_ioctl(dhd, 0, BRCMF_C_UP, (char *)&up, sizeof(up));
 
 	/* Setup event_msgs */
@@ -1290,23 +1291,23 @@ int brcmf_c_preinit_ioctls(dhd_pub_t *dhd)
 
 #ifdef ARP_OFFLOAD_SUPPORT
 	/* Set and enable ARP offload feature */
-	if (dhd_arp_enable)
-		brcmf_c_arp_offload_set(dhd, dhd_arp_mode);
-	brcmf_c_arp_offload_enable(dhd, dhd_arp_enable);
+	if (brcmf_arp_enable)
+		brcmf_c_arp_offload_set(dhd, brcmf_arp_mode);
+	brcmf_c_arp_offload_enable(dhd, brcmf_arp_enable);
 #endif				/* ARP_OFFLOAD_SUPPORT */
 
 #ifdef PKT_FILTER_SUPPORT
 	{
 		int i;
 		/* Set up pkt filter */
-		if (dhd_pkt_filter_enable) {
+		if (brcmf_pkt_filter_enable) {
 			for (i = 0; i < dhd->pktfilter_count; i++) {
 				brcmf_c_pktfilter_offload_set(dhd,
 							  dhd->pktfilter[i]);
 				brcmf_c_pktfilter_offload_enable(dhd,
 				     dhd->pktfilter[i],
-				     dhd_pkt_filter_init,
-				     dhd_master_mode);
+				     brcmf_pkt_filter_init,
+				     brcmf_master_mode);
 			}
 		}
 	}
diff --git a/drivers/staging/brcm80211/brcmfmac/dhd_linux.c b/drivers/staging/brcm80211/brcmfmac/dhd_linux.c
index c6cae48..2d4e2c7 100644
--- a/drivers/staging/brcm80211/brcmfmac/dhd_linux.c
+++ b/drivers/staging/brcm80211/brcmfmac/dhd_linux.c
@@ -259,35 +259,35 @@ uint dhd_sysioc = true;
 module_param(dhd_sysioc, uint, 0);
 
 /* Watchdog interval */
-uint dhd_watchdog_ms = 10;
-module_param(dhd_watchdog_ms, uint, 0);
+uint brcmf_watchdog_ms = 10;
+module_param(brcmf_watchdog_ms, uint, 0);
 
 #ifdef DHD_DEBUG
 /* Console poll interval */
-uint dhd_console_ms;
-module_param(dhd_console_ms, uint, 0);
+uint brcmf_console_ms;
+module_param(brcmf_console_ms, uint, 0);
 #endif				/* DHD_DEBUG */
 
 /* ARP offload agent mode : Enable ARP Host Auto-Reply
 and ARP Peer Auto-Reply */
-uint dhd_arp_mode = 0xb;
-module_param(dhd_arp_mode, uint, 0);
+uint brcmf_arp_mode = 0xb;
+module_param(brcmf_arp_mode, uint, 0);
 
 /* ARP offload enable */
-uint dhd_arp_enable = true;
-module_param(dhd_arp_enable, uint, 0);
+uint brcmf_arp_enable = true;
+module_param(brcmf_arp_enable, uint, 0);
 
 /* Global Pkt filter enable control */
-uint dhd_pkt_filter_enable = true;
-module_param(dhd_pkt_filter_enable, uint, 0);
+uint brcmf_pkt_filter_enable = true;
+module_param(brcmf_pkt_filter_enable, uint, 0);
 
 /*  Pkt filter init setup */
-uint dhd_pkt_filter_init;
-module_param(dhd_pkt_filter_init, uint, 0);
+uint brcmf_pkt_filter_init;
+module_param(brcmf_pkt_filter_init, uint, 0);
 
 /* Pkt filter mode control */
-uint dhd_master_mode = true;
-module_param(dhd_master_mode, uint, 1);
+uint brcmf_master_mode = true;
+module_param(brcmf_master_mode, uint, 1);
 
 /* Watchdog thread priority, -1 to use kernel timer */
 int dhd_watchdog_prio = 97;
@@ -303,13 +303,13 @@ module_param(dhd_dongle_memsize, int, 0);
 
 /* Contorl fw roaming */
 #ifdef CUSTOMER_HW2
-uint dhd_roam;
+uint brcmf_roam;
 #else
-uint dhd_roam = 1;
+uint brcmf_roam = 1;
 #endif
 
 /* Control radio state */
-uint dhd_radio_up = 1;
+uint brcmf_radio_up = 1;
 
 /* Network inteface name */
 char iface_name[IFNAMSIZ] = "wlan";
@@ -321,20 +321,20 @@ module_param_string(iface_name, iface_name, IFNAMSIZ, 0);
 int dhd_ioctl_timeout_msec = IOCTL_RESP_TIMEOUT;
 
 /* Idle timeout for backplane clock */
-int dhd_idletime = DHD_IDLETIME_TICKS;
-module_param(dhd_idletime, int, 0);
+int brcmf_idletime = BRCMF_IDLETIME_TICKS;
+module_param(brcmf_idletime, int, 0);
 
 /* Use polling */
-uint dhd_poll;
-module_param(dhd_poll, uint, 0);
+uint brcmf_poll;
+module_param(brcmf_poll, uint, 0);
 
 /* Use interrupts */
-uint dhd_intr = true;
-module_param(dhd_intr, uint, 0);
+uint brcmf_intr = true;
+module_param(brcmf_intr, uint, 0);
 
 /* SDIO Drive Strength (in milliamps) */
-uint dhd_sdiod_drive_strength = 6;
-module_param(dhd_sdiod_drive_strength, uint, 0);
+uint brcmf_sdiod_drive_strength = 6;
+module_param(brcmf_sdiod_drive_strength, uint, 0);
 
 /* Tx/Rx bounds */
 extern uint dhd_txbound;
@@ -348,12 +348,12 @@ module_param(dhd_deferred_tx, uint, 0);
 
 #ifdef SDTEST
 /* Echo packet generator (pkts/s) */
-uint dhd_pktgen;
-module_param(dhd_pktgen, uint, 0);
+uint brcmf_pktgen;
+module_param(brcmf_pktgen, uint, 0);
 
 /* Echo packet len (0 => sawtooth, max 2040) */
-uint dhd_pktgen_len;
-module_param(dhd_pktgen_len, uint, 0);
+uint brcmf_pktgen_len;
+module_param(brcmf_pktgen_len, uint, 0);
 #endif
 
 /* Version string to report */
@@ -384,13 +384,13 @@ static void dhd_set_packet_filter(int value, dhd_pub_t *dhd)
 	DHD_TRACE(("%s: %d\n", __func__, value));
 	/* 1 - Enable packet filter, only allow unicast packet to send up */
 	/* 0 - Disable packet filter */
-	if (dhd_pkt_filter_enable) {
+	if (brcmf_pkt_filter_enable) {
 		int i;
 
 		for (i = 0; i < dhd->pktfilter_count; i++) {
 			brcmf_c_pktfilter_offload_set(dhd, dhd->pktfilter[i]);
 			brcmf_c_pktfilter_offload_enable(dhd, dhd->pktfilter[i],
-						     value, dhd_master_mode);
+						     value, brcmf_master_mode);
 		}
 	}
 #endif
@@ -1276,7 +1276,7 @@ static void dhd_watchdog(unsigned long data)
 		/* Reschedule the watchdog */
 		if (dhd->wd_timer_valid) {
 			mod_timer(&dhd->timer,
-				  jiffies + dhd_watchdog_ms * HZ / 1000);
+				  jiffies + brcmf_watchdog_ms * HZ / 1000);
 		}
 		return;
 	}
@@ -1289,7 +1289,7 @@ static void dhd_watchdog(unsigned long data)
 
 	/* Reschedule the watchdog */
 	if (dhd->wd_timer_valid)
-		mod_timer(&dhd->timer, jiffies + dhd_watchdog_ms * HZ / 1000);
+		mod_timer(&dhd->timer, jiffies + brcmf_watchdog_ms * HZ / 1000);
 }
 
 static int dhd_dpc_thread(void *data)
@@ -1992,7 +1992,7 @@ int dhd_bus_start(dhd_pub_t *dhdp)
 
 	/* Start the watchdog timer */
 	dhd->pub.tickcnt = 0;
-	dhd_os_wd_timer(&dhd->pub, dhd_watchdog_ms);
+	dhd_os_wd_timer(&dhd->pub, brcmf_watchdog_ms);
 
 	/* Bring up the bus */
 	ret = brcmf_sdbrcm_bus_init(&dhd->pub, true);
@@ -2403,9 +2403,9 @@ void dhd_os_wd_timer(void *bus, uint wdtick)
 	}
 
 	if (wdtick) {
-		dhd_watchdog_ms = (uint) wdtick;
+		brcmf_watchdog_ms = (uint) wdtick;
 
-		if (save_dhd_watchdog_ms != dhd_watchdog_ms) {
+		if (save_dhd_watchdog_ms != brcmf_watchdog_ms) {
 
 			if (dhd->wd_timer_valid == true)
 				/* Stop timer and restart at new value */
@@ -2415,13 +2415,13 @@ void dhd_os_wd_timer(void *bus, uint wdtick)
 			   dynamically changed or in the first instance
 			 */
 			dhd->timer.expires =
-			    jiffies + dhd_watchdog_ms * HZ / 1000;
+			    jiffies + brcmf_watchdog_ms * HZ / 1000;
 			add_timer(&dhd->timer);
 
 		} else {
 			/* Re arm the timer, at last watchdog period */
 			mod_timer(&dhd->timer,
-				  jiffies + dhd_watchdog_ms * HZ / 1000);
+				  jiffies + brcmf_watchdog_ms * HZ / 1000);
 		}
 
 		dhd->wd_timer_valid = true;
@@ -2558,7 +2558,7 @@ int dhd_dev_reset(struct net_device *dev, u8 flag)
 
 	/* Turning on watchdog back */
 	if (!flag)
-		dhd_os_wd_timer(&dhd->pub, dhd_watchdog_ms);
+		dhd_os_wd_timer(&dhd->pub, brcmf_watchdog_ms);
 	DHD_ERROR(("%s:  WLAN OFF DONE\n", __func__));
 
 	return 1;
diff --git a/drivers/staging/brcm80211/brcmfmac/dhd_sdio.c b/drivers/staging/brcm80211/brcmfmac/dhd_sdio.c
index 7e7d288..5ce62fe 100644
--- a/drivers/staging/brcm80211/brcmfmac/dhd_sdio.c
+++ b/drivers/staging/brcm80211/brcmfmac/dhd_sdio.c
@@ -999,7 +999,7 @@ static int brcmf_sdbrcm_clkctl(dhd_bus_t *bus, uint target, bool pendok)
 	/* Early exit if we're already there */
 	if (bus->clkstate == target) {
 		if (target == CLK_AVAIL) {
-			dhd_os_wd_timer(bus->dhd, dhd_watchdog_ms);
+			dhd_os_wd_timer(bus->dhd, brcmf_watchdog_ms);
 			bus->activity = true;
 		}
 		return 0;
@@ -1012,7 +1012,7 @@ static int brcmf_sdbrcm_clkctl(dhd_bus_t *bus, uint target, bool pendok)
 			brcmf_sdbrcm_sdclk(bus, true);
 		/* Now request HT Avail on the backplane */
 		brcmf_sdbrcm_htclk(bus, true, pendok);
-		dhd_os_wd_timer(bus->dhd, dhd_watchdog_ms);
+		dhd_os_wd_timer(bus->dhd, brcmf_watchdog_ms);
 		bus->activity = true;
 		break;
 
@@ -1025,7 +1025,7 @@ static int brcmf_sdbrcm_clkctl(dhd_bus_t *bus, uint target, bool pendok)
 		else
 			DHD_ERROR(("brcmf_sdbrcm_clkctl: request for %d -> %d"
 				   "\n", bus->clkstate, target));
-		dhd_os_wd_timer(bus->dhd, dhd_watchdog_ms);
+		dhd_os_wd_timer(bus->dhd, brcmf_watchdog_ms);
 		break;
 
 	case CLK_NONE:
@@ -1781,7 +1781,7 @@ const struct brcmu_iovar dhdsdio_iovars[] = {
 #ifdef SDTEST
 	{"extloop", IOV_EXTLOOP, 0, IOVT_BOOL, 0}
 	,
-	{"pktgen", IOV_PKTGEN, 0, IOVT_BUFFER, sizeof(dhd_pktgen_t)}
+	{"pktgen", IOV_PKTGEN, 0, IOVT_BUFFER, sizeof(brcmf_pktgen_t)}
 	,
 #endif				/* SDTEST */
 
@@ -1918,7 +1918,7 @@ void dhd_bus_clearcounts(dhd_pub_t *dhdp)
 #ifdef SDTEST
 static int brcmf_sdbrcm_pktgen_get(dhd_bus_t *bus, u8 *arg)
 {
-	dhd_pktgen_t pktgen;
+	brcmf_pktgen_t pktgen;
 
 	pktgen.version = DHD_PKTGEN_VERSION;
 	pktgen.freq = bus->pktgen_freq;
@@ -1940,7 +1940,7 @@ static int brcmf_sdbrcm_pktgen_get(dhd_bus_t *bus, u8 *arg)
 
 static int brcmf_sdbrcm_pktgen_set(dhd_bus_t *bus, u8 *arg)
 {
-	dhd_pktgen_t pktgen;
+	brcmf_pktgen_t pktgen;
 	uint oldcnt, oldmode;
 
 	memcpy(&pktgen, arg, sizeof(pktgen));
@@ -2544,14 +2544,14 @@ brcmf_sdbrcm_doiovar(dhd_bus_t *bus, const struct brcmu_iovar *vi, u32 actionid,
 		break;
 
 	case IOV_GVAL(IOV_SDIOD_DRIVE):
-		int_val = (s32) dhd_sdiod_drive_strength;
+		int_val = (s32) brcmf_sdiod_drive_strength;
 		memcpy(arg, &int_val, val_size);
 		break;
 
 	case IOV_SVAL(IOV_SDIOD_DRIVE):
-		dhd_sdiod_drive_strength = int_val;
+		brcmf_sdiod_drive_strength = int_val;
 		brcmf_sdbrcm_sdiod_drive_strength_init(bus,
-					     dhd_sdiod_drive_strength);
+					     brcmf_sdiod_drive_strength);
 		break;
 
 	case IOV_SVAL(IOV_DOWNLOAD):
@@ -4757,19 +4757,20 @@ void brcmf_sdbrcm_isr(void *arg)
 static void brcmf_sdbrcm_pktgen_init(dhd_bus_t *bus)
 {
 	/* Default to specified length, or full range */
-	if (dhd_pktgen_len) {
-		bus->pktgen_maxlen = min(dhd_pktgen_len, MAX_PKTGEN_LEN);
+	if (brcmf_pktgen_len) {
+		bus->pktgen_maxlen = min(brcmf_pktgen_len,
+					 BRCMF_MAX_PKTGEN_LEN);
 		bus->pktgen_minlen = bus->pktgen_maxlen;
 	} else {
-		bus->pktgen_maxlen = MAX_PKTGEN_LEN;
+		bus->pktgen_maxlen = BRCMF_MAX_PKTGEN_LEN;
 		bus->pktgen_minlen = 0;
 	}
 	bus->pktgen_len = (u16) bus->pktgen_minlen;
 
 	/* Default to per-watchdog burst with 10s print time */
 	bus->pktgen_freq = 1;
-	bus->pktgen_print = 10000 / dhd_watchdog_ms;
-	bus->pktgen_count = (dhd_pktgen * dhd_watchdog_ms + 999) / 1000;
+	bus->pktgen_print = 10000 / brcmf_watchdog_ms;
+	bus->pktgen_count = (brcmf_pktgen * brcmf_watchdog_ms + 999) / 1000;
 
 	/* Default to echo mode */
 	bus->pktgen_mode = DHD_PKTGEN_ECHO;
@@ -5069,14 +5070,14 @@ extern bool brcmf_sdbrcm_bus_watchdog(dhd_pub_t *dhdp)
 	}
 #ifdef DHD_DEBUG
 	/* Poll for console output periodically */
-	if (dhdp->busstate == DHD_BUS_DATA && dhd_console_ms != 0) {
-		bus->console.count += dhd_watchdog_ms;
-		if (bus->console.count >= dhd_console_ms) {
-			bus->console.count -= dhd_console_ms;
+	if (dhdp->busstate == DHD_BUS_DATA && brcmf_console_ms != 0) {
+		bus->console.count += brcmf_watchdog_ms;
+		if (bus->console.count >= brcmf_console_ms) {
+			bus->console.count -= brcmf_console_ms;
 			/* Make sure backplane clock is on */
 			brcmf_sdbrcm_clkctl(bus, CLK_AVAIL, false);
 			if (brcmf_sdbrcm_readconsole(bus) < 0)
-				dhd_console_ms = 0;	/* On error,
+				brcmf_console_ms = 0;	/* On error,
 							 stop trying */
 		}
 	}
@@ -5098,7 +5099,7 @@ extern bool brcmf_sdbrcm_bus_watchdog(dhd_pub_t *dhdp)
 			bus->idlecount = 0;
 			if (bus->activity) {
 				bus->activity = false;
-				dhd_os_wd_timer(bus->dhd, dhd_watchdog_ms);
+				dhd_os_wd_timer(bus->dhd, brcmf_watchdog_ms);
 			} else {
 				brcmf_sdbrcm_clkctl(bus, CLK_NONE, false);
 			}
@@ -5390,7 +5391,7 @@ brcmf_sdbrcm_probe_attach(struct dhd_bus *bus, void *sdh, void *regsva,
 		goto fail;
 	}
 
-	brcmf_sdbrcm_sdiod_drive_strength_init(bus, dhd_sdiod_drive_strength);
+	brcmf_sdbrcm_sdiod_drive_strength_init(bus, brcmf_sdiod_drive_strength);
 
 	/* Get info on the ARM and SOCRAM cores... */
 	if (!DHD_NOPMU(bus)) {
@@ -5421,8 +5422,8 @@ brcmf_sdbrcm_probe_attach(struct dhd_bus *bus, void *sdh, void *regsva,
 	bus->rxhdr = (u8 *) roundup((unsigned long)&bus->hdrbuf[0], DHD_SDALIGN);
 
 	/* Set the poll and/or interrupt flags */
-	bus->intr = (bool) dhd_intr;
-	bus->poll = (bool) dhd_poll;
+	bus->intr = (bool) brcmf_intr;
+	bus->poll = (bool) brcmf_poll;
 	if (bus->poll)
 		bus->pollrate = 1;
 
@@ -5498,7 +5499,7 @@ static bool brcmf_sdbrcm_probe_init(dhd_bus_t *bus, void *sdh)
 
 	/* ...and initialize clock/power states */
 	bus->clkstate = CLK_SDONLY;
-	bus->idletime = (s32) dhd_idletime;
+	bus->idletime = (s32) brcmf_idletime;
 	bus->idleclock = DHD_IDLE_ACTIVE;
 
 	/* Query the F2 block size, set roundup accordingly */
diff --git a/drivers/staging/brcm80211/brcmfmac/wl_cfg80211.c b/drivers/staging/brcm80211/brcmfmac/wl_cfg80211.c
index b30ae73..dd47451 100644
--- a/drivers/staging/brcm80211/brcmfmac/wl_cfg80211.c
+++ b/drivers/staging/brcm80211/brcmfmac/wl_cfg80211.c
@@ -2101,7 +2101,7 @@ static s32 wl_cfg80211_resume(struct wiphy *wiphy)
 
 	if (test_bit(WL_STATUS_READY, &wl->status)) {
 		/* Turn on Watchdog timer */
-		wl_os_wd_timer(ndev, dhd_watchdog_ms);
+		wl_os_wd_timer(ndev, brcmf_watchdog_ms);
 		wl_invoke_iscan(wiphy_to_wl(wiphy));
 	}
 
-- 
1.7.1


