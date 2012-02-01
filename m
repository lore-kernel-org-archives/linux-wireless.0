Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wi0-f174.google.com ([209.85.212.174]:50918 "EHLO
	mail-wi0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752853Ab2BAQor (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 1 Feb 2012 11:44:47 -0500
Received: by wics10 with SMTP id s10so1055524wic.19
        for <linux-wireless@vger.kernel.org>; Wed, 01 Feb 2012 08:44:45 -0800 (PST)
From: Eliad Peller <eliad@wizery.com>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: <linux-wireless@vger.kernel.org>
Subject: [PATCH v2] mac80211: timeout a single frame in the rx reorder buffer
Date: Wed,  1 Feb 2012 18:48:09 +0200
Message-Id: <1328114889-15627-1-git-send-email-eliad@wizery.com> (sfid-20120201_174451_052054_D6EB60FC)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

The current code checks for stored_mpdu_num > 1, causing
the reorder_timer to be triggered indefinitely, but the
frame is never timed-out (until the next packet is received)

Signed-off-by: Eliad Peller <eliad@wizery.com>
Cc: <stable@vger.kernel.org>
Acked-by: Johannes Berg <johannes@sipsolutions.net>
---
v2: cc stable

 net/mac80211/rx.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/net/mac80211/rx.c b/net/mac80211/rx.c
index f407427..7e3980f 100644
--- a/net/mac80211/rx.c
+++ b/net/mac80211/rx.c
@@ -611,7 +611,7 @@ static void ieee80211_sta_reorder_release(struct ieee80211_hw *hw,
 	index = seq_sub(tid_agg_rx->head_seq_num, tid_agg_rx->ssn) %
 						tid_agg_rx->buf_size;
 	if (!tid_agg_rx->reorder_buf[index] &&
-	    tid_agg_rx->stored_mpdu_num > 1) {
+	    tid_agg_rx->stored_mpdu_num) {
 		/*
 		 * No buffers ready to be released, but check whether any
 		 * frames in the reorder buffer have timed out.
-- 
1.7.6.401.g6a319

