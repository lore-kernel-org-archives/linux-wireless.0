Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.codeaurora.org ([198.145.29.96]:36758 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751992AbeGJLSt (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 10 Jul 2018 07:18:49 -0400
From: Manikanta Pubbisetty <mpubbise@codeaurora.org>
To: johannes@sipsolutions.net
Cc: linux-wireless@vger.kernel.org,
        Manikanta Pubbisetty <mpubbise@codeaurora.org>
Subject: [PATCHv2] mac80211: restrict delayed tailroom needed decrement
Date: Tue, 10 Jul 2018 16:48:27 +0530
Message-Id: <1531221507-28610-1-git-send-email-mpubbise@codeaurora.org> (sfid-20180710_131853_218970_FAC5641A)
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
decrement for other iftypes may be unnecessary.

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

Also, WARN_ONs were observed while trying to bring down the AP_VLAN
interface:
(warn_slowpath_common) (warn_slowpath_null+0x18/0x20)
(warn_slowpath_null) (ieee80211_free_keys+0x114/0x1e4)
(ieee80211_free_keys) (ieee80211_del_virtual_monitor+0x51c/0x850)
(ieee80211_del_virtual_monitor) (ieee80211_stop+0x30/0x3c)
(ieee80211_stop) (__dev_close_many+0x94/0xb8)
(__dev_close_many) (dev_close_many+0x5c/0xc8)

Restricting delayed decrement to station interface alone fixes the problem
and it makes sense to do so because delayed decrement is done to improve
roam time which is applicable only for client devices.

Signed-off-by: Manikanta Pubbisetty <mpubbise@codeaurora.org>
---
V2:
	* Updated commit log
	* Addressed V1 comments

 net/mac80211/cfg.c |  2 +-
 net/mac80211/key.c | 13 ++++++++-----
 2 files changed, 9 insertions(+), 6 deletions(-)

diff --git a/net/mac80211/cfg.c b/net/mac80211/cfg.c
index 02f3672..d25da0e 100644
--- a/net/mac80211/cfg.c
+++ b/net/mac80211/cfg.c
@@ -495,7 +495,7 @@ static int ieee80211_del_key(struct wiphy *wiphy, struct net_device *dev,
 		goto out_unlock;
 	}
 
-	ieee80211_key_free(key, true);
+	ieee80211_key_free(key, sdata->vif.type == NL80211_IFTYPE_STATION);
 
 	ret = 0;
  out_unlock:
diff --git a/net/mac80211/key.c b/net/mac80211/key.c
index ee0d0cc..f7e4c2d 100644
--- a/net/mac80211/key.c
+++ b/net/mac80211/key.c
@@ -657,9 +657,10 @@ int ieee80211_key_link(struct ieee80211_key *key,
 	struct ieee80211_local *local = sdata->local;
 	struct ieee80211_key *old_key;
 	int idx, ret;
-	bool pairwise;
+	bool pairwise, iftype_sta;
 
 	pairwise = key->conf.flags & IEEE80211_KEY_FLAG_PAIRWISE;
+	iftype_sta  =  sdata->vif.type == NL80211_IFTYPE_STATION;
 	idx = key->conf.keyidx;
 
 	mutex_lock(&sdata->local->key_mtx);
@@ -688,14 +689,14 @@ int ieee80211_key_link(struct ieee80211_key *key,
 	increment_tailroom_need_count(sdata);
 
 	ieee80211_key_replace(sdata, sta, pairwise, old_key, key);
-	ieee80211_key_destroy(old_key, true);
+	ieee80211_key_destroy(old_key, iftype_sta);
 
 	ieee80211_debugfs_key_add(key);
 
 	if (!local->wowlan) {
 		ret = ieee80211_key_enable_hw_accel(key);
 		if (ret)
-			ieee80211_key_free(key, true);
+			ieee80211_key_free(key, iftype_sta);
 	} else {
 		ret = 0;
 	}
@@ -930,7 +931,8 @@ void ieee80211_free_sta_keys(struct ieee80211_local *local,
 		ieee80211_key_replace(key->sdata, key->sta,
 				key->conf.flags & IEEE80211_KEY_FLAG_PAIRWISE,
 				key, NULL);
-		__ieee80211_key_destroy(key, true);
+		__ieee80211_key_destroy(key, key->sdata->vif.type ==
+					NL80211_IFTYPE_STATION);
 	}
 
 	for (i = 0; i < NUM_DEFAULT_KEYS; i++) {
@@ -940,7 +942,8 @@ void ieee80211_free_sta_keys(struct ieee80211_local *local,
 		ieee80211_key_replace(key->sdata, key->sta,
 				key->conf.flags & IEEE80211_KEY_FLAG_PAIRWISE,
 				key, NULL);
-		__ieee80211_key_destroy(key, true);
+		__ieee80211_key_destroy(key, key->sdata->vif.type ==
+					NL80211_IFTYPE_STATION);
 	}
 
 	mutex_unlock(&local->key_mtx);
-- 
2.7.4
