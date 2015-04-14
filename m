Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([5.9.151.49]:56847 "EHLO sipsolutions.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753764AbbDNPEH (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 14 Apr 2015 11:04:07 -0400
From: Johannes Berg <johannes@sipsolutions.net>
To: linux-wireless@vger.kernel.org
Cc: Johannes Berg <johannes.berg@intel.com>
Subject: [RFC/RFT 03/11] mac80211: extend fast-xmit to driver fragmentation
Date: Tue, 14 Apr 2015 17:03:41 +0200
Message-Id: <1429023829-3991-4-git-send-email-johannes@sipsolutions.net> (sfid-20150414_170438_926962_4E3E29D6)
In-Reply-To: <1429023829-3991-1-git-send-email-johannes@sipsolutions.net>
References: <1429023829-3991-1-git-send-email-johannes@sipsolutions.net>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Johannes Berg <johannes.berg@intel.com>

If the driver handles fragmentation then it wouldn't
be done in software so we can still use the fast-xmit
path in that case.

Signed-off-by: Johannes Berg <johannes.berg@intel.com>
---
 net/mac80211/tx.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/net/mac80211/tx.c b/net/mac80211/tx.c
index d5bfa6c4afd0..86d64bd11c01 100644
--- a/net/mac80211/tx.c
+++ b/net/mac80211/tx.c
@@ -2439,7 +2439,8 @@ void ieee80211_check_fast_xmit(struct sta_info *sta, gfp_t gfp)
 		return;
 
 	/* fast-xmit doesn't handle fragmentation at all */
-	if (local->hw.wiphy->frag_threshold != (u32)-1)
+	if (local->hw.wiphy->frag_threshold != (u32)-1 &&
+	    !local->ops->set_frag_threshold)
 		return;
 
 	rcu_read_lock();
-- 
2.1.4

