Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([144.76.43.62]:43406 "EHLO
        sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726909AbeIEQED (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 5 Sep 2018 12:04:03 -0400
From: Johannes Berg <johannes@sipsolutions.net>
To: linux-wireless@vger.kernel.org
Cc: =?UTF-8?q?Toke=20H=C3=B8iland-J=C3=B8rgensen?= <toke@toke.dk>,
        Felix Fietkau <nbd@nbd.name>,
        Johannes Berg <johannes.berg@intel.com>
Subject: [PATCH] mac80211: TDLS: fix skb queue/priority assignment
Date: Wed,  5 Sep 2018 13:34:02 +0200
Message-Id: <20180905113402.7665-1-johannes@sipsolutions.net> (sfid-20180905_133416_297971_AFC86F42)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Johannes Berg <johannes.berg@intel.com>

If the TDLS setup happens over a connection to an AP that
doesn't have QoS, we nevertheless assign a non-zero TID
(skb->priority) and queue mapping, which may confuse us or
drivers later.

Fix it by just assigning the special skb->priority and then
using ieee80211_select_queue() just like other data frames
would go through.

Signed-off-by: Johannes Berg <johannes.berg@intel.com>
---
OK, this addresses the case I was worried about - perhaps
better take this than the txq patch?
---
 net/mac80211/tdls.c | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/net/mac80211/tdls.c b/net/mac80211/tdls.c
index 5cd5e6e5834e..6c647f425e05 100644
--- a/net/mac80211/tdls.c
+++ b/net/mac80211/tdls.c
@@ -16,6 +16,7 @@
 #include "ieee80211_i.h"
 #include "driver-ops.h"
 #include "rate.h"
+#include "wme.h"
 
 /* give usermode some time for retries in setting up the TDLS session */
 #define TDLS_PEER_SETUP_TIMEOUT	(15 * HZ)
@@ -1010,14 +1011,13 @@ ieee80211_tdls_prep_mgmt_packet(struct wiphy *wiphy, struct net_device *dev,
 	switch (action_code) {
 	case WLAN_TDLS_SETUP_REQUEST:
 	case WLAN_TDLS_SETUP_RESPONSE:
-		skb_set_queue_mapping(skb, IEEE80211_AC_BK);
-		skb->priority = 2;
+		skb->priority = 256 + 2;
 		break;
 	default:
-		skb_set_queue_mapping(skb, IEEE80211_AC_VI);
-		skb->priority = 5;
+		skb->priority = 256 + 5;
 		break;
 	}
+	skb_set_queue_mapping(skb, ieee80211_select_queue(sdata, skb));
 
 	/*
 	 * Set the WLAN_TDLS_TEARDOWN flag to indicate a teardown in progress.
-- 
2.14.4
