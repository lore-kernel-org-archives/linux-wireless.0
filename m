Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pa0-f68.google.com ([209.85.220.68]:34082 "EHLO
	mail-pa0-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751161AbcGMHE5 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 13 Jul 2016 03:04:57 -0400
Received: by mail-pa0-f68.google.com with SMTP id hh10so2493781pac.1
        for <linux-wireless@vger.kernel.org>; Wed, 13 Jul 2016 00:04:52 -0700 (PDT)
From: Masashi Honma <masashi.honma@gmail.com>
To: johannes@sipsolutions.net
Cc: linux-wireless@vger.kernel.org, j@w1.fi, me@bobcopeland.com,
	Masashi Honma <masashi.honma@gmail.com>
Subject: [PATCH] mac80211: End the MPSP even if EOSP frame was not received
Date: Wed, 13 Jul 2016 16:04:35 +0900
Message-Id: <1468393475-2483-1-git-send-email-masashi.honma@gmail.com> (sfid-20160713_090545_520409_1BDFAD48)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

The mesh STA sends QoS frame with EOSP (end of service period)
subfiled=1 to end the MPSP(mesh peer service period). Previously, if
the frame was not acked by peer, the mesh STA did not end the MPSP.
This patch ends the MPSP even if the QoS frame was no acked.

Signed-off-by: Masashi Honma <masashi.honma@gmail.com>
---
 net/mac80211/status.c | 14 +++++++-------
 1 file changed, 7 insertions(+), 7 deletions(-)

diff --git a/net/mac80211/status.c b/net/mac80211/status.c
index c6d5c72..a2a6826 100644
--- a/net/mac80211/status.c
+++ b/net/mac80211/status.c
@@ -771,6 +771,13 @@ void ieee80211_tx_status(struct ieee80211_hw *hw, struct sk_buff *skb)
 			clear_sta_flag(sta, WLAN_STA_SP);
 
 		acked = !!(info->flags & IEEE80211_TX_STAT_ACK);
+
+		/* mesh Peer Service Period support */
+		if (ieee80211_vif_is_mesh(&sta->sdata->vif) &&
+		    ieee80211_is_data_qos(fc))
+			ieee80211_mpsp_trigger_process(
+				ieee80211_get_qos_ctl(hdr), sta, true, acked);
+
 		if (!acked && test_sta_flag(sta, WLAN_STA_PS_STA)) {
 			/*
 			 * The STA is in power save mode, so assume
@@ -781,13 +788,6 @@ void ieee80211_tx_status(struct ieee80211_hw *hw, struct sk_buff *skb)
 			return;
 		}
 
-		/* mesh Peer Service Period support */
-		if (ieee80211_vif_is_mesh(&sta->sdata->vif) &&
-		    ieee80211_is_data_qos(fc))
-			ieee80211_mpsp_trigger_process(
-					ieee80211_get_qos_ctl(hdr),
-					sta, true, acked);
-
 		if (ieee80211_hw_check(&local->hw, HAS_RATE_CONTROL) &&
 		    (ieee80211_is_data(hdr->frame_control)) &&
 		    (rates_idx != -1))
-- 
2.7.4

