Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga09.intel.com ([134.134.136.24]:31025 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750907AbaFEQ3q (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 5 Jun 2014 12:29:46 -0400
From: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
To: johannes@sipsolutions.net
Cc: linux-wireless@vger.kernel.org,
	Luciano Coelho <luciano.coelho@intel.com>,
	Emmanuel Grumbach <emmanuel.grumbach@intel.com>
Subject: [PATCH 3/3] mac80211: stop only the queues assigned to the vif during channel switch
Date: Thu,  5 Jun 2014 19:26:07 +0300
Message-Id: <1401985567-27336-3-git-send-email-emmanuel.grumbach@intel.com> (sfid-20140605_182949_680495_AEE16D6B)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Luciano Coelho <luciano.coelho@intel.com>

Instead of stopping all the hardware queues during channel switch,
which is especially bad when we have large CSA counts, stop only the
queues that are assigned to the vif that is performing the channel
switch.

Signed-off-by: Luciano Coelho <luciano.coelho@intel.com>
Signed-off-by: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
---
 net/mac80211/cfg.c   | 10 ++++------
 net/mac80211/iface.c |  5 ++---
 net/mac80211/mlme.c  | 20 ++++++++------------
 3 files changed, 14 insertions(+), 21 deletions(-)

diff --git a/net/mac80211/cfg.c b/net/mac80211/cfg.c
index c6fe358..5215abb 100644
--- a/net/mac80211/cfg.c
+++ b/net/mac80211/cfg.c
@@ -1142,9 +1142,8 @@ static int ieee80211_stop_ap(struct wiphy *wiphy, struct net_device *dev)
 	mutex_lock(&local->mtx);
 	sdata->vif.csa_active = false;
 	if (!ieee80211_csa_needs_block_tx(local))
-		ieee80211_wake_queues_by_reason(&local->hw,
-					IEEE80211_MAX_QUEUE_MAP,
-					IEEE80211_QUEUE_STOP_REASON_CSA);
+		ieee80211_wake_vif_queues(local, sdata,
+					  IEEE80211_QUEUE_STOP_REASON_CSA);
 	mutex_unlock(&local->mtx);
 
 	kfree(sdata->u.ap.next_beacon);
@@ -3146,9 +3145,8 @@ static int __ieee80211_csa_finalize(struct ieee80211_sub_if_data *sdata)
 	cfg80211_ch_switch_notify(sdata->dev, &sdata->csa_chandef);
 
 	if (!ieee80211_csa_needs_block_tx(local))
-		ieee80211_wake_queues_by_reason(&local->hw,
-					IEEE80211_MAX_QUEUE_MAP,
-					IEEE80211_QUEUE_STOP_REASON_CSA);
+		ieee80211_wake_vif_queues(local, sdata,
+					  IEEE80211_QUEUE_STOP_REASON_CSA);
 
 	return 0;
 }
diff --git a/net/mac80211/iface.c b/net/mac80211/iface.c
index 9b9d804..c7417db 100644
--- a/net/mac80211/iface.c
+++ b/net/mac80211/iface.c
@@ -842,9 +842,8 @@ static void ieee80211_do_stop(struct ieee80211_sub_if_data *sdata,
 	mutex_lock(&local->mtx);
 	sdata->vif.csa_active = false;
 	if (!ieee80211_csa_needs_block_tx(local))
-		ieee80211_wake_queues_by_reason(&local->hw,
-					IEEE80211_MAX_QUEUE_MAP,
-					IEEE80211_QUEUE_STOP_REASON_CSA);
+		ieee80211_wake_vif_queues(local, sdata,
+					  IEEE80211_QUEUE_STOP_REASON_CSA);
 	mutex_unlock(&local->mtx);
 	sdata_unlock(sdata);
 
diff --git a/net/mac80211/mlme.c b/net/mac80211/mlme.c
index 003d17e..2d3b3a5 100644
--- a/net/mac80211/mlme.c
+++ b/net/mac80211/mlme.c
@@ -993,9 +993,8 @@ static void ieee80211_chswitch_work(struct work_struct *work)
 	sdata->vif.csa_active = false;
 	/* XXX: wait for a beacon first? */
 	if (!ieee80211_csa_needs_block_tx(local))
-		ieee80211_wake_queues_by_reason(&local->hw,
-					IEEE80211_MAX_QUEUE_MAP,
-					IEEE80211_QUEUE_STOP_REASON_CSA);
+		ieee80211_wake_vif_queues(local, sdata,
+					  IEEE80211_QUEUE_STOP_REASON_CSA);
 	mutex_unlock(&local->mtx);
 
 	ieee80211_bss_info_change_notify(sdata, changed);
@@ -1109,9 +1108,8 @@ ieee80211_sta_process_chanswitch(struct ieee80211_sub_if_data *sdata,
 	sdata->csa_block_tx = csa_ie.mode;
 
 	if (sdata->csa_block_tx)
-		ieee80211_stop_queues_by_reason(&local->hw,
-					IEEE80211_MAX_QUEUE_MAP,
-					IEEE80211_QUEUE_STOP_REASON_CSA);
+		ieee80211_stop_vif_queues(local, sdata,
+					  IEEE80211_QUEUE_STOP_REASON_CSA);
 	mutex_unlock(&local->mtx);
 
 	cfg80211_ch_switch_started_notify(sdata->dev, &csa_ie.chandef,
@@ -1830,9 +1828,8 @@ static void ieee80211_set_disassoc(struct ieee80211_sub_if_data *sdata,
 
 	sdata->vif.csa_active = false;
 	if (!ieee80211_csa_needs_block_tx(local))
-		ieee80211_wake_queues_by_reason(&local->hw,
-					IEEE80211_MAX_QUEUE_MAP,
-					IEEE80211_QUEUE_STOP_REASON_CSA);
+		ieee80211_wake_vif_queues(local, sdata,
+					  IEEE80211_QUEUE_STOP_REASON_CSA);
 	mutex_unlock(&local->mtx);
 
 	sdata->encrypt_headroom = IEEE80211_ENCRYPT_HEADROOM;
@@ -2078,9 +2075,8 @@ static void __ieee80211_disconnect(struct ieee80211_sub_if_data *sdata)
 	mutex_lock(&local->mtx);
 	sdata->vif.csa_active = false;
 	if (!ieee80211_csa_needs_block_tx(local))
-		ieee80211_wake_queues_by_reason(&local->hw,
-					IEEE80211_MAX_QUEUE_MAP,
-					IEEE80211_QUEUE_STOP_REASON_CSA);
+		ieee80211_wake_vif_queues(local, sdata,
+					  IEEE80211_QUEUE_STOP_REASON_CSA);
 	mutex_unlock(&local->mtx);
 
 	cfg80211_tx_mlme_mgmt(sdata->dev, frame_buf,
-- 
1.9.1

