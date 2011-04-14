Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from dakia2.marvell.com ([65.219.4.35]:44821 "EHLO
	dakia2.marvell.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755655Ab1DNAW6 (ORCPT
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
Subject: [PATCH 1/4] mwifiex: cleanup ioctl wait queue and abstraction layer
Date: Wed, 13 Apr 2011 17:27:06 -0700
Message-Id: <1302740829-21315-1-git-send-email-bzhao@marvell.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Amitkumar Karwar <akarwar@marvell.com>

1) remove mwifiex_alloc_fill_wait_queue() and
mwifiex_request_ioctl()
2) avoid dynamic allocation of wait queue
3) remove unnecessary mwifiex_error_code macros that
were used mainly by the wait queue status code
4) remove some abstraction functions
5) split mwifiex_prepare_cmd() to mwifiex_send_cmd_async()
and mwifiex_send_sync() to handle asynchronous and
synchronous commands respectively

Signed-off-by: Amitkumar Karwar <akarwar@marvell.com>
Signed-off-by: Bing Zhao <bzhao@marvell.com>
---
 drivers/net/wireless/mwifiex/11n.c           |   13 +-
 drivers/net/wireless/mwifiex/11n_rxreorder.c |    2 +-
 drivers/net/wireless/mwifiex/README          |    2 +-
 drivers/net/wireless/mwifiex/cfg80211.c      |  113 ++--
 drivers/net/wireless/mwifiex/cmdevt.c        |  179 ++---
 drivers/net/wireless/mwifiex/debugfs.c       |    4 +-
 drivers/net/wireless/mwifiex/decl.h          |   24 +-
 drivers/net/wireless/mwifiex/init.c          |    3 +-
 drivers/net/wireless/mwifiex/join.c          |   90 +--
 drivers/net/wireless/mwifiex/main.c          |   71 +-
 drivers/net/wireless/mwifiex/main.h          |  123 +---
 drivers/net/wireless/mwifiex/scan.c          |  126 +---
 drivers/net/wireless/mwifiex/sdio.c          |   11 +-
 drivers/net/wireless/mwifiex/sta_cmd.c       |   60 +-
 drivers/net/wireless/mwifiex/sta_cmdresp.c   |   29 +-
 drivers/net/wireless/mwifiex/sta_event.c     |   25 +-
 drivers/net/wireless/mwifiex/sta_ioctl.c     | 1008 ++++----------------------
 drivers/net/wireless/mwifiex/sta_tx.c        |    2 +-
 drivers/net/wireless/mwifiex/util.c          |   51 +-
 19 files changed, 502 insertions(+), 1434 deletions(-)

diff --git a/drivers/net/wireless/mwifiex/11n.c b/drivers/net/wireless/mwifiex/11n.c
index 73a6e62..edf4c27 100644
--- a/drivers/net/wireless/mwifiex/11n.c
+++ b/drivers/net/wireless/mwifiex/11n.c
@@ -541,9 +541,8 @@ mwifiex_cfg_tx_buf(struct mwifiex_private *priv,
 	else if (priv->adapter->curr_tx_buf_size <= MWIFIEX_TX_DATA_BUF_SIZE_8K)
 		curr_tx_buf_size = MWIFIEX_TX_DATA_BUF_SIZE_8K;
 	if (curr_tx_buf_size != tx_buf)
-		mwifiex_prepare_cmd(priv, HostCmd_CMD_RECONFIGURE_TX_BUFF,
-			HostCmd_ACT_GEN_SET, 0,
-			NULL, &tx_buf);
+		mwifiex_send_cmd_async(priv, HostCmd_CMD_RECONFIGURE_TX_BUFF,
+				       HostCmd_ACT_GEN_SET, 0, &tx_buf);
 
 	return;
 }
@@ -694,8 +693,8 @@ int mwifiex_send_addba(struct mwifiex_private *priv, int tid, u8 *peer_mac)
 	memcpy(&add_ba_req.peer_mac_addr, peer_mac, ETH_ALEN);
 
 	/* We don't wait for the response of this command */
-	ret = mwifiex_prepare_cmd(priv, HostCmd_CMD_11N_ADDBA_REQ,
-				  0, 0, NULL, &add_ba_req);
+	ret = mwifiex_send_cmd_async(priv, HostCmd_CMD_11N_ADDBA_REQ,
+				     0, 0, &add_ba_req);
 
 	return ret;
 }
@@ -722,8 +721,8 @@ int mwifiex_send_delba(struct mwifiex_private *priv, int tid, u8 *peer_mac,
 	memcpy(&delba.peer_mac_addr, peer_mac, ETH_ALEN);
 
 	/* We don't wait for the response of this command */
-	ret = mwifiex_prepare_cmd(priv, HostCmd_CMD_11N_DELBA,
-				  HostCmd_ACT_GEN_SET, 0, NULL, &delba);
+	ret = mwifiex_send_cmd_async(priv, HostCmd_CMD_11N_DELBA,
+				     HostCmd_ACT_GEN_SET, 0, &delba);
 
 	return ret;
 }
diff --git a/drivers/net/wireless/mwifiex/11n_rxreorder.c b/drivers/net/wireless/mwifiex/11n_rxreorder.c
index 8e94e62..ef46d0a 100644
--- a/drivers/net/wireless/mwifiex/11n_rxreorder.c
+++ b/drivers/net/wireless/mwifiex/11n_rxreorder.c
@@ -609,7 +609,7 @@ void mwifiex_11n_ba_stream_timeout(struct mwifiex_private *priv,
 	delba.del_ba_param_set |= cpu_to_le16(
 		(u16) event->origninator << DELBA_INITIATOR_POS);
 	delba.reason_code = cpu_to_le16(WLAN_REASON_QSTA_TIMEOUT);
-	mwifiex_prepare_cmd(priv, HostCmd_CMD_11N_DELBA, 0, 0, NULL, &delba);
+	mwifiex_send_cmd_async(priv, HostCmd_CMD_11N_DELBA, 0, 0, &delba);
 
 	return;
 }
diff --git a/drivers/net/wireless/mwifiex/README b/drivers/net/wireless/mwifiex/README
index 338377f..b55bade 100644
--- a/drivers/net/wireless/mwifiex/README
+++ b/drivers/net/wireless/mwifiex/README
@@ -157,7 +157,7 @@ info
 	mp_wr_bitmap = <SDIO multi-port write bitmap>
 	cmd_resp_received = <0/1, no cmd response to process/response received and yet to process>
 	event_received = <0/1, no event to process/event received and yet to process>
-	ioctl_pending = <number of ioctl pending>
+	cmd_pending = <number of cmd pending>
 	tx_pending = <number of Tx packet pending>
 	rx_pending = <number of Rx packet pending>
 
