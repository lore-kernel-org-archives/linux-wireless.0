Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga09.intel.com ([134.134.136.24]:21225 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1161383Ab2COU2D (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 15 Mar 2012 16:28:03 -0400
From: Wey-Yi Guy <wey-yi.w.guy@intel.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org,
	Johannes Berg <johannes.berg@intel.com>,
	Wey-Yi Guy <wey-yi.w.guy@intel.com>
Subject: [PATCH 06/26] iwlwifi: add trailing newline to various messages
Date: Thu, 15 Mar 2012 13:26:46 -0700
Message-Id: <1331843226-29860-7-git-send-email-wey-yi.w.guy@intel.com> (sfid-20120315_212856_443141_90705BD6)
In-Reply-To: <1331843226-29860-1-git-send-email-wey-yi.w.guy@intel.com>
References: <1331843226-29860-1-git-send-email-wey-yi.w.guy@intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Johannes Berg <johannes.berg@intel.com>

A whole bunch of messages, even some recent ones,
didn't include a trailing newline so add it.

Signed-off-by: Johannes Berg <johannes.berg@intel.com>
Signed-off-by: Wey-Yi Guy <wey-yi.w.guy@intel.com>
---
 drivers/net/wireless/iwlwifi/iwl-agn-lib.c       |   14 +++++++-------
 drivers/net/wireless/iwlwifi/iwl-agn-rs.c        |    2 +-
 drivers/net/wireless/iwlwifi/iwl-agn-rx.c        |    2 +-
 drivers/net/wireless/iwlwifi/iwl-agn-rxon.c      |    2 +-
 drivers/net/wireless/iwlwifi/iwl-agn-tx.c        |    8 ++++----
 drivers/net/wireless/iwlwifi/iwl-trans-pcie-rx.c |    2 +-
 drivers/net/wireless/iwlwifi/iwl-trans-pcie-tx.c |    2 +-
 7 files changed, 16 insertions(+), 16 deletions(-)

diff --git a/drivers/net/wireless/iwlwifi/iwl-agn-lib.c b/drivers/net/wireless/iwlwifi/iwl-agn-lib.c
index 3e1698d..53b9a11 100644
--- a/drivers/net/wireless/iwlwifi/iwl-agn-lib.c
+++ b/drivers/net/wireless/iwlwifi/iwl-agn-lib.c
@@ -615,7 +615,7 @@ static void iwlagn_print_uartmsg(struct iwl_priv *priv,
 				struct iwl_bt_uart_msg *uart_msg)
 {
 	IWL_DEBUG_COEX(priv, "Message Type = 0x%X, SSN = 0x%X, "
-			"Update Req = 0x%X",
+			"Update Req = 0x%X\n",
 		(BT_UART_MSG_FRAME1MSGTYPE_MSK & uart_msg->frame1) >>
 			BT_UART_MSG_FRAME1MSGTYPE_POS,
 		(BT_UART_MSG_FRAME1SSN_MSK & uart_msg->frame1) >>
@@ -624,7 +624,7 @@ static void iwlagn_print_uartmsg(struct iwl_priv *priv,
 			BT_UART_MSG_FRAME1UPDATEREQ_POS);
 
 	IWL_DEBUG_COEX(priv, "Open connections = 0x%X, Traffic load = 0x%X, "
-			"Chl_SeqN = 0x%X, In band = 0x%X",
+			"Chl_SeqN = 0x%X, In band = 0x%X\n",
 		(BT_UART_MSG_FRAME2OPENCONNECTIONS_MSK & uart_msg->frame2) >>
 			BT_UART_MSG_FRAME2OPENCONNECTIONS_POS,
 		(BT_UART_MSG_FRAME2TRAFFICLOAD_MSK & uart_msg->frame2) >>
@@ -635,7 +635,7 @@ static void iwlagn_print_uartmsg(struct iwl_priv *priv,
 			BT_UART_MSG_FRAME2INBAND_POS);
 
 	IWL_DEBUG_COEX(priv, "SCO/eSCO = 0x%X, Sniff = 0x%X, A2DP = 0x%X, "
-			"ACL = 0x%X, Master = 0x%X, OBEX = 0x%X",
+			"ACL = 0x%X, Master = 0x%X, OBEX = 0x%X\n",
 		(BT_UART_MSG_FRAME3SCOESCO_MSK & uart_msg->frame3) >>
 			BT_UART_MSG_FRAME3SCOESCO_POS,
 		(BT_UART_MSG_FRAME3SNIFF_MSK & uart_msg->frame3) >>
@@ -649,12 +649,12 @@ static void iwlagn_print_uartmsg(struct iwl_priv *priv,
 		(BT_UART_MSG_FRAME3OBEX_MSK & uart_msg->frame3) >>
 			BT_UART_MSG_FRAME3OBEX_POS);
 
-	IWL_DEBUG_COEX(priv, "Idle duration = 0x%X",
+	IWL_DEBUG_COEX(priv, "Idle duration = 0x%X\n",
 		(BT_UART_MSG_FRAME4IDLEDURATION_MSK & uart_msg->frame4) >>
 			BT_UART_MSG_FRAME4IDLEDURATION_POS);
 
 	IWL_DEBUG_COEX(priv, "Tx Activity = 0x%X, Rx Activity = 0x%X, "
-			"eSCO Retransmissions = 0x%X",
+			"eSCO Retransmissions = 0x%X\n",
 		(BT_UART_MSG_FRAME5TXACTIVITY_MSK & uart_msg->frame5) >>
 			BT_UART_MSG_FRAME5TXACTIVITY_POS,
 		(BT_UART_MSG_FRAME5RXACTIVITY_MSK & uart_msg->frame5) >>
@@ -662,14 +662,14 @@ static void iwlagn_print_uartmsg(struct iwl_priv *priv,
 		(BT_UART_MSG_FRAME5ESCORETRANSMIT_MSK & uart_msg->frame5) >>
 			BT_UART_MSG_FRAME5ESCORETRANSMIT_POS);
 
-	IWL_DEBUG_COEX(priv, "Sniff Interval = 0x%X, Discoverable = 0x%X",
+	IWL_DEBUG_COEX(priv, "Sniff Interval = 0x%X, Discoverable = 0x%X\n",
 		(BT_UART_MSG_FRAME6SNIFFINTERVAL_MSK & uart_msg->frame6) >>
 			BT_UART_MSG_FRAME6SNIFFINTERVAL_POS,
 		(BT_UART_MSG_FRAME6DISCOVERABLE_MSK & uart_msg->frame6) >>
 			BT_UART_MSG_FRAME6DISCOVERABLE_POS);
 
 	IWL_DEBUG_COEX(priv, "Sniff Activity = 0x%X, Page = "
-			"0x%X, Inquiry = 0x%X, Connectable = 0x%X",
+			"0x%X, Inquiry = 0x%X, Connectable = 0x%X\n",
 		(BT_UART_MSG_FRAME7SNIFFACTIVITY_MSK & uart_msg->frame7) >>
 			BT_UART_MSG_FRAME7SNIFFACTIVITY_POS,
 		(BT_UART_MSG_FRAME7PAGE_MSK & uart_msg->frame7) >>
diff --git a/drivers/net/wireless/iwlwifi/iwl-agn-rs.c b/drivers/net/wireless/iwlwifi/iwl-agn-rs.c
index 53f8c51..2343412 100644
--- a/drivers/net/wireless/iwlwifi/iwl-agn-rs.c
+++ b/drivers/net/wireless/iwlwifi/iwl-agn-rs.c
@@ -2166,7 +2166,7 @@ static void rs_stay_in_table(struct iwl_lq_sta *lq_sta, bool force_search)
 		    (lq_sta->total_success > lq_sta->max_success_limit) ||
 		    ((!lq_sta->search_better_tbl) && (lq_sta->flush_timer)
 		     && (flush_interval_passed))) {
-			IWL_DEBUG_RATE(priv, "LQ: stay is expired %d %d %d\n:",
+			IWL_DEBUG_RATE(priv, "LQ: stay is expired %d %d %d\n",
 				     lq_sta->total_failed,
 				     lq_sta->total_success,
 				     flush_interval_passed);
diff --git a/drivers/net/wireless/iwlwifi/iwl-agn-rx.c b/drivers/net/wireless/iwlwifi/iwl-agn-rx.c
index 872dc86..0a8c3e6 100644
--- a/drivers/net/wireless/iwlwifi/iwl-agn-rx.c
+++ b/drivers/net/wireless/iwlwifi/iwl-agn-rx.c
@@ -970,7 +970,7 @@ static int iwlagn_rx_reply_rx(struct iwl_priv *priv,
 	}
 
 	if ((unlikely(phy_res->cfg_phy_cnt > 20))) {
-		IWL_DEBUG_DROP(priv, "dsp size out of range [0,20]: %d/n",
+		IWL_DEBUG_DROP(priv, "dsp size out of range [0,20]: %d\n",
 				phy_res->cfg_phy_cnt);
 		return 0;
 	}
diff --git a/drivers/net/wireless/iwlwifi/iwl-agn-rxon.c b/drivers/net/wireless/iwlwifi/iwl-agn-rxon.c
index 8125f4b..9494d75 100644
--- a/drivers/net/wireless/iwlwifi/iwl-agn-rxon.c
+++ b/drivers/net/wireless/iwlwifi/iwl-agn-rxon.c
@@ -550,7 +550,7 @@ int iwlagn_mac_config(struct ieee80211_hw *hw, u32 changed)
 	const struct iwl_channel_info *ch_info;
 	int ret = 0;
 
-	IWL_DEBUG_MAC80211(priv, "enter: changed %#x", changed);
+	IWL_DEBUG_MAC80211(priv, "enter: changed %#x\n", changed);
 
 	mutex_lock(&priv->mutex);
 
diff --git a/drivers/net/wireless/iwlwifi/iwl-agn-tx.c b/drivers/net/wireless/iwlwifi/iwl-agn-tx.c
index 34adedc..453d880 100644
--- a/drivers/net/wireless/iwlwifi/iwl-agn-tx.c
+++ b/drivers/net/wireless/iwlwifi/iwl-agn-tx.c
@@ -515,7 +515,7 @@ int iwlagn_tx_agg_stop(struct iwl_priv *priv, struct ieee80211_vif *vif,
 		return 0;
 	}
 
-	IWL_DEBUG_TX_QUEUES(priv, "Can proceed: ssn = next_recl = %d",
+	IWL_DEBUG_TX_QUEUES(priv, "Can proceed: ssn = next_recl = %d\n",
 			    tid_data->agg.ssn);
 turn_off:
 	priv->tid_data[sta_id][tid].agg.state = IWL_AGG_OFF;
@@ -570,13 +570,13 @@ int iwlagn_tx_agg_start(struct iwl_priv *priv, struct ieee80211_vif *vif,
 	}
 
 	if (*ssn == tid_data->next_reclaimed) {
-		IWL_DEBUG_TX_QUEUES(priv, "Can proceed: ssn = next_recl = %d",
+		IWL_DEBUG_TX_QUEUES(priv, "Can proceed: ssn = next_recl = %d\n",
 				    tid_data->agg.ssn);
 		tid_data->agg.state = IWL_AGG_ON;
 		ieee80211_start_tx_ba_cb_irqsafe(vif, sta->addr, tid);
 	} else {
 		IWL_DEBUG_TX_QUEUES(priv, "Can't proceed: ssn %d, "
-				    "next_reclaimed = %d",
+				    "next_reclaimed = %d\n",
 				    tid_data->agg.ssn,
 				    tid_data->next_reclaimed);
 		tid_data->agg.state = IWL_EMPTYING_HW_QUEUE_ADDBA;
@@ -1059,7 +1059,7 @@ int iwlagn_rx_reply_tx(struct iwl_priv *priv, struct iwl_rx_cmd_buffer *rxb,
 		if (tid != IWL_TID_NON_QOS) {
 			priv->tid_data[sta_id][tid].next_reclaimed =
 				next_reclaimed;
-			IWL_DEBUG_TX_REPLY(priv, "Next reclaimed packet:%d",
+			IWL_DEBUG_TX_REPLY(priv, "Next reclaimed packet:%d\n",
 						  next_reclaimed);
 		}
 
diff --git a/drivers/net/wireless/iwlwifi/iwl-trans-pcie-rx.c b/drivers/net/wireless/iwlwifi/iwl-trans-pcie-rx.c
index b282311..bab5114 100644
--- a/drivers/net/wireless/iwlwifi/iwl-trans-pcie-rx.c
+++ b/drivers/net/wireless/iwlwifi/iwl-trans-pcie-rx.c
@@ -976,7 +976,7 @@ void iwl_irq_tasklet(struct iwl_trans *trans)
 	if (iwl_have_debug_level(IWL_DL_ISR)) {
 		/* just for debug */
 		inta_mask = iwl_read32(trans, CSR_INT_MASK);
-		IWL_DEBUG_ISR(trans, "inta 0x%08x, enabled 0x%08x\n ",
+		IWL_DEBUG_ISR(trans, "inta 0x%08x, enabled 0x%08x\n",
 				inta, inta_mask);
 	}
 #endif
diff --git a/drivers/net/wireless/iwlwifi/iwl-trans-pcie-tx.c b/drivers/net/wireless/iwlwifi/iwl-trans-pcie-tx.c
index a66ad9b..8b3eb9e 100644
--- a/drivers/net/wireless/iwlwifi/iwl-trans-pcie-tx.c
+++ b/drivers/net/wireless/iwlwifi/iwl-trans-pcie-tx.c
@@ -448,7 +448,7 @@ static void iwlagn_tx_queue_stop_scheduler(struct iwl_trans *trans, u16 txq_id)
 void iwl_trans_set_wr_ptrs(struct iwl_trans *trans,
 				int txq_id, u32 index)
 {
-	IWL_DEBUG_TX_QUEUES(trans, "Q %d  WrPtr: %d", txq_id, index & 0xff);
+	IWL_DEBUG_TX_QUEUES(trans, "Q %d  WrPtr: %d\n", txq_id, index & 0xff);
 	iwl_write_direct32(trans, HBUS_TARG_WRPTR,
 			(index & 0xff) | (txq_id << 8));
 	iwl_write_prph(trans, SCD_QUEUE_RDPTR(txq_id), index);
-- 
1.7.0.4

