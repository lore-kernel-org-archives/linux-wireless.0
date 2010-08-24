Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-bw0-f46.google.com ([209.85.214.46]:42818 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752143Ab0HXRWu (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 24 Aug 2010 13:22:50 -0400
Received: by bwz11 with SMTP id 11so4952089bwz.19
        for <linux-wireless@vger.kernel.org>; Tue, 24 Aug 2010 10:22:48 -0700 (PDT)
From: Christian Lamparter <chunkeey@googlemail.com>
To: "linux-wireless" <linux-wireless@vger.kernel.org>
Subject: [PATCH] mac80211: fix rcu-unsafe pointer dereference
Date: Tue, 24 Aug 2010 19:22:42 +0200
Cc: "John W. Linville" <linville@tuxdriver.com>,
	Johannes Berg <johannes@sipsolutions.net>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="us-ascii"
Message-Id: <201008241922.42514.chunkeey@googlemail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This patch fixes a potential crash (null-pointer de-
reference) which was introduced in my previous patch:
 "mac80211: AMPDU rx reorder timeout timer"

During a BA teardown, the pointer to the soon-to-be-gone
tid_ampdu_rx element will be nullified. Therefore the
release timer mechanism has to be careful not to
accidentally access the item without any RCU protection.

Signed-off-by: Christian Lamparter <chunkeey@googlemail.com>
---
diff --git a/net/mac80211/rx.c b/net/mac80211/rx.c
index 06ef5c1..0c19702 100644
--- a/net/mac80211/rx.c
+++ b/net/mac80211/rx.c
@@ -2482,6 +2482,11 @@ void ieee80211_release_reorder_timeout(struct sta_info *sta, int tid)
 {
 	struct sk_buff_head frames;
 	struct ieee80211_rx_data rx = { };
+	struct tid_ampdu_rx *tid_agg_rx;
+
+	tid_agg_rx = rcu_dereference(sta->ampdu_mlme.tid_rx[tid]);
+	if (!tid_agg_rx)
+		return;
 
 	__skb_queue_head_init(&frames);
 
@@ -2496,10 +2501,9 @@ void ieee80211_release_reorder_timeout(struct sta_info *sta, int tid)
 		     test_bit(SCAN_OFF_CHANNEL, &sta->local->scanning)))
 		rx.flags |= IEEE80211_RX_IN_SCAN;
 
-	spin_lock(&sta->ampdu_mlme.tid_rx[tid]->reorder_lock);
-	ieee80211_sta_reorder_release(&sta->local->hw,
-		sta->ampdu_mlme.tid_rx[tid], &frames);
-	spin_unlock(&sta->ampdu_mlme.tid_rx[tid]->reorder_lock);
+	spin_lock(&tid_agg_rx->reorder_lock);
+	ieee80211_sta_reorder_release(&sta->local->hw, tid_agg_rx, &frames);
+	spin_unlock(&tid_agg_rx->reorder_lock);
 
 	ieee80211_rx_handlers(&rx, &frames);
 }
