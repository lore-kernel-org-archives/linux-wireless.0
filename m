Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:33177 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752285Ab0IJAi3 convert rfc822-to-8bit
	(ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 9 Sep 2010 20:38:29 -0400
From: Ben Hutchings <ben@decadent.org.uk>
To: Greg Kroah-Hartman <gregkh@suse.de>
Cc: Brett Rudley <brudley@broadcom.com>,
	Henry Ptasinski <henryp@broadcom.com>,
	Nohee Ko <noheek@broadcom.com>, linux-wireless@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Date: Fri, 10 Sep 2010 01:38:18 +0100
Message-ID: <1284079098.5323.595.camel@localhost>
Mime-Version: 1.0
Subject: [PATCH] brcm80211: Fix some initialisation failure paths
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Initialise wl_info::tasklet early so that it's safe to tasklet_kill()
it in wl_free().

Remove assertions from wl_free() that may not be true in case of
initialisation failure.

Call wl_release_fw() in case of failure after wl_request_fw().
Don't rely on wl_firmware::fw_cnt in wl_release_fw().

Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
This is compile-tested only; I don't have any of the supported hardware
myself.

Ben.

 drivers/staging/brcm80211/TODO              |    1 -
 drivers/staging/brcm80211/sys/wl_mac80211.c |   25 ++++++++++++-------------
 2 files changed, 12 insertions(+), 14 deletions(-)

diff --git a/drivers/staging/brcm80211/TODO b/drivers/staging/brcm80211/TODO
index aa38d49..5870bca 100644
--- a/drivers/staging/brcm80211/TODO
+++ b/drivers/staging/brcm80211/TODO
@@ -25,7 +25,6 @@ Bugs
 - Various occasional asserts/hangs
 - Scanning during data transfer sometimes causes major slowdowns.  Sometimes
   revcovers when scan is done, other times not.
-- Driver does not handle missing firmware gracefully.
 - Mac80211 API not completely implemented (ie ops_bss_info_changed,
   ops_get_stats, etc)
 
diff --git a/drivers/staging/brcm80211/sys/wl_mac80211.c b/drivers/staging/brcm80211/sys/wl_mac80211.c
index d73ec44..3e0c450 100644
--- a/drivers/staging/brcm80211/sys/wl_mac80211.c
+++ b/drivers/staging/brcm80211/sys/wl_mac80211.c
@@ -837,6 +837,9 @@ static wl_info_t *wl_attach(uint16 vendor, uint16 device, ulong regs,
 	wl->osh = osh;
 	atomic_set(&wl->callbacks, 0);
 
+	/* setup the bottom half handler */
+	tasklet_init(&wl->tasklet, wl_dpc, (ulong) wl);
+
 #ifdef WLC_HIGH_ONLY
 	wl->rpc_th = bcm_rpc_tp_attach(osh, NULL);
 	if (wl->rpc_th == NULL) {
@@ -905,17 +908,16 @@ static wl_info_t *wl_attach(uint16 vendor, uint16 device, ulong regs,
 #endif
 
 	/* common load-time initialization */
-	if (!
-	    (wl->wlc =
-	     wlc_attach((void *)wl, vendor, device, unit, wl->piomode, osh,
-			wl->regsva, wl->bcm_bustype, btparam, &err))) {
+	wl->wlc = wlc_attach((void *)wl, vendor, device, unit, wl->piomode, osh,
+			     wl->regsva, wl->bcm_bustype, btparam, &err);
+#ifndef WLC_HIGH_ONLY
+	wl_release_fw(wl);
+#endif
+	if (!wl->wlc) {
 		printf("%s: %s driver failed with code %d\n", KBUILD_MODNAME,
 		       EPI_VERSION_STR, err);
 		goto fail;
 	}
-#ifndef WLC_HIGH_ONLY
-	wl_release_fw(wl);
-#endif
 	wl->pub = wlc_pub(wl->wlc);
 
 	wl->pub->ieee_hw = hw;
@@ -942,9 +944,6 @@ static wl_info_t *wl_attach(uint16 vendor, uint16 device, ulong regs,
 	wlc_iovar_setint(wl->wlc, "sd_drivestrength", sd_drivestrength);
 #endif
 
-	/* setup the bottom half handler */
-	tasklet_init(&wl->tasklet, wl_dpc, (ulong) wl);
-
 #ifdef WLC_LOW
 	/* register our interrupt handler */
 	if (request_irq(irq, wl_isr, IRQF_SHARED, KBUILD_MODNAME, wl)) {
@@ -1710,11 +1709,9 @@ void wl_free(wl_info_t * wl)
 
 	ASSERT(wl);
 #ifndef WLC_HIGH_ONLY
-	ASSERT(wl->irq);	/* bmac does not use direct interrupt */
 	/* free ucode data */
 	if (wl->fw.fw_cnt)
 		wl_ucode_data_free();
-	ASSERT(wl->wlc);
 	if (wl->irq)
 		free_irq(wl->irq, wl);
 #endif
@@ -2509,6 +2506,7 @@ static int wl_request_fw(wl_info_t * wl, struct pci_dev *pdev)
 		status = request_firmware(&wl->fw.fw_bin[i], fw_name, device);
 		if (status) {
 			printf("fail to request firmware %s\n", fw_name);
+			wl_release_fw(wl);
 			return status;
 		}
 		WL_NONE(("request fw %s\n", fw_name));
@@ -2517,6 +2515,7 @@ static int wl_request_fw(wl_info_t * wl, struct pci_dev *pdev)
 		status = request_firmware(&wl->fw.fw_hdr[i], fw_name, device);
 		if (status) {
 			printf("fail to request firmware %s\n", fw_name);
+			wl_release_fw(wl);
 			return status;
 		}
 		wl->fw.hdr_num_entries[i] =
@@ -2539,7 +2538,7 @@ void wl_ucode_free_buf(void *p)
 static void wl_release_fw(wl_info_t * wl)
 {
 	int i;
-	for (i = 0; i < wl->fw.fw_cnt; i++) {
+	for (i = 0; i < WL_MAX_FW; i++) {
 		release_firmware(wl->fw.fw_bin[i]);
 		release_firmware(wl->fw.fw_hdr[i]);
 	}
-- 
1.7.1


