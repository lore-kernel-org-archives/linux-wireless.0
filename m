Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from na3sys009aog112.obsmtp.com ([74.125.149.207]:58594 "HELO
	na3sys009aog112.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1751668Ab2GNDMC (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 13 Jul 2012 23:12:02 -0400
From: Bing Zhao <bzhao@marvell.com>
To: linux-wireless@vger.kernel.org
Cc: "John W. Linville" <linville@tuxdriver.com>,
	Amitkumar Karwar <akarwar@marvell.com>,
	Avinash Patil <patila@marvell.com>,
	Kiran Divekar <dkiran@marvell.com>,
	Yogesh Powar <yogeshp@marvell.com>,
	Stone Piao <piaoyun@marvell.com>, Ying Luo <luoy@marvell.com>,
	Frank Huang <frankh@marvell.com>, Bing Zhao <bzhao@marvell.com>
Subject: [PATCH 1/4] mwifiex: remove redundant code in set channel path
Date: Fri, 13 Jul 2012 20:09:30 -0700
Message-Id: <1342235373-27613-2-git-send-email-bzhao@marvell.com> (sfid-20120714_051241_277552_BCC2864D)
In-Reply-To: <1342235373-27613-1-git-send-email-bzhao@marvell.com>
References: <1342235373-27613-1-git-send-email-bzhao@marvell.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Amitkumar Karwar <akarwar@marvell.com>

1) Recently we removed set_channel cfg80211 handler. Also, cfg80211
blocks ibss connection requests if ibss network is already started
/joined. Hence the code to restart ibss network in new channel
(mwifiex_drv_change_adhoc_chan() function) becomes redundant.

2) mwifiex_bss_set_channel() function is redundant. It does some
error checking and calculate adhoc start band and adhoc channel.
Cfg80211 already takes care of error checking and provides correct
channel information to the driver. Adhoc start band is already
calculated in mwifiex_set_rf_channel() function.

Other associated code is also removed in this patch.

Signed-off-by: Amitkumar Karwar <akarwar@marvell.com>
Signed-off-by: Bing Zhao <bzhao@marvell.com>
---
 drivers/net/wireless/mwifiex/cfg80211.c    |   15 +---
 drivers/net/wireless/mwifiex/fw.h          |   10 --
 drivers/net/wireless/mwifiex/main.h        |    4 -
 drivers/net/wireless/mwifiex/sta_cmd.c     |   38 -------
 drivers/net/wireless/mwifiex/sta_cmdresp.c |   31 ------
 drivers/net/wireless/mwifiex/sta_ioctl.c   |  163 ----------------------------
 6 files changed, 2 insertions(+), 259 deletions(-)

diff --git a/drivers/net/wireless/mwifiex/cfg80211.c b/drivers/net/wireless/mwifiex/cfg80211.c
index b1b2027..4b99ad5 100644
--- a/drivers/net/wireless/mwifiex/cfg80211.c
+++ b/drivers/net/wireless/mwifiex/cfg80211.c
@@ -349,7 +349,6 @@ mwifiex_set_rf_channel(struct mwifiex_private *priv,
 		       struct ieee80211_channel *chan,
 		       enum nl80211_channel_type channel_type)
 {
-	struct mwifiex_chan_freq_power cfp;
 	u32 config_bands = 0;
 	struct wiphy *wiphy = priv->wdev->wiphy;
 	struct mwifiex_adapter *adapter = priv->adapter;
@@ -389,24 +388,14 @@ mwifiex_set_rf_channel(struct mwifiex_private *priv,
 			mwifiex_cfg80211_channel_type_to_sec_chan_offset
 			(channel_type);
 		adapter->channel_type = channel_type;
+		priv->adhoc_channel =
+			ieee80211_frequency_to_channel(chan->center_freq);
 
 		mwifiex_send_domain_info_cmd_fw(wiphy);
 	}
 
 	wiphy_dbg(wiphy, "info: setting band %d, chan offset %d, mode %d\n",
 		  config_bands, adapter->sec_chan_offset, priv->bss_mode);
-	if (!chan)
-		return 0;
-
-	memset(&cfp, 0, sizeof(cfp));
-	cfp.freq = chan->center_freq;
-	cfp.channel = ieee80211_frequency_to_channel(chan->center_freq);
-
-	if (priv->bss_type == MWIFIEX_BSS_TYPE_STA) {
-		if (mwifiex_bss_set_channel(priv, &cfp))
-			return -EFAULT;
-		return mwifiex_drv_change_adhoc_chan(priv, cfp.channel);
-	}
 
 	return 0;
 }
