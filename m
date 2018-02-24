Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtps.newmedia-net.de ([185.84.6.167]:60630 "EHLO
        webmail.newmedia-net.de" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1750826AbeBXPUJ (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Sat, 24 Feb 2018 10:20:09 -0500
From: s.gottschall@dd-wrt.com
To: linux-wireless@vger.kernel.org
Cc: kvalo@codeaurora.org, ath10k@lists.infradead.org,
        Sebastian Gottschall <s.gottschall@newmedia-net.de>,
        Sebastian Gottschall <s.gottschall@dd-wrt.com>
Subject: [PATCH v11] ath10k: add LED and GPIO controlling support for various chipsets
Date: Sat, 24 Feb 2018 16:20:01 +0100
Message-Id: <20180224152001.6887-1-s.gottschall@dd-wrt.com> (sfid-20180224_162013_754583_17A4E716)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Sebastian Gottschall <s.gottschall@newmedia-net.de>

Adds LED and GPIO Control support for 988x, 9887, 9888, 99x0, 9984 based chipsets with on chipset connected led's
using WMI Firmware API.
The LED device will get available named as "ath10k-phyX" at sysfs and can be controlled with various triggers.
adds also debugfs interface for gpio control.

Signed-off-by: Sebastian Gottschall <s.gottschall@dd-wrt.com>

v2  add correct gpio count per chipset and remove IPQ4019 support since this chipset does not make use of specific gpios)
v5  fix compiling without LED_CLASS and GPIOLIB support, fix also error by kbuild test robot which does not occur in standard builds. curious
v6  correct return values and fix comment style
v7  fix ath10k_unregister_led for compiling without LED_CLASS
v8  fix various code design issues reported by reviewers
v9  move led and led code to separate sourcefile (gpio.c)
v10 compile fix if gpiolib isnt included
v11 make register_cpio_chip static. advise by krobot
---
 drivers/net/wireless/ath/ath10k/Kconfig   |  10 ++
 drivers/net/wireless/ath/ath10k/Makefile  |   1 +
 drivers/net/wireless/ath/ath10k/core.c    |  28 ++++-
 drivers/net/wireless/ath/ath10k/core.h    |  62 +++++++++-
 drivers/net/wireless/ath/ath10k/debug.c   | 146 ++++++++++++++++++++++
 drivers/net/wireless/ath/ath10k/gpio.c    | 196 ++++++++++++++++++++++++++++++
 drivers/net/wireless/ath/ath10k/hw.h      |   2 +
 drivers/net/wireless/ath/ath10k/mac.c     |   5 +
 drivers/net/wireless/ath/ath10k/wmi-ops.h |  36 +++++-
 drivers/net/wireless/ath/ath10k/wmi-tlv.c |  65 ++++++++++
 drivers/net/wireless/ath/ath10k/wmi.c     |  46 +++++++
 drivers/net/wireless/ath/ath10k/wmi.h     |  36 ++++++
 12 files changed, 630 insertions(+), 3 deletions(-)
 create mode 100644 drivers/net/wireless/ath/ath10k/gpio.c

diff --git a/drivers/net/wireless/ath/ath10k/Kconfig b/drivers/net/wireless/ath/ath10k/Kconfig
index deb5ae21a559..5d61d499dca4 100644
--- a/drivers/net/wireless/ath/ath10k/Kconfig
+++ b/drivers/net/wireless/ath/ath10k/Kconfig
@@ -10,6 +10,16 @@ config ATH10K
 
           If you choose to build a module, it'll be called ath10k.
 
+config ATH10K_LEDS
+	bool "SoftLED Support"
+	depends on ATH10K
+	select MAC80211_LEDS
+	select LEDS_CLASS
+	select NEW_LEDS
+	default y
+	help
+	  This option is necessary, if you want LED support for chipset connected led pins
+
 config ATH10K_PCI
 	tristate "Atheros ath10k PCI support"
 	depends on ATH10K && PCI
diff --git a/drivers/net/wireless/ath/ath10k/Makefile b/drivers/net/wireless/ath/ath10k/Makefile
index 6739ac26fd29..eccc9806fa43 100644
--- a/drivers/net/wireless/ath/ath10k/Makefile
+++ b/drivers/net/wireless/ath/ath10k/Makefile
@@ -20,6 +20,7 @@ ath10k_core-$(CONFIG_NL80211_TESTMODE) += testmode.o
 ath10k_core-$(CONFIG_ATH10K_TRACING) += trace.o
 ath10k_core-$(CONFIG_THERMAL) += thermal.o
 ath10k_core-$(CONFIG_MAC80211_DEBUGFS) += debugfs_sta.o
+ath10k_core-$(CONFIG_ATH10K_LEDS) += gpio.o
 ath10k_core-$(CONFIG_PM) += wow.o
 ath10k_core-$(CONFIG_DEV_COREDUMP) += coredump.o
 
diff --git a/drivers/net/wireless/ath/ath10k/core.c b/drivers/net/wireless/ath/ath10k/core.c
index f3ec13b80b20..d7f89ca98c2d 100644
--- a/drivers/net/wireless/ath/ath10k/core.c
+++ b/drivers/net/wireless/ath/ath10k/core.c
@@ -21,6 +21,10 @@
 #include <linux/dmi.h>
 #include <linux/ctype.h>
 #include <asm/byteorder.h>
+#include <linux/leds.h>
+#include <linux/platform_device.h>
+#include <linux/version.h>
+
 
 #include "core.h"
 #include "mac.h"
