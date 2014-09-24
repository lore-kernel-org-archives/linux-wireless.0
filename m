Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail2.candelatech.com ([208.74.158.173]:59830 "EHLO
	mail2.candelatech.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751078AbaIXQfL (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 24 Sep 2014 12:35:11 -0400
From: greearb@candelatech.com
To: linux-wireless@vger.kernel.org
Cc: ath10k@lists.infradead.org, Ben Greear <greearb@candelatech.com>
Subject: [PATCH 1/2] ath10k: move create-ht-cap methods above set-antenna.
Date: Wed, 24 Sep 2014 09:35:05 -0700
Message-Id: <1411576506-11815-1-git-send-email-greearb@candelatech.com> (sfid-20140924_183515_016124_9632851A)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Ben Greear <greearb@candelatech.com>

We will need to use these in set-antenna, so move them
so that we do not have to define the method signatures.

Signed-off-by: Ben Greear <greearb@candelatech.com>
---
 drivers/net/wireless/ath/ath10k/mac.c | 172 +++++++++++++++++-----------------
 1 file changed, 86 insertions(+), 86 deletions(-)

diff --git a/drivers/net/wireless/ath/ath10k/mac.c b/drivers/net/wireless/ath/ath10k/mac.c
index bde3a2f..dbef84a 100644
--- a/drivers/net/wireless/ath/ath10k/mac.c
+++ b/drivers/net/wireless/ath/ath10k/mac.c
@@ -2408,6 +2408,92 @@ void ath10k_halt(struct ath10k *ar)
 	spin_unlock_bh(&ar->data_lock);
 }
 
+static struct ieee80211_sta_vht_cap ath10k_create_vht_cap(struct ath10k *ar)
+{
+	struct ieee80211_sta_vht_cap vht_cap = {0};
+	u16 mcs_map;
+	int i;
+
+	vht_cap.vht_supported = 1;
+	vht_cap.cap = ar->vht_cap_info;
+
+	mcs_map = 0;
+	for (i = 0; i < 8; i++) {
+		if (i < ar->num_rf_chains)
+			mcs_map |= IEEE80211_VHT_MCS_SUPPORT_0_9 << (i*2);
+		else
+			mcs_map |= IEEE80211_VHT_MCS_NOT_SUPPORTED << (i*2);
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
+	for (i = 0; i < ar->num_rf_chains; i++)
+		ht_cap.mcs.rx_mask[i] = 0xFF;
+
+	ht_cap.mcs.tx_params |= IEEE80211_HT_MCS_TX_DEFINED;
+
+	return ht_cap;
+}
+
 static int ath10k_get_antenna(struct ieee80211_hw *hw, u32 *tx_ant, u32 *rx_ant)
 {
 	struct ath10k *ar = hw->priv;
@@ -4735,92 +4821,6 @@ static const struct ieee80211_iface_combination ath10k_10x_if_comb[] = {
 	},
 };
 
-static struct ieee80211_sta_vht_cap ath10k_create_vht_cap(struct ath10k *ar)
-{
-	struct ieee80211_sta_vht_cap vht_cap = {0};
-	u16 mcs_map;
-	int i;
-
-	vht_cap.vht_supported = 1;
-	vht_cap.cap = ar->vht_cap_info;
-
-	mcs_map = 0;
-	for (i = 0; i < 8; i++) {
-		if (i < ar->num_rf_chains)
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
-	for (i = 0; i < ar->num_rf_chains; i++)
-		ht_cap.mcs.rx_mask[i] = 0xFF;
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
1.7.11.7

