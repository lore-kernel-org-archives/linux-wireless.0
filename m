Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([18.85.46.34]:50730 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758917AbXLPW6W (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 16 Dec 2007 17:58:22 -0500
Subject: [PATCH 100/48] libertas: kill whitespace at end of lines
From: David Woodhouse <dwmw2@infradead.org>
In-Reply-To: <libertas-12345@shinybook.infradead.org>
To: John Linville <linville@tuxdriver.com>
Cc: Dan Williams <dcbw@redhat.com>, libertas-dev@lists.infradead.org,
	linux-wireless@vger.kernel.org
Message-Id: <E1J42Ro-00037r-OP@shinybook.infradead.org> (sfid-20071216_225827_991317_3FF8C421)
Date: Sun, 16 Dec 2007 17:59:00 -0500
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Date: Fri, 14 Dec 2007 22:53:41 -0500

Signed-off-by: David Woodhouse <dwmw2@infradead.org>
---
 drivers/net/wireless/libertas/cmd.c     |    2 +-
 drivers/net/wireless/libertas/cmd.h     |    4 ++--
 drivers/net/wireless/libertas/debugfs.c |    2 +-
 drivers/net/wireless/libertas/if_sdio.c |    2 +-
 drivers/net/wireless/libertas/if_usb.c  |    4 ++--
 drivers/net/wireless/libertas/main.c    |   14 +++++++-------
 drivers/net/wireless/libertas/tx.c      |    4 ++--
 7 files changed, 16 insertions(+), 16 deletions(-)

diff --git a/drivers/net/wireless/libertas/cmd.c b/drivers/net/wireless/libertas/cmd.c
index 171acc2..ffef721 100644
--- a/drivers/net/wireless/libertas/cmd.c
+++ b/drivers/net/wireless/libertas/cmd.c
@@ -1122,7 +1122,7 @@ int lbs_mesh_config(struct lbs_private *priv, uint16_t enable, uint16_t chan)
 	cmd.action = cpu_to_le16(enable);
 	cmd.channel = cpu_to_le16(chan);
 	cmd.type = cpu_to_le16(priv->mesh_tlv);
-	
+
 	if (enable) {
 		cmd.length = cpu_to_le16(priv->mesh_ssid_len);
 		memcpy(cmd.data, priv->mesh_ssid, priv->mesh_ssid_len);
diff --git a/drivers/net/wireless/libertas/cmd.h b/drivers/net/wireless/libertas/cmd.h
index a4aaa6b..999fabe 100644
--- a/drivers/net/wireless/libertas/cmd.h
+++ b/drivers/net/wireless/libertas/cmd.h
@@ -11,9 +11,9 @@
 
 #define lbs_cmd_with_response(priv, cmdnr, cmd)	\
 	lbs_cmd(priv, cmdnr, cmd, lbs_cmd_copyback, (unsigned long) (cmd))
- 
+
 int __lbs_cmd(struct lbs_private *priv, uint16_t command,
-	      struct cmd_header *in_cmd, int in_cmd_size, 
+	      struct cmd_header *in_cmd, int in_cmd_size,
 	      int (*callback)(struct lbs_private *, unsigned long, struct cmd_header *),
 	      unsigned long callback_arg);
 
diff --git a/drivers/net/wireless/libertas/debugfs.c b/drivers/net/wireless/libertas/debugfs.c
index f4858bd..226b183 100644
--- a/drivers/net/wireless/libertas/debugfs.c
+++ b/drivers/net/wireless/libertas/debugfs.c
@@ -295,7 +295,7 @@ static ssize_t lbs_setuserscan(struct file *file,
 
 	if (!buf)
 		return -ENOMEM;
-		
+
 	buf_size = min(count, len - 1);
 	if (copy_from_user(buf, userbuf, buf_size)) {
 		res = -EFAULT;
diff --git a/drivers/net/wireless/libertas/if_sdio.c b/drivers/net/wireless/libertas/if_sdio.c
index 85675c5..b24584d 100644
--- a/drivers/net/wireless/libertas/if_sdio.c
+++ b/drivers/net/wireless/libertas/if_sdio.c
@@ -19,7 +19,7 @@
  * current block size.
  *
  * As SDIO is still new to the kernel, it is unfortunately common with
- * bugs in the host controllers related to that. One such bug is that 
+ * bugs in the host controllers related to that. One such bug is that
  * controllers cannot do transfers that aren't a multiple of 4 bytes.
  * If you don't have time to fix the host controller driver, you can
  * work around the problem by modifying if_sdio_host_to_card() and
diff --git a/drivers/net/wireless/libertas/if_usb.c b/drivers/net/wireless/libertas/if_usb.c
index 9cb9e03..396ce67 100644
--- a/drivers/net/wireless/libertas/if_usb.c
+++ b/drivers/net/wireless/libertas/if_usb.c
@@ -152,7 +152,7 @@ static int if_usb_probe(struct usb_interface *intf,
 
 	setup_timer(&cardp->fw_timeout, if_usb_fw_timeo, (unsigned long)cardp);
 	init_waitqueue_head(&cardp->fw_wq);
-								     
+
 	cardp->udev = udev;
 	iface_desc = intf->cur_altsetting;
 
@@ -871,7 +871,7 @@ restart:
 
 	/* ... and wait for the process to complete */
 	wait_event_interruptible(cardp->fw_wq, cardp->surprise_removed || cardp->fwdnldover);
-	
+
 	del_timer_sync(&cardp->fw_timeout);
 	usb_kill_urb(cardp->rx_urb);
 
diff --git a/drivers/net/wireless/libertas/main.c b/drivers/net/wireless/libertas/main.c
index b51513f..0dc7de6 100644
--- a/drivers/net/wireless/libertas/main.c
+++ b/drivers/net/wireless/libertas/main.c
@@ -255,7 +255,7 @@ static int lbs_add_rtap(struct lbs_private *priv);
 static void lbs_remove_rtap(struct lbs_private *priv);
 static int lbs_add_mesh(struct lbs_private *priv);
 static void lbs_remove_mesh(struct lbs_private *priv);
-  
+
 
 /**
  * Get function for sysfs attribute rtap
@@ -347,7 +347,7 @@ static ssize_t lbs_mesh_set(struct device *dev,
 	ret = lbs_mesh_config(priv, enable, priv->curbssparams.channel);
 	if (ret)
 		return ret;
-		
+
 	if (enable)
 		lbs_add_mesh(priv);
 	else
@@ -401,7 +401,7 @@ static int lbs_dev_open(struct net_device *dev)
 		netif_carrier_on(dev);
 	} else {
 		priv->infra_open = 1;
-		
+
 		if (priv->connect_status == LBS_CONNECTED)
 			netif_carrier_on(dev);
 		else
@@ -433,7 +433,7 @@ static int lbs_mesh_stop(struct net_device *dev)
 
 	netif_stop_queue(dev);
 	netif_carrier_off(dev);
-	
+
 	spin_unlock_irq(&priv->driver_lock);
 	return 0;
 }
@@ -453,7 +453,7 @@ static int lbs_eth_stop(struct net_device *dev)
 	priv->infra_open = 0;
 
 	netif_stop_queue(dev);
-	
+
 	spin_unlock_irq(&priv->driver_lock);
 	return 0;
 }
@@ -850,7 +850,7 @@ int lbs_suspend(struct lbs_private *priv)
 	}
 
 	memset(&cmd, 0, sizeof(cmd));
-	
+
 	ret = __lbs_cmd(priv, CMD_802_11_HOST_SLEEP_ACTIVATE, &cmd,
 			sizeof(cmd), lbs_suspend_callback, 0);
 	if (ret)
@@ -1180,7 +1180,7 @@ int lbs_start_card(struct lbs_private *priv)
 	/* Enable mesh, if supported, and work out which TLV it uses.
 	   0x100 + 291 is an unofficial value used in 5.110.20.pXX
 	   0x100 + 37 is the official value used in 5.110.21.pXX
-	   but we check them in that order because 20.pXX doesn't 
+	   but we check them in that order because 20.pXX doesn't
 	   give an error -- it just silently fails. */
 
 	/* 5.110.20.pXX firmware will fail the command if the channel
diff --git a/drivers/net/wireless/libertas/tx.c b/drivers/net/wireless/libertas/tx.c
index 8a1a396..00d95f7 100644
--- a/drivers/net/wireless/libertas/tx.c
+++ b/drivers/net/wireless/libertas/tx.c
@@ -93,8 +93,8 @@ int lbs_hard_start_xmit(struct sk_buff *skb, struct net_device *dev)
 		netif_stop_queue(priv->mesh_dev);
 
 	if (priv->tx_pending_len) {
-		/* This can happen if packets come in on the mesh and eth 
-		   device simultaneously -- there's no mutual exclusion on 
+		/* This can happen if packets come in on the mesh and eth
+		   device simultaneously -- there's no mutual exclusion on
 		   hard_start_xmit() calls between devices. */
 		lbs_deb_tx("Packet on %s while busy\n", dev->name);
 		ret = NETDEV_TX_BUSY;
-- 
1.5.3.4

