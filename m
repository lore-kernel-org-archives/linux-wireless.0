Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from server19320154104.serverpool.info ([193.201.54.104]:47298 "EHLO
	hauke-m.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752582Ab1IURGY (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 21 Sep 2011 13:06:24 -0400
From: Hauke Mehrtens <hauke@hauke-m.de>
To: mcgrof@gmail.com, mcgrof@qca.qualcomm.com
Cc: linux-wireless@vger.kernel.org, Hauke Mehrtens <hauke@hauke-m.de>
Subject: [PATCH 1/2] compat-wireless: make patches apply again
Date: Wed, 21 Sep 2011 19:06:16 +0200
Message-Id: <1316624777-8001-1-git-send-email-hauke@hauke-m.de> (sfid-20110921_190633_416554_ADA17F54)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


Signed-off-by: Hauke Mehrtens <hauke@hauke-m.de>
---
 patches/09-threaded-irq.patch |   12 ++++++------
 1 files changed, 6 insertions(+), 6 deletions(-)

diff --git a/patches/09-threaded-irq.patch b/patches/09-threaded-irq.patch
index 7df41f6..d83b6d4 100644
--- a/patches/09-threaded-irq.patch
+++ b/patches/09-threaded-irq.patch
@@ -6,7 +6,7 @@ thread in process context as well.
 
 --- a/drivers/net/wireless/b43/main.c
 +++ b/drivers/net/wireless/b43/main.c
-@@ -4174,8 +4174,13 @@ redo:
+@@ -4175,8 +4175,13 @@ redo:
  	if (b43_bus_host_is_sdio(dev->dev)) {
  		b43_sdio_free_irq(dev);
  	} else {
@@ -20,7 +20,7 @@ thread in process context as well.
  	}
  	mutex_lock(&wl->mutex);
  	dev = wl->current_dev;
-@@ -4215,9 +4220,17 @@ static int b43_wireless_core_start(struc
+@@ -4216,9 +4221,17 @@ static int b43_wireless_core_start(struc
  			goto out;
  		}
  	} else {
@@ -38,7 +38,7 @@ thread in process context as well.
  		if (err) {
  			b43err(dev->wl, "Cannot request IRQ-%d\n",
  			       dev->dev->irq);
-@@ -5006,6 +5019,10 @@ static int b43_setup_bands(struct b43_wl
+@@ -5007,6 +5020,10 @@ static int b43_setup_bands(struct b43_wl
  
  static void b43_wireless_core_detach(struct b43_wldev *dev)
  {
@@ -122,10 +122,10 @@ thread in process context as well.
  	return 0;
 --- a/drivers/net/wireless/wl12xx/wl12xx.h
 +++ b/drivers/net/wireless/wl12xx/wl12xx.h
-@@ -626,6 +626,10 @@ struct wl1271 {
+@@ -630,6 +630,10 @@ struct wl1271 {
  
- 	/* number of currently active RX BA sessions */
- 	int ba_rx_session_count;
+ 	/* AP-mode - number of currently connected stations */
+ 	int active_sta_count;
 +
 +#if LINUX_VERSION_CODE < KERNEL_VERSION(2,6,31)
 +	struct compat_threaded_irq irq_compat;
-- 
1.7.4.1

