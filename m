Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.neomailbox.net ([178.209.62.157]:2377 "EHLO
	s3.neomailbox.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755203Ab3LJQkt (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 10 Dec 2013 11:40:49 -0500
From: Antonio Quartulli <antonio@meshcoding.com>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: linux-wireless@vger.kernel.org,
	Antonio Quartulli <antonio@open-mesh.com>
Subject: [RFC 1/2] mac80211: iterate over vif using RCU
Date: Tue, 10 Dec 2013 17:39:57 +0100
Message-Id: <1386693598-3934-1-git-send-email-antonio@meshcoding.com> (sfid-20131210_174104_858179_2F93B153)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Antonio Quartulli <antonio@open-mesh.com>

I need to invoke ieee80211_iter_keys() from a periodic worker in a driver and
therefore I would prefer to get rid of any of locks to avoid problems.
These two patches try to use rcu lock to protect the iteration, but I'd like to
get a feedback before sending this stuff as a patch :-)

Moreover, why do we use list_for_each_entry_safe() is ieee80211_iter_keys() if
the list cannot be altered (pointer to key is not passed to iter() so we should
be sure that nobody is going to invoke list_del())?

Cheers,


In ieee80211_iter_keys the local->interfaces list is
accessed for reading only. RCU can be used instead
of pretending to be under RTNL lock.

This can simplify future users of this function.

Signed-off-by: Antonio Quartulli <antonio@open-mesh.com>
---
 net/mac80211/key.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/net/mac80211/key.c b/net/mac80211/key.c
index 3e51dd7..04c885a 100644
--- a/net/mac80211/key.c
+++ b/net/mac80211/key.c
@@ -550,8 +550,6 @@ void ieee80211_iter_keys(struct ieee80211_hw *hw,
 	struct ieee80211_key *key, *tmp;
 	struct ieee80211_sub_if_data *sdata;
 
-	ASSERT_RTNL();
-
 	mutex_lock(&local->key_mtx);
 	if (vif) {
 		sdata = vif_to_sdata(vif);
@@ -560,12 +558,14 @@ void ieee80211_iter_keys(struct ieee80211_hw *hw,
 			     key->sta ? &key->sta->sta : NULL,
 			     &key->conf, iter_data);
 	} else {
-		list_for_each_entry(sdata, &local->interfaces, list)
+		rcu_read_lock();
+		list_for_each_entry_rcu(sdata, &local->interfaces, list)
 			list_for_each_entry_safe(key, tmp,
 						 &sdata->key_list, list)
 				iter(hw, &sdata->vif,
 				     key->sta ? &key->sta->sta : NULL,
 				     &key->conf, iter_data);
+		rcu_read_unlock();
 	}
 	mutex_unlock(&local->key_mtx);
 }
-- 
1.8.5.1

