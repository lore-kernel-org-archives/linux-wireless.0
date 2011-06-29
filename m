Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mms1.broadcom.com ([216.31.210.17]:2091 "EHLO mms1.broadcom.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757990Ab1F2Xss (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 29 Jun 2011 19:48:48 -0400
From: "Franky Lin" <frankyl@broadcom.com>
To: gregkh@suse.de
cc: devel@linuxdriverproject.org, linux-wireless@vger.kernel.org
Subject: [PATCH 055/119] staging: brcm80211: rename more brcmfmac module
 parameters
Date: Wed, 29 Jun 2011 16:47:19 -0700
Message-ID: <1309391303-22741-56-git-send-email-frankyl@broadcom.com> (sfid-20110630_015038_060343_270E9D02)
In-Reply-To: <1309391303-22741-1-git-send-email-frankyl@broadcom.com>
References: <1309391303-22741-1-git-send-email-frankyl@broadcom.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Arend van Spriel <arend@broadcom.com>

Renamed remaining brcmfmac module parameters to more consistent
naming convention.

Signed-off-by: Arend van Spriel <arend@broadcom.com>
Reviewed-by: Roland Vossen <rvossen@broadcom.com>
Reviewed-by: Franky Lin <frankyl@broadcom.com>
---
 drivers/staging/brcm80211/brcmfmac/dhd_linux.c |   74 ++++++++++++------------
 drivers/staging/brcm80211/brcmfmac/dhd_sdio.c  |   42 +++++++-------
 2 files changed, 58 insertions(+), 58 deletions(-)

diff --git a/drivers/staging/brcm80211/brcmfmac/dhd_linux.c b/drivers/staging/brcm80211/brcmfmac/dhd_linux.c
index fb5bef0..5aa4492 100644
--- a/drivers/staging/brcm80211/brcmfmac/dhd_linux.c
+++ b/drivers/staging/brcm80211/brcmfmac/dhd_linux.c
@@ -248,15 +248,15 @@ module_param_string(firmware_path, firmware_path, MOD_PARAM_PATHLEN, 0);
 module_param_string(nvram_path, nvram_path, MOD_PARAM_PATHLEN, 0);
 
 /* No firmware required */
-bool dhd_no_fw_req;
-module_param(dhd_no_fw_req, bool, 0);
+bool brcmf_no_fw_req;
+module_param(brcmf_no_fw_req, bool, 0);
 
 /* Error bits */
 module_param(brcmf_msg_level, int, 0);
 
 /* Spawn a thread for system ioctls (set mac, set mcast) */
-uint dhd_sysioc = true;
-module_param(dhd_sysioc, uint, 0);
+uint brcmf_sysioc = true;
+module_param(brcmf_sysioc, uint, 0);
 
 /* Watchdog interval */
 uint brcmf_watchdog_ms = 10;
@@ -290,16 +290,16 @@ uint brcmf_master_mode = true;
 module_param(brcmf_master_mode, uint, 1);
 
 /* Watchdog thread priority, -1 to use kernel timer */
-int dhd_watchdog_prio = 97;
-module_param(dhd_watchdog_prio, int, 0);
+int brcmf_watchdog_prio = 97;
+module_param(brcmf_watchdog_prio, int, 0);
 
 /* DPC thread priority, -1 to use tasklet */
-int dhd_dpc_prio = 98;
-module_param(dhd_dpc_prio, int, 0);
+int brcmf_dpc_prio = 98;
+module_param(brcmf_dpc_prio, int, 0);
 
 /* DPC thread priority, -1 to use tasklet */
-extern int dhd_dongle_memsize;
-module_param(dhd_dongle_memsize, int, 0);
+extern int brcmf_dongle_memsize;
+module_param(brcmf_dongle_memsize, int, 0);
 
 /* Contorl fw roaming */
 #ifdef CUSTOMER_HW2
@@ -318,7 +318,7 @@ module_param_string(iface_name, iface_name, IFNAMSIZ, 0);
 /* The following are specific to the SDIO dongle */
 
 /* IOCTL response timeout */
-int dhd_ioctl_timeout_msec = IOCTL_RESP_TIMEOUT;
+int brcmf_ioctl_timeout_msec = IOCTL_RESP_TIMEOUT;
 
 /* Idle timeout for backplane clock */
 int brcmf_idletime = BRCMF_IDLETIME_TICKS;
@@ -337,14 +337,14 @@ uint brcmf_sdiod_drive_strength = 6;
 module_param(brcmf_sdiod_drive_strength, uint, 0);
 
 /* Tx/Rx bounds */
-extern uint dhd_txbound;
-extern uint dhd_rxbound;
-module_param(dhd_txbound, uint, 0);
-module_param(dhd_rxbound, uint, 0);
+extern uint brcmf_txbound;
+extern uint brcmf_rxbound;
+module_param(brcmf_txbound, uint, 0);
+module_param(brcmf_rxbound, uint, 0);
 
 /* Deferred transmits */
-extern uint dhd_deferred_tx;
-module_param(dhd_deferred_tx, uint, 0);
+extern uint brcmf_deferred_tx;
+module_param(brcmf_deferred_tx, uint, 0);
 
 #ifdef SDTEST
 /* Echo packet generator (pkts/s) */
@@ -1204,10 +1204,10 @@ static int brcmf_watchdog_thread(void *data)
 	 * so get rid of all our resources
 	 */
 #ifdef DHD_SCHED
-	if (dhd_watchdog_prio > 0) {
+	if (brcmf_watchdog_prio > 0) {
 		struct sched_param param;
-		param.sched_priority = (dhd_watchdog_prio < MAX_RT_PRIO) ?
-		    dhd_watchdog_prio : (MAX_RT_PRIO - 1);
+		param.sched_priority = (brcmf_watchdog_prio < MAX_RT_PRIO) ?
+		    brcmf_watchdog_prio : (MAX_RT_PRIO - 1);
 		sched_setscheduler(current, SCHED_FIFO, &param);
 	}
 #endif				/* DHD_SCHED */
@@ -1264,11 +1264,11 @@ static int brcmf_dpc_thread(void *data)
 	 * so get rid of all our resources
 	 */
 #ifdef DHD_SCHED
-	if (dhd_dpc_prio > 0) {
+	if (brcmf_dpc_prio > 0) {
 		struct sched_param param;
 		param.sched_priority =
-		    (dhd_dpc_prio <
-		     MAX_RT_PRIO) ? dhd_dpc_prio : (MAX_RT_PRIO - 1);
+		    (brcmf_dpc_prio <
+		     MAX_RT_PRIO) ? brcmf_dpc_prio : (MAX_RT_PRIO - 1);
 		sched_setscheduler(current, SCHED_FIFO, &param);
 	}
 #endif				/* DHD_SCHED */
@@ -1843,7 +1843,7 @@ dhd_pub_t *brcmf_attach(struct dhd_bus *bus, uint bus_hdrlen)
 		DHD_ERROR(("wl_cfg80211_attach failed\n"));
 		goto fail;
 	}
-	if (!dhd_no_fw_req) {
+	if (!brcmf_no_fw_req) {
 		strcpy(brcmf_fw_path, wl_cfg80211_get_fwname());
 		strcpy(brcmf_nv_path, wl_cfg80211_get_nvramname());
 	}
@@ -1855,12 +1855,12 @@ dhd_pub_t *brcmf_attach(struct dhd_bus *bus, uint bus_hdrlen)
 
 	/* Initialize thread based operation and lock */
 	sema_init(&dhd->sdsem, 1);
-	if ((dhd_watchdog_prio >= 0) && (dhd_dpc_prio >= 0))
+	if ((brcmf_watchdog_prio >= 0) && (brcmf_dpc_prio >= 0))
 		dhd->threads_only = true;
 	else
 		dhd->threads_only = false;
 
-	if (dhd_dpc_prio >= 0) {
+	if (brcmf_dpc_prio >= 0) {
 		/* Initialize watchdog thread */
 		sema_init(&dhd->watchdog_sem, 0);
 		dhd->watchdog_tsk = kthread_run(brcmf_watchdog_thread, dhd,
@@ -1875,7 +1875,7 @@ dhd_pub_t *brcmf_attach(struct dhd_bus *bus, uint bus_hdrlen)
 	}
 
 	/* Set up the bottom half handler */
-	if (dhd_dpc_prio >= 0) {
+	if (brcmf_dpc_prio >= 0) {
 		/* Initialize DPC thread */
 		sema_init(&dhd->dpc_sem, 0);
 		dhd->dpc_tsk = kthread_run(brcmf_dpc_thread, dhd, "dhd_dpc");
@@ -1889,7 +1889,7 @@ dhd_pub_t *brcmf_attach(struct dhd_bus *bus, uint bus_hdrlen)
 		dhd->dpc_tsk = NULL;
 	}
 
-	if (dhd_sysioc) {
+	if (brcmf_sysioc) {
 		sema_init(&dhd->sysioc_sem, 0);
 		dhd->sysioc_tsk = kthread_run(_brcmf_sysioc_thread, dhd,
 						"_dhd_sysioc");
@@ -2228,12 +2228,12 @@ static int __init brcmf_module_init(void)
 	/* Sanity check on the module parameters */
 	do {
 		/* Both watchdog and DPC as tasklets are ok */
-		if ((dhd_watchdog_prio < 0) && (dhd_dpc_prio < 0))
+		if ((brcmf_watchdog_prio < 0) && (brcmf_dpc_prio < 0))
 			break;
 
 		/* If both watchdog and DPC are threads, TX must be deferred */
-		if ((dhd_watchdog_prio >= 0) && (dhd_dpc_prio >= 0)
-		    && dhd_deferred_tx)
+		if ((brcmf_watchdog_prio >= 0) && (brcmf_dpc_prio >= 0)
+		    && brcmf_deferred_tx)
 			break;
 
 		DHD_ERROR(("Invalid module parameters.\n"));
@@ -2307,19 +2307,19 @@ int brcmf_os_proto_unblock(dhd_pub_t *pub)
 
 unsigned int brcmf_os_get_ioctl_resp_timeout(void)
 {
-	return (unsigned int)dhd_ioctl_timeout_msec;
+	return (unsigned int)brcmf_ioctl_timeout_msec;
 }
 
 void brcmf_os_set_ioctl_resp_timeout(unsigned int timeout_msec)
 {
-	dhd_ioctl_timeout_msec = (int)timeout_msec;
+	brcmf_ioctl_timeout_msec = (int)timeout_msec;
 }
 
 int brcmf_os_ioctl_resp_wait(dhd_pub_t *pub, uint *condition, bool *pending)
 {
 	dhd_info_t *dhd = (dhd_info_t *) (pub->info);
 	DECLARE_WAITQUEUE(wait, current);
-	int timeout = dhd_ioctl_timeout_msec;
+	int timeout = brcmf_ioctl_timeout_msec;
 
 	/* Convert timeout in millsecond to jiffies */
 	timeout = timeout * HZ / 1000;
@@ -2399,7 +2399,7 @@ void *brcmf_os_open_image(char *filename)
 {
 	struct file *fp;
 
-	if (!dhd_no_fw_req)
+	if (!brcmf_no_fw_req)
 		return wl_cfg80211_request_fw(filename);
 
 	fp = filp_open(filename, O_RDONLY, 0);
@@ -2420,7 +2420,7 @@ int brcmf_os_get_image_block(char *buf, int len, void *image)
 	struct file *fp = (struct file *)image;
 	int rdlen;
 
-	if (!dhd_no_fw_req)
+	if (!brcmf_no_fw_req)
 		return wl_cfg80211_read_fw(buf, len);
 
 	if (!image)
@@ -2435,7 +2435,7 @@ int brcmf_os_get_image_block(char *buf, int len, void *image)
 
 void brcmf_os_close_image(void *image)
 {
-	if (!dhd_no_fw_req)
+	if (!brcmf_no_fw_req)
 		return wl_cfg80211_release_fw();
 	if (image)
 		filp_close((struct file *)image, NULL);
diff --git a/drivers/staging/brcm80211/brcmfmac/dhd_sdio.c b/drivers/staging/brcm80211/brcmfmac/dhd_sdio.c
index 905afbc..003f485 100644
--- a/drivers/staging/brcm80211/brcmfmac/dhd_sdio.c
+++ b/drivers/staging/brcm80211/brcmfmac/dhd_sdio.c
@@ -650,16 +650,16 @@ static int tx_packets[NUMPRIO];
 #endif				/* DHD_DEBUG */
 
 /* Deferred transmit */
-const uint dhd_deferred_tx = 1;
+const uint brcmf_deferred_tx = 1;
 
 /* Tx/Rx bounds */
-uint dhd_txbound;
-uint dhd_rxbound;
+uint brcmf_txbound;
+uint brcmf_rxbound;
 uint dhd_txminmax;
 
 /* override the RAM size if possible */
 #define DONGLE_MIN_MEMSIZE (128 * 1024)
-int dhd_dongle_memsize;
+int brcmf_dongle_memsize;
 
 static bool dhd_alignctl;
 
@@ -807,10 +807,10 @@ static void brcmf_sdbrcm_setmemsize(struct dhd_bus *bus, int mem_size)
 	s32 min_size = DONGLE_MIN_MEMSIZE;
 	/* Restrict the memsize to user specified limit */
 	DHD_ERROR(("user: Restrict the dongle ram size to %d, min %d\n",
-		dhd_dongle_memsize, min_size));
-	if ((dhd_dongle_memsize > min_size) &&
-	    (dhd_dongle_memsize < (s32) bus->orig_ramsize))
-		bus->ramsize = dhd_dongle_memsize;
+		brcmf_dongle_memsize, min_size));
+	if ((brcmf_dongle_memsize > min_size) &&
+	    (brcmf_dongle_memsize < (s32) bus->orig_ramsize))
+		bus->ramsize = brcmf_dongle_memsize;
 }
 
 static int brcmf_sdbrcm_set_siaddr_window(dhd_bus_t *bus, u32 address)
@@ -1363,7 +1363,7 @@ int brcmf_sdbrcm_bus_txdata(struct dhd_bus *bus, struct sk_buff *pkt)
 
 	/* Check for existing queue, current flow-control,
 			 pending event, or pending clock */
-	if (dhd_deferred_tx || bus->fcstate || pktq_len(&bus->txq)
+	if (brcmf_deferred_tx || bus->fcstate || pktq_len(&bus->txq)
 	    || bus->dpc_sched || (!DATAOK(bus))
 	    || (bus->flowcontrol & NBITVAL(prec))
 	    || (bus->clkstate != CLK_AVAIL)) {
@@ -1392,7 +1392,7 @@ int brcmf_sdbrcm_bus_txdata(struct dhd_bus *bus, struct sk_buff *pkt)
 			qcount[prec] = pktq_plen(&bus->txq, prec);
 #endif
 		/* Schedule DPC if needed to send queued packet(s) */
-		if (dhd_deferred_tx && !bus->dpc_sched) {
+		if (brcmf_deferred_tx && !bus->dpc_sched) {
 			bus->dpc_sched = true;
 			brcmf_sched_dpc(bus->dhd);
 		}
@@ -2703,21 +2703,21 @@ brcmf_sdbrcm_doiovar(dhd_bus_t *bus, const struct brcmu_iovar *vi, u32 actionid,
 		break;
 
 	case IOV_GVAL(IOV_TXBOUND):
-		int_val = (s32) dhd_txbound;
+		int_val = (s32) brcmf_txbound;
 		memcpy(arg, &int_val, val_size);
 		break;
 
 	case IOV_SVAL(IOV_TXBOUND):
-		dhd_txbound = (uint) int_val;
+		brcmf_txbound = (uint) int_val;
 		break;
 
 	case IOV_GVAL(IOV_RXBOUND):
-		int_val = (s32) dhd_rxbound;
+		int_val = (s32) brcmf_rxbound;
 		memcpy(arg, &int_val, val_size);
 		break;
 
 	case IOV_SVAL(IOV_RXBOUND):
-		dhd_rxbound = (uint) int_val;
+		brcmf_rxbound = (uint) int_val;
 		break;
 
 	case IOV_GVAL(IOV_TXMINMAX):
@@ -4443,8 +4443,8 @@ bool brcmf_sdbrcm_dpc(dhd_bus_t *bus)
 	struct sdpcmd_regs *regs = bus->regs;
 	u32 intstatus, newstatus = 0;
 	uint retries = 0;
-	uint rxlimit = dhd_rxbound;	/* Rx frames to read before resched */
-	uint txlimit = dhd_txbound;	/* Tx frames to send before resched */
+	uint rxlimit = brcmf_rxbound;	/* Rx frames to read before resched */
+	uint txlimit = brcmf_txbound;	/* Tx frames to send before resched */
 	uint framecnt = 0;	/* Temporary counter of tx/rx frames */
 	bool rxdone = true;	/* Flag for no more read data */
 	bool resched = false;	/* Flag indicating resched wanted */
@@ -5201,13 +5201,13 @@ static void *brcmf_sdbrcm_probe(u16 venid, u16 devid, u16 bus_no,
 	 * first time that the driver is initialized vs subsequent
 	 * initializations.
 	 */
-	dhd_txbound = DHD_TXBOUND;
-	dhd_rxbound = DHD_RXBOUND;
+	brcmf_txbound = DHD_TXBOUND;
+	brcmf_rxbound = DHD_RXBOUND;
 	dhd_alignctl = true;
 	sd1idle = true;
 	dhd_readahead = true;
 	retrydata = false;
-	dhd_dongle_memsize = 0;
+	brcmf_dongle_memsize = 0;
 	dhd_txminmax = DHD_TXMINMAX;
 
 	forcealign = true;
@@ -5402,8 +5402,8 @@ brcmf_sdbrcm_probe_attach(struct dhd_bus *bus, void *sdh, void *regsva,
 			goto fail;
 		}
 		bus->ramsize = bus->orig_ramsize;
-		if (dhd_dongle_memsize)
-			brcmf_sdbrcm_setmemsize(bus, dhd_dongle_memsize);
+		if (brcmf_dongle_memsize)
+			brcmf_sdbrcm_setmemsize(bus, brcmf_dongle_memsize);
 
 		DHD_ERROR(("DHD: dongle ram size is set to %d(orig %d)\n",
 			   bus->ramsize, bus->orig_ramsize));
-- 
1.7.1


