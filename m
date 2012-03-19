Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from ebb06.tieto.com ([131.207.168.38]:42906 "EHLO ebb06.tieto.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754896Ab2CTOzF (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 20 Mar 2012 10:55:05 -0400
From: Michal Kazior <michal.kazior@tieto.com>
Date: Mon, 19 Mar 2012 08:50:08 +0100
Subject: [RFC 02/12] mac80211: prepare ieee80211_sta_get_rates to per-vif
To: <linux-wireless@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain
Message-ID: <50e68d85-854e-4bfc-8a31-3f5db15e328d@FIVLA-EXHUB02.eu.tieto.com> (sfid-20120320_155509_904376_A71717D6)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

In preparation for multi-channel operation.

Signed-off-by: Michal Kazior <michal.kazior@tieto.com>
---
 net/mac80211/ibss.c        |    4 ++--
 net/mac80211/ieee80211_i.h |    2 +-
 net/mac80211/mesh.c        |    2 +-
 net/mac80211/mesh_plink.c  |    2 +-
 net/mac80211/util.c        |    3 ++-
 5 files changed, 7 insertions(+), 6 deletions(-)

diff --git a/net/mac80211/ibss.c b/net/mac80211/ibss.c
index 50ba1fa..8bea83b 100644
--- a/net/mac80211/ibss.c
+++ b/net/mac80211/ibss.c
@@ -409,7 +409,7 @@ static void ieee80211_rx_bss_info(struct ieee80211_sub_if_data *sdata,
 		sta = sta_info_get(sdata, mgmt->sa);
 
 		if (elems->supp_rates) {
-			supp_rates = ieee80211_sta_get_rates(local, elems,
+			supp_rates = ieee80211_sta_get_rates(sdata, elems,
 							     band);
 			if (sta) {
 				u32 prev_rates;
@@ -560,7 +560,7 @@ static void ieee80211_rx_bss_info(struct ieee80211_sub_if_data *sdata,
 		       sdata->name, mgmt->bssid);
 #endif
 		ieee80211_sta_join_ibss(sdata, bss);
-		supp_rates = ieee80211_sta_get_rates(local, elems, band);
+		supp_rates = ieee80211_sta_get_rates(sdata, elems, band);
 		ieee80211_ibss_add_sta(sdata, mgmt->bssid, mgmt->sa,
 				       supp_rates, true);
 		rcu_read_unlock();
diff --git a/net/mac80211/ieee80211_i.h b/net/mac80211/ieee80211_i.h
index de9346e..822dafd 100644
--- a/net/mac80211/ieee80211_i.h
+++ b/net/mac80211/ieee80211_i.h
@@ -1458,7 +1458,7 @@ void ieee80211_send_probe_req(struct ieee80211_sub_if_data *sdata, u8 *dst,
 void ieee80211_sta_def_wmm_params(struct ieee80211_sub_if_data *sdata,
 				  const size_t supp_rates_len,
 				  const u8 *supp_rates);
-u32 ieee80211_sta_get_rates(struct ieee80211_local *local,
+u32 ieee80211_sta_get_rates(struct ieee80211_sub_if_data *sdata,
 			    struct ieee802_11_elems *elems,
 			    enum ieee80211_band band);
 int __ieee80211_request_smps(struct ieee80211_sub_if_data *sdata,
diff --git a/net/mac80211/mesh.c b/net/mac80211/mesh.c
index e5fbb7c..0e6106e 100644
--- a/net/mac80211/mesh.c
+++ b/net/mac80211/mesh.c
@@ -651,7 +651,7 @@ static void ieee80211_mesh_rx_bcn_presp(struct ieee80211_sub_if_data *sdata,
 
 	if (elems.mesh_id && elems.mesh_config &&
 	    mesh_matches_local(&elems, sdata)) {
-		supp_rates = ieee80211_sta_get_rates(local, &elems, band);
+		supp_rates = ieee80211_sta_get_rates(sdata, &elems, band);
 		mesh_neighbour_update(mgmt->sa, supp_rates, sdata, &elems);
 	}
 }
diff --git a/net/mac80211/mesh_plink.c b/net/mac80211/mesh_plink.c
index 4e53c4c..aee6014 100644
--- a/net/mac80211/mesh_plink.c
+++ b/net/mac80211/mesh_plink.c
@@ -592,7 +592,7 @@ void mesh_rx_plink_frame(struct ieee80211_sub_if_data *sdata, struct ieee80211_m
 			return;
 		}
 
-		rates = ieee80211_sta_get_rates(local, &elems, rx_status->band);
+		rates = ieee80211_sta_get_rates(sdata, &elems, rx_status->band);
 		sta = mesh_plink_alloc(sdata, mgmt->sa, rates, &elems);
 		if (!sta) {
 			mpl_dbg("Mesh plink error: plink table full\n");
diff --git a/net/mac80211/util.c b/net/mac80211/util.c
index 959b2c4..928721d 100644
--- a/net/mac80211/util.c
+++ b/net/mac80211/util.c
@@ -1105,10 +1105,11 @@ void ieee80211_send_probe_req(struct ieee80211_sub_if_data *sdata, u8 *dst,
 	}
 }
 
-u32 ieee80211_sta_get_rates(struct ieee80211_local *local,
+u32 ieee80211_sta_get_rates(struct ieee80211_sub_if_data *sdata,
 			    struct ieee802_11_elems *elems,
 			    enum ieee80211_band band)
 {
+	struct ieee80211_local *local = sdata->local;
 	struct ieee80211_supported_band *sband;
 	struct ieee80211_rate *bitrates;
 	size_t num_rates;
-- 
1.7.0.4

