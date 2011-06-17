Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from dakia2.marvell.com ([65.219.4.35]:60717 "EHLO
	dakia2.marvell.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754591Ab1FQXJS (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 17 Jun 2011 19:09:18 -0400
From: Bing Zhao <bzhao@marvell.com>
To: linux-wireless@vger.kernel.org
Cc: "John W. Linville" <linville@tuxdriver.com>,
	Johannes Berg <johannes@sipsolutions.net>,
	Amitkumar Karwar <akarwar@marvell.com>,
	Kiran Divekar <dkiran@marvell.com>,
	Yogesh Powar <yogeshp@marvell.com>,
	Frank Huang <frankh@marvell.com>,
	Bing Zhao <bzhao@marvell.com>, Joe Perches <joe@perches.com>,
	Julian Calaby <julian.calaby@gmail.com>
Subject: [PATCH] mwifiex: remove casts of void pointers
Date: Fri, 17 Jun 2011 16:14:28 -0700
Message-Id: <1308352468-8926-1-git-send-email-bzhao@marvell.com> (sfid-20110618_010935_830848_C4F9DCF1)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Amitkumar Karwar <akarwar@marvell.com>

In some cases local pointers are used to cast void pointers passed to
the function. Those unnecessary local pointers are also removed.

This patch was inspired by Joe Perches' patch
[PATCH net-next 1/2] wireless: Remove casts of void *;
and the comments from Julian Calaby.

Signed-off-by: Amitkumar Karwar <akarwar@marvell.com>
Cc: Joe Perches <joe@perches.com>
Cc: Julian Calaby <julian.calaby@gmail.com>
Signed-off-by: Bing Zhao <bzhao@marvell.com>
---
 drivers/net/wireless/mwifiex/11n.c           |   33 ++++-----
 drivers/net/wireless/mwifiex/11n.h           |   14 ++--
 drivers/net/wireless/mwifiex/11n_rxreorder.c |    5 +-
 drivers/net/wireless/mwifiex/11n_rxreorder.h |    5 +-
 drivers/net/wireless/mwifiex/cmdevt.c        |   28 +++-----
 drivers/net/wireless/mwifiex/join.c          |   23 ++----
 drivers/net/wireless/mwifiex/main.c          |    2 +-
 drivers/net/wireless/mwifiex/main.h          |   16 ++--
 drivers/net/wireless/mwifiex/scan.c          |    6 +-
 drivers/net/wireless/mwifiex/sta_cmd.c       |  100 +++++++++++---------------
 drivers/net/wireless/mwifiex/sta_cmdresp.c   |   67 +++++++----------
 drivers/net/wireless/mwifiex/sta_rx.c        |    2 +-
 drivers/net/wireless/mwifiex/txrx.c          |    2 +-
 13 files changed, 128 insertions(+), 175 deletions(-)

diff --git a/drivers/net/wireless/mwifiex/11n.c b/drivers/net/wireless/mwifiex/11n.c
index 916183d..34bba52 100644
--- a/drivers/net/wireless/mwifiex/11n.c
+++ b/drivers/net/wireless/mwifiex/11n.c
@@ -185,13 +185,12 @@ int mwifiex_ret_11n_addba_req(struct mwifiex_private *priv,
  *
  * Handling includes changing the header fields into CPU format.
  */
-int mwifiex_ret_11n_cfg(struct host_cmd_ds_command *resp, void *data_buf)
+int mwifiex_ret_11n_cfg(struct host_cmd_ds_command *resp,
+			struct mwifiex_ds_11n_tx_cfg *tx_cfg)
 {
-	struct mwifiex_ds_11n_tx_cfg *tx_cfg;
 	struct host_cmd_ds_11n_cfg *htcfg = &resp->params.htcfg;
 
-	if (data_buf) {
-		tx_cfg = (struct mwifiex_ds_11n_tx_cfg *) data_buf;
+	if (tx_cfg) {
 		tx_cfg->tx_htcap = le16_to_cpu(htcfg->ht_tx_cap);
 		tx_cfg->tx_htinfo = le16_to_cpu(htcfg->ht_tx_info);
 	}
@@ -208,11 +207,10 @@ int mwifiex_ret_11n_cfg(struct host_cmd_ds_command *resp, void *data_buf)
  */
 int mwifiex_cmd_recfg_tx_buf(struct mwifiex_private *priv,
 			     struct host_cmd_ds_command *cmd, int cmd_action,
-			     void *data_buf)
+			     u16 *buf_size)
 {
 	struct host_cmd_ds_txbuf_cfg *tx_buf = &cmd->params.tx_buf;
 	u16 action = (u16) cmd_action;
-	u16 buf_size = *((u16 *) data_buf);
 
 	cmd->command = cpu_to_le16(HostCmd_CMD_RECONFIGURE_TX_BUFF);
 	cmd->size =
@@ -220,8 +218,8 @@ int mwifiex_cmd_recfg_tx_buf(struct mwifiex_private *priv,
 	tx_buf->action = cpu_to_le16(action);
 	switch (action) {
 	case HostCmd_ACT_GEN_SET:
-		dev_dbg(priv->adapter->dev, "cmd: set tx_buf=%d\n", buf_size);
-		tx_buf->buff_size = cpu_to_le16(buf_size);
+		dev_dbg(priv->adapter->dev, "cmd: set tx_buf=%d\n", *buf_size);
+		tx_buf->buff_size = cpu_to_le16(*buf_size);
 		break;
 	case HostCmd_ACT_GEN_GET:
 	default:
@@ -240,13 +238,12 @@ int mwifiex_cmd_recfg_tx_buf(struct mwifiex_private *priv,
  *      - Ensuring correct endian-ness
  */
 int mwifiex_cmd_amsdu_aggr_ctrl(struct host_cmd_ds_command *cmd,
-				int cmd_action, void *data_buf)
+				int cmd_action,
+				struct mwifiex_ds_11n_amsdu_aggr_ctrl *aa_ctrl)
 {
 	struct host_cmd_ds_amsdu_aggr_ctrl *amsdu_ctrl =
 		&cmd->params.amsdu_aggr_ctrl;
 	u16 action = (u16) cmd_action;
-	struct mwifiex_ds_11n_amsdu_aggr_ctrl *aa_ctrl =
-		(struct mwifiex_ds_11n_amsdu_aggr_ctrl *) data_buf;
 
 	cmd->command = cpu_to_le16(HostCmd_CMD_AMSDU_AGGR_CTRL);
 	cmd->size = cpu_to_le16(sizeof(struct host_cmd_ds_amsdu_aggr_ctrl)
@@ -272,15 +269,13 @@ int mwifiex_cmd_amsdu_aggr_ctrl(struct host_cmd_ds_command *cmd,
  * Handling includes changing the header fields into CPU format.
  */
 int mwifiex_ret_amsdu_aggr_ctrl(struct host_cmd_ds_command *resp,
-				void *data_buf)
+				struct mwifiex_ds_11n_amsdu_aggr_ctrl
+				*amsdu_aggr_ctrl)
 {
-	struct mwifiex_ds_11n_amsdu_aggr_ctrl *amsdu_aggr_ctrl;
 	struct host_cmd_ds_amsdu_aggr_ctrl *amsdu_ctrl =
 		&resp->params.amsdu_aggr_ctrl;
 
-	if (data_buf) {
-		amsdu_aggr_ctrl =
-			(struct mwifiex_ds_11n_amsdu_aggr_ctrl *) data_buf;
+	if (amsdu_aggr_ctrl) {
 		amsdu_aggr_ctrl->enable = le16_to_cpu(amsdu_ctrl->enable);
 		amsdu_aggr_ctrl->curr_buf_size =
 			le16_to_cpu(amsdu_ctrl->curr_buf_size);
@@ -296,12 +291,10 @@ int mwifiex_ret_amsdu_aggr_ctrl(struct host_cmd_ds_command *resp,
  *      - Setting HT Tx capability and HT Tx information fields
  *      - Ensuring correct endian-ness
  */
-int mwifiex_cmd_11n_cfg(struct host_cmd_ds_command *cmd,
-			u16 cmd_action, void *data_buf)
+int mwifiex_cmd_11n_cfg(struct host_cmd_ds_command *cmd, u16 cmd_action,
+			struct mwifiex_ds_11n_tx_cfg *txcfg)
 {
 	struct host_cmd_ds_11n_cfg *htcfg = &cmd->params.htcfg;
-	struct mwifiex_ds_11n_tx_cfg *txcfg =
-		(struct mwifiex_ds_11n_tx_cfg *) data_buf;
 
 	cmd->command = cpu_to_le16(HostCmd_CMD_11N_CFG);
 	cmd->size = cpu_to_le16(sizeof(struct host_cmd_ds_11n_cfg) + S_DS_GEN);
diff --git a/drivers/net/wireless/mwifiex/11n.h b/drivers/net/wireless/mwifiex/11n.h
index a4390a1..90b421e 100644
--- a/drivers/net/wireless/mwifiex/11n.h
+++ b/drivers/net/wireless/mwifiex/11n.h
@@ -29,9 +29,9 @@ int mwifiex_ret_11n_delba(struct mwifiex_private *priv,
 int mwifiex_ret_11n_addba_req(struct mwifiex_private *priv,
 			      struct host_cmd_ds_command *resp);
 int mwifiex_ret_11n_cfg(struct host_cmd_ds_command *resp,
-			void *data_buf);
-int mwifiex_cmd_11n_cfg(struct host_cmd_ds_command *cmd,
-			u16 cmd_action, void *data_buf);
+			struct mwifiex_ds_11n_tx_cfg *tx_cfg);
+int mwifiex_cmd_11n_cfg(struct host_cmd_ds_command *cmd, u16 cmd_action,
+			struct mwifiex_ds_11n_tx_cfg *txcfg);
 
 int mwifiex_cmd_append_11n_tlv(struct mwifiex_private *priv,
 			       struct mwifiex_bssdescriptor *bss_desc,
@@ -62,12 +62,14 @@ int mwifiex_get_rx_reorder_tbl(struct mwifiex_private *priv,
 int mwifiex_get_tx_ba_stream_tbl(struct mwifiex_private *priv,
 			       struct mwifiex_ds_tx_ba_stream_tbl *buf);
 int mwifiex_ret_amsdu_aggr_ctrl(struct host_cmd_ds_command *resp,
-				void *data_buf);
+				struct mwifiex_ds_11n_amsdu_aggr_ctrl
+				*amsdu_aggr_ctrl);
 int mwifiex_cmd_recfg_tx_buf(struct mwifiex_private *priv,
 			     struct host_cmd_ds_command *cmd,
-			     int cmd_action, void *data_buf);
+			     int cmd_action, u16 *buf_size);
 int mwifiex_cmd_amsdu_aggr_ctrl(struct host_cmd_ds_command *cmd,
-				int cmd_action, void *data_buf);
+				int cmd_action,
+				struct mwifiex_ds_11n_amsdu_aggr_ctrl *aa_ctrl);
 
 /*
  * This function checks whether AMPDU is allowed or not for a particular TID.
diff --git a/drivers/net/wireless/mwifiex/11n_rxreorder.c b/drivers/net/wireless/mwifiex/11n_rxreorder.c
index e5dfdc3..7aa9aa0 100644
--- a/drivers/net/wireless/mwifiex/11n_rxreorder.c
+++ b/drivers/net/wireless/mwifiex/11n_rxreorder.c
@@ -328,13 +328,12 @@ int mwifiex_cmd_11n_addba_req(struct host_cmd_ds_command *cmd, void *data_buf)
  */
 int mwifiex_cmd_11n_addba_rsp_gen(struct mwifiex_private *priv,
 				  struct host_cmd_ds_command *cmd,
-				  void *data_buf)
+				  struct host_cmd_ds_11n_addba_req
+				  *cmd_addba_req)
 {
 	struct host_cmd_ds_11n_addba_rsp *add_ba_rsp =
 		(struct host_cmd_ds_11n_addba_rsp *)
 		&cmd->params.add_ba_rsp;
-	struct host_cmd_ds_11n_addba_req *cmd_addba_req =
-		(struct host_cmd_ds_11n_addba_req *) data_buf;
 	u8 tid;
 	int win_size;
 	uint16_t block_ack_param_set;
diff --git a/drivers/net/wireless/mwifiex/11n_rxreorder.h b/drivers/net/wireless/mwifiex/11n_rxreorder.h
index f3ca8c8..033c8ad 100644
--- a/drivers/net/wireless/mwifiex/11n_rxreorder.h
+++ b/drivers/net/wireless/mwifiex/11n_rxreorder.h
@@ -52,8 +52,9 @@ int mwifiex_ret_11n_addba_resp(struct mwifiex_private *priv,
 int mwifiex_cmd_11n_delba(struct host_cmd_ds_command *cmd,
 			  void *data_buf);
 int mwifiex_cmd_11n_addba_rsp_gen(struct mwifiex_private *priv,
-				  struct host_cmd_ds_command
-				  *cmd, void *data_buf);
+				  struct host_cmd_ds_command *cmd,
+				  struct host_cmd_ds_11n_addba_req
+				  *cmd_addba_req);
 int mwifiex_cmd_11n_addba_req(struct host_cmd_ds_command *cmd,
 			      void *data_buf);
 void mwifiex_11n_cleanup_reorder_tbl(struct mwifiex_private *priv);
diff --git a/drivers/net/wireless/mwifiex/cmdevt.c b/drivers/net/wireless/mwifiex/cmdevt.c
index cd89fed..b5352af 100644
--- a/drivers/net/wireless/mwifiex/cmdevt.c
+++ b/drivers/net/wireless/mwifiex/cmdevt.c
@@ -104,13 +104,11 @@ mwifiex_clean_cmd_node(struct mwifiex_adapter *adapter,
  * main thread.
  */
 static int mwifiex_cmd_host_cmd(struct mwifiex_private *priv,
-				struct host_cmd_ds_command *cmd, void *data_buf)
+				struct host_cmd_ds_command *cmd,
+				struct mwifiex_ds_misc_cmd *pcmd_ptr)
 {
-	struct mwifiex_ds_misc_cmd *pcmd_ptr =
-		(struct mwifiex_ds_misc_cmd *) data_buf;
-
 	/* Copy the HOST command to command buffer */
-	memcpy((void *) cmd, pcmd_ptr->cmd, pcmd_ptr->len);
+	memcpy(cmd, pcmd_ptr->cmd, pcmd_ptr->len);
 	dev_dbg(priv->adapter->dev, "cmd: host cmd size = %d\n", pcmd_ptr->len);
 	return 0;
 }
@@ -707,15 +705,14 @@ int mwifiex_process_cmdresp(struct mwifiex_adapter *adapter)
 
 	if (adapter->curr_cmd->cmd_flag & CMD_F_HOSTCMD) {
 		/* Copy original response back to response buffer */
-		struct mwifiex_ds_misc_cmd *hostcmd = NULL;
+		struct mwifiex_ds_misc_cmd *hostcmd;
 		uint16_t size = le16_to_cpu(resp->size);
 		dev_dbg(adapter->dev, "info: host cmd resp size = %d\n", size);
 		size = min_t(u16, size, MWIFIEX_SIZE_OF_CMD_BUFFER);
 		if (adapter->curr_cmd->data_buf) {
-			hostcmd = (struct mwifiex_ds_misc_cmd *)
-						adapter->curr_cmd->data_buf;
+			hostcmd = adapter->curr_cmd->data_buf;
 			hostcmd->len = size;
-			memcpy(hostcmd->cmd, (void *) resp, size);
+			memcpy(hostcmd->cmd, resp, size);
 		}
 	}
 	orig_cmdresp_no = le16_to_cpu(resp->command);
@@ -1155,7 +1152,7 @@ EXPORT_SYMBOL_GPL(mwifiex_process_sleep_confirm_resp);
 int mwifiex_cmd_enh_power_mode(struct mwifiex_private *priv,
 			       struct host_cmd_ds_command *cmd,
 			       u16 cmd_action, uint16_t ps_bitmap,
-			       void *data_buf)
+			       struct mwifiex_ds_auto_ds *auto_ds)
 {
 	struct host_cmd_ds_802_11_ps_mode_enh *psmode_enh =
 		&cmd->params.psmode_enh;
@@ -1218,9 +1215,8 @@ int mwifiex_cmd_enh_power_mode(struct mwifiex_private *priv,
 					sizeof(struct mwifiex_ie_types_header));
 			cmd_size += sizeof(*auto_ds_tlv);
 			tlv += sizeof(*auto_ds_tlv);
-			if (data_buf)
-				idletime = ((struct mwifiex_ds_auto_ds *)
-					     data_buf)->idle_time;
+			if (auto_ds)
+				idletime = auto_ds->idle_time;
 			dev_dbg(priv->adapter->dev,
 					"cmd: PS Command: Enter Auto Deep Sleep\n");
 			auto_ds_tlv->deep_sleep_timeout = cpu_to_le16(idletime);
@@ -1239,7 +1235,7 @@ int mwifiex_cmd_enh_power_mode(struct mwifiex_private *priv,
  */
 int mwifiex_ret_enh_power_mode(struct mwifiex_private *priv,
 			       struct host_cmd_ds_command *resp,
-			       void *data_buf)
+			       struct mwifiex_ds_pm_cfg *pm_cfg)
 {
 	struct mwifiex_adapter *adapter = priv->adapter;
 	struct host_cmd_ds_802_11_ps_mode_enh *ps_mode =
@@ -1282,10 +1278,8 @@ int mwifiex_ret_enh_power_mode(struct mwifiex_private *priv,
 
 		dev_dbg(adapter->dev, "cmd: ps_bitmap=%#x\n", ps_bitmap);
 
-		if (data_buf) {
+		if (pm_cfg) {
 			/* This section is for get power save mode */
-			struct mwifiex_ds_pm_cfg *pm_cfg =
-					(struct mwifiex_ds_pm_cfg *)data_buf;
 			if (ps_bitmap & BITMAP_STA_PS)
 				pm_cfg->param.ps_mode = 1;
 			else
diff --git a/drivers/net/wireless/mwifiex/join.c b/drivers/net/wireless/mwifiex/join.c
index 5eab3dc..644e2e4 100644
--- a/drivers/net/wireless/mwifiex/join.c
+++ b/drivers/net/wireless/mwifiex/join.c
@@ -364,10 +364,9 @@ static int mwifiex_append_rsn_ie_wpa_wpa2(struct mwifiex_private *priv,
  */
 int mwifiex_cmd_802_11_associate(struct mwifiex_private *priv,
 				 struct host_cmd_ds_command *cmd,
-				 void *data_buf)
+				 struct mwifiex_bssdescriptor *bss_desc)
 {
 	struct host_cmd_ds_802_11_associate *assoc = &cmd->params.associate;
-	struct mwifiex_bssdescriptor *bss_desc;
 	struct mwifiex_ie_types_ssid_param_set *ssid_tlv;
 	struct mwifiex_ie_types_phy_param_set *phy_tlv;
 	struct mwifiex_ie_types_ss_param_set *ss_tlv;
@@ -380,7 +379,6 @@ int mwifiex_cmd_802_11_associate(struct mwifiex_private *priv,
 	u8 *pos;
 	int rsn_ie_len = 0;
 
-	bss_desc = (struct mwifiex_bssdescriptor *) data_buf;
 	pos = (u8 *) assoc;
 
 	mwifiex_cfg_tx_buf(priv, bss_desc);
@@ -748,7 +746,8 @@ done:
  */
 int
 mwifiex_cmd_802_11_ad_hoc_start(struct mwifiex_private *priv,
-				struct host_cmd_ds_command *cmd, void *data_buf)
+				struct host_cmd_ds_command *cmd,
+				struct mwifiex_802_11_ssid *req_ssid)
 {
 	int rsn_ie_len = 0;
 	struct mwifiex_adapter *adapter = priv->adapter;
@@ -786,20 +785,15 @@ mwifiex_cmd_802_11_ad_hoc_start(struct mwifiex_private *priv,
 
 	memset(adhoc_start->ssid, 0, IEEE80211_MAX_SSID_LEN);
 
-	memcpy(adhoc_start->ssid,
-	       ((struct mwifiex_802_11_ssid *) data_buf)->ssid,
-	       ((struct mwifiex_802_11_ssid *) data_buf)->ssid_len);
+	memcpy(adhoc_start->ssid, req_ssid->ssid, req_ssid->ssid_len);
 
 	dev_dbg(adapter->dev, "info: ADHOC_S_CMD: SSID = %s\n",
 				adhoc_start->ssid);
 
 	memset(bss_desc->ssid.ssid, 0, IEEE80211_MAX_SSID_LEN);
-	memcpy(bss_desc->ssid.ssid,
-	       ((struct mwifiex_802_11_ssid *) data_buf)->ssid,
-	       ((struct mwifiex_802_11_ssid *) data_buf)->ssid_len);
+	memcpy(bss_desc->ssid.ssid, req_ssid->ssid, req_ssid->ssid_len);
 
-	bss_desc->ssid.ssid_len =
-		((struct mwifiex_802_11_ssid *) data_buf)->ssid_len;
+	bss_desc->ssid.ssid_len = req_ssid->ssid_len;
 
 	/* Set the BSS mode */
 	adhoc_start->bss_mode = HostCmd_BSS_MODE_IBSS;
@@ -1036,13 +1030,12 @@ mwifiex_cmd_802_11_ad_hoc_start(struct mwifiex_private *priv,
  */
 int
 mwifiex_cmd_802_11_ad_hoc_join(struct mwifiex_private *priv,
-			       struct host_cmd_ds_command *cmd, void *data_buf)
+			       struct host_cmd_ds_command *cmd,
+			       struct mwifiex_bssdescriptor *bss_desc)
 {
 	int rsn_ie_len = 0;
 	struct host_cmd_ds_802_11_ad_hoc_join *adhoc_join =
 		&cmd->params.adhoc_join;
-	struct mwifiex_bssdescriptor *bss_desc =
-		(struct mwifiex_bssdescriptor *) data_buf;
 	struct mwifiex_ie_types_chan_list_param_set *chan_tlv;
 	u32 cmd_append_size = 0;
 	u16 tmp_cap;
diff --git a/drivers/net/wireless/mwifiex/main.c b/drivers/net/wireless/mwifiex/main.c
index 054a5c3..e5fc53d 100644
--- a/drivers/net/wireless/mwifiex/main.c
+++ b/drivers/net/wireless/mwifiex/main.c
@@ -553,7 +553,7 @@ static int
 mwifiex_set_mac_address(struct net_device *dev, void *addr)
 {
 	struct mwifiex_private *priv = mwifiex_netdev_get_priv(dev);
-	struct sockaddr *hw_addr = (struct sockaddr *) addr;
+	struct sockaddr *hw_addr = addr;
 	int ret;
 
 	memcpy(priv->curr_addr, hw_addr->sa_data, ETH_ALEN);
diff --git a/drivers/net/wireless/mwifiex/main.h b/drivers/net/wireless/mwifiex/main.h
index db201cc..03691c0 100644
--- a/drivers/net/wireless/mwifiex/main.h
+++ b/drivers/net/wireless/mwifiex/main.h
@@ -736,10 +736,10 @@ void mwifiex_process_sleep_confirm_resp(struct mwifiex_adapter *, u8 *,
 int mwifiex_cmd_enh_power_mode(struct mwifiex_private *priv,
 			       struct host_cmd_ds_command *cmd,
 			       u16 cmd_action, uint16_t ps_bitmap,
-			       void *data_buf);
+			       struct mwifiex_ds_auto_ds *auto_ds);
 int mwifiex_ret_enh_power_mode(struct mwifiex_private *priv,
 			       struct host_cmd_ds_command *resp,
-			       void *data_buf);
+			       struct mwifiex_ds_pm_cfg *pm_cfg);
 void mwifiex_process_hs_config(struct mwifiex_adapter *adapter);
 void mwifiex_hs_activated_event(struct mwifiex_private *priv,
 					u8 activated);
@@ -751,7 +751,7 @@ int mwifiex_sta_prepare_cmd(struct mwifiex_private *, uint16_t cmd_no,
 			    u16 cmd_action, u32 cmd_oid,
 			    void *data_buf, void *cmd_buf);
 int mwifiex_process_sta_cmdresp(struct mwifiex_private *, u16 cmdresp_no,
-				void *cmd_buf);
+				struct host_cmd_ds_command *resp);
 int mwifiex_process_sta_rx_packet(struct mwifiex_adapter *,
 				  struct sk_buff *skb);
 int mwifiex_process_sta_event(struct mwifiex_private *);
@@ -760,7 +760,7 @@ int mwifiex_sta_init_cmd(struct mwifiex_private *, u8 first_sta);
 int mwifiex_scan_networks(struct mwifiex_private *priv,
 			  const struct mwifiex_user_scan_cfg *user_scan_in);
 int mwifiex_cmd_802_11_scan(struct host_cmd_ds_command *cmd,
-			    void *data_buf);
+			    struct mwifiex_scan_cmd_config *scan_cfg);
 void mwifiex_queue_scan_cmd(struct mwifiex_private *priv,
 			    struct cmd_ctrl_node *cmd_node);
 int mwifiex_ret_802_11_scan(struct mwifiex_private *priv,
@@ -777,8 +777,8 @@ s32 mwifiex_ssid_cmp(struct mwifiex_802_11_ssid *ssid1,
 int mwifiex_associate(struct mwifiex_private *priv,
 		      struct mwifiex_bssdescriptor *bss_desc);
 int mwifiex_cmd_802_11_associate(struct mwifiex_private *priv,
-				 struct host_cmd_ds_command
-				 *cmd, void *data_buf);
+				 struct host_cmd_ds_command *cmd,
+				 struct mwifiex_bssdescriptor *bss_desc);
 int mwifiex_ret_802_11_associate(struct mwifiex_private *priv,
 				 struct host_cmd_ds_command *resp);
 void mwifiex_reset_connect_state(struct mwifiex_private *priv);
@@ -791,10 +791,10 @@ int mwifiex_adhoc_join(struct mwifiex_private *priv,
 		       struct mwifiex_bssdescriptor *bss_desc);
 int mwifiex_cmd_802_11_ad_hoc_start(struct mwifiex_private *priv,
 				    struct host_cmd_ds_command *cmd,
-				    void *data_buf);
+				    struct mwifiex_802_11_ssid *req_ssid);
 int mwifiex_cmd_802_11_ad_hoc_join(struct mwifiex_private *priv,
 				   struct host_cmd_ds_command *cmd,
-				   void *data_buf);
+				   struct mwifiex_bssdescriptor *bss_desc);
 int mwifiex_ret_802_11_ad_hoc(struct mwifiex_private *priv,
 			      struct host_cmd_ds_command *resp);
 int mwifiex_cmd_802_11_bg_scan_query(struct host_cmd_ds_command *cmd);
diff --git a/drivers/net/wireless/mwifiex/scan.c b/drivers/net/wireless/mwifiex/scan.c
index 5c22860..6f88c8a 100644
--- a/drivers/net/wireless/mwifiex/scan.c
+++ b/drivers/net/wireless/mwifiex/scan.c
@@ -2357,12 +2357,10 @@ int mwifiex_scan_networks(struct mwifiex_private *priv,
  *      - Setting command ID, and proper size
  *      - Ensuring correct endian-ness
  */
-int mwifiex_cmd_802_11_scan(struct host_cmd_ds_command *cmd, void *data_buf)
+int mwifiex_cmd_802_11_scan(struct host_cmd_ds_command *cmd,
+			    struct mwifiex_scan_cmd_config *scan_cfg)
 {
 	struct host_cmd_ds_802_11_scan *scan_cmd = &cmd->params.scan;
-	struct mwifiex_scan_cmd_config *scan_cfg;
-
-	scan_cfg = (struct mwifiex_scan_cmd_config *) data_buf;
 
 	/* Set fixed field variables in scan command */
 	scan_cmd->bss_mode = scan_cfg->bss_mode;
diff --git a/drivers/net/wireless/mwifiex/sta_cmd.c b/drivers/net/wireless/mwifiex/sta_cmd.c
index 8af3a78..d5c987a 100644
--- a/drivers/net/wireless/mwifiex/sta_cmd.c
+++ b/drivers/net/wireless/mwifiex/sta_cmd.c
@@ -67,10 +67,9 @@ mwifiex_cmd_802_11_rssi_info(struct mwifiex_private *priv,
  */
 static int mwifiex_cmd_mac_control(struct mwifiex_private *priv,
 				   struct host_cmd_ds_command *cmd,
-				   u16 cmd_action, void *data_buf)
+				   u16 cmd_action, u16 *action)
 {
 	struct host_cmd_ds_mac_control *mac_ctrl = &cmd->params.mac_ctrl;
-	u16 action = *((u16 *) data_buf);
 
 	if (cmd_action != HostCmd_ACT_GEN_SET) {
 		dev_err(priv->adapter->dev,
@@ -81,7 +80,7 @@ static int mwifiex_cmd_mac_control(struct mwifiex_private *priv,
 	cmd->command = cpu_to_le16(HostCmd_CMD_MAC_CONTROL);
 	cmd->size =
 		cpu_to_le16(sizeof(struct host_cmd_ds_mac_control) + S_DS_GEN);
-	mac_ctrl->action = cpu_to_le16(action);
+	mac_ctrl->action = cpu_to_le16(*action);
 
 	return 0;
 }
@@ -104,10 +103,9 @@ static int mwifiex_cmd_mac_control(struct mwifiex_private *priv,
 static int mwifiex_cmd_802_11_snmp_mib(struct mwifiex_private *priv,
 				       struct host_cmd_ds_command *cmd,
 				       u16 cmd_action, u32 cmd_oid,
-				       void *data_buf)
+				       u32 *ul_temp)
 {
 	struct host_cmd_ds_802_11_snmp_mib *snmp_mib = &cmd->params.smib;
-	u32 ul_temp;
 
 	dev_dbg(priv->adapter->dev, "cmd: SNMP_CMD: cmd_oid = 0x%x\n", cmd_oid);
 	cmd->command = cpu_to_le16(HostCmd_CMD_802_11_SNMP_MIB);
@@ -127,9 +125,8 @@ static int mwifiex_cmd_802_11_snmp_mib(struct mwifiex_private *priv,
 		if (cmd_action == HostCmd_ACT_GEN_SET) {
 			snmp_mib->query_type = cpu_to_le16(HostCmd_ACT_GEN_SET);
 			snmp_mib->buf_size = cpu_to_le16(sizeof(u16));
-			ul_temp = *((u32 *) data_buf);
 			*((__le16 *) (snmp_mib->value)) =
-				cpu_to_le16((u16) ul_temp);
+				cpu_to_le16((u16) *ul_temp);
 			cmd->size = cpu_to_le16(le16_to_cpu(cmd->size)
 				+ sizeof(u16));
 		}
@@ -139,9 +136,8 @@ static int mwifiex_cmd_802_11_snmp_mib(struct mwifiex_private *priv,
 		if (cmd_action == HostCmd_ACT_GEN_SET) {
 			snmp_mib->query_type = cpu_to_le16(HostCmd_ACT_GEN_SET);
 			snmp_mib->buf_size = cpu_to_le16(sizeof(u16));
-			ul_temp = *((u32 *) data_buf);
 			*(__le16 *) (snmp_mib->value) =
-				cpu_to_le16((u16) ul_temp);
+				cpu_to_le16((u16) *ul_temp);
 			cmd->size = cpu_to_le16(le16_to_cpu(cmd->size)
 				+ sizeof(u16));
 		}
@@ -152,9 +148,8 @@ static int mwifiex_cmd_802_11_snmp_mib(struct mwifiex_private *priv,
 		if (cmd_action == HostCmd_ACT_GEN_SET) {
 			snmp_mib->query_type = cpu_to_le16(HostCmd_ACT_GEN_SET);
 			snmp_mib->buf_size = cpu_to_le16(sizeof(u16));
-			ul_temp = (*(u32 *) data_buf);
 			*((__le16 *) (snmp_mib->value)) =
-				cpu_to_le16((u16) ul_temp);
+				cpu_to_le16((u16) *ul_temp);
 			cmd->size = cpu_to_le16(le16_to_cpu(cmd->size)
 				+ sizeof(u16));
 		}
@@ -164,9 +159,8 @@ static int mwifiex_cmd_802_11_snmp_mib(struct mwifiex_private *priv,
 		if (cmd_action == HostCmd_ACT_GEN_SET) {
 			snmp_mib->query_type = cpu_to_le16(HostCmd_ACT_GEN_SET);
 			snmp_mib->buf_size = cpu_to_le16(sizeof(u16));
-			ul_temp = *(u32 *) data_buf;
 			*((__le16 *) (snmp_mib->value)) =
-				cpu_to_le16((u16) ul_temp);
+				cpu_to_le16((u16) *ul_temp);
 			cmd->size = cpu_to_le16(le16_to_cpu(cmd->size)
 				+ sizeof(u16));
 		}
@@ -209,13 +203,11 @@ mwifiex_cmd_802_11_get_log(struct host_cmd_ds_command *cmd)
  */
 static int mwifiex_cmd_tx_rate_cfg(struct mwifiex_private *priv,
 				   struct host_cmd_ds_command *cmd,
-				   u16 cmd_action, void *data_buf)
+				   u16 cmd_action, u16 *pbitmap_rates)
 {
 	struct host_cmd_ds_tx_rate_cfg *rate_cfg = &cmd->params.tx_rate_cfg;
 	struct mwifiex_rate_scope *rate_scope;
 	struct mwifiex_rate_drop_pattern *rate_drop;
-	u16 *pbitmap_rates = (u16 *) data_buf;
-
 	u32 i;
 
 	cmd->command = cpu_to_le16(HostCmd_CMD_TX_RATE_CFG);
@@ -272,10 +264,10 @@ static int mwifiex_cmd_tx_rate_cfg(struct mwifiex_private *priv,
  *      - Ensuring correct endian-ness
  */
 static int mwifiex_cmd_tx_power_cfg(struct host_cmd_ds_command *cmd,
-				    u16 cmd_action, void *data_buf)
+				    u16 cmd_action,
+				    struct host_cmd_ds_txpwr_cfg *txp)
 {
 	struct mwifiex_types_power_group *pg_tlv;
-	struct host_cmd_ds_txpwr_cfg *txp;
 	struct host_cmd_ds_txpwr_cfg *cmd_txp_cfg = &cmd->params.txp_cfg;
 
 	cmd->command = cpu_to_le16(HostCmd_CMD_TXPWR_CFG);
@@ -283,12 +275,11 @@ static int mwifiex_cmd_tx_power_cfg(struct host_cmd_ds_command *cmd,
 		cpu_to_le16(S_DS_GEN + sizeof(struct host_cmd_ds_txpwr_cfg));
 	switch (cmd_action) {
 	case HostCmd_ACT_GEN_SET:
-		txp = (struct host_cmd_ds_txpwr_cfg *) data_buf;
 		if (txp->mode) {
 			pg_tlv = (struct mwifiex_types_power_group
-				  *) ((unsigned long) data_buf +
+				  *) ((unsigned long) txp +
 				     sizeof(struct host_cmd_ds_txpwr_cfg));
-			memmove(cmd_txp_cfg, data_buf,
+			memmove(cmd_txp_cfg, txp,
 				sizeof(struct host_cmd_ds_txpwr_cfg) +
 				sizeof(struct mwifiex_types_power_group) +
 				pg_tlv->length);
@@ -300,7 +291,7 @@ static int mwifiex_cmd_tx_power_cfg(struct host_cmd_ds_command *cmd,
 				  sizeof(struct mwifiex_types_power_group) +
 				  pg_tlv->length);
 		} else {
-			memmove(cmd_txp_cfg, data_buf,
+			memmove(cmd_txp_cfg, txp,
 				sizeof(struct host_cmd_ds_txpwr_cfg));
 		}
 		cmd_txp_cfg->action = cpu_to_le16(cmd_action);
@@ -322,22 +313,23 @@ static int mwifiex_cmd_tx_power_cfg(struct host_cmd_ds_command *cmd,
  *        (as required)
  *      - Ensuring correct endian-ness
  */
-static int mwifiex_cmd_802_11_hs_cfg(struct mwifiex_private *priv,
-				     struct host_cmd_ds_command *cmd,
-				     u16 cmd_action,
-				     struct mwifiex_hs_config_param *data_buf)
+static int
+mwifiex_cmd_802_11_hs_cfg(struct mwifiex_private *priv,
+			  struct host_cmd_ds_command *cmd,
+			  u16 cmd_action,
+			  struct mwifiex_hs_config_param *hscfg_param)
 {
 	struct mwifiex_adapter *adapter = priv->adapter;
 	struct host_cmd_ds_802_11_hs_cfg_enh *hs_cfg = &cmd->params.opt_hs_cfg;
 	u16 hs_activate = false;
 
-	if (data_buf == NULL)
+	if (!hscfg_param)
 		/* New Activate command */
 		hs_activate = true;
 	cmd->command = cpu_to_le16(HostCmd_CMD_802_11_HS_CFG_ENH);
 
 	if (!hs_activate &&
-	    (data_buf->conditions
+	    (hscfg_param->conditions
 	    != cpu_to_le32(HOST_SLEEP_CFG_CANCEL))
 	    && ((adapter->arp_filter_size > 0)
 		&& (adapter->arp_filter_size <= ARP_FILTER_MAX_BUF_SIZE))) {
@@ -359,9 +351,9 @@ static int mwifiex_cmd_802_11_hs_cfg(struct mwifiex_private *priv,
 		hs_cfg->params.hs_activate.resp_ctrl = RESP_NEEDED;
 	} else {
 		hs_cfg->action = cpu_to_le16(HS_CONFIGURE);
-		hs_cfg->params.hs_config.conditions = data_buf->conditions;
-		hs_cfg->params.hs_config.gpio = data_buf->gpio;
-		hs_cfg->params.hs_config.gap = data_buf->gap;
+		hs_cfg->params.hs_config.conditions = hscfg_param->conditions;
+		hs_cfg->params.hs_config.gpio = hscfg_param->gpio;
+		hs_cfg->params.hs_config.gap = hscfg_param->gap;
 		dev_dbg(adapter->dev,
 			"cmd: HS_CFG_CMD: condition:0x%x gpio:0x%x gap:0x%x\n",
 		       hs_cfg->params.hs_config.conditions,
@@ -405,11 +397,11 @@ static int mwifiex_cmd_802_11_mac_address(struct mwifiex_private *priv,
  *      - Setting MAC multicast address
  *      - Ensuring correct endian-ness
  */
-static int mwifiex_cmd_mac_multicast_adr(struct host_cmd_ds_command *cmd,
-					 u16 cmd_action, void *data_buf)
+static int
+mwifiex_cmd_mac_multicast_adr(struct host_cmd_ds_command *cmd,
+			      u16 cmd_action,
+			      struct mwifiex_multicast_list *mcast_list)
 {
-	struct mwifiex_multicast_list *mcast_list =
-		(struct mwifiex_multicast_list *) data_buf;
 	struct host_cmd_ds_mac_multicast_adr *mcast_addr = &cmd->params.mc_addr;
 
 	cmd->size = cpu_to_le16(sizeof(struct host_cmd_ds_mac_multicast_adr) +
@@ -435,7 +427,7 @@ static int mwifiex_cmd_mac_multicast_adr(struct host_cmd_ds_command *cmd,
  */
 static int mwifiex_cmd_802_11_deauthenticate(struct mwifiex_private *priv,
 					     struct host_cmd_ds_command *cmd,
-					     void *data_buf)
+					     u8 *mac)
 {
 	struct host_cmd_ds_802_11_deauthenticate *deauth = &cmd->params.deauth;
 
@@ -444,7 +436,7 @@ static int mwifiex_cmd_802_11_deauthenticate(struct mwifiex_private *priv,
 				+ S_DS_GEN);
 
 	/* Set AP MAC address */
-	memcpy(deauth->mac_addr, (u8 *) data_buf, ETH_ALEN);
+	memcpy(deauth->mac_addr, mac, ETH_ALEN);
 
 	dev_dbg(priv->adapter->dev, "cmd: Deauth: %pM\n", deauth->mac_addr);
 
@@ -543,15 +535,14 @@ mwifiex_set_keyparamset_wep(struct mwifiex_private *priv,
  *        encryption (TKIP, AES) (as required)
  *      - Ensuring correct endian-ness
  */
-static int mwifiex_cmd_802_11_key_material(struct mwifiex_private *priv,
-					   struct host_cmd_ds_command *cmd,
-					   u16 cmd_action,
-					   u32 cmd_oid, void *data_buf)
+static int
+mwifiex_cmd_802_11_key_material(struct mwifiex_private *priv,
+				struct host_cmd_ds_command *cmd,
+				u16 cmd_action, u32 cmd_oid,
+				struct mwifiex_ds_encrypt_key *enc_key)
 {
 	struct host_cmd_ds_802_11_key_material *key_material =
 		&cmd->params.key_material;
-	struct mwifiex_ds_encrypt_key *enc_key =
-		(struct mwifiex_ds_encrypt_key *) data_buf;
 	u16 key_param_len = 0;
 	int ret = 0;
 	const u8 bc_mac[] = { 0xff, 0xff, 0xff, 0xff, 0xff, 0xff };
@@ -741,7 +732,7 @@ static int mwifiex_cmd_802_11d_domain_info(struct mwifiex_private *priv,
  */
 static int mwifiex_cmd_802_11_rf_channel(struct mwifiex_private *priv,
 					 struct host_cmd_ds_command *cmd,
-					 u16 cmd_action, void *data_buf)
+					 u16 cmd_action, u16 *channel)
 {
 	struct host_cmd_ds_802_11_rf_channel *rf_chan =
 		&cmd->params.rf_channel;
@@ -759,7 +750,7 @@ static int mwifiex_cmd_802_11_rf_channel(struct mwifiex_private *priv,
 
 		rf_type = le16_to_cpu(rf_chan->rf_type);
 		SET_SECONDARYCHAN(rf_type, priv->adapter->chan_offset);
-		rf_chan->current_channel = cpu_to_le16(*((u16 *) data_buf));
+		rf_chan->current_channel = cpu_to_le16(*channel);
 	}
 	rf_chan->action = cpu_to_le16(cmd_action);
 	return 0;
@@ -774,11 +765,10 @@ static int mwifiex_cmd_802_11_rf_channel(struct mwifiex_private *priv,
  *      - Ensuring correct endian-ness
  */
 static int mwifiex_cmd_ibss_coalescing_status(struct host_cmd_ds_command *cmd,
-					      u16 cmd_action, void *data_buf)
+					      u16 cmd_action, u16 *enable)
 {
 	struct host_cmd_ds_802_11_ibss_status *ibss_coal =
 		&(cmd->params.ibss_coalescing);
-	u16 enable = 0;
 
 	cmd->command = cpu_to_le16(HostCmd_CMD_802_11_IBSS_COALESCING_STATUS);
 	cmd->size = cpu_to_le16(sizeof(struct host_cmd_ds_802_11_ibss_status) +
@@ -788,9 +778,8 @@ static int mwifiex_cmd_ibss_coalescing_status(struct host_cmd_ds_command *cmd,
 
 	switch (cmd_action) {
 	case HostCmd_ACT_GEN_SET:
-		if (data_buf != NULL)
-			enable = *(u16 *) data_buf;
-		ibss_coal->enable = cpu_to_le16(enable);
+		if (enable)
+			ibss_coal->enable = cpu_to_le16(*enable);
 		break;
 
 		/* In other case.. Nothing to do */
@@ -822,9 +811,8 @@ static int mwifiex_cmd_ibss_coalescing_status(struct host_cmd_ds_command *cmd,
 static int mwifiex_cmd_reg_access(struct host_cmd_ds_command *cmd,
 				  u16 cmd_action, void *data_buf)
 {
-	struct mwifiex_ds_reg_rw *reg_rw;
+	struct mwifiex_ds_reg_rw *reg_rw = data_buf;
 
-	reg_rw = (struct mwifiex_ds_reg_rw *) data_buf;
 	switch (le16_to_cpu(cmd->command)) {
 	case HostCmd_CMD_MAC_REG_ACCESS:
 	{
@@ -893,8 +881,7 @@ static int mwifiex_cmd_reg_access(struct host_cmd_ds_command *cmd,
 	}
 	case HostCmd_CMD_802_11_EEPROM_ACCESS:
 	{
-		struct mwifiex_ds_read_eeprom *rd_eeprom =
-			(struct mwifiex_ds_read_eeprom *) data_buf;
+		struct mwifiex_ds_read_eeprom *rd_eeprom = data_buf;
 		struct host_cmd_ds_802_11_eeprom_access *cmd_eeprom =
 			(struct host_cmd_ds_802_11_eeprom_access *)
 			&cmd->params.eeprom;
@@ -923,8 +910,7 @@ int mwifiex_sta_prepare_cmd(struct mwifiex_private *priv, uint16_t cmd_no,
 			    u16 cmd_action, u32 cmd_oid,
 			    void *data_buf, void *cmd_buf)
 {
-	struct host_cmd_ds_command *cmd_ptr =
-		(struct host_cmd_ds_command *) cmd_buf;
+	struct host_cmd_ds_command *cmd_ptr = cmd_buf;
 	int ret = 0;
 
 	/* Prepare command */
@@ -1181,7 +1167,7 @@ int mwifiex_sta_init_cmd(struct mwifiex_private *priv, u8 first_sta)
 	/* Send request to firmware */
 	ret = mwifiex_send_cmd_async(priv, HostCmd_CMD_AMSDU_AGGR_CTRL,
 				     HostCmd_ACT_GEN_SET, 0,
-				     (void *) &amsdu_aggr_ctrl);
+				     &amsdu_aggr_ctrl);
 	if (ret)
 		return -1;
 	/* MAC Control must be the last command in init_fw */
diff --git a/drivers/net/wireless/mwifiex/sta_cmdresp.c b/drivers/net/wireless/mwifiex/sta_cmdresp.c
index d08f764..7e4b6be 100644
--- a/drivers/net/wireless/mwifiex/sta_cmdresp.c
+++ b/drivers/net/wireless/mwifiex/sta_cmdresp.c
@@ -120,11 +120,10 @@ mwifiex_process_cmdresp_error(struct mwifiex_private *priv,
  */
 static int mwifiex_ret_802_11_rssi_info(struct mwifiex_private *priv,
 					struct host_cmd_ds_command *resp,
-					void *data_buf)
+					struct mwifiex_ds_get_signal *signal)
 {
 	struct host_cmd_ds_802_11_rssi_info_rsp *rssi_info_rsp =
 		&resp->params.rssi_info_rsp;
-	struct mwifiex_ds_get_signal *signal;
 
 	priv->data_rssi_last = le16_to_cpu(rssi_info_rsp->data_rssi_last);
 	priv->data_nf_last = le16_to_cpu(rssi_info_rsp->data_nf_last);
@@ -139,8 +138,7 @@ static int mwifiex_ret_802_11_rssi_info(struct mwifiex_private *priv,
 	priv->bcn_nf_avg = le16_to_cpu(rssi_info_rsp->bcn_nf_avg);
 
 	/* Need to indicate IOCTL complete */
-	if (data_buf) {
-		signal = (struct mwifiex_ds_get_signal *) data_buf;
+	if (signal) {
 		memset(signal, 0, sizeof(struct mwifiex_ds_get_signal));
 
 		signal->selector = ALL_RSSI_INFO_MASK;
@@ -185,32 +183,30 @@ static int mwifiex_ret_802_11_rssi_info(struct mwifiex_private *priv,
  */
 static int mwifiex_ret_802_11_snmp_mib(struct mwifiex_private *priv,
 				       struct host_cmd_ds_command *resp,
-				       void *data_buf)
+				       u32 *ul_temp)
 {
 	struct host_cmd_ds_802_11_snmp_mib *smib = &resp->params.smib;
 	u16 oid = le16_to_cpu(smib->oid);
 	u16 query_type = le16_to_cpu(smib->query_type);
-	u32 ul_temp;
 
 	dev_dbg(priv->adapter->dev, "info: SNMP_RESP: oid value = %#x,"
 			" query_type = %#x, buf size = %#x\n",
 			oid, query_type, le16_to_cpu(smib->buf_size));
 	if (query_type == HostCmd_ACT_GEN_GET) {
-		ul_temp = le16_to_cpu(*((__le16 *) (smib->value)));
-		if (data_buf)
-			*(u32 *)data_buf = ul_temp;
+		if (ul_temp)
+			*ul_temp = le16_to_cpu(*((__le16 *) (smib->value)));
 		switch (oid) {
 		case FRAG_THRESH_I:
 			dev_dbg(priv->adapter->dev,
-				"info: SNMP_RESP: FragThsd =%u\n", ul_temp);
+				"info: SNMP_RESP: FragThsd =%u\n", *ul_temp);
 			break;
 		case RTS_THRESH_I:
 			dev_dbg(priv->adapter->dev,
-				"info: SNMP_RESP: RTSThsd =%u\n", ul_temp);
+				"info: SNMP_RESP: RTSThsd =%u\n", *ul_temp);
 			break;
 		case SHORT_RETRY_LIM_I:
 			dev_dbg(priv->adapter->dev,
-				"info: SNMP_RESP: TxRetryCount=%u\n", ul_temp);
+				"info: SNMP_RESP: TxRetryCount=%u\n", *ul_temp);
 			break;
 		default:
 			break;
@@ -228,14 +224,12 @@ static int mwifiex_ret_802_11_snmp_mib(struct mwifiex_private *priv,
  */
 static int mwifiex_ret_get_log(struct mwifiex_private *priv,
 			       struct host_cmd_ds_command *resp,
-			       void *data_buf)
+			       struct mwifiex_ds_get_stats *stats)
 {
 	struct host_cmd_ds_802_11_get_log *get_log =
 		(struct host_cmd_ds_802_11_get_log *) &resp->params.get_log;
-	struct mwifiex_ds_get_stats *stats;
 
-	if (data_buf) {
-		stats = (struct mwifiex_ds_get_stats *) data_buf;
+	if (stats) {
 		stats->mcast_tx_frame = le32_to_cpu(get_log->mcast_tx_frame);
 		stats->failed = le32_to_cpu(get_log->failed);
 		stats->retry = le32_to_cpu(get_log->retry);
@@ -278,9 +272,8 @@ static int mwifiex_ret_get_log(struct mwifiex_private *priv,
  */
 static int mwifiex_ret_tx_rate_cfg(struct mwifiex_private *priv,
 				   struct host_cmd_ds_command *resp,
-				   void *data_buf)
+				   struct mwifiex_rate_cfg *ds_rate)
 {
-	struct mwifiex_rate_cfg *ds_rate;
 	struct host_cmd_ds_tx_rate_cfg *rate_cfg = &resp->params.tx_rate_cfg;
 	struct mwifiex_rate_scope *rate_scope;
 	struct mwifiex_ie_types_header *head;
@@ -329,8 +322,7 @@ static int mwifiex_ret_tx_rate_cfg(struct mwifiex_private *priv,
 					  HostCmd_CMD_802_11_TX_RATE_QUERY,
 					  HostCmd_ACT_GEN_GET, 0, NULL);
 
-	if (data_buf) {
-		ds_rate = (struct mwifiex_rate_cfg *) data_buf;
+	if (ds_rate) {
 		if (le16_to_cpu(rate_cfg->action) == HostCmd_ACT_GEN_GET) {
 			if (priv->is_data_rate_auto) {
 				ds_rate->is_rate_auto = 1;
@@ -413,8 +405,7 @@ static int mwifiex_get_power_level(struct mwifiex_private *priv, void *data_buf)
  * and saving the current Tx power level in driver.
  */
 static int mwifiex_ret_tx_power_cfg(struct mwifiex_private *priv,
-				    struct host_cmd_ds_command *resp,
-				    void *data_buf)
+				    struct host_cmd_ds_command *resp)
 {
 	struct mwifiex_adapter *adapter = priv->adapter;
 	struct host_cmd_ds_txpwr_cfg *txp_cfg = &resp->params.txp_cfg;
@@ -631,21 +622,21 @@ static int mwifiex_ret_802_11d_domain_info(struct mwifiex_private *priv,
  */
 static int mwifiex_ret_802_11_rf_channel(struct mwifiex_private *priv,
 					 struct host_cmd_ds_command *resp,
-					 void *data_buf)
+					 u16 *new_channel)
 {
 	struct host_cmd_ds_802_11_rf_channel *rf_channel =
 		&resp->params.rf_channel;
-	u16 new_channel = le16_to_cpu(rf_channel->current_channel);
 
-	if (priv->curr_bss_params.bss_descriptor.channel != new_channel) {
+	if (new_channel)
+		*new_channel = le16_to_cpu(rf_channel->current_channel);
+
+	if (priv->curr_bss_params.bss_descriptor.channel != *new_channel) {
 		dev_dbg(priv->adapter->dev, "cmd: Channel Switch: %d to %d\n",
 		       priv->curr_bss_params.bss_descriptor.channel,
-		       new_channel);
+		       *new_channel);
 		/* Update the channel again */
-		priv->curr_bss_params.bss_descriptor.channel = new_channel;
+		priv->curr_bss_params.bss_descriptor.channel = *new_channel;
 	}
-	if (data_buf)
-		*((u16 *)data_buf) = new_channel;
 
 	return 0;
 }
@@ -658,13 +649,11 @@ static int mwifiex_ret_802_11_rf_channel(struct mwifiex_private *priv,
  */
 static int mwifiex_ret_ver_ext(struct mwifiex_private *priv,
 			       struct host_cmd_ds_command *resp,
-			       void *data_buf)
+			       struct host_cmd_ds_version_ext *version_ext)
 {
 	struct host_cmd_ds_version_ext *ver_ext = &resp->params.verext;
-	struct host_cmd_ds_version_ext *version_ext;
 
-	if (data_buf) {
-		version_ext = (struct host_cmd_ds_version_ext *)data_buf;
+	if (version_ext) {
 		version_ext->version_str_sel = ver_ext->version_str_sel;
 		memcpy(version_ext->version_str, ver_ext->version_str,
 		       sizeof(char) * 128);
@@ -686,8 +675,8 @@ static int mwifiex_ret_reg_access(u16 type, struct host_cmd_ds_command *resp,
 	struct mwifiex_ds_read_eeprom *eeprom;
 
 	if (data_buf) {
-		reg_rw = (struct mwifiex_ds_reg_rw *) data_buf;
-		eeprom = (struct mwifiex_ds_read_eeprom *) data_buf;
+		reg_rw = data_buf;
+		eeprom = data_buf;
 		switch (type) {
 		case HostCmd_CMD_MAC_REG_ACCESS:
 			{
@@ -825,13 +814,11 @@ static int mwifiex_ret_ibss_coalescing_status(struct mwifiex_private *priv,
  * This is a generic function, which calls command specific
  * response handlers based on the command ID.
  */
-int mwifiex_process_sta_cmdresp(struct mwifiex_private *priv,
-				u16 cmdresp_no, void *cmd_buf)
+int mwifiex_process_sta_cmdresp(struct mwifiex_private *priv, u16 cmdresp_no,
+				struct host_cmd_ds_command *resp)
 {
 	int ret = 0;
 	struct mwifiex_adapter *adapter = priv->adapter;
-	struct host_cmd_ds_command *resp =
-		(struct host_cmd_ds_command *) cmd_buf;
 	void *data_buf = adapter->curr_cmd->data_buf;
 
 	/* If the command is not successful, cleanup and return failure */
@@ -865,7 +852,7 @@ int mwifiex_process_sta_cmdresp(struct mwifiex_private *priv,
 			"info: CMD_RESP: BG_SCAN result is ready!\n");
 		break;
 	case HostCmd_CMD_TXPWR_CFG:
-		ret = mwifiex_ret_tx_power_cfg(priv, resp, data_buf);
+		ret = mwifiex_ret_tx_power_cfg(priv, resp);
 		break;
 	case HostCmd_CMD_802_11_PS_MODE_ENH:
 		ret = mwifiex_ret_enh_power_mode(priv, resp, data_buf);
diff --git a/drivers/net/wireless/mwifiex/sta_rx.c b/drivers/net/wireless/mwifiex/sta_rx.c
index 1fdddec..2743051 100644
--- a/drivers/net/wireless/mwifiex/sta_rx.c
+++ b/drivers/net/wireless/mwifiex/sta_rx.c
@@ -187,7 +187,7 @@ int mwifiex_process_sta_rx_packet(struct mwifiex_adapter *adapter,
 	ret = mwifiex_11n_rx_reorder_pkt(priv, local_rx_pd->seq_num,
 					     local_rx_pd->priority, ta,
 					     (u8) local_rx_pd->rx_pkt_type,
-						(void *) skb);
+					     skb);
 
 	if (ret || (rx_pkt_type == PKT_TYPE_BAR)) {
 		if (priv && (ret == -1))
diff --git a/drivers/net/wireless/mwifiex/txrx.c b/drivers/net/wireless/mwifiex/txrx.c
index aaa50c0..6190b2f 100644
--- a/drivers/net/wireless/mwifiex/txrx.c
+++ b/drivers/net/wireless/mwifiex/txrx.c
@@ -71,7 +71,7 @@ int mwifiex_process_tx(struct mwifiex_private *priv, struct sk_buff *skb,
 	u8 *head_ptr;
 	struct txpd *local_tx_pd = NULL;
 
-	head_ptr = (u8 *) mwifiex_process_sta_txpd(priv, skb);
+	head_ptr = mwifiex_process_sta_txpd(priv, skb);
 	if (head_ptr) {
 		if (GET_BSS_ROLE(priv) == MWIFIEX_BSS_ROLE_STA)
 			local_tx_pd =
-- 
1.7.0.2

