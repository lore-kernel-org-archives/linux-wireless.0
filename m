Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wolverine02.qualcomm.com ([199.106.114.251]:31834 "EHLO
	wolverine02.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754300AbbJ0MWW (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 27 Oct 2015 08:22:22 -0400
From: Rajkumar Manoharan <rmanohar@qti.qualcomm.com>
To: <ath10k@lists.infradead.org>
CC: <linux-wireless@vger.kernel.org>,
	Rajkumar Manoharan <rmanohar@qti.qualcomm.com>
Subject: [PATCH 3/4] ath10k: move static HT/VHT capability setup functions
Date: Tue, 27 Oct 2015 17:51:13 +0530
Message-ID: <1445948474-16738-3-git-send-email-rmanohar@qti.qualcomm.com> (sfid-20151027_132225_302769_6F34621F)
In-Reply-To: <1445948474-16738-1-git-send-email-rmanohar@qti.qualcomm.com>
References: <1445948474-16738-1-git-send-email-rmanohar@qti.qualcomm.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Move HT and VHT capabiltity setup static functions to avoid
forward declaration.

Signed-off-by: Rajkumar Manoharan <rmanohar@qti.qualcomm.com>
---
 drivers/net/wireless/ath/ath10k/mac.c | 280 +++++++++++++++++-----------------
 1 file changed, 140 insertions(+), 140 deletions(-)

diff --git a/drivers/net/wireless/ath/ath10k/mac.c b/drivers/net/wireless/ath/ath10k/mac.c
index 4e799d4..2217494 100644
--- a/drivers/net/wireless/ath/ath10k/mac.c
+++ b/drivers/net/wireless/ath/ath10k/mac.c
@@ -3757,6 +3757,146 @@ static void ath10k_check_chain_mask(struct ath10k *ar, u32 cm, const char *dbg)
 		    dbg, cm);
 }
 
