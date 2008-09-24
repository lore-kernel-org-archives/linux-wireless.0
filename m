Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from charlotte.tuxdriver.com ([70.61.120.58]:49439 "EHLO
	smtp.tuxdriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754014AbYIXXEi (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 24 Sep 2008 19:04:38 -0400
From: "John W. Linville" <linville@tuxdriver.com>
To: linux-wireless@vger.kernel.org
Cc: "John W. Linville" <linville@tuxdriver.com>
Subject: [PATCH] wireless: consolidate on a single escape_essid implementation
Date: Wed, 24 Sep 2008 18:15:36 -0400
Message-Id: <1222294536-24367-1-git-send-email-linville@tuxdriver.com> (sfid-20080925_010455_582253_D66BE03B)
In-Reply-To: <>
References: <>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This is also an excuse to create the long rumored lib80211 module...

Signed-off-by: John W. Linville <linville@tuxdriver.com>
---
Wtf...

 drivers/net/wireless/Kconfig                |    1 +
 drivers/net/wireless/ipw2200.h              |    1 +
 drivers/net/wireless/iwlwifi/Kconfig        |    2 +
 drivers/net/wireless/iwlwifi/iwl-scan.c     |   53 +++---------------------
 drivers/net/wireless/iwlwifi/iwl3945-base.c |   48 ++--------------------
 drivers/net/wireless/libertas/assoc.c       |    2 +
 drivers/net/wireless/libertas/cmd.c         |    1 +
 drivers/net/wireless/libertas/debugfs.c     |    1 +
 drivers/net/wireless/libertas/decl.h        |    4 --
 drivers/net/wireless/libertas/main.c        |   27 ------------
 drivers/net/wireless/libertas/scan.c        |    3 +
 drivers/net/wireless/libertas/wext.c        |    1 +
 include/net/ieee80211.h                     |   20 ---------
 include/net/lib80211.h                      |   31 ++++++++++++++
 net/ieee80211/Kconfig                       |    1 +
 net/ieee80211/ieee80211_module.c            |   26 ------------
 net/ieee80211/ieee80211_rx.c                |    9 ++--
 net/wireless/Kconfig                        |   10 +++++
 net/wireless/Makefile                       |    1 +
 net/wireless/lib80211.c                     |   58 +++++++++++++++++++++++++++
 20 files changed, 128 insertions(+), 172 deletions(-)
 create mode 100644 include/net/lib80211.h
 create mode 100644 net/wireless/lib80211.c

diff --git a/drivers/net/wireless/Kconfig b/drivers/net/wireless/Kconfig
index 1edbdc2..6a81a03 100644
--- a/drivers/net/wireless/Kconfig
+++ b/drivers/net/wireless/Kconfig
@@ -271,6 +271,7 @@ config LIBERTAS
 	tristate "Marvell 8xxx Libertas WLAN driver support"
 	depends on WLAN_80211
 	select WIRELESS_EXT
+	select LIB80211
 	select FW_LOADER
 	---help---
 	  A library for Marvell Libertas 8xxx devices.
diff --git a/drivers/net/wireless/ipw2200.h b/drivers/net/wireless/ipw2200.h
index 0bad1ec..0a84d52 100644
--- a/drivers/net/wireless/ipw2200.h
+++ b/drivers/net/wireless/ipw2200.h
@@ -48,6 +48,7 @@
 #include <linux/jiffies.h>
 #include <asm/io.h>
 
+#include <net/lib80211.h>
 #include <net/ieee80211.h>
 #include <net/ieee80211_radiotap.h>
 
diff --git a/drivers/net/wireless/iwlwifi/Kconfig b/drivers/net/wireless/iwlwifi/Kconfig
index b0ac0ce..47bee0e 100644
--- a/drivers/net/wireless/iwlwifi/Kconfig
+++ b/drivers/net/wireless/iwlwifi/Kconfig
@@ -4,6 +4,7 @@ config IWLWIFI
 config IWLCORE
 	tristate "Intel Wireless Wifi Core"
 	depends on PCI && MAC80211 && WLAN_80211 && EXPERIMENTAL
+	select LIB80211
 	select IWLWIFI
 	select MAC80211_LEDS if IWLWIFI_LEDS
 	select LEDS_CLASS if IWLWIFI_LEDS
@@ -105,6 +106,7 @@ config IWL3945
 	tristate "Intel PRO/Wireless 3945ABG/BG Network Connection"
 	depends on PCI && MAC80211 && WLAN_80211 && EXPERIMENTAL
 	select FW_LOADER
+	select LIB80211
 	select IWLWIFI
 	select MAC80211_LEDS if IWL3945_LEDS
 	select LEDS_CLASS if IWL3945_LEDS
diff --git a/drivers/net/wireless/iwlwifi/iwl-scan.c b/drivers/net/wireless/iwlwifi/iwl-scan.c
index bf855c3..dd77eeb 100644
--- a/drivers/net/wireless/iwlwifi/iwl-scan.c
+++ b/drivers/net/wireless/iwlwifi/iwl-scan.c
@@ -25,8 +25,10 @@
  * Tomas Winkler <tomas.winkler@intel.com>
  * Intel Corporation, 5200 N.E. Elam Young Parkway, Hillsboro, OR 97124-6497
  *****************************************************************************/
-#include <net/mac80211.h>
+#include <linux/types.h>
 #include <linux/etherdevice.h>
+#include <net/lib80211.h>
+#include <net/mac80211.h>
 
 #include "iwl-eeprom.h"
 #include "iwl-dev.h"
@@ -69,49 +71,6 @@ static int scan_tx_ant[3] = {
 };
 
 
-
-static int iwl_is_empty_essid(const char *essid, int essid_len)
-{
-	/* Single white space is for Linksys APs */
-	if (essid_len == 1 && essid[0] == ' ')
-		return 1;
-
-	/* Otherwise, if the entire essid is 0, we assume it is hidden */
-	while (essid_len) {
-		essid_len--;
-		if (essid[essid_len] != '\0')
-			return 0;
-	}
-
-	return 1;
-}
-
-
-
-static const char *iwl_escape_essid(const char *essid, u8 essid_len)
-{
-	static char escaped[IW_ESSID_MAX_SIZE * 2 + 1];
-	const char *s = essid;
-	char *d = escaped;
-
-	if (iwl_is_empty_essid(essid, essid_len)) {
-		memcpy(escaped, "<hidden>", sizeof("<hidden>"));
-		return escaped;
-	}
-
-	essid_len = min(essid_len, (u8) IW_ESSID_MAX_SIZE);
-	while (essid_len--) {
-		if (*s == '\0') {
-			*d++ = '\\';
-			*d++ = '0';
-			s++;
-		} else
-			*d++ = *s++;
-	}
-	*d = '\0';
-	return escaped;
-}
-
 /**
  * iwl_scan_cancel - Cancel any currently executing HW scan
  *
@@ -796,8 +755,8 @@ static void iwl_bg_request_scan(struct work_struct *data)
 	/* We should add the ability for user to lock to PASSIVE ONLY */
 	if (priv->one_direct_scan) {
 		IWL_DEBUG_SCAN("Start direct scan for '%s'\n",
-				iwl_escape_essid(priv->direct_ssid,
-				priv->direct_ssid_len));
+				escape_essid(priv->direct_ssid,
+					     priv->direct_ssid_len));
 		scan->direct_scan[0].id = WLAN_EID_SSID;
 		scan->direct_scan[0].len = priv->direct_ssid_len;
 		memcpy(scan->direct_scan[0].ssid,
@@ -805,7 +764,7 @@ static void iwl_bg_request_scan(struct work_struct *data)
 		n_probes++;
 	} else if (!iwl_is_associated(priv) && priv->essid_len) {
 		IWL_DEBUG_SCAN("Start direct scan for '%s' (not associated)\n",
-				iwl_escape_essid(priv->essid, priv->essid_len));
+				escape_essid(priv->essid, priv->essid_len));
 		scan->direct_scan[0].id = WLAN_EID_SSID;
 		scan->direct_scan[0].len = priv->essid_len;
 		memcpy(scan->direct_scan[0].ssid, priv->essid, priv->essid_len);
diff --git a/drivers/net/wireless/iwlwifi/iwl3945-base.c b/drivers/net/wireless/iwlwifi/iwl3945-base.c
index d15a2c9..0dad24c 100644
--- a/drivers/net/wireless/iwlwifi/iwl3945-base.c
+++ b/drivers/net/wireless/iwlwifi/iwl3945-base.c
@@ -41,6 +41,7 @@
 #include <linux/if_arp.h>
 
 #include <net/ieee80211_radiotap.h>
+#include <net/lib80211.h>
 #include <net/mac80211.h>
 
 #include <asm/div64.h>
@@ -107,46 +108,6 @@ static const struct ieee80211_supported_band *iwl3945_get_band(
 	return priv->hw->wiphy->bands[band];
 }
 
-static int iwl3945_is_empty_essid(const char *essid, int essid_len)
-{
-	/* Single white space is for Linksys APs */
-	if (essid_len == 1 && essid[0] == ' ')
-		return 1;
-
-	/* Otherwise, if the entire essid is 0, we assume it is hidden */
-	while (essid_len) {
-		essid_len--;
-		if (essid[essid_len] != '\0')
-			return 0;
-	}
-
-	return 1;
-}
-
-static const char *iwl3945_escape_essid(const char *essid, u8 essid_len)
-{
-	static char escaped[IW_ESSID_MAX_SIZE * 2 + 1];
-	const char *s = essid;
-	char *d = escaped;
-
-	if (iwl3945_is_empty_essid(essid, essid_len)) {
-		memcpy(escaped, "<hidden>", sizeof("<hidden>"));
-		return escaped;
-	}
-
-	essid_len = min(essid_len, (u8) IW_ESSID_MAX_SIZE);
-	while (essid_len--) {
-		if (*s == '\0') {
-			*d++ = '\\';
-			*d++ = '0';
-			s++;
-		} else
-			*d++ = *s++;
-	}
-	*d = '\0';
-	return escaped;
-}
-
 /*************** DMA-QUEUE-GENERAL-FUNCTIONS  *****
  * DMA services
  *
@@ -6202,8 +6163,7 @@ static void iwl3945_bg_request_scan(struct work_struct *data)
 	if (priv->one_direct_scan) {
 		IWL_DEBUG_SCAN
 		    ("Kicking off one direct scan for '%s'\n",
-		     iwl3945_escape_essid(priv->direct_ssid,
-				      priv->direct_ssid_len));
+		     escape_essid(priv->direct_ssid, priv->direct_ssid_len));
 		scan->direct_scan[0].id = WLAN_EID_SSID;
 		scan->direct_scan[0].len = priv->direct_ssid_len;
 		memcpy(scan->direct_scan[0].ssid,
@@ -6212,7 +6172,7 @@ static void iwl3945_bg_request_scan(struct work_struct *data)
 	} else if (!iwl3945_is_associated(priv) && priv->essid_len) {
 		IWL_DEBUG_SCAN
 		  ("Kicking off one direct scan for '%s' when not associated\n",
-		   iwl3945_escape_essid(priv->essid, priv->essid_len));
+		   escape_essid(priv->essid, priv->essid_len));
 		scan->direct_scan[0].id = WLAN_EID_SSID;
 		scan->direct_scan[0].len = priv->essid_len;
 		memcpy(scan->direct_scan[0].ssid, priv->essid, priv->essid_len);
@@ -7031,7 +6991,7 @@ static int iwl3945_mac_hw_scan(struct ieee80211_hw *hw, u8 *ssid, size_t len)
 	}
 	if (len) {
 		IWL_DEBUG_SCAN("direct scan for %s [%d]\n ",
-			       iwl3945_escape_essid(ssid, len), (int)len);
+			       escape_essid(ssid, len), (int)len);
 
 		priv->one_direct_scan = 1;
 		priv->direct_ssid_len = (u8)
diff --git a/drivers/net/wireless/libertas/assoc.c b/drivers/net/wireless/libertas/assoc.c
index 92be604..0bf763d 100644
--- a/drivers/net/wireless/libertas/assoc.c
+++ b/drivers/net/wireless/libertas/assoc.c
@@ -1,6 +1,8 @@
 /* Copyright (C) 2006, Red Hat, Inc. */
 
+#include <linux/types.h>
 #include <linux/etherdevice.h>
+#include <net/lib80211.h>
 
 #include "assoc.h"
 #include "decl.h"
diff --git a/drivers/net/wireless/libertas/cmd.c b/drivers/net/wireless/libertas/cmd.c
index aee19fa..47f3dd4 100644
--- a/drivers/net/wireless/libertas/cmd.c
+++ b/drivers/net/wireless/libertas/cmd.c
@@ -4,6 +4,7 @@
   */
 
 #include <net/iw_handler.h>
+#include <net/lib80211.h>
 #include <net/ieee80211.h>
 #include <linux/kfifo.h>
 #include "host.h"
diff --git a/drivers/net/wireless/libertas/debugfs.c b/drivers/net/wireless/libertas/debugfs.c
index 0aa0ce3..70b9e3e 100644
--- a/drivers/net/wireless/libertas/debugfs.c
+++ b/drivers/net/wireless/libertas/debugfs.c
@@ -5,6 +5,7 @@
 #include <linux/mm.h>
 #include <linux/string.h>
 #include <net/iw_handler.h>
+#include <net/lib80211.h>
 
 #include "dev.h"
 #include "decl.h"
diff --git a/drivers/net/wireless/libertas/decl.h b/drivers/net/wireless/libertas/decl.h
index 1a8888c..0b84bdc 100644
--- a/drivers/net/wireless/libertas/decl.h
+++ b/drivers/net/wireless/libertas/decl.h
@@ -74,8 +74,4 @@ void lbs_host_to_card_done(struct lbs_private *priv);
 
 int lbs_update_channel(struct lbs_private *priv);
 
-#ifndef CONFIG_IEEE80211
-const char *escape_essid(const char *essid, u8 essid_len);
-#endif
-
 #endif
diff --git a/drivers/net/wireless/libertas/main.c b/drivers/net/wireless/libertas/main.c
index 73dc8c7..b30e845 100644
--- a/drivers/net/wireless/libertas/main.c
+++ b/drivers/net/wireless/libertas/main.c
@@ -1647,33 +1647,6 @@ out:
 	return ret;
 }
 
-#ifndef CONFIG_IEEE80211
-const char *escape_essid(const char *essid, u8 essid_len)
-{
-	static char escaped[IW_ESSID_MAX_SIZE * 2 + 1];
-	const char *s = essid;
-	char *d = escaped;
-
-	if (ieee80211_is_empty_essid(essid, essid_len)) {
-		memcpy(escaped, "<hidden>", sizeof("<hidden>"));
-		return escaped;
-	}
-
-	essid_len = min(essid_len, (u8) IW_ESSID_MAX_SIZE);
-	while (essid_len--) {
-		if (*s == '\0') {
-			*d++ = '\\';
-			*d++ = '0';
-			s++;
-		} else {
-			*d++ = *s++;
-		}
-	}
-	*d = '\0';
-	return escaped;
-}
-#endif
-
 module_init(lbs_init_module);
 module_exit(lbs_exit_module);
 
diff --git a/drivers/net/wireless/libertas/scan.c b/drivers/net/wireless/libertas/scan.c
index 8f66903..6638e3f 100644
--- a/drivers/net/wireless/libertas/scan.c
+++ b/drivers/net/wireless/libertas/scan.c
@@ -4,9 +4,12 @@
   * IOCTL handlers as well as command preperation and response routines
   *  for sending scan commands to the firmware.
   */
+#include <linux/types.h>
 #include <linux/etherdevice.h>
 #include <asm/unaligned.h>
 
+#include <net/lib80211.h>
+
 #include "host.h"
 #include "decl.h"
 #include "dev.h"
diff --git a/drivers/net/wireless/libertas/wext.c b/drivers/net/wireless/libertas/wext.c
index 6ebdd7f..7ecc2c7 100644
--- a/drivers/net/wireless/libertas/wext.c
+++ b/drivers/net/wireless/libertas/wext.c
@@ -8,6 +8,7 @@
 #include <linux/wireless.h>
 #include <linux/bitops.h>
 
+#include <net/lib80211.h>
 #include <net/ieee80211.h>
 #include <net/iw_handler.h>
 
diff --git a/include/net/ieee80211.h b/include/net/ieee80211.h
index b31399e..c7daa1d 100644
--- a/include/net/ieee80211.h
+++ b/include/net/ieee80211.h
@@ -127,10 +127,6 @@ static inline bool ieee80211_ratelimit_debug(u32 level)
 }
 #endif				/* CONFIG_IEEE80211_DEBUG */
 
