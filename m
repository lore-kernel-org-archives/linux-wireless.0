Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mms1.broadcom.com ([216.31.210.17]:1884 "EHLO mms1.broadcom.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754935Ab1I2Weo (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 29 Sep 2011 18:34:44 -0400
From: "Franky Lin" <frankyl@broadcom.com>
To: gregkh@suse.de
cc: devel@linuxdriverproject.org, linux-wireless@vger.kernel.org
Subject: [PATCH v3 04/25] staging: brcm80211: removed redundant wlc->cfg
 struct member
Date: Thu, 29 Sep 2011 15:34:15 -0700
Message-ID: <1317335676-3424-5-git-send-email-frankyl@broadcom.com> (sfid-20110930_003451_123400_E8378A00)
In-Reply-To: <1317335676-3424-1-git-send-email-frankyl@broadcom.com>
References: <1317145530-18839-1-git-send-email-frankyl@broadcom.com>
 <1317335676-3424-1-git-send-email-frankyl@broadcom.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Roland Vossen <rvossen@broadcom.com>

After initialization ('attach'), this struct member always pointed at
the same memory as wlc->bsscfg.

Reviewed-by: Pieter-Paul Giesberts <pieterpg@broadcom.com>
Reviewed-by: Arend van Spriel <arend@broadcom.com>
Signed-off-by: Franky Lin <frankyl@broadcom.com>
---
 drivers/staging/brcm80211/brcmsmac/main.c |   47 ++++++++++++----------------
 drivers/staging/brcm80211/brcmsmac/main.h |    1 -
 2 files changed, 20 insertions(+), 28 deletions(-)

diff --git a/drivers/staging/brcm80211/brcmsmac/main.c b/drivers/staging/brcm80211/brcmsmac/main.c
index 138f63b..ee9c322 100644
--- a/drivers/staging/brcm80211/brcmsmac/main.c
+++ b/drivers/staging/brcm80211/brcmsmac/main.c
@@ -486,7 +486,7 @@ static void brcms_c_detach_mfree(struct brcms_c_info *wlc)
 	if (wlc == NULL)
 		return;
 
-	brcms_c_bsscfg_mfree(wlc->cfg);
+	brcms_c_bsscfg_mfree(wlc->bsscfg);
 	kfree(wlc->pub);
 	kfree(wlc->modulecb);
 	kfree(wlc->default_bss);
@@ -577,8 +577,8 @@ brcms_c_attach_malloc(uint unit, uint *err, uint devid)
 		goto fail;
 	}
 
