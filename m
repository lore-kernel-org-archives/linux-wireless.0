Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from dakia2.marvell.com ([65.219.4.35]:44809 "EHLO
	dakia2.marvell.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755620Ab1DNAW6 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 13 Apr 2011 20:22:58 -0400
From: Bing Zhao <bzhao@marvell.com>
To: linux-wireless@vger.kernel.org
Cc: "John W. Linville" <linville@tuxdriver.com>,
	Johannes Berg <johannes@sipsolutions.net>,
	Amitkumar Karwar <akarwar@marvell.com>,
	Kiran Divekar <dkiran@marvell.com>,
	Yogesh Powar <yogeshp@marvell.com>,
	Marc Yang <yangyang@marvell.com>,
	Frank Huang <frankh@marvell.com>, Bing Zhao <bzhao@marvell.com>
Subject: [PATCH 3/4] mwifiex: remove unused function parameters
Date: Wed, 13 Apr 2011 17:27:08 -0700
Message-Id: <1302740829-21315-3-git-send-email-bzhao@marvell.com>
In-Reply-To: <1302740829-21315-1-git-send-email-bzhao@marvell.com>
References: <1302740829-21315-1-git-send-email-bzhao@marvell.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Amitkumar Karwar <akarwar@marvell.com>

Some function parameters become useless after previous
cleanup changes.

Signed-off-by: Amitkumar Karwar <akarwar@marvell.com>
Signed-off-by: Bing Zhao <bzhao@marvell.com>
---
 drivers/net/wireless/mwifiex/11n.c           |   13 ++-----
 drivers/net/wireless/mwifiex/11n.h           |   50 +++++++++-----------------
 drivers/net/wireless/mwifiex/11n_aggr.c      |    5 +--
 drivers/net/wireless/mwifiex/11n_rxreorder.c |    6 +--
 drivers/net/wireless/mwifiex/11n_rxreorder.h |    6 +--
 drivers/net/wireless/mwifiex/cfp.c           |    9 ++---
 drivers/net/wireless/mwifiex/main.h          |   17 +++------
 drivers/net/wireless/mwifiex/scan.c          |    7 +---
 drivers/net/wireless/mwifiex/sdio.c          |   18 ++++-----
 drivers/net/wireless/mwifiex/sta_cmd.c       |   40 +++++++++------------
 drivers/net/wireless/mwifiex/sta_cmdresp.c   |   13 ++-----
 drivers/net/wireless/mwifiex/sta_ioctl.c     |    7 ++--
 drivers/net/wireless/mwifiex/wmm.c           |   17 ++++-----
 drivers/net/wireless/mwifiex/wmm.h           |    8 ++---
 14 files changed, 80 insertions(+), 136 deletions(-)

diff --git a/drivers/net/wireless/mwifiex/11n.c b/drivers/net/wireless/mwifiex/11n.c
index c57107a..d64065f 100644
--- a/drivers/net/wireless/mwifiex/11n.c
+++ b/drivers/net/wireless/mwifiex/11n.c
@@ -242,9 +242,7 @@ int mwifiex_ret_11n_addba_req(struct mwifiex_private *priv,
  *
  * Handling includes changing the header fields into CPU format.
  */
-int mwifiex_ret_11n_cfg(struct mwifiex_private *priv,
-			struct host_cmd_ds_command *resp,
-			void *data_buf)
+int mwifiex_ret_11n_cfg(struct host_cmd_ds_command *resp, void *data_buf)
 {
 	struct mwifiex_ds_11n_tx_cfg *tx_cfg = NULL;
 	struct host_cmd_ds_11n_cfg *htcfg = &resp->params.htcfg;
@@ -298,8 +296,7 @@ int mwifiex_cmd_recfg_tx_buf(struct mwifiex_private *priv,
  *      - Setting AMSDU control parameters (for SET only)
  *      - Ensuring correct endian-ness
  */
-int mwifiex_cmd_amsdu_aggr_ctrl(struct mwifiex_private *priv,
-				struct host_cmd_ds_command *cmd,
+int mwifiex_cmd_amsdu_aggr_ctrl(struct host_cmd_ds_command *cmd,
 				int cmd_action, void *data_buf)
 {
 	struct host_cmd_ds_amsdu_aggr_ctrl *amsdu_ctrl =
@@ -331,8 +328,7 @@ int mwifiex_cmd_amsdu_aggr_ctrl(struct mwifiex_private *priv,
  *
  * Handling includes changing the header fields into CPU format.
  */
-int mwifiex_ret_amsdu_aggr_ctrl(struct mwifiex_private *priv,
-				struct host_cmd_ds_command *resp,
+int mwifiex_ret_amsdu_aggr_ctrl(struct host_cmd_ds_command *resp,
 				void *data_buf)
 {
 	struct mwifiex_ds_11n_amsdu_aggr_ctrl *amsdu_aggr_ctrl = NULL;
@@ -357,8 +353,7 @@ int mwifiex_ret_amsdu_aggr_ctrl(struct mwifiex_private *priv,
  *      - Setting HT Tx capability and HT Tx information fields
  *      - Ensuring correct endian-ness
  */
-int mwifiex_cmd_11n_cfg(struct mwifiex_private *priv,
-			struct host_cmd_ds_command *cmd,
+int mwifiex_cmd_11n_cfg(struct host_cmd_ds_command *cmd,
 			u16 cmd_action, void *data_buf)
 {
 	struct host_cmd_ds_11n_cfg *htcfg = &cmd->params.htcfg;
diff --git a/drivers/net/wireless/mwifiex/11n.h b/drivers/net/wireless/mwifiex/11n.h
index 71a853e..9128d2c 100644
--- a/drivers/net/wireless/mwifiex/11n.h
+++ b/drivers/net/wireless/mwifiex/11n.h
@@ -28,15 +28,9 @@ int mwifiex_ret_11n_delba(struct mwifiex_private *priv,
 			  struct host_cmd_ds_command *resp);
 int mwifiex_ret_11n_addba_req(struct mwifiex_private *priv,
 			      struct host_cmd_ds_command *resp);
-int mwifiex_ret_11n_cfg(struct mwifiex_private *priv,
-			struct host_cmd_ds_command *resp,
+int mwifiex_ret_11n_cfg(struct host_cmd_ds_command *resp,
 			void *data_buf);
-int mwifiex_cmd_11n_cfg(struct mwifiex_private *priv,
-			struct host_cmd_ds_command *cmd,
-			u16 cmd_action, void *data_buf);
-
-int mwifiex_cmd_11n_cfg(struct mwifiex_private *priv,
-			struct host_cmd_ds_command *cmd,
+int mwifiex_cmd_11n_cfg(struct host_cmd_ds_command *cmd,
 			u16 cmd_action, void *data_buf);
 
 int mwifiex_cmd_append_11n_tlv(struct mwifiex_private *priv,
@@ -67,24 +61,19 @@ int mwifiex_get_rx_reorder_tbl(struct mwifiex_private *priv,
 			      struct mwifiex_ds_rx_reorder_tbl *buf);
 int mwifiex_get_tx_ba_stream_tbl(struct mwifiex_private *priv,
 			       struct mwifiex_ds_tx_ba_stream_tbl *buf);
-int mwifiex_ret_amsdu_aggr_ctrl(struct mwifiex_private *priv,
-				struct host_cmd_ds_command
-				*resp,
+int mwifiex_ret_amsdu_aggr_ctrl(struct host_cmd_ds_command *resp,
 				void *data_buf);
 int mwifiex_cmd_recfg_tx_buf(struct mwifiex_private *priv,
 			     struct host_cmd_ds_command *cmd,
 			     int cmd_action, void *data_buf);
-int mwifiex_cmd_amsdu_aggr_ctrl(struct mwifiex_private *priv,
-				struct host_cmd_ds_command *cmd,
-				int cmd_action,
-				void *data_buf);
+int mwifiex_cmd_amsdu_aggr_ctrl(struct host_cmd_ds_command *cmd,
+				int cmd_action, void *data_buf);
 
 /*
  * This function checks whether AMPDU is allowed or not for a particular TID.
  */
 static inline u8
-mwifiex_is_ampdu_allowed(struct mwifiex_private *priv,
-			 struct mwifiex_ra_list_tbl *ptr, int tid)
+mwifiex_is_ampdu_allowed(struct mwifiex_private *priv, int tid)
 {
 	return ((priv->aggr_prio_tbl[tid].ampdu_ap != BA_STREAM_NOT_ALLOWED)
 		? true : false);
@@ -94,8 +83,7 @@ mwifiex_is_ampdu_allowed(struct mwifiex_private *priv,
  * This function checks whether AMSDU is allowed or not for a particular TID.
  */
 static inline u8
-mwifiex_is_amsdu_allowed(struct mwifiex_private *priv,
-			 struct mwifiex_ra_list_tbl *ptr, int tid)
+mwifiex_is_amsdu_allowed(struct mwifiex_private *priv, int tid)
 {
 	return (((priv->aggr_prio_tbl[tid].amsdu != BA_STREAM_NOT_ALLOWED)
 			&& ((priv->is_data_rate_auto)
@@ -106,21 +94,18 @@ mwifiex_is_amsdu_allowed(struct mwifiex_private *priv,
 /*
  * This function checks whether a BA stream is available or not.
  */
-static inline u8
-mwifiex_is_ba_stream_avail(struct mwifiex_private *priv)
+static inline u8 mwifiex_is_ba_stream_avail(struct mwifiex_adapter *adapter)
 {
-	struct mwifiex_private *pmpriv = NULL;
-	u8 i = 0;
+	struct mwifiex_private *priv;
+	u8 i;
 	u32 ba_stream_num = 0;
 
-	for (i = 0; i < priv->adapter->priv_num; i++) {
-		pmpriv = priv->adapter->priv[i];
-		if (pmpriv)
-			ba_stream_num +=
-				mwifiex_wmm_list_len(priv->adapter,
-						     (struct list_head
-						      *) &pmpriv->
-						     tx_ba_stream_tbl_ptr);
+	for (i = 0; i < adapter->priv_num; i++) {
+		priv = adapter->priv[i];
+		if (priv)
+			ba_stream_num += mwifiex_wmm_list_len(
+						(struct list_head *)
+						&priv->tx_ba_stream_tbl_ptr);
 	}
 
 	return ((ba_stream_num <
@@ -133,8 +118,7 @@ mwifiex_is_ba_stream_avail(struct mwifiex_private *priv)
  * Upon successfully locating, both the TID and the RA are returned.
  */
 static inline u8
-mwifiex_find_stream_to_delete(struct mwifiex_private *priv,
-			      struct mwifiex_ra_list_tbl *ptr, int ptr_tid,
+mwifiex_find_stream_to_delete(struct mwifiex_private *priv, int ptr_tid,
 			      int *ptid, u8 *ra)
 {
 	int tid;
diff --git a/drivers/net/wireless/mwifiex/11n_aggr.c b/drivers/net/wireless/mwifiex/11n_aggr.c
index c2abced..c9fb062 100644
--- a/drivers/net/wireless/mwifiex/11n_aggr.c
+++ b/drivers/net/wireless/mwifiex/11n_aggr.c
@@ -44,8 +44,7 @@
  * MSDU => |DA|SA|Length|SNAP|......   ..|
  */
 static int
-mwifiex_11n_form_amsdu_pkt(struct mwifiex_adapter *adapter,
-			   struct sk_buff *skb_aggr,
+mwifiex_11n_form_amsdu_pkt(struct sk_buff *skb_aggr,
 			   struct sk_buff *skb_src, int *pad)
 
 {
@@ -324,7 +323,7 @@ mwifiex_11n_aggregate_pkt(struct mwifiex_private *priv,
 
 		spin_unlock_irqrestore(&priv->wmm.ra_list_spinlock,
 				       ra_list_flags);
-		mwifiex_11n_form_amsdu_pkt(adapter, skb_aggr, skb_src, &pad);
+		mwifiex_11n_form_amsdu_pkt(skb_aggr, skb_src, &pad);
 
 		mwifiex_write_data_complete(adapter, skb_src, 0);
 
diff --git a/drivers/net/wireless/mwifiex/11n_rxreorder.c b/drivers/net/wireless/mwifiex/11n_rxreorder.c
index 6736fc6..755e5d5 100644
--- a/drivers/net/wireless/mwifiex/11n_rxreorder.c
+++ b/drivers/net/wireless/mwifiex/11n_rxreorder.c
@@ -319,8 +319,7 @@ mwifiex_11n_create_rx_reorder_tbl(struct mwifiex_private *priv, u8 *ta,
  *      - Setting add BA request buffer
  *      - Ensuring correct endian-ness
  */
-int mwifiex_cmd_11n_addba_req(struct mwifiex_private *priv,
-			      struct host_cmd_ds_command *cmd, void *data_buf)
+int mwifiex_cmd_11n_addba_req(struct host_cmd_ds_command *cmd, void *data_buf)
 {
 	struct host_cmd_ds_11n_addba_req *add_ba_req =
 		(struct host_cmd_ds_11n_addba_req *)
@@ -391,8 +390,7 @@ int mwifiex_cmd_11n_addba_rsp_gen(struct mwifiex_private *priv,
  *      - Setting del BA request buffer
  *      - Ensuring correct endian-ness
  */
-int mwifiex_cmd_11n_delba(struct mwifiex_private *priv,
-			  struct host_cmd_ds_command *cmd, void *data_buf)
+int mwifiex_cmd_11n_delba(struct host_cmd_ds_command *cmd, void *data_buf)
 {
 	struct host_cmd_ds_11n_delba *del_ba = (struct host_cmd_ds_11n_delba *)
 		&cmd->params.del_ba;
diff --git a/drivers/net/wireless/mwifiex/11n_rxreorder.h b/drivers/net/wireless/mwifiex/11n_rxreorder.h
index 42f5690..f3ca8c8 100644
--- a/drivers/net/wireless/mwifiex/11n_rxreorder.h
+++ b/drivers/net/wireless/mwifiex/11n_rxreorder.h
@@ -49,14 +49,12 @@ void mwifiex_11n_ba_stream_timeout(struct mwifiex_private *priv,
 int mwifiex_ret_11n_addba_resp(struct mwifiex_private *priv,
 			       struct host_cmd_ds_command
 			       *resp);
-int mwifiex_cmd_11n_delba(struct mwifiex_private *priv,
-			  struct host_cmd_ds_command *cmd,
+int mwifiex_cmd_11n_delba(struct host_cmd_ds_command *cmd,
 			  void *data_buf);
 int mwifiex_cmd_11n_addba_rsp_gen(struct mwifiex_private *priv,
 				  struct host_cmd_ds_command
 				  *cmd, void *data_buf);
-int mwifiex_cmd_11n_addba_req(struct mwifiex_private *priv,
-			      struct host_cmd_ds_command *cmd,
+int mwifiex_cmd_11n_addba_req(struct host_cmd_ds_command *cmd,
 			      void *data_buf);
 void mwifiex_11n_cleanup_reorder_tbl(struct mwifiex_private *priv);
 struct mwifiex_rx_reorder_tbl *mwifiex_11n_get_rxreorder_tbl(struct
diff --git a/drivers/net/wireless/mwifiex/cfp.c b/drivers/net/wireless/mwifiex/cfp.c
index 07187a4..bb73cfe 100644
--- a/drivers/net/wireless/mwifiex/cfp.c
+++ b/drivers/net/wireless/mwifiex/cfp.c
@@ -75,8 +75,7 @@ u8 supported_rates_n[N_SUPPORTED_RATES] = { 0x02, 0x04, 0 };
  * This function maps an index in supported rates table into
  * the corresponding data rate.
  */
-u32 mwifiex_index_to_data_rate(struct mwifiex_adapter *adapter, u8 index,
-			       u8 ht_info)
+u32 mwifiex_index_to_data_rate(u8 index, u8 ht_info)
 {
 	u16 mcs_rate[4][8] = {
 		{0x1b, 0x36, 0x51, 0x6c, 0xa2, 0xd8, 0xf3, 0x10e}
@@ -126,7 +125,7 @@ u32 mwifiex_index_to_data_rate(struct mwifiex_adapter *adapter, u8 index,
  * This function maps a data rate value into corresponding index in supported
  * rates table.
  */
-u8 mwifiex_data_rate_to_index(struct mwifiex_adapter *adapter, u32 rate)
+u8 mwifiex_data_rate_to_index(u32 rate)
 {
 	u16 *ptr;
 
@@ -265,9 +264,7 @@ mwifiex_is_rate_auto(struct mwifiex_private *priv)
 /*
  * This function converts rate bitmap into rate index.
  */
-int
-mwifiex_get_rate_index(struct mwifiex_adapter *adapter, u16 *rate_bitmap,
-		       int size)
+int mwifiex_get_rate_index(u16 *rate_bitmap, int size)
 {
 	int i;
 
diff --git a/drivers/net/wireless/mwifiex/main.h b/drivers/net/wireless/mwifiex/main.h
index 7ead15e..2d296dc 100644
--- a/drivers/net/wireless/mwifiex/main.h
+++ b/drivers/net/wireless/mwifiex/main.h
@@ -767,8 +767,7 @@ void *mwifiex_process_sta_txpd(struct mwifiex_private *, struct sk_buff *skb);
 int mwifiex_sta_init_cmd(struct mwifiex_private *, u8 first_sta);
 int mwifiex_scan_networks(struct mwifiex_private *priv,
 			  const struct mwifiex_user_scan_cfg *user_scan_in);
-int mwifiex_cmd_802_11_scan(struct mwifiex_private *priv,
-			    struct host_cmd_ds_command *cmd,
+int mwifiex_cmd_802_11_scan(struct host_cmd_ds_command *cmd,
 			    void *data_buf);
 void mwifiex_queue_scan_cmd(struct mwifiex_private *priv,
 			    struct cmd_ctrl_node *cmd_node);
@@ -806,9 +805,7 @@ int mwifiex_cmd_802_11_ad_hoc_join(struct mwifiex_private *priv,
 				   void *data_buf);
 int mwifiex_ret_802_11_ad_hoc(struct mwifiex_private *priv,
 			      struct host_cmd_ds_command *resp);
-int mwifiex_cmd_802_11_bg_scan_query(struct mwifiex_private *priv,
-				     struct host_cmd_ds_command *cmd,
-				     void *data_buf);
+int mwifiex_cmd_802_11_bg_scan_query(struct host_cmd_ds_command *cmd);
 struct mwifiex_chan_freq_power *
 			mwifiex_get_cfp_by_band_and_channel_from_cfg80211(
 						struct mwifiex_private *priv,
@@ -816,20 +813,16 @@ struct mwifiex_chan_freq_power *
 struct mwifiex_chan_freq_power *mwifiex_get_cfp_by_band_and_freq_from_cfg80211(
 						struct mwifiex_private *priv,
 						u8 band, u32 freq);
-u32 mwifiex_index_to_data_rate(struct mwifiex_adapter *adapter, u8 index,
-				 u8 ht_info);
+u32 mwifiex_index_to_data_rate(u8 index, u8 ht_info);
 u32 mwifiex_find_freq_from_band_chan(u8, u8);
 int mwifiex_cmd_append_vsie_tlv(struct mwifiex_private *priv, u16 vsie_mask,
 				u8 **buffer);
-u32 mwifiex_index_to_data_rate(struct mwifiex_adapter *adapter, u8 index,
-				 u8 ht_info);
 u32 mwifiex_get_active_data_rates(struct mwifiex_private *priv,
 				    u8 *rates);
 u32 mwifiex_get_supported_rates(struct mwifiex_private *priv, u8 *rates);
-u8 mwifiex_data_rate_to_index(struct mwifiex_adapter *adapter, u32 rate);
+u8 mwifiex_data_rate_to_index(u32 rate);
 u8 mwifiex_is_rate_auto(struct mwifiex_private *priv);
-int mwifiex_get_rate_index(struct mwifiex_adapter *adapter,
-			   u16 *rateBitmap, int size);
+int mwifiex_get_rate_index(u16 *rateBitmap, int size);
 extern u16 region_code_index[MWIFIEX_MAX_REGION_CODE];
 void mwifiex_save_curr_bcn(struct mwifiex_private *priv);
 void mwifiex_free_curr_bcn(struct mwifiex_private *priv);
diff --git a/drivers/net/wireless/mwifiex/scan.c b/drivers/net/wireless/mwifiex/scan.c
index 12fe021..8474271 100644
--- a/drivers/net/wireless/mwifiex/scan.c
+++ b/drivers/net/wireless/mwifiex/scan.c
@@ -2364,8 +2364,7 @@ int mwifiex_scan_networks(struct mwifiex_private *priv,
  *      - Setting command ID, and proper size
  *      - Ensuring correct endian-ness
  */
-int mwifiex_cmd_802_11_scan(struct mwifiex_private *priv,
-			    struct host_cmd_ds_command *cmd, void *data_buf)
+int mwifiex_cmd_802_11_scan(struct host_cmd_ds_command *cmd, void *data_buf)
 {
 	struct host_cmd_ds_802_11_scan *scan_cmd = &cmd->params.scan;
 	struct mwifiex_scan_cmd_config *scan_cfg;
@@ -2658,9 +2657,7 @@ done:
  *      - Setting background scan flush parameter
  *      - Ensuring correct endian-ness
  */
-int mwifiex_cmd_802_11_bg_scan_query(struct mwifiex_private *priv,
-				     struct host_cmd_ds_command *cmd,
-				     void *data_buf)
+int mwifiex_cmd_802_11_bg_scan_query(struct host_cmd_ds_command *cmd)
 {
 	struct host_cmd_ds_802_11_bg_scan_query *bg_query =
 		&cmd->params.bg_scan_query;
diff --git a/drivers/net/wireless/mwifiex/sdio.c b/drivers/net/wireless/mwifiex/sdio.c
index fa46df5..41c087d 100644
--- a/drivers/net/wireless/mwifiex/sdio.c
+++ b/drivers/net/wireless/mwifiex/sdio.c
@@ -282,7 +282,7 @@ mwifiex_read_reg(struct mwifiex_adapter *adapter, u32 reg, u32 *data)
  */
 static int
 mwifiex_write_data_sync(struct mwifiex_adapter *adapter,
-			u8 *buffer, u32 pkt_len, u32 port, u32 timeout)
+			u8 *buffer, u32 pkt_len, u32 port)
 {
 	struct sdio_mmc_card *card = adapter->card;
 	int ret = -1;
@@ -314,9 +314,8 @@ mwifiex_write_data_sync(struct mwifiex_adapter *adapter,
 /*
  * This function reads multiple data from SDIO card memory.
  */
-static int mwifiex_read_data_sync(struct mwifiex_adapter *adapter,
-				  u8 *buffer, u32 len,
-		       u32 port, u32 timeout, u8 claim)
+static int mwifiex_read_data_sync(struct mwifiex_adapter *adapter, u8 *buffer,
+				  u32 len, u32 port, u8 claim)
 {
 	struct sdio_mmc_card *card = adapter->card;
 	int ret = -1;
@@ -430,8 +429,7 @@ static int mwifiex_write_data_to_card(struct mwifiex_adapter *adapter,
 	int ret = 0;
 
 	do {
-		ret = mwifiex_write_data_sync(adapter, payload, pkt_len,
-								port, 0);
+		ret = mwifiex_write_data_sync(adapter, payload, pkt_len, port);
 		if (ret) {
 			i++;
 			dev_err(adapter->dev, "host_to_card, write iomem"
@@ -630,7 +628,7 @@ static int mwifiex_sdio_card_to_host(struct mwifiex_adapter *adapter,
 		return -1;
 	}
 
-	ret = mwifiex_read_data_sync(adapter, buffer, npayload, ioport, 0, 1);
+	ret = mwifiex_read_data_sync(adapter, buffer, npayload, ioport, 1);
 
 	if (ret) {
 		dev_err(adapter->dev, "%s: read iomem failed: %d\n", __func__,
@@ -769,7 +767,7 @@ static int mwifiex_prog_fw_w_helper(struct mwifiex_adapter *adapter,
 
 		ret = mwifiex_write_data_sync(adapter, fwbuf, tx_blocks *
 					      MWIFIEX_SDIO_BLOCK_SIZE,
-					      adapter->ioport, 0);
+					      adapter->ioport);
 		if (ret) {
 			dev_err(adapter->dev, "FW download, write iomem (%d)"
 					" failed @ %d\n", i, offset);
@@ -842,7 +840,7 @@ static void mwifiex_interrupt_status(struct mwifiex_adapter *adapter)
 	unsigned long flags;
 
 	if (mwifiex_read_data_sync(adapter, card->mp_regs, MAX_MP_REGS,
-				   REG_PORT | MWIFIEX_SDIO_BYTE_MODE_MASK, 0,
+				   REG_PORT | MWIFIEX_SDIO_BYTE_MODE_MASK,
 				   0)) {
 		dev_err(adapter->dev, "read mp_regs failed\n");
 		return;
@@ -1050,7 +1048,7 @@ static int mwifiex_sdio_card_to_host_mp_aggr(struct mwifiex_adapter *adapter,
 					   card->mpa_rx.buf_len,
 					   (adapter->ioport | 0x1000 |
 					    (card->mpa_rx.ports << 4)) +
-					   card->mpa_rx.start_port, 0, 1))
+					   card->mpa_rx.start_port, 1))
 			return -1;
 
 		curr_ptr = card->mpa_rx.buf;
diff --git a/drivers/net/wireless/mwifiex/sta_cmd.c b/drivers/net/wireless/mwifiex/sta_cmd.c
index dec4963..33c8ba1 100644
--- a/drivers/net/wireless/mwifiex/sta_cmd.c
+++ b/drivers/net/wireless/mwifiex/sta_cmd.c
@@ -190,8 +190,7 @@ static int mwifiex_cmd_802_11_snmp_mib(struct mwifiex_private *priv,
  *      - Ensuring correct endian-ness
  */
 static int
-mwifiex_cmd_802_11_get_log(struct mwifiex_private *priv,
-			   struct host_cmd_ds_command *cmd)
+mwifiex_cmd_802_11_get_log(struct host_cmd_ds_command *cmd)
 {
 	cmd->command = cpu_to_le16(HostCmd_CMD_802_11_GET_LOG);
 	cmd->size = cpu_to_le16(sizeof(struct host_cmd_ds_802_11_get_log) +
@@ -272,8 +271,7 @@ static int mwifiex_cmd_tx_rate_cfg(struct mwifiex_private *priv,
  *        (as required)
  *      - Ensuring correct endian-ness
  */
-static int mwifiex_cmd_tx_power_cfg(struct mwifiex_private *priv,
-				    struct host_cmd_ds_command *cmd,
+static int mwifiex_cmd_tx_power_cfg(struct host_cmd_ds_command *cmd,
 				    u16 cmd_action, void *data_buf)
 {
 	struct mwifiex_types_power_group *pg_tlv = NULL;
@@ -407,8 +405,7 @@ static int mwifiex_cmd_802_11_mac_address(struct mwifiex_private *priv,
  *      - Setting MAC multicast address
  *      - Ensuring correct endian-ness
  */
-static int mwifiex_cmd_mac_multicast_adr(struct mwifiex_private *priv,
-					 struct host_cmd_ds_command *cmd,
+static int mwifiex_cmd_mac_multicast_adr(struct host_cmd_ds_command *cmd,
 					 u16 cmd_action, void *data_buf)
 {
 	struct mwifiex_multicast_list *mcast_list =
@@ -463,8 +460,7 @@ static int mwifiex_cmd_802_11_deauthenticate(struct mwifiex_private *priv,
  *      - Setting command ID and proper size
  *      - Ensuring correct endian-ness
  */
-static int mwifiex_cmd_802_11_ad_hoc_stop(struct mwifiex_private *priv,
-					  struct host_cmd_ds_command *cmd)
+static int mwifiex_cmd_802_11_ad_hoc_stop(struct host_cmd_ds_command *cmd)
 {
 	cmd->command = cpu_to_le16(HostCmd_CMD_802_11_AD_HOC_STOP);
 	cmd->size = cpu_to_le16(S_DS_GEN);
@@ -777,8 +773,7 @@ static int mwifiex_cmd_802_11_rf_channel(struct mwifiex_private *priv,
  *      - Setting status to enable or disable (for SET only)
  *      - Ensuring correct endian-ness
  */
-static int mwifiex_cmd_ibss_coalescing_status(struct mwifiex_private *priv,
-					      struct host_cmd_ds_command *cmd,
+static int mwifiex_cmd_ibss_coalescing_status(struct host_cmd_ds_command *cmd,
 					      u16 cmd_action, void *data_buf)
 {
 	struct host_cmd_ds_802_11_ibss_status *ibss_coal =
@@ -946,7 +941,7 @@ int mwifiex_sta_prepare_cmd(struct mwifiex_private *priv, uint16_t cmd_no,
 						     cmd_action);
 		break;
 	case HostCmd_CMD_MAC_MULTICAST_ADR:
-		ret = mwifiex_cmd_mac_multicast_adr(priv, cmd_ptr, cmd_action,
+		ret = mwifiex_cmd_mac_multicast_adr(cmd_ptr, cmd_action,
 						    data_buf);
 		break;
 	case HostCmd_CMD_TX_RATE_CFG:
@@ -954,7 +949,7 @@ int mwifiex_sta_prepare_cmd(struct mwifiex_private *priv, uint16_t cmd_no,
 					      data_buf);
 		break;
 	case HostCmd_CMD_TXPWR_CFG:
-		ret = mwifiex_cmd_tx_power_cfg(priv, cmd_ptr, cmd_action,
+		ret = mwifiex_cmd_tx_power_cfg(cmd_ptr, cmd_action,
 					       data_buf);
 		break;
 	case HostCmd_CMD_802_11_PS_MODE_ENH:
@@ -966,11 +961,10 @@ int mwifiex_sta_prepare_cmd(struct mwifiex_private *priv, uint16_t cmd_no,
 				(struct mwifiex_hs_config_param *) data_buf);
 		break;
 	case HostCmd_CMD_802_11_SCAN:
-		ret = mwifiex_cmd_802_11_scan(priv, cmd_ptr, data_buf);
+		ret = mwifiex_cmd_802_11_scan(cmd_ptr, data_buf);
 		break;
 	case HostCmd_CMD_802_11_BG_SCAN_QUERY:
-		ret = mwifiex_cmd_802_11_bg_scan_query(priv, cmd_ptr,
-						       data_buf);
+		ret = mwifiex_cmd_802_11_bg_scan_query(cmd_ptr);
 		break;
 	case HostCmd_CMD_802_11_ASSOCIATE:
 		ret = mwifiex_cmd_802_11_associate(priv, cmd_ptr, data_buf);
@@ -984,14 +978,14 @@ int mwifiex_sta_prepare_cmd(struct mwifiex_private *priv, uint16_t cmd_no,
 						      data_buf);
 		break;
 	case HostCmd_CMD_802_11_GET_LOG:
-		ret = mwifiex_cmd_802_11_get_log(priv, cmd_ptr);
+		ret = mwifiex_cmd_802_11_get_log(cmd_ptr);
 		break;
 	case HostCmd_CMD_802_11_AD_HOC_JOIN:
 		ret = mwifiex_cmd_802_11_ad_hoc_join(priv, cmd_ptr,
 						     data_buf);
 		break;
 	case HostCmd_CMD_802_11_AD_HOC_STOP:
-		ret = mwifiex_cmd_802_11_ad_hoc_stop(priv, cmd_ptr);
+		ret = mwifiex_cmd_802_11_ad_hoc_stop(cmd_ptr);
 		break;
 	case HostCmd_CMD_RSSI_INFO:
 		ret = mwifiex_cmd_802_11_rssi_info(priv, cmd_ptr, cmd_action);
@@ -1036,10 +1030,10 @@ int mwifiex_sta_prepare_cmd(struct mwifiex_private *priv, uint16_t cmd_no,
 		cmd_ptr->size = cpu_to_le16(S_DS_GEN);
 		break;
 	case HostCmd_CMD_11N_ADDBA_REQ:
-		ret = mwifiex_cmd_11n_addba_req(priv, cmd_ptr, data_buf);
+		ret = mwifiex_cmd_11n_addba_req(cmd_ptr, data_buf);
 		break;
 	case HostCmd_CMD_11N_DELBA:
-		ret = mwifiex_cmd_11n_delba(priv, cmd_ptr, data_buf);
+		ret = mwifiex_cmd_11n_delba(cmd_ptr, data_buf);
 		break;
 	case HostCmd_CMD_11N_ADDBA_RSP:
 		ret = mwifiex_cmd_11n_addba_rsp_gen(priv, cmd_ptr, data_buf);
@@ -1058,11 +1052,11 @@ int mwifiex_sta_prepare_cmd(struct mwifiex_private *priv, uint16_t cmd_no,
 					       data_buf);
 		break;
 	case HostCmd_CMD_AMSDU_AGGR_CTRL:
-		ret = mwifiex_cmd_amsdu_aggr_ctrl(priv, cmd_ptr, cmd_action,
+		ret = mwifiex_cmd_amsdu_aggr_ctrl(cmd_ptr, cmd_action,
 						  data_buf);
 		break;
 	case HostCmd_CMD_11N_CFG:
-		ret = mwifiex_cmd_11n_cfg(priv, cmd_ptr, cmd_action,
+		ret = mwifiex_cmd_11n_cfg(cmd_ptr, cmd_action,
 					  data_buf);
 		break;
 	case HostCmd_CMD_WMM_GET_STATUS:
@@ -1075,8 +1069,8 @@ int mwifiex_sta_prepare_cmd(struct mwifiex_private *priv, uint16_t cmd_no,
 		ret = 0;
 		break;
 	case HostCmd_CMD_802_11_IBSS_COALESCING_STATUS:
-		ret = mwifiex_cmd_ibss_coalescing_status(priv, cmd_ptr,
-							 cmd_action, data_buf);
+		ret = mwifiex_cmd_ibss_coalescing_status(cmd_ptr, cmd_action,
+							 data_buf);
 		break;
 	case HostCmd_CMD_MAC_REG_ACCESS:
 	case HostCmd_CMD_BBP_REG_ACCESS:
diff --git a/drivers/net/wireless/mwifiex/sta_cmdresp.c b/drivers/net/wireless/mwifiex/sta_cmdresp.c
index 20ce8cb..7f4f10b 100644
--- a/drivers/net/wireless/mwifiex/sta_cmdresp.c
+++ b/drivers/net/wireless/mwifiex/sta_cmdresp.c
@@ -280,7 +280,6 @@ static int mwifiex_ret_tx_rate_cfg(struct mwifiex_private *priv,
 				   struct host_cmd_ds_command *resp,
 				   void *data_buf)
 {
-	struct mwifiex_adapter *adapter = priv->adapter;
 	struct mwifiex_rate_cfg *ds_rate = NULL;
 	struct host_cmd_ds_tx_rate_cfg *rate_cfg = &resp->params.tx_rate_cfg;
 	struct mwifiex_rate_scope *rate_scope;
@@ -336,9 +335,7 @@ static int mwifiex_ret_tx_rate_cfg(struct mwifiex_private *priv,
 			if (priv->is_data_rate_auto) {
 				ds_rate->is_rate_auto = 1;
 			} else {
-				ds_rate->rate =
-					mwifiex_get_rate_index(adapter,
-							       priv->
+				ds_rate->rate = mwifiex_get_rate_index(priv->
 							       bitmap_rates,
 							       sizeof(priv->
 							       bitmap_rates));
@@ -514,13 +511,11 @@ static int mwifiex_ret_mac_multicast_adr(struct mwifiex_private *priv,
 static int mwifiex_ret_802_11_tx_rate_query(struct mwifiex_private *priv,
 					    struct host_cmd_ds_command *resp)
 {
-	struct mwifiex_adapter *adapter = priv->adapter;
-
 	priv->tx_rate = resp->params.tx_rate.tx_rate;
 	priv->tx_htinfo = resp->params.tx_rate.ht_info;
 	if (!priv->is_data_rate_auto)
 		priv->data_rate =
-			mwifiex_index_to_data_rate(adapter, priv->tx_rate,
+			mwifiex_index_to_data_rate(priv->tx_rate,
 						   priv->tx_htinfo);
 
 	return 0;
@@ -946,7 +941,7 @@ int mwifiex_process_sta_cmdresp(struct mwifiex_private *priv,
 						mp_end_port));
 		break;
 	case HostCmd_CMD_AMSDU_AGGR_CTRL:
-		ret = mwifiex_ret_amsdu_aggr_ctrl(priv, resp, data_buf);
+		ret = mwifiex_ret_amsdu_aggr_ctrl(resp, data_buf);
 		break;
 	case HostCmd_CMD_WMM_GET_STATUS:
 		ret = mwifiex_ret_wmm_get_status(priv, resp);
@@ -965,7 +960,7 @@ int mwifiex_process_sta_cmdresp(struct mwifiex_private *priv,
 	case HostCmd_CMD_SET_BSS_MODE:
 		break;
 	case HostCmd_CMD_11N_CFG:
-		ret = mwifiex_ret_11n_cfg(priv, resp, data_buf);
+		ret = mwifiex_ret_11n_cfg(resp, data_buf);
 		break;
 	default:
 		dev_err(adapter->dev, "CMD_RESP: unknown cmd response %#x\n",
diff --git a/drivers/net/wireless/mwifiex/sta_ioctl.c b/drivers/net/wireless/mwifiex/sta_ioctl.c
index 5f2ce94..6489f26 100644
--- a/drivers/net/wireless/mwifiex/sta_ioctl.c
+++ b/drivers/net/wireless/mwifiex/sta_ioctl.c
@@ -812,8 +812,7 @@ static int mwifiex_rate_ioctl_set_rate_value(struct mwifiex_private *priv,
 		}
 		memset(bitmap_rates, 0, sizeof(bitmap_rates));
 
-		rate_index =
-			mwifiex_data_rate_to_index(adapter, rate_cfg->rate);
+		rate_index = mwifiex_data_rate_to_index(rate_cfg->rate);
 
 		/* Only allow b/g rates to be set */
 		if (rate_index >= MWIFIEX_RATE_INDEX_HRDSSS0 &&
@@ -874,8 +873,8 @@ int mwifiex_drv_get_data_rate(struct mwifiex_private *priv,
 
 	if (!ret) {
 		if (rate && rate->is_rate_auto)
-			rate->rate = mwifiex_index_to_data_rate(priv->adapter,
-					priv->tx_rate, priv->tx_htinfo);
+			rate->rate = mwifiex_index_to_data_rate(priv->tx_rate,
+							priv->tx_htinfo);
 		else if (rate)
 			rate->rate = priv->data_rate;
 	} else {
diff --git a/drivers/net/wireless/mwifiex/wmm.c b/drivers/net/wireless/mwifiex/wmm.c
index 6ce6f94..57b98c5 100644
--- a/drivers/net/wireless/mwifiex/wmm.c
+++ b/drivers/net/wireless/mwifiex/wmm.c
@@ -177,8 +177,7 @@ static void mwifiex_wmm_default_queue_priorities(struct mwifiex_private *priv)
  * This function map ACs to TIDs.
  */
 static void
-mwifiex_wmm_queue_priorities_tid(struct mwifiex_private *priv,
-				 u8 queue_priority[])
+mwifiex_wmm_queue_priorities_tid(u8 queue_priority[])
 {
 	int i;
 
@@ -247,7 +246,7 @@ mwifiex_wmm_setup_queue_priorities(struct mwifiex_private *priv,
 		}
 	}
 
-	mwifiex_wmm_queue_priorities_tid(priv, priv->wmm.queue_priority);
+	mwifiex_wmm_queue_priorities_tid(priv->wmm.queue_priority);
 }
 
 /*
@@ -416,7 +415,7 @@ mwifiex_wmm_lists_empty(struct mwifiex_adapter *adapter)
 		priv = adapter->priv[j];
 		if (priv) {
 			for (i = 0; i < MAX_NUM_TID; i++)
-				if (!mwifiex_wmm_is_ra_list_empty(adapter,
+				if (!mwifiex_wmm_is_ra_list_empty(
 					     &priv->wmm.tid_tbl_ptr[i].ra_list))
 					return false;
 		}
@@ -1161,7 +1160,7 @@ mwifiex_dequeue_tx_packet(struct mwifiex_adapter *adapter)
 	if (!ptr)
 		return -1;
 
-	tid = mwifiex_get_tid(priv->adapter, ptr);
+	tid = mwifiex_get_tid(ptr);
 
 	dev_dbg(adapter->dev, "data: tid=%d\n", tid);
 
@@ -1186,14 +1185,14 @@ mwifiex_dequeue_tx_packet(struct mwifiex_adapter *adapter)
 		/* ra_list_spinlock has been freed in
 		   mwifiex_send_single_packet() */
 	} else {
-		if (mwifiex_is_ampdu_allowed(priv, ptr, tid)) {
-			if (mwifiex_is_ba_stream_avail(priv)) {
+		if (mwifiex_is_ampdu_allowed(priv, tid)) {
+			if (mwifiex_is_ba_stream_avail(adapter)) {
 				mwifiex_11n_create_tx_ba_stream_tbl(priv,
 						ptr->ra, tid,
 						BA_STREAM_SETUP_INPROGRESS);
 				mwifiex_send_addba(priv, tid, ptr->ra);
 			} else if (mwifiex_find_stream_to_delete
-				   (priv, ptr, tid, &tid_del, ra)) {
+				   (priv, tid, &tid_del, ra)) {
 				mwifiex_11n_create_tx_ba_stream_tbl(priv,
 						ptr->ra, tid,
 						BA_STREAM_SETUP_INPROGRESS);
@@ -1202,7 +1201,7 @@ mwifiex_dequeue_tx_packet(struct mwifiex_adapter *adapter)
 		}
 /* Minimum number of AMSDU */
 #define MIN_NUM_AMSDU 2
-		if (mwifiex_is_amsdu_allowed(priv, ptr, tid) &&
+		if (mwifiex_is_amsdu_allowed(priv, tid) &&
 		    (mwifiex_num_pkts_in_txq(priv, ptr, adapter->tx_buf_size) >=
 		     MIN_NUM_AMSDU))
 			mwifiex_11n_aggregate_pkt(priv, ptr, INTF_HEADER_LEN,
diff --git a/drivers/net/wireless/mwifiex/wmm.h b/drivers/net/wireless/mwifiex/wmm.h
index 241f1b0..fcea1f6 100644
--- a/drivers/net/wireless/mwifiex/wmm.h
+++ b/drivers/net/wireless/mwifiex/wmm.h
@@ -35,8 +35,7 @@ enum ieee_types_wmm_ecw_bitmasks {
  * This function retrieves the TID of the given RA list.
  */
 static inline int
-mwifiex_get_tid(struct mwifiex_adapter *adapter,
-		struct mwifiex_ra_list_tbl *ptr)
+mwifiex_get_tid(struct mwifiex_ra_list_tbl *ptr)
 {
 	struct sk_buff *skb;
 
@@ -52,7 +51,7 @@ mwifiex_get_tid(struct mwifiex_adapter *adapter,
  * This function gets the length of a list.
  */
 static inline int
-mwifiex_wmm_list_len(struct mwifiex_adapter *adapter, struct list_head *head)
+mwifiex_wmm_list_len(struct list_head *head)
 {
 	struct list_head *pos;
 	int count = 0;
@@ -67,8 +66,7 @@ mwifiex_wmm_list_len(struct mwifiex_adapter *adapter, struct list_head *head)
  * This function checks if a RA list is empty or not.
  */
 static inline u8
-mwifiex_wmm_is_ra_list_empty(struct mwifiex_adapter *adapter,
-			     struct list_head *ra_list_hhead)
+mwifiex_wmm_is_ra_list_empty(struct list_head *ra_list_hhead)
 {
 	struct mwifiex_ra_list_tbl *ra_list;
 	int is_list_empty;
-- 
1.7.0.2

