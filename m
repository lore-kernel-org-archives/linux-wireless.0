Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from paleale.coelho.fi ([176.9.41.70]:46972 "EHLO
        farmhouse.coelho.fi" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1727577AbeIEJeu (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 5 Sep 2018 05:34:50 -0400
From: Luca Coelho <luca@coelho.fi>
To: johannes@sipsolutions.net
Cc: linux-wireless@vger.kernel.org,
        Andrei Otcheretianski <andrei.otcheretianski@intel.com>,
        Luca Coelho <luciano.coelho@intel.com>
Date: Wed,  5 Sep 2018 08:06:13 +0300
Message-Id: <20180905050614.23273-9-luca@coelho.fi> (sfid-20180905_070635_094172_67131BBF)
In-Reply-To: <20180905050614.23273-1-luca@coelho.fi>
References: <20180831083130.15525-1-luca@coelho.fi>
 <20180905050614.23273-1-luca@coelho.fi>
Subject: [RESEND PATCH v2 8/9] mac80211: Always report TX status
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Andrei Otcheretianski <andrei.otcheretianski@intel.com>

If a frame is dropped for any reason, mac80211 wouldn't report the TX
status back to user space.

As the user space may rely on the TX_STATUS to kick its state
machines, resends etc, it's better to just report this frame as not
acked instead.

Signed-off-by: Andrei Otcheretianski <andrei.otcheretianski@intel.com>
Signed-off-by: Luca Coelho <luciano.coelho@intel.com>
---
 net/mac80211/status.c | 7 ++-----
 1 file changed, 2 insertions(+), 5 deletions(-)

diff --git a/net/mac80211/status.c b/net/mac80211/status.c
index 9a6d7208bf4f..001a869c059c 100644
--- a/net/mac80211/status.c
+++ b/net/mac80211/status.c
@@ -479,11 +479,6 @@ static void ieee80211_report_ack_skb(struct ieee80211_local *local,
 	if (!skb)
 		return;
 
-	if (dropped) {
-		dev_kfree_skb_any(skb);
-		return;
-	}
-
 	if (info->flags & IEEE80211_TX_INTFL_NL80211_FRAME_TX) {
 		u64 cookie = IEEE80211_SKB_CB(skb)->ack.cookie;
 		struct ieee80211_sub_if_data *sdata;
@@ -506,6 +501,8 @@ static void ieee80211_report_ack_skb(struct ieee80211_local *local,
 		}
 		rcu_read_unlock();
 
+		dev_kfree_skb_any(skb);
+	} else if (dropped) {
 		dev_kfree_skb_any(skb);
 	} else {
 		/* consumes skb */
-- 
2.18.0
