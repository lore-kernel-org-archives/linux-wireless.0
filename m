Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.neratec.com ([46.140.151.2]:48850 "EHLO mail.neratec.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753512AbbFJLHD (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 10 Jun 2015 07:07:03 -0400
From: Wojciech Dubowik <Wojciech.Dubowik@neratec.com>
To: linux-wireless@vger.kernel.org
Cc: julian.calaby@gmail.com, johannes@sipsolutions.net,
	Wojciech Dubowik <Wojciech.Dubowik@neratec.com>
Subject: [PATCH v3] mac80211: Avoid unnecessary locking on CSA counter update
Date: Wed, 10 Jun 2015 13:06:53 +0200
Message-Id: <1433934413-4713-1-git-send-email-Wojciech.Dubowik@neratec.com> (sfid-20150610_130707_736205_EB02D84A)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

v2: Use splitted functions instead of direct counter decrement.
v3: Changed subject and commit message

Signed-off-by: Wojciech Dubowik <Wojciech.Dubowik@neratec.com>
---
 net/mac80211/tx.c | 22 ++++++++++++++--------
 1 file changed, 14 insertions(+), 8 deletions(-)

diff --git a/net/mac80211/tx.c b/net/mac80211/tx.c
index 7fe528a..7425803 100644
--- a/net/mac80211/tx.c
+++ b/net/mac80211/tx.c
@@ -3211,6 +3211,16 @@ static void ieee80211_set_csa(struct ieee80211_sub_if_data *sdata,
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
@@ -3229,11 +3239,7 @@ u8 ieee80211_csa_update_counter(struct ieee80211_vif *vif)
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
@@ -3333,7 +3339,7 @@ __ieee80211_beacon_get(struct ieee80211_hw *hw,
 		if (beacon) {
 			if (beacon->csa_counter_offsets[0]) {
 				if (!is_template)
-					ieee80211_csa_update_counter(vif);
+					__ieee80211_csa_update_counter(beacon);
 
 				ieee80211_set_csa(sdata, beacon);
 			}
@@ -3379,7 +3385,7 @@ __ieee80211_beacon_get(struct ieee80211_hw *hw,
 
 		if (beacon->csa_counter_offsets[0]) {
 			if (!is_template)
-				ieee80211_csa_update_counter(vif);
+				__ieee80211_csa_update_counter(beacon);
 
 			ieee80211_set_csa(sdata, beacon);
 		}
@@ -3409,7 +3415,7 @@ __ieee80211_beacon_get(struct ieee80211_hw *hw,
 				 * for now we leave it consistent with overall
 				 * mac80211's behavior.
 				 */
-				ieee80211_csa_update_counter(vif);
+				__ieee80211_csa_update_counter(beacon);
 
 			ieee80211_set_csa(sdata, beacon);
 		}
-- 
1.9.1

