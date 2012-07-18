Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:44250 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755327Ab2GRSlb (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 18 Jul 2012 14:41:31 -0400
From: Johannes Berg <johannes@sipsolutions.net>
To: linux-wireless@vger.kernel.org
Cc: Johannes Berg <johannes.berg@intel.com>
Subject: [PATCH] mac80211: fix scan_sdata assignment
Date: Wed, 18 Jul 2012 20:41:33 +0200
Message-Id: <1342636893-5230-1-git-send-email-johannes@sipsolutions.net> (sfid-20120718_204133_600747_35A6852F)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Johannes Berg <johannes.berg@intel.com>

We need to use RCU to assign scan_sdata.

Signed-off-by: Johannes Berg <johannes.berg@intel.com>
---
 net/mac80211/scan.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/net/mac80211/scan.c b/net/mac80211/scan.c
index e80a8b6..85d89d8 100644
--- a/net/mac80211/scan.c
+++ b/net/mac80211/scan.c
@@ -300,7 +300,7 @@ static void __ieee80211_scan_completed(struct ieee80211_hw *hw, bool aborted,
 	if (local->scan_req != local->int_scan_req)
 		cfg80211_scan_done(local->scan_req, aborted);
 	local->scan_req = NULL;
-	local->scan_sdata = NULL;
+	rcu_assign_pointer(local->scan_sdata, NULL);
 
 	local->scanning = 0;
 	local->scan_channel = NULL;
-- 
1.7.10.4

