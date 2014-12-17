Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wolverine01.qualcomm.com ([199.106.114.254]:7516 "EHLO
	wolverine01.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751449AbaLQKWa (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 17 Dec 2014 05:22:30 -0500
Subject: [PATCH v2 6/8] ath10k: add thermal cooling device support
To: <ath10k@lists.infradead.org>
From: Kalle Valo <kvalo@qca.qualcomm.com>
CC: <linux-wireless@vger.kernel.org>
Date: Wed, 17 Dec 2014 12:22:07 +0200
Message-ID: <20141217102207.15964.86994.stgit@potku.adurom.net> (sfid-20141217_112233_604651_768D198E)
In-Reply-To: <20141217101755.15964.2625.stgit@potku.adurom.net>
References: <20141217101755.15964.2625.stgit@potku.adurom.net>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Rajkumar Manoharan <rmanohar@qti.qualcomm.com>

Thermal cooling device support is added to control the temperature
by throttling the data transmission for the given duration. Throttling
is done using hw MAC quiet time setting. Period, duration and offset
from TBTT can be set up to quiet the MAC transmits for the required duty
cycle (% of quiet duration). The thermal device allows user to configure
duty cycle.

The quiet params are derived as follows.
	period = max(25TU, beacon interval / number of bss)
	duration = period * duty cycle / 100

Quiet mode can be disabled by setting the duty cycle to 0. The cooling
device can be found under /sys/class/thermal/cooling_deviceX/.
Corresponding soft link to this device can be found under phy folder.

/sys/class/ieee80211/phy*/device/cooling_device.

To set duty cycle as 40%,

echo 40 >/sys/class/ieee80211/phy*/device/cooling_device/cur_state

Signed-off-by: Rajkumar Manoharan <rmanohar@qti.qualcomm.com>
Signed-off-by: Kalle Valo <kvalo@qca.qualcomm.com>
---
 drivers/net/wireless/ath/ath10k/Makefile  |    1 
 drivers/net/wireless/ath/ath10k/core.c    |   10 ++
 drivers/net/wireless/ath/ath10k/core.h    |    3 +
 drivers/net/wireless/ath/ath10k/thermal.c |  155 +++++++++++++++++++++++++++++
 drivers/net/wireless/ath/ath10k/thermal.h |   44 ++++++++
 5 files changed, 213 insertions(+)
 create mode 100644 drivers/net/wireless/ath/ath10k/thermal.c
 create mode 100644 drivers/net/wireless/ath/ath10k/thermal.h

diff --git a/drivers/net/wireless/ath/ath10k/Makefile b/drivers/net/wireless/ath/ath10k/Makefile
index 8abb66ceb99c..ffa3b1a8745f 100644
--- a/drivers/net/wireless/ath/ath10k/Makefile
+++ b/drivers/net/wireless/ath/ath10k/Makefile
@@ -14,6 +14,7 @@ ath10k_core-y += mac.o \
 ath10k_core-$(CONFIG_ATH10K_DEBUGFS) += spectral.o
 ath10k_core-$(CONFIG_NL80211_TESTMODE) += testmode.o
 ath10k_core-$(CONFIG_ATH10K_TRACING) += trace.o
+ath10k_core-$(CONFIG_THERMAL) += thermal.o
 
 obj-$(CONFIG_ATH10K_PCI) += ath10k_pci.o
 ath10k_pci-y += pci.o \
diff --git a/drivers/net/wireless/ath/ath10k/core.c b/drivers/net/wireless/ath/ath10k/core.c
index 45bca513719e..28bfacb382f3 100644
--- a/drivers/net/wireless/ath/ath10k/core.c
+++ b/drivers/net/wireless/ath/ath10k/core.c
@@ -1234,9 +1234,18 @@ static void ath10k_core_register_work(struct work_struct *work)
 		goto err_debug_destroy;
 	}
 
+	status = ath10k_thermal_register(ar);
+	if (status) {
+		ath10k_err(ar, "could not register thermal device: %d\n",
+			   status);
+		goto err_spectral_destroy;
+	}
+
 	set_bit(ATH10K_FLAG_CORE_REGISTERED, &ar->dev_flags);
 	return;
 
+err_spectral_destroy:
+	ath10k_spectral_destroy(ar);
 err_debug_destroy:
 	ath10k_debug_destroy(ar);
 err_unregister_mac:
@@ -1266,6 +1275,7 @@ void ath10k_core_unregister(struct ath10k *ar)
 	if (!test_bit(ATH10K_FLAG_CORE_REGISTERED, &ar->dev_flags))
 		return;
 
+	ath10k_thermal_unregister(ar);
 	/* Stop spectral before unregistering from mac80211 to remove the
 	 * relayfs debugfs file cleanly. Otherwise the parent debugfs tree
 	 * would be already be free'd recursively, leading to a double free.
diff --git a/drivers/net/wireless/ath/ath10k/core.h b/drivers/net/wireless/ath/ath10k/core.h
index 3998f1e33874..7b6d9e4567a3 100644
--- a/drivers/net/wireless/ath/ath10k/core.h
+++ b/drivers/net/wireless/ath/ath10k/core.h
@@ -34,6 +34,7 @@
 #include "../regd.h"
 #include "../dfs_pattern_detector.h"
 #include "spectral.h"
+#include "thermal.h"
 
 #define MS(_v, _f) (((_v) & _f##_MASK) >> _f##_LSB)
 #define SM(_v, _f) (((_v) << _f##_LSB) & _f##_MASK)
@@ -634,6 +635,8 @@ struct ath10k {
 		u32 fw_cold_reset_counter;
 	} stats;
 
+	struct ath10k_thermal thermal;
+
 	/* must be last */
 	u8 drv_priv[0] __aligned(sizeof(void *));
 };
