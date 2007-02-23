Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga06.intel.com ([134.134.136.21]:26528 "EHLO
	orsmga101.jf.intel.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S933206AbXBWUpM (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 23 Feb 2007 15:45:12 -0500
Message-ID: <45DF518B.5060809@linux.intel.com>
Date: Fri, 23 Feb 2007 12:41:47 -0800
From: James Ketrenos <jketreno@linux.intel.com>
MIME-Version: 1.0
To: linux-wireless@vger.kernel.org,
	"John W. Linville" <linville@tuxdriver.com>,
	Johannes Berg <johannes@sipsolutions.net>
Subject: [PATCH] d80211: create net/wireless/Kconfig and make nl80211 optional
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Move the wireless Kconfig options into their own wireless/Kconfig and
add a CONFIG_CFG80211_NL80211 configuration option to allow nl80211
support to be optionally included (default =y)

This also adds Johannes' stub functions for nl80211_init and 
nl80211_exit when CONFIG_CFG80211_NL80211 is not defined.

Acked-by: Johannes Berg <johannes@sipsolutions.net>
Signed-off-by: James Ketrenos <jketreno@linux.intel.com>
---
  net/wireless/Kconfig  |   42 ++++++++++++++++++++++++++++++++++++++++++
  net/wireless/Makefile |    3 ++-
  3 files changed, 45 insertions(+), 17 deletions(-)
---
diff --git a/net/wireless/Kconfig b/net/wireless/Kconfig
new file mode 100644
index 0000000..89308d0
--- /dev/null
+++ b/net/wireless/Kconfig
@@ -0,0 +1,42 @@
+config CFG80211
+        tristate "Improved wireless configuration API"
+        select WIRELESS_EXT
+
+config CFG80211_WEXT_COMPAT
+        bool "cfg80211 Wireless Extensions compatibility"
+        depends CFG80211
+        default y
+        ---help---
+        This option allows using devices whose drivers have been
+        converted to use the new cfg80211 with wireless extensions,
+        providing WE-20 compatibility.
+	
+        Note that cfg80211's "native" interface is nl80211 using
+        generic netlink. The wireless extensions are being
+        deprecated, but userspace tools may still be using them.
+
+        NOTE: wireless extension support (WIRELESS_EXT) is currently a
+        built-in based on 'Wireless Extension' support (selected
+        when CFG80211 is enabled).
+
+        If unsure, say Y.
+
+config CFG80211_NL80211
+	tristate "nl80211 new netlink interface support"
+	depends CFG80211
+	default y
+	---help---
+        This option turns on the new netlink interface
+        (nl80211) support in cfg80211.
+	
+        If =n, drivers using d80211 will be configured via
+        wireless extension support provided by that subsystem.
+
+        If =m, the module will be called nl80211.ko
+
+        NOTE: wireless extension support (WIRELESS_EXT) is currently a
+        built-in based on 'Wireless Extension' support (selected
+        when CFG80211 is enabled).
+
+        If unsure, say Y.
+
diff --git a/net/wireless/Makefile b/net/wireless/Makefile
index c52c251..1f47511 100644
--- a/net/wireless/Makefile
+++ b/net/wireless/Makefile
@@ -1,6 +1,7 @@
  obj-$(CONFIG_CFG80211) += cfg80211.o

-cfg80211-y += core.o sysfs.o nl80211.o
+cfg80211-y += core.o sysfs.o
+cfg80211-$(CONFIG_NL80211) += nl80211.o
  cfg80211-$(CONFIG_CFG80211_WEXT_COMPAT) += wext-compat.o

  ifeq ($(CONFIG_CFG80211),m)
--- wireless-dev.orig/net/wireless/nl80211.h	2007-02-23
+++ wireless-dev/net/wireless/nl80211.h	2007-02-23
@@ -1,7 +1,17 @@
  #ifndef __NET_WIRELESS_NL80211_H
  #define __NET_WIRELESS_NL80211_H

+#ifdef CONFIG_CFG80211_NL80211
  extern int nl80211_init(void);
  extern void nl80211_exit(void);
+#else
+static inline int nl80211_init(void)
+{
+	return 0;
+}
+static inline void nl80211_exit(void)
+{
+}
+#endif /* CONFIG_CFG80211_NL80211 */

  #endif /* __NET_WIRELESS_NL80211_H */
