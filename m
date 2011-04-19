Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mms2.broadcom.com ([216.31.210.18]:4310 "EHLO mms2.broadcom.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751889Ab1DSG7P (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 19 Apr 2011 02:59:15 -0400
From: "Roland Vossen" <rvossen@broadcom.com>
To: gregkh@suse.de
cc: devel@linuxdriverproject.org, linux-wireless@vger.kernel.org
Subject: [PATCH 1/3] staging: brcm80211: replaced WL_TRACE by BCMMSG
Date: Tue, 19 Apr 2011 08:59:02 +0200
Message-ID: <1303196344-3157-2-git-send-email-rvossen@broadcom.com>
In-Reply-To: <1303196344-3157-1-git-send-email-rvossen@broadcom.com>
References: <1303196344-3157-1-git-send-email-rvossen@broadcom.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Code cleanup. Make code more readable by converting different macro's
(WL_TRACE, WL_AMPDU, etc) into one BCMMSG. This single macro uses dev_err()
instead of printk(), so the user is able to correlate a log
message to our driver. This patch only replaces WL_TRACE, subsequent patches
will replace WL_AMPDU etc.

Signed-off-by: Roland Vossen <rvossen@broadcom.com>
Reviewed-by: Arend van Spriel <arend@broadcom.com>
---
 drivers/staging/brcm80211/brcmsmac/wl_dbg.h      |   15 ++-
 drivers/staging/brcm80211/brcmsmac/wl_mac80211.c |   18 ++--
 drivers/staging/brcm80211/brcmsmac/wlc_bmac.c    |  104 +++++++++++-----------
 drivers/staging/brcm80211/brcmsmac/wlc_channel.c |    2 +-
 drivers/staging/brcm80211/brcmsmac/wlc_main.c    |   62 +++++++-------
 drivers/staging/brcm80211/brcmsmac/wlc_stf.c     |    6 +-
 6 files changed, 105 insertions(+), 102 deletions(-)

diff --git a/drivers/staging/brcm80211/brcmsmac/wl_dbg.h b/drivers/staging/brcm80211/brcmsmac/wl_dbg.h
index bdc0f85..5e58f5e 100644
--- a/drivers/staging/brcm80211/brcmsmac/wl_dbg.h
+++ b/drivers/staging/brcm80211/brcmsmac/wl_dbg.h
@@ -17,6 +17,8 @@
 #ifndef _wl_dbg_h_
 #define _wl_dbg_h_
 
+#include <linux/device.h>			/* dev_err() */
+
 /* wl_msg_level is a bit vector with defs in wlioctl.h */
 extern u32 wl_msg_level;
 
@@ -26,14 +28,17 @@ do {						\
 		printk(fmt, ##args);		\
 } while (0)
 
+#define BCMMSG(dev, fmt, args...)		\
+do {						\
+	if (wl_msg_level & WL_TRACE_VAL)	\
+		dev_err(dev, "%s: " fmt, __func__, ##args);	\
+} while (0)
+
 #ifdef BCMDBG
 
-#define	WL_TRACE(fmt, args...)	WL_PRINT(WL_TRACE_VAL, fmt, ##args)
 #define WL_AMPDU(fmt, args...)	WL_PRINT(WL_AMPDU_VAL, fmt, ##args)
 #define WL_FFPLD(fmt, args...)	WL_PRINT(WL_FFPLD_VAL, fmt, ##args)
 
-#define WL_ERROR_ON()		(wl_msg_level & WL_ERROR_VAL)
-
 /* Extra message control for AMPDU debugging */
 #define   WL_AMPDU_UPDN_VAL	0x00000001	/* Config up/down related  */
 #define   WL_AMPDU_ERR_VAL	0x00000002	/* Calls to beaocn update  */
@@ -79,8 +84,6 @@ do {						\
 #define WL_AMPDU(fmt, args...)		no_printk(fmt, ##args)
 #define WL_FFPLD(fmt, args...)		no_printk(fmt, ##args)
 
-#define WL_ERROR_ON()		0
-
 #define WL_AMPDU_UPDN(fmt, args...)	no_printk(fmt, ##args)
 #define WL_AMPDU_RX(fmt, args...)	no_printk(fmt, ##args)
 #define WL_AMPDU_ERR(fmt, args...)	no_printk(fmt, ##args)
@@ -95,4 +98,6 @@ do {						\
 
 #endif				/* BCMDBG */
 
+#define WL_ERROR_ON()		(wl_msg_level & WL_ERROR_VAL)
+
 #endif				/* _wl_dbg_h_ */
diff --git a/drivers/staging/brcm80211/brcmsmac/wl_mac80211.c b/drivers/staging/brcm80211/brcmsmac/wl_mac80211.c
index 6ea747f..43938f4 100644
--- a/drivers/staging/brcm80211/brcmsmac/wl_mac80211.c
+++ b/drivers/staging/brcm80211/brcmsmac/wl_mac80211.c
@@ -787,7 +787,7 @@ static struct wl_info *wl_attach(u16 vendor, u16 device, unsigned long regs,
 		/* Do nothing */
 	} else {
 		bustype = PCI_BUS;
-		WL_TRACE("force to PCI\n");
+		BCMMSG(wl->dev, "force to PCI\n");
 	}
 	wl->bcm_bustype = bustype;
 
@@ -1130,9 +1130,9 @@ wl_pci_probe(struct pci_dev *pdev, const struct pci_device_id *ent)
 	struct ieee80211_hw *hw;
 	u32 val;
 
-	WL_TRACE("%s: bus %d slot %d func %d irq %d\n",
-		 __func__, pdev->bus->number, PCI_SLOT(pdev->devfn),
-		 PCI_FUNC(pdev->devfn), pdev->irq);
+	BCMMSG(&pdev->dev, "bus %d slot %d func %d irq %d\n",
+	       pdev->bus->number, PCI_SLOT(pdev->devfn),
+	       PCI_FUNC(pdev->devfn), pdev->irq);
 
 	if ((pdev->vendor != PCI_VENDOR_ID_BROADCOM) ||
 	    (((pdev->device & 0xff00) != 0x4300) &&
@@ -1181,7 +1181,7 @@ static int wl_suspend(struct pci_dev *pdev, pm_message_t state)
 	struct wl_info *wl;
 	struct ieee80211_hw *hw;
 
-	WL_TRACE("wl: wl_suspend\n");
+	BCMMSG(&pdev->dev, "\n");
 
 	hw = pci_get_drvdata(pdev);
 	wl = HW_TO_WL(hw);
@@ -1208,7 +1208,7 @@ static int wl_resume(struct pci_dev *pdev)
 	int err = 0;
 	u32 val;
 
-	WL_TRACE("wl: wl_resume\n");
+	BCMMSG(&pdev->dev, "wl:\n");
 	hw = pci_get_drvdata(pdev);
 	wl = HW_TO_WL(hw);
 	if (!wl) {
@@ -1441,8 +1441,7 @@ void wl_txflowcontrol(struct wl_info *wl, struct wl_if *wlif, bool state,
  */
 void wl_init(struct wl_info *wl)
 {
-	WL_TRACE("wl%d: wl_init\n", wl->pub->unit);
-
+	BCMMSG(&WL_TO_HW(wl)->wiphy->dev, "wl%d\n", wl->pub->unit);
 	wl_reset(wl);
 
 	wlc_init(wl->wlc);
@@ -1453,8 +1452,7 @@ void wl_init(struct wl_info *wl)
  */
 uint wl_reset(struct wl_info *wl)
 {
-	WL_TRACE("wl%d: wl_reset\n", wl->pub->unit);
-
+	BCMMSG(&WL_TO_HW(wl)->wiphy->dev, "wl%d\n", wl->pub->unit);
 	wlc_reset(wl->wlc);
 
 	/* dpc will not be rescheduled */
diff --git a/drivers/staging/brcm80211/brcmsmac/wlc_bmac.c b/drivers/staging/brcm80211/brcmsmac/wlc_bmac.c
index fd3669e..fc61584 100644
--- a/drivers/staging/brcm80211/brcmsmac/wlc_bmac.c
+++ b/drivers/staging/brcm80211/brcmsmac/wlc_bmac.c
@@ -234,7 +234,7 @@ static u32 WLBANDINITFN(wlc_setband_inact) (struct wlc_info *wlc, uint bandunit)
 	struct wlc_hw_info *wlc_hw = wlc->hw;
 	u32 macintmask;
 
-	WL_TRACE("wl%d: wlc_setband_inact\n", wlc_hw->unit);
+	BCMMSG(wlc->dev, "wl%d\n", wlc_hw->unit);
 
 	WARN_ON((R_REG(&wlc_hw->regs->maccontrol) & MCTL_EN_MAC) != 0);
 
@@ -266,7 +266,7 @@ wlc_bmac_recv(struct wlc_hw_info *wlc_hw, uint fifo, bool bound)
 	uint bound_limit = bound ? wlc_hw->wlc->pub->tunables->rxbnd : -1;
 	wlc_d11rxhdr_t *wlc_rxhdr = NULL;
 
-	WL_TRACE("wl%d: %s\n", wlc_hw->unit, __func__);
+	BCMMSG(wlc_hw->wlc->dev, "wl%d\n", wlc_hw->unit);
 	/* gather received frames */
 	while ((p = dma_rx(wlc_hw->di[fifo]))) {
 
@@ -323,8 +323,8 @@ bool BCMFASTPATH wlc_dpc(struct wlc_info *wlc, bool bounded)
 	macintstatus = wlc->macintstatus;
 	wlc->macintstatus = 0;
 
-	WL_TRACE("wl%d: wlc_dpc: macintstatus 0x%x\n",
-		 wlc_hw->unit, macintstatus);
+	BCMMSG(wlc->dev, "wl%d: macintstatus 0x%x\n",
+	       wlc_hw->unit, macintstatus);
 
 	WARN_ON(macintstatus & MI_PRQ); /* PRQ Interrupt in non-MBSS */
 
@@ -354,8 +354,7 @@ bool BCMFASTPATH wlc_dpc(struct wlc_info *wlc, bool bounded)
 
 	/* ATIM window end */
 	if (macintstatus & MI_ATIMWINEND) {
-		WL_TRACE("wlc_isr: end of ATIM window\n");
-
+		BCMMSG(wlc->dev, "end of ATIM window\n");
 		OR_REG(&regs->maccommand, wlc->qvalid);
 		wlc->qvalid = 0;
 	}
@@ -404,8 +403,8 @@ bool BCMFASTPATH wlc_dpc(struct wlc_info *wlc, bool bounded)
 	}
 
 	if (macintstatus & MI_RFDISABLE) {
-		WL_TRACE("wl%d: BMAC Detected a change on the RF Disable Input\n", wlc_hw->unit);
-
+		BCMMSG(wlc->dev, "wl%d: BMAC Detected a change on the"
+		       " RF Disable Input\n", wlc_hw->unit);
 		wlc->pub->_cnt->rfdisable++;
 		wl_rfkill_set_hw_state(wlc->wl);
 	}
@@ -428,7 +427,7 @@ void wlc_bmac_watchdog(void *arg)
 	struct wlc_info *wlc = (struct wlc_info *) arg;
 	struct wlc_hw_info *wlc_hw = wlc->hw;
 
-	WL_TRACE("wl%d: wlc_bmac_watchdog\n", wlc_hw->unit);
+	BCMMSG(wlc->dev, "wl%d\n", wlc_hw->unit);
 
 	if (!wlc_hw->up)
 		return;
@@ -451,8 +450,7 @@ wlc_bmac_set_chanspec(struct wlc_hw_info *wlc_hw, chanspec_t chanspec,
 {
 	uint bandunit;
 
-	WL_TRACE("wl%d: wlc_bmac_set_chanspec 0x%x\n",
-		 wlc_hw->unit, chanspec);
+	BCMMSG(wlc_hw->wlc->dev, "wl%d: 0x%x\n", wlc_hw->unit, chanspec);
 
 	wlc_hw->chanspec = chanspec;
 
@@ -625,9 +623,8 @@ int wlc_bmac_attach(struct wlc_info *wlc, u16 vendor, u16 device, uint unit,
 	shared_phy_params_t sha_params;
 	struct device *dev = wlc->dev;
 
-	WL_TRACE("wl%d: wlc_bmac_attach: vendor 0x%x device 0x%x\n",
-		 unit, vendor, device);
-
+	BCMMSG(wlc->dev, "wl%d: vendor 0x%x device 0x%x\n", unit, vendor,
+		device);
 
 	wme = true;
 
@@ -942,8 +939,9 @@ int wlc_bmac_attach(struct wlc_info *wlc, u16 vendor, u16 device, uint unit,
 		goto fail;
 	}
 
-	WL_TRACE("%s:: deviceid 0x%x nbands %d board 0x%x macaddr: %s\n",
-		 __func__, wlc_hw->deviceid, wlc_hw->_nbands,
+	BCMMSG(wlc->dev,
+		 "deviceid 0x%x nbands %d board 0x%x macaddr: %s\n",
+		 wlc_hw->deviceid, wlc_hw->_nbands,
 		 wlc_hw->sih->boardtype, macaddr);
 
 	return err;
@@ -1031,7 +1029,7 @@ int wlc_bmac_detach(struct wlc_info *wlc)
 
 void wlc_bmac_reset(struct wlc_hw_info *wlc_hw)
 {
-	WL_TRACE("wl%d: wlc_bmac_reset\n", wlc_hw->unit);
+	BCMMSG(wlc_hw->wlc->dev, "wl%d\n", wlc_hw->unit);
 
 	wlc_hw->wlc->pub->_cnt->reset++;
 
@@ -1052,7 +1050,7 @@ wlc_bmac_init(struct wlc_hw_info *wlc_hw, chanspec_t chanspec,
 	bool fastclk;
 	struct wlc_info *wlc = wlc_hw->wlc;
 
-	WL_TRACE("wl%d: wlc_bmac_init\n", wlc_hw->unit);
+	BCMMSG(wlc_hw->wlc->dev, "wl%d\n", wlc_hw->unit);
 
 	/* request FAST clock if not on */
 	fastclk = wlc_hw->forcefastclk;
@@ -1101,7 +1099,7 @@ int wlc_bmac_up_prep(struct wlc_hw_info *wlc_hw)
 {
 	uint coremask;
 
-	WL_TRACE("wl%d: %s:\n", wlc_hw->unit, __func__);
+	BCMMSG(wlc_hw->wlc->dev, "wl%d\n", wlc_hw->unit);
 
 	/*
 	 * Enable pll and xtal, initialize the power control registers,
@@ -1143,7 +1141,7 @@ int wlc_bmac_up_prep(struct wlc_hw_info *wlc_hw)
 
 int wlc_bmac_up_finish(struct wlc_hw_info *wlc_hw)
 {
-	WL_TRACE("wl%d: %s:\n", wlc_hw->unit, __func__);
+	BCMMSG(wlc_hw->wlc->dev, "wl%d\n", wlc_hw->unit);
 
 	wlc_hw->up = true;
 	wlc_phy_hw_state_upd(wlc_hw->band->pi, true);
@@ -1159,7 +1157,7 @@ int wlc_bmac_down_prep(struct wlc_hw_info *wlc_hw)
 	bool dev_gone;
 	uint callbacks = 0;
 
-	WL_TRACE("wl%d: %s:\n", wlc_hw->unit, __func__);
+	BCMMSG(wlc_hw->wlc->dev, "wl%d\n", wlc_hw->unit);
 
 	if (!wlc_hw->up)
 		return callbacks;
@@ -1187,7 +1185,7 @@ int wlc_bmac_down_finish(struct wlc_hw_info *wlc_hw)
 	uint callbacks = 0;
 	bool dev_gone;
 
-	WL_TRACE("wl%d: %s:\n", wlc_hw->unit, __func__);
+	BCMMSG(wlc_hw->wlc->dev, "wl%d\n", wlc_hw->unit);
 
 	if (!wlc_hw->up)
 		return callbacks;
@@ -1570,7 +1568,7 @@ wlc_bmac_set_rcmta(struct wlc_hw_info *wlc_hw, int idx,
 	u32 mac_hm;
 	u16 mac_l;
 
-	WL_TRACE("wl%d: %s\n", wlc_hw->unit, __func__);
+	BCMMSG(wlc_hw->wlc->dev, "wl%d\n", wlc_hw->unit);
 
 	mac_hm =
 	    (addr[3] << 24) | (addr[2] << 16) |
@@ -1597,7 +1595,8 @@ wlc_bmac_set_addrmatch(struct wlc_hw_info *wlc_hw, int match_reg_offset,
 	u16 mac_m;
 	u16 mac_h;
 
-	WL_TRACE("wl%d: wlc_bmac_set_addrmatch\n", wlc_hw->unit);
+	BCMMSG(wlc_hw->wlc->dev, "wl%d: wlc_bmac_set_addrmatch\n",
+		 wlc_hw->unit);
 
 	regs = wlc_hw->regs;
 	mac_l = addr[0] | (addr[1] << 8);
@@ -1622,7 +1621,7 @@ wlc_bmac_write_template_ram(struct wlc_hw_info *wlc_hw, int offset, int len,
 #ifdef IL_BIGENDIAN
 	volatile u16 *dptr = NULL;
 #endif				/* IL_BIGENDIAN */
-	WL_TRACE("wl%d: wlc_bmac_write_template_ram\n", wlc_hw->unit);
+	BCMMSG(wlc_hw->wlc->dev, "wl%d\n", wlc_hw->unit);
 
 	regs = wlc_hw->regs;
 	W_REG(&regs->tplatewrptr, offset);
@@ -1755,8 +1754,8 @@ WLBANDINITFN(wlc_bmac_bsinit) (struct wlc_info *wlc, chanspec_t chanspec)
 {
 	struct wlc_hw_info *wlc_hw = wlc->hw;
 
-	WL_TRACE("wl%d: wlc_bmac_bsinit: bandunit %d\n",
-		 wlc_hw->unit, wlc_hw->band->bandunit);
+	BCMMSG(wlc->dev, "wl%d: bandunit %d\n", wlc_hw->unit,
+		wlc_hw->band->bandunit);
 
 	wlc_ucode_bsinit(wlc_hw);
 
@@ -1785,7 +1784,7 @@ WLBANDINITFN(wlc_bmac_bsinit) (struct wlc_info *wlc, chanspec_t chanspec)
 
 static void wlc_bmac_core_phy_clk(struct wlc_hw_info *wlc_hw, bool clk)
 {
-	WL_TRACE("wl%d: wlc_bmac_core_phy_clk: clk %d\n", wlc_hw->unit, clk);
+	BCMMSG(wlc_hw->wlc->dev, "wl%d: clk %d\n", wlc_hw->unit, clk);
 
 	wlc_hw->phyclk = clk;
 
@@ -1810,7 +1809,7 @@ static void wlc_bmac_core_phy_clk(struct wlc_hw_info *wlc_hw, bool clk)
 /* Perform a soft reset of the PHY PLL */
 void wlc_bmac_core_phypll_reset(struct wlc_hw_info *wlc_hw)
 {
-	WL_TRACE("wl%d: wlc_bmac_core_phypll_reset\n", wlc_hw->unit);
+	BCMMSG(wlc_hw->wlc->dev, "wl%d\n", wlc_hw->unit);
 
 	ai_corereg(wlc_hw->sih, SI_CC_IDX,
 		   offsetof(chipcregs_t, chipcontrol_addr), ~0, 0);
@@ -1856,7 +1855,7 @@ void wlc_bmac_phy_reset(struct wlc_hw_info *wlc_hw)
 	u32 phy_bw_clkbits;
 	bool phy_in_reset = false;
 
-	WL_TRACE("wl%d: wlc_bmac_phy_reset\n", wlc_hw->unit);
+	BCMMSG(wlc_hw->wlc->dev, "wl%d\n", wlc_hw->unit);
 
 	if (pih == NULL)
 		return;
@@ -1933,7 +1932,8 @@ WLBANDINITFN(wlc_bmac_setband) (struct wlc_hw_info *wlc_hw, uint bandunit,
 /* low-level band switch utility routine */
 void WLBANDINITFN(wlc_setxband) (struct wlc_hw_info *wlc_hw, uint bandunit)
 {
-	WL_TRACE("wl%d: wlc_setxband: bandunit %d\n", wlc_hw->unit, bandunit);
+	BCMMSG(wlc_hw->wlc->dev, "wl%d: bandunit %d\n", wlc_hw->unit,
+		bandunit);
 
 	wlc_hw->band = wlc_hw->bandstate[bandunit];
 
@@ -2062,7 +2062,7 @@ void wlc_bmac_hw_up(struct wlc_hw_info *wlc_hw)
 	if (wlc_hw->wlc->pub->hw_up)
 		return;
 
-	WL_TRACE("wl%d: %s:\n", wlc_hw->unit, __func__);
+	BCMMSG(wlc_hw->wlc->dev, "wl%d\n", wlc_hw->unit);
 
 	/*
 	 * Enable pll and xtal, initialize the power control registers,
@@ -2123,7 +2123,7 @@ void wlc_bmac_corereset(struct wlc_hw_info *wlc_hw, u32 flags)
 	if (flags == WLC_USE_COREFLAGS)
 		flags = (wlc_hw->band->pi ? wlc_hw->band->core_flags : 0);
 
-	WL_TRACE("wl%d: %s\n", wlc_hw->unit, __func__);
+	BCMMSG(wlc_hw->wlc->dev, "wl%d\n", wlc_hw->unit);
 
 	regs = wlc_hw->regs;
 
@@ -2265,7 +2265,7 @@ static void wlc_coreinit(struct wlc_info *wlc)
 
 	regs = wlc_hw->regs;
 
-	WL_TRACE("wl%d: wlc_coreinit\n", wlc_hw->unit);
+	BCMMSG(wlc->dev, "wl%d\n", wlc_hw->unit);
 
 	/* reset PSM */
 	wlc_bmac_mctrl(wlc_hw, ~0, (MCTL_IHR_EN | MCTL_PSM_JMP_0 | MCTL_WAKE));
@@ -2564,7 +2564,7 @@ static void wlc_ucode_write(struct wlc_hw_info *wlc_hw, const u32 ucode[],
 	uint i;
 	uint count;
 
-	WL_TRACE("wl%d: wlc_ucode_write\n", wlc_hw->unit);
+	BCMMSG(wlc_hw->wlc->dev, "wl%d\n", wlc_hw->unit);
 
 	count = (nbytes / sizeof(u32));
 
@@ -2580,7 +2580,7 @@ static void wlc_write_inits(struct wlc_hw_info *wlc_hw,
 	int i;
 	volatile u8 *base;
 
-	WL_TRACE("wl%d: wlc_write_inits\n", wlc_hw->unit);
+	BCMMSG(wlc_hw->wlc->dev, "wl%d\n", wlc_hw->unit);
 
 	base = (volatile u8 *)wlc_hw->regs;
 
@@ -2653,8 +2653,8 @@ void wlc_bmac_fifoerrors(struct wlc_hw_info *wlc_hw)
 		if (!intstatus)
 			continue;
 
-		WL_TRACE("wl%d: wlc_bmac_fifoerrors: intstatus%d 0x%x\n",
-			 unit, idx, intstatus);
+		BCMMSG(wlc_hw->wlc->dev, "wl%d: intstatus%d 0x%x\n",
+			unit, idx, intstatus);
 
 		if (intstatus & I_RO) {
 			dev_err(dev, "wl%d: fifo %d: receive fifo overflow\n",
@@ -2904,7 +2904,8 @@ static inline u32 wlc_intstatus(struct wlc_info *wlc, bool in_isr)
 	/* macintstatus includes a DMA interrupt summary bit */
 	macintstatus = R_REG(&regs->macintstatus);
 
-	WL_TRACE("wl%d: macintstatus: 0x%x\n", wlc_hw->unit, macintstatus);
+	BCMMSG(wlc->dev, "wl%d: macintstatus: 0x%x\n", wlc_hw->unit,
+		 macintstatus);
 
 	/* detect cardbus removed, in power down(suspend) and in reset */
 	if (DEVICEREMOVED(wlc))
@@ -3037,7 +3038,7 @@ wlc_bmac_txstatus(struct wlc_hw_info *wlc_hw, bool bound, bool *fatal)
 	 */
 	uint max_tx_num = bound ? wlc->pub->tunables->txsbnd : -1;
 
-	WL_TRACE("wl%d: wlc_bmac_txstatus\n", wlc_hw->unit);
+	BCMMSG(wlc->dev, "wl%d\n", wlc_hw->unit);
 
 	txs = &txstatus;
 	regs = wlc_hw->regs;
@@ -3084,8 +3085,8 @@ void wlc_suspend_mac_and_wait(struct wlc_info *wlc)
 	u32 mc, mi;
 	struct device *dev = wlc->dev;
 
-	WL_TRACE("wl%d: wlc_suspend_mac_and_wait: bandunit %d\n",
-		 wlc_hw->unit, wlc_hw->band->bandunit);
+	BCMMSG(wlc->dev, "wl%d: bandunit %d\n", wlc_hw->unit,
+		wlc_hw->band->bandunit);
 
 	/*
 	 * Track overlapping suspend requests
@@ -3148,8 +3149,8 @@ void wlc_enable_mac(struct wlc_info *wlc)
 	d11regs_t *regs = wlc_hw->regs;
 	u32 mc, mi;
 
-	WL_TRACE("wl%d: wlc_enable_mac: bandunit %d\n",
-		 wlc_hw->unit, wlc->band->bandunit);
+	BCMMSG(wlc->dev, "wl%d: bandunit %d\n", wlc_hw->unit,
+		wlc->band->bandunit);
 
 	/*
 	 * Track overlapping suspend requests
@@ -3271,7 +3272,7 @@ static bool wlc_bmac_validate_chip_access(struct wlc_hw_info *wlc_hw)
 	u32 w, val;
 	struct device *dev = wlc_hw->wlc->dev;
 
-	WL_TRACE("wl%d: validate_chip_access\n", wlc_hw->unit);
+	BCMMSG(dev, "wl%d\n", wlc_hw->unit);
 
 	regs = wlc_hw->regs;
 
@@ -3335,7 +3336,7 @@ void wlc_bmac_core_phypll_ctl(struct wlc_hw_info *wlc_hw, bool on)
 	d11regs_t *regs;
 	u32 tmp;
 
-	WL_TRACE("wl%d: wlc_bmac_core_phypll_ctl\n", wlc_hw->unit);
+	BCMMSG(wlc_hw->wlc->dev, "wl%d\n", wlc_hw->unit);
 
 	tmp = 0;
 	regs = wlc_hw->regs;
@@ -3386,7 +3387,7 @@ void wlc_coredisable(struct wlc_hw_info *wlc_hw)
 {
 	bool dev_gone;
 
-	WL_TRACE("wl%d: %s\n", wlc_hw->unit, __func__);
+	BCMMSG(wlc_hw->wlc->dev, "wl%d\n", wlc_hw->unit);
 
 	dev_gone = DEVICEREMOVED(wlc_hw->wlc);
 
@@ -3422,7 +3423,7 @@ void wlc_coredisable(struct wlc_hw_info *wlc_hw)
 /* power both the pll and external oscillator on/off */
 static void wlc_bmac_xtal(struct wlc_hw_info *wlc_hw, bool want)
 {
-	WL_TRACE("wl%d: wlc_bmac_xtal: want %d\n", wlc_hw->unit, want);
+	BCMMSG(wlc_hw->wlc->dev, "wl%d: want %d\n", wlc_hw->unit, want);
 
 	/* dont power down if plldown is false or we must poll hw radio disable */
 	if (!want && wlc_hw->pllreq)
@@ -3451,8 +3452,7 @@ static void wlc_flushqueues(struct wlc_info *wlc)
 		if (wlc_hw->di[i]) {
 			dma_txreclaim(wlc_hw->di[i], HNDDMA_RANGE_ALL);
 			TXPKTPENDCLR(wlc, i);
-			WL_TRACE("wlc_flushqueues: pktpend fifo %d cleared\n",
-				 i);
+			BCMMSG(wlc->dev, "pktpend fifo %d clrd\n", i);
 		}
 
 	/* free any posted rx packets */
@@ -3567,8 +3567,8 @@ wlc_bmac_copyfrom_objmem(struct wlc_hw_info *wlc_hw, uint offset, void *buf,
 
 void wlc_bmac_copyfrom_vars(struct wlc_hw_info *wlc_hw, char **buf, uint *len)
 {
-	WL_TRACE("wlc_bmac_copyfrom_vars, nvram vars totlen=%d\n",
-		 wlc_hw->vars_size);
+	BCMMSG(wlc_hw->wlc->dev, "nvram vars totlen=%d\n",
+		wlc_hw->vars_size);
 
 	*buf = wlc_hw->vars;
 	*len = wlc_hw->vars_size;
diff --git a/drivers/staging/brcm80211/brcmsmac/wlc_channel.c b/drivers/staging/brcm80211/brcmsmac/wlc_channel.c
index 55a741b..fea71ec 100644
--- a/drivers/staging/brcm80211/brcmsmac/wlc_channel.c
+++ b/drivers/staging/brcm80211/brcmsmac/wlc_channel.c
@@ -631,7 +631,7 @@ wlc_cm_info_t *wlc_channel_mgr_attach(struct wlc_info *wlc)
 	struct wlc_pub *pub = wlc->pub;
 	char *ccode;
 
-	WL_TRACE("wl%d: wlc_channel_mgr_attach\n", wlc->pub->unit);
+	BCMMSG(wlc->dev, "wl%d\n", wlc->pub->unit);
 
 	wlc_cm = kzalloc(sizeof(wlc_cm_info_t), GFP_ATOMIC);
 	if (wlc_cm == NULL) {
diff --git a/drivers/staging/brcm80211/brcmsmac/wlc_main.c b/drivers/staging/brcm80211/brcmsmac/wlc_main.c
index 6fb9d9c..46bf93b 100644
--- a/drivers/staging/brcm80211/brcmsmac/wlc_main.c
+++ b/drivers/staging/brcm80211/brcmsmac/wlc_main.c
@@ -329,7 +329,7 @@ void wlc_get_rcmta(struct wlc_info *wlc, int idx, u8 *addr)
 	d11regs_t *regs = wlc->regs;
 	u32 v32;
 
-	WL_TRACE("wl%d: %s\n", WLCWLUNIT(wlc), __func__);
+	BCMMSG(wlc->dev, "wl%d\n", WLCWLUNIT(wlc));
 
 	W_REG(&regs->objaddr, (OBJADDR_RCMTA_SEL | (idx * 2)));
 	(void)R_REG(&regs->objaddr);
@@ -383,7 +383,7 @@ bool wlc_ps_allowed(struct wlc_info *wlc)
 
 void wlc_reset(struct wlc_info *wlc)
 {
-	WL_TRACE("wl%d: wlc_reset\n", wlc->pub->unit);
+	BCMMSG(wlc->dev, "wl%d\n", wlc->pub->unit);
 
 	wlc->check_for_unaligned_tbtt = false;
 
@@ -439,7 +439,7 @@ void wlc_init(struct wlc_info *wlc)
 	struct wlc_bsscfg *bsscfg;
 	bool mute = false;
 
-	WL_TRACE("wl%d: wlc_init\n", wlc->pub->unit);
+	BCMMSG(wlc->dev, "wl%d\n", wlc->pub->unit);
 
 	regs = wlc->regs;
 
@@ -611,7 +611,7 @@ void wlc_set_ps_ctrl(struct wlc_info *wlc)
 	hps = PS_ALLOWED(wlc);
 	wake = hps ? (STAY_AWAKE(wlc)) : true;
 
-	WL_TRACE("wl%d: wlc_set_ps_ctrl: hps %d wake %d\n",
+	BCMMSG(wlc->dev, "wl%d: hps %d wake %d\n",
 		 wlc->pub->unit, hps, wake);
 
 	v1 = R_REG(&wlc->regs->maccontrol);
@@ -1082,7 +1082,7 @@ void wlc_beacon_phytxctl_txant_upd(struct wlc_info *wlc, ratespec_t bcn_rspec)
 */
 void wlc_protection_upd(struct wlc_info *wlc, uint idx, int val)
 {
-	WL_TRACE("wlc_protection_upd: idx %d, val %d\n", idx, val);
+	BCMMSG(wlc->dev, "idx %d, val %d\n", idx, val);
 
 	switch (idx) {
 	case WLC_PROT_G_SPEC:
@@ -1192,7 +1192,7 @@ static void wlc_bandinit_ordered(struct wlc_info *wlc, chanspec_t chanspec)
 	uint parkband;
 	uint i, band_order[2];
 
-	WL_TRACE("wl%d: wlc_bandinit_ordered\n", wlc->pub->unit);
+	BCMMSG(wlc->dev, "wl%d\n", wlc->pub->unit);
 	/*
 	 * We might have been bandlocked during down and the chip power-cycled (hibernate).
 	 * figure out the right band to park on
@@ -1233,7 +1233,7 @@ static void wlc_bandinit_ordered(struct wlc_info *wlc, chanspec_t chanspec)
 /* band-specific init */
 static void WLBANDINITFN(wlc_bsinit) (struct wlc_info *wlc)
 {
-	WL_TRACE("wl%d: wlc_bsinit: bandunit %d\n",
+	BCMMSG(wlc->dev, "wl%d: bandunit %d\n",
 		 wlc->pub->unit, wlc->band->bandunit);
 
 	/* write ucode ACK/CTS rate table */
@@ -1992,7 +1992,7 @@ uint wlc_detach(struct wlc_info *wlc)
 	if (wlc == NULL)
 		return 0;
 
-	WL_TRACE("wl%d: %s\n", wlc->pub->unit, __func__);
+	BCMMSG(wlc->dev, "wl%d\n", wlc->pub->unit);
 
 	callbacks += wlc_bmac_detach(wlc);
 
@@ -2262,7 +2262,7 @@ static void wlc_watchdog(void *arg)
 	int i;
 	struct wlc_bsscfg *cfg;
 
-	WL_TRACE("wl%d: wlc_watchdog\n", wlc->pub->unit);
+	BCMMSG(wlc->dev, "wl%d\n", wlc->pub->unit);
 
 	if (!wlc->pub->up)
 		return;
@@ -2330,7 +2330,7 @@ static void wlc_watchdog(void *arg)
 /* make interface operational */
 int wlc_up(struct wlc_info *wlc)
 {
-	WL_TRACE("wl%d: %s:\n", wlc->pub->unit, __func__);
+	BCMMSG(wlc->dev, "wl%d\n", wlc->pub->unit);
 
 	/* HW is turned off so don't try to access it */
 	if (wlc->pub->hw_off || DEVICEREMOVED(wlc))
@@ -2476,7 +2476,7 @@ uint wlc_down(struct wlc_info *wlc)
 	bool dev_gone = false;
 	struct wlc_txq_info *qi;
 
-	WL_TRACE("wl%d: %s:\n", wlc->pub->unit, __func__);
+	BCMMSG(wlc->dev, "wl%d\n", wlc->pub->unit);
 
 	/* check if we are already in the going down path */
 	if (wlc->going_down) {
@@ -4278,7 +4278,7 @@ wlc_doiovar(void *hdl, const bcm_iovar_t *vi, u32 actionid,
 	bool bool_val2;
 	wlc_bss_info_t *current_bss;
 
-	WL_TRACE("wl%d: %s\n", wlc->pub->unit, __func__);
+	BCMMSG(wlc->dev, "wl%d\n", wlc->pub->unit);
 
 	bsscfg = NULL;
 	current_bss = NULL;
@@ -4302,8 +4302,7 @@ wlc_doiovar(void *hdl, const bcm_iovar_t *vi, u32 actionid,
 	bool_val = (int_val != 0) ? true : false;
 	bool_val2 = (int_val2 != 0) ? true : false;
 
-	WL_TRACE("wl%d: %s: id %d\n",
-		 wlc->pub->unit, __func__, IOV_ID(actionid));
+	BCMMSG(wlc->dev, "wl%d: id %d\n", wlc->pub->unit, IOV_ID(actionid));
 	/* Do the actual parameter implementation */
 	switch (actionid) {
 	case IOV_SVAL(IOV_RTSTHRESH):
@@ -5060,7 +5059,7 @@ wlc_txfifo(struct wlc_info *wlc, uint fifo, struct sk_buff *p, bool commit,
 	 */
 	if (commit) {
 		TXPKTPENDINC(wlc, fifo, txpktpend);
-		WL_TRACE("wlc_txfifo, pktpend inc %d to %d\n",
+		BCMMSG(wlc->dev, "pktpend inc %d to %d\n",
 			 txpktpend, TXPKTPENDGET(wlc, fifo));
 	}
 
@@ -6131,7 +6130,7 @@ void wlc_high_dpc(struct wlc_info *wlc, u32 macintstatus)
 	if (macintstatus & ~(MI_TBTT | MI_TXSTOP)) {
 		bcm_format_flags(int_flags, macintstatus, flagstr,
 				 sizeof(flagstr));
-		WL_TRACE("wl%d: macintstatus 0x%x %s\n",
+		BCMMSG(wlc->dev, "wl%d: macintstatus 0x%x %s\n",
 			 wlc->pub->unit, macintstatus, flagstr);
 	}
 #endif				/* BCMDBG */
@@ -6360,8 +6359,8 @@ void BCMFASTPATH
 wlc_txfifo_complete(struct wlc_info *wlc, uint fifo, s8 txpktpend)
 {
 	TXPKTPENDDEC(wlc, fifo, txpktpend);
-	WL_TRACE("wlc_txfifo_complete, pktpend dec %d to %d\n",
-		 txpktpend, TXPKTPENDGET(wlc, fifo));
+	BCMMSG(wlc->dev, "pktpend dec %d to %d\n", txpktpend,
+		TXPKTPENDGET(wlc, fifo));
 
 	/* There is more room; mark precedences related to this FIFO sendable */
 	WLC_TX_FIFO_ENAB(wlc, fifo);
@@ -6668,7 +6667,7 @@ void BCMFASTPATH wlc_recv(struct wlc_info *wlc, struct sk_buff *p)
 	uint len;
 	bool is_amsdu;
 
-	WL_TRACE("wl%d: wlc_recv\n", wlc->pub->unit);
+	BCMMSG(wlc->dev, "wl%d\n", wlc->pub->unit);
 
 	/* frame starts with rxhdr */
 	rxh = (d11rxhdr_t *) (p->data);
@@ -6765,7 +6764,7 @@ wlc_calc_lsig_len(struct wlc_info *wlc, ratespec_t ratespec, uint mac_len)
 {
 	uint nsyms, len = 0, kNdps;
 
-	WL_TRACE("wl%d: wlc_calc_lsig_len: rate %d, len%d\n",
+	BCMMSG(wlc->dev, "wl%d: rate %d, len%d\n",
 		 wlc->pub->unit, RSPEC2RATE(ratespec), mac_len);
 
 	if (IS_MCS(ratespec)) {
@@ -6813,7 +6812,7 @@ wlc_calc_frame_time(struct wlc_info *wlc, ratespec_t ratespec, u8 preamble_type,
 		rate = WLC_RATE_1M;
 	}
 
-	WL_TRACE("wl%d: wlc_calc_frame_time: rspec 0x%x, preamble_type %d, len%d\n",
+	BCMMSG(wlc->dev, "wl%d: rspec 0x%x, preamble_type %d, len%d\n",
 		 wlc->pub->unit, ratespec, preamble_type, mac_len);
 
 	if (IS_MCS(ratespec)) {
@@ -6876,7 +6875,7 @@ wlc_calc_frame_len(struct wlc_info *wlc, ratespec_t ratespec, u8 preamble_type,
 	uint nsyms, mac_len, Ndps, kNdps;
 	uint rate = RSPEC2RATE(ratespec);
 
-	WL_TRACE("wl%d: wlc_calc_frame_len: rspec 0x%x, preamble_type %d, dur %d\n",
+	BCMMSG(wlc->dev, "wl%d: rspec 0x%x, preamble_type %d, dur %d\n",
 		 wlc->pub->unit, ratespec, preamble_type, dur);
 
 	if (IS_MCS(ratespec)) {
@@ -6918,8 +6917,8 @@ wlc_calc_frame_len(struct wlc_info *wlc, ratespec_t ratespec, u8 preamble_type,
 static uint
 wlc_calc_ba_time(struct wlc_info *wlc, ratespec_t rspec, u8 preamble_type)
 {
-	WL_TRACE("wl%d: wlc_calc_ba_time: rspec 0x%x, preamble_type %d\n",
-		 wlc->pub->unit, rspec, preamble_type);
+	BCMMSG(wlc->dev, "wl%d: rspec 0x%x, "
+		 "preamble_type %d\n", wlc->pub->unit, rspec, preamble_type);
 	/* Spec 9.6: ack rate is the highest rate in BSSBasicRateSet that is less than
 	 * or equal to the rate of the immediately previous frame in the FES
 	 */
@@ -6935,8 +6934,8 @@ wlc_calc_ack_time(struct wlc_info *wlc, ratespec_t rspec, u8 preamble_type)
 {
 	uint dur = 0;
 
-	WL_TRACE("wl%d: wlc_calc_ack_time: rspec 0x%x, preamble_type %d\n",
-		 wlc->pub->unit, rspec, preamble_type);
+	BCMMSG(wlc->dev, "wl%d: rspec 0x%x, preamble_type %d\n",
+		wlc->pub->unit, rspec, preamble_type);
 	/* Spec 9.6: ack rate is the highest rate in BSSBasicRateSet that is less than
 	 * or equal to the rate of the immediately previous frame in the FES
 	 */
@@ -6951,8 +6950,8 @@ wlc_calc_ack_time(struct wlc_info *wlc, ratespec_t rspec, u8 preamble_type)
 static uint
 wlc_calc_cts_time(struct wlc_info *wlc, ratespec_t rspec, u8 preamble_type)
 {
-	WL_TRACE("wl%d: wlc_calc_cts_time: ratespec 0x%x, preamble_type %d\n",
-		 wlc->pub->unit, rspec, preamble_type);
+	BCMMSG(wlc->dev, "wl%d: ratespec 0x%x, preamble_type %d\n",
+		wlc->pub->unit, rspec, preamble_type);
 	return wlc_calc_ack_time(wlc, rspec, preamble_type);
 }
 
@@ -7652,8 +7651,9 @@ mac80211_wlc_set_nrate(struct wlc_info *wlc, struct wlcband *cur_band,
 		} else if (rate > HIGHEST_SINGLE_STREAM_MCS) {
 			/* mcs > 7 must use stf SDM */
 			if (stf != PHY_TXC1_MODE_SDM) {
-				WL_TRACE("wl%d: %s: enabling SDM mode for mcs %d\n",
-					 WLCWLUNIT(wlc), __func__, rate);
+				BCMMSG(wlc->dev, "wl%d: enabling "
+					 "SDM mode for mcs %d\n",
+					 WLCWLUNIT(wlc), rate);
 				stf = PHY_TXC1_MODE_SDM;
 			}
 		} else {
@@ -7924,7 +7924,7 @@ void wlc_txflowcontrol(struct wlc_info *wlc, struct wlc_txq_info *qi,
 	uint prio_bits;
 	uint cur_bits;
 
-	WL_TRACE("%s: flow control kicks in\n", __func__);
+	BCMMSG(wlc->dev, "flow control kicks in\n");
 
 	if (prio == ALLPRIO) {
 		prio_bits = TXQ_STOP_FOR_PRIOFC_MASK;
diff --git a/drivers/staging/brcm80211/brcmsmac/wlc_stf.c b/drivers/staging/brcm80211/brcmsmac/wlc_stf.c
index c58ab68..97f9b4d 100644
--- a/drivers/staging/brcm80211/brcmsmac/wlc_stf.c
+++ b/drivers/staging/brcm80211/brcmsmac/wlc_stf.c
@@ -190,8 +190,8 @@ bool wlc_stf_stbc_rx_set(struct wlc_info *wlc, s32 int_val)
 
 static int wlc_stf_txcore_set(struct wlc_info *wlc, u8 Nsts, u8 core_mask)
 {
-	WL_TRACE("wl%d: %s: Nsts %d core_mask %x\n",
-		 wlc->pub->unit, __func__, Nsts, core_mask);
+	BCMMSG(wlc->dev, "wl%d: Nsts %d core_mask %x\n",
+		 wlc->pub->unit, Nsts, core_mask);
 
 	if (WLC_BITSCNT(core_mask) > wlc->stf->txstreams) {
 		core_mask = 0;
@@ -226,7 +226,7 @@ static int wlc_stf_spatial_policy_set(struct wlc_info *wlc, int val)
 	int i;
 	u8 core_mask = 0;
 
-	WL_TRACE("wl%d: %s: val %x\n", wlc->pub->unit, __func__, val);
+	BCMMSG(wlc->dev, "wl%d: val %x\n", wlc->pub->unit, val);
 
 	wlc->stf->spatial_policy = (s8) val;
 	for (i = 1; i <= MAX_STREAMS_SUPPORTED; i++) {
-- 
1.7.1


