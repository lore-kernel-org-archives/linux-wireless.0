Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.codeaurora.org ([198.145.29.96]:49702 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S932278AbeGII6L (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 9 Jul 2018 04:58:11 -0400
From: Manikanta Pubbisetty <mpubbise@codeaurora.org>
To: johannes@sipsolutions.net
Cc: linux-wireless@vger.kernel.org,
        Manikanta Pubbisetty <mpubbise@codeaurora.org>
Subject: [PATCH] mac80211: restrict delayed tailroom needed decrement
Date: Mon,  9 Jul 2018 14:28:01 +0530
Message-Id: <1531126681-5146-1-git-send-email-mpubbise@codeaurora.org> (sfid-20180709_105818_675395_65E92141)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

As explained in ieee80211_delayed_tailroom_dec(), during roam,
keys of the old AP will be destroyed and new keys will be
installed. Deletion of the old key causes
crypto_tx_tailroom_needed_cnt to go from 1 to 0 and the new key
installation causes a transition from 0 to 1.

Whenever crypto_tx_tailroom_needed_cnt transitions from 0 to 1,
we invoke synchronize_net(); the reason for doing this is to avoid
a race in the TX path as explained in increment_tailroom_need_count().
This synchronize_net() operation can be slow and can affect the station
roam time. To avoid this, decrementing the crypto_tx_tailroom_needed_cnt
is delayed for a while so that upon installation of new key the
transition would be from 1 to 2 instead of 0 to 1 and thereby
improving the roam time.

This is all correct for a STA iftype, but deferring the tailroom_needed
decrement for other iftypes may be incorrect.

For example, let's consider the case of a 4-addr client connecting to
an AP for which AP_VLAN interface is also created, let the initial
value for tailroom_needed on the AP be 1.

* 4-addr client connects to the AP (AP: tailroom_needed = 1)
* AP will clear old keys, delay decrement of tailroom_needed count
* AP_VLAN is created, it takes the tailroom count from master
  (AP_VLAN: tailroom_needed = 1, AP: tailroom_needed = 1)
* Install new key for the station, assume key is plumbed in the HW,
  there won't be any change in tailroom_needed count on AP iface
* Delayed decrement of tailroom_needed count on AP
  (AP: tailroom_needed = 0, AP_VLAN: tailroom_needed = 1)

Because of the delayed decrement on AP iface, tailroom_needed count goes
out of sync between AP(master iface) and AP_VLAN(slave iface) and
there would be unnecessary tailroom created for the packets going
through AP_VLAN iface.

Restricting delayed decrement to station interface alone fixes the problem
and it makes sense to do so because delayed decrement is done to improve
roam time which is applicable only for client devices.

Signed-off-by: Manikanta Pubbisetty <mpubbise@codeaurora.org>
---
 net/mac80211/key.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/net/mac80211/key.c b/net/mac80211/key.c
index ee0d0cc..d1ea86a 100644
--- a/net/mac80211/key.c
+++ b/net/mac80211/key.c
@@ -583,7 +583,8 @@ static void __ieee80211_key_destroy(struct ieee80211_key *key,
 
 		ieee80211_debugfs_key_remove(key);
 
-		if (delay_tailroom) {
+		if (delay_tailroom &&
+		    sdata->vif.type == NL80211_IFTYPE_STATION) {
 			/* see ieee80211_delayed_tailroom_dec */
 			sdata->crypto_tx_tailroom_pending_dec++;
 			schedule_delayed_work(&sdata->dec_tailroom_needed_wk,
-- 
2.7.4
