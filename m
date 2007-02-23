Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga06.intel.com ([134.134.136.21]:39285 "EHLO
	orsmga101.jf.intel.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S933236AbXBWVvD (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 23 Feb 2007 16:51:03 -0500
Message-ID: <45DF60F9.9090806@linux.intel.com>
Date: Fri, 23 Feb 2007 13:47:37 -0800
From: James Ketrenos <jketreno@linux.intel.com>
MIME-Version: 1.0
To: Johannes Berg <johannes@sipsolutions.net>
CC: linux-wireless@vger.kernel.org,
	"John W. Linville" <linville@tuxdriver.com>
Subject: Re: [PATCH] d80211: create net/wireless/Kconfig and make nl80211  optional
References: <45DF518B.5060809@linux.intel.com> <1172263955.3870.85.camel@johannes.berg>
In-Reply-To: <1172263955.3870.85.camel@johannes.berg>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Ok... this time for sure.  Maybe :)  At least its Friday.

James

----

[PATCH] create net/wireless/Kconfig and make nl80211 optional

Move the wireless Kconfig options into their own wireless/Kconfig and
add a CONFIG_NL80211 configuration option to allow nl80211
support to be optionally included (default =y)

This also implements stub functions for nl80211_init and nl80211_exit
when CONFIG_NL80211 is not defined.

Acked-by: Johannes Berg <johannes@sipsolutions.net>
Signed-off-by: James Ketrenos <jketreno@linux.intel.com>
---
  net/Kconfig            |   17 +----------------
  net/wireless/Kconfig   |   33 +++++++++++++++++++++++++++++++++
  net/wireless/Makefile  |    3 ++-
  net/wireless/nl80211.h |   10 ++++++++++
  4 files changed, 46 insertions(+), 17 deletions(-)
---
diff --git a/net/Kconfig b/net/Kconfig
index 3bff36e..6fa4d68 100644
--- a/net/Kconfig
+++ b/net/Kconfig
@@ -228,22 +228,7 @@ config WIRELESS_EXT
  config FIB_RULES
  	bool

-config CFG80211
-	tristate "Improved wireless configuration API"
-
-config CFG80211_WEXT_COMPAT
-	bool "cfg80211 Wireless Extensions compatibility"
-	depends CFG80211
-	default y
-	---help---
-	This option allows using devices whose drivers have been
-	converted to use the new cfg80211 with wireless extensions,
-	providing WE-20 compatibility. Note that cfg80211's "native"
-	interface is nl80211 using generic netlink. The wireless
-	extensions are being deprecated, but userspace tools may still
-	be using them.
-
-	If unsure, say Y.
+source "net/wireless/Kconfig"

  endif   # if NET
  endmenu # Networking
diff --git a/net/wireless/Kconfig b/net/wireless/Kconfig
new file mode 100644
index 0000000..7e83504
--- /dev/null
+++ b/net/wireless/Kconfig
@@ -0,0 +1,33 @@
+config CFG80211
+        tristate "Improved wireless configuration API"
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
+        If unsure, say Y.
+
+config NL80211
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
diff --git a/net/wireless/nl80211.h b/net/wireless/nl80211.h
index 0edc7a4..31524c7 100644
--- a/net/wireless/nl80211.h
+++ b/net/wireless/nl80211.h
@@ -1,7 +1,17 @@
  #ifndef __NET_WIRELESS_NL80211_H
  #define __NET_WIRELESS_NL80211_H

+#ifdef CONFIG_NL80211
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
+#endif /* CONFIG_NL80211 */

  #endif /* __NET_WIRELESS_NL80211_H */
