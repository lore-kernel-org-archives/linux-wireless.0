Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mms3.broadcom.com ([216.31.210.19]:2915 "EHLO MMS3.broadcom.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758047Ab1EMKAQ (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 13 May 2011 06:00:16 -0400
From: "Arend van Spriel" <arend@broadcom.com>
To: gregkh@suse.de
cc: "Roland Vossen" <rvossen@broadcom.com>,
	devel@linuxdriverproject.org, linux-wireless@vger.kernel.org,
	"Arend van Spriel" <arend@broadcom.com>
Subject: [PATCH 03/32] staging: brcm80211: replaced #ifdef __mips__
 sections by W_REG_FLUSH
Date: Fri, 13 May 2011 11:59:23 +0200
Message-ID: <1305280792-9475-3-git-send-email-arend@broadcom.com> (sfid-20110513_120049_119888_3DA2B63B)
In-Reply-To: <1305280792-9475-1-git-send-email-arend@broadcom.com>
References: <1305280792-9475-1-git-send-email-arend@broadcom.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Roland Vossen <rvossen@broadcom.com>

Code cleanup. A read-after-write construct is present in the code to ensure
write order for certain Broadcom chips. Those chips are: bcm4706, bcm4716,
bcm4717, bcm4718. All these chips contain a MIPS processor. This patch gets
rid of several #ifdef __mips__ sections by defining a new macro in a header
file.

Cc: devel@linuxdriverproject.org
Cc: linux-wireless@vger.kernel.org
Reviewed-by: Henry Ptasinski <henryp@broadcom.com>
Reviewed-by: Brett Rudley <brudley@broadcom.com>
Signed-off-by: Arend van Spriel <arend@broadcom.com>
---
 .../staging/brcm80211/brcmsmac/phy/wlc_phy_cmn.c   |   63 ++++----------------
 drivers/staging/brcm80211/include/bcmutils.h       |    2 +-
 2 files changed, 14 insertions(+), 51 deletions(-)

diff --git a/drivers/staging/brcm80211/brcmsmac/phy/wlc_phy_cmn.c b/drivers/staging/brcm80211/brcmsmac/phy/wlc_phy_cmn.c
index b3c5f07..3fe483f 100644
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
 
 #ifdef CONFIG_BRCM_FIX_IO_ORDER
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
index a4a2a8d..cd58ca6 100644
--- a/drivers/staging/brcm80211/include/bcmutils.h
+++ b/drivers/staging/brcm80211/include/bcmutils.h
@@ -373,7 +373,7 @@ extern void bcm_prpkt(const char *msg, struct sk_buff *p0);
  * transactions. As a fix, a read after write is performed on certain places
  * in the code. Older chips and the newer 5357 family don't require this fix.
  */
-#define W_REG_FLUSH(r, v)	{ W_REG((r), (v)); (void)R_REG(r); }
+#define W_REG_FLUSH(r, v)	({ W_REG((r), (v)); (void)R_REG(r); })
 #else
 #define W_REG_FLUSH(r, v)	W_REG((r), (v))
 #endif				/* CONFIG_BRCM_FIX_IO_ORDER */
-- 
1.7.4.1


