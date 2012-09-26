Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from na3sys009aog122.obsmtp.com ([74.125.149.147]:55525 "EHLO
	na3sys009aog122.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751781Ab2IZD3K (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 25 Sep 2012 23:29:10 -0400
From: Bing Zhao <bzhao@marvell.com>
To: linux-wireless@vger.kernel.org
Cc: "John W. Linville" <linville@tuxdriver.com>,
	Amitkumar Karwar <akarwar@marvell.com>,
	Avinash Patil <patila@marvell.com>,
	Nishant Sarmukadam <nishants@marvell.com>,
	Stone Piao <piaoyun@marvell.com>,
	Frank Huang <frankh@marvell.com>, Bing Zhao <bzhao@marvell.com>
Subject: [PATCH 06/15] mwifiex: implement remain_on_channel and cancel_remain_on_channel
Date: Tue, 25 Sep 2012 20:23:36 -0700
Message-Id: <1348629825-12001-7-git-send-email-bzhao@marvell.com> (sfid-20120926_052914_293349_527A22A4)
In-Reply-To: <1348629825-12001-1-git-send-email-bzhao@marvell.com>
References: <1348629825-12001-1-git-send-email-bzhao@marvell.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Stone Piao <piaoyun@marvell.com>

Add a new command to implement remain_on_channel and
cancel_remain_on_channel.

Signed-off-by: Stone Piao <piaoyun@marvell.com>
Signed-off-by: Kiran Divekar <dkiran@marvell.com>
Signed-off-by: Bing Zhao <bzhao@marvell.com>
---
 drivers/net/wireless/mwifiex/cfg80211.c    |   82 +++++++++++++++++++++++++++-
 drivers/net/wireless/mwifiex/fw.h          |   12 ++++
 drivers/net/wireless/mwifiex/init.c        |    2 +-
 drivers/net/wireless/mwifiex/main.h        |   15 +++++-
 drivers/net/wireless/mwifiex/sta_cmd.c     |    8 +++
 drivers/net/wireless/mwifiex/sta_cmdresp.c |   19 +++++++
 drivers/net/wireless/mwifiex/sta_ioctl.c   |   29 ++++++++++
 drivers/net/wireless/mwifiex/util.c        |    2 +-
 8 files changed, 163 insertions(+), 6 deletions(-)

diff --git a/drivers/net/wireless/mwifiex/cfg80211.c b/drivers/net/wireless/mwifiex/cfg80211.c
index f86043d..261d7c5 100644
--- a/drivers/net/wireless/mwifiex/cfg80211.c
+++ b/drivers/net/wireless/mwifiex/cfg80211.c
@@ -77,8 +77,7 @@ static const struct ieee80211_regdomain mwifiex_world_regdom_custom = {
  *      NL80211_CHAN_HT40MINUS -> IEEE80211_HT_PARAM_CHA_SEC_BELOW
  *      Others                 -> IEEE80211_HT_PARAM_CHA_SEC_NONE
  */
-static u8
-mwifiex_chan_type_to_sec_chan_offset(enum nl80211_channel_type chan_type)
+u8 mwifiex_chan_type_to_sec_chan_offset(enum nl80211_channel_type chan_type)
 {
 	switch (chan_type) {
 	case NL80211_CHAN_NO_HT:
@@ -248,6 +247,79 @@ mwifiex_cfg80211_mgmt_frame_register(struct wiphy *wiphy,
 }
 
 /*
+ * CFG802.11 operation handler to remain on channel.
+ */
+static int
+mwifiex_cfg80211_remain_on_channel(struct wiphy *wiphy,
+				   struct wireless_dev *wdev,
+				   struct ieee80211_channel *chan,
+				   enum nl80211_channel_type channel_type,
+				   unsigned int duration, u64 *cookie)
+{
+	struct mwifiex_private *priv = mwifiex_netdev_get_priv(wdev->netdev);
+	int ret;
+
+	if (!chan || !cookie) {
+		wiphy_err(wiphy, "Invalid parameter for ROC\n");
+		return -EINVAL;
+	}
+
+	if (priv->roc_cfg.cookie) {
+		wiphy_dbg(wiphy, "info: ongoing ROC, cookie = 0x%llu\n",
+			  priv->roc_cfg.cookie);
+		return -EBUSY;
+	}
+
+	ret = mwifiex_remain_on_chan_cfg(priv, HostCmd_ACT_GEN_SET, chan,
+					 &channel_type, duration);
+
+	if (!ret) {
+		*cookie = random32() | 1;
+		priv->roc_cfg.cookie = *cookie;
+		priv->roc_cfg.chan = *chan;
+		priv->roc_cfg.chan_type = channel_type;
+
+		cfg80211_ready_on_channel(wdev, *cookie, chan, channel_type,
+					  duration, GFP_ATOMIC);
+
+		wiphy_dbg(wiphy, "info: ROC, cookie = 0x%llx\n", *cookie);
+	}
+
+	return ret;
+}
+
+/*
+ * CFG802.11 operation handler to cancel remain on channel.
+ */
+static int
+mwifiex_cfg80211_cancel_remain_on_channel(struct wiphy *wiphy,
+					  struct wireless_dev *wdev, u64 cookie)
+{
+	struct mwifiex_private *priv = mwifiex_netdev_get_priv(wdev->netdev);
+	int ret;
+
+	if (cookie != priv->roc_cfg.cookie)
+		return -ENOENT;
+
+	ret = mwifiex_remain_on_chan_cfg(priv, HostCmd_ACT_GEN_REMOVE,
+					 &priv->roc_cfg.chan,
+					 &priv->roc_cfg.chan_type, 0);
+
+	if (!ret) {
+		cfg80211_remain_on_channel_expired(wdev, cookie,
+						   &priv->roc_cfg.chan,
+						   priv->roc_cfg.chan_type,
+						   GFP_ATOMIC);
+
+		memset(&priv->roc_cfg, 0, sizeof(struct mwifiex_roc_cfg));
+
+		wiphy_dbg(wiphy, "info: cancel ROC, cookie = 0x%llx\n", cookie);
+	}
+
+	return ret;
+}
+
+/*
  * CFG802.11 operation handler to set Tx power.
  */
 static int
@@ -1950,6 +2022,8 @@ static struct cfg80211_ops mwifiex_cfg80211_ops = {
 	.del_key = mwifiex_cfg80211_del_key,
 	.mgmt_tx = mwifiex_cfg80211_mgmt_tx,
 	.mgmt_frame_register = mwifiex_cfg80211_mgmt_frame_register,
+	.remain_on_channel = mwifiex_cfg80211_remain_on_channel,
+	.cancel_remain_on_channel = mwifiex_cfg80211_cancel_remain_on_channel,
 	.set_default_key = mwifiex_cfg80211_set_default_key,
 	.set_power_mgmt = mwifiex_cfg80211_set_power_mgmt,
 	.set_tx_power = mwifiex_cfg80211_set_tx_power,
@@ -1987,6 +2061,7 @@ int mwifiex_register_cfg80211(struct mwifiex_adapter *adapter)
 	wiphy->max_scan_ssids = MWIFIEX_MAX_SSID_LIST_LENGTH;
 	wiphy->max_scan_ie_len = MWIFIEX_MAX_VSIE_LEN;
 	wiphy->mgmt_stypes = mwifiex_mgmt_stypes;
+	wiphy->max_remain_on_channel_duration = 5000;
 	wiphy->interface_modes = BIT(NL80211_IFTYPE_STATION) |
 				 BIT(NL80211_IFTYPE_ADHOC) |
 				 BIT(NL80211_IFTYPE_AP);
@@ -2008,7 +2083,8 @@ int mwifiex_register_cfg80211(struct mwifiex_adapter *adapter)
 	wiphy->signal_type = CFG80211_SIGNAL_TYPE_MBM;
 	wiphy->flags |= WIPHY_FLAG_HAVE_AP_SME |
 			WIPHY_FLAG_AP_PROBE_RESP_OFFLOAD |
-			WIPHY_FLAG_CUSTOM_REGULATORY;
+			WIPHY_FLAG_CUSTOM_REGULATORY |
+			WIPHY_FLAG_HAS_REMAIN_ON_CHANNEL;
 
 	wiphy_apply_custom_regulatory(wiphy, &mwifiex_world_regdom_custom);
 
diff --git a/drivers/net/wireless/mwifiex/fw.h b/drivers/net/wireless/mwifiex/fw.h
index b587ea3..9818cae 100644
--- a/drivers/net/wireless/mwifiex/fw.h
+++ b/drivers/net/wireless/mwifiex/fw.h
@@ -265,6 +265,7 @@ enum MWIFIEX_802_11_PRIVACY_FILTER {
 #define HostCmd_CMD_SET_BSS_MODE                      0x00f7
 #define HostCmd_CMD_PCIE_DESC_DETAILS                 0x00fa
 #define HostCmd_CMD_MGMT_FRAME_REG                    0x010c
+#define HostCmd_CMD_REMAIN_ON_CHAN                    0x010d
 
 #define PROTOCOL_NO_SECURITY        0x01
 #define PROTOCOL_STATIC_WEP         0x02
@@ -293,6 +294,7 @@ enum ENH_PS_MODES {
 #define HostCmd_RET_BIT                       0x8000
 #define HostCmd_ACT_GEN_GET                   0x0000
 #define HostCmd_ACT_GEN_SET                   0x0001
+#define HostCmd_ACT_GEN_REMOVE                0x0004
 #define HostCmd_ACT_BITWISE_SET               0x0002
 #define HostCmd_ACT_BITWISE_CLR               0x0003
 #define HostCmd_RESULT_OK                     0x0000
@@ -1343,6 +1345,15 @@ struct host_cmd_ds_mgmt_frame_reg {
 	__le32 mask;
 } __packed;
 
+struct host_cmd_ds_remain_on_chan {
+	__le16 action;
+	u8 status;
+	u8 reserved;
+	u8 band_cfg;
+	u8 channel;
+	__le32 duration;
+} __packed;
+
 struct host_cmd_ds_802_11_ibss_status {
 	__le16 action;
 	__le16 enable;
@@ -1452,6 +1463,7 @@ struct host_cmd_ds_command {
 		struct host_cmd_ds_802_11_key_material key_material;
 		struct host_cmd_ds_version_ext verext;
 		struct host_cmd_ds_mgmt_frame_reg reg_mask;
+		struct host_cmd_ds_remain_on_chan roc_cfg;
 		struct host_cmd_ds_802_11_ibss_status ibss_coalescing;
 		struct host_cmd_ds_mac_reg_access mac_reg;
 		struct host_cmd_ds_bbp_reg_access bbp_reg;
diff --git a/drivers/net/wireless/mwifiex/init.c b/drivers/net/wireless/mwifiex/init.c
index 105a5c5..fa96dc3 100644
--- a/drivers/net/wireless/mwifiex/init.c
+++ b/drivers/net/wireless/mwifiex/init.c
@@ -214,7 +214,7 @@ static int mwifiex_init_priv(struct mwifiex_private *priv)
 	priv->wps_ie = NULL;
 	priv->wps_ie_len = 0;
 	priv->ap_11n_enabled = 0;
-	priv->mgmt_rx_freq = 2437;
+	memset(&priv->roc_cfg, 0, sizeof(priv->roc_cfg));
 
 	priv->scan_block = false;
 
diff --git a/drivers/net/wireless/mwifiex/main.h b/drivers/net/wireless/mwifiex/main.h
index ec5794e..89ba66e 100644
--- a/drivers/net/wireless/mwifiex/main.h
+++ b/drivers/net/wireless/mwifiex/main.h
@@ -370,6 +370,12 @@ struct wps {
 	u8 session_enable;
 };
 
+struct mwifiex_roc_cfg {
+	u64 cookie;
+	struct ieee80211_channel chan;
+	enum nl80211_channel_type chan_type;
+};
+
 struct mwifiex_adapter;
 struct mwifiex_private;
 
@@ -497,7 +503,7 @@ struct mwifiex_private {
 	struct timer_list scan_delay_timer;
 	u8 ap_11n_enabled;
 	u32 mgmt_frame_mask;
-	u32 mgmt_rx_freq;
+	struct mwifiex_roc_cfg roc_cfg;
 };
 
 enum mwifiex_ba_status {
@@ -1007,6 +1013,11 @@ int mwifiex_set_gen_ie(struct mwifiex_private *priv, u8 *ie, int ie_len);
 
 int mwifiex_get_ver_ext(struct mwifiex_private *priv);
 
+int mwifiex_remain_on_chan_cfg(struct mwifiex_private *priv, u16 action,
+			       struct ieee80211_channel *chan,
+			       enum nl80211_channel_type *channel_type,
+			       unsigned int duration);
+
 int mwifiex_get_stats_info(struct mwifiex_private *priv,
 			   struct mwifiex_ds_get_stats *log);
 
@@ -1049,6 +1060,8 @@ int mwifiex_update_bss_desc_with_ie(struct mwifiex_adapter *adapter,
 int mwifiex_check_network_compatibility(struct mwifiex_private *priv,
 					struct mwifiex_bssdescriptor *bss_desc);
 
+u8 mwifiex_chan_type_to_sec_chan_offset(enum nl80211_channel_type chan_type);
+
 struct wireless_dev *mwifiex_add_virtual_intf(struct wiphy *wiphy,
 					      const char *name,
 					      enum nl80211_iftype type,
diff --git a/drivers/net/wireless/mwifiex/sta_cmd.c b/drivers/net/wireless/mwifiex/sta_cmd.c
index dc4fe8c..0252446 100644
--- a/drivers/net/wireless/mwifiex/sta_cmd.c
+++ b/drivers/net/wireless/mwifiex/sta_cmd.c
@@ -1176,6 +1176,14 @@ int mwifiex_sta_prepare_cmd(struct mwifiex_private *priv, uint16_t cmd_no,
 				    S_DS_GEN);
 		ret = 0;
 		break;
+	case HostCmd_CMD_REMAIN_ON_CHAN:
+		cmd_ptr->command = cpu_to_le16(cmd_no);
+		memcpy(&cmd_ptr->params, data_buf,
+		       sizeof(struct host_cmd_ds_remain_on_chan));
+		cmd_ptr->size =
+		      cpu_to_le16(sizeof(struct host_cmd_ds_remain_on_chan) +
+				  S_DS_GEN);
+		break;
 	case HostCmd_CMD_FUNC_INIT:
 		if (priv->adapter->hw_status == MWIFIEX_HW_STATUS_RESET)
 			priv->adapter->hw_status = MWIFIEX_HW_STATUS_READY;
diff --git a/drivers/net/wireless/mwifiex/sta_cmdresp.c b/drivers/net/wireless/mwifiex/sta_cmdresp.c
index d1f53e3..621d36e 100644
--- a/drivers/net/wireless/mwifiex/sta_cmdresp.c
+++ b/drivers/net/wireless/mwifiex/sta_cmdresp.c
@@ -654,6 +654,22 @@ static int mwifiex_ret_ver_ext(struct mwifiex_private *priv,
 }
 
 /*
+ * This function handles the command response of remain on channel.
+ */
+static int
+mwifiex_ret_remain_on_chan(struct mwifiex_private *priv,
+			   struct host_cmd_ds_command *resp,
+			   struct host_cmd_ds_remain_on_chan *roc_cfg)
+{
+	struct host_cmd_ds_remain_on_chan *resp_cfg = &resp->params.roc_cfg;
+
+	if (roc_cfg)
+		memcpy(roc_cfg, resp_cfg, sizeof(*roc_cfg));
+
+	return 0;
+}
+
+/*
  * This function handles the command response of register access.
  *
  * The register value and offset are returned to the user. For EEPROM
@@ -875,6 +891,9 @@ int mwifiex_process_sta_cmdresp(struct mwifiex_private *priv, u16 cmdresp_no,
 	case HostCmd_CMD_VERSION_EXT:
 		ret = mwifiex_ret_ver_ext(priv, resp, data_buf);
 		break;
+	case HostCmd_CMD_REMAIN_ON_CHAN:
+		ret = mwifiex_ret_remain_on_chan(priv, resp, data_buf);
+		break;
 	case HostCmd_CMD_MGMT_FRAME_REG:
 	case HostCmd_CMD_FUNC_INIT:
 	case HostCmd_CMD_FUNC_SHUTDOWN:
diff --git a/drivers/net/wireless/mwifiex/sta_ioctl.c b/drivers/net/wireless/mwifiex/sta_ioctl.c
index 731562f..fd09a21 100644
--- a/drivers/net/wireless/mwifiex/sta_ioctl.c
+++ b/drivers/net/wireless/mwifiex/sta_ioctl.c
@@ -1043,6 +1043,35 @@ mwifiex_get_ver_ext(struct mwifiex_private *priv)
 	return 0;
 }
 
+int
+mwifiex_remain_on_chan_cfg(struct mwifiex_private *priv, u16 action,
+			   struct ieee80211_channel *chan,
+			   enum nl80211_channel_type *ct,
+			   unsigned int duration)
+{
+	struct host_cmd_ds_remain_on_chan roc_cfg;
+	u8 sc;
+
+	memset(&roc_cfg, 0, sizeof(roc_cfg));
+	roc_cfg.action = cpu_to_le16(action);
+	if (action == HostCmd_ACT_GEN_SET) {
+		roc_cfg.band_cfg = chan->band;
+		sc = mwifiex_chan_type_to_sec_chan_offset(*ct);
+		roc_cfg.band_cfg |= (sc << 2);
+
+		roc_cfg.channel =
+			ieee80211_frequency_to_channel(chan->center_freq);
+		roc_cfg.duration = cpu_to_le32(duration);
+	}
+	if (mwifiex_send_cmd_sync(priv, HostCmd_CMD_REMAIN_ON_CHAN,
+				  action, 0, &roc_cfg)) {
+		dev_err(priv->adapter->dev, "failed to remain on channel\n");
+		return -1;
+	}
+
+	return roc_cfg.status;
+}
+
 /*
  * Sends IOCTL request to get statistics information.
  *
diff --git a/drivers/net/wireless/mwifiex/util.c b/drivers/net/wireless/mwifiex/util.c
index e1dc3e4..ae88f80 100644
--- a/drivers/net/wireless/mwifiex/util.c
+++ b/drivers/net/wireless/mwifiex/util.c
@@ -174,7 +174,7 @@ mwifiex_process_mgmt_packet(struct mwifiex_adapter *adapter,
 	pkt_len -= ETH_ALEN + sizeof(pkt_len);
 	rx_pd->rx_pkt_length = cpu_to_le16(pkt_len);
 
-	cfg80211_rx_mgmt(priv->wdev, priv->mgmt_rx_freq,
+	cfg80211_rx_mgmt(priv->wdev, priv->roc_cfg.chan.center_freq,
 			 CAL_RSSI(rx_pd->snr, rx_pd->nf),
 			 skb->data, pkt_len, GFP_ATOMIC);
 
-- 
1.7.0.2

