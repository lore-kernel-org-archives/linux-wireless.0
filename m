Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([18.85.46.34]:33758 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752616AbZCJCHr (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 9 Mar 2009 22:07:47 -0400
From: "Luis R. Rodriguez" <lrodriguez@atheros.com>
To: linville@tuxdriver.com, johannes@sipsolutions.net
Cc: linux-wireless@vger.kernel.org,
	"Luis R. Rodriguez" <lrodriguez@atheros.com>
Subject: [PATCH 3/3] cfg80211: add regulatory netlink multicast group
Date: Mon,  9 Mar 2009 22:07:42 -0400
Message-Id: <1236650862-17702-4-git-send-email-lrodriguez@atheros.com> (sfid-20090310_032927_872048_96757CEC)
In-Reply-To: <1236650862-17702-1-git-send-email-lrodriguez@atheros.com>
References: <1236650862-17702-1-git-send-email-lrodriguez@atheros.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This allows us to send to userspace "regulatory" events.
For now we just send an event when we change regulatory domains.
We also notify userspace when devices are using their own custom
world roaming regulatory domains.

Signed-off-by: Luis R. Rodriguez <lrodriguez@atheros.com>
---
 include/linux/nl80211.h |   48 ++++++++++++++++++++++++++++++++++++
 net/wireless/core.c     |   11 ++++++++
 net/wireless/nl80211.c  |   62 +++++++++++++++++++++++++++++++++++++++++++++++
 net/wireless/nl80211.h  |    5 ++++
 net/wireless/reg.c      |   13 +++++++++-
 5 files changed, 138 insertions(+), 1 deletions(-)

diff --git a/include/linux/nl80211.h b/include/linux/nl80211.h
index 98343c9..9118460 100644
--- a/include/linux/nl80211.h
+++ b/include/linux/nl80211.h
@@ -150,6 +150,17 @@
  * @NL80211_CMD_SCAN_ABORTED: scan was aborted, for unspecified reasons,
  *	partial scan results may be available
  *
+ * @NL80211_CMD_REG_CHANGE: indicates to userspace the regulatory domain
+ * 	has been changed and provides details of the request information
+ * 	that caused the change such as who initiated the regulatory request
+ * 	(%NL80211_ATTR_REG_INITIATOR), the wiphy_idx
+ * 	(%NL80211_ATTR_REG_ALPHA2) on which the request was made from if
+ * 	the initiator was %NL80211_REGDOM_SET_BY_COUNTRY_IE or
+ * 	%NL80211_REGDOM_SET_BY_DRIVER, the type of regulatory domain
+ * 	set (%NL80211_ATTR_REG_TYPE), if the type of regulatory domain is
+ * 	%NL80211_REG_TYPE_COUNTRY the alpha2 to which we have moved on
+ * 	to (%NL80211_ATTR_REG_ALPHA2).
+ *
  * @NL80211_CMD_MAX: highest used command number
  * @__NL80211_CMD_AFTER_LAST: internal use
  */
@@ -204,6 +215,8 @@ enum nl80211_commands {
 	NL80211_CMD_NEW_SCAN_RESULTS,
 	NL80211_CMD_SCAN_ABORTED,
 
+	NL80211_CMD_REG_CHANGE,
+
 	/* add new commands above here */
 
 	/* used to define NL80211_CMD_MAX below */
@@ -218,6 +231,8 @@ enum nl80211_commands {
 #define NL80211_CMD_SET_BSS NL80211_CMD_SET_BSS
 #define NL80211_CMD_SET_MGMT_EXTRA_IE NL80211_CMD_SET_MGMT_EXTRA_IE
 
+#define NL80211_CMD_REG_CHANGE NL80211_CMD_REG_CHANGE
+
 /**
  * enum nl80211_attrs - nl80211 netlink attributes
  *
@@ -329,6 +344,11 @@ enum nl80211_commands {
  *	messages carried the same generation number)
  * @NL80211_ATTR_BSS: scan result BSS
  *
+ * @NL80211_ATTR_REG_INITIATOR: indicates who requested the regulatory domain
+ * 	currently in effect. This could be any of the %NL80211_REGDOM_SET_BY_*
+ * @NL80211_ATTR_REG_TYPE: indicates the type of the regulatory domain currently
+ * 	set. This can be one of the nl80211_reg_type (%NL80211_REGDOM_TYPE_*)
+ *
  * @NL80211_ATTR_MAX: highest attribute number currently defined
  * @__NL80211_ATTR_AFTER_LAST: internal use
  */
@@ -403,6 +423,9 @@ enum nl80211_attrs {
 	NL80211_ATTR_SCAN_GENERATION,
 	NL80211_ATTR_BSS,
 
+	NL80211_ATTR_REG_INITIATOR,
+	NL80211_ATTR_REG_TYPE,
+
 	/* add attributes here, update the policy in nl80211.c */
 
 	__NL80211_ATTR_AFTER_LAST,
@@ -420,6 +443,8 @@ enum nl80211_attrs {
 #define NL80211_ATTR_WIPHY_CHANNEL_TYPE NL80211_ATTR_WIPHY_CHANNEL_TYPE
 #define NL80211_ATTR_MGMT_SUBTYPE NL80211_ATTR_MGMT_SUBTYPE
 #define NL80211_ATTR_IE NL80211_ATTR_IE
+#define NL80211_ATTR_REG_INITIATOR NL80211_ATTR_REG_INITIATOR
+#define NL80211_ATTR_REG_TYPE NL80211_ATTR_REG_TYPE
 
 #define NL80211_MAX_SUPP_RATES			32
 #define NL80211_MAX_SUPP_REG_RULES		32
@@ -695,6 +720,29 @@ enum nl80211_reg_initiator {
 };
 
 /**
+ * enum nl80211_reg_type - specifies the type of regulatory domain
+ * @NL80211_REGDOM_TYPE_COUNTRY: the regulatory domain set is one that pertains
+ *	to a specific country. When this is set you can count on the
+ *	ISO / IEC 3166 alpha2 country code being valid.
+ * @NL80211_REGDOM_TYPE_WORLD: the regulatory set domain is the world regulatory
+ * 	domain.
+ * @NL80211_REGDOM_TYPE_CUSTOM_WORLD: the regulatory domain set is a custom
+ * 	driver specific world regulatory domain. These do not apply system-wide
+ * 	and are only applicable to the individual devices which have requested
+ * 	them to be applied.
+ * @NL80211_REGDOM_TYPE_INTERSECTION: the regulatory domain set is the product
+ *	of an intersection between two regulatory domains -- the previously
+ *	set regulatory domain on the system and the last accepted regulatory
+ *	domain request to be processed.
+ */
+enum nl80211_reg_type {
+	NL80211_REGDOM_TYPE_COUNTRY,
+	NL80211_REGDOM_TYPE_WORLD,
+	NL80211_REGDOM_TYPE_CUSTOM_WORLD,
+	NL80211_REGDOM_TYPE_INTERSECTION,
+};
+
+/**
  * enum nl80211_reg_rule_attr - regulatory rule attributes
  * @NL80211_ATTR_REG_RULE_FLAGS: a set of flags which specify additional
  * 	considerations for a given frequency range. These are the
diff --git a/net/wireless/core.c b/net/wireless/core.c
index c939f5e..17fe390 100644
--- a/net/wireless/core.c
+++ b/net/wireless/core.c
@@ -365,6 +365,17 @@ int wiphy_register(struct wiphy *wiphy)
 	if (IS_ERR(drv->wiphy.debugfsdir))
 		drv->wiphy.debugfsdir = NULL;
 
+	if (wiphy->custom_regulatory) {
+		struct regulatory_request request;
+
+		request.wiphy_idx = get_wiphy_idx(wiphy);
+		request.initiator = NL80211_REGDOM_SET_BY_DRIVER;
+		request.alpha2[0] = '9';
+		request.alpha2[1] = '9';
+
+		nl80211_send_reg_change_event(&request);
+	}
+
 	res = 0;
 out_unlock:
 	mutex_unlock(&cfg80211_mutex);
diff --git a/net/wireless/nl80211.c b/net/wireless/nl80211.c
index 4827020..eab5f6a 100644
--- a/net/wireless/nl80211.c
+++ b/net/wireless/nl80211.c
@@ -2746,6 +2746,9 @@ static struct genl_multicast_group nl80211_config_mcgrp = {
 static struct genl_multicast_group nl80211_scan_mcgrp = {
 	.name = "scan",
 };
+static struct genl_multicast_group nl80211_regulatory_mcgrp = {
+	.name = "regulatory",
+};
 
 /* notification functions */
 
@@ -2825,6 +2828,61 @@ void nl80211_send_scan_aborted(struct cfg80211_registered_device *rdev,
 	genlmsg_multicast(msg, 0, nl80211_scan_mcgrp.id, GFP_KERNEL);
 }
 
+/*
+ * This can happen on global regulatory changes or device specific settings
+ * based on custom world regulatory domains.
+ */
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
+	/* Userspace can always count this one always being set */
+	NLA_PUT_U8(msg, NL80211_ATTR_REG_INITIATOR, request->initiator);
+
+	if (request->alpha2[0] == '0' && request->alpha2[1] == '0')
+		NLA_PUT_U8(msg, NL80211_ATTR_REG_TYPE,
+			   NL80211_REGDOM_TYPE_WORLD);
+	else if (request->alpha2[0] == '9' && request->alpha2[1] == '9')
+		NLA_PUT_U8(msg, NL80211_ATTR_REG_TYPE,
+			   NL80211_REGDOM_TYPE_CUSTOM_WORLD);
+	else if ((request->alpha2[0] == '9' && request->alpha2[1] == '8') ||
+		 request->intersect)
+		NLA_PUT_U8(msg, NL80211_ATTR_REG_TYPE,
+			   NL80211_REGDOM_TYPE_INTERSECTION);
+	else {
+		NLA_PUT_U8(msg, NL80211_ATTR_REG_TYPE,
+			   NL80211_REGDOM_TYPE_COUNTRY);
+		NLA_PUT_STRING(msg, NL80211_ATTR_REG_ALPHA2, request->alpha2);
+	}
+
+	if (wiphy_idx_valid(request->wiphy_idx))
+		NLA_PUT_U32(msg, NL80211_ATTR_WIPHY, request->wiphy_idx);
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
@@ -2849,6 +2907,10 @@ int nl80211_init(void)
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
index 68fde6d..eb8b8ed 100644
--- a/net/wireless/reg.c
+++ b/net/wireless/reg.c
@@ -41,6 +41,7 @@
 #include <net/cfg80211.h>
 #include "core.h"
 #include "reg.h"
+#include "nl80211.h"
 
 /* Receipt of information from last regulatory request */
 static struct regulatory_request *last_request;
@@ -1403,8 +1404,16 @@ new_request:
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
@@ -2084,6 +2093,8 @@ int set_regdom(const struct ieee80211_regdomain *rd)
 
 	print_regdomain(cfg80211_regdomain);
 
+	nl80211_send_reg_change_event(last_request);
+
 	return r;
 }
 
-- 
1.6.0.6

