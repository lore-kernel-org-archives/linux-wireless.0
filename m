Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from c60.cesmail.net ([216.154.195.49]:32690 "EHLO c60.cesmail.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751093AbXI3Sjc (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Sun, 30 Sep 2007 14:39:32 -0400
From: Pavel Roskin <proski@gnu.org>
Subject: [PATCH 08/26] at76_usb: Eliminate err(), it's USB specific
To: John Linville <linville@tuxdriver.com>
Cc: linux-wireless@vger.kernel.org
Date: Sun, 30 Sep 2007 14:39:30 -0400
Message-ID: <20070930183929.23921.94352.stgit@tt.roinet.com>
In-Reply-To: <20070930183409.23921.97762.stgit@tt.roinet.com>
References: <20070930183409.23921.97762.stgit@tt.roinet.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Signed-off-by: Pavel Roskin <proski@gnu.org>
---

 drivers/net/wireless/at76_usb.c |  287 +++++++++++++++++++++------------------
 1 files changed, 158 insertions(+), 129 deletions(-)


diff --git a/drivers/net/wireless/at76_usb.c b/drivers/net/wireless/at76_usb.c
index be578a9..2a9dfb6 100644
--- a/drivers/net/wireless/at76_usb.c
+++ b/drivers/net/wireless/at76_usb.c
@@ -319,7 +319,7 @@ static int at76_usbdfu_download(struct usb_device *udev, u8 *buf, u32 size,
 		 manifest_sync_timeout);
 
 	if (!size) {
-		err("FW Buffer length invalid!");
+		printk(KERN_ERR DRIVER_NAME ": FW buffer length invalid!\n");
 		return -EINVAL;
 	}
 
@@ -331,7 +331,8 @@ static int at76_usbdfu_download(struct usb_device *udev, u8 *buf, u32 size,
 		if (need_dfu_state) {
 			ret = at76_dfu_get_state(udev, &dfu_state);
 			if (ret < 0) {
-				err("DFU: Failed to get DFU state: %d", ret);
+				printk(KERN_ERR DRIVER_NAME
+				       ": cannot get DFU state: %d\n", ret);
 				goto exit;
 			}
 			need_dfu_state = 0;
@@ -346,7 +347,9 @@ static int at76_usbdfu_download(struct usb_device *udev, u8 *buf, u32 size,
 				dfu_timeout = at76_get_timeout(&dfu_stat_buf);
 				need_dfu_state = 0;
 			} else
-				err("at76_dfu_get_status failed with %d", ret);
+				printk(KERN_ERR DRIVER_NAME
+				       ": at76_dfu_get_status failed with %d\n",
+				       ret);
 			break;
 
 		case STATE_DFU_DOWNLOAD_BUSY:
@@ -376,7 +379,9 @@ static int at76_usbdfu_download(struct usb_device *udev, u8 *buf, u32 size,
 			blockno++;
 
 			if (ret != bsize)
-				err("dfu_download_block failed with %d", ret);
+				printk(KERN_ERR DRIVER_NAME
+				       ": dfu_download_block failed with %d\n",
+				       ret);
 			need_dfu_state = 1;
 			break;
 
@@ -665,7 +670,8 @@ static int at76_get_hw_config(struct at76_priv *priv)
 exit:
 	kfree(hwcfg);
 	if (ret < 0)
-		err("Get HW Config failed (%d)", ret);
+		printk(KERN_ERR "%s: cannot get HW Config (error %d)\n",
+		       priv->netdev->name, ret);
 
 	return ret;
 }
@@ -768,15 +774,14 @@ static const char *at76_get_cmd_status_string(u8 cmd_status)
 /* Wait until the command is completed */
 static int at76_wait_completion(struct at76_priv *priv, int cmd)
 {
-	struct net_device *netdev = priv->netdev;
 	int status = 0;
 	unsigned long timeout = jiffies + CMD_COMPLETION_TIMEOUT;
 
 	do {
 		status = at76_get_cmd_status(priv->udev, cmd);
 		if (status < 0) {
-			err("%s: at76_get_cmd_status failed: %d", netdev->name,
-			    status);
+			printk(KERN_ERR "%s: at76_get_cmd_status failed: %d\n",
+			       priv->netdev->name, status);
 			break;
 		}
 
@@ -791,8 +796,9 @@ static int at76_wait_completion(struct at76_priv *priv, int cmd)
 
 		schedule_timeout_interruptible(HZ / 10);	/* 100 ms */
 		if (time_after(jiffies, timeout)) {
-			err("%s: timeout waiting for cmd %d completion",
-			    netdev->name, cmd);
+			printk(KERN_ERR
+			       "%s: completion timeout for command %d\n",
+			       priv->netdev->name, cmd);
 			status = -ETIMEDOUT;
 			break;
 		}
@@ -835,8 +841,8 @@ static int at76_set_radio(struct at76_priv *priv, int enable)
 
 	ret = at76_set_card_command(priv->udev, cmd, NULL, 0);
 	if (ret < 0)
-		err("%s: at76_set_card_command(CMD_RADIO) failed: %d",
-		    priv->netdev->name, ret);
+		printk(KERN_ERR "%s: at76_set_card_command(%d) failed: %d\n",
+		       priv->netdev->name, cmd, ret);
 	else
 		ret = 1;
 
@@ -856,8 +862,8 @@ static int at76_set_pm_mode(struct at76_priv *priv)
 
 	ret = at76_set_mib(priv, &priv->mib_buf);
 	if (ret < 0)
-		err("%s: set_mib (pm_mode) failed: %d", priv->netdev->name,
-		    ret);
+		printk(KERN_ERR "%s: set_mib (pm_mode) failed: %d\n",
+		       priv->netdev->name, ret);
 
 	return ret;
 }
@@ -874,8 +880,8 @@ static int at76_set_associd(struct at76_priv *priv, u16 id)
 
 	ret = at76_set_mib(priv, &priv->mib_buf);
 	if (ret < 0)
-		err("%s: set_mib (associd) failed: %d", priv->netdev->name,
-		    ret);
+		printk(KERN_ERR "%s: set_mib (associd) failed: %d\n",
+		       priv->netdev->name, ret);
 
 	return ret;
 }
@@ -892,8 +898,9 @@ static int at76_set_listen_interval(struct at76_priv *priv, u16 interval)
 
 	ret = at76_set_mib(priv, &priv->mib_buf);
 	if (ret < 0)
-		err("%s: set_mib (listen_interval) failed: %d",
-		    priv->netdev->name, ret);
+		printk(KERN_ERR
+		       "%s: set_mib (listen_interval) failed: %d\n",
+		       priv->netdev->name, ret);
 
 	return ret;
 }
@@ -909,8 +916,8 @@ static int at76_set_preamble(struct at76_priv *priv, u8 type)
 
 	ret = at76_set_mib(priv, &priv->mib_buf);
 	if (ret < 0)
-		err("%s: set_mib (preamble) failed: %d", priv->netdev->name,
-		    ret);
+		printk(KERN_ERR "%s: set_mib (preamble) failed: %d\n",
+		       priv->netdev->name, ret);
 
 	return ret;
 }
@@ -926,8 +933,8 @@ static int at76_set_frag(struct at76_priv *priv, u16 size)
 
 	ret = at76_set_mib(priv, &priv->mib_buf);
 	if (ret < 0)
-		err("%s: set_mib (frag threshold) failed: %d",
-		    priv->netdev->name, ret);
+		printk(KERN_ERR "%s: set_mib (frag threshold) failed: %d\n",
+		       priv->netdev->name, ret);
 
 	return ret;
 }
