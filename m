Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wolverine01.qualcomm.com ([199.106.114.254]:39113 "EHLO
	wolverine01.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750765AbcDOL20 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 15 Apr 2016 07:28:26 -0400
From: "Kanchanapally, Vidyullatha" <vkanchan@qti.qualcomm.com>
To: <johannes@sipsolutions.net>
CC: <linux-wireless@vger.kernel.org>, <jouni@qca.qualcomm.com>,
	<vkanchan@qti.qualcomm.com>, <amarnath@qca.qualcomm.com>,
	<usdutt@qti.qualcomm.com>
Subject: [PATCH] cfg80211: Advertise extended capabilities per interface type to userspace
Date: Fri, 15 Apr 2016 16:57:49 +0530
Message-ID: <1460719669-3421-1-git-send-email-vkanchan@qti.qualcomm.com> (sfid-20160415_132831_034243_615F9CDE)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: "Kanchanapally, Vidyullatha" <vkanchan@qti.qualcomm.com>

The driver extended capabilities may differ for different
interface types which the userspace needs to know (for
example the fine timing measurement initiator and responder
bits might differ for a station and AP). Add a new nl80211
attribute to provide extended capabilities per interface type
to userspace.

Reviewed-by: Jouni Malinen <jouni@qca.qualcomm.com>
Signed-off-by: Vidyullatha Kanchanapally <vkanchan@qti.qualcomm.com>
---
 include/net/cfg80211.h       | 28 +++++++++++++++++++++++++++-
 include/uapi/linux/nl80211.h |  7 +++++++
 net/wireless/nl80211.c       | 33 +++++++++++++++++++++++++++++++++
 3 files changed, 67 insertions(+), 1 deletion(-)

diff --git a/include/net/cfg80211.h b/include/net/cfg80211.h
index 1e008cd..c66a374 100644
--- a/include/net/cfg80211.h
+++ b/include/net/cfg80211.h
@@ -3080,6 +3080,24 @@ struct wiphy_vendor_command {
 };
 
 /**
+ * struct wiphy_iftype_ext_capab - extended capabilities per interface type
+ * @iftype: interface type
+ * @ext_capab: extended capabilities supported by the driver,
+ *	additional capabilities might be supported by userspace; these are
+ *	the 802.11 extended capabilities ("Extended Capabilities element")
+ *	and are in the same format as in the information element. See
+ *	IEEE Std 802.11-2012 8.4.2.29 for the defined fields.
+ * @ext_capab_mask: mask of the valid values
+ * @ext_capab_len: length of the extended capabilities
+ */
+struct wiphy_iftype_ext_capab {
+	enum nl80211_iftype iftype;
+	const u8 *ext_capab;
+	const u8 *ext_capab_mask;
+	u8 ext_capab_len;
+};
+
+/**
  * struct wiphy - wireless hardware description
  * @reg_notifier: the driver's regulatory notification callback,
  *	note that if your driver uses wiphy_apply_custom_regulatory()
@@ -3196,9 +3214,14 @@ struct wiphy_vendor_command {
  *	additional capabilities might be supported by userspace; these are
  *	the 802.11 extended capabilities ("Extended Capabilities element")
  *	and are in the same format as in the information element. See
- *	802.11-2012 8.4.2.29 for the defined fields.
+ *	802.11-2012 8.4.2.29 for the defined fields. These are the default
+ *	extended capabilities to be used if the capabilities are not specified
+ *	for a specific interface type in iftype_ext_capab.
  * @extended_capabilities_mask: mask of the valid values
  * @extended_capabilities_len: length of the extended capabilities
+ * @iftype_ext_capab: array of extended capabilities per interface type
+ * @num_iftype_ext_capab: number of interface types for which extended
+ *	capabilities are specified separately.
  * @coalesce: packet coalescing support information
  *
  * @vendor_commands: array of vendor commands supported by the hardware
@@ -3298,6 +3321,9 @@ struct wiphy {
 	const u8 *extended_capabilities, *extended_capabilities_mask;
 	u8 extended_capabilities_len;
 
+	struct wiphy_iftype_ext_capab *iftype_ext_capab;
+	unsigned int num_iftype_ext_capab;
+
 	/* If multiple wiphys are registered and you're handed e.g.
 	 * a regular netdev with assigned ieee80211_ptr, you won't
 	 * know whether it points to a wiphy your driver has registered
diff --git a/include/uapi/linux/nl80211.h b/include/uapi/linux/nl80211.h
index 9baa20b..8c3eae1 100644
--- a/include/uapi/linux/nl80211.h
+++ b/include/uapi/linux/nl80211.h
@@ -1817,6 +1817,11 @@ enum nl80211_commands {
  * @NL80211_ATTR_STA_SUPPORT_P2P_PS: whether P2P PS mechanism supported
  *	or not. u8, one of the values of &enum nl80211_sta_p2p_ps_status
  *
+ * @NL80211_ATTR_IFTYPE_EXT_CAPA: Nested attribute of the following attributes:
+ *	%NL80211_ATTR_IFTYPE, %NL80211_ATTR_EXT_CAPA,
+ *	%NL80211_ATTR_EXT_CAPA_MASK, to specify the extended capabilities per
+ *	interface type.
+ *
  * @NUM_NL80211_ATTR: total number of nl80211_attrs available
  * @NL80211_ATTR_MAX: highest attribute number currently defined
  * @__NL80211_ATTR_AFTER_LAST: internal use
@@ -2197,6 +2202,8 @@ enum nl80211_attrs {
 
 	NL80211_ATTR_STA_SUPPORT_P2P_PS,
 
+	NL80211_ATTR_IFTYPE_EXT_CAPA,
+
 	/* add attributes here, update the policy in nl80211.c */
 
 	__NL80211_ATTR_AFTER_LAST,
diff --git a/net/wireless/nl80211.c b/net/wireless/nl80211.c
index 3514450..94b9791 100644
--- a/net/wireless/nl80211.c
+++ b/net/wireless/nl80211.c
@@ -1761,6 +1761,39 @@ static int nl80211_send_wiphy(struct cfg80211_registered_device *rdev,
 			nla_nest_end(msg, nested);
 		}
 
+		state->split_start++;
+		break;
+	case 13:
+		if (rdev->wiphy.num_iftype_ext_capab &&
+		    rdev->wiphy.iftype_ext_capab) {
+			struct nlattr *nested_ext_capab, *nested;
+
+			nested = nla_nest_start(msg,
+						NL80211_ATTR_IFTYPE_EXT_CAPA);
+			if (!nested)
+				goto nla_put_failure;
+
+			for (i = 0; i < rdev->wiphy.num_iftype_ext_capab; i++) {
+				struct wiphy_iftype_ext_capab *capab;
+
+				capab = &rdev->wiphy.iftype_ext_capab[i];
+				nested_ext_capab = nla_nest_start(msg, i);
+				if (!nested_ext_capab ||
+				    nla_put_u32(msg, NL80211_ATTR_IFTYPE,
+						capab->iftype) ||
+				    nla_put(msg, NL80211_ATTR_EXT_CAPA,
+					    capab->ext_capab_len,
+					    capab->ext_capab) ||
+				    nla_put(msg, NL80211_ATTR_EXT_CAPA_MASK,
+					    capab->ext_capab_len,
+					    capab->ext_capab_mask))
+					goto nla_put_failure;
+
+				nla_nest_end(msg, nested_ext_capab);
+			}
+			nla_nest_end(msg, nested);
+		}
+
 		/* done */
 		state->split_start = 0;
 		break;
-- 
1.8.2.1

