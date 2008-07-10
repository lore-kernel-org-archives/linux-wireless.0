Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wa-out-1112.google.com ([209.85.146.179]:65489 "EHLO
	wa-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752441AbYGJQ1J (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 10 Jul 2008 12:27:09 -0400
Received: by wa-out-1112.google.com with SMTP id j37so2079436waf.23
        for <linux-wireless@vger.kernel.org>; Thu, 10 Jul 2008 09:27:08 -0700 (PDT)
To: linux-wireless@vger.kernel.org
Cc: johannes@sipsolutions.net
From: Luis Carlos Cobo <luisca@cozybit.com>
Date: Thu, 10 Jul 2008 16:57:25 +0200
Subject: [PATCH 1/6] mac80211: allow no mac address until firmware load
Message-ID: <48763814.27052c0a.1794.2095@mx.google.com> (sfid-20080710_182713_086368_4756C52A)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Originally by Johannes Berg. This patch adds support for devices that do not
report their MAC address until the firmware is loaded. While the address is not
known, a multicast on is used.

Signed-off-by: Luis Carlos Cobo <luisca@cozybit.com>
Tested-by: Javier Cardona <javier@cozybit.com>
---
 net/mac80211/ieee80211_i.h |    1 +
 net/mac80211/main.c        |   61 ++++++++++++++++++++++++++++++++++++++++++++
 2 files changed, 62 insertions(+), 0 deletions(-)

diff --git a/net/mac80211/ieee80211_i.h b/net/mac80211/ieee80211_i.h
index c916c2f..8e8c0eb 100644
--- a/net/mac80211/ieee80211_i.h
+++ b/net/mac80211/ieee80211_i.h
@@ -551,6 +551,7 @@ struct ieee80211_local {
 	const struct ieee80211_ops *ops;
 
 	struct net_device *mdev; /* wmaster# - "master" 802.11 device */
+	unsigned int hwid;
 	int open_count;
 	int monitors, cooked_mntrs;
 	/* number of interfaces with corresponding FIF_ flags */
diff --git a/net/mac80211/main.c b/net/mac80211/main.c
index cf477ad..2204aa5 100644
--- a/net/mac80211/main.c
+++ b/net/mac80211/main.c
@@ -178,6 +178,20 @@ static inline int identical_mac_addr_allowed(int type1, int type2)
 		  type2 == IEEE80211_IF_TYPE_VLAN)));
 }
 
+static void calculate_invalid_mac(u8 *addr, unsigned int hwid)
+{
+	/*
+	 * Random multicast, private use address with hwid mixed in.
+	 * Must be multicast to let is_valid_ether_addr() fail on it.
+	 */
+	addr[0] = 0xe7;
+	addr[1] = 0xc4;
+	addr[2] = 0x2e ^ ((hwid >> 24) & 0xFF);
+	addr[3] = 0xdd ^ ((hwid >> 16) & 0xFF);
+	addr[4] = 0xcb ^ ((hwid >>  8) & 0xFF);
+	addr[5] = 0x8c ^ ((hwid >>  0) & 0xFF);
+}
+
 static int ieee80211_open(struct net_device *dev)
 {
 	struct ieee80211_sub_if_data *sdata, *nsdata;
@@ -187,9 +201,17 @@ static int ieee80211_open(struct net_device *dev)
 	u32 changed = 0;
 	int res;
 	bool need_hw_reconfig = 0;
+	u8 inval_addr[ETH_ALEN];
 
 	sdata = IEEE80211_DEV_TO_SUB_IF(dev);
 
+	calculate_invalid_mac(inval_addr, local->hwid);
+
+	/* fail early if user set an invalid address */
+	if (compare_ether_addr(dev->dev_addr, inval_addr) &&
+	    !is_valid_ether_addr(dev->dev_addr))
+		return -EADDRNOTAVAIL;
+
 	/* we hold the RTNL here so can safely walk the list */
 	list_for_each_entry(nsdata, &local->interfaces, list) {
 		struct net_device *ndev = nsdata->dev;
@@ -288,6 +310,32 @@ static int ieee80211_open(struct net_device *dev)
 		ieee80211_led_radio(local, local->hw.conf.radio_enabled);
 	}
 
+	/*
+	 * Check all interfaces and copy the hopefully now-present
+	 * MAC address to those that have the special invalid one.
+	 */
+	list_for_each_entry(nsdata, &local->interfaces, list) {
+		struct net_device *ndev = nsdata->dev;
+
+		/*
+		 * No need to check netif_running since we do not allow
+		 * it to start up with this invalid address.
+		 */
+		if (compare_ether_addr(inval_addr, ndev->dev_addr) == 0)
+			memcpy(ndev->dev_addr,
+			       local->hw.wiphy->perm_addr,
+			       ETH_ALEN);
+	}
+
+	/*
+	 * Validate the MAC address for this device.
+	 */
+	if (!is_valid_ether_addr(dev->dev_addr)) {
+		if (!local->open_count && local->ops->stop)
+			local->ops->stop(local_to_hw(local));
+		return -EADDRNOTAVAIL;
+	}
+
 	switch (sdata->vif.type) {
 	case IEEE80211_IF_TYPE_VLAN:
 		list_add(&sdata->u.vlan.list, &sdata->u.vlan.ap->u.ap.vlans);
@@ -995,6 +1043,8 @@ void ieee80211_if_setup(struct net_device *dev)
 	dev->open = ieee80211_open;
 	dev->stop = ieee80211_stop;
 	dev->destructor = ieee80211_if_free;
+	/* we will validate the address ourselves in ->open */
+	dev->validate_addr = NULL;
 }
 
 /* everything else */
@@ -1571,6 +1621,8 @@ struct ieee80211_hw *ieee80211_alloc_hw(size_t priv_data_len,
 	struct ieee80211_local *local;
 	int priv_size;
 	struct wiphy *wiphy;
+	static atomic_t hw_counter = ATOMIC_INIT(0);
+	u8 inval_addr[ETH_ALEN];
 
 	/* Ensure 32-byte alignment of our private data and hw private data.
 	 * We use the wiphy priv data for both our ieee80211_local and for
@@ -1601,6 +1653,15 @@ struct ieee80211_hw *ieee80211_alloc_hw(size_t priv_data_len,
 	local = wiphy_priv(wiphy);
 	local->hw.wiphy = wiphy;
 
+	/*
+	 * Hack for devices that cannot read the mac address until they are
+	 * started... keep an invalid multicast address as the device MAC...
+	 * Read on in ieee80211_open().
+	 */
+	local->hwid = atomic_inc_return(&hw_counter);
+	calculate_invalid_mac(inval_addr, local->hwid);
+	memcpy(local->hw.wiphy->perm_addr, inval_addr, ETH_ALEN);
+
 	local->hw.priv = (char *)local +
 			 ((sizeof(struct ieee80211_local) +
 			   NETDEV_ALIGN_CONST) & ~NETDEV_ALIGN_CONST);
-- 
1.5.4.3



