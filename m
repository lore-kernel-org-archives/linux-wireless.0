Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.nokia.com ([192.100.122.233]:36172 "EHLO
	mgw-mx06.nokia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933766AbZJMJuF (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 13 Oct 2009 05:50:05 -0400
From: Luciano Coelho <luciano.coelho@nokia.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org,
	Juuso Oikarinen <juuso.oikarinen@nokia.com>,
	=?utf-8?q?Janne=20Yl=C3=A4lehto?= <janne.ylalehto@nokia.com>
Subject: [PATCH 18/22] wl1271: Support for IPv4 ARP filtering
Date: Tue, 13 Oct 2009 12:47:55 +0300
Message-Id: <1255427279-1224-19-git-send-email-luciano.coelho@nokia.com>
In-Reply-To: <1255427279-1224-1-git-send-email-luciano.coelho@nokia.com>
References: <1255427279-1224-1-git-send-email-luciano.coelho@nokia.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Juuso Oikarinen <juuso.oikarinen@nokia.com>

Add support for IPv4 ARP filtering in the driver. This will dramatically
reduce the number of unnecessary interrupts by the device in conqested
networks.

This patch is based on a similar patch to wl1251 by Janne Ylälehto.

Cc: Janne Ylälehto <janne.ylalehto@nokia.com>
Signed-off-by: Juuso Oikarinen <juuso.oikarinen@nokia.com>
Reviewed-by: Luciano Coelho <luciano.coelho@nokia.com>
Signed-off-by: Luciano Coelho <luciano.coelho@nokia.com>
---
 drivers/net/wireless/wl12xx/wl1271.h      |    2 +
 drivers/net/wireless/wl12xx/wl1271_acx.c  |   38 +++++++++++
 drivers/net/wireless/wl12xx/wl1271_acx.h  |   17 +++++
 drivers/net/wireless/wl12xx/wl1271_main.c |  100 +++++++++++++++++++++++++++++
 4 files changed, 157 insertions(+), 0 deletions(-)

diff --git a/drivers/net/wireless/wl12xx/wl1271.h b/drivers/net/wireless/wl12xx/wl1271.h
index 79a7324..1e399a2 100644
--- a/drivers/net/wireless/wl12xx/wl1271.h
+++ b/drivers/net/wireless/wl12xx/wl1271.h
@@ -441,6 +441,8 @@ struct wl1271 {
 
 	/* Current chipset configuration */
 	struct conf_drv_settings conf;
+
+	struct list_head list;
 };
 
 int wl1271_plt_start(struct wl1271 *wl);
diff --git a/drivers/net/wireless/wl12xx/wl1271_acx.c b/drivers/net/wireless/wl12xx/wl1271_acx.c
index 44a1237..e891cd5 100644
--- a/drivers/net/wireless/wl12xx/wl1271_acx.c
+++ b/drivers/net/wireless/wl12xx/wl1271_acx.c
@@ -1092,3 +1092,41 @@ out:
 	kfree(acx);
 	return ret;
 }
+
+int wl1271_acx_arp_ip_filter(struct wl1271 *wl, bool enable, u8 *address,
+			     u8 version)
+{
+	struct wl1271_acx_arp_filter *acx;
+	int ret;
+
+	wl1271_debug(DEBUG_ACX, "acx arp ip filter, enable: %d", enable);
+
+	acx = kzalloc(sizeof(*acx), GFP_KERNEL);
+	if (!acx) {
+		ret = -ENOMEM;
+		goto out;
+	}
+
+	acx->version = version;
+	acx->enable = enable;
+
+	if (enable == true) {
+		if (version == ACX_IPV4_VERSION)
+			memcpy(acx->address, address, ACX_IPV4_ADDR_SIZE);
+		else if (version == ACX_IPV6_VERSION)
+			memcpy(acx->address, address, sizeof(acx->address));
+		else
+			wl1271_error("Invalid IP version");
+	}
+
+	ret = wl1271_cmd_configure(wl, ACX_ARP_IP_FILTER,
+				   acx, sizeof(*acx));
+	if (ret < 0) {
+		wl1271_warning("failed to set arp ip filter: %d", ret);
+		goto out;
+	}
+
+out:
+	kfree(acx);
+	return ret;
+}
diff --git a/drivers/net/wireless/wl12xx/wl1271_acx.h b/drivers/net/wireless/wl12xx/wl1271_acx.h
index 29fd363..1580314 100644
--- a/drivers/net/wireless/wl12xx/wl1271_acx.h
+++ b/drivers/net/wireless/wl12xx/wl1271_acx.h
@@ -955,6 +955,21 @@ struct wl1271_acx_bet_enable {
 	u8 padding[2];
 } __attribute__ ((packed));
 
+#define ACX_IPV4_VERSION 4
+#define ACX_IPV6_VERSION 6
+#define ACX_IPV4_ADDR_SIZE 4
+struct wl1271_acx_arp_filter {
+	struct acx_header header;
+	u8 version;         /* ACX_IPV4_VERSION, ACX_IPV6_VERSION */
+	u8 enable;          /* 1 to enable ARP filtering, 0 to disable */
+	u8 padding[2];
+	u8 address[16];     /* The configured device IP address - all ARP
+			       requests directed to this IP address will pass
+			       through. For IPv4, the first four bytes are
+			       used. */
+} __attribute__((packed));
+
+
 enum {
 	ACX_WAKE_UP_CONDITIONS      = 0x0002,
 	ACX_MEM_CFG                 = 0x0003,
@@ -1064,5 +1079,7 @@ int wl1271_acx_init_mem_config(struct wl1271 *wl);
 int wl1271_acx_init_rx_interrupt(struct wl1271 *wl);
 int wl1271_acx_smart_reflex(struct wl1271 *wl);
 int wl1271_acx_bet_enable(struct wl1271 *wl, bool enable);
+int wl1271_acx_arp_ip_filter(struct wl1271 *wl, bool enable, u8 *address,
+			     u8 version);
 
 #endif /* __WL1271_ACX_H__ */
diff --git a/drivers/net/wireless/wl12xx/wl1271_main.c b/drivers/net/wireless/wl12xx/wl1271_main.c
index d6d1a4c..7d70f41 100644
--- a/drivers/net/wireless/wl12xx/wl1271_main.c
+++ b/drivers/net/wireless/wl12xx/wl1271_main.c
@@ -32,6 +32,7 @@
 #include <linux/etherdevice.h>
 #include <linux/vmalloc.h>
 #include <linux/spi/wl12xx.h>
+#include <linux/inetdevice.h>
 
 #include "wl1271.h"
 #include "wl12xx_80211.h"
@@ -325,6 +326,8 @@ static struct conf_drv_settings default_conf = {
 	}
 };
 
+static LIST_HEAD(wl_list);
+
 static void wl1271_conf_init(struct wl1271 *wl)
 {
 
@@ -843,6 +846,93 @@ static int wl1271_op_tx(struct ieee80211_hw *hw, struct sk_buff *skb)
 	return NETDEV_TX_OK;
 }
 
+static int wl1271_dev_notify(struct notifier_block *me, unsigned long what,
+			     void *arg)
+{
+	struct net_device *dev;
+	struct wireless_dev *wdev;
+	struct wiphy *wiphy;
+	struct ieee80211_hw *hw;
+	struct wl1271 *wl;
+	struct wl1271 *wl_temp;
+	struct in_device *idev;
+	struct in_ifaddr *ifa = arg;
+	int ret = 0;
+
+	/* FIXME: this ugly function should probably be implemented in the
+	 * mac80211, and here should only be a simple callback handling actual
+	 * setting of the filters. Now we need to dig up references to
+	 * various structures to gain access to what we need.
+	 * Also, because of this, there is no "initial" setting of the filter
+	 * in "op_start", because we don't want to dig up struct net_device
+	 * there - the filter will be set upon first change of the interface
+	 * IP address. */
+
+	dev = ifa->ifa_dev->dev;
+
+	wdev = dev->ieee80211_ptr;
+	if (wdev == NULL)
+		return -ENODEV;
+
+	wiphy = wdev->wiphy;
+	if (wiphy == NULL)
+		return -ENODEV;
+
+	hw = wiphy_priv(wiphy);
+	if (hw == NULL)
+		return -ENODEV;
+
+	/* Check that the interface is one supported by this driver. */
+	wl_temp = hw->priv;
+	list_for_each_entry(wl, &wl_list, list) {
+		if (wl == wl_temp)
+			break;
+	}
+	if (wl == NULL)
+		return -ENODEV;
+
+	/* Get the interface IP address for the device. "ifa" will become
+	   NULL if:
+	     - there is no IPV4 protocol address configured
+	     - there are multiple (virtual) IPV4 addresses configured
+	   When "ifa" is NULL, filtering will be disabled.
+	*/
+	ifa = NULL;
+	idev = dev->ip_ptr;
+	if (idev)
+		ifa = idev->ifa_list;
+
+	if (ifa && ifa->ifa_next)
+		ifa = NULL;
+
+	mutex_lock(&wl->mutex);
+
+	if (wl->state == WL1271_STATE_OFF)
+		goto out;
+
+	ret = wl1271_ps_elp_wakeup(wl, false);
+	if (ret < 0)
+		goto out;
+	if (ifa)
+		ret = wl1271_acx_arp_ip_filter(wl, true,
+					       (u8 *)&ifa->ifa_address,
+					       ACX_IPV4_VERSION);
+	else
+		ret = wl1271_acx_arp_ip_filter(wl, false, NULL,
+					       ACX_IPV4_VERSION);
+	wl1271_ps_elp_sleep(wl);
+
+out:
+	mutex_unlock(&wl->mutex);
+
+	return ret;
+}
+
+static struct notifier_block wl1271_dev_notifier = {
+	.notifier_call = wl1271_dev_notify,
+};
+
+
 static int wl1271_op_start(struct ieee80211_hw *hw)
 {
 	struct wl1271 *wl = hw->priv;
@@ -886,6 +976,11 @@ out_power_off:
 out:
 	mutex_unlock(&wl->mutex);
 
+	if (!ret) {
+		list_add(&wl->list, &wl_list);
+		register_inetaddr_notifier(&wl1271_dev_notifier);
+	}
+
 	return ret;
 }
 
@@ -906,6 +1001,9 @@ static void wl1271_op_stop(struct ieee80211_hw *hw)
 	wl->filter_params = NULL;
 	spin_unlock_irqrestore(&wl->wl_lock, flags);
 
+	unregister_inetaddr_notifier(&wl1271_dev_notifier);
+	list_del(&wl->list);
+
 	mutex_lock(&wl->mutex);
 
 	WARN_ON(wl->state != WL1271_STATE_ON);
@@ -1754,6 +1852,8 @@ static int __devinit wl1271_probe(struct spi_device *spi)
 	wl = hw->priv;
 	memset(wl, 0, sizeof(*wl));
 
+	INIT_LIST_HEAD(&wl->list);
+
 	wl->hw = hw;
 	dev_set_drvdata(&spi->dev, wl);
 	wl->spi = spi;
-- 
1.5.6.5

