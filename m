Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from server19320154104.serverpool.info ([193.201.54.104]:57243 "EHLO
	hauke-m.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752318AbZEQMrv (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Sun, 17 May 2009 08:47:51 -0400
From: Hauke Mehrtens <hauke@hauke-m.de>
To: lrodriguez@atheros.com
Cc: linux-wireless@vger.kernel.org, stecklum@tls-tautenburg.de,
	me@bobcopeland.com, breusshe@hotmail.com,
	Hauke Mehrtens <hauke@hauke-m.de>
Subject: [PATCH 2/4] compat-2.6: Add WL12XX driver.
Date: Sun, 17 May 2009 14:47:41 +0200
Message-Id: <1242564463-9120-2-git-send-email-hauke@hauke-m.de>
In-Reply-To: <1242564463-9120-1-git-send-email-hauke@hauke-m.de>
References: <1242564463-9120-1-git-send-email-hauke@hauke-m.de>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Signed-off-by: Hauke Mehrtens <hauke@hauke-m.de>
---
 compat/compat.diff      |   30 ++++++++++++++++++++++++------
 config.mk               |    6 ++++++
 scripts/admin-update.sh |   10 ++++++++++
 3 files changed, 40 insertions(+), 6 deletions(-)

diff --git a/compat/compat.diff b/compat/compat.diff
index 3ee9e86..1c05577 100644
--- a/compat/compat.diff
+++ b/compat/compat.diff
@@ -181,12 +181,6 @@
  obj-$(CONFIG_LIBERTAS)		+= libertas/
  
  obj-$(CONFIG_LIBERTAS_THINFIRM)	+= libertas_tf/
-@@ -58,5 +32,3 @@ obj-$(CONFIG_P54_COMMON)	+= p54/
- obj-$(CONFIG_ATH_COMMON)	+= ath/
- 
- obj-$(CONFIG_MAC80211_HWSIM)	+= mac80211_hwsim.o
--
--obj-$(CONFIG_WL12XX)	+= wl12xx/
 --- a/drivers/net/wireless/b43/pcmcia.c
 +++ b/drivers/net/wireless/b43/pcmcia.c
 @@ -87,7 +87,11 @@ static int __devinit b43_pcmcia_probe(struct pcmcia_device *dev)
@@ -464,6 +458,30 @@
  
  	tmp = RNDIS_PACKET_TYPE_DIRECTED | RNDIS_PACKET_TYPE_BROADCAST;
  	retval = rndis_set_oid(usbdev, OID_GEN_CURRENT_PACKET_FILTER, &tmp,
+--- a/drivers/net/wireless/wl12xx/main.c
++++ b/drivers/net/wireless/wl12xx/main.c
+@@ -26,6 +26,9 @@
+ #include <linux/firmware.h>
+ #include <linux/delay.h>
+ #include <linux/irq.h>
++#if (LINUX_VERSION_CODE == KERNEL_VERSION(2,6,28))
++#include <linux/device.h>
++#endif
+ #include <linux/spi/spi.h>
+ #include <linux/crc32.h>
+ #include <linux/etherdevice.h>
+--- a/drivers/net/wireless/wl12xx/spi.c
++++ b/drivers/net/wireless/wl12xx/spi.c
+@@ -23,6 +23,9 @@
+ 
+ #include <linux/module.h>
+ #include <linux/crc7.h>
++#if (LINUX_VERSION_CODE == KERNEL_VERSION(2,6,28))
++#include <linux/device.h>
++#endif
+ #include <linux/spi/spi.h>
+ 
+ #include "wl12xx.h"
 --- a/include/net/cfg80211.h
 +++ b/include/net/cfg80211.h
 @@ -23,6 +23,7 @@
diff --git a/config.mk b/config.mk
index a3296d3..f94b37b 100644
--- a/config.mk
+++ b/config.mk
@@ -280,6 +280,12 @@ endif
 
 endif # end of USB driver list
 
+ifneq ($(CONFIG_SPI_MASTER),)
+
+CONFIG_WL12XX=m
+
+endif # end of SPI driver list
+
 # Common rt2x00 requirements
 ifeq ($(NEED_RT2X00),y)
 CONFIG_RT2X00=m
diff --git a/scripts/admin-update.sh b/scripts/admin-update.sh
index 574d4e3..1616844 100755
--- a/scripts/admin-update.sh
+++ b/scripts/admin-update.sh
@@ -24,6 +24,8 @@ INCLUDE_LINUX="$INCLUDE_LINUX ath9k_platform.h"
 # For rndis_wext
 INCLUDE_LINUX_USB="usbnet.h rndis_host.h"
 
+INCLUDE_LINUX_SPI="wl12xx.h"
+
 # The good new yummy stuff
 INCLUDE_NET="cfg80211.h ieee80211_radiotap.h iw_handler.h"
 INCLUDE_NET="$INCLUDE_NET mac80211.h wext.h lib80211.h regulatory.h"
@@ -61,6 +63,7 @@ DRIVERS="$DRIVERS drivers/net/wireless/p54"
 DRIVERS="$DRIVERS drivers/net/wireless/rtl818x"
 DRIVERS="$DRIVERS drivers/net/wireless/libertas_tf"
 DRIVERS="$DRIVERS drivers/net/wireless/ipw2x00"
+DRIVERS="$DRIVERS drivers/net/wireless/wl12xx"
 
 # Drivers that belong the the wireless directory
 DRIVER_FILES="adm8211.c  adm8211.h"
@@ -71,6 +74,7 @@ DRIVER_FILES="$DRIVER_FILES mwl8k.c"
 
 mkdir -p include/linux/ include/net/ include/linux/usb \
 	include/linux/unaligned \
+	include/linux/spi \
 	net/mac80211/ net/wireless/ \
 	drivers/ssb/ \
 	drivers/net/usb/ \
@@ -98,6 +102,12 @@ for i in $INCLUDE_LINUX_USB; do
 	cp $GIT_TREE/$DIR/$i $DIR/
 done
 
+DIR="include/linux/spi"
+for i in $INCLUDE_LINUX_SPI; do
+	echo "Copying $GIT_TREE/$DIR/$i"
+	cp $GIT_TREE/$DIR/$i $DIR/
+done
+
 # net/wireless and net/mac80211
 for i in $NET_DIRS; do
 	echo "Copying $GIT_TREE/net/$i/*.[ch]"
-- 
1.6.2.1

