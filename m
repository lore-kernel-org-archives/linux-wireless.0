Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from rcsinet10.oracle.com ([148.87.113.121]:57128 "EHLO
	rcsinet10.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754779Ab1EWAYV (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 22 May 2011 20:24:21 -0400
Date: Sun, 22 May 2011 17:22:45 -0700
From: Randy Dunlap <randy.dunlap@oracle.com>
To: linux-wireless@vger.kernel.org
Cc: "John W. Linville" <linville@tuxdriver.com>, davem@davemloft.net,
	torvalds <torvalds@linux-foundation.org>
Subject: [PATCH] wireless: fix fatal kernel-doc error + warning in
 mac80211.h
Message-Id: <20110522172245.8e53875d.randy.dunlap@oracle.com> (sfid-20110523_022425_584075_024F0505)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Randy Dunlap <randy.dunlap@oracle.com>

Fix new kernel-doc Error and Warning in <net/mac80211.h>:

Error(linux-2.6.39-git5/include/net/mac80211.h:550): cannot understand prototype: 'struct ieee80211_sched_scan_ies '
Warning(linux-2.6.39-git5/include/net/mac80211.h:2289): No description found for parameter 'sta'

Signed-off-by: Randy Dunlap <randy.dunlap@oracle.com>
---
 include/net/mac80211.h |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

--- linux-2.6.39-git5.orig/include/net/mac80211.h
+++ linux-2.6.39-git5/include/net/mac80211.h
@@ -538,7 +538,7 @@ struct ieee80211_tx_info {
 };
 
 /**
- * ieee80211_sched_scan_ies - scheduled scan IEs
+ * struct ieee80211_sched_scan_ies - scheduled scan IEs
  *
  * This structure is used to pass the appropriate IEs to be used in scheduled
  * scans for all bands.  It contains both the IEs passed from the userspace
@@ -2278,6 +2278,7 @@ static inline int ieee80211_sta_ps_trans
 
 /**
  * ieee80211_sta_set_tim - set the TIM bit for a sleeping station
+ * @sta: &struct ieee80211_sta pointer for the sleeping station
  *
  * If a driver buffers frames for a powersave station instead of passing
  * them back to mac80211 for retransmission, the station needs to be told
