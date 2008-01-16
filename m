Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s131.mittwaldmedien.de ([62.216.178.31]:23201 "EHLO
	s131.mittwaldmedien.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750762AbYAPO54 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 16 Jan 2008 09:57:56 -0500
From: Holger Schurig <hs4233@mail.mn-solutions.de>
To: "linux-wireless" <linux-wireless@vger.kernel.org>
Subject: [PATCH] libertas: pepper main with debug statement
Date: Wed, 16 Jan 2008 15:59:52 +0100
Cc: libertas-dev@lists.infradead.org,
	"John W. Linville" <linville@tuxdriver.com>,
	Dan Williams <dcbw@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Message-Id: <200801161559.52661.hs4233@mail.mn-solutions.de> (sfid-20080116_145801_341558_19F7631B)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

libertas: re-pepper debug statementThe recent fluff of updates
didn't put proper lbs_deb_enter/leave calls into the source code.
Add them where appropriate.

Also contains some whitespace changes.

Signed-off-by: Holger Schurig <hs4233@mail.mn-solutions.de>

Index: wireless-2.6/drivers/net/wireless/libertas/main.c
===================================================================
--- wireless-2.6.orig/drivers/net/wireless/libertas/main.c	2008-01-16 12:59:09.000000000 +0100
+++ wireless-2.6/drivers/net/wireless/libertas/main.c	2008-01-16 14:07:20.000000000 +0100
@@ -388,6 +388,8 @@ static int lbs_dev_open(struct net_devic
 	struct lbs_private *priv = (struct lbs_private *) dev->priv ;
 	int ret = 0;
 
+	lbs_deb_enter(LBS_DEB_NET);
+
 	spin_lock_irq(&priv->driver_lock);
 
 	if (priv->monitormode != LBS_MONITOR_OFF) {
@@ -413,6 +415,7 @@ static int lbs_dev_open(struct net_devic
  out:
 
 	spin_unlock_irq(&priv->driver_lock);
+	lbs_deb_leave_args(LBS_DEB_NET, "ret %d", ret);
 	return ret;
 }
 
@@ -426,6 +429,7 @@ static int lbs_mesh_stop(struct net_devi
 {
 	struct lbs_private *priv = (struct lbs_private *) (dev->priv);
 
+	lbs_deb_enter(LBS_DEB_MESH);
 	spin_lock_irq(&priv->driver_lock);
 
 	priv->mesh_open = 0;
@@ -435,6 +439,8 @@ static int lbs_mesh_stop(struct net_devi
 	netif_carrier_off(dev);
 
 	spin_unlock_irq(&priv->driver_lock);
+
+	lbs_deb_leave(LBS_DEB_MESH);
 	return 0;
 }
 
@@ -448,13 +454,14 @@ static int lbs_eth_stop(struct net_devic
 {
 	struct lbs_private *priv = (struct lbs_private *) dev->priv;
 
-	spin_lock_irq(&priv->driver_lock);
+	lbs_deb_enter(LBS_DEB_NET);
 
+	spin_lock_irq(&priv->driver_lock);
 	priv->infra_open = 0;
-
 	netif_stop_queue(dev);
-
 	spin_unlock_irq(&priv->driver_lock);
+
+	lbs_deb_leave(LBS_DEB_NET);
 	return 0;
 }
 
@@ -490,6 +497,8 @@ void lbs_host_to_card_done(struct lbs_pr
 {
 	unsigned long flags;
 
+	lbs_deb_enter(LBS_DEB_THREAD);
+
 	spin_lock_irqsave(&priv->driver_lock, flags);
 
 	priv->dnld_sent = DNLD_RES_RECEIVED;
@@ -499,6 +508,7 @@ void lbs_host_to_card_done(struct lbs_pr
 		wake_up_interruptible(&priv->waitq);
 
 	spin_unlock_irqrestore(&priv->driver_lock, flags);
+	lbs_deb_leave(LBS_DEB_THREAD);
 }
 EXPORT_SYMBOL_GPL(lbs_host_to_card_done);
 
@@ -512,6 +522,7 @@ static struct net_device_stats *lbs_get_
 {
 	struct lbs_private *priv = (struct lbs_private *) dev->priv;
 
+	lbs_deb_enter(LBS_DEB_NET);
 	return &priv->stats;
 }
 
@@ -564,9 +575,7 @@ static int lbs_copy_multicast_address(st
 		memcpy(&priv->multicastlist[i], mcptr->dmi_addr, ETH_ALEN);
 		mcptr = mcptr->next;
 	}
-
 	return i;
-
 }
 
 static void lbs_set_multicast_list(struct net_device *dev)
@@ -620,7 +629,7 @@ static void lbs_set_multicast_list(struc
 				       dev->mc_count);
 
 				for (i = 0; i < dev->mc_count; i++) {
-					lbs_deb_net("Multicast address %d:%s\n",
+					lbs_deb_net("Multicast address %d: %s\n",
 					       i, print_mac(mac,
 					       priv->multicastlist[i]));
 				}
@@ -857,22 +866,24 @@ static int lbs_thread(void *data)
 static int lbs_suspend_callback(struct lbs_private *priv, unsigned long dummy,
 				struct cmd_header *cmd)
 {
-	lbs_deb_fw("HOST_SLEEP_ACTIVATE succeeded\n");
+	lbs_deb_enter(LBS_DEB_FW);
 
 	netif_device_detach(priv->dev);
 	if (priv->mesh_dev)
 		netif_device_detach(priv->mesh_dev);
 
 	priv->fw_ready = 0;
+	lbs_deb_leave(LBS_DEB_FW);
 	return 0;
 }
 
-
 int lbs_suspend(struct lbs_private *priv)
 {
 	struct cmd_header cmd;
 	int ret;
 
+	lbs_deb_enter(LBS_DEB_FW);
+
 	if (priv->wol_criteria == 0xffffffff) {
 		lbs_pr_info("Suspend attempt without configuring wake params!\n");
 		return -EINVAL;
@@ -885,12 +896,15 @@ int lbs_suspend(struct lbs_private *priv
 	if (ret)
 		lbs_pr_info("HOST_SLEEP_ACTIVATE failed: %d\n", ret);
 
+	lbs_deb_leave_args(LBS_DEB_FW, "ret %d", ret);
 	return ret;
 }
 EXPORT_SYMBOL_GPL(lbs_suspend);
 
 int lbs_resume(struct lbs_private *priv)
 {
+	lbs_deb_enter(LBS_DEB_FW);
+
 	priv->fw_ready = 1;
 
 	/* Firmware doesn't seem to give us RX packets any more
@@ -902,6 +916,7 @@ int lbs_resume(struct lbs_private *priv)
 	if (priv->mesh_dev)
 		netif_device_attach(priv->mesh_dev);
 
+	lbs_deb_leave(LBS_DEB_FW);
 	return 0;
 }
 EXPORT_SYMBOL_GPL(lbs_resume);
@@ -953,6 +968,7 @@ static void command_timer_fn(unsigned lo
 	struct lbs_private *priv = (struct lbs_private *)data;
 	unsigned long flags;
 
+	lbs_deb_enter(LBS_DEB_CMD);
 	spin_lock_irqsave(&priv->driver_lock, flags);
 
 	if (!priv->cur_cmd) {
@@ -964,8 +980,9 @@ static void command_timer_fn(unsigned lo
 
 	priv->cmd_timed_out = 1;
 	wake_up_interruptible(&priv->waitq);
- out:
+out:
 	spin_unlock_irqrestore(&priv->driver_lock, flags);
+	lbs_deb_leave(LBS_DEB_CMD);
 }
 
 static int lbs_init_adapter(struct lbs_private *priv)
@@ -973,6 +990,8 @@ static int lbs_init_adapter(struct lbs_p
 	size_t bufsize;
 	int i, ret = 0;
 
+	lbs_deb_enter(LBS_DEB_MAIN);
+
 	/* Allocate buffer to store the BSSID list */
 	bufsize = MAX_NETWORK_COUNT * sizeof(struct bss_descriptor);
 	priv->networks = kzalloc(bufsize, GFP_KERNEL);
@@ -1015,7 +1034,7 @@ static int lbs_init_adapter(struct lbs_p
 	mutex_init(&priv->lock);
 
 	setup_timer(&priv->command_timer, command_timer_fn,
-	            (unsigned long)priv);
+		(unsigned long)priv);
 
 	INIT_LIST_HEAD(&priv->cmdfreeq);
 	INIT_LIST_HEAD(&priv->cmdpendingq);
@@ -1030,20 +1049,21 @@ static int lbs_init_adapter(struct lbs_p
 	}
 
 out:
+	lbs_deb_leave_args(LBS_DEB_MAIN, "ret %d", ret);
+
 	return ret;
 }
 
 static void lbs_free_adapter(struct lbs_private *priv)
 {
-	lbs_deb_fw("free command buffer\n");
-	lbs_free_cmd_buffer(priv);
+	lbs_deb_enter(LBS_DEB_MAIN);
 
-	lbs_deb_fw("free command_timer\n");
+	lbs_free_cmd_buffer(priv);
 	del_timer(&priv->command_timer);
-
-	lbs_deb_fw("free scan results table\n");
 	kfree(priv->networks);
 	priv->networks = NULL;
+
+	lbs_deb_leave(LBS_DEB_MAIN);
 }
 
 /**
@@ -1058,7 +1078,7 @@ struct lbs_private *lbs_add_card(void *c
 	struct net_device *dev = NULL;
 	struct lbs_private *priv = NULL;
 
-	lbs_deb_enter(LBS_DEB_NET);
+	lbs_deb_enter(LBS_DEB_MAIN);
 
 	/* Allocate an Ethernet device and register it */
 	dev = alloc_etherdev(sizeof(struct lbs_private));
@@ -1124,7 +1144,7 @@ err_init_adapter:
 	priv = NULL;
 
 done:
-	lbs_deb_leave_args(LBS_DEB_NET, "priv %p", priv);
+	lbs_deb_leave_args(LBS_DEB_MAIN, "priv %p", priv);
 	return priv;
 }
 EXPORT_SYMBOL_GPL(lbs_add_card);
@@ -1338,26 +1358,19 @@ static void lbs_remove_mesh(struct lbs_p
 {
 	struct net_device *mesh_dev;
 
-	lbs_deb_enter(LBS_DEB_MAIN);
-
-	if (!priv)
-		goto out;
 
 	mesh_dev = priv->mesh_dev;
 	if (!mesh_dev)
-		goto out;
+		return;
 
+	lbs_deb_enter(LBS_DEB_MESH);
 	netif_stop_queue(mesh_dev);
 	netif_carrier_off(priv->mesh_dev);
-
 	sysfs_remove_group(&(mesh_dev->dev.kobj), &lbs_mesh_attr_group);
 	unregister_netdev(mesh_dev);
-
 	priv->mesh_dev = NULL;
 	free_netdev(mesh_dev);
-
-out:
-	lbs_deb_leave(LBS_DEB_MAIN);
+	lbs_deb_leave(LBS_DEB_MESH);
 }
 EXPORT_SYMBOL_GPL(lbs_remove_mesh);
 
@@ -1404,22 +1417,20 @@ int lbs_set_regiontable(struct lbs_priva
 
 	memset(priv->region_channel, 0, sizeof(priv->region_channel));
 
-	{
-		cfp = lbs_get_region_cfp_table(region, band, &cfp_no);
-		if (cfp != NULL) {
-			priv->region_channel[i].nrcfp = cfp_no;
-			priv->region_channel[i].CFP = cfp;
-		} else {
-			lbs_deb_main("wrong region code %#x in band B/G\n",
-			       region);
-			ret = -1;
-			goto out;
-		}
-		priv->region_channel[i].valid = 1;
-		priv->region_channel[i].region = region;
-		priv->region_channel[i].band = band;
-		i++;
+	cfp = lbs_get_region_cfp_table(region, band, &cfp_no);
+	if (cfp != NULL) {
+		priv->region_channel[i].nrcfp = cfp_no;
+		priv->region_channel[i].CFP = cfp;
+	} else {
+		lbs_deb_main("wrong region code %#x in band B/G\n",
+		       region);
+		ret = -1;
+		goto out;
 	}
+	priv->region_channel[i].valid = 1;
+	priv->region_channel[i].region = region;
+	priv->region_channel[i].band = band;
+	i++;
 out:
 	lbs_deb_leave_args(LBS_DEB_MAIN, "ret %d", ret);
 	return ret;
@@ -1438,12 +1449,9 @@ void lbs_interrupt(struct lbs_private *p
 	lbs_deb_enter(LBS_DEB_THREAD);
 
 	lbs_deb_thread("lbs_interrupt: intcounter=%d\n", priv->intcounter);
-
 	priv->intcounter++;
-
 	if (priv->psstate == PS_STATE_SLEEP)
 		priv->psstate = PS_STATE_AWAKE;
-
 	wake_up_interruptible(&priv->waitq);
 
 	lbs_deb_leave(LBS_DEB_THREAD);
@@ -1475,9 +1483,7 @@ static int __init lbs_init_module(void)
 static void __exit lbs_exit_module(void)
 {
 	lbs_deb_enter(LBS_DEB_MAIN);
-
 	lbs_debugfs_remove();
-
 	lbs_deb_leave(LBS_DEB_MAIN);
 }
 
@@ -1488,49 +1494,61 @@ static void __exit lbs_exit_module(void)
 static int lbs_rtap_open(struct net_device *dev)
 {
 	/* Yes, _stop_ the queue. Because we don't support injection */
-        netif_carrier_off(dev);
-        netif_stop_queue(dev);
-        return 0;
+	lbs_deb_enter(LBS_DEB_MAIN);
+	netif_carrier_off(dev);
+	netif_stop_queue(dev);
+	lbs_deb_leave(LBS_DEB_LEAVE);
+	return 0;
 }
 
 static int lbs_rtap_stop(struct net_device *dev)
 {
-        return 0;
+	lbs_deb_enter(LBS_DEB_MAIN);
+	lbs_deb_leave(LBS_DEB_MAIN);
+	return 0;
 }
 
 static int lbs_rtap_hard_start_xmit(struct sk_buff *skb, struct net_device *dev)
 {
-        netif_stop_queue(dev);
-        return NETDEV_TX_BUSY;
+	netif_stop_queue(dev);
+	return NETDEV_TX_BUSY;
 }
 
 static struct net_device_stats *lbs_rtap_get_stats(struct net_device *dev)
 {
 	struct lbs_private *priv = dev->priv;
+	lbs_deb_enter(LBS_DEB_NET);
 	return &priv->stats;
 }
 
 
 static void lbs_remove_rtap(struct lbs_private *priv)
 {
+	lbs_deb_enter(LBS_DEB_MAIN);
 	if (priv->rtap_net_dev == NULL)
 		return;
 	unregister_netdev(priv->rtap_net_dev);
 	free_netdev(priv->rtap_net_dev);
 	priv->rtap_net_dev = NULL;
+	lbs_deb_leave(LBS_DEB_MAIN);
 }
 
 static int lbs_add_rtap(struct lbs_private *priv)
 {
-	int rc = 0;
+	int ret = 0;
 	struct net_device *rtap_dev;
 
-	if (priv->rtap_net_dev)
-		return -EPERM;
+	lbs_deb_enter(LBS_DEB_MAIN);
+	if (priv->rtap_net_dev) {
+		ret = -EPERM;
+		goto out;
+	}
 
 	rtap_dev = alloc_netdev(0, "rtap%d", ether_setup);
-	if (rtap_dev == NULL)
-		return -ENOMEM;
+	if (rtap_dev == NULL) {
+		ret = -ENOMEM;
+		goto out;
+	}
 
 	memcpy(rtap_dev->dev_addr, priv->current_addr, ETH_ALEN);
 	rtap_dev->type = ARPHRD_IEEE80211_RADIOTAP;
@@ -1541,14 +1559,16 @@ static int lbs_add_rtap(struct lbs_priva
 	rtap_dev->set_multicast_list = lbs_set_multicast_list;
 	rtap_dev->priv = priv;
 
-	rc = register_netdev(rtap_dev);
-	if (rc) {
+	ret = register_netdev(rtap_dev);
+	if (ret) {
 		free_netdev(rtap_dev);
-		return rc;
+		goto out;
 	}
 	priv->rtap_net_dev = rtap_dev;
 
-	return 0;
+out:
+	lbs_deb_leave_args(LBS_DEB_MAIN, "ret %d", ret);
+	return ret;
 }
 
 
