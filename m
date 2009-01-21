Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from xc.sipsolutions.net ([83.246.72.84]:38412 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753285AbZAUONs (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 21 Jan 2009 09:13:48 -0500
Subject: [PATCH] wireless: restrict to 32 legacy rates
From: Johannes Berg <johannes@sipsolutions.net>
To: John Linville <linville@tuxdriver.com>
Cc: linux-wireless <linux-wireless@vger.kernel.org>
Content-Type: text/plain
Date: Wed, 21 Jan 2009 15:13:48 +0100
Message-Id: <1232547228.6059.3.camel@johannes.local> (sfid-20090121_151354_106876_CBC37475)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Since the standards only define 12 legacy rates, 32 is certainly
a sane upper limit and we don't need to use u64 everywhere. Add
sanity checking that no more than 32 rates are registered and
change the variables to u32 throughout.

Signed-off-by: Johannes Berg <johannes@sipsolutions.net>
---
 drivers/net/wireless/b43/main.c       |    2 +-
 drivers/net/wireless/b43legacy/main.c |    2 +-
 drivers/net/wireless/p54/p54.h        |    2 +-
 drivers/net/wireless/rt2x00/rt2x00.h  |    2 +-
 include/net/mac80211.h                |    4 ++--
 include/net/wireless.h                |    2 +-
 net/mac80211/ieee80211_i.h            |    6 +++---
 net/mac80211/mesh.c                   |    2 +-
 net/mac80211/mesh.h                   |    2 +-
 net/mac80211/mesh_plink.c             |    6 +++---
 net/mac80211/mlme.c                   |   16 ++++++++--------
 net/mac80211/util.c                   |    4 ++--
 net/wireless/core.c                   |   12 +++++++++---
 net/wireless/util.c                   |    2 +-
 14 files changed, 35 insertions(+), 29 deletions(-)

--- wireless-testing.orig/include/net/mac80211.h	2009-01-21 15:13:03.000000000 +0100
+++ wireless-testing/include/net/mac80211.h	2009-01-21 15:13:04.000000000 +0100
@@ -207,7 +207,7 @@ struct ieee80211_bss_conf {
 	u16 beacon_int;
 	u16 assoc_capability;
 	u64 timestamp;
-	u64 basic_rates;
+	u32 basic_rates;
 	struct ieee80211_bss_ht_conf ht;
 };
 
@@ -761,7 +761,7 @@ enum set_key_cmd {
  *	sizeof(void *), size is determined in hw information.
  */
 struct ieee80211_sta {
-	u64 supp_rates[IEEE80211_NUM_BANDS];
+	u32 supp_rates[IEEE80211_NUM_BANDS];
 	u8 addr[ETH_ALEN];
 	u16 aid;
 	struct ieee80211_sta_ht_cap ht_cap;
--- wireless-testing.orig/net/mac80211/ieee80211_i.h	2009-01-21 15:13:02.000000000 +0100
+++ wireless-testing/net/mac80211/ieee80211_i.h	2009-01-21 15:13:04.000000000 +0100
@@ -909,11 +909,11 @@ int ieee80211_sta_set_bssid(struct ieee8
 void ieee80211_sta_req_auth(struct ieee80211_sub_if_data *sdata,
 			    struct ieee80211_if_sta *ifsta);
 struct sta_info *ieee80211_ibss_add_sta(struct ieee80211_sub_if_data *sdata,
-					u8 *bssid, u8 *addr, u64 supp_rates);
+					u8 *bssid, u8 *addr, u32 supp_rates);
 int ieee80211_sta_deauthenticate(struct ieee80211_sub_if_data *sdata, u16 reason);
 int ieee80211_sta_disassociate(struct ieee80211_sub_if_data *sdata, u16 reason);
 u32 ieee80211_reset_erp_info(struct ieee80211_sub_if_data *sdata);
-u64 ieee80211_sta_get_rates(struct ieee80211_local *local,
+u32 ieee80211_sta_get_rates(struct ieee80211_local *local,
 			    struct ieee802_11_elems *elems,
 			    enum ieee80211_band band);
 void ieee80211_send_probe_req(struct ieee80211_sub_if_data *sdata, u8 *dst,
@@ -1022,7 +1022,7 @@ void ieee80211_tx_skb(struct ieee80211_s
 void ieee802_11_parse_elems(u8 *start, size_t len,
 			    struct ieee802_11_elems *elems);
 int ieee80211_set_freq(struct ieee80211_sub_if_data *sdata, int freq);
-u64 ieee80211_mandatory_rates(struct ieee80211_local *local,
+u32 ieee80211_mandatory_rates(struct ieee80211_local *local,
 			      enum ieee80211_band band);
 
 void ieee80211_dynamic_ps_enable_work(struct work_struct *work);
--- wireless-testing.orig/net/mac80211/mlme.c	2009-01-21 15:13:01.000000000 +0100
+++ wireless-testing/net/mac80211/mlme.c	2009-01-21 15:13:04.000000000 +0100
@@ -73,7 +73,7 @@ static u8 *ieee80211_bss_get_ie(struct i
 
 static int ieee80211_compatible_rates(struct ieee80211_bss *bss,
 				      struct ieee80211_supported_band *sband,
-				      u64 *rates)
+				      u32 *rates)
 {
 	int i, j, count;
 	*rates = 0;
@@ -93,14 +93,14 @@ static int ieee80211_compatible_rates(st
 }
 
 /* also used by mesh code */
-u64 ieee80211_sta_get_rates(struct ieee80211_local *local,
+u32 ieee80211_sta_get_rates(struct ieee80211_local *local,
 			    struct ieee802_11_elems *elems,
 			    enum ieee80211_band band)
 {
 	struct ieee80211_supported_band *sband;
 	struct ieee80211_rate *bitrates;
 	size_t num_rates;
-	u64 supp_rates;
+	u32 supp_rates;
 	int i, j;
 	sband = local->hw.wiphy->bands[band];
 
@@ -253,7 +253,7 @@ static void ieee80211_send_assoc(struct 
 	struct ieee80211_bss *bss;
 	int wmm = 0;
 	struct ieee80211_supported_band *sband;
-	u64 rates = 0;
+	u32 rates = 0;
 	size_t e_ies_len;
 
 	if (ifsta->flags & IEEE80211_STA_PREV_BSSID_SET) {
@@ -1282,7 +1282,7 @@ static void ieee80211_rx_mgmt_assoc_resp
 	struct ieee80211_local *local = sdata->local;
 	struct ieee80211_supported_band *sband;
 	struct sta_info *sta;
-	u64 rates, basic_rates;
+	u32 rates, basic_rates;
 	u16 capab_info, status_code, aid;
 	struct ieee802_11_elems elems;
 	struct ieee80211_bss_conf *bss_conf = &sdata->vif.bss_conf;
@@ -1638,7 +1638,7 @@ static void ieee80211_rx_bss_info(struct
 	struct sta_info *sta;
 	struct ieee80211_channel *channel;
 	u64 beacon_timestamp, rx_timestamp;
-	u64 supp_rates = 0;
+	u32 supp_rates = 0;
 	enum ieee80211_band band = rx_status->band;
 
 	if (elems->ds_params && elems->ds_params_len == 1)
@@ -1659,7 +1659,7 @@ static void ieee80211_rx_bss_info(struct
 
 		sta = sta_info_get(local, mgmt->sa);
 		if (sta) {
-			u64 prev_rates;
+			u32 prev_rates;
 
 			prev_rates = sta->sta.supp_rates[band];
 			/* make sure mandatory rates are always added */
@@ -2525,7 +2525,7 @@ void ieee80211_sta_setup_sdata(struct ie
  * must be callable in atomic context.
  */
 struct sta_info *ieee80211_ibss_add_sta(struct ieee80211_sub_if_data *sdata,
-					u8 *bssid,u8 *addr, u64 supp_rates)
+					u8 *bssid,u8 *addr, u32 supp_rates)
 {
 	struct ieee80211_local *local = sdata->local;
 	struct sta_info *sta;
--- wireless-testing.orig/include/net/wireless.h	2009-01-21 15:13:01.000000000 +0100
+++ wireless-testing/include/net/wireless.h	2009-01-21 15:13:04.000000000 +0100
@@ -367,7 +367,7 @@ ieee80211_get_channel(struct wiphy *wiph
  */
 struct ieee80211_rate *
 ieee80211_get_response_rate(struct ieee80211_supported_band *sband,
-			    u64 basic_rates, int bitrate);
+			    u32 basic_rates, int bitrate);
 
 /**
  * regulatory_hint - driver hint to the wireless core a regulatory domain
--- wireless-testing.orig/net/mac80211/util.c	2009-01-21 15:13:02.000000000 +0100
+++ wireless-testing/net/mac80211/util.c	2009-01-21 15:13:04.000000000 +0100
@@ -731,12 +731,12 @@ int ieee80211_set_freq(struct ieee80211_
 	return ret;
 }
 
-u64 ieee80211_mandatory_rates(struct ieee80211_local *local,
+u32 ieee80211_mandatory_rates(struct ieee80211_local *local,
 			      enum ieee80211_band band)
 {
 	struct ieee80211_supported_band *sband;
 	struct ieee80211_rate *bitrates;
-	u64 mandatory_rates;
+	u32 mandatory_rates;
 	enum ieee80211_rate_flags mandatory_flag;
 	int i;
 
--- wireless-testing.orig/net/wireless/util.c	2009-01-21 15:13:01.000000000 +0100
+++ wireless-testing/net/wireless/util.c	2009-01-21 15:13:04.000000000 +0100
@@ -9,7 +9,7 @@
 
 struct ieee80211_rate *
 ieee80211_get_response_rate(struct ieee80211_supported_band *sband,
-			    u64 basic_rates, int bitrate)
+			    u32 basic_rates, int bitrate)
 {
 	struct ieee80211_rate *result = &sband->bitrates[0];
 	int i;
--- wireless-testing.orig/net/mac80211/mesh.c	2009-01-21 15:13:01.000000000 +0100
+++ wireless-testing/net/mac80211/mesh.c	2009-01-21 15:13:04.000000000 +0100
@@ -476,7 +476,7 @@ static void ieee80211_mesh_rx_bcn_presp(
 	struct ieee80211_local *local = sdata->local;
 	struct ieee802_11_elems elems;
 	struct ieee80211_channel *channel;
-	u64 supp_rates = 0;
+	u32 supp_rates = 0;
 	size_t baselen;
 	int freq;
 	enum ieee80211_band band = rx_status->band;
--- wireless-testing.orig/net/mac80211/mesh.h	2009-01-21 15:13:01.000000000 +0100
+++ wireless-testing/net/mac80211/mesh.h	2009-01-21 15:13:04.000000000 +0100
@@ -236,7 +236,7 @@ void mesh_rx_path_sel_frame(struct ieee8
 		struct ieee80211_mgmt *mgmt, size_t len);
 int mesh_path_add(u8 *dst, struct ieee80211_sub_if_data *sdata);
 /* Mesh plinks */
-void mesh_neighbour_update(u8 *hw_addr, u64 rates,
+void mesh_neighbour_update(u8 *hw_addr, u32 rates,
 		struct ieee80211_sub_if_data *sdata, bool add);
 bool mesh_peer_accepts_plinks(struct ieee802_11_elems *ie);
 void mesh_accept_plinks_update(struct ieee80211_sub_if_data *sdata);
--- wireless-testing.orig/net/mac80211/mesh_plink.c	2009-01-21 15:13:01.000000000 +0100
+++ wireless-testing/net/mac80211/mesh_plink.c	2009-01-21 15:13:04.000000000 +0100
@@ -93,7 +93,7 @@ static inline void mesh_plink_fsm_restar
  *       on it in the lifecycle management section!
  */
 static struct sta_info *mesh_plink_alloc(struct ieee80211_sub_if_data *sdata,
-					 u8 *hw_addr, u64 rates)
+					 u8 *hw_addr, u32 rates)
 {
 	struct ieee80211_local *local = sdata->local;
 	struct sta_info *sta;
@@ -222,7 +222,7 @@ static int mesh_plink_frame_tx(struct ie
 	return 0;
 }
 
-void mesh_neighbour_update(u8 *hw_addr, u64 rates, struct ieee80211_sub_if_data *sdata,
+void mesh_neighbour_update(u8 *hw_addr, u32 rates, struct ieee80211_sub_if_data *sdata,
 			   bool peer_accepting_plinks)
 {
 	struct ieee80211_local *local = sdata->local;
@@ -477,7 +477,7 @@ void mesh_rx_plink_frame(struct ieee8021
 		spin_lock_bh(&sta->lock);
 	} else if (!sta) {
 		/* ftype == PLINK_OPEN */
-		u64 rates;
+		u32 rates;
 		if (!mesh_plink_free_count(sdata)) {
 			mpl_dbg("Mesh plink error: no more free plinks\n");
 			rcu_read_unlock();
--- wireless-testing.orig/net/wireless/core.c	2009-01-21 15:13:01.000000000 +0100
+++ wireless-testing/net/wireless/core.c	2009-01-21 15:13:04.000000000 +0100
@@ -273,10 +273,16 @@ int wiphy_register(struct wiphy *wiphy)
 
 		sband->band = band;
 
-		if (!sband->n_channels || !sband->n_bitrates) {
-			WARN_ON(1);
+		if (WARN_ON(!sband->n_channels || !sband->n_bitrates))
+			return -EINVAL;
+
+		/*
+		 * Since we use a u32 for rate bitmaps in
+		 * ieee80211_get_response_rate, we cannot
+		 * have more than 32 legacy rates.
+		 */
+		if (WARN_ON(sband->n_bitrates > 32))
 			return -EINVAL;
-		}
 
 		for (i = 0; i < sband->n_channels; i++) {
 			sband->channels[i].orig_flags =
--- wireless-testing.orig/drivers/net/wireless/b43/main.c	2009-01-21 15:13:01.000000000 +0100
+++ wireless-testing/drivers/net/wireless/b43/main.c	2009-01-21 15:13:04.000000000 +0100
@@ -3398,7 +3398,7 @@ out_unlock_mutex:
 	return err;
 }
 
-static void b43_update_basic_rates(struct b43_wldev *dev, u64 brates)
+static void b43_update_basic_rates(struct b43_wldev *dev, u32 brates)
 {
 	struct ieee80211_supported_band *sband =
 		dev->wl->hw->wiphy->bands[b43_current_band(dev->wl)];
--- wireless-testing.orig/drivers/net/wireless/b43legacy/main.c	2009-01-21 15:13:01.000000000 +0100
+++ wireless-testing/drivers/net/wireless/b43legacy/main.c	2009-01-21 15:13:04.000000000 +0100
@@ -2650,7 +2650,7 @@ out_unlock_mutex:
 	return err;
 }
 
-static void b43legacy_update_basic_rates(struct b43legacy_wldev *dev, u64 brates)
+static void b43legacy_update_basic_rates(struct b43legacy_wldev *dev, u32 brates)
 {
 	struct ieee80211_supported_band *sband =
 		dev->wl->hw->wiphy->bands[IEEE80211_BAND_2GHZ];
--- wireless-testing.orig/drivers/net/wireless/p54/p54.h	2009-01-21 15:13:01.000000000 +0100
+++ wireless-testing/drivers/net/wireless/p54/p54.h	2009-01-21 15:13:04.000000000 +0100
@@ -144,7 +144,7 @@ struct p54_common {
 	unsigned int output_power;
 	u32 tsf_low32;
 	u32 tsf_high32;
-	u64 basic_rate_mask;
+	u32 basic_rate_mask;
 	u16 wakeup_timer;
 	u16 aid;
 	struct ieee80211_tx_queue_stats tx_stats[8];
--- wireless-testing.orig/drivers/net/wireless/rt2x00/rt2x00.h	2009-01-21 15:13:01.000000000 +0100
+++ wireless-testing/drivers/net/wireless/rt2x00/rt2x00.h	2009-01-21 15:13:04.000000000 +0100
@@ -396,7 +396,7 @@ struct rt2x00lib_erp {
 	int ack_timeout;
 	int ack_consume_time;
 
-	u64 basic_rates;
+	u32 basic_rates;
 
 	int slot_time;
 


