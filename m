Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-bw0-f46.google.com ([209.85.214.46]:43431 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754772Ab1DXS5A (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 24 Apr 2011 14:57:00 -0400
Received: by bwz15 with SMTP id 15so1250477bwz.19
        for <linux-wireless@vger.kernel.org>; Sun, 24 Apr 2011 11:56:58 -0700 (PDT)
From: Christian Lamparter <chunkeey@googlemail.com>
Date: Sun, 24 Apr 2011 20:41:16 +0200
Subject: [PATCH] mac80211: fix too early reorder release timer
To: linux-wireless@vger.kernel.org
Cc: linville@tuxdriver.com
Message-Id: <E1QE4UJ-0007nO-Sx@debian64.daheim> (sfid-20110424_205703_781501_E95A3C37)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

The release timer has to expire "just" after a
frame is up for release. Currently, if the timer
callback starts on time, the "!time_after" check
above will start a new timer instead of
releasing the frames.

Signed-off-by: Christian Lamparter <chunkeey@googlemail.com>
---
 net/mac80211/rx.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/net/mac80211/rx.c b/net/mac80211/rx.c
index a864890..599fa90 100644
--- a/net/mac80211/rx.c
+++ b/net/mac80211/rx.c
@@ -652,7 +652,7 @@ static void ieee80211_sta_reorder_release(struct ieee80211_hw *hw,
  set_release_timer:
 
 		mod_timer(&tid_agg_rx->reorder_timer,
-			  tid_agg_rx->reorder_time[j] +
+			  tid_agg_rx->reorder_time[j] + 1 +
 			  HT_RX_REORDER_BUF_TIMEOUT);
 	} else {
 		del_timer(&tid_agg_rx->reorder_timer);
-- 
1.7.4.4

