Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga03.intel.com ([143.182.124.21]:60004 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752226AbYA3K77 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 30 Jan 2008 05:59:59 -0500
From: Ron Rindjunsky <ron.rindjunsky@intel.com>
To: linville@tuxdriver.com
Cc: johannes@sipsolutions.net, linux-wireless@vger.kernel.org,
	flamingice@sourmilk.net, tomas.winkler@intel.com,
	Ron Rindjunsky <ron.rindjunsky@intel.com>
Subject: [PATCH 1/1] mac80211: adjustable number of bits for qdisc pool
Date: Wed, 30 Jan 2008 12:58:45 +0200
Message-Id: <12016907253540-git-send-email-ron.rindjunsky@intel.com> (sfid-20080130_110005_648165_6ED8CB76)
Content-Type: text/plain; charset="us-ascii"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This fix allows to control the number of bits that qdiscs book keeping can be done
for with respect to the qdisc pool

Signed-off-by: Ron Rindjunsky <ron.rindjunsky@intel.com>
---
 net/mac80211/wme.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/net/mac80211/wme.c b/net/mac80211/wme.c
index 7bbc793..f12e044 100644
--- a/net/mac80211/wme.c
+++ b/net/mac80211/wme.c
@@ -25,7 +25,7 @@ const int ieee802_1d_to_ac[8] = { 2, 3, 3, 2, 1, 1, 0, 0 };
 
 struct ieee80211_sched_data
 {
-	unsigned long qdisc_pool;
+	unsigned long qdisc_pool[BITS_TO_LONGS(TC_80211_MAX_QUEUES)];
 	struct tcf_proto *filter_list;
 	struct Qdisc *queues[TC_80211_MAX_QUEUES];
 	struct sk_buff_head requeued[TC_80211_MAX_QUEUES];
-- 
1.5.3.3

---------------------------------------------------------------------
Intel Israel (74) Limited

This e-mail and any attachments may contain confidential material for
the sole use of the intended recipient(s). Any review or distribution
by others is strictly prohibited. If you are not the intended
recipient, please contact the sender and delete all copies.

