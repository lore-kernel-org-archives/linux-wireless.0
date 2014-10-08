Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from dedo.coelho.fi ([88.198.205.34]:34579 "EHLO dedo.coelho.fi"
	rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org with ESMTP
	id S1754471AbaJHGtY (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 8 Oct 2014 02:49:24 -0400
From: Luca Coelho <luca@coelho.fi>
To: johannes@sipsolutions.net
Cc: emmanuel.grumbach@intel.com, michal.kazior@tieto.com,
	linux-wireless@vger.kernel.org
Date: Wed,  8 Oct 2014 09:48:40 +0300
Message-Id: <1412750920-15392-8-git-send-email-luca@coelho.fi> (sfid-20141008_084929_101065_6F532739)
In-Reply-To: <1412750920-15392-1-git-send-email-luca@coelho.fi>
References: <1412750920-15392-1-git-send-email-luca@coelho.fi>
Subject: [PATCH v2 7/7] mac80211: allow channel switch with multiple channel contexts
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Luciano Coelho <luciano.coelho@intel.com>

Channel switch with multiple channel contexts should now work fine.
Remove check that disallows switches when multiple contexts are in
use.

Signed-off-by: Luciano Coelho <luciano.coelho@intel.com>
---
Note: the driver changes are only compile-tested.
---
 drivers/net/wireless/iwlegacy/4965-mac.c    |  2 +-
 drivers/net/wireless/iwlegacy/4965.h        |  5 +++--
 drivers/net/wireless/iwlwifi/dvm/mac80211.c |  1 +
 drivers/net/wireless/ti/wlcore/main.c       | 23 ++++++++---------------
 include/net/mac80211.h                      |  1 +
 net/mac80211/driver-ops.h                   |  7 ++++---
 net/mac80211/mlme.c                         | 26 ++++++++++----------------
 net/mac80211/trace.h                        |  9 ++++++---
 8 files changed, 34 insertions(+), 40 deletions(-)

diff --git a/drivers/net/wireless/iwlegacy/4965-mac.c b/drivers/net/wireless/iwlegacy/4965-mac.c
index 9f930a0..42c4e39 100644
--- a/drivers/net/wireless/iwlegacy/4965-mac.c
+++ b/drivers/net/wireless/iwlegacy/4965-mac.c
@@ -6063,7 +6063,7 @@ il4965_mac_sta_add(struct ieee80211_hw *hw, struct ieee80211_vif *vif,
 }
 
 void
-il4965_mac_channel_switch(struct ieee80211_hw *hw,
+il4965_mac_channel_switch(struct ieee80211_hw *hw, struct ieee80211_vif *vif,
 			  struct ieee80211_channel_switch *ch_switch)
 {
 	struct il_priv *il = hw->priv;
diff --git a/drivers/net/wireless/iwlegacy/4965.h b/drivers/net/wireless/iwlegacy/4965.h
index 337dfcf..3a57f71 100644
--- a/drivers/net/wireless/iwlegacy/4965.h
+++ b/drivers/net/wireless/iwlegacy/4965.h
@@ -187,8 +187,9 @@ int il4965_mac_ampdu_action(struct ieee80211_hw *hw, struct ieee80211_vif *vif,
 			    u8 buf_size);
 int il4965_mac_sta_add(struct ieee80211_hw *hw, struct ieee80211_vif *vif,
 		       struct ieee80211_sta *sta);
-void il4965_mac_channel_switch(struct ieee80211_hw *hw,
-			       struct ieee80211_channel_switch *ch_switch);
+void
+il4965_mac_channel_switch(struct ieee80211_hw *hw, struct ieee80211_vif *vif,
+			  struct ieee80211_channel_switch *ch_switch);
 
 void il4965_led_enable(struct il_priv *il);
 
diff --git a/drivers/net/wireless/iwlwifi/dvm/mac80211.c b/drivers/net/wireless/iwlwifi/dvm/mac80211.c
index 2364a3c..a967bf8 100644
--- a/drivers/net/wireless/iwlwifi/dvm/mac80211.c
+++ b/drivers/net/wireless/iwlwifi/dvm/mac80211.c
@@ -941,6 +941,7 @@ static int iwlagn_mac_sta_state(struct ieee80211_hw *hw,
 }
 
 static void iwlagn_mac_channel_switch(struct ieee80211_hw *hw,
+				      struct ieee80211_vif *vif,
 				      struct ieee80211_channel_switch *ch_switch)
 {
 	struct iwl_priv *priv = IWL_MAC80211_GET_DVM(hw);
diff --git a/drivers/net/wireless/ti/wlcore/main.c b/drivers/net/wireless/ti/wlcore/main.c
index 575c8f6..6ad3fce 100644
--- a/drivers/net/wireless/ti/wlcore/main.c
+++ b/drivers/net/wireless/ti/wlcore/main.c
@@ -5177,10 +5177,11 @@ out:
 }
 
 static void wl12xx_op_channel_switch(struct ieee80211_hw *hw,
+				     struct ieee80211_vif *vif,
 				     struct ieee80211_channel_switch *ch_switch)
 {
 	struct wl1271 *wl = hw->priv;
-	struct wl12xx_vif *wlvif;
+	struct wl12xx_vif *wlvif = wl12xx_vif_to_data(vif);
 	int ret;
 
 	wl1271_debug(DEBUG_MAC80211, "mac80211 channel switch");
@@ -5190,14 +5191,8 @@ static void wl12xx_op_channel_switch(struct ieee80211_hw *hw,
 	mutex_lock(&wl->mutex);
 
 	if (unlikely(wl->state == WLCORE_STATE_OFF)) {
-		wl12xx_for_each_wlvif_sta(wl, wlvif) {
-			struct ieee80211_vif *vif = wl12xx_wlvif_to_vif(wlvif);
-
-			if (!test_bit(WLVIF_FLAG_STA_ASSOCIATED, &wlvif->flags))
-				continue;
-
+		if (test_bit(WLVIF_FLAG_STA_ASSOCIATED, &wlvif->flags))
 			ieee80211_chswitch_done(vif, false);
-		}
 		goto out;
 	} else if (unlikely(wl->state != WLCORE_STATE_ON)) {
 		goto out;
@@ -5208,11 +5203,9 @@ static void wl12xx_op_channel_switch(struct ieee80211_hw *hw,
 		goto out;
 
 	/* TODO: change mac80211 to pass vif as param */
-	wl12xx_for_each_wlvif_sta(wl, wlvif) {
-		unsigned long delay_usec;
 
-		if (!test_bit(WLVIF_FLAG_STA_ASSOCIATED, &wlvif->flags))
-			continue;
+	if (test_bit(WLVIF_FLAG_STA_ASSOCIATED, &wlvif->flags)) {
+		unsigned long delay_usec;
 
 		ret = wl->ops->channel_switch(wl, wlvif, ch_switch);
 		if (ret)
@@ -5222,10 +5215,10 @@ static void wl12xx_op_channel_switch(struct ieee80211_hw *hw,
 
 		/* indicate failure 5 seconds after channel switch time */
 		delay_usec = ieee80211_tu_to_usec(wlvif->beacon_int) *
-			     ch_switch->count;
+			ch_switch->count;
 		ieee80211_queue_delayed_work(hw, &wlvif->channel_switch_work,
-				usecs_to_jiffies(delay_usec) +
-				msecs_to_jiffies(5000));
+					     usecs_to_jiffies(delay_usec) +
+					     msecs_to_jiffies(5000));
 	}
 
 out_sleep:
diff --git a/include/net/mac80211.h b/include/net/mac80211.h
index 7861ed8..9bb2fc7 100644
--- a/include/net/mac80211.h
+++ b/include/net/mac80211.h
@@ -2969,6 +2969,7 @@ struct ieee80211_ops {
 	void (*flush)(struct ieee80211_hw *hw, struct ieee80211_vif *vif,
 		      u32 queues, bool drop);
 	void (*channel_switch)(struct ieee80211_hw *hw,
+			       struct ieee80211_vif *vif,
 			       struct ieee80211_channel_switch *ch_switch);
 	int (*set_antenna)(struct ieee80211_hw *hw, u32 tx_ant, u32 rx_ant);
 	int (*get_antenna)(struct ieee80211_hw *hw, u32 *tx_ant, u32 *rx_ant);
diff --git a/net/mac80211/driver-ops.h b/net/mac80211/driver-ops.h
index 0a60906..1bbb079 100644
--- a/net/mac80211/driver-ops.h
+++ b/net/mac80211/driver-ops.h
@@ -764,12 +764,13 @@ static inline void drv_flush(struct ieee80211_local *local,
 }
 
 static inline void drv_channel_switch(struct ieee80211_local *local,
-				     struct ieee80211_channel_switch *ch_switch)
+				      struct ieee80211_sub_if_data *sdata,
+				      struct ieee80211_channel_switch *ch_switch)
 {
 	might_sleep();
 
-	trace_drv_channel_switch(local, ch_switch);
-	local->ops->channel_switch(&local->hw, ch_switch);
+	trace_drv_channel_switch(local, sdata, ch_switch);
+	local->ops->channel_switch(&local->hw, &sdata->vif, ch_switch);
 	trace_drv_return_void(local);
 }
 
diff --git a/net/mac80211/mlme.c b/net/mac80211/mlme.c
index 109812f..28baccb 100644
--- a/net/mac80211/mlme.c
+++ b/net/mac80211/mlme.c
@@ -1134,21 +1134,15 @@ ieee80211_sta_process_chanswitch(struct ieee80211_sub_if_data *sdata,
 
 	chanctx = container_of(conf, struct ieee80211_chanctx, conf);
 
-	if (local->use_chanctx) {
-		u32 num_chanctx = 0;
-		list_for_each_entry(chanctx, &local->chanctx_list, list)
-		       num_chanctx++;
-
-		if (num_chanctx > 1 ||
-		    !(local->hw.flags & IEEE80211_HW_CHANCTX_STA_CSA)) {
-			sdata_info(sdata,
-				   "not handling chan-switch with channel contexts\n");
-			ieee80211_queue_work(&local->hw,
-					     &ifmgd->csa_connection_drop_work);
-			mutex_unlock(&local->chanctx_mtx);
-			mutex_unlock(&local->mtx);
-			return;
-		}
+	if (local->use_chanctx &&
+	    !(local->hw.flags & IEEE80211_HW_CHANCTX_STA_CSA)) {
+		sdata_info(sdata,
+			   "driver doesn't support chan-switch with channel contexts\n");
+		ieee80211_queue_work(&local->hw,
+				     &ifmgd->csa_connection_drop_work);
+		mutex_unlock(&local->chanctx_mtx);
+		mutex_unlock(&local->mtx);
+		return;
 	}
 
 	ch_switch.timestamp = timestamp;
@@ -1192,7 +1186,7 @@ ieee80211_sta_process_chanswitch(struct ieee80211_sub_if_data *sdata,
 
 	if (local->ops->channel_switch) {
 		/* use driver's channel switch callback */
-		drv_channel_switch(local, &ch_switch);
+		drv_channel_switch(local, sdata, &ch_switch);
 		return;
 	}
 
diff --git a/net/mac80211/trace.h b/net/mac80211/trace.h
index ca0e12d..976606a 100644
--- a/net/mac80211/trace.h
+++ b/net/mac80211/trace.h
@@ -987,12 +987,14 @@ TRACE_EVENT(drv_flush,
 
 TRACE_EVENT(drv_channel_switch,
 	TP_PROTO(struct ieee80211_local *local,
+		 struct ieee80211_sub_if_data *sdata,
 		 struct ieee80211_channel_switch *ch_switch),
 
-	TP_ARGS(local, ch_switch),
+	TP_ARGS(local, sdata, ch_switch),
 
 	TP_STRUCT__entry(
 		LOCAL_ENTRY
+		VIF_ENTRY
 		CHANDEF_ENTRY
 		__field(u64, timestamp)
 		__field(u32, device_timestamp)
@@ -1002,6 +1004,7 @@ TRACE_EVENT(drv_channel_switch,
 
 	TP_fast_assign(
 		LOCAL_ASSIGN;
+		VIF_ASSIGN;
 		CHANDEF_ASSIGN(&ch_switch->chandef)
 		__entry->timestamp = ch_switch->timestamp;
 		__entry->device_timestamp = ch_switch->device_timestamp;
@@ -1010,8 +1013,8 @@ TRACE_EVENT(drv_channel_switch,
 	),
 
 	TP_printk(
-		LOCAL_PR_FMT " new " CHANDEF_PR_FMT " count:%d",
-		LOCAL_PR_ARG, CHANDEF_PR_ARG, __entry->count
+		LOCAL_PR_FMT VIF_PR_FMT " new " CHANDEF_PR_FMT " count:%d",
+		LOCAL_PR_ARG, VIF_PR_ARG, CHANDEF_PR_ARG, __entry->count
 	)
 );
 
-- 
2.1.1

