Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from server19320154104.serverpool.info ([193.201.54.104]:55507 "EHLO
	hauke-m.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752951Ab1LVUrp (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 22 Dec 2011 15:47:45 -0500
From: Hauke Mehrtens <hauke@hauke-m.de>
To: mcgrof@gmail.com, mcgrof@qca.qualcomm.com
Cc: linux-wireless@vger.kernel.org, Hauke Mehrtens <hauke@hauke-m.de>
Subject: [PATCH 1/6] compat-wireless: compile fix for commit patches/09-threaded-irq.patch
Date: Thu, 22 Dec 2011 21:47:25 +0100
Message-Id: <1324586850-5212-2-git-send-email-hauke@hauke-m.de> (sfid-20111222_214749_444132_7A9DE89D)
In-Reply-To: <1324586850-5212-1-git-send-email-hauke@hauke-m.de>
References: <1324586850-5212-1-git-send-email-hauke@hauke-m.de>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This commit had some compile problem with kernel < 2.6.32

commit c486a4fcc5ddfb3232edfd0489fe63ffc1fa8aea
Author: Luis R. Rodriguez <mcgrof@qca.qualcomm.com>
Date:   Tue Dec 13 10:40:55 2011 -0800

    compat-wireless: fix patches/09-threaded-irq.patch

There was a semicolon missing at the end of a line and wl1271_hardirq
has to be renamed to wl12xx_hardirq.
This is now compile tested with all maijor kernel version from 2.6.27.

Signed-off-by: Hauke Mehrtens <hauke@hauke-m.de>
---
 patches/09-threaded-irq.patch |   22 +++++++++++-----------
 1 files changed, 11 insertions(+), 11 deletions(-)

diff --git a/patches/09-threaded-irq.patch b/patches/09-threaded-irq.patch
index 694dde9..83e6c7b 100644
--- a/patches/09-threaded-irq.patch
+++ b/patches/09-threaded-irq.patch
@@ -6,7 +6,7 @@ thread in process context as well.
 
 --- a/drivers/net/wireless/b43/main.c
 +++ b/drivers/net/wireless/b43/main.c
-@@ -4184,8 +4184,13 @@ redo:
+@@ -4201,8 +4201,13 @@ redo:
  	if (b43_bus_host_is_sdio(dev->dev)) {
  		b43_sdio_free_irq(dev);
  	} else {
@@ -20,7 +20,7 @@ thread in process context as well.
  	}
  	mutex_lock(&wl->mutex);
  	dev = wl->current_dev;
-@@ -4225,9 +4230,17 @@ static int b43_wireless_core_start(struc
+@@ -4244,9 +4249,17 @@ static int b43_wireless_core_start(struc
  			goto out;
  		}
  	} else {
@@ -38,7 +38,7 @@ thread in process context as well.
  		if (err) {
  			b43err(dev->wl, "Cannot request IRQ-%d\n",
  			       dev->dev->irq);
-@@ -5016,6 +5029,10 @@ static int b43_setup_bands(struct b43_wl
+@@ -5035,6 +5048,10 @@ static int b43_setup_bands(struct b43_wl
  
  static void b43_wireless_core_detach(struct b43_wldev *dev)
  {
@@ -51,7 +51,7 @@ thread in process context as well.
  	b43_release_firmware(dev);
 --- a/drivers/net/wireless/b43/b43.h
 +++ b/drivers/net/wireless/b43/b43.h
-@@ -843,6 +843,9 @@ struct b43_wldev {
+@@ -844,6 +844,9 @@ struct b43_wldev {
  	unsigned int tx_count;
  	unsigned int rx_count;
  #endif
@@ -63,22 +63,22 @@ thread in process context as well.
  /* Data structure for the WLAN parts (802.11 cores) of the b43 chip. */
 --- a/drivers/net/wireless/wl12xx/main.c
 +++ b/drivers/net/wireless/wl12xx/main.c
-@@ -5183,14 +5183,25 @@ static int __devinit wl12xx_probe(struct
+@@ -5180,14 +5180,25 @@ static int __devinit wl12xx_probe(struct
  
  	platform_set_drvdata(pdev, wl);
  
 +#if LINUX_VERSION_CODE < KERNEL_VERSION(2,6,32)
-+	irqflags = IRQF_TRIGGER_RISING
++	irqflags = IRQF_TRIGGER_RISING;
 +#else
  	if (wl->platform_quirks & WL12XX_PLATFORM_QUIRK_EDGE_IRQ)
  		irqflags = IRQF_TRIGGER_RISING;
  	else
  		irqflags = IRQF_TRIGGER_HIGH | IRQF_ONESHOT;
- 
 +#endif
+ 
 +#if LINUX_VERSION_CODE < KERNEL_VERSION(2,6,31)
 +	ret = compat_request_threaded_irq(&wl->irq_compat, wl->irq,
-+					  wl1271_hardirq, wl1271_irq,
++					  wl12xx_hardirq, wl1271_irq,
 +					  irqflags,
 +					  pdev->name, wl);
 +#else
@@ -89,7 +89,7 @@ thread in process context as well.
  	if (ret < 0) {
  		wl1271_error("request_irq() failed: %d", ret);
  		goto out_free_hw;
-@@ -5244,7 +5255,11 @@ out_bt_coex_state:
+@@ -5241,7 +5252,11 @@ out_bt_coex_state:
  	device_remove_file(wl->dev, &dev_attr_bt_coex_state);
  
  out_irq:
@@ -101,7 +101,7 @@ thread in process context as well.
  
  out_free_hw:
  	wl1271_free_hw(wl);
-@@ -5262,7 +5277,12 @@ static int __devexit wl12xx_remove(struc
+@@ -5259,7 +5274,12 @@ static int __devexit wl12xx_remove(struc
  		disable_irq_wake(wl->irq);
  	}
  	wl1271_unregister_hw(wl);
@@ -116,7 +116,7 @@ thread in process context as well.
  	return 0;
 --- a/drivers/net/wireless/wl12xx/wl12xx.h
 +++ b/drivers/net/wireless/wl12xx/wl12xx.h
-@@ -484,6 +484,10 @@ struct wl1271 {
+@@ -477,6 +477,10 @@ struct wl1271 {
  
  	/* last wlvif we transmitted from */
  	struct wl12xx_vif *last_wlvif;
-- 
1.7.5.4

