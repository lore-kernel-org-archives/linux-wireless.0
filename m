Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wi0-f169.google.com ([209.85.212.169]:34247 "EHLO
	mail-wi0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750755AbbEGMaq (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 7 May 2015 08:30:46 -0400
Received: by wicmx19 with SMTP id mx19so12698091wic.1
        for <linux-wireless@vger.kernel.org>; Thu, 07 May 2015 05:30:45 -0700 (PDT)
From: Arik Nemtsov <arik@wizery.com>
To: <linux-wireless@vger.kernel.org>
Cc: Johannes Berg <johannes@sipsolutions.net>
Subject: [PATCH] mac80211: TDLS: use the BSS chandef for HT/VHT operation IEs
Date: Thu,  7 May 2015 15:30:41 +0300
Message-Id: <1431001841-1876-1-git-send-email-arik@wizery.com> (sfid-20150507_143050_290151_90BEE24E)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

The chandef of the current channel context might be wider (though
compatible). The TDLS link cares only about the channel of the BSS.

In addition make sure to specify the VHT operation IE when VHT is supported
on a non-2.4GHz band, as required by IEEE802.11ac-2013. This is not the
same as HT-operation, to be specified only if the BSS doesn't support HT.

Signed-off-by: Arik Nemtsov <arikx.nemtsov@intel.com>
Reviewed-by: Johannes Berg <johannes.berg@intel.com>
---
 net/mac80211/tdls.c | 27 ++++++++-------------------
 1 file changed, 8 insertions(+), 19 deletions(-)

diff --git a/net/mac80211/tdls.c b/net/mac80211/tdls.c
index fff0d86..8a92a92 100644
--- a/net/mac80211/tdls.c
+++ b/net/mac80211/tdls.c
@@ -527,30 +527,19 @@ ieee80211_tdls_add_setup_cfm_ies(struct ieee80211_sub_if_data *sdata,
 
 	/* if HT support is only added in TDLS, we need an HT-operation IE */
 	if (!ap_sta->sta.ht_cap.ht_supported && sta->sta.ht_cap.ht_supported) {
-		struct ieee80211_chanctx_conf *chanctx_conf =
-				rcu_dereference(sdata->vif.chanctx_conf);
-		if (!WARN_ON(!chanctx_conf)) {
-			pos = skb_put(skb, 2 +
-				      sizeof(struct ieee80211_ht_operation));
-			/* send an empty HT operation IE */
-			ieee80211_ie_build_ht_oper(pos, &sta->sta.ht_cap,
-						   &chanctx_conf->def, 0);
-		}
+		pos = skb_put(skb, 2 + sizeof(struct ieee80211_ht_operation));
+		/* send an empty HT operation IE */
+		ieee80211_ie_build_ht_oper(pos, &sta->sta.ht_cap,
+					   &sdata->vif.bss_conf.chandef, 0);
 	}
 
 	ieee80211_tdls_add_link_ie(sdata, skb, peer, initiator);
 
 	/* only include VHT-operation if not on the 2.4GHz band */
-	if (band != IEEE80211_BAND_2GHZ && !ap_sta->sta.vht_cap.vht_supported &&
-	    sta->sta.vht_cap.vht_supported) {
-		struct ieee80211_chanctx_conf *chanctx_conf =
-				rcu_dereference(sdata->vif.chanctx_conf);
-		if (!WARN_ON(!chanctx_conf)) {
-			pos = skb_put(skb, 2 +
-				      sizeof(struct ieee80211_vht_operation));
-			ieee80211_ie_build_vht_oper(pos, &sta->sta.vht_cap,
-						    &chanctx_conf->def);
-		}
+	if (band != IEEE80211_BAND_2GHZ && sta->sta.vht_cap.vht_supported) {
+		pos = skb_put(skb, 2 + sizeof(struct ieee80211_vht_operation));
+		ieee80211_ie_build_vht_oper(pos, &sta->sta.vht_cap,
+					    &sdata->vif.bss_conf.chandef);
 	}
 
 	rcu_read_unlock();
-- 
2.1.0

