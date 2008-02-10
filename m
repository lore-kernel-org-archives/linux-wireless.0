Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from emh03.mail.saunalahti.fi ([62.142.5.109]:56176 "EHLO
	emh03.mail.saunalahti.fi" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751333AbYBJPKw (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 10 Feb 2008 10:10:52 -0500
From: Kalle Valo <kalle.valo@iki.fi>
Subject: [PATCH 05/12] at76_usb: add mac80211 support
To: linux-wireless@vger.kernel.org
Cc: Pavel Roskin <proski@gnu.org>
Date: Sun, 10 Feb 2008 17:00:26 +0200
Message-ID: <20080210150026.17592.53529.stgit@tikku> (sfid-20080210_151058_772369_BC7F9D15)
In-Reply-To: <20080210145733.17592.61729.stgit@tikku>
References: <20080210145733.17592.61729.stgit@tikku>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This patch creates the basic facilities for using mac80211 while keeping
the old legacy stack alone. This add only adds new code, no old code is
changed. Both the legacy and mac80211 interfaces are created to make the
transition easier. The legacy interface will be removed with following
patches.

Signed-off-by: Kalle Valo <kalle.valo@iki.fi>
---

 drivers/net/wireless/at76_usb.c |  480 +++++++++++++++++++++++++++++++++++++++
 drivers/net/wireless/at76_usb.h |   11 +
 2 files changed, 491 insertions(+), 0 deletions(-)


diff --git a/drivers/net/wireless/at76_usb.c b/drivers/net/wireless/at76_usb.c
index c312634..6e8a001 100644
--- a/drivers/net/wireless/at76_usb.c
+++ b/drivers/net/wireless/at76_usb.c
@@ -6,6 +6,7 @@
  * Copyright (c) 2004 Nick Jones
  * Copyright (c) 2004 Balint Seeber <n0_5p4m_p13453@hotmail.com>
  * Copyright (c) 2007 Guido Guenther <agx@sigxcpu.org>
+ * Copyright (c) 2007 Kalle Valo <kalle.valo@iki.fi>
  *
  * This program is free software; you can redistribute it and/or
  * modify it under the terms of the GNU General Public License as
@@ -16,6 +17,15 @@
  * Atmel AT76C503A/505/505A.
  *
  * Some iw_handler code was taken from airo.c, (C) 1999 Benjamin Reed
+ *
+ * TODO for the mac80211 port:
+ * o monitor mode
+ * o adhoc support
+ * o hardware wep encryption
+ * o RTS/CTS support
+ * o Power Save Mode support
+ * o support for short/long preambles
+ * o export variables through debugfs/sysfs
  */
 
 #include <linux/init.h>
@@ -77,6 +87,7 @@
 #define DBG_FW			0x10000000	/* firmware download */
 #define DBG_DFU			0x20000000	/* device firmware upgrade */
 #define DBG_CMD			0x40000000
+#define DBG_MAC80211		0x80000000
 
 #define DBG_DEFAULTS		0
 
@@ -5036,6 +5047,27 @@ static void at76_rx_tasklet(unsigned long param)
 		 "%s: rx frame: rate %d rssi %d noise %d link %d %s",
 		 priv->netdev->name, buf->rx_rate, buf->rssi, buf->noise_level,
 		 buf->link_quality, hex2str(i802_11_hdr, 48));
+
+	if (priv->use_mac80211) {
+		struct ieee80211_rx_status rx_status = {0};
+		skb_pull(priv->rx_skb, AT76_RX_HDRLEN);
+		skb_trim(priv->rx_skb, le16_to_cpu(buf->wlength));
+		at76_dbg_dump(DBG_RX_DATA, priv->rx_skb->data,
+			      priv->rx_skb->len, "RX: len=%d",
+			      priv->rx_skb->len);
+
+		rx_status.ssi = buf->rssi;
+
+		at76_dbg(DBG_MAC80211, "calling ieee80211_rx_irqsafe(): %d/%d",
+			 priv->rx_skb->len, priv->rx_skb->data_len);
+		ieee80211_rx_irqsafe(priv->hw, priv->rx_skb, &rx_status);
+
+		/* Use a new skb for the next receive */
+		priv->rx_skb = NULL;
+
+		goto exit;
+	}
+
 	if (priv->iw_mode == IW_MODE_MONITOR) {
 		at76_rx_monitor_mode(priv);
 		goto exit;
@@ -5151,9 +5183,370 @@ exit:
 		return NULL;
 }
 
