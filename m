Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mms3.broadcom.com ([216.31.210.19]:4900 "EHLO MMS3.broadcom.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751044Ab1DSHN7 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 19 Apr 2011 03:13:59 -0400
From: "Roland Vossen" <rvossen@broadcom.com>
To: gregkh@suse.de
cc: devel@linuxdriverproject.org, linux-wireless@vger.kernel.org,
	linville@tuxdriver.com
Subject: [PATCH 1/2] staging: brcm80211: removed #ifdef __mips__
Date: Tue, 19 Apr 2011 09:13:44 +0200
Message-ID: <1303197225-4263-2-git-send-email-rvossen@broadcom.com>
In-Reply-To: <1303197225-4263-1-git-send-email-rvossen@broadcom.com>
References: <1303197225-4263-1-git-send-email-rvossen@broadcom.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Code cleanup. __mips__ was undefined for current builds.

Signed-off-by: Roland Vossen <rvossen@broadcom.com>
Reviewed-by: Arend van Spriel <arend@broadcom.com>
---
 .../staging/brcm80211/brcmsmac/phy/wlc_phy_cmn.c   |   48 --------------------
 drivers/staging/brcm80211/include/bcmdefs.h        |    4 --
 drivers/staging/brcm80211/include/bcmutils.h       |   31 -------------
 drivers/staging/brcm80211/util/bcmutils.c          |   28 -----------
 drivers/staging/brcm80211/util/hnddma.c            |   23 ---------
 5 files changed, 0 insertions(+), 134 deletions(-)

diff --git a/drivers/staging/brcm80211/brcmsmac/phy/wlc_phy_cmn.c b/drivers/staging/brcm80211/brcmsmac/phy/wlc_phy_cmn.c
index 40f0444..92133c7 100644
--- a/drivers/staging/brcm80211/brcmsmac/phy/wlc_phy_cmn.c
+++ b/drivers/staging/brcm80211/brcmsmac/phy/wlc_phy_cmn.c
@@ -246,15 +246,9 @@ u16 read_radio_reg(phy_info_t *pi, u16 addr)
 	    (D11REV_IS(pi->sh->corerev, 22)
 	     && (pi->pubpi.phy_type != PHY_TYPE_SSN))) {
 		W_REG(&pi->regs->radioregaddr, addr);
-#ifdef __mips__
-		(void)R_REG(&pi->regs->radioregaddr);
-#endif
 		data = R_REG(&pi->regs->radioregdata);
 	} else {
 		W_REG(&pi->regs->phy4waddr, addr);
-#ifdef __mips__
-		(void)R_REG(&pi->regs->phy4waddr);
-#endif
 
 #ifdef __ARM_ARCH_4T__
 		__asm__(" .align 4 ");
@@ -280,15 +274,9 @@ void write_radio_reg(phy_info_t *pi, u16 addr, u16 val)
 	     && (pi->pubpi.phy_type != PHY_TYPE_SSN))) {
 
 		W_REG(&pi->regs->radioregaddr, addr);
-#ifdef __mips__
-		(void)R_REG(&pi->regs->radioregaddr);
-#endif
 		W_REG(&pi->regs->radioregdata, val);
 	} else {
 		W_REG(&pi->regs->phy4waddr, addr);
-#ifdef __mips__
-		(void)R_REG(&pi->regs->phy4waddr);
-#endif
 		W_REG(&pi->regs->phy4wdatalo, val);
 	}
 
@@ -311,28 +299,16 @@ static u32 read_radio_id(phy_info_t *pi)
 		u32 b0, b1, b2;
 
 		W_REG(&pi->regs->radioregaddr, 0);
-#ifdef __mips__
-		(void)R_REG(&pi->regs->radioregaddr);
-#endif
 		b0 = (u32) R_REG(&pi->regs->radioregdata);
 		W_REG(&pi->regs->radioregaddr, 1);
-#ifdef __mips__
-		(void)R_REG(&pi->regs->radioregaddr);
-#endif
 		b1 = (u32) R_REG(&pi->regs->radioregdata);
 		W_REG(&pi->regs->radioregaddr, 2);
-#ifdef __mips__
-		(void)R_REG(&pi->regs->radioregaddr);
-#endif
 		b2 = (u32) R_REG(&pi->regs->radioregdata);
 
 		id = ((b0 & 0xf) << 28) | (((b2 << 8) | b1) << 12) | ((b0 >> 4)
 								      & 0xf);
 	} else {
 		W_REG(&pi->regs->phy4waddr, RADIO_IDCODE);
-#ifdef __mips__
-		(void)R_REG(&pi->regs->phy4waddr);
-#endif
 		id = (u32) R_REG(&pi->regs->phy4wdatalo);
 		id |= (u32) R_REG(&pi->regs->phy4wdatahi) << 16;
 	}
@@ -396,10 +372,6 @@ u16 read_phy_reg(phy_info_t *pi, u16 addr)
 	regs = pi->regs;
 
 	W_REG(&regs->phyregaddr, addr);
