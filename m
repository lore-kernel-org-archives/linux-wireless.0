Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mms1.broadcom.com ([216.31.210.17]:2817 "EHLO mms1.broadcom.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752870Ab1HHN70 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 8 Aug 2011 09:59:26 -0400
From: "Arend van Spriel" <arend@broadcom.com>
To: gregkh@suse.de
cc: devel@linuxdriverproject.org, linux-wireless@vger.kernel.org,
	"Roland Vossen" <rvossen@broadcom.com>,
	"Arend van Spriel" <arend@broadcom.com>
Subject: [PATCHv2 23/82] staging: brcm80211: fix for checkpatch 'avoid
 externs in c file' warning
Date: Mon, 8 Aug 2011 15:58:07 +0200
Message-ID: <1312811946-16713-24-git-send-email-arend@broadcom.com> (sfid-20110808_160204_644111_C8BEE756)
In-Reply-To: <1312811946-16713-1-git-send-email-arend@broadcom.com>
References: <1312811946-16713-1-git-send-email-arend@broadcom.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Roland Vossen <rvossen@broadcom.com>

Signed-off-by: Roland Vossen <rvossen@broadcom.com>
Reviewed-by: Arend van Spriel <arend@broadcom.com>
Reviewed-by: Franky Lin <frankyl@broadcom.com>
Signed-off-by: Arend van Spriel <arend@broadcom.com>
---
 drivers/staging/brcm80211/brcmfmac/bcmsdh.c    |   10 ++--------
 drivers/staging/brcm80211/brcmfmac/dhd_linux.c |    4 ++--
 drivers/staging/brcm80211/brcmfmac/sdio_host.h |    1 +
 3 files changed, 5 insertions(+), 10 deletions(-)

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
index 4ba9d7d..b0a9862 100644
--- a/drivers/staging/brcm80211/brcmfmac/dhd_linux.c
+++ b/drivers/staging/brcm80211/brcmfmac/dhd_linux.c
@@ -423,7 +423,7 @@ static int _brcmf_set_mac_address(struct brcmf_info *drvr_priv, int ifidx, u8 *a
 }
 
 #ifdef SOFTAP
-extern struct net_device *ap_net_dev;
+static struct net_device *ap_net_dev;
 #endif
 
 /* Virtual interfaces only ((ifp && ifp->info && ifp->idx == true) */
@@ -469,7 +469,7 @@ static void brcmf_op_if(struct brcmf_if *ifp)
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
 
-- 
1.7.4.1


