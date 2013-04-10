Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga14.intel.com ([143.182.124.37]:35867 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S965013Ab3DJLBj (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 10 Apr 2013 07:01:39 -0400
From: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
To: linux-wireless@vger.kernel.org,
	Stanislav Yakovlev <stas.yakovlev@gmail.com>,
	"John W. Linville" <linville@tuxdriver.com>
Cc: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Subject: [PATCH] ipw2x00: move to kstrto* functions
Date: Wed, 10 Apr 2013 14:01:18 +0300
Message-Id: <1365591678-18781-1-git-send-email-andriy.shevchenko@linux.intel.com> (sfid-20130410_130145_125437_42543DBE)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

There is better to use kstrto* instead of simple_strtoul. In this case it
applies a bit stricter rules for input as well.

Signed-off-by: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
---
 drivers/net/wireless/ipw2x00/ipw2100.c | 32 +++++++-------------------------
 1 file changed, 7 insertions(+), 25 deletions(-)

diff --git a/drivers/net/wireless/ipw2x00/ipw2100.c b/drivers/net/wireless/ipw2x00/ipw2100.c
index cb066f6..15920aa 100644
--- a/drivers/net/wireless/ipw2x00/ipw2100.c
+++ b/drivers/net/wireless/ipw2x00/ipw2100.c
@@ -4167,17 +4167,11 @@ static ssize_t show_debug_level(struct device_driver *d, char *buf)
 static ssize_t store_debug_level(struct device_driver *d,
 				 const char *buf, size_t count)
 {
-	char *p = (char *)buf;
 	u32 val;
+	int ret;
 
-	if (p[1] == 'x' || p[1] == 'X' || p[0] == 'x' || p[0] == 'X') {
-		p++;
-		if (p[0] == 'x' || p[0] == 'X')
-			p++;
-		val = simple_strtoul(p, &p, 16);
-	} else
-		val = simple_strtoul(p, &p, 10);
-	if (p == buf)
+	ret = kstrtou32(buf, 0, &val);
+	if (ret)
 		IPW_DEBUG_INFO(": %s is not in hex or decimal form.\n", buf);
 	else
 		ipw2100_debug_level = val;
@@ -4238,27 +4232,15 @@ static ssize_t store_scan_age(struct device *d, struct device_attribute *attr,
 {
 	struct ipw2100_priv *priv = dev_get_drvdata(d);
 	struct net_device *dev = priv->net_dev;
-	char buffer[] = "00000000";
-	unsigned long len =
-	    (sizeof(buffer) - 1) > count ? count : sizeof(buffer) - 1;
 	unsigned long val;
-	char *p = buffer;
+	int ret;
 
 	(void)dev;		/* kill unused-var warning for debug-only code */
 
 	IPW_DEBUG_INFO("enter\n");
 
-	strncpy(buffer, buf, len);
-	buffer[len] = 0;
-
-	if (p[1] == 'x' || p[1] == 'X' || p[0] == 'x' || p[0] == 'X') {
-		p++;
-		if (p[0] == 'x' || p[0] == 'X')
-			p++;
-		val = simple_strtoul(p, &p, 16);
-	} else
-		val = simple_strtoul(p, &p, 10);
-	if (p == buffer) {
+	ret = kstrtoul(buf, 0, &val);
+	if (ret) {
 		IPW_DEBUG_INFO("%s: user supplied invalid value.\n", dev->name);
 	} else {
 		priv->ieee->scan_age = val;
@@ -4266,7 +4248,7 @@ static ssize_t store_scan_age(struct device *d, struct device_attribute *attr,
 	}
 
 	IPW_DEBUG_INFO("exit\n");
-	return len;
+	return strnlen(buf, count);
 }
 
 static DEVICE_ATTR(scan_age, S_IWUSR | S_IRUGO, show_scan_age, store_scan_age);
-- 
1.8.2.rc0.22.gb3600c3

