Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga01.intel.com ([192.55.52.88]:61023 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753190AbbHOTkz (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Sat, 15 Aug 2015 15:40:55 -0400
From: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
To: johannes@sipsolutions.net
Cc: linux-wireless@vger.kernel.org,
	Johannes Berg <johannes.berg@intel.com>
Subject: [PATCH 9/9] mac80211: remove direct probe step before authentication
Date: Sat, 15 Aug 2015 22:39:54 +0300
Message-Id: <1439667594-13632-10-git-send-email-emmanuel.grumbach@intel.com> (sfid-20150815_214058_471709_E041DA56)
In-Reply-To: <1439667594-13632-1-git-send-email-emmanuel.grumbach@intel.com>
References: <1439667594-13632-1-git-send-email-emmanuel.grumbach@intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Johannes Berg <johannes.berg@intel.com>

The direct probe step before authentication was done mostly for
two reasons:
 1) the BSS data could be stale
 2) the beacon might not have included all IEs

The concern (1) doesn't really seem to be relevant any more as
we time out BSS information after about 30 seconds, and in fact
the original patch only did the direct probe if the data was
older than the BSS timeout to begin with. This condition got
(likely inadvertedly) removed later though.

Analysing this in more detail shows that since we mostly use
data from the association response, the only real reason for
needing the probe response was that the code validates the WMM
parameters, and those are optional in beacons. As the previous
patches removed that behaviour, we can now remove the direct
probe step entirely.

Signed-off-by: Johannes Berg <johannes.berg@intel.com>
---
 net/mac80211/mlme.c | 82 +++++++++++++++--------------------------------------
 1 file changed, 23 insertions(+), 59 deletions(-)

