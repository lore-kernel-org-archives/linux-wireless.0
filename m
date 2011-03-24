Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-iy0-f174.google.com ([209.85.210.174]:48382 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934176Ab1CXXBw convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 24 Mar 2011 19:01:52 -0400
Received: by iyb26 with SMTP id 26so458257iyb.19
        for <linux-wireless@vger.kernel.org>; Thu, 24 Mar 2011 16:01:52 -0700 (PDT)
From: Daniel Halperin <dhalperi@cs.washington.edu>
Content-Type: text/plain; charset=us-ascii
Subject: [PATCH v2] mac80211: fix aggregation frame release during timeout 
Date: Thu, 24 Mar 2011 16:01:48 -0700
Message-Id: <BEE1FD4D-9E17-4B27-8B0D-C842F1067A7D@cs.washington.edu>
To: linux-wireless <linux-wireless@vger.kernel.org>
Mime-Version: 1.0 (Apple Message framework v1084)
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
v2: moved the skipped test to the front of the line
---
 net/mac80211/rx.c |    3 ++-
 1 files changed, 2 insertions(+), 1 deletions(-)

diff --git a/net/mac80211/rx.c b/net/mac80211/rx.c
index 5c1930b..aa5cc37 100644
--- a/net/mac80211/rx.c
+++ b/net/mac80211/rx.c
@@ -612,7 +612,8 @@ static void ieee80211_sta_reorder_release(struct ieee80211_hw *hw,
 				skipped++;
 				continue;
 			}
-			if (!time_after(jiffies, tid_agg_rx->reorder_time[j] +
+			if (skipped &&
+			    !time_after(jiffies, tid_agg_rx->reorder_time[j] +
 					HT_RX_REORDER_BUF_TIMEOUT))
 				goto set_release_timer;
 
-- 
1.7.0.4


