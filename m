Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from server19320154104.serverpool.info ([193.201.54.104]:48611 "EHLO
	hauke-m.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753358Ab0ISR40 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Sun, 19 Sep 2010 13:56:26 -0400
From: Hauke Mehrtens <hauke@hauke-m.de>
To: lrodriguez@atheros.com
Cc: linux-wireless@vger.kernel.org, mcgrof@infradead.org,
	Hauke Mehrtens <hauke@hauke-m.de>
Subject: [PATCH 2/2 v2] compat-wireless: "backport" pcmcia api changes.
Date: Sun, 19 Sep 2010 19:56:09 +0200
Message-Id: <1284918969-19315-1-git-send-email-hauke@hauke-m.de>
In-Reply-To: <1284918553-32365-1-git-send-email-hauke@hauke-m.de>
References: <1284918553-32365-1-git-send-email-hauke@hauke-m.de>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

The PCMCIA API changed again.
This patch was only compile tested, beacuse I do not have devices to
test this.

Signed-off-by: Hauke Mehrtens <hauke@hauke-m.de>
---
 patches/24-pcmcia.patch |  836 ++++++++++++++++++++++++++++++++++++-----------
 1 files changed, 647 insertions(+), 189 deletions(-)

diff --git a/patches/24-pcmcia.patch b/patches/24-pcmcia.patch
index 6324a76..4e1aedb 100644
--- a/patches/24-pcmcia.patch
+++ b/patches/24-pcmcia.patch
@@ -1,6 +1,6 @@
 --- a/drivers/bluetooth/bluecard_cs.c
 +++ b/drivers/bluetooth/bluecard_cs.c
-@@ -159,7 +159,12 @@ static void bluecard_detach(struct pcmci
+@@ -158,7 +158,12 @@ static void bluecard_detach(struct pcmci
  static void bluecard_activity_led_timeout(u_long arg)
  {
  	bluecard_info_t *info = (bluecard_info_t *)arg;
@@ -13,7 +13,7 @@
  
  	if (!test_bit(CARD_HAS_PCCARD_ID, &(info->hw_state)))
  		return;
-@@ -176,7 +181,11 @@ static void bluecard_activity_led_timeou
+@@ -175,7 +180,11 @@ static void bluecard_activity_led_timeou
  
  static void bluecard_enable_activity_led(bluecard_info_t *info)
  {
@@ -25,7 +25,7 @@
  
  	if (!test_bit(CARD_HAS_PCCARD_ID, &(info->hw_state)))
  		return;
-@@ -232,7 +241,11 @@ static void bluecard_write_wakeup(blueca
+@@ -231,7 +240,11 @@ static void bluecard_write_wakeup(blueca
  	}
  
  	do {
@@ -37,7 +37,7 @@
  		register unsigned int offset;
  		register unsigned char command;
  		register unsigned long ready_bit;
-@@ -379,7 +392,11 @@ static void bluecard_receive(bluecard_in
+@@ -378,7 +391,11 @@ static void bluecard_receive(bluecard_in
  		return;
  	}
  
@@ -49,7 +49,7 @@
  
  	if (test_bit(XMIT_SENDING_READY, &(info->tx_state)))
  		bluecard_enable_activity_led(info);
-@@ -508,7 +525,11 @@ static irqreturn_t bluecard_interrupt(in
+@@ -507,7 +524,11 @@ static irqreturn_t bluecard_interrupt(in
  	if (!test_bit(CARD_READY, &(info->hw_state)))
  		return IRQ_HANDLED;
  
@@ -61,7 +61,7 @@
  
  	spin_lock(&(info->lock));
  
-@@ -622,7 +643,11 @@ static int bluecard_hci_flush(struct hci
+@@ -621,7 +642,11 @@ static int bluecard_hci_flush(struct hci
  static int bluecard_hci_open(struct hci_dev *hdev)
  {
  	bluecard_info_t *info = (bluecard_info_t *)(hdev->driver_data);
@@ -73,7 +73,7 @@
  
  	if (test_bit(CARD_HAS_PCCARD_ID, &(info->hw_state)))
  		bluecard_hci_set_baud_rate(hdev, DEFAULT_BAUD_RATE);
-@@ -642,7 +667,11 @@ static int bluecard_hci_open(struct hci_
+@@ -641,7 +666,11 @@ static int bluecard_hci_open(struct hci_
  static int bluecard_hci_close(struct hci_dev *hdev)
  {
  	bluecard_info_t *info = (bluecard_info_t *)(hdev->driver_data);
@@ -85,7 +85,7 @@
  
  	if (!test_and_clear_bit(HCI_RUNNING, &(hdev->flags)))
  		return 0;
-@@ -709,7 +738,11 @@ static int bluecard_hci_ioctl(struct hci
+@@ -708,7 +737,11 @@ static int bluecard_hci_ioctl(struct hci
  
  static int bluecard_open(bluecard_info_t *info)
  {
@@ -97,7 +97,7 @@
  	struct hci_dev *hdev;
  	unsigned char id;
  
-@@ -828,7 +861,11 @@ static int bluecard_open(bluecard_info_t
+@@ -827,7 +860,11 @@ static int bluecard_open(bluecard_info_t
  
  static int bluecard_close(bluecard_info_t *info)
  {
@@ -109,7 +109,7 @@
  	struct hci_dev *hdev = info->hdev;
  
  	if (!hdev)
-@@ -865,6 +902,12 @@ static int bluecard_probe(struct pcmcia_
+@@ -864,7 +901,18 @@ static int bluecard_probe(struct pcmcia_
  	info->p_dev = link;
  	link->priv = info;
  
@@ -119,12 +119,24 @@
 +	link->irq.Handler = bluecard_interrupt;
 +#endif
 +
- 	link->conf.Attributes = CONF_ENABLE_IRQ;
- 	link->conf.IntType = INT_MEMORY_AND_IO;
++#if (LINUX_VERSION_CODE >= KERNEL_VERSION(2,6,37))
+ 	link->config_flags |= CONF_ENABLE_IRQ;
++#else
++	link->conf.Attributes = CONF_ENABLE_IRQ;
++	link->conf.IntType = INT_MEMORY_AND_IO;
++#endif
  
-@@ -888,13 +931,24 @@ static int bluecard_config(struct pcmcia
+ 	return bluecard_config(link);
+ }
+@@ -884,15 +932,30 @@ static int bluecard_config(struct pcmcia
+ 	bluecard_info_t *info = link->priv;
+ 	int i, n;
  
- 	link->conf.ConfigIndex = 0x20;
++#if (LINUX_VERSION_CODE >= KERNEL_VERSION(2,6,37))
+ 	link->config_index = 0x20;
++#else
++	link->conf.ConfigIndex = 0x20;
++#endif
  
 +#if (LINUX_VERSION_CODE >= KERNEL_VERSION(2,6,36))
  	link->resource[0]->flags |= IO_DATA_PATH_WIDTH_8;
@@ -147,7 +159,7 @@
  		if (i == 0)
  			break;
  	}
-@@ -902,9 +956,15 @@ static int bluecard_config(struct pcmcia
+@@ -900,9 +963,15 @@ static int bluecard_config(struct pcmcia
  	if (i != 0)
  		goto failed;
  
@@ -161,11 +173,25 @@
 +		link->irq.AssignedIRQ = 0;
 +#endif
  
- 	i = pcmcia_request_configuration(link, &link->conf);
+ 	i = pcmcia_enable_device(link);
  	if (i != 0)
+@@ -940,7 +1009,13 @@ MODULE_DEVICE_TABLE(pcmcia, bluecard_ids
+ 
+ static struct pcmcia_driver bluecard_driver = {
+ 	.owner		= THIS_MODULE,
++#if (LINUX_VERSION_CODE >= KERNEL_VERSION(2,6,37))
+ 	.name		= "bluecard_cs",
++#else
++	.drv		= {
++		.name	= "bluecard_cs",
++	},
++#endif
+ 	.probe		= bluecard_probe,
+ 	.remove		= bluecard_detach,
+ 	.id_table	= bluecard_ids,
 --- a/drivers/bluetooth/bt3c_cs.c
 +++ b/drivers/bluetooth/bt3c_cs.c
-@@ -188,7 +188,11 @@ static void bt3c_write_wakeup(bt3c_info_
+@@ -187,7 +187,11 @@ static void bt3c_write_wakeup(bt3c_info_
  		return;
  
  	do {
@@ -177,7 +203,7 @@
  		register struct sk_buff *skb;
  		register int len;
  
-@@ -226,7 +230,11 @@ static void bt3c_receive(bt3c_info_t *in
+@@ -225,7 +229,11 @@ static void bt3c_receive(bt3c_info_t *in
  		return;
  	}
  
@@ -189,7 +215,7 @@
  
  	avail = bt3c_read(iobase, 0x7006);
  	//printk("bt3c_cs: receiving %d bytes\n", avail);
-@@ -347,7 +355,11 @@ static irqreturn_t bt3c_interrupt(int ir
+@@ -346,7 +354,11 @@ static irqreturn_t bt3c_interrupt(int ir
  		/* our irq handler is shared */
  		return IRQ_NONE;
  
@@ -201,7 +227,7 @@
  
  	spin_lock(&(info->lock));
  
-@@ -480,7 +492,11 @@ static int bt3c_load_firmware(bt3c_info_
+@@ -479,7 +491,11 @@ static int bt3c_load_firmware(bt3c_info_
  	unsigned int iobase, size, addr, fcs, tmp;
  	int i, err = 0;
  
@@ -213,13 +239,17 @@
  
  	/* Reset */
  	bt3c_io_write(iobase, 0x8040, 0x0404);
-@@ -657,8 +673,19 @@ static int bt3c_probe(struct pcmcia_devi
+@@ -656,8 +672,27 @@ static int bt3c_probe(struct pcmcia_devi
  	info->p_dev = link;
  	link->priv = info;
  
++#if (LINUX_VERSION_CODE >= KERNEL_VERSION(2,6,37))
+ 	link->config_flags |= CONF_ENABLE_IRQ | CONF_AUTO_SET_VPP |
+ 		CONF_AUTO_SET_IO;
++#else
 +#if (LINUX_VERSION_CODE >= KERNEL_VERSION(2,6,36))
- 	link->resource[0]->flags |= IO_DATA_PATH_WIDTH_8;
- 	link->resource[0]->end = 8;
++	link->resource[0]->flags |= IO_DATA_PATH_WIDTH_8;
++	link->resource[0]->end = 8;
 +#else
 +	link->io.Attributes1 = IO_DATA_PATH_WIDTH_8;
 +	link->io.NumPorts1= 8;
@@ -230,50 +260,86 @@
 +
 +	link->irq.Handler = bt3c_interrupt;
 +#endif
++
++	link->conf.Attributes = CONF_ENABLE_IRQ;
++	link->conf.IntType = INT_MEMORY_AND_IO;
++#endif
  
- 	link->conf.Attributes = CONF_ENABLE_IRQ;
- 	link->conf.IntType = INT_MEMORY_AND_IO;
-@@ -683,14 +710,23 @@ static int bt3c_check_config(struct pcmc
- {
- 	unsigned long try = (unsigned long) priv_data;
+ 	return bt3c_config(link);
+ }
+@@ -671,6 +706,7 @@ static void bt3c_detach(struct pcmcia_de
+ 	kfree(info);
+ }
  
++#if (LINUX_VERSION_CODE >= KERNEL_VERSION(2,6,37))
+ static int bt3c_check_config(struct pcmcia_device *p_dev, void *priv_data)
+ {
+ 	int *try = priv_data;
+@@ -709,6 +745,63 @@ static int bt3c_check_config_notpicky(st
+ 	}
+ 	return -ENODEV;
+ }
++#else
++static int bt3c_check_config(struct pcmcia_device *p_dev,
++			     cistpl_cftable_entry_t *cf,
++			     cistpl_cftable_entry_t *dflt,
++			     unsigned int vcc,
++			     void *priv_data)
++{
++	unsigned long try = (unsigned long) priv_data;
++
 +#if (LINUX_VERSION_CODE >= KERNEL_VERSION(2,6,36))
- 	p_dev->io_lines = (try == 0) ? 16 : cf->io.flags & CISTPL_IO_LINES_MASK;
++	p_dev->io_lines = (try == 0) ? 16 : cf->io.flags & CISTPL_IO_LINES_MASK;
 +#endif
- 
- 	if (cf->vpp1.present & (1 << CISTPL_POWER_VNOM))
- 		p_dev->conf.Vpp = cf->vpp1.param[CISTPL_POWER_VNOM] / 10000;
- 	if ((cf->io.nwin > 0) && (cf->io.win[0].len == 8) &&
- 	    (cf->io.win[0].base != 0)) {
++
++	if (cf->vpp1.present & (1 << CISTPL_POWER_VNOM))
++		p_dev->conf.Vpp = cf->vpp1.param[CISTPL_POWER_VNOM] / 10000;
++	if ((cf->io.nwin > 0) && (cf->io.win[0].len == 8) &&
++	    (cf->io.win[0].base != 0)) {
 +#if (LINUX_VERSION_CODE >= KERNEL_VERSION(2,6,36))
- 		p_dev->resource[0]->start = cf->io.win[0].base;
- 		if (!pcmcia_request_io(p_dev))
++		p_dev->resource[0]->start = cf->io.win[0].base;
++		if (!pcmcia_request_io(p_dev))
 +#else
 +		p_dev->io.BasePort1 = cf->io.win[0].base;
 +		p_dev->io.IOAddrLines = (try == 0) ? 16 :
 +			cf->io.flags & CISTPL_IO_LINES_MASK;
 +		if (!pcmcia_request_io(p_dev, &p_dev->io))
 +#endif
- 			return 0;
- 	}
- 	return -ENODEV;
-@@ -707,9 +743,15 @@ static int bt3c_check_config_notpicky(st
- 
- 	if ((cf->io.nwin > 0) && ((cf->io.flags & CISTPL_IO_LINES_MASK) <= 3)) {
- 		for (j = 0; j < 5; j++) {
++			return 0;
++	}
++	return -ENODEV;
++}
++
++static int bt3c_check_config_notpicky(struct pcmcia_device *p_dev,
++				      cistpl_cftable_entry_t *cf,
++				      cistpl_cftable_entry_t *dflt,
++				      unsigned int vcc,
++				      void *priv_data)
++{
++	static unsigned int base[5] = { 0x3f8, 0x2f8, 0x3e8, 0x2e8, 0x0 };
++	int j;
++
++	if ((cf->io.nwin > 0) && ((cf->io.flags & CISTPL_IO_LINES_MASK) <= 3)) {
++		for (j = 0; j < 5; j++) {
 +#if (LINUX_VERSION_CODE >= KERNEL_VERSION(2,6,36))
- 			p_dev->resource[0]->start = base[j];
- 			p_dev->io_lines = base[j] ? 16 : 3;
- 			if (!pcmcia_request_io(p_dev))
++			p_dev->resource[0]->start = base[j];
++			p_dev->io_lines = base[j] ? 16 : 3;
++			if (!pcmcia_request_io(p_dev))
 +#else
 +			p_dev->io.BasePort1 = base[j];
 +			p_dev->io.IOAddrLines = base[j] ? 16 : 3;
 +			if (!pcmcia_request_io(p_dev, &p_dev->io))
 +#endif
- 				return 0;
- 		}
- 	}
-@@ -738,9 +780,15 @@ static int bt3c_config(struct pcmcia_dev
++				return 0;
++		}
++	}
++	return -ENODEV;
++}
++#endif
+ 
+ static int bt3c_config(struct pcmcia_device *link)
+ {
+@@ -732,9 +825,15 @@ static int bt3c_config(struct pcmcia_dev
  	goto failed;
  
  found_port:
@@ -287,11 +353,25 @@
 +		link->irq.AssignedIRQ = 0;
 +#endif
  
- 	i = pcmcia_request_configuration(link, &link->conf);
+ 	i = pcmcia_enable_device(link);
  	if (i != 0)
+@@ -769,7 +868,13 @@ MODULE_DEVICE_TABLE(pcmcia, bt3c_ids);
+ 
+ static struct pcmcia_driver bt3c_driver = {
+ 	.owner		= THIS_MODULE,
++#if (LINUX_VERSION_CODE >= KERNEL_VERSION(2,6,37))
+ 	.name		= "bt3c_cs",
++#else
++	.drv		= {
++		.name	= "bt3c_cs",
++	},
++#endif
+ 	.probe		= bt3c_probe,
+ 	.remove		= bt3c_detach,
+ 	.id_table	= bt3c_ids,
 --- a/drivers/bluetooth/btuart_cs.c
 +++ b/drivers/bluetooth/btuart_cs.c
-@@ -142,7 +142,11 @@ static void btuart_write_wakeup(btuart_i
+@@ -141,7 +141,11 @@ static void btuart_write_wakeup(btuart_i
  	}
  
  	do {
@@ -303,7 +383,7 @@
  		register struct sk_buff *skb;
  		register int len;
  
-@@ -183,7 +187,11 @@ static void btuart_receive(btuart_info_t
+@@ -182,7 +186,11 @@ static void btuart_receive(btuart_info_t
  		return;
  	}
  
@@ -315,7 +395,7 @@
  
  	do {
  		info->hdev->stat.byte_rx++;
-@@ -297,7 +305,11 @@ static irqreturn_t btuart_interrupt(int 
+@@ -296,7 +304,11 @@ static irqreturn_t btuart_interrupt(int 
  		/* our irq handler is shared */
  		return IRQ_NONE;
  
@@ -327,7 +407,7 @@
  
  	spin_lock(&(info->lock));
  
-@@ -354,7 +366,11 @@ static void btuart_change_speed(btuart_i
+@@ -353,7 +365,11 @@ static void btuart_change_speed(btuart_i
  		return;
  	}
  
@@ -339,7 +419,7 @@
  
  	spin_lock_irqsave(&(info->lock), flags);
  
-@@ -478,7 +494,11 @@ static int btuart_hci_ioctl(struct hci_d
+@@ -477,7 +493,11 @@ static int btuart_hci_ioctl(struct hci_d
  static int btuart_open(btuart_info_t *info)
  {
  	unsigned long flags;
@@ -351,7 +431,7 @@
  	struct hci_dev *hdev;
  
  	spin_lock_init(&(info->lock));
-@@ -548,7 +568,11 @@ static int btuart_open(btuart_info_t *in
+@@ -547,7 +567,11 @@ static int btuart_open(btuart_info_t *in
  static int btuart_close(btuart_info_t *info)
  {
  	unsigned long flags;
@@ -363,13 +443,17 @@
  	struct hci_dev *hdev = info->hdev;
  
  	if (!hdev)
-@@ -586,8 +610,19 @@ static int btuart_probe(struct pcmcia_de
+@@ -585,8 +609,27 @@ static int btuart_probe(struct pcmcia_de
  	info->p_dev = link;
  	link->priv = info;
  
++#if (LINUX_VERSION_CODE >= KERNEL_VERSION(2,6,37))
+ 	link->config_flags |= CONF_ENABLE_IRQ | CONF_AUTO_SET_VPP |
+ 		CONF_AUTO_SET_IO;
++#else
 +#if (LINUX_VERSION_CODE >= KERNEL_VERSION(2,6,36))
- 	link->resource[0]->flags |= IO_DATA_PATH_WIDTH_8;
- 	link->resource[0]->end = 8;
++	link->resource[0]->flags |= IO_DATA_PATH_WIDTH_8;
++	link->resource[0]->end = 8;
 +#else
 +	link->io.Attributes1 = IO_DATA_PATH_WIDTH_8;
 +	link->io.NumPorts1= 8;
@@ -380,50 +464,86 @@
 +
 +	link->irq.Handler = btuart_interrupt;
 +#endif
++
++	link->conf.Attributes = CONF_ENABLE_IRQ;
++	link->conf.IntType = INT_MEMORY_AND_IO;
++#endif
+ 
+ 	return btuart_config(link);
+ }
+@@ -600,6 +643,7 @@ static void btuart_detach(struct pcmcia_
+ 	kfree(info);
+ }
  
- 	link->conf.Attributes = CONF_ENABLE_IRQ;
- 	link->conf.IntType = INT_MEMORY_AND_IO;
-@@ -612,14 +647,23 @@ static int btuart_check_config(struct pc
++#if (LINUX_VERSION_CODE >= KERNEL_VERSION(2,6,37))
+ static int btuart_check_config(struct pcmcia_device *p_dev, void *priv_data)
  {
  	int *try = priv_data;
- 
+@@ -638,6 +682,63 @@ static int btuart_check_config_notpicky(
+ 	}
+ 	return -ENODEV;
+ }
++#else
++static int btuart_check_config(struct pcmcia_device *p_dev,
++			       cistpl_cftable_entry_t *cf,
++			       cistpl_cftable_entry_t *dflt,
++			       unsigned int vcc,
++			       void *priv_data)
++{
++	int *try = priv_data;
++
 +#if (LINUX_VERSION_CODE >= KERNEL_VERSION(2,6,36))
- 	p_dev->io_lines = (try == 0) ? 16 : cf->io.flags & CISTPL_IO_LINES_MASK;
++	p_dev->io_lines = (try == 0) ? 16 : cf->io.flags & CISTPL_IO_LINES_MASK;
 +#endif
- 
- 	if (cf->vpp1.present & (1 << CISTPL_POWER_VNOM))
- 		p_dev->conf.Vpp = cf->vpp1.param[CISTPL_POWER_VNOM] / 10000;
- 	if ((cf->io.nwin > 0) && (cf->io.win[0].len == 8) &&
- 	    (cf->io.win[0].base != 0)) {
++
++	if (cf->vpp1.present & (1 << CISTPL_POWER_VNOM))
++		p_dev->conf.Vpp = cf->vpp1.param[CISTPL_POWER_VNOM] / 10000;
++	if ((cf->io.nwin > 0) && (cf->io.win[0].len == 8) &&
++	    (cf->io.win[0].base != 0)) {
 +#if (LINUX_VERSION_CODE >= KERNEL_VERSION(2,6,36))
- 		p_dev->resource[0]->start = cf->io.win[0].base;
- 		if (!pcmcia_request_io(p_dev))
++		p_dev->resource[0]->start = cf->io.win[0].base;
++		if (!pcmcia_request_io(p_dev))
 +#else
 +		p_dev->io.BasePort1 = cf->io.win[0].base;
 +		p_dev->io.IOAddrLines = (*try == 0) ? 16 :
 +			cf->io.flags & CISTPL_IO_LINES_MASK;
 +		if (!pcmcia_request_io(p_dev, &p_dev->io))
 +#endif
- 			return 0;
- 	}
- 	return -ENODEV;
-@@ -636,9 +680,15 @@ static int btuart_check_config_notpicky(
- 
- 	if ((cf->io.nwin > 0) && ((cf->io.flags & CISTPL_IO_LINES_MASK) <= 3)) {
- 		for (j = 0; j < 5; j++) {
++			return 0;
++	}
++	return -ENODEV;
++}
++
++static int btuart_check_config_notpicky(struct pcmcia_device *p_dev,
++					cistpl_cftable_entry_t *cf,
++					cistpl_cftable_entry_t *dflt,
++					unsigned int vcc,
++					void *priv_data)
++{
++	static unsigned int base[5] = { 0x3f8, 0x2f8, 0x3e8, 0x2e8, 0x0 };
++	int j;
++
++	if ((cf->io.nwin > 0) && ((cf->io.flags & CISTPL_IO_LINES_MASK) <= 3)) {
++		for (j = 0; j < 5; j++) {
 +#if (LINUX_VERSION_CODE >= KERNEL_VERSION(2,6,36))
- 			p_dev->resource[0]->start = base[j];
- 			p_dev->io_lines = base[j] ? 16 : 3;
- 			if (!pcmcia_request_io(p_dev))
++			p_dev->resource[0]->start = base[j];
++			p_dev->io_lines = base[j] ? 16 : 3;
++			if (!pcmcia_request_io(p_dev))
 +#else
 +			p_dev->io.BasePort1 = base[j];
 +			p_dev->io.IOAddrLines = base[j] ? 16 : 3;
 +			if (!pcmcia_request_io(p_dev, &p_dev->io))
 +#endif
- 				return 0;
- 		}
- 	}
-@@ -667,9 +717,15 @@ static int btuart_config(struct pcmcia_d
++				return 0;
++		}
++	}
++	return -ENODEV;
++}
++#endif
+ 
+ static int btuart_config(struct pcmcia_device *link)
+ {
+@@ -661,9 +762,15 @@ static int btuart_config(struct pcmcia_d
  	goto failed;
  
  found_port:
@@ -437,11 +557,25 @@
 +		link->irq.AssignedIRQ = 0;
 +#endif
  
- 	i = pcmcia_request_configuration(link, &link->conf);
+ 	i = pcmcia_enable_device(link);
  	if (i != 0)
+@@ -697,7 +804,13 @@ MODULE_DEVICE_TABLE(pcmcia, btuart_ids);
+ 
+ static struct pcmcia_driver btuart_driver = {
+ 	.owner		= THIS_MODULE,
++#if (LINUX_VERSION_CODE >= KERNEL_VERSION(2,6,37))
+ 	.name		= "btuart_cs",
++#else
++	.drv		= {
++		.name	= "btuart_cs",
++	},
++#endif
+ 	.probe		= btuart_probe,
+ 	.remove		= btuart_detach,
+ 	.id_table	= btuart_ids,
 --- a/drivers/bluetooth/dtl1_cs.c
 +++ b/drivers/bluetooth/dtl1_cs.c
-@@ -149,7 +149,11 @@ static void dtl1_write_wakeup(dtl1_info_
+@@ -148,7 +148,11 @@ static void dtl1_write_wakeup(dtl1_info_
  	}
  
  	do {
@@ -453,7 +587,7 @@
  		register struct sk_buff *skb;
  		register int len;
  
-@@ -214,7 +218,11 @@ static void dtl1_receive(dtl1_info_t *in
+@@ -213,7 +217,11 @@ static void dtl1_receive(dtl1_info_t *in
  		return;
  	}
  
@@ -465,7 +599,7 @@
  
  	do {
  		info->hdev->stat.byte_rx++;
-@@ -301,7 +309,11 @@ static irqreturn_t dtl1_interrupt(int ir
+@@ -300,7 +308,11 @@ static irqreturn_t dtl1_interrupt(int ir
  		/* our irq handler is shared */
  		return IRQ_NONE;
  
@@ -477,7 +611,7 @@
  
  	spin_lock(&(info->lock));
  
-@@ -461,7 +473,11 @@ static int dtl1_hci_ioctl(struct hci_dev
+@@ -460,7 +472,11 @@ static int dtl1_hci_ioctl(struct hci_dev
  static int dtl1_open(dtl1_info_t *info)
  {
  	unsigned long flags;
@@ -489,7 +623,7 @@
  	struct hci_dev *hdev;
  
  	spin_lock_init(&(info->lock));
-@@ -508,8 +524,13 @@ static int dtl1_open(dtl1_info_t *info)
+@@ -507,8 +523,13 @@ static int dtl1_open(dtl1_info_t *info)
  	outb(UART_LCR_WLEN8, iobase + UART_LCR);	/* Reset DLAB */
  	outb((UART_MCR_DTR | UART_MCR_RTS | UART_MCR_OUT2), iobase + UART_MCR);
  
@@ -503,7 +637,7 @@
  
  	/* Turn on interrupts */
  	outb(UART_IER_RLSI | UART_IER_RDI | UART_IER_THRI, iobase + UART_IER);
-@@ -534,7 +555,11 @@ static int dtl1_open(dtl1_info_t *info)
+@@ -533,7 +554,11 @@ static int dtl1_open(dtl1_info_t *info)
  static int dtl1_close(dtl1_info_t *info)
  {
  	unsigned long flags;
@@ -515,13 +649,16 @@
  	struct hci_dev *hdev = info->hdev;
  
  	if (!hdev)
-@@ -572,8 +597,17 @@ static int dtl1_probe(struct pcmcia_devi
+@@ -571,7 +596,24 @@ static int dtl1_probe(struct pcmcia_devi
  	info->p_dev = link;
  	link->priv = info;
  
++#if (LINUX_VERSION_CODE >= KERNEL_VERSION(2,6,37))
+ 	link->config_flags |= CONF_ENABLE_IRQ | CONF_AUTO_SET_IO;
++#else
 +#if (LINUX_VERSION_CODE >= KERNEL_VERSION(2,6,36))
- 	link->resource[0]->flags |= IO_DATA_PATH_WIDTH_8;
- 	link->resource[0]->end = 8;
++	link->resource[0]->flags |= IO_DATA_PATH_WIDTH_8;
++	link->resource[0]->end = 8;
 +#else
 +	link->io.Attributes1 = IO_DATA_PATH_WIDTH_8;
 +	link->io.NumPorts1= 8;
@@ -530,28 +667,52 @@
 +	link->irq.Attributes = IRQ_TYPE_DYNAMIC_SHARING;
 +	link->irq.Handler = dtl1_interrupt;
 +#endif
++
++	link->conf.Attributes = CONF_ENABLE_IRQ;
++	link->conf.IntType = INT_MEMORY_AND_IO;
++#endif
  
- 	link->conf.Attributes = CONF_ENABLE_IRQ;
- 	link->conf.IntType = INT_MEMORY_AND_IO;
-@@ -600,10 +634,17 @@ static int dtl1_confcheck(struct pcmcia_
- 	if ((cf->io.nwin != 1) || (cf->io.win[0].len <= 8))
- 		return -ENODEV;
+ 	return dtl1_config(link);
+ }
+@@ -586,6 +628,7 @@ static void dtl1_detach(struct pcmcia_de
+ 	kfree(info);
+ }
+ 
++#if (LINUX_VERSION_CODE >= KERNEL_VERSION(2,6,37))
+ static int dtl1_confcheck(struct pcmcia_device *p_dev, void *priv_data)
+ {
+ 	if ((p_dev->resource[1]->end) || (p_dev->resource[1]->end < 8))
+@@ -596,6 +639,29 @@ static int dtl1_confcheck(struct pcmcia_
  
-+#if (LINUX_VERSION_CODE >= KERNEL_VERSION(2,6,36))
- 	p_dev->resource[0]->start = cf->io.win[0].base;
- 	p_dev->resource[0]->end = cf->io.win[0].len;	/*yo */
- 	p_dev->io_lines = cf->io.flags & CISTPL_IO_LINES_MASK;
  	return pcmcia_request_io(p_dev);
+ }
++#else
++static int dtl1_confcheck(struct pcmcia_device *p_dev,
++			  cistpl_cftable_entry_t *cf,
++			  cistpl_cftable_entry_t *dflt,
++			  unsigned int vcc,
++			  void *priv_data)
++{
++	if ((cf->io.nwin != 1) || (cf->io.win[0].len <= 8))
++		return -ENODEV;
++
++#if (LINUX_VERSION_CODE >= KERNEL_VERSION(2,6,36))
++	p_dev->resource[0]->start = cf->io.win[0].base;
++	p_dev->resource[0]->end = cf->io.win[0].len;	/*yo */
++	p_dev->io_lines = cf->io.flags & CISTPL_IO_LINES_MASK;
++	return pcmcia_request_io(p_dev);
 +#else
 +	p_dev->io.BasePort1 = cf->io.win[0].base;
 +	p_dev->io.NumPorts1 = cf->io.win[0].len;	/*yo */
 +	p_dev->io.IOAddrLines = cf->io.flags & CISTPL_IO_LINES_MASK;
 +	return pcmcia_request_io(p_dev, &p_dev->io);
 +#endif
- }
++}
++#endif
  
  static int dtl1_config(struct pcmcia_device *link)
-@@ -612,13 +653,23 @@ static int dtl1_config(struct pcmcia_dev
+ {
+@@ -603,13 +669,23 @@ static int dtl1_config(struct pcmcia_dev
  	int i;
  
  	/* Look for a generic full-sized window */
@@ -573,11 +734,65 @@
 +		link->irq.AssignedIRQ = 0;
 +#endif
  
- 	i = pcmcia_request_configuration(link, &link->conf);
+ 	i = pcmcia_enable_device(link);
  	if (i != 0)
+@@ -647,7 +723,13 @@ MODULE_DEVICE_TABLE(pcmcia, dtl1_ids);
+ 
+ static struct pcmcia_driver dtl1_driver = {
+ 	.owner		= THIS_MODULE,
++#if (LINUX_VERSION_CODE >= KERNEL_VERSION(2,6,37))
+ 	.name		= "dtl1_cs",
++#else
++	.drv		= {
++		.name	= "dtl1_cs",
++	},
++#endif
+ 	.probe		= dtl1_probe,
+ 	.remove		= dtl1_detach,
+ 	.id_table	= dtl1_ids,
 --- a/drivers/net/wireless/b43/pcmcia.c
 +++ b/drivers/net/wireless/b43/pcmcia.c
-@@ -89,7 +89,14 @@ static int __devinit b43_pcmcia_probe(st
+@@ -62,6 +62,9 @@ static int b43_pcmcia_resume(struct pcmc
+ static int __devinit b43_pcmcia_probe(struct pcmcia_device *dev)
+ {
+ 	struct ssb_bus *ssb;
++#if (LINUX_VERSION_CODE < KERNEL_VERSION(2,6,37))
++	win_req_t win;
++#endif
+ 	int err = -ENOMEM;
+ 	int res = 0;
+ 
+@@ -71,6 +74,7 @@ static int __devinit b43_pcmcia_probe(st
+ 
+ 	err = -ENODEV;
+ 
++#if (LINUX_VERSION_CODE >= KERNEL_VERSION(2,6,37))
+ 	dev->config_flags |= CONF_ENABLE_IRQ;
+ 
+ 	dev->resource[2]->flags |=  WIN_ENABLE | WIN_DATA_WIDTH_16 |
+@@ -78,21 +82,46 @@ static int __devinit b43_pcmcia_probe(st
+ 	dev->resource[2]->start = 0;
+ 	dev->resource[2]->end = SSB_CORE_SIZE;
+ 	res = pcmcia_request_window(dev, dev->resource[2], 250);
++#else
++	dev->conf.Attributes = CONF_ENABLE_IRQ;
++	dev->conf.IntType = INT_MEMORY_AND_IO;
++
++	win.Attributes =  WIN_ENABLE | WIN_DATA_WIDTH_16 |
++			 WIN_USE_WAIT;
++	win.Base = 0;
++	win.Size = SSB_CORE_SIZE;
++	win.AccessSpeed = 250;
++	res = pcmcia_request_window(dev, &win, &dev->win);
++#endif
+ 	if (res != 0)
+ 		goto err_kfree_ssb;
+-
++#if (LINUX_VERSION_CODE >= KERNEL_VERSION(2,6,37))
+ 	res = pcmcia_map_mem_page(dev, dev->resource[2], 0);
++#else
++	res = pcmcia_map_mem_page(dev, dev->win, 0);
++#endif
  	if (res != 0)
  		goto err_disable;
  
@@ -591,10 +806,35 @@
 +#endif
  		goto err_disable;
  
- 	res = pcmcia_request_configuration(dev, &dev->conf);
+ 	res = pcmcia_enable_device(dev);
+ 	if (res != 0)
+ 		goto err_disable;
+ 
++#if (LINUX_VERSION_CODE >= KERNEL_VERSION(2,6,37))
+ 	err = ssb_bus_pcmciabus_register(ssb, dev, dev->resource[2]->start);
++#else
++	err = ssb_bus_pcmciabus_register(ssb, dev, win.Base);
++#endif
+ 	if (err)
+ 		goto err_disable;
+ 	dev->priv = ssb;
+@@ -121,7 +150,13 @@ static void __devexit b43_pcmcia_remove(
+ 
+ static struct pcmcia_driver b43_pcmcia_driver = {
+ 	.owner		= THIS_MODULE,
++#if (LINUX_VERSION_CODE >= KERNEL_VERSION(2,6,37))
+ 	.name		= "b43-pcmcia",
++#else
++	.drv		= {
++		.name	= "b43-pcmcia",
++	},
++#endif
+ 	.id_table	= b43_pcmcia_tbl,
+ 	.probe		= b43_pcmcia_probe,
+ 	.remove		= __devexit_p(b43_pcmcia_remove),
 --- a/drivers/net/wireless/libertas/if_cs.c
 +++ b/drivers/net/wireless/libertas/if_cs.c
-@@ -774,7 +774,11 @@ static void if_cs_release(struct pcmcia_
+@@ -764,7 +764,11 @@ static void if_cs_release(struct pcmcia_
  
  	lbs_deb_enter(LBS_DEB_CS);
  
@@ -606,24 +846,45 @@
  	pcmcia_disable_device(p_dev);
  	if (card->iobase)
  		ioport_unmap(card->iobase);
-@@ -799,9 +803,15 @@ static int if_cs_ioprobe(struct pcmcia_d
- 			 unsigned int vcc,
- 			 void *priv_data)
+@@ -772,7 +776,7 @@ static void if_cs_release(struct pcmcia_
+ 	lbs_deb_leave(LBS_DEB_CS);
+ }
+ 
+-
++#if (LINUX_VERSION_CODE >= KERNEL_VERSION(2,6,37))
+ static int if_cs_ioprobe(struct pcmcia_device *p_dev, void *priv_data)
  {
+ 	p_dev->resource[0]->flags &= ~IO_DATA_PATH_WIDTH;
+@@ -782,9 +786,39 @@ static int if_cs_ioprobe(struct pcmcia_d
+ 		lbs_pr_err("wrong CIS (check number of IO windows)\n");
+ 		return -ENODEV;
+ 	}
++#else
++static int if_cs_ioprobe(struct pcmcia_device *p_dev,
++			 cistpl_cftable_entry_t *cfg,
++			 cistpl_cftable_entry_t *dflt,
++			 unsigned int vcc,
++			 void *priv_data)
++{
 +#if (LINUX_VERSION_CODE >= KERNEL_VERSION(2,6,36))
- 	p_dev->resource[0]->flags |= IO_DATA_PATH_WIDTH_AUTO;
- 	p_dev->resource[0]->start = cfg->io.win[0].base;
- 	p_dev->resource[0]->end = cfg->io.win[0].len;
++	p_dev->resource[0]->flags |= IO_DATA_PATH_WIDTH_AUTO;
++	p_dev->resource[0]->start = cfg->io.win[0].base;
++	p_dev->resource[0]->end = cfg->io.win[0].len;
 +#else
 +	p_dev->io.Attributes1 = IO_DATA_PATH_WIDTH_AUTO;
 +	p_dev->io.BasePort1 = cfg->io.win[0].base;
 +	p_dev->io.NumPorts1 = cfg->io.win[0].len;
 +#endif
- 
- 	/* Do we need to allocate an interrupt? */
- 	p_dev->conf.Attributes |= CONF_ENABLE_IRQ;
-@@ -813,7 +823,11 @@ static int if_cs_ioprobe(struct pcmcia_d
- 	}
++
++	/* Do we need to allocate an interrupt? */
++	p_dev->conf.Attributes |= CONF_ENABLE_IRQ;
++
++	/* IO window settings */
++	if (cfg->io.nwin != 1) {
++		lbs_pr_err("wrong CIS (check number of IO windows)\n");
++		return -ENODEV;
++	}
++#endif
  
  	/* This reserves IO space but doesn't actually enable it */
 +#if (LINUX_VERSION_CODE >= KERNEL_VERSION(2,6,36))
@@ -634,19 +895,24 @@
  }
  
  static int if_cs_probe(struct pcmcia_device *p_dev)
-@@ -835,6 +849,11 @@ static int if_cs_probe(struct pcmcia_dev
+@@ -806,7 +840,16 @@ static int if_cs_probe(struct pcmcia_dev
  	card->p_dev = p_dev;
  	p_dev->priv = card;
  
++#if (LINUX_VERSION_CODE >= KERNEL_VERSION(2,6,37))
+ 	p_dev->config_flags |= CONF_ENABLE_IRQ | CONF_AUTO_SET_IO;
++#else
 +#if (LINUX_VERSION_CODE < KERNEL_VERSION(2,6,35))
 +	p_dev->irq.Attributes = IRQ_TYPE_DYNAMIC_SHARING;
 +	p_dev->irq.Handler = NULL;
 +#endif
-+
- 	p_dev->conf.Attributes = 0;
- 	p_dev->conf.IntType = INT_MEMORY_AND_IO;
++	p_dev->conf.Attributes = 0;
++	p_dev->conf.IntType = INT_MEMORY_AND_IO;
++#endif
  
-@@ -848,12 +867,26 @@ static int if_cs_probe(struct pcmcia_dev
+ 	if (pcmcia_loop_config(p_dev, if_cs_ioprobe, NULL)) {
+ 		lbs_pr_err("error in pcmcia_loop_config\n");
+@@ -818,12 +861,26 @@ static int if_cs_probe(struct pcmcia_dev
  	 * a handler to the interrupt, unless the 'Handler' member of
  	 * the irq structure is initialized.
  	 */
@@ -673,7 +939,7 @@
  	if (!card->iobase) {
  		lbs_pr_err("error in ioport_map\n");
  		ret = -EIO;
-@@ -872,7 +905,17 @@ static int if_cs_probe(struct pcmcia_dev
+@@ -837,7 +894,17 @@ static int if_cs_probe(struct pcmcia_dev
  	}
  
  	/* Finally, report what we've done */
@@ -691,7 +957,7 @@
  
  	/*
  	 * Most of the libertas cards can do unaligned register access, but some
-@@ -941,7 +984,11 @@ static int if_cs_probe(struct pcmcia_dev
+@@ -906,7 +973,11 @@ static int if_cs_probe(struct pcmcia_dev
  	priv->fw_ready = 1;
  
  	/* Now actually get the IRQ */
@@ -703,9 +969,23 @@
  		IRQF_SHARED, DRV_NAME, card);
  	if (ret) {
  		lbs_pr_err("error in request_irq\n");
+@@ -977,7 +1048,13 @@ MODULE_DEVICE_TABLE(pcmcia, if_cs_ids);
+ 
+ static struct pcmcia_driver lbs_driver = {
+ 	.owner		= THIS_MODULE,
++#if (LINUX_VERSION_CODE >= KERNEL_VERSION(2,6,37))
+ 	.name		= DRV_NAME,
++#else
++	.drv		= {
++		.name	= DRV_NAME,
++	},
++#endif
+ 	.probe		= if_cs_probe,
+ 	.remove		= if_cs_detach,
+ 	.id_table       = if_cs_ids,
 --- a/drivers/net/wireless/orinoco/orinoco_cs.c
 +++ b/drivers/net/wireless/orinoco/orinoco_cs.c
-@@ -79,7 +79,11 @@ orinoco_cs_hard_reset(struct orinoco_pri
+@@ -78,7 +78,11 @@ orinoco_cs_hard_reset(struct orinoco_pri
  	/* We need atomic ops here, because we're not holding the lock */
  	set_bit(0, &card->hard_reset_in_progress);
  
@@ -717,7 +997,7 @@
  	if (err)
  		return err;
  
-@@ -117,6 +121,12 @@ orinoco_cs_probe(struct pcmcia_device *l
+@@ -108,6 +112,16 @@ orinoco_cs_probe(struct pcmcia_device *l
  	card->p_dev = link;
  	link->priv = priv;
  
@@ -726,28 +1006,81 @@
 +	link->irq.Attributes = IRQ_TYPE_DYNAMIC_SHARING;
 +	link->irq.Handler = orinoco_interrupt;
 +#endif
++#if (LINUX_VERSION_CODE < KERNEL_VERSION(2,6,37))
++	link->conf.Attributes = 0;
++	link->conf.IntType = INT_MEMORY_AND_IO;
++#endif
 +
- 	/* General socket configuration defaults can go here.  In this
- 	 * client, we assume very little, and rely on the CIS for
- 	 * almost everything.  In most clients, many details (i.e.,
-@@ -191,23 +201,48 @@ static int orinoco_cs_config_check(struc
- 	p_dev->conf.Attributes |= CONF_ENABLE_IRQ;
+ 	return orinoco_cs_config(link);
+ }				/* orinoco_cs_attach */
+ 
+@@ -122,6 +136,7 @@ static void orinoco_cs_detach(struct pcm
+ 	free_orinocodev(priv);
+ }				/* orinoco_cs_detach */
  
- 	/* IO window settings */
++#if (LINUX_VERSION_CODE >= KERNEL_VERSION(2,6,37))
+ static int orinoco_cs_config_check(struct pcmcia_device *p_dev, void *priv_data)
+ {
+ 	if (p_dev->config_index == 0)
+@@ -129,6 +144,98 @@ static int orinoco_cs_config_check(struc
+ 
+ 	return pcmcia_request_io(p_dev);
+ };
++#else
++static int orinoco_cs_config_check(struct pcmcia_device *p_dev,
++				   cistpl_cftable_entry_t *cfg,
++				   cistpl_cftable_entry_t *dflt,
++				   unsigned int vcc,
++				   void *priv_data)
++{
++	if (cfg->index == 0)
++		goto next_entry;
++
++	/* Use power settings for Vcc and Vpp if present */
++	/* Note that the CIS values need to be rescaled */
++	if (cfg->vcc.present & (1 << CISTPL_POWER_VNOM)) {
++		if (vcc != cfg->vcc.param[CISTPL_POWER_VNOM] / 10000) {
++			DEBUG(2, "%s: Vcc mismatch (vcc = %d, CIS = %d)\n",
++			      __func__, vcc,
++			      cfg->vcc.param[CISTPL_POWER_VNOM] / 10000);
++			if (!ignore_cis_vcc)
++				goto next_entry;
++		}
++	} else if (dflt->vcc.present & (1 << CISTPL_POWER_VNOM)) {
++		if (vcc != dflt->vcc.param[CISTPL_POWER_VNOM] / 10000) {
++			DEBUG(2, "%s: Vcc mismatch (vcc = %d, CIS = %d)\n",
++			      __func__, vcc,
++			      dflt->vcc.param[CISTPL_POWER_VNOM] / 10000);
++			if (!ignore_cis_vcc)
++				goto next_entry;
++		}
++	}
++
++	if (cfg->vpp1.present & (1 << CISTPL_POWER_VNOM))
++		p_dev->conf.Vpp =
++			cfg->vpp1.param[CISTPL_POWER_VNOM] / 10000;
++	else if (dflt->vpp1.present & (1 << CISTPL_POWER_VNOM))
++		p_dev->conf.Vpp =
++			dflt->vpp1.param[CISTPL_POWER_VNOM] / 10000;
++
++	/* Do we need to allocate an interrupt? */
++	p_dev->conf.Attributes |= CONF_ENABLE_IRQ;
++
++	/* IO window settings */
 +#if LINUX_VERSION_CODE >= KERNEL_VERSION(2,6,36)
- 	p_dev->resource[0]->end = p_dev->resource[1]->end = 0;
++	p_dev->resource[0]->end = p_dev->resource[1]->end = 0;
 +#else
 +	p_dev->io.NumPorts1 = p_dev->io.NumPorts2 = 0;
 +#endif
- 	if ((cfg->io.nwin > 0) || (dflt->io.nwin > 0)) {
- 		cistpl_io_t *io = (cfg->io.nwin) ? &cfg->io : &dflt->io;
++	if ((cfg->io.nwin > 0) || (dflt->io.nwin > 0)) {
++		cistpl_io_t *io = (cfg->io.nwin) ? &cfg->io : &dflt->io;
 +#if LINUX_VERSION_CODE >= KERNEL_VERSION(2,6,36)
- 		p_dev->io_lines = io->flags & CISTPL_IO_LINES_MASK;
- 		p_dev->resource[0]->flags &= ~IO_DATA_PATH_WIDTH;
- 		p_dev->resource[0]->flags |=
- 			pcmcia_io_cfg_data_width(io->flags);
- 		p_dev->resource[0]->start = io->win[0].base;
- 		p_dev->resource[0]->end = io->win[0].len;
++		p_dev->io_lines = io->flags & CISTPL_IO_LINES_MASK;
++		p_dev->resource[0]->flags &= ~IO_DATA_PATH_WIDTH;
++		p_dev->resource[0]->flags |=
++			pcmcia_io_cfg_data_width(io->flags);
++		p_dev->resource[0]->start = io->win[0].base;
++		p_dev->resource[0]->end = io->win[0].len;
 +#else
 +		p_dev->io.Attributes1 = IO_DATA_PATH_WIDTH_AUTO;
 +		if (!(io->flags & CISTPL_IO_8BIT))
@@ -758,28 +1091,50 @@
 +		p_dev->io.BasePort1 = io->win[0].base;
 +		p_dev->io.NumPorts1 = io->win[0].len;
 +#endif
- 		if (io->nwin > 1) {
++		if (io->nwin > 1) {
 +#if LINUX_VERSION_CODE >= KERNEL_VERSION(2,6,36)
- 			p_dev->resource[1]->flags = p_dev->resource[0]->flags;
- 			p_dev->resource[1]->start = io->win[1].base;
- 			p_dev->resource[1]->end = io->win[1].len;
++			p_dev->resource[1]->flags = p_dev->resource[0]->flags;
++			p_dev->resource[1]->start = io->win[1].base;
++			p_dev->resource[1]->end = io->win[1].len;
 +#else
 +			p_dev->io.Attributes2 = p_dev->io.Attributes1;
 +			p_dev->io.BasePort2 = io->win[1].base;
 +			p_dev->io.NumPorts2 = io->win[1].len;
 +#endif
- 		}
- 
- 		/* This reserves IO space but doesn't actually enable it */
++		}
++
++		/* This reserves IO space but doesn't actually enable it */
 +#if LINUX_VERSION_CODE >= KERNEL_VERSION(2,6,36)
- 		if (pcmcia_request_io(p_dev) != 0)
++		if (pcmcia_request_io(p_dev) != 0)
 +#else
 +		if (pcmcia_request_io(p_dev, &p_dev->io) != 0)
 +#endif
- 			goto next_entry;
- 	}
- 	return 0;
-@@ -248,15 +283,23 @@ orinoco_cs_config(struct pcmcia_device *
++			goto next_entry;
++	}
++	return 0;
++
++next_entry:
++	pcmcia_disable_device(p_dev);
++	return -ENODEV;
++};
++#endif
+ 
+ static int
+ orinoco_cs_config(struct pcmcia_device *link)
+@@ -138,10 +245,12 @@ orinoco_cs_config(struct pcmcia_device *
+ 	int ret;
+ 	void __iomem *mem;
+ 
++#if (LINUX_VERSION_CODE >= KERNEL_VERSION(2,6,37))
+ 	link->config_flags |= CONF_AUTO_SET_VPP | CONF_AUTO_CHECK_VCC |
+ 		CONF_AUTO_SET_IO | CONF_ENABLE_IRQ;
+ 	if (ignore_cis_vcc)
+ 		link->config_flags &= ~CONF_AUTO_CHECK_VCC;
++#endif
+ 	ret = pcmcia_loop_config(link, orinoco_cs_config_check, NULL);
+ 	if (ret) {
+ 		if (!ignore_cis_vcc)
+@@ -151,15 +260,23 @@ orinoco_cs_config(struct pcmcia_device *
  		goto failed;
  	}
  
@@ -803,7 +1158,7 @@
  	if (!mem)
  		goto failed;
  
-@@ -278,8 +321,16 @@ orinoco_cs_config(struct pcmcia_device *
+@@ -176,8 +293,16 @@ orinoco_cs_config(struct pcmcia_device *
  	}
  
  	/* Register an interface with the stack */
@@ -820,9 +1175,23 @@
  		printk(KERN_ERR PFX "orinoco_if_add() failed\n");
  		goto failed;
  	}
+@@ -328,7 +453,13 @@ MODULE_DEVICE_TABLE(pcmcia, orinoco_cs_i
+ 
+ static struct pcmcia_driver orinoco_driver = {
+ 	.owner		= THIS_MODULE,
++#if (LINUX_VERSION_CODE >= KERNEL_VERSION(2,6,37))
+ 	.name		= DRIVER_NAME,
++#else
++	.drv		= {
++		.name	= DRIVER_NAME,
++	},
++#endif
+ 	.probe		= orinoco_cs_probe,
+ 	.remove		= orinoco_cs_detach,
+ 	.id_table       = orinoco_cs_ids,
 --- a/drivers/net/wireless/orinoco/spectrum_cs.c
 +++ b/drivers/net/wireless/orinoco/spectrum_cs.c
-@@ -179,6 +179,12 @@ spectrum_cs_probe(struct pcmcia_device *
+@@ -170,6 +170,16 @@ spectrum_cs_probe(struct pcmcia_device *
  	card->p_dev = link;
  	link->priv = priv;
  
@@ -831,28 +1200,81 @@
 +	link->irq.Attributes = IRQ_TYPE_DYNAMIC_SHARING;
 +	link->irq.Handler = orinoco_interrupt;
 +#endif
++#if (LINUX_VERSION_CODE < KERNEL_VERSION(2,6,37))
++	link->conf.Attributes = 0;
++	link->conf.IntType = INT_MEMORY_AND_IO;
++#endif
 +
- 	/* General socket configuration defaults can go here.  In this
- 	 * client, we assume very little, and rely on the CIS for
- 	 * almost everything.  In most clients, many details (i.e.,
-@@ -253,23 +259,48 @@ static int spectrum_cs_config_check(stru
- 	p_dev->conf.Attributes |= CONF_ENABLE_IRQ;
+ 	return spectrum_cs_config(link);
+ }				/* spectrum_cs_attach */
+ 
+@@ -184,6 +194,7 @@ static void spectrum_cs_detach(struct pc
+ 	free_orinocodev(priv);
+ }				/* spectrum_cs_detach */
+ 
++#if (LINUX_VERSION_CODE >= KERNEL_VERSION(2,6,37))
+ static int spectrum_cs_config_check(struct pcmcia_device *p_dev,
+ 				    void *priv_data)
+ {
+@@ -192,6 +203,98 @@ static int spectrum_cs_config_check(stru
  
- 	/* IO window settings */
+ 	return pcmcia_request_io(p_dev);
+ };
++#else
++static int spectrum_cs_config_check(struct pcmcia_device *p_dev,
++				    cistpl_cftable_entry_t *cfg,
++				    cistpl_cftable_entry_t *dflt,
++				    unsigned int vcc,
++				    void *priv_data)
++{
++	if (cfg->index == 0)
++		goto next_entry;
++
++	/* Use power settings for Vcc and Vpp if present */
++	/* Note that the CIS values need to be rescaled */
++	if (cfg->vcc.present & (1 << CISTPL_POWER_VNOM)) {
++		if (vcc != cfg->vcc.param[CISTPL_POWER_VNOM] / 10000) {
++			DEBUG(2, "%s: Vcc mismatch (vcc = %d, CIS = %d)\n",
++			      __func__, vcc,
++			      cfg->vcc.param[CISTPL_POWER_VNOM] / 10000);
++			if (!ignore_cis_vcc)
++				goto next_entry;
++		}
++	} else if (dflt->vcc.present & (1 << CISTPL_POWER_VNOM)) {
++		if (vcc != dflt->vcc.param[CISTPL_POWER_VNOM] / 10000) {
++			DEBUG(2, "%s: Vcc mismatch (vcc = %d, CIS = %d)\n",
++			      __func__, vcc,
++			      dflt->vcc.param[CISTPL_POWER_VNOM] / 10000);
++			if (!ignore_cis_vcc)
++				goto next_entry;
++		}
++	}
++
++	if (cfg->vpp1.present & (1 << CISTPL_POWER_VNOM))
++		p_dev->conf.Vpp =
++			cfg->vpp1.param[CISTPL_POWER_VNOM] / 10000;
++	else if (dflt->vpp1.present & (1 << CISTPL_POWER_VNOM))
++		p_dev->conf.Vpp =
++			dflt->vpp1.param[CISTPL_POWER_VNOM] / 10000;
++
++	/* Do we need to allocate an interrupt? */
++	p_dev->conf.Attributes |= CONF_ENABLE_IRQ;
++
++	/* IO window settings */
 +#if LINUX_VERSION_CODE >= KERNEL_VERSION(2,6,36)
- 	p_dev->resource[0]->end = p_dev->resource[1]->end = 0;
++	p_dev->resource[0]->end = p_dev->resource[1]->end = 0;
 +#else
 +	p_dev->io.NumPorts1 = p_dev->io.NumPorts2 = 0;
 +#endif
- 	if ((cfg->io.nwin > 0) || (dflt->io.nwin > 0)) {
- 		cistpl_io_t *io = (cfg->io.nwin) ? &cfg->io : &dflt->io;
++	if ((cfg->io.nwin > 0) || (dflt->io.nwin > 0)) {
++		cistpl_io_t *io = (cfg->io.nwin) ? &cfg->io : &dflt->io;
 +#if LINUX_VERSION_CODE >= KERNEL_VERSION(2,6,36)
- 		p_dev->io_lines = io->flags & CISTPL_IO_LINES_MASK;
- 		p_dev->resource[0]->flags &= ~IO_DATA_PATH_WIDTH;
- 		p_dev->resource[0]->flags |=
- 			pcmcia_io_cfg_data_width(io->flags);
- 		p_dev->resource[0]->start = io->win[0].base;
- 		p_dev->resource[0]->end = io->win[0].len;
++		p_dev->io_lines = io->flags & CISTPL_IO_LINES_MASK;
++		p_dev->resource[0]->flags &= ~IO_DATA_PATH_WIDTH;
++		p_dev->resource[0]->flags |=
++			pcmcia_io_cfg_data_width(io->flags);
++		p_dev->resource[0]->start = io->win[0].base;
++		p_dev->resource[0]->end = io->win[0].len;
 +#else
 +		p_dev->io.Attributes1 = IO_DATA_PATH_WIDTH_AUTO;
 +		if (!(io->flags & CISTPL_IO_8BIT))
@@ -863,28 +1285,50 @@
 +		p_dev->io.BasePort1 = io->win[0].base;
 +		p_dev->io.NumPorts1 = io->win[0].len;
 +#endif
- 		if (io->nwin > 1) {
++		if (io->nwin > 1) {
 +#if LINUX_VERSION_CODE >= KERNEL_VERSION(2,6,36)
- 			p_dev->resource[1]->flags = p_dev->resource[0]->flags;
- 			p_dev->resource[1]->start = io->win[1].base;
- 			p_dev->resource[1]->end = io->win[1].len;
++			p_dev->resource[1]->flags = p_dev->resource[0]->flags;
++			p_dev->resource[1]->start = io->win[1].base;
++			p_dev->resource[1]->end = io->win[1].len;
 +#else
 +			p_dev->io.Attributes2 = p_dev->io.Attributes1;
 +			p_dev->io.BasePort2 = io->win[1].base;
 +			p_dev->io.NumPorts2 = io->win[1].len;
 +#endif
- 		}
- 
- 		/* This reserves IO space but doesn't actually enable it */
++		}
++
++		/* This reserves IO space but doesn't actually enable it */
 +#if LINUX_VERSION_CODE >= KERNEL_VERSION(2,6,36)
- 		if (pcmcia_request_io(p_dev) != 0)
++		if (pcmcia_request_io(p_dev) != 0)
 +#else
 +		if (pcmcia_request_io(p_dev, &p_dev->io) != 0)
 +#endif
- 			goto next_entry;
- 	}
- 	return 0;
-@@ -310,15 +341,23 @@ spectrum_cs_config(struct pcmcia_device 
++			goto next_entry;
++	}
++	return 0;
++
++next_entry:
++	pcmcia_disable_device(p_dev);
++	return -ENODEV;
++};
++#endif
+ 
+ static int
+ spectrum_cs_config(struct pcmcia_device *link)
+@@ -201,10 +304,12 @@ spectrum_cs_config(struct pcmcia_device 
+ 	int ret;
+ 	void __iomem *mem;
+ 
++#if (LINUX_VERSION_CODE >= KERNEL_VERSION(2,6,37))
+ 	link->config_flags |= CONF_AUTO_SET_VPP | CONF_AUTO_CHECK_VCC |
+ 		CONF_AUTO_SET_IO | CONF_ENABLE_IRQ;
+ 	if (ignore_cis_vcc)
+ 		link->config_flags &= ~CONF_AUTO_CHECK_VCC;
++#endif
+ 	ret = pcmcia_loop_config(link, spectrum_cs_config_check, NULL);
+ 	if (ret) {
+ 		if (!ignore_cis_vcc)
+@@ -214,15 +319,23 @@ spectrum_cs_config(struct pcmcia_device 
  		goto failed;
  	}
  
@@ -908,7 +1352,7 @@
  	if (!mem)
  		goto failed;
  
-@@ -345,8 +384,16 @@ spectrum_cs_config(struct pcmcia_device 
+@@ -244,8 +357,16 @@ spectrum_cs_config(struct pcmcia_device 
  	}
  
  	/* Register an interface with the stack */
@@ -925,9 +1369,23 @@
  		printk(KERN_ERR PFX "orinoco_if_add() failed\n");
  		goto failed;
  	}
+@@ -311,7 +432,13 @@ MODULE_DEVICE_TABLE(pcmcia, spectrum_cs_
+ 
+ static struct pcmcia_driver orinoco_driver = {
+ 	.owner		= THIS_MODULE,
++#if (LINUX_VERSION_CODE >= KERNEL_VERSION(2,6,37))
+ 	.name		= DRIVER_NAME,
++#else
++	.drv		= {
++		.name	= DRIVER_NAME,
++	},
++#endif
+ 	.probe		= spectrum_cs_probe,
+ 	.remove		= spectrum_cs_detach,
+ 	.suspend	= spectrum_cs_suspend,
 --- a/drivers/ssb/main.c
 +++ b/drivers/ssb/main.c
-@@ -490,7 +490,11 @@ static int ssb_devices_register(struct s
+@@ -489,7 +489,11 @@ static int ssb_devices_register(struct s
  			break;
  		case SSB_BUSTYPE_PCMCIA:
  #ifdef CONFIG_SSB_PCMCIAHOST
-- 
1.7.0.4

