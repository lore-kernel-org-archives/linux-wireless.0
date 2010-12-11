Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from dakia2.marvell.com ([65.219.4.35]:45259 "EHLO
	dakia2.marvell.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753199Ab0LKDBd (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 10 Dec 2010 22:01:33 -0500
From: Bing Zhao <bzhao@marvell.com>
To: linux-wireless@vger.kernel.org
Cc: "John W. Linville" <linville@tuxdriver.com>,
	Johannes Berg <johannes@sipsolutions.net>,
	Amitkumar Karwar <akarwar@marvell.com>,
	Kiran Divekar <dkiran@marvell.com>,
	Frank Huang <frankh@marvell.com>, Bing Zhao <bzhao@marvell.com>
Subject: [PATCH] mwifiex: change incorrect GFP_ATOMIC memory allocation
Date: Fri, 10 Dec 2010 19:01:31 -0800
Message-Id: <1292036491-12821-1-git-send-email-bzhao@marvell.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Kiran Divekar <dkiran@marvell.com>

flag to GFP_KERNEL. Use GFP_ATOMIC only in atomic contexts like
interrrupt handlers, BH and in process context with spin lock
already held.

Signed-off-by: Kiran Divekar <dkiran@marvell.com>
---
 drivers/net/wireless/mwifiex/11n_rxreorder.c |    4 ++--
 drivers/net/wireless/mwifiex/cmdevt.c        |    2 +-
 drivers/net/wireless/mwifiex/init.c          |    4 ++--
 drivers/net/wireless/mwifiex/join.c          |    2 +-
 drivers/net/wireless/mwifiex/main.c          |    4 ++--
 drivers/net/wireless/mwifiex/scan.c          |   10 +++++-----
 drivers/net/wireless/mwifiex/sdio.c          |    8 ++++----
 drivers/net/wireless/mwifiex/sta_ioctl.c     |    2 +-
 drivers/net/wireless/mwifiex/util.c          |    8 ++++----
 9 files changed, 22 insertions(+), 22 deletions(-)

diff --git a/drivers/net/wireless/mwifiex/11n_rxreorder.c b/drivers/net/wireless/mwifiex/11n_rxreorder.c
index 06bf96f..c7b9d2d 100644
--- a/drivers/net/wireless/mwifiex/11n_rxreorder.c
+++ b/drivers/net/wireless/mwifiex/11n_rxreorder.c
@@ -319,7 +319,7 @@ mwifiex_11n_create_rx_reorder_tbl(struct mwifiex_private *priv, u8 *ta,
 		       ta[4], ta[5], win_size);
 
 		new_node = kzalloc(sizeof(struct mwifiex_rx_reorder_tbl),
-						GFP_ATOMIC);
+						GFP_KERNEL);
 		if (!new_node) {
 			PRINTM(MERROR, "%s: failed to alloc new_node\n",
 			       __func__);
@@ -346,7 +346,7 @@ mwifiex_11n_create_rx_reorder_tbl(struct mwifiex_private *priv, u8 *ta,
 		new_node->win_size = win_size;
 
 		new_node->rx_reorder_ptr = kzalloc(sizeof(void *) * win_size,
-						GFP_ATOMIC);
+						GFP_KERNEL);
 		if (!new_node->rx_reorder_ptr) {
 			kfree((u8 *) new_node);
 			PRINTM(MERROR, "%s: failed to alloc reorder_ptr\n",
diff --git a/drivers/net/wireless/mwifiex/cmdevt.c b/drivers/net/wireless/mwifiex/cmdevt.c
index 6f22f5a..509eab0 100644
--- a/drivers/net/wireless/mwifiex/cmdevt.c
+++ b/drivers/net/wireless/mwifiex/cmdevt.c
@@ -461,7 +461,7 @@ mwifiex_alloc_cmd_buffer(struct mwifiex_adapter *adapter)
 
 	/* Allocate and initialize struct cmd_ctrl_node */
 	buf_size = sizeof(struct cmd_ctrl_node) * MWIFIEX_NUM_OF_CMD_BUFFER;
-	cmd_array = kzalloc(buf_size, GFP_ATOMIC);
+	cmd_array = kzalloc(buf_size, GFP_KERNEL);
 	if (!cmd_array) {
 		PRINTM(MERROR, "%s: failed to alloc cmd_array\n", __func__);
 		ret = MWIFIEX_STATUS_FAILURE;
diff --git a/drivers/net/wireless/mwifiex/init.c b/drivers/net/wireless/mwifiex/init.c
index 664959a..d0a2556 100644
--- a/drivers/net/wireless/mwifiex/init.c
+++ b/drivers/net/wireless/mwifiex/init.c
@@ -41,7 +41,7 @@ mwifiex_add_bss_prio_tbl(struct mwifiex_private *priv)
 
 	ENTER();
 
-	bss_prio = kzalloc(sizeof(struct mwifiex_bss_prio_node), GFP_ATOMIC);
+	bss_prio = kzalloc(sizeof(struct mwifiex_bss_prio_node), GFP_KERNEL);
 	if (!bss_prio) {
 		PRINTM(MERROR, "%s: failed to alloc bss_prio\n", __func__);
 		status = MWIFIEX_STATUS_FAILURE;
@@ -178,7 +178,7 @@ mwifiex_allocate_adapter(struct mwifiex_adapter *adapter)
 
 	/* Allocate buffer to store the BSSID list */
 	buf_size = sizeof(struct mwifiex_bssdescriptor) * IW_MAX_AP;
-	temp_scan_table = kzalloc(buf_size, GFP_ATOMIC);
+	temp_scan_table = kzalloc(buf_size, GFP_KERNEL);
 	if (!temp_scan_table) {
 		PRINTM(MERROR, "%s: failed to alloc temp_scan_table\n",
 		       __func__);
diff --git a/drivers/net/wireless/mwifiex/join.c b/drivers/net/wireless/mwifiex/join.c
index 264cb01..9ac0c2f 100644
--- a/drivers/net/wireless/mwifiex/join.c
+++ b/drivers/net/wireless/mwifiex/join.c
@@ -149,7 +149,7 @@ mwifiex_get_common_rates(struct mwifiex_private *priv,
 
 	ENTER();
 
-	tmp = kmalloc(rate1_size, GFP_ATOMIC);
+	tmp = kmalloc(rate1_size, GFP_KERNEL);
 	if (!tmp) {
 		PRINTM(MERROR, "%s: failed to alloc tmp\n", __func__);
 		ret = MWIFIEX_STATUS_FAILURE;
diff --git a/drivers/net/wireless/mwifiex/main.c b/drivers/net/wireless/mwifiex/main.c
index 7e8973f..00e5eab 100644
--- a/drivers/net/wireless/mwifiex/main.c
+++ b/drivers/net/wireless/mwifiex/main.c
@@ -78,7 +78,7 @@ mwifiex_register(void *card,
 
 	ENTER();
 
-	adapter = kzalloc(sizeof(struct mwifiex_adapter), GFP_ATOMIC);
+	adapter = kzalloc(sizeof(struct mwifiex_adapter), GFP_KERNEL);
 	/* Allocate memory for adapter structure */
 	if (!adapter) {
 		ret = MWIFIEX_STATUS_FAILURE;
@@ -106,7 +106,7 @@ mwifiex_register(void *card,
 			   allocate memory for private structure */
 			adapter->priv[i] =
 				kzalloc(sizeof(struct mwifiex_private),
-					GFP_ATOMIC);
+					GFP_KERNEL);
 			if (!adapter->priv[i]) {
 				PRINTM(MERROR,
 				       "%s: failed to allocate priv[]\n",
diff --git a/drivers/net/wireless/mwifiex/scan.c b/drivers/net/wireless/mwifiex/scan.c
index f496045..fc63922 100644
--- a/drivers/net/wireless/mwifiex/scan.c
+++ b/drivers/net/wireless/mwifiex/scan.c
@@ -2540,7 +2540,7 @@ mwifiex_scan_networks(struct mwifiex_private *priv,
 	ENTER();
 
 	scan_cfg_out = kzalloc(sizeof(union mwifiex_scan_cmd_config_tlv),
-					GFP_ATOMIC);
+					GFP_KERNEL);
 	if (!scan_cfg_out) {
 		PRINTM(MERROR, "%s: failed to alloc scan_cfg_out\n", __func__);
 		LEAVE();
@@ -2550,7 +2550,7 @@ mwifiex_scan_networks(struct mwifiex_private *priv,
 	buf_size =
 		sizeof(struct mwifiex_chan_scan_param_set) *
 		MWIFIEX_USER_SCAN_CHAN_MAX;
-	scan_chan_list = kzalloc(buf_size, GFP_ATOMIC);
+	scan_chan_list = kzalloc(buf_size, GFP_KERNEL);
 	if (!scan_chan_list) {
 		PRINTM(MERROR, "%s: failed to alloc scan_cfg_out\n", __func__);
 		kfree(scan_cfg_out);
@@ -2765,7 +2765,7 @@ mwifiex_ret_802_11_scan(struct mwifiex_private *priv,
 	 *  or as an addition at the end of the table
 	 */
 	bss_new_entry = kzalloc(sizeof(struct mwifiex_bssdescriptor),
-				GFP_ATOMIC);
+				GFP_KERNEL);
 	if (!bss_new_entry) {
 		PRINTM(MERROR, "%s: failed to alloc bss_new_entry\n", __func__);
 		ret = MWIFIEX_STATUS_FAILURE;
@@ -3223,7 +3223,7 @@ mwifiex_scan_specific_ssid(struct mwifiex_private *priv,
 
 	mwifiex_scan_delete_ssid_table_entry(priv, req_ssid);
 
-	scan_cfg = kzalloc(sizeof(struct mwifiex_user_scan_cfg), GFP_ATOMIC);
+	scan_cfg = kzalloc(sizeof(struct mwifiex_user_scan_cfg), GFP_KERNEL);
 	if (!scan_cfg) {
 		PRINTM(MERROR, "%s: failed to alloc scan_cfg\n", __func__);
 		ret = MWIFIEX_STATUS_FAILURE;
@@ -3326,7 +3326,7 @@ mwifiex_save_curr_bcn(struct mwifiex_private *priv)
 			return;
 
 		priv->curr_bcn_buf = kzalloc(curr_bss->beacon_buf_size,
-						GFP_ATOMIC);
+						GFP_KERNEL);
 		if (!priv->curr_bcn_buf)
 			PRINTM(MERROR, "%s: failed to alloc curr_bcn_buf\n",
 			       __func__);
diff --git a/drivers/net/wireless/mwifiex/sdio.c b/drivers/net/wireless/mwifiex/sdio.c
index 132347d..c06e662 100644
--- a/drivers/net/wireless/mwifiex/sdio.c
+++ b/drivers/net/wireless/mwifiex/sdio.c
@@ -764,7 +764,7 @@ mwifiex_prog_fw_w_helper(struct mwifiex_adapter *adapter,
 	PRINTM(MINFO, "Downloading FW image (%d bytes)\n", firmware_len);
 
 	/* Assume that the allocated buffer is 8-byte aligned */
-	fwbuf = kzalloc(MWIFIEX_UPLD_SIZE, GFP_ATOMIC);
+	fwbuf = kzalloc(MWIFIEX_UPLD_SIZE, GFP_KERNEL);
 	if (!fwbuf) {
 		PRINTM(MERROR,
 		       "Unable to allocate buffer for firmware. Terminating "
@@ -1680,7 +1680,7 @@ mwifiex_alloc_sdio_mpa_buffers(struct mwifiex_adapter *adapter,
 
 	ENTER();
 
-	card->mpa_tx.buf = kzalloc(mpa_tx_buf_size, GFP_ATOMIC);
+	card->mpa_tx.buf = kzalloc(mpa_tx_buf_size, GFP_KERNEL);
 	if (!card->mpa_tx.buf) {
 		PRINTM(MERROR,
 		       "Could not allocate buffer for SDIO MP TX aggr\n");
@@ -1690,7 +1690,7 @@ mwifiex_alloc_sdio_mpa_buffers(struct mwifiex_adapter *adapter,
 
 	card->mpa_tx.buf_size = mpa_tx_buf_size;
 
-	card->mpa_rx.buf = kzalloc(mpa_rx_buf_size, GFP_ATOMIC);
+	card->mpa_rx.buf = kzalloc(mpa_rx_buf_size, GFP_KERNEL);
 	if (!card->mpa_rx.buf) {
 		PRINTM(MERROR,
 		       "Could not allocate buffer for SDIO MP RX aggr\n");
@@ -1852,7 +1852,7 @@ mwifiex_init_sdio(struct mwifiex_adapter *adapter)
 	card->mpa_rx.pkt_aggr_limit = SDIO_MP_AGGR_DEF_PKT_LIMIT;
 
 	/* Allocate buffers for SDIO MP-A */
-	card->mp_regs = kzalloc(MAX_MP_REGS, GFP_ATOMIC);
+	card->mp_regs = kzalloc(MAX_MP_REGS, GFP_KERNEL);
 	if (!card->mp_regs) {
 		PRINTM(MERROR, "%s: failed to allocate mp_regs\n", __func__);
 		ret = MWIFIEX_STATUS_FAILURE;
diff --git a/drivers/net/wireless/mwifiex/sta_ioctl.c b/drivers/net/wireless/mwifiex/sta_ioctl.c
index cad23c3..4a13ccc 100644
--- a/drivers/net/wireless/mwifiex/sta_ioctl.c
+++ b/drivers/net/wireless/mwifiex/sta_ioctl.c
@@ -2622,7 +2622,7 @@ mwifiex_power_ioctl_set_power(struct mwifiex_adapter *adapter,
 			goto exit;
 		}
 	}
-	buf = kzalloc(MWIFIEX_SIZE_OF_CMD_BUFFER, GFP_ATOMIC);
+	buf = kzalloc(MWIFIEX_SIZE_OF_CMD_BUFFER, GFP_KERNEL);
 	if (!buf) {
 		PRINTM(MERROR, "%s: failed to alloc cmd buffer\n", __func__);
 		ret = MWIFIEX_STATUS_FAILURE;
diff --git a/drivers/net/wireless/mwifiex/util.c b/drivers/net/wireless/mwifiex/util.c
index d28f5a9..e442efc 100644
--- a/drivers/net/wireless/mwifiex/util.c
+++ b/drivers/net/wireless/mwifiex/util.c
@@ -70,7 +70,7 @@ mwifiex_init_lock(void **lock)
 {
 	struct mwifiex_lock *mlock = NULL;
 
-	mlock = kmalloc(sizeof(struct mwifiex_lock), GFP_ATOMIC);
+	mlock = kmalloc(sizeof(struct mwifiex_lock), GFP_KERNEL);
 	if (!mlock)
 		return MWIFIEX_STATUS_FAILURE;
 
@@ -277,7 +277,7 @@ mwifiex_init_timer(void **timer,
 	struct mwifiex_drv_timer *drv_timer = NULL;
 
 	drv_timer = (struct mwifiex_drv_timer *)
-		kmalloc(sizeof(struct mwifiex_drv_timer), GFP_ATOMIC);
+		kmalloc(sizeof(struct mwifiex_drv_timer), GFP_KERNEL);
 	if (!drv_timer) {
 		LEAVE();
 		return MWIFIEX_STATUS_FAILURE;
@@ -613,7 +613,7 @@ mwifiex_alloc_buffer(u32 data_len)
 
 	ENTER();
 
-	mbuf = kzalloc(buf_size, GFP_ATOMIC);
+	mbuf = kzalloc(buf_size, GFP_KERNEL);
 	if (!mbuf) {
 		PRINTM(MERROR, "%s: failed to alloc struct mwifiex_buffer\n",
 		       __func__);
@@ -1135,7 +1135,7 @@ mwifiex_alloc_buffer_skb(int size)
 
 	ENTER();
 
-	mbuf = kzalloc(sizeof(struct mwifiex_buffer), GFP_ATOMIC);
+	mbuf = kzalloc(sizeof(struct mwifiex_buffer), GFP_KERNEL);
 	if (!mbuf) {
 		PRINTM(MERROR, "%s: failed to alloc struct mwifiex_buffer",
 		       __func__);
-- 
1.7.0.2

