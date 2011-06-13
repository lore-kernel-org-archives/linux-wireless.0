Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from emh02.mail.saunalahti.fi ([62.142.5.108]:40523 "EHLO
	emh02.mail.saunalahti.fi" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755295Ab1FMWie (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 13 Jun 2011 18:38:34 -0400
Received: from saunalahti-vams (vs3-12.mail.saunalahti.fi [62.142.5.96])
	by emh02-2.mail.saunalahti.fi (Postfix) with SMTP id BE2D0EF664
	for <linux-wireless@vger.kernel.org>; Tue, 14 Jun 2011 01:38:32 +0300 (EEST)
Received: from localhost6.localdomain6 (a88-115-184-248.elisa-laajakaista.fi [88.115.184.248])
	by emh06.mail.saunalahti.fi (Postfix) with ESMTP id 4A04FE51A3
	for <linux-wireless@vger.kernel.org>; Tue, 14 Jun 2011 01:38:31 +0300 (EEST)
Subject: [PATCH v2 27/27] mac80211: use mac80211_hw
To: linux-wireless@vger.kernel.org
From: Kalle Valo <kvalo@adurom.com>
Date: Tue, 14 Jun 2011 01:38:30 +0300
Message-ID: <20110613223830.10517.79913.stgit@localhost6.localdomain6> (sfid-20110614_005722_683610_59BDB99C)
In-Reply-To: <20110613223029.10517.52197.stgit@localhost6.localdomain6>
References: <20110613223029.10517.52197.stgit@localhost6.localdomain6>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Signed-off-by: Kalle Valo <kvalo@adurom.com>
---
 net/mac80211/led.c                 |   10 ++++----
 net/mac80211/mac80211_i.h          |   22 +++++++++--------
 net/mac80211/main.c                |   14 +++++------
 net/mac80211/mlme.c                |    6 ++---
 net/mac80211/offchannel.c          |    4 ++-
 net/mac80211/pm.c                  |    2 +-
 net/mac80211/rc80211_minstrel.c    |    4 ++-
 net/mac80211/rc80211_minstrel.h    |    2 +-
 net/mac80211/rc80211_minstrel_ht.c |    4 ++-
 net/mac80211/rc80211_pid_algo.c    |    2 +-
 net/mac80211/rx.c                  |   18 +++++++-------
 net/mac80211/scan.c                |    8 +++---
 net/mac80211/sta_info.c            |    4 ++-
 net/mac80211/status.c              |    4 ++-
 net/mac80211/tx.c                  |   14 +++++------
 net/mac80211/util.c                |   46 ++++++++++++++++++------------------
 16 files changed, 82 insertions(+), 82 deletions(-)

diff --git a/net/mac80211/led.c b/net/mac80211/led.c
index 0d2fd97..2a14969 100644
--- a/net/mac80211/led.c
+++ b/net/mac80211/led.c
@@ -137,7 +137,7 @@ void ieee80211_led_exit(struct mac80211_local *local)
 	}
 }
 
-char *__ieee80211_get_radio_led_name(struct ieee80211_hw *hw)
+char *__ieee80211_get_radio_led_name(struct mac80211_hw *hw)
 {
 	struct mac80211_local *local = hw_to_local(hw);
 
@@ -145,7 +145,7 @@ char *__ieee80211_get_radio_led_name(struct ieee80211_hw *hw)
 }
 EXPORT_SYMBOL(__ieee80211_get_radio_led_name);
 
-char *__ieee80211_get_assoc_led_name(struct ieee80211_hw *hw)
+char *__ieee80211_get_assoc_led_name(struct mac80211_hw *hw)
 {
 	struct mac80211_local *local = hw_to_local(hw);
 
@@ -153,7 +153,7 @@ char *__ieee80211_get_assoc_led_name(struct ieee80211_hw *hw)
 }
 EXPORT_SYMBOL(__ieee80211_get_assoc_led_name);
 
-char *__ieee80211_get_tx_led_name(struct ieee80211_hw *hw)
+char *__ieee80211_get_tx_led_name(struct mac80211_hw *hw)
 {
 	struct mac80211_local *local = hw_to_local(hw);
 
@@ -161,7 +161,7 @@ char *__ieee80211_get_tx_led_name(struct ieee80211_hw *hw)
 }
 EXPORT_SYMBOL(__ieee80211_get_tx_led_name);
 
-char *__ieee80211_get_rx_led_name(struct ieee80211_hw *hw)
+char *__ieee80211_get_rx_led_name(struct mac80211_hw *hw)
 {
 	struct mac80211_local *local = hw_to_local(hw);
 
@@ -215,7 +215,7 @@ static void tpt_trig_timer(unsigned long data)
 	read_unlock(&tpt_trig->trig.leddev_list_lock);
 }
 
