Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:38209 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932921Ab2CZQrW (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 26 Mar 2012 12:47:22 -0400
Message-ID: <1332780438.5435.53.camel@jlt3.sipsolutions.net> (sfid-20120326_184725_425617_B1AAF9AF)
Subject: [PATCH] mac80211: don't always advertise remain-on-channel
From: Johannes Berg <johannes@sipsolutions.net>
To: linux-wireless <linux-wireless@vger.kernel.org>
Cc: Jouni Malinen <j@w1.fi>, Sujith <Sujith.Manoharan@atheros.com>,
	Luciano Coelho <coelho@ti.com>,
	Christian Lamparter <chunkeey@googlemail.com>,
	"Luis R. Rodriguez" <mcgrof@gmail.com>
Date: Mon, 26 Mar 2012 18:47:18 +0200
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Johannes Berg <johannes.berg@intel.com>

Not all devices are really capable of implementing
remain-on-channel, even if it is implemented in SW,
as they can't necessarily deal with channel changes
while associated.

Remove the WIPHY_FLAG_HAS_REMAIN_ON_CHANNEL and add
it only if either the driver has remain_on_channel
implemented in the driver/device.

Also add it to all drivers that advertise P2P right
now since those definitely have to have it working.

Signed-off-by: Johannes Berg <johannes.berg@intel.com>
---
I think e.g. wl1251 would completely get fucked up by this .. let's not
go there. Also iwlegacy wouldn't like offchannel much, and doesn't need
it since it'll never have P2P anyway.

Since we don't need offchannel any more for "real" operation (auth/assoc
used to use it) we should clean this up too.

 drivers/net/wireless/ath/ath9k/htc_drv_init.c |    3 ++-
 drivers/net/wireless/ath/ath9k/init.c         |    1 +
 drivers/net/wireless/ath/carl9170/fw.c        |    2 ++
 drivers/net/wireless/mac80211_hwsim.c         |    3 ++-
 drivers/net/wireless/wl12xx/main.c            |    3 ++-
 net/mac80211/main.c                           |    6 ++++--
 6 files changed, 13 insertions(+), 5 deletions(-)

--- a/net/mac80211/main.c	2012-03-26 18:41:42.000000000 +0200
+++ b/net/mac80211/main.c	2012-03-26 18:41:43.000000000 +0200
@@ -560,8 +560,10 @@ struct ieee80211_hw *ieee80211_alloc_hw(
 			WIPHY_FLAG_4ADDR_AP |
 			WIPHY_FLAG_4ADDR_STATION |
 			WIPHY_FLAG_REPORTS_OBSS |
-			WIPHY_FLAG_OFFCHAN_TX |
-			WIPHY_FLAG_HAS_REMAIN_ON_CHANNEL;
+			WIPHY_FLAG_OFFCHAN_TX;
+
+	if (ops->remain_on_channel)
+		wiphy->flags |= WIPHY_FLAG_HAS_REMAIN_ON_CHANNEL;
 
 	wiphy->features = NL80211_FEATURE_SK_TX_STATUS |
 			  NL80211_FEATURE_HT_IBSS;
--- a/drivers/net/wireless/ath/ath9k/htc_drv_init.c	2012-03-26 18:41:42.000000000 +0200
+++ b/drivers/net/wireless/ath/ath9k/htc_drv_init.c	2012-03-26 18:41:43.000000000 +0200
@@ -711,7 +711,8 @@ static void ath9k_set_hw_capab(struct at
 
 	hw->wiphy->flags &= ~WIPHY_FLAG_PS_ON_BY_DEFAULT;
 
-	hw->wiphy->flags |= WIPHY_FLAG_IBSS_RSN;
+	hw->wiphy->flags |= WIPHY_FLAG_IBSS_RSN |
+			    WIPHY_FLAG_HAS_REMAIN_ON_CHANNEL;
 
 	hw->queues = 4;
 	hw->channel_change_time = 5000;
--- a/drivers/net/wireless/ath/ath9k/init.c	2012-03-26 18:41:42.000000000 +0200
+++ b/drivers/net/wireless/ath/ath9k/init.c	2012-03-26 18:41:43.000000000 +0200
@@ -676,6 +676,7 @@ void ath9k_set_hw_capab(struct ath_softc
 
 	hw->wiphy->flags |= WIPHY_FLAG_IBSS_RSN;
 	hw->wiphy->flags |= WIPHY_FLAG_SUPPORTS_TDLS;
+	hw->wiphy->flags |= WIPHY_FLAG_HAS_REMAIN_ON_CHANNEL;
 
 	hw->queues = 4;
 	hw->max_rates = 4;
--- a/drivers/net/wireless/ath/carl9170/fw.c	2012-03-26 18:41:42.000000000 +0200
+++ b/drivers/net/wireless/ath/carl9170/fw.c	2012-03-26 18:41:43.000000000 +0200
@@ -355,6 +355,8 @@ static int carl9170_fw(struct ar9170 *ar
 
 	ar->hw->wiphy->interface_modes |= if_comb_types;
 
+	ar->hw->wiphy->flags |= WIPHY_FLAG_HAS_REMAIN_ON_CHANNEL;
+
 #undef SUPPORTED
 	return carl9170_fw_tx_sequence(ar);
 }
--- a/drivers/net/wireless/wl12xx/main.c	2012-03-26 18:41:42.000000000 +0200
+++ b/drivers/net/wireless/wl12xx/main.c	2012-03-26 18:41:43.000000000 +0200
@@ -5242,7 +5242,8 @@ static int wl1271_init_ieee80211(struct
 	wl->hw->wiphy->max_sched_scan_ie_len = WL1271_CMD_TEMPL_MAX_SIZE -
 		sizeof(struct ieee80211_header);
 
-	wl->hw->wiphy->flags |= WIPHY_FLAG_AP_UAPSD;
+	wl->hw->wiphy->flags |= WIPHY_FLAG_AP_UAPSD |
+				WIPHY_FLAG_HAS_REMAIN_ON_CHANNEL;
 
 	/* make sure all our channels fit in the scanned_ch bitmask */
 	BUILD_BUG_ON(ARRAY_SIZE(wl1271_channels) +
--- a/drivers/net/wireless/mac80211_hwsim.c	2012-03-26 18:41:42.000000000 +0200
+++ b/drivers/net/wireless/mac80211_hwsim.c	2012-03-26 18:41:43.000000000 +0200
@@ -1791,7 +1791,8 @@ static int __init init_mac80211_hwsim(vo
 			    IEEE80211_HW_SUPPORTS_DYNAMIC_SMPS |
 			    IEEE80211_HW_AMPDU_AGGREGATION;
 
-		hw->wiphy->flags |= WIPHY_FLAG_SUPPORTS_TDLS;
+		hw->wiphy->flags |= WIPHY_FLAG_SUPPORTS_TDLS |
+				    WIPHY_FLAG_HAS_REMAIN_ON_CHANNEL;
 
 		/* ask mac80211 to reserve space for magic */
 		hw->vif_data_size = sizeof(struct hwsim_vif_priv);


