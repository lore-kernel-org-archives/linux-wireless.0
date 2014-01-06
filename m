Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-gw1-out.broadcom.com ([216.31.210.62]:46431 "EHLO
	mail-gw1-out.broadcom.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752652AbaAFLk5 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 6 Jan 2014 06:40:57 -0500
From: Arend van Spriel <arend@broadcom.com>
To: "John W. Linville" <linville@tuxdriver.com>
CC: linux-wireless <linux-wireless@vger.kernel.org>,
	Arend van Spriel <arend@broadcom.com>
Subject: [PATCH 06/15] brcmfmac: correct reporting HT40 support in wiphy htcap
Date: Mon, 6 Jan 2014 12:40:41 +0100
Message-ID: <1389008450-28529-7-git-send-email-arend@broadcom.com> (sfid-20140106_124109_135723_658F58B5)
In-Reply-To: <1389008450-28529-1-git-send-email-arend@broadcom.com>
References: <1389008450-28529-1-git-send-email-arend@broadcom.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Using 'iw phy' only showed HT20 support in the HT capabilities info.
This patch determines support for HT40 using a firmware query that
is supposed to work for all supported devices.

Reviewed-by: Hante Meuleman <meuleman@broadcom.com>
Reviewed-by: Franky Lin <frankyl@broadcom.com>
Reviewed-by: Pieter-Paul Giesberts <pieterpg@broadcom.com>
Signed-off-by: Arend van Spriel <arend@broadcom.com>
---
 .../net/wireless/brcm80211/brcmfmac/wl_cfg80211.c  |  120 +++++++++++++-------
 .../net/wireless/brcm80211/include/brcmu_wifi.h    |   14 +++
 2 files changed, 91 insertions(+), 43 deletions(-)

diff --git a/drivers/net/wireless/brcm80211/brcmfmac/wl_cfg80211.c b/drivers/net/wireless/brcm80211/brcmfmac/wl_cfg80211.c
index 3966fe0..a7c1afe 100644
--- a/drivers/net/wireless/brcm80211/brcmfmac/wl_cfg80211.c
+++ b/drivers/net/wireless/brcm80211/brcmfmac/wl_cfg80211.c
@@ -5087,7 +5087,8 @@ dongle_scantime_out:
 }
 
 
-static s32 brcmf_construct_reginfo(struct brcmf_cfg80211_info *cfg, u32 bw_cap)
+static s32 brcmf_construct_reginfo(struct brcmf_cfg80211_info *cfg,
+				   u32 bw_cap[])
 {
 	struct brcmf_if *ifp = netdev_priv(cfg_to_ndev(cfg));
 	struct ieee80211_channel *band_chan_arr;
@@ -5100,7 +5101,6 @@ static s32 brcmf_construct_reginfo(struct brcmf_cfg80211_info *cfg, u32 bw_cap)
 	enum ieee80211_band band;
 	u32 channel;
 	u32 *n_cnt;
-	bool ht40_allowed;
 	u32 index;
 	u32 ht40_flag;
 	bool update;
@@ -5133,18 +5133,17 @@ static s32 brcmf_construct_reginfo(struct brcmf_cfg80211_info *cfg, u32 bw_cap)
 			array_size = ARRAY_SIZE(__wl_2ghz_channels);
 			n_cnt = &__wl_band_2ghz.n_channels;
 			band = IEEE80211_BAND_2GHZ;
-			ht40_allowed = (bw_cap == WLC_N_BW_40ALL);
 		} else if (ch.band == BRCMU_CHAN_BAND_5G) {
 			band_chan_arr = __wl_5ghz_a_channels;
 			array_size = ARRAY_SIZE(__wl_5ghz_a_channels);
 			n_cnt = &__wl_band_5ghz_a.n_channels;
 			band = IEEE80211_BAND_5GHZ;
-			ht40_allowed = !(bw_cap == WLC_N_BW_20ALL);
 		} else {
-			brcmf_err("Invalid channel Sepc. 0x%x.\n", ch.chspec);
+			brcmf_err("Invalid channel Spec. 0x%x.\n", ch.chspec);
 			continue;
 		}
