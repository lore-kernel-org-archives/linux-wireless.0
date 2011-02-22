Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from dakia2.marvell.com ([65.219.4.35]:40175 "EHLO
	dakia2.marvell.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750990Ab1BVVwu (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 22 Feb 2011 16:52:50 -0500
From: Bing Zhao <bzhao@marvell.com>
To: linux-wireless@vger.kernel.org
Cc: "John W. Linville" <linville@tuxdriver.com>,
	Johannes Berg <johannes@sipsolutions.net>,
	Amitkumar Karwar <akarwar@marvell.com>,
	Kiran Divekar <dkiran@marvell.com>,
	Frank Huang <frankh@marvell.com>, Bing Zhao <bzhao@marvell.com>
Subject: [PATCH] mwifiex: remove static forward declarations
Date: Tue, 22 Feb 2011 13:55:20 -0800
Message-Id: <1298411720-13917-1-git-send-email-bzhao@marvell.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

shuffle the code to get ride of the static forward declarations

Signed-off-by: Bing Zhao <bzhao@marvell.com>
Signed-off-by: Kiran Divekar <dkiran@marvell.com>
---
 drivers/net/wireless/mwifiex/cfg80211.c |  653 +++++++++++++-----------------
 drivers/net/wireless/mwifiex/cfg80211.h |    9 -
 2 files changed, 283 insertions(+), 379 deletions(-)

diff --git a/drivers/net/wireless/mwifiex/cfg80211.c b/drivers/net/wireless/mwifiex/cfg80211.c
index 6a8f9e1..9ae328b 100644
--- a/drivers/net/wireless/mwifiex/cfg80211.c
+++ b/drivers/net/wireless/mwifiex/cfg80211.c
@@ -20,62 +20,6 @@
 #include "cfg80211.h"
 #include "main.h"
 
-static int mwifiex_cfg80211_change_virtual_intf(struct wiphy *wiphy,
-						struct net_device *dev,
-						enum nl80211_iftype type,
-						u32 *flags,
-						struct vif_params *params);
-
-static int mwifiex_cfg80211_disconnect(struct wiphy *wiphy,
-				       struct net_device *dev, u16 reason_code);
-
-static int mwifiex_cfg80211_connect(struct wiphy *wiphy, struct net_device *dev,
-				    struct cfg80211_connect_params *sme);
-
-static int mwifiex_cfg80211_scan(struct wiphy *wiphy, struct net_device *dev,
-				 struct cfg80211_scan_request *request);
-
-static int mwifiex_cfg80211_get_station(struct wiphy *wiphy,
-					struct net_device *dev,
-					u8 *mac, struct station_info *sinfo);
-
-static int mwifiex_cfg80211_set_wiphy_params(struct wiphy *wiphy, u32 changed);
-
-static int mwifiex_cfg80211_set_channel(struct wiphy *wiphy,
-					struct net_device *dev,
-					struct ieee80211_channel *chan,
-					enum nl80211_channel_type channel_type);
-
-static int mwifiex_cfg80211_join_ibss(struct wiphy *wiphy,
-				      struct net_device *dev,
-				      struct cfg80211_ibss_params *params);
-
-static int mwifiex_cfg80211_leave_ibss(struct wiphy *wiphy,
-				       struct net_device *dev);
-
-static int mwifiex_cfg80211_add_key(struct wiphy *wiphy,
-				    struct net_device *netdev, u8 key_index,
-				    bool pairwise, const u8 *mac_addr,
-				    struct key_params *params);
-
-static int mwifiex_cfg80211_del_key(struct wiphy *wiphy,
-				    struct net_device *netdev, u8 key_index,
-				    bool pairwise, const u8 *mac_addr);
-
-static int mwifiex_cfg80211_set_default_key(struct wiphy *wiphy,
-					    struct net_device *netdev,
-					    u8 key_index, bool unicast,
-					    bool multicast);
-static int mwifiex_cfg80211_set_power_mgmt(struct wiphy *wiphy,
-					   struct net_device *dev, bool enabled,
-					   int timeout);
-
-static int mwifiex_cfg80211_set_tx_power(struct wiphy *wiphy,
-					 enum nl80211_tx_power_setting type,
-					 int dbm);
-static int mwifiex_inform_bss_from_scan_result(struct mwifiex_private *priv,
-					struct mwifiex_802_11_ssid *ssid);
-
 /*
  * This function maps the nl802.11 channel type into driver channel type.
  *
@@ -203,24 +147,6 @@ mwifiex_get_mwifiex_cipher(u32 cipher, int *wpa_enabled)
 	return encrypt_mode;
 }
 
-/** station cfg80211 operations */
-static struct cfg80211_ops mwifiex_cfg80211_ops = {
-	.change_virtual_intf = mwifiex_cfg80211_change_virtual_intf,
-	.scan = mwifiex_cfg80211_scan,
-	.connect = mwifiex_cfg80211_connect,
-	.disconnect = mwifiex_cfg80211_disconnect,
-	.get_station = mwifiex_cfg80211_get_station,
-	.set_wiphy_params = mwifiex_cfg80211_set_wiphy_params,
-	.set_channel = mwifiex_cfg80211_set_channel,
-	.join_ibss = mwifiex_cfg80211_join_ibss,
-	.leave_ibss = mwifiex_cfg80211_leave_ibss,
-	.add_key = mwifiex_cfg80211_add_key,
-	.del_key = mwifiex_cfg80211_del_key,
-	.set_default_key = mwifiex_cfg80211_set_default_key,
-	.set_power_mgmt = mwifiex_cfg80211_set_power_mgmt,
-	.set_tx_power = mwifiex_cfg80211_set_tx_power,
-};
-
 /*
  * This function returns the association status.
  */
@@ -233,10 +159,8 @@ mwifiex_get_assoc_status(struct mwifiex_private *priv)
 /*
  * This function retrieves the private structure from kernel wiphy structure.
  */
-void *
-mwifiex_cfg80211_get_priv(struct wiphy *wiphy)
+static void *mwifiex_cfg80211_get_priv(struct wiphy *wiphy)
 {
-
 	return (void *) (*(unsigned long *) wiphy_priv(wiphy));
 }
 
@@ -347,6 +271,128 @@ mwifiex_cfg80211_add_key(struct wiphy *wiphy, struct net_device *netdev,
 }
 
 /*
+ * This function sends domain information to the firmware.
+ *
+ * The following information are passed to the firmware -
+ *      - Country codes
+ *      - Sub bands (first channel, number of channels, maximum Tx power)
+ */
+static int mwifiex_send_domain_info_cmd_fw(struct wiphy *wiphy)
+{
+	u8 no_of_triplet = 0;
+	struct ieee80211_country_ie_triplet *t;
+	u8 no_of_parsed_chan = 0;
+	u8 first_chan = 0, next_chan = 0, max_pwr = 0;
+	u8 i, flag = 0;
+	enum ieee80211_band band;
+	struct ieee80211_supported_band *sband;
+	struct ieee80211_channel *ch;
+	struct mwifiex_private *priv = (struct mwifiex_private *)
+					mwifiex_cfg80211_get_priv(wiphy);
+	struct mwifiex_adapter *adapter = priv->adapter;
+	struct mwifiex_802_11d_domain_reg *domain_info = &adapter->domain_reg;
+	int ret = 0;
+
+	/* Set country code */
+	domain_info->country_code[0] = priv->country_code[0];
+	domain_info->country_code[1] = priv->country_code[1];
+	domain_info->country_code[2] = ' ';
+
+	band = mwifiex_band_to_radio_type(adapter->config_bands);
+	if (!wiphy->bands[band]) {
+		PRINTM(MERROR, "11D: Error setting domain info in FW\n");
+		return -1;
+	}
+
+	sband = wiphy->bands[band];
+
+	for (i = 0; i < sband->n_channels ; i++) {
+		ch = &sband->channels[i];
+		if (ch->flags & IEEE80211_CHAN_DISABLED)
+			continue;
+
+		if (!flag) {
+			flag = 1;
+			first_chan = (u32) ch->hw_value;
+			next_chan = first_chan;
+			max_pwr = ch->max_power;
+			no_of_parsed_chan = 1;
+			continue;
+		}
+
+		if (ch->hw_value == next_chan + 1 &&
+				ch->max_power == max_pwr) {
+			next_chan++;
+			no_of_parsed_chan++;
+		} else {
+			t = &domain_info->triplet[no_of_triplet];
+			t->chans.first_channel = first_chan;
+			t->chans.num_channels = no_of_parsed_chan;
+			t->chans.max_power = max_pwr;
+			no_of_triplet++;
+			first_chan = (u32) ch->hw_value;
+			next_chan = first_chan;
+			max_pwr = ch->max_power;
+			no_of_parsed_chan = 1;
+		}
+	}
+
+	if (flag) {
+		t = &domain_info->triplet[no_of_triplet];
+		t->chans.first_channel = first_chan;
+		t->chans.num_channels = no_of_parsed_chan;
+		t->chans.max_power = max_pwr;
+		no_of_triplet++;
+	}
+
+	domain_info->no_of_triplet = no_of_triplet;
+	/* Send cmd to FW to set domain info */
+	ret = mwifiex_prepare_cmd(priv,
+			HostCmd_CMD_802_11D_DOMAIN_INFO,
+			HostCmd_ACT_GEN_SET, 0, NULL, NULL);
+	if (ret)
+		PRINTM(MERROR, "11D: Error setting domain info in FW\n");
+
+	return ret;
+}
+
+/*
+ * CFG802.11 regulatory domain callback function.
+ *
+ * This function is called when the regulatory domain is changed due to the
+ * following reasons -
+ *      - Set by driver
+ *      - Set by system core
+ *      - Set by user
+ *      - Set bt Country IE
+ */
+static int mwifiex_reg_notifier(struct wiphy *wiphy,
+		struct regulatory_request *request)
+{
+	struct mwifiex_private *priv = (struct mwifiex_private *)
+				mwifiex_cfg80211_get_priv(wiphy);
+
+	PRINTM(MINFO, "cfg80211 regulatory domain callback for domain \
+			%c%c\n", request->alpha2[0], request->alpha2[1]);
+
+	memcpy(priv->country_code, request->alpha2, sizeof(request->alpha2));
+
+	switch (request->initiator) {
+	case NL80211_REGDOM_SET_BY_DRIVER:
+	case NL80211_REGDOM_SET_BY_CORE:
+	case NL80211_REGDOM_SET_BY_USER:
+		break;
+		/* Todo: apply driver specific changes in channel flags based
+		on the request initiator if necessory. **/
+	case NL80211_REGDOM_SET_BY_COUNTRY_IE:
+		break;
+	}
+	mwifiex_send_domain_info_cmd_fw(wiphy);
+
+	return 0;
+}
+
+/*
  * This function sets the RF channel.
  *
  * This function creates multiple IOCTL requests, populates them accordingly
@@ -890,6 +936,148 @@ static int mwifiex_cfg80211_inform_ibss_bss(struct mwifiex_private *priv)
 }
 
 /*
+ * This function informs the CFG802.11 subsystem of a new BSS connection.
+ *
+ * The following information are sent to the CFG802.11 subsystem
+ * to register the new BSS connection. If we do not register the new BSS,
+ * a kernel panic will result.
+ *      - MAC address
+ *      - Capabilities
+ *      - Beacon period
+ *      - RSSI value
+ *      - Channel
+ *      - Supported rates IE
+ *      - Extended capabilities IE
+ *      - DS parameter set IE
+ *      - HT Capability IE
+ *      - Vendor Specific IE (221)
+ *      - WPA IE
+ *      - RSN IE
+ */
+static int mwifiex_inform_bss_from_scan_result(struct mwifiex_private *priv,
+		struct mwifiex_802_11_ssid *ssid)
+{
+	struct mwifiex_scan_resp scan_resp;
+	struct mwifiex_bssdescriptor *scan_table;
+	int ret = 0, i, j;
+	struct ieee80211_channel *chan;
+	u8 *ie, *tmp, *ie_buf;
+	u32 ie_len;
+	u64 ts = 0;
+	u8 *beacon;
+	int beacon_size;
+	u8 element_id, element_len;
+
+	memset(&scan_resp, 0, sizeof(scan_resp));
+	if (mwifiex_get_scan_table(priv, MWIFIEX_IOCTL_WAIT, &scan_resp)) {
+		ret = -EFAULT;
+		goto done;
+	}
+
+#define MAX_IE_BUF	2048
+	ie_buf = kzalloc(MAX_IE_BUF, GFP_KERNEL);
+	if (!ie_buf) {
+		PRINTM(MERROR, "%s: failed to allocate ie_buf\n", __func__);
+		ret = -ENOMEM;
+		goto done;
+	}
+
+	scan_table = (struct mwifiex_bssdescriptor *) scan_resp.scan_table;
+	for (i = 0; i < scan_resp.num_in_scan_table; i++) {
+		if (ssid) {
+			/* Inform specific BSS only */
+			if (memcmp(ssid->ssid, scan_table[i].ssid.ssid,
+					   ssid->ssid_len))
+				continue;
+		}
+		memset(ie_buf, 0, MAX_IE_BUF);
+		ie_buf[0] = WLAN_EID_SSID;
+		ie_buf[1] = scan_table[i].ssid.ssid_len;
+		memcpy(&ie_buf[sizeof(struct ieee_types_header)],
+		       scan_table[i].ssid.ssid, ie_buf[1]);
+
+		ie = ie_buf + ie_buf[1] + sizeof(struct ieee_types_header);
+		ie_len = ie_buf[1] + sizeof(struct ieee_types_header);
+
+		ie[0] = WLAN_EID_SUPP_RATES;
+
+		for (j = 0; j < sizeof(scan_table[i].supported_rates); j++) {
+			if (!scan_table[i].supported_rates[j])
+				break;
+			else
+				ie[j + sizeof(struct ieee_types_header)] =
+					scan_table[i].supported_rates[j];
+		}
+
+		ie[1] = j;
+		ie_len += ie[1] + sizeof(struct ieee_types_header);
+
+		beacon = scan_table[i].beacon_buf;
+		beacon_size = scan_table[i].beacon_buf_size;
+
+		/* Skip time stamp, beacon interval and capability */
+
+		if (beacon) {
+			beacon += sizeof(scan_table[i].beacon_period)
+				+ sizeof(scan_table[i].time_stamp) +
+				+sizeof(scan_table[i].cap_info_bitmap);
+
+			beacon_size -= sizeof(scan_table[i].beacon_period)
+				+ sizeof(scan_table[i].time_stamp)
+				+ sizeof(scan_table[i].cap_info_bitmap);
+		}
+
+		while (beacon_size >= sizeof(struct ieee_types_header)) {
+			ie = ie_buf + ie_len;
+			element_id = *beacon;
+			element_len = *(beacon + 1);
+			if (beacon_size < (int) element_len +
+			    sizeof(struct ieee_types_header)) {
+				PRINTM(MERROR, "Get scan: Error in processing"
+				       " IE, bytes left < IE length\n");
+				break;
+			}
+			switch (element_id) {
+			case WLAN_EID_EXT_CAPABILITY:
+			case WLAN_EID_DS_PARAMS:
+			case WLAN_EID_HT_CAPABILITY:
+			case WLAN_EID_VENDOR_SPECIFIC:
+			case WLAN_EID_RSN:
+			case WLAN_EID_BSS_AC_ACCESS_DELAY:
+				ie[0] = element_id;
+				ie[1] = element_len;
+				tmp = (u8 *) beacon;
+				memcpy(&ie[sizeof(struct ieee_types_header)],
+				       tmp + sizeof(struct ieee_types_header),
+				       element_len);
+				ie_len += ie[1] +
+					sizeof(struct ieee_types_header);
+				break;
+			default:
+				break;
+			}
+			beacon += element_len +
+					sizeof(struct ieee_types_header);
+			beacon_size -= element_len +
+					sizeof(struct ieee_types_header);
+		}
+		chan = ieee80211_get_channel(priv->wdev->wiphy,
+						scan_table[i].freq);
+		cfg80211_inform_bss(priv->wdev->wiphy, chan,
+					scan_table[i].mac_address,
+					ts, scan_table[i].cap_info_bitmap,
+					scan_table[i].beacon_period,
+					ie_buf, ie_len,
+					scan_table[i].rssi, GFP_KERNEL);
+	}
+
+	kfree(ie_buf);
+
+done:
+	return ret;
+}
+
+/*
  * This function connects with a BSS.
  *
  * This function handles both Infra and Ad-Hoc modes. It also performs
@@ -1176,155 +1364,6 @@ mwifiex_cfg80211_leave_ibss(struct wiphy *wiphy, struct net_device *dev)
 }
 
 /*
- * This function informs the CFG802.11 subsystem of a new BSS connection.
- *
- * The following information are sent to the CFG802.11 subsystem
- * to register the new BSS connection. If we do not register the new BSS,
- * a kernel panic will result.
- *      - MAC address
- *      - Capabilities
- *      - Beacon period
- *      - RSSI value
- *      - Channel
- *      - Supported rates IE
- *      - Extended capabilities IE
- *      - DS parameter set IE
- *      - HT Capability IE
- *      - Vendor Specific IE (221)
- *      - WPA IE
- *      - RSN IE
- */
-static int
-mwifiex_inform_bss_from_scan_result(struct mwifiex_private *priv,
-		struct mwifiex_802_11_ssid *ssid)
-{
-	struct mwifiex_scan_resp scan_resp;
-	struct mwifiex_bssdescriptor *scan_table;
-	int ret = 0, i, j;
-	struct ieee80211_channel *chan;
-	u8 *ie, *tmp, *ie_buf;
-	u32 ie_len;
-	u64 ts = 0;
-	u8 *beacon;
-	int beacon_size;
-	u8 element_id;
-	u8 element_len;
-
-	ENTER();
-	memset(&scan_resp, 0, sizeof(scan_resp));
-	if (mwifiex_get_scan_table(priv, MWIFIEX_IOCTL_WAIT, &scan_resp)) {
-		ret = -EFAULT;
-		goto done;
-	}
-#define MAX_IE_BUF	2048
-	ie_buf = kzalloc(MAX_IE_BUF, GFP_KERNEL);
-	if (!ie_buf) {
-		PRINTM(MERROR, "%s: failed to allocate ie_buf\n", __func__);
-		ret = -ENOMEM;
-		goto done;
-	}
-
-	scan_table = (struct mwifiex_bssdescriptor *) scan_resp.scan_table;
-	for (i = 0; i < scan_resp.num_in_scan_table; i++) {
-
-		if (ssid) {
-			/* Inform specific BSS only */
-			if (memcmp(ssid->ssid, scan_table[i].ssid.ssid,
-					   ssid->ssid_len))
-				continue;
-		}
-		memset(ie_buf, 0, MAX_IE_BUF);
-		ie_buf[0] = WLAN_EID_SSID;
-		ie_buf[1] = scan_table[i].ssid.ssid_len;
-		memcpy(&ie_buf[sizeof(struct ieee_types_header)],
-		       scan_table[i].ssid.ssid, ie_buf[1]);
-
-		ie = ie_buf + ie_buf[1] + sizeof(struct ieee_types_header);
-		ie_len = ie_buf[1] + sizeof(struct ieee_types_header);
-
-		ie[0] = WLAN_EID_SUPP_RATES;
-
-		for (j = 0; j < sizeof(scan_table[i].supported_rates); j++) {
-			if (!scan_table[i].supported_rates[j])
-				break;
-			else {
-				ie[j + sizeof(struct ieee_types_header)] =
-					scan_table[i].supported_rates[j];
-			}
-		}
-
-		ie[1] = j;
-		ie_len += ie[1] + sizeof(struct ieee_types_header);
-
-		beacon = scan_table[i].beacon_buf;
-		beacon_size = scan_table[i].beacon_buf_size;
-
-		/* Skip time stamp, beacon interval and capability */
-
-		if (beacon) {
-			beacon += sizeof(scan_table[i].beacon_period)
-				+ sizeof(scan_table[i].time_stamp) +
-				+sizeof(scan_table[i].cap_info_bitmap);
-
-			beacon_size -= sizeof(scan_table[i].beacon_period)
-				+ sizeof(scan_table[i].time_stamp)
-				+ sizeof(scan_table[i].cap_info_bitmap);
-		}
-
-		while (beacon_size >= sizeof(struct ieee_types_header)) {
-			ie = ie_buf + ie_len;
-			element_id = *beacon;
-			element_len = *(beacon + 1);
-			if (beacon_size <
-			    (int) element_len +
-			    sizeof(struct ieee_types_header)) {
-				PRINTM(MERROR,
-				       "Get scan: Error in processing IE, "
-				       "bytes left < IE length\n");
-				break;
-			}
-			switch (element_id) {
-			case WLAN_EID_EXT_CAPABILITY:
-			case WLAN_EID_DS_PARAMS:
-			case WLAN_EID_HT_CAPABILITY:
-			case WLAN_EID_VENDOR_SPECIFIC:
-			case WLAN_EID_RSN:
-			case WLAN_EID_BSS_AC_ACCESS_DELAY:
-				ie[0] = element_id;
-				ie[1] = element_len;
-				tmp = (u8 *) beacon;
-				memcpy(&ie[sizeof(struct ieee_types_header)],
-				       tmp + sizeof(struct ieee_types_header),
-				       element_len);
-				ie_len +=
-					ie[1] +
-					sizeof(struct ieee_types_header);
-				break;
-			default:
-				break;
-			}
-			beacon +=
-				element_len + sizeof(struct ieee_types_header);
-			beacon_size -=
-				element_len + sizeof(struct ieee_types_header);
-		}
-		chan = ieee80211_get_channel(priv->wdev->wiphy,
-				scan_table[i].freq);
-		cfg80211_inform_bss(priv->wdev->wiphy, chan,
-				scan_table[i].mac_address,
-				    ts, scan_table[i].cap_info_bitmap,
-				    scan_table[i].beacon_period, ie_buf, ie_len,
-				    scan_table[i].rssi, GFP_KERNEL);
-	}
-
-	kfree(ie_buf);
-
-done:
-	LEAVE();
-	return ret;
-}
-
-/*
  * CFG802.11 operation handler for scan request.
  *
  * This function issues a scan request to the firmware based upon
@@ -1397,6 +1436,24 @@ mwifiex_setup_ht_caps(struct ieee80211_sta_ht_cap *ht_info,
 	LEAVE();
 }
 
+/** station cfg80211 operations */
+static struct cfg80211_ops mwifiex_cfg80211_ops = {
+	.change_virtual_intf = mwifiex_cfg80211_change_virtual_intf,
+	.scan = mwifiex_cfg80211_scan,
+	.connect = mwifiex_cfg80211_connect,
+	.disconnect = mwifiex_cfg80211_disconnect,
+	.get_station = mwifiex_cfg80211_get_station,
+	.set_wiphy_params = mwifiex_cfg80211_set_wiphy_params,
+	.set_channel = mwifiex_cfg80211_set_channel,
+	.join_ibss = mwifiex_cfg80211_join_ibss,
+	.leave_ibss = mwifiex_cfg80211_leave_ibss,
+	.add_key = mwifiex_cfg80211_add_key,
+	.del_key = mwifiex_cfg80211_del_key,
+	.set_default_key = mwifiex_cfg80211_set_default_key,
+	.set_power_mgmt = mwifiex_cfg80211_set_power_mgmt,
+	.set_tx_power = mwifiex_cfg80211_set_tx_power,
+};
+
 /*
  * This function registers the device with CFG802.11 subsystem.
  *
@@ -1574,147 +1631,3 @@ done:
 
 	return;
 }
-
-/**
- *  This function prepares the set domain info command and sends
- *  it to firmware.
- */
-static int mwifiex_11d_set_domain_info(struct mwifiex_private *priv)
-{
-	int ret = 0;
-
-	ENTER();
-
-	/* Send cmd to FW to set domain info */
-	ret = mwifiex_prepare_cmd(priv,
-			HostCmd_CMD_802_11D_DOMAIN_INFO,
-			HostCmd_ACT_GEN_SET, 0, NULL, NULL);
-	if (ret)
-		PRINTM(MERROR, "11D: Failed to download domain Info\n");
-
-	LEAVE();
-	return ret;
-}
-
-/*
- * This function sends domain information to the firmware.
- *
- * The following information are passed to the firmware -
- *      - Country codes
- *      - Sub bands (first channel, number of channels, maximum Tx power)
- */
-void mwifiex_send_domain_info_cmd_fw(struct wiphy *wiphy)
-{
-	u8 no_of_triplet = 0;
-	struct ieee80211_country_ie_triplet *t;
-	u8 no_of_parsed_chan = 0;
-	u8 first_chan = 0, next_chan = 0, max_pwr = 0;
-	u8 i, flag = 0;
-	enum ieee80211_band band;
-	struct ieee80211_supported_band *sband;
-	struct ieee80211_channel *ch;
-	struct mwifiex_private *priv = (struct mwifiex_private *)
-					mwifiex_cfg80211_get_priv(wiphy);
-	struct mwifiex_adapter *adapter = priv->adapter;
-	struct mwifiex_802_11d_domain_reg *domain_info = &adapter->domain_reg;
-	int ret = 0;
-
-	ENTER();
-	/* Set country code */
-	domain_info->country_code[0] = priv->country_code[0];
-	domain_info->country_code[1] = priv->country_code[1];
-	domain_info->country_code[2] = ' ';
-
-	band = mwifiex_band_to_radio_type(adapter->config_bands);
-	if (!wiphy->bands[band]) {
-		PRINTM(MERROR, "11D: Error setting domain info in FW\n");
-		return;
-	}
-
-	sband = wiphy->bands[band];
-
-	for (i = 0; i < sband->n_channels ; i++) {
-		ch = &sband->channels[i];
-		if (ch->flags & IEEE80211_CHAN_DISABLED)
-			continue;
-
-		if (!flag) {
-			flag = 1;
-			first_chan = (u32) ch->hw_value;
-			next_chan = first_chan;
-			max_pwr = ch->max_power;
-			no_of_parsed_chan = 1;
-			continue;
-		}
-
-		if (ch->hw_value == next_chan + 1 &&
-				ch->max_power == max_pwr) {
-			next_chan++;
-			no_of_parsed_chan++;
-		} else {
-			t = &domain_info->triplet[no_of_triplet];
-			t->chans.first_channel = first_chan;
-			t->chans.num_channels = no_of_parsed_chan;
-			t->chans.max_power = max_pwr;
-			no_of_triplet++;
-			first_chan = (u32) ch->hw_value;
-			next_chan = first_chan;
-			max_pwr = ch->max_power;
-			no_of_parsed_chan = 1;
-		}
-	}
-
-	if (flag) {
-		t = &domain_info->triplet[no_of_triplet];
-		t->chans.first_channel = first_chan;
-		t->chans.num_channels = no_of_parsed_chan;
-		t->chans.max_power = max_pwr;
-		no_of_triplet++;
-	}
-
-	domain_info->no_of_triplet = no_of_triplet;
-	/* Set domain info */
-	ret = mwifiex_11d_set_domain_info(priv);
-	if (ret)
-		PRINTM(MERROR, "11D: Error setting domain info in FW\n");
-	LEAVE();
-}
-
-/*
- * CFG802.11 regulatory domain callback function.
- *
- * This function is called when the regulatory domain is changed due to the
- * following reasons -
- *      - Set by driver
- *      - Set by system core
- *      - Set by user
- *      - Set bt Country IE
- */
-int mwifiex_reg_notifier(struct wiphy *wiphy,
-		struct regulatory_request *request)
-{
-	struct mwifiex_private *priv = (struct mwifiex_private *)
-				mwifiex_cfg80211_get_priv(wiphy);
-	ENTER();
-
-	PRINTM(MINFO, "cfg80211 regulatory domain callback for domain \
-			%c%c\n", request->alpha2[0], request->alpha2[1]);
-
-	memcpy(priv->country_code, request->alpha2, sizeof(request->alpha2));
-
-	switch (request->initiator) {
-	case NL80211_REGDOM_SET_BY_DRIVER:
-	case NL80211_REGDOM_SET_BY_CORE:
-	case NL80211_REGDOM_SET_BY_USER:
-		break;
-		/* Todo: apply driver specific changes in channel flags based
-		on the request initiator if necessory. **/
-	case NL80211_REGDOM_SET_BY_COUNTRY_IE:
-		break;
-	}
-	mwifiex_send_domain_info_cmd_fw(wiphy);
-
-	LEAVE();
-
-	return 0;
-}
diff --git a/drivers/net/wireless/mwifiex/cfg80211.h b/drivers/net/wireless/mwifiex/cfg80211.h
index 90dd077..6468739 100644
--- a/drivers/net/wireless/mwifiex/cfg80211.h
+++ b/drivers/net/wireless/mwifiex/cfg80211.h
@@ -28,13 +28,4 @@ int mwifiex_register_cfg80211(struct net_device *, u8 *,
 				struct mwifiex_private *);
 
 void mwifiex_cfg80211_results(struct work_struct *work);
-
-void *mwifiex_cfg80211_get_priv(struct wiphy *wiphy);
-
-/*	cfg80211 regulatory domain definitions	*/
-
-int mwifiex_reg_notifier(struct wiphy *wiphy,
-			 struct regulatory_request *request);
-void mwifiex_send_domain_info_cmd_fw(struct wiphy *wiphy);
-
 #endif
-- 
1.7.0.2

