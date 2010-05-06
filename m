Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from charlotte.tuxdriver.com ([70.61.120.58]:59863 "EHLO
	smtp.tuxdriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753570Ab0EFTAS (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 6 May 2010 15:00:18 -0400
From: "John W. Linville" <linville@tuxdriver.com>
To: linux-wireless@vger.kernel.org
Cc: "John W. Linville" <linville@tuxdriver.com>
Subject: [PATCH] mac80211: set IEEE80211_TX_CTL_FIRST_FRAGMENT for beacons
Date: Thu,  6 May 2010 14:45:17 -0400
Message-Id: <1273171517-6264-1-git-send-email-linville@tuxdriver.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Also simplify the flags assignment into a single statement at the
end of ieee80211_beacon_get_tim.

Signed-off-by: John W. Linville <linville@tuxdriver.com>
---
 net/mac80211/tx.c |    5 +++--
 1 files changed, 3 insertions(+), 2 deletions(-)

diff --git a/net/mac80211/tx.c b/net/mac80211/tx.c
index f3841f4..6bd2492 100644
--- a/net/mac80211/tx.c
+++ b/net/mac80211/tx.c
@@ -2251,8 +2251,9 @@ struct sk_buff *ieee80211_beacon_get_tim(struct ieee80211_hw *hw,
 
 	info->control.vif = vif;
 
-	info->flags |= IEEE80211_TX_CTL_CLEAR_PS_FILT;
-	info->flags |= IEEE80211_TX_CTL_ASSIGN_SEQ;
+	info->flags |= (IEEE80211_TX_CTL_CLEAR_PS_FILT |
+			IEEE80211_TX_CTL_ASSIGN_SEQ |
+			IEEE80211_TX_CTL_FIRST_FRAGMENT);
  out:
 	rcu_read_unlock();
 	return skb;
-- 
1.6.6.1