-char *__ieee80211_create_tpt_led_trigger(struct ieee80211_hw *hw,
+char *__ieee80211_create_tpt_led_trigger(struct mac80211_hw *hw,
 				unsigned int flags,
 				const struct ieee80211_tpt_blink *blink_table,
 				unsigned int blink_table_len)
diff --git a/net/mac80211/mac80211_i.h b/net/mac80211/mac80211_i.h
index 1b3d0fb..eeedef6 100644
--- a/net/mac80211/mac80211_i.h
+++ b/net/mac80211/mac80211_i.h
@@ -699,7 +699,7 @@ struct mac80211_local {
 	/* embed the driver visible part.
 	 * don't cast (use the static inlines below), but we keep
 	 * it first anyway so they become a no-op */
-	struct ieee80211_hw hw;
+	struct mac80211_hw hw;
 
 	const struct ieee80211_ops *ops;
 
@@ -1055,12 +1055,12 @@ struct ieee802_11_elems {
 };
 
 static inline struct mac80211_local *hw_to_local(
-	struct ieee80211_hw *hw)
+	struct mac80211_hw *hw)
 {
 	return container_of(hw, struct mac80211_local, hw);
 }
 
-static inline struct ieee80211_hw *local_to_hw(
+static inline struct mac80211_hw *local_to_hw(
 	struct mac80211_local *local)
 {
 	return &local->hw;
@@ -1266,10 +1266,10 @@ int ieee80211_reconfig(struct mac80211_local *local);
 void ieee80211_stop_device(struct mac80211_local *local);
 
 #ifdef CONFIG_PM
-int __ieee80211_suspend(struct ieee80211_hw *hw,
+int __ieee80211_suspend(struct mac80211_hw *hw,
 			struct cfg80211_wowlan *wowlan);
 
-static inline int __ieee80211_resume(struct ieee80211_hw *hw)
+static inline int __ieee80211_resume(struct mac80211_hw *hw)
 {
 	struct mac80211_local *local = hw_to_local(hw);
 
@@ -1280,13 +1280,13 @@ static inline int __ieee80211_resume(struct ieee80211_hw *hw)
 	return ieee80211_reconfig(hw_to_local(hw));
 }
 #else
-static inline int __ieee80211_suspend(struct ieee80211_hw *hw,
+static inline int __ieee80211_suspend(struct mac80211_hw *hw,
 				      struct cfg80211_wowlan *wowlan)
 {
 	return 0;
 }
 
-static inline int __ieee80211_resume(struct ieee80211_hw *hw)
+static inline int __ieee80211_resume(struct mac80211_hw *hw)
 {
 	return 0;
 }
@@ -1323,13 +1323,13 @@ void ieee80211_sta_tx_notify(struct mac80211_sub_if_data *sdata,
 			     struct ieee80211_hdr *hdr, bool ack);
 void ieee80211_beacon_connection_loss_work(struct work_struct *work);
 
-void ieee80211_wake_queues_by_reason(struct ieee80211_hw *hw,
+void ieee80211_wake_queues_by_reason(struct mac80211_hw *hw,
 				     enum queue_stop_reason reason);
-void ieee80211_stop_queues_by_reason(struct ieee80211_hw *hw,
+void ieee80211_stop_queues_by_reason(struct mac80211_hw *hw,
 				     enum queue_stop_reason reason);
-void ieee80211_wake_queue_by_reason(struct ieee80211_hw *hw, int queue,
+void ieee80211_wake_queue_by_reason(struct mac80211_hw *hw, int queue,
 				    enum queue_stop_reason reason);
-void ieee80211_stop_queue_by_reason(struct ieee80211_hw *hw, int queue,
+void ieee80211_stop_queue_by_reason(struct mac80211_hw *hw, int queue,
 				    enum queue_stop_reason reason);
 void ieee80211_add_pending_skb(struct mac80211_local *local,
 			       struct sk_buff *skb);
diff --git a/net/mac80211/main.c b/net/mac80211/main.c
index d9db197..7f03a3e 100644
--- a/net/mac80211/main.c
+++ b/net/mac80211/main.c
@@ -369,7 +369,7 @@ static void ieee80211_restart_work(struct work_struct *work)
 	rtnl_unlock();
 }
 
-void ieee80211_restart_hw(struct ieee80211_hw *hw)
+void ieee80211_restart_hw(struct mac80211_hw *hw)
 {
 	struct mac80211_local *local = hw_to_local(hw);
 
@@ -474,7 +474,7 @@ static int ieee80211_napi_poll(struct napi_struct *napi, int budget)
 	return local->ops->napi_poll(&local->hw, budget);
 }
 
-void ieee80211_napi_schedule(struct ieee80211_hw *hw)
+void ieee80211_napi_schedule(struct mac80211_hw *hw)
 {
 	struct mac80211_local *local = hw_to_local(hw);
 
@@ -482,7 +482,7 @@ void ieee80211_napi_schedule(struct ieee80211_hw *hw)
 }
 EXPORT_SYMBOL(ieee80211_napi_schedule);
 
-void ieee80211_napi_complete(struct ieee80211_hw *hw)
+void ieee80211_napi_complete(struct mac80211_hw *hw)
 {
 	struct mac80211_local *local = hw_to_local(hw);
 
@@ -546,7 +546,7 @@ ieee80211_default_mgmt_stypes[NUM_NL80211_IFTYPES] = {
 	},
 };
 
-struct ieee80211_hw *ieee80211_alloc_hw(size_t priv_data_len,
+struct mac80211_hw *ieee80211_alloc_hw(size_t priv_data_len,
 					const struct ieee80211_ops *ops)
 {
 	struct mac80211_local *local;
@@ -682,7 +682,7 @@ struct ieee80211_hw *ieee80211_alloc_hw(size_t priv_data_len,
 }
 EXPORT_SYMBOL(ieee80211_alloc_hw);
 
-int ieee80211_register_hw(struct ieee80211_hw *hw)
+int ieee80211_register_hw(struct mac80211_hw *hw)
 {
 	struct mac80211_local *local = hw_to_local(hw);
 	int result, i;
@@ -978,7 +978,7 @@ int ieee80211_register_hw(struct ieee80211_hw *hw)
 }
 EXPORT_SYMBOL(ieee80211_register_hw);
 
-void ieee80211_unregister_hw(struct ieee80211_hw *hw)
+void ieee80211_unregister_hw(struct mac80211_hw *hw)
 {
 	struct mac80211_local *local = hw_to_local(hw);
 
@@ -1030,7 +1030,7 @@ void ieee80211_unregister_hw(struct ieee80211_hw *hw)
 }
 EXPORT_SYMBOL(ieee80211_unregister_hw);
 
-void ieee80211_free_hw(struct ieee80211_hw *hw)
+void ieee80211_free_hw(struct mac80211_hw *hw)
 {
 	struct mac80211_local *local = hw_to_local(hw);
 
diff --git a/net/mac80211/mlme.c b/net/mac80211/mlme.c
index b92dbda..54a9762 100644
--- a/net/mac80211/mlme.c
+++ b/net/mac80211/mlme.c
@@ -1277,7 +1277,7 @@ static void ieee80211_mgd_probe_ap(struct mac80211_sub_if_data *sdata,
 	mutex_unlock(&ifmgd->mtx);
 }
 
-struct sk_buff *ieee80211_ap_probereq_get(struct ieee80211_hw *hw,
+struct sk_buff *ieee80211_ap_probereq_get(struct mac80211_hw *hw,
 					  struct ieee80211_vif *vif)
 {
 	struct mac80211_sub_if_data *sdata = vif_to_sdata(vif);
@@ -1349,7 +1349,7 @@ void ieee80211_beacon_connection_loss_work(struct work_struct *work)
 void ieee80211_beacon_loss(struct ieee80211_vif *vif)
 {
 	struct mac80211_sub_if_data *sdata = vif_to_sdata(vif);
-	struct ieee80211_hw *hw = &sdata->local->hw;
+	struct mac80211_hw *hw = &sdata->local->hw;
 
 	trace_api_beacon_loss(sdata);
 
@@ -1361,7 +1361,7 @@ EXPORT_SYMBOL(ieee80211_beacon_loss);
 void ieee80211_connection_loss(struct ieee80211_vif *vif)
 {
 	struct mac80211_sub_if_data *sdata = vif_to_sdata(vif);
-	struct ieee80211_hw *hw = &sdata->local->hw;
+	struct mac80211_hw *hw = &sdata->local->hw;
 
 	trace_api_connection_loss(sdata);
 
diff --git a/net/mac80211/offchannel.c b/net/mac80211/offchannel.c
index 5473d79..9449fcf 100644
--- a/net/mac80211/offchannel.c
+++ b/net/mac80211/offchannel.c
@@ -229,7 +229,7 @@ static void ieee80211_hw_roc_start(struct work_struct *work)
 	mutex_unlock(&local->mtx);
 }
 
-void ieee80211_ready_on_channel(struct ieee80211_hw *hw)
+void ieee80211_ready_on_channel(struct mac80211_hw *hw)
 {
 	struct mac80211_local *local = hw_to_local(hw);
 
@@ -266,7 +266,7 @@ static void ieee80211_hw_roc_done(struct work_struct *work)
 	mutex_unlock(&local->mtx);
 }
 
-void ieee80211_remain_on_channel_expired(struct ieee80211_hw *hw)
+void ieee80211_remain_on_channel_expired(struct mac80211_hw *hw)
 {
 	struct mac80211_local *local = hw_to_local(hw);
 
diff --git a/net/mac80211/pm.c b/net/mac80211/pm.c
index e41aa9e..f2786f9 100644
--- a/net/mac80211/pm.c
+++ b/net/mac80211/pm.c
@@ -6,7 +6,7 @@
 #include "driver-ops.h"
 #include "led.h"
 
-int __ieee80211_suspend(struct ieee80211_hw *hw, struct cfg80211_wowlan *wowlan)
+int __ieee80211_suspend(struct mac80211_hw *hw, struct cfg80211_wowlan *wowlan)
 {
 	struct mac80211_local *local = hw_to_local(hw);
 	struct mac80211_sub_if_data *sdata;
diff --git a/net/mac80211/rc80211_minstrel.c b/net/mac80211/rc80211_minstrel.c
index 6a9d98e..82c203d 100644
--- a/net/mac80211/rc80211_minstrel.c
+++ b/net/mac80211/rc80211_minstrel.c
@@ -451,7 +451,7 @@ minstrel_alloc_sta(void *priv, struct ieee80211_sta *sta, gfp_t gfp)
 	struct ieee80211_supported_band *sband;
 	struct minstrel_sta_info *mi;
 	struct minstrel_priv *mp = priv;
-	struct ieee80211_hw *hw = mp->hw;
+	struct mac80211_hw *hw = mp->hw;
 	int max_rates = 0;
 	int i;
 
@@ -494,7 +494,7 @@ minstrel_free_sta(void *priv, struct ieee80211_sta *sta, void *priv_sta)
 }
 
 static void *
-minstrel_alloc(struct ieee80211_hw *hw, struct dentry *debugfsdir)
+minstrel_alloc(struct mac80211_hw *hw, struct dentry *debugfsdir)
 {
 	struct minstrel_priv *mp;
 
diff --git a/net/mac80211/rc80211_minstrel.h b/net/mac80211/rc80211_minstrel.h
index 5d278ec..e659354 100644
--- a/net/mac80211/rc80211_minstrel.h
+++ b/net/mac80211/rc80211_minstrel.h
@@ -68,7 +68,7 @@ struct minstrel_sta_info {
 };
 
 struct minstrel_priv {
-	struct ieee80211_hw *hw;
+	struct mac80211_hw *hw;
 	bool has_mrr;
 	unsigned int cw_min;
 	unsigned int cw_max;
diff --git a/net/mac80211/rc80211_minstrel_ht.c b/net/mac80211/rc80211_minstrel_ht.c
index 0aef63a..0991c4f 100644
--- a/net/mac80211/rc80211_minstrel_ht.c
+++ b/net/mac80211/rc80211_minstrel_ht.c
@@ -784,7 +784,7 @@ minstrel_ht_alloc_sta(void *priv, struct ieee80211_sta *sta, gfp_t gfp)
 	struct ieee80211_supported_band *sband;
 	struct minstrel_ht_sta_priv *msp;
 	struct minstrel_priv *mp = priv;
-	struct ieee80211_hw *hw = mp->hw;
+	struct mac80211_hw *hw = mp->hw;
 	int max_rates = 0;
 	int i;
 
@@ -826,7 +826,7 @@ minstrel_ht_free_sta(void *priv, struct ieee80211_sta *sta, void *priv_sta)
 }
 
 static void *
-minstrel_ht_alloc(struct ieee80211_hw *hw, struct dentry *debugfsdir)
+minstrel_ht_alloc(struct mac80211_hw *hw, struct dentry *debugfsdir)
 {
 	return mac80211_minstrel.alloc(hw, debugfsdir);
 }
diff --git a/net/mac80211/rc80211_pid_algo.c b/net/mac80211/rc80211_pid_algo.c
index aeda654..a0800f0 100644
--- a/net/mac80211/rc80211_pid_algo.c
+++ b/net/mac80211/rc80211_pid_algo.c
@@ -336,7 +336,7 @@ rate_control_pid_rate_init(void *priv, struct ieee80211_supported_band *sband,
 	spinfo->txrate_idx = rate_lowest_index(sband, sta);
 }
 
-static void *rate_control_pid_alloc(struct ieee80211_hw *hw,
+static void *rate_control_pid_alloc(struct mac80211_hw *hw,
 				    struct dentry *debugfsdir)
 {
 	struct rc_pid_info *pinfo;
diff --git a/net/mac80211/rx.c b/net/mac80211/rx.c
index 3893271..5c5990d 100644
--- a/net/mac80211/rx.c
+++ b/net/mac80211/rx.c
@@ -546,7 +546,7 @@ static inline u16 seq_sub(u16 sq1, u16 sq2)
 }
 
 
-static void ieee80211_release_reorder_frame(struct ieee80211_hw *hw,
+static void ieee80211_release_reorder_frame(struct mac80211_hw *hw,
 					    struct tid_ampdu_rx *tid_agg_rx,
 					    int index)
 {
@@ -570,7 +570,7 @@ no_frame:
 	tid_agg_rx->head_seq_num = seq_inc(tid_agg_rx->head_seq_num);
 }
 
-static void ieee80211_release_reorder_frames(struct ieee80211_hw *hw,
+static void ieee80211_release_reorder_frames(struct mac80211_hw *hw,
 					     struct tid_ampdu_rx *tid_agg_rx,
 					     u16 head_seq_num)
 {
@@ -596,7 +596,7 @@ static void ieee80211_release_reorder_frames(struct ieee80211_hw *hw,
  */
 #define HT_RX_REORDER_BUF_TIMEOUT (HZ / 10)
 
-static void ieee80211_sta_reorder_release(struct ieee80211_hw *hw,
+static void ieee80211_sta_reorder_release(struct mac80211_hw *hw,
 					  struct tid_ampdu_rx *tid_agg_rx)
 {
 	int index, j;
@@ -669,7 +669,7 @@ static void ieee80211_sta_reorder_release(struct ieee80211_hw *hw,
  * rcu_read_lock protection. It returns false if the frame
  * can be processed immediately, true if it was consumed.
  */
-static bool ieee80211_sta_manage_reorder_buf(struct ieee80211_hw *hw,
+static bool ieee80211_sta_manage_reorder_buf(struct mac80211_hw *hw,
 					     struct tid_ampdu_rx *tid_agg_rx,
 					     struct sk_buff *skb)
 {
@@ -743,7 +743,7 @@ static void ieee80211_rx_reorder_ampdu(struct mac80211_rx_data *rx)
 {
 	struct sk_buff *skb = rx->skb;
 	struct mac80211_local *local = rx->local;
-	struct ieee80211_hw *hw = &local->hw;
+	struct mac80211_hw *hw = &local->hw;
 	struct ieee80211_hdr *hdr = (struct ieee80211_hdr *) skb->data;
 	struct sta_info *sta = rx->sta;
 	struct tid_ampdu_rx *tid_agg_rx;
@@ -1981,7 +1981,7 @@ static ieee80211_rx_result debug_noinline
 ieee80211_rx_h_ctrl(struct mac80211_rx_data *rx)
 {
 	struct mac80211_local *local = rx->local;
-	struct ieee80211_hw *hw = &local->hw;
+	struct mac80211_hw *hw = &local->hw;
 	struct sk_buff *skb = rx->skb;
 	struct ieee80211_bar *bar = (struct ieee80211_bar *)skb->data;
 	struct tid_ampdu_rx *tid_agg_rx;
@@ -2737,7 +2737,7 @@ static bool ieee80211_prepare_and_rx_handle(struct mac80211_rx_data *rx,
  * This is the actual Rx frames handler. as it blongs to Rx path it must
  * be called with rcu_read_lock protection.
  */
-static void __ieee80211_rx_handle_packet(struct ieee80211_hw *hw,
+static void __ieee80211_rx_handle_packet(struct mac80211_hw *hw,
 					 struct sk_buff *skb)
 {
 	struct ieee80211_rx_status *status = IEEE80211_SKB_RXCB(skb);
@@ -2846,7 +2846,7 @@ static void __ieee80211_rx_handle_packet(struct ieee80211_hw *hw,
  * This is the receive path handler. It is called by a low level driver when an
  * 802.11 MPDU is received from the hardware.
  */
-void ieee80211_rx(struct ieee80211_hw *hw, struct sk_buff *skb)
+void ieee80211_rx(struct mac80211_hw *hw, struct sk_buff *skb)
 {
 	struct mac80211_local *local = hw_to_local(hw);
 	struct ieee80211_rate *rate = NULL;
@@ -2949,7 +2949,7 @@ EXPORT_SYMBOL(ieee80211_rx);
 
 /* This is a version of the rx handler that can be called from hard irq
  * context. Post the skb on the queue and schedule the tasklet */
-void ieee80211_rx_irqsafe(struct ieee80211_hw *hw, struct sk_buff *skb)
+void ieee80211_rx_irqsafe(struct mac80211_hw *hw, struct sk_buff *skb)
 {
 	struct mac80211_local *local = hw_to_local(hw);
 
diff --git a/net/mac80211/scan.c b/net/mac80211/scan.c
index 284e0cb..225bbd5 100644
--- a/net/mac80211/scan.c
+++ b/net/mac80211/scan.c
@@ -258,7 +258,7 @@ static bool ieee80211_prep_hw_scan(struct mac80211_local *local)
 	return true;
 }
 
-static void __ieee80211_scan_completed(struct ieee80211_hw *hw, bool aborted,
+static void __ieee80211_scan_completed(struct mac80211_hw *hw, bool aborted,
 				       bool was_hw_scan)
 {
 	struct mac80211_local *local = hw_to_local(hw);
@@ -325,7 +325,7 @@ static void __ieee80211_scan_completed(struct ieee80211_hw *hw, bool aborted,
 	ieee80211_queue_work(&local->hw, &local->work_work);
 }
 
-void ieee80211_scan_completed(struct ieee80211_hw *hw, bool aborted)
+void ieee80211_scan_completed(struct mac80211_hw *hw, bool aborted)
 {
 	struct mac80211_local *local = hw_to_local(hw);
 
@@ -931,7 +931,7 @@ out:
 	return ret;
 }
 
-void ieee80211_sched_scan_results(struct ieee80211_hw *hw)
+void ieee80211_sched_scan_results(struct mac80211_hw *hw)
 {
 	struct mac80211_local *local = hw_to_local(hw);
 
@@ -965,7 +965,7 @@ void ieee80211_sched_scan_stopped_work(struct work_struct *work)
 	cfg80211_sched_scan_stopped(local->hw.wiphy);
 }
 
-void ieee80211_sched_scan_stopped(struct ieee80211_hw *hw)
+void ieee80211_sched_scan_stopped(struct mac80211_hw *hw)
 {
 	struct mac80211_local *local = hw_to_local(hw);
 
diff --git a/net/mac80211/sta_info.c b/net/mac80211/sta_info.c
index a6b187d..866a0da 100644
--- a/net/mac80211/sta_info.c
+++ b/net/mac80211/sta_info.c
@@ -844,7 +844,7 @@ void ieee80211_sta_expire(struct mac80211_sub_if_data *sdata,
 	mutex_unlock(&local->sta_mtx);
 }
 
-struct ieee80211_sta *ieee80211_find_sta_by_ifaddr(struct ieee80211_hw *hw,
+struct ieee80211_sta *ieee80211_find_sta_by_ifaddr(struct mac80211_hw *hw,
 					       const u8 *addr,
 					       const u8 *localaddr)
 {
@@ -980,7 +980,7 @@ void ieee80211_sta_ps_deliver_poll_response(struct sta_info *sta)
 	}
 }
 
-void ieee80211_sta_block_awake(struct ieee80211_hw *hw,
+void ieee80211_sta_block_awake(struct mac80211_hw *hw,
 			       struct ieee80211_sta *pubsta, bool block)
 {
 	struct sta_info *sta = container_of(pubsta, struct sta_info, sta);
diff --git a/net/mac80211/status.c b/net/mac80211/status.c
index 37c886d..919d648 100644
--- a/net/mac80211/status.c
+++ b/net/mac80211/status.c
@@ -16,7 +16,7 @@
 #include "led.h"
 
 
-void ieee80211_tx_status_irqsafe(struct ieee80211_hw *hw,
+void ieee80211_tx_status_irqsafe(struct mac80211_hw *hw,
 				 struct sk_buff *skb)
 {
 	struct mac80211_local *local = hw_to_local(hw);
@@ -170,7 +170,7 @@ static void ieee80211_frame_acked(struct sta_info *sta, struct sk_buff *skb)
  */
 #define STA_LOST_PKT_THRESHOLD	50
 
-void ieee80211_tx_status(struct ieee80211_hw *hw, struct sk_buff *skb)
+void ieee80211_tx_status(struct mac80211_hw *hw, struct sk_buff *skb)
 {
 	struct sk_buff *skb2;
 	struct ieee80211_hdr *hdr = (struct ieee80211_hdr *) skb->data;
diff --git a/net/mac80211/tx.c b/net/mac80211/tx.c
index ea0f76a..a8ef06c 100644
--- a/net/mac80211/tx.c
+++ b/net/mac80211/tx.c
@@ -2162,7 +2162,7 @@ static void ieee80211_beacon_add_tim(struct mac80211_if_ap *bss,
 	}
 }
 
-struct sk_buff *ieee80211_beacon_get_tim(struct ieee80211_hw *hw,
+struct sk_buff *ieee80211_beacon_get_tim(struct mac80211_hw *hw,
 					 struct ieee80211_vif *vif,
 					 u16 *tim_offset, u16 *tim_length)
 {
@@ -2319,7 +2319,7 @@ struct sk_buff *ieee80211_beacon_get_tim(struct ieee80211_hw *hw,
 }
 EXPORT_SYMBOL(ieee80211_beacon_get_tim);
 
-struct sk_buff *ieee80211_pspoll_get(struct ieee80211_hw *hw,
+struct sk_buff *ieee80211_pspoll_get(struct mac80211_hw *hw,
 				     struct ieee80211_vif *vif)
 {
 	struct mac80211_sub_if_data *sdata;
@@ -2359,7 +2359,7 @@ struct sk_buff *ieee80211_pspoll_get(struct ieee80211_hw *hw,
 }
 EXPORT_SYMBOL(ieee80211_pspoll_get);
 
-struct sk_buff *ieee80211_nullfunc_get(struct ieee80211_hw *hw,
+struct sk_buff *ieee80211_nullfunc_get(struct mac80211_hw *hw,
 				       struct ieee80211_vif *vif)
 {
 	struct ieee80211_hdr_3addr *nullfunc;
@@ -2397,7 +2397,7 @@ struct sk_buff *ieee80211_nullfunc_get(struct ieee80211_hw *hw,
 }
 EXPORT_SYMBOL(ieee80211_nullfunc_get);
 
-struct sk_buff *ieee80211_probereq_get(struct ieee80211_hw *hw,
+struct sk_buff *ieee80211_probereq_get(struct mac80211_hw *hw,
 				       struct ieee80211_vif *vif,
 				       const u8 *ssid, size_t ssid_len,
 				       const u8 *ie, size_t ie_len)
@@ -2447,7 +2447,7 @@ struct sk_buff *ieee80211_probereq_get(struct ieee80211_hw *hw,
 }
 EXPORT_SYMBOL(ieee80211_probereq_get);
 
-void ieee80211_rts_get(struct ieee80211_hw *hw, struct ieee80211_vif *vif,
+void ieee80211_rts_get(struct mac80211_hw *hw, struct ieee80211_vif *vif,
 		       const void *frame, size_t frame_len,
 		       const struct ieee80211_tx_info *frame_txctl,
 		       struct ieee80211_rts *rts)
@@ -2463,7 +2463,7 @@ void ieee80211_rts_get(struct ieee80211_hw *hw, struct ieee80211_vif *vif,
 }
 EXPORT_SYMBOL(ieee80211_rts_get);
 
-void ieee80211_ctstoself_get(struct ieee80211_hw *hw, struct ieee80211_vif *vif,
+void ieee80211_ctstoself_get(struct mac80211_hw *hw, struct ieee80211_vif *vif,
 			     const void *frame, size_t frame_len,
 			     const struct ieee80211_tx_info *frame_txctl,
 			     struct ieee80211_cts *cts)
@@ -2479,7 +2479,7 @@ void ieee80211_ctstoself_get(struct ieee80211_hw *hw, struct ieee80211_vif *vif,
 EXPORT_SYMBOL(ieee80211_ctstoself_get);
 
 struct sk_buff *
-ieee80211_get_buffered_bc(struct ieee80211_hw *hw,
+ieee80211_get_buffered_bc(struct mac80211_hw *hw,
 			  struct ieee80211_vif *vif)
 {
 	struct mac80211_local *local = hw_to_local(hw);
diff --git a/net/mac80211/util.c b/net/mac80211/util.c
index 65b0367..b9a83d0 100644
--- a/net/mac80211/util.c
+++ b/net/mac80211/util.c
@@ -35,7 +35,7 @@
 /* privid for wiphys to determine whether they belong to us or not */
 void *mac80211_wiphy_privid = &mac80211_wiphy_privid;
 
-struct ieee80211_hw *wiphy_to_ieee80211_hw(struct wiphy *wiphy)
+struct mac80211_hw *wiphy_to_mac80211_hw(struct wiphy *wiphy)
 {
 	struct mac80211_local *local;
 	BUG_ON(!wiphy);
@@ -43,7 +43,7 @@ struct ieee80211_hw *wiphy_to_ieee80211_hw(struct wiphy *wiphy)
 	local = wiphy_priv(wiphy);
 	return &local->hw;
 }
-EXPORT_SYMBOL(wiphy_to_ieee80211_hw);
+EXPORT_SYMBOL(wiphy_to_mac80211_hw);
 
 u8 *ieee80211_get_bssid(struct ieee80211_hdr *hdr, size_t len,
 			enum nl80211_iftype type)
@@ -159,7 +159,7 @@ int ieee80211_frame_duration(struct mac80211_local *local, size_t len,
 }
 
 /* Exported duration function for driver use */
-__le16 ieee80211_generic_frame_duration(struct ieee80211_hw *hw,
+__le16 ieee80211_generic_frame_duration(struct mac80211_hw *hw,
 					struct ieee80211_vif *vif,
 					size_t frame_len,
 					struct ieee80211_rate *rate)
@@ -185,7 +185,7 @@ __le16 ieee80211_generic_frame_duration(struct ieee80211_hw *hw,
 }
 EXPORT_SYMBOL(ieee80211_generic_frame_duration);
 
-__le16 ieee80211_rts_duration(struct ieee80211_hw *hw,
+__le16 ieee80211_rts_duration(struct mac80211_hw *hw,
 			      struct ieee80211_vif *vif, size_t frame_len,
 			      const struct ieee80211_tx_info *frame_txctl)
 {
@@ -225,7 +225,7 @@ __le16 ieee80211_rts_duration(struct ieee80211_hw *hw,
 }
 EXPORT_SYMBOL(ieee80211_rts_duration);
 
-__le16 ieee80211_ctstoself_duration(struct ieee80211_hw *hw,
+__le16 ieee80211_ctstoself_duration(struct mac80211_hw *hw,
 				    struct ieee80211_vif *vif,
 				    size_t frame_len,
 				    const struct ieee80211_tx_info *frame_txctl)
@@ -264,7 +264,7 @@ __le16 ieee80211_ctstoself_duration(struct ieee80211_hw *hw,
 }
 EXPORT_SYMBOL(ieee80211_ctstoself_duration);
 
-static void __ieee80211_wake_queue(struct ieee80211_hw *hw, int queue,
+static void __ieee80211_wake_queue(struct mac80211_hw *hw, int queue,
 				   enum queue_stop_reason reason)
 {
 	struct mac80211_local *local = hw_to_local(hw);
@@ -293,7 +293,7 @@ static void __ieee80211_wake_queue(struct ieee80211_hw *hw, int queue,
 		tasklet_schedule(&local->tx_pending_tasklet);
 }
 
-void ieee80211_wake_queue_by_reason(struct ieee80211_hw *hw, int queue,
+void ieee80211_wake_queue_by_reason(struct mac80211_hw *hw, int queue,
 				    enum queue_stop_reason reason)
 {
 	struct mac80211_local *local = hw_to_local(hw);
@@ -304,14 +304,14 @@ void ieee80211_wake_queue_by_reason(struct ieee80211_hw *hw, int queue,
 	spin_unlock_irqrestore(&local->queue_stop_reason_lock, flags);
 }
 
-void ieee80211_wake_queue(struct ieee80211_hw *hw, int queue)
+void ieee80211_wake_queue(struct mac80211_hw *hw, int queue)
 {
 	ieee80211_wake_queue_by_reason(hw, queue,
 				       MAC80211_QUEUE_STOP_REASON_DRIVER);
 }
 EXPORT_SYMBOL(ieee80211_wake_queue);
 
-static void __ieee80211_stop_queue(struct ieee80211_hw *hw, int queue,
+static void __ieee80211_stop_queue(struct mac80211_hw *hw, int queue,
 				   enum queue_stop_reason reason)
 {
 	struct mac80211_local *local = hw_to_local(hw);
@@ -330,7 +330,7 @@ static void __ieee80211_stop_queue(struct ieee80211_hw *hw, int queue,
 	rcu_read_unlock();
 }
 
-void ieee80211_stop_queue_by_reason(struct ieee80211_hw *hw, int queue,
+void ieee80211_stop_queue_by_reason(struct mac80211_hw *hw, int queue,
 				    enum queue_stop_reason reason)
 {
 	struct mac80211_local *local = hw_to_local(hw);
@@ -341,7 +341,7 @@ void ieee80211_stop_queue_by_reason(struct ieee80211_hw *hw, int queue,
 	spin_unlock_irqrestore(&local->queue_stop_reason_lock, flags);
 }
 
-void ieee80211_stop_queue(struct ieee80211_hw *hw, int queue)
+void ieee80211_stop_queue(struct mac80211_hw *hw, int queue)
 {
 	ieee80211_stop_queue_by_reason(hw, queue,
 				       MAC80211_QUEUE_STOP_REASON_DRIVER);
@@ -351,7 +351,7 @@ EXPORT_SYMBOL(ieee80211_stop_queue);
 void ieee80211_add_pending_skb(struct mac80211_local *local,
 			       struct sk_buff *skb)
 {
-	struct ieee80211_hw *hw = &local->hw;
+	struct mac80211_hw *hw = &local->hw;
 	unsigned long flags;
 	int queue = skb_get_queue_mapping(skb);
 	struct ieee80211_tx_info *info = IEEE80211_SKB_CB(skb);
@@ -372,7 +372,7 @@ int ieee80211_add_pending_skbs_fn(struct mac80211_local *local,
 				  struct sk_buff_head *skbs,
 				  void (*fn)(void *data), void *data)
 {
-	struct ieee80211_hw *hw = &local->hw;
+	struct mac80211_hw *hw = &local->hw;
 	struct sk_buff *skb;
 	unsigned long flags;
 	int queue, ret = 0, i;
@@ -412,7 +412,7 @@ int ieee80211_add_pending_skbs(struct mac80211_local *local,
 	return ieee80211_add_pending_skbs_fn(local, skbs, NULL, NULL);
 }
 
-void ieee80211_stop_queues_by_reason(struct ieee80211_hw *hw,
+void ieee80211_stop_queues_by_reason(struct mac80211_hw *hw,
 				    enum queue_stop_reason reason)
 {
 	struct mac80211_local *local = hw_to_local(hw);
@@ -427,14 +427,14 @@ void ieee80211_stop_queues_by_reason(struct ieee80211_hw *hw,
 	spin_unlock_irqrestore(&local->queue_stop_reason_lock, flags);
 }
 
-void ieee80211_stop_queues(struct ieee80211_hw *hw)
+void ieee80211_stop_queues(struct mac80211_hw *hw)
 {
 	ieee80211_stop_queues_by_reason(hw,
 					MAC80211_QUEUE_STOP_REASON_DRIVER);
 }
 EXPORT_SYMBOL(ieee80211_stop_queues);
 
-int ieee80211_queue_stopped(struct ieee80211_hw *hw, int queue)
+int ieee80211_queue_stopped(struct mac80211_hw *hw, int queue)
 {
 	struct mac80211_local *local = hw_to_local(hw);
 	unsigned long flags;
@@ -450,7 +450,7 @@ int ieee80211_queue_stopped(struct ieee80211_hw *hw, int queue)
 }
 EXPORT_SYMBOL(ieee80211_queue_stopped);
 
-void ieee80211_wake_queues_by_reason(struct ieee80211_hw *hw,
+void ieee80211_wake_queues_by_reason(struct mac80211_hw *hw,
 				     enum queue_stop_reason reason)
 {
 	struct mac80211_local *local = hw_to_local(hw);
@@ -465,14 +465,14 @@ void ieee80211_wake_queues_by_reason(struct ieee80211_hw *hw,
 	spin_unlock_irqrestore(&local->queue_stop_reason_lock, flags);
 }
 
-void ieee80211_wake_queues(struct ieee80211_hw *hw)
+void ieee80211_wake_queues(struct mac80211_hw *hw)
 {
 	ieee80211_wake_queues_by_reason(hw, MAC80211_QUEUE_STOP_REASON_DRIVER);
 }
 EXPORT_SYMBOL(ieee80211_wake_queues);
 
 void ieee80211_iterate_active_interfaces(
-	struct ieee80211_hw *hw,
+	struct mac80211_hw *hw,
 	void (*iterator)(void *data, u8 *mac,
 			 struct ieee80211_vif *vif),
 	void *data)
@@ -500,7 +500,7 @@ void ieee80211_iterate_active_interfaces(
 EXPORT_SYMBOL_GPL(ieee80211_iterate_active_interfaces);
 
 void ieee80211_iterate_active_interfaces_atomic(
-	struct ieee80211_hw *hw,
+	struct mac80211_hw *hw,
 	void (*iterator)(void *data, u8 *mac,
 			 struct ieee80211_vif *vif),
 	void *data)
@@ -543,7 +543,7 @@ static bool ieee80211_can_queue_work(struct mac80211_local *local)
 	return true;
 }
 
-void ieee80211_queue_work(struct ieee80211_hw *hw, struct work_struct *work)
+void ieee80211_queue_work(struct mac80211_hw *hw, struct work_struct *work)
 {
 	struct mac80211_local *local = hw_to_local(hw);
 
@@ -554,7 +554,7 @@ void ieee80211_queue_work(struct ieee80211_hw *hw, struct work_struct *work)
 }
 EXPORT_SYMBOL(ieee80211_queue_work);
 
-void ieee80211_queue_delayed_work(struct ieee80211_hw *hw,
+void ieee80211_queue_delayed_work(struct mac80211_hw *hw,
 				  struct delayed_work *dwork,
 				  unsigned long delay)
 {
@@ -1120,7 +1120,7 @@ void ieee80211_stop_device(struct mac80211_local *local)
 
 int ieee80211_reconfig(struct mac80211_local *local)
 {
-	struct ieee80211_hw *hw = &local->hw;
+	struct mac80211_hw *hw = &local->hw;
 	struct mac80211_sub_if_data *sdata;
 	struct sta_info *sta;
 	int res;

