Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from fg-out-1718.google.com ([72.14.220.154]:38321 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752740AbYHNRku (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 14 Aug 2008 13:40:50 -0400
Received: by fg-out-1718.google.com with SMTP id 19so461794fgg.17
        for <linux-wireless@vger.kernel.org>; Thu, 14 Aug 2008 10:40:49 -0700 (PDT)
To: linux-wireless@vger.kernel.org
Cc: linville@tuxdriver.com, johannes@sipsolutions.net, dcbw@redhat.com
From: Luis Carlos Cobo <luisca@cozybit.com>
Subject: [PATCHv2 1/6] mac80211: allow no mac address until firmware load
Date: Thu, 14 Aug 2008 10:40:48 -0700 (PDT)
Message-ID: <48a46e20.0407560a.399c.ffffa75f@mx.google.com> (sfid-20080814_194052_886264_44746B22)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Originally by Johannes Berg. This patch adds support for devices that do not
report their MAC address until the firmware is loaded. While the address is not
known, a multicast on is used.

Signed-off-by: Luis Carlos Cobo <luisca@cozybit.com>
---
 net/mac80211/main.c |   38 ++++++++++++++++++++++++++++++++++++++
 1 files changed, 38 insertions(+), 0 deletions(-)

diff --git a/net/mac80211/main.c b/net/mac80211/main.c
index aa5a191..5a70583 100644
--- a/net/mac80211/main.c
+++ b/net/mac80211/main.c
@@ -187,9 +187,15 @@ static int ieee80211_open(struct net_device *dev)
 	u32 changed = 0;
 	int res;
 	bool need_hw_reconfig = 0;
+	u8 null_addr[ETH_ALEN] = {0};
 
 	sdata = IEEE80211_DEV_TO_SUB_IF(dev);
 
+	/* fail early if user set an invalid address */
+	if (compare_ether_addr(dev->dev_addr, null_addr) &&
+	    !is_valid_ether_addr(dev->dev_addr))
+		return -EADDRNOTAVAIL;
+
 	/* we hold the RTNL here so can safely walk the list */
 	list_for_each_entry(nsdata, &local->interfaces, list) {
 		struct net_device *ndev = nsdata->dev;
@@ -270,6 +276,36 @@ static int ieee80211_open(struct net_device *dev)
 		ieee80211_led_radio(local, local->hw.conf.radio_enabled);
 	}
 
+	/*
+	 * Check all interfaces and copy the hopefully now-present
+	 * MAC address to those that have the special null one.
+	 */
+	list_for_each_entry(nsdata, &local->interfaces, list) {
+		struct net_device *ndev = nsdata->dev;
+
+		/*
+		 * No need to check netif_running since we do not allow
+		 * it to start up with this invalid address.
+		 */
+		if (compare_ether_addr(null_addr, ndev->dev_addr) == 0)
+			memcpy(ndev->dev_addr,
+			       local->hw.wiphy->perm_addr,
+			       ETH_ALEN);
+	}
+
+	if (compare_ether_addr(null_addr, local->mdev->dev_addr) == 0)
+		memcpy(local->mdev->dev_addr, local->hw.wiphy->perm_addr,
+		       ETH_ALEN);
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
 		/* no need to tell driver */
@@ -975,6 +1011,8 @@ void ieee80211_if_setup(struct net_device *dev)
 	dev->open = ieee80211_open;
 	dev->stop = ieee80211_stop;
 	dev->destructor = free_netdev;
+	/* we will validate the address ourselves in ->open */
+	dev->validate_addr = NULL;
 }
 
 /* everything else */
-- 
1.5.4.3



