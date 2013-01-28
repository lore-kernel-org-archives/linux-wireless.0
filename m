Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:6444 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754287Ab3A1Nmf (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 28 Jan 2013 08:42:35 -0500
From: Stanislaw Gruszka <sgruszka@redhat.com>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: linux-wireless@vger.kernel.org,
	Stanislaw Gruszka <sgruszka@redhat.com>
Subject: [PATCH] mac80211: remove IEEE80211_HW_TEARDOWN_AGGR_ON_BAR_FAIL
Date: Mon, 28 Jan 2013 14:42:30 +0100
Message-Id: <1359380550-7798-1-git-send-email-sgruszka@redhat.com> (sfid-20130128_144239_711444_4033B184)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This is basically a revert of:

commit 5b632fe85ec82e5c43740b52e74c66df50a37db3
Author: Stanislaw Gruszka <sgruszka@redhat.com>
Date:   Mon Dec 3 12:56:33 2012 +0100

    mac80211: introduce IEEE80211_HW_TEARDOWN_AGGR_ON_BAR_FAIL

We do not need this flag any longer, rt2x00 BAR/BA problem was fixed
correctly by wireless-testing commit:

commit 84e9e8ebd369679a958200a8baca96aafb2393bb
Author: Helmut Schaa <helmut.schaa@googlemail.com>
Date:   Thu Jan 17 17:34:32 2013 +0100

    rt2x00: Improve TX status handling for BlockAckReq frames

Signed-off-by: Stanislaw Gruszka <sgruszka@redhat.com>
---
 include/net/mac80211.h |    5 -----
 net/mac80211/status.c  |    6 +-----
 2 files changed, 1 insertions(+), 10 deletions(-)

diff --git a/include/net/mac80211.h b/include/net/mac80211.h
index 3037f49..6cc805c 100644
--- a/include/net/mac80211.h
+++ b/include/net/mac80211.h
@@ -1369,10 +1369,6 @@ struct ieee80211_tx_control {
  * @IEEE80211_HW_P2P_DEV_ADDR_FOR_INTF: Use the P2P Device address for any
  *	P2P Interface. This will be honoured even if more than one interface
  *	is supported.
- *
- * @IEEE80211_HW_TEARDOWN_AGGR_ON_BAR_FAIL: On this hardware TX BA session
- *	should be tear down once BAR frame will not be acked.
- *
  */
 enum ieee80211_hw_flags {
 	IEEE80211_HW_HAS_RATE_CONTROL			= 1<<0,
@@ -1401,7 +1397,6 @@ enum ieee80211_hw_flags {
 	IEEE80211_HW_TX_AMPDU_SETUP_IN_HW		= 1<<23,
 	IEEE80211_HW_SCAN_WHILE_IDLE			= 1<<24,
 	IEEE80211_HW_P2P_DEV_ADDR_FOR_INTF		= 1<<25,
-	IEEE80211_HW_TEARDOWN_AGGR_ON_BAR_FAIL		= 1<<26,
 };
 
 /**
diff --git a/net/mac80211/status.c b/net/mac80211/status.c
index 07d9957..ab50285 100644
--- a/net/mac80211/status.c
+++ b/net/mac80211/status.c
@@ -502,11 +502,7 @@ void ieee80211_tx_status(struct ieee80211_hw *hw, struct sk_buff *skb)
 				       IEEE80211_BAR_CTRL_TID_INFO_MASK) >>
 				      IEEE80211_BAR_CTRL_TID_INFO_SHIFT;
 
-				if (local->hw.flags &
-				    IEEE80211_HW_TEARDOWN_AGGR_ON_BAR_FAIL)
-					ieee80211_stop_tx_ba_session(&sta->sta, tid);
-				else
-					ieee80211_set_bar_pending(sta, tid, ssn);
+				ieee80211_set_bar_pending(sta, tid, ssn);
 			}
 		}
 
-- 
1.7.1

