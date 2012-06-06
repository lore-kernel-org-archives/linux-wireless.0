Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:51865 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751231Ab2FFGFf (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 6 Jun 2012 02:05:35 -0400
Message-ID: <1338962733.4513.1.camel@jlt3.sipsolutions.net> (sfid-20120606_080537_688792_3D2E4BE4)
Subject: [PATCH] mac80211: print info when disabling HT
From: Johannes Berg <johannes@sipsolutions.net>
To: John Linville <linville@tuxdriver.com>
Cc: linux-wireless <linux-wireless@vger.kernel.org>
Date: Wed, 06 Jun 2012 08:05:33 +0200
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
Did this slip through? :-)

 net/mac80211/mlme.c |   13 ++++++++++---
 1 file changed, 10 insertions(+), 3 deletions(-)

diff --git a/net/mac80211/mlme.c b/net/mac80211/mlme.c
index 7c07715..9c0fac0 100644
--- a/net/mac80211/mlme.c
+++ b/net/mac80211/mlme.c
@@ -3299,11 +3299,15 @@ int ieee80211_mgd_assoc(struct ieee80211_sub_if_data *sdata,
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
@@ -3311,8 +3315,11 @@ int ieee80211_mgd_assoc(struct ieee80211_sub_if_data *sdata,
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
-- 
1.7.10