@@ -943,7 +950,8 @@ static int at76_set_rts(struct at76_priv *priv, u16 size)
 
 	ret = at76_set_mib(priv, &priv->mib_buf);
 	if (ret < 0)
-		err("%s: set_mib (rts) failed: %d", priv->netdev->name, ret);
+		printk(KERN_ERR "%s: set_mib (rts) failed: %d\n",
+		       priv->netdev->name, ret);
 
 	return ret;
 }
@@ -959,8 +967,8 @@ static int at76_set_autorate_fallback(struct at76_priv *priv, int onoff)
 
 	ret = at76_set_mib(priv, &priv->mib_buf);
 	if (ret < 0)
-		err("%s: set_mib (autorate fallback) failed: %d",
-		    priv->netdev->name, ret);
+		printk(KERN_ERR "%s: set_mib (autorate fallback) failed: %d\n",
+		       priv->netdev->name, ret);
 
 	return ret;
 }
@@ -976,8 +984,8 @@ static int at76_add_mac_address(struct at76_priv *priv, void *addr)
 
 	ret = at76_set_mib(priv, &priv->mib_buf);
 	if (ret < 0)
-		err("%s: set_mib (MAC_ADDR, mac_addr) failed: %d",
-		    priv->netdev->name, ret);
+		printk(KERN_ERR "%s: set_mib (MAC_ADDR, mac_addr) failed: %d\n",
+		       priv->netdev->name, ret);
 
 	return ret;
 }
@@ -997,8 +1005,8 @@ static int at76_set_group_address(struct at76_priv *priv, u8 *addr, int n)
 
 	ret = at76_set_mib(priv, &priv->mib_buf);
 	if (ret < 0)
-		err("%s: set_mib (MIB_MAC_ADDR, group_addr) failed: %d",
-		    priv->netdev->name, ret);
+		printk(KERN_ERR "%s: cannot set group address: %d\n",
+		       priv->netdev->name, ret);
 
 	/* I do not know anything about the group_addr_status field... (oku) */
 	priv->mib_buf.type = MIB_MAC_ADDR;
