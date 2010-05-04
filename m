Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from server19320154104.serverpool.info ([193.201.54.104]:43208 "EHLO
	hauke-m.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S934342Ab0EDWlN (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 4 May 2010 18:41:13 -0400
From: Hauke Mehrtens <hauke@hauke-m.de>
To: lrodriguez@atheros.com
Cc: linux-wireless@vger.kernel.org, mcgrof@infradead.org,
	Hauke Mehrtens <hauke@hauke-m.de>
Subject: [PATCH] compat-wireless: updates for orinoco
Date: Wed,  5 May 2010 00:40:50 +0200
Message-Id: <1273012850-8359-1-git-send-email-hauke@hauke-m.de>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

* Make all the patches apply again.
* rename read_pda to avoid conflicts with definitions in kernel <= 2.6.29
* add orinoco usb

Signed-off-by: Hauke Mehrtens <hauke@hauke-m.de>
---
 config.mk                                 |    2 +
 patches/01-netdev.patch                   |   51 +++++++++++++++++++++-----
 patches/24-pcmcia.patch                   |   10 +++---
 patches/27-hermes-read-pda-conflict.patch |   56 +++++++++++++++++++++++++++++
 4 files changed, 104 insertions(+), 15 deletions(-)
 create mode 100644 patches/27-hermes-read-pda-conflict.patch

diff --git a/config.mk b/config.mk
index 6a7c5c9..176c0af 100644
--- a/config.mk
+++ b/config.mk
@@ -388,6 +388,8 @@ CONFIG_LIBERTAS_USB=m
 NEED_LIBERTAS=y
 endif
 
+CONFIG_ORINOCO_USB=m
+
 endif # end of USB driver list
 
 ifneq ($(CONFIG_SPI_MASTER),)
diff --git a/patches/01-netdev.patch b/patches/01-netdev.patch
index 01dbbce..51d12c4 100644
--- a/patches/01-netdev.patch
+++ b/patches/01-netdev.patch
@@ -575,7 +575,7 @@ without creating a headache on maintenance of the pathes.
  	dev->tx_queue_len = 0;
 --- a/drivers/net/wireless/orinoco/main.c
 +++ b/drivers/net/wireless/orinoco/main.c
-@@ -2078,6 +2078,7 @@ int orinoco_init(struct orinoco_private 
+@@ -2087,6 +2087,7 @@ int orinoco_init(struct orinoco_private 
  }
  EXPORT_SYMBOL(orinoco_init);
  
@@ -583,7 +583,7 @@ without creating a headache on maintenance of the pathes.
  static const struct net_device_ops orinoco_netdev_ops = {
  	.ndo_open		= orinoco_open,
  	.ndo_stop		= orinoco_stop,
-@@ -2089,6 +2090,7 @@ static const struct net_device_ops orino
+@@ -2098,6 +2099,7 @@ static const struct net_device_ops orino
  	.ndo_tx_timeout		= orinoco_tx_timeout,
  	.ndo_get_stats		= orinoco_get_stats,
  };
@@ -591,12 +591,15 @@ without creating a headache on maintenance of the pathes.
  
  /* Allocate private data.
   *
-@@ -2211,7 +2213,18 @@ int orinoco_if_add(struct orinoco_privat
- 
- 	/* Setup / override net_device fields */
- 	dev->ieee80211_ptr = wdev;
+@@ -2227,10 +2229,21 @@ int orinoco_if_add(struct orinoco_privat
+ 	dev->wireless_data = &priv->wireless_data;
+ #endif
+ 	/* Default to standard ops if not set */
 +#if (LINUX_VERSION_CODE >= KERNEL_VERSION(2,6,29))
- 	dev->netdev_ops = &orinoco_netdev_ops;
+ 	if (ops)
+ 		dev->netdev_ops = ops;
+ 	else
+ 		dev->netdev_ops = &orinoco_netdev_ops;
 +#else
 +	dev->open = orinoco_open;
 +	dev->stop = orinoco_stop;
@@ -607,9 +610,37 @@ without creating a headache on maintenance of the pathes.
 +	dev->tx_timeout = orinoco_tx_timeout;
 +	dev->get_stats = orinoco_get_stats;
 +#endif
- 	dev->watchdog_timeo = HZ; /* 1 second timeout */
- 	dev->wireless_handlers = &orinoco_handler_def;
- #ifdef WIRELESS_SPY
+ 
+ 	/* we use the default eth_mac_addr for setting the MAC addr */
+ 
+--- a/drivers/net/wireless/orinoco/orinoco_usb.c
++++ b/drivers/net/wireless/orinoco/orinoco_usb.c
+@@ -1566,6 +1566,7 @@ static const struct hermes_ops ezusb_ops
+ 	.unlock_irq = ezusb_unlock_irq,
+ };
+ 
++#if (LINUX_VERSION_CODE >= KERNEL_VERSION(2,6,29))
+ static const struct net_device_ops ezusb_netdev_ops = {
+ 	.ndo_open		= orinoco_open,
+ 	.ndo_stop		= orinoco_stop,
+@@ -1577,6 +1578,7 @@ static const struct net_device_ops ezusb
+ 	.ndo_tx_timeout		= orinoco_tx_timeout,
+ 	.ndo_get_stats		= orinoco_get_stats,
+ };
++#endif
+ 
+ static int ezusb_probe(struct usb_interface *interface,
+ 		       const struct usb_device_id *id)
+@@ -1722,6 +1724,9 @@ static int ezusb_probe(struct usb_interf
+ 		err("%s: orinoco_if_add() failed", __func__);
+ 		goto error;
+ 	}
++#if (LINUX_VERSION_CODE < KERNEL_VERSION(2,6,29))
++	priv->ndev->hard_start_xmit = ezusb_xmit;
++#endif
+ 	upriv->dev = priv->ndev;
+ 
+ 	goto exit;
 --- a/net/bluetooth/bnep/netdev.c
 +++ b/net/bluetooth/bnep/netdev.c
 @@ -168,8 +168,12 @@ static inline int bnep_net_proto_filter(
diff --git a/patches/24-pcmcia.patch b/patches/24-pcmcia.patch
index 283b30d..3bc395d 100644
--- a/patches/24-pcmcia.patch
+++ b/patches/24-pcmcia.patch
@@ -251,9 +251,9 @@
  	/* Register an interface with the stack */
  	if (orinoco_if_add(priv, link->io.BasePort1,
 +#if (LINUX_VERSION_CODE >= KERNEL_VERSION(2,6,35))
- 			   link->irq) != 0) {
+ 			   link->irq, NULL) != 0) {
 +#else
-+			   link->irq.AssignedIRQ) != 0) {
++			   link->irq.AssignedIRQ, NULL) != 0) {
 +#endif
  		printk(KERN_ERR PFX "orinoco_if_add() failed\n");
  		goto failed;
@@ -285,14 +285,14 @@
  	if (ret)
  		goto failed;
  
-@@ -359,7 +369,11 @@ spectrum_cs_config(struct pcmcia_device 
+@@ -360,7 +370,11 @@ spectrum_cs_config(struct pcmcia_device 
  
  	/* Register an interface with the stack */
  	if (orinoco_if_add(priv, link->io.BasePort1,
 +#if (LINUX_VERSION_CODE >= KERNEL_VERSION(2,6,35))
- 			   link->irq) != 0) {
+ 			   link->irq, NULL) != 0) {
 +#else
-+			   link->irq.AssignedIRQ) != 0) {
++			   link->irq.AssignedIRQ, NULL) != 0) {
 +#endif
  		printk(KERN_ERR PFX "orinoco_if_add() failed\n");
  		goto failed;
diff --git a/patches/27-hermes-read-pda-conflict.patch b/patches/27-hermes-read-pda-conflict.patch
new file mode 100644
index 0000000..fe6b181
--- /dev/null
+++ b/patches/27-hermes-read-pda-conflict.patch
@@ -0,0 +1,56 @@
+Rename read_pda to something else because this symbol is used in a
+define for something else in arch/um/include/asm/pda.h on older kernels.
+
+--- a/drivers/net/wireless/orinoco/fw.c
++++ b/drivers/net/wireless/orinoco/fw.c
+@@ -122,7 +122,7 @@ orinoco_dl_firmware(struct orinoco_priva
+ 	dev_dbg(dev, "Attempting to download firmware %s\n", firmware);
+ 
+ 	/* Read current plug data */
+-	err = hw->ops->read_pda(hw, pda, fw->pda_addr, fw->pda_size);
++	err = hw->ops->read_pda_h(hw, pda, fw->pda_addr, fw->pda_size);
+ 	dev_dbg(dev, "Read PDA returned %d\n", err);
+ 	if (err)
+ 		goto free;
+@@ -224,7 +224,7 @@ symbol_dl_image(struct orinoco_private *
+ 		if (!pda)
+ 			return -ENOMEM;
+ 
+-		ret = hw->ops->read_pda(hw, pda, fw->pda_addr, fw->pda_size);
++		ret = hw->ops->read_pda_h(hw, pda, fw->pda_addr, fw->pda_size);
+ 		if (ret)
+ 			goto free;
+ 	}
+--- a/drivers/net/wireless/orinoco/hermes.c
++++ b/drivers/net/wireless/orinoco/hermes.c
+@@ -765,7 +765,7 @@ static const struct hermes_ops hermes_op
+ 	.write_ltv = hermes_write_ltv,
+ 	.bap_pread = hermes_bap_pread,
+ 	.bap_pwrite = hermes_bap_pwrite,
+-	.read_pda = hermes_read_pda,
++	.read_pda_h = hermes_read_pda,
+ 	.program_init = hermesi_program_init,
+ 	.program_end = hermesi_program_end,
+ 	.program = hermes_program_bytes,
+--- a/drivers/net/wireless/orinoco/hermes.h
++++ b/drivers/net/wireless/orinoco/hermes.h
+@@ -393,7 +393,7 @@ struct hermes_ops {
+ 			 u16 id, u16 offset);
+ 	int (*bap_pwrite)(struct hermes *hw, int bap, const void *buf,
+ 			  int len, u16 id, u16 offset);
+-	int (*read_pda)(struct hermes *hw, __le16 *pda,
++	int (*read_pda_h)(struct hermes *hw, __le16 *pda,
+ 			u32 pda_addr, u16 pda_len);
+ 	int (*program_init)(struct hermes *hw, u32 entry_point);
+ 	int (*program_end)(struct hermes *hw);
+--- a/drivers/net/wireless/orinoco/orinoco_usb.c
++++ b/drivers/net/wireless/orinoco/orinoco_usb.c
+@@ -1556,7 +1556,7 @@ static const struct hermes_ops ezusb_ops
+ 	.read_ltv = ezusb_read_ltv,
+ 	.write_ltv = ezusb_write_ltv,
+ 	.bap_pread = ezusb_bap_pread,
+-	.read_pda = ezusb_read_pda,
++	.read_pda_h = ezusb_read_pda,
+ 	.program_init = ezusb_program_init,
+ 	.program_end = ezusb_program_end,
+ 	.program = ezusb_program,
-- 
1.7.0.4

