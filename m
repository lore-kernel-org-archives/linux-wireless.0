Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from server19320154104.serverpool.info ([193.201.54.104]:60015 "EHLO
	hauke-m.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752767Ab1GVQu0 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 22 Jul 2011 12:50:26 -0400
From: Hauke Mehrtens <hauke@hauke-m.de>
To: mcgrof@gmail.com, lrodriguez@atheros.com
Cc: linux-wireless@vger.kernel.org, Hauke Mehrtens <hauke@hauke-m.de>
Subject: [PATCH 2/5] compat-wireless: fix build of b43 on older kernels.
Date: Fri, 22 Jul 2011 18:50:12 +0200
Message-Id: <1311353415-30952-2-git-send-email-hauke@hauke-m.de> (sfid-20110722_185029_257089_07038BED)
In-Reply-To: <1311353415-30952-1-git-send-email-hauke@hauke-m.de>
References: <1311353415-30952-1-git-send-email-hauke@hauke-m.de>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

The structs in b43 changed.

Signed-off-by: Hauke Mehrtens <hauke@hauke-m.de>
---
 patches/09-threaded-irq.patch |   10 +++++-----
 1 files changed, 5 insertions(+), 5 deletions(-)

diff --git a/patches/09-threaded-irq.patch b/patches/09-threaded-irq.patch
index e2748d9..cc8c5d4 100644
--- a/patches/09-threaded-irq.patch
+++ b/patches/09-threaded-irq.patch
@@ -6,7 +6,7 @@ thread in process context as well.
 
 --- a/drivers/net/wireless/b43/main.c
 +++ b/drivers/net/wireless/b43/main.c
-@@ -4124,8 +4124,13 @@ redo:
+@@ -4144,8 +4144,13 @@ redo:
  	if (b43_bus_host_is_sdio(dev->dev)) {
  		b43_sdio_free_irq(dev);
  	} else {
@@ -20,7 +20,7 @@ thread in process context as well.
  	}
  	mutex_lock(&wl->mutex);
  	dev = wl->current_dev;
-@@ -4165,9 +4170,17 @@ static int b43_wireless_core_start(struc
+@@ -4185,9 +4190,17 @@ static int b43_wireless_core_start(struc
  			goto out;
  		}
  	} else {
@@ -38,12 +38,12 @@ thread in process context as well.
  		if (err) {
  			b43err(dev->wl, "Cannot request IRQ-%d\n",
  			       dev->dev->irq);
-@@ -4937,6 +4950,10 @@ static int b43_setup_bands(struct b43_wl
+@@ -4957,6 +4970,10 @@ static int b43_setup_bands(struct b43_wl
  
  static void b43_wireless_core_detach(struct b43_wldev *dev)
  {
 +#if LINUX_VERSION_CODE < KERNEL_VERSION(2,6,31)
-+	if (dev->sdev->bus->bustype != SSB_BUSTYPE_SDIO)
++	if (dev->dev->sdev->bus->bustype != SSB_BUSTYPE_SDIO)
 +		compat_destroy_threaded_irq(&dev->irq_compat);
 +#endif
  	/* We release firmware that late to not be required to re-request
@@ -51,7 +51,7 @@ thread in process context as well.
  	b43_release_firmware(dev);
 --- a/drivers/net/wireless/b43/b43.h
 +++ b/drivers/net/wireless/b43/b43.h
-@@ -791,6 +791,9 @@ struct b43_wldev {
+@@ -798,6 +798,9 @@ struct b43_wldev {
  	unsigned int tx_count;
  	unsigned int rx_count;
  #endif
-- 
1.7.4.1

