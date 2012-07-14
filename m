Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from na3sys009aog112.obsmtp.com ([74.125.149.207]:50751 "HELO
	na3sys009aog112.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1756936Ab2GNDMI (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 13 Jul 2012 23:12:08 -0400
From: Bing Zhao <bzhao@marvell.com>
To: linux-wireless@vger.kernel.org
Cc: "John W. Linville" <linville@tuxdriver.com>,
	Amitkumar Karwar <akarwar@marvell.com>,
	Avinash Patil <patila@marvell.com>,
	Kiran Divekar <dkiran@marvell.com>,
	Yogesh Powar <yogeshp@marvell.com>,
	Stone Piao <piaoyun@marvell.com>, Ying Luo <luoy@marvell.com>,
	Frank Huang <frankh@marvell.com>, Bing Zhao <bzhao@marvell.com>
Subject: [PATCH 2/4] mwifiex: remove unnecessary code in data rate configuration
Date: Fri, 13 Jul 2012 20:09:31 -0700
Message-Id: <1342235373-27613-3-git-send-email-bzhao@marvell.com> (sfid-20120714_051246_108416_BD6E116A)
In-Reply-To: <1342235373-27613-1-git-send-email-bzhao@marvell.com>
References: <1342235373-27613-1-git-send-email-bzhao@marvell.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Amitkumar Karwar <akarwar@marvell.com>

1) Remove unnecessary wrapper functions.
2) Currently we don't have command to set Tx data rate, so
mwifiex_rate_ioctl_set_rate_value() function and related code
can be removed.
3) "ds_rate" filled by mwifiex_ret_tx_rate_cfg() is never used.

Signed-off-by: Amitkumar Karwar <akarwar@marvell.com>
Signed-off-by: Bing Zhao <bzhao@marvell.com>
---
 drivers/net/wireless/mwifiex/cfg80211.c    |    4 +-
 drivers/net/wireless/mwifiex/cfp.c         |   31 -------
 drivers/net/wireless/mwifiex/decl.h        |    9 --
 drivers/net/wireless/mwifiex/ioctl.h       |    6 --
 drivers/net/wireless/mwifiex/main.h        |    5 +-
 drivers/net/wireless/mwifiex/sta_cmdresp.c |   39 ++-------
 drivers/net/wireless/mwifiex/sta_ioctl.c   |  124 ++--------------------------
 7 files changed, 17 insertions(+), 201 deletions(-)

