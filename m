Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga11.intel.com ([192.55.52.93]:21180 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751789AbYDWKpS (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 23 Apr 2008 06:45:18 -0400
From: Ron Rindjunsky <ron.rindjunsky@intel.com>
To: linville@tuxdriver.com
Cc: johannes@sipsolutions.net, linux-wireless@vger.kernel.org,
	bunk@kernel.org, tomas.winkler@intel.com,
	reinette.chatre@intel.com,
	Ron Rindjunsky <ron.rindjunsky@intel.com>
Subject: [PATCH 1/1] mac80211: fix use before check of Qdisc length
Date: Wed, 23 Apr 2008 13:45:12 +0300
Message-Id: <1208947512-22938-1-git-send-email-ron.rindjunsky@intel.com> (sfid-20080423_124557_997138_1FA9B4E4)
Content-Type: text/plain; charset="us-ascii"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This patch fixes use of Qdisc length in requeue function, before we checked
the reference is valid. (Adrian Bunk's catch)

Signed-off-by: Ron Rindjunsky <ron.rindjunsky@intel.com>
Signed-off-by: Adrian Bunk <bunk@kernel.org>
---
 net/mac80211/wme.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/net/mac80211/wme.c b/net/mac80211/wme.c
index 4e94e40..64faa3d 100644
--- a/net/mac80211/wme.c
+++ b/net/mac80211/wme.c
@@ -709,7 +709,7 @@ void ieee80211_requeue(struct ieee80211_local *local, int queue)
 	struct ieee80211_sched_data *q = qdisc_priv(root_qd);
 	struct Qdisc *qdisc = q->queues[queue];
 	struct sk_buff *skb = NULL;
-	u32 len = qdisc->q.qlen;
+	u32 len;
 
 	if (!qdisc || !qdisc->dequeue)
 		return;
-- 
1.5.3.3

---------------------------------------------------------------------
Intel Israel (74) Limited

This e-mail and any attachments may contain confidential material for
the sole use of the intended recipient(s). Any review or distribution
by others is strictly prohibited. If you are not the intended
recipient, please contact the sender and delete all copies.

