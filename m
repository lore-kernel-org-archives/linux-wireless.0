Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mms2.broadcom.com ([216.31.210.18]:4739 "EHLO mms2.broadcom.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752244Ab1I0Rpw (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 27 Sep 2011 13:45:52 -0400
From: "Franky Lin" <frankyl@broadcom.com>
To: gregkh@suse.de
cc: devel@linuxdriverproject.org, linux-wireless@vger.kernel.org
Subject: [PATCH v2 03/26] staging: brcm80211: deleted unused array of
 bss configurations in softmac
Date: Tue, 27 Sep 2011 10:45:07 -0700
Message-ID: <1317145530-18839-4-git-send-email-frankyl@broadcom.com> (sfid-20110927_194603_282725_C0751FB6)
In-Reply-To: <1317145530-18839-1-git-send-email-frankyl@broadcom.com>
References: <1317145530-18839-1-git-send-email-frankyl@broadcom.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Roland Vossen <rvossen@broadcom.com>

List always had one element. Converted the array to a scalar.

Reviewed-by: Pieter-Paul Giesberts <pieterpg@broadcom.com>
Reviewed-by: Arend van Spriel <arend@broadcom.com>
Signed-off-by: Franky Lin <frankyl@broadcom.com>
---
 drivers/staging/brcm80211/brcmsmac/main.c  |  139 +++++++++-------------------
 drivers/staging/brcm80211/brcmsmac/main.h  |    2 +-
 drivers/staging/brcm80211/brcmsmac/types.h |    5 -
 3 files changed, 43 insertions(+), 103 deletions(-)

diff --git a/drivers/staging/brcm80211/brcmsmac/main.c b/drivers/staging/brcm80211/brcmsmac/main.c
index d160212..138f63b 100644
--- a/drivers/staging/brcm80211/brcmsmac/main.c
+++ b/drivers/staging/brcm80211/brcmsmac/main.c
@@ -342,15 +342,6 @@ static u16 frametype(u32 rspec, u8 mimoframe)
 /* Starting corerev for the fifo size table */
 #define XMTFIFOTBL_STARTREV	20
 
-/* iterate through all valid bsscfg entries */
-#define FOREACH_BSS(wlc, idx, cfg) \
-	for (idx = 0; (int) idx < BRCMS_MAXBSSCFG; idx++) { \
-		cfg = (wlc)->bsscfg[idx]; \
-		if (!cfg) \
-			continue;
-/* close marker for iterator code block */
-#define END_FOREACH_BSS()	}
-
 /* currently the best mechanism for determining SIFS is the band in use */
 static u16 get_sifs(struct brcms_band *band)
 {
@@ -3278,8 +3269,7 @@ static void brcms_b_antsel_set(struct brcms_hardware *wlc_hw, u32 antsel_avail)
  */
 bool brcms_c_ps_allowed(struct brcms_c_info *wlc)
 {
-	int idx;
-	struct brcms_bss_cfg *cfg;
+	struct brcms_bss_cfg *cfg = wlc->bsscfg;
 
 	/* disallow PS when one of the following global conditions meets */
 	if (!wlc->pub->associated)
@@ -3289,19 +3279,16 @@ bool brcms_c_ps_allowed(struct brcms_c_info *wlc)
 	if (wlc->monitor)
 		return false;
 
-	for (idx = 0; idx < BRCMS_MAXBSSCFG; idx++) {
-		cfg = wlc->bsscfg[idx];
-		if (cfg && cfg->associated) {
-			/*
-			 * disallow PS when one of the following
-			 * bsscfg specific conditions meets
-			 */
-			if (!cfg->BSS)
-				return false;
+	if (cfg->associated) {
+		/*
+		 * disallow PS when one of the following
+		 * bsscfg specific conditions meets
+		 */
+		if (!cfg->BSS)
+			return false;
 
-			if (!cfg->dtim_programmed)
-				return false;
-		}
+		if (!cfg->dtim_programmed)
+			return false;
 	}
 
 	return true;
@@ -3779,8 +3766,6 @@ void brcms_c_init(struct brcms_c_info *wlc)
 {
 	struct d11regs *regs;
 	u16 chanspec;
-	int i;
-	struct brcms_bss_cfg *bsscfg;
 	bool mute = false;
 
 	BCMMSG(wlc->wiphy, "wl%d\n", wlc->pub->unit);
@@ -3806,32 +3791,24 @@ void brcms_c_init(struct brcms_c_info *wlc)
 	brcms_c_reprate_init(wlc);
 
 	/* write ethernet address to core */
-	FOREACH_BSS(wlc, i, bsscfg)
-		brcms_c_set_mac(bsscfg);
-		brcms_c_set_bssid(bsscfg);
-	END_FOREACH_BSS()
+	brcms_c_set_mac(wlc->bsscfg);
+	brcms_c_set_bssid(wlc->bsscfg);
 
 	/* Update tsf_cfprep if associated and up */
-	if (wlc->pub->associated) {
-		FOREACH_BSS(wlc, i, bsscfg)
-			if (bsscfg->up) {
-				u32 bi;
+	if (wlc->pub->associated && wlc->bsscfg->up) {
+		u32 bi;
 
-				/* get beacon period and convert to uS */
-				bi = bsscfg->current_bss->beacon_period << 10;
-				/*
-				 * update since init path would reset
-				 * to default value
-				 */
-				W_REG(&regs->tsf_cfprep,
-				      (bi << CFPREP_CBI_SHIFT));
-
-				/* Update maccontrol PM related bits */
-				brcms_c_set_ps_ctrl(wlc);
+		/* get beacon period and convert to uS */
+		bi = wlc->bsscfg->current_bss->beacon_period << 10;
+		/*
+		 * update since init path would reset
+		 * to default value
+		 */
+		W_REG(&regs->tsf_cfprep,
+		      (bi << CFPREP_CBI_SHIFT));
 
-				break;
-			}
-		END_FOREACH_BSS()
+		/* Update maccontrol PM related bits */
+		brcms_c_set_ps_ctrl(wlc);
 	}
 
 	brcms_c_bandinit_ordered(wlc, chanspec);
@@ -4021,26 +3998,13 @@ void brcms_c_switch_shortslot(struct brcms_c_info *wlc, bool shortslot)
 	brcms_b_set_shortslot(wlc->hw, shortslot);
 }
 
-/*
- * propagate home chanspec to all bsscfgs in
- * case bsscfg->current_bss->chanspec is referenced
- */
 void brcms_c_set_home_chanspec(struct brcms_c_info *wlc, u16 chanspec)
 {
 	if (wlc->home_chanspec != chanspec) {
-		int idx;
-		struct brcms_bss_cfg *cfg;
-
 		wlc->home_chanspec = chanspec;
 
-		FOREACH_BSS(wlc, idx, cfg)
-			if (!cfg->associated)
-				continue;
-
-			cfg->current_bss->chanspec = chanspec;
-		END_FOREACH_BSS()
-
-
+		if (wlc->bsscfg->associated)
+			wlc->bsscfg->current_bss->chanspec = chanspec;
 	}
 }
 
@@ -4092,8 +4056,7 @@ brcms_b_set_chanspec(struct brcms_hardware *wlc_hw, u16 chanspec,
 static void brcms_c_setband(struct brcms_c_info *wlc,
 					   uint bandunit)
 {
-	int idx;
-	struct brcms_bss_cfg *cfg;
+	struct brcms_bss_cfg *cfg = wlc->bsscfg;
 
 	wlc->band = wlc->bandstate[bandunit];
 
@@ -4101,11 +4064,9 @@ static void brcms_c_setband(struct brcms_c_info *wlc,
 		return;
 
 	/* wait for at least one beacon before entering sleeping state */
-	for (idx = 0; idx < BRCMS_MAXBSSCFG; idx++) {
-		cfg = wlc->bsscfg[idx];
-		if (cfg && cfg->associated)
-			cfg->PMawakebcn = true;
-	}
+	if (cfg->associated)
+		cfg->PMawakebcn = true;
+
 	brcms_c_set_ps_ctrl(wlc);
 
 	/* band-specific initializations */
@@ -5427,7 +5388,7 @@ brcms_c_attach(struct brcms_info *wl, u16 vendor, u16 device, uint unit,
 		goto fail;
 	}
 
-	wlc->bsscfg[0] = wlc->cfg;
+	wlc->bsscfg = wlc->cfg;
 	wlc->cfg->_idx = 0;
 	wlc->cfg->wlc = wlc;
 
@@ -5840,19 +5801,15 @@ int brcms_c_up(struct brcms_c_info *wlc)
 		if (status == -ENOMEDIUM) {
 			if (!mboolisset
 			    (wlc->pub->radio_disabled, WL_RADIO_HW_DISABLE)) {
-				int idx;
-				struct brcms_bss_cfg *bsscfg;
+				struct brcms_bss_cfg *bsscfg = wlc->bsscfg;
 				mboolset(wlc->pub->radio_disabled,
 					 WL_RADIO_HW_DISABLE);
 
-				FOREACH_BSS(wlc, idx, bsscfg)
-					if (!bsscfg->enable || !bsscfg->BSS)
-						continue;
-					wiphy_err(wlc->wiphy, "wl%d.%d: up"
+				if (bsscfg->enable && bsscfg->BSS)
+					wiphy_err(wlc->wiphy, "wl%d: up"
 						  ": rfdisable -> "
 						  "bsscfg_disable()\n",
-						   wlc->pub->unit, idx);
-				END_FOREACH_BSS()
+						   wlc->pub->unit);
 			}
 		}
 	}
@@ -8993,14 +8950,10 @@ void brcms_c_bss_update_beacon(struct brcms_c_info *wlc,
  */
 void brcms_c_update_beacon(struct brcms_c_info *wlc)
 {
-	int idx;
-	struct brcms_bss_cfg *bsscfg;
+	struct brcms_bss_cfg *bsscfg = wlc->bsscfg;
 
-	/* update AP or IBSS beacons */
-	FOREACH_BSS(wlc, idx, bsscfg)
-		if (bsscfg->up && !bsscfg->BSS)
-			brcms_c_bss_update_beacon(wlc, bsscfg);
-	END_FOREACH_BSS()
+	if (bsscfg->up && !bsscfg->BSS)
+		brcms_c_bss_update_beacon(wlc, bsscfg);
 }
 
 /* Write ssid into shared memory */
@@ -9020,14 +8973,11 @@ void brcms_c_shm_ssid_upd(struct brcms_c_info *wlc, struct brcms_bss_cfg *cfg)
 
 void brcms_c_update_probe_resp(struct brcms_c_info *wlc, bool suspend)
 {
-	int idx;
-	struct brcms_bss_cfg *bsscfg;
+	struct brcms_bss_cfg *bsscfg = wlc->bsscfg;
 
 	/* update AP or IBSS probe responses */
-	FOREACH_BSS(wlc, idx, bsscfg)
-		if (bsscfg->up && !bsscfg->BSS)
-			brcms_c_bss_update_probe_resp(wlc, bsscfg, suspend);
-	END_FOREACH_BSS()
+	if (bsscfg->up && !bsscfg->BSS)
+		brcms_c_bss_update_probe_resp(wlc, bsscfg, suspend);
 }
 
 void
@@ -9105,12 +9055,7 @@ int brcms_c_prep_pdu(struct brcms_c_info *wlc, struct sk_buff *pdu, uint *fifop)
 /* init tx reported rate mechanism */
 void brcms_c_reprate_init(struct brcms_c_info *wlc)
 {
-	int i;
-	struct brcms_bss_cfg *bsscfg;
-
-	FOREACH_BSS(wlc, i, bsscfg)
-		brcms_c_bsscfg_reprate_init(bsscfg);
-	END_FOREACH_BSS()
+	brcms_c_bsscfg_reprate_init(wlc->bsscfg);
 }
 
 /* per bsscfg init tx reported rate mechanism */
diff --git a/drivers/staging/brcm80211/brcmsmac/main.h b/drivers/staging/brcm80211/brcmsmac/main.h
index 1572e46..ede4aef 100644
--- a/drivers/staging/brcm80211/brcmsmac/main.h
+++ b/drivers/staging/brcm80211/brcmsmac/main.h
@@ -564,7 +564,7 @@ struct brcms_c_info {
 	u16 tx_prec_map;
 	u16 fifo2prec_map[NFIFO];
 
-	struct brcms_bss_cfg *bsscfg[BRCMS_MAXBSSCFG];
+	struct brcms_bss_cfg *bsscfg;
 	struct brcms_bss_cfg *cfg;
 
 	/* tx queue */
diff --git a/drivers/staging/brcm80211/brcmsmac/types.h b/drivers/staging/brcm80211/brcmsmac/types.h
index ace210c..415ab8b 100644
--- a/drivers/staging/brcm80211/brcmsmac/types.h
+++ b/drivers/staging/brcm80211/brcmsmac/types.h
@@ -244,11 +244,6 @@
  * ********************************************************************
  */
 
-/* NetBSD also needs to keep track of this */
-
-/* max # BSS configs */
-#define BRCMS_MAXBSSCFG		(1)
-
 #define BCMMSG(dev, fmt, args...)		\
 do {						\
 	if (brcm_msg_level & LOG_TRACE_VAL)	\
-- 
1.7.1


