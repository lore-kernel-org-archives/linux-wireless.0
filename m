Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([18.85.46.34]:46322 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752694AbZBZCkA (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 25 Feb 2009 21:40:00 -0500
From: "Luis R. Rodriguez" <lrodriguez@atheros.com>
To: linville@tuxdriver.com, johannes@sipsolutions.net
Cc: linux-wireless@vger.kernel.org, mb@bu3sch.de,
	"Luis R. Rodriguez" <lrodriguez@atheros.com>
Subject: [PATCH 3/3] cfg80211: add regulatory netlink multicast group
Date: Wed, 25 Feb 2009 21:39:49 -0500
Message-Id: <1235615989-1323-4-git-send-email-lrodriguez@atheros.com> (sfid-20090226_034006_935819_6735EF39)
In-Reply-To: <1235615989-1323-1-git-send-email-lrodriguez@atheros.com>
References: <1235615989-1323-1-git-send-email-lrodriguez@atheros.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This allows us to send to userspace "regulatory" events.
For now we just send an event when we change regulatory domains.

Signed-off-by: Luis R. Rodriguez <lrodriguez@atheros.com>
---
 include/linux/nl80211.h |   20 ++++++++++++++++++++
 net/wireless/nl80211.c  |   46 ++++++++++++++++++++++++++++++++++++++++++++++
 net/wireless/nl80211.h  |    5 +++++
 net/wireless/reg.c      |   13 ++++++++++++-
 4 files changed, 83 insertions(+), 1 deletions(-)

diff --git a/include/linux/nl80211.h b/include/linux/nl80211.h
index 989be40..6cf2048 100644
--- a/include/linux/nl80211.h
+++ b/include/linux/nl80211.h
@@ -166,6 +166,14 @@
  *	NL80211_ATTR_FRAME contains the management frame (including both the
  *	header and frame body, but not FCS).
  *
+ * @NL80211_CMD_REG_CHANGE: indicates to userspace the regulatory domain
+ * 	has been changed and provides details of the request information
+ * 	that caused the change such as who initiated the regulatory request,
+ * 	to what country, if a device requested the change which one was it,
+ * 	if a country IE initiated the request a checksum of that country IE
+ * 	along with its capability environment and also if the regulatory
+ * 	domain is the product of an intersection.
+ *
  * @NL80211_CMD_MAX: highest used command number
  * @__NL80211_CMD_AFTER_LAST: internal use
  */
@@ -223,6 +231,8 @@ enum nl80211_commands {
 	NL80211_CMD_RX_AUTH,
 	NL80211_CMD_RX_ASSOC,
 
+	NL80211_CMD_REG_CHANGE,
+
 	/* add new commands above here */
 
 	/* used to define NL80211_CMD_MAX below */
@@ -352,6 +362,13 @@ enum nl80211_commands {
  *	and body, but not FCS; used, e.g., with NL80211_CMD_RX_AUTH and
  *	NL80211_CMD_RX_ASSOC events
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
@@ -428,6 +445,9 @@ enum nl80211_attrs {
 
 	NL80211_ATTR_FRAME,
 
+	NL80211_ATTR_REG_INITIATOR,
+	NL80211_ATTR_REG_INTERSECT,
+
 	/* add attributes here, update the policy in nl80211.c */
 
 	__NL80211_ATTR_AFTER_LAST,
diff --git a/net/wireless/nl80211.c b/net/wireless/nl80211.c
index fcbe4b2..e4c15fd 100644
--- a/net/wireless/nl80211.c
+++ b/net/wireless/nl80211.c
@@ -2710,6 +2710,9 @@ static struct genl_multicast_group nl80211_scan_mcgrp = {
 static struct genl_multicast_group nl80211_mlme_mcgrp = {
 	.name = "mlme",
 };
+static struct genl_multicast_group nl80211_regulatory_mcgrp = {
+	.name = "regulatory",
+};
 
 /* notification functions */
 
@@ -2836,6 +2839,45 @@ void nl80211_send_rx_assoc(struct cfg80211_registered_device *rdev,
 	nl80211_send_mlme_event(rdev, netdev, skb, NL80211_CMD_RX_ASSOC);
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
@@ -2864,6 +2906,10 @@ int nl80211_init(void)
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
index 6179c2b..9073109 100644
--- a/net/wireless/nl80211.h
+++ b/net/wireless/nl80211.h
@@ -17,6 +17,7 @@ extern void nl80211_send_rx_auth(struct cfg80211_registered_device *rdev,
 extern void nl80211_send_rx_assoc(struct cfg80211_registered_device *rdev,
 				  struct net_device *netdev,
 				  struct sk_buff *skb);
+extern void nl80211_send_reg_change_event(struct regulatory_request *request);
 #else
 static inline int nl80211_init(void)
 {
@@ -47,6 +48,10 @@ nl80211_send_rx_assoc(struct cfg80211_registered_device *rdev,
 		      struct net_device *netdev, struct sk_buff *skb)
 {
 }
+static inline void
+nl80211_send_reg_change_event(struct regulatory_request *request)
+{
+}
 #endif /* CONFIG_NL80211 */
 
 #endif /* __NET_WIRELESS_NL80211_H */
diff --git a/net/wireless/reg.c b/net/wireless/reg.c
index c40e99e..b110ef4 100644
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

