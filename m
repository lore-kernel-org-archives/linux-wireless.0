Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from salugit.unile.it ([193.204.77.149]:44841 "EHLO salug.it"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751582AbZLVBv4 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 21 Dec 2009 20:51:56 -0500
Received: from magooz.no-ip.org (unknown [151.95.194.34])
	by salug.it (Postfix) with ESMTP id C94861815D
	for <linux-wireless@vger.kernel.org>; Tue, 22 Dec 2009 02:20:51 +0100 (CET)
Date: Tue, 22 Dec 2009 02:21:35 +0100
From: Luca Verdesca <magooz@salug.it>
To: linux-wireless@vger.kernel.org
Subject: [PATCH] ath5k: adding LED support for AR5BXB63 cards
Message-ID: <20091222022135.2102c465@magooz.no-ip.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

With following patch, LED should now work with LiteOn AR5BXB63 mini
pci-e cards.

I hope I made no mistake.

Happy hacking!
Magooz


*** /usr/src/linux/drivers/net/wireless/ath/ath5k/led.c	2009-12-16 16:06:08.000000000 +0100
--- /home/magooz/led.c	2009-12-16 16:10:46.000000000 +0100
***************
*** 53,58 ****
--- 53,61 ----
  
  /* Devices we match on for LED config info (typically laptops) */
  static const struct pci_device_id ath5k_led_devices[] = {
+ 	/* LiteOn AR5BXB63 (magooz@salug.it) */
+ 	{ PCI_SDEVICE(ATHEROS, 0x3067), ATH_LED(3, 0) },
  	/* AR5211 */
  	{ PCI_VDEVICE(ATHEROS, PCI_DEVICE_ID_ATHEROS_AR5211), ATH_LED(0, 0) },
  	/* HP Compaq nc6xx, nc4000, nx6000 */
