Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from server19320154104.serverpool.info ([193.201.54.104]:50138 "EHLO
	hauke-m.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S935201Ab0HQSbj (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 17 Aug 2010 14:31:39 -0400
From: Hauke Mehrtens <hauke@hauke-m.de>
To: lrodriguez@atheros.com
Cc: linux-wireless@vger.kernel.org, mcgrof@infradead.org,
	Hauke Mehrtens <hauke@hauke-m.de>
Subject: [PATCH 1/3] compat-wireless: deactivate namespace
Date: Tue, 17 Aug 2010 20:31:07 +0200
Message-Id: <1282069869-22300-2-git-send-email-hauke@hauke-m.de>
In-Reply-To: <1282069869-22300-1-git-send-email-hauke@hauke-m.de>
References: <1282069869-22300-1-git-send-email-hauke@hauke-m.de>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Namespace support was introduced with kernel 2.6.35 in struct class.
Deactivate it for older kernel.

Signed-off-by: Hauke Mehrtens <hauke@hauke-m.de>
---
 patches/32-remove-ns-type.patch |   28 ++++++++++++++++++++++++++++
 1 files changed, 28 insertions(+), 0 deletions(-)
 create mode 100644 patches/32-remove-ns-type.patch

diff --git a/patches/32-remove-ns-type.patch b/patches/32-remove-ns-type.patch
new file mode 100644
index 0000000..b35c927
--- /dev/null
+++ b/patches/32-remove-ns-type.patch
@@ -0,0 +1,28 @@
+--- a/net/wireless/sysfs.c
++++ b/net/wireless/sysfs.c
+@@ -110,12 +110,14 @@ static int wiphy_resume(struct device *d
+ 	return ret;
+ }
+ 
++#if (LINUX_VERSION_CODE >= KERNEL_VERSION(2,6,35))
+ static const void *wiphy_namespace(struct device *d)
+ {
+ 	struct wiphy *wiphy = container_of(d, struct wiphy, dev);
+ 
+ 	return wiphy_net(wiphy);
+ }
++#endif
+ 
+ struct class ieee80211_class = {
+ 	.name = "ieee80211",
+@@ -127,8 +129,10 @@ struct class ieee80211_class = {
+ #endif
+ 	.suspend = wiphy_suspend,
+ 	.resume = wiphy_resume,
++#if (LINUX_VERSION_CODE >= KERNEL_VERSION(2,6,35))
+ 	.ns_type = &net_ns_type_operations,
+ 	.namespace = wiphy_namespace,
++#endif
+ };
+ 
+ int wiphy_sysfs_init(void)
-- 
1.7.0.4

