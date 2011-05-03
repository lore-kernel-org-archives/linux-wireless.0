Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mms1.broadcom.com ([216.31.210.17]:2303 "EHLO mms1.broadcom.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752249Ab1ECJg1 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 3 May 2011 05:36:27 -0400
From: "Arend van Spriel" <arend@broadcom.com>
To: gregkh@suse.de
cc: "Roland Vossen" <rvossen@broadcom.com>,
	devel@linuxdriverproject.org, linux-wireless@vger.kernel.org,
	"Brett Rudley" <brudley@broadcom.com>,
	"Henry Ptasinski" <henryp@broadcom.com>
Subject: [PATCH 58/61] staging: brcm80211: replaced WL_TRACE by BCMMSG
Date: Tue, 3 May 2011 11:35:58 +0200
Message-ID: <1304415361-7813-59-git-send-email-arend@broadcom.com> (sfid-20110503_113649_004039_6D367C02)
In-Reply-To: <1304415361-7813-1-git-send-email-arend@broadcom.com>
References: <1304415361-7813-1-git-send-email-arend@broadcom.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Roland Vossen <rvossen@broadcom.com>

Code cleanup. Make code more readable by converting different macro's
(WL_TRACE, WL_AMPDU, etc) into one BCMMSG. This single macro uses wiphy_err()
instead of printk(), so the user is able to correlate a log
message to our driver. This patch only replaces WL_TRACE, subsequent patches
will replace WL_AMPDU etc.

Cc: devel@linuxdriverproject.org
Cc: linux-wireless@vger.kernel.org
Cc: Brett Rudley <brudley@broadcom.com>
Cc: Henry Ptasinski <henryp@broadcom.com>
Cc: Roland Vossen <rvossen@broadcom.com>
Signed-off-by: Arend van Spriel <arend@broadcom.com>
---
 drivers/staging/brcm80211/brcmsmac/wl_dbg.h      |   15 ++-
 drivers/staging/brcm80211/brcmsmac/wl_mac80211.c |   17 ++---
 drivers/staging/brcm80211/brcmsmac/wlc_bmac.c    |  104 +++++++++++-----------
 drivers/staging/brcm80211/brcmsmac/wlc_channel.c |    2 +-
 drivers/staging/brcm80211/brcmsmac/wlc_main.c    |   62 +++++++-------
 drivers/staging/brcm80211/brcmsmac/wlc_stf.c     |    6 +-
 6 files changed, 103 insertions(+), 103 deletions(-)

diff --git a/drivers/staging/brcm80211/brcmsmac/wl_dbg.h b/drivers/staging/brcm80211/brcmsmac/wl_dbg.h
index bdc0f85..6e7f664 100644
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
+		wiphy_err(dev, "%s: " fmt, __func__, ##args);	\
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
index 0a11e80..a932284 100644
--- a/drivers/staging/brcm80211/brcmsmac/wl_mac80211.c
+++ b/drivers/staging/brcm80211/brcmsmac/wl_mac80211.c
@@ -766,7 +766,7 @@ static struct wl_info *wl_attach(u16 vendor, u16 device, unsigned long regs,
 		/* Do nothing */
 	} else {
 		bustype = PCI_BUS;
-		WL_TRACE("force to PCI\n");
+		BCMMSG(wl->wiphy, "force to PCI\n");
 	}
 	wl->bcm_bustype = bustype;
 
@@ -1104,9 +1104,9 @@ wl_pci_probe(struct pci_dev *pdev, const struct pci_device_id *ent)
 	struct ieee80211_hw *hw;
 	u32 val;
 
-	WL_TRACE("%s: bus %d slot %d func %d irq %d\n",
-		 __func__, pdev->bus->number, PCI_SLOT(pdev->devfn),
-		 PCI_FUNC(pdev->devfn), pdev->irq);
+	dev_info(&pdev->dev, "bus %d slot %d func %d irq %d\n",
+	       pdev->bus->number, PCI_SLOT(pdev->devfn),
+	       PCI_FUNC(pdev->devfn), pdev->irq);
 
 	if ((pdev->vendor != PCI_VENDOR_ID_BROADCOM) ||
 	    (((pdev->device & 0xff00) != 0x4300) &&
@@ -1155,8 +1155,6 @@ static int wl_suspend(struct pci_dev *pdev, pm_message_t state)
 	struct wl_info *wl;
 	struct ieee80211_hw *hw;
 
-	WL_TRACE("wl: wl_suspend\n");
-
 	hw = pci_get_drvdata(pdev);
 	wl = HW_TO_WL(hw);
 	if (!wl) {
@@ -1182,7 +1180,6 @@ static int wl_resume(struct pci_dev *pdev)
 	int err = 0;
 	u32 val;
 
-	WL_TRACE("wl: wl_resume\n");
 	hw = pci_get_drvdata(pdev);
 	wl = HW_TO_WL(hw);
 	if (!wl) {
@@ -1414,8 +1411,7 @@ void wl_txflowcontrol(struct wl_info *wl, struct wl_if *wlif, bool state,
  */
 void wl_init(struct wl_info *wl)
 {
-	WL_TRACE("wl%d: wl_init\n", wl->pub->unit);
-
+	BCMMSG(WL_TO_HW(wl)->wiphy, "wl%d\n", wl->pub->unit);
 	wl_reset(wl);
 
 	wlc_init(wl->wlc);
@@ -1426,8 +1422,7 @@ void wl_init(struct wl_info *wl)
  */
 uint wl_reset(struct wl_info *wl)
 {
-	WL_TRACE("wl%d: wl_reset\n", wl->pub->unit);
-
+	BCMMSG(WL_TO_HW(wl)->wiphy, "wl%d\n", wl->pub->unit);
 	wlc_reset(wl->wlc);
 
 	/* dpc will not be rescheduled */
diff --git a/drivers/staging/brcm80211/brcmsmac/wlc_bmac.c b/drivers/staging/brcm80211/brcmsmac/wlc_bmac.c
index 5217ead..91d366d 100644
--- a/drivers/staging/brcm80211/brcmsmac/wlc_bmac.c
+++ b/drivers/staging/brcm80211/brcmsmac/wlc_bmac.c
@@ -235,7 +235,7 @@ static u32 WLBANDINITFN(wlc_setband_inact) (struct wlc_info *wlc, uint bandunit)
 	struct wlc_hw_info *wlc_hw = wlc->hw;
 	u32 macintmask;
 
-	WL_TRACE("wl%d: wlc_setband_inact\n", wlc_hw->unit);
+	BCMMSG(wlc->wiphy, "wl%d\n", wlc_hw->unit);
 
 	WARN_ON((R_REG(&wlc_hw->regs->maccontrol) & MCTL_EN_MAC) != 0);
 
@@ -267,7 +267,7 @@ wlc_bmac_recv(struct wlc_hw_info *wlc_hw, uint fifo, bool bound)
 	uint bound_limit = bound ? wlc_hw->wlc->pub->tunables->rxbnd : -1;
 	wlc_d11rxhdr_t *wlc_rxhdr = NULL;
 
-	WL_TRACE("wl%d: %s\n", wlc_hw->unit, __func__);
+	BCMMSG(wlc_hw->wlc->wiphy, "wl%d\n", wlc_hw->unit);
 	/* gather received frames */
 	while ((p = dma_rx(wlc_hw->di[fifo]))) {
 
@@ -325,8 +325,8 @@ bool BCMFASTPATH wlc_dpc(struct wlc_info *wlc, bool bounded)
 	macintstatus = wlc->macintstatus;
 	wlc->macintstatus = 0;
 
-	WL_TRACE("wl%d: wlc_dpc: macintstatus 0x%x\n",
-		 wlc_hw->unit, macintstatus);
+	BCMMSG(wlc->wiphy, "wl%d: macintstatus 0x%x\n",
+	       wlc_hw->unit, macintstatus);
 
 	WARN_ON(macintstatus & MI_PRQ); /* PRQ Interrupt in non-MBSS */
 
@@ -356,8 +356,7 @@ bool BCMFASTPATH wlc_dpc(struct wlc_info *wlc, bool bounded)
 
 	/* ATIM window end */
 	if (macintstatus & MI_ATIMWINEND) {
-		WL_TRACE("wlc_isr: end of ATIM window\n");
-
+		BCMMSG(wlc->wiphy, "end of ATIM window\n");
 		OR_REG(&regs->maccommand, wlc->qvalid);
 		wlc->qvalid = 0;
 	}
@@ -406,8 +405,8 @@ bool BCMFASTPATH wlc_dpc(struct wlc_info *wlc, bool bounded)
 	}
 
 	if (macintstatus & MI_RFDISABLE) {
-		WL_TRACE("wl%d: BMAC Detected a change on the RF Disable Input\n", wlc_hw->unit);
-
+		BCMMSG(wlc->wiphy, "wl%d: BMAC Detected a change on the"
+		       " RF Disable Input\n", wlc_hw->unit);
 		wlc->pub->_cnt->rfdisable++;
 		wl_rfkill_set_hw_state(wlc->wl);
 	}
@@ -430,7 +429,7 @@ void wlc_bmac_watchdog(void *arg)
 	struct wlc_info *wlc = (struct wlc_info *) arg;
 	struct wlc_hw_info *wlc_hw = wlc->hw;
 
-	WL_TRACE("wl%d: wlc_bmac_watchdog\n", wlc_hw->unit);
+	BCMMSG(wlc->wiphy, "wl%d\n", wlc_hw->unit);
 
 	if (!wlc_hw->up)
 		return;
@@ -453,8 +452,7 @@ wlc_bmac_set_chanspec(struct wlc_hw_info *wlc_hw, chanspec_t chanspec,
 {
 	uint bandunit;
 
-	WL_TRACE("wl%d: wlc_bmac_set_chanspec 0x%x\n",
-		 wlc_hw->unit, chanspec);
+	BCMMSG(wlc_hw->wlc->wiphy, "wl%d: 0x%x\n", wlc_hw->unit, chanspec);
 
 	wlc_hw->chanspec = chanspec;
 
@@ -627,9 +625,8 @@ int wlc_bmac_attach(struct wlc_info *wlc, u16 vendor, u16 device, uint unit,
 	shared_phy_params_t sha_params;
 	struct wiphy *wiphy = wlc->wiphy;
 
-	WL_TRACE("wl%d: wlc_bmac_attach: vendor 0x%x device 0x%x\n",
-		 unit, vendor, device);
-
+	BCMMSG(wlc->wiphy, "wl%d: vendor 0x%x device 0x%x\n", unit, vendor,
+		device);
 
 	wme = true;
 
@@ -945,8 +942,9 @@ int wlc_bmac_attach(struct wlc_info *wlc, u16 vendor, u16 device, uint unit,
 		goto fail;
 	}
 
-	WL_TRACE("%s:: deviceid 0x%x nbands %d board 0x%x macaddr: %s\n",
-		 __func__, wlc_hw->deviceid, wlc_hw->_nbands,
+	BCMMSG(wlc->wiphy,
+		 "deviceid 0x%x nbands %d board 0x%x macaddr: %s\n",
+		 wlc_hw->deviceid, wlc_hw->_nbands,
 		 wlc_hw->sih->boardtype, macaddr);
 
 	return err;
@@ -1035,7 +1033,7 @@ int wlc_bmac_detach(struct wlc_info *wlc)
 
 void wlc_bmac_reset(struct wlc_hw_info *wlc_hw)
 {
-	WL_TRACE("wl%d: wlc_bmac_reset\n", wlc_hw->unit);
+	BCMMSG(wlc_hw->wlc->wiphy, "wl%d\n", wlc_hw->unit);
 
 	wlc_hw->wlc->pub->_cnt->reset++;
 
@@ -1056,7 +1054,7 @@ wlc_bmac_init(struct wlc_hw_info *wlc_hw, chanspec_t chanspec,
 	bool fastclk;
 	struct wlc_info *wlc = wlc_hw->wlc;
 
-	WL_TRACE("wl%d: wlc_bmac_init\n", wlc_hw->unit);
+	BCMMSG(wlc_hw->wlc->wiphy, "wl%d\n", wlc_hw->unit);
 
 	/* request FAST clock if not on */
 	fastclk = wlc_hw->forcefastclk;
@@ -1105,7 +1103,7 @@ int wlc_bmac_up_prep(struct wlc_hw_info *wlc_hw)
 {
 	uint coremask;
 
-	WL_TRACE("wl%d: %s:\n", wlc_hw->unit, __func__);
+	BCMMSG(wlc_hw->wlc->wiphy, "wl%d\n", wlc_hw->unit);
 
 	/*
 	 * Enable pll and xtal, initialize the power control registers,
@@ -1147,7 +1145,7 @@ int wlc_bmac_up_prep(struct wlc_hw_info *wlc_hw)
 
 int wlc_bmac_up_finish(struct wlc_hw_info *wlc_hw)
 {
-	WL_TRACE("wl%d: %s:\n", wlc_hw->unit, __func__);
+	BCMMSG(wlc_hw->wlc->wiphy, "wl%d\n", wlc_hw->unit);
 
 	wlc_hw->up = true;
 	wlc_phy_hw_state_upd(wlc_hw->band->pi, true);
@@ -1163,7 +1161,7 @@ int wlc_bmac_down_prep(struct wlc_hw_info *wlc_hw)
 	bool dev_gone;
 	uint callbacks = 0;
 
-	WL_TRACE("wl%d: %s:\n", wlc_hw->unit, __func__);
+	BCMMSG(wlc_hw->wlc->wiphy, "wl%d\n", wlc_hw->unit);
 
 	if (!wlc_hw->up)
 		return callbacks;
@@ -1191,7 +1189,7 @@ int wlc_bmac_down_finish(struct wlc_hw_info *wlc_hw)
 	uint callbacks = 0;
 	bool dev_gone;
 
-	WL_TRACE("wl%d: %s:\n", wlc_hw->unit, __func__);
+	BCMMSG(wlc_hw->wlc->wiphy, "wl%d\n", wlc_hw->unit);
 
 	if (!wlc_hw->up)
 		return callbacks;
@@ -1574,7 +1572,7 @@ wlc_bmac_set_rcmta(struct wlc_hw_info *wlc_hw, int idx,
 	u32 mac_hm;
 	u16 mac_l;
 
-	WL_TRACE("wl%d: %s\n", wlc_hw->unit, __func__);
+	BCMMSG(wlc_hw->wlc->wiphy, "wl%d\n", wlc_hw->unit);
 
 	mac_hm =
 	    (addr[3] << 24) | (addr[2] << 16) |
@@ -1601,7 +1599,8 @@ wlc_bmac_set_addrmatch(struct wlc_hw_info *wlc_hw, int match_reg_offset,
 	u16 mac_m;
 	u16 mac_h;
 
-	WL_TRACE("wl%d: wlc_bmac_set_addrmatch\n", wlc_hw->unit);
+	BCMMSG(wlc_hw->wlc->wiphy, "wl%d: wlc_bmac_set_addrmatch\n",
+		 wlc_hw->unit);
 
 	regs = wlc_hw->regs;
 	mac_l = addr[0] | (addr[1] << 8);
@@ -1626,7 +1625,7 @@ wlc_bmac_write_template_ram(struct wlc_hw_info *wlc_hw, int offset, int len,
 #ifdef IL_BIGENDIAN
 	volatile u16 *dptr = NULL;
 #endif				/* IL_BIGENDIAN */
-	WL_TRACE("wl%d: wlc_bmac_write_template_ram\n", wlc_hw->unit);
+	BCMMSG(wlc_hw->wlc->wiphy, "wl%d\n", wlc_hw->unit);
 
 	regs = wlc_hw->regs;
 	W_REG(&regs->tplatewrptr, offset);
@@ -1759,8 +1758,8 @@ WLBANDINITFN(wlc_bmac_bsinit) (struct wlc_info *wlc, chanspec_t chanspec)
 {
 	struct wlc_hw_info *wlc_hw = wlc->hw;
 
-	WL_TRACE("wl%d: wlc_bmac_bsinit: bandunit %d\n",
-		 wlc_hw->unit, wlc_hw->band->bandunit);
+	BCMMSG(wlc->wiphy, "wl%d: bandunit %d\n", wlc_hw->unit,
+		wlc_hw->band->bandunit);
 
 	wlc_ucode_bsinit(wlc_hw);
 
@@ -1789,7 +1788,7 @@ WLBANDINITFN(wlc_bmac_bsinit) (struct wlc_info *wlc, chanspec_t chanspec)
 
 static void wlc_bmac_core_phy_clk(struct wlc_hw_info *wlc_hw, bool clk)
 {
-	WL_TRACE("wl%d: wlc_bmac_core_phy_clk: clk %d\n", wlc_hw->unit, clk);
+	BCMMSG(wlc_hw->wlc->wiphy, "wl%d: clk %d\n", wlc_hw->unit, clk);
 
 	wlc_hw->phyclk = clk;
 
@@ -1814,7 +1813,7 @@ static void wlc_bmac_core_phy_clk(struct wlc_hw_info *wlc_hw, bool clk)
 /* Perform a soft reset of the PHY PLL */
 void wlc_bmac_core_phypll_reset(struct wlc_hw_info *wlc_hw)
 {
-	WL_TRACE("wl%d: wlc_bmac_core_phypll_reset\n", wlc_hw->unit);
+	BCMMSG(wlc_hw->wlc->wiphy, "wl%d\n", wlc_hw->unit);
 
 	ai_corereg(wlc_hw->sih, SI_CC_IDX,
 		   offsetof(chipcregs_t, chipcontrol_addr), ~0, 0);
@@ -1860,7 +1859,7 @@ void wlc_bmac_phy_reset(struct wlc_hw_info *wlc_hw)
 	u32 phy_bw_clkbits;
 	bool phy_in_reset = false;
 
-	WL_TRACE("wl%d: wlc_bmac_phy_reset\n", wlc_hw->unit);
+	BCMMSG(wlc_hw->wlc->wiphy, "wl%d\n", wlc_hw->unit);
 
 	if (pih == NULL)
 		return;
@@ -1937,7 +1936,8 @@ WLBANDINITFN(wlc_bmac_setband) (struct wlc_hw_info *wlc_hw, uint bandunit,
 /* low-level band switch utility routine */
 void WLBANDINITFN(wlc_setxband) (struct wlc_hw_info *wlc_hw, uint bandunit)
 {
-	WL_TRACE("wl%d: wlc_setxband: bandunit %d\n", wlc_hw->unit, bandunit);
+	BCMMSG(wlc_hw->wlc->wiphy, "wl%d: bandunit %d\n", wlc_hw->unit,
+		bandunit);
 
 	wlc_hw->band = wlc_hw->bandstate[bandunit];
 
@@ -2066,7 +2066,7 @@ void wlc_bmac_hw_up(struct wlc_hw_info *wlc_hw)
 	if (wlc_hw->wlc->pub->hw_up)
 		return;
 
-	WL_TRACE("wl%d: %s:\n", wlc_hw->unit, __func__);
+	BCMMSG(wlc_hw->wlc->wiphy, "wl%d\n", wlc_hw->unit);
 
 	/*
 	 * Enable pll and xtal, initialize the power control registers,
@@ -2127,7 +2127,7 @@ void wlc_bmac_corereset(struct wlc_hw_info *wlc_hw, u32 flags)
 	if (flags == WLC_USE_COREFLAGS)
 		flags = (wlc_hw->band->pi ? wlc_hw->band->core_flags : 0);
 
-	WL_TRACE("wl%d: %s\n", wlc_hw->unit, __func__);
+	BCMMSG(wlc_hw->wlc->wiphy, "wl%d\n", wlc_hw->unit);
 
 	regs = wlc_hw->regs;
 
@@ -2269,7 +2269,7 @@ static void wlc_coreinit(struct wlc_info *wlc)
 
 	regs = wlc_hw->regs;
 
-	WL_TRACE("wl%d: wlc_coreinit\n", wlc_hw->unit);
+	BCMMSG(wlc->wiphy, "wl%d\n", wlc_hw->unit);
 
 	/* reset PSM */
 	wlc_bmac_mctrl(wlc_hw, ~0, (MCTL_IHR_EN | MCTL_PSM_JMP_0 | MCTL_WAKE));
@@ -2572,7 +2572,7 @@ static void wlc_ucode_write(struct wlc_hw_info *wlc_hw, const u32 ucode[],
 	uint i;
 	uint count;
 
-	WL_TRACE("wl%d: wlc_ucode_write\n", wlc_hw->unit);
+	BCMMSG(wlc_hw->wlc->wiphy, "wl%d\n", wlc_hw->unit);
 
 	count = (nbytes / sizeof(u32));
 
@@ -2588,7 +2588,7 @@ static void wlc_write_inits(struct wlc_hw_info *wlc_hw,
 	int i;
 	volatile u8 *base;
 
-	WL_TRACE("wl%d: wlc_write_inits\n", wlc_hw->unit);
+	BCMMSG(wlc_hw->wlc->wiphy, "wl%d\n", wlc_hw->unit);
 
 	base = (volatile u8 *)wlc_hw->regs;
 
@@ -2661,8 +2661,8 @@ void wlc_bmac_fifoerrors(struct wlc_hw_info *wlc_hw)
 		if (!intstatus)
 			continue;
 
-		WL_TRACE("wl%d: wlc_bmac_fifoerrors: intstatus%d 0x%x\n",
-			 unit, idx, intstatus);
+		BCMMSG(wlc_hw->wlc->wiphy, "wl%d: intstatus%d 0x%x\n",
+			unit, idx, intstatus);
 
 		if (intstatus & I_RO) {
 			wiphy_err(wiphy, "wl%d: fifo %d: receive fifo "
@@ -2913,7 +2913,8 @@ static inline u32 wlc_intstatus(struct wlc_info *wlc, bool in_isr)
 	/* macintstatus includes a DMA interrupt summary bit */
 	macintstatus = R_REG(&regs->macintstatus);
 
-	WL_TRACE("wl%d: macintstatus: 0x%x\n", wlc_hw->unit, macintstatus);
+	BCMMSG(wlc->wiphy, "wl%d: macintstatus: 0x%x\n", wlc_hw->unit,
+		 macintstatus);
 
 	/* detect cardbus removed, in power down(suspend) and in reset */
 	if (DEVICEREMOVED(wlc))
@@ -3047,7 +3048,7 @@ wlc_bmac_txstatus(struct wlc_hw_info *wlc_hw, bool bound, bool *fatal)
 	 */
 	uint max_tx_num = bound ? wlc->pub->tunables->txsbnd : -1;
 
-	WL_TRACE("wl%d: wlc_bmac_txstatus\n", wlc_hw->unit);
+	BCMMSG(wlc->wiphy, "wl%d\n", wlc_hw->unit);
 
 	txs = &txstatus;
 	regs = wlc_hw->regs;
@@ -3094,8 +3095,8 @@ void wlc_suspend_mac_and_wait(struct wlc_info *wlc)
 	u32 mc, mi;
 	struct wiphy *wiphy = wlc->wiphy;
 
-	WL_TRACE("wl%d: wlc_suspend_mac_and_wait: bandunit %d\n",
-		 wlc_hw->unit, wlc_hw->band->bandunit);
+	BCMMSG(wlc->wiphy, "wl%d: bandunit %d\n", wlc_hw->unit,
+		wlc_hw->band->bandunit);
 
 	/*
 	 * Track overlapping suspend requests
@@ -3162,8 +3163,8 @@ void wlc_enable_mac(struct wlc_info *wlc)
 	d11regs_t *regs = wlc_hw->regs;
 	u32 mc, mi;
 
-	WL_TRACE("wl%d: wlc_enable_mac: bandunit %d\n",
-		 wlc_hw->unit, wlc->band->bandunit);
+	BCMMSG(wlc->wiphy, "wl%d: bandunit %d\n", wlc_hw->unit,
+		wlc->band->bandunit);
 
 	/*
 	 * Track overlapping suspend requests
@@ -3285,7 +3286,7 @@ static bool wlc_bmac_validate_chip_access(struct wlc_hw_info *wlc_hw)
 	u32 w, val;
 	struct wiphy *wiphy = wlc_hw->wlc->wiphy;
 
-	WL_TRACE("wl%d: validate_chip_access\n", wlc_hw->unit);
+	BCMMSG(wiphy, "wl%d\n", wlc_hw->unit);
 
 	regs = wlc_hw->regs;
 
@@ -3349,7 +3350,7 @@ void wlc_bmac_core_phypll_ctl(struct wlc_hw_info *wlc_hw, bool on)
 	d11regs_t *regs;
 	u32 tmp;
 
-	WL_TRACE("wl%d: wlc_bmac_core_phypll_ctl\n", wlc_hw->unit);
+	BCMMSG(wlc_hw->wlc->wiphy, "wl%d\n", wlc_hw->unit);
 
 	tmp = 0;
 	regs = wlc_hw->regs;
@@ -3400,7 +3401,7 @@ void wlc_coredisable(struct wlc_hw_info *wlc_hw)
 {
 	bool dev_gone;
 
-	WL_TRACE("wl%d: %s\n", wlc_hw->unit, __func__);
+	BCMMSG(wlc_hw->wlc->wiphy, "wl%d\n", wlc_hw->unit);
 
 	dev_gone = DEVICEREMOVED(wlc_hw->wlc);
 
@@ -3436,7 +3437,7 @@ void wlc_coredisable(struct wlc_hw_info *wlc_hw)
 /* power both the pll and external oscillator on/off */
 static void wlc_bmac_xtal(struct wlc_hw_info *wlc_hw, bool want)
 {
-	WL_TRACE("wl%d: wlc_bmac_xtal: want %d\n", wlc_hw->unit, want);
+	BCMMSG(wlc_hw->wlc->wiphy, "wl%d: want %d\n", wlc_hw->unit, want);
 
 	/* dont power down if plldown is false or we must poll hw radio disable */
 	if (!want && wlc_hw->pllreq)
@@ -3465,8 +3466,7 @@ static void wlc_flushqueues(struct wlc_info *wlc)
 		if (wlc_hw->di[i]) {
 			dma_txreclaim(wlc_hw->di[i], HNDDMA_RANGE_ALL);
 			TXPKTPENDCLR(wlc, i);
-			WL_TRACE("wlc_flushqueues: pktpend fifo %d cleared\n",
-				 i);
+			BCMMSG(wlc->wiphy, "pktpend fifo %d clrd\n", i);
 		}
 
 	/* free any posted rx packets */
@@ -3581,8 +3581,8 @@ wlc_bmac_copyfrom_objmem(struct wlc_hw_info *wlc_hw, uint offset, void *buf,
 
 void wlc_bmac_copyfrom_vars(struct wlc_hw_info *wlc_hw, char **buf, uint *len)
 {
-	WL_TRACE("wlc_bmac_copyfrom_vars, nvram vars totlen=%d\n",
-		 wlc_hw->vars_size);
+	BCMMSG(wlc_hw->wlc->wiphy, "nvram vars totlen=%d\n",
+		wlc_hw->vars_size);
 
 	*buf = wlc_hw->vars;
 	*len = wlc_hw->vars_size;
diff --git a/drivers/staging/brcm80211/brcmsmac/wlc_channel.c b/drivers/staging/brcm80211/brcmsmac/wlc_channel.c
index 40d94b6..bde82bd 100644
--- a/drivers/staging/brcm80211/brcmsmac/wlc_channel.c
+++ b/drivers/staging/brcm80211/brcmsmac/wlc_channel.c
@@ -631,7 +631,7 @@ wlc_cm_info_t *wlc_channel_mgr_attach(struct wlc_info *wlc)
 	struct wlc_pub *pub = wlc->pub;
 	char *ccode;
 
-	WL_TRACE("wl%d: wlc_channel_mgr_attach\n", wlc->pub->unit);
+	BCMMSG(wlc->wiphy, "wl%d\n", wlc->pub->unit);
 
 	wlc_cm = kzalloc(sizeof(wlc_cm_info_t), GFP_ATOMIC);
 	if (wlc_cm == NULL) {
diff --git a/drivers/staging/brcm80211/brcmsmac/wlc_main.c b/drivers/staging/brcm80211/brcmsmac/wlc_main.c
index a790cb6..f0dd21e 100644
--- a/drivers/staging/brcm80211/brcmsmac/wlc_main.c
+++ b/drivers/staging/brcm80211/brcmsmac/wlc_main.c
@@ -331,7 +331,7 @@ void wlc_get_rcmta(struct wlc_info *wlc, int idx, u8 *addr)
 	d11regs_t *regs = wlc->regs;
 	u32 v32;
 
-	WL_TRACE("wl%d: %s\n", WLCWLUNIT(wlc), __func__);
+	BCMMSG(wlc->wiphy, "wl%d\n", WLCWLUNIT(wlc));
 
 	W_REG(&regs->objaddr, (OBJADDR_RCMTA_SEL | (idx * 2)));
 	(void)R_REG(&regs->objaddr);
@@ -385,7 +385,7 @@ bool wlc_ps_allowed(struct wlc_info *wlc)
 
 void wlc_reset(struct wlc_info *wlc)
 {
-	WL_TRACE("wl%d: wlc_reset\n", wlc->pub->unit);
+	BCMMSG(wlc->wiphy, "wl%d\n", wlc->pub->unit);
 
 	wlc->check_for_unaligned_tbtt = false;
 
@@ -441,7 +441,7 @@ void wlc_init(struct wlc_info *wlc)
 	struct wlc_bsscfg *bsscfg;
 	bool mute = false;
 
-	WL_TRACE("wl%d: wlc_init\n", wlc->pub->unit);
+	BCMMSG(wlc->wiphy, "wl%d\n", wlc->pub->unit);
 
 	regs = wlc->regs;
 
@@ -613,7 +613,7 @@ void wlc_set_ps_ctrl(struct wlc_info *wlc)
 	hps = PS_ALLOWED(wlc);
 	wake = hps ? (STAY_AWAKE(wlc)) : true;
 
-	WL_TRACE("wl%d: wlc_set_ps_ctrl: hps %d wake %d\n",
+	BCMMSG(wlc->wiphy, "wl%d: hps %d wake %d\n",
 		 wlc->pub->unit, hps, wake);
 
 	v1 = R_REG(&wlc->regs->maccontrol);
@@ -1085,7 +1085,7 @@ void wlc_beacon_phytxctl_txant_upd(struct wlc_info *wlc, ratespec_t bcn_rspec)
 */
 void wlc_protection_upd(struct wlc_info *wlc, uint idx, int val)
 {
-	WL_TRACE("wlc_protection_upd: idx %d, val %d\n", idx, val);
+	BCMMSG(wlc->wiphy, "idx %d, val %d\n", idx, val);
 
 	switch (idx) {
 	case WLC_PROT_G_SPEC:
@@ -1195,7 +1195,7 @@ static void wlc_bandinit_ordered(struct wlc_info *wlc, chanspec_t chanspec)
 	uint parkband;
 	uint i, band_order[2];
 
-	WL_TRACE("wl%d: wlc_bandinit_ordered\n", wlc->pub->unit);
+	BCMMSG(wlc->wiphy, "wl%d\n", wlc->pub->unit);
 	/*
 	 * We might have been bandlocked during down and the chip power-cycled (hibernate).
 	 * figure out the right band to park on
@@ -1236,7 +1236,7 @@ static void wlc_bandinit_ordered(struct wlc_info *wlc, chanspec_t chanspec)
 /* band-specific init */
 static void WLBANDINITFN(wlc_bsinit) (struct wlc_info *wlc)
 {
-	WL_TRACE("wl%d: wlc_bsinit: bandunit %d\n",
+	BCMMSG(wlc->wiphy, "wl%d: bandunit %d\n",
 		 wlc->pub->unit, wlc->band->bandunit);
 
 	/* write ucode ACK/CTS rate table */
@@ -1993,7 +1993,7 @@ uint wlc_detach(struct wlc_info *wlc)
 	if (wlc == NULL)
 		return 0;
 
-	WL_TRACE("wl%d: %s\n", wlc->pub->unit, __func__);
+	BCMMSG(wlc->wiphy, "wl%d\n", wlc->pub->unit);
 
 	callbacks += wlc_bmac_detach(wlc);
 
@@ -2263,7 +2263,7 @@ static void wlc_watchdog(void *arg)
 	int i;
 	struct wlc_bsscfg *cfg;
 
-	WL_TRACE("wl%d: wlc_watchdog\n", wlc->pub->unit);
+	BCMMSG(wlc->wiphy, "wl%d\n", wlc->pub->unit);
 
 	if (!wlc->pub->up)
 		return;
@@ -2331,7 +2331,7 @@ static void wlc_watchdog(void *arg)
 /* make interface operational */
 int wlc_up(struct wlc_info *wlc)
 {
-	WL_TRACE("wl%d: %s:\n", wlc->pub->unit, __func__);
+	BCMMSG(wlc->wiphy, "wl%d\n", wlc->pub->unit);
 
 	/* HW is turned off so don't try to access it */
 	if (wlc->pub->hw_off || DEVICEREMOVED(wlc))
@@ -2477,7 +2477,7 @@ uint wlc_down(struct wlc_info *wlc)
 	bool dev_gone = false;
 	struct wlc_txq_info *qi;
 
-	WL_TRACE("wl%d: %s:\n", wlc->pub->unit, __func__);
+	BCMMSG(wlc->wiphy, "wl%d\n", wlc->pub->unit);
 
 	/* check if we are already in the going down path */
 	if (wlc->going_down) {
@@ -4271,7 +4271,7 @@ wlc_doiovar(void *hdl, const bcm_iovar_t *vi, u32 actionid,
 	bool bool_val2;
 	wlc_bss_info_t *current_bss;
 
-	WL_TRACE("wl%d: %s\n", wlc->pub->unit, __func__);
+	BCMMSG(wlc->wiphy, "wl%d\n", wlc->pub->unit);
 
 	bsscfg = NULL;
 	current_bss = NULL;
@@ -4295,8 +4295,7 @@ wlc_doiovar(void *hdl, const bcm_iovar_t *vi, u32 actionid,
 	bool_val = (int_val != 0) ? true : false;
 	bool_val2 = (int_val2 != 0) ? true : false;
 
-	WL_TRACE("wl%d: %s: id %d\n",
-		 wlc->pub->unit, __func__, IOV_ID(actionid));
+	BCMMSG(wlc->wiphy, "wl%d: id %d\n", wlc->pub->unit, IOV_ID(actionid));
 	/* Do the actual parameter implementation */
 	switch (actionid) {
 	case IOV_SVAL(IOV_RTSTHRESH):
@@ -5053,7 +5052,7 @@ wlc_txfifo(struct wlc_info *wlc, uint fifo, struct sk_buff *p, bool commit,
 	 */
 	if (commit) {
 		TXPKTPENDINC(wlc, fifo, txpktpend);
-		WL_TRACE("wlc_txfifo, pktpend inc %d to %d\n",
+		BCMMSG(wlc->wiphy, "pktpend inc %d to %d\n",
 			 txpktpend, TXPKTPENDGET(wlc, fifo));
 	}
 
@@ -6130,7 +6129,7 @@ void wlc_high_dpc(struct wlc_info *wlc, u32 macintstatus)
 	if (macintstatus & ~(MI_TBTT | MI_TXSTOP)) {
 		bcm_format_flags(int_flags, macintstatus, flagstr,
 				 sizeof(flagstr));
-		WL_TRACE("wl%d: macintstatus 0x%x %s\n",
+		BCMMSG(wlc->wiphy, "wl%d: macintstatus 0x%x %s\n",
 			 wlc->pub->unit, macintstatus, flagstr);
 	}
 #endif				/* BCMDBG */
@@ -6362,8 +6361,8 @@ void BCMFASTPATH
 wlc_txfifo_complete(struct wlc_info *wlc, uint fifo, s8 txpktpend)
 {
 	TXPKTPENDDEC(wlc, fifo, txpktpend);
-	WL_TRACE("wlc_txfifo_complete, pktpend dec %d to %d\n",
-		 txpktpend, TXPKTPENDGET(wlc, fifo));
+	BCMMSG(wlc->wiphy, "pktpend dec %d to %d\n", txpktpend,
+		TXPKTPENDGET(wlc, fifo));
 
 	/* There is more room; mark precedences related to this FIFO sendable */
 	WLC_TX_FIFO_ENAB(wlc, fifo);
@@ -6673,7 +6672,7 @@ void BCMFASTPATH wlc_recv(struct wlc_info *wlc, struct sk_buff *p)
 	uint len;
 	bool is_amsdu;
 
-	WL_TRACE("wl%d: wlc_recv\n", wlc->pub->unit);
+	BCMMSG(wlc->wiphy, "wl%d\n", wlc->pub->unit);
 
 	/* frame starts with rxhdr */
 	rxh = (d11rxhdr_t *) (p->data);
@@ -6771,7 +6770,7 @@ wlc_calc_lsig_len(struct wlc_info *wlc, ratespec_t ratespec, uint mac_len)
 {
 	uint nsyms, len = 0, kNdps;
 
-	WL_TRACE("wl%d: wlc_calc_lsig_len: rate %d, len%d\n",
+	BCMMSG(wlc->wiphy, "wl%d: rate %d, len%d\n",
 		 wlc->pub->unit, RSPEC2RATE(ratespec), mac_len);
 
 	if (IS_MCS(ratespec)) {
@@ -6819,7 +6818,7 @@ wlc_calc_frame_time(struct wlc_info *wlc, ratespec_t ratespec, u8 preamble_type,
 		rate = WLC_RATE_1M;
 	}
 
-	WL_TRACE("wl%d: wlc_calc_frame_time: rspec 0x%x, preamble_type %d, len%d\n",
+	BCMMSG(wlc->wiphy, "wl%d: rspec 0x%x, preamble_type %d, len%d\n",
 		 wlc->pub->unit, ratespec, preamble_type, mac_len);
 
 	if (IS_MCS(ratespec)) {
@@ -6882,7 +6881,7 @@ wlc_calc_frame_len(struct wlc_info *wlc, ratespec_t ratespec, u8 preamble_type,
 	uint nsyms, mac_len, Ndps, kNdps;
 	uint rate = RSPEC2RATE(ratespec);
 
-	WL_TRACE("wl%d: wlc_calc_frame_len: rspec 0x%x, preamble_type %d, dur %d\n",
+	BCMMSG(wlc->wiphy, "wl%d: rspec 0x%x, preamble_type %d, dur %d\n",
 		 wlc->pub->unit, ratespec, preamble_type, dur);
 
 	if (IS_MCS(ratespec)) {
@@ -6924,8 +6923,8 @@ wlc_calc_frame_len(struct wlc_info *wlc, ratespec_t ratespec, u8 preamble_type,
 static uint
 wlc_calc_ba_time(struct wlc_info *wlc, ratespec_t rspec, u8 preamble_type)
 {
-	WL_TRACE("wl%d: wlc_calc_ba_time: rspec 0x%x, preamble_type %d\n",
-		 wlc->pub->unit, rspec, preamble_type);
+	BCMMSG(wlc->wiphy, "wl%d: rspec 0x%x, "
+		 "preamble_type %d\n", wlc->pub->unit, rspec, preamble_type);
 	/* Spec 9.6: ack rate is the highest rate in BSSBasicRateSet that is less than
 	 * or equal to the rate of the immediately previous frame in the FES
 	 */
@@ -6941,8 +6940,8 @@ wlc_calc_ack_time(struct wlc_info *wlc, ratespec_t rspec, u8 preamble_type)
 {
 	uint dur = 0;
 
-	WL_TRACE("wl%d: wlc_calc_ack_time: rspec 0x%x, preamble_type %d\n",
-		 wlc->pub->unit, rspec, preamble_type);
+	BCMMSG(wlc->wiphy, "wl%d: rspec 0x%x, preamble_type %d\n",
+		wlc->pub->unit, rspec, preamble_type);
 	/* Spec 9.6: ack rate is the highest rate in BSSBasicRateSet that is less than
 	 * or equal to the rate of the immediately previous frame in the FES
 	 */
@@ -6957,8 +6956,8 @@ wlc_calc_ack_time(struct wlc_info *wlc, ratespec_t rspec, u8 preamble_type)
 static uint
 wlc_calc_cts_time(struct wlc_info *wlc, ratespec_t rspec, u8 preamble_type)
 {
-	WL_TRACE("wl%d: wlc_calc_cts_time: ratespec 0x%x, preamble_type %d\n",
-		 wlc->pub->unit, rspec, preamble_type);
+	BCMMSG(wlc->wiphy, "wl%d: ratespec 0x%x, preamble_type %d\n",
+		wlc->pub->unit, rspec, preamble_type);
 	return wlc_calc_ack_time(wlc, rspec, preamble_type);
 }
 
@@ -7659,8 +7658,9 @@ mac80211_wlc_set_nrate(struct wlc_info *wlc, struct wlcband *cur_band,
 		} else if (rate > HIGHEST_SINGLE_STREAM_MCS) {
 			/* mcs > 7 must use stf SDM */
 			if (stf != PHY_TXC1_MODE_SDM) {
-				WL_TRACE("wl%d: %s: enabling SDM mode for mcs %d\n",
-					 WLCWLUNIT(wlc), __func__, rate);
+				BCMMSG(wlc->wiphy, "wl%d: enabling "
+					 "SDM mode for mcs %d\n",
+					 WLCWLUNIT(wlc), rate);
 				stf = PHY_TXC1_MODE_SDM;
 			}
 		} else {
@@ -7931,7 +7931,7 @@ void wlc_txflowcontrol(struct wlc_info *wlc, struct wlc_txq_info *qi,
 	uint prio_bits;
 	uint cur_bits;
 
-	WL_TRACE("%s: flow control kicks in\n", __func__);
+	BCMMSG(wlc->wiphy, "flow control kicks in\n");
 
 	if (prio == ALLPRIO) {
 		prio_bits = TXQ_STOP_FOR_PRIOFC_MASK;
diff --git a/drivers/staging/brcm80211/brcmsmac/wlc_stf.c b/drivers/staging/brcm80211/brcmsmac/wlc_stf.c
index bbf8442..aa8d42d 100644
--- a/drivers/staging/brcm80211/brcmsmac/wlc_stf.c
+++ b/drivers/staging/brcm80211/brcmsmac/wlc_stf.c
@@ -190,8 +190,8 @@ bool wlc_stf_stbc_rx_set(struct wlc_info *wlc, s32 int_val)
 
 static int wlc_stf_txcore_set(struct wlc_info *wlc, u8 Nsts, u8 core_mask)
 {
-	WL_TRACE("wl%d: %s: Nsts %d core_mask %x\n",
-		 wlc->pub->unit, __func__, Nsts, core_mask);
+	BCMMSG(wlc->wiphy, "wl%d: Nsts %d core_mask %x\n",
+		 wlc->pub->unit, Nsts, core_mask);
 
 	if (WLC_BITSCNT(core_mask) > wlc->stf->txstreams) {
 		core_mask = 0;
@@ -226,7 +226,7 @@ static int wlc_stf_spatial_policy_set(struct wlc_info *wlc, int val)
 	int i;
 	u8 core_mask = 0;
 
-	WL_TRACE("wl%d: %s: val %x\n", wlc->pub->unit, __func__, val);
+	BCMMSG(wlc->wiphy, "wl%d: val %x\n", wlc->pub->unit, val);
 
 	wlc->stf->spatial_policy = (s8) val;
 	for (i = 1; i <= MAX_STREAMS_SUPPORTED; i++) {
-- 
1.7.4.1


