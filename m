Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mms3.broadcom.com ([216.31.210.19]:2019 "EHLO MMS3.broadcom.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756230Ab1I2Wex (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 29 Sep 2011 18:34:53 -0400
From: "Franky Lin" <frankyl@broadcom.com>
To: gregkh@suse.de
cc: devel@linuxdriverproject.org, linux-wireless@vger.kernel.org
Subject: [PATCH v3 08/25] staging: brcm80211: remove ht_cap field from
 brcms_c_info structure
Date: Thu, 29 Sep 2011 15:34:19 -0700
Message-ID: <1317335676-3424-9-git-send-email-frankyl@broadcom.com> (sfid-20110930_003502_162327_739E0B42)
In-Reply-To: <1317335676-3424-1-git-send-email-frankyl@broadcom.com>
References: <1317145530-18839-1-git-send-email-frankyl@broadcom.com>
 <1317335676-3424-1-git-send-email-frankyl@broadcom.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Arend van Spriel <arend@broadcom.com>

The field ht_cap was typed ieee80211_ht_cap from ieee80211.h. This
contained little endian annotated field cap_info resulting in sparse
endian warnings. It turned out the driver was setting the field, but
it was actually never used. Therefore it has been removed.

Reported-by: Johannes Berg <johannes@sipsolutions.net>
Reviewed-by: Roland Vossen <rvossen@broadcom.com>
Signed-off-by: Franky Lin <frankyl@broadcom.com>
---
 drivers/staging/brcm80211/brcmsmac/main.c |   23 -----------------------
 drivers/staging/brcm80211/brcmsmac/main.h |    2 --
 drivers/staging/brcm80211/brcmsmac/stf.c  |    9 ---------
 3 files changed, 0 insertions(+), 34 deletions(-)

diff --git a/drivers/staging/brcm80211/brcmsmac/main.c b/drivers/staging/brcm80211/brcmsmac/main.c
index 3ec952c..074e16f 100644
--- a/drivers/staging/brcm80211/brcmsmac/main.c
+++ b/drivers/staging/brcm80211/brcmsmac/main.c
@@ -325,11 +325,6 @@ static u16 frametype(u32 rspec, u8 mimoframe)
  */
 #define SSID_FMT_BUF_LEN	((4 * IEEE80211_MAX_SSID_LEN) + 1)
 
-/* defaults for the HT (MIMO) bss */
-#define HT_CAP	(IEEE80211_HT_CAP_SM_PS |\
-	IEEE80211_HT_CAP_SUP_WIDTH_20_40 | IEEE80211_HT_CAP_GRN_FLD |\
-	IEEE80211_HT_CAP_MAX_AMSDU | IEEE80211_HT_CAP_DSSSCCK40)
-
 /*
  * The following table lists the buffer memory allocated to xmt fifos in HW.
  * the size is in units of 256bytes(one block), total size is HW dependent
@@ -4213,13 +4208,6 @@ void brcms_c_protection_upd(struct brcms_c_info *wlc, uint idx, int val)
 
 static void brcms_c_ht_update_sgi_rx(struct brcms_c_info *wlc, int val)
 {
-	wlc->ht_cap.cap_info &= ~(IEEE80211_HT_CAP_SGI_20 |
-					IEEE80211_HT_CAP_SGI_40);
-	wlc->ht_cap.cap_info |= (val & BRCMS_N_SGI_20) ?
-					IEEE80211_HT_CAP_SGI_20 : 0;
-	wlc->ht_cap.cap_info |= (val & BRCMS_N_SGI_40) ?
-					IEEE80211_HT_CAP_SGI_40 : 0;
-
 	if (wlc->pub->up) {
 		brcms_c_update_beacon(wlc);
 		brcms_c_update_probe_resp(wlc, true);
@@ -4230,10 +4218,6 @@ static void brcms_c_ht_update_ldpc(struct brcms_c_info *wlc, s8 val)
 {
 	wlc->stf->ldpc = val;
 
-	wlc->ht_cap.cap_info &= ~IEEE80211_HT_CAP_LDPC_CODING;
-	if (wlc->stf->ldpc != OFF)
-		wlc->ht_cap.cap_info |= IEEE80211_HT_CAP_LDPC_CODING;
-
 	if (wlc->pub->up) {
 		brcms_c_update_beacon(wlc);
 		brcms_c_update_probe_resp(wlc, true);
@@ -5376,8 +5360,6 @@ brcms_c_attach(struct brcms_info *wl, u16 vendor, u16 device, uint unit,
 	wlc->bsscfg->wlc = wlc;
 
 	wlc->mimoft = FT_HT;
-	wlc->ht_cap.cap_info = HT_CAP;
-
 	wlc->mimo_40txbw = AUTO;
 	wlc->ofdm_40txbw = AUTO;
 	wlc->cck_40txbw = AUTO;
@@ -5403,15 +5385,10 @@ brcms_c_attach(struct brcms_info *wl, u16 vendor, u16 device, uint unit,
 	if (n_disabled & WLFEATURE_DISABLE_11N_STBC_TX) {
 		wlc->bandstate[BAND_2G_INDEX]->band_stf_stbc_tx = OFF;
 		wlc->bandstate[BAND_5G_INDEX]->band_stf_stbc_tx = OFF;
-		wlc->ht_cap.cap_info &= ~IEEE80211_HT_CAP_TX_STBC;
 	}
 	if (n_disabled & WLFEATURE_DISABLE_11N_STBC_RX)
 		brcms_c_stf_stbc_rx_set(wlc, HT_CAP_RX_STBC_NO);
 
-	/* apply the GF override from nvram conf */
-	if (n_disabled & WLFEATURE_DISABLE_11N_GF)
-		wlc->ht_cap.cap_info &= ~IEEE80211_HT_CAP_GRN_FLD;
-
 	/* initialize radio_mpc_disable according to wlc->mpc */
 	brcms_c_radio_mpc_upd(wlc);
 	brcms_b_antsel_set(wlc->hw, wlc->asi->antsel_avail);
