Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pf0-f193.google.com ([209.85.192.193]:33624 "EHLO
	mail-pf0-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751728AbcHBJL6 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 2 Aug 2016 05:11:58 -0400
Received: by mail-pf0-f193.google.com with SMTP id i6so12081047pfe.0
        for <linux-wireless@vger.kernel.org>; Tue, 02 Aug 2016 02:11:21 -0700 (PDT)
From: Masashi Honma <masashi.honma@gmail.com>
To: johannes@sipsolutions.net
Cc: linux-wireless@vger.kernel.org, j@w1.fi, me@bobcopeland.com,
	Masashi Honma <masashi.honma@gmail.com>
Subject: [PATCH v2] mac80211: End the MPSP even if EOSP frame was not acked
Date: Tue,  2 Aug 2016 17:16:57 +0900
Message-Id: <1470125817-4461-1-git-send-email-masashi.honma@gmail.com> (sfid-20160802_111500_426701_C48E3DA7)
In-Reply-To: <1468393475-2483-1-git-send-email-masashi.honma@gmail.com>
References: <1468393475-2483-1-git-send-email-masashi.honma@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

If QoS frame with EOSP (end of service period) subfield=1 sent by local
peer was not acked by remote peer, local peer did not end the MPSP. This
prevents local peer from going to DOZE state. And if the remote peer
goes away without closing connection, local peer continues AWAKE state
and wastes battery.

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

