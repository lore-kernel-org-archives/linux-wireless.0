Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.neratec.com ([46.140.151.2]:64668 "EHLO mail.neratec.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752807AbbFAN7w (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 1 Jun 2015 09:59:52 -0400
Received: from localhost (localhost [127.0.0.1])
	by mail.neratec.com (Postfix) with ESMTP id 6C9B5A05F98
	for <linux-wireless@vger.kernel.org>; Mon,  1 Jun 2015 15:54:24 +0200 (CEST)
From: Wojciech Dubowik <Wojciech.Dubowik@neratec.com>
To: linux-wireless@vger.kernel.org
Cc: Wojciech Dubowik <Wojciech.Dubowik@neratec.com>
Subject: [PATCH] mac80211: Fix double locking on CSA counter update
Date: Mon,  1 Jun 2015 15:54:16 +0200
Message-Id: <1433166856-3285-1-git-send-email-Wojciech.Dubowik@neratec.com> (sfid-20150601_160005_185002_B78776B5)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

We call rcu locked ieee80211_csa_update_counter from
already locked section. Fix it by decrementing counter
directly instead of calling ieee80211_csa_update_counter.

Signed-off-by: Wojciech Dubowik <Wojciech.Dubowik@neratec.com>
---
 net/mac80211/tx.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/net/mac80211/tx.c b/net/mac80211/tx.c
index 8df1342..9233559 100644
--- a/net/mac80211/tx.c
+++ b/net/mac80211/tx.c
@@ -3338,7 +3338,7 @@ __ieee80211_beacon_get(struct ieee80211_hw *hw,
 		if (beacon) {
 			if (beacon->csa_counter_offsets[0]) {
 				if (!is_template)
-					ieee80211_csa_update_counter(vif);
+					WARN_ON_ONCE(beacon->csa_current_counter--);
 
 				ieee80211_set_csa(sdata, beacon);
 			}
@@ -3384,7 +3384,7 @@ __ieee80211_beacon_get(struct ieee80211_hw *hw,
 
 		if (beacon->csa_counter_offsets[0]) {
 			if (!is_template)
-				ieee80211_csa_update_counter(vif);
+				WARN_ON_ONCE(beacon->csa_current_counter--);
 
 			ieee80211_set_csa(sdata, beacon);
 		}
@@ -3414,7 +3414,7 @@ __ieee80211_beacon_get(struct ieee80211_hw *hw,
 				 * for now we leave it consistent with overall
 				 * mac80211's behavior.
 				 */
-				ieee80211_csa_update_counter(vif);
+				WARN_ON_ONCE(beacon->csa_current_counter--);
 
 			ieee80211_set_csa(sdata, beacon);
 		}
-- 
1.9.1

