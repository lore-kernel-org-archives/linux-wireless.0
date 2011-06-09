Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mms2.broadcom.com ([216.31.210.18]:2043 "EHLO mms2.broadcom.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752904Ab1FIOp2 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 9 Jun 2011 10:45:28 -0400
From: "Roland Vossen" <rvossen@broadcom.com>
To: gregkh@suse.de
cc: devel@linuxdriverproject.org, linux-wireless@vger.kernel.org
Subject: [PATCH 08/21] staging: brcm80211: remove device id parameter
 from ai_attach()
Date: Thu, 9 Jun 2011 16:44:48 +0200
Message-ID: <1307630701-9170-9-git-send-email-rvossen@broadcom.com> (sfid-20110609_164535_452699_85A54E93)
In-Reply-To: <1307630701-9170-1-git-send-email-rvossen@broadcom.com>
References: <1307630701-9170-1-git-send-email-rvossen@broadcom.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Arend van Spriel <arend@broadcom.com>

The device id is passed to ai_attach() and subsequent functions
without actually being used. It can be removed.

Signed-off-by: Arend van Spriel <arend@broadcom.com>
Reviewed-by: Roland Vossen <rvossen@broadcom.com>
Reviewed-by: Franky Lin <frankyl@broadcom.com>
---
 drivers/staging/brcm80211/brcmsmac/aiutils.c |   20 +++++++++-----------
 drivers/staging/brcm80211/brcmsmac/aiutils.h |    4 ++--
 drivers/staging/brcm80211/brcmsmac/bmac.c    |    2 +-
 3 files changed, 12 insertions(+), 14 deletions(-)

diff --git a/drivers/staging/brcm80211/brcmsmac/aiutils.c b/drivers/staging/brcm80211/brcmsmac/aiutils.c
index 7907b15..82809cb 100644
--- a/drivers/staging/brcm80211/brcmsmac/aiutils.c
+++ b/drivers/staging/brcm80211/brcmsmac/aiutils.c
@@ -434,7 +434,7 @@ static void ai_hwfixup(si_info_t *sii)
 }
 
 /* parse the enumeration rom to identify all cores */
