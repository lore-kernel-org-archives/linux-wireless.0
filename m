Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from hermes4.cs.kuleuven.be ([134.58.40.3]:49030 "EHLO
        hermes4.cs.kuleuven.be" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1733014AbeHGBID (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 6 Aug 2018 21:08:03 -0400
Received: from hermes4.cs.kuleuven.be. (localhost [127.0.0.1])
        by hermes4.cs.kuleuven.be.  with ESMTP id w76Mm1ZQ007498
        for <linux-wireless@vger.kernel.org>; Tue, 7 Aug 2018 00:48:01 +0200
Received: (from defang@localhost)
        by hermes4.cs.kuleuven.be. (8.14.4/8.14.4/Submit) id w76MkCOT007434
        for <linux-wireless@vger.kernel.org>; Tue, 7 Aug 2018 00:46:12 +0200
From: Mathy Vanhoef <Mathy.Vanhoef@cs.kuleuven.be>
To: johannes@sipsolutions.net, linux-wireless@vger.kernel.org
Cc: Mathy Vanhoef <Mathy.Vanhoef@cs.kuleuven.be>
Subject: [PATCH] mac80211: ignore SA Query Requests with unknown payload data
Date: Tue,  7 Aug 2018 00:48:57 +0200
Message-Id: <20180806224857.14853-1-Mathy.Vanhoef@cs.kuleuven.be> (sfid-20180807_005648_499149_2A57E2F9)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

When operating in station mode, ignore SA Query Request frames that
contain extra payload data. The kernel doesn't know how to handle these
frames. Instead, give userspace a chance to handle these frames.

For example, with Operating Channel Validation, SA Query Requests may
now contain an extra Operating Channel Information (OCI) element as
payload data. The kernel should ignore these frames, since it does not
know how to properly handle them. Instead, let userspace process these
frames.

Signed-off-by: Mathy Vanhoef <Mathy.Vanhoef@cs.kuleuven.be>
---
For background on Operating Channel Validation, see:
https://mentor.ieee.org/802.11/dcn/17/11-17-1807-12-000m-defense-against-multi-channel-mitm-attacks-via-operating-channel-validation.docx

A corresponding patchset was also recently submitted to Hostap, see "Add
support for Operating Channel Validation (OCV)".


 net/mac80211/rx.c | 18 ++++++++++--------
 1 file changed, 10 insertions(+), 8 deletions(-)

diff --git a/net/mac80211/rx.c b/net/mac80211/rx.c
index 932985ca4e66..9a4fb17bada7 100644
--- a/net/mac80211/rx.c
+++ b/net/mac80211/rx.c
@@ -2755,7 +2755,7 @@ ieee80211_rx_h_ctrl(struct ieee80211_rx_data *rx, struct sk_buff_head *frames)
 	return RX_DROP_MONITOR;
 }
 
-static void ieee80211_process_sa_query_req(struct ieee80211_sub_if_data *sdata,
+static bool ieee80211_process_sa_query_req(struct ieee80211_sub_if_data *sdata,
 					   struct ieee80211_mgmt *mgmt,
 					   size_t len)
 {
@@ -2765,23 +2765,23 @@ static void ieee80211_process_sa_query_req(struct ieee80211_sub_if_data *sdata,
 
 	if (!ether_addr_equal(mgmt->da, sdata->vif.addr)) {
 		/* Not to own unicast address */
-		return;
+		return false;
 	}
 
 	if (!ether_addr_equal(mgmt->sa, sdata->u.mgd.bssid) ||
 	    !ether_addr_equal(mgmt->bssid, sdata->u.mgd.bssid)) {
 		/* Not from the current AP or not associated yet. */
-		return;
+		return false;
 	}
 
-	if (len < 24 + 1 + sizeof(resp->u.action.u.sa_query)) {
-		/* Too short SA Query request frame */
-		return;
+	if (len != 24 + 1 + sizeof(resp->u.action.u.sa_query)) {
+		/* Too short SA Query request frame, or one we can't handle */
+		return false;
 	}
 
 	skb = dev_alloc_skb(sizeof(*resp) + local->hw.extra_tx_headroom);
 	if (skb == NULL)
-		return;
+		return false;
 
 	skb_reserve(skb, local->hw.extra_tx_headroom);
 	resp = skb_put_zero(skb, 24);
@@ -2798,6 +2798,7 @@ static void ieee80211_process_sa_query_req(struct ieee80211_sub_if_data *sdata,
 	       WLAN_SA_QUERY_TR_ID_LEN);
 
 	ieee80211_tx_skb(sdata, skb);
+	return true;
 }
 
 static ieee80211_rx_result debug_noinline
@@ -3089,7 +3090,8 @@ ieee80211_rx_h_action(struct ieee80211_rx_data *rx)
 		case WLAN_ACTION_SA_QUERY_REQUEST:
 			if (sdata->vif.type != NL80211_IFTYPE_STATION)
 				break;
-			ieee80211_process_sa_query_req(sdata, mgmt, len);
+			if (!ieee80211_process_sa_query_req(sdata, mgmt, len))
+				break;
 			goto handled;
 		}
 		break;
-- 
2.18.0
