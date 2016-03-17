Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga03.intel.com ([134.134.136.65]:23612 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751810AbcCQNDU (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 17 Mar 2016 09:03:20 -0400
From: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
To: johannes@sipsolutions.net
Cc: linux-wireless@vger.kernel.org,
	Johannes Berg <johannes.berg@intel.com>
Subject: [PATCH 1/4] mac80211: don't start dynamic PS timer if not needed
Date: Thu, 17 Mar 2016 15:02:52 +0200
Message-Id: <1458219775-24450-1-git-send-email-emmanuel.grumbach@intel.com> (sfid-20160317_140324_152589_99C2E41D)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Johannes Berg <johannes.berg@intel.com>

If the device implements dynamic PS itself, there's no need
to ever start the dynamic powersave timer on RX.

While at it, fix up some indentation in this code.

Signed-off-by: Johannes Berg <johannes.berg@intel.com>
---
 net/mac80211/rx.c | 10 +++++-----
 1 file changed, 5 insertions(+), 5 deletions(-)

diff --git a/net/mac80211/rx.c b/net/mac80211/rx.c
index 9127957..3746ba5 100644
--- a/net/mac80211/rx.c
+++ b/net/mac80211/rx.c
@@ -2456,14 +2456,14 @@ ieee80211_rx_h_data(struct ieee80211_rx_data *rx)
 
 	rx->skb->dev = dev;
 
-	if (local->ps_sdata && local->hw.conf.dynamic_ps_timeout > 0 &&
+	if (!ieee80211_hw_check(&local->hw, SUPPORTS_DYNAMIC_PS) &&
+	    local->ps_sdata && local->hw.conf.dynamic_ps_timeout > 0 &&
 	    !is_multicast_ether_addr(
 		    ((struct ethhdr *)rx->skb->data)->h_dest) &&
 	    (!local->scanning &&
-	     !test_bit(SDATA_STATE_OFFCHANNEL, &sdata->state))) {
-			mod_timer(&local->dynamic_ps_timer, jiffies +
-			 msecs_to_jiffies(local->hw.conf.dynamic_ps_timeout));
-	}
+	     !test_bit(SDATA_STATE_OFFCHANNEL, &sdata->state)))
+		mod_timer(&local->dynamic_ps_timer, jiffies +
+			  msecs_to_jiffies(local->hw.conf.dynamic_ps_timeout));
 
 	ieee80211_deliver_skb(rx);
 
-- 
2.5.0