diff --git a/drivers/staging/brcm80211/brcmsmac/main.h b/drivers/staging/brcm80211/brcmsmac/main.h
index 717843a..8760d7e 100644
--- a/drivers/staging/brcm80211/brcmsmac/main.h
+++ b/drivers/staging/brcm80211/brcmsmac/main.h
@@ -456,7 +456,6 @@ struct brcms_txq_info {
  * cck_40txbw: 11N, cck tx b/w override when in 40MHZ mode.
  * ofdm_40txbw: 11N, ofdm tx b/w override when in 40MHZ mode.
  * mimo_40txbw: 11N, mimo tx b/w override when in 40MHZ mode.
- * ht_cap: HT CAP IE being advertised by this node.
  * default_bss: configured BSS parameters.
  * mc_fid_counter: BC/MC FIFO frame ID counter.
  * country_default: saved country for leaving 802.11d auto-country mode.
@@ -570,7 +569,6 @@ struct brcms_c_info {
 	s8 cck_40txbw;
 	s8 ofdm_40txbw;
 	s8 mimo_40txbw;
-	struct ieee80211_ht_cap ht_cap;
 
 	struct brcms_bss_info *default_bss;
 
diff --git a/drivers/staging/brcm80211/brcmsmac/stf.c b/drivers/staging/brcm80211/brcmsmac/stf.c
index 91b53a5..c77bab2 100644
--- a/drivers/staging/brcm80211/brcmsmac/stf.c
+++ b/drivers/staging/brcm80211/brcmsmac/stf.c
@@ -53,9 +53,6 @@ static void brcms_c_stf_stbc_rx_ht_update(struct brcms_c_info *wlc, int val)
 			return;
 	}
 
-	wlc->ht_cap.cap_info &= ~IEEE80211_HT_CAP_RX_STBC;
-	wlc->ht_cap.cap_info |= (val << IEEE80211_HT_CAP_RX_STBC_SHIFT);
-
 	if (wlc->pub->up) {
 		brcms_c_update_beacon(wlc);
 		brcms_c_update_probe_resp(wlc, true);
@@ -140,12 +137,6 @@ static bool brcms_c_stf_stbc_tx_set(struct brcms_c_info *wlc, s32 int_val)
 	if ((int_val == ON) && (wlc->stf->txstreams == 1))
 		return false;
 
-	if ((int_val == OFF) || (wlc->stf->txstreams == 1)
-	    || !BRCMS_STBC_CAP_PHY(wlc))
-		wlc->ht_cap.cap_info &= ~IEEE80211_HT_CAP_TX_STBC;
-	else
-		wlc->ht_cap.cap_info |= IEEE80211_HT_CAP_TX_STBC;
-
 	wlc->bandstate[BAND_2G_INDEX]->band_stf_stbc_tx = (s8) int_val;
 	wlc->bandstate[BAND_5G_INDEX]->band_stf_stbc_tx = (s8) int_val;
 
-- 
1.7.1


