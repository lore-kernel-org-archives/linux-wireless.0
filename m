Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mms3.broadcom.com ([216.31.210.19]:4155 "EHLO MMS3.broadcom.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750794Ab1IAJRg (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 1 Sep 2011 05:17:36 -0400
From: "Roland Vossen" <rvossen@broadcom.com>
To: gregkh@suse.de
cc: devel@linuxdriverproject.org, linux-wireless@vger.kernel.org
Subject: [PATCH 01/30] staging: brcm80211: removed static function
 declarations in aiutils.c
Date: Thu, 1 Sep 2011 11:16:51 +0200
Message-ID: <1314868640-9425-2-git-send-email-rvossen@broadcom.com> (sfid-20110901_111745_243934_C08C65AB)
In-Reply-To: <1314868640-9425-1-git-send-email-rvossen@broadcom.com>
References: <1314868640-9425-1-git-send-email-rvossen@broadcom.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Reported-by: Johannes Berg <johannes@sipsolutions.net>
Signed-off-by: Roland Vossen <rvossen@broadcom.com>
---
 drivers/staging/brcm80211/brcmsmac/aiutils.c |  211 ++++++++++++--------------
 1 files changed, 97 insertions(+), 114 deletions(-)

diff --git a/drivers/staging/brcm80211/brcmsmac/aiutils.c b/drivers/staging/brcm80211/brcmsmac/aiutils.c
index 62186b7..07f9d37 100644
--- a/drivers/staging/brcm80211/brcmsmac/aiutils.c
+++ b/drivers/staging/brcm80211/brcmsmac/aiutils.c
@@ -407,6 +407,9 @@ struct aidmp {
 	u32 componentid3;	/* 0xffc */
 };
 
+/* global kernel resource */
+static struct si_info ksii;
+
 /* EROM parsing */
 
 static u32
@@ -839,6 +842,28 @@ u32 ai_core_cflags(struct si_pub *sih, u32 mask, u32 val)
 	return R_REG(&ai->ioctrl);
 }
 
+/* return true if PCIE capability exists in the pci config space */
+static bool ai_ispcie(struct si_info *sii)
+{
+	u8 cap_ptr;
+
+	cap_ptr =
+	    pcicore_find_pci_capability(sii->pbus, PCI_CAP_ID_EXP, NULL,
+					NULL);
+	if (!cap_ptr)
+		return false;
+
+	return true;
+}
+
+static bool ai_buscore_prep(struct si_info *sii)
+{
+	/* kludge to enable the clock on the 4306 which lacks a slowclock */
+	if (!ai_ispcie(sii))
+		ai_clkctl_xtal(&sii->pub, XTAL | PLL, ON);
+	return true;
+}
+
 u32 ai_core_sflags(struct si_pub *sih, u32 mask, u32 val)
 {
 	struct si_info *sii;
@@ -862,62 +887,6 @@ u32 ai_core_sflags(struct si_pub *sih, u32 mask, u32 val)
 	return R_REG(&ai->iostatus);
 }
 
