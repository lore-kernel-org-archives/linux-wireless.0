Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mms1.broadcom.com ([216.31.210.17]:2275 "EHLO mms1.broadcom.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758811Ab1FALq3 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 1 Jun 2011 07:46:29 -0400
From: "Roland Vossen" <rvossen@broadcom.com>
To: gregkh@suse.de
cc: devel@linuxdriverproject.org, linux-wireless@vger.kernel.org
Subject: [PATCH 47/83] staging: brcm80211: macro cleanup
Date: Wed, 1 Jun 2011 13:45:32 +0200
Message-ID: <1306928768-7501-47-git-send-email-rvossen@broadcom.com> (sfid-20110601_134704_808323_F2E215AB)
In-Reply-To: <1306928768-7501-1-git-send-email-rvossen@broadcom.com>
References: <1306928768-7501-1-git-send-email-rvossen@broadcom.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Code cleanup. Replaced bcopy() by memcpy(). Removed redundant PAD
macro definitions.

Signed-off-by: Roland Vossen <rvossen@broadcom.com>
Reviewed-by: Arend van Spriel <arend@broadcom.com>
---
 drivers/staging/brcm80211/brcmfmac/dhd_sdio.c   |    8 --------
 drivers/staging/brcm80211/brcmfmac/sbsdpcmdev.h |    7 -------
 drivers/staging/brcm80211/brcmsmac/aiutils.c    |    2 +-
 drivers/staging/brcm80211/brcmsmac/aiutils.h    |    7 -------
 drivers/staging/brcm80211/brcmsmac/bcmnvram.h   |    4 ----
 drivers/staging/brcm80211/brcmsmac/d11.h        |    7 -------
 drivers/staging/brcm80211/brcmsmac/nicpci.c     |    7 -------
 drivers/staging/brcm80211/include/aidmp.h       |    6 ++----
 drivers/staging/brcm80211/include/bcmutils.h    |    2 --
 drivers/staging/brcm80211/include/chipcommon.h  |    7 +------
 10 files changed, 4 insertions(+), 53 deletions(-)

diff --git a/drivers/staging/brcm80211/brcmfmac/dhd_sdio.c b/drivers/staging/brcm80211/brcmfmac/dhd_sdio.c
index ebead09..835beaa 100644
--- a/drivers/staging/brcm80211/brcmfmac/dhd_sdio.c
+++ b/drivers/staging/brcm80211/brcmfmac/dhd_sdio.c
@@ -60,8 +60,6 @@
 
 #define	TRAP_T_SIZE	80
 
-#ifndef	_LANGUAGE_ASSEMBLY
-
 typedef struct _trap_struct {
 	u32 type;
 	u32 epc;
@@ -85,8 +83,6 @@ typedef struct _trap_struct {
 	u32 pc;
 } trap_t;
 
-#endif				/* !_LANGUAGE_ASSEMBLY */
-
 #define CBUF_LEN	(128)
 
 #define LOG_BUF_LEN	1024
@@ -447,8 +443,6 @@ typedef struct dhd_bus {
 	bool ctrl_frame_stat;
 } dhd_bus_t;
 
-#ifndef _LANGUAGE_ASSEMBLY
-
 typedef volatile struct _sbconfig {
 	u32 PAD[2];
 	u32 sbipsflag;	/* initiator port ocp slave flag */
@@ -489,8 +483,6 @@ typedef volatile struct _sbconfig {
 	u32 sbidhigh;	/* identification */
 } sbconfig_t;
 
-#endif				/* _LANGUAGE_ASSEMBLY */
-
 /* clkstate */
 #define CLK_NONE	0
 #define CLK_SDONLY	1
diff --git a/drivers/staging/brcm80211/brcmfmac/sbsdpcmdev.h b/drivers/staging/brcm80211/brcmfmac/sbsdpcmdev.h
index cc64b2f..3799d50 100644
--- a/drivers/staging/brcm80211/brcmfmac/sbsdpcmdev.h
+++ b/drivers/staging/brcm80211/brcmfmac/sbsdpcmdev.h
@@ -17,13 +17,6 @@
 #ifndef	_sbsdpcmdev_h_
 #define	_sbsdpcmdev_h_
 
-/* cpp contortions to concatenate w/arg prescan */
-#ifndef PAD
-#define	_PADLINE(line)	pad ## line
-#define	_XSTR(line)	_PADLINE(line)
-#define	PAD		_XSTR(__LINE__)
-#endif				/* PAD */
-
 /* core registers */
 typedef volatile struct {
 	u32 corecontrol;	/* CoreControl, 0x000, rev8 */
diff --git a/drivers/staging/brcm80211/brcmsmac/aiutils.c b/drivers/staging/brcm80211/brcmsmac/aiutils.c
index 2de6cfb..d57908b 100644
--- a/drivers/staging/brcm80211/brcmsmac/aiutils.c
+++ b/drivers/staging/brcm80211/brcmsmac/aiutils.c
@@ -1082,7 +1082,7 @@ void ai_detach(struct si_pub *sih)
 	uint idx;
 
 	struct si_pub *si_local = NULL;
-	bcopy(&sih, &si_local, sizeof(struct si_pub **));
+	memcpy(&si_local, &sih, sizeof(struct si_pub **));
 
 	sii = SI_INFO(sih);
 
diff --git a/drivers/staging/brcm80211/brcmsmac/aiutils.h b/drivers/staging/brcm80211/brcmsmac/aiutils.h
index 53d2e02..ec7acd1 100644
--- a/drivers/staging/brcm80211/brcmsmac/aiutils.h
+++ b/drivers/staging/brcm80211/brcmsmac/aiutils.h
@@ -17,13 +17,6 @@
 #ifndef	_aiutils_h_
 #define	_aiutils_h_
 
-/* cpp contortions to concatenate w/arg prescan */
-#ifndef PAD
-#define	_PADLINE(line)	pad ## line
-#define	_XSTR(line)	_PADLINE(line)
-#define	PAD		_XSTR(__LINE__)
-#endif
-
 /* Include the soci specific files */
 #include <aidmp.h>
 
diff --git a/drivers/staging/brcm80211/brcmsmac/bcmnvram.h b/drivers/staging/brcm80211/brcmsmac/bcmnvram.h
index 12645dd..bc62695 100644
--- a/drivers/staging/brcm80211/brcmsmac/bcmnvram.h
+++ b/drivers/staging/brcm80211/brcmsmac/bcmnvram.h
@@ -17,8 +17,6 @@
 #ifndef _bcmnvram_h_
 #define _bcmnvram_h_
 
-#ifndef _LANGUAGE_ASSEMBLY
-
 #include <bcmdefs.h>
 
 struct nvram_header {
@@ -128,8 +126,6 @@ extern int nvram_commit(void);
  */
 extern int nvram_getall(char *nvram_buf, int count);
 
-#endif				/* _LANGUAGE_ASSEMBLY */
-
 /* variable access */
 extern char *getvar(char *vars, const char *name);
 extern int getintvar(char *vars, const char *name);
diff --git a/drivers/staging/brcm80211/brcmsmac/d11.h b/drivers/staging/brcm80211/brcmsmac/d11.h
index d1babcd..12a0ead 100644
--- a/drivers/staging/brcm80211/brcmsmac/d11.h
+++ b/drivers/staging/brcm80211/brcmsmac/d11.h
@@ -19,13 +19,6 @@
 
 #include <linux/ieee80211.h>
 
-/* cpp contortions to concatenate w/arg prescan */
-#ifndef	PAD
-#define	_PADLINE(line)	pad ## line
-#define	_XSTR(line)	_PADLINE(line)
-#define	PAD		_XSTR(__LINE__)
-#endif
-
 #define	BCN_TMPL_LEN		512	/* length of the BCN template area */
 
 /* RX FIFO numbers */
diff --git a/drivers/staging/brcm80211/brcmsmac/nicpci.c b/drivers/staging/brcm80211/brcmsmac/nicpci.c
index 6b9cb6b..8a956f5 100644
--- a/drivers/staging/brcm80211/brcmsmac/nicpci.c
+++ b/drivers/staging/brcm80211/brcmsmac/nicpci.c
@@ -117,13 +117,6 @@
 /* PCIE protocol TLP diagnostic registers */
 #define PCIE_TLP_WORKAROUNDSREG		0x004	/* TLP Workarounds */
 
-/* cpp contortions to concatenate w/arg prescan */
-#ifndef PAD
-#define	_PADLINE(line)	pad ## line
-#define	_XSTR(line)	_PADLINE(line)
-#define	PAD		_XSTR(__LINE__)
-#endif
-
 /* Sonics side: PCI core and host control registers */
 struct sbpciregs {
 	u32 control;		/* PCI control */
diff --git a/drivers/staging/brcm80211/include/aidmp.h b/drivers/staging/brcm80211/include/aidmp.h
index 7e0ce8f..2c10177 100644
--- a/drivers/staging/brcm80211/include/aidmp.h
+++ b/drivers/staging/brcm80211/include/aidmp.h
@@ -17,6 +17,8 @@
 #ifndef	_AIDMP_H
 #define	_AIDMP_H
 
+#include "bcmdefs.h"		/* for PAD macro */
+
 /* Manufacturer Ids */
 #define	MFGID_ARM		0x43b
 #define	MFGID_BRCM		0x4bf
@@ -100,8 +102,6 @@
 #define	SD_SG32			0x00000008
 #define	SD_SZ_ALIGN		0x00000fff
 
-#ifndef _LANGUAGE_ASSEMBLY
-
 typedef volatile struct _aidmp {
 	u32 oobselina30;	/* 0x000 */
 	u32 oobselina74;	/* 0x004 */
@@ -220,8 +220,6 @@ typedef volatile struct _aidmp {
 	u32 componentid3;	/* 0xffc */
 } aidmp_t;
 
-#endif				/* _LANGUAGE_ASSEMBLY */
-
 /* Out-of-band Router registers */
 #define	OOB_BUSCONFIG		0x020
 #define	OOB_STATUSA		0x100
diff --git a/drivers/staging/brcm80211/include/bcmutils.h b/drivers/staging/brcm80211/include/bcmutils.h
index d7f531e..1a1c8ad 100644
--- a/drivers/staging/brcm80211/include/bcmutils.h
+++ b/drivers/staging/brcm80211/include/bcmutils.h
@@ -272,8 +272,6 @@ extern void bcm_prpkt(const char *msg, struct sk_buff *p0);
 #include <linux/kernel.h>	/* for vsn/printf's */
 #include <linux/string.h>	/* for mem*, str* */
 #endif
-/* bcopy's: Linux kernel doesn't provide these (anymore) */
-#define	bcopy(src, dst, len)	memcpy((dst), (src), (len))
 
 /* register access macros */
 #ifndef __BIG_ENDIAN
diff --git a/drivers/staging/brcm80211/include/chipcommon.h b/drivers/staging/brcm80211/include/chipcommon.h
index 9ca2e69..ee1130f 100644
--- a/drivers/staging/brcm80211/include/chipcommon.h
+++ b/drivers/staging/brcm80211/include/chipcommon.h
@@ -17,12 +17,7 @@
 #ifndef	_SBCHIPC_H
 #define	_SBCHIPC_H
 
-/* cpp contortions to concatenate w/arg prescan */
-#ifndef PAD
-#define	_PADLINE(line)	pad ## line
-#define	_XSTR(line)	_PADLINE(line)
-#define	PAD		_XSTR(__LINE__)
-#endif				/* PAD */
+#include "bcmdefs.h"		/* for PAD macro */
 
 typedef volatile struct {
 	u32 chipid;		/* 0x0 */
-- 
1.7.4.1


