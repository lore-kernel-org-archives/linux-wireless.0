Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from na3sys009aog129.obsmtp.com ([74.125.149.142]:46142 "EHLO
	na3sys009aog129.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1758312Ab3GaAS7 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 30 Jul 2013 20:18:59 -0400
From: Bing Zhao <bzhao@marvell.com>
To: <linux-wireless@vger.kernel.org>
CC: "John W. Linville" <linville@tuxdriver.com>,
	Avinash Patil <patila@marvell.com>,
	Amitkumar Karwar <akarwar@marvell.com>,
	Nishant Sarmukadam <nishants@marvell.com>,
	Frank Huang <frankh@marvell.com>, Bing Zhao <bzhao@marvell.com>
Subject: [PATCH] mwifiex: populate rates in probe request using cfg80211_scan_request
Date: Tue, 30 Jul 2013 17:18:56 -0700
Message-ID: <1375229936-31923-1-git-send-email-bzhao@marvell.com> (sfid-20130731_021901_466674_A79D4A4E)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Avinash Patil <patila@marvell.com>

Whenever available, use cfg80211_scan_request to populates rates
in outgoing probe request. This will help to advertise band specific
rates and fix an issue where 11b rates were advertised in probe
request going out on 11a band.

This will also ensure that we do not advertise 11b rates while P2P
scan is going on.

Signed-off-by: Avinash Patil <patila@marvell.com>
Signed-off-by: Bing Zhao <bzhao@marvell.com>
---
 drivers/net/wireless/mwifiex/cfp.c  | 42 ++++++++++++++++++++++---
 drivers/net/wireless/mwifiex/main.h |  2 ++
 drivers/net/wireless/mwifiex/scan.c | 63 +++++++++++++++++++++++++++----------
 3 files changed, 85 insertions(+), 22 deletions(-)

diff --git a/drivers/net/wireless/mwifiex/cfp.c b/drivers/net/wireless/mwifiex/cfp.c
index 5178c46..9eefacb 100644
--- a/drivers/net/wireless/mwifiex/cfp.c
+++ b/drivers/net/wireless/mwifiex/cfp.c
@@ -404,11 +404,43 @@ mwifiex_is_rate_auto(struct mwifiex_private *priv)
 		return false;
 }
 
