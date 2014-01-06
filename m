Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from li674-96.members.linode.com ([212.71.239.96]:43897 "EHLO
	li674-96.members.linode.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751063AbaAFILy (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 6 Jan 2014 03:11:54 -0500
Date: Mon, 6 Jan 2014 10:11:51 +0200
From: Jouni Malinen <j@w1.fi>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: linux-wireless@vger.kernel.org
Subject: [RFC] cfg80211: Advertise maximum associated STAs in AP mode
Message-ID: <20140106081151.GA1613@w1.fi> (sfid-20140106_091158_593936_5F478FF0)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This allows drivers to advertise the maximum number of associated
stations they support in AP mode (including P2P GO). User space
applications can use this for cleaner way of handling the limit (e.g.,
hostapd rejecting IEEE 802.11 authentication without manual
configuration of the limit) or to figure out what type of use cases can
be executed with multiple devices before trying and failing.

Signed-off-by: Jouni Malinen <j@w1.fi>
---
 include/net/cfg80211.h       |    5 +++++
 include/uapi/linux/nl80211.h |    5 +++++
 net/wireless/nl80211.c       |    6 ++++++
 3 files changed, 16 insertions(+)

diff --git a/include/net/cfg80211.h b/include/net/cfg80211.h
index 3553c3a..efa7af5 100644
--- a/include/net/cfg80211.h
+++ b/include/net/cfg80211.h
@@ -2890,6 +2890,9 @@ struct wiphy_vendor_command {
  * @n_vendor_commands: number of vendor commands
  * @vendor_events: array of vendor events supported by the hardware
  * @n_vendor_events: number of vendor events
+ *
+ * @max_ap_assoc_sta: maximum number of associated stations supported in AP mode
+ *	(including P2P GO) or 0 to indicate no such limit is advertised
  */
 struct wiphy {
 	/* assign these fields before you register the wiphy */
@@ -3005,6 +3008,8 @@ struct wiphy {
 	const struct nl80211_vendor_cmd_info *vendor_events;
 	int n_vendor_commands, n_vendor_events;
 
+	u16 max_ap_assoc_sta;
+
 	char priv[0] __aligned(NETDEV_ALIGN);
 };
 
diff --git a/include/uapi/linux/nl80211.h b/include/uapi/linux/nl80211.h
index 86b8888..28d3194 100644
--- a/include/uapi/linux/nl80211.h
+++ b/include/uapi/linux/nl80211.h
@@ -1576,6 +1576,9 @@ enum nl80211_commands {
  *	scans). If not included, the driver will use its default value. u32
  *	attribute.
  *
+ * @NL80211_ATTR_MAX_AP_ASSOC_STA: Device attribute that indicates how many
+ *	associated stations are supported in AP mode (including P2P GO); u32.
+ *
  * @NL80211_ATTR_MAX: highest attribute number currently defined
  * @__NL80211_ATTR_AFTER_LAST: internal use
  */
@@ -1910,6 +1913,8 @@ enum nl80211_attrs {
 	NL80211_ATTR_MIN_CHANNEL_TIME,
 	NL80211_ATTR_MAX_CHANNEL_TIME,
 
+	NL80211_ATTR_MAX_AP_ASSOC_STA,
+
 	/* add attributes here, update the policy in nl80211.c */
 
 	__NL80211_ATTR_AFTER_LAST,
diff --git a/net/wireless/nl80211.c b/net/wireless/nl80211.c
index caf2829..2fbb84d 100644
--- a/net/wireless/nl80211.c
+++ b/net/wireless/nl80211.c
@@ -1592,6 +1592,12 @@ static int nl80211_send_wiphy(struct cfg80211_registered_device *dev,
 		    (nla_put_flag(msg, NL80211_ATTR_SUPPORT_5_MHZ) ||
 		     nla_put_flag(msg, NL80211_ATTR_SUPPORT_10_MHZ)))
 			goto nla_put_failure;
+
+		if (dev->wiphy.max_ap_assoc_sta &&
+		    nla_put_u32(msg, NL80211_ATTR_MAX_AP_ASSOC_STA,
+				dev->wiphy.max_ap_assoc_sta))
+			goto nla_put_failure;
+
 		state->split_start++;
 		break;
 	case 11:
-- 
1.7.9.5


-- 
Jouni Malinen                                            PGP id EFC895FA
