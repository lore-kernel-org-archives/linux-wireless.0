Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:46287 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750742Ab2GZHG2 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 26 Jul 2012 03:06:28 -0400
From: Johannes Berg <johannes@sipsolutions.net>
To: linux-wireless@vger.kernel.org
Cc: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
Subject: [PATCH] mac80211: don't call mgd_prepare_tx when associated
Date: Thu, 26 Jul 2012 09:06:22 +0200
Message-Id: <1343286382-7239-1-git-send-email-johannes@sipsolutions.net> (sfid-20120726_090631_430791_F104D5CE)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Emmanuel Grumbach <emmanuel.grumbach@intel.com>

This doesn't make any sense since we are expected to be on
the medium or at least to Tx only when we are on the right
channel and the AP/GO can hear us.

Move the call to mgd_prepare_tx() for deauth to be only
done in case we're sending a deauth while not associated.

Signed-off-by: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
Signed-off-by: Johannes Berg <johannes.berg@intel.com>
---
 net/mac80211/mlme.c |    9 +++++----
 1 file changed, 5 insertions(+), 4 deletions(-)

diff --git a/net/mac80211/mlme.c b/net/mac80211/mlme.c
index 81b2269..f0d6fa2 100644
--- a/net/mac80211/mlme.c
+++ b/net/mac80211/mlme.c
@@ -610,8 +610,6 @@ static void ieee80211_send_deauth_disassoc(struct ieee80211_sub_if_data *sdata,
 			IEEE80211_SKB_CB(skb)->flags |=
 				IEEE80211_TX_INTFL_DONT_ENCRYPT;
 
-		drv_mgd_prepare_tx(local, sdata);
-
 		ieee80211_tx_skb(sdata, skb);
 	}
 }
@@ -3504,14 +3502,17 @@ int ieee80211_mgd_deauth(struct ieee80211_sub_if_data *sdata,
 		   req->bssid, req->reason_code);
 
 	if (ifmgd->associated &&
-	    ether_addr_equal(ifmgd->associated->bssid, req->bssid))
+	    ether_addr_equal(ifmgd->associated->bssid, req->bssid)) {
 		ieee80211_set_disassoc(sdata, IEEE80211_STYPE_DEAUTH,
 				       req->reason_code, true, frame_buf);
-	else
+	} else {
+		drv_mgd_prepare_tx(sdata->local, sdata);
 		ieee80211_send_deauth_disassoc(sdata, req->bssid,
 					       IEEE80211_STYPE_DEAUTH,
 					       req->reason_code, true,
 					       frame_buf);
+	}
+
 	mutex_unlock(&ifmgd->mtx);
 
 	__cfg80211_send_deauth(sdata->dev, frame_buf, DEAUTH_DISASSOC_LEN);
-- 
1.7.10.4

