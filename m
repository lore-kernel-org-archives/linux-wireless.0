Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:44781 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754691Ab2E3N6R (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 30 May 2012 09:58:17 -0400
Message-ID: <1338386220.4511.23.camel@jlt3.sipsolutions.net> (sfid-20120530_163649_494529_D9680C94)
Subject: [PATCH v2] mac80211: print info when disabling HT
From: Johannes Berg <johannes@sipsolutions.net>
To: John Linville <linville@tuxdriver.com>
Cc: linux-wireless <linux-wireless@vger.kernel.org>
Date: Wed, 30 May 2012 15:57:00 +0200
In-Reply-To: <1338379000.4511.12.camel@jlt3.sipsolutions.net> (sfid-20120530_135647_769633_35D284ED)
References: <1338379000.4511.12.camel@jlt3.sipsolutions.net>
	 (sfid-20120530_135647_769633_35D284ED)
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Johannes Berg <johannes.berg@intel.com>

Make mac80211 print a message when it disables
HT due to the connection using WEP/TKIP or due
to the AP not supporting WMM/QoS.

Signed-off-by: Johannes Berg <johannes.berg@intel.com>
---
v2: use netdev_info

 net/mac80211/mlme.c |   13 ++++++++++---
 1 file changed, 10 insertions(+), 3 deletions(-)

--- a/net/mac80211/mlme.c	2012-05-30 15:52:37.000000000 +0200
+++ b/net/mac80211/mlme.c	2012-05-30 15:52:59.000000000 +0200
@@ -3317,11 +3317,15 @@ int ieee80211_mgd_assoc(struct ieee80211
 	 * We can set this to true for non-11n hardware, that'll be checked
 	 * separately along with the peer capabilities.
 	 */
-	for (i = 0; i < req->crypto.n_ciphers_pairwise; i++)
+	for (i = 0; i < req->crypto.n_ciphers_pairwise; i++) {
 		if (req->crypto.ciphers_pairwise[i] == WLAN_CIPHER_SUITE_WEP40 ||
 		    req->crypto.ciphers_pairwise[i] == WLAN_CIPHER_SUITE_TKIP ||
-		    req->crypto.ciphers_pairwise[i] == WLAN_CIPHER_SUITE_WEP104)
+		    req->crypto.ciphers_pairwise[i] == WLAN_CIPHER_SUITE_WEP104) {
 			ifmgd->flags |= IEEE80211_STA_DISABLE_11N;
+			netdev_info(sdata->dev,
+				    "disabling HT due to WEP/TKIP use\n");
+		}
+	}
 
 	if (req->flags & ASSOC_REQ_DISABLE_HT)
 		ifmgd->flags |= IEEE80211_STA_DISABLE_11N;
@@ -3329,8 +3333,11 @@ int ieee80211_mgd_assoc(struct ieee80211
 	/* Also disable HT if we don't support it or the AP doesn't use WMM */
 	sband = local->hw.wiphy->bands[req->bss->channel->band];
 	if (!sband->ht_cap.ht_supported ||
-	    local->hw.queues < IEEE80211_NUM_ACS || !bss->wmm_used)
+	    local->hw.queues < IEEE80211_NUM_ACS || !bss->wmm_used) {
 		ifmgd->flags |= IEEE80211_STA_DISABLE_11N;
+		netdev_info(sdata->dev,
+			    "disabling HT as WMM/QoS is not supported\n");
+	}
 
 	memcpy(&ifmgd->ht_capa, &req->ht_capa, sizeof(ifmgd->ht_capa));
 	memcpy(&ifmgd->ht_capa_mask, &req->ht_capa_mask,


