Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from emh03.mail.saunalahti.fi ([62.142.5.109]:45501 "EHLO
	emh03.mail.saunalahti.fi" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755295Ab1FMWi1 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 13 Jun 2011 18:38:27 -0400
Received: from saunalahti-vams (vs3-10.mail.saunalahti.fi [62.142.5.94])
	by emh03-2.mail.saunalahti.fi (Postfix) with SMTP id BF6B5EB285
	for <linux-wireless@vger.kernel.org>; Tue, 14 Jun 2011 01:38:25 +0300 (EEST)
Received: from localhost6.localdomain6 (a88-115-184-248.elisa-laajakaista.fi [88.115.184.248])
	by emh02.mail.saunalahti.fi (Postfix) with ESMTP id 94E092BD42
	for <linux-wireless@vger.kernel.org>; Tue, 14 Jun 2011 01:38:24 +0300 (EEST)
Subject: [PATCH v2 26/27] mac80211: change queue stop reasons to use mac80211
	prefix
To: linux-wireless@vger.kernel.org
From: Kalle Valo <kvalo@adurom.com>
Date: Tue, 14 Jun 2011 01:38:24 +0300
Message-ID: <20110613223824.10517.39092.stgit@localhost6.localdomain6> (sfid-20110614_005724_054514_AA0E8310)
In-Reply-To: <20110613223029.10517.52197.stgit@localhost6.localdomain6>
References: <20110613223029.10517.52197.stgit@localhost6.localdomain6>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Signed-off-by: Kalle Valo <kvalo@adurom.com>
---
 net/mac80211/agg-tx.c     |    4 ++--
 net/mac80211/mac80211_i.h |   12 ++++++------
 net/mac80211/main.c       |    2 +-
 net/mac80211/mlme.c       |   14 ++++++++++----
 net/mac80211/pm.c         |    2 +-
 net/mac80211/tx.c         |    2 +-
 net/mac80211/util.c       |   18 +++++++++---------
 7 files changed, 30 insertions(+), 24 deletions(-)

diff --git a/net/mac80211/agg-tx.c b/net/mac80211/agg-tx.c
index 0d772a6..b6f3998 100644
--- a/net/mac80211/agg-tx.c
+++ b/net/mac80211/agg-tx.c
@@ -268,7 +268,7 @@ ieee80211_stop_queue_agg(struct mac80211_local *local, int tid)
 	if (atomic_inc_return(&local->agg_queue_stop[queue]) == 1)
 		ieee80211_stop_queue_by_reason(
 			&local->hw, queue,
-			IEEE80211_QUEUE_STOP_REASON_AGGREGATION);
+			MAC80211_QUEUE_STOP_REASON_AGGREGATION);
 	__acquire(agg_queue);
 }
 
@@ -280,7 +280,7 @@ ieee80211_wake_queue_agg(struct mac80211_local *local, int tid)
 	if (atomic_dec_return(&local->agg_queue_stop[queue]) == 0)
 		ieee80211_wake_queue_by_reason(
 			&local->hw, queue,
-			IEEE80211_QUEUE_STOP_REASON_AGGREGATION);
+			MAC80211_QUEUE_STOP_REASON_AGGREGATION);
 	__release(agg_queue);
 }
 
diff --git a/net/mac80211/mac80211_i.h b/net/mac80211/mac80211_i.h
index d0ca2f5..1b3d0fb 100644
--- a/net/mac80211/mac80211_i.h
+++ b/net/mac80211/mac80211_i.h
@@ -633,12 +633,12 @@ enum {
 };
 
 enum queue_stop_reason {
-	IEEE80211_QUEUE_STOP_REASON_DRIVER,
-	IEEE80211_QUEUE_STOP_REASON_PS,
-	IEEE80211_QUEUE_STOP_REASON_CSA,
-	IEEE80211_QUEUE_STOP_REASON_AGGREGATION,
-	IEEE80211_QUEUE_STOP_REASON_SUSPEND,
-	IEEE80211_QUEUE_STOP_REASON_SKB_ADD,
+	MAC80211_QUEUE_STOP_REASON_DRIVER,
+	MAC80211_QUEUE_STOP_REASON_PS,
+	MAC80211_QUEUE_STOP_REASON_CSA,
+	MAC80211_QUEUE_STOP_REASON_AGGREGATION,
+	MAC80211_QUEUE_STOP_REASON_SUSPEND,
+	MAC80211_QUEUE_STOP_REASON_SKB_ADD,
 };
 
 #ifdef CONFIG_MAC80211_LEDS
