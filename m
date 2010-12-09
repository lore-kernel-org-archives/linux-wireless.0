Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp2.it.da.ut.ee ([193.40.5.67]:46769 "EHLO smtp2.it.da.ut.ee"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755683Ab0LIXTZ (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 9 Dec 2010 18:19:25 -0500
Date: Fri, 10 Dec 2010 01:19:23 +0200 (EET)
From: Meelis Roos <mroos@linux.ee>
To: netdev@vger.kernel.org, Jouni Malinen <j@w1.fi>,
	linux-wireless@vger.kernel.org
Subject: [PATCH] fix hostap registration order
Message-ID: <alpine.SOC.1.00.1012100020110.26229@math.ut.ee>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

In 2.6.37-rc4, hostap_pci init gives a WARNING with backtrace telling 
that netif_stop_queue is called before register_netdev. Fix it by moving 
this call after register_netdev. Removes the warning and seems to work, 
but why is the call to netif_stop_queue needed at all after 
register_netdev?

Signed-off-by: Meelis Roos <mroos@linux.ee>

diff --git a/drivers/net/wireless/hostap/hostap_hw.c b/drivers/net/wireless/hostap/hostap_hw.c
index b7cb165..cc760c5 100644
--- a/drivers/net/wireless/hostap/hostap_hw.c
+++ b/drivers/net/wireless/hostap/hostap_hw.c
@@ -3253,6 +3253,8 @@ while (0)
 	}
 	printk(KERN_INFO "%s: Registered netdevice %s\n", dev_info, dev->name);
 
+	netif_stop_queue(dev);
+
 	hostap_init_data(local);
 	return dev;
 
diff --git a/drivers/net/wireless/hostap/hostap_main.c b/drivers/net/wireless/hostap/hostap_main.c
index 25a2722..0f1b202 100644
--- a/drivers/net/wireless/hostap/hostap_main.c
+++ b/drivers/net/wireless/hostap/hostap_main.c
@@ -100,6 +100,7 @@ struct net_device * hostap_add_interface(struct local_info *local,
 	printk(KERN_DEBUG "%s: registered netdevice %s\n",
 	       mdev->name, dev->name);
 
+	netif_stop_queue(dev);
 	return dev;
 }
 
@@ -891,7 +892,6 @@ void hostap_setup_dev(struct net_device *dev, local_info_t *local,
 
 	SET_ETHTOOL_OPS(dev, &prism2_ethtool_ops);
 
-	netif_stop_queue(dev);
 }
 
 static int hostap_enable_hostapd(local_info_t *local, int rtnl_locked)
-- 
Meelis Roos (mroos@linux.ee)
