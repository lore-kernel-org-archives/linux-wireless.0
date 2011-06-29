Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mms2.broadcom.com ([216.31.210.18]:4649 "EHLO mms2.broadcom.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758237Ab1F2Xtm (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 29 Jun 2011 19:49:42 -0400
From: "Franky Lin" <frankyl@broadcom.com>
To: gregkh@suse.de
cc: devel@linuxdriverproject.org, linux-wireless@vger.kernel.org
Subject: [PATCH 104/119] staging: brcm80211: rename dhd_bus structure
 and functions
Date: Wed, 29 Jun 2011 16:48:08 -0700
Message-ID: <1309391303-22741-105-git-send-email-frankyl@broadcom.com> (sfid-20110630_015309_512781_FD0695B7)
In-Reply-To: <1309391303-22741-1-git-send-email-frankyl@broadcom.com>
References: <1309391303-22741-1-git-send-email-frankyl@broadcom.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Arend van Spriel <arend@broadcom.com>

The header file dhd_bus.h contains several function prototypes
starting with dhd_bus_ and using parameter with struct dhd_bus.
These function and structure have been renamed to brcmf_bus.

Signed-off-by: Arend van Spriel <arend@broadcom.com>
Reviewed-by: Roland Vossen <rvossen@broadcom.com>
Reviewed-by: Franky Lin <frankyl@broadcom.com>
---
 drivers/staging/brcm80211/brcmfmac/dhd.h        |    6 +-
 drivers/staging/brcm80211/brcmfmac/dhd_bus.h    |   24 ++--
 drivers/staging/brcm80211/brcmfmac/dhd_common.c |    2 +-
 drivers/staging/brcm80211/brcmfmac/dhd_linux.c  |    6 +-
 drivers/staging/brcm80211/brcmfmac/dhd_sdio.c   |  212 +++++++++++-----------
 5 files changed, 125 insertions(+), 125 deletions(-)

diff --git a/drivers/staging/brcm80211/brcmfmac/dhd.h b/drivers/staging/brcm80211/brcmfmac/dhd.h
index 9f627e5..f76a3dd 100644
--- a/drivers/staging/brcm80211/brcmfmac/dhd.h
+++ b/drivers/staging/brcm80211/brcmfmac/dhd.h
@@ -522,14 +522,14 @@ struct brcmf_ioctl {
 };
 
 /* Forward decls for struct brcmf_pub (see below) */
-struct dhd_bus;		/* device bus info */
+struct brcmf_bus;		/* device bus info */
 struct brcmf_proto;	/* device communication protocol info */
 struct brcmf_info;	/* device driver info */
 
 /* Common structure for module and instance linkage */
 struct brcmf_pub {
 	/* Linkage ponters */
-	struct dhd_bus *bus;
+	struct brcmf_bus *bus;
 	struct brcmf_proto *prot;
 	struct brcmf_info *info;
 
@@ -753,7 +753,7 @@ static inline void MUTEX_UNLOCK_WL_SCAN_SET(void)
  * Returned structure should have bus and prot pointers filled in.
  * bus_hdrlen specifies required headroom for bus module header.
  */
-extern struct brcmf_pub *brcmf_attach(struct dhd_bus *bus,
+extern struct brcmf_pub *brcmf_attach(struct brcmf_bus *bus,
 				      uint bus_hdrlen);
 extern int brcmf_net_attach(struct brcmf_pub *drvr, int idx);
 extern int brcmf_netdev_wait_pend8021x(struct net_device *dev);
diff --git a/drivers/staging/brcm80211/brcmfmac/dhd_bus.h b/drivers/staging/brcm80211/brcmfmac/dhd_bus.h
index 096d73c..50da972 100644
--- a/drivers/staging/brcm80211/brcmfmac/dhd_bus.h
+++ b/drivers/staging/brcm80211/brcmfmac/dhd_bus.h
@@ -33,26 +33,26 @@
 extern uint brcmf_watchdog_ms;
 
 /* Indicate (dis)interest in finding dongles. */
-extern int dhd_bus_register(void);
-extern void dhd_bus_unregister(void);
+extern int brcmf_bus_register(void);
+extern void brcmf_bus_unregister(void);
 
 /* Stop bus module: clear pending frames, disable data flow */
-extern void brcmf_sdbrcm_bus_stop(struct dhd_bus *bus, bool enforce_mutex);
+extern void brcmf_sdbrcm_bus_stop(struct brcmf_bus *bus, bool enforce_mutex);
 
 /* Initialize bus module: prepare for communication w/dongle */
 extern int brcmf_sdbrcm_bus_init(struct brcmf_pub *drvr, bool enforce_mutex);
 
 /* Send a data frame to the dongle.  Callee disposes of txp. */
-extern int brcmf_sdbrcm_bus_txdata(struct dhd_bus *bus, struct sk_buff *txp);
+extern int brcmf_sdbrcm_bus_txdata(struct brcmf_bus *bus, struct sk_buff *txp);
 
 /* Send/receive a control message to/from the dongle.
  * Expects caller to enforce a single outstanding transaction.
  */
 extern int
-brcmf_sdbrcm_bus_txctl(struct dhd_bus *bus, unsigned char *msg, uint msglen);
+brcmf_sdbrcm_bus_txctl(struct brcmf_bus *bus, unsigned char *msg, uint msglen);
 
 extern int
-brcmf_sdbrcm_bus_rxctl(struct dhd_bus *bus, unsigned char *msg, uint msglen);
+brcmf_sdbrcm_bus_rxctl(struct brcmf_bus *bus, unsigned char *msg, uint msglen);
 
 extern void dhd_bus_isr(bool *InterruptRecognized,
 			bool *QueueMiniportHandleInterrupt, void *arg);
@@ -67,15 +67,15 @@ extern void brcmf_sdbrcm_bus_dump(struct brcmf_pub *drvr,
 				  struct brcmu_strbuf *strbuf);
 
 /* Clear any bus counters */
-extern void dhd_bus_clearcounts(struct brcmf_pub *drvr);
+extern void brcmf_bus_clearcounts(struct brcmf_pub *drvr);
 
 /* return the dongle chipid */
-extern uint dhd_bus_chip(struct dhd_bus *bus);
+extern uint brcmf_bus_chip(struct brcmf_bus *bus);
 
-extern void *dhd_bus_pub(struct dhd_bus *bus);
-extern void *dhd_bus_txq(struct dhd_bus *bus);
-extern uint dhd_bus_hdrlen(struct dhd_bus *bus);
+extern void *brcmf_bus_drvr(struct brcmf_bus *bus);
+extern void *brcmf_bus_txq(struct brcmf_bus *bus);
+extern uint brcmf_bus_hdrlen(struct brcmf_bus *bus);
 
-extern void brcmf_sdbrcm_wd_timer(struct dhd_bus *bus, uint wdtick);
+extern void brcmf_sdbrcm_wd_timer(struct brcmf_bus *bus, uint wdtick);
 
 #endif				/* _dhd_bus_h_ */
diff --git a/drivers/staging/brcm80211/brcmfmac/dhd_common.c b/drivers/staging/brcm80211/brcmfmac/dhd_common.c
index fc361d1..14dc98d 100644
--- a/drivers/staging/brcm80211/brcmfmac/dhd_common.c
+++ b/drivers/staging/brcm80211/brcmfmac/dhd_common.c
@@ -225,7 +225,7 @@ brcmf_c_doiovar(struct brcmf_pub *drvr, const struct brcmu_iovar *vi,
 		drvr->tx_realloc = 0;
 		drvr->wd_dpc_sched = 0;
 		memset(&drvr->dstats, 0, sizeof(drvr->dstats));
-		dhd_bus_clearcounts(drvr);
+		brcmf_bus_clearcounts(drvr);
 		break;
 
 	case IOV_GVAL(IOV_IOCTLTIMEOUT):{
diff --git a/drivers/staging/brcm80211/brcmfmac/dhd_linux.c b/drivers/staging/brcm80211/brcmfmac/dhd_linux.c
index 29ed98a..aa2f81f 100644
--- a/drivers/staging/brcm80211/brcmfmac/dhd_linux.c
+++ b/drivers/staging/brcm80211/brcmfmac/dhd_linux.c
@@ -1426,7 +1426,7 @@ void brcmf_del_if(struct brcmf_info *drvr_priv, int ifidx)
 	up(&drvr_priv->sysioc_sem);
 }
 
-struct brcmf_pub *brcmf_attach(struct dhd_bus *bus, uint bus_hdrlen)
+struct brcmf_pub *brcmf_attach(struct brcmf_bus *bus, uint bus_hdrlen)
 {
 	struct brcmf_info *drvr_priv = NULL;
 	struct net_device *net;
@@ -1761,7 +1761,7 @@ static void __exit brcmf_module_cleanup(void)
 {
 	DHD_TRACE(("%s: Enter\n", __func__));
 
-	dhd_bus_unregister();
+	brcmf_bus_unregister();
 }
 
 static int __init brcmf_module_init(void)
@@ -1770,7 +1770,7 @@ static int __init brcmf_module_init(void)
 
 	DHD_TRACE(("%s: Enter\n", __func__));
 
-	error = dhd_bus_register();
+	error = brcmf_bus_register();
 
 	if (error) {
 		DHD_ERROR(("%s: dhd_bus_register failed\n", __func__));
diff --git a/drivers/staging/brcm80211/brcmfmac/dhd_sdio.c b/drivers/staging/brcm80211/brcmfmac/dhd_sdio.c
index a69791e..ba3ea59 100644
--- a/drivers/staging/brcm80211/brcmfmac/dhd_sdio.c
+++ b/drivers/staging/brcm80211/brcmfmac/dhd_sdio.c
@@ -542,7 +542,7 @@ struct chip_info {
 };
 
 /* Private data for SDIO bus interaction */
-typedef struct dhd_bus {
+struct brcmf_bus {
 	struct brcmf_pub *drvr;
 
 	struct brcmf_sdio_card *card;	/* Handle for sdio card calls */
@@ -695,7 +695,7 @@ typedef struct dhd_bus {
 	const struct firmware *firmware;
 	const char *nv_name;
 	u32 fw_ptr;
-} dhd_bus_t;
+};
 
 typedef volatile struct _sbconfig {
 	u32 PAD[2];
@@ -865,74 +865,74 @@ do { \
 #define HOSTINTMASK		(I_HMB_SW_MASK | I_CHIPACTIVE)
 
 #ifdef SDTEST
-static void brcmf_sdbrcm_checkdied(dhd_bus_t *bus, void *pkt, uint seq);
-static void brcmf_sdbrcm_sdtest_set(dhd_bus_t *bus, bool start);
+static void brcmf_sdbrcm_checkdied(struct brcmf_bus *bus, void *pkt, uint seq);
+static void brcmf_sdbrcm_sdtest_set(struct brcmf_bus *bus, bool start);
 #endif
 
 #ifdef BCMDBG
 static int brcmf_sdbrcm_bus_console_in(struct brcmf_pub *drvr,
 				       unsigned char *msg, uint msglen);
-static int brcmf_sdbrcm_checkdied(dhd_bus_t *bus, u8 *data, uint size);
-static int brcmf_sdbrcm_mem_dump(dhd_bus_t *bus);
+static int brcmf_sdbrcm_checkdied(struct brcmf_bus *bus, u8 *data, uint size);
+static int brcmf_sdbrcm_mem_dump(struct brcmf_bus *bus);
 #endif				/* BCMDBG  */
-static int brcmf_sdbrcm_download_state(dhd_bus_t *bus, bool enter);
+static int brcmf_sdbrcm_download_state(struct brcmf_bus *bus, bool enter);
 
-static void brcmf_sdbrcm_release(dhd_bus_t *bus);
-static void brcmf_sdbrcm_release_malloc(dhd_bus_t *bus);
+static void brcmf_sdbrcm_release(struct brcmf_bus *bus);
+static void brcmf_sdbrcm_release_malloc(struct brcmf_bus *bus);
 static void brcmf_sdbrcm_disconnect(void *ptr);
 static bool brcmf_sdbrcm_chipmatch(u16 chipid);
-static bool brcmf_sdbrcm_probe_attach(dhd_bus_t *bus, void *card,
+static bool brcmf_sdbrcm_probe_attach(struct brcmf_bus *bus, void *card,
 				 void *regsva, u16 devid);
-static bool brcmf_sdbrcm_probe_malloc(dhd_bus_t *bus, void *card);
-static bool brcmf_sdbrcm_probe_init(dhd_bus_t *bus, void *card);
-static void brcmf_sdbrcm_release_dongle(dhd_bus_t *bus);
+static bool brcmf_sdbrcm_probe_malloc(struct brcmf_bus *bus, void *card);
+static bool brcmf_sdbrcm_probe_init(struct brcmf_bus *bus, void *card);
+static void brcmf_sdbrcm_release_dongle(struct brcmf_bus *bus);
 
 static uint brcmf_process_nvram_vars(char *varbuf, uint len);
 
-static void brcmf_sdbrcm_setmemsize(struct dhd_bus *bus, int mem_size);
-static int brcmf_sdbrcm_send_buf(dhd_bus_t *bus, u32 addr, uint fn,
+static void brcmf_sdbrcm_setmemsize(struct brcmf_bus *bus, int mem_size);
+static int brcmf_sdbrcm_send_buf(struct brcmf_bus *bus, u32 addr, uint fn,
 			       uint flags, u8 *buf, uint nbytes,
 			       struct sk_buff *pkt,
 			       brcmf_sdio_cmplt_fn_t complete, void *handle);
 
-static bool brcmf_sdbrcm_download_firmware(struct dhd_bus *bus, void *card);
-static int  _brcmf_sdbrcm_download_firmware(struct dhd_bus *bus);
+static bool brcmf_sdbrcm_download_firmware(struct brcmf_bus *bus, void *card);
+static int  _brcmf_sdbrcm_download_firmware(struct brcmf_bus *bus);
 
-static int brcmf_sdbrcm_download_code_file(struct dhd_bus *bus);
-static int brcmf_sdbrcm_download_nvram(struct dhd_bus *bus);
+static int brcmf_sdbrcm_download_code_file(struct brcmf_bus *bus);
+static int brcmf_sdbrcm_download_nvram(struct brcmf_bus *bus);
 
 static void
 brcmf_sdbrcm_chip_disablecore(struct brcmf_sdio_card *card, u32 corebase);
 
-static int brcmf_sdbrcm_chip_attach(struct dhd_bus *bus, void *regs);
+static int brcmf_sdbrcm_chip_attach(struct brcmf_bus *bus, void *regs);
 
 static void
 brcmf_sdbrcm_chip_resetcore(struct brcmf_sdio_card *card, u32 corebase);
 
-static void brcmf_sdbrcm_sdiod_drive_strength_init(struct dhd_bus *bus,
+static void brcmf_sdbrcm_sdiod_drive_strength_init(struct brcmf_bus *bus,
 					u32 drivestrength);
-static void brcmf_sdbrcm_chip_detach(struct dhd_bus *bus);
-static void brcmf_sdbrcm_wait_for_event(dhd_bus_t *bus, bool *lockvar);
-static void brcmf_sdbrcm_wait_event_wakeup(dhd_bus_t *bus);
+static void brcmf_sdbrcm_chip_detach(struct brcmf_bus *bus);
+static void brcmf_sdbrcm_wait_for_event(struct brcmf_bus *bus, bool *lockvar);
+static void brcmf_sdbrcm_wait_event_wakeup(struct brcmf_bus *bus);
 static void brcmf_sdbrcm_watchdog(unsigned long data);
 static int brcmf_sdbrcm_watchdog_thread(void *data);
 static int brcmf_sdbrcm_dpc_thread(void *data);
 static void brcmf_sdbrcm_dpc_tasklet(unsigned long data);
-static void brcmf_sdbrcm_sched_dpc(dhd_bus_t *bus);
-static void brcmf_sdbrcm_sdlock(dhd_bus_t *bus);
-static void brcmf_sdbrcm_sdunlock(dhd_bus_t *bus);
-static int brcmf_sdbrcm_get_image(char *buf, int len, struct dhd_bus *bus);
+static void brcmf_sdbrcm_sched_dpc(struct brcmf_bus *bus);
+static void brcmf_sdbrcm_sdlock(struct brcmf_bus *bus);
+static void brcmf_sdbrcm_sdunlock(struct brcmf_bus *bus);
+static int brcmf_sdbrcm_get_image(char *buf, int len, struct brcmf_bus *bus);
 
 /* Packet free applicable unconditionally for sdio and sdspi.
  * Conditional if bufpool was present for gspi bus.
  */
-static void brcmf_sdbrcm_pktfree2(dhd_bus_t *bus, struct sk_buff *pkt)
+static void brcmf_sdbrcm_pktfree2(struct brcmf_bus *bus, struct sk_buff *pkt)
 {
 	if ((bus->bus != SPI_BUS) || bus->usebufpool)
 		brcmu_pkt_buf_free_skb(pkt);
 }
 
-static void brcmf_sdbrcm_setmemsize(struct dhd_bus *bus, int mem_size)
+static void brcmf_sdbrcm_setmemsize(struct brcmf_bus *bus, int mem_size)
 {
 	s32 min_size = DONGLE_MIN_MEMSIZE;
 	/* Restrict the memsize to user specified limit */
@@ -943,7 +943,7 @@ static void brcmf_sdbrcm_setmemsize(struct dhd_bus *bus, int mem_size)
 		bus->ramsize = brcmf_dongle_memsize;
 }
 
-static int brcmf_sdbrcm_set_siaddr_window(dhd_bus_t *bus, u32 address)
+static int brcmf_sdbrcm_set_siaddr_window(struct brcmf_bus *bus, u32 address)
 {
 	int err = 0;
 	brcmf_sdcard_cfg_write(bus->card, SDIO_FUNC_1, SBSDIO_FUNC1_SBADDRLOW,
@@ -961,7 +961,7 @@ static int brcmf_sdbrcm_set_siaddr_window(dhd_bus_t *bus, u32 address)
 }
 
 /* Turn backplane clock on or off */
-static int brcmf_sdbrcm_htclk(dhd_bus_t *bus, bool on, bool pendok)
+static int brcmf_sdbrcm_htclk(struct brcmf_bus *bus, bool on, bool pendok)
 {
 	int err;
 	u8 clkctl, clkreq, devctl;
@@ -1093,7 +1093,7 @@ static int brcmf_sdbrcm_htclk(dhd_bus_t *bus, bool on, bool pendok)
 }
 
 /* Change idle/active SD state */
-static int brcmf_sdbrcm_sdclk(dhd_bus_t *bus, bool on)
+static int brcmf_sdbrcm_sdclk(struct brcmf_bus *bus, bool on)
 {
 	DHD_TRACE(("%s: Enter\n", __func__));
 
@@ -1106,7 +1106,7 @@ static int brcmf_sdbrcm_sdclk(dhd_bus_t *bus, bool on)
 }
 
 /* Transition SD and backplane clock readiness */
-static int brcmf_sdbrcm_clkctl(dhd_bus_t *bus, uint target, bool pendok)
+static int brcmf_sdbrcm_clkctl(struct brcmf_bus *bus, uint target, bool pendok)
 {
 #ifdef BCMDBG
 	uint oldstate = bus->clkstate;
@@ -1162,7 +1162,7 @@ static int brcmf_sdbrcm_clkctl(dhd_bus_t *bus, uint target, bool pendok)
 	return 0;
 }
 
-int brcmf_sdbrcm_bussleep(dhd_bus_t *bus, bool sleep)
+int brcmf_sdbrcm_bussleep(struct brcmf_bus *bus, bool sleep)
 {
 	struct brcmf_sdio_card *card = bus->card;
 	struct sdpcmd_regs *regs = bus->regs;
@@ -1259,7 +1259,7 @@ int brcmf_sdbrcm_bussleep(dhd_bus_t *bus, bool sleep)
 
 /* Writes a HW/SW header into the packet and sends it. */
 /* Assumes: (a) header space already there, (b) caller holds lock */
-static int brcmf_sdbrcm_txpkt(dhd_bus_t *bus, struct sk_buff *pkt, uint chan,
+static int brcmf_sdbrcm_txpkt(struct brcmf_bus *bus, struct sk_buff *pkt, uint chan,
 			 bool free_pkt)
 {
 	int ret;
@@ -1411,7 +1411,7 @@ done:
 	return ret;
 }
 
-int brcmf_sdbrcm_bus_txdata(struct dhd_bus *bus, struct sk_buff *pkt)
+int brcmf_sdbrcm_bus_txdata(struct brcmf_bus *bus, struct sk_buff *pkt)
 {
 	int ret = -EBADE;
 	uint datalen, prec;
@@ -1509,7 +1509,7 @@ int brcmf_sdbrcm_bus_txdata(struct dhd_bus *bus, struct sk_buff *pkt)
 	return ret;
 }
 
-static uint brcmf_sdbrcm_sendfromq(dhd_bus_t *bus, uint maxframes)
+static uint brcmf_sdbrcm_sendfromq(struct brcmf_bus *bus, uint maxframes)
 {
 	struct sk_buff *pkt;
 	u32 intstatus = 0;
@@ -1570,7 +1570,7 @@ static uint brcmf_sdbrcm_sendfromq(dhd_bus_t *bus, uint maxframes)
 }
 
 int
-brcmf_sdbrcm_bus_txctl(struct dhd_bus *bus, unsigned char *msg, uint msglen)
+brcmf_sdbrcm_bus_txctl(struct brcmf_bus *bus, unsigned char *msg, uint msglen)
 {
 	u8 *frame;
 	u16 len;
@@ -1731,7 +1731,7 @@ brcmf_sdbrcm_bus_txctl(struct dhd_bus *bus, unsigned char *msg, uint msglen)
 	return ret ? -EIO : 0;
 }
 
-int brcmf_sdbrcm_bus_rxctl(struct dhd_bus *bus, unsigned char *msg, uint msglen)
+int brcmf_sdbrcm_bus_rxctl(struct brcmf_bus *bus, unsigned char *msg, uint msglen)
 {
 	int timeleft;
 	uint rxlen = 0;
@@ -1888,7 +1888,7 @@ dhd_dump_pct(struct brcmu_strbuf *strbuf, char *desc, uint num, uint div)
 
 void brcmf_sdbrcm_bus_dump(struct brcmf_pub *drvr, struct brcmu_strbuf *strbuf)
 {
-	dhd_bus_t *bus = drvr->bus;
+	struct brcmf_bus *bus = drvr->bus;
 
 	brcmu_bprintf(strbuf, "Bus SDIO structure:\n");
 	brcmu_bprintf(strbuf,
@@ -1986,9 +1986,9 @@ void brcmf_sdbrcm_bus_dump(struct brcmf_pub *drvr, struct brcmu_strbuf *strbuf)
 		    bus->sleeping);
 }
 
-void dhd_bus_clearcounts(struct brcmf_pub *drvr)
+void brcmf_bus_clearcounts(struct brcmf_pub *drvr)
 {
-	dhd_bus_t *bus = (dhd_bus_t *) drvr->bus;
+	struct brcmf_bus *bus = (struct brcmf_bus *) drvr->bus;
 
 	bus->intrcount = bus->lastintrs = bus->spurious = bus->regfails = 0;
 	bus->rxrtx = bus->rx_toolong = bus->rxc_errors = 0;
@@ -1999,7 +1999,7 @@ void dhd_bus_clearcounts(struct brcmf_pub *drvr)
 }
 
 #ifdef SDTEST
-static int brcmf_sdbrcm_pktgen_get(dhd_bus_t *bus, u8 *arg)
+static int brcmf_sdbrcm_pktgen_get(struct brcmf_bus *bus, u8 *arg)
 {
 	brcmf_pktgen_t pktgen;
 
@@ -2021,7 +2021,7 @@ static int brcmf_sdbrcm_pktgen_get(dhd_bus_t *bus, u8 *arg)
 	return 0;
 }
 
-static int brcmf_sdbrcm_pktgen_set(dhd_bus_t *bus, u8 *arg)
+static int brcmf_sdbrcm_pktgen_set(struct brcmf_bus *bus, u8 *arg)
 {
 	brcmf_pktgen_t pktgen;
 	uint oldcnt, oldmode;
@@ -2055,7 +2055,7 @@ static int brcmf_sdbrcm_pktgen_set(dhd_bus_t *bus, u8 *arg)
 #endif				/* SDTEST */
 
 static int
-brcmf_sdbrcm_membytes(dhd_bus_t *bus, bool write, u32 address, u8 *data,
+brcmf_sdbrcm_membytes(struct brcmf_bus *bus, bool write, u32 address, u8 *data,
 		 uint size)
 {
 	int bcmerror = 0;
@@ -2116,7 +2116,7 @@ xfer_done:
 }
 
 #ifdef BCMDBG
-static int brcmf_sdbrcm_readshared(dhd_bus_t *bus, struct sdpcm_shared *sh)
+static int brcmf_sdbrcm_readshared(struct brcmf_bus *bus, struct sdpcm_shared *sh)
 {
 	u32 addr;
 	int rv;
@@ -2168,7 +2168,7 @@ static int brcmf_sdbrcm_readshared(dhd_bus_t *bus, struct sdpcm_shared *sh)
 	return 0;
 }
 
-static int brcmf_sdbrcm_checkdied(dhd_bus_t *bus, u8 *data, uint size)
+static int brcmf_sdbrcm_checkdied(struct brcmf_bus *bus, u8 *data, uint size)
 {
 	int bcmerror = 0;
 	uint msize = 512;
@@ -2297,7 +2297,7 @@ done:
 	return bcmerror;
 }
 
-static int brcmf_sdbrcm_mem_dump(dhd_bus_t *bus)
+static int brcmf_sdbrcm_mem_dump(struct brcmf_bus *bus)
 {
 	int ret = 0;
 	int size;		/* Full mem size */
@@ -2346,7 +2346,7 @@ static int brcmf_sdbrcm_mem_dump(dhd_bus_t *bus)
 
 #define CONSOLE_LINE_MAX	192
 
-static int brcmf_sdbrcm_readconsole(dhd_bus_t *bus)
+static int brcmf_sdbrcm_readconsole(struct brcmf_bus *bus)
 {
 	struct dhd_console *c = &bus->console;
 	u8 line[CONSOLE_LINE_MAX], ch;
@@ -2423,7 +2423,7 @@ break2:
 }
 #endif				/* BCMDBG */
 
-int brcmf_sdbrcm_downloadvars(dhd_bus_t *bus, void *arg, int len)
+int brcmf_sdbrcm_downloadvars(struct brcmf_bus *bus, void *arg, int len)
 {
 	int bcmerror = 0;
 
@@ -2457,7 +2457,7 @@ err:
 }
 
 static int
-brcmf_sdbrcm_doiovar(dhd_bus_t *bus, const struct brcmu_iovar *vi, u32 actionid,
+brcmf_sdbrcm_doiovar(struct brcmf_bus *bus, const struct brcmu_iovar *vi, u32 actionid,
 		const char *name, void *params, int plen, void *arg, int len,
 		int val_size)
 {
@@ -2900,7 +2900,7 @@ exit:
 	return bcmerror;
 }
 
-static int brcmf_sdbrcm_write_vars(dhd_bus_t *bus)
+static int brcmf_sdbrcm_write_vars(struct brcmf_bus *bus)
 {
 	int bcmerror = 0;
 	u32 varsize;
@@ -2987,7 +2987,7 @@ static int brcmf_sdbrcm_write_vars(dhd_bus_t *bus)
 	return bcmerror;
 }
 
-static int brcmf_sdbrcm_download_state(dhd_bus_t *bus, bool enter)
+static int brcmf_sdbrcm_download_state(struct brcmf_bus *bus, bool enter)
 {
 	uint retries;
 	u32 regdata;
@@ -3044,7 +3044,7 @@ int
 brcmf_sdbrcm_bus_iovar_op(struct brcmf_pub *drvr, const char *name,
 			  void *params, int plen, void *arg, int len, bool set)
 {
-	dhd_bus_t *bus = drvr->bus;
+	struct brcmf_bus *bus = drvr->bus;
 	const struct brcmu_iovar *vi = NULL;
 	int bcmerror = 0;
 	int val_size;
@@ -3129,7 +3129,7 @@ exit:
 	return bcmerror;
 }
 
-void brcmf_sdbrcm_bus_stop(struct dhd_bus *bus, bool enforce_mutex)
+void brcmf_sdbrcm_bus_stop(struct brcmf_bus *bus, bool enforce_mutex)
 {
 	u32 local_hostintmask;
 	u8 saveclk;
@@ -3218,7 +3218,7 @@ void brcmf_sdbrcm_bus_stop(struct dhd_bus *bus, bool enforce_mutex)
 
 int brcmf_sdbrcm_bus_init(struct brcmf_pub *drvr, bool enforce_mutex)
 {
-	dhd_bus_t *bus = drvr->bus;
+	struct brcmf_bus *bus = drvr->bus;
 	struct brcmf_timeout tmo;
 	uint retries = 0;
 	u8 ready, enable;
@@ -3344,7 +3344,7 @@ exit:
 	return ret;
 }
 
-static void brcmf_sdbrcm_rxfail(dhd_bus_t *bus, bool abort, bool rtx)
+static void brcmf_sdbrcm_rxfail(struct brcmf_bus *bus, bool abort, bool rtx)
 {
 	struct brcmf_sdio_card *card = bus->card;
 	struct sdpcmd_regs *regs = bus->regs;
@@ -3408,7 +3408,7 @@ static void brcmf_sdbrcm_rxfail(dhd_bus_t *bus, bool abort, bool rtx)
 }
 
 static void
-brcmf_sdbrcm_read_control(dhd_bus_t *bus, u8 *hdr, uint len, uint doff)
+brcmf_sdbrcm_read_control(struct brcmf_bus *bus, u8 *hdr, uint len, uint doff)
 {
 	struct brcmf_sdio_card *card = bus->card;
 	uint rdlen, pad;
@@ -3513,7 +3513,7 @@ done:
 	brcmf_os_ioctl_resp_wake(bus->drvr);
 }
 
-static u8 brcmf_sdbrcm_rxglom(dhd_bus_t *bus, u8 rxseq)
+static u8 brcmf_sdbrcm_rxglom(struct brcmf_bus *bus, u8 rxseq)
 {
 	u16 dlen, totlen;
 	u8 *dptr, num = 0;
@@ -3916,7 +3916,7 @@ static u8 brcmf_sdbrcm_rxglom(dhd_bus_t *bus, u8 rxseq)
 
 /* Return true if there may be more frames to read */
 static uint
-brcmf_sdbrcm_readframes(dhd_bus_t *bus, uint maxframes, bool *finished)
+brcmf_sdbrcm_readframes(struct brcmf_bus *bus, uint maxframes, bool *finished)
 {
 	struct brcmf_sdio_card *card = bus->card;
 
@@ -4512,7 +4512,7 @@ deliver:
 	return rxcount;
 }
 
-static u32 brcmf_sdbrcm_hostmail(dhd_bus_t *bus)
+static u32 brcmf_sdbrcm_hostmail(struct brcmf_bus *bus)
 {
 	struct sdpcmd_regs *regs = bus->regs;
 	u32 intstatus = 0;
@@ -4586,7 +4586,7 @@ static u32 brcmf_sdbrcm_hostmail(dhd_bus_t *bus)
 	return intstatus;
 }
 
-static bool brcmf_sdbrcm_dpc(dhd_bus_t *bus)
+static bool brcmf_sdbrcm_dpc(struct brcmf_bus *bus)
 {
 	struct brcmf_sdio_card *card = bus->card;
 	struct sdpcmd_regs *regs = bus->regs;
@@ -4842,7 +4842,7 @@ clkwait:
 
 void brcmf_sdbrcm_isr(void *arg)
 {
-	dhd_bus_t *bus = (dhd_bus_t *) arg;
+	struct brcmf_bus *bus = (struct brcmf_bus *) arg;
 	struct brcmf_sdio_card *card;
 
 	DHD_TRACE(("%s: Enter\n", __func__));
@@ -4889,7 +4889,7 @@ void brcmf_sdbrcm_isr(void *arg)
 }
 
 #ifdef SDTEST
-static void brcmf_sdbrcm_pktgen_init(dhd_bus_t *bus)
+static void brcmf_sdbrcm_pktgen_init(struct brcmf_bus *bus)
 {
 	/* Default to specified length, or full range */
 	if (brcmf_pktgen_len) {
@@ -4912,7 +4912,7 @@ static void brcmf_sdbrcm_pktgen_init(dhd_bus_t *bus)
 	bus->pktgen_stop = 1;
 }
 
-static void brcmf_sdbrcm_pktgen(dhd_bus_t *bus)
+static void brcmf_sdbrcm_pktgen(struct brcmf_bus *bus)
 {
 	struct sk_buff *pkt;
 	u8 *data;
@@ -5020,7 +5020,7 @@ static void brcmf_sdbrcm_pktgen(dhd_bus_t *bus)
 	}
 }
 
-static void brcmf_sdbrcm_sdtest_set(dhd_bus_t *bus, bool start)
+static void brcmf_sdbrcm_sdtest_set(struct brcmf_bus *bus, bool start)
 {
 	struct sk_buff *pkt;
 	u8 *data;
@@ -5047,7 +5047,7 @@ static void brcmf_sdbrcm_sdtest_set(dhd_bus_t *bus, bool start)
 }
 
 static void
-brcmf_sdbrcm_checkdied(dhd_bus_t *bus, struct sk_buff *pkt, uint seq)
+brcmf_sdbrcm_checkdied(struct brcmf_bus *bus, struct sk_buff *pkt, uint seq)
 {
 	u8 *data;
 	uint pktlen;
@@ -5151,7 +5151,7 @@ brcmf_sdbrcm_checkdied(dhd_bus_t *bus, struct sk_buff *pkt, uint seq)
 
 extern bool brcmf_sdbrcm_bus_watchdog(struct brcmf_pub *drvr)
 {
-	dhd_bus_t *bus;
+	struct brcmf_bus *bus;
 
 	DHD_TIMER(("%s: Enter\n", __func__));
 
@@ -5250,7 +5250,7 @@ extern bool brcmf_sdbrcm_bus_watchdog(struct brcmf_pub *drvr)
 static int brcmf_sdbrcm_bus_console_in(struct brcmf_pub *drvr,
 				       unsigned char *msg, uint msglen)
 {
-	dhd_bus_t *bus = drvr->bus;
+	struct brcmf_bus *bus = drvr->bus;
 	u32 addr, val;
 	int rv;
 	struct sk_buff *pkt;
@@ -5328,7 +5328,7 @@ static void *brcmf_sdbrcm_probe(u16 venid, u16 devid, u16 bus_no,
 			   void *card)
 {
 	int ret;
-	dhd_bus_t *bus;
+	struct brcmf_bus *bus;
 
 	/* Init global variables at run-time, not as part of the declaration.
 	 * This is required to support init/de-init of the driver.
@@ -5402,9 +5402,9 @@ static void *brcmf_sdbrcm_probe(u16 venid, u16 devid, u16 bus_no,
 	}
 
 	/* Allocate private bus interface state */
-	bus = kzalloc(sizeof(dhd_bus_t), GFP_ATOMIC);
+	bus = kzalloc(sizeof(struct brcmf_bus), GFP_ATOMIC);
 	if (!bus) {
-		DHD_ERROR(("%s: kmalloc of dhd_bus_t failed\n", __func__));
+		DHD_ERROR(("%s: kmalloc of struct dhd_bus failed\n", __func__));
 		goto fail;
 	}
 	bus->card = card;
@@ -5521,7 +5521,7 @@ fail:
 }
 
 static bool
-brcmf_sdbrcm_probe_attach(struct dhd_bus *bus, void *card, void *regsva,
+brcmf_sdbrcm_probe_attach(struct brcmf_bus *bus, void *card, void *regsva,
 			  u16 devid)
 {
 	u8 clkctl = 0;
@@ -5614,7 +5614,7 @@ fail:
 	return false;
 }
 
-static bool brcmf_sdbrcm_probe_malloc(dhd_bus_t *bus, void *card)
+static bool brcmf_sdbrcm_probe_malloc(struct brcmf_bus *bus, void *card)
 {
 	DHD_TRACE(("%s: Enter\n", __func__));
 
@@ -5654,7 +5654,7 @@ fail:
 	return false;
 }
 
-static bool brcmf_sdbrcm_probe_init(dhd_bus_t *bus, void *card)
+static bool brcmf_sdbrcm_probe_init(struct brcmf_bus *bus, void *card)
 {
 	s32 fnum;
 
@@ -5711,7 +5711,7 @@ static bool brcmf_sdbrcm_probe_init(dhd_bus_t *bus, void *card)
 }
 
 static bool
-brcmf_sdbrcm_download_firmware(struct dhd_bus *bus, void *card)
+brcmf_sdbrcm_download_firmware(struct brcmf_bus *bus, void *card)
 {
 	bool ret;
 
@@ -5726,7 +5726,7 @@ brcmf_sdbrcm_download_firmware(struct dhd_bus *bus, void *card)
 }
 
 /* Detach and free everything */
-static void brcmf_sdbrcm_release(dhd_bus_t *bus)
+static void brcmf_sdbrcm_release(struct brcmf_bus *bus)
 {
 	DHD_TRACE(("%s: Enter\n", __func__));
 
@@ -5749,7 +5749,7 @@ static void brcmf_sdbrcm_release(dhd_bus_t *bus)
 	DHD_TRACE(("%s: Disconnected\n", __func__));
 }
 
-static void brcmf_sdbrcm_release_malloc(dhd_bus_t *bus)
+static void brcmf_sdbrcm_release_malloc(struct brcmf_bus *bus)
 {
 	DHD_TRACE(("%s: Enter\n", __func__));
 
@@ -5764,7 +5764,7 @@ static void brcmf_sdbrcm_release_malloc(dhd_bus_t *bus)
 	bus->databuf = NULL;
 }
 
-static void brcmf_sdbrcm_release_dongle(dhd_bus_t *bus)
+static void brcmf_sdbrcm_release_dongle(struct brcmf_bus *bus)
 {
 	DHD_TRACE(("%s: Enter\n", __func__));
 
@@ -5785,7 +5785,7 @@ static void brcmf_sdbrcm_release_dongle(dhd_bus_t *bus)
 
 static void brcmf_sdbrcm_disconnect(void *ptr)
 {
-	dhd_bus_t *bus = (dhd_bus_t *)ptr;
+	struct brcmf_bus *bus = (struct brcmf_bus *)ptr;
 
 	DHD_TRACE(("%s: Enter\n", __func__));
 
@@ -5807,7 +5807,7 @@ static struct brcmf_sdioh_driver dhd_sdio = {
 	brcmf_sdbrcm_disconnect
 };
 
-int dhd_bus_register(void)
+int brcmf_bus_register(void)
 {
 	DHD_TRACE(("%s: Enter\n", __func__));
 
@@ -5829,14 +5829,14 @@ int dhd_bus_register(void)
 	return brcmf_sdio_register(&dhd_sdio);
 }
 
-void dhd_bus_unregister(void)
+void brcmf_bus_unregister(void)
 {
 	DHD_TRACE(("%s: Enter\n", __func__));
 
 	brcmf_sdio_unregister();
 }
 
-static int brcmf_sdbrcm_download_code_file(struct dhd_bus *bus)
+static int brcmf_sdbrcm_download_code_file(struct brcmf_bus *bus)
 {
 	int offset = 0;
 	uint len;
@@ -5938,7 +5938,7 @@ static uint brcmf_process_nvram_vars(char *varbuf, uint len)
 	return buf_len;
 }
 
-static int brcmf_sdbrcm_download_nvram(struct dhd_bus *bus)
+static int brcmf_sdbrcm_download_nvram(struct brcmf_bus *bus)
 {
 	uint len;
 	char *memblock = NULL;
@@ -5990,7 +5990,7 @@ err:
 	return ret;
 }
 
-static int _brcmf_sdbrcm_download_firmware(struct dhd_bus *bus)
+static int _brcmf_sdbrcm_download_firmware(struct brcmf_bus *bus)
 {
 	int bcmerror = -1;
 
@@ -6033,7 +6033,7 @@ err:
 
 
 static int
-brcmf_sdbrcm_send_buf(dhd_bus_t *bus, u32 addr, uint fn, uint flags,
+brcmf_sdbrcm_send_buf(struct brcmf_bus *bus, u32 addr, uint fn, uint flags,
 		    u8 *buf, uint nbytes, struct sk_buff *pkt,
 		    brcmf_sdio_cmplt_fn_t complete, void *handle)
 {
@@ -6042,23 +6042,23 @@ brcmf_sdbrcm_send_buf(dhd_bus_t *bus, u32 addr, uint fn, uint flags,
 		 handle);
 }
 
-uint dhd_bus_chip(struct dhd_bus *bus)
+uint brcmf_bus_chip(struct brcmf_bus *bus)
 {
 	ASSERT(bus->ci != NULL);
 	return bus->ci->chip;
 }
 
-void *dhd_bus_pub(struct dhd_bus *bus)
+void *brcmf_bus_drvr(struct brcmf_bus *bus)
 {
 	return bus->drvr;
 }
 
-void *dhd_bus_txq(struct dhd_bus *bus)
+void *brcmf_bus_txq(struct brcmf_bus *bus)
 {
 	return &bus->txq;
 }
 
-uint dhd_bus_hdrlen(struct dhd_bus *bus)
+uint brcmf_bus_hdrlen(struct brcmf_bus *bus)
 {
 	return SDPCM_HDRLEN;
 }
@@ -6066,7 +6066,7 @@ uint dhd_bus_hdrlen(struct dhd_bus *bus)
 int brcmf_bus_devreset(struct brcmf_pub *drvr, u8 flag)
 {
 	int bcmerror = 0;
-	dhd_bus_t *bus;
+	struct brcmf_bus *bus;
 
 	bus = drvr->bus;
 
@@ -6265,7 +6265,7 @@ brcmf_sdbrcm_chip_disablecore(struct brcmf_sdio_card *card, u32 corebase)
 }
 
 static int
-brcmf_sdbrcm_chip_attach(struct dhd_bus *bus, void *regs)
+brcmf_sdbrcm_chip_attach(struct brcmf_bus *bus, void *regs)
 {
 	struct chip_info *ci;
 	int err;
@@ -6448,7 +6448,7 @@ static const struct sdiod_drive_str sdiod_drive_strength_tab3[] = {
 #define SDIOD_DRVSTR_KEY(chip, pmu)     (((chip) << 16) | (pmu))
 
 static void
-brcmf_sdbrcm_sdiod_drive_strength_init(struct dhd_bus *bus, u32 drivestrength) {
+brcmf_sdbrcm_sdiod_drive_strength_init(struct brcmf_bus *bus, u32 drivestrength) {
 	struct sdiod_drive_str *str_tab = NULL;
 	u32 str_mask = 0;
 	u32 str_shift = 0;
@@ -6512,7 +6512,7 @@ brcmf_sdbrcm_sdiod_drive_strength_init(struct dhd_bus *bus, u32 drivestrength) {
 }
 
 static void
-brcmf_sdbrcm_chip_detach(struct dhd_bus *bus)
+brcmf_sdbrcm_chip_detach(struct brcmf_bus *bus)
 {
 	DHD_TRACE(("%s: Enter\n", __func__));
 
@@ -6521,7 +6521,7 @@ brcmf_sdbrcm_chip_detach(struct dhd_bus *bus)
 }
 
 static void
-brcmf_sdbrcm_wait_for_event(dhd_bus_t *bus, bool *lockvar)
+brcmf_sdbrcm_wait_for_event(struct brcmf_bus *bus, bool *lockvar)
 {
 	brcmf_sdbrcm_sdunlock(bus);
 	wait_event_interruptible_timeout(bus->ctrl_wait,
@@ -6531,7 +6531,7 @@ brcmf_sdbrcm_wait_for_event(dhd_bus_t *bus, bool *lockvar)
 }
 
 static void
-brcmf_sdbrcm_wait_event_wakeup(dhd_bus_t *bus)
+brcmf_sdbrcm_wait_event_wakeup(struct brcmf_bus *bus)
 {
 	if (waitqueue_active(&bus->ctrl_wait))
 		wake_up_interruptible(&bus->ctrl_wait);
@@ -6541,7 +6541,7 @@ brcmf_sdbrcm_wait_event_wakeup(dhd_bus_t *bus)
 static int
 brcmf_sdbrcm_watchdog_thread(void *data)
 {
-	dhd_bus_t *bus = (dhd_bus_t *)data;
+	struct brcmf_bus *bus = (struct brcmf_bus *)data;
 
 	/* This thread doesn't need any user-level access,
 	* so get rid of all our resources
@@ -6572,7 +6572,7 @@ brcmf_sdbrcm_watchdog_thread(void *data)
 static void
 brcmf_sdbrcm_watchdog(unsigned long data)
 {
-	dhd_bus_t *bus = (dhd_bus_t *)data;
+	struct brcmf_bus *bus = (struct brcmf_bus *)data;
 
 	if (brcmf_watchdog_prio >= 0) {
 		if (bus->watchdog_tsk)
@@ -6592,7 +6592,7 @@ brcmf_sdbrcm_watchdog(unsigned long data)
 }
 
 void
-brcmf_sdbrcm_wd_timer(struct dhd_bus *bus, uint wdtick)
+brcmf_sdbrcm_wd_timer(struct brcmf_bus *bus, uint wdtick)
 {
 	static uint save_ms;
 
@@ -6636,7 +6636,7 @@ brcmf_sdbrcm_wd_timer(struct dhd_bus *bus, uint wdtick)
 
 static int brcmf_sdbrcm_dpc_thread(void *data)
 {
-	dhd_bus_t *bus = (dhd_bus_t *) data;
+	struct brcmf_bus *bus = (struct brcmf_bus *) data;
 
 	/* This thread doesn't need any user-level access,
 	 * so get rid of all our resources
@@ -6670,7 +6670,7 @@ static int brcmf_sdbrcm_dpc_thread(void *data)
 
 static void brcmf_sdbrcm_dpc_tasklet(unsigned long data)
 {
-	dhd_bus_t *bus = (dhd_bus_t *) data;
+	struct brcmf_bus *bus = (struct brcmf_bus *) data;
 
 	/* Call bus dpc unless it indicated down (then clean stop) */
 	if (bus->drvr->busstate != DHD_BUS_DOWN) {
@@ -6680,7 +6680,7 @@ static void brcmf_sdbrcm_dpc_tasklet(unsigned long data)
 		brcmf_sdbrcm_bus_stop(bus, true);
 }
 
-static void brcmf_sdbrcm_sched_dpc(dhd_bus_t *bus)
+static void brcmf_sdbrcm_sched_dpc(struct brcmf_bus *bus)
 {
 	if (bus->dpc_tsk) {
 		complete(&bus->dpc_wait);
@@ -6690,7 +6690,7 @@ static void brcmf_sdbrcm_sched_dpc(dhd_bus_t *bus)
 	tasklet_schedule(&bus->tasklet);
 }
 
-static void brcmf_sdbrcm_sdlock(dhd_bus_t *bus)
+static void brcmf_sdbrcm_sdlock(struct brcmf_bus *bus)
 {
 	if (bus->threads_only)
 		down(&bus->sdsem);
@@ -6698,7 +6698,7 @@ static void brcmf_sdbrcm_sdlock(dhd_bus_t *bus)
 		spin_lock_bh(&bus->sdlock);
 }
 
-static void brcmf_sdbrcm_sdunlock(dhd_bus_t *bus)
+static void brcmf_sdbrcm_sdunlock(struct brcmf_bus *bus)
 {
 	if (bus->threads_only)
 		up(&bus->sdsem);
@@ -6706,7 +6706,7 @@ static void brcmf_sdbrcm_sdunlock(dhd_bus_t *bus)
 		spin_unlock_bh(&bus->sdlock);
 }
 
-static int brcmf_sdbrcm_get_image(char *buf, int len, struct dhd_bus *bus)
+static int brcmf_sdbrcm_get_image(char *buf, int len, struct brcmf_bus *bus)
 {
 	if (bus->firmware->size < bus->fw_ptr + len)
 		len = bus->firmware->size - bus->fw_ptr;
-- 
1.7.1


