Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([5.9.151.49]:34376 "EHLO sipsolutions.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751120AbcIMGaA (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 13 Sep 2016 02:30:00 -0400
From: Johannes Berg <johannes@sipsolutions.net>
To: linux-wireless@vger.kernel.org
Cc: Johannes Berg <johannes.berg@intel.com>
Subject: [PATCH] mac80211: simplify TDLS RA lookup
Date: Tue, 13 Sep 2016 08:29:55 +0200
Message-Id: <1473748195-17453-1-git-send-email-johannes@sipsolutions.net> (sfid-20160913_083004_106195_6FCBA445)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Johannes Berg <johannes.berg@intel.com>

smatch pointed out that the second check of "tdls_auth" was
pointless since if it was true, we returned from the function
already. We can further simplify the code by moving the first
check (if it's a TDLS peer at all) into the outer if, to only
handle that inside. This simplifies the control flow here.

Signed-off-by: Johannes Berg <johannes.berg@intel.com>
---
 net/mac80211/tx.c | 15 ++++-----------
 1 file changed, 4 insertions(+), 11 deletions(-)

diff --git a/net/mac80211/tx.c b/net/mac80211/tx.c
index ee9e7d60cb78..61d302d97145 100644
--- a/net/mac80211/tx.c
+++ b/net/mac80211/tx.c
@@ -2263,15 +2263,9 @@ static int ieee80211_lookup_ra_sta(struct ieee80211_sub_if_data *sdata,
 	case NL80211_IFTYPE_STATION:
 		if (sdata->wdev.wiphy->flags & WIPHY_FLAG_SUPPORTS_TDLS) {
 			sta = sta_info_get(sdata, skb->data);
-			if (sta) {
-				bool tdls_peer, tdls_auth;
-
-				tdls_peer = test_sta_flag(sta,
-							  WLAN_STA_TDLS_PEER);
-				tdls_auth = test_sta_flag(sta,
-						WLAN_STA_TDLS_PEER_AUTH);
-
-				if (tdls_peer && tdls_auth) {
+			if (sta && test_sta_flag(sta, WLAN_STA_TDLS_PEER)) {
+				if (test_sta_flag(sta,
+						  WLAN_STA_TDLS_PEER_AUTH)) {
 					*sta_out = sta;
 					return 0;
 				}
@@ -2283,8 +2277,7 @@ static int ieee80211_lookup_ra_sta(struct ieee80211_sub_if_data *sdata,
 				 * after a TDLS sta is removed due to being
 				 * unreachable.
 				 */
-				if (tdls_peer && !tdls_auth &&
-				    !ieee80211_is_tdls_setup(skb))
+				if (!ieee80211_is_tdls_setup(skb))
 					return -EINVAL;
 			}
 
-- 
2.8.1
