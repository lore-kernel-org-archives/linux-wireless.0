Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx0b-0016f401.pphosted.com ([67.231.156.173]:25427 "EHLO
	mx0b-0016f401.pphosted.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750868AbaBHAXn (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 7 Feb 2014 19:23:43 -0500
From: Bing Zhao <bzhao@marvell.com>
To: <linux-wireless@vger.kernel.org>
CC: "John W. Linville" <linville@tuxdriver.com>,
	Amitkumar Karwar <akarwar@marvell.com>,
	Avinash Patil <patila@marvell.com>,
	Nishant Sarmukadam <nishants@marvell.com>,
	Frank Huang <frankh@marvell.com>, Bing Zhao <bzhao@marvell.com>
Subject: [PATCH v2 06/30] mwifiex: separate out response buffer parsing code
Date: Fri, 7 Feb 2014 16:23:35 -0800
Message-ID: <1391819017-20995-2-git-send-email-bzhao@marvell.com> (sfid-20140208_012347_190999_C10AA7CC)
In-Reply-To: <1391819017-20995-1-git-send-email-bzhao@marvell.com>
References: <1391819017-20995-1-git-send-email-bzhao@marvell.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Amitkumar Karwar <akarwar@marvell.com>

This new function will be useful later for extended scan
feature.

Signed-off-by: Amitkumar Karwar <akarwar@marvell.com>
Signed-off-by: Bing Zhao <bzhao@marvell.com>
---
 drivers/net/wireless/mwifiex/scan.c | 309 +++++++++++++++++++-----------------
 1 file changed, 163 insertions(+), 146 deletions(-)

diff --git a/drivers/net/wireless/mwifiex/scan.c b/drivers/net/wireless/mwifiex/scan.c
index b0be830..28f0a38 100644
--- a/drivers/net/wireless/mwifiex/scan.c
+++ b/drivers/net/wireless/mwifiex/scan.c
@@ -1576,6 +1576,156 @@ done:
 	return 0;
 }
 
+static int
+mwifiex_parse_single_response_buf(struct mwifiex_private *priv, u8 **bss_info,
+				  u32 *bytes_left, u64 fw_tsf, u8 *radio_type,
+				  bool ext_scan)
+{
+	struct mwifiex_adapter *adapter = priv->adapter;
+	struct mwifiex_chan_freq_power *cfp;
+	struct cfg80211_bss *bss;
+	u8 bssid[ETH_ALEN];
+	s32 rssi;
+	const u8 *ie_buf;
+	size_t ie_len;
+	u16 channel = 0;
+	u16 beacon_size = 0;
+	u32 curr_bcn_bytes;
+	u32 freq;
+	u16 beacon_period;
+	u16 cap_info_bitmap;
+	u8 *current_ptr;
+	u64 timestamp;
+	struct mwifiex_fixed_bcn_param *bcn_param;
+	struct mwifiex_bss_priv *bss_priv;
+
+	if (*bytes_left >= sizeof(beacon_size)) {
+		/* Extract & convert beacon size from command buffer */
+		memcpy(&beacon_size, *bss_info, sizeof(beacon_size));
+		*bytes_left -= sizeof(beacon_size);
+		*bss_info += sizeof(beacon_size);
+	}
+
+	if (!beacon_size || beacon_size > *bytes_left) {
+		*bss_info += *bytes_left;
+		*bytes_left = 0;
+		return -EFAULT;
+	}
+
+	/* Initialize the current working beacon pointer for this BSS
+	 * iteration
+	 */
+	current_ptr = *bss_info;
+
+	/* Advance the return beacon pointer past the current beacon */
+	*bss_info += beacon_size;
+	*bytes_left -= beacon_size;
+
+	curr_bcn_bytes = beacon_size;
+
+	/* First 5 fields are bssid, RSSI(for legacy scan only),
+	 * time stamp, beacon interval, and capability information
+	 */
+	if (curr_bcn_bytes < ETH_ALEN + sizeof(u8) +
+	    sizeof(struct mwifiex_fixed_bcn_param)) {
+		dev_err(adapter->dev, "InterpretIE: not enough bytes left\n");
+		return -EFAULT;
+	}
+
+	memcpy(bssid, current_ptr, ETH_ALEN);
+	current_ptr += ETH_ALEN;
+	curr_bcn_bytes -= ETH_ALEN;
+
+	if (!ext_scan) {
+		rssi = (s32) *(u8 *)current_ptr;
+		rssi = (-rssi) * 100;		/* Convert dBm to mBm */
+		current_ptr += sizeof(u8);
+		curr_bcn_bytes -= sizeof(u8);
+		dev_dbg(adapter->dev, "info: InterpretIE: RSSI=%d\n", rssi);
+	}
+
+	bcn_param = (struct mwifiex_fixed_bcn_param *)current_ptr;
+	current_ptr += sizeof(*bcn_param);
+	curr_bcn_bytes -= sizeof(*bcn_param);
+
+	timestamp = le64_to_cpu(bcn_param->timestamp);
+	beacon_period = le16_to_cpu(bcn_param->beacon_period);
+
+	cap_info_bitmap = le16_to_cpu(bcn_param->cap_info_bitmap);
+	dev_dbg(adapter->dev, "info: InterpretIE: capabilities=0x%X\n",
+		cap_info_bitmap);
+
+	/* Rest of the current buffer are IE's */
+	ie_buf = current_ptr;
+	ie_len = curr_bcn_bytes;
+	dev_dbg(adapter->dev, "info: InterpretIE: IELength for this AP = %d\n",
+		curr_bcn_bytes);
+
+	while (curr_bcn_bytes >= sizeof(struct ieee_types_header)) {
+		u8 element_id, element_len;
+
+		element_id = *current_ptr;
+		element_len = *(current_ptr + 1);
+		if (curr_bcn_bytes < element_len +
+				sizeof(struct ieee_types_header)) {
+			dev_err(adapter->dev,
+				"%s: bytes left < IE length\n", __func__);
+			return -EFAULT;
+		}
+		if (element_id == WLAN_EID_DS_PARAMS) {
+			channel = *(current_ptr +
+				    sizeof(struct ieee_types_header));
+			break;
+		}
+
+		current_ptr += element_len + sizeof(struct ieee_types_header);
+		curr_bcn_bytes -= element_len +
+					sizeof(struct ieee_types_header);
+	}
+
+	if (channel) {
+		struct ieee80211_channel *chan;
+		u8 band;
+
+		/* Skip entry if on csa closed channel */
+		if (channel == priv->csa_chan) {
+			dev_dbg(adapter->dev,
+				"Dropping entry on csa closed channel\n");
+			return 0;
+		}
+
+		band = BAND_G;
+		if (radio_type)
+			band = mwifiex_radio_type_to_band(*radio_type &
+							  (BIT(0) | BIT(1)));
+
+		cfp = mwifiex_get_cfp(priv, band, channel, 0);
+
+		freq = cfp ? cfp->freq : 0;
+
+		chan = ieee80211_get_channel(priv->wdev->wiphy, freq);
+
+		if (chan && !(chan->flags & IEEE80211_CHAN_DISABLED)) {
+			bss = cfg80211_inform_bss(priv->wdev->wiphy,
+					    chan, bssid, timestamp,
+					    cap_info_bitmap, beacon_period,
+					    ie_buf, ie_len, rssi, GFP_KERNEL);
+			bss_priv = (struct mwifiex_bss_priv *)bss->priv;
+			bss_priv->band = band;
+			bss_priv->fw_tsf = fw_tsf;
+			if (priv->media_connected &&
+			    !memcmp(bssid, priv->curr_bss_params.bss_descriptor
+				    .mac_address, ETH_ALEN))
+				mwifiex_update_curr_bss_params(priv, bss);
+			cfg80211_put_bss(priv->wdev->wiphy, bss);
+		}
+	} else {
+		dev_dbg(adapter->dev, "missing BSS channel IE\n");
+	}
+
+	return 0;
+}
+
 /*
  * This function handles the command response of scan.
  *
@@ -1609,12 +1759,12 @@ int mwifiex_ret_802_11_scan(struct mwifiex_private *priv,
 	u32 bytes_left;
 	u32 idx;
 	u32 tlv_buf_size;
-	struct mwifiex_chan_freq_power *cfp;
 	struct mwifiex_ie_types_chan_band_list_param_set *chan_band_tlv;
 	struct chan_band_param_set *chan_band;
 	u8 is_bgscan_resp;
 	unsigned long flags;
-	struct cfg80211_bss *bss;
+	__le64 fw_tsf = 0;
+	u8 *radio_type;
 
 	is_bgscan_resp = (le16_to_cpu(resp->command)
 			  == HostCmd_CMD_802_11_BG_SCAN_QUERY);
@@ -1676,107 +1826,6 @@ int mwifiex_ret_802_11_scan(struct mwifiex_private *priv,
 					     &chan_band_tlv);
 
 	for (idx = 0; idx < scan_rsp->number_of_sets && bytes_left; idx++) {
-		u8 bssid[ETH_ALEN];
-		s32 rssi;
-		const u8 *ie_buf;
-		size_t ie_len;
-		u16 channel = 0;
-		__le64 fw_tsf = 0;
-		u16 beacon_size = 0;
-		u32 curr_bcn_bytes;
-		u32 freq;
-		u16 beacon_period;
-		u16 cap_info_bitmap;
-		u8 *current_ptr;
-		u64 timestamp;
-		struct mwifiex_fixed_bcn_param *bcn_param;
-		struct mwifiex_bss_priv *bss_priv;
-
-		if (bytes_left >= sizeof(beacon_size)) {
-			/* Extract & convert beacon size from command buffer */
-			memcpy(&beacon_size, bss_info, sizeof(beacon_size));
-			bytes_left -= sizeof(beacon_size);
-			bss_info += sizeof(beacon_size);
-		}
-
-		if (!beacon_size || beacon_size > bytes_left) {
-			bss_info += bytes_left;
-			bytes_left = 0;
-			ret = -1;
-			goto check_next_scan;
-		}
-
-		/* Initialize the current working beacon pointer for this BSS
-		 * iteration */
-		current_ptr = bss_info;
-
-		/* Advance the return beacon pointer past the current beacon */
-		bss_info += beacon_size;
-		bytes_left -= beacon_size;
-
-		curr_bcn_bytes = beacon_size;
-
-		/* First 5 fields are bssid, RSSI(for legacy scan only),
-		 * time stamp, beacon interval, and capability information
-		 */
-		if (curr_bcn_bytes < ETH_ALEN + sizeof(u8) +
-		    sizeof(struct mwifiex_fixed_bcn_param)) {
-			dev_err(adapter->dev,
-				"InterpretIE: not enough bytes left\n");
-			continue;
-		}
-
-		memcpy(bssid, current_ptr, ETH_ALEN);
-		current_ptr += ETH_ALEN;
-		curr_bcn_bytes -= ETH_ALEN;
-
-		rssi = (s32) *(u8 *)current_ptr;
-		rssi = (-rssi) * 100;		/* Convert dBm to mBm */
-		current_ptr += sizeof(u8);
-		curr_bcn_bytes -= sizeof(u8);
-		dev_dbg(adapter->dev, "info: InterpretIE: RSSI=%d\n", rssi);
-
-		bcn_param = (struct mwifiex_fixed_bcn_param *)current_ptr;
-		current_ptr += sizeof(*bcn_param);
-		curr_bcn_bytes -= sizeof(*bcn_param);
-
-		timestamp = le64_to_cpu(bcn_param->timestamp);
-		beacon_period = le16_to_cpu(bcn_param->beacon_period);
-
-		cap_info_bitmap = le16_to_cpu(bcn_param->cap_info_bitmap);
-		dev_dbg(adapter->dev, "info: InterpretIE: capabilities=0x%X\n",
-			cap_info_bitmap);
-
-		/* Rest of the current buffer are IE's */
-		ie_buf = current_ptr;
-		ie_len = curr_bcn_bytes;
-		dev_dbg(adapter->dev,
-			"info: InterpretIE: IELength for this AP = %d\n",
-			curr_bcn_bytes);
-
-		while (curr_bcn_bytes >= sizeof(struct ieee_types_header)) {
-			u8 element_id, element_len;
-
-			element_id = *current_ptr;
-			element_len = *(current_ptr + 1);
-			if (curr_bcn_bytes < element_len +
-					sizeof(struct ieee_types_header)) {
-				dev_err(priv->adapter->dev,
-					"%s: bytes left < IE length\n",
-					__func__);
-				goto check_next_scan;
-			}
-			if (element_id == WLAN_EID_DS_PARAMS) {
-				channel = *(current_ptr + sizeof(struct ieee_types_header));
-				break;
-			}
-
-			current_ptr += element_len +
-					sizeof(struct ieee_types_header);
-			curr_bcn_bytes -= element_len +
-					sizeof(struct ieee_types_header);
-		}
-
 		/*
 		 * If the TSF TLV was appended to the scan results, save this
 		 * entry's TSF value in the fw_tsf field. It is the firmware's
@@ -1787,51 +1836,19 @@ int mwifiex_ret_802_11_scan(struct mwifiex_private *priv,
 			memcpy(&fw_tsf, &tsf_tlv->tsf_data[idx * TSF_DATA_SIZE],
 			       sizeof(fw_tsf));
 
-		if (channel) {
-			struct ieee80211_channel *chan;
-			u8 band;
-
-			/* Skip entry if on csa closed channel */
-			if (channel == priv->csa_chan) {
-				dev_dbg(adapter->dev,
-					"Dropping entry on csa closed channel\n");
-				continue;
-			}
-
-			band = BAND_G;
-			if (chan_band_tlv) {
-				chan_band =
-					&chan_band_tlv->chan_band_param[idx];
-				band = mwifiex_radio_type_to_band(
-						chan_band->radio_type
-						& (BIT(0) | BIT(1)));
-			}
-
-			cfp = mwifiex_get_cfp(priv, band, channel, 0);
-
-			freq = cfp ? cfp->freq : 0;
-
-			chan = ieee80211_get_channel(priv->wdev->wiphy, freq);
-
-			if (chan && !(chan->flags & IEEE80211_CHAN_DISABLED)) {
-				bss = cfg80211_inform_bss(priv->wdev->wiphy,
-					      chan, bssid, timestamp,
-					      cap_info_bitmap, beacon_period,
-					      ie_buf, ie_len, rssi, GFP_KERNEL);
-				bss_priv = (struct mwifiex_bss_priv *)bss->priv;
-				bss_priv->band = band;
-				bss_priv->fw_tsf = le64_to_cpu(fw_tsf);
-				if (priv->media_connected &&
-				    !memcmp(bssid,
-					    priv->curr_bss_params.bss_descriptor
-					    .mac_address, ETH_ALEN))
-					mwifiex_update_curr_bss_params(priv,
-								       bss);
-				cfg80211_put_bss(priv->wdev->wiphy, bss);
-			}
+		if (chan_band_tlv) {
+			chan_band = &chan_band_tlv->chan_band_param[idx];
+			radio_type = &chan_band->radio_type;
 		} else {
-			dev_dbg(adapter->dev, "missing BSS channel IE\n");
+			radio_type = NULL;
 		}
+
+		ret = mwifiex_parse_single_response_buf(priv, &bss_info,
+							&bytes_left,
+							le64_to_cpu(fw_tsf),
+							radio_type, false);
+		if (ret)
+			goto check_next_scan;
 	}
 
 check_next_scan:
-- 
1.8.2.3

