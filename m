Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-bw0-f46.google.com ([209.85.214.46]:51416 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751608Ab1JVTxJ (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 22 Oct 2011 15:53:09 -0400
Received: by bkbzt19 with SMTP id zt19so6310992bkb.19
        for <linux-wireless@vger.kernel.org>; Sat, 22 Oct 2011 12:53:08 -0700 (PDT)
From: Guy Eilam <guy@wizery.com>
To: johannes@sipsolutions.net
Cc: linux-wireless@vger.kernel.org
Subject: [PATCH v2 1/3] nl80211: Add probe response offload attribute
Date: Sat, 22 Oct 2011 21:51:21 +0200
Message-Id: <1319313081-28722-1-git-send-email-guy@wizery.com> (sfid-20111022_215328_201174_445167F3)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Notify the userspace of the probe response offloading
support by the driver.

Signed-off-by: Guy Eilam <guy@wizery.com>
---
v2:
use struct wiphy instead of a function pointer
this change made the previous second PATCH:
"Get the probe response offloading support from the driver" irrelevant
changed WPS to WSC

 include/linux/nl80211.h |   24 ++++++++++++++++++++++++
 include/net/cfg80211.h  |    5 +++++
 net/wireless/nl80211.c  |    5 +++++
 3 files changed, 34 insertions(+), 0 deletions(-)

diff --git a/include/linux/nl80211.h b/include/linux/nl80211.h
index 9d797f2..c1f0a3d 100644
--- a/include/linux/nl80211.h
+++ b/include/linux/nl80211.h
@@ -1109,6 +1109,11 @@ enum nl80211_commands {
  *	%NL80211_CMD_TDLS_MGMT. Otherwise %NL80211_CMD_TDLS_OPER should be
  *	used for asking the driver to perform a TDLS operation.
  *
+ * @NL80211_ATTR_PROBE_RESP_OFFLOAD_SUPPORT: Indicates the support
+ *	of probe response offloading by the driver/firmware.
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
@@ -2648,4 +2655,21 @@ enum nl80211_tdls_operation {
 	NL80211_TDLS_DISABLE_LINK,
 };
 
+/**
+ * enum nl80211_probe_resp_offload_support_attr - definition of optional
+ *	supported protocols for probe response offloading by the driver/firmware
+ *	to be used with the %NL80211_ATTR_PROBE_RESP_OFFLOAD_SUPPORT
+ *	attribute. Each enum value represents a bit in the bitmap of
+ *	supported protocols.
+ *
+ * @NL80211_PROBE_RESP_OFFLOAD_SUPPORT_WSC: Support for WSC ver. 1
+ * @NL80211_PROBE_RESP_OFFLOAD_SUPPORT_WSC2: Support for WSC ver. 2
+ * @NL80211_PROBE_RESP_OFFLOAD_SUPPORT_P2P: Support for P2P
+ */
+enum nl80211_probe_resp_offload_support_attr {
+	NL80211_PROBE_RESP_OFFLOAD_SUPPORT_WSC =	1<<0,
+	NL80211_PROBE_RESP_OFFLOAD_SUPPORT_WSC2 =	1<<1,
+	NL80211_PROBE_RESP_OFFLOAD_SUPPORT_P2P =	1<<2,
+};
+
 #endif /* __LINUX_NL80211_H */
diff --git a/include/net/cfg80211.h b/include/net/cfg80211.h
index 74f4f85..c9f69a6 100644
--- a/include/net/cfg80211.h
+++ b/include/net/cfg80211.h
@@ -1690,6 +1690,7 @@ enum wiphy_flags {
 	WIPHY_FLAG_AP_UAPSD			= BIT(14),
 	WIPHY_FLAG_SUPPORTS_TDLS		= BIT(15),
 	WIPHY_FLAG_TDLS_EXTERNAL_SETUP		= BIT(16),
+	WIPHY_FLAG_SUPPORT_PROBE_RESP_OFFLOAD	= BIT(17),
 };
 
 /**
@@ -1953,6 +1954,10 @@ struct wiphy {
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
index edf655a..71d36ed 100644
--- a/net/wireless/nl80211.c
+++ b/net/wireless/nl80211.c
@@ -759,6 +759,11 @@ static int nl80211_send_wiphy(struct sk_buff *msg, u32 pid, u32 seq, int flags,
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
1.7.4.1

