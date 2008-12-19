Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga11.intel.com ([192.55.52.93]:28446 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752965AbYLSCpg (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 18 Dec 2008 21:45:36 -0500
From: Zhu Yi <yi.zhu@intel.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org,
	ipw3945-devel@lists.sourceforge.net,
	"Winkler, Tomas" <tomas.winkler@intel.com>,
	Zhu Yi <yi.zhu@intel.com>
Subject: [PATCH 34/43] iwlwifi: use iwl_cmd instead of iwl3945_cmd
Date: Fri, 19 Dec 2008 10:37:34 +0800
Message-Id: <1229654263-21454-35-git-send-email-yi.zhu@intel.com> (sfid-20081219_034622_048946_AC87D04A)
In-Reply-To: <1229654263-21454-34-git-send-email-yi.zhu@intel.com>
References: <1229654263-21454-1-git-send-email-yi.zhu@intel.com>
 <1229654263-21454-2-git-send-email-yi.zhu@intel.com>
 <1229654263-21454-3-git-send-email-yi.zhu@intel.com>
 <1229654263-21454-4-git-send-email-yi.zhu@intel.com>
 <1229654263-21454-5-git-send-email-yi.zhu@intel.com>
 <1229654263-21454-6-git-send-email-yi.zhu@intel.com>
 <1229654263-21454-7-git-send-email-yi.zhu@intel.com>
 <1229654263-21454-8-git-send-email-yi.zhu@intel.com>
 <1229654263-21454-9-git-send-email-yi.zhu@intel.com>
 <1229654263-21454-10-git-send-email-yi.zhu@intel.com>
 <1229654263-21454-11-git-send-email-yi.zhu@intel.com>
 <1229654263-21454-12-git-send-email-yi.zhu@intel.com>
 <1229654263-21454-13-git-send-email-yi.zhu@intel.com>
 <1229654263-21454-14-git-send-email-yi.zhu@intel.com>
 <1229654263-21454-15-git-send-email-yi.zhu@intel.com>
 <1229654263-21454-16-git-send-email-yi.zhu@intel.com>
 <1229654263-21454-17-git-send-email-yi.zhu@intel.com>
 <1229654263-21454-18-git-send-email-yi.zhu@intel.com>
 <1229654263-21454-19-git-send-email-yi.zhu@intel.com>
 <1229654263-21454-20-git-send-email-yi.zhu@intel.com>
 <1229654263-21454-21-git-send-email-yi.zhu@intel.com>
 <1229654263-21454-22-git-send-email-yi.zhu@intel.com>
 <1229654263-21454-23-git-send-email-yi.zhu@intel.com>
 <1229654263-21454-24-git-send-email-yi.zhu@intel.com>
 <1229654263-21454-25-git-send-email-yi.zhu@intel.com>
 <1229654263-21454-26-git-send-email-yi.zhu@intel.com>
 <1229654263-21454-27-git-send-email-yi.zhu@intel.com>
 <1229654263-21454-28-git-send-email-yi.zhu@intel.com>
 <1229654263-21454-29-git-send-email-yi.zhu@intel.com>
 <1229654263-21454-30-git-send-email-yi.zhu@intel.com>
 <1229654263-21454-31-git-send-email-yi.zhu@intel.com>
 <1229654263-21454-32-git-send-email-yi.zhu@intel.com>
 <1229654263-21454-33-git-send-email-yi.zhu@intel.com>
 <1229654263-21454-34-git-send-email-yi.zhu@intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Winkler, Tomas <tomas.winkler@intel.com>

This patch makes use of iwl_cmd instead of iwl3945_cmd and related
structures which were just the same.

Signed-off-by: Tomas Winkler <tomas.winkler@intel.com>
Signed-off-by: Zhu Yi <yi.zhu@intel.com>
---
 drivers/net/wireless/iwlwifi/iwl-3945-led.c |    4 +-
 drivers/net/wireless/iwlwifi/iwl-3945.c     |   22 +++++-----
 drivers/net/wireless/iwlwifi/iwl-3945.h     |   61 +--------------------------
 drivers/net/wireless/iwlwifi/iwl-dev.h      |    2 +-
 drivers/net/wireless/iwlwifi/iwl3945-base.c |   54 ++++++++++++-----------
 5 files changed, 44 insertions(+), 99 deletions(-)

diff --git a/drivers/net/wireless/iwlwifi/iwl-3945-led.c b/drivers/net/wireless/iwlwifi/iwl-3945-led.c
index 958e705..10e68d6 100644
--- a/drivers/net/wireless/iwlwifi/iwl-3945-led.c
+++ b/drivers/net/wireless/iwlwifi/iwl-3945-led.c
@@ -68,7 +68,7 @@ static const struct {
 #define IWL_SOLID_BLINK_IDX (ARRAY_SIZE(blink_tbl) - 1)
 
 static int iwl3945_led_cmd_callback(struct iwl_priv *priv,
-				    struct iwl3945_cmd *cmd,
+				    struct iwl_cmd *cmd,
 				    struct sk_buff *skb)
 {
 	return 1;
@@ -83,7 +83,7 @@ static inline int iwl3945_brightness_to_idx(enum led_brightness brightness)
 static int iwl_send_led_cmd(struct iwl_priv *priv,
 			    struct iwl_led_cmd *led_cmd)
 {
-	struct iwl3945_host_cmd cmd = {
+	struct iwl_host_cmd cmd = {
 		.id = REPLY_LEDS_CMD,
 		.len = sizeof(struct iwl_led_cmd),
 		.data = led_cmd,
diff --git a/drivers/net/wireless/iwlwifi/iwl-3945.c b/drivers/net/wireless/iwlwifi/iwl-3945.c
index 5a44a87..aaf21e3 100644
--- a/drivers/net/wireless/iwlwifi/iwl-3945.c
+++ b/drivers/net/wireless/iwlwifi/iwl-3945.c
@@ -827,8 +827,7 @@ u8 iwl3945_hw_find_station(struct iwl_priv *priv, const u8 *addr)
  * iwl3945_hw_build_tx_cmd_rate - Add rate portion to TX_CMD:
  *
 */
-void iwl3945_hw_build_tx_cmd_rate(struct iwl_priv *priv,
-			      struct iwl3945_cmd *cmd,
+void iwl3945_hw_build_tx_cmd_rate(struct iwl_priv *priv, struct iwl_cmd *cmd,
 			      struct ieee80211_tx_info *info,
 			      struct ieee80211_hdr *hdr, int sta_id, int tx_id)
 {
@@ -840,9 +839,10 @@ void iwl3945_hw_build_tx_cmd_rate(struct iwl_priv *priv,
 	u8 data_retry_limit;
 	__le32 tx_flags;
 	__le16 fc = hdr->frame_control;
+	struct iwl3945_tx_cmd *tx = (struct iwl3945_tx_cmd *)cmd->cmd.payload;
 
 	rate = iwl3945_rates[rate_index].plcp;
-	tx_flags = cmd->cmd.tx.tx_flags;
+	tx_flags = tx->tx_flags;
 
 	/* We need to figure out how to get the sta->supp_rates while
 	 * in this running context */
@@ -879,22 +879,22 @@ void iwl3945_hw_build_tx_cmd_rate(struct iwl_priv *priv,
 		}
 	}
 
-	cmd->cmd.tx.rts_retry_limit = rts_retry_limit;
-	cmd->cmd.tx.data_retry_limit = data_retry_limit;
-	cmd->cmd.tx.rate = rate;
-	cmd->cmd.tx.tx_flags = tx_flags;
+	tx->rts_retry_limit = rts_retry_limit;
+	tx->data_retry_limit = data_retry_limit;
+	tx->rate = rate;
+	tx->tx_flags = tx_flags;
 
 	/* OFDM */
-	cmd->cmd.tx.supp_rates[0] =
+	tx->supp_rates[0] =
 	   ((rate_mask & IWL_OFDM_RATES_MASK) >> IWL_FIRST_OFDM_RATE) & 0xFF;
 
 	/* CCK */
-	cmd->cmd.tx.supp_rates[1] = (rate_mask & 0xF);
+	tx->supp_rates[1] = (rate_mask & 0xF);
 
 	IWL_DEBUG_RATE("Tx sta id: %d, rate: %d (plcp), flags: 0x%4X "
 		       "cck/ofdm mask: 0x%x/0x%x\n", sta_id,
-		       cmd->cmd.tx.rate, le32_to_cpu(cmd->cmd.tx.tx_flags),
-		       cmd->cmd.tx.supp_rates[1], cmd->cmd.tx.supp_rates[0]);
+		       tx->rate, le32_to_cpu(tx->tx_flags),
+		       tx->supp_rates[1], tx->supp_rates[0]);
 }
 
 u8 iwl3945_sync_sta(struct iwl_priv *priv, int sta_id, u16 tx_rate, u8 flags)
diff --git a/drivers/net/wireless/iwlwifi/iwl-3945.h b/drivers/net/wireless/iwlwifi/iwl-3945.h
index 63bf832..18424a3 100644
--- a/drivers/net/wireless/iwlwifi/iwl-3945.h
+++ b/drivers/net/wireless/iwlwifi/iwl-3945.h
@@ -147,62 +147,6 @@ struct iwl3945_frame {
 #define SN_TO_SEQ(ssn) (((ssn) << 4) & IEEE80211_SCTL_SEQ)
 #define MAX_SN ((IEEE80211_SCTL_SEQ) >> 4)
 
-struct iwl3945_cmd;
-struct iwl_priv;
-
-struct iwl3945_cmd_meta {
-	struct iwl3945_cmd_meta *source;
-	union {
-		struct sk_buff *skb;
-		int (*callback)(struct iwl_priv *priv,
-				struct iwl3945_cmd *cmd, struct sk_buff *skb);
-	} __attribute__ ((packed)) u;
-
-	/* The CMD_SIZE_HUGE flag bit indicates that the command
-	 * structure is stored at the end of the shared queue memory. */
-	u32 flags;
-
-} __attribute__ ((packed));
-
-/**
- * struct iwl3945_cmd
- *
- * For allocation of the command and tx queues, this establishes the overall
- * size of the largest command we send to uCode, except for a scan command
- * (which is relatively huge; space is allocated separately).
- */
-struct iwl3945_cmd {
-	struct iwl3945_cmd_meta meta;
-	struct iwl_cmd_header hdr;
-	union {
-		struct iwl3945_addsta_cmd addsta;
-		struct iwl_led_cmd led;
-		u32 flags;
-		u8 val8;
-		u16 val16;
-		u32 val32;
-		struct iwl_bt_cmd bt;
-		struct iwl_rxon_time_cmd rxon_time;
-		struct iwl_powertable_cmd powertable;
-		struct iwl_qosparam_cmd qosparam;
-		struct iwl3945_tx_cmd tx;
-		struct iwl3945_tx_beacon_cmd tx_beacon;
-		struct iwl3945_rxon_assoc_cmd rxon_assoc;
-		u8 *indirect;
-		u8 payload[360];
-	} __attribute__ ((packed)) cmd;
-} __attribute__ ((packed));
-
-struct iwl3945_host_cmd {
-	u8 id;
-	u16 len;
-	struct iwl3945_cmd_meta meta;
-	const void *data;
-};
-
-#define TFD39_MAX_PAYLOAD_SIZE (sizeof(struct iwl3945_cmd) - \
-			      sizeof(struct iwl3945_cmd_meta))
-
 /*
  * RX related structures and functions
  */
@@ -288,7 +232,7 @@ extern void iwl3945_tx_queue_free(struct iwl_priv *priv, struct iwl3945_tx_queue
 extern int iwl3945_send_cmd_pdu(struct iwl_priv *priv, u8 id, u16 len,
 			    const void *data);
 extern int __must_check iwl3945_send_cmd(struct iwl_priv *priv,
-		struct iwl3945_host_cmd *cmd);
+					 struct iwl_host_cmd *cmd);
 extern unsigned int iwl3945_fill_beacon_frame(struct iwl_priv *priv,
 					struct ieee80211_hdr *hdr,int left);
 extern int iwl3945_rx_queue_update_write_ptr(struct iwl_priv *priv,
@@ -340,8 +284,7 @@ extern int iwl3945_hw_tx_queue_init(struct iwl_priv *priv,
 extern unsigned int iwl3945_hw_get_beacon_cmd(struct iwl_priv *priv,
 				 struct iwl3945_frame *frame, u8 rate);
 extern int iwl3945_hw_get_rx_read(struct iwl_priv *priv);
-extern void iwl3945_hw_build_tx_cmd_rate(struct iwl_priv *priv,
-				     struct iwl3945_cmd *cmd,
+void iwl3945_hw_build_tx_cmd_rate(struct iwl_priv *priv, struct iwl_cmd *cmd,
 				     struct ieee80211_tx_info *info,
 				     struct ieee80211_hdr *hdr,
 				     int sta_id, int tx_id);
diff --git a/drivers/net/wireless/iwlwifi/iwl-dev.h b/drivers/net/wireless/iwlwifi/iwl-dev.h
index 5cc6c5e..6a07a68 100644
--- a/drivers/net/wireless/iwlwifi/iwl-dev.h
+++ b/drivers/net/wireless/iwlwifi/iwl-dev.h
@@ -240,7 +240,7 @@ struct iwl_channel_info {
 struct iwl3945_tx_queue {
 	struct iwl_queue q;
 	struct iwl3945_tfd_frame *bd;
-	struct iwl3945_cmd *cmd;
+	struct iwl_cmd *cmd;
 	dma_addr_t dma_addr_cmd;
 	struct iwl3945_tx_info *txb;
 	int need_update;
diff --git a/drivers/net/wireless/iwlwifi/iwl3945-base.c b/drivers/net/wireless/iwlwifi/iwl3945-base.c
index d84c4ce..fc17787 100644
--- a/drivers/net/wireless/iwlwifi/iwl3945-base.c
+++ b/drivers/net/wireless/iwlwifi/iwl3945-base.c
@@ -232,7 +232,7 @@ int iwl3945_tx_queue_init(struct iwl_priv *priv,
 	 * For data Tx queues (all other queues), no super-size command
 	 * space is needed.
 	 */
-	len = sizeof(struct iwl3945_cmd) * slots_num;
+	len = sizeof(struct iwl_cmd) * slots_num;
 	if (txq_id == IWL_CMD_QUEUE_NUM)
 		len +=  IWL_MAX_SCAN_SIZE;
 	txq->cmd = pci_alloc_consistent(dev, len, &txq->dma_addr_cmd);
@@ -283,7 +283,7 @@ void iwl3945_tx_queue_free(struct iwl_priv *priv, struct iwl3945_tx_queue *txq)
 	     q->read_ptr = iwl_queue_inc_wrap(q->read_ptr, q->n_bd))
 		iwl3945_hw_txq_free_tfd(priv, txq);
 
-	len = sizeof(struct iwl3945_cmd) * q->n_window;
+	len = sizeof(struct iwl_cmd) * q->n_window;
 	if (q->id == IWL_CMD_QUEUE_NUM)
 		len += IWL_MAX_SCAN_SIZE;
 
@@ -501,13 +501,13 @@ static inline int iwl3945_is_ready_rf(struct iwl_priv *priv)
  * failed. On success, it turns the index (> 0) of command in the
  * command queue.
  */
-static int iwl3945_enqueue_hcmd(struct iwl_priv *priv, struct iwl3945_host_cmd *cmd)
+static int iwl3945_enqueue_hcmd(struct iwl_priv *priv, struct iwl_host_cmd *cmd)
 {
 	struct iwl3945_tx_queue *txq = &priv->txq39[IWL_CMD_QUEUE_NUM];
 	struct iwl_queue *q = &txq->q;
 	struct iwl3945_tfd_frame *tfd;
 	u32 *control_flags;
-	struct iwl3945_cmd *out_cmd;
+	struct iwl_cmd *out_cmd;
 	u32 idx;
 	u16 fix_size = (u16)(cmd->len + sizeof(out_cmd->hdr));
 	dma_addr_t phys_addr;
@@ -519,7 +519,7 @@ static int iwl3945_enqueue_hcmd(struct iwl_priv *priv, struct iwl3945_host_cmd *
 	/* If any of the command structures end up being larger than
 	 * the TFD_MAX_PAYLOAD_SIZE, and it sent as a 'small' command then
 	 * we will need to increase the size of the TFD entries */
-	BUG_ON((fix_size > TFD39_MAX_PAYLOAD_SIZE) &&
+	BUG_ON((fix_size > TFD_MAX_PAYLOAD_SIZE) &&
 	       !(cmd->meta.flags & CMD_SIZE_HUGE));
 
 
@@ -557,7 +557,7 @@ static int iwl3945_enqueue_hcmd(struct iwl_priv *priv, struct iwl3945_host_cmd *
 		out_cmd->hdr.sequence |= SEQ_HUGE_FRAME;
 
 	phys_addr = txq->dma_addr_cmd + sizeof(txq->cmd[0]) * idx +
-			offsetof(struct iwl3945_cmd, hdr);
+			offsetof(struct iwl_cmd, hdr);
 	iwl3945_hw_txq_attach_buf_to_tfd(priv, tfd, phys_addr, fix_size);
 
 	pad = U32_PAD(cmd->len);
@@ -580,7 +580,8 @@ static int iwl3945_enqueue_hcmd(struct iwl_priv *priv, struct iwl3945_host_cmd *
 	return ret ? ret : idx;
 }
 
-static int iwl3945_send_cmd_async(struct iwl_priv *priv, struct iwl3945_host_cmd *cmd)
+static int iwl3945_send_cmd_async(struct iwl_priv *priv,
+				  struct iwl_host_cmd *cmd)
 {
 	int ret;
 
@@ -605,7 +606,8 @@ static int iwl3945_send_cmd_async(struct iwl_priv *priv, struct iwl3945_host_cmd
 	return 0;
 }
 
-static int iwl3945_send_cmd_sync(struct iwl_priv *priv, struct iwl3945_host_cmd *cmd)
+static int iwl3945_send_cmd_sync(struct iwl_priv *priv,
+				 struct iwl_host_cmd *cmd)
 {
 	int cmd_idx;
 	int ret;
@@ -676,7 +678,7 @@ static int iwl3945_send_cmd_sync(struct iwl_priv *priv, struct iwl3945_host_cmd
 
 cancel:
 	if (cmd->meta.flags & CMD_WANT_SKB) {
-		struct iwl3945_cmd *qcmd;
+		struct iwl_cmd *qcmd;
 
 		/* Cancel the CMD_WANT_SKB flag for the cmd in the
 		 * TX cmd queue. Otherwise in case the cmd comes
@@ -695,7 +697,7 @@ out:
 	return ret;
 }
 
-int iwl3945_send_cmd(struct iwl_priv *priv, struct iwl3945_host_cmd *cmd)
+int iwl3945_send_cmd(struct iwl_priv *priv, struct iwl_host_cmd *cmd)
 {
 	if (cmd->meta.flags & CMD_ASYNC)
 		return iwl3945_send_cmd_async(priv, cmd);
@@ -705,7 +707,7 @@ int iwl3945_send_cmd(struct iwl_priv *priv, struct iwl3945_host_cmd *cmd)
 
 int iwl3945_send_cmd_pdu(struct iwl_priv *priv, u8 id, u16 len, const void *data)
 {
-	struct iwl3945_host_cmd cmd = {
+	struct iwl_host_cmd cmd = {
 		.id = id,
 		.len = len,
 		.data = data,
@@ -716,7 +718,7 @@ int iwl3945_send_cmd_pdu(struct iwl_priv *priv, u8 id, u16 len, const void *data
 
 static int __must_check iwl3945_send_cmd_u32(struct iwl_priv *priv, u8 id, u32 val)
 {
-	struct iwl3945_host_cmd cmd = {
+	struct iwl_host_cmd cmd = {
 		.id = id,
 		.len = sizeof(val),
 		.data = &val,
@@ -895,7 +897,7 @@ static int iwl3945_send_rxon_assoc(struct iwl_priv *priv)
 	int rc = 0;
 	struct iwl_rx_packet *res = NULL;
 	struct iwl3945_rxon_assoc_cmd rxon_assoc;
-	struct iwl3945_host_cmd cmd = {
+	struct iwl_host_cmd cmd = {
 		.id = REPLY_RXON_ASSOC,
 		.len = sizeof(rxon_assoc),
 		.meta.flags = CMD_WANT_SKB,
@@ -1079,7 +1081,7 @@ static int iwl3945_send_scan_abort(struct iwl_priv *priv)
 {
 	int rc = 0;
 	struct iwl_rx_packet *res;
-	struct iwl3945_host_cmd cmd = {
+	struct iwl_host_cmd cmd = {
 		.id = REPLY_SCAN_ABORT_CMD,
 		.meta.flags = CMD_WANT_SKB,
 	};
@@ -1117,7 +1119,7 @@ static int iwl3945_send_scan_abort(struct iwl_priv *priv)
 }
 
 static int iwl3945_card_state_sync_callback(struct iwl_priv *priv,
-					struct iwl3945_cmd *cmd,
+					struct iwl_cmd *cmd,
 					struct sk_buff *skb)
 {
 	return 1;
@@ -1135,7 +1137,7 @@ static int iwl3945_card_state_sync_callback(struct iwl_priv *priv,
  */
 static int iwl3945_send_card_state(struct iwl_priv *priv, u32 flags, u8 meta_flag)
 {
-	struct iwl3945_host_cmd cmd = {
+	struct iwl_host_cmd cmd = {
 		.id = REPLY_CARD_STATE_CMD,
 		.len = sizeof(u32),
 		.data = &flags,
@@ -1149,7 +1151,7 @@ static int iwl3945_send_card_state(struct iwl_priv *priv, u32 flags, u8 meta_fla
 }
 
 static int iwl3945_add_sta_sync_callback(struct iwl_priv *priv,
-				     struct iwl3945_cmd *cmd, struct sk_buff *skb)
+				     struct iwl_cmd *cmd, struct sk_buff *skb)
 {
 	struct iwl_rx_packet *res = NULL;
 
@@ -1181,7 +1183,7 @@ int iwl3945_send_add_station(struct iwl_priv *priv,
 {
 	struct iwl_rx_packet *res = NULL;
 	int rc = 0;
-	struct iwl3945_host_cmd cmd = {
+	struct iwl_host_cmd cmd = {
 		.id = REPLY_ADD_STA,
 		.len = sizeof(struct iwl3945_addsta_cmd),
 		.meta.flags = flags,
@@ -2204,7 +2206,7 @@ static int iwl3945_set_mode(struct iwl_priv *priv, int mode)
 
 static void iwl3945_build_tx_cmd_hwcrypto(struct iwl_priv *priv,
 				      struct ieee80211_tx_info *info,
-				      struct iwl3945_cmd *cmd,
+				      struct iwl_cmd *cmd,
 				      struct sk_buff *skb_frag,
 				      int last_frag)
 {
@@ -2253,7 +2255,7 @@ static void iwl3945_build_tx_cmd_hwcrypto(struct iwl_priv *priv,
  * handle build REPLY_TX command notification.
  */
 static void iwl3945_build_tx_cmd_basic(struct iwl_priv *priv,
-				  struct iwl3945_cmd *cmd,
+				  struct iwl_cmd *cmd,
 				  struct ieee80211_tx_info *info,
 				  struct ieee80211_hdr *hdr,
 				  int is_unicast, u8 std_id)
@@ -2390,7 +2392,7 @@ static int iwl3945_tx_skb(struct iwl_priv *priv, struct sk_buff *skb)
 	struct iwl_queue *q = NULL;
 	dma_addr_t phys_addr;
 	dma_addr_t txcmd_phys;
-	struct iwl3945_cmd *out_cmd = NULL;
+	struct iwl_cmd *out_cmd = NULL;
 	u16 len, idx, len_org, hdr_len;
 	u8 id;
 	u8 unicast;
@@ -2520,8 +2522,8 @@ static int iwl3945_tx_skb(struct iwl_priv *priv, struct sk_buff *skb)
 
 	/* Physical address of this Tx command's header (not MAC header!),
 	 * within command buffer array. */
-	txcmd_phys = txq->dma_addr_cmd + sizeof(struct iwl3945_cmd) * idx +
-		     offsetof(struct iwl3945_cmd, hdr);
+	txcmd_phys = txq->dma_addr_cmd + sizeof(struct iwl_cmd) * idx +
+		     offsetof(struct iwl_cmd, hdr);
 
 	/* Add buffer containing Tx command and MAC(!) header to TFD's
 	 * first entry */
@@ -2799,7 +2801,7 @@ static int iwl3945_get_measurement(struct iwl_priv *priv,
 {
 	struct iwl_spectrum_cmd spectrum;
 	struct iwl_rx_packet *res;
-	struct iwl3945_host_cmd cmd = {
+	struct iwl_host_cmd cmd = {
 		.id = REPLY_SPECTRUM_MEASUREMENT_CMD,
 		.data = (void *)&spectrum,
 		.meta.flags = CMD_WANT_SKB,
@@ -3277,7 +3279,7 @@ static void iwl3945_tx_cmd_complete(struct iwl_priv *priv,
 	int index = SEQ_TO_INDEX(sequence);
 	int huge =  !!(pkt->hdr.sequence & SEQ_HUGE_FRAME);
 	int cmd_index;
-	struct iwl3945_cmd *cmd;
+	struct iwl_cmd *cmd;
 
 	BUG_ON(txq_id != IWL_CMD_QUEUE_NUM);
 
@@ -5984,7 +5986,7 @@ static void iwl3945_bg_request_scan(struct work_struct *data)
 {
 	struct iwl_priv *priv =
 	    container_of(data, struct iwl_priv, request_scan);
-	struct iwl3945_host_cmd cmd = {
+	struct iwl_host_cmd cmd = {
 		.id = REPLY_SCAN_CMD,
 		.len = sizeof(struct iwl3945_scan_cmd),
 		.meta.flags = CMD_SIZE_HUGE,
-- 
1.5.3.6

