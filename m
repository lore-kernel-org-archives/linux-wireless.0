Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mms2.broadcom.com ([216.31.210.18]:1858 "EHLO mms2.broadcom.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753397Ab1HHN7i (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 8 Aug 2011 09:59:38 -0400
From: "Arend van Spriel" <arend@broadcom.com>
To: gregkh@suse.de
cc: devel@linuxdriverproject.org, linux-wireless@vger.kernel.org,
	"Roland Vossen" <rvossen@broadcom.com>,
	"Arend van Spriel" <arend@broadcom.com>
Subject: [PATCHv2 75/82] staging: brcm80211: replaced void *btparam into
 struct pci_dev *btparam
Date: Mon, 8 Aug 2011 15:58:59 +0200
Message-ID: <1312811946-16713-76-git-send-email-arend@broadcom.com> (sfid-20110808_155958_438308_50A9A781)
In-Reply-To: <1312811946-16713-1-git-send-email-arend@broadcom.com>
References: <1312811946-16713-1-git-send-email-arend@broadcom.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Roland Vossen <rvossen@broadcom.com>

Code cleanup. Since the softmac driver only supports a PCI(e) bus, the void *
could be replaced with a less generic type.

Reviewed-by: Pieter-Paul Giesberts <pieterpg@broadcom.com>
Signed-off-by: Arend van Spriel <arend@broadcom.com>
---
 drivers/staging/brcm80211/brcmsmac/aiutils.c     |    8 +++++---
 drivers/staging/brcm80211/brcmsmac/aiutils.h     |    4 +++-
 drivers/staging/brcm80211/brcmsmac/mac80211_if.c |    6 +++---
 drivers/staging/brcm80211/brcmsmac/main.c        |    9 +++++----
 drivers/staging/brcm80211/brcmsmac/pub.h         |    2 +-
 5 files changed, 17 insertions(+), 12 deletions(-)

diff --git a/drivers/staging/brcm80211/brcmsmac/aiutils.c b/drivers/staging/brcm80211/brcmsmac/aiutils.c
index 37edd1c..9cfb492 100644
--- a/drivers/staging/brcm80211/brcmsmac/aiutils.c
+++ b/drivers/staging/brcm80211/brcmsmac/aiutils.c
@@ -861,7 +861,8 @@ u32 ai_core_sflags(struct si_pub *sih, u32 mask, u32 val)
 /* *************** from siutils.c ************** */
 /* local prototypes */
 static struct si_info *ai_doattach(struct si_info *sii, void *regs,
-				   void *sdh, char **vars, uint *varsz);
+				   struct pci_dev *sdh,
+				   char **vars, uint *varsz);
 static bool ai_buscore_prep(struct si_info *sii);
 static bool ai_buscore_setup(struct si_info *sii, struct chipcregs *cc,
 			     u32 savewin, uint *origidx, void *regs);
@@ -881,7 +882,8 @@ static bool ai_ispcie(struct si_info *sii);
  * vars - pointer to a pointer area for "environment" variables
  * varsz - pointer to int to return the size of the vars
  */
