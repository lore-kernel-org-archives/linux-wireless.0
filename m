Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mms2.broadcom.com ([216.31.210.18]:2705 "EHLO mms2.broadcom.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753458Ab1HONem (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 15 Aug 2011 09:34:42 -0400
From: "Arend van Spriel" <arend@broadcom.com>
To: gregkh@suse.de
cc: devel@linuxdriverproject.org, linux-wireless@vger.kernel.org,
	"Roland Vossen" <rvossen@broadcom.com>,
	"Arend van Spriel" <arend@broadcom.com>
Subject: [PATCH 15/15] staging: brcm80211: removed unused MIPS specific
 SDRAM swap window
Date: Mon, 15 Aug 2011 15:34:27 +0200
Message-ID: <1313415267-5264-16-git-send-email-arend@broadcom.com> (sfid-20110815_154257_256891_6699BF1E)
In-Reply-To: <1313415267-5264-1-git-send-email-arend@broadcom.com>
References: <1313415267-5264-1-git-send-email-arend@broadcom.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Roland Vossen <rvossen@broadcom.com>

Certain Mips based, big endian Broadcom products contain a memory window
for endianness swap purposes. However, this is too system specific for
this driver as there are more big endian platforms to support. Thus, this
'window' functionality is not to be used and can be removed.

The swap window would be a performance improvement and could be provided
with a dedicated mapping function in the platform specific code.

Tested on BCM63281.

Reviewed-by: Henry Ptasinski <henryp@broadcom.com>
Reviewed-by: Arend van Spriel <arend@broadcom.com>
Tested-by: Jonas Gorski <jonas.gorski@gmail.com>
Signed-off-by: Arend van Spriel <arend@broadcom.com>
---
 drivers/staging/brcm80211/brcmsmac/aiutils.h |    2 --
 drivers/staging/brcm80211/brcmsmac/dma.c     |    8 --------
 2 files changed, 0 insertions(+), 10 deletions(-)

diff --git a/drivers/staging/brcm80211/brcmsmac/aiutils.h b/drivers/staging/brcm80211/brcmsmac/aiutils.h
index 7ea42af..375c06f 100644
--- a/drivers/staging/brcm80211/brcmsmac/aiutils.h
+++ b/drivers/staging/brcm80211/brcmsmac/aiutils.h
@@ -30,8 +30,6 @@
 #define SI_PCI_MEM_SZ		(64 * 1024 * 1024)
 /* Host Mode sb2pcitranslation1 (64 MB) */
 #define SI_PCI_CFG		0x0c000000
-/* Byteswapped Physical SDRAM */
-#define	SI_SDRAM_SWAPPED	0x10000000
 /* Region 2 for sdram (512 MB) */
 #define SI_SDRAM_R2		0x80000000
 
diff --git a/drivers/staging/brcm80211/brcmsmac/dma.c b/drivers/staging/brcm80211/brcmsmac/dma.c
index bda36c7..2ef416a 100644
--- a/drivers/staging/brcm80211/brcmsmac/dma.c
+++ b/drivers/staging/brcm80211/brcmsmac/dma.c
@@ -442,9 +442,6 @@ struct dma_pub *dma_attach(char *name, struct si_pub *sih,
 	di->ddoffsethigh = SI_PCIE_DMA_H32;
 	di->dataoffsetlow = di->ddoffsetlow;
 	di->dataoffsethigh = di->ddoffsethigh;
-#if defined(__mips__) && defined(IL_BIGENDIAN)
-	di->dataoffsetlow = di->dataoffsetlow + SI_SDRAM_SWAPPED;
-#endif				/* defined(__mips__) && defined(IL_BIGENDIAN) */
 	/* WAR64450 : DMACtl.Addr ext fields are not supported in SDIOD core. */
 	if ((ai_coreid(sih) == SDIOD_CORE_ID)
 	    && ((ai_corerev(sih) > 0) && (ai_corerev(sih) <= 2)))
@@ -570,12 +567,7 @@ dma64_dd_upd(struct dma_info *di, struct dma64desc *ddring,
 	u32 ctrl2 = bufcount & D64_CTRL2_BC_MASK;
 
 	/* PCI bus with big(>1G) physical address, use address extension */
-#if defined(__mips__) && defined(IL_BIGENDIAN)
-	if ((di->dataoffsetlow == SI_SDRAM_SWAPPED)
-	    || !(pa & PCI32ADDR_HIGH)) {
-#else
 	if ((di->dataoffsetlow == 0) || !(pa & PCI32ADDR_HIGH)) {
-#endif				/* defined(__mips__) && defined(IL_BIGENDIAN) */
 		ddring[outidx].addrlow = cpu_to_le32(pa + di->dataoffsetlow);
 		ddring[outidx].addrhigh = cpu_to_le32(di->dataoffsethigh);
 		ddring[outidx].ctrl1 = cpu_to_le32(*flags);
-- 
1.7.4.1


