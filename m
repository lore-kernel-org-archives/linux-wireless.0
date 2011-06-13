Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from emh06.mail.saunalahti.fi ([62.142.5.116]:36326 "EHLO
	emh06.mail.saunalahti.fi" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755212Ab1FMWf6 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 13 Jun 2011 18:35:58 -0400
Received: from saunalahti-vams (vs3-11.mail.saunalahti.fi [62.142.5.95])
	by emh06-2.mail.saunalahti.fi (Postfix) with SMTP id 11B98C7C7D
	for <linux-wireless@vger.kernel.org>; Tue, 14 Jun 2011 01:35:57 +0300 (EEST)
Received: from localhost6.localdomain6 (a88-115-184-248.elisa-laajakaista.fi [88.115.184.248])
	by emh05.mail.saunalahti.fi (Postfix) with ESMTP id D7EE827D83
	for <linux-wireless@vger.kernel.org>; Tue, 14 Jun 2011 01:35:55 +0300 (EEST)
Subject: [PATCH v2 09/27] mac80211: rename ieee80211_bss to mac80211_bss
To: linux-wireless@vger.kernel.org
From: Kalle Valo <kvalo@adurom.com>
Date: Tue, 14 Jun 2011 01:35:45 +0300
Message-ID: <20110613223545.10517.91774.stgit@localhost6.localdomain6> (sfid-20110614_003600_460193_658DD247)
In-Reply-To: <20110613223029.10517.52197.stgit@localhost6.localdomain6>
References: <20110613223029.10517.52197.stgit@localhost6.localdomain6>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Signed-off-by: Kalle Valo <kvalo@adurom.com>
---
 net/mac80211/ibss.c       |    6 +++---
 net/mac80211/mac80211_i.h |   16 ++++++++--------
 net/mac80211/main.c       |    2 +-
 net/mac80211/mlme.c       |   10 +++++-----
 net/mac80211/scan.c       |   12 ++++++------
 5 files changed, 23 insertions(+), 23 deletions(-)

diff --git a/net/mac80211/ibss.c b/net/mac80211/ibss.c
index d97273b..6d6729b 100644
--- a/net/mac80211/ibss.c
+++ b/net/mac80211/ibss.c
@@ -211,7 +211,7 @@ static void __ieee80211_sta_join_ibss(struct ieee80211_sub_if_data *sdata,
 }
 
 static void ieee80211_sta_join_ibss(struct ieee80211_sub_if_data *sdata,
-				    struct ieee80211_bss *bss)
+				    struct mac80211_bss *bss)
 {
 	struct cfg80211_bss *cbss =
 		container_of((void *)bss, struct cfg80211_bss, priv);
@@ -260,7 +260,7 @@ static void ieee80211_rx_bss_info(struct ieee80211_sub_if_data *sdata,
 	struct mac80211_local *local = sdata->local;
 	int freq;
 	struct cfg80211_bss *cbss;
-	struct ieee80211_bss *bss;
+	struct mac80211_bss *bss;
 	struct sta_info *sta;
 	struct ieee80211_channel *channel;
 	u64 beacon_timestamp, rx_timestamp;
@@ -600,7 +600,7 @@ static void ieee80211_sta_find_ibss(struct ieee80211_sub_if_data *sdata)
 				capability);
 
 	if (cbss) {
-		struct ieee80211_bss *bss;
+		struct mac80211_bss *bss;
 
 		bss = (void *)cbss->priv;
 #ifdef CONFIG_MAC80211_IBSS_DEBUG
diff --git a/net/mac80211/mac80211_i.h b/net/mac80211/mac80211_i.h
index fa766b2..238228e 100644
--- a/net/mac80211/mac80211_i.h
+++ b/net/mac80211/mac80211_i.h
@@ -74,7 +74,7 @@ struct mac80211_fragment_entry {
 };
 
 
-struct ieee80211_bss {
+struct mac80211_bss {
 	/* don't want to look up all the time */
 	size_t ssid_len;
 	u8 ssid[IEEE80211_MAX_SSID_LEN];
@@ -106,7 +106,7 @@ struct ieee80211_bss {
 	u8 erp_value;
 };
 
-static inline u8 *bss_mesh_cfg(struct ieee80211_bss *bss)
+static inline u8 *bss_mesh_cfg(struct mac80211_bss *bss)
 {
 #ifdef CONFIG_MAC80211_MESH
 	return bss->mesh_cfg;
@@ -114,7 +114,7 @@ static inline u8 *bss_mesh_cfg(struct ieee80211_bss *bss)
 	return NULL;
 }
 
-static inline u8 *bss_mesh_id(struct ieee80211_bss *bss)
+static inline u8 *bss_mesh_id(struct mac80211_bss *bss)
 {
 #ifdef CONFIG_MAC80211_MESH
 	return bss->mesh_id;
@@ -122,7 +122,7 @@ static inline u8 *bss_mesh_id(struct ieee80211_bss *bss)
 	return NULL;
 }
 
-static inline u8 bss_mesh_id_len(struct ieee80211_bss *bss)
+static inline u8 bss_mesh_id_len(struct mac80211_bss *bss)
 {
 #ifdef CONFIG_MAC80211_MESH
 	return bss->mesh_id_len;
@@ -1101,7 +1101,7 @@ int ieee80211_max_network_latency(struct notifier_block *nb,
 int ieee80211_set_arp_filter(struct ieee80211_sub_if_data *sdata);
 void ieee80211_sta_process_chanswitch(struct ieee80211_sub_if_data *sdata,
 				      struct ieee80211_channel_sw_ie *sw_elem,
-				      struct ieee80211_bss *bss,
+				      struct mac80211_bss *bss,
 				      u64 timestamp);
 void ieee80211_sta_quiesce(struct ieee80211_sub_if_data *sdata);
 void ieee80211_sta_restart(struct ieee80211_sub_if_data *sdata);
@@ -1143,7 +1143,7 @@ ieee80211_rx_result
 ieee80211_scan_rx(struct ieee80211_sub_if_data *sdata, struct sk_buff *skb);
 
 void ieee80211_mlme_notify_scan_completed(struct mac80211_local *local);
-struct ieee80211_bss *
+struct mac80211_bss *
 ieee80211_bss_info_update(struct mac80211_local *local,
 			  struct ieee80211_rx_status *rx_status,
 			  struct ieee80211_mgmt *mgmt,
@@ -1151,11 +1151,11 @@ ieee80211_bss_info_update(struct mac80211_local *local,
 			  struct ieee802_11_elems *elems,
 			  struct ieee80211_channel *channel,
 			  bool beacon);
-struct ieee80211_bss *
+struct mac80211_bss *
 ieee80211_rx_bss_get(struct mac80211_local *local, u8 *bssid, int freq,
 		     u8 *ssid, u8 ssid_len);
 void ieee80211_rx_bss_put(struct mac80211_local *local,
-			  struct ieee80211_bss *bss);
+			  struct mac80211_bss *bss);
 
 /* scheduled scan handling */
 int ieee80211_request_sched_scan_start(struct ieee80211_sub_if_data *sdata,
diff --git a/net/mac80211/main.c b/net/mac80211/main.c
index 87416c3..244f588 100644
--- a/net/mac80211/main.c
+++ b/net/mac80211/main.c
@@ -586,7 +586,7 @@ struct ieee80211_hw *ieee80211_alloc_hw(size_t priv_data_len,
 	if (!ops->set_key)
 		wiphy->flags |= WIPHY_FLAG_IBSS_RSN;
 
-	wiphy->bss_priv_size = sizeof(struct ieee80211_bss);
+	wiphy->bss_priv_size = sizeof(struct mac80211_bss);
 
 	local = wiphy_priv(wiphy);
 
diff --git a/net/mac80211/mlme.c b/net/mac80211/mlme.c
index 6eb164a..dcf33eb 100644
--- a/net/mac80211/mlme.c
+++ b/net/mac80211/mlme.c
@@ -445,7 +445,7 @@ static void ieee80211_chswitch_timer(unsigned long data)
 
 void ieee80211_sta_process_chanswitch(struct ieee80211_sub_if_data *sdata,
 				      struct ieee80211_channel_sw_ie *sw_elem,
-				      struct ieee80211_bss *bss,
+				      struct mac80211_bss *bss,
 				      u64 timestamp)
 {
 	struct cfg80211_bss *cbss =
@@ -702,7 +702,7 @@ void ieee80211_recalc_ps(struct mac80211_local *local, s32 latency)
 		if (beaconint_us > latency) {
 			local->ps_sdata = NULL;
 		} else {
-			struct ieee80211_bss *bss;
+			struct mac80211_bss *bss;
 			int maxslp = 1;
 			u8 dtimper;
 
@@ -957,7 +957,7 @@ static void ieee80211_set_associated(struct ieee80211_sub_if_data *sdata,
 				     struct cfg80211_bss *cbss,
 				     u32 bss_info_changed)
 {
-	struct ieee80211_bss *bss = (void *)cbss->priv;
+	struct mac80211_bss *bss = (void *)cbss->priv;
 	struct mac80211_local *local = sdata->local;
 	struct ieee80211_bss_conf *bss_conf = &sdata->vif.bss_conf;
 
@@ -1602,7 +1602,7 @@ static void ieee80211_rx_bss_info(struct ieee80211_sub_if_data *sdata,
 {
 	struct mac80211_local *local = sdata->local;
 	int freq;
-	struct ieee80211_bss *bss;
+	struct mac80211_bss *bss;
 	struct ieee80211_channel *channel;
 	bool need_ps = false;
 
@@ -2407,7 +2407,7 @@ int ieee80211_mgd_assoc(struct ieee80211_sub_if_data *sdata,
 			struct cfg80211_assoc_request *req)
 {
 	struct ieee80211_if_managed *ifmgd = &sdata->u.mgd;
-	struct ieee80211_bss *bss = (void *)req->bss->priv;
+	struct mac80211_bss *bss = (void *)req->bss->priv;
 	struct ieee80211_work *wk;
 	const u8 *ssid;
 	int i;
diff --git a/net/mac80211/scan.c b/net/mac80211/scan.c
index e7b8be2..7c3d17b 100644
--- a/net/mac80211/scan.c
+++ b/net/mac80211/scan.c
@@ -27,7 +27,7 @@
 #define IEEE80211_CHANNEL_TIME (HZ / 33)
 #define IEEE80211_PASSIVE_CHANNEL_TIME (HZ / 8)
 
-struct ieee80211_bss *
+struct mac80211_bss *
 ieee80211_rx_bss_get(struct mac80211_local *local, u8 *bssid, int freq,
 		     u8 *ssid, u8 ssid_len)
 {
@@ -43,14 +43,14 @@ ieee80211_rx_bss_get(struct mac80211_local *local, u8 *bssid, int freq,
 
 static void ieee80211_rx_bss_free(struct cfg80211_bss *cbss)
 {
-	struct ieee80211_bss *bss = (void *)cbss->priv;
+	struct mac80211_bss *bss = (void *)cbss->priv;
 
 	kfree(bss_mesh_id(bss));
 	kfree(bss_mesh_cfg(bss));
 }
 
 void ieee80211_rx_bss_put(struct mac80211_local *local,
-			  struct ieee80211_bss *bss)
+			  struct mac80211_bss *bss)
 {
 	if (!bss)
 		return;
@@ -74,7 +74,7 @@ static bool is_uapsd_supported(struct ieee802_11_elems *elems)
 	return qos_info & IEEE80211_WMM_IE_AP_QOSINFO_UAPSD;
 }
 
-struct ieee80211_bss *
+struct mac80211_bss *
 ieee80211_bss_info_update(struct mac80211_local *local,
 			  struct ieee80211_rx_status *rx_status,
 			  struct ieee80211_mgmt *mgmt,
@@ -84,7 +84,7 @@ ieee80211_bss_info_update(struct mac80211_local *local,
 			  bool beacon)
 {
 	struct cfg80211_bss *cbss;
-	struct ieee80211_bss *bss;
+	struct mac80211_bss *bss;
 	int clen, srlen;
 	s32 signal = 0;
 
@@ -151,7 +151,7 @@ ieee80211_scan_rx(struct ieee80211_sub_if_data *sdata, struct sk_buff *skb)
 {
 	struct ieee80211_rx_status *rx_status = IEEE80211_SKB_RXCB(skb);
 	struct ieee80211_mgmt *mgmt;
-	struct ieee80211_bss *bss;
+	struct mac80211_bss *bss;
 	u8 *elements;
 	struct ieee80211_channel *channel;
 	size_t baselen;

