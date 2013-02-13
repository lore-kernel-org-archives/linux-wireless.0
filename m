Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:53092 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965005Ab3BMWzM (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 13 Feb 2013 17:55:12 -0500
From: Johannes Berg <johannes@sipsolutions.net>
To: linux-wireless@vger.kernel.org
Cc: Wojciech.Dubowik@neratec.com,
	Johannes Berg <johannes.berg@intel.com>
Subject: [PATCH] mac80211: fix auth/assoc timeout handling
Date: Wed, 13 Feb 2013 23:55:04 +0100
Message-Id: <1360796104-32455-1-git-send-email-johannes@sipsolutions.net> (sfid-20130213_235517_826065_A2C916AB)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Johannes Berg <johannes.berg@intel.com>

In my commit 1672c0e31917f49d31d30d79067103432bc20cc7
("mac80211: start auth/assoc timeout on frame status")
I broke auth/assoc timeout handling: in case we wait
for the TX status, it now leaves the timeout field set
to 0, which is a valid time and can compare as being
before now ("jiffies"). Thus, if the work struct runs
for some other reason, the auth/assoc is treated as
having timed out.

Fix this by introducing a separate "timeout_started"
variable that tracks whether the timeout has started
and is checked before timing out.

Reported-by: Wojciech Dubowik <Wojciech.Dubowik@neratec.com>
Signed-off-by: Johannes Berg <johannes.berg@intel.com>
---
 net/mac80211/ieee80211_i.h |  2 ++
 net/mac80211/mlme.c        | 23 +++++++++++++++++++----
 2 files changed, 21 insertions(+), 4 deletions(-)

diff --git a/net/mac80211/ieee80211_i.h b/net/mac80211/ieee80211_i.h
index 959888c..815e019 100644
--- a/net/mac80211/ieee80211_i.h
+++ b/net/mac80211/ieee80211_i.h
@@ -343,6 +343,7 @@ struct ieee80211_mgd_auth_data {
 	u8 key[WLAN_KEY_LEN_WEP104];
 	u8 key_len, key_idx;
 	bool done;
+	bool timeout_started;
 
 	u16 sae_trans, sae_status;
 	size_t data_len;
@@ -364,6 +365,7 @@ struct ieee80211_mgd_assoc_data {
 	bool wmm, uapsd;
 	bool have_beacon, need_beacon;
 	bool synced;
+	bool timeout_started;
 
 	u8 ap_ht_param;
 
diff --git a/net/mac80211/mlme.c b/net/mac80211/mlme.c
index 7d4cde7..cafefb2 100644
--- a/net/mac80211/mlme.c
+++ b/net/mac80211/mlme.c
@@ -1999,6 +1999,7 @@ ieee80211_rx_mgmt_auth(struct ieee80211_sub_if_data *sdata,
 	sdata_info(sdata, "authenticated\n");
 	ifmgd->auth_data->done = true;
 	ifmgd->auth_data->timeout = jiffies + IEEE80211_AUTH_WAIT_ASSOC;
+	ifmgd->auth_data->timeout_started = true;
 	run_again(ifmgd, ifmgd->auth_data->timeout);
 
 	if (ifmgd->auth_data->algorithm == WLAN_AUTH_SAE &&
@@ -2333,6 +2334,7 @@ ieee80211_rx_mgmt_assoc_resp(struct ieee80211_sub_if_data *sdata,
 			   "%pM rejected association temporarily; comeback duration %u TU (%u ms)\n",
 			   mgmt->sa, tu, ms);
 		assoc_data->timeout = jiffies + msecs_to_jiffies(ms);
+		assoc_data->timeout_started = true;
 		if (ms > IEEE80211_ASSOC_TIMEOUT)
 			run_again(ifmgd, assoc_data->timeout);
 		return RX_MGMT_NONE;
@@ -2456,6 +2458,7 @@ static void ieee80211_rx_mgmt_probe_resp(struct ieee80211_sub_if_data *sdata,
 		sdata_info(sdata, "direct probe responded\n");
 		ifmgd->auth_data->tries = 0;
 		ifmgd->auth_data->timeout = jiffies;
+		ifmgd->auth_data->timeout_started = true;
 		run_again(ifmgd, ifmgd->auth_data->timeout);
 	}
 }
@@ -2541,6 +2544,7 @@ static void ieee80211_rx_mgmt_beacon(struct ieee80211_sub_if_data *sdata,
 		}
 		/* continue assoc process */
 		ifmgd->assoc_data->timeout = jiffies;
+		ifmgd->assoc_data->timeout_started = true;
 		run_again(ifmgd, ifmgd->assoc_data->timeout);
 		return;
 	}
@@ -2933,7 +2937,10 @@ static int ieee80211_probe_auth(struct ieee80211_sub_if_data *sdata)
 
 	if (!(local->hw.flags & IEEE80211_HW_REPORTS_TX_ACK_STATUS)) {
 		auth_data->timeout = jiffies + IEEE80211_AUTH_TIMEOUT;
+		ifmgd->auth_data->timeout_started = true;
 		run_again(ifmgd, auth_data->timeout);
+	} else {
+		auth_data->timeout_started = false;
 	}
 
 	return 0;
@@ -2967,7 +2974,10 @@ static int ieee80211_do_assoc(struct ieee80211_sub_if_data *sdata)
 
 	if (!(local->hw.flags & IEEE80211_HW_REPORTS_TX_ACK_STATUS)) {
 		assoc_data->timeout = jiffies + IEEE80211_ASSOC_TIMEOUT;
+		assoc_data->timeout_started = true;
 		run_again(&sdata->u.mgd, assoc_data->timeout);
+	} else {
+		assoc_data->timeout_started = false;
 	}
 
 	return 0;
@@ -3006,6 +3016,7 @@ void ieee80211_sta_work(struct ieee80211_sub_if_data *sdata)
 			} else {
 				ifmgd->auth_data->timeout = jiffies - 1;
 			}
+			ifmgd->auth_data->timeout_started = true;
 		} else if (ifmgd->assoc_data &&
 			   (ieee80211_is_assoc_req(fc) ||
 			    ieee80211_is_reassoc_req(fc))) {
@@ -3016,10 +3027,11 @@ void ieee80211_sta_work(struct ieee80211_sub_if_data *sdata)
 			} else {
 				ifmgd->assoc_data->timeout = jiffies - 1;
 			}
+			ifmgd->assoc_data->timeout_started = true;
 		}
 	}
 
