Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from styx.suse.cz ([82.119.242.94]:49000 "EHLO silver.suse.cz"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S934313AbXCWUnm (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 23 Mar 2007 16:43:42 -0400
From: Jiri Benc <jbenc@suse.cz>
To: "John W. Linville" <linville@tuxdriver.com>
In-Reply-To: <20070323214400.642621638.midnight@suse.cz>
Cc: linux-wireless@vger.kernel.org
Subject: [PATCH 16/19] mac80211: fix passing wrong pointer to ieee80211_dump_frame
Message-Id: <20070323204459.2DBDB4858F@silver.suse.cz>
Date: Fri, 23 Mar 2007 21:44:59 +0100 (CET)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Hong Liu <hong.liu@intel.com>

Signed-off-by: Hong Liu <hong.liu@intel.com>
Signed-off-by: Jiri Benc <jbenc@suse.cz>

---

 net/mac80211/ieee80211.c |    3 ++-
 1 files changed, 2 insertions(+), 1 deletions(-)

0ddfc778426ba75c2ad71d23e9e2e48121264c70
diff --git a/net/mac80211/ieee80211.c b/net/mac80211/ieee80211.c
index 24cc3a0..fccb0fe 100644
--- a/net/mac80211/ieee80211.c
+++ b/net/mac80211/ieee80211.c
@@ -1166,7 +1166,8 @@ static int __ieee80211_tx(struct ieee802
 			}
 
 			ieee80211_dump_frame(local->mdev->name,
-					     "TX to low-level driver", skb);
+					     "TX to low-level driver",
+					     tx->u.tx.extra_frag[i]);
 			ret = local->ops->tx(local_to_hw(local),
 					    tx->u.tx.extra_frag[i],
 					    control);
-- 
1.3.0

