Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mms1.broadcom.com ([216.31.210.17]:2289 "EHLO mms1.broadcom.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752263Ab1ECJgX (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 3 May 2011 05:36:23 -0400
From: "Arend van Spriel" <arend@broadcom.com>
To: gregkh@suse.de
cc: devel@linuxdriverproject.org, linux-wireless@vger.kernel.org,
	"Brett Rudley" <brudley@broadcom.com>,
	"Henry Ptasinski" <henryp@broadcom.com>,
	"Roland Vossen" <rvossen@broadcom.com>
Subject: [PATCH 44/61] staging: brcm80211: cleanup definitions in
 aiutils header file
Date: Tue, 3 May 2011 11:35:44 +0200
Message-ID: <1304415361-7813-45-git-send-email-arend@broadcom.com> (sfid-20110503_114020_245921_1DC7740A)
In-Reply-To: <1304415361-7813-1-git-send-email-arend@broadcom.com>
References: <1304415361-7813-1-git-send-email-arend@broadcom.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

The aiutils header file contained a few prototypes that are not
defined in the source file so these are removed.

Cc: devel@linuxdriverproject.org
Cc: linux-wireless@vger.kernel.org
Cc: Brett Rudley <brudley@broadcom.com>
Cc: Henry Ptasinski <henryp@broadcom.com>
Cc: Roland Vossen <rvossen@broadcom.com>
Signed-off-by: Arend van Spriel <arend@broadcom.com>
---
 drivers/staging/brcm80211/include/aiutils.h |   17 -----------------
 1 files changed, 0 insertions(+), 17 deletions(-)

diff --git a/drivers/staging/brcm80211/include/aiutils.h b/drivers/staging/brcm80211/include/aiutils.h
index 3b7235c..c10d8f4 100644
--- a/drivers/staging/brcm80211/include/aiutils.h
+++ b/drivers/staging/brcm80211/include/aiutils.h
@@ -455,11 +455,6 @@ typedef struct si_info {
 } si_info_t;
 
 /* AMBA Interconnect exported externs */
-#if 0
-extern si_t *ai_attach(uint pcidev, struct osl_info *osh, void *regs,
-		       uint bustype, void *sdh, char **vars, uint *varsz);
-extern si_t *ai_kattach(struct osl_info *osh);
-#endif
 extern void ai_scan(si_t *sih, void *regs, uint devid);
 
 extern uint ai_flag(si_t *sih);
@@ -489,9 +484,7 @@ extern void si_detach(si_t *sih);
 extern bool si_pci_war16165(si_t *sih);
 
 extern uint si_coreid(si_t *sih);
-extern uint si_flag(si_t *sih);
 extern uint si_corerev(si_t *sih);
-struct osl_info *si_osh(si_t *sih);
 extern uint si_corereg(si_t *sih, uint coreidx, uint regoff, uint mask,
 		uint val);
 extern void si_write_wrapperreg(si_t *sih, u32 offset, u32 val);
@@ -520,17 +513,9 @@ extern u16 si_clkctl_fast_pwrup_delay(si_t *sih);
 extern bool si_clkctl_cc(si_t *sih, uint mode);
 extern int si_clkctl_xtal(si_t *sih, uint what, bool on);
 extern bool si_deviceremoved(si_t *sih);
-extern u32 si_socram_size(si_t *sih);
-
-extern void si_watchdog(si_t *sih, uint ticks);
 extern u32 si_gpiocontrol(si_t *sih, u32 mask, u32 val,
 			     u8 priority);
 
-#define si_eci(sih) 0
-#define si_eci_init(sih) (0)
-#define si_eci_notify_bt(sih, type, val)  (0)
-#define si_seci(sih) 0
-
 /* OTP status */
 extern bool si_is_otp_disabled(si_t *sih);
 extern bool si_is_otp_powered(si_t *sih);
@@ -549,11 +534,9 @@ extern int si_devpath(si_t *sih, char *path, int size);
 extern char *si_getdevpathvar(si_t *sih, const char *name);
 extern int si_getdevpathintvar(si_t *sih, const char *name);
 
-extern void si_war42780_clkreq(si_t *sih, bool clkreq);
 extern void si_pci_sleep(si_t *sih);
 extern void si_pci_down(si_t *sih);
 extern void si_pci_up(si_t *sih);
-extern void si_pcie_extendL1timer(si_t *sih, bool extend);
 extern int si_pci_fixcfg(si_t *sih);
 
 extern void si_chipcontrl_epa4331(si_t *sih, bool on);
-- 
1.7.4.1