-/*
- * This function gets the supported data rates.
- *
- * The function works in both Ad-Hoc and infra mode by printing the
- * band and returning the data rates.
+/* This function gets the supported data rates from bitmask inside
+ * cfg80211_scan_request.
+ */
+u32 mwifiex_get_rates_from_cfg80211(struct mwifiex_private *priv,
+				    u8 *rates, u8 radio_type)
+{
+	struct wiphy *wiphy = priv->adapter->wiphy;
+	struct cfg80211_scan_request *request = priv->scan_request;
+	u32 num_rates, rate_mask;
+	struct ieee80211_supported_band *sband;
+	int i;
+
+	if (radio_type) {
+		sband = wiphy->bands[IEEE80211_BAND_5GHZ];
+		if (WARN_ON_ONCE(!sband))
+			return 0;
+		rate_mask = request->rates[IEEE80211_BAND_5GHZ];
+	} else {
+		sband = wiphy->bands[IEEE80211_BAND_2GHZ];
+		if (WARN_ON_ONCE(!sband))
+			return 0;
+		rate_mask = request->rates[IEEE80211_BAND_2GHZ];
+	}
+
+	num_rates = 0;
+	for (i = 0; i < sband->n_bitrates; i++) {
+		if ((BIT(i) & rate_mask) == 0)
+			continue; /* skip rate */
+		rates[num_rates++] = (u8)(sband->bitrates[i].bitrate / 5);
+	}
+
+	return num_rates;
+}
+
+/* This function gets the supported data rates. The function works in
+ * both Ad-Hoc and infra mode by printing the band and returning the
+ * data rates.
  */
 u32 mwifiex_get_supported_rates(struct mwifiex_private *priv, u8 *rates)
 {
diff --git a/drivers/net/wireless/mwifiex/main.h b/drivers/net/wireless/mwifiex/main.h
index 48685e7..cf961d9 100644
--- a/drivers/net/wireless/mwifiex/main.h
+++ b/drivers/net/wireless/mwifiex/main.h
@@ -903,6 +903,8 @@ int mwifiex_cmd_append_vsie_tlv(struct mwifiex_private *priv, u16 vsie_mask,
 u32 mwifiex_get_active_data_rates(struct mwifiex_private *priv,
 				    u8 *rates);
 u32 mwifiex_get_supported_rates(struct mwifiex_private *priv, u8 *rates);
+u32 mwifiex_get_rates_from_cfg80211(struct mwifiex_private *priv,
+				    u8 *rates, u8 radio_type);
 u8 mwifiex_is_rate_auto(struct mwifiex_private *priv);
 extern u16 region_code_index[MWIFIEX_MAX_REGION_CODE];
 void mwifiex_save_curr_bcn(struct mwifiex_private *priv);
diff --git a/drivers/net/wireless/mwifiex/scan.c b/drivers/net/wireless/mwifiex/scan.c
index c447d9b..8cf7d50 100644
--- a/drivers/net/wireless/mwifiex/scan.c
+++ b/drivers/net/wireless/mwifiex/scan.c
@@ -543,6 +543,37 @@ mwifiex_scan_create_channel_list(struct mwifiex_private *priv,
 	return chan_idx;
 }
 
+/* This function appends rate TLV to scan config command. */
+static int
+mwifiex_append_rate_tlv(struct mwifiex_private *priv,
+			struct mwifiex_scan_cmd_config *scan_cfg_out,
+			u8 radio)
+{
+	struct mwifiex_ie_types_rates_param_set *rates_tlv;
+	u8 rates[MWIFIEX_SUPPORTED_RATES], *tlv_pos;
+	u32 rates_size;
+
+	memset(rates, 0, sizeof(rates));
+
+	tlv_pos = (u8 *)scan_cfg_out->tlv_buf + scan_cfg_out->tlv_buf_len;
+
+	if (priv->scan_request)
+		rates_size = mwifiex_get_rates_from_cfg80211(priv, rates,
+							     radio);
+	else
+		rates_size = mwifiex_get_supported_rates(priv, rates);
+
+	dev_dbg(priv->adapter->dev, "info: SCAN_CMD: Rates size = %d\n",
+		rates_size);
+	rates_tlv = (struct mwifiex_ie_types_rates_param_set *)tlv_pos;
+	rates_tlv->header.type = cpu_to_le16(WLAN_EID_SUPP_RATES);
+	rates_tlv->header.len = cpu_to_le16((u16) rates_size);
+	memcpy(rates_tlv->rates, rates, rates_size);
+	scan_cfg_out->tlv_buf_len += sizeof(rates_tlv->header) + rates_size;
+
+	return rates_size;
+}
+
 /*
  * This function constructs and sends multiple scan config commands to
  * the firmware.
@@ -564,9 +595,10 @@ mwifiex_scan_channel_list(struct mwifiex_private *priv,
 	struct mwifiex_chan_scan_param_set *tmp_chan_list;
 	struct mwifiex_chan_scan_param_set *start_chan;
 
-	u32 tlv_idx;
+	u32 tlv_idx, rates_size;
 	u32 total_scan_time;
 	u32 done_early;
+	u8 radio_type;
 
 	if (!scan_cfg_out || !chan_tlv_out || !scan_chan_list) {
 		dev_dbg(priv->adapter->dev,
@@ -591,6 +623,7 @@ mwifiex_scan_channel_list(struct mwifiex_private *priv,
 
 		tlv_idx = 0;
 		total_scan_time = 0;
+		radio_type = 0;
 		chan_tlv_out->header.len = 0;
 		start_chan = tmp_chan_list;
 		done_early = false;
@@ -612,6 +645,7 @@ mwifiex_scan_channel_list(struct mwifiex_private *priv,
 				continue;
 			}
 
+			radio_type = tmp_chan_list->radio_type;
 			dev_dbg(priv->adapter->dev,
 				"info: Scan: Chan(%3d), Radio(%d),"
 				" Mode(%d, %d), Dur(%d)\n",
@@ -692,6 +726,9 @@ mwifiex_scan_channel_list(struct mwifiex_private *priv,
 			break;
 		}
 
+		rates_size = mwifiex_append_rate_tlv(priv, scan_cfg_out,
+						     radio_type);
+
 		priv->adapter->scan_channels = start_chan;
 
 		/* Send the scan command to the firmware with the specified
@@ -699,6 +736,14 @@ mwifiex_scan_channel_list(struct mwifiex_private *priv,
 		ret = mwifiex_send_cmd_async(priv, HostCmd_CMD_802_11_SCAN,
 					     HostCmd_ACT_GEN_SET, 0,
 					     scan_cfg_out);
+
+		/* rate IE is updated per scan command but same starting
+		 * pointer is used each time so that rate IE from earlier
+		 * scan_cfg_out->buf is overwritten with new one.
+		 */
+		scan_cfg_out->tlv_buf_len -=
+			    sizeof(struct mwifiex_ie_types_header) + rates_size;
+
 		if (ret)
 			break;
 	}
@@ -741,7 +786,6 @@ mwifiex_config_scan(struct mwifiex_private *priv,
 	struct mwifiex_adapter *adapter = priv->adapter;
 	struct mwifiex_ie_types_num_probes *num_probes_tlv;
 	struct mwifiex_ie_types_wildcard_ssid_params *wildcard_ssid_tlv;
-	struct mwifiex_ie_types_rates_param_set *rates_tlv;
 	u8 *tlv_pos;
 	u32 num_probes;
 	u32 ssid_len;
@@ -753,8 +797,6 @@ mwifiex_config_scan(struct mwifiex_private *priv,
 	u8 radio_type;
 	int i;
 	u8 ssid_filter;
-	u8 rates[MWIFIEX_SUPPORTED_RATES];
-	u32 rates_size;
 	struct mwifiex_ie_types_htcap *ht_cap;
 
 	/* The tlv_buf_len is calculated for each scan command.  The TLVs added
@@ -889,19 +931,6 @@ mwifiex_config_scan(struct mwifiex_private *priv,
 
 	}
 
-	/* Append rates tlv */
-	memset(rates, 0, sizeof(rates));
-
-	rates_size = mwifiex_get_supported_rates(priv, rates);
-
-	rates_tlv = (struct mwifiex_ie_types_rates_param_set *) tlv_pos;
-	rates_tlv->header.type = cpu_to_le16(WLAN_EID_SUPP_RATES);
-	rates_tlv->header.len = cpu_to_le16((u16) rates_size);
-	memcpy(rates_tlv->rates, rates, rates_size);
-	tlv_pos += sizeof(rates_tlv->header) + rates_size;
-
-	dev_dbg(adapter->dev, "info: SCAN_CMD: Rates size = %d\n", rates_size);
-
 	if (ISSUPP_11NENABLED(priv->adapter->fw_cap_info) &&
 	    (priv->adapter->config_bands & BAND_GN ||
 	     priv->adapter->config_bands & BAND_AN)) {
-- 
1.8.2.3

