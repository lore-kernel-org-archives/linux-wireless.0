Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-bw0-f46.google.com ([209.85.214.46]:64088 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754559Ab1BMOlB (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 13 Feb 2011 09:41:01 -0500
Received: by mail-bw0-f46.google.com with SMTP id 15so4702340bwz.19
        for <linux-wireless@vger.kernel.org>; Sun, 13 Feb 2011 06:40:59 -0800 (PST)
From: Stanislav Fomichev <kernel@fomichev.me>
To: linux-wireless@vger.kernel.org
Cc: brudley@broadcom.com, gregkh@suse.de
Subject: [PATCH 4/8] brcm80211: replace ht_cap_ie with ieee80211_ht_cap
Date: Sun, 13 Feb 2011 17:40:39 +0300
Message-Id: <1297608043-18381-4-git-send-email-kernel@fomichev.me>
In-Reply-To: <1297608043-18381-1-git-send-email-kernel@fomichev.me>
References: <1297608043-18381-1-git-send-email-kernel@fomichev.me>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Signed-off-by: Stanislav Fomichev <kernel@fomichev.me>
---
 drivers/staging/brcm80211/include/proto/802.11.h |   26 ----------------------
 drivers/staging/brcm80211/sys/wlc_mac80211.c     |   22 +++++++++---------
 drivers/staging/brcm80211/sys/wlc_mac80211.h     |    2 +-
 drivers/staging/brcm80211/sys/wlc_pub.h          |    7 ++++-
 drivers/staging/brcm80211/sys/wlc_stf.c          |   14 ++++++------
 5 files changed, 24 insertions(+), 47 deletions(-)

diff --git a/drivers/staging/brcm80211/include/proto/802.11.h b/drivers/staging/brcm80211/include/proto/802.11.h
index 11f7987..3238dad 100644
--- a/drivers/staging/brcm80211/include/proto/802.11.h
+++ b/drivers/staging/brcm80211/include/proto/802.11.h
@@ -228,34 +228,8 @@ typedef struct d11cnt {
 
 #define MCSSET_LEN	16
 
-BWL_PRE_PACKED_STRUCT struct ht_cap_ie {
-	u16 cap;
-	u8 params;
-	u8 supp_mcs[MCSSET_LEN];
-	u16 ext_htcap;
-	u32 txbf_cap;
-	u8 as_cap;
-} BWL_POST_PACKED_STRUCT;
-typedef struct ht_cap_ie ht_cap_ie_t;
-
 #define HT_CAP_IE_LEN		26
 
-#define HT_CAP_LDPC_CODING	0x0001
-#define HT_CAP_40MHZ		0x0002
-#define HT_CAP_MIMO_PS_MASK	0x000C
-#define HT_CAP_MIMO_PS_SHIFT	0x0002
-#define HT_CAP_MIMO_PS_OFF	0x0003
-#define HT_CAP_MIMO_PS_ON	0x0000
-#define HT_CAP_GF		0x0010
-#define HT_CAP_SHORT_GI_20	0x0020
-#define HT_CAP_SHORT_GI_40	0x0040
-#define HT_CAP_TX_STBC		0x0080
-#define HT_CAP_RX_STBC_MASK	0x0300
-#define HT_CAP_RX_STBC_SHIFT	8
-#define HT_CAP_MAX_AMSDU	0x0800
-#define HT_CAP_DSSS_CCK	0x1000
-#define HT_CAP_40MHZ_INTOLERANT 0x4000
-
 #define HT_CAP_RX_STBC_NO		0x0
 #define HT_CAP_RX_STBC_ONE_STREAM	0x1
 
diff --git a/drivers/staging/brcm80211/sys/wlc_mac80211.c b/drivers/staging/brcm80211/sys/wlc_mac80211.c
index ddaa515..ce13e2e 100644
--- a/drivers/staging/brcm80211/sys/wlc_mac80211.c
+++ b/drivers/staging/brcm80211/sys/wlc_mac80211.c
@@ -1170,9 +1170,9 @@ void wlc_protection_upd(struct wlc_info *wlc, uint idx, int val)
 
 static void wlc_ht_update_sgi_rx(struct wlc_info *wlc, int val)
 {
-	wlc->ht_cap.cap &= ~(HT_CAP_SHORT_GI_20 | HT_CAP_SHORT_GI_40);
-	wlc->ht_cap.cap |= (val & WLC_N_SGI_20) ? HT_CAP_SHORT_GI_20 : 0;
-	wlc->ht_cap.cap |= (val & WLC_N_SGI_40) ? HT_CAP_SHORT_GI_40 : 0;
+	wlc->ht_cap.cap_info &= ~(IEEE80211_HT_CAP_SGI_20 | IEEE80211_HT_CAP_SGI_40);
+	wlc->ht_cap.cap_info |= (val & WLC_N_SGI_20) ? IEEE80211_HT_CAP_SGI_20 : 0;
+	wlc->ht_cap.cap_info |= (val & WLC_N_SGI_40) ? IEEE80211_HT_CAP_SGI_40 : 0;
 
 	if (wlc->pub->up) {
 		wlc_update_beacon(wlc);
@@ -1184,9 +1184,9 @@ static void wlc_ht_update_ldpc(struct wlc_info *wlc, s8 val)
 {
 	wlc->stf->ldpc = val;
 
-	wlc->ht_cap.cap &= ~HT_CAP_LDPC_CODING;
+	wlc->ht_cap.cap_info &= ~IEEE80211_HT_CAP_LDPC_CODING;
 	if (wlc->stf->ldpc != OFF)
-		wlc->ht_cap.cap |= HT_CAP_LDPC_CODING;
+		wlc->ht_cap.cap_info |= IEEE80211_HT_CAP_LDPC_CODING;
 
 	if (wlc->pub->up) {
 		wlc_update_beacon(wlc);
@@ -1740,7 +1740,7 @@ void *wlc_attach(void *wl, u16 vendor, u16 device, uint unit, bool piomode,
 	ASSERT(IEEE80211_MIN_ACTION_SIZE - 1 == DOT11_MGMT_HDR_LEN);
 	ASSERT(sizeof(struct dot11_bcn_prb) == DOT11_BCN_PRB_LEN);
 	ASSERT(sizeof(tx_status_t) == TXSTATUS_LEN);
-	ASSERT(sizeof(ht_cap_ie_t) == HT_CAP_IE_LEN);
+	ASSERT(sizeof(struct ieee80211_ht_cap) == HT_CAP_IE_LEN);
 #ifdef BRCM_FULLMAC
 	ASSERT(offsetof(wl_scan_params_t, channel_list) ==
 	       WL_SCAN_PARAMS_FIXED_SIZE);
@@ -1944,7 +1944,7 @@ void *wlc_attach(void *wl, u16 vendor, u16 device, uint unit, bool piomode,
 	wlc_wme_initparams_sta(wlc, &wlc->wme_param_ie);
 
 	wlc->mimoft = FT_HT;
-	wlc->ht_cap.cap = HT_CAP;
+	wlc->ht_cap.cap_info = HT_CAP;
 	if (HT_ENAB(wlc->pub))
 		wlc->stf->ldpc = AUTO;
 
@@ -1981,14 +1981,14 @@ void *wlc_attach(void *wl, u16 vendor, u16 device, uint unit, bool piomode,
 	if (n_disabled & WLFEATURE_DISABLE_11N_STBC_TX) {
 		wlc->bandstate[BAND_2G_INDEX]->band_stf_stbc_tx = OFF;
 		wlc->bandstate[BAND_5G_INDEX]->band_stf_stbc_tx = OFF;
-		wlc->ht_cap.cap &= ~HT_CAP_TX_STBC;
+		wlc->ht_cap.cap_info &= ~IEEE80211_HT_CAP_TX_STBC;
 	}
 	if (n_disabled & WLFEATURE_DISABLE_11N_STBC_RX)
 		wlc_stf_stbc_rx_set(wlc, HT_CAP_RX_STBC_NO);
 
 	/* apply the GF override from nvram conf */
 	if (n_disabled & WLFEATURE_DISABLE_11N_GF)
-		wlc->ht_cap.cap &= ~HT_CAP_GF;
+		wlc->ht_cap.cap_info &= ~IEEE80211_HT_CAP_GRN_FLD;
 
 	/* initialize radio_mpc_disable according to wlc->mpc */
 	wlc_radio_mpc_upd(wlc);
@@ -8269,8 +8269,8 @@ void wlc_reset_bmac_done(struct wlc_info *wlc)
 
 void wlc_ht_mimops_cap_update(struct wlc_info *wlc, u8 mimops_mode)
 {
-	wlc->ht_cap.cap &= ~HT_CAP_MIMO_PS_MASK;
-	wlc->ht_cap.cap |= (mimops_mode << HT_CAP_MIMO_PS_SHIFT);
+	wlc->ht_cap.cap_info &= ~IEEE80211_HT_CAP_SM_PS;
+	wlc->ht_cap.cap_info |= (mimops_mode << IEEE80211_HT_CAP_SM_PS_SHIFT);
 
 	if (AP_ENAB(wlc->pub) && wlc->clk) {
 		wlc_update_beacon(wlc);
diff --git a/drivers/staging/brcm80211/sys/wlc_mac80211.h b/drivers/staging/brcm80211/sys/wlc_mac80211.h
index 5df996b..d0c274b 100644
--- a/drivers/staging/brcm80211/sys/wlc_mac80211.h
+++ b/drivers/staging/brcm80211/sys/wlc_mac80211.h
@@ -677,7 +677,7 @@ struct wlc_info {
 	s8 cck_40txbw;	/* 11N, cck tx b/w override when in 40MHZ mode */
 	s8 ofdm_40txbw;	/* 11N, ofdm tx b/w override when in 40MHZ mode */
 	s8 mimo_40txbw;	/* 11N, mimo tx b/w override when in 40MHZ mode */
-	ht_cap_ie_t ht_cap;	/* HT CAP IE being advertised by this node */
+	struct ieee80211_ht_cap ht_cap;	/* HT CAP IE being advertised by this node */
 
 	uint seckeys;		/* 54 key table shm address */
 	uint tkmickeys;		/* 12 TKIP MIC key table shm address */
diff --git a/drivers/staging/brcm80211/sys/wlc_pub.h b/drivers/staging/brcm80211/sys/wlc_pub.h
index aff4130..c304156 100644
--- a/drivers/staging/brcm80211/sys/wlc_pub.h
+++ b/drivers/staging/brcm80211/sys/wlc_pub.h
@@ -145,8 +145,11 @@ struct rsn_parms {
 #define AMPDU_DEF_MPDU_DENSITY	6	/* default mpdu density (110 ==> 4us) */
 
 /* defaults for the HT (MIMO) bss */
-#define HT_CAP	((HT_CAP_MIMO_PS_OFF << HT_CAP_MIMO_PS_SHIFT) | HT_CAP_40MHZ | \
-	HT_CAP_GF | HT_CAP_MAX_AMSDU | HT_CAP_DSSS_CCK)
+#define HT_CAP	((WLAN_HT_CAP_SM_PS_DISABLED << IEEE80211_HT_CAP_SM_PS_SHIFT) | \
+		IEEE80211_HT_CAP_SUP_WIDTH_20_40 | \
+		IEEE80211_HT_CAP_GRN_FLD | \
+		IEEE80211_HT_CAP_MAX_AMSDU | \
+		IEEE80211_HT_CAP_DSSSCCK40)
 
 /* WLC packet type is a void * */
 typedef void *wlc_pkt_t;
diff --git a/drivers/staging/brcm80211/sys/wlc_stf.c b/drivers/staging/brcm80211/sys/wlc_stf.c
index 8975b09..bb56a88 100644
--- a/drivers/staging/brcm80211/sys/wlc_stf.c
+++ b/drivers/staging/brcm80211/sys/wlc_stf.c
@@ -76,8 +76,8 @@ static void wlc_stf_stbc_rx_ht_update(struct wlc_info *wlc, int val)
 			return;
 	}
 
-	wlc->ht_cap.cap &= ~HT_CAP_RX_STBC_MASK;
-	wlc->ht_cap.cap |= (val << HT_CAP_RX_STBC_SHIFT);
+	wlc->ht_cap.cap_info &= ~IEEE80211_HT_CAP_RX_STBC;
+	wlc->ht_cap.cap_info |= (val << IEEE80211_HT_CAP_RX_STBC_SHIFT);
 
 	if (wlc->pub->up) {
 		wlc_update_beacon(wlc);
@@ -153,7 +153,7 @@ wlc_stf_ss_algo_channel_get(struct wlc_info *wlc, u16 *ss_algo_channel,
 
 static s8 wlc_stf_stbc_rx_get(struct wlc_info *wlc)
 {
-	return (wlc->ht_cap.cap & HT_CAP_RX_STBC_MASK) >> HT_CAP_RX_STBC_SHIFT;
+	return (wlc->ht_cap.cap_info & IEEE80211_HT_CAP_RX_STBC) >> IEEE80211_HT_CAP_RX_STBC_SHIFT;
 }
 
 static bool wlc_stf_stbc_tx_set(struct wlc_info *wlc, s32 int_val)
@@ -167,9 +167,9 @@ static bool wlc_stf_stbc_tx_set(struct wlc_info *wlc, s32 int_val)
 
 	if ((int_val == OFF) || (wlc->stf->txstreams == 1)
 	    || !WLC_STBC_CAP_PHY(wlc))
-		wlc->ht_cap.cap &= ~HT_CAP_TX_STBC;
+		wlc->ht_cap.cap_info &= ~IEEE80211_HT_CAP_TX_STBC;
 	else
-		wlc->ht_cap.cap |= HT_CAP_TX_STBC;
+		wlc->ht_cap.cap_info |= IEEE80211_HT_CAP_TX_STBC;
 
 	wlc->bandstate[BAND_2G_INDEX]->band_stf_stbc_tx = (s8) int_val;
 	wlc->bandstate[BAND_5G_INDEX]->band_stf_stbc_tx = (s8) int_val;
@@ -341,7 +341,7 @@ int wlc_stf_rxchain_set(struct wlc_info *wlc, s32 int_val)
 
 	if (rxchain_cnt != old_rxchain_cnt) {
 		mimops_mode =
-		    (rxchain_cnt == 1) ? HT_CAP_MIMO_PS_ON : HT_CAP_MIMO_PS_OFF;
+		    (rxchain_cnt == 1) ? WLAN_HT_CAP_SM_PS_STATIC : WLAN_HT_CAP_SM_PS_DISABLED;
 		wlc->mimops_PM = mimops_mode;
 		if (AP_ENAB(wlc->pub)) {
 			wlc_phy_stf_chain_set(wlc->band->pi, wlc->stf->txchain,
@@ -353,7 +353,7 @@ int wlc_stf_rxchain_set(struct wlc_info *wlc, s32 int_val)
 			return BCME_OK;
 		}
 		if (wlc->pub->associated) {
-			if (mimops_mode == HT_CAP_MIMO_PS_OFF) {
+			if (mimops_mode == WLAN_HT_CAP_SM_PS_DISABLED) {
 				/* if mimops is off, turn on the Rx chain first */
 				wlc_phy_stf_chain_set(wlc->band->pi,
 						      wlc->stf->txchain,
-- 
1.7.1

