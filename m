Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([5.9.151.49]:46739 "EHLO sipsolutions.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751794AbbFQIlT (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 17 Jun 2015 04:41:19 -0400
From: Johannes Berg <johannes@sipsolutions.net>
To: linux-wireless@vger.kernel.org
Cc: Johannes Berg <johannes.berg@intel.com>
Subject: [PATCH 04/14] mac80211: remove short frame test and counter
Date: Wed, 17 Jun 2015 10:41:05 +0200
Message-Id: <1434530475-3553-5-git-send-email-johannes@sipsolutions.net> (sfid-20150617_104129_225938_811D3408)
In-Reply-To: <1434530475-3553-1-git-send-email-johannes@sipsolutions.net>
References: <1434530475-3553-1-git-send-email-johannes@sipsolutions.net>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Johannes Berg <johannes.berg@intel.com>

Short frames less than 16 octets are already blocked in the monitor
code by the should_drop_frame() function, and cannot get into the
regular RX path. Therefore, this check can never trigger and the
counter invariably stays zero. Remove the useless code.

Signed-off-by: Johannes Berg <johannes.berg@intel.com>
---
 net/mac80211/debugfs.c     | 1 -
 net/mac80211/ieee80211_i.h | 1 -
 net/mac80211/rx.c          | 5 -----
 3 files changed, 7 deletions(-)

diff --git a/net/mac80211/debugfs.c b/net/mac80211/debugfs.c
index 3ea8b7de9633..2c79d777f0e4 100644
--- a/net/mac80211/debugfs.c
+++ b/net/mac80211/debugfs.c
@@ -277,7 +277,6 @@ void debugfs_hw_add(struct ieee80211_local *local)
 	DEBUGFS_STATS_ADD(rx_handlers_queued);
 	DEBUGFS_STATS_ADD(rx_handlers_drop_nullfunc);
 	DEBUGFS_STATS_ADD(rx_handlers_drop_defrag);
-	DEBUGFS_STATS_ADD(rx_handlers_drop_short);
 	DEBUGFS_STATS_ADD(tx_expand_skb_head);
 	DEBUGFS_STATS_ADD(tx_expand_skb_head_cloned);
 	DEBUGFS_STATS_ADD(rx_expand_skb_head_defrag);
diff --git a/net/mac80211/ieee80211_i.h b/net/mac80211/ieee80211_i.h
index b12f61507f9f..eb91102e4809 100644
--- a/net/mac80211/ieee80211_i.h
+++ b/net/mac80211/ieee80211_i.h
@@ -1286,7 +1286,6 @@ struct ieee80211_local {
 	unsigned int rx_handlers_queued;
 	unsigned int rx_handlers_drop_nullfunc;
 	unsigned int rx_handlers_drop_defrag;
-	unsigned int rx_handlers_drop_short;
 	unsigned int tx_expand_skb_head;
 	unsigned int tx_expand_skb_head_cloned;
 	unsigned int rx_expand_skb_head_defrag;
diff --git a/net/mac80211/rx.c b/net/mac80211/rx.c
index 9fb8ce982c2d..aa57a2ab8245 100644
--- a/net/mac80211/rx.c
+++ b/net/mac80211/rx.c
@@ -1093,11 +1093,6 @@ ieee80211_rx_h_check(struct ieee80211_rx_data *rx)
 {
 	struct ieee80211_hdr *hdr = (struct ieee80211_hdr *)rx->skb->data;
 
-	if (unlikely(rx->skb->len < 16)) {
-		I802_DEBUG_INC(rx->local->rx_handlers_drop_short);
-		return RX_DROP_MONITOR;
-	}
-
 	/* Drop disallowed frame classes based on STA auth/assoc state;
 	 * IEEE 802.11, Chap 5.5.
 	 *
-- 
2.1.4

