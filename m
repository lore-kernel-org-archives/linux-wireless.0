Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from server19320154104.serverpool.info ([193.201.54.104]:52025 "EHLO
	hauke-m.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1762657Ab0HGNfA (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Sat, 7 Aug 2010 09:35:00 -0400
From: Hauke Mehrtens <hauke@hauke-m.de>
To: lrodriguez@atheros.com
Cc: linux-wireless@vger.kernel.org, mcgrof@infradead.org,
	Hauke Mehrtens <hauke@hauke-m.de>
Subject: [PATCH 1/2] compat-wireless: backport pcmcia api changes
Date: Sat,  7 Aug 2010 15:34:43 +0200
Message-Id: <1281188084-7232-1-git-send-email-hauke@hauke-m.de>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Signed-off-by: Hauke Mehrtens <hauke@hauke-m.de>
---
 patches/24-pcmcia.patch |  483 +++++++++++++++++++++++++++++++++++++++++++++--
 1 files changed, 469 insertions(+), 14 deletions(-)

diff --git a/patches/24-pcmcia.patch b/patches/24-pcmcia.patch
index b1d65bf..5beda46 100644
--- a/patches/24-pcmcia.patch
+++ b/patches/24-pcmcia.patch
@@ -1,6 +1,115 @@
 --- a/drivers/bluetooth/bluecard_cs.c
 +++ b/drivers/bluetooth/bluecard_cs.c
-@@ -865,6 +865,12 @@ static int bluecard_probe(struct pcmcia_
+@@ -159,7 +159,12 @@ static void bluecard_detach(struct pcmci
+ static void bluecard_activity_led_timeout(u_long arg)
+ {
+ 	bluecard_info_t *info = (bluecard_info_t *)arg;
++#if (LINUX_VERSION_CODE >= KERNEL_VERSION(2,6,36))
+ 	unsigned int iobase = info->p_dev->resource[0]->start;
++#else
++	unsigned int iobase = info->p_dev->io.BasePort1;
++#endif
++
+ 
+ 	if (!test_bit(CARD_HAS_PCCARD_ID, &(info->hw_state)))
+ 		return;
+@@ -176,7 +181,11 @@ static void bluecard_activity_led_timeou
+ 
+ static void bluecard_enable_activity_led(bluecard_info_t *info)
+ {
++#if (LINUX_VERSION_CODE >= KERNEL_VERSION(2,6,36))
+ 	unsigned int iobase = info->p_dev->resource[0]->start;
++#else
++	unsigned int iobase = info->p_dev->io.BasePort1;
++#endif
+ 
+ 	if (!test_bit(CARD_HAS_PCCARD_ID, &(info->hw_state)))
+ 		return;
+@@ -232,7 +241,11 @@ static void bluecard_write_wakeup(blueca
+ 	}
+ 
+ 	do {
++#if (LINUX_VERSION_CODE >= KERNEL_VERSION(2,6,36))
+ 		register unsigned int iobase = info->p_dev->resource[0]->start;
++#else
++		register unsigned int iobase = info->p_dev->io.BasePort1;
++#endif
+ 		register unsigned int offset;
+ 		register unsigned char command;
+ 		register unsigned long ready_bit;
+@@ -379,7 +392,11 @@ static void bluecard_receive(bluecard_in
+ 		return;
+ 	}
+ 
++#if (LINUX_VERSION_CODE >= KERNEL_VERSION(2,6,36))
+ 	iobase = info->p_dev->resource[0]->start;
++#else
++	iobase = info->p_dev->io.BasePort1;
++#endif
+ 
+ 	if (test_bit(XMIT_SENDING_READY, &(info->tx_state)))
+ 		bluecard_enable_activity_led(info);
+@@ -508,7 +525,11 @@ static irqreturn_t bluecard_interrupt(in
+ 	if (!test_bit(CARD_READY, &(info->hw_state)))
+ 		return IRQ_HANDLED;
+ 
++#if (LINUX_VERSION_CODE >= KERNEL_VERSION(2,6,36))
+ 	iobase = info->p_dev->resource[0]->start;
++#else
++	iobase = info->p_dev->io.BasePort1;
++#endif
+ 
+ 	spin_lock(&(info->lock));
+ 
+@@ -622,7 +643,11 @@ static int bluecard_hci_flush(struct hci
+ static int bluecard_hci_open(struct hci_dev *hdev)
+ {
+ 	bluecard_info_t *info = (bluecard_info_t *)(hdev->driver_data);
++#if (LINUX_VERSION_CODE >= KERNEL_VERSION(2,6,36))
+ 	unsigned int iobase = info->p_dev->resource[0]->start;
++#else
++	unsigned int iobase = info->p_dev->io.BasePort1;
++#endif
+ 
+ 	if (test_bit(CARD_HAS_PCCARD_ID, &(info->hw_state)))
+ 		bluecard_hci_set_baud_rate(hdev, DEFAULT_BAUD_RATE);
+@@ -642,7 +667,11 @@ static int bluecard_hci_open(struct hci_
+ static int bluecard_hci_close(struct hci_dev *hdev)
+ {
+ 	bluecard_info_t *info = (bluecard_info_t *)(hdev->driver_data);
++#if (LINUX_VERSION_CODE >= KERNEL_VERSION(2,6,36))
+ 	unsigned int iobase = info->p_dev->resource[0]->start;
++#else
++	unsigned int iobase = info->p_dev->io.BasePort1;
++#endif
+ 
+ 	if (!test_and_clear_bit(HCI_RUNNING, &(hdev->flags)))
+ 		return 0;
+@@ -709,7 +738,11 @@ static int bluecard_hci_ioctl(struct hci
+ 
+ static int bluecard_open(bluecard_info_t *info)
+ {
++#if (LINUX_VERSION_CODE >= KERNEL_VERSION(2,6,36))
+ 	unsigned int iobase = info->p_dev->resource[0]->start;
++#else
++	unsigned int iobase = info->p_dev->io.BasePort1;
++#endif
+ 	struct hci_dev *hdev;
+ 	unsigned char id;
+ 
+@@ -828,7 +861,11 @@ static int bluecard_open(bluecard_info_t
+ 
+ static int bluecard_close(bluecard_info_t *info)
+ {
++#if (LINUX_VERSION_CODE >= KERNEL_VERSION(2,6,36))
+ 	unsigned int iobase = info->p_dev->resource[0]->start;
++#else
++	unsigned int iobase = info->p_dev->io.BasePort1;
++#endif
+ 	struct hci_dev *hdev = info->hdev;
+ 
+ 	if (!hdev)
+@@ -865,6 +902,12 @@ static int bluecard_probe(struct pcmcia_
  	info->p_dev = link;
  	link->priv = info;
  
@@ -13,7 +122,32 @@
  	link->conf.Attributes = CONF_ENABLE_IRQ;
  	link->conf.IntType = INT_MEMORY_AND_IO;
  
-@@ -902,9 +908,15 @@ static int bluecard_config(struct pcmcia
+@@ -888,13 +931,24 @@ static int bluecard_config(struct pcmcia
+ 
+ 	link->conf.ConfigIndex = 0x20;
+ 
++#if (LINUX_VERSION_CODE >= KERNEL_VERSION(2,6,36))
+ 	link->resource[0]->flags |= IO_DATA_PATH_WIDTH_8;
+ 	link->resource[0]->end = 64;
+ 	link->io_lines = 6;
++#else
++	link->io.Attributes1 = IO_DATA_PATH_WIDTH_8;
++	link->io.NumPorts1 = 64;
++	link->io.IOAddrLines = 6;;
++#endif
+ 
+ 	for (n = 0; n < 0x400; n += 0x40) {
++#if (LINUX_VERSION_CODE >= KERNEL_VERSION(2,6,36))
+ 		link->resource[0]->start = n ^ 0x300;
+ 		i = pcmcia_request_io(link);
++#else
++		link->io.BasePort1 = n ^ 0x300;
++		i = pcmcia_request_io(link, &link->io);
++#endif
+ 		if (i == 0)
+ 			break;
+ 	}
+@@ -902,9 +956,15 @@ static int bluecard_config(struct pcmcia
  	if (i != 0)
  		goto failed;
  
@@ -31,20 +165,115 @@
  	if (i != 0)
 --- a/drivers/bluetooth/bt3c_cs.c
 +++ b/drivers/bluetooth/bt3c_cs.c
-@@ -660,6 +660,12 @@ static int bt3c_probe(struct pcmcia_devi
+@@ -188,7 +188,11 @@ static void bt3c_write_wakeup(bt3c_info_
+ 		return;
+ 
+ 	do {
++#if (LINUX_VERSION_CODE >= KERNEL_VERSION(2,6,36))
+ 		register unsigned int iobase = info->p_dev->resource[0]->start;
++#else
++		register unsigned int iobase = info->p_dev->io.BasePort1;
++#endif
+ 		register struct sk_buff *skb;
+ 		register int len;
+ 
+@@ -226,7 +230,11 @@ static void bt3c_receive(bt3c_info_t *in
+ 		return;
+ 	}
+ 
++#if (LINUX_VERSION_CODE >= KERNEL_VERSION(2,6,36))
+ 	iobase = info->p_dev->resource[0]->start;
++#else
++	iobase = info->p_dev->io.BasePort1;
++#endif
+ 
+ 	avail = bt3c_read(iobase, 0x7006);
+ 	//printk("bt3c_cs: receiving %d bytes\n", avail);
+@@ -347,7 +355,11 @@ static irqreturn_t bt3c_interrupt(int ir
+ 		/* our irq handler is shared */
+ 		return IRQ_NONE;
+ 
++#if (LINUX_VERSION_CODE >= KERNEL_VERSION(2,6,36))
+ 	iobase = info->p_dev->resource[0]->start;
++#else
++	iobase = info->p_dev->io.BasePort1;
++#endif
+ 
+ 	spin_lock(&(info->lock));
+ 
+@@ -480,7 +492,11 @@ static int bt3c_load_firmware(bt3c_info_
+ 	unsigned int iobase, size, addr, fcs, tmp;
+ 	int i, err = 0;
+ 
++#if (LINUX_VERSION_CODE >= KERNEL_VERSION(2,6,36))
+ 	iobase = info->p_dev->resource[0]->start;
++#else
++	iobase = info->p_dev->io.BasePort1;
++#endif
+ 
+ 	/* Reset */
+ 	bt3c_io_write(iobase, 0x8040, 0x0404);
+@@ -657,8 +673,19 @@ static int bt3c_probe(struct pcmcia_devi
+ 	info->p_dev = link;
+ 	link->priv = info;
+ 
++#if (LINUX_VERSION_CODE >= KERNEL_VERSION(2,6,36))
  	link->resource[0]->flags |= IO_DATA_PATH_WIDTH_8;
  	link->resource[0]->end = 8;
- 
++#else
++	link->io.Attributes1 = IO_DATA_PATH_WIDTH_8;
++	link->io.NumPorts1= 8;
++#endif
++
 +#if (LINUX_VERSION_CODE < KERNEL_VERSION(2,6,35))
 +	link->irq.Attributes = IRQ_TYPE_DYNAMIC_SHARING;
 +
 +	link->irq.Handler = bt3c_interrupt;
 +#endif
-+
+ 
  	link->conf.Attributes = CONF_ENABLE_IRQ;
  	link->conf.IntType = INT_MEMORY_AND_IO;
+@@ -683,14 +710,23 @@ static int bt3c_check_config(struct pcmc
+ {
+ 	unsigned long try = (unsigned long) priv_data;
  
-@@ -738,9 +744,15 @@ static int bt3c_config(struct pcmcia_dev
++#if (LINUX_VERSION_CODE >= KERNEL_VERSION(2,6,36))
+ 	p_dev->io_lines = (try == 0) ? 16 : cf->io.flags & CISTPL_IO_LINES_MASK;
++#endif
+ 
+ 	if (cf->vpp1.present & (1 << CISTPL_POWER_VNOM))
+ 		p_dev->conf.Vpp = cf->vpp1.param[CISTPL_POWER_VNOM] / 10000;
+ 	if ((cf->io.nwin > 0) && (cf->io.win[0].len == 8) &&
+ 	    (cf->io.win[0].base != 0)) {
++#if (LINUX_VERSION_CODE >= KERNEL_VERSION(2,6,36))
+ 		p_dev->resource[0]->start = cf->io.win[0].base;
+ 		if (!pcmcia_request_io(p_dev))
++#else
++		p_dev->io.BasePort1 = cf->io.win[0].base;
++		p_dev->io.IOAddrLines = (try == 0) ? 16 :
++			cf->io.flags & CISTPL_IO_LINES_MASK;
++		if (!pcmcia_request_io(p_dev, &p_dev->io))
++#endif
+ 			return 0;
+ 	}
+ 	return -ENODEV;
+@@ -707,9 +743,15 @@ static int bt3c_check_config_notpicky(st
+ 
+ 	if ((cf->io.nwin > 0) && ((cf->io.flags & CISTPL_IO_LINES_MASK) <= 3)) {
+ 		for (j = 0; j < 5; j++) {
++#if (LINUX_VERSION_CODE >= KERNEL_VERSION(2,6,36))
+ 			p_dev->resource[0]->start = base[j];
+ 			p_dev->io_lines = base[j] ? 16 : 3;
+ 			if (!pcmcia_request_io(p_dev))
++#else
++			p_dev->io.BasePort1 = base[j];
++			p_dev->io.IOAddrLines = base[j] ? 16 : 3;
++			if (!pcmcia_request_io(p_dev, &p_dev->io))
++#endif
+ 				return 0;
+ 		}
+ 	}
+@@ -738,9 +780,15 @@ static int bt3c_config(struct pcmcia_dev
  	goto failed;
  
  found_port:
@@ -62,20 +291,139 @@
  	if (i != 0)
 --- a/drivers/bluetooth/btuart_cs.c
 +++ b/drivers/bluetooth/btuart_cs.c
-@@ -589,6 +589,12 @@ static int btuart_probe(struct pcmcia_de
+@@ -142,7 +142,11 @@ static void btuart_write_wakeup(btuart_i
+ 	}
+ 
+ 	do {
++#if (LINUX_VERSION_CODE >= KERNEL_VERSION(2,6,36))
+ 		register unsigned int iobase = info->p_dev->resource[0]->start;
++#else
++		register unsigned int iobase = info->p_dev->io.BasePort1;
++#endif
+ 		register struct sk_buff *skb;
+ 		register int len;
+ 
+@@ -183,7 +187,11 @@ static void btuart_receive(btuart_info_t
+ 		return;
+ 	}
+ 
++#if (LINUX_VERSION_CODE >= KERNEL_VERSION(2,6,36))
+ 	iobase = info->p_dev->resource[0]->start;
++#else
++	iobase = info->p_dev->io.BasePort1;
++#endif
+ 
+ 	do {
+ 		info->hdev->stat.byte_rx++;
+@@ -297,7 +305,11 @@ static irqreturn_t btuart_interrupt(int 
+ 		/* our irq handler is shared */
+ 		return IRQ_NONE;
+ 
++#if (LINUX_VERSION_CODE >= KERNEL_VERSION(2,6,36))
+ 	iobase = info->p_dev->resource[0]->start;
++#else
++	iobase = info->p_dev->io.BasePort1;
++#endif
+ 
+ 	spin_lock(&(info->lock));
+ 
+@@ -354,7 +366,11 @@ static void btuart_change_speed(btuart_i
+ 		return;
+ 	}
+ 
++#if (LINUX_VERSION_CODE >= KERNEL_VERSION(2,6,36))
+ 	iobase = info->p_dev->resource[0]->start;
++#else
++	iobase = info->p_dev->io.BasePort1;
++#endif
+ 
+ 	spin_lock_irqsave(&(info->lock), flags);
+ 
+@@ -478,7 +494,11 @@ static int btuart_hci_ioctl(struct hci_d
+ static int btuart_open(btuart_info_t *info)
+ {
+ 	unsigned long flags;
++#if (LINUX_VERSION_CODE >= KERNEL_VERSION(2,6,36))
+ 	unsigned int iobase = info->p_dev->resource[0]->start;
++#else
++	unsigned int iobase = info->p_dev->io.BasePort1;
++#endif
+ 	struct hci_dev *hdev;
+ 
+ 	spin_lock_init(&(info->lock));
+@@ -548,7 +568,11 @@ static int btuart_open(btuart_info_t *in
+ static int btuart_close(btuart_info_t *info)
+ {
+ 	unsigned long flags;
++#if (LINUX_VERSION_CODE >= KERNEL_VERSION(2,6,36))
+ 	unsigned int iobase = info->p_dev->resource[0]->start;
++#else
++	unsigned int iobase = info->p_dev->io.BasePort1;
++#endif
+ 	struct hci_dev *hdev = info->hdev;
+ 
+ 	if (!hdev)
+@@ -586,8 +610,19 @@ static int btuart_probe(struct pcmcia_de
+ 	info->p_dev = link;
+ 	link->priv = info;
+ 
++#if (LINUX_VERSION_CODE >= KERNEL_VERSION(2,6,36))
  	link->resource[0]->flags |= IO_DATA_PATH_WIDTH_8;
  	link->resource[0]->end = 8;
- 
++#else
++	link->io.Attributes1 = IO_DATA_PATH_WIDTH_8;
++	link->io.NumPorts1= 8;
++#endif
++
 +#if (LINUX_VERSION_CODE < KERNEL_VERSION(2,6,35))
 +	link->irq.Attributes = IRQ_TYPE_DYNAMIC_SHARING;
 +
 +	link->irq.Handler = btuart_interrupt;
 +#endif
-+
+ 
  	link->conf.Attributes = CONF_ENABLE_IRQ;
  	link->conf.IntType = INT_MEMORY_AND_IO;
+@@ -612,14 +647,23 @@ static int btuart_check_config(struct pc
+ {
+ 	int *try = priv_data;
  
-@@ -667,9 +673,15 @@ static int btuart_config(struct pcmcia_d
++#if (LINUX_VERSION_CODE >= KERNEL_VERSION(2,6,36))
+ 	p_dev->io_lines = (try == 0) ? 16 : cf->io.flags & CISTPL_IO_LINES_MASK;
++#endif
+ 
+ 	if (cf->vpp1.present & (1 << CISTPL_POWER_VNOM))
+ 		p_dev->conf.Vpp = cf->vpp1.param[CISTPL_POWER_VNOM] / 10000;
+ 	if ((cf->io.nwin > 0) && (cf->io.win[0].len == 8) &&
+ 	    (cf->io.win[0].base != 0)) {
++#if (LINUX_VERSION_CODE >= KERNEL_VERSION(2,6,36))
+ 		p_dev->resource[0]->start = cf->io.win[0].base;
+ 		if (!pcmcia_request_io(p_dev))
++#else
++		p_dev->io.BasePort1 = cf->io.win[0].base;
++		p_dev->io.IOAddrLines = (*try == 0) ? 16 :
++			cf->io.flags & CISTPL_IO_LINES_MASK;
++		if (!pcmcia_request_io(p_dev, &p_dev->io))
++#endif
+ 			return 0;
+ 	}
+ 	return -ENODEV;
+@@ -636,9 +680,15 @@ static int btuart_check_config_notpicky(
+ 
+ 	if ((cf->io.nwin > 0) && ((cf->io.flags & CISTPL_IO_LINES_MASK) <= 3)) {
+ 		for (j = 0; j < 5; j++) {
++#if (LINUX_VERSION_CODE >= KERNEL_VERSION(2,6,36))
+ 			p_dev->resource[0]->start = base[j];
+ 			p_dev->io_lines = base[j] ? 16 : 3;
+ 			if (!pcmcia_request_io(p_dev))
++#else
++			p_dev->io.BasePort1 = base[j];
++			p_dev->io.IOAddrLines = base[j] ? 16 : 3;
++			if (!pcmcia_request_io(p_dev, &p_dev->io))
++#endif
+ 				return 0;
+ 		}
+ 	}
+@@ -667,9 +717,15 @@ static int btuart_config(struct pcmcia_d
  	goto failed;
  
  found_port:
@@ -93,10 +441,91 @@
  	if (i != 0)
 --- a/drivers/bluetooth/dtl1_cs.c
 +++ b/drivers/bluetooth/dtl1_cs.c
-@@ -574,6 +574,10 @@ static int dtl1_probe(struct pcmcia_devi
+@@ -149,7 +149,11 @@ static void dtl1_write_wakeup(dtl1_info_
+ 	}
+ 
+ 	do {
++#if (LINUX_VERSION_CODE >= KERNEL_VERSION(2,6,36))
+ 		register unsigned int iobase = info->p_dev->resource[0]->start;
++#else
++		register unsigned int iobase = info->p_dev->io.BasePort1;
++#endif
+ 		register struct sk_buff *skb;
+ 		register int len;
+ 
+@@ -214,7 +218,11 @@ static void dtl1_receive(dtl1_info_t *in
+ 		return;
+ 	}
+ 
++#if (LINUX_VERSION_CODE >= KERNEL_VERSION(2,6,36))
+ 	iobase = info->p_dev->resource[0]->start;
++#else
++	iobase = info->p_dev->io.BasePort1;
++#endif
+ 
+ 	do {
+ 		info->hdev->stat.byte_rx++;
+@@ -301,7 +309,11 @@ static irqreturn_t dtl1_interrupt(int ir
+ 		/* our irq handler is shared */
+ 		return IRQ_NONE;
+ 
++#if (LINUX_VERSION_CODE >= KERNEL_VERSION(2,6,36))
+ 	iobase = info->p_dev->resource[0]->start;
++#else
++	iobase = info->p_dev->io.BasePort1;
++#endif
+ 
+ 	spin_lock(&(info->lock));
+ 
+@@ -461,7 +473,11 @@ static int dtl1_hci_ioctl(struct hci_dev
+ static int dtl1_open(dtl1_info_t *info)
+ {
+ 	unsigned long flags;
++#if (LINUX_VERSION_CODE >= KERNEL_VERSION(2,6,36))
+ 	unsigned int iobase = info->p_dev->resource[0]->start;
++#else
++	unsigned int iobase = info->p_dev->io.BasePort1;
++#endif
+ 	struct hci_dev *hdev;
+ 
+ 	spin_lock_init(&(info->lock));
+@@ -508,8 +524,13 @@ static int dtl1_open(dtl1_info_t *info)
+ 	outb(UART_LCR_WLEN8, iobase + UART_LCR);	/* Reset DLAB */
+ 	outb((UART_MCR_DTR | UART_MCR_RTS | UART_MCR_OUT2), iobase + UART_MCR);
+ 
++#if (LINUX_VERSION_CODE >= KERNEL_VERSION(2,6,36))
+ 	info->ri_latch = inb(info->p_dev->resource[0]->start + UART_MSR)
+ 				& UART_MSR_RI;
++#else
++	info->ri_latch = inb(info->p_dev->io.BasePort1 + UART_MSR)
++				& UART_MSR_RI;
++#endif
+ 
+ 	/* Turn on interrupts */
+ 	outb(UART_IER_RLSI | UART_IER_RDI | UART_IER_THRI, iobase + UART_IER);
+@@ -534,7 +555,11 @@ static int dtl1_open(dtl1_info_t *info)
+ static int dtl1_close(dtl1_info_t *info)
+ {
+ 	unsigned long flags;
++#if (LINUX_VERSION_CODE >= KERNEL_VERSION(2,6,36))
+ 	unsigned int iobase = info->p_dev->resource[0]->start;
++#else
++	unsigned int iobase = info->p_dev->io.BasePort1;
++#endif
+ 	struct hci_dev *hdev = info->hdev;
+ 
+ 	if (!hdev)
+@@ -572,8 +597,17 @@ static int dtl1_probe(struct pcmcia_devi
+ 	info->p_dev = link;
+ 	link->priv = info;
  
++#if (LINUX_VERSION_CODE >= KERNEL_VERSION(2,6,36))
  	link->resource[0]->flags |= IO_DATA_PATH_WIDTH_8;
  	link->resource[0]->end = 8;
++#else
++	link->io.Attributes1 = IO_DATA_PATH_WIDTH_8;
++	link->io.NumPorts1= 8;
++#endif
 +#if (LINUX_VERSION_CODE < KERNEL_VERSION(2,6,35))
 +	link->irq.Attributes = IRQ_TYPE_DYNAMIC_SHARING;
 +	link->irq.Handler = dtl1_interrupt;
@@ -104,7 +533,33 @@
  
  	link->conf.Attributes = CONF_ENABLE_IRQ;
  	link->conf.IntType = INT_MEMORY_AND_IO;
-@@ -616,9 +620,15 @@ static int dtl1_config(struct pcmcia_dev
+@@ -600,10 +634,17 @@ static int dtl1_confcheck(struct pcmcia_
+ 	if ((cf->io.nwin != 1) || (cf->io.win[0].len <= 8))
+ 		return -ENODEV;
+ 
++#if (LINUX_VERSION_CODE >= KERNEL_VERSION(2,6,36))
+ 	p_dev->resource[0]->start = cf->io.win[0].base;
+ 	p_dev->resource[0]->end = cf->io.win[0].len;	/*yo */
+ 	p_dev->io_lines = cf->io.flags & CISTPL_IO_LINES_MASK;
+ 	return pcmcia_request_io(p_dev);
++#else
++	p_dev->io.BasePort1 = cf->io.win[0].base;
++	p_dev->io.NumPorts1 = cf->io.win[0].len;	/*yo */
++	p_dev->io.IOAddrLines = cf->io.flags & CISTPL_IO_LINES_MASK;
++	return pcmcia_request_io(p_dev, &p_dev->io);
++#endif
+ }
+ 
+ static int dtl1_config(struct pcmcia_device *link)
+@@ -612,13 +653,23 @@ static int dtl1_config(struct pcmcia_dev
+ 	int i;
+ 
+ 	/* Look for a generic full-sized window */
++#if (LINUX_VERSION_CODE >= KERNEL_VERSION(2,6,36))
+ 	link->resource[0]->end = 8;
++#else
++	link->io.NumPorts1 = 8;
++#endif
  	if (pcmcia_loop_config(link, dtl1_confcheck, NULL) < 0)
  		goto failed;
  
@@ -429,7 +884,7 @@
  			goto next_entry;
  	}
  	return 0;
-@@ -310,15 +341,23 @@ spectrum_cs_config(struct pcmcia_device
+@@ -310,15 +341,23 @@ spectrum_cs_config(struct pcmcia_device 
  		goto failed;
  	}
  
@@ -453,7 +908,7 @@
  	if (!mem)
  		goto failed;
  
-@@ -345,8 +384,16 @@ spectrum_cs_config(struct pcmcia_device
+@@ -345,8 +384,16 @@ spectrum_cs_config(struct pcmcia_device 
  	}
  
  	/* Register an interface with the stack */
-- 
1.7.0.4

