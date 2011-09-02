Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mms2.broadcom.com ([216.31.210.18]:1779 "EHLO mms2.broadcom.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752279Ab1IBOAz (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 2 Sep 2011 10:00:55 -0400
From: "Roland Vossen" <rvossen@broadcom.com>
To: gregkh@suse.de
cc: devel@linuxdriverproject.org, linux-wireless@vger.kernel.org
Subject: [PATCH 09/12] staging: brcm80211: remove AP related code from
 softmac
Date: Fri, 2 Sep 2011 16:00:36 +0200
Message-ID: <1314972039-27098-10-git-send-email-rvossen@broadcom.com> (sfid-20110902_160108_499234_CAE996B0)
In-Reply-To: <1314972039-27098-1-git-send-email-rvossen@broadcom.com>
References: <1314972039-27098-1-git-send-email-rvossen@broadcom.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

AP support was only partially implemented and never invoked.
AP related code sections removed.

Reported-by: Johannes Berg <johannes@sipsolutions.net>
Reviewed-by: Pieter-Paul Giesberts <pieterpg@broadcom.com>
Reviewed-by: Arend van Spriel <arend@broadcom.com>
Signed-off-by: Roland Vossen <rvossen@broadcom.com>
---
 drivers/staging/brcm80211/brcmsmac/main.c |   64 ++++-------------------------
 drivers/staging/brcm80211/brcmsmac/pub.h  |   11 +-----
 2 files changed, 10 insertions(+), 65 deletions(-)

diff --git a/drivers/staging/brcm80211/brcmsmac/main.c b/drivers/staging/brcm80211/brcmsmac/main.c
index fff3ba9..4de57f4 100644
--- a/drivers/staging/brcm80211/brcmsmac/main.c
+++ b/drivers/staging/brcm80211/brcmsmac/main.c
@@ -193,7 +193,7 @@
  * for maintenance tasks such as phy calibration and scb update
  */
 
-#define BRCMS_WAR16165(wlc) ((!AP_ENAB(wlc->pub)) && (wlc->war16165))
+#define BRCMS_WAR16165(wlc) (wlc->war16165)
 
 /* Find basic rate for a given rate */
 #define BRCMS_BASIC_RATE(wlc, rspec) \
@@ -780,11 +780,6 @@ bool brcms_c_dpc(struct brcms_c_info *wlc, bool bounded)
 
 	WARN_ON(macintstatus & MI_PRQ); /* PRQ Interrupt in non-MBSS */
 
-	/* BCN template is available */
-	if (AP_ENAB(wlc->pub) && (!APSTA_ENAB(wlc->pub))
-	    && (macintstatus & MI_BCNTPL))
-		brcms_c_update_beacon(wlc);
-
 	/* tx status */
 	if (macintstatus & MI_TFS) {
 		if (brcms_b_txstatus(wlc->hw, bounded, &fatal))
@@ -3596,8 +3591,7 @@ void brcms_c_mac_bcn_promisc_change(struct brcms_c_info *wlc, bool promisc)
 
 void brcms_c_mac_bcn_promisc(struct brcms_c_info *wlc)
 {
-	if ((AP_ENAB(wlc->pub) && (N_ENAB(wlc->pub) || wlc->band->gmode)) ||
-	    wlc->bcnmisc_ibss || wlc->bcnmisc_scan || wlc->bcnmisc_monitor)
+	if (wlc->bcnmisc_ibss || wlc->bcnmisc_scan || wlc->bcnmisc_monitor)
 		brcms_c_mctrl(wlc, MCTL_BCNS_PROMISC, MCTL_BCNS_PROMISC);
 	else
 		brcms_c_mctrl(wlc, MCTL_BCNS_PROMISC, 0);
@@ -3614,7 +3608,7 @@ void brcms_c_mac_promisc(struct brcms_c_info *wlc)
 	 * the MCTL_PROMISC bit since all BSS data traffic is
 	 * directed at the AP
 	 */
-	if (PROMISC_ENAB(wlc->pub) && !AP_ENAB(wlc->pub))
+	if (PROMISC_ENAB(wlc->pub))
 		promisc_bits |= MCTL_PROMISC;
 
 	/* monitor mode needs both MCTL_PROMISC and MCTL_KEEPCONTROL
@@ -4129,11 +4123,6 @@ void brcms_c_edcf_setparams(struct brcms_c_info *wlc, bool suspend)
 	if (suspend)
 		brcms_c_suspend_mac_and_wait(wlc);
 
-	if (AP_ENAB(wlc->pub) && WME_ENAB(wlc->pub)) {
-		brcms_c_update_beacon(wlc);
-		brcms_c_update_probe_resp(wlc, false);
-	}
-
 	if (suspend)
 		brcms_c_enable_mac(wlc);
 
@@ -4146,11 +4135,8 @@ static void brcms_c_down_led_upd(struct brcms_c_info *wlc)
 	 * maintain LEDs while in down state, turn on sbclk if
 	 * not available yet. Turn on sbclk if necessary
 	 */
-	if (!AP_ENAB(wlc->pub)) {
-		brcms_c_pllreq(wlc, true, BRCMS_PLLREQ_FLIP);
-
-		brcms_c_pllreq(wlc, false, BRCMS_PLLREQ_FLIP);
-	}
+	brcms_c_pllreq(wlc, true, BRCMS_PLLREQ_FLIP);
+	brcms_c_pllreq(wlc, false, BRCMS_PLLREQ_FLIP);
 }
 
 static bool brcms_c_radio_monitor_start(struct brcms_c_info *wlc)
@@ -5394,12 +5380,8 @@ uint brcms_c_detach(struct brcms_c_info *wlc)
 /* update state that depends on the current value of "ap" */
 void brcms_c_ap_upd(struct brcms_c_info *wlc)
 {
-	if (AP_ENAB(wlc->pub))
-		/* AP: short not allowed, but not enforced */
-		wlc->PLCPHdr_override = BRCMS_PLCP_AUTO;
-	else
-		/* STA-BSS; short capable */
-		wlc->PLCPHdr_override = BRCMS_PLCP_SHORT;
+	/* STA-BSS; short capable */
+	wlc->PLCPHdr_override = BRCMS_PLCP_SHORT;
 
 	/* fixup mpc */
 	wlc->mpc = true;
@@ -5678,10 +5660,6 @@ int brcms_c_up(struct brcms_c_info *wlc)
 
 	brcms_b_up_finish(wlc->hw);
 
-	/* other software states up after ISR is running */
-	/* start APs that were to be brought up but are not up  yet */
-	/* if (AP_ENAB(wlc->pub)) brcms_c_restart_ap(wlc->ap); */
-
 	/* Program the TX wme params with the current settings */
 	brcms_c_wme_retries_write(wlc);
 
@@ -5900,9 +5878,6 @@ int brcms_c_set_gmode(struct brcms_c_info *wlc, u8 gmode, bool config)
 		break;
 
 	case GMODE_LRS:
-		if (AP_ENAB(wlc->pub))
-			brcms_c_rateset_copy(&cck_rates,
-					     &wlc->sup_rates_override);
 		break;
 
 	case GMODE_AUTO:
@@ -5916,11 +5891,6 @@ int brcms_c_set_gmode(struct brcms_c_info *wlc, u8 gmode, bool config)
 		break;
 
 	case GMODE_PERFORMANCE:
-		if (AP_ENAB(wlc->pub))
-			/* Put all rates into the Supported Rates element */
-			brcms_c_rateset_copy(&cck_ofdm_rates,
-					 &wlc->sup_rates_override);
-
 		shortslot = BRCMS_SHORTSLOT_ON;
 		shortslot_restrict = true;
 		ofdm_basic = true;
@@ -5953,21 +5923,13 @@ int brcms_c_set_gmode(struct brcms_c_info *wlc, u8 gmode, bool config)
 
 	wlc->shortslot_override = shortslot;
 
-	if (AP_ENAB(wlc->pub))
-		/* wlc->ap->shortslot_restrict = shortslot_restrict; */
-		wlc->PLCPHdr_override =
-		    (preamble !=
-		     BRCMS_PLCP_LONG) ? BRCMS_PLCP_SHORT : BRCMS_PLCP_AUTO;
-
-	if ((AP_ENAB(wlc->pub) && preamble != BRCMS_PLCP_LONG)
-	    || preamble == BRCMS_PLCP_SHORT)
+	if (preamble == BRCMS_PLCP_SHORT)
 		wlc->default_bss->capability |= WLAN_CAPABILITY_SHORT_PREAMBLE;
 	else
 		wlc->default_bss->capability &= ~WLAN_CAPABILITY_SHORT_PREAMBLE;
 
 	/* Update shortslot capability bit for AP and IBSS */
-	if ((AP_ENAB(wlc->pub) && shortslot == BRCMS_SHORTSLOT_AUTO) ||
-	    shortslot == BRCMS_SHORTSLOT_ON)
+	if (shortslot == BRCMS_SHORTSLOT_ON)
 		wlc->default_bss->capability |= WLAN_CAPABILITY_SHORT_SLOT_TIME;
 	else
 		wlc->default_bss->capability &=
@@ -8359,20 +8321,12 @@ brcms_c_txfifo_complete(struct brcms_c_info *wlc, uint fifo, s8 txpktpend)
 	/* There is more room; mark precedences related to this FIFO sendable */
 	BRCMS_TX_FIFO_ENAB(wlc, fifo);
 
-	/* Clear MHF2_TXBCMC_NOW flag if BCMC fifo has drained */
-	if (AP_ENAB(wlc->pub) &&
-	    !TXPKTPENDGET(wlc, TX_BCMC_FIFO))
-		brcms_c_mhf(wlc, MHF2, MHF2_TXBCMC_NOW, 0, BRCM_BAND_AUTO);
-
 	/* figure out which bsscfg is being worked on... */
 }
 
 /* Update beacon listen interval in shared memory */
 void brcms_c_bcn_li_upd(struct brcms_c_info *wlc)
 {
-	if (AP_ENAB(wlc->pub))
-		return;
-
 	/* wake up every DTIM is the default */
 	if (wlc->bcn_li_dtim == 1)
 		brcms_c_write_shm(wlc, M_BCN_LI, 0);
diff --git a/drivers/staging/brcm80211/brcmsmac/pub.h b/drivers/staging/brcm80211/brcmsmac/pub.h
index ab2fb11..a56239a 100644
--- a/drivers/staging/brcm80211/brcmsmac/pub.h
+++ b/drivers/staging/brcm80211/brcmsmac/pub.h
@@ -285,22 +285,13 @@ enum wlc_par_id {
  * *********************************************
  */
 
-/* AP Support (versus STA) */
-#define	AP_ENAB(pub)	(0)
-
-/* Macro to check if APSTA mode enabled */
-#define APSTA_ENAB(pub)	(0)
-
-/* Some useful combinations */
-#define STA_ONLY(pub)	(!AP_ENAB(pub))
-#define AP_ONLY(pub)	(AP_ENAB(pub) && !APSTA_ENAB(pub))
-
 #define ENAB_1x1	0x01
 #define ENAB_2x2	0x02
 #define ENAB_3x3	0x04
 #define ENAB_4x4	0x08
 #define SUPPORT_11N	(ENAB_1x1|ENAB_2x2)
 #define SUPPORT_HT	(ENAB_1x1|ENAB_2x2|ENAB_3x3)
+
 /* WL11N Support */
 #define N_ENAB(pub) ((pub)->_n_enab & SUPPORT_11N)
 #define N_REQD(pub) ((pub)->_n_reqd)
-- 
1.7.4.1