diff --git a/drivers/net/wireless/mwifiex/cfg80211.c b/drivers/net/wireless/mwifiex/cfg80211.c
index 4b99ad5..7d68c2b 100644
--- a/drivers/net/wireless/mwifiex/cfg80211.c
+++ b/drivers/net/wireless/mwifiex/cfg80211.c
@@ -615,7 +615,7 @@ static int
 mwifiex_dump_station_info(struct mwifiex_private *priv,
 			  struct station_info *sinfo)
 {
-	struct mwifiex_rate_cfg rate;
+	u32 rate;
 
 	sinfo->filled = STATION_INFO_RX_BYTES | STATION_INFO_TX_BYTES |
 			STATION_INFO_RX_PACKETS | STATION_INFO_TX_PACKETS |
@@ -661,7 +661,7 @@ mwifiex_dump_station_info(struct mwifiex_private *priv,
 	sinfo->tx_packets = priv->stats.tx_packets;
 	sinfo->signal = priv->bcn_rssi_avg;
 	/* bit rate is in 500 kb/s units. Convert it to 100kb/s units */
-	sinfo->txrate.legacy = rate.rate * 5;
+	sinfo->txrate.legacy = rate * 5;
 
 	if (priv->bss_mode == NL80211_IFTYPE_STATION) {
 		sinfo->filled |= STATION_INFO_BSS_PARAM;
diff --git a/drivers/net/wireless/mwifiex/cfp.c b/drivers/net/wireless/mwifiex/cfp.c
index 560871b..f69300f 100644
--- a/drivers/net/wireless/mwifiex/cfp.c
+++ b/drivers/net/wireless/mwifiex/cfp.c
@@ -167,23 +167,6 @@ u32 mwifiex_index_to_data_rate(struct mwifiex_private *priv, u8 index,
 }
 
 /*
- * This function maps a data rate value into corresponding index in supported
- * rates table.
- */
-u8 mwifiex_data_rate_to_index(u32 rate)
-{
-	u16 *ptr;
-
-	if (rate) {
-		ptr = memchr(mwifiex_data_rates, rate,
-				sizeof(mwifiex_data_rates));
-		if (ptr)
-			return (u8) (ptr - mwifiex_data_rates);
-	}
-	return 0;
-}
-
-/*
  * This function returns the current active data rates.
  *
  * The result may vary depending upon connection status.
@@ -277,20 +260,6 @@ mwifiex_is_rate_auto(struct mwifiex_private *priv)
 }
 
 /*
- * This function converts rate bitmap into rate index.
- */
-int mwifiex_get_rate_index(u16 *rate_bitmap, int size)
-{
-	int i;
-
-	for (i = 0; i < size * 8; i++)
-		if (rate_bitmap[i / 16] & (1 << (i % 16)))
-			return i;
-
-	return 0;
-}
-
-/*
  * This function gets the supported data rates.
  *
  * The function works in both Ad-Hoc and infra mode by printing the
diff --git a/drivers/net/wireless/mwifiex/decl.h b/drivers/net/wireless/mwifiex/decl.h
index f918f66..070ef25 100644
--- a/drivers/net/wireless/mwifiex/decl.h
+++ b/drivers/net/wireless/mwifiex/decl.h
@@ -41,16 +41,7 @@
 #define MWIFIEX_AMPDU_DEF_RXWINSIZE        16
 #define MWIFIEX_DEFAULT_BLOCK_ACK_TIMEOUT  0xffff
 
-#define MWIFIEX_RATE_INDEX_HRDSSS0 0
-#define MWIFIEX_RATE_INDEX_HRDSSS3 3
-#define MWIFIEX_RATE_INDEX_OFDM0   4
-#define MWIFIEX_RATE_INDEX_OFDM7   11
-#define MWIFIEX_RATE_INDEX_MCS0    12
-
-#define MWIFIEX_RATE_BITMAP_OFDM0  16
-#define MWIFIEX_RATE_BITMAP_OFDM7  23
 #define MWIFIEX_RATE_BITMAP_MCS0   32
-#define MWIFIEX_RATE_BITMAP_MCS127 159
 
 #define MWIFIEX_RX_DATA_BUF_SIZE     (4 * 1024)
 #define MWIFIEX_RX_CMD_BUF_SIZE	     (2 * 1024)
diff --git a/drivers/net/wireless/mwifiex/ioctl.h b/drivers/net/wireless/mwifiex/ioctl.h
index e121294..5019153 100644
--- a/drivers/net/wireless/mwifiex/ioctl.h
+++ b/drivers/net/wireless/mwifiex/ioctl.h
@@ -225,12 +225,6 @@ struct mwifiex_ds_encrypt_key {
 	u8 wapi_rxpn[WAPI_RXPN_LEN];
 };
 
-struct mwifiex_rate_cfg {
-	u32 action;
-	u32 is_rate_auto;
-	u32 rate;
-};
-
 struct mwifiex_power_cfg {
 	u32 is_power_auto;
 	u32 power_level;
diff --git a/drivers/net/wireless/mwifiex/main.h b/drivers/net/wireless/mwifiex/main.h
index b710649..34705f5 100644
--- a/drivers/net/wireless/mwifiex/main.h
+++ b/drivers/net/wireless/mwifiex/main.h
@@ -824,9 +824,7 @@ int mwifiex_cmd_append_vsie_tlv(struct mwifiex_private *priv, u16 vsie_mask,
 u32 mwifiex_get_active_data_rates(struct mwifiex_private *priv,
 				    u8 *rates);
 u32 mwifiex_get_supported_rates(struct mwifiex_private *priv, u8 *rates);
-u8 mwifiex_data_rate_to_index(u32 rate);
 u8 mwifiex_is_rate_auto(struct mwifiex_private *priv);
-int mwifiex_get_rate_index(u16 *rateBitmap, int size);
 extern u16 region_code_index[MWIFIEX_MAX_REGION_CODE];
 void mwifiex_save_curr_bcn(struct mwifiex_private *priv);
 void mwifiex_free_curr_bcn(struct mwifiex_private *priv);
@@ -945,8 +943,7 @@ int mwifiex_bss_start(struct mwifiex_private *priv, struct cfg80211_bss *bss,
 int mwifiex_cancel_hs(struct mwifiex_private *priv, int cmd_type);
 int mwifiex_enable_hs(struct mwifiex_adapter *adapter);
 int mwifiex_disable_auto_ds(struct mwifiex_private *priv);
-int mwifiex_drv_get_data_rate(struct mwifiex_private *priv,
-			      struct mwifiex_rate_cfg *rate);
+int mwifiex_drv_get_data_rate(struct mwifiex_private *priv, u32 *rate);
 int mwifiex_request_scan(struct mwifiex_private *priv,
 			 struct cfg80211_ssid *req_ssid);
 int mwifiex_scan_networks(struct mwifiex_private *priv,
diff --git a/drivers/net/wireless/mwifiex/sta_cmdresp.c b/drivers/net/wireless/mwifiex/sta_cmdresp.c
index 43ede5e..e0178c0 100644
--- a/drivers/net/wireless/mwifiex/sta_cmdresp.c
+++ b/drivers/net/wireless/mwifiex/sta_cmdresp.c
@@ -267,12 +267,10 @@ static int mwifiex_ret_get_log(struct mwifiex_private *priv,
  *
  * Based on the new rate bitmaps, the function re-evaluates if
  * auto data rate has been activated. If not, it sends another
- * query to the firmware to get the current Tx data rate and updates
- * the driver value.
+ * query to the firmware to get the current Tx data rate.
  */
 static int mwifiex_ret_tx_rate_cfg(struct mwifiex_private *priv,
-				   struct host_cmd_ds_command *resp,
-				   struct mwifiex_rate_cfg *ds_rate)
+				   struct host_cmd_ds_command *resp)
 {
 	struct host_cmd_ds_tx_rate_cfg *rate_cfg = &resp->params.tx_rate_cfg;
 	struct mwifiex_rate_scope *rate_scope;
@@ -280,7 +278,6 @@ static int mwifiex_ret_tx_rate_cfg(struct mwifiex_private *priv,
 	u16 tlv, tlv_buf_len;
 	u8 *tlv_buf;
 	u32 i;
-	int ret = 0;
 
 	tlv_buf = (u8 *) ((u8 *) rate_cfg) +
 			sizeof(struct host_cmd_ds_tx_rate_cfg);
@@ -318,33 +315,11 @@ static int mwifiex_ret_tx_rate_cfg(struct mwifiex_private *priv,
 	if (priv->is_data_rate_auto)
 		priv->data_rate = 0;
 	else
-		ret = mwifiex_send_cmd_async(priv,
-					  HostCmd_CMD_802_11_TX_RATE_QUERY,
-					  HostCmd_ACT_GEN_GET, 0, NULL);
-
-	if (!ds_rate)
-		return ret;
-
-	if (le16_to_cpu(rate_cfg->action) == HostCmd_ACT_GEN_GET) {
-		if (priv->is_data_rate_auto) {
-			ds_rate->is_rate_auto = 1;
-		return ret;
-	}
-	ds_rate->rate = mwifiex_get_rate_index(priv->bitmap_rates,
-					       sizeof(priv->bitmap_rates));
-
-	if (ds_rate->rate >= MWIFIEX_RATE_BITMAP_OFDM0 &&
-	    ds_rate->rate <= MWIFIEX_RATE_BITMAP_OFDM7)
-		ds_rate->rate -= (MWIFIEX_RATE_BITMAP_OFDM0 -
-				  MWIFIEX_RATE_INDEX_OFDM0);
-
-	if (ds_rate->rate >= MWIFIEX_RATE_BITMAP_MCS0 &&
-	    ds_rate->rate <= MWIFIEX_RATE_BITMAP_MCS127)
-		ds_rate->rate -= (MWIFIEX_RATE_BITMAP_MCS0 -
-				  MWIFIEX_RATE_INDEX_MCS0);
-	}
+		return mwifiex_send_cmd_async(priv,
+					      HostCmd_CMD_802_11_TX_RATE_QUERY,
+					      HostCmd_ACT_GEN_GET, 0, NULL);
 
-	return ret;
+	return 0;
 }
 
 /*
@@ -856,7 +831,7 @@ int mwifiex_process_sta_cmdresp(struct mwifiex_private *priv, u16 cmdresp_no,
 		ret = mwifiex_ret_mac_multicast_adr(priv, resp);
 		break;
 	case HostCmd_CMD_TX_RATE_CFG:
-		ret = mwifiex_ret_tx_rate_cfg(priv, resp, data_buf);
+		ret = mwifiex_ret_tx_rate_cfg(priv, resp);
 		break;
 	case HostCmd_CMD_802_11_SCAN:
 		ret = mwifiex_ret_802_11_scan(priv, resp);
diff --git a/drivers/net/wireless/mwifiex/sta_ioctl.c b/drivers/net/wireless/mwifiex/sta_ioctl.c
index 6dff016..fb21360 100644
--- a/drivers/net/wireless/mwifiex/sta_ioctl.c
+++ b/drivers/net/wireless/mwifiex/sta_ioctl.c
@@ -497,134 +497,24 @@ int mwifiex_disable_auto_ds(struct mwifiex_private *priv)
 EXPORT_SYMBOL_GPL(mwifiex_disable_auto_ds);
 
 /*
- * IOCTL request handler to get rate.
- *
- * This function prepares the correct firmware command and
- * issues it to get the current rate if it is connected,
- * otherwise, the function returns the lowest supported rate
- * for the band.
- */
-static int mwifiex_rate_ioctl_get_rate_value(struct mwifiex_private *priv,
-					     struct mwifiex_rate_cfg *rate_cfg)
-{
-	rate_cfg->is_rate_auto = priv->is_data_rate_auto;
-	return mwifiex_send_cmd_sync(priv, HostCmd_CMD_802_11_TX_RATE_QUERY,
-				     HostCmd_ACT_GEN_GET, 0, NULL);
-}
-
-/*
- * IOCTL request handler to set rate.
- *
- * This function prepares the correct firmware command and
- * issues it to set the current rate.
- *
- * The function also performs validation checking on the supplied value.
- */
-static int mwifiex_rate_ioctl_set_rate_value(struct mwifiex_private *priv,
-					     struct mwifiex_rate_cfg *rate_cfg)
-{
-	u8 rates[MWIFIEX_SUPPORTED_RATES];
-	u8 *rate;
-	int rate_index, ret;
-	u16 bitmap_rates[MAX_BITMAP_RATES_SIZE];
-	u32 i;
-	struct mwifiex_adapter *adapter = priv->adapter;
-
-	if (rate_cfg->is_rate_auto) {
-		memset(bitmap_rates, 0, sizeof(bitmap_rates));
-		/* Support all HR/DSSS rates */
-		bitmap_rates[0] = 0x000F;
-		/* Support all OFDM rates */
-		bitmap_rates[1] = 0x00FF;
-		/* Support all HT-MCSs rate */
-		for (i = 0; i < ARRAY_SIZE(priv->bitmap_rates) - 3; i++)
-			bitmap_rates[i + 2] = 0xFFFF;
-		bitmap_rates[9] = 0x3FFF;
-	} else {
-		memset(rates, 0, sizeof(rates));
-		mwifiex_get_active_data_rates(priv, rates);
-		rate = rates;
-		for (i = 0; (rate[i] && i < MWIFIEX_SUPPORTED_RATES); i++) {
-			dev_dbg(adapter->dev, "info: rate=%#x wanted=%#x\n",
-				rate[i], rate_cfg->rate);
-			if ((rate[i] & 0x7f) == (rate_cfg->rate & 0x7f))
-				break;
-		}
-		if ((i == MWIFIEX_SUPPORTED_RATES) || !rate[i]) {
-			dev_err(adapter->dev, "fixed data rate %#x is out "
-			       "of range\n", rate_cfg->rate);
-			return -1;
-		}
-		memset(bitmap_rates, 0, sizeof(bitmap_rates));
-
-		rate_index = mwifiex_data_rate_to_index(rate_cfg->rate);
-
-		/* Only allow b/g rates to be set */
-		if (rate_index >= MWIFIEX_RATE_INDEX_HRDSSS0 &&
-		    rate_index <= MWIFIEX_RATE_INDEX_HRDSSS3) {
-			bitmap_rates[0] = 1 << rate_index;
-		} else {
-			rate_index -= 1; /* There is a 0x00 in the table */
-			if (rate_index >= MWIFIEX_RATE_INDEX_OFDM0 &&
-			    rate_index <= MWIFIEX_RATE_INDEX_OFDM7)
-				bitmap_rates[1] = 1 << (rate_index -
-						   MWIFIEX_RATE_INDEX_OFDM0);
-		}
-	}
-
-	ret = mwifiex_send_cmd_sync(priv, HostCmd_CMD_TX_RATE_CFG,
-				    HostCmd_ACT_GEN_SET, 0, bitmap_rates);
-
-	return ret;
-}
-
-/*
- * IOCTL request handler to set/get rate.
- *
- * This function can be used to set/get either the rate value or the
- * rate index.
- */
-static int mwifiex_rate_ioctl_cfg(struct mwifiex_private *priv,
-				  struct mwifiex_rate_cfg *rate_cfg)
-{
-	int status;
-
-	if (!rate_cfg)
-		return -1;
-
-	if (rate_cfg->action == HostCmd_ACT_GEN_GET)
-		status = mwifiex_rate_ioctl_get_rate_value(priv, rate_cfg);
-	else
-		status = mwifiex_rate_ioctl_set_rate_value(priv, rate_cfg);
-
-	return status;
-}
-
-/*
  * Sends IOCTL request to get the data rate.
  *
  * This function allocates the IOCTL request buffer, fills it
  * with requisite parameters and calls the IOCTL handler.
  */
-int mwifiex_drv_get_data_rate(struct mwifiex_private *priv,
-			      struct mwifiex_rate_cfg *rate)
+int mwifiex_drv_get_data_rate(struct mwifiex_private *priv, u32 *rate)
 {
 	int ret;
 
-	memset(rate, 0, sizeof(struct mwifiex_rate_cfg));
-	rate->action = HostCmd_ACT_GEN_GET;
-	ret = mwifiex_rate_ioctl_cfg(priv, rate);
+	ret = mwifiex_send_cmd_sync(priv, HostCmd_CMD_802_11_TX_RATE_QUERY,
+				    HostCmd_ACT_GEN_GET, 0, NULL);
 
 	if (!ret) {
-		if (rate->is_rate_auto)
-			rate->rate = mwifiex_index_to_data_rate(priv,
-								priv->tx_rate,
-								priv->tx_htinfo
-								);
+		if (priv->is_data_rate_auto)
+			*rate = mwifiex_index_to_data_rate(priv, priv->tx_rate,
+							   priv->tx_htinfo);
 		else
-			rate->rate = priv->data_rate;
-	} else {
-		ret = -1;
+			*rate = priv->data_rate;
 	}
 
 	return ret;
-- 
1.7.0.2