@@ -1009,8 +1017,8 @@ static int at76_set_group_address(struct at76_priv *priv, u8 *addr, int n)
 
 	ret = at76_set_mib(priv, &priv->mib_buf);
 	if (ret < 0)
-		err("%s: set_mib (MIB_MAC_ADDR, group_addr_status) failed: %d",
-		    priv->netdev->name, ret);
+		printk(KERN_ERR "%s: cannot set group address status: %d\n",
+		       priv->netdev->name, ret);
 
 	return ret;
 }
@@ -1029,8 +1037,8 @@ static void at76_dump_mib_mac_addr(struct at76_priv *priv)
 	ret = at76_get_mib(priv->udev, MIB_MAC_ADDR, m,
 			   sizeof(struct mib_mac_addr));
 	if (ret < 0) {
-		err("%s: at76_get_mib (MAC_ADDR) failed: %d",
-		    priv->netdev->name, ret);
+		printk(KERN_ERR "%s: at76_get_mib (MAC_ADDR) failed: %d\n",
+		       priv->netdev->name, ret);
 		goto exit;
 	}
 
@@ -1058,8 +1066,8 @@ static void at76_dump_mib_mac_wep(struct at76_priv *priv)
 	ret = at76_get_mib(priv->udev, MIB_MAC_WEP, m,
 			   sizeof(struct mib_mac_wep));
 	if (ret < 0) {
-		err("%s: at76_get_mib (MAC_WEP) failed: %d", priv->netdev->name,
-		    ret);
+		printk(KERN_ERR "%s: at76_get_mib (MAC_WEP) failed: %d\n",
+		       priv->netdev->name, ret);
 		goto exit;
 	}
 
@@ -1096,8 +1104,8 @@ static void at76_dump_mib_mac_mgmt(struct at76_priv *priv)
 	ret = at76_get_mib(priv->udev, MIB_MAC_MGMT, m,
 			   sizeof(struct mib_mac_mgmt));
 	if (ret < 0) {
-		err("%s: at76_get_mib (MAC_MGMT) failed: %d",
-		    priv->netdev->name, ret);
+		printk(KERN_ERR "%s: at76_get_mib (MAC_MGMT) failed: %d\n",
+		       priv->netdev->name, ret);
 		goto exit;
 	}
 
@@ -1135,8 +1143,8 @@ static void at76_dump_mib_mac(struct at76_priv *priv)
 
 	ret = at76_get_mib(priv->udev, MIB_MAC, m, sizeof(struct mib_mac));
 	if (ret < 0) {
-		err("%s: at76_get_mib (MAC) failed: %d", priv->netdev->name,
-		    ret);
+		printk(KERN_ERR "%s: at76_get_mib (MAC) failed: %d\n",
+		       priv->netdev->name, ret);
 		goto exit;
 	}
 
@@ -1171,8 +1179,8 @@ static void at76_dump_mib_phy(struct at76_priv *priv)
 
 	ret = at76_get_mib(priv->udev, MIB_PHY, m, sizeof(struct mib_phy));
 	if (ret < 0) {
-		err("%s: at76_get_mib (PHY) failed: %d", priv->netdev->name,
-		    ret);
+		printk(KERN_ERR "%s: at76_get_mib (PHY) failed: %d\n",
+		       priv->netdev->name, ret);
 		goto exit;
 	}
 
@@ -1204,8 +1212,8 @@ static void at76_dump_mib_local(struct at76_priv *priv)
 
 	ret = at76_get_mib(priv->udev, MIB_LOCAL, m, sizeof(struct mib_local));
 	if (ret < 0) {
-		err("%s: at76_get_mib (LOCAL) failed: %d", priv->netdev->name,
-		    ret);
+		printk(KERN_ERR "%s: at76_get_mib (LOCAL) failed: %d\n",
+		       priv->netdev->name, ret);
 		goto exit;
 	}
 
@@ -1229,8 +1237,8 @@ static void at76_dump_mib_mdomain(struct at76_priv *priv)
 	ret = at76_get_mib(priv->udev, MIB_MDOMAIN, m,
 			   sizeof(struct mib_mdomain));
 	if (ret < 0) {
-		err("%s: at76_get_mib (MDOMAIN) failed: %d", priv->netdev->name,
-		    ret);
+		printk(KERN_ERR "%s: at76_get_mib (MDOMAIN) failed: %d\n",
+		       priv->netdev->name, ret);
 		goto exit;
 	}
 
