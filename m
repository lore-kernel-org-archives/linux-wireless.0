Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from xc.sipsolutions.net ([83.246.72.84]:44237 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752168AbYIKApt (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 10 Sep 2008 20:45:49 -0400
Subject: [PATCH 21/18] mac80211: share sta->supp_rates
From: Johannes Berg <johannes@sipsolutions.net>
To: John Linville <linville@tuxdriver.com>
Cc: linux-wireless@vger.kernel.org
In-Reply-To: <20080910220145.707263000@sipsolutions.net> (sfid-20080911_001619_033062_98BAB5F3)
References: <20080910220145.707263000@sipsolutions.net>
	 (sfid-20080911_001619_033062_98BAB5F3)
Content-Type: text/plain
Date: Thu, 11 Sep 2008 02:45:11 +0200
Message-Id: <1221093911.3804.69.camel@johannes.berg> (sfid-20080911_024553_233842_6D2143AF)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

As more preparation for a saner rate control algorithm API,
share the supported rates bitmap in the public API.

Signed-off-by: Johannes Berg <johannes@sipsolutions.net>
---
 drivers/net/wireless/ath9k/rc.c            |    2 +-
 drivers/net/wireless/iwlwifi/iwl-3945-rs.c |    4 ++--
 drivers/net/wireless/iwlwifi/iwl-agn-rs.c  |    6 +++---
 include/net/mac80211.h                     |    2 ++
 net/mac80211/cfg.c                         |    2 +-
 net/mac80211/mesh_plink.c                  |    4 ++--
 net/mac80211/mlme.c                        |    8 ++++----
 net/mac80211/rate.h                        |    2 +-
 net/mac80211/sta_info.h                    |    2 --
 9 files changed, 16 insertions(+), 16 deletions(-)

--- everything.orig/include/net/mac80211.h	2008-09-11 02:28:09.000000000 +0200
+++ everything/include/net/mac80211.h	2008-09-11 02:28:23.000000000 +0200
@@ -666,10 +666,12 @@ enum set_key_cmd {
  *
  * @addr: MAC address
  * @aid: AID we assigned to the station if we're an AP
+ * @supp_rates: Bitmap of supported rates (per band)
  * @drv_priv: data area for driver use, will always be aligned to
  *	sizeof(void *), size is determined in hw information.
  */
 struct ieee80211_sta {
+	u64 supp_rates[IEEE80211_NUM_BANDS];
 	u8 addr[ETH_ALEN];
 	u16 aid;
 
--- everything.orig/net/mac80211/cfg.c	2008-09-11 02:30:18.000000000 +0200
+++ everything/net/mac80211/cfg.c	2008-09-11 02:30:24.000000000 +0200
@@ -662,7 +662,7 @@ static void sta_apply_parameters(struct 
 					rates |= BIT(j);
 			}
 		}
-		sta->supp_rates[local->oper_channel->band] = rates;
+		sta->sta.supp_rates[local->oper_channel->band] = rates;
 	}
 
 	if (params->ht_capa) {
--- everything.orig/net/mac80211/mlme.c	2008-09-11 02:29:22.000000000 +0200
+++ everything/net/mac80211/mlme.c	2008-09-11 02:29:58.000000000 +0200
@@ -1332,7 +1332,7 @@ static void ieee80211_rx_mgmt_assoc_resp
 		}
 	}
 
-	sta->supp_rates[local->hw.conf.channel->band] = rates;
+	sta->sta.supp_rates[local->hw.conf.channel->band] = rates;
 	sdata->bss_conf.basic_rates = basic_rates;
 
 	/* cf. IEEE 802.11 9.2.12 */
@@ -1528,9 +1528,9 @@ static void ieee80211_rx_bss_info(struct
 		if (sta) {
 			u64 prev_rates;
 
-			prev_rates = sta->supp_rates[band];
+			prev_rates = sta->sta.supp_rates[band];
 			/* make sure mandatory rates are always added */
-			sta->supp_rates[band] = supp_rates |
+			sta->sta.supp_rates[band] = supp_rates |
 				ieee80211_mandatory_rates(local, band);
 
 #ifdef CONFIG_MAC80211_IBSS_DEBUG
@@ -2369,7 +2369,7 @@ struct sta_info *ieee80211_ibss_add_sta(
 	set_sta_flags(sta, WLAN_STA_AUTHORIZED);
 
 	/* make sure mandatory rates are always added */
-	sta->supp_rates[band] = supp_rates |
+	sta->sta.supp_rates[band] = supp_rates |
 			ieee80211_mandatory_rates(local, band);
 
 	rate_control_rate_init(sta, local);
--- everything.orig/net/mac80211/rate.h	2008-09-11 02:28:54.000000000 +0200
+++ everything/net/mac80211/rate.h	2008-09-11 02:28:59.000000000 +0200
@@ -134,7 +134,7 @@ static inline int rate_supported(struct 
 				 enum ieee80211_band band,
 				 int index)
 {
-	return (sta == NULL || sta->supp_rates[band] & BIT(index));
+	return (sta == NULL || sta->sta.supp_rates[band] & BIT(index));
 }
 
 static inline s8
--- everything.orig/net/mac80211/sta_info.h	2008-09-11 02:27:55.000000000 +0200
+++ everything/net/mac80211/sta_info.h	2008-09-11 02:28:05.000000000 +0200
@@ -168,7 +168,6 @@ struct sta_ampdu_mlme {
  *	in the header file.
  * @flaglock: spinlock for flags accesses
  * @ht_info: HT capabilities of this STA
- * @supp_rates: Bitmap of supported rates (per band)
  * @addr: MAC address of this STA
  * @aid: STA's unique AID (1..2007, 0 = not assigned yet),
  *	only used in AP (and IBSS?) mode
@@ -228,7 +227,6 @@ struct sta_info {
 	spinlock_t lock;
 	spinlock_t flaglock;
 	struct ieee80211_ht_info ht_info;
-	u64 supp_rates[IEEE80211_NUM_BANDS];
 
 	u16 listen_interval;
 
--- everything.orig/net/mac80211/mesh_plink.c	2008-09-11 02:31:19.000000000 +0200
+++ everything/net/mac80211/mesh_plink.c	2008-09-11 02:31:30.000000000 +0200
@@ -106,7 +106,7 @@ static struct sta_info *mesh_plink_alloc
 		return NULL;
 
 	sta->flags = WLAN_STA_AUTHORIZED;
-	sta->supp_rates[local->hw.conf.channel->band] = rates;
+	sta->sta.supp_rates[local->hw.conf.channel->band] = rates;
 
 	return sta;
 }
@@ -243,7 +243,7 @@ void mesh_neighbour_update(u8 *hw_addr, 
 	}
 
 	sta->last_rx = jiffies;
-	sta->supp_rates[local->hw.conf.channel->band] = rates;
+	sta->sta.supp_rates[local->hw.conf.channel->band] = rates;
 	if (peer_accepting_plinks && sta->plink_state == PLINK_LISTEN &&
 			sdata->u.mesh.accepting_plinks &&
 			sdata->u.mesh.mshcfg.auto_open_plinks)
--- everything.orig/drivers/net/wireless/ath9k/rc.c	2008-09-11 02:33:17.000000000 +0200
+++ everything/drivers/net/wireless/ath9k/rc.c	2008-09-11 02:33:22.000000000 +0200
@@ -1825,7 +1825,7 @@ static void ath_setup_rates(struct ieee8
 
 	sband =  local->hw.wiphy->bands[local->hw.conf.channel->band];
 	for (i = 0; i < sband->n_bitrates; i++) {
-		if (sta->supp_rates[local->hw.conf.channel->band] & BIT(i)) {
+		if (sta->sta.supp_rates[local->hw.conf.channel->band] & BIT(i)) {
 			rc_priv->neg_rates.rs_rates[j]
 				= (sband->bitrates[i].bitrate * 2) / 10;
 			j++;
--- everything.orig/drivers/net/wireless/iwlwifi/iwl-3945-rs.c	2008-09-11 02:32:31.000000000 +0200
+++ everything/drivers/net/wireless/iwlwifi/iwl-3945-rs.c	2008-09-11 02:32:44.000000000 +0200
@@ -333,7 +333,7 @@ static void rs_rate_init(void *priv_rate
 	 * after assoc.. */
 
 	for (i = IWL_RATE_COUNT - 1; i >= 0; i--) {
-		if (sta->supp_rates[local->hw.conf.channel->band] & (1 << i)) {
+		if (sta->sta.supp_rates[local->hw.conf.channel->band] & (1 << i)) {
 			sta->txrate_idx = i;
 			break;
 		}
@@ -680,7 +680,7 @@ static void rs_get_rate(void *priv_rate,
 
 	rs_sta = (void *)sta->rate_ctrl_priv;
 
-	rate_mask = sta->supp_rates[sband->band];
+	rate_mask = sta->sta.supp_rates[sband->band];
 	index = min(rs_sta->last_txrate_idx & 0xffff, IWL_RATE_COUNT - 1);
 
 	if (sband->band == IEEE80211_BAND_5GHZ)
--- everything.orig/drivers/net/wireless/iwlwifi/iwl-agn-rs.c	2008-09-11 02:32:31.000000000 +0200
+++ everything/drivers/net/wireless/iwlwifi/iwl-agn-rs.c	2008-09-11 02:33:05.000000000 +0200
@@ -1731,7 +1731,7 @@ static void rs_rate_scale_perform(struct
 		return;
 
 	lq_sta = (struct iwl_lq_sta *)sta->rate_ctrl_priv;
-	lq_sta->supp_rates = sta->supp_rates[lq_sta->band];
+	lq_sta->supp_rates = sta->sta.supp_rates[lq_sta->band];
 
 	tid = rs_tl_add_packet(lq_sta, hdr);
 
@@ -2233,7 +2233,7 @@ static void rs_rate_init(void *priv_rate
 	sband = local->hw.wiphy->bands[local->hw.conf.channel->band];
 
 	lq_sta->flush_timer = 0;
-	lq_sta->supp_rates = sta->supp_rates[sband->band];
+	lq_sta->supp_rates = sta->sta.supp_rates[sband->band];
 	sta->txrate_idx = 3;
 	for (j = 0; j < LQ_SIZE; j++)
 		for (i = 0; i < IWL_RATE_COUNT; i++)
@@ -2270,7 +2270,7 @@ static void rs_rate_init(void *priv_rate
 
 	/* Find highest tx rate supported by hardware and destination station */
 	for (i = 0; i < sband->n_bitrates; i++)
-		if (sta->supp_rates[sband->band] & BIT(i))
+		if (sta->sta.supp_rates[sband->band] & BIT(i))
 			sta->txrate_idx = i;
 
 	lq_sta->last_txrate_idx = sta->txrate_idx;


