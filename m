Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from nbd.name ([46.4.11.11]:53279 "EHLO nbd.name"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751382AbcKDJ2A (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 4 Nov 2016 05:28:00 -0400
From: Felix Fietkau <nbd@nbd.name>
To: linux-wireless@vger.kernel.org
Cc: toke@toke.dk, johannes@sipsolutions.net
Subject: [PATCH 1/3] mac80211: update A-MPDU flag on tx dequeue
Date: Fri,  4 Nov 2016 10:27:52 +0100
Message-Id: <20161104092754.91649-1-nbd@nbd.name> (sfid-20161104_102809_852793_6F5C131A)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

The sequence number counter is used to derive the starting sequence
number. Since that counter is updated on tx dequeue, the A-MPDU flag
needs to be up to date at the tme of dequeue as well.

This patch prevents sending more A-MPDU frames after the session has
been terminated and also ensures that aggregation starts right after the
session has been established

Fixes: bb42f2d13ffc ("mac80211: Move reorder-sensitive TX handlers to after TXQ dequeue")
Signed-off-by: Felix Fietkau <nbd@nbd.name>
---
 net/mac80211/tx.c | 5 +++++
 1 file changed, 5 insertions(+)

diff --git a/net/mac80211/tx.c b/net/mac80211/tx.c
index 62ccaf6..c380e85 100644
--- a/net/mac80211/tx.c
+++ b/net/mac80211/tx.c
@@ -3451,6 +3451,11 @@ struct sk_buff *ieee80211_tx_dequeue(struct ieee80211_hw *hw,
 		goto begin;
 	}
 
+	if (test_bit(IEEE80211_TXQ_AMPDU, &txqi->flags))
+		info->flags |= IEEE80211_TX_CTL_AMPDU;
+	else
+		info->flags &= ~IEEE80211_TX_CTL_AMPDU;
+
 	if (info->control.flags & IEEE80211_TX_CTRL_FAST_XMIT) {
 		struct sta_info *sta = container_of(txq->sta, struct sta_info,
 						    sta);
-- 
2.10.1