@@ -1259,7 +1267,8 @@ static int at76_get_current_bssid(struct at76_priv *priv)
 	ret = at76_get_mib(priv->udev, MIB_MAC_MGMT, mac_mgmt,
 			   sizeof(struct mib_mac_mgmt));
 	if (ret < 0) {
-		err("%s: at76_get_mib failed: %d", priv->netdev->name, ret);
+		printk(KERN_ERR "%s: at76_get_mib failed: %d\n",
+		       priv->netdev->name, ret);
 		goto error;
 	}
 	memcpy(priv->bssid, mac_mgmt->current_bssid, ETH_ALEN);
@@ -1282,8 +1291,8 @@ static int at76_get_current_channel(struct at76_priv *priv)
 	}
 	ret = at76_get_mib(priv->udev, MIB_PHY, phy, sizeof(struct mib_phy));
 	if (ret < 0) {
-		err("%s: at76_get_mib(MIB_PHY) failed: %d", priv->netdev->name,
-		    ret);
+		printk(KERN_ERR "%s: at76_get_mib(MIB_PHY) failed: %d\n",
+		       priv->netdev->name, ret);
 		goto error;
 	}
 	priv->channel = phy->channel_id;
@@ -1380,14 +1389,15 @@ static int at76_start_ibss(struct at76_priv *priv)
 	ret = at76_set_card_command(priv->udev, CMD_START_IBSS, &bss,
 				    sizeof(struct at76_req_ibss));
 	if (ret < 0) {
-		err("%s: start_ibss failed: %d", priv->netdev->name, ret);
+		printk(KERN_ERR "%s: start_ibss failed: %d\n",
+		       priv->netdev->name, ret);
 		return ret;
 	}
 
 	ret = at76_wait_completion(priv, CMD_START_IBSS);
 	if (ret != CMD_STATUS_COMPLETE) {
-		err("%s start_ibss failed to complete, %d",
-		    priv->netdev->name, ret);
+		printk(KERN_ERR "%s: start_ibss failed to complete, %d\n",
+		       priv->netdev->name, ret);
 		return ret;
 	}
 
@@ -1407,8 +1417,8 @@ static int at76_start_ibss(struct at76_priv *priv)
 
 	ret = at76_set_mib(priv, &priv->mib_buf);
 	if (ret < 0) {
-		err("%s: set_mib (ibss change ok) failed: %d",
-		    priv->netdev->name, ret);
+		printk(KERN_ERR "%s: set_mib (ibss change ok) failed: %d\n",
+		       priv->netdev->name, ret);
 		return ret;
 	}
 
@@ -1518,8 +1528,8 @@ static void at76_tx_callback(struct urb *urb)
 			  AT76_TX_HDRLEN, at76_tx_callback, priv);
 	ret = usb_submit_urb(priv->tx_urb, GFP_ATOMIC);
 	if (ret)
-		err("%s: %s error in tx submit urb: %d",
-		    priv->netdev->name, __func__, ret);
+		printk(KERN_ERR "%s: error in tx submit urb: %d\n",
+		       priv->netdev->name, ret);
 
 	kfree(mgmt_buf);
 }
@@ -1549,8 +1559,8 @@ static int at76_tx_mgmt(struct at76_priv *priv, struct at76_tx_buffer *txbuf)
 		/* a data/mgmt tx is already pending in the URB -
 		   if this is no error in some situations we must
 		   implement a queue or silently modify the old msg */
-		err("%s: %s removed pending mgmt buffer %s", priv->netdev->name,
-		    __func__, hex2str(oldbuf, 64));
+		printk(KERN_ERR "%s: removed pending mgmt buffer %s\n",
+		       priv->netdev->name, hex2str(oldbuf, 64));
 		kfree(oldbuf);
 		return 0;
 	}
@@ -1559,8 +1569,8 @@ static int at76_tx_mgmt(struct at76_priv *priv, struct at76_tx_buffer *txbuf)
 	txbuf->padding = at76_calc_padding(le16_to_cpu(txbuf->wlength));
 
 	if (priv->next_mgmt_bulk)
-		err("%s: %s URB status %d, but mgmt is pending",
-		    priv->netdev->name, __func__, urb_status);
+		printk(KERN_ERR "%s: URB status %d, but mgmt is pending\n",
+		       priv->netdev->name, urb_status);
 
 	at76_dbg(DBG_TX_MGMT,
 		 "%s: tx mgmt: wlen %d tx_rate %d pad %d %s",
@@ -1577,8 +1587,8 @@ static int at76_tx_mgmt(struct at76_priv *priv, struct at76_tx_buffer *txbuf)
 			  AT76_TX_HDRLEN, at76_tx_callback, priv);
 	ret = usb_submit_urb(priv->tx_urb, GFP_ATOMIC);
 	if (ret)
-		err("%s: %s error in tx submit urb: %d",
-		    priv->netdev->name, __func__, ret);
+		printk(KERN_ERR "%s: error in tx submit urb: %d\n",
+		       priv->netdev->name, ret);
 
 	kfree(txbuf);
 
