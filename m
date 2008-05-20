Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([18.85.46.34]:51516 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754664AbYETNTe (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 20 May 2008 09:19:34 -0400
Subject: Re: [PATCH] libertas: fix multicast filtering on eth and msh
	interfaces.
From: David Woodhouse <dwmw2@infradead.org>
To: Holger Schurig <hs4233@mail.mn-solutions.de>
Cc: libertas-dev@lists.infradead.org, linux-wireless@vger.kernel.org,
	linville@tuxdriver.com
In-Reply-To: <200805200951.14516.hs4233@mail.mn-solutions.de>
References: <1211208955.21380.163.camel@pmac.infradead.org>
	 <200805200951.14516.hs4233@mail.mn-solutions.de>
Content-Type: text/plain
Date: Tue, 20 May 2008 14:19:30 +0100
Message-Id: <1211289570.21380.219.camel@pmac.infradead.org> (sfid-20080520_152031_568293_9DB7CE36)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, 2008-05-20 at 09:51 +0200, Holger Schurig wrote:
> The whole warning was: Warning: trailing whitespace in lines
> 621,625,654 of drivers/net/wireless/libertas/main.c.

Thanks; I'll send an updated patch. Must remember to run checkpatch.pl.

I also shouldn't be using dev_get_flags() -- that's just for userspace
and won't include IFF_PROMISC or IFF_ALLMULTI when I need it to. And
I've cleaned up the loop over priv->dev and priv->mesh_dev to use a
helper function.

I also put the warning printk change into a separate commit. This is
what I've got in git://git.infradead.org/~dwmw2/libertas-2.6.git now:

diff --git a/drivers/net/wireless/libertas/cmd.c b/drivers/net/wireless/libertas/cmd.c
index bed68e9..b494aba 100644
--- a/drivers/net/wireless/libertas/cmd.c
+++ b/drivers/net/wireless/libertas/cmd.c
@@ -746,28 +746,6 @@ out:
 	return ret;
 }
 
-static int lbs_cmd_mac_multicast_adr(struct lbs_private *priv,
-				      struct cmd_ds_command *cmd,
-				      u16 cmd_action)
-{
-	struct cmd_ds_mac_multicast_adr *pMCastAdr = &cmd->params.madr;
-
-	lbs_deb_enter(LBS_DEB_CMD);
-	cmd->size = cpu_to_le16(sizeof(struct cmd_ds_mac_multicast_adr) +
-			     S_DS_GEN);
-	cmd->command = cpu_to_le16(CMD_MAC_MULTICAST_ADR);
-
-	lbs_deb_cmd("MULTICAST_ADR: setting %d addresses\n", pMCastAdr->nr_of_adrs);
-	pMCastAdr->action = cpu_to_le16(cmd_action);
-	pMCastAdr->nr_of_adrs =
-	    cpu_to_le16((u16) priv->nr_of_multicastmacaddr);
-	memcpy(pMCastAdr->maclist, priv->multicastlist,
-	       priv->nr_of_multicastmacaddr * ETH_ALEN);
-
-	lbs_deb_leave(LBS_DEB_CMD);
-	return 0;
-}
-
 /**
  *  @brief Get the radio channel
  *
@@ -1247,8 +1225,7 @@ void lbs_set_mac_control(struct lbs_private *priv)
 	cmd.action = cpu_to_le16(priv->mac_control);
 	cmd.reserved = 0;
 
-	lbs_cmd_async(priv, CMD_MAC_CONTROL,
-		&cmd.hdr, sizeof(cmd));
+	lbs_cmd_async(priv, CMD_MAC_CONTROL, &cmd.hdr, sizeof(cmd));
 
 	lbs_deb_leave(LBS_DEB_CMD);
 }
@@ -1360,10 +1337,6 @@ int lbs_prepare_and_send_command(struct lbs_private *priv,
 							 cmdptr, cmd_action);
 		break;
 
-	case CMD_MAC_MULTICAST_ADR:
-		ret = lbs_cmd_mac_multicast_adr(priv, cmdptr, cmd_action);
-		break;
-
 	case CMD_802_11_MONITOR_MODE:
 		ret = lbs_cmd_802_11_monitor_mode(cmdptr,
 				          cmd_action, pdata_buf);
diff --git a/drivers/net/wireless/libertas/cmdresp.c b/drivers/net/wireless/libertas/cmdresp.c
index 9e50fdd..4c3c5ec 100644
--- a/drivers/net/wireless/libertas/cmdresp.c
+++ b/drivers/net/wireless/libertas/cmdresp.c
@@ -316,7 +316,6 @@ static inline int handle_cmd_response(struct lbs_private *priv,
 
 		break;
 
-	case CMD_RET(CMD_MAC_MULTICAST_ADR):
 	case CMD_RET(CMD_802_11_RESET):
 	case CMD_RET(CMD_802_11_AUTHENTICATE):
 	case CMD_RET(CMD_802_11_BEACON_STOP):
diff --git a/drivers/net/wireless/libertas/dev.h b/drivers/net/wireless/libertas/dev.h
index 0d9edb9..e12ce65 100644
--- a/drivers/net/wireless/libertas/dev.h
+++ b/drivers/net/wireless/libertas/dev.h
@@ -140,6 +140,8 @@ struct lbs_private {
 	wait_queue_head_t waitq;
 	struct workqueue_struct *work_thread;
 
+	struct work_struct mcast_work;
+
 	/** Scanning */
 	struct delayed_work scan_work;
 	struct delayed_work assoc_work;
diff --git a/drivers/net/wireless/libertas/hostcmd.h b/drivers/net/wireless/libertas/hostcmd.h
index f29bc5b..c36ab31 100644
--- a/drivers/net/wireless/libertas/hostcmd.h
+++ b/drivers/net/wireless/libertas/hostcmd.h
@@ -219,6 +219,7 @@ struct cmd_ds_mac_control {
 };
 
 struct cmd_ds_mac_multicast_adr {
+	struct cmd_header hdr;
 	__le16 action;
 	__le16 nr_of_adrs;
 	u8 maclist[ETH_ALEN * MRVDRV_MAX_MULTICAST_LIST_SIZE];
@@ -703,7 +704,6 @@ struct cmd_ds_command {
 		struct cmd_ds_802_11_rf_antenna rant;
 		struct cmd_ds_802_11_monitor_mode monitor;
 		struct cmd_ds_802_11_rate_adapt_rateset rateset;
-		struct cmd_ds_mac_multicast_adr madr;
 		struct cmd_ds_802_11_ad_hoc_join adj;
 		struct cmd_ds_802_11_rssi rssi;
 		struct cmd_ds_802_11_rssi_rsp rssirsp;
diff --git a/drivers/net/wireless/libertas/main.c b/drivers/net/wireless/libertas/main.c
index 02e4fb6..603bd38 100644
--- a/drivers/net/wireless/libertas/main.c
+++ b/drivers/net/wireless/libertas/main.c
@@ -11,6 +11,7 @@
 #include <linux/if_arp.h>
 #include <linux/kthread.h>
 #include <linux/kfifo.h>
+#include <linux/stddef.h>
 
 #include <net/iw_handler.h>
 #include <net/ieee80211.h>
@@ -446,6 +447,8 @@ static int lbs_mesh_stop(struct net_device *dev)
 
 	spin_unlock_irq(&priv->driver_lock);
 
+	schedule_work(&priv->mcast_work);
+
 	lbs_deb_leave(LBS_DEB_MESH);
 	return 0;
 }
@@ -467,6 +470,8 @@ static int lbs_eth_stop(struct net_device *dev)
 	netif_stop_queue(dev);
 	spin_unlock_irq(&priv->driver_lock);
 
+	schedule_work(&priv->mcast_work);
+
 	lbs_deb_leave(LBS_DEB_NET);
 	return 0;
 }
@@ -563,89 +568,116 @@ done:
 	return ret;
 }
 
