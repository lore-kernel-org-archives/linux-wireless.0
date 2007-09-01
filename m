Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from c60.cesmail.net ([216.154.195.49]:17799 "EHLO c60.cesmail.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751287AbXIAEeu (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Sat, 1 Sep 2007 00:34:50 -0400
Received: from dv.roinet.com (static-72-92-88-10.phlapa.fios.verizon.net [72.92.88.10])
	by relay.cesmail.net (Postfix) with ESMTP id 5DF05618FE1
	for <linux-wireless@vger.kernel.org>; Sat,  1 Sep 2007 00:34:49 -0400 (EDT)
From: Pavel Roskin <proski@gnu.org>
Subject: [PATCH 06/35] Move (de)initialization functions closer to the end of  file
To: linux-wireless@vger.kernel.org
Date: Sat, 01 Sep 2007 00:34:49 -0400
Message-ID: <20070901043448.2498.6971.stgit@dv.roinet.com>
In-Reply-To: <20070901043233.2498.95850.stgit@dv.roinet.com>
References: <20070901043233.2498.95850.stgit@dv.roinet.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Signed-off-by: Pavel Roskin <proski@gnu.org>
---

 drivers/net/wireless/at76_usb.c |  496 ++++++++++++++++++++-------------------
 1 files changed, 248 insertions(+), 248 deletions(-)


diff --git a/drivers/net/wireless/at76_usb.c b/drivers/net/wireless/at76_usb.c
index 967a0f0..55e82cd 100644
--- a/drivers/net/wireless/at76_usb.c
+++ b/drivers/net/wireless/at76_usb.c
@@ -1966,122 +1966,6 @@ exit:
 	mutex_unlock(&priv->mtx);
 }
 
-static void at76_delete_device(struct at76_priv *priv)
-{
-	int i;
-
-	at76_dbg(DBG_PROC_ENTRY, "%s: ENTER", __func__);
-
-	/* The device is gone, don't bother turning it off */
-	priv->device_unplugged = 1;
-
-	tasklet_kill(&priv->rx_tasklet);
-
-	if (priv->netdev_registered)
-		unregister_netdev(priv->netdev);
-
-	/* assuming we used keventd, it must quiesce too */
-	flush_scheduled_work();
-
-	kfree(priv->bulk_out_buffer);
-
-	if (priv->write_urb) {
-		usb_kill_urb(priv->write_urb);
-		usb_free_urb(priv->write_urb);
-	}
-	if (priv->read_urb) {
-		usb_kill_urb(priv->read_urb);
-		usb_free_urb(priv->read_urb);
-	}
-
-	at76_dbg(DBG_PROC_ENTRY, "%s: unlinked urbs", __func__);
-
-	if (priv->rx_skb)
-		kfree_skb(priv->rx_skb);
-
-	at76_free_bss_list(priv);
-	del_timer_sync(&priv->bss_list_timer);
-	cancel_delayed_work(&priv->dwork_get_scan);
-	cancel_delayed_work(&priv->dwork_beacon);
-	cancel_delayed_work(&priv->dwork_auth);
-	cancel_delayed_work(&priv->dwork_assoc);
-
-	if (priv->mac_state == MAC_CONNECTED)
-		at76_iwevent_bss_disconnect(priv->netdev);
-
-	for (i = 0; i < NR_RX_DATA_BUF; i++)
-		if (priv->rx_data[i].skb) {
-			dev_kfree_skb(priv->rx_data[i].skb);
-			priv->rx_data[i].skb = NULL;
-		}
-	usb_put_dev(priv->udev);
-
-	at76_dbg(DBG_PROC_ENTRY, "%s: before freeing priv/netdev", __func__);
-	free_netdev(priv->netdev);	/* priv is in netdev */
-
-	at76_dbg(DBG_PROC_ENTRY, "%s: EXIT", __func__);
-}
-
-static int at76_alloc_urbs(struct at76_priv *priv,
-			   struct usb_interface *interface)
-{
-	struct usb_endpoint_descriptor *endpoint, *ep_in, *ep_out;
-	int i;
-	int buffer_size;
-	struct usb_host_interface *iface_desc;
-
-	at76_dbg(DBG_PROC_ENTRY, "%s: ENTER", __func__);
-
-	at76_dbg(DBG_URB, "%s: NumEndpoints %d ", __func__,
-		 interface->altsetting[0].desc.bNumEndpoints);
-
-	ep_in = NULL;
-	ep_out = NULL;
-	iface_desc = interface->cur_altsetting;
-	for (i = 0; i < iface_desc->desc.bNumEndpoints; i++) {
-		endpoint = &iface_desc->endpoint[i].desc;
-
-		at76_dbg(DBG_URB, "%s: %d. endpoint: addr 0x%x attr 0x%x",
-			 __func__, i, endpoint->bEndpointAddress,
-			 endpoint->bmAttributes);
-
-		if (!ep_in && usb_endpoint_is_bulk_in(endpoint))
-			ep_in = endpoint;
-
-		if (!ep_out && usb_endpoint_is_bulk_out(endpoint))
-			ep_out = endpoint;
-	}
-
-	if (!ep_in || !ep_out) {
-		printk(KERN_ERR DRIVER_NAME ": bulk endpoints missing\n");
-		return -ENXIO;
-	}
-
-	priv->rx_bulk_pipe =
-	    usb_rcvbulkpipe(priv->udev, ep_in->bEndpointAddress);
-	priv->tx_bulk_pipe =
-	    usb_sndbulkpipe(priv->udev, ep_out->bEndpointAddress);
-
-	priv->read_urb = usb_alloc_urb(0, GFP_KERNEL);
-	priv->write_urb = usb_alloc_urb(0, GFP_KERNEL);
-	if (!priv->read_urb || !priv->write_urb) {
-		printk(KERN_ERR DRIVER_NAME ": cannot allocate URB\n");
-		return -ENOMEM;
-	}
-
-	buffer_size = sizeof(struct at76_tx_buffer) + MAX_PADDING_SIZE;
-	priv->bulk_out_buffer = kmalloc(buffer_size, GFP_KERNEL);
-	if (!priv->bulk_out_buffer) {
-		printk(KERN_ERR DRIVER_NAME
-		       ": cannot allocate output buffer\n");
-		return -ENOMEM;
-	}
-
-	at76_dbg(DBG_PROC_ENTRY, "%s: EXIT", __func__);
-
-	return 0;
-}
-
 /* We only store the new mac address in netdev struct,
    it gets set when the netdev is opened. */
 static int at76_set_mac_address(struct net_device *netdev, void *addr)
