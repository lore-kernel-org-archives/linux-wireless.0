Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pa0-f49.google.com ([209.85.220.49]:44396 "EHLO
	mail-pa0-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754220Ab3G3BsT (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 29 Jul 2013 21:48:19 -0400
Received: by mail-pa0-f49.google.com with SMTP id bi5so6562649pad.22
        for <linux-wireless@vger.kernel.org>; Mon, 29 Jul 2013 18:48:19 -0700 (PDT)
From: Chun-Yeow Yeoh <yeohchunyeow@cozybit.com>
To: linux-wireless@vger.kernel.org
Cc: johannes@sipsolutions.net, linville@tuxdriver.com,
	devel@lists.open80211s.org,
	Chun-Yeow Yeoh <yeohchunyeow@cozybit.com>
Subject: [PATCH] mac80211: allow lowest basic rate for unicast management frame in mesh
Date: Mon, 29 Jul 2013 18:48:12 -0700
Message-Id: <1375148892-18121-1-git-send-email-yeohchunyeow@cozybit.com> (sfid-20130730_034823_046616_309CE6A3)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Allow lowest basic rate to be used for unicast management frame in
mesh. Otherwise, the lowest supported rate is used for unicast
management frame, such as 1Mbps for 2.4GHz and 6Mbps for 5GHz. Rename
the rc_send_low_broadcast to re_send_low_basicrate since now it is
also applied to unicast management frame in mesh.

Signed-off-by: Chun-Yeow Yeoh <yeohchunyeow@cozybit.com>
---
 net/mac80211/rate.c |   11 +++++++++--
 1 file changed, 9 insertions(+), 2 deletions(-)

diff --git a/net/mac80211/rate.c b/net/mac80211/rate.c
index ba63ac8..8038d47 100644
--- a/net/mac80211/rate.c
+++ b/net/mac80211/rate.c
@@ -210,7 +210,7 @@ static bool rc_no_data_or_no_ack_use_min(struct ieee80211_tx_rate_control *txrc)
 		!ieee80211_is_data(fc);
 }
 
-static void rc_send_low_broadcast(s8 *idx, u32 basic_rates,
+static void rc_send_low_basicrate(s8 *idx, u32 basic_rates,
 				  struct ieee80211_supported_band *sband)
 {
 	u8 i;
@@ -269,6 +269,7 @@ bool rate_control_send_low(struct ieee80211_sta *sta,
 {
 	struct ieee80211_tx_info *info = IEEE80211_SKB_CB(txrc->skb);
 	struct ieee80211_supported_band *sband = txrc->sband;
+	struct sta_info *sta_mesh = container_of(sta, struct sta_info, sta);
 	int mcast_rate;
 
 	if (!sta || !priv_sta || rc_no_data_or_no_ack_use_min(txrc)) {
@@ -281,10 +282,16 @@ bool rate_control_send_low(struct ieee80211_sta *sta,
 				return true;
 			}
 
-			rc_send_low_broadcast(&info->control.rates[0].idx,
+			rc_send_low_basicrate(&info->control.rates[0].idx,
 					      txrc->bss_conf->basic_rates,
 					      sband);
 		}
+
+		if (sta && ieee80211_vif_is_mesh(&sta_mesh->sdata->vif))
+			rc_send_low_basicrate(&info->control.rates[0].idx,
+					      txrc->bss_conf->basic_rates,
+					      sband);
+
 		return true;
 	}
 	return false;
-- 
1.7.9.5

