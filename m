Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga09.intel.com ([134.134.136.24]:54587 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754991Ab2CDUnB (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Sun, 4 Mar 2012 15:43:01 -0500
From: Wey-Yi Guy <wey-yi.w.guy@intel.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org,
	Johannes Berg <johannes.berg@intel.com>,
	Wey-Yi Guy <wey-yi.w.guy@intel.com>
Subject: [PATCH 021/101] iwlwifi: don't pass iwl_rx_mem_buffer to upper layers
Date: Sun,  4 Mar 2012 11:28:35 -0800
Message-Id: <1330889395-533-22-git-send-email-wey-yi.w.guy@intel.com> (sfid-20120304_214642_236648_5750F91D)
In-Reply-To: <1330889395-533-1-git-send-email-wey-yi.w.guy@intel.com>
References: <1330889395-533-1-git-send-email-wey-yi.w.guy@intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Johannes Berg <johannes.berg@intel.com>

struct iwl_rx_mem_buffer implementation details
(DMA address, list pointers) that the upper
layers don't need. Introduce iwl_rx_cmd_buffer
that is passed upstream and only contains the
needed data (the page). Additionally, access
this data only via accessor functions, allowing
us to change the implementation in the future.
These accessors are rxb_addr() (as before) and
rxb_steal_page() to take ownership of the data.

Signed-off-by: Johannes Berg <johannes.berg@intel.com>
Signed-off-by: Wey-Yi Guy <wey-yi.w.guy@intel.com>
---
 drivers/net/wireless/iwlwifi/iwl-agn-lib.c        |    2 +-
 drivers/net/wireless/iwlwifi/iwl-agn-rx.c         |   41 +++++++++++----------
 drivers/net/wireless/iwlwifi/iwl-agn-sta.c        |    2 +-
 drivers/net/wireless/iwlwifi/iwl-agn-tx.c         |    4 +-
 drivers/net/wireless/iwlwifi/iwl-agn.h            |   12 +++---
 drivers/net/wireless/iwlwifi/iwl-dev.h            |    4 +-
 drivers/net/wireless/iwlwifi/iwl-op-mode.h        |    6 ++--
 drivers/net/wireless/iwlwifi/iwl-scan.c           |    8 ++--
 drivers/net/wireless/iwlwifi/iwl-shared.h         |   18 +++++++---
 drivers/net/wireless/iwlwifi/iwl-testmode.c       |    4 +-
 drivers/net/wireless/iwlwifi/iwl-trans-pcie-int.h |    8 ++++-
 drivers/net/wireless/iwlwifi/iwl-trans-pcie-rx.c  |   21 +++++++----
 drivers/net/wireless/iwlwifi/iwl-trans-pcie-tx.c  |    5 +--
 drivers/net/wireless/iwlwifi/iwl-ucode.c          |    2 +-
 14 files changed, 80 insertions(+), 57 deletions(-)

diff --git a/drivers/net/wireless/iwlwifi/iwl-agn-lib.c b/drivers/net/wireless/iwlwifi/iwl-agn-lib.c
index 626b0d1..e96af51 100644
--- a/drivers/net/wireless/iwlwifi/iwl-agn-lib.c
+++ b/drivers/net/wireless/iwlwifi/iwl-agn-lib.c
@@ -707,7 +707,7 @@ static void iwlagn_set_kill_msk(struct iwl_priv *priv,
 }
 
 int iwlagn_bt_coex_profile_notif(struct iwl_priv *priv,
-				  struct iwl_rx_mem_buffer *rxb,
+				  struct iwl_rx_cmd_buffer *rxb,
 				  struct iwl_device_cmd *cmd)
 {
 	struct iwl_rx_packet *pkt = rxb_addr(rxb);
diff --git a/drivers/net/wireless/iwlwifi/iwl-agn-rx.c b/drivers/net/wireless/iwlwifi/iwl-agn-rx.c
index bc21586..8e025e0 100644
--- a/drivers/net/wireless/iwlwifi/iwl-agn-rx.c
+++ b/drivers/net/wireless/iwlwifi/iwl-agn-rx.c
@@ -131,7 +131,7 @@ const char *get_cmd_string(u8 cmd)
  ******************************************************************************/
 
 static int iwlagn_rx_reply_error(struct iwl_priv *priv,
-			       struct iwl_rx_mem_buffer *rxb,
+			       struct iwl_rx_cmd_buffer *rxb,
 			       struct iwl_device_cmd *cmd)
 {
 	struct iwl_rx_packet *pkt = rxb_addr(rxb);
@@ -146,7 +146,7 @@ static int iwlagn_rx_reply_error(struct iwl_priv *priv,
 	return 0;
 }
 
-static int iwlagn_rx_csa(struct iwl_priv *priv, struct iwl_rx_mem_buffer *rxb,
+static int iwlagn_rx_csa(struct iwl_priv *priv, struct iwl_rx_cmd_buffer *rxb,
 			       struct iwl_device_cmd *cmd)
 {
 	struct iwl_rx_packet *pkt = rxb_addr(rxb);
@@ -177,7 +177,7 @@ static int iwlagn_rx_csa(struct iwl_priv *priv, struct iwl_rx_mem_buffer *rxb,
 
 
 static int iwlagn_rx_spectrum_measure_notif(struct iwl_priv *priv,
-					  struct iwl_rx_mem_buffer *rxb,
+					  struct iwl_rx_cmd_buffer *rxb,
 					  struct iwl_device_cmd *cmd)
 {
 	struct iwl_rx_packet *pkt = rxb_addr(rxb);
@@ -195,7 +195,7 @@ static int iwlagn_rx_spectrum_measure_notif(struct iwl_priv *priv,
 }
 
 static int iwlagn_rx_pm_sleep_notif(struct iwl_priv *priv,
-				  struct iwl_rx_mem_buffer *rxb,
+				  struct iwl_rx_cmd_buffer *rxb,
 				  struct iwl_device_cmd *cmd)
 {
 #ifdef CONFIG_IWLWIFI_DEBUG
@@ -208,7 +208,7 @@ static int iwlagn_rx_pm_sleep_notif(struct iwl_priv *priv,
 }
 
 static int iwlagn_rx_pm_debug_statistics_notif(struct iwl_priv *priv,
-					     struct iwl_rx_mem_buffer *rxb,
+					     struct iwl_rx_cmd_buffer *rxb,
 					     struct iwl_device_cmd *cmd)
 {
 	struct iwl_rx_packet *pkt = rxb_addr(rxb);
@@ -222,7 +222,7 @@ static int iwlagn_rx_pm_debug_statistics_notif(struct iwl_priv *priv,
 }
 
 static int iwlagn_rx_beacon_notif(struct iwl_priv *priv,
-				struct iwl_rx_mem_buffer *rxb,
+				struct iwl_rx_cmd_buffer *rxb,
 				struct iwl_device_cmd *cmd)
 {
 	struct iwl_rx_packet *pkt = rxb_addr(rxb);
@@ -489,7 +489,7 @@ iwlagn_accumulative_statistics(struct iwl_priv *priv,
 #endif
 
 static int iwlagn_rx_statistics(struct iwl_priv *priv,
-			      struct iwl_rx_mem_buffer *rxb,
+			      struct iwl_rx_cmd_buffer *rxb,
 			      struct iwl_device_cmd *cmd)
 {
 	unsigned long stamp = jiffies;
@@ -597,7 +597,7 @@ static int iwlagn_rx_statistics(struct iwl_priv *priv,
 }
 
 static int iwlagn_rx_reply_statistics(struct iwl_priv *priv,
-				    struct iwl_rx_mem_buffer *rxb,
+				    struct iwl_rx_cmd_buffer *rxb,
 				    struct iwl_device_cmd *cmd)
 {
 	struct iwl_rx_packet *pkt = rxb_addr(rxb);
@@ -620,7 +620,7 @@ static int iwlagn_rx_reply_statistics(struct iwl_priv *priv,
 /* Handle notification from uCode that card's power state is changing
  * due to software, hardware, or critical temperature RFKILL */
 static int iwlagn_rx_card_state_notif(struct iwl_priv *priv,
-				    struct iwl_rx_mem_buffer *rxb,
+				    struct iwl_rx_cmd_buffer *rxb,
 				    struct iwl_device_cmd *cmd)
 {
 	struct iwl_rx_packet *pkt = rxb_addr(rxb);
@@ -673,7 +673,7 @@ static int iwlagn_rx_card_state_notif(struct iwl_priv *priv,
 }
 
 static int iwlagn_rx_missed_beacon_notif(struct iwl_priv *priv,
-				       struct iwl_rx_mem_buffer *rxb,
+				       struct iwl_rx_cmd_buffer *rxb,
 				       struct iwl_device_cmd *cmd)
 
 {
@@ -698,7 +698,7 @@ static int iwlagn_rx_missed_beacon_notif(struct iwl_priv *priv,
 /* Cache phy data (Rx signal strength, etc) for HT frame (REPLY_RX_PHY_CMD).
  * This will be used later in iwl_rx_reply_rx() for REPLY_RX_MPDU_CMD. */
 static int iwlagn_rx_reply_rx_phy(struct iwl_priv *priv,
-				struct iwl_rx_mem_buffer *rxb,
+				struct iwl_rx_cmd_buffer *rxb,
 				struct iwl_device_cmd *cmd)
 {
 	struct iwl_rx_packet *pkt = rxb_addr(rxb);
@@ -765,12 +765,14 @@ static void iwlagn_pass_packet_to_mac80211(struct iwl_priv *priv,
 					struct ieee80211_hdr *hdr,
 					u16 len,
 					u32 ampdu_status,
-					struct iwl_rx_mem_buffer *rxb,
+					struct iwl_rx_cmd_buffer *rxb,
 					struct ieee80211_rx_status *stats)
 {
 	struct sk_buff *skb;
 	__le16 fc = hdr->frame_control;
 	struct iwl_rxon_context *ctx;
+	struct page *p;
+	int offset;
 
 	/* We only process data packets if the interface is open */
 	if (unlikely(!priv->is_open)) {
@@ -790,7 +792,9 @@ static void iwlagn_pass_packet_to_mac80211(struct iwl_priv *priv,
 		return;
 	}
 
-	skb_add_rx_frag(skb, 0, rxb->page, (void *)hdr - rxb_addr(rxb), len);
+	offset = (void *)hdr - rxb_addr(rxb);
+	p = rxb_steal_page(rxb);
+	skb_add_rx_frag(skb, 0, p, offset, len);
 
 	iwl_update_stats(priv, false, fc, len);
 
@@ -817,7 +821,6 @@ static void iwlagn_pass_packet_to_mac80211(struct iwl_priv *priv,
 	memcpy(IEEE80211_SKB_RXCB(skb), stats, sizeof(*stats));
 
 	ieee80211_rx(priv->hw, skb);
-	rxb->page = NULL;
 }
 
 static u32 iwlagn_translate_rx_status(struct iwl_priv *priv, u32 decrypt_in)
@@ -923,7 +926,7 @@ static int iwlagn_calc_rssi(struct iwl_priv *priv,
 /* Called for REPLY_RX (legacy ABG frames), or
  * REPLY_RX_MPDU_CMD (HT high-throughput N frames). */
 static int iwlagn_rx_reply_rx(struct iwl_priv *priv,
-			    struct iwl_rx_mem_buffer *rxb,
+			    struct iwl_rx_cmd_buffer *rxb,
 			    struct iwl_device_cmd *cmd)
 {
 	struct ieee80211_hdr *header;
@@ -1043,7 +1046,7 @@ static int iwlagn_rx_reply_rx(struct iwl_priv *priv,
 }
 
 static int iwlagn_rx_noa_notification(struct iwl_priv *priv,
-				      struct iwl_rx_mem_buffer *rxb,
+				      struct iwl_rx_cmd_buffer *rxb,
 				      struct iwl_device_cmd *cmd)
 {
 	struct iwl_wipan_noa_data *new_data, *old_data;
@@ -1094,7 +1097,7 @@ static int iwlagn_rx_noa_notification(struct iwl_priv *priv,
  */
 void iwl_setup_rx_handlers(struct iwl_priv *priv)
 {
-	int (**handlers)(struct iwl_priv *priv, struct iwl_rx_mem_buffer *rxb,
+	int (**handlers)(struct iwl_priv *priv, struct iwl_rx_cmd_buffer *rxb,
 			       struct iwl_device_cmd *cmd);
 
 	handlers = priv->rx_handlers;
@@ -1149,8 +1152,8 @@ void iwl_setup_rx_handlers(struct iwl_priv *priv)
 
 }
 
-int iwl_rx_dispatch(struct iwl_op_mode *op_mode, struct iwl_rx_mem_buffer *rxb,
-		     struct iwl_device_cmd *cmd)
+int iwl_rx_dispatch(struct iwl_op_mode *op_mode, struct iwl_rx_cmd_buffer *rxb,
+		    struct iwl_device_cmd *cmd)
 {
 	struct iwl_rx_packet *pkt = rxb_addr(rxb);
 	struct iwl_priv *priv = IWL_OP_MODE_GET_DVM(op_mode);
diff --git a/drivers/net/wireless/iwlwifi/iwl-agn-sta.c b/drivers/net/wireless/iwlwifi/iwl-agn-sta.c
index 9ef8da4..736f8dc 100644
--- a/drivers/net/wireless/iwlwifi/iwl-agn-sta.c
+++ b/drivers/net/wireless/iwlwifi/iwl-agn-sta.c
@@ -123,7 +123,7 @@ static int iwl_process_add_sta_resp(struct iwl_priv *priv,
 	return ret;
 }
 
-int iwl_add_sta_callback(struct iwl_priv *priv, struct iwl_rx_mem_buffer *rxb,
+int iwl_add_sta_callback(struct iwl_priv *priv, struct iwl_rx_cmd_buffer *rxb,
 			       struct iwl_device_cmd *cmd)
 {
 	struct iwl_rx_packet *pkt = rxb_addr(rxb);
diff --git a/drivers/net/wireless/iwlwifi/iwl-agn-tx.c b/drivers/net/wireless/iwlwifi/iwl-agn-tx.c
index 1914bee..dd28785 100644
--- a/drivers/net/wireless/iwlwifi/iwl-agn-tx.c
+++ b/drivers/net/wireless/iwlwifi/iwl-agn-tx.c
@@ -977,7 +977,7 @@ static void iwl_check_abort_status(struct iwl_priv *priv,
 	}
 }
 
-int iwlagn_rx_reply_tx(struct iwl_priv *priv, struct iwl_rx_mem_buffer *rxb,
+int iwlagn_rx_reply_tx(struct iwl_priv *priv, struct iwl_rx_cmd_buffer *rxb,
 			       struct iwl_device_cmd *cmd)
 {
 	struct iwl_rx_packet *pkt = rxb_addr(rxb);
@@ -1108,7 +1108,7 @@ int iwlagn_rx_reply_tx(struct iwl_priv *priv, struct iwl_rx_mem_buffer *rxb,
  * of frames sent via aggregation.
  */
 int iwlagn_rx_reply_compressed_ba(struct iwl_priv *priv,
-				   struct iwl_rx_mem_buffer *rxb,
+				   struct iwl_rx_cmd_buffer *rxb,
 				   struct iwl_device_cmd *cmd)
 {
 	struct iwl_rx_packet *pkt = rxb_addr(rxb);
diff --git a/drivers/net/wireless/iwlwifi/iwl-agn.h b/drivers/net/wireless/iwlwifi/iwl-agn.h
index a142a19..a9c018a 100644
--- a/drivers/net/wireless/iwlwifi/iwl-agn.h
+++ b/drivers/net/wireless/iwlwifi/iwl-agn.h
@@ -82,7 +82,7 @@ void iwl_cancel_deferred_work(struct iwl_priv *priv);
 void iwlagn_prepare_restart(struct iwl_priv *priv);
 void iwl_free_skb(struct iwl_op_mode *op_mode, struct sk_buff *skb);
 int __must_check iwl_rx_dispatch(struct iwl_op_mode *op_mode,
-				 struct iwl_rx_mem_buffer *rxb,
+				 struct iwl_rx_cmd_buffer *rxb,
 				 struct iwl_device_cmd *cmd);
 void iwl_stop_sw_queue(struct iwl_op_mode *op_mode, u8 ac);
 void iwl_wake_sw_queue(struct iwl_op_mode *op_mode, u8 ac);
@@ -110,7 +110,7 @@ void iwlagn_config_ht40(struct ieee80211_conf *conf,
 
 /* uCode */
 int iwlagn_rx_calib_result(struct iwl_priv *priv,
-			    struct iwl_rx_mem_buffer *rxb,
+			    struct iwl_rx_cmd_buffer *rxb,
 			    struct iwl_device_cmd *cmd);
 void iwl_init_context(struct iwl_priv *priv, u32 ucode_flags);
 
@@ -142,9 +142,9 @@ int iwlagn_tx_agg_oper(struct iwl_priv *priv, struct ieee80211_vif *vif,
 int iwlagn_tx_agg_stop(struct iwl_priv *priv, struct ieee80211_vif *vif,
 		       struct ieee80211_sta *sta, u16 tid);
 int iwlagn_rx_reply_compressed_ba(struct iwl_priv *priv,
-				   struct iwl_rx_mem_buffer *rxb,
+				   struct iwl_rx_cmd_buffer *rxb,
 				   struct iwl_device_cmd *cmd);
-int iwlagn_rx_reply_tx(struct iwl_priv *priv, struct iwl_rx_mem_buffer *rxb,
+int iwlagn_rx_reply_tx(struct iwl_priv *priv, struct iwl_rx_cmd_buffer *rxb,
 			       struct iwl_device_cmd *cmd);
 
 static inline u32 iwl_tx_status_to_mac80211(u32 status)
@@ -179,7 +179,7 @@ void iwlagn_disable_roc(struct iwl_priv *priv);
 /* bt coex */
 void iwlagn_send_advance_bt_config(struct iwl_priv *priv);
 int iwlagn_bt_coex_profile_notif(struct iwl_priv *priv,
-				  struct iwl_rx_mem_buffer *rxb,
+				  struct iwl_rx_cmd_buffer *rxb,
 				  struct iwl_device_cmd *cmd);
 void iwlagn_bt_rx_handler_setup(struct iwl_priv *priv);
 void iwlagn_bt_setup_deferred_work(struct iwl_priv *priv);
@@ -227,7 +227,7 @@ void iwl_sta_fill_lq(struct iwl_priv *priv, struct iwl_rxon_context *ctx,
 		     u8 sta_id, struct iwl_link_quality_cmd *link_cmd);
 int iwl_send_lq_cmd(struct iwl_priv *priv, struct iwl_rxon_context *ctx,
 		    struct iwl_link_quality_cmd *lq, u8 flags, bool init);
-int iwl_add_sta_callback(struct iwl_priv *priv, struct iwl_rx_mem_buffer *rxb,
+int iwl_add_sta_callback(struct iwl_priv *priv, struct iwl_rx_cmd_buffer *rxb,
 			       struct iwl_device_cmd *cmd);
 
 
diff --git a/drivers/net/wireless/iwlwifi/iwl-dev.h b/drivers/net/wireless/iwlwifi/iwl-dev.h
index ef71463..5957209 100644
--- a/drivers/net/wireless/iwlwifi/iwl-dev.h
+++ b/drivers/net/wireless/iwlwifi/iwl-dev.h
@@ -729,9 +729,9 @@ struct iwl_priv {
 	enum ieee80211_band band;
 
 	void (*pre_rx_handler)(struct iwl_priv *priv,
-			       struct iwl_rx_mem_buffer *rxb);
+			       struct iwl_rx_cmd_buffer *rxb);
 	int (*rx_handlers[REPLY_MAX])(struct iwl_priv *priv,
-				       struct iwl_rx_mem_buffer *rxb,
+				       struct iwl_rx_cmd_buffer *rxb,
 				       struct iwl_device_cmd *cmd);
 
 	struct ieee80211_supported_band bands[IEEE80211_NUM_BANDS];
diff --git a/drivers/net/wireless/iwlwifi/iwl-op-mode.h b/drivers/net/wireless/iwlwifi/iwl-op-mode.h
index d4fc9be..41e58a1 100644
--- a/drivers/net/wireless/iwlwifi/iwl-op-mode.h
+++ b/drivers/net/wireless/iwlwifi/iwl-op-mode.h
@@ -67,7 +67,7 @@ struct iwl_op_mode;
 struct iwl_trans;
 struct sk_buff;
 struct iwl_device_cmd;
-struct iwl_rx_mem_buffer;
+struct iwl_rx_cmd_buffer;
 
 /**
  * DOC: Operational mode - what is it ?
@@ -125,7 +125,7 @@ struct iwl_rx_mem_buffer;
 struct iwl_op_mode_ops {
 	struct iwl_op_mode *(*start)(struct iwl_trans *trans);
 	void (*stop)(struct iwl_op_mode *op_mode);
-	int (*rx)(struct iwl_op_mode *op_mode, struct iwl_rx_mem_buffer *rxb,
+	int (*rx)(struct iwl_op_mode *op_mode, struct iwl_rx_cmd_buffer *rxb,
 		  struct iwl_device_cmd *cmd);
 	void (*queue_full)(struct iwl_op_mode *op_mode, u8 ac);
 	void (*queue_not_full)(struct iwl_op_mode *op_mode, u8 ac);
@@ -156,7 +156,7 @@ static inline void iwl_op_mode_stop(struct iwl_op_mode *op_mode)
 }
 
 static inline int iwl_op_mode_rx(struct iwl_op_mode *op_mode,
-				  struct iwl_rx_mem_buffer *rxb,
+				  struct iwl_rx_cmd_buffer *rxb,
 				  struct iwl_device_cmd *cmd)
 {
 	return op_mode->ops->rx(op_mode, rxb, cmd);
diff --git a/drivers/net/wireless/iwlwifi/iwl-scan.c b/drivers/net/wireless/iwlwifi/iwl-scan.c
index c0fc368..28899da 100644
--- a/drivers/net/wireless/iwlwifi/iwl-scan.c
+++ b/drivers/net/wireless/iwlwifi/iwl-scan.c
@@ -260,7 +260,7 @@ void iwl_scan_cancel_timeout(struct iwl_priv *priv, unsigned long ms)
 
 /* Service response to REPLY_SCAN_CMD (0x80) */
 static int iwl_rx_reply_scan(struct iwl_priv *priv,
-			      struct iwl_rx_mem_buffer *rxb,
+			      struct iwl_rx_cmd_buffer *rxb,
 			      struct iwl_device_cmd *cmd)
 {
 #ifdef CONFIG_IWLWIFI_DEBUG
@@ -275,7 +275,7 @@ static int iwl_rx_reply_scan(struct iwl_priv *priv,
 
 /* Service SCAN_START_NOTIFICATION (0x82) */
 static int iwl_rx_scan_start_notif(struct iwl_priv *priv,
-				    struct iwl_rx_mem_buffer *rxb,
+				    struct iwl_rx_cmd_buffer *rxb,
 				    struct iwl_device_cmd *cmd)
 {
 	struct iwl_rx_packet *pkt = rxb_addr(rxb);
@@ -302,7 +302,7 @@ static int iwl_rx_scan_start_notif(struct iwl_priv *priv,
 
 /* Service SCAN_RESULTS_NOTIFICATION (0x83) */
 static int iwl_rx_scan_results_notif(struct iwl_priv *priv,
-				      struct iwl_rx_mem_buffer *rxb,
+				      struct iwl_rx_cmd_buffer *rxb,
 				      struct iwl_device_cmd *cmd)
 {
 #ifdef CONFIG_IWLWIFI_DEBUG
@@ -328,7 +328,7 @@ static int iwl_rx_scan_results_notif(struct iwl_priv *priv,
 
 /* Service SCAN_COMPLETE_NOTIFICATION (0x84) */
 static int iwl_rx_scan_complete_notif(struct iwl_priv *priv,
-				       struct iwl_rx_mem_buffer *rxb,
+				       struct iwl_rx_cmd_buffer *rxb,
 				       struct iwl_device_cmd *cmd)
 {
 	struct iwl_rx_packet *pkt = rxb_addr(rxb);
diff --git a/drivers/net/wireless/iwlwifi/iwl-shared.h b/drivers/net/wireless/iwlwifi/iwl-shared.h
index 53244d8..ed1811d 100644
--- a/drivers/net/wireless/iwlwifi/iwl-shared.h
+++ b/drivers/net/wireless/iwlwifi/iwl-shared.h
@@ -433,13 +433,21 @@ static inline int iwl_queue_dec_wrap(int index, int n_bd)
 	return --index & (n_bd - 1);
 }
 
-struct iwl_rx_mem_buffer {
-	dma_addr_t page_dma;
-	struct page *page;
-	struct list_head list;
+struct iwl_rx_cmd_buffer {
+	struct page *_page;
 };
 
-#define rxb_addr(r) page_address(r->page)
+static inline void *rxb_addr(struct iwl_rx_cmd_buffer *r)
+{
+	return page_address(r->_page);
+}
+
+static inline struct page *rxb_steal_page(struct iwl_rx_cmd_buffer *r)
+{
+	struct page *p = r->_page;
+	r->_page = NULL;
+	return p;
+}
 
 /*
  * mac80211 queues, ACs, hardware queues, FIFOs.
diff --git a/drivers/net/wireless/iwlwifi/iwl-testmode.c b/drivers/net/wireless/iwlwifi/iwl-testmode.c
index cc1f3e9..b24b166 100644
--- a/drivers/net/wireless/iwlwifi/iwl-testmode.c
+++ b/drivers/net/wireless/iwlwifi/iwl-testmode.c
@@ -131,7 +131,7 @@ struct nla_policy iwl_testmode_gnl_msg_policy[IWL_TM_ATTR_MAX] = {
  * See the struct iwl_rx_packet in iwl-commands.h for the format of the
  * received events from the device
  */
-static inline int get_event_length(struct iwl_rx_mem_buffer *rxb)
+static inline int get_event_length(struct iwl_rx_cmd_buffer *rxb)
 {
 	struct iwl_rx_packet *pkt = rxb_addr(rxb);
 	if (pkt)
@@ -162,7 +162,7 @@ static inline int get_event_length(struct iwl_rx_mem_buffer *rxb)
  */
 
 static void iwl_testmode_ucode_rx_pkt(struct iwl_priv *priv,
-				struct iwl_rx_mem_buffer *rxb)
+				      struct iwl_rx_cmd_buffer *rxb)
 {
 	struct ieee80211_hw *hw = priv->hw;
 	struct sk_buff *skb;
diff --git a/drivers/net/wireless/iwlwifi/iwl-trans-pcie-int.h b/drivers/net/wireless/iwlwifi/iwl-trans-pcie-int.h
index b102946..632d409 100644
--- a/drivers/net/wireless/iwlwifi/iwl-trans-pcie-int.h
+++ b/drivers/net/wireless/iwlwifi/iwl-trans-pcie-int.h
@@ -49,6 +49,12 @@ struct iwl_host_cmd;
 /*This file includes the declaration that are internal to the
  * trans_pcie layer */
 
+struct iwl_rx_mem_buffer {
+	dma_addr_t page_dma;
+	struct page *page;
+	struct list_head list;
+};
+
 /**
  * struct isr_statistics - interrupt statistics
  *
@@ -287,7 +293,7 @@ int iwlagn_txq_attach_buf_to_tfd(struct iwl_trans *trans,
 int iwl_queue_init(struct iwl_queue *q, int count, int slots_num, u32 id);
 int iwl_trans_pcie_send_cmd(struct iwl_trans *trans, struct iwl_host_cmd *cmd);
 void iwl_tx_cmd_complete(struct iwl_trans *trans,
-			 struct iwl_rx_mem_buffer *rxb, int handler_status);
+			 struct iwl_rx_cmd_buffer *rxb, int handler_status);
 void iwl_trans_txq_update_byte_cnt_tbl(struct iwl_trans *trans,
 					   struct iwl_tx_queue *txq,
 					   u16 byte_cnt);
diff --git a/drivers/net/wireless/iwlwifi/iwl-trans-pcie-rx.c b/drivers/net/wireless/iwlwifi/iwl-trans-pcie-rx.c
index 6495945..68e89be 100644
--- a/drivers/net/wireless/iwlwifi/iwl-trans-pcie-rx.c
+++ b/drivers/net/wireless/iwlwifi/iwl-trans-pcie-rx.c
@@ -367,8 +367,6 @@ void iwl_bg_rx_replenish(struct work_struct *data)
  */
 static void iwl_rx_handle(struct iwl_trans *trans)
 {
-	struct iwl_rx_mem_buffer *rxb;
-	struct iwl_rx_packet *pkt;
 	struct iwl_trans_pcie *trans_pcie =
 		IWL_TRANS_GET_PCIE_TRANS(trans);
 	struct iwl_rx_queue *rxq = &trans_pcie->rxq;
@@ -402,6 +400,9 @@ static void iwl_rx_handle(struct iwl_trans *trans)
 	while (i != r) {
 		int len, err;
 		u16 sequence;
+		struct iwl_rx_mem_buffer *rxb;
+		struct iwl_rx_cmd_buffer rxcb;
+		struct iwl_rx_packet *pkt;
 
 		rxb = rxq->queue[i];
 
@@ -418,7 +419,9 @@ static void iwl_rx_handle(struct iwl_trans *trans)
 		dma_unmap_page(trans->dev, rxb->page_dma,
 			       PAGE_SIZE << hw_params(trans).rx_page_order,
 			       DMA_FROM_DEVICE);
-		pkt = rxb_addr(rxb);
+
+		rxcb._page = rxb->page;
+		pkt = rxb_addr(&rxcb);
 
 		IWL_DEBUG_RX(trans, "r = %d, i = %d, %s, 0x%02x\n", r,
 			i, get_cmd_string(pkt->hdr.cmd), pkt->hdr.cmd);
@@ -461,10 +464,10 @@ static void iwl_rx_handle(struct iwl_trans *trans)
 		     "reclaim is false, SEQ_RX_FRAME unset: %s\n",
 		     get_cmd_string(pkt->hdr.cmd));
 
-		err = iwl_op_mode_rx(trans->op_mode, rxb, cmd);
+		err = iwl_op_mode_rx(trans->op_mode, &rxcb, cmd);
 
 		/*
-		 * XXX: After here, we should always check rxb->page
+		 * XXX: After here, we should always check rxcb._page
 		 * against NULL before touching it or its virtual
 		 * memory (pkt). Because some rx_handler might have
 		 * already taken or freed the pages.
@@ -475,12 +478,16 @@ static void iwl_rx_handle(struct iwl_trans *trans)
 			 * and fire off the (possibly) blocking
 			 * iwl_trans_send_cmd()
 			 * as we reclaim the driver command queue */
-			if (rxb->page)
-				iwl_tx_cmd_complete(trans, rxb, err);
+			if (rxcb._page)
+				iwl_tx_cmd_complete(trans, &rxcb, err);
 			else
 				IWL_WARN(trans, "Claim null rxb?\n");
 		}
 
+		/* page was stolen from us */
+		if (rxcb._page == NULL)
+			rxb->page = NULL;
+
 		/* Reuse the page if possible. For notification packets and
 		 * SKBs that fail to Rx correctly, add them back into the
 		 * rx_free list for reuse later. */
diff --git a/drivers/net/wireless/iwlwifi/iwl-trans-pcie-tx.c b/drivers/net/wireless/iwlwifi/iwl-trans-pcie-tx.c
index 771fae2..0513b90 100644
--- a/drivers/net/wireless/iwlwifi/iwl-trans-pcie-tx.c
+++ b/drivers/net/wireless/iwlwifi/iwl-trans-pcie-tx.c
@@ -841,7 +841,7 @@ static void iwl_hcmd_queue_reclaim(struct iwl_trans *trans, int txq_id,
  * will be executed.  The attached skb (if present) will only be freed
  * if the callback returns 1
  */
-void iwl_tx_cmd_complete(struct iwl_trans *trans, struct iwl_rx_mem_buffer *rxb,
+void iwl_tx_cmd_complete(struct iwl_trans *trans, struct iwl_rx_cmd_buffer *rxb,
 			 int handler_status)
 {
 	struct iwl_rx_packet *pkt = rxb_addr(rxb);
@@ -879,9 +879,8 @@ void iwl_tx_cmd_complete(struct iwl_trans *trans, struct iwl_rx_mem_buffer *rxb,
 
 	/* Input error checking is done when commands are added to queue. */
 	if (meta->flags & CMD_WANT_SKB) {
-		struct page *p = rxb->page;
+		struct page *p = rxb_steal_page(rxb);
 
-		rxb->page = NULL;
 		meta->source->resp_pkt = pkt;
 		meta->source->_rx_page_addr = (unsigned long)page_address(p);
 		meta->source->_rx_page_order = hw_params(trans).rx_page_order;
diff --git a/drivers/net/wireless/iwlwifi/iwl-ucode.c b/drivers/net/wireless/iwlwifi/iwl-ucode.c
index 206a61c..12e79d0 100644
--- a/drivers/net/wireless/iwlwifi/iwl-ucode.c
+++ b/drivers/net/wireless/iwlwifi/iwl-ucode.c
@@ -228,7 +228,7 @@ static int iwl_send_calib_cfg(struct iwl_trans *trans)
 }
 
 int iwlagn_rx_calib_result(struct iwl_priv *priv,
-			    struct iwl_rx_mem_buffer *rxb,
+			    struct iwl_rx_cmd_buffer *rxb,
 			    struct iwl_device_cmd *cmd)
 {
 	struct iwl_rx_packet *pkt = rxb_addr(rxb);
-- 
1.7.0.4

