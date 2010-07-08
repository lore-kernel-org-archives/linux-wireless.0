Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.nokia.com ([192.100.122.233]:40423 "EHLO
	mgw-mx06.nokia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755567Ab0GHOvH (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 8 Jul 2010 10:51:07 -0400
From: Luciano Coelho <luciano.coelho@nokia.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org,
	Juuso Oikarinen <juuso.oikarinen@nokia.com>
Subject: [PATCH 03/13] wl1271: Use the ARP configuration function from mac80211
Date: Thu,  8 Jul 2010 17:49:58 +0300
Message-Id: <1278600608-22411-4-git-send-email-luciano.coelho@nokia.com>
In-Reply-To: <1278600608-22411-1-git-send-email-luciano.coelho@nokia.com>
References: <1278600608-22411-1-git-send-email-luciano.coelho@nokia.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Juuso Oikarinen <juuso.oikarinen@nokia.com>

This patch updates the driver to use the ARP configuration function from the
mac80211. Also, clean up IPv6 support from the ACX function as ARP is not
used with that protocol version.

Signed-off-by: Juuso Oikarinen <juuso.oikarinen@nokia.com>
Reviewed-by: Luciano Coelho <luciano.coelho@nokia.com>
Signed-off-by: Luciano Coelho <luciano.coelho@nokia.com>
---
 drivers/net/wireless/wl12xx/wl1271_acx.c  |   19 +---
 drivers/net/wireless/wl12xx/wl1271_acx.h  |    3 +-
 drivers/net/wireless/wl12xx/wl1271_main.c |  142 ++++++++++-------------------
 3 files changed, 56 insertions(+), 108 deletions(-)

diff --git a/drivers/net/wireless/wl12xx/wl1271_acx.c b/drivers/net/wireless/wl12xx/wl1271_acx.c
index 5cadb9d..b45ebbc 100644
--- a/drivers/net/wireless/wl12xx/wl1271_acx.c
+++ b/drivers/net/wireless/wl12xx/wl1271_acx.c
@@ -1075,13 +1075,12 @@ out:
 	return ret;
 }
 
-int wl1271_acx_arp_ip_filter(struct wl1271 *wl, bool enable, u8 *address,
-			     u8 version)
+int wl1271_acx_arp_ip_filter(struct wl1271 *wl, u8 mode, u8 *address)
 {
 	struct wl1271_acx_arp_filter *acx;
 	int ret;
 
-	wl1271_debug(DEBUG_ACX, "acx arp ip filter, enable: %d", enable);
+	wl1271_debug(DEBUG_ACX, "acx arp ip filter, mode: %d", mode);
 
 	acx = kzalloc(sizeof(*acx), GFP_KERNEL);
 	if (!acx) {
@@ -1089,17 +1088,11 @@ int wl1271_acx_arp_ip_filter(struct wl1271 *wl, bool enable, u8 *address,
 		goto out;
 	}
 
-	acx->version = version;
-	acx->enable = enable;
+	acx->version = ACX_IPV4_VERSION;
+	acx->enable = mode;
 
-	if (enable == true) {
-		if (version == ACX_IPV4_VERSION)
-			memcpy(acx->address, address, ACX_IPV4_ADDR_SIZE);
-		else if (version == ACX_IPV6_VERSION)
-			memcpy(acx->address, address, sizeof(acx->address));
-		else
-			wl1271_error("Invalid IP version");
-	}
+	if (mode != ACX_ARP_DISABLE)
+		memcpy(acx->address, address, ACX_IPV4_ADDR_SIZE);
 
 	ret = wl1271_cmd_configure(wl, ACX_ARP_IP_FILTER,
 				   acx, sizeof(*acx));
diff --git a/drivers/net/wireless/wl12xx/wl1271_acx.h b/drivers/net/wireless/wl12xx/wl1271_acx.h
index 914b29b..6a6f3e3 100644
--- a/drivers/net/wireless/wl12xx/wl1271_acx.h
+++ b/drivers/net/wireless/wl12xx/wl1271_acx.h
@@ -1117,8 +1117,7 @@ int wl1271_acx_init_mem_config(struct wl1271 *wl);
 int wl1271_acx_init_rx_interrupt(struct wl1271 *wl);
 int wl1271_acx_smart_reflex(struct wl1271 *wl);
 int wl1271_acx_bet_enable(struct wl1271 *wl, bool enable);
-int wl1271_acx_arp_ip_filter(struct wl1271 *wl, bool enable, u8 *address,
-			     u8 version);
+int wl1271_acx_arp_ip_filter(struct wl1271 *wl, u8 mode, u8 *address);
 int wl1271_acx_pm_config(struct wl1271 *wl);
 int wl1271_acx_keep_alive_mode(struct wl1271 *wl, bool enable);
 int wl1271_acx_keep_alive_config(struct wl1271 *wl, u8 index, u8 tpl_valid);
diff --git a/drivers/net/wireless/wl12xx/wl1271_main.c b/drivers/net/wireless/wl12xx/wl1271_main.c
index 5970fde..a37244c 100644
--- a/drivers/net/wireless/wl12xx/wl1271_main.c
+++ b/drivers/net/wireless/wl12xx/wl1271_main.c
@@ -28,7 +28,6 @@
 #include <linux/crc32.h>
 #include <linux/etherdevice.h>
 #include <linux/vmalloc.h>
-#include <linux/inetdevice.h>
 #include <linux/platform_device.h>
 #include <linux/slab.h>
 
@@ -818,93 +817,6 @@ static int wl1271_op_tx(struct ieee80211_hw *hw, struct sk_buff *skb)
 	return NETDEV_TX_OK;
 }
 
-static int wl1271_dev_notify(struct notifier_block *me, unsigned long what,
-			     void *arg)
-{
-	struct net_device *dev;
-	struct wireless_dev *wdev;
-	struct wiphy *wiphy;
-	struct ieee80211_hw *hw;
-	struct wl1271 *wl;
-	struct wl1271 *wl_temp;
-	struct in_device *idev;
-	struct in_ifaddr *ifa = arg;
-	int ret = 0;
-
-	/* FIXME: this ugly function should probably be implemented in the
-	 * mac80211, and here should only be a simple callback handling actual
-	 * setting of the filters. Now we need to dig up references to
-	 * various structures to gain access to what we need.
-	 * Also, because of this, there is no "initial" setting of the filter
-	 * in "op_start", because we don't want to dig up struct net_device
-	 * there - the filter will be set upon first change of the interface
-	 * IP address. */
-
-	dev = ifa->ifa_dev->dev;
-
-	wdev = dev->ieee80211_ptr;
-	if (wdev == NULL)
-		return NOTIFY_DONE;
-
-	wiphy = wdev->wiphy;
-	if (wiphy == NULL)
-		return NOTIFY_DONE;
-
-	hw = wiphy_priv(wiphy);
-	if (hw == NULL)
-		return NOTIFY_DONE;
-
-	/* Check that the interface is one supported by this driver. */
-	wl_temp = hw->priv;
-	list_for_each_entry(wl, &wl_list, list) {
-		if (wl == wl_temp)
-			break;
-	}
-	if (wl != wl_temp)
-		return NOTIFY_DONE;
-
-	/* Get the interface IP address for the device. "ifa" will become
-	   NULL if:
-	     - there is no IPV4 protocol address configured
-	     - there are multiple (virtual) IPV4 addresses configured
-	   When "ifa" is NULL, filtering will be disabled.
-	*/
-	ifa = NULL;
-	idev = dev->ip_ptr;
-	if (idev)
-		ifa = idev->ifa_list;
-
-	if (ifa && ifa->ifa_next)
-		ifa = NULL;
-
-	mutex_lock(&wl->mutex);
-
-	if (wl->state == WL1271_STATE_OFF)
-		goto out;
-
-	ret = wl1271_ps_elp_wakeup(wl, false);
-	if (ret < 0)
-		goto out;
-	if (ifa)
-		ret = wl1271_acx_arp_ip_filter(wl, true,
-					       (u8 *)&ifa->ifa_address,
-					       ACX_IPV4_VERSION);
-	else
-		ret = wl1271_acx_arp_ip_filter(wl, false, NULL,
-					       ACX_IPV4_VERSION);
-	wl1271_ps_elp_sleep(wl);
-
-out:
-	mutex_unlock(&wl->mutex);
-
-	return NOTIFY_OK;
-}
-
-static struct notifier_block wl1271_dev_notifier = {
-	.notifier_call = wl1271_dev_notify,
-};
-
-
 static int wl1271_op_start(struct ieee80211_hw *hw)
 {
 	wl1271_debug(DEBUG_MAC80211, "mac80211 start");
@@ -1008,10 +920,8 @@ power_off:
 out:
 	mutex_unlock(&wl->mutex);
 
-	if (!ret) {
+	if (!ret)
 		list_add(&wl->list, &wl_list);
-		register_inetaddr_notifier(&wl1271_dev_notifier);
-	}
 
 	return ret;
 }
@@ -1022,8 +932,6 @@ static void wl1271_op_remove_interface(struct ieee80211_hw *hw,
 	struct wl1271 *wl = hw->priv;
 	int i;
 
-	unregister_inetaddr_notifier(&wl1271_dev_notifier);
-
 	mutex_lock(&wl->mutex);
 	wl1271_debug(DEBUG_MAC80211, "mac80211 remove interface");
 
@@ -1400,6 +1308,53 @@ struct wl1271_filter_params {
 	u8 mc_list[ACX_MC_ADDRESS_GROUP_MAX][ETH_ALEN];
 };
 
+static int wl1271_op_configure_arp_filter(struct ieee80211_hw *hw,
+					  struct ieee80211_vif *vif,
+					  struct in_ifaddr *ifa_list)
+{
+	struct wl1271 *wl = hw->priv;
+	int ret = 0;
+
+	WARN_ON(vif != wl->vif);
+
+	/* disable filtering if there are multiple addresses */
+	if (ifa_list && ifa_list->ifa_next)
+		ifa_list = NULL;
+
+	mutex_lock(&wl->mutex);
+
+	if (wl->state == WL1271_STATE_OFF)
+		goto out;
+
+	WARN_ON(wl->bss_type != BSS_TYPE_STA_BSS);
+
+	ret = wl1271_ps_elp_wakeup(wl, false);
+	if (ret < 0)
+		goto out;
+
+	if (ifa_list) {
+		ret = wl1271_cmd_build_arp_reply(wl, &ifa_list->ifa_address);
+		if (ret < 0)
+			goto out_sleep;
+		ret = wl1271_acx_arp_ip_filter(wl, ACX_ARP_FILTER_AND_REPLY,
+					       (u8 *)&ifa_list->ifa_address);
+		if (ret < 0)
+			goto out_sleep;
+	} else {
+		ret = wl1271_acx_arp_ip_filter(wl, ACX_ARP_DISABLE, NULL);
+		if (ret < 0)
+			goto out_sleep;
+	}
+
+out_sleep:
+	wl1271_ps_elp_sleep(wl);
+
+out:
+	mutex_unlock(&wl->mutex);
+
+	return ret;
+}
+
 static u64 wl1271_op_prepare_multicast(struct ieee80211_hw *hw,
 				       struct netdev_hw_addr_list *mc_list)
 {
@@ -2213,6 +2168,7 @@ static const struct ieee80211_ops wl1271_ops = {
 	.add_interface = wl1271_op_add_interface,
 	.remove_interface = wl1271_op_remove_interface,
 	.config = wl1271_op_config,
+	.configure_arp_filter = wl1271_op_configure_arp_filter,
 	.prepare_multicast = wl1271_op_prepare_multicast,
 	.configure_filter = wl1271_op_configure_filter,
 	.tx = wl1271_op_tx,
-- 
1.6.3.3

