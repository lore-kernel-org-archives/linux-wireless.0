Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mms1.broadcom.com ([216.31.210.17]:4280 "EHLO mms1.broadcom.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932416Ab1GNVaC (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 14 Jul 2011 17:30:02 -0400
From: "Franky Lin" <frankyl@broadcom.com>
To: gregkh@suse.de
cc: devel@linuxdriverproject.org, linux-wireless@vger.kernel.org
Subject: [PATCH 17/35] staging: brcm80211: modify the FOREACH_BSS macro
Date: Thu, 14 Jul 2011 14:29:13 -0700
Message-ID: <1310678971-28952-18-git-send-email-frankyl@broadcom.com> (sfid-20110714_233026_314307_4E681D0F)
In-Reply-To: <1310678971-28952-1-git-send-email-frankyl@broadcom.com>
References: <1310678971-28952-1-git-send-email-frankyl@broadcom.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Arend van Spriel <arend@broadcom.com>

The FOREACH_BSS macro was changed to remove a checkpatch error. However,
the patch was considered ugly. This patch is another attempt to make it
more clear.

Reported-by: Dan Carpenter <error27@gmail.com>
Signed-off-by: Arend van Spriel <arend@broadcom.com>
Reviewed-by: Roland Vossen <rvossen@broadcom.com>
---
 drivers/staging/brcm80211/brcmsmac/main.c |   48 ++++++++++++++++------------
 1 files changed, 27 insertions(+), 21 deletions(-)

diff --git a/drivers/staging/brcm80211/brcmsmac/main.c b/drivers/staging/brcm80211/brcmsmac/main.c
index d3c325c..3509361 100644
--- a/drivers/staging/brcm80211/brcmsmac/main.c
+++ b/drivers/staging/brcm80211/brcmsmac/main.c
@@ -250,10 +250,14 @@
 #define BSSCFG_STA(cfg)		(1)
 #define BSSCFG_IBSS(cfg)	(!(cfg)->BSS)
 
-/* As above for all non-NULL BSS configs */
+/* iterate through all valid bsscfg entries */
 #define FOREACH_BSS(wlc, idx, cfg) \
-	for (idx = 0; (int) idx < BRCMS_MAXBSSCFG; idx++) \
-		if ((cfg = (wlc)->bsscfg[idx]))
+	for (idx = 0; (int) idx < BRCMS_MAXBSSCFG; idx++) { \
+		cfg = (wlc)->bsscfg[idx]; \
+		if (!cfg) \
+			continue;
+/* close marker for iterator code block */
+#define END_FOREACH_BSS		}
 
 /* Shared memory location index for various AC params */
 #define wme_shmemacindex(ac)	wme_ac2fifo[ac]
@@ -3315,14 +3319,14 @@ void brcms_c_init(struct brcms_c_info *wlc)
 	brcms_c_reprate_init(wlc);
 
 	/* write ethernet address to core */
-	FOREACH_BSS(wlc, i, bsscfg) {
+	FOREACH_BSS(wlc, i, bsscfg)
 		brcms_c_set_mac(bsscfg);
 		brcms_c_set_bssid(bsscfg);
-	}
+	END_FOREACH_BSS
 
 	/* Update tsf_cfprep if associated and up */
 	if (wlc->pub->associated) {
-		FOREACH_BSS(wlc, i, bsscfg) {
+		FOREACH_BSS(wlc, i, bsscfg)
 			if (bsscfg->up) {
 				u32 bi;
 
@@ -3340,7 +3344,7 @@ void brcms_c_init(struct brcms_c_info *wlc)
 
 				break;
 			}
-		}
+		END_FOREACH_BSS
 	}
 
 	brcms_c_bandinit_ordered(wlc, chanspec);
@@ -3540,7 +3544,7 @@ void brcms_c_switch_shortslot(struct brcms_c_info *wlc, bool shortslot)
 	wlc->shortslot = shortslot;
 
 	/* update the capability based on current shortslot mode */
-	FOREACH_BSS(wlc, idx, cfg) {
+	FOREACH_BSS(wlc, idx, cfg)
 		if (!cfg->associated)
 			continue;
 		cfg->current_bss->capability &=
@@ -3548,7 +3552,8 @@ void brcms_c_switch_shortslot(struct brcms_c_info *wlc, bool shortslot)
 		if (wlc->shortslot)
 			cfg->current_bss->capability |=
 					WLAN_CAPABILITY_SHORT_SLOT_TIME;
-	}
+	END_FOREACH_BSS
+
 
 	brcms_b_set_shortslot(wlc->hw, shortslot);
 }
@@ -3589,12 +3594,13 @@ void brcms_c_set_home_chanspec(struct brcms_c_info *wlc, u16 chanspec)
 
 		wlc->home_chanspec = chanspec;
 
-		FOREACH_BSS(wlc, idx, cfg) {
+		FOREACH_BSS(wlc, idx, cfg)
 			if (!cfg->associated)
 				continue;
 
 			cfg->current_bss->chanspec = chanspec;
-		}
+		END_FOREACH_BSS
+
 
 	}
 }
