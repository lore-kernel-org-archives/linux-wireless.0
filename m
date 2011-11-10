Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wy0-f174.google.com ([74.125.82.174]:55494 "EHLO
	mail-wy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933729Ab1KJJ3E (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 10 Nov 2011 04:29:04 -0500
Received: by wyh15 with SMTP id 15so2465632wyh.19
        for <linux-wireless@vger.kernel.org>; Thu, 10 Nov 2011 01:29:03 -0800 (PST)
From: Arik Nemtsov <arik@wizery.com>
To: <linux-wireless@vger.kernel.org>
Cc: Johannes Berg <johannes@sipsolutions.net>,
	Arik Nemtsov <arik@wizery.com>
Subject: [PATCH v5 1/3] nl80211: Add probe response offload attribute
Date: Thu, 10 Nov 2011 11:28:55 +0200
Message-Id: <1320917337-30561-1-git-send-email-arik@wizery.com> (sfid-20111110_102916_865359_FFFA7CBA)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Notify user-space about probe-response offloading support in the driver.

A wiphy flag is used to indicate support and a bitmap of protocols
determines which protocols are supported.

Signed-off-by: Guy Eilam <guy@wizery.com>
Signed-off-by: Arik Nemtsov <arik@wizery.com>
---
v4->5:
- fixed up the constant of the PROBE_RESP_OFFLOAD attribute (left over
  from v3)
- rebased everything on wireless-testing

include/linux/nl80211.h |   28 ++++++++++++++++++++++++++++
 include/net/cfg80211.h  |   10 ++++++++++
 net/wireless/nl80211.c  |    4 ++++
 3 files changed, 42 insertions(+), 0 deletions(-)

diff --git a/include/linux/nl80211.h b/include/linux/nl80211.h
index 3152ddf..be92333 100644
--- a/include/linux/nl80211.h
+++ b/include/linux/nl80211.h
@@ -1160,6 +1160,11 @@ enum nl80211_commands {
  *
  * @NL80211_ATTR_FEATURE_FLAGS: This u32 attribute contains flags from
  *	&enum nl80211_feature_flags and is advertised in wiphy information.
+ * @NL80211_ATTR_PROBE_RESP_OFFLOAD: Indicates that the HW responds to probe
+ *
+ *	requests while operating in AP-mode.
+ *	This attribute holds a bitmap of the supported protocols for
+ *	offloading (see &enum nl80211_probe_resp_offload_support_attr).
  *
  * @NL80211_ATTR_MAX: highest attribute number currently defined
  * @__NL80211_ATTR_AFTER_LAST: internal use
@@ -1395,6 +1400,8 @@ enum nl80211_attrs {
 
 	NL80211_ATTR_FEATURE_FLAGS,
 
+	NL80211_ATTR_PROBE_RESP_OFFLOAD,
+
 	/* add attributes here, update the policy in nl80211.c */
 
 	__NL80211_ATTR_AFTER_LAST,
@@ -2727,4 +2734,25 @@ enum nl80211_feature_flags {
 	NL80211_FEATURE_SK_TX_STATUS	= 1 << 0,
 };
 
+/**
+ * enum nl80211_probe_resp_offload_support_attr - optional supported
+ *	protocols for probe-response offloading by the driver/FW.
+ *	To be used with the %NL80211_ATTR_PROBE_RESP_OFFLOAD attribute.
+ *	Each enum value represents a bit in the bitmap of supported
+ *	protocols. Typically a subset of probe-requests belonging to a
+ *	supported protocol will be excluded from offload and uploaded
+ *	to the host.
+ *
+ * @NL80211_PROBE_RESP_OFFLOAD_SUPPORT_WPS: Support for WPS ver. 1
+ * @NL80211_PROBE_RESP_OFFLOAD_SUPPORT_WPS2: Support for WPS ver. 2
+ * @NL80211_PROBE_RESP_OFFLOAD_SUPPORT_P2P: Support for P2P
+ * @NL80211_PROBE_RESP_OFFLOAD_SUPPORT_80211U: Support for 802.11u
+ */
+enum nl80211_probe_resp_offload_support_attr {
+	NL80211_PROBE_RESP_OFFLOAD_SUPPORT_WPS =	1<<0,
+	NL80211_PROBE_RESP_OFFLOAD_SUPPORT_WPS2 =	1<<1,
+	NL80211_PROBE_RESP_OFFLOAD_SUPPORT_P2P =	1<<2,
+	NL80211_PROBE_RESP_OFFLOAD_SUPPORT_80211U =	1<<3,
+};
+
 #endif /* __LINUX_NL80211_H */
diff --git a/include/net/cfg80211.h b/include/net/cfg80211.h
index e1ee141..243bf23 100644
--- a/include/net/cfg80211.h
+++ b/include/net/cfg80211.h
@@ -1689,6 +1689,8 @@ struct cfg80211_ops {
  * @WIPHY_FLAG_REPORTS_OBSS: the device will report beacons from other BSSes
  *	when there are virtual interfaces in AP mode by calling
  *	cfg80211_report_obss_beacon().
+ * @WIPHY_FLAG_AP_PROBE_RESP_OFFLOAD: When operating as an AP, the device
+ *	responds to probe-requests in hardware.
  */
 enum wiphy_flags {
 	WIPHY_FLAG_CUSTOM_REGULATORY		= BIT(0),
@@ -1709,6 +1711,7 @@ enum wiphy_flags {
 	WIPHY_FLAG_TDLS_EXTERNAL_SETUP		= BIT(16),
 	WIPHY_FLAG_HAVE_AP_SME			= BIT(17),
 	WIPHY_FLAG_REPORTS_OBSS			= BIT(18),
+	WIPHY_FLAG_AP_PROBE_RESP_OFFLOAD	= BIT(19),
 };
 
 /**
@@ -1977,6 +1980,13 @@ struct wiphy {
 	u32 available_antennas_tx;
 	u32 available_antennas_rx;
 
+	/*
+	 * Bitmap of supported protocols for probe response offloading
+	 * see &enum nl80211_probe_resp_offload_support_attr. Only valid
+	 * when the wiphy flag @WIPHY_FLAG_AP_PROBE_RESP_OFFLOAD is set.
+	 */
+	u32 probe_resp_offload;
+
 	/* If multiple wiphys are registered and you're handed e.g.
 	 * a regular netdev with assigned ieee80211_ptr, you won't
 	 * know whether it points to a wiphy your driver has registered
diff --git a/net/wireless/nl80211.c b/net/wireless/nl80211.c
index 864fcb6..0349f48 100644
--- a/net/wireless/nl80211.c
+++ b/net/wireless/nl80211.c
@@ -759,6 +759,10 @@ static int nl80211_send_wiphy(struct sk_buff *msg, u32 pid, u32 seq, int flags,
 	NLA_PUT_U32(msg, NL80211_ATTR_WIPHY_ANTENNA_AVAIL_RX,
 		    dev->wiphy.available_antennas_rx);
 
+	if (dev->wiphy.flags & WIPHY_FLAG_AP_PROBE_RESP_OFFLOAD)
+		NLA_PUT_U32(msg, NL80211_ATTR_PROBE_RESP_OFFLOAD,
+			    dev->wiphy.probe_resp_offload);
+
 	if ((dev->wiphy.available_antennas_tx ||
 	     dev->wiphy.available_antennas_rx) && dev->ops->get_antenna) {
 		u32 tx_ant = 0, rx_ant = 0;
-- 
1.7.5.4

