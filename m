Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ey0-f174.google.com ([209.85.215.174]:59695 "EHLO
	mail-ey0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753131Ab1KHOfg (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 8 Nov 2011 09:35:36 -0500
Received: by eye27 with SMTP id 27so395520eye.19
        for <linux-wireless@vger.kernel.org>; Tue, 08 Nov 2011 06:35:34 -0800 (PST)
From: Arik Nemtsov <arik@wizery.com>
To: <linux-wireless@vger.kernel.org>
Cc: Johannes Berg <johannes@sipsolutions.net>,
	Arik Nemtsov <arik@wizery.com>
Subject: [PATCH v3 1/3] nl80211: Add probe response offload attribute
Date: Tue,  8 Nov 2011 16:35:26 +0200
Message-Id: <1320762928-6782-1-git-send-email-arik@wizery.com> (sfid-20111108_153540_002001_937FDFCA)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Notify user-space about probe-response offloading support in the driver.

A wiphy flag is used to indicate support and a bitmap of protocols
determines which protocols are supported.

Signed-off-by: Guy Eilam <guy@wizery.com>
Signed-off-by: Arik Nemtsov <arik@wizery.com>
---
v1->3:
changed wording and added 80211u bit for supported offload protocols

include/linux/nl80211.h |   28 ++++++++++++++++++++++++++++
 include/net/cfg80211.h  |    5 +++++
 net/wireless/nl80211.c  |    5 +++++
 3 files changed, 38 insertions(+), 0 deletions(-)

diff --git a/include/linux/nl80211.h b/include/linux/nl80211.h
index 8049bf7..e74afc4 100644
--- a/include/linux/nl80211.h
+++ b/include/linux/nl80211.h
@@ -1109,6 +1109,11 @@ enum nl80211_commands {
  *	%NL80211_CMD_TDLS_MGMT. Otherwise %NL80211_CMD_TDLS_OPER should be
  *	used for asking the driver to perform a TDLS operation.
  *
+ * @NL80211_ATTR_PROBE_RESP_OFFLOAD_SUPPORT: Indicates support for probe
+ *	response offloading by the driver/firmware.
+ *	In addition this attribute holds a bitmap of the supported protocols
+ *	for offloading using &enum nl80211_probe_resp_offload_support_attr.
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
+ * enum nl80211_probe_resp_offload_support_attr - definition of optional
+ *	supported protocols for probe response offloading by the driver/FW.
+ *	to be used with the %NL80211_ATTR_PROBE_RESP_OFFLOAD_SUPPORT
+ *	attribute. Each enum value represents a bit in the bitmap of
+ *	supported protocols. Typically a subset of probe-requests belonging
+ *	to a supported protocol will be excluded from offload and uploaded
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
index 92cf1c2..7939495 100644
--- a/include/net/cfg80211.h
+++ b/include/net/cfg80211.h
@@ -1693,6 +1693,7 @@ enum wiphy_flags {
 	WIPHY_FLAG_AP_UAPSD			= BIT(14),
 	WIPHY_FLAG_SUPPORTS_TDLS		= BIT(15),
 	WIPHY_FLAG_TDLS_EXTERNAL_SETUP		= BIT(16),
+	WIPHY_FLAG_SUPPORT_PROBE_RESP_OFFLOAD	= BIT(17),
 };
 
 /**
@@ -1956,6 +1957,10 @@ struct wiphy {
 	u32 available_antennas_tx;
 	u32 available_antennas_rx;
 
+	/* bitmap of supported protocols for probe response offloading
+	 * see enum nl80211_probe_resp_offload_support_attr */
+	u32 probe_resp_offload;
+
 	/* If multiple wiphys are registered and you're handed e.g.
 	 * a regular netdev with assigned ieee80211_ptr, you won't
 	 * know whether it points to a wiphy your driver has registered
diff --git a/net/wireless/nl80211.c b/net/wireless/nl80211.c
index b3a476f..9800f8d 100644
--- a/net/wireless/nl80211.c
+++ b/net/wireless/nl80211.c
@@ -758,6 +758,11 @@ static int nl80211_send_wiphy(struct sk_buff *msg, u32 pid, u32 seq, int flags,
 	NLA_PUT_U32(msg, NL80211_ATTR_WIPHY_ANTENNA_AVAIL_RX,
 		    dev->wiphy.available_antennas_rx);
 
+	if (dev->wiphy.flags & WIPHY_FLAG_SUPPORT_PROBE_RESP_OFFLOAD)
+		NLA_PUT_U32(msg,
+			NL80211_ATTR_PROBE_RESP_OFFLOAD_SUPPORT,
+			dev->wiphy.probe_resp_offload);
+
 	if ((dev->wiphy.available_antennas_tx ||
 	     dev->wiphy.available_antennas_rx) && dev->ops->get_antenna) {
 		u32 tx_ant = 0, rx_ant = 0;
-- 
1.7.5.4