-		if (!ht40_allowed && ch.bw == BRCMU_CHAN_BW_40)
+		if (!(bw_cap[band] & WLC_BW_40MHZ_BIT) &&
+		    ch.bw == BRCMU_CHAN_BW_40)
 			continue;
 		update = false;
 		for (j = 0; (j < *n_cnt && (*n_cnt < array_size)); j++) {
@@ -5162,7 +5161,10 @@ static s32 brcmf_construct_reginfo(struct brcmf_cfg80211_info *cfg, u32 bw_cap)
 				ieee80211_channel_to_frequency(ch.chnum, band);
 			band_chan_arr[index].hw_value = ch.chnum;
 
-			if (ch.bw == BRCMU_CHAN_BW_40 && ht40_allowed) {
+			brcmf_err("channel %d: f=%d bw=%d sb=%d\n",
+				  ch.chnum, band_chan_arr[index].center_freq,
+				  ch.bw, ch.sb);
+			if (ch.bw == BRCMU_CHAN_BW_40) {
 				/* assuming the order is HT20, HT40 Upper,
 				 * HT40 lower from chanspecs
 				 */
@@ -5213,6 +5215,46 @@ exit:
 	return err;
 }
 
+static void brcmf_get_bwcap(struct brcmf_if *ifp, u32 bw_cap[])
+{
+	u32 band, mimo_bwcap;
+	int err;
+
+	band = WLC_BAND_2G;
+	err = brcmf_fil_iovar_int_get(ifp, "bw_cap", &band);
+	if (!err) {
+		bw_cap[IEEE80211_BAND_2GHZ] = band;
+		band = WLC_BAND_5G;
+		err = brcmf_fil_iovar_int_get(ifp, "bw_cap", &band);
+		if (!err) {
+			bw_cap[IEEE80211_BAND_5GHZ] = band;
+			return;
+		}
+		WARN_ON(1);
+		return;
+	}
+	brcmf_dbg(INFO, "fallback to mimo_bw_cap info\n");
+	mimo_bwcap = 0;
+	err = brcmf_fil_iovar_int_get(ifp, "mimo_bw_cap", &mimo_bwcap);
+	if (err)
+		/* assume 20MHz if firmware does not give a clue */
+		mimo_bwcap = WLC_N_BW_20ALL;
+
+	switch (mimo_bwcap) {
+	case WLC_N_BW_40ALL:
+		bw_cap[IEEE80211_BAND_2GHZ] |= WLC_BW_40MHZ_BIT;
+		/* fall-thru */
+	case WLC_N_BW_20IN2G_40IN5G:
+		bw_cap[IEEE80211_BAND_5GHZ] |= WLC_BW_40MHZ_BIT;
+		/* fall-thru */
+	case WLC_N_BW_20ALL:
+		bw_cap[IEEE80211_BAND_2GHZ] |= WLC_BW_20MHZ_BIT;
+		bw_cap[IEEE80211_BAND_5GHZ] |= WLC_BW_20MHZ_BIT;
+		break;
+	default:
+		brcmf_err("invalid mimo_bw_cap value\n");
+	}
+}
 
 static s32 brcmf_update_wiphybands(struct brcmf_cfg80211_info *cfg)
 {
@@ -5221,13 +5263,13 @@ static s32 brcmf_update_wiphybands(struct brcmf_cfg80211_info *cfg)
 	s32 phy_list;
 	u32 band_list[3];
 	u32 nmode;
-	u32 bw_cap = 0;
+	u32 bw_cap[2] = { 0, 0 };
 	s8 phy;
 	s32 err;
 	u32 nband;
 	s32 i;
-	struct ieee80211_supported_band *bands[IEEE80211_NUM_BANDS];
-	s32 index;
+	struct ieee80211_supported_band *bands[2] = { NULL, NULL };
+	struct ieee80211_supported_band *band;
 
 	err = brcmf_fil_cmd_data_get(ifp, BRCMF_C_GET_PHYLIST,
 				     &phy_list, sizeof(phy_list));
@@ -5253,11 +5295,10 @@ static s32 brcmf_update_wiphybands(struct brcmf_cfg80211_info *cfg)
 	if (err) {
 		brcmf_err("nmode error (%d)\n", err);
 	} else {
-		err = brcmf_fil_iovar_int_get(ifp, "mimo_bw_cap", &bw_cap);
-		if (err)
-			brcmf_err("mimo_bw_cap error (%d)\n", err);
+		brcmf_get_bwcap(ifp, bw_cap);
 	}
-	brcmf_dbg(INFO, "nmode=%d, mimo_bw_cap=%d\n", nmode, bw_cap);
+	brcmf_dbg(INFO, "nmode=%d, bw_cap=(%d, %d)\n", nmode,
+		  bw_cap[IEEE80211_BAND_2GHZ], bw_cap[IEEE80211_BAND_5GHZ]);
 
 	err = brcmf_construct_reginfo(cfg, bw_cap);
 	if (err) {
@@ -5266,40 +5307,33 @@ static s32 brcmf_update_wiphybands(struct brcmf_cfg80211_info *cfg)
 	}
 
 	nband = band_list[0];
-	memset(bands, 0, sizeof(bands));
 
 	for (i = 1; i <= nband && i < ARRAY_SIZE(band_list); i++) {
-		index = -1;
+		band = NULL;
 		if ((band_list[i] == WLC_BAND_5G) &&
-		    (__wl_band_5ghz_a.n_channels > 0)) {
-			index = IEEE80211_BAND_5GHZ;
-			bands[index] = &__wl_band_5ghz_a;
-			if ((bw_cap == WLC_N_BW_40ALL) ||
-			    (bw_cap == WLC_N_BW_20IN2G_40IN5G))
-				bands[index]->ht_cap.cap |=
-							IEEE80211_HT_CAP_SGI_40;
-		} else if ((band_list[i] == WLC_BAND_2G) &&
-			   (__wl_band_2ghz.n_channels > 0)) {
-			index = IEEE80211_BAND_2GHZ;
-			bands[index] = &__wl_band_2ghz;
-			if (bw_cap == WLC_N_BW_40ALL)
-				bands[index]->ht_cap.cap |=
-							IEEE80211_HT_CAP_SGI_40;
-		}
+		    (__wl_band_5ghz_a.n_channels > 0))
+			band = &__wl_band_5ghz_a;
+		else if ((band_list[i] == WLC_BAND_2G) &&
+			 (__wl_band_2ghz.n_channels > 0))
+			band = &__wl_band_2ghz;
+		else
+			continue;
 
-		if ((index >= 0) && nmode) {
-			bands[index]->ht_cap.cap |= IEEE80211_HT_CAP_SGI_20;
-			bands[index]->ht_cap.cap |= IEEE80211_HT_CAP_DSSSCCK40;
-			bands[index]->ht_cap.ht_supported = true;
-			bands[index]->ht_cap.ampdu_factor =
-						IEEE80211_HT_MAX_AMPDU_64K;
-			bands[index]->ht_cap.ampdu_density =
-						IEEE80211_HT_MPDU_DENSITY_16;
-			/* An HT shall support all EQM rates for one spatial
-			 * stream
-			 */
-			bands[index]->ht_cap.mcs.rx_mask[0] = 0xff;
+		if (bw_cap[band->band] & WLC_BW_40MHZ_BIT) {
+			band->ht_cap.cap |= IEEE80211_HT_CAP_SGI_40;
+			band->ht_cap.cap |= IEEE80211_HT_CAP_SUP_WIDTH_20_40;
 		}
+		band->ht_cap.cap |= IEEE80211_HT_CAP_SGI_20;
+		band->ht_cap.cap |= IEEE80211_HT_CAP_DSSSCCK40;
+		band->ht_cap.ht_supported = true;
+		band->ht_cap.ampdu_factor = IEEE80211_HT_MAX_AMPDU_64K;
+		band->ht_cap.ampdu_density = IEEE80211_HT_MPDU_DENSITY_16;
+		/* An HT shall support all EQM rates for one spatial
+		 * stream
+		 */
+		band->ht_cap.mcs.rx_mask[0] = 0xff;
+		band->ht_cap.mcs.tx_params = IEEE80211_HT_MCS_TX_DEFINED;
+		bands[band->band] = band;
 	}
 
 	wiphy = cfg_to_wiphy(cfg);
diff --git a/drivers/net/wireless/brcm80211/include/brcmu_wifi.h b/drivers/net/wireless/brcm80211/include/brcmu_wifi.h
index 0505cc0..7ca2aa1 100644
--- a/drivers/net/wireless/brcm80211/include/brcmu_wifi.h
+++ b/drivers/net/wireless/brcm80211/include/brcmu_wifi.h
@@ -82,6 +82,20 @@
 #define WLC_N_BW_40ALL			1
 #define WLC_N_BW_20IN2G_40IN5G		2
 
+#define WLC_BW_20MHZ_BIT		BIT(0)
+#define WLC_BW_40MHZ_BIT		BIT(1)
+#define WLC_BW_80MHZ_BIT		BIT(2)
+#define WLC_BW_160MHZ_BIT		BIT(3)
+
+/* Bandwidth capabilities */
+#define WLC_BW_CAP_20MHZ		(WLC_BW_20MHZ_BIT)
+#define WLC_BW_CAP_40MHZ		(WLC_BW_40MHZ_BIT|WLC_BW_20MHZ_BIT)
+#define WLC_BW_CAP_80MHZ		(WLC_BW_80MHZ_BIT|WLC_BW_40MHZ_BIT| \
+					 WLC_BW_20MHZ_BIT)
+#define WLC_BW_CAP_160MHZ		(WLC_BW_160MHZ_BIT|WLC_BW_80MHZ_BIT| \
+					 WLC_BW_40MHZ_BIT|WLC_BW_20MHZ_BIT)
+#define WLC_BW_CAP_UNRESTRICTED		0xFF
+
 /* band types */
 #define	WLC_BAND_AUTO			0	/* auto-select */
 #define	WLC_BAND_5G			1	/* 5 Ghz */
-- 
1.7.10.4

