Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([18.85.46.34]:34762 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754881AbZBZXXm (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 26 Feb 2009 18:23:42 -0500
From: "Luis R. Rodriguez" <lrodriguez@atheros.com>
To: linville@tuxdriver.com, johannes@sipsolutions.net
Cc: linux-wireless@vger.kernel.org, mb@bu3sch.de,
	"Luis R. Rodriguez" <lrodriguez@atheros.com>
Subject: [PATCH v2 3/3] cfg80211: add regulatory netlink multicast group
Date: Thu, 26 Feb 2009 18:23:35 -0500
Message-Id: <1235690615-12109-4-git-send-email-lrodriguez@atheros.com> (sfid-20090227_002355_052223_12405318)
In-Reply-To: <1235690615-12109-1-git-send-email-lrodriguez@atheros.com>
References: <1235690615-12109-1-git-send-email-lrodriguez@atheros.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This allows us to send to userspace "regulatory" events.
For now we just send an event when we change regulatory domains.

Signed-off-by: Luis R. Rodriguez <lrodriguez@atheros.com>
---
 include/linux/nl80211.h |   26 ++++++++++++++++++++++++++
 net/wireless/nl80211.c  |   46 ++++++++++++++++++++++++++++++++++++++++++++++
 net/wireless/nl80211.h  |    5 +++++
 net/wireless/reg.c      |   13 ++++++++++++-
 4 files changed, 89 insertions(+), 1 deletions(-)

diff --git a/include/linux/nl80211.h b/include/linux/nl80211.h
index c0fd432..b4b65ad 100644
--- a/include/linux/nl80211.h
+++ b/include/linux/nl80211.h
@@ -150,6 +150,16 @@
  * @NL80211_CMD_SCAN_ABORTED: scan was aborted, for unspecified reasons,
  *	partial scan results may be available
  *
+ * @NL80211_CMD_REG_CHANGE: indicates to userspace the regulatory domain
+ * 	has been changed and provides details of the request information
+ * 	that caused the change such as who initiated the regulatory request
+ * 	(%NL80211_ATTR_REG_INITIATOR), the alpha2 to which we have moved on
+ * 	to (%NL80211_ATTR_REG_ALPHA2), whether or not the regulatory domain
+ * 	is the product of an intersection (%NL80211_ATTR_REG_INTERSECT) and
+ * 	the registered device's wiphy_idx (NL80211_ATTR_WIPHY) on which the
+ * 	request was made from (if the request came from a country IE or a
+ * 	driver regulatory hint).
+ *
  * @NL80211_CMD_MAX: highest used command number
  * @__NL80211_CMD_AFTER_LAST: internal use
  */
@@ -204,6 +214,8 @@ enum nl80211_commands {
 	NL80211_CMD_NEW_SCAN_RESULTS,
 	NL80211_CMD_SCAN_ABORTED,
 
+	NL80211_CMD_REG_CHANGE,
+
 	/* add new commands above here */
 
 	/* used to define NL80211_CMD_MAX below */
@@ -218,6 +230,8 @@ enum nl80211_commands {
 #define NL80211_CMD_SET_BSS NL80211_CMD_SET_BSS
 #define NL80211_CMD_SET_MGMT_EXTRA_IE NL80211_CMD_SET_MGMT_EXTRA_IE
 
+#define NL80211_CMD_REG_CHANGE NL80211_CMD_REG_CHANGE
+
 /**
  * enum nl80211_attrs - nl80211 netlink attributes
  *
@@ -329,6 +343,13 @@ enum nl80211_commands {
  *	messages carried the same generation number)
  * @NL80211_ATTR_BSS: scan result BSS
  *
+ * @NL80211_ATTR_REG_INITIATOR: indicates who requested the regulatory domain
+ * 	currently in effect. This could be any of the %NL80211_REGDOM_SET_BY_*
+ * @NL80211_ATTR_REG_INTERSECT: indicates whether or not the current regulatory
+ * 	domain is the product of an interesection between two regulatory
+ * 	domains. This is a boolean value so if this is set it means it was
+ * 	the product of an intersection.
+ *
  * @NL80211_ATTR_MAX: highest attribute number currently defined
  * @__NL80211_ATTR_AFTER_LAST: internal use
  */
@@ -403,6 +424,9 @@ enum nl80211_attrs {
 	NL80211_ATTR_SCAN_GENERATION,
 	NL80211_ATTR_BSS,
 
+	NL80211_ATTR_REG_INITIATOR,
+	NL80211_ATTR_REG_INTERSECT,
+
 	/* add attributes here, update the policy in nl80211.c */
 
 	__NL80211_ATTR_AFTER_LAST,
@@ -420,6 +444,8 @@ enum nl80211_attrs {
 #define NL80211_ATTR_WIPHY_CHANNEL_TYPE NL80211_ATTR_WIPHY_CHANNEL_TYPE
 #define NL80211_ATTR_MGMT_SUBTYPE NL80211_ATTR_MGMT_SUBTYPE
 #define NL80211_ATTR_IE NL80211_ATTR_IE
+#define NL80211_ATTR_REG_INITIATOR NL80211_ATTR_REG_INITIATOR
+#define NL80211_ATTR_REG_INTERSECT NL80211_ATTR_REG_INTERSECT
 
 #define NL80211_MAX_SUPP_RATES			32
 #define NL80211_MAX_SUPP_REG_RULES		32
diff --git a/net/wireless/nl80211.c b/net/wireless/nl80211.c
index 04ef828..f384fab 100644
--- a/net/wireless/nl80211.c
+++ b/net/wireless/nl80211.c
@@ -2705,6 +2705,9 @@ static struct genl_multicast_group nl80211_config_mcgrp = {
 static struct genl_multicast_group nl80211_scan_mcgrp = {
 	.name = "scan",
 };
+static struct genl_multicast_group nl80211_regulatory_mcgrp = {
+	.name = "regulatory",
+};
 
 /* notification functions */
 
@@ -2784,6 +2787,45 @@ void nl80211_send_scan_aborted(struct cfg80211_registered_device *rdev,
 	genlmsg_multicast(msg, 0, nl80211_scan_mcgrp.id, GFP_KERNEL);
 }
 
+void nl80211_send_reg_change_event(struct regulatory_request *request)
+{
+	struct sk_buff *msg;
+	void *hdr;
+
+	msg = nlmsg_new(NLMSG_GOODSIZE, GFP_KERNEL);
+	if (!msg)
+		return;
+
+	hdr = nl80211hdr_put(msg, 0, 0, 0, NL80211_CMD_REG_CHANGE);
+	if (!hdr) {
+		nlmsg_free(msg);
+		return;
+	}
+
+	/* Userspace can count on these two always being set */
+	NLA_PUT_STRING(msg, NL80211_ATTR_REG_ALPHA2, request->alpha2);
+	NLA_PUT_U8(msg, NL80211_ATTR_REG_INITIATOR, request->initiator);
+
+	if (wiphy_idx_valid(request->wiphy_idx))
+		NLA_PUT_U32(msg, NL80211_ATTR_WIPHY, request->wiphy_idx);
+
+	if (request->intersect)
+		NLA_PUT_U8(msg, NL80211_ATTR_REG_INTERSECT, 1);
+
+	if (genlmsg_end(msg, hdr) < 0) {
+		nlmsg_free(msg);
+		return;
+	}
+
+	genlmsg_multicast(msg, 0, nl80211_regulatory_mcgrp.id, GFP_KERNEL);
+
+	return;
+
+nla_put_failure:
+	genlmsg_cancel(msg, hdr);
+	nlmsg_free(msg);
+}
+
 /* initialisation/exit functions */
 
 int nl80211_init(void)
@@ -2808,6 +2850,10 @@ int nl80211_init(void)
 	if (err)
 		goto err_out;
 
+	err = genl_register_mc_group(&nl80211_fam, &nl80211_regulatory_mcgrp);
+	if (err)
+		goto err_out;
+
 	return 0;
  err_out:
 	genl_unregister_family(&nl80211_fam);
diff --git a/net/wireless/nl80211.h b/net/wireless/nl80211.h
index 69787b6..e65a3c3 100644
--- a/net/wireless/nl80211.h
+++ b/net/wireless/nl80211.h
@@ -11,6 +11,7 @@ extern void nl80211_send_scan_done(struct cfg80211_registered_device *rdev,
 				   struct net_device *netdev);
 extern void nl80211_send_scan_aborted(struct cfg80211_registered_device *rdev,
 				      struct net_device *netdev);
+extern void nl80211_send_reg_change_event(struct regulatory_request *request);
 #else
 static inline int nl80211_init(void)
 {
@@ -31,6 +32,10 @@ static inline void nl80211_send_scan_aborted(
 					struct cfg80211_registered_device *rdev,
 					struct net_device *netdev)
 {}
+static inline void
+nl80211_send_reg_change_event(struct regulatory_request *request)
+{
+}
 #endif /* CONFIG_NL80211 */
 
 #endif /* __NET_WIRELESS_NL80211_H */
diff --git a/net/wireless/reg.c b/net/wireless/reg.c
index 7341288..a9ce557 100644
--- a/net/wireless/reg.c
+++ b/net/wireless/reg.c
@@ -41,6 +41,7 @@
 #include <net/cfg80211.h>
 #include "core.h"
 #include "reg.h"
+#include "nl80211.h"
 
 /* Receipt of information from last regulatory request */
 static struct regulatory_request *last_request;
@@ -1391,8 +1392,16 @@ new_request:
 	pending_request = NULL;
 
 	/* When r == REG_INTERSECT we do need to call CRDA */
-	if (r < 0)
+	if (r < 0) {
+		/*
+		 * Since CRDA will not be called in this case as we already
+		 * have applied the requested regulatory domain before we just
+		 * inform userspace we have processed the request
+		 */
+		if (r == -EALREADY)
+			nl80211_send_reg_change_event(last_request);
 		return r;
+	}
 
 	/*
 	 * Note: When CONFIG_WIRELESS_OLD_REGULATORY is enabled
@@ -2072,6 +2081,8 @@ int set_regdom(const struct ieee80211_regdomain *rd)
 
 	print_regdomain(cfg80211_regdomain);
 
+	nl80211_send_reg_change_event(last_request);
+
 	return r;
 }
 
-- 
1.6.0.3