-/* *************** from siutils.c ************** */
-/* local prototypes */
-static struct si_info *ai_doattach(struct si_info *sii, void *regs,
-				   struct pci_dev *sdh,
-				   char **vars, uint *varsz);
-static bool ai_buscore_prep(struct si_info *sii);
-static bool ai_buscore_setup(struct si_info *sii, u32 savewin, uint *origidx);
-static void ai_nvram_process(struct si_info *sii, char *pvars);
-
-/* dev path concatenation util */
-static char *ai_devpathvar(struct si_pub *sih, char *var, int len,
-			   const char *name);
-static bool _ai_clkctl_cc(struct si_info *sii, uint mode);
-static bool ai_ispcie(struct si_info *sii);
-
-/*
- * Allocate a si handle.
- * devid - pci device id (used to determine chip#)
- * osh - opaque OS handle
- * regs - virtual address of initial core registers
- * vars - pointer to a pointer area for "environment" variables
- * varsz - pointer to int to return the size of the vars
- */
-struct si_pub *
-ai_attach(void *regs, struct pci_dev *sdh, char **vars, uint *varsz)
-{
-	struct si_info *sii;
-
-	/* alloc struct si_info */
-	sii = kmalloc(sizeof(struct si_info), GFP_ATOMIC);
-	if (sii == NULL) {
-		SI_ERROR(("si_attach: malloc failed!\n"));
-		return NULL;
-	}
-
-	if (ai_doattach(sii, regs, sdh, vars, varsz) == NULL) {
-		kfree(sii);
-		return NULL;
-	}
-	sii->vars = vars ? *vars : NULL;
-	sii->varsz = varsz ? *varsz : 0;
-
-	return (struct si_pub *) sii;
-}
-
-/* global kernel resource */
-static struct si_info ksii;
-
-static bool ai_buscore_prep(struct si_info *sii)
-{
-	/* kludge to enable the clock on the 4306 which lacks a slowclock */
-	if (!ai_ispcie(sii))
-		ai_clkctl_xtal(&sii->pub, XTAL | PLL, ON);
-	return true;
-}
-
 static bool
 ai_buscore_setup(struct si_info *sii, u32 savewin, uint *origidx)
 {
@@ -1206,6 +1175,34 @@ static struct si_info *ai_doattach(struct si_info *sii,
 	return NULL;
 }
 
+/*
+ * Allocate a si handle.
+ * devid - pci device id (used to determine chip#)
+ * osh - opaque OS handle
+ * regs - virtual address of initial core registers
+ * vars - pointer to a pointer area for "environment" variables
+ * varsz - pointer to int to return the size of the vars
+ */
+struct si_pub *
+ai_attach(void *regs, struct pci_dev *sdh, char **vars, uint *varsz)
+{
+	struct si_info *sii;
+
+	/* alloc struct si_info */
+	sii = kmalloc(sizeof(struct si_info), GFP_ATOMIC);
+	if (sii == NULL)
+		return NULL;
+
+	if (ai_doattach(sii, regs, sdh, vars, varsz) == NULL) {
+		kfree(sii);
+		return NULL;
+	}
+	sii->vars = vars ? *vars : NULL;
+	sii->varsz = varsz ? *varsz : 0;
+
+	return (struct si_pub *) sii;
+}
+
 /* may be called with core in reset */
 void ai_detach(struct si_pub *sih)
 {
@@ -1732,30 +1729,6 @@ int ai_clkctl_xtal(struct si_pub *sih, uint what, bool on)
 	return 0;
 }
 
-/*
- *  clock control policy function throught chipcommon
- *
- *    set dynamic clk control mode (forceslow, forcefast, dynamic)
- *    returns true if we are forcing fast clock
- *    this is a wrapper over the next internal function
- *      to allow flexible policy settings for outside caller
- */
-bool ai_clkctl_cc(struct si_pub *sih, uint mode)
-{
-	struct si_info *sii;
-
-	sii = SI_INFO(sih);
-
-	/* chipcommon cores prior to rev6 don't support dynamic clock control */
-	if (sih->ccrev < 6)
-		return false;
-
-	if (PCI_FORCEHT(sii))
-		return mode == CLK_FAST;
-
-	return _ai_clkctl_cc(sii, mode);
-}
-
 /* clk control mechanism through chipcommon, no policy checking */
 static bool _ai_clkctl_cc(struct si_info *sii, uint mode)
 {
@@ -1842,6 +1815,30 @@ static bool _ai_clkctl_cc(struct si_info *sii, uint mode)
 	return mode == CLK_FAST;
 }
 
+/*
+ *  clock control policy function throught chipcommon
+ *
+ *    set dynamic clk control mode (forceslow, forcefast, dynamic)
+ *    returns true if we are forcing fast clock
+ *    this is a wrapper over the next internal function
+ *      to allow flexible policy settings for outside caller
+ */
+bool ai_clkctl_cc(struct si_pub *sih, uint mode)
+{
+	struct si_info *sii;
+
+	sii = SI_INFO(sih);
+
+	/* chipcommon cores prior to rev6 don't support dynamic clock control */
+	if (sih->ccrev < 6)
+		return false;
+
+	if (PCI_FORCEHT(sii))
+		return mode == CLK_FAST;
+
+	return _ai_clkctl_cc(sii, mode);
+}
+
 /* Build device path */
 int ai_devpath(struct si_pub *sih, char *path, int size)
 {
@@ -1862,31 +1859,6 @@ int ai_devpath(struct si_pub *sih, char *path, int size)
 	return 0;
 }
 
-/* Get a variable, but only if it has a devpath prefix */
-char *ai_getdevpathvar(struct si_pub *sih, const char *name)
-{
-	char varname[SI_DEVPATH_BUFSZ + 32];
-
-	ai_devpathvar(sih, varname, sizeof(varname), name);
-
-	return getvar(NULL, varname);
-}
-
-/* Get a variable, but only if it has a devpath prefix */
-int ai_getdevpathintvar(struct si_pub *sih, const char *name)
-{
-	char varname[SI_DEVPATH_BUFSZ + 32];
-
-	ai_devpathvar(sih, varname, sizeof(varname), name);
-
-	return getintvar(NULL, varname);
-}
-
-char *ai_getnvramflvar(struct si_pub *sih, const char *name)
-{
-	return getvar(NULL, name);
-}
-
 /* Concatenate the dev path with a varname into the given 'var' buffer
  * and return the 'var' pointer. Nothing is done to the arguments if
  * len == 0 or var is NULL, var is still returned. On overflow, the
@@ -1912,18 +1884,29 @@ static char *ai_devpathvar(struct si_pub *sih, char *var, int len,
 	return var;
 }
 
-/* return true if PCIE capability exists in the pci config space */
-static bool ai_ispcie(struct si_info *sii)
+/* Get a variable, but only if it has a devpath prefix */
+char *ai_getdevpathvar(struct si_pub *sih, const char *name)
 {
-	u8 cap_ptr;
+	char varname[SI_DEVPATH_BUFSZ + 32];
 
-	cap_ptr =
-	    pcicore_find_pci_capability(sii->pbus, PCI_CAP_ID_EXP, NULL,
-					NULL);
-	if (!cap_ptr)
-		return false;
+	ai_devpathvar(sih, varname, sizeof(varname), name);
 
-	return true;
+	return getvar(NULL, varname);
+}
+
+/* Get a variable, but only if it has a devpath prefix */
+int ai_getdevpathintvar(struct si_pub *sih, const char *name)
+{
+	char varname[SI_DEVPATH_BUFSZ + 32];
+
+	ai_devpathvar(sih, varname, sizeof(varname), name);
+
+	return getintvar(NULL, varname);
+}
+
+char *ai_getnvramflvar(struct si_pub *sih, const char *name)
+{
+	return getvar(NULL, name);
 }
 
 bool ai_pci_war16165(struct si_pub *sih)
-- 
1.7.4.1