+static void at76_mac80211_tx_callback(struct urb *urb)
+{
+	struct at76_priv *priv = urb->context;
+
+	at76_dbg(DBG_MAC80211, "%s()", __func__);
+
+	switch (urb->status) {
+	case 0:
+		/* success */
+		priv->tx_status.flags |= IEEE80211_TX_STATUS_ACK;
+		break;
+	case -ENOENT:
+	case -ECONNRESET:
+		/* fail, urb has been unlinked */
+		/* FIXME: add error message */
+		break;
+	default:
+		at76_dbg(DBG_URB, "%s - nonzero tx status received: %d",
+			 __func__, urb->status);
+		break;
+	}
+
+	priv->tx_status.excessive_retries = 0;
+	priv->tx_status.retry_count = 0;
+	priv->tx_status.ack_signal = 0;
+
+	ieee80211_tx_status_irqsafe(priv->hw, priv->tx_skb, &priv->tx_status);
+
+	memset(&priv->tx_status, 0, sizeof(priv->tx_status));
+	priv->tx_skb = NULL;
+
+	ieee80211_start_queues(priv->hw);
+}
+
+static int at76_mac80211_tx(struct ieee80211_hw *hw, struct sk_buff *skb,
+		  struct ieee80211_tx_control *control)
+{
+	struct at76_mac80211_priv *mac80211_priv = hw->priv;
+	struct at76_priv *priv = mac80211_priv->at76_priv;
+	struct at76_tx_buffer *tx_buffer = priv->bulk_out_buffer;
+	int padding, submit_len, ret;
+
+	at76_dbg(DBG_MAC80211, "%s()", __func__);
+
+	if (priv->tx_urb->status == -EINPROGRESS) {
+		printk(KERN_ERR "%s: %s called while tx urb is pending\n",
+		       priv->netdev->name, __func__);
+		return NETDEV_TX_BUSY;
+	}
+
+	ieee80211_stop_queues(hw);
+
+	at76_ledtrig_tx_activity();	/* tell ledtrigger we send a packet */
+
+	WARN_ON(priv->tx_skb != NULL);
+
+	priv->tx_skb = skb;
+	memcpy(&priv->tx_status.control, control, sizeof(*control));
+	padding = at76_calc_padding(skb->len);
+	submit_len = AT76_TX_HDRLEN + skb->len + padding;
+
+	/* setup 'Atmel' header */
+	memset(tx_buffer, 0, sizeof(*tx_buffer));
+	tx_buffer->padding = padding;
+	tx_buffer->wlength = cpu_to_le16(skb->len);
+	tx_buffer->tx_rate = control->tx_rate->hw_value;
+	memset(tx_buffer->reserved, 0, sizeof(tx_buffer->reserved));
+	memcpy(tx_buffer->packet, skb->data, skb->len);
+
+	at76_dbg(DBG_TX_DATA, "%s tx: wlen 0x%x pad 0x%x rate %d hdr",
+		 priv->netdev->name, le16_to_cpu(tx_buffer->wlength),
+		 tx_buffer->padding, tx_buffer->tx_rate);
+
+	/* send stuff */
+	at76_dbg_dump(DBG_TX_DATA_CONTENT, tx_buffer, submit_len,
+		      "%s(): tx_buffer %d bytes:", __func__, submit_len);
+	usb_fill_bulk_urb(priv->tx_urb, priv->udev, priv->tx_pipe, tx_buffer,
+			  submit_len, at76_mac80211_tx_callback, priv);
+	ret = usb_submit_urb(priv->tx_urb, GFP_ATOMIC);
+	if (ret) {
+		printk(KERN_ERR "%s: error in tx submit urb: %d\n",
+		       priv->netdev->name, ret);
+		if (ret == -EINVAL)
+			printk(KERN_ERR
+			       "%s: -EINVAL: tx urb %p hcpriv %p complete %p\n",
+			       priv->netdev->name, priv->tx_urb,
+			       priv->tx_urb->hcpriv, priv->tx_urb->complete);
+	}
+
+	return 0;
+}
+
+static int at76_mac80211_start(struct ieee80211_hw *hw)
+{
+	struct at76_mac80211_priv *mac80211_priv = hw->priv;
+	struct at76_priv *priv = mac80211_priv->at76_priv;
+	int ret;
+
+	at76_dbg(DBG_MAC80211, "%s()", __func__);
+
+	mutex_lock(&priv->mtx);
+
+	priv->use_mac80211 = 1;
+
+	ret = at76_submit_rx_urb(priv);
+	if (ret < 0) {
+		printk(KERN_ERR "%s: open: submit_rx_urb failed: %d\n",
+		       priv->netdev->name, ret);
+		goto error;
+	}
+
+	at76_startup_device(priv);
+
+error:
+	mutex_unlock(&priv->mtx);
+
+	return 0;
+}
+
+static void at76_mac80211_stop(struct ieee80211_hw *hw)
+{
+	struct at76_mac80211_priv *mac80211_priv = hw->priv;
+	struct at76_priv *priv = mac80211_priv->at76_priv;
+
+	at76_dbg(DBG_MAC80211, "%s()", __func__);
+
+	mutex_lock(&priv->mtx);
+
+	priv->use_mac80211 = 0;
+
+	if (!priv->device_unplugged) {
+		/* We are called by "ifconfig ethX down", not because the
+		 * device is not available anymore. */
+		at76_set_radio(priv, 0);
+
+		/* We unlink rx_urb because at76_open() re-submits it.
+		 * If unplugged, at76_delete_device() takes care of it. */
+		usb_kill_urb(priv->rx_urb);
+	}
+
+	mutex_unlock(&priv->mtx);
+}
+
+static int at76_add_interface(struct ieee80211_hw *hw,
+			     struct ieee80211_if_init_conf *conf)
+{
+	struct at76_mac80211_priv *m_priv = hw->priv;
+	struct at76_priv *priv = m_priv->at76_priv;
+	int ret = 0;
+
+	at76_dbg(DBG_MAC80211, "%s()", __func__);
+
+	mutex_lock(&priv->mtx);
+
+	switch (conf->type) {
+	case IEEE80211_IF_TYPE_STA:
+		priv->iw_mode = IW_MODE_INFRA;
+		break;
+	default:
+		ret = -EOPNOTSUPP;
+		goto exit;
+	}
+
+exit:
+	mutex_unlock(&priv->mtx);
+
+	return ret;
+}
+
+static void at76_remove_interface(struct ieee80211_hw *hw,
+				 struct ieee80211_if_init_conf *conf)
+{
+	at76_dbg(DBG_MAC80211, "%s()", __func__);
+}
+
+static int at76_join(struct at76_priv *priv)
+{
+	struct at76_req_join join;
+	int ret;
+
+	memset(&join, 0, sizeof(struct at76_req_join));
+	memcpy(join.essid, priv->essid, priv->essid_size);
+	join.essid_size = priv->essid_size;
+	memcpy(join.bssid, priv->bssid, ETH_ALEN);
+	join.bss_type = INFRASTRUCTURE_MODE;
+	join.channel = priv->channel;
+	join.timeout = cpu_to_le16(2000);
+
+	at76_dbg(DBG_MAC80211, "%s: sending CMD_JOIN", __func__);
+	ret = at76_set_card_command(priv->udev, CMD_JOIN, &join,
+				    sizeof(struct at76_req_join));
+
+	if (ret < 0) {
+		printk(KERN_ERR "%s: CMD_JOIN failed: %d",
+		       wiphy_name(priv->hw->wiphy), ret);
+		return 0;
+	}
+
+	ret = at76_wait_completion(priv, CMD_JOIN);
+	at76_dbg(DBG_MAC80211, "%s: CMD_JOIN returned: 0x%02x", __func__, ret);
+	if (ret != CMD_STATUS_COMPLETE) {
+		printk(KERN_ERR "%s: CMD_JOIN failed: %d",
+		       wiphy_name(priv->hw->wiphy), ret);
+		return 0;
+	}
+
+	at76_set_pm_mode(priv);
+
+	return 0;
+}
+
+static void at76_dwork_hw_scan(struct work_struct *work)
+{
+	struct at76_priv *priv = container_of(work, struct at76_priv,
+					      dwork_hw_scan.work);
+	int ret;
+
+	mutex_lock(&priv->mtx);
+
+	ret = at76_get_cmd_status(priv->udev, CMD_SCAN);
+	at76_dbg(DBG_MAC80211, "%s: CMD_SCAN status 0x%02x",
+		 __func__, ret);
+
+	/* FIXME: add maximum time for scan to complete */
+
+	if (ret != CMD_STATUS_COMPLETE) {
+		queue_delayed_work(priv->hw->workqueue, &priv->dwork_hw_scan,
+				   SCAN_POLL_INTERVAL);
+		goto exit;
+	}
+
+	ieee80211_scan_completed(priv->hw);
+
+	if (is_valid_ether_addr(priv->bssid))
+		at76_join(priv);
+
+	ieee80211_start_queues(priv->hw);
+
+exit:
+	mutex_unlock(&priv->mtx);
+}
+
+
+static int at76_hw_scan(struct ieee80211_hw *hw, u8 *ssid, size_t len)
+{
+	struct at76_mac80211_priv *m_priv = hw->priv;
+	struct at76_priv *priv = m_priv->at76_priv;
+	struct at76_req_scan scan;
+	int ret;
+
+	at76_dbg(DBG_MAC80211, "%s():", __func__);
+	at76_dbg_dump(DBG_MAC80211, ssid, len,
+		      "ssid %zd bytes:", len);
+
+	mutex_lock(&priv->mtx);
+
+	ieee80211_stop_queues(hw);
+
+	memset(&scan, 0, sizeof(struct at76_req_scan));
+	memset(scan.bssid, 0xFF, ETH_ALEN);
+	scan.scan_type = SCAN_TYPE_ACTIVE;
+	if (priv->essid_size > 0) {
+		memcpy(scan.essid, ssid, len);
+		scan.essid_size = len;
+	}
+	scan.min_channel_time = cpu_to_le16(priv->scan_min_time);
+	scan.max_channel_time = cpu_to_le16(priv->scan_max_time);
+	scan.probe_delay = cpu_to_le16(priv->scan_min_time * 1000);
+	scan.international_scan = 0;
+
+	at76_dbg(DBG_MAC80211, "%s: sending CMD_SCAN", __func__);
+	ret = at76_set_card_command(priv->udev, CMD_SCAN, &scan,
+				    sizeof(scan));
+
+	if (ret < 0) {
+		err("CMD_SCAN failed: %d", ret);
+		goto exit;
+	}
+
+	queue_delayed_work(priv->hw->workqueue, &priv->dwork_hw_scan,
+			   SCAN_POLL_INTERVAL);
+
+exit:
+	mutex_unlock(&priv->mtx);
+
+	return 0;
+}
+
+static int at76_config(struct ieee80211_hw *hw, struct ieee80211_conf *conf)
+{
+	struct at76_mac80211_priv *m_priv = hw->priv;
+	struct at76_priv *priv = m_priv->at76_priv;
+
+	at76_dbg(DBG_MAC80211, "%s(): channel %d radio %d",
+		 __func__, conf->channel->hw_value, conf->radio_enabled);
+	at76_dbg_dump(DBG_MAC80211, priv->essid, priv->essid_size, "ssid:");
+	at76_dbg_dump(DBG_MAC80211, priv->bssid, ETH_ALEN, "bssid:");
+
+	mutex_lock(&priv->mtx);
+
+	priv->channel = conf->channel->hw_value;
+
+	if (is_valid_ether_addr(priv->bssid))
+		at76_join(priv);
+
+	mutex_unlock(&priv->mtx);
+
+	return 0;
+}
+
+static int at76_config_interface(struct ieee80211_hw *hw,
+				 struct ieee80211_vif *vif,
+				 struct ieee80211_if_conf *conf)
+{
+	struct at76_mac80211_priv *m_priv = hw->priv;
+	struct at76_priv *priv = m_priv->at76_priv;
+
+	at76_dbg(DBG_MAC80211, "%s(): ssid_len=%zd", __func__, conf->ssid_len);
+	at76_dbg_dump(DBG_MAC80211, conf->ssid, conf->ssid_len, "ssid:");
+	at76_dbg_dump(DBG_MAC80211, conf->bssid, ETH_ALEN, "bssid:");
+
+	mutex_lock(&priv->mtx);
+
+	memcpy(priv->bssid, conf->bssid, ETH_ALEN);
+	memcpy(priv->essid, conf->ssid, conf->ssid_len);
+	priv->essid_size = conf->ssid_len;
+
+	if (is_valid_ether_addr(priv->bssid))
+		/* mac80211 is joining a bss */
+		at76_join(priv);
+
+	mutex_unlock(&priv->mtx);
+
+	return 0;
+}
+
+static void at76_configure_filter(struct ieee80211_hw *hw,
+				  unsigned int changed_flags,
+				  unsigned int *total_flags, int mc_count,
+				  struct dev_addr_list *mc_list)
+{
+	at76_dbg(DBG_MAC80211, "%s(): changed_flags=0x%08x "
+		 "total_flags=0x%08x mc_count=%d",
+		 __func__, changed_flags, *total_flags, mc_count);
+
+	*total_flags = 0;
+}
+
+static const struct ieee80211_ops at76_ops = {
+	.tx = at76_mac80211_tx,
+	.add_interface = at76_add_interface,
+	.remove_interface = at76_remove_interface,
+	.config = at76_config,
+	.config_interface = at76_config_interface,
+	.configure_filter = at76_configure_filter,
+	.start = at76_mac80211_start,
+	.stop = at76_mac80211_stop,
+	.hw_scan = at76_hw_scan,
+};
+
 /* Allocate network device and initialize private data */
 static struct at76_priv *at76_alloc_new_device(struct usb_device *udev)
 {
+	struct at76_mac80211_priv *mac80211_priv;
 	struct net_device *netdev;
 	struct at76_priv *priv;
 	int i;
@@ -5182,6 +5575,7 @@ static struct at76_priv *at76_alloc_new_device(struct usb_device *udev)
 	INIT_DELAYED_WORK(&priv->dwork_beacon, at76_dwork_beacon);
 	INIT_DELAYED_WORK(&priv->dwork_auth, at76_dwork_auth);
 	INIT_DELAYED_WORK(&priv->dwork_assoc, at76_dwork_assoc);
+	INIT_DELAYED_WORK(&priv->dwork_hw_scan, at76_dwork_hw_scan);
 
 	spin_lock_init(&priv->mgmt_spinlock);
 	priv->next_mgmt_bulk = NULL;
@@ -5208,6 +5602,20 @@ static struct at76_priv *at76_alloc_new_device(struct usb_device *udev)
 	priv->pm_mode = AT76_PM_OFF;
 	priv->pm_period = 0;
 
+	priv->hw = ieee80211_alloc_hw(sizeof(struct at76_mac80211_priv),
+				      &at76_ops);
+	if (!priv->hw) {
+		printk(KERN_ERR DRIVER_NAME ": could not register"
+		       " ieee80211_hw\n");
+		return NULL;
+	}
+
+	mac80211_priv = priv->hw->priv;
+	mac80211_priv->at76_priv = priv;
+
+	/* unit us */
+	priv->hw->channel_change_time = 100000;
+
 	return priv;
 }
 
