Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from na3sys009aog105.obsmtp.com ([74.125.149.75]:53651 "HELO
	na3sys009aog105.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1161299Ab2CPDwj (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 15 Mar 2012 23:52:39 -0400
From: Bing Zhao <bzhao@marvell.com>
To: linux-wireless@vger.kernel.org
Cc: "John W. Linville" <linville@tuxdriver.com>,
	Amitkumar Karwar <akarwar@marvell.com>,
	Kiran Divekar <dkiran@marvell.com>,
	Yogesh Powar <yogeshp@marvell.com>,
	Avinash Patil <patila@marvell.com>,
	Frank Huang <frankh@marvell.com>, Bing Zhao <bzhao@marvell.com>
Subject: [PATCH 5/5] mwifiex: add set_cqm_rssi_config handler support
Date: Thu, 15 Mar 2012 20:51:51 -0700
Message-Id: <1331869911-10624-6-git-send-email-bzhao@marvell.com> (sfid-20120316_045244_041802_AA75935D)
In-Reply-To: <1331869911-10624-1-git-send-email-bzhao@marvell.com>
References: <1331869911-10624-1-git-send-email-bzhao@marvell.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Amitkumar Karwar <akarwar@marvell.com>

In this handler LOW_RSSI and HIGH_RSSI events are subscribed
to FW using provided threshold value so that FW will monitor
connection quality and trigger any of these events.

Driver will notify cfg80211 about connection quality based on
inputs from FW and provided hysteresis.

Signed-off-by: Amitkumar Karwar <akarwar@marvell.com>
Signed-off-by: Yogesh Ashok Powar <yogeshp@marvell.com>
Signed-off-by: Bing Zhao <bzhao@marvell.com>
---
 drivers/net/wireless/mwifiex/cfg80211.c    |   40 +++++++++++
 drivers/net/wireless/mwifiex/fw.h          |   17 +++++
 drivers/net/wireless/mwifiex/ioctl.h       |   21 ++++++
 drivers/net/wireless/mwifiex/main.h        |    3 +
 drivers/net/wireless/mwifiex/sta_cmd.c     |   98 ++++++++++++++++++++++++++++
 drivers/net/wireless/mwifiex/sta_cmdresp.c |   50 ++++++++++++++
 drivers/net/wireless/mwifiex/sta_event.c   |   12 ++++
 7 files changed, 241 insertions(+), 0 deletions(-)

diff --git a/drivers/net/wireless/mwifiex/cfg80211.c b/drivers/net/wireless/mwifiex/cfg80211.c
index 96c1e3b..c7e8918 100644
--- a/drivers/net/wireless/mwifiex/cfg80211.c
+++ b/drivers/net/wireless/mwifiex/cfg80211.c
@@ -766,6 +766,45 @@ static int mwifiex_cfg80211_set_bitrate_mask(struct wiphy *wiphy,
 }
 
 /*
+ * CFG802.11 operation handler for connection quality monitoring.
+ *
+ * This function subscribes/unsubscribes HIGH_RSSI and LOW_RSSI
+ * events to FW.
+ */
+static int mwifiex_cfg80211_set_cqm_rssi_config(struct wiphy *wiphy,
+						struct net_device *dev,
+						s32 rssi_thold, u32 rssi_hyst)
+{
+	struct mwifiex_private *priv = mwifiex_netdev_get_priv(dev);
+	struct mwifiex_ds_misc_subsc_evt subsc_evt;
+
+	priv->cqm_rssi_thold = rssi_thold;
+	priv->cqm_rssi_hyst = rssi_hyst;
+
+	memset(&subsc_evt, 0x00, sizeof(struct mwifiex_ds_misc_subsc_evt));
+	subsc_evt.events = BITMASK_BCN_RSSI_LOW | BITMASK_BCN_RSSI_HIGH;
+
+	/* Subscribe/unsubscribe low and high rssi events */
+	if (rssi_thold && rssi_hyst) {
+		subsc_evt.action = HostCmd_ACT_BITWISE_SET;
+		subsc_evt.bcn_l_rssi_cfg.abs_value = abs(rssi_thold);
+		subsc_evt.bcn_h_rssi_cfg.abs_value = abs(rssi_thold);
+		subsc_evt.bcn_l_rssi_cfg.evt_freq = 1;
+		subsc_evt.bcn_h_rssi_cfg.evt_freq = 1;
+		return mwifiex_send_cmd_sync(priv,
+					     HostCmd_CMD_802_11_SUBSCRIBE_EVENT,
+					     0, 0, &subsc_evt);
+	} else {
+		subsc_evt.action = HostCmd_ACT_BITWISE_CLR;
+		return mwifiex_send_cmd_sync(priv,
+					     HostCmd_CMD_802_11_SUBSCRIBE_EVENT,
+					     0, 0, &subsc_evt);
+	}
+
+	return 0;
+}
+
+/*
  * CFG802.11 operation handler for disconnection request.
  *
  * This function does not work when there is already a disconnection
@@ -1367,6 +1406,7 @@ static struct cfg80211_ops mwifiex_cfg80211_ops = {
 	.set_power_mgmt = mwifiex_cfg80211_set_power_mgmt,
 	.set_tx_power = mwifiex_cfg80211_set_tx_power,
 	.set_bitrate_mask = mwifiex_cfg80211_set_bitrate_mask,
+	.set_cqm_rssi_config = mwifiex_cfg80211_set_cqm_rssi_config,
 };
 
 /*
diff --git a/drivers/net/wireless/mwifiex/fw.h b/drivers/net/wireless/mwifiex/fw.h
index e98fc5a..7da9789 100644
--- a/drivers/net/wireless/mwifiex/fw.h
+++ b/drivers/net/wireless/mwifiex/fw.h
@@ -92,10 +92,12 @@ enum MWIFIEX_802_11_PRIVACY_FILTER {
 #define TLV_TYPE_KEY_MATERIAL       (PROPRIETARY_TLV_BASE_ID + 0)
 #define TLV_TYPE_CHANLIST           (PROPRIETARY_TLV_BASE_ID + 1)
 #define TLV_TYPE_NUMPROBES          (PROPRIETARY_TLV_BASE_ID + 2)
+#define TLV_TYPE_RSSI_LOW           (PROPRIETARY_TLV_BASE_ID + 4)
 #define TLV_TYPE_PASSTHROUGH        (PROPRIETARY_TLV_BASE_ID + 10)
 #define TLV_TYPE_WMMQSTATUS         (PROPRIETARY_TLV_BASE_ID + 16)
 #define TLV_TYPE_WILDCARDSSID       (PROPRIETARY_TLV_BASE_ID + 18)
 #define TLV_TYPE_TSFTIMESTAMP       (PROPRIETARY_TLV_BASE_ID + 19)
+#define TLV_TYPE_RSSI_HIGH          (PROPRIETARY_TLV_BASE_ID + 22)
 #define TLV_TYPE_AUTH_TYPE          (PROPRIETARY_TLV_BASE_ID + 31)
 #define TLV_TYPE_CHANNELBANDLIST    (PROPRIETARY_TLV_BASE_ID + 42)
 #define TLV_TYPE_RATE_DROP_CONTROL  (PROPRIETARY_TLV_BASE_ID + 82)
@@ -194,6 +196,7 @@ enum MWIFIEX_802_11_PRIVACY_FILTER {
 #define HostCmd_CMD_802_11_KEY_MATERIAL               0x005e
 #define HostCmd_CMD_802_11_BG_SCAN_QUERY              0x006c
 #define HostCmd_CMD_WMM_GET_STATUS                    0x0071
+#define HostCmd_CMD_802_11_SUBSCRIBE_EVENT            0x0075
 #define HostCmd_CMD_802_11_TX_RATE_QUERY              0x007f
 #define HostCmd_CMD_802_11_IBSS_COALESCING_STATUS     0x0083
 #define HostCmd_CMD_VERSION_EXT                       0x0097
@@ -228,6 +231,8 @@ enum ENH_PS_MODES {
 #define HostCmd_RET_BIT                       0x8000
 #define HostCmd_ACT_GEN_GET                   0x0000
 #define HostCmd_ACT_GEN_SET                   0x0001
+#define HostCmd_ACT_BITWISE_SET               0x0002
+#define HostCmd_ACT_BITWISE_CLR               0x0003
 #define HostCmd_RESULT_OK                     0x0000
 
 #define HostCmd_ACT_MAC_RX_ON                 0x0001
@@ -1146,6 +1151,17 @@ struct host_cmd_ds_pcie_details {
 	u32 sleep_cookie_addr_hi;
 } __packed;
 
+struct mwifiex_ie_types_rssi_threshold {
+	struct mwifiex_ie_types_header header;
+	u8 abs_value;
+	u8 evt_freq;
+} __packed;
+
+struct host_cmd_ds_802_11_subsc_evt {
+	__le16 action;
+	__le16 events;
+} __packed;
+
 struct host_cmd_ds_command {
 	__le16 command;
 	__le16 size;
@@ -1195,6 +1211,7 @@ struct host_cmd_ds_command {
 		struct host_cmd_ds_set_bss_mode bss_mode;
 		struct host_cmd_ds_pcie_details pcie_host_spec;
 		struct host_cmd_ds_802_11_eeprom_access eeprom;
+		struct host_cmd_ds_802_11_subsc_evt subsc_evt;
 	} params;
 } __packed;
 
diff --git a/drivers/net/wireless/mwifiex/ioctl.h b/drivers/net/wireless/mwifiex/ioctl.h
index 58fe054..99c0664 100644
--- a/drivers/net/wireless/mwifiex/ioctl.h
+++ b/drivers/net/wireless/mwifiex/ioctl.h
@@ -280,6 +280,27 @@ struct mwifiex_ds_misc_cmd {
 	u8 cmd[MWIFIEX_SIZE_OF_CMD_BUFFER];
 };
 
+#define BITMASK_BCN_RSSI_LOW	BIT(0)
+#define BITMASK_BCN_RSSI_HIGH	BIT(4)
+
+enum subsc_evt_rssi_state {
+	EVENT_HANDLED,
+	RSSI_LOW_RECVD,
+	RSSI_HIGH_RECVD
+};
+
+struct subsc_evt_cfg {
+	u8 abs_value;
+	u8 evt_freq;
+};
+
+struct mwifiex_ds_misc_subsc_evt {
+	u16 action;
+	u16 events;
+	struct subsc_evt_cfg bcn_l_rssi_cfg;
+	struct subsc_evt_cfg bcn_h_rssi_cfg;
+};
+
 #define MWIFIEX_MAX_VSIE_LEN       (256)
 #define MWIFIEX_MAX_VSIE_NUM       (8)
 #define MWIFIEX_VSIE_MASK_SCAN     0x01
diff --git a/drivers/net/wireless/mwifiex/main.h b/drivers/net/wireless/mwifiex/main.h
index 70bdfb9..9f24b93 100644
--- a/drivers/net/wireless/mwifiex/main.h
+++ b/drivers/net/wireless/mwifiex/main.h
@@ -458,6 +458,9 @@ struct mwifiex_private {
 	u8 country_code[IEEE80211_COUNTRY_STRING_LEN];
 	struct wps wps;
 	u8 scan_block;
+	s32 cqm_rssi_thold;
+	u32 cqm_rssi_hyst;
+	u8 subsc_evt_rssi_state;
 };
 
 enum mwifiex_ba_status {
diff --git a/drivers/net/wireless/mwifiex/sta_cmd.c b/drivers/net/wireless/mwifiex/sta_cmd.c
index 6c8e459..e90c34d 100644
--- a/drivers/net/wireless/mwifiex/sta_cmd.c
+++ b/drivers/net/wireless/mwifiex/sta_cmd.c
@@ -907,6 +907,101 @@ mwifiex_cmd_pcie_host_spec(struct mwifiex_private *priv,
 }
 
 /*
+ * This function prepares command for event subscription, configuration
+ * and query. Events can be subscribed or unsubscribed. Current subscribed
+ * events can be queried. Also, current subscribed events are reported in
+ * every FW response.
+ */
+static int
+mwifiex_cmd_802_11_subsc_evt(struct mwifiex_private *priv,
+			     struct host_cmd_ds_command *cmd,
+			     struct mwifiex_ds_misc_subsc_evt *subsc_evt_cfg)
+{
+	struct host_cmd_ds_802_11_subsc_evt *subsc_evt = &cmd->params.subsc_evt;
+	struct mwifiex_ie_types_rssi_threshold *rssi_tlv;
+	u16 event_bitmap;
+	u8 *pos;
+
+	cmd->command = cpu_to_le16(HostCmd_CMD_802_11_SUBSCRIBE_EVENT);
+	cmd->size = cpu_to_le16(sizeof(struct host_cmd_ds_802_11_subsc_evt) +
+				S_DS_GEN);
+
+	subsc_evt->action = cpu_to_le16(subsc_evt_cfg->action);
+	dev_dbg(priv->adapter->dev, "cmd: action: %d\n", subsc_evt_cfg->action);
+
+	/*For query requests, no configuration TLV structures are to be added.*/
+	if (subsc_evt_cfg->action == HostCmd_ACT_GEN_GET)
+		return 0;
+
+	subsc_evt->events = cpu_to_le16(subsc_evt_cfg->events);
+
+	event_bitmap = subsc_evt_cfg->events;
+	dev_dbg(priv->adapter->dev, "cmd: event bitmap : %16x\n",
+		event_bitmap);
+
+	if (((subsc_evt_cfg->action == HostCmd_ACT_BITWISE_CLR) ||
+	     (subsc_evt_cfg->action == HostCmd_ACT_BITWISE_SET)) &&
+	    (event_bitmap == 0)) {
+		dev_dbg(priv->adapter->dev, "Error: No event specified "
+			"for bitwise action type\n");
+		return -EINVAL;
+	}
+
+	/*
+	 * Append TLV structures for each of the specified events for
+	 * subscribing or re-configuring. This is not required for
+	 * bitwise unsubscribing request.
+	 */
+	if (subsc_evt_cfg->action == HostCmd_ACT_BITWISE_CLR)
+		return 0;
+
+	pos = ((u8 *)subsc_evt) +
+			sizeof(struct host_cmd_ds_802_11_subsc_evt);
+
+	if (event_bitmap & BITMASK_BCN_RSSI_LOW) {
+		rssi_tlv = (struct mwifiex_ie_types_rssi_threshold *) pos;
+
+		rssi_tlv->header.type = cpu_to_le16(TLV_TYPE_RSSI_LOW);
+		rssi_tlv->header.len =
+		    cpu_to_le16(sizeof(struct mwifiex_ie_types_rssi_threshold) -
+				sizeof(struct mwifiex_ie_types_header));
+		rssi_tlv->abs_value = subsc_evt_cfg->bcn_l_rssi_cfg.abs_value;
+		rssi_tlv->evt_freq = subsc_evt_cfg->bcn_l_rssi_cfg.evt_freq;
+
+		dev_dbg(priv->adapter->dev, "Cfg Beacon Low Rssi event, "
+			"RSSI:-%d dBm, Freq:%d\n",
+			subsc_evt_cfg->bcn_l_rssi_cfg.abs_value,
+			subsc_evt_cfg->bcn_l_rssi_cfg.evt_freq);
+
+		pos += sizeof(struct mwifiex_ie_types_rssi_threshold);
+		le16_add_cpu(&cmd->size,
+			     sizeof(struct mwifiex_ie_types_rssi_threshold));
+	}
+
+	if (event_bitmap & BITMASK_BCN_RSSI_HIGH) {
+		rssi_tlv = (struct mwifiex_ie_types_rssi_threshold *) pos;
+
+		rssi_tlv->header.type = cpu_to_le16(TLV_TYPE_RSSI_HIGH);
+		rssi_tlv->header.len =
+		    cpu_to_le16(sizeof(struct mwifiex_ie_types_rssi_threshold) -
+				sizeof(struct mwifiex_ie_types_header));
+		rssi_tlv->abs_value = subsc_evt_cfg->bcn_h_rssi_cfg.abs_value;
+		rssi_tlv->evt_freq = subsc_evt_cfg->bcn_h_rssi_cfg.evt_freq;
+
+		dev_dbg(priv->adapter->dev, "Cfg Beacon Low Rssi event, "
+			"RSSI:-%d dBm, Freq:%d\n",
+			subsc_evt_cfg->bcn_h_rssi_cfg.abs_value,
+			subsc_evt_cfg->bcn_h_rssi_cfg.evt_freq);
+
+		pos += sizeof(struct mwifiex_ie_types_rssi_threshold);
+		le16_add_cpu(&cmd->size,
+			     sizeof(struct mwifiex_ie_types_rssi_threshold));
+	}
+
+	return 0;
+}
+
+/*
  * This function prepares the commands before sending them to the firmware.
  *
  * This is a generic function which calls specific command preparation
@@ -1086,6 +1181,9 @@ int mwifiex_sta_prepare_cmd(struct mwifiex_private *priv, uint16_t cmd_no,
 	case HostCmd_CMD_PCIE_DESC_DETAILS:
 		ret = mwifiex_cmd_pcie_host_spec(priv, cmd_ptr, cmd_action);
 		break;
+	case HostCmd_CMD_802_11_SUBSCRIBE_EVENT:
+		ret = mwifiex_cmd_802_11_subsc_evt(priv, cmd_ptr, data_buf);
+		break;
 	default:
 		dev_err(priv->adapter->dev,
 			"PREP_CMD: unknown cmd- %#x\n", cmd_no);
diff --git a/drivers/net/wireless/mwifiex/sta_cmdresp.c b/drivers/net/wireless/mwifiex/sta_cmdresp.c
index cd90b6f..3aa5424 100644
--- a/drivers/net/wireless/mwifiex/sta_cmdresp.c
+++ b/drivers/net/wireless/mwifiex/sta_cmdresp.c
@@ -123,6 +123,7 @@ static int mwifiex_ret_802_11_rssi_info(struct mwifiex_private *priv,
 {
 	struct host_cmd_ds_802_11_rssi_info_rsp *rssi_info_rsp =
 						&resp->params.rssi_info_rsp;
+	struct mwifiex_ds_misc_subsc_evt subsc_evt;
 
 	priv->data_rssi_last = le16_to_cpu(rssi_info_rsp->data_rssi_last);
 	priv->data_nf_last = le16_to_cpu(rssi_info_rsp->data_nf_last);
@@ -136,6 +137,30 @@ static int mwifiex_ret_802_11_rssi_info(struct mwifiex_private *priv,
 	priv->bcn_rssi_avg = le16_to_cpu(rssi_info_rsp->bcn_rssi_avg);
 	priv->bcn_nf_avg = le16_to_cpu(rssi_info_rsp->bcn_nf_avg);
 
+	if (priv->subsc_evt_rssi_state == EVENT_HANDLED)
+		return 0;
+
+	/* Resubscribe low and high rssi events with new thresholds */
+	memset(&subsc_evt, 0x00, sizeof(struct mwifiex_ds_misc_subsc_evt));
+	subsc_evt.events = BITMASK_BCN_RSSI_LOW | BITMASK_BCN_RSSI_HIGH;
+	subsc_evt.action = HostCmd_ACT_BITWISE_SET;
+	if (priv->subsc_evt_rssi_state == RSSI_LOW_RECVD) {
+		subsc_evt.bcn_l_rssi_cfg.abs_value = abs(priv->bcn_rssi_avg -
+				priv->cqm_rssi_hyst);
+		subsc_evt.bcn_h_rssi_cfg.abs_value = abs(priv->cqm_rssi_thold);
+	} else if (priv->subsc_evt_rssi_state == RSSI_HIGH_RECVD) {
+		subsc_evt.bcn_l_rssi_cfg.abs_value = abs(priv->cqm_rssi_thold);
+		subsc_evt.bcn_h_rssi_cfg.abs_value = abs(priv->bcn_rssi_avg +
+				priv->cqm_rssi_hyst);
+	}
+	subsc_evt.bcn_l_rssi_cfg.evt_freq = 1;
+	subsc_evt.bcn_h_rssi_cfg.evt_freq = 1;
+
+	priv->subsc_evt_rssi_state = EVENT_HANDLED;
+
+	mwifiex_send_cmd_async(priv, HostCmd_CMD_802_11_SUBSCRIBE_EVENT,
+			       0, 0, &subsc_evt);
+
 	return 0;
 }
 
@@ -755,6 +780,28 @@ static int mwifiex_ret_ibss_coalescing_status(struct mwifiex_private *priv,
 }
 
 /*
+ * This function handles the command response for subscribe event command.
+ */
+static int mwifiex_ret_subsc_evt(struct mwifiex_private *priv,
+				 struct host_cmd_ds_command *resp,
+				 struct mwifiex_ds_misc_subsc_evt *sub_event)
+{
+	struct host_cmd_ds_802_11_subsc_evt *cmd_sub_event =
+		(struct host_cmd_ds_802_11_subsc_evt *)&resp->params.subsc_evt;
+
+	/* For every subscribe event command (Get/Set/Clear), FW reports the
+	 * current set of subscribed events*/
+	dev_dbg(priv->adapter->dev, "Bitmap of currently subscribed events: %16x\n",
+		le16_to_cpu(cmd_sub_event->events));
+
+	/*Return the subscribed event info for a Get request*/
+	if (sub_event)
+		sub_event->events = le16_to_cpu(cmd_sub_event->events);
+
+	return 0;
+}
+
+/*
  * This function handles the command responses.
  *
  * This is a generic function, which calls command specific
@@ -894,6 +941,9 @@ int mwifiex_process_sta_cmdresp(struct mwifiex_private *priv, u16 cmdresp_no,
 		break;
 	case HostCmd_CMD_PCIE_DESC_DETAILS:
 		break;
+	case HostCmd_CMD_802_11_SUBSCRIBE_EVENT:
+		ret = mwifiex_ret_subsc_evt(priv, resp, data_buf);
+		break;
 	default:
 		dev_err(adapter->dev, "CMD_RESP: unknown cmd response %#x\n",
 			resp->command);
diff --git a/drivers/net/wireless/mwifiex/sta_event.c b/drivers/net/wireless/mwifiex/sta_event.c
index 33b311c..f6bbb93 100644
--- a/drivers/net/wireless/mwifiex/sta_event.c
+++ b/drivers/net/wireless/mwifiex/sta_event.c
@@ -314,6 +314,12 @@ int mwifiex_process_sta_event(struct mwifiex_private *priv)
 		break;
 
 	case EVENT_RSSI_LOW:
+		cfg80211_cqm_rssi_notify(priv->netdev,
+					 NL80211_CQM_RSSI_THRESHOLD_EVENT_LOW,
+					 GFP_KERNEL);
+		mwifiex_send_cmd_async(priv, HostCmd_CMD_RSSI_INFO,
+				       HostCmd_ACT_GEN_GET, 0, NULL);
+		priv->subsc_evt_rssi_state = RSSI_LOW_RECVD;
 		dev_dbg(adapter->dev, "event: Beacon RSSI_LOW\n");
 		break;
 	case EVENT_SNR_LOW:
@@ -323,6 +329,12 @@ int mwifiex_process_sta_event(struct mwifiex_private *priv)
 		dev_dbg(adapter->dev, "event: MAX_FAIL\n");
 		break;
 	case EVENT_RSSI_HIGH:
+		cfg80211_cqm_rssi_notify(priv->netdev,
+					 NL80211_CQM_RSSI_THRESHOLD_EVENT_HIGH,
+					 GFP_KERNEL);
+		mwifiex_send_cmd_async(priv, HostCmd_CMD_RSSI_INFO,
+				       HostCmd_ACT_GEN_GET, 0, NULL);
+		priv->subsc_evt_rssi_state = RSSI_HIGH_RECVD;
 		dev_dbg(adapter->dev, "event: Beacon RSSI_HIGH\n");
 		break;
 	case EVENT_SNR_HIGH:
-- 
1.7.0.2

