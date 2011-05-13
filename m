Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mms1.broadcom.com ([216.31.210.17]:3385 "EHLO mms1.broadcom.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757972Ab1EMKAF (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 13 May 2011 06:00:05 -0400
From: "Arend van Spriel" <arend@broadcom.com>
To: gregkh@suse.de
cc: "Roland Vossen" <rvossen@broadcom.com>,
	devel@linuxdriverproject.org, linux-wireless@vger.kernel.org,
	"Arend van Spriel" <arend@broadcom.com>
Subject: [PATCH 04/32] staging: brcm80211: got rid of #ifdef __mips__
 sections in hnddma.c
Date: Fri, 13 May 2011 11:59:24 +0200
Message-ID: <1305280792-9475-4-git-send-email-arend@broadcom.com> (sfid-20110513_120121_247875_B77C528A)
In-Reply-To: <1305280792-9475-1-git-send-email-arend@broadcom.com>
References: <1305280792-9475-1-git-send-email-arend@broadcom.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Roland Vossen <rvossen@broadcom.com>

Code cleanup. Broadcom MIPS chips in big endian mode have a memory window
in which sdram contents is byte swapped. Code in hnddmac.c makes use of
this window. Reworked code so the #ifdef __mips__ is moved from .c to
.h file.

Cc: devel@linuxdriverproject.org
Cc: linux-wireless@vger.kernel.org
Reviewed-by: Henry Ptasinski <henryp@broadcom.com>
Reviewed-by: Brett Rudley <brudley@broadcom.com>
Signed-off-by: Arend van Spriel <arend@broadcom.com>
---
 drivers/staging/brcm80211/brcmsmac/aiutils.h |    2 --
 drivers/staging/brcm80211/brcmsmac/hnddma.c  |    7 -------
 drivers/staging/brcm80211/include/hndsoc.h   |    6 ++++++
 3 files changed, 6 insertions(+), 9 deletions(-)

diff --git a/drivers/staging/brcm80211/brcmsmac/aiutils.h b/drivers/staging/brcm80211/brcmsmac/aiutils.h
index b98099e..1168b53 100644
--- a/drivers/staging/brcm80211/brcmsmac/aiutils.h
+++ b/drivers/staging/brcm80211/brcmsmac/aiutils.h
@@ -38,8 +38,6 @@
 #define SI_PCI_MEM_SZ		(64 * 1024 * 1024)
 /* Host Mode sb2pcitranslation1 (64 MB) */
 #define SI_PCI_CFG		0x0c000000
-/* Byteswapped Physical SDRAM */
-#define	SI_SDRAM_SWAPPED	0x10000000
 /* Region 2 for sdram (512 MB) */
 #define SI_SDRAM_R2		0x80000000
 
diff --git a/drivers/staging/brcm80211/brcmsmac/hnddma.c b/drivers/staging/brcm80211/brcmsmac/hnddma.c
index 962010f..33432e6 100644
--- a/drivers/staging/brcm80211/brcmsmac/hnddma.c
+++ b/drivers/staging/brcm80211/brcmsmac/hnddma.c
@@ -352,9 +352,7 @@ struct hnddma_pub *dma_attach(char *name, si_t *sih,
 		di->dataoffsetlow = di->ddoffsetlow;
 		di->dataoffsethigh = di->ddoffsethigh;
 	}
-#if defined(__mips__) && defined(IL_BIGENDIAN)
 	di->dataoffsetlow = di->dataoffsetlow + SI_SDRAM_SWAPPED;
-#endif				/* defined(__mips__) && defined(IL_BIGENDIAN) */
 	/* WAR64450 : DMACtl.Addr ext fields are not supported in SDIOD core. */
 	if ((ai_coreid(sih) == SDIOD_CORE_ID)
 	    && ((ai_corerev(sih) > 0) && (ai_corerev(sih) <= 2)))
@@ -469,13 +467,8 @@ dma64_dd_upd(dma_info_t *di, dma64dd_t *ddring, dmaaddr_t pa, uint outidx,
 	u32 ctrl2 = bufcount & D64_CTRL2_BC_MASK;
 
 	/* PCI bus with big(>1G) physical address, use address extension */
-#if defined(__mips__) && defined(IL_BIGENDIAN)
 	if ((di->dataoffsetlow == SI_SDRAM_SWAPPED)
 	    || !(PHYSADDRLO(pa) & PCI32ADDR_HIGH)) {
-#else
-	if ((di->dataoffsetlow == 0) || !(PHYSADDRLO(pa) & PCI32ADDR_HIGH)) {
-#endif				/* defined(__mips__) && defined(IL_BIGENDIAN) */
-
 		W_SM(&ddring[outidx].addrlow,
 		     BUS_SWAP32(PHYSADDRLO(pa) + di->dataoffsetlow));
 		W_SM(&ddring[outidx].addrhigh,
diff --git a/drivers/staging/brcm80211/include/hndsoc.h b/drivers/staging/brcm80211/include/hndsoc.h
index 6435686..4754934 100644
--- a/drivers/staging/brcm80211/include/hndsoc.h
+++ b/drivers/staging/brcm80211/include/hndsoc.h
@@ -29,7 +29,13 @@
 #define SI_PCI_MEM		0x08000000	/* Host Mode sb2pcitranslation0 (64 MB) */
 #define SI_PCI_MEM_SZ		(64 * 1024 * 1024)
 #define SI_PCI_CFG		0x0c000000	/* Host Mode sb2pcitranslation1 (64 MB) */
+
+#if defined(__mips__) && defined(__BIG_ENDIAN)
 #define	SI_SDRAM_SWAPPED	0x10000000	/* Byteswapped Physical SDRAM */
+#else
+#define	SI_SDRAM_SWAPPED	0x0		/* Already byte swapped */
+#endif
+
 #define SI_SDRAM_R2		0x80000000	/* Region 2 for sdram (512 MB) */
 
 #ifdef SI_ENUM_BASE_VARIABLE
-- 
1.7.4.1


