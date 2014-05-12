Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-gw2-out.broadcom.com ([216.31.210.63]:54122 "EHLO
	mail-gw2-out.broadcom.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754708AbaELIrr (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 12 May 2014 04:47:47 -0400
From: Arend van Spriel <arend@broadcom.com>
To: "John W. Linville" <linville@tuxdriver.com>
CC: linux-wireless <linux-wireless@vger.kernel.org>,
	Arend van Spriel <arend@broadcom.com>
Subject: [PATCH 10/14] brcmfmac: provide VHT capability information to user-space
Date: Mon, 12 May 2014 10:47:35 +0200
Message-ID: <1399884459-5048-11-git-send-email-arend@broadcom.com> (sfid-20140512_104800_247529_F1827545)
In-Reply-To: <1399884459-5048-1-git-send-email-arend@broadcom.com>
References: <1399884459-5048-1-git-send-email-arend@broadcom.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Although brcmfmac support several 11ac devices it did not advertise
VHT related information to cfg80211.

Reviewed-by: Daniel (Deognyoun) Kim <dekim@broadcom.com>
Reviewed-by: Franky Lin <frankyl@broadcom.com>
Reviewed-by: Hante Meuleman <meuleman@broadcom.com>
Reviewed-by: Pieter-Paul Giesberts <pieterpg@broadcom.com>
Signed-off-by: Arend van Spriel <arend@broadcom.com>
---
 .../net/wireless/brcm80211/brcmfmac/wl_cfg80211.c  |   73 ++++++++++++++++----
 1 file changed, 59 insertions(+), 14 deletions(-)

diff --git a/drivers/net/wireless/brcm80211/brcmfmac/wl_cfg80211.c b/drivers/net/wireless/brcm80211/brcmfmac/wl_cfg80211.c
index 5f89a42..b56c2127 100644
--- a/drivers/net/wireless/brcm80211/brcmfmac/wl_cfg80211.c
+++ b/drivers/net/wireless/brcm80211/brcmfmac/wl_cfg80211.c
@@ -5313,13 +5313,63 @@ static void brcmf_get_bwcap(struct brcmf_if *ifp, u32 bw_cap[])
 	}
 }
 
