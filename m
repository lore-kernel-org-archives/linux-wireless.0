Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from na3sys009aog105.obsmtp.com ([74.125.149.75]:54805 "HELO
	na3sys009aog105.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1161299Ab2CPDwa (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 15 Mar 2012 23:52:30 -0400
From: Bing Zhao <bzhao@marvell.com>
To: linux-wireless@vger.kernel.org
Cc: "John W. Linville" <linville@tuxdriver.com>,
	Amitkumar Karwar <akarwar@marvell.com>,
	Kiran Divekar <dkiran@marvell.com>,
	Yogesh Powar <yogeshp@marvell.com>,
	Avinash Patil <patila@marvell.com>,
	Frank Huang <frankh@marvell.com>, Bing Zhao <bzhao@marvell.com>
Subject: [PATCH 3/5] mwifiex: remove redundant signal handling code
Date: Thu, 15 Mar 2012 20:51:49 -0700
Message-Id: <1331869911-10624-4-git-send-email-bzhao@marvell.com> (sfid-20120316_045234_705066_AA75E24B)
In-Reply-To: <1331869911-10624-1-git-send-email-bzhao@marvell.com>
References: <1331869911-10624-1-git-send-email-bzhao@marvell.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Amitkumar Karwar <akarwar@marvell.com>

1) The wrapper function mwifiex_get_signal_info() is unnecessary.
2) As noise and signal vaules in private structure already get
modified, we don't need to explicitly pass
"struct mwifiex_ds_get_signal" to get it filled.

Signed-off-by: Amitkumar Karwar <akarwar@marvell.com>
Signed-off-by: Bing Zhao <bzhao@marvell.com>
---
 drivers/net/wireless/mwifiex/cfg80211.c    |   16 +++++-------
 drivers/net/wireless/mwifiex/ioctl.h       |   28 -----------------------
 drivers/net/wireless/mwifiex/main.h        |    3 --
 drivers/net/wireless/mwifiex/sta_cmdresp.c |   34 +--------------------------
 drivers/net/wireless/mwifiex/sta_event.c   |    3 --
 drivers/net/wireless/mwifiex/sta_ioctl.c   |   33 ---------------------------
 6 files changed, 9 insertions(+), 108 deletions(-)