-struct si_pub *ai_attach(void *regs, void *sdh, char **vars, uint *varsz)
+struct si_pub *
+ai_attach(void *regs, struct pci_dev *sdh, char **vars, uint *varsz)
 {
 	struct si_info *sii;
 
@@ -1052,7 +1054,7 @@ static __used void ai_nvram_process(struct si_info *sii, char *pvars)
 }
 
 static struct si_info *ai_doattach(struct si_info *sii,
-				   void *regs, void *pbus,
+				   void *regs, struct pci_dev *pbus,
 				   char **vars, uint *varsz)
 {
 	struct si_pub *sih = &sii->pub;
diff --git a/drivers/staging/brcm80211/brcmsmac/aiutils.h b/drivers/staging/brcm80211/brcmsmac/aiutils.h
index 076b4c8..101ab92 100644
--- a/drivers/staging/brcm80211/brcmsmac/aiutils.h
+++ b/drivers/staging/brcm80211/brcmsmac/aiutils.h
@@ -446,6 +446,8 @@ struct si_pub {
 #define	IS_SIM(chippkg)	\
 	((chippkg == HDLSIM_PKG_ID) || (chippkg == HWSIM_PKG_ID))
 
+struct pci_dev;
+
 struct gpioh_item {
 	void *arg;
 	bool level;
@@ -515,7 +517,7 @@ extern u32 ai_addrspacesize(struct si_pub *sih, uint asidx);
 extern void ai_write_wrap_reg(struct si_pub *sih, u32 offset, u32 val);
 
 /* === exported functions === */
-extern struct si_pub *ai_attach(void *regs, void *sdh, char **vars,
+extern struct si_pub *ai_attach(void *regs, struct pci_dev *sdh, char **vars,
 				uint *varsz);
 extern void ai_detach(struct si_pub *sih);
 extern bool ai_pci_war16165(struct si_pub *sih);
diff --git a/drivers/staging/brcm80211/brcmsmac/mac80211_if.c b/drivers/staging/brcm80211/brcmsmac/mac80211_if.c
index 6bcb7ea..7f6a490 100644
--- a/drivers/staging/brcm80211/brcmsmac/mac80211_if.c
+++ b/drivers/staging/brcm80211/brcmsmac/mac80211_if.c
@@ -755,7 +755,7 @@ static int brcms_set_hint(struct brcms_info *wl, char *abbrev)
  */
 static struct brcms_info *brcms_attach(u16 vendor, u16 device,
 				       unsigned long regs,
-				       void *btparam, uint irq)
+				       struct pci_dev *btparam, uint irq)
 {
 	struct brcms_info *wl = NULL;
 	int unit, err;
@@ -795,11 +795,11 @@ static struct brcms_info *brcms_attach(u16 vendor, u16 device,
 	spin_lock_init(&wl->isr_lock);
 
 	/* prepare ucode */
-	if (brcms_request_fw(wl, (struct pci_dev *)btparam) < 0) {
+	if (brcms_request_fw(wl, btparam) < 0) {
 		wiphy_err(wl->wiphy, "%s: Failed to find firmware usually in "
 			  "%s\n", KBUILD_MODNAME, "/lib/firmware/brcm");
 		brcms_release_fw(wl);
-		brcms_remove((struct pci_dev *)btparam);
+		brcms_remove(btparam);
 		return NULL;
 	}
 
diff --git a/drivers/staging/brcm80211/brcmsmac/main.c b/drivers/staging/brcm80211/brcmsmac/main.c
index fb9f13f..d011ed6 100644
--- a/drivers/staging/brcm80211/brcmsmac/main.c
+++ b/drivers/staging/brcm80211/brcmsmac/main.c
@@ -313,7 +313,7 @@ struct brcms_b_state;
 
 static int brcms_b_attach(struct brcms_c_info *wlc, u16 vendor, u16 device,
 			  uint unit, bool piomode, void *regsva,
-			  void *btparam);
+			  struct pci_dev *btparam);
 
 /* up/down, reset, clk */
 static void brcms_b_reset(struct brcms_hardware *wlc_hw);
@@ -4301,7 +4301,7 @@ struct brcms_pub *brcms_c_pub(void *wlc)
  *    put the whole chip in reset(driver down state), no clock
  */
 int brcms_b_attach(struct brcms_c_info *wlc, u16 vendor, u16 device, uint unit,
-		   bool piomode, void *regsva, void *btparam)
+		   bool piomode, void *regsva, struct pci_dev *btparam)
 {
 	struct brcms_hardware *wlc_hw;
 	struct d11regs *regs;
@@ -4644,8 +4644,9 @@ int brcms_b_attach(struct brcms_c_info *wlc, u16 vendor, u16 device, uint unit,
 /*
  * The common driver entry routine. Error codes should be unique
  */
-void *brcms_c_attach(struct brcms_info *wl, u16 vendor, u16 device, uint unit,
-		 bool piomode, void *regsva, void *btparam, uint *perr)
+void *
+brcms_c_attach(struct brcms_info *wl, u16 vendor, u16 device, uint unit,
+	       bool piomode, void *regsva, struct pci_dev *btparam, uint *perr)
 {
 	struct brcms_c_info *wlc;
 	uint err = 0;
diff --git a/drivers/staging/brcm80211/brcmsmac/pub.h b/drivers/staging/brcm80211/brcmsmac/pub.h
index 5e15c67..bfbb261 100644
--- a/drivers/staging/brcm80211/brcmsmac/pub.h
+++ b/drivers/staging/brcm80211/brcmsmac/pub.h
@@ -551,7 +551,7 @@ struct brcms_antselcfg {
 /* common functions for every port */
 extern void *brcms_c_attach(struct brcms_info *wl, u16 vendor, u16 device,
 			uint unit, bool piomode, void *regsva,
-			void *btparam, uint *perr);
+			struct pci_dev *btparam, uint *perr);
 extern uint brcms_c_detach(struct brcms_c_info *wlc);
 extern int brcms_c_up(struct brcms_c_info *wlc);
 extern uint brcms_c_down(struct brcms_c_info *wlc);
-- 
1.7.4.1


