Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.neratec.com ([46.140.151.2]:20484 "EHLO mail.neratec.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751487AbbFAOvq (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 1 Jun 2015 10:51:46 -0400
From: Wojciech Dubowik <Wojciech.Dubowik@neratec.com>
To: linux-wireless@vger.kernel.org
Cc: julian.calaby@gmail.com,
	Wojciech Dubowik <Wojciech.Dubowik@neratec.com>
Subject: [PATCH v2] mac80211: Fix double locking on CSA counter update
Date: Mon,  1 Jun 2015 16:51:31 +0200
Message-Id: <1433170291-28665-1-git-send-email-Wojciech.Dubowik@neratec.com> (sfid-20150601_165150_599042_C9CB69CD)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

We call rcu locked ieee80211_csa_update_counter from already locked
section. Fix it by splitting ieee80211_csa_update_counter into
locked and unlocked variants and use the latter in rcu locked section.

v2: Use splitted functions instead of direct counter decrement.

Signed-off-by: Wojciech Dubowik <Wojciech.Dubowik@neratec.com>
---
 net/mac80211/tx.c | 22 ++++++++++++++--------
 1 file changed, 14 insertions(+), 8 deletions(-)

diff --git a/net/mac80211/tx.c b/net/mac80211/tx.c
index 8df1342..312b199 100644
--- a/net/mac80211/tx.c
+++ b/net/mac80211/tx.c
@@ -3216,6 +3216,16 @@ static void ieee80211_set_csa(struct ieee80211_sub_if_data *sdata,
 	rcu_read_unlock();
 }
 
+static u8 __ieee80211_csa_update_counter(struct beacon_data *beacon)
+{
+	beacon->csa_current_counter--;
+
+	/* the counter should never reach 0 */
+	WARN_ON_ONCE(!beacon->csa_current_counter);
+
+	return beacon->csa_current_counter;
+}
+
 u8 ieee80211_csa_update_counter(struct ieee80211_vif *vif)
 {
 	struct ieee80211_sub_if_data *sdata = vif_to_sdata(vif);
@@ -3234,11 +3244,7 @@ u8 ieee80211_csa_update_counter(struct ieee80211_vif *vif)
 	if (!beacon)
 		goto unlock;
 
-	beacon->csa_current_counter--;
-
-	/* the counter should never reach 0 */
-	WARN_ON_ONCE(!beacon->csa_current_counter);
-	count = beacon->csa_current_counter;
+	count = __ieee80211_csa_update_counter(beacon);
 
 unlock:
 	rcu_read_unlock();
@@ -3338,7 +3344,7 @@ __ieee80211_beacon_get(struct ieee80211_hw *hw,
 		if (beacon) {
 			if (beacon->csa_counter_offsets[0]) {
 				if (!is_template)
-					ieee80211_csa_update_counter(vif);
+					__ieee80211_csa_update_counter(beacon);
 
 				ieee80211_set_csa(sdata, beacon);
 			}
@@ -3384,7 +3390,7 @@ __ieee80211_beacon_get(struct ieee80211_hw *hw,
 
 		if (beacon->csa_counter_offsets[0]) {
 			if (!is_template)
-				ieee80211_csa_update_counter(vif);
+				__ieee80211_csa_update_counter(beacon);
 
 			ieee80211_set_csa(sdata, beacon);
 		}
@@ -3414,7 +3420,7 @@ __ieee80211_beacon_get(struct ieee80211_hw *hw,
 				 * for now we leave it consistent with overall
 				 * mac80211's behavior.
 				 */
-				ieee80211_csa_update_counter(vif);
+				__ieee80211_csa_update_counter(beacon);
 
 			ieee80211_set_csa(sdata, beacon);
 		}
-- 
1.9.1