@@ -5270,6 +5678,56 @@ static int at76_alloc_urbs(struct at76_priv *priv,
 	return 0;
 }
 
+static struct ieee80211_rate at76_rates[] = {
+	{ .bitrate = 10,
+	  .hw_value = TX_RATE_1MBIT, },
+	{ .bitrate = 20,
+	  .hw_value = TX_RATE_2MBIT, },
+	{ .bitrate = 55,
+	  .hw_value = TX_RATE_5_5MBIT, },
+	{ .bitrate = 110,
+	  .hw_value = TX_RATE_11MBIT, },
+};
+
+static struct ieee80211_channel at76_channels[] = {
+	{ .hw_value = 1,
+	  .center_freq = 2412},
+	{ .hw_value = 2,
+	  .center_freq = 2417},
+	{ .hw_value = 3,
+	  .center_freq = 2422},
+	{ .hw_value = 4,
+	  .center_freq = 2427},
+	{ .hw_value = 5,
+	  .center_freq = 2432},
+	{ .hw_value = 6,
+	  .center_freq = 2437},
+	{ .hw_value = 7,
+	  .center_freq = 2442},
+	{ .hw_value = 8,
+	  .center_freq = 2447},
+	{ .hw_value = 9,
+	  .center_freq = 2452},
+	{ .hw_value = 10,
+	  .center_freq = 2457},
+	{ .hw_value = 11,
+	  .center_freq = 2462},
+	{ .hw_value = 12,
+	  .center_freq = 2467},
+	{ .hw_value = 13,
+	  .center_freq = 2472},
+	{ .hw_value = 14,
+	  .center_freq = 2484}
+};
+
+static struct ieee80211_supported_band at76_supported_band = {
+	.channels = at76_channels,
+	.n_channels = ARRAY_SIZE(at76_channels),
+	.bitrates = at76_rates,
+	.n_bitrates = ARRAY_SIZE(at76_rates),
+};
+
+
 /* Register network device and initialize the hardware */
 static int at76_init_new_device(struct at76_priv *priv,
 				struct usb_interface *interface)
