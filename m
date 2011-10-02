Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mms2.broadcom.com ([216.31.210.18]:1705 "EHLO mms2.broadcom.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753657Ab1JBRPA (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Sun, 2 Oct 2011 13:15:00 -0400
From: "Franky Lin" <frankyl@broadcom.com>
To: gregkh@suse.de
cc: devel@linuxdriverproject.org, linux-wireless@vger.kernel.org
Subject: [PATCH 08/20] staging: brcm80211: added __iomem qualifier to
 softmac phy
Date: Sun, 2 Oct 2011 10:14:33 -0700
Message-ID: <1317575685-3156-9-git-send-email-frankyl@broadcom.com> (sfid-20111002_191521_922039_9D9B4D40)
In-Reply-To: <1317575685-3156-1-git-send-email-frankyl@broadcom.com>
References: <1317575685-3156-1-git-send-email-frankyl@broadcom.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Roland Vossen <rvossen@broadcom.com>

Code cleanup. Makes it clear when an address is mapped IO space.

Reviewed-by: Pieter-Paul Giesberts <pieterpg@broadcom.com>
Reviewed-by: Arend van Spriel <arend@broadcom.com>
Signed-off-by: Franky Lin <frankyl@broadcom.com>
---
 drivers/staging/brcm80211/brcmsmac/phy/phy_cmn.c |   19 +++++++++----------
 drivers/staging/brcm80211/brcmsmac/phy/phy_hal.h |    2 +-
 drivers/staging/brcm80211/brcmsmac/phy/phy_int.h |    2 +-
 drivers/staging/brcm80211/brcmsmac/phy/phy_n.c   |    9 +++++----
 4 files changed, 16 insertions(+), 16 deletions(-)

diff --git a/drivers/staging/brcm80211/brcmsmac/phy/phy_cmn.c b/drivers/staging/brcm80211/brcmsmac/phy/phy_cmn.c
index 5b81480..45e3b4b 100644
--- a/drivers/staging/brcm80211/brcmsmac/phy/phy_cmn.c
+++ b/drivers/staging/brcm80211/brcmsmac/phy/phy_cmn.c
@@ -323,7 +323,7 @@ void write_phy_channel_reg(struct brcms_phy *pi, uint val)
 
 u16 read_phy_reg(struct brcms_phy *pi, u16 addr)
 {
-	struct d11regs *regs;
+	struct d11regs __iomem *regs;
 
 	regs = pi->regs;
 
@@ -335,7 +335,7 @@ u16 read_phy_reg(struct brcms_phy *pi, u16 addr)
 
 void write_phy_reg(struct brcms_phy *pi, u16 addr, u16 val)
 {
-	struct d11regs *regs;
+	struct d11regs __iomem *regs;
 
 	regs = pi->regs;
 
@@ -345,8 +345,7 @@ void write_phy_reg(struct brcms_phy *pi, u16 addr, u16 val)
 	if (addr == 0x72)
 		(void)R_REG(&regs->phyregdata);
 #else
-	W_REG((u32 *)(&regs->phyregaddr),
-	      addr | (val << 16));
+	W_REG((u32 __iomem *)(&regs->phyregaddr), addr | (val << 16));
 	if (++pi->phy_wreg >= pi->phy_wreg_limit) {
 		pi->phy_wreg = 0;
 		(void)R_REG(&regs->phyversion);
@@ -356,7 +355,7 @@ void write_phy_reg(struct brcms_phy *pi, u16 addr, u16 val)
 
 void and_phy_reg(struct brcms_phy *pi, u16 addr, u16 val)
 {
-	struct d11regs *regs;
+	struct d11regs __iomem *regs;
 
 	regs = pi->regs;
 
@@ -368,7 +367,7 @@ void and_phy_reg(struct brcms_phy *pi, u16 addr, u16 val)
 
 void or_phy_reg(struct brcms_phy *pi, u16 addr, u16 val)
 {
-	struct d11regs *regs;
+	struct d11regs __iomem *regs;
 
 	regs = pi->regs;
 
@@ -380,7 +379,7 @@ void or_phy_reg(struct brcms_phy *pi, u16 addr, u16 val)
 
 void mod_phy_reg(struct brcms_phy *pi, u16 addr, u16 mask, u16 val)
 {
-	struct d11regs *regs;
+	struct d11regs __iomem *regs;
 
 	regs = pi->regs;
 
@@ -494,8 +493,8 @@ static u32 wlc_phy_get_radio_ver(struct brcms_phy *pi)
 }
 
 struct brcms_phy_pub *
-wlc_phy_attach(struct shared_phy *sh, struct d11regs *regs, int bandtype,
-	       char *vars, struct wiphy *wiphy)
+wlc_phy_attach(struct shared_phy *sh, struct d11regs __iomem *regs,
+	       int bandtype, char *vars, struct wiphy *wiphy)
 {
 	struct brcms_phy *pi;
 	u32 sflags = 0;
@@ -1065,7 +1064,7 @@ wlc_phy_init_radio_regs(struct brcms_phy *pi,
 void wlc_phy_do_dummy_tx(struct brcms_phy *pi, bool ofdm, bool pa_on)
 {
 #define DUMMY_PKT_LEN   20
-	struct d11regs *regs = pi->regs;
+	struct d11regs __iomem *regs = pi->regs;
 	int i, count;
 	u8 ofdmpkt[DUMMY_PKT_LEN] = {
 		0xcc, 0x01, 0x02, 0x00, 0x00, 0x00, 0xd4, 0x00, 0x00, 0x00,
diff --git a/drivers/staging/brcm80211/brcmsmac/phy/phy_hal.h b/drivers/staging/brcm80211/brcmsmac/phy/phy_hal.h
index 39c3c22..44818af 100644
--- a/drivers/staging/brcm80211/brcmsmac/phy/phy_hal.h
+++ b/drivers/staging/brcm80211/brcmsmac/phy/phy_hal.h
@@ -184,7 +184,7 @@ struct shared_phy_params {
 
 extern struct shared_phy *wlc_phy_shared_attach(struct shared_phy_params *shp);
 extern struct brcms_phy_pub *wlc_phy_attach(struct shared_phy *sh,
-					    struct d11regs *regs,
+					    struct d11regs __iomem *regs,
 					    int bandtype, char *vars,
 					    struct wiphy *wiphy);
 extern void wlc_phy_detach(struct brcms_phy_pub *ppi);
diff --git a/drivers/staging/brcm80211/brcmsmac/phy/phy_int.h b/drivers/staging/brcm80211/brcmsmac/phy/phy_int.h
index 1611521..4468090 100644
--- a/drivers/staging/brcm80211/brcmsmac/phy/phy_int.h
+++ b/drivers/staging/brcm80211/brcmsmac/phy/phy_int.h
@@ -559,7 +559,7 @@ struct brcms_phy {
 	} u;
 	bool user_txpwr_at_rfport;
 
-	struct d11regs *regs;
+	struct d11regs __iomem *regs;
 	struct brcms_phy *next;
 	char *vars;
 	struct brcms_phy_pub pubpi;
diff --git a/drivers/staging/brcm80211/brcmsmac/phy/phy_n.c b/drivers/staging/brcm80211/brcmsmac/phy/phy_n.c
index 4023af1..67cfcdd 100644
--- a/drivers/staging/brcm80211/brcmsmac/phy/phy_n.c
+++ b/drivers/staging/brcm80211/brcmsmac/phy/phy_n.c
@@ -19363,7 +19363,7 @@ void wlc_phy_init_nphy(struct brcms_phy *pi)
 	bool do_nphy_cal = false;
 	uint core;
 	uint origidx, intr_val;
-	struct d11regs *regs;
+	struct d11regs __iomem *regs;
 	u32 d11_clk_ctl_st;
 	bool do_rssi_cal = false;
 
@@ -19385,9 +19385,10 @@ void wlc_phy_init_nphy(struct brcms_phy *pi)
 	if ((pi->nphy_gband_spurwar2_en) && CHSPEC_IS2G(pi->radio_chanspec) &&
 	    CHSPEC_IS40(pi->radio_chanspec)) {
 
-		regs = (struct d11regs *) ai_switch_core(pi->sh->sih,
-							 D11_CORE_ID, &origidx,
-							 &intr_val);
+		regs = (struct d11regs __iomem *)
+				ai_switch_core(pi->sh->sih,
+					       D11_CORE_ID, &origidx,
+					       &intr_val);
 		d11_clk_ctl_st = R_REG(&regs->clk_ctl_st);
 		AND_REG(&regs->clk_ctl_st,
 			~(CCS_FORCEHT | CCS_HTAREQ));
-- 
1.7.1