@@ -3720,91 +3604,6 @@ static struct ethtool_ops at76_ethtool_ops = {
 	.get_link = at76_ethtool_get_link,
 };
 
-/* Register network device and initialize the hardware */
-static int at76_init_new_device(struct at76_priv *priv,
-				struct usb_interface *interface)
-{
-	struct net_device *netdev = priv->netdev;
-	int ret;
-
-	/* set up the endpoint information */
-	/* check out the endpoints */
-
-	at76_dbg(DBG_DEVSTART, "USB interface: %d endpoints",
-		 interface->cur_altsetting->desc.bNumEndpoints);
-
-	ret = at76_alloc_urbs(priv, interface);
-	if (ret < 0)
-		goto exit;
-
-	/* MAC address */
-	ret = at76_get_hw_config(priv);
-	if (ret < 0) {
-		err("could not get MAC address");
-		goto exit;
-	}
-
-	priv->domain = at76_get_reg_domain(priv->regulatory_domain);
-	/* init. netdev->dev_addr */
-	memcpy(netdev->dev_addr, priv->mac_addr, ETH_ALEN);
-
-	/* initializing */
-	priv->international_roaming = IR_OFF;
-	priv->channel = DEF_CHANNEL;
-	priv->iw_mode = IW_MODE_INFRA;
-	memset(priv->essid, 0, IW_ESSID_MAX_SIZE);
-	priv->rts_threshold = DEF_RTS_THRESHOLD;
-	priv->frag_threshold = DEF_FRAG_THRESHOLD;
-	priv->short_retry_limit = DEF_SHORT_RETRY_LIMIT;
-	priv->txrate = TX_RATE_AUTO;
-	priv->preamble_type = PREAMBLE_TYPE_LONG;
-	priv->beacon_period = 100;
-	priv->beacons_last_qual = jiffies_to_msecs(jiffies);
-	priv->auth_mode = WLAN_AUTH_OPEN;
-	priv->scan_min_time = DEF_SCAN_MIN_TIME;
-	priv->scan_max_time = DEF_SCAN_MAX_TIME;
-	priv->scan_mode = SCAN_TYPE_ACTIVE;
-
-	netdev->flags &= ~IFF_MULTICAST;	/* not yet or never */
-	netdev->open = at76_open;
-	netdev->stop = at76_stop;
-	netdev->get_stats = at76_get_stats;
-	netdev->ethtool_ops = &at76_ethtool_ops;
-
-	/* Add pointers to enable iwspy support. */
-	priv->wireless_data.spy_data = &priv->spy_data;
-	netdev->wireless_data = &priv->wireless_data;
-
-	netdev->hard_start_xmit = at76_tx;
-	netdev->tx_timeout = at76_tx_timeout;
-	netdev->watchdog_timeo = 2 * HZ;
-	netdev->wireless_handlers = &at76_handler_def;
-	netdev->set_multicast_list = at76_set_multicast;
-	netdev->set_mac_address = at76_set_mac_address;
-
-	ret = register_netdev(priv->netdev);
-	if (ret) {
-		err("unable to register netdevice %s (status %d)!",
-		    priv->netdev->name, ret);
-		goto exit;
-	}
-	priv->netdev_registered = 1;
-
-	printk(KERN_INFO "%s: MAC address %s\n", netdev->name,
-	       mac2str(priv->mac_addr));
-	printk(KERN_INFO "%s: firmware version %d.%d.%d-%d\n", netdev->name,
-	       priv->fw_version.major, priv->fw_version.minor,
-	       priv->fw_version.patch, priv->fw_version.build);
-	printk(KERN_INFO "%s: regulatory domain %s (id %d)\n", netdev->name,
-	       priv->domain->name, priv->regulatory_domain);
-
-	/* we let this timer run the whole time this driver instance lives */
-	mod_timer(&priv->bss_list_timer, jiffies + BSS_LIST_TIMEOUT);
-
-exit:
-	return ret;
-}
-
 /* Download external firmware */
 static int at76_load_external_fw(struct usb_device *udev, struct fwentry *fwe)
 {
@@ -5516,6 +5315,76 @@ exit:
 	at76_submit_read_urb(priv);
 }
 
