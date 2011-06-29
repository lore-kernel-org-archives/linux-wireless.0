Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mms1.broadcom.com ([216.31.210.17]:1914 "EHLO mms1.broadcom.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754370Ab1F2Xsd (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 29 Jun 2011 19:48:33 -0400
From: "Franky Lin" <frankyl@broadcom.com>
To: gregkh@suse.de
cc: devel@linuxdriverproject.org, linux-wireless@vger.kernel.org
Subject: [PATCH 016/119] staging: brcm80211: remove macro FOREACH_AS_STA
Date: Wed, 29 Jun 2011 16:46:40 -0700
Message-ID: <1309391303-22741-17-git-send-email-frankyl@broadcom.com> (sfid-20110630_014843_826824_BA32F4A0)
In-Reply-To: <1309391303-22741-1-git-send-email-frankyl@broadcom.com>
References: <1309391303-22741-1-git-send-email-frankyl@broadcom.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Arend van Spriel <arend@broadcom.com>

The macro definition FOREACH_AS_STA does an assignment inside the
if condition, which is considered a checkpatch error. It has been
removed.

Signed-off-by: Arend van Spriel <arend@broadcom.com>
Reviewed-by: Roland Vossen <rvossen@broadcom.com>
---
 drivers/staging/brcm80211/brcmsmac/main.c |   31 +++++++++++++++-------------
 1 files changed, 17 insertions(+), 14 deletions(-)

diff --git a/drivers/staging/brcm80211/brcmsmac/main.c b/drivers/staging/brcm80211/brcmsmac/main.c
index 093f3bf..f7ebaf1 100644
--- a/drivers/staging/brcm80211/brcmsmac/main.c
+++ b/drivers/staging/brcm80211/brcmsmac/main.c
@@ -252,12 +252,6 @@ const u8 wlc_prio2prec_map[] = {
 #define BSSCFG_STA(cfg)		(1)
 #define BSSCFG_IBSS(cfg)	(!(cfg)->BSS)
 
-/* Iterator for "associated" STA bss configs:
-   (struct brcms_c_info *wlc, int idx, struct brcms_c_bsscfg *cfg) */
-#define FOREACH_AS_STA(wlc, idx, cfg) \
-	for (idx = 0; (int) idx < WLC_MAXBSSCFG; idx++) \
-		if ((cfg = (wlc)->bsscfg[idx]) && BSSCFG_STA(cfg) && cfg->associated)
-
 /* As above for all non-NULL BSS configs */
 #define FOREACH_BSS(wlc, idx, cfg) \
 	for (idx = 0; (int) idx < WLC_MAXBSSCFG; idx++) \
@@ -396,13 +390,19 @@ bool brcms_c_ps_allowed(struct brcms_c_info *wlc)
 	if (AP_ACTIVE(wlc) || wlc->monitor)
 		return false;
 
-	FOREACH_AS_STA(wlc, idx, cfg) {
-		/* disallow PS when one of the following bsscfg specific conditions meets */
-		if (!cfg->BSS || !WLC_PORTOPEN(cfg))
-			return false;
+	for (idx = 0; idx < WLC_MAXBSSCFG; idx++) {
+		cfg = wlc->bsscfg[idx];
+		if (cfg && BSSCFG_STA(cfg) && cfg->associated) {
+			/*
+			 * disallow PS when one of the following
+			 * bsscfg specific conditions meets
+			 */
+			if (!cfg->BSS || !WLC_PORTOPEN(cfg))
+				return false;
 
-		if (!cfg->dtim_programmed)
-			return false;
+			if (!cfg->dtim_programmed)
+				return false;
+		}
 	}
 
 	return true;
@@ -1060,8 +1060,11 @@ static void WLBANDINITFN(brcms_c_setband) (struct brcms_c_info *wlc,
 		return;
 
 	/* wait for at least one beacon before entering sleeping state */
-	FOREACH_AS_STA(wlc, idx, cfg)
-	    cfg->PMawakebcn = true;
+	for (idx = 0; idx < WLC_MAXBSSCFG; idx++) {
+		cfg = wlc->bsscfg[idx];
+		if (cfg && BSSCFG_STA(cfg) && cfg->associated)
+			cfg->PMawakebcn = true;
+	}
 	brcms_c_set_ps_ctrl(wlc);
 
 	/* band-specific initializations */
-- 
1.7.1


