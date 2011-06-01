Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mms3.broadcom.com ([216.31.210.19]:4840 "EHLO MMS3.broadcom.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758887Ab1FALqv (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 1 Jun 2011 07:46:51 -0400
From: "Roland Vossen" <rvossen@broadcom.com>
To: gregkh@suse.de
cc: devel@linuxdriverproject.org, linux-wireless@vger.kernel.org
Subject: [PATCH 07/83] staging: brcm80211: fix compiler warning
 introduced
Date: Wed, 1 Jun 2011 13:44:52 +0200
Message-ID: <1306928768-7501-7-git-send-email-rvossen@broadcom.com> (sfid-20110601_134829_853559_480D19DF)
In-Reply-To: <1306928768-7501-1-git-send-email-rvossen@broadcom.com>
References: <1306928768-7501-1-git-send-email-rvossen@broadcom.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Arend van Spriel <arend@broadcom.com>

Patch "[0f06b6a] remove WLC_WATCHDOG_TBTT macro" resulted
in compiler warning because static function wlc_watchdog_backup_bi()
is no longer used. This has been fixed in this patch.

Signed-off-by: Arend van Spriel <arend@broadcom.com>
Reviewed-by: Roland Vossen <rvossen@broadcom.com>
---
 drivers/staging/brcm80211/brcmsmac/wlc_main.c |   16 ----------------
 1 files changed, 0 insertions(+), 16 deletions(-)

diff --git a/drivers/staging/brcm80211/brcmsmac/wlc_main.c b/drivers/staging/brcm80211/brcmsmac/wlc_main.c
index 33045d5..c1257d4 100644
--- a/drivers/staging/brcm80211/brcmsmac/wlc_main.c
+++ b/drivers/staging/brcm80211/brcmsmac/wlc_main.c
@@ -732,22 +732,6 @@ void wlc_set_chanspec(struct wlc_info *wlc, chanspec_t chanspec)
 	wlc_ucode_mac_upd(wlc);
 }
 
-static u32 wlc_watchdog_backup_bi(struct wlc_info *wlc)
-{
-	u32 bi;
-	bi = 2 * wlc->cfg->current_bss->dtim_period *
-	    wlc->cfg->current_bss->beacon_period;
-	if (wlc->bcn_li_dtim)
-		bi *= wlc->bcn_li_dtim;
-	else if (wlc->bcn_li_bcn)
-		/* recalculate bi based on bcn_li_bcn */
-		bi = 2 * wlc->bcn_li_bcn * wlc->cfg->current_bss->beacon_period;
-
-	if (bi < 2 * TIMER_INTERVAL_WATCHDOG)
-		bi = 2 * TIMER_INTERVAL_WATCHDOG;
-	return bi;
-}
-
 ratespec_t wlc_lowest_basic_rspec(struct wlc_info *wlc, wlc_rateset_t *rs)
 {
 	ratespec_t lowest_basic_rspec;
-- 
1.7.4.1


