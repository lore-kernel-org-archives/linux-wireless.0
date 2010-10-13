Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-yw0-f46.google.com ([209.85.213.46]:47717 "EHLO
	mail-yw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753149Ab0JMLJP (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 13 Oct 2010 07:09:15 -0400
From: csanjay@mistralsolutions.com
To: linux-omap@vger.kernel.org
Cc: linux-wireless@vger.kernel.org,
	Sanjay Kumar Champati <csanjay@mistralsolutions.com>
Subject: [RFC: WL1271 DC supprot on OMAP3EVM 3/5] ARM: Supported for BT enable on OMAP3EVM for WL1271 DC
Date: Wed, 13 Oct 2010 16:27:17 +0530
Message-Id: <1286967439-705-4-git-send-email-csanjay@mistralsolutions.com>
In-Reply-To: <1286967439-705-1-git-send-email-csanjay@mistralsolutions.com>
References: <1286967439-705-1-git-send-email-csanjay@mistralsolutions.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Sanjay Kumar Champati <csanjay@mistralsolutions.com>

* Midified "tty_io.c" and "Kconfig" files to suuport BT enable for WL1271

Signed-off-by: Sanjay Kumar Champati <csanjay@mistralsolutions.com>
---
 drivers/bluetooth/Kconfig |    7 +++
 drivers/char/tty_io.c     |  110 +++++++++++++++++++++++++++++++++++++++++++++
 2 files changed, 117 insertions(+), 0 deletions(-)

diff --git a/drivers/bluetooth/Kconfig b/drivers/bluetooth/Kconfig
index 652367a..2ed159c 100644
--- a/drivers/bluetooth/Kconfig
+++ b/drivers/bluetooth/Kconfig
@@ -195,5 +195,12 @@ config BT_MRVL_SDIO
 	  Say Y here to compile support for Marvell BT-over-SDIO driver
 	  into the kernel or say M to compile it as module.
 
+config BT_WL1271
+	bool "WL1271 Bluetooth driver support"
+	depends on BT_HCIUART
+	help
+	The core driver to support WL1271 Bluetooth devices.
+	Say Y here to compile WL1271 Bluetooth driver into the kernel.
+
 endmenu
 
diff --git a/drivers/char/tty_io.c b/drivers/char/tty_io.c
index f15df40..a3ae352 100644
--- a/drivers/char/tty_io.c
+++ b/drivers/char/tty_io.c
@@ -107,6 +107,17 @@
 #include <linux/kmod.h>
 #include <linux/nsproxy.h>
 
+#ifdef CONFIG_BT_WL1271
+/*
+ *	WL1271: To control T2 gpios on OMAP3 EVM
+ */
+#include "linux/i2c/twl.h"
+
+/*
+ *	WL1271: To set BT_EN of TI's WL1271 Bluetooth chip
+ */
+#define TIOSETWL1271POWER 0x6000
+#endif
 #undef TTY_DEBUG_HANGUP
 
 #define TTY_PARANOIA_CHECK 1
@@ -154,6 +165,95 @@ static void release_tty(struct tty_struct *tty, int idx);
 static void __proc_set_tty(struct task_struct *tsk, struct tty_struct *tty);
 static void proc_set_tty(struct task_struct *tsk, struct tty_struct *tty);
 
+#ifdef CONFIG_BT_WL1271
+/*
+ *	WL1271: Power enable sequence
+ */
+static int bt_init_power(void)
+{
+	int ret = 0;
+	u8 reg_value = 0;
+
+	/* Wl1271 Daughter card BT_EN is connected to T2-GPIO.13 */
+	/* Enable GPIO */
+	ret = twl_i2c_read_u8(TWL4030_MODULE_GPIO,
+				&reg_value, REG_GPIO_CTRL);
+	if (ret != 0)
+		goto err;
+	/* T2-GPIO.13 -> output */
+	ret = twl_i2c_read_u8(TWL4030_MODULE_GPIO,
+				&reg_value, REG_GPIODATADIR2);
+	if (ret != 0)
+		goto err;
+	reg_value |= 0x20;
+	ret = twl_i2c_write_u8(TWL4030_MODULE_GPIO,
+				reg_value, REG_GPIODATADIR2);
+	if (ret != 0)
+		goto err;
+	/* T2-GPIO.13 -> LOW */
+	ret = twl_i2c_read_u8(TWL4030_MODULE_GPIO,
+				&reg_value, REG_GPIODATAOUT2);
+	if (ret != 0)
+		goto err;
+	reg_value &= ~(0x20);
+	ret = twl_i2c_write_u8(TWL4030_MODULE_GPIO,
+				reg_value, REG_GPIODATAOUT2);
+	if (ret != 0)
+		goto err;
+
+	mdelay(50);
+	/* T2-GPIO.13 -> HIGH */
+	reg_value |= (0x20);
+	ret = twl_i2c_write_u8(TWL4030_MODULE_GPIO,
+				reg_value, REG_GPIODATAOUT2);
+	if (ret != 0)
+		goto err;
+
+	mdelay(50);
+	/* T2-GPIO.13 -> LOW */
+	reg_value &= ~(0x20);
+	ret = twl_i2c_write_u8(TWL4030_MODULE_GPIO,
+				reg_value, REG_GPIODATAOUT2);
+	if (ret != 0)
+		goto err;
+	printk(KERN_INFO "WL1271: BT_EN GPIO initialized\n");
+err:
+	return ret;
+} /* End of init_bt_power() */
+
+/*
+ *	WL1271: Set Bluetooth Enable
+ */
+static int tty_setbt_power(int __user *p)
+{
+	int power;
+	int err = 0;
+	u8 reg_value = 0;
+
+	if (get_user(power, p))
+		return -EFAULT;
+
+	printk(KERN_INFO "Set BT_EN of WL1271\n");
+	/* Power settings argument should either be 1 or 0 */
+	power = power ? 1 : 0;
+
+	if (power)
+		reg_value |= (0x20);
+	else
+		reg_value &= ~(0x20);
+
+	err = twl_i2c_write_u8(TWL4030_MODULE_GPIO,
+				reg_value, REG_GPIODATAOUT2);
+	if (err != 0) {
+		printk(KERN_DEBUG "WL1271: Set BT_EN failed %d %d\n",
+							err, power);
+	return err;
+	}
+	printk(KERN_INFO "WL1271: Powering %s\n", power ? "on" : "off");
+	return 0;
+} /* End of set_bt_power() */
+#endif
+
 /**
  *	alloc_tty_struct	-	allocate a tty object
  *
@@ -2571,6 +2671,11 @@ long tty_ioctl(struct file *file, unsigned int cmd, unsigned long arg)
 	case TIOCMBIC:
 	case TIOCMBIS:
 		return tty_tiocmset(tty, file, cmd, p);
+#ifdef CONFIG_BT_WL1271
+	/* Control BT_EN pin of Bluetooth-WL1271 */
+	case TIOSETWL1271POWER:
+		return tty_setbt_power(p);
+#endif
 	case TCFLSH:
 		switch (arg) {
 		case TCIFLUSH:
@@ -3142,6 +3247,11 @@ static int __init tty_init(void)
 #ifdef CONFIG_VT
 	vty_init(&console_fops);
 #endif
+
+#ifdef CONFIG_BT_WL1271
+	/* Initialize Bluetooth- WL1271chip connected to UART */
+	bt_init_power();
+#endif
 	return 0;
 }
 module_init(tty_init);
-- 
1.6.3.3