diff --git a/net/mac80211/mlme.c b/net/mac80211/mlme.c
index cd7e55e..1d13ef5 100644
--- a/net/mac80211/mlme.c
+++ b/net/mac80211/mlme.c
@@ -3262,16 +3262,6 @@ static void ieee80211_rx_mgmt_probe_resp(struct ieee80211_sub_if_data *sdata,
 	if (ifmgd->associated &&
 	    ether_addr_equal(mgmt->bssid, ifmgd->associated->bssid))
 		ieee80211_reset_ap_probe(sdata);
-
-	if (ifmgd->auth_data && !ifmgd->auth_data->bss->proberesp_ies &&
-	    ether_addr_equal(mgmt->bssid, ifmgd->auth_data->bss->bssid)) {
-		/* got probe response, continue with auth */
-		sdata_info(sdata, "direct probe responded\n");
-		ifmgd->auth_data->tries = 0;
-		ifmgd->auth_data->timeout = jiffies;
-		ifmgd->auth_data->timeout_started = true;
-		run_again(sdata, ifmgd->auth_data->timeout);
-	}
 }
 
 /*
@@ -3717,12 +3707,14 @@ static void ieee80211_sta_connection_lost(struct ieee80211_sub_if_data *sdata,
 				    reason);
 }
 
-static int ieee80211_probe_auth(struct ieee80211_sub_if_data *sdata)
+static int ieee80211_auth(struct ieee80211_sub_if_data *sdata)
 {
 	struct ieee80211_local *local = sdata->local;
 	struct ieee80211_if_managed *ifmgd = &sdata->u.mgd;
 	struct ieee80211_mgd_auth_data *auth_data = ifmgd->auth_data;
 	u32 tx_flags = 0;
+	u16 trans = 1;
+	u16 status = 0;
 
 	sdata_assert_lock(sdata);
 
@@ -3746,54 +3738,27 @@ static int ieee80211_probe_auth(struct ieee80211_sub_if_data *sdata)
 
 	drv_mgd_prepare_tx(local, sdata);
 
-	if (auth_data->bss->proberesp_ies) {
-		u16 trans = 1;
-		u16 status = 0;
-
-		sdata_info(sdata, "send auth to %pM (try %d/%d)\n",
-			   auth_data->bss->bssid, auth_data->tries,
-			   IEEE80211_AUTH_MAX_TRIES);
-
-		auth_data->expected_transaction = 2;
+	sdata_info(sdata, "send auth to %pM (try %d/%d)\n",
+		   auth_data->bss->bssid, auth_data->tries,
+		   IEEE80211_AUTH_MAX_TRIES);
 
-		if (auth_data->algorithm == WLAN_AUTH_SAE) {
-			trans = auth_data->sae_trans;
-			status = auth_data->sae_status;
-			auth_data->expected_transaction = trans;
-		}
+	auth_data->expected_transaction = 2;
 
-		if (ieee80211_hw_check(&local->hw, REPORTS_TX_ACK_STATUS))
-			tx_flags = IEEE80211_TX_CTL_REQ_TX_STATUS |
-				   IEEE80211_TX_INTFL_MLME_CONN_TX;
-
-		ieee80211_send_auth(sdata, trans, auth_data->algorithm, status,
-				    auth_data->data, auth_data->data_len,
-				    auth_data->bss->bssid,
-				    auth_data->bss->bssid, NULL, 0, 0,
-				    tx_flags);
-	} else {
-		const u8 *ssidie;
+	if (auth_data->algorithm == WLAN_AUTH_SAE) {
+		trans = auth_data->sae_trans;
+		status = auth_data->sae_status;
+		auth_data->expected_transaction = trans;
+	}
 
-		sdata_info(sdata, "direct probe to %pM (try %d/%i)\n",
-			   auth_data->bss->bssid, auth_data->tries,
-			   IEEE80211_AUTH_MAX_TRIES);
+	if (ieee80211_hw_check(&local->hw, REPORTS_TX_ACK_STATUS))
+		tx_flags = IEEE80211_TX_CTL_REQ_TX_STATUS |
+			   IEEE80211_TX_INTFL_MLME_CONN_TX;
 
-		rcu_read_lock();
-		ssidie = ieee80211_bss_get_ie(auth_data->bss, WLAN_EID_SSID);
-		if (!ssidie) {
-			rcu_read_unlock();
-			return -EINVAL;
-		}
-		/*
-		 * Direct probe is sent to broadcast address as some APs
-		 * will not answer to direct packet in unassociated state.
-		 */
-		ieee80211_send_probe_req(sdata, sdata->vif.addr, NULL,
-					 ssidie + 2, ssidie[1],
-					 NULL, 0, (u32) -1, true, 0,
-					 auth_data->bss->channel, false);
-		rcu_read_unlock();
-	}
+	ieee80211_send_auth(sdata, trans, auth_data->algorithm, status,
+			    auth_data->data, auth_data->data_len,
+			    auth_data->bss->bssid,
+			    auth_data->bss->bssid, NULL, 0, 0,
+			    tx_flags);
 
 	if (tx_flags == 0) {
 		auth_data->timeout = jiffies + IEEE80211_AUTH_TIMEOUT;
@@ -3874,8 +3839,7 @@ void ieee80211_sta_work(struct ieee80211_sub_if_data *sdata)
 		bool status_acked = ifmgd->status_acked;
 
 		ifmgd->status_received = false;
-		if (ifmgd->auth_data &&
-		    (ieee80211_is_probe_req(fc) || ieee80211_is_auth(fc))) {
+		if (ifmgd->auth_data && ieee80211_is_auth(fc)) {
 			if (status_acked) {
 				ifmgd->auth_data->timeout =
 					jiffies + IEEE80211_AUTH_TIMEOUT_SHORT;
@@ -3906,7 +3870,7 @@ void ieee80211_sta_work(struct ieee80211_sub_if_data *sdata)
 			 * so let's just kill the auth data
 			 */
 			ieee80211_destroy_auth_data(sdata, false);
-		} else if (ieee80211_probe_auth(sdata)) {
+		} else if (ieee80211_auth(sdata)) {
 			u8 bssid[ETH_ALEN];
 			struct ieee80211_event event = {
 				.type = MLME_EVENT,
@@ -4613,7 +4577,7 @@ int ieee80211_mgd_auth(struct ieee80211_sub_if_data *sdata,
 	if (err)
 		goto err_clear;
 
-	err = ieee80211_probe_auth(sdata);
+	err = ieee80211_auth(sdata);
 	if (err) {
 		sta_info_destroy_addr(sdata, req->bss->bssid);
 		goto err_clear;
-- 
2.1.4

