Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mms2.broadcom.com ([216.31.210.18]:3347 "EHLO mms2.broadcom.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755042Ab1GVS5e (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 22 Jul 2011 14:57:34 -0400
From: "Arend van Spriel" <arend@broadcom.com>
To: gregkh@suse.de
cc: "Arend van Spriel" <arend@broadcom.com>,
	devel@linuxdriverproject.org, linux-wireless@vger.kernel.org
Subject: [PATCH 13/29] staging: brcm80211: revisited END_FOREACH_BSS
 macro
Date: Fri, 22 Jul 2011 20:57:00 +0200
Message-ID: <1311361036-3175-14-git-send-email-arend@broadcom.com> (sfid-20110722_205846_324600_8DE3CF1A)
In-Reply-To: <1311361036-3175-1-git-send-email-arend@broadcom.com>
References: <1311361036-3175-1-git-send-email-arend@broadcom.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

The definition of END_FOREACH_BSS macro resulted in an invalid
checkpatch.pl warning. By adding braces to the macro this warning
goes away. Ideally, the checkpatch.pl script should be adapted
but lacking good perl knowledge to do so.

Cc: devel@linuxdriverproject.org
Cc: linux-wireless@vger.kernel.org
Reported-by: Dan Carpenter <error27@gmail.com>
Reviewed-by: Pieter-Paul Giesberts <pieterpg@broadcom.com>
Reviewed-by: Roland Vossen <rvossen@broadcom.com>
Signed-off-by: Arend van Spriel <arend@broadcom.com>
---
 drivers/staging/brcm80211/brcmsmac/main.c |   20 ++++++++++----------
 1 files changed, 10 insertions(+), 10 deletions(-)

diff --git a/drivers/staging/brcm80211/brcmsmac/main.c b/drivers/staging/brcm80211/brcmsmac/main.c
index e67bf64..f5f914f 100644
--- a/drivers/staging/brcm80211/brcmsmac/main.c
+++ b/drivers/staging/brcm80211/brcmsmac/main.c
@@ -270,7 +270,7 @@
 		if (!cfg) \
 			continue;
 /* close marker for iterator code block */
-#define END_FOREACH_BSS		}
+#define END_FOREACH_BSS()	}
 
 /* Shared memory location index for various AC params */
 #define wme_shmemacindex(ac)	wme_ac2fifo[ac]
@@ -3345,7 +3345,7 @@ void brcms_c_init(struct brcms_c_info *wlc)
 	FOREACH_BSS(wlc, i, bsscfg)
 		brcms_c_set_mac(bsscfg);
 		brcms_c_set_bssid(bsscfg);
-	END_FOREACH_BSS
+	END_FOREACH_BSS()
 
 	/* Update tsf_cfprep if associated and up */
 	if (wlc->pub->associated) {
@@ -3367,7 +3367,7 @@ void brcms_c_init(struct brcms_c_info *wlc)
 
 				break;
 			}
-		END_FOREACH_BSS
+		END_FOREACH_BSS()
 	}
 
 	brcms_c_bandinit_ordered(wlc, chanspec);
@@ -3577,7 +3577,7 @@ void brcms_c_switch_shortslot(struct brcms_c_info *wlc, bool shortslot)
 		if (wlc->shortslot)
 			cfg->current_bss->capability |=
 					WLAN_CAPABILITY_SHORT_SLOT_TIME;
-	END_FOREACH_BSS /* this comment fixes a checkpatch warning */
+	END_FOREACH_BSS()
 
 	brcms_b_set_shortslot(wlc->hw, shortslot);
 }
@@ -3626,7 +3626,7 @@ void brcms_c_set_home_chanspec(struct brcms_c_info *wlc, u16 chanspec)
 				continue;
 
 			cfg->current_bss->chanspec = chanspec;
-		END_FOREACH_BSS
+		END_FOREACH_BSS()
 
 
 	}
@@ -5384,7 +5384,7 @@ static void brcms_c_watchdog(void *arg)
 			cfg->tk_cm_dt--;
 		if (cfg->tk_cm_bt)
 			cfg->tk_cm_bt--;
-	END_FOREACH_BSS
+	END_FOREACH_BSS()
 
 	/* Call any registered watchdog handlers */
 	for (i = 0; i < BRCMS_MAXMODULES; i++) {
@@ -5557,7 +5557,7 @@ int brcms_c_up(struct brcms_c_info *wlc)
 						  ": rfdisable -> "
 						  "bsscfg_disable()\n",
 						   wlc->pub->unit, idx);
-				END_FOREACH_BSS
+				END_FOREACH_BSS()
 			}
 		}
 	}
@@ -9075,7 +9075,7 @@ void brcms_c_update_beacon(struct brcms_c_info *wlc)
 	FOREACH_BSS(wlc, idx, bsscfg)
 		if (bsscfg->up && (BSSCFG_AP(bsscfg) || !bsscfg->BSS))
 			brcms_c_bss_update_beacon(wlc, bsscfg);
-	END_FOREACH_BSS
+	END_FOREACH_BSS()
 }
 
 /* Write ssid into shared memory */
@@ -9104,7 +9104,7 @@ void brcms_c_update_probe_resp(struct brcms_c_info *wlc, bool suspend)
 	FOREACH_BSS(wlc, idx, bsscfg)
 		if (bsscfg->up && (BSSCFG_AP(bsscfg) || !bsscfg->BSS))
 			brcms_c_bss_update_probe_resp(wlc, bsscfg, suspend);
-	END_FOREACH_BSS
+	END_FOREACH_BSS()
 }
 
 void
@@ -9191,7 +9191,7 @@ void brcms_c_reprate_init(struct brcms_c_info *wlc)
 
 	FOREACH_BSS(wlc, i, bsscfg)
 		brcms_c_bsscfg_reprate_init(bsscfg);
-	END_FOREACH_BSS
+	END_FOREACH_BSS()
 }
 
 /* per bsscfg init tx reported rate mechanism */
-- 
1.7.4.1


