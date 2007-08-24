Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from crystal.sipsolutions.net ([195.210.38.204]:45025 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758259AbXHXMcG (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 24 Aug 2007 08:32:06 -0400
Message-Id: <20070824122912.305409000@sipsolutions.net>
References: <20070824122705.549190000@sipsolutions.net>
Date: Fri, 24 Aug 2007 14:27:19 +0200
From: Johannes Berg <johannes@sipsolutions.net>
To: John Linville <linville@tuxdriver.com>
Cc: linux-wireless@vger.kernel.org
Subject: [PATCH 14/15] cfg80211: add key threshold stuff
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This adds all requisites for key threshold setting and notification
to cfg80211/nl80211.

Signed-off-by: Johannes Berg <johannes@sipsolutions.net>

---
 include/linux/nl80211.h |   10 +++++++++-
 include/net/cfg80211.h  |   17 +++++++++++++++++
 net/wireless/Makefile   |    2 +-
 net/wireless/nl80211.c  |   13 +++++++++++++
 net/wireless/nl80211.h  |    1 +
 net/wireless/notify.c   |   39 +++++++++++++++++++++++++++++++++++++++
 6 files changed, 80 insertions(+), 2 deletions(-)

--- wireless-dev.orig/include/linux/nl80211.h	2007-08-24 13:03:00.549420431 +0200
+++ wireless-dev/include/linux/nl80211.h	2007-08-24 13:03:03.319420431 +0200
@@ -48,6 +48,8 @@
  * @NL80211_SET_DEFAULT_KEY: set the default key index
  * @NL80211_CMD_DEL_KEY: delete a key identified by %NL80211_ATTR_KEY_IDX
  *	or %NL80211_ATTR_MAC.
+ * @NL80211_CMD_KEY_THRESHOLD_REACHED: notification from kernel that the
+ *	key threshold for a specific key has been reached.
  * @__NL80211_CMD_AFTER_LAST: internal use
  */
 enum nl80211_commands {
@@ -86,7 +88,7 @@ enum nl80211_commands {
 	NL80211_CMD_AP_UPDATE_STA,
 	NL80211_CMD_AP_GET_STA_INFO,
 	NL80211_CMD_AP_SET_RATESETS,
-	/* %input: ifindex, key_cipher, key_data, {key_idx, mac} */
+	/* %input: ifindex, key_cipher, key_data, {key_threshold,key_idx,mac}*/
 	NL80211_CMD_ADD_KEY,
 	/* %input: ifindex, key_idx|mac */
 	NL80211_CMD_DEL_KEY,
@@ -94,6 +96,7 @@ enum nl80211_commands {
 	NL80211_CMD_SET_DEFAULT_KEY,
 
 	/* add commands here */
+	NL80211_CMD_KEY_THRESHOLD_REACHED,
 
 	/* used to define NL80211_CMD_MAX below */
 	__NL80211_CMD_AFTER_LAST
@@ -141,6 +144,8 @@ enum nl80211_commands {
  * @NL80211_ATTR_MAC: MAC address (various uses)
  * @NL80211_ATTR_KEY_CIPHER: key cipher suite (u32, as defined by IEEE 802.11
  *	section 7.3.2.25.1, e.g. 0x000FAC04)
+ * @NL80211_ATTR_KEY_THRESHOLD: key threshold, the kernel will generate a key
+ *	threshold notification when a key has been used this many times
  * @__NL80211_ATTR_AFTER_LAST: internal use
  */
 enum nl80211_attrs {
@@ -192,6 +197,9 @@ enum nl80211_attrs {
 	NL80211_ATTR_BEACON_HEAD,
 	NL80211_ATTR_BEACON_TAIL,
 
+	/* %type: u32 */
+	NL80211_ATTR_KEY_THRESHOLD,
+
 	/* add attributes here, update the policy in nl80211.c */
 
 	/* used to define NL80211_ATTR_MAX below */
--- wireless-dev.orig/net/wireless/nl80211.c	2007-08-24 13:03:00.559420431 +0200
+++ wireless-dev/net/wireless/nl80211.c	2007-08-24 13:03:03.329420431 +0200
@@ -103,6 +103,7 @@ static struct nla_policy nl80211_policy[
 	[NL80211_ATTR_KEY_IDX] = { .type = NLA_U8 },
 	[NL80211_ATTR_MAC] = { .type = NLA_BINARY, .len = ETH_ALEN },
 	[NL80211_ATTR_KEY_CIPHER] = { .type = NLA_U32 },
+	[NL80211_ATTR_KEY_THRESHOLD] = { .type = NLA_U32 },
 };
 
 /* netlink command implementations */
@@ -761,6 +762,10 @@ static int nl80211_add_key(struct sk_buf
 	if (info->attrs[NL80211_ATTR_MAC])
 		params.macaddress = nla_data(info->attrs[NL80211_ATTR_MAC]);
 
+	if (info->attrs[NL80211_ATTR_KEY_THRESHOLD])
+		params.threshold =
+			nla_get_u32(info->attrs[NL80211_ATTR_KEY_THRESHOLD]);
+
 	if (params.key_idx > 3)
 		return -EINVAL;
 
@@ -1045,6 +1050,10 @@ static struct genl_multicast_group nl802
 	.name = "config",
 };
 
+struct genl_multicast_group nl80211_notify_mcgrp = {
+	.name = "notification",
+};
+
 /* notification functions */
 
 void nl80211_notify_dev_rename(struct cfg80211_registered_device *rdev)
@@ -1088,6 +1097,10 @@ int nl80211_init(void)
 	if (err)
 		goto err_out;
 
+	err = genl_register_mc_group(&nl80211_fam, &nl80211_notify_mcgrp);
+	if (err)
+		goto err_out;
+
 	return 0;
  err_out:
 	genl_unregister_family(&nl80211_fam);
--- wireless-dev.orig/include/net/cfg80211.h	2007-08-24 13:03:00.559420431 +0200
+++ wireless-dev/include/net/cfg80211.h	2007-08-24 13:03:03.329420431 +0200
@@ -73,12 +73,16 @@ struct association_params {
  * @key_idx: key index (0-3)
  * @macaddress: MAC address (for a pairwise key) or %NULL
  * @cipher: cipher suite selector
+ * @threshold: key threshold, notify userspace that a key has
+ *	been used this many times if possible by calling
+ *	the cfg80211_key_threshold_notify() function
  */
 struct key_params {
 	u8 *key;
 	u8 *macaddress;
 	int key_len;
 	u32 cipher;
+	u32 threshold;
 	u8 key_idx;
 };
 
@@ -193,6 +197,19 @@ struct cfg80211_ops {
 				   u8 key_idx);
 };
 
+/* notification functions */
+/**
+ * cfg80211_key_threshold_notify - notify about key threshold
+ *
+ * Use this function to notify userspace that the key threshold
+ * for a specific key has been reached.
+ *
+ * @dev: the netdevice the key is associated with
+ * @keyidx: the key index of the key
+ * @mac: the MAC address for a pairwise key or %NULL
+ */
+void cfg80211_key_threshold_notify(struct net_device *dev,
+				   u8 keyidx, u8 *mac);
 
 /* helper functions specific to nl80211 */
 extern void *nl80211hdr_put(struct sk_buff *skb, u32 pid,
--- /dev/null	1970-01-01 00:00:00.000000000 +0000
+++ wireless-dev/net/wireless/notify.c	2007-08-24 13:03:03.329420431 +0200
@@ -0,0 +1,39 @@
+/*
+ * This is the new netlink-based wireless notification interface.
+ *
+ * Copyright 2007 Johannes Berg <johannes@sipsolutions.net>
+ */
+
+#include <linux/nl80211.h>
+#include <linux/rtnetlink.h>
+#include <net/genetlink.h>
+#include <net/cfg80211.h>
+#include "core.h"
+#include "nl80211.h"
+
+void cfg80211_key_threshold_notify(struct net_device *dev,
+				   u8 keyidx, u8 *mac)
+{
+#ifdef CONFIG_NL80211
+	struct sk_buff *msg;
+	void *hdr;
+
+	hdr = nl80211msg_new(&msg, 0, 0, 0, NL80211_CMD_KEY_THRESHOLD_REACHED);
+	if (IS_ERR(hdr))
+		return;
+
+	NLA_PUT_U32(msg, NL80211_ATTR_IFINDEX, dev->ifindex);
+	if (mac)
+		NLA_PUT(msg, NL80211_ATTR_MAC, ETH_ALEN, mac);
+	NLA_PUT_U8(msg, NL80211_ATTR_KEY_IDX, keyidx);
+
+	genlmsg_end(msg, hdr);
+	genlmsg_multicast(msg, 0, nl80211_notify_mcgrp.id, GFP_KERNEL);
+
+	return;
+
+ nla_put_failure:
+	nlmsg_free(msg);
+#endif
+}
+EXPORT_SYMBOL(cfg80211_key_threshold_notify);
--- wireless-dev.orig/net/wireless/Makefile	2007-08-24 13:02:47.619420431 +0200
+++ wireless-dev/net/wireless/Makefile	2007-08-24 13:03:03.329420431 +0200
@@ -1,5 +1,5 @@
 obj-$(CONFIG_WIRELESS_EXT) += wext.o
 obj-$(CONFIG_CFG80211) += cfg80211.o
 
-cfg80211-y += core.o sysfs.o radiotap.o
+cfg80211-y += core.o sysfs.o radiotap.o notify.o
 cfg80211-$(CONFIG_NL80211) += nl80211.o
--- wireless-dev.orig/net/wireless/nl80211.h	2007-08-24 13:02:47.699420431 +0200
+++ wireless-dev/net/wireless/nl80211.h	2007-08-24 13:03:03.329420431 +0200
@@ -7,6 +7,7 @@
 extern int nl80211_init(void);
 extern void nl80211_exit(void);
 extern void nl80211_notify_dev_rename(struct cfg80211_registered_device *rdev);
+extern struct genl_multicast_group nl80211_notify_mcgrp;
 #else
 static inline int nl80211_init(void)
 {

-- 