-void ai_scan(struct si_pub *sih, void *regs, uint devid)
+void ai_scan(struct si_pub *sih, void *regs)
 {
 	si_info_t *sii = SI_INFO(sih);
 	chipcregs_t *cc = (chipcregs_t *) regs;
@@ -850,11 +850,10 @@ u32 ai_core_sflags(struct si_pub *sih, u32 mask, u32 val)
 
 /* *************** from siutils.c ************** */
 /* local prototypes */
-static si_info_t *ai_doattach(si_info_t *sii, uint devid, void *regs,
+static si_info_t *ai_doattach(si_info_t *sii, void *regs,
 			      uint bustype, void *sdh, char **vars,
 			      uint *varsz);
-static bool ai_buscore_prep(si_info_t *sii, uint bustype, uint devid,
-			    void *sdh);
+static bool ai_buscore_prep(si_info_t *sii, uint bustype);
 static bool ai_buscore_setup(si_info_t *sii, chipcregs_t *cc, uint bustype,
 			     u32 savewin, uint *origidx, void *regs);
 static void ai_nvram_process(si_info_t *sii, char *pvars);
@@ -877,7 +876,7 @@ static u32 ai_gpioreservation;
  * vars - pointer to a pointer area for "environment" variables
  * varsz - pointer to int to return the size of the vars
  */
-struct si_pub *ai_attach(uint devid, void *regs, uint bustype,
+struct si_pub *ai_attach(void *regs, uint bustype,
 		void *sdh, char **vars, uint *varsz)
 {
 	si_info_t *sii;
@@ -889,7 +888,7 @@ struct si_pub *ai_attach(uint devid, void *regs, uint bustype,
 		return NULL;
 	}
 
-	if (ai_doattach(sii, devid, regs, bustype, sdh, vars, varsz) ==
+	if (ai_doattach(sii, regs, bustype, sdh, vars, varsz) ==
 	    NULL) {
 		kfree(sii);
 		return NULL;
@@ -903,8 +902,7 @@ struct si_pub *ai_attach(uint devid, void *regs, uint bustype,
 /* global kernel resource */
 static si_info_t ksii;
 
-static bool ai_buscore_prep(si_info_t *sii, uint bustype, uint devid,
-			    void *sdh)
+static bool ai_buscore_prep(si_info_t *sii, uint bustype)
 {
 	/* kludge to enable the clock on the 4306 which lacks a slowclock */
 	if (bustype == PCI_BUS && !ai_ispcie(sii))
@@ -1070,7 +1068,7 @@ static __used void ai_nvram_process(si_info_t *sii, char *pvars)
 	sii->pub.boardflags = getintvar(pvars, "boardflags");
 }
 
-static si_info_t *ai_doattach(si_info_t *sii, uint devid,
+static si_info_t *ai_doattach(si_info_t *sii,
 			      void *regs, uint bustype, void *pbus,
 			      char **vars, uint *varsz)
 {
@@ -1116,7 +1114,7 @@ static si_info_t *ai_doattach(si_info_t *sii, uint devid,
 	sih->bustype = bustype;
 
 	/* bus/core/clk setup for register access */
-	if (!ai_buscore_prep(sii, bustype, devid, pbus)) {
+	if (!ai_buscore_prep(sii, bustype)) {
 		SI_ERROR(("si_doattach: si_core_clk_prep failed %d\n",
 			  bustype));
 		return NULL;
@@ -1142,7 +1140,7 @@ static si_info_t *ai_doattach(si_info_t *sii, uint devid,
 	if (socitype == SOCI_AI) {
 		SI_MSG(("Found chip type AI (0x%08x)\n", w));
 		/* pass chipc address instead of original core base */
-		ai_scan(&sii->pub, (void *)cc, devid);
+		ai_scan(&sii->pub, (void *)cc);
 	} else {
 		SI_ERROR(("Found chip of unknown type (0x%08x)\n", w));
 		return NULL;
diff --git a/drivers/staging/brcm80211/brcmsmac/aiutils.h b/drivers/staging/brcm80211/brcmsmac/aiutils.h
index 85c39af..2b124c1 100644
--- a/drivers/staging/brcm80211/brcmsmac/aiutils.h
+++ b/drivers/staging/brcm80211/brcmsmac/aiutils.h
@@ -499,7 +499,7 @@ struct si_info {
 };
 
 /* AMBA Interconnect exported externs */
-extern void ai_scan(struct si_pub *sih, void *regs, uint devid);
+extern void ai_scan(struct si_pub *sih, void *regs);
 
 extern uint ai_flag(struct si_pub *sih);
 extern void ai_setint(struct si_pub *sih, int siflag);
@@ -521,7 +521,7 @@ extern u32 ai_addrspacesize(struct si_pub *sih, uint asidx);
 extern void ai_write_wrap_reg(struct si_pub *sih, u32 offset, u32 val);
 
 /* === exported functions === */
-extern struct si_pub *ai_attach(uint pcidev, void *regs, uint bustype,
+extern struct si_pub *ai_attach(void *regs, uint bustype,
 		       void *sdh, char **vars, uint *varsz);
 
 extern void ai_detach(struct si_pub *sih);
diff --git a/drivers/staging/brcm80211/brcmsmac/bmac.c b/drivers/staging/brcm80211/brcmsmac/bmac.c
index 68bf242..448a562 100644
--- a/drivers/staging/brcm80211/brcmsmac/bmac.c
+++ b/drivers/staging/brcm80211/brcmsmac/bmac.c
@@ -610,7 +610,7 @@ int wlc_bmac_attach(struct wlc_info *wlc, u16 vendor, u16 device, uint unit,
 	 * Also initialize software state that depends on the particular hardware
 	 * we are running.
 	 */
-	wlc_hw->sih = ai_attach((uint) device, regsva, bustype, btparam,
+	wlc_hw->sih = ai_attach(regsva, bustype, btparam,
 				&wlc_hw->vars, &wlc_hw->vars_size);
 	if (wlc_hw->sih == NULL) {
 		wiphy_err(wiphy, "wl%d: wlc_bmac_attach: si_attach failed\n",
-- 
1.7.4.1