diff --git a/drivers/net/wireless/mwifiex/cfg80211.c b/drivers/net/wireless/mwifiex/cfg80211.c
index ec0895f..a1ff490 100644
--- a/drivers/net/wireless/mwifiex/cfg80211.c
+++ b/drivers/net/wireless/mwifiex/cfg80211.c
@@ -139,8 +139,16 @@ mwifiex_cfg80211_set_tx_power(struct wiphy *wiphy,
 {
 	int ret = 0;
 	struct mwifiex_private *priv = mwifiex_cfg80211_get_priv(wiphy);
+	struct mwifiex_power_cfg power_cfg;
 
-	ret = mwifiex_set_tx_power(priv, type, dbm);
+	if (type == NL80211_TX_POWER_FIXED) {
+		power_cfg.is_power_auto = 0;
+		power_cfg.power_level = dbm;
+	} else {
+		power_cfg.is_power_auto = 1;
+	}
+
+	ret = mwifiex_set_tx_power(priv, &power_cfg);
 
 	return ret;
 }
@@ -157,13 +165,15 @@ mwifiex_cfg80211_set_power_mgmt(struct wiphy *wiphy,
 {
 	int ret = 0;
 	struct mwifiex_private *priv = mwifiex_cfg80211_get_priv(wiphy);
+	u32 ps_mode;
 
 	if (timeout)
 		wiphy_dbg(wiphy,
 			"info: ignoring the timeout value"
 			" for IEEE power save\n");
 
-	ret = mwifiex_drv_set_power(priv, enabled);
+	ps_mode = enabled;
+	ret = mwifiex_drv_set_power(priv, &ps_mode);
 
 	return ret;
 }
@@ -291,8 +301,8 @@ static int mwifiex_send_domain_info_cmd_fw(struct wiphy *wiphy)
 
 	domain_info->no_of_triplet = no_of_triplet;
 	/* Send cmd to FW to set domain info */
-	ret = mwifiex_prepare_cmd(priv, HostCmd_CMD_802_11D_DOMAIN_INFO,
-				  HostCmd_ACT_GEN_SET, 0, NULL, NULL);
+	ret = mwifiex_send_cmd_async(priv, HostCmd_CMD_802_11D_DOMAIN_INFO,
+				     HostCmd_ACT_GEN_SET, 0, NULL);
 	if (ret)
 		wiphy_err(wiphy, "11D: setting domain info in FW\n");
 
@@ -347,7 +357,6 @@ mwifiex_set_rf_channel(struct mwifiex_private *priv,
 {
 	struct mwifiex_chan_freq_power cfp;
 	int ret = 0;
-	int status = 0;
 	struct mwifiex_ds_band_cfg band_cfg;
 	u32 config_bands = 0;
 	struct wiphy *wiphy = priv->wdev->wiphy;
@@ -370,10 +379,9 @@ mwifiex_set_rf_channel(struct mwifiex_private *priv,
 		band_cfg.sec_chan_offset =
 			mwifiex_cfg80211_channel_type_to_mwifiex_channels
 			(channel_type);
-		status = mwifiex_radio_ioctl_band_cfg(priv, HostCmd_ACT_GEN_SET,
-						      &band_cfg);
+		ret = mwifiex_set_radio_band_cfg(priv, &band_cfg);
 
-		if (status)
+		if (ret)
 			return -EFAULT;
 		mwifiex_send_domain_info_cmd_fw(wiphy);
 	}
@@ -389,8 +397,8 @@ mwifiex_set_rf_channel(struct mwifiex_private *priv,
 	/* Convert frequency to channel */
 	cfp.channel = ieee80211_frequency_to_channel(chan->center_freq);
 
-	status = mwifiex_bss_ioctl_channel(priv, HostCmd_ACT_GEN_SET, &cfp);
-	if (status)
+	ret = mwifiex_bss_set_channel(priv, &cfp);
+	if (ret)
 		return -EFAULT;
 
 	ret = mwifiex_drv_change_adhoc_chan(priv, cfp.channel);
@@ -422,66 +430,45 @@ mwifiex_cfg80211_set_channel(struct wiphy *wiphy, struct net_device *dev,
 /*
  * This function sets the fragmentation threshold.
  *
- * This function creates an IOCTL request, populates it accordingly
- * and issues an IOCTL.
- *
- * The fragmentation threshold value must lies between MWIFIEX_FRAG_MIN_VALUE
+ * The fragmentation threshold value must lie between MWIFIEX_FRAG_MIN_VALUE
  * and MWIFIEX_FRAG_MAX_VALUE.
  */
 static int
 mwifiex_set_frag(struct mwifiex_private *priv, u32 frag_thr)
 {
 	int ret = 0;
-	int status = 0;
-	struct mwifiex_wait_queue *wait = NULL;
-	u8 wait_option = MWIFIEX_IOCTL_WAIT;
 
 	if (frag_thr < MWIFIEX_FRAG_MIN_VALUE
 	    || frag_thr > MWIFIEX_FRAG_MAX_VALUE)
 		return -EINVAL;
 
-	wait = mwifiex_alloc_fill_wait_queue(priv, wait_option);
-	if (!wait)
-		return -ENOMEM;
+	/* Send request to firmware */
+	ret = mwifiex_send_cmd_sync(priv, HostCmd_CMD_802_11_SNMP_MIB,
+				    HostCmd_ACT_GEN_SET, FRAG_THRESH_I,
+				    &frag_thr);
 
-	status = mwifiex_snmp_mib_ioctl(priv, wait, FRAG_THRESH_I,
-					HostCmd_ACT_GEN_SET, &frag_thr);
-
-	if (mwifiex_request_ioctl(priv, wait, status, wait_option))
-		ret = -EFAULT;
-
-	kfree(wait);
 	return ret;
 }
 
 /*
  * This function sets the RTS threshold.
- *
- * This function creates an IOCTL request, populates it accordingly
- * and issues an IOCTL.
+
+ * The rts value must lie between MWIFIEX_RTS_MIN_VALUE
+ * and MWIFIEX_RTS_MAX_VALUE.
  */
 static int
 mwifiex_set_rts(struct mwifiex_private *priv, u32 rts_thr)
 {
 	int ret = 0;
-	struct mwifiex_wait_queue *wait = NULL;
-	int status = 0;
-	u8 wait_option = MWIFIEX_IOCTL_WAIT;
 
 	if (rts_thr < MWIFIEX_RTS_MIN_VALUE || rts_thr > MWIFIEX_RTS_MAX_VALUE)
 		rts_thr = MWIFIEX_RTS_MAX_VALUE;
 
-	wait = mwifiex_alloc_fill_wait_queue(priv, wait_option);
-	if (!wait)
-		return -ENOMEM;
-
-	status = mwifiex_snmp_mib_ioctl(priv, wait, RTS_THRESH_I,
-					HostCmd_ACT_GEN_SET, &rts_thr);
-
-	if (mwifiex_request_ioctl(priv, wait, status, wait_option))
-		ret = -EFAULT;
+	/* Send request to firmware */
+	ret = mwifiex_send_cmd_sync(priv, HostCmd_CMD_802_11_SNMP_MIB,
+				    HostCmd_ACT_GEN_SET, RTS_THRESH_I,
+				    &rts_thr);
 
-	kfree(wait);
 	return ret;
 }
 
@@ -518,7 +505,6 @@ mwifiex_cfg80211_change_virtual_intf(struct wiphy *wiphy,
 {
 	int ret = 0;
 	struct mwifiex_private *priv = mwifiex_netdev_get_priv(dev);
-	struct mwifiex_wait_queue *wait = NULL;
 
 	if (priv->bss_mode == type) {
 		wiphy_warn(wiphy, "already set to required type\n");
@@ -545,24 +531,13 @@ mwifiex_cfg80211_change_virtual_intf(struct wiphy *wiphy,
 		return -EINVAL;
 	}
 
-	wait = mwifiex_alloc_fill_wait_queue(priv, MWIFIEX_IOCTL_WAIT);
-	if (!wait)
-		return -ENOMEM;
-
-	mwifiex_deauthenticate(priv, wait, NULL);
+	mwifiex_deauthenticate(priv, NULL);
 
 	priv->sec_info.authentication_mode = NL80211_AUTHTYPE_OPEN_SYSTEM;
 
-	ret = mwifiex_prepare_cmd(priv, HostCmd_CMD_SET_BSS_MODE,
-				  HostCmd_ACT_GEN_SET, 0, wait, NULL);
-	if (!ret)
-		ret = -EINPROGRESS;
+	ret = mwifiex_send_cmd_sync(priv, HostCmd_CMD_SET_BSS_MODE,
+				    HostCmd_ACT_GEN_SET, 0, NULL);
 
-	ret = mwifiex_request_ioctl(priv, wait, ret, MWIFIEX_IOCTL_WAIT);
-	if (ret)
-		ret = -EFAULT;
-
-	kfree(wait);
 	return ret;
 }
 
@@ -592,7 +567,7 @@ mwifiex_dump_station_info(struct mwifiex_private *priv,
 
 	/* Get signal information from the firmware */
 	memset(&signal, 0, sizeof(struct mwifiex_ds_get_signal));
-	if (mwifiex_get_signal_info(priv, MWIFIEX_IOCTL_WAIT, &signal)) {
+	if (mwifiex_get_signal_info(priv, &signal)) {
 		dev_err(priv->adapter->dev, "getting signal information\n");
 		ret = -EFAULT;
 	}
@@ -750,7 +725,7 @@ mwifiex_cfg80211_disconnect(struct wiphy *wiphy, struct net_device *dev,
 		return -EBUSY;
 
 	priv->disconnect = 1;
-	if (mwifiex_disconnect(priv, MWIFIEX_IOCTL_WAIT, NULL))
+	if (mwifiex_deauthenticate(priv, NULL))
 		return -EFAULT;
 
 	wiphy_dbg(wiphy, "info: successfully disconnected from %pM:"
@@ -838,8 +813,8 @@ static int mwifiex_inform_bss_from_scan_result(struct mwifiex_private *priv,
 	u8 element_id, element_len;
 
 	memset(&scan_resp, 0, sizeof(scan_resp));
-	if (mwifiex_get_scan_table(priv, MWIFIEX_IOCTL_WAIT, &scan_resp))
-		return -EFAULT;
+	scan_resp.scan_table = (u8 *) priv->adapter->scan_table;
+	scan_resp.num_in_scan_table = priv->adapter->num_in_scan_table;
 
 #define MAX_IE_BUF	2048
 	ie_buf = kzalloc(MAX_IE_BUF, GFP_KERNEL);
@@ -986,7 +961,7 @@ mwifiex_cfg80211_assoc(struct mwifiex_private *priv, size_t ssid_len, u8 *ssid,
 	}
 
 	/* disconnect before try to associate */
-	mwifiex_disconnect(priv, MWIFIEX_IOCTL_WAIT, NULL);
+	mwifiex_deauthenticate(priv, NULL);
 
 	if (channel)
 		ret = mwifiex_set_rf_channel(priv, channel,
@@ -1046,7 +1021,7 @@ mwifiex_cfg80211_assoc(struct mwifiex_private *priv, size_t ssid_len, u8 *ssid,
 	}
 done:
 	/* Do specific SSID scanning */
-	if (mwifiex_request_scan(priv, MWIFIEX_IOCTL_WAIT, &req_ssid)) {
+	if (mwifiex_request_scan(priv, &req_ssid)) {
 		dev_err(priv->adapter->dev, "scan error\n");
 		return -EFAULT;
 	}
@@ -1055,8 +1030,7 @@ done:
 	memcpy(&ssid_bssid.ssid, &req_ssid, sizeof(struct mwifiex_802_11_ssid));
 
 	if (mode != NL80211_IFTYPE_ADHOC) {
-		if (mwifiex_find_best_bss(priv, MWIFIEX_IOCTL_WAIT,
-					  &ssid_bssid))
+		if (mwifiex_find_best_bss(priv, &ssid_bssid))
 			return -EFAULT;
 		/* Inform the BSS information to kernel, otherwise
 		 * kernel will give a panic after successful assoc */
@@ -1072,7 +1046,10 @@ done:
 	/* Connect to BSS by ESSID */
 	memset(&ssid_bssid.bssid, 0, ETH_ALEN);
 
-	if (mwifiex_bss_start(priv, MWIFIEX_IOCTL_WAIT, &ssid_bssid))
+	if (!netif_queue_stopped(priv->netdev))
+		netif_stop_queue(priv->netdev);
+
+	if (mwifiex_bss_start(priv, &ssid_bssid))
 		return -EFAULT;
 
 	if (mode == NL80211_IFTYPE_ADHOC) {
@@ -1176,7 +1153,7 @@ mwifiex_cfg80211_leave_ibss(struct wiphy *wiphy, struct net_device *dev)
 
 	wiphy_dbg(wiphy, "info: disconnecting from essid %pM\n",
 			priv->cfg_bssid);
-	if (mwifiex_disconnect(priv, MWIFIEX_IOCTL_WAIT, NULL))
+	if (mwifiex_deauthenticate(priv, NULL))
 		return -EFAULT;
 
 	queue_work(priv->workqueue, &priv->cfg_workqueue);
diff --git a/drivers/net/wireless/mwifiex/cmdevt.c b/drivers/net/wireless/mwifiex/cmdevt.c
index 8676480..bb6fecd 100644
--- a/drivers/net/wireless/mwifiex/cmdevt.c
+++ b/drivers/net/wireless/mwifiex/cmdevt.c
@@ -36,11 +36,12 @@
 static void
 mwifiex_init_cmd_node(struct mwifiex_private *priv,
 		      struct cmd_ctrl_node *cmd_node,
-		      u32 cmd_oid, void *wait_queue, void *data_buf)
+		      u32 cmd_oid, void *data_buf)
 {
 	cmd_node->priv = priv;
 	cmd_node->cmd_oid = cmd_oid;
-	cmd_node->wq_buf = wait_queue;
+	cmd_node->wait_q_enabled = priv->adapter->cmd_wait_q_required;
+	priv->adapter->cmd_wait_q_required = false;
 	cmd_node->data_buf = data_buf;
 	cmd_node->cmd_skb = cmd_node->skb;
 }
@@ -86,8 +87,8 @@ mwifiex_clean_cmd_node(struct mwifiex_adapter *adapter,
 {
 	cmd_node->cmd_oid = 0;
 	cmd_node->cmd_flag = 0;
-	cmd_node->wq_buf = NULL;
 	cmd_node->data_buf = NULL;
+	cmd_node->wait_q_enabled = false;
 
 	if (cmd_node->resp_skb) {
 		mwifiex_recv_complete(adapter, cmd_node->resp_skb, 0);
@@ -98,30 +99,6 @@ mwifiex_clean_cmd_node(struct mwifiex_adapter *adapter,
 }
 
 /*
- * This function returns a command node from the pending queue which
- * matches the given IOCTL request.
- */
-static struct cmd_ctrl_node *
-mwifiex_get_pending_ioctl_cmd(struct mwifiex_adapter *adapter,
-			      struct mwifiex_wait_queue *wait_queue)
-{
-	unsigned long flags;
-	struct cmd_ctrl_node *cmd_node;
-
-	spin_lock_irqsave(&adapter->cmd_pending_q_lock, flags);
-	list_for_each_entry(cmd_node, &adapter->cmd_pending_q, list) {
-		if (cmd_node->wq_buf == wait_queue) {
-			spin_unlock_irqrestore(&adapter->cmd_pending_q_lock,
-					       flags);
-			return cmd_node;
-		}
-	}
-	spin_unlock_irqrestore(&adapter->cmd_pending_q_lock, flags);
-
-	return NULL;
-}
-
-/*
  * This function sends a host command to the firmware.
  *
  * The function copies the host command into the driver command
@@ -155,7 +132,6 @@ static int mwifiex_dnld_cmd_to_fw(struct mwifiex_private *priv,
 	struct mwifiex_adapter *adapter = priv->adapter;
 	int ret = 0;
 	struct host_cmd_ds_command *host_cmd;
-	struct mwifiex_wait_queue *wait_queue = NULL;
 	uint16_t cmd_code;
 	uint16_t cmd_size;
 	struct timeval tstamp;
@@ -165,15 +141,13 @@ static int mwifiex_dnld_cmd_to_fw(struct mwifiex_private *priv,
 		return -1;
 
 	host_cmd = (struct host_cmd_ds_command *) (cmd_node->cmd_skb->data);
-	if (cmd_node->wq_buf)
-		wait_queue = (struct mwifiex_wait_queue *) cmd_node->wq_buf;
 
 	/* Sanity test */
 	if (host_cmd == NULL || host_cmd->size == 0) {
 		dev_err(adapter->dev, "DNLD_CMD: host_cmd is null"
 			" or cmd size is 0, not sending\n");
-		if (wait_queue)
-			wait_queue->status = MWIFIEX_ERROR_CMD_DNLD_FAIL;
+		if (cmd_node->wait_q_enabled)
+			adapter->cmd_wait_q.status = -1;
 		mwifiex_insert_cmd_to_free_q(adapter, cmd_node);
 		return -1;
 	}
@@ -210,8 +184,8 @@ static int mwifiex_dnld_cmd_to_fw(struct mwifiex_private *priv,
 
 	if (ret == -1) {
 		dev_err(adapter->dev, "DNLD_CMD: host to card failed\n");
-		if (wait_queue)
-			wait_queue->status = MWIFIEX_ERROR_CMD_DNLD_FAIL;
+		if (cmd_node->wait_q_enabled)
+			adapter->cmd_wait_q.status = -1;
 		mwifiex_insert_cmd_to_free_q(adapter, adapter->curr_cmd);
 
 		spin_lock_irqsave(&adapter->mwifiex_cmd_lock, flags);
@@ -437,7 +411,31 @@ int mwifiex_process_event(struct mwifiex_adapter *adapter)
 }
 
 /*
- * This function prepares a command before sending it to the firmware.
+ * This function is used to send synchronous command to the firmware.
+ *
+ * it allocates a wait queue for the command and wait for the command
+ * response.
+ */
+int mwifiex_send_cmd_sync(struct mwifiex_private *priv, uint16_t cmd_no,
+			  u16 cmd_action, u32 cmd_oid, void *data_buf)
+{
+	int ret = 0;
+	struct mwifiex_adapter *adapter = priv->adapter;
+
+	adapter->cmd_wait_q_required = true;
+	adapter->cmd_wait_q.condition = false;
+
+	ret = mwifiex_send_cmd_async(priv, cmd_no, cmd_action, cmd_oid,
+				     data_buf);
+	if (!ret)
+		ret = mwifiex_wait_queue_complete(adapter);
+
+	return ret;
+}
+
+
+/*
+ * This function prepares a command and asynchronously send it to the firmware.
  *
  * Preparation includes -
  *      - Sanity tests to make sure the card is still present or the FW
@@ -447,9 +445,8 @@ int mwifiex_process_event(struct mwifiex_adapter *adapter)
  *      - Fill up the non-default parameters and buffer pointers
  *      - Add the command to pending queue
  */
-int mwifiex_prepare_cmd(struct mwifiex_private *priv, uint16_t cmd_no,
-			u16 cmd_action, u32 cmd_oid,
-			void *wait_queue, void *data_buf)
+int mwifiex_send_cmd_async(struct mwifiex_private *priv, uint16_t cmd_no,
+			   u16 cmd_action, u32 cmd_oid, void *data_buf)
 {
 	int ret = 0;
 	struct mwifiex_adapter *adapter = priv->adapter;
@@ -487,7 +484,7 @@ int mwifiex_prepare_cmd(struct mwifiex_private *priv, uint16_t cmd_no,
 	}
 
 	/* Initialize the command node */
-	mwifiex_init_cmd_node(priv, cmd_node, cmd_oid, wait_queue, data_buf);
+	mwifiex_init_cmd_node(priv, cmd_node, cmd_oid, data_buf);
 
 	if (!cmd_node->cmd_skb) {
 		dev_err(adapter->dev, "PREP_CMD: no free cmd buf\n");
@@ -537,18 +534,13 @@ void
 mwifiex_insert_cmd_to_free_q(struct mwifiex_adapter *adapter,
 			     struct cmd_ctrl_node *cmd_node)
 {
-	struct mwifiex_wait_queue *wait_queue = NULL;
 	unsigned long flags;
 
 	if (cmd_node == NULL)
 		return;
-	if (cmd_node->wq_buf) {
-		wait_queue = (struct mwifiex_wait_queue *) cmd_node->wq_buf;
-		if (wait_queue->status != MWIFIEX_ERROR_NO_ERROR)
-			mwifiex_ioctl_complete(adapter, wait_queue, -1);
-		else
-			mwifiex_ioctl_complete(adapter, wait_queue, 0);
-	}
+
+	if (cmd_node->wait_q_enabled)
+		mwifiex_complete_cmd(adapter);
 	/* Clean the node */
 	mwifiex_clean_cmd_node(adapter, cmd_node);
 
@@ -694,7 +686,6 @@ int mwifiex_process_cmdresp(struct mwifiex_adapter *adapter)
 	uint16_t orig_cmdresp_no;
 	uint16_t cmdresp_no;
 	uint16_t cmdresp_result;
-	struct mwifiex_wait_queue *wait_queue = NULL;
 	struct timeval tstamp;
 	unsigned long flags;
 
@@ -708,10 +699,6 @@ int mwifiex_process_cmdresp(struct mwifiex_adapter *adapter)
 		return -1;
 	}
 
-	if (adapter->curr_cmd->wq_buf)
-		wait_queue = (struct mwifiex_wait_queue *)
-				adapter->curr_cmd->wq_buf;
-
 	adapter->num_cmd_timeout = 0;
 
 	resp = (struct host_cmd_ds_command *) adapter->curr_cmd->resp_skb->data;
@@ -766,8 +753,8 @@ int mwifiex_process_cmdresp(struct mwifiex_adapter *adapter)
 
 	if (!(orig_cmdresp_no & HostCmd_RET_BIT)) {
 		dev_err(adapter->dev, "CMD_RESP: invalid cmd resp\n");
-		if (wait_queue)
-			wait_queue->status = MWIFIEX_ERROR_FW_CMDRESP;
+		if (adapter->curr_cmd->wait_q_enabled)
+			adapter->cmd_wait_q.status = -1;
 
 		mwifiex_insert_cmd_to_free_q(adapter, adapter->curr_cmd);
 		spin_lock_irqsave(&adapter->mwifiex_cmd_lock, flags);
@@ -783,8 +770,7 @@ int mwifiex_process_cmdresp(struct mwifiex_adapter *adapter)
 			ret = mwifiex_ret_802_11_hs_cfg(priv, resp);
 	} else {
 		/* handle response */
-		ret = mwifiex_process_sta_cmdresp(priv, cmdresp_no, resp,
-						  wait_queue);
+		ret = mwifiex_process_sta_cmdresp(priv, cmdresp_no, resp);
 	}
 
 	/* Check init command response */
@@ -799,10 +785,10 @@ int mwifiex_process_cmdresp(struct mwifiex_adapter *adapter)
 	}
 
 	if (adapter->curr_cmd) {
-		if (wait_queue && (!ret))
-			wait_queue->status = MWIFIEX_ERROR_NO_ERROR;
-		else if (wait_queue && (ret == -1))
-			wait_queue->status = MWIFIEX_ERROR_CMD_RESP_FAIL;
+		if (adapter->curr_cmd->wait_q_enabled && (!ret))
+			adapter->cmd_wait_q.status = 0;
+		else if (adapter->curr_cmd->wait_q_enabled && (ret == -1))
+			adapter->cmd_wait_q.status = -1;
 
 		/* Clean up and put current command back to cmd_free_q */
 		mwifiex_insert_cmd_to_free_q(adapter, adapter->curr_cmd);
@@ -826,7 +812,6 @@ mwifiex_cmd_timeout_func(unsigned long function_context)
 	struct mwifiex_adapter *adapter =
 		(struct mwifiex_adapter *) function_context;
 	struct cmd_ctrl_node *cmd_node = NULL;
-	struct mwifiex_wait_queue *wait_queue = NULL;
 	struct timeval tstamp;
 
 	adapter->num_cmd_timeout++;
@@ -836,10 +821,8 @@ mwifiex_cmd_timeout_func(unsigned long function_context)
 		return;
 	}
 	cmd_node = adapter->curr_cmd;
-	if (cmd_node->wq_buf) {
-		wait_queue = (struct mwifiex_wait_queue *) cmd_node->wq_buf;
-		wait_queue->status = MWIFIEX_ERROR_CMD_TIMEOUT;
-	}
+	if (cmd_node->wait_q_enabled)
+		adapter->cmd_wait_q.status = -ETIMEDOUT;
 
 	if (cmd_node) {
 		adapter->dbg.timeout_cmd_id =
@@ -903,18 +886,15 @@ void
 mwifiex_cancel_all_pending_cmd(struct mwifiex_adapter *adapter)
 {
 	struct cmd_ctrl_node *cmd_node = NULL, *tmp_node = NULL;
-	struct mwifiex_wait_queue *wait_queue = NULL;
 	unsigned long flags;
 
 	/* Cancel current cmd */
-	if ((adapter->curr_cmd) && (adapter->curr_cmd->wq_buf)) {
-		wait_queue =
-			(struct mwifiex_wait_queue *) adapter->curr_cmd->wq_buf;
+	if ((adapter->curr_cmd) && (adapter->curr_cmd->wait_q_enabled)) {
 		spin_lock_irqsave(&adapter->mwifiex_cmd_lock, flags);
-		adapter->curr_cmd->wq_buf = NULL;
+		adapter->curr_cmd->wait_q_enabled = false;
 		spin_unlock_irqrestore(&adapter->mwifiex_cmd_lock, flags);
-		wait_queue->status = MWIFIEX_ERROR_CMD_CANCEL;
-		mwifiex_ioctl_complete(adapter, wait_queue, -1);
+		adapter->cmd_wait_q.status = -1;
+		mwifiex_complete_cmd(adapter);
 	}
 	/* Cancel all pending command */
 	spin_lock_irqsave(&adapter->cmd_pending_q_lock, flags);
@@ -923,12 +903,10 @@ mwifiex_cancel_all_pending_cmd(struct mwifiex_adapter *adapter)
 		list_del(&cmd_node->list);
 		spin_unlock_irqrestore(&adapter->cmd_pending_q_lock, flags);
 
-		if (cmd_node->wq_buf) {
-			wait_queue =
-				(struct mwifiex_wait_queue *) cmd_node->wq_buf;
-			wait_queue->status = MWIFIEX_ERROR_CMD_CANCEL;
-			mwifiex_ioctl_complete(adapter, wait_queue, -1);
-			cmd_node->wq_buf = NULL;
+		if (cmd_node->wait_q_enabled) {
+			adapter->cmd_wait_q.status = -1;
+			mwifiex_complete_cmd(adapter);
+			cmd_node->wait_q_enabled = false;
 		}
 		mwifiex_insert_cmd_to_free_q(adapter, cmd_node);
 		spin_lock_irqsave(&adapter->cmd_pending_q_lock, flags);
@@ -942,7 +920,7 @@ mwifiex_cancel_all_pending_cmd(struct mwifiex_adapter *adapter)
 		list_del(&cmd_node->list);
 		spin_unlock_irqrestore(&adapter->scan_pending_q_lock, flags);
 
-		cmd_node->wq_buf = NULL;
+		cmd_node->wait_q_enabled = false;
 		mwifiex_insert_cmd_to_free_q(adapter, cmd_node);
 		spin_lock_irqsave(&adapter->scan_pending_q_lock, flags);
 	}
@@ -964,8 +942,7 @@ mwifiex_cancel_all_pending_cmd(struct mwifiex_adapter *adapter)
  * are cancelled.
  */
 void
-mwifiex_cancel_pending_ioctl(struct mwifiex_adapter *adapter,
-			     struct mwifiex_wait_queue *wait_queue)
+mwifiex_cancel_pending_ioctl(struct mwifiex_adapter *adapter)
 {
 	struct cmd_ctrl_node *cmd_node = NULL, *tmp_node = NULL;
 	unsigned long cmd_flags;
@@ -974,45 +951,33 @@ mwifiex_cancel_pending_ioctl(struct mwifiex_adapter *adapter,
 	uint16_t cancel_scan_cmd = false;
 
 	if ((adapter->curr_cmd) &&
-	    (adapter->curr_cmd->wq_buf == wait_queue)) {
+	     (adapter->curr_cmd->wait_q_enabled)) {
 		spin_lock_irqsave(&adapter->mwifiex_cmd_lock, cmd_flags);
 		cmd_node = adapter->curr_cmd;
-		cmd_node->wq_buf = NULL;
+		cmd_node->wait_q_enabled = false;
 		cmd_node->cmd_flag |= CMD_F_CANCELED;
-		spin_unlock_irqrestore(&adapter->mwifiex_cmd_lock, cmd_flags);
-	}
-
-	spin_lock_irqsave(&adapter->mwifiex_cmd_lock, cmd_flags);
-	while (1) {
-		cmd_node = mwifiex_get_pending_ioctl_cmd(adapter, wait_queue);
-		if (!cmd_node)
-			break;
-
 		spin_lock_irqsave(&adapter->cmd_pending_q_lock,
 				  cmd_pending_q_flags);
 		list_del(&cmd_node->list);
 		spin_unlock_irqrestore(&adapter->cmd_pending_q_lock,
 				       cmd_pending_q_flags);
-
-		cmd_node->wq_buf = NULL;
 		mwifiex_insert_cmd_to_free_q(adapter, cmd_node);
+		spin_unlock_irqrestore(&adapter->mwifiex_cmd_lock, cmd_flags);
 	}
-	spin_unlock_irqrestore(&adapter->mwifiex_cmd_lock, cmd_flags);
+
 	/* Cancel all pending scan command */
 	spin_lock_irqsave(&adapter->scan_pending_q_lock,
 			  scan_pending_q_flags);
 	list_for_each_entry_safe(cmd_node, tmp_node,
 				 &adapter->scan_pending_q, list) {
-		if (cmd_node->wq_buf == wait_queue) {
-			list_del(&cmd_node->list);
-			spin_unlock_irqrestore(&adapter->scan_pending_q_lock,
-					       scan_pending_q_flags);
-			cmd_node->wq_buf = NULL;
-			mwifiex_insert_cmd_to_free_q(adapter, cmd_node);
-			spin_lock_irqsave(&adapter->scan_pending_q_lock,
-					  scan_pending_q_flags);
-			cancel_scan_cmd = true;
-		}
+		list_del(&cmd_node->list);
+		spin_unlock_irqrestore(&adapter->scan_pending_q_lock,
+				       scan_pending_q_flags);
+		cmd_node->wait_q_enabled = false;
+		mwifiex_insert_cmd_to_free_q(adapter, cmd_node);
+		spin_lock_irqsave(&adapter->scan_pending_q_lock,
+				  scan_pending_q_flags);
+		cancel_scan_cmd = true;
 	}
 	spin_unlock_irqrestore(&adapter->scan_pending_q_lock,
 			       scan_pending_q_flags);
@@ -1022,8 +987,8 @@ mwifiex_cancel_pending_ioctl(struct mwifiex_adapter *adapter,
 		adapter->scan_processing = false;
 		spin_unlock_irqrestore(&adapter->mwifiex_cmd_lock, cmd_flags);
 	}
-	wait_queue->status = MWIFIEX_ERROR_CMD_CANCEL;
-	mwifiex_ioctl_complete(adapter, wait_queue, -1);
+	adapter->cmd_wait_q.status = -1;
+	mwifiex_complete_cmd(adapter);
 
 	return;
 }
diff --git a/drivers/net/wireless/mwifiex/debugfs.c b/drivers/net/wireless/mwifiex/debugfs.c
index 63b0969..77d7c77 100644
--- a/drivers/net/wireless/mwifiex/debugfs.c
+++ b/drivers/net/wireless/mwifiex/debugfs.c
@@ -129,8 +129,8 @@ static struct mwifiex_debug_data items[] = {
 	 item_addr(event_received), 1},
 
 	/* variables defined in struct mwifiex_adapter */
-	{"ioctl_pending", adapter_item_size(ioctl_pending),
-	 adapter_item_addr(ioctl_pending), 1},
+	{"cmd_pending", adapter_item_size(cmd_pending),
+	 adapter_item_addr(cmd_pending), 1},
 	{"tx_pending", adapter_item_size(tx_pending),
 	 adapter_item_addr(tx_pending), 1},
 	{"rx_pending", adapter_item_size(rx_pending),
diff --git a/drivers/net/wireless/mwifiex/decl.h b/drivers/net/wireless/mwifiex/decl.h
index c3c15f9..8364b62 100644
--- a/drivers/net/wireless/mwifiex/decl.h
+++ b/drivers/net/wireless/mwifiex/decl.h
@@ -61,23 +61,6 @@
 
 #define MWIFIEX_BUF_FLAG_REQUEUED_PKT      BIT(0)
 
-enum mwifiex_error_code {
-	MWIFIEX_ERROR_NO_ERROR = 0,
-	MWIFIEX_ERROR_FW_NOT_READY = 0x00000001,
-	MWIFIEX_ERROR_FW_BUSY,
-	MWIFIEX_ERROR_FW_CMDRESP,
-	MWIFIEX_ERROR_PKT_SIZE_INVALID = 0x80000001,
-	MWIFIEX_ERROR_PKT_TIMEOUT,
-	MWIFIEX_ERROR_CMD_INVALID,
-	MWIFIEX_ERROR_CMD_TIMEOUT,
-	MWIFIEX_ERROR_CMD_DNLD_FAIL,
-	MWIFIEX_ERROR_CMD_CANCEL,
-	MWIFIEX_ERROR_CMD_RESP_FAIL,
-	MWIFIEX_ERROR_ASSOC_FAIL,
-	MWIFIEX_ERROR_EVENT_UNKNOWN,
-	MWIFIEX_ERROR_INVALID_PARAMETER,
-};
-
 enum mwifiex_bss_type {
 	MWIFIEX_BSS_TYPE_STA = 0,
 	MWIFIEX_BSS_TYPE_UAP = 1,
@@ -112,12 +95,9 @@ struct mwifiex_802_11_ssid {
 };
 
 struct mwifiex_wait_queue {
-	u32 bss_index;
-	wait_queue_head_t *wait;
-	u16 *condition;
-	u32 start_time;
+	wait_queue_head_t wait;
+	u16 condition;
 	int status;
-	u32 enabled;
 };
 
 struct mwifiex_rxinfo {
diff --git a/drivers/net/wireless/mwifiex/init.c b/drivers/net/wireless/mwifiex/init.c
index 8189862..26931d5 100644
--- a/drivers/net/wireless/mwifiex/init.c
+++ b/drivers/net/wireless/mwifiex/init.c
@@ -35,7 +35,6 @@ static int mwifiex_add_bss_prio_tbl(struct mwifiex_private *priv)
 {
 	struct mwifiex_adapter *adapter = priv->adapter;
 	struct mwifiex_bss_prio_node *bss_prio;
-	int status = 0;
 	unsigned long flags;
 
 	bss_prio = kzalloc(sizeof(struct mwifiex_bss_prio_node), GFP_KERNEL);
@@ -59,7 +58,7 @@ static int mwifiex_add_bss_prio_tbl(struct mwifiex_private *priv)
 	spin_unlock_irqrestore(&adapter->bss_prio_tbl[priv->bss_priority]
 			.bss_prio_lock, flags);
 
-	return status;
+	return 0;
 }
 
 /*
diff --git a/drivers/net/wireless/mwifiex/join.c b/drivers/net/wireless/mwifiex/join.c
index 7a9e0b5..60d25c6 100644
--- a/drivers/net/wireless/mwifiex/join.c
+++ b/drivers/net/wireless/mwifiex/join.c
@@ -590,11 +590,10 @@ int mwifiex_cmd_802_11_associate(struct mwifiex_private *priv,
  * an association success (0) or failure (non-zero).
  */
 int mwifiex_ret_802_11_associate(struct mwifiex_private *priv,
-			     struct host_cmd_ds_command *resp, void *wq_buf)
+			     struct host_cmd_ds_command *resp)
 {
+	struct mwifiex_adapter *adapter = priv->adapter;
 	int ret = 0;
-	struct mwifiex_wait_queue *wait_queue =
-		(struct mwifiex_wait_queue *) wq_buf;
 	struct ieee_types_assoc_rsp *assoc_rsp;
 	struct mwifiex_bssdescriptor *bss_desc;
 	u8 enable_data = true;
@@ -718,16 +717,11 @@ int mwifiex_ret_802_11_associate(struct mwifiex_private *priv,
 
 done:
 	/* Need to indicate IOCTL complete */
-	if (wait_queue) {
-		if (ret) {
-			if (assoc_rsp->status_code)
-				wait_queue->status =
-					le16_to_cpu(assoc_rsp->status_code);
-			else
-				wait_queue->status = MWIFIEX_ERROR_ASSOC_FAIL;
-		} else {
-			wait_queue->status = MWIFIEX_ERROR_NO_ERROR;
-		}
+	if (adapter->curr_cmd->wait_q_enabled) {
+		if (ret)
+			adapter->cmd_wait_q.status = -1;
+		else
+			adapter->cmd_wait_q.status = 0;
 	}
 
 	return ret;
@@ -885,9 +879,9 @@ mwifiex_cmd_802_11_ad_hoc_start(struct mwifiex_private *priv,
 	mwifiex_get_active_data_rates(priv, adhoc_start->DataRate);
 	if ((adapter->adhoc_start_band & BAND_G) &&
 	    (priv->curr_pkt_filter & HostCmd_ACT_MAC_ADHOC_G_PROTECTION_ON)) {
-		ret = mwifiex_prepare_cmd(priv, HostCmd_CMD_MAC_CONTROL,
-					  HostCmd_ACT_GEN_SET,
-					  0, NULL, &priv->curr_pkt_filter);
+		ret = mwifiex_send_cmd_async(priv, HostCmd_CMD_MAC_CONTROL,
+					     HostCmd_ACT_GEN_SET, 0,
+					     &priv->curr_pkt_filter);
 
 		if (ret) {
 			dev_err(adapter->dev,
@@ -1066,9 +1060,9 @@ mwifiex_cmd_802_11_ad_hoc_join(struct mwifiex_private *priv,
 			priv->
 			curr_pkt_filter | HostCmd_ACT_MAC_ADHOC_G_PROTECTION_ON;
 
-		ret = mwifiex_prepare_cmd(priv, HostCmd_CMD_MAC_CONTROL,
-					  HostCmd_ACT_GEN_SET, 0, NULL,
-					  &curr_pkt_filter);
+		ret = mwifiex_send_cmd_async(priv, HostCmd_CMD_MAC_CONTROL,
+					     HostCmd_ACT_GEN_SET, 0,
+					     &curr_pkt_filter);
 		if (ret) {
 			dev_err(priv->adapter->dev,
 			       "ADHOC_J_CMD: G Protection config failed\n");
@@ -1192,11 +1186,10 @@ mwifiex_cmd_802_11_ad_hoc_join(struct mwifiex_private *priv,
  * saves the beacon buffer.
  */
 int mwifiex_ret_802_11_ad_hoc(struct mwifiex_private *priv,
-			      struct host_cmd_ds_command *resp, void *wq_buf)
+			      struct host_cmd_ds_command *resp)
 {
 	int ret = 0;
-	struct mwifiex_wait_queue *wait_queue =
-		(struct mwifiex_wait_queue *) wq_buf;
+	struct mwifiex_adapter *adapter = priv->adapter;
 	struct host_cmd_ds_802_11_ad_hoc_result *adhoc_result;
 	struct mwifiex_bssdescriptor *bss_desc;
 	u16 command = le16_to_cpu(resp->command);
@@ -1264,11 +1257,11 @@ int mwifiex_ret_802_11_ad_hoc(struct mwifiex_private *priv,
 
 done:
 	/* Need to indicate IOCTL complete */
-	if (wait_queue) {
+	if (adapter->curr_cmd->wait_q_enabled) {
 		if (ret)
-			wait_queue->status = MWIFIEX_ERROR_ASSOC_FAIL;
+			adapter->cmd_wait_q.status = -1;
 		else
-			wait_queue->status = MWIFIEX_ERROR_NO_ERROR;
+			adapter->cmd_wait_q.status = 0;
 
 	}
 
@@ -1283,7 +1276,7 @@ done:
  * command to firmware.
  */
 int mwifiex_associate(struct mwifiex_private *priv,
-		      void *wait_queue, struct mwifiex_bssdescriptor *bss_desc)
+		      struct mwifiex_bssdescriptor *bss_desc)
 {
 	int ret = 0;
 	u8 current_bssid[ETH_ALEN];
@@ -1301,9 +1294,8 @@ int mwifiex_associate(struct mwifiex_private *priv,
 	   retrieval */
 	priv->assoc_rsp_size = 0;
 
-	ret = mwifiex_prepare_cmd(priv, HostCmd_CMD_802_11_ASSOCIATE,
-				  HostCmd_ACT_GEN_SET, 0, wait_queue,
-				  bss_desc);
+	ret = mwifiex_send_cmd_sync(priv, HostCmd_CMD_802_11_ASSOCIATE,
+				    HostCmd_ACT_GEN_SET, 0, bss_desc);
 
 	return ret;
 }
@@ -1315,7 +1307,7 @@ int mwifiex_associate(struct mwifiex_private *priv,
  */
 int
 mwifiex_adhoc_start(struct mwifiex_private *priv,
-		    void *wait_queue, struct mwifiex_802_11_ssid *adhoc_ssid)
+		    struct mwifiex_802_11_ssid *adhoc_ssid)
 {
 	int ret = 0;
 
@@ -1326,9 +1318,8 @@ mwifiex_adhoc_start(struct mwifiex_private *priv,
 	dev_dbg(priv->adapter->dev, "info: curr_bss_params.band = %d\n",
 	       priv->curr_bss_params.band);
 
-	ret = mwifiex_prepare_cmd(priv, HostCmd_CMD_802_11_AD_HOC_START,
-				  HostCmd_ACT_GEN_SET, 0, wait_queue,
-				  adhoc_ssid);
+	ret = mwifiex_send_cmd_sync(priv, HostCmd_CMD_802_11_AD_HOC_START,
+				    HostCmd_ACT_GEN_SET, 0, adhoc_ssid);
 
 	return ret;
 }
@@ -1340,7 +1331,7 @@ mwifiex_adhoc_start(struct mwifiex_private *priv,
  * if already not connected to the requested SSID.
  */
 int mwifiex_adhoc_join(struct mwifiex_private *priv,
-		       void *wait_queue, struct mwifiex_bssdescriptor *bss_desc)
+		       struct mwifiex_bssdescriptor *bss_desc)
 {
 	int ret = 0;
 
@@ -1369,9 +1360,8 @@ int mwifiex_adhoc_join(struct mwifiex_private *priv,
 	dev_dbg(priv->adapter->dev, "info: curr_bss_params.band = %c\n",
 	       priv->curr_bss_params.band);
 
-	ret = mwifiex_prepare_cmd(priv, HostCmd_CMD_802_11_AD_HOC_JOIN,
-				  HostCmd_ACT_GEN_SET, 0, wait_queue,
-				  bss_desc);
+	ret = mwifiex_send_cmd_sync(priv, HostCmd_CMD_802_11_AD_HOC_JOIN,
+				    HostCmd_ACT_GEN_SET, 0, bss_desc);
 
 	return ret;
 }
@@ -1380,9 +1370,7 @@ int mwifiex_adhoc_join(struct mwifiex_private *priv,
  * This function deauthenticates/disconnects from infra network by sending
  * deauthentication request.
  */
-static int mwifiex_deauthenticate_infra(struct mwifiex_private *priv,
-					struct mwifiex_wait_queue *wait,
-					u8 *mac)
+static int mwifiex_deauthenticate_infra(struct mwifiex_private *priv, u8 *mac)
 {
 	u8 mac_address[ETH_ALEN];
 	int ret = 0;
@@ -1400,11 +1388,8 @@ static int mwifiex_deauthenticate_infra(struct mwifiex_private *priv,
 		       bss_descriptor.mac_address, ETH_ALEN);
 	}
 
-	ret = mwifiex_prepare_cmd(priv, HostCmd_CMD_802_11_DEAUTHENTICATE,
-				  HostCmd_ACT_GEN_SET, 0, wait, &mac_address);
-
-	if (!ret && wait)
-		ret = -EINPROGRESS;
+	ret = mwifiex_send_cmd_sync(priv, HostCmd_CMD_802_11_DEAUTHENTICATE,
+				    HostCmd_ACT_GEN_SET, 0, &mac_address);
 
 	return ret;
 }
@@ -1415,26 +1400,23 @@ static int mwifiex_deauthenticate_infra(struct mwifiex_private *priv,
  * In case of infra made, it sends deauthentication request, and
  * in case of ad-hoc mode, a stop network request is sent to the firmware.
  */
-int mwifiex_deauthenticate(struct mwifiex_private *priv,
-			   struct mwifiex_wait_queue *wait, u8 *mac)
+int mwifiex_deauthenticate(struct mwifiex_private *priv, u8 *mac)
 {
 	int ret = 0;
 
 	if (priv->media_connected) {
 		if (priv->bss_mode == NL80211_IFTYPE_STATION) {
-			ret = mwifiex_deauthenticate_infra(priv, wait, mac);
+			ret = mwifiex_deauthenticate_infra(priv, mac);
 		} else if (priv->bss_mode == NL80211_IFTYPE_ADHOC) {
-			ret = mwifiex_prepare_cmd(priv,
-					HostCmd_CMD_802_11_AD_HOC_STOP,
-					HostCmd_ACT_GEN_SET, 0, wait, NULL);
-
-			if (!ret && wait)
-				ret = -EINPROGRESS;
+			ret = mwifiex_send_cmd_sync(priv,
+						HostCmd_CMD_802_11_AD_HOC_STOP,
+						HostCmd_ACT_GEN_SET, 0, NULL);
 		}
 	}
 
 	return ret;
 }
+EXPORT_SYMBOL_GPL(mwifiex_deauthenticate);
 
 /*
  * This function converts band to radio type used in channel TLV.
diff --git a/drivers/net/wireless/mwifiex/main.c b/drivers/net/wireless/mwifiex/main.c
index ed89ca4..df665db 100644
--- a/drivers/net/wireless/mwifiex/main.c
+++ b/drivers/net/wireless/mwifiex/main.c
@@ -597,16 +597,23 @@ mwifiex_set_mac_address(struct net_device *dev, void *addr)
 {
 	struct mwifiex_private *priv = mwifiex_netdev_get_priv(dev);
 	struct sockaddr *hw_addr = (struct sockaddr *) addr;
+	int ret = 0;
 
 	memcpy(priv->curr_addr, hw_addr->sa_data, ETH_ALEN);
 
-	if (mwifiex_request_set_mac_address(priv)) {
-		dev_err(priv->adapter->dev, "set MAC address failed\n");
-		return -EFAULT;
-	}
+	/* Send request to firmware */
+	ret = mwifiex_send_cmd_sync(priv, HostCmd_CMD_802_11_MAC_ADDRESS,
+				    HostCmd_ACT_GEN_SET, 0, NULL);
+
+	if (!ret)
+		memcpy(priv->netdev->dev_addr, priv->curr_addr, ETH_ALEN);
+	else
+		dev_err(priv->adapter->dev, "set mac address failed: ret=%d"
+					    "\n", ret);
+
 	memcpy(dev->dev_addr, priv->curr_addr, ETH_ALEN);
 
-	return 0;
+	return ret;
 }
 
 /*
@@ -615,7 +622,20 @@ mwifiex_set_mac_address(struct net_device *dev, void *addr)
 static void mwifiex_set_multicast_list(struct net_device *dev)
 {
 	struct mwifiex_private *priv = mwifiex_netdev_get_priv(dev);
-	mwifiex_request_set_multicast_list(priv, dev);
+	struct mwifiex_multicast_list mcast_list;
+
+	if (dev->flags & IFF_PROMISC) {
+		mcast_list.mode = MWIFIEX_PROMISC_MODE;
+	} else if (dev->flags & IFF_ALLMULTI ||
+		   netdev_mc_count(dev) > MWIFIEX_MAX_MULTICAST_LIST_SIZE) {
+		mcast_list.mode = MWIFIEX_ALL_MULTI_MODE;
+	} else {
+		mcast_list.mode = MWIFIEX_MULTICAST_MODE;
+		if (netdev_mc_count(dev))
+			mcast_list.num_multicast_addr =
+				mwifiex_copy_mcast_addr(&mcast_list, dev);
+	}
+	mwifiex_request_set_multicast_list(priv, &mcast_list);
 }
 
 /*
@@ -677,9 +697,6 @@ mwifiex_init_priv_params(struct mwifiex_private *priv, struct net_device *dev)
 {
 	dev->netdev_ops = &mwifiex_netdev_ops;
 	/* Initialize private structure */
-	init_waitqueue_head(&priv->ioctl_wait_q);
-	init_waitqueue_head(&priv->cmd_wait_q);
-	init_waitqueue_head(&priv->w_stats_wait_q);
 	priv->current_key_index = 0;
 	priv->media_connected = false;
 	memset(&priv->nick_name, 0, sizeof(priv->nick_name));
@@ -808,32 +825,6 @@ mwifiex_remove_interface(struct mwifiex_adapter *adapter, u8 bss_index)
 }
 
 /*
- * Sends IOCTL request to shutdown firmware.
- *
- * This function allocates the IOCTL request buffer, fills it
- * with requisite parameters and calls the IOCTL handler.
- */
-int mwifiex_shutdown_fw(struct mwifiex_private *priv, u8 wait_option)
-{
-	struct mwifiex_wait_queue *wait = NULL;
-	int status = 0;
-
-	/* Allocate an IOCTL request buffer */
-	wait = mwifiex_alloc_fill_wait_queue(priv, wait_option);
-	if (!wait)
-		return -ENOMEM;
-
-	status = mwifiex_misc_ioctl_init_shutdown(priv->adapter, wait,
-						  MWIFIEX_FUNC_SHUTDOWN);
-
-	status = mwifiex_request_ioctl(priv, wait, status, wait_option);
-
-	kfree(wait);
-	return status;
-}
-EXPORT_SYMBOL_GPL(mwifiex_shutdown_fw);
-
-/*
  * This function check if command is pending.
  */
 int is_command_pending(struct mwifiex_adapter *adapter)
@@ -927,6 +918,10 @@ mwifiex_add_card(void *card, struct semaphore *sem,
 	adapter->is_suspended = false;
 	adapter->hs_activated = false;
 	init_waitqueue_head(&adapter->hs_activate_wait_q);
+	adapter->cmd_wait_q_required = false;
+	init_waitqueue_head(&adapter->cmd_wait_q.wait);
+	adapter->cmd_wait_q.condition = false;
+	adapter->cmd_wait_q.status = 0;
 
 	/* Create workqueue */
 	adapter->workqueue = create_workqueue("MWIFIEX_WORK_QUEUE");
@@ -1038,12 +1033,12 @@ int mwifiex_remove_card(struct mwifiex_adapter *adapter, struct semaphore *sem)
 	dev_dbg(adapter->dev, "cmd: mwifiex_shutdown_drv done\n");
 	if (atomic_read(&adapter->rx_pending) ||
 	    atomic_read(&adapter->tx_pending) ||
-	    atomic_read(&adapter->ioctl_pending)) {
+	    atomic_read(&adapter->cmd_pending)) {
 		dev_err(adapter->dev, "rx_pending=%d, tx_pending=%d, "
-		       "ioctl_pending=%d\n",
+		       "cmd_pending=%d\n",
 		       atomic_read(&adapter->rx_pending),
 		       atomic_read(&adapter->tx_pending),
-		       atomic_read(&adapter->ioctl_pending));
+		       atomic_read(&adapter->cmd_pending));
 	}
 
 	/* Remove interface */
diff --git a/drivers/net/wireless/mwifiex/main.h b/drivers/net/wireless/mwifiex/main.h
index 43ff149..7ead15e 100644
--- a/drivers/net/wireless/mwifiex/main.h
+++ b/drivers/net/wireless/mwifiex/main.h
@@ -42,11 +42,8 @@ extern const char driver_version[];
 extern struct mwifiex_adapter *g_adapter;
 
 enum {
-	MWIFIEX_NO_WAIT,
-	MWIFIEX_IOCTL_WAIT,
-	MWIFIEX_CMD_WAIT,
-	MWIFIEX_PROC_WAIT,
-	MWIFIEX_WSTATS_WAIT
+	MWIFIEX_ASYNC_CMD,
+	MWIFIEX_SYNC_CMD
 };
 
 #define DRV_MODE_STA       0x1
@@ -468,10 +465,6 @@ struct mwifiex_private {
 	u32 curr_bcn_size;
 	/* spin lock for beacon buffer */
 	spinlock_t curr_bcn_buf_lock;
-	u16 ioctl_wait_q_woken;
-	wait_queue_head_t ioctl_wait_q;
-	u16 cmd_wait_q_woken;
-	wait_queue_head_t cmd_wait_q;
 	struct wireless_dev *wdev;
 	struct mwifiex_chan_freq_power cfp;
 	char version_str[128];
@@ -480,8 +473,6 @@ struct mwifiex_private {
 #endif
 	u8 nick_name[16];
 	struct iw_statistics w_stats;
-	u16 w_stats_wait_q_woken;
-	wait_queue_head_t w_stats_wait_q;
 	u16 current_key_index;
 	struct semaphore async_sem;
 	u8 scan_pending_on_block;
@@ -552,7 +543,7 @@ struct cmd_ctrl_node {
 	struct sk_buff *cmd_skb;
 	struct sk_buff *resp_skb;
 	void *data_buf;
-	void *wq_buf;
+	u32 wait_q_enabled;
 	struct sk_buff *skb;
 };
 
@@ -590,7 +581,7 @@ struct mwifiex_adapter {
 	struct mwifiex_if_ops if_ops;
 	atomic_t rx_pending;
 	atomic_t tx_pending;
-	atomic_t ioctl_pending;
+	atomic_t cmd_pending;
 	struct workqueue_struct *workqueue;
 	struct work_struct main_work;
 	struct mwifiex_bss_prio_tbl bss_prio_tbl[MWIFIEX_MAX_BSS_NUM];
@@ -684,6 +675,8 @@ struct mwifiex_adapter {
 	struct mwifiex_dbg dbg;
 	u8 arp_filter[ARP_FILTER_MAX_BUF_SIZE];
 	u32 arp_filter_size;
+	u16 cmd_wait_q_required;
+	struct mwifiex_wait_queue cmd_wait_q;
 };
 
 int mwifiex_init_lock_list(struct mwifiex_adapter *adapter);
@@ -707,29 +700,23 @@ int mwifiex_recv_packet(struct mwifiex_adapter *, struct sk_buff *skb);
 
 int mwifiex_process_event(struct mwifiex_adapter *adapter);
 
-int mwifiex_ioctl_complete(struct mwifiex_adapter *adapter,
-			   struct mwifiex_wait_queue *ioctl_wq,
-			   int status);
+int mwifiex_complete_cmd(struct mwifiex_adapter *adapter);
 
-int mwifiex_prepare_cmd(struct mwifiex_private *priv,
-			uint16_t cmd_no,
-			u16 cmd_action,
-			u32 cmd_oid,
-			void *wait_queue, void *data_buf);
+int mwifiex_send_cmd_async(struct mwifiex_private *priv, uint16_t cmd_no,
+			   u16 cmd_action, u32 cmd_oid, void *data_buf);
+
+int mwifiex_send_cmd_sync(struct mwifiex_private *priv, uint16_t cmd_no,
+			  u16 cmd_action, u32 cmd_oid, void *data_buf);
 
 void mwifiex_cmd_timeout_func(unsigned long function_context);
 
-int mwifiex_misc_ioctl_init_shutdown(struct mwifiex_adapter *adapter,
-				     struct mwifiex_wait_queue *wait_queue,
-				     u32 func_init_shutdown);
 int mwifiex_get_debug_info(struct mwifiex_private *,
 			   struct mwifiex_debug_info *);
 
 int mwifiex_alloc_cmd_buffer(struct mwifiex_adapter *adapter);
 int mwifiex_free_cmd_buffer(struct mwifiex_adapter *adapter);
 void mwifiex_cancel_all_pending_cmd(struct mwifiex_adapter *adapter);
-void mwifiex_cancel_pending_ioctl(struct mwifiex_adapter *adapter,
-				  struct mwifiex_wait_queue *ioctl_wq);
+void mwifiex_cancel_pending_ioctl(struct mwifiex_adapter *adapter);
 
 void mwifiex_insert_cmd_to_free_q(struct mwifiex_adapter *adapter,
 				  struct cmd_ctrl_node *cmd_node);
@@ -772,24 +759,21 @@ int mwifiex_sta_prepare_cmd(struct mwifiex_private *, uint16_t cmd_no,
 			    u16 cmd_action, u32 cmd_oid,
 			    void *data_buf, void *cmd_buf);
 int mwifiex_process_sta_cmdresp(struct mwifiex_private *, u16 cmdresp_no,
-				void *cmd_buf, void *ioctl);
+				void *cmd_buf);
 int mwifiex_process_sta_rx_packet(struct mwifiex_adapter *,
 				  struct sk_buff *skb);
 int mwifiex_process_sta_event(struct mwifiex_private *);
 void *mwifiex_process_sta_txpd(struct mwifiex_private *, struct sk_buff *skb);
 int mwifiex_sta_init_cmd(struct mwifiex_private *, u8 first_sta);
-int mwifiex_scan_networks(struct mwifiex_private *priv, void *wait_queue,
-			  u16 action,
-			  const struct mwifiex_user_scan_cfg
-			  *user_scan_in, struct mwifiex_scan_resp *);
+int mwifiex_scan_networks(struct mwifiex_private *priv,
+			  const struct mwifiex_user_scan_cfg *user_scan_in);
 int mwifiex_cmd_802_11_scan(struct mwifiex_private *priv,
 			    struct host_cmd_ds_command *cmd,
 			    void *data_buf);
 void mwifiex_queue_scan_cmd(struct mwifiex_private *priv,
 			    struct cmd_ctrl_node *cmd_node);
 int mwifiex_ret_802_11_scan(struct mwifiex_private *priv,
-			    struct host_cmd_ds_command *resp,
-			    void *wait_queue);
+			    struct host_cmd_ds_command *resp);
 s32 mwifiex_find_ssid_in_list(struct mwifiex_private *priv,
 				struct mwifiex_802_11_ssid *ssid, u8 *bssid,
 				u32 mode);
@@ -799,23 +783,20 @@ int mwifiex_find_best_network(struct mwifiex_private *priv,
 			      struct mwifiex_ssid_bssid *req_ssid_bssid);
 s32 mwifiex_ssid_cmp(struct mwifiex_802_11_ssid *ssid1,
 		       struct mwifiex_802_11_ssid *ssid2);
-int mwifiex_associate(struct mwifiex_private *priv, void *wait_queue,
+int mwifiex_associate(struct mwifiex_private *priv,
 		      struct mwifiex_bssdescriptor *bss_desc);
 int mwifiex_cmd_802_11_associate(struct mwifiex_private *priv,
 				 struct host_cmd_ds_command
 				 *cmd, void *data_buf);
 int mwifiex_ret_802_11_associate(struct mwifiex_private *priv,
-				 struct host_cmd_ds_command *resp,
-				 void *wait_queue);
+				 struct host_cmd_ds_command *resp);
 void mwifiex_reset_connect_state(struct mwifiex_private *priv);
 void mwifiex_2040_coex_event(struct mwifiex_private *priv);
 u8 mwifiex_band_to_radio_type(u8 band);
-int mwifiex_deauthenticate(struct mwifiex_private *priv,
-			   struct mwifiex_wait_queue *wait_queue,
-			   u8 *mac);
-int mwifiex_adhoc_start(struct mwifiex_private *priv, void *wait_queue,
+int mwifiex_deauthenticate(struct mwifiex_private *priv, u8 *mac);
+int mwifiex_adhoc_start(struct mwifiex_private *priv,
 			struct mwifiex_802_11_ssid *adhoc_ssid);
-int mwifiex_adhoc_join(struct mwifiex_private *priv, void *wait_queue,
+int mwifiex_adhoc_join(struct mwifiex_private *priv,
 		       struct mwifiex_bssdescriptor *bss_desc);
 int mwifiex_cmd_802_11_ad_hoc_start(struct mwifiex_private *priv,
 				    struct host_cmd_ds_command *cmd,
@@ -824,8 +805,7 @@ int mwifiex_cmd_802_11_ad_hoc_join(struct mwifiex_private *priv,
 				   struct host_cmd_ds_command *cmd,
 				   void *data_buf);
 int mwifiex_ret_802_11_ad_hoc(struct mwifiex_private *priv,
-			      struct host_cmd_ds_command *resp,
-			      void *wait_queue);
+			      struct host_cmd_ds_command *resp);
 int mwifiex_cmd_802_11_bg_scan_query(struct mwifiex_private *priv,
 				     struct host_cmd_ds_command *cmd,
 				     void *data_buf);
@@ -943,52 +923,34 @@ mwifiex_netdev_get_priv(struct net_device *dev)
 	return (struct mwifiex_private *) (*(unsigned long *) netdev_priv(dev));
 }
 
-struct mwifiex_wait_queue *mwifiex_alloc_fill_wait_queue(
-				struct mwifiex_private *,
-				u8 wait_option);
 struct mwifiex_private *mwifiex_bss_index_to_priv(struct mwifiex_adapter
 						*adapter, u8 bss_index);
-int mwifiex_shutdown_fw(struct mwifiex_private *, u8);
-
+int mwifiex_init_shutdown_fw(struct mwifiex_private *priv,
+			     u32 func_init_shutdown);
 int mwifiex_add_card(void *, struct semaphore *, struct mwifiex_if_ops *);
 int mwifiex_remove_card(struct mwifiex_adapter *, struct semaphore *);
 
 void mwifiex_get_version(struct mwifiex_adapter *adapter, char *version,
 			 int maxlen);
-int mwifiex_request_set_mac_address(struct mwifiex_private *priv);
-void mwifiex_request_set_multicast_list(struct mwifiex_private *priv,
-					struct net_device *dev);
-int mwifiex_request_ioctl(struct mwifiex_private *priv,
-			  struct mwifiex_wait_queue *req,
-			  int, u8 wait_option);
-int mwifiex_disconnect(struct mwifiex_private *, u8, u8 *);
+int mwifiex_request_set_multicast_list(struct mwifiex_private *priv,
+			struct mwifiex_multicast_list *mcast_list);
+int mwifiex_copy_mcast_addr(struct mwifiex_multicast_list *mlist,
+			    struct net_device *dev);
+int mwifiex_wait_queue_complete(struct mwifiex_adapter *adapter);
 int mwifiex_bss_start(struct mwifiex_private *priv,
-		      u8 wait_option,
 		      struct mwifiex_ssid_bssid *ssid_bssid);
 int mwifiex_set_hs_params(struct mwifiex_private *priv,
-			      u16 action, u8 wait_option,
+			      u16 action, int cmd_type,
 			      struct mwifiex_ds_hs_cfg *hscfg);
-int mwifiex_cancel_hs(struct mwifiex_private *priv, u8 wait_option);
+int mwifiex_cancel_hs(struct mwifiex_private *priv, int cmd_type);
 int mwifiex_enable_hs(struct mwifiex_adapter *adapter);
-void mwifiex_process_ioctl_resp(struct mwifiex_private *priv,
-				struct mwifiex_wait_queue *req);
-u32 mwifiex_get_mode(struct mwifiex_private *priv, u8 wait_option);
 int mwifiex_get_signal_info(struct mwifiex_private *priv,
-			    u8 wait_option,
 			    struct mwifiex_ds_get_signal *signal);
 int mwifiex_drv_get_data_rate(struct mwifiex_private *priv,
 			      struct mwifiex_rate_cfg *rate);
-int mwifiex_get_channel_list(struct mwifiex_private *priv,
-			     u8 wait_option,
-			     struct mwifiex_chan_list *chanlist);
-int mwifiex_get_scan_table(struct mwifiex_private *priv,
-			   u8 wait_option,
-			   struct mwifiex_scan_resp *scanresp);
-int mwifiex_enable_wep_key(struct mwifiex_private *priv, u8 wait_option);
-int mwifiex_find_best_bss(struct mwifiex_private *priv, u8 wait_option,
+int mwifiex_find_best_bss(struct mwifiex_private *priv,
 			  struct mwifiex_ssid_bssid *ssid_bssid);
 int mwifiex_request_scan(struct mwifiex_private *priv,
-			 u8 wait_option,
 			 struct mwifiex_802_11_ssid *req_ssid);
 int mwifiex_set_user_scan_ioctl(struct mwifiex_private *priv,
 				struct mwifiex_user_scan_cfg *scan_req);
@@ -1024,27 +986,22 @@ int mwifiex_set_tx_rate_cfg(struct mwifiex_private *priv, int tx_rate_index);
 
 int mwifiex_get_tx_rate_cfg(struct mwifiex_private *priv, int *tx_rate_index);
 
-int mwifiex_drv_set_power(struct mwifiex_private *priv, bool power_on);
+int mwifiex_drv_set_power(struct mwifiex_private *priv, u32 *ps_mode);
 
 int mwifiex_drv_get_driver_version(struct mwifiex_adapter *adapter,
 				   char *version, int max_len);
 
-int mwifiex_set_tx_power(struct mwifiex_private *priv, int type, int dbm);
+int mwifiex_set_tx_power(struct mwifiex_private *priv,
+			 struct mwifiex_power_cfg *power_cfg);
 
 int mwifiex_main_process(struct mwifiex_adapter *);
 
-int mwifiex_bss_ioctl_channel(struct mwifiex_private *,
-			      u16 action,
-			      struct mwifiex_chan_freq_power *cfp);
+int mwifiex_bss_set_channel(struct mwifiex_private *,
+			    struct mwifiex_chan_freq_power *cfp);
 int mwifiex_bss_ioctl_find_bss(struct mwifiex_private *,
-			       struct mwifiex_wait_queue *,
 			       struct mwifiex_ssid_bssid *);
-int mwifiex_radio_ioctl_band_cfg(struct mwifiex_private *,
-				 u16 action,
-				 struct mwifiex_ds_band_cfg *);
-int mwifiex_snmp_mib_ioctl(struct mwifiex_private *,
-			   struct mwifiex_wait_queue *,
-			   u32 cmd_oid, u16 action, u32 *value);
+int mwifiex_set_radio_band_cfg(struct mwifiex_private *,
+			 struct mwifiex_ds_band_cfg *);
 int mwifiex_get_bss_info(struct mwifiex_private *,
 			 struct mwifiex_bss_info *);
 
diff --git a/drivers/net/wireless/mwifiex/scan.c b/drivers/net/wireless/mwifiex/scan.c
index 6bb52d0..12fe021 100644
--- a/drivers/net/wireless/mwifiex/scan.c
+++ b/drivers/net/wireless/mwifiex/scan.c
@@ -178,9 +178,8 @@ mwifiex_ssid_cmp(struct mwifiex_802_11_ssid *ssid1,
  * with requisite parameters and calls the IOCTL handler.
  */
 int mwifiex_find_best_bss(struct mwifiex_private *priv,
-			  u8 wait_option, struct mwifiex_ssid_bssid *ssid_bssid)
+			  struct mwifiex_ssid_bssid *ssid_bssid)
 {
-	struct mwifiex_wait_queue *wait = NULL;
 	struct mwifiex_ssid_bssid tmp_ssid_bssid;
 	int ret = 0;
 	u8 *mac = NULL;
@@ -188,14 +187,9 @@ int mwifiex_find_best_bss(struct mwifiex_private *priv,
 	if (!ssid_bssid)
 		return -1;
 
-	/* Allocate wait request buffer */
-	wait = mwifiex_alloc_fill_wait_queue(priv, wait_option);
-	if (!wait)
-		return -ENOMEM;
-
 	memcpy(&tmp_ssid_bssid, ssid_bssid,
 	       sizeof(struct mwifiex_ssid_bssid));
-	ret = mwifiex_bss_ioctl_find_bss(priv, wait, &tmp_ssid_bssid);
+	ret = mwifiex_bss_ioctl_find_bss(priv, &tmp_ssid_bssid);
 
 	if (!ret) {
 		memcpy(ssid_bssid, &tmp_ssid_bssid,
@@ -205,7 +199,6 @@ int mwifiex_find_best_bss(struct mwifiex_private *priv,
 				" %pM\n", ssid_bssid->ssid.ssid, mac);
 	}
 
-	kfree(wait);
 	return ret;
 }
 
@@ -221,22 +214,14 @@ int mwifiex_find_best_bss(struct mwifiex_private *priv,
 int mwifiex_set_user_scan_ioctl(struct mwifiex_private *priv,
 				struct mwifiex_user_scan_cfg *scan_req)
 {
-	struct mwifiex_wait_queue *wait = NULL;
 	int status = 0;
-	u8 wait_option = MWIFIEX_IOCTL_WAIT;
-
-	/* Allocate an IOCTL request buffer */
-	wait = mwifiex_alloc_fill_wait_queue(priv, wait_option);
-	if (!wait)
-		return -ENOMEM;
 
-	status = mwifiex_scan_networks(priv, wait, HostCmd_ACT_GEN_SET,
-				       scan_req, NULL);
+	priv->adapter->cmd_wait_q.condition = false;
 
-	status = mwifiex_request_ioctl(priv, wait, status, wait_option);
+	status = mwifiex_scan_networks(priv, scan_req);
+	if (!status)
+		status = mwifiex_wait_queue_complete(priv->adapter);
 
-	if (wait && (status != -EINPROGRESS))
-		kfree(wait);
 	return status;
 }
 
@@ -674,7 +659,7 @@ mwifiex_scan_create_channel_list(struct mwifiex_private *priv,
  * along with the other TLVs, to the firmware.
  */
 static int
-mwifiex_scan_channel_list(struct mwifiex_private *priv, void *wait_buf,
+mwifiex_scan_channel_list(struct mwifiex_private *priv,
 			  u32 max_chan_per_scan, u8 filtered_scan,
 			  struct mwifiex_scan_cmd_config *scan_cfg_out,
 			  struct mwifiex_ie_types_chan_list_param_set
@@ -808,9 +793,9 @@ mwifiex_scan_channel_list(struct mwifiex_private *priv, void *wait_buf,
 
 		/* Send the scan command to the firmware with the specified
 		   cfg */
-		ret = mwifiex_prepare_cmd(priv, HostCmd_CMD_802_11_SCAN,
-					  HostCmd_ACT_GEN_SET,
-					  0, wait_buf, scan_cfg_out);
+		ret = mwifiex_send_cmd_async(priv, HostCmd_CMD_802_11_SCAN,
+					     HostCmd_ACT_GEN_SET, 0,
+					     scan_cfg_out);
 		if (ret)
 			break;
 	}
@@ -2271,9 +2256,7 @@ mwifiex_scan_delete_ssid_table_entry(struct mwifiex_private *priv,
  * update the internal driver scan table.
  */
 int mwifiex_scan_networks(struct mwifiex_private *priv,
-			  void *wait_buf, u16 action,
-			  const struct mwifiex_user_scan_cfg *user_scan_in,
-			  struct mwifiex_scan_resp *scan_resp)
+			  const struct mwifiex_user_scan_cfg *user_scan_in)
 {
 	int ret = 0;
 	struct mwifiex_adapter *adapter = priv->adapter;
@@ -2288,18 +2271,7 @@ int mwifiex_scan_networks(struct mwifiex_private *priv,
 	u8 max_chan_per_scan;
 	unsigned long flags;
 
-	if (action == HostCmd_ACT_GEN_GET) {
-		if (scan_resp) {
-			scan_resp->scan_table = (u8 *) adapter->scan_table;
-			scan_resp->num_in_scan_table =
-				adapter->num_in_scan_table;
-		} else {
-			ret = -1;
-		}
-		return ret;
-	}
-
-	if (adapter->scan_processing && action == HostCmd_ACT_GEN_SET) {
+	if (adapter->scan_processing) {
 		dev_dbg(adapter->dev, "cmd: Scan already in process...\n");
 		return ret;
 	}
@@ -2308,7 +2280,7 @@ int mwifiex_scan_networks(struct mwifiex_private *priv,
 	adapter->scan_processing = true;
 	spin_unlock_irqrestore(&adapter->mwifiex_cmd_lock, flags);
 
-	if (priv->scan_block && action == HostCmd_ACT_GEN_SET) {
+	if (priv->scan_block) {
 		dev_dbg(adapter->dev,
 			"cmd: Scan is blocked during association...\n");
 		return ret;
@@ -2348,9 +2320,9 @@ int mwifiex_scan_networks(struct mwifiex_private *priv,
 		adapter->bcn_buf_end = adapter->bcn_buf;
 	}
 
-	ret = mwifiex_scan_channel_list(priv, wait_buf, max_chan_per_scan,
-					filtered_scan, &scan_cfg_out->config,
-					chan_list_out, scan_chan_list);
+	ret = mwifiex_scan_channel_list(priv, max_chan_per_scan, filtered_scan,
+					&scan_cfg_out->config, chan_list_out,
+					scan_chan_list);
 
 	/* Get scan command from scan_pending_q and put to cmd_pending_q */
 	if (!ret) {
@@ -2367,7 +2339,6 @@ int mwifiex_scan_networks(struct mwifiex_private *priv,
 			spin_unlock_irqrestore(&adapter->scan_pending_q_lock,
 					       flags);
 		}
-		ret = -EINPROGRESS;
 	} else {
 		spin_lock_irqsave(&adapter->mwifiex_cmd_lock, flags);
 		adapter->scan_processing = true;
@@ -2437,11 +2408,10 @@ int mwifiex_cmd_802_11_scan(struct mwifiex_private *priv,
  *      .-------------------------------------------------------------.
  */
 int mwifiex_ret_802_11_scan(struct mwifiex_private *priv,
-			    struct host_cmd_ds_command *resp, void *wq_buf)
+			    struct host_cmd_ds_command *resp)
 {
 	int ret = 0;
 	struct mwifiex_adapter *adapter = priv->adapter;
-	struct mwifiex_wait_queue *wait_queue = NULL;
 	struct cmd_ctrl_node *cmd_node = NULL;
 	struct host_cmd_ds_802_11_scan_rsp *scan_rsp = NULL;
 	struct mwifiex_bssdescriptor *bss_new_entry = NULL;
@@ -2653,13 +2623,9 @@ int mwifiex_ret_802_11_scan(struct mwifiex_private *priv,
 		mwifiex_process_scan_results(priv);
 
 		/* Need to indicate IOCTL complete */
-		wait_queue = (struct mwifiex_wait_queue *) wq_buf;
-		if (wait_queue) {
-			wait_queue->status = MWIFIEX_ERROR_NO_ERROR;
-
-			/* Indicate ioctl complete */
-			mwifiex_ioctl_complete(adapter,
-			       (struct mwifiex_wait_queue *) wait_queue, 0);
+		if (adapter->curr_cmd->wait_q_enabled) {
+			adapter->cmd_wait_q.status = 0;
+			mwifiex_complete_cmd(adapter);
 		}
 		if (priv->report_scan_result)
 			priv->report_scan_result = false;
@@ -2853,6 +2819,7 @@ mwifiex_queue_scan_cmd(struct mwifiex_private *priv,
 	struct mwifiex_adapter *adapter = priv->adapter;
 	unsigned long flags;
 
+	cmd_node->wait_q_enabled = true;
 	spin_lock_irqsave(&adapter->scan_pending_q_lock, flags);
 	list_add_tail(&cmd_node->list, &adapter->scan_pending_q);
 	spin_unlock_irqrestore(&adapter->scan_pending_q_lock, flags);
@@ -2899,9 +2866,7 @@ int mwifiex_find_best_network(struct mwifiex_private *priv,
  * firmware, filtered on a specific SSID.
  */
 static int mwifiex_scan_specific_ssid(struct mwifiex_private *priv,
-				      void *wait_buf, u16 action,
-				      struct mwifiex_802_11_ssid *req_ssid,
-				      struct mwifiex_scan_resp *scan_resp)
+				      struct mwifiex_802_11_ssid *req_ssid)
 {
 	struct mwifiex_adapter *adapter = priv->adapter;
 	int ret = 0;
@@ -2910,24 +2875,12 @@ static int mwifiex_scan_specific_ssid(struct mwifiex_private *priv,
 	if (!req_ssid)
 		return -1;
 
-	if (action == HostCmd_ACT_GEN_GET) {
-		if (scan_resp) {
-			scan_resp->scan_table =
-				(u8 *) &priv->curr_bss_params.bss_descriptor;
-			scan_resp->num_in_scan_table =
-				adapter->num_in_scan_table;
-		} else {
-			ret = -1;
-		}
-		return ret;
-	}
-
-	if (adapter->scan_processing && action == HostCmd_ACT_GEN_SET) {
+	if (adapter->scan_processing) {
 		dev_dbg(adapter->dev, "cmd: Scan already in process...\n");
 		return ret;
 	}
 
-	if (priv->scan_block && action == HostCmd_ACT_GEN_SET) {
+	if (priv->scan_block) {
 		dev_dbg(adapter->dev,
 			"cmd: Scan is blocked during association...\n");
 		return ret;
@@ -2945,7 +2898,7 @@ static int mwifiex_scan_specific_ssid(struct mwifiex_private *priv,
 	       req_ssid->ssid_len);
 	scan_cfg->keep_previous_scan = true;
 
-	ret = mwifiex_scan_networks(priv, wait_buf, action, scan_cfg, NULL);
+	ret = mwifiex_scan_networks(priv, scan_cfg);
 
 	kfree(scan_cfg);
 	return ret;
@@ -2960,12 +2913,10 @@ static int mwifiex_scan_specific_ssid(struct mwifiex_private *priv,
  * Scan command can be issued for both normal scan and specific SSID
  * scan, depending upon whether an SSID is provided or not.
  */
-int mwifiex_request_scan(struct mwifiex_private *priv, u8 wait_option,
+int mwifiex_request_scan(struct mwifiex_private *priv,
 			 struct mwifiex_802_11_ssid *req_ssid)
 {
 	int ret = 0;
-	struct mwifiex_wait_queue *wait = NULL;
-	int status = 0;
 
 	if (down_interruptible(&priv->async_sem)) {
 		dev_err(priv->adapter->dev, "%s: acquire semaphore\n",
@@ -2974,32 +2925,23 @@ int mwifiex_request_scan(struct mwifiex_private *priv, u8 wait_option,
 	}
 	priv->scan_pending_on_block = true;
 
-	/* Allocate wait request buffer */
-	wait = mwifiex_alloc_fill_wait_queue(priv, wait_option);
-	if (!wait) {
-		ret = -1;
-		goto done;
-	}
+	priv->adapter->cmd_wait_q.condition = false;
 
 	if (req_ssid && req_ssid->ssid_len != 0)
 		/* Specific SSID scan */
-		status = mwifiex_scan_specific_ssid(priv, wait,
-						    HostCmd_ACT_GEN_SET,
-						    req_ssid, NULL);
+		ret = mwifiex_scan_specific_ssid(priv, req_ssid);
 	else
 		/* Normal scan */
-		status = mwifiex_scan_networks(priv, wait, HostCmd_ACT_GEN_SET,
-					       NULL, NULL);
-	status = mwifiex_request_ioctl(priv, wait, status, wait_option);
-	if (status == -1)
-		ret = -1;
-done:
-	if ((wait) && (status != -EINPROGRESS))
-		kfree(wait);
+		ret = mwifiex_scan_networks(priv, NULL);
+
+	if (!ret)
+		ret = mwifiex_wait_queue_complete(priv->adapter);
+
 	if (ret == -1) {
 		priv->scan_pending_on_block = false;
 		up(&priv->async_sem);
 	}
+
 	return ret;
 }
 
diff --git a/drivers/net/wireless/mwifiex/sdio.c b/drivers/net/wireless/mwifiex/sdio.c
index f21e5cd..f207756 100644
--- a/drivers/net/wireless/mwifiex/sdio.c
+++ b/drivers/net/wireless/mwifiex/sdio.c
@@ -208,7 +208,7 @@ static int mwifiex_sdio_resume(struct device *dev)
 
 	/* Disable Host Sleep */
 	mwifiex_cancel_hs(mwifiex_get_priv(adapter, MWIFIEX_BSS_ROLE_STA),
-			      MWIFIEX_NO_WAIT);
+			  MWIFIEX_ASYNC_CMD);
 
 	return 0;
 }
@@ -1745,13 +1745,12 @@ mwifiex_sdio_cleanup_module(void)
 	for (i = 0; i < adapter->priv_num; i++)
 		if ((GET_BSS_ROLE(adapter->priv[i]) == MWIFIEX_BSS_ROLE_STA) &&
 		    adapter->priv[i]->media_connected)
-			mwifiex_disconnect(adapter->priv[i], MWIFIEX_CMD_WAIT,
-					   NULL);
+			mwifiex_deauthenticate(adapter->priv[i], NULL);
 
 	if (!adapter->surprise_removed)
-		mwifiex_shutdown_fw(mwifiex_get_priv
-				    (adapter, MWIFIEX_BSS_ROLE_ANY),
-				    MWIFIEX_CMD_WAIT);
+		mwifiex_init_shutdown_fw(mwifiex_get_priv(adapter,
+							  MWIFIEX_BSS_ROLE_ANY),
+					 MWIFIEX_FUNC_SHUTDOWN);
 
 exit:
 	up(&add_remove_card_sem);
diff --git a/drivers/net/wireless/mwifiex/sta_cmd.c b/drivers/net/wireless/mwifiex/sta_cmd.c
index 19de652..dec4963 100644
--- a/drivers/net/wireless/mwifiex/sta_cmd.c
+++ b/drivers/net/wireless/mwifiex/sta_cmd.c
@@ -1135,65 +1135,66 @@ int mwifiex_sta_init_cmd(struct mwifiex_private *priv, u8 first_sta)
 
 	if (first_sta) {
 
-		ret = mwifiex_prepare_cmd(priv, HostCmd_CMD_FUNC_INIT,
-					  HostCmd_ACT_GEN_SET, 0, NULL, NULL);
+		ret = mwifiex_send_cmd_async(priv, HostCmd_CMD_FUNC_INIT,
+					     HostCmd_ACT_GEN_SET, 0, NULL);
 		if (ret)
 			return -1;
 		/* Read MAC address from HW */
-		ret = mwifiex_prepare_cmd(priv, HostCmd_CMD_GET_HW_SPEC,
-					  HostCmd_ACT_GEN_GET, 0, NULL, NULL);
+		ret = mwifiex_send_cmd_async(priv, HostCmd_CMD_GET_HW_SPEC,
+					     HostCmd_ACT_GEN_GET, 0, NULL);
 		if (ret)
 			return -1;
 
 		/* Reconfigure tx buf size */
-		ret = mwifiex_prepare_cmd(priv, HostCmd_CMD_RECONFIGURE_TX_BUFF,
-					  HostCmd_ACT_GEN_SET, 0, NULL,
-					  &priv->adapter->tx_buf_size);
+		ret = mwifiex_send_cmd_async(priv,
+					     HostCmd_CMD_RECONFIGURE_TX_BUFF,
+					     HostCmd_ACT_GEN_SET, 0,
+					     &priv->adapter->tx_buf_size);
 		if (ret)
 			return -1;
 
 		/* Enable IEEE PS by default */
 		priv->adapter->ps_mode = MWIFIEX_802_11_POWER_MODE_PSP;
-		ret = mwifiex_prepare_cmd(priv, HostCmd_CMD_802_11_PS_MODE_ENH,
-					  EN_AUTO_PS, BITMAP_STA_PS, NULL,
-					  NULL);
+		ret = mwifiex_send_cmd_async(priv,
+					     HostCmd_CMD_802_11_PS_MODE_ENH,
+					     EN_AUTO_PS, BITMAP_STA_PS, NULL);
 		if (ret)
 			return -1;
 	}
 
 	/* get tx rate */
-	ret = mwifiex_prepare_cmd(priv, HostCmd_CMD_TX_RATE_CFG,
-				  HostCmd_ACT_GEN_GET, 0, NULL, NULL);
+	ret = mwifiex_send_cmd_async(priv, HostCmd_CMD_TX_RATE_CFG,
+				     HostCmd_ACT_GEN_GET, 0, NULL);
 	if (ret)
 		return -1;
 	priv->data_rate = 0;
 
 	/* get tx power */
-	ret = mwifiex_prepare_cmd(priv, HostCmd_CMD_TXPWR_CFG,
-				  HostCmd_ACT_GEN_GET, 0, NULL, NULL);
+	ret = mwifiex_send_cmd_async(priv, HostCmd_CMD_TXPWR_CFG,
+				     HostCmd_ACT_GEN_GET, 0, NULL);
 	if (ret)
 		return -1;
 
 	/* set ibss coalescing_status */
-	ret = mwifiex_prepare_cmd(priv,
-				  HostCmd_CMD_802_11_IBSS_COALESCING_STATUS,
-				  HostCmd_ACT_GEN_SET, 0, NULL, &enable);
+	ret = mwifiex_send_cmd_async(priv,
+				     HostCmd_CMD_802_11_IBSS_COALESCING_STATUS,
+				     HostCmd_ACT_GEN_SET, 0, &enable);
 	if (ret)
 		return -1;
 
 	memset(&amsdu_aggr_ctrl, 0, sizeof(amsdu_aggr_ctrl));
 	amsdu_aggr_ctrl.enable = true;
 	/* Send request to firmware */
-	ret = mwifiex_prepare_cmd(priv, HostCmd_CMD_AMSDU_AGGR_CTRL,
-				  HostCmd_ACT_GEN_SET, 0, NULL,
-				  (void *) &amsdu_aggr_ctrl);
+	ret = mwifiex_send_cmd_async(priv, HostCmd_CMD_AMSDU_AGGR_CTRL,
+				     HostCmd_ACT_GEN_SET, 0,
+				     (void *) &amsdu_aggr_ctrl);
 	if (ret)
 		return -1;
 	/* MAC Control must be the last command in init_fw */
 	/* set MAC Control */
-	ret = mwifiex_prepare_cmd(priv, HostCmd_CMD_MAC_CONTROL,
-				  HostCmd_ACT_GEN_SET, 0, NULL,
-				  &priv->curr_pkt_filter);
+	ret = mwifiex_send_cmd_async(priv, HostCmd_CMD_MAC_CONTROL,
+				     HostCmd_ACT_GEN_SET, 0,
+				     &priv->curr_pkt_filter);
 	if (ret)
 		return -1;
 
@@ -1201,19 +1202,18 @@ int mwifiex_sta_init_cmd(struct mwifiex_private *priv, u8 first_sta)
 		/* Enable auto deep sleep */
 		auto_ds.auto_ds = DEEP_SLEEP_ON;
 		auto_ds.idle_time = DEEP_SLEEP_IDLE_TIME;
-		ret = mwifiex_prepare_cmd(priv,
-				HostCmd_CMD_802_11_PS_MODE_ENH,
-				EN_AUTO_PS, BITMAP_AUTO_DS, NULL,
-				&auto_ds);
+		ret = mwifiex_send_cmd_async(priv,
+					     HostCmd_CMD_802_11_PS_MODE_ENH,
+					     EN_AUTO_PS, BITMAP_AUTO_DS,
+					     &auto_ds);
 		if (ret)
 			return -1;
 	}
 
 	/* Send cmd to FW to enable/disable 11D function */
 	state_11d = ENABLE_11D;
-	ret = mwifiex_prepare_cmd(priv, HostCmd_CMD_802_11_SNMP_MIB,
-				  HostCmd_ACT_GEN_SET, DOT11D_I,
-				  NULL, &state_11d);
+	ret = mwifiex_send_cmd_async(priv, HostCmd_CMD_802_11_SNMP_MIB,
+				     HostCmd_ACT_GEN_SET, DOT11D_I, &state_11d);
 	if (ret)
 		dev_err(priv->adapter->dev, "11D: failed to enable 11D\n");
 
diff --git a/drivers/net/wireless/mwifiex/sta_cmdresp.c b/drivers/net/wireless/mwifiex/sta_cmdresp.c
index 648df69..8743c11 100644
--- a/drivers/net/wireless/mwifiex/sta_cmdresp.c
+++ b/drivers/net/wireless/mwifiex/sta_cmdresp.c
@@ -41,8 +41,7 @@
  */
 static void
 mwifiex_process_cmdresp_error(struct mwifiex_private *priv,
-			      struct host_cmd_ds_command *resp,
-			      struct mwifiex_wait_queue *wq_buf)
+			      struct host_cmd_ds_command *resp)
 {
 	struct cmd_ctrl_node *cmd_node = NULL, *tmp_node = NULL;
 	struct mwifiex_adapter *adapter = priv->adapter;
@@ -51,8 +50,9 @@ mwifiex_process_cmdresp_error(struct mwifiex_private *priv,
 
 	dev_err(adapter->dev, "CMD_RESP: cmd %#x error, result=%#x\n",
 			resp->command, resp->result);
-	if (wq_buf)
-		wq_buf->status = MWIFIEX_ERROR_FW_CMDRESP;
+
+	if (adapter->curr_cmd->wait_q_enabled)
+		adapter->cmd_wait_q.status = -1;
 
 	switch (le16_to_cpu(resp->command)) {
 	case HostCmd_CMD_802_11_PS_MODE_ENH:
@@ -328,9 +328,9 @@ static int mwifiex_ret_tx_rate_cfg(struct mwifiex_private *priv,
 	if (priv->is_data_rate_auto)
 		priv->data_rate = 0;
 	else
-		ret = mwifiex_prepare_cmd(priv,
+		ret = mwifiex_send_cmd_async(priv,
 					  HostCmd_CMD_802_11_TX_RATE_QUERY,
-					  HostCmd_ACT_GEN_GET, 0, NULL, NULL);
+					  HostCmd_ACT_GEN_GET, 0, NULL);
 
 	if (data_buf) {
 		ds_rate = (struct mwifiex_rate_cfg *) data_buf;
@@ -833,19 +833,17 @@ static int mwifiex_ret_ibss_coalescing_status(struct mwifiex_private *priv,
  * response handlers based on the command ID.
  */
 int mwifiex_process_sta_cmdresp(struct mwifiex_private *priv,
-				u16 cmdresp_no, void *cmd_buf, void *wq_buf)
+				u16 cmdresp_no, void *cmd_buf)
 {
 	int ret = 0;
 	struct mwifiex_adapter *adapter = priv->adapter;
 	struct host_cmd_ds_command *resp =
 		(struct host_cmd_ds_command *) cmd_buf;
-	struct mwifiex_wait_queue *wait_queue =
-		(struct mwifiex_wait_queue *) wq_buf;
 	void *data_buf = adapter->curr_cmd->data_buf;
 
 	/* If the command is not successful, cleanup and return failure */
 	if (resp->result != HostCmd_RESULT_OK) {
-		mwifiex_process_cmdresp_error(priv, resp, wait_queue);
+		mwifiex_process_cmdresp_error(priv, resp);
 		return -1;
 	}
 	/* Command successful, handle response */
@@ -865,12 +863,11 @@ int mwifiex_process_sta_cmdresp(struct mwifiex_private *priv,
 		ret = mwifiex_ret_tx_rate_cfg(priv, resp, data_buf);
 		break;
 	case HostCmd_CMD_802_11_SCAN:
-		ret = mwifiex_ret_802_11_scan(priv, resp, wait_queue);
-		wait_queue = NULL;
-		adapter->curr_cmd->wq_buf = NULL;
+		ret = mwifiex_ret_802_11_scan(priv, resp);
+		adapter->curr_cmd->wait_q_enabled = false;
 		break;
 	case HostCmd_CMD_802_11_BG_SCAN_QUERY:
-		ret = mwifiex_ret_802_11_scan(priv, resp, wait_queue);
+		ret = mwifiex_ret_802_11_scan(priv, resp);
 		dev_dbg(adapter->dev,
 			"info: CMD_RESP: BG_SCAN result is ready!\n");
 		break;
@@ -884,14 +881,14 @@ int mwifiex_process_sta_cmdresp(struct mwifiex_private *priv,
 		ret = mwifiex_ret_802_11_hs_cfg(priv, resp);
 		break;
 	case HostCmd_CMD_802_11_ASSOCIATE:
-		ret = mwifiex_ret_802_11_associate(priv, resp, wait_queue);
+		ret = mwifiex_ret_802_11_associate(priv, resp);
 		break;
 	case HostCmd_CMD_802_11_DEAUTHENTICATE:
 		ret = mwifiex_ret_802_11_deauthenticate(priv, resp);
 		break;
 	case HostCmd_CMD_802_11_AD_HOC_START:
 	case HostCmd_CMD_802_11_AD_HOC_JOIN:
-		ret = mwifiex_ret_802_11_ad_hoc(priv, resp, wait_queue);
+		ret = mwifiex_ret_802_11_ad_hoc(priv, resp);
 		break;
 	case HostCmd_CMD_802_11_AD_HOC_STOP:
 		ret = mwifiex_ret_802_11_ad_hoc_stop(priv, resp);
diff --git a/drivers/net/wireless/mwifiex/sta_event.c b/drivers/net/wireless/mwifiex/sta_event.c
index 936d7c1..fc265ca 100644
--- a/drivers/net/wireless/mwifiex/sta_event.c
+++ b/drivers/net/wireless/mwifiex/sta_event.c
@@ -271,8 +271,9 @@ int mwifiex_process_sta_event(struct mwifiex_private *priv)
 
 	case EVENT_HS_ACT_REQ:
 		dev_dbg(adapter->dev, "event: HS_ACT_REQ\n");
-		ret = mwifiex_prepare_cmd(priv, HostCmd_CMD_802_11_HS_CFG_ENH,
-					  0, 0, NULL, NULL);
+		ret = mwifiex_send_cmd_async(priv,
+					     HostCmd_CMD_802_11_HS_CFG_ENH,
+					     0, 0, NULL);
 		break;
 
 	case EVENT_MIC_ERR_UNICAST:
@@ -303,9 +304,9 @@ int mwifiex_process_sta_event(struct mwifiex_private *priv)
 		       sizeof(struct mwifiex_bssdescriptor) * IW_MAX_AP);
 		adapter->num_in_scan_table = 0;
 		adapter->bcn_buf_end = adapter->bcn_buf;
-		ret = mwifiex_prepare_cmd(priv,
-					  HostCmd_CMD_802_11_BG_SCAN_QUERY,
-					  HostCmd_ACT_GEN_GET, 0, NULL, NULL);
+		ret = mwifiex_send_cmd_async(priv,
+					     HostCmd_CMD_802_11_BG_SCAN_QUERY,
+					     HostCmd_ACT_GEN_GET, 0, NULL);
 		break;
 
 	case EVENT_PORT_RELEASE:
@@ -314,8 +315,8 @@ int mwifiex_process_sta_event(struct mwifiex_private *priv)
 
 	case EVENT_WMM_STATUS_CHANGE:
 		dev_dbg(adapter->dev, "event: WMM status changed\n");
-		ret = mwifiex_prepare_cmd(priv, HostCmd_CMD_WMM_GET_STATUS,
-					  0, 0, NULL, NULL);
+		ret = mwifiex_send_cmd_async(priv, HostCmd_CMD_WMM_GET_STATUS,
+					     0, 0, NULL);
 		break;
 
 	case EVENT_RSSI_LOW:
@@ -353,15 +354,15 @@ int mwifiex_process_sta_event(struct mwifiex_private *priv)
 		break;
 	case EVENT_IBSS_COALESCED:
 		dev_dbg(adapter->dev, "event: IBSS_COALESCED\n");
-		ret = mwifiex_prepare_cmd(priv,
+		ret = mwifiex_send_cmd_async(priv,
 				HostCmd_CMD_802_11_IBSS_COALESCING_STATUS,
-				HostCmd_ACT_GEN_GET, 0, NULL, NULL);
+				HostCmd_ACT_GEN_GET, 0, NULL);
 		break;
 	case EVENT_ADDBA:
 		dev_dbg(adapter->dev, "event: ADDBA Request\n");
-		mwifiex_prepare_cmd(priv, HostCmd_CMD_11N_ADDBA_RSP,
-				    HostCmd_ACT_GEN_SET, 0, NULL,
-				    adapter->event_body);
+		mwifiex_send_cmd_async(priv, HostCmd_CMD_11N_ADDBA_RSP,
+				       HostCmd_ACT_GEN_SET, 0,
+				       adapter->event_body);
 		break;
 	case EVENT_DELBA:
 		dev_dbg(adapter->dev, "event: DELBA Request\n");
diff --git a/drivers/net/wireless/mwifiex/sta_ioctl.c b/drivers/net/wireless/mwifiex/sta_ioctl.c
index 2fcdbc2..5f2ce94 100644
--- a/drivers/net/wireless/mwifiex/sta_ioctl.c
+++ b/drivers/net/wireless/mwifiex/sta_ioctl.c
@@ -33,9 +33,8 @@
  * size, and the calling function must ensure enough memory is
  * available.
  */
-static int
-mwifiex_copy_mcast_addr(struct mwifiex_multicast_list *mlist,
-			struct net_device *dev)
+int mwifiex_copy_mcast_addr(struct mwifiex_multicast_list *mlist,
+			    struct net_device *dev)
 {
 	int i = 0;
 	struct netdev_hw_addr *ha;
@@ -47,216 +46,51 @@ mwifiex_copy_mcast_addr(struct mwifiex_multicast_list *mlist,
 }
 
 /*
- * Allocate and fills a wait queue with proper parameters.
- *
- * This function needs to be called before an IOCTL request can be made.
- * It can handle the following wait options:
- *      MWIFIEX_NO_WAIT     - Waiting is disabled
- *      MWIFIEX_IOCTL_WAIT  - Waiting is done on IOCTL wait queue
- *      MWIFIEX_CMD_WAIT    - Waiting is done on command wait queue
- *      MWIFIEX_WSTATS_WAIT - Waiting is done on stats wait queue
- */
-struct mwifiex_wait_queue *
-mwifiex_alloc_fill_wait_queue(struct mwifiex_private *priv,
-			      u8 wait_option)
-{
-	struct mwifiex_wait_queue *wait = NULL;
-
-	wait = (struct mwifiex_wait_queue *)
-		kzalloc(sizeof(struct mwifiex_wait_queue), GFP_ATOMIC);
-	if (!wait) {
-		dev_err(priv->adapter->dev, "%s: fail to alloc buffer\n",
-						__func__);
-		return wait;
-	}
-
-	wait->bss_index = priv->bss_index;
-
-	switch (wait_option) {
-	case MWIFIEX_NO_WAIT:
-		wait->enabled = 0;
-		break;
-	case MWIFIEX_IOCTL_WAIT:
-		priv->ioctl_wait_q_woken = false;
-		wait->start_time = jiffies;
-		wait->wait = &priv->ioctl_wait_q;
-		wait->condition = &priv->ioctl_wait_q_woken;
-		wait->enabled = 1;
-		break;
-	case MWIFIEX_CMD_WAIT:
-		priv->cmd_wait_q_woken = false;
-		wait->start_time = jiffies;
-		wait->wait = &priv->cmd_wait_q;
-		wait->condition = &priv->cmd_wait_q_woken;
-		wait->enabled = 1;
-		break;
-	case MWIFIEX_WSTATS_WAIT:
-		priv->w_stats_wait_q_woken = false;
-		wait->start_time = jiffies;
-		wait->wait = &priv->w_stats_wait_q;
-		wait->condition = &priv->w_stats_wait_q_woken;
-		wait->enabled = 1;
-		break;
-	}
-
-	return wait;
-}
-
-/*
  * Wait queue completion handler.
  *
- * This function waits on a particular wait queue.
- * For NO_WAIT option, it returns immediately. It also cancels the
- * pending IOCTL request after waking up, in case of errors.
+ * This function waits on a cmd wait queue. It also cancels the pending
+ * request after waking up, in case of errors.
  */
-static void
-mwifiex_wait_ioctl_complete(struct mwifiex_private *priv,
-			    struct mwifiex_wait_queue *wait,
-			    u8 wait_option)
+int mwifiex_wait_queue_complete(struct mwifiex_adapter *adapter)
 {
 	bool cancel_flag = false;
+	int status = adapter->cmd_wait_q.status;
 
-	switch (wait_option) {
-	case MWIFIEX_NO_WAIT:
-		break;
-	case MWIFIEX_IOCTL_WAIT:
-		wait_event_interruptible(priv->ioctl_wait_q,
-					 priv->ioctl_wait_q_woken);
-		if (!priv->ioctl_wait_q_woken)
-			cancel_flag = true;
-		break;
-	case MWIFIEX_CMD_WAIT:
-		wait_event_interruptible(priv->cmd_wait_q,
-					 priv->cmd_wait_q_woken);
-		if (!priv->cmd_wait_q_woken)
-			cancel_flag = true;
-		break;
-	case MWIFIEX_WSTATS_WAIT:
-		wait_event_interruptible(priv->w_stats_wait_q,
-					 priv->w_stats_wait_q_woken);
-		if (!priv->w_stats_wait_q_woken)
-			cancel_flag = true;
-		break;
-	}
-	if (cancel_flag) {
-		mwifiex_cancel_pending_ioctl(priv->adapter, wait);
-		dev_dbg(priv->adapter->dev, "cmd: IOCTL cancel: wait=%p, wait_option=%d\n",
-			wait, wait_option);
-	}
+	dev_dbg(adapter->dev, "cmd pending\n");
+	atomic_inc(&adapter->cmd_pending);
 
-	return;
-}
+	/* Status pending, wake up main process */
+	queue_work(adapter->workqueue, &adapter->main_work);
 
-/*
- * The function waits for the request to complete and issues the
- * completion handler, if required.
- */
-int mwifiex_request_ioctl(struct mwifiex_private *priv,
-			  struct mwifiex_wait_queue *wait,
-			  int status, u8 wait_option)
-{
-	switch (status) {
-	case -EINPROGRESS:
-		dev_dbg(priv->adapter->dev, "cmd: IOCTL pending: wait=%p, wait_option=%d\n",
-				wait, wait_option);
-		atomic_inc(&priv->adapter->ioctl_pending);
-		/* Status pending, wake up main process */
-		queue_work(priv->adapter->workqueue, &priv->adapter->main_work);
-
-		/* Wait for completion */
-		if (wait_option) {
-			mwifiex_wait_ioctl_complete(priv, wait, wait_option);
-			status = wait->status;
-		}
-		break;
-	case 0:
-	case -1:
-	case -EBUSY:
-	default:
-		break;
-	}
-	return status;
-}
-EXPORT_SYMBOL_GPL(mwifiex_request_ioctl);
+	/* Wait for completion */
+	wait_event_interruptible(adapter->cmd_wait_q.wait,
+					adapter->cmd_wait_q.condition);
+	if (!adapter->cmd_wait_q.condition)
+		cancel_flag = true;
 
-/*
- * IOCTL request handler to set/get MAC address.
- *
- * This function prepares the correct firmware command and
- * issues it to get the extended version information.
- */
-static int mwifiex_bss_ioctl_mac_address(struct mwifiex_private *priv,
-					 struct mwifiex_wait_queue *wait,
-					 u8 action, u8 *mac)
-{
-	int ret = 0;
-
-	if ((action == HostCmd_ACT_GEN_GET) && mac) {
-		memcpy(mac, priv->curr_addr, ETH_ALEN);
-		return 0;
+	if (cancel_flag) {
+		mwifiex_cancel_pending_ioctl(adapter);
+		dev_dbg(adapter->dev, "cmd cancel\n");
 	}
+	adapter->cmd_wait_q.status = 0;
 
-	/* Send request to firmware */
-	ret = mwifiex_prepare_cmd(priv, HostCmd_CMD_802_11_MAC_ADDRESS,
-				  action, 0, wait, mac);
-	if (!ret)
-		ret = -EINPROGRESS;
-
-	return ret;
-}
-
-/*
- * Sends IOCTL request to set MAC address.
- *
- * This function allocates the IOCTL request buffer, fills it
- * with requisite parameters and calls the IOCTL handler.
- */
-int mwifiex_request_set_mac_address(struct mwifiex_private *priv)
-{
-	struct mwifiex_wait_queue *wait = NULL;
-	int status = 0;
-	u8 wait_option = MWIFIEX_CMD_WAIT;
-
-	/* Allocate wait buffer */
-	wait = mwifiex_alloc_fill_wait_queue(priv, wait_option);
-	if (!wait)
-		return -ENOMEM;
-
-	status = mwifiex_bss_ioctl_mac_address(priv, wait, HostCmd_ACT_GEN_SET,
-					       NULL);
-
-	status = mwifiex_request_ioctl(priv, wait, status, wait_option);
-	if (!status)
-		memcpy(priv->netdev->dev_addr, priv->curr_addr, ETH_ALEN);
-	else
-		dev_err(priv->adapter->dev, "set mac address failed: status=%d"
-				" error_code=%#x\n", status, wait->status);
-
-	kfree(wait);
 	return status;
 }
 
 /*
- * IOCTL request handler to set multicast list.
- *
  * This function prepares the correct firmware command and
  * issues it to set the multicast list.
  *
  * This function can be used to enable promiscuous mode, or enable all
  * multicast packets, or to enable selective multicast.
  */
-static int
-mwifiex_bss_ioctl_multicast_list(struct mwifiex_private *priv,
-				 struct mwifiex_wait_queue *wait,
-				 u16 action,
-				 struct mwifiex_multicast_list *mcast_list)
+int mwifiex_request_set_multicast_list(struct mwifiex_private *priv,
+				struct mwifiex_multicast_list *mcast_list)
 {
 	int ret = 0;
 	u16 old_pkt_filter;
 
 	old_pkt_filter = priv->curr_pkt_filter;
-	if (action == HostCmd_ACT_GEN_GET)
-		return -1;
 
 	if (mcast_list->mode == MWIFIEX_PROMISC_MODE) {
 		dev_dbg(priv->adapter->dev, "info: Enable Promiscuous mode\n");
@@ -281,16 +115,15 @@ mwifiex_bss_ioctl_multicast_list(struct mwifiex_private *priv,
 				/* Set multicast addresses to firmware */
 				if (old_pkt_filter == priv->curr_pkt_filter) {
 					/* Send request to firmware */
-					ret = mwifiex_prepare_cmd(priv,
+					ret = mwifiex_send_cmd_async(priv,
 						HostCmd_CMD_MAC_MULTICAST_ADR,
-						action, 0, wait, mcast_list);
-					if (!ret)
-						ret = -EINPROGRESS;
+						HostCmd_ACT_GEN_SET, 0,
+						mcast_list);
 				} else {
 					/* Send request to firmware */
-					ret = mwifiex_prepare_cmd(priv,
+					ret = mwifiex_send_cmd_async(priv,
 						HostCmd_CMD_MAC_MULTICAST_ADR,
-						action, 0, NULL,
+						HostCmd_ACT_GEN_SET, 0,
 						mcast_list);
 				}
 			}
@@ -300,101 +133,21 @@ mwifiex_bss_ioctl_multicast_list(struct mwifiex_private *priv,
 		"info: old_pkt_filter=%#x, curr_pkt_filter=%#x\n",
 	       old_pkt_filter, priv->curr_pkt_filter);
 	if (old_pkt_filter != priv->curr_pkt_filter) {
-		ret = mwifiex_prepare_cmd(priv, HostCmd_CMD_MAC_CONTROL, action,
-					  0, wait, &priv->curr_pkt_filter);
-		if (!ret)
-			ret = -EINPROGRESS;
+		ret = mwifiex_send_cmd_async(priv, HostCmd_CMD_MAC_CONTROL,
+					     HostCmd_ACT_GEN_SET,
+					     0, &priv->curr_pkt_filter);
 	}
 
 	return ret;
 }
 
 /*
- * Sends IOCTL request to set multicast list.
- *
- * This function allocates the IOCTL request buffer, fills it
- * with requisite parameters and calls the IOCTL handler.
- */
-void
-mwifiex_request_set_multicast_list(struct mwifiex_private *priv,
-				   struct net_device *dev)
-{
-	struct mwifiex_wait_queue *wait = NULL;
-	struct mwifiex_multicast_list mcast_list;
-	u8 wait_option = MWIFIEX_NO_WAIT;
-	int status = 0;
-
-	/* Allocate wait buffer */
-	wait = mwifiex_alloc_fill_wait_queue(priv, wait_option);
-	if (!wait)
-		return;
-
-	if (dev->flags & IFF_PROMISC) {
-		mcast_list.mode = MWIFIEX_PROMISC_MODE;
-	} else if (dev->flags & IFF_ALLMULTI ||
-		   netdev_mc_count(dev) > MWIFIEX_MAX_MULTICAST_LIST_SIZE) {
-		mcast_list.mode = MWIFIEX_ALL_MULTI_MODE;
-	} else {
-		mcast_list.mode = MWIFIEX_MULTICAST_MODE;
-		if (netdev_mc_count(dev))
-			mcast_list.num_multicast_addr =
-				mwifiex_copy_mcast_addr(&mcast_list, dev);
-	}
-	status = mwifiex_bss_ioctl_multicast_list(priv, wait,
-						  HostCmd_ACT_GEN_SET,
-						  &mcast_list);
-
-	status = mwifiex_request_ioctl(priv, wait, status, wait_option);
-	if (wait && status != -EINPROGRESS)
-		kfree(wait);
-
-	return;
-}
-
-/*
- * IOCTL request handler to disconnect from a BSS/IBSS.
- */
-static int mwifiex_bss_ioctl_stop(struct mwifiex_private *priv,
-				  struct mwifiex_wait_queue *wait, u8 *mac)
-{
-	return mwifiex_deauthenticate(priv, wait, mac);
-}
-
-/*
- * Sends IOCTL request to disconnect from a BSS.
- *
- * This function allocates the IOCTL request buffer, fills it
- * with requisite parameters and calls the IOCTL handler.
- */
-int mwifiex_disconnect(struct mwifiex_private *priv, u8 wait_option, u8 *mac)
-{
-	struct mwifiex_wait_queue *wait = NULL;
-	int status = 0;
-
-	/* Allocate wait buffer */
-	wait = mwifiex_alloc_fill_wait_queue(priv, wait_option);
-	if (!wait)
-		return -ENOMEM;
-
-	status = mwifiex_bss_ioctl_stop(priv, wait, mac);
-
-	status = mwifiex_request_ioctl(priv, wait, status, wait_option);
-
-	kfree(wait);
-	return status;
-}
-EXPORT_SYMBOL_GPL(mwifiex_disconnect);
-
-/*
- * IOCTL request handler to join a BSS/IBSS.
- *
  * In Ad-Hoc mode, the IBSS is created if not found in scan list.
  * In both Ad-Hoc and infra mode, an deauthentication is performed
  * first.
  */
-static int mwifiex_bss_ioctl_start(struct mwifiex_private *priv,
-				   struct mwifiex_wait_queue *wait,
-				   struct mwifiex_ssid_bssid *ssid_bssid)
+int mwifiex_bss_start(struct mwifiex_private *priv,
+		      struct mwifiex_ssid_bssid *ssid_bssid)
 {
 	int ret = 0;
 	struct mwifiex_adapter *adapter = priv->adapter;
@@ -406,7 +159,7 @@ static int mwifiex_bss_ioctl_start(struct mwifiex_private *priv,
 
 	if (priv->bss_mode == NL80211_IFTYPE_STATION) {
 		/* Infra mode */
-		ret = mwifiex_deauthenticate(priv, NULL, NULL);
+		ret = mwifiex_deauthenticate(priv, NULL);
 		if (ret)
 			return ret;
 
@@ -427,7 +180,7 @@ static int mwifiex_bss_ioctl_start(struct mwifiex_private *priv,
 		/* Clear any past association response stored for
 		 * application retrieval */
 		priv->assoc_rsp_size = 0;
-		ret = mwifiex_associate(priv, wait, &adapter->scan_table[i]);
+		ret = mwifiex_associate(priv, &adapter->scan_table[i]);
 		if (ret)
 			return ret;
 	} else {
@@ -441,7 +194,7 @@ static int mwifiex_bss_ioctl_start(struct mwifiex_private *priv,
 
 		/* Exit Adhoc mode first */
 		dev_dbg(adapter->dev, "info: Sending Adhoc Stop\n");
-		ret = mwifiex_deauthenticate(priv, NULL, NULL);
+		ret = mwifiex_deauthenticate(priv, NULL);
 		if (ret)
 			return ret;
 
@@ -460,75 +213,39 @@ static int mwifiex_bss_ioctl_start(struct mwifiex_private *priv,
 		if (i >= 0) {
 			dev_dbg(adapter->dev, "info: network found in scan"
 							" list. Joining...\n");
-			ret = mwifiex_adhoc_join(priv, wait,
-						 &adapter->scan_table[i]);
+			ret = mwifiex_adhoc_join(priv, &adapter->scan_table[i]);
 			if (ret)
 				return ret;
 		} else {	/* i >= 0 */
 			dev_dbg(adapter->dev, "info: Network not found in "
 				"the list, creating adhoc with ssid = %s\n",
 			       ssid_bssid->ssid.ssid);
-			ret = mwifiex_adhoc_start(priv, wait,
-						  &ssid_bssid->ssid);
+			ret = mwifiex_adhoc_start(priv, &ssid_bssid->ssid);
 			if (ret)
 				return ret;
 		}
 	}
 
-	if (!ret)
-		ret = -EINPROGRESS;
-
 	return ret;
 }
 
 /*
- * Sends IOCTL request to connect with a BSS.
- *
- * This function allocates the IOCTL request buffer, fills it
- * with requisite parameters and calls the IOCTL handler.
- */
-int mwifiex_bss_start(struct mwifiex_private *priv, u8 wait_option,
-		      struct mwifiex_ssid_bssid *ssid_bssid)
-{
-	struct mwifiex_wait_queue *wait = NULL;
-	struct mwifiex_ssid_bssid tmp_ssid_bssid;
-	int status = 0;
-
-	/* Stop the O.S. TX queue if needed */
-	if (!netif_queue_stopped(priv->netdev))
-		netif_stop_queue(priv->netdev);
-
-	/* Allocate wait buffer */
-	wait = mwifiex_alloc_fill_wait_queue(priv, wait_option);
-	if (!wait)
-		return -ENOMEM;
-
-	if (ssid_bssid)
-		memcpy(&tmp_ssid_bssid, ssid_bssid,
-		       sizeof(struct mwifiex_ssid_bssid));
-	status = mwifiex_bss_ioctl_start(priv, wait, &tmp_ssid_bssid);
-
-	status = mwifiex_request_ioctl(priv, wait, status, wait_option);
-
-	kfree(wait);
-	return status;
-}
-
-/*
  * IOCTL request handler to set host sleep configuration.
  *
  * This function prepares the correct firmware command and
  * issues it.
  */
-static int
-mwifiex_pm_ioctl_hs_cfg(struct mwifiex_private *priv,
-			struct mwifiex_wait_queue *wait,
-			u16 action, struct mwifiex_ds_hs_cfg *hs_cfg)
+int mwifiex_set_hs_params(struct mwifiex_private *priv, u16 action,
+			  int cmd_type, struct mwifiex_ds_hs_cfg *hs_cfg)
+
 {
 	struct mwifiex_adapter *adapter = priv->adapter;
 	int status = 0;
 	u32 prev_cond = 0;
 
+	if (!hs_cfg)
+		return -ENOMEM;
+
 	switch (action) {
 	case HostCmd_ACT_GEN_SET:
 		if (adapter->pps_uapsd_mode) {
@@ -561,12 +278,16 @@ mwifiex_pm_ioctl_hs_cfg(struct mwifiex_private *priv,
 				status = -1;
 				break;
 			}
-			status = mwifiex_prepare_cmd(priv,
-					HostCmd_CMD_802_11_HS_CFG_ENH,
-					HostCmd_ACT_GEN_SET,
-					0, wait, &adapter->hs_cfg);
-			if (!status)
-				status = -EINPROGRESS;
+			if (cmd_type == MWIFIEX_SYNC_CMD)
+				status = mwifiex_send_cmd_sync(priv,
+						HostCmd_CMD_802_11_HS_CFG_ENH,
+						HostCmd_ACT_GEN_SET, 0,
+						&adapter->hs_cfg);
+			else
+				status = mwifiex_send_cmd_async(priv,
+						HostCmd_CMD_802_11_HS_CFG_ENH,
+						HostCmd_ACT_GEN_SET, 0,
+						&adapter->hs_cfg);
 			if (hs_cfg->conditions == HOST_SLEEP_CFG_CANCEL)
 				/* Restore previous condition */
 				adapter->hs_cfg.conditions =
@@ -592,42 +313,12 @@ mwifiex_pm_ioctl_hs_cfg(struct mwifiex_private *priv,
 }
 
 /*
- * Sends IOCTL request to set Host Sleep parameters.
- *
- * This function allocates the IOCTL request buffer, fills it
- * with requisite parameters and calls the IOCTL handler.
- */
-int mwifiex_set_hs_params(struct mwifiex_private *priv, u16 action,
-			      u8 wait_option,
-			      struct mwifiex_ds_hs_cfg *hscfg)
-{
-	int ret = 0;
-	struct mwifiex_wait_queue *wait = NULL;
-
-	if (!hscfg)
-		return -ENOMEM;
-
-	/* Allocate wait buffer */
-	wait = mwifiex_alloc_fill_wait_queue(priv, wait_option);
-	if (!wait)
-		return -ENOMEM;
-
-	ret = mwifiex_pm_ioctl_hs_cfg(priv, wait, action, hscfg);
-
-	ret = mwifiex_request_ioctl(priv, wait, ret, wait_option);
-
-	if (wait && (ret != -EINPROGRESS))
-		kfree(wait);
-	return ret;
-}
-
-/*
  * Sends IOCTL request to cancel the existing Host Sleep configuration.
  *
  * This function allocates the IOCTL request buffer, fills it
  * with requisite parameters and calls the IOCTL handler.
  */
-int mwifiex_cancel_hs(struct mwifiex_private *priv, u8 wait_option)
+int mwifiex_cancel_hs(struct mwifiex_private *priv, int cmd_type)
 {
 	int ret = 0;
 	struct mwifiex_ds_hs_cfg hscfg;
@@ -636,7 +327,7 @@ int mwifiex_cancel_hs(struct mwifiex_private *priv, u8 wait_option)
 	hscfg.conditions = HOST_SLEEP_CFG_CANCEL;
 	hscfg.is_invoke_hostcmd = true;
 	ret = mwifiex_set_hs_params(priv, HostCmd_ACT_GEN_SET,
-					wait_option, &hscfg);
+				    cmd_type, &hscfg);
 
 	return ret;
 }
@@ -665,8 +356,8 @@ int mwifiex_enable_hs(struct mwifiex_adapter *adapter)
 
 	if (mwifiex_set_hs_params(mwifiex_get_priv(adapter,
 						       MWIFIEX_BSS_ROLE_STA),
-				      HostCmd_ACT_GEN_SET,
-				      MWIFIEX_IOCTL_WAIT, &hscfg)) {
+				  HostCmd_ACT_GEN_SET, MWIFIEX_SYNC_CMD,
+				  &hscfg)) {
 		dev_err(adapter->dev, "IOCTL request HS enable failed\n");
 		return false;
 	}
@@ -679,69 +370,6 @@ int mwifiex_enable_hs(struct mwifiex_adapter *adapter)
 EXPORT_SYMBOL_GPL(mwifiex_enable_hs);
 
 /*
- * IOCTL request handler to get signal information.
- *
- * This function prepares the correct firmware command and
- * issues it to get the signal (RSSI) information.
- *
- * This only works in the connected mode.
- */
-static int mwifiex_get_info_signal(struct mwifiex_private *priv,
-				   struct mwifiex_wait_queue *wait,
-				   struct mwifiex_ds_get_signal *signal)
-{
-	int ret = 0;
-
-	if (!wait) {
-		dev_err(priv->adapter->dev, "WAIT information is not present\n");
-		return -1;
-	}
-
-	/* Signal info can be obtained only if connected */
-	if (!priv->media_connected) {
-		dev_dbg(priv->adapter->dev,
-			"info: Can not get signal in disconnected state\n");
-		return -1;
-	}
-
-	/* Send request to firmware */
-	ret = mwifiex_prepare_cmd(priv, HostCmd_CMD_RSSI_INFO,
-				  HostCmd_ACT_GEN_GET, 0, wait, signal);
-
-	if (!ret)
-		ret = -EINPROGRESS;
-
-	return ret;
-}
-
-/*
- * IOCTL request handler to get statistics.
- *
- * This function prepares the correct firmware command and
- * issues it to get the statistics (RSSI) information.
- */
-static int mwifiex_get_info_stats(struct mwifiex_private *priv,
-			   struct mwifiex_wait_queue *wait,
-			   struct mwifiex_ds_get_stats *log)
-{
-	int ret = 0;
-
-	if (!wait) {
-		dev_err(priv->adapter->dev, "MWIFIEX IOCTL information is not present\n");
-		return -1;
-	}
-
-	/* Send request to firmware */
-	ret = mwifiex_prepare_cmd(priv, HostCmd_CMD_802_11_GET_LOG,
-				  HostCmd_ACT_GEN_GET, 0, wait, log);
-
-	if (!ret)
-		ret = -EINPROGRESS;
-
-	return ret;
-}
-
-/*
  * IOCTL request handler to get BSS information.
  *
  * This function collates the information from different driver structures
@@ -813,90 +441,20 @@ int mwifiex_get_bss_info(struct mwifiex_private *priv,
 }
 
 /*
- * IOCTL request handler to get extended version information.
- *
- * This function prepares the correct firmware command and
- * issues it to get the extended version information.
- */
-static int mwifiex_get_info_ver_ext(struct mwifiex_private *priv,
-				    struct mwifiex_wait_queue *wait,
-				    struct mwifiex_ver_ext *ver_ext)
-{
-	int ret = 0;
-
-	/* Send request to firmware */
-	ret = mwifiex_prepare_cmd(priv, HostCmd_CMD_VERSION_EXT,
-				  HostCmd_ACT_GEN_GET, 0, wait, ver_ext);
-	if (!ret)
-		ret = -EINPROGRESS;
-
-	return ret;
-}
-
-/*
- * IOCTL request handler to set/get SNMP MIB parameters.
- *
- * This function prepares the correct firmware command and
- * issues it.
+ * The function sets band configurations.
  *
- * Currently the following parameters are supported -
- *      Set/get RTS Threshold
- *      Set/get fragmentation threshold
- *      Set/get retry count
- */
-int mwifiex_snmp_mib_ioctl(struct mwifiex_private *priv,
-			   struct mwifiex_wait_queue *wait,
-			   u32 cmd_oid, u16 action, u32 *value)
-{
-	int ret = 0;
-
-	if (!value)
-		return -1;
-
-	/* Send request to firmware */
-	ret = mwifiex_prepare_cmd(priv, HostCmd_CMD_802_11_SNMP_MIB,
-				  action, cmd_oid, wait, value);
-
-	if (!ret)
-		ret = -EINPROGRESS;
-
-	return ret;
-}
-
-/*
- * IOCTL request handler to set/get band configurations.
- *
- * For SET operation, it performs extra checks to make sure the Ad-Hoc
+ * it performs extra checks to make sure the Ad-Hoc
  * band and channel are compatible. Otherwise it returns an error.
  *
- * For GET operation, this function retrieves the following information -
- *      - Infra bands
- *      - Ad-hoc band
- *      - Ad-hoc channel
- *      - Secondary channel offset
  */
-int mwifiex_radio_ioctl_band_cfg(struct mwifiex_private *priv,
-				 u16 action,
-				 struct mwifiex_ds_band_cfg *radio_cfg)
+int mwifiex_set_radio_band_cfg(struct mwifiex_private *priv,
+			       struct mwifiex_ds_band_cfg *radio_cfg)
 {
 	struct mwifiex_adapter *adapter = priv->adapter;
 	u8 infra_band = 0;
 	u8 adhoc_band = 0;
 	u32 adhoc_channel = 0;
 
-	if (action == HostCmd_ACT_GEN_GET) {
-		/* Infra Bands */
-		radio_cfg->config_bands = adapter->config_bands;
-		/* Adhoc Band */
-		radio_cfg->adhoc_start_band = adapter->adhoc_start_band;
-		/* Adhoc channel */
-		radio_cfg->adhoc_channel = priv->adhoc_channel;
-		/* Secondary channel offset */
-		radio_cfg->sec_chan_offset = adapter->chan_offset;
-		return 0;
-	}
-
-	/* For action = SET */
 	infra_band = (u8) radio_cfg->config_bands;
 	adhoc_band = (u8) radio_cfg->adhoc_start_band;
 	adhoc_channel = radio_cfg->adhoc_channel;
@@ -950,8 +508,8 @@ int mwifiex_radio_ioctl_band_cfg(struct mwifiex_private *priv,
  * This function performs validity checking on channel/frequency
  * compatibility and returns failure if not valid.
  */
-int mwifiex_bss_ioctl_channel(struct mwifiex_private *priv, u16 action,
-			      struct mwifiex_chan_freq_power *chan)
+int mwifiex_bss_set_channel(struct mwifiex_private *priv,
+			    struct mwifiex_chan_freq_power *chan)
 {
 	struct mwifiex_adapter *adapter = priv->adapter;
 	struct mwifiex_chan_freq_power *cfp = NULL;
@@ -959,16 +517,6 @@ int mwifiex_bss_ioctl_channel(struct mwifiex_private *priv, u16 action,
 	if (!chan)
 		return -1;
 
-	if (action == HostCmd_ACT_GEN_GET) {
-		cfp = mwifiex_get_cfp_by_band_and_channel_from_cfg80211(priv,
-				priv->curr_bss_params.band,
-				(u16) priv->curr_bss_params.bss_descriptor.
-					channel);
-		chan->channel = cfp->channel;
-		chan->freq = cfp->freq;
-
-		return 0;
-	}
 	if (!chan->channel && !chan->freq)
 		return -1;
 	if (adapter->adhoc_start_band & BAND_AN)
@@ -1024,7 +572,6 @@ int mwifiex_bss_ioctl_channel(struct mwifiex_private *priv, u16 action,
  * issues it to set or get the ad-hoc channel.
  */
 static int mwifiex_bss_ioctl_ibss_channel(struct mwifiex_private *priv,
-					  struct mwifiex_wait_queue *wait,
 					  u16 action, u16 *channel)
 {
 	int ret = 0;
@@ -1039,10 +586,8 @@ static int mwifiex_bss_ioctl_ibss_channel(struct mwifiex_private *priv,
 	}
 
 	/* Send request to firmware */
-	ret = mwifiex_prepare_cmd(priv, HostCmd_CMD_802_11_RF_CHANNEL,
-				  action, 0, wait, channel);
-	if (!ret)
-		ret = -EINPROGRESS;
+	ret = mwifiex_send_cmd_sync(priv, HostCmd_CMD_802_11_RF_CHANNEL,
+				    action, 0, channel);
 
 	return ret;
 }
@@ -1054,7 +599,6 @@ static int mwifiex_bss_ioctl_ibss_channel(struct mwifiex_private *priv,
  * these are provided, just the best BSS (best RSSI) is returned.
  */
 int mwifiex_bss_ioctl_find_bss(struct mwifiex_private *priv,
-			       struct mwifiex_wait_queue *wait,
 			       struct mwifiex_ssid_bssid *ssid_bssid)
 {
 	struct mwifiex_adapter *adapter = priv->adapter;
@@ -1114,10 +658,7 @@ int
 mwifiex_drv_change_adhoc_chan(struct mwifiex_private *priv, int channel)
 {
 	int ret = 0;
-	int status = 0;
 	struct mwifiex_bss_info bss_info;
-	struct mwifiex_wait_queue *wait = NULL;
-	u8 wait_option = MWIFIEX_IOCTL_WAIT;
 	struct mwifiex_ssid_bssid ssid_bssid;
 	u16 curr_chan = 0;
 
@@ -1127,19 +668,10 @@ mwifiex_drv_change_adhoc_chan(struct mwifiex_private *priv, int channel)
 	if (mwifiex_get_bss_info(priv, &bss_info))
 		return -1;
 
-	/* Allocate wait buffer */
-	wait = mwifiex_alloc_fill_wait_queue(priv, wait_option);
-	if (!wait)
-		return -ENOMEM;
-
 	/* Get current channel */
-	status = mwifiex_bss_ioctl_ibss_channel(priv, wait, HostCmd_ACT_GEN_GET,
-						&curr_chan);
+	ret = mwifiex_bss_ioctl_ibss_channel(priv, HostCmd_ACT_GEN_GET,
+					     &curr_chan);
 
-	if (mwifiex_request_ioctl(priv, wait, status, wait_option)) {
-		ret = -1;
-		goto done;
-	}
 	if (curr_chan == channel) {
 		ret = 0;
 		goto done;
@@ -1154,23 +686,13 @@ mwifiex_drv_change_adhoc_chan(struct mwifiex_private *priv, int channel)
 
 	/* Do disonnect */
 	memset(&ssid_bssid, 0, ETH_ALEN);
-	status = mwifiex_bss_ioctl_stop(priv, wait, ssid_bssid.bssid);
+	ret = mwifiex_deauthenticate(priv, ssid_bssid.bssid);
 
-	if (mwifiex_request_ioctl(priv, wait, status, wait_option)) {
-		ret = -1;
-		goto done;
-	}
-
-	status = mwifiex_bss_ioctl_ibss_channel(priv, wait, HostCmd_ACT_GEN_SET,
-						(u16 *) &channel);
-
-	if (mwifiex_request_ioctl(priv, wait, status, wait_option)) {
-		ret = -1;
-		goto done;
-	}
+	ret = mwifiex_bss_ioctl_ibss_channel(priv, HostCmd_ACT_GEN_SET,
+					     (u16 *) &channel);
 
 	/* Do specific SSID scanning */
-	if (mwifiex_request_scan(priv, wait_option, &bss_info.ssid)) {
+	if (mwifiex_request_scan(priv, &bss_info.ssid)) {
 		ret = -1;
 		goto done;
 	}
@@ -1179,13 +701,8 @@ mwifiex_drv_change_adhoc_chan(struct mwifiex_private *priv, int channel)
 	memcpy(&ssid_bssid.ssid, &bss_info.ssid,
 	       sizeof(struct mwifiex_802_11_ssid));
 
-	status = mwifiex_bss_ioctl_start(priv, wait, &ssid_bssid);
-
-	if (mwifiex_request_ioctl(priv, wait, status, wait_option))
-		ret = -1;
-
+	ret = mwifiex_bss_start(priv, &ssid_bssid);
 done:
-	kfree(wait);
 	return ret;
 }
 
@@ -1198,7 +715,6 @@ done:
  * for the band.
  */
 static int mwifiex_rate_ioctl_get_rate_value(struct mwifiex_private *priv,
-					     struct mwifiex_wait_queue *wait,
 					     struct mwifiex_rate_cfg *rate_cfg)
 {
 	struct mwifiex_adapter *adapter = priv->adapter;
@@ -1242,11 +758,9 @@ static int mwifiex_rate_ioctl_get_rate_value(struct mwifiex_private *priv,
 		}
 	} else {
 		/* Send request to firmware */
-		ret = mwifiex_prepare_cmd(priv,
-					  HostCmd_CMD_802_11_TX_RATE_QUERY,
-					  HostCmd_ACT_GEN_GET, 0, wait, NULL);
-		if (!ret)
-			ret = -EINPROGRESS;
+		ret = mwifiex_send_cmd_sync(priv,
+					    HostCmd_CMD_802_11_TX_RATE_QUERY,
+					    HostCmd_ACT_GEN_GET, 0, NULL);
 	}
 
 	return ret;
@@ -1261,7 +775,6 @@ static int mwifiex_rate_ioctl_get_rate_value(struct mwifiex_private *priv,
  * The function also performs validation checking on the supplied value.
  */
 static int mwifiex_rate_ioctl_set_rate_value(struct mwifiex_private *priv,
-					     struct mwifiex_wait_queue *wait,
 					     struct mwifiex_rate_cfg *rate_cfg)
 {
 	u8 rates[MWIFIEX_SUPPORTED_RATES];
@@ -1316,10 +829,8 @@ static int mwifiex_rate_ioctl_set_rate_value(struct mwifiex_private *priv,
 	}
 
 	/* Send request to firmware */
-	ret = mwifiex_prepare_cmd(priv, HostCmd_CMD_TX_RATE_CFG,
-				  HostCmd_ACT_GEN_SET, 0, wait, bitmap_rates);
-	if (!ret)
-		ret = -EINPROGRESS;
+	ret = mwifiex_send_cmd_sync(priv, HostCmd_CMD_TX_RATE_CFG,
+				    HostCmd_ACT_GEN_SET, 0, bitmap_rates);
 
 	return ret;
 }
@@ -1331,7 +842,6 @@ static int mwifiex_rate_ioctl_set_rate_value(struct mwifiex_private *priv,
  * rate index.
  */
 static int mwifiex_rate_ioctl_cfg(struct mwifiex_private *priv,
-				  struct mwifiex_wait_queue *wait,
 				  struct mwifiex_rate_cfg *rate_cfg)
 {
 	int status = 0;
@@ -1340,11 +850,9 @@ static int mwifiex_rate_ioctl_cfg(struct mwifiex_private *priv,
 		return -1;
 
 	if (rate_cfg->action == HostCmd_ACT_GEN_GET)
-		status = mwifiex_rate_ioctl_get_rate_value(
-				priv, wait, rate_cfg);
+		status = mwifiex_rate_ioctl_get_rate_value(priv, rate_cfg);
 	else
-		status = mwifiex_rate_ioctl_set_rate_value(
-				priv, wait, rate_cfg);
+		status = mwifiex_rate_ioctl_set_rate_value(priv, rate_cfg);
 
 	return status;
 }
@@ -1359,19 +867,11 @@ int mwifiex_drv_get_data_rate(struct mwifiex_private *priv,
 			      struct mwifiex_rate_cfg *rate)
 {
 	int ret = 0;
-	struct mwifiex_wait_queue *wait = NULL;
-	u8 wait_option = MWIFIEX_IOCTL_WAIT;
-
-	/* Allocate wait buffer */
-	wait = mwifiex_alloc_fill_wait_queue(priv, wait_option);
-	if (!wait)
-		return -ENOMEM;
 
 	memset(rate, 0, sizeof(struct mwifiex_rate_cfg));
 	rate->action = HostCmd_ACT_GEN_GET;
-	ret = mwifiex_rate_ioctl_cfg(priv, wait, rate);
+	ret = mwifiex_rate_ioctl_cfg(priv, rate);
 
-	ret = mwifiex_request_ioctl(priv, wait, ret, wait_option);
 	if (!ret) {
 		if (rate && rate->is_rate_auto)
 			rate->rate = mwifiex_index_to_data_rate(priv->adapter,
@@ -1382,7 +882,6 @@ int mwifiex_drv_get_data_rate(struct mwifiex_private *priv,
 		ret = -1;
 	}
 
-	kfree(wait);
 	return ret;
 }
 
@@ -1398,9 +897,8 @@ int mwifiex_drv_get_data_rate(struct mwifiex_private *priv,
  *      - Modulation class HTBW20
  *      - Modulation class HTBW40
  */
-static int mwifiex_power_ioctl_set_power(struct mwifiex_private *priv,
-					 struct mwifiex_wait_queue *wait,
-					 struct mwifiex_power_cfg *power_cfg)
+int mwifiex_set_tx_power(struct mwifiex_private *priv,
+			 struct mwifiex_power_cfg *power_cfg)
 {
 	int ret = 0;
 	struct host_cmd_ds_txpwr_cfg *txp_cfg = NULL;
@@ -1473,12 +971,10 @@ static int mwifiex_power_ioctl_set_power(struct mwifiex_private *priv,
 		pg->ht_bandwidth = HT_BW_40;
 	}
 	/* Send request to firmware */
-	ret = mwifiex_prepare_cmd(priv, HostCmd_CMD_TXPWR_CFG,
-				  HostCmd_ACT_GEN_SET, 0, wait, buf);
-	if (!ret)
-		ret = -EINPROGRESS;
-	kfree(buf);
+	ret = mwifiex_send_cmd_sync(priv, HostCmd_CMD_TXPWR_CFG,
+				    HostCmd_ACT_GEN_SET, 0, buf);
 
+	kfree(buf);
 	return ret;
 }
 
@@ -1488,33 +984,23 @@ static int mwifiex_power_ioctl_set_power(struct mwifiex_private *priv,
  * This function prepares the correct firmware command and
  * issues it.
  */
-static int mwifiex_pm_ioctl_ps_mode(struct mwifiex_private *priv,
-				    struct mwifiex_wait_queue *wait,
-				    u32 *ps_mode, u16 action)
+int mwifiex_drv_set_power(struct mwifiex_private *priv, u32 *ps_mode)
 {
 	int ret = 0;
 	struct mwifiex_adapter *adapter = priv->adapter;
 	u16 sub_cmd;
 
-	if (action == HostCmd_ACT_GEN_SET) {
-		if (*ps_mode)
-			adapter->ps_mode = MWIFIEX_802_11_POWER_MODE_PSP;
-		else
-			adapter->ps_mode = MWIFIEX_802_11_POWER_MODE_CAM;
-		sub_cmd = (*ps_mode) ? EN_AUTO_PS : DIS_AUTO_PS;
-		ret = mwifiex_prepare_cmd(priv, HostCmd_CMD_802_11_PS_MODE_ENH,
-					  sub_cmd, BITMAP_STA_PS, wait, NULL);
-		if ((!ret) && (sub_cmd == DIS_AUTO_PS))
-			ret = mwifiex_prepare_cmd(priv,
-					HostCmd_CMD_802_11_PS_MODE_ENH, GET_PS,
-					0, NULL, NULL);
-	} else {
-		ret = mwifiex_prepare_cmd(priv, HostCmd_CMD_802_11_PS_MODE_ENH,
-					  GET_PS, 0, wait, NULL);
-	}
-
-	if (!ret)
-		ret = -EINPROGRESS;
+	if (*ps_mode)
+		adapter->ps_mode = MWIFIEX_802_11_POWER_MODE_PSP;
+	else
+		adapter->ps_mode = MWIFIEX_802_11_POWER_MODE_CAM;
+	sub_cmd = (*ps_mode) ? EN_AUTO_PS : DIS_AUTO_PS;
+	ret = mwifiex_send_cmd_sync(priv, HostCmd_CMD_802_11_PS_MODE_ENH,
+				    sub_cmd, BITMAP_STA_PS, NULL);
+	if ((!ret) && (sub_cmd == DIS_AUTO_PS))
+		ret = mwifiex_send_cmd_async(priv,
+				HostCmd_CMD_802_11_PS_MODE_ENH, GET_PS,
+				0, NULL);
 
 	return ret;
 }
@@ -1600,18 +1086,14 @@ static int mwifiex_set_wapi_ie(struct mwifiex_private *priv,
  * This function prepares the correct firmware command and
  * issues it.
  */
-static int mwifiex_sec_ioctl_set_wapi_key(struct mwifiex_adapter *adapter,
-			       struct mwifiex_wait_queue *wait,
+static int mwifiex_sec_ioctl_set_wapi_key(struct mwifiex_private *priv,
 			       struct mwifiex_ds_encrypt_key *encrypt_key)
 {
 	int ret = 0;
-	struct mwifiex_private *priv = adapter->priv[wait->bss_index];
 
-	ret = mwifiex_prepare_cmd(priv, HostCmd_CMD_802_11_KEY_MATERIAL,
-				  HostCmd_ACT_GEN_SET, KEY_INFO_ENABLED,
-				  wait, encrypt_key);
-	if (!ret)
-		ret = -EINPROGRESS;
+	ret = mwifiex_send_cmd_sync(priv, HostCmd_CMD_802_11_KEY_MATERIAL,
+				    HostCmd_ACT_GEN_SET, KEY_INFO_ENABLED,
+				    encrypt_key);
 
 	return ret;
 }
@@ -1622,12 +1104,10 @@ static int mwifiex_sec_ioctl_set_wapi_key(struct mwifiex_adapter *adapter,
  * This function prepares the correct firmware command and
  * issues it, after validation checks.
  */
-static int mwifiex_sec_ioctl_set_wep_key(struct mwifiex_adapter *adapter,
-			      struct mwifiex_wait_queue *wait,
+static int mwifiex_sec_ioctl_set_wep_key(struct mwifiex_private *priv,
 			      struct mwifiex_ds_encrypt_key *encrypt_key)
 {
 	int ret = 0;
-	struct mwifiex_private *priv = adapter->priv[wait->bss_index];
 	struct mwifiex_wep_key *wep_key = NULL;
 	int index;
 
@@ -1641,7 +1121,7 @@ static int mwifiex_sec_ioctl_set_wep_key(struct mwifiex_adapter *adapter,
 		/* Copy the required key as the current key */
 		wep_key = &priv->wep_key[index];
 		if (!wep_key->key_length) {
-			dev_err(adapter->dev,
+			dev_err(priv->adapter->dev,
 				"key not set, so cannot enable it\n");
 			return -1;
 		}
@@ -1661,8 +1141,9 @@ static int mwifiex_sec_ioctl_set_wep_key(struct mwifiex_adapter *adapter,
 	}
 	if (wep_key->key_length) {
 		/* Send request to firmware */
-		ret = mwifiex_prepare_cmd(priv, HostCmd_CMD_802_11_KEY_MATERIAL,
-					  HostCmd_ACT_GEN_SET, 0, NULL, NULL);
+		ret = mwifiex_send_cmd_async(priv,
+					     HostCmd_CMD_802_11_KEY_MATERIAL,
+					     HostCmd_ACT_GEN_SET, 0, NULL);
 		if (ret)
 			return ret;
 	}
@@ -1672,11 +1153,9 @@ static int mwifiex_sec_ioctl_set_wep_key(struct mwifiex_adapter *adapter,
 		priv->curr_pkt_filter &= ~HostCmd_ACT_MAC_WEP_ENABLE;
 
 	/* Send request to firmware */
-	ret = mwifiex_prepare_cmd(priv, HostCmd_CMD_MAC_CONTROL,
-				  HostCmd_ACT_GEN_SET, 0, wait,
-				  &priv->curr_pkt_filter);
-	if (!ret)
-		ret = -EINPROGRESS;
+	ret = mwifiex_send_cmd_sync(priv, HostCmd_CMD_MAC_CONTROL,
+				    HostCmd_ACT_GEN_SET, 0,
+				    &priv->curr_pkt_filter);
 
 	return ret;
 }
@@ -1691,18 +1170,16 @@ static int mwifiex_sec_ioctl_set_wep_key(struct mwifiex_adapter *adapter,
  *
  * This function can also be used to disable a currently set key.
  */
-static int mwifiex_sec_ioctl_set_wpa_key(struct mwifiex_adapter *adapter,
-			      struct mwifiex_wait_queue *wait,
+static int mwifiex_sec_ioctl_set_wpa_key(struct mwifiex_private *priv,
 			      struct mwifiex_ds_encrypt_key *encrypt_key)
 {
 	int ret = 0;
-	struct mwifiex_private *priv = adapter->priv[wait->bss_index];
 	u8 remove_key = false;
 	struct host_cmd_ds_802_11_key_material *ibss_key;
 
 	/* Current driver only supports key length of up to 32 bytes */
 	if (encrypt_key->key_len > MWIFIEX_MAX_KEY_LENGTH) {
-		dev_err(adapter->dev, "key length too long\n");
+		dev_err(priv->adapter->dev, "key length too long\n");
 		return -1;
 	}
 
@@ -1713,9 +1190,10 @@ static int mwifiex_sec_ioctl_set_wpa_key(struct mwifiex_adapter *adapter,
 		 */
 		/* Send the key as PTK to firmware */
 		encrypt_key->key_index = MWIFIEX_KEY_INDEX_UNICAST;
-		ret = mwifiex_prepare_cmd(priv, HostCmd_CMD_802_11_KEY_MATERIAL,
-					  HostCmd_ACT_GEN_SET, KEY_INFO_ENABLED,
-					  NULL, encrypt_key);
+		ret = mwifiex_send_cmd_async(priv,
+					HostCmd_CMD_802_11_KEY_MATERIAL,
+					HostCmd_ACT_GEN_SET, KEY_INFO_ENABLED,
+					encrypt_key);
 		if (ret)
 			return ret;
 
@@ -1740,18 +1218,16 @@ static int mwifiex_sec_ioctl_set_wpa_key(struct mwifiex_adapter *adapter,
 
 	if (remove_key)
 		/* Send request to firmware */
-		ret = mwifiex_prepare_cmd(priv, HostCmd_CMD_802_11_KEY_MATERIAL,
-					  HostCmd_ACT_GEN_SET,
-					  !(KEY_INFO_ENABLED),
-					  wait, encrypt_key);
+		ret = mwifiex_send_cmd_sync(priv,
+				       HostCmd_CMD_802_11_KEY_MATERIAL,
+				       HostCmd_ACT_GEN_SET, !(KEY_INFO_ENABLED),
+				       encrypt_key);
 	else
 		/* Send request to firmware */
-		ret = mwifiex_prepare_cmd(priv, HostCmd_CMD_802_11_KEY_MATERIAL,
-					  HostCmd_ACT_GEN_SET, KEY_INFO_ENABLED,
-					  wait, encrypt_key);
-
-	if (!ret)
-		ret = -EINPROGRESS;
+		ret = mwifiex_send_cmd_sync(priv,
+					HostCmd_CMD_802_11_KEY_MATERIAL,
+					HostCmd_ACT_GEN_SET, KEY_INFO_ENABLED,
+					encrypt_key);
 
 	return ret;
 }
@@ -1764,21 +1240,16 @@ static int mwifiex_sec_ioctl_set_wpa_key(struct mwifiex_adapter *adapter,
  */
 static int
 mwifiex_sec_ioctl_encrypt_key(struct mwifiex_private *priv,
-			      struct mwifiex_wait_queue *wait,
 			      struct mwifiex_ds_encrypt_key *encrypt_key)
 {
 	int status = 0;
-	struct mwifiex_adapter *adapter = priv->adapter;
 
 	if (encrypt_key->is_wapi_key)
-		status = mwifiex_sec_ioctl_set_wapi_key(adapter, wait,
-							encrypt_key);
+		status = mwifiex_sec_ioctl_set_wapi_key(priv, encrypt_key);
 	else if (encrypt_key->key_len > WLAN_KEY_LEN_WEP104)
-		status = mwifiex_sec_ioctl_set_wpa_key(adapter, wait,
-						       encrypt_key);
+		status = mwifiex_sec_ioctl_set_wpa_key(priv, encrypt_key);
 	else
-		status = mwifiex_sec_ioctl_set_wep_key(adapter, wait,
-						       encrypt_key);
+		status = mwifiex_sec_ioctl_set_wep_key(priv, encrypt_key);
 	return status;
 }
 
@@ -1806,94 +1277,31 @@ mwifiex_drv_get_driver_version(struct mwifiex_adapter *adapter, char *version,
 }
 
 /*
- * Sends IOCTL request to set Tx power. It can be set to either auto
- * or a fixed value.
- *
- * This function allocates the IOCTL request buffer, fills it
- * with requisite parameters and calls the IOCTL handler.
- */
-int
-mwifiex_set_tx_power(struct mwifiex_private *priv, int type, int dbm)
-{
-	struct mwifiex_power_cfg power_cfg;
-	struct mwifiex_wait_queue *wait = NULL;
-	int status = 0;
-	int ret = 0;
-
-	wait = mwifiex_alloc_fill_wait_queue(priv, MWIFIEX_IOCTL_WAIT);
-	if (!wait)
-		return -ENOMEM;
-
-	if (type == NL80211_TX_POWER_FIXED) {
-		power_cfg.is_power_auto = 0;
-		power_cfg.power_level = dbm;
-	} else {
-		power_cfg.is_power_auto = 1;
-	}
-	status = mwifiex_power_ioctl_set_power(priv, wait, &power_cfg);
-
-	ret = mwifiex_request_ioctl(priv, wait, status, MWIFIEX_IOCTL_WAIT);
-
-	kfree(wait);
-	return ret;
-}
-
-/*
- * Sends IOCTL request to get scan table.
- *
- * This function allocates the IOCTL request buffer, fills it
- * with requisite parameters and calls the IOCTL handler.
- */
-int mwifiex_get_scan_table(struct mwifiex_private *priv, u8 wait_option,
-			   struct mwifiex_scan_resp *scan_resp)
-{
-	struct mwifiex_wait_queue *wait = NULL;
-	struct mwifiex_scan_resp scan;
-	int status = 0;
-
-	/* Allocate wait buffer */
-	wait = mwifiex_alloc_fill_wait_queue(priv, wait_option);
-	if (!wait)
-		return -ENOMEM;
-
-	status = mwifiex_scan_networks(priv, wait, HostCmd_ACT_GEN_GET,
-				       NULL, &scan);
-
-	status = mwifiex_request_ioctl(priv, wait, status, wait_option);
-	if (!status) {
-		if (scan_resp)
-			memcpy(scan_resp, &scan,
-			       sizeof(struct mwifiex_scan_resp));
-	}
-
-	if (wait && (status != -EINPROGRESS))
-		kfree(wait);
-	return status;
-}
-
-/*
  * Sends IOCTL request to get signal information.
  *
  * This function allocates the IOCTL request buffer, fills it
  * with requisite parameters and calls the IOCTL handler.
  */
-int mwifiex_get_signal_info(struct mwifiex_private *priv, u8 wait_option,
+int mwifiex_get_signal_info(struct mwifiex_private *priv,
 			    struct mwifiex_ds_get_signal *signal)
 {
 	struct mwifiex_ds_get_signal info;
-	struct mwifiex_wait_queue *wait = NULL;
 	int status = 0;
 
-	/* Allocate wait buffer */
-	wait = mwifiex_alloc_fill_wait_queue(priv, wait_option);
-	if (!wait)
-		return -ENOMEM;
-
+	memset(&info, 0, sizeof(struct mwifiex_ds_get_signal));
 	info.selector = ALL_RSSI_INFO_MASK;
 
-	status = mwifiex_get_info_signal(priv, wait, &info);
+	/* Signal info can be obtained only if connected */
+	if (!priv->media_connected) {
+		dev_dbg(priv->adapter->dev,
+			"info: Can not get signal in disconnected state\n");
+		return -1;
+	}
+
+	/* Send request to firmware */
+	status = mwifiex_send_cmd_sync(priv, HostCmd_CMD_RSSI_INFO,
+				       HostCmd_ACT_GEN_GET, 0, signal);
 
-	status = mwifiex_request_ioctl(priv, wait, status, wait_option);
 	if (!status) {
 		if (signal)
 			memcpy(signal, &info,
@@ -1904,8 +1312,6 @@ int mwifiex_get_signal_info(struct mwifiex_private *priv, u8 wait_option,
 			priv->w_stats.qual.noise = info.bcn_nf_avg;
 	}
 
-	if (wait && (status != -EINPROGRESS))
-		kfree(wait);
 	return status;
 }
 
@@ -1918,15 +1324,9 @@ int mwifiex_get_signal_info(struct mwifiex_private *priv, u8 wait_option,
 int mwifiex_set_encode(struct mwifiex_private *priv, const u8 *key,
 			int key_len, u8 key_index, int disable)
 {
-	struct mwifiex_wait_queue *wait = NULL;
 	struct mwifiex_ds_encrypt_key encrypt_key;
-	int status = 0;
 	int ret = 0;
 
-	wait = mwifiex_alloc_fill_wait_queue(priv, MWIFIEX_IOCTL_WAIT);
-	if (!wait)
-		return -ENOMEM;
-
 	memset(&encrypt_key, 0, sizeof(struct mwifiex_ds_encrypt_key));
 	encrypt_key.key_len = key_len;
 	if (!disable) {
@@ -1937,40 +1337,8 @@ int mwifiex_set_encode(struct mwifiex_private *priv, const u8 *key,
 		encrypt_key.key_disable = true;
 	}
 
-	status = mwifiex_sec_ioctl_encrypt_key(priv, wait, &encrypt_key);
-
-	if (mwifiex_request_ioctl(priv, wait, status, MWIFIEX_IOCTL_WAIT))
-		ret = -EFAULT;
-
-	kfree(wait);
-	return ret;
-}
-
-/*
- * Sends IOCTL request to set power management parameters.
- *
- * This function allocates the IOCTL request buffer, fills it
- * with requisite parameters and calls the IOCTL handler.
- */
-int
-mwifiex_drv_set_power(struct mwifiex_private *priv, bool power_on)
-{
-	int ret = 0;
-	int status = 0;
-	struct mwifiex_wait_queue *wait = NULL;
-	u32 ps_mode;
-
-	wait = mwifiex_alloc_fill_wait_queue(priv, MWIFIEX_IOCTL_WAIT);
-	if (!wait)
-		return -ENOMEM;
-
-	ps_mode = power_on;
-	status = mwifiex_pm_ioctl_ps_mode(priv, wait, &ps_mode,
-					  HostCmd_ACT_GEN_SET);
+	ret = mwifiex_sec_ioctl_encrypt_key(priv, &encrypt_key);
 
-	ret = mwifiex_request_ioctl(priv, wait, status, MWIFIEX_IOCTL_WAIT);
-
-	kfree(wait);
 	return ret;
 }
 
@@ -1984,26 +1352,17 @@ int
 mwifiex_get_ver_ext(struct mwifiex_private *priv)
 {
 	struct mwifiex_ver_ext ver_ext;
-	struct mwifiex_wait_queue *wait = NULL;
-	int status = 0;
 	int ret = 0;
-	u8 wait_option = MWIFIEX_IOCTL_WAIT;
-
-	/* Allocate wait buffer */
-	wait = mwifiex_alloc_fill_wait_queue(priv, wait_option);
-	if (!wait)
-		return -ENOMEM;
 
 	/* get fw version */
 	memset(&ver_ext, 0, sizeof(struct host_cmd_ds_version_ext));
-	status = mwifiex_get_info_ver_ext(priv, wait, &ver_ext);
-
-	ret = mwifiex_request_ioctl(priv, wait, status, wait_option);
+	/* Send request to firmware */
+	ret = mwifiex_send_cmd_sync(priv, HostCmd_CMD_VERSION_EXT,
+				    HostCmd_ACT_GEN_GET, 0, &ver_ext);
 
 	if (ret)
 		ret = -1;
 
-	kfree(wait);
 	return ret;
 }
 
@@ -2018,21 +1377,13 @@ mwifiex_get_stats_info(struct mwifiex_private *priv,
 		       struct mwifiex_ds_get_stats *log)
 {
 	int ret = 0;
-	int status = 0;
-	struct mwifiex_wait_queue *wait = NULL;
 	struct mwifiex_ds_get_stats get_log;
-	u8 wait_option = MWIFIEX_IOCTL_WAIT;
-
-	/* Allocate wait buffer */
-	wait = mwifiex_alloc_fill_wait_queue(priv, wait_option);
-	if (!wait)
-		return -ENOMEM;
 
 	memset(&get_log, 0, sizeof(struct mwifiex_ds_get_stats));
-	status = mwifiex_get_info_stats(priv, wait, &get_log);
+	/* Send request to firmware */
+	ret = mwifiex_send_cmd_sync(priv, HostCmd_CMD_802_11_GET_LOG,
+				    HostCmd_ACT_GEN_GET, 0, &get_log);
 
-	/* Send IOCTL request to MWIFIEX */
-	ret = mwifiex_request_ioctl(priv, wait, status, wait_option);
 	if (!ret) {
 		if (log)
 			memcpy(log, &get_log, sizeof(struct
@@ -2042,7 +1393,6 @@ mwifiex_get_stats_info(struct mwifiex_private *priv,
 		priv->w_stats.discard.misc = get_log.ack_failure;
 	}
 
-	kfree(wait);
 	return ret;
 }
 
@@ -2060,7 +1410,6 @@ mwifiex_get_stats_info(struct mwifiex_private *priv,
  *      - CAU
  */
 static int mwifiex_reg_mem_ioctl_reg_rw(struct mwifiex_private *priv,
-					struct mwifiex_wait_queue *wait,
 					struct mwifiex_ds_reg_rw *reg_rw,
 					u16 action)
 {
@@ -2088,10 +1437,7 @@ static int mwifiex_reg_mem_ioctl_reg_rw(struct mwifiex_private *priv,
 	}
 
 	/* Send request to firmware */
-	ret = mwifiex_prepare_cmd(priv, cmd_no, action, 0, wait, reg_rw);
-
-	if (!ret)
-		ret = -EINPROGRESS;
+	ret = mwifiex_send_cmd_sync(priv, cmd_no, action, 0, reg_rw);
 
 	return ret;
 }
@@ -2107,23 +1453,13 @@ mwifiex_reg_write(struct mwifiex_private *priv, u32 reg_type,
 		  u32 reg_offset, u32 reg_value)
 {
 	int ret = 0;
-	int status = 0;
-	struct mwifiex_wait_queue *wait = NULL;
 	struct mwifiex_ds_reg_rw reg_rw;
 
-	wait = mwifiex_alloc_fill_wait_queue(priv, MWIFIEX_IOCTL_WAIT);
-	if (!wait)
-		return -ENOMEM;
-
 	reg_rw.type = cpu_to_le32(reg_type);
 	reg_rw.offset = cpu_to_le32(reg_offset);
 	reg_rw.value = cpu_to_le32(reg_value);
-	status = mwifiex_reg_mem_ioctl_reg_rw(priv, wait, &reg_rw,
-					      HostCmd_ACT_GEN_SET);
+	ret = mwifiex_reg_mem_ioctl_reg_rw(priv, &reg_rw, HostCmd_ACT_GEN_SET);
 
-	ret = mwifiex_request_ioctl(priv, wait, status, MWIFIEX_IOCTL_WAIT);
-
-	kfree(wait);
 	return ret;
 }
 
@@ -2138,50 +1474,18 @@ mwifiex_reg_read(struct mwifiex_private *priv, u32 reg_type,
 		 u32 reg_offset, u32 *value)
 {
 	int ret = 0;
-	int status = 0;
-	struct mwifiex_wait_queue *wait = NULL;
 	struct mwifiex_ds_reg_rw reg_rw;
 
-	wait = mwifiex_alloc_fill_wait_queue(priv, MWIFIEX_IOCTL_WAIT);
-	if (!wait)
-		return -ENOMEM;
-
 	reg_rw.type = cpu_to_le32(reg_type);
 	reg_rw.offset = cpu_to_le32(reg_offset);
-	status = mwifiex_reg_mem_ioctl_reg_rw(priv, wait, &reg_rw,
-					      HostCmd_ACT_GEN_GET);
+	ret = mwifiex_reg_mem_ioctl_reg_rw(priv, &reg_rw, HostCmd_ACT_GEN_GET);
 
-	ret = mwifiex_request_ioctl(priv, wait, status, MWIFIEX_IOCTL_WAIT);
 	if (ret)
 		goto done;
 
 	*value = le32_to_cpu(reg_rw.value);
 
 done:
-	kfree(wait);
-	return ret;
-}
-
-/*
- * IOCTL request handler to read EEPROM.
- *
- * This function prepares the correct firmware command and
- * issues it.
- */
-static int
-mwifiex_reg_mem_ioctl_read_eeprom(struct mwifiex_private *priv,
-				  struct mwifiex_wait_queue *wait,
-				  struct mwifiex_ds_read_eeprom *rd_eeprom)
-{
-	int ret = 0;
-
-	/* Send request to firmware */
-	ret = mwifiex_prepare_cmd(priv, HostCmd_CMD_802_11_EEPROM_ACCESS,
-				  HostCmd_ACT_GEN_GET, 0, wait, rd_eeprom);
-
-	if (!ret)
-		ret = -EINPROGRESS;
-
 	return ret;
 }
 
@@ -2196,25 +1500,17 @@ mwifiex_eeprom_read(struct mwifiex_private *priv, u16 offset, u16 bytes,
 		    u8 *value)
 {
 	int ret = 0;
-	int status = 0;
-	struct mwifiex_wait_queue *wait = NULL;
 	struct mwifiex_ds_read_eeprom rd_eeprom;
 
-	wait = mwifiex_alloc_fill_wait_queue(priv, MWIFIEX_IOCTL_WAIT);
-	if (!wait)
-		return -ENOMEM;
-
 	rd_eeprom.offset = cpu_to_le16((u16) offset);
 	rd_eeprom.byte_count = cpu_to_le16((u16) bytes);
-	status = mwifiex_reg_mem_ioctl_read_eeprom(priv, wait, &rd_eeprom);
 
-	ret = mwifiex_request_ioctl(priv, wait, status, MWIFIEX_IOCTL_WAIT);
-	if (ret)
-		goto done;
+	/* Send request to firmware */
+	ret = mwifiex_send_cmd_sync(priv, HostCmd_CMD_802_11_EEPROM_ACCESS,
+				    HostCmd_ACT_GEN_GET, 0, &rd_eeprom);
 
-	memcpy(value, rd_eeprom.value, MAX_EEPROM_DATA);
-done:
-	kfree(wait);
+	if (!ret)
+		memcpy(value, rd_eeprom.value, MAX_EEPROM_DATA);
 	return ret;
 }
 
diff --git a/drivers/net/wireless/mwifiex/sta_tx.c b/drivers/net/wireless/mwifiex/sta_tx.c
index e8db6bd..b261d81 100644
--- a/drivers/net/wireless/mwifiex/sta_tx.c
+++ b/drivers/net/wireless/mwifiex/sta_tx.c
@@ -51,7 +51,7 @@ void *mwifiex_process_sta_txpd(struct mwifiex_private *priv,
 	if (!skb->len) {
 		dev_err(adapter->dev, "Tx: bad packet length: %d\n",
 		       skb->len);
-		tx_info->status_code = MWIFIEX_ERROR_PKT_SIZE_INVALID;
+		tx_info->status_code = -1;
 		return skb->data;
 	}
 
diff --git a/drivers/net/wireless/mwifiex/util.c b/drivers/net/wireless/mwifiex/util.c
index 205022a..9f65587 100644
--- a/drivers/net/wireless/mwifiex/util.c
+++ b/drivers/net/wireless/mwifiex/util.c
@@ -55,17 +55,12 @@ int mwifiex_shutdown_fw_complete(struct mwifiex_adapter *adapter)
 }
 
 /*
- * IOCTL request handler to send function init/shutdown command
+ * This function sends init/shutdown command
  * to firmware.
- *
- * This function prepares the correct firmware command and
- * issues it.
  */
-int mwifiex_misc_ioctl_init_shutdown(struct mwifiex_adapter *adapter,
-				     struct mwifiex_wait_queue *wait,
-				     u32 func_init_shutdown)
+int mwifiex_init_shutdown_fw(struct mwifiex_private *priv,
+			     u32 func_init_shutdown)
 {
-	struct mwifiex_private *priv = adapter->priv[wait->bss_index];
 	int ret;
 	u16 cmd;
 
@@ -74,19 +69,16 @@ int mwifiex_misc_ioctl_init_shutdown(struct mwifiex_adapter *adapter,
 	} else if (func_init_shutdown == MWIFIEX_FUNC_SHUTDOWN) {
 		cmd = HostCmd_CMD_FUNC_SHUTDOWN;
 	} else {
-		dev_err(adapter->dev, "unsupported parameter\n");
+		dev_err(priv->adapter->dev, "unsupported parameter\n");
 		return -1;
 	}
 
 	/* Send command to firmware */
-	ret = mwifiex_prepare_cmd(priv, cmd, HostCmd_ACT_GEN_SET,
-				  0, wait, NULL);
-
-	if (!ret)
-		ret = -EINPROGRESS;
+	ret = mwifiex_send_cmd_sync(priv, cmd, HostCmd_ACT_GEN_SET, 0, NULL);
 
 	return ret;
 }
+EXPORT_SYMBOL_GPL(mwifiex_init_shutdown_fw);
 
 /*
  * IOCTL request handler to set/get debug information.
@@ -222,31 +214,18 @@ int mwifiex_recv_complete(struct mwifiex_adapter *adapter,
  * corresponding waiting function. Otherwise, it processes the
  * IOCTL response and frees the response buffer.
  */
-int mwifiex_ioctl_complete(struct mwifiex_adapter *adapter,
-			   struct mwifiex_wait_queue *wait_queue,
-			   int status)
+int mwifiex_complete_cmd(struct mwifiex_adapter *adapter)
 {
-	enum mwifiex_error_code status_code =
-		(enum mwifiex_error_code) wait_queue->status;
-
-	atomic_dec(&adapter->ioctl_pending);
+	atomic_dec(&adapter->cmd_pending);
+	dev_dbg(adapter->dev, "cmd completed: status=%d\n",
+					adapter->cmd_wait_q.status);
 
-	dev_dbg(adapter->dev, "cmd: IOCTL completed: status=%d,"
-			" status_code=%#x\n", status, status_code);
+	adapter->cmd_wait_q.condition = true;
 
-	if (wait_queue->enabled) {
-		*wait_queue->condition = true;
-		wait_queue->status = status;
-		if (status && (status_code == MWIFIEX_ERROR_CMD_TIMEOUT))
-			dev_err(adapter->dev, "cmd timeout\n");
-		else
-			wake_up_interruptible(wait_queue->wait);
-	} else {
-		if (status)
-			dev_err(adapter->dev, "cmd failed: status_code=%#x\n",
-			       status_code);
-		kfree(wait_queue);
-	}
+	if (adapter->cmd_wait_q.status == -ETIMEDOUT)
+		dev_err(adapter->dev, "cmd timeout\n");
+	else
+		wake_up_interruptible(&adapter->cmd_wait_q.wait);
 
 	return 0;
 }
-- 
1.7.0.2