diff --git a/drivers/net/wireless/ath/ath10k/thermal.c b/drivers/net/wireless/ath/ath10k/thermal.c
new file mode 100644
index 000000000000..e98ce8ce27e2
--- /dev/null
+++ b/drivers/net/wireless/ath/ath10k/thermal.c
@@ -0,0 +1,155 @@
+/*
+ * Copyright (c) 2014 Qualcomm Atheros, Inc.
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
+#include <linux/device.h>
+#include <linux/sysfs.h>
+#include <linux/thermal.h>
+#include "core.h"
+#include "debug.h"
+#include "wmi-ops.h"
+
+static int ath10k_thermal_get_active_vifs(struct ath10k *ar,
+					  enum wmi_vdev_type type)
+{
+	struct ath10k_vif *arvif;
+	int count = 0;
+
+	lockdep_assert_held(&ar->conf_mutex);
+
+	list_for_each_entry(arvif, &ar->arvifs, list) {
+		if (!arvif->is_started)
+			continue;
+
+		if (!arvif->is_up)
+			continue;
+
+		if (arvif->vdev_type != type)
+			continue;
+
+		count++;
+	}
+	return count;
+}
+
+static int ath10k_thermal_get_max_dutycycle(struct thermal_cooling_device *cdev,
+					    unsigned long *state)
+{
+	*state = ATH10K_QUIET_DUTY_CYCLE_MAX;
+
+	return 0;
+}
+
+static int ath10k_thermal_get_cur_dutycycle(struct thermal_cooling_device *cdev,
+					    unsigned long *state)
+{
+	struct ath10k *ar = cdev->devdata;
+
+	mutex_lock(&ar->conf_mutex);
+	*state = ar->thermal.duty_cycle;
+	mutex_unlock(&ar->conf_mutex);
+
+	return 0;
+}
+
+static int ath10k_thermal_set_cur_dutycycle(struct thermal_cooling_device *cdev,
+					    unsigned long duty_cycle)
+{
+	struct ath10k *ar = cdev->devdata;
+	u32 period, duration, enabled;
+	int num_bss, ret = 0;
+
+	mutex_lock(&ar->conf_mutex);
+	if (ar->state != ATH10K_STATE_ON) {
+		ret = -ENETDOWN;
+		goto out;
+	}
+
+	if (duty_cycle > ATH10K_QUIET_DUTY_CYCLE_MAX) {
+		ath10k_warn(ar, "duty cycle %ld is exceeding the limit %d\n",
+			    duty_cycle, ATH10K_QUIET_DUTY_CYCLE_MAX);
+		ret = -EINVAL;
+		goto out;
+	}
+	/* TODO: Right now, thermal mitigation is handled only for single/multi
+	 * vif AP mode. Since quiet param is not validated in STA mode, it needs
+	 * to be investigated further to handle multi STA and multi-vif (AP+STA)
+	 * mode properly.
+	 */
+	num_bss = ath10k_thermal_get_active_vifs(ar, WMI_VDEV_TYPE_AP);
+	if (!num_bss) {
+		ath10k_warn(ar, "no active AP interfaces\n");
+		ret = -ENETDOWN;
+		goto out;
+	}
+	period = max(ATH10K_QUIET_PERIOD_MIN,
+		     (ATH10K_QUIET_PERIOD_DEFAULT / num_bss));
+	duration = period * (duty_cycle / 100);
+	enabled = duration ? 1 : 0;
+
+	ret = ath10k_wmi_pdev_set_quiet_mode(ar, period, duration,
+					     ATH10K_QUIET_START_OFFSET,
+					     enabled);
+	if (ret) {
+		ath10k_warn(ar, "failed to set quiet mode period %u duarion %u enabled %u ret %d\n",
+			    period, duration, enabled, ret);
+		goto out;
+	}
+	ar->thermal.duty_cycle = duty_cycle;
+out:
+	mutex_unlock(&ar->conf_mutex);
+	return ret;
+}
+
+static struct thermal_cooling_device_ops ath10k_thermal_ops = {
+	.get_max_state = ath10k_thermal_get_max_dutycycle,
+	.get_cur_state = ath10k_thermal_get_cur_dutycycle,
+	.set_cur_state = ath10k_thermal_set_cur_dutycycle,
+};
+
+int ath10k_thermal_register(struct ath10k *ar)
+{
+	struct thermal_cooling_device *cdev;
+	int ret;
+
+	cdev = thermal_cooling_device_register("ath10k_thermal", ar,
+					       &ath10k_thermal_ops);
+
+	if (IS_ERR(cdev)) {
+		ath10k_err(ar, "failed to setup thermal device result: %ld\n",
+			   PTR_ERR(cdev));
+		return -EINVAL;
+	}
+
+	ret = sysfs_create_link(&ar->dev->kobj, &cdev->device.kobj,
+				"cooling_device");
+	if (ret) {
+		ath10k_err(ar, "failed to create thermal symlink\n");
+		goto err_cooling_destroy;
+	}
+
+	ar->thermal.cdev = cdev;
+	return 0;
+
+err_cooling_destroy:
+	thermal_cooling_device_unregister(cdev);
+	return ret;
+}
+
+void ath10k_thermal_unregister(struct ath10k *ar)
+{
+	thermal_cooling_device_unregister(ar->thermal.cdev);
+	sysfs_remove_link(&ar->dev->kobj, "cooling_device");
+}
diff --git a/drivers/net/wireless/ath/ath10k/thermal.h b/drivers/net/wireless/ath/ath10k/thermal.h
new file mode 100644
index 000000000000..e20bb87849ae
--- /dev/null
+++ b/drivers/net/wireless/ath/ath10k/thermal.h
@@ -0,0 +1,44 @@
+/*
+ * Copyright (c) 2014 Qualcomm Atheros, Inc.
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
+#ifndef _THERMAL_
+#define _THERMAL_
+
+#define ATH10K_QUIET_PERIOD_DEFAULT     100
+#define ATH10K_QUIET_PERIOD_MIN         25
+#define ATH10K_QUIET_START_OFFSET       10
+#define ATH10K_QUIET_DUTY_CYCLE_MAX     70
+
+struct ath10k_thermal {
+	struct thermal_cooling_device *cdev;
+
+	/* protected by conf_mutex */
+	u32 duty_cycle;
+};
+
+#ifdef CONFIG_THERMAL
+int ath10k_thermal_register(struct ath10k *ar);
+void ath10k_thermal_unregister(struct ath10k *ar);
+#else
+static inline int ath10k_thermal_register(struct ath10k *ar)
+{
+	return 0;
+}
+
+static inline void ath10k_thermal_unregister(struct ath10k *ar)
+{
+}
+#endif
+#endif /* _THERMAL_ */