+static int ath10k_mac_get_vht_cap_bf_sts(struct ath10k *ar)
+{
+	int nsts = ar->vht_cap_info;
+
+	nsts &= IEEE80211_VHT_CAP_BEAMFORMEE_STS_MASK;
+	nsts >>= IEEE80211_VHT_CAP_BEAMFORMEE_STS_SHIFT;
+
+	/* If firmware does not deliver to host number of space-time
+	 * streams supported, assume it support up to 4 BF STS and return
+	 * the value for VHT CAP: nsts-1)
+	 */
+	if (nsts == 0)
+		return 3;
+
+	return nsts;
+}
+
+static int ath10k_mac_get_vht_cap_bf_sound_dim(struct ath10k *ar)
+{
+	int sound_dim = ar->vht_cap_info;
+
+	sound_dim &= IEEE80211_VHT_CAP_SOUNDING_DIMENSIONS_MASK;
+	sound_dim >>= IEEE80211_VHT_CAP_SOUNDING_DIMENSIONS_SHIFT;
+
+	/* If the sounding dimension is not advertised by the firmware,
+	 * let's use a default value of 1
+	 */
+	if (sound_dim == 0)
+		return 1;
+
+	return sound_dim;
+}
+
+static struct ieee80211_sta_vht_cap ath10k_create_vht_cap(struct ath10k *ar)
+{
+	struct ieee80211_sta_vht_cap vht_cap = {0};
+	u16 mcs_map;
+	u32 val;
+	int i;
+
+	vht_cap.vht_supported = 1;
+	vht_cap.cap = ar->vht_cap_info;
+
+	if (ar->vht_cap_info & (IEEE80211_VHT_CAP_SU_BEAMFORMEE_CAPABLE |
+				IEEE80211_VHT_CAP_MU_BEAMFORMEE_CAPABLE)) {
+		val = ath10k_mac_get_vht_cap_bf_sts(ar);
+		val <<= IEEE80211_VHT_CAP_BEAMFORMEE_STS_SHIFT;
+		val &= IEEE80211_VHT_CAP_BEAMFORMEE_STS_MASK;
+
+		vht_cap.cap |= val;
+	}
+
+	if (ar->vht_cap_info & (IEEE80211_VHT_CAP_SU_BEAMFORMER_CAPABLE |
+				IEEE80211_VHT_CAP_MU_BEAMFORMER_CAPABLE)) {
+		val = ath10k_mac_get_vht_cap_bf_sound_dim(ar);
+		val <<= IEEE80211_VHT_CAP_SOUNDING_DIMENSIONS_SHIFT;
+		val &= IEEE80211_VHT_CAP_SOUNDING_DIMENSIONS_MASK;
+
+		vht_cap.cap |= val;
+	}
+
+	mcs_map = 0;
+	for (i = 0; i < 8; i++) {
+		if ((i < ar->num_rf_chains) && (ar->cfg_tx_chainmask & BIT(i)))
+			mcs_map |= IEEE80211_VHT_MCS_SUPPORT_0_9 << (i * 2);
+		else
+			mcs_map |= IEEE80211_VHT_MCS_NOT_SUPPORTED << (i * 2);
+	}
+
+	vht_cap.vht_mcs.rx_mcs_map = cpu_to_le16(mcs_map);
+	vht_cap.vht_mcs.tx_mcs_map = cpu_to_le16(mcs_map);
+
+	return vht_cap;
+}
+
+static struct ieee80211_sta_ht_cap ath10k_get_ht_cap(struct ath10k *ar)
+{
+	int i;
+	struct ieee80211_sta_ht_cap ht_cap = {0};
+
+	if (!(ar->ht_cap_info & WMI_HT_CAP_ENABLED))
+		return ht_cap;
+
+	ht_cap.ht_supported = 1;
+	ht_cap.ampdu_factor = IEEE80211_HT_MAX_AMPDU_64K;
+	ht_cap.ampdu_density = IEEE80211_HT_MPDU_DENSITY_8;
+	ht_cap.cap |= IEEE80211_HT_CAP_SUP_WIDTH_20_40;
+	ht_cap.cap |= IEEE80211_HT_CAP_DSSSCCK40;
+	ht_cap.cap |= WLAN_HT_CAP_SM_PS_STATIC << IEEE80211_HT_CAP_SM_PS_SHIFT;
+
+	if (ar->ht_cap_info & WMI_HT_CAP_HT20_SGI)
+		ht_cap.cap |= IEEE80211_HT_CAP_SGI_20;
+
+	if (ar->ht_cap_info & WMI_HT_CAP_HT40_SGI)
+		ht_cap.cap |= IEEE80211_HT_CAP_SGI_40;
+
+	if (ar->ht_cap_info & WMI_HT_CAP_DYNAMIC_SMPS) {
+		u32 smps;
+
+		smps   = WLAN_HT_CAP_SM_PS_DYNAMIC;
+		smps <<= IEEE80211_HT_CAP_SM_PS_SHIFT;
+
+		ht_cap.cap |= smps;
+	}
+
+	if (ar->ht_cap_info & WMI_HT_CAP_TX_STBC)
+		ht_cap.cap |= IEEE80211_HT_CAP_TX_STBC;
+
+	if (ar->ht_cap_info & WMI_HT_CAP_RX_STBC) {
+		u32 stbc;
+
+		stbc   = ar->ht_cap_info;
+		stbc  &= WMI_HT_CAP_RX_STBC;
+		stbc >>= WMI_HT_CAP_RX_STBC_MASK_SHIFT;
+		stbc <<= IEEE80211_HT_CAP_RX_STBC_SHIFT;
+		stbc  &= IEEE80211_HT_CAP_RX_STBC;
+
+		ht_cap.cap |= stbc;
+	}
+
+	if (ar->ht_cap_info & WMI_HT_CAP_LDPC)
+		ht_cap.cap |= IEEE80211_HT_CAP_LDPC_CODING;
+
+	if (ar->ht_cap_info & WMI_HT_CAP_L_SIG_TXOP_PROT)
+		ht_cap.cap |= IEEE80211_HT_CAP_LSIG_TXOP_PROT;
+
+	/* max AMSDU is implicitly taken from vht_cap_info */
+	if (ar->vht_cap_info & WMI_VHT_CAP_MAX_MPDU_LEN_MASK)
+		ht_cap.cap |= IEEE80211_HT_CAP_MAX_AMSDU;
+
+	for (i = 0; i < ar->num_rf_chains; i++) {
+		if (ar->cfg_rx_chainmask & BIT(i))
+			ht_cap.mcs.rx_mask[i] = 0xFF;
+	}
+
+	ht_cap.mcs.tx_params |= IEEE80211_HT_MCS_TX_DEFINED;
+
+	return ht_cap;
+}
+
 static int __ath10k_set_antenna(struct ath10k *ar, u32 tx_ant, u32 rx_ant)
 {
 	int ret;
@@ -4056,39 +4196,6 @@ static u32 get_nss_from_chainmask(u16 chain_mask)
 	return 1;
 }
 
