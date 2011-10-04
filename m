Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mms3.broadcom.com ([216.31.210.19]:2415 "EHLO MMS3.broadcom.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932867Ab1JDVTi (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 4 Oct 2011 17:19:38 -0400
From: "Arend van Spriel" <arend@broadcom.com>
To: gregkh@suse.de
cc: devel@linuxdriverproject.org, linux-wireless@vger.kernel.org,
	"Alwin Beukers" <alwin@broadcom.com>,
	"Arend van Spriel" <arend@broadcom.com>
Subject: [PATCH 21/26] staging: brcm80211: removed synchronisation of
 wlc->machwcap field
Date: Tue, 4 Oct 2011 23:19:07 +0200
Message-ID: <1317763152-17607-22-git-send-email-arend@broadcom.com> (sfid-20111004_232002_917767_5AFC6023)
In-Reply-To: <1317763152-17607-1-git-send-email-arend@broadcom.com>
References: <1317763152-17607-1-git-send-email-arend@broadcom.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Alwin Beukers <alwin@broadcom.com>

- removed copying field wlc->machwcap from brcms_hardware to brcms_c_info
  during module attach.
- field wlc->machwcap was written but never read. Therefore it was removed.

Reviewed-by: Pieter-Paul Giesberts <pieterpg@broadcom.com>
Reviewed-by: Roland Vossen <rvossen@broadcom.com>
Reviewed-by: Arend van Spriel <arend@broadcom.com>
Signed-off-by: Arend van Spriel <arend@broadcom.com>
---
 drivers/staging/brcm80211/brcmsmac/main.c |   39 +----------------------------
 drivers/staging/brcm80211/brcmsmac/main.h |    2 -
 2 files changed, 1 insertions(+), 40 deletions(-)

diff --git a/drivers/staging/brcm80211/brcmsmac/main.c b/drivers/staging/brcm80211/brcmsmac/main.c
index 175d85e..0656d99 100644
--- a/drivers/staging/brcm80211/brcmsmac/main.c
+++ b/drivers/staging/brcm80211/brcmsmac/main.c
@@ -390,13 +390,6 @@ static int brcms_chspec_bw(u16 chanspec)
 	return BRCMS_10_MHZ;
 }
 
-/* dup state between BMAC(struct brcms_hardware) and HIGH(struct brcms_c_info)
-   driver */
-struct brcms_b_state {
-	u32 machwcap;	/* mac hw capibility */
-	u32 preamble_ovr;	/* preamble override */
-};
-
 struct edcf_acparam {
 	u8 ACI;
 	u8 ECW;
@@ -1168,14 +1161,6 @@ bool brcms_c_dpc(struct brcms_c_info *wlc, bool bounded)
 	return wlc->macintstatus != 0;
 }
 
-static int brcms_b_state_get(struct brcms_hardware *wlc_hw,
-		      struct brcms_b_state *state)
-{
-	state->machwcap = wlc_hw->machwcap;
-
-	return 0;
-}
-
 /* set initial host flags value */
 static void
 brcms_c_mhfdef(struct brcms_c_info *wlc, u16 *mhfs, u16 mhf2_init)
@@ -4534,20 +4519,6 @@ void brcms_c_info_init(struct brcms_c_info *wlc, int unit)
 	wlc->mpc_delay_off = wlc->mpc_dlycnt = BRCMS_MPC_MIN_DELAYCNT;
 }
 
-static bool brcms_c_state_bmac_sync(struct brcms_c_info *wlc)
-{
-	struct brcms_b_state state_bmac = {0};
-
-	if (brcms_b_state_get(wlc->hw, &state_bmac) != 0)
-		return false;
-
-	wlc->machwcap = state_bmac.machwcap;
-	brcms_c_protection_upd(wlc, BRCMS_PROT_N_PAM_OVR,
-			   (s8) state_bmac.preamble_ovr);
-
-	return true;
-}
-
 static uint brcms_c_attach_module(struct brcms_c_info *wlc)
 {
 	uint err = 0;
@@ -5151,15 +5122,7 @@ brcms_c_attach(struct brcms_info *wl, u16 vendor, u16 device, uint unit,
 	if (err)
 		goto fail;
 
-	/*
-	 * for some states, due to different info pointer(e,g, wlc, wlc_hw) or
-	 * master/slave split, HIGH driver(both monolithic and HIGH_ONLY) needs
-	 * to sync states FROM BMAC portion driver
-	 */
-	if (!brcms_c_state_bmac_sync(wlc)) {
-		err = 20;
-		goto fail;
-	}
+	brcms_c_protection_upd(wlc, BRCMS_PROT_N_PAM_OVR, OFF);
 
 	pub->phy_11ncapable = BRCMS_PHY_11N_CAP(wlc->band);
 
diff --git a/drivers/staging/brcm80211/brcmsmac/main.h b/drivers/staging/brcm80211/brcmsmac/main.h
index 99d5c60..441292a 100644
--- a/drivers/staging/brcm80211/brcmsmac/main.h
+++ b/drivers/staging/brcm80211/brcmsmac/main.h
@@ -519,8 +519,6 @@ struct brcms_c_info {
 	u16 deviceid;
 	uint ucode_rev;
 
-	u32 machwcap;
-
 	u8 perm_etheraddr[ETH_ALEN];
 
 	bool bandlocked;
-- 
1.7.4.1


