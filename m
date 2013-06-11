Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([144.76.43.152]:38612 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752127Ab3FKSV5 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 11 Jun 2013 14:21:57 -0400
From: Johannes Berg <johannes@sipsolutions.net>
To: linux-wireless@vger.kernel.org
Cc: Alexander Bondar <alexander.bondar@intel.com>
Subject: [PATCH] mac80211: track AP's beacon rate and give it to the driver
Date: Tue, 11 Jun 2013 20:21:51 +0200
Message-Id: <1370974911-6074-1-git-send-email-johannes@sipsolutions.net> (sfid-20130611_202200_176767_ACF2C20E)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Alexander Bondar <alexander.bondar@intel.com>

Track the AP's beacon rate in the scan BSS data and in the
interface configuration to let the drivers know which rate
the AP is using. This information may be used by drivers,
in our case to let the firmware optimise beacon RX.

Signed-off-by: Alexander Bondar <alexander.bondar@intel.com>
Signed-off-by: Johannes Berg <johannes.berg@intel.com>
---
 include/net/mac80211.h     | 2 ++
 net/mac80211/ieee80211_i.h | 1 +
 net/mac80211/mlme.c        | 8 +++++++-
 net/mac80211/scan.c        | 9 +++++++++
 4 files changed, 19 insertions(+), 1 deletion(-)

diff --git a/include/net/mac80211.h b/include/net/mac80211.h
index a405a7a..5b7a3da 100644
--- a/include/net/mac80211.h
+++ b/include/net/mac80211.h
@@ -305,6 +305,7 @@ enum ieee80211_rssi_event {
  * @basic_rates: bitmap of basic rates, each bit stands for an
  *	index into the rate table configured by the driver in
  *	the current band.
+ * @beacon_rate: associated AP's beacon TX rate
  * @mcast_rate: per-band multicast rate index + 1 (0: disabled)
  * @bssid: The BSSID for this BSS
  * @enable_beacon: whether beaconing should be enabled or not
@@ -352,6 +353,7 @@ struct ieee80211_bss_conf {
 	u32 sync_device_ts;
 	u8 sync_dtim_count;
 	u32 basic_rates;
+	struct ieee80211_rate *beacon_rate;
 	int mcast_rate[IEEE80211_NUM_BANDS];
 	u16 ht_operation_mode;
 	s32 cqm_rssi_thold;
diff --git a/net/mac80211/ieee80211_i.h b/net/mac80211/ieee80211_i.h
index 7a6f1a0..a4dfb0b 100644
--- a/net/mac80211/ieee80211_i.h
+++ b/net/mac80211/ieee80211_i.h
@@ -94,6 +94,7 @@ struct ieee80211_bss {
 #define IEEE80211_MAX_SUPP_RATES 32
 	u8 supp_rates[IEEE80211_MAX_SUPP_RATES];
 	size_t supp_rates_len;
+	struct ieee80211_rate *beacon_rate;
 
 	/*
 	 * During association, we save an ERP value from a probe response so
diff --git a/net/mac80211/mlme.c b/net/mac80211/mlme.c
index ad9bb9e..87f2d4d 100644
--- a/net/mac80211/mlme.c
+++ b/net/mac80211/mlme.c
@@ -1779,8 +1779,10 @@ static void ieee80211_set_associated(struct ieee80211_sub_if_data *sdata,
 		 * probably just won't work at all.
 		 */
 		bss_conf->dtim_period = sdata->u.mgd.dtim_period ?: 1;
+		bss_conf->beacon_rate = bss->beacon_rate;
 		bss_info_changed |= BSS_CHANGED_BEACON_INFO;
 	} else {
+		bss_conf->beacon_rate = NULL;
 		bss_conf->dtim_period = 0;
 	}
 
@@ -1903,6 +1905,8 @@ static void ieee80211_set_disassoc(struct ieee80211_sub_if_data *sdata,
 	del_timer_sync(&sdata->u.mgd.chswitch_timer);
 
 	sdata->vif.bss_conf.dtim_period = 0;
+	sdata->vif.bss_conf.beacon_rate = NULL;
+
 	ifmgd->have_beacon = false;
 
 	ifmgd->flags = 0;
@@ -2754,8 +2758,10 @@ static void ieee80211_rx_bss_info(struct ieee80211_sub_if_data *sdata,
 
 	bss = ieee80211_bss_info_update(local, rx_status, mgmt, len, elems,
 					channel);
-	if (bss)
+	if (bss) {
 		ieee80211_rx_bss_put(local, bss);
+		sdata->vif.bss_conf.beacon_rate = bss->beacon_rate;
+	}
 
 	if (!sdata->u.mgd.associated ||
 	    !ether_addr_equal(mgmt->bssid, sdata->u.mgd.associated->bssid))
diff --git a/net/mac80211/scan.c b/net/mac80211/scan.c
index 99b10392..1b122a7 100644
--- a/net/mac80211/scan.c
+++ b/net/mac80211/scan.c
@@ -140,6 +140,15 @@ ieee80211_bss_info_update(struct ieee80211_local *local,
 			bss->valid_data |= IEEE80211_BSS_VALID_WMM;
 	}
 
+	if (beacon) {
+		struct ieee80211_supported_band *sband =
+			local->hw.wiphy->bands[rx_status->band];
+		if (!(rx_status->flag & RX_FLAG_HT) &&
+		    !(rx_status->flag & RX_FLAG_VHT))
+			bss->beacon_rate =
+				&sband->bitrates[rx_status->rate_idx];
+	}
+
 	return bss;
 }
 
-- 
1.8.0

