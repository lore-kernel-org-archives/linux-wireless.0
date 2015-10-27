Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wolverine02.qualcomm.com ([199.106.114.251]:14973 "EHLO
	wolverine02.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754289AbbJ0MWo (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 27 Oct 2015 08:22:44 -0400
From: Rajkumar Manoharan <rmanohar@qti.qualcomm.com>
To: <ath10k@lists.infradead.org>
CC: <linux-wireless@vger.kernel.org>,
	Rajkumar Manoharan <rmanohar@qti.qualcomm.com>
Subject: [PATCH 4/4] ath10k: reload HT/VHT capabilities on antenna change
Date: Tue, 27 Oct 2015 17:51:14 +0530
Message-ID: <1445948474-16738-4-git-send-email-rmanohar@qti.qualcomm.com> (sfid-20151027_132247_187404_BD41B60F)
In-Reply-To: <1445948474-16738-1-git-send-email-rmanohar@qti.qualcomm.com>
References: <1445948474-16738-1-git-send-email-rmanohar@qti.qualcomm.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

To reflect configured antenna settings in HT/VHT MCS map,
reload the HT/VHT capabilities upon antenna change.

Signed-off-by: Rajkumar Manoharan <rmanohar@qti.qualcomm.com>
---
 drivers/net/wireless/ath/ath10k/mac.c | 39 +++++++++++++++++++++++++----------
 1 file changed, 28 insertions(+), 11 deletions(-)

diff --git a/drivers/net/wireless/ath/ath10k/mac.c b/drivers/net/wireless/ath/ath10k/mac.c
index 2217494..5782ec9 100644
--- a/drivers/net/wireless/ath/ath10k/mac.c
+++ b/drivers/net/wireless/ath/ath10k/mac.c
@@ -3897,6 +3897,29 @@ static struct ieee80211_sta_ht_cap ath10k_get_ht_cap(struct ath10k *ar)
 	return ht_cap;
 }
 
+static void ath10k_mac_setup_ht_vht_cap(struct ath10k *ar)
+{
+	struct ieee80211_supported_band *band;
+	struct ieee80211_sta_vht_cap vht_cap;
+	struct ieee80211_sta_ht_cap ht_cap;
+
+	ht_cap = ath10k_get_ht_cap(ar);
+	vht_cap = ath10k_create_vht_cap(ar);
+
+	if (ar->phy_capability & WHAL_WLAN_11G_CAPABILITY) {
+		band = &ar->mac.sbands[IEEE80211_BAND_2GHZ];
+		band->ht_cap = ht_cap;
+
+		/* Enable the VHT support at 2.4 GHz */
+		band->vht_cap = vht_cap;
+	}
+	if (ar->phy_capability & WHAL_WLAN_11A_CAPABILITY) {
+		band = &ar->mac.sbands[IEEE80211_BAND_5GHZ];
+		band->ht_cap = ht_cap;
+		band->vht_cap = vht_cap;
+	}
+}
+
 static int __ath10k_set_antenna(struct ath10k *ar, u32 tx_ant, u32 rx_ant)
 {
 	int ret;
@@ -3929,6 +3952,9 @@ static int __ath10k_set_antenna(struct ath10k *ar, u32 tx_ant, u32 rx_ant)
 		return ret;
 	}
 
+	/* Reload HT/VHT capability */
+	ath10k_mac_setup_ht_vht_cap(ar);
+
 	return 0;
 }
 
@@ -7090,8 +7116,6 @@ int ath10k_mac_register(struct ath10k *ar)
 		WLAN_CIPHER_SUITE_AES_CMAC,
 	};
 	struct ieee80211_supported_band *band;
-	struct ieee80211_sta_vht_cap vht_cap;
-	struct ieee80211_sta_ht_cap ht_cap;
 	void *channels;
 	int ret;
 
@@ -7099,9 +7123,6 @@ int ath10k_mac_register(struct ath10k *ar)
 
 	SET_IEEE80211_DEV(ar->hw, ar->dev);
 
-	ht_cap = ath10k_get_ht_cap(ar);
-	vht_cap = ath10k_create_vht_cap(ar);
-
 	BUILD_BUG_ON((ARRAY_SIZE(ath10k_2ghz_channels) +
 		      ARRAY_SIZE(ath10k_5ghz_channels)) !=
 		     ATH10K_NUM_CHANS);
@@ -7120,10 +7141,6 @@ int ath10k_mac_register(struct ath10k *ar)
 		band->channels = channels;
 		band->n_bitrates = ath10k_g_rates_size;
 		band->bitrates = ath10k_g_rates;
-		band->ht_cap = ht_cap;
-
-		/* Enable the VHT support at 2.4 GHz */
-		band->vht_cap = vht_cap;
 
 		ar->hw->wiphy->bands[IEEE80211_BAND_2GHZ] = band;
 	}
@@ -7142,11 +7159,11 @@ int ath10k_mac_register(struct ath10k *ar)
 		band->channels = channels;
 		band->n_bitrates = ath10k_a_rates_size;
 		band->bitrates = ath10k_a_rates;
-		band->ht_cap = ht_cap;
-		band->vht_cap = vht_cap;
 		ar->hw->wiphy->bands[IEEE80211_BAND_5GHZ] = band;
 	}
 
+	ath10k_mac_setup_ht_vht_cap(ar);
+
 	ar->hw->wiphy->interface_modes =
 		BIT(NL80211_IFTYPE_STATION) |
 		BIT(NL80211_IFTYPE_AP) |
-- 
2.6.2

