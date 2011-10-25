Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wolverine02.qualcomm.com ([199.106.114.251]:4692 "EHLO
	wolverine02.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933612Ab1JYOJG (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 25 Oct 2011 10:09:06 -0400
From: Vasanthakumar Thiagarajan <vthiagar@qca.qualcomm.com>
To: <kvalo@qca.qualcomm.com>
CC: <linux-wireless@vger.kernel.org>
Subject: [PATCH V2 30/31] ath6kl: Initialize target wlan values for every vif
Date: Tue, 25 Oct 2011 19:34:25 +0530
Message-ID: <1319551466-29070-31-git-send-email-vthiagar@qca.qualcomm.com> (sfid-20111025_160914_131577_9A5A850D)
In-Reply-To: <1319551466-29070-1-git-send-email-vthiagar@qca.qualcomm.com>
References: <1319551466-29070-1-git-send-email-vthiagar@qca.qualcomm.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Wlan parameters need to be configured for every vif
in target.

Signed-off-by: Vasanthakumar Thiagarajan <vthiagar@qca.qualcomm.com>
---
 drivers/net/wireless/ath/ath6kl/debug.c |    4 +-
 drivers/net/wireless/ath/ath6kl/init.c  |   34 +++++++++++++++++++----------
 drivers/net/wireless/ath/ath6kl/wmi.c   |   35 ++++++++++++++++--------------
 drivers/net/wireless/ath/ath6kl/wmi.h   |   18 ++++++++-------
 4 files changed, 53 insertions(+), 38 deletions(-)

diff --git a/drivers/net/wireless/ath/ath6kl/debug.c b/drivers/net/wireless/ath/ath6kl/debug.c
index e515c83..725d598 100644
--- a/drivers/net/wireless/ath/ath6kl/debug.c
+++ b/drivers/net/wireless/ath/ath6kl/debug.c
@@ -1188,7 +1188,7 @@ static ssize_t ath6kl_keepalive_write(struct file *file,
 	if (ret)
 		return ret;
 
-	ret = ath6kl_wmi_set_keepalive_cmd(ar->wmi, val);
+	ret = ath6kl_wmi_set_keepalive_cmd(ar->wmi, 0, val);
 	if (ret)
 		return ret;
 
@@ -1233,7 +1233,7 @@ static ssize_t ath6kl_disconnect_timeout_write(struct file *file,
 	if (ret)
 		return ret;
 
-	ret = ath6kl_wmi_disctimeout_cmd(ar->wmi, val);
+	ret = ath6kl_wmi_disctimeout_cmd(ar->wmi, 0, val);
 	if (ret)
 		return ret;
 
diff --git a/drivers/net/wireless/ath/ath6kl/init.c b/drivers/net/wireless/ath/ath6kl/init.c
index 6f5bdff..49f1a94 100644
--- a/drivers/net/wireless/ath/ath6kl/init.c
+++ b/drivers/net/wireless/ath/ath6kl/init.c
@@ -352,7 +352,7 @@ void ath6kl_target_failure(struct ath6kl *ar)
 
 }
 
-static int ath6kl_target_config_wlan_params(struct ath6kl *ar)
+static int ath6kl_target_config_wlan_params(struct ath6kl *ar, int idx)
 {
 	int status = 0;
 	int ret;
@@ -362,46 +362,50 @@ static int ath6kl_target_config_wlan_params(struct ath6kl *ar)
 	 * default values. Required if checksum offload is needed. Set
 	 * RxMetaVersion to 2.
 	 */
-	if (ath6kl_wmi_set_rx_frame_format_cmd(ar->wmi,
+	if (ath6kl_wmi_set_rx_frame_format_cmd(ar->wmi, idx,
 					       ar->rx_meta_ver, 0, 0)) {
 		ath6kl_err("unable to set the rx frame format\n");
 		status = -EIO;
 	}
 
 	if (ar->conf_flags & ATH6KL_CONF_IGNORE_PS_FAIL_EVT_IN_SCAN)
-		if ((ath6kl_wmi_pmparams_cmd(ar->wmi, 0, 1, 0, 0, 1,
+		if ((ath6kl_wmi_pmparams_cmd(ar->wmi, idx, 0, 1, 0, 0, 1,
 		     IGNORE_POWER_SAVE_FAIL_EVENT_DURING_SCAN)) != 0) {
 			ath6kl_err("unable to set power save fail event policy\n");
 			status = -EIO;
 		}
 
 	if (!(ar->conf_flags & ATH6KL_CONF_IGNORE_ERP_BARKER))
-		if ((ath6kl_wmi_set_lpreamble_cmd(ar->wmi, 0,
+		if ((ath6kl_wmi_set_lpreamble_cmd(ar->wmi, idx, 0,
 		     WMI_DONOT_IGNORE_BARKER_IN_ERP)) != 0) {
 			ath6kl_err("unable to set barker preamble policy\n");
 			status = -EIO;
 		}
 
-	if (ath6kl_wmi_set_keepalive_cmd(ar->wmi,
+	if (ath6kl_wmi_set_keepalive_cmd(ar->wmi, idx,
 			WLAN_CONFIG_KEEP_ALIVE_INTERVAL)) {
 		ath6kl_err("unable to set keep alive interval\n");
 		status = -EIO;
 	}
 
-	if (ath6kl_wmi_disctimeout_cmd(ar->wmi,
+	if (ath6kl_wmi_disctimeout_cmd(ar->wmi, idx,
 			WLAN_CONFIG_DISCONNECT_TIMEOUT)) {
 		ath6kl_err("unable to set disconnect timeout\n");
 		status = -EIO;
 	}
 
 	if (!(ar->conf_flags & ATH6KL_CONF_ENABLE_TX_BURST))
-		if (ath6kl_wmi_set_wmm_txop(ar->wmi, WMI_TXOP_DISABLED)) {
+		if (ath6kl_wmi_set_wmm_txop(ar->wmi, idx, WMI_TXOP_DISABLED)) {
 			ath6kl_err("unable to set txop bursting\n");
 			status = -EIO;
 		}
 
+	/*
+	 * FIXME: Make sure p2p configurations are not applied to
+	 * non-p2p capable interfaces when multivif support is enabled.
+	 */
 	if (ar->p2p) {
-		ret = ath6kl_wmi_info_req_cmd(ar->wmi,
+		ret = ath6kl_wmi_info_req_cmd(ar->wmi, idx,
 					      P2P_FLAG_CAPABILITIES_REQ |
 					      P2P_FLAG_MACADDR_REQ |
 					      P2P_FLAG_HMODEL_REQ);
@@ -413,9 +417,13 @@ static int ath6kl_target_config_wlan_params(struct ath6kl *ar)
 		}
 	}
 
+	/*
+	 * FIXME: Make sure p2p configurations are not applied to
+	 * non-p2p capable interfaces when multivif support is enabled.
+	 */
 	if (ar->p2p) {
 		/* Enable Probe Request reporting for P2P */
-		ret = ath6kl_wmi_probe_report_req_cmd(ar->wmi, true);
+		ret = ath6kl_wmi_probe_report_req_cmd(ar->wmi, idx, true);
 		if (ret) {
 			ath6kl_dbg(ATH6KL_DBG_TRC, "failed to enable Probe "
 				   "Request reporting (%d)\n", ret);
@@ -1542,9 +1550,11 @@ static int ath6kl_init(struct ath6kl *ar)
 
 	ar->wiphy->flags |= WIPHY_FLAG_SUPPORTS_FW_ROAM;
 
-	status = ath6kl_target_config_wlan_params(ar);
-	if (status)
-		goto err_htc_stop;
+	for (i = 0; i < MAX_NUM_VIF; i++) {
+		status = ath6kl_target_config_wlan_params(ar, i);
+		if (status)
+			goto err_htc_stop;
+	}
 
 	/*
 	 * Set mac address which is received in ready event
diff --git a/drivers/net/wireless/ath/ath6kl/wmi.c b/drivers/net/wireless/ath/ath6kl/wmi.c
index 1fada31..e6b0960 100644
--- a/drivers/net/wireless/ath/ath6kl/wmi.c
+++ b/drivers/net/wireless/ath/ath6kl/wmi.c
@@ -1940,7 +1940,7 @@ int ath6kl_wmi_powermode_cmd(struct wmi *wmi, u8 if_idx, u8 pwr_mode)
 	return ret;
 }
 
-int ath6kl_wmi_pmparams_cmd(struct wmi *wmi, u16 idle_period,
+int ath6kl_wmi_pmparams_cmd(struct wmi *wmi, u8 if_idx, u16 idle_period,
 			    u16 ps_poll_num, u16 dtim_policy,
 			    u16 tx_wakeup_policy, u16 num_tx_to_wakeup,
 			    u16 ps_fail_event_policy)
@@ -1961,12 +1961,12 @@ int ath6kl_wmi_pmparams_cmd(struct wmi *wmi, u16 idle_period,
 	pm->num_tx_to_wakeup = cpu_to_le16(num_tx_to_wakeup);
 	pm->ps_fail_event_policy = cpu_to_le16(ps_fail_event_policy);
 
-	ret = ath6kl_wmi_cmd_send(wmi, 0, skb, WMI_SET_POWER_PARAMS_CMDID,
+	ret = ath6kl_wmi_cmd_send(wmi, if_idx, skb, WMI_SET_POWER_PARAMS_CMDID,
 				  NO_SYNC_WMIFLAG);
 	return ret;
 }
 
-int ath6kl_wmi_disctimeout_cmd(struct wmi *wmi, u8 timeout)
+int ath6kl_wmi_disctimeout_cmd(struct wmi *wmi, u8 if_idx, u8 timeout)
 {
 	struct sk_buff *skb;
 	struct wmi_disc_timeout_cmd *cmd;
@@ -1979,7 +1979,7 @@ int ath6kl_wmi_disctimeout_cmd(struct wmi *wmi, u8 timeout)
 	cmd = (struct wmi_disc_timeout_cmd *) skb->data;
 	cmd->discon_timeout = timeout;
 
-	ret = ath6kl_wmi_cmd_send(wmi, 0, skb, WMI_SET_DISC_TIMEOUT_CMDID,
+	ret = ath6kl_wmi_cmd_send(wmi, if_idx, skb, WMI_SET_DISC_TIMEOUT_CMDID,
 				  NO_SYNC_WMIFLAG);
 
 	if (ret == 0)
@@ -2500,7 +2500,8 @@ int ath6kl_wmi_get_roam_tbl_cmd(struct wmi *wmi)
 	return ath6kl_wmi_simple_cmd(wmi, 0, WMI_GET_ROAM_TBL_CMDID);
 }
 
-int ath6kl_wmi_set_lpreamble_cmd(struct wmi *wmi, u8 status, u8 preamble_policy)
+int ath6kl_wmi_set_lpreamble_cmd(struct wmi *wmi, u8 if_idx, u8 status,
+				 u8 preamble_policy)
 {
 	struct sk_buff *skb;
 	struct wmi_set_lpreamble_cmd *cmd;
@@ -2514,7 +2515,7 @@ int ath6kl_wmi_set_lpreamble_cmd(struct wmi *wmi, u8 status, u8 preamble_policy)
 	cmd->status = status;
 	cmd->preamble_policy = preamble_policy;
 
-	ret = ath6kl_wmi_cmd_send(wmi, 0, skb, WMI_SET_LPREAMBLE_CMDID,
+	ret = ath6kl_wmi_cmd_send(wmi, if_idx, skb, WMI_SET_LPREAMBLE_CMDID,
 				  NO_SYNC_WMIFLAG);
 	return ret;
 }
@@ -2537,7 +2538,7 @@ int ath6kl_wmi_set_rts_cmd(struct wmi *wmi, u16 threshold)
 	return ret;
 }
 
-int ath6kl_wmi_set_wmm_txop(struct wmi *wmi, enum wmi_txop_cfg cfg)
+int ath6kl_wmi_set_wmm_txop(struct wmi *wmi, u8 if_idx, enum wmi_txop_cfg cfg)
 {
 	struct sk_buff *skb;
 	struct wmi_set_wmm_txop_cmd *cmd;
@@ -2553,12 +2554,13 @@ int ath6kl_wmi_set_wmm_txop(struct wmi *wmi, enum wmi_txop_cfg cfg)
 	cmd = (struct wmi_set_wmm_txop_cmd *) skb->data;
 	cmd->txop_enable = cfg;
 
-	ret = ath6kl_wmi_cmd_send(wmi, 0, skb, WMI_SET_WMM_TXOP_CMDID,
+	ret = ath6kl_wmi_cmd_send(wmi, if_idx, skb, WMI_SET_WMM_TXOP_CMDID,
 				  NO_SYNC_WMIFLAG);
 	return ret;
 }
 
-int ath6kl_wmi_set_keepalive_cmd(struct wmi *wmi, u8 keep_alive_intvl)
+int ath6kl_wmi_set_keepalive_cmd(struct wmi *wmi, u8 if_idx,
+				 u8 keep_alive_intvl)
 {
 	struct sk_buff *skb;
 	struct wmi_set_keepalive_cmd *cmd;
@@ -2571,7 +2573,7 @@ int ath6kl_wmi_set_keepalive_cmd(struct wmi *wmi, u8 keep_alive_intvl)
 	cmd = (struct wmi_set_keepalive_cmd *) skb->data;
 	cmd->keep_alive_intvl = keep_alive_intvl;
 
-	ret = ath6kl_wmi_cmd_send(wmi, 0, skb, WMI_SET_KEEPALIVE_CMDID,
+	ret = ath6kl_wmi_cmd_send(wmi, if_idx, skb, WMI_SET_KEEPALIVE_CMDID,
 				  NO_SYNC_WMIFLAG);
 
 	if (ret == 0)
@@ -2734,7 +2736,8 @@ int ath6kl_wmi_set_pvb_cmd(struct wmi *wmi, u8 if_idx, u16 aid,
 	return 0;
 }
 
-int ath6kl_wmi_set_rx_frame_format_cmd(struct wmi *wmi, u8 rx_meta_ver,
+int ath6kl_wmi_set_rx_frame_format_cmd(struct wmi *wmi, u8 if_idx,
+				       u8 rx_meta_ver,
 				       bool rx_dot11_hdr, bool defrag_on_host)
 {
 	struct sk_buff *skb;
@@ -2751,7 +2754,7 @@ int ath6kl_wmi_set_rx_frame_format_cmd(struct wmi *wmi, u8 rx_meta_ver,
 	cmd->meta_ver = rx_meta_ver;
 
 	/* Delete the local aggr state, on host */
-	ret = ath6kl_wmi_cmd_send(wmi, 0, skb, WMI_RX_FRAME_FORMAT_CMDID,
+	ret = ath6kl_wmi_cmd_send(wmi, if_idx, skb, WMI_RX_FRAME_FORMAT_CMDID,
 				  NO_SYNC_WMIFLAG);
 
 	return ret;
@@ -2872,7 +2875,7 @@ int ath6kl_wmi_send_probe_response_cmd(struct wmi *wmi, u8 if_idx, u32 freq,
 				   NO_SYNC_WMIFLAG);
 }
 
-int ath6kl_wmi_probe_report_req_cmd(struct wmi *wmi, bool enable)
+int ath6kl_wmi_probe_report_req_cmd(struct wmi *wmi, u8 if_idx, bool enable)
 {
 	struct sk_buff *skb;
 	struct wmi_probe_req_report_cmd *p;
@@ -2885,11 +2888,11 @@ int ath6kl_wmi_probe_report_req_cmd(struct wmi *wmi, bool enable)
 		   enable);
 	p = (struct wmi_probe_req_report_cmd *) skb->data;
 	p->enable = enable ? 1 : 0;
-	return ath6kl_wmi_cmd_send(wmi, 0, skb, WMI_PROBE_REQ_REPORT_CMDID,
+	return ath6kl_wmi_cmd_send(wmi, if_idx, skb, WMI_PROBE_REQ_REPORT_CMDID,
 				   NO_SYNC_WMIFLAG);
 }
 
-int ath6kl_wmi_info_req_cmd(struct wmi *wmi, u32 info_req_flags)
+int ath6kl_wmi_info_req_cmd(struct wmi *wmi, u8 if_idx, u32 info_req_flags)
 {
 	struct sk_buff *skb;
 	struct wmi_get_p2p_info *p;
@@ -2902,7 +2905,7 @@ int ath6kl_wmi_info_req_cmd(struct wmi *wmi, u32 info_req_flags)
 		   info_req_flags);
 	p = (struct wmi_get_p2p_info *) skb->data;
 	p->info_req_flags = cpu_to_le32(info_req_flags);
-	return ath6kl_wmi_cmd_send(wmi, 0, skb, WMI_GET_P2P_INFO_CMDID,
+	return ath6kl_wmi_cmd_send(wmi, if_idx, skb, WMI_GET_P2P_INFO_CMDID,
 				   NO_SYNC_WMIFLAG);
 }
 
diff --git a/drivers/net/wireless/ath/ath6kl/wmi.h b/drivers/net/wireless/ath/ath6kl/wmi.h
index e2f3304..495d2e5 100644
--- a/drivers/net/wireless/ath/ath6kl/wmi.h
+++ b/drivers/net/wireless/ath/ath6kl/wmi.h
@@ -2230,18 +2230,18 @@ int ath6kl_wmi_listeninterval_cmd(struct wmi *wmi, u8 if_idx,
 				  u16 listen_interval,
 				  u16 listen_beacons);
 int ath6kl_wmi_powermode_cmd(struct wmi *wmi, u8 if_idx, u8 pwr_mode);
-int ath6kl_wmi_pmparams_cmd(struct wmi *wmi, u16 idle_period,
+int ath6kl_wmi_pmparams_cmd(struct wmi *wmi, u8 if_idx, u16 idle_period,
 			    u16 ps_poll_num, u16 dtim_policy,
 			    u16 tx_wakup_policy, u16 num_tx_to_wakeup,
 			    u16 ps_fail_event_policy);
-int ath6kl_wmi_disctimeout_cmd(struct wmi *wmi, u8 timeout);
 int ath6kl_wmi_create_pstream_cmd(struct wmi *wmi, u8 if_idx,
 				  struct wmi_create_pstream_cmd *pstream);
 int ath6kl_wmi_delete_pstream_cmd(struct wmi *wmi, u8 if_idx, u8 traffic_class,
 				  u8 tsid);
+int ath6kl_wmi_disctimeout_cmd(struct wmi *wmi, u8 if_idx, u8 timeout);
 
 int ath6kl_wmi_set_rts_cmd(struct wmi *wmi, u16 threshold);
-int ath6kl_wmi_set_lpreamble_cmd(struct wmi *wmi, u8 status,
+int ath6kl_wmi_set_lpreamble_cmd(struct wmi *wmi, u8 if_idx, u8 status,
 				 u8 preamble_policy);
 
 int ath6kl_wmi_get_challenge_resp_cmd(struct wmi *wmi, u32 cookie, u32 source);
@@ -2262,8 +2262,9 @@ int ath6kl_wmi_set_tx_pwr_cmd(struct wmi *wmi, u8 if_idx, u8 dbM);
 int ath6kl_wmi_get_tx_pwr_cmd(struct wmi *wmi, u8 if_idx);
 int ath6kl_wmi_get_roam_tbl_cmd(struct wmi *wmi);
 
-int ath6kl_wmi_set_wmm_txop(struct wmi *wmi, enum wmi_txop_cfg cfg);
-int ath6kl_wmi_set_keepalive_cmd(struct wmi *wmi, u8 keep_alive_intvl);
+int ath6kl_wmi_set_wmm_txop(struct wmi *wmi, u8 if_idx, enum wmi_txop_cfg cfg);
+int ath6kl_wmi_set_keepalive_cmd(struct wmi *wmi, u8 if_idx,
+				 u8 keep_alive_intvl);
 int ath6kl_wmi_test_cmd(struct wmi *wmi, void *buf, size_t len);
 
 s32 ath6kl_wmi_get_rate(s8 rate_index);
@@ -2282,7 +2283,8 @@ int ath6kl_wmi_ap_set_mlme(struct wmi *wmip, u8 if_idx, u8 cmd,
 
 int ath6kl_wmi_set_pvb_cmd(struct wmi *wmi, u8 if_idx, u16 aid, bool flag);
 
-int ath6kl_wmi_set_rx_frame_format_cmd(struct wmi *wmi, u8 rx_meta_version,
+int ath6kl_wmi_set_rx_frame_format_cmd(struct wmi *wmi, u8 if_idx,
+				       u8 rx_meta_version,
 				       bool rx_dot11_hdr, bool defrag_on_host);
 
 int ath6kl_wmi_set_appie_cmd(struct wmi *wmi, u8 if_idx, u8 mgmt_frm_type,
@@ -2301,9 +2303,9 @@ int ath6kl_wmi_send_probe_response_cmd(struct wmi *wmi, u8 if_idx, u32 freq,
 				       const u8 *dst, const u8 *data,
 				       u16 data_len);
 
-int ath6kl_wmi_probe_report_req_cmd(struct wmi *wmi, bool enable);
+int ath6kl_wmi_probe_report_req_cmd(struct wmi *wmi, u8 if_idx, bool enable);
 
-int ath6kl_wmi_info_req_cmd(struct wmi *wmi, u32 info_req_flags);
+int ath6kl_wmi_info_req_cmd(struct wmi *wmi, u8 if_idx, u32 info_req_flags);
 
 int ath6kl_wmi_cancel_remain_on_chnl_cmd(struct wmi *wmi, u8 if_idx);
 
-- 
1.7.0.4

