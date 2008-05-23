Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.gmx.net ([213.165.64.20]:34437 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1750830AbYEWXL5 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 23 May 2008 19:11:57 -0400
Message-ID: <48374F39.40904@gmx.de> (sfid-20080524_011202_926048_FDAD9BD1)
Date: Sat, 24 May 2008 01:11:53 +0200
From: Thomas Kunze <thommycheck@gmx.de>
MIME-Version: 1.0
To: linux-wireless@vger.kernel.org
CC: j@w1.fi
Subject: hostap oops
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi,

the hostap driver produces an oops at boot time for me. I use a prism2 compact flash card. 

Its seems that this is because the driver receives irqs before it is ready to do so. 

I found a patch that solve the problem, but it looks more like a hack.

Any suggestions how to solve this in a better way?

Regards,
Thomas
--

diff --git a/drivers/net/wireless/hostap/hostap_cs.c b/drivers/net/wireless/hostap/hostap_cs.c
index ed4317a..804f365 100644
--- a/drivers/net/wireless/hostap/hostap_cs.c
+++ b/drivers/net/wireless/hostap/hostap_cs.c
@@ -35,7 +35,7 @@ static int ignore_cis_vcc;
 module_param(ignore_cis_vcc, int, 0444);
 MODULE_PARM_DESC(ignore_cis_vcc, "Ignore broken CIS VCC entry");
 
-
+int activar=0;
 /* struct local_info::hw_priv */
 struct hostap_cs_priv {
 	dev_node_t node;
@@ -499,11 +499,13 @@ static int hostap_cs_probe(struct pcmcia_device *p_dev)
 
 	PDEBUG(DEBUG_HW, "%s: setting Vcc=33 (constant)\n", dev_info);
 	p_dev->conf.IntType = INT_MEMORY_AND_IO;
-
+	
+	activar=0;
 	ret = prism2_config(p_dev);
 	if (ret) {
 		PDEBUG(DEBUG_EXTRA, "prism2_config() failed\n");
 	}
+	activar=1;
 
 	return ret;
 }
diff --git a/drivers/net/wireless/hostap/hostap_hw.c b/drivers/net/wireless/hostap/hostap_hw.c
index cdf90c4..d79a2a5 100644
--- a/drivers/net/wireless/hostap/hostap_hw.c
+++ b/drivers/net/wireless/hostap/hostap_hw.c
@@ -54,6 +54,7 @@
 #include "hostap.h"
 #include "hostap_ap.h"
 
+extern int activar;
 
 /* #define final_version */
 
@@ -1497,6 +1498,8 @@ static int prism2_hw_config(struct net_device *dev, int initial)
 	if (local->hw_downloading)
 		return 1;
 
+	activar=1;
+
 	if (prism2_hw_init(dev, initial)) {
 		return local->no_pri ? 0 : 1;
 	}
@@ -2628,8 +2631,15 @@ static irqreturn_t prism2_interrupt(int irq, void *dev_id)
 	int events = 0;
 	u16 ev;
 
-	iface = netdev_priv(dev);
-	local = iface->local;
+
+	// Todos los parametros de entrada son correctos (no son nulos). De momento esta es la unica forma que conozco de detectar el problema.
+	if (!activar) {
+		printk("hostap_hw.c: INTERRUPT BEFORE DEVICE INIT!\n");
+		return IRQ_HANDLED;
+	}
+
+ 	iface = netdev_priv(dev);
+ 	local = iface->local;
 
 	prism2_io_debug_add(dev, PRISM2_IO_DEBUG_CMD_INTERRUPT, 0, 0);
 
diff --git a/drivers/net/wireless/hostap/hostap_pci.c b/drivers/net/wireless/hostap/hostap_pci.c
index 3a874fc..df58aa3 100644
--- a/drivers/net/wireless/hostap/hostap_pci.c
+++ b/drivers/net/wireless/hostap/hostap_pci.c
@@ -19,6 +19,7 @@
 
 #include "hostap_wlan.h"
 
+int activar=1;
 
 static char *dev_info = "hostap_pci";
 
diff --git a/drivers/net/wireless/hostap/hostap_plx.c b/drivers/net/wireless/hostap/hostap_plx.c
index cbf15d7..4475174 100644
--- a/drivers/net/wireless/hostap/hostap_plx.c
+++ b/drivers/net/wireless/hostap/hostap_plx.c
@@ -21,7 +21,7 @@
 #include <asm/io.h>
 
 #include "hostap_wlan.h"
-
+int activar=1;
 
 static char *dev_info = "hostap_plx";
 


