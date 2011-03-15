Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:43756 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750863Ab1COWRL (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 15 Mar 2011 18:17:11 -0400
Subject: [PATCH] mac80211: add comment about reordering
From: Johannes Berg <johannes@sipsolutions.net>
To: "John W. Linville" <linville@tuxdriver.com>
Cc: linux-wireless <linux-wireless@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Date: Tue, 15 Mar 2011 23:17:01 +0100
Message-ID: <1300227421.12606.0.camel@jlt3.sipsolutions.net>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Johannes Berg <johannes.berg@intel.com>

Took me a minute to figure this out, maybe
it's better documented...

Signed-off-by: Johannes Berg <johannes.berg@intel.com>
---
 net/mac80211/rx.c |    2 ++
 1 file changed, 2 insertions(+)

--- a/net/mac80211/rx.c	2011-03-15 23:14:55.000000000 +0100
+++ b/net/mac80211/rx.c	2011-03-15 23:15:25.000000000 +0100
@@ -706,6 +706,8 @@ static bool ieee80211_sta_manage_reorder
 	/*
 	 * If the current MPDU is in the right order and nothing else
 	 * is stored we can process it directly, no need to buffer it.
+	 * If it is first but there's something stored, we may be able
+	 * to release frames after this one.
 	 */
 	if (mpdu_seq_num == tid_agg_rx->head_seq_num &&
 	    tid_agg_rx->stored_mpdu_num == 0) {


