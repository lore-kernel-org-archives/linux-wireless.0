Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from server19320154104.serverpool.info ([193.201.54.104]:59008 "EHLO
	hauke-m.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757327Ab0LIWXN (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 9 Dec 2010 17:23:13 -0500
From: Hauke Mehrtens <hauke@hauke-m.de>
To: lrodriguez@atheros.com
Cc: linux-wireless@vger.kernel.org, mcgrof@infradead.org,
	Hauke Mehrtens <hauke@hauke-m.de>
Subject: [PATCH] compat-wireless: make patch apply again
Date: Thu,  9 Dec 2010 23:23:05 +0100
Message-Id: <1291933385-18217-1-git-send-email-hauke@hauke-m.de>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


Signed-off-by: Hauke Mehrtens <hauke@hauke-m.de>
---
 patches/24-pcmcia.patch |   50 ++++++++++++++++++++++++----------------------
 1 files changed, 26 insertions(+), 24 deletions(-)

diff --git a/patches/24-pcmcia.patch b/patches/24-pcmcia.patch
index 9614d78..775c969 100644
--- a/patches/24-pcmcia.patch
+++ b/patches/24-pcmcia.patch
@@ -1134,21 +1134,10 @@
  	ret = pcmcia_loop_config(link, orinoco_cs_config_check, NULL);
  	if (ret) {
  		if (!ignore_cis_vcc)
-@@ -151,15 +260,23 @@ orinoco_cs_config(struct pcmcia_device *
+@@ -151,8 +260,12 @@ orinoco_cs_config(struct pcmcia_device *
  		goto failed;
  	}
  
-+#if (LINUX_VERSION_CODE >= KERNEL_VERSION(2,6,35))
- 	ret = pcmcia_request_irq(link, orinoco_interrupt);
-+#else
-+	ret = pcmcia_request_irq(link, &link->irq);
-+#endif
- 	if (ret)
- 		goto failed;
- 
- 	/* We initialize the hermes structure before completing PCMCIA
- 	 * configuration just in case the interrupt handler gets
- 	 * called. */
 +#if LINUX_VERSION_CODE >= KERNEL_VERSION(2,6,36)
  	mem = ioport_map(link->resource[0]->start,
  			resource_size(link->resource[0]));
@@ -1158,6 +1147,18 @@
  	if (!mem)
  		goto failed;
  
+@@ -161,7 +274,11 @@ orinoco_cs_config(struct pcmcia_device *
+ 	 * called. */
+ 	hermes_struct_init(hw, mem, HERMES_16BIT_REGSPACING);
+ 
++#if (LINUX_VERSION_CODE >= KERNEL_VERSION(2,6,35))
+ 	ret = pcmcia_request_irq(link, orinoco_interrupt);
++#else
++	ret = pcmcia_request_irq(link, &link->irq);
++#endif
+ 	if (ret)
+ 		goto failed;
+ 
 @@ -176,8 +293,16 @@ orinoco_cs_config(struct pcmcia_device *
  	}
  
@@ -1328,21 +1329,10 @@
  	ret = pcmcia_loop_config(link, spectrum_cs_config_check, NULL);
  	if (ret) {
  		if (!ignore_cis_vcc)
-@@ -214,15 +319,23 @@ spectrum_cs_config(struct pcmcia_device
+@@ -214,8 +319,12 @@ spectrum_cs_config(struct pcmcia_device
  		goto failed;
  	}
  
-+#if (LINUX_VERSION_CODE >= KERNEL_VERSION(2,6,35))
- 	ret = pcmcia_request_irq(link, orinoco_interrupt);
-+#else
-+	ret = pcmcia_request_irq(link, &link->irq);
-+#endif
- 	if (ret)
- 		goto failed;
- 
- 	/* We initialize the hermes structure before completing PCMCIA
- 	 * configuration just in case the interrupt handler gets
- 	 * called. */
 +#if LINUX_VERSION_CODE >= KERNEL_VERSION(2,6,36)
  	mem = ioport_map(link->resource[0]->start,
  			resource_size(link->resource[0]));
@@ -1352,6 +1342,18 @@
  	if (!mem)
  		goto failed;
  
+@@ -225,7 +334,11 @@ spectrum_cs_config(struct pcmcia_device
+ 	hermes_struct_init(hw, mem, HERMES_16BIT_REGSPACING);
+ 	hw->eeprom_pda = true;
+ 
++#if (LINUX_VERSION_CODE >= KERNEL_VERSION(2,6,35))
+ 	ret = pcmcia_request_irq(link, orinoco_interrupt);
++#else
++	ret = pcmcia_request_irq(link, &link->irq);
++#endif
+ 	if (ret)
+ 		goto failed;
+ 
 @@ -244,8 +357,16 @@ spectrum_cs_config(struct pcmcia_device
  	}
  
-- 
1.7.1

