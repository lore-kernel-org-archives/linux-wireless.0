Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from charlotte.tuxdriver.com ([70.61.120.58]:42441 "EHLO
	smtp.tuxdriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752324Ab0D3TpP (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 30 Apr 2010 15:45:15 -0400
From: "John W. Linville" <linville@tuxdriver.com>
To: linux-wireless@vger.kernel.org
Cc: johannes@sipsolutions.net,
	"John W. Linville" <linville@tuxdriver.com>
Subject: [PATCH] mac80211: remove deprecated noise field from ieee80211_rx_status
Date: Fri, 30 Apr 2010 15:39:11 -0400
Message-Id: <1272656351-5983-1-git-send-email-linville@tuxdriver.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Also remove associated IEEE80211_HW_NOISE_DBM from ieee80211_hw_flags.

Signed-off-by: John W. Linville <linville@tuxdriver.com>
---
 drivers/net/wireless/ath/ar9170/main.c      |    3 +--
 drivers/net/wireless/ath/ath5k/base.c       |    3 +--
 drivers/net/wireless/b43/main.c             |    3 +--
 drivers/net/wireless/b43legacy/main.c       |    3 +--
 drivers/net/wireless/iwlwifi/iwl-agn.c      |    1 -
 drivers/net/wireless/iwlwifi/iwl3945-base.c |    1 -
 drivers/net/wireless/mwl8k.c                |    4 ++--
 drivers/net/wireless/p54/main.c             |    3 +--
 drivers/net/wireless/wl12xx/wl1251_main.c   |    1 -
 drivers/net/wireless/wl12xx/wl1271_main.c   |    1 -
 include/net/mac80211.h                      |    8 +-------
 net/mac80211/rx.c                           |    2 --
 12 files changed, 8 insertions(+), 25 deletions(-)

diff --git a/drivers/net/wireless/ath/ar9170/main.c b/drivers/net/wireless/ath/ar9170/main.c
index cfc6a35..dfcc055 100644
--- a/drivers/net/wireless/ath/ar9170/main.c
+++ b/drivers/net/wireless/ath/ar9170/main.c
@@ -2550,8 +2550,7 @@ void *ar9170_alloc(size_t priv_size)
 					 BIT(NL80211_IFTYPE_ADHOC);
 	ar->hw->flags |= IEEE80211_HW_RX_INCLUDES_FCS |
 			 IEEE80211_HW_HOST_BROADCAST_PS_BUFFERING |
-			 IEEE80211_HW_SIGNAL_DBM |
-			 IEEE80211_HW_NOISE_DBM;
+			 IEEE80211_HW_SIGNAL_DBM;
 
 	if (modparam_ht) {
 		ar->hw->flags |= IEEE80211_HW_AMPDU_AGGREGATION;
diff --git a/drivers/net/wireless/ath/ath5k/base.c b/drivers/net/wireless/ath/ath5k/base.c
index 1f3e5b0..feb7b9e 100644
--- a/drivers/net/wireless/ath/ath5k/base.c
+++ b/drivers/net/wireless/ath/ath5k/base.c
@@ -547,8 +547,7 @@ ath5k_pci_probe(struct pci_dev *pdev,
 	SET_IEEE80211_DEV(hw, &pdev->dev);
 	hw->flags = IEEE80211_HW_RX_INCLUDES_FCS |
 		    IEEE80211_HW_HOST_BROADCAST_PS_BUFFERING |
-		    IEEE80211_HW_SIGNAL_DBM |
-		    IEEE80211_HW_NOISE_DBM;
+		    IEEE80211_HW_SIGNAL_DBM;
 
 	hw->wiphy->interface_modes =
 		BIT(NL80211_IFTYPE_AP) |
diff --git a/drivers/net/wireless/b43/main.c b/drivers/net/wireless/b43/main.c
index 14cf3bd..e057559 100644
--- a/drivers/net/wireless/b43/main.c
+++ b/drivers/net/wireless/b43/main.c
@@ -4904,8 +4904,7 @@ static int b43_wireless_init(struct ssb_device *dev)
 
 	/* fill hw info */
 	hw->flags = IEEE80211_HW_RX_INCLUDES_FCS |
-		    IEEE80211_HW_SIGNAL_DBM |
-		    IEEE80211_HW_NOISE_DBM;
+		    IEEE80211_HW_SIGNAL_DBM;
 
 	hw->wiphy->interface_modes =
 		BIT(NL80211_IFTYPE_AP) |
diff --git a/drivers/net/wireless/b43legacy/main.c b/drivers/net/wireless/b43legacy/main.c
index 1d070be..b2df432 100644
--- a/drivers/net/wireless/b43legacy/main.c
+++ b/drivers/net/wireless/b43legacy/main.c
@@ -3768,8 +3768,7 @@ static int b43legacy_wireless_init(struct ssb_device *dev)
 
 	/* fill hw info */
 	hw->flags = IEEE80211_HW_RX_INCLUDES_FCS |
-		    IEEE80211_HW_SIGNAL_DBM |
-		    IEEE80211_HW_NOISE_DBM;
+		    IEEE80211_HW_SIGNAL_DBM;
 	hw->wiphy->interface_modes =
 		BIT(NL80211_IFTYPE_AP) |
 		BIT(NL80211_IFTYPE_STATION) |
diff --git a/drivers/net/wireless/iwlwifi/iwl-agn.c b/drivers/net/wireless/iwlwifi/iwl-agn.c
index c22d3d8..0cd3386 100644
--- a/drivers/net/wireless/iwlwifi/iwl-agn.c
+++ b/drivers/net/wireless/iwlwifi/iwl-agn.c
@@ -2653,7 +2653,6 @@ static int iwl_mac_setup_register(struct iwl_priv *priv)
 
 	/* Tell mac80211 our characteristics */
 	hw->flags = IEEE80211_HW_SIGNAL_DBM |
-		    IEEE80211_HW_NOISE_DBM |
 		    IEEE80211_HW_AMPDU_AGGREGATION |
 		    IEEE80211_HW_SPECTRUM_MGMT;
 
diff --git a/drivers/net/wireless/iwlwifi/iwl3945-base.c b/drivers/net/wireless/iwlwifi/iwl3945-base.c
index e7263ed..c9da39d 100644
--- a/drivers/net/wireless/iwlwifi/iwl3945-base.c
+++ b/drivers/net/wireless/iwlwifi/iwl3945-base.c
@@ -3872,7 +3872,6 @@ static int iwl3945_setup_mac(struct iwl_priv *priv)
 
 	/* Tell mac80211 our characteristics */
 	hw->flags = IEEE80211_HW_SIGNAL_DBM |
-		    IEEE80211_HW_NOISE_DBM |
 		    IEEE80211_HW_SPECTRUM_MGMT;
 
 	if (!priv->cfg->broken_powersave)
diff --git a/drivers/net/wireless/mwl8k.c b/drivers/net/wireless/mwl8k.c
index 9af6c94..a90bb6d 100644
--- a/drivers/net/wireless/mwl8k.c
+++ b/drivers/net/wireless/mwl8k.c
@@ -3981,8 +3981,8 @@ static int __devinit mwl8k_probe(struct pci_dev *pdev,
 
 	hw->queues = MWL8K_TX_QUEUES;
 
-	/* Set rssi and noise values to dBm */
-	hw->flags |= IEEE80211_HW_SIGNAL_DBM | IEEE80211_HW_NOISE_DBM;
+	/* Set rssi values to dBm */
+	hw->flags |= IEEE80211_HW_SIGNAL_DBM;
 	hw->vif_data_size = sizeof(struct mwl8k_vif);
 	hw->sta_data_size = sizeof(struct mwl8k_sta);
 
diff --git a/drivers/net/wireless/p54/main.c b/drivers/net/wireless/p54/main.c
index 36f4c82..10a4b16 100644
--- a/drivers/net/wireless/p54/main.c
+++ b/drivers/net/wireless/p54/main.c
@@ -545,8 +545,7 @@ struct ieee80211_hw *p54_init_common(size_t priv_data_len)
 		     IEEE80211_HW_SUPPORTS_PS |
 		     IEEE80211_HW_PS_NULLFUNC_STACK |
 		     IEEE80211_HW_BEACON_FILTER |
-		     IEEE80211_HW_REPORTS_TX_ACK_STATUS |
-		     IEEE80211_HW_NOISE_DBM;
+		     IEEE80211_HW_REPORTS_TX_ACK_STATUS;
 
 	dev->wiphy->interface_modes = BIT(NL80211_IFTYPE_STATION) |
 				      BIT(NL80211_IFTYPE_ADHOC) |
diff --git a/drivers/net/wireless/wl12xx/wl1251_main.c b/drivers/net/wireless/wl12xx/wl1251_main.c
index 4d3be80..b70621f 100644
--- a/drivers/net/wireless/wl12xx/wl1251_main.c
+++ b/drivers/net/wireless/wl12xx/wl1251_main.c
@@ -1291,7 +1291,6 @@ int wl1251_init_ieee80211(struct wl1251 *wl)
 	wl->hw->channel_change_time = 10000;
 
 	wl->hw->flags = IEEE80211_HW_SIGNAL_DBM |
-		IEEE80211_HW_NOISE_DBM |
 		IEEE80211_HW_SUPPORTS_PS |
 		IEEE80211_HW_BEACON_FILTER |
 		IEEE80211_HW_SUPPORTS_UAPSD;
diff --git a/drivers/net/wireless/wl12xx/wl1271_main.c b/drivers/net/wireless/wl12xx/wl1271_main.c
index a794d5e..b083725 100644
--- a/drivers/net/wireless/wl12xx/wl1271_main.c
+++ b/drivers/net/wireless/wl12xx/wl1271_main.c
@@ -2275,7 +2275,6 @@ int wl1271_init_ieee80211(struct wl1271 *wl)
 	wl->hw->max_listen_interval = wl->conf.conn.max_listen_interval;
 
 	wl->hw->flags = IEEE80211_HW_SIGNAL_DBM |
-		IEEE80211_HW_NOISE_DBM |
 		IEEE80211_HW_BEACON_FILTER |
 		IEEE80211_HW_SUPPORTS_PS |
 		IEEE80211_HW_SUPPORTS_UAPSD |
diff --git a/include/net/mac80211.h b/include/net/mac80211.h
index 2879c8e..00502b1 100644
--- a/include/net/mac80211.h
+++ b/include/net/mac80211.h
@@ -560,7 +560,6 @@ enum mac80211_rx_flags {
  * @signal: signal strength when receiving this frame, either in dBm, in dB or
  *	unspecified depending on the hardware capabilities flags
  *	@IEEE80211_HW_SIGNAL_*
- * @noise: noise when receiving this frame, in dBm (DEPRECATED).
  * @antenna: antenna used
  * @rate_idx: index of data rate into band's supported rates or MCS index if
  *	HT rates are use (RX_FLAG_HT)
@@ -571,7 +570,6 @@ struct ieee80211_rx_status {
 	enum ieee80211_band band;
 	int freq;
 	int signal;
-	int noise __deprecated;
 	int antenna;
 	int rate_idx;
 	int flag;
@@ -934,10 +932,6 @@ enum ieee80211_tkip_key_type {
  *	one milliwatt. This is the preferred method since it is standardized
  *	between different devices. @max_signal does not need to be set.
  *
- * @IEEE80211_HW_NOISE_DBM:
- *	Hardware can provide noise (radio interference) values in units dBm,
- *      decibel difference from one milliwatt.
- *
  * @IEEE80211_HW_SPECTRUM_MGMT:
  * 	Hardware supports spectrum management defined in 802.11h
  * 	Measurement, Channel Switch, Quieting, TPC
@@ -1001,7 +995,7 @@ enum ieee80211_hw_flags {
 	IEEE80211_HW_2GHZ_SHORT_PREAMBLE_INCAPABLE	= 1<<4,
 	IEEE80211_HW_SIGNAL_UNSPEC			= 1<<5,
 	IEEE80211_HW_SIGNAL_DBM				= 1<<6,
-	IEEE80211_HW_NOISE_DBM				= 1<<7,
+	/* use this hole */
 	IEEE80211_HW_SPECTRUM_MGMT			= 1<<8,
 	IEEE80211_HW_AMPDU_AGGREGATION			= 1<<9,
 	IEEE80211_HW_SUPPORTS_PS			= 1<<10,
diff --git a/net/mac80211/rx.c b/net/mac80211/rx.c
index 8ee7db1..e4f325f 100644
--- a/net/mac80211/rx.c
+++ b/net/mac80211/rx.c
@@ -80,8 +80,6 @@ ieee80211_rx_radiotap_len(struct ieee80211_local *local,
 		len += 8;
 	if (local->hw.flags & IEEE80211_HW_SIGNAL_DBM)
 		len += 1;
-	if (local->hw.flags & IEEE80211_HW_NOISE_DBM)
-		len += 1;
 
 	if (len & 1) /* padding for RX_FLAGS if necessary */
 		len++;
-- 
1.6.6.1

