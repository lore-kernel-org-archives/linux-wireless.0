Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx0b-0016f401.pphosted.com ([67.231.156.173]:32991 "EHLO
	mx0b-0016f401.pphosted.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751413AbbANKrU (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 14 Jan 2015 05:47:20 -0500
Received: from pps.filterd (m0045851.ppops.net [127.0.0.1])
	by mx0b-0016f401.pphosted.com (8.14.5/8.14.5) with SMTP id t0EAOqIH024046
	for <linux-wireless@vger.kernel.org>; Wed, 14 Jan 2015 02:47:19 -0800
Received: from sc-owa.marvell.com ([199.233.58.135])
	by mx0b-0016f401.pphosted.com with ESMTP id 1rv520pv2n-1
	(version=TLSv1/SSLv3 cipher=AES128-SHA bits=128 verify=NOT)
	for <linux-wireless@vger.kernel.org>; Wed, 14 Jan 2015 02:47:19 -0800
From: Avinash Patil <patila@marvell.com>
To: <linux-wireless@vger.kernel.org>
CC: <akarwar@marvell.com>, <cluo@marvell.com>, <yangyang@marvell.com>,
	<gaoqs@marvell.com>, Avinash Patil <patila@marvell.com>
Subject: [PATCH 06/10] mwifiex: add cfg80211 start_radar_detection handler
Date: Wed, 14 Jan 2015 21:45:34 +0530
Message-ID: <1421252138-30157-7-git-send-email-patila@marvell.com> (sfid-20150114_114728_866375_7FA794D9)
In-Reply-To: <1421252138-30157-1-git-send-email-patila@marvell.com>
References: <1421252138-30157-1-git-send-email-patila@marvell.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This patch adds support for cfg80211 start_radar_detection handler.
Upon reception of start_radar_detection, driver prepares radar detect
command to FW.

Delayed work is queued for CAC time which sends radar detection finished
event to cfg80211.

Signed-off-by: Avinash Patil <patila@marvell.com>
Signed-off-by: Qingshui Gao <gaoqs@marvell.com>
Signed-off-by: Cathy Luo <cluo@marvell.com>
---
 drivers/net/wireless/mwifiex/11h.c         | 66 ++++++++++++++++++++++++++++++
 drivers/net/wireless/mwifiex/cfg80211.c    | 59 ++++++++++++++++++++++++++
 drivers/net/wireless/mwifiex/decl.h        |  6 +++
 drivers/net/wireless/mwifiex/fw.h          | 13 ++++++
 drivers/net/wireless/mwifiex/init.c        |  1 +
 drivers/net/wireless/mwifiex/main.h        | 10 +++++
 drivers/net/wireless/mwifiex/sta_cmd.c     |  4 ++
 drivers/net/wireless/mwifiex/sta_cmdresp.c |  2 +
 drivers/net/wireless/mwifiex/uap_cmd.c     |  5 +++
 9 files changed, 166 insertions(+)

diff --git a/drivers/net/wireless/mwifiex/11h.c b/drivers/net/wireless/mwifiex/11h.c
index f23b647a..8832c83 100644
--- a/drivers/net/wireless/mwifiex/11h.c
+++ b/drivers/net/wireless/mwifiex/11h.c
@@ -99,3 +99,69 @@ void mwifiex_11h_process_join(struct mwifiex_private *priv, u8 **buffer,
 		bss_desc->cap_info_bitmap &= ~WLAN_CAPABILITY_SPECTRUM_MGMT;
 	}
 }
+
+/* This is DFS CAC work queue function.
+ * This delayed work emits CAC finished event for cfg80211 if
+ * CAC was started earlier.
+ */
+void mwifiex_dfs_cac_work_queue(struct work_struct *work)
+{
+	struct cfg80211_chan_def chandef;
+	struct delayed_work *delayed_work =
+			container_of(work, struct delayed_work, work);
+	struct mwifiex_private *priv =
+			container_of(delayed_work, struct mwifiex_private,
+				     dfs_cac_work);
+
+	if (WARN_ON(!priv))
+		return;
+
+	chandef = priv->dfs_chandef;
+	if (priv->wdev.cac_started) {
+		dev_dbg(priv->adapter->dev,
+			"CAC timer finished; No radar detected\n");
+		cfg80211_cac_event(priv->netdev, &chandef,
+				   NL80211_RADAR_CAC_FINISHED,
+				   GFP_KERNEL);
+	}
+}
+
+/* This function prepares channel report request command to FW for
+ * starting radar detection.
+ */
+int mwifiex_cmd_issue_chan_report_request(struct mwifiex_private *priv,
+					  struct host_cmd_ds_command *cmd,
+					  void *data_buf)
+{
+	struct host_cmd_ds_chan_rpt_req *cr_req = &cmd->params.chan_rpt_req;
+	struct mwifiex_radar_params *radar_params = (void *)data_buf;
+
+	cmd->command = cpu_to_le16(HostCmd_CMD_CHAN_REPORT_REQUEST);
+	cmd->size = cpu_to_le16(S_DS_GEN);
+	le16_add_cpu(&cmd->size, sizeof(struct host_cmd_ds_chan_rpt_req));
+
+	cr_req->chan_desc.start_freq = cpu_to_le16(MWIFIEX_A_BAND_START_FREQ);
+	cr_req->chan_desc.chan_num = radar_params->chandef->chan->hw_value;
+	cr_req->chan_desc.chan_width = radar_params->chandef->width;
+	cr_req->msec_dwell_time = cpu_to_le32(radar_params->cac_time_ms);
+
+	dev_dbg(priv->adapter->dev,
+		"11h: issuing DFS Radar check for channel=%d\n",
+		radar_params->chandef->chan->hw_value);
+
+	return 0;
+}
+
+/* This function is to abort ongoing CAC upon stopping AP operations
+ * or during unload.
+ */
+void mwifiex_abort_cac(struct mwifiex_private *priv)
+{
+	if (priv->wdev.cac_started) {
+		dev_dbg(priv->adapter->dev,
+			"Aborting delayed work for CAC.\n");
+		cancel_delayed_work_sync(&priv->dfs_cac_work);
+		cfg80211_cac_event(priv->netdev, &priv->dfs_chandef,
+				   NL80211_RADAR_CAC_ABORTED, GFP_KERNEL);
+	}
+}
diff --git a/drivers/net/wireless/mwifiex/cfg80211.c b/drivers/net/wireless/mwifiex/cfg80211.c
index 9ef9ff6..13c9c67 100644
--- a/drivers/net/wireless/mwifiex/cfg80211.c
+++ b/drivers/net/wireless/mwifiex/cfg80211.c
@@ -1649,6 +1649,8 @@ static int mwifiex_cfg80211_stop_ap(struct wiphy *wiphy, struct net_device *dev)
 {
 	struct mwifiex_private *priv = mwifiex_netdev_get_priv(dev);
 
+	mwifiex_abort_cac(priv);
+
 	if (mwifiex_del_mgmt_ies(priv))
 		wiphy_err(wiphy, "Failed to delete mgmt IEs!\n");
 
@@ -2381,6 +2383,7 @@ mwifiex_setup_ht_caps(struct ieee80211_sta_ht_cap *ht_info,
 	ht_info->mcs.tx_params = IEEE80211_HT_MCS_TX_DEFINED;
 }
 
+#define MWIFIEX_MAX_WQ_LEN  30
 /*
  *  create a new virtual interface with the given name
  */
@@ -2394,6 +2397,7 @@ struct wireless_dev *mwifiex_add_virtual_intf(struct wiphy *wiphy,
 	struct mwifiex_private *priv;
 	struct net_device *dev;
 	void *mdev_priv;
+	char dfs_cac_str[MWIFIEX_MAX_WQ_LEN];
 
 	if (!adapter)
 		return ERR_PTR(-EFAULT);
@@ -2558,6 +2562,24 @@ struct wireless_dev *mwifiex_add_virtual_intf(struct wiphy *wiphy,
 		return ERR_PTR(-EFAULT);
 	}
 
+	strcpy(dfs_cac_str, "MWIFIEX_DFS_CAC");
+	strcat(dfs_cac_str, name);
+	priv->dfs_cac_workqueue = alloc_workqueue(dfs_cac_str,
+						  WQ_HIGHPRI |
+						  WQ_MEM_RECLAIM |
+						  WQ_UNBOUND, 1);
+	if (!priv->dfs_cac_workqueue) {
+		wiphy_err(wiphy, "cannot register virtual network device\n");
+		free_netdev(dev);
+		priv->bss_mode = NL80211_IFTYPE_UNSPECIFIED;
+		priv->netdev = NULL;
+		memset(&priv->wdev, 0, sizeof(priv->wdev));
+		priv->wdev.iftype = NL80211_IFTYPE_UNSPECIFIED;
+		return ERR_PTR(-ENOMEM);
+	}
+
+	INIT_DELAYED_WORK(&priv->dfs_cac_work, mwifiex_dfs_cac_work_queue);
+
 	sema_init(&priv->async_sem, 1);
 
 	dev_dbg(adapter->dev, "info: %s: Marvell 802.11 Adapter\n", dev->name);
@@ -2607,6 +2629,12 @@ int mwifiex_del_virtual_intf(struct wiphy *wiphy, struct wireless_dev *wdev)
 	if (wdev->netdev->reg_state == NETREG_REGISTERED)
 		unregister_netdevice(wdev->netdev);
 
+	if (priv->dfs_cac_workqueue) {
+		flush_workqueue(priv->dfs_cac_workqueue);
+		destroy_workqueue(priv->dfs_cac_workqueue);
+		priv->dfs_cac_workqueue = NULL;
+	}
+
 	/* Clear the priv in adapter */
 	priv->netdev->ieee80211_ptr = NULL;
 	priv->netdev = NULL;
@@ -3055,6 +3083,36 @@ mwifiex_cfg80211_add_station(struct wiphy *wiphy, struct net_device *dev,
 }
 
 static int
+mwifiex_cfg80211_start_radar_detection(struct wiphy *wiphy,
+				       struct net_device *dev,
+				       struct cfg80211_chan_def *chandef,
+				       u32 cac_time_ms)
+{
+	struct mwifiex_private *priv = mwifiex_netdev_get_priv(dev);
+	struct mwifiex_radar_params radar_params;
+
+	if (priv->adapter->scan_processing) {
+		dev_err(priv->adapter->dev,
+			"radar detection: scan already in process...\n");
+		return -EBUSY;
+	}
+
+	memset(&radar_params, 0, sizeof(struct mwifiex_radar_params));
+	radar_params.chandef = chandef;
+	radar_params.cac_time_ms = cac_time_ms;
+
+	memcpy(&priv->dfs_chandef, chandef, sizeof(priv->dfs_chandef));
+
+	if (mwifiex_send_cmd(priv, HostCmd_CMD_CHAN_REPORT_REQUEST,
+			     HostCmd_ACT_GEN_SET, 0, &radar_params, true))
+		return -1;
+
+	queue_delayed_work(priv->dfs_cac_workqueue, &priv->dfs_cac_work,
+			   msecs_to_jiffies(cac_time_ms));
+	return 0;
+}
+
+static int
 mwifiex_cfg80211_change_station(struct wiphy *wiphy, struct net_device *dev,
 				const u8 *mac,
 				struct station_parameters *params)
@@ -3118,6 +3176,7 @@ static struct cfg80211_ops mwifiex_cfg80211_ops = {
 	.tdls_oper = mwifiex_cfg80211_tdls_oper,
 	.add_station = mwifiex_cfg80211_add_station,
 	.change_station = mwifiex_cfg80211_change_station,
+	.start_radar_detection = mwifiex_cfg80211_start_radar_detection,
 };
 
 #ifdef CONFIG_PM
diff --git a/drivers/net/wireless/mwifiex/decl.h b/drivers/net/wireless/mwifiex/decl.h
index 4481ac4..68aed4e 100644
--- a/drivers/net/wireless/mwifiex/decl.h
+++ b/drivers/net/wireless/mwifiex/decl.h
@@ -108,6 +108,8 @@
 #define MWIFIEX_MAX_UAP_NUM		1
 #define MWIFIEX_MAX_P2P_NUM		1
 
+#define MWIFIEX_A_BAND_START_FREQ	5000
+
 enum mwifiex_bss_type {
 	MWIFIEX_BSS_TYPE_STA = 0,
 	MWIFIEX_BSS_TYPE_UAP = 1,
@@ -242,4 +244,8 @@ struct mwifiex_iface_comb {
 	u8 p2p_intf;
 };
 
+struct mwifiex_radar_params {
+	struct cfg80211_chan_def *chandef;
+	u32 cac_time_ms;
+} __packed;
 #endif /* !_MWIFIEX_DECL_H_ */
diff --git a/drivers/net/wireless/mwifiex/fw.h b/drivers/net/wireless/mwifiex/fw.h
index 15ad776..739151c 100644
--- a/drivers/net/wireless/mwifiex/fw.h
+++ b/drivers/net/wireless/mwifiex/fw.h
@@ -336,6 +336,7 @@ enum MWIFIEX_802_11_PRIVACY_FILTER {
 #define HostCmd_CMD_11N_ADDBA_RSP                     0x00cf
 #define HostCmd_CMD_11N_DELBA                         0x00d0
 #define HostCmd_CMD_RECONFIGURE_TX_BUFF               0x00d9
+#define HostCmd_CMD_CHAN_REPORT_REQUEST               0x00dd
 #define HostCmd_CMD_AMSDU_AGGR_CTRL                   0x00df
 #define HostCmd_CMD_TXPWR_CFG                         0x00d1
 #define HostCmd_CMD_TX_RATE_CFG                       0x00d6
@@ -1216,6 +1217,17 @@ struct host_cmd_ds_tdls_oper {
 	u8 peer_mac[ETH_ALEN];
 } __packed;
 
+struct mwifiex_chan_desc {
+	__le16 start_freq;
+	u8 chan_width;
+	u8 chan_num;
+} __packed;
+
+struct host_cmd_ds_chan_rpt_req {
+	struct mwifiex_chan_desc chan_desc;
+	__le32 msec_dwell_time;
+} __packed;
+
 struct mwifiex_fixed_bcn_param {
 	__le64 timestamp;
 	__le16 beacon_period;
@@ -1904,6 +1916,7 @@ struct host_cmd_ds_command {
 		struct host_cmd_11ac_vht_cfg vht_cfg;
 		struct host_cmd_ds_coalesce_cfg coalesce_cfg;
 		struct host_cmd_ds_tdls_oper tdls_oper;
+		struct host_cmd_ds_chan_rpt_req chan_rpt_req;
 	} params;
 } __packed;
 
diff --git a/drivers/net/wireless/mwifiex/init.c b/drivers/net/wireless/mwifiex/init.c
index d54c576..b021701 100644
--- a/drivers/net/wireless/mwifiex/init.c
+++ b/drivers/net/wireless/mwifiex/init.c
@@ -664,6 +664,7 @@ mwifiex_shutdown_drv(struct mwifiex_adapter *adapter)
 			priv = adapter->priv[i];
 
 			mwifiex_clean_auto_tdls(priv);
+			mwifiex_abort_cac(priv);
 			mwifiex_clean_txrx(priv);
 			mwifiex_delete_bss_prio_tbl(priv);
 		}
diff --git a/drivers/net/wireless/mwifiex/main.h b/drivers/net/wireless/mwifiex/main.h
index cf61775..8e2b692 100644
--- a/drivers/net/wireless/mwifiex/main.h
+++ b/drivers/net/wireless/mwifiex/main.h
@@ -589,6 +589,9 @@ struct mwifiex_private {
 	spinlock_t ack_status_lock;
 	/** rx histogram data */
 	struct mwifiex_histogram_data *hist_data;
+	struct cfg80211_chan_def dfs_chandef;
+	struct workqueue_struct *dfs_cac_workqueue;
+	struct delayed_work dfs_cac_work;
 };
 
 enum mwifiex_ba_status {
@@ -755,6 +758,8 @@ struct mwifiex_adapter {
 	struct work_struct main_work;
 	struct workqueue_struct *rx_workqueue;
 	struct work_struct rx_work;
+	struct workqueue_struct *dfs_workqueue;
+	struct work_struct dfs_work;
 	bool rx_work_enabled;
 	bool rx_processing;
 	bool delay_main_work;
@@ -1376,6 +1381,9 @@ void mwifiex_check_auto_tdls(unsigned long context);
 void mwifiex_add_auto_tdls_peer(struct mwifiex_private *priv, const u8 *mac);
 void mwifiex_setup_auto_tdls_timer(struct mwifiex_private *priv);
 void mwifiex_clean_auto_tdls(struct mwifiex_private *priv);
+int mwifiex_cmd_issue_chan_report_request(struct mwifiex_private *priv,
+					  struct host_cmd_ds_command *cmd,
+					  void *data_buf);
 
 void mwifiex_parse_tx_status_event(struct mwifiex_private *priv,
 				   void *event_body);
@@ -1383,6 +1391,8 @@ void mwifiex_parse_tx_status_event(struct mwifiex_private *priv,
 struct sk_buff *
 mwifiex_clone_skb_for_tx_status(struct mwifiex_private *priv,
 				struct sk_buff *skb, u8 flag, u64 *cookie);
+void mwifiex_dfs_cac_work_queue(struct work_struct *work);
+void mwifiex_abort_cac(struct mwifiex_private *priv);
 
 void mwifiex_hist_data_set(struct mwifiex_private *priv, u8 rx_rate, s8 snr,
 			   s8 nflr);
diff --git a/drivers/net/wireless/mwifiex/sta_cmd.c b/drivers/net/wireless/mwifiex/sta_cmd.c
index 92a66e8..f7d204f 100644
--- a/drivers/net/wireless/mwifiex/sta_cmd.c
+++ b/drivers/net/wireless/mwifiex/sta_cmd.c
@@ -1897,6 +1897,10 @@ int mwifiex_sta_prepare_cmd(struct mwifiex_private *priv, uint16_t cmd_no,
 	case HostCmd_CMD_TDLS_OPER:
 		ret = mwifiex_cmd_tdls_oper(priv, cmd_ptr, data_buf);
 		break;
+	case HostCmd_CMD_CHAN_REPORT_REQUEST:
+		ret = mwifiex_cmd_issue_chan_report_request(priv, cmd_ptr,
+							    data_buf);
+		break;
 	default:
 		dev_err(priv->adapter->dev,
 			"PREP_CMD: unknown cmd- %#x\n", cmd_no);
diff --git a/drivers/net/wireless/mwifiex/sta_cmdresp.c b/drivers/net/wireless/mwifiex/sta_cmdresp.c
index 65d10a3..39f3176 100644
--- a/drivers/net/wireless/mwifiex/sta_cmdresp.c
+++ b/drivers/net/wireless/mwifiex/sta_cmdresp.c
@@ -1119,6 +1119,8 @@ int mwifiex_process_sta_cmdresp(struct mwifiex_private *priv, u16 cmdresp_no,
 	case HostCmd_CMD_TDLS_OPER:
 		ret = mwifiex_ret_tdls_oper(priv, resp);
 		break;
+	case HostCmd_CMD_CHAN_REPORT_REQUEST:
+		break;
 	default:
 		dev_err(adapter->dev, "CMD_RESP: unknown cmd response %#x\n",
 			resp->command);
diff --git a/drivers/net/wireless/mwifiex/uap_cmd.c b/drivers/net/wireless/mwifiex/uap_cmd.c
index baf5314..f5c2af0 100644
--- a/drivers/net/wireless/mwifiex/uap_cmd.c
+++ b/drivers/net/wireless/mwifiex/uap_cmd.c
@@ -761,6 +761,11 @@ int mwifiex_uap_prepare_cmd(struct mwifiex_private *priv, u16 cmd_no,
 		if (mwifiex_cmd_uap_sta_deauth(priv, cmd, data_buf))
 			return -1;
 		break;
+	case HostCmd_CMD_CHAN_REPORT_REQUEST:
+		if (mwifiex_cmd_issue_chan_report_request(priv, cmd_buf,
+							  data_buf))
+			return -1;
+		break;
 	default:
 		dev_err(priv->adapter->dev,
 			"PREP_CMD: unknown cmd %#x\n", cmd_no);
-- 
1.8.1.4

