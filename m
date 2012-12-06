Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:54057 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932246Ab2LFVSN (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 6 Dec 2012 16:18:13 -0500
From: Johannes Berg <johannes@sipsolutions.net>
To: linux-wireless@vger.kernel.org
Cc: Johannes Berg <johannes.berg@intel.com>
Subject: [PATCH] compat: backport unsigned netlink attribute accessors
Date: Thu,  6 Dec 2012 22:18:33 +0100
Message-Id: <1354828714-7731-1-git-send-email-johannes@sipsolutions.net> (sfid-20121206_221816_778500_C85A19B6)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Johannes Berg <johannes.berg@intel.com>

These were added upstream in commit
4778e0be16c291ba6d9d55eeff3a6764fc84a071.

Signed-off-by: Johannes Berg <johannes.berg@intel.com>
---
 include/linux/compat-3.7.h | 85 ++++++++++++++++++++++++++++++++++++++++++++++
 1 file changed, 85 insertions(+)

diff --git a/include/linux/compat-3.7.h b/include/linux/compat-3.7.h
index 2d7b6dd..3e0625d 100644
--- a/include/linux/compat-3.7.h
+++ b/include/linux/compat-3.7.h
@@ -13,6 +13,7 @@
 #include <linux/user_namespace.h>
 #include <linux/file.h>
 #include <linux/seq_file.h>
+#include <net/netlink.h>
 
 #define VM_DONTDUMP    VM_NODUMP
 
@@ -89,6 +90,90 @@ static inline int pcie_capability_clear_dword(struct pci_dev *dev, int pos,
 
 #define PCI_EXP_LNKSTA2			50      /* Link Status 2 */
 
+/**
+ * nla_put_s8 - Add a s8 netlink attribute to a socket buffer
+ * @skb: socket buffer to add attribute to
+ * @attrtype: attribute type
+ * @value: numeric value
+ */
+static inline int nla_put_s8(struct sk_buff *skb, int attrtype, s8 value)
+{
+	return nla_put(skb, attrtype, sizeof(s8), &value);
+}
+
+/**
+ * nla_put_s16 - Add a s16 netlink attribute to a socket buffer
+ * @skb: socket buffer to add attribute to
+ * @attrtype: attribute type
+ * @value: numeric value
+ */
+static inline int nla_put_s16(struct sk_buff *skb, int attrtype, s16 value)
+{
+	return nla_put(skb, attrtype, sizeof(s16), &value);
+}
+
+/**
+ * nla_put_s32 - Add a s32 netlink attribute to a socket buffer
+ * @skb: socket buffer to add attribute to
+ * @attrtype: attribute type
+ * @value: numeric value
+ */
+static inline int nla_put_s32(struct sk_buff *skb, int attrtype, s32 value)
+{
+	return nla_put(skb, attrtype, sizeof(s32), &value);
+}
+
+/**
+ * nla_put_s64 - Add a s64 netlink attribute to a socket buffer
+ * @skb: socket buffer to add attribute to
+ * @attrtype: attribute type
+ * @value: numeric value
+ */
+static inline int nla_put_s64(struct sk_buff *skb, int attrtype, s64 value)
+{
+	return nla_put(skb, attrtype, sizeof(s64), &value);
+}
+
+/**
+ * nla_get_s32 - return payload of s32 attribute
+ * @nla: s32 netlink attribute
+ */
+static inline s32 nla_get_s32(const struct nlattr *nla)
+{
+	return *(s32 *) nla_data(nla);
+}
+
+/**
+ * nla_get_s16 - return payload of s16 attribute
+ * @nla: s16 netlink attribute
+ */
+static inline s16 nla_get_s16(const struct nlattr *nla)
+{
+	return *(s16 *) nla_data(nla);
+}
+
+/**
+ * nla_get_s8 - return payload of s8 attribute
+ * @nla: s8 netlink attribute
+ */
+static inline s8 nla_get_s8(const struct nlattr *nla)
+{
+	return *(s8 *) nla_data(nla);
+}
+
+/**
+ * nla_get_s64 - return payload of s64 attribute
+ * @nla: s64 netlink attribute
+ */
+static inline s64 nla_get_s64(const struct nlattr *nla)
+{
+	s64 tmp;
+
+	nla_memcpy(&tmp, nla, sizeof(tmp));
+
+	return tmp;
+}
+
 #else /* (LINUX_VERSION_CODE > KERNEL_VERSION(3,7,0)) */
 #define netlink_notify_portid(__notify) (__notify->portid)
 #define genl_info_snd_portid(__genl_info) (__genl_info->snd_portid)
-- 
1.8.0