+/* Load firmware into kernel memory and parse it */
+static struct fwentry *at76_load_firmware(struct usb_device *udev,
+					  enum board_type board_type)
+{
+	int ret;
+	char *str;
+	struct at76_fw_header *fwh;
+	struct fwentry *fwe = &firmwares[board_type];
+
+	mutex_lock(&fw_mutex);
+
+	if (fwe->loaded) {
+		at76_dbg(DBG_FW, "re-using previously loaded fw");
+		goto exit;
+	}
+
+	at76_dbg(DBG_FW, "downloading firmware %s", fwe->fwname);
+	ret = request_firmware(&fwe->fw, fwe->fwname, &udev->dev);
+	if (ret < 0) {
+		err("firmware %s not found.", fwe->fwname);
+		err("You may need to download the firmware from "
+		    "http://developer.berlios.de/projects/at76c503a/");
+		goto exit;
+	}
+
+	at76_dbg(DBG_FW, "got it.");
+	fwh = (struct at76_fw_header *)(fwe->fw->data);
+
+	if (fwe->fw->size <= sizeof(*fwh)) {
+		err("firmware is too short (0x%zx)", fwe->fw->size);
+		goto exit;
+	}
+
+	/* CRC currently not checked */
+	fwe->board_type = le32_to_cpu(fwh->board_type);
+	if (fwe->board_type != board_type) {
+		err("board type mismatch, requested %u, got %u", board_type,
+		    fwe->board_type);
+		goto exit;
+	}
+
+	fwe->fw_version.major = fwh->major;
+	fwe->fw_version.minor = fwh->minor;
+	fwe->fw_version.patch = fwh->patch;
+	fwe->fw_version.build = fwh->build;
+
+	str = (char *)fwh + le32_to_cpu(fwh->str_offset);
+	fwe->intfw = (u8 *)fwh + le32_to_cpu(fwh->int_fw_offset);
+	fwe->intfw_size = le32_to_cpu(fwh->int_fw_len);
+	fwe->extfw = (u8 *)fwh + le32_to_cpu(fwh->ext_fw_offset);
+	fwe->extfw_size = le32_to_cpu(fwh->ext_fw_len);
+
+	fwe->loaded = 1;
+
+	at76_dbg(DBG_DEVSTART, "firmware board %u version %u.%u.%u-%u "
+		 "(int %d:%d, ext %d:%d)", board_type,
+		 fwh->major, fwh->minor, fwh->patch, fwh->build,
+		 le32_to_cpu(fwh->int_fw_offset), le32_to_cpu(fwh->int_fw_len),
+		 le32_to_cpu(fwh->ext_fw_offset), le32_to_cpu(fwh->ext_fw_len));
+	at76_dbg(DBG_DEVSTART, "firmware id %s", str);
+
+exit:
+	mutex_unlock(&fw_mutex);
+
+	if (fwe->loaded)
+		return fwe;
+	else
+		return NULL;
+}
+
 /* Allocate network device and initialize private data */
 static struct at76_priv *at76_alloc_new_device(struct usb_device *udev)
 {
@@ -5578,74 +5447,205 @@ static struct at76_priv *at76_alloc_new_device(struct usb_device *udev)
 	return priv;
 }
 