-static int ath10k_mac_get_vht_cap_bf_sts(struct ath10k *ar)
-{
-	int nsts = ar->vht_cap_info;
-
-	nsts &= IEEE80211_VHT_CAP_BEAMFORMEE_STS_MASK;
-	nsts >>= IEEE80211_VHT_CAP_BEAMFORMEE_STS_SHIFT;
-
-	/* If firmware does not deliver to host number of space-time
-	 * streams supported, assume it support up to 4 BF STS and return
-	 * the value for VHT CAP: nsts-1)
-	 * */
-	if (nsts == 0)
-		return 3;
-
-	return nsts;
-}
-
-static int ath10k_mac_get_vht_cap_bf_sound_dim(struct ath10k *ar)
-{
-	int sound_dim = ar->vht_cap_info;
-
-	sound_dim &= IEEE80211_VHT_CAP_SOUNDING_DIMENSIONS_MASK;
-	sound_dim >>= IEEE80211_VHT_CAP_SOUNDING_DIMENSIONS_SHIFT;
-
-	/* If the sounding dimension is not advertised by the firmware,
-	 * let's use a default value of 1
-	 */
-	if (sound_dim == 0)
-		return 1;
-
-	return sound_dim;
-}
-
 static int ath10k_mac_set_txbf_conf(struct ath10k_vif *arvif)
 {
 	u32 value = 0;
@@ -6942,113 +7049,6 @@ static const struct ieee80211_iface_combination ath10k_10_4_if_comb[] = {
 	},
 };
 