@@ -3095,24 +3105,24 @@ static int at76_tx(struct sk_buff *skb, struct net_device *netdev)
 	struct ethhdr *eh = (struct ethhdr *)skb->data;
 
 	if (netif_queue_stopped(netdev)) {
-		err("%s: %s called while netdev is stopped", netdev->name,
-		    __func__);
+		printk(KERN_ERR "%s: %s called while netdev is stopped\n",
+		       netdev->name, __func__);
 		/* skip this packet */
 		dev_kfree_skb(skb);
 		return 0;
 	}
 
 	if (priv->tx_urb->status == -EINPROGRESS) {
-		err("%s: %s called while priv->tx_urb is pending for tx",
-		    netdev->name, __func__);
+		printk(KERN_ERR "%s: %s called while tx urb is pending\n",
+		       netdev->name, __func__);
 		/* skip this packet */
 		dev_kfree_skb(skb);
 		return 0;
 	}
 
 	if (skb->len < ETH_HLEN) {
-		err("%s: %s: skb too short (%d)", priv->netdev->name,
-		    __func__, skb->len);
+		printk(KERN_ERR "%s: %s: skb too short (%d)\n",
+		       netdev->name, __func__, skb->len);
 		dev_kfree_skb(skb);
 		return 0;
 	}
@@ -3132,11 +3142,11 @@ static int at76_tx(struct sk_buff *skb, struct net_device *netdev)
 			       skb->len - ETH_HLEN);
 			wlen = IEEE80211_3ADDR_LEN + skb->len - ETH_HLEN;
 		} else {
-			err("%s: %s: no support for non-SNAP 802.2 packets "
-			    "(DSAP 0x%02x SSAP 0x%02x cntrl 0x%02x)",
-			    priv->netdev->name, __func__,
-			    skb->data[ETH_HLEN], skb->data[ETH_HLEN + 1],
-			    skb->data[ETH_HLEN + 2]);
+			printk(KERN_ERR "%s: dropping non-SNAP 802.2 packet "
+			       "(DSAP 0x%02x SSAP 0x%02x cntrl 0x%02x)\n",
+			       priv->netdev->name, skb->data[ETH_HLEN],
+			       skb->data[ETH_HLEN + 1],
+			       skb->data[ETH_HLEN + 2]);
 			dev_kfree_skb(skb);
 			return 0;
 		}
@@ -3200,11 +3210,13 @@ static int at76_tx(struct sk_buff *skb, struct net_device *netdev)
 	ret = usb_submit_urb(priv->tx_urb, GFP_ATOMIC);
 	if (ret) {
 		stats->tx_errors++;
-		err("%s: error in tx submit urb: %d", netdev->name, ret);
+		printk(KERN_ERR "%s: error in tx submit urb: %d\n",
+		       netdev->name, ret);
 		if (ret == -EINVAL)
-			err("-EINVAL: urb %p urb->hcpriv %p urb->complete %p",
-			    priv->tx_urb, priv->tx_urb->hcpriv,
-			    priv->tx_urb->complete);
+			printk(KERN_ERR
+			       "%s: -EINVAL: tx urb %p hcpriv %p complete %p\n",
+			       priv->netdev->name, priv->tx_urb,
+			       priv->tx_urb->hcpriv, priv->tx_urb->complete);
 	} else {
 		stats->tx_bytes += skb->len;
 		dev_kfree_skb(skb);
@@ -3232,15 +3244,16 @@ static int at76_submit_rx_urb(struct at76_priv *priv)
 	struct sk_buff *skb = priv->rx_skb;
 
 	if (!priv->rx_urb) {
-		err("%s: priv->rx_urb is NULL", __func__);
+		printk(KERN_ERR "%s: %s: priv->rx_urb is NULL\n",
+		       priv->netdev->name, __func__);
 		return -EFAULT;
 	}
 
 	if (!skb) {
 		skb = dev_alloc_skb(sizeof(struct at76_rx_buffer));
 		if (!skb) {
-			err("%s: unable to allocate rx skbuff.",
-			    priv->netdev->name);
+			printk(KERN_ERR "%s: cannot allocate rx skbuff\n",
+			       priv->netdev->name);
 			ret = -ENOMEM;
 			goto exit;
 		}
@@ -3259,8 +3272,8 @@ static int at76_submit_rx_urb(struct at76_priv *priv)
 			at76_dbg(DBG_DEVSTART,
 				 "usb_submit_urb returned -ENODEV");
 		else
-			err("%s: rx, usb_submit_urb failed: %d",
-			    priv->netdev->name, ret);
+			printk(KERN_ERR "%s: rx, usb_submit_urb failed: %d\n",
+			       priv->netdev->name, ret);
 	}
 
 exit:
@@ -3295,7 +3308,8 @@ static int at76_open(struct net_device *netdev)
 
 	ret = at76_submit_rx_urb(priv);
 	if (ret < 0) {
-		err("%s: open: submit_rx_urb failed: %d", netdev->name, ret);
+		printk(KERN_ERR "%s: open: submit_rx_urb failed: %d\n",
+		       netdev->name, ret);
 		goto error;
 	}
 
@@ -3383,7 +3397,8 @@ static int at76_load_external_fw(struct usb_device *udev, struct fwentry *fwe)
 	at76_dbg(DBG_DEVSTART, "opmode %d", op_mode);
 
 	if (op_mode != OPMODE_NORMAL_NIC_WITHOUT_FLASH) {
-		err("unexpected opmode %d", op_mode);
+		printk(KERN_ERR DRIVER_NAME ": unexpected opmode %d\n",
+		       op_mode);
 		return -EINVAL;
 	}
 
@@ -3402,8 +3417,9 @@ static int at76_load_external_fw(struct usb_device *udev, struct fwentry *fwe)
 			 size, bsize, blockno);
 		ret = at76_load_ext_fw_block(udev, blockno, block, bsize);
 		if (ret != bsize) {
-			err("loading %dth firmware block failed: %d", blockno,
-			    ret);
+			printk(KERN_ERR DRIVER_NAME
+			       ": loading %dth firmware block failed: %d\n",
+			       blockno, ret);
 			goto exit;
 		}
 		buf += bsize;
