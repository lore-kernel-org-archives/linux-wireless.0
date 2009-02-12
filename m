Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx2.redhat.com ([66.187.237.31]:39618 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757040AbZBLRea (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 12 Feb 2009 12:34:30 -0500
Subject: [PATCH] make net/ieee80211.h private to ipw2x00
From: Dan Williams <dcbw@redhat.com>
To: "John W. Linville" <linville@tuxdriver.com>
Cc: linux-wireless@vger.kernel.org,
	reinette chatre <reinette.chatre@intel.com>
In-Reply-To: <1234390630.14687.9.camel@localhost>
References: <1234390630.14687.9.camel@localhost>
Content-Type: text/plain
Date: Thu, 12 Feb 2009 12:32:55 -0500
Message-Id: <1234459975.15402.4.camel@localhost> (sfid-20090212_183435_045406_8149C75C)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Only ipw2x00 now uses it.  Reduce confusion.  Profit!

Signed-off-by: Dan Williams <dcbw@redhat.com>

---
Depends on "[PATCH] hostap: convert usage of net/ieee80211.h to linux/ieee80211.h" of course...

 drivers/net/wireless/ipw2x00/Kconfig               |    2 +-
 .../net/wireless/ipw2x00}/ieee80211.h              |    0
 drivers/net/wireless/ipw2x00/ipw2100.h             |    4 ++--
 drivers/net/wireless/ipw2x00/ipw2200.h             |    3 ++-
 drivers/net/wireless/ipw2x00/libipw_geo.c          |    2 +-
 drivers/net/wireless/ipw2x00/libipw_module.c       |    2 +-
 drivers/net/wireless/ipw2x00/libipw_rx.c           |    3 ++-
 drivers/net/wireless/ipw2x00/libipw_tx.c           |    2 +-
 drivers/net/wireless/ipw2x00/libipw_wx.c           |    3 ++-
 9 files changed, 12 insertions(+), 9 deletions(-)
 rename {include/net => drivers/net/wireless/ipw2x00}/ieee80211.h (100%)

diff --git a/drivers/net/wireless/ipw2x00/Kconfig b/drivers/net/wireless/ipw2x00/Kconfig
index 1d5dc3e..85cc799 100644
--- a/drivers/net/wireless/ipw2x00/Kconfig
+++ b/drivers/net/wireless/ipw2x00/Kconfig
@@ -186,7 +186,7 @@ config LIBIPW_DEBUG
 	  % echo 0x00000FFO > /proc/net/ieee80211/debug_level
 
 	  For a list of values you can assign to debug_level, you
-	  can look at the bit mask values in <net/ieee80211.h>
+	  can look at the bit mask values in ieee80211.h
 
 	  If you are not trying to debug or develop the libipw
 	  component, you most likely want to say N here.
diff --git a/include/net/ieee80211.h b/drivers/net/wireless/ipw2x00/ieee80211.h
similarity index 100%
rename from include/net/ieee80211.h
rename to drivers/net/wireless/ipw2x00/ieee80211.h
diff --git a/drivers/net/wireless/ipw2x00/ipw2100.h b/drivers/net/wireless/ipw2x00/ipw2100.h
index bbf1ddc..46b135d 100644
--- a/drivers/net/wireless/ipw2x00/ipw2100.h
+++ b/drivers/net/wireless/ipw2x00/ipw2100.h
@@ -39,8 +39,6 @@
 #include <linux/wireless.h>
 #include <net/iw_handler.h>	// new driver API
 
-#include <net/ieee80211.h>
-
 #ifdef CONFIG_IPW2100_MONITOR
 #include <net/ieee80211_radiotap.h>
 #endif
@@ -48,6 +46,8 @@
 #include <linux/workqueue.h>
 #include <linux/mutex.h>
 
+#include "ieee80211.h"
+
 struct ipw2100_priv;
 struct ipw2100_tx_packet;
 struct ipw2100_rx_packet;
diff --git a/drivers/net/wireless/ipw2x00/ipw2200.h b/drivers/net/wireless/ipw2x00/ipw2200.h
index 277b274..3e66c99 100644
--- a/drivers/net/wireless/ipw2x00/ipw2200.h
+++ b/drivers/net/wireless/ipw2x00/ipw2200.h
@@ -49,13 +49,14 @@
 #include <asm/io.h>
 
 #include <net/lib80211.h>
-#include <net/ieee80211.h>
 #include <net/ieee80211_radiotap.h>
 
 #define DRV_NAME	"ipw2200"
 
 #include <linux/workqueue.h>
 
+#include "ieee80211.h"
+
 /* Authentication  and Association States */
 enum connection_manager_assoc_states {
 	CMAS_INIT = 0,
diff --git a/drivers/net/wireless/ipw2x00/libipw_geo.c b/drivers/net/wireless/ipw2x00/libipw_geo.c
index 960ad13..9dfbb87 100644
--- a/drivers/net/wireless/ipw2x00/libipw_geo.c
+++ b/drivers/net/wireless/ipw2x00/libipw_geo.c
@@ -41,7 +41,7 @@
 #include <linux/etherdevice.h>
 #include <asm/uaccess.h>
 
-#include <net/ieee80211.h>
+#include "ieee80211.h"
 
 int ieee80211_is_valid_channel(struct ieee80211_device *ieee, u8 channel)
 {
diff --git a/drivers/net/wireless/ipw2x00/libipw_module.c b/drivers/net/wireless/ipw2x00/libipw_module.c
index a2f5616..0f233ab 100644
--- a/drivers/net/wireless/ipw2x00/libipw_module.c
+++ b/drivers/net/wireless/ipw2x00/libipw_module.c
@@ -50,7 +50,7 @@
 #include <net/net_namespace.h>
 #include <net/arp.h>
 
-#include <net/ieee80211.h>
+#include "ieee80211.h"
 
 #define DRV_DESCRIPTION "802.11 data/management/control stack"
 #define DRV_NAME        "ieee80211"
diff --git a/drivers/net/wireless/ipw2x00/libipw_rx.c b/drivers/net/wireless/ipw2x00/libipw_rx.c
index 9c67dfa..4865475 100644
--- a/drivers/net/wireless/ipw2x00/libipw_rx.c
+++ b/drivers/net/wireless/ipw2x00/libipw_rx.c
@@ -33,7 +33,8 @@
 #include <linux/ctype.h>
 
 #include <net/lib80211.h>
-#include <net/ieee80211.h>
+
+#include "ieee80211.h"
 
 static void ieee80211_monitor_rx(struct ieee80211_device *ieee,
 					struct sk_buff *skb,
diff --git a/drivers/net/wireless/ipw2x00/libipw_tx.c b/drivers/net/wireless/ipw2x00/libipw_tx.c
index f78f57e..a874e90 100644
--- a/drivers/net/wireless/ipw2x00/libipw_tx.c
+++ b/drivers/net/wireless/ipw2x00/libipw_tx.c
@@ -41,7 +41,7 @@
 #include <linux/etherdevice.h>
 #include <asm/uaccess.h>
 
-#include <net/ieee80211.h>
+#include "ieee80211.h"
 
 /*
 
diff --git a/drivers/net/wireless/ipw2x00/libipw_wx.c b/drivers/net/wireless/ipw2x00/libipw_wx.c
index 31ea3ab..dfbadb3 100644
--- a/drivers/net/wireless/ipw2x00/libipw_wx.c
+++ b/drivers/net/wireless/ipw2x00/libipw_wx.c
@@ -35,9 +35,10 @@
 #include <linux/jiffies.h>
 
 #include <net/lib80211.h>
-#include <net/ieee80211.h>
 #include <linux/wireless.h>
 
+#include "ieee80211.h"
+
 static const char *ieee80211_modes[] = {
 	"?", "a", "b", "ab", "g", "ag", "bg", "abg"
 };
-- 
1.6.1.3


