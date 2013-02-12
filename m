Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:47342 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759317Ab3BLOB3 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 12 Feb 2013 09:01:29 -0500
From: Johannes Berg <johannes@sipsolutions.net>
To: linux-wireless@vger.kernel.org
Cc: Johannes Berg <johannes.berg@intel.com>
Subject: [PATCH 1/2] cfg80211: advertise extended capabilities to userspace
Date: Tue, 12 Feb 2013 15:01:21 +0100
Message-Id: <1360677682-3694-1-git-send-email-johannes@sipsolutions.net> (sfid-20130212_150133_849592_60D3E9ED)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Johannes Berg <johannes.berg@intel.com>

In many cases, userspace may need to know which of the
802.11 extended capabilities ("Extended Capabilities
element") are implemented in the driver or device, to
include them e.g. in beacons, assoc request/response
or other frames. Add a new nl80211 attribute to hold
the extended capabilities bitmap for this.

Signed-off-by: Johannes Berg <johannes.berg@intel.com>
---
 include/net/cfg80211.h       | 11 +++++++++++
 include/uapi/linux/nl80211.h |  9 +++++++++
 net/wireless/nl80211.c       |  9 +++++++++
 3 files changed, 29 insertions(+)

diff --git a/include/net/cfg80211.h b/include/net/cfg80211.h
index bc670b2..a8e30f5 100644
--- a/include/net/cfg80211.h
+++ b/include/net/cfg80211.h
@@ -2463,6 +2463,14 @@ struct wiphy_wowlan_support {
  *
  * @max_acl_mac_addrs: Maximum number of MAC addresses that the device
  *	supports for ACL.
+ *
+ * @extended_capabilities: extended capabilities supported by the driver,
+ *	additional capabilities might be supported by userspace; these are
+ *	the 802.11 extended capabilities ("Extended Capabilities element")
+ *	and are in the same format as in the information element. See
+ *	802.11-2012 8.4.2.29 for the defined fields.
+ * @extended_capabilities_mask: mask of the valid values
+ * @extended_capabilities_len: length of the extended capabilities
  */
 struct wiphy {
 	/* assign these fields before you register the wiphy */
@@ -2529,6 +2537,9 @@ struct wiphy {
 	 */
 	u32 probe_resp_offload;
 
+	const u8 *extended_capabilities, *extended_capabilities_mask;
+	u8 extended_capabilities_len;
+
 	/* If multiple wiphys are registered and you're handed e.g.
 	 * a regular netdev with assigned ieee80211_ptr, you won't
 	 * know whether it points to a wiphy your driver has registered
diff --git a/include/uapi/linux/nl80211.h b/include/uapi/linux/nl80211.h
index 641984f..91b1e89 100644
--- a/include/uapi/linux/nl80211.h
+++ b/include/uapi/linux/nl80211.h
@@ -1342,6 +1342,12 @@ enum nl80211_commands {
  *	number of MAC addresses that a device can support for MAC
  *	ACL.
  *
+ * @NL80211_ATTR_EXT_CAPA: 802.11 extended capabilities that the kernel driver
+ *	has and handles. The format is the same as the IE contents. See
+ *	802.11-2012 8.4.2.29 for more information.
+ * @NL80211_ATTR_EXT_CAPA_MASK: Extended capabilities that the kernel driver
+ *	has set in the %NL80211_ATTR_EXT_CAPA value, for multibit fields.
+ *
  * @NL80211_ATTR_MAX: highest attribute number currently defined
  * @__NL80211_ATTR_AFTER_LAST: internal use
  */
@@ -1620,6 +1626,9 @@ enum nl80211_attrs {
 
 	NL80211_ATTR_MAC_ACL_MAX,
 
+	NL80211_ATTR_EXT_CAPA,
+	NL80211_ATTR_EXT_CAPA_MASK,
+
 	/* add attributes here, update the policy in nl80211.c */
 
 	__NL80211_ATTR_AFTER_LAST,
diff --git a/net/wireless/nl80211.c b/net/wireless/nl80211.c
index b19c822..1908b70 100644
--- a/net/wireless/nl80211.c
+++ b/net/wireless/nl80211.c
@@ -1354,6 +1354,15 @@ static int nl80211_send_wiphy(struct sk_buff *msg, u32 portid, u32 seq, int flag
 			dev->wiphy.max_acl_mac_addrs))
 		goto nla_put_failure;
 
+	if (dev->wiphy.extended_capabilities &&
+	    (nla_put(msg, NL80211_ATTR_EXT_CAPA,
+		     dev->wiphy.extended_capabilities_len,
+		     dev->wiphy.extended_capabilities) ||
+	     nla_put(msg, NL80211_ATTR_EXT_CAPA_MASK,
+		     dev->wiphy.extended_capabilities_len,
+		     dev->wiphy.extended_capabilities_mask)))
+		goto nla_put_failure;
+
 	return genlmsg_end(msg, hdr);
 
  nla_put_failure:
-- 
1.8.0

