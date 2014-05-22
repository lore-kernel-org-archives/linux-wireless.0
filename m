Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ee0-f45.google.com ([74.125.83.45]:38947 "EHLO
	mail-ee0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752402AbaEVNfc (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 22 May 2014 09:35:32 -0400
Received: by mail-ee0-f45.google.com with SMTP id d49so2662347eek.4
        for <linux-wireless@vger.kernel.org>; Thu, 22 May 2014 06:35:30 -0700 (PDT)
From: Michal Kazior <michal.kazior@tieto.com>
To: linux-wireless@vger.kernel.org
Cc: johannes@sipsolutions.net, Michal Kazior <michal.kazior@tieto.com>
Subject: [PATCH 3/3] mac80211: make csa_currnet_counter atomic
Date: Thu, 22 May 2014 15:28:14 +0200
Message-Id: <1400765294-14732-4-git-send-email-michal.kazior@tieto.com> (sfid-20140522_153537_708185_5299451A)
In-Reply-To: <1400765294-14732-1-git-send-email-michal.kazior@tieto.com>
References: <1400765294-14732-1-git-send-email-michal.kazior@tieto.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Even it ieee80211_beacon_get() and
ieee80211_csa_update_counter() were to be
guaranteed to be serialized by drivers it still
couldn't be guaranteed to be safe on SMP systems.

Signed-off-by: Michal Kazior <michal.kazior@tieto.com>
---
 net/mac80211/cfg.c         | 12 +++++++-----
 net/mac80211/ieee80211_i.h |  2 +-
 net/mac80211/tx.c          | 11 ++++++-----
 3 files changed, 14 insertions(+), 11 deletions(-)

diff --git a/net/mac80211/cfg.c b/net/mac80211/cfg.c
index 0518268..aab258b 100644
--- a/net/mac80211/cfg.c
+++ b/net/mac80211/cfg.c
@@ -938,7 +938,7 @@ static int ieee80211_assign_beacon(struct ieee80211_sub_if_data *sdata,
 	new->tail = new->head + new_head_len;
 	new->head_len = new_head_len;
 	new->tail_len = new_tail_len;
-	new->csa_current_counter = csa_count;
+	atomic_set(&new->csa_current_counter, csa_count);
 	memcpy(new->csa_counter_offset, csa_counter_offset_beacon,
 	       n_csa_counter_offset_beacon * sizeof(*new->csa_counter_offset));
 
@@ -3508,7 +3508,6 @@ static int ieee80211_mgmt_tx(struct wiphy *wiphy, struct wireless_dev *wdev,
 	    (sdata->vif.type == NL80211_IFTYPE_AP ||
 	     sdata->vif.type == NL80211_IFTYPE_ADHOC) &&
 	    params->n_csa_offsets) {
-		int i;
 		struct beacon_data *beacon = NULL;
 
 		rcu_read_lock();
@@ -3520,10 +3519,13 @@ static int ieee80211_mgmt_tx(struct wiphy *wiphy, struct wireless_dev *wdev,
 		else if (ieee80211_vif_is_mesh(&sdata->vif))
 			beacon = rcu_dereference(sdata->u.mesh.beacon);
 
-		if (beacon)
+		if (beacon) {
+			u8 count = atomic_read(&beacon->csa_current_counter);
+			int i;
+
 			for (i = 0; i < params->n_csa_offsets; i++)
-				data[params->csa_offsets[i]] =
-					beacon->csa_current_counter;
+				data[params->csa_offsets[i]] = count;
+		}
 
 		rcu_read_unlock();
 	}
diff --git a/net/mac80211/ieee80211_i.h b/net/mac80211/ieee80211_i.h
index 71915a2..69da2d6 100644
--- a/net/mac80211/ieee80211_i.h
+++ b/net/mac80211/ieee80211_i.h
@@ -234,7 +234,7 @@ struct beacon_data {
 	int head_len, tail_len;
 	struct ieee80211_meshconf_ie *meshconf;
 	u16 csa_counter_offset[IEEE80211_MAX_CSA_COUNTERS_NUM];
-	u8 csa_current_counter;
+	atomic_t csa_current_counter;
 	struct rcu_head rcu_head;
 };
 
diff --git a/net/mac80211/tx.c b/net/mac80211/tx.c
index eeeafeb..af59877 100644
--- a/net/mac80211/tx.c
+++ b/net/mac80211/tx.c
@@ -2423,7 +2423,7 @@ static void ieee80211_set_csa(struct ieee80211_sub_if_data *sdata,
 	u8 *beacon_data;
 	size_t beacon_data_len;
 	int i;
-	u8 count = beacon->csa_current_counter;
+	u8 count = atomic_read(&beacon->csa_current_counter);
 
 	switch (sdata->vif.type) {
 	case NL80211_IFTYPE_AP:
@@ -2481,11 +2481,12 @@ u8 ieee80211_csa_update_counter(struct ieee80211_vif *vif)
 	if (!beacon)
 		goto unlock;
 
-	beacon->csa_current_counter--;
-
+	count = atomic_dec_return(&beacon->csa_current_counter);
 	/* the counter should never reach 0 */
-	WARN_ON_ONCE(!beacon->csa_current_counter);
-	count = beacon->csa_current_counter;
+	if (WARN_ON_ONCE(count <= 0)) {
+		/* prevent it from going negative */
+		atomic_inc(&beacon->csa_current_counter);
+	}
 
 unlock:
 	rcu_read_unlock();
-- 
1.8.5.3

