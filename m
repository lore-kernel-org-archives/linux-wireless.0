Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mms2.broadcom.com ([216.31.210.18]:1683 "EHLO mms2.broadcom.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752900Ab1HHN71 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 8 Aug 2011 09:59:27 -0400
From: "Arend van Spriel" <arend@broadcom.com>
To: gregkh@suse.de
cc: devel@linuxdriverproject.org, linux-wireless@vger.kernel.org,
	"Arend van Spriel" <arend@broadcom.com>
Subject: [PATCHv2 18/82] staging: brcm80211: modify the FOREACH_BSS
 macro
Date: Mon, 8 Aug 2011 15:58:02 +0200
Message-ID: <1312811946-16713-19-git-send-email-arend@broadcom.com> (sfid-20110808_160210_894776_4BDC8345)
In-Reply-To: <1312811946-16713-1-git-send-email-arend@broadcom.com>
References: <1312811946-16713-1-git-send-email-arend@broadcom.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

The FOREACH_BSS macro was changed to remove a checkpatch error. However,
the patch was considered ugly. This patch is another attempt to make it
more clear. END_FOREACH_BSS is defined with braces to avoid an invalid
checkpatch.pl warning. Ideally, the checkpatch.pl script should be adapted
but lacking good perl knowledge to do so.

Reported-by: Dan Carpenter <error27@gmail.com>
Reviewed-by: Pieter-Paul Giesberts <pieterpg@broadcom.com>
Reviewed-by: Roland Vossen <rvossen@broadcom.com>
Signed-off-by: Arend van Spriel <arend@broadcom.com>
---
 drivers/staging/brcm80211/brcmsmac/main.c |   47 ++++++++++++++++-------------
 1 files changed, 26 insertions(+), 21 deletions(-)

diff --git a/drivers/staging/brcm80211/brcmsmac/main.c b/drivers/staging/brcm80211/brcmsmac/main.c
index d3c325c..d5f570a 100644
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
+#define END_FOREACH_BSS()	}
 
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
+	END_FOREACH_BSS()
 
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
+		END_FOREACH_BSS()
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
@@ -3548,7 +3552,7 @@ void brcms_c_switch_shortslot(struct brcms_c_info *wlc, bool shortslot)
 		if (wlc->shortslot)
 			cfg->current_bss->capability |=
 					WLAN_CAPABILITY_SHORT_SLOT_TIME;
-	}
+	END_FOREACH_BSS()
 
 	brcms_b_set_shortslot(wlc->hw, shortslot);
 }
@@ -3589,12 +3593,13 @@ void brcms_c_set_home_chanspec(struct brcms_c_info *wlc, u16 chanspec)
 
 		wlc->home_chanspec = chanspec;
 
-		FOREACH_BSS(wlc, idx, cfg) {
+		FOREACH_BSS(wlc, idx, cfg)
 			if (!cfg->associated)
 				continue;
 
 			cfg->current_bss->chanspec = chanspec;
-		}
+		END_FOREACH_BSS()
+
 
 	}
 }
@@ -5309,14 +5314,14 @@ static void brcms_c_watchdog(void *arg)
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
+	END_FOREACH_BSS()
 
 	/* Call any registered watchdog handlers */
 	for (i = 0; i < BRCMS_MAXMODULES; i++) {
@@ -5474,7 +5479,7 @@ int brcms_c_up(struct brcms_c_info *wlc)
 				mboolset(wlc->pub->radio_disabled,
 					 WL_RADIO_HW_DISABLE);
 
-				FOREACH_BSS(wlc, idx, bsscfg) {
+				FOREACH_BSS(wlc, idx, bsscfg)
 					if (!BSSCFG_STA(bsscfg)
 					    || !bsscfg->enable || !bsscfg->BSS)
 						continue;
@@ -5482,7 +5487,7 @@ int brcms_c_up(struct brcms_c_info *wlc)
 						  ": rfdisable -> "
 						  "bsscfg_disable()\n",
 						   wlc->pub->unit, idx);
-				}
+				END_FOREACH_BSS()
 			}
 		}
 	}
@@ -8918,10 +8923,10 @@ void brcms_c_update_beacon(struct brcms_c_info *wlc)
 	struct brcms_bss_cfg *bsscfg;
 
 	/* update AP or IBSS beacons */
-	FOREACH_BSS(wlc, idx, bsscfg) {
+	FOREACH_BSS(wlc, idx, bsscfg)
 		if (bsscfg->up && (BSSCFG_AP(bsscfg) || !bsscfg->BSS))
 			brcms_c_bss_update_beacon(wlc, bsscfg);
-	}
+	END_FOREACH_BSS()
 }
 
 /* Write ssid into shared memory */
@@ -8947,10 +8952,10 @@ void brcms_c_update_probe_resp(struct brcms_c_info *wlc, bool suspend)
 	struct brcms_bss_cfg *bsscfg;
 
 	/* update AP or IBSS probe responses */
-	FOREACH_BSS(wlc, idx, bsscfg) {
+	FOREACH_BSS(wlc, idx, bsscfg)
 		if (bsscfg->up && (BSSCFG_AP(bsscfg) || !bsscfg->BSS))
 			brcms_c_bss_update_probe_resp(wlc, bsscfg, suspend);
-	}
+	END_FOREACH_BSS()
 }
 
 void
@@ -9031,9 +9036,9 @@ void brcms_c_reprate_init(struct brcms_c_info *wlc)
 	int i;
 	struct brcms_bss_cfg *bsscfg;
 
-	FOREACH_BSS(wlc, i, bsscfg) {
+	FOREACH_BSS(wlc, i, bsscfg)
 		brcms_c_bsscfg_reprate_init(bsscfg);
-	}
+	END_FOREACH_BSS()
 }
 
 /* per bsscfg init tx reported rate mechanism */
-- 
1.7.4.1