@@ -3419,7 +3435,8 @@ static int at76_load_external_fw(struct usb_device *udev, struct fwentry *fwe)
 exit:
 	kfree(block);
 	if (ret < 0)
-		err("Downloading external firmware failed: %d", ret);
+		printk(KERN_ERR DRIVER_NAME
+		       ": downloading external firmware failed: %d\n", ret);
 	return ret;
 }
 
@@ -3433,7 +3450,8 @@ static int at76_load_internal_fw(struct usb_device *udev, struct fwentry *fwe)
 				   need_remap ? 0 : 2000);
 
 	if (ret < 0) {
-		err("downloading internal fw failed with %d", ret);
+		printk(KERN_ERR DRIVER_NAME
+		       ": downloading internal fw failed with %d\n", ret);
 		goto exit;
 	}
 
@@ -3443,7 +3461,8 @@ static int at76_load_internal_fw(struct usb_device *udev, struct fwentry *fwe)
 	if (need_remap) {
 		ret = at76_remap(udev);
 		if (ret < 0) {
-			err("sending REMAP failed with %d", ret);
+			printk(KERN_ERR DRIVER_NAME
+			       ": sending REMAP failed with %d\n", ret);
 			goto exit;
 		}
 	}
@@ -3616,18 +3635,18 @@ static void at76_work_join(struct work_struct *work)
 
 	ret = at76_join_bss(priv, priv->curr_bss);
 	if (ret < 0) {
-		err("%s: join_bss failed with %d", priv->netdev->name, ret);
+		printk(KERN_ERR "%s: join_bss failed with %d\n",
+		       priv->netdev->name, ret);
 		goto exit;
 	}
 
 	ret = at76_wait_completion(priv, CMD_JOIN);
 	if (ret != CMD_STATUS_COMPLETE) {
 		if (ret != CMD_STATUS_TIME_OUT)
-			err("%s join_bss completed with %d",
-			    priv->netdev->name, ret);
+			printk(KERN_ERR "%s: join_bss completed with %d\n",
+			       priv->netdev->name, ret);
 		else
-			printk(KERN_INFO
-			       "%s: join_bss ssid %s timed out\n",
+			printk(KERN_INFO "%s: join_bss ssid %s timed out\n",
 			       priv->netdev->name,
 			       mac2str(priv->curr_bss->bssid));
 
@@ -3681,8 +3700,8 @@ static void at76_dwork_get_scan(struct work_struct *work)
 
 	status = at76_get_cmd_status(priv->udev, CMD_SCAN);
 	if (status < 0) {
-		err("%s: %s: at76_get_cmd_status failed with %d",
-		    priv->netdev->name, __func__, status);
+		printk(KERN_ERR "%s: %s: at76_get_cmd_status failed with %d\n",
+		       priv->netdev->name, __func__, status);
 		status = CMD_STATUS_IN_PROGRESS;
 		/* INFO: Hope it was a one off error - if not, scanning
 		   further down the line and stop this cycle */
@@ -3695,9 +3714,9 @@ static void at76_dwork_get_scan(struct work_struct *work)
 	if (status != CMD_STATUS_COMPLETE) {
 		if ((status != CMD_STATUS_IN_PROGRESS) &&
 		    (status != CMD_STATUS_IDLE))
-			err("%s: %s: Bad scan status: %s",
-			    priv->netdev->name, __func__,
-			    at76_get_cmd_status_string(status));
+			printk(KERN_ERR "%s: %s: Bad scan status: %s\n",
+			       priv->netdev->name, __func__,
+			       at76_get_cmd_status_string(status));
 
 		/* the first cmd status after scan start is always a IDLE ->
 		   start the timer to poll again until COMPLETED */
@@ -3715,11 +3734,12 @@ static void at76_dwork_get_scan(struct work_struct *work)
 	if (priv->scan_need_any) {
 		ret = at76_start_scan(priv, 0);
 		if (ret < 0)
-			err("%s: %s: start_scan (ANY) failed with %d",
-			    priv->netdev->name, __func__, ret);
+			printk(KERN_ERR
+			       "%s: %s: start_scan (ANY) failed with %d\n",
+			       priv->netdev->name, __func__, ret);
 		at76_dbg(DBG_MGMT_TIMER,
-			 "%s:%d: starting mgmt_timer for %d ticks",
-			 __func__, __LINE__, SCAN_POLL_INTERVAL);
+			 "%s:%d: starting mgmt_timer for %d ticks", __func__,
+			 __LINE__, SCAN_POLL_INTERVAL);
 		schedule_delayed_work(&priv->dwork_get_scan,
 				      SCAN_POLL_INTERVAL);
 		priv->scan_need_any = 0;
@@ -3823,7 +3843,6 @@ static void at76_work_new_bss(struct work_struct *work)
 	struct at76_priv *priv = container_of(work, struct at76_priv,
 					      work_new_bss);
 	int ret;
-	struct net_device *netdev = priv->netdev;
 	struct mib_mac_mgmt mac_mgmt;
 
 	mutex_lock(&priv->mtx);
@@ -3831,7 +3850,8 @@ static void at76_work_new_bss(struct work_struct *work)
 	ret = at76_get_mib(priv->udev, MIB_MAC_MGMT, &mac_mgmt,
 			   sizeof(struct mib_mac_mgmt));
 	if (ret < 0) {
-		err("%s: at76_get_mib failed: %d", netdev->name, ret);
+		printk(KERN_ERR "%s: at76_get_mib failed: %d\n",
+		       priv->netdev->name, ret);
 		goto exit;
 	}
 
@@ -3848,8 +3868,8 @@ static void at76_work_new_bss(struct work_struct *work)
 
 	ret = at76_set_mib(priv, &priv->mib_buf);
 	if (ret < 0)
-		err("%s: set_mib (ibss change ok) failed: %d", netdev->name,
-		    ret);
+		printk(KERN_ERR "%s: set_mib (ibss change ok) failed: %d\n",
+		       priv->netdev->name, ret);
 
 exit:
 	mutex_unlock(&priv->mtx);
@@ -3928,8 +3948,8 @@ static int at76_startup_device(struct at76_priv *priv)
 	ret = at76_set_card_command(priv->udev, CMD_STARTUP, &priv->card_config,
 				    sizeof(struct at76_card_config));
 	if (ret < 0) {
-		err("%s: at76_set_card_command failed: %d", priv->netdev->name,
-		    ret);
+		printk(KERN_ERR "%s: at76_set_card_command failed: %d\n",
+		       priv->netdev->name, ret);
 		return ret;
 	}
 
@@ -4024,8 +4044,8 @@ static void at76_work_start_scan(struct work_struct *work)
 	ret = at76_start_scan(priv, 1);
 
 	if (ret < 0)
-		err("%s: %s: start_scan failed with %d",
-		    priv->netdev->name, __func__, ret);
+		printk(KERN_ERR "%s: %s: start_scan failed with %d\n",
+		       priv->netdev->name, __func__, ret);
 	else {
 		at76_dbg(DBG_MGMT_TIMER,
 			 "%s:%d: starting mgmt_timer for %d ticks",
@@ -4054,8 +4074,8 @@ static void at76_work_set_promisc(struct work_struct *work)
 
 	ret = at76_set_mib(priv, &priv->mib_buf);
 	if (ret < 0)
-		err("%s: set_mib (promiscuous_mode) failed: %d",
-		    priv->netdev->name, ret);
+		printk(KERN_ERR "%s: set_mib (promiscuous_mode) failed: %d\n",
+		       priv->netdev->name, ret);
 
 	mutex_unlock(&priv->mtx);
 }
@@ -4898,8 +4918,8 @@ static void at76_rx_monitor_mode(struct at76_priv *priv)
 
 	skb = dev_alloc_skb(skblen);
 	if (!skb) {
-		err("%s: MONITOR MODE: dev_alloc_skb for radiotap header "
-		    "returned NULL", priv->netdev->name);
+		printk(KERN_ERR "%s: MONITOR MODE: dev_alloc_skb for radiotap "
+		       "header returned NULL\n", priv->netdev->name);
 		return;
 	}
 
@@ -5051,9 +5071,11 @@ static struct fwentry *at76_load_firmware(struct usb_device *udev,
 	at76_dbg(DBG_FW, "downloading firmware %s", fwe->fwname);
 	ret = request_firmware(&fwe->fw, fwe->fwname, &udev->dev);
 	if (ret < 0) {
-		err("firmware %s not found.", fwe->fwname);
-		err("You may need to download the firmware from "
-		    "http://developer.berlios.de/projects/at76c503a/");
+		printk(KERN_ERR DRIVER_NAME ": firmware %s not found!\n",
+		       fwe->fwname);
+		printk(KERN_ERR DRIVER_NAME
+		       ": you may need to download the firmware from "
+		       "http://developer.berlios.de/projects/at76c503a/");
 		goto exit;
 	}
 
@@ -5061,15 +5083,17 @@ static struct fwentry *at76_load_firmware(struct usb_device *udev,
 	fwh = (struct at76_fw_header *)(fwe->fw->data);
 
 	if (fwe->fw->size <= sizeof(*fwh)) {
-		err("firmware is too short (0x%zx)", fwe->fw->size);
+		printk(KERN_ERR DRIVER_NAME ": firmware is too short (0x%zx)\n",
+		       fwe->fw->size);
 		goto exit;
 	}
 
 	/* CRC currently not checked */
 	fwe->board_type = le32_to_cpu(fwh->board_type);
 	if (fwe->board_type != board_type) {
-		err("board type mismatch, requested %u, got %u", board_type,
-		    fwe->board_type);
+		printk(KERN_ERR DRIVER_NAME
+		       ": board type mismatch, requested %u, got %u\n",
+		       board_type, fwe->board_type);
 		goto exit;
 	}
 
@@ -5112,7 +5136,7 @@ static struct at76_priv *at76_alloc_new_device(struct usb_device *udev)
 	/* allocate memory for our device state and initialize it */
 	netdev = alloc_etherdev(sizeof(struct at76_priv));
 	if (!netdev) {
-		err("out of memory");
+		printk(KERN_ERR DRIVER_NAME ": out of memory\n");
 		return NULL;
 	}
 
@@ -5241,7 +5265,8 @@ static int at76_init_new_device(struct at76_priv *priv,
 	/* MAC address */
 	ret = at76_get_hw_config(priv);
 	if (ret < 0) {
-		err("could not get MAC address");
+		printk(KERN_ERR "%s: cannot get MAC address\n",
+		       priv->netdev->name);
 		goto exit;
 	}
 
@@ -5283,8 +5308,8 @@ static int at76_init_new_device(struct at76_priv *priv,
 
 	ret = register_netdev(priv->netdev);
 	if (ret) {
-		err("unable to register netdevice %s (status %d)!",
-		    priv->netdev->name, ret);
+		printk(KERN_ERR "cannot register netdevice %s (status %d)!\n",
+		       priv->netdev->name, ret);
 		goto exit;
 	}
 	priv->netdev_registered = 1;
@@ -5387,8 +5412,8 @@ static int at76_probe(struct usb_interface *interface,
 	   we get 204 with 2.4.23, Fiberline FL-WL240u (505A+RFMD2958) ??? */
 
 	if (op_mode == OPMODE_HW_CONFIG_MODE) {
-		err("cannot handle a device in HW_CONFIG_MODE (opmode %d)",
-		    op_mode);
+		printk(KERN_ERR DRIVER_NAME
+		       ": cannot handle a device in HW_CONFIG_MODE\n");
 		ret = -EBUSY;
 		goto error;
 	}
@@ -5399,7 +5424,9 @@ static int at76_probe(struct usb_interface *interface,
 		at76_dbg(DBG_DEVSTART, "downloading internal firmware");
 		ret = at76_load_internal_fw(udev, fwe);
 		if (ret < 0) {
-			err("error %d downloading internal firmware", ret);
+			printk(KERN_ERR DRIVER_NAME
+			       ": error %d downloading internal firmware\n",
+			       ret);
 			goto error;
 		}
 		usb_put_dev(udev);
@@ -5433,7 +5460,8 @@ static int at76_probe(struct usb_interface *interface,
 		/* Re-check firmware version */
 		ret = at76_get_mib(udev, MIB_FW_VERSION, &fwv, sizeof(fwv));
 		if (ret < 0) {
-			err("error %d getting firmware version", ret);
+			printk(KERN_ERR DRIVER_NAME
+			       ": error %d getting firmware version\n", ret);
 			goto error;
 		}
 
@@ -5509,7 +5537,8 @@ static int __init at76_mod_init(void)
 	/* register this driver with the USB subsystem */
 	result = usb_register(&at76_driver);
 	if (result < 0)
-		err("usb_register failed (status %d)", result);
+		printk(KERN_ERR DRIVER_NAME
+		       ": usb_register failed (status %d)\n", result);
 
 	led_trigger_register_simple("at76_usb-tx", &ledtrig_tx);
 	return result;