-#ifdef __mips__
-	(void)R_REG(&regs->phyregaddr);
-#endif
-
 	pi->phy_wreg = 0;
 	return R_REG(&regs->phyregdata);
 }
@@ -410,13 +382,6 @@ void write_phy_reg(phy_info_t *pi, u16 addr, u16 val)
 
 	regs = pi->regs;
 
-#ifdef __mips__
-	W_REG(&regs->phyregaddr, addr);
-	(void)R_REG(&regs->phyregaddr);
-	W_REG(&regs->phyregdata, val);
-	if (addr == 0x72)
-		(void)R_REG(&regs->phyregdata);
-#else
 	W_REG((u32 *)(&regs->phyregaddr),
 	      addr | (val << 16));
 	if (pi->sh->bustype == PCI_BUS) {
@@ -425,7 +390,6 @@ void write_phy_reg(phy_info_t *pi, u16 addr, u16 val)
 			(void)R_REG(&regs->phyversion);
 		}
 	}
-#endif
 }
 
 void and_phy_reg(phy_info_t *pi, u16 addr, u16 val)
@@ -435,10 +399,6 @@ void and_phy_reg(phy_info_t *pi, u16 addr, u16 val)
 	regs = pi->regs;
 
 	W_REG(&regs->phyregaddr, addr);
-#ifdef __mips__
-	(void)R_REG(&regs->phyregaddr);
-#endif
-
 	W_REG(&regs->phyregdata, (R_REG(&regs->phyregdata) & val));
 	pi->phy_wreg = 0;
 }
@@ -450,10 +410,6 @@ void or_phy_reg(phy_info_t *pi, u16 addr, u16 val)
 	regs = pi->regs;
 
 	W_REG(&regs->phyregaddr, addr);
-#ifdef __mips__
-	(void)R_REG(&regs->phyregaddr);
-#endif
-
 	W_REG(&regs->phyregdata, (R_REG(&regs->phyregdata) | val));
 	pi->phy_wreg = 0;
 }
@@ -465,10 +421,6 @@ void mod_phy_reg(phy_info_t *pi, u16 addr, u16 mask, u16 val)
 	regs = pi->regs;
 
 	W_REG(&regs->phyregaddr, addr);
-#ifdef __mips__
-	(void)R_REG(&regs->phyregaddr);
-#endif
-
 	W_REG(&regs->phyregdata,
 	      ((R_REG(&regs->phyregdata) & ~mask) | (val & mask)));
 	pi->phy_wreg = 0;
diff --git a/drivers/staging/brcm80211/include/bcmdefs.h b/drivers/staging/brcm80211/include/bcmdefs.h
index 22a389e..5d1a620 100644
--- a/drivers/staging/brcm80211/include/bcmdefs.h
+++ b/drivers/staging/brcm80211/include/bcmdefs.h
@@ -36,11 +36,7 @@
 
 #define	AUTO	(-1)		/* Auto = -1 */
 
-#ifdef mips
-#define BCMFASTPATH		__attribute__ ((__section__(".text.fastpath")))
-#else
 #define BCMFASTPATH
-#endif
 
 /* Bus types */
 #define	SI_BUS			0	/* SOC Interconnect */
diff --git a/drivers/staging/brcm80211/include/bcmutils.h b/drivers/staging/brcm80211/include/bcmutils.h
index f2e81e5..3a6d500 100644
--- a/drivers/staging/brcm80211/include/bcmutils.h
+++ b/drivers/staging/brcm80211/include/bcmutils.h
@@ -299,43 +299,12 @@ extern void osl_assert(char *exp, char *file, int line);
 
 /* register access macros */
 #ifndef IL_BIGENDIAN
-#ifndef __mips__
 #define R_REG(r) (\
 	SELECT_BUS_READ(sizeof(*(r)) == sizeof(u8) ? \
 	readb((volatile u8*)(r)) : \
 	sizeof(*(r)) == sizeof(u16) ? readw((volatile u16*)(r)) : \
 	readl((volatile u32*)(r)), OSL_READ_REG(r)) \
 )