-/* Load firmware into kernel memory and parse it */
-static struct fwentry *at76_load_firmware(struct usb_device *udev,
-					  enum board_type board_type)
+static int at76_alloc_urbs(struct at76_priv *priv,
+			   struct usb_interface *interface)
+{
+	struct usb_endpoint_descriptor *endpoint, *ep_in, *ep_out;
+	int i;
+	int buffer_size;
+	struct usb_host_interface *iface_desc;
+
+	at76_dbg(DBG_PROC_ENTRY, "%s: ENTER", __func__);
+
+	at76_dbg(DBG_URB, "%s: NumEndpoints %d ", __func__,
+		 interface->altsetting[0].desc.bNumEndpoints);
+
+	ep_in = NULL;
+	ep_out = NULL;
+	iface_desc = interface->cur_altsetting;
+	for (i = 0; i < iface_desc->desc.bNumEndpoints; i++) {
+		endpoint = &iface_desc->endpoint[i].desc;
+
+		at76_dbg(DBG_URB, "%s: %d. endpoint: addr 0x%x attr 0x%x",
+			 __func__, i, endpoint->bEndpointAddress,
+			 endpoint->bmAttributes);
+
+		if (!ep_in && usb_endpoint_is_bulk_in(endpoint))
+			ep_in = endpoint;
+
+		if (!ep_out && usb_endpoint_is_bulk_out(endpoint))
+			ep_out = endpoint;
+	}
+
+	if (!ep_in || !ep_out) {
+		printk(KERN_ERR DRIVER_NAME ": bulk endpoints missing\n");
+		return -ENXIO;
+	}
+
+	priv->rx_bulk_pipe =
+	    usb_rcvbulkpipe(priv->udev, ep_in->bEndpointAddress);
+	priv->tx_bulk_pipe =
+	    usb_sndbulkpipe(priv->udev, ep_out->bEndpointAddress);
+
+	priv->read_urb = usb_alloc_urb(0, GFP_KERNEL);
+	priv->write_urb = usb_alloc_urb(0, GFP_KERNEL);
+	if (!priv->read_urb || !priv->write_urb) {
+		printk(KERN_ERR DRIVER_NAME ": cannot allocate URB\n");
+		return -ENOMEM;
+	}
+
+	buffer_size = sizeof(struct at76_tx_buffer) + MAX_PADDING_SIZE;
+	priv->bulk_out_buffer = kmalloc(buffer_size, GFP_KERNEL);
+	if (!priv->bulk_out_buffer) {
+		printk(KERN_ERR DRIVER_NAME
+		       ": cannot allocate output buffer\n");
+		return -ENOMEM;
+	}
+
+	at76_dbg(DBG_PROC_ENTRY, "%s: EXIT", __func__);
+
+	return 0;
+}
+
+/* Register network device and initialize the hardware */
+static int at76_init_new_device(struct at76_priv *priv,
+				struct usb_interface *interface)
 {
+	struct net_device *netdev = priv->netdev;
 	int ret;
-	char *str;
-	struct at76_fw_header *fwh;
-	struct fwentry *fwe = &firmwares[board_type];
 
-	mutex_lock(&fw_mutex);
+	/* set up the endpoint information */
+	/* check out the endpoints */
 
-	if (fwe->loaded) {
-		at76_dbg(DBG_FW, "re-using previously loaded fw");
+	at76_dbg(DBG_DEVSTART, "USB interface: %d endpoints",
+		 interface->cur_altsetting->desc.bNumEndpoints);
+
+	ret = at76_alloc_urbs(priv, interface);
+	if (ret < 0)
 		goto exit;
-	}
 
-	at76_dbg(DBG_FW, "downloading firmware %s", fwe->fwname);
-	ret = request_firmware(&fwe->fw, fwe->fwname, &udev->dev);
+	/* MAC address */
+	ret = at76_get_hw_config(priv);
 	if (ret < 0) {
-		err("firmware %s not found.", fwe->fwname);
-		err("You may need to download the firmware from "
-		    "http://developer.berlios.de/projects/at76c503a/");
+		err("could not get MAC address");
 		goto exit;
 	}
 
-	at76_dbg(DBG_FW, "got it.");
-	fwh = (struct at76_fw_header *)(fwe->fw->data);
+	priv->domain = at76_get_reg_domain(priv->regulatory_domain);
+	/* init. netdev->dev_addr */
+	memcpy(netdev->dev_addr, priv->mac_addr, ETH_ALEN);
 
-	if (fwe->fw->size <= sizeof(*fwh)) {
-		err("firmware is too short (0x%zx)", fwe->fw->size);
+	/* initializing */
+	priv->international_roaming = IR_OFF;
+	priv->channel = DEF_CHANNEL;
+	priv->iw_mode = IW_MODE_INFRA;
+	memset(priv->essid, 0, IW_ESSID_MAX_SIZE);
+	priv->rts_threshold = DEF_RTS_THRESHOLD;
+	priv->frag_threshold = DEF_FRAG_THRESHOLD;
+	priv->short_retry_limit = DEF_SHORT_RETRY_LIMIT;
+	priv->txrate = TX_RATE_AUTO;
+	priv->preamble_type = PREAMBLE_TYPE_LONG;
+	priv->beacon_period = 100;
+	priv->beacons_last_qual = jiffies_to_msecs(jiffies);
+	priv->auth_mode = WLAN_AUTH_OPEN;
+	priv->scan_min_time = DEF_SCAN_MIN_TIME;
+	priv->scan_max_time = DEF_SCAN_MAX_TIME;
+	priv->scan_mode = SCAN_TYPE_ACTIVE;
+
+	netdev->flags &= ~IFF_MULTICAST;	/* not yet or never */
+	netdev->open = at76_open;
+	netdev->stop = at76_stop;
+	netdev->get_stats = at76_get_stats;
+	netdev->ethtool_ops = &at76_ethtool_ops;
+
+	/* Add pointers to enable iwspy support. */
+	priv->wireless_data.spy_data = &priv->spy_data;
+	netdev->wireless_data = &priv->wireless_data;
+
+	netdev->hard_start_xmit = at76_tx;
+	netdev->tx_timeout = at76_tx_timeout;
+	netdev->watchdog_timeo = 2 * HZ;
+	netdev->wireless_handlers = &at76_handler_def;
+	netdev->set_multicast_list = at76_set_multicast;
+	netdev->set_mac_address = at76_set_mac_address;
+
+	ret = register_netdev(priv->netdev);
+	if (ret) {
+		err("unable to register netdevice %s (status %d)!",
+		    priv->netdev->name, ret);
 		goto exit;
 	}
+	priv->netdev_registered = 1;
 
-	/* CRC currently not checked */
-	fwe->board_type = le32_to_cpu(fwh->board_type);
-	if (fwe->board_type != board_type) {
-		err("board type mismatch, requested %u, got %u", board_type,
-		    fwe->board_type);
-		goto exit;
+	printk(KERN_INFO "%s: MAC address %s\n", netdev->name,
+	       mac2str(priv->mac_addr));
+	printk(KERN_INFO "%s: firmware version %d.%d.%d-%d\n", netdev->name,
+	       priv->fw_version.major, priv->fw_version.minor,
+	       priv->fw_version.patch, priv->fw_version.build);
+	printk(KERN_INFO "%s: regulatory domain %s (id %d)\n", netdev->name,
+	       priv->domain->name, priv->regulatory_domain);
+
+	/* we let this timer run the whole time this driver instance lives */
+	mod_timer(&priv->bss_list_timer, jiffies + BSS_LIST_TIMEOUT);
+
+exit:
+	return ret;
+}
+
+static void at76_delete_device(struct at76_priv *priv)
+{
+	int i;
+
+	at76_dbg(DBG_PROC_ENTRY, "%s: ENTER", __func__);
+
+	/* The device is gone, don't bother turning it off */
+	priv->device_unplugged = 1;
+
+	tasklet_kill(&priv->rx_tasklet);
+
+	if (priv->netdev_registered)
+		unregister_netdev(priv->netdev);
+
+	/* assuming we used keventd, it must quiesce too */
+	flush_scheduled_work();
+
+	kfree(priv->bulk_out_buffer);
+
+	if (priv->write_urb) {
+		usb_kill_urb(priv->write_urb);
+		usb_free_urb(priv->write_urb);
+	}
+	if (priv->read_urb) {
+		usb_kill_urb(priv->read_urb);
+		usb_free_urb(priv->read_urb);
 	}
 
-	fwe->fw_version.major = fwh->major;
-	fwe->fw_version.minor = fwh->minor;
-	fwe->fw_version.patch = fwh->patch;
-	fwe->fw_version.build = fwh->build;
+	at76_dbg(DBG_PROC_ENTRY, "%s: unlinked urbs", __func__);
 
-	str = (char *)fwh + le32_to_cpu(fwh->str_offset);
-	fwe->intfw = (u8 *)fwh + le32_to_cpu(fwh->int_fw_offset);
-	fwe->intfw_size = le32_to_cpu(fwh->int_fw_len);
-	fwe->extfw = (u8 *)fwh + le32_to_cpu(fwh->ext_fw_offset);
-	fwe->extfw_size = le32_to_cpu(fwh->ext_fw_len);
+	if (priv->rx_skb)
+		kfree_skb(priv->rx_skb);
 
-	fwe->loaded = 1;
+	at76_free_bss_list(priv);
+	del_timer_sync(&priv->bss_list_timer);
+	cancel_delayed_work(&priv->dwork_get_scan);
+	cancel_delayed_work(&priv->dwork_beacon);
+	cancel_delayed_work(&priv->dwork_auth);
+	cancel_delayed_work(&priv->dwork_assoc);
 
-	at76_dbg(DBG_DEVSTART, "firmware board %u version %u.%u.%u-%u "
-		 "(int %d:%d, ext %d:%d)", board_type,
-		 fwh->major, fwh->minor, fwh->patch, fwh->build,
-		 le32_to_cpu(fwh->int_fw_offset), le32_to_cpu(fwh->int_fw_len),
-		 le32_to_cpu(fwh->ext_fw_offset), le32_to_cpu(fwh->ext_fw_len));
-	at76_dbg(DBG_DEVSTART, "firmware id %s", str);
+	if (priv->mac_state == MAC_CONNECTED)
+		at76_iwevent_bss_disconnect(priv->netdev);
 
-exit:
-	mutex_unlock(&fw_mutex);
+	for (i = 0; i < NR_RX_DATA_BUF; i++)
+		if (priv->rx_data[i].skb) {
+			dev_kfree_skb(priv->rx_data[i].skb);
+			priv->rx_data[i].skb = NULL;
+		}
+	usb_put_dev(priv->udev);
 
-	if (fwe->loaded)
-		return fwe;
-	else
-		return NULL;
+	at76_dbg(DBG_PROC_ENTRY, "%s: before freeing priv/netdev", __func__);
+	free_netdev(priv->netdev);	/* priv is in netdev */
+
+	at76_dbg(DBG_PROC_ENTRY, "%s: EXIT", __func__);
 }
 
 static int at76_probe(struct usb_interface *interface,
