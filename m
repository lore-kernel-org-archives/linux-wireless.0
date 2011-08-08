Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mms3.broadcom.com ([216.31.210.19]:3142 "EHLO MMS3.broadcom.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752622Ab1HHN7Z (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 8 Aug 2011 09:59:25 -0400
From: "Arend van Spriel" <arend@broadcom.com>
To: gregkh@suse.de
cc: devel@linuxdriverproject.org, linux-wireless@vger.kernel.org,
	"Arend van Spriel" <arend@broadcom.com>
Subject: [PATCHv2 21/82] staging: brcm80211: remove volatile keyword
 from driver sources
Date: Mon, 8 Aug 2011 15:58:05 +0200
Message-ID: <1312811946-16713-22-git-send-email-arend@broadcom.com> (sfid-20110808_155934_991046_686A69AA)
In-Reply-To: <1312811946-16713-1-git-send-email-arend@broadcom.com>
References: <1312811946-16713-1-git-send-email-arend@broadcom.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

As checkpatch.pl rightfully indicated the volatile keyword was used
but not necessary. It has been removed from the code.

Signed-off-by: Arend van Spriel <arend@broadcom.com>
Reviewed-by: Roland Vossen <rvossen@broadcom.com>
---
 drivers/staging/brcm80211/brcmsmac/main.c        |   12 ++++++------
 drivers/staging/brcm80211/brcmsmac/phy/phy_cmn.c |    2 +-
 2 files changed, 7 insertions(+), 7 deletions(-)

diff --git a/drivers/staging/brcm80211/brcmsmac/main.c b/drivers/staging/brcm80211/brcmsmac/main.c
index d5f570a..a493795 100644
--- a/drivers/staging/brcm80211/brcmsmac/main.c
+++ b/drivers/staging/brcm80211/brcmsmac/main.c
@@ -2017,11 +2017,11 @@ static void brcms_c_write_inits(struct brcms_hardware *wlc_hw,
 			    const struct d11init *inits)
 {
 	int i;
-	volatile u8 *base;
+	u8 *base;
 
 	BCMMSG(wlc_hw->wlc->wiphy, "wl%d\n", wlc_hw->unit);
 
-	base = (volatile u8 *)wlc_hw->regs;
+	base = (u8 *)wlc_hw->regs;
 
 	for (i = 0; inits[i].addr != 0xffff; i++) {
 		if (inits[i].size == 2)
@@ -2822,8 +2822,8 @@ static u16
 brcms_b_read_objmem(struct brcms_hardware *wlc_hw, uint offset, u32 sel)
 {
 	struct d11regs *regs = wlc_hw->regs;
-	volatile u16 *objdata_lo = (volatile u16 *)&regs->objdata;
-	volatile u16 *objdata_hi = objdata_lo + 1;
+	u16 *objdata_lo = (u16 *)&regs->objdata;
+	u16 *objdata_hi = objdata_lo + 1;
 	u16 v;
 
 	W_REG(&regs->objaddr, sel | (offset >> 2));
@@ -2842,8 +2842,8 @@ brcms_b_write_objmem(struct brcms_hardware *wlc_hw, uint offset, u16 v,
 		     u32 sel)
 {
 	struct d11regs *regs = wlc_hw->regs;
-	volatile u16 *objdata_lo = (volatile u16 *)&regs->objdata;
-	volatile u16 *objdata_hi = objdata_lo + 1;
+	u16 *objdata_lo = (u16 *)&regs->objdata;
+	u16 *objdata_hi = objdata_lo + 1;
 
 	W_REG(&regs->objaddr, sel | (offset >> 2));
 	(void)R_REG(&regs->objaddr);
diff --git a/drivers/staging/brcm80211/brcmsmac/phy/phy_cmn.c b/drivers/staging/brcm80211/brcmsmac/phy/phy_cmn.c
index 940f76b..c6c5287 100644
--- a/drivers/staging/brcm80211/brcmsmac/phy/phy_cmn.c
+++ b/drivers/staging/brcm80211/brcmsmac/phy/phy_cmn.c
@@ -205,7 +205,7 @@ void wlc_radioreg_enter(struct brcms_phy_pub *pih)
 void wlc_radioreg_exit(struct brcms_phy_pub *pih)
 {
 	struct brcms_phy *pi = (struct brcms_phy *) pih;
-	volatile u16 dummy;
+	u16 dummy;
 
 	dummy = R_REG(&pi->regs->phyversion);
 	pi->phy_wreg = 0;
-- 
1.7.4.1


