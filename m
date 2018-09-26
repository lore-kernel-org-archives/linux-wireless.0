Return-Path: <SRS0=mZ/2=MI=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.4 required=3.0 tests=DKIMWL_WL_MED,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,USER_AGENT_GIT,USER_IN_DEF_DKIM_WL
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 59048C43382
	for <linux-wireless@archiver.kernel.org>; Wed, 26 Sep 2018 19:44:27 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id E802E21533
	for <linux-wireless@archiver.kernel.org>; Wed, 26 Sep 2018 19:44:26 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="PLy7rG1y"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org E802E21533
Authentication-Results: mail.kernel.org; dmarc=fail (p=reject dis=none) header.from=google.com
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-wireless-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726520AbeI0B6t (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Wed, 26 Sep 2018 21:58:49 -0400
Received: from mail-pg1-f201.google.com ([209.85.215.201]:56464 "EHLO
        mail-pg1-f201.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726416AbeI0B6s (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 26 Sep 2018 21:58:48 -0400
Received: by mail-pg1-f201.google.com with SMTP id 191-v6so97367pgb.23
        for <linux-wireless@vger.kernel.org>; Wed, 26 Sep 2018 12:44:16 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:message-id:mime-version:subject:from:to:cc;
        bh=RhXLlkCtPfj5sn7hhjwVJfEkOEsEBHmrporxw2aQKhg=;
        b=PLy7rG1y1foMeBUMOTptnFZxkEiwGRbTm3qJQpDjJJXXLKJN2RCKK34SIqJPm/20lr
         n4JJfk2DkNlKzzbvNPh4g7hC1yUFj3JoREBk7aErd21y6RDK2UHNotxWnLsBwzRfAIWi
         tMXXiNAQuz4m+ebPeCOULcFDtR09wtALUeWdP0j5KdAUPWz5CZjLw9uU7xGLzEYM3wpD
         1Knu+SO7XgA97uJolMqXh6i9b0bzgVy391tYEVcP6xT2IpmRm/eCcDLItr9IoAIl1g9Q
         tUxuYLephkcziSRpKrmFRTXXOC73WlBP72L1CXgAJRXetkHG/FheWkUi6mS0ia17EFs7
         WxnQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:message-id:mime-version:subject:from:to:cc;
        bh=RhXLlkCtPfj5sn7hhjwVJfEkOEsEBHmrporxw2aQKhg=;
        b=M7WwHyrO/0xH9/rncO0dhXI16K5ldVrgCjtDLnJr+oG32qi5X6JQcC13Hx2S09pRT0
         7YTYP2e3/OXG0uNZD/j54e8noxsbrGK05SAnpL9adcC+krqKiQgH9IgRFOkXPy3yncxe
         uZsRLBvZbfKTMyDaIHL4puxFVCOCSuJeeFavyxDci5AsR1wNaVrbK+20z1oaaYXnJl3Z
         s7ijBYQ4Z6YXHE8cPB82HrbOThtaysaBdXsEBwYsS/6A65EaWkBf92EBXuf2KzS8dOhH
         0bKdKwoJozs0nYUEndJC8b80YKUHMS4a8cKzEWJZwGPL7F+mT8ZlXk4l2cM4Pu0JceD1
         K3eg==
X-Gm-Message-State: ABuFfoic0uMEWsMOb0lBgixenYn5dv/kxd82qFn7VQlbheS1VrQyCTZ0
        qu6eSZ+6gdtRmu+Zdmxb0KuCMaeiEmEiQ2Hk
X-Google-Smtp-Source: ACcGV60LWE9jXTzPmX4OsClNHyrQamnPVkBujPCh1LBPNAyTD/dPdU/Ampy/q8Ur70jn1Hp+V3IJMTWLrCIZmowc
X-Received: by 2002:a65:6406:: with SMTP id a6-v6mr393980pgv.58.1537991056256;
 Wed, 26 Sep 2018 12:44:16 -0700 (PDT)
Date:   Wed, 26 Sep 2018 12:43:24 -0700
Message-Id: <20180926194324.71290-1-schuffelen@google.com>
Mime-Version: 1.0
X-Mailer: git-send-email 2.19.0.605.g01d371f741-goog
Subject: [PATCH net-next v2] wireless-drivers: rtnetlink wifi simulation device
From:   Cody Schuffelen <schuffelen@google.com>
To:     Johannes Berg <johannes@sipsolutions.net>
Cc:     Kalle Valo <kvalo@codeaurora.org>,
        "David S . Miller" <davem@davemloft.net>,
        linux-kernel@vger.kernel.org, linux-wireless@vger.kernel.org,
        netdev@vger.kernel.org, kernel-team@android.com,
        Cody Schuffelen <schuffelen@google.com>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

This device takes over an existing network device and produces a
new one that appears like a wireless connection, returning enough canned
responses to nl80211 to satisfy a standard network manager. If
necessary, it can also be set up one step removed from an existing
network device, such as through a vlan/80211Q or macvlan connection to
not disrupt the existing network interface.

To use it to wrap a bare ethernet connection:

ip link set eth0 down
ip link set eth0 name buried_eth0
ip link set buried_eth0 up
ip link add link buried_eth0 name wlan0 type virt_wifi

eth0 is renamed to buried_eth0 to avoid a network manager trying to
manage it, as the original network link will become unusuable and only
the wireless wrapper will be functional. This can also be combined with
vlan or macvlan links on top of eth0 to share the network between
distinct links, but that requires support outside the machine for
accepting vlan-tagged packets or packets from multiple MAC addresses.

This is being used for Google's Remote Android Virtual Device project,
which runs Android devices in virtual machines. The standard network
interfaces provided inside the virtual machines are all ethernet.
However, Android is not interested in ethernet devices and would rather
connect to a wireless interface. This patch allows the virtual machine
guest to treat one of its network connections as wireless rather than
ethernet, satisfying Android's network connection requirements.

We believe this is a generally useful driver for simulating wireless
network connections in other environments where a wireless connection is
desired by some userspace process but is not available. Future work can
also include exporting the wireless control plane to userspace, so the
device can configure the behavior of the simulated wireless network
itself.

This is distinct from other testing efforts such as mac80211_hwsim by
being a cfg80211 device instead of mac80211 device, allowing straight
pass-through on the data plane instead of forcing packaging of ethernet
data into mac80211 frames.

Signed-off-by: A. Cody Schuffelen <schuffelen@google.com>
Acked-by: Alistair Strachan <astrachan@google.com>
Acked-by: Greg Hartman <ghartman@google.com>
Signed-off-by: Cody Schuffelen <schuffelen@google.com>
---
Original change: https://lore.kernel.org/lkml/5b5b8e09.1c69fb81.c693c.0acd@mx.google.com/
First review: https://lore.kernel.org/lkml/1535460343.5895.56.camel@sipsolutions.net/

Thanks for the detailed review! I believe I've addressed all comments.

The problem we've experienced with routing the hwsim virtual medium from the
inside the VM to outside the VM is this required running hwsim on the host
kernel as well. This is too intrusive for our use-case, whereas wifi that
exists completely inside the VM kernel is much more palatable.

 drivers/net/wireless/Kconfig     |   7 +
 drivers/net/wireless/Makefile    |   2 +
 drivers/net/wireless/virt_wifi.c | 530 +++++++++++++++++++++++++++++++
 3 files changed, 539 insertions(+)
 create mode 100644 drivers/net/wireless/virt_wifi.c

diff --git a/drivers/net/wireless/Kconfig b/drivers/net/wireless/Kconfig
index 166920ae23f8..1781d8a7f05a 100644
--- a/drivers/net/wireless/Kconfig
+++ b/drivers/net/wireless/Kconfig
@@ -114,4 +114,11 @@ config USB_NET_RNDIS_WLAN
 
 	  If you choose to build a module, it'll be called rndis_wlan.
 
+config VIRT_WIFI
+	tristate "Wifi wrapper for ethernet drivers"
+	default n
+	---help---
+	  This option adds support for ethernet connections to appear as if they
+	  are wifi connections through a special rtnetlink device.
+
 endif # WLAN
diff --git a/drivers/net/wireless/Makefile b/drivers/net/wireless/Makefile
index 7fc96306712a..6cfe74515c95 100644
--- a/drivers/net/wireless/Makefile
+++ b/drivers/net/wireless/Makefile
@@ -27,3 +27,5 @@ obj-$(CONFIG_PCMCIA_WL3501)	+= wl3501_cs.o
 obj-$(CONFIG_USB_NET_RNDIS_WLAN)	+= rndis_wlan.o
 
 obj-$(CONFIG_MAC80211_HWSIM)	+= mac80211_hwsim.o
+
+obj-$(CONFIG_VIRT_WIFI)	+= virt_wifi.o
diff --git a/drivers/net/wireless/virt_wifi.c b/drivers/net/wireless/virt_wifi.c
new file mode 100644
index 000000000000..5dcfa4c3006d
--- /dev/null
+++ b/drivers/net/wireless/virt_wifi.c
@@ -0,0 +1,530 @@
+// SPDX-License-Identifier: GPL-2.0
+/* drivers/net/wireless/virt_wifi.c
+ *
+ * A fake implementation of cfg80211_ops that can be tacked on to an ethernet
+ * net_device to make it appear as a wireless connection.
+ *
+ * Copyright (C) 2018 Google, Inc.
+ *
+ * Author: schuffelen@google.com
+ */
+
+#include <net/cfg80211.h>
+#include <net/rtnetlink.h>
+#include <linux/etherdevice.h>
+#include <linux/module.h>
+
+struct virt_wifi_priv {
+	bool being_deleted;
+	bool is_connected;
+	struct net_device *netdev;
+	struct cfg80211_scan_request *scan_request;
+	struct delayed_work scan_result;
+	struct delayed_work scan_complete;
+	struct delayed_work connect;
+	struct delayed_work disconnect;
+	u16 disconnect_reason;
+};
+
+static struct ieee80211_channel channel_2ghz = {
+	.band = NL80211_BAND_2GHZ,
+	.center_freq = 5500,
+	.hw_value = 5500,
+
+	.flags = 0, /* ieee80211_channel_flags */
+	.max_antenna_gain = 20,
+	.max_power = 5500,
+	.max_reg_power = 9999,
+};
+
+static struct ieee80211_rate bitrates_2ghz[] = {
+	{
+		.bitrate = 10,
+	}, {
+		.bitrate = 20,
+	}, {
+		.bitrate = 55,
+	}, {
+		.bitrate = 60,
+	}, {
+		.bitrate = 110,
+	}, {
+		.bitrate = 120,
+	}, {
+		.bitrate = 240,
+	},
+};
+
+static struct ieee80211_supported_band band_2ghz = {
+	.channels = &channel_2ghz,
+	.bitrates = bitrates_2ghz,
+	.band = NL80211_BAND_2GHZ,
+	.n_channels = 1,
+	.n_bitrates = 7,
+	.ht_cap = {
+		.ht_supported = true,
+	},
+	.vht_cap = {
+		.vht_supported = true,
+	},
+};
+
+static struct ieee80211_channel channel_5ghz = {
+	.band = NL80211_BAND_5GHZ,
+	.center_freq = 5500,
+	.hw_value = 5500,
+
+	.flags = 0, /* ieee80211_channel_flags */
+	.max_antenna_gain = 20,
+	.max_power = 5500,
+	.max_reg_power = 9999,
+};
+
+static struct ieee80211_rate bitrates_5ghz[] = {
+	{
+		.bitrate = 60,
+	}, {
+		.bitrate = 120,
+	}, {
+		.bitrate = 240,
+	},
+};
+
+static struct ieee80211_supported_band band_5ghz = {
+	.channels = &channel_5ghz,
+	.bitrates = bitrates_5ghz,
+	.band = NL80211_BAND_5GHZ,
+	.n_channels = 1,
+	.n_bitrates = 3,
+	.ht_cap = {
+		.ht_supported = true,
+	},
+	.vht_cap = {
+		.vht_supported = true,
+	},
+};
+
+/** Assigned at module init. Guaranteed locally-administered and unicast. */
+static u8 fake_router_bssid[ETH_ALEN] = {};
+
+static int virt_wifi_scan(struct wiphy *wiphy,
+			  struct cfg80211_scan_request *request)
+{
+	struct virt_wifi_priv *priv = wiphy_priv(wiphy);
+
+	wiphy_debug(wiphy, "scan\n");
+
+	if (priv->scan_request || priv->being_deleted)
+		return -EBUSY;
+
+	priv->scan_request = request;
+	schedule_delayed_work(&priv->scan_result, HZ * 2);
+
+	return 0;
+}
+
+static void virt_wifi_scan_result(struct work_struct *work)
+{
+	char ssid[] = "__VirtWifi";
+	struct cfg80211_bss *informed_bss;
+	struct virt_wifi_priv *priv =
+		container_of(work, struct virt_wifi_priv,
+			     scan_result.work);
+	struct wiphy *wiphy = priv_to_wiphy(priv);
+	struct cfg80211_inform_bss mock_inform_bss = {
+		.chan = &channel_5ghz,
+		.scan_width = NL80211_BSS_CHAN_WIDTH_20,
+		.signal = -60,
+		.boottime_ns = ktime_get_boot_ns(),
+	};
+
+	ssid[0] = WLAN_EID_SSID;
+	/* size of the array minus null terminator, length byte, tag byte */
+	ssid[1] = sizeof(ssid) - 3;
+
+	informed_bss = cfg80211_inform_bss_data(wiphy, &mock_inform_bss,
+						CFG80211_BSS_FTYPE_PRESP,
+						fake_router_bssid,
+						mock_inform_bss.boottime_ns,
+						WLAN_CAPABILITY_ESS, 0, ssid,
+						/* Truncate before the null. */
+						sizeof(ssid) - 1, GFP_KERNEL);
+	cfg80211_put_bss(wiphy, informed_bss);
+
+	informed_bss = cfg80211_inform_bss_data(wiphy, &mock_inform_bss,
+						CFG80211_BSS_FTYPE_BEACON,
+						fake_router_bssid,
+						mock_inform_bss.boottime_ns,
+						WLAN_CAPABILITY_ESS, 0, ssid,
+						/* Truncate before the null. */
+						sizeof(ssid) - 1, GFP_KERNEL);
+	cfg80211_put_bss(wiphy, informed_bss);
+
+	schedule_delayed_work(&priv->scan_complete, HZ * 2);
+}
+
+static void virt_wifi_scan_complete(struct work_struct *work)
+{
+	struct virt_wifi_priv *priv =
+		container_of(work, struct virt_wifi_priv, scan_complete.work);
+	struct cfg80211_scan_info scan_info = {};
+
+	cfg80211_scan_done(priv->scan_request, &scan_info);
+	priv->scan_request = NULL;
+}
+
+static int virt_wifi_connect(struct wiphy *wiphy, struct net_device *netdev,
+			     struct cfg80211_connect_params *sme)
+{
+	struct virt_wifi_priv *priv = wiphy_priv(wiphy);
+	bool could_schedule;
+
+	if (priv->being_deleted)
+		return -EBUSY;
+
+	if (sme->bssid && !ether_addr_equal(sme->bssid, fake_router_bssid))
+		return -EINVAL;
+
+	wiphy_debug(wiphy, "connect\n");
+	could_schedule = schedule_delayed_work(&priv->connect, HZ * 2);
+	return could_schedule ? 0 : -EBUSY;
+}
+
+static void virt_wifi_connect_complete(struct work_struct *work)
+{
+	struct virt_wifi_priv *priv =
+		container_of(work, struct virt_wifi_priv, connect.work);
+
+	cfg80211_connect_result(priv->netdev, fake_router_bssid, NULL, 0, NULL,
+				0, 0, GFP_KERNEL);
+	priv->is_connected = true;
+}
+
+static int virt_wifi_disconnect(struct wiphy *wiphy, struct net_device *netdev,
+				u16 reason_code)
+{
+	struct virt_wifi_priv *priv = wiphy_priv(wiphy);
+	bool could_schedule;
+
+	if (priv->being_deleted)
+		return -EBUSY;
+
+	wiphy_debug(wiphy, "disconnect\n");
+	could_schedule = schedule_delayed_work(&priv->disconnect, HZ * 2);
+	if (!could_schedule)
+		return -EBUSY;
+	priv->disconnect_reason = reason_code;
+	return 0;
+}
+
+static void virt_wifi_disconnect_complete(struct work_struct *work)
+{
+	struct virt_wifi_priv *priv =
+		container_of(work, struct virt_wifi_priv, disconnect.work);
+
+	cfg80211_disconnected(priv->netdev, priv->disconnect_reason, NULL, 0,
+			      true, GFP_KERNEL);
+	priv->is_connected = false;
+}
+
+static int virt_wifi_get_station(struct wiphy *wiphy, struct net_device *dev,
+				 const u8 *mac, struct station_info *sinfo)
+{
+	wiphy_debug(wiphy, "get_station\n");
+	sinfo->filled = BIT(NL80211_STA_INFO_TX_PACKETS) |
+		BIT(NL80211_STA_INFO_TX_FAILED) | BIT(NL80211_STA_INFO_SIGNAL) |
+		BIT(NL80211_STA_INFO_TX_BITRATE);
+	sinfo->tx_packets = 1;
+	sinfo->tx_failed = 0;
+	sinfo->signal = -60;
+	sinfo->txrate = (struct rate_info) {
+		.legacy = 10, /* units are 100kbit/s */
+	};
+	return 0;
+}
+
+static int virt_wifi_dump_station(struct wiphy *wiphy, struct net_device *dev,
+				  int idx, u8 *mac, struct station_info *sinfo)
+{
+	wiphy_debug(wiphy, "dump_station\n");
+
+	if (idx != 0)
+		return -ENOENT;
+
+	ether_addr_copy(mac, fake_router_bssid);
+	return virt_wifi_get_station(wiphy, dev, fake_router_bssid, sinfo);
+}
+
+static const struct cfg80211_ops virt_wifi_cfg80211_ops = {
+	.scan = virt_wifi_scan,
+
+	.connect = virt_wifi_connect,
+	.disconnect = virt_wifi_disconnect,
+
+	.get_station = virt_wifi_get_station,
+	.dump_station = virt_wifi_dump_station,
+};
+
+static struct wireless_dev *virt_wireless_dev(struct device *device,
+					      struct net_device *netdev)
+{
+	struct wireless_dev *wdev;
+	struct wiphy *wiphy;
+	struct virt_wifi_priv *priv;
+
+	wdev = kzalloc(sizeof(*wdev), GFP_KERNEL);
+
+	if (!wdev)
+		return ERR_PTR(-ENOMEM);
+
+	wdev->iftype = NL80211_IFTYPE_STATION;
+	wiphy = wiphy_new(&virt_wifi_cfg80211_ops, sizeof(*priv));
+
+	if (!wiphy) {
+		kfree(wdev);
+		return ERR_PTR(-ENOMEM);
+	}
+
+	wdev->wiphy = wiphy;
+
+	wiphy->max_scan_ssids = 4;
+	wiphy->max_scan_ie_len = 1000;
+	wiphy->signal_type = CFG80211_SIGNAL_TYPE_MBM;
+
+	wiphy->bands[NL80211_BAND_2GHZ] = &band_2ghz;
+	wiphy->bands[NL80211_BAND_5GHZ] = &band_5ghz;
+	wiphy->bands[NL80211_BAND_60GHZ] = NULL;
+
+	/* Don't worry about frequency regulations. */
+	wiphy->regulatory_flags = REGULATORY_WIPHY_SELF_MANAGED;
+	wiphy->interface_modes = BIT(NL80211_IFTYPE_STATION);
+	set_wiphy_dev(wiphy, device);
+
+	priv = wiphy_priv(wiphy);
+	priv->being_deleted = false;
+	priv->is_connected = false;
+	priv->scan_request = NULL;
+	priv->netdev = netdev;
+	INIT_DELAYED_WORK(&priv->scan_result, virt_wifi_scan_result);
+	INIT_DELAYED_WORK(&priv->scan_complete, virt_wifi_scan_complete);
+	INIT_DELAYED_WORK(&priv->connect, virt_wifi_connect_complete);
+	INIT_DELAYED_WORK(&priv->disconnect, virt_wifi_disconnect_complete);
+	return wdev;
+}
+
+struct virt_wifi_netdev_priv {
+	struct net_device *lowerdev;
+	struct net_device *upperdev;
+	struct work_struct register_wiphy_work;
+};
+
+static netdev_tx_t virt_wifi_start_xmit(struct sk_buff *skb,
+					struct net_device *dev)
+{
+	struct virt_wifi_netdev_priv *priv = netdev_priv(dev);
+	struct virt_wifi_priv *w_priv = wiphy_priv(dev->ieee80211_ptr->wiphy);
+
+	if (!w_priv->is_connected)
+		return NETDEV_TX_BUSY;
+
+	skb->dev = priv->lowerdev;
+	return dev_queue_xmit(skb);
+}
+
+static const struct net_device_ops virt_wifi_ops = {
+	.ndo_start_xmit = virt_wifi_start_xmit,
+};
+
+static void free_netdev_and_wiphy(struct net_device *dev)
+{
+	struct virt_wifi_netdev_priv *priv = netdev_priv(dev);
+	struct virt_wifi_priv *w_priv;
+
+	flush_work(&priv->register_wiphy_work);
+	if (dev->ieee80211_ptr && !IS_ERR(dev->ieee80211_ptr)) {
+		w_priv = wiphy_priv(dev->ieee80211_ptr->wiphy);
+		w_priv->being_deleted = true;
+		flush_delayed_work(&w_priv->scan_result);
+		flush_delayed_work(&w_priv->scan_complete);
+		flush_delayed_work(&w_priv->connect);
+		flush_delayed_work(&w_priv->disconnect);
+
+		if (dev->ieee80211_ptr->wiphy->registered)
+			wiphy_unregister(dev->ieee80211_ptr->wiphy);
+		wiphy_free(dev->ieee80211_ptr->wiphy);
+		kfree(dev->ieee80211_ptr);
+	}
+	free_netdev(dev);
+}
+
+static void virt_wifi_setup(struct net_device *dev)
+{
+	ether_setup(dev);
+	dev->netdev_ops = &virt_wifi_ops;
+	dev->priv_destructor = free_netdev_and_wiphy;
+}
+
+/* Called under rcu_read_lock() from netif_receive_skb */
+static rx_handler_result_t virt_wifi_rx_handler(struct sk_buff **pskb)
+{
+	struct sk_buff *skb = *pskb;
+	struct virt_wifi_netdev_priv *priv =
+		rcu_dereference(skb->dev->rx_handler_data);
+	struct virt_wifi_priv *w_priv =
+		wiphy_priv(priv->upperdev->ieee80211_ptr->wiphy);
+
+	if (!w_priv->is_connected)
+		return RX_HANDLER_PASS;
+
+	/* GFP_ATOMIC because this is a packet interrupt handler. */
+	skb = skb_share_check(skb, GFP_ATOMIC);
+	if (!skb) {
+		dev_err(&priv->upperdev->dev, "can't skb_share_check\n");
+		return RX_HANDLER_CONSUMED;
+	}
+
+	*pskb = skb;
+	skb->dev = priv->upperdev;
+	skb->pkt_type = PACKET_HOST;
+	return RX_HANDLER_ANOTHER;
+}
+
+static void virt_wifi_register_wiphy(struct work_struct *work)
+{
+	struct virt_wifi_netdev_priv *priv =
+		container_of(work, struct virt_wifi_netdev_priv,
+			     register_wiphy_work);
+	struct wireless_dev *wdev = priv->upperdev->ieee80211_ptr;
+	int err;
+
+	err = wiphy_register(wdev->wiphy);
+	if (err < 0) {
+		dev_err(&priv->upperdev->dev, "can't wiphy_register (%d)\n",
+			err);
+
+		/* Roll back the net_device, it's not going to do wifi. */
+		rtnl_lock();
+		err = rtnl_delete_link(priv->upperdev);
+		rtnl_unlock();
+
+		/* rtnl_delete_link should only throw errors if it's not a
+		 * netlink device, but we know here it is already a virt_wifi
+		 * device.
+		 */
+		WARN_ONCE(err, "rtnl_delete_link failed on a virt_wifi device");
+	}
+}
+
+/* Called with rtnl lock held. */
+static int virt_wifi_newlink(struct net *src_net, struct net_device *dev,
+			     struct nlattr *tb[], struct nlattr *data[],
+			     struct netlink_ext_ack *extack)
+{
+	struct virt_wifi_netdev_priv *priv = netdev_priv(dev);
+	int err;
+
+	if (!tb[IFLA_LINK])
+		return -EINVAL;
+
+	priv->upperdev = dev;
+	priv->lowerdev = __dev_get_by_index(src_net,
+					    nla_get_u32(tb[IFLA_LINK]));
+
+	if (!priv->lowerdev)
+		return -ENODEV;
+	if (!tb[IFLA_MTU])
+		dev->mtu = priv->lowerdev->mtu;
+	else if (dev->mtu > priv->lowerdev->mtu)
+		return -EINVAL;
+
+	err = netdev_rx_handler_register(priv->lowerdev, virt_wifi_rx_handler,
+					 priv);
+	if (err != 0) {
+		dev_err(&priv->lowerdev->dev,
+			"can't netdev_rx_handler_register: %ld\n",
+			PTR_ERR(dev->ieee80211_ptr));
+		return err;
+	}
+
+	eth_hw_addr_inherit(dev, priv->lowerdev);
+	netif_stacked_transfer_operstate(priv->lowerdev, dev);
+
+	SET_NETDEV_DEV(dev, &priv->lowerdev->dev);
+	dev->ieee80211_ptr = virt_wireless_dev(&priv->lowerdev->dev, dev);
+
+	if (IS_ERR(dev->ieee80211_ptr)) {
+		dev_err(&priv->lowerdev->dev, "can't init wireless: %ld\n",
+			PTR_ERR(dev->ieee80211_ptr));
+		return PTR_ERR(dev->ieee80211_ptr);
+	}
+
+	err = register_netdevice(dev);
+	if (err) {
+		dev_err(&priv->lowerdev->dev, "can't register_netdevice: %d\n",
+			err);
+		goto remove_handler;
+	}
+
+	err = netdev_upper_dev_link(priv->lowerdev, dev, extack);
+	if (err) {
+		dev_err(&priv->lowerdev->dev, "can't netdev_upper_dev_link: %d\n",
+			err);
+		goto unregister_netdev;
+	}
+
+	/* The newlink callback is invoked while holding the rtnl lock, but
+	 * register_wiphy wants to claim the rtnl lock itself.
+	 */
+	INIT_WORK(&priv->register_wiphy_work, virt_wifi_register_wiphy);
+	schedule_work(&priv->register_wiphy_work);
+
+	return 0;
+remove_handler:
+	netdev_rx_handler_unregister(priv->lowerdev);
+unregister_netdev:
+	unregister_netdevice(dev);
+
+	return err;
+}
+
+/** Called with rtnl lock held. */
+static void virt_wifi_dellink(struct net_device *dev,
+			      struct list_head *head)
+{
+	struct virt_wifi_netdev_priv *priv = netdev_priv(dev);
+
+	netdev_rx_handler_unregister(priv->lowerdev);
+	netdev_upper_dev_unlink(priv->lowerdev, dev);
+
+	unregister_netdevice_queue(dev, head);
+
+	/* Deleting the wiphy is handled in the netdev destructor. */
+}
+
+static struct rtnl_link_ops virt_wifi_link_ops = {
+	.kind		= "virt_wifi",
+	.setup		= virt_wifi_setup,
+	.newlink	= virt_wifi_newlink,
+	.dellink	= virt_wifi_dellink,
+	.priv_size	= sizeof(struct virt_wifi_netdev_priv),
+};
+
+static int __init virt_wifi_init_module(void)
+{
+	/* Guaranteed to be locallly-administered and not multicast. */
+	eth_random_addr(fake_router_bssid);
+	return rtnl_link_register(&virt_wifi_link_ops);
+}
+
+static void __exit virt_wifi_cleanup_module(void)
+{
+	rtnl_link_unregister(&virt_wifi_link_ops);
+}
+
+module_init(virt_wifi_init_module);
+module_exit(virt_wifi_cleanup_module);
+
+MODULE_LICENSE("GPL v2");
+MODULE_AUTHOR("Cody Schuffelen <schuffelen@google.com>");
+MODULE_DESCRIPTION("Driver for a wireless wrapper of ethernet devices");
+MODULE_ALIAS_RTNL_LINK("virt_wifi");
-- 
2.19.0.605.g01d371f741-goog

