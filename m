Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mms2.broadcom.com ([216.31.210.18]:4670 "EHLO mms2.broadcom.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758167Ab1F2XtO (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 29 Jun 2011 19:49:14 -0400
From: "Franky Lin" <frankyl@broadcom.com>
To: gregkh@suse.de
cc: devel@linuxdriverproject.org, linux-wireless@vger.kernel.org
Subject: [PATCH 071/119] staging: brcm80211: replace DHD_DEBUG macro
 with BCMDBG
Date: Wed, 29 Jun 2011 16:47:35 -0700
Message-ID: <1309391303-22741-72-git-send-email-frankyl@broadcom.com> (sfid-20110630_015159_597250_ADF36076)
In-Reply-To: <1309391303-22741-1-git-send-email-frankyl@broadcom.com>
References: <1309391303-22741-1-git-send-email-frankyl@broadcom.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Arend van Spriel <arend@broadcom.com>

The common Makefile for both brcm80211 drivers defines the macro
BCMDBG upon select Kconfig item BRCMDBG. The fullmac source add
another macro DHD_DEBUG with the same meaning. This is removed
and all conditional code now checks for BCMDBG definition.

Signed-off-by: Arend van Spriel <arend@broadcom.com>
Reviewed-by: Roland Vossen <rvossen@broadcom.com>
Reviewed-by: Franky Lin <frankyl@broadcom.com>
---
 drivers/staging/brcm80211/brcmfmac/Makefile       |    2 +-
 drivers/staging/brcm80211/brcmfmac/bcmsdbus.h     |    2 +-
 drivers/staging/brcm80211/brcmfmac/bcmsdh.c       |    2 +-
 drivers/staging/brcm80211/brcmfmac/bcmsdh_sdmmc.c |    2 +-
 drivers/staging/brcm80211/brcmfmac/dhd.h          |    8 +-
 drivers/staging/brcm80211/brcmfmac/dhd_bus.h      |    4 +-
 drivers/staging/brcm80211/brcmfmac/dhd_common.c   |   12 +-
 drivers/staging/brcm80211/brcmfmac/dhd_dbg.h      |    6 +-
 drivers/staging/brcm80211/brcmfmac/dhd_linux.c    |   10 +-
 drivers/staging/brcm80211/brcmfmac/dhd_sdio.c     |  126 ++++++++++-----------
 drivers/staging/brcm80211/brcmfmac/sdio_host.h    |    2 +-
 11 files changed, 87 insertions(+), 89 deletions(-)

diff --git a/drivers/staging/brcm80211/brcmfmac/Makefile b/drivers/staging/brcm80211/brcmfmac/Makefile
index 2fcc409..a54a7d3 100644
--- a/drivers/staging/brcm80211/brcmfmac/Makefile
+++ b/drivers/staging/brcm80211/brcmfmac/Makefile
@@ -22,7 +22,7 @@ ccflags-y :=			\
 	-DBRCMF_SDALIGN=64	\
 	-DMAX_HDR_READ=64
 
-ccflags-$(CONFIG_BRCMDBG)	+= -DDHD_DEBUG -DSHOW_EVENTS
+ccflags-$(CONFIG_BRCMDBG)	+= -DSHOW_EVENTS
 
 ccflags-y += \
 	-Idrivers/staging/brcm80211/brcmfmac	\
diff --git a/drivers/staging/brcm80211/brcmfmac/bcmsdbus.h b/drivers/staging/brcm80211/brcmfmac/bcmsdbus.h
index 88d0b02..05600e0 100644
--- a/drivers/staging/brcm80211/brcmfmac/bcmsdbus.h
+++ b/drivers/staging/brcm80211/brcmfmac/bcmsdbus.h
@@ -57,7 +57,7 @@ brcmf_sdioh_interrupt_query(struct sdioh_info *si, bool *onoff);
 extern int
 brcmf_sdioh_interrupt_set(struct sdioh_info *si, bool enable_disable);
 
-#if defined(DHD_DEBUG)
+#if defined(BCMDBG)
 extern bool brcmf_sdioh_interrupt_pending(struct sdioh_info *si);
 #endif
 
diff --git a/drivers/staging/brcm80211/brcmfmac/bcmsdh.c b/drivers/staging/brcm80211/brcmfmac/bcmsdh.c
index 733ba96..72a91bd 100644
--- a/drivers/staging/brcm80211/brcmfmac/bcmsdh.c
+++ b/drivers/staging/brcm80211/brcmfmac/bcmsdh.c
@@ -160,7 +160,7 @@ int brcmf_sdcard_intr_dereg(void *sdh)
 	return SDIOH_API_SUCCESS(status) ? 0 : -EIO;
 }
 
-#if defined(DHD_DEBUG)
+#if defined(BCMDBG)
 bool brcmf_sdcard_intr_pending(void *sdh)
 {
 	struct brcmf_sdio *bcmsdh = (struct brcmf_sdio *) sdh;
diff --git a/drivers/staging/brcm80211/brcmfmac/bcmsdh_sdmmc.c b/drivers/staging/brcm80211/brcmfmac/bcmsdh_sdmmc.c
index 5e52813..335da48 100644
--- a/drivers/staging/brcm80211/brcmfmac/bcmsdh_sdmmc.c
+++ b/drivers/staging/brcm80211/brcmfmac/bcmsdh_sdmmc.c
@@ -330,7 +330,7 @@ brcmf_sdioh_interrupt_query(struct sdioh_info *sd, bool *onoff)
 	return SDIOH_API_RC_SUCCESS;
 }
 
