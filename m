Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:49606 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751529Ab1JVRF4 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 22 Oct 2011 13:05:56 -0400
Subject: [PATCH] nl80211: clean up genlmsg_end uses
From: Johannes Berg <johannes@sipsolutions.net>
To: John Linville <linville@tuxdriver.com>
Cc: linux-wireless <linux-wireless@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Date: Sat, 22 Oct 2011 19:05:51 +0200
Message-ID: <1319303151.3956.10.camel@jlt3.sipsolutions.net> (sfid-20111022_190603_275319_CE03B376)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Johannes Berg <johannes.berg@intel.com>

genlmsg_end() cannot fail, it just returns the length
of the message. Thus, error handling for it is useless.
While removing it, I also noticed a useless variable
and removed this it as well.

Signed-off-by: Johannes Berg <johannes.berg@intel.com>
---
 net/wireless/nl80211.c |   97 +++++++++----------------------------------------
 1 file changed, 19 insertions(+), 78 deletions(-)

--- a/net/wireless/nl80211.c	2011-10-22 19:00:10.000000000 +0200
+++ b/net/wireless/nl80211.c	2011-10-22 19:03:05.000000000 +0200
@@ -6634,10 +6634,7 @@ void nl80211_send_reg_change_event(struc
 	if (wiphy_idx_valid(request->wiphy_idx))
 		NLA_PUT_U32(msg, NL80211_ATTR_WIPHY, request->wiphy_idx);
 
-	if (genlmsg_end(msg, hdr) < 0) {
-		nlmsg_free(msg);
-		return;
-	}
+	genlmsg_end(msg, hdr);
 
 	rcu_read_lock();
 	genlmsg_multicast_allns(msg, 0, nl80211_regulatory_mcgrp.id,
@@ -6673,10 +6670,7 @@ static void nl80211_send_mlme_event(stru
 	NLA_PUT_U32(msg, NL80211_ATTR_IFINDEX, netdev->ifindex);
 	NLA_PUT(msg, NL80211_ATTR_FRAME, len, buf);
 
-	if (genlmsg_end(msg, hdr) < 0) {
-		nlmsg_free(msg);
-		return;
-	}
+	genlmsg_end(msg, hdr);
 
 	genlmsg_multicast_netns(wiphy_net(&rdev->wiphy), msg, 0,
 				nl80211_mlme_mcgrp.id, gfp);
@@ -6757,10 +6751,7 @@ static void nl80211_send_mlme_timeout(st
 	NLA_PUT_FLAG(msg, NL80211_ATTR_TIMED_OUT);
 	NLA_PUT(msg, NL80211_ATTR_MAC, ETH_ALEN, addr);
 
-	if (genlmsg_end(msg, hdr) < 0) {
-		nlmsg_free(msg);
-		return;
-	}
+	genlmsg_end(msg, hdr);
 
 	genlmsg_multicast_netns(wiphy_net(&rdev->wiphy), msg, 0,
 				nl80211_mlme_mcgrp.id, gfp);
@@ -6816,10 +6807,7 @@ void nl80211_send_connect_result(struct
 	if (resp_ie)
 		NLA_PUT(msg, NL80211_ATTR_RESP_IE, resp_ie_len, resp_ie);
 
-	if (genlmsg_end(msg, hdr) < 0) {
-		nlmsg_free(msg);
-		return;
-	}
+	genlmsg_end(msg, hdr);
 
 	genlmsg_multicast_netns(wiphy_net(&rdev->wiphy), msg, 0,
 				nl80211_mlme_mcgrp.id, gfp);
@@ -6857,10 +6845,7 @@ void nl80211_send_roamed(struct cfg80211
 	if (resp_ie)
 		NLA_PUT(msg, NL80211_ATTR_RESP_IE, resp_ie_len, resp_ie);
 
-	if (genlmsg_end(msg, hdr) < 0) {
-		nlmsg_free(msg);
-		return;
-	}
+	genlmsg_end(msg, hdr);
 
 	genlmsg_multicast_netns(wiphy_net(&rdev->wiphy), msg, 0,
 				nl80211_mlme_mcgrp.id, gfp);
@@ -6898,10 +6883,7 @@ void nl80211_send_disconnected(struct cf
 	if (ie)
 		NLA_PUT(msg, NL80211_ATTR_IE, ie_len, ie);
 
-	if (genlmsg_end(msg, hdr) < 0) {
-		nlmsg_free(msg);
-		return;
-	}
+	genlmsg_end(msg, hdr);
 
 	genlmsg_multicast_netns(wiphy_net(&rdev->wiphy), msg, 0,
 				nl80211_mlme_mcgrp.id, GFP_KERNEL);
@@ -6934,10 +6916,7 @@ void nl80211_send_ibss_bssid(struct cfg8
 	NLA_PUT_U32(msg, NL80211_ATTR_IFINDEX, netdev->ifindex);
 	NLA_PUT(msg, NL80211_ATTR_MAC, ETH_ALEN, bssid);
 
-	if (genlmsg_end(msg, hdr) < 0) {
-		nlmsg_free(msg);
-		return;
-	}
+	genlmsg_end(msg, hdr);
 
 	genlmsg_multicast_netns(wiphy_net(&rdev->wiphy), msg, 0,
 				nl80211_mlme_mcgrp.id, gfp);
@@ -6972,10 +6951,7 @@ void nl80211_send_new_peer_candidate(str
 	if (ie_len && ie)
 		NLA_PUT(msg, NL80211_ATTR_IE, ie_len , ie);
 
-	if (genlmsg_end(msg, hdr) < 0) {
-		nlmsg_free(msg);
-		return;
-	}
+	genlmsg_end(msg, hdr);
 
 	genlmsg_multicast_netns(wiphy_net(&rdev->wiphy), msg, 0,
 				nl80211_mlme_mcgrp.id, gfp);
@@ -7014,10 +6990,7 @@ void nl80211_michael_mic_failure(struct
 	if (tsc)
 		NLA_PUT(msg, NL80211_ATTR_KEY_SEQ, 6, tsc);
 
-	if (genlmsg_end(msg, hdr) < 0) {
-		nlmsg_free(msg);
-		return;
-	}
+	genlmsg_end(msg, hdr);
 
 	genlmsg_multicast_netns(wiphy_net(&rdev->wiphy), msg, 0,
 				nl80211_mlme_mcgrp.id, gfp);
@@ -7068,10 +7041,7 @@ void nl80211_send_beacon_hint_event(stru
 		goto nla_put_failure;
 	nla_nest_end(msg, nl_freq);
 
-	if (genlmsg_end(msg, hdr) < 0) {
-		nlmsg_free(msg);
-		return;
-	}
+	genlmsg_end(msg, hdr);
 
 	rcu_read_lock();
 	genlmsg_multicast_allns(msg, 0, nl80211_regulatory_mcgrp.id,
@@ -7114,10 +7084,7 @@ static void nl80211_send_remain_on_chan_
 	if (cmd == NL80211_CMD_REMAIN_ON_CHANNEL)
 		NLA_PUT_U32(msg, NL80211_ATTR_DURATION, duration);
 
-	if (genlmsg_end(msg, hdr) < 0) {
-		nlmsg_free(msg);
-		return;
-	}
+	genlmsg_end(msg, hdr);
 
 	genlmsg_multicast_netns(wiphy_net(&rdev->wiphy), msg, 0,
 				nl80211_mlme_mcgrp.id, gfp);
@@ -7188,10 +7155,7 @@ void nl80211_send_sta_del_event(struct c
 	NLA_PUT_U32(msg, NL80211_ATTR_IFINDEX, dev->ifindex);
 	NLA_PUT(msg, NL80211_ATTR_MAC, ETH_ALEN, mac_addr);
 
-	if (genlmsg_end(msg, hdr) < 0) {
-		nlmsg_free(msg);
-		return;
-	}
+	genlmsg_end(msg, hdr);
 
 	genlmsg_multicast_netns(wiphy_net(&rdev->wiphy), msg, 0,
 				nl80211_mlme_mcgrp.id, gfp);
@@ -7208,7 +7172,6 @@ int nl80211_send_mgmt(struct cfg80211_re
 {
 	struct sk_buff *msg;
 	void *hdr;
-	int err;
 
 	msg = nlmsg_new(NLMSG_DEFAULT_SIZE, gfp);
 	if (!msg)
@@ -7225,16 +7188,9 @@ int nl80211_send_mgmt(struct cfg80211_re
 	NLA_PUT_U32(msg, NL80211_ATTR_WIPHY_FREQ, freq);
 	NLA_PUT(msg, NL80211_ATTR_FRAME, len, buf);
 
-	err = genlmsg_end(msg, hdr);
-	if (err < 0) {
-		nlmsg_free(msg);
-		return err;
-	}
+	genlmsg_end(msg, hdr);
 
-	err = genlmsg_unicast(wiphy_net(&rdev->wiphy), msg, nlpid);
-	if (err < 0)
-		return err;
-	return 0;
+	return genlmsg_unicast(wiphy_net(&rdev->wiphy), msg, nlpid);
 
  nla_put_failure:
 	genlmsg_cancel(msg, hdr);
@@ -7267,10 +7223,7 @@ void nl80211_send_mgmt_tx_status(struct
 	if (ack)
 		NLA_PUT_FLAG(msg, NL80211_ATTR_ACK);
 
-	if (genlmsg_end(msg, hdr) < 0) {
-		nlmsg_free(msg);
-		return;
-	}
+	genlmsg_end(msg, hdr);
 
 	genlmsg_multicast(msg, 0, nl80211_mlme_mcgrp.id, gfp);
 	return;
@@ -7312,10 +7265,7 @@ nl80211_send_cqm_rssi_notify(struct cfg8
 
 	nla_nest_end(msg, pinfoattr);
 
-	if (genlmsg_end(msg, hdr) < 0) {
-		nlmsg_free(msg);
-		return;
-	}
+	genlmsg_end(msg, hdr);
 
 	genlmsg_multicast_netns(wiphy_net(&rdev->wiphy), msg, 0,
 				nl80211_mlme_mcgrp.id, gfp);
@@ -7357,10 +7307,7 @@ void nl80211_gtk_rekey_notify(struct cfg
 
 	nla_nest_end(msg, rekey_attr);
 
-	if (genlmsg_end(msg, hdr) < 0) {
-		nlmsg_free(msg);
-		return;
-	}
+	genlmsg_end(msg, hdr);
 
 	genlmsg_multicast_netns(wiphy_net(&rdev->wiphy), msg, 0,
 				nl80211_mlme_mcgrp.id, gfp);
@@ -7403,10 +7350,7 @@ void nl80211_pmksa_candidate_notify(stru
 
 	nla_nest_end(msg, attr);
 
-	if (genlmsg_end(msg, hdr) < 0) {
-		nlmsg_free(msg);
-		return;
-	}
+	genlmsg_end(msg, hdr);
 
 	genlmsg_multicast_netns(wiphy_net(&rdev->wiphy), msg, 0,
 				nl80211_mlme_mcgrp.id, gfp);
@@ -7448,10 +7392,7 @@ nl80211_send_cqm_pktloss_notify(struct c
 
 	nla_nest_end(msg, pinfoattr);
 
-	if (genlmsg_end(msg, hdr) < 0) {
-		nlmsg_free(msg);
-		return;
-	}
+	genlmsg_end(msg, hdr);
 
 	genlmsg_multicast_netns(wiphy_net(&rdev->wiphy), msg, 0,
 				nl80211_mlme_mcgrp.id, gfp);