@@ -5349,6 +5807,22 @@ static int at76_init_new_device(struct at76_priv *priv,
 	/* we let this timer run the whole time this driver instance lives */
 	mod_timer(&priv->bss_list_timer, jiffies + BSS_LIST_TIMEOUT);
 
+	/* mac80211 initialisation */
+	priv->hw->wiphy->bands[IEEE80211_BAND_2GHZ] = &at76_supported_band;
+	priv->hw->flags = IEEE80211_HW_RX_INCLUDES_FCS;
+
+	SET_IEEE80211_DEV(priv->hw, &interface->dev);
+	SET_IEEE80211_PERM_ADDR(priv->hw, priv->mac_addr);
+
+	ret = ieee80211_register_hw(priv->hw);
+	if (ret) {
+		printk(KERN_ERR "cannot register mac80211 hw (status %d)!\n",
+		       ret);
+		goto exit;
+	}
+
+	priv->mac80211_registered = 1;
+
 exit:
 	return ret;
 }
@@ -5365,6 +5839,12 @@ static void at76_delete_device(struct at76_priv *priv)
 	if (priv->netdev_registered)
 		unregister_netdev(priv->netdev);
 
+	if (priv->mac80211_registered)
+		ieee80211_unregister_hw(priv->hw);
+
+	ieee80211_free_hw(priv->hw);
+	priv->hw = NULL;
+
 	/* assuming we used keventd, it must quiesce too */
 	flush_scheduled_work();
 
