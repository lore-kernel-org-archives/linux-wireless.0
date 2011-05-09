Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mms3.broadcom.com ([216.31.210.19]:3450 "EHLO MMS3.broadcom.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754129Ab1EIOdn (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 9 May 2011 10:33:43 -0400
From: "Arend van Spriel" <arend@broadcom.com>
To: gregkh@suse.de
cc: "Arend van Spriel" <arend@broadcom.com>,
	devel@linuxdriverproject.org, linux-wireless@vger.kernel.org
Subject: [PATCH 06/10] staging: brcm80211: use int_sqrt kernel function
 iso driver implementation
Date: Mon, 9 May 2011 16:33:25 +0200
Message-ID: <1304951609-2493-6-git-send-email-arend@broadcom.com> (sfid-20110509_163742_296526_9001AB46)
In-Reply-To: <1304951609-2493-1-git-send-email-arend@broadcom.com>
References: <1304951609-2493-1-git-send-email-arend@broadcom.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

The driver code had its own implementation for fixed point square root
calculation, but such a function is already available in the linux
kernel so the driver implementation has been removed using the kernel
function.

Cc: devel@linuxdriverproject.org
Cc: linux-wireless@vger.kernel.org
Reviewed-by: Roland Vossen <rvossen@broadcoom.com>
Reviewed-by: Henry Ptasinski <henryp@broadcom.com>
Reviewed-by: Brett Rudley <brudley@broadcom.com>
Signed-off-by: Arend van Spriel <arend@broadcom.com>
---
 .../staging/brcm80211/brcmsmac/phy/wlc_phy_cmn.c   |   19 -------------------
 .../staging/brcm80211/brcmsmac/phy/wlc_phy_int.h   |    1 -
 .../staging/brcm80211/brcmsmac/phy/wlc_phy_lcn.c   |    2 +-
 drivers/staging/brcm80211/brcmsmac/phy/wlc_phy_n.c |    2 +-
 4 files changed, 2 insertions(+), 22 deletions(-)

diff --git a/drivers/staging/brcm80211/brcmsmac/phy/wlc_phy_cmn.c b/drivers/staging/brcm80211/brcmsmac/phy/wlc_phy_cmn.c
index f35a18c..446dc84 100644
--- a/drivers/staging/brcm80211/brcmsmac/phy/wlc_phy_cmn.c
+++ b/drivers/staging/brcm80211/brcmsmac/phy/wlc_phy_cmn.c
@@ -3117,25 +3117,6 @@ u8 wlc_phy_nbits(s32 value)
 	return nbits;
 }
 
-u32 wlc_phy_sqrt_int(u32 value)
-{
-	u32 root = 0, shift = 0;
-
-	for (shift = 0; shift < 32; shift += 2) {
-		if (((0x40000000 >> shift) + root) <= value) {
-			value -= ((0x40000000 >> shift) + root);
-			root = (root >> 1) | (0x40000000 >> shift);
-		} else {
-			root = root >> 1;
-		}
-	}
-
-	if (root < value)
-		++root;
-
-	return root;
-}
-
 void wlc_phy_stf_chain_init(wlc_phy_t *pih, u8 txchain, u8 rxchain)
 {
 	phy_info_t *pi = (phy_info_t *) pih;
diff --git a/drivers/staging/brcm80211/brcmsmac/phy/wlc_phy_int.h b/drivers/staging/brcm80211/brcmsmac/phy/wlc_phy_int.h
index 77c6106..10cbf52 100644
--- a/drivers/staging/brcm80211/brcmsmac/phy/wlc_phy_int.h
+++ b/drivers/staging/brcm80211/brcmsmac/phy/wlc_phy_int.h
@@ -1025,7 +1025,6 @@ extern void wlc_phy_txpower_update_shm(phy_info_t *pi);
 
 extern void wlc_phy_cordic(fixed theta, cs32 *val);
 extern u8 wlc_phy_nbits(s32 value);
-extern u32 wlc_phy_sqrt_int(u32 value);
 extern void wlc_phy_compute_dB(u32 *cmplx_pwr, s8 *p_dB, u8 core);
 
 extern uint wlc_phy_init_radio_regs_allbands(phy_info_t *pi,
diff --git a/drivers/staging/brcm80211/brcmsmac/phy/wlc_phy_lcn.c b/drivers/staging/brcm80211/brcmsmac/phy/wlc_phy_lcn.c
index a28633c..b8864c5 100644
--- a/drivers/staging/brcm80211/brcmsmac/phy/wlc_phy_lcn.c
+++ b/drivers/staging/brcm80211/brcmsmac/phy/wlc_phy_lcn.c
@@ -3244,7 +3244,7 @@ static bool wlc_lcnphy_calc_rx_iq_comp(phy_info_t *pi, u16 num_samps)
 	}
 	b /= temp;
 	b -= a * a;
-	b = (s32) wlc_phy_sqrt_int((u32) b);
+	b = (s32) int_sqrt((unsigned long) b);
 	b -= (1 << 10);
 	a0_new = (u16) (a & 0x3ff);
 	b0_new = (u16) (b & 0x3ff);
diff --git a/drivers/staging/brcm80211/brcmsmac/phy/wlc_phy_n.c b/drivers/staging/brcm80211/brcmsmac/phy/wlc_phy_n.c
index a099f7f..7127509 100644
--- a/drivers/staging/brcm80211/brcmsmac/phy/wlc_phy_n.c
+++ b/drivers/staging/brcm80211/brcmsmac/phy/wlc_phy_n.c
@@ -24608,7 +24608,7 @@ static void wlc_phy_calc_rx_iq_comp_nphy(phy_info_t *pi, u8 core_mask)
 		}
 		b /= temp;
 		b -= a * a;
-		b = (s32) wlc_phy_sqrt_int((u32) b);
+		b = (s32) int_sqrt((unsigned long) b);
 		b -= (1 << 10);
 
 		if ((curr_core == PHY_CORE_0) && (core_mask & 0x1)) {
-- 
1.7.4.1