-#if defined(DHD_DEBUG)
+#if defined(BCMDBG)
 extern bool brcmf_sdioh_interrupt_pending(struct sdioh_info *sd)
 {
 	return 0;
diff --git a/drivers/staging/brcm80211/brcmfmac/dhd.h b/drivers/staging/brcm80211/brcmfmac/dhd.h
index 65e00a8..b7ed29c 100644
--- a/drivers/staging/brcm80211/brcmfmac/dhd.h
+++ b/drivers/staging/brcm80211/brcmfmac/dhd.h
@@ -777,10 +777,10 @@ extern atomic_t brcmf_mmc_suspend;
 /* Watchdog timer interval */
 extern uint brcmf_watchdog_ms;
 
-#if defined(DHD_DEBUG)
+#if defined(BCMDBG)
 /* Console output poll interval */
 extern uint brcmf_console_ms;
-#endif				/* defined(DHD_DEBUG) */
+#endif				/* defined(BCMDBG) */
 
 /* Use interrupts */
 extern uint brcmf_intr;
@@ -933,9 +933,9 @@ extern int brcmf_custom_get_mac_address(unsigned char *buf);
 extern void brcmf_os_sdunlock_sndup_rxq(dhd_pub_t *pub);
 extern void brcmf_os_sdlock_eventq(dhd_pub_t *pub);
 extern void brcmf_os_sdunlock_eventq(dhd_pub_t *pub);
-#ifdef DHD_DEBUG
+#ifdef BCMDBG
 extern int brcmf_write_to_file(dhd_pub_t *dhd, u8 *buf, int size);
-#endif				/* DHD_DEBUG */
+#endif				/* BCMDBG */
 #if defined(OOB_INTR_ONLY)
 extern int brcmf_customer_oob_irq_map(unsigned long *irq_flags_ptr);
 #endif				/* defined(OOB_INTR_ONLY) */
diff --git a/drivers/staging/brcm80211/brcmfmac/dhd_bus.h b/drivers/staging/brcm80211/brcmfmac/dhd_bus.h
index 73b72ff..722dbb4 100644
--- a/drivers/staging/brcm80211/brcmfmac/dhd_bus.h
+++ b/drivers/staging/brcm80211/brcmfmac/dhd_bus.h
@@ -58,11 +58,11 @@ brcmf_sdbrcm_bus_rxctl(struct dhd_bus *bus, unsigned char *msg, uint msglen);
 /* Watchdog timer function */
 extern bool brcmf_sdbrcm_bus_watchdog(dhd_pub_t *dhd);
 
-#ifdef DHD_DEBUG
+#ifdef BCMDBG
 /* Device console input function */
 extern int
 brcmf_sdbrcm_bus_console_in(dhd_pub_t *dhd, unsigned char *msg, uint msglen);
-#endif				/* DHD_DEBUG */
+#endif				/* BCMDBG */
 
 /* Deferred processing for the bus, return true requests reschedule */
 extern bool dhd_bus_dpc(struct dhd_bus *bus);
diff --git a/drivers/staging/brcm80211/brcmfmac/dhd_common.c b/drivers/staging/brcm80211/brcmfmac/dhd_common.c
index b481eb3..6c41088 100644
--- a/drivers/staging/brcm80211/brcmfmac/dhd_common.c
+++ b/drivers/staging/brcm80211/brcmfmac/dhd_common.c
@@ -39,7 +39,7 @@ char brcmf_nv_path[MOD_PARAM_PATHLEN];
 #define EPI_VERSION_STR         "4.218.248.5"
 #define MSGTRACE_VERSION	1
 
-#ifdef DHD_DEBUG
+#ifdef BCMDBG
 const char brcmf_version[] =
 "Dongle Host Driver, version " EPI_VERSION_STR "\nCompiled on " __DATE__
 " at " __TIME__;
@@ -55,7 +55,7 @@ enum {
 	IOV_BCMERROR,
 	IOV_WDTICK,
 	IOV_DUMP,
-#ifdef DHD_DEBUG
+#ifdef BCMDBG
 	IOV_CONS,
 	IOV_DCONSOLE_POLL,
 #endif
@@ -71,10 +71,10 @@ enum {
 const struct brcmu_iovar brcmf_iovars[] = {
 	{"version", IOV_VERSION, 0, IOVT_BUFFER, sizeof(brcmf_version)}
 	,
-#ifdef DHD_DEBUG
+#ifdef BCMDBG
 	{"msglevel", IOV_MSGLEVEL, 0, IOVT_UINT32, 0}
 	,
-#endif				/* DHD_DEBUG */
+#endif				/* BCMDBG */
 	{"bcmerrorstr", IOV_BCMERRORSTR, 0, IOVT_BUFFER, BCME_STRLEN}
 	,
 	{"bcmerror", IOV_BCMERROR, 0, IOVT_INT8, 0}
@@ -83,7 +83,7 @@ const struct brcmu_iovar brcmf_iovars[] = {
 	,
 	{"dump", IOV_DUMP, 0, IOVT_BUFFER, DHD_IOCTL_MAXLEN}
 	,
-#ifdef DHD_DEBUG
+#ifdef BCMDBG
 	{"dconpoll", IOV_DCONSOLE_POLL, 0, IOVT_UINT32, 0}
 	,
 	{"cons", IOV_CONS, 0, IOVT_BUFFER, 0}
@@ -255,7 +255,7 @@ brcmf_c_doiovar(dhd_pub_t *dhd_pub, const struct brcmu_iovar *vi, u32 actionid,
 		bcmerror = brcmf_c_dump(dhd_pub, arg, len);
 		break;
 
-#ifdef DHD_DEBUG
+#ifdef BCMDBG
 	case IOV_GVAL(IOV_DCONSOLE_POLL):
 		int_val = (s32) brcmf_console_ms;
 		memcpy(arg, &int_val, val_size);
diff --git a/drivers/staging/brcm80211/brcmfmac/dhd_dbg.h b/drivers/staging/brcm80211/brcmfmac/dhd_dbg.h
index 2cbfb51..e0fc124 100644
--- a/drivers/staging/brcm80211/brcmfmac/dhd_dbg.h
+++ b/drivers/staging/brcm80211/brcmfmac/dhd_dbg.h
@@ -17,7 +17,7 @@
 #ifndef _dhd_dbg_
 #define _dhd_dbg_
 
-#if defined(DHD_DEBUG)
+#if defined(BCMDBG)
 
 #define DHD_ERROR(args) \
 	do {if ((brcmf_msg_level & DHD_ERROR_VAL) && (net_ratelimit())) \
@@ -61,7 +61,7 @@
 #define DHD_BTA_ON()		(brcmf_msg_level & DHD_BTA_VAL)
 #define DHD_ISCAN_ON()		(brcmf_msg_level & DHD_ISCAN_VAL)
 
-#else	/* (defined BCMDBG) || (defined DHD_DEBUG) */
+#else	/* (defined BCMDBG) || (defined BCMDBG) */
 
 #define DHD_ERROR(args)  do {if (net_ratelimit()) printk args; } while (0)
 #define DHD_TRACE(args)
@@ -90,7 +90,7 @@
 #define DHD_EVENT_ON()		0
 #define DHD_BTA_ON()		0
 #define DHD_ISCAN_ON()		0
-#endif				/* defined(DHD_DEBUG) */
+#endif				/* defined(BCMDBG) */
 
 #define DHD_LOG(args)
 
diff --git a/drivers/staging/brcm80211/brcmfmac/dhd_linux.c b/drivers/staging/brcm80211/brcmfmac/dhd_linux.c
index 0764d02..6507891 100644
--- a/drivers/staging/brcm80211/brcmfmac/dhd_linux.c
+++ b/drivers/staging/brcm80211/brcmfmac/dhd_linux.c
@@ -262,11 +262,11 @@ module_param(brcmf_sysioc, uint, 0);
 uint brcmf_watchdog_ms = 10;
 module_param(brcmf_watchdog_ms, uint, 0);
 
-#ifdef DHD_DEBUG
+#ifdef BCMDBG
 /* Console poll interval */
 uint brcmf_console_ms;
 module_param(brcmf_console_ms, uint, 0);
-#endif				/* DHD_DEBUG */
+#endif				/* BCMDBG */
 
 /* ARP offload agent mode : Enable ARP Host Auto-Reply
 and ARP Peer Auto-Reply */
@@ -357,7 +357,7 @@ module_param(brcmf_pktgen_len, uint, 0);
 #endif
 
 /* Version string to report */
-#ifdef DHD_DEBUG
+#ifdef BCMDBG
 #define DHD_COMPILED "\nCompiled in " SRCBASE
 #else
 #define DHD_COMPILED
@@ -2632,7 +2632,7 @@ void brcmf_netdev_os_wd_timer(struct net_device *ndev, uint wdtick)
 	brcmf_os_wd_timer(&dhd->pub, wdtick);
 }
 
-#ifdef DHD_DEBUG
+#ifdef BCMDBG
 int brcmf_write_to_file(dhd_pub_t *dhd, u8 *buf, int size)
 {
 	int ret = 0;
@@ -2666,7 +2666,7 @@ exit:
 
 	return ret;
 }
-#endif				/* DHD_DEBUG */
+#endif				/* BCMDBG */
 
 #if defined(BCMDBG)
 void osl_assert(char *exp, char *file, int line)
diff --git a/drivers/staging/brcm80211/brcmfmac/dhd_sdio.c b/drivers/staging/brcm80211/brcmfmac/dhd_sdio.c
index afb840a..54a0e80 100644
--- a/drivers/staging/brcm80211/brcmfmac/dhd_sdio.c
+++ b/drivers/staging/brcm80211/brcmfmac/dhd_sdio.c
@@ -65,7 +65,7 @@
 #define SET_REG(r, mask, val) \
 		W_REG((r), ((R_REG(r) & ~(mask)) | (val)))
 
-#ifdef DHD_DEBUG
+#ifdef BCMDBG
 
 /* ARM trap handling */
 
@@ -160,7 +160,7 @@ struct rte_console {
 	char cbuf[CBUF_LEN];
 };
 
-#endif				/* DHD_DEBUG */
+#endif				/* BCMDBG */
 #include <chipcommon.h>
 
 #include "sbsdio.h"
@@ -408,7 +408,7 @@ DHD_SPINWAIT_SLEEP_INIT(sdioh_spinwait_sleep);
 #define CORE_SB(base, field) \
 		(base + SBCONFIGOFF + offsetof(sbconfig_t, field))
 
-#ifdef DHD_DEBUG
+#ifdef BCMDBG
 /* Device console log buffer state */
 struct dhd_console {
 	uint count;		/* Poll interval msec counter */
@@ -418,7 +418,7 @@ struct dhd_console {
 	u8 *buf;		/* Log buffer (host copy) */
 	uint last;		/* Last buffer read index */
 };
-#endif				/* DHD_DEBUG */
+#endif				/* BCMDBG */
 
 struct sdpcm_shared {
 	u32 flags;
@@ -514,10 +514,10 @@ typedef struct dhd_bus {
 	uint polltick;		/* Tick counter */
 	uint pollcnt;		/* Count of active polls */
 
-#ifdef DHD_DEBUG
+#ifdef BCMDBG
 	struct dhd_console console;	/* Console output polling support */
 	uint console_addr;	/* Console address from shared struct */
-#endif				/* DHD_DEBUG */
+#endif				/* BCMDBG */
 
 	uint regfails;		/* Count of R_REG/W_REG failures */
 
@@ -636,10 +636,10 @@ typedef volatile struct _sbconfig {
 
 #define DHD_NOPMU(dhd)	(false)
 
-#ifdef DHD_DEBUG
+#ifdef BCMDBG
 static int qcount[NUMPRIO];
 static int tx_packets[NUMPRIO];
-#endif				/* DHD_DEBUG */
+#endif				/* BCMDBG */
 
 /* Deferred transmit */
 const uint brcmf_deferred_tx = 1;
@@ -748,10 +748,10 @@ static void brcmf_sdbrcm_checkdied(dhd_bus_t *bus, void *pkt, uint seq);
 static void brcmf_sdbrcm_sdtest_set(dhd_bus_t *bus, bool start);
 #endif
 
-#ifdef DHD_DEBUG
+#ifdef BCMDBG
 static int brcmf_sdbrcm_checkdied(dhd_bus_t *bus, u8 *data, uint size);
 static int brcmf_sdbrcm_mem_dump(dhd_bus_t *bus);
-#endif				/* DHD_DEBUG  */
+#endif				/* BCMDBG  */
 static int brcmf_sdbrcm_download_state(dhd_bus_t *bus, bool enter);
 
 static void brcmf_sdbrcm_release(dhd_bus_t *bus);
@@ -922,14 +922,14 @@ static int brcmf_sdbrcm_htclk(dhd_bus_t *bus, bool on, bool pendok)
 		bus->clkstate = CLK_AVAIL;
 		DHD_INFO(("CLKCTL: turned ON\n"));
 
-#if defined(DHD_DEBUG)
+#if defined(BCMDBG)
 		if (bus->alp_only != true) {
 			if (SBSDIO_ALPONLY(clkctl)) {
 				DHD_ERROR(("%s: HT Clock should be on.\n",
 					   __func__));
 			}
 		}
-#endif				/* defined (DHD_DEBUG) */
+#endif				/* defined (BCMDBG) */
 
 		bus->activity = true;
 	} else {
@@ -973,9 +973,9 @@ static int brcmf_sdbrcm_sdclk(dhd_bus_t *bus, bool on)
 /* Transition SD and backplane clock readiness */
 static int brcmf_sdbrcm_clkctl(dhd_bus_t *bus, uint target, bool pendok)
 {
-#ifdef DHD_DEBUG
+#ifdef BCMDBG
 	uint oldstate = bus->clkstate;
-#endif				/* DHD_DEBUG */
+#endif				/* BCMDBG */
 
 	DHD_TRACE(("%s: Enter\n", __func__));
 
@@ -1020,9 +1020,9 @@ static int brcmf_sdbrcm_clkctl(dhd_bus_t *bus, uint target, bool pendok)
 		brcmf_os_wd_timer(bus->dhd, 0);
 		break;
 	}
-#ifdef DHD_DEBUG
+#ifdef BCMDBG
 	DHD_INFO(("brcmf_sdbrcm_clkctl: %d -> %d\n", oldstate, bus->clkstate));
-#endif				/* DHD_DEBUG */
+#endif				/* BCMDBG */
 
 	return 0;
 }
@@ -1227,7 +1227,7 @@ static int brcmf_sdbrcm_txpkt(dhd_bus_t *bus, struct sk_buff *pkt, uint chan,
 	put_unaligned_le32(swheader, frame + SDPCM_FRAMETAG_LEN);
 	put_unaligned_le32(0, frame + SDPCM_FRAMETAG_LEN + sizeof(swheader));
 
-#ifdef DHD_DEBUG
+#ifdef BCMDBG
 	tx_packets[pkt->priority]++;
 	if (DHD_BYTES_ON() &&
 	    (((DHD_CTL_ON() && (chan == SDPCM_CONTROL_CHANNEL)) ||
@@ -1372,7 +1372,7 @@ int brcmf_sdbrcm_bus_txdata(struct dhd_bus *bus, struct sk_buff *pkt)
 		if (pktq_len(&bus->txq) >= TXHI)
 			brcmf_txflowcontrol(bus->dhd, 0, ON);
 
-#ifdef DHD_DEBUG
+#ifdef BCMDBG
 		if (pktq_plen(&bus->txq, prec) > qcount[prec])
 			qcount[prec] = pktq_plen(&bus->txq, prec);
 #endif
@@ -1564,7 +1564,7 @@ brcmf_sdbrcm_bus_txctl(struct dhd_bus *bus, unsigned char *msg, uint msglen)
 	}
 
 	if (ret == -1) {
-#ifdef DHD_DEBUG
+#ifdef BCMDBG
 		if (DHD_BYTES_ON() && DHD_CTL_ON()) {
 			printk(KERN_DEBUG "Tx Frame:\n");
 			print_hex_dump_bytes("", DUMP_PREFIX_OFFSET,
@@ -1661,21 +1661,21 @@ int brcmf_sdbrcm_bus_rxctl(struct dhd_bus *bus, unsigned char *msg, uint msglen)
 			 __func__, rxlen, msglen));
 	} else if (timeleft == 0) {
 		DHD_ERROR(("%s: resumed on timeout\n", __func__));
-#ifdef DHD_DEBUG
+#ifdef BCMDBG
 		brcmf_os_sdlock(bus->dhd);
 		brcmf_sdbrcm_checkdied(bus, NULL, 0);
 		brcmf_os_sdunlock(bus->dhd);
-#endif				/* DHD_DEBUG */
+#endif				/* BCMDBG */
 	} else if (pending == true) {
 		DHD_CTL(("%s: cancelled\n", __func__));
 		return -ERESTARTSYS;
 	} else {
 		DHD_CTL(("%s: resumed for unknown reason?\n", __func__));
-#ifdef DHD_DEBUG
+#ifdef BCMDBG
 		brcmf_os_sdlock(bus->dhd);
 		brcmf_sdbrcm_checkdied(bus, NULL, 0);
 		brcmf_os_sdunlock(bus->dhd);
-#endif				/* DHD_DEBUG */
+#endif				/* BCMDBG */
 	}
 
 	if (rxlen)
@@ -1695,7 +1695,7 @@ enum {
 	IOV_SDCIS,
 	IOV_MEMBYTES,
 	IOV_MEMSIZE,
-#ifdef DHD_DEBUG
+#ifdef BCMDBG
 	IOV_CHECKDIED,
 #endif
 	IOV_DOWNLOAD,
@@ -1739,7 +1739,7 @@ const struct brcmu_iovar dhdsdio_iovars[] = {
 	{"alignctl", IOV_ALIGNCTL, 0, IOVT_BOOL, 0},
 	{"sdalign", IOV_SDALIGN, 0, IOVT_BOOL, 0},
 	{"devreset", IOV_DEVRESET, 0, IOVT_BOOL, 0},
-#ifdef DHD_DEBUG
+#ifdef BCMDBG
 	{"sdreg", IOV_SDREG, 0, IOVT_BUFFER, sizeof(struct brcmf_sdreg)}
 	,
 	{"sbreg", IOV_SBREG, 0, IOVT_BUFFER, sizeof(struct brcmf_sdreg)}
@@ -1756,11 +1756,9 @@ const struct brcmu_iovar dhdsdio_iovars[] = {
 	,
 	{"cpu", IOV_CPU, 0, IOVT_BOOL, 0}
 	,
-#ifdef DHD_DEBUG
 	{"checkdied", IOV_CHECKDIED, 0, IOVT_BUFFER, 0}
 	,
-#endif				/* DHD_DEBUG  */
-#endif				/* DHD_DEBUG */
+#endif				/* BCMDBG */
 #ifdef SDTEST
 	{"extloop", IOV_EXTLOOP, 0, IOVT_BOOL, 0}
 	,
@@ -1873,13 +1871,13 @@ void brcmf_sdbrcm_bus_dump(dhd_pub_t *dhdp, struct brcmu_strbuf *strbuf)
 			    bus->pktgen_fail);
 	}
 #endif				/* SDTEST */
-#ifdef DHD_DEBUG
+#ifdef BCMDBG
 	brcmu_bprintf(strbuf, "dpc_sched %d host interrupt%spending\n",
 		    bus->dpc_sched,
 		    (brcmf_sdcard_intr_pending(bus->sdh) ? " " : " not "));
 	brcmu_bprintf(strbuf, "blocksize %d roundup %d\n", bus->blocksize,
 		    bus->roundup);
-#endif				/* DHD_DEBUG */
+#endif				/* BCMDBG */
 	brcmu_bprintf(strbuf,
 		    "clkstate %d activity %d idletime %d idlecount %d sleeping %d\n",
 		    bus->clkstate, bus->activity, bus->idletime, bus->idlecount,
@@ -2015,7 +2013,7 @@ xfer_done:
 	return bcmerror;
 }
 
-#ifdef DHD_DEBUG
+#ifdef BCMDBG
 static int brcmf_sdbrcm_readshared(dhd_bus_t *bus, struct sdpcm_shared *sh)
 {
 	u32 addr;
@@ -2183,12 +2181,12 @@ static int brcmf_sdbrcm_checkdied(dhd_bus_t *bus, u8 *data, uint size)
 	if (sdpcm_shared.flags & (SDPCM_SHARED_ASSERT | SDPCM_SHARED_TRAP))
 		DHD_ERROR(("%s: %s\n", __func__, strbuf.origbuf));
 
-#ifdef DHD_DEBUG
+#ifdef BCMDBG
 	if (sdpcm_shared.flags & SDPCM_SHARED_TRAP) {
 		/* Mem dump to a file on device */
 		brcmf_sdbrcm_mem_dump(bus);
 	}
-#endif				/* DHD_DEBUG */
+#endif				/* BCMDBG */
 
 done:
 	kfree(mbuffer);
@@ -2321,7 +2319,7 @@ break2:
 
 	return 0;
 }
-#endif				/* DHD_DEBUG */
+#endif				/* BCMDBG */
 
 int brcmf_sdbrcm_downloadvars(dhd_bus_t *bus, void *arg, int len)
 {
@@ -2581,16 +2579,16 @@ brcmf_sdbrcm_doiovar(dhd_bus_t *bus, const struct brcmu_iovar *vi, u32 actionid,
 		memcpy(arg, &int_val, val_size);
 		break;
 
-#ifdef DHD_DEBUG
+#ifdef BCMDBG
 	case IOV_GVAL(IOV_VARS):
 		if (bus->varsz < (uint) len)
 			memcpy(arg, bus->vars, bus->varsz);
 		else
 			bcmerror = -EOVERFLOW;
 		break;
-#endif				/* DHD_DEBUG */
+#endif				/* BCMDBG */
 
-#ifdef DHD_DEBUG
+#ifdef BCMDBG
 	case IOV_GVAL(IOV_SDREG):
 		{
 			struct brcmf_sdreg *sd_ptr;
@@ -2713,7 +2711,7 @@ brcmf_sdbrcm_doiovar(dhd_bus_t *bus, const struct brcmu_iovar *vi, u32 actionid,
 	case IOV_SVAL(IOV_TXMINMAX):
 		dhd_txminmax = (uint) int_val;
 		break;
-#endif				/* DHD_DEBUG */
+#endif				/* BCMDBG */
 
 #ifdef SDTEST
 	case IOV_GVAL(IOV_EXTLOOP):
@@ -2779,9 +2777,9 @@ static int brcmf_sdbrcm_write_vars(dhd_bus_t *bus)
 	u32 varaddr;
 	u8 *vbuffer;
 	u32 varsizew;
-#ifdef DHD_DEBUG
+#ifdef BCMDBG
 	char *nvram_ularray;
-#endif				/* DHD_DEBUG */
+#endif				/* BCMDBG */
 
 	/* Even if there are no vars are to be written, we still
 		 need to set the ramsize. */
@@ -2798,7 +2796,7 @@ static int brcmf_sdbrcm_write_vars(dhd_bus_t *bus)
 		/* Write the vars list */
 		bcmerror =
 		    brcmf_sdbrcm_membytes(bus, true, varaddr, vbuffer, varsize);
-#ifdef DHD_DEBUG
+#ifdef BCMDBG
 		/* Verify NVRAM bytes */
 		DHD_INFO(("Compare NVRAM dl & ul; varsize=%d\n", varsize));
 		nvram_ularray = kmalloc(varsize, GFP_ATOMIC);
@@ -2825,7 +2823,7 @@ static int brcmf_sdbrcm_write_vars(dhd_bus_t *bus)
 				__func__));
 
 		kfree(nvram_ularray);
-#endif				/* DHD_DEBUG */
+#endif				/* BCMDBG */
 
 		kfree(vbuffer);
 	}
@@ -3335,7 +3333,7 @@ brcmf_sdbrcm_read_control(dhd_bus_t *bus, u8 *hdr, uint len, uint doff)
 
 gotpkt:
 
-#ifdef DHD_DEBUG
+#ifdef BCMDBG
 	if (DHD_BYTES_ON() && DHD_CTL_ON()) {
 		printk(KERN_DEBUG "RxCtrl:\n");
 		print_hex_dump_bytes("", DUMP_PREFIX_OFFSET, bus->rxctl, len);
@@ -3524,7 +3522,7 @@ static u8 brcmf_sdbrcm_rxglom(dhd_bus_t *bus, u8 rxseq)
 			}
 			return 0;
 		}
-#ifdef DHD_DEBUG
+#ifdef BCMDBG
 		if (DHD_GLOM_ON()) {
 			printk(KERN_DEBUG "SUPERFRAME:\n");
 			print_hex_dump_bytes("", DUMP_PREFIX_OFFSET,
@@ -3608,7 +3606,7 @@ static u8 brcmf_sdbrcm_rxglom(dhd_bus_t *bus, u8 rxseq)
 			check = get_unaligned_le16(dptr + sizeof(u16));
 			chan = SDPCM_PACKET_CHANNEL(&dptr[SDPCM_FRAMETAG_LEN]);
 			doff = SDPCM_DOFFSET_VALUE(&dptr[SDPCM_FRAMETAG_LEN]);
-#ifdef DHD_DEBUG
+#ifdef BCMDBG
 			if (DHD_GLOM_ON()) {
 				printk(KERN_DEBUG "subframe:\n");
 				print_hex_dump_bytes("", DUMP_PREFIX_OFFSET,
@@ -3686,7 +3684,7 @@ static u8 brcmf_sdbrcm_rxglom(dhd_bus_t *bus, u8 rxseq)
 				bus->rx_badseq++;
 				rxseq = seq;
 			}
-#ifdef DHD_DEBUG
+#ifdef BCMDBG
 			if (DHD_BYTES_ON() && DHD_DATA_ON()) {
 				printk(KERN_DEBUG "Rx Subframe Data:\n");
 				print_hex_dump_bytes("", DUMP_PREFIX_OFFSET,
@@ -3727,7 +3725,7 @@ static u8 brcmf_sdbrcm_rxglom(dhd_bus_t *bus, u8 rxseq)
 			plast = pfirst;
 			num++;
 
-#ifdef DHD_DEBUG
+#ifdef BCMDBG
 			if (DHD_GLOM_ON()) {
 				DHD_GLOM(("%s subframe %d to stack, %p(%p/%d) "
 				"nxt/lnk %p/%p\n",
@@ -3738,7 +3736,7 @@ static u8 brcmf_sdbrcm_rxglom(dhd_bus_t *bus, u8 rxseq)
 						pfirst->data,
 						min_t(int, pfirst->len, 32));
 			}
-#endif				/* DHD_DEBUG */
+#endif				/* BCMDBG */
 		}
 		if (num) {
 			brcmf_os_sdunlock(bus->dhd);
@@ -3775,7 +3773,7 @@ brcmf_sdbrcm_readframes(dhd_bus_t *bus, uint maxframes, bool *finished)
 	int ifidx = 0;
 	uint rxcount = 0;	/* Total frames read */
 
-#if defined(DHD_DEBUG) || defined(SDTEST)
+#if defined(BCMDBG) || defined(SDTEST)
 	bool sdtest = false;	/* To limit message spew from test mode */
 #endif
 
@@ -4035,7 +4033,7 @@ brcmf_sdbrcm_readframes(dhd_bus_t *bus, uint maxframes, bool *finished)
 			}
 			bus->tx_max = txmax;
 
-#ifdef DHD_DEBUG
+#ifdef BCMDBG
 			if (DHD_BYTES_ON() && DHD_DATA_ON()) {
 				printk(KERN_DEBUG "Rx Data:\n");
 				print_hex_dump_bytes("", DUMP_PREFIX_OFFSET,
@@ -4098,7 +4096,7 @@ brcmf_sdbrcm_readframes(dhd_bus_t *bus, uint maxframes, bool *finished)
 			brcmf_sdbrcm_rxfail(bus, true, true);
 			continue;
 		}
-#ifdef DHD_DEBUG
+#ifdef BCMDBG
 		if (DHD_BYTES_ON() || DHD_HDRS_ON()) {
 			printk(KERN_DEBUG "RxHdr:\n");
 			print_hex_dump_bytes("", DUMP_PREFIX_OFFSET,
@@ -4270,7 +4268,7 @@ brcmf_sdbrcm_readframes(dhd_bus_t *bus, uint maxframes, bool *finished)
 		skb_push(pkt, firstread);
 		memcpy(pkt->data, bus->rxhdr, firstread);
 
-#ifdef DHD_DEBUG
+#ifdef BCMDBG
 		if (DHD_BYTES_ON() && DHD_DATA_ON()) {
 			printk(KERN_DEBUG "Rx Data:\n");
 			print_hex_dump_bytes("", DUMP_PREFIX_OFFSET,
@@ -4284,7 +4282,7 @@ deliver:
 			if (SDPCM_GLOMDESC(&bus->rxhdr[SDPCM_FRAMETAG_LEN])) {
 				DHD_GLOM(("%s: glom descriptor, %d bytes:\n",
 					__func__, len));
-#ifdef DHD_DEBUG
+#ifdef BCMDBG
 				if (DHD_GLOM_ON()) {
 					printk(KERN_DEBUG "Glom Data:\n");
 					print_hex_dump_bytes("",
@@ -4332,13 +4330,13 @@ deliver:
 		brcmf_os_sdlock(bus->dhd);
 	}
 	rxcount = maxframes - rxleft;
-#ifdef DHD_DEBUG
+#ifdef BCMDBG
 	/* Message if we hit the limit */
 	if (!rxleft && !sdtest)
 		DHD_DATA(("%s: hit rx limit of %d frames\n", __func__,
 			  maxframes));
 	else
-#endif				/* DHD_DEBUG */
+#endif				/* BCMDBG */
 		DHD_DATA(("%s: processed %d frames\n", __func__, rxcount));
 	/* Back off rxseq if awaiting rtx, update rx_seq */
 	if (bus->rxskip)
@@ -4446,7 +4444,7 @@ bool brcmf_sdbrcm_dpc(dhd_bus_t *bus)
 		int err;
 		u8 clkctl, devctl = 0;
 
-#ifdef DHD_DEBUG
+#ifdef BCMDBG
 		/* Check for inconsistent device control */
 		devctl = brcmf_sdcard_cfg_read(sdh, SDIO_FUNC_1,
 					       SBSDIO_DEVICE_CTL, &err);
@@ -4457,7 +4455,7 @@ bool brcmf_sdbrcm_dpc(dhd_bus_t *bus)
 		} else {
 			ASSERT(devctl & SBSDIO_DEVCTL_CA_INT_ONLY);
 		}
-#endif				/* DHD_DEBUG */
+#endif				/* BCMDBG */
 
 		/* Read CSR, if clock on switch to AVAIL, else ignore */
 		clkctl = brcmf_sdcard_cfg_read(sdh, SDIO_FUNC_1,
@@ -4840,7 +4838,7 @@ static void brcmf_sdbrcm_pktgen(dhd_bus_t *bus)
 			*data++ =
 			    SDPCM_TEST_FILL(fillbyte, (u8) bus->pktgen_sent);
 
-#ifdef DHD_DEBUG
+#ifdef BCMDBG
 		if (DHD_BYTES_ON() && DHD_DATA_ON()) {
 			data = (u8 *) (pkt->data) + SDPCM_HDRLEN;
 			printk(KERN_DEBUG "brcmf_sdbrcm_pktgen: Tx Data:\n");
@@ -5051,7 +5049,7 @@ extern bool brcmf_sdbrcm_bus_watchdog(dhd_pub_t *dhdp)
 		/* Update interrupt tracking */
 		bus->lastintrs = bus->intrcount;
 	}
-#ifdef DHD_DEBUG
+#ifdef BCMDBG
 	/* Poll for console output periodically */
 	if (dhdp->busstate == DHD_BUS_DATA && brcmf_console_ms != 0) {
 		bus->console.count += brcmf_watchdog_ms;
@@ -5064,7 +5062,7 @@ extern bool brcmf_sdbrcm_bus_watchdog(dhd_pub_t *dhdp)
 							 stop trying */
 		}
 	}
-#endif				/* DHD_DEBUG */
+#endif				/* BCMDBG */
 
 #ifdef SDTEST
 	/* Generate packets if configured */
@@ -5094,7 +5092,7 @@ extern bool brcmf_sdbrcm_bus_watchdog(dhd_pub_t *dhdp)
 	return bus->ipend;
 }
 
-#ifdef DHD_DEBUG
+#ifdef BCMDBG
 extern int brcmf_sdbrcm_bus_console_in(dhd_pub_t *dhdp, unsigned char *msg,
 				       uint msglen)
 {
@@ -5158,7 +5156,7 @@ done:
 
 	return rv;
 }
-#endif				/* DHD_DEBUG */
+#endif				/* BCMDBG */
 
 static bool brcmf_sdbrcm_chipmatch(u16 chipid)
 {
@@ -5336,11 +5334,11 @@ brcmf_sdbrcm_probe_attach(struct dhd_bus *bus, void *sdh, void *regsva,
 	if (brcmf_sdbrcm_set_siaddr_window(bus, SI_ENUM_BASE))
 		DHD_ERROR(("%s: FAILED to return to SI_ENUM_BASE\n", __func__));
 
-#ifdef DHD_DEBUG
+#ifdef BCMDBG
 	printk(KERN_DEBUG "F1 signature read @0x18000000=0x%4x\n",
 	       brcmf_sdcard_reg_read(bus->sdh, SI_ENUM_BASE, 4));
 
-#endif				/* DHD_DEBUG */
+#endif				/* BCMDBG */
 
 	/*
 	 * Force PLL off until brcmf_sdbrcm_chip_attach()
diff --git a/drivers/staging/brcm80211/brcmfmac/sdio_host.h b/drivers/staging/brcm80211/brcmfmac/sdio_host.h
index b7e0754..6938abc 100644
--- a/drivers/staging/brcm80211/brcmfmac/sdio_host.h
+++ b/drivers/staging/brcm80211/brcmfmac/sdio_host.h
@@ -87,7 +87,7 @@ extern int brcmf_sdcard_intr_disable(void *sdh);
 extern int brcmf_sdcard_intr_reg(void *sdh, bcmsdh_cb_fn_t fn, void *argh);
 extern int brcmf_sdcard_intr_dereg(void *sdh);
 
-#if defined(DHD_DEBUG)
+#if defined(BCMDBG)
 /* Query pending interrupt status from the host controller */
 extern bool brcmf_sdcard_intr_pending(void *sdh);
 #endif
-- 
1.7.1


