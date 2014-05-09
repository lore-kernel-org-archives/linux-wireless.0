Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from dedo.coelho.fi ([88.198.205.34]:44365 "EHLO dedo.coelho.fi"
	rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org with ESMTP
	id S1756509AbaEILMM (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 9 May 2014 07:12:12 -0400
From: Luca Coelho <luca@coelho.fi>
To: johannes@sipsolutions.net
Cc: linux-wireless@vger.kernel.org, michal.kazior@tieto.com,
	andrei.otcheretianski@intel.com
Date: Fri,  9 May 2014 14:11:47 +0300
Message-Id: <1399633911-12788-5-git-send-email-luca@coelho.fi> (sfid-20140509_131237_576081_6957B982)
In-Reply-To: <1399633911-12788-1-git-send-email-luca@coelho.fi>
References: <1399633911-12788-1-git-send-email-luca@coelho.fi>
Subject: [PATCH 4/8] mac80211: Support multiple CSA counters
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Andrei Otcheretianski <andrei.otcheretianski@intel.com>

Support up to IEEE80211_MAX_CSA_COUNTERS_NUM csa counters.
This is defined to be 2 now, to support both CSA and eCSA
counters.

Signed-off-by: Andrei Otcheretianski <andrei.otcheretianski@intel.com>
Signed-off-by: Luciano Coelho <luciano.coelho@intel.com>
---
 net/mac80211/cfg.c         | 24 +++++++++++++------
 net/mac80211/ibss.c        |  2 +-
 net/mac80211/ieee80211_i.h |  6 +++--
 net/mac80211/main.c        |  2 ++
 net/mac80211/mesh.c        |  2 +-
 net/mac80211/tx.c          | 58 ++++++++++++++++++++++++++++------------------
 net/wireless/nl80211.c     |  4 ++--
 7 files changed, 63 insertions(+), 35 deletions(-)

diff --git a/net/mac80211/cfg.c b/net/mac80211/cfg.c
index 6f132a5..43af0d6b 100644
--- a/net/mac80211/cfg.c
+++ b/net/mac80211/cfg.c
@@ -3191,14 +3191,24 @@ static int ieee80211_set_csa_beacon(struct ieee80211_sub_if_data *sdata,
 		if (params->count <= 1)
 			break;
 
-		sdata->csa_counter_offset_beacon =
-			params->counter_offsets_beacon[0];
+		if ((params->n_counter_offsets_beacon >
+		     IEEE80211_MAX_CSA_COUNTERS_NUM) ||
+		    (params->n_counter_offsets_presp >
+		     IEEE80211_MAX_CSA_COUNTERS_NUM))
+			return -EINVAL;
 
-		if (params->n_counter_offsets_presp)
-			sdata->csa_counter_offset_presp =
-				params->counter_offsets_presp[0];
-		else
-			sdata->csa_counter_offset_presp = 0;
+		/* make sure we don't have garbage in other counters */
+		memset(sdata->csa_counter_offset_beacon, 0,
+		       sizeof(sdata->csa_counter_offset_beacon));
+		memset(sdata->csa_counter_offset_presp, 0,
+		       sizeof(sdata->csa_counter_offset_presp));
+
+		memcpy(sdata->csa_counter_offset_beacon,
+		       params->counter_offsets_beacon,
+		       params->n_counter_offsets_beacon * sizeof(u16));
+		memcpy(sdata->csa_counter_offset_presp,
+		       params->counter_offsets_presp,
+		       params->n_counter_offsets_presp * sizeof(u16));
 
 		err = ieee80211_assign_beacon(sdata, &params->beacon_csa);
 		if (err < 0) {
diff --git a/net/mac80211/ibss.c b/net/mac80211/ibss.c
index ff4d415..1bbac94 100644
--- a/net/mac80211/ibss.c
+++ b/net/mac80211/ibss.c
@@ -143,7 +143,7 @@ ieee80211_ibss_build_presp(struct ieee80211_sub_if_data *sdata,
 		*pos++ = csa_settings->block_tx ? 1 : 0;
 		*pos++ = ieee80211_frequency_to_channel(
 				csa_settings->chandef.chan->center_freq);
-		sdata->csa_counter_offset_beacon = (pos - presp->head);
+		sdata->csa_counter_offset_beacon[0] = (pos - presp->head);
 		*pos++ = csa_settings->count;
 	}
 
diff --git a/net/mac80211/ieee80211_i.h b/net/mac80211/ieee80211_i.h
index fb2d9e7..05ed592 100644
--- a/net/mac80211/ieee80211_i.h
+++ b/net/mac80211/ieee80211_i.h
@@ -70,6 +70,8 @@ struct ieee80211_local;
 
 #define IEEE80211_DEAUTH_FRAME_LEN	(24 /* hdr */ + 2 /* reason */)
 
+#define IEEE80211_MAX_CSA_COUNTERS_NUM 2
+
 struct ieee80211_fragment_entry {
 	unsigned long first_frag_time;
 	unsigned int seq;
@@ -753,8 +755,8 @@ struct ieee80211_sub_if_data {
 	struct mac80211_qos_map __rcu *qos_map;
 
 	struct work_struct csa_finalize_work;
-	int csa_counter_offset_beacon;
-	int csa_counter_offset_presp;
+	u16 csa_counter_offset_beacon[IEEE80211_MAX_CSA_COUNTERS_NUM];
+	u16 csa_counter_offset_presp[IEEE80211_MAX_CSA_COUNTERS_NUM];
 	bool csa_radar_required;
 	bool csa_block_tx; /* write-protected by sdata_lock and local->mtx */
 	struct cfg80211_chan_def csa_chandef;
diff --git a/net/mac80211/main.c b/net/mac80211/main.c
index 69175f1..767335f 100644
--- a/net/mac80211/main.c
+++ b/net/mac80211/main.c
@@ -954,6 +954,8 @@ int ieee80211_register_hw(struct ieee80211_hw *hw)
 	if (local->hw.wiphy->flags & WIPHY_FLAG_SUPPORTS_TDLS)
 		local->hw.wiphy->flags |= WIPHY_FLAG_TDLS_EXTERNAL_SETUP;
 
+	local->hw.wiphy->max_num_csa_counters = IEEE80211_MAX_CSA_COUNTERS_NUM;
+
 	result = wiphy_register(local->hw.wiphy);
 	if (result < 0)
 		goto fail_wiphy_register;
diff --git a/net/mac80211/mesh.c b/net/mac80211/mesh.c
index b06ddc9..6495a3f 100644
--- a/net/mac80211/mesh.c
+++ b/net/mac80211/mesh.c
@@ -679,7 +679,7 @@ ieee80211_mesh_build_beacon(struct ieee80211_if_mesh *ifmsh)
 		*pos++ = 0x0;
 		*pos++ = ieee80211_frequency_to_channel(
 				csa->settings.chandef.chan->center_freq);
-		sdata->csa_counter_offset_beacon = hdr_len + 6;
+		sdata->csa_counter_offset_beacon[0] = hdr_len + 6;
 		*pos++ = csa->settings.count;
 		*pos++ = WLAN_EID_CHAN_SWITCH_PARAM;
 		*pos++ = 6;
diff --git a/net/mac80211/tx.c b/net/mac80211/tx.c
index 263dea5..0d1a42d 100644
--- a/net/mac80211/tx.c
+++ b/net/mac80211/tx.c
@@ -2417,10 +2417,9 @@ static void ieee80211_update_csa(struct ieee80211_sub_if_data *sdata,
 				 struct beacon_data *beacon)
 {
 	struct probe_resp *resp;
-	int counter_offset_beacon = sdata->csa_counter_offset_beacon;
-	int counter_offset_presp = sdata->csa_counter_offset_presp;
 	u8 *beacon_data;
 	size_t beacon_data_len;
+	int i;
 
 	switch (sdata->vif.type) {
 	case NL80211_IFTYPE_AP:
@@ -2438,32 +2437,47 @@ static void ieee80211_update_csa(struct ieee80211_sub_if_data *sdata,
 	default:
 		return;
 	}
-	if (WARN_ON(counter_offset_beacon >= beacon_data_len))
-		return;
 
-	/* Warn if the driver did not check for/react to csa
-	 * completeness.  A beacon with CSA counter set to 0 should
-	 * never occur, because a counter of 1 means switch just
-	 * before the next beacon.
-	 */
-	if (WARN_ON(beacon_data[counter_offset_beacon] == 1))
-		return;
+	for (i = 0; i < IEEE80211_MAX_CSA_COUNTERS_NUM; ++i) {
+		u16 counter_offset_beacon =
+			sdata->csa_counter_offset_beacon[i];
+		u16 counter_offset_presp = sdata->csa_counter_offset_presp[i];
 
-	sdata->csa_current_counter--;
-	beacon_data[counter_offset_beacon] = sdata->csa_current_counter;
+		if (counter_offset_beacon) {
+			if (WARN_ON(counter_offset_beacon >= beacon_data_len))
+				return;
 
-	if (sdata->vif.type == NL80211_IFTYPE_AP && counter_offset_presp) {
-		rcu_read_lock();
-		resp = rcu_dereference(sdata->u.ap.probe_resp);
+			/* Warn if the driver did not check for/react to csa
+			 * completeness.  A beacon with CSA counter set to 0
+			 * should never occur, because a counter of 1 means
+			 * switch just before the next beacon.
+			 */
+			if (WARN_ON(beacon_data[counter_offset_beacon] == 1))
+				return;
 
-		/* if nl80211 accepted the offset, this should not happen. */
-		if (WARN_ON(!resp)) {
+			beacon_data[counter_offset_beacon] =
+				sdata->csa_current_counter - 1;
+		}
+
+		if (sdata->vif.type == NL80211_IFTYPE_AP &&
+		    counter_offset_presp) {
+			rcu_read_lock();
+			resp = rcu_dereference(sdata->u.ap.probe_resp);
+
+			/* If nl80211 accepted the offset, this should
+			 * not happen.
+			 */
+			if (WARN_ON(!resp)) {
+				rcu_read_unlock();
+				return;
+			}
+			resp->data[counter_offset_presp] =
+				sdata->csa_current_counter - 1;
 			rcu_read_unlock();
-			return;
 		}
-		resp->data[counter_offset_presp] = sdata->csa_current_counter;
-		rcu_read_unlock();
 	}
+
+	sdata->csa_current_counter--;
 }
 
 bool ieee80211_csa_is_complete(struct ieee80211_vif *vif)
@@ -2472,7 +2486,7 @@ bool ieee80211_csa_is_complete(struct ieee80211_vif *vif)
 	struct beacon_data *beacon = NULL;
 	u8 *beacon_data;
 	size_t beacon_data_len;
-	int counter_beacon = sdata->csa_counter_offset_beacon;
+	int counter_beacon = sdata->csa_counter_offset_beacon[0];
 	int ret = false;
 
 	if (!ieee80211_sdata_running(sdata))
diff --git a/net/wireless/nl80211.c b/net/wireless/nl80211.c
index 6cfff9b..30ab799 100644
--- a/net/wireless/nl80211.c
+++ b/net/wireless/nl80211.c
@@ -1669,9 +1669,9 @@ static int nl80211_send_wiphy(struct cfg80211_registered_device *rdev,
 			nla_nest_end(msg, nested);
 		}
 
-		if (dev->wiphy.flags & WIPHY_FLAG_HAS_CHANNEL_SWITCH &&
+		if (rdev->wiphy.flags & WIPHY_FLAG_HAS_CHANNEL_SWITCH &&
 		    nla_put_u8(msg, NL80211_ATTR_MAX_CSA_COUNTERS,
-			       dev->wiphy.max_num_csa_counters))
+			       rdev->wiphy.max_num_csa_counters))
 			goto nla_put_failure;
 
 		/* done */
-- 
2.0.0.rc0

