Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga02.intel.com ([134.134.136.20]:35456 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752720AbYA3LJQ (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 30 Jan 2008 06:09:16 -0500
From: Tomas Winkler <tomas.winkler@intel.com>
To: linville@tuxdriver.com, johannes@sipsolutions.net
Cc: linux-wireless@vger.kernel.org,
	Ron Rindjunsky <ron.rindjunsky@intel.com>
Subject: [PATCH 1/1] mac80211: adjustable number of bits for qdisc pool
Date: Wed, 30 Jan 2008 13:07:51 +0200
Message-Id: <12016912713994-git-send-email-tomas.winkler@intel.com> (sfid-20080130_110919_528126_43357051)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Ron Rindjunsky <ron.rindjunsky@intel.com>

This fix allows to control the number of bits that qdiscs book keeping can be done
for with respect to the qdisc pool

Signed-off-by: Ron Rindjunsky <ron.rindjunsky@intel.com>
Signed-off-by: Tomas Winkler <tomas.winkler@intel.com>
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
1.5.2.2