@@ -65,6 +69,8 @@ static const struct ath10k_hw_params ath10k_hw_params_list[] = {
 		.id = QCA988X_HW_2_0_VERSION,
 		.dev_id = QCA988X_2_0_DEVICE_ID,
 		.name = "qca988x hw2.0",
+		.led_pin = 1,
+		.gpio_count = 24, 
 		.patch_load_addr = QCA988X_HW_2_0_PATCH_LOAD_ADDR,
 		.uart_pin = 7,
 		.cc_wraparound_type = ATH10K_HW_CC_WRAP_SHIFTED_ALL,
@@ -94,6 +100,8 @@ static const struct ath10k_hw_params ath10k_hw_params_list[] = {
 		.id = QCA988X_HW_2_0_VERSION,
 		.dev_id = QCA988X_2_0_DEVICE_ID_UBNT,
 		.name = "qca988x hw2.0 ubiquiti",
+		.led_pin = 1,
+		.gpio_count = 24, 
 		.patch_load_addr = QCA988X_HW_2_0_PATCH_LOAD_ADDR,
 		.uart_pin = 7,
 		.cc_wraparound_type = ATH10K_HW_CC_WRAP_SHIFTED_ALL,
@@ -123,6 +131,8 @@ static const struct ath10k_hw_params ath10k_hw_params_list[] = {
 		.id = QCA9887_HW_1_0_VERSION,
 		.dev_id = QCA9887_1_0_DEVICE_ID,
 		.name = "qca9887 hw1.0",
+		.led_pin = 1,
+		.gpio_count = 24, 
 		.patch_load_addr = QCA9887_HW_1_0_PATCH_LOAD_ADDR,
 		.uart_pin = 7,
 		.cc_wraparound_type = ATH10K_HW_CC_WRAP_SHIFTED_ALL,
@@ -267,6 +277,8 @@ static const struct ath10k_hw_params ath10k_hw_params_list[] = {
 		.id = QCA99X0_HW_2_0_DEV_VERSION,
 		.dev_id = QCA99X0_2_0_DEVICE_ID,
 		.name = "qca99x0 hw2.0",
+		.led_pin = 17,
+		.gpio_count = 35, 
 		.patch_load_addr = QCA99X0_HW_2_0_PATCH_LOAD_ADDR,
 		.uart_pin = 7,
 		.otp_exe_param = 0x00000700,
@@ -301,6 +313,8 @@ static const struct ath10k_hw_params ath10k_hw_params_list[] = {
 		.id = QCA9984_HW_1_0_DEV_VERSION,
 		.dev_id = QCA9984_1_0_DEVICE_ID,
 		.name = "qca9984/qca9994 hw1.0",
+		.led_pin = 17,
+		.gpio_count = 35, 
 		.patch_load_addr = QCA9984_HW_1_0_PATCH_LOAD_ADDR,
 		.uart_pin = 7,
 		.cc_wraparound_type = ATH10K_HW_CC_WRAP_SHIFTED_EACH,
@@ -340,6 +354,8 @@ static const struct ath10k_hw_params ath10k_hw_params_list[] = {
 		.id = QCA9888_HW_2_0_DEV_VERSION,
 		.dev_id = QCA9888_2_0_DEVICE_ID,
 		.name = "qca9888 hw2.0",
+		.led_pin = 17,
+		.gpio_count = 35, 
 		.patch_load_addr = QCA9888_HW_2_0_PATCH_LOAD_ADDR,
 		.uart_pin = 7,
 		.cc_wraparound_type = ATH10K_HW_CC_WRAP_SHIFTED_EACH,
@@ -2372,8 +2388,15 @@ int ath10k_core_start(struct ath10k *ar, enum ath10k_firmware_mode mode,
 	if (status)
 		goto err_hif_stop;
 
-	return 0;
+	
+	status = ath10k_attach_led(ar);
+	if (status)
+		goto err_no_led;
 
+	ath10k_attach_gpio(ar);
+
+err_no_led:	
+	return 0;
 err_hif_stop:
 	ath10k_hif_stop(ar);
 err_htt_rx_detach:
@@ -2673,6 +2696,9 @@ void ath10k_core_unregister(struct ath10k *ar)
 	ath10k_core_free_board_files(ar);
 
 	ath10k_debug_unregister(ar);
+
+	ath10k_unregister_gpio_chip(ar);
+	ath10k_unregister_led(ar);
 }
 EXPORT_SYMBOL(ath10k_core_unregister);
 
diff --git a/drivers/net/wireless/ath/ath10k/core.h b/drivers/net/wireless/ath/ath10k/core.h
index c624b96f8b84..f44ced4a4a57 100644
--- a/drivers/net/wireless/ath/ath10k/core.h
+++ b/drivers/net/wireless/ath/ath10k/core.h
@@ -25,6 +25,8 @@
 #include <linux/pci.h>
 #include <linux/uuid.h>
 #include <linux/time.h>
+#include <linux/gpio.h>
+#include <linux/leds.h>
 
 #include "htt.h"
 #include "htc.h"
@@ -812,6 +814,62 @@ struct ath10k_per_peer_tx_stats {
 	u32	reserved2;
 };
 
+struct ath10k_gpiocontrol {
+	struct ath10k *ar;
+
+	/* since we have no gpio read method, these are the state variables for debugfs.  */	
+	u32 gpio_set_num;
+	u32 gpio_num;
+	u32 gpio_input;
+	u32 gpio_pull_type;
+	u32 gpio_intr_mode;
+	u32 gpio_set; 
+
+#if IS_ENABLED(CONFIG_GPIOLIB)
+	struct gpio_chip gchip;
+#endif /* CONFIG_GPIOLIB */
+	struct gpio_led wifi_led;
+	struct led_classdev cdev;
+	char label[48];
+	u32 gpio_state_dir; /* same as for debugfs, but for gpiochip implementation */
+	u32 gpio_state_pin;
+};
+
+#if IS_ENABLED(CONFIG_ATH10K_LEDS)
+void ath10k_unregister_led(struct ath10k *ar);
+void ath10k_reset_led_pin(struct ath10k *ar);
+int ath10k_attach_led(struct ath10k *ar);
+#else
+static inline void ath10k_unregister_led(struct ath10k *ar)
+{
+
+}
+static inline void ath10k_reset_led_pin(struct ath10k *ar)
+{
+
+}
+static inline int ath10k_attach_led(struct ath10k *ar)
+{
+	return -ENODEV;
+}
+#endif
+
+#if IS_ENABLED(CONFIG_ATH10K_LEDS) && IS_ENABLED(CONFIG_GPIOLIB)
+static void ath10k_unregister_gpio_chip(struct ath10k *ar);
+#else
+static inline int ath10k_attach_gpio(struct ath10k *ar)
+{
+	return -ENODEV;
+}
+#endif
+#if IS_ENABLED(CONFIG_ATH10K_LEDS)
+int ath10k_attach_gpio(struct ath10k *ar);
+#else
+static inline void ath10k_unregister_gpio_chip(struct ath10k *ar) 
+{
+
+}
+#endif
 struct ath10k {
 	struct ath_common ath_common;
 	struct ieee80211_hw *hw;
@@ -840,7 +898,9 @@ struct ath10k {
 	u32 low_5ghz_chan;
 	u32 high_5ghz_chan;
 	bool ani_enabled;
-
+#if IS_ENABLED(CONFIG_ATH10K_LEDS)
+	struct ath10k_gpiocontrol *gpio;
+#endif
 	bool p2p;
 
 	struct {
diff --git a/drivers/net/wireless/ath/ath10k/debug.c b/drivers/net/wireless/ath/ath10k/debug.c
index 1b9c092d210f..a8baa7424633 100644
--- a/drivers/net/wireless/ath/ath10k/debug.c
+++ b/drivers/net/wireless/ath/ath10k/debug.c
@@ -1084,6 +1084,126 @@ static ssize_t ath10k_write_fw_dbglog(struct file *file,
 	return ret;
 }
 
+#if IS_ENABLED(CONFIG_ATH10K_LEDS)
+static ssize_t ath10k_read_gpio_config(struct file *file, char __user *user_buf,
+				      size_t count, loff_t *ppos)
+{
+	struct ath10k *ar = file->private_data;
+	struct ath10k_gpiocontrol *gpio = ar->gpio; 
+	size_t len;
+	char buf[96];
+	if (!gpio)
+		return 0;
+
+	len = scnprintf(buf, sizeof(buf), "%u %u %u %u\n", gpio->gpio_num, gpio->gpio_input, gpio->gpio_pull_type, gpio->gpio_intr_mode);
+
+	return simple_read_from_buffer(user_buf, count, ppos, buf, len);
+}
+
+
+static ssize_t ath10k_write_gpio_config(struct file *file,
+				      const char __user *user_buf,
+				      size_t count, loff_t *ppos)
+{
+	struct ath10k *ar = file->private_data;
+	struct ath10k_gpiocontrol *gpio = ar->gpio; 
+	int ret;
+	char buf[96];
+	u32 gpio_num, input, pull_type, intr_mode;
+	if (!gpio)
+		return -EINVAL;
+
+	simple_write_to_buffer(buf, sizeof(buf) - 1, ppos, user_buf, count);
+
+	/* make sure that buf is null terminated */
+	buf[sizeof(buf) - 1] = 0;
+
+	gpio->gpio_num = gpio_num;
+	gpio->gpio_input = input;
+	gpio->gpio_pull_type = pull_type;
+	gpio->gpio_intr_mode = intr_mode;
+	ret = sscanf(buf, "%u %u %u %u", &gpio_num, &input, &pull_type, &intr_mode);
+
+	if (!ret)
+		return -EINVAL;
+
+
+	mutex_lock(&ar->conf_mutex);
+
+
+	ret = ath10k_wmi_gpio_config(ar, gpio_num, input, pull_type, intr_mode);
+
+	if (ret) {
+		ath10k_warn(ar, "gpio_config cfg failed from debugfs: %d\n", ret);
+		goto exit;
+	}
+	ret = count;
+
+exit:
+	mutex_unlock(&ar->conf_mutex);
+
+	return ret;
+}
+
+static ssize_t ath10k_read_gpio_output(struct file *file, char __user *user_buf,
+				      size_t count, loff_t *ppos)
+{
+	struct ath10k *ar = file->private_data;
+	struct ath10k_gpiocontrol *gpio = ar->gpio; 
+	size_t len;
+	char buf[96];
+	if (!gpio)
+		return 0;
+
+	len = scnprintf(buf, sizeof(buf), "%u %u\n", gpio->gpio_num, gpio->gpio_set);
+
+	return simple_read_from_buffer(user_buf, count, ppos, buf, len);
+}
+
+
+static ssize_t ath10k_write_gpio_output(struct file *file,
+				      const char __user *user_buf,
+				      size_t count, loff_t *ppos)
+{
+	struct ath10k *ar = file->private_data;
+	struct ath10k_gpiocontrol *gpio = ar->gpio; 
+	int ret;
+	char buf[96];
+	u32 gpio_num, set;
+	if (!gpio)
+		return -EINVAL;
+
+	simple_write_to_buffer(buf, sizeof(buf) - 1, ppos, user_buf, count);
+
+	/* make sure that buf is null terminated */
+	buf[sizeof(buf) - 1] = 0;
+
+	gpio->gpio_set_num = gpio_num;
+	gpio->gpio_set = set;
+	ret = sscanf(buf, "%u %u", &gpio_num, &set);
+
+	if (!ret)
+		return -EINVAL;
+
+
+	mutex_lock(&ar->conf_mutex);
+
+
+	ret = ath10k_wmi_gpio_output(ar, gpio_num, set);
+
+	if (ret) {
+		ath10k_warn(ar, "gpio_output cfg failed from debugfs: %d\n", ret);
+		goto exit;
+	}
+	ret = count;
+
+exit:
+	mutex_unlock(&ar->conf_mutex);
+
+	return ret;
+}
+#endif
+
 /* TODO:  Would be nice to always support ethtool stats, would need to
  * move the stats storage out of ath10k_debug, or always have ath10k_debug
  * struct available..
@@ -1252,6 +1372,25 @@ static const struct file_operations fops_fw_dbglog = {
 	.llseek = default_llseek,
 };
 
+
+#if IS_ENABLED(CONFIG_ATH10K_LEDS)
+static const struct file_operations fops_gpio_output = {
+	.read = ath10k_read_gpio_output,
+	.write = ath10k_write_gpio_output,
+	.open = simple_open,
+	.owner = THIS_MODULE,
+	.llseek = default_llseek,
+};
+
+static const struct file_operations fops_gpio_config = {
+	.read = ath10k_read_gpio_config,
+	.write = ath10k_write_gpio_config,
+	.open = simple_open,
+	.owner = THIS_MODULE,
+	.llseek = default_llseek,
+};
+#endif
+
 static int ath10k_debug_cal_data_fetch(struct ath10k *ar)
 {
 	u32 hi_addr;
@@ -2259,6 +2398,13 @@ int ath10k_debug_register(struct ath10k *ar)
 	debugfs_create_file("fw_dbglog", 0600, ar->debug.debugfs_phy, ar,
 			    &fops_fw_dbglog);
 
+#if IS_ENABLED(CONFIG_ATH10K_LEDS)
+	debugfs_create_file("gpio_output", 0600, ar->debug.debugfs_phy, ar,
+			    &fops_gpio_output);
+
+	debugfs_create_file("gpio_config", 0600, ar->debug.debugfs_phy, ar,
+			    &fops_gpio_config);
+#endif
 	debugfs_create_file("cal_data", 0400, ar->debug.debugfs_phy, ar,
 			    &fops_cal_data);
 
diff --git a/drivers/net/wireless/ath/ath10k/gpio.c b/drivers/net/wireless/ath/ath10k/gpio.c
new file mode 100644
index 000000000000..e9ce44bb21b0
--- /dev/null
+++ b/drivers/net/wireless/ath/ath10k/gpio.c
@@ -0,0 +1,196 @@
+/*
+ * Copyright (c) 2005-2011 Atheros Communications Inc.
+ * Copyright (c) 2011-2017 Qualcomm Atheros, Inc.
+ * Copyright (c) 2018 Sebastian Gottschall <s.gottschall@dd-wrt.com>
+ *
+ * Permission to use, copy, modify, and/or distribute this software for any
+ * purpose with or without fee is hereby granted, provided that the above
+ * copyright notice and this permission notice appear in all copies.
+ *
+ * THE SOFTWARE IS PROVIDED "AS IS" AND THE AUTHOR DISCLAIMS ALL WARRANTIES
+ * WITH REGARD TO THIS SOFTWARE INCLUDING ALL IMPLIED WARRANTIES OF
+ * MERCHANTABILITY AND FITNESS. IN NO EVENT SHALL THE AUTHOR BE LIABLE FOR
+ * ANY SPECIAL, DIRECT, INDIRECT, OR CONSEQUENTIAL DAMAGES OR ANY DAMAGES
+ * WHATSOEVER RESULTING FROM LOSS OF USE, DATA OR PROFITS, WHETHER IN AN
+ * ACTION OF CONTRACT, NEGLIGENCE OR OTHER TORTIOUS ACTION, ARISING OUT OF
+ * OR IN CONNECTION WITH THE USE OR PERFORMANCE OF THIS SOFTWARE.
+ */
+
+
+#include <linux/module.h>
+#include <linux/firmware.h>
+#include <linux/of.h>
+#include <linux/dmi.h>
+#include <linux/ctype.h>
+#include <asm/byteorder.h>
+#include <linux/leds.h>
+#include <linux/platform_device.h>
+#include <linux/version.h>
+
+
+#include "core.h"
+#include "wmi.h"
+#include "wmi-ops.h"
+
+#if IS_ENABLED(CONFIG_GPIOLIB)
+static int ath10k_gpio_pin_cfg_input(struct gpio_chip *chip, unsigned offset)
+{
+	struct ath10k_gpiocontrol *gpio = container_of(chip, struct ath10k_gpiocontrol, gchip);
+	ath10k_wmi_gpio_config(gpio->ar, offset, 1, WMI_GPIO_PULL_NONE, WMI_GPIO_INTTYPE_DISABLE); /* configure to input */
+	gpio->gpio_state_dir = 1;
+	return 0;
+}
+
+/* gpio_chip handler : set GPIO to output */
+static int ath10k_gpio_pin_cfg_output(struct gpio_chip *chip, unsigned offset,
+				     int value)
+{
+	struct ath10k_gpiocontrol *gpio = container_of(chip, struct ath10k_gpiocontrol, gchip);
+
+	ath10k_wmi_gpio_config(gpio->ar, offset, 0, WMI_GPIO_PULL_NONE, WMI_GPIO_INTTYPE_DISABLE); /* configure to output */
+	ath10k_wmi_gpio_output(gpio->ar, offset, value);
+	gpio->gpio_state_dir = 0;
+	gpio->gpio_state_pin = value;
+	return 0;
+}
+
+/* gpio_chip handler : query GPIO direction (0=out, 1=in) */
+static int ath10k_gpio_pin_get_dir(struct gpio_chip *chip, unsigned offset)
+{
+	struct ath10k_gpiocontrol *gpio = container_of(chip, struct ath10k_gpiocontrol, gchip);
+
+	return gpio->gpio_state_dir;
+}
+
+/* gpio_chip handler : get GPIO pin value */
+static int ath10k_gpio_pin_get(struct gpio_chip *chip, unsigned offset)
+{
+	struct ath10k_gpiocontrol *gpio = container_of(chip, struct ath10k_gpiocontrol, gchip);
+
+	return gpio->gpio_state_pin;
+}
+
+/* gpio_chip handler : set GPIO pin to value */
+static void ath10k_gpio_pin_set(struct gpio_chip *chip, unsigned offset,
+			       int value)
+{
+	struct ath10k_gpiocontrol *gpio = container_of(chip, struct ath10k_gpiocontrol, gchip);
+
+	ath10k_wmi_gpio_output(gpio->ar, offset, value);
+	gpio->gpio_state_pin = value;
+}
+
+/* register GPIO chip */
+static int ath10k_register_gpio_chip(struct ath10k *ar)
+{
+ 
+	struct ath10k_gpiocontrol *gpio = ar->gpio;
+	if (!gpio) {
+		return -ENODEV;
+	}
+	gpio->gchip.parent = ar->dev;
+	gpio->gchip.base = -1;	/* determine base automatically */
+	gpio->gchip.ngpio = ar->hw_params.gpio_count;
+	gpio->gchip.label = gpio->label;
+	gpio->gchip.direction_input = ath10k_gpio_pin_cfg_input;
+	gpio->gchip.direction_output = ath10k_gpio_pin_cfg_output;
+	gpio->gchip.get_direction = ath10k_gpio_pin_get_dir;
+	gpio->gchip.get = ath10k_gpio_pin_get;
+	gpio->gchip.set = ath10k_gpio_pin_set;
+
+	if (gpiochip_add(&gpio->gchip)) {
+		dev_err(ar->dev, "Error while registering gpio chip\n");
+		return -ENODEV;
+	}
+	gpio->gchip.owner = NULL;
+	gpio->ar = ar;
+	return 0;
+}
+
+/* remove GPIO chip */
+void ath10k_unregister_gpio_chip(struct ath10k *ar)
+{
+	struct ath10k_gpiocontrol *gpio = ar->gpio; 
+	if (gpio) {
+		gpiochip_remove(&gpio->gchip);
+	}
+}
+
+int ath10k_attach_gpio(struct ath10k *ar)
+{
+	if (ar->hw_params.led_pin) { /* only attach if non zero since some chipsets are unsupported yet */
+		return ath10k_register_gpio_chip(ar);
+	}
+
+	return -ENODEV;
+}
+
+#endif
+
+
+static void ath10k_led_brightness(struct led_classdev *led_cdev,
+			       enum led_brightness brightness)
+{
+	struct ath10k_gpiocontrol *gpio = container_of(led_cdev, struct ath10k_gpiocontrol, cdev);
+	struct gpio_led *led = &gpio->wifi_led;
+	if (gpio->ar->state == ATH10K_STATE_ON) {
+		gpio->gpio_state_pin = (brightness != LED_OFF) ^ led->active_low;
+		ath10k_wmi_gpio_output(gpio->ar, led->gpio, gpio->gpio_state_pin);
+	}
+}
+
+static int ath10k_add_led(struct ath10k *ar, struct gpio_led *gpioled)
+{
+	int ret;
+	struct ath10k_gpiocontrol *gpio = ar->gpio; 
+	gpio->cdev.name = gpioled->name;
+	gpio->cdev.default_trigger = gpioled->default_trigger;
+	gpio->cdev.brightness_set = ath10k_led_brightness;
+
+	ret = led_classdev_register(wiphy_dev(ar->hw->wiphy), &gpio->cdev);
+	if (ret < 0)
+		return ret;
+
+	return 0;
+}
+
+void ath10k_unregister_led(struct ath10k *ar)
+{
+	struct ath10k_gpiocontrol *gpio = ar->gpio; 
+	if (gpio) {
+		led_classdev_unregister(&gpio->cdev);
+		kfree(gpio);
+	}
+}
+
+void ath10k_reset_led_pin(struct ath10k *ar) 
+{
+	/* need to reset gpio state */
+	if (ar->hw_params.led_pin) { 
+		ath10k_wmi_gpio_config(ar, ar->hw_params.led_pin, 0, WMI_GPIO_PULL_NONE, WMI_GPIO_INTTYPE_DISABLE);
+		ath10k_wmi_gpio_output(ar, ar->hw_params.led_pin, 1);
+	}
+}
+
+int ath10k_attach_led(struct ath10k *ar)
+{
+	struct ath10k_gpiocontrol *gpio;
+	if (ar->gpio) { /* already registered, ignore */
+		return -EINVAL;
+	}
+	gpio = kzalloc(sizeof(struct ath10k_gpiocontrol), GFP_KERNEL);
+	if (!gpio) {
+		return -ENOMEM;
+	}
+	ar->gpio = gpio;
+	snprintf(gpio->label, sizeof(gpio->label), "ath10k-%s",
+		 wiphy_name(ar->hw->wiphy));
+	gpio->wifi_led.active_low = 1;
+	gpio->wifi_led.gpio = ar->hw_params.led_pin;
+	gpio->wifi_led.name = gpio->label;
+	gpio->wifi_led.default_state = LEDS_GPIO_DEFSTATE_KEEP;
+		
+	ath10k_add_led(ar, &gpio->wifi_led);
+	ath10k_reset_led_pin(ar); /* initially we need to configure the led pin to output */
+	return 0;
+}		
diff --git a/drivers/net/wireless/ath/ath10k/hw.h b/drivers/net/wireless/ath/ath10k/hw.h
index 413b1b4321f7..af91d0202e45 100644
--- a/drivers/net/wireless/ath/ath10k/hw.h
+++ b/drivers/net/wireless/ath/ath10k/hw.h
@@ -495,6 +495,8 @@ struct ath10k_hw_params {
 	const char *name;
 	u32 patch_load_addr;
 	int uart_pin;
+	int led_pin; /* 1 for peregrine, 17 for beeliner */
+	int gpio_count; /* 24 for peregrine, 35 for beeliner */
 	u32 otp_exe_param;
 
 	/* Type of hw cycle counter wraparound logic, for more info
diff --git a/drivers/net/wireless/ath/ath10k/mac.c b/drivers/net/wireless/ath/ath10k/mac.c
index ebb3f1b046f3..6c4925dfcde9 100644
--- a/drivers/net/wireless/ath/ath10k/mac.c
+++ b/drivers/net/wireless/ath/ath10k/mac.c
@@ -4601,6 +4601,11 @@ static int ath10k_start(struct ieee80211_hw *hw)
 	switch (ar->state) {
 	case ATH10K_STATE_OFF:
 		ar->state = ATH10K_STATE_ON;
+		/* 
+		 * under some circumstances, the gpio pin gets reconfigured to default state by the firmware, so we need to reconfigure it
+		 * this behaviour has only ben seen on QCA9984 and QCA99XX devices so far
+		 */    
+		ath10k_reset_led_pin(ar); 
 		break;
 	case ATH10K_STATE_RESTARTING:
 		ar->state = ATH10K_STATE_RESTARTED;
diff --git a/drivers/net/wireless/ath/ath10k/wmi-ops.h b/drivers/net/wireless/ath/ath10k/wmi-ops.h
index 14093cfdc505..a38d6a8f7ec5 100644
--- a/drivers/net/wireless/ath/ath10k/wmi-ops.h
+++ b/drivers/net/wireless/ath/ath10k/wmi-ops.h
@@ -197,8 +197,13 @@ struct wmi_ops {
 					(struct ath10k *ar,
 					 enum wmi_bss_survey_req_type type);
 	struct sk_buff *(*gen_echo)(struct ath10k *ar, u32 value);
+
+	struct sk_buff *(*gen_gpio_config)(struct ath10k *ar, u32 gpio_num, u32 input, u32 pull_type, u32 intr_mode);
+
+	struct sk_buff *(*gen_gpio_output)(struct ath10k *ar, u32 gpio_num, u32 set);
 };
 
+
 int ath10k_wmi_cmd_send(struct ath10k *ar, struct sk_buff *skb, u32 cmd_id);
 
 static inline int
@@ -957,6 +962,35 @@ ath10k_wmi_force_fw_hang(struct ath10k *ar,
 
 	return ath10k_wmi_cmd_send(ar, skb, ar->wmi.cmd->force_fw_hang_cmdid);
 }
+static inline int 
+ath10k_wmi_gpio_config(struct ath10k *ar, u32 gpio_num, u32 input, u32 pull_type, u32 intr_mode)
+{
+	struct sk_buff *skb;
+
+	if (!ar->wmi.ops->gen_gpio_config)
+		return -EOPNOTSUPP;
+
+	skb = ar->wmi.ops->gen_gpio_config(ar, gpio_num, input, pull_type, intr_mode);
+	if (IS_ERR(skb))
+		return PTR_ERR(skb);
+
+	return ath10k_wmi_cmd_send_nowait(ar, skb, ar->wmi.cmd->gpio_config_cmdid);
+}
+
+static inline int 
+ath10k_wmi_gpio_output(struct ath10k *ar, u32 gpio_num, u32 set)
+{
+	struct sk_buff *skb;
+
+	if (!ar->wmi.ops->gen_gpio_config)
+		return -EOPNOTSUPP;
+
+	skb = ar->wmi.ops->gen_gpio_output(ar, gpio_num, set);
+	if (IS_ERR(skb))
+		return PTR_ERR(skb);
+
+	return ath10k_wmi_cmd_send_nowait(ar, skb, ar->wmi.cmd->gpio_output_cmdid);
+}
 
 static inline int
 ath10k_wmi_dbglog_cfg(struct ath10k *ar, u64 module_enable, u32 log_level)
@@ -1034,7 +1068,7 @@ ath10k_wmi_pdev_get_temperature(struct ath10k *ar)
 	if (IS_ERR(skb))
 		return PTR_ERR(skb);
 
-	return ath10k_wmi_cmd_send(ar, skb,
+	return ath10k_wmi_cmd_send_nowait(ar, skb,
 				   ar->wmi.cmd->pdev_get_temperature_cmdid);
 }
 
diff --git a/drivers/net/wireless/ath/ath10k/wmi-tlv.c b/drivers/net/wireless/ath/ath10k/wmi-tlv.c
index ae77a007ae07..2bfba63f1dcf 100644
--- a/drivers/net/wireless/ath/ath10k/wmi-tlv.c
+++ b/drivers/net/wireless/ath/ath10k/wmi-tlv.c
@@ -3250,6 +3250,69 @@ ath10k_wmi_tlv_op_gen_echo(struct ath10k *ar, u32 value)
 	return skb;
 }
 
+static struct sk_buff *
+ath10k_wmi_tlv_op_gen_gpio_config(struct ath10k *ar, u32 gpio_num, u32 input, u32 pull_type, u32 intr_mode)
+{
+    struct wmi_gpio_config_cmd *cmd;
+    struct wmi_tlv *tlv;
+    struct sk_buff *skb;
+    void *ptr; 
+    size_t len;
+
+    len = sizeof(*tlv) + sizeof(*cmd);
+    skb = ath10k_wmi_alloc_skb(ar, len);
+    if (!skb)
+	return ERR_PTR(-ENOMEM);
+
+    ptr = (void *)skb->data;
+    tlv = ptr;
+    tlv->tag = __cpu_to_le16(WMI_TLV_TAG_STRUCT_GPIO_CONFIG_CMD);
+    tlv->len = __cpu_to_le16(sizeof(*cmd));
+
+    cmd = (struct wmi_gpio_config_cmd *)skb->data;
+    cmd->pull_type = __cpu_to_le32(pull_type);
+    cmd->gpio_num = __cpu_to_le32(gpio_num);
+    cmd->input = __cpu_to_le32(input);
+    cmd->intr_mode = __cpu_to_le32(intr_mode);
+
+    ptr += sizeof(*tlv);
+    ptr += sizeof(*cmd);
+
+    ath10k_dbg(ar, ATH10K_DBG_WMI, "wmi tlv gpio_config gpio_num 0x%08x input 0x%08x pull_type 0x%08x intr_mode 0x%08x\n", gpio_num, input, pull_type, intr_mode);
+    return skb;
+}
+
+static struct sk_buff *
+ath10k_wmi_tlv_op_gen_gpio_output(struct ath10k *ar, u32 gpio_num, u32 set)
+{
+    struct wmi_gpio_output_cmd *cmd;
+    struct wmi_tlv *tlv;
+    struct sk_buff *skb;
+    void *ptr; 
+    size_t len;
+
+    len = sizeof(*tlv) + sizeof(*cmd);
+    skb = ath10k_wmi_alloc_skb(ar, len);
+    if (!skb)
+	return ERR_PTR(-ENOMEM);
+
+    ptr = (void *)skb->data;
+    tlv = ptr;
+    tlv->tag = __cpu_to_le16(WMI_TLV_TAG_STRUCT_GPIO_OUTPUT_CMD);
+    tlv->len = __cpu_to_le16(sizeof(*cmd));
+
+    cmd = (struct wmi_gpio_output_cmd *)skb->data;
+    cmd->gpio_num = __cpu_to_le32(gpio_num);
+    cmd->set = __cpu_to_le32(set);
+
+    ptr += sizeof(*tlv);
+    ptr += sizeof(*cmd);
+
+    ath10k_dbg(ar, ATH10K_DBG_WMI, "wmi tlv gpio_output gpio_num 0x%08x set 0x%08x\n", gpio_num, set);
+    return skb;
+}
+
+
 static struct sk_buff *
 ath10k_wmi_tlv_op_gen_vdev_spectral_conf(struct ath10k *ar,
 					 const struct wmi_vdev_spectral_conf_arg *arg)
@@ -3727,6 +3790,8 @@ static const struct wmi_ops wmi_tlv_ops = {
 	.fw_stats_fill = ath10k_wmi_main_op_fw_stats_fill,
 	.get_vdev_subtype = ath10k_wmi_op_get_vdev_subtype,
 	.gen_echo = ath10k_wmi_tlv_op_gen_echo,
+	.gen_gpio_config = ath10k_wmi_tlv_op_gen_gpio_config,
+	.gen_gpio_output = ath10k_wmi_tlv_op_gen_gpio_output,
 	.gen_vdev_spectral_conf = ath10k_wmi_tlv_op_gen_vdev_spectral_conf,
 	.gen_vdev_spectral_enable = ath10k_wmi_tlv_op_gen_vdev_spectral_enable,
 };
diff --git a/drivers/net/wireless/ath/ath10k/wmi.c b/drivers/net/wireless/ath/ath10k/wmi.c
index 58dc2189ba49..b56e5a673a8c 100644
--- a/drivers/net/wireless/ath/ath10k/wmi.c
+++ b/drivers/net/wireless/ath/ath10k/wmi.c
@@ -6646,6 +6646,41 @@ ath10k_wmi_op_gen_peer_set_param(struct ath10k *ar, u32 vdev_id,
 	return skb;
 }
 
+static struct sk_buff *
+ath10k_wmi_op_gen_gpio_config(struct ath10k *ar, u32 gpio_num, u32 input, u32 pull_type, u32 intr_mode)
+{
+    struct wmi_gpio_config_cmd *cmd;
+    struct sk_buff *skb;
+
+    skb = ath10k_wmi_alloc_skb(ar, sizeof(*cmd));
+    if (!skb)
+	return ERR_PTR(-ENOMEM);
+    cmd = (struct wmi_gpio_config_cmd *)skb->data;
+    cmd->pull_type = __cpu_to_le32(pull_type);
+    cmd->gpio_num = __cpu_to_le32(gpio_num);
+    cmd->input = __cpu_to_le32(input);
+    cmd->intr_mode = __cpu_to_le32(intr_mode);
+
+    ath10k_dbg(ar, ATH10K_DBG_WMI, "wmi gpio_config gpio_num 0x%08x input 0x%08x pull_type 0x%08x intr_mode 0x%08x\n", gpio_num, input, pull_type, intr_mode);
+    return skb;
+}
+
+static struct sk_buff *
+ath10k_wmi_op_gen_gpio_output(struct ath10k *ar, u32 gpio_num, u32 set)
+{
+    struct wmi_gpio_output_cmd *cmd;
+    struct sk_buff *skb;
+
+    skb = ath10k_wmi_alloc_skb(ar, sizeof(*cmd));
+    if (!skb)
+	return ERR_PTR(-ENOMEM);
+    cmd = (struct wmi_gpio_output_cmd *)skb->data;
+    cmd->gpio_num = __cpu_to_le32(gpio_num);
+    cmd->set = __cpu_to_le32(set);
+    ath10k_dbg(ar, ATH10K_DBG_WMI, "wmi gpio_output gpio_num 0x%08x set 0x%08x\n", gpio_num, set);
+    return skb;
+}
+
 static struct sk_buff *
 ath10k_wmi_op_gen_set_psmode(struct ath10k *ar, u32 vdev_id,
 			     enum wmi_sta_ps_mode psmode)
@@ -8153,6 +8188,9 @@ static const struct wmi_ops wmi_ops = {
 	.fw_stats_fill = ath10k_wmi_main_op_fw_stats_fill,
 	.get_vdev_subtype = ath10k_wmi_op_get_vdev_subtype,
 	.gen_echo = ath10k_wmi_op_gen_echo,
+	.gen_gpio_config = ath10k_wmi_op_gen_gpio_config,
+	.gen_gpio_output = ath10k_wmi_op_gen_gpio_output,
+	
 	/* .gen_bcn_tmpl not implemented */
 	/* .gen_prb_tmpl not implemented */
 	/* .gen_p2p_go_bcn_ie not implemented */
@@ -8223,6 +8261,8 @@ static const struct wmi_ops wmi_10_1_ops = {
 	.fw_stats_fill = ath10k_wmi_10x_op_fw_stats_fill,
 	.get_vdev_subtype = ath10k_wmi_op_get_vdev_subtype,
 	.gen_echo = ath10k_wmi_op_gen_echo,
+	.gen_gpio_config = ath10k_wmi_op_gen_gpio_config,
+	.gen_gpio_output = ath10k_wmi_op_gen_gpio_output,
 	/* .gen_bcn_tmpl not implemented */
 	/* .gen_prb_tmpl not implemented */
 	/* .gen_p2p_go_bcn_ie not implemented */
@@ -8294,6 +8334,8 @@ static const struct wmi_ops wmi_10_2_ops = {
 	.gen_delba_send = ath10k_wmi_op_gen_delba_send,
 	.fw_stats_fill = ath10k_wmi_10x_op_fw_stats_fill,
 	.get_vdev_subtype = ath10k_wmi_op_get_vdev_subtype,
+	.gen_gpio_config = ath10k_wmi_op_gen_gpio_config,
+	.gen_gpio_output = ath10k_wmi_op_gen_gpio_output,
 	/* .gen_pdev_enable_adaptive_cca not implemented */
 };
 
@@ -8364,6 +8406,8 @@ static const struct wmi_ops wmi_10_2_4_ops = {
 	.gen_pdev_enable_adaptive_cca =
 		ath10k_wmi_op_gen_pdev_enable_adaptive_cca,
 	.get_vdev_subtype = ath10k_wmi_10_2_4_op_get_vdev_subtype,
+	.gen_gpio_config = ath10k_wmi_op_gen_gpio_config,
+	.gen_gpio_output = ath10k_wmi_op_gen_gpio_output,
 	/* .gen_bcn_tmpl not implemented */
 	/* .gen_prb_tmpl not implemented */
 	/* .gen_p2p_go_bcn_ie not implemented */
@@ -8439,6 +8483,8 @@ static const struct wmi_ops wmi_10_4_ops = {
 	.gen_pdev_bss_chan_info_req = ath10k_wmi_10_2_op_gen_pdev_bss_chan_info,
 	.gen_echo = ath10k_wmi_op_gen_echo,
 	.gen_pdev_get_tpc_config = ath10k_wmi_10_2_4_op_gen_pdev_get_tpc_config,
+	.gen_gpio_config = ath10k_wmi_op_gen_gpio_config,
+	.gen_gpio_output = ath10k_wmi_op_gen_gpio_output,
 };
 
 int ath10k_wmi_attach(struct ath10k *ar)
diff --git a/drivers/net/wireless/ath/ath10k/wmi.h b/drivers/net/wireless/ath/ath10k/wmi.h
index c7b30ed9015d..dc180a86dc3b 100644
--- a/drivers/net/wireless/ath/ath10k/wmi.h
+++ b/drivers/net/wireless/ath/ath10k/wmi.h
@@ -2906,6 +2906,42 @@ enum wmi_10_4_feature_mask {
 
 };
 
+/* WMI_GPIO_CONFIG_CMDID */
+enum {
+    WMI_GPIO_PULL_NONE,
+    WMI_GPIO_PULL_UP,
+    WMI_GPIO_PULL_DOWN,
+};
+
+enum {
+    WMI_GPIO_INTTYPE_DISABLE,
+    WMI_GPIO_INTTYPE_RISING_EDGE,
+    WMI_GPIO_INTTYPE_FALLING_EDGE,
+    WMI_GPIO_INTTYPE_BOTH_EDGE,
+    WMI_GPIO_INTTYPE_LEVEL_LOW,
+    WMI_GPIO_INTTYPE_LEVEL_HIGH
+};
+
+/* WMI_GPIO_CONFIG_CMDID */
+struct wmi_gpio_config_cmd {
+    __le32 gpio_num;             /* GPIO number to be setup */
+    __le32 input;                /* 0 - Output/ 1 - Input */
+    __le32 pull_type;            /* Pull type defined above */
+    __le32 intr_mode;            /* Interrupt mode defined above (Input) */
+} __packed;
+
+/* WMI_GPIO_OUTPUT_CMDID */
+struct wmi_gpio_output_cmd {
+    __le32 gpio_num;    /* GPIO number to be setup */
+    __le32 set;         /* Set the GPIO pin*/
+} __packed;
+
+/* WMI_GPIO_INPUT_EVENTID */
+struct wmi_gpio_input_event {
+    __le32 gpio_num;    /* GPIO number which changed state */
+} __packed;
+
+
 struct wmi_ext_resource_config_10_4_cmd {
 	/* contains enum wmi_host_platform_type */
 	__le32 host_platform_config;
-- 
2.14.1
