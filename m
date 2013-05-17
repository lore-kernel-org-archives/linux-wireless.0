Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:18107 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755697Ab3EQLl2 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 17 May 2013 07:41:28 -0400
Date: Fri, 17 May 2013 13:43:04 +0200
From: Stanislaw Gruszka <sgruszka@redhat.com>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: linux-wireless@vger.kernel.org
Subject: [PATCH 3.10] mac80211: fix direct probe auth
Message-ID: <20130517114303.GB1641@redhat.com> (sfid-20130517_134147_282067_74742627)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

We send direct probe to broadcast address, as some APs do not respond to
unicast PROBE frames when unassociated. Broadcast frames are not acked,
so we can not use that for trigger MLME state machine, but we need to
use old timeout mechanism.

This fixes authentication timed out like below:

[ 1024.671974] wlan6: authenticate with 54:e6:fc:98:63:fe
[ 1024.694125] wlan6: direct probe to 54:e6:fc:98:63:fe (try 1/3)
[ 1024.695450] wlan6: direct probe to 54:e6:fc:98:63:fe (try 2/3)
[ 1024.700586] wlan6: send auth to 54:e6:fc:98:63:fe (try 3/3)
[ 1024.701441] wlan6: authentication with 54:e6:fc:98:63:fe timed out

With fix, we have:

[ 4524.198978] wlan6: authenticate with 54:e6:fc:98:63:fe
[ 4524.220692] wlan6: direct probe to 54:e6:fc:98:63:fe (try 1/3)
[ 4524.421784] wlan6: send auth to 54:e6:fc:98:63:fe (try 2/3)
[ 4524.423272] wlan6: authenticated
[ 4524.423811] wlan6: associate with 54:e6:fc:98:63:fe (try 1/3)
[ 4524.427492] wlan6: RX AssocResp from 54:e6:fc:98:63:fe (capab=0x431 status=0 aid=1)

Cc: stable@vger.kernel.org # 3.9
Signed-off-by: Stanislaw Gruszka <sgruszka@redhat.com>
---
 net/mac80211/mlme.c |   12 ++++++------
 1 files changed, 6 insertions(+), 6 deletions(-)

diff --git a/net/mac80211/mlme.c b/net/mac80211/mlme.c
index 346ad4c..0a60f40 100644
--- a/net/mac80211/mlme.c
+++ b/net/mac80211/mlme.c
@@ -3182,10 +3182,6 @@ static int ieee80211_probe_auth(struct ieee80211_sub_if_data *sdata)
 	if (WARN_ON_ONCE(!auth_data))
 		return -EINVAL;
 
-	if (local->hw.flags & IEEE80211_HW_REPORTS_TX_ACK_STATUS)
-		tx_flags = IEEE80211_TX_CTL_REQ_TX_STATUS |
-			   IEEE80211_TX_INTFL_MLME_CONN_TX;
-
 	auth_data->tries++;
 
 	if (auth_data->tries > IEEE80211_AUTH_MAX_TRIES) {
@@ -3219,6 +3215,10 @@ static int ieee80211_probe_auth(struct ieee80211_sub_if_data *sdata)
 			auth_data->expected_transaction = trans;
 		}
 
+		if (local->hw.flags & IEEE80211_HW_REPORTS_TX_ACK_STATUS)
+			tx_flags = IEEE80211_TX_CTL_REQ_TX_STATUS |
+				   IEEE80211_TX_INTFL_MLME_CONN_TX;
+
 		ieee80211_send_auth(sdata, trans, auth_data->algorithm, status,
 				    auth_data->data, auth_data->data_len,
 				    auth_data->bss->bssid,
@@ -3242,12 +3242,12 @@ static int ieee80211_probe_auth(struct ieee80211_sub_if_data *sdata)
 		 * will not answer to direct packet in unassociated state.
 		 */
 		ieee80211_send_probe_req(sdata, NULL, ssidie + 2, ssidie[1],
-					 NULL, 0, (u32) -1, true, tx_flags,
+					 NULL, 0, (u32) -1, true, 0,
 					 auth_data->bss->channel, false);
 		rcu_read_unlock();
 	}
 
-	if (!(local->hw.flags & IEEE80211_HW_REPORTS_TX_ACK_STATUS)) {
+	if (tx_flags == 0) {
 		auth_data->timeout = jiffies + IEEE80211_AUTH_TIMEOUT;
 		ifmgd->auth_data->timeout_started = true;
 		run_again(ifmgd, auth_data->timeout);
-- 
1.7.4.4

