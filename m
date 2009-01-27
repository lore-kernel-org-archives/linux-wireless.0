Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga02.intel.com ([134.134.136.20]:7077 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751443AbZA0WZP (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 27 Jan 2009 17:25:15 -0500
From: Reinette Chatre <reinette.chatre@intel.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org,
	ipw3945-devel@lists.sourceforge.net,
	Tomas Winkler <tomas.winkler@intel.com>,
	Reinette Chatre <reinette.chatre@intel.com>
Subject: [PATCH 5/7] iwlwifi: don't use implicit priv in IWL_DEBUG
Date: Tue, 27 Jan 2009 14:27:56 -0800
Message-Id: <1233095278-5850-6-git-send-email-reinette.chatre@intel.com> (sfid-20090127_232538_060140_9C096B15)
In-Reply-To: <1233095278-5850-5-git-send-email-reinette.chatre@intel.com>
References: <>
 <1233095278-5850-1-git-send-email-reinette.chatre@intel.com>
 <1233095278-5850-2-git-send-email-reinette.chatre@intel.com>
 <1233095278-5850-3-git-send-email-reinette.chatre@intel.com>
 <1233095278-5850-4-git-send-email-reinette.chatre@intel.com>
 <1233095278-5850-5-git-send-email-reinette.chatre@intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Tomas Winkler <tomas.winkler@intel.com>

Call IWL_DEBUG macro with explicit priv argument.

Signed-off-by: Tomas Winkler <tomas.winkler@intel.com>
Acked-by: Samuel Ortiz <samuel.ortiz@intel.com>
Signed-off-by: Reinette Chatre <reinette.chatre@intel.com>
---
 drivers/net/wireless/iwlwifi/iwl-3945-led.c |    6 +-
 drivers/net/wireless/iwlwifi/iwl-3945-rs.c  |   74 +++---
 drivers/net/wireless/iwlwifi/iwl-3945.c     |  109 ++++----
 drivers/net/wireless/iwlwifi/iwl-4965.c     |  126 ++++----
 drivers/net/wireless/iwlwifi/iwl-5000.c     |   54 ++--
 drivers/net/wireless/iwlwifi/iwl-agn-rs.c   |  104 ++++----
 drivers/net/wireless/iwlwifi/iwl-agn.c      |  281 +++++++++---------
 drivers/net/wireless/iwlwifi/iwl-calib.c    |   74 +++---
 drivers/net/wireless/iwlwifi/iwl-core.c     |   72 +++---
 drivers/net/wireless/iwlwifi/iwl-debug.h    |  103 ++++---
 drivers/net/wireless/iwlwifi/iwl-eeprom.c   |   14 +-
 drivers/net/wireless/iwlwifi/iwl-hcmd.c     |    8 +-
 drivers/net/wireless/iwlwifi/iwl-io.h       |   20 +-
 drivers/net/wireless/iwlwifi/iwl-led.c      |   14 +-
 drivers/net/wireless/iwlwifi/iwl-power.c    |   18 +-
 drivers/net/wireless/iwlwifi/iwl-rfkill.c   |    8 +-
 drivers/net/wireless/iwlwifi/iwl-rx.c       |   28 +-
 drivers/net/wireless/iwlwifi/iwl-scan.c     |   62 ++--
 drivers/net/wireless/iwlwifi/iwl-spectrum.c |    8 +-
 drivers/net/wireless/iwlwifi/iwl-sta.c      |   36 ++--
 drivers/net/wireless/iwlwifi/iwl-tx.c       |   52 ++--
 drivers/net/wireless/iwlwifi/iwl3945-base.c |  427 ++++++++++++++-------------
 22 files changed, 859 insertions(+), 839 deletions(-)

diff --git a/drivers/net/wireless/iwlwifi/iwl-3945-led.c b/drivers/net/wireless/iwlwifi/iwl-3945-led.c
index fab1373..2e507e9 100644
--- a/drivers/net/wireless/iwlwifi/iwl-3945-led.c
+++ b/drivers/net/wireless/iwlwifi/iwl-3945-led.c
@@ -137,7 +137,7 @@ static int iwl3945_led_off(struct iwl_priv *priv, int led_id)
 		.off = 0,
 		.interval = IWL_DEF_LED_INTRVL
 	};
-	IWL_DEBUG_LED("led off %d\n", led_id);
+	IWL_DEBUG_LED(priv, "led off %d\n", led_id);
 	return iwl_send_led_cmd(priv, &led_cmd);
 }
 
@@ -174,7 +174,7 @@ static void iwl3945_led_brightness_set(struct led_classdev *led_cdev,
 	case LED_FULL:
 		if (led->type == IWL_LED_TRG_ASSOC) {
 			priv->allow_blinking = 1;
-			IWL_DEBUG_LED("MAC is  associated\n");
+			IWL_DEBUG_LED(priv, "MAC is  associated\n");
 		}
 		if (led->led_on)
 			led->led_on(priv, IWL_LED_LINK);
@@ -182,7 +182,7 @@ static void iwl3945_led_brightness_set(struct led_classdev *led_cdev,
 	case LED_OFF:
 		if (led->type == IWL_LED_TRG_ASSOC) {
 			priv->allow_blinking = 0;
-			IWL_DEBUG_LED("MAC is disassociated\n");
+			IWL_DEBUG_LED(priv, "MAC is disassociated\n");
 		}
 		if (led->led_off)
 			led->led_off(priv, IWL_LED_LINK);
diff --git a/drivers/net/wireless/iwlwifi/iwl-3945-rs.c b/drivers/net/wireless/iwlwifi/iwl-3945-rs.c
index 45ce3ff..7db8198 100644
--- a/drivers/net/wireless/iwlwifi/iwl-3945-rs.c
+++ b/drivers/net/wireless/iwlwifi/iwl-3945-rs.c
@@ -197,7 +197,7 @@ static int iwl3945_rate_scale_flush_windows(struct iwl3945_rs_sta *rs_sta)
 		spin_lock_irqsave(&rs_sta->lock, flags);
 		if (time_after(jiffies, rs_sta->win[i].stamp +
 			       IWL_RATE_WIN_FLUSH)) {
-			IWL_DEBUG_RATE("flushing %d samples of rate "
+			IWL_DEBUG_RATE(priv, "flushing %d samples of rate "
 				       "index %d\n",
 				       rs_sta->win[i].counter, i);
 			iwl3945_clear_window(&rs_sta->win[i]);
@@ -221,7 +221,7 @@ static void iwl3945_bg_rate_scale_flush(unsigned long data)
 	unsigned long flags;
 	u32 packet_count, duration, pps;
 
-	IWL_DEBUG_RATE("enter\n");
+	IWL_DEBUG_RATE(priv, "enter\n");
 
 	unflushed = iwl3945_rate_scale_flush_windows(rs_sta);
 
@@ -236,7 +236,7 @@ static void iwl3945_bg_rate_scale_flush(unsigned long data)
 		duration =
 		    jiffies_to_msecs(jiffies - rs_sta->last_partial_flush);
 
-		IWL_DEBUG_RATE("Tx'd %d packets in %dms\n",
+		IWL_DEBUG_RATE(priv, "Tx'd %d packets in %dms\n",
 			       packet_count, duration);
 
 		/* Determine packets per second */
@@ -256,7 +256,7 @@ static void iwl3945_bg_rate_scale_flush(unsigned long data)
 
 		rs_sta->flush_time = msecs_to_jiffies(duration);
 
-		IWL_DEBUG_RATE("new flush period: %d msec ave %d\n",
+		IWL_DEBUG_RATE(priv, "new flush period: %d msec ave %d\n",
 			       duration, packet_count);
 
 		mod_timer(&rs_sta->rate_scale_flush, jiffies +
@@ -274,7 +274,7 @@ static void iwl3945_bg_rate_scale_flush(unsigned long data)
 
 	spin_unlock_irqrestore(&rs_sta->lock, flags);
 
-	IWL_DEBUG_RATE("leave\n");
+	IWL_DEBUG_RATE(priv, "leave\n");
 }
 
 /**
@@ -293,7 +293,7 @@ static void iwl3945_collect_tx_data(struct iwl3945_rs_sta *rs_sta,
 	struct iwl_priv *priv __maybe_unused = rs_sta->priv;
 
 	if (!retries) {
-		IWL_DEBUG_RATE("leave: retries == 0 -- should be at least 1\n");
+		IWL_DEBUG_RATE(priv, "leave: retries == 0 -- should be at least 1\n");
 		return;
 	}
 
@@ -347,7 +347,7 @@ static void rs_rate_init(void *priv_r, struct ieee80211_supported_band *sband,
 	struct iwl_priv *priv = (struct iwl_priv *)priv_r;
 	int i;
 
-	IWL_DEBUG_RATE("enter\n");
+	IWL_DEBUG_RATE(priv, "enter\n");
 
 	/* TODO: what is a good starting rate for STA? About middle? Maybe not
 	 * the lowest or the highest rate.. Could consider using RSSI from
@@ -370,7 +370,7 @@ static void rs_rate_init(void *priv_r, struct ieee80211_supported_band *sband,
 	}
 
 
-	IWL_DEBUG_RATE("leave\n");
+	IWL_DEBUG_RATE(priv, "leave\n");
 }
 
 static void *rs_alloc(struct ieee80211_hw *hw, struct dentry *debugfsdir)
@@ -396,11 +396,11 @@ static void *rs_alloc_sta(void *iwl_priv, struct ieee80211_sta *sta, gfp_t gfp)
 	 *	as well just put all the information there.
 	 */
 
-	IWL_DEBUG_RATE("enter\n");
+	IWL_DEBUG_RATE(priv, "enter\n");
 
 	rs_sta = kzalloc(sizeof(struct iwl3945_rs_sta), gfp);
 	if (!rs_sta) {
-		IWL_DEBUG_RATE("leave: ENOMEM\n");
+		IWL_DEBUG_RATE(priv, "leave: ENOMEM\n");
 		return NULL;
 	}
 
@@ -428,7 +428,7 @@ static void *rs_alloc_sta(void *iwl_priv, struct ieee80211_sta *sta, gfp_t gfp)
 	for (i = 0; i < IWL_RATE_COUNT_3945; i++)
 		iwl3945_clear_window(&rs_sta->win[i]);
 
-	IWL_DEBUG_RATE("leave\n");
+	IWL_DEBUG_RATE(priv, "leave\n");
 
 	return rs_sta;
 }
@@ -442,10 +442,10 @@ static void rs_free_sta(void *iwl_priv, struct ieee80211_sta *sta,
 
 	psta->rs_sta = NULL;
 
-	IWL_DEBUG_RATE("enter\n");
+	IWL_DEBUG_RATE(priv, "enter\n");
 	del_timer_sync(&rs_sta->rate_scale_flush);
 	kfree(rs_sta);
-	IWL_DEBUG_RATE("leave\n");
+	IWL_DEBUG_RATE(priv, "leave\n");
 }
 
 
@@ -466,18 +466,18 @@ static void rs_tx_status(void *priv_rate, struct ieee80211_supported_band *sband
 	struct iwl3945_rs_sta *rs_sta = priv_sta;
 	struct ieee80211_tx_info *info = IEEE80211_SKB_CB(skb);
 
-	IWL_DEBUG_RATE("enter\n");
+	IWL_DEBUG_RATE(priv, "enter\n");
 
 	retries = info->status.rates[0].count;
 
 	first_index = sband->bitrates[info->status.rates[0].idx].hw_value;
 	if ((first_index < 0) || (first_index >= IWL_RATE_COUNT_3945)) {
-		IWL_DEBUG_RATE("leave: Rate out of bounds: %d\n", first_index);
+		IWL_DEBUG_RATE(priv, "leave: Rate out of bounds: %d\n", first_index);
 		return;
 	}
 
 	if (!priv_sta) {
-		IWL_DEBUG_RATE("leave: No STA priv data to update!\n");
+		IWL_DEBUG_RATE(priv, "leave: No STA priv data to update!\n");
 		return;
 	}
 
@@ -511,7 +511,7 @@ static void rs_tx_status(void *priv_rate, struct ieee80211_supported_band *sband
 		iwl3945_collect_tx_data(rs_sta,
 				    &rs_sta->win[scale_rate_index],
 				    0, current_count, scale_rate_index);
-		IWL_DEBUG_RATE("Update rate %d for %d retries.\n",
+		IWL_DEBUG_RATE(priv, "Update rate %d for %d retries.\n",
 			       scale_rate_index, current_count);
 
 		retries -= current_count;
@@ -521,7 +521,7 @@ static void rs_tx_status(void *priv_rate, struct ieee80211_supported_band *sband
 
 
 	/* Update the last index window with success/failure based on ACK */
-	IWL_DEBUG_RATE("Update rate %d with %s.\n",
+	IWL_DEBUG_RATE(priv, "Update rate %d with %s.\n",
 		       last_index,
 		       (info->flags & IEEE80211_TX_STAT_ACK) ?
 		       "success" : "failure");
@@ -546,7 +546,7 @@ static void rs_tx_status(void *priv_rate, struct ieee80211_supported_band *sband
 
 	spin_unlock_irqrestore(&rs_sta->lock, flags);
 
-	IWL_DEBUG_RATE("leave\n");
+	IWL_DEBUG_RATE(priv, "leave\n");
 
 	return;
 }
@@ -596,7 +596,7 @@ static u16 iwl3945_get_adjacent_rate(struct iwl3945_rs_sta *rs_sta,
 			break;
 		if (rate_mask & (1 << low))
 			break;
-		IWL_DEBUG_RATE("Skipping masked lower rate: %d\n", low);
+		IWL_DEBUG_RATE(priv, "Skipping masked lower rate: %d\n", low);
 	}
 
 	high = index;
@@ -609,7 +609,7 @@ static u16 iwl3945_get_adjacent_rate(struct iwl3945_rs_sta *rs_sta,
 			break;
 		if (rate_mask & (1 << high))
 			break;
-		IWL_DEBUG_RATE("Skipping masked higher rate: %d\n", high);
+		IWL_DEBUG_RATE(priv, "Skipping masked higher rate: %d\n", high);
 	}
 
 	return (high << 8) | low;
@@ -655,7 +655,7 @@ static void rs_get_rate(void *priv_r, struct ieee80211_sta *sta,
 	struct iwl_priv *priv = (struct iwl_priv *)priv_r;
 	struct ieee80211_tx_info *info = IEEE80211_SKB_CB(skb);
 
-	IWL_DEBUG_RATE("enter\n");
+	IWL_DEBUG_RATE(priv, "enter\n");
 
 	if (sta)
 		rate_mask = sta->supp_rates[sband->band];
@@ -666,7 +666,7 @@ static void rs_get_rate(void *priv_r, struct ieee80211_sta *sta,
 	if ((fc & IEEE80211_FCTL_FTYPE) != IEEE80211_FTYPE_DATA ||
 	    is_multicast_ether_addr(hdr->addr1) ||
 	    !sta || !priv_sta) {
-		IWL_DEBUG_RATE("leave: No STA priv data to update!\n");
+		IWL_DEBUG_RATE(priv, "leave: No STA priv data to update!\n");
 		if (!rate_mask)
 			info->control.rates[0].idx =
 					rate_lowest_index(sband, NULL);
@@ -693,7 +693,7 @@ static void rs_get_rate(void *priv_r, struct ieee80211_sta *sta,
 		u8 sta_id = iwl3945_hw_find_station(priv, hdr->addr1);
 
 		if (sta_id == IWL_INVALID_STATION) {
-			IWL_DEBUG_RATE("LQ: ADD station %pm\n",
+			IWL_DEBUG_RATE(priv, "LQ: ADD station %pm\n",
 				       hdr->addr1);
 			sta_id = iwl3945_add_station(priv,
 				    hdr->addr1, 0, CMD_ASYNC);
@@ -728,7 +728,7 @@ static void rs_get_rate(void *priv_r, struct ieee80211_sta *sta,
 	     (window->success_counter < IWL_RATE_MIN_SUCCESS_TH))) {
 		spin_unlock_irqrestore(&rs_sta->lock, flags);
 
-		IWL_DEBUG_RATE("Invalid average_tpt on rate %d: "
+		IWL_DEBUG_RATE(priv, "Invalid average_tpt on rate %d: "
 			       "counter: %d, success_counter: %d, "
 			       "expected_tpt is %sNULL\n",
 			       index,
@@ -761,7 +761,7 @@ static void rs_get_rate(void *priv_r, struct ieee80211_sta *sta,
 	scale_action = 1;
 
 	if ((window->success_ratio < IWL_RATE_DECREASE_TH) || !current_tpt) {
-		IWL_DEBUG_RATE("decrease rate because of low success_ratio\n");
+		IWL_DEBUG_RATE(priv, "decrease rate because of low success_ratio\n");
 		scale_action = -1;
 	} else if ((low_tpt == IWL_INVALID_VALUE) &&
 		   (high_tpt == IWL_INVALID_VALUE))
@@ -769,7 +769,7 @@ static void rs_get_rate(void *priv_r, struct ieee80211_sta *sta,
 	else if ((low_tpt != IWL_INVALID_VALUE) &&
 		 (high_tpt != IWL_INVALID_VALUE) &&
 		 (low_tpt < current_tpt) && (high_tpt < current_tpt)) {
-		IWL_DEBUG_RATE("No action -- low [%d] & high [%d] < "
+		IWL_DEBUG_RATE(priv, "No action -- low [%d] & high [%d] < "
 			       "current_tpt [%d]\n",
 			       low_tpt, high_tpt, current_tpt);
 		scale_action = 0;
@@ -778,14 +778,14 @@ static void rs_get_rate(void *priv_r, struct ieee80211_sta *sta,
 			if (high_tpt > current_tpt)
 				scale_action = 1;
 			else {
-				IWL_DEBUG_RATE
-				    ("decrease rate because of high tpt\n");
+				IWL_DEBUG_RATE(priv,
+				    "decrease rate because of high tpt\n");
 				scale_action = -1;
 			}
 		} else if (low_tpt != IWL_INVALID_VALUE) {
 			if (low_tpt > current_tpt) {
-				IWL_DEBUG_RATE
-				    ("decrease rate because of low tpt\n");
+				IWL_DEBUG_RATE(priv,
+				    "decrease rate because of low tpt\n");
 				scale_action = -1;
 			} else
 				scale_action = 1;
@@ -797,7 +797,7 @@ static void rs_get_rate(void *priv_r, struct ieee80211_sta *sta,
 			scale_action = 0;
 	} else if (scale_action == 1) {
 		if (window->success_ratio < IWL_SUCCESS_UP_TH) {
-			IWL_DEBUG_RATE("No action -- success_ratio [%d] < "
+			IWL_DEBUG_RATE(priv, "No action -- success_ratio [%d] < "
 			       "SUCCESS UP\n", window->success_ratio);
 			scale_action = 0;
 		}
@@ -820,7 +820,7 @@ static void rs_get_rate(void *priv_r, struct ieee80211_sta *sta,
 		break;
 	}
 
-	IWL_DEBUG_RATE("Selected %d (action %d) - low %d high %d\n",
+	IWL_DEBUG_RATE(priv, "Selected %d (action %d) - low %d high %d\n",
 		       index, scale_action, low, high);
 
  out:
@@ -832,7 +832,7 @@ static void rs_get_rate(void *priv_r, struct ieee80211_sta *sta,
 	else
 		info->control.rates[0].idx = rs_sta->last_txrate_idx;
 
-	IWL_DEBUG_RATE("leave: %d\n", index);
+	IWL_DEBUG_RATE(priv, "leave: %d\n", index);
 }
 
 #ifdef CONFIG_MAC80211_DEBUGFS
@@ -915,7 +915,7 @@ void iwl3945_rate_scale_init(struct ieee80211_hw *hw, s32 sta_id)
 	struct ieee80211_sta *sta;
 	struct iwl3945_sta_priv *psta;
 
-	IWL_DEBUG_RATE("enter\n");
+	IWL_DEBUG_RATE(priv, "enter\n");
 
 	rcu_read_lock();
 
@@ -955,11 +955,11 @@ void iwl3945_rate_scale_init(struct ieee80211_hw *hw, s32 sta_id)
 	if (rssi == 0)
 		rssi = IWL_MIN_RSSI_VAL;
 
-	IWL_DEBUG(IWL_DL_INFO | IWL_DL_RATE, "Network RSSI: %d\n", rssi);
+	IWL_DEBUG_RATE(priv, "Network RSSI: %d\n", rssi);
 
 	rs_sta->start_rate = iwl3945_get_rate_index_by_rssi(rssi, priv->band);
 
-	IWL_DEBUG_RATE("leave: rssi %d assign rate index: "
+	IWL_DEBUG_RATE(priv, "leave: rssi %d assign rate index: "
 		       "%d (plcp 0x%x)\n", rssi, rs_sta->start_rate,
 		       iwl3945_rates[rs_sta->start_rate].plcp);
 	rcu_read_unlock();
diff --git a/drivers/net/wireless/iwlwifi/iwl-3945.c b/drivers/net/wireless/iwlwifi/iwl-3945.c
index b4b186d..8ff5798 100644
--- a/drivers/net/wireless/iwlwifi/iwl-3945.c
+++ b/drivers/net/wireless/iwlwifi/iwl-3945.c
@@ -170,7 +170,7 @@ void iwl3945_disable_events(struct iwl_priv *priv)
 	iwl_release_nic_access(priv);
 
 	if (IWL_EVT_DISABLE && (array_size == IWL_EVT_DISABLE_SIZE)) {
-		IWL_DEBUG_INFO("Disabling selected uCode log events at 0x%x\n",
+		IWL_DEBUG_INFO(priv, "Disabling selected uCode log events at 0x%x\n",
 			       disable_ptr);
 		ret = iwl_grab_nic_access(priv);
 		for (i = 0; i < IWL_EVT_DISABLE_SIZE; i++)
@@ -180,9 +180,9 @@ void iwl3945_disable_events(struct iwl_priv *priv)
 
 		iwl_release_nic_access(priv);
 	} else {
-		IWL_DEBUG_INFO("Selected uCode log events may be disabled\n");
-		IWL_DEBUG_INFO("  by writing \"1\"s into disable bitmap\n");
-		IWL_DEBUG_INFO("  in SRAM at 0x%x, size %d u32s\n",
+		IWL_DEBUG_INFO(priv, "Selected uCode log events may be disabled\n");
+		IWL_DEBUG_INFO(priv, "  by writing \"1\"s into disable bitmap\n");
+		IWL_DEBUG_INFO(priv, "  in SRAM at 0x%x, size %d u32s\n",
 			       disable_ptr, array_size);
 	}
 
@@ -338,11 +338,11 @@ static void iwl3945_rx_reply_tx(struct iwl_priv *priv,
 	info->flags |= ((status & TX_STATUS_MSK) == TX_STATUS_SUCCESS) ?
 				IEEE80211_TX_STAT_ACK : 0;
 
-	IWL_DEBUG_TX("Tx queue %d Status %s (0x%08x) plcp rate %d retries %d\n",
+	IWL_DEBUG_TX(priv, "Tx queue %d Status %s (0x%08x) plcp rate %d retries %d\n",
 			txq_id, iwl3945_get_tx_fail_reason(status), status,
 			tx_resp->rate, tx_resp->failure_frame);
 
-	IWL_DEBUG_TX_REPLY("Tx queue reclaim %d\n", index);
+	IWL_DEBUG_TX_REPLY(priv, "Tx queue reclaim %d\n", index);
 	iwl3945_tx_queue_reclaim(priv, txq_id, index);
 
 	if (iwl_check_bits(status, TX_ABORT_REQUIRED_MSK))
@@ -362,7 +362,7 @@ static void iwl3945_rx_reply_tx(struct iwl_priv *priv,
 void iwl3945_hw_rx_statistics(struct iwl_priv *priv, struct iwl_rx_mem_buffer *rxb)
 {
 	struct iwl_rx_packet *pkt = (void *)rxb->skb->data;
-	IWL_DEBUG_RX("Statistics notification received (%d vs %d).\n",
+	IWL_DEBUG_RX(priv, "Statistics notification received (%d vs %d).\n",
 		     (int)sizeof(struct iwl3945_notif_statistics),
 		     le32_to_cpu(pkt->len));
 
@@ -496,13 +496,13 @@ static void _iwl3945_dbg_report_frame(struct iwl_priv *priv,
 		 * MAC addresses show just the last byte (for brevity),
 		 *    but you can hack it to show more, if you'd like to. */
 		if (dataframe)
-			IWL_DEBUG_RX("%s: mhd=0x%04x, dst=0x%02x, "
+			IWL_DEBUG_RX(priv, "%s: mhd=0x%04x, dst=0x%02x, "
 				     "len=%u, rssi=%d, chnl=%d, rate=%d, \n",
 				     title, le16_to_cpu(fc), header->addr1[5],
 				     length, rssi, channel, rate);
 		else {
 			/* src/dst addresses assume managed mode */
-			IWL_DEBUG_RX("%s: 0x%04x, dst=0x%02x, "
+			IWL_DEBUG_RX(priv, "%s: 0x%04x, dst=0x%02x, "
 				     "src=0x%02x, rssi=%u, tim=%lu usec, "
 				     "phy=0x%02x, chnl=%d\n",
 				     title, le16_to_cpu(fc), header->addr1[5],
@@ -563,14 +563,14 @@ static void iwl3945_pass_packet_to_mac80211(struct iwl_priv *priv,
 
 	/* We received data from the HW, so stop the watchdog */
 	if (unlikely((len + IWL39_RX_FRAME_SIZE) > skb_tailroom(rxb->skb))) {
-		IWL_DEBUG_DROP("Corruption detected!\n");
+		IWL_DEBUG_DROP(priv, "Corruption detected!\n");
 		return;
 	}
 
 	/* We only process data packets if the interface is open */
 	if (unlikely(!priv->is_open)) {
-		IWL_DEBUG_DROP_LIMIT
-		    ("Dropping packet while interface is not open.\n");
+		IWL_DEBUG_DROP_LIMIT(priv,
+			"Dropping packet while interface is not open.\n");
 		return;
 	}
 
@@ -626,15 +626,14 @@ static void iwl3945_rx_reply_rx(struct iwl_priv *priv,
 		rx_status.flag |= RX_FLAG_SHORTPRE;
 
 	if ((unlikely(rx_stats->phy_count > 20))) {
-		IWL_DEBUG_DROP
-		    ("dsp size out of range [0,20]: "
-		     "%d/n", rx_stats->phy_count);
+		IWL_DEBUG_DROP(priv, "dsp size out of range [0,20]: %d/n",
+				rx_stats->phy_count);
 		return;
 	}
 
 	if (!(rx_end->status & RX_RES_STATUS_NO_CRC32_ERROR)
 	    || !(rx_end->status & RX_RES_STATUS_NO_RXE_OVERFLOW)) {
-		IWL_DEBUG_RX("Bad CRC or FIFO: 0x%08X.\n", rx_end->status);
+		IWL_DEBUG_RX(priv, "Bad CRC or FIFO: 0x%08X.\n", rx_end->status);
 		return;
 	}
 
@@ -673,7 +672,7 @@ static void iwl3945_rx_reply_rx(struct iwl_priv *priv,
 	}
 
 
-	IWL_DEBUG_STATS("Rssi %d noise %d qual %d sig_avg %d noise_diff %d\n",
+	IWL_DEBUG_STATS(priv, "Rssi %d noise %d qual %d sig_avg %d noise_diff %d\n",
 			rx_status.signal, rx_status.noise, rx_status.qual,
 			rx_stats_sig_avg, rx_stats_noise_diff);
 
@@ -681,7 +680,7 @@ static void iwl3945_rx_reply_rx(struct iwl_priv *priv,
 
 	network_packet = iwl3945_is_network_packet(priv, header);
 
-	IWL_DEBUG_STATS_LIMIT("[%c] %d RSSI:%d Signal:%u, Noise:%u, Rate:%u\n",
+	IWL_DEBUG_STATS_LIMIT(priv, "[%c] %d RSSI:%d Signal:%u, Noise:%u, Rate:%u\n",
 			      network_packet ? '*' : ' ',
 			      le16_to_cpu(rx_hdr->channel),
 			      rx_status.signal, rx_status.signal,
@@ -799,7 +798,7 @@ u8 iwl3945_hw_find_station(struct iwl_priv *priv, const u8 *addr)
 			goto out;
 		}
 
-	IWL_DEBUG_INFO("can not find STA %pM (total %d)\n",
+	IWL_DEBUG_INFO(priv, "can not find STA %pM (total %d)\n",
 		       addr, priv->num_stations);
  out:
 	spin_unlock_irqrestore(&priv->sta_lock, flags);
@@ -874,7 +873,7 @@ void iwl3945_hw_build_tx_cmd_rate(struct iwl_priv *priv, struct iwl_cmd *cmd,
 	/* CCK */
 	tx->supp_rates[1] = (rate_mask & 0xF);
 
-	IWL_DEBUG_RATE("Tx sta id: %d, rate: %d (plcp), flags: 0x%4X "
+	IWL_DEBUG_RATE(priv, "Tx sta id: %d, rate: %d (plcp), flags: 0x%4X "
 		       "cck/ofdm mask: 0x%x/0x%x\n", sta_id,
 		       tx->rate, le32_to_cpu(tx->tx_flags),
 		       tx->supp_rates[1], tx->supp_rates[0]);
@@ -899,7 +898,7 @@ u8 iwl3945_sync_sta(struct iwl_priv *priv, int sta_id, u16 tx_rate, u8 flags)
 
 	iwl_send_add_sta(priv,
 			 (struct iwl_addsta_cmd *)&station->sta, flags);
-	IWL_DEBUG_RATE("SCALE sync station %d to rate %d\n",
+	IWL_DEBUG_RATE(priv, "SCALE sync station %d to rate %d\n",
 			sta_id, tx_rate);
 	return sta_id;
 }
@@ -1080,7 +1079,7 @@ static int iwl3945_apm_init(struct iwl_priv *priv)
 	iwl_poll_direct_bit(priv, CSR_GP_CNTRL,
 			    CSR_GP_CNTRL_REG_FLAG_MAC_CLOCK_READY, 25000);
 	if (ret < 0) {
-		IWL_DEBUG_INFO("Failed to init the card\n");
+		IWL_DEBUG_INFO(priv, "Failed to init the card\n");
 		goto out;
 	}
 
@@ -1112,31 +1111,31 @@ static void iwl3945_nic_config(struct iwl_priv *priv)
 	spin_lock_irqsave(&priv->lock, flags);
 
 	if (rev_id & PCI_CFG_REV_ID_BIT_RTP)
-		IWL_DEBUG_INFO("RTP type \n");
+		IWL_DEBUG_INFO(priv, "RTP type \n");
 	else if (rev_id & PCI_CFG_REV_ID_BIT_BASIC_SKU) {
-		IWL_DEBUG_INFO("3945 RADIO-MB type\n");
+		IWL_DEBUG_INFO(priv, "3945 RADIO-MB type\n");
 		iwl_set_bit(priv, CSR_HW_IF_CONFIG_REG,
 			    CSR39_HW_IF_CONFIG_REG_BIT_3945_MB);
 	} else {
-		IWL_DEBUG_INFO("3945 RADIO-MM type\n");
+		IWL_DEBUG_INFO(priv, "3945 RADIO-MM type\n");
 		iwl_set_bit(priv, CSR_HW_IF_CONFIG_REG,
 			    CSR39_HW_IF_CONFIG_REG_BIT_3945_MM);
 	}
 
 	if (EEPROM_SKU_CAP_OP_MODE_MRC == eeprom->sku_cap) {
-		IWL_DEBUG_INFO("SKU OP mode is mrc\n");
+		IWL_DEBUG_INFO(priv, "SKU OP mode is mrc\n");
 		iwl_set_bit(priv, CSR_HW_IF_CONFIG_REG,
 			    CSR39_HW_IF_CONFIG_REG_BIT_SKU_MRC);
 	} else
-		IWL_DEBUG_INFO("SKU OP mode is basic\n");
+		IWL_DEBUG_INFO(priv, "SKU OP mode is basic\n");
 
 	if ((eeprom->board_revision & 0xF0) == 0xD0) {
-		IWL_DEBUG_INFO("3945ABG revision is 0x%X\n",
+		IWL_DEBUG_INFO(priv, "3945ABG revision is 0x%X\n",
 			       eeprom->board_revision);
 		iwl_set_bit(priv, CSR_HW_IF_CONFIG_REG,
 			    CSR39_HW_IF_CONFIG_REG_BIT_BOARD_TYPE);
 	} else {
-		IWL_DEBUG_INFO("3945ABG revision is 0x%X\n",
+		IWL_DEBUG_INFO(priv, "3945ABG revision is 0x%X\n",
 			       eeprom->board_revision);
 		iwl_clear_bit(priv, CSR_HW_IF_CONFIG_REG,
 			      CSR39_HW_IF_CONFIG_REG_BIT_BOARD_TYPE);
@@ -1145,10 +1144,10 @@ static void iwl3945_nic_config(struct iwl_priv *priv)
 	if (eeprom->almgor_m_version <= 1) {
 		iwl_set_bit(priv, CSR_HW_IF_CONFIG_REG,
 			    CSR39_HW_IF_CONFIG_REG_BITS_SILICON_TYPE_A);
-		IWL_DEBUG_INFO("Card M type A version is 0x%X\n",
+		IWL_DEBUG_INFO(priv, "Card M type A version is 0x%X\n",
 			       eeprom->almgor_m_version);
 	} else {
-		IWL_DEBUG_INFO("Card M type B version is 0x%X\n",
+		IWL_DEBUG_INFO(priv, "Card M type B version is 0x%X\n",
 			       eeprom->almgor_m_version);
 		iwl_set_bit(priv, CSR_HW_IF_CONFIG_REG,
 			    CSR39_HW_IF_CONFIG_REG_BITS_SILICON_TYPE_B);
@@ -1156,10 +1155,10 @@ static void iwl3945_nic_config(struct iwl_priv *priv)
 	spin_unlock_irqrestore(&priv->lock, flags);
 
 	if (eeprom->sku_cap & EEPROM_SKU_CAP_SW_RF_KILL_ENABLE)
-		IWL_DEBUG_RF_KILL("SW RF KILL supported in EEPROM.\n");
+		IWL_DEBUG_RF_KILL(priv, "SW RF KILL supported in EEPROM.\n");
 
 	if (eeprom->sku_cap & EEPROM_SKU_CAP_HW_RF_KILL_ENABLE)
-		IWL_DEBUG_RF_KILL("HW RF KILL supported in EEPROM.\n");
+		IWL_DEBUG_RF_KILL(priv, "HW RF KILL supported in EEPROM.\n");
 }
 
 int iwl3945_hw_nic_init(struct iwl_priv *priv)
@@ -1177,7 +1176,7 @@ int iwl3945_hw_nic_init(struct iwl_priv *priv)
 	rc = pci_read_config_byte(priv->pci_dev, PCI_REVISION_ID, &rev_id);
 	if (rc)
 		return rc;
-	IWL_DEBUG_INFO("HW Revision ID = 0x%X\n", rev_id);
+	IWL_DEBUG_INFO(priv, "HW Revision ID = 0x%X\n", rev_id);
 
 	rc = priv->cfg->ops->lib->apm_ops.set_pwr_src(priv, IWL_PWR_SRC_VMAIN);
 	if(rc)
@@ -1286,7 +1285,7 @@ static int iwl3945_apm_stop_master(struct iwl_priv *priv)
 
 out:
 	spin_unlock_irqrestore(&priv->lock, flags);
-	IWL_DEBUG_INFO("stop master\n");
+	IWL_DEBUG_INFO(priv, "stop master\n");
 
 	return ret;
 }
@@ -1391,7 +1390,7 @@ static int iwl3945_hw_reg_txpower_get_temperature(struct iwl_priv *priv)
 
 	/* driver's okay range is -260 to +25.
 	 *   human readable okay range is 0 to +285 */
-	IWL_DEBUG_INFO("Temperature: %d\n", temperature + IWL_TEMP_CONVERT);
+	IWL_DEBUG_INFO(priv, "Temperature: %d\n", temperature + IWL_TEMP_CONVERT);
 
 	/* handle insane temp reading */
 	if (iwl3945_hw_reg_temp_out_of_range(temperature)) {
@@ -1428,20 +1427,20 @@ static int is_temp_calib_needed(struct iwl_priv *priv)
 
 	/* get absolute value */
 	if (temp_diff < 0) {
-		IWL_DEBUG_POWER("Getting cooler, delta %d,\n", temp_diff);
+		IWL_DEBUG_POWER(priv, "Getting cooler, delta %d,\n", temp_diff);
 		temp_diff = -temp_diff;
 	} else if (temp_diff == 0)
-		IWL_DEBUG_POWER("Same temp,\n");
+		IWL_DEBUG_POWER(priv, "Same temp,\n");
 	else
-		IWL_DEBUG_POWER("Getting warmer, delta %d,\n", temp_diff);
+		IWL_DEBUG_POWER(priv, "Getting warmer, delta %d,\n", temp_diff);
 
 	/* if we don't need calibration, *don't* update last_temperature */
 	if (temp_diff < IWL_TEMPERATURE_LIMIT_TIMER) {
-		IWL_DEBUG_POWER("Timed thermal calib not needed\n");
+		IWL_DEBUG_POWER(priv, "Timed thermal calib not needed\n");
 		return 0;
 	}
 
-	IWL_DEBUG_POWER("Timed thermal calib needed\n");
+	IWL_DEBUG_POWER(priv, "Timed thermal calib needed\n");
 
 	/* assume that caller will actually do calib ...
 	 *   update the "last temperature" value */
@@ -1710,7 +1709,7 @@ static int iwl3945_send_tx_power(struct iwl_priv *priv)
 	}
 
 	if (!is_channel_valid(ch_info)) {
-		IWL_DEBUG_POWER("Not calling TX_PWR_TABLE_CMD on "
+		IWL_DEBUG_POWER(priv, "Not calling TX_PWR_TABLE_CMD on "
 				"non-Tx channel.\n");
 		return 0;
 	}
@@ -1723,7 +1722,7 @@ static int iwl3945_send_tx_power(struct iwl_priv *priv)
 		txpower.power[i].tpc = ch_info->power_info[i].tpc;
 		txpower.power[i].rate = iwl3945_rates[rate_idx].plcp;
 
-		IWL_DEBUG_POWER("ch %d:%d rf %d dsp %3d rate code 0x%02x\n",
+		IWL_DEBUG_POWER(priv, "ch %d:%d rf %d dsp %3d rate code 0x%02x\n",
 				le16_to_cpu(txpower.channel),
 				txpower.band,
 				txpower.power[i].tpc.tx_gain,
@@ -1736,7 +1735,7 @@ static int iwl3945_send_tx_power(struct iwl_priv *priv)
 		txpower.power[i].tpc = ch_info->power_info[i].tpc;
 		txpower.power[i].rate = iwl3945_rates[rate_idx].plcp;
 
-		IWL_DEBUG_POWER("ch %d:%d rf %d dsp %3d rate code 0x%02x\n",
+		IWL_DEBUG_POWER(priv, "ch %d:%d rf %d dsp %3d rate code 0x%02x\n",
 				le16_to_cpu(txpower.channel),
 				txpower.band,
 				txpower.power[i].tpc.tx_gain,
@@ -1927,12 +1926,12 @@ int iwl3945_hw_reg_set_txpower(struct iwl_priv *priv, s8 power)
 	u8 i;
 
 	if (priv->tx_power_user_lmt == power) {
-		IWL_DEBUG_POWER("Requested Tx power same as current "
+		IWL_DEBUG_POWER(priv, "Requested Tx power same as current "
 				"limit: %ddBm.\n", power);
 		return 0;
 	}
 
-	IWL_DEBUG_POWER("Setting upper limit clamp to %ddBm.\n", power);
+	IWL_DEBUG_POWER(priv, "Setting upper limit clamp to %ddBm.\n", power);
 	priv->tx_power_user_lmt = power;
 
 	/* set up new Tx powers for each and every channel, 2.4 and 5.x */
@@ -2042,7 +2041,7 @@ static u16 iwl3945_hw_reg_get_ch_grp_index(struct iwl_priv *priv,
 	} else
 		group_index = 0;	/* 2.4 GHz, group 0 */
 
-	IWL_DEBUG_POWER("Chnl %d mapped to grp %d\n", ch_info->channel,
+	IWL_DEBUG_POWER(priv, "Chnl %d mapped to grp %d\n", ch_info->channel,
 			group_index);
 	return group_index;
 }
@@ -2109,7 +2108,7 @@ static void iwl3945_hw_reg_init_channel_groups(struct iwl_priv *priv)
 	struct iwl3945_eeprom *eeprom = (struct iwl3945_eeprom *)priv->eeprom;
 	const struct iwl3945_eeprom_txpower_group *group;
 
-	IWL_DEBUG_POWER("Initializing factory calib info from EEPROM\n");
+	IWL_DEBUG_POWER(priv, "Initializing factory calib info from EEPROM\n");
 
 	for (i = 0; i < IWL_NUM_TX_CALIB_GROUPS; i++) {
 		s8 *clip_pwrs;	/* table of power levels for each rate */
@@ -2225,7 +2224,7 @@ int iwl3945_txpower_set_from_eeprom(struct iwl_priv *priv)
 				eeprom->groups[ch_info->group_index].
 				temperature);
 
-		IWL_DEBUG_POWER("Delta index for channel %d: %d [%d]\n",
+		IWL_DEBUG_POWER(priv, "Delta index for channel %d: %d [%d]\n",
 				ch_info->channel, delta_index, temperature +
 				IWL_TEMP_CONVERT);
 
@@ -2410,7 +2409,7 @@ int iwl3945_init_hw_rate_table(struct iwl_priv *priv)
 
 	switch (priv->band) {
 	case IEEE80211_BAND_5GHZ:
-		IWL_DEBUG_RATE("Select A mode rate scale\n");
+		IWL_DEBUG_RATE(priv, "Select A mode rate scale\n");
 		/* If one of the following CCK rates is used,
 		 * have it fall back to the 6M OFDM rate */
 		for (i = IWL_RATE_1M_INDEX_TABLE;
@@ -2428,7 +2427,7 @@ int iwl3945_init_hw_rate_table(struct iwl_priv *priv)
 		break;
 
 	case IEEE80211_BAND_2GHZ:
-		IWL_DEBUG_RATE("Select B/G mode rate scale\n");
+		IWL_DEBUG_RATE(priv, "Select B/G mode rate scale\n");
 		/* If an OFDM rate is used, have it fall back to the
 		 * 1M CCK rates */
 
@@ -2553,7 +2552,7 @@ static int iwl3945_verify_bsm(struct iwl_priv *priv)
 	u32 reg;
 	u32 val;
 
-	IWL_DEBUG_INFO("Begin verify bsm\n");
+	IWL_DEBUG_INFO(priv, "Begin verify bsm\n");
 
 	/* verify BSM SRAM contents */
 	val = iwl_read_prph(priv, BSM_WR_DWCOUNT_REG);
@@ -2571,7 +2570,7 @@ static int iwl3945_verify_bsm(struct iwl_priv *priv)
 		}
 	}
 
-	IWL_DEBUG_INFO("BSM bootstrap uCode image OK\n");
+	IWL_DEBUG_INFO(priv, "BSM bootstrap uCode image OK\n");
 
 	return 0;
 }
@@ -2648,7 +2647,7 @@ static int iwl3945_load_bsm(struct iwl_priv *priv)
 	u32 done;
 	u32 reg_offset;
 
-	IWL_DEBUG_INFO("Begin load bsm\n");
+	IWL_DEBUG_INFO(priv, "Begin load bsm\n");
 
 	/* make sure bootstrap program is no larger than BSM's SRAM size */
 	if (len > IWL39_MAX_BSM_SIZE)
@@ -2705,7 +2704,7 @@ static int iwl3945_load_bsm(struct iwl_priv *priv)
 		udelay(10);
 	}
 	if (i < 100)
-		IWL_DEBUG_INFO("BSM write complete, poll %d iterations\n", i);
+		IWL_DEBUG_INFO(priv, "BSM write complete, poll %d iterations\n", i);
 	else {
 		IWL_ERR(priv, "BSM write did not complete!\n");
 		return -EIO;
diff --git a/drivers/net/wireless/iwlwifi/iwl-4965.c b/drivers/net/wireless/iwlwifi/iwl-4965.c
index d7d956d..7e9c8cf 100644
--- a/drivers/net/wireless/iwlwifi/iwl-4965.c
+++ b/drivers/net/wireless/iwlwifi/iwl-4965.c
@@ -76,7 +76,7 @@ static int iwl4965_verify_bsm(struct iwl_priv *priv)
 	u32 reg;
 	u32 val;
 
-	IWL_DEBUG_INFO("Begin verify bsm\n");
+	IWL_DEBUG_INFO(priv, "Begin verify bsm\n");
 
 	/* verify BSM SRAM contents */
 	val = iwl_read_prph(priv, BSM_WR_DWCOUNT_REG);
@@ -94,7 +94,7 @@ static int iwl4965_verify_bsm(struct iwl_priv *priv)
 		}
 	}
 
-	IWL_DEBUG_INFO("BSM bootstrap uCode image OK\n");
+	IWL_DEBUG_INFO(priv, "BSM bootstrap uCode image OK\n");
 
 	return 0;
 }
@@ -144,7 +144,7 @@ static int iwl4965_load_bsm(struct iwl_priv *priv)
 	u32 reg_offset;
 	int ret;
 
-	IWL_DEBUG_INFO("Begin load bsm\n");
+	IWL_DEBUG_INFO(priv, "Begin load bsm\n");
 
 	priv->ucode_type = UCODE_RT;
 
@@ -201,7 +201,7 @@ static int iwl4965_load_bsm(struct iwl_priv *priv)
 		udelay(10);
 	}
 	if (i < 100)
-		IWL_DEBUG_INFO("BSM write complete, poll %d iterations\n", i);
+		IWL_DEBUG_INFO(priv, "BSM write complete, poll %d iterations\n", i);
 	else {
 		IWL_ERR(priv, "BSM write did not complete!\n");
 		return -EIO;
@@ -257,7 +257,7 @@ static int iwl4965_set_ucode_ptrs(struct iwl_priv *priv)
 
 	spin_unlock_irqrestore(&priv->lock, flags);
 
-	IWL_DEBUG_INFO("Runtime uCode pointers are set.\n");
+	IWL_DEBUG_INFO(priv, "Runtime uCode pointers are set.\n");
 
 	return ret;
 }
@@ -279,7 +279,7 @@ static void iwl4965_init_alive_start(struct iwl_priv *priv)
 	if (priv->card_alive_init.is_valid != UCODE_VALID_OK) {
 		/* We had an error bringing up the hardware, so take it
 		 * all the way back down so we can try again */
-		IWL_DEBUG_INFO("Initialize Alive failed.\n");
+		IWL_DEBUG_INFO(priv, "Initialize Alive failed.\n");
 		goto restart;
 	}
 
@@ -289,7 +289,7 @@ static void iwl4965_init_alive_start(struct iwl_priv *priv)
 	if (iwl_verify_ucode(priv)) {
 		/* Runtime instruction load was bad;
 		 * take it all the way back down so we can try again */
-		IWL_DEBUG_INFO("Bad \"initialize\" uCode load.\n");
+		IWL_DEBUG_INFO(priv, "Bad \"initialize\" uCode load.\n");
 		goto restart;
 	}
 
@@ -299,11 +299,11 @@ static void iwl4965_init_alive_start(struct iwl_priv *priv)
 	/* Send pointers to protocol/runtime uCode image ... init code will
 	 * load and launch runtime uCode, which will send us another "Alive"
 	 * notification. */
-	IWL_DEBUG_INFO("Initialization Alive received.\n");
+	IWL_DEBUG_INFO(priv, "Initialization Alive received.\n");
 	if (iwl4965_set_ucode_ptrs(priv)) {
 		/* Runtime instruction load won't happen;
 		 * take it all the way back down so we can try again */
-		IWL_DEBUG_INFO("Couldn't set up uCode pointers.\n");
+		IWL_DEBUG_INFO(priv, "Couldn't set up uCode pointers.\n");
 		goto restart;
 	}
 	return;
@@ -354,7 +354,7 @@ static int iwl4965_apm_init(struct iwl_priv *priv)
 	ret = iwl_poll_direct_bit(priv, CSR_GP_CNTRL,
 			CSR_GP_CNTRL_REG_FLAG_MAC_CLOCK_READY, 25000);
 	if (ret < 0) {
-		IWL_DEBUG_INFO("Failed to init the card\n");
+		IWL_DEBUG_INFO(priv, "Failed to init the card\n");
 		goto out;
 	}
 
@@ -437,7 +437,7 @@ static int iwl4965_apm_stop_master(struct iwl_priv *priv)
 			CSR_RESET_REG_FLAG_MASTER_DISABLED, 100);
 
 	spin_unlock_irqrestore(&priv->lock, flags);
-	IWL_DEBUG_INFO("stop master\n");
+	IWL_DEBUG_INFO(priv, "stop master\n");
 
 	return 0;
 }
@@ -526,7 +526,7 @@ static void iwl4965_chain_noise_reset(struct iwl_priv *priv)
 			IWL_ERR(priv,
 				"Could not send REPLY_PHY_CALIBRATION_CMD\n");
 		data->state = IWL_CHAIN_NOISE_ACCUMULATE;
-		IWL_DEBUG_CALIB("Run chain_noise_calibrate\n");
+		IWL_DEBUG_CALIB(priv, "Run chain_noise_calibrate\n");
 	}
 }
 
@@ -558,7 +558,7 @@ static void iwl4965_gain_computation(struct iwl_priv *priv,
 			data->delta_gain_code[i] = 0;
 		}
 	}
-	IWL_DEBUG_CALIB("delta_gain_codes: a %d b %d c %d\n",
+	IWL_DEBUG_CALIB(priv, "delta_gain_codes: a %d b %d c %d\n",
 		     data->delta_gain_code[0],
 		     data->delta_gain_code[1],
 		     data->delta_gain_code[2]);
@@ -576,7 +576,7 @@ static void iwl4965_gain_computation(struct iwl_priv *priv,
 		ret = iwl_send_cmd_pdu(priv, REPLY_PHY_CALIBRATION_CMD,
 				      sizeof(cmd), &cmd);
 		if (ret)
-			IWL_DEBUG_CALIB("fail sending cmd "
+			IWL_DEBUG_CALIB(priv, "fail sending cmd "
 				     "REPLY_PHY_CALIBRATION_CMD \n");
 
 		/* TODO we might want recalculate
@@ -669,7 +669,7 @@ static void iwl4965_tx_queue_set_status(struct iwl_priv *priv,
 
 	txq->sched_retry = scd_retry;
 
-	IWL_DEBUG_INFO("%s %s Queue %d on AC %d\n",
+	IWL_DEBUG_INFO(priv, "%s %s Queue %d on AC %d\n",
 		       active ? "Activate" : "Deactivate",
 		       scd_retry ? "BA" : "AC", txq_id, tx_fifo_id);
 }
@@ -968,7 +968,7 @@ static int iwl4965_interpolate_chan(struct iwl_priv *priv, u32 channel,
 	ch_i2 = priv->calib_info->band_info[s].ch2.ch_num;
 	chan_info->ch_num = (u8) channel;
 
-	IWL_DEBUG_TXPOWER("channel %d subband %d factory cal ch %d & %d\n",
+	IWL_DEBUG_TXPOWER(priv, "channel %d subband %d factory cal ch %d & %d\n",
 			  channel, s, ch_i1, ch_i2);
 
 	for (c = 0; c < EEPROM_TX_POWER_TX_CHAINS; c++) {
@@ -998,19 +998,19 @@ static int iwl4965_interpolate_chan(struct iwl_priv *priv, u32 channel,
 							   m1->pa_det, ch_i2,
 							   m2->pa_det);
 
-			IWL_DEBUG_TXPOWER
-			    ("chain %d meas %d AP1=%d AP2=%d AP=%d\n", c, m,
-			     m1->actual_pow, m2->actual_pow, omeas->actual_pow);
-			IWL_DEBUG_TXPOWER
-			    ("chain %d meas %d NI1=%d NI2=%d NI=%d\n", c, m,
-			     m1->gain_idx, m2->gain_idx, omeas->gain_idx);
-			IWL_DEBUG_TXPOWER
-			    ("chain %d meas %d PA1=%d PA2=%d PA=%d\n", c, m,
-			     m1->pa_det, m2->pa_det, omeas->pa_det);
-			IWL_DEBUG_TXPOWER
-			    ("chain %d meas %d  T1=%d  T2=%d  T=%d\n", c, m,
-			     m1->temperature, m2->temperature,
-			     omeas->temperature);
+			IWL_DEBUG_TXPOWER(priv,
+				"chain %d meas %d AP1=%d AP2=%d AP=%d\n", c, m,
+				m1->actual_pow, m2->actual_pow, omeas->actual_pow);
+			IWL_DEBUG_TXPOWER(priv,
+				"chain %d meas %d NI1=%d NI2=%d NI=%d\n", c, m,
+				m1->gain_idx, m2->gain_idx, omeas->gain_idx);
+			IWL_DEBUG_TXPOWER(priv,
+				"chain %d meas %d PA1=%d PA2=%d PA=%d\n", c, m,
+				m1->pa_det, m2->pa_det, omeas->pa_det);
+			IWL_DEBUG_TXPOWER(priv,
+				"chain %d meas %d  T1=%d  T2=%d  T=%d\n", c, m,
+				m1->temperature, m2->temperature,
+				omeas->temperature);
 		}
 	}
 
@@ -1312,7 +1312,7 @@ static int iwl4965_fill_txpower_tbl(struct iwl_priv *priv, u8 band, u16 channel,
 	user_target_power = 2 * priv->tx_power_user_lmt;
 
 	/* Get current (RXON) channel, band, width */
-	IWL_DEBUG_TXPOWER("chan %d band %d is_fat %d\n", channel, band,
+	IWL_DEBUG_TXPOWER(priv, "chan %d band %d is_fat %d\n", channel, band,
 			  is_fat);
 
 	ch_info = iwl_get_channel_info(priv, priv->band, channel);
@@ -1329,7 +1329,7 @@ static int iwl4965_fill_txpower_tbl(struct iwl_priv *priv, u8 band, u16 channel,
 		return -EINVAL;
 	}
 
-	IWL_DEBUG_TXPOWER("channel %d belongs to txatten group %d\n",
+	IWL_DEBUG_TXPOWER(priv, "channel %d belongs to txatten group %d\n",
 			  channel, txatten_grp);
 
 	if (is_fat) {
@@ -1379,7 +1379,7 @@ static int iwl4965_fill_txpower_tbl(struct iwl_priv *priv, u8 band, u16 channel,
 	voltage_compensation =
 	    iwl4965_get_voltage_compensation(voltage, init_voltage);
 
-	IWL_DEBUG_TXPOWER("curr volt %d eeprom volt %d volt comp %d\n",
+	IWL_DEBUG_TXPOWER(priv, "curr volt %d eeprom volt %d volt comp %d\n",
 			  init_voltage,
 			  voltage, voltage_compensation);
 
@@ -1410,13 +1410,13 @@ static int iwl4965_fill_txpower_tbl(struct iwl_priv *priv, u8 band, u16 channel,
 		factory_gain_index[c] = measurement->gain_idx;
 		factory_actual_pwr[c] = measurement->actual_pow;
 
-		IWL_DEBUG_TXPOWER("chain = %d\n", c);
-		IWL_DEBUG_TXPOWER("fctry tmp %d, "
+		IWL_DEBUG_TXPOWER(priv, "chain = %d\n", c);
+		IWL_DEBUG_TXPOWER(priv, "fctry tmp %d, "
 				  "curr tmp %d, comp %d steps\n",
 				  factory_temp, current_temp,
 				  temperature_comp[c]);
 
-		IWL_DEBUG_TXPOWER("fctry idx %d, fctry pwr %d\n",
+		IWL_DEBUG_TXPOWER(priv, "fctry idx %d, fctry pwr %d\n",
 				  factory_gain_index[c],
 				  factory_actual_pwr[c]);
 	}
@@ -1449,7 +1449,7 @@ static int iwl4965_fill_txpower_tbl(struct iwl_priv *priv, u8 band, u16 channel,
 		if (target_power > power_limit)
 			target_power = power_limit;
 
-		IWL_DEBUG_TXPOWER("rate %d sat %d reg %d usr %d tgt %d\n",
+		IWL_DEBUG_TXPOWER(priv, "rate %d sat %d reg %d usr %d tgt %d\n",
 				  i, saturation_power - back_off_table[i],
 				  current_regulatory, user_target_power,
 				  target_power);
@@ -1473,7 +1473,7 @@ static int iwl4965_fill_txpower_tbl(struct iwl_priv *priv, u8 band, u16 channel,
 					    voltage_compensation +
 					    atten_value);
 
-/*			IWL_DEBUG_TXPOWER("calculated txpower index %d\n",
+/*			IWL_DEBUG_TXPOWER(priv, "calculated txpower index %d\n",
 						power_index); */
 
 			if (power_index < get_min_power_index(i, band))
@@ -1506,7 +1506,7 @@ static int iwl4965_fill_txpower_tbl(struct iwl_priv *priv, u8 band, u16 channel,
 			tx_power.s.dsp_predis_atten[c] =
 				gain_table[band][power_index].dsp;
 
-			IWL_DEBUG_TXPOWER("chain %d mimo %d index %d "
+			IWL_DEBUG_TXPOWER(priv, "chain %d mimo %d index %d "
 					  "gain 0x%02x dsp %d\n",
 					  c, atten_value, power_index,
 					tx_power.s.radio_tx_gain[c],
@@ -1581,7 +1581,7 @@ static int iwl4965_send_rxon_assoc(struct iwl_priv *priv)
 	     rxon2->ofdm_ht_dual_stream_basic_rates) &&
 	    (rxon1->rx_chain == rxon2->rx_chain) &&
 	    (rxon1->ofdm_basic_rates == rxon2->ofdm_basic_rates)) {
-		IWL_DEBUG_INFO("Using current RXON_ASSOC.  Not resending.\n");
+		IWL_DEBUG_INFO(priv, "Using current RXON_ASSOC.  Not resending.\n");
 		return 0;
 	}
 
@@ -1638,7 +1638,7 @@ static int iwl4965_hw_channel_switch(struct iwl_priv *priv, u16 channel)
 	rc = iwl4965_fill_txpower_tbl(priv, band, channel, is_fat,
 				      ctrl_chan_high, &cmd.tx_power);
 	if (rc) {
-		IWL_DEBUG_11H("error:%d  fill txpower_tbl\n", rc);
+		IWL_DEBUG_11H(priv, "error:%d  fill txpower_tbl\n", rc);
 		return rc;
 	}
 
@@ -1703,13 +1703,13 @@ static int iwl4965_hw_get_temperature(const struct iwl_priv *priv)
 
 	if (test_bit(STATUS_TEMPERATURE, &priv->status) &&
 		(priv->statistics.flag & STATISTICS_REPLY_FLG_FAT_MODE_MSK)) {
-		IWL_DEBUG_TEMP("Running FAT temperature calibration\n");
+		IWL_DEBUG_TEMP(priv, "Running FAT temperature calibration\n");
 		R1 = (s32)le32_to_cpu(priv->card_alive_init.therm_r1[1]);
 		R2 = (s32)le32_to_cpu(priv->card_alive_init.therm_r2[1]);
 		R3 = (s32)le32_to_cpu(priv->card_alive_init.therm_r3[1]);
 		R4 = le32_to_cpu(priv->card_alive_init.therm_r4[1]);
 	} else {
-		IWL_DEBUG_TEMP("Running temperature calibration\n");
+		IWL_DEBUG_TEMP(priv, "Running temperature calibration\n");
 		R1 = (s32)le32_to_cpu(priv->card_alive_init.therm_r1[0]);
 		R2 = (s32)le32_to_cpu(priv->card_alive_init.therm_r2[0]);
 		R3 = (s32)le32_to_cpu(priv->card_alive_init.therm_r3[0]);
@@ -1729,7 +1729,7 @@ static int iwl4965_hw_get_temperature(const struct iwl_priv *priv)
 		vt = sign_extend(
 			le32_to_cpu(priv->statistics.general.temperature), 23);
 
-	IWL_DEBUG_TEMP("Calib values R[1-3]: %d %d %d R4: %d\n", R1, R2, R3, vt);
+	IWL_DEBUG_TEMP(priv, "Calib values R[1-3]: %d %d %d R4: %d\n", R1, R2, R3, vt);
 
 	if (R3 == R1) {
 		IWL_ERR(priv, "Calibration conflict R1 == R3\n");
@@ -1742,7 +1742,7 @@ static int iwl4965_hw_get_temperature(const struct iwl_priv *priv)
 	temperature /= (R3 - R1);
 	temperature = (temperature * 97) / 100 + TEMPERATURE_CALIB_KELVIN_OFFSET;
 
-	IWL_DEBUG_TEMP("Calibrated temperature: %dK, %dC\n",
+	IWL_DEBUG_TEMP(priv, "Calibrated temperature: %dK, %dC\n",
 			temperature, KELVIN_TO_CELSIUS(temperature));
 
 	return temperature;
@@ -1765,7 +1765,7 @@ static int iwl4965_is_temp_calib_needed(struct iwl_priv *priv)
 	int temp_diff;
 
 	if (!test_bit(STATUS_STATISTICS, &priv->status)) {
-		IWL_DEBUG_TEMP("Temperature not updated -- no statistics.\n");
+		IWL_DEBUG_TEMP(priv, "Temperature not updated -- no statistics.\n");
 		return 0;
 	}
 
@@ -1773,19 +1773,19 @@ static int iwl4965_is_temp_calib_needed(struct iwl_priv *priv)
 
 	/* get absolute value */
 	if (temp_diff < 0) {
-		IWL_DEBUG_POWER("Getting cooler, delta %d, \n", temp_diff);
+		IWL_DEBUG_POWER(priv, "Getting cooler, delta %d, \n", temp_diff);
 		temp_diff = -temp_diff;
 	} else if (temp_diff == 0)
-		IWL_DEBUG_POWER("Same temp, \n");
+		IWL_DEBUG_POWER(priv, "Same temp, \n");
 	else
-		IWL_DEBUG_POWER("Getting warmer, delta %d, \n", temp_diff);
+		IWL_DEBUG_POWER(priv, "Getting warmer, delta %d, \n", temp_diff);
 
 	if (temp_diff < IWL_TEMPERATURE_THRESHOLD) {
-		IWL_DEBUG_POWER("Thermal txpower calib not needed\n");
+		IWL_DEBUG_POWER(priv, "Thermal txpower calib not needed\n");
 		return 0;
 	}
 
-	IWL_DEBUG_POWER("Thermal txpower calib needed\n");
+	IWL_DEBUG_POWER(priv, "Thermal txpower calib needed\n");
 
 	return 1;
 }
@@ -1800,12 +1800,12 @@ static void iwl4965_temperature_calib(struct iwl_priv *priv)
 
 	if (priv->temperature != temp) {
 		if (priv->temperature)
-			IWL_DEBUG_TEMP("Temperature changed "
+			IWL_DEBUG_TEMP(priv, "Temperature changed "
 				       "from %dC to %dC\n",
 				       KELVIN_TO_CELSIUS(priv->temperature),
 				       KELVIN_TO_CELSIUS(temp));
 		else
-			IWL_DEBUG_TEMP("Temperature "
+			IWL_DEBUG_TEMP(priv, "Temperature "
 				       "initialized to %dC\n",
 				       KELVIN_TO_CELSIUS(temp));
 	}
@@ -2022,7 +2022,7 @@ static int iwl4965_tx_status_reply_tx(struct iwl_priv *priv,
 	int i, sh, idx;
 	u16 seq;
 	if (agg->wait_for_ba)
-		IWL_DEBUG_TX_REPLY("got tx response w/o block-ack\n");
+		IWL_DEBUG_TX_REPLY(priv, "got tx response w/o block-ack\n");
 
 	agg->frame_count = tx_resp->frame_count;
 	agg->start_idx = start_idx;
@@ -2036,7 +2036,7 @@ static int iwl4965_tx_status_reply_tx(struct iwl_priv *priv,
 		idx = start_idx;
 
 		/* FIXME: code repetition */
-		IWL_DEBUG_TX_REPLY("FrameCnt = %d, StartIdx=%d idx=%d\n",
+		IWL_DEBUG_TX_REPLY(priv, "FrameCnt = %d, StartIdx=%d idx=%d\n",
 				   agg->frame_count, agg->start_idx, idx);
 
 		info = IEEE80211_SKB_CB(priv->txq[txq_id].txb[idx].skb[0]);
@@ -2047,9 +2047,9 @@ static int iwl4965_tx_status_reply_tx(struct iwl_priv *priv,
 		iwl_hwrate_to_tx_control(priv, rate_n_flags, info);
 		/* FIXME: code repetition end */
 
-		IWL_DEBUG_TX_REPLY("1 Frame 0x%x failure :%d\n",
+		IWL_DEBUG_TX_REPLY(priv, "1 Frame 0x%x failure :%d\n",
 				    status & 0xff, tx_resp->failure_frame);
-		IWL_DEBUG_TX_REPLY("Rate Info rate_n_flags=%x\n", rate_n_flags);
+		IWL_DEBUG_TX_REPLY(priv, "Rate Info rate_n_flags=%x\n", rate_n_flags);
 
 		agg->wait_for_ba = 0;
 	} else {
@@ -2069,7 +2069,7 @@ static int iwl4965_tx_status_reply_tx(struct iwl_priv *priv,
 				      AGG_TX_STATE_ABORT_MSK))
 				continue;
 
-			IWL_DEBUG_TX_REPLY("FrameCnt = %d, txq_id=%d idx=%d\n",
+			IWL_DEBUG_TX_REPLY(priv, "FrameCnt = %d, txq_id=%d idx=%d\n",
 					   agg->frame_count, txq_id, idx);
 
 			hdr = iwl_tx_queue_get_hdr(priv, txq_id, idx);
@@ -2083,7 +2083,7 @@ static int iwl4965_tx_status_reply_tx(struct iwl_priv *priv,
 				return -1;
 			}
 
-			IWL_DEBUG_TX_REPLY("AGG Frame i=%d idx %d seq=%d\n",
+			IWL_DEBUG_TX_REPLY(priv, "AGG Frame i=%d idx %d seq=%d\n",
 					   i, idx, SEQ_TO_SN(sc));
 
 			sh = idx - start;
@@ -2101,13 +2101,13 @@ static int iwl4965_tx_status_reply_tx(struct iwl_priv *priv,
 				sh = 0;
 			}
 			bitmap |= 1ULL << sh;
-			IWL_DEBUG_TX_REPLY("start=%d bitmap=0x%llx\n",
+			IWL_DEBUG_TX_REPLY(priv, "start=%d bitmap=0x%llx\n",
 					   start, (unsigned long long)bitmap);
 		}
 
 		agg->bitmap = bitmap;
 		agg->start_idx = start;
-		IWL_DEBUG_TX_REPLY("Frames %d start_idx=%d bitmap=0x%llx\n",
+		IWL_DEBUG_TX_REPLY(priv, "Frames %d start_idx=%d bitmap=0x%llx\n",
 				   agg->frame_count, agg->start_idx,
 				   (unsigned long long)agg->bitmap);
 
@@ -2176,7 +2176,7 @@ static void iwl4965_rx_reply_tx(struct iwl_priv *priv,
 
 		if (txq->q.read_ptr != (scd_ssn & 0xff)) {
 			index = iwl_queue_dec_wrap(scd_ssn & 0xff, txq->q.n_bd);
-			IWL_DEBUG_TX_REPLY("Retry scheduler reclaim scd_ssn "
+			IWL_DEBUG_TX_REPLY(priv, "Retry scheduler reclaim scd_ssn "
 					   "%d index %d\n", scd_ssn , index);
 			freed = iwl_tx_queue_reclaim(priv, txq_id, index);
 			priv->stations[sta_id].tid[tid].tfds_in_queue -= freed;
@@ -2199,7 +2199,7 @@ static void iwl4965_rx_reply_tx(struct iwl_priv *priv,
 					le32_to_cpu(tx_resp->rate_n_flags),
 					info);
 
-		IWL_DEBUG_TX_REPLY("TXQ %d status %s (0x%08x) "
+		IWL_DEBUG_TX_REPLY(priv, "TXQ %d status %s (0x%08x) "
 				   "rate_n_flags 0x%x retries %d\n",
 				   txq_id,
 				   iwl_get_tx_fail_reason(status), status,
@@ -2247,7 +2247,7 @@ static int iwl4965_calc_rssi(struct iwl_priv *priv,
 		if (valid_antennae & (1 << i))
 			max_rssi = max(ncphy->rssi_info[i << 1], max_rssi);
 
-	IWL_DEBUG_STATS("Rssi In A %d B %d C %d Max %d AGC dB %d\n",
+	IWL_DEBUG_STATS(priv, "Rssi In A %d B %d C %d Max %d AGC dB %d\n",
 		ncphy->rssi_info[0], ncphy->rssi_info[2], ncphy->rssi_info[4],
 		max_rssi, agc);
 
diff --git a/drivers/net/wireless/iwlwifi/iwl-5000.c b/drivers/net/wireless/iwlwifi/iwl-5000.c
index 89d92a8..c5e9a66 100644
--- a/drivers/net/wireless/iwlwifi/iwl-5000.c
+++ b/drivers/net/wireless/iwlwifi/iwl-5000.c
@@ -84,7 +84,7 @@ static int iwl5000_apm_stop_master(struct iwl_priv *priv)
 				  CSR_RESET_REG_FLAG_MASTER_DISABLED, 100);
 
 	spin_unlock_irqrestore(&priv->lock, flags);
-	IWL_DEBUG_INFO("stop master\n");
+	IWL_DEBUG_INFO(priv, "stop master\n");
 
 	return 0;
 }
@@ -118,7 +118,7 @@ static int iwl5000_apm_init(struct iwl_priv *priv)
 	ret = iwl_poll_direct_bit(priv, CSR_GP_CNTRL,
 			CSR_GP_CNTRL_REG_FLAG_MAC_CLOCK_READY, 25000);
 	if (ret < 0) {
-		IWL_DEBUG_INFO("Failed to init the card\n");
+		IWL_DEBUG_INFO(priv, "Failed to init the card\n");
 		return ret;
 	}
 
@@ -186,7 +186,7 @@ static int iwl5000_apm_reset(struct iwl_priv *priv)
 	ret = iwl_poll_direct_bit(priv, CSR_GP_CNTRL,
 			CSR_GP_CNTRL_REG_FLAG_MAC_CLOCK_READY, 25000);
 	if (ret < 0) {
-		IWL_DEBUG_INFO("Failed to init the card\n");
+		IWL_DEBUG_INFO(priv, "Failed to init the card\n");
 		goto out;
 	}
 
@@ -338,7 +338,7 @@ static void iwl5000_gain_computation(struct iwl_priv *priv,
 			data->delta_gain_code[i] |= (1 << 2);
 	}
 
-	IWL_DEBUG_CALIB("Delta gains: ANT_B = %d  ANT_C = %d\n",
+	IWL_DEBUG_CALIB(priv, "Delta gains: ANT_B = %d  ANT_C = %d\n",
 			data->delta_gain_code[1], data->delta_gain_code[2]);
 
 	if (!data->radio_write) {
@@ -387,7 +387,7 @@ static void iwl5000_chain_noise_reset(struct iwl_priv *priv)
 			IWL_ERR(priv,
 				"Could not send REPLY_PHY_CALIBRATION_CMD\n");
 		data->state = IWL_CHAIN_NOISE_ACCUMULATE;
-		IWL_DEBUG_CALIB("Run chain_noise_calibrate\n");
+		IWL_DEBUG_CALIB(priv, "Run chain_noise_calibrate\n");
 	}
 }
 
@@ -518,7 +518,7 @@ static void iwl5000_rx_calib_result(struct iwl_priv *priv,
 static void iwl5000_rx_calib_complete(struct iwl_priv *priv,
 			       struct iwl_rx_mem_buffer *rxb)
 {
-	IWL_DEBUG_INFO("Init. calibration is completed, restarting fw.\n");
+	IWL_DEBUG_INFO(priv, "Init. calibration is completed, restarting fw.\n");
 	queue_work(priv->workqueue, &priv->restart);
 }
 
@@ -586,7 +586,7 @@ static int iwl5000_load_given_ucode(struct iwl_priv *priv,
 	if (ret)
 		return ret;
 
-	IWL_DEBUG_INFO("INST uCode section being loaded...\n");
+	IWL_DEBUG_INFO(priv, "INST uCode section being loaded...\n");
 	ret = wait_event_interruptible_timeout(priv->wait_command_queue,
 					priv->ucode_write_complete, 5 * HZ);
 	if (ret == -ERESTARTSYS) {
@@ -606,7 +606,7 @@ static int iwl5000_load_given_ucode(struct iwl_priv *priv,
 	if (ret)
 		return ret;
 
-	IWL_DEBUG_INFO("DATA uCode section being loaded...\n");
+	IWL_DEBUG_INFO(priv, "DATA uCode section being loaded...\n");
 
 	ret = wait_event_interruptible_timeout(priv->wait_command_queue,
 				priv->ucode_write_complete, 5 * HZ);
@@ -631,20 +631,20 @@ static int iwl5000_load_ucode(struct iwl_priv *priv)
 
 	/* check whether init ucode should be loaded, or rather runtime ucode */
 	if (priv->ucode_init.len && (priv->ucode_type == UCODE_NONE)) {
-		IWL_DEBUG_INFO("Init ucode found. Loading init ucode...\n");
+		IWL_DEBUG_INFO(priv, "Init ucode found. Loading init ucode...\n");
 		ret = iwl5000_load_given_ucode(priv,
 			&priv->ucode_init, &priv->ucode_init_data);
 		if (!ret) {
-			IWL_DEBUG_INFO("Init ucode load complete.\n");
+			IWL_DEBUG_INFO(priv, "Init ucode load complete.\n");
 			priv->ucode_type = UCODE_INIT;
 		}
 	} else {
-		IWL_DEBUG_INFO("Init ucode not found, or already loaded. "
+		IWL_DEBUG_INFO(priv, "Init ucode not found, or already loaded. "
 			"Loading runtime ucode...\n");
 		ret = iwl5000_load_given_ucode(priv,
 			&priv->ucode_code, &priv->ucode_data);
 		if (!ret) {
-			IWL_DEBUG_INFO("Runtime ucode load complete.\n");
+			IWL_DEBUG_INFO(priv, "Runtime ucode load complete.\n");
 			priv->ucode_type = UCODE_RT;
 		}
 	}
@@ -660,7 +660,7 @@ static void iwl5000_init_alive_start(struct iwl_priv *priv)
 	if (priv->card_alive_init.is_valid != UCODE_VALID_OK) {
 		/* We had an error bringing up the hardware, so take it
 		 * all the way back down so we can try again */
-		IWL_DEBUG_INFO("Initialize Alive failed.\n");
+		IWL_DEBUG_INFO(priv, "Initialize Alive failed.\n");
 		goto restart;
 	}
 
@@ -670,7 +670,7 @@ static void iwl5000_init_alive_start(struct iwl_priv *priv)
 	if (iwl_verify_ucode(priv)) {
 		/* Runtime instruction load was bad;
 		 * take it all the way back down so we can try again */
-		IWL_DEBUG_INFO("Bad \"initialize\" uCode load.\n");
+		IWL_DEBUG_INFO(priv, "Bad \"initialize\" uCode load.\n");
 		goto restart;
 	}
 
@@ -713,7 +713,7 @@ static void iwl5000_tx_queue_set_status(struct iwl_priv *priv,
 
 	txq->sched_retry = scd_retry;
 
-	IWL_DEBUG_INFO("%s %s Queue %d on AC %d\n",
+	IWL_DEBUG_INFO(priv, "%s %s Queue %d on AC %d\n",
 		       active ? "Activate" : "Deactivate",
 		       scd_retry ? "BA" : "AC", txq_id, tx_fifo_id);
 }
@@ -1151,7 +1151,7 @@ static int iwl5000_tx_status_reply_tx(struct iwl_priv *priv,
 	u16 seq;
 
 	if (agg->wait_for_ba)
-		IWL_DEBUG_TX_REPLY("got tx response w/o block-ack\n");
+		IWL_DEBUG_TX_REPLY(priv, "got tx response w/o block-ack\n");
 
 	agg->frame_count = tx_resp->frame_count;
 	agg->start_idx = start_idx;
@@ -1165,7 +1165,7 @@ static int iwl5000_tx_status_reply_tx(struct iwl_priv *priv,
 		idx = start_idx;
 
 		/* FIXME: code repetition */
-		IWL_DEBUG_TX_REPLY("FrameCnt = %d, StartIdx=%d idx=%d\n",
+		IWL_DEBUG_TX_REPLY(priv, "FrameCnt = %d, StartIdx=%d idx=%d\n",
 				   agg->frame_count, agg->start_idx, idx);
 
 		info = IEEE80211_SKB_CB(priv->txq[txq_id].txb[idx].skb[0]);
@@ -1177,9 +1177,9 @@ static int iwl5000_tx_status_reply_tx(struct iwl_priv *priv,
 
 		/* FIXME: code repetition end */
 
-		IWL_DEBUG_TX_REPLY("1 Frame 0x%x failure :%d\n",
+		IWL_DEBUG_TX_REPLY(priv, "1 Frame 0x%x failure :%d\n",
 				    status & 0xff, tx_resp->failure_frame);
-		IWL_DEBUG_TX_REPLY("Rate Info rate_n_flags=%x\n", rate_n_flags);
+		IWL_DEBUG_TX_REPLY(priv, "Rate Info rate_n_flags=%x\n", rate_n_flags);
 
 		agg->wait_for_ba = 0;
 	} else {
@@ -1199,7 +1199,7 @@ static int iwl5000_tx_status_reply_tx(struct iwl_priv *priv,
 				      AGG_TX_STATE_ABORT_MSK))
 				continue;
 
-			IWL_DEBUG_TX_REPLY("FrameCnt = %d, txq_id=%d idx=%d\n",
+			IWL_DEBUG_TX_REPLY(priv, "FrameCnt = %d, txq_id=%d idx=%d\n",
 					   agg->frame_count, txq_id, idx);
 
 			hdr = iwl_tx_queue_get_hdr(priv, txq_id, idx);
@@ -1214,7 +1214,7 @@ static int iwl5000_tx_status_reply_tx(struct iwl_priv *priv,
 				return -1;
 			}
 
-			IWL_DEBUG_TX_REPLY("AGG Frame i=%d idx %d seq=%d\n",
+			IWL_DEBUG_TX_REPLY(priv, "AGG Frame i=%d idx %d seq=%d\n",
 					   i, idx, SEQ_TO_SN(sc));
 
 			sh = idx - start;
@@ -1232,13 +1232,13 @@ static int iwl5000_tx_status_reply_tx(struct iwl_priv *priv,
 				sh = 0;
 			}
 			bitmap |= 1ULL << sh;
-			IWL_DEBUG_TX_REPLY("start=%d bitmap=0x%llx\n",
+			IWL_DEBUG_TX_REPLY(priv, "start=%d bitmap=0x%llx\n",
 					   start, (unsigned long long)bitmap);
 		}
 
 		agg->bitmap = bitmap;
 		agg->start_idx = start;
-		IWL_DEBUG_TX_REPLY("Frames %d start_idx=%d bitmap=0x%llx\n",
+		IWL_DEBUG_TX_REPLY(priv, "Frames %d start_idx=%d bitmap=0x%llx\n",
 				   agg->frame_count, agg->start_idx,
 				   (unsigned long long)agg->bitmap);
 
@@ -1291,7 +1291,7 @@ static void iwl5000_rx_reply_tx(struct iwl_priv *priv,
 
 		if (txq->q.read_ptr != (scd_ssn & 0xff)) {
 			index = iwl_queue_dec_wrap(scd_ssn & 0xff, txq->q.n_bd);
-			IWL_DEBUG_TX_REPLY("Retry scheduler reclaim "
+			IWL_DEBUG_TX_REPLY(priv, "Retry scheduler reclaim "
 					"scd_ssn=%d idx=%d txq=%d swq=%d\n",
 					scd_ssn , index, txq_id, txq->swq_id);
 
@@ -1318,7 +1318,7 @@ static void iwl5000_rx_reply_tx(struct iwl_priv *priv,
 					le32_to_cpu(tx_resp->rate_n_flags),
 					info);
 
-		IWL_DEBUG_TX_REPLY("TXQ %d status %s (0x%08x) rate_n_flags "
+		IWL_DEBUG_TX_REPLY(priv, "TXQ %d status %s (0x%08x) rate_n_flags "
 				   "0x%x retries %d\n",
 				   txq_id,
 				   iwl_get_tx_fail_reason(status), status,
@@ -1389,7 +1389,7 @@ static int iwl5000_send_rxon_assoc(struct iwl_priv *priv)
 	    (rxon1->acquisition_data == rxon2->acquisition_data) &&
 	    (rxon1->rx_chain == rxon2->rx_chain) &&
 	    (rxon1->ofdm_basic_rates == rxon2->ofdm_basic_rates)) {
-		IWL_DEBUG_INFO("Using current RXON_ASSOC.  Not resending.\n");
+		IWL_DEBUG_INFO(priv, "Using current RXON_ASSOC.  Not resending.\n");
 		return 0;
 	}
 
@@ -1465,7 +1465,7 @@ static int iwl5000_calc_rssi(struct iwl_priv *priv,
 	max_rssi = max_t(u32, rssi_a, rssi_b);
 	max_rssi = max_t(u32, max_rssi, rssi_c);
 
-	IWL_DEBUG_STATS("Rssi In A %d B %d C %d Max %d AGC dB %d\n",
+	IWL_DEBUG_STATS(priv, "Rssi In A %d B %d C %d Max %d AGC dB %d\n",
 		rssi_a, rssi_b, rssi_c, max_rssi, agc);
 
 	/* dBm = max_rssi dB - agc dB - constant.
diff --git a/drivers/net/wireless/iwlwifi/iwl-agn-rs.c b/drivers/net/wireless/iwlwifi/iwl-agn-rs.c
index 13039a0..04b42c8 100644
--- a/drivers/net/wireless/iwlwifi/iwl-agn-rs.c
+++ b/drivers/net/wireless/iwlwifi/iwl-agn-rs.c
@@ -360,7 +360,7 @@ static void rs_tl_turn_on_agg_for_tid(struct iwl_priv *priv,
 				      struct ieee80211_sta *sta)
 {
 	if (rs_tl_get_load(lq_data, tid) > IWL_AGG_LOAD_THRESHOLD) {
-		IWL_DEBUG_HT("Starting Tx agg: STA: %pM tid: %d\n",
+		IWL_DEBUG_HT(priv, "Starting Tx agg: STA: %pM tid: %d\n",
 				sta->addr, tid);
 		ieee80211_start_tx_ba_session(priv->hw, sta->addr, tid);
 	}
@@ -693,7 +693,7 @@ static u16 rs_get_adjacent_rate(struct iwl_priv *priv, u8 index, u16 rate_mask,
 			break;
 		if (rate_mask & (1 << low))
 			break;
-		IWL_DEBUG_RATE("Skipping masked lower rate: %d\n", low);
+		IWL_DEBUG_RATE(priv, "Skipping masked lower rate: %d\n", low);
 	}
 
 	high = index;
@@ -703,7 +703,7 @@ static u16 rs_get_adjacent_rate(struct iwl_priv *priv, u8 index, u16 rate_mask,
 			break;
 		if (rate_mask & (1 << high))
 			break;
-		IWL_DEBUG_RATE("Skipping masked higher rate: %d\n", high);
+		IWL_DEBUG_RATE(priv, "Skipping masked higher rate: %d\n", high);
 	}
 
 	return (high << 8) | low;
@@ -790,7 +790,7 @@ static void rs_tx_status(void *priv_r, struct ieee80211_supported_band *sband,
 	u8 active_index = 0;
 	s32 tpt = 0;
 
-	IWL_DEBUG_RATE_LIMIT("get frame ack response, update rate scale window\n");
+	IWL_DEBUG_RATE_LIMIT(priv, "get frame ack response, update rate scale window\n");
 
 	if (!ieee80211_is_data(hdr->frame_control) ||
 	    is_multicast_ether_addr(hdr->addr1))
@@ -840,7 +840,7 @@ static void rs_tx_status(void *priv_r, struct ieee80211_supported_band *sband,
 	    (!!(tx_rate & RATE_MCS_GF_MSK) != !!(info->status.rates[0].flags & IEEE80211_TX_RC_GREEN_FIELD)) ||
 	    (hw->wiphy->bands[priv->band]->bitrates[rs_index].bitrate !=
 	     hw->wiphy->bands[info->band]->bitrates[info->status.rates[0].idx].bitrate)) {
-		IWL_DEBUG_RATE("initial rate does not match 0x%x\n", tx_rate);
+		IWL_DEBUG_RATE(priv, "initial rate does not match 0x%x\n", tx_rate);
 		/* the last LQ command could failed so the LQ in ucode not
 		 * the same in driver sync up
 		 */
@@ -971,7 +971,7 @@ out:
 static void rs_set_stay_in_table(struct iwl_priv *priv, u8 is_legacy,
 				 struct iwl_lq_sta *lq_sta)
 {
-	IWL_DEBUG_RATE("we are staying in the same table\n");
+	IWL_DEBUG_RATE(priv, "we are staying in the same table\n");
 	lq_sta->stay_in_tbl = 1;	/* only place this gets set */
 	if (is_legacy) {
 		lq_sta->table_count_limit = IWL_LEGACY_TABLE_COUNT;
@@ -1150,7 +1150,7 @@ static int rs_switch_to_mimo2(struct iwl_priv *priv,
 	if (priv->hw_params.tx_chains_num < 2)
 		return -1;
 
-	IWL_DEBUG_RATE("LQ: try to switch to MIMO2\n");
+	IWL_DEBUG_RATE(priv, "LQ: try to switch to MIMO2\n");
 
 	tbl->lq_type = LQ_MIMO2;
 	tbl->is_dup = lq_sta->is_dup;
@@ -1179,16 +1179,16 @@ static int rs_switch_to_mimo2(struct iwl_priv *priv,
 
 	rate = rs_get_best_rate(priv, lq_sta, tbl, rate_mask, index);
 
-	IWL_DEBUG_RATE("LQ: MIMO2 best rate %d mask %X\n", rate, rate_mask);
+	IWL_DEBUG_RATE(priv, "LQ: MIMO2 best rate %d mask %X\n", rate, rate_mask);
 
 	if ((rate == IWL_RATE_INVALID) || !((1 << rate) & rate_mask)) {
-		IWL_DEBUG_RATE("Can't switch with index %d rate mask %x\n",
+		IWL_DEBUG_RATE(priv, "Can't switch with index %d rate mask %x\n",
 						rate, rate_mask);
 		return -1;
 	}
 	tbl->current_rate = rate_n_flags_from_tbl(priv, tbl, rate, is_green);
 
-	IWL_DEBUG_RATE("LQ: Switch to new mcs %X index is green %X\n",
+	IWL_DEBUG_RATE(priv, "LQ: Switch to new mcs %X index is green %X\n",
 		     tbl->current_rate, is_green);
 	return 0;
 }
@@ -1209,7 +1209,7 @@ static int rs_switch_to_siso(struct iwl_priv *priv,
 	if (!conf_is_ht(conf) || !sta->ht_cap.ht_supported)
 		return -1;
 
-	IWL_DEBUG_RATE("LQ: try to switch to SISO\n");
+	IWL_DEBUG_RATE(priv, "LQ: try to switch to SISO\n");
 
 	tbl->is_dup = lq_sta->is_dup;
 	tbl->lq_type = LQ_SISO;
@@ -1240,14 +1240,14 @@ static int rs_switch_to_siso(struct iwl_priv *priv,
 	rs_set_expected_tpt_table(lq_sta, tbl);
 	rate = rs_get_best_rate(priv, lq_sta, tbl, rate_mask, index);
 
-	IWL_DEBUG_RATE("LQ: get best rate %d mask %X\n", rate, rate_mask);
+	IWL_DEBUG_RATE(priv, "LQ: get best rate %d mask %X\n", rate, rate_mask);
 	if ((rate == IWL_RATE_INVALID) || !((1 << rate) & rate_mask)) {
-		IWL_DEBUG_RATE("can not switch with index %d rate mask %x\n",
+		IWL_DEBUG_RATE(priv, "can not switch with index %d rate mask %x\n",
 			     rate, rate_mask);
 		return -1;
 	}
 	tbl->current_rate = rate_n_flags_from_tbl(priv, tbl, rate, is_green);
-	IWL_DEBUG_RATE("LQ: Switch to new mcs %X index is green %X\n",
+	IWL_DEBUG_RATE(priv, "LQ: Switch to new mcs %X index is green %X\n",
 		     tbl->current_rate, is_green);
 	return 0;
 }
@@ -1276,7 +1276,7 @@ static int rs_move_legacy_other(struct iwl_priv *priv,
 		switch (tbl->action) {
 		case IWL_LEGACY_SWITCH_ANTENNA1:
 		case IWL_LEGACY_SWITCH_ANTENNA2:
-			IWL_DEBUG_RATE("LQ: Legacy toggle Antenna\n");
+			IWL_DEBUG_RATE(priv, "LQ: Legacy toggle Antenna\n");
 
 			lq_sta->action_counter++;
 
@@ -1300,7 +1300,7 @@ static int rs_move_legacy_other(struct iwl_priv *priv,
 			}
 			break;
 		case IWL_LEGACY_SWITCH_SISO:
-			IWL_DEBUG_RATE("LQ: Legacy switch to SISO\n");
+			IWL_DEBUG_RATE(priv, "LQ: Legacy switch to SISO\n");
 
 			/* Set up search table to try SISO */
 			memcpy(search_tbl, tbl, sz);
@@ -1316,7 +1316,7 @@ static int rs_move_legacy_other(struct iwl_priv *priv,
 		case IWL_LEGACY_SWITCH_MIMO2_AB:
 		case IWL_LEGACY_SWITCH_MIMO2_AC:
 		case IWL_LEGACY_SWITCH_MIMO2_BC:
-			IWL_DEBUG_RATE("LQ: Legacy switch to MIMO2\n");
+			IWL_DEBUG_RATE(priv, "LQ: Legacy switch to MIMO2\n");
 
 			/* Set up search table to try MIMO */
 			memcpy(search_tbl, tbl, sz);
@@ -1385,7 +1385,7 @@ static int rs_move_siso_to_other(struct iwl_priv *priv,
 		switch (tbl->action) {
 		case IWL_SISO_SWITCH_ANTENNA1:
 		case IWL_SISO_SWITCH_ANTENNA2:
-			IWL_DEBUG_RATE("LQ: SISO toggle Antenna\n");
+			IWL_DEBUG_RATE(priv, "LQ: SISO toggle Antenna\n");
 
 			if ((tbl->action == IWL_SISO_SWITCH_ANTENNA1 &&
 							tx_chains_num <= 1) ||
@@ -1404,7 +1404,7 @@ static int rs_move_siso_to_other(struct iwl_priv *priv,
 		case IWL_SISO_SWITCH_MIMO2_AB:
 		case IWL_SISO_SWITCH_MIMO2_AC:
 		case IWL_SISO_SWITCH_MIMO2_BC:
-			IWL_DEBUG_RATE("LQ: SISO switch to MIMO2\n");
+			IWL_DEBUG_RATE(priv, "LQ: SISO switch to MIMO2\n");
 			memcpy(search_tbl, tbl, sz);
 			search_tbl->is_SGI = 0;
 
@@ -1433,7 +1433,7 @@ static int rs_move_siso_to_other(struct iwl_priv *priv,
 						HT_SHORT_GI_40MHZ))
 				break;
 
-			IWL_DEBUG_RATE("LQ: SISO toggle SGI/NGI\n");
+			IWL_DEBUG_RATE(priv, "LQ: SISO toggle SGI/NGI\n");
 
 			memcpy(search_tbl, tbl, sz);
 			if (is_green) {
@@ -1498,7 +1498,7 @@ static int rs_move_mimo_to_other(struct iwl_priv *priv,
 		switch (tbl->action) {
 		case IWL_MIMO2_SWITCH_ANTENNA1:
 		case IWL_MIMO2_SWITCH_ANTENNA2:
-			IWL_DEBUG_RATE("LQ: MIMO toggle Antennas\n");
+			IWL_DEBUG_RATE(priv, "LQ: MIMO toggle Antennas\n");
 
 			if (tx_chains_num <= 2)
 				break;
@@ -1514,7 +1514,7 @@ static int rs_move_mimo_to_other(struct iwl_priv *priv,
 		case IWL_MIMO2_SWITCH_SISO_A:
 		case IWL_MIMO2_SWITCH_SISO_B:
 		case IWL_MIMO2_SWITCH_SISO_C:
-			IWL_DEBUG_RATE("LQ: MIMO2 switch to SISO\n");
+			IWL_DEBUG_RATE(priv, "LQ: MIMO2 switch to SISO\n");
 
 			/* Set up new search table for SISO */
 			memcpy(search_tbl, tbl, sz);
@@ -1546,7 +1546,7 @@ static int rs_move_mimo_to_other(struct iwl_priv *priv,
 						HT_SHORT_GI_40MHZ))
 				break;
 
-			IWL_DEBUG_RATE("LQ: MIMO toggle SGI/NGI\n");
+			IWL_DEBUG_RATE(priv, "LQ: MIMO toggle SGI/NGI\n");
 
 			/* Set up new search table for MIMO */
 			memcpy(search_tbl, tbl, sz);
@@ -1629,7 +1629,7 @@ static void rs_stay_in_table(struct iwl_lq_sta *lq_sta)
 		    (lq_sta->total_success > lq_sta->max_success_limit) ||
 		    ((!lq_sta->search_better_tbl) && (lq_sta->flush_timer)
 		     && (flush_interval_passed))) {
-			IWL_DEBUG_RATE("LQ: stay is expired %d %d %d\n:",
+			IWL_DEBUG_RATE(priv, "LQ: stay is expired %d %d %d\n:",
 				     lq_sta->total_failed,
 				     lq_sta->total_success,
 				     flush_interval_passed);
@@ -1652,7 +1652,7 @@ static void rs_stay_in_table(struct iwl_lq_sta *lq_sta)
 			    lq_sta->table_count_limit) {
 				lq_sta->table_count = 0;
 
-				IWL_DEBUG_RATE("LQ: stay in table clear win\n");
+				IWL_DEBUG_RATE(priv, "LQ: stay in table clear win\n");
 				for (i = 0; i < IWL_RATE_COUNT; i++)
 					rs_rate_scale_clear_window(
 						&(tbl->win[i]));
@@ -1701,7 +1701,7 @@ static void rs_rate_scale_perform(struct iwl_priv *priv,
 	s32 sr;
 	u8 tid = MAX_TID_COUNT;
 
-	IWL_DEBUG_RATE("rate scale calculate new rate for skb\n");
+	IWL_DEBUG_RATE(priv, "rate scale calculate new rate for skb\n");
 
 	/* Send management frames and broadcast/multicast data using
 	 * lowest rate. */
@@ -1733,13 +1733,13 @@ static void rs_rate_scale_perform(struct iwl_priv *priv,
 	/* current tx rate */
 	index = lq_sta->last_txrate_idx;
 
-	IWL_DEBUG_RATE("Rate scale index %d for type %d\n", index,
+	IWL_DEBUG_RATE(priv, "Rate scale index %d for type %d\n", index,
 		       tbl->lq_type);
 
 	/* rates available for this association, and for modulation mode */
 	rate_mask = rs_get_supported_rates(lq_sta, hdr, tbl->lq_type);
 
-	IWL_DEBUG_RATE("mask 0x%04X \n", rate_mask);
+	IWL_DEBUG_RATE(priv, "mask 0x%04X \n", rate_mask);
 
 	/* mask with station rate restriction */
 	if (is_legacy(tbl->lq_type)) {
@@ -1789,7 +1789,7 @@ static void rs_rate_scale_perform(struct iwl_priv *priv,
 	fail_count = window->counter - window->success_counter;
 	if ((fail_count < IWL_RATE_MIN_FAILURE_TH) &&
 			(window->success_counter < IWL_RATE_MIN_SUCCESS_TH)) {
-		IWL_DEBUG_RATE("LQ: still below TH. succ=%d total=%d "
+		IWL_DEBUG_RATE(priv, "LQ: still below TH. succ=%d total=%d "
 			       "for index %d\n",
 			       window->success_counter, window->counter, index);
 
@@ -1817,7 +1817,7 @@ static void rs_rate_scale_perform(struct iwl_priv *priv,
 		 * continuing to use the setup that we've been trying. */
 		if (window->average_tpt > lq_sta->last_tpt) {
 
-			IWL_DEBUG_RATE("LQ: SWITCHING TO NEW TABLE "
+			IWL_DEBUG_RATE(priv, "LQ: SWITCHING TO NEW TABLE "
 					"suc=%d cur-tpt=%d old-tpt=%d\n",
 					window->success_ratio,
 					window->average_tpt,
@@ -1833,7 +1833,7 @@ static void rs_rate_scale_perform(struct iwl_priv *priv,
 		/* Else poor success; go back to mode in "active" table */
 		} else {
 
-			IWL_DEBUG_RATE("LQ: GOING BACK TO THE OLD TABLE "
+			IWL_DEBUG_RATE(priv, "LQ: GOING BACK TO THE OLD TABLE "
 					"suc=%d cur-tpt=%d old-tpt=%d\n",
 					window->success_ratio,
 					window->average_tpt,
@@ -1886,7 +1886,7 @@ static void rs_rate_scale_perform(struct iwl_priv *priv,
 
 	/* Too many failures, decrease rate */
 	if ((sr <= IWL_RATE_DECREASE_TH) || (current_tpt == 0)) {
-		IWL_DEBUG_RATE("decrease rate because of low success_ratio\n");
+		IWL_DEBUG_RATE(priv, "decrease rate because of low success_ratio\n");
 		scale_action = -1;
 
 	/* No throughput measured yet for adjacent rates; try increase. */
@@ -1917,8 +1917,8 @@ static void rs_rate_scale_perform(struct iwl_priv *priv,
 					sr >= IWL_RATE_INCREASE_TH) {
 				scale_action = 1;
 			} else {
-				IWL_DEBUG_RATE
-				    ("decrease rate because of high tpt\n");
+				IWL_DEBUG_RATE(priv,
+				    "decrease rate because of high tpt\n");
 				scale_action = -1;
 			}
 
@@ -1926,8 +1926,8 @@ static void rs_rate_scale_perform(struct iwl_priv *priv,
 		} else if (low_tpt != IWL_INVALID_VALUE) {
 			/* Lower rate has better throughput */
 			if (low_tpt > current_tpt) {
-				IWL_DEBUG_RATE
-				    ("decrease rate because of low tpt\n");
+				IWL_DEBUG_RATE(priv,
+				    "decrease rate because of low tpt\n");
 				scale_action = -1;
 			} else if (sr >= IWL_RATE_INCREASE_TH) {
 				scale_action = 1;
@@ -1964,7 +1964,7 @@ static void rs_rate_scale_perform(struct iwl_priv *priv,
 		break;
 	}
 
-	IWL_DEBUG_RATE("choose rate scale index %d action %d low %d "
+	IWL_DEBUG_RATE(priv, "choose rate scale index %d action %d low %d "
 		    "high %d type %d\n",
 		     index, scale_action, low, high, tbl->lq_type);
 
@@ -2008,7 +2008,7 @@ lq_update:
 			/* Use new "search" start rate */
 			index = iwl_hwrate_to_plcp_idx(tbl->current_rate);
 
-			IWL_DEBUG_RATE("Switch current  mcs: %X index: %d\n",
+			IWL_DEBUG_RATE(priv, "Switch current  mcs: %X index: %d\n",
 				     tbl->current_rate, index);
 			rs_fill_link_cmd(priv, lq_sta, tbl->current_rate);
 			iwl_send_lq_cmd(priv, &lq_sta->lq, CMD_ASYNC);
@@ -2023,7 +2023,7 @@ lq_update:
 		if (is_legacy(tbl1->lq_type) && !conf_is_ht(conf) &&
 		    lq_sta->action_counter >= 1) {
 			lq_sta->action_counter = 0;
-			IWL_DEBUG_RATE("LQ: STAY in legacy table\n");
+			IWL_DEBUG_RATE(priv, "LQ: STAY in legacy table\n");
 			rs_set_stay_in_table(priv, 1, lq_sta);
 		}
 
@@ -2035,7 +2035,7 @@ lq_update:
 			if ((lq_sta->last_tpt > IWL_AGG_TPT_THREHOLD) &&
 			    (lq_sta->tx_agg_tid_en & (1 << tid)) &&
 			    (tid != MAX_TID_COUNT)) {
-				IWL_DEBUG_RATE("try to aggregate tid %d\n", tid);
+				IWL_DEBUG_RATE(priv, "try to aggregate tid %d\n", tid);
 				rs_tl_turn_on_agg(priv, tid, lq_sta, sta);
 			}
 			lq_sta->action_counter = 0;
@@ -2131,7 +2131,7 @@ static void rs_get_rate(void *priv_r, struct ieee80211_sta *sta, void *priv_sta,
 	int rate_idx;
 	u64 mask_bit = 0;
 
-	IWL_DEBUG_RATE_LIMIT("rate scale calculate new rate for skb\n");
+	IWL_DEBUG_RATE_LIMIT(priv, "rate scale calculate new rate for skb\n");
 
 	/* Get max rate if user set max rate */
 	if (lq_sta) {
@@ -2167,7 +2167,7 @@ static void rs_get_rate(void *priv_r, struct ieee80211_sta *sta, void *priv_sta,
 		u8 sta_id = iwl_find_station(priv, hdr->addr1);
 
 		if (sta_id == IWL_INVALID_STATION) {
-			IWL_DEBUG_RATE("LQ: ADD station %pM\n",
+			IWL_DEBUG_RATE(priv, "LQ: ADD station %pM\n",
 				       hdr->addr1);
 			sta_id = iwl_add_station_flags(priv, hdr->addr1,
 							0, CMD_ASYNC, NULL);
@@ -2196,7 +2196,7 @@ static void *rs_alloc_sta(void *priv_rate, struct ieee80211_sta *sta,
 	int i, j;
 
 	priv = (struct iwl_priv *)priv_rate;
-	IWL_DEBUG_RATE("create station rate scale window\n");
+	IWL_DEBUG_RATE(priv, "create station rate scale window\n");
 
 	lq_sta = kzalloc(sizeof(struct iwl_lq_sta), gfp);
 
@@ -2229,7 +2229,7 @@ static void rs_rate_init(void *priv_r, struct ieee80211_supported_band *sband,
 		for (i = 0; i < IWL_RATE_COUNT; i++)
 			rs_rate_scale_clear_window(&lq_sta->lq_info[j].win[i]);
 
-	IWL_DEBUG_RATE("LQ: *** rate scale station global init ***\n");
+	IWL_DEBUG_RATE(priv, "LQ: *** rate scale station global init ***\n");
 	/* TODO: what is a good starting rate for STA? About middle? Maybe not
 	 * the lowest or the highest rate.. Could consider using RSSI from
 	 * previous packets? Need to have IEEE 802.1X auth succeed immediately
@@ -2240,10 +2240,10 @@ static void rs_rate_init(void *priv_r, struct ieee80211_supported_band *sband,
 		u8 sta_id = iwl_find_station(priv, sta->addr);
 
 		/* for IBSS the call are from tasklet */
-		IWL_DEBUG_RATE("LQ: ADD station %pM\n", sta->addr);
+		IWL_DEBUG_RATE(priv, "LQ: ADD station %pM\n", sta->addr);
 
 		if (sta_id == IWL_INVALID_STATION) {
-			IWL_DEBUG_RATE("LQ: ADD station %pM\n", sta->addr);
+			IWL_DEBUG_RATE(priv, "LQ: ADD station %pM\n", sta->addr);
 			sta_id = iwl_add_station_flags(priv, sta->addr,
 							0, CMD_ASYNC, NULL);
 		}
@@ -2282,7 +2282,7 @@ static void rs_rate_init(void *priv_r, struct ieee80211_supported_band *sband,
 	lq_sta->active_mimo3_rate &= ~((u16)0x2);
 	lq_sta->active_mimo3_rate <<= IWL_FIRST_OFDM_RATE;
 
-	IWL_DEBUG_RATE("SISO-RATE=%X MIMO2-RATE=%X MIMO3-RATE=%X\n",
+	IWL_DEBUG_RATE(priv, "SISO-RATE=%X MIMO2-RATE=%X MIMO3-RATE=%X\n",
 		     lq_sta->active_siso_rate,
 		     lq_sta->active_mimo2_rate,
 		     lq_sta->active_mimo3_rate);
@@ -2448,9 +2448,9 @@ static void rs_free_sta(void *priv_r, struct ieee80211_sta *sta,
 	struct iwl_lq_sta *lq_sta = priv_sta;
 	struct iwl_priv *priv __maybe_unused = priv_r;
 
-	IWL_DEBUG_RATE("enter\n");
+	IWL_DEBUG_RATE(priv, "enter\n");
 	kfree(lq_sta);
-	IWL_DEBUG_RATE("leave\n");
+	IWL_DEBUG_RATE(priv, "leave\n");
 }
 
 
@@ -2475,9 +2475,9 @@ static void rs_dbgfs_set_mcs(struct iwl_lq_sta *lq_sta,
 			else
 				*rate_n_flags = 0x820A;
 		}
-		IWL_DEBUG_RATE("Fixed rate ON\n");
+		IWL_DEBUG_RATE(priv, "Fixed rate ON\n");
 	} else {
-		IWL_DEBUG_RATE("Fixed rate OFF\n");
+		IWL_DEBUG_RATE(priv, "Fixed rate OFF\n");
 	}
 }
 
@@ -2506,7 +2506,7 @@ static ssize_t rs_sta_dbgfs_scale_table_write(struct file *file,
 	lq_sta->active_mimo2_rate  = 0x1FD0;	/* 6 - 60 MBits, no 9, no CCK */
 	lq_sta->active_mimo3_rate  = 0x1FD0;	/* 6 - 60 MBits, no 9, no CCK */
 
-	IWL_DEBUG_RATE("sta_id %d rate 0x%X\n",
+	IWL_DEBUG_RATE(priv, "sta_id %d rate 0x%X\n",
 		lq_sta->lq.sta_id, lq_sta->dbg_fixed_rate);
 
 	if (lq_sta->dbg_fixed_rate) {
diff --git a/drivers/net/wireless/iwlwifi/iwl-agn.c b/drivers/net/wireless/iwlwifi/iwl-agn.c
index eab238e..5540f3b 100644
--- a/drivers/net/wireless/iwlwifi/iwl-agn.c
+++ b/drivers/net/wireless/iwlwifi/iwl-agn.c
@@ -147,7 +147,7 @@ static int iwl_commit_rxon(struct iwl_priv *priv)
 	 * we must clear the associated from the active configuration
 	 * before we apply the new config */
 	if (iwl_is_associated(priv) && new_assoc) {
-		IWL_DEBUG_INFO("Toggling associated bit on current RXON\n");
+		IWL_DEBUG_INFO(priv, "Toggling associated bit on current RXON\n");
 		active_rxon->filter_flags &= ~RXON_FILTER_ASSOC_MSK;
 
 		ret = iwl_send_cmd_pdu(priv, REPLY_RXON,
@@ -163,7 +163,7 @@ static int iwl_commit_rxon(struct iwl_priv *priv)
 		}
 	}
 
-	IWL_DEBUG_INFO("Sending RXON\n"
+	IWL_DEBUG_INFO(priv, "Sending RXON\n"
 		       "* with%s RXON_FILTER_ASSOC_MSK\n"
 		       "* channel = %d\n"
 		       "* bssid = %pM\n",
@@ -254,7 +254,7 @@ static void iwl_clear_free_frames(struct iwl_priv *priv)
 {
 	struct list_head *element;
 
-	IWL_DEBUG_INFO("%d frames on pre-allocated heap on clear.\n",
+	IWL_DEBUG_INFO(priv, "%d frames on pre-allocated heap on clear.\n",
 		       priv->frames_count);
 
 	while (!list_empty(&priv->free_frames)) {
@@ -538,7 +538,7 @@ static void iwl_ht_conf(struct iwl_priv *priv,
 	struct iwl_ht_info *iwl_conf = &priv->current_ht_config;
 	struct ieee80211_sta *sta;
 
-	IWL_DEBUG_MAC80211("enter: \n");
+	IWL_DEBUG_MAC80211(priv, "enter: \n");
 
 	if (!iwl_conf->is_ht)
 		return;
@@ -598,7 +598,7 @@ static void iwl_ht_conf(struct iwl_priv *priv,
 
 	rcu_read_unlock();
 
-	IWL_DEBUG_MAC80211("leave\n");
+	IWL_DEBUG_MAC80211(priv, "leave\n");
 }
 
 /*
@@ -623,7 +623,7 @@ static void iwl_activate_qos(struct iwl_priv *priv, u8 force)
 		priv->qos_data.def_qos_parm.qos_flags |= QOS_PARAM_FLG_TGN_MSK;
 
 	if (force || iwl_is_associated(priv)) {
-		IWL_DEBUG_QOS("send QoS cmd with Qos active=%d FLAGS=0x%X\n",
+		IWL_DEBUG_QOS(priv, "send QoS cmd with Qos active=%d FLAGS=0x%X\n",
 				priv->qos_data.qos_active,
 				priv->qos_data.def_qos_parm.qos_flags);
 
@@ -680,7 +680,7 @@ static void iwl_setup_rxon_timing(struct iwl_priv *priv)
 	priv->rxon_timing.beacon_init_val = cpu_to_le32(interval_tm - rem);
 
 	spin_unlock_irqrestore(&priv->lock, flags);
-	IWL_DEBUG_ASSOC("beacon interval %d beacon timer %d beacon tim %d\n",
+	IWL_DEBUG_ASSOC(priv, "beacon interval %d beacon timer %d beacon tim %d\n",
 			le16_to_cpu(priv->rxon_timing.beacon_interval),
 			le32_to_cpu(priv->rxon_timing.beacon_init_val),
 			le16_to_cpu(priv->rxon_timing.atim_window));
@@ -701,7 +701,7 @@ static int iwl_set_mode(struct iwl_priv *priv, int mode)
 	cancel_delayed_work(&priv->scan_check);
 	if (iwl_scan_cancel_timeout(priv, 100)) {
 		IWL_WARN(priv, "Aborted scan still in progress after 100ms\n");
-		IWL_DEBUG_MAC80211("leaving - scan abort failed.\n");
+		IWL_DEBUG_MAC80211(priv, "leaving - scan abort failed.\n");
 		return -EAGAIN;
 	}
 
@@ -724,19 +724,19 @@ static void iwl_rx_reply_alive(struct iwl_priv *priv,
 
 	palive = &pkt->u.alive_frame;
 
-	IWL_DEBUG_INFO("Alive ucode status 0x%08X revision "
+	IWL_DEBUG_INFO(priv, "Alive ucode status 0x%08X revision "
 		       "0x%01X 0x%01X\n",
 		       palive->is_valid, palive->ver_type,
 		       palive->ver_subtype);
 
 	if (palive->ver_subtype == INITIALIZE_SUBTYPE) {
-		IWL_DEBUG_INFO("Initialization Alive received.\n");
+		IWL_DEBUG_INFO(priv, "Initialization Alive received.\n");
 		memcpy(&priv->card_alive_init,
 		       &pkt->u.alive_frame,
 		       sizeof(struct iwl_init_alive_resp));
 		pwork = &priv->init_alive_start;
 	} else {
-		IWL_DEBUG_INFO("Runtime Alive received.\n");
+		IWL_DEBUG_INFO(priv, "Runtime Alive received.\n");
 		memcpy(&priv->card_alive, &pkt->u.alive_frame,
 		       sizeof(struct iwl_alive_resp));
 		pwork = &priv->alive_start;
@@ -771,7 +771,7 @@ static void iwl_rx_pm_sleep_notif(struct iwl_priv *priv,
 #ifdef CONFIG_IWLWIFI_DEBUG
 	struct iwl_rx_packet *pkt = (struct iwl_rx_packet *)rxb->skb->data;
 	struct iwl_sleep_notification *sleep = &(pkt->u.sleep_notif);
-	IWL_DEBUG_RX("sleep mode: %d, src: %d\n",
+	IWL_DEBUG_RX(priv, "sleep mode: %d, src: %d\n",
 		     sleep->pm_sleep_mode, sleep->pm_wakeup_src);
 #endif
 }
@@ -780,7 +780,7 @@ static void iwl_rx_pm_debug_statistics_notif(struct iwl_priv *priv,
 					     struct iwl_rx_mem_buffer *rxb)
 {
 	struct iwl_rx_packet *pkt = (struct iwl_rx_packet *)rxb->skb->data;
-	IWL_DEBUG_RADIO("Dumping %d bytes of unhandled "
+	IWL_DEBUG_RADIO(priv, "Dumping %d bytes of unhandled "
 			"notification for %s:\n",
 			le32_to_cpu(pkt->len), get_cmd_string(pkt->hdr.cmd));
 	iwl_print_hex_dump(priv, IWL_DL_RADIO, pkt->u.raw, le32_to_cpu(pkt->len));
@@ -844,7 +844,7 @@ static void iwl_rx_beacon_notif(struct iwl_priv *priv,
 		(struct iwl4965_beacon_notif *)pkt->u.raw;
 	u8 rate = iwl_hw_get_rate(beacon->beacon_notify_hdr.rate_n_flags);
 
-	IWL_DEBUG_RX("beacon status %x retries %d iss %d "
+	IWL_DEBUG_RX(priv, "beacon status %x retries %d iss %d "
 		"tsf %d %d rate %d\n",
 		le32_to_cpu(beacon->beacon_notify_hdr.u.status) & TX_STATUS_MSK,
 		beacon->beacon_notify_hdr.failure_frame,
@@ -867,7 +867,7 @@ static void iwl_rx_card_state_notif(struct iwl_priv *priv,
 	u32 flags = le32_to_cpu(pkt->u.card_state_notif.flags);
 	unsigned long status = priv->status;
 
-	IWL_DEBUG_RF_KILL("Card state received: HW:%s SW:%s\n",
+	IWL_DEBUG_RF_KILL(priv, "Card state received: HW:%s SW:%s\n",
 			  (flags & HW_CARD_DISABLED) ? "Kill" : "On",
 			  (flags & SW_CARD_DISABLED) ? "Kill" : "On");
 
@@ -1029,7 +1029,7 @@ void iwl_rx_handle(struct iwl_priv *priv)
 
 	/* Rx interrupt, but nothing sent from uCode */
 	if (i == r)
-		IWL_DEBUG(IWL_DL_RX, "r = %d, i = %d\n", r, i);
+		IWL_DEBUG_RX(priv, "r = %d, i = %d\n", r, i);
 
 	if (iwl_rx_queue_space(rxq) > (RX_QUEUE_SIZE / 2))
 		fill_rx = 1;
@@ -1069,12 +1069,12 @@ void iwl_rx_handle(struct iwl_priv *priv)
 		 *   handle those that need handling via function in
 		 *   rx_handlers table.  See iwl_setup_rx_handlers() */
 		if (priv->rx_handlers[pkt->hdr.cmd]) {
-			IWL_DEBUG(IWL_DL_RX, "r = %d, i = %d, %s, 0x%02x\n", r,
+			IWL_DEBUG_RX(priv, "r = %d, i = %d, %s, 0x%02x\n", r,
 				i, get_cmd_string(pkt->hdr.cmd), pkt->hdr.cmd);
 			priv->rx_handlers[pkt->hdr.cmd] (priv, rxb);
 		} else {
 			/* No handling needed */
-			IWL_DEBUG(IWL_DL_RX,
+			IWL_DEBUG_RX(priv,
 				"r %d i %d No handler needed for %s, 0x%02x\n",
 				r, i, get_cmd_string(pkt->hdr.cmd),
 				pkt->hdr.cmd);
@@ -1175,7 +1175,7 @@ static void iwl_irq_tasklet(struct iwl_priv *priv)
 	if (priv->debug_level & IWL_DL_ISR) {
 		/* just for debug */
 		inta_mask = iwl_read32(priv, CSR_INT_MASK);
-		IWL_DEBUG_ISR("inta 0x%08x, enabled 0x%08x, fh 0x%08x\n",
+		IWL_DEBUG_ISR(priv, "inta 0x%08x, enabled 0x%08x, fh 0x%08x\n",
 			      inta, inta_mask, inta_fh);
 	}
 #endif
@@ -1209,12 +1209,12 @@ static void iwl_irq_tasklet(struct iwl_priv *priv)
 	if (priv->debug_level & (IWL_DL_ISR)) {
 		/* NIC fires this, but we don't use it, redundant with WAKEUP */
 		if (inta & CSR_INT_BIT_SCD)
-			IWL_DEBUG_ISR("Scheduler finished to transmit "
+			IWL_DEBUG_ISR(priv, "Scheduler finished to transmit "
 				      "the frame/frames.\n");
 
 		/* Alive notification via Rx interrupt will do the real work */
 		if (inta & CSR_INT_BIT_ALIVE)
-			IWL_DEBUG_ISR("Alive interrupt\n");
+			IWL_DEBUG_ISR(priv, "Alive interrupt\n");
 	}
 #endif
 	/* Safely ignore these bits for debug checks below */
@@ -1227,7 +1227,7 @@ static void iwl_irq_tasklet(struct iwl_priv *priv)
 				CSR_GP_CNTRL_REG_FLAG_HW_RF_KILL_SW))
 			hw_rf_kill = 1;
 
-		IWL_DEBUG(IWL_DL_RF_KILL, "RF_KILL bit toggled to %s.\n",
+		IWL_DEBUG_RF_KILL(priv, "RF_KILL bit toggled to %s.\n",
 				hw_rf_kill ? "disable radio" : "enable radio");
 
 		/* driver only loads ucode once setting the interface up.
@@ -1262,7 +1262,7 @@ static void iwl_irq_tasklet(struct iwl_priv *priv)
 
 	/* uCode wakes up after power-down sleep */
 	if (inta & CSR_INT_BIT_WAKEUP) {
-		IWL_DEBUG_ISR("Wakeup interrupt\n");
+		IWL_DEBUG_ISR(priv, "Wakeup interrupt\n");
 		iwl_rx_queue_update_write_ptr(priv, &priv->rxq);
 		iwl_txq_update_write_ptr(priv, &priv->txq[0]);
 		iwl_txq_update_write_ptr(priv, &priv->txq[1]);
@@ -1283,7 +1283,7 @@ static void iwl_irq_tasklet(struct iwl_priv *priv)
 	}
 
 	if (inta & CSR_INT_BIT_FH_TX) {
-		IWL_DEBUG_ISR("Tx interrupt\n");
+		IWL_DEBUG_ISR(priv, "Tx interrupt\n");
 		handled |= CSR_INT_BIT_FH_TX;
 		/* FH finished to write, send event */
 		priv->ucode_write_complete = 1;
@@ -1309,7 +1309,7 @@ static void iwl_irq_tasklet(struct iwl_priv *priv)
 		inta = iwl_read32(priv, CSR_INT);
 		inta_mask = iwl_read32(priv, CSR_INT_MASK);
 		inta_fh = iwl_read32(priv, CSR_FH_INT_STATUS);
-		IWL_DEBUG_ISR("End inta 0x%08x, enabled 0x%08x, fh 0x%08x, "
+		IWL_DEBUG_ISR(priv, "End inta 0x%08x, enabled 0x%08x, fh 0x%08x, "
 			"flags 0x%08lx\n", inta, inta_mask, inta_fh, flags);
 	}
 #endif
@@ -1341,7 +1341,7 @@ static irqreturn_t iwl_isr(int irq, void *data)
 	 * This may be due to IRQ shared with another device,
 	 * or due to sporadic interrupts thrown from our NIC. */
 	if (!inta && !inta_fh) {
-		IWL_DEBUG_ISR("Ignore interrupt, inta == 0, inta_fh == 0\n");
+		IWL_DEBUG_ISR(priv, "Ignore interrupt, inta == 0, inta_fh == 0\n");
 		goto none;
 	}
 
@@ -1352,7 +1352,7 @@ static irqreturn_t iwl_isr(int irq, void *data)
 		goto unplugged;
 	}
 
-	IWL_DEBUG_ISR("ISR inta 0x%08x, enabled 0x%08x, fh 0x%08x\n",
+	IWL_DEBUG_ISR(priv, "ISR inta 0x%08x, enabled 0x%08x, fh 0x%08x\n",
 		      inta, inta_mask, inta_fh);
 
 	inta &= ~CSR_INT_BIT_SCD;
@@ -1434,7 +1434,7 @@ static int iwl_read_ucode(struct iwl_priv *priv)
 					"Please use API v%u instead.\n",
 					  buf, api_max);
 
-			IWL_DEBUG_INFO("Got firmware '%s' file (%zd bytes) from disk\n",
+			IWL_DEBUG_INFO(priv, "Got firmware '%s' file (%zd bytes) from disk\n",
 				       buf, ucode_raw->size);
 			break;
 		}
@@ -1485,17 +1485,17 @@ static int iwl_read_ucode(struct iwl_priv *priv)
 	       IWL_UCODE_API(priv->ucode_ver),
 	       IWL_UCODE_SERIAL(priv->ucode_ver));
 
-	IWL_DEBUG_INFO("f/w package hdr ucode version raw = 0x%x\n",
+	IWL_DEBUG_INFO(priv, "f/w package hdr ucode version raw = 0x%x\n",
 		       priv->ucode_ver);
-	IWL_DEBUG_INFO("f/w package hdr runtime inst size = %u\n",
+	IWL_DEBUG_INFO(priv, "f/w package hdr runtime inst size = %u\n",
 		       inst_size);
-	IWL_DEBUG_INFO("f/w package hdr runtime data size = %u\n",
+	IWL_DEBUG_INFO(priv, "f/w package hdr runtime data size = %u\n",
 		       data_size);
-	IWL_DEBUG_INFO("f/w package hdr init inst size = %u\n",
+	IWL_DEBUG_INFO(priv, "f/w package hdr init inst size = %u\n",
 		       init_size);
-	IWL_DEBUG_INFO("f/w package hdr init data size = %u\n",
+	IWL_DEBUG_INFO(priv, "f/w package hdr init data size = %u\n",
 		       init_data_size);
-	IWL_DEBUG_INFO("f/w package hdr boot inst size = %u\n",
+	IWL_DEBUG_INFO(priv, "f/w package hdr boot inst size = %u\n",
 		       boot_size);
 
 	/* Verify size of file vs. image size info in file's header */
@@ -1503,7 +1503,7 @@ static int iwl_read_ucode(struct iwl_priv *priv)
 		inst_size + data_size + init_size +
 		init_data_size + boot_size) {
 
-		IWL_DEBUG_INFO("uCode file size %d too small\n",
+		IWL_DEBUG_INFO(priv, "uCode file size %d too small\n",
 			       (int)ucode_raw->size);
 		ret = -EINVAL;
 		goto err_release;
@@ -1511,36 +1511,33 @@ static int iwl_read_ucode(struct iwl_priv *priv)
 
 	/* Verify that uCode images will fit in card's SRAM */
 	if (inst_size > priv->hw_params.max_inst_size) {
-		IWL_DEBUG_INFO("uCode instr len %d too large to fit in\n",
+		IWL_DEBUG_INFO(priv, "uCode instr len %d too large to fit in\n",
 			       inst_size);
 		ret = -EINVAL;
 		goto err_release;
 	}
 
 	if (data_size > priv->hw_params.max_data_size) {
-		IWL_DEBUG_INFO("uCode data len %d too large to fit in\n",
+		IWL_DEBUG_INFO(priv, "uCode data len %d too large to fit in\n",
 				data_size);
 		ret = -EINVAL;
 		goto err_release;
 	}
 	if (init_size > priv->hw_params.max_inst_size) {
-		IWL_DEBUG_INFO
-		    ("uCode init instr len %d too large to fit in\n",
-		      init_size);
+		IWL_INFO(priv, "uCode init instr len %d too large to fit in\n",
+			init_size);
 		ret = -EINVAL;
 		goto err_release;
 	}
 	if (init_data_size > priv->hw_params.max_data_size) {
-		IWL_DEBUG_INFO
-		    ("uCode init data len %d too large to fit in\n",
+		IWL_INFO(priv, "uCode init data len %d too large to fit in\n",
 		      init_data_size);
 		ret = -EINVAL;
 		goto err_release;
 	}
 	if (boot_size > priv->hw_params.max_bsm_size) {
-		IWL_DEBUG_INFO
-		    ("uCode boot instr len %d too large to fit in\n",
-		      boot_size);
+		IWL_INFO(priv, "uCode boot instr len %d too large to fit in\n",
+			boot_size);
 		ret = -EINVAL;
 		goto err_release;
 	}
@@ -1585,16 +1582,16 @@ static int iwl_read_ucode(struct iwl_priv *priv)
 	/* Runtime instructions (first block of data in file) */
 	src = &ucode->data[0];
 	len = priv->ucode_code.len;
-	IWL_DEBUG_INFO("Copying (but not loading) uCode instr len %Zd\n", len);
+	IWL_DEBUG_INFO(priv, "Copying (but not loading) uCode instr len %Zd\n", len);
 	memcpy(priv->ucode_code.v_addr, src, len);
-	IWL_DEBUG_INFO("uCode instr buf vaddr = 0x%p, paddr = 0x%08x\n",
+	IWL_DEBUG_INFO(priv, "uCode instr buf vaddr = 0x%p, paddr = 0x%08x\n",
 		priv->ucode_code.v_addr, (u32)priv->ucode_code.p_addr);
 
 	/* Runtime data (2nd block)
 	 * NOTE:  Copy into backup buffer will be done in iwl_up()  */
 	src = &ucode->data[inst_size];
 	len = priv->ucode_data.len;
-	IWL_DEBUG_INFO("Copying (but not loading) uCode data len %Zd\n", len);
+	IWL_DEBUG_INFO(priv, "Copying (but not loading) uCode data len %Zd\n", len);
 	memcpy(priv->ucode_data.v_addr, src, len);
 	memcpy(priv->ucode_data_backup.v_addr, src, len);
 
@@ -1602,7 +1599,7 @@ static int iwl_read_ucode(struct iwl_priv *priv)
 	if (init_size) {
 		src = &ucode->data[inst_size + data_size];
 		len = priv->ucode_init.len;
-		IWL_DEBUG_INFO("Copying (but not loading) init instr len %Zd\n",
+		IWL_DEBUG_INFO(priv, "Copying (but not loading) init instr len %Zd\n",
 				len);
 		memcpy(priv->ucode_init.v_addr, src, len);
 	}
@@ -1611,7 +1608,7 @@ static int iwl_read_ucode(struct iwl_priv *priv)
 	if (init_data_size) {
 		src = &ucode->data[inst_size + data_size + init_size];
 		len = priv->ucode_init_data.len;
-		IWL_DEBUG_INFO("Copying (but not loading) init data len %Zd\n",
+		IWL_DEBUG_INFO(priv, "Copying (but not loading) init data len %Zd\n",
 			       len);
 		memcpy(priv->ucode_init_data.v_addr, src, len);
 	}
@@ -1619,7 +1616,7 @@ static int iwl_read_ucode(struct iwl_priv *priv)
 	/* Bootstrap instructions (5th block) */
 	src = &ucode->data[inst_size + data_size + init_size + init_data_size];
 	len = priv->ucode_boot.len;
-	IWL_DEBUG_INFO("Copying (but not loading) boot instr len %Zd\n", len);
+	IWL_DEBUG_INFO(priv, "Copying (but not loading) boot instr len %Zd\n", len);
 	memcpy(priv->ucode_boot.v_addr, src, len);
 
 	/* We have our copies now, allow OS release its copies */
@@ -1651,12 +1648,12 @@ static void iwl_alive_start(struct iwl_priv *priv)
 {
 	int ret = 0;
 
-	IWL_DEBUG_INFO("Runtime Alive received.\n");
+	IWL_DEBUG_INFO(priv, "Runtime Alive received.\n");
 
 	if (priv->card_alive.is_valid != UCODE_VALID_OK) {
 		/* We had an error bringing up the hardware, so take it
 		 * all the way back down so we can try again */
-		IWL_DEBUG_INFO("Alive failed.\n");
+		IWL_DEBUG_INFO(priv, "Alive failed.\n");
 		goto restart;
 	}
 
@@ -1666,7 +1663,7 @@ static void iwl_alive_start(struct iwl_priv *priv)
 	if (iwl_verify_ucode(priv)) {
 		/* Runtime instruction load was bad;
 		 * take it all the way back down so we can try again */
-		IWL_DEBUG_INFO("Bad runtime uCode load.\n");
+		IWL_DEBUG_INFO(priv, "Bad runtime uCode load.\n");
 		goto restart;
 	}
 
@@ -1716,7 +1713,7 @@ static void iwl_alive_start(struct iwl_priv *priv)
 
 	iwl_leds_register(priv);
 
-	IWL_DEBUG_INFO("ALIVE processing complete.\n");
+	IWL_DEBUG_INFO(priv, "ALIVE processing complete.\n");
 	set_bit(STATUS_READY, &priv->status);
 	wake_up_interruptible(&priv->wait_command_queue);
 
@@ -1750,7 +1747,7 @@ static void __iwl_down(struct iwl_priv *priv)
 	unsigned long flags;
 	int exit_pending = test_bit(STATUS_EXIT_PENDING, &priv->status);
 
-	IWL_DEBUG_INFO(DRV_NAME " is going down\n");
+	IWL_DEBUG_INFO(priv, DRV_NAME " is going down\n");
 
 	if (!exit_pending)
 		set_bit(STATUS_EXIT_PENDING, &priv->status);
@@ -1931,7 +1928,7 @@ static int __iwl_up(struct iwl_priv *priv)
 		/* start card; "initialize" will load runtime ucode */
 		iwl_nic_start(priv);
 
-		IWL_DEBUG_INFO(DRV_NAME " is coming up\n");
+		IWL_DEBUG_INFO(priv, DRV_NAME " is coming up\n");
 
 		return 0;
 	}
@@ -2052,7 +2049,7 @@ static void iwl_post_associate(struct iwl_priv *priv)
 		return;
 	}
 
-	IWL_DEBUG_ASSOC("Associated as %d to: %pM\n",
+	IWL_DEBUG_ASSOC(priv, "Associated as %d to: %pM\n",
 			priv->assoc_id, priv->active_rxon.bssid_addr);
 
 
@@ -2085,7 +2082,7 @@ static void iwl_post_associate(struct iwl_priv *priv)
 	iwl_set_rxon_chain(priv);
 	priv->staging_rxon.assoc_id = cpu_to_le16(priv->assoc_id);
 
-	IWL_DEBUG_ASSOC("assoc id %d beacon interval %d\n",
+	IWL_DEBUG_ASSOC(priv, "assoc id %d beacon interval %d\n",
 			priv->assoc_id, priv->beacon_int);
 
 	if (priv->assoc_capability & WLAN_CAPABILITY_SHORT_PREAMBLE)
@@ -2158,7 +2155,7 @@ static int iwl_mac_start(struct ieee80211_hw *hw)
 	struct iwl_priv *priv = hw->priv;
 	int ret;
 
-	IWL_DEBUG_MAC80211("enter\n");
+	IWL_DEBUG_MAC80211(priv, "enter\n");
 
 	/* we should be verifying the device is ready to be opened */
 	mutex_lock(&priv->mutex);
@@ -2188,7 +2185,7 @@ static int iwl_mac_start(struct ieee80211_hw *hw)
 	if (iwl_is_rfkill(priv))
 		goto out;
 
-	IWL_DEBUG_INFO("Start UP work done.\n");
+	IWL_DEBUG_INFO(priv, "Start UP work done.\n");
 
 	if (test_bit(STATUS_IN_SUSPEND, &priv->status))
 		return 0;
@@ -2208,7 +2205,7 @@ static int iwl_mac_start(struct ieee80211_hw *hw)
 
 out:
 	priv->is_open = 1;
-	IWL_DEBUG_MAC80211("leave\n");
+	IWL_DEBUG_MAC80211(priv, "leave\n");
 	return 0;
 }
 
@@ -2216,10 +2213,10 @@ static void iwl_mac_stop(struct ieee80211_hw *hw)
 {
 	struct iwl_priv *priv = hw->priv;
 
-	IWL_DEBUG_MAC80211("enter\n");
+	IWL_DEBUG_MAC80211(priv, "enter\n");
 
 	if (!priv->is_open) {
-		IWL_DEBUG_MAC80211("leave - skip\n");
+		IWL_DEBUG_MAC80211(priv, "leave - skip\n");
 		return;
 	}
 
@@ -2242,22 +2239,22 @@ static void iwl_mac_stop(struct ieee80211_hw *hw)
 	iwl_write32(priv, CSR_INT, 0xFFFFFFFF);
 	iwl_enable_interrupts(priv);
 
-	IWL_DEBUG_MAC80211("leave\n");
+	IWL_DEBUG_MAC80211(priv, "leave\n");
 }
 
 static int iwl_mac_tx(struct ieee80211_hw *hw, struct sk_buff *skb)
 {
 	struct iwl_priv *priv = hw->priv;
 
-	IWL_DEBUG_MACDUMP("enter\n");
+	IWL_DEBUG_MACDUMP(priv, "enter\n");
 
-	IWL_DEBUG_TX("dev->xmit(%d bytes) at rate 0x%02x\n", skb->len,
+	IWL_DEBUG_TX(priv, "dev->xmit(%d bytes) at rate 0x%02x\n", skb->len,
 		     ieee80211_get_tx_rate(hw, IEEE80211_SKB_CB(skb))->bitrate);
 
 	if (iwl_tx_skb(priv, skb))
 		dev_kfree_skb_any(skb);
 
-	IWL_DEBUG_MACDUMP("leave\n");
+	IWL_DEBUG_MACDUMP(priv, "leave\n");
 	return NETDEV_TX_OK;
 }
 
@@ -2267,10 +2264,10 @@ static int iwl_mac_add_interface(struct ieee80211_hw *hw,
 	struct iwl_priv *priv = hw->priv;
 	unsigned long flags;
 
-	IWL_DEBUG_MAC80211("enter: type %d\n", conf->type);
+	IWL_DEBUG_MAC80211(priv, "enter: type %d\n", conf->type);
 
 	if (priv->vif) {
-		IWL_DEBUG_MAC80211("leave - vif != NULL\n");
+		IWL_DEBUG_MAC80211(priv, "leave - vif != NULL\n");
 		return -EOPNOTSUPP;
 	}
 
@@ -2283,7 +2280,7 @@ static int iwl_mac_add_interface(struct ieee80211_hw *hw,
 	mutex_lock(&priv->mutex);
 
 	if (conf->mac_addr) {
-		IWL_DEBUG_MAC80211("Set %pM\n", conf->mac_addr);
+		IWL_DEBUG_MAC80211(priv, "Set %pM\n", conf->mac_addr);
 		memcpy(priv->mac_addr, conf->mac_addr, ETH_ALEN);
 	}
 
@@ -2293,7 +2290,7 @@ static int iwl_mac_add_interface(struct ieee80211_hw *hw,
 
 	mutex_unlock(&priv->mutex);
 
-	IWL_DEBUG_MAC80211("leave\n");
+	IWL_DEBUG_MAC80211(priv, "leave\n");
 	return 0;
 }
 
@@ -2314,12 +2311,12 @@ static int iwl_mac_config(struct ieee80211_hw *hw, u32 changed)
 	u16 channel;
 
 	mutex_lock(&priv->mutex);
-	IWL_DEBUG_MAC80211("enter to channel %d\n", conf->channel->hw_value);
+	IWL_DEBUG_MAC80211(priv, "enter to channel %d\n", conf->channel->hw_value);
 
 	priv->current_ht_config.is_ht = conf_is_ht(conf);
 
 	if (conf->radio_enabled && iwl_radio_kill_sw_enable_radio(priv)) {
-		IWL_DEBUG_MAC80211("leave - RF-KILL - waiting for uCode\n");
+		IWL_DEBUG_MAC80211(priv, "leave - RF-KILL - waiting for uCode\n");
 		goto out;
 	}
 
@@ -2327,14 +2324,14 @@ static int iwl_mac_config(struct ieee80211_hw *hw, u32 changed)
 		iwl_radio_kill_sw_disable_radio(priv);
 
 	if (!iwl_is_ready(priv)) {
-		IWL_DEBUG_MAC80211("leave - not ready\n");
+		IWL_DEBUG_MAC80211(priv, "leave - not ready\n");
 		ret = -EIO;
 		goto out;
 	}
 
 	if (unlikely(!priv->cfg->mod_params->disable_hw_scan &&
 		     test_bit(STATUS_SCANNING, &priv->status))) {
-		IWL_DEBUG_MAC80211("leave - scanning\n");
+		IWL_DEBUG_MAC80211(priv, "leave - scanning\n");
 		mutex_unlock(&priv->mutex);
 		return 0;
 	}
@@ -2342,7 +2339,7 @@ static int iwl_mac_config(struct ieee80211_hw *hw, u32 changed)
 	channel = ieee80211_frequency_to_channel(conf->channel->center_freq);
 	ch_info = iwl_get_channel_info(priv, conf->channel->band, channel);
 	if (!is_channel_valid(ch_info)) {
-		IWL_DEBUG_MAC80211("leave - invalid channel\n");
+		IWL_DEBUG_MAC80211(priv, "leave - invalid channel\n");
 		ret = -EINVAL;
 		goto out;
 	}
@@ -2387,12 +2384,12 @@ static int iwl_mac_config(struct ieee80211_hw *hw, u32 changed)
 #endif
 
 	if (!conf->radio_enabled) {
-		IWL_DEBUG_MAC80211("leave - radio disabled\n");
+		IWL_DEBUG_MAC80211(priv, "leave - radio disabled\n");
 		goto out;
 	}
 
 	if (iwl_is_rfkill(priv)) {
-		IWL_DEBUG_MAC80211("leave - RF kill\n");
+		IWL_DEBUG_MAC80211(priv, "leave - RF kill\n");
 		ret = -EIO;
 		goto out;
 	}
@@ -2402,9 +2399,9 @@ static int iwl_mac_config(struct ieee80211_hw *hw, u32 changed)
 	else
 		ret = iwl_power_set_user_mode(priv, IWL_POWER_MODE_CAM);
 	if (ret)
-		IWL_DEBUG_MAC80211("Error setting power level\n");
+		IWL_DEBUG_MAC80211(priv, "Error setting power level\n");
 
-	IWL_DEBUG_MAC80211("TX Power old=%d new=%d\n",
+	IWL_DEBUG_MAC80211(priv, "TX Power old=%d new=%d\n",
 			   priv->tx_power_user_lmt, conf->power_level);
 
 	iwl_set_tx_power(priv, conf->power_level, false);
@@ -2418,9 +2415,9 @@ static int iwl_mac_config(struct ieee80211_hw *hw, u32 changed)
 		   &priv->staging_rxon, sizeof(priv->staging_rxon)))
 		iwl_commit_rxon(priv);
 	else
-		IWL_DEBUG_INFO("No re-sending same RXON configuration.\n");
+		IWL_DEBUG_INFO(priv, "No re-sending same RXON configuration.\n");
 
-	IWL_DEBUG_MAC80211("leave\n");
+	IWL_DEBUG_MAC80211(priv, "leave\n");
 
 out:
 	mutex_unlock(&priv->mutex);
@@ -2501,7 +2498,7 @@ static int iwl_mac_config_interface(struct ieee80211_hw *hw,
 		return -EIO;
 
 	if (priv->vif != vif) {
-		IWL_DEBUG_MAC80211("leave - priv->vif != vif\n");
+		IWL_DEBUG_MAC80211(priv, "leave - priv->vif != vif\n");
 		return 0;
 	}
 
@@ -2523,7 +2520,7 @@ static int iwl_mac_config_interface(struct ieee80211_hw *hw,
 	mutex_lock(&priv->mutex);
 
 	if (conf->bssid)
-		IWL_DEBUG_MAC80211("bssid: %pM\n", conf->bssid);
+		IWL_DEBUG_MAC80211(priv, "bssid: %pM\n", conf->bssid);
 
 /*
  * very dubious code was here; the probe filtering flag is never set:
@@ -2536,7 +2533,7 @@ static int iwl_mac_config_interface(struct ieee80211_hw *hw,
 		if (!conf->bssid) {
 			conf->bssid = priv->mac_addr;
 			memcpy(priv->bssid, priv->mac_addr, ETH_ALEN);
-			IWL_DEBUG_MAC80211("bssid was set to: %pM\n",
+			IWL_DEBUG_MAC80211(priv, "bssid was set to: %pM\n",
 					   conf->bssid);
 		}
 		if (priv->ibss_beacon)
@@ -2555,7 +2552,7 @@ static int iwl_mac_config_interface(struct ieee80211_hw *hw,
 		if (iwl_scan_cancel_timeout(priv, 100)) {
 			IWL_WARN(priv, "Aborted scan still in progress "
 				    "after 100ms\n");
-			IWL_DEBUG_MAC80211("leaving - scan abort failed.\n");
+			IWL_DEBUG_MAC80211(priv, "leaving - scan abort failed.\n");
 			mutex_unlock(&priv->mutex);
 			return -EAGAIN;
 		}
@@ -2583,7 +2580,7 @@ static int iwl_mac_config_interface(struct ieee80211_hw *hw,
 	}
 
  done:
-	IWL_DEBUG_MAC80211("leave\n");
+	IWL_DEBUG_MAC80211(priv, "leave\n");
 	mutex_unlock(&priv->mutex);
 
 	return 0;
@@ -2594,7 +2591,7 @@ static void iwl_mac_remove_interface(struct ieee80211_hw *hw,
 {
 	struct iwl_priv *priv = hw->priv;
 
-	IWL_DEBUG_MAC80211("enter\n");
+	IWL_DEBUG_MAC80211(priv, "enter\n");
 
 	mutex_lock(&priv->mutex);
 
@@ -2609,7 +2606,7 @@ static void iwl_mac_remove_interface(struct ieee80211_hw *hw,
 	}
 	mutex_unlock(&priv->mutex);
 
-	IWL_DEBUG_MAC80211("leave\n");
+	IWL_DEBUG_MAC80211(priv, "leave\n");
 
 }
 
@@ -2621,10 +2618,10 @@ static void iwl_bss_info_changed(struct ieee80211_hw *hw,
 {
 	struct iwl_priv *priv = hw->priv;
 
-	IWL_DEBUG_MAC80211("changes = 0x%X\n", changes);
+	IWL_DEBUG_MAC80211(priv, "changes = 0x%X\n", changes);
 
 	if (changes & BSS_CHANGED_ERP_PREAMBLE) {
-		IWL_DEBUG_MAC80211("ERP_PREAMBLE %d\n",
+		IWL_DEBUG_MAC80211(priv, "ERP_PREAMBLE %d\n",
 				   bss_conf->use_short_preamble);
 		if (bss_conf->use_short_preamble)
 			priv->staging_rxon.flags |= RXON_FLG_SHORT_PREAMBLE_MSK;
@@ -2633,7 +2630,7 @@ static void iwl_bss_info_changed(struct ieee80211_hw *hw,
 	}
 
 	if (changes & BSS_CHANGED_ERP_CTS_PROT) {
-		IWL_DEBUG_MAC80211("ERP_CTS %d\n", bss_conf->use_cts_prot);
+		IWL_DEBUG_MAC80211(priv, "ERP_CTS %d\n", bss_conf->use_cts_prot);
 		if (bss_conf->use_cts_prot && (priv->band != IEEE80211_BAND_5GHZ))
 			priv->staging_rxon.flags |= RXON_FLG_TGG_PROTECT_MSK;
 		else
@@ -2646,7 +2643,7 @@ static void iwl_bss_info_changed(struct ieee80211_hw *hw,
 	}
 
 	if (changes & BSS_CHANGED_ASSOC) {
-		IWL_DEBUG_MAC80211("ASSOC %d\n", bss_conf->assoc);
+		IWL_DEBUG_MAC80211(priv, "ASSOC %d\n", bss_conf->assoc);
 		/* This should never happen as this function should
 		 * never be called from interrupt context. */
 		if (WARN_ON_ONCE(in_interrupt()))
@@ -2668,10 +2665,10 @@ static void iwl_bss_info_changed(struct ieee80211_hw *hw,
 			mutex_unlock(&priv->mutex);
 		} else {
 			priv->assoc_id = 0;
-			IWL_DEBUG_MAC80211("DISASSOC %d\n", bss_conf->assoc);
+			IWL_DEBUG_MAC80211(priv, "DISASSOC %d\n", bss_conf->assoc);
 		}
 	} else if (changes && iwl_is_associated(priv) && priv->assoc_id) {
-			IWL_DEBUG_MAC80211("Associated Changes %d\n", changes);
+			IWL_DEBUG_MAC80211(priv, "Associated Changes %d\n", changes);
 			iwl_send_rxon_assoc(priv);
 	}
 
@@ -2683,14 +2680,14 @@ static int iwl_mac_hw_scan(struct ieee80211_hw *hw, u8 *ssid, size_t ssid_len)
 	struct iwl_priv *priv = hw->priv;
 	int ret;
 
-	IWL_DEBUG_MAC80211("enter\n");
+	IWL_DEBUG_MAC80211(priv, "enter\n");
 
 	mutex_lock(&priv->mutex);
 	spin_lock_irqsave(&priv->lock, flags);
 
 	if (!iwl_is_ready_rf(priv)) {
 		ret = -EIO;
-		IWL_DEBUG_MAC80211("leave - not ready or exit pending\n");
+		IWL_DEBUG_MAC80211(priv, "leave - not ready or exit pending\n");
 		goto out_unlock;
 	}
 
@@ -2700,7 +2697,7 @@ static int iwl_mac_hw_scan(struct ieee80211_hw *hw, u8 *ssid, size_t ssid_len)
 	 */
 	if (priv->next_scan_jiffies &&
 	    time_after(priv->next_scan_jiffies, jiffies)) {
-		IWL_DEBUG_SCAN("scan rejected: within next scan period\n");
+		IWL_DEBUG_SCAN(priv, "scan rejected: within next scan period\n");
 		queue_work(priv->workqueue, &priv->scan_completed);
 		ret = 0;
 		goto out_unlock;
@@ -2709,7 +2706,7 @@ static int iwl_mac_hw_scan(struct ieee80211_hw *hw, u8 *ssid, size_t ssid_len)
 	/* if we just finished scan ask for delay */
 	if (iwl_is_associated(priv) && priv->last_scan_jiffies &&
 	    time_after(priv->last_scan_jiffies + IWL_DELAY_NEXT_SCAN, jiffies)) {
-		IWL_DEBUG_SCAN("scan rejected: within previous scan period\n");
+		IWL_DEBUG_SCAN(priv, "scan rejected: within previous scan period\n");
 		queue_work(priv->workqueue, &priv->scan_completed);
 		ret = 0;
 		goto out_unlock;
@@ -2725,7 +2722,7 @@ static int iwl_mac_hw_scan(struct ieee80211_hw *hw, u8 *ssid, size_t ssid_len)
 
 	ret = iwl_scan_initiate(priv);
 
-	IWL_DEBUG_MAC80211("leave\n");
+	IWL_DEBUG_MAC80211(priv, "leave\n");
 
 out_unlock:
 	spin_unlock_irqrestore(&priv->lock, flags);
@@ -2740,11 +2737,11 @@ static void iwl_mac_update_tkip_key(struct ieee80211_hw *hw,
 {
 
 	struct iwl_priv *priv = hw->priv;
-	IWL_DEBUG_MAC80211("enter\n");
+	IWL_DEBUG_MAC80211(priv, "enter\n");
 
 	iwl_update_tkip_key(priv, keyconf, addr, iv32, phase1key);
 
-	IWL_DEBUG_MAC80211("leave\n");
+	IWL_DEBUG_MAC80211(priv, "leave\n");
 }
 
 static int iwl_mac_set_key(struct ieee80211_hw *hw, enum set_key_cmd cmd,
@@ -2758,16 +2755,16 @@ static int iwl_mac_set_key(struct ieee80211_hw *hw, enum set_key_cmd cmd,
 	u8 sta_id;
 	bool is_default_wep_key = false;
 
-	IWL_DEBUG_MAC80211("enter\n");
+	IWL_DEBUG_MAC80211(priv, "enter\n");
 
 	if (priv->hw_params.sw_crypto) {
-		IWL_DEBUG_MAC80211("leave - hwcrypto disabled\n");
+		IWL_DEBUG_MAC80211(priv, "leave - hwcrypto disabled\n");
 		return -EOPNOTSUPP;
 	}
 	addr = sta ? sta->addr : iwl_bcast_addr;
 	sta_id = iwl_find_station(priv, addr);
 	if (sta_id == IWL_INVALID_STATION) {
-		IWL_DEBUG_MAC80211("leave - %pM not in station map.\n",
+		IWL_DEBUG_MAC80211(priv, "leave - %pM not in station map.\n",
 				   addr);
 		return -EINVAL;
 
@@ -2797,7 +2794,7 @@ static int iwl_mac_set_key(struct ieee80211_hw *hw, enum set_key_cmd cmd,
 		else
 			ret = iwl_set_dynamic_key(priv, key, sta_id);
 
-		IWL_DEBUG_MAC80211("enable hwcrypto key\n");
+		IWL_DEBUG_MAC80211(priv, "enable hwcrypto key\n");
 		break;
 	case DISABLE_KEY:
 		if (is_default_wep_key)
@@ -2805,13 +2802,13 @@ static int iwl_mac_set_key(struct ieee80211_hw *hw, enum set_key_cmd cmd,
 		else
 			ret = iwl_remove_dynamic_key(priv, key, sta_id);
 
-		IWL_DEBUG_MAC80211("disable hwcrypto key\n");
+		IWL_DEBUG_MAC80211(priv, "disable hwcrypto key\n");
 		break;
 	default:
 		ret = -EINVAL;
 	}
 
-	IWL_DEBUG_MAC80211("leave\n");
+	IWL_DEBUG_MAC80211(priv, "leave\n");
 
 	return ret;
 }
@@ -2823,15 +2820,15 @@ static int iwl_mac_conf_tx(struct ieee80211_hw *hw, u16 queue,
 	unsigned long flags;
 	int q;
 
-	IWL_DEBUG_MAC80211("enter\n");
+	IWL_DEBUG_MAC80211(priv, "enter\n");
 
 	if (!iwl_is_ready_rf(priv)) {
-		IWL_DEBUG_MAC80211("leave - RF not ready\n");
+		IWL_DEBUG_MAC80211(priv, "leave - RF not ready\n");
 		return -EIO;
 	}
 
 	if (queue >= AC_NUM) {
-		IWL_DEBUG_MAC80211("leave - queue >= AC_NUM %d\n", queue);
+		IWL_DEBUG_MAC80211(priv, "leave - queue >= AC_NUM %d\n", queue);
 		return 0;
 	}
 
@@ -2855,7 +2852,7 @@ static int iwl_mac_conf_tx(struct ieee80211_hw *hw, u16 queue,
 
 	spin_unlock_irqrestore(&priv->lock, flags);
 
-	IWL_DEBUG_MAC80211("leave\n");
+	IWL_DEBUG_MAC80211(priv, "leave\n");
 	return 0;
 }
 
@@ -2865,7 +2862,7 @@ static int iwl_mac_ampdu_action(struct ieee80211_hw *hw,
 {
 	struct iwl_priv *priv = hw->priv;
 
-	IWL_DEBUG_HT("A-MPDU action on addr %pM tid %d\n",
+	IWL_DEBUG_HT(priv, "A-MPDU action on addr %pM tid %d\n",
 		     sta->addr, tid);
 
 	if (!(priv->cfg->sku & IWL_SKU_N))
@@ -2873,19 +2870,19 @@ static int iwl_mac_ampdu_action(struct ieee80211_hw *hw,
 
 	switch (action) {
 	case IEEE80211_AMPDU_RX_START:
-		IWL_DEBUG_HT("start Rx\n");
+		IWL_DEBUG_HT(priv, "start Rx\n");
 		return iwl_sta_rx_agg_start(priv, sta->addr, tid, *ssn);
 	case IEEE80211_AMPDU_RX_STOP:
-		IWL_DEBUG_HT("stop Rx\n");
+		IWL_DEBUG_HT(priv, "stop Rx\n");
 		return iwl_sta_rx_agg_stop(priv, sta->addr, tid);
 	case IEEE80211_AMPDU_TX_START:
-		IWL_DEBUG_HT("start Tx\n");
+		IWL_DEBUG_HT(priv, "start Tx\n");
 		return iwl_tx_agg_start(priv, sta->addr, tid, ssn);
 	case IEEE80211_AMPDU_TX_STOP:
-		IWL_DEBUG_HT("stop Tx\n");
+		IWL_DEBUG_HT(priv, "stop Tx\n");
 		return iwl_tx_agg_stop(priv, sta->addr, tid);
 	default:
-		IWL_DEBUG_HT("unknown\n");
+		IWL_DEBUG_HT(priv, "unknown\n");
 		return -EINVAL;
 		break;
 	}
@@ -2901,10 +2898,10 @@ static int iwl_mac_get_tx_stats(struct ieee80211_hw *hw,
 	struct iwl_queue *q;
 	unsigned long flags;
 
-	IWL_DEBUG_MAC80211("enter\n");
+	IWL_DEBUG_MAC80211(priv, "enter\n");
 
 	if (!iwl_is_ready_rf(priv)) {
-		IWL_DEBUG_MAC80211("leave - RF not ready\n");
+		IWL_DEBUG_MAC80211(priv, "leave - RF not ready\n");
 		return -EIO;
 	}
 
@@ -2922,7 +2919,7 @@ static int iwl_mac_get_tx_stats(struct ieee80211_hw *hw,
 	}
 	spin_unlock_irqrestore(&priv->lock, flags);
 
-	IWL_DEBUG_MAC80211("leave\n");
+	IWL_DEBUG_MAC80211(priv, "leave\n");
 
 	return 0;
 }
@@ -2933,8 +2930,8 @@ static int iwl_mac_get_stats(struct ieee80211_hw *hw,
 	struct iwl_priv *priv = hw->priv;
 
 	priv = hw->priv;
-	IWL_DEBUG_MAC80211("enter\n");
-	IWL_DEBUG_MAC80211("leave\n");
+	IWL_DEBUG_MAC80211(priv, "enter\n");
+	IWL_DEBUG_MAC80211(priv, "leave\n");
 
 	return 0;
 }
@@ -2945,7 +2942,7 @@ static void iwl_mac_reset_tsf(struct ieee80211_hw *hw)
 	unsigned long flags;
 
 	mutex_lock(&priv->mutex);
-	IWL_DEBUG_MAC80211("enter\n");
+	IWL_DEBUG_MAC80211(priv, "enter\n");
 
 	spin_lock_irqsave(&priv->lock, flags);
 	memset(&priv->current_ht_config, 0, sizeof(struct iwl_ht_info));
@@ -2972,7 +2969,7 @@ static void iwl_mac_reset_tsf(struct ieee80211_hw *hw)
 	spin_unlock_irqrestore(&priv->lock, flags);
 
 	if (!iwl_is_ready_rf(priv)) {
-		IWL_DEBUG_MAC80211("leave - not ready\n");
+		IWL_DEBUG_MAC80211(priv, "leave - not ready\n");
 		mutex_unlock(&priv->mutex);
 		return;
 	}
@@ -3001,7 +2998,7 @@ static void iwl_mac_reset_tsf(struct ieee80211_hw *hw)
 						     IEEE80211_CHAN_RADAR))
 				iwl_power_disable_management(priv, 3000);
 
-		IWL_DEBUG_MAC80211("leave - not in IBSS\n");
+		IWL_DEBUG_MAC80211(priv, "leave - not in IBSS\n");
 		mutex_unlock(&priv->mutex);
 		return;
 	}
@@ -3010,7 +3007,7 @@ static void iwl_mac_reset_tsf(struct ieee80211_hw *hw)
 
 	mutex_unlock(&priv->mutex);
 
-	IWL_DEBUG_MAC80211("leave\n");
+	IWL_DEBUG_MAC80211(priv, "leave\n");
 }
 
 static int iwl_mac_beacon_update(struct ieee80211_hw *hw, struct sk_buff *skb)
@@ -3019,15 +3016,15 @@ static int iwl_mac_beacon_update(struct ieee80211_hw *hw, struct sk_buff *skb)
 	unsigned long flags;
 	__le64 timestamp;
 
-	IWL_DEBUG_MAC80211("enter\n");
+	IWL_DEBUG_MAC80211(priv, "enter\n");
 
 	if (!iwl_is_ready_rf(priv)) {
-		IWL_DEBUG_MAC80211("leave - RF not ready\n");
+		IWL_DEBUG_MAC80211(priv, "leave - RF not ready\n");
 		return -EIO;
 	}
 
 	if (priv->iw_mode != NL80211_IFTYPE_ADHOC) {
-		IWL_DEBUG_MAC80211("leave - not IBSS\n");
+		IWL_DEBUG_MAC80211(priv, "leave - not IBSS\n");
 		return -EIO;
 	}
 
@@ -3042,7 +3039,7 @@ static int iwl_mac_beacon_update(struct ieee80211_hw *hw, struct sk_buff *skb)
 	timestamp = ((struct ieee80211_mgmt *)skb->data)->u.beacon.timestamp;
 	priv->timestamp = le64_to_cpu(timestamp);
 
-	IWL_DEBUG_MAC80211("leave\n");
+	IWL_DEBUG_MAC80211(priv, "leave\n");
 	spin_unlock_irqrestore(&priv->lock, flags);
 
 	iwl_reset_qos(priv);
@@ -3200,7 +3197,7 @@ static ssize_t store_flags(struct device *d,
 		if (iwl_scan_cancel_timeout(priv, 100))
 			IWL_WARN(priv, "Could not cancel scan.\n");
 		else {
-			IWL_DEBUG_INFO("Commit rxon.flags = 0x%04X\n", flags);
+			IWL_DEBUG_INFO(priv, "Commit rxon.flags = 0x%04X\n", flags);
 			priv->staging_rxon.flags = cpu_to_le32(flags);
 			iwl_commit_rxon(priv);
 		}
@@ -3239,7 +3236,7 @@ static ssize_t store_filter_flags(struct device *d,
 		if (iwl_scan_cancel_timeout(priv, 100))
 			IWL_WARN(priv, "Could not cancel scan.\n");
 		else {
-			IWL_DEBUG_INFO("Committing rxon.filter_flags = "
+			IWL_DEBUG_INFO(priv, "Committing rxon.filter_flags = "
 				       "0x%04X\n", filter_flags);
 			priv->staging_rxon.filter_flags =
 				cpu_to_le32(filter_flags);
@@ -3276,7 +3273,7 @@ static ssize_t store_power_level(struct device *d,
 
 	ret = iwl_power_set_user_mode(priv, mode);
 	if (ret) {
-		IWL_DEBUG_MAC80211("failed setting power mode.\n");
+		IWL_DEBUG_MAC80211(priv, "failed setting power mode.\n");
 		goto out;
 	}
 	ret = count;
@@ -3477,7 +3474,7 @@ static int iwl_pci_probe(struct pci_dev *pdev, const struct pci_device_id *ent)
 
 	SET_IEEE80211_DEV(hw, &pdev->dev);
 
-	IWL_DEBUG_INFO("*** LOAD DRIVER ***\n");
+	IWL_DEBUG_INFO(priv, "*** LOAD DRIVER ***\n");
 	priv->cfg = cfg;
 	priv->pci_dev = pdev;
 
@@ -3526,9 +3523,9 @@ static int iwl_pci_probe(struct pci_dev *pdev, const struct pci_device_id *ent)
 		goto out_pci_release_regions;
 	}
 
-	IWL_DEBUG_INFO("pci_resource_len = 0x%08llx\n",
+	IWL_DEBUG_INFO(priv, "pci_resource_len = 0x%08llx\n",
 		(unsigned long long) pci_resource_len(pdev, 0));
-	IWL_DEBUG_INFO("pci_resource_base = %p\n", priv->hw_base);
+	IWL_DEBUG_INFO(priv, "pci_resource_base = %p\n", priv->hw_base);
 
 	iwl_hw_detect(priv);
 	IWL_INFO(priv, "Detected Intel Wireless WiFi Link %s REV=0x%X\n",
@@ -3541,7 +3538,7 @@ static int iwl_pci_probe(struct pci_dev *pdev, const struct pci_device_id *ent)
 	/* amp init */
 	err = priv->cfg->ops->lib->apm_ops.init(priv);
 	if (err < 0) {
-		IWL_DEBUG_INFO("Failed to init APMG\n");
+		IWL_DEBUG_INFO(priv, "Failed to init APMG\n");
 		goto out_iounmap;
 	}
 	/*****************
@@ -3559,7 +3556,7 @@ static int iwl_pci_probe(struct pci_dev *pdev, const struct pci_device_id *ent)
 
 	/* extract MAC Address */
 	iwl_eeprom_get_mac(priv, priv->mac_addr);
-	IWL_DEBUG_INFO("MAC address: %pM\n", priv->mac_addr);
+	IWL_DEBUG_INFO(priv, "MAC address: %pM\n", priv->mac_addr);
 	SET_IEEE80211_PERM_ADDR(priv->hw, priv->mac_addr);
 
 	/************************
@@ -3586,7 +3583,7 @@ static int iwl_pci_probe(struct pci_dev *pdev, const struct pci_device_id *ent)
 	/* Disable radio (SW RF KILL) via parameter when loading driver */
 	if (priv->cfg->mod_params->disable) {
 		set_bit(STATUS_RF_KILL_SW, &priv->status);
-		IWL_DEBUG_INFO("Radio disabled.\n");
+		IWL_DEBUG_INFO(priv, "Radio disabled.\n");
 	}
 
 	/********************
@@ -3680,7 +3677,7 @@ static void __devexit iwl_pci_remove(struct pci_dev *pdev)
 	if (!priv)
 		return;
 
-	IWL_DEBUG_INFO("*** UNLOAD DRIVER ***\n");
+	IWL_DEBUG_INFO(priv, "*** UNLOAD DRIVER ***\n");
 
 	iwl_dbgfs_unregister(priv);
 	sysfs_remove_group(&pdev->dev.kobj, &iwl_attribute_group);
diff --git a/drivers/net/wireless/iwlwifi/iwl-calib.c b/drivers/net/wireless/iwlwifi/iwl-calib.c
index 8e5e666..d06c577 100644
--- a/drivers/net/wireless/iwlwifi/iwl-calib.c
+++ b/drivers/net/wireless/iwlwifi/iwl-calib.c
@@ -202,7 +202,7 @@ static int iwl_sens_energy_cck(struct iwl_priv *priv,
 		val = data->nrg_silence_rssi[i];
 		silence_ref = max(silence_ref, val);
 	}
-	IWL_DEBUG_CALIB("silence a %u, b %u, c %u, 20-bcn max %u\n",
+	IWL_DEBUG_CALIB(priv, "silence a %u, b %u, c %u, 20-bcn max %u\n",
 			silence_rssi_a, silence_rssi_b, silence_rssi_c,
 			silence_ref);
 
@@ -226,7 +226,7 @@ static int iwl_sens_energy_cck(struct iwl_priv *priv,
 		max_nrg_cck = (u32) max(max_nrg_cck, (data->nrg_value[i]));
 	max_nrg_cck += 6;
 
-	IWL_DEBUG_CALIB("rx energy a %u, b %u, c %u, 10-bcn max/min %u\n",
+	IWL_DEBUG_CALIB(priv, "rx energy a %u, b %u, c %u, 10-bcn max/min %u\n",
 			rx_info->beacon_energy_a, rx_info->beacon_energy_b,
 			rx_info->beacon_energy_c, max_nrg_cck - 6);
 
@@ -236,15 +236,15 @@ static int iwl_sens_energy_cck(struct iwl_priv *priv,
 		data->num_in_cck_no_fa++;
 	else
 		data->num_in_cck_no_fa = 0;
-	IWL_DEBUG_CALIB("consecutive bcns with few false alarms = %u\n",
+	IWL_DEBUG_CALIB(priv, "consecutive bcns with few false alarms = %u\n",
 			data->num_in_cck_no_fa);
 
 	/* If we got too many false alarms this time, reduce sensitivity */
 	if ((false_alarms > max_false_alarms) &&
 		(data->auto_corr_cck > AUTO_CORR_MAX_TH_CCK)) {
-		IWL_DEBUG_CALIB("norm FA %u > max FA %u\n",
+		IWL_DEBUG_CALIB(priv, "norm FA %u > max FA %u\n",
 		     false_alarms, max_false_alarms);
-		IWL_DEBUG_CALIB("... reducing sensitivity\n");
+		IWL_DEBUG_CALIB(priv, "... reducing sensitivity\n");
 		data->nrg_curr_state = IWL_FA_TOO_MANY;
 		/* Store for "fewer than desired" on later beacon */
 		data->nrg_silence_ref = silence_ref;
@@ -266,7 +266,7 @@ static int iwl_sens_energy_cck(struct iwl_priv *priv,
 		data->nrg_auto_corr_silence_diff = (s32)data->nrg_silence_ref -
 						   (s32)silence_ref;
 
-		IWL_DEBUG_CALIB("norm FA %u < min FA %u, silence diff %d\n",
+		IWL_DEBUG_CALIB(priv, "norm FA %u < min FA %u, silence diff %d\n",
 			 false_alarms, min_false_alarms,
 			 data->nrg_auto_corr_silence_diff);
 
@@ -280,17 +280,17 @@ static int iwl_sens_energy_cck(struct iwl_priv *priv,
 			((data->nrg_auto_corr_silence_diff > NRG_DIFF) ||
 			(data->num_in_cck_no_fa > MAX_NUMBER_CCK_NO_FA))) {
 
-			IWL_DEBUG_CALIB("... increasing sensitivity\n");
+			IWL_DEBUG_CALIB(priv, "... increasing sensitivity\n");
 			/* Increase nrg value to increase sensitivity */
 			val = data->nrg_th_cck + NRG_STEP_CCK;
 			data->nrg_th_cck = min((u32)ranges->min_nrg_cck, val);
 		} else {
-			IWL_DEBUG_CALIB("... but not changing sensitivity\n");
+			IWL_DEBUG_CALIB(priv, "... but not changing sensitivity\n");
 		}
 
 	/* Else we got a healthy number of false alarms, keep status quo */
 	} else {
-		IWL_DEBUG_CALIB(" FA in safe zone\n");
+		IWL_DEBUG_CALIB(priv, " FA in safe zone\n");
 		data->nrg_curr_state = IWL_FA_GOOD_RANGE;
 
 		/* Store for use in "fewer than desired" with later beacon */
@@ -300,7 +300,7 @@ static int iwl_sens_energy_cck(struct iwl_priv *priv,
 		 *   give it some extra margin by reducing sensitivity again
 		 *   (but don't go below measured energy of desired Rx) */
 		if (IWL_FA_TOO_MANY == data->nrg_prev_state) {
-			IWL_DEBUG_CALIB("... increasing margin\n");
+			IWL_DEBUG_CALIB(priv, "... increasing margin\n");
 			if (data->nrg_th_cck > (max_nrg_cck + NRG_MARGIN))
 				data->nrg_th_cck -= NRG_MARGIN;
 			else
@@ -314,7 +314,7 @@ static int iwl_sens_energy_cck(struct iwl_priv *priv,
 	 * Lower value is higher energy, so we use max()!
 	 */
 	data->nrg_th_cck = max(max_nrg_cck, data->nrg_th_cck);
-	IWL_DEBUG_CALIB("new nrg_th_cck %u\n", data->nrg_th_cck);
+	IWL_DEBUG_CALIB(priv, "new nrg_th_cck %u\n", data->nrg_th_cck);
 
 	data->nrg_prev_state = data->nrg_curr_state;
 
@@ -367,7 +367,7 @@ static int iwl_sens_auto_corr_ofdm(struct iwl_priv *priv,
 	/* If we got too many false alarms this time, reduce sensitivity */
 	if (false_alarms > max_false_alarms) {
 
-		IWL_DEBUG_CALIB("norm FA %u > max FA %u)\n",
+		IWL_DEBUG_CALIB(priv, "norm FA %u > max FA %u)\n",
 			     false_alarms, max_false_alarms);
 
 		val = data->auto_corr_ofdm + AUTO_CORR_STEP_OFDM;
@@ -390,7 +390,7 @@ static int iwl_sens_auto_corr_ofdm(struct iwl_priv *priv,
 	/* Else if we got fewer than desired, increase sensitivity */
 	else if (false_alarms < min_false_alarms) {
 
-		IWL_DEBUG_CALIB("norm FA %u < min FA %u\n",
+		IWL_DEBUG_CALIB(priv, "norm FA %u < min FA %u\n",
 			     false_alarms, min_false_alarms);
 
 		val = data->auto_corr_ofdm - AUTO_CORR_STEP_OFDM;
@@ -409,7 +409,7 @@ static int iwl_sens_auto_corr_ofdm(struct iwl_priv *priv,
 		data->auto_corr_ofdm_mrc_x1 =
 			max((u32)ranges->auto_corr_min_ofdm_mrc_x1, val);
 	} else {
-		IWL_DEBUG_CALIB("min FA %u < norm FA %u < max FA %u OK\n",
+		IWL_DEBUG_CALIB(priv, "min FA %u < norm FA %u < max FA %u OK\n",
 			 min_false_alarms, false_alarms, max_false_alarms);
 	}
 	return 0;
@@ -458,12 +458,12 @@ static int iwl_sensitivity_write(struct iwl_priv *priv)
 	cmd.table[HD_OFDM_ENERGY_TH_IN_INDEX] =
 				__constant_cpu_to_le16(62);
 
-	IWL_DEBUG_CALIB("ofdm: ac %u mrc %u x1 %u mrc_x1 %u thresh %u\n",
+	IWL_DEBUG_CALIB(priv, "ofdm: ac %u mrc %u x1 %u mrc_x1 %u thresh %u\n",
 			data->auto_corr_ofdm, data->auto_corr_ofdm_mrc,
 			data->auto_corr_ofdm_x1, data->auto_corr_ofdm_mrc_x1,
 			data->nrg_th_ofdm);
 
-	IWL_DEBUG_CALIB("cck: ac %u mrc %u thresh %u\n",
+	IWL_DEBUG_CALIB(priv, "cck: ac %u mrc %u thresh %u\n",
 			data->auto_corr_cck, data->auto_corr_cck_mrc,
 			data->nrg_th_cck);
 
@@ -473,7 +473,7 @@ static int iwl_sensitivity_write(struct iwl_priv *priv)
 	/* Don't send command to uCode if nothing has changed */
 	if (!memcmp(&cmd.table[0], &(priv->sensitivity_tbl[0]),
 		    sizeof(u16)*HD_TABLE_SIZE)) {
-		IWL_DEBUG_CALIB("No change in SENSITIVITY_CMD\n");
+		IWL_DEBUG_CALIB(priv, "No change in SENSITIVITY_CMD\n");
 		return 0;
 	}
 
@@ -498,7 +498,7 @@ void iwl_init_sensitivity(struct iwl_priv *priv)
 	if (priv->disable_sens_cal)
 		return;
 
-	IWL_DEBUG_CALIB("Start iwl_init_sensitivity\n");
+	IWL_DEBUG_CALIB(priv, "Start iwl_init_sensitivity\n");
 
 	/* Clear driver's sensitivity algo data */
 	data = &(priv->sensitivity_data);
@@ -536,7 +536,7 @@ void iwl_init_sensitivity(struct iwl_priv *priv)
 	data->last_fa_cnt_cck = 0;
 
 	ret |= iwl_sensitivity_write(priv);
-	IWL_DEBUG_CALIB("<<return 0x%X\n", ret);
+	IWL_DEBUG_CALIB(priv, "<<return 0x%X\n", ret);
 }
 EXPORT_SYMBOL(iwl_init_sensitivity);
 
@@ -562,13 +562,13 @@ void iwl_sensitivity_calibration(struct iwl_priv *priv,
 	data = &(priv->sensitivity_data);
 
 	if (!iwl_is_associated(priv)) {
-		IWL_DEBUG_CALIB("<< - not associated\n");
+		IWL_DEBUG_CALIB(priv, "<< - not associated\n");
 		return;
 	}
 
 	spin_lock_irqsave(&priv->lock, flags);
 	if (rx_info->interference_data_flag != INTERFERENCE_DATA_AVAILABLE) {
-		IWL_DEBUG_CALIB("<< invalid data.\n");
+		IWL_DEBUG_CALIB(priv, "<< invalid data.\n");
 		spin_unlock_irqrestore(&priv->lock, flags);
 		return;
 	}
@@ -595,10 +595,10 @@ void iwl_sensitivity_calibration(struct iwl_priv *priv,
 
 	spin_unlock_irqrestore(&priv->lock, flags);
 
-	IWL_DEBUG_CALIB("rx_enable_time = %u usecs\n", rx_enable_time);
+	IWL_DEBUG_CALIB(priv, "rx_enable_time = %u usecs\n", rx_enable_time);
 
 	if (!rx_enable_time) {
-		IWL_DEBUG_CALIB("<< RX Enable Time == 0! \n");
+		IWL_DEBUG_CALIB(priv, "<< RX Enable Time == 0! \n");
 		return;
 	}
 
@@ -637,7 +637,7 @@ void iwl_sensitivity_calibration(struct iwl_priv *priv,
 	norm_fa_ofdm = fa_ofdm + bad_plcp_ofdm;
 	norm_fa_cck = fa_cck + bad_plcp_cck;
 
-	IWL_DEBUG_CALIB("cck: fa %u badp %u  ofdm: fa %u badp %u\n", fa_cck,
+	IWL_DEBUG_CALIB(priv, "cck: fa %u badp %u  ofdm: fa %u badp %u\n", fa_cck,
 			bad_plcp_cck, fa_ofdm, bad_plcp_ofdm);
 
 	iwl_sens_auto_corr_ofdm(priv, norm_fa_ofdm, rx_enable_time);
@@ -690,13 +690,13 @@ void iwl_chain_noise_calibration(struct iwl_priv *priv,
 	 *   then we're done forever. */
 	if (data->state != IWL_CHAIN_NOISE_ACCUMULATE) {
 		if (data->state == IWL_CHAIN_NOISE_ALIVE)
-			IWL_DEBUG_CALIB("Wait for noise calib reset\n");
+			IWL_DEBUG_CALIB(priv, "Wait for noise calib reset\n");
 		return;
 	}
 
 	spin_lock_irqsave(&priv->lock, flags);
 	if (rx_info->interference_data_flag != INTERFERENCE_DATA_AVAILABLE) {
-		IWL_DEBUG_CALIB(" << Interference data unavailable\n");
+		IWL_DEBUG_CALIB(priv, " << Interference data unavailable\n");
 		spin_unlock_irqrestore(&priv->lock, flags);
 		return;
 	}
@@ -709,7 +709,7 @@ void iwl_chain_noise_calibration(struct iwl_priv *priv,
 	/* Make sure we accumulate data for just the associated channel
 	 *   (even if scanning). */
 	if ((rxon_chnum != stat_chnum) || (rxon_band24 != stat_band24)) {
-		IWL_DEBUG_CALIB("Stats not from chan=%d, band24=%d\n",
+		IWL_DEBUG_CALIB(priv, "Stats not from chan=%d, band24=%d\n",
 				rxon_chnum, rxon_band24);
 		spin_unlock_irqrestore(&priv->lock, flags);
 		return;
@@ -739,11 +739,11 @@ void iwl_chain_noise_calibration(struct iwl_priv *priv,
 	data->chain_signal_b = (chain_sig_b + data->chain_signal_b);
 	data->chain_signal_c = (chain_sig_c + data->chain_signal_c);
 
-	IWL_DEBUG_CALIB("chan=%d, band24=%d, beacon=%d\n",
+	IWL_DEBUG_CALIB(priv, "chan=%d, band24=%d, beacon=%d\n",
 			rxon_chnum, rxon_band24, data->beacon_count);
-	IWL_DEBUG_CALIB("chain_sig: a %d b %d c %d\n",
+	IWL_DEBUG_CALIB(priv, "chain_sig: a %d b %d c %d\n",
 			chain_sig_a, chain_sig_b, chain_sig_c);
-	IWL_DEBUG_CALIB("chain_noise: a %d b %d c %d\n",
+	IWL_DEBUG_CALIB(priv, "chain_noise: a %d b %d c %d\n",
 			chain_noise_a, chain_noise_b, chain_noise_c);
 
 	/* If this is the 20th beacon, determine:
@@ -773,9 +773,9 @@ void iwl_chain_noise_calibration(struct iwl_priv *priv,
 		active_chains = (1 << max_average_sig_antenna_i);
 	}
 
-	IWL_DEBUG_CALIB("average_sig: a %d b %d c %d\n",
+	IWL_DEBUG_CALIB(priv, "average_sig: a %d b %d c %d\n",
 		     average_sig[0], average_sig[1], average_sig[2]);
-	IWL_DEBUG_CALIB("max_average_sig = %d, antenna %d\n",
+	IWL_DEBUG_CALIB(priv, "max_average_sig = %d, antenna %d\n",
 		     max_average_sig, max_average_sig_antenna_i);
 
 	/* Compare signal strengths for all 3 receivers. */
@@ -789,7 +789,7 @@ void iwl_chain_noise_calibration(struct iwl_priv *priv,
 				data->disconn_array[i] = 1;
 			else
 				active_chains |= (1 << i);
-			IWL_DEBUG_CALIB("i = %d  rssiDelta = %d  "
+			IWL_DEBUG_CALIB(priv, "i = %d  rssiDelta = %d  "
 			     "disconn_array[i] = %d\n",
 			     i, rssi_delta, data->disconn_array[i]);
 		}
@@ -813,7 +813,7 @@ void iwl_chain_noise_calibration(struct iwl_priv *priv,
 			 * disconnected connect it anyway */
 			data->disconn_array[i] = 0;
 			active_chains |= ant_msk;
-			IWL_DEBUG_CALIB("All Tx chains are disconnected W/A - "
+			IWL_DEBUG_CALIB(priv, "All Tx chains are disconnected W/A - "
 				"declare %d as connected\n", i);
 			break;
 		}
@@ -821,7 +821,7 @@ void iwl_chain_noise_calibration(struct iwl_priv *priv,
 
 	/* Save for use within RXON, TX, SCAN commands, etc. */
 	priv->chain_noise_data.active_chains = active_chains;
-	IWL_DEBUG_CALIB("active_chains (bitwise) = 0x%x\n",
+	IWL_DEBUG_CALIB(priv, "active_chains (bitwise) = 0x%x\n",
 			active_chains);
 
 	/* Analyze noise for rx balance */
@@ -839,11 +839,11 @@ void iwl_chain_noise_calibration(struct iwl_priv *priv,
 		}
 	}
 
-	IWL_DEBUG_CALIB("average_noise: a %d b %d c %d\n",
+	IWL_DEBUG_CALIB(priv, "average_noise: a %d b %d c %d\n",
 			average_noise[0], average_noise[1],
 			average_noise[2]);
 
-	IWL_DEBUG_CALIB("min_average_noise = %d, antenna %d\n",
+	IWL_DEBUG_CALIB(priv, "min_average_noise = %d, antenna %d\n",
 			min_average_noise, min_average_noise_antenna_i);
 
 	priv->cfg->ops->utils->gain_computation(priv, average_noise,
diff --git a/drivers/net/wireless/iwlwifi/iwl-core.c b/drivers/net/wireless/iwlwifi/iwl-core.c
index 4f2b88c..5f92cfb 100644
--- a/drivers/net/wireless/iwlwifi/iwl-core.c
+++ b/drivers/net/wireless/iwlwifi/iwl-core.c
@@ -323,7 +323,7 @@ void iwl_reset_qos(struct iwl_priv *priv)
 			priv->qos_data.def_qos_parm.ac[i].reserved1 = 0;
 		}
 	}
-	IWL_DEBUG_QOS("set QoS to default \n");
+	IWL_DEBUG_QOS(priv, "set QoS to default \n");
 
 	spin_unlock_irqrestore(&priv->lock, flags);
 }
@@ -419,7 +419,7 @@ int iwlcore_init_geos(struct iwl_priv *priv)
 
 	if (priv->bands[IEEE80211_BAND_2GHZ].n_bitrates ||
 	    priv->bands[IEEE80211_BAND_5GHZ].n_bitrates) {
-		IWL_DEBUG_INFO("Geography modes already initialized.\n");
+		IWL_DEBUG_INFO(priv, "Geography modes already initialized.\n");
 		set_bit(STATUS_GEO_CONFIGURED, &priv->status);
 		return 0;
 	}
@@ -501,7 +501,7 @@ int iwlcore_init_geos(struct iwl_priv *priv)
 		/* Save flags for reg domain usage */
 		geo_ch->orig_flags = geo_ch->flags;
 
-		IWL_DEBUG_INFO("Channel %d Freq=%d[%sGHz] %s flag=0x%X\n",
+		IWL_DEBUG_INFO(priv, "Channel %d Freq=%d[%sGHz] %s flag=0x%X\n",
 				ch->channel, geo_ch->center_freq,
 				is_channel_a_band(ch) ?  "5.2" : "2.4",
 				geo_ch->flags & IEEE80211_CHAN_DISABLED ?
@@ -790,7 +790,7 @@ void iwl_set_rxon_ht(struct iwl_priv *priv, struct iwl_ht_info *ht_info)
 
 	iwl_set_rxon_chain(priv);
 
-	IWL_DEBUG_ASSOC("supported HT rate 0x%X 0x%X 0x%X "
+	IWL_DEBUG_ASSOC(priv, "supported HT rate 0x%X 0x%X 0x%X "
 			"rxon flags 0x%X operation mode :0x%X "
 			"extension channel offset 0x%x\n",
 			ht_info->mcs.rx_mask[0],
@@ -936,7 +936,7 @@ void iwl_set_rxon_chain(struct iwl_priv *priv)
 	else
 		priv->staging_rxon.rx_chain &= ~RXON_RX_CHAIN_MIMO_FORCE_MSK;
 
-	IWL_DEBUG_ASSOC("rx_chain=0x%X active=%d idle=%d\n",
+	IWL_DEBUG_ASSOC(priv, "rx_chain=0x%X active=%d idle=%d\n",
 			priv->staging_rxon.rx_chain,
 			active_rx_cnt, idle_rx_cnt);
 
@@ -961,7 +961,7 @@ int iwl_set_rxon_channel(struct iwl_priv *priv, struct ieee80211_channel *ch)
 	u16 channel = ieee80211_frequency_to_channel(ch->center_freq);
 
 	if (!iwl_get_channel_info(priv, band, channel)) {
-		IWL_DEBUG_INFO("Could not set channel to %d [%d]\n",
+		IWL_DEBUG_INFO(priv, "Could not set channel to %d [%d]\n",
 			       channel, band);
 		return -EINVAL;
 	}
@@ -978,7 +978,7 @@ int iwl_set_rxon_channel(struct iwl_priv *priv, struct ieee80211_channel *ch)
 
 	priv->band = band;
 
-	IWL_DEBUG_INFO("Staging channel set to %d [%d]\n", channel, band);
+	IWL_DEBUG_INFO(priv, "Staging channel set to %d [%d]\n", channel, band);
 
 	return 0;
 }
@@ -1108,7 +1108,7 @@ void iwl_set_rate(struct iwl_priv *priv)
 			priv->active_rate |= (1 << rate->hw_value);
 	}
 
-	IWL_DEBUG_RATE("Set active_rate = %0x, active_rate_basic = %0x\n",
+	IWL_DEBUG_RATE(priv, "Set active_rate = %0x, active_rate_basic = %0x\n",
 		       priv->active_rate, priv->active_rate_basic);
 
 	/*
@@ -1140,7 +1140,7 @@ void iwl_rx_csa(struct iwl_priv *priv, struct iwl_rx_mem_buffer *rxb)
 	struct iwl_rx_packet *pkt = (struct iwl_rx_packet *)rxb->skb->data;
 	struct iwl_rxon_cmd *rxon = (void *)&priv->active_rxon;
 	struct iwl_csa_notification *csa = &(pkt->u.csa_notif);
-	IWL_DEBUG_11H("CSA notif: channel %d, status %d\n",
+	IWL_DEBUG_11H(priv, "CSA notif: channel %d, status %d\n",
 		      le16_to_cpu(csa->channel), le32_to_cpu(csa->status));
 	rxon->channel = csa->channel;
 	priv->staging_rxon.channel = csa->channel;
@@ -1152,19 +1152,19 @@ static void iwl_print_rx_config_cmd(struct iwl_priv *priv)
 {
 	struct iwl_rxon_cmd *rxon = &priv->staging_rxon;
 
-	IWL_DEBUG_RADIO("RX CONFIG:\n");
+	IWL_DEBUG_RADIO(priv, "RX CONFIG:\n");
 	iwl_print_hex_dump(priv, IWL_DL_RADIO, (u8 *) rxon, sizeof(*rxon));
-	IWL_DEBUG_RADIO("u16 channel: 0x%x\n", le16_to_cpu(rxon->channel));
-	IWL_DEBUG_RADIO("u32 flags: 0x%08X\n", le32_to_cpu(rxon->flags));
-	IWL_DEBUG_RADIO("u32 filter_flags: 0x%08x\n",
+	IWL_DEBUG_RADIO(priv, "u16 channel: 0x%x\n", le16_to_cpu(rxon->channel));
+	IWL_DEBUG_RADIO(priv, "u32 flags: 0x%08X\n", le32_to_cpu(rxon->flags));
+	IWL_DEBUG_RADIO(priv, "u32 filter_flags: 0x%08x\n",
 			le32_to_cpu(rxon->filter_flags));
-	IWL_DEBUG_RADIO("u8 dev_type: 0x%x\n", rxon->dev_type);
-	IWL_DEBUG_RADIO("u8 ofdm_basic_rates: 0x%02x\n",
+	IWL_DEBUG_RADIO(priv, "u8 dev_type: 0x%x\n", rxon->dev_type);
+	IWL_DEBUG_RADIO(priv, "u8 ofdm_basic_rates: 0x%02x\n",
 			rxon->ofdm_basic_rates);
-	IWL_DEBUG_RADIO("u8 cck_basic_rates: 0x%02x\n", rxon->cck_basic_rates);
-	IWL_DEBUG_RADIO("u8[6] node_addr: %pM\n", rxon->node_addr);
-	IWL_DEBUG_RADIO("u8[6] bssid_addr: %pM\n", rxon->bssid_addr);
-	IWL_DEBUG_RADIO("u16 assoc_id: 0x%x\n", le16_to_cpu(rxon->assoc_id));
+	IWL_DEBUG_RADIO(priv, "u8 cck_basic_rates: 0x%02x\n", rxon->cck_basic_rates);
+	IWL_DEBUG_RADIO(priv, "u8[6] node_addr: %pM\n", rxon->node_addr);
+	IWL_DEBUG_RADIO(priv, "u8[6] bssid_addr: %pM\n", rxon->bssid_addr);
+	IWL_DEBUG_RADIO(priv, "u16 assoc_id: 0x%x\n", le16_to_cpu(rxon->assoc_id));
 }
 #endif
 
@@ -1194,7 +1194,7 @@ void iwl_irq_handle_error(struct iwl_priv *priv)
 	clear_bit(STATUS_READY, &priv->status);
 
 	if (!test_bit(STATUS_EXIT_PENDING, &priv->status)) {
-		IWL_DEBUG(IWL_DL_FW_ERRORS,
+		IWL_DEBUG(priv, IWL_DL_FW_ERRORS,
 			  "Restarting adapter due to uCode error.\n");
 
 		if (iwl_is_associated(priv)) {
@@ -1216,7 +1216,7 @@ void iwl_configure_filter(struct ieee80211_hw *hw,
 	struct iwl_priv *priv = hw->priv;
 	__le32 *filter_flags = &priv->staging_rxon.filter_flags;
 
-	IWL_DEBUG_MAC80211("Enter: changed: 0x%x, total: 0x%x\n",
+	IWL_DEBUG_MAC80211(priv, "Enter: changed: 0x%x, total: 0x%x\n",
 			changed_flags, *total_flags);
 
 	if (changed_flags & (FIF_OTHER_BSS | FIF_PROMISC_IN_BSS)) {
@@ -1429,13 +1429,13 @@ void iwl_disable_interrupts(struct iwl_priv *priv)
 	 * from uCode or flow handler (Rx/Tx DMA) */
 	iwl_write32(priv, CSR_INT, 0xffffffff);
 	iwl_write32(priv, CSR_FH_INT_STATUS, 0xffffffff);
-	IWL_DEBUG_ISR("Disabled interrupts\n");
+	IWL_DEBUG_ISR(priv, "Disabled interrupts\n");
 }
 EXPORT_SYMBOL(iwl_disable_interrupts);
 
 void iwl_enable_interrupts(struct iwl_priv *priv)
 {
-	IWL_DEBUG_ISR("Enabling interrupts\n");
+	IWL_DEBUG_ISR(priv, "Enabling interrupts\n");
 	set_bit(STATUS_INT_ENABLED, &priv->status);
 	iwl_write32(priv, CSR_INT_MASK, CSR_INI_SET_MASK);
 }
@@ -1481,7 +1481,7 @@ static int iwlcore_verify_inst_sparse(struct iwl_priv *priv, __le32 *image, u32
 	u32 errcnt = 0;
 	u32 i;
 
-	IWL_DEBUG_INFO("ucode inst image size is %u\n", len);
+	IWL_DEBUG_INFO(priv, "ucode inst image size is %u\n", len);
 
 	ret = iwl_grab_nic_access(priv);
 	if (ret)
@@ -1519,7 +1519,7 @@ static int iwl_verify_inst_full(struct iwl_priv *priv, __le32 *image,
 	int ret = 0;
 	u32 errcnt;
 
-	IWL_DEBUG_INFO("ucode inst image size is %u\n", len);
+	IWL_DEBUG_INFO(priv, "ucode inst image size is %u\n", len);
 
 	ret = iwl_grab_nic_access(priv);
 	if (ret)
@@ -1548,8 +1548,8 @@ static int iwl_verify_inst_full(struct iwl_priv *priv, __le32 *image,
 	iwl_release_nic_access(priv);
 
 	if (!errcnt)
-		IWL_DEBUG_INFO
-		    ("ucode image in INSTRUCTION memory is good\n");
+		IWL_DEBUG_INFO(priv,
+		    "ucode image in INSTRUCTION memory is good\n");
 
 	return ret;
 }
@@ -1569,7 +1569,7 @@ int iwl_verify_ucode(struct iwl_priv *priv)
 	len = priv->ucode_boot.len;
 	ret = iwlcore_verify_inst_sparse(priv, image, len);
 	if (!ret) {
-		IWL_DEBUG_INFO("Bootstrap uCode is good in inst SRAM\n");
+		IWL_DEBUG_INFO(priv, "Bootstrap uCode is good in inst SRAM\n");
 		return 0;
 	}
 
@@ -1578,7 +1578,7 @@ int iwl_verify_ucode(struct iwl_priv *priv)
 	len = priv->ucode_init.len;
 	ret = iwlcore_verify_inst_sparse(priv, image, len);
 	if (!ret) {
-		IWL_DEBUG_INFO("Initialize uCode is good in inst SRAM\n");
+		IWL_DEBUG_INFO(priv, "Initialize uCode is good in inst SRAM\n");
 		return 0;
 	}
 
@@ -1587,7 +1587,7 @@ int iwl_verify_ucode(struct iwl_priv *priv)
 	len = priv->ucode_code.len;
 	ret = iwlcore_verify_inst_sparse(priv, image, len);
 	if (!ret) {
-		IWL_DEBUG_INFO("Runtime uCode is good in inst SRAM\n");
+		IWL_DEBUG_INFO(priv, "Runtime uCode is good in inst SRAM\n");
 		return 0;
 	}
 
@@ -1827,7 +1827,7 @@ void iwl_rf_kill_ct_config(struct iwl_priv *priv)
 	if (ret)
 		IWL_ERR(priv, "REPLY_CT_KILL_CONFIG_CMD failed\n");
 	else
-		IWL_DEBUG_INFO("REPLY_CT_KILL_CONFIG_CMD succeeded, "
+		IWL_DEBUG_INFO(priv, "REPLY_CT_KILL_CONFIG_CMD succeeded, "
 			"critical temperature is %d\n",
 			cmd.critical_temperature_R);
 }
@@ -1864,7 +1864,7 @@ void iwl_radio_kill_sw_disable_radio(struct iwl_priv *priv)
 	if (test_bit(STATUS_RF_KILL_SW, &priv->status))
 		return;
 
-	IWL_DEBUG_RF_KILL("Manual SW RF KILL set to: RADIO OFF\n");
+	IWL_DEBUG_RF_KILL(priv, "Manual SW RF KILL set to: RADIO OFF\n");
 
 	iwl_scan_cancel(priv);
 	/* FIXME: This is a workaround for AP */
@@ -1893,7 +1893,7 @@ int iwl_radio_kill_sw_enable_radio(struct iwl_priv *priv)
 	if (!test_bit(STATUS_RF_KILL_SW, &priv->status))
 		return 0;
 
-	IWL_DEBUG_RF_KILL("Manual SW RF KILL set to: RADIO ON\n");
+	IWL_DEBUG_RF_KILL(priv, "Manual SW RF KILL set to: RADIO ON\n");
 
 	spin_lock_irqsave(&priv->lock, flags);
 	iwl_write32(priv, CSR_UCODE_DRV_GP1_CLR, CSR_UCODE_SW_BIT_RFKILL);
@@ -1918,7 +1918,7 @@ int iwl_radio_kill_sw_enable_radio(struct iwl_priv *priv)
 	spin_unlock_irqrestore(&priv->lock, flags);
 
 	if (test_bit(STATUS_RF_KILL_HW, &priv->status)) {
-		IWL_DEBUG_RF_KILL("Can not turn radio back on - "
+		IWL_DEBUG_RF_KILL(priv, "Can not turn radio back on - "
 				  "disabled by HW switch\n");
 		return 0;
 	}
@@ -1953,7 +1953,7 @@ void iwl_bg_rf_kill(struct work_struct *work)
 	mutex_lock(&priv->mutex);
 
 	if (!iwl_is_rfkill(priv)) {
-		IWL_DEBUG(IWL_DL_RF_KILL,
+		IWL_DEBUG_RF_KILL(priv,
 			  "HW and/or SW RF Kill no longer active, restarting "
 			  "device\n");
 		if (!test_bit(STATUS_EXIT_PENDING, &priv->status) &&
@@ -1965,7 +1965,7 @@ void iwl_bg_rf_kill(struct work_struct *work)
 			ieee80211_stop_queues(priv->hw);
 
 		if (!test_bit(STATUS_RF_KILL_HW, &priv->status))
-			IWL_DEBUG_RF_KILL("Can not turn radio back on - "
+			IWL_DEBUG_RF_KILL(priv, "Can not turn radio back on - "
 					  "disabled by SW switch\n");
 		else
 			IWL_WARN(priv, "Radio Frequency Kill Switch is On:\n"
diff --git a/drivers/net/wireless/iwlwifi/iwl-debug.h b/drivers/net/wireless/iwlwifi/iwl-debug.h
index 7192d32..65d1a7f 100644
--- a/drivers/net/wireless/iwlwifi/iwl-debug.h
+++ b/drivers/net/wireless/iwlwifi/iwl-debug.h
@@ -37,18 +37,20 @@ struct iwl_priv;
 #define IWL_CRIT(p, f, a...) dev_crit(&((p)->pci_dev->dev), f, ## a)
 
 #ifdef CONFIG_IWLWIFI_DEBUG
-#define IWL_DEBUG(level, fmt, args...)					    \
-do {									    \
-	if (priv->debug_level & (level))				    \
-		dev_printk(KERN_ERR, &(priv->hw->wiphy->dev), "%c %s " fmt, \
-			   in_interrupt() ? 'I' : 'U', __func__ , ## args); \
+#define IWL_DEBUG(__priv, level, fmt, args...)				\
+do {									\
+	if (__priv->debug_level & (level))				\
+		dev_printk(KERN_ERR, &(__priv->hw->wiphy->dev),		\
+			 "%c %s " fmt, in_interrupt() ? 'I' : 'U',	\
+			__func__ , ## args);				\
 } while (0)
 
-#define IWL_DEBUG_LIMIT(level, fmt, args...)				    \
-do {									    \
-	if ((priv->debug_level & (level)) && net_ratelimit())		    \
-		dev_printk(KERN_ERR, &(priv->hw->wiphy->dev), "%c %s " fmt, \
-			   in_interrupt() ? 'I' : 'U', __func__ , ## args); \
+#define IWL_DEBUG_LIMIT(__priv, level, fmt, args...)			\
+do {									\
+	if ((__priv->debug_level & (level)) && net_ratelimit())		\
+		dev_printk(KERN_ERR, &(__priv->hw->wiphy->dev),		\
+			"%c %s " fmt, in_interrupt() ? 'I' : 'U',	\
+			 __func__ , ## args);				\
 } while (0)
 
 #define iwl_print_hex_dump(priv, level, p, len) 			\
@@ -88,8 +90,8 @@ void iwl_dbgfs_unregister(struct iwl_priv *priv);
 #endif
 
 #else
-#define IWL_DEBUG(level, fmt, args...)
-#define IWL_DEBUG_LIMIT(level, fmt, args...)
+#define IWL_DEBUG(__priv, level, fmt, args...)
+#define IWL_DEBUG_LIMIT(__priv, level, fmt, args...)
 static inline void iwl_print_hex_dump(struct iwl_priv *priv, int level,
 				      void *p, u32 len)
 {}
@@ -169,42 +171,45 @@ static inline void iwl_dbgfs_unregister(struct iwl_priv *priv)
 #define IWL_DL_TX_REPLY		(1 << 30)
 #define IWL_DL_QOS		(1 << 31)
 
-#define IWL_DEBUG_INFO(f, a...)		IWL_DEBUG(IWL_DL_INFO, f, ## a)
-#define IWL_DEBUG_MAC80211(f, a...)	IWL_DEBUG(IWL_DL_MAC80211, f, ## a)
-#define IWL_DEBUG_MACDUMP(f, a...)	IWL_DEBUG(IWL_DL_MACDUMP, f, ## a)
-#define IWL_DEBUG_TEMP(f, a...)		IWL_DEBUG(IWL_DL_TEMP, f, ## a)
-#define IWL_DEBUG_SCAN(f, a...)		IWL_DEBUG(IWL_DL_SCAN, f, ## a)
-#define IWL_DEBUG_RX(f, a...)		IWL_DEBUG(IWL_DL_RX, f, ## a)
-#define IWL_DEBUG_TX(f, a...)		IWL_DEBUG(IWL_DL_TX, f, ## a)
-#define IWL_DEBUG_ISR(f, a...)		IWL_DEBUG(IWL_DL_ISR, f, ## a)
-#define IWL_DEBUG_LED(f, a...)		IWL_DEBUG(IWL_DL_LED, f, ## a)
-#define IWL_DEBUG_WEP(f, a...)		IWL_DEBUG(IWL_DL_WEP, f, ## a)
-#define IWL_DEBUG_HC(f, a...)		IWL_DEBUG(IWL_DL_HCMD, f, ## a)
-#define IWL_DEBUG_HC_DUMP(f, a...)	IWL_DEBUG(IWL_DL_HCMD_DUMP, f, ## a)
-#define IWL_DEBUG_CALIB(f, a...)	IWL_DEBUG(IWL_DL_CALIB, f, ## a)
-#define IWL_DEBUG_FW(f, a...)		IWL_DEBUG(IWL_DL_FW, f, ## a)
-#define IWL_DEBUG_RF_KILL(f, a...)	IWL_DEBUG(IWL_DL_RF_KILL, f, ## a)
-#define IWL_DEBUG_DROP(f, a...)		IWL_DEBUG(IWL_DL_DROP, f, ## a)
-#define IWL_DEBUG_DROP_LIMIT(f, a...)	IWL_DEBUG_LIMIT(IWL_DL_DROP, f, ## a)
-#define IWL_DEBUG_AP(f, a...)		IWL_DEBUG(IWL_DL_AP, f, ## a)
-#define IWL_DEBUG_TXPOWER(f, a...)	IWL_DEBUG(IWL_DL_TXPOWER, f, ## a)
-#define IWL_DEBUG_IO(f, a...)		IWL_DEBUG(IWL_DL_IO, f, ## a)
-#define IWL_DEBUG_RATE(f, a...)		IWL_DEBUG(IWL_DL_RATE, f, ## a)
-#define IWL_DEBUG_RATE_LIMIT(f, a...)	IWL_DEBUG_LIMIT(IWL_DL_RATE, f, ## a)
-#define IWL_DEBUG_NOTIF(f, a...)	IWL_DEBUG(IWL_DL_NOTIF, f, ## a)
-#define IWL_DEBUG_ASSOC(f, a...)	\
-		IWL_DEBUG(IWL_DL_ASSOC | IWL_DL_INFO, f, ## a)
-#define IWL_DEBUG_ASSOC_LIMIT(f, a...)	\
-		IWL_DEBUG_LIMIT(IWL_DL_ASSOC | IWL_DL_INFO, f, ## a)
-#define IWL_DEBUG_HT(f, a...)		IWL_DEBUG(IWL_DL_HT, f, ## a)
-#define IWL_DEBUG_STATS(f, a...)	IWL_DEBUG(IWL_DL_STATS, f, ## a)
-#define IWL_DEBUG_STATS_LIMIT(f, a...)	IWL_DEBUG_LIMIT(IWL_DL_STATS, f, ## a)
-#define IWL_DEBUG_TX_REPLY(f, a...)	IWL_DEBUG(IWL_DL_TX_REPLY, f, ## a)
-#define IWL_DEBUG_TX_REPLY_LIMIT(f, a...) \
-		IWL_DEBUG_LIMIT(IWL_DL_TX_REPLY, f, ## a)
-#define IWL_DEBUG_QOS(f, a...)		IWL_DEBUG(IWL_DL_QOS, f, ## a)
-#define IWL_DEBUG_RADIO(f, a...)	IWL_DEBUG(IWL_DL_RADIO, f, ## a)
-#define IWL_DEBUG_POWER(f, a...)	IWL_DEBUG(IWL_DL_POWER, f, ## a)
-#define IWL_DEBUG_11H(f, a...)		IWL_DEBUG(IWL_DL_11H, f, ## a)
+#define IWL_DEBUG_INFO(p, f, a...)	IWL_DEBUG(p, IWL_DL_INFO, f, ## a)
+#define IWL_DEBUG_MAC80211(p, f, a...)	IWL_DEBUG(p, IWL_DL_MAC80211, f, ## a)
+#define IWL_DEBUG_MACDUMP(p, f, a...)	IWL_DEBUG(p, IWL_DL_MACDUMP, f, ## a)
+#define IWL_DEBUG_TEMP(p, f, a...)	IWL_DEBUG(p, IWL_DL_TEMP, f, ## a)
+#define IWL_DEBUG_SCAN(p, f, a...)	IWL_DEBUG(p, IWL_DL_SCAN, f, ## a)
+#define IWL_DEBUG_RX(p, f, a...)	IWL_DEBUG(p, IWL_DL_RX, f, ## a)
+#define IWL_DEBUG_TX(p, f, a...)	IWL_DEBUG(p, IWL_DL_TX, f, ## a)
+#define IWL_DEBUG_ISR(p, f, a...)	IWL_DEBUG(p, IWL_DL_ISR, f, ## a)
+#define IWL_DEBUG_LED(p, f, a...)	IWL_DEBUG(p, IWL_DL_LED, f, ## a)
+#define IWL_DEBUG_WEP(p, f, a...)	IWL_DEBUG(p, IWL_DL_WEP, f, ## a)
+#define IWL_DEBUG_HC(p, f, a...)	IWL_DEBUG(p, IWL_DL_HCMD, f, ## a)
+#define IWL_DEBUG_HC_DUMP(p, f, a...)	IWL_DEBUG(p, IWL_DL_HCMD_DUMP, f, ## a)
+#define IWL_DEBUG_CALIB(p, f, a...)	IWL_DEBUG(p, IWL_DL_CALIB, f, ## a)
+#define IWL_DEBUG_FW(p, f, a...)	IWL_DEBUG(p, IWL_DL_FW, f, ## a)
+#define IWL_DEBUG_RF_KILL(p, f, a...)	IWL_DEBUG(p, IWL_DL_RF_KILL, f, ## a)
+#define IWL_DEBUG_DROP(p, f, a...)	IWL_DEBUG(p, IWL_DL_DROP, f, ## a)
+#define IWL_DEBUG_DROP_LIMIT(p, f, a...)	\
+		IWL_DEBUG_LIMIT(p, IWL_DL_DROP, f, ## a)
+#define IWL_DEBUG_AP(p, f, a...)	IWL_DEBUG(p, IWL_DL_AP, f, ## a)
+#define IWL_DEBUG_TXPOWER(p, f, a...)	IWL_DEBUG(p, IWL_DL_TXPOWER, f, ## a)
+#define IWL_DEBUG_IO(p, f, a...)	IWL_DEBUG(p, IWL_DL_IO, f, ## a)
+#define IWL_DEBUG_RATE(p, f, a...)	IWL_DEBUG(p, IWL_DL_RATE, f, ## a)
+#define IWL_DEBUG_RATE_LIMIT(p, f, a...)	\
+		IWL_DEBUG_LIMIT(p, IWL_DL_RATE, f, ## a)
+#define IWL_DEBUG_NOTIF(p, f, a...)	IWL_DEBUG(p, IWL_DL_NOTIF, f, ## a)
+#define IWL_DEBUG_ASSOC(p, f, a...)	\
+		IWL_DEBUG(p, IWL_DL_ASSOC | IWL_DL_INFO, f, ## a)
+#define IWL_DEBUG_ASSOC_LIMIT(p, f, a...)	\
+		IWL_DEBUG_LIMIT(p, IWL_DL_ASSOC | IWL_DL_INFO, f, ## a)
+#define IWL_DEBUG_HT(p, f, a...)	IWL_DEBUG(p, IWL_DL_HT, f, ## a)
+#define IWL_DEBUG_STATS(p, f, a...)	IWL_DEBUG(p, IWL_DL_STATS, f, ## a)
+#define IWL_DEBUG_STATS_LIMIT(p, f, a...)	\
+		IWL_DEBUG_LIMIT(p, IWL_DL_STATS, f, ## a)
+#define IWL_DEBUG_TX_REPLY(p, f, a...)	IWL_DEBUG(p, IWL_DL_TX_REPLY, f, ## a)
+#define IWL_DEBUG_TX_REPLY_LIMIT(p, f, a...) \
+		IWL_DEBUG_LIMIT(p, IWL_DL_TX_REPLY, f, ## a)
+#define IWL_DEBUG_QOS(p, f, a...)	IWL_DEBUG(p, IWL_DL_QOS, f, ## a)
+#define IWL_DEBUG_RADIO(p, f, a...)	IWL_DEBUG(p, IWL_DL_RADIO, f, ## a)
+#define IWL_DEBUG_POWER(p, f, a...)	IWL_DEBUG(p, IWL_DL_POWER, f, ## a)
+#define IWL_DEBUG_11H(p, f, a...)	IWL_DEBUG(p, IWL_DL_11H, f, ## a)
 
 #endif
diff --git a/drivers/net/wireless/iwlwifi/iwl-eeprom.c b/drivers/net/wireless/iwlwifi/iwl-eeprom.c
index eaa658f..d1d1d9b 100644
--- a/drivers/net/wireless/iwlwifi/iwl-eeprom.c
+++ b/drivers/net/wireless/iwlwifi/iwl-eeprom.c
@@ -173,7 +173,7 @@ int iwlcore_eeprom_acquire_semaphore(struct iwl_priv *priv)
 				CSR_HW_IF_CONFIG_REG_BIT_EEPROM_OWN_SEM,
 				EEPROM_SEM_TIMEOUT);
 		if (ret >= 0) {
-			IWL_DEBUG_IO("Acquired semaphore after %d tries.\n",
+			IWL_DEBUG_IO(priv, "Acquired semaphore after %d tries.\n",
 				count+1);
 			return ret;
 		}
@@ -390,7 +390,7 @@ static int iwl_set_fat_chan_info(struct iwl_priv *priv,
 	if (!is_channel_valid(ch_info))
 		return -1;
 
-	IWL_DEBUG_INFO("FAT Ch. %d [%sGHz] %s%s%s%s%s(0x%02x %ddBm):"
+	IWL_DEBUG_INFO(priv, "FAT Ch. %d [%sGHz] %s%s%s%s%s(0x%02x %ddBm):"
 			" Ad-Hoc %ssupported\n",
 			ch_info->channel,
 			is_channel_a_band(ch_info) ?
@@ -432,11 +432,11 @@ int iwl_init_channel_map(struct iwl_priv *priv)
 	struct iwl_channel_info *ch_info;
 
 	if (priv->channel_count) {
-		IWL_DEBUG_INFO("Channel map already initialized.\n");
+		IWL_DEBUG_INFO(priv, "Channel map already initialized.\n");
 		return 0;
 	}
 
-	IWL_DEBUG_INFO("Initializing regulatory info from EEPROM\n");
+	IWL_DEBUG_INFO(priv, "Initializing regulatory info from EEPROM\n");
 
 	priv->channel_count =
 	    ARRAY_SIZE(iwl_eeprom_band_1) +
@@ -445,7 +445,7 @@ int iwl_init_channel_map(struct iwl_priv *priv)
 	    ARRAY_SIZE(iwl_eeprom_band_4) +
 	    ARRAY_SIZE(iwl_eeprom_band_5);
 
-	IWL_DEBUG_INFO("Parsing data for %d channels.\n", priv->channel_count);
+	IWL_DEBUG_INFO(priv, "Parsing data for %d channels.\n", priv->channel_count);
 
 	priv->channel_info = kzalloc(sizeof(struct iwl_channel_info) *
 				     priv->channel_count, GFP_KERNEL);
@@ -485,7 +485,7 @@ int iwl_init_channel_map(struct iwl_priv *priv)
 				 IEEE80211_CHAN_NO_FAT_BELOW);
 
 			if (!(is_channel_valid(ch_info))) {
-				IWL_DEBUG_INFO("Ch. %d Flags %x [%sGHz] - "
+				IWL_DEBUG_INFO(priv, "Ch. %d Flags %x [%sGHz] - "
 					       "No traffic\n",
 					       ch_info->channel,
 					       ch_info->flags,
@@ -501,7 +501,7 @@ int iwl_init_channel_map(struct iwl_priv *priv)
 			ch_info->scan_power = eeprom_ch_info[ch].max_power_avg;
 			ch_info->min_power = 0;
 
-			IWL_DEBUG_INFO("Ch. %d [%sGHz] %s%s%s%s%s%s(0x%02x %ddBm):"
+			IWL_DEBUG_INFO(priv, "Ch. %d [%sGHz] %s%s%s%s%s%s(0x%02x %ddBm):"
 				       " Ad-Hoc %ssupported\n",
 				       ch_info->channel,
 				       is_channel_a_band(ch_info) ?
diff --git a/drivers/net/wireless/iwlwifi/iwl-hcmd.c b/drivers/net/wireless/iwlwifi/iwl-hcmd.c
index 65ae2af..17d61ac 100644
--- a/drivers/net/wireless/iwlwifi/iwl-hcmd.c
+++ b/drivers/net/wireless/iwlwifi/iwl-hcmd.c
@@ -125,11 +125,11 @@ static int iwl_generic_cmd_callback(struct iwl_priv *priv,
 	switch (cmd->hdr.cmd) {
 	case REPLY_TX_LINK_QUALITY_CMD:
 	case SENSITIVITY_CMD:
-		IWL_DEBUG_HC_DUMP("back from %s (0x%08X)\n",
+		IWL_DEBUG_HC_DUMP(priv, "back from %s (0x%08X)\n",
 				get_cmd_string(cmd->hdr.cmd), pkt->hdr.flags);
 				break;
 	default:
-		IWL_DEBUG_HC("back from %s (0x%08X)\n",
+		IWL_DEBUG_HC(priv, "back from %s (0x%08X)\n",
 				get_cmd_string(cmd->hdr.cmd), pkt->hdr.flags);
 	}
 #endif
@@ -211,13 +211,13 @@ int iwl_send_cmd_sync(struct iwl_priv *priv, struct iwl_host_cmd *cmd)
 	}
 
 	if (test_bit(STATUS_RF_KILL_HW, &priv->status)) {
-		IWL_DEBUG_INFO("Command %s aborted: RF KILL Switch\n",
+		IWL_DEBUG_INFO(priv, "Command %s aborted: RF KILL Switch\n",
 			       get_cmd_string(cmd->id));
 		ret = -ECANCELED;
 		goto fail;
 	}
 	if (test_bit(STATUS_FW_ERROR, &priv->status)) {
-		IWL_DEBUG_INFO("Command %s failed: FW Error\n",
+		IWL_DEBUG_INFO(priv, "Command %s failed: FW Error\n",
 			       get_cmd_string(cmd->id));
 		ret = -EIO;
 		goto fail;
diff --git a/drivers/net/wireless/iwlwifi/iwl-io.h b/drivers/net/wireless/iwlwifi/iwl-io.h
index 7341a2d..c7b8e5b 100644
--- a/drivers/net/wireless/iwlwifi/iwl-io.h
+++ b/drivers/net/wireless/iwlwifi/iwl-io.h
@@ -66,7 +66,7 @@
 static inline void __iwl_write32(const char *f, u32 l, struct iwl_priv *priv,
 				 u32 ofs, u32 val)
 {
-	IWL_DEBUG_IO("write32(0x%08X, 0x%08X) - %s %d\n", ofs, val, f, l);
+	IWL_DEBUG_IO(priv, "write32(0x%08X, 0x%08X) - %s %d\n", ofs, val, f, l);
 	_iwl_write32(priv, ofs, val);
 }
 #define iwl_write32(priv, ofs, val) \
@@ -79,7 +79,7 @@ static inline void __iwl_write32(const char *f, u32 l, struct iwl_priv *priv,
 #ifdef CONFIG_IWLWIFI_DEBUG
 static inline u32 __iwl_read32(char *f, u32 l, struct iwl_priv *priv, u32 ofs)
 {
-	IWL_DEBUG_IO("read_direct32(0x%08X) - %s %d\n", ofs, f, l);
+	IWL_DEBUG_IO(priv, "read_direct32(0x%08X) - %s %d\n", ofs, f, l);
 	return _iwl_read32(priv, ofs);
 }
 #define iwl_read32(priv, ofs) __iwl_read32(__FILE__, __LINE__, priv, ofs)
@@ -108,7 +108,7 @@ static inline int __iwl_poll_bit(const char *f, u32 l,
 				 u32 bits, u32 mask, int timeout)
 {
 	int ret = _iwl_poll_bit(priv, addr, bits, mask, timeout);
-	IWL_DEBUG_IO("poll_bit(0x%08X, 0x%08X, 0x%08X) - %s- %s %d\n",
+	IWL_DEBUG_IO(priv, "poll_bit(0x%08X, 0x%08X, 0x%08X) - %s- %s %d\n",
 		     addr, bits, mask,
 		     unlikely(ret  == -ETIMEDOUT) ? "timeout" : "", f, l);
 	return ret;
@@ -128,7 +128,7 @@ static inline void __iwl_set_bit(const char *f, u32 l,
 				 struct iwl_priv *priv, u32 reg, u32 mask)
 {
 	u32 val = _iwl_read32(priv, reg) | mask;
-	IWL_DEBUG_IO("set_bit(0x%08X, 0x%08X) = 0x%08X\n", reg, mask, val);
+	IWL_DEBUG_IO(priv, "set_bit(0x%08X, 0x%08X) = 0x%08X\n", reg, mask, val);
 	_iwl_write32(priv, reg, val);
 }
 #define iwl_set_bit(p, r, m) __iwl_set_bit(__FILE__, __LINE__, p, r, m)
@@ -145,7 +145,7 @@ static inline void __iwl_clear_bit(const char *f, u32 l,
 				   struct iwl_priv *priv, u32 reg, u32 mask)
 {
 	u32 val = _iwl_read32(priv, reg) & ~mask;
-	IWL_DEBUG_IO("clear_bit(0x%08X, 0x%08X) = 0x%08X\n", reg, mask, val);
+	IWL_DEBUG_IO(priv, "clear_bit(0x%08X, 0x%08X) = 0x%08X\n", reg, mask, val);
 	_iwl_write32(priv, reg, val);
 }
 #define iwl_clear_bit(p, r, m) __iwl_clear_bit(__FILE__, __LINE__, p, r, m)
@@ -184,7 +184,7 @@ static inline int __iwl_grab_nic_access(const char *f, u32 l,
 	if (atomic_read(&priv->restrict_refcnt))
 		IWL_ERR(priv, "Grabbing access while already held %s %d.\n", f, l);
 
-	IWL_DEBUG_IO("grabbing nic access - %s %d\n", f, l);
+	IWL_DEBUG_IO(priv, "grabbing nic access - %s %d\n", f, l);
 	return _iwl_grab_nic_access(priv);
 }
 #define iwl_grab_nic_access(priv) \
@@ -209,7 +209,7 @@ static inline void __iwl_release_nic_access(const char *f, u32 l,
 	if (atomic_read(&priv->restrict_refcnt) <= 0)
 		IWL_ERR(priv, "Release unheld nic access at line %s %d.\n", f, l);
 
-	IWL_DEBUG_IO("releasing nic access - %s %d\n", f, l);
+	IWL_DEBUG_IO(priv, "releasing nic access - %s %d\n", f, l);
 	_iwl_release_nic_access(priv);
 }
 #define iwl_release_nic_access(priv) \
@@ -230,7 +230,7 @@ static inline u32 __iwl_read_direct32(const char *f, u32 l,
 	u32 value = _iwl_read_direct32(priv, reg);
 	if (!atomic_read(&priv->restrict_refcnt))
 		IWL_ERR(priv, "Nic access not held from %s %d\n", f, l);
-	IWL_DEBUG_IO("read_direct32(0x%4X) = 0x%08x - %s %d \n", reg, value,
+	IWL_DEBUG_IO(priv, "read_direct32(0x%4X) = 0x%08x - %s %d \n", reg, value,
 		     f, l);
 	return value;
 }
@@ -284,10 +284,10 @@ static inline int __iwl_poll_direct_bit(const char *f, u32 l,
 	int ret  = _iwl_poll_direct_bit(priv, addr, mask, timeout);
 
 	if (unlikely(ret == -ETIMEDOUT))
-		IWL_DEBUG_IO("poll_direct_bit(0x%08X, 0x%08X) - "
+		IWL_DEBUG_IO(priv, "poll_direct_bit(0x%08X, 0x%08X) - "
 			     "timedout - %s %d\n", addr, mask, f, l);
 	else
-		IWL_DEBUG_IO("poll_direct_bit(0x%08X, 0x%08X) = 0x%08X "
+		IWL_DEBUG_IO(priv, "poll_direct_bit(0x%08X, 0x%08X) = 0x%08X "
 			     "- %s %d\n", addr, mask, ret, f, l);
 	return ret;
 }
diff --git a/drivers/net/wireless/iwlwifi/iwl-led.c b/drivers/net/wireless/iwlwifi/iwl-led.c
index 501cffe..63d669e 100644
--- a/drivers/net/wireless/iwlwifi/iwl-led.c
+++ b/drivers/net/wireless/iwlwifi/iwl-led.c
@@ -123,7 +123,7 @@ static int iwl4965_led_pattern(struct iwl_priv *priv, int led_id,
 /* Set led register off */
 static int iwl4965_led_on_reg(struct iwl_priv *priv, int led_id)
 {
-	IWL_DEBUG_LED("led on %d\n", led_id);
+	IWL_DEBUG_LED(priv, "led on %d\n", led_id);
 	iwl_write32(priv, CSR_LED_REG, CSR_LED_REG_TRUN_ON);
 	return 0;
 }
@@ -150,7 +150,7 @@ int iwl4965_led_off(struct iwl_priv *priv, int led_id)
 		.off = 0,
 		.interval = IWL_DEF_LED_INTRVL
 	};
-	IWL_DEBUG_LED("led off %d\n", led_id);
+	IWL_DEBUG_LED(priv, "led off %d\n", led_id);
 	return iwl_send_led_cmd(priv, &led_cmd);
 }
 #endif
@@ -159,7 +159,7 @@ int iwl4965_led_off(struct iwl_priv *priv, int led_id)
 /* Set led register off */
 static int iwl4965_led_off_reg(struct iwl_priv *priv, int led_id)
 {
-	IWL_DEBUG_LED("LED Reg off\n");
+	IWL_DEBUG_LED(priv, "LED Reg off\n");
 	iwl_write32(priv, CSR_LED_REG, CSR_LED_REG_TRUN_OFF);
 	return 0;
 }
@@ -169,7 +169,7 @@ static int iwl4965_led_off_reg(struct iwl_priv *priv, int led_id)
  */
 static int iwl_led_associate(struct iwl_priv *priv, int led_id)
 {
-	IWL_DEBUG_LED("Associated\n");
+	IWL_DEBUG_LED(priv, "Associated\n");
 	priv->allow_blinking = 1;
 	return iwl4965_led_on_reg(priv, led_id);
 }
@@ -213,7 +213,7 @@ static void iwl_led_brightness_set(struct led_classdev *led_cdev,
 		return;
 
 
-	IWL_DEBUG_LED("Led type = %s brightness = %d\n",
+	IWL_DEBUG_LED(priv, "Led type = %s brightness = %d\n",
 			led_type_str[led->type], brightness);
 	switch (brightness) {
 	case LED_FULL:
@@ -280,7 +280,7 @@ static int iwl_get_blink_rate(struct iwl_priv *priv)
 	if (tpt < 0) /* wraparound */
 		tpt = -tpt;
 
-	IWL_DEBUG_LED("tpt %lld current_tpt %llu\n",
+	IWL_DEBUG_LED(priv, "tpt %lld current_tpt %llu\n",
 		(long long)tpt,
 		(unsigned long long)current_tpt);
 	priv->led_tpt = current_tpt;
@@ -292,7 +292,7 @@ static int iwl_get_blink_rate(struct iwl_priv *priv)
 			if (tpt  > (blink_tbl[i].tpt * IWL_1MB_RATE))
 				break;
 
-	IWL_DEBUG_LED("LED BLINK IDX=%d\n", i);
+	IWL_DEBUG_LED(priv, "LED BLINK IDX=%d\n", i);
 	return i;
 }
 
diff --git a/drivers/net/wireless/iwlwifi/iwl-power.c b/drivers/net/wireless/iwlwifi/iwl-power.c
index a463459..abe0d29 100644
--- a/drivers/net/wireless/iwlwifi/iwl-power.c
+++ b/drivers/net/wireless/iwlwifi/iwl-power.c
@@ -149,7 +149,7 @@ static void iwl_power_init_handle(struct iwl_priv *priv)
 	int i;
 	u16 pci_pm;
 
-	IWL_DEBUG_POWER("Initialize power \n");
+	IWL_DEBUG_POWER(priv, "Initialize power \n");
 
 	pow_data = &priv->power_data;
 
@@ -161,7 +161,7 @@ static void iwl_power_init_handle(struct iwl_priv *priv)
 
 	pci_read_config_word(priv->pci_dev, PCI_CFG_LINK_CTRL, &pci_pm);
 
-	IWL_DEBUG_POWER("adjust power command flags\n");
+	IWL_DEBUG_POWER(priv, "adjust power command flags\n");
 
 	for (i = 0; i < IWL_POWER_MAX; i++) {
 		cmd = &pow_data->pwr_range_0[i].cmd;
@@ -185,7 +185,7 @@ static int iwl_update_power_cmd(struct iwl_priv *priv,
 	bool skip;
 
 	if (mode > IWL_POWER_INDEX_5) {
-		IWL_DEBUG_POWER("Error invalid power mode \n");
+		IWL_DEBUG_POWER(priv, "Error invalid power mode \n");
 		return -EINVAL;
 	}
 
@@ -225,10 +225,10 @@ static int iwl_update_power_cmd(struct iwl_priv *priv,
 		if (le32_to_cpu(cmd->sleep_interval[i]) > max_sleep)
 			cmd->sleep_interval[i] = cpu_to_le32(max_sleep);
 
-	IWL_DEBUG_POWER("Flags value = 0x%08X\n", cmd->flags);
-	IWL_DEBUG_POWER("Tx timeout = %u\n", le32_to_cpu(cmd->tx_data_timeout));
-	IWL_DEBUG_POWER("Rx timeout = %u\n", le32_to_cpu(cmd->rx_data_timeout));
-	IWL_DEBUG_POWER("Sleep interval vector = { %d , %d , %d , %d , %d }\n",
+	IWL_DEBUG_POWER(priv, "Flags value = 0x%08X\n", cmd->flags);
+	IWL_DEBUG_POWER(priv, "Tx timeout = %u\n", le32_to_cpu(cmd->tx_data_timeout));
+	IWL_DEBUG_POWER(priv, "Rx timeout = %u\n", le32_to_cpu(cmd->rx_data_timeout));
+	IWL_DEBUG_POWER(priv, "Sleep interval vector = { %d , %d , %d , %d , %d }\n",
 			le32_to_cpu(cmd->sleep_interval[0]),
 			le32_to_cpu(cmd->sleep_interval[1]),
 			le32_to_cpu(cmd->sleep_interval[2]),
@@ -302,7 +302,7 @@ int iwl_power_update_mode(struct iwl_priv *priv, bool force)
 		if (priv->cfg->ops->lib->update_chain_flags && update_chains)
 			priv->cfg->ops->lib->update_chain_flags(priv);
 		else
-			IWL_DEBUG_POWER("Cannot update the power, chain noise "
+			IWL_DEBUG_POWER(priv, "Cannot update the power, chain noise "
 					"calibration running: %d\n",
 					priv->chain_noise_data.state);
 		if (!ret)
@@ -423,7 +423,7 @@ static void iwl_bg_set_power_save(struct work_struct *work)
 {
 	struct iwl_priv *priv = container_of(work,
 				struct iwl_priv, set_power_save.work);
-	IWL_DEBUG(IWL_DL_STATE, "update power\n");
+	IWL_DEBUG_POWER(priv, "update power\n");
 
 	if (test_bit(STATUS_EXIT_PENDING, &priv->status))
 		return;
diff --git a/drivers/net/wireless/iwlwifi/iwl-rfkill.c b/drivers/net/wireless/iwlwifi/iwl-rfkill.c
index f67d7be..2ad9faf 100644
--- a/drivers/net/wireless/iwlwifi/iwl-rfkill.c
+++ b/drivers/net/wireless/iwlwifi/iwl-rfkill.c
@@ -47,7 +47,7 @@ static int iwl_rfkill_soft_rf_kill(void *data, enum rfkill_state state)
 	if (test_bit(STATUS_EXIT_PENDING, &priv->status))
 		return 0;
 
-	IWL_DEBUG_RF_KILL("we received soft RFKILL set to state %d\n", state);
+	IWL_DEBUG_RF_KILL(priv, "we received soft RFKILL set to state %d\n", state);
 	mutex_lock(&priv->mutex);
 
 	switch (state) {
@@ -79,7 +79,7 @@ int iwl_rfkill_init(struct iwl_priv *priv)
 
 	BUG_ON(device == NULL);
 
-	IWL_DEBUG_RF_KILL("Initializing RFKILL.\n");
+	IWL_DEBUG_RF_KILL(priv, "Initializing RFKILL.\n");
 	priv->rfkill = rfkill_allocate(device, RFKILL_TYPE_WLAN);
 	if (!priv->rfkill) {
 		IWL_ERR(priv, "Unable to allocate RFKILL device.\n");
@@ -102,7 +102,7 @@ int iwl_rfkill_init(struct iwl_priv *priv)
 		goto free_rfkill;
 	}
 
-	IWL_DEBUG_RF_KILL("RFKILL initialization complete.\n");
+	IWL_DEBUG_RF_KILL(priv, "RFKILL initialization complete.\n");
 	return ret;
 
 free_rfkill:
@@ -111,7 +111,7 @@ free_rfkill:
 	priv->rfkill = NULL;
 
 error:
-	IWL_DEBUG_RF_KILL("RFKILL initialization complete.\n");
+	IWL_DEBUG_RF_KILL(priv, "RFKILL initialization complete.\n");
 	return ret;
 }
 EXPORT_SYMBOL(iwl_rfkill_init);
diff --git a/drivers/net/wireless/iwlwifi/iwl-rx.c b/drivers/net/wireless/iwlwifi/iwl-rx.c
index c8865d0..8f65908 100644
--- a/drivers/net/wireless/iwlwifi/iwl-rx.c
+++ b/drivers/net/wireless/iwlwifi/iwl-rx.c
@@ -494,7 +494,7 @@ void iwl_rx_missed_beacon_notif(struct iwl_priv *priv,
 
 	missed_beacon = &pkt->u.missed_beacon;
 	if (le32_to_cpu(missed_beacon->consequtive_missed_beacons) > 5) {
-		IWL_DEBUG_CALIB("missed bcn cnsq %d totl %d rcd %d expctd %d\n",
+		IWL_DEBUG_CALIB(priv, "missed bcn cnsq %d totl %d rcd %d expctd %d\n",
 		    le32_to_cpu(missed_beacon->consequtive_missed_beacons),
 		    le32_to_cpu(missed_beacon->total_missed_becons),
 		    le32_to_cpu(missed_beacon->num_recvd_beacons),
@@ -541,7 +541,7 @@ static void iwl_rx_calc_noise(struct iwl_priv *priv)
 	else
 		priv->last_rx_noise = IWL_NOISE_MEAS_NOT_AVAILABLE;
 
-	IWL_DEBUG_CALIB("inband silence a %u, b %u, c %u, dBm %d\n",
+	IWL_DEBUG_CALIB(priv, "inband silence a %u, b %u, c %u, dBm %d\n",
 			bcn_silence_a, bcn_silence_b, bcn_silence_c,
 			priv->last_rx_noise);
 }
@@ -554,7 +554,7 @@ void iwl_rx_statistics(struct iwl_priv *priv,
 	int change;
 	struct iwl_rx_packet *pkt = (struct iwl_rx_packet *)rxb->skb->data;
 
-	IWL_DEBUG_RX("Statistics notification received (%d vs %d).\n",
+	IWL_DEBUG_RX(priv, "Statistics notification received (%d vs %d).\n",
 		     (int)sizeof(priv->statistics), pkt->len);
 
 	change = ((priv->statistics.general.temperature !=
@@ -741,13 +741,13 @@ static void iwl_dbg_report_frame(struct iwl_priv *priv,
 		 * MAC addresses show just the last byte (for brevity),
 		 *    but you can hack it to show more, if you'd like to. */
 		if (dataframe)
-			IWL_DEBUG_RX("%s: mhd=0x%04x, dst=0x%02x, "
+			IWL_DEBUG_RX(priv, "%s: mhd=0x%04x, dst=0x%02x, "
 				     "len=%u, rssi=%d, chnl=%d, rate=%u, \n",
 				     title, le16_to_cpu(fc), header->addr1[5],
 				     length, rssi, channel, bitrate);
 		else {
 			/* src/dst addresses assume managed mode */
-			IWL_DEBUG_RX("%s: 0x%04x, dst=0x%02x, src=0x%02x, "
+			IWL_DEBUG_RX(priv, "%s: 0x%04x, dst=0x%02x, src=0x%02x, "
 				     "len=%u, rssi=%d, tim=%lu usec, "
 				     "phy=0x%02x, chnl=%d\n",
 				     title, le16_to_cpu(fc), header->addr1[5],
@@ -785,7 +785,7 @@ int iwl_set_decrypted_flag(struct iwl_priv *priv,
 	if (!(fc & IEEE80211_FCTL_PROTECTED))
 		return 0;
 
-	IWL_DEBUG_RX("decrypt_res:0x%x\n", decrypt_res);
+	IWL_DEBUG_RX(priv, "decrypt_res:0x%x\n", decrypt_res);
 	switch (decrypt_res & RX_RES_STATUS_SEC_TYPE_MSK) {
 	case RX_RES_STATUS_SEC_TYPE_TKIP:
 		/* The uCode has got a bad phase 1 Key, pushes the packet.
@@ -799,13 +799,13 @@ int iwl_set_decrypted_flag(struct iwl_priv *priv,
 		    RX_RES_STATUS_BAD_ICV_MIC) {
 			/* bad ICV, the packet is destroyed since the
 			 * decryption is inplace, drop it */
-			IWL_DEBUG_RX("Packet destroyed\n");
+			IWL_DEBUG_RX(priv, "Packet destroyed\n");
 			return -1;
 		}
 	case RX_RES_STATUS_SEC_TYPE_CCMP:
 		if ((decrypt_res & RX_RES_STATUS_DECRYPT_TYPE_MSK) ==
 		    RX_RES_STATUS_DECRYPT_OK) {
-			IWL_DEBUG_RX("hw decrypt successfully!!!\n");
+			IWL_DEBUG_RX(priv, "hw decrypt successfully!!!\n");
 			stats->flag |= RX_FLAG_DECRYPTED;
 		}
 		break;
@@ -870,7 +870,7 @@ static u32 iwl_translate_rx_status(struct iwl_priv *priv, u32 decrypt_in)
 		break;
 	};
 
-	IWL_DEBUG_RX("decrypt_in:0x%x  decrypt_out = 0x%x\n",
+	IWL_DEBUG_RX(priv, "decrypt_in:0x%x  decrypt_out = 0x%x\n",
 					decrypt_in, decrypt_out);
 
 	return decrypt_out;
@@ -934,8 +934,8 @@ static void iwl_pass_packet_to_mac80211(struct iwl_priv *priv,
 
 	/* We only process data packets if the interface is open */
 	if (unlikely(!priv->is_open)) {
-		IWL_DEBUG_DROP_LIMIT
-		    ("Dropping packet while interface is not open.\n");
+		IWL_DEBUG_DROP_LIMIT(priv,
+		    "Dropping packet while interface is not open.\n");
 		return;
 	}
 
@@ -1007,7 +1007,7 @@ void iwl_rx_reply_rx(struct iwl_priv *priv,
 	/*rx_status.flag |= RX_FLAG_TSFT;*/
 
 	if ((unlikely(rx_start->cfg_phy_cnt > 20))) {
-		IWL_DEBUG_DROP("dsp size out of range [0,20]: %d/n",
+		IWL_DEBUG_DROP(priv, "dsp size out of range [0,20]: %d/n",
 				rx_start->cfg_phy_cnt);
 		return;
 	}
@@ -1045,7 +1045,7 @@ void iwl_rx_reply_rx(struct iwl_priv *priv,
 
 	if (!(*rx_end & RX_RES_STATUS_NO_CRC32_ERROR) ||
 	    !(*rx_end & RX_RES_STATUS_NO_RXE_OVERFLOW)) {
-		IWL_DEBUG_RX("Bad CRC or FIFO: 0x%08X.\n",
+		IWL_DEBUG_RX(priv, "Bad CRC or FIFO: 0x%08X.\n",
 				le32_to_cpu(*rx_end));
 		return;
 	}
@@ -1078,7 +1078,7 @@ void iwl_rx_reply_rx(struct iwl_priv *priv,
 	if (unlikely(priv->debug_level & IWL_DL_RX))
 		iwl_dbg_report_frame(priv, rx_start, len, header, 1);
 #endif
-	IWL_DEBUG_STATS_LIMIT("Rssi %d, noise %d, qual %d, TSF %llu\n",
+	IWL_DEBUG_STATS_LIMIT(priv, "Rssi %d, noise %d, qual %d, TSF %llu\n",
 		rx_status.signal, rx_status.noise, rx_status.signal,
 		(unsigned long long)rx_status.mactime);
 
diff --git a/drivers/net/wireless/iwlwifi/iwl-scan.c b/drivers/net/wireless/iwlwifi/iwl-scan.c
index c282d1d..22bad3c 100644
--- a/drivers/net/wireless/iwlwifi/iwl-scan.c
+++ b/drivers/net/wireless/iwlwifi/iwl-scan.c
@@ -70,12 +70,12 @@ int iwl_scan_cancel(struct iwl_priv *priv)
 
 	if (test_bit(STATUS_SCANNING, &priv->status)) {
 		if (!test_bit(STATUS_SCAN_ABORTING, &priv->status)) {
-			IWL_DEBUG_SCAN("Queuing scan abort.\n");
+			IWL_DEBUG_SCAN(priv, "Queuing scan abort.\n");
 			set_bit(STATUS_SCAN_ABORTING, &priv->status);
 			queue_work(priv->workqueue, &priv->abort_scan);
 
 		} else
-			IWL_DEBUG_SCAN("Scan abort already in progress.\n");
+			IWL_DEBUG_SCAN(priv, "Scan abort already in progress.\n");
 
 		return test_bit(STATUS_SCANNING, &priv->status);
 	}
@@ -140,7 +140,7 @@ int iwl_send_scan_abort(struct iwl_priv *priv)
 		 * can occur if we send the scan abort before we
 		 * the microcode has notified us that a scan is
 		 * completed. */
-		IWL_DEBUG_INFO("SCAN_ABORT returned %d.\n", res->u.status);
+		IWL_DEBUG_INFO(priv, "SCAN_ABORT returned %d.\n", res->u.status);
 		clear_bit(STATUS_SCAN_ABORTING, &priv->status);
 		clear_bit(STATUS_SCAN_HW, &priv->status);
 	}
@@ -161,7 +161,7 @@ static void iwl_rx_reply_scan(struct iwl_priv *priv,
 	struct iwl_scanreq_notification *notif =
 	    (struct iwl_scanreq_notification *)pkt->u.raw;
 
-	IWL_DEBUG_RX("Scan request status = 0x%x\n", notif->status);
+	IWL_DEBUG_RX(priv, "Scan request status = 0x%x\n", notif->status);
 #endif
 }
 
@@ -173,7 +173,7 @@ static void iwl_rx_scan_start_notif(struct iwl_priv *priv,
 	struct iwl_scanstart_notification *notif =
 	    (struct iwl_scanstart_notification *)pkt->u.raw;
 	priv->scan_start_tsf = le32_to_cpu(notif->tsf_low);
-	IWL_DEBUG_SCAN("Scan start: "
+	IWL_DEBUG_SCAN(priv, "Scan start: "
 		       "%d [802.11%s] "
 		       "(TSF: 0x%08X:%08X) - %d (beacon timer %u)\n",
 		       notif->channel,
@@ -192,7 +192,7 @@ static void iwl_rx_scan_results_notif(struct iwl_priv *priv,
 	struct iwl_scanresults_notification *notif =
 	    (struct iwl_scanresults_notification *)pkt->u.raw;
 
-	IWL_DEBUG_SCAN("Scan ch.res: "
+	IWL_DEBUG_SCAN(priv, "Scan ch.res: "
 		       "%d [802.11%s] "
 		       "(TSF: 0x%08X:%08X) - %d "
 		       "elapsed=%lu usec (%dms since last)\n",
@@ -218,7 +218,7 @@ static void iwl_rx_scan_complete_notif(struct iwl_priv *priv,
 	struct iwl_rx_packet *pkt = (struct iwl_rx_packet *)rxb->skb->data;
 	struct iwl_scancomplete_notification *scan_notif = (void *)pkt->u.raw;
 
-	IWL_DEBUG_SCAN("Scan complete: %d channels (TSF 0x%08X:%08X) - %d\n",
+	IWL_DEBUG_SCAN(priv, "Scan complete: %d channels (TSF 0x%08X:%08X) - %d\n",
 		       scan_notif->scanned_channels,
 		       scan_notif->tsf_low,
 		       scan_notif->tsf_high, scan_notif->status);
@@ -230,7 +230,7 @@ static void iwl_rx_scan_complete_notif(struct iwl_priv *priv,
 	/* The scan completion notification came in, so kill that timer... */
 	cancel_delayed_work(&priv->scan_check);
 
-	IWL_DEBUG_INFO("Scan pass on %sGHz took %dms\n",
+	IWL_DEBUG_INFO(priv, "Scan pass on %sGHz took %dms\n",
 		       (priv->scan_bands & BIT(IEEE80211_BAND_2GHZ)) ?
 						"2.4" : "5.2",
 		       jiffies_to_msecs(elapsed_jiffies
@@ -248,7 +248,7 @@ static void iwl_rx_scan_complete_notif(struct iwl_priv *priv,
 	 * then we reset the scan state machine and terminate,
 	 * re-queuing another scan if one has been requested */
 	if (test_bit(STATUS_SCAN_ABORTING, &priv->status)) {
-		IWL_DEBUG_INFO("Aborted scan completed.\n");
+		IWL_DEBUG_INFO(priv, "Aborted scan completed.\n");
 		clear_bit(STATUS_SCAN_ABORTING, &priv->status);
 	} else {
 		/* If there are more bands on this scan pass reschedule */
@@ -258,11 +258,11 @@ static void iwl_rx_scan_complete_notif(struct iwl_priv *priv,
 
 	priv->last_scan_jiffies = jiffies;
 	priv->next_scan_jiffies = 0;
-	IWL_DEBUG_INFO("Setting scan to off\n");
+	IWL_DEBUG_INFO(priv, "Setting scan to off\n");
 
 	clear_bit(STATUS_SCANNING, &priv->status);
 
-	IWL_DEBUG_INFO("Scan took %dms\n",
+	IWL_DEBUG_INFO(priv, "Scan took %dms\n",
 		jiffies_to_msecs(elapsed_jiffies(priv->scan_start, jiffies)));
 
 	queue_work(priv->workqueue, &priv->scan_completed);
@@ -355,7 +355,7 @@ static int iwl_get_channels_for_scan(struct iwl_priv *priv,
 
 		ch_info = iwl_get_channel_info(priv, band, channel);
 		if (!is_channel_valid(ch_info)) {
-			IWL_DEBUG_SCAN("Channel %d is INVALID for this band.\n",
+			IWL_DEBUG_SCAN(priv, "Channel %d is INVALID for this band.\n",
 					channel);
 			continue;
 		}
@@ -384,7 +384,7 @@ static int iwl_get_channels_for_scan(struct iwl_priv *priv,
 		else
 			scan_ch->tx_gain = ((1 << 5) | (5 << 3));
 
-		IWL_DEBUG_SCAN("Scanning ch=%d prob=0x%X [%s %d]\n",
+		IWL_DEBUG_SCAN(priv, "Scanning ch=%d prob=0x%X [%s %d]\n",
 			       channel, le32_to_cpu(scan_ch->type),
 			       (scan_ch->type & SCAN_CHANNEL_TYPE_ACTIVE) ?
 				"ACTIVE" : "PASSIVE",
@@ -395,7 +395,7 @@ static int iwl_get_channels_for_scan(struct iwl_priv *priv,
 		added++;
 	}
 
-	IWL_DEBUG_SCAN("total channels to scan %d \n", added);
+	IWL_DEBUG_SCAN(priv, "total channels to scan %d \n", added);
 	return added;
 }
 
@@ -411,21 +411,21 @@ void iwl_init_scan_params(struct iwl_priv *priv)
 int iwl_scan_initiate(struct iwl_priv *priv)
 {
 	if (!iwl_is_ready_rf(priv)) {
-		IWL_DEBUG_SCAN("Aborting scan due to not ready.\n");
+		IWL_DEBUG_SCAN(priv, "Aborting scan due to not ready.\n");
 		return -EIO;
 	}
 
 	if (test_bit(STATUS_SCANNING, &priv->status)) {
-		IWL_DEBUG_SCAN("Scan already in progress.\n");
+		IWL_DEBUG_SCAN(priv, "Scan already in progress.\n");
 		return -EAGAIN;
 	}
 
 	if (test_bit(STATUS_SCAN_ABORTING, &priv->status)) {
-		IWL_DEBUG_SCAN("Scan request while abort pending\n");
+		IWL_DEBUG_SCAN(priv, "Scan request while abort pending\n");
 		return -EAGAIN;
 	}
 
-	IWL_DEBUG_INFO("Starting scan...\n");
+	IWL_DEBUG_INFO(priv, "Starting scan...\n");
 	if (priv->cfg->sku & IWL_SKU_G)
 		priv->scan_bands |= BIT(IEEE80211_BAND_2GHZ);
 	if (priv->cfg->sku & IWL_SKU_A)
@@ -453,7 +453,7 @@ void iwl_bg_scan_check(struct work_struct *data)
 	mutex_lock(&priv->mutex);
 	if (test_bit(STATUS_SCANNING, &priv->status) ||
 	    test_bit(STATUS_SCAN_ABORTING, &priv->status)) {
-		IWL_DEBUG(IWL_DL_SCAN, "Scan completion watchdog resetting "
+		IWL_DEBUG_SCAN(priv, "Scan completion watchdog resetting "
 			"adapter (%dms)\n",
 			jiffies_to_msecs(IWL_SCAN_CHECK_WATCHDOG));
 
@@ -657,34 +657,34 @@ static void iwl_bg_request_scan(struct work_struct *data)
 	/* This should never be called or scheduled if there is currently
 	 * a scan active in the hardware. */
 	if (test_bit(STATUS_SCAN_HW, &priv->status)) {
-		IWL_DEBUG_INFO("Multiple concurrent scan requests in parallel. "
+		IWL_DEBUG_INFO(priv, "Multiple concurrent scan requests in parallel. "
 			       "Ignoring second request.\n");
 		ret = -EIO;
 		goto done;
 	}
 
 	if (test_bit(STATUS_EXIT_PENDING, &priv->status)) {
-		IWL_DEBUG_SCAN("Aborting scan due to device shutdown\n");
+		IWL_DEBUG_SCAN(priv, "Aborting scan due to device shutdown\n");
 		goto done;
 	}
 
 	if (test_bit(STATUS_SCAN_ABORTING, &priv->status)) {
-		IWL_DEBUG_HC("Scan request while abort pending.  Queuing.\n");
+		IWL_DEBUG_HC(priv, "Scan request while abort pending.  Queuing.\n");
 		goto done;
 	}
 
 	if (iwl_is_rfkill(priv)) {
-		IWL_DEBUG_HC("Aborting scan due to RF Kill activation\n");
+		IWL_DEBUG_HC(priv, "Aborting scan due to RF Kill activation\n");
 		goto done;
 	}
 
 	if (!test_bit(STATUS_READY, &priv->status)) {
-		IWL_DEBUG_HC("Scan request while uninitialized.  Queuing.\n");
+		IWL_DEBUG_HC(priv, "Scan request while uninitialized.  Queuing.\n");
 		goto done;
 	}
 
 	if (!priv->scan_bands) {
-		IWL_DEBUG_HC("Aborting scan due to no requested bands\n");
+		IWL_DEBUG_HC(priv, "Aborting scan due to no requested bands\n");
 		goto done;
 	}
 
@@ -709,7 +709,7 @@ static void iwl_bg_request_scan(struct work_struct *data)
 		u32 scan_suspend_time = 100;
 		unsigned long flags;
 
-		IWL_DEBUG_INFO("Scanning while associated...\n");
+		IWL_DEBUG_INFO(priv, "Scanning while associated...\n");
 
 		spin_lock_irqsave(&priv->lock, flags);
 		interval = priv->beacon_int;
@@ -724,13 +724,13 @@ static void iwl_bg_request_scan(struct work_struct *data)
 		scan_suspend_time = (extra |
 		    ((suspend_time % interval) * 1024));
 		scan->suspend_time = cpu_to_le32(scan_suspend_time);
-		IWL_DEBUG_SCAN("suspend_time 0x%X beacon interval %d\n",
+		IWL_DEBUG_SCAN(priv, "suspend_time 0x%X beacon interval %d\n",
 			       scan_suspend_time, interval);
 	}
 
 	/* We should add the ability for user to lock to PASSIVE ONLY */
 	if (priv->one_direct_scan) {
-		IWL_DEBUG_SCAN("Start direct scan for '%s'\n",
+		IWL_DEBUG_SCAN(priv, "Start direct scan for '%s'\n",
 				print_ssid(ssid, priv->direct_ssid,
 					   priv->direct_ssid_len));
 		scan->direct_scan[0].id = WLAN_EID_SSID;
@@ -739,7 +739,7 @@ static void iwl_bg_request_scan(struct work_struct *data)
 		       priv->direct_ssid, priv->direct_ssid_len);
 		n_probes++;
 	} else {
-		IWL_DEBUG_SCAN("Start indirect scan.\n");
+		IWL_DEBUG_SCAN(priv, "Start indirect scan.\n");
 	}
 
 	scan->tx_cmd.tx_flags = TX_CMD_FLG_SEQ_CTL_MSK;
@@ -801,7 +801,7 @@ static void iwl_bg_request_scan(struct work_struct *data)
 			(void *)&scan->data[le16_to_cpu(scan->tx_cmd.len)]);
 
 	if (scan->channel_count == 0) {
-		IWL_DEBUG_SCAN("channel count %d\n", scan->channel_count);
+		IWL_DEBUG_SCAN(priv, "channel count %d\n", scan->channel_count);
 		goto done;
 	}
 
@@ -855,7 +855,7 @@ void iwl_bg_scan_completed(struct work_struct *work)
 	struct iwl_priv *priv =
 	    container_of(work, struct iwl_priv, scan_completed);
 
-	IWL_DEBUG_SCAN("SCAN complete scan\n");
+	IWL_DEBUG_SCAN(priv, "SCAN complete scan\n");
 
 	if (test_bit(STATUS_EXIT_PENDING, &priv->status))
 		return;
diff --git a/drivers/net/wireless/iwlwifi/iwl-spectrum.c b/drivers/net/wireless/iwlwifi/iwl-spectrum.c
index aba1ef2..022bcf1 100644
--- a/drivers/net/wireless/iwlwifi/iwl-spectrum.c
+++ b/drivers/net/wireless/iwlwifi/iwl-spectrum.c
@@ -154,9 +154,9 @@ static int iwl_get_measurement(struct iwl_priv *priv,
 	switch (spectrum_resp_status) {
 	case 0:		/* Command will be handled */
 		if (res->u.spectrum.id != 0xff) {
-			IWL_DEBUG_INFO
-			    ("Replaced existing measurement: %d\n",
-			     res->u.spectrum.id);
+			IWL_DEBUG_INFO(priv,
+				"Replaced existing measurement: %d\n",
+				res->u.spectrum.id);
 			priv->measurement_status &= ~MEASUREMENT_READY;
 		}
 		priv->measurement_status |= MEASUREMENT_ACTIVE;
@@ -181,7 +181,7 @@ static void iwl_rx_spectrum_measure_notif(struct iwl_priv *priv,
 	struct iwl_spectrum_notification *report = &(pkt->u.spectrum_notif);
 
 	if (!report->state) {
-		IWL_DEBUG(IWL_DL_11H,
+		IWL_DEBUG_11H(priv,
 			"Spectrum Measure Notification: Start\n");
 		return;
 	}
diff --git a/drivers/net/wireless/iwlwifi/iwl-sta.c b/drivers/net/wireless/iwlwifi/iwl-sta.c
index 9bba98e..7d2129c 100644
--- a/drivers/net/wireless/iwlwifi/iwl-sta.c
+++ b/drivers/net/wireless/iwlwifi/iwl-sta.c
@@ -60,7 +60,7 @@ u8 iwl_find_station(struct iwl_priv *priv, const u8 *addr)
 			goto out;
 		}
 
-	IWL_DEBUG_ASSOC_LIMIT("can not find STA %pM total %d\n",
+	IWL_DEBUG_ASSOC_LIMIT(priv, "can not find STA %pM total %d\n",
 			      addr, priv->num_stations);
 
  out:
@@ -92,7 +92,7 @@ static void iwl_sta_ucode_activate(struct iwl_priv *priv, u8 sta_id)
 			sta_id);
 
 	priv->stations[sta_id].used |= IWL_STA_UCODE_ACTIVE;
-	IWL_DEBUG_ASSOC("Added STA to Ucode: %pM\n",
+	IWL_DEBUG_ASSOC(priv, "Added STA to Ucode: %pM\n",
 			priv->stations[sta_id].sta.sta.addr);
 
 	spin_unlock_irqrestore(&priv->sta_lock, flags);
@@ -123,7 +123,7 @@ static int iwl_add_sta_callback(struct iwl_priv *priv,
 		iwl_sta_ucode_activate(priv, sta_id);
 		 /* fall through */
 	default:
-		IWL_DEBUG_HC("Received REPLY_ADD_STA:(0x%08X)\n",
+		IWL_DEBUG_HC(priv, "Received REPLY_ADD_STA:(0x%08X)\n",
 			     res->u.add_sta.status);
 		break;
 	}
@@ -166,7 +166,7 @@ int iwl_send_add_sta(struct iwl_priv *priv,
 		switch (res->u.add_sta.status) {
 		case ADD_STA_SUCCESS_MSK:
 			iwl_sta_ucode_activate(priv, sta->sta.sta_id);
-			IWL_DEBUG_INFO("REPLY_ADD_STA PASSED\n");
+			IWL_DEBUG_INFO(priv, "REPLY_ADD_STA PASSED\n");
 			break;
 		default:
 			ret = -EIO;
@@ -272,7 +272,7 @@ u8 iwl_add_station_flags(struct iwl_priv *priv, const u8 *addr, int is_ap,
 
 	station = &priv->stations[sta_id];
 	station->used = IWL_STA_DRIVER_ACTIVE;
-	IWL_DEBUG_ASSOC("Add STA to driver ID %d: %pM\n",
+	IWL_DEBUG_ASSOC(priv, "Add STA to driver ID %d: %pM\n",
 			sta_id, addr);
 	priv->num_stations++;
 
@@ -304,7 +304,7 @@ static void iwl_sta_ucode_deactivate(struct iwl_priv *priv, const char *addr)
 
 	BUG_ON(sta_id == IWL_INVALID_STATION);
 
-	IWL_DEBUG_ASSOC("Removed STA from Ucode: %pM\n", addr);
+	IWL_DEBUG_ASSOC(priv, "Removed STA from Ucode: %pM\n", addr);
 
 	spin_lock_irqsave(&priv->sta_lock, flags);
 
@@ -390,7 +390,7 @@ static int iwl_send_remove_station(struct iwl_priv *priv, const u8 *addr,
 		switch (res->u.rem_sta.status) {
 		case REM_STA_SUCCESS_MSK:
 			iwl_sta_ucode_deactivate(priv, addr);
-			IWL_DEBUG_ASSOC("REPLY_REMOVE_STA PASSED\n");
+			IWL_DEBUG_ASSOC(priv, "REPLY_REMOVE_STA PASSED\n");
 			break;
 		default:
 			ret = -EIO;
@@ -432,7 +432,7 @@ int iwl_remove_station(struct iwl_priv *priv, const u8 *addr, int is_ap)
 	if (unlikely(sta_id == IWL_INVALID_STATION))
 		goto out;
 
-	IWL_DEBUG_ASSOC("Removing STA from driver:%d  %pM\n",
+	IWL_DEBUG_ASSOC(priv, "Removing STA from driver:%d  %pM\n",
 		sta_id, addr);
 
 	if (!(priv->stations[sta_id].used & IWL_STA_DRIVER_ACTIVE)) {
@@ -557,7 +557,7 @@ int iwl_remove_default_wep_key(struct iwl_priv *priv,
 	priv->default_wep_key--;
 	memset(&priv->wep_keys[keyconf->keyidx], 0, sizeof(priv->wep_keys[0]));
 	ret = iwl_send_static_wepkey_cmd(priv, 1);
-	IWL_DEBUG_WEP("Remove default WEP key: idx=%d ret=%d\n",
+	IWL_DEBUG_WEP(priv, "Remove default WEP key: idx=%d ret=%d\n",
 		      keyconf->keyidx, ret);
 	spin_unlock_irqrestore(&priv->sta_lock, flags);
 
@@ -573,7 +573,7 @@ int iwl_set_default_wep_key(struct iwl_priv *priv,
 
 	if (keyconf->keylen != WEP_KEY_LEN_128 &&
 	    keyconf->keylen != WEP_KEY_LEN_64) {
-		IWL_DEBUG_WEP("Bad WEP key length %d\n", keyconf->keylen);
+		IWL_DEBUG_WEP(priv, "Bad WEP key length %d\n", keyconf->keylen);
 		return -EINVAL;
 	}
 
@@ -593,7 +593,7 @@ int iwl_set_default_wep_key(struct iwl_priv *priv,
 							keyconf->keylen);
 
 	ret = iwl_send_static_wepkey_cmd(priv, 0);
-	IWL_DEBUG_WEP("Set default WEP key: len=%d idx=%d ret=%d\n",
+	IWL_DEBUG_WEP(priv, "Set default WEP key: len=%d idx=%d ret=%d\n",
 		keyconf->keylen, keyconf->keyidx, ret);
 	spin_unlock_irqrestore(&priv->sta_lock, flags);
 
@@ -749,7 +749,7 @@ void iwl_update_tkip_key(struct iwl_priv *priv,
 
 	sta_id = iwl_find_station(priv, addr);
 	if (sta_id == IWL_INVALID_STATION) {
-		IWL_DEBUG_MAC80211("leave - %pM not in station map.\n",
+		IWL_DEBUG_MAC80211(priv, "leave - %pM not in station map.\n",
 				   addr);
 		return;
 	}
@@ -801,7 +801,7 @@ int iwl_remove_dynamic_key(struct iwl_priv *priv,
 	key_flags = le16_to_cpu(priv->stations[sta_id].sta.key.key_flags);
 	keyidx = (key_flags >> STA_KEY_FLG_KEYID_POS) & 0x3;
 
-	IWL_DEBUG_WEP("Remove dynamic key: idx=%d sta=%d\n",
+	IWL_DEBUG_WEP(priv, "Remove dynamic key: idx=%d sta=%d\n",
 		      keyconf->keyidx, sta_id);
 
 	if (keyconf->keyidx != keyidx) {
@@ -865,7 +865,7 @@ int iwl_set_dynamic_key(struct iwl_priv *priv,
 		ret = -EINVAL;
 	}
 
-	IWL_DEBUG_WEP("Set dynamic key: alg= %d len=%d idx=%d sta=%d ret=%d\n",
+	IWL_DEBUG_WEP(priv, "Set dynamic key: alg= %d len=%d idx=%d sta=%d ret=%d\n",
 		      keyconf->alg, keyconf->keylen, keyconf->keyidx,
 		      sta_id, ret);
 
@@ -878,13 +878,13 @@ static void iwl_dump_lq_cmd(struct iwl_priv *priv,
 			   struct iwl_link_quality_cmd *lq)
 {
 	int i;
-	IWL_DEBUG_RATE("lq station id 0x%x\n", lq->sta_id);
-	IWL_DEBUG_RATE("lq ant 0x%X 0x%X\n",
+	IWL_DEBUG_RATE(priv, "lq station id 0x%x\n", lq->sta_id);
+	IWL_DEBUG_RATE(priv, "lq ant 0x%X 0x%X\n",
 		       lq->general_params.single_stream_ant_msk,
 		       lq->general_params.dual_stream_ant_msk);
 
 	for (i = 0; i < LINK_QUAL_MAX_RETRY_NUM; i++)
-		IWL_DEBUG_RATE("lq index %d 0x%X\n",
+		IWL_DEBUG_RATE(priv, "lq index %d 0x%X\n",
 			       i, lq->rs_table[i].rate_n_flags);
 }
 #else
@@ -1061,7 +1061,7 @@ int iwl_get_sta_id(struct iwl_priv *priv, struct ieee80211_hdr *hdr)
 		if (sta_id != IWL_INVALID_STATION)
 			return sta_id;
 
-		IWL_DEBUG_DROP("Station %pM not in station map. "
+		IWL_DEBUG_DROP(priv, "Station %pM not in station map. "
 			       "Defaulting to broadcast...\n",
 			       hdr->addr1);
 		iwl_print_hex_dump(priv, IWL_DL_DROP, (u8 *) hdr, sizeof(*hdr));
diff --git a/drivers/net/wireless/iwlwifi/iwl-tx.c b/drivers/net/wireless/iwlwifi/iwl-tx.c
index 58118c8..3b708e1 100644
--- a/drivers/net/wireless/iwlwifi/iwl-tx.c
+++ b/drivers/net/wireless/iwlwifi/iwl-tx.c
@@ -96,7 +96,7 @@ int iwl_txq_update_write_ptr(struct iwl_priv *priv, struct iwl_tx_queue *txq)
 		reg = iwl_read32(priv, CSR_UCODE_DRV_GP1);
 
 		if (reg & CSR_UCODE_DRV_GP1_BIT_MAC_SLEEP) {
-			IWL_DEBUG_INFO("Requesting wakeup, GP1 = 0x%x\n", reg);
+			IWL_DEBUG_INFO(priv, "Requesting wakeup, GP1 = 0x%x\n", reg);
 			iwl_set_bit(priv, CSR_GP_CNTRL,
 				    CSR_GP_CNTRL_REG_FLAG_MAC_ACCESS_REQ);
 			return ret;
@@ -639,14 +639,14 @@ static void iwl_tx_cmd_build_hwcrypto(struct iwl_priv *priv,
 		memcpy(tx_cmd->key, keyconf->key, keyconf->keylen);
 		if (info->flags & IEEE80211_TX_CTL_AMPDU)
 			tx_cmd->tx_flags |= TX_CMD_FLG_AGG_CCMP_MSK;
-		IWL_DEBUG_TX("tx_cmd with AES hwcrypto\n");
+		IWL_DEBUG_TX(priv, "tx_cmd with AES hwcrypto\n");
 		break;
 
 	case ALG_TKIP:
 		tx_cmd->sec_ctl = TX_CMD_SEC_TKIP;
 		ieee80211_get_tkip_key(keyconf, skb_frag,
 			IEEE80211_TKIP_P2_KEY, tx_cmd->key);
-		IWL_DEBUG_TX("tx_cmd with tkip hwcrypto\n");
+		IWL_DEBUG_TX(priv, "tx_cmd with tkip hwcrypto\n");
 		break;
 
 	case ALG_WEP:
@@ -658,7 +658,7 @@ static void iwl_tx_cmd_build_hwcrypto(struct iwl_priv *priv,
 
 		memcpy(&tx_cmd->key[3], keyconf->key, keyconf->keylen);
 
-		IWL_DEBUG_TX("Configuring packet for WEP encryption "
+		IWL_DEBUG_TX(priv, "Configuring packet for WEP encryption "
 			     "with key %d\n", keyconf->keyidx);
 		break;
 
@@ -704,7 +704,7 @@ int iwl_tx_skb(struct iwl_priv *priv, struct sk_buff *skb)
 
 	spin_lock_irqsave(&priv->lock, flags);
 	if (iwl_is_rfkill(priv)) {
-		IWL_DEBUG_DROP("Dropping - RF KILL\n");
+		IWL_DEBUG_DROP(priv, "Dropping - RF KILL\n");
 		goto drop_unlock;
 	}
 
@@ -718,11 +718,11 @@ int iwl_tx_skb(struct iwl_priv *priv, struct sk_buff *skb)
 
 #ifdef CONFIG_IWLWIFI_DEBUG
 	if (ieee80211_is_auth(fc))
-		IWL_DEBUG_TX("Sending AUTH frame\n");
+		IWL_DEBUG_TX(priv, "Sending AUTH frame\n");
 	else if (ieee80211_is_assoc_req(fc))
-		IWL_DEBUG_TX("Sending ASSOC frame\n");
+		IWL_DEBUG_TX(priv, "Sending ASSOC frame\n");
 	else if (ieee80211_is_reassoc_req(fc))
-		IWL_DEBUG_TX("Sending REASSOC frame\n");
+		IWL_DEBUG_TX(priv, "Sending REASSOC frame\n");
 #endif
 
 	/* drop all data frame if we are not associated */
@@ -732,7 +732,7 @@ int iwl_tx_skb(struct iwl_priv *priv, struct sk_buff *skb)
 	    (!iwl_is_associated(priv) ||
 	     ((priv->iw_mode == NL80211_IFTYPE_STATION) && !priv->assoc_id) ||
 	     !priv->assoc_station_added)) {
-		IWL_DEBUG_DROP("Dropping - !iwl_is_associated\n");
+		IWL_DEBUG_DROP(priv, "Dropping - !iwl_is_associated\n");
 		goto drop_unlock;
 	}
 
@@ -743,12 +743,12 @@ int iwl_tx_skb(struct iwl_priv *priv, struct sk_buff *skb)
 	/* Find (or create) index into station table for destination station */
 	sta_id = iwl_get_sta_id(priv, hdr);
 	if (sta_id == IWL_INVALID_STATION) {
-		IWL_DEBUG_DROP("Dropping - INVALID STATION: %pM\n",
+		IWL_DEBUG_DROP(priv, "Dropping - INVALID STATION: %pM\n",
 			       hdr->addr1);
 		goto drop;
 	}
 
-	IWL_DEBUG_TX("station Id %d\n", sta_id);
+	IWL_DEBUG_TX(priv, "station Id %d\n", sta_id);
 
 	swq_id = skb_get_queue_mapping(skb);
 	txq_id = swq_id;
@@ -939,7 +939,7 @@ int iwl_enqueue_hcmd(struct iwl_priv *priv, struct iwl_host_cmd *cmd)
 	       !(cmd->meta.flags & CMD_SIZE_HUGE));
 
 	if (iwl_is_rfkill(priv)) {
-		IWL_DEBUG_INFO("Not sending command - RF KILL");
+		IWL_DEBUG_INFO(priv, "Not sending command - RF KILL");
 		return -EIO;
 	}
 
@@ -982,7 +982,7 @@ int iwl_enqueue_hcmd(struct iwl_priv *priv, struct iwl_host_cmd *cmd)
 	switch (out_cmd->hdr.cmd) {
 	case REPLY_TX_LINK_QUALITY_CMD:
 	case SENSITIVITY_CMD:
-		IWL_DEBUG_HC_DUMP("Sending command %s (#%x), seq: 0x%04X, "
+		IWL_DEBUG_HC_DUMP(priv, "Sending command %s (#%x), seq: 0x%04X, "
 				"%d bytes at %d[%d]:%d\n",
 				get_cmd_string(out_cmd->hdr.cmd),
 				out_cmd->hdr.cmd,
@@ -990,7 +990,7 @@ int iwl_enqueue_hcmd(struct iwl_priv *priv, struct iwl_host_cmd *cmd)
 				q->write_ptr, idx, IWL_CMD_QUEUE_NUM);
 				break;
 	default:
-		IWL_DEBUG_HC("Sending command %s (#%x), seq: 0x%04X, "
+		IWL_DEBUG_HC(priv, "Sending command %s (#%x), seq: 0x%04X, "
 				"%d bytes at %d[%d]:%d\n",
 				get_cmd_string(out_cmd->hdr.cmd),
 				out_cmd->hdr.cmd,
@@ -1195,7 +1195,7 @@ int iwl_tx_agg_start(struct iwl_priv *priv, const u8 *ra, u16 tid, u16 *ssn)
 		tid_data->agg.state = IWL_AGG_ON;
 		ieee80211_start_tx_ba_cb_irqsafe(priv->hw, ra, tid);
 	} else {
-		IWL_DEBUG_HT("HW queue is NOT empty: %d packets in HW queue\n",
+		IWL_DEBUG_HT(priv, "HW queue is NOT empty: %d packets in HW queue\n",
 			     tid_data->tfds_in_queue);
 		tid_data->agg.state = IWL_EMPTYING_HW_QUEUE_ADDBA;
 	}
@@ -1236,13 +1236,13 @@ int iwl_tx_agg_stop(struct iwl_priv *priv , const u8 *ra, u16 tid)
 
 	/* The queue is not empty */
 	if (write_ptr != read_ptr) {
-		IWL_DEBUG_HT("Stopping a non empty AGG HW QUEUE\n");
+		IWL_DEBUG_HT(priv, "Stopping a non empty AGG HW QUEUE\n");
 		priv->stations[sta_id].tid[tid].agg.state =
 				IWL_EMPTYING_HW_QUEUE_DELBA;
 		return 0;
 	}
 
-	IWL_DEBUG_HT("HW queue is empty\n");
+	IWL_DEBUG_HT(priv, "HW queue is empty\n");
 	priv->stations[sta_id].tid[tid].agg.state = IWL_AGG_OFF;
 
 	spin_lock_irqsave(&priv->lock, flags);
@@ -1273,7 +1273,7 @@ int iwl_txq_check_empty(struct iwl_priv *priv, int sta_id, u8 tid, int txq_id)
 		    (q->read_ptr == q->write_ptr)) {
 			u16 ssn = SEQ_TO_SN(tid_data->seq_number);
 			int tx_fifo = default_tid_to_tx_fifo[tid];
-			IWL_DEBUG_HT("HW queue empty: continue DELBA flow\n");
+			IWL_DEBUG_HT(priv, "HW queue empty: continue DELBA flow\n");
 			priv->cfg->ops->lib->txq_agg_disable(priv, txq_id,
 							     ssn, tx_fifo);
 			tid_data->agg.state = IWL_AGG_OFF;
@@ -1283,7 +1283,7 @@ int iwl_txq_check_empty(struct iwl_priv *priv, int sta_id, u8 tid, int txq_id)
 	case IWL_EMPTYING_HW_QUEUE_ADDBA:
 		/* We are reclaiming the last packet of the queue */
 		if (tid_data->tfds_in_queue == 0) {
-			IWL_DEBUG_HT("HW queue empty: continue ADDBA flow\n");
+			IWL_DEBUG_HT(priv, "HW queue empty: continue ADDBA flow\n");
 			tid_data->agg.state = IWL_AGG_ON;
 			ieee80211_start_tx_ba_cb_irqsafe(priv->hw, addr, tid);
 		}
@@ -1318,7 +1318,7 @@ static int iwl_tx_status_reply_compressed_ba(struct iwl_priv *priv,
 
 	/* Mark that the expected block-ack response arrived */
 	agg->wait_for_ba = 0;
-	IWL_DEBUG_TX_REPLY("BA %d %d\n", agg->start_idx, ba_resp->seq_ctl);
+	IWL_DEBUG_TX_REPLY(priv, "BA %d %d\n", agg->start_idx, ba_resp->seq_ctl);
 
 	/* Calculate shift to align block-ack bits with our Tx window bits */
 	sh = agg->start_idx - SEQ_TO_INDEX(seq_ctl >> 4);
@@ -1329,7 +1329,7 @@ static int iwl_tx_status_reply_compressed_ba(struct iwl_priv *priv,
 	bitmap = le64_to_cpu(ba_resp->bitmap) >> sh;
 
 	if (agg->frame_count > (64 - sh)) {
-		IWL_DEBUG_TX_REPLY("more frames than bitmap size");
+		IWL_DEBUG_TX_REPLY(priv, "more frames than bitmap size");
 		return -1;
 	}
 
@@ -1342,7 +1342,7 @@ static int iwl_tx_status_reply_compressed_ba(struct iwl_priv *priv,
 	for (i = 0; i < agg->frame_count ; i++) {
 		ack = bitmap & (1ULL << i);
 		successes += !!ack;
-		IWL_DEBUG_TX_REPLY("%s ON i=%d idx=%d raw=%d\n",
+		IWL_DEBUG_TX_REPLY(priv, "%s ON i=%d idx=%d raw=%d\n",
 			ack ? "ACK" : "NACK", i, (agg->start_idx + i) & 0xff,
 			agg->start_idx + i);
 	}
@@ -1355,7 +1355,7 @@ static int iwl_tx_status_reply_compressed_ba(struct iwl_priv *priv,
 	info->status.ampdu_ack_len = agg->frame_count;
 	iwl_hwrate_to_tx_control(priv, agg->rate_n_flags, info);
 
-	IWL_DEBUG_TX_REPLY("Bitmap %llx\n", (unsigned long long)bitmap);
+	IWL_DEBUG_TX_REPLY(priv, "Bitmap %llx\n", (unsigned long long)bitmap);
 
 	return 0;
 }
@@ -1400,19 +1400,19 @@ void iwl_rx_reply_compressed_ba(struct iwl_priv *priv,
 
 	/* TODO: Need to get this copy more safely - now good for debug */
 
-	IWL_DEBUG_TX_REPLY("REPLY_COMPRESSED_BA [%d] Received from %pM, "
+	IWL_DEBUG_TX_REPLY(priv, "REPLY_COMPRESSED_BA [%d] Received from %pM, "
 			   "sta_id = %d\n",
 			   agg->wait_for_ba,
 			   (u8 *) &ba_resp->sta_addr_lo32,
 			   ba_resp->sta_id);
-	IWL_DEBUG_TX_REPLY("TID = %d, SeqCtl = %d, bitmap = 0x%llx, scd_flow = "
+	IWL_DEBUG_TX_REPLY(priv, "TID = %d, SeqCtl = %d, bitmap = 0x%llx, scd_flow = "
 			   "%d, scd_ssn = %d\n",
 			   ba_resp->tid,
 			   ba_resp->seq_ctl,
 			   (unsigned long long)le64_to_cpu(ba_resp->bitmap),
 			   ba_resp->scd_flow,
 			   ba_resp->scd_ssn);
-	IWL_DEBUG_TX_REPLY("DAT start_idx = %d, bitmap = 0x%llx \n",
+	IWL_DEBUG_TX_REPLY(priv, "DAT start_idx = %d, bitmap = 0x%llx \n",
 			   agg->start_idx,
 			   (unsigned long long)agg->bitmap);
 
diff --git a/drivers/net/wireless/iwlwifi/iwl3945-base.c b/drivers/net/wireless/iwlwifi/iwl3945-base.c
index 346a301..ac33717 100644
--- a/drivers/net/wireless/iwlwifi/iwl3945-base.c
+++ b/drivers/net/wireless/iwlwifi/iwl3945-base.c
@@ -203,7 +203,7 @@ u8 iwl3945_add_station(struct iwl_priv *priv, const u8 *addr, int is_ap, u8 flag
 		return index;
 	}
 
-	IWL_DEBUG_ASSOC("Add STA ID %d: %pM\n", index, addr);
+	IWL_DEBUG_ASSOC(priv, "Add STA ID %d: %pM\n", index, addr);
 	station = &priv->stations_39[index];
 	station->used = 1;
 	priv->num_stations++;
@@ -251,7 +251,7 @@ static int iwl3945_send_rxon_assoc(struct iwl_priv *priv)
 	    (rxon1->filter_flags == rxon2->filter_flags) &&
 	    (rxon1->cck_basic_rates == rxon2->cck_basic_rates) &&
 	    (rxon1->ofdm_basic_rates == rxon2->ofdm_basic_rates)) {
-		IWL_DEBUG_INFO("Using current RXON_ASSOC.  Not resending.\n");
+		IWL_DEBUG_INFO(priv, "Using current RXON_ASSOC.  Not resending.\n");
 		return 0;
 	}
 
@@ -368,7 +368,7 @@ static int iwl3945_commit_rxon(struct iwl_priv *priv)
 	 * before we apply the new config */
 	if (iwl_is_associated(priv) &&
 	    (staging_rxon->filter_flags & RXON_FILTER_ASSOC_MSK)) {
-		IWL_DEBUG_INFO("Toggling associated bit on current RXON\n");
+		IWL_DEBUG_INFO(priv, "Toggling associated bit on current RXON\n");
 		active_rxon->filter_flags &= ~RXON_FILTER_ASSOC_MSK;
 
 		/*
@@ -391,7 +391,7 @@ static int iwl3945_commit_rxon(struct iwl_priv *priv)
 		}
 	}
 
-	IWL_DEBUG_INFO("Sending RXON\n"
+	IWL_DEBUG_INFO(priv, "Sending RXON\n"
 		       "* with%s RXON_FILTER_ASSOC_MSK\n"
 		       "* channel = %d\n"
 		       "* bssid = %pM\n",
@@ -489,7 +489,7 @@ static int iwl3945_update_sta_key_info(struct iwl_priv *priv,
 
 	spin_unlock_irqrestore(&priv->sta_lock, flags);
 
-	IWL_DEBUG_INFO("hwcrypto: modify ucode station key info\n");
+	IWL_DEBUG_INFO(priv, "hwcrypto: modify ucode station key info\n");
 	iwl_send_add_sta(priv,
 		(struct iwl_addsta_cmd *)&priv->stations_39[sta_id].sta, 0);
 	return 0;
@@ -508,7 +508,7 @@ static int iwl3945_clear_sta_key_info(struct iwl_priv *priv, u8 sta_id)
 	priv->stations_39[sta_id].sta.mode = STA_CONTROL_MODIFY_MSK;
 	spin_unlock_irqrestore(&priv->sta_lock, flags);
 
-	IWL_DEBUG_INFO("hwcrypto: clear ucode station key info\n");
+	IWL_DEBUG_INFO(priv, "hwcrypto: clear ucode station key info\n");
 	iwl_send_add_sta(priv,
 		(struct iwl_addsta_cmd *)&priv->stations_39[sta_id].sta, 0);
 	return 0;
@@ -518,7 +518,7 @@ static void iwl3945_clear_free_frames(struct iwl_priv *priv)
 {
 	struct list_head *element;
 
-	IWL_DEBUG_INFO("%d frames on pre-allocated heap on clear.\n",
+	IWL_DEBUG_INFO(priv, "%d frames on pre-allocated heap on clear.\n",
 		       priv->frames_count);
 
 	while (!list_empty(&priv->free_frames)) {
@@ -648,7 +648,7 @@ static void iwl3945_activate_qos(struct iwl_priv *priv, u8 force)
 	spin_unlock_irqrestore(&priv->lock, flags);
 
 	if (force || iwl_is_associated(priv)) {
-		IWL_DEBUG_QOS("send QoS cmd with QoS active %d \n",
+		IWL_DEBUG_QOS(priv, "send QoS cmd with QoS active %d \n",
 			      priv->qos_data.qos_active);
 
 		iwl3945_send_qos_params_command(priv,
@@ -690,7 +690,7 @@ int iwl3945_power_init_handle(struct iwl_priv *priv)
 	int size = sizeof(struct iwl_power_vec_entry) * IWL_POWER_MAX;
 	u16 pci_pm;
 
-	IWL_DEBUG_POWER("Initialize power \n");
+	IWL_DEBUG_POWER(priv, "Initialize power \n");
 
 	pow_data = &priv->power_data;
 
@@ -707,7 +707,7 @@ int iwl3945_power_init_handle(struct iwl_priv *priv)
 	else {
 		struct iwl_powertable_cmd *cmd;
 
-		IWL_DEBUG_POWER("adjust power command flags\n");
+		IWL_DEBUG_POWER(priv, "adjust power command flags\n");
 
 		for (i = 0; i < IWL_POWER_MAX; i++) {
 			cmd = &pow_data->pwr_range_0[i].cmd;
@@ -732,7 +732,7 @@ static int iwl3945_update_power_cmd(struct iwl_priv *priv,
 	bool skip;
 
 	if (mode > IWL_POWER_INDEX_5) {
-		IWL_DEBUG_POWER("Error invalid power mode \n");
+		IWL_DEBUG_POWER(priv, "Error invalid power mode \n");
 		return -EINVAL;
 	}
 	pow_data = &priv->power_data;
@@ -765,10 +765,10 @@ static int iwl3945_update_power_cmd(struct iwl_priv *priv,
 		if (le32_to_cpu(cmd->sleep_interval[i]) > max_sleep)
 			cmd->sleep_interval[i] = cpu_to_le32(max_sleep);
 
-	IWL_DEBUG_POWER("Flags value = 0x%08X\n", cmd->flags);
-	IWL_DEBUG_POWER("Tx timeout = %u\n", le32_to_cpu(cmd->tx_data_timeout));
-	IWL_DEBUG_POWER("Rx timeout = %u\n", le32_to_cpu(cmd->rx_data_timeout));
-	IWL_DEBUG_POWER("Sleep interval vector = { %d , %d , %d , %d , %d }\n",
+	IWL_DEBUG_POWER(priv, "Flags value = 0x%08X\n", cmd->flags);
+	IWL_DEBUG_POWER(priv, "Tx timeout = %u\n", le32_to_cpu(cmd->tx_data_timeout));
+	IWL_DEBUG_POWER(priv, "Rx timeout = %u\n", le32_to_cpu(cmd->rx_data_timeout));
+	IWL_DEBUG_POWER(priv, "Sleep interval vector = { %d , %d , %d , %d , %d }\n",
 			le32_to_cpu(cmd->sleep_interval[0]),
 			le32_to_cpu(cmd->sleep_interval[1]),
 			le32_to_cpu(cmd->sleep_interval[2]),
@@ -875,8 +875,8 @@ static void iwl3945_setup_rxon_timing(struct iwl_priv *priv)
 	priv->rxon_timing.beacon_init_val =
 	    cpu_to_le32((u32) ((u64) interval_tm_unit - result));
 
-	IWL_DEBUG_ASSOC
-	    ("beacon interval %d beacon timer %d beacon tim %d\n",
+	IWL_DEBUG_ASSOC(priv,
+		"beacon interval %d beacon timer %d beacon tim %d\n",
 		le16_to_cpu(priv->rxon_timing.beacon_interval),
 		le32_to_cpu(priv->rxon_timing.beacon_init_val),
 		le16_to_cpu(priv->rxon_timing.atim_window));
@@ -885,22 +885,22 @@ static void iwl3945_setup_rxon_timing(struct iwl_priv *priv)
 static int iwl3945_scan_initiate(struct iwl_priv *priv)
 {
 	if (!iwl_is_ready_rf(priv)) {
-		IWL_DEBUG_SCAN("Aborting scan due to not ready.\n");
+		IWL_DEBUG_SCAN(priv, "Aborting scan due to not ready.\n");
 		return -EIO;
 	}
 
 	if (test_bit(STATUS_SCANNING, &priv->status)) {
-		IWL_DEBUG_SCAN("Scan already in progress.\n");
+		IWL_DEBUG_SCAN(priv, "Scan already in progress.\n");
 		return -EAGAIN;
 	}
 
 	if (test_bit(STATUS_SCAN_ABORTING, &priv->status)) {
-		IWL_DEBUG_SCAN("Scan request while abort pending.  "
+		IWL_DEBUG_SCAN(priv, "Scan request while abort pending.  "
 			       "Queuing.\n");
 		return -EAGAIN;
 	}
 
-	IWL_DEBUG_INFO("Starting scan...\n");
+	IWL_DEBUG_INFO(priv, "Starting scan...\n");
 	if (priv->cfg->sku & IWL_SKU_G)
 		priv->scan_bands |= BIT(IEEE80211_BAND_2GHZ);
 	if (priv->cfg->sku & IWL_SKU_A)
@@ -941,7 +941,7 @@ static int iwl3945_set_mode(struct iwl_priv *priv, int mode)
 	cancel_delayed_work(&priv->scan_check);
 	if (iwl_scan_cancel_timeout(priv, 100)) {
 		IWL_WARN(priv, "Aborted scan still in progress after 100ms\n");
-		IWL_DEBUG_MAC80211("leaving - scan abort failed.\n");
+		IWL_DEBUG_MAC80211(priv, "leaving - scan abort failed.\n");
 		return -EAGAIN;
 	}
 
@@ -964,7 +964,7 @@ static void iwl3945_build_tx_cmd_hwcrypto(struct iwl_priv *priv,
 	case ALG_CCMP:
 		tx->sec_ctl = TX_CMD_SEC_CCM;
 		memcpy(tx->key, keyinfo->key, keyinfo->keylen);
-		IWL_DEBUG_TX("tx_cmd with AES hwcrypto\n");
+		IWL_DEBUG_TX(priv, "tx_cmd with AES hwcrypto\n");
 		break;
 
 	case ALG_TKIP:
@@ -988,7 +988,7 @@ static void iwl3945_build_tx_cmd_hwcrypto(struct iwl_priv *priv,
 
 		memcpy(&tx->key[3], keyinfo->key, keyinfo->keylen);
 
-		IWL_DEBUG_TX("Configuring packet for WEP encryption "
+		IWL_DEBUG_TX(priv, "Configuring packet for WEP encryption "
 			     "with key %d\n", info->control.hw_key->hw_key_idx);
 		break;
 
@@ -1105,7 +1105,7 @@ static int iwl3945_get_sta_id(struct iwl_priv *priv, struct ieee80211_hdr *hdr)
 		if (sta_id != IWL_INVALID_STATION)
 			return sta_id;
 
-		IWL_DEBUG_DROP("Station %pM not in station map. "
+		IWL_DEBUG_DROP(priv, "Station %pM not in station map. "
 			       "Defaulting to broadcast...\n",
 			       hdr->addr1);
 		iwl_print_hex_dump(priv, IWL_DL_DROP, (u8 *) hdr, sizeof(*hdr));
@@ -1151,7 +1151,7 @@ static int iwl3945_tx_skb(struct iwl_priv *priv, struct sk_buff *skb)
 
 	spin_lock_irqsave(&priv->lock, flags);
 	if (iwl_is_rfkill(priv)) {
-		IWL_DEBUG_DROP("Dropping - RF KILL\n");
+		IWL_DEBUG_DROP(priv, "Dropping - RF KILL\n");
 		goto drop_unlock;
 	}
 
@@ -1167,11 +1167,11 @@ static int iwl3945_tx_skb(struct iwl_priv *priv, struct sk_buff *skb)
 
 #ifdef CONFIG_IWLWIFI_DEBUG
 	if (ieee80211_is_auth(fc))
-		IWL_DEBUG_TX("Sending AUTH frame\n");
+		IWL_DEBUG_TX(priv, "Sending AUTH frame\n");
 	else if (ieee80211_is_assoc_req(fc))
-		IWL_DEBUG_TX("Sending ASSOC frame\n");
+		IWL_DEBUG_TX(priv, "Sending ASSOC frame\n");
 	else if (ieee80211_is_reassoc_req(fc))
-		IWL_DEBUG_TX("Sending REASSOC frame\n");
+		IWL_DEBUG_TX(priv, "Sending REASSOC frame\n");
 #endif
 
 	/* drop all data frame if we are not associated */
@@ -1179,7 +1179,7 @@ static int iwl3945_tx_skb(struct iwl_priv *priv, struct sk_buff *skb)
 	    (priv->iw_mode != NL80211_IFTYPE_MONITOR) && /* packet injection */
 	    (!iwl_is_associated(priv) ||
 	     ((priv->iw_mode == NL80211_IFTYPE_STATION) && !priv->assoc_id))) {
-		IWL_DEBUG_DROP("Dropping - !iwl_is_associated\n");
+		IWL_DEBUG_DROP(priv, "Dropping - !iwl_is_associated\n");
 		goto drop_unlock;
 	}
 
@@ -1190,12 +1190,12 @@ static int iwl3945_tx_skb(struct iwl_priv *priv, struct sk_buff *skb)
 	/* Find (or create) index into station table for destination station */
 	sta_id = iwl3945_get_sta_id(priv, hdr);
 	if (sta_id == IWL_INVALID_STATION) {
-		IWL_DEBUG_DROP("Dropping - INVALID STATION: %pM\n",
+		IWL_DEBUG_DROP(priv, "Dropping - INVALID STATION: %pM\n",
 			       hdr->addr1);
 		goto drop;
 	}
 
-	IWL_DEBUG_RATE("station Id %d\n", sta_id);
+	IWL_DEBUG_RATE(priv, "station Id %d\n", sta_id);
 
 	if (ieee80211_is_data_qos(fc)) {
 		qc = ieee80211_get_qos_ctl(hdr);
@@ -1351,7 +1351,7 @@ static void iwl3945_radio_kill_sw(struct iwl_priv *priv, int disable_radio)
 	if (!!disable_radio == test_bit(STATUS_RF_KILL_SW, &priv->status))
 		return;
 
-	IWL_DEBUG_RF_KILL("Manual SW RF KILL set to: RADIO %s\n",
+	IWL_DEBUG_RF_KILL(priv, "Manual SW RF KILL set to: RADIO %s\n",
 			  disable_radio ? "OFF" : "ON");
 
 	if (disable_radio) {
@@ -1384,7 +1384,7 @@ static void iwl3945_radio_kill_sw(struct iwl_priv *priv, int disable_radio)
 	spin_unlock_irqrestore(&priv->lock, flags);
 
 	if (test_bit(STATUS_RF_KILL_HW, &priv->status)) {
-		IWL_DEBUG_RF_KILL("Can not turn radio back on - "
+		IWL_DEBUG_RF_KILL(priv, "Can not turn radio back on - "
 				  "disabled by HW switch\n");
 		return;
 	}
@@ -1507,7 +1507,7 @@ static int iwl3945_get_measurement(struct iwl_priv *priv,
 	switch (spectrum_resp_status) {
 	case 0:		/* Command will be handled */
 		if (res->u.spectrum.id != 0xff) {
-			IWL_DEBUG_INFO("Replaced existing measurement: %d\n",
+			IWL_DEBUG_INFO(priv, "Replaced existing measurement: %d\n",
 						res->u.spectrum.id);
 			priv->measurement_status &= ~MEASUREMENT_READY;
 		}
@@ -1535,18 +1535,18 @@ static void iwl3945_rx_reply_alive(struct iwl_priv *priv,
 
 	palive = &pkt->u.alive_frame;
 
-	IWL_DEBUG_INFO("Alive ucode status 0x%08X revision "
+	IWL_DEBUG_INFO(priv, "Alive ucode status 0x%08X revision "
 		       "0x%01X 0x%01X\n",
 		       palive->is_valid, palive->ver_type,
 		       palive->ver_subtype);
 
 	if (palive->ver_subtype == INITIALIZE_SUBTYPE) {
-		IWL_DEBUG_INFO("Initialization Alive received.\n");
+		IWL_DEBUG_INFO(priv, "Initialization Alive received.\n");
 		memcpy(&priv->card_alive_init, &pkt->u.alive_frame,
 		       sizeof(struct iwl_alive_resp));
 		pwork = &priv->init_alive_start;
 	} else {
-		IWL_DEBUG_INFO("Runtime Alive received.\n");
+		IWL_DEBUG_INFO(priv, "Runtime Alive received.\n");
 		memcpy(&priv->card_alive, &pkt->u.alive_frame,
 		       sizeof(struct iwl_alive_resp));
 		pwork = &priv->alive_start;
@@ -1569,7 +1569,7 @@ static void iwl3945_rx_reply_add_sta(struct iwl_priv *priv,
 	struct iwl_rx_packet *pkt = (void *)rxb->skb->data;
 #endif
 
-	IWL_DEBUG_RX("Received REPLY_ADD_STA: 0x%02X\n", pkt->u.status);
+	IWL_DEBUG_RX(priv, "Received REPLY_ADD_STA: 0x%02X\n", pkt->u.status);
 	return;
 }
 
@@ -1595,7 +1595,7 @@ static void iwl3945_rx_spectrum_measure_notif(struct iwl_priv *priv,
 	struct iwl_spectrum_notification *report = &(pkt->u.spectrum_notif);
 
 	if (!report->state) {
-		IWL_DEBUG(IWL_DL_11H | IWL_DL_INFO,
+		IWL_DEBUG(priv, IWL_DL_11H | IWL_DL_INFO,
 			  "Spectrum Measure Notification: Start\n");
 		return;
 	}
@@ -1611,7 +1611,7 @@ static void iwl3945_rx_pm_sleep_notif(struct iwl_priv *priv,
 #ifdef CONFIG_IWLWIFI_DEBUG
 	struct iwl_rx_packet *pkt = (void *)rxb->skb->data;
 	struct iwl_sleep_notification *sleep = &(pkt->u.sleep_notif);
-	IWL_DEBUG_RX("sleep mode: %d, src: %d\n",
+	IWL_DEBUG_RX(priv, "sleep mode: %d, src: %d\n",
 		     sleep->pm_sleep_mode, sleep->pm_wakeup_src);
 #endif
 }
@@ -1620,7 +1620,7 @@ static void iwl3945_rx_pm_debug_statistics_notif(struct iwl_priv *priv,
 					     struct iwl_rx_mem_buffer *rxb)
 {
 	struct iwl_rx_packet *pkt = (void *)rxb->skb->data;
-	IWL_DEBUG_RADIO("Dumping %d bytes of unhandled "
+	IWL_DEBUG_RADIO(priv, "Dumping %d bytes of unhandled "
 			"notification for %s:\n",
 			le32_to_cpu(pkt->len), get_cmd_string(pkt->hdr.cmd));
 	iwl_print_hex_dump(priv, IWL_DL_RADIO, pkt->u.raw,
@@ -1660,7 +1660,7 @@ static void iwl3945_rx_beacon_notif(struct iwl_priv *priv,
 	struct iwl3945_beacon_notif *beacon = &(pkt->u.beacon_status);
 	u8 rate = beacon->beacon_notify_hdr.rate;
 
-	IWL_DEBUG_RX("beacon status %x retries %d iss %d "
+	IWL_DEBUG_RX(priv, "beacon status %x retries %d iss %d "
 		"tsf %d %d rate %d\n",
 		le32_to_cpu(beacon->beacon_notify_hdr.status) & TX_STATUS_MSK,
 		beacon->beacon_notify_hdr.failure_frame,
@@ -1683,7 +1683,7 @@ static void iwl3945_rx_reply_scan(struct iwl_priv *priv,
 	struct iwl_scanreq_notification *notif =
 	    (struct iwl_scanreq_notification *)pkt->u.raw;
 
-	IWL_DEBUG_RX("Scan request status = 0x%x\n", notif->status);
+	IWL_DEBUG_RX(priv, "Scan request status = 0x%x\n", notif->status);
 #endif
 }
 
@@ -1695,7 +1695,7 @@ static void iwl3945_rx_scan_start_notif(struct iwl_priv *priv,
 	struct iwl_scanstart_notification *notif =
 	    (struct iwl_scanstart_notification *)pkt->u.raw;
 	priv->scan_start_tsf = le32_to_cpu(notif->tsf_low);
-	IWL_DEBUG_SCAN("Scan start: "
+	IWL_DEBUG_SCAN(priv, "Scan start: "
 		       "%d [802.11%s] "
 		       "(TSF: 0x%08X:%08X) - %d (beacon timer %u)\n",
 		       notif->channel,
@@ -1714,7 +1714,7 @@ static void iwl3945_rx_scan_results_notif(struct iwl_priv *priv,
 	    (struct iwl_scanresults_notification *)pkt->u.raw;
 #endif
 
-	IWL_DEBUG_SCAN("Scan ch.res: "
+	IWL_DEBUG_SCAN(priv, "Scan ch.res: "
 		       "%d [802.11%s] "
 		       "(TSF: 0x%08X:%08X) - %d "
 		       "elapsed=%lu usec (%dms since last)\n",
@@ -1740,7 +1740,7 @@ static void iwl3945_rx_scan_complete_notif(struct iwl_priv *priv,
 	struct iwl_scancomplete_notification *scan_notif = (void *)pkt->u.raw;
 #endif
 
-	IWL_DEBUG_SCAN("Scan complete: %d channels (TSF 0x%08X:%08X) - %d\n",
+	IWL_DEBUG_SCAN(priv, "Scan complete: %d channels (TSF 0x%08X:%08X) - %d\n",
 		       scan_notif->scanned_channels,
 		       scan_notif->tsf_low,
 		       scan_notif->tsf_high, scan_notif->status);
@@ -1751,7 +1751,7 @@ static void iwl3945_rx_scan_complete_notif(struct iwl_priv *priv,
 	/* The scan completion notification came in, so kill that timer... */
 	cancel_delayed_work(&priv->scan_check);
 
-	IWL_DEBUG_INFO("Scan pass on %sGHz took %dms\n",
+	IWL_DEBUG_INFO(priv, "Scan pass on %sGHz took %dms\n",
 		       (priv->scan_bands & BIT(IEEE80211_BAND_2GHZ)) ?
 							"2.4" : "5.2",
 		       jiffies_to_msecs(elapsed_jiffies
@@ -1769,7 +1769,7 @@ static void iwl3945_rx_scan_complete_notif(struct iwl_priv *priv,
 	 * then we reset the scan state machine and terminate,
 	 * re-queuing another scan if one has been requested */
 	if (test_bit(STATUS_SCAN_ABORTING, &priv->status)) {
-		IWL_DEBUG_INFO("Aborted scan completed.\n");
+		IWL_DEBUG_INFO(priv, "Aborted scan completed.\n");
 		clear_bit(STATUS_SCAN_ABORTING, &priv->status);
 	} else {
 		/* If there are more bands on this scan pass reschedule */
@@ -1779,11 +1779,11 @@ static void iwl3945_rx_scan_complete_notif(struct iwl_priv *priv,
 
 	priv->last_scan_jiffies = jiffies;
 	priv->next_scan_jiffies = 0;
-	IWL_DEBUG_INFO("Setting scan to off\n");
+	IWL_DEBUG_INFO(priv, "Setting scan to off\n");
 
 	clear_bit(STATUS_SCANNING, &priv->status);
 
-	IWL_DEBUG_INFO("Scan took %dms\n",
+	IWL_DEBUG_INFO(priv, "Scan took %dms\n",
 		jiffies_to_msecs(elapsed_jiffies(priv->scan_start, jiffies)));
 
 	queue_work(priv->workqueue, &priv->scan_completed);
@@ -1804,7 +1804,7 @@ static void iwl3945_rx_card_state_notif(struct iwl_priv *priv,
 	u32 flags = le32_to_cpu(pkt->u.card_state_notif.flags);
 	unsigned long status = priv->status;
 
-	IWL_DEBUG_RF_KILL("Card state received: HW:%s SW:%s\n",
+	IWL_DEBUG_RF_KILL(priv, "Card state received: HW:%s SW:%s\n",
 			  (flags & HW_CARD_DISABLED) ? "Kill" : "On",
 			  (flags & SW_CARD_DISABLED) ? "Kill" : "On");
 
@@ -2265,7 +2265,7 @@ static void iwl3945_rx_handle(struct iwl_priv *priv)
 		fill_rx = 1;
 	/* Rx interrupt, but nothing sent from uCode */
 	if (i == r)
-		IWL_DEBUG(IWL_DL_RX | IWL_DL_ISR, "r = %d, i = %d\n", r, i);
+		IWL_DEBUG(priv, IWL_DL_RX | IWL_DL_ISR, "r = %d, i = %d\n", r, i);
 
 	while (i != r) {
 		rxb = rxq->queue[i];
@@ -2296,13 +2296,13 @@ static void iwl3945_rx_handle(struct iwl_priv *priv)
 		 *   handle those that need handling via function in
 		 *   rx_handlers table.  See iwl3945_setup_rx_handlers() */
 		if (priv->rx_handlers[pkt->hdr.cmd]) {
-			IWL_DEBUG(IWL_DL_HCMD | IWL_DL_RX | IWL_DL_ISR,
+			IWL_DEBUG(priv, IWL_DL_HCMD | IWL_DL_RX | IWL_DL_ISR,
 				"r = %d, i = %d, %s, 0x%02x\n", r, i,
 				get_cmd_string(pkt->hdr.cmd), pkt->hdr.cmd);
 			priv->rx_handlers[pkt->hdr.cmd] (priv, rxb);
 		} else {
 			/* No handling needed */
-			IWL_DEBUG(IWL_DL_HCMD | IWL_DL_RX | IWL_DL_ISR,
+			IWL_DEBUG(priv, IWL_DL_HCMD | IWL_DL_RX | IWL_DL_ISR,
 				"r %d i %d No handler needed for %s, 0x%02x\n",
 				r, i, get_cmd_string(pkt->hdr.cmd),
 				pkt->hdr.cmd);
@@ -2353,7 +2353,7 @@ static void iwl3945_rx_handle(struct iwl_priv *priv)
 
 static void iwl3945_enable_interrupts(struct iwl_priv *priv)
 {
-	IWL_DEBUG_ISR("Enabling interrupts\n");
+	IWL_DEBUG_ISR(priv, "Enabling interrupts\n");
 	set_bit(STATUS_INT_ENABLED, &priv->status);
 	iwl_write32(priv, CSR_INT_MASK, CSR_INI_SET_MASK);
 }
@@ -2379,7 +2379,7 @@ static inline void iwl3945_disable_interrupts(struct iwl_priv *priv)
 	 * from uCode or flow handler (Rx/Tx DMA) */
 	iwl_write32(priv, CSR_INT, 0xffffffff);
 	iwl_write32(priv, CSR_FH_INT_STATUS, 0xffffffff);
-	IWL_DEBUG_ISR("Disabled interrupts\n");
+	IWL_DEBUG_ISR(priv, "Disabled interrupts\n");
 }
 
 static const char *desc_lookup(int i)
@@ -2604,7 +2604,7 @@ static void iwl3945_irq_tasklet(struct iwl_priv *priv)
 	if (priv->debug_level & IWL_DL_ISR) {
 		/* just for debug */
 		inta_mask = iwl_read32(priv, CSR_INT_MASK);
-		IWL_DEBUG_ISR("inta 0x%08x, enabled 0x%08x, fh 0x%08x\n",
+		IWL_DEBUG_ISR(priv, "inta 0x%08x, enabled 0x%08x, fh 0x%08x\n",
 			      inta, inta_mask, inta_fh);
 	}
 #endif
@@ -2638,12 +2638,12 @@ static void iwl3945_irq_tasklet(struct iwl_priv *priv)
 	if (priv->debug_level & (IWL_DL_ISR)) {
 		/* NIC fires this, but we don't use it, redundant with WAKEUP */
 		if (inta & CSR_INT_BIT_SCD)
-			IWL_DEBUG_ISR("Scheduler finished to transmit "
+			IWL_DEBUG_ISR(priv, "Scheduler finished to transmit "
 				      "the frame/frames.\n");
 
 		/* Alive notification via Rx interrupt will do the real work */
 		if (inta & CSR_INT_BIT_ALIVE)
-			IWL_DEBUG_ISR("Alive interrupt\n");
+			IWL_DEBUG_ISR(priv, "Alive interrupt\n");
 	}
 #endif
 	/* Safely ignore these bits for debug checks below */
@@ -2659,7 +2659,7 @@ static void iwl3945_irq_tasklet(struct iwl_priv *priv)
 
 	/* uCode wakes up after power-down sleep */
 	if (inta & CSR_INT_BIT_WAKEUP) {
-		IWL_DEBUG_ISR("Wakeup interrupt\n");
+		IWL_DEBUG_ISR(priv, "Wakeup interrupt\n");
 		iwl_rx_queue_update_write_ptr(priv, &priv->rxq);
 		iwl_txq_update_write_ptr(priv, &priv->txq[0]);
 		iwl_txq_update_write_ptr(priv, &priv->txq[1]);
@@ -2680,7 +2680,7 @@ static void iwl3945_irq_tasklet(struct iwl_priv *priv)
 	}
 
 	if (inta & CSR_INT_BIT_FH_TX) {
-		IWL_DEBUG_ISR("Tx interrupt\n");
+		IWL_DEBUG_ISR(priv, "Tx interrupt\n");
 
 		iwl_write32(priv, CSR_FH_INT_STATUS, (1 << 6));
 		if (!iwl_grab_nic_access(priv)) {
@@ -2710,7 +2710,7 @@ static void iwl3945_irq_tasklet(struct iwl_priv *priv)
 		inta = iwl_read32(priv, CSR_INT);
 		inta_mask = iwl_read32(priv, CSR_INT_MASK);
 		inta_fh = iwl_read32(priv, CSR_FH_INT_STATUS);
-		IWL_DEBUG_ISR("End inta 0x%08x, enabled 0x%08x, fh 0x%08x, "
+		IWL_DEBUG_ISR(priv, "End inta 0x%08x, enabled 0x%08x, fh 0x%08x, "
 			"flags 0x%08lx\n", inta, inta_mask, inta_fh, flags);
 	}
 #endif
@@ -2742,7 +2742,7 @@ static irqreturn_t iwl3945_isr(int irq, void *data)
 	 * This may be due to IRQ shared with another device,
 	 * or due to sporadic interrupts thrown from our NIC. */
 	if (!inta && !inta_fh) {
-		IWL_DEBUG_ISR("Ignore interrupt, inta == 0, inta_fh == 0\n");
+		IWL_DEBUG_ISR(priv, "Ignore interrupt, inta == 0, inta_fh == 0\n");
 		goto none;
 	}
 
@@ -2752,7 +2752,7 @@ static irqreturn_t iwl3945_isr(int irq, void *data)
 		goto unplugged;
 	}
 
-	IWL_DEBUG_ISR("ISR inta 0x%08x, enabled 0x%08x, fh 0x%08x\n",
+	IWL_DEBUG_ISR(priv, "ISR inta 0x%08x, enabled 0x%08x, fh 0x%08x\n",
 		      inta, inta_mask, inta_fh);
 
 	inta &= ~CSR_INT_BIT_SCD;
@@ -2806,7 +2806,7 @@ static int iwl3945_get_channels_for_scan(struct iwl_priv *priv,
 
 		ch_info = iwl_get_channel_info(priv, band, scan_ch->channel);
 		if (!is_channel_valid(ch_info)) {
-			IWL_DEBUG_SCAN("Channel %d is INVALID for this band.\n",
+			IWL_DEBUG_SCAN(priv, "Channel %d is INVALID for this band.\n",
 				       scan_ch->channel);
 			continue;
 		}
@@ -2854,7 +2854,7 @@ static int iwl3945_get_channels_for_scan(struct iwl_priv *priv,
 			 */
 		}
 
-		IWL_DEBUG_SCAN("Scanning %d [%s %d]\n",
+		IWL_DEBUG_SCAN(priv, "Scanning %d [%s %d]\n",
 			       scan_ch->channel,
 			       (scan_ch->type & 1) ? "ACTIVE" : "PASSIVE",
 			       (scan_ch->type & 1) ?
@@ -2864,7 +2864,7 @@ static int iwl3945_get_channels_for_scan(struct iwl_priv *priv,
 		added++;
 	}
 
-	IWL_DEBUG_SCAN("total channels to scan %d \n", added);
+	IWL_DEBUG_SCAN(priv, "total channels to scan %d \n", added);
 	return added;
 }
 
@@ -2915,7 +2915,7 @@ static int iwl3945_verify_inst_full(struct iwl_priv *priv, __le32 *image, u32 le
 	int rc = 0;
 	u32 errcnt;
 
-	IWL_DEBUG_INFO("ucode inst image size is %u\n", len);
+	IWL_DEBUG_INFO(priv, "ucode inst image size is %u\n", len);
 
 	rc = iwl_grab_nic_access(priv);
 	if (rc)
@@ -2944,7 +2944,8 @@ static int iwl3945_verify_inst_full(struct iwl_priv *priv, __le32 *image, u32 le
 	iwl_release_nic_access(priv);
 
 	if (!errcnt)
-		IWL_DEBUG_INFO("ucode image in INSTRUCTION memory is good\n");
+		IWL_DEBUG_INFO(priv,
+			"ucode image in INSTRUCTION memory is good\n");
 
 	return rc;
 }
@@ -2962,7 +2963,7 @@ static int iwl3945_verify_inst_sparse(struct iwl_priv *priv, __le32 *image, u32
 	u32 errcnt = 0;
 	u32 i;
 
-	IWL_DEBUG_INFO("ucode inst image size is %u\n", len);
+	IWL_DEBUG_INFO(priv, "ucode inst image size is %u\n", len);
 
 	rc = iwl_grab_nic_access(priv);
 	if (rc)
@@ -3009,7 +3010,7 @@ static int iwl3945_verify_ucode(struct iwl_priv *priv)
 	len = priv->ucode_boot.len;
 	rc = iwl3945_verify_inst_sparse(priv, image, len);
 	if (rc == 0) {
-		IWL_DEBUG_INFO("Bootstrap uCode is good in inst SRAM\n");
+		IWL_DEBUG_INFO(priv, "Bootstrap uCode is good in inst SRAM\n");
 		return 0;
 	}
 
@@ -3018,7 +3019,7 @@ static int iwl3945_verify_ucode(struct iwl_priv *priv)
 	len = priv->ucode_init.len;
 	rc = iwl3945_verify_inst_sparse(priv, image, len);
 	if (rc == 0) {
-		IWL_DEBUG_INFO("Initialize uCode is good in inst SRAM\n");
+		IWL_DEBUG_INFO(priv, "Initialize uCode is good in inst SRAM\n");
 		return 0;
 	}
 
@@ -3027,7 +3028,7 @@ static int iwl3945_verify_ucode(struct iwl_priv *priv)
 	len = priv->ucode_code.len;
 	rc = iwl3945_verify_inst_sparse(priv, image, len);
 	if (rc == 0) {
-		IWL_DEBUG_INFO("Runtime uCode is good in inst SRAM\n");
+		IWL_DEBUG_INFO(priv, "Runtime uCode is good in inst SRAM\n");
 		return 0;
 	}
 
@@ -3086,7 +3087,8 @@ static int iwl3945_read_ucode(struct iwl_priv *priv)
 					"which is deprecated. "
 					" Please use API v%u instead.\n",
 					  buf, api_max);
-			IWL_DEBUG_INFO("Got firmware '%s' file (%zd bytes) from disk\n",
+			IWL_DEBUG_INFO(priv, "Got firmware '%s' file "
+				       "(%zd bytes) from disk\n",
 				       buf, ucode_raw->size);
 			break;
 		}
@@ -3137,13 +3139,18 @@ static int iwl3945_read_ucode(struct iwl_priv *priv)
 		IWL_UCODE_API(priv->ucode_ver),
 		IWL_UCODE_SERIAL(priv->ucode_ver));
 
-	IWL_DEBUG_INFO("f/w package hdr ucode version raw = 0x%x\n",
+	IWL_DEBUG_INFO(priv, "f/w package hdr ucode version raw = 0x%x\n",
 		       priv->ucode_ver);
-	IWL_DEBUG_INFO("f/w package hdr runtime inst size = %u\n", inst_size);
-	IWL_DEBUG_INFO("f/w package hdr runtime data size = %u\n", data_size);
-	IWL_DEBUG_INFO("f/w package hdr init inst size = %u\n", init_size);
-	IWL_DEBUG_INFO("f/w package hdr init data size = %u\n", init_data_size);
-	IWL_DEBUG_INFO("f/w package hdr boot inst size = %u\n", boot_size);
+	IWL_DEBUG_INFO(priv, "f/w package hdr runtime inst size = %u\n",
+		       inst_size);
+	IWL_DEBUG_INFO(priv, "f/w package hdr runtime data size = %u\n",
+		       data_size);
+	IWL_DEBUG_INFO(priv, "f/w package hdr init inst size = %u\n",
+		       init_size);
+	IWL_DEBUG_INFO(priv, "f/w package hdr init data size = %u\n",
+		       init_data_size);
+	IWL_DEBUG_INFO(priv, "f/w package hdr boot inst size = %u\n",
+		       boot_size);
 
 
 	/* Verify size of file vs. image size info in file's header */
@@ -3151,40 +3158,43 @@ static int iwl3945_read_ucode(struct iwl_priv *priv)
 		inst_size + data_size + init_size +
 		init_data_size + boot_size) {
 
-		IWL_DEBUG_INFO("uCode file size %d too small\n",
-			       (int)ucode_raw->size);
+		IWL_DEBUG_INFO(priv, "uCode file size %zd too small\n",
+			       ucode_raw->size);
 		ret = -EINVAL;
 		goto err_release;
 	}
 
 	/* Verify that uCode images will fit in card's SRAM */
 	if (inst_size > IWL39_MAX_INST_SIZE) {
-		IWL_DEBUG_INFO("uCode instr len %d too large to fit in\n",
+		IWL_DEBUG_INFO(priv, "uCode instr len %d too large to fit in\n",
 			       inst_size);
 		ret = -EINVAL;
 		goto err_release;
 	}
 
 	if (data_size > IWL39_MAX_DATA_SIZE) {
-		IWL_DEBUG_INFO("uCode data len %d too large to fit in\n",
+		IWL_DEBUG_INFO(priv, "uCode data len %d too large to fit in\n",
 			       data_size);
 		ret = -EINVAL;
 		goto err_release;
 	}
 	if (init_size > IWL39_MAX_INST_SIZE) {
-		IWL_DEBUG_INFO("uCode init instr len %d too large to fit in\n",
+		IWL_DEBUG_INFO(priv,
+				"uCode init instr len %d too large to fit in\n",
 				init_size);
 		ret = -EINVAL;
 		goto err_release;
 	}
 	if (init_data_size > IWL39_MAX_DATA_SIZE) {
-		IWL_DEBUG_INFO("uCode init data len %d too large to fit in\n",
+		IWL_DEBUG_INFO(priv,
+				"uCode init data len %d too large to fit in\n",
 				init_data_size);
 		ret = -EINVAL;
 		goto err_release;
 	}
 	if (boot_size > IWL39_MAX_BSM_SIZE) {
-		IWL_DEBUG_INFO("uCode boot instr len %d too large to fit in\n",
+		IWL_DEBUG_INFO(priv,
+				"uCode boot instr len %d too large to fit in\n",
 				boot_size);
 		ret = -EINVAL;
 		goto err_release;
@@ -3234,16 +3244,18 @@ static int iwl3945_read_ucode(struct iwl_priv *priv)
 	/* Runtime instructions (first block of data in file) */
 	src = &ucode->data[0];
 	len = priv->ucode_code.len;
-	IWL_DEBUG_INFO("Copying (but not loading) uCode instr len %Zd\n", len);
+	IWL_DEBUG_INFO(priv,
+		"Copying (but not loading) uCode instr len %zd\n", len);
 	memcpy(priv->ucode_code.v_addr, src, len);
-	IWL_DEBUG_INFO("uCode instr buf vaddr = 0x%p, paddr = 0x%08x\n",
+	IWL_DEBUG_INFO(priv, "uCode instr buf vaddr = 0x%p, paddr = 0x%08x\n",
 		priv->ucode_code.v_addr, (u32)priv->ucode_code.p_addr);
 
 	/* Runtime data (2nd block)
 	 * NOTE:  Copy into backup buffer will be done in iwl3945_up()  */
 	src = &ucode->data[inst_size];
 	len = priv->ucode_data.len;
-	IWL_DEBUG_INFO("Copying (but not loading) uCode data len %Zd\n", len);
+	IWL_DEBUG_INFO(priv,
+		"Copying (but not loading) uCode data len %zd\n", len);
 	memcpy(priv->ucode_data.v_addr, src, len);
 	memcpy(priv->ucode_data_backup.v_addr, src, len);
 
@@ -3251,8 +3263,8 @@ static int iwl3945_read_ucode(struct iwl_priv *priv)
 	if (init_size) {
 		src = &ucode->data[inst_size + data_size];
 		len = priv->ucode_init.len;
-		IWL_DEBUG_INFO("Copying (but not loading) init instr len %Zd\n",
-			       len);
+		IWL_DEBUG_INFO(priv,
+			"Copying (but not loading) init instr len %zd\n", len);
 		memcpy(priv->ucode_init.v_addr, src, len);
 	}
 
@@ -3260,16 +3272,16 @@ static int iwl3945_read_ucode(struct iwl_priv *priv)
 	if (init_data_size) {
 		src = &ucode->data[inst_size + data_size + init_size];
 		len = priv->ucode_init_data.len;
-		IWL_DEBUG_INFO("Copying (but not loading) init data len %d\n",
-			       (int)len);
+		IWL_DEBUG_INFO(priv,
+			"Copying (but not loading) init data len %zd\n", len);
 		memcpy(priv->ucode_init_data.v_addr, src, len);
 	}
 
 	/* Bootstrap instructions (5th block) */
 	src = &ucode->data[inst_size + data_size + init_size + init_data_size];
 	len = priv->ucode_boot.len;
-	IWL_DEBUG_INFO("Copying (but not loading) boot instr len %d\n",
-		       (int)len);
+	IWL_DEBUG_INFO(priv,
+		"Copying (but not loading) boot instr len %zd\n", len);
 	memcpy(priv->ucode_boot.v_addr, src, len);
 
 	/* We have our copies now, allow OS release its copies */
@@ -3331,7 +3343,7 @@ static int iwl3945_set_ucode_ptrs(struct iwl_priv *priv)
 
 	spin_unlock_irqrestore(&priv->lock, flags);
 
-	IWL_DEBUG_INFO("Runtime uCode pointers are set.\n");
+	IWL_DEBUG_INFO(priv, "Runtime uCode pointers are set.\n");
 
 	return rc;
 }
@@ -3349,7 +3361,7 @@ static void iwl3945_init_alive_start(struct iwl_priv *priv)
 	if (priv->card_alive_init.is_valid != UCODE_VALID_OK) {
 		/* We had an error bringing up the hardware, so take it
 		 * all the way back down so we can try again */
-		IWL_DEBUG_INFO("Initialize Alive failed.\n");
+		IWL_DEBUG_INFO(priv, "Initialize Alive failed.\n");
 		goto restart;
 	}
 
@@ -3359,18 +3371,18 @@ static void iwl3945_init_alive_start(struct iwl_priv *priv)
 	if (iwl3945_verify_ucode(priv)) {
 		/* Runtime instruction load was bad;
 		 * take it all the way back down so we can try again */
-		IWL_DEBUG_INFO("Bad \"initialize\" uCode load.\n");
+		IWL_DEBUG_INFO(priv, "Bad \"initialize\" uCode load.\n");
 		goto restart;
 	}
 
 	/* Send pointers to protocol/runtime uCode image ... init code will
 	 * load and launch runtime uCode, which will send us another "Alive"
 	 * notification. */
-	IWL_DEBUG_INFO("Initialization Alive received.\n");
+	IWL_DEBUG_INFO(priv, "Initialization Alive received.\n");
 	if (iwl3945_set_ucode_ptrs(priv)) {
 		/* Runtime instruction load won't happen;
 		 * take it all the way back down so we can try again */
-		IWL_DEBUG_INFO("Couldn't set up uCode pointers.\n");
+		IWL_DEBUG_INFO(priv, "Couldn't set up uCode pointers.\n");
 		goto restart;
 	}
 	return;
@@ -3395,12 +3407,12 @@ static void iwl3945_alive_start(struct iwl_priv *priv)
 	int thermal_spin = 0;
 	u32 rfkill;
 
-	IWL_DEBUG_INFO("Runtime Alive received.\n");
+	IWL_DEBUG_INFO(priv, "Runtime Alive received.\n");
 
 	if (priv->card_alive.is_valid != UCODE_VALID_OK) {
 		/* We had an error bringing up the hardware, so take it
 		 * all the way back down so we can try again */
-		IWL_DEBUG_INFO("Alive failed.\n");
+		IWL_DEBUG_INFO(priv, "Alive failed.\n");
 		goto restart;
 	}
 
@@ -3410,7 +3422,7 @@ static void iwl3945_alive_start(struct iwl_priv *priv)
 	if (iwl3945_verify_ucode(priv)) {
 		/* Runtime instruction load was bad;
 		 * take it all the way back down so we can try again */
-		IWL_DEBUG_INFO("Bad runtime uCode load.\n");
+		IWL_DEBUG_INFO(priv, "Bad runtime uCode load.\n");
 		goto restart;
 	}
 
@@ -3423,7 +3435,7 @@ static void iwl3945_alive_start(struct iwl_priv *priv)
 	}
 
 	rfkill = iwl_read_prph(priv, APMG_RFKILL_REG);
-	IWL_DEBUG_INFO("RFKILL status: 0x%x\n", rfkill);
+	IWL_DEBUG_INFO(priv, "RFKILL status: 0x%x\n", rfkill);
 	iwl_release_nic_access(priv);
 
 	if (rfkill & 0x1) {
@@ -3436,7 +3448,7 @@ static void iwl3945_alive_start(struct iwl_priv *priv)
 		}
 
 		if (thermal_spin)
-			IWL_DEBUG_INFO("Thermal calibration took %dus\n",
+			IWL_DEBUG_INFO(priv, "Thermal calibration took %dus\n",
 				       thermal_spin * 10);
 	} else
 		set_bit(STATUS_RF_KILL_HW, &priv->status);
@@ -3479,7 +3491,7 @@ static void iwl3945_alive_start(struct iwl_priv *priv)
 
 	iwl3945_led_register(priv);
 
-	IWL_DEBUG_INFO("ALIVE processing complete.\n");
+	IWL_DEBUG_INFO(priv, "ALIVE processing complete.\n");
 	set_bit(STATUS_READY, &priv->status);
 	wake_up_interruptible(&priv->wait_command_queue);
 
@@ -3508,7 +3520,7 @@ static void __iwl3945_down(struct iwl_priv *priv)
 	int exit_pending = test_bit(STATUS_EXIT_PENDING, &priv->status);
 	struct ieee80211_conf *conf = NULL;
 
-	IWL_DEBUG_INFO(DRV_NAME " is going down\n");
+	IWL_DEBUG_INFO(priv, DRV_NAME " is going down\n");
 
 	conf = ieee80211_get_hw_conf(priv->hw);
 
@@ -3695,7 +3707,7 @@ static int __iwl3945_up(struct iwl_priv *priv)
 		/* start card; "initialize" will load runtime ucode */
 		iwl3945_nic_start(priv);
 
-		IWL_DEBUG_INFO(DRV_NAME " is coming up\n");
+		IWL_DEBUG_INFO(priv, DRV_NAME " is coming up\n");
 
 		return 0;
 	}
@@ -3796,34 +3808,36 @@ static void iwl3945_bg_request_scan(struct work_struct *data)
 	/* This should never be called or scheduled if there is currently
 	 * a scan active in the hardware. */
 	if (test_bit(STATUS_SCAN_HW, &priv->status)) {
-		IWL_DEBUG_INFO("Multiple concurrent scan requests in parallel. "
-			       "Ignoring second request.\n");
+		IWL_DEBUG_INFO(priv, "Multiple concurrent scan requests  "
+				"Ignoring second request.\n");
 		rc = -EIO;
 		goto done;
 	}
 
 	if (test_bit(STATUS_EXIT_PENDING, &priv->status)) {
-		IWL_DEBUG_SCAN("Aborting scan due to device shutdown\n");
+		IWL_DEBUG_SCAN(priv, "Aborting scan due to device shutdown\n");
 		goto done;
 	}
 
 	if (test_bit(STATUS_SCAN_ABORTING, &priv->status)) {
-		IWL_DEBUG_HC("Scan request while abort pending.  Queuing.\n");
+		IWL_DEBUG_HC(priv,
+			"Scan request while abort pending. Queuing.\n");
 		goto done;
 	}
 
 	if (iwl_is_rfkill(priv)) {
-		IWL_DEBUG_HC("Aborting scan due to RF Kill activation\n");
+		IWL_DEBUG_HC(priv, "Aborting scan due to RF Kill activation\n");
 		goto done;
 	}
 
 	if (!test_bit(STATUS_READY, &priv->status)) {
-		IWL_DEBUG_HC("Scan request while uninitialized.  Queuing.\n");
+		IWL_DEBUG_HC(priv,
+			"Scan request while uninitialized. Queuing.\n");
 		goto done;
 	}
 
 	if (!priv->scan_bands) {
-		IWL_DEBUG_HC("Aborting scan due to no requested bands\n");
+		IWL_DEBUG_HC(priv, "Aborting scan due to no requested bands\n");
 		goto done;
 	}
 
@@ -3848,7 +3862,7 @@ static void iwl3945_bg_request_scan(struct work_struct *data)
 		u32 scan_suspend_time = 100;
 		unsigned long flags;
 
-		IWL_DEBUG_INFO("Scanning while associated...\n");
+		IWL_DEBUG_INFO(priv, "Scanning while associated...\n");
 
 		spin_lock_irqsave(&priv->lock, flags);
 		interval = priv->beacon_int;
@@ -3870,15 +3884,14 @@ static void iwl3945_bg_request_scan(struct work_struct *data)
 		    (extra | ((suspend_time % interval) * 1024));
 
 		scan->suspend_time = cpu_to_le32(scan_suspend_time);
-		IWL_DEBUG_SCAN("suspend_time 0x%X beacon interval %d\n",
+		IWL_DEBUG_SCAN(priv, "suspend_time 0x%X beacon interval %d\n",
 			       scan_suspend_time, interval);
 	}
 
 	/* We should add the ability for user to lock to PASSIVE ONLY */
 	if (priv->one_direct_scan) {
-		IWL_DEBUG_SCAN
-		    ("Kicking off one direct scan for '%s'\n",
-		     print_ssid(ssid, priv->direct_ssid,
+		IWL_DEBUG_SCAN(priv, "Kicking off one direct scan for '%s'\n",
+				print_ssid(ssid, priv->direct_ssid,
 				priv->direct_ssid_len));
 		scan->direct_scan[0].id = WLAN_EID_SSID;
 		scan->direct_scan[0].len = priv->direct_ssid_len;
@@ -3886,7 +3899,7 @@ static void iwl3945_bg_request_scan(struct work_struct *data)
 		       priv->direct_ssid, priv->direct_ssid_len);
 		n_probes++;
 	} else
-		IWL_DEBUG_SCAN("Kicking off one indirect scan.\n");
+		IWL_DEBUG_SCAN(priv, "Kicking off one indirect scan.\n");
 
 	/* We don't build a direct scan probe request; the uCode will do
 	 * that based on the direct_mask added to each channel entry */
@@ -3927,7 +3940,7 @@ static void iwl3945_bg_request_scan(struct work_struct *data)
 			(void *)&scan->data[le16_to_cpu(scan->tx_cmd.len)]);
 
 	if (scan->channel_count == 0) {
-		IWL_DEBUG_SCAN("channel count %d\n", scan->channel_count);
+		IWL_DEBUG_SCAN(priv, "channel count %d\n", scan->channel_count);
 		goto done;
 	}
 
@@ -4011,7 +4024,7 @@ static void iwl3945_post_associate(struct iwl_priv *priv)
 	}
 
 
-	IWL_DEBUG_ASSOC("Associated as %d to: %pM\n",
+	IWL_DEBUG_ASSOC(priv, "Associated as %d to: %pM\n",
 			priv->assoc_id, priv->active_rxon.bssid_addr);
 
 	if (test_bit(STATUS_EXIT_PENDING, &priv->status))
@@ -4039,7 +4052,7 @@ static void iwl3945_post_associate(struct iwl_priv *priv)
 
 	priv->staging_rxon.assoc_id = cpu_to_le16(priv->assoc_id);
 
-	IWL_DEBUG_ASSOC("assoc id %d beacon interval %d\n",
+	IWL_DEBUG_ASSOC(priv, "assoc id %d beacon interval %d\n",
 			priv->assoc_id, priv->beacon_int);
 
 	if (priv->assoc_capability & WLAN_CAPABILITY_SHORT_PREAMBLE)
@@ -4105,7 +4118,7 @@ static int iwl3945_mac_start(struct ieee80211_hw *hw)
 	struct iwl_priv *priv = hw->priv;
 	int ret;
 
-	IWL_DEBUG_MAC80211("enter\n");
+	IWL_DEBUG_MAC80211(priv, "enter\n");
 
 	/* we should be verifying the device is ready to be opened */
 	mutex_lock(&priv->mutex);
@@ -4132,7 +4145,7 @@ static int iwl3945_mac_start(struct ieee80211_hw *hw)
 	if (ret)
 		goto out_release_irq;
 
-	IWL_DEBUG_INFO("Start UP work.\n");
+	IWL_DEBUG_INFO(priv, "Start UP work.\n");
 
 	if (test_bit(STATUS_IN_SUSPEND, &priv->status))
 		return 0;
@@ -4157,12 +4170,12 @@ static int iwl3945_mac_start(struct ieee80211_hw *hw)
 	cancel_delayed_work(&priv->rfkill_poll);
 
 	priv->is_open = 1;
-	IWL_DEBUG_MAC80211("leave\n");
+	IWL_DEBUG_MAC80211(priv, "leave\n");
 	return 0;
 
 out_release_irq:
 	priv->is_open = 0;
-	IWL_DEBUG_MAC80211("leave - failed\n");
+	IWL_DEBUG_MAC80211(priv, "leave - failed\n");
 	return ret;
 }
 
@@ -4170,10 +4183,10 @@ static void iwl3945_mac_stop(struct ieee80211_hw *hw)
 {
 	struct iwl_priv *priv = hw->priv;
 
-	IWL_DEBUG_MAC80211("enter\n");
+	IWL_DEBUG_MAC80211(priv, "enter\n");
 
 	if (!priv->is_open) {
-		IWL_DEBUG_MAC80211("leave - skip\n");
+		IWL_DEBUG_MAC80211(priv, "leave - skip\n");
 		return;
 	}
 
@@ -4196,22 +4209,22 @@ static void iwl3945_mac_stop(struct ieee80211_hw *hw)
 	queue_delayed_work(priv->workqueue, &priv->rfkill_poll,
 			   round_jiffies_relative(2 * HZ));
 
-	IWL_DEBUG_MAC80211("leave\n");
+	IWL_DEBUG_MAC80211(priv, "leave\n");
 }
 
 static int iwl3945_mac_tx(struct ieee80211_hw *hw, struct sk_buff *skb)
 {
 	struct iwl_priv *priv = hw->priv;
 
-	IWL_DEBUG_MAC80211("enter\n");
+	IWL_DEBUG_MAC80211(priv, "enter\n");
 
-	IWL_DEBUG_TX("dev->xmit(%d bytes) at rate 0x%02x\n", skb->len,
+	IWL_DEBUG_TX(priv, "dev->xmit(%d bytes) at rate 0x%02x\n", skb->len,
 		     ieee80211_get_tx_rate(hw, IEEE80211_SKB_CB(skb))->bitrate);
 
 	if (iwl3945_tx_skb(priv, skb))
 		dev_kfree_skb_any(skb);
 
-	IWL_DEBUG_MAC80211("leave\n");
+	IWL_DEBUG_MAC80211(priv, "leave\n");
 	return NETDEV_TX_OK;
 }
 
@@ -4221,10 +4234,10 @@ static int iwl3945_mac_add_interface(struct ieee80211_hw *hw,
 	struct iwl_priv *priv = hw->priv;
 	unsigned long flags;
 
-	IWL_DEBUG_MAC80211("enter: type %d\n", conf->type);
+	IWL_DEBUG_MAC80211(priv, "enter: type %d\n", conf->type);
 
 	if (priv->vif) {
-		IWL_DEBUG_MAC80211("leave - vif != NULL\n");
+		IWL_DEBUG_MAC80211(priv, "leave - vif != NULL\n");
 		return -EOPNOTSUPP;
 	}
 
@@ -4237,7 +4250,7 @@ static int iwl3945_mac_add_interface(struct ieee80211_hw *hw,
 	mutex_lock(&priv->mutex);
 
 	if (conf->mac_addr) {
-		IWL_DEBUG_MAC80211("Set: %pM\n", conf->mac_addr);
+		IWL_DEBUG_MAC80211(priv, "Set: %pM\n", conf->mac_addr);
 		memcpy(priv->mac_addr, conf->mac_addr, ETH_ALEN);
 	}
 
@@ -4246,7 +4259,7 @@ static int iwl3945_mac_add_interface(struct ieee80211_hw *hw,
 
 	mutex_unlock(&priv->mutex);
 
-	IWL_DEBUG_MAC80211("leave\n");
+	IWL_DEBUG_MAC80211(priv, "leave\n");
 	return 0;
 }
 
@@ -4266,17 +4279,18 @@ static int iwl3945_mac_config(struct ieee80211_hw *hw, u32 changed)
 	int ret = 0;
 
 	mutex_lock(&priv->mutex);
-	IWL_DEBUG_MAC80211("enter to channel %d\n", conf->channel->hw_value);
+	IWL_DEBUG_MAC80211(priv, "enter to channel %d\n",
+				conf->channel->hw_value);
 
 	if (!iwl_is_ready(priv)) {
-		IWL_DEBUG_MAC80211("leave - not ready\n");
+		IWL_DEBUG_MAC80211(priv, "leave - not ready\n");
 		ret = -EIO;
 		goto out;
 	}
 
 	if (unlikely(!iwl3945_mod_params.disable_hw_scan &&
 		     test_bit(STATUS_SCANNING, &priv->status))) {
-		IWL_DEBUG_MAC80211("leave - scanning\n");
+		IWL_DEBUG_MAC80211(priv, "leave - scanning\n");
 		set_bit(STATUS_CONF_PENDING, &priv->status);
 		mutex_unlock(&priv->mutex);
 		return 0;
@@ -4287,9 +4301,10 @@ static int iwl3945_mac_config(struct ieee80211_hw *hw, u32 changed)
 	ch_info = iwl_get_channel_info(priv, conf->channel->band,
 				       conf->channel->hw_value);
 	if (!is_channel_valid(ch_info)) {
-		IWL_DEBUG_SCAN("Channel %d [%d] is INVALID for this band.\n",
-			       conf->channel->hw_value, conf->channel->band);
-		IWL_DEBUG_MAC80211("leave - invalid channel\n");
+		IWL_DEBUG_SCAN(priv,
+				"Channel %d [%d] is INVALID for this band.\n",
+				conf->channel->hw_value, conf->channel->band);
+		IWL_DEBUG_MAC80211(priv, "leave - invalid channel\n");
 		spin_unlock_irqrestore(&priv->lock, flags);
 		ret = -EINVAL;
 		goto out;
@@ -4316,12 +4331,12 @@ static int iwl3945_mac_config(struct ieee80211_hw *hw, u32 changed)
 	iwl3945_radio_kill_sw(priv, !conf->radio_enabled);
 
 	if (!conf->radio_enabled) {
-		IWL_DEBUG_MAC80211("leave - radio disabled\n");
+		IWL_DEBUG_MAC80211(priv, "leave - radio disabled\n");
 		goto out;
 	}
 
 	if (iwl_is_rfkill(priv)) {
-		IWL_DEBUG_MAC80211("leave - RF kill\n");
+		IWL_DEBUG_MAC80211(priv, "leave - RF kill\n");
 		ret = -EIO;
 		goto out;
 	}
@@ -4332,9 +4347,9 @@ static int iwl3945_mac_config(struct ieee80211_hw *hw, u32 changed)
 		   &priv->staging_rxon, sizeof(priv->staging_rxon)))
 		iwl3945_commit_rxon(priv);
 	else
-		IWL_DEBUG_INFO("No re-sending same RXON configuration.\n");
+		IWL_DEBUG_INFO(priv, "Not re-sending same RXON configuration\n");
 
-	IWL_DEBUG_MAC80211("leave\n");
+	IWL_DEBUG_MAC80211(priv, "leave\n");
 
 out:
 	clear_bit(STATUS_CONF_PENDING, &priv->status);
@@ -4411,7 +4426,7 @@ static int iwl3945_mac_config_interface(struct ieee80211_hw *hw,
 		return -EIO;
 
 	if (priv->vif != vif) {
-		IWL_DEBUG_MAC80211("leave - priv->vif != vif\n");
+		IWL_DEBUG_MAC80211(priv, "leave - priv->vif != vif\n");
 		return 0;
 	}
 
@@ -4434,7 +4449,7 @@ static int iwl3945_mac_config_interface(struct ieee80211_hw *hw,
 	mutex_lock(&priv->mutex);
 
 	if (conf->bssid)
-		IWL_DEBUG_MAC80211("bssid: %pM\n", conf->bssid);
+		IWL_DEBUG_MAC80211(priv, "bssid: %pM\n", conf->bssid);
 
 /*
  * very dubious code was here; the probe filtering flag is never set:
@@ -4447,7 +4462,7 @@ static int iwl3945_mac_config_interface(struct ieee80211_hw *hw,
 		if (!conf->bssid) {
 			conf->bssid = priv->mac_addr;
 			memcpy(priv->bssid, priv->mac_addr, ETH_ALEN);
-			IWL_DEBUG_MAC80211("bssid was set to: %pM\n",
+			IWL_DEBUG_MAC80211(priv, "bssid was set to: %pM\n",
 					   conf->bssid);
 		}
 		if (priv->ibss_beacon)
@@ -4466,7 +4481,7 @@ static int iwl3945_mac_config_interface(struct ieee80211_hw *hw,
 		if (iwl_scan_cancel_timeout(priv, 100)) {
 			IWL_WARN(priv, "Aborted scan still in progress "
 				    "after 100ms\n");
-			IWL_DEBUG_MAC80211("leaving - scan abort failed.\n");
+			IWL_DEBUG_MAC80211(priv, "leaving:scan abort failed\n");
 			mutex_unlock(&priv->mutex);
 			return -EAGAIN;
 		}
@@ -4494,7 +4509,7 @@ static int iwl3945_mac_config_interface(struct ieee80211_hw *hw,
 	}
 
  done:
-	IWL_DEBUG_MAC80211("leave\n");
+	IWL_DEBUG_MAC80211(priv, "leave\n");
 	mutex_unlock(&priv->mutex);
 
 	return 0;
@@ -4505,7 +4520,7 @@ static void iwl3945_mac_remove_interface(struct ieee80211_hw *hw,
 {
 	struct iwl_priv *priv = hw->priv;
 
-	IWL_DEBUG_MAC80211("enter\n");
+	IWL_DEBUG_MAC80211(priv, "enter\n");
 
 	mutex_lock(&priv->mutex);
 
@@ -4520,7 +4535,7 @@ static void iwl3945_mac_remove_interface(struct ieee80211_hw *hw,
 	}
 	mutex_unlock(&priv->mutex);
 
-	IWL_DEBUG_MAC80211("leave\n");
+	IWL_DEBUG_MAC80211(priv, "leave\n");
 }
 
 #define IWL_DELAY_NEXT_SCAN_AFTER_ASSOC (HZ*6)
@@ -4532,10 +4547,10 @@ static void iwl3945_bss_info_changed(struct ieee80211_hw *hw,
 {
 	struct iwl_priv *priv = hw->priv;
 
-	IWL_DEBUG_MAC80211("changes = 0x%X\n", changes);
+	IWL_DEBUG_MAC80211(priv, "changes = 0x%X\n", changes);
 
 	if (changes & BSS_CHANGED_ERP_PREAMBLE) {
-		IWL_DEBUG_MAC80211("ERP_PREAMBLE %d\n",
+		IWL_DEBUG_MAC80211(priv, "ERP_PREAMBLE %d\n",
 				   bss_conf->use_short_preamble);
 		if (bss_conf->use_short_preamble)
 			priv->staging_rxon.flags |= RXON_FLG_SHORT_PREAMBLE_MSK;
@@ -4545,7 +4560,8 @@ static void iwl3945_bss_info_changed(struct ieee80211_hw *hw,
 	}
 
 	if (changes & BSS_CHANGED_ERP_CTS_PROT) {
-		IWL_DEBUG_MAC80211("ERP_CTS %d\n", bss_conf->use_cts_prot);
+		IWL_DEBUG_MAC80211(priv, "ERP_CTS %d\n",
+				   bss_conf->use_cts_prot);
 		if (bss_conf->use_cts_prot && (priv->band != IEEE80211_BAND_5GHZ))
 			priv->staging_rxon.flags |= RXON_FLG_TGG_PROTECT_MSK;
 		else
@@ -4553,7 +4569,7 @@ static void iwl3945_bss_info_changed(struct ieee80211_hw *hw,
 	}
 
 	if (changes & BSS_CHANGED_ASSOC) {
-		IWL_DEBUG_MAC80211("ASSOC %d\n", bss_conf->assoc);
+		IWL_DEBUG_MAC80211(priv, "ASSOC %d\n", bss_conf->assoc);
 		/* This should never happen as this function should
 		 * never be called from interrupt context. */
 		if (WARN_ON_ONCE(in_interrupt()))
@@ -4571,10 +4587,12 @@ static void iwl3945_bss_info_changed(struct ieee80211_hw *hw,
 			mutex_unlock(&priv->mutex);
 		} else {
 			priv->assoc_id = 0;
-			IWL_DEBUG_MAC80211("DISASSOC %d\n", bss_conf->assoc);
+			IWL_DEBUG_MAC80211(priv,
+					"DISASSOC %d\n", bss_conf->assoc);
 		}
 	} else if (changes && iwl_is_associated(priv) && priv->assoc_id) {
-			IWL_DEBUG_MAC80211("Associated Changes %d\n", changes);
+			IWL_DEBUG_MAC80211(priv,
+					"Associated Changes %d\n", changes);
 			iwl3945_send_rxon_assoc(priv);
 	}
 
@@ -4587,14 +4605,14 @@ static int iwl3945_mac_hw_scan(struct ieee80211_hw *hw, u8 *ssid, size_t len)
 	struct iwl_priv *priv = hw->priv;
 	DECLARE_SSID_BUF(ssid_buf);
 
-	IWL_DEBUG_MAC80211("enter\n");
+	IWL_DEBUG_MAC80211(priv, "enter\n");
 
 	mutex_lock(&priv->mutex);
 	spin_lock_irqsave(&priv->lock, flags);
 
 	if (!iwl_is_ready_rf(priv)) {
 		rc = -EIO;
-		IWL_DEBUG_MAC80211("leave - not ready or exit pending\n");
+		IWL_DEBUG_MAC80211(priv, "leave - not ready or exit pending\n");
 		goto out_unlock;
 	}
 
@@ -4612,8 +4630,8 @@ static int iwl3945_mac_hw_scan(struct ieee80211_hw *hw, u8 *ssid, size_t len)
 		goto out_unlock;
 	}
 	if (len) {
-		IWL_DEBUG_SCAN("direct scan for %s [%d]\n ",
-			       print_ssid(ssid_buf, ssid, len), (int)len);
+		IWL_DEBUG_SCAN(priv, "direct scan for %s [%zd]\n ",
+			       print_ssid(ssid_buf, ssid, len), len);
 
 		priv->one_direct_scan = 1;
 		priv->direct_ssid_len = (u8)
@@ -4624,7 +4642,7 @@ static int iwl3945_mac_hw_scan(struct ieee80211_hw *hw, u8 *ssid, size_t len)
 
 	rc = iwl3945_scan_initiate(priv);
 
-	IWL_DEBUG_MAC80211("leave\n");
+	IWL_DEBUG_MAC80211(priv, "leave\n");
 
 out_unlock:
 	spin_unlock_irqrestore(&priv->lock, flags);
@@ -4643,17 +4661,17 @@ static int iwl3945_mac_set_key(struct ieee80211_hw *hw, enum set_key_cmd cmd,
 	int ret;
 	u8 sta_id;
 
-	IWL_DEBUG_MAC80211("enter\n");
+	IWL_DEBUG_MAC80211(priv, "enter\n");
 
 	if (iwl3945_mod_params.sw_crypto) {
-		IWL_DEBUG_MAC80211("leave - hwcrypto disabled\n");
+		IWL_DEBUG_MAC80211(priv, "leave - hwcrypto disabled\n");
 		return -EOPNOTSUPP;
 	}
 
 	addr = sta ? sta->addr : iwl_bcast_addr;
 	sta_id = iwl3945_hw_find_station(priv, addr);
 	if (sta_id == IWL_INVALID_STATION) {
-		IWL_DEBUG_MAC80211("leave - %pM not in station map.\n",
+		IWL_DEBUG_MAC80211(priv, "leave - %pM not in station map.\n",
 				   addr);
 		return -EINVAL;
 	}
@@ -4669,7 +4687,8 @@ static int iwl3945_mac_set_key(struct ieee80211_hw *hw, enum set_key_cmd cmd,
 			iwl_set_rxon_hwcrypto(priv, 1);
 			iwl3945_commit_rxon(priv);
 			key->hw_key_idx = sta_id;
-			IWL_DEBUG_MAC80211("set_key success, using hwcrypto\n");
+			IWL_DEBUG_MAC80211(priv,
+				"set_key success, using hwcrypto\n");
 			key->flags |= IEEE80211_KEY_FLAG_GENERATE_IV;
 		}
 		break;
@@ -4678,14 +4697,14 @@ static int iwl3945_mac_set_key(struct ieee80211_hw *hw, enum set_key_cmd cmd,
 		if (!ret) {
 			iwl_set_rxon_hwcrypto(priv, 0);
 			iwl3945_commit_rxon(priv);
-			IWL_DEBUG_MAC80211("disable hwcrypto key\n");
+			IWL_DEBUG_MAC80211(priv, "disable hwcrypto key\n");
 		}
 		break;
 	default:
 		ret = -EINVAL;
 	}
 
-	IWL_DEBUG_MAC80211("leave\n");
+	IWL_DEBUG_MAC80211(priv, "leave\n");
 	mutex_unlock(&priv->mutex);
 
 	return ret;
@@ -4698,15 +4717,15 @@ static int iwl3945_mac_conf_tx(struct ieee80211_hw *hw, u16 queue,
 	unsigned long flags;
 	int q;
 
-	IWL_DEBUG_MAC80211("enter\n");
+	IWL_DEBUG_MAC80211(priv, "enter\n");
 
 	if (!iwl_is_ready_rf(priv)) {
-		IWL_DEBUG_MAC80211("leave - RF not ready\n");
+		IWL_DEBUG_MAC80211(priv, "leave - RF not ready\n");
 		return -EIO;
 	}
 
 	if (queue >= AC_NUM) {
-		IWL_DEBUG_MAC80211("leave - queue >= AC_NUM %d\n", queue);
+		IWL_DEBUG_MAC80211(priv, "leave - queue >= AC_NUM %d\n", queue);
 		return 0;
 	}
 
@@ -4733,7 +4752,7 @@ static int iwl3945_mac_conf_tx(struct ieee80211_hw *hw, u16 queue,
 
 	mutex_unlock(&priv->mutex);
 
-	IWL_DEBUG_MAC80211("leave\n");
+	IWL_DEBUG_MAC80211(priv, "leave\n");
 	return 0;
 }
 
@@ -4746,10 +4765,10 @@ static int iwl3945_mac_get_tx_stats(struct ieee80211_hw *hw,
 	struct iwl_queue *q;
 	unsigned long flags;
 
-	IWL_DEBUG_MAC80211("enter\n");
+	IWL_DEBUG_MAC80211(priv, "enter\n");
 
 	if (!iwl_is_ready_rf(priv)) {
-		IWL_DEBUG_MAC80211("leave - RF not ready\n");
+		IWL_DEBUG_MAC80211(priv, "leave - RF not ready\n");
 		return -EIO;
 	}
 
@@ -4767,7 +4786,7 @@ static int iwl3945_mac_get_tx_stats(struct ieee80211_hw *hw,
 	}
 	spin_unlock_irqrestore(&priv->lock, flags);
 
-	IWL_DEBUG_MAC80211("leave\n");
+	IWL_DEBUG_MAC80211(priv, "leave\n");
 
 	return 0;
 }
@@ -4778,7 +4797,7 @@ static void iwl3945_mac_reset_tsf(struct ieee80211_hw *hw)
 	unsigned long flags;
 
 	mutex_lock(&priv->mutex);
-	IWL_DEBUG_MAC80211("enter\n");
+	IWL_DEBUG_MAC80211(priv, "enter\n");
 
 	iwl_reset_qos(priv);
 
@@ -4800,7 +4819,7 @@ static void iwl3945_mac_reset_tsf(struct ieee80211_hw *hw)
 	spin_unlock_irqrestore(&priv->lock, flags);
 
 	if (!iwl_is_ready_rf(priv)) {
-		IWL_DEBUG_MAC80211("leave - not ready\n");
+		IWL_DEBUG_MAC80211(priv, "leave - not ready\n");
 		mutex_unlock(&priv->mutex);
 		return;
 	}
@@ -4817,7 +4836,7 @@ static void iwl3945_mac_reset_tsf(struct ieee80211_hw *hw)
 	/* Per mac80211.h: This is only used in IBSS mode... */
 	if (priv->iw_mode != NL80211_IFTYPE_ADHOC) {
 
-		IWL_DEBUG_MAC80211("leave - not in IBSS\n");
+		IWL_DEBUG_MAC80211(priv, "leave - not in IBSS\n");
 		mutex_unlock(&priv->mutex);
 		return;
 	}
@@ -4826,7 +4845,7 @@ static void iwl3945_mac_reset_tsf(struct ieee80211_hw *hw)
 
 	mutex_unlock(&priv->mutex);
 
-	IWL_DEBUG_MAC80211("leave\n");
+	IWL_DEBUG_MAC80211(priv, "leave\n");
 
 }
 
@@ -4835,15 +4854,15 @@ static int iwl3945_mac_beacon_update(struct ieee80211_hw *hw, struct sk_buff *sk
 	struct iwl_priv *priv = hw->priv;
 	unsigned long flags;
 
-	IWL_DEBUG_MAC80211("enter\n");
+	IWL_DEBUG_MAC80211(priv, "enter\n");
 
 	if (!iwl_is_ready_rf(priv)) {
-		IWL_DEBUG_MAC80211("leave - RF not ready\n");
+		IWL_DEBUG_MAC80211(priv, "leave - RF not ready\n");
 		return -EIO;
 	}
 
 	if (priv->iw_mode != NL80211_IFTYPE_ADHOC) {
-		IWL_DEBUG_MAC80211("leave - not IBSS\n");
+		IWL_DEBUG_MAC80211(priv, "leave - not IBSS\n");
 		return -EIO;
 	}
 
@@ -4856,7 +4875,7 @@ static int iwl3945_mac_beacon_update(struct ieee80211_hw *hw, struct sk_buff *sk
 
 	priv->assoc_id = 0;
 
-	IWL_DEBUG_MAC80211("leave\n");
+	IWL_DEBUG_MAC80211(priv, "leave\n");
 	spin_unlock_irqrestore(&priv->lock, flags);
 
 	iwl_reset_qos(priv);
@@ -4971,7 +4990,7 @@ static ssize_t store_flags(struct device *d,
 		if (iwl_scan_cancel_timeout(priv, 100))
 			IWL_WARN(priv, "Could not cancel scan.\n");
 		else {
-			IWL_DEBUG_INFO("Committing rxon.flags = 0x%04X\n",
+			IWL_DEBUG_INFO(priv, "Committing rxon.flags = 0x%04X\n",
 				       flags);
 			priv->staging_rxon.flags = cpu_to_le32(flags);
 			iwl3945_commit_rxon(priv);
@@ -5006,7 +5025,7 @@ static ssize_t store_filter_flags(struct device *d,
 		if (iwl_scan_cancel_timeout(priv, 100))
 			IWL_WARN(priv, "Could not cancel scan.\n");
 		else {
-			IWL_DEBUG_INFO("Committing rxon.filter_flags = "
+			IWL_DEBUG_INFO(priv, "Committing rxon.filter_flags = "
 				       "0x%04X\n", filter_flags);
 			priv->staging_rxon.filter_flags =
 				cpu_to_le32(filter_flags);
@@ -5083,7 +5102,7 @@ static ssize_t store_measurement(struct device *d,
 			type = simple_strtoul(p + 1, NULL, 0);
 	}
 
-	IWL_DEBUG_INFO("Invoking measurement of type %d on "
+	IWL_DEBUG_INFO(priv, "Invoking measurement of type %d on "
 		       "channel %d (for '%s')\n", type, params.channel, buf);
 	iwl3945_get_measurement(priv, &params, type);
 
@@ -5142,7 +5161,7 @@ static ssize_t store_power_level(struct device *d,
 	if (mode != priv->power_mode) {
 		rc = iwl3945_send_power_mode(priv, IWL_POWER_LEVEL(mode));
 		if (rc) {
-			IWL_DEBUG_MAC80211("failed setting power mode.\n");
+			IWL_DEBUG_MAC80211(priv, "failed setting power mode\n");
 			goto out;
 		}
 		priv->power_mode = mode;
@@ -5277,15 +5296,15 @@ static ssize_t store_antenna(struct device *d,
 		return 0;
 
 	if (sscanf(buf, "%1i", &ant) != 1) {
-		IWL_DEBUG_INFO("not in hex or decimal form.\n");
+		IWL_DEBUG_INFO(priv, "not in hex or decimal form.\n");
 		return count;
 	}
 
 	if ((ant >= 0) && (ant <= 2)) {
-		IWL_DEBUG_INFO("Setting antenna select to %d.\n", ant);
+		IWL_DEBUG_INFO(priv, "Setting antenna select to %d.\n", ant);
 		iwl3945_mod_params.antenna = (enum iwl3945_antenna)ant;
 	} else
-		IWL_DEBUG_INFO("Bad antenna select value %d.\n", ant);
+		IWL_DEBUG_INFO(priv, "Bad antenna select value %d.\n", ant);
 
 
 	return count;
@@ -5532,12 +5551,12 @@ static int iwl3945_pci_probe(struct pci_dev *pdev, const struct pci_device_id *e
 	 * "the hard way", rather than using device's scan.
 	 */
 	if (iwl3945_mod_params.disable_hw_scan) {
-		IWL_DEBUG_INFO("Disabling hw_scan\n");
+		IWL_DEBUG_INFO(priv, "Disabling hw_scan\n");
 		iwl3945_hw_ops.hw_scan = NULL;
 	}
 
 
-	IWL_DEBUG_INFO("*** LOAD DRIVER ***\n");
+	IWL_DEBUG_INFO(priv, "*** LOAD DRIVER ***\n");
 	priv->cfg = cfg;
 	priv->pci_dev = pdev;
 
@@ -5593,9 +5612,9 @@ static int iwl3945_pci_probe(struct pci_dev *pdev, const struct pci_device_id *e
 		goto out_pci_release_regions;
 	}
 
-	IWL_DEBUG_INFO("pci_resource_len = 0x%08llx\n",
+	IWL_DEBUG_INFO(priv, "pci_resource_len = 0x%08llx\n",
 			(unsigned long long) pci_resource_len(pdev, 0));
-	IWL_DEBUG_INFO("pci_resource_base = %p\n", priv->hw_base);
+	IWL_DEBUG_INFO(priv, "pci_resource_base = %p\n", priv->hw_base);
 
 	/* We disable the RETRY_TIMEOUT register (0x41) to keep
 	 * PCI Tx retries from interfering with C3 CPU state */
@@ -5604,7 +5623,7 @@ static int iwl3945_pci_probe(struct pci_dev *pdev, const struct pci_device_id *e
 	/* amp init */
 	err = priv->cfg->ops->lib->apm_ops.init(priv);
 	if (err < 0) {
-		IWL_DEBUG_INFO("Failed to init APMG\n");
+		IWL_DEBUG_INFO(priv, "Failed to init APMG\n");
 		goto out_iounmap;
 	}
 
@@ -5621,7 +5640,7 @@ static int iwl3945_pci_probe(struct pci_dev *pdev, const struct pci_device_id *e
 	/* MAC Address location in EEPROM same for 3945/4965 */
 	eeprom = (struct iwl3945_eeprom *)priv->eeprom;
 	memcpy(priv->mac_addr, eeprom->mac_address, ETH_ALEN);
-	IWL_DEBUG_INFO("MAC address: %pM\n", priv->mac_addr);
+	IWL_DEBUG_INFO(priv, "MAC address: %pM\n", priv->mac_addr);
 	SET_IEEE80211_PERM_ADDR(priv->hw, priv->mac_addr);
 
 	/***********************
@@ -5654,7 +5673,7 @@ static int iwl3945_pci_probe(struct pci_dev *pdev, const struct pci_device_id *e
 	/* Disable radio (SW RF KILL) via parameter when loading driver */
 	if (iwl3945_mod_params.disable) {
 		set_bit(STATUS_RF_KILL_SW, &priv->status);
-		IWL_DEBUG_INFO("Radio disabled.\n");
+		IWL_DEBUG_INFO(priv, "Radio disabled.\n");
 	}
 
 
@@ -5743,7 +5762,7 @@ static void __devexit iwl3945_pci_remove(struct pci_dev *pdev)
 	if (!priv)
 		return;
 
-	IWL_DEBUG_INFO("*** UNLOAD DRIVER ***\n");
+	IWL_DEBUG_INFO(priv, "*** UNLOAD DRIVER ***\n");
 
 	set_bit(STATUS_EXIT_PENDING, &priv->status);
 
-- 
1.5.4.3

