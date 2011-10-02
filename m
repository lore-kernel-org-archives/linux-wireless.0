Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mms2.broadcom.com ([216.31.210.18]:1720 "EHLO mms2.broadcom.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753690Ab1JBRPA (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Sun, 2 Oct 2011 13:15:00 -0400
From: "Franky Lin" <frankyl@broadcom.com>
To: gregkh@suse.de
cc: devel@linuxdriverproject.org, linux-wireless@vger.kernel.org
Subject: [PATCH 15/20] staging: brcm80211: removed unused softmac mimo
 disable code
Date: Sun, 2 Oct 2011 10:14:40 -0700
Message-ID: <1317575685-3156-16-git-send-email-frankyl@broadcom.com> (sfid-20111002_191526_289873_356D3ED1)
In-Reply-To: <1317575685-3156-1-git-send-email-frankyl@broadcom.com>
References: <1317575685-3156-1-git-send-email-frankyl@broadcom.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Roland Vossen <rvossen@broadcom.com>

No element in array locale_bn[] has the 'no mimo' flag bit set.

Reviewed-by: Pieter-Paul Giesberts <pieterpg@broadcom.com>
Reviewed-by: Arend van Spriel <arend@broadcom.com>
Signed-off-by: Franky Lin <frankyl@broadcom.com>
---
 drivers/staging/brcm80211/brcmsmac/channel.c |   15 +++------------
 drivers/staging/brcm80211/brcmsmac/main.h    |    2 --
 drivers/staging/brcm80211/brcmsmac/stf.c     |   14 ++++++--------
 3 files changed, 9 insertions(+), 22 deletions(-)

diff --git a/drivers/staging/brcm80211/brcmsmac/channel.c b/drivers/staging/brcm80211/brcmsmac/channel.c
index 02bb795..7fe005a 100644
--- a/drivers/staging/brcm80211/brcmsmac/channel.c
+++ b/drivers/staging/brcm80211/brcmsmac/channel.c
@@ -987,7 +987,6 @@ brcms_c_set_country_common(struct brcms_cm_info *wlc_cm,
 		       const char *ccode, uint regrev,
 		       const struct country_info *country)
 {
-	const struct locale_mimo_info *li_mimo;
 	const struct locale_info *locale;
 	struct brcms_c_info *wlc = wlc_cm->wlc;
 	char prev_country_abbrev[BRCM_CNTRY_BUF_SZ];
@@ -1003,17 +1002,9 @@ brcms_c_set_country_common(struct brcms_cm_info *wlc_cm,
 	strncpy(wlc_cm->ccode, ccode, BRCM_CNTRY_BUF_SZ - 1);
 	wlc_cm->regrev = regrev;
 
-	/* disable/restore nmode based on country regulations */
-	li_mimo = brcms_c_get_mimo_2g(country->locale_mimo_2G);
-	if (li_mimo && (li_mimo->flags & BRCMS_NO_MIMO)) {
-		brcms_c_set_nmode(wlc, OFF);
-		wlc->stf->no_cddstbc = true;
-	} else {
-		wlc->stf->no_cddstbc = false;
-		if ((wlc->pub->_n_enab & SUPPORT_11N) !=
-		    wlc->protection->nmode_user)
-			brcms_c_set_nmode(wlc, wlc->protection->nmode_user);
-	}
+	if ((wlc->pub->_n_enab & SUPPORT_11N) !=
+	    wlc->protection->nmode_user)
+		brcms_c_set_nmode(wlc, wlc->protection->nmode_user);
 
 	brcms_c_stf_ss_update(wlc, wlc->bandstate[BAND_2G_INDEX]);
 	brcms_c_stf_ss_update(wlc, wlc->bandstate[BAND_5G_INDEX]);
diff --git a/drivers/staging/brcm80211/brcmsmac/main.h b/drivers/staging/brcm80211/brcmsmac/main.h
index 045356a..8815042 100644
--- a/drivers/staging/brcm80211/brcmsmac/main.h
+++ b/drivers/staging/brcm80211/brcmsmac/main.h
@@ -194,7 +194,6 @@ struct brcms_protection {
  * ss_algosel_auto: if true, use wlc->stf->ss_algo_channel;
  *			else use wlc->band->stf->ss_mode_band.
  * ss_algo_channel: ss based on per-channel algo: 0: SISO, 1: CDD 2: STBC.
- * no_cddstbc: stf override, 1: no CDD (or STBC) allowed.
  * rxchain_restore_delay: delay time to restore default rxchain.
  * ldpc: AUTO/ON/OFF ldpc cap supported.
  * txcore[MAX_STREAMS_SUPPORTED + 1]: bitmap of selected core for each Nsts.
@@ -213,7 +212,6 @@ struct brcms_stf {
 	u8 ss_opmode;
 	bool ss_algosel_auto;
 	u16 ss_algo_channel;
-	u8 no_cddstbc;
 	u8 rxchain_restore_delay;
 	s8 ldpc;
 	u8 txcore[MAX_STREAMS_SUPPORTED + 1];
diff --git a/drivers/staging/brcm80211/brcmsmac/stf.c b/drivers/staging/brcm80211/brcmsmac/stf.c
index c77bab2..ba3c3ef 100644
--- a/drivers/staging/brcm80211/brcmsmac/stf.c
+++ b/drivers/staging/brcm80211/brcmsmac/stf.c
@@ -319,17 +319,15 @@ int brcms_c_stf_ss_update(struct brcms_c_info *wlc, struct brcms_band *band)
 	if (BRCMS_STBC_CAP_PHY(wlc) &&
 	    wlc->stf->ss_algosel_auto
 	    && (wlc->stf->ss_algo_channel != (u16) -1)) {
-		upd_stf_ss = (wlc->stf->no_cddstbc || (wlc->stf->txstreams == 1)
-			      || isset(&wlc->stf->ss_algo_channel,
-				       PHY_TXC1_MODE_SISO)) ? PHY_TXC1_MODE_SISO
-		    : PHY_TXC1_MODE_CDD;
+		upd_stf_ss = (wlc->stf->txstreams == 1 ||
+			      isset(&wlc->stf->ss_algo_channel,
+				    PHY_TXC1_MODE_SISO)) ?
+				    PHY_TXC1_MODE_SISO : PHY_TXC1_MODE_CDD;
 	} else {
 		if (wlc->band != band)
 			return ret_code;
-		upd_stf_ss = (wlc->stf->no_cddstbc
-			      || (wlc->stf->txstreams ==
-				  1)) ? PHY_TXC1_MODE_SISO : band->
-		    band_stf_ss_mode;
+		upd_stf_ss = (wlc->stf->txstreams == 1) ?
+				PHY_TXC1_MODE_SISO : band->band_stf_ss_mode;
 	}
 	if (prev_stf_ss != upd_stf_ss) {
 		wlc->stf->ss_opmode = upd_stf_ss;
-- 
1.7.1


