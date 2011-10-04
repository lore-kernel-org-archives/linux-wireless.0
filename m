Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mms3.broadcom.com ([216.31.210.19]:2340 "EHLO MMS3.broadcom.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932558Ab1JDVTc (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 4 Oct 2011 17:19:32 -0400
From: "Arend van Spriel" <arend@broadcom.com>
To: gregkh@suse.de
cc: devel@linuxdriverproject.org, linux-wireless@vger.kernel.org,
	"Franky Lin" <frankyl@broadcom.com>,
	"Arend van Spriel" <arend@broadcom.com>
Subject: [PATCH 09/26] staging: brcm80211: stop using assigned thread
 priority in fullmac
Date: Tue, 4 Oct 2011 23:18:55 +0200
Message-ID: <1317763152-17607-10-git-send-email-arend@broadcom.com> (sfid-20111004_231936_794650_7ABA7F6B)
In-Reply-To: <1317763152-17607-1-git-send-email-arend@broadcom.com>
References: <1317763152-17607-1-git-send-email-arend@broadcom.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Franky Lin <frankyl@broadcom.com>

Stop assigning priority to watchdog and dpc threads. Remove related
code.

Reviewed-by: Arend van Spriel <arend@broadcom.com>
Reviewed-by: Roland Vossen <rvossen@broadcom.com>
Reviewed-by: Pieter-Paul Giesberts <pieterpg@broadcom.com>
Signed-off-by: Arend van Spriel <arend@broadcom.com>
---
 drivers/staging/brcm80211/brcmfmac/dhd_sdio.c |   60 ++----------------------
 1 files changed, 5 insertions(+), 55 deletions(-)

diff --git a/drivers/staging/brcm80211/brcmfmac/dhd_sdio.c b/drivers/staging/brcm80211/brcmfmac/dhd_sdio.c
index 6c2391b..f3e6249 100644
--- a/drivers/staging/brcm80211/brcmfmac/dhd_sdio.c
+++ b/drivers/staging/brcm80211/brcmfmac/dhd_sdio.c
@@ -715,14 +715,6 @@ static int qcount[NUMPRIO];
 static int tx_packets[NUMPRIO];
 #endif				/* BCMDBG */
 
-/* Watchdog thread priority, -1 to use kernel timer */
-int brcmf_watchdog_prio = 97;
-module_param(brcmf_watchdog_prio, int, 0);
-
-/* DPC thread priority, -1 to use tasklet */
-int brcmf_dpc_prio = 98;
-module_param(brcmf_dpc_prio, int, 0);
-
 #define SDIO_DRIVE_STRENGTH	6	/* in milliamps */
 
 #define RETRYCHAN(chan) ((chan) == SDPCM_EVENT_CHANNEL)
@@ -2692,16 +2684,6 @@ static int brcmf_sdbrcm_dpc_thread(void *data)
 {
 	struct brcmf_bus *bus = (struct brcmf_bus *) data;
 
-	/* This thread doesn't need any user-level access,
-	 * so get rid of all our resources
-	 */
-	if (brcmf_dpc_prio > 0) {
-		struct sched_param param;
-		param.sched_priority = (brcmf_dpc_prio < MAX_RT_PRIO) ?
-				       brcmf_dpc_prio : (MAX_RT_PRIO - 1);
-		sched_setscheduler(current, SCHED_FIFO, &param);
-	}
-
 	allow_signal(SIGTERM);
 	/* Run until signal received */
 	while (1) {
@@ -4364,16 +4346,6 @@ brcmf_sdbrcm_watchdog_thread(void *data)
 {
 	struct brcmf_bus *bus = (struct brcmf_bus *)data;
 
-	/* This thread doesn't need any user-level access,
-	* so get rid of all our resources
-	*/
-	if (brcmf_watchdog_prio > 0) {
-		struct sched_param param;
-		param.sched_priority = (brcmf_watchdog_prio < MAX_RT_PRIO) ?
-				       brcmf_watchdog_prio : (MAX_RT_PRIO - 1);
-		sched_setscheduler(current, SCHED_FIFO, &param);
-	}
-
 	allow_signal(SIGTERM);
 	/* Run until signal received */
 	while (1) {
@@ -4394,7 +4366,7 @@ brcmf_sdbrcm_watchdog(unsigned long data)
 {
 	struct brcmf_bus *bus = (struct brcmf_bus *)data;
 
-	if (brcmf_watchdog_prio >= 0) {
+	if (bus->threads_only) {
 		if (bus->watchdog_tsk)
 			complete(&bus->watchdog_wait);
 		else
@@ -4493,6 +4465,7 @@ void *brcmf_sdbrcm_probe(u16 bus_no, u16 slot, u16 func, uint bustype,
 	bus->tx_seq = SDPCM_SEQUENCE_WRAP - 1;
 	bus->usebufpool = false;	/* Use bufpool if allocated,
 					 else use locally malloced rxbuf */
+	bus->threads_only = true;
 
 	/* attempt to attach to the dongle */
 	if (!(brcmf_sdbrcm_probe_attach(bus, regsva))) {
@@ -4510,14 +4483,9 @@ void *brcmf_sdbrcm_probe(u16 bus_no, u16 slot, u16 func, uint bustype,
 	bus->timer.function = brcmf_sdbrcm_watchdog;
 
 	/* Initialize thread based operation and lock */
-	if ((brcmf_watchdog_prio >= 0) && (brcmf_dpc_prio >= 0)) {
-		bus->threads_only = true;
+	if (bus->threads_only) {
 		sema_init(&bus->sdsem, 1);
-	} else {
-		bus->threads_only = false;
-	}
 
-	if (brcmf_dpc_prio >= 0) {
 		/* Initialize watchdog thread */
 		init_completion(&bus->watchdog_wait);
 		bus->watchdog_tsk = kthread_run(brcmf_sdbrcm_watchdog_thread,
@@ -4527,11 +4495,6 @@ void *brcmf_sdbrcm_probe(u16 bus_no, u16 slot, u16 func, uint bustype,
 			       "brcmf_watchdog thread failed to start\n");
 			bus->watchdog_tsk = NULL;
 		}
-	} else
-		bus->watchdog_tsk = NULL;
-
-	/* Set up the bottom half handler */
-	if (brcmf_dpc_prio >= 0) {
 		/* Initialize DPC thread */
 		init_completion(&bus->dpc_wait);
 		bus->dpc_tsk = kthread_run(brcmf_sdbrcm_dpc_thread,
@@ -4542,9 +4505,10 @@ void *brcmf_sdbrcm_probe(u16 bus_no, u16 slot, u16 func, uint bustype,
 			bus->dpc_tsk = NULL;
 		}
 	} else {
+		bus->watchdog_tsk = NULL;
+		bus->dpc_tsk = NULL;
 		tasklet_init(&bus->tasklet, brcmf_sdbrcm_dpc_tasklet,
 			     (unsigned long)bus);
-		bus->dpc_tsk = NULL;
 	}
 
 	/* Attach to the brcmf/OS/network interface */
@@ -4613,20 +4577,6 @@ int brcmf_bus_register(void)
 {
 	brcmf_dbg(TRACE, "Enter\n");
 
-	/* Sanity check on the module parameters */
-	do {
-		/* Both watchdog and DPC as tasklets are ok */
-		if ((brcmf_watchdog_prio < 0) && (brcmf_dpc_prio < 0))
-			break;
-
-		/* If both watchdog and DPC are threads, TX must be deferred */
-		if (brcmf_watchdog_prio >= 0 && brcmf_dpc_prio >= 0)
-			break;
-
-		brcmf_dbg(ERROR, "Invalid module parameters.\n");
-		return -EINVAL;
-	} while (0);
-
 	return brcmf_sdio_register();
 }
 
-- 
1.7.4.1


