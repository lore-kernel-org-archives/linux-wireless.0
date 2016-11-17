Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from relay.smtp.broadcom.com ([192.19.211.62]:38283 "EHLO
        relay.smtp.broadcom.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753058AbcKQLkB (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 17 Nov 2016 06:40:01 -0500
From: Arend van Spriel <arend.vanspriel@broadcom.com>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: linux-wireless <linux-wireless@vger.kernel.org>,
        Arend van Spriel <arend@broadcom.com>,
        Arend van Spriel <arend.vanspriel@broadcom.com>
Subject: [PATCH 2/5] nl80211: add reporting of gscan capabilities
Date: Thu, 17 Nov 2016 11:39:49 +0000
Message-Id: <1479382792-13131-3-git-send-email-arend.vanspriel@broadcom.com> (sfid-20161117_124005_602110_48A12DA1)
In-Reply-To: <1479382792-13131-1-git-send-email-arend.vanspriel@broadcom.com>
References: <1479382792-13131-1-git-send-email-arend.vanspriel@broadcom.com>
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
Signed-off-by: Arend van Spriel <arend.vanspriel@broadcom.com>
---
 include/net/cfg80211.h       | 36 +++++++++++++++++++++++++++
 include/uapi/linux/nl80211.h | 58 ++++++++++++++++++++++++++++++++++++++++++++
 net/wireless/nl80211.c       | 45 +++++++++++++++++++++++++++++++++-
 3 files changed, 138 insertions(+), 1 deletion(-)

diff --git a/include/net/cfg80211.h b/include/net/cfg80211.h
index d1217da..c77bb08 100644
--- a/include/net/cfg80211.h
+++ b/include/net/cfg80211.h
@@ -3372,6 +3372,40 @@ struct wiphy_iftype_ext_capab {
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
+	u32 max_scan_cache_size;
+	u32 max_scan_buckets;
+	u32 max_ap_cache_per_scan;
+	u32 max_rssi_sample_size;
+	u32 max_scan_reporting_threshold;
+	u32 max_hotlist_bssids;
+	u32 max_hotlist_ssids;
+	u32 max_significant_wifi_change_aps;
+	u32 max_bssid_history_entries;
+	u32 max_epno_hashed_networks;
+	u32 max_epno_exact_networks;
+	u32 max_white_list_ssid;
+};
+
+/**
  * struct wiphy - wireless hardware description
  * @reg_notifier: the driver's regulatory notification callback,
  *	note that if your driver uses wiphy_apply_custom_regulatory()
@@ -3524,6 +3558,7 @@ struct wiphy_iftype_ext_capab {
  * @bss_select_support: bitmask indicating the BSS selection criteria supported
  *	by the driver in the .connect() callback. The bit position maps to the
  *	attribute indices defined in &enum nl80211_bss_select_attr.
+ * @gscan: structure holding the hardware capabilities for gscan.
  *
  * @cookie_counter: unique generic cookie counter, used to identify objects.
  */
@@ -3654,6 +3689,7 @@ struct wiphy {
 	u8 max_adj_channel_rssi_comp;
 
 	u32 bss_select_support;
+	const struct wiphy_gscan_caps *gscan;
 
 	u64 cookie_counter;
 
diff --git a/include/uapi/linux/nl80211.h b/include/uapi/linux/nl80211.h
index 7e935f6..232a792 100644
--- a/include/uapi/linux/nl80211.h
+++ b/include/uapi/linux/nl80211.h
@@ -1977,6 +1977,9 @@ enum nl80211_commands {
  * @NL80211_ATTR_MULTICAST_TO_UNICAST_ENABLED: Indicates whether or not multicast
  *	packets should be send out as unicast to all stations (flag attribute).
  *
+ * @NL80211_ATTR_GSCAN_CAPS: indicating capabilities of GScan functionality
+ *	of the device. This is a nested attribute.
+ *
  * @NUM_NL80211_ATTR: total number of nl80211_attrs available
  * @NL80211_ATTR_MAX: highest attribute number currently defined
  * @__NL80211_ATTR_AFTER_LAST: internal use
@@ -2381,6 +2384,8 @@ enum nl80211_attrs {
 
 	NL80211_ATTR_MULTICAST_TO_UNICAST_ENABLED,
 
+	NL80211_ATTR_GSCAN_CAPS,
+
 	/* add attributes here, update the policy in nl80211.c */
 
 	__NL80211_ATTR_AFTER_LAST,
@@ -5188,4 +5193,57 @@ enum nl80211_nan_match_attributes {
 	NL80211_NAN_MATCH_ATTR_MAX = NUM_NL80211_NAN_MATCH_ATTR - 1
 };
 
+/**
+ * enum nl80211_gscan_caps_attr - GScan capabilities attributes.
+ *
+ * @__NL80211_GSCAN_CAPS_ATTR_INVALID: reserved.
+ * @NL80211_GSCAN_CAPS_ATTR_MAX_SCAN_CACHE_SIZE: total space allocated for
+ *	scan results (in bytes).
+ * @NL80211_GSCAN_CAPS_ATTR_MAX_SCAN_BUCKETS: maximum number of channel buckets.
+ * @NL80211_GSCAN_CAPS_ATTR_MAX_AP_CACHE_PER_SCAN: maximum number of APs that
+ *	can be stored per scan.
+ * @NL80211_GSCAN_CAPS_ATTR_MAX_RSSI_SAMPLE_SIZE:  number of RSSI samples used
+ *	for averaging RSSI.
+ * @NL80211_GSCAN_CAPS_ATTR_MAX_SCAN_REPORTING_THRESHOLD: max possible report
+ *	threshold. in percentage.
+ * @NL80211_GSCAN_CAPS_ATTR_MAX_HOTLIST_BSSID: maximum number of entries for
+ *	hotlist BSSIDs.
+ * @NL80211_GSCAN_CAPS_ATTR_MAX_HOTLIST_SSID: maximum number of entries for
+ *	hotlist SSIDs.
+ * @NL80211_GSCAN_CAPS_ATTR_MAX_SIGNIFICANT_WIFI_CHANGE_APS: maximum number of
+ *	entries for significant change APs.
+ * @NL80211_GSCAN_CAPS_ATTR_MAX_BSSID_HISTORY: number of BSSID/RSSI entries that
+ *	device can hold.
+ * @NL80211_GSCAN_CAPS_ATTR_MAX_EPNO_HASHED_NETWORKS: max number of hashed epno
+ *	entries.
+ * @NL80211_GSCAN_CAPS_ATTR_MAX_EPNO_EXACT_NETWORKS: max number of epno entries
+ *	for which an exact match of SSID is required or which are hidded SSIDs.
+ * @NL80211_GSCAN_CAPS_ATTR_MAX_WHITE_LIST_SSID: max number of white listed
+ *	SSIDs.
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
index ffce566..4606fc9 100644
--- a/net/wireless/nl80211.c
+++ b/net/wireless/nl80211.c
@@ -1423,9 +1423,10 @@ static int nl80211_send_wiphy(struct cfg80211_registered_device *rdev,
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
@@ -1880,6 +1881,48 @@ static int nl80211_send_wiphy(struct cfg80211_registered_device *rdev,
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
+		    nla_put_u32(msg, NL80211_GSCAN_CAPS_ATTR_MAX_SCAN_CACHE_SIZE,
+				gscan->max_scan_cache_size) ||
+		    nla_put_u32(msg, NL80211_GSCAN_CAPS_ATTR_MAX_SCAN_BUCKETS,
+				gscan->max_scan_buckets) ||
+		    nla_put_u32(msg, NL80211_GSCAN_CAPS_ATTR_MAX_AP_CACHE_PER_SCAN,
+				gscan->max_ap_cache_per_scan) ||
+		    nla_put_u32(msg, NL80211_GSCAN_CAPS_ATTR_MAX_RSSI_SAMPLE_SIZE,
+				gscan->max_rssi_sample_size) ||
+		    nla_put_u32(msg,
+				NL80211_GSCAN_CAPS_ATTR_MAX_SCAN_REPORTING_THRESHOLD,
+				gscan->max_scan_reporting_threshold) ||
+		    nla_put_u32(msg, NL80211_GSCAN_CAPS_ATTR_MAX_HOTLIST_BSSID,
+				gscan->max_hotlist_bssids) ||
+		    nla_put_u32(msg, NL80211_GSCAN_CAPS_ATTR_MAX_HOTLIST_SSID,
+				gscan->max_hotlist_ssids) ||
+		    nla_put_u32(msg,
+				NL80211_GSCAN_CAPS_ATTR_MAX_SIGNIFICANT_WIFI_CHANGE_APS,
+				gscan->max_significant_wifi_change_aps) ||
+		    nla_put_u32(msg, NL80211_GSCAN_CAPS_ATTR_MAX_BSSID_HISTORY,
+				gscan->max_bssid_history_entries) ||
+		    nla_put_u32(msg,
+				NL80211_GSCAN_CAPS_ATTR_MAX_EPNO_HASHED_NETWORKS,
+				gscan->max_epno_hashed_networks) ||
+		    nla_put_u32(msg,
+				NL80211_GSCAN_CAPS_ATTR_MAX_EPNO_EXACT_NETWORKS,
+				gscan->max_epno_exact_networks) ||
+		    nla_put_u32(msg, NL80211_GSCAN_CAPS_ATTR_MAX_WHITE_LIST_SSID,
+				gscan->max_white_list_ssid))
+			goto nla_put_failure;
+		nla_nest_end(msg, nl_gscan);
+
 		/* done */
 		state->split_start = 0;
 		break;
-- 
1.9.1
