Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mms1.broadcom.com ([216.31.210.17]:2131 "EHLO mms1.broadcom.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S934709Ab1JENUj (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 5 Oct 2011 09:20:39 -0400
From: "Arend van Spriel" <arend@broadcom.com>
To: gregkh@suse.de
cc: devel@linuxdriverproject.org, linux-wireless@vger.kernel.org,
	"Arend van Spriel" <arend@broadcom.com>
Subject: [PATCH 13/15] staging: brcm80211: cleanup driver variable
 references
Date: Wed, 5 Oct 2011 15:20:12 +0200
Message-ID: <1317820814-7083-14-git-send-email-arend@broadcom.com> (sfid-20111005_152100_650567_AEA6DDAC)
In-Reply-To: <1317820814-7083-1-git-send-email-arend@broadcom.com>
References: <1317820814-7083-1-git-send-email-arend@broadcom.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Throughout the data structures within the driver several references
to the driver variables were stored. As the storage and access
functions are now consolidated into srom.c those references are
no longer needed and have been removed.

Reviewed-by: Roland Vossen <rvossen@broadcom.com>
Reviewed-by: Alwin Beukers <alwin@broadcom.com>
Signed-off-by: Arend van Spriel <arend@broadcom.com>
---
 drivers/staging/brcm80211/brcmsmac/aiutils.c     |   13 +++------
 drivers/staging/brcm80211/brcmsmac/aiutils.h     |    5 +---
 drivers/staging/brcm80211/brcmsmac/main.c        |   30 ++-------------------
 drivers/staging/brcm80211/brcmsmac/main.h        |    5 ---
 drivers/staging/brcm80211/brcmsmac/phy/phy_cmn.c |    6 +---
 drivers/staging/brcm80211/brcmsmac/phy/phy_hal.h |    4 +--
 drivers/staging/brcm80211/brcmsmac/phy/phy_int.h |    1 -
 drivers/staging/brcm80211/brcmsmac/pub.h         |    1 -
 drivers/staging/brcm80211/brcmsmac/srom.c        |   14 ++--------
 drivers/staging/brcm80211/brcmsmac/srom.h        |    3 +-
 10 files changed, 14 insertions(+), 68 deletions(-)

diff --git a/drivers/staging/brcm80211/brcmsmac/aiutils.c b/drivers/staging/brcm80211/brcmsmac/aiutils.c
index afba8b1..025fa0e 100644
--- a/drivers/staging/brcm80211/brcmsmac/aiutils.c
+++ b/drivers/staging/brcm80211/brcmsmac/aiutils.c
@@ -1025,8 +1025,7 @@ static __used void ai_nvram_process(struct si_info *sii)
 }
 
 static struct si_info *ai_doattach(struct si_info *sii,
-				   void __iomem *regs, struct pci_dev *pbus,
-				   char **vars, uint *varsz)
+				   void __iomem *regs, struct pci_dev *pbus)
 {
 	struct si_pub *sih = &sii->pub;
 	u32 w, savewin;
@@ -1091,11 +1090,9 @@ static struct si_info *ai_doattach(struct si_info *sii,
 		goto exit;
 
 	/* Init nvram from sprom/otp if they exist */
-	if (srom_var_init(&sii->pub, cc, vars, varsz))
+	if (srom_var_init(&sii->pub, cc))
 		goto exit;
 
-	sii->vars = vars ? *vars : NULL;
-	sii->varsz = varsz ? *varsz : 0;
 	ai_nvram_process(sii);
 
 	/* === NVRAM, clock is ready === */
@@ -1172,11 +1169,9 @@ static struct si_info *ai_doattach(struct si_info *sii,
  * devid - pci device id (used to determine chip#)
  * osh - opaque OS handle
  * regs - virtual address of initial core registers
- * vars - pointer to a pointer area for "environment" variables
- * varsz - pointer to int to return the size of the vars
  */
 struct si_pub *
-ai_attach(void __iomem *regs, struct pci_dev *sdh, char **vars, uint *varsz)
+ai_attach(void __iomem *regs, struct pci_dev *sdh)
 {
 	struct si_info *sii;
 
@@ -1185,7 +1180,7 @@ ai_attach(void __iomem *regs, struct pci_dev *sdh, char **vars, uint *varsz)
 	if (sii == NULL)
 		return NULL;
 
-	if (ai_doattach(sii, regs, sdh, vars, varsz) == NULL) {
+	if (ai_doattach(sii, regs, sdh) == NULL) {
 		kfree(sii);
 		return NULL;
 	}
diff --git a/drivers/staging/brcm80211/brcmsmac/aiutils.h b/drivers/staging/brcm80211/brcmsmac/aiutils.h
index dce5551..106a742 100644
--- a/drivers/staging/brcm80211/brcmsmac/aiutils.h
+++ b/drivers/staging/brcm80211/brcmsmac/aiutils.h
@@ -267,8 +267,6 @@ struct si_info {
 	struct pcicore_info *pch; /* PCI/E core handle */
 
 	struct list_head var_list; /* list of srom variables */
-	char *vars;
-	uint varsz;
 
 	void __iomem *curmap;			/* current regs va */
 	void __iomem *regs[SI_MAXCORES];	/* other regs va */
@@ -320,8 +318,7 @@ extern u32 ai_addrspacesize(struct si_pub *sih, uint asidx);
 extern void ai_write_wrap_reg(struct si_pub *sih, u32 offset, u32 val);
 
 /* === exported functions === */
-extern struct si_pub *ai_attach(void __iomem *regs, struct pci_dev *sdh,
-				char **vars, uint *varsz);
+extern struct si_pub *ai_attach(void __iomem *regs, struct pci_dev *sdh);
 extern void ai_detach(struct si_pub *sih);
 extern uint ai_coreid(struct si_pub *sih);
 extern uint ai_corerev(struct si_pub *sih);
diff --git a/drivers/staging/brcm80211/brcmsmac/main.c b/drivers/staging/brcm80211/brcmsmac/main.c
index 5ec25e8..1e35be9 100644
--- a/drivers/staging/brcm80211/brcmsmac/main.c
+++ b/drivers/staging/brcm80211/brcmsmac/main.c
@@ -3106,16 +3106,6 @@ brcms_b_copyfrom_objmem(struct brcms_hardware *wlc_hw, uint offset, void *buf,
 	}
 }
 
-static void brcms_b_copyfrom_vars(struct brcms_hardware *wlc_hw, char **buf,
-			   uint *len)
-{
-	BCMMSG(wlc_hw->wlc->wiphy, "nvram vars totlen=%d\n",
-		wlc_hw->vars_size);
-
-	*buf = wlc_hw->vars;
-	*len = wlc_hw->vars_size;
-}
-
 static void brcms_b_retrylimit_upd(struct brcms_hardware *wlc_hw,
 				   u16 SRL, u16 LRL)
 {
@@ -4551,7 +4541,6 @@ static int brcms_b_attach(struct brcms_c_info *wlc, u16 vendor, u16 device,
 	struct brcms_hardware *wlc_hw;
 	struct d11regs __iomem *regs;
 	char *macaddr = NULL;
-	char *vars;
 	uint err = 0;
 	uint j;
 	bool wme = false;
@@ -4576,15 +4565,13 @@ static int brcms_b_attach(struct brcms_c_info *wlc, u16 vendor, u16 device,
 	 * Do the hardware portion of the attach. Also initialize software
 	 * state that depends on the particular hardware we are running.
 	 */
-	wlc_hw->sih = ai_attach(regsva, btparam,
-				&wlc_hw->vars, &wlc_hw->vars_size);
+	wlc_hw->sih = ai_attach(regsva, btparam);
 	if (wlc_hw->sih == NULL) {
 		wiphy_err(wiphy, "wl%d: brcms_b_attach: si_attach failed\n",
 			  unit);
 		err = 11;
 		goto fail;
 	}
-	vars = wlc_hw->vars;
 
 	/* verify again the device is supported */
 	if (!brcms_c_chipmatch(vendor, device)) {
@@ -4692,7 +4679,6 @@ static int brcms_b_attach(struct brcms_c_info *wlc, u16 vendor, u16 device,
 	sha_params.physhim = wlc_hw->physhim;
 	sha_params.unit = unit;
 	sha_params.corerev = wlc_hw->corerev;
-	sha_params.vars = vars;
 	sha_params.vid = wlc_hw->vendorid;
 	sha_params.did = wlc_hw->deviceid;
 	sha_params.chip = wlc_hw->sih->chip;
@@ -4738,8 +4724,8 @@ static int brcms_b_attach(struct brcms_c_info *wlc, u16 vendor, u16 device,
 		/* Get a phy for this band */
 		wlc_hw->band->pi =
 			wlc_phy_attach(wlc_hw->phy_sh, regs,
-					wlc_hw->band->bandtype, vars,
-					wlc->wiphy);
+				       wlc_hw->band->bandtype,
+				       wlc->wiphy);
 		if (wlc_hw->band->pi == NULL) {
 			wiphy_err(wiphy, "wl%d: brcms_b_attach: wlc_phy_"
 				  "attach failed\n", unit);
@@ -4897,12 +4883,10 @@ static bool brcms_c_attach_stf_ant_init(struct brcms_c_info *wlc)
 {
 	int aa;
 	uint unit;
-	char *vars;
 	int bandtype;
 	struct si_pub *sih = wlc->hw->sih;
 
 	unit = wlc->pub->unit;
-	vars = wlc->pub->vars;
 	bandtype = wlc->band->bandtype;
 
 	/* get antennas available */
@@ -5092,10 +5076,6 @@ brcms_c_attach(struct brcms_info *wl, u16 vendor, u16 device, uint unit,
 
 	pub->phy_11ncapable = BRCMS_PHY_11N_CAP(wlc->band);
 
-	/* propagate *vars* from BMAC driver to high driver */
-	brcms_b_copyfrom_vars(wlc->hw, &pub->vars, &wlc->vars_size);
-
-
 	/* disable allowed duty cycle */
 	wlc->tx_duty_cycle_ofdm = 0;
 	wlc->tx_duty_cycle_cck = 0;
@@ -5304,10 +5284,6 @@ static int brcms_b_detach(struct brcms_c_info *wlc)
 
 	wlc_phy_shim_detach(wlc_hw->physhim);
 
-	/* free vars */
-	kfree(wlc_hw->vars);
-	wlc_hw->vars = NULL;
-
 	if (wlc_hw->sih) {
 		ai_detach(wlc_hw->sih);
 		wlc_hw->sih = NULL;
diff --git a/drivers/staging/brcm80211/brcmsmac/main.h b/drivers/staging/brcm80211/brcmsmac/main.h
index 441292a..7a2554f 100644
--- a/drivers/staging/brcm80211/brcmsmac/main.h
+++ b/drivers/staging/brcm80211/brcmsmac/main.h
@@ -336,8 +336,6 @@ struct brcms_hardware {
 	u32 machwcap_backup;	/* backup of machwcap */
 
 	struct si_pub *sih;	/* SI handle (cookie for siutils calls) */
-	char *vars;		/* "environment" name=value */
-	uint vars_size;		/* size of vars, free vars on detach */
 	struct d11regs __iomem *regs;	/* pointer to device registers */
 	struct phy_shim_info *physhim; /* phy shim layer handler */
 	struct shared_phy *phy_sh;	/* pointer to shared phy state */
@@ -420,7 +418,6 @@ struct brcms_txq_info {
  * ampdu: ampdu module handler.
  * asi: antsel module handler.
  * cmi: channel manager module handler.
- * vars_size: size of vars, free vars on detach.
  * vendorid: PCI vendor id.
  * deviceid: PCI device id.
  * ucode_rev: microcode revision.
@@ -513,8 +510,6 @@ struct brcms_c_info {
 	struct antsel_info *asi;
 	struct brcms_cm_info *cmi;
 
-	uint vars_size;
-
 	u16 vendorid;
 	u16 deviceid;
 	uint ucode_rev;
diff --git a/drivers/staging/brcm80211/brcmsmac/phy/phy_cmn.c b/drivers/staging/brcm80211/brcmsmac/phy/phy_cmn.c
index 59767e3..d54cfdb 100644
--- a/drivers/staging/brcm80211/brcmsmac/phy/phy_cmn.c
+++ b/drivers/staging/brcm80211/brcmsmac/phy/phy_cmn.c
@@ -459,7 +459,7 @@ static u32 wlc_phy_get_radio_ver(struct brcms_phy *pi)
 
 struct brcms_phy_pub *
 wlc_phy_attach(struct shared_phy *sh, struct d11regs __iomem *regs,
-	       int bandtype, char *vars, struct wiphy *wiphy)
+	       int bandtype, struct wiphy *wiphy)
 {
 	struct brcms_phy *pi;
 	u32 sflags = 0;
@@ -493,8 +493,6 @@ wlc_phy_attach(struct shared_phy *sh, struct d11regs __iomem *regs,
 	pi->phy_init_por = true;
 	pi->phy_wreg_limit = PHY_WREG_LIMIT;
 
-	pi->vars = vars;
-
 	pi->txpwr_percent = 100;
 
 	pi->do_initcal = true;
@@ -609,8 +607,6 @@ wlc_phy_attach(struct shared_phy *sh, struct d11regs __iomem *regs,
 	pi->next = pi->sh->phy_head;
 	sh->phy_head = pi;
 
-	pi->vars = (char *)&pi->vars;
-
 	memcpy(&pi->pubpi_ro, &pi->pubpi, sizeof(struct brcms_phy_pub));
 
 	return &pi->pubpi_ro;
diff --git a/drivers/staging/brcm80211/brcmsmac/phy/phy_hal.h b/drivers/staging/brcm80211/brcmsmac/phy/phy_hal.h
index 44818af..96e1516 100644
--- a/drivers/staging/brcm80211/brcmsmac/phy/phy_hal.h
+++ b/drivers/staging/brcm80211/brcmsmac/phy/phy_hal.h
@@ -167,7 +167,6 @@ struct shared_phy_params {
 	uint unit;
 	uint corerev;
 	uint buscorerev;
-	char *vars;
 	u16 vid;
 	u16 did;
 	uint chip;
@@ -185,8 +184,7 @@ struct shared_phy_params {
 extern struct shared_phy *wlc_phy_shared_attach(struct shared_phy_params *shp);
 extern struct brcms_phy_pub *wlc_phy_attach(struct shared_phy *sh,
 					    struct d11regs __iomem *regs,
-					    int bandtype, char *vars,
-					    struct wiphy *wiphy);
+					    int bandtype, struct wiphy *wiphy);
 extern void wlc_phy_detach(struct brcms_phy_pub *ppi);
 
 extern bool wlc_phy_get_phyversion(struct brcms_phy_pub *pih, u16 *phytype,
diff --git a/drivers/staging/brcm80211/brcmsmac/phy/phy_int.h b/drivers/staging/brcm80211/brcmsmac/phy/phy_int.h
index 4330e38..bea8524 100644
--- a/drivers/staging/brcm80211/brcmsmac/phy/phy_int.h
+++ b/drivers/staging/brcm80211/brcmsmac/phy/phy_int.h
@@ -561,7 +561,6 @@ struct brcms_phy {
 
 	struct d11regs __iomem *regs;
 	struct brcms_phy *next;
-	char *vars;
 	struct brcms_phy_pub pubpi;
 
 	bool do_initcal;
diff --git a/drivers/staging/brcm80211/brcmsmac/pub.h b/drivers/staging/brcm80211/brcmsmac/pub.h
index 8c9ac8f..3942f47 100644
--- a/drivers/staging/brcm80211/brcmsmac/pub.h
+++ b/drivers/staging/brcm80211/brcmsmac/pub.h
@@ -407,7 +407,6 @@ struct brcms_pub {
 	uint unit;		/* device instance number */
 	uint corerev;		/* core revision */
 	struct si_pub *sih;	/* SI handle (cookie for siutils calls) */
-	char *vars;		/* "environment" name=value */
 	bool up;		/* interface up and running */
 	bool hw_off;		/* HW is off */
 	bool hw_up;		/* one time hw up/down */
diff --git a/drivers/staging/brcm80211/brcmsmac/srom.c b/drivers/staging/brcm80211/brcmsmac/srom.c
index 8400cf4..99f7910 100644
--- a/drivers/staging/brcm80211/brcmsmac/srom.c
+++ b/drivers/staging/brcm80211/brcmsmac/srom.c
@@ -1154,8 +1154,7 @@ static int otp_read_pci(struct si_pub *sih, u16 *buf, uint bufsz)
  * Initialize nonvolatile variable table from sprom.
  * Return 0 on success, nonzero on error.
  */
-static int initvars_srom_pci(struct si_pub *sih, void __iomem *curmap,
-			     char **vars, uint *count)
+static int initvars_srom_pci(struct si_pub *sih, void __iomem *curmap)
 {
 	u16 *srom;
 	u16 __iomem *sromwindow;
@@ -1243,21 +1242,14 @@ void srom_free_vars(struct si_pub *sih)
  * Initialize local vars from the right source for this platform.
  * Return 0 on success, nonzero on error.
  */
-int srom_var_init(struct si_pub *sih, void __iomem *curmap, char **vars,
-		  uint *count)
+int srom_var_init(struct si_pub *sih, void __iomem *curmap)
 {
 	uint len;
 
 	len = 0;
 
-	if (vars == NULL || count == NULL)
-		return 0;
-
-	*vars = NULL;
-	*count = 0;
-
 	if (curmap != NULL)
-		return initvars_srom_pci(sih, curmap, vars, count);
+		return initvars_srom_pci(sih, curmap);
 
 	return -EINVAL;
 }
diff --git a/drivers/staging/brcm80211/brcmsmac/srom.h b/drivers/staging/brcm80211/brcmsmac/srom.h
index 395ab7f..708c43f 100644
--- a/drivers/staging/brcm80211/brcmsmac/srom.h
+++ b/drivers/staging/brcm80211/brcmsmac/srom.h
@@ -20,8 +20,7 @@
 #include "types.h"
 
 /* Prototypes */
-extern int srom_var_init(struct si_pub *sih, void __iomem *curmap, char **vars,
-			 uint *count);
+extern int srom_var_init(struct si_pub *sih, void __iomem *curmap);
 extern void srom_free_vars(struct si_pub *sih);
 
 extern int srom_read(struct si_pub *sih, uint bus, void *curmap,
-- 
1.7.4.1


