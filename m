Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from xc.sipsolutions.net ([83.246.72.84]:55508 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754286AbZJKNLU (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 11 Oct 2009 09:11:20 -0400
Subject: [PATCH] mac80211: document ieee80211_rx() context requirement
From: Johannes Berg <johannes@sipsolutions.net>
To: John Linville <linville@tuxdriver.com>
Cc: linux-wireless <linux-wireless@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Date: Sun, 11 Oct 2009 15:10:40 +0200
Message-Id: <1255266640.4095.235.camel@johannes.local>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

ieee80211_rx() must be called with softirqs disabled
since the networking stack requires this for netif_rx()
and some code in mac80211 can assume that it can not
be processing its own tasklet and this call at the same
time.

It may be possible to remove this requirement after a
careful audit of mac80211 and doing any needed locking
improvements in it along with disabling softirqs around
netif_rx(). An alternative might be to push all packet
processing to process context in mac80211, instead of
to the tasklet, and add other synchronisation.

Signed-off-by: Johannes Berg <johannes@sipsolutions.net>
---
 include/net/mac80211.h |    2 ++
 net/mac80211/rx.c      |    2 ++
 2 files changed, 4 insertions(+)

--- wireless-testing.orig/include/net/mac80211.h	2009-10-11 12:19:54.000000000 +0200
+++ wireless-testing/include/net/mac80211.h	2009-10-11 12:20:41.000000000 +0200
@@ -1669,6 +1669,8 @@ void ieee80211_restart_hw(struct ieee802
  * to this function and ieee80211_rx_irqsafe() may not be mixed for a
  * single hardware.
  *
+ * Note that right now, this function must be called with softirqs disabled.
+ *
  * @hw: the hardware this frame came in on
  * @skb: the buffer to receive, owned by mac80211 after this call
  */
--- wireless-testing.orig/net/mac80211/rx.c	2009-10-11 12:24:39.000000000 +0200
+++ wireless-testing/net/mac80211/rx.c	2009-10-11 12:38:22.000000000 +0200
@@ -2453,6 +2453,8 @@ void ieee80211_rx(struct ieee80211_hw *h
 	struct ieee80211_supported_band *sband;
 	struct ieee80211_rx_status *status = IEEE80211_SKB_RXCB(skb);
 
+	WARN_ON_ONCE(softirq_count() == 0);
+
 	if (WARN_ON(status->band < 0 ||
 		    status->band >= IEEE80211_NUM_BANDS))
 		goto drop;