-#else				/* __mips__ */
-#define R_REG(r) (\
-	SELECT_BUS_READ( \
-		({ \
-			__typeof(*(r)) __osl_v; \
-			__asm__ __volatile__("sync"); \
-			switch (sizeof(*(r))) { \
-			case sizeof(u8): \
-				__osl_v = readb((volatile u8*)(r)); \
-				break; \
-			case sizeof(u16): \
-				__osl_v = readw((volatile u16*)(r)); \
-				break; \
-			case sizeof(u32): \
-				__osl_v = \
-				readl((volatile u32*)(r)); \
-				break; \
-			} \
-			__asm__ __volatile__("sync"); \
-			__osl_v; \
-		}), \
-		({ \
-			__typeof(*(r)) __osl_v; \
-			__asm__ __volatile__("sync"); \
-			__osl_v = OSL_READ_REG(r); \
-			__asm__ __volatile__("sync"); \
-			__osl_v; \
-		})) \
-)
-#endif				/* __mips__ */
 
 #define W_REG(r, v) do { \
 	SELECT_BUS_WRITE( \
diff --git a/drivers/staging/brcm80211/util/bcmutils.c b/drivers/staging/brcm80211/util/bcmutils.c
index fcb091e..df1b6fe 100644
--- a/drivers/staging/brcm80211/util/bcmutils.c
+++ b/drivers/staging/brcm80211/util/bcmutils.c
@@ -724,37 +724,9 @@ u32 hndcrc32(u8 *pdata,	/* pointer to array of data to process */
 )
 {
 	u8 *pend;
-#ifdef __mips__
-	u8 tmp[4];
-	unsigned long *tptr = (unsigned long *) tmp;
-
-	/* in case the beginning of the buffer isn't aligned */
-	pend = (u8 *) ((uint) (pdata + 3) & 0xfffffffc);
-	nbytes -= (pend - pdata);
-	while (pdata < pend)
-		CRC_INNER_LOOP(32, crc, *pdata++);
-
-	/* handle bulk of data as 32-bit words */
-	pend = pdata + (nbytes & 0xfffffffc);
-	while (pdata < pend) {
-		*tptr = *(unsigned long *) pdata;
-		pdata += sizeof(unsigned long *);
-		CRC_INNER_LOOP(32, crc, tmp[0]);
-		CRC_INNER_LOOP(32, crc, tmp[1]);
-		CRC_INNER_LOOP(32, crc, tmp[2]);
-		CRC_INNER_LOOP(32, crc, tmp[3]);
-	}
-
-	/* 1-3 bytes at end of buffer */
-	pend = pdata + (nbytes & 0x03);
-	while (pdata < pend)
-		CRC_INNER_LOOP(32, crc, *pdata++);
-#else
 	pend = pdata + nbytes;
 	while (pdata < pend)
 		CRC_INNER_LOOP(32, crc, *pdata++);
-#endif				/* __mips__ */
-
 	return crc;
 }
 /*
diff --git a/drivers/staging/brcm80211/util/hnddma.c b/drivers/staging/brcm80211/util/hnddma.c
index 26eeb1f..134caf2 100644
--- a/drivers/staging/brcm80211/util/hnddma.c
+++ b/drivers/staging/brcm80211/util/hnddma.c
@@ -27,10 +27,6 @@
 #include <sbhnddma.h>
 #include <hnddma.h>
 
-#if defined(__mips__)
-#include <asm/addrspace.h>
-#endif
-
 #ifdef BRCM_FULLMAC
 #error "hnddma.c shouldn't be needed for FULLMAC"
 #endif
@@ -350,9 +346,6 @@ struct hnddma_pub *dma_attach(char *name, si_t *sih,
 		di->dataoffsetlow = di->ddoffsetlow;
 		di->dataoffsethigh = di->ddoffsethigh;
 	}
-#if defined(__mips__) && defined(IL_BIGENDIAN)
-	di->dataoffsetlow = di->dataoffsetlow + SI_SDRAM_SWAPPED;
-#endif				/* defined(__mips__) && defined(IL_BIGENDIAN) */
 	/* WAR64450 : DMACtl.Addr ext fields are not supported in SDIOD core. */
 	if ((ai_coreid(sih) == SDIOD_CORE_ID)
 	    && ((ai_corerev(sih) > 0) && (ai_corerev(sih) <= 2)))
@@ -467,12 +460,7 @@ dma64_dd_upd(dma_info_t *di, dma64dd_t *ddring, dmaaddr_t pa, uint outidx,
 	u32 ctrl2 = bufcount & D64_CTRL2_BC_MASK;
 
 	/* PCI bus with big(>1G) physical address, use address extension */
-#if defined(__mips__) && defined(IL_BIGENDIAN)
-	if ((di->dataoffsetlow == SI_SDRAM_SWAPPED)
-	    || !(PHYSADDRLO(pa) & PCI32ADDR_HIGH)) {
-#else
 	if ((di->dataoffsetlow == 0) || !(PHYSADDRLO(pa) & PCI32ADDR_HIGH)) {
-#endif				/* defined(__mips__) && defined(IL_BIGENDIAN) */
 		W_SM(&ddring[outidx].addrlow,
 		     BUS_SWAP32(PHYSADDRLO(pa) + di->dataoffsetlow));
 		W_SM(&ddring[outidx].addrhigh,
@@ -726,17 +714,6 @@ static void *BCMFASTPATH _dma_rx(dma_info_t *di)
 
 	len = le16_to_cpu(*(u16 *) (head->data));
 	DMA_TRACE(("%s: dma_rx len %d\n", di->name, len));
-
-#if defined(__mips__)
-#define OSL_UNCACHED(va)        ((void *)KSEG1ADDR((va)))
-	if (!len) {
-		while (!(len = *(u16 *) OSL_UNCACHED(head->data)))
-			udelay(1);
-
-		*(u16 *) (head->data) = cpu_to_le16((u16) len);
-	}
-#endif				/* defined(__mips__) */
-
 	/* set actual length */
 	pkt_len = min((di->rxoffset + len), di->rxbufsize);
 	__skb_trim(head, pkt_len);
-- 
1.7.1


