Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from xc.sipsolutions.net ([83.246.72.84]:52803 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753010AbYHFTqC (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 6 Aug 2008 15:46:02 -0400
Subject: [PATCH] mac80211: fill start-sequence-number for BA session start
From: Johannes Berg <johannes@sipsolutions.net>
To: John Linville <linville@tuxdriver.com>
Cc: linux-wireless <linux-wireless@vger.kernel.org>
Content-Type: text/plain
Date: Wed, 06 Aug 2008 21:45:26 +0200
Message-Id: <1218051926.23048.65.camel@johannes.berg> (sfid-20080806_214607_881462_5E348B73)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Otherwise, drivers are required to keep track of the sequence numbers
themselves, and they really shouldn't be since we already do it for
them. I'll fix the race once we figure out how this code should work
at all, it's currently disabled.

Signed-off-by: Johannes Berg <johannes@sipsolutions.net>
---
 net/mac80211/ht.c |    5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

--- everything.orig/net/mac80211/ht.c	2008-08-06 21:40:24.000000000 +0200
+++ everything/net/mac80211/ht.c	2008-08-06 21:43:42.000000000 +0200
@@ -78,7 +78,7 @@ int ieee80211_start_tx_ba_session(struct
 	struct ieee80211_local *local = hw_to_local(hw);
 	struct sta_info *sta;
 	struct ieee80211_sub_if_data *sdata;
-	u16 start_seq_num = 0;
+	u16 start_seq_num;
 	u8 *state;
 	int ret;
 	DECLARE_MAC_BUF(mac);
@@ -158,6 +158,9 @@ int ieee80211_start_tx_ba_session(struct
 	 * call back right away, it must see that the flow has begun */
 	*state |= HT_ADDBA_REQUESTED_MSK;
 
+	/* This is slightly racy because the queue isn't stopped */
+	start_seq_num = sta->tid_seq[tid];
+
 	if (local->ops->ampdu_action)
 		ret = local->ops->ampdu_action(hw, IEEE80211_AMPDU_TX_START,
 						ra, tid, &start_seq_num);


