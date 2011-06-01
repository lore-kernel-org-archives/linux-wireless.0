Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mms3.broadcom.com ([216.31.210.19]:1143 "EHLO MMS3.broadcom.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758899Ab1FALqv (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 1 Jun 2011 07:46:51 -0400
From: "Roland Vossen" <rvossen@broadcom.com>
To: gregkh@suse.de
cc: devel@linuxdriverproject.org, linux-wireless@vger.kernel.org
Subject: [PATCH 08/83] staging: brcm80211: replaced #ifdef __mips__
 sections by W_REG_FLUSH
Date: Wed, 1 Jun 2011 13:44:53 +0200
Message-ID: <1306928768-7501-8-git-send-email-rvossen@broadcom.com> (sfid-20110601_134756_768294_8F95017F)
In-Reply-To: <1306928768-7501-1-git-send-email-rvossen@broadcom.com>
References: <1306928768-7501-1-git-send-email-rvossen@broadcom.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Code cleanup. A read-after-write construct is present in the code to ensure
write order for certain Broadcom chips. Those chips are: bcm4706, bcm4716,
bcm4717, bcm4718. All these chips contain a MIPS processor. This patch gets
rid of several #ifdef __mips__ sections by defining a new macro in a header
file. This patch does not introduce behavioral changes and is purely meant
for code cleanup. The __mips__ define will be made more specific in a future
patch.

Signed-off-by: Roland Vossen <rvossen@broadcom.com>
Reviewed-by: Arend van Spriel <arend@broadcom.com>
---
 .../staging/brcm80211/brcmsmac/phy/wlc_phy_cmn.c   |   63 ++++----------------
 drivers/staging/brcm80211/include/bcmutils.h       |   11 ++++
 2 files changed, 24 insertions(+), 50 deletions(-)

diff --git a/drivers/staging/brcm80211/brcmsmac/phy/wlc_phy_cmn.c b/drivers/staging/brcm80211/brcmsmac/phy/wlc_phy_cmn.c
index f45628a..07a5bcb 100644
--- a/drivers/staging/brcm80211/brcmsmac/phy/wlc_phy_cmn.c
+++ b/drivers/staging/brcm80211/brcmsmac/phy/wlc_phy_cmn.c
@@ -247,16 +247,10 @@ u16 read_radio_reg(phy_info_t *pi, u16 addr)
 	if ((D11REV_GE(pi->sh->corerev, 24)) ||
 	    (D11REV_IS(pi->sh->corerev, 22)
 	     && (pi->pubpi.phy_type != PHY_TYPE_SSN))) {
-		W_REG(&pi->regs->radioregaddr, addr);
-#ifdef __mips__
-		(void)R_REG(&pi->regs->radioregaddr);
-#endif
+		W_REG_FLUSH(&pi->regs->radioregaddr, addr);
 		data = R_REG(&pi->regs->radioregdata);
 	} else {
-		W_REG(&pi->regs->phy4waddr, addr);
-#ifdef __mips__
-		(void)R_REG(&pi->regs->phy4waddr);
-#endif
+		W_REG_FLUSH(&pi->regs->phy4waddr, addr);
 
 #ifdef __ARM_ARCH_4T__
 		__asm__(" .align 4 ");
@@ -281,16 +275,10 @@ void write_radio_reg(phy_info_t *pi, u16 addr, u16 val)
 	    (D11REV_IS(pi->sh->corerev, 22)
 	     && (pi->pubpi.phy_type != PHY_TYPE_SSN))) {
 
-		W_REG(&pi->regs->radioregaddr, addr);
-#ifdef __mips__
-		(void)R_REG(&pi->regs->radioregaddr);
-#endif
+		W_REG_FLUSH(&pi->regs->radioregaddr, addr);
 		W_REG(&pi->regs->radioregdata, val);
 	} else {
-		W_REG(&pi->regs->phy4waddr, addr);
-#ifdef __mips__
-		(void)R_REG(&pi->regs->phy4waddr);
-#endif
+		W_REG_FLUSH(&pi->regs->phy4waddr, addr);
 		W_REG(&pi->regs->phy4wdatalo, val);
 	}
 
@@ -312,29 +300,17 @@ static u32 read_radio_id(phy_info_t *pi)
 	if (D11REV_GE(pi->sh->corerev, 24)) {
 		u32 b0, b1, b2;
 
-		W_REG(&pi->regs->radioregaddr, 0);
-#ifdef __mips__
-		(void)R_REG(&pi->regs->radioregaddr);
-#endif
+		W_REG_FLUSH(&pi->regs->radioregaddr, 0);
 		b0 = (u32) R_REG(&pi->regs->radioregdata);
-		W_REG(&pi->regs->radioregaddr, 1);
-#ifdef __mips__
-		(void)R_REG(&pi->regs->radioregaddr);
-#endif
+		W_REG_FLUSH(&pi->regs->radioregaddr, 1);
 		b1 = (u32) R_REG(&pi->regs->radioregdata);
-		W_REG(&pi->regs->radioregaddr, 2);
-#ifdef __mips__
-		(void)R_REG(&pi->regs->radioregaddr);
-#endif
+		W_REG_FLUSH(&pi->regs->radioregaddr, 2);
 		b2 = (u32) R_REG(&pi->regs->radioregdata);
 
 		id = ((b0 & 0xf) << 28) | (((b2 << 8) | b1) << 12) | ((b0 >> 4)
 								      & 0xf);
 	} else {
-		W_REG(&pi->regs->phy4waddr, RADIO_IDCODE);
-#ifdef __mips__
-		(void)R_REG(&pi->regs->phy4waddr);
-#endif
+		W_REG_FLUSH(&pi->regs->phy4waddr, RADIO_IDCODE);
 		id = (u32) R_REG(&pi->regs->phy4wdatalo);
 		id |= (u32) R_REG(&pi->regs->phy4wdatahi) << 16;
 	}
@@ -397,10 +373,7 @@ u16 read_phy_reg(phy_info_t *pi, u16 addr)
 
 	regs = pi->regs;
 
-	W_REG(&regs->phyregaddr, addr);
-#ifdef __mips__
-	(void)R_REG(&regs->phyregaddr);
-#endif
+	W_REG_FLUSH(&regs->phyregaddr, addr);
 
 	pi->phy_wreg = 0;
 	return R_REG(&regs->phyregdata);
@@ -413,8 +386,7 @@ void write_phy_reg(phy_info_t *pi, u16 addr, u16 val)
 	regs = pi->regs;
 
 #ifdef __mips__
-	W_REG(&regs->phyregaddr, addr);
-	(void)R_REG(&regs->phyregaddr);
+	W_REG_FLUSH(&regs->phyregaddr, addr);
 	W_REG(&regs->phyregdata, val);
 	if (addr == 0x72)
 		(void)R_REG(&regs->phyregdata);
@@ -436,10 +408,7 @@ void and_phy_reg(phy_info_t *pi, u16 addr, u16 val)
 
 	regs = pi->regs;
 
-	W_REG(&regs->phyregaddr, addr);
-#ifdef __mips__
-	(void)R_REG(&regs->phyregaddr);
-#endif
+	W_REG_FLUSH(&regs->phyregaddr, addr);
 
 	W_REG(&regs->phyregdata, (R_REG(&regs->phyregdata) & val));
 	pi->phy_wreg = 0;
@@ -451,10 +420,7 @@ void or_phy_reg(phy_info_t *pi, u16 addr, u16 val)
 
 	regs = pi->regs;
 
-	W_REG(&regs->phyregaddr, addr);
-#ifdef __mips__
-	(void)R_REG(&regs->phyregaddr);
-#endif
+	W_REG_FLUSH(&regs->phyregaddr, addr);
 
 	W_REG(&regs->phyregdata, (R_REG(&regs->phyregdata) | val));
 	pi->phy_wreg = 0;
@@ -466,10 +432,7 @@ void mod_phy_reg(phy_info_t *pi, u16 addr, u16 mask, u16 val)
 
 	regs = pi->regs;
 
-	W_REG(&regs->phyregaddr, addr);
-#ifdef __mips__
-	(void)R_REG(&regs->phyregaddr);
-#endif
+	W_REG_FLUSH(&regs->phyregaddr, addr);
 
 	W_REG(&regs->phyregdata,
 	      ((R_REG(&regs->phyregdata) & ~mask) | (val & mask)));
diff --git a/drivers/staging/brcm80211/include/bcmutils.h b/drivers/staging/brcm80211/include/bcmutils.h
index 17683f2..d7f531e 100644
--- a/drivers/staging/brcm80211/include/bcmutils.h
+++ b/drivers/staging/brcm80211/include/bcmutils.h
@@ -366,6 +366,17 @@ extern void bcm_prpkt(const char *msg, struct sk_buff *p0);
 	} while (0)
 #endif				/* __BIG_ENDIAN */
 
+#ifdef __mips__
+/*
+ * bcm4716 (which includes 4717 & 4718), plus 4706 on PCIe can reorder
+ * transactions. As a fix, a read after write is performed on certain places
+ * in the code. Older chips and the newer 5357 family don't require this fix.
+ */
+#define W_REG_FLUSH(r, v)	({ W_REG((r), (v)); (void)R_REG(r); })
+#else
+#define W_REG_FLUSH(r, v)	W_REG((r), (v))
+#endif				/* __mips__ */
+
 #define AND_REG(r, v)	W_REG((r), R_REG(r) & (v))
 #define OR_REG(r, v)	W_REG((r), R_REG(r) | (v))
 
-- 
1.7.4.1


