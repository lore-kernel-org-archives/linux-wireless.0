Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from server19320154104.serverpool.info ([193.201.54.104]:42320 "EHLO
	hauke-m.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751997Ab0AAQWa (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 1 Jan 2010 11:22:30 -0500
From: Hauke Mehrtens <hauke@hauke-m.de>
To: lrodriguez@atheros.com
Cc: linux-wireless@vger.kernel.org, mcgrof@infradead.org,
	Hauke Mehrtens <hauke@hauke-m.de>
Subject: [PATCH 2/5] compat-wireless: Add missing file
Date: Fri,  1 Jan 2010 17:21:09 +0100
Message-Id: <1262362872-10251-3-git-send-email-hauke@hauke-m.de>
In-Reply-To: <1262362872-10251-1-git-send-email-hauke@hauke-m.de>
References: <1262362872-10251-1-git-send-email-hauke@hauke-m.de>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Add file missing in commit 377a5538e1edf8bdf432cc95abe806754de9cda3
	compat-wireless: activate usbnet for kernel > 2.6.28

Signed-off-by: Hauke Mehrtens <hauke@hauke-m.de>
---
 patches/18-rename-usb-net-symbols.patch |   58 +++++++++++++++++++++++++++++++
 1 files changed, 58 insertions(+), 0 deletions(-)
 create mode 100644 patches/18-rename-usb-net-symbols.patch

diff --git a/patches/18-rename-usb-net-symbols.patch b/patches/18-rename-usb-net-symbols.patch
new file mode 100644
index 0000000..d8f6ca3
--- /dev/null
+++ b/patches/18-rename-usb-net-symbols.patch
@@ -0,0 +1,58 @@
+Rename config names for usbnet to deactivate them also if activated in
+the main kernel configuration. This is needed because
+usb_autopm_put_interface_async and usb_autopm_get_interface_async are
+not backported to kernel 2.6.28 and earlier.
+Remove this patch if these symbols are backported.
+
+diff --git a/drivers/net/usb/Makefile b/drivers/net/usb/Makefile
+index e17afb7..ddea3ae 100644
+--- a/drivers/net/usb/Makefile
++++ b/drivers/net/usb/Makefile
+@@ -8,18 +8,18 @@ obj-$(CONFIG_USB_PEGASUS)	+= pegasus.o
+ obj-$(CONFIG_USB_RTL8150)	+= rtl8150.o
+ obj-$(CONFIG_USB_HSO)		+= hso.o
+ obj-$(CONFIG_USB_NET_AX8817X)	+= asix.o
+-obj-$(CONFIG_USB_NET_CDCETHER)	+= cdc_ether.o
++obj-$(CONFIG_USB_NET_COMPAT_CDCETHER)	+= cdc_ether.o
+ obj-$(CONFIG_USB_NET_CDC_EEM)	+= cdc_eem.o
+ obj-$(CONFIG_USB_NET_DM9601)	+= dm9601.o
+ obj-$(CONFIG_USB_NET_SMSC95XX)	+= smsc95xx.o
+ obj-$(CONFIG_USB_NET_GL620A)	+= gl620a.o
+ obj-$(CONFIG_USB_NET_NET1080)	+= net1080.o
+ obj-$(CONFIG_USB_NET_PLUSB)	+= plusb.o
+-obj-$(CONFIG_USB_NET_RNDIS_HOST)	+= rndis_host.o
++obj-$(CONFIG_USB_NET_COMPAT_RNDIS_HOST)	+= rndis_host.o
+ obj-$(CONFIG_USB_NET_CDC_SUBSET)	+= cdc_subset.o
+ obj-$(CONFIG_USB_NET_ZAURUS)	+= zaurus.o
+ obj-$(CONFIG_USB_NET_MCS7830)	+= mcs7830.o
+-obj-$(CONFIG_USB_USBNET)	+= usbnet.o
++obj-$(CONFIG_USB_COMPAT_USBNET)	+= usbnet.o
+ obj-$(CONFIG_USB_NET_INT51X1)	+= int51x1.o
+ obj-$(CONFIG_USB_CDC_PHONET)	+= cdc-phonet.o
+ 
+diff --git a/drivers/net/usb/cdc_ether.c b/drivers/net/usb/cdc_ether.c
+index 21e183a..65c385f 100644
+--- a/drivers/net/usb/cdc_ether.c
++++ b/drivers/net/usb/cdc_ether.c
+@@ -33,7 +33,7 @@
+ #include <linux/usb/usbnet.h>
+ 
+ 
+-#if defined(CONFIG_USB_NET_RNDIS_HOST) || defined(CONFIG_USB_NET_RNDIS_HOST_MODULE)
++#if defined(CONFIG_USB_NET_COMPAT_RNDIS_HOST) || defined(CONFIG_USB_NET_COMPAT_RNDIS_HOST_MODULE)
+ 
+ static int is_rndis(struct usb_interface_descriptor *desc)
+ {
+diff --git a/drivers/net/wireless/Makefile b/drivers/net/wireless/Makefile
+index 5d4ce4d..d4e48bd 100644
+--- a/drivers/net/wireless/Makefile
++++ b/drivers/net/wireless/Makefile
+@@ -29,7 +29,7 @@ obj-$(CONFIG_RTL8187)		+= rtl818x/
+ obj-$(CONFIG_PCMCIA_RAYCS)	+= ray_cs.o
+ obj-$(CONFIG_PCMCIA_WL3501)	+= wl3501_cs.o
+ 
+-obj-$(CONFIG_USB_NET_RNDIS_WLAN)	+= rndis_wlan.o
++obj-$(CONFIG_USB_NET_COMPAT_RNDIS_WLAN)	+= rndis_wlan.o
+ 
+ obj-$(CONFIG_USB_ZD1201)	+= zd1201.o
+ obj-$(CONFIG_LIBERTAS)		+= libertas/
-- 
1.6.3.3