diff --git a/net/mac80211/main.c b/net/mac80211/main.c
index a59821e..d9db197 100644
--- a/net/mac80211/main.c
+++ b/net/mac80211/main.c
@@ -380,7 +380,7 @@ void ieee80211_restart_hw(struct ieee80211_hw *hw)
 
 	/* use this reason, ieee80211_reconfig will unblock it */
 	ieee80211_stop_queues_by_reason(hw,
-		IEEE80211_QUEUE_STOP_REASON_SUSPEND);
+		MAC80211_QUEUE_STOP_REASON_SUSPEND);
 
 	schedule_work(&local->restart_work);
 }
diff --git a/net/mac80211/mlme.c b/net/mac80211/mlme.c
index 46bc4db..b92dbda 100644
--- a/net/mac80211/mlme.c
+++ b/net/mac80211/mlme.c
@@ -232,6 +232,9 @@ static u32 ieee80211_enable_ht(struct mac80211_sub_if_data *sdata,
 		WARN_ON(!ieee80211_set_channel_type(local, sdata, channel_type));
 	}
 
+	ieee80211_stop_queues_by_reason(&sdata->local->hw,
+					MAC80211_QUEUE_STOP_REASON_CSA);
+
 	/* channel_type change automatically detected */
 	ieee80211_hw_config(local, 0);
 
@@ -245,6 +248,9 @@ static u32 ieee80211_enable_ht(struct mac80211_sub_if_data *sdata,
 		rcu_read_unlock();
 	}
 
+	ieee80211_wake_queues_by_reason(&sdata->local->hw,
+					MAC80211_QUEUE_STOP_REASON_CSA);
+
 	ht_opmode = le16_to_cpu(hti->operation_mode);
 
 	/* if bss configuration changed store the new one */
@@ -400,7 +406,7 @@ static void ieee80211_chswitch_work(struct work_struct *work)
 	ifmgd->associated->channel = sdata->local->oper_channel;
 
 	ieee80211_wake_queues_by_reason(&sdata->local->hw,
-					IEEE80211_QUEUE_STOP_REASON_CSA);
+					MAC80211_QUEUE_STOP_REASON_CSA);
  out:
 	ifmgd->flags &= ~MAC80211_STA_CSA_RECEIVED;
 	mutex_unlock(&ifmgd->mtx);
@@ -483,7 +489,7 @@ void ieee80211_sta_process_chanswitch(struct mac80211_sub_if_data *sdata,
 		if (sw_elem->mode) {
 			ch_switch.block_tx = true;
 			ieee80211_stop_queues_by_reason(&sdata->local->hw,
-					IEEE80211_QUEUE_STOP_REASON_CSA);
+					MAC80211_QUEUE_STOP_REASON_CSA);
 		}
 		ch_switch.channel = new_ch;
 		ch_switch.count = sw_elem->count;
@@ -498,7 +504,7 @@ void ieee80211_sta_process_chanswitch(struct mac80211_sub_if_data *sdata,
 	} else {
 		if (sw_elem->mode)
 			ieee80211_stop_queues_by_reason(&sdata->local->hw,
-					IEEE80211_QUEUE_STOP_REASON_CSA);
+					MAC80211_QUEUE_STOP_REASON_CSA);
 		ifmgd->flags |= MAC80211_STA_CSA_RECEIVED;
 		mod_timer(&ifmgd->chswitch_timer,
 			  jiffies +
@@ -740,7 +746,7 @@ void ieee80211_dynamic_ps_disable_work(struct work_struct *work)
 	}
 
 	ieee80211_wake_queues_by_reason(&local->hw,
-					IEEE80211_QUEUE_STOP_REASON_PS);
+					MAC80211_QUEUE_STOP_REASON_PS);
 }
 
 void ieee80211_dynamic_ps_enable_work(struct work_struct *work)
diff --git a/net/mac80211/pm.c b/net/mac80211/pm.c
index 47505f0..e41aa9e 100644
--- a/net/mac80211/pm.c
+++ b/net/mac80211/pm.c
@@ -24,7 +24,7 @@ int __ieee80211_suspend(struct ieee80211_hw *hw, struct cfg80211_wowlan *wowlan)
 	}
 
 	ieee80211_stop_queues_by_reason(hw,
-			IEEE80211_QUEUE_STOP_REASON_SUSPEND);
+			MAC80211_QUEUE_STOP_REASON_SUSPEND);
 
 	/* flush out all packets */
 	synchronize_net();
diff --git a/net/mac80211/tx.c b/net/mac80211/tx.c
index e43e34b..ea0f76a 100644
--- a/net/mac80211/tx.c
+++ b/net/mac80211/tx.c
@@ -231,7 +231,7 @@ ieee80211_tx_h_dynamic_ps(struct mac80211_tx_data *tx)
 
 	if (local->hw.conf.flags & IEEE80211_CONF_PS) {
 		ieee80211_stop_queues_by_reason(&local->hw,
-						IEEE80211_QUEUE_STOP_REASON_PS);
+						MAC80211_QUEUE_STOP_REASON_PS);
 		ifmgd->flags &= ~MAC80211_STA_NULLFUNC_ACKED;
 		ieee80211_queue_work(&local->hw,
 				     &local->dynamic_ps_disable_work);
