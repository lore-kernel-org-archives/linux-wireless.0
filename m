Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mr1.bfh.ch ([147.87.250.50]:36451 "EHLO mr1.bfh.ch"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752589AbYEPNse (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 16 May 2008 09:48:34 -0400
From: Michael Bernhard <michael.bernhard@bfh.ch>
To: mcgrof@winlab.rutgers.edu
Cc: linux-wireless@vger.kernel.org
Subject: [PATCH 1/3] compat-2.6: Correct the three failed hunks
Date: Fri, 16 May 2008 15:48:43 +0200
Message-Id: <12109457263315-git-send-email-michael.bernhard@bfh.ch> (sfid-20080516_154839_837335_87185CE4)
In-Reply-To: <1210945725582-git-send-email-michael.bernhard@bfh.ch>
References: <1210945725582-git-send-email-michael.bernhard@bfh.ch>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Signed-off-by: Michael Bernhard <michael.bernhard@bfh.ch>
---
 compat/compat.diff |   24 +++++++++++++++---------
 1 files changed, 15 insertions(+), 9 deletions(-)

diff --git a/compat/compat.diff b/compat/compat.diff
index cce9875..ce0808d 100644
--- a/compat/compat.diff
+++ b/compat/compat.diff
@@ -39,7 +39,7 @@
  int wiphy_sysfs_init(void)
 --- a/include/linux/bitops.h	2008-02-28 19:54:52.000000000 +0100
 +++ b/include/linux/bitops.h	2008-02-28 19:54:53.000000000 +0100
-@@ -1,12 +1,15 @@
+@@ -1,14 +1,17 @@
  #ifndef _LINUX_BITOPS_H
  #define _LINUX_BITOPS_H
  #include <asm/types.h>
@@ -49,12 +49,14 @@
  #define BIT(nr)			(1UL << (nr))
  #define BIT_MASK(nr)		(1UL << ((nr) % BITS_PER_LONG))
  #define BIT_WORD(nr)		((nr) / BITS_PER_LONG)
-+#if (LINUX_VERSION_CODE > KERNEL_VERSION(2,6,23))
- #define BITS_TO_LONGS(nr)	DIV_ROUND_UP(nr, BITS_PER_LONG)
-+#endif
  #define BITS_PER_BYTE		8
++#if (LINUX_VERSION_CODE > KERNEL_VERSION(2,6,23))
+ #define BITS_TO_LONGS(nr)	DIV_ROUND_UP(nr, BITS_PER_BYTE * sizeof(long))
  #endif
++#endif
  
+ /*
+  * Include this here because some architectures need generic_ffs/fls in
 --- a/include/linux/ssb/ssb.h	2008-02-28 19:54:52.000000000 +0100
 +++ b/include/linux/ssb/ssb.h	2008-02-28 19:54:53.000000000 +0100
 @@ -9,6 +9,7 @@
@@ -198,7 +200,7 @@
  rtl8180-objs		:= rtl8180_dev.o rtl8180_rtl8225.o rtl8180_sa2400.o rtl8180_max2820.o rtl8180_grf5101.o
 --- a/drivers/misc/Makefile	2008-02-28 19:54:52.000000000 +0100
 +++ b/drivers/misc/Makefile	2008-02-28 19:54:53.000000000 +0100
-@@ -3,22 +3,4 @@
+@@ -3,26 +3,4 @@
  #
  obj- := misc.o	# Dummy rule to force built-in.o to be made
  
@@ -206,9 +208,11 @@
 -obj-$(CONFIG_HDPU_FEATURES)	+= hdpuftrs/
 -obj-$(CONFIG_MSI_LAPTOP)     += msi-laptop.o
 -obj-$(CONFIG_ACER_WMI)     += acer-wmi.o
--obj-$(CONFIG_ASUS_LAPTOP)     += asus-laptop.o
+-obj-$(CONFIG_ASUS_LAPTOP)	+= asus-laptop.o
+-obj-$(CONFIG_EEEPC_LAPTOP)	+= eeepc-laptop.o
 -obj-$(CONFIG_ATMEL_PWM)		+= atmel_pwm.o
 -obj-$(CONFIG_ATMEL_SSC)		+= atmel-ssc.o
+-obj-$(CONFIG_ATMEL_TCLIB)	+= atmel_tclib.o
 -obj-$(CONFIG_TC1100_WMI)	+= tc1100-wmi.o
 -obj-$(CONFIG_LKDTM)		+= lkdtm.o
 -obj-$(CONFIG_TIFM_CORE)       	+= tifm_core.o
@@ -221,6 +225,8 @@
  obj-$(CONFIG_EEPROM_93CX6)	+= eeprom_93cx6.o
 -obj-$(CONFIG_INTEL_MENLOW)	+= intel_menlow.o
 -obj-$(CONFIG_ENCLOSURE_SERVICES) += enclosure.o
+-obj-$(CONFIG_KGDB_TESTS)	+= kgdbts.o
+-obj-$(CONFIG_SGI_XP)		+= sgi-xp/
 --- a/net/wireless/core.c	2008-02-28 19:54:52.000000000 +0100
 +++ b/net/wireless/core.c	2008-02-28 19:54:53.000000000 +0100
 @@ -71,9 +71,9 @@ __cfg80211_drv_from_info(struct genl_inf
@@ -491,7 +497,7 @@
  		for (i = 0; i < len; i += 2) {
  			u16 val = buf[i] | (buf[i + 1] << 8);
  			adm8211_write_sram(dev, addr + i / 2, val);
-@@ -445,7 +477,11 @@
+@@ -444,7 +476,11 @@
  		if (skb) {
  			struct ieee80211_rx_status rx_status = {0};
  
@@ -500,9 +506,9 @@
 +#else
  			if (priv->pdev->revision < ADM8211_REV_CA)
 +#endif
- 				rx_status.ssi = rssi;
+ 				rx_status.signal = rssi;
  			else
- 				rx_status.ssi = 100 - rssi;
+ 				rx_status.signal = 100 - rssi;
 @@ -718,7 +754,11 @@
  		adm8211_rf_write_syn_rfmd2958(dev, 0x0A, reg);
  		/* set TXRX TX_GAIN */
-- 
1.5.2.5

