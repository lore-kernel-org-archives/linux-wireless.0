Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mms2.broadcom.com ([216.31.210.18]:1485 "EHLO mms2.broadcom.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752211Ab1LHXHW (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 8 Dec 2011 18:07:22 -0500
From: "Franky Lin" <frankyl@broadcom.com>
To: linville@tuxdriver.com
cc: linux-wireless@vger.kernel.org
Subject: [PATCH 18/23] brcm80211: smac: use bcma functions for register
 access in phy code
Date: Thu, 8 Dec 2011 15:06:54 -0800
Message-ID: <1323385619-7454-19-git-send-email-frankyl@broadcom.com> (sfid-20111209_000801_123149_B353809E)
In-Reply-To: <1323385619-7454-1-git-send-email-frankyl@broadcom.com>
References: <1323385619-7454-1-git-send-email-frankyl@broadcom.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Arend van Spriel <arend@broadcom.com>

This adds the use of bcma functions to access the registers within
the phy source code.

Reviewed-by: Pieter-Paul Giesberts <pieterpg@broadcom.com>
Reviewed-by: Alwin Beukers <alwin@broadcom.com>
Signed-off-by: Arend van Spriel <arend@broadcom.com>
Signed-off-by: Franky Lin <frankyl@broadcom.com>
---
 drivers/net/wireless/brcm80211/brcmsmac/main.c     |    2 +-
 .../net/wireless/brcm80211/brcmsmac/phy/phy_cmn.c  |  183 +++++++++-----------
 .../net/wireless/brcm80211/brcmsmac/phy/phy_hal.h  |    2 +-
 .../net/wireless/brcm80211/brcmsmac/phy/phy_int.h  |    4 +-
 .../net/wireless/brcm80211/brcmsmac/phy/phy_lcn.c  |   69 ++++----
 .../net/wireless/brcm80211/brcmsmac/phy/phy_n.c    |   75 ++++----
 drivers/net/wireless/brcm80211/brcmsmac/types.h    |    3 +
 7 files changed, 162 insertions(+), 176 deletions(-)

diff --git a/drivers/net/wireless/brcm80211/brcmsmac/main.c b/drivers/net/wireless/brcm80211/brcmsmac/main.c
index 43172b3..5db2bdc 100644
--- a/drivers/net/wireless/brcm80211/brcmsmac/main.c
+++ b/drivers/net/wireless/brcm80211/brcmsmac/main.c
@@ -4626,7 +4626,7 @@ static int brcms_b_attach(struct brcms_c_info *wlc, struct bcma_device *core,
 
 		/* Get a phy for this band */
 		wlc_hw->band->pi =
-			wlc_phy_attach(wlc_hw->phy_sh, core->bus->mmio,
+			wlc_phy_attach(wlc_hw->phy_sh, core,
 				       wlc_hw->band->bandtype,
 				       wlc->wiphy);
 		if (wlc_hw->band->pi == NULL) {
diff --git a/drivers/net/wireless/brcm80211/brcmsmac/phy/phy_cmn.c b/drivers/net/wireless/brcm80211/brcmsmac/phy/phy_cmn.c
index 30cc558..51719b2 100644
--- a/drivers/net/wireless/brcm80211/brcmsmac/phy/phy_cmn.c
+++ b/drivers/net/wireless/brcm80211/brcmsmac/phy/phy_cmn.c
@@ -149,9 +149,8 @@ void wlc_radioreg_enter(struct brcms_phy_pub *pih)
 void wlc_radioreg_exit(struct brcms_phy_pub *pih)
 {
 	struct brcms_phy *pi = (struct brcms_phy *) pih;
-	u16 dummy;
 
-	dummy = R_REG(&pi->regs->phyversion);
+	(void)bcma_read16(pi->d11core, D11REGOFFS(phyversion));
 	pi->phy_wreg = 0;
 	wlapi_bmac_mctrl(pi->sh->physhim, MCTL_LOCK_RADIO, 0);
 }
@@ -186,11 +185,11 @@ u16 read_radio_reg(struct brcms_phy *pi, u16 addr)
 	if ((D11REV_GE(pi->sh->corerev, 24)) ||
 	    (D11REV_IS(pi->sh->corerev, 22)
 	     && (pi->pubpi.phy_type != PHY_TYPE_SSN))) {
-		W_REG_FLUSH(&pi->regs->radioregaddr, addr);
-		data = R_REG(&pi->regs->radioregdata);
+		bcma_wflush16(pi->d11core, D11REGOFFS(radioregaddr), addr);
+		data = bcma_read16(pi->d11core, D11REGOFFS(radioregdata));
 	} else {
-		W_REG_FLUSH(&pi->regs->phy4waddr, addr);
-		data = R_REG(&pi->regs->phy4wdatalo);
+		bcma_wflush16(pi->d11core, D11REGOFFS(phy4waddr), addr);
+		data = bcma_read16(pi->d11core, D11REGOFFS(phy4wdatalo));
 	}
 	pi->phy_wreg = 0;
 
@@ -203,15 +202,15 @@ void write_radio_reg(struct brcms_phy *pi, u16 addr, u16 val)
 	    (D11REV_IS(pi->sh->corerev, 22)
 	     && (pi->pubpi.phy_type != PHY_TYPE_SSN))) {
 
-		W_REG_FLUSH(&pi->regs->radioregaddr, addr);
-		W_REG(&pi->regs->radioregdata, val);
+		bcma_wflush16(pi->d11core, D11REGOFFS(radioregaddr), addr);
+		bcma_write16(pi->d11core, D11REGOFFS(radioregdata), val);
 	} else {
-		W_REG_FLUSH(&pi->regs->phy4waddr, addr);
-		W_REG(&pi->regs->phy4wdatalo, val);
+		bcma_wflush16(pi->d11core, D11REGOFFS(phy4waddr), addr);
+		bcma_write16(pi->d11core, D11REGOFFS(phy4wdatalo), val);
 	}
 
 	if (++pi->phy_wreg >= pi->phy_wreg_limit) {
-		(void)R_REG(&pi->regs->maccontrol);
+		(void)bcma_read32(pi->d11core, D11REGOFFS(maccontrol));
 		pi->phy_wreg = 0;
 	}
 }
@@ -223,19 +222,20 @@ static u32 read_radio_id(struct brcms_phy *pi)
 	if (D11REV_GE(pi->sh->corerev, 24)) {
 		u32 b0, b1, b2;
 
-		W_REG_FLUSH(&pi->regs->radioregaddr, 0);
-		b0 = (u32) R_REG(&pi->regs->radioregdata);
-		W_REG_FLUSH(&pi->regs->radioregaddr, 1);
-		b1 = (u32) R_REG(&pi->regs->radioregdata);
-		W_REG_FLUSH(&pi->regs->radioregaddr, 2);
-		b2 = (u32) R_REG(&pi->regs->radioregdata);
+		bcma_wflush16(pi->d11core, D11REGOFFS(radioregaddr), 0);
+		b0 = (u32) bcma_read16(pi->d11core, D11REGOFFS(radioregdata));
+		bcma_wflush16(pi->d11core, D11REGOFFS(radioregaddr), 1);
+		b1 = (u32) bcma_read16(pi->d11core, D11REGOFFS(radioregdata));
+		bcma_wflush16(pi->d11core, D11REGOFFS(radioregaddr), 2);
+		b2 = (u32) bcma_read16(pi->d11core, D11REGOFFS(radioregdata));
 
 		id = ((b0 & 0xf) << 28) | (((b2 << 8) | b1) << 12) | ((b0 >> 4)
 								      & 0xf);
 	} else {
-		W_REG_FLUSH(&pi->regs->phy4waddr, RADIO_IDCODE);
-		id = (u32) R_REG(&pi->regs->phy4wdatalo);
-		id |= (u32) R_REG(&pi->regs->phy4wdatahi) << 16;
+		bcma_wflush16(pi->d11core, D11REGOFFS(phy4waddr), RADIO_IDCODE);
+		id = (u32) bcma_read16(pi->d11core, D11REGOFFS(phy4wdatalo));
+		id |= (u32) bcma_read16(pi->d11core,
+					D11REGOFFS(phy4wdatahi)) << 16;
 	}
 	pi->phy_wreg = 0;
 	return id;
@@ -275,75 +275,52 @@ void mod_radio_reg(struct brcms_phy *pi, u16 addr, u16 mask, u16 val)
 
 void write_phy_channel_reg(struct brcms_phy *pi, uint val)
 {
-	W_REG(&pi->regs->phychannel, val);
+	bcma_write16(pi->d11core, D11REGOFFS(phychannel), val);
 }
 
 u16 read_phy_reg(struct brcms_phy *pi, u16 addr)
 {
-	struct d11regs __iomem *regs;
-
-	regs = pi->regs;
-
-	W_REG_FLUSH(&regs->phyregaddr, addr);
+	bcma_wflush16(pi->d11core, D11REGOFFS(phyregaddr), addr);
 
 	pi->phy_wreg = 0;
-	return R_REG(&regs->phyregdata);
+	return bcma_read16(pi->d11core, D11REGOFFS(phyregdata));
 }
 
 void write_phy_reg(struct brcms_phy *pi, u16 addr, u16 val)
 {
-	struct d11regs __iomem *regs;
-
-	regs = pi->regs;
-
 #ifdef CONFIG_BCM47XX
-	W_REG_FLUSH(&regs->phyregaddr, addr);
-	W_REG(&regs->phyregdata, val);
+	bcma_wflush16(pi->d11core, D11REGOFFS(phyregaddr), addr);
+	bcma_write16(pi->d11core, D11REGOFFS(phyregdata), val);
 	if (addr == 0x72)
-		(void)R_REG(&regs->phyregdata);
+		(void)bcma_read16(pi->d11core, D11REGOFFS(phyregdata), val);
 #else
-	W_REG((u32 __iomem *)(&regs->phyregaddr), addr | (val << 16));
+	bcma_write32(pi->d11core, D11REGOFFS(phyregaddr), addr | (val << 16));
 	if (++pi->phy_wreg >= pi->phy_wreg_limit) {
 		pi->phy_wreg = 0;
-		(void)R_REG(&regs->phyversion);
+		(void)bcma_read16(pi->d11core, D11REGOFFS(phyversion));
 	}
 #endif
 }
 
 void and_phy_reg(struct brcms_phy *pi, u16 addr, u16 val)
 {
-	struct d11regs __iomem *regs;
-
-	regs = pi->regs;
-
-	W_REG_FLUSH(&regs->phyregaddr, addr);
-
-	W_REG(&regs->phyregdata, (R_REG(&regs->phyregdata) & val));
+	bcma_wflush16(pi->d11core, D11REGOFFS(phyregaddr), addr);
+	bcma_mask16(pi->d11core, D11REGOFFS(phyregdata), val);
 	pi->phy_wreg = 0;
 }
 
 void or_phy_reg(struct brcms_phy *pi, u16 addr, u16 val)
 {
-	struct d11regs __iomem *regs;
-
-	regs = pi->regs;
-
-	W_REG_FLUSH(&regs->phyregaddr, addr);
-
-	W_REG(&regs->phyregdata, (R_REG(&regs->phyregdata) | val));
+	bcma_wflush16(pi->d11core, D11REGOFFS(phyregaddr), addr);
+	bcma_set16(pi->d11core, D11REGOFFS(phyregdata), val);
 	pi->phy_wreg = 0;
 }
 
 void mod_phy_reg(struct brcms_phy *pi, u16 addr, u16 mask, u16 val)
 {
-	struct d11regs __iomem *regs;
-
-	regs = pi->regs;
-
-	W_REG_FLUSH(&regs->phyregaddr, addr);
-
-	W_REG(&regs->phyregdata,
-	      ((R_REG(&regs->phyregdata) & ~mask) | (val & mask)));
+	val &= mask;
+	bcma_wflush16(pi->d11core, D11REGOFFS(phyregaddr), addr);
+	bcma_maskset16(pi->d11core, D11REGOFFS(phyregdata), ~mask, val);
 	pi->phy_wreg = 0;
 }
 
@@ -448,7 +425,7 @@ static u32 wlc_phy_get_radio_ver(struct brcms_phy *pi)
 }
 
 struct brcms_phy_pub *
-wlc_phy_attach(struct shared_phy *sh, struct d11regs __iomem *regs,
+wlc_phy_attach(struct shared_phy *sh, struct bcma_device *d11core,
 	       int bandtype, struct wiphy *wiphy)
 {
 	struct brcms_phy *pi;
@@ -478,7 +455,7 @@ wlc_phy_attach(struct shared_phy *sh, struct d11regs __iomem *regs,
 	if (pi == NULL)
 		return NULL;
 	pi->wiphy = wiphy;
-	pi->regs = regs;
+	pi->d11core = d11core;
 	pi->sh = sh;
 	pi->phy_init_por = true;
 	pi->phy_wreg_limit = PHY_WREG_LIMIT;
@@ -493,7 +470,7 @@ wlc_phy_attach(struct shared_phy *sh, struct d11regs __iomem *regs,
 		pi->pubpi.coreflags = SICF_GMODE;
 
 	wlapi_bmac_corereset(pi->sh->physhim, pi->pubpi.coreflags);
-	phyversion = R_REG(&pi->regs->phyversion);
+	phyversion = bcma_read16(pi->d11core, D11REGOFFS(phyversion));
 
 	pi->pubpi.phy_type = PHY_TYPE(phyversion);
 	pi->pubpi.phy_rev = phyversion & PV_PV_MASK;
@@ -777,7 +754,7 @@ void wlc_phy_init(struct brcms_phy_pub *pih, u16 chanspec)
 
 	pi->radio_chanspec = chanspec;
 
-	mc = R_REG(&pi->regs->maccontrol);
+	mc = bcma_read32(pi->d11core, D11REGOFFS(maccontrol));
 	if (WARN(mc & MCTL_EN_MAC, "HW error MAC running on init"))
 		return;
 
@@ -823,8 +800,8 @@ void wlc_phy_cal_init(struct brcms_phy_pub *pih)
 	struct brcms_phy *pi = (struct brcms_phy *) pih;
 	void (*cal_init)(struct brcms_phy *) = NULL;
 
-	if (WARN((R_REG(&pi->regs->maccontrol) & MCTL_EN_MAC) != 0,
-		 "HW error: MAC enabled during phy cal\n"))
+	if (WARN((bcma_read32(pi->d11core, D11REGOFFS(maccontrol)) &
+		  MCTL_EN_MAC) != 0, "HW error: MAC enabled during phy cal\n"))
 		return;
 
 	if (!pi->initialized) {
@@ -1015,7 +992,7 @@ wlc_phy_init_radio_regs(struct brcms_phy *pi,
 void wlc_phy_do_dummy_tx(struct brcms_phy *pi, bool ofdm, bool pa_on)
 {
 #define DUMMY_PKT_LEN   20
-	struct d11regs __iomem *regs = pi->regs;
+	struct bcma_device *core = pi->d11core;
 	int i, count;
 	u8 ofdmpkt[DUMMY_PKT_LEN] = {
 		0xcc, 0x01, 0x02, 0x00, 0x00, 0x00, 0xd4, 0x00, 0x00, 0x00,
@@ -1031,26 +1008,28 @@ void wlc_phy_do_dummy_tx(struct brcms_phy *pi, bool ofdm, bool pa_on)
 	wlapi_bmac_write_template_ram(pi->sh->physhim, 0, DUMMY_PKT_LEN,
 				      dummypkt);
 
-	W_REG(&regs->xmtsel, 0);
+	bcma_write16(core, D11REGOFFS(xmtsel), 0);
 
 	if (D11REV_GE(pi->sh->corerev, 11))
-		W_REG(&regs->wepctl, 0x100);
+		bcma_write16(core, D11REGOFFS(wepctl), 0x100);
 	else
-		W_REG(&regs->wepctl, 0);
+		bcma_write16(core, D11REGOFFS(wepctl), 0);
 
-	W_REG(&regs->txe_phyctl, (ofdm ? 1 : 0) | PHY_TXC_ANT_0);
+	bcma_write16(core, D11REGOFFS(txe_phyctl),
+		     (ofdm ? 1 : 0) | PHY_TXC_ANT_0);
 	if (ISNPHY(pi) || ISLCNPHY(pi))
-		W_REG(&regs->txe_phyctl1, 0x1A02);
+		bcma_write16(core, D11REGOFFS(txe_phyctl1), 0x1A02);
 
-	W_REG(&regs->txe_wm_0, 0);
-	W_REG(&regs->txe_wm_1, 0);
+	bcma_write16(core, D11REGOFFS(txe_wm_0), 0);
+	bcma_write16(core, D11REGOFFS(txe_wm_1), 0);
 
-	W_REG(&regs->xmttplatetxptr, 0);
-	W_REG(&regs->xmttxcnt, DUMMY_PKT_LEN);
+	bcma_write16(core, D11REGOFFS(xmttplatetxptr), 0);
+	bcma_write16(core, D11REGOFFS(xmttxcnt), DUMMY_PKT_LEN);
 
-	W_REG(&regs->xmtsel, ((8 << 8) | (1 << 5) | (1 << 2) | 2));
+	bcma_write16(core, D11REGOFFS(xmtsel),
+		     ((8 << 8) | (1 << 5) | (1 << 2) | 2));
 
-	W_REG(&regs->txe_ctl, 0);
+	bcma_write16(core, D11REGOFFS(txe_ctl), 0);
 
 	if (!pa_on) {
 		if (ISNPHY(pi))
@@ -1058,27 +1037,28 @@ void wlc_phy_do_dummy_tx(struct brcms_phy *pi, bool ofdm, bool pa_on)
 	}
 
 	if (ISNPHY(pi) || ISLCNPHY(pi))
-		W_REG(&regs->txe_aux, 0xD0);
+		bcma_write16(core, D11REGOFFS(txe_aux), 0xD0);
 	else
-		W_REG(&regs->txe_aux, ((1 << 5) | (1 << 4)));
+		bcma_write16(core, D11REGOFFS(txe_aux), ((1 << 5) | (1 << 4)));
 
-	(void)R_REG(&regs->txe_aux);
+	(void)bcma_read16(core, D11REGOFFS(txe_aux));
 
 	i = 0;
 	count = ofdm ? 30 : 250;
 	while ((i++ < count)
-	       && (R_REG(&regs->txe_status) & (1 << 7)))
+	       && (bcma_read16(core, D11REGOFFS(txe_status)) & (1 << 7)))
 		udelay(10);
 
 	i = 0;
 
-	while ((i++ < 10)
-	       && ((R_REG(&regs->txe_status) & (1 << 10)) == 0))
+	while ((i++ < 10) &&
+	       ((bcma_read16(core, D11REGOFFS(txe_status)) & (1 << 10)) == 0))
 		udelay(10);
 
 	i = 0;
 
-	while ((i++ < 10) && ((R_REG(&regs->ifsstat) & (1 << 8))))
+	while ((i++ < 10) &&
+	       ((bcma_read16(core, D11REGOFFS(ifsstat)) & (1 << 8))))
 		udelay(10);
 
 	if (!pa_on) {
@@ -1135,7 +1115,7 @@ static bool wlc_phy_cal_txpower_recalc_sw(struct brcms_phy *pi)
 void wlc_phy_switch_radio(struct brcms_phy_pub *pih, bool on)
 {
 	struct brcms_phy *pi = (struct brcms_phy *) pih;
-	(void)R_REG(&pi->regs->maccontrol);
+	(void)bcma_read32(pi->d11core, D11REGOFFS(maccontrol));
 
 	if (ISNPHY(pi)) {
 		wlc_phy_switch_radio_nphy(pi, on);
@@ -1375,7 +1355,7 @@ void wlc_phy_txpower_target_set(struct brcms_phy_pub *ppi,
 	memcpy(&pi->tx_user_target[TXP_FIRST_MCS_40_SDM],
 	       &txpwr->mcs_40_mimo[0], BRCMS_NUM_RATES_MCS_2_STREAM);
 
-	if (R_REG(&pi->regs->maccontrol) & MCTL_EN_MAC)
+	if (bcma_read32(pi->d11core, D11REGOFFS(maccontrol)) & MCTL_EN_MAC)
 		mac_enabled = true;
 
 	if (mac_enabled)
@@ -1405,7 +1385,8 @@ int wlc_phy_txpower_set(struct brcms_phy_pub *ppi, uint qdbm, bool override)
 		if (!SCAN_INPROG_PHY(pi)) {
 			bool suspend;
 
-			suspend = (0 == (R_REG(&pi->regs->maccontrol) &
+			suspend = (0 == (bcma_read32(pi->d11core,
+						     D11REGOFFS(maccontrol)) &
 					 MCTL_EN_MAC));
 
 			if (!suspend)
@@ -1858,18 +1839,17 @@ void wlc_phy_runbist_config(struct brcms_phy_pub *ppi, bool start_end)
 
 		if (NREV_IS(pi->pubpi.phy_rev, 3)
 		    || NREV_IS(pi->pubpi.phy_rev, 4)) {
-			W_REG(&pi->regs->phyregaddr, 0xa0);
-			(void)R_REG(&pi->regs->phyregaddr);
-			rxc = R_REG(&pi->regs->phyregdata);
-			W_REG(&pi->regs->phyregdata,
-			      (0x1 << 15) | rxc);
+			bcma_wflush16(pi->d11core, D11REGOFFS(phyregaddr),
+				      0xa0);
+			bcma_set16(pi->d11core, D11REGOFFS(phyregdata),
+				   0x1 << 15);
 		}
 	} else {
 		if (NREV_IS(pi->pubpi.phy_rev, 3)
 		    || NREV_IS(pi->pubpi.phy_rev, 4)) {
-			W_REG(&pi->regs->phyregaddr, 0xa0);
-			(void)R_REG(&pi->regs->phyregaddr);
-			W_REG(&pi->regs->phyregdata, rxc);
+			bcma_wflush16(pi->d11core, D11REGOFFS(phyregaddr),
+				      0xa0);
+			bcma_write16(pi->d11core, D11REGOFFS(phyregdata), rxc);
 		}
 
 		wlc_phy_por_inform(ppi);
@@ -1989,7 +1969,9 @@ void wlc_phy_txpower_hw_ctrl_set(struct brcms_phy_pub *ppi, bool hwpwrctrl)
 	pi->txpwrctrl = hwpwrctrl;
 
 	if (ISNPHY(pi)) {
-		suspend = (0 == (R_REG(&pi->regs->maccontrol) & MCTL_EN_MAC));
+		suspend = (0 == (bcma_read32(pi->d11core,
+					     D11REGOFFS(maccontrol)) &
+				 MCTL_EN_MAC));
 		if (!suspend)
 			wlapi_suspend_mac_and_wait(pi->sh->physhim);
 
@@ -2191,7 +2173,8 @@ void wlc_phy_ant_rxdiv_set(struct brcms_phy_pub *ppi, u8 val)
 	if (!pi->sh->clk)
 		return;
 
-	suspend = (0 == (R_REG(&pi->regs->maccontrol) & MCTL_EN_MAC));
+	suspend = (0 == (bcma_read32(pi->d11core, D11REGOFFS(maccontrol)) &
+			 MCTL_EN_MAC));
 	if (!suspend)
 		wlapi_suspend_mac_and_wait(pi->sh->physhim);
 
@@ -2409,8 +2392,8 @@ wlc_phy_noise_sample_request(struct brcms_phy_pub *pih, u8 reason, u8 ch)
 			wlapi_bmac_write_shm(pi->sh->physhim, M_PWRIND_MAP2, 0);
 			wlapi_bmac_write_shm(pi->sh->physhim, M_PWRIND_MAP3, 0);
 
-			OR_REG(&pi->regs->maccommand,
-			       MCMD_BG_NOISE);
+			bcma_set32(pi->d11core, D11REGOFFS(maccommand),
+				   MCMD_BG_NOISE);
 		} else {
 			wlapi_suspend_mac_and_wait(pi->sh->physhim);
 			wlc_lcnphy_deaf_mode(pi, (bool) 0);
@@ -2428,8 +2411,8 @@ wlc_phy_noise_sample_request(struct brcms_phy_pub *pih, u8 reason, u8 ch)
 			wlapi_bmac_write_shm(pi->sh->physhim, M_PWRIND_MAP2, 0);
 			wlapi_bmac_write_shm(pi->sh->physhim, M_PWRIND_MAP3, 0);
 
-			OR_REG(&pi->regs->maccommand,
-			       MCMD_BG_NOISE);
+			bcma_set32(pi->d11core, D11REGOFFS(maccommand),
+				   MCMD_BG_NOISE);
 		} else {
 			struct phy_iq_est est[PHY_CORE_MAX];
 			u32 cmplx_pwr[PHY_CORE_MAX];
diff --git a/drivers/net/wireless/brcm80211/brcmsmac/phy/phy_hal.h b/drivers/net/wireless/brcm80211/brcmsmac/phy/phy_hal.h
index 5549c7b..e34a71e 100644
--- a/drivers/net/wireless/brcm80211/brcmsmac/phy/phy_hal.h
+++ b/drivers/net/wireless/brcm80211/brcmsmac/phy/phy_hal.h
@@ -181,7 +181,7 @@ struct shared_phy_params {
 
 extern struct shared_phy *wlc_phy_shared_attach(struct shared_phy_params *shp);
 extern struct brcms_phy_pub *wlc_phy_attach(struct shared_phy *sh,
-					    struct d11regs __iomem *regs,
+					    struct bcma_device *d11core,
 					    int bandtype, struct wiphy *wiphy);
 extern void wlc_phy_detach(struct brcms_phy_pub *ppi);
 
diff --git a/drivers/net/wireless/brcm80211/brcmsmac/phy/phy_int.h b/drivers/net/wireless/brcm80211/brcmsmac/phy/phy_int.h
index 02e6407..af00e2c 100644
--- a/drivers/net/wireless/brcm80211/brcmsmac/phy/phy_int.h
+++ b/drivers/net/wireless/brcm80211/brcmsmac/phy/phy_int.h
@@ -557,7 +557,7 @@ struct brcms_phy {
 	} u;
 	bool user_txpwr_at_rfport;
 
-	struct d11regs __iomem *regs;
+	struct bcma_device *d11core;
 	struct brcms_phy *next;
 	struct brcms_phy_pub pubpi;
 
@@ -1088,7 +1088,7 @@ extern void wlc_phy_table_write_nphy(struct brcms_phy *pi, u32, u32, u32,
 
 #define BRCMS_PHY_WAR_PR51571(pi) \
 	if (NREV_LT((pi)->pubpi.phy_rev, 3)) \
-		(void)R_REG(&(pi)->regs->maccontrol)
+		(void)bcma_read32(pi->d11core, D11REGOFFS(maccontrol))
 
 extern void wlc_phy_cal_perical_nphy_run(struct brcms_phy *pi, u8 caltype);
 extern void wlc_phy_aci_reset_nphy(struct brcms_phy *pi);
diff --git a/drivers/net/wireless/brcm80211/brcmsmac/phy/phy_lcn.c b/drivers/net/wireless/brcm80211/brcmsmac/phy/phy_lcn.c
index a63aa99..efa0142 100644
--- a/drivers/net/wireless/brcm80211/brcmsmac/phy/phy_lcn.c
+++ b/drivers/net/wireless/brcm80211/brcmsmac/phy/phy_lcn.c
@@ -2813,10 +2813,8 @@ static void wlc_lcnphy_idle_tssi_est(struct brcms_phy_pub *ppi)
 	u16 SAVE_jtag_auxpga = read_radio_reg(pi, RADIO_2064_REG0FF) & 0x10;
 	u16 SAVE_iqadc_aux_en = read_radio_reg(pi, RADIO_2064_REG11F) & 4;
 	idleTssi = read_phy_reg(pi, 0x4ab);
-	suspend =
-		(0 ==
-		 (R_REG(&((struct brcms_phy *) pi)->regs->maccontrol) &
-		  MCTL_EN_MAC));
+	suspend = (0 == (bcma_read32(pi->d11core, D11REGOFFS(maccontrol)) &
+			 MCTL_EN_MAC));
 	if (!suspend)
 		wlapi_suspend_mac_and_wait(pi->sh->physhim);
 	wlc_lcnphy_set_tx_pwr_ctrl(pi, LCNPHY_TX_PWR_CTRL_OFF);
@@ -2890,7 +2888,8 @@ static void wlc_lcnphy_vbat_temp_sense_setup(struct brcms_phy *pi, u8 mode)
 
 	for (i = 0; i < 14; i++)
 		values_to_save[i] = read_phy_reg(pi, tempsense_phy_regs[i]);
-	suspend = (0 == (R_REG(&pi->regs->maccontrol) & MCTL_EN_MAC));
+	suspend = (0 == (bcma_read32(pi->d11core, D11REGOFFS(maccontrol)) &
+			 MCTL_EN_MAC));
 	if (!suspend)
 		wlapi_suspend_mac_and_wait(pi->sh->physhim);
 	save_txpwrCtrlEn = read_radio_reg(pi, 0x4a4);
@@ -3016,8 +3015,8 @@ static void wlc_lcnphy_tx_pwr_ctrl_init(struct brcms_phy_pub *ppi)
 	bool suspend;
 	struct brcms_phy *pi = (struct brcms_phy *) ppi;
 
-	suspend =
-		(0 == (R_REG(&pi->regs->maccontrol) & MCTL_EN_MAC));
+	suspend = (0 == (bcma_read32(pi->d11core, D11REGOFFS(maccontrol)) &
+			 MCTL_EN_MAC));
 	if (!suspend)
 		wlapi_suspend_mac_and_wait(pi->sh->physhim);
 
@@ -3535,15 +3534,17 @@ wlc_lcnphy_samp_cap(struct brcms_phy *pi, int clip_detect_algo, u16 thresh,
 	timer = 0;
 	old_sslpnCalibClkEnCtrl = read_phy_reg(pi, 0x6da);
 
-	curval1 = R_REG(&pi->regs->psm_corectlsts);
+	curval1 = bcma_read16(pi->d11core, D11REGOFFS(psm_corectlsts));
 	ptr[130] = 0;
-	W_REG(&pi->regs->psm_corectlsts, ((1 << 6) | curval1));
+	bcma_write16(pi->d11core, D11REGOFFS(psm_corectlsts),
+		     ((1 << 6) | curval1));
 
-	W_REG(&pi->regs->smpl_clct_strptr, 0x7E00);
-	W_REG(&pi->regs->smpl_clct_stpptr, 0x8000);
+	bcma_write16(pi->d11core, D11REGOFFS(smpl_clct_strptr), 0x7E00);
+	bcma_write16(pi->d11core, D11REGOFFS(smpl_clct_stpptr), 0x8000);
 	udelay(20);
-	curval2 = R_REG(&pi->regs->psm_phy_hdr_param);
-	W_REG(&pi->regs->psm_phy_hdr_param, curval2 | 0x30);
+	curval2 = bcma_read16(pi->d11core, D11REGOFFS(psm_phy_hdr_param));
+	bcma_write16(pi->d11core, D11REGOFFS(psm_phy_hdr_param),
+		     curval2 | 0x30);
 
 	write_phy_reg(pi, 0x555, 0x0);
 	write_phy_reg(pi, 0x5a6, 0x5);
@@ -3560,19 +3561,19 @@ wlc_lcnphy_samp_cap(struct brcms_phy *pi, int clip_detect_algo, u16 thresh,
 
 	sslpnCalibClkEnCtrl = read_phy_reg(pi, 0x6da);
 	write_phy_reg(pi, 0x6da, (u32) (sslpnCalibClkEnCtrl | 0x2008));
-	stpptr = R_REG(&pi->regs->smpl_clct_stpptr);
-	curptr = R_REG(&pi->regs->smpl_clct_curptr);
+	stpptr = bcma_read16(pi->d11core, D11REGOFFS(smpl_clct_stpptr));
+	curptr = bcma_read16(pi->d11core, D11REGOFFS(smpl_clct_curptr));
 	do {
 		udelay(10);
-		curptr = R_REG(&pi->regs->smpl_clct_curptr);
+		curptr = bcma_read16(pi->d11core, D11REGOFFS(smpl_clct_curptr));
 		timer++;
 	} while ((curptr != stpptr) && (timer < 500));
 
-	W_REG(&pi->regs->psm_phy_hdr_param, 0x2);
+	bcma_write16(pi->d11core, D11REGOFFS(psm_phy_hdr_param), 0x2);
 	strptr = 0x7E00;
-	W_REG(&pi->regs->tplatewrptr, strptr);
+	bcma_write32(pi->d11core, D11REGOFFS(tplatewrptr), strptr);
 	while (strptr < 0x8000) {
-		val = R_REG(&pi->regs->tplatewrdata);
+		val = bcma_read32(pi->d11core, D11REGOFFS(tplatewrdata));
 		imag = ((val >> 16) & 0x3ff);
 		real = ((val) & 0x3ff);
 		if (imag > 511)
@@ -3597,8 +3598,8 @@ wlc_lcnphy_samp_cap(struct brcms_phy *pi, int clip_detect_algo, u16 thresh,
 	}
 
 	write_phy_reg(pi, 0x6da, old_sslpnCalibClkEnCtrl);
-	W_REG(&pi->regs->psm_phy_hdr_param, curval2);
-	W_REG(&pi->regs->psm_corectlsts, curval1);
+	bcma_write16(pi->d11core, D11REGOFFS(psm_phy_hdr_param), curval2);
+	bcma_write16(pi->d11core, D11REGOFFS(psm_corectlsts), curval1);
 }
 
 static void
@@ -3968,9 +3969,9 @@ s16 wlc_lcnphy_tempsense_new(struct brcms_phy *pi, bool mode)
 	bool suspend = 0;
 
 	if (mode == 1) {
-		suspend =
-			(0 ==
-			 (R_REG(&pi->regs->maccontrol) & MCTL_EN_MAC));
+		suspend = (0 == (bcma_read32(pi->d11core,
+					     D11REGOFFS(maccontrol)) &
+				 MCTL_EN_MAC));
 		if (!suspend)
 			wlapi_suspend_mac_and_wait(pi->sh->physhim);
 		wlc_lcnphy_vbat_temp_sense_setup(pi, TEMPSENSE);
@@ -4012,9 +4013,9 @@ u16 wlc_lcnphy_tempsense(struct brcms_phy *pi, bool mode)
 	struct brcms_phy_lcnphy *pi_lcn = pi->u.pi_lcnphy;
 
 	if (mode == 1) {
-		suspend =
-			(0 ==
-			 (R_REG(&pi->regs->maccontrol) & MCTL_EN_MAC));
+		suspend = (0 == (bcma_read32(pi->d11core,
+					     D11REGOFFS(maccontrol)) &
+				 MCTL_EN_MAC));
 		if (!suspend)
 			wlapi_suspend_mac_and_wait(pi->sh->physhim);
 		wlc_lcnphy_vbat_temp_sense_setup(pi, TEMPSENSE);
@@ -4078,9 +4079,9 @@ s8 wlc_lcnphy_vbatsense(struct brcms_phy *pi, bool mode)
 	bool suspend = 0;
 
 	if (mode == 1) {
-		suspend =
-			(0 ==
-			 (R_REG(&pi->regs->maccontrol) & MCTL_EN_MAC));
+		suspend = (0 == (bcma_read32(pi->d11core,
+					     D11REGOFFS(maccontrol)) &
+				 MCTL_EN_MAC));
 		if (!suspend)
 			wlapi_suspend_mac_and_wait(pi->sh->physhim);
 		wlc_lcnphy_vbat_temp_sense_setup(pi, VBATSENSE);
@@ -4127,8 +4128,8 @@ static void wlc_lcnphy_glacial_timer_based_cal(struct brcms_phy *pi)
 	s8 index;
 	u16 SAVE_pwrctrl = wlc_lcnphy_get_tx_pwr_ctrl(pi);
 	struct brcms_phy_lcnphy *pi_lcn = pi->u.pi_lcnphy;
-	suspend =
-		(0 == (R_REG(&pi->regs->maccontrol) & MCTL_EN_MAC));
+	suspend = (0 == (bcma_read32(pi->d11core, D11REGOFFS(maccontrol)) &
+			 MCTL_EN_MAC));
 	if (!suspend)
 		wlapi_suspend_mac_and_wait(pi->sh->physhim);
 	wlc_lcnphy_deaf_mode(pi, true);
@@ -4166,8 +4167,8 @@ static void wlc_lcnphy_periodic_cal(struct brcms_phy *pi)
 	pi_lcn->lcnphy_full_cal_channel = CHSPEC_CHANNEL(pi->radio_chanspec);
 	index = pi_lcn->lcnphy_current_index;
 
-	suspend =
-		(0 == (R_REG(&pi->regs->maccontrol) & MCTL_EN_MAC));
+	suspend = (0 == (bcma_read32(pi->d11core, D11REGOFFS(maccontrol)) &
+			 MCTL_EN_MAC));
 	if (!suspend) {
 		wlapi_bmac_write_shm(pi->sh->physhim, M_CTS_DURATION, 10000);
 		wlapi_suspend_mac_and_wait(pi->sh->physhim);
diff --git a/drivers/net/wireless/brcm80211/brcmsmac/phy/phy_n.c b/drivers/net/wireless/brcm80211/brcmsmac/phy/phy_n.c
index ec9b566..7a20919 100644
--- a/drivers/net/wireless/brcm80211/brcmsmac/phy/phy_n.c
+++ b/drivers/net/wireless/brcm80211/brcmsmac/phy/phy_n.c
@@ -17802,7 +17802,7 @@ static void wlc_phy_txpwrctrl_pwr_setup_nphy(struct brcms_phy *pi)
 
 	if (D11REV_IS(pi->sh->corerev, 11) || D11REV_IS(pi->sh->corerev, 12)) {
 		wlapi_bmac_mctrl(pi->sh->physhim, MCTL_PHYLOCK, MCTL_PHYLOCK);
-		(void)R_REG(&pi->regs->maccontrol);
+		(void)bcma_read32(pi->d11core, D11REGOFFS(maccontrol));
 		udelay(1);
 	}
 
@@ -17953,7 +17953,7 @@ static void wlc_phy_txpwrctrl_pwr_setup_nphy(struct brcms_phy *pi)
 
 	if (D11REV_IS(pi->sh->corerev, 11) || D11REV_IS(pi->sh->corerev, 12)) {
 		wlapi_bmac_mctrl(pi->sh->physhim, MCTL_PHYLOCK, MCTL_PHYLOCK);
-		(void)R_REG(&pi->regs->maccontrol);
+		(void)bcma_read32(pi->d11core, D11REGOFFS(maccontrol));
 		udelay(1);
 	}
 
@@ -19448,7 +19448,6 @@ void wlc_phy_init_nphy(struct brcms_phy *pi)
 	bool do_nphy_cal = false;
 	uint core;
 	uint origidx, intr_val;
-	struct d11regs __iomem *regs;
 	u32 d11_clk_ctl_st;
 	bool do_rssi_cal = false;
 
@@ -19470,15 +19469,15 @@ void wlc_phy_init_nphy(struct brcms_phy *pi)
 	if ((pi->nphy_gband_spurwar2_en) && CHSPEC_IS2G(pi->radio_chanspec) &&
 	    CHSPEC_IS40(pi->radio_chanspec)) {
 
-		regs = (struct d11regs __iomem *)
-				ai_switch_core(pi->sh->sih,
-					       D11_CORE_ID, &origidx,
-					       &intr_val);
-		d11_clk_ctl_st = R_REG(&regs->clk_ctl_st);
-		AND_REG(&regs->clk_ctl_st,
-			~(CCS_FORCEHT | CCS_HTAREQ));
+		ai_switch_core(pi->sh->sih, D11_CORE_ID, &origidx, &intr_val);
 
-		W_REG(&regs->clk_ctl_st, d11_clk_ctl_st);
+		d11_clk_ctl_st = bcma_read32(pi->d11core,
+					     D11REGOFFS(clk_ctl_st));
+		bcma_mask32(pi->d11core, D11REGOFFS(clk_ctl_st),
+			    ~(CCS_FORCEHT | CCS_HTAREQ));
+
+		bcma_write32(pi->d11core, D11REGOFFS(clk_ctl_st),
+			     d11_clk_ctl_st);
 
 		ai_restore_core(pi->sh->sih, origidx, intr_val);
 	}
@@ -19885,7 +19884,8 @@ void wlc_phy_rxcore_setstate_nphy(struct brcms_phy_pub *pih, u8 rxcore_bitmask)
 	if (!pi->sh->clk)
 		return;
 
-	suspend = (0 == (R_REG(&pi->regs->maccontrol) & MCTL_EN_MAC));
+	suspend = (0 == (bcma_read32(pi->d11core, D11REGOFFS(maccontrol)) &
+			 MCTL_EN_MAC));
 	if (!suspend)
 		wlapi_suspend_mac_and_wait(pi->sh->physhim);
 
@@ -21263,28 +21263,28 @@ wlc_phy_chanspec_nphy_setup(struct brcms_phy *pi, u16 chanspec,
 	val = read_phy_reg(pi, 0x09) & NPHY_BandControl_currentBand;
 	if (CHSPEC_IS5G(chanspec) && !val) {
 
-		val = R_REG(&pi->regs->psm_phy_hdr_param);
-		W_REG(&pi->regs->psm_phy_hdr_param,
+		val = bcma_read16(pi->d11core, D11REGOFFS(psm_phy_hdr_param));
+		bcma_write16(pi->d11core, D11REGOFFS(psm_phy_hdr_param),
 		      (val | MAC_PHY_FORCE_CLK));
 
 		or_phy_reg(pi, (NPHY_TO_BPHY_OFF + BPHY_BB_CONFIG),
 			   (BBCFG_RESETCCA | BBCFG_RESETRX));
 
-		W_REG(&pi->regs->psm_phy_hdr_param, val);
+		bcma_write16(pi->d11core, D11REGOFFS(psm_phy_hdr_param), val);
 
 		or_phy_reg(pi, 0x09, NPHY_BandControl_currentBand);
 	} else if (!CHSPEC_IS5G(chanspec) && val) {
 
 		and_phy_reg(pi, 0x09, ~NPHY_BandControl_currentBand);
 
-		val = R_REG(&pi->regs->psm_phy_hdr_param);
-		W_REG(&pi->regs->psm_phy_hdr_param,
+		val = bcma_read16(pi->d11core, D11REGOFFS(psm_phy_hdr_param));
+		bcma_write16(pi->d11core, D11REGOFFS(psm_phy_hdr_param),
 		      (val | MAC_PHY_FORCE_CLK));
 
 		and_phy_reg(pi, (NPHY_TO_BPHY_OFF + BPHY_BB_CONFIG),
 			    (u16) (~(BBCFG_RESETCCA | BBCFG_RESETRX)));
 
-		W_REG(&pi->regs->psm_phy_hdr_param, val);
+		bcma_write16(pi->d11core, D11REGOFFS(psm_phy_hdr_param), val);
 	}
 
 	write_phy_reg(pi, 0x1ce, ci->PHY_BW1a);
@@ -21347,19 +21347,18 @@ wlc_phy_chanspec_nphy_setup(struct brcms_phy *pi, u16 chanspec,
 
 		if ((pi->sh->chip == BCM43224_CHIP_ID) ||
 		    (pi->sh->chip == BCM43225_CHIP_ID)) {
-
 			if (spuravoid == 1) {
-
-				W_REG(&pi->regs->tsf_clk_frac_l,
-				      0x5341);
-				W_REG(&pi->regs->tsf_clk_frac_h,
-				      0x8);
+				bcma_write16(pi->d11core,
+					     D11REGOFFS(tsf_clk_frac_l),
+					     0x5341);
+				bcma_write16(pi->d11core,
+					     D11REGOFFS(tsf_clk_frac_h), 0x8);
 			} else {
-
-				W_REG(&pi->regs->tsf_clk_frac_l,
-				      0x8889);
-				W_REG(&pi->regs->tsf_clk_frac_h,
-				      0x8);
+				bcma_write16(pi->d11core,
+					     D11REGOFFS(tsf_clk_frac_l),
+					     0x8889);
+				bcma_write16(pi->d11core,
+					     D11REGOFFS(tsf_clk_frac_h), 0x8);
 			}
 		}
 
@@ -21499,13 +21498,13 @@ void wlc_phy_antsel_init(struct brcms_phy_pub *ppi, bool lut_init)
 
 		ai_gpiocontrol(pi->sh->sih, mask, mask, GPIO_DRV_PRIORITY);
 
-		mc = R_REG(&pi->regs->maccontrol);
+		mc = bcma_read32(pi->d11core, D11REGOFFS(maccontrol));
 		mc &= ~MCTL_GPOUT_SEL_MASK;
-		W_REG(&pi->regs->maccontrol, mc);
+		bcma_write32(pi->d11core, D11REGOFFS(maccontrol), mc);
 
-		OR_REG(&pi->regs->psm_gpio_oe, mask);
+		bcma_set16(pi->d11core, D11REGOFFS(psm_gpio_oe), mask);
 
-		AND_REG(&pi->regs->psm_gpio_out, ~mask);
+		bcma_mask16(pi->d11core, D11REGOFFS(psm_gpio_out), ~mask);
 
 		if (lut_init) {
 			write_phy_reg(pi, 0xf8, 0x02d8);
@@ -21522,9 +21521,8 @@ u16 wlc_phy_classifier_nphy(struct brcms_phy *pi, u16 mask, u16 val)
 	bool suspended = false;
 
 	if (D11REV_IS(pi->sh->corerev, 16)) {
-		suspended =
-			(R_REG(&pi->regs->maccontrol) & MCTL_EN_MAC) ?
-			false : true;
+		suspended = (bcma_read32(pi->d11core, D11REGOFFS(maccontrol)) &
+			     MCTL_EN_MAC) ? false : true;
 		if (!suspended)
 			wlapi_suspend_mac_and_wait(pi->sh->physhim);
 	}
@@ -25383,7 +25381,8 @@ static void wlc_phy_a4(struct brcms_phy *pi, bool full_cal)
 	if (pi->nphy_papd_skip == 1)
 		return;
 
-	phy_b3 = (0 == (R_REG(&pi->regs->maccontrol) & MCTL_EN_MAC));
+	phy_b3 = (0 == (bcma_read32(pi->d11core, D11REGOFFS(maccontrol)) &
+			MCTL_EN_MAC));
 	if (!phy_b3)
 		wlapi_suspend_mac_and_wait(pi->sh->physhim);
 
@@ -28357,7 +28356,7 @@ void wlc_phy_txpower_recalc_target_nphy(struct brcms_phy *pi)
 
 	if (D11REV_IS(pi->sh->corerev, 11) || D11REV_IS(pi->sh->corerev, 12)) {
 		wlapi_bmac_mctrl(pi->sh->physhim, MCTL_PHYLOCK, MCTL_PHYLOCK);
-		(void)R_REG(&pi->regs->maccontrol);
+		(void)bcma_read32(pi->d11core, D11REGOFFS(maccontrol));
 		udelay(1);
 	}
 
diff --git a/drivers/net/wireless/brcm80211/brcmsmac/types.h b/drivers/net/wireless/brcm80211/brcmsmac/types.h
index 27a814b..e64971a 100644
--- a/drivers/net/wireless/brcm80211/brcmsmac/types.h
+++ b/drivers/net/wireless/brcm80211/brcmsmac/types.h
@@ -300,8 +300,11 @@ do {						\
  * in the code. Older chips and the newer 5357 family don't require this fix.
  */
 #define W_REG_FLUSH(r, v)	({ W_REG((r), (v)); (void)R_REG(r); })
+#define bcma_wflush16(c, o, v) \
+	({ bcma_write16(c, o, v); (void)bcma_read16(c, o); })
 #else
 #define W_REG_FLUSH(r, v)	W_REG((r), (v))
+#define bcma_wflush16(c, o, v)	bcma_write16(c, o, v)
 #endif				/* CONFIG_BCM47XX */
 
 #define AND_REG(r, v)	W_REG((r), R_REG(r) & (v))
-- 
1.7.5.4