-static int lbs_copy_multicast_address(struct lbs_private *priv,
-				     struct net_device *dev)
+
+static inline int mac_in_list(unsigned char *list, int list_len,
+			      unsigned char *mac)
 {
-	int i = 0;
-	struct dev_mc_list *mcptr = dev->mc_list;
+	while (list_len) {
+		if (!memcmp(list, mac, ETH_ALEN))
+			return 1;
+		list += ETH_ALEN;
+		list_len--;
+	}
+	return 0;
+}
+
 
-	for (i = 0; i < dev->mc_count; i++) {
-		memcpy(&priv->multicastlist[i], mcptr->dmi_addr, ETH_ALEN);
-		mcptr = mcptr->next;
+static int lbs_add_mcast_addrs(struct cmd_ds_mac_multicast_adr *cmd,
+			       struct net_device *dev, int nr_addrs)
+{
+	int i = nr_addrs;
+	struct dev_mc_list *mc_list;
+	DECLARE_MAC_BUF(mac);
+
+	if ((dev->flags & (IFF_UP|IFF_MULTICAST)) != (IFF_UP|IFF_MULTICAST))
+		return nr_addrs;
+
+	netif_tx_lock_bh(dev);
+	for (mc_list = dev->mc_list; mc_list; mc_list = mc_list->next) {
+		if (mac_in_list(cmd->maclist, nr_addrs, mc_list->dmi_addr)) {
+			lbs_deb_net("mcast address %s:%s skipped\n", dev->name,
+				    print_mac(mac, mc_list->dmi_addr));
+			continue;
+		}
+
+		if (i == MRVDRV_MAX_MULTICAST_LIST_SIZE)
+			break;
+		memcpy(&cmd->maclist[6*i], mc_list->dmi_addr, ETH_ALEN);
+		lbs_deb_net("mcast address %s:%s added to filter\n", dev->name,
+			    print_mac(mac, mc_list->dmi_addr));
+		i++;
 	}
+	netif_tx_unlock_bh(dev);
+	if (mc_list)
+		return -EOVERFLOW;
+
 	return i;
 }
 
-static void lbs_set_multicast_list(struct net_device *dev)
+static void lbs_set_mcast_worker(struct work_struct *work)
 {
-	struct lbs_private *priv = dev->priv;
-	int old_mac_control;
-	DECLARE_MAC_BUF(mac);
+	struct lbs_private *priv = container_of(work, struct lbs_private, mcast_work);
+	struct cmd_ds_mac_multicast_adr mcast_cmd;
+	int dev_flags;
+	int nr_addrs;
+	int old_mac_control = priv->mac_control;
 
 	lbs_deb_enter(LBS_DEB_NET);
 
-	old_mac_control = priv->mac_control;
-
-	if (dev->flags & IFF_PROMISC) {
-		lbs_deb_net("enable promiscuous mode\n");
-		priv->mac_control |=
-		    CMD_ACT_MAC_PROMISCUOUS_ENABLE;
-		priv->mac_control &=
-		    ~(CMD_ACT_MAC_ALL_MULTICAST_ENABLE |
-		      CMD_ACT_MAC_MULTICAST_ENABLE);
-	} else {
-		/* Multicast */
-		priv->mac_control &=
-		    ~CMD_ACT_MAC_PROMISCUOUS_ENABLE;
-
-		if (dev->flags & IFF_ALLMULTI || dev->mc_count >
-		    MRVDRV_MAX_MULTICAST_LIST_SIZE) {
-			lbs_deb_net( "enabling all multicast\n");
-			priv->mac_control |=
-			    CMD_ACT_MAC_ALL_MULTICAST_ENABLE;
-			priv->mac_control &=
-			    ~CMD_ACT_MAC_MULTICAST_ENABLE;
-		} else {
-			priv->mac_control &=
-			    ~CMD_ACT_MAC_ALL_MULTICAST_ENABLE;
-
-			if (!dev->mc_count) {
-				lbs_deb_net("no multicast addresses, "
-				       "disabling multicast\n");
-				priv->mac_control &=
-				    ~CMD_ACT_MAC_MULTICAST_ENABLE;
-			} else {
-				int i;
-
-				priv->mac_control |=
-				    CMD_ACT_MAC_MULTICAST_ENABLE;
-
-				priv->nr_of_multicastmacaddr =
-				    lbs_copy_multicast_address(priv, dev);
-
-				lbs_deb_net("multicast addresses: %d\n",
-				       dev->mc_count);
-
-				for (i = 0; i < dev->mc_count; i++) {
-					lbs_deb_net("Multicast address %d: %s\n",
-					       i, print_mac(mac,
-					       priv->multicastlist[i]));
-				}
-				/* send multicast addresses to firmware */
-				lbs_prepare_and_send_command(priv,
-						      CMD_MAC_MULTICAST_ADR,
-						      CMD_ACT_SET, 0, 0,
-						      NULL);
-			}
-		}
+	dev_flags = priv->dev->flags;
+	if (priv->mesh_dev)
+		dev_flags |= priv->mesh_dev->flags;
+
+	if (dev_flags & IFF_PROMISC) {
+		priv->mac_control |= CMD_ACT_MAC_PROMISCUOUS_ENABLE;
+		priv->mac_control &= ~(CMD_ACT_MAC_ALL_MULTICAST_ENABLE |
+				       CMD_ACT_MAC_MULTICAST_ENABLE);
+		goto out_set_mac_control;
+	} else if (dev_flags & IFF_ALLMULTI) {
+	do_allmulti:
+		priv->mac_control |= CMD_ACT_MAC_ALL_MULTICAST_ENABLE;
+		priv->mac_control &= ~(CMD_ACT_MAC_PROMISCUOUS_ENABLE |
+				       CMD_ACT_MAC_MULTICAST_ENABLE);
+		goto out_set_mac_control;
 	}
 
+	/* Once for priv->dev, again for priv->mesh_dev if it exists */
+	nr_addrs = lbs_add_mcast_addrs(&mcast_cmd, priv->dev, 0);
+	if (nr_addrs >= 0 && priv->mesh_dev)
+		nr_addrs = lbs_add_mcast_addrs(&mcast_cmd, priv->mesh_dev, nr_addrs);
+	if (nr_addrs < 0)
+		goto do_allmulti;
+
+	if (nr_addrs) {
+		int size = offsetof(struct cmd_ds_mac_multicast_adr,
+				    maclist[6*nr_addrs]);
+
+		mcast_cmd.action = cpu_to_le16(CMD_ACT_SET);
+		mcast_cmd.hdr.size = cpu_to_le16(size);
+		mcast_cmd.nr_of_adrs = cpu_to_le16(nr_addrs);
+
+		lbs_cmd_async(priv, CMD_MAC_MULTICAST_ADR, &mcast_cmd.hdr, size);
+
+		priv->mac_control |= CMD_ACT_MAC_MULTICAST_ENABLE;
+	} else
+		priv->mac_control &= ~CMD_ACT_MAC_MULTICAST_ENABLE;
+
+	priv->mac_control &= ~(CMD_ACT_MAC_PROMISCUOUS_ENABLE |
+			       CMD_ACT_MAC_ALL_MULTICAST_ENABLE);
+ out_set_mac_control:
 	if (priv->mac_control != old_mac_control)
 		lbs_set_mac_control(priv);
 
 	lbs_deb_leave(LBS_DEB_NET);
 }
 
+static void lbs_set_multicast_list(struct net_device *dev)
+{
+	struct lbs_private *priv = dev->priv;
+
+	schedule_work(&priv->mcast_work);
+}
+
 /**
  *  @brief This function handles the major jobs in the LBS driver.
  *  It handles all events generated by firmware, RX data received
@@ -1123,6 +1155,7 @@ struct lbs_private *lbs_add_card(void *card, struct device *dmdev)
 	priv->work_thread = create_singlethread_workqueue("lbs_worker");
 	INIT_DELAYED_WORK(&priv->assoc_work, lbs_association_worker);
 	INIT_DELAYED_WORK(&priv->scan_work, lbs_scan_worker);
+	INIT_WORK(&priv->mcast_work, lbs_set_mcast_worker);
 	INIT_WORK(&priv->sync_channel, lbs_sync_channel_worker);
 
 	sprintf(priv->mesh_ssid, "mesh");
@@ -1159,6 +1192,7 @@ void lbs_remove_card(struct lbs_private *priv)
 
 	cancel_delayed_work_sync(&priv->scan_work);
 	cancel_delayed_work_sync(&priv->assoc_work);
+	cancel_work_sync(&priv->mcast_work);
 	destroy_workqueue(priv->work_thread);
 
 	if (priv->psmode == LBS802_11POWERMODEMAX_PSP) {
@@ -1323,6 +1357,8 @@ static int lbs_add_mesh(struct lbs_private *priv)
 #ifdef	WIRELESS_EXT
 	mesh_dev->wireless_handlers = (struct iw_handler_def *)&mesh_handler_def;
 #endif
+	mesh_dev->flags |= IFF_BROADCAST | IFF_MULTICAST;
+	mesh_dev->set_multicast_list = lbs_set_multicast_list;
 	/* Register virtual mesh interface */
 	ret = register_netdev(mesh_dev);
 	if (ret) {
@@ -1555,7 +1591,6 @@ static int lbs_add_rtap(struct lbs_private *priv)
 	rtap_dev->stop = lbs_rtap_stop;
 	rtap_dev->get_stats = lbs_rtap_get_stats;
 	rtap_dev->hard_start_xmit = lbs_rtap_hard_start_xmit;
-	rtap_dev->set_multicast_list = lbs_set_multicast_list;
 	rtap_dev->priv = priv;
 	SET_NETDEV_DEV(rtap_dev, priv->dev->dev.parent);
 

-- 
dwmw2