+static void brcmf_update_ht_cap(struct ieee80211_supported_band *band,
+				u32 bw_cap[2], u32 nchain)
+{
+	band->ht_cap.ht_supported = true;
+	if (bw_cap[band->band] & WLC_BW_40MHZ_BIT) {
+		band->ht_cap.cap |= IEEE80211_HT_CAP_SGI_40;
+		band->ht_cap.cap |= IEEE80211_HT_CAP_SUP_WIDTH_20_40;
+	}
+	band->ht_cap.cap |= IEEE80211_HT_CAP_SGI_20;
+	band->ht_cap.cap |= IEEE80211_HT_CAP_DSSSCCK40;
+	band->ht_cap.ampdu_factor = IEEE80211_HT_MAX_AMPDU_64K;
+	band->ht_cap.ampdu_density = IEEE80211_HT_MPDU_DENSITY_16;
+	memset(band->ht_cap.mcs.rx_mask, 0xff, nchain);
+	band->ht_cap.mcs.tx_params = IEEE80211_HT_MCS_TX_DEFINED;
+}
+
+static __le16 brcmf_get_mcs_map(u32 nchain, enum ieee80211_vht_mcs_support supp)
+{
+	u16 mcs_map;
+	int i;
+
+	for (i = 0, mcs_map = 0xFFFF; i < nchain; i++)
+		mcs_map = (mcs_map << 2) | supp;
+
+	return cpu_to_le16(mcs_map);
+}
+
+static void brcmf_update_vht_cap(struct ieee80211_supported_band *band,
+				 u32 bw_cap[2], u32 nchain)
+{
+	__le16 mcs_map;
+
+	/* not allowed in 2.4G band */
+	if (band->band == IEEE80211_BAND_2GHZ)
+		return;
+
+	band->vht_cap.vht_supported = true;
+	/* 80MHz is mandatory */
+	band->vht_cap.cap |= IEEE80211_VHT_CAP_SHORT_GI_80;
+	if (bw_cap[band->band] & WLC_BW_160MHZ_BIT) {
+		band->vht_cap.cap |= IEEE80211_VHT_CAP_SUPP_CHAN_WIDTH_160MHZ;
+		band->vht_cap.cap |= IEEE80211_VHT_CAP_SHORT_GI_160;
+	}
+	/* all support 256-QAM */
+	mcs_map = brcmf_get_mcs_map(nchain, IEEE80211_VHT_MCS_SUPPORT_0_9);
+	band->vht_cap.vht_mcs.rx_mcs_map = mcs_map;
+	band->vht_cap.vht_mcs.tx_mcs_map = mcs_map;
+}
+
 static s32 brcmf_update_wiphybands(struct brcmf_cfg80211_info *cfg)
 {
 	struct brcmf_if *ifp = netdev_priv(cfg_to_ndev(cfg));
 	struct wiphy *wiphy;
 	s32 phy_list;
 	u32 band_list[3];
-	u32 nmode;
+	u32 nmode = 0;
+	u32 vhtmode = 0;
 	u32 bw_cap[2] = { 0, 0 };
 	u32 rxchain;
 	u32 nchain;
@@ -5350,14 +5400,16 @@ static s32 brcmf_update_wiphybands(struct brcmf_cfg80211_info *cfg)
 	brcmf_dbg(INFO, "BRCMF_C_GET_BANDLIST reported: 0x%08x 0x%08x 0x%08x phy\n",
 		  band_list[0], band_list[1], band_list[2]);
 
+	(void)brcmf_fil_iovar_int_get(ifp, "vhtmode", &vhtmode);
 	err = brcmf_fil_iovar_int_get(ifp, "nmode", &nmode);
 	if (err) {
 		brcmf_err("nmode error (%d)\n", err);
 	} else {
 		brcmf_get_bwcap(ifp, bw_cap);
 	}
-	brcmf_dbg(INFO, "nmode=%d, bw_cap=(%d, %d)\n", nmode,
-		  bw_cap[IEEE80211_BAND_2GHZ], bw_cap[IEEE80211_BAND_5GHZ]);
+	brcmf_dbg(INFO, "nmode=%d, vhtmode=%d, bw_cap=(%d, %d)\n",
+		  nmode, vhtmode, bw_cap[IEEE80211_BAND_2GHZ],
+		  bw_cap[IEEE80211_BAND_5GHZ]);
 
 	err = brcmf_fil_iovar_int_get(ifp, "rxchain", &rxchain);
 	if (err) {
@@ -5388,17 +5440,10 @@ static s32 brcmf_update_wiphybands(struct brcmf_cfg80211_info *cfg)
 		else
 			continue;
 
-		if (bw_cap[band->band] & WLC_BW_40MHZ_BIT) {
-			band->ht_cap.cap |= IEEE80211_HT_CAP_SGI_40;
-			band->ht_cap.cap |= IEEE80211_HT_CAP_SUP_WIDTH_20_40;
-		}
-		band->ht_cap.cap |= IEEE80211_HT_CAP_SGI_20;
-		band->ht_cap.cap |= IEEE80211_HT_CAP_DSSSCCK40;
-		band->ht_cap.ht_supported = true;
-		band->ht_cap.ampdu_factor = IEEE80211_HT_MAX_AMPDU_64K;
-		band->ht_cap.ampdu_density = IEEE80211_HT_MPDU_DENSITY_16;
-		memset(band->ht_cap.mcs.rx_mask, 0xff, nchain);
-		band->ht_cap.mcs.tx_params = IEEE80211_HT_MCS_TX_DEFINED;
+		if (nmode)
+			brcmf_update_ht_cap(band, bw_cap, nchain);
+		if (vhtmode)
+			brcmf_update_vht_cap(band, bw_cap, nchain);
 		bands[band->band] = band;
 	}
 
-- 
1.7.9.5