-	if (ifmgd->auth_data &&
+	if (ifmgd->auth_data && ifmgd->auth_data->timeout_started &&
 	    time_after(jiffies, ifmgd->auth_data->timeout)) {
 		if (ifmgd->auth_data->done) {
 			/*
@@ -3038,10 +3050,10 @@ void ieee80211_sta_work(struct ieee80211_sub_if_data *sdata)
 			cfg80211_send_auth_timeout(sdata->dev, bssid);
 			mutex_lock(&ifmgd->mtx);
 		}
-	} else if (ifmgd->auth_data)
+	} else if (ifmgd->auth_data && ifmgd->auth_data->timeout_started)
 		run_again(ifmgd, ifmgd->auth_data->timeout);
 
-	if (ifmgd->assoc_data &&
+	if (ifmgd->assoc_data && ifmgd->assoc_data->timeout_started &&
 	    time_after(jiffies, ifmgd->assoc_data->timeout)) {
 		if ((ifmgd->assoc_data->need_beacon &&
 		     !ifmgd->assoc_data->have_beacon) ||
@@ -3056,7 +3068,7 @@ void ieee80211_sta_work(struct ieee80211_sub_if_data *sdata)
 			cfg80211_send_assoc_timeout(sdata->dev, bssid);
 			mutex_lock(&ifmgd->mtx);
 		}
-	} else if (ifmgd->assoc_data)
+	} else if (ifmgd->assoc_data && ifmgd->assoc_data->timeout_started)
 		run_again(ifmgd, ifmgd->assoc_data->timeout);
 
 	if (ifmgd->flags & (IEEE80211_STA_BEACON_POLL |
@@ -4031,6 +4043,7 @@ int ieee80211_mgd_assoc(struct ieee80211_sub_if_data *sdata,
 		sdata_info(sdata, "waiting for beacon from %pM\n",
 			   ifmgd->bssid);
 		assoc_data->timeout = TU_TO_EXP_TIME(req->bss->beacon_interval);
+		assoc_data->timeout_started = true;
 		assoc_data->need_beacon = true;
 	} else if (beacon_ies) {
 		const u8 *tim_ie = cfg80211_find_ie(WLAN_EID_TIM,
@@ -4046,6 +4059,7 @@ int ieee80211_mgd_assoc(struct ieee80211_sub_if_data *sdata,
 		}
 		assoc_data->have_beacon = true;
 		assoc_data->timeout = jiffies;
+		assoc_data->timeout_started = true;
 
 		if (local->hw.flags & IEEE80211_HW_TIMING_BEACON_ONLY) {
 			sdata->vif.bss_conf.sync_tsf = beacon_ies->tsf;
@@ -4055,6 +4069,7 @@ int ieee80211_mgd_assoc(struct ieee80211_sub_if_data *sdata,
 		}
 	} else {
 		assoc_data->timeout = jiffies;
+		assoc_data->timeout_started = true;
 	}
 	rcu_read_unlock();
 
-- 
1.8.0

