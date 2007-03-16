Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga02.intel.com ([134.134.136.20]:41194 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751988AbXCPDk7 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 15 Mar 2007 23:40:59 -0400
Subject: [PATCH 5/5] mac80211: fix passing wrong pointer to  ieee80211_dump_frame
From: Hong Liu <hong.liu@intel.com>
To: Jiri Benc <jbenc@suse.cz>,
	"John W. Linville" <linville@tuxdriver.com>
Cc: linux-wireless@vger.kernel.org
Content-Type: text/plain
Message-Id: <1174015696.3408.37.camel@devlinux-hong>
Mime-Version: 1.0
Date: Fri, 16 Mar 2007 11:28:19 +0800
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>



Signed-off-by: Hong Liu <hong.liu@intel.com>

---

 net/mac80211/ieee80211.c |    3 ++-
 1 files changed, 2 insertions(+), 1 deletions(-)

12fccf89c133c23251fa8c5bca980bdc8875c053
diff --git a/net/mac80211/ieee80211.c b/net/mac80211/ieee80211.c
index 577dbe3..fbdabfb 100644
--- a/net/mac80211/ieee80211.c
+++ b/net/mac80211/ieee80211.c
@@ -1174,7 +1174,8 @@ static int __ieee80211_tx(struct ieee802
 			}
 
 			ieee80211_dump_frame(local->mdev->name,
-					     "TX to low-level driver", skb);
+					     "TX to low-level driver",
+					     tx->u.tx.extra_frag[i]);
 			ret = local->ops->tx(local_to_hw(local),
 					    tx->u.tx.extra_frag[i],
 					    control);
-- 
1.3.3

