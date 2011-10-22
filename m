Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-bw0-f46.google.com ([209.85.214.46]:57106 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753527Ab1JVNNk (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 22 Oct 2011 09:13:40 -0400
Received: by bkbzt19 with SMTP id zt19so5986913bkb.19
        for <linux-wireless@vger.kernel.org>; Sat, 22 Oct 2011 06:13:39 -0700 (PDT)
From: Guy Eilam <guy@wizery.com>
To: johannes@sipsolutions.net
Cc: linux-wireless@vger.kernel.org
Subject: [PATCH 1/4] nl80211: Add probe response offload attribute
Date: Sat, 22 Oct 2011 15:11:49 +0200
Message-Id: <1319289112-21896-1-git-send-email-guy@wizery.com> (sfid-20111022_151344_264372_C668B096)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Notify the userspace of the probe response offloading
support by the driver.

Signed-off-by: Guy Eilam <guy@wizery.com>
---
 include/linux/nl80211.h |   24 ++++++++++++++++++++++++
 include/net/cfg80211.h  |    4 ++++
 net/wireless/nl80211.c  |   12 ++++++++++++
 3 files changed, 40 insertions(+), 0 deletions(-)

diff --git a/include/linux/nl80211.h b/include/linux/nl80211.h
index 9d797f2..a436f74 100644
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
+ * @NL80211_PROBE_RESP_OFFLOAD_SUPPORT_WPS: Support for WPS ver. 1
+ * @NL80211_PROBE_RESP_OFFLOAD_SUPPORT_WPS2: Support for WPS ver. 2
+ * @NL80211_PROBE_RESP_OFFLOAD_SUPPORT_P2P: Support for P2P
+ */
+enum nl80211_probe_resp_offload_support_attr {
+	NL80211_PROBE_RESP_OFFLOAD_SUPPORT_WPS,
+	NL80211_PROBE_RESP_OFFLOAD_SUPPORT_WPS2,
+	NL80211_PROBE_RESP_OFFLOAD_SUPPORT_P2P,
+};
+
 #endif /* __LINUX_NL80211_H */
diff --git a/include/net/cfg80211.h b/include/net/cfg80211.h
index 74f4f85..b5ddd62 100644
--- a/include/net/cfg80211.h
+++ b/include/net/cfg80211.h
@@ -1425,6 +1425,8 @@ struct cfg80211_gtk_rekey_data {
  *
  * @tdls_mgmt: Transmit a TDLS management frame.
  * @tdls_oper: Perform a high-level TDLS operation (e.g. TDLS link setup).
+ *
+ * @get_probe_resp_offload: Get probe response offload support from driver.
  */
 struct cfg80211_ops {
 	int	(*suspend)(struct wiphy *wiphy, struct cfg80211_wowlan *wow);
@@ -1614,6 +1616,8 @@ struct cfg80211_ops {
 			     u16 status_code, const u8 *buf, size_t len);
 	int	(*tdls_oper)(struct wiphy *wiphy, struct net_device *dev,
 			     u8 *peer, enum nl80211_tdls_operation oper);
+	int (*get_probe_resp_offload) (struct wiphy *wiphy,
+				u32 *supp_protocols);
 };
 
 /*
diff --git a/net/wireless/nl80211.c b/net/wireless/nl80211.c
index edf655a..ad90ec4 100644
--- a/net/wireless/nl80211.c
+++ b/net/wireless/nl80211.c
@@ -759,6 +759,18 @@ static int nl80211_send_wiphy(struct sk_buff *msg, u32 pid, u32 seq, int flags,
 	NLA_PUT_U32(msg, NL80211_ATTR_WIPHY_ANTENNA_AVAIL_RX,
 		    dev->wiphy.available_antennas_rx);
 
+	if (dev->ops->get_probe_resp_offload) {
+		u32 supp_protocols = 0;
+		int res;
+		res = dev->ops->get_probe_resp_offload(&dev->wiphy,
+							&supp_protocols);
+		if (!res) {
+			NLA_PUT_U32(msg,
+				NL80211_ATTR_PROBE_RESP_OFFLOAD_SUPPORT,
+				supp_protocols);
+		}
+	}
+
 	if ((dev->wiphy.available_antennas_tx ||
 	     dev->wiphy.available_antennas_rx) && dev->ops->get_antenna) {
 		u32 tx_ant = 0, rx_ant = 0;
-- 
1.7.4.1

