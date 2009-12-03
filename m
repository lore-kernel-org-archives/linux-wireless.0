Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from xc.sipsolutions.net ([83.246.72.84]:47492 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756508AbZLCTOs (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 3 Dec 2009 14:14:48 -0500
Subject: Re: [PATCH v2 3/5] mac80211: correctly place aMPDU RX reorder code
From: Johannes Berg <johannes@sipsolutions.net>
To: reinette chatre <reinette.chatre@intel.com>
Cc: John Linville <linville@tuxdriver.com>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
In-Reply-To: <1259864007.4653.298.camel@rc-desk>
References: <20091125164614.427835023@sipsolutions.net>
	 <20091125164821.184669673@sipsolutions.net>
	 <1259864007.4653.298.camel@rc-desk>
Content-Type: text/plain; charset="UTF-8"
Date: Thu, 03 Dec 2009 20:14:49 +0100
Message-ID: <1259867689.12843.14.camel@johannes.local>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, 2009-12-03 at 10:13 -0800, reinette chatre wrote:

> [  729.672010]  [<ffffffff812aff1b>] skb_queue_tail+0x2b/0x60
> [  729.672010]  [<ffffffffa04b11f5>] ieee80211_release_reorder_frame+0x35/0x50 [mac80211]

So Christian beat me to looking at the trace and pointed out that
skb_queue_tail has no business here, we've intentionally not initialised
the spinlock. The patch below should fix it. I suppose I never had
actual reordering in my tests.

johannes

---
 net/mac80211/rx.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- wireless-testing.orig/net/mac80211/rx.c	2009-12-03 20:13:44.000000000 +0100
+++ wireless-testing/net/mac80211/rx.c	2009-12-03 20:13:50.000000000 +0100
@@ -570,7 +570,7 @@ static void ieee80211_release_reorder_fr
 		rate = &sband->bitrates[status->rate_idx];
 	tid_agg_rx->stored_mpdu_num--;
 	tid_agg_rx->reorder_buf[index] = NULL;
-	skb_queue_tail(frames, skb);
+	__skb_queue_tail(frames, skb);
 
 no_frame:
 	tid_agg_rx->head_seq_num = seq_inc(tid_agg_rx->head_seq_num);


