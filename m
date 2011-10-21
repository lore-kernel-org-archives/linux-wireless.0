Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mms3.broadcom.com ([216.31.210.19]:2888 "EHLO MMS3.broadcom.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754823Ab1JUOQu (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 21 Oct 2011 10:16:50 -0400
From: "Arend van Spriel" <arend@broadcom.com>
To: linville@tuxdriver.com
cc: linux-wireless@vger.kernel.org,
	"Roland Vossen" <rvossen@broadcom.com>,
	"Arend van Spriel" <arend@broadcom.com>
Subject: [PATCH v2 03/17] brcm80211: smac: removed MPC related code
Date: Fri, 21 Oct 2011 16:16:21 +0200
Message-ID: <1319206595-17138-4-git-send-email-arend@broadcom.com> (sfid-20111021_161714_246262_2A394413)
In-Reply-To: <1319206595-17138-1-git-send-email-arend@broadcom.com>
References: <1319206595-17138-1-git-send-email-arend@broadcom.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Roland Vossen <rvossen@broadcom.com>

The chip init sequence enables MPC (Minimum Power Consumption), but the
driver disables it after that. As there are no interfaces to enable this
mode the related code is unused (member variable wlc->mpc is false).

Reviewed-by: Alwin Beukers <alwin@broadcom.com>
Reviewed-by: Arend van Spriel <arend@broadcom.com>
Reviewed-by: Pieter-Paul Giesberts <pieterpg@broadcom.com>
Signed-off-by: Roland Vossen <rvossen@broadcom.com>
Signed-off-by: Arend van Spriel <arend@broadcom.com>
---
 .../net/wireless/brcm80211/brcmsmac/mac80211_if.c  |    2 +-
 drivers/net/wireless/brcm80211/brcmsmac/main.c     |   70 ++------------------
 drivers/net/wireless/brcm80211/brcmsmac/main.h     |    2 -
 drivers/net/wireless/brcm80211/brcmsmac/pub.h      |    2 +-
 4 files changed, 8 insertions(+), 68 deletions(-)

diff --git a/drivers/net/wireless/brcm80211/brcmsmac/mac80211_if.c b/drivers/net/wireless/brcm80211/brcmsmac/mac80211_if.c
index 7a24a83..1781157 100644
--- a/drivers/net/wireless/brcm80211/brcmsmac/mac80211_if.c
+++ b/drivers/net/wireless/brcm80211/brcmsmac/mac80211_if.c
@@ -1079,7 +1079,7 @@ static struct brcms_info *brcms_attach(u16 vendor, u16 device,
 	wl->pub->ieee_hw = hw;
 
 	/* disable mpc */
-	brcms_c_set_radio_mpc(wl->wlc, false);
+	brcms_c_set_radio_mpc(wl->wlc);
 
 	/* register our interrupt handler */
 	if (request_irq(irq, brcms_isr, IRQF_SHARED, KBUILD_MODNAME, wl)) {
diff --git a/drivers/net/wireless/brcm80211/brcmsmac/main.c b/drivers/net/wireless/brcm80211/brcmsmac/main.c
index 4f1d6e4..4687983 100644
--- a/drivers/net/wireless/brcm80211/brcmsmac/main.c
+++ b/drivers/net/wireless/brcm80211/brcmsmac/main.c
@@ -419,20 +419,6 @@ static int brcms_chspec_bw(u16 chanspec)
 	return BRCMS_10_MHZ;
 }
 
-/*
- * return true if Minimum Power Consumption should
- * be entered, false otherwise
- */
-static bool brcms_c_is_non_delay_mpc(struct brcms_c_info *wlc)
-{
-	return false;
-}
-
-static bool brcms_c_ismpc(struct brcms_c_info *wlc)
-{
-	return (wlc->mpc_delay_off == 0) && (brcms_c_is_non_delay_mpc(wlc));
-}
-
 static void brcms_c_bsscfg_mfree(struct brcms_bss_cfg *cfg)
 {
 	if (cfg == NULL)
@@ -4350,56 +4336,18 @@ static void brcms_b_watchdog(void *arg)
 
 static void brcms_c_radio_mpc_upd(struct brcms_c_info *wlc)
 {
-	bool mpc_radio, radio_state;
-
 	/*
 	 * Clear the WL_RADIO_MPC_DISABLE bit when mpc feature is disabled
 	 * in case the WL_RADIO_MPC_DISABLE bit was set. Stop the radio
 	 * monitor also when WL_RADIO_MPC_DISABLE is the only reason that
 	 * the radio is going down.
 	 */
-	if (!wlc->mpc) {
-		if (!wlc->pub->radio_disabled)
-			return;
-		mboolclr(wlc->pub->radio_disabled, WL_RADIO_MPC_DISABLE);
-		brcms_c_radio_upd(wlc);
-		if (!wlc->pub->radio_disabled)
-			brcms_c_radio_monitor_stop(wlc);
+	if (!wlc->pub->radio_disabled)
 		return;
-	}
-
-	/*
-	 * sync ismpc logic with WL_RADIO_MPC_DISABLE bit in
-	 * wlc->pub->radio_disabled to go ON, always call radio_upd
-	 * synchronously to go OFF, postpone radio_upd to later when
-	 * context is safe(e.g. watchdog)
-	 */
-	radio_state =
-	    (mboolisset(wlc->pub->radio_disabled, WL_RADIO_MPC_DISABLE) ? OFF :
-	     ON);
-	mpc_radio = (brcms_c_ismpc(wlc) == true) ? OFF : ON;
-
-	if (radio_state == ON && mpc_radio == OFF)
-		wlc->mpc_delay_off = wlc->mpc_dlycnt;
-	else if (radio_state == OFF && mpc_radio == ON) {
-		mboolclr(wlc->pub->radio_disabled, WL_RADIO_MPC_DISABLE);
-		brcms_c_radio_upd(wlc);
-		if (wlc->mpc_offcnt < BRCMS_MPC_THRESHOLD)
-			wlc->mpc_dlycnt = BRCMS_MPC_MAX_DELAYCNT;
-		else
-			wlc->mpc_dlycnt = BRCMS_MPC_MIN_DELAYCNT;
-	}
-	/*
-	 * Below logic is meant to capture the transition from mpc off
-	 * to mpc on for reasons other than wlc->mpc_delay_off keeping
-	 * the mpc off. In that case reset wlc->mpc_delay_off to
-	 * wlc->mpc_dlycnt, so that we restart the countdown of mpc_delay_off
-	 */
-	if ((wlc->prev_non_delay_mpc == false) &&
-	    (brcms_c_is_non_delay_mpc(wlc) == true) && wlc->mpc_delay_off)
-		wlc->mpc_delay_off = wlc->mpc_dlycnt;
-
-	wlc->prev_non_delay_mpc = brcms_c_is_non_delay_mpc(wlc);
+	mboolclr(wlc->pub->radio_disabled, WL_RADIO_MPC_DISABLE);
+	brcms_c_radio_upd(wlc);
+	if (!wlc->pub->radio_disabled)
+		brcms_c_radio_monitor_stop(wlc);
 }
 
 /* common watchdog code */
@@ -4427,8 +4375,6 @@ static void brcms_c_watchdog(void *arg)
 		if (--wlc->mpc_delay_off == 0) {
 			mboolset(wlc->pub->radio_disabled,
 				 WL_RADIO_MPC_DISABLE);
-			if (wlc->mpc && brcms_c_ismpc(wlc))
-				wlc->mpc_offcnt = 0;
 		}
 	}
 
@@ -5200,9 +5146,6 @@ static void brcms_c_ap_upd(struct brcms_c_info *wlc)
 {
 	/* STA-BSS; short capable */
 	wlc->PLCPHdr_override = BRCMS_PLCP_SHORT;
-
-	/* fixup mpc */
-	wlc->mpc = true;
 }
 
 /* Initialize just the hardware when coming out of POR or S3/S5 system states */
@@ -8192,9 +8135,8 @@ int brcms_c_get_tx_power(struct brcms_c_info *wlc)
 	return (int)(qdbm / BRCMS_TXPWR_DB_FACTOR);
 }
 
-void brcms_c_set_radio_mpc(struct brcms_c_info *wlc, bool mpc)
+void brcms_c_set_radio_mpc(struct brcms_c_info *wlc)
 {
-	wlc->mpc = mpc;
 	brcms_c_radio_mpc_upd(wlc);
 }
 
diff --git a/drivers/net/wireless/brcm80211/brcmsmac/main.h b/drivers/net/wireless/brcm80211/brcmsmac/main.h
index c0e0fcf..37c55fd 100644
--- a/drivers/net/wireless/brcm80211/brcmsmac/main.h
+++ b/drivers/net/wireless/brcm80211/brcmsmac/main.h
@@ -427,7 +427,6 @@ struct brcms_txq_info {
  * bandinit_pending: track band init in auto band.
  * radio_monitor: radio timer is running.
  * going_down: down path intermediate variable.
- * mpc: enable minimum power consumption.
  * mpc_dlycnt: # of watchdog cnt before turn disable radio.
  * mpc_offcnt: # of watchdog cnt that radio is disabled.
  * mpc_delay_off: delay radio disable by # of watchdog cnt.
@@ -522,7 +521,6 @@ struct brcms_c_info {
 	bool radio_monitor;
 	bool going_down;
 
-	bool mpc;
 	u8 mpc_dlycnt;
 	u8 mpc_offcnt;
 	u8 mpc_delay_off;
diff --git a/drivers/net/wireless/brcm80211/brcmsmac/pub.h b/drivers/net/wireless/brcm80211/brcmsmac/pub.h
index d20116a..2e09216 100644
--- a/drivers/net/wireless/brcm80211/brcmsmac/pub.h
+++ b/drivers/net/wireless/brcm80211/brcmsmac/pub.h
@@ -596,7 +596,7 @@ extern void brcms_c_set_beacon_listen_interval(struct brcms_c_info *wlc,
 					u8 interval);
 extern int brcms_c_set_tx_power(struct brcms_c_info *wlc, int txpwr);
 extern int brcms_c_get_tx_power(struct brcms_c_info *wlc);
-extern void brcms_c_set_radio_mpc(struct brcms_c_info *wlc, bool mpc);
+extern void brcms_c_set_radio_mpc(struct brcms_c_info *wlc);
 extern bool brcms_c_check_radio_disabled(struct brcms_c_info *wlc);
 
 #endif				/* _BRCM_PUB_H_ */
-- 
1.7.4.1


