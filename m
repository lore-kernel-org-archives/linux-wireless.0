Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from xc.sipsolutions.net ([83.246.72.84]:56060 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751873AbYJ1SgJ (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 28 Oct 2008 14:36:09 -0400
Subject: [PATCH] wireless: clean up sysfs code using %pM
From: Johannes Berg <johannes@sipsolutions.net>
To: "David S. Miller" <davem@davemloft.net>
Cc: John Linville <linville@tuxdriver.com>,
	linux-wireless <linux-wireless@vger.kernel.org>
Content-Type: text/plain
Date: Tue, 28 Oct 2008 14:00:54 +0100
Message-Id: <1225198854.3598.6.camel@johannes.berg> (sfid-20081028_193616_104085_C67FCEEF)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Remove converting the MAC address to a string by a direct byte
conversion and use %pM instead, since the code is now boilerplate
use a macro to define the show functions, and also use the shorter
__ATTR_RO macro to define the attributes.

Signed-off-by: Johannes Berg <johannes@sipsolutions.net>
---
John, just FYI, it needs to go through net-next-2.6 since it depends on
%pM. Won't cause conflicts either :)

 net/wireless/sysfs.c |   25 ++++++++++---------------
 1 file changed, 10 insertions(+), 15 deletions(-)

--- test-tree.orig/net/wireless/sysfs.c	2008-10-28 13:45:27.000000000 +0100
+++ test-tree/net/wireless/sysfs.c	2008-10-28 13:56:50.000000000 +0100
@@ -23,25 +23,20 @@ static inline struct cfg80211_registered
 	return container_of(dev, struct cfg80211_registered_device, wiphy.dev);
 }
 
-static ssize_t _show_index(struct device *dev, struct device_attribute *attr,
-			   char *buf)
-{
-	return sprintf(buf, "%d\n", dev_to_rdev(dev)->idx);
+#define SHOW_FMT(name, fmt, member)					\
+static ssize_t name ## _show(struct device *dev,			\
+			      struct device_attribute *attr,		\
+			      char *buf)				\
+{									\
+	return sprintf(buf, fmt "\n", dev_to_rdev(dev)->member);	\
 }
 
-static ssize_t _show_permaddr(struct device *dev,
-			      struct device_attribute *attr,
-			      char *buf)
-{
-	unsigned char *addr = dev_to_rdev(dev)->wiphy.perm_addr;
-
-	return sprintf(buf, "%.2x:%.2x:%.2x:%.2x:%.2x:%.2x\n",
-		       addr[0], addr[1], addr[2], addr[3], addr[4], addr[5]);
-}
+SHOW_FMT(index, "%d", idx);
+SHOW_FMT(macaddress, "%pM", wiphy.perm_addr);
 
 static struct device_attribute ieee80211_dev_attrs[] = {
-	__ATTR(index, S_IRUGO, _show_index, NULL),
-	__ATTR(macaddress, S_IRUGO, _show_permaddr, NULL),
+	__ATTR_RO(index),
+	__ATTR_RO(macaddress),
 	{}
 };
 


