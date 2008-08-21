Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from hostap.isc.org ([149.20.54.63]:50879 "EHLO hostap.isc.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754635AbYHUSqo (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 21 Aug 2008 14:46:44 -0400
Date: Thu, 21 Aug 2008 21:45:56 +0300
From: Jouni Malinen <jouni.malinen@atheros.com>
To: "John W. Linville" <linville@tuxdriver.com>
Cc: linux-wireless@vger.kernel.org
Subject: mac80211_hwsim: Add minimal IEEE 802.11n support
Message-ID: <20080821184556.GD4846@jm.kir.nu> (sfid-20080821_204647_587985_C704CE55)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Set some semi-random values for HT and add more queues to allow IEEE
802.11n association to be tested with mac80211_hwsim. This with the
latest hostapd git tree version can complete a simulated 802.11n
association successfully (with mac80211 client MLME).

Signed-off-by: Jouni Malinen <jouni.malinen@atheros.com>


Index: wireless-testing/drivers/net/wireless/mac80211_hwsim.c
===================================================================
--- wireless-testing.orig/drivers/net/wireless/mac80211_hwsim.c
+++ wireless-testing/drivers/net/wireless/mac80211_hwsim.c
@@ -446,7 +446,8 @@ static int __init init_mac80211_hwsim(vo
 		SET_IEEE80211_PERM_ADDR(hw, addr);
 
 		hw->channel_change_time = 1;
-		hw->queues = 1;
+		hw->queues = 4;
+		hw->ampdu_queues = 1;
 
 		memcpy(data->channels, hwsim_channels, sizeof(hwsim_channels));
 		memcpy(data->rates, hwsim_rates, sizeof(hwsim_rates));
@@ -454,6 +455,19 @@ static int __init init_mac80211_hwsim(vo
 		data->band.n_channels = ARRAY_SIZE(hwsim_channels);
 		data->band.bitrates = data->rates;
 		data->band.n_bitrates = ARRAY_SIZE(hwsim_rates);
+		data->band.ht_info.ht_supported = 1;
+		data->band.ht_info.cap = IEEE80211_HT_CAP_SUP_WIDTH |
+			IEEE80211_HT_CAP_GRN_FLD |
+			IEEE80211_HT_CAP_SGI_40 |
+			IEEE80211_HT_CAP_DSSSCCK40;
+		data->band.ht_info.ampdu_factor = 0x3;
+		data->band.ht_info.ampdu_density = 0x6;
+		memset(data->band.ht_info.supp_mcs_set, 0,
+		       sizeof(data->band.ht_info.supp_mcs_set));
+		data->band.ht_info.supp_mcs_set[0] = 0xff;
+		data->band.ht_info.supp_mcs_set[1] = 0xff;
+		data->band.ht_info.supp_mcs_set[12] =
+			IEEE80211_HT_CAP_MCS_TX_DEFINED;
 		hw->wiphy->bands[IEEE80211_BAND_2GHZ] = &data->band;
 
 		err = ieee80211_register_hw(hw);

-- 
Jouni Malinen                                            PGP id EFC895FA
