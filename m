Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from dakia2.marvell.com ([65.219.4.35]:59746 "EHLO
	dakia2.marvell.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932682Ab0LTT0o (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 20 Dec 2010 14:26:44 -0500
From: Bing Zhao <bzhao@marvell.com>
To: linux-wireless@vger.kernel.org
Cc: "John W. Linville" <linville@tuxdriver.com>,
	Johannes Berg <johannes@sipsolutions.net>,
	Amitkumar Karwar <akarwar@marvell.com>,
	Kiran Divekar <dkiran@marvell.com>,
	Frank Huang <frankh@marvell.com>, Bing Zhao <bzhao@marvell.com>
Subject: [PATCH 2/3] mwifiex: remove set operation for debugfs command 'debug'
Date: Mon, 20 Dec 2010 11:26:46 -0800
Message-Id: <1292873207-9318-2-git-send-email-bzhao@marvell.com>
In-Reply-To: <1292873207-9318-1-git-send-email-bzhao@marvell.com>
References: <1292873207-9318-1-git-send-email-bzhao@marvell.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Amitkumar Karwar <akarwar@marvell.com>

Debugfs command 'debug' gives useful information for debugging
purpose. Since there is no use case of set operation for this
command, the support is removed.

Signed-off-by: Amitkumar Karwar <akarwar@marvell.com>
---
 drivers/net/wireless/mwifiex/debugfs.c   |   98 +-----------------------------
 drivers/net/wireless/mwifiex/main.h      |    4 -
 drivers/net/wireless/mwifiex/sta_ioctl.c |   44 -------------
 drivers/net/wireless/mwifiex/util.c      |   73 +----------------------
 4 files changed, 2 insertions(+), 217 deletions(-)

diff --git a/drivers/net/wireless/mwifiex/debugfs.c b/drivers/net/wireless/mwifiex/debugfs.c
index 2b642f1..597cb26 100644
--- a/drivers/net/wireless/mwifiex/debugfs.c
+++ b/drivers/net/wireless/mwifiex/debugfs.c
@@ -510,102 +510,6 @@ exit:
 }
 
 /*
- * Proc debug file write handler.
- *
- * This function is called when the 'debug' file is opened for writing
- *
- * This function can be used to overwrite/set debug parameters. It does
- * not validate if a debug parameter can be changed or not. It just sends
- * the change request to firmware.
- */
-static ssize_t
-mwifiex_debug_write(struct file *file, const char __user *ubuf,
-		    size_t count, loff_t *ppos)
-{
-	struct mwifiex_private *priv =
-		(struct mwifiex_private *) file->private_data;
-	char *buf, *p, *p0, *p1, *p2;
-	struct mwifiex_debug_data *d = &items[0];
-	ssize_t ret = 0;
-	unsigned long val;
-	int i;
-
-	ENTER();
-
-	buf = kzalloc(count, GFP_KERNEL);
-	if (!buf) {
-		ret = -EFAULT;
-		goto exit;
-	}
-
-	if (copy_from_user(buf, ubuf, count)) {
-		kfree(buf);
-		PRINTM(MERROR, "%s: copy_from_user failed\n", __func__);
-		ret = -EFAULT;
-		goto exit;
-	}
-
-	for (p0 = buf, i = 0; i < num_of_items; i++) {
-		/* skip array */
-		if (d[i].num > 1)
-			continue;
-
-		do {
-			p = strstr(p0, d[i].name);
-			if (!p)
-				break;
-
-			p1 = strchr(p, '\n');
-			if (!p1)
-				break;
-
-			p0 = p1++;
-
-			p2 = strchr(p, '=');
-			if (!p2)
-				break;
-			p2++;
-
-			ret = strict_strtoul(p2, 0, &val);
-			if (ret < 0) {
-				PRINTM(MERROR, "strict_strtoul fail %d\n", ret);
-				ret = -EFAULT;
-			}
-
-			switch (d[i].size) {
-			case 1:
-				*((u8 *) d[i].addr) = (u8) val;
-				break;
-			case 2:
-				*((u16 *) d[i].addr) = (u16) val;
-				break;
-			case 4:
-				*((u32 *) d[i].addr) = (u32) val;
-				break;
-			case 8:
-				*((long long *) d[i].addr) = (long long) val;
-				break;
-			default:
-				break;
-			}
-		} while (1);
-	}
-
-	kfree(buf);
-
-	/* Set debug information */
-	if (mwifiex_set_debug_info(priv, MWIFIEX_PROC_WAIT, &info)) {
-		PRINTM(MERROR, "%s: mwifiex_set_debug_info\n", __func__);
-		ret = -EFAULT;
-		goto exit;
-	}
-
-	LEAVE();
-exit:
-	return count;
-}
-
-/*
  * Proc txaggrpio file write handler.
  *
  * This function is called when the 'txaggrprio' file is opened for writing
@@ -2434,7 +2338,7 @@ static const struct file_operations mwifiex_dfs_##name##_fops = {       \
 
 
 MWIFIEX_DFS_FILE_READ_OPS(info);
-MWIFIEX_DFS_FILE_OPS(debug);
+MWIFIEX_DFS_FILE_READ_OPS(debug);
 MWIFIEX_DFS_FILE_OPS(deepsleep);
 MWIFIEX_DFS_FILE_OPS(hscfg);
 MWIFIEX_DFS_FILE_OPS(amsduaggrctrl);
diff --git a/drivers/net/wireless/mwifiex/main.h b/drivers/net/wireless/mwifiex/main.h
index 646cc55..f43372f 100644
--- a/drivers/net/wireless/mwifiex/main.h
+++ b/drivers/net/wireless/mwifiex/main.h
@@ -996,10 +996,6 @@ enum mwifiex_status mwifiex_get_debug_info(struct mwifiex_private *priv,
 					   u8 wait_option,
 					   struct mwifiex_debug_info
 					   *debug_info);
-enum mwifiex_status mwifiex_set_debug_info(struct mwifiex_private *priv,
-					   u8 wait_option,
-					   struct mwifiex_debug_info
-					   *debug_info);
 enum mwifiex_status mwifiex_disconnect(struct mwifiex_private *, u8, u8 *);
 enum mwifiex_status mwifiex_bss_start(struct mwifiex_private *priv,
 				      u8 wait_option,
diff --git a/drivers/net/wireless/mwifiex/sta_ioctl.c b/drivers/net/wireless/mwifiex/sta_ioctl.c
index 4a13ccc..f1676bb 100644
--- a/drivers/net/wireless/mwifiex/sta_ioctl.c
+++ b/drivers/net/wireless/mwifiex/sta_ioctl.c
@@ -546,50 +546,6 @@ mwifiex_get_debug_info(struct mwifiex_private *priv, u8 wait_option,
 }
 
 /*
- * Sends IOCTL request to set debug information.
- *
- * This function allocates the IOCTL request buffer, fills it
- * with requisite parameters and calls the IOCTL handler.
- */
-enum mwifiex_status
-mwifiex_set_debug_info(struct mwifiex_private *priv, u8 wait_option,
-		       struct mwifiex_debug_info *debug_info)
-{
-	struct mwifiex_ioctl_req *req = NULL;
-	struct mwifiex_ds_get_info *info = NULL;
-	enum mwifiex_status status = MWIFIEX_STATUS_SUCCESS;
-
-	ENTER();
-
-	if (!debug_info) {
-		LEAVE();
-		return MWIFIEX_STATUS_FAILURE;
-	}
-
-	/* Allocate an IOCTL request buffer */
-	req = mwifiex_alloc_ioctl_req(sizeof(struct mwifiex_ds_get_info));
-	if (req == NULL) {
-		LEAVE();
-		return MWIFIEX_STATUS_FAILURE;
-	}
-
-	/* Fill request buffer */
-	info = (struct mwifiex_ds_get_info *) req->buffer;
-	info->sub_command = MWIFIEX_OID_GET_DEBUG_INFO;
-	memcpy(&info->param.debug_info, debug_info,
-	       sizeof(struct mwifiex_debug_info));
-	req->req_id = MWIFIEX_IOCTL_GET_INFO;
-	req->action = MWIFIEX_ACT_SET;
-
-	status = mwifiex_request_ioctl(priv, req, wait_option);
-
-	if (req && (status != MWIFIEX_STATUS_PENDING))
-		kfree(req);
-	LEAVE();
-	return status;
-}
-
-/*
  * Sends IOCTL request to get Host Sleep parameters.
  *
  * This function allocates the IOCTL request buffer, fills it
diff --git a/drivers/net/wireless/mwifiex/util.c b/drivers/net/wireless/mwifiex/util.c
index 9af28b3..9ef5b74 100644
--- a/drivers/net/wireless/mwifiex/util.c
+++ b/drivers/net/wireless/mwifiex/util.c
@@ -296,78 +296,7 @@ mwifiex_get_info_debug_info(struct mwifiex_adapter *adapter,
 
 	info = (struct mwifiex_ds_get_info *) ioctl_req->buffer;
 
-	if (ioctl_req->action == MWIFIEX_ACT_SET) {
-		memcpy(priv->wmm.packets_out,
-		       info->param.debug_info.packets_out,
-		       sizeof(priv->wmm.packets_out));
-		adapter->max_tx_buf_size =
-			(u16) info->param.debug_info.max_tx_buf_size;
-		adapter->tx_buf_size =
-			(u16) info->param.debug_info.tx_buf_size;
-		adapter->curr_tx_buf_size =
-			(u16) info->param.debug_info.curr_tx_buf_size;
-		adapter->ps_mode = info->param.debug_info.ps_mode;
-		adapter->ps_state = info->param.debug_info.ps_state;
-		adapter->is_deep_sleep = info->param.debug_info.is_deep_sleep;
-		adapter->pm_wakeup_card_req =
-			info->param.debug_info.pm_wakeup_card_req;
-		adapter->pm_wakeup_fw_try =
-			info->param.debug_info.pm_wakeup_fw_try;
-		adapter->is_hs_configured =
-			info->param.debug_info.is_hs_configured;
-		adapter->hs_activated = info->param.debug_info.hs_activated;
-
-		adapter->dbg.num_cmd_host_to_card_failure =
-			info->param.debug_info.num_cmd_host_to_card_failure;
-		adapter->dbg.num_cmd_sleep_cfm_host_to_card_failure =
-			info->param.debug_info.
-			num_cmd_sleep_cfm_host_to_card_failure;
-		adapter->dbg.num_tx_host_to_card_failure =
-			info->param.debug_info.num_tx_host_to_card_failure;
-		adapter->dbg.num_event_deauth =
-			info->param.debug_info.num_event_deauth;
-		adapter->dbg.num_event_disassoc =
-			info->param.debug_info.num_event_disassoc;
-		adapter->dbg.num_event_link_lost =
-			info->param.debug_info.num_event_link_lost;
-		adapter->dbg.num_cmd_deauth =
-			info->param.debug_info.num_cmd_deauth;
-		adapter->dbg.num_cmd_assoc_success =
-			info->param.debug_info.num_cmd_assoc_success;
-		adapter->dbg.num_cmd_assoc_failure =
-			info->param.debug_info.num_cmd_assoc_failure;
-		adapter->dbg.num_tx_timeout =
-			info->param.debug_info.num_tx_timeout;
-		adapter->dbg.num_cmd_timeout =
-			info->param.debug_info.num_cmd_timeout;
-		adapter->dbg.timeout_cmd_id =
-			info->param.debug_info.timeout_cmd_id;
-		adapter->dbg.timeout_cmd_act =
-			info->param.debug_info.timeout_cmd_act;
-		memcpy(adapter->dbg.last_cmd_id,
-		       info->param.debug_info.last_cmd_id,
-		       sizeof(adapter->dbg.last_cmd_id));
-		memcpy(adapter->dbg.last_cmd_act,
-		       info->param.debug_info.last_cmd_act,
-		       sizeof(adapter->dbg.last_cmd_act));
-		adapter->dbg.last_cmd_index =
-			info->param.debug_info.last_cmd_index;
-		memcpy(adapter->dbg.last_cmd_resp_id,
-		       info->param.debug_info.last_cmd_resp_id,
-		       sizeof(adapter->dbg.last_cmd_resp_id));
-		adapter->dbg.last_cmd_resp_index =
-			info->param.debug_info.last_cmd_resp_index;
-		memcpy(adapter->dbg.last_event,
-		       info->param.debug_info.last_event,
-		       sizeof(adapter->dbg.last_event));
-		adapter->dbg.last_event_index =
-			info->param.debug_info.last_event_index;
-
-		adapter->data_sent = info->param.debug_info.data_sent;
-		adapter->cmd_sent = info->param.debug_info.cmd_sent;
-		adapter->cmd_resp_received =
-			info->param.debug_info.cmd_resp_received;
-	} else {		/* MWIFIEX_ACT_GET */
+	if (ioctl_req->action == MWIFIEX_ACT_GET) {
 		memcpy(info->param.debug_info.packets_out,
 		       priv->wmm.packets_out,
 		       sizeof(priv->wmm.packets_out));
-- 
1.7.0.2

