Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-gw1-out.broadcom.com ([216.31.210.62]:3616 "EHLO
	mail-gw1-out.broadcom.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752184AbbKYKcx (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 25 Nov 2015 05:32:53 -0500
From: Arend van Spriel <arend@broadcom.com>
To: Kalle Valo <kvalo@codeaurora.org>
CC: linux-wireless <linux-wireless@vger.kernel.org>,
	Hante Meuleman <meuleman@broadcom.com>,
	Arend van Spriel <arend@broadcom.com>
Subject: [PATCH 07/11] brcmfmac: Add beamforming support.
Date: Wed, 25 Nov 2015 11:32:43 +0100
Message-ID: <1448447567-12189-8-git-send-email-arend@broadcom.com> (sfid-20151125_113300_679090_1B106B5E)
In-Reply-To: <1448447567-12189-1-git-send-email-arend@broadcom.com>
References: <1448447567-12189-1-git-send-email-arend@broadcom.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Hante Meuleman <meuleman@broadcom.com>

Some devices support beamforming. This patch enables tx beamforming
if supported and reports beamforming capabilities per channel if
supported.

Reviewed-by: Arend Van Spriel <arend@broadcom.com>
Reviewed-by: Franky (Zhenhui) Lin <frankyl@broadcom.com>
Reviewed-by: Pieter-Paul Giesberts <pieterpg@broadcom.com>
Signed-off-by: Hante Meuleman <meuleman@broadcom.com>
Signed-off-by: Arend van Spriel <arend@broadcom.com>
---
 .../broadcom/brcm80211/brcmfmac/cfg80211.c         | 36 ++++++++++++++++++++--
 .../wireless/broadcom/brcm80211/brcmfmac/common.c  |  3 ++
 .../broadcom/brcm80211/brcmfmac/fwil_types.h       |  5 +++
 3 files changed, 42 insertions(+), 2 deletions(-)

diff --git a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/cfg80211.c b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/cfg80211.c
index ef0f882..771c581 100644
--- a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/cfg80211.c
+++ b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/cfg80211.c
@@ -5672,7 +5672,8 @@ static __le16 brcmf_get_mcs_map(u32 nchain, enum ieee80211_vht_mcs_support supp)
 }
 
 static void brcmf_update_vht_cap(struct ieee80211_supported_band *band,
-				 u32 bw_cap[2], u32 nchain)
+				 u32 bw_cap[2], u32 nchain, u32 txstreams,
+				 u32 txbf_bfe_cap, u32 txbf_bfr_cap)
 {
 	__le16 mcs_map;
 
@@ -5691,6 +5692,25 @@ static void brcmf_update_vht_cap(struct ieee80211_supported_band *band,
 	mcs_map = brcmf_get_mcs_map(nchain, IEEE80211_VHT_MCS_SUPPORT_0_9);
 	band->vht_cap.vht_mcs.rx_mcs_map = mcs_map;
 	band->vht_cap.vht_mcs.tx_mcs_map = mcs_map;
+
+	/* Beamforming support information */
+	if (txbf_bfe_cap & BRCMF_TXBF_SU_BFE_CAP)
+		band->vht_cap.cap |= IEEE80211_VHT_CAP_SU_BEAMFORMEE_CAPABLE;
+	if (txbf_bfe_cap & BRCMF_TXBF_MU_BFE_CAP)
+		band->vht_cap.cap |= IEEE80211_VHT_CAP_MU_BEAMFORMEE_CAPABLE;
+	if (txbf_bfr_cap & BRCMF_TXBF_SU_BFR_CAP)
+		band->vht_cap.cap |= IEEE80211_VHT_CAP_SU_BEAMFORMER_CAPABLE;
+	if (txbf_bfr_cap & BRCMF_TXBF_MU_BFR_CAP)
+		band->vht_cap.cap |= IEEE80211_VHT_CAP_MU_BEAMFORMER_CAPABLE;
+
+	if ((txbf_bfe_cap || txbf_bfr_cap) && (txstreams > 1)) {
+		band->vht_cap.cap |=
+			(2 << IEEE80211_VHT_CAP_BEAMFORMEE_STS_SHIFT);
+		band->vht_cap.cap |= ((txstreams - 1) <<
+				IEEE80211_VHT_CAP_SOUNDING_DIMENSIONS_SHIFT);
+		band->vht_cap.cap |=
+			IEEE80211_VHT_CAP_VHT_LINK_ADAPTATION_VHT_MRQ_MFB;
+	}
 }
 
 static int brcmf_setup_wiphybands(struct wiphy *wiphy)
@@ -5705,6 +5725,9 @@ static int brcmf_setup_wiphybands(struct wiphy *wiphy)
 	int err;
 	s32 i;
 	struct ieee80211_supported_band *band;
+	u32 txstreams = 0;
+	u32 txbf_bfe_cap = 0;
+	u32 txbf_bfr_cap = 0;
 
 	(void)brcmf_fil_iovar_int_get(ifp, "vhtmode", &vhtmode);
 	err = brcmf_fil_iovar_int_get(ifp, "nmode", &nmode);
@@ -5733,6 +5756,14 @@ static int brcmf_setup_wiphybands(struct wiphy *wiphy)
 		return err;
 	}
 
+	if (vhtmode) {
+		(void)brcmf_fil_iovar_int_get(ifp, "txstreams", &txstreams);
+		(void)brcmf_fil_iovar_int_get(ifp, "txbf_bfe_cap",
+					      &txbf_bfe_cap);
+		(void)brcmf_fil_iovar_int_get(ifp, "txbf_bfr_cap",
+					      &txbf_bfr_cap);
+	}
+
 	wiphy = cfg_to_wiphy(cfg);
 	for (i = 0; i < ARRAY_SIZE(wiphy->bands); i++) {
 		band = wiphy->bands[i];
@@ -5742,7 +5773,8 @@ static int brcmf_setup_wiphybands(struct wiphy *wiphy)
 		if (nmode)
 			brcmf_update_ht_cap(band, bw_cap, nchain);
 		if (vhtmode)
-			brcmf_update_vht_cap(band, bw_cap, nchain);
+			brcmf_update_vht_cap(band, bw_cap, nchain, txstreams,
+					     txbf_bfe_cap, txbf_bfr_cap);
 	}
 
 	return 0;
diff --git a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/common.c b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/common.c
index 59beed2..474de11 100644
--- a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/common.c
+++ b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/common.c
@@ -153,6 +153,9 @@ int brcmf_c_preinit_dcmds(struct brcmf_if *ifp)
 		goto done;
 	}
 
+	/* Enable tx beamforming, errors can be ignored (not supported) */
+	(void)brcmf_fil_iovar_int_set(ifp, "txbf", 1);
+
 	/* do bus specific preinit here */
 	err = brcmf_bus_preinit(ifp->drvr->bus_if);
 done:
diff --git a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/fwil_types.h b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/fwil_types.h
index 2bcd187..18483e7 100644
--- a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/fwil_types.h
+++ b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/fwil_types.h
@@ -121,6 +121,11 @@
 
 #define BRCMF_MAX_ASSOCLIST		128
 
+#define BRCMF_TXBF_SU_BFE_CAP		BIT(0)
+#define BRCMF_TXBF_MU_BFE_CAP		BIT(1)
+#define BRCMF_TXBF_SU_BFR_CAP		BIT(0)
+#define BRCMF_TXBF_MU_BFR_CAP		BIT(1)
+
 /* join preference types for join_pref iovar */
 enum brcmf_join_pref_types {
 	BRCMF_JOIN_PREF_RSSI = 1,
-- 
1.9.1