diff --git a/net/mac80211/util.c b/net/mac80211/util.c
index 7e1514c..65b0367 100644
--- a/net/mac80211/util.c
+++ b/net/mac80211/util.c
@@ -307,7 +307,7 @@ void ieee80211_wake_queue_by_reason(struct ieee80211_hw *hw, int queue,
 void ieee80211_wake_queue(struct ieee80211_hw *hw, int queue)
 {
 	ieee80211_wake_queue_by_reason(hw, queue,
-				       IEEE80211_QUEUE_STOP_REASON_DRIVER);
+				       MAC80211_QUEUE_STOP_REASON_DRIVER);
 }
 EXPORT_SYMBOL(ieee80211_wake_queue);
 
@@ -344,7 +344,7 @@ void ieee80211_stop_queue_by_reason(struct ieee80211_hw *hw, int queue,
 void ieee80211_stop_queue(struct ieee80211_hw *hw, int queue)
 {
 	ieee80211_stop_queue_by_reason(hw, queue,
-				       IEEE80211_QUEUE_STOP_REASON_DRIVER);
+				       MAC80211_QUEUE_STOP_REASON_DRIVER);
 }
 EXPORT_SYMBOL(ieee80211_stop_queue);
 
@@ -362,9 +362,9 @@ void ieee80211_add_pending_skb(struct mac80211_local *local,
 	}
 
 	spin_lock_irqsave(&local->queue_stop_reason_lock, flags);
-	__ieee80211_stop_queue(hw, queue, IEEE80211_QUEUE_STOP_REASON_SKB_ADD);
+	__ieee80211_stop_queue(hw, queue, MAC80211_QUEUE_STOP_REASON_SKB_ADD);
 	__skb_queue_tail(&local->pending[queue], skb);
-	__ieee80211_wake_queue(hw, queue, IEEE80211_QUEUE_STOP_REASON_SKB_ADD);
+	__ieee80211_wake_queue(hw, queue, MAC80211_QUEUE_STOP_REASON_SKB_ADD);
 	spin_unlock_irqrestore(&local->queue_stop_reason_lock, flags);
 }
 
@@ -380,7 +380,7 @@ int ieee80211_add_pending_skbs_fn(struct mac80211_local *local,
 	spin_lock_irqsave(&local->queue_stop_reason_lock, flags);
 	for (i = 0; i < hw->queues; i++)
 		__ieee80211_stop_queue(hw, i,
-			IEEE80211_QUEUE_STOP_REASON_SKB_ADD);
+			MAC80211_QUEUE_STOP_REASON_SKB_ADD);
 
 	while ((skb = skb_dequeue(skbs))) {
 		struct ieee80211_tx_info *info = IEEE80211_SKB_CB(skb);
@@ -400,7 +400,7 @@ int ieee80211_add_pending_skbs_fn(struct mac80211_local *local,
 
 	for (i = 0; i < hw->queues; i++)
 		__ieee80211_wake_queue(hw, i,
-			IEEE80211_QUEUE_STOP_REASON_SKB_ADD);
+			MAC80211_QUEUE_STOP_REASON_SKB_ADD);
 	spin_unlock_irqrestore(&local->queue_stop_reason_lock, flags);
 
 	return ret;
@@ -430,7 +430,7 @@ void ieee80211_stop_queues_by_reason(struct ieee80211_hw *hw,
 void ieee80211_stop_queues(struct ieee80211_hw *hw)
 {
 	ieee80211_stop_queues_by_reason(hw,
-					IEEE80211_QUEUE_STOP_REASON_DRIVER);
+					MAC80211_QUEUE_STOP_REASON_DRIVER);
 }
 EXPORT_SYMBOL(ieee80211_stop_queues);
 
@@ -467,7 +467,7 @@ void ieee80211_wake_queues_by_reason(struct ieee80211_hw *hw,
 
 void ieee80211_wake_queues(struct ieee80211_hw *hw)
 {
-	ieee80211_wake_queues_by_reason(hw, IEEE80211_QUEUE_STOP_REASON_DRIVER);
+	ieee80211_wake_queues_by_reason(hw, MAC80211_QUEUE_STOP_REASON_DRIVER);
 }
 EXPORT_SYMBOL(ieee80211_wake_queues);
 
@@ -1278,7 +1278,7 @@ int ieee80211_reconfig(struct mac80211_local *local)
 
  wake_up:
 	ieee80211_wake_queues_by_reason(hw,
-			IEEE80211_QUEUE_STOP_REASON_SUSPEND);
+			MAC80211_QUEUE_STOP_REASON_SUSPEND);
 
 	/*
 	 * If this is for hw restart things are still running.

