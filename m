Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:59793 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752312Ab0GVPLa (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 22 Jul 2010 11:11:30 -0400
Subject: [PATCH] mac80211: fix sta assignment
From: Johannes Berg <johannes@sipsolutions.net>
To: John Linville <linville@tuxdriver.com>
Cc: linux-wireless <linux-wireless@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Date: Thu, 22 Jul 2010 17:11:28 +0200
Message-ID: <1279811488.12439.22.camel@jlt3.sipsolutions.net>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Johannes Berg <johannes.berg@intel.com>

I just had the following:
WARNING: at drivers/net/wireless/iwlwifi/iwl-agn-tx.c:574 iwlagn_tx_skb+0x1576/0x15f0 [iwlagn]()
Call Trace:
 <IRQ>  [<ffffffff8105c5df>] warn_slowpath_common+0x7f/0xc0
 [<ffffffff8105c63a>] warn_slowpath_null+0x1a/0x20
 [<ffffffffa0290b46>] iwlagn_tx_skb+0x1576/0x15f0 [iwlagn]
 [<ffffffffa027076c>] iwl_mac_tx+0x5c/0x260 [iwlagn]
 [<ffffffffa01bdf5b>] __ieee80211_tx+0x10b/0x1a0 [mac80211]
 [<ffffffffa01bfb86>] ieee80211_tx_pending+0x186/0x2d0 [mac80211]
 [<ffffffff81062ea5>] tasklet_action+0x125/0x130
 [<ffffffff810634a6>] __do_softirq+0x106/0x270
 [<ffffffff8100c09c>] call_softirq+0x1c/0x30
iwlagn 0000:02:00.0: Attempting to modify non-existing station 107

Note that 107 == 0x6b which is slab poison.

The reason is that mac80211 passed a freed station
pointer to mac80211, because as it happened iwlwifi
reset itself while mac80211 was disconnecting from
the network.

It turns out that we do take care to look up the
station pointer in ieee80211_tx_pending_skb, but
then don't use it, which obviously is a bug. Fix
this by removing the ieee80211_tx_h_sta handler
and assigning the station pointer directly.

Signed-off-by: Johannes Berg <johannes.berg@intel.com>
---
 net/mac80211/tx.c |   17 +++++------------
 1 file changed, 5 insertions(+), 12 deletions(-)

--- wireless-testing.orig/net/mac80211/tx.c	2010-07-22 16:55:47.000000000 +0200
+++ wireless-testing/net/mac80211/tx.c	2010-07-22 16:59:49.000000000 +0200
@@ -576,17 +576,6 @@ ieee80211_tx_h_select_key(struct ieee802
 }
 
 static ieee80211_tx_result debug_noinline
-ieee80211_tx_h_sta(struct ieee80211_tx_data *tx)
-{
-	struct ieee80211_tx_info *info = IEEE80211_SKB_CB(tx->skb);
-
-	if (tx->sta && tx->sta->uploaded)
-		info->control.sta = &tx->sta->sta;
-
-	return TX_CONTINUE;
-}
-
-static ieee80211_tx_result debug_noinline
 ieee80211_tx_h_rate_ctrl(struct ieee80211_tx_data *tx)
 {
 	struct ieee80211_tx_info *info = IEEE80211_SKB_CB(tx->skb);
@@ -1307,6 +1296,11 @@ static int __ieee80211_tx(struct ieee802
 			break;
 		}
 
+		if (sta && sta->uploaded)
+			info->control.sta = &sta->sta;
+		else
+			info->control.sta = NULL;
+
 		ret = drv_tx(local, skb);
 		if (WARN_ON(ret != NETDEV_TX_OK && skb->len != len)) {
 			dev_kfree_skb(skb);
@@ -1346,7 +1340,6 @@ static int invoke_tx_handlers(struct iee
 	CALL_TXH(ieee80211_tx_h_check_assoc);
 	CALL_TXH(ieee80211_tx_h_ps_buf);
 	CALL_TXH(ieee80211_tx_h_select_key);
-	CALL_TXH(ieee80211_tx_h_sta);
 	if (!(tx->local->hw.flags & IEEE80211_HW_HAS_RATE_CONTROL))
 		CALL_TXH(ieee80211_tx_h_rate_ctrl);
 


