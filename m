Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mms2.broadcom.com ([216.31.210.18]:4625 "EHLO mms2.broadcom.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933213Ab1JDVTi (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 4 Oct 2011 17:19:38 -0400
From: "Arend van Spriel" <arend@broadcom.com>
To: gregkh@suse.de
cc: devel@linuxdriverproject.org, linux-wireless@vger.kernel.org,
	"Alwin Beukers" <alwin@broadcom.com>,
	"Arend van Spriel" <arend@broadcom.com>
Subject: [PATCH 11/26] staging: brcm80211: removed accessor functions
 for band type and etheraddress.
Date: Tue, 4 Oct 2011 23:18:57 +0200
Message-ID: <1317763152-17607-12-git-send-email-arend@broadcom.com> (sfid-20111004_231955_033459_0B8EED76)
In-Reply-To: <1317763152-17607-1-git-send-email-arend@broadcom.com>
References: <1317763152-17607-1-git-send-email-arend@broadcom.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Alwin Beukers <alwin@broadcom.com>

Functions were trivial so not really adding value.

Reviewed-by: Pieter-Paul Giesberts <pieterpg@broadcom.com>
Reviewed-by: Roland Vossen <rvossen@broadcom.com>
Reviewed-by: Arend van Spriel <arend@broadcom.com>
Signed-off-by: Arend van Spriel <arend@broadcom.com>
---
 drivers/staging/brcm80211/brcmsmac/main.c |   21 +++++----------------
 1 files changed, 5 insertions(+), 16 deletions(-)

diff --git a/drivers/staging/brcm80211/brcmsmac/main.c b/drivers/staging/brcm80211/brcmsmac/main.c
index db05521..b6c4361 100644
--- a/drivers/staging/brcm80211/brcmsmac/main.c
+++ b/drivers/staging/brcm80211/brcmsmac/main.c
@@ -1369,16 +1369,6 @@ static void brcms_b_wait_for_wake(struct brcms_hardware *wlc_hw)
 		  DBGST_ASLEEP), wlc_hw->wlc->fastpwrup_dly);
 }
 
-static void brcms_b_hw_etheraddr(struct brcms_hardware *wlc_hw, u8 *ea)
-{
-	memcpy(ea, wlc_hw->etheraddr, ETH_ALEN);
-}
-
-static int brcms_b_bandtype(struct brcms_hardware *wlc_hw)
-{
-	return wlc_hw->band->bandtype;
-}
-
 /* control chip clock to save power, enable dynamic clock or force fast clock */
 static void brcms_b_clkctl_clk(struct brcms_hardware *wlc_hw, uint mode)
 {
@@ -3939,7 +3929,7 @@ static void brcms_b_set_shortslot(struct brcms_hardware *wlc_hw, bool shortslot)
 {
 	wlc_hw->shortslot = shortslot;
 
-	if (brcms_b_bandtype(wlc_hw) == BRCM_BAND_2G && wlc_hw->up) {
+	if (wlc_hw->band->bandtype == BRCM_BAND_2G && wlc_hw->up) {
 		brcms_c_suspend_mac_and_wait(wlc_hw->wlc);
 		brcms_b_update_slot_timing(wlc_hw, shortslot);
 		brcms_c_enable_mac(wlc_hw->wlc);
@@ -4854,8 +4844,8 @@ static int brcms_b_attach(struct brcms_c_info *wlc, u16 vendor, u16 device,
 		/* Get a phy for this band */
 		wlc_hw->band->pi =
 			wlc_phy_attach(wlc_hw->phy_sh, regs,
-				       brcms_b_bandtype(wlc_hw), vars,
-				       wlc->wiphy);
+					wlc_hw->band->bandtype, vars,
+					wlc->wiphy);
 		if (wlc_hw->band->pi == NULL) {
 			wiphy_err(wiphy, "wl%d: brcms_b_attach: wlc_phy_"
 				  "attach failed\n", unit);
@@ -5235,9 +5225,8 @@ brcms_c_attach(struct brcms_info *wl, u16 vendor, u16 device, uint unit,
 	for (i = 0; i < NFIFO; i++)
 		wlc->core->txavail[i] = wlc->hw->txavail[i];
 
-	brcms_b_hw_etheraddr(wlc->hw, wlc->perm_etheraddr);
-
-	memcpy(&pub->cur_etheraddr, &wlc->perm_etheraddr, ETH_ALEN);
+	memcpy(&wlc->perm_etheraddr, &wlc->hw->etheraddr, ETH_ALEN);
+	memcpy(&pub->cur_etheraddr, &wlc->hw->etheraddr, ETH_ALEN);
 
 	for (j = 0; j < wlc->pub->_nbands; j++) {
 		wlc->band = wlc->bandstate[j];
-- 
1.7.4.1


