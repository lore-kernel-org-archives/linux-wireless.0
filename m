Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from fg-out-1718.google.com ([72.14.220.159]:19961 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752289AbZCFLCj (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 6 Mar 2009 06:02:39 -0500
Received: by fg-out-1718.google.com with SMTP id 16so516128fgg.17
        for <linux-wireless@vger.kernel.org>; Fri, 06 Mar 2009 03:02:36 -0800 (PST)
From: Helmut Schaa <helmut.schaa@googlemail.com>
To: linville@tuxdriver.com
Subject: [PATCH] libipw: fix debug output
Date: Fri, 6 Mar 2009 12:02:25 +0100
Cc: linux-wireless@vger.kernel.org, yi.zhu@intel.com
MIME-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Message-Id: <200903061202.25990.helmut.schaa@gmail.com> (sfid-20090306_120244_011140_EEE32219)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Replace all remaining occurrences of CONFIG_IEEE80211_DEBUG with
CONFIG_LIBIPW_DEBUG in libipw to allow debug output again.

Signed-off-by: Helmut Schaa <helmut.schaa@googlemail.com>
---

diff --git a/drivers/net/wireless/ipw2x00/ieee80211.h b/drivers/net/wireless/ipw2x00/ieee80211.h
index 7515fad..97c7cfc 100644
--- a/drivers/net/wireless/ipw2x00/ieee80211.h
+++ b/drivers/net/wireless/ipw2x00/ieee80211.h
@@ -112,7 +112,7 @@
 
 /* debug macros */
 
-#ifdef CONFIG_IEEE80211_DEBUG
+#ifdef CONFIG_LIBIPW_DEBUG
 extern u32 ieee80211_debug_level;
 #define IEEE80211_DEBUG(level, fmt, args...) \
 do { if (ieee80211_debug_level & (level)) \
@@ -128,7 +128,7 @@ static inline bool ieee80211_ratelimit_debug(u32 level)
 {
 	return false;
 }
-#endif				/* CONFIG_IEEE80211_DEBUG */
+#endif				/* CONFIG_LIBIPW_DEBUG */
 
 /*
  * To use the debug system:
@@ -152,7 +152,7 @@ static inline bool ieee80211_ratelimit_debug(u32 level)
  * you simply need to add your entry to the ieee80211_debug_level array.
  *
  * If you do not see debug_level in /proc/net/ieee80211 then you do not have
- * CONFIG_IEEE80211_DEBUG defined in your kernel configuration
+ * CONFIG_LIBIPW_DEBUG defined in your kernel configuration
  *
  */
 
diff --git a/drivers/net/wireless/ipw2x00/libipw_module.c b/drivers/net/wireless/ipw2x00/libipw_module.c
index ec77534..f4803fc 100644
--- a/drivers/net/wireless/ipw2x00/libipw_module.c
+++ b/drivers/net/wireless/ipw2x00/libipw_module.c
@@ -221,7 +221,7 @@ void free_ieee80211(struct net_device *dev)
 	free_netdev(dev);
 }
 
-#ifdef CONFIG_IEEE80211_DEBUG
+#ifdef CONFIG_LIBIPW_DEBUG
 
 static int debug = 0;
 u32 ieee80211_debug_level = 0;
@@ -252,11 +252,11 @@ static int store_debug_level(struct file *file, const char __user * buffer,
 
 	return strnlen(buf, len);
 }
-#endif				/* CONFIG_IEEE80211_DEBUG */
+#endif				/* CONFIG_LIBIPW_DEBUG */
 
 static int __init ieee80211_init(void)
 {
-#ifdef CONFIG_IEEE80211_DEBUG
+#ifdef CONFIG_LIBIPW_DEBUG
 	struct proc_dir_entry *e;
 
 	ieee80211_debug_level = debug;
@@ -276,7 +276,7 @@ static int __init ieee80211_init(void)
 	e->read_proc = show_debug_level;
 	e->write_proc = store_debug_level;
 	e->data = NULL;
-#endif				/* CONFIG_IEEE80211_DEBUG */
+#endif				/* CONFIG_LIBIPW_DEBUG */
 
 	printk(KERN_INFO DRV_NAME ": " DRV_DESCRIPTION ", " DRV_VERSION "\n");
 	printk(KERN_INFO DRV_NAME ": " DRV_COPYRIGHT "\n");
@@ -286,20 +286,20 @@ static int __init ieee80211_init(void)
 
 static void __exit ieee80211_exit(void)
 {
-#ifdef CONFIG_IEEE80211_DEBUG
+#ifdef CONFIG_LIBIPW_DEBUG
 	if (ieee80211_proc) {
 		remove_proc_entry("debug_level", ieee80211_proc);
 		remove_proc_entry(DRV_NAME, init_net.proc_net);
 		ieee80211_proc = NULL;
 	}
-#endif				/* CONFIG_IEEE80211_DEBUG */
+#endif				/* CONFIG_LIBIPW_DEBUG */
 }
 
-#ifdef CONFIG_IEEE80211_DEBUG
+#ifdef CONFIG_LIBIPW_DEBUG
 #include <linux/moduleparam.h>
 module_param(debug, int, 0444);
 MODULE_PARM_DESC(debug, "debug output mask");
-#endif				/* CONFIG_IEEE80211_DEBUG */
+#endif				/* CONFIG_LIBIPW_DEBUG */
 
 module_exit(ieee80211_exit);
 module_init(ieee80211_init);
diff --git a/drivers/net/wireless/ipw2x00/libipw_rx.c b/drivers/net/wireless/ipw2x00/libipw_rx.c
index 8d9e96f..794d2fc 100644
--- a/drivers/net/wireless/ipw2x00/libipw_rx.c
+++ b/drivers/net/wireless/ipw2x00/libipw_rx.c
@@ -1080,7 +1080,7 @@ static int ieee80211_parse_qos_info_param_IE(struct ieee80211_info_element
 	return rc;
 }
 
-#ifdef CONFIG_IEEE80211_DEBUG
+#ifdef CONFIG_LIBIPW_DEBUG
 #define MFIE_STRING(x) case MFIE_TYPE_ ##x: return #x
 
 static const char *get_info_element_string(u16 id)
@@ -1125,7 +1125,7 @@ static int ieee80211_parse_info_param(struct ieee80211_info_element
 {
 	DECLARE_SSID_BUF(ssid);
 	u8 i;
-#ifdef CONFIG_IEEE80211_DEBUG
+#ifdef CONFIG_LIBIPW_DEBUG
 	char rates_str[64];
 	char *p;
 #endif
@@ -1161,14 +1161,14 @@ static int ieee80211_parse_info_param(struct ieee80211_info_element
 			break;
 
 		case MFIE_TYPE_RATES:
-#ifdef CONFIG_IEEE80211_DEBUG
+#ifdef CONFIG_LIBIPW_DEBUG
 			p = rates_str;
 #endif
 			network->rates_len = min(info_element->len,
 						 MAX_RATES_LENGTH);
 			for (i = 0; i < network->rates_len; i++) {
 				network->rates[i] = info_element->data[i];
-#ifdef CONFIG_IEEE80211_DEBUG
+#ifdef CONFIG_LIBIPW_DEBUG
 				p += snprintf(p, sizeof(rates_str) -
 					      (p - rates_str), "%02X ",
 					      network->rates[i]);
@@ -1188,14 +1188,14 @@ static int ieee80211_parse_info_param(struct ieee80211_info_element
 			break;
 
 		case MFIE_TYPE_RATES_EX:
-#ifdef CONFIG_IEEE80211_DEBUG
+#ifdef CONFIG_LIBIPW_DEBUG
 			p = rates_str;
 #endif
 			network->rates_ex_len = min(info_element->len,
 						    MAX_RATES_EX_LENGTH);
 			for (i = 0; i < network->rates_ex_len; i++) {
 				network->rates_ex[i] = info_element->data[i];
-#ifdef CONFIG_IEEE80211_DEBUG
+#ifdef CONFIG_LIBIPW_DEBUG
 				p += snprintf(p, sizeof(rates_str) -
 					      (p - rates_str), "%02X ",
 					      network->rates[i]);
@@ -1562,7 +1562,7 @@ static void ieee80211_process_probe_response(struct ieee80211_device
 	};
 	struct ieee80211_network *target;
 	struct ieee80211_network *oldest = NULL;
-#ifdef CONFIG_IEEE80211_DEBUG
+#ifdef CONFIG_LIBIPW_DEBUG
 	struct ieee80211_info_element *info_element = beacon->info_element;
 #endif
 	unsigned long flags;
@@ -1640,7 +1640,7 @@ static void ieee80211_process_probe_response(struct ieee80211_device
 			list_del(ieee->network_free_list.next);
 		}
 
-#ifdef CONFIG_IEEE80211_DEBUG
+#ifdef CONFIG_LIBIPW_DEBUG
 		IEEE80211_DEBUG_SCAN("Adding '%s' (%pM) via %s.\n",
 				     print_ssid(ssid, network.ssid,
 						 network.ssid_len),
