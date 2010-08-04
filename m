Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ey0-f174.google.com ([209.85.215.174]:42940 "EHLO
	mail-ey0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758041Ab0HDOS4 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 4 Aug 2010 10:18:56 -0400
Received: by mail-ey0-f174.google.com with SMTP id 25so1978184eya.19
        for <linux-wireless@vger.kernel.org>; Wed, 04 Aug 2010 07:18:56 -0700 (PDT)
From: Kshitij Kulshreshtha <kkhere.geo@gmail.com>
To: "Luis R. Rodriguez" <lrodriguez@atheros.com>,
	Hauke Mehrtens <hauke@hauke-m.de>
Cc: linux-wireless@vger.kernel.org,
	Kshitij Kulshreshtha <kkhere.geo@gmail.com>
Subject: [PATCH] compat-wireless: more PCMCIA backporting
Date: Wed,  4 Aug 2010 16:18:36 +0200
Message-Id: <1280931516-29665-3-git-send-email-kkhere.geo@gmail.com>
In-Reply-To: <1280931516-29665-1-git-send-email-kkhere.geo@gmail.com>
References: <1280931516-29665-1-git-send-email-kkhere.geo@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

to fix build, these changes are leftovers from commit

    commit dedb69815e9608360249e62a794e3dea6a867ab8
    Author: Luis R. Rodriguez <lrodriguez@atheros.com>
    Date:   Tue Aug 3 13:30:01 2010 -0700

        compat-wireless: backport and fix new PCMCIA changes


Signed-off-by: Kshitij Kulshreshtha <kkhere.geo@gmail.com>
---
 patches/24-pcmcia.patch |  131 +++++++++++++++++++++++++++++++++++++++++++++--
 1 files changed, 126 insertions(+), 5 deletions(-)

diff --git a/patches/24-pcmcia.patch b/patches/24-pcmcia.patch
index 9fb0e77..b1d65bf 100644
--- a/patches/24-pcmcia.patch
+++ b/patches/24-pcmcia.patch
@@ -275,7 +275,56 @@
  	/* General socket configuration defaults can go here.  In this
  	 * client, we assume very little, and rely on the CIS for
  	 * almost everything.  In most clients, many details (i.e.,
-@@ -248,7 +258,11 @@ orinoco_cs_config(struct pcmcia_device *
+@@ -191,23 +201,48 @@ static int orinoco_cs_config_check(struc
+ 	p_dev->conf.Attributes |= CONF_ENABLE_IRQ;
+ 
+ 	/* IO window settings */
++#if LINUX_VERSION_CODE >= KERNEL_VERSION(2,6,36)
+ 	p_dev->resource[0]->end = p_dev->resource[1]->end = 0;
++#else
++	p_dev->io.NumPorts1 = p_dev->io.NumPorts2 = 0;
++#endif
+ 	if ((cfg->io.nwin > 0) || (dflt->io.nwin > 0)) {
+ 		cistpl_io_t *io = (cfg->io.nwin) ? &cfg->io : &dflt->io;
++#if LINUX_VERSION_CODE >= KERNEL_VERSION(2,6,36)
+ 		p_dev->io_lines = io->flags & CISTPL_IO_LINES_MASK;
+ 		p_dev->resource[0]->flags &= ~IO_DATA_PATH_WIDTH;
+ 		p_dev->resource[0]->flags |=
+ 			pcmcia_io_cfg_data_width(io->flags);
+ 		p_dev->resource[0]->start = io->win[0].base;
+ 		p_dev->resource[0]->end = io->win[0].len;
++#else
++		p_dev->io.Attributes1 = IO_DATA_PATH_WIDTH_AUTO;
++		if (!(io->flags & CISTPL_IO_8BIT))
++			p_dev->io.Attributes1 = IO_DATA_PATH_WIDTH_16;
++		if (!(io->flags & CISTPL_IO_16BIT))
++			p_dev->io.Attributes1 = IO_DATA_PATH_WIDTH_8;
++		p_dev->io.IOAddrLines = io->flags & CISTPL_IO_LINES_MASK;
++		p_dev->io.BasePort1 = io->win[0].base;
++		p_dev->io.NumPorts1 = io->win[0].len;
++#endif
+ 		if (io->nwin > 1) {
++#if LINUX_VERSION_CODE >= KERNEL_VERSION(2,6,36)
+ 			p_dev->resource[1]->flags = p_dev->resource[0]->flags;
+ 			p_dev->resource[1]->start = io->win[1].base;
+ 			p_dev->resource[1]->end = io->win[1].len;
++#else
++			p_dev->io.Attributes2 = p_dev->io.Attributes1;
++			p_dev->io.BasePort2 = io->win[1].base;
++			p_dev->io.NumPorts2 = io->win[1].len;
++#endif
+ 		}
+ 
+ 		/* This reserves IO space but doesn't actually enable it */
++#if LINUX_VERSION_CODE >= KERNEL_VERSION(2,6,36)
+ 		if (pcmcia_request_io(p_dev) != 0)
++#else
++		if (pcmcia_request_io(p_dev, &p_dev->io) != 0)
++#endif
+ 			goto next_entry;
+ 	}
+ 	return 0;
+@@ -248,15 +283,23 @@ orinoco_cs_config(struct pcmcia_device *
  		goto failed;
  	}
  
@@ -287,7 +336,19 @@
  	if (ret)
  		goto failed;
  
-@@ -278,8 +292,16 @@ orinoco_cs_config(struct pcmcia_device *
+ 	/* We initialize the hermes structure before completing PCMCIA
+ 	 * configuration just in case the interrupt handler gets
+ 	 * called. */
++#if LINUX_VERSION_CODE >= KERNEL_VERSION(2,6,36)
+ 	mem = ioport_map(link->resource[0]->start,
+ 			resource_size(link->resource[0]));
++#else
++	mem = ioport_map(link->io.BasePort1, link->io.NumPorts1);
++#endif
+ 	if (!mem)
+ 		goto failed;
+ 
+@@ -278,8 +321,16 @@ orinoco_cs_config(struct pcmcia_device *
  	}
  
  	/* Register an interface with the stack */
@@ -319,7 +380,56 @@
  	/* General socket configuration defaults can go here.  In this
  	 * client, we assume very little, and rely on the CIS for
  	 * almost everything.  In most clients, many details (i.e.,
-@@ -310,7 +316,11 @@ spectrum_cs_config(struct pcmcia_device 
+@@ -253,23 +259,48 @@ static int spectrum_cs_config_check(stru
+ 	p_dev->conf.Attributes |= CONF_ENABLE_IRQ;
+ 
+ 	/* IO window settings */
++#if LINUX_VERSION_CODE >= KERNEL_VERSION(2,6,36)
+ 	p_dev->resource[0]->end = p_dev->resource[1]->end = 0;
++#else
++	p_dev->io.NumPorts1 = p_dev->io.NumPorts2 = 0;
++#endif
+ 	if ((cfg->io.nwin > 0) || (dflt->io.nwin > 0)) {
+ 		cistpl_io_t *io = (cfg->io.nwin) ? &cfg->io : &dflt->io;
++#if LINUX_VERSION_CODE >= KERNEL_VERSION(2,6,36)
+ 		p_dev->io_lines = io->flags & CISTPL_IO_LINES_MASK;
+ 		p_dev->resource[0]->flags &= ~IO_DATA_PATH_WIDTH;
+ 		p_dev->resource[0]->flags |=
+ 			pcmcia_io_cfg_data_width(io->flags);
+ 		p_dev->resource[0]->start = io->win[0].base;
+ 		p_dev->resource[0]->end = io->win[0].len;
++#else
++		p_dev->io.Attributes1 = IO_DATA_PATH_WIDTH_AUTO;
++		if (!(io->flags & CISTPL_IO_8BIT))
++			p_dev->io.Attributes1 = IO_DATA_PATH_WIDTH_16;
++		if (!(io->flags & CISTPL_IO_16BIT))
++			p_dev->io.Attributes1 = IO_DATA_PATH_WIDTH_8;
++		p_dev->io.IOAddrLines = io->flags & CISTPL_IO_LINES_MASK;
++		p_dev->io.BasePort1 = io->win[0].base;
++		p_dev->io.NumPorts1 = io->win[0].len;
++#endif
+ 		if (io->nwin > 1) {
++#if LINUX_VERSION_CODE >= KERNEL_VERSION(2,6,36)
+ 			p_dev->resource[1]->flags = p_dev->resource[0]->flags;
+ 			p_dev->resource[1]->start = io->win[1].base;
+ 			p_dev->resource[1]->end = io->win[1].len;
++#else
++			p_dev->io.Attributes2 = p_dev->io.Attributes1;
++			p_dev->io.BasePort2 = io->win[1].base;
++			p_dev->io.NumPorts2 = io->win[1].len;
++#endif
+ 		}
+ 
+ 		/* This reserves IO space but doesn't actually enable it */
++#if LINUX_VERSION_CODE >= KERNEL_VERSION(2,6,36)
+ 		if (pcmcia_request_io(p_dev) != 0)
++#else
++		if (pcmcia_request_io(p_dev, &p_dev->io) != 0)
++#endif
+ 			goto next_entry;
+ 	}
+ 	return 0;
+@@ -310,15 +341,23 @@ spectrum_cs_config(struct pcmcia_device
  		goto failed;
  	}
  
@@ -331,7 +441,19 @@
  	if (ret)
  		goto failed;
  
-@@ -345,8 +355,17 @@ spectrum_cs_config(struct pcmcia_device 
+ 	/* We initialize the hermes structure before completing PCMCIA
+ 	 * configuration just in case the interrupt handler gets
+ 	 * called. */
++#if LINUX_VERSION_CODE >= KERNEL_VERSION(2,6,36)
+ 	mem = ioport_map(link->resource[0]->start,
+ 			resource_size(link->resource[0]));
++#else
++	mem = ioport_map(link->io.BasePort1, link->io.NumPorts1);
++#endif
+ 	if (!mem)
+ 		goto failed;
+ 
+@@ -345,8 +384,16 @@ spectrum_cs_config(struct pcmcia_device
  	}
  
  	/* Register an interface with the stack */
@@ -343,7 +465,6 @@
 +			   link->irq, NULL) != 0) {
 +#else
 +	if (orinoco_if_add(priv, link->io.BasePort1,
-+			   link->irq, NULL) != 0) {
 +			   link->irq.AssignedIRQ, NULL) != 0) {
 +#endif
  		printk(KERN_ERR PFX "orinoco_if_add() failed\n");
-- 
1.7.1

