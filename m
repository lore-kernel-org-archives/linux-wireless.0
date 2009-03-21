Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from suva.vyatta.com ([76.74.103.44]:36701 "EHLO suva.vyatta.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1760779AbZCUFsW (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Sat, 21 Mar 2009 01:48:22 -0400
Message-Id: <20090321053717.601771143@vyatta.com> (sfid-20090321_065122_704364_56BF32DB)
References: <20090321053527.316395697@vyatta.com>
Date: Fri, 20 Mar 2009 22:36:33 -0700
From: Stephen Hemminger <shemminger@vyatta.com>
To: David Miller <davem@davemloft.net>, j@w1.fi
Cc: netdev@vger.kernel.org, linux-wireless@vger.kernel.org
Subject: [PATCH 66/77] mac80211_hwsim: convert to internal net_device_stats
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Signed-off-by: Stephen Hemminger <shemminger@vyatta.com>


--- a/drivers/net/wireless/mac80211_hwsim.c	2009-03-20 21:45:40.802964051 -0700
+++ b/drivers/net/wireless/mac80211_hwsim.c	2009-03-20 22:26:02.959027480 -0700
@@ -739,10 +739,16 @@ static struct device_driver mac80211_hws
 	.name = "mac80211_hwsim"
 };
 
+static const struct net_device_ops hwsim_netdev_ops = {
+	.ndo_start_xmit 	= hwsim_mon_xmit,
+	.ndo_change_mtu		= eth_change_mtu,
+	.ndo_set_mac_address 	= eth_mac_addr,
+	.ndo_validate_addr	= eth_validate_addr,
+};
 
 static void hwsim_mon_setup(struct net_device *dev)
 {
-	dev->hard_start_xmit = hwsim_mon_xmit;
+	dev->netdev_ops = &hwsim_netdev_ops;
 	dev->destructor = free_netdev;
 	ether_setup(dev);
 	dev->tx_queue_len = 0;

-- 