-/* escape_essid() is intended to be used in debug (and possibly error)
- * messages. It should never be used for passing essid to user space. */
-const char *escape_essid(const char *essid, u8 essid_len);
-
 /*
  * To use the debug system:
  *
@@ -1139,22 +1135,6 @@ static inline void *ieee80211_priv(struct net_device *dev)
 	return ((struct ieee80211_device *)netdev_priv(dev))->priv;
 }
 
-static inline int ieee80211_is_empty_essid(const char *essid, int essid_len)
-{
-	/* Single white space is for Linksys APs */
-	if (essid_len == 1 && essid[0] == ' ')
-		return 1;
-
-	/* Otherwise, if the entire essid is 0, we assume it is hidden */
-	while (essid_len) {
-		essid_len--;
-		if (essid[essid_len] != '\0')
-			return 0;
-	}
-
-	return 1;
-}
-
 static inline int ieee80211_is_valid_mode(struct ieee80211_device *ieee,
 					  int mode)
 {
diff --git a/include/net/lib80211.h b/include/net/lib80211.h
new file mode 100644
index 0000000..6be5a3d
--- /dev/null
+++ b/include/net/lib80211.h
@@ -0,0 +1,31 @@
+/*
+ * lib80211.h -- common bits for IEEE802.11 wireless drivers
+ *
+ * Copyright (c) 2008, John W. Linville <linville@tuxdriver.com>
+ *
+ */
+
+#ifndef LIB80211_H
+#define LIB80211_H
+
+/* escape_essid() is intended to be used in debug (and possibly error)
+ * messages. It should never be used for passing essid to user space. */
+const char *escape_essid(const char *essid, u8 essid_len);
+
+static inline int is_empty_essid(const char *essid, int essid_len)
+{
+	/* Single white space is for Linksys APs */
+	if (essid_len == 1 && essid[0] == ' ')
+		return 1;
+
+	/* Otherwise, if the entire essid is 0, we assume it is hidden */
+	while (essid_len) {
+		essid_len--;
+		if (essid[essid_len] != '\0')
+			return 0;
+	}
+
+	return 1;
+}
+
+#endif /* LIB80211_H */
diff --git a/net/ieee80211/Kconfig b/net/ieee80211/Kconfig
index 94ed7d3..dc3eeed 100644
--- a/net/ieee80211/Kconfig
+++ b/net/ieee80211/Kconfig
@@ -1,5 +1,6 @@
 config IEEE80211
 	tristate "Generic IEEE 802.11 Networking Stack (DEPRECATED)"
+	select LIB80211
 	---help---
 	This option enables the hardware independent IEEE 802.11
 	networking stack.  This component is deprecated in favor of the
diff --git a/net/ieee80211/ieee80211_module.c b/net/ieee80211/ieee80211_module.c
index 949772a..d34d4e7 100644
--- a/net/ieee80211/ieee80211_module.c
+++ b/net/ieee80211/ieee80211_module.c
@@ -308,31 +308,5 @@ MODULE_PARM_DESC(debug, "debug output mask");
 module_exit(ieee80211_exit);
 module_init(ieee80211_init);
 
-const char *escape_essid(const char *essid, u8 essid_len)
-{
-	static char escaped[IW_ESSID_MAX_SIZE * 2 + 1];
-	const char *s = essid;
-	char *d = escaped;
-
-	if (ieee80211_is_empty_essid(essid, essid_len)) {
-		memcpy(escaped, "<hidden>", sizeof("<hidden>"));
-		return escaped;
-	}
-
-	essid_len = min(essid_len, (u8) IW_ESSID_MAX_SIZE);
-	while (essid_len--) {
-		if (*s == '\0') {
-			*d++ = '\\';
-			*d++ = '0';
-			s++;
-		} else {
-			*d++ = *s++;
-		}
-	}
-	*d = '\0';
-	return escaped;
-}
-
 EXPORT_SYMBOL(alloc_ieee80211);
 EXPORT_SYMBOL(free_ieee80211);
-EXPORT_SYMBOL(escape_essid);
diff --git a/net/ieee80211/ieee80211_rx.c b/net/ieee80211/ieee80211_rx.c
index 69dbc34..cea9090 100644
--- a/net/ieee80211/ieee80211_rx.c
+++ b/net/ieee80211/ieee80211_rx.c
@@ -32,6 +32,7 @@
 #include <asm/uaccess.h>
 #include <linux/ctype.h>
 
+#include <net/lib80211.h>
 #include <net/ieee80211.h>
 
 static void ieee80211_monitor_rx(struct ieee80211_device *ieee,
@@ -1166,8 +1167,8 @@ static int ieee80211_parse_info_param(struct ieee80211_info_element
 
 		switch (info_element->id) {
 		case MFIE_TYPE_SSID:
-			if (ieee80211_is_empty_essid(info_element->data,
-						     info_element->len)) {
+			if (is_empty_essid(info_element->data,
+					   info_element->len)) {
 				network->flags |= NETWORK_EMPTY_ESSID;
 				break;
 			}
@@ -1411,7 +1412,7 @@ static int ieee80211_handle_assoc_resp(struct ieee80211_device *ieee, struct iee
 			network->mode |= IEEE_B;
 	}
 
-	if (ieee80211_is_empty_essid(network->ssid, network->ssid_len))
+	if (is_empty_essid(network->ssid, network->ssid_len))
 		network->flags |= NETWORK_EMPTY_ESSID;
 
 	memcpy(&network->stats, stats, sizeof(network->stats));
@@ -1485,7 +1486,7 @@ static int ieee80211_network_init(struct ieee80211_device *ieee, struct ieee8021
 		return 1;
 	}
 
-	if (ieee80211_is_empty_essid(network->ssid, network->ssid_len))
+	if (is_empty_essid(network->ssid, network->ssid_len))
 		network->flags |= NETWORK_EMPTY_ESSID;
 
 	memcpy(&network->stats, stats, sizeof(network->stats));
diff --git a/net/wireless/Kconfig b/net/wireless/Kconfig
index b97bd9f..2efaa02 100644
--- a/net/wireless/Kconfig
+++ b/net/wireless/Kconfig
@@ -73,3 +73,13 @@ config WIRELESS_EXT_SYSFS
 
 	  Say Y if you have programs using it, like old versions of
 	  hal.
+
+config LIB80211
+	tristate "Common routines for IEEE802.11 drivers"
+	default n
+	help
+	  This options enables a library of common routines used
+	  by IEEE802.11 wireless LAN drivers.
+
+	  Drivers should select this themselves if needed.  Say Y if
+	  you want this built into your kernel.
diff --git a/net/wireless/Makefile b/net/wireless/Makefile
index b9f943c..d2d848d 100644
--- a/net/wireless/Makefile
+++ b/net/wireless/Makefile
@@ -1,5 +1,6 @@
 obj-$(CONFIG_WIRELESS_EXT) += wext.o
 obj-$(CONFIG_CFG80211) += cfg80211.o
+obj-$(CONFIG_LIB80211) += lib80211.o
 
 cfg80211-y += core.o sysfs.o radiotap.o util.o reg.o
 cfg80211-$(CONFIG_NL80211) += nl80211.o
diff --git a/net/wireless/lib80211.c b/net/wireless/lib80211.c
new file mode 100644
index 0000000..44630b5
--- /dev/null
+++ b/net/wireless/lib80211.c
@@ -0,0 +1,58 @@
+/*
+ * lib80211 -- common bits for IEEE802.11 drivers
+ *
+ * Copyright(c) 2008 John W. Linville <linville@tuxdriver.com>
+ *
+ */
+
+#include <linux/module.h>
+#include <linux/wireless.h>
+
+#include <net/lib80211.h>
+
+#define DRV_NAME        "lib80211"
+
+#define DRV_DESCRIPTION	"common routines for IEEE802.11 drivers"
+
+MODULE_DESCRIPTION(DRV_DESCRIPTION);
+MODULE_AUTHOR("John W. Linville <linville@tuxdriver.com>");
+MODULE_LICENSE("GPL");
+
+const char *escape_essid(const char *essid, u8 essid_len)
+{
+	static char escaped[IW_ESSID_MAX_SIZE * 2 + 1];
+	const char *s = essid;
+	char *d = escaped;
+
+	if (is_empty_essid(essid, essid_len)) {
+		memcpy(escaped, "<hidden>", sizeof("<hidden>"));
+		return escaped;
+	}
+
+	essid_len = min(essid_len, (u8) IW_ESSID_MAX_SIZE);
+	while (essid_len--) {
+		if (*s == '\0') {
+			*d++ = '\\';
+			*d++ = '0';
+			s++;
+		} else {
+			*d++ = *s++;
+		}
+	}
+	*d = '\0';
+	return escaped;
+}
+EXPORT_SYMBOL(escape_essid);
+
+static int __init ieee80211_init(void)
+{
+	printk(KERN_INFO DRV_NAME ": " DRV_DESCRIPTION "\n");
+	return 0;
+}
+
+static void __exit ieee80211_exit(void)
+{
+}
+
+module_init(ieee80211_init);
+module_exit(ieee80211_exit);
-- 
1.5.4.3