-static struct ieee80211_sta_vht_cap ath10k_create_vht_cap(struct ath10k *ar)
-{
-	struct ieee80211_sta_vht_cap vht_cap = {0};
-	u16 mcs_map;
-	u32 val;
-	int i;
-
-	vht_cap.vht_supported = 1;
-	vht_cap.cap = ar->vht_cap_info;
-
-	if (ar->vht_cap_info & (IEEE80211_VHT_CAP_SU_BEAMFORMEE_CAPABLE |
-				IEEE80211_VHT_CAP_MU_BEAMFORMEE_CAPABLE)) {
-		val = ath10k_mac_get_vht_cap_bf_sts(ar);
-		val <<= IEEE80211_VHT_CAP_BEAMFORMEE_STS_SHIFT;
-		val &= IEEE80211_VHT_CAP_BEAMFORMEE_STS_MASK;
-
-		vht_cap.cap |= val;
-	}
-
-	if (ar->vht_cap_info & (IEEE80211_VHT_CAP_SU_BEAMFORMER_CAPABLE |
-				IEEE80211_VHT_CAP_MU_BEAMFORMER_CAPABLE)) {
-		val = ath10k_mac_get_vht_cap_bf_sound_dim(ar);
-		val <<= IEEE80211_VHT_CAP_SOUNDING_DIMENSIONS_SHIFT;
-		val &= IEEE80211_VHT_CAP_SOUNDING_DIMENSIONS_MASK;
-
-		vht_cap.cap |= val;
-	}
-
-	mcs_map = 0;
-	for (i = 0; i < 8; i++) {
-		if ((i < ar->num_rf_chains) && (ar->cfg_tx_chainmask & BIT(i)))
-			mcs_map |= IEEE80211_VHT_MCS_SUPPORT_0_9 << (i*2);
-		else
-			mcs_map |= IEEE80211_VHT_MCS_NOT_SUPPORTED << (i*2);
-	}
-
-	vht_cap.vht_mcs.rx_mcs_map = cpu_to_le16(mcs_map);
-	vht_cap.vht_mcs.tx_mcs_map = cpu_to_le16(mcs_map);
-
-	return vht_cap;
-}
-
-static struct ieee80211_sta_ht_cap ath10k_get_ht_cap(struct ath10k *ar)
-{
-	int i;
-	struct ieee80211_sta_ht_cap ht_cap = {0};
-
-	if (!(ar->ht_cap_info & WMI_HT_CAP_ENABLED))
-		return ht_cap;
-
-	ht_cap.ht_supported = 1;
-	ht_cap.ampdu_factor = IEEE80211_HT_MAX_AMPDU_64K;
-	ht_cap.ampdu_density = IEEE80211_HT_MPDU_DENSITY_8;
-	ht_cap.cap |= IEEE80211_HT_CAP_SUP_WIDTH_20_40;
-	ht_cap.cap |= IEEE80211_HT_CAP_DSSSCCK40;
-	ht_cap.cap |= WLAN_HT_CAP_SM_PS_STATIC << IEEE80211_HT_CAP_SM_PS_SHIFT;
-
-	if (ar->ht_cap_info & WMI_HT_CAP_HT20_SGI)
-		ht_cap.cap |= IEEE80211_HT_CAP_SGI_20;
-
-	if (ar->ht_cap_info & WMI_HT_CAP_HT40_SGI)
-		ht_cap.cap |= IEEE80211_HT_CAP_SGI_40;
-
-	if (ar->ht_cap_info & WMI_HT_CAP_DYNAMIC_SMPS) {
-		u32 smps;
-
-		smps   = WLAN_HT_CAP_SM_PS_DYNAMIC;
-		smps <<= IEEE80211_HT_CAP_SM_PS_SHIFT;
-
-		ht_cap.cap |= smps;
-	}
-
-	if (ar->ht_cap_info & WMI_HT_CAP_TX_STBC)
-		ht_cap.cap |= IEEE80211_HT_CAP_TX_STBC;
-
-	if (ar->ht_cap_info & WMI_HT_CAP_RX_STBC) {
-		u32 stbc;
-
-		stbc   = ar->ht_cap_info;
-		stbc  &= WMI_HT_CAP_RX_STBC;
-		stbc >>= WMI_HT_CAP_RX_STBC_MASK_SHIFT;
-		stbc <<= IEEE80211_HT_CAP_RX_STBC_SHIFT;
-		stbc  &= IEEE80211_HT_CAP_RX_STBC;
-
-		ht_cap.cap |= stbc;
-	}
-
-	if (ar->ht_cap_info & WMI_HT_CAP_LDPC)
-		ht_cap.cap |= IEEE80211_HT_CAP_LDPC_CODING;
-
-	if (ar->ht_cap_info & WMI_HT_CAP_L_SIG_TXOP_PROT)
-		ht_cap.cap |= IEEE80211_HT_CAP_LSIG_TXOP_PROT;
-
-	/* max AMSDU is implicitly taken from vht_cap_info */
-	if (ar->vht_cap_info & WMI_VHT_CAP_MAX_MPDU_LEN_MASK)
-		ht_cap.cap |= IEEE80211_HT_CAP_MAX_AMSDU;
-
-	for (i = 0; i < ar->num_rf_chains; i++) {
-		if (ar->cfg_rx_chainmask & BIT(i))
-			ht_cap.mcs.rx_mask[i] = 0xFF;
-	}
-
-	ht_cap.mcs.tx_params |= IEEE80211_HT_MCS_TX_DEFINED;
-
-	return ht_cap;
-}
-
 static void ath10k_get_arvif_iter(void *data, u8 *mac,
 				  struct ieee80211_vif *vif)
 {
-- 
2.6.2