diff --git a/drivers/net/wireless/mwifiex/fw.h b/drivers/net/wireless/mwifiex/fw.h
index 14e985d..e831b44 100644
--- a/drivers/net/wireless/mwifiex/fw.h
+++ b/drivers/net/wireless/mwifiex/fw.h
@@ -225,7 +225,6 @@ enum MWIFIEX_802_11_PRIVACY_FILTER {
 #define HostCmd_CMD_BBP_REG_ACCESS                    0x001a
 #define HostCmd_CMD_RF_REG_ACCESS                     0x001b
 #define HostCmd_CMD_PMIC_REG_ACCESS                   0x00ad
-#define HostCmd_CMD_802_11_RF_CHANNEL                 0x001d
 #define HostCmd_CMD_RF_TX_PWR                         0x001e
 #define HostCmd_CMD_RF_ANTENNA                        0x0020
 #define HostCmd_CMD_802_11_DEAUTHENTICATE             0x0024
@@ -1292,14 +1291,6 @@ struct host_cmd_tlv_channel_band {
 	u8 channel;
 } __packed;
 
-struct host_cmd_ds_802_11_rf_channel {
-	__le16 action;
-	__le16 current_channel;
-	__le16 rf_type;
-	__le16 reserved;
-	u8 reserved_1[32];
-} __packed;
-
 struct host_cmd_ds_version_ext {
 	u8 version_str_sel;
 	char version_str[128];
@@ -1384,7 +1375,6 @@ struct host_cmd_ds_command {
 		struct host_cmd_ds_802_11_rssi_info rssi_info;
 		struct host_cmd_ds_802_11_rssi_info_rsp rssi_info_rsp;
 		struct host_cmd_ds_802_11_snmp_mib smib;
-		struct host_cmd_ds_802_11_rf_channel rf_channel;
 		struct host_cmd_ds_tx_rate_query tx_rate;
 		struct host_cmd_ds_tx_rate_cfg tx_rate_cfg;
 		struct host_cmd_ds_txpwr_cfg txp_cfg;
diff --git a/drivers/net/wireless/mwifiex/main.h b/drivers/net/wireless/mwifiex/main.h
index 774880d..b710649 100644
--- a/drivers/net/wireless/mwifiex/main.h
+++ b/drivers/net/wireless/mwifiex/main.h
@@ -953,8 +953,6 @@ int mwifiex_scan_networks(struct mwifiex_private *priv,
 			  const struct mwifiex_user_scan_cfg *user_scan_in);
 int mwifiex_set_radio(struct mwifiex_private *priv, u8 option);
 
-int mwifiex_drv_change_adhoc_chan(struct mwifiex_private *priv, u16 channel);
-
 int mwifiex_set_encode(struct mwifiex_private *priv, const u8 *key,
 		       int key_len, u8 key_index, const u8 *mac_addr,
 		       int disable);
@@ -993,8 +991,6 @@ int mwifiex_set_tx_power(struct mwifiex_private *priv,
 
 int mwifiex_main_process(struct mwifiex_adapter *);
 
-int mwifiex_bss_set_channel(struct mwifiex_private *,
-			    struct mwifiex_chan_freq_power *cfp);
 int mwifiex_get_bss_info(struct mwifiex_private *,
 			 struct mwifiex_bss_info *);
 int mwifiex_fill_new_bss_desc(struct mwifiex_private *priv,
diff --git a/drivers/net/wireless/mwifiex/sta_cmd.c b/drivers/net/wireless/mwifiex/sta_cmd.c
index 75eaa6f..93b06cd 100644
--- a/drivers/net/wireless/mwifiex/sta_cmd.c
+++ b/drivers/net/wireless/mwifiex/sta_cmd.c
@@ -745,40 +745,6 @@ static int mwifiex_cmd_802_11d_domain_info(struct mwifiex_private *priv,
 }
 
 /*
- * This function prepares command to set/get RF channel.
- *
- * Preparation includes -
- *      - Setting command ID, action and proper size
- *      - Setting RF type and current RF channel (for SET only)
- *      - Ensuring correct endian-ness
- */
-static int mwifiex_cmd_802_11_rf_channel(struct mwifiex_private *priv,
-					 struct host_cmd_ds_command *cmd,
-					 u16 cmd_action, u16 *channel)
-{
-	struct host_cmd_ds_802_11_rf_channel *rf_chan =
-		&cmd->params.rf_channel;
-	uint16_t rf_type = le16_to_cpu(rf_chan->rf_type);
-
-	cmd->command = cpu_to_le16(HostCmd_CMD_802_11_RF_CHANNEL);
-	cmd->size = cpu_to_le16(sizeof(struct host_cmd_ds_802_11_rf_channel)
-				+ S_DS_GEN);
-
-	if (cmd_action == HostCmd_ACT_GEN_SET) {
-		if ((priv->adapter->adhoc_start_band & BAND_A) ||
-		    (priv->adapter->adhoc_start_band & BAND_AN))
-			rf_chan->rf_type =
-				cpu_to_le16(HostCmd_SCAN_RADIO_TYPE_A);
-
-		rf_type = le16_to_cpu(rf_chan->rf_type);
-		SET_SECONDARYCHAN(rf_type, priv->adapter->sec_chan_offset);
-		rf_chan->current_channel = cpu_to_le16(*channel);
-	}
-	rf_chan->action = cpu_to_le16(cmd_action);
-	return 0;
-}
-
-/*
  * This function prepares command to set/get IBSS coalescing status.
  *
  * Preparation includes -
@@ -1175,10 +1141,6 @@ int mwifiex_sta_prepare_cmd(struct mwifiex_private *priv, uint16_t cmd_no,
 				    S_DS_GEN);
 		ret = 0;
 		break;
-	case HostCmd_CMD_802_11_RF_CHANNEL:
-		ret = mwifiex_cmd_802_11_rf_channel(priv, cmd_ptr, cmd_action,
-						    data_buf);
-		break;
 	case HostCmd_CMD_FUNC_INIT:
 		if (priv->adapter->hw_status == MWIFIEX_HW_STATUS_RESET)
 			priv->adapter->hw_status = MWIFIEX_HW_STATUS_READY;
diff --git a/drivers/net/wireless/mwifiex/sta_cmdresp.c b/drivers/net/wireless/mwifiex/sta_cmdresp.c
index 71c9b5b..43ede5e 100644
--- a/drivers/net/wireless/mwifiex/sta_cmdresp.c
+++ b/drivers/net/wireless/mwifiex/sta_cmdresp.c
@@ -656,34 +656,6 @@ static int mwifiex_ret_802_11d_domain_info(struct mwifiex_private *priv,
 }
 
 /*
- * This function handles the command response of get RF channel.
- *
- * Handling includes changing the header fields into CPU format
- * and saving the new channel in driver.
- */
-static int mwifiex_ret_802_11_rf_channel(struct mwifiex_private *priv,
-					 struct host_cmd_ds_command *resp,
-					 u16 *data_buf)
-{
-	struct host_cmd_ds_802_11_rf_channel *rf_channel =
-		&resp->params.rf_channel;
-	u16 new_channel = le16_to_cpu(rf_channel->current_channel);
-
-	if (priv->curr_bss_params.bss_descriptor.channel != new_channel) {
-		dev_dbg(priv->adapter->dev, "cmd: Channel Switch: %d to %d\n",
-			priv->curr_bss_params.bss_descriptor.channel,
-			new_channel);
-		/* Update the channel again */
-		priv->curr_bss_params.bss_descriptor.channel = new_channel;
-	}
-
-	if (data_buf)
-		*data_buf = new_channel;
-
-	return 0;
-}
-
-/*
  * This function handles the command response of get extended version.
  *
  * Handling includes forming the extended version string and sending it
@@ -935,9 +907,6 @@ int mwifiex_process_sta_cmdresp(struct mwifiex_private *priv, u16 cmdresp_no,
 	case HostCmd_CMD_802_11_TX_RATE_QUERY:
 		ret = mwifiex_ret_802_11_tx_rate_query(priv, resp);
 		break;
-	case HostCmd_CMD_802_11_RF_CHANNEL:
-		ret = mwifiex_ret_802_11_rf_channel(priv, resp, data_buf);
-		break;
 	case HostCmd_CMD_VERSION_EXT:
 		ret = mwifiex_ret_ver_ext(priv, resp, data_buf);
 		break;
diff --git a/drivers/net/wireless/mwifiex/sta_ioctl.c b/drivers/net/wireless/mwifiex/sta_ioctl.c
index f2fd242..6dff016 100644
--- a/drivers/net/wireless/mwifiex/sta_ioctl.c
+++ b/drivers/net/wireless/mwifiex/sta_ioctl.c
@@ -497,169 +497,6 @@ int mwifiex_disable_auto_ds(struct mwifiex_private *priv)
 EXPORT_SYMBOL_GPL(mwifiex_disable_auto_ds);
 
 /*
- * IOCTL request handler to set/get active channel.
- *
- * This function performs validity checking on channel/frequency
- * compatibility and returns failure if not valid.
- */
-int mwifiex_bss_set_channel(struct mwifiex_private *priv,
-			    struct mwifiex_chan_freq_power *chan)
-{
-	struct mwifiex_adapter *adapter = priv->adapter;
-	struct mwifiex_chan_freq_power *cfp = NULL;
-
-	if (!chan)
-		return -1;
-
-	if (!chan->channel && !chan->freq)
-		return -1;
-	if (adapter->adhoc_start_band & BAND_AN)
-		adapter->adhoc_start_band = BAND_G | BAND_B | BAND_GN;
-	else if (adapter->adhoc_start_band & BAND_A)
-		adapter->adhoc_start_band = BAND_G | BAND_B;
-	if (chan->channel) {
-		if (chan->channel <= MAX_CHANNEL_BAND_BG)
-			cfp = mwifiex_get_cfp(priv, 0, (u16) chan->channel, 0);
-		if (!cfp) {
-			cfp = mwifiex_get_cfp(priv, BAND_A,
-					      (u16) chan->channel, 0);
-			if (cfp) {
-				if (adapter->adhoc_11n_enabled)
-					adapter->adhoc_start_band = BAND_A
-								    | BAND_AN;
-				else
-					adapter->adhoc_start_band = BAND_A;
-			}
-		}
-	} else {
-		if (chan->freq <= MAX_FREQUENCY_BAND_BG)
-			cfp = mwifiex_get_cfp(priv, 0, 0, chan->freq);
-		if (!cfp) {
-			cfp = mwifiex_get_cfp(priv, BAND_A, 0, chan->freq);
-			if (cfp) {
-				if (adapter->adhoc_11n_enabled)
-					adapter->adhoc_start_band = BAND_A
-								    | BAND_AN;
-				else
-					adapter->adhoc_start_band = BAND_A;
-			}
-		}
-	}
-	if (!cfp || !cfp->channel) {
-		dev_err(adapter->dev, "invalid channel/freq\n");
-		return -1;
-	}
-	priv->adhoc_channel = (u8) cfp->channel;
-	chan->channel = cfp->channel;
-	chan->freq = cfp->freq;
-
-	return 0;
-}
-
-/*
- * IOCTL request handler to set/get Ad-Hoc channel.
- *
- * This function prepares the correct firmware command and
- * issues it to set or get the ad-hoc channel.
- */
-static int mwifiex_bss_ioctl_ibss_channel(struct mwifiex_private *priv,
-					  u16 action, u16 *channel)
-{
-	if (action == HostCmd_ACT_GEN_GET) {
-		if (!priv->media_connected) {
-			*channel = priv->adhoc_channel;
-			return 0;
-		}
-	} else {
-		priv->adhoc_channel = (u8) *channel;
-	}
-
-	return mwifiex_send_cmd_sync(priv, HostCmd_CMD_802_11_RF_CHANNEL,
-				     action, 0, channel);
-}
-
-/*
- * IOCTL request handler to change Ad-Hoc channel.
- *
- * This function allocates the IOCTL request buffer, fills it
- * with requisite parameters and calls the IOCTL handler.
- *
- * The function follows the following steps to perform the change -
- *      - Get current IBSS information
- *      - Get current channel
- *      - If no change is required, return
- *      - If not connected, change channel and return
- *      - If connected,
- *          - Disconnect
- *          - Change channel
- *          - Perform specific SSID scan with same SSID
- *          - Start/Join the IBSS
- */
-int
-mwifiex_drv_change_adhoc_chan(struct mwifiex_private *priv, u16 channel)
-{
-	int ret;
-	struct mwifiex_bss_info bss_info;
-	struct mwifiex_ssid_bssid ssid_bssid;
-	u16 curr_chan = 0;
-	struct cfg80211_bss *bss = NULL;
-	struct ieee80211_channel *chan;
-	enum ieee80211_band band;
-
-	memset(&bss_info, 0, sizeof(bss_info));
-
-	/* Get BSS information */
-	if (mwifiex_get_bss_info(priv, &bss_info))
-		return -1;
-
-	/* Get current channel */
-	ret = mwifiex_bss_ioctl_ibss_channel(priv, HostCmd_ACT_GEN_GET,
-					     &curr_chan);
-
-	if (curr_chan == channel) {
-		ret = 0;
-		goto done;
-	}
-	dev_dbg(priv->adapter->dev, "cmd: updating channel from %d to %d\n",
-		curr_chan, channel);
-
-	if (!bss_info.media_connected) {
-		ret = 0;
-		goto done;
-	}
-
-	/* Do disonnect */
-	memset(&ssid_bssid, 0, ETH_ALEN);
-	ret = mwifiex_deauthenticate(priv, ssid_bssid.bssid);
-
-	ret = mwifiex_bss_ioctl_ibss_channel(priv, HostCmd_ACT_GEN_SET,
-					     &channel);
-
-	/* Do specific SSID scanning */
-	if (mwifiex_request_scan(priv, &bss_info.ssid)) {
-		ret = -1;
-		goto done;
-	}
-
-	band = mwifiex_band_to_radio_type(priv->curr_bss_params.band);
-	chan = __ieee80211_get_channel(priv->wdev->wiphy,
-				       ieee80211_channel_to_frequency(channel,
-								      band));
-
-	/* Find the BSS we want using available scan results */
-	bss = cfg80211_get_bss(priv->wdev->wiphy, chan, bss_info.bssid,
-			       bss_info.ssid.ssid, bss_info.ssid.ssid_len,
-			       WLAN_CAPABILITY_ESS, WLAN_CAPABILITY_ESS);
-	if (!bss)
-		wiphy_warn(priv->wdev->wiphy, "assoc: bss %pM not in scan results\n",
-			   bss_info.bssid);
-
-	ret = mwifiex_bss_start(priv, bss, &bss_info.ssid);
-done:
-	return ret;
-}
-
-/*
  * IOCTL request handler to get rate.
  *
  * This function prepares the correct firmware command and
-- 
1.7.0.2

