Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wolverine01.qualcomm.com ([199.106.114.254]:13936 "EHLO
	wolverine01.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750838AbcEPFL3 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 16 May 2016 01:11:29 -0400
From: "Kanchanapally, Vidyullatha" <vkanchan@qti.qualcomm.com>
To: <johannes@sipsolutions.net>
CC: <linux-wireless@vger.kernel.org>, <jouni@qca.qualcomm.com>,
	<vkanchan@qti.qualcomm.com>, <amarnath@qca.qualcomm.com>,
	<usdutt@qti.qualcomm.com>
Subject: [PATCH v2] cfg80211: Advertise extended capabilities per interface type to userspace
Date: Mon, 16 May 2016 10:41:04 +0530
Message-ID: <1463375464-9025-1-git-send-email-vkanchan@qti.qualcomm.com> (sfid-20160516_071133_277414_5FC87E5C)
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

Signed-off-by: Vidyullatha Kanchanapally <vkanchan@qti.qualcomm.com>
Reviewed-by: Jouni Malinen <jouni@qca.qualcomm.com>
---
 v2:
 * Split NL80211_ATTR_IFTYPE_EXT_CAPA into multiple messages for each
   interface.
 * Add check to warn if the globally advertised capabilities are not
   advertised on all possible interface types.

 include/net/cfg80211.h       | 28 +++++++++++++++++++++++++++-
 include/uapi/linux/nl80211.h |  7 +++++++
 net/wireless/core.c          | 30 ++++++++++++++++++++++++++++++
 net/wireless/nl80211.c       | 43 ++++++++++++++++++++++++++++++++++++++++++-
 4 files changed, 106 insertions(+), 2 deletions(-)

diff --git a/include/net/cfg80211.h b/include/net/cfg80211.h
index 1e008cd..e6cafa0 100644
--- a/include/net/cfg80211.h
+++ b/include/net/cfg80211.h
@@ -3080,6 +3080,24 @@ struct wiphy_vendor_command {
 };
 
 /**
+ * struct wiphy_iftype_ext_capab - extended capabilities per interface type
+ * @iftype: interface type
+ * @extended_capabilities: extended capabilities supported by the driver,
+ *	additional capabilities might be supported by userspace; these are the
+ *	802.11 extended capabilities ("Extended Capabilities element") and are
+ *	in the same format as in the information element. See IEEE Std
+ *	802.11-2012 8.4.2.29 for the defined fields.
+ * @extended_capabilities_mask: mask of the valid values
+ * @extended_capabilities_len: length of the extended capabilities
+ */
+struct wiphy_iftype_ext_capab {
+	enum nl80211_iftype iftype;
+	const u8 *extended_capabilities;
+	const u8 *extended_capabilities_mask;
+	u8 extended_capabilities_len;
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
 
+	const struct wiphy_iftype_ext_capab *iftype_ext_capab;
+	unsigned int num_iftype_ext_capab;
+
 	/* If multiple wiphys are registered and you're handed e.g.
 	 * a regular netdev with assigned ieee80211_ptr, you won't
 	 * know whether it points to a wiphy your driver has registered
diff --git a/include/uapi/linux/nl80211.h b/include/uapi/linux/nl80211.h
index e23d786..a83c62a 100644
--- a/include/uapi/linux/nl80211.h
+++ b/include/uapi/linux/nl80211.h
@@ -1819,6 +1819,11 @@ enum nl80211_commands {
  *
  * @NL80211_ATTR_PAD: attribute used for padding for 64-bit alignment
  *
+ * @NL80211_ATTR_IFTYPE_EXT_CAPA: Nested attribute of the following attributes:
+ *	%NL80211_ATTR_IFTYPE, %NL80211_ATTR_EXT_CAPA,
+ *	%NL80211_ATTR_EXT_CAPA_MASK, to specify the extended capabilities per
+ *	interface type.
+ *
  * @NUM_NL80211_ATTR: total number of nl80211_attrs available
  * @NL80211_ATTR_MAX: highest attribute number currently defined
  * @__NL80211_ATTR_AFTER_LAST: internal use
@@ -2201,6 +2206,8 @@ enum nl80211_attrs {
 
 	NL80211_ATTR_PAD,
 
+	NL80211_ATTR_IFTYPE_EXT_CAPA,
+
 	/* add attributes here, update the policy in nl80211.c */
 
 	__NL80211_ATTR_AFTER_LAST,
diff --git a/net/wireless/core.c b/net/wireless/core.c
index 7f7b940..d493da9 100644
--- a/net/wireless/core.c
+++ b/net/wireless/core.c
@@ -747,6 +747,36 @@ int wiphy_register(struct wiphy *wiphy)
 		nl80211_send_reg_change_event(&request);
 	}
 
+	/* Check that nobody globally advertises any capabilities they do not
+	 * advertise on all possible interface types.
+	 */
+	if (wiphy->extended_capabilities_len &&
+	    wiphy->num_iftype_ext_capab &&
+	    wiphy->iftype_ext_capab) {
+		u8 supported_on_all, j;
+		const struct wiphy_iftype_ext_capab *capab;
+
+		capab = wiphy->iftype_ext_capab;
+		for (j = 0; j < wiphy->extended_capabilities_len; j++) {
+			if (capab[0].extended_capabilities_len > j)
+				supported_on_all =
+					capab[0].extended_capabilities[j];
+			else
+				supported_on_all = 0x00;
+			for (i = 1; i < wiphy->num_iftype_ext_capab; i++) {
+				if (j >= capab[i].extended_capabilities_len) {
+					supported_on_all = 0x00;
+					break;
+				}
+				supported_on_all &=
+					capab[i].extended_capabilities[j];
+			}
+			if (WARN_ON(wiphy->extended_capabilities[j] &
+				    ~supported_on_all))
+				break;
+		}
+	}
+
 	rdev->wiphy.registered = true;
 	rtnl_unlock();
 
diff --git a/net/wireless/nl80211.c b/net/wireless/nl80211.c
index 9bc84a2..fec4332 100644
--- a/net/wireless/nl80211.c
+++ b/net/wireless/nl80211.c
@@ -1264,7 +1264,7 @@ nl80211_send_mgmt_stypes(struct sk_buff *msg,
 struct nl80211_dump_wiphy_state {
 	s64 filter_wiphy;
 	long start;
-	long split_start, band_start, chan_start;
+	long split_start, band_start, chan_start, capa_start;
 	bool split;
 };
 
@@ -1761,6 +1761,47 @@ static int nl80211_send_wiphy(struct cfg80211_registered_device *rdev,
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
+			for (i = state->capa_start;
+			     i < rdev->wiphy.num_iftype_ext_capab; i++) {
+				const struct wiphy_iftype_ext_capab *capab;
+
+				capab = &rdev->wiphy.iftype_ext_capab[i];
+
+				nested_ext_capab = nla_nest_start(msg, i);
+				if (!nested_ext_capab ||
+				    nla_put_u32(msg, NL80211_ATTR_IFTYPE,
+						capab->iftype) ||
+				    nla_put(msg, NL80211_ATTR_EXT_CAPA,
+					    capab->extended_capabilities_len,
+					    capab->extended_capabilities) ||
+				    nla_put(msg, NL80211_ATTR_EXT_CAPA_MASK,
+					    capab->extended_capabilities_len,
+					    capab->extended_capabilities_mask))
+					goto nla_put_failure;
+
+				nla_nest_end(msg, nested_ext_capab);
+				if (state->split)
+					break;
+			}
+			nla_nest_end(msg, nested);
+			if (i < rdev->wiphy.num_iftype_ext_capab) {
+				state->capa_start = i + 1;
+				break;
+			}
+		}
+
 		/* done */
 		state->split_start = 0;
 		break;
-- 
1.8.2.1

