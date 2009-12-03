Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from xc.sipsolutions.net ([83.246.72.84]:53253 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754799AbZLCTsK (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 3 Dec 2009 14:48:10 -0500
Subject: [PATCH] mac80211: fix reorder buffer release
From: Johannes Berg <johannes@sipsolutions.net>
To: John Linville <linville@tuxdriver.com>
Cc: Reinette Chatre <reinette.chatre@intel.com>,
	Christian Lamparter <chunkeey@googlemail.com>,
	linux-wireless <linux-wireless@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Date: Thu, 03 Dec 2009 20:48:09 +0100
Message-ID: <1259869689.12843.16.camel@johannes.local>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

My patch "mac80211: correctly place aMPDU RX reorder code"
uses an skb queue for MPDUs that were released from the
buffer. I intentially didn't initialise and use the skb
queue's spinlock, but in this place forgot that the code
variant that doesn't touch the spinlock is needed.

Thanks to Christian Lamparter for quickly spotting the
bug in the backtrace Reinette reported.

Reported-by: Reinette Chatre <reinette.chatre@intel.com>
Bug-identified-by: Christian Lamparter <chunkeey@googlemail.com>
Tested-by: Reinette Chatre <reinette.chatre@intel.com>
Signed-off-by: Johannes Berg <johannes@sipsolutions.net>
---
 net/mac80211/rx.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- wireless-testing.orig/net/mac80211/rx.c	2009-12-03 20:18:21.000000000 +0100
+++ wireless-testing/net/mac80211/rx.c	2009-12-03 20:42:50.000000000 +0100
@@ -570,7 +570,7 @@ static void ieee80211_release_reorder_fr
 		rate = &sband->bitrates[status->rate_idx];
 	tid_agg_rx->stored_mpdu_num--;
 	tid_agg_rx->reorder_buf[index] = NULL;
-	skb_queue_tail(frames, skb);
+	__skb_queue_tail(frames, skb);
 
 no_frame:
 	tid_agg_rx->head_seq_num = seq_inc(tid_agg_rx->head_seq_num);


