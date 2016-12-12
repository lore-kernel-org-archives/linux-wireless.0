Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from lpdvsmtp01.broadcom.com ([192.19.211.62]:54803 "EHLO
        relay.smtp.broadcom.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750727AbcLLMAR (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 12 Dec 2016 07:00:17 -0500
From: Arend van Spriel <arend.vanspriel@broadcom.com>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: linux-wireless <linux-wireless@vger.kernel.org>,
        Arend van Spriel <arend@broadcom.com>
Subject: [RFC V3 01/11] nl80211: add reporting of gscan capabilities
Date: Mon, 12 Dec 2016 11:59:47 +0000
Message-Id: <1481543997-24624-2-git-send-email-arend.vanspriel@broadcom.com> (sfid-20161212_130037_527759_F3F3201B)
In-Reply-To: <1481543997-24624-1-git-send-email-arend.vanspriel@broadcom.com>
References: <1481543997-24624-1-git-send-email-arend.vanspriel@broadcom.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Arend van Spriel <arend@broadcom.com>

GScan is a scan offload feature used in recent Android releases. This
patch adds possibility for wireless device drivers to report their
capabilities and provide it to user-space.

Reviewed-by: Hante Meuleman <hante.meuleman@broadcom.com>
Reviewed-by: Pieter-Paul Giesberts <pieter-paul.giesberts@broadcom.com>
Reviewed-by: Franky Lin <franky.lin@broadcom.com>
Signed-off-by: Arend van Spriel <arend@broadcom.com>
---
Changes:
 V3:
  - change storage types for capabilities.
---
 include/net/cfg80211.h       | 36 +++++++++++++++++++++++++++
 include/uapi/linux/nl80211.h | 59 ++++++++++++++++++++++++++++++++++++++++++++
 net/wireless/nl80211.c       | 45 ++++++++++++++++++++++++++++++++-
 3 files changed, 139 insertions(+), 1 deletion(-)

diff --git a/include/net/cfg80211.h b/include/net/cfg80211.h
index ef42749..b78377f 100644
--- a/include/net/cfg80211.h
+++ b/include/net/cfg80211.h
@@ -3361,6 +3361,40 @@ struct wiphy_iftype_ext_capab {
 };

 /**
+ * struct wiphy_gscan_caps -  gscan capabilities of the device.
+ *
+ * @max_scan_cache_size: total space allocated for scan results (in bytes).
+ * @max_scan_buckets: maximum number of channel buckets.
+ * @max_ap_cache_per_scan: maximum number of APs that can be stored per scan.
+ * @max_rssi_sample_size: number of RSSI samples used for averaging RSSI.
+ * @max_scan_reporting_threshold: max possible report threshold. in percentage.
+ * @max_hotlist_bssids: maximum number of entries for hotlist BSSIDs.
+ * @max_hotlist_ssids: maximum number of entries for hotlist SSIDs.
+ * @max_significant_wifi_change_aps: maximum number of entries for significant
+ *	change APs.
+ * @max_bssid_history_entries: number of BSSID/RSSI entries that device can
+ *	hold.
+ * @max_epno_networks: max number of hashed epno entries.
+ * @max_epno_networks_by_ssid: max number of epno entries for which an
+ *	exact match of SSID is required or which are hidded SSIDs.
+ * @max_white_list_ssid: max number of white listed SSIDs.
+ */
+struct wiphy_gscan_caps {
+	u16 max_scan_cache_size;
+	u8 max_scan_buckets;
+	u8 max_ap_cache_per_scan;
+	u8 max_rssi_sample_size;
+	u8 max_scan_reporting_threshold;
+	u8 max_hotlist_bssids;
+	u8 max_hotlist_ssids;
+	u8 max_significant_wifi_change_aps;
+	u8 max_bssid_history_entries;
+	u8 max_epno_hashed_networks;
+	u8 max_epno_exact_networks;
+	u8 max_white_list_ssid;
+};
+
+/**
  * struct wiphy - wireless hardware description
  * @reg_notifier: the driver's regulatory notification callback,
  *	note that if your driver uses wiphy_apply_custom_regulatory()
@@ -3513,6 +3547,7 @@ struct wiphy_iftype_ext_capab {
  * @bss_select_support: bitmask indicating the BSS selection criteria supported
  *	by the driver in the .connect() callback. The bit position maps to the
  *	attribute indices defined in &enum nl80211_bss_select_attr.
+ * @gscan: structure holding the hardware capabilities for gscan.
  *
  * @cookie_counter: unique generic cookie counter, used to identify objects.
  */
@@ -3643,6 +3678,7 @@ struct wiphy {
 	u8 max_adj_channel_rssi_comp;

 	u32 bss_select_support;
+	const struct wiphy_gscan_caps *gscan;

 	u64 cookie_counter;

diff --git a/include/uapi/linux/nl80211.h b/include/uapi/linux/nl80211.h
index 6b76e3b..01ab2f7 100644
--- a/include/uapi/linux/nl80211.h
+++ b/include/uapi/linux/nl80211.h
@@ -1980,6 +1980,9 @@ enum nl80211_commands {
  * @NL80211_ATTR_BSSID: The BSSID of the AP. Note that %NL80211_ATTR_MAC is also
  *	used in various commands/events for specifying the BSSID.
  *
+ * @NL80211_ATTR_GSCAN_CAPS: indicating capabilities of GScan functionality
+ *	of the device. This is a nested attribute.
+ *
  * @NUM_NL80211_ATTR: total number of nl80211_attrs available
  * @NL80211_ATTR_MAX: highest attribute number currently defined
  * @__NL80211_ATTR_AFTER_LAST: internal use
@@ -2385,6 +2388,7 @@ enum nl80211_attrs {
 	NL80211_ATTR_MULTICAST_TO_UNICAST_ENABLED,

 	NL80211_ATTR_BSSID,
+	NL80211_ATTR_GSCAN_CAPS,

 	/* add attributes here, update the policy in nl80211.c */

@@ -5187,4 +5191,59 @@ enum nl80211_nan_match_attributes {
 	NL80211_NAN_MATCH_ATTR_MAX = NUM_NL80211_NAN_MATCH_ATTR - 1
 };

+/**
+ * enum nl80211_gscan_caps_attr - GScan capabilities attributes.
+ *
+ * @__NL80211_GSCAN_CAPS_ATTR_INVALID: reserved.
+ * @NL80211_GSCAN_CAPS_ATTR_MAX_SCAN_CACHE_SIZE: total space allocated for
+ *	scan results in bytes (u16).
+ * @NL80211_GSCAN_CAPS_ATTR_MAX_SCAN_BUCKETS: maximum number of channel buckets
+ *	allowed (u8).
+ * @NL80211_GSCAN_CAPS_ATTR_MAX_AP_CACHE_PER_SCAN: maximum number of APs that
+ *	can be stored per scan (u8).
+ * @NL80211_GSCAN_CAPS_ATTR_MAX_RSSI_SAMPLE_SIZE: maximum number of RSSI samples
+ *	used for averaging RSSI (u8).
+ * @NL80211_GSCAN_CAPS_ATTR_MAX_SCAN_REPORTING_THRESHOLD: maximum allowed
+ *	percentile report threshold (u8).
+ * @NL80211_GSCAN_CAPS_ATTR_MAX_HOTLIST_BSSID: maximum number of entries for
+ *	hotlist BSSIDs (u8).
+ * @NL80211_GSCAN_CAPS_ATTR_MAX_HOTLIST_SSID: maximum number of entries for
+ *	hotlist SSIDs (u8).
+ * @NL80211_GSCAN_CAPS_ATTR_MAX_SIGNIFICANT_WIFI_CHANGE_APS: maximum number of
+ *	entries for significant change APs (u8).
+ * @NL80211_GSCAN_CAPS_ATTR_MAX_BSSID_HISTORY: number of BSSID/RSSI entries that
+ *	device can hold (u8).
+ * @NL80211_GSCAN_CAPS_ATTR_MAX_EPNO_HASHED_NETWORKS: maximum number of hashed
+ *	epno entries (u8).
+ * @NL80211_GSCAN_CAPS_ATTR_MAX_EPNO_EXACT_NETWORKS: maximum number of epno
+ *	entries for which an exact match of SSID is required or which are hidden
+ *	SSIDs (u8).
+ * @NL80211_GSCAN_CAPS_ATTR_MAX_WHITE_LIST_SSID: maximum number of white listed
+ *	SSIDs (u8).
+ * @NL80211_GSCAN_CAPS_ATTR_MAX: highest GScan capability attribute.
+ *
+ * @__NL80211_GSCAN_CAPS_ATTR_AFTER_LAST: internal use.
+ *
+ * All attributes are u32 type.
+ */
+enum nl80211_gscan_caps_attr {
+	__NL80211_GSCAN_CAPS_ATTR_INVALID,
+	NL80211_GSCAN_CAPS_ATTR_MAX_SCAN_CACHE_SIZE,
+	NL80211_GSCAN_CAPS_ATTR_MAX_SCAN_BUCKETS,
+	NL80211_GSCAN_CAPS_ATTR_MAX_AP_CACHE_PER_SCAN,
+	NL80211_GSCAN_CAPS_ATTR_MAX_RSSI_SAMPLE_SIZE,
+	NL80211_GSCAN_CAPS_ATTR_MAX_SCAN_REPORTING_THRESHOLD,
+	NL80211_GSCAN_CAPS_ATTR_MAX_HOTLIST_BSSID,
+	NL80211_GSCAN_CAPS_ATTR_MAX_HOTLIST_SSID,
+	NL80211_GSCAN_CAPS_ATTR_MAX_SIGNIFICANT_WIFI_CHANGE_APS,
+	NL80211_GSCAN_CAPS_ATTR_MAX_BSSID_HISTORY,
+	NL80211_GSCAN_CAPS_ATTR_MAX_EPNO_HASHED_NETWORKS,
+	NL80211_GSCAN_CAPS_ATTR_MAX_EPNO_EXACT_NETWORKS,
+	NL80211_GSCAN_CAPS_ATTR_MAX_WHITE_LIST_SSID,
+
+	/* keep last */
+	__NL80211_GSCAN_CAPS_ATTR_AFTER_LAST,
+	NL80211_GSCAN_CAPS_ATTR_MAX = __NL80211_GSCAN_CAPS_ATTR_AFTER_LAST - 1
+};
+
 #endif /* __LINUX_NL80211_H */
diff --git a/net/wireless/nl80211.c b/net/wireless/nl80211.c
index 7762231..40209ec 100644
--- a/net/wireless/nl80211.c
+++ b/net/wireless/nl80211.c
@@ -1424,9 +1424,10 @@ static int nl80211_send_wiphy(struct cfg80211_registered_device *rdev,
 	void *hdr;
 	struct nlattr *nl_bands, *nl_band;
 	struct nlattr *nl_freqs, *nl_freq;
-	struct nlattr *nl_cmds;
+	struct nlattr *nl_cmds, *nl_gscan;
 	enum nl80211_band band;
 	struct ieee80211_channel *chan;
+	const struct wiphy_gscan_caps *gscan;
 	int i;
 	const struct ieee80211_txrx_stypes *mgmt_stypes =
 				rdev->wiphy.mgmt_stypes;
@@ -1881,6 +1882,48 @@ static int nl80211_send_wiphy(struct cfg80211_registered_device *rdev,
 			}
 		}

+		state->split_start++;
+		break;
+	case 14:
+		if (!rdev->wiphy.gscan) {
+			/* done */
+			state->split_start = 0;
+			break;
+		}
+		gscan = rdev->wiphy.gscan;
+		nl_gscan = nla_nest_start(msg, NL80211_ATTR_GSCAN_CAPS);
+		if (!nl_gscan ||
+		    nla_put_u16(msg, NL80211_GSCAN_CAPS_ATTR_MAX_SCAN_CACHE_SIZE,
+				gscan->max_scan_cache_size) ||
+		    nla_put_u8(msg, NL80211_GSCAN_CAPS_ATTR_MAX_SCAN_BUCKETS,
+			       gscan->max_scan_buckets) ||
+		    nla_put_u8(msg, NL80211_GSCAN_CAPS_ATTR_MAX_AP_CACHE_PER_SCAN,
+			       gscan->max_ap_cache_per_scan) ||
+		    nla_put_u8(msg, NL80211_GSCAN_CAPS_ATTR_MAX_RSSI_SAMPLE_SIZE,
+			       gscan->max_rssi_sample_size) ||
+		    nla_put_u8(msg,
+			       NL80211_GSCAN_CAPS_ATTR_MAX_SCAN_REPORTING_THRESHOLD,
+			       gscan->max_scan_reporting_threshold) ||
+		    nla_put_u8(msg, NL80211_GSCAN_CAPS_ATTR_MAX_HOTLIST_BSSID,
+			       gscan->max_hotlist_bssids) ||
+		    nla_put_u8(msg, NL80211_GSCAN_CAPS_ATTR_MAX_HOTLIST_SSID,
+			       gscan->max_hotlist_ssids) ||
+		    nla_put_u8(msg,
+			       NL80211_GSCAN_CAPS_ATTR_MAX_SIGNIFICANT_WIFI_CHANGE_APS,
+			       gscan->max_significant_wifi_change_aps) ||
+		    nla_put_u8(msg, NL80211_GSCAN_CAPS_ATTR_MAX_BSSID_HISTORY,
+			       gscan->max_bssid_history_entries) ||
+		    nla_put_u8(msg,
+			       NL80211_GSCAN_CAPS_ATTR_MAX_EPNO_HASHED_NETWORKS,
+			       gscan->max_epno_hashed_networks) ||
+		    nla_put_u8(msg,
+			       NL80211_GSCAN_CAPS_ATTR_MAX_EPNO_EXACT_NETWORKS,
+			       gscan->max_epno_exact_networks) ||
+		    nla_put_u8(msg, NL80211_GSCAN_CAPS_ATTR_MAX_WHITE_LIST_SSID,
+			       gscan->max_white_list_ssid))
+			goto nla_put_failure;
+		nla_nest_end(msg, nl_gscan);
+
 		/* done */
 		state->split_start = 0;
 		break;
--
1.9.1
