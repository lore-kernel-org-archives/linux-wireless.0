Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-la0-f49.google.com ([209.85.215.49]:34728 "EHLO
	mail-la0-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752622AbbIBLU6 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 2 Sep 2015 07:20:58 -0400
Received: by laeb10 with SMTP id b10so4731427lae.1
        for <linux-wireless@vger.kernel.org>; Wed, 02 Sep 2015 04:20:56 -0700 (PDT)
From: Bartosz Markowski <bartosz.markowski@tieto.com>
To: ath10k@lists.infradead.org
Cc: linux-wireless@vger.kernel.org,
	Bartosz Markowski <bartosz.markowski@tieto.com>
Subject: [PATCH 2/2] ath10k: fix beamformer VHT sounding dimensions capability
Date: Wed,  2 Sep 2015 13:20:20 +0200
Message-Id: <1441192820-8403-2-git-send-email-bartosz.markowski@tieto.com> (sfid-20150902_132106_298811_FB631F21)
In-Reply-To: <1441192820-8403-1-git-send-email-bartosz.markowski@tieto.com>
References: <1441192820-8403-1-git-send-email-bartosz.markowski@tieto.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Similarly to the VHT STS, this is supposed to be propagated by firmware.
In case it's not, use the default value, but as last resort.

Signed-off-by: Bartosz Markowski <bartosz.markowski@tieto.com>
---
 drivers/net/wireless/ath/ath10k/mac.c | 21 +++++++++++++++++++--
 1 file changed, 19 insertions(+), 2 deletions(-)

diff --git a/drivers/net/wireless/ath/ath10k/mac.c b/drivers/net/wireless/ath/ath10k/mac.c
index 25c20d18021a..db3be8f794e4 100644
--- a/drivers/net/wireless/ath/ath10k/mac.c
+++ b/drivers/net/wireless/ath/ath10k/mac.c
@@ -4080,11 +4080,27 @@ static int ath10k_mac_get_vht_cap_bf_sts(struct ath10k *ar)
 	return nsts;
 }
 
+static int ath10k_mac_get_vht_cap_bf_sound_dim(struct ath10k *ar)
+{
+	int sound_dim = ar->vht_cap_info;
+	sound_dim &= IEEE80211_VHT_CAP_SOUNDING_DIMENSIONS_MASK;
+	sound_dim >>=IEEE80211_VHT_CAP_SOUNDING_DIMENSIONS_SHIFT;
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
 static int ath10k_mac_set_txbf_conf(struct ath10k_vif *arvif)
 {
 	u32 value = 0;
 	struct ath10k *ar = arvif->ar;
 	int nsts;
+	int sound_dim;
 
 	if (ath10k_wmi_get_txbf_conf_scheme(ar) != WMI_TXBF_CONF_BEFORE_ASSOC)
 		return 0;
@@ -4094,9 +4110,10 @@ static int ath10k_mac_set_txbf_conf(struct ath10k_vif *arvif)
 				IEEE80211_VHT_CAP_MU_BEAMFORMEE_CAPABLE))
 		value |= SM(nsts, WMI_TXBF_STS_CAP_OFFSET);
 
+	sound_dim = ath10k_mac_get_vht_cap_bf_sound_dim(ar);
 	if (ar->vht_cap_info & (IEEE80211_VHT_CAP_SU_BEAMFORMER_CAPABLE |
 				IEEE80211_VHT_CAP_MU_BEAMFORMER_CAPABLE))
-		value |= SM((ar->num_rf_chains - 1), WMI_BF_SOUND_DIM_OFFSET);
+		value |= SM(sound_dim, WMI_BF_SOUND_DIM_OFFSET);
 
 	if (!value)
 		return 0;
@@ -6830,7 +6847,7 @@ static struct ieee80211_sta_vht_cap ath10k_create_vht_cap(struct ath10k *ar)
 
 	if (ar->vht_cap_info & (IEEE80211_VHT_CAP_SU_BEAMFORMER_CAPABLE |
 				IEEE80211_VHT_CAP_MU_BEAMFORMER_CAPABLE)) {
-		val = ar->num_rf_chains - 1;
+		val = ath10k_mac_get_vht_cap_bf_sound_dim(ar);
 		val <<= IEEE80211_VHT_CAP_SOUNDING_DIMENSIONS_SHIFT;
 		val &= IEEE80211_VHT_CAP_SOUNDING_DIMENSIONS_MASK;
 
-- 
2.1.2

