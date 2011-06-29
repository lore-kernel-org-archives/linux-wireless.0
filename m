Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mms2.broadcom.com ([216.31.210.18]:4671 "EHLO mms2.broadcom.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757427Ab1F2XtR (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 29 Jun 2011 19:49:17 -0400
From: "Franky Lin" <frankyl@broadcom.com>
To: gregkh@suse.de
cc: devel@linuxdriverproject.org, linux-wireless@vger.kernel.org
Subject: [PATCH 065/119] staging: brcm80211: always enable code for
 PLATFORM_BUS functionality
Date: Wed, 29 Jun 2011 16:47:29 -0700
Message-ID: <1309391303-22741-66-git-send-email-frankyl@broadcom.com> (sfid-20110630_015206_148409_791ADA28)
In-Reply-To: <1309391303-22741-1-git-send-email-frankyl@broadcom.com>
References: <1309391303-22741-1-git-send-email-frankyl@broadcom.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Arend van Spriel <arend@broadcom.com>

Some code is conditionally compiled in upon defintion of PLATFORM_BUS
macro. This patch will have it compiled in unconditionally.

Signed-off-by: Arend van Spriel <arend@broadcom.com>
Reviewed-by: Roland Vossen <rvossen@broadcom.com>
Reviewed-by: Franky Lin <frankyl@broadcom.com>
---
 drivers/staging/brcm80211/brcmfmac/Makefile       |    1 -
 drivers/staging/brcm80211/brcmfmac/bcmsdh_linux.c |    9 ---------
 2 files changed, 0 insertions(+), 10 deletions(-)

diff --git a/drivers/staging/brcm80211/brcmfmac/Makefile b/drivers/staging/brcm80211/brcmfmac/Makefile
index f76e62a..0674a6a 100644
--- a/drivers/staging/brcm80211/brcmfmac/Makefile
+++ b/drivers/staging/brcm80211/brcmfmac/Makefile
@@ -16,7 +16,6 @@
 # CONNECTION WITH THE USE OR PERFORMANCE OF THIS SOFTWARE.
 
 ccflags-y :=			\
-	-DBCMPLATFORM_BUS	\
 	-DBCMSDIO		\
 	-DBRCM_FULLMAC		\
 	-DBRCMF_FIRSTREAD=64	\
diff --git a/drivers/staging/brcm80211/brcmfmac/bcmsdh_linux.c b/drivers/staging/brcm80211/brcmfmac/bcmsdh_linux.c
index 5243f33..5194c59 100644
--- a/drivers/staging/brcm80211/brcmfmac/bcmsdh_linux.c
+++ b/drivers/staging/brcm80211/brcmfmac/bcmsdh_linux.c
@@ -36,9 +36,6 @@
 extern void brcmf_sdbrcm_isr(void *args);
 #endif				/* defined(OOB_INTR_ONLY) */
 #if defined(CONFIG_MACH_SANDGATE2G) || defined(CONFIG_MACH_LOGICPD_PXA270)
-#if !defined(BCMPLATFORM_BUS)
-#define BCMPLATFORM_BUS
-#endif				/* !defined(BCMPLATFORM_BUS) */
 
 #include <linux/platform_device.h>
 #endif				/* CONFIG_MACH_SANDGATE2G */
@@ -51,11 +48,7 @@ extern void brcmf_sdbrcm_isr(void *args);
  */
 struct bcmsdh_hc {
 	struct bcmsdh_hc *next;
-#ifdef BCMPLATFORM_BUS
 	struct device *dev;	/* platform device handle */
-#else
-	struct pci_dev *dev;	/* pci device handle */
-#endif				/* BCMPLATFORM_BUS */
 	void *regs;		/* SDIO Host Controller address */
 	struct brcmf_sdio *sdh;	/* SDIO Host Controller handle */
 	void *ch;
@@ -120,7 +113,6 @@ bool brcmf_sdio_chipmatch(u16 vendor, u16 device)
 	return false;
 }
 
-#if defined(BCMPLATFORM_BUS)
 /* forward declarations */
 int brcmf_sdio_probe(struct device *dev);
 EXPORT_SYMBOL(brcmf_sdio_probe);
@@ -228,7 +220,6 @@ int brcmf_sdio_remove(struct device *dev)
 	kfree(sdhc);
 	return 0;
 }
-#endif				/* BCMPLATFORM_BUS */
 
 extern int brcmf_sdio_function_init(void);
 
-- 
1.7.1