diff --git a/drivers/net/wireless/mwifiex/cfg80211.c b/drivers/net/wireless/mwifiex/cfg80211.c
index 4f65419..9cf8d53 100644
--- a/drivers/net/wireless/mwifiex/cfg80211.c
+++ b/drivers/net/wireless/mwifiex/cfg80211.c
@@ -516,9 +516,7 @@ static int
 mwifiex_dump_station_info(struct mwifiex_private *priv,
 			  struct station_info *sinfo)
 {
-	struct mwifiex_ds_get_signal signal;
 	struct mwifiex_rate_cfg rate;
-	int ret = 0;
 
 	sinfo->filled = STATION_INFO_RX_BYTES | STATION_INFO_TX_BYTES |
 		STATION_INFO_RX_PACKETS |
@@ -526,15 +524,15 @@ mwifiex_dump_station_info(struct mwifiex_private *priv,
 		| STATION_INFO_SIGNAL | STATION_INFO_TX_BITRATE;
 
 	/* Get signal information from the firmware */
-	memset(&signal, 0, sizeof(struct mwifiex_ds_get_signal));
-	if (mwifiex_get_signal_info(priv, &signal)) {
-		dev_err(priv->adapter->dev, "getting signal information\n");
-		ret = -EFAULT;
+	if (mwifiex_send_cmd_sync(priv, HostCmd_CMD_RSSI_INFO,
+				  HostCmd_ACT_GEN_GET, 0, NULL)) {
+		dev_err(priv->adapter->dev, "failed to get signal information\n");
+		return -EFAULT;
 	}
 
 	if (mwifiex_drv_get_data_rate(priv, &rate)) {
 		dev_err(priv->adapter->dev, "getting data rate\n");
-		ret = -EFAULT;
+		return -EFAULT;
 	}
 
 	/* Get DTIM period information from firmware */
@@ -561,7 +559,7 @@ mwifiex_dump_station_info(struct mwifiex_private *priv,
 	sinfo->tx_bytes = priv->stats.tx_bytes;
 	sinfo->rx_packets = priv->stats.rx_packets;
 	sinfo->tx_packets = priv->stats.tx_packets;
-	sinfo->signal = priv->qual_level;
+	sinfo->signal = priv->bcn_rssi_avg;
 	/* bit rate is in 500 kb/s units. Convert it to 100kb/s units */
 	sinfo->txrate.legacy = rate.rate * 5;
 
@@ -581,7 +579,7 @@ mwifiex_dump_station_info(struct mwifiex_private *priv,
 			priv->curr_bss_params.bss_descriptor.beacon_period;
 	}
 
-	return ret;
+	return 0;
 }
 
 /*
diff --git a/drivers/net/wireless/mwifiex/ioctl.h b/drivers/net/wireless/mwifiex/ioctl.h
index 7ca4e82..58fe054 100644
--- a/drivers/net/wireless/mwifiex/ioctl.h
+++ b/drivers/net/wireless/mwifiex/ioctl.h
@@ -85,34 +85,6 @@ struct mwifiex_ds_get_stats {
 	u32 wep_icv_error[4];
 };
 
-#define BCN_RSSI_AVG_MASK               0x00000002
-#define BCN_NF_AVG_MASK                 0x00000200
-#define ALL_RSSI_INFO_MASK              0x00000fff
-
-struct mwifiex_ds_get_signal {
-	/*
-	 * Bit0:  Last Beacon RSSI,  Bit1:  Average Beacon RSSI,
-	 * Bit2:  Last Data RSSI,    Bit3:  Average Data RSSI,
-	 * Bit4:  Last Beacon SNR,   Bit5:  Average Beacon SNR,
-	 * Bit6:  Last Data SNR,     Bit7:  Average Data SNR,
-	 * Bit8:  Last Beacon NF,    Bit9:  Average Beacon NF,
-	 * Bit10: Last Data NF,      Bit11: Average Data NF
-	 */
-	u16 selector;
-	s16 bcn_rssi_last;
-	s16 bcn_rssi_avg;
-	s16 data_rssi_last;
-	s16 data_rssi_avg;
-	s16 bcn_snr_last;
-	s16 bcn_snr_avg;
-	s16 data_snr_last;
-	s16 data_snr_avg;
-	s16 bcn_nf_last;
-	s16 bcn_nf_avg;
-	s16 data_nf_last;
-	s16 data_nf_avg;
-};
-
 #define MWIFIEX_MAX_VER_STR_LEN    128
 
 struct mwifiex_ver_ext {
diff --git a/drivers/net/wireless/mwifiex/main.h b/drivers/net/wireless/mwifiex/main.h
index 35225e9..70bdfb9 100644
--- a/drivers/net/wireless/mwifiex/main.h
+++ b/drivers/net/wireless/mwifiex/main.h
@@ -448,7 +448,6 @@ struct mwifiex_private {
 	struct dentry *dfs_dev_dir;
 #endif
 	u8 nick_name[16];
-	u8 qual_level, qual_noise;
 	u16 current_key_index;
 	struct semaphore async_sem;
 	u8 scan_pending_on_block;
@@ -896,8 +895,6 @@ int mwifiex_bss_start(struct mwifiex_private *priv, struct cfg80211_bss *bss,
 int mwifiex_cancel_hs(struct mwifiex_private *priv, int cmd_type);
 int mwifiex_enable_hs(struct mwifiex_adapter *adapter);
 int mwifiex_disable_auto_ds(struct mwifiex_private *priv);
-int mwifiex_get_signal_info(struct mwifiex_private *priv,
-			    struct mwifiex_ds_get_signal *signal);
 int mwifiex_drv_get_data_rate(struct mwifiex_private *priv,
 			      struct mwifiex_rate_cfg *rate);
 int mwifiex_request_scan(struct mwifiex_private *priv,
diff --git a/drivers/net/wireless/mwifiex/sta_cmdresp.c b/drivers/net/wireless/mwifiex/sta_cmdresp.c
index 4da19ed..cd90b6f 100644
--- a/drivers/net/wireless/mwifiex/sta_cmdresp.c
+++ b/drivers/net/wireless/mwifiex/sta_cmdresp.c
@@ -119,8 +119,7 @@ mwifiex_process_cmdresp_error(struct mwifiex_private *priv,
  * calculated SNR values.
  */
 static int mwifiex_ret_802_11_rssi_info(struct mwifiex_private *priv,
-					struct host_cmd_ds_command *resp,
-					struct mwifiex_ds_get_signal *signal)
+					struct host_cmd_ds_command *resp)
 {
 	struct host_cmd_ds_802_11_rssi_info_rsp *rssi_info_rsp =
 						&resp->params.rssi_info_rsp;
@@ -137,35 +136,6 @@ static int mwifiex_ret_802_11_rssi_info(struct mwifiex_private *priv,
 	priv->bcn_rssi_avg = le16_to_cpu(rssi_info_rsp->bcn_rssi_avg);
 	priv->bcn_nf_avg = le16_to_cpu(rssi_info_rsp->bcn_nf_avg);
 
-	/* Need to indicate IOCTL complete */
-	if (signal) {
-		memset(signal, 0, sizeof(*signal));
-
-		signal->selector = ALL_RSSI_INFO_MASK;
-
-		/* RSSI */
-		signal->bcn_rssi_last = priv->bcn_rssi_last;
-		signal->bcn_rssi_avg = priv->bcn_rssi_avg;
-		signal->data_rssi_last = priv->data_rssi_last;
-		signal->data_rssi_avg = priv->data_rssi_avg;
-
-		/* SNR */
-		signal->bcn_snr_last =
-			CAL_SNR(priv->bcn_rssi_last, priv->bcn_nf_last);
-		signal->bcn_snr_avg =
-			CAL_SNR(priv->bcn_rssi_avg, priv->bcn_nf_avg);
-		signal->data_snr_last =
-			CAL_SNR(priv->data_rssi_last, priv->data_nf_last);
-		signal->data_snr_avg =
-			CAL_SNR(priv->data_rssi_avg, priv->data_nf_avg);
-
-		/* NF */
-		signal->bcn_nf_last = priv->bcn_nf_last;
-		signal->bcn_nf_avg = priv->bcn_nf_avg;
-		signal->data_nf_last = priv->data_nf_last;
-		signal->data_nf_avg = priv->data_nf_avg;
-	}
-
 	return 0;
 }
 
@@ -853,7 +823,7 @@ int mwifiex_process_sta_cmdresp(struct mwifiex_private *priv, u16 cmdresp_no,
 		ret = mwifiex_ret_get_log(priv, resp, data_buf);
 		break;
 	case HostCmd_CMD_RSSI_INFO:
-		ret = mwifiex_ret_802_11_rssi_info(priv, resp, data_buf);
+		ret = mwifiex_ret_802_11_rssi_info(priv, resp);
 		break;
 	case HostCmd_CMD_802_11_SNMP_MIB:
 		ret = mwifiex_ret_802_11_snmp_mib(priv, resp, data_buf);
diff --git a/drivers/net/wireless/mwifiex/sta_event.c b/drivers/net/wireless/mwifiex/sta_event.c
index cc531b5..33b311c 100644
--- a/drivers/net/wireless/mwifiex/sta_event.c
+++ b/drivers/net/wireless/mwifiex/sta_event.c
@@ -128,9 +128,6 @@ mwifiex_reset_connect_state(struct mwifiex_private *priv)
 		mwifiex_stop_net_dev_queue(priv->netdev, adapter);
 	if (netif_carrier_ok(priv->netdev))
 		netif_carrier_off(priv->netdev);
-	/* Reset wireless stats signal info */
-	priv->qual_level = 0;
-	priv->qual_noise = 0;
 }
 
 /*
diff --git a/drivers/net/wireless/mwifiex/sta_ioctl.c b/drivers/net/wireless/mwifiex/sta_ioctl.c
index d7b11de..8ba58d9 100644
--- a/drivers/net/wireless/mwifiex/sta_ioctl.c
+++ b/drivers/net/wireless/mwifiex/sta_ioctl.c
@@ -1185,39 +1185,6 @@ mwifiex_drv_get_driver_version(struct mwifiex_adapter *adapter, char *version,
 }
 
 /*
- * Sends IOCTL request to get signal information.
- *
- * This function allocates the IOCTL request buffer, fills it
- * with requisite parameters and calls the IOCTL handler.
- */
-int mwifiex_get_signal_info(struct mwifiex_private *priv,
-			    struct mwifiex_ds_get_signal *signal)
-{
-	int status;
-
-	signal->selector = ALL_RSSI_INFO_MASK;
-
-	/* Signal info can be obtained only if connected */
-	if (!priv->media_connected) {
-		dev_dbg(priv->adapter->dev,
-			"info: Can not get signal in disconnected state\n");
-		return -1;
-	}
-
-	status = mwifiex_send_cmd_sync(priv, HostCmd_CMD_RSSI_INFO,
-				       HostCmd_ACT_GEN_GET, 0, signal);
-
-	if (!status) {
-		if (signal->selector & BCN_RSSI_AVG_MASK)
-			priv->qual_level = signal->bcn_rssi_avg;
-		if (signal->selector & BCN_NF_AVG_MASK)
-			priv->qual_noise = signal->bcn_nf_avg;
-	}
-
-	return status;
-}
-
-/*
  * Sends IOCTL request to set encoding parameters.
  *
  * This function allocates the IOCTL request buffer, fills it
-- 
1.7.0.2

