Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from dakia2.marvell.com ([65.219.4.35]:57128 "EHLO
	dakia2.marvell.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754886Ab1EDDHP (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 3 May 2011 23:07:15 -0400
From: Bing Zhao <bzhao@marvell.com>
To: linux-wireless@vger.kernel.org
Cc: "John W. Linville" <linville@tuxdriver.com>,
	Johannes Berg <johannes@sipsolutions.net>,
	Amitkumar Karwar <akarwar@marvell.com>,
	Kiran Divekar <dkiran@marvell.com>,
	Yogesh Powar <yogeshp@marvell.com>,
	Marc Yang <yangyang@marvell.com>,
	Frank Huang <frankh@marvell.com>, Bing Zhao <bzhao@marvell.com>
Subject: [PATCH 2/2] mwifiex: remove unnecessary variable initialization
Date: Tue,  3 May 2011 20:11:46 -0700
Message-Id: <1304478706-31673-2-git-send-email-bzhao@marvell.com> (sfid-20110504_050728_665147_7D9672C4)
In-Reply-To: <1304478706-31673-1-git-send-email-bzhao@marvell.com>
References: <1304478706-31673-1-git-send-email-bzhao@marvell.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Yogesh Ashok Powar <yogeshp@marvell.com>

Skip initialization of local variables with some default values
if the values are not going to be used further down the code path.

Signed-off-by: Yogesh Ashok Powar <yogeshp@marvell.com>
Signed-off-by: Bing Zhao <bzhao@marvell.com>
---
 drivers/net/wireless/mwifiex/11n.c           |    7 ++--
 drivers/net/wireless/mwifiex/11n_aggr.c      |    7 ++--
 drivers/net/wireless/mwifiex/11n_rxreorder.c |   15 ++++----
 drivers/net/wireless/mwifiex/cfg80211.c      |   23 +++++-------
 drivers/net/wireless/mwifiex/cmdevt.c        |   28 +++++++-------
 drivers/net/wireless/mwifiex/debugfs.c       |   10 +++---
 drivers/net/wireless/mwifiex/init.c          |   29 ++++++---------
 drivers/net/wireless/mwifiex/join.c          |    9 ++---
 drivers/net/wireless/mwifiex/main.c          |   19 +++++-----
 drivers/net/wireless/mwifiex/scan.c          |   22 ++++++------
 drivers/net/wireless/mwifiex/sdio.c          |   30 ++++++++--------
 drivers/net/wireless/mwifiex/sta_cmd.c       |    8 ++--
 drivers/net/wireless/mwifiex/sta_cmdresp.c   |   28 +++++++-------
 drivers/net/wireless/mwifiex/sta_ioctl.c     |   50 ++++++++++++-------------
 drivers/net/wireless/mwifiex/sta_rx.c        |    4 +-
 drivers/net/wireless/mwifiex/sta_tx.c        |    4 +-
 drivers/net/wireless/mwifiex/txrx.c          |   10 +++---
 drivers/net/wireless/mwifiex/util.c          |    8 ++--
 drivers/net/wireless/mwifiex/wmm.c           |    2 +-
 19 files changed, 148 insertions(+), 165 deletions(-)

diff --git a/drivers/net/wireless/mwifiex/11n.c b/drivers/net/wireless/mwifiex/11n.c
index 1d294cf..916183d 100644
--- a/drivers/net/wireless/mwifiex/11n.c
+++ b/drivers/net/wireless/mwifiex/11n.c
@@ -187,7 +187,7 @@ int mwifiex_ret_11n_addba_req(struct mwifiex_private *priv,
  */
 int mwifiex_ret_11n_cfg(struct host_cmd_ds_command *resp, void *data_buf)
 {
-	struct mwifiex_ds_11n_tx_cfg *tx_cfg = NULL;
+	struct mwifiex_ds_11n_tx_cfg *tx_cfg;
 	struct host_cmd_ds_11n_cfg *htcfg = &resp->params.htcfg;
 
 	if (data_buf) {
@@ -274,7 +274,7 @@ int mwifiex_cmd_amsdu_aggr_ctrl(struct host_cmd_ds_command *cmd,
 int mwifiex_ret_amsdu_aggr_ctrl(struct host_cmd_ds_command *resp,
 				void *data_buf)
 {
-	struct mwifiex_ds_11n_amsdu_aggr_ctrl *amsdu_aggr_ctrl = NULL;
+	struct mwifiex_ds_11n_amsdu_aggr_ctrl *amsdu_aggr_ctrl;
 	struct host_cmd_ds_amsdu_aggr_ctrl *amsdu_ctrl =
 		&resp->params.amsdu_aggr_ctrl;
 
@@ -461,8 +461,7 @@ mwifiex_cfg_tx_buf(struct mwifiex_private *priv,
 		   struct mwifiex_bssdescriptor *bss_desc)
 {
 	u16 max_amsdu = MWIFIEX_TX_DATA_BUF_SIZE_2K;
-	u16 tx_buf = 0;
-	u16 curr_tx_buf_size = 0;
+	u16 tx_buf, curr_tx_buf_size = 0;
 
 	if (bss_desc->bcn_ht_cap) {
 		if (le16_to_cpu(bss_desc->bcn_ht_cap->cap_info) &
diff --git a/drivers/net/wireless/mwifiex/11n_aggr.c b/drivers/net/wireless/mwifiex/11n_aggr.c
index c9fb062..12cf424 100644
--- a/drivers/net/wireless/mwifiex/11n_aggr.c
+++ b/drivers/net/wireless/mwifiex/11n_aggr.c
@@ -60,7 +60,7 @@ mwifiex_11n_form_amsdu_pkt(struct sk_buff *skb_aggr,
 			 * later with ethertype
 			 */
 	};
-	struct tx_packet_hdr *tx_header = NULL;
+	struct tx_packet_hdr *tx_header;
 
 	skb_put(skb_aggr, sizeof(*tx_header));
 
@@ -182,7 +182,7 @@ int mwifiex_11n_deaggregate_pkt(struct mwifiex_private *priv,
 	struct mwifiex_rxinfo *rx_info = MWIFIEX_SKB_RXCB(skb);
 	struct rxpd *local_rx_pd = (struct rxpd *) skb->data;
 	struct sk_buff *skb_daggr;
-	struct mwifiex_rxinfo *rx_info_daggr = NULL;
+	struct mwifiex_rxinfo *rx_info_daggr;
 	int ret = -1;
 	struct rx_packet_hdr *rx_pkt_hdr;
 	struct mwifiex_adapter *adapter = priv->adapter;
@@ -285,8 +285,7 @@ mwifiex_11n_aggregate_pkt(struct mwifiex_private *priv,
 	struct mwifiex_adapter *adapter = priv->adapter;
 	struct sk_buff *skb_aggr, *skb_src;
 	struct mwifiex_txinfo *tx_info_aggr, *tx_info_src;
-	int pad = 0;
-	int ret = 0;
+	int pad = 0, ret;
 	struct mwifiex_tx_param tx_param;
 	struct txpd *ptx_pd = NULL;
 
diff --git a/drivers/net/wireless/mwifiex/11n_rxreorder.c b/drivers/net/wireless/mwifiex/11n_rxreorder.c
index a93c03f..e5dfdc3 100644
--- a/drivers/net/wireless/mwifiex/11n_rxreorder.c
+++ b/drivers/net/wireless/mwifiex/11n_rxreorder.c
@@ -39,7 +39,7 @@ mwifiex_11n_dispatch_pkt_until_start_win(struct mwifiex_private *priv,
 					 *rx_reor_tbl_ptr, int start_win)
 {
 	int no_pkt_to_send, i;
-	void *rx_tmp_ptr = NULL;
+	void *rx_tmp_ptr;
 	unsigned long flags;
 
 	no_pkt_to_send = (start_win > rx_reor_tbl_ptr->start_win) ?
@@ -88,7 +88,7 @@ mwifiex_11n_scan_and_dispatch(struct mwifiex_private *priv,
 			      struct mwifiex_rx_reorder_tbl *rx_reor_tbl_ptr)
 {
 	int i, j, xchg;
-	void *rx_tmp_ptr = NULL;
+	void *rx_tmp_ptr;
 	unsigned long flags;
 
 	for (i = 0; i < rx_reor_tbl_ptr->win_size; ++i) {
@@ -335,8 +335,8 @@ int mwifiex_cmd_11n_addba_rsp_gen(struct mwifiex_private *priv,
 		&cmd->params.add_ba_rsp;
 	struct host_cmd_ds_11n_addba_req *cmd_addba_req =
 		(struct host_cmd_ds_11n_addba_req *) data_buf;
-	u8 tid = 0;
-	int win_size = 0;
+	u8 tid;
+	int win_size;
 	uint16_t block_ack_param_set;
 
 	cmd->command = cpu_to_le16(HostCmd_CMD_11N_ADDBA_RSP);
@@ -406,9 +406,8 @@ int mwifiex_11n_rx_reorder_pkt(struct mwifiex_private *priv,
 				u8 *ta, u8 pkt_type, void *payload)
 {
 	struct mwifiex_rx_reorder_tbl *rx_reor_tbl_ptr;
-	int start_win, end_win, win_size;
-	int ret = 0;
-	u16 pkt_index = 0;
+	int start_win, end_win, win_size, ret;
+	u16 pkt_index;
 
 	rx_reor_tbl_ptr =
 		mwifiex_11n_get_rx_reorder_tbl((struct mwifiex_private *) priv,
@@ -540,7 +539,7 @@ int mwifiex_ret_11n_addba_resp(struct mwifiex_private *priv,
 		(struct host_cmd_ds_11n_addba_rsp *)
 		&resp->params.add_ba_rsp;
 	int tid, win_size;
-	struct mwifiex_rx_reorder_tbl *rx_reor_tbl_ptr = NULL;
+	struct mwifiex_rx_reorder_tbl *rx_reor_tbl_ptr;
 	uint16_t block_ack_param_set;
 
 	block_ack_param_set = le16_to_cpu(add_ba_rsp->block_ack_param_set);
diff --git a/drivers/net/wireless/mwifiex/cfg80211.c b/drivers/net/wireless/mwifiex/cfg80211.c
index 77a8029..0c01163 100644
--- a/drivers/net/wireless/mwifiex/cfg80211.c
+++ b/drivers/net/wireless/mwifiex/cfg80211.c
@@ -77,18 +77,15 @@ mwifiex_channels_to_cfg80211_channel_type(int channel_type)
 static int
 mwifiex_is_alg_wep(u32 cipher)
 {
-	int alg = 0;
-
 	switch (cipher) {
 	case WLAN_CIPHER_SUITE_WEP40:
 	case WLAN_CIPHER_SUITE_WEP104:
-		alg = 1;
-		break;
+		return 1;
 	default:
-		alg = 0;
 		break;
 	}
-	return alg;
+
+	return 0;
 }
 
 /*
@@ -408,7 +405,7 @@ mwifiex_cfg80211_set_channel(struct wiphy *wiphy, struct net_device *dev,
 static int
 mwifiex_set_frag(struct mwifiex_private *priv, u32 frag_thr)
 {
-	int ret = 0;
+	int ret;
 
 	if (frag_thr < MWIFIEX_FRAG_MIN_VALUE
 	    || frag_thr > MWIFIEX_FRAG_MAX_VALUE)
@@ -449,7 +446,6 @@ static int
 mwifiex_cfg80211_set_wiphy_params(struct wiphy *wiphy, u32 changed)
 {
 	struct mwifiex_private *priv = mwifiex_cfg80211_get_priv(wiphy);
-
 	int ret = 0;
 
 	if (changed & WIPHY_PARAM_RTS_THRESHOLD) {
@@ -473,7 +469,7 @@ mwifiex_cfg80211_change_virtual_intf(struct wiphy *wiphy,
 				     enum nl80211_iftype type, u32 *flags,
 				     struct vif_params *params)
 {
-	int ret = 0;
+	int ret;
 	struct mwifiex_private *priv = mwifiex_netdev_get_priv(dev);
 
 	if (priv->bss_mode == type) {
@@ -717,7 +713,7 @@ static int mwifiex_cfg80211_inform_ibss_bss(struct mwifiex_private *priv)
 {
 	struct ieee80211_channel *chan;
 	struct mwifiex_bss_info bss_info;
-	int ie_len = 0;
+	int ie_len;
 	u8 ie_buf[IEEE80211_MAX_SSID_LEN + sizeof(struct ieee_types_header)];
 
 	if (mwifiex_get_bss_info(priv, &bss_info))
@@ -903,8 +899,7 @@ mwifiex_cfg80211_assoc(struct mwifiex_private *priv, size_t ssid_len, u8 *ssid,
 {
 	struct mwifiex_802_11_ssid req_ssid;
 	struct mwifiex_ssid_bssid ssid_bssid;
-	int ret = 0;
-	int auth_type = 0;
+	int ret, auth_type = 0;
 
 	memset(&req_ssid, 0, sizeof(struct mwifiex_802_11_ssid));
 	memset(&ssid_bssid, 0, sizeof(struct mwifiex_ssid_bssid));
@@ -1247,8 +1242,8 @@ static struct cfg80211_ops mwifiex_cfg80211_ops = {
 int mwifiex_register_cfg80211(struct net_device *dev, u8 *mac,
 			      struct mwifiex_private *priv)
 {
-	int ret = 0;
-	void *wdev_priv = NULL;
+	int ret;
+	void *wdev_priv;
 	struct wireless_dev *wdev;
 
 	wdev = kzalloc(sizeof(struct wireless_dev), GFP_KERNEL);
diff --git a/drivers/net/wireless/mwifiex/cmdevt.c b/drivers/net/wireless/mwifiex/cmdevt.c
index 776146a..b75cc92 100644
--- a/drivers/net/wireless/mwifiex/cmdevt.c
+++ b/drivers/net/wireless/mwifiex/cmdevt.c
@@ -128,7 +128,7 @@ static int mwifiex_dnld_cmd_to_fw(struct mwifiex_private *priv,
 {
 
 	struct mwifiex_adapter *adapter = priv->adapter;
-	int ret = 0;
+	int ret;
 	struct host_cmd_ds_command *host_cmd;
 	uint16_t cmd_code;
 	uint16_t cmd_size;
@@ -222,8 +222,8 @@ static int mwifiex_dnld_cmd_to_fw(struct mwifiex_private *priv,
  */
 static int mwifiex_dnld_sleep_confirm_cmd(struct mwifiex_adapter *adapter)
 {
-	int ret = 0;
-	u16 cmd_len = 0;
+	int ret;
+	u16 cmd_len;
 	struct mwifiex_private *priv;
 	struct mwifiex_opt_sleep_confirm_buffer *sleep_cfm_buf =
 				(struct mwifiex_opt_sleep_confirm_buffer *)
@@ -364,13 +364,13 @@ int mwifiex_free_cmd_buffer(struct mwifiex_adapter *adapter)
  */
 int mwifiex_process_event(struct mwifiex_adapter *adapter)
 {
-	int ret = 0;
+	int ret;
 	struct mwifiex_private *priv =
 		mwifiex_get_priv(adapter, MWIFIEX_BSS_ROLE_ANY);
 	struct sk_buff *skb = adapter->event_skb;
 	u32 eventcause = adapter->event_cause;
 	struct timeval tstamp;
-	struct mwifiex_rxinfo *rx_info = NULL;
+	struct mwifiex_rxinfo *rx_info;
 
 	/* Save the last event to debug log */
 	adapter->dbg.last_event_index =
@@ -446,10 +446,10 @@ int mwifiex_send_cmd_sync(struct mwifiex_private *priv, uint16_t cmd_no,
 int mwifiex_send_cmd_async(struct mwifiex_private *priv, uint16_t cmd_no,
 			   u16 cmd_action, u32 cmd_oid, void *data_buf)
 {
-	int ret = 0;
+	int ret;
 	struct mwifiex_adapter *adapter = priv->adapter;
-	struct cmd_ctrl_node *cmd_node = NULL;
-	struct host_cmd_ds_command *cmd_ptr = NULL;
+	struct cmd_ctrl_node *cmd_node;
+	struct host_cmd_ds_command *cmd_ptr;
 
 	if (!adapter) {
 		pr_err("PREP_CMD: adapter is NULL\n");
@@ -605,8 +605,8 @@ mwifiex_insert_cmd_to_pending_q(struct mwifiex_adapter *adapter,
  */
 int mwifiex_exec_next_cmd(struct mwifiex_adapter *adapter)
 {
-	struct mwifiex_private *priv = NULL;
-	struct cmd_ctrl_node *cmd_node = NULL;
+	struct mwifiex_private *priv;
+	struct cmd_ctrl_node *cmd_node;
 	int ret = 0;
 	struct host_cmd_ds_command *host_cmd;
 	unsigned long cmd_flags;
@@ -673,7 +673,7 @@ int mwifiex_exec_next_cmd(struct mwifiex_adapter *adapter)
  */
 int mwifiex_process_cmdresp(struct mwifiex_adapter *adapter)
 {
-	struct host_cmd_ds_command *resp = NULL;
+	struct host_cmd_ds_command *resp;
 	struct mwifiex_private *priv =
 		mwifiex_get_priv(adapter, MWIFIEX_BSS_ROLE_ANY);
 	int ret = 0;
@@ -805,7 +805,7 @@ mwifiex_cmd_timeout_func(unsigned long function_context)
 {
 	struct mwifiex_adapter *adapter =
 		(struct mwifiex_adapter *) function_context;
-	struct cmd_ctrl_node *cmd_node = NULL;
+	struct cmd_ctrl_node *cmd_node;
 	struct timeval tstamp;
 
 	adapter->num_cmd_timeout++;
@@ -877,7 +877,7 @@ mwifiex_cmd_timeout_func(unsigned long function_context)
 void
 mwifiex_cancel_all_pending_cmd(struct mwifiex_adapter *adapter)
 {
-	struct cmd_ctrl_node *cmd_node = NULL, *tmp_node = NULL;
+	struct cmd_ctrl_node *cmd_node = NULL, *tmp_node;
 	unsigned long flags;
 
 	/* Cancel current cmd */
@@ -1160,7 +1160,7 @@ int mwifiex_cmd_enh_power_mode(struct mwifiex_private *priv,
 {
 	struct host_cmd_ds_802_11_ps_mode_enh *psmode_enh =
 		&cmd->params.psmode_enh;
-	u8 *tlv = NULL;
+	u8 *tlv;
 	u16 cmd_size = 0;
 
 	cmd->command = cpu_to_le16(HostCmd_CMD_802_11_PS_MODE_ENH);
diff --git a/drivers/net/wireless/mwifiex/debugfs.c b/drivers/net/wireless/mwifiex/debugfs.c
index 7ddcb06..46d65e0 100644
--- a/drivers/net/wireless/mwifiex/debugfs.c
+++ b/drivers/net/wireless/mwifiex/debugfs.c
@@ -193,7 +193,7 @@ mwifiex_info_read(struct file *file, char __user *ubuf,
 	unsigned long page = get_zeroed_page(GFP_KERNEL);
 	char *p = (char *) page, fmt[64];
 	struct mwifiex_bss_info info;
-	ssize_t ret = 0;
+	ssize_t ret;
 	int i = 0;
 
 	if (!p)
@@ -288,7 +288,7 @@ mwifiex_getlog_read(struct file *file, char __user *ubuf,
 		(struct mwifiex_private *) file->private_data;
 	unsigned long page = get_zeroed_page(GFP_KERNEL);
 	char *p = (char *) page;
-	ssize_t ret = 0;
+	ssize_t ret;
 	struct mwifiex_ds_get_stats stats;
 
 	if (!p)
@@ -400,7 +400,7 @@ mwifiex_debug_read(struct file *file, char __user *ubuf,
 	struct mwifiex_debug_data *d = &items[0];
 	unsigned long page = get_zeroed_page(GFP_KERNEL);
 	char *p = (char *) page;
-	ssize_t ret = 0;
+	ssize_t ret;
 	size_t size, addr;
 	long val;
 	int i, j;
@@ -507,7 +507,7 @@ mwifiex_regrdwr_write(struct file *file,
 	unsigned long addr = get_zeroed_page(GFP_KERNEL);
 	char *buf = (char *) addr;
 	size_t buf_size = min(count, (size_t) (PAGE_SIZE - 1));
-	int ret = 0;
+	int ret;
 	u32 reg_type = 0, reg_offset = 0, reg_value = UINT_MAX;
 
 	if (!buf)
@@ -650,7 +650,7 @@ mwifiex_rdeeprom_read(struct file *file, char __user *ubuf,
 		(struct mwifiex_private *) file->private_data;
 	unsigned long addr = get_zeroed_page(GFP_KERNEL);
 	char *buf = (char *) addr;
-	int pos = 0, ret = 0, i = 0;
+	int pos = 0, ret = 0, i;
 	u8 value[MAX_EEPROM_DATA];
 
 	if (!buf)
diff --git a/drivers/net/wireless/mwifiex/init.c b/drivers/net/wireless/mwifiex/init.c
index fc2c0c5..27ad72b 100644
--- a/drivers/net/wireless/mwifiex/init.c
+++ b/drivers/net/wireless/mwifiex/init.c
@@ -151,7 +151,7 @@ static int mwifiex_init_priv(struct mwifiex_private *priv)
  */
 static int mwifiex_allocate_adapter(struct mwifiex_adapter *adapter)
 {
-	int ret = 0;
+	int ret;
 	u32 buf_size;
 	struct mwifiex_bssdescriptor *temp_scan_table;
 
@@ -342,9 +342,8 @@ mwifiex_free_adapter(struct mwifiex_adapter *adapter)
  */
 int mwifiex_init_lock_list(struct mwifiex_adapter *adapter)
 {
-	struct mwifiex_private   *priv = NULL;
-	s32           i = 0;
-	u32           j = 0;
+	struct mwifiex_private *priv;
+	s32 i, j;
 
 	spin_lock_init(&adapter->mwifiex_lock);
 	spin_lock_init(&adapter->int_lock);
@@ -400,9 +399,8 @@ int mwifiex_init_lock_list(struct mwifiex_adapter *adapter)
  */
 void mwifiex_free_lock_list(struct mwifiex_adapter *adapter)
 {
-	struct mwifiex_private *priv = NULL;
-	s32           i = 0;
-	s32           j = 0;
+	struct mwifiex_private *priv;
+	s32 i, j;
 
 	/* Free lists */
 	list_del(&adapter->cmd_free_q);
@@ -436,10 +434,9 @@ void mwifiex_free_lock_list(struct mwifiex_adapter *adapter)
  */
 int mwifiex_init_fw(struct mwifiex_adapter *adapter)
 {
-	int ret = 0;
-	struct mwifiex_private *priv = NULL;
-	u8 i = 0;
-	u8 first_sta = true;
+	int ret;
+	struct mwifiex_private *priv;
+	u8 i, first_sta = true;
 	int is_cmd_pend_q_empty;
 	unsigned long flags;
 
@@ -497,8 +494,7 @@ static void mwifiex_delete_bss_prio_tbl(struct mwifiex_private *priv)
 {
 	int i;
 	struct mwifiex_adapter *adapter = priv->adapter;
-	struct mwifiex_bss_prio_node *bssprio_node = NULL, *tmp_node = NULL,
-								**cur = NULL;
+	struct mwifiex_bss_prio_node *bssprio_node, *tmp_node, **cur;
 	struct list_head *head;
 	spinlock_t *lock;
 	unsigned long flags;
@@ -552,8 +548,8 @@ int
 mwifiex_shutdown_drv(struct mwifiex_adapter *adapter)
 {
 	int ret = -EINPROGRESS;
-	struct mwifiex_private *priv = NULL;
-	s32 i = 0;
+	struct mwifiex_private *priv;
+	s32 i;
 	unsigned long flags;
 
 	/* mwifiex already shutdown */
@@ -608,9 +604,8 @@ mwifiex_shutdown_drv(struct mwifiex_adapter *adapter)
 int mwifiex_dnld_fw(struct mwifiex_adapter *adapter,
 		    struct mwifiex_fw_image *pmfw)
 {
-	int ret = 0;
+	int ret, winner;
 	u32 poll_num = 1;
-	int winner;
 
 	/* Check if firmware is already running */
 	ret = adapter->if_ops.check_fw_status(adapter, poll_num, &winner);
diff --git a/drivers/net/wireless/mwifiex/join.c b/drivers/net/wireless/mwifiex/join.c
index 85fca5e..5eab3dc 100644
--- a/drivers/net/wireless/mwifiex/join.c
+++ b/drivers/net/wireless/mwifiex/join.c
@@ -143,9 +143,8 @@ mwifiex_cmd_append_tsf_tlv(struct mwifiex_private *priv, u8 **buffer,
 static int mwifiex_get_common_rates(struct mwifiex_private *priv, u8 *rate1,
 				    u32 rate1_size, u8 *rate2, u32 rate2_size)
 {
-	int ret = 0;
-	u8 *ptr = rate1;
-	u8 *tmp = NULL;
+	int ret;
+	u8 *ptr = rate1, *tmp;
 	u32 i, j;
 
 	tmp = kmalloc(rate1_size, GFP_KERNEL);
@@ -203,7 +202,7 @@ mwifiex_setup_rates_from_bssdesc(struct mwifiex_private *priv,
 				 u8 *out_rates, u32 *out_rates_size)
 {
 	u8 card_rates[MWIFIEX_SUPPORTED_RATES];
-	u32 card_rates_size = 0;
+	u32 card_rates_size;
 
 	/* Copy AP supported rates */
 	memcpy(out_rates, bss_desc->supported_rates, MWIFIEX_SUPPORTED_RATES);
@@ -1359,7 +1358,7 @@ int mwifiex_adhoc_join(struct mwifiex_private *priv,
 static int mwifiex_deauthenticate_infra(struct mwifiex_private *priv, u8 *mac)
 {
 	u8 mac_address[ETH_ALEN];
-	int ret = 0;
+	int ret;
 	u8 zero_mac[ETH_ALEN] = { 0, 0, 0, 0, 0, 0 };
 
 	if (mac) {
diff --git a/drivers/net/wireless/mwifiex/main.c b/drivers/net/wireless/mwifiex/main.c
index c597188..38f912b 100644
--- a/drivers/net/wireless/mwifiex/main.c
+++ b/drivers/net/wireless/mwifiex/main.c
@@ -150,7 +150,7 @@ error:
  */
 static int mwifiex_unregister(struct mwifiex_adapter *adapter)
 {
-	s32 i = 0;
+	s32 i;
 
 	del_timer(&adapter->cmd_timer);
 
@@ -379,8 +379,7 @@ static void mwifiex_free_adapter(struct mwifiex_adapter *adapter)
  */
 static int mwifiex_init_hw_fw(struct mwifiex_adapter *adapter)
 {
-	int ret = 0;
-	int err;
+	int ret, err;
 	struct mwifiex_fw_image fw;
 
 	memset(&fw, 0, sizeof(struct mwifiex_fw_image));
@@ -449,7 +448,7 @@ done:
 static void
 mwifiex_fill_buffer(struct sk_buff *skb)
 {
-	struct ethhdr *eth = NULL;
+	struct ethhdr *eth;
 	struct iphdr *iph;
 	struct timeval tv;
 	u8 tid = 0;
@@ -510,7 +509,7 @@ static int
 mwifiex_hard_start_xmit(struct sk_buff *skb, struct net_device *dev)
 {
 	struct mwifiex_private *priv = mwifiex_netdev_get_priv(dev);
-	struct sk_buff *new_skb = NULL;
+	struct sk_buff *new_skb;
 	struct mwifiex_txinfo *tx_info;
 
 	dev_dbg(priv->adapter->dev, "data: %lu BSS(%d): Data <= kernel\n",
@@ -571,7 +570,7 @@ mwifiex_set_mac_address(struct net_device *dev, void *addr)
 {
 	struct mwifiex_private *priv = mwifiex_netdev_get_priv(dev);
 	struct sockaddr *hw_addr = (struct sockaddr *) addr;
-	int ret = 0;
+	int ret;
 
 	memcpy(priv->curr_addr, hw_addr->sa_data, ETH_ALEN);
 
@@ -696,9 +695,9 @@ static struct mwifiex_private *mwifiex_add_interface(
 			struct mwifiex_adapter *adapter,
 			u8 bss_index, u8 bss_type)
 {
-	struct net_device *dev = NULL;
-	struct mwifiex_private *priv = NULL;
-	void *mdev_priv = NULL;
+	struct net_device *dev;
+	struct mwifiex_private *priv;
+	void *mdev_priv;
 
 	dev = alloc_netdev_mq(sizeof(struct mwifiex_private *), "mlan%d",
 			      ether_setup, 1);
@@ -763,7 +762,7 @@ error:
 static void
 mwifiex_remove_interface(struct mwifiex_adapter *adapter, u8 bss_index)
 {
-	struct net_device *dev = NULL;
+	struct net_device *dev;
 	struct mwifiex_private *priv = adapter->priv[bss_index];
 
 	if (!priv)
diff --git a/drivers/net/wireless/mwifiex/scan.c b/drivers/net/wireless/mwifiex/scan.c
index 31a5295..4968974 100644
--- a/drivers/net/wireless/mwifiex/scan.c
+++ b/drivers/net/wireless/mwifiex/scan.c
@@ -117,8 +117,8 @@ mwifiex_search_oui_in_ie(struct ie_body *iebody, u8 *oui)
 static u8
 mwifiex_is_rsn_oui_present(struct mwifiex_bssdescriptor *bss_desc, u32 cipher)
 {
-	u8 *oui = NULL;
-	struct ie_body *iebody = NULL;
+	u8 *oui;
+	struct ie_body *iebody;
 	u8 ret = MWIFIEX_OUI_NOT_PRESENT;
 
 	if (((bss_desc->bcn_rsn_ie) && ((*(bss_desc->bcn_rsn_ie)).
@@ -144,8 +144,8 @@ mwifiex_is_rsn_oui_present(struct mwifiex_bssdescriptor *bss_desc, u32 cipher)
 static u8
 mwifiex_is_wpa_oui_present(struct mwifiex_bssdescriptor *bss_desc, u32 cipher)
 {
-	u8 *oui = NULL;
-	struct ie_body *iebody = NULL;
+	u8 *oui;
+	struct ie_body *iebody;
 	u8 ret = MWIFIEX_OUI_NOT_PRESENT;
 
 	if (((bss_desc->bcn_wpa_ie) && ((*(bss_desc->bcn_wpa_ie)).
@@ -181,7 +181,7 @@ int mwifiex_find_best_bss(struct mwifiex_private *priv,
 			  struct mwifiex_ssid_bssid *ssid_bssid)
 {
 	struct mwifiex_ssid_bssid tmp_ssid_bssid;
-	u8 *mac = NULL;
+	u8 *mac;
 
 	if (!ssid_bssid)
 		return -1;
@@ -213,7 +213,7 @@ int mwifiex_find_best_bss(struct mwifiex_private *priv,
 int mwifiex_set_user_scan_ioctl(struct mwifiex_private *priv,
 				struct mwifiex_user_scan_cfg *scan_req)
 {
-	int status = 0;
+	int status;
 
 	priv->adapter->cmd_wait_q.condition = false;
 
@@ -2253,8 +2253,8 @@ int mwifiex_scan_networks(struct mwifiex_private *priv,
 {
 	int ret = 0;
 	struct mwifiex_adapter *adapter = priv->adapter;
-	struct cmd_ctrl_node *cmd_node = NULL;
-	union mwifiex_scan_cmd_config_tlv *scan_cfg_out = NULL;
+	struct cmd_ctrl_node *cmd_node;
+	union mwifiex_scan_cmd_config_tlv *scan_cfg_out;
 	struct mwifiex_ie_types_chan_list_param_set *chan_list_out;
 	u32 buf_size;
 	struct mwifiex_chan_scan_param_set *scan_chan_list;
@@ -2404,8 +2404,8 @@ int mwifiex_ret_802_11_scan(struct mwifiex_private *priv,
 {
 	int ret = 0;
 	struct mwifiex_adapter *adapter = priv->adapter;
-	struct cmd_ctrl_node *cmd_node = NULL;
-	struct host_cmd_ds_802_11_scan_rsp *scan_rsp = NULL;
+	struct cmd_ctrl_node *cmd_node;
+	struct host_cmd_ds_802_11_scan_rsp *scan_rsp;
 	struct mwifiex_bssdescriptor *bss_new_entry = NULL;
 	struct mwifiex_ie_types_data *tlv_data;
 	struct mwifiex_ie_types_tsf_timestamp *tsf_tlv;
@@ -2906,7 +2906,7 @@ static int mwifiex_scan_specific_ssid(struct mwifiex_private *priv,
 int mwifiex_request_scan(struct mwifiex_private *priv,
 			 struct mwifiex_802_11_ssid *req_ssid)
 {
-	int ret = 0;
+	int ret;
 
 	if (down_interruptible(&priv->async_sem)) {
 		dev_err(priv->adapter->dev, "%s: acquire semaphore\n",
diff --git a/drivers/net/wireless/mwifiex/sdio.c b/drivers/net/wireless/mwifiex/sdio.c
index 5148d0e..470dbaa 100644
--- a/drivers/net/wireless/mwifiex/sdio.c
+++ b/drivers/net/wireless/mwifiex/sdio.c
@@ -46,7 +46,7 @@ static struct semaphore add_remove_card_sem;
 static int
 mwifiex_sdio_probe(struct sdio_func *func, const struct sdio_device_id *id)
 {
-	int ret = 0;
+	int ret;
 	struct sdio_mmc_card *card = NULL;
 
 	pr_debug("info: vendor=0x%4.04X device=0x%4.04X class=%d function=%d\n",
@@ -119,7 +119,7 @@ static int mwifiex_sdio_suspend(struct device *dev)
 {
 	struct sdio_func *func = dev_to_sdio_func(dev);
 	struct sdio_mmc_card *card;
-	struct mwifiex_adapter *adapter = NULL;
+	struct mwifiex_adapter *adapter;
 	mmc_pm_flag_t pm_flag = 0;
 	int hs_actived = 0;
 	int i;
@@ -177,7 +177,7 @@ static int mwifiex_sdio_resume(struct device *dev)
 {
 	struct sdio_func *func = dev_to_sdio_func(dev);
 	struct sdio_mmc_card *card;
-	struct mwifiex_adapter *adapter = NULL;
+	struct mwifiex_adapter *adapter;
 	mmc_pm_flag_t pm_flag = 0;
 	int i;
 
@@ -420,7 +420,7 @@ static int mwifiex_write_data_to_card(struct mwifiex_adapter *adapter,
 				      u8 *payload, u32 pkt_len, u32 port)
 {
 	u32 i = 0;
-	int ret = 0;
+	int ret;
 
 	do {
 		ret = mwifiex_write_data_sync(adapter, payload, pkt_len, port);
@@ -531,7 +531,7 @@ static int
 mwifiex_sdio_poll_card_status(struct mwifiex_adapter *adapter, u8 bits)
 {
 	u32 tries;
-	u32 cs = 0;
+	u32 cs;
 
 	for (tries = 0; tries < MAX_POLL_TRIES; tries++) {
 		if (mwifiex_read_reg(adapter, CARD_STATUS_REG, &cs))
@@ -553,7 +553,7 @@ mwifiex_sdio_poll_card_status(struct mwifiex_adapter *adapter, u8 bits)
 static int
 mwifiex_sdio_read_fw_status(struct mwifiex_adapter *adapter, u16 *dat)
 {
-	u32 fws0 = 0, fws1 = 0;
+	u32 fws0, fws1;
 
 	if (mwifiex_read_reg(adapter, CARD_FW_STATUS0_REG, &fws0))
 		return -1;
@@ -574,7 +574,7 @@ mwifiex_sdio_read_fw_status(struct mwifiex_adapter *adapter, u16 *dat)
  */
 static int mwifiex_sdio_disable_host_int(struct mwifiex_adapter *adapter)
 {
-	u32 host_int_mask = 0;
+	u32 host_int_mask;
 
 	/* Read back the host_int_mask register */
 	if (mwifiex_read_reg(adapter, HOST_INT_MASK_REG, &host_int_mask))
@@ -614,7 +614,7 @@ static int mwifiex_sdio_card_to_host(struct mwifiex_adapter *adapter,
 				     u32 *type, u8 *buffer,
 				     u32 npayload, u32 ioport)
 {
-	int ret = 0;
+	int ret;
 	u32 nb;
 
 	if (!buffer) {
@@ -652,14 +652,14 @@ static int mwifiex_sdio_card_to_host(struct mwifiex_adapter *adapter,
 static int mwifiex_prog_fw_w_helper(struct mwifiex_adapter *adapter,
 				    struct mwifiex_fw_image *fw)
 {
-	int ret = 0;
+	int ret;
 	u8 *firmware = fw->fw_buf;
 	u32 firmware_len = fw->fw_len;
 	u32 offset = 0;
 	u32 base0, base1;
 	u8 *fwbuf;
 	u16 len = 0;
-	u32 txlen = 0, tx_blocks = 0, tries = 0;
+	u32 txlen, tx_blocks = 0, tries;
 	u32 i = 0;
 
 	if (!firmware_len) {
@@ -830,7 +830,7 @@ static int mwifiex_check_fw_status(struct mwifiex_adapter *adapter,
 static void mwifiex_interrupt_status(struct mwifiex_adapter *adapter)
 {
 	struct sdio_mmc_card *card = adapter->card;
-	u32 sdio_ireg = 0;
+	u32 sdio_ireg;
 	unsigned long flags;
 
 	if (mwifiex_read_data_sync(adapter, card->mp_regs, MAX_MP_REGS,
@@ -964,7 +964,7 @@ static int mwifiex_sdio_card_to_host_mp_aggr(struct mwifiex_adapter *adapter,
 	s32 f_do_rx_cur = 0;
 	s32 f_aggr_cur = 0;
 	struct sk_buff *skb_deaggr;
-	u32 pind = 0;
+	u32 pind;
 	u32 pkt_len, pkt_type = 0;
 	u8 *curr_ptr;
 	u32 rx_len = skb->len;
@@ -1114,7 +1114,7 @@ static int mwifiex_process_int_status(struct mwifiex_adapter *adapter)
 	struct sdio_mmc_card *card = adapter->card;
 	int ret = 0;
 	u8 sdio_ireg;
-	struct sk_buff *skb = NULL;
+	struct sk_buff *skb;
 	u8 port = CTRL_PORT;
 	u32 len_reg_l, len_reg_u;
 	u32 rx_blocks;
@@ -1377,7 +1377,7 @@ static int mwifiex_sdio_host_to_card(struct mwifiex_adapter *adapter,
 				     struct mwifiex_tx_param *tx_param)
 {
 	struct sdio_mmc_card *card = adapter->card;
-	int ret = 0;
+	int ret;
 	u32 buf_block_len;
 	u32 blk_size;
 	u8 port = CTRL_PORT;
@@ -1560,7 +1560,7 @@ static int mwifiex_init_sdio(struct mwifiex_adapter *adapter)
 {
 	struct sdio_mmc_card *card = adapter->card;
 	int ret;
-	u32 sdio_ireg = 0;
+	u32 sdio_ireg;
 
 	/*
 	 * Read the HOST_INT_STATUS_REG for ACK the first interrupt got
diff --git a/drivers/net/wireless/mwifiex/sta_cmd.c b/drivers/net/wireless/mwifiex/sta_cmd.c
index 33c8ba1..8af3a78 100644
--- a/drivers/net/wireless/mwifiex/sta_cmd.c
+++ b/drivers/net/wireless/mwifiex/sta_cmd.c
@@ -274,8 +274,8 @@ static int mwifiex_cmd_tx_rate_cfg(struct mwifiex_private *priv,
 static int mwifiex_cmd_tx_power_cfg(struct host_cmd_ds_command *cmd,
 				    u16 cmd_action, void *data_buf)
 {
-	struct mwifiex_types_power_group *pg_tlv = NULL;
-	struct host_cmd_ds_txpwr_cfg *txp = NULL;
+	struct mwifiex_types_power_group *pg_tlv;
+	struct host_cmd_ds_txpwr_cfg *txp;
 	struct host_cmd_ds_txpwr_cfg *cmd_txp_cfg = &cmd->params.txp_cfg;
 
 	cmd->command = cpu_to_le16(HostCmd_CMD_TXPWR_CFG);
@@ -478,7 +478,7 @@ mwifiex_set_keyparamset_wep(struct mwifiex_private *priv,
 			    struct mwifiex_ie_type_key_param_set *key_param_set,
 			    u16 *key_param_len)
 {
-	int cur_key_param_len = 0;
+	int cur_key_param_len;
 	u8 i;
 
 	/* Multi-key_param_set TLV is supported */
@@ -1121,7 +1121,7 @@ int mwifiex_sta_prepare_cmd(struct mwifiex_private *priv, uint16_t cmd_no,
  */
 int mwifiex_sta_init_cmd(struct mwifiex_private *priv, u8 first_sta)
 {
-	int ret = 0;
+	int ret;
 	u16 enable = true;
 	struct mwifiex_ds_11n_amsdu_aggr_ctrl amsdu_aggr_ctrl;
 	struct mwifiex_ds_auto_ds auto_ds;
diff --git a/drivers/net/wireless/mwifiex/sta_cmdresp.c b/drivers/net/wireless/mwifiex/sta_cmdresp.c
index 7f4f10b..d08f764 100644
--- a/drivers/net/wireless/mwifiex/sta_cmdresp.c
+++ b/drivers/net/wireless/mwifiex/sta_cmdresp.c
@@ -43,7 +43,7 @@ static void
 mwifiex_process_cmdresp_error(struct mwifiex_private *priv,
 			      struct host_cmd_ds_command *resp)
 {
-	struct cmd_ctrl_node *cmd_node = NULL, *tmp_node = NULL;
+	struct cmd_ctrl_node *cmd_node = NULL, *tmp_node;
 	struct mwifiex_adapter *adapter = priv->adapter;
 	struct host_cmd_ds_802_11_ps_mode_enh *pm;
 	unsigned long flags;
@@ -124,7 +124,7 @@ static int mwifiex_ret_802_11_rssi_info(struct mwifiex_private *priv,
 {
 	struct host_cmd_ds_802_11_rssi_info_rsp *rssi_info_rsp =
 		&resp->params.rssi_info_rsp;
-	struct mwifiex_ds_get_signal *signal = NULL;
+	struct mwifiex_ds_get_signal *signal;
 
 	priv->data_rssi_last = le16_to_cpu(rssi_info_rsp->data_rssi_last);
 	priv->data_nf_last = le16_to_cpu(rssi_info_rsp->data_nf_last);
@@ -232,7 +232,7 @@ static int mwifiex_ret_get_log(struct mwifiex_private *priv,
 {
 	struct host_cmd_ds_802_11_get_log *get_log =
 		(struct host_cmd_ds_802_11_get_log *) &resp->params.get_log;
-	struct mwifiex_ds_get_stats *stats = NULL;
+	struct mwifiex_ds_get_stats *stats;
 
 	if (data_buf) {
 		stats = (struct mwifiex_ds_get_stats *) data_buf;
@@ -280,10 +280,10 @@ static int mwifiex_ret_tx_rate_cfg(struct mwifiex_private *priv,
 				   struct host_cmd_ds_command *resp,
 				   void *data_buf)
 {
-	struct mwifiex_rate_cfg *ds_rate = NULL;
+	struct mwifiex_rate_cfg *ds_rate;
 	struct host_cmd_ds_tx_rate_cfg *rate_cfg = &resp->params.tx_rate_cfg;
 	struct mwifiex_rate_scope *rate_scope;
-	struct mwifiex_ie_types_header *head = NULL;
+	struct mwifiex_ie_types_header *head;
 	u16 tlv, tlv_buf_len;
 	u8 *tlv_buf;
 	u32 i;
@@ -368,9 +368,9 @@ static int mwifiex_ret_tx_rate_cfg(struct mwifiex_private *priv,
  */
 static int mwifiex_get_power_level(struct mwifiex_private *priv, void *data_buf)
 {
-	int length = -1, max_power = -1, min_power = -1;
-	struct mwifiex_types_power_group *pg_tlv_hdr = NULL;
-	struct mwifiex_power_group *pg = NULL;
+	int length, max_power = -1, min_power = -1;
+	struct mwifiex_types_power_group *pg_tlv_hdr;
+	struct mwifiex_power_group *pg;
 
 	if (data_buf) {
 		pg_tlv_hdr =
@@ -418,8 +418,8 @@ static int mwifiex_ret_tx_power_cfg(struct mwifiex_private *priv,
 {
 	struct mwifiex_adapter *adapter = priv->adapter;
 	struct host_cmd_ds_txpwr_cfg *txp_cfg = &resp->params.txp_cfg;
-	struct mwifiex_types_power_group *pg_tlv_hdr = NULL;
-	struct mwifiex_power_group *pg = NULL;
+	struct mwifiex_types_power_group *pg_tlv_hdr;
+	struct mwifiex_power_group *pg;
 	u16 action = le16_to_cpu(txp_cfg->action);
 
 	switch (action) {
@@ -593,7 +593,7 @@ static int mwifiex_ret_802_11d_domain_info(struct mwifiex_private *priv,
 		&resp->params.domain_info_resp;
 	struct mwifiex_ietypes_domain_param_set *domain = &domain_info->domain;
 	u16 action = le16_to_cpu(domain_info->action);
-	u8 no_of_triplet = 0;
+	u8 no_of_triplet;
 
 	no_of_triplet = (u8) ((le16_to_cpu(domain->header.len) -
 					IEEE80211_COUNTRY_STRING_LEN) /
@@ -661,7 +661,7 @@ static int mwifiex_ret_ver_ext(struct mwifiex_private *priv,
 			       void *data_buf)
 {
 	struct host_cmd_ds_version_ext *ver_ext = &resp->params.verext;
-	struct host_cmd_ds_version_ext *version_ext = NULL;
+	struct host_cmd_ds_version_ext *version_ext;
 
 	if (data_buf) {
 		version_ext = (struct host_cmd_ds_version_ext *)data_buf;
@@ -682,8 +682,8 @@ static int mwifiex_ret_ver_ext(struct mwifiex_private *priv,
 static int mwifiex_ret_reg_access(u16 type, struct host_cmd_ds_command *resp,
 				  void *data_buf)
 {
-	struct mwifiex_ds_reg_rw *reg_rw = NULL;
-	struct mwifiex_ds_read_eeprom *eeprom = NULL;
+	struct mwifiex_ds_reg_rw *reg_rw;
+	struct mwifiex_ds_read_eeprom *eeprom;
 
 	if (data_buf) {
 		reg_rw = (struct mwifiex_ds_reg_rw *) data_buf;
diff --git a/drivers/net/wireless/mwifiex/sta_ioctl.c b/drivers/net/wireless/mwifiex/sta_ioctl.c
index e7adaab..4585c1b 100644
--- a/drivers/net/wireless/mwifiex/sta_ioctl.c
+++ b/drivers/net/wireless/mwifiex/sta_ioctl.c
@@ -149,7 +149,7 @@ int mwifiex_request_set_multicast_list(struct mwifiex_private *priv,
 int mwifiex_bss_start(struct mwifiex_private *priv,
 		      struct mwifiex_ssid_bssid *ssid_bssid)
 {
-	int ret = 0;
+	int ret;
 	struct mwifiex_adapter *adapter = priv->adapter;
 	s32 i = -1;
 
@@ -376,7 +376,7 @@ int mwifiex_get_bss_info(struct mwifiex_private *priv,
 {
 	struct mwifiex_adapter *adapter = priv->adapter;
 	struct mwifiex_bssdescriptor *bss_desc;
-	s32 tbl_idx = 0;
+	s32 tbl_idx;
 
 	if (!info)
 		return -1;
@@ -436,9 +436,8 @@ int mwifiex_set_radio_band_cfg(struct mwifiex_private *priv,
 			       struct mwifiex_ds_band_cfg *radio_cfg)
 {
 	struct mwifiex_adapter *adapter = priv->adapter;
-	u8 infra_band = 0;
-	u8 adhoc_band = 0;
-	u32 adhoc_channel = 0;
+	u8 infra_band, adhoc_band;
+	u32 adhoc_channel;
 
 	infra_band = (u8) radio_cfg->config_bands;
 	adhoc_band = (u8) radio_cfg->adhoc_start_band;
@@ -636,7 +635,7 @@ int mwifiex_bss_ioctl_find_bss(struct mwifiex_private *priv,
 int
 mwifiex_drv_change_adhoc_chan(struct mwifiex_private *priv, int channel)
 {
-	int ret = 0;
+	int ret;
 	struct mwifiex_bss_info bss_info;
 	struct mwifiex_ssid_bssid ssid_bssid;
 	u16 curr_chan = 0;
@@ -755,11 +754,10 @@ static int mwifiex_rate_ioctl_set_rate_value(struct mwifiex_private *priv,
 					     struct mwifiex_rate_cfg *rate_cfg)
 {
 	u8 rates[MWIFIEX_SUPPORTED_RATES];
-	u8 *rate = NULL;
-	int rate_index = 0;
+	u8 *rate;
+	int rate_index, ret;
 	u16 bitmap_rates[MAX_BITMAP_RATES_SIZE];
-	u32 i = 0;
-	int ret = 0;
+	u32 i;
 	struct mwifiex_adapter *adapter = priv->adapter;
 
 	if (rate_cfg->is_rate_auto) {
@@ -819,7 +817,7 @@ static int mwifiex_rate_ioctl_set_rate_value(struct mwifiex_private *priv,
 static int mwifiex_rate_ioctl_cfg(struct mwifiex_private *priv,
 				  struct mwifiex_rate_cfg *rate_cfg)
 {
-	int status = 0;
+	int status;
 
 	if (!rate_cfg)
 		return -1;
@@ -841,7 +839,7 @@ static int mwifiex_rate_ioctl_cfg(struct mwifiex_private *priv,
 int mwifiex_drv_get_data_rate(struct mwifiex_private *priv,
 			      struct mwifiex_rate_cfg *rate)
 {
-	int ret = 0;
+	int ret;
 
 	memset(rate, 0, sizeof(struct mwifiex_rate_cfg));
 	rate->action = HostCmd_ACT_GEN_GET;
@@ -875,11 +873,11 @@ int mwifiex_drv_get_data_rate(struct mwifiex_private *priv,
 int mwifiex_set_tx_power(struct mwifiex_private *priv,
 			 struct mwifiex_power_cfg *power_cfg)
 {
-	int ret = 0;
-	struct host_cmd_ds_txpwr_cfg *txp_cfg = NULL;
-	struct mwifiex_types_power_group *pg_tlv = NULL;
-	struct mwifiex_power_group *pg = NULL;
-	u8 *buf = NULL;
+	int ret;
+	struct host_cmd_ds_txpwr_cfg *txp_cfg;
+	struct mwifiex_types_power_group *pg_tlv;
+	struct mwifiex_power_group *pg;
+	u8 *buf;
 	u16 dbm = 0;
 
 	if (!power_cfg->is_power_auto) {
@@ -960,7 +958,7 @@ int mwifiex_set_tx_power(struct mwifiex_private *priv,
  */
 int mwifiex_drv_set_power(struct mwifiex_private *priv, u32 *ps_mode)
 {
-	int ret = 0;
+	int ret;
 	struct mwifiex_adapter *adapter = priv->adapter;
 	u16 sub_cmd;
 
@@ -1078,8 +1076,8 @@ static int mwifiex_sec_ioctl_set_wapi_key(struct mwifiex_private *priv,
 static int mwifiex_sec_ioctl_set_wep_key(struct mwifiex_private *priv,
 			      struct mwifiex_ds_encrypt_key *encrypt_key)
 {
-	int ret = 0;
-	struct mwifiex_wep_key *wep_key = NULL;
+	int ret;
+	struct mwifiex_wep_key *wep_key;
 	int index;
 
 	if (priv->wep_key_curr_index >= NUM_WEP_KEYS)
@@ -1142,7 +1140,7 @@ static int mwifiex_sec_ioctl_set_wep_key(struct mwifiex_private *priv,
 static int mwifiex_sec_ioctl_set_wpa_key(struct mwifiex_private *priv,
 			      struct mwifiex_ds_encrypt_key *encrypt_key)
 {
-	int ret = 0;
+	int ret;
 	u8 remove_key = false;
 	struct host_cmd_ds_802_11_key_material *ibss_key;
 
@@ -1209,7 +1207,7 @@ static int
 mwifiex_sec_ioctl_encrypt_key(struct mwifiex_private *priv,
 			      struct mwifiex_ds_encrypt_key *encrypt_key)
 {
-	int status = 0;
+	int status;
 
 	if (encrypt_key->is_wapi_key)
 		status = mwifiex_sec_ioctl_set_wapi_key(priv, encrypt_key);
@@ -1253,7 +1251,7 @@ int mwifiex_get_signal_info(struct mwifiex_private *priv,
 			    struct mwifiex_ds_get_signal *signal)
 {
 	struct mwifiex_ds_get_signal info;
-	int status = 0;
+	int status;
 
 	memset(&info, 0, sizeof(struct mwifiex_ds_get_signal));
 	info.selector = ALL_RSSI_INFO_MASK;
@@ -1334,7 +1332,7 @@ int
 mwifiex_get_stats_info(struct mwifiex_private *priv,
 		       struct mwifiex_ds_get_stats *log)
 {
-	int ret = 0;
+	int ret;
 	struct mwifiex_ds_get_stats get_log;
 
 	memset(&get_log, 0, sizeof(struct mwifiex_ds_get_stats));
@@ -1425,7 +1423,7 @@ int
 mwifiex_reg_read(struct mwifiex_private *priv, u32 reg_type,
 		 u32 reg_offset, u32 *value)
 {
-	int ret = 0;
+	int ret;
 	struct mwifiex_ds_reg_rw reg_rw;
 
 	reg_rw.type = cpu_to_le32(reg_type);
@@ -1451,7 +1449,7 @@ int
 mwifiex_eeprom_read(struct mwifiex_private *priv, u16 offset, u16 bytes,
 		    u8 *value)
 {
-	int ret = 0;
+	int ret;
 	struct mwifiex_ds_read_eeprom rd_eeprom;
 
 	rd_eeprom.offset = cpu_to_le16((u16) offset);
diff --git a/drivers/net/wireless/mwifiex/sta_rx.c b/drivers/net/wireless/mwifiex/sta_rx.c
index 8282679..e047f0d 100644
--- a/drivers/net/wireless/mwifiex/sta_rx.c
+++ b/drivers/net/wireless/mwifiex/sta_rx.c
@@ -41,7 +41,7 @@
 int mwifiex_process_rx_packet(struct mwifiex_adapter *adapter,
 			      struct sk_buff *skb)
 {
-	int ret = 0;
+	int ret;
 	struct mwifiex_rxinfo *rx_info = MWIFIEX_SKB_RXCB(skb);
 	struct mwifiex_private *priv = adapter->priv[rx_info->bss_index];
 	struct rx_packet_hdr *rx_pkt_hdr;
@@ -123,7 +123,7 @@ int mwifiex_process_sta_rx_packet(struct mwifiex_adapter *adapter,
 	struct mwifiex_rxinfo *rx_info = MWIFIEX_SKB_RXCB(skb);
 	struct rx_packet_hdr *rx_pkt_hdr;
 	u8 ta[ETH_ALEN];
-	u16 rx_pkt_type = 0;
+	u16 rx_pkt_type;
 	struct mwifiex_private *priv = adapter->priv[rx_info->bss_index];
 
 	local_rx_pd = (struct rxpd *) (skb->data);
diff --git a/drivers/net/wireless/mwifiex/sta_tx.c b/drivers/net/wireless/mwifiex/sta_tx.c
index 5d37ef1..fa6221b 100644
--- a/drivers/net/wireless/mwifiex/sta_tx.c
+++ b/drivers/net/wireless/mwifiex/sta_tx.c
@@ -113,8 +113,8 @@ int mwifiex_send_null_packet(struct mwifiex_private *priv, u8 flags)
 /* sizeof(struct txpd) + Interface specific header */
 #define NULL_PACKET_HDR 64
 	u32 data_len = NULL_PACKET_HDR;
-	struct sk_buff *skb = NULL;
-	int ret = 0;
+	struct sk_buff *skb;
+	int ret;
 	struct mwifiex_txinfo *tx_info = NULL;
 
 	if (adapter->surprise_removed)
diff --git a/drivers/net/wireless/mwifiex/txrx.c b/drivers/net/wireless/mwifiex/txrx.c
index ce772e0..2101208 100644
--- a/drivers/net/wireless/mwifiex/txrx.c
+++ b/drivers/net/wireless/mwifiex/txrx.c
@@ -68,7 +68,7 @@ int mwifiex_process_tx(struct mwifiex_private *priv, struct sk_buff *skb,
 {
 	int ret = -1;
 	struct mwifiex_adapter *adapter = priv->adapter;
-	u8 *head_ptr = NULL;
+	u8 *head_ptr;
 	struct txpd *local_tx_pd = NULL;
 
 	head_ptr = (u8 *) mwifiex_process_sta_txpd(priv, skb);
@@ -121,8 +121,8 @@ int mwifiex_process_tx(struct mwifiex_private *priv, struct sk_buff *skb,
 int mwifiex_write_data_complete(struct mwifiex_adapter *adapter,
 				struct sk_buff *skb, int status)
 {
-	struct mwifiex_private *priv = NULL, *tpriv = NULL;
-	struct mwifiex_txinfo *tx_info = NULL;
+	struct mwifiex_private *priv, *tpriv;
+	struct mwifiex_txinfo *tx_info;
 	int i;
 
 	if (!skb)
@@ -169,9 +169,9 @@ int mwifiex_recv_packet_complete(struct mwifiex_adapter *adapter,
 				 struct sk_buff *skb, int status)
 {
 	struct mwifiex_rxinfo *rx_info = MWIFIEX_SKB_RXCB(skb);
-	struct mwifiex_rxinfo *rx_info_parent = NULL;
+	struct mwifiex_rxinfo *rx_info_parent;
 	struct mwifiex_private *priv;
-	struct sk_buff *skb_parent = NULL;
+	struct sk_buff *skb_parent;
 	unsigned long flags;
 
 	priv = adapter->priv[rx_info->bss_index];
diff --git a/drivers/net/wireless/mwifiex/util.c b/drivers/net/wireless/mwifiex/util.c
index 7ab4fb2..a8d53aa 100644
--- a/drivers/net/wireless/mwifiex/util.c
+++ b/drivers/net/wireless/mwifiex/util.c
@@ -152,8 +152,8 @@ int mwifiex_get_debug_info(struct mwifiex_private *priv,
  */
 int mwifiex_recv_packet(struct mwifiex_adapter *adapter, struct sk_buff *skb)
 {
-	struct mwifiex_rxinfo *rx_info = NULL;
-	struct mwifiex_private *priv = NULL;
+	struct mwifiex_rxinfo *rx_info;
+	struct mwifiex_private *priv;
 
 	if (!skb)
 		return -1;
@@ -184,8 +184,8 @@ int mwifiex_recv_packet(struct mwifiex_adapter *adapter, struct sk_buff *skb)
 int mwifiex_recv_complete(struct mwifiex_adapter *adapter,
 			  struct sk_buff *skb, int status)
 {
-	struct mwifiex_private *priv = NULL;
-	struct mwifiex_rxinfo *rx_info = NULL;
+	struct mwifiex_private *priv;
+	struct mwifiex_rxinfo *rx_info;
 
 	if (!skb)
 		return 0;
diff --git a/drivers/net/wireless/mwifiex/wmm.c b/drivers/net/wireless/mwifiex/wmm.c
index c009370..faa09e3 100644
--- a/drivers/net/wireless/mwifiex/wmm.c
+++ b/drivers/net/wireless/mwifiex/wmm.c
@@ -799,7 +799,7 @@ u8
 mwifiex_wmm_compute_drv_pkt_delay(struct mwifiex_private *priv,
 					const struct sk_buff *skb)
 {
-	u8 ret_val = 0;
+	u8 ret_val;
 	struct timeval out_tstamp, in_tstamp;
 	u32 queue_delay;
 
-- 
1.7.0.2

