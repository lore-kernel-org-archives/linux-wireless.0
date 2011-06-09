Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from server19320154104.serverpool.info ([193.201.54.104]:33064 "EHLO
	hauke-m.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756543Ab1FIWEM (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 9 Jun 2011 18:04:12 -0400
From: Hauke Mehrtens <hauke@hauke-m.de>
To: mcgrof@gmail.com, lrodriguez@atheros.com
Cc: linux-wireless@vger.kernel.org, jonas.gorski@gmail.com,
	Hauke Mehrtens <hauke@hauke-m.de>
Subject: [PATCH 04/11] compat-wireless: make patches apply again
Date: Fri, 10 Jun 2011 00:03:35 +0200
Message-Id: <1307657022-23808-5-git-send-email-hauke@hauke-m.de> (sfid-20110610_000417_830508_266523EB)
In-Reply-To: <1307657022-23808-1-git-send-email-hauke@hauke-m.de>
References: <1307657022-23808-1-git-send-email-hauke@hauke-m.de>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Signed-off-by: Hauke Mehrtens <hauke@hauke-m.de>
---
 patches/08-rename-config-options.patch |   10 +++++-----
 patches/09-threaded-irq.patch          |   30 +++++++++++++++---------------
 patches/35-fix-makefile-includes.patch |   10 +++++-----
 3 files changed, 25 insertions(+), 25 deletions(-)

diff --git a/patches/08-rename-config-options.patch b/patches/08-rename-config-options.patch
index fdc2322..3fa9c41 100644
--- a/patches/08-rename-config-options.patch
+++ b/patches/08-rename-config-options.patch
@@ -35,7 +35,7 @@ CONFIG_BT_HIDP does not build with older kernel versions.
  iwl4965-objs		+= iwl-4965-lib.o iwl-4965-rx.o iwl-4965-calib.o
 --- a/drivers/net/wireless/iwlegacy/iwl-dev.h
 +++ b/drivers/net/wireless/iwlegacy/iwl-dev.h
-@@ -1221,7 +1221,7 @@ struct iwl_priv {
+@@ -1211,7 +1211,7 @@ struct iwl_priv {
  
  		} _3945;
  #endif
@@ -69,7 +69,7 @@ CONFIG_BT_HIDP does not build with older kernel versions.
  		zd_rf_al2230.o zd_rf_rf2959.o \
 --- a/include/net/bluetooth/bluetooth.h
 +++ b/include/net/bluetooth/bluetooth.h
-@@ -205,7 +205,7 @@ extern void bt_sysfs_cleanup(void);
+@@ -213,7 +213,7 @@ extern void bt_sysfs_cleanup(void);
  
  extern struct dentry *bt_debugfs;
  
@@ -78,7 +78,7 @@ CONFIG_BT_HIDP does not build with older kernel versions.
  int l2cap_init(void);
  void l2cap_exit(void);
  #else
-@@ -219,7 +219,7 @@ static inline void l2cap_exit(void)
+@@ -227,7 +227,7 @@ static inline void l2cap_exit(void)
  }
  #endif
  
@@ -97,9 +97,9 @@ CONFIG_BT_HIDP does not build with older kernel versions.
 +obj-$(CONFIG_COMPAT_BT_HIDP)	+= hidp/
  
  bluetooth-y := af_bluetooth.o hci_core.o hci_conn.o hci_event.o mgmt.o hci_sock.o hci_sysfs.o lib.o
--bluetooth-$(CONFIG_BT_L2CAP)	+= l2cap_core.o l2cap_sock.o
+-bluetooth-$(CONFIG_BT_L2CAP)	+= l2cap_core.o l2cap_sock.o smp.o
 -bluetooth-$(CONFIG_BT_SCO)	+= sco.o
-+bluetooth-$(CONFIG_COMPAT_BT_L2CAP)	+= l2cap_core.o l2cap_sock.o
++bluetooth-$(CONFIG_COMPAT_BT_L2CAP)	+= l2cap_core.o l2cap_sock.o smp.o
 +bluetooth-$(CONFIG_COMPAT_BT_SCO)	+= sco.o
 --- a/net/bluetooth/hidp/Makefile
 +++ b/net/bluetooth/hidp/Makefile
diff --git a/patches/09-threaded-irq.patch b/patches/09-threaded-irq.patch
index acfe043..9013562 100644
--- a/patches/09-threaded-irq.patch
+++ b/patches/09-threaded-irq.patch
@@ -6,39 +6,39 @@ thread in process context as well.
 
 --- a/drivers/net/wireless/b43/main.c
 +++ b/drivers/net/wireless/b43/main.c
-@@ -3970,8 +3970,13 @@ redo:
- 	if (dev->sdev->bus->bustype == SSB_BUSTYPE_SDIO) {
+@@ -3984,8 +3984,13 @@ redo:
+ 	if (b43_bus_host_is_sdio(dev->dev)) {
  		b43_sdio_free_irq(dev);
  	} else {
 +#if LINUX_VERSION_CODE < KERNEL_VERSION(2,6,31)
 +		compat_synchronize_threaded_irq(&dev->irq_compat);
 +		compat_free_threaded_irq(&dev->irq_compat);
 +#else
- 		synchronize_irq(dev->sdev->irq);
- 		free_irq(dev->sdev->irq, dev);
+ 		synchronize_irq(dev->dev->irq);
+ 		free_irq(dev->dev->irq, dev);
 +#endif
  	}
  	mutex_lock(&wl->mutex);
  	dev = wl->current_dev;
-@@ -4011,9 +4016,17 @@ static int b43_wireless_core_start(struc
+@@ -4025,9 +4030,17 @@ static int b43_wireless_core_start(struc
  			goto out;
  		}
  	} else {
 +#if LINUX_VERSION_CODE < KERNEL_VERSION(2,6,31)
 +		err = compat_request_threaded_irq(&dev->irq_compat,
-+						  dev->sdev->irq,
++						  dev->dev->irq,
 +						  b43_interrupt_handler,
 +						  b43_interrupt_thread_handler,
 +						  IRQF_SHARED, KBUILD_MODNAME, dev);
 +#else
- 		err = request_threaded_irq(dev->sdev->irq, b43_interrupt_handler,
+ 		err = request_threaded_irq(dev->dev->irq, b43_interrupt_handler,
  					   b43_interrupt_thread_handler,
  					   IRQF_SHARED, KBUILD_MODNAME, dev);
 +#endif
  		if (err) {
  			b43err(dev->wl, "Cannot request IRQ-%d\n",
- 			       dev->sdev->irq);
-@@ -4728,6 +4741,10 @@ static int b43_setup_bands(struct b43_wl
+ 			       dev->dev->irq);
+@@ -4744,6 +4757,10 @@ static int b43_setup_bands(struct b43_wl
  
  static void b43_wireless_core_detach(struct b43_wldev *dev)
  {
@@ -51,7 +51,7 @@ thread in process context as well.
  	b43_release_firmware(dev);
 --- a/drivers/net/wireless/b43/b43.h
 +++ b/drivers/net/wireless/b43/b43.h
-@@ -772,6 +772,9 @@ struct b43_wldev {
+@@ -786,6 +786,9 @@ struct b43_wldev {
  	unsigned int tx_count;
  	unsigned int rx_count;
  #endif
@@ -63,7 +63,7 @@ thread in process context as well.
  /* Data structure for the WLAN parts (802.11 cores) of the b43 chip. */
 --- a/drivers/net/wireless/wl12xx/spi.c
 +++ b/drivers/net/wireless/wl12xx/spi.c
-@@ -405,10 +405,14 @@ static int __devinit wl1271_probe(struct
+@@ -406,10 +406,14 @@ static int __devinit wl1271_probe(struct
  	wl->tcxo_clock = pdata->board_tcxo_clock;
  	wl->platform_quirks = pdata->platform_quirks;
  
@@ -78,7 +78,7 @@ thread in process context as well.
  
  	wl->irq = spi->irq;
  	if (wl->irq < 0) {
-@@ -417,9 +421,16 @@ static int __devinit wl1271_probe(struct
+@@ -418,9 +422,16 @@ static int __devinit wl1271_probe(struct
  		goto out_free;
  	}
  
@@ -95,7 +95,7 @@ thread in process context as well.
  	if (ret < 0) {
  		wl1271_error("request_irq() failed: %d", ret);
  		goto out_free;
-@@ -440,7 +451,11 @@ static int __devinit wl1271_probe(struct
+@@ -441,7 +452,11 @@ static int __devinit wl1271_probe(struct
  	return 0;
  
   out_irq:
@@ -107,7 +107,7 @@ thread in process context as well.
  
   out_free:
  	wl1271_free_hw(wl);
-@@ -453,7 +468,12 @@ static int __devexit wl1271_remove(struc
+@@ -454,7 +469,12 @@ static int __devexit wl1271_remove(struc
  	struct wl1271 *wl = dev_get_drvdata(&spi->dev);
  
  	wl1271_unregister_hw(wl);
@@ -122,7 +122,7 @@ thread in process context as well.
  	return 0;
 --- a/drivers/net/wireless/wl12xx/wl12xx.h
 +++ b/drivers/net/wireless/wl12xx/wl12xx.h
-@@ -593,6 +593,10 @@ struct wl1271 {
+@@ -594,6 +594,10 @@ struct wl1271 {
  
  	/* Platform limitations */
  	unsigned int platform_quirks;
diff --git a/patches/35-fix-makefile-includes.patch b/patches/35-fix-makefile-includes.patch
index 4a01aa2..ea8bd8c 100644
--- a/patches/35-fix-makefile-includes.patch
+++ b/patches/35-fix-makefile-includes.patch
@@ -45,17 +45,17 @@ path the make process will search in the kernel tree for the headers.
 +	-I$(obj)/../include
  
  BRCMSMAC_OFILES := \
- 	wl_mac80211.o \
---- a/drivers/staging/brcm80211/util/Makefile
-+++ b/drivers/staging/brcm80211/util/Makefile
+ 	mac80211_if.o \
+--- a/drivers/staging/brcm80211/brcmutil/Makefile
++++ b/drivers/staging/brcm80211/brcmutil/Makefile
 @@ -16,8 +16,8 @@
  # CONNECTION WITH THE USE OR PERFORMANCE OF THIS SOFTWARE.
  
  ccflags-y :=				\
--	-Idrivers/staging/brcm80211/util \
+-	-Idrivers/staging/brcm80211/brcmutil \
 -	-Idrivers/staging/brcm80211/include
 +	-I$(obj)			\
 +	-I$(obj)/../include
  
  BRCMUTIL_OFILES := \
- 	bcmutils.o \
+ 	utils.o \
-- 
1.7.4.1

