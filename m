Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mr1.bfh.ch ([147.87.250.50]:59384 "EHLO mr1.bfh.ch"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756251AbYEPOKP (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 16 May 2008 10:10:15 -0400
From: Michael Bernhard <michael.bernhard@bfh.ch>
To: mcgrof@winlab.rutgers.edu
Cc: linux-wireless@vger.kernel.org
Subject: Re: [PATCH 2/3 v2] compat-2.6: Add some missing functions and macros
Date: Fri, 16 May 2008 16:10:28 +0200
Message-Id: <12109470283444-git-send-email-michael.bernhard@bfh.ch> (sfid-20080516_161022_903305_95F117E7)
In-Reply-To: <12109457272730-git-send-email-michael.bernhard@bfh.ch>
References: <12109457272730-git-send-email-michael.bernhard@bfh.ch>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Signed-off-by: Michael Bernhard <michael.bernhard@bfh.ch>
---
I'm sorry. The folowing two lines slipped through:

> +/* Undef BIT() which is defined in include/linux/bitops.h */
> +#undef BIT

Here is a new patch.

 compat/compat.h         |   28 ++++++++++++++++++++++++++++
 scripts/admin-update.sh |   10 ++++++++++
 2 files changed, 38 insertions(+), 0 deletions(-)

diff --git a/compat/compat.h b/compat/compat.h
index 4ae26ac..0d940ab 100644
--- a/compat/compat.h
+++ b/compat/compat.h
@@ -30,6 +30,9 @@
 #include <linux/init.h>
 #include <linux/uaccess.h>
 
+#include <linux/unaligned/access_ok.h>
+#include <linux/unaligned/generic.h>
+
 #include <net/arp.h>
 #include <net/neighbour.h>
 
@@ -403,6 +406,31 @@ static inline void led_classdev_unregister_suspended(struct led_classdev *lcd)
 	led_classdev_unregister(lcd);
 }
 
+/* From include/linux/device.h */
+static inline const char *dev_name(struct device *dev)
+{
+	/* will be changed into kobject_name(&dev->kobj) in the near future */
+	return dev->bus_id;
+}
+
+/* From include/linux/kernel.h */
+/**
+ * clamp_val - return a value clamped to a given range using val's type
+ * @val: current value
+ * @min: minimum allowable value
+ * @max: maximum allowable value
+ *
+ * This macro does no typechecking and uses temporary variables of whatever
+ * type the input argument 'val' is.  This is useful when val is an unsigned
+ * type and min and max are literals that will otherwise be assigned a signed
+ * integer type.
+ */
+#define clamp_val(val, min, max) ({		\
+	typeof(val) __val = (val);		\
+	typeof(val) __min = (min);		\
+	typeof(val) __max = (max);		\
+	__val = __val < __min ? __min: __val;	\
+	__val > __max ? __max: __val; })
 
 #endif /* (LINUX_VERSION_CODE < KERNEL_VERSION(2,6,25)) */
 #endif /* LINUX_26_COMPAT_H */
diff --git a/scripts/admin-update.sh b/scripts/admin-update.sh
index 555c1e8..55ef211 100755
--- a/scripts/admin-update.sh
+++ b/scripts/admin-update.sh
@@ -23,6 +23,9 @@ INCLUDE_LINUX="$INCLUDE_LINUX pci_ids.h bitops.h eeprom_93cx6.h pm_qos_params.h"
 # For rndis_wext
 INCLUDE_LINUX_USB="usbnet.h rndis_host.h"
 
+# Unaligned access
+INCLUDE_LINUX_UNALIGNED="access_ok.h generic.h"
+
 # Stuff that should die or be merged, only ipw uses it
 INCLUDE_NET_OLD="ieee80211.h ieee80211_crypt.h"
 # The good new yummy stuff
@@ -73,6 +76,7 @@ DRIVER_FILES="$DRIVER_FILES rndis_wlan.c"
 DRIVER_FILES="$DRIVER_FILES at76_usb.h at76_usb.c"
 
 mkdir -p include/linux/ include/net/ include/linux/usb \
+	include/linux/unaligned \
 	net/mac80211/ net/wireless/ net/ieee80211/ \
 	drivers/ssb/ \
 	drivers/net/usb/ \
@@ -100,6 +104,12 @@ for i in $INCLUDE_LINUX_USB; do
 	cp $GIT_TREE/$DIR/$i $DIR/
 done
 
+DIR="include/linux/unaligned"
+for i in $INCLUDE_LINUX_UNALIGNED; do
+	echo "Copying $GIT_TREE/$DIR/$i"
+	cp $GIT_TREE/$DIR/$i $DIR/
+done
+
 # net/wireless and net/mac80211
 for i in $NET_DIRS; do
 	echo "Copying $GIT_TREE/net/$i/*.[ch]"
-- 
1.5.2.5

