Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from crystal.sipsolutions.net ([195.210.38.204]:60239 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752440AbXFVIqW (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 22 Jun 2007 04:46:22 -0400
Subject: [PATCH] mac80211: move wpa trigger to debugfs
From: Johannes Berg <johannes@sipsolutions.net>
To: "John W. Linville" <linville@tuxdriver.com>
Cc: Jiri Benc <jbenc@suse.cz>,
	linux-wireless <linux-wireless@vger.kernel.org>
Content-Type: text/plain
Date: Fri, 22 Jun 2007 09:53:00 +0200
Message-Id: <1182498780.21939.54.camel@johannes.berg>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This patch creates a new per-STA debugfs file to trigger WPA testing.

Printout of the file is like this:
0x00000001 *FAIL_TX_MIC
0x00000002  FAIL_TX_ICV
0x00000004  FAIL_RX_MIC
0x00000008  FAIL_RX_ICV
0x00000010  TX_REPLAY
0x00000020  TX_REPLAY_FRAG
0x00000040  TX_SKIP_SEQ

where the "*" indicates that the specific test is enabled, input it
takes is just an integer with the bits you want set.

Signed-off-by: Johannes Berg <johannes@sipsolutions.net>

---
 net/mac80211/Kconfig           |    2 -
 net/mac80211/debugfs_sta.c     |   61 +++++++++++++++++++++++++++++++++++++++++
 net/mac80211/hostapd_ioctl.h   |   10 ------
 net/mac80211/ieee80211_i.h     |    8 +++++
 net/mac80211/ieee80211_ioctl.c |   32 ---------------------
 net/mac80211/sta_info.h        |    3 ++
 6 files changed, 73 insertions(+), 43 deletions(-)

--- wireless-dev.orig/net/mac80211/hostapd_ioctl.h	2007-06-22 09:21:05.368635409 +0200
+++ wireless-dev/net/mac80211/hostapd_ioctl.h	2007-06-22 09:21:29.558635409 +0200
@@ -175,16 +175,6 @@ struct prism2_hostapd_param {
 			s32 listen;   /* microseconds */
 		} scan;
 		struct {
-#define WPA_TRIGGER_FAIL_TX_MIC BIT(0)
-#define WPA_TRIGGER_FAIL_TX_ICV BIT(1)
-#define WPA_TRIGGER_FAIL_RX_MIC BIT(2)
-#define WPA_TRIGGER_FAIL_RX_ICV BIT(3)
-#define WPA_TRIGGER_TX_REPLAY BIT(4)
-#define WPA_TRIGGER_TX_REPLAY_FRAG BIT(5)
-#define WPA_TRIGGER_TX_SKIP_SEQ BIT(6)
-			u32 trigger;
-		} wpa_trigger;
-		struct {
 			u16 mode; /* MODE_* */
 			u16 num_supported_rates;
 			u16 num_basic_rates;
--- wireless-dev.orig/net/mac80211/ieee80211_ioctl.c	2007-06-22 09:21:35.988635409 +0200
+++ wireless-dev/net/mac80211/ieee80211_ioctl.c	2007-06-22 09:21:52.408635409 +0200
@@ -835,33 +835,6 @@ static int ieee80211_ioctl_get_encryptio
 }
 
 
-#ifdef CONFIG_HOSTAPD_WPA_TESTING
-static int ieee80211_ioctl_wpa_trigger(struct net_device *dev,
-				       struct prism2_hostapd_param *param)
-{
-	struct ieee80211_local *local = wdev_priv(dev->ieee80211_ptr);
-	struct sta_info *sta;
-
-	if (is_broadcast_ether_addr(param->sta_addr)) {
-		local->wpa_trigger = param->u.wpa_trigger.trigger;
-		return 0;
-	}
-
-	sta = sta_info_get(local, param->sta_addr);
-	if (!sta) {
-		printk(KERN_DEBUG "%s: wpa_trigger - unknown addr\n",
-		       dev->name);
-		return -EINVAL;
-	}
-
-	sta->wpa_trigger = param->u.wpa_trigger.trigger;
-
-	sta_info_put(sta);
-	return 0;
-}
-#endif /* CONFIG_HOSTAPD_WPA_TESTING */
-
-
 static int ieee80211_ioctl_set_rate_sets(struct net_device *dev,
 					 struct prism2_hostapd_param *param,
 					 int param_len)
@@ -1357,11 +1330,6 @@ static int ieee80211_ioctl_priv_hostapd(
 	case PRISM2_HOSTAPD_GET_HW_FEATURES:
 		ret = ieee80211_ioctl_get_hw_features(dev, param, p->length);
 		break;
-#ifdef CONFIG_HOSTAPD_WPA_TESTING
-	case PRISM2_HOSTAPD_WPA_TRIGGER:
-		ret = ieee80211_ioctl_wpa_trigger(dev, param);
-		break;
-#endif /* CONFIG_HOSTAPD_WPA_TESTING */
 	case PRISM2_HOSTAPD_SET_RATE_SETS:
 		ret = ieee80211_ioctl_set_rate_sets(dev, param, p->length);
 		break;
--- wireless-dev.orig/net/mac80211/Kconfig	2007-06-22 09:22:02.398635409 +0200
+++ wireless-dev/net/mac80211/Kconfig	2007-06-22 09:22:31.778635409 +0200
@@ -66,7 +66,7 @@ config MAC80211_DEBUG_COUNTERS
 
 config HOSTAPD_WPA_TESTING
 	bool "Support for TKIP countermeasures testing"
-	depends on MAC80211_DEBUG
+	depends on MAC80211_DEBUG && MAC80211_DEBUGFS
 
 config MAC80211_IBSS_DEBUG
 	bool "Support for IBSS testing"
--- wireless-dev.orig/net/mac80211/debugfs_sta.c	2007-06-22 09:23:27.118635409 +0200
+++ wireless-dev/net/mac80211/debugfs_sta.c	2007-06-22 09:49:02.868635409 +0200
@@ -194,6 +194,58 @@ static ssize_t sta_wme_tx_queue_read(str
 STA_OPS(wme_tx_queue);
 #endif
 
+#ifdef CONFIG_HOSTAPD_WPA_TESTING
+static ssize_t sta_wpa_trigger_read(struct file *file, char __user *userbuf,
+				    size_t count, loff_t *ppos)
+{
+	static const char *bitnames[] = {
+		"FAIL_TX_MIC",
+		"FAIL_TX_ICV",
+		"FAIL_RX_MIC",
+		"FAIL_RX_ICV",
+		"TX_REPLAY",
+		"TX_REPLAY_FRAG",
+		"TX_SKIP_SEQ",
+	};
+	static const int numbits = ARRAY_SIZE(bitnames);
+	struct sta_info *sta = file->private_data;
+	/* increase buffer size when adding new flags! */
+	char buf[numbits*30], *p = buf;
+	int i;
+	for (i = 0; i < numbits; i++)
+		p += scnprintf(p, sizeof(buf)+buf-p, "0x%.8x %s%s\n",
+			       (1<<i), sta->wpa_trigger & (1<<i) ? "*": " ",
+			       bitnames[i]);
+	return simple_read_from_buffer(userbuf, count, ppos, buf, p - buf);
+}
+
+static ssize_t sta_wpa_trigger_write(struct file *file,
+				     const char __user *userbuf,
+				     size_t count, loff_t *ppos)
+{
+	char buf[11], *end;
+	int size = min(sizeof(buf)-1, count);
+	struct sta_info *sta = file->private_data;
+	u32 flags;
+
+	if (copy_from_user(buf, userbuf, size))
+		return -EFAULT;
+
+	buf[sizeof(buf)-1] = '\0';
+	flags = simple_strtoul(buf, &end, 0);
+	if (end - buf != size)
+		return -EINVAL;
+	sta->wpa_trigger = flags;
+	return size;
+}
+
+static const struct file_operations sta_wpa_trigger_ops = {
+	.read = sta_wpa_trigger_read,
+	.write = sta_wpa_trigger_write,
+	.open = mac80211_open_file_generic,
+};
+#endif
+
 #define DEBUGFS_ADD(name) \
 	sta->debugfs.name = debugfs_create_file(#name, 0444, \
 		sta->debugfs.dir, sta, &sta_ ##name## _ops);
@@ -227,6 +279,12 @@ void ieee80211_sta_debugfs_add(struct st
 	DEBUGFS_ADD(wme_rx_queue);
 	DEBUGFS_ADD(wme_tx_queue);
 #endif
+#ifdef CONFIG_HOSTAPD_WPA_TESTING
+	sta->debugfs.wpa_trigger =
+		debugfs_create_file("wpa_trigger", 0644,
+				    sta->debugfs.dir, sta,
+				    &sta_wpa_trigger_ops);
+#endif
 }
 
 void ieee80211_sta_debugfs_remove(struct sta_info *sta)
@@ -241,6 +299,9 @@ void ieee80211_sta_debugfs_remove(struct
 	DEBUGFS_DEL(wme_rx_queue);
 	DEBUGFS_DEL(wme_tx_queue);
 #endif
+#ifdef CONFIG_HOSTAPD_WPA_TESTING
+	DEBUGFS_DEL(wpa_trigger);
+#endif
 
 	debugfs_remove(sta->debugfs.dir);
 	sta->debugfs.dir = NULL;
--- wireless-dev.orig/net/mac80211/ieee80211_i.h	2007-06-22 09:22:43.188635409 +0200
+++ wireless-dev/net/mac80211/ieee80211_i.h	2007-06-22 09:31:39.848635409 +0200
@@ -552,6 +552,14 @@ struct ieee80211_local {
 	int scan_flags;
 
 #ifdef CONFIG_HOSTAPD_WPA_TESTING
+#define WPA_TRIGGER_FAIL_TX_MIC BIT(0)
+#define WPA_TRIGGER_FAIL_TX_ICV BIT(1)
+#define WPA_TRIGGER_FAIL_RX_MIC BIT(2)
+#define WPA_TRIGGER_FAIL_RX_ICV BIT(3)
+#define WPA_TRIGGER_TX_REPLAY BIT(4)
+#define WPA_TRIGGER_TX_REPLAY_FRAG BIT(5)
+#define WPA_TRIGGER_TX_SKIP_SEQ BIT(6)
+/* update debugfs_sta.c when adding new flags */
 	u32 wpa_trigger;
 #endif /* CONFIG_HOSTAPD_WPA_TESTING */
 	/* SNMP counters */
--- wireless-dev.orig/net/mac80211/sta_info.h	2007-06-22 09:42:48.548635409 +0200
+++ wireless-dev/net/mac80211/sta_info.h	2007-06-22 09:43:07.648635409 +0200
@@ -137,6 +137,9 @@ struct sta_info {
 		struct dentry *wme_rx_queue;
 		struct dentry *wme_tx_queue;
 #endif
+#ifdef CONFIG_HOSTAPD_WPA_TESTING
+		struct dentry *wpa_trigger;
+#endif
 	} debugfs;
 #endif
 };