diff --git a/drivers/net/wireless/at76_usb.h b/drivers/net/wireless/at76_usb.h
index 9329d5d..555a948 100644
--- a/drivers/net/wireless/at76_usb.h
+++ b/drivers/net/wireless/at76_usb.h
@@ -444,6 +444,7 @@ struct at76_priv {
 	struct iw_statistics wstats;	/* wireless stats */
 
 	struct sk_buff *rx_skb;	/* skbuff for receiving data */
+	struct sk_buff *tx_skb;	/* skbuff for transmitting data */
 	void *bulk_out_buffer;	/* buffer for sending data */
 
 	struct urb *tx_urb;	/* URB for sending data */
@@ -466,6 +467,7 @@ struct at76_priv {
 	struct delayed_work dwork_beacon;
 	struct delayed_work dwork_auth;
 	struct delayed_work dwork_assoc;
+	struct delayed_work dwork_hw_scan;
 
 	struct tasklet_struct rx_tasklet;
 
@@ -555,6 +557,15 @@ struct at76_priv {
 	int beacons_received;
 	unsigned long beacons_last_qual;	/* time we restarted counting
 						   beacons */
+
+	struct ieee80211_hw *hw;
+	struct ieee80211_tx_status tx_status;
+	int use_mac80211;
+	int mac80211_registered;
+};
+
+struct at76_mac80211_priv {
+	struct at76_priv *at76_priv;
 };
 
 struct at76_rx_radiotap {

