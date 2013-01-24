Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:54410 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752887Ab3AXKod (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 24 Jan 2013 05:44:33 -0500
From: Johannes Berg <johannes@sipsolutions.net>
To: linux-wireless@vger.kernel.org
Cc: backports@vger.kernel.org, Johannes Berg <johannes.berg@intel.com>
Subject: [PATCH v2] compat: backport nla_put_be{16,32,64}()
Date: Thu, 24 Jan 2013 11:44:56 +0100
Message-Id: <1359024296-17724-1-git-send-email-johannes@sipsolutions.net> (sfid-20130124_114436_656941_4B13767D)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Johannes Berg <johannes.berg@intel.com>

I intend to use these in nl80211.

Signed-off-by: Johannes Berg <johannes.berg@intel.com>
---
 include/linux/compat-3.5.h | 24 ++++++++++++++++++++++++
 1 file changed, 24 insertions(+)

diff --git a/include/linux/compat-3.5.h b/include/linux/compat-3.5.h
index 9cffead..1242720 100644
--- a/include/linux/compat-3.5.h
+++ b/include/linux/compat-3.5.h
@@ -10,6 +10,30 @@
 
 /*
  * This backports:
+ * commit 569a8fc38367dfafd87454f27ac646c8e6b54bca
+ * Author: David S. Miller <davem@davemloft.net>
+ * Date:   Thu Mar 29 23:18:53 2012 -0400
+ *
+ *     netlink: Add nla_put_be{16,32,64}() helpers.
+ */
+
+static inline int nla_put_be16(struct sk_buff *skb, int attrtype, __be16 value)
+{
+	return nla_put(skb, attrtype, sizeof(__be16), &value);
+}
+
+static inline int nla_put_be32(struct sk_buff *skb, int attrtype, __be32 value)
+{
+	return nla_put(skb, attrtype, sizeof(__be32), &value);
+}
+
+static inline int nla_put_be64(struct sk_buff *skb, int attrtype, __be64 value)
+{
+	return nla_put(skb, attrtype, sizeof(__be64), &value);
+}
+
+/*
+ * This backports:
  *
  * commit f56f821feb7b36223f309e0ec05986bb137ce418
  * Author: Daniel Vetter <daniel.vetter@ffwll.ch>
-- 
1.8.0

