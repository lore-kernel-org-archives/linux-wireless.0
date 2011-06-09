Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mms1.broadcom.com ([216.31.210.17]:2490 "EHLO mms1.broadcom.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752409Ab1FIOpR (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 9 Jun 2011 10:45:17 -0400
From: "Roland Vossen" <rvossen@broadcom.com>
To: gregkh@suse.de
cc: devel@linuxdriverproject.org, linux-wireless@vger.kernel.org
Subject: [PATCH 12/21] staging: brcm80211: use __BIG_ENDIAN macro in
 dma.c
Date: Thu, 9 Jun 2011 16:44:52 +0200
Message-ID: <1307630701-9170-13-git-send-email-rvossen@broadcom.com> (sfid-20110609_164546_212360_DE1D76DE)
In-Reply-To: <1307630701-9170-1-git-send-email-rvossen@broadcom.com>
References: <1307630701-9170-1-git-send-email-rvossen@broadcom.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Arend van Spriel <arend@broadcom.com>

The source file dma.c used a macro definition that indicated a big endian
platform. The linux tree has its own macro determined by architecture and/or
kernel configuration. This byteorder macro is __BIG_ENDIAN. This is now used
in dma.c.

Signed-off-by: Arend van Spriel <arend@broadcom.com>
Reviewed-by: Roland Vossen <rvossen@broadcom.com>
Reviewed-by: Franky Lin <frankyl@broadcom.com>
---
 drivers/staging/brcm80211/brcmsmac/dma.c |    8 ++++----
 1 files changed, 4 insertions(+), 4 deletions(-)

diff --git a/drivers/staging/brcm80211/brcmsmac/dma.c b/drivers/staging/brcm80211/brcmsmac/dma.c
index adf364c..9a9f0e7 100644
--- a/drivers/staging/brcm80211/brcmsmac/dma.c
+++ b/drivers/staging/brcm80211/brcmsmac/dma.c
@@ -507,9 +507,9 @@ struct dma_pub *dma_attach(char *name, struct si_pub *sih,
 		di->dataoffsetlow = di->ddoffsetlow;
 		di->dataoffsethigh = di->ddoffsethigh;
 	}
-#if defined(__mips__) && defined(IL_BIGENDIAN)
+#if defined(__mips__) && defined(__BIG_ENDIAN)
 	di->dataoffsetlow = di->dataoffsetlow + SI_SDRAM_SWAPPED;
-#endif				/* defined(__mips__) && defined(IL_BIGENDIAN) */
+#endif				/* defined(__mips__) && defined(__BIG_ENDIAN) */
 	/* WAR64450 : DMACtl.Addr ext fields are not supported in SDIOD core. */
 	if ((ai_coreid(sih) == SDIOD_CORE_ID)
 	    && ((ai_corerev(sih) > 0) && (ai_corerev(sih) <= 2)))
@@ -624,12 +624,12 @@ dma64_dd_upd(dma_info_t *di, dma64dd_t *ddring, dmaaddr_t pa, uint outidx,
 	u32 ctrl2 = bufcount & D64_CTRL2_BC_MASK;
 
 	/* PCI bus with big(>1G) physical address, use address extension */
-#if defined(__mips__) && defined(IL_BIGENDIAN)
+#if defined(__mips__) && defined(__BIG_ENDIAN)
 	if ((di->dataoffsetlow == SI_SDRAM_SWAPPED)
 	    || !(PHYSADDRLO(pa) & PCI32ADDR_HIGH)) {
 #else
 	if ((di->dataoffsetlow == 0) || !(PHYSADDRLO(pa) & PCI32ADDR_HIGH)) {
-#endif				/* defined(__mips__) && defined(IL_BIGENDIAN) */
+#endif				/* defined(__mips__) && defined(__BIG_ENDIAN) */
 
 		W_SM(&ddring[outidx].addrlow,
 		     BUS_SWAP32(PHYSADDRLO(pa) + di->dataoffsetlow));
-- 
1.7.4.1