@@ -5309,14 +5315,14 @@ static void brcms_c_watchdog(void *arg)
 		brcms_c_statsupd(wlc);
 
 	/* Manage TKIP countermeasures timers */
-	FOREACH_BSS(wlc, i, cfg) {
+	FOREACH_BSS(wlc, i, cfg)
 		if (cfg->tk_cm_dt) {
 			cfg->tk_cm_dt--;
 		}
 		if (cfg->tk_cm_bt) {
 			cfg->tk_cm_bt--;
 		}
-	}
+	END_FOREACH_BSS
 
 	/* Call any registered watchdog handlers */
 	for (i = 0; i < BRCMS_MAXMODULES; i++) {
@@ -5474,7 +5480,7 @@ int brcms_c_up(struct brcms_c_info *wlc)
 				mboolset(wlc->pub->radio_disabled,
 					 WL_RADIO_HW_DISABLE);
 
-				FOREACH_BSS(wlc, idx, bsscfg) {
+				FOREACH_BSS(wlc, idx, bsscfg)
 					if (!BSSCFG_STA(bsscfg)
 					    || !bsscfg->enable || !bsscfg->BSS)
 						continue;
@@ -5482,7 +5488,7 @@ int brcms_c_up(struct brcms_c_info *wlc)
 						  ": rfdisable -> "
 						  "bsscfg_disable()\n",
 						   wlc->pub->unit, idx);
-				}
+				END_FOREACH_BSS
 			}
 		}
 	}
@@ -8918,10 +8924,10 @@ void brcms_c_update_beacon(struct brcms_c_info *wlc)
 	struct brcms_bss_cfg *bsscfg;
 
 	/* update AP or IBSS beacons */
-	FOREACH_BSS(wlc, idx, bsscfg) {
+	FOREACH_BSS(wlc, idx, bsscfg)
 		if (bsscfg->up && (BSSCFG_AP(bsscfg) || !bsscfg->BSS))
 			brcms_c_bss_update_beacon(wlc, bsscfg);
-	}
+	END_FOREACH_BSS
 }
 
 /* Write ssid into shared memory */
@@ -8947,10 +8953,10 @@ void brcms_c_update_probe_resp(struct brcms_c_info *wlc, bool suspend)
 	struct brcms_bss_cfg *bsscfg;
 
 	/* update AP or IBSS probe responses */
-	FOREACH_BSS(wlc, idx, bsscfg) {
+	FOREACH_BSS(wlc, idx, bsscfg)
 		if (bsscfg->up && (BSSCFG_AP(bsscfg) || !bsscfg->BSS))
 			brcms_c_bss_update_probe_resp(wlc, bsscfg, suspend);
-	}
+	END_FOREACH_BSS
 }
 
 void
@@ -9031,9 +9037,9 @@ void brcms_c_reprate_init(struct brcms_c_info *wlc)
 	int i;
 	struct brcms_bss_cfg *bsscfg;
 
-	FOREACH_BSS(wlc, i, bsscfg) {
+	FOREACH_BSS(wlc, i, bsscfg)
 		brcms_c_bsscfg_reprate_init(bsscfg);
-	}
+	END_FOREACH_BSS
 }
 
 /* per bsscfg init tx reported rate mechanism */
-- 
1.7.1


