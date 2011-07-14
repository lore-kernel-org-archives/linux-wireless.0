Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mms1.broadcom.com ([216.31.210.17]:4277 "EHLO mms1.broadcom.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932382Ab1GNV34 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 14 Jul 2011 17:29:56 -0400
From: "Franky Lin" <frankyl@broadcom.com>
To: gregkh@suse.de
cc: devel@linuxdriverproject.org, linux-wireless@vger.kernel.org
Subject: [PATCH 22/35] staging: brcm80211: fix for checkpatch 'avoid
 externs in c file' warning
Date: Thu, 14 Jul 2011 14:29:18 -0700
Message-ID: <1310678971-28952-23-git-send-email-frankyl@broadcom.com> (sfid-20110714_233137_947147_CACBE0D8)
In-Reply-To: <1310678971-28952-1-git-send-email-frankyl@broadcom.com>
References: <1310678971-28952-1-git-send-email-frankyl@broadcom.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Roland Vossen <rvossen@broadcom.com>

Signed-off-by: Roland Vossen <rvossen@broadcom.com>
Reviewed-by: Arend van Spriel <arend@broadcom.com>
Reviewed-by: Franky Lin <frankyl@broadcom.com>
---
 drivers/staging/brcm80211/brcmfmac/bcmsdh.c    |   10 ++--------
 drivers/staging/brcm80211/brcmfmac/dhd_linux.c |    4 ++--
 drivers/staging/brcm80211/brcmfmac/sdio_host.h |    1 +
 drivers/staging/brcm80211/brcmsmac/main.c      |    3 +--
 4 files changed, 6 insertions(+), 12 deletions(-)

diff --git a/drivers/staging/brcm80211/brcmfmac/bcmsdh.c b/drivers/staging/brcm80211/brcmfmac/bcmsdh.c
index f4e72ed..fb3ab63 100644
--- a/drivers/staging/brcm80211/brcmfmac/bcmsdh.c
+++ b/drivers/staging/brcm80211/brcmfmac/bcmsdh.c
@@ -103,16 +103,8 @@ static struct brcmf_sdioh_driver drvinfo = { NULL, NULL };
 
 module_param(sd_msglevel, uint, 0);
 
-extern uint sd_f2_blocksize;
 module_param(sd_f2_blocksize, int, 0);
 
-/* forward declarations */
-int brcmf_sdio_probe(struct device *dev);
-EXPORT_SYMBOL(brcmf_sdio_probe);
-
-int brcmf_sdio_remove(struct device *dev);
-EXPORT_SYMBOL(brcmf_sdio_remove);
-
 struct brcmf_sdio_card*
 brcmf_sdcard_attach(void *cfghdl, u32 *regsva, uint irq)
 {
@@ -590,6 +582,7 @@ err:
 
 	return -ENODEV;
 }
+EXPORT_SYMBOL(brcmf_sdio_probe);
 
 int brcmf_sdio_remove(struct device *dev)
 {
@@ -619,6 +612,7 @@ int brcmf_sdio_remove(struct device *dev)
 	kfree(sdhc);
 	return 0;
 }
+EXPORT_SYMBOL(brcmf_sdio_remove);
 
 int brcmf_sdio_register(struct brcmf_sdioh_driver *driver)
 {
diff --git a/drivers/staging/brcm80211/brcmfmac/dhd_linux.c b/drivers/staging/brcm80211/brcmfmac/dhd_linux.c
index 310a96f..9ee566c 100644
--- a/drivers/staging/brcm80211/brcmfmac/dhd_linux.c
+++ b/drivers/staging/brcm80211/brcmfmac/dhd_linux.c
@@ -422,7 +422,7 @@ static int _brcmf_set_mac_address(struct brcmf_info *drvr_priv, int ifidx, u8 *a
 }
 
 #ifdef SOFTAP
-extern struct net_device *ap_net_dev;
+static struct net_device *ap_net_dev;
 #endif
 
 /* Virtual interfaces only ((ifp && ifp->info && ifp->idx == true) */
@@ -468,7 +468,7 @@ static void brcmf_op_if(struct brcmf_if *ifp)
 #ifdef SOFTAP
 				/* semaphore that the soft AP CODE
 					 waits on */
-				extern struct semaphore ap_eth_sema;
+				struct semaphore ap_eth_sema;
 
 				/* save ptr to wl0.1 netdev for use
 					 in wl_iw.c  */
diff --git a/drivers/staging/brcm80211/brcmfmac/sdio_host.h b/drivers/staging/brcm80211/brcmfmac/sdio_host.h
index d345472..ad67955 100644
--- a/drivers/staging/brcm80211/brcmfmac/sdio_host.h
+++ b/drivers/staging/brcm80211/brcmfmac/sdio_host.h
@@ -341,6 +341,7 @@ extern int brcmf_sdioh_abort(struct sdioh_info *si, uint fnc);
 extern void brcmf_sdio_wdtmr_enable(bool enable);
 
 extern uint sd_msglevel;	/* Debug message level */
+extern uint sd_f2_blocksize;
 
 extern struct brcmf_sdmmc_instance *gInstance;
 
diff --git a/drivers/staging/brcm80211/brcmsmac/main.c b/drivers/staging/brcm80211/brcmsmac/main.c
index ec3a4db..85d161c 100644
--- a/drivers/staging/brcm80211/brcmsmac/main.c
+++ b/drivers/staging/brcm80211/brcmsmac/main.c
@@ -3552,8 +3552,7 @@ void brcms_c_switch_shortslot(struct brcms_c_info *wlc, bool shortslot)
 		if (wlc->shortslot)
 			cfg->current_bss->capability |=
 					WLAN_CAPABILITY_SHORT_SLOT_TIME;
-	END_FOREACH_BSS
-
+	END_FOREACH_BSS /* this comment fixes a checkpatch warning */
 
 	brcms_b_set_shortslot(wlc->hw, shortslot);
 }
-- 
1.7.1