-	wlc->cfg = brcms_c_bsscfg_malloc(unit);
-	if (wlc->cfg == NULL) {
+	wlc->bsscfg = brcms_c_bsscfg_malloc(unit);
+	if (wlc->bsscfg == NULL) {
 		*err = 1011;
 		goto fail;
 	}
@@ -3943,14 +3943,13 @@ void brcms_c_set_ps_ctrl(struct brcms_c_info *wlc)
  * Write this BSS config's MAC address to core.
  * Updates RXE match engine.
  */
-int brcms_c_set_mac(struct brcms_bss_cfg *cfg)
+int brcms_c_set_mac(struct brcms_bss_cfg *bsscfg)
 {
 	int err = 0;
-	struct brcms_c_info *wlc = cfg->wlc;
+	struct brcms_c_info *wlc = bsscfg->wlc;
 
-	if (cfg == wlc->cfg)
-		/* enter the MAC addr into the RXE match registers */
-		brcms_c_set_addrmatch(wlc, RCM_MAC_OFFSET, cfg->cur_etheraddr);
+	/* enter the MAC addr into the RXE match registers */
+	brcms_c_set_addrmatch(wlc, RCM_MAC_OFFSET, bsscfg->cur_etheraddr);
 
 	brcms_c_ampdu_macaddr_upd(wlc);
 
@@ -3960,13 +3959,10 @@ int brcms_c_set_mac(struct brcms_bss_cfg *cfg)
 /* Write the BSS config's BSSID address to core (set_bssid in d11procs.tcl).
  * Updates RXE match engine.
  */
-void brcms_c_set_bssid(struct brcms_bss_cfg *cfg)
+void brcms_c_set_bssid(struct brcms_bss_cfg *bsscfg)
 {
-	struct brcms_c_info *wlc = cfg->wlc;
-
-	/* if primary config, we need to update BSSID in RXE match registers */
-	if (cfg == wlc->cfg)
-		brcms_c_set_addrmatch(wlc, RCM_BSSID_OFFSET, cfg->BSSID);
+	/* we need to update BSSID in RXE match registers */
+	brcms_c_set_addrmatch(bsscfg->wlc, RCM_BSSID_OFFSET, bsscfg->BSSID);
 }
 
 static void brcms_b_set_shortslot(struct brcms_hardware *wlc_hw, bool shortslot)
@@ -5388,9 +5384,8 @@ brcms_c_attach(struct brcms_info *wl, u16 vendor, u16 device, uint unit,
 		goto fail;
 	}
 
-	wlc->bsscfg = wlc->cfg;
-	wlc->cfg->_idx = 0;
-	wlc->cfg->wlc = wlc;
+	wlc->bsscfg->_idx = 0;
+	wlc->bsscfg->wlc = wlc;
 
 	wlc->mimoft = FT_HT;
 	wlc->ht_cap.cap_info = HT_CAP;
@@ -6241,8 +6236,8 @@ static void brcms_c_ofdm_rateset_war(struct brcms_c_info *wlc)
 	u8 r;
 	bool war = false;
 
-	if (wlc->cfg->associated)
-		r = wlc->cfg->current_bss->rateset.rates[0];
+	if (wlc->bsscfg->associated)
+		r = wlc->bsscfg->current_bss->rateset.rates[0];
 	else
 		r = wlc->default_bss->rateset.rates[0];
 
@@ -6311,7 +6306,7 @@ void brcms_c_get_current_rateset(struct brcms_c_info *wlc,
 	struct brcms_c_rateset *rs;
 
 	if (wlc->pub->associated)
-		rs = &wlc->cfg->current_bss->rateset;
+		rs = &wlc->bsscfg->current_bss->rateset;
 	else
 		rs = &wlc->default_bss->rateset;
 
@@ -6337,8 +6332,8 @@ int brcms_c_set_rateset(struct brcms_c_info *wlc, struct brcm_rateset *rs)
 	/* merge rateset coming in with the current mcsset */
 	if (wlc->pub->_n_enab & SUPPORT_11N) {
 		struct brcms_bss_info *mcsset_bss;
-		if (wlc->cfg->associated)
-			mcsset_bss = wlc->cfg->current_bss;
+		if (wlc->bsscfg->associated)
+			mcsset_bss = wlc->bsscfg->current_bss;
 		else
 			mcsset_bss = wlc->default_bss;
 		memcpy(internal_rs.mcs, &mcsset_bss->rateset.mcs[0],
@@ -8096,9 +8091,7 @@ brcms_c_rspec_to_rts_rspec(struct brcms_c_info *wlc, u32 rspec,
 
 void brcms_c_tbtt(struct brcms_c_info *wlc)
 {
-	struct brcms_bss_cfg *cfg = wlc->cfg;
-
-	if (!cfg->BSS)
+	if (!wlc->bsscfg->BSS)
 		/*
 		 * DirFrmQ is now valid...defer setting until end
 		 * of ATIM window
@@ -9144,7 +9137,7 @@ brcms_c_set_addrmatch(struct brcms_c_info *wlc, int match_reg_offset,
 {
 	brcms_b_set_addrmatch(wlc->hw, match_reg_offset, addr);
 	if (match_reg_offset == RCM_BSSID_OFFSET)
-		memcpy(wlc->cfg->BSSID, addr, ETH_ALEN);
+		memcpy(wlc->bsscfg->BSSID, addr, ETH_ALEN);
 }
 
 void brcms_c_pllreq(struct brcms_c_info *wlc, bool set, u32 req_bit)
@@ -9273,7 +9266,7 @@ void brcms_c_scan_stop(struct brcms_c_info *wlc)
 void brcms_c_associate_upd(struct brcms_c_info *wlc, bool state)
 {
 	wlc->pub->associated = state;
-	wlc->cfg->associated = state;
+	wlc->bsscfg->associated = state;
 }
 
 /*
diff --git a/drivers/staging/brcm80211/brcmsmac/main.h b/drivers/staging/brcm80211/brcmsmac/main.h
index ede4aef..d6de9c3 100644
--- a/drivers/staging/brcm80211/brcmsmac/main.h
+++ b/drivers/staging/brcm80211/brcmsmac/main.h
@@ -565,7 +565,6 @@ struct brcms_c_info {
 	u16 fifo2prec_map[NFIFO];
 
 	struct brcms_bss_cfg *bsscfg;
-	struct brcms_bss_cfg *cfg;
 
 	/* tx queue */
 	struct brcms_txq_info *tx_queues;
-- 
1.7.1


