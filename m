Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from lo.gmane.org ([80.91.229.12]:34886 "EHLO lo.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752485AbZKFNFA (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 6 Nov 2009 08:05:00 -0500
Received: from list by lo.gmane.org with local (Exim 4.50)
	id 1N6OUz-00085W-6W
	for linux-wireless@vger.kernel.org; Fri, 06 Nov 2009 14:05:05 +0100
Received: from host204-255-dynamic.1-87-r.retail.telecomitalia.it ([87.1.255.204])
        by main.gmane.org with esmtp (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-wireless@vger.kernel.org>; Fri, 06 Nov 2009 14:05:05 +0100
Received: from carlo_parata by host204-255-dynamic.1-87-r.retail.telecomitalia.it with local (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-wireless@vger.kernel.org>; Fri, 06 Nov 2009 14:05:05 +0100
To: linux-wireless@vger.kernel.org
From: Carlo Parata <carlo_parata@hotmail.com>
Subject: [PATCH] Wifi led does not work on Acer Aspire One D250 (ath5k driver)
Date: Fri, 6 Nov 2009 13:00:02 +0000 (UTC)
Message-ID: <loom.20091106T135746-452@post.gmane.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

With this patch, a Acer Aspire One D250 can turn on the wifi led. The array of
compatible devices in ath5k driver now includes the hardware present in this
computer, as well as the led pin and polarity.

--- ../led.c	2009-11-06 06:16:39.000000000 +0100
+++ ./drivers/net/wireless/ath/ath5k/led.c	2009-11-06 12:37:44.000000000 +0100
@@ -73,6 +73,8 @@
 	{ ATH_SDEVICE(PCI_VENDOR_ID_HP, 0x0137b), ATH_LED(3, 1) },
 	/* IBM-specific AR5212 (all others) */
 	{ PCI_VDEVICE(ATHEROS, PCI_DEVICE_ID_ATHEROS_AR5212_IBM), ATH_LED(0, 0) },
+        /* Acer Aspire One D250 AR5007EG */
+	{ PCI_VDEVICE(ATHEROS, 0x001c), ATH_LED(3, 1) },
 	{ }
 };


