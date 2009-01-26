Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.vyatta.com ([76.74.103.46]:41250 "EHLO mail.vyatta.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751747AbZAZSeg (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 26 Jan 2009 13:34:36 -0500
Received: from localhost (localhost.localdomain [127.0.0.1])
	by mail.vyatta.com (Postfix) with ESMTP id 469674F46FD
	for <linux-wireless@vger.kernel.org>; Mon, 26 Jan 2009 10:34:39 -0800 (PST)
Received: from mail.vyatta.com ([127.0.0.1])
	by localhost (mail.vyatta.com [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id qh+yD+-4BRCT for <linux-wireless@vger.kernel.org>;
	Mon, 26 Jan 2009 10:34:39 -0800 (PST)
Received: from s6510 (pool-96-225-207-155.ptldor.fios.verizon.net [96.225.207.155])
	by mail.vyatta.com (Postfix) with ESMTP id E99D64F46E7
	for <linux-wireless@vger.kernel.org>; Mon, 26 Jan 2009 10:34:38 -0800 (PST)
Date: Tue, 27 Jan 2009 05:33:57 +1100
From: Stephen Hemminger <shemminger@vyatta.com>
To: linux-wireless@vger.kernel.org
Subject: [PATCH] hostap: convert to net_device_ops
Message-ID: <20090127053357.689baabe@s6510> (sfid-20090126_193440_513507_1E7A82F0)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Convert to net_device_ops, compile tested only.

--- a/drivers/net/wireless/hostap/hostap_hw.c	2009-01-07 03:03:33.000000000 +1100
+++ b/drivers/net/wireless/hostap/hostap_hw.c	2009-01-25 21:10:43.977634507 +1100
@@ -3075,6 +3075,13 @@ static void prism2_set_lockdep_class(str
 	netdev_for_each_tx_queue(dev, prism2_set_lockdep_class_one, NULL);
 }
 
+static const struct net_device_ops hostap_netdev_ops = {
+	.ndo_start_xmit 	= hostap_master_start_xmit,
+	.ndo_change_mtu		= eth_change_mtu,
+	.ndo_set_mac_address 	= eth_mac_addr,
+	.ndo_validate_addr	= eth_validate_addr,
+};
+
 static struct net_device *
 prism2_init_local_data(struct prism2_helper_functions *funcs, int card_idx,
 		       struct device *sdev)
@@ -3228,9 +3235,9 @@ while (0)
 
 	hostap_setup_dev(dev, local, HOSTAP_INTERFACE_MASTER);
 
-	dev->hard_start_xmit = hostap_master_start_xmit;
 	dev->type = ARPHRD_IEEE80211;
 	dev->header_ops = &hostap_80211_ops;
+	dev->netdev_ops = &hostap_netdev-ops;
 
 	rtnl_lock();
 	ret = dev_alloc_name(dev, "wifi%d");
