Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from server19320154104.serverpool.info ([193.201.54.104]:35328 "EHLO
	hauke-m.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755994Ab1HaWKi (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 31 Aug 2011 18:10:38 -0400
From: Hauke Mehrtens <hauke@hauke-m.de>
To: mcgrof@gmail.com, mcgrof@qca.qualcomm.com
Cc: linux-wireless@vger.kernel.org, Hauke Mehrtens <hauke@hauke-m.de>
Subject: [PATCH 1/2] compat-wireless: make patches apply again
Date: Thu,  1 Sep 2011 00:10:29 +0200
Message-Id: <1314828630-26768-1-git-send-email-hauke@hauke-m.de> (sfid-20110901_001041_363230_92D9FF4A)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


Signed-off-by: Hauke Mehrtens <hauke@hauke-m.de>
---
 patches/09-threaded-irq.patch          |   12 ++++++------
 patches/35-fix-makefile-includes.patch |   10 +++++-----
 patches/37-vsnprintk.patch             |   13 ++++++-------
 3 files changed, 17 insertions(+), 18 deletions(-)

diff --git a/patches/09-threaded-irq.patch b/patches/09-threaded-irq.patch
index de84972..bea44d2 100644
--- a/patches/09-threaded-irq.patch
+++ b/patches/09-threaded-irq.patch
@@ -6,7 +6,7 @@ thread in process context as well.
 
 --- a/drivers/net/wireless/b43/main.c
 +++ b/drivers/net/wireless/b43/main.c
-@@ -4168,8 +4168,13 @@ redo:
+@@ -4171,8 +4171,13 @@ redo:
  	if (b43_bus_host_is_sdio(dev->dev)) {
  		b43_sdio_free_irq(dev);
  	} else {
@@ -20,7 +20,7 @@ thread in process context as well.
  	}
  	mutex_lock(&wl->mutex);
  	dev = wl->current_dev;
-@@ -4209,9 +4214,17 @@ static int b43_wireless_core_start(struc
+@@ -4212,9 +4217,17 @@ static int b43_wireless_core_start(struc
  			goto out;
  		}
  	} else {
@@ -38,7 +38,7 @@ thread in process context as well.
  		if (err) {
  			b43err(dev->wl, "Cannot request IRQ-%d\n",
  			       dev->dev->irq);
-@@ -5000,6 +5013,10 @@ static int b43_setup_bands(struct b43_wl
+@@ -5003,6 +5016,10 @@ static int b43_setup_bands(struct b43_wl
  
  static void b43_wireless_core_detach(struct b43_wldev *dev)
  {
@@ -122,10 +122,10 @@ thread in process context as well.
  	return 0;
 --- a/drivers/net/wireless/wl12xx/wl12xx.h
 +++ b/drivers/net/wireless/wl12xx/wl12xx.h
-@@ -622,6 +622,10 @@ struct wl1271 {
+@@ -623,6 +623,10 @@ struct wl1271 {
  
- 	/* Platform limitations */
- 	unsigned int platform_quirks;
+ 	/* number of currently active RX BA sessions */
+ 	int ba_rx_session_count;
 +
 +#if LINUX_VERSION_CODE < KERNEL_VERSION(2,6,31)
 +	struct compat_threaded_irq irq_compat;
diff --git a/patches/35-fix-makefile-includes.patch b/patches/35-fix-makefile-includes.patch
index aa3dd92..17994b7 100644
--- a/patches/35-fix-makefile-includes.patch
+++ b/patches/35-fix-makefile-includes.patch
@@ -20,7 +20,7 @@ path the make process will search in the kernel tree for the headers.
 +ccflags-y += -I$(obj)/..
 --- a/drivers/staging/brcm80211/brcmfmac/Makefile
 +++ b/drivers/staging/brcm80211/brcmfmac/Makefile
-@@ -23,8 +23,8 @@ ccflags-y :=			\
+@@ -18,8 +18,8 @@
  ccflags-$(CONFIG_BRCMDBG)	+= -DSHOW_EVENTS
  
  ccflags-y += \
@@ -33,10 +33,10 @@ path the make process will search in the kernel tree for the headers.
  	wl_cfg80211.o \
 --- a/drivers/staging/brcm80211/brcmsmac/Makefile
 +++ b/drivers/staging/brcm80211/brcmsmac/Makefile
-@@ -23,9 +23,9 @@ ccflags-y :=				\
- 	-DWL11N					\
- 	-DDBAND					\
- 	-DBCMNVRAMR				\
+@@ -16,9 +16,9 @@
+ # CONNECTION WITH THE USE OR PERFORMANCE OF THIS SOFTWARE.
+ 
+ ccflags-y :=				\
 -	-Idrivers/staging/brcm80211/brcmsmac \
 -	-Idrivers/staging/brcm80211/brcmsmac/phy \
 -	-Idrivers/staging/brcm80211/include
diff --git a/patches/37-vsnprintk.patch b/patches/37-vsnprintk.patch
index b192713..8217de9 100644
--- a/patches/37-vsnprintk.patch
+++ b/patches/37-vsnprintk.patch
@@ -1,14 +1,13 @@
 --- a/drivers/net/wireless/ath/main.c
 +++ b/drivers/net/wireless/ath/main.c
-@@ -60,16 +60,23 @@ EXPORT_SYMBOL(ath_rxbuf_alloc);
- int ath_printk(const char *level, struct ath_common *common,
- 	       const char *fmt, ...)
+@@ -59,15 +59,22 @@ EXPORT_SYMBOL(ath_rxbuf_alloc);
+ 
+ void ath_printk(const char *level, const char *fmt, ...)
  {
 +#if (LINUX_VERSION_CODE >= KERNEL_VERSION(2,6,36))
  	struct va_format vaf;
 +#endif
  	va_list args;
- 	int rtn;
  
  	va_start(args, fmt);
  
@@ -16,11 +15,11 @@
  	vaf.fmt = fmt;
  	vaf.va = &args;
  
- 	rtn = printk("%sath: %pV", level, &vaf);
+ 	printk("%sath: %pV", level, &vaf);
 +#else
 +	printk("%sath: ", level);
-+	rtn = vprintk(fmt, args);
++	vprintk(fmt, args);
 +#endif
  
  	va_end(args);
- 
+ }
-- 
1.7.4.1

