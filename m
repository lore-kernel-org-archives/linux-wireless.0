Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtps.newmedia-net.de ([185.84.6.167]:59271 "EHLO
        webmail.newmedia-net.de" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1033103AbeBOOqu (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 15 Feb 2018 09:46:50 -0500
To: linux-wireless@vger.kernel.org
From: Sebastian Gottschall <s.gottschall@dd-wrt.com>
Subject: [PATCH 1/1] ath10k: add LED and GPIO controlling support for various
 chipsets
Message-ID: <3252acc4-45de-fa5d-256a-bd10b6577431@dd-wrt.com> (sfid-20180215_154654_357441_DDAD0A68)
Date: Thu, 15 Feb 2018 15:46:47 +0100
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Adds LED and GPIO Control support for 988x, 9887, 9888, 99x0, 9984 and 
ipq4019 based chipsets with on chipset connected led's
using WMI Firmware API.
The LED device will get available named as "ath10k-phyX" at sysfs and 
can be controlled with various triggers.
adds also debugfs interface for gpio control.

Signed-off-by: Sebastian Gottschall <s.gottschall@dd-wrt.com>

  drivers/net/wireless/ath/ath10k/core.c    | 168 
+++++++++++++++++++++++++++++-
  drivers/net/wireless/ath/ath10k/core.h    |  15 +++
  drivers/net/wireless/ath/ath10k/debug.c   | 140 +++++++++++++++++++++++++
  drivers/net/wireless/ath/ath10k/hw.h      |   1 +
  drivers/net/wireless/ath/ath10k/wmi-ops.h |  36 ++++++-
  drivers/net/wireless/ath/ath10k/wmi.c     |  43 ++++++++
  drivers/net/wireless/ath/ath10k/wmi.h     |  36 +++++++
  7 files changed, 436 insertions(+), 3 deletions(-)

diff --git a/drivers/net/wireless/ath/ath10k/core.c 
b/drivers/net/wireless/ath/ath10k/core.c
index f3ec13b80b20..b712bf09ad6f 100644
--- a/drivers/net/wireless/ath/ath10k/core.c
+++ b/drivers/net/wireless/ath/ath10k/core.c
@@ -21,6 +21,9 @@
  #include <linux/dmi.h>
  #include <linux/ctype.h>
  #include <asm/byteorder.h>
+#include <linux/leds.h>
+#include <linux/platform_device.h>
+

  #include "core.h"
  #include "mac.h"
@@ -65,6 +68,7 @@ static const struct ath10k_hw_params 
ath10k_hw_params_list[] = {
          .id = QCA988X_HW_2_0_VERSION,
          .dev_id = QCA988X_2_0_DEVICE_ID,
          .name = "qca988x hw2.0",
+        .led_pin = 1,
          .patch_load_addr = QCA988X_HW_2_0_PATCH_LOAD_ADDR,
          .uart_pin = 7,
          .cc_wraparound_type = ATH10K_HW_CC_WRAP_SHIFTED_ALL,
@@ -94,6 +98,7 @@ static const struct ath10k_hw_params 
ath10k_hw_params_list[] = {
          .id = QCA988X_HW_2_0_VERSION,
          .dev_id = QCA988X_2_0_DEVICE_ID_UBNT,
          .name = "qca988x hw2.0 ubiquiti",
+        .led_pin = 1,
          .patch_load_addr = QCA988X_HW_2_0_PATCH_LOAD_ADDR,
          .uart_pin = 7,
          .cc_wraparound_type = ATH10K_HW_CC_WRAP_SHIFTED_ALL,
@@ -123,6 +128,7 @@ static const struct ath10k_hw_params 
ath10k_hw_params_list[] = {
          .id = QCA9887_HW_1_0_VERSION,
          .dev_id = QCA9887_1_0_DEVICE_ID,
          .name = "qca9887 hw1.0",
+        .led_pin = 1,
          .patch_load_addr = QCA9887_HW_1_0_PATCH_LOAD_ADDR,
          .uart_pin = 7,
          .cc_wraparound_type = ATH10K_HW_CC_WRAP_SHIFTED_ALL,
@@ -267,6 +273,7 @@ static const struct ath10k_hw_params 
ath10k_hw_params_list[] = {
          .id = QCA99X0_HW_2_0_DEV_VERSION,
          .dev_id = QCA99X0_2_0_DEVICE_ID,
          .name = "qca99x0 hw2.0",
+        .led_pin = 17,
          .patch_load_addr = QCA99X0_HW_2_0_PATCH_LOAD_ADDR,
          .uart_pin = 7,
          .otp_exe_param = 0x00000700,
@@ -301,6 +308,7 @@ static const struct ath10k_hw_params 
ath10k_hw_params_list[] = {
          .id = QCA9984_HW_1_0_DEV_VERSION,
          .dev_id = QCA9984_1_0_DEVICE_ID,
          .name = "qca9984/qca9994 hw1.0",
+        .led_pin = 17,
          .patch_load_addr = QCA9984_HW_1_0_PATCH_LOAD_ADDR,
          .uart_pin = 7,
          .cc_wraparound_type = ATH10K_HW_CC_WRAP_SHIFTED_EACH,
@@ -340,6 +348,7 @@ static const struct ath10k_hw_params 
ath10k_hw_params_list[] = {
          .id = QCA9888_HW_2_0_DEV_VERSION,
          .dev_id = QCA9888_2_0_DEVICE_ID,
          .name = "qca9888 hw2.0",
+        .led_pin = 17,
          .patch_load_addr = QCA9888_HW_2_0_PATCH_LOAD_ADDR,
          .uart_pin = 7,
          .cc_wraparound_type = ATH10K_HW_CC_WRAP_SHIFTED_EACH,
@@ -436,6 +445,7 @@ static const struct ath10k_hw_params 
ath10k_hw_params_list[] = {
          .id = QCA4019_HW_1_0_DEV_VERSION,
          .dev_id = 0,
          .name = "qca4019 hw1.0",
+        .led_pin = 58,
          .patch_load_addr = QCA4019_HW_1_0_PATCH_LOAD_ADDR,
          .uart_pin = 7,
          .cc_wraparound_type = ATH10K_HW_CC_WRAP_SHIFTED_EACH,
@@ -2132,12 +2142,143 @@ static int ath10k_core_reset_rx_filter(struct 
ath10k *ar)
      return 0;
  }

+static int ath10k_gpio_pin_cfg_input(struct gpio_chip *chip, unsigned 
offset)
+{
+    struct ath10k_gpiocontrol *gpio = container_of(chip, struct 
ath10k_gpiocontrol, gchip);
+    ath10k_wmi_gpio_config(gpio->ar, offset, 1, WMI_GPIO_PULL_NONE, 
WMI_GPIO_INTTYPE_DISABLE); // configure to input
+    gpio->gpio_state_dir = 1;
+    return 0;
+}
+
+/* gpio_chip handler : set GPIO to output */
+static int ath10k_gpio_pin_cfg_output(struct gpio_chip *chip, unsigned 
offset,
+                     int value)
+{
+    struct ath10k_gpiocontrol *gpio = container_of(chip, struct 
ath10k_gpiocontrol, gchip);
+
+    ath10k_wmi_gpio_config(gpio->ar, offset, 0, WMI_GPIO_PULL_NONE, 
WMI_GPIO_INTTYPE_DISABLE); // configure to output
+    ath10k_wmi_gpio_output(gpio->ar, offset, value);
+    gpio->gpio_state_dir = 0;
+    gpio->gpio_state_pin = value;
+    return 0;
+}
+
+/* gpio_chip handler : query GPIO direction (0=out, 1=in) */
+static int ath10k_gpio_pin_get_dir(struct gpio_chip *chip, unsigned 
offset)
+{
+    struct ath10k_gpiocontrol *gpio = container_of(chip, struct 
ath10k_gpiocontrol, gchip);
+
+    return gpio->gpio_state_dir;
+}
+
+/* gpio_chip handler : get GPIO pin value */
+static int ath10k_gpio_pin_get(struct gpio_chip *chip, unsigned offset)
+{
+    struct ath10k_gpiocontrol *gpio = container_of(chip, struct 
ath10k_gpiocontrol, gchip);
+
+    return gpio->gpio_state_pin;
+}
+
+/* gpio_chip handler : set GPIO pin to value */
+static void ath10k_gpio_pin_set(struct gpio_chip *chip, unsigned offset,
+                   int value)
+{
+    struct ath10k_gpiocontrol *gpio = container_of(chip, struct 
ath10k_gpiocontrol, gchip);
+
+    ath10k_wmi_gpio_output(gpio->ar, offset, value);
+    gpio->gpio_state_pin = value;
+}
+
+/* register GPIO chip */
+static int ath10k_register_gpio_chip(struct ath10k *ar)
+{
+    struct ath10k_gpiocontrol *gpio;
+    gpio = kzalloc(sizeof(struct ath10k_gpiocontrol), GFP_KERNEL);
+    if (!gpio) {
+        return -1;
+    }
+
+    snprintf(gpio->label, sizeof(gpio->label), "ath10k-%s",
+         wiphy_name(ar->hw->wiphy));
+#if LINUX_VERSION_CODE >= KERNEL_VERSION(4,5,0)
+    gpio->gchip.parent = ar->dev;
+#else
+    gpio->gchip.dev = ar->dev;
+#endif
+    gpio->gchip.base = -1;    /* determine base automatically */
+    gpio->gchip.ngpio = 32;
+    gpio->gchip.label = gpio->label;
+    gpio->gchip.direction_input = ath10k_gpio_pin_cfg_input;
+    gpio->gchip.direction_output = ath10k_gpio_pin_cfg_output;
+    gpio->gchip.get_direction = ath10k_gpio_pin_get_dir;
+    gpio->gchip.get = ath10k_gpio_pin_get;
+    gpio->gchip.set = ath10k_gpio_pin_set;
+
+    if (gpiochip_add(&gpio->gchip)) {
+        printk(KERN_ERR "Error while registering gpio chip\n");
+        return -1;
+    }
+    gpio->gchip.owner = NULL;
+    ar->gpio = gpio;
+    gpio->ar = ar;
+    return 0;
+}
+
+/* remove GPIO chip */
+static void ath10k_unregister_gpio_chip(struct ath10k *ar)
+{
+    struct ath10k_gpiocontrol *gpio = ar->gpio;
+    if (gpio)
+        gpiochip_remove(&gpio->gchip);
+}
+
+static void ath10k_led_brightness(struct led_classdev *led_cdev,
+                   enum led_brightness brightness)
+{
+    struct ath10k_gpiocontrol *gpio = container_of(led_cdev, struct 
ath10k_gpiocontrol, cdev);
+    struct gpio_led *led = &gpio->wifi_led;
+    if (gpio->ar->state == ATH10K_STATE_ON) {
+        gpio->gpio_state_pin = (brightness != LED_OFF) ^ led->active_low;
+        ath10k_wmi_gpio_output(gpio->ar, led->gpio, gpio->gpio_state_pin);
+    }
+}
+
+static int ath10k_add_led(struct ath10k *ar, struct gpio_led *gpioled)
+{
+    int ret;
+    struct ath10k_gpiocontrol *gpio = ar->gpio;
+    if (!gpio)
+        return -1;
+    gpio->cdev.name = gpioled->name;
+    gpio->cdev.default_trigger = gpioled->default_trigger;
+    gpio->cdev.brightness_set = ath10k_led_brightness;
+
+    ret = led_classdev_register(wiphy_dev(ar->hw->wiphy), &gpio->cdev);
+    if (ret < 0)
+        return ret;
+
+    ath10k_wmi_gpio_config(ar, gpioled->gpio, 0, WMI_GPIO_PULL_NONE, 
WMI_GPIO_INTTYPE_DISABLE); // configure to output
+
+    /* Set default LED state */
+    if (gpioled->default_state == LEDS_GPIO_DEFSTATE_ON)
+        ath10k_wmi_gpio_output(ar, gpioled->gpio, !gpioled->active_low);
+    else
+        ath10k_wmi_gpio_output(ar, gpioled->gpio, gpioled->active_low);
+
+    return 0;
+}
+
+static void ath10k_unregister_led(struct ath10k *ar)
+{
+    if (ar->gpio)
+        led_classdev_unregister(&ar->gpio->cdev);
+}
+
  int ath10k_core_start(struct ath10k *ar, enum ath10k_firmware_mode mode,
                const struct ath10k_fw_components *fw)
  {
      int status;
      u32 val;
-
      lockdep_assert_held(&ar->conf_mutex);

      clear_bit(ATH10K_FLAG_CRASH_FLUSH, &ar->dev_flags);
@@ -2372,8 +2513,28 @@ int ath10k_core_start(struct ath10k *ar, enum 
ath10k_firmware_mode mode,
      if (status)
          goto err_hif_stop;

-    return 0;
+/* LED Code */
+    if (ar->hw_params.led_pin) { // only configure if non zero
+        if (!ar->gpio_attached) {
+            status = ath10k_register_gpio_chip(ar);
+            if (status) {
+                goto err_no_led;
+            }
+            ar->gpio_attached = 1;
+            ar->gpio->wifi_led.active_low = 1;
+            ar->gpio->wifi_led.gpio = ar->hw_params.led_pin;
+            ar->gpio->wifi_led.name = ar->gpio->label;
+            ar->gpio->wifi_led.default_state = LEDS_GPIO_DEFSTATE_KEEP;
+
+            ath10k_add_led(ar, &ar->gpio->wifi_led);
+        }
+        ath10k_wmi_gpio_config(ar, ar->hw_params.led_pin, 0, 
WMI_GPIO_PULL_NONE, WMI_GPIO_INTTYPE_DISABLE); // configure to output
+        ath10k_wmi_gpio_output(ar, ar->hw_params.led_pin, 1);
+    }

+err_no_led:;
+
+    return 0;
  err_hif_stop:
      ath10k_hif_stop(ar);
  err_htt_rx_detach:
@@ -2673,6 +2834,9 @@ void ath10k_core_unregister(struct ath10k *ar)
      ath10k_core_free_board_files(ar);

      ath10k_debug_unregister(ar);
+
+    ath10k_unregister_led(ar);
+    ath10k_unregister_gpio_chip(ar);
  }
  EXPORT_SYMBOL(ath10k_core_unregister);

diff --git a/drivers/net/wireless/ath/ath10k/core.h 
b/drivers/net/wireless/ath/ath10k/core.h
index c624b96f8b84..c289deb09cd9 100644
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
@@ -812,6 +814,17 @@ struct ath10k_per_peer_tx_stats {
      u32    reserved2;
  };

+struct ath10k_gpiocontrol {
+    struct ath10k *ar;
+    u32 gpio_set_num, gpio_num, gpio_input, gpio_pull_type, 
gpio_intr_mode, gpio_set; /* since we have no gpio read method, these 
are the state variables for debugfs.  */
+    struct gpio_led wifi_led;
+    struct gpio_chip gchip;
+    struct led_classdev cdev;
+    char label[48];
+    u32 gpio_state_dir; /* same as for debugfs, but for gpiochip 
implementation */
+    u32 gpio_state_pin;
+};
+
  struct ath10k {
      struct ath_common ath_common;
      struct ieee80211_hw *hw;
@@ -840,6 +853,8 @@ struct ath10k {
      u32 low_5ghz_chan;
      u32 high_5ghz_chan;
      bool ani_enabled;
+    struct ath10k_gpiocontrol *gpio;
+    int gpio_attached;

      bool p2p;

diff --git a/drivers/net/wireless/ath/ath10k/debug.c 
b/drivers/net/wireless/ath/ath10k/debug.c
index 1b9c092d210f..6253acec7ee1 100644
--- a/drivers/net/wireless/ath/ath10k/debug.c
+++ b/drivers/net/wireless/ath/ath10k/debug.c
@@ -1084,6 +1084,122 @@ static ssize_t ath10k_write_fw_dbglog(struct 
file *file,
      return ret;
  }

+
+static ssize_t ath10k_read_gpio_config(struct file *file, char __user 
*user_buf,
+                      size_t count, loff_t *ppos)
+{
+    struct ath10k *ar = file->private_data;
+    struct ath10k_gpiocontrol *gpio = ar->gpio;
+    size_t len;
+    char buf[96];
+
+    len = scnprintf(buf, sizeof(buf), "%u %u %u %u\n", gpio->gpio_num, 
gpio->gpio_input, gpio->gpio_pull_type, gpio->gpio_intr_mode);
+
+    return simple_read_from_buffer(user_buf, count, ppos, buf, len);
+}
+
+
+static ssize_t ath10k_write_gpio_config(struct file *file,
+                      const char __user *user_buf,
+                      size_t count, loff_t *ppos)
+{
+    struct ath10k *ar = file->private_data;
+    struct ath10k_gpiocontrol *gpio = ar->gpio;
+    int ret;
+    char buf[96];
+    u32 gpio_num, input, pull_type, intr_mode;
+
+    simple_write_to_buffer(buf, sizeof(buf) - 1, ppos, user_buf, count);
+
+    /* make sure that buf is null terminated */
+    buf[sizeof(buf) - 1] = 0;
+
+    gpio->gpio_num = gpio_num;
+    gpio->gpio_input = input;
+    gpio->gpio_pull_type = pull_type;
+    gpio->gpio_intr_mode = intr_mode;
+    ret = sscanf(buf, "%u %u %u %u", &gpio_num, &input, &pull_type, 
&intr_mode);
+
+    if (!ret)
+        return -EINVAL;
+
+
+    mutex_lock(&ar->conf_mutex);
+
+
+    ret = ath10k_wmi_gpio_config(ar, gpio_num, input, pull_type, 
intr_mode);
+
+    if (ret) {
+        ath10k_warn(ar, "gpio_config cfg failed from debugfs: %d\n", ret);
+        goto exit;
+    }
+    ret = count;
+
+exit:
+    mutex_unlock(&ar->conf_mutex);
+
+    return ret;
+}
+
+static ssize_t ath10k_read_gpio_output(struct file *file, char __user 
*user_buf,
+                      size_t count, loff_t *ppos)
+{
+    struct ath10k *ar = file->private_data;
+    struct ath10k_gpiocontrol *gpio = ar->gpio;
+
+    size_t len;
+    char buf[96];
+
+    len = scnprintf(buf, sizeof(buf), "%u %u\n", gpio->gpio_num, 
gpio->gpio_set);
+
+    return simple_read_from_buffer(user_buf, count, ppos, buf, len);
+}
+
+
+static ssize_t ath10k_write_gpio_output(struct file *file,
+                      const char __user *user_buf,
+                      size_t count, loff_t *ppos)
+{
+    struct ath10k *ar = file->private_data;
+    struct ath10k_gpiocontrol *gpio = ar->gpio;
+
+    int ret;
+    char buf[96];
+    u32 gpio_num, set;
+
+    simple_write_to_buffer(buf, sizeof(buf) - 1, ppos, user_buf, count);
+
+    /* make sure that buf is null terminated */
+    buf[sizeof(buf) - 1] = 0;
+
+    gpio->gpio_set_num = gpio_num;
+    gpio->gpio_set = set;
+    ret = sscanf(buf, "%u %u", &gpio_num, &set);
+
+    if (!ret)
+        return -EINVAL;
+
+
+    mutex_lock(&ar->conf_mutex);
+
+
+    ret = ath10k_wmi_gpio_output(ar, gpio_num, set);
+
+    if (ret) {
+        ath10k_warn(ar, "gpio_output cfg failed from debugfs: %d\n", ret);
+        goto exit;
+    }
+    ret = count;
+
+exit:
+    mutex_unlock(&ar->conf_mutex);
+
+    return ret;
+}
+
+
+
+
  /* TODO:  Would be nice to always support ethtool stats, would need to
   * move the stats storage out of ath10k_debug, or always have 
ath10k_debug
   * struct available..
@@ -1252,6 +1368,24 @@ static const struct file_operations 
fops_fw_dbglog = {
      .llseek = default_llseek,
  };

+
+
+static const struct file_operations fops_gpio_output = {
+    .read = ath10k_read_gpio_output,
+    .write = ath10k_write_gpio_output,
+    .open = simple_open,
+    .owner = THIS_MODULE,
+    .llseek = default_llseek,
+};
+
+static const struct file_operations fops_gpio_config = {
+    .read = ath10k_read_gpio_config,
+    .write = ath10k_write_gpio_config,
+    .open = simple_open,
+    .owner = THIS_MODULE,
+    .llseek = default_llseek,
+};
+
  static int ath10k_debug_cal_data_fetch(struct ath10k *ar)
  {
      u32 hi_addr;
@@ -2259,6 +2393,12 @@ int ath10k_debug_register(struct ath10k *ar)
      debugfs_create_file("fw_dbglog", 0600, ar->debug.debugfs_phy, ar,
                  &fops_fw_dbglog);

+    debugfs_create_file("gpio_output", 0600, ar->debug.debugfs_phy, ar,
+                &fops_gpio_output);
+
+    debugfs_create_file("gpio_config", 0600, ar->debug.debugfs_phy, ar,
+                &fops_gpio_config);
+
      debugfs_create_file("cal_data", 0400, ar->debug.debugfs_phy, ar,
                  &fops_cal_data);

diff --git a/drivers/net/wireless/ath/ath10k/hw.h 
b/drivers/net/wireless/ath/ath10k/hw.h
index 413b1b4321f7..7b743f3b205b 100644
--- a/drivers/net/wireless/ath/ath10k/hw.h
+++ b/drivers/net/wireless/ath/ath10k/hw.h
@@ -495,6 +495,7 @@ struct ath10k_hw_params {
      const char *name;
      u32 patch_load_addr;
      int uart_pin;
+    int led_pin; // 1 for peregrine, 17 for beeliner, 58 for ipq4019
      u32 otp_exe_param;

      /* Type of hw cycle counter wraparound logic, for more info
diff --git a/drivers/net/wireless/ath/ath10k/wmi-ops.h 
b/drivers/net/wireless/ath/ath10k/wmi-ops.h
index 14093cfdc505..a38d6a8f7ec5 100644
--- a/drivers/net/wireless/ath/ath10k/wmi-ops.h
+++ b/drivers/net/wireless/ath/ath10k/wmi-ops.h
@@ -197,8 +197,13 @@ struct wmi_ops {
                      (struct ath10k *ar,
                       enum wmi_bss_survey_req_type type);
      struct sk_buff *(*gen_echo)(struct ath10k *ar, u32 value);
+
+    struct sk_buff *(*gen_gpio_config)(struct ath10k *ar, u32 gpio_num, 
u32 input, u32 pull_type, u32 intr_mode);
+
+    struct sk_buff *(*gen_gpio_output)(struct ath10k *ar, u32 gpio_num, 
u32 set);
  };

+
  int ath10k_wmi_cmd_send(struct ath10k *ar, struct sk_buff *skb, u32 
cmd_id);

  static inline int
@@ -957,6 +962,35 @@ ath10k_wmi_force_fw_hang(struct ath10k *ar,

      return ath10k_wmi_cmd_send(ar, skb, 
ar->wmi.cmd->force_fw_hang_cmdid);
  }
+static inline int
+ath10k_wmi_gpio_config(struct ath10k *ar, u32 gpio_num, u32 input, u32 
pull_type, u32 intr_mode)
+{
+    struct sk_buff *skb;
+
+    if (!ar->wmi.ops->gen_gpio_config)
+        return -EOPNOTSUPP;
+
+    skb = ar->wmi.ops->gen_gpio_config(ar, gpio_num, input, pull_type, 
intr_mode);
+    if (IS_ERR(skb))
+        return PTR_ERR(skb);
+
+    return ath10k_wmi_cmd_send_nowait(ar, skb, 
ar->wmi.cmd->gpio_config_cmdid);
+}
+
+static inline int
+ath10k_wmi_gpio_output(struct ath10k *ar, u32 gpio_num, u32 set)
+{
+    struct sk_buff *skb;
+
+    if (!ar->wmi.ops->gen_gpio_config)
+        return -EOPNOTSUPP;
+
+    skb = ar->wmi.ops->gen_gpio_output(ar, gpio_num, set);
+    if (IS_ERR(skb))
+        return PTR_ERR(skb);
+
+    return ath10k_wmi_cmd_send_nowait(ar, skb, 
ar->wmi.cmd->gpio_output_cmdid);
+}

  static inline int
  ath10k_wmi_dbglog_cfg(struct ath10k *ar, u64 module_enable, u32 
log_level)
@@ -1034,7 +1068,7 @@ ath10k_wmi_pdev_get_temperature(struct ath10k *ar)
      if (IS_ERR(skb))
          return PTR_ERR(skb);

-    return ath10k_wmi_cmd_send(ar, skb,
+    return ath10k_wmi_cmd_send_nowait(ar, skb,
ar->wmi.cmd->pdev_get_temperature_cmdid);
  }

diff --git a/drivers/net/wireless/ath/ath10k/wmi.c 
b/drivers/net/wireless/ath/ath10k/wmi.c
index 58dc2189ba49..2367dcc11b4f 100644
--- a/drivers/net/wireless/ath/ath10k/wmi.c
+++ b/drivers/net/wireless/ath/ath10k/wmi.c
@@ -6646,6 +6646,38 @@ ath10k_wmi_op_gen_peer_set_param(struct ath10k 
*ar, u32 vdev_id,
      return skb;
  }

+static struct sk_buff *
+ath10k_wmi_op_gen_gpio_config(struct ath10k *ar, u32 gpio_num, u32 
input, u32 pull_type, u32 intr_mode)
+{
+    struct wmi_gpio_config_cmd *cmd;
+    struct sk_buff *skb;
+
+    skb = ath10k_wmi_alloc_skb(ar, sizeof(*cmd));
+    if (!skb)
+    return ERR_PTR(-ENOMEM);
+    cmd = (struct wmi_gpio_config_cmd *)skb->data;
+    cmd->pull_type = __cpu_to_le32(pull_type);
+    cmd->gpio_num = __cpu_to_le32(gpio_num);
+    cmd->input = __cpu_to_le32(input);
+    cmd->intr_mode = __cpu_to_le32(intr_mode);
+    return skb;
+}
+
+static struct sk_buff *
+ath10k_wmi_op_gen_gpio_output(struct ath10k *ar, u32 gpio_num, u32 set)
+{
+    struct wmi_gpio_output_cmd *cmd;
+    struct sk_buff *skb;
+
+    skb = ath10k_wmi_alloc_skb(ar, sizeof(*cmd));
+    if (!skb)
+    return ERR_PTR(-ENOMEM);
+    cmd = (struct wmi_gpio_output_cmd *)skb->data;
+    cmd->gpio_num = __cpu_to_le32(gpio_num);
+    cmd->set = __cpu_to_le32(set);
+    return skb;
+}
+
  static struct sk_buff *
  ath10k_wmi_op_gen_set_psmode(struct ath10k *ar, u32 vdev_id,
                   enum wmi_sta_ps_mode psmode)
@@ -8153,6 +8185,9 @@ static const struct wmi_ops wmi_ops = {
      .fw_stats_fill = ath10k_wmi_main_op_fw_stats_fill,
      .get_vdev_subtype = ath10k_wmi_op_get_vdev_subtype,
      .gen_echo = ath10k_wmi_op_gen_echo,
+    .gen_gpio_config = ath10k_wmi_op_gen_gpio_config,
+    .gen_gpio_output = ath10k_wmi_op_gen_gpio_output,
+
      /* .gen_bcn_tmpl not implemented */
      /* .gen_prb_tmpl not implemented */
      /* .gen_p2p_go_bcn_ie not implemented */
@@ -8223,6 +8258,8 @@ static const struct wmi_ops wmi_10_1_ops = {
      .fw_stats_fill = ath10k_wmi_10x_op_fw_stats_fill,
      .get_vdev_subtype = ath10k_wmi_op_get_vdev_subtype,
      .gen_echo = ath10k_wmi_op_gen_echo,
+    .gen_gpio_config = ath10k_wmi_op_gen_gpio_config,
+    .gen_gpio_output = ath10k_wmi_op_gen_gpio_output,
      /* .gen_bcn_tmpl not implemented */
      /* .gen_prb_tmpl not implemented */
      /* .gen_p2p_go_bcn_ie not implemented */
@@ -8294,6 +8331,8 @@ static const struct wmi_ops wmi_10_2_ops = {
      .gen_delba_send = ath10k_wmi_op_gen_delba_send,
      .fw_stats_fill = ath10k_wmi_10x_op_fw_stats_fill,
      .get_vdev_subtype = ath10k_wmi_op_get_vdev_subtype,
+    .gen_gpio_config = ath10k_wmi_op_gen_gpio_config,
+    .gen_gpio_output = ath10k_wmi_op_gen_gpio_output,
      /* .gen_pdev_enable_adaptive_cca not implemented */
  };

@@ -8364,6 +8403,8 @@ static const struct wmi_ops wmi_10_2_4_ops = {
      .gen_pdev_enable_adaptive_cca =
          ath10k_wmi_op_gen_pdev_enable_adaptive_cca,
      .get_vdev_subtype = ath10k_wmi_10_2_4_op_get_vdev_subtype,
+    .gen_gpio_config = ath10k_wmi_op_gen_gpio_config,
+    .gen_gpio_output = ath10k_wmi_op_gen_gpio_output,
      /* .gen_bcn_tmpl not implemented */
      /* .gen_prb_tmpl not implemented */
      /* .gen_p2p_go_bcn_ie not implemented */
@@ -8439,6 +8480,8 @@ static const struct wmi_ops wmi_10_4_ops = {
      .gen_pdev_bss_chan_info_req = 
ath10k_wmi_10_2_op_gen_pdev_bss_chan_info,
      .gen_echo = ath10k_wmi_op_gen_echo,
      .gen_pdev_get_tpc_config = 
ath10k_wmi_10_2_4_op_gen_pdev_get_tpc_config,
+    .gen_gpio_config = ath10k_wmi_op_gen_gpio_config,
+    .gen_gpio_output = ath10k_wmi_op_gen_gpio_output,
  };

  int ath10k_wmi_attach(struct ath10k *ar)
diff --git a/drivers/net/wireless/ath/ath10k/wmi.h 
b/drivers/net/wireless/ath/ath10k/wmi.h
index c7b30ed9015d..dc180a86dc3b 100644
--- a/drivers/net/wireless/ath/ath10k/wmi.h
+++ b/drivers/net/wireless/ath/ath10k/wmi.h
@@ -2906,6 +2906,42 @@ enum wmi_10_4_feature_mask {

  };

+/* WMI_GPIO_CONFIG_CMDID */
+enum {
+    WMI_GPIO_PULL_NONE,
+    WMI_GPIO_PULL_UP,
+    WMI_GPIO_PULL_DOWN,
+};
+
+enum {
+    WMI_GPIO_INTTYPE_DISABLE,
+    WMI_GPIO_INTTYPE_RISING_EDGE,
+    WMI_GPIO_INTTYPE_FALLING_EDGE,
+    WMI_GPIO_INTTYPE_BOTH_EDGE,
+    WMI_GPIO_INTTYPE_LEVEL_LOW,
+    WMI_GPIO_INTTYPE_LEVEL_HIGH
+};
+
+/* WMI_GPIO_CONFIG_CMDID */
+struct wmi_gpio_config_cmd {
+    __le32 gpio_num;             /* GPIO number to be setup */
+    __le32 input;                /* 0 - Output/ 1 - Input */
+    __le32 pull_type;            /* Pull type defined above */
+    __le32 intr_mode;            /* Interrupt mode defined above 
(Input) */
+} __packed;
+
+/* WMI_GPIO_OUTPUT_CMDID */
+struct wmi_gpio_output_cmd {
+    __le32 gpio_num;    /* GPIO number to be setup */
+    __le32 set;         /* Set the GPIO pin*/
+} __packed;
+
+/* WMI_GPIO_INPUT_EVENTID */
+struct wmi_gpio_input_event {
+    __le32 gpio_num;    /* GPIO number which changed state */
+} __packed;
+
+
  struct wmi_ext_resource_config_10_4_cmd {
      /* contains enum wmi_host_platform_type */
      __le32 host_platform_config;
