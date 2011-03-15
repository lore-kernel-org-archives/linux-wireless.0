Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pv0-f174.google.com ([74.125.83.174]:38272 "EHLO
	mail-pv0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753404Ab1COXuA convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 15 Mar 2011 19:50:00 -0400
Received: by pvg12 with SMTP id 12so183969pvg.19
        for <linux-wireless@vger.kernel.org>; Tue, 15 Mar 2011 16:50:00 -0700 (PDT)
From: Daniel Halperin <dhalperi@cs.washington.edu>
Content-Type: text/plain; charset=us-ascii
Subject: [PATCH] mac80211: fix aggregation frame release during timeout
Date: Tue, 15 Mar 2011 16:49:56 -0700
Message-Id: <507B31BE-2066-4434-870D-108F7DF912A6@cs.washington.edu>
To: linux-wireless <linux-wireless@vger.kernel.org>
Mime-Version: 1.0 (Apple Message framework v1082)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Suppose the aggregation reorder buffer looks like this:

x-T-R1-y-R2,

where x and y are frames that have not been received, T is a received
frame that has timed out, and R1,R2 are received frames that have not
yet timed out. The proper behavior in this scenario is to move the
window past x (skipping it), release T and R1, and leave the window at y
until y is received or R2 times out.

As written, this code will instead leave the window at R1, because it
has not yet timed out. Fix this by exiting the reorder loop only when
the frame that has not timed out AND there are skipped frames earlier in
the current valid window.

Signed-off-by: Daniel Halperin <dhalperi@cs.washington.edu>
---
 net/mac80211/rx.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/net/mac80211/rx.c b/net/mac80211/rx.c
index a6701ed..d466bee 100644
--- a/net/mac80211/rx.c
+++ b/net/mac80211/rx.c
@@ -605,7 +605,7 @@ static void ieee80211_sta_reorder_release(struct ieee80211_hw *hw,
 				continue;
 			}
 			if (!time_after(jiffies, tid_agg_rx->reorder_time[j] +
-					HT_RX_REORDER_BUF_TIMEOUT))
+					HT_RX_REORDER_BUF_TIMEOUT) && skipped)
 				goto set_release_timer;
 
 #ifdef CONFIG_MAC80211_HT_DEBUG
-- 
1.7.0.4


