Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ww0-f44.google.com ([74.125.82.44]:38924 "EHLO
	mail-ww0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750838Ab1KHQqJ (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 8 Nov 2011 11:46:09 -0500
Received: by wwi36 with SMTP id 36so1043384wwi.1
        for <linux-wireless@vger.kernel.org>; Tue, 08 Nov 2011 08:46:08 -0800 (PST)
From: Arik Nemtsov <arik@wizery.com>
To: <linux-wireless@vger.kernel.org>
Cc: Johannes Berg <johannes@sipsolutions.net>,
	Arik Nemtsov <arik@wizery.com>
Subject: [PATCH v4 1/3] nl80211: Add probe response offload attribute
Date: Tue,  8 Nov 2011 18:45:59 +0200
Message-Id: <1320770761-23268-1-git-send-email-arik@wizery.com> (sfid-20111108_174613_638639_0D27B516)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Notify user-space about probe-response offloading support in the driver.

A wiphy flag is used to indicate support and a bitmap of protocols
determines which protocols are supported.

Signed-off-by: Guy Eilam <guy@wizery.com>
Signed-off-by: Arik Nemtsov <arik@wizery.com>
---
v3->4:
- Add missing documentation
- Make comments more explicit about probe-resp offloading being always
  in-effect for supporting devices.

include/linux/nl80211.h |   28 ++++++++++++++++++++++++++++
 include/net/cfg80211.h  |   10 ++++++++++
 net/wireless/nl80211.c  |    5 +++++
 3 files changed, 43 insertions(+), 0 deletions(-)

diff --git a/include/linux/nl80211.h b/include/linux/nl80211.h
index 8049bf7..e468d0b 100644
--- a/include/linux/nl80211.h
+++ b/include/linux/nl80211.h
@@ -1109,6 +1109,11 @@ enum nl80211_commands {
  *	%NL80211_CMD_TDLS_MGMT. Otherwise %NL80211_CMD_TDLS_OPER should be
  *	used for asking the driver to perform a TDLS operation.
  *
+ * @NL80211_ATTR_PROBE_RESP_OFFLOAD: Indicates that the HW responds to probe
+ *	requests while operating in AP-mode.
+ *	This attribute holds a bitmap of the supported protocols for
+ *	offloading (see &enum nl80211_probe_resp_offload_support_attr).
+ *
  * @NL80211_ATTR_MAX: highest attribute number currently defined
  * @__NL80211_ATTR_AFTER_LAST: internal use
  */
@@ -1337,6 +1342,8 @@ enum nl80211_attrs {
 	NL80211_ATTR_TDLS_SUPPORT,
 	NL80211_ATTR_TDLS_EXTERNAL_SETUP,
 
+	NL80211_ATTR_PROBE_RESP_OFFLOAD_SUPPORT,
+
 	/* add attributes here, update the policy in nl80211.c */
 
 	__NL80211_ATTR_AFTER_LAST,
@@ -2650,4 +2657,25 @@ enum nl80211_tdls_operation {
 	NL80211_TDLS_DISABLE_LINK,
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
index 92cf1c2..9e8aa88 100644
--- a/include/net/cfg80211.h
+++ b/include/net/cfg80211.h
@@ -1675,6 +1675,8 @@ struct cfg80211_ops {
  *	teardown packets should be sent through the @NL80211_CMD_TDLS_MGMT
  *	command. When this flag is not set, @NL80211_CMD_TDLS_OPER should be
  *	used for asking the driver/firmware to perform a TDLS operation.
+ * @WIPHY_FLAG_AP_PROBE_RESP_OFFLOAD: When operating as an AP, the device
+ *	responds to probe-requests in hardware.
  */
 enum wiphy_flags {
 	WIPHY_FLAG_CUSTOM_REGULATORY		= BIT(0),
@@ -1693,6 +1695,7 @@ enum wiphy_flags {
 	WIPHY_FLAG_AP_UAPSD			= BIT(14),
 	WIPHY_FLAG_SUPPORTS_TDLS		= BIT(15),
 	WIPHY_FLAG_TDLS_EXTERNAL_SETUP		= BIT(16),
+	WIPHY_FLAG_AP_PROBE_RESP_OFFLOAD	= BIT(17),
 };
 
 /**
@@ -1956,6 +1959,13 @@ struct wiphy {
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
index b3a476f..62acdb8 100644
--- a/net/wireless/nl80211.c
+++ b/net/wireless/nl80211.c
@@ -758,6 +758,11 @@ static int nl80211_send_wiphy(struct sk_buff *msg, u32 pid, u32 seq, int flags,
 	NLA_PUT_U32(msg, NL80211_ATTR_WIPHY_ANTENNA_AVAIL_RX,
 		    dev->wiphy.available_antennas_rx);
 
+	if (dev->wiphy.flags & WIPHY_FLAG_AP_PROBE_RESP_OFFLOAD)
+		NLA_PUT_U32(msg,
+			NL80211_ATTR_PROBE_RESP_OFFLOAD_SUPPORT,
+			dev->wiphy.probe_resp_offload);
+
 	if ((dev->wiphy.available_antennas_tx ||
 	     dev->wiphy.available_antennas_rx) && dev->ops->get_antenna) {
 		u32 tx_ant = 0, rx_ant = 0;
-- 
1.7.5.4

