Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from paleale.coelho.fi ([176.9.41.70]:40612 "EHLO
        farmhouse.coelho.fi" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1754572AbeDTKtg (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 20 Apr 2018 06:49:36 -0400
From: Luca Coelho <luca@coelho.fi>
To: johannes@sipsolutions.net
Cc: linux-wireless@vger.kernel.org, Ilan Peer <ilan.peer@intel.com>,
        Luca Coelho <luciano.coelho@intel.com>
Date: Fri, 20 Apr 2018 13:49:20 +0300
Message-Id: <20180420104926.8816-4-luca@coelho.fi> (sfid-20180420_124948_446782_7E969B20)
In-Reply-To: <20180420104926.8816-1-luca@coelho.fi>
References: <20180420104926.8816-1-luca@coelho.fi>
Subject: [PATCH 3/9] mac80211: Adjust SAE authentication timeout
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Ilan Peer <ilan.peer@intel.com>

The IEEE P802.11-REVmd D1.0 specification updated the SAE authentication
timeout to be 2000 milliseconds (see dot11RSNASAERetransPeriod). Update
the SAE timeout setting accordingly.

While at it, reduce some code duplication in the timeout configuration.

Signed-off-by: Ilan Peer <ilan.peer@intel.com>
Signed-off-by: Luca Coelho <luciano.coelho@intel.com>
---
 net/mac80211/mlme.c | 25 ++++++++++++++++++-------
 1 file changed, 18 insertions(+), 7 deletions(-)

diff --git a/net/mac80211/mlme.c b/net/mac80211/mlme.c
index 69449db7e283..51021d3d2d18 100644
--- a/net/mac80211/mlme.c
+++ b/net/mac80211/mlme.c
@@ -36,6 +36,7 @@
 #define IEEE80211_AUTH_TIMEOUT		(HZ / 5)
 #define IEEE80211_AUTH_TIMEOUT_LONG	(HZ / 2)
 #define IEEE80211_AUTH_TIMEOUT_SHORT	(HZ / 10)
+#define IEEE80211_AUTH_TIMEOUT_SAE	(HZ * 2)
 #define IEEE80211_AUTH_MAX_TRIES	3
 #define IEEE80211_AUTH_WAIT_ASSOC	(HZ * 5)
 #define IEEE80211_ASSOC_TIMEOUT		(HZ / 5)
@@ -3814,16 +3815,19 @@ static int ieee80211_auth(struct ieee80211_sub_if_data *sdata)
 			    tx_flags);
 
 	if (tx_flags == 0) {
-		auth_data->timeout = jiffies + IEEE80211_AUTH_TIMEOUT;
-		auth_data->timeout_started = true;
-		run_again(sdata, auth_data->timeout);
+		if (auth_data->algorithm == WLAN_AUTH_SAE)
+			auth_data->timeout = jiffies +
+				IEEE80211_AUTH_TIMEOUT_SAE;
+		else
+			auth_data->timeout = jiffies + IEEE80211_AUTH_TIMEOUT;
 	} else {
 		auth_data->timeout =
 			round_jiffies_up(jiffies + IEEE80211_AUTH_TIMEOUT_LONG);
-		auth_data->timeout_started = true;
-		run_again(sdata, auth_data->timeout);
 	}
 
+	auth_data->timeout_started = true;
+	run_again(sdata, auth_data->timeout);
+
 	return 0;
 }
 
@@ -3894,8 +3898,15 @@ void ieee80211_sta_work(struct ieee80211_sub_if_data *sdata)
 		ifmgd->status_received = false;
 		if (ifmgd->auth_data && ieee80211_is_auth(fc)) {
 			if (status_acked) {
-				ifmgd->auth_data->timeout =
-					jiffies + IEEE80211_AUTH_TIMEOUT_SHORT;
+				if (ifmgd->auth_data->algorithm ==
+				    WLAN_AUTH_SAE)
+					ifmgd->auth_data->timeout =
+						jiffies +
+						IEEE80211_AUTH_TIMEOUT_SAE;
+				else
+					ifmgd->auth_data->timeout =
+						jiffies +
+						IEEE80211_AUTH_TIMEOUT_SHORT;
 				run_again(sdata, ifmgd->auth_data->timeout);
 			} else {
 				ifmgd->auth_data->timeout = jiffies - 1;
-- 
2.17.0
