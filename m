Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pb0-f46.google.com ([209.85.160.46]:64951 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932783Ab2C2X27 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 29 Mar 2012 19:28:59 -0400
Received: by pbcun15 with SMTP id un15so789198pbc.19
        for <linux-wireless@vger.kernel.org>; Thu, 29 Mar 2012 16:28:58 -0700 (PDT)
MIME-Version: 1.0
From: Ashok Nagarajan <ashok@cozybit.com>
To: linux-wireless@vger.kernel.org
Cc: javier@cozybit.com, thomas@cozybit.com, johannes@sipsolutions.net,
	devel@lists.open80211s.org, linville@tuxdriver.com,
	Ashok Nagarajan <ashok@cozybit.com>
Subject: [PATCH 3/4] mac80211: Modify sta_get_rates to give basic rates
Date: Thu, 29 Mar 2012 16:28:48 -0700
Message-Id: <1333063729-9353-3-git-send-email-ashok@cozybit.com> (sfid-20120330_012905_402884_17AE1933)
In-Reply-To: <1333063729-9353-1-git-send-email-ashok@cozybit.com>
References: <1333063729-9353-1-git-send-email-ashok@cozybit.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


Signed-off-by: Ashok Nagarajan <ashok@cozybit.com>
Signed-off-by: Thomas Pedersen <thomas@cozybit.com>
---
 net/mac80211/ibss.c        |    4 ++--
 net/mac80211/ieee80211_i.h |    2 +-
 net/mac80211/mesh.c        |    5 +++--
 net/mac80211/mesh_plink.c  |    7 ++++---
 net/mac80211/util.c        |   16 +++++++++++++---
 5 files changed, 23 insertions(+), 11 deletions(-)

diff --git a/net/mac80211/ibss.c b/net/mac80211/ibss.c
index 33fd8d9..17bfb3a 100644
--- a/net/mac80211/ibss.c
+++ b/net/mac80211/ibss.c
@@ -410,7 +410,7 @@ static void ieee80211_rx_bss_info(struct ieee80211_sub_if_data *sdata,
 
 		if (elems->supp_rates) {
 			supp_rates = ieee80211_sta_get_rates(local, elems,
-							     band);
+							     band, NULL);
 			if (sta) {
 				u32 prev_rates;
 
@@ -560,7 +560,7 @@ static void ieee80211_rx_bss_info(struct ieee80211_sub_if_data *sdata,
 		       sdata->name, mgmt->bssid);
 #endif
 		ieee80211_sta_join_ibss(sdata, bss);
-		supp_rates = ieee80211_sta_get_rates(local, elems, band);
+		supp_rates = ieee80211_sta_get_rates(local, elems, band, NULL);
 		ieee80211_ibss_add_sta(sdata, mgmt->bssid, mgmt->sa,
 				       supp_rates, true);
 		rcu_read_unlock();
diff --git a/net/mac80211/ieee80211_i.h b/net/mac80211/ieee80211_i.h
index d9798a3..1cf5c03 100644
--- a/net/mac80211/ieee80211_i.h
+++ b/net/mac80211/ieee80211_i.h
@@ -1460,7 +1460,7 @@ void ieee80211_sta_def_wmm_params(struct ieee80211_sub_if_data *sdata,
 				  const u8 *supp_rates);
 u32 ieee80211_sta_get_rates(struct ieee80211_local *local,
 			    struct ieee802_11_elems *elems,
-			    enum ieee80211_band band);
+			    enum ieee80211_band band, u32 *basic_rates);
 int __ieee80211_request_smps(struct ieee80211_sub_if_data *sdata,
 			     enum ieee80211_smps_mode smps_mode);
 void ieee80211_recalc_smps(struct ieee80211_local *local);
diff --git a/net/mac80211/mesh.c b/net/mac80211/mesh.c
index 56ec79d..964d8a9 100644
--- a/net/mac80211/mesh.c
+++ b/net/mac80211/mesh.c
@@ -622,7 +622,7 @@ static void ieee80211_mesh_rx_bcn_presp(struct ieee80211_sub_if_data *sdata,
 	struct ieee80211_local *local = sdata->local;
 	struct ieee802_11_elems elems;
 	struct ieee80211_channel *channel;
-	u32 supp_rates = 0;
+	u32 supp_rates = 0, basic_rates = 0;
 	size_t baselen;
 	int freq;
 	enum ieee80211_band band = rx_status->band;
@@ -655,7 +655,8 @@ static void ieee80211_mesh_rx_bcn_presp(struct ieee80211_sub_if_data *sdata,
 
 	if (elems.mesh_id && elems.mesh_config &&
 	    mesh_matches_local(&elems, sdata)) {
-		supp_rates = ieee80211_sta_get_rates(local, &elems, band);
+		supp_rates = ieee80211_sta_get_rates(local, &elems,
+						     band, &basic_rates);
 		mesh_neighbour_update(mgmt, supp_rates, sdata, &elems,
 					rx_status);
 	}
diff --git a/net/mac80211/mesh_plink.c b/net/mac80211/mesh_plink.c
index 8ba5f5e..879b0a1 100644
--- a/net/mac80211/mesh_plink.c
+++ b/net/mac80211/mesh_plink.c
@@ -474,6 +474,7 @@ void mesh_rx_plink_frame(struct ieee80211_sub_if_data *sdata, struct ieee80211_m
 	bool deactivated, matches_local = true;
 	u8 ie_len;
 	u8 *baseaddr;
+	u32 rates, basic_rates = 0;
 	__le16 plid, llid, reason;
 #ifdef CONFIG_MAC80211_VERBOSE_MPL_DEBUG
 	static const char *mplstates[] = {
@@ -568,6 +569,9 @@ void mesh_rx_plink_frame(struct ieee80211_sub_if_data *sdata, struct ieee80211_m
 
 	/* Now we will figure out the appropriate event... */
 	event = PLINK_UNDEFINED;
+	rates = ieee80211_sta_get_rates(local, &elems,
+					rx_status->band, &basic_rates);
+
 	if (ftype != WLAN_SP_MESH_PEERING_CLOSE &&
 	    (!mesh_matches_local(&elems, sdata))) {
 		matches_local = false;
@@ -592,7 +596,6 @@ void mesh_rx_plink_frame(struct ieee80211_sub_if_data *sdata, struct ieee80211_m
 		return;
 	} else if (!sta) {
 		/* ftype == WLAN_SP_MESH_PEERING_OPEN */
-		u32 rates;
 
 		rcu_read_unlock();
 
@@ -600,8 +603,6 @@ void mesh_rx_plink_frame(struct ieee80211_sub_if_data *sdata, struct ieee80211_m
 			mpl_dbg("Mesh plink error: no more free plinks\n");
 			return;
 		}
-
-		rates = ieee80211_sta_get_rates(local, &elems, rx_status->band);
 		sta = mesh_plink_alloc(sdata, mgmt->sa, rates, &elems);
 		if (!sta) {
 			mpl_dbg("Mesh plink error: plink table full\n");
diff --git a/net/mac80211/util.c b/net/mac80211/util.c
index a1e2ff5..0b8763d 100644
--- a/net/mac80211/util.c
+++ b/net/mac80211/util.c
@@ -1106,7 +1106,7 @@ void ieee80211_send_probe_req(struct ieee80211_sub_if_data *sdata, u8 *dst,
 
 u32 ieee80211_sta_get_rates(struct ieee80211_local *local,
 			    struct ieee802_11_elems *elems,
-			    enum ieee80211_band band)
+			    enum ieee80211_band band, u32 *basic_rates)
 {
 	struct ieee80211_supported_band *sband;
 	struct ieee80211_rate *bitrates;
@@ -1127,15 +1127,25 @@ u32 ieee80211_sta_get_rates(struct ieee80211_local *local,
 		     elems->ext_supp_rates_len; i++) {
 		u8 rate = 0;
 		int own_rate;
+		bool is_basic;
 		if (i < elems->supp_rates_len)
 			rate = elems->supp_rates[i];
 		else if (elems->ext_supp_rates)
 			rate = elems->ext_supp_rates
 				[i - elems->supp_rates_len];
 		own_rate = 5 * (rate & 0x7f);
-		for (j = 0; j < num_rates; j++)
-			if (bitrates[j].bitrate == own_rate)
+		is_basic = !!(rate & 0x80);
+
+		if (is_basic && (rate & 0x7f) == BSS_MEMBERSHIP_SELECTOR_HT_PHY)
+			continue;
+
+		for (j = 0; j < num_rates; j++) {
+			if (bitrates[j].bitrate == own_rate) {
 				supp_rates |= BIT(j);
+				if (basic_rates && is_basic)
+					*basic_rates |= BIT(j);
+			}
+		}
 	}
 	return supp_rates;
 }
-- 
1.7.5.4

