Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from ebb05.tieto.com ([131.207.168.36]:63292 "EHLO ebb05.tieto.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752349Ab3JRKIH (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 18 Oct 2013 06:08:07 -0400
From: Bartosz Markowski <bartosz.markowski@tieto.com>
To: <ath10k@lists.infradead.org>
CC: <linux-wireless@vger.kernel.org>,
	Bartosz Markowski <bartosz.markowski@tieto.com>
Subject: [PATCH 1/2] ath10k: remove P2P from supported interface modes for 10.X FW
Date: Fri, 18 Oct 2013 12:07:57 +0200
Message-ID: <1382090878-22216-1-git-send-email-bartosz.markowski@tieto.com> (sfid-20131018_120811_944078_0919764F)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

FW 10.X does not support P2P, stop advertising it to mac80211.

Signed-off-by: Bartosz Markowski <bartosz.markowski@tieto.com>
---
 drivers/net/wireless/ath/ath10k/mac.c |   44 +++++++++++++++++++++++++++------
 1 file changed, 37 insertions(+), 7 deletions(-)

diff --git a/drivers/net/wireless/ath/ath10k/mac.c b/drivers/net/wireless/ath/ath10k/mac.c
index 0b1cc51..af046c4 100644
--- a/drivers/net/wireless/ath/ath10k/mac.c
+++ b/drivers/net/wireless/ath/ath10k/mac.c
@@ -3249,6 +3249,17 @@ static const struct ieee80211_iface_limit ath10k_if_limits[] = {
 	},
 };
 
+static const struct ieee80211_iface_limit ath10k_10x_if_limits[] = {
+	{
+	.max	= 8,
+	.types	= BIT(NL80211_IFTYPE_STATION)
+	},
+	{
+	.max	= 7,
+	.types	= BIT(NL80211_IFTYPE_AP)
+	},
+};
+
 static const struct ieee80211_iface_combination ath10k_if_comb = {
 	.limits = ath10k_if_limits,
 	.n_limits = ARRAY_SIZE(ath10k_if_limits),
@@ -3257,6 +3268,14 @@ static const struct ieee80211_iface_combination ath10k_if_comb = {
 	.beacon_int_infra_match = true,
 };
 
+static const struct ieee80211_iface_combination ath10k_10x_if_comb = {
+	.limits = ath10k_10x_if_limits,
+	.n_limits = ARRAY_SIZE(ath10k_10x_if_limits),
+	.max_interfaces = 8,
+	.num_different_channels = 1,
+	.beacon_int_infra_match = true,
+};
+
 static struct ieee80211_sta_vht_cap ath10k_create_vht_cap(struct ath10k *ar)
 {
 	struct ieee80211_sta_vht_cap vht_cap = {0};
@@ -3430,12 +3449,19 @@ int ath10k_mac_register(struct ath10k *ar)
 		ar->hw->wiphy->bands[IEEE80211_BAND_5GHZ] = band;
 	}
 
-	ar->hw->wiphy->interface_modes =
-		BIT(NL80211_IFTYPE_STATION) |
-		BIT(NL80211_IFTYPE_ADHOC) |
-		BIT(NL80211_IFTYPE_AP) |
-		BIT(NL80211_IFTYPE_P2P_CLIENT) |
-		BIT(NL80211_IFTYPE_P2P_GO);
+	/* 10.x firmware does not support P2P */
+	if (test_bit(ATH10K_FW_FEATURE_WMI_10X, ar->fw_features))
+		ar->hw->wiphy->interface_modes =
+			BIT(NL80211_IFTYPE_STATION) |
+			BIT(NL80211_IFTYPE_ADHOC) |
+			BIT(NL80211_IFTYPE_AP);
+	else
+		ar->hw->wiphy->interface_modes =
+			BIT(NL80211_IFTYPE_STATION) |
+			BIT(NL80211_IFTYPE_ADHOC) |
+			BIT(NL80211_IFTYPE_AP) |
+			BIT(NL80211_IFTYPE_P2P_CLIENT) |
+			BIT(NL80211_IFTYPE_P2P_GO);
 
 	ar->hw->flags = IEEE80211_HW_SIGNAL_DBM |
 			IEEE80211_HW_SUPPORTS_PS |
@@ -3478,7 +3504,11 @@ int ath10k_mac_register(struct ath10k *ar)
 	 */
 	ar->hw->queues = 4;
 
-	ar->hw->wiphy->iface_combinations = &ath10k_if_comb;
+	if (test_bit(ATH10K_FW_FEATURE_WMI_10X, ar->fw_features))
+		ar->hw->wiphy->iface_combinations = &ath10k_10x_if_comb;
+	else
+		ar->hw->wiphy->iface_combinations = &ath10k_if_comb;
+
 	ar->hw->wiphy->n_iface_combinations = 1;
 
 	ar->hw->netdev_features = NETIF_F_HW_CSUM;
-- 
1.7.10

