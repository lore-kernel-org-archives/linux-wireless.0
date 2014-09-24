Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail2.candelatech.com ([208.74.158.173]:59834 "EHLO
	mail2.candelatech.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751182AbaIXQfL (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 24 Sep 2014 12:35:11 -0400
From: greearb@candelatech.com
To: linux-wireless@vger.kernel.org
Cc: ath10k@lists.infradead.org, Ben Greear <greearb@candelatech.com>
Subject: [PATCH 2/2] ath10k: re-config ht_caps when chainmask is modified.
Date: Wed, 24 Sep 2014 09:35:06 -0700
Message-Id: <1411576506-11815-2-git-send-email-greearb@candelatech.com> (sfid-20140924_183517_535525_730084EC)
In-Reply-To: <1411576506-11815-1-git-send-email-greearb@candelatech.com>
References: <1411576506-11815-1-git-send-email-greearb@candelatech.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Ben Greear <greearb@candelatech.com>

This lets the mac80211 stack use the proper ht-caps when
negotiating with the peer.  Note that all vdevs are guaranteed
to be down when antenna changes, so we can set the ht_caps
without worrying about messing up existing stations.

This patch also moves the get_nss_from_chainmask up in
the file.

Signed-off-by: Ben Greear <greearb@candelatech.com>
---
 drivers/net/wireless/ath/ath10k/mac.c | 57 ++++++++++++++++++++++++-----------
 1 file changed, 40 insertions(+), 17 deletions(-)

diff --git a/drivers/net/wireless/ath/ath10k/mac.c b/drivers/net/wireless/ath/ath10k/mac.c
index dbef84a..8bd47ea 100644
--- a/drivers/net/wireless/ath/ath10k/mac.c
+++ b/drivers/net/wireless/ath/ath10k/mac.c
@@ -2408,18 +2408,34 @@ void ath10k_halt(struct ath10k *ar)
 	spin_unlock_bh(&ar->data_lock);
 }
 
-static struct ieee80211_sta_vht_cap ath10k_create_vht_cap(struct ath10k *ar)
+static u32 get_nss_from_chainmask(u16 chain_mask)
+{
+	if ((chain_mask & 0x15) == 0x15)
+		return 4;
+	else if ((chain_mask & 0x7) == 0x7)
+		return 3;
+	else if ((chain_mask & 0x3) == 0x3)
+		return 2;
+	return 1;
+}
+
+static struct ieee80211_sta_vht_cap ath10k_create_vht_cap(struct ath10k *ar,
+							  bool use_cfg_chains)
 {
 	struct ieee80211_sta_vht_cap vht_cap = {0};
 	u16 mcs_map;
 	int i;
+	int nrf = ar->num_rf_chains;
+
+	if (use_cfg_chains && ar->cfg_tx_chainmask)
+		nrf = get_nss_from_chainmask(ar->cfg_tx_chainmask);
 
 	vht_cap.vht_supported = 1;
 	vht_cap.cap = ar->vht_cap_info;
 
 	mcs_map = 0;
 	for (i = 0; i < 8; i++) {
-		if (i < ar->num_rf_chains)
+		if (i < nrf)
 			mcs_map |= IEEE80211_VHT_MCS_SUPPORT_0_9 << (i*2);
 		else
 			mcs_map |= IEEE80211_VHT_MCS_NOT_SUPPORTED << (i*2);
@@ -2431,10 +2447,15 @@ static struct ieee80211_sta_vht_cap ath10k_create_vht_cap(struct ath10k *ar)
 	return vht_cap;
 }
 
-static struct ieee80211_sta_ht_cap ath10k_get_ht_cap(struct ath10k *ar)
+static struct ieee80211_sta_ht_cap ath10k_get_ht_cap(struct ath10k *ar,
+						     bool use_cfg_chains)
 {
 	int i;
 	struct ieee80211_sta_ht_cap ht_cap = {0};
+	int nrf = ar->num_rf_chains;
+
+	if (use_cfg_chains && ar->cfg_tx_chainmask)
+		nrf = get_nss_from_chainmask(ar->cfg_tx_chainmask);
 
 	if (!(ar->ht_cap_info & WMI_HT_CAP_ENABLED))
 		return ht_cap;
@@ -2486,7 +2507,7 @@ static struct ieee80211_sta_ht_cap ath10k_get_ht_cap(struct ath10k *ar)
 	if (ar->vht_cap_info & WMI_VHT_CAP_MAX_MPDU_LEN_MASK)
 		ht_cap.cap |= IEEE80211_HT_CAP_MAX_AMSDU;
 
-	for (i = 0; i < ar->num_rf_chains; i++)
+	for (i = 0; i < nrf; i++)
 		ht_cap.mcs.rx_mask[i] = 0xFF;
 
 	ht_cap.mcs.tx_params |= IEEE80211_HT_MCS_TX_DEFINED;
@@ -2528,6 +2549,8 @@ static void ath10k_check_chain_mask(struct ath10k *ar, u32 cm, const char* dbg)
 static int __ath10k_set_antenna(struct ath10k *ar, u32 tx_ant, u32 rx_ant)
 {
 	int ret;
+	struct ieee80211_sta_vht_cap vht_cap;
+	struct ieee80211_sta_ht_cap ht_cap;
 
 	lockdep_assert_held(&ar->conf_mutex);
 
@@ -2537,6 +2560,17 @@ static int __ath10k_set_antenna(struct ath10k *ar, u32 tx_ant, u32 rx_ant)
 	ar->cfg_tx_chainmask = tx_ant;
 	ar->cfg_rx_chainmask = rx_ant;
 
+	ht_cap = ath10k_get_ht_cap(ar, true);
+	vht_cap = ath10k_create_vht_cap(ar, true);
+
+	if (ar->phy_capability & WHAL_WLAN_11G_CAPABILITY)
+		ar->mac.sbands[IEEE80211_BAND_2GHZ].ht_cap = ht_cap;
+
+	if (ar->phy_capability & WHAL_WLAN_11A_CAPABILITY) {
+		ar->mac.sbands[IEEE80211_BAND_5GHZ].ht_cap = ht_cap;
+		ar->mac.sbands[IEEE80211_BAND_5GHZ].vht_cap = vht_cap;
+	}
+
 	if ((ar->state != ATH10K_STATE_ON) &&
 	    (ar->state != ATH10K_STATE_RESTARTED))
 		return 0;
@@ -2859,17 +2893,6 @@ static int ath10k_config(struct ieee80211_hw *hw, u32 changed)
 	return ret;
 }
 
-static u32 get_nss_from_chainmask(u16 chain_mask)
-{
-	if ((chain_mask & 0x15) == 0x15)
-		return 4;
-	else if ((chain_mask & 0x7) == 0x7)
-		return 3;
-	else if ((chain_mask & 0x3) == 0x3)
-		return 2;
-	return 1;
-}
-
 /*
  * TODO:
  * Figure out how to handle WMI_VDEV_SUBTYPE_P2P_DEVICE,
@@ -4864,8 +4887,8 @@ int ath10k_mac_register(struct ath10k *ar)
 
 	SET_IEEE80211_DEV(ar->hw, ar->dev);
 
-	ht_cap = ath10k_get_ht_cap(ar);
-	vht_cap = ath10k_create_vht_cap(ar);
+	ht_cap = ath10k_get_ht_cap(ar, false);
+	vht_cap = ath10k_create_vht_cap(ar, false);
 
 	if (ar->phy_capability & WHAL_WLAN_11G_CAPABILITY) {
 		channels = kmemdup(ath10k_2ghz_channels,
-- 
1.7.11.7

