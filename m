Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail30g.wh2.ocn.ne.jp ([220.111.41.239]:1580 "HELO
	mail30g.wh2.ocn.ne.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1755178Ab0ELJke (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 12 May 2010 05:40:34 -0400
Received: from vs3016.wh2.ocn.ne.jp (125.206.180.189)
	by mail30g.wh2.ocn.ne.jp (RS ver 1.0.95vs) with SMTP id 3-0919197233
	for <linux-wireless@vger.kernel.org>; Wed, 12 May 2010 18:40:33 +0900 (JST)
Subject: [PATCH 10/12] ath5k: add sysfs files for ANI parameters
To: linville@tuxdriver.com
From: Bruno Randolf <br1@einfach.org>
Cc: ath5k-devel@lists.ath5k.org, linux-wireless@vger.kernel.org
Date: Wed, 12 May 2010 18:40:34 +0900
Message-ID: <20100512094034.6575.76706.stgit@tt-desk>
In-Reply-To: <20100512093947.6575.99595.stgit@tt-desk>
References: <20100512093947.6575.99595.stgit@tt-desk>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

/sys/class/ieee80211/phy0/device/ani/ani_mode
/sys/class/ieee80211/phy0/device/ani/noise_immunity_level
/sys/class/ieee80211/phy0/device/ani/spur_level
/sys/class/ieee80211/phy0/device/ani/firstep_level
/sys/class/ieee80211/phy0/device/ani/ofdm_weak_signal_detection
/sys/class/ieee80211/phy0/device/ani/cck_weak_signal_detection
/sys/class/ieee80211/phy0/device/ani/noise_immunity_level_max
/sys/class/ieee80211/phy0/device/ani/spur_level_max
/sys/class/ieee80211/phy0/device/ani/firstep_level_max

sysfs has a lot of symlinks, so you can find the files also in other locations,
like (by PCI ID) /sys/devices/pci0000:00/0000:00:11.0/ani and others.

Signed-off-by: Bruno Randolf <br1@einfach.org>
---
 drivers/net/wireless/ath/ath5k/Makefile |    1 
 drivers/net/wireless/ath/ath5k/ath5k.h  |    3 +
 drivers/net/wireless/ath/ath5k/base.c   |    3 +
 drivers/net/wireless/ath/ath5k/reset.c  |    1 
 drivers/net/wireless/ath/ath5k/sysfs.c  |  116 +++++++++++++++++++++++++++++++
 5 files changed, 123 insertions(+), 1 deletions(-)
 create mode 100644 drivers/net/wireless/ath/ath5k/sysfs.c

diff --git a/drivers/net/wireless/ath/ath5k/Makefile b/drivers/net/wireless/ath/ath5k/Makefile
index cc09595..2242a14 100644
--- a/drivers/net/wireless/ath/ath5k/Makefile
+++ b/drivers/net/wireless/ath/ath5k/Makefile
@@ -13,5 +13,6 @@ ath5k-y				+= base.o
 ath5k-y				+= led.o
 ath5k-y				+= rfkill.o
 ath5k-y				+= ani.o
+ath5k-y				+= sysfs.o
 ath5k-$(CONFIG_ATH5K_DEBUG)	+= debug.o
 obj-$(CONFIG_ATH5K)		+= ath5k.o
diff --git a/drivers/net/wireless/ath/ath5k/ath5k.h b/drivers/net/wireless/ath/ath5k/ath5k.h
index d6f9afe..eace74d 100644
--- a/drivers/net/wireless/ath/ath5k/ath5k.h
+++ b/drivers/net/wireless/ath/ath5k/ath5k.h
@@ -1150,6 +1150,9 @@ struct ath5k_hw {
 int ath5k_hw_attach(struct ath5k_softc *sc);
 void ath5k_hw_detach(struct ath5k_hw *ah);
 
+int ath5k_sysfs_register(struct ath5k_softc *sc);
+void ath5k_sysfs_unregister(struct ath5k_softc *sc);
+
 /* LED functions */
 int ath5k_init_leds(struct ath5k_softc *sc);
 void ath5k_led_enable(struct ath5k_softc *sc);
diff --git a/drivers/net/wireless/ath/ath5k/base.c b/drivers/net/wireless/ath/ath5k/base.c
index 3fcf220..053cb36 100644
--- a/drivers/net/wireless/ath/ath5k/base.c
+++ b/drivers/net/wireless/ath/ath5k/base.c
@@ -861,6 +861,8 @@ ath5k_attach(struct pci_dev *pdev, struct ieee80211_hw *hw)
 
 	ath5k_init_leds(sc);
 
+	ath5k_sysfs_register(sc);
+
 	return 0;
 err_queues:
 	ath5k_txq_release(sc);
@@ -896,6 +898,7 @@ ath5k_detach(struct pci_dev *pdev, struct ieee80211_hw *hw)
 	ath5k_hw_release_tx_queue(sc->ah, sc->bhalq);
 	ath5k_unregister_leds(sc);
 
+	ath5k_sysfs_unregister(sc);
 	/*
 	 * NB: can't reclaim these until after ieee80211_ifdetach
 	 * returns because we'll get called back to reclaim node
diff --git a/drivers/net/wireless/ath/ath5k/reset.c b/drivers/net/wireless/ath/ath5k/reset.c
index 2890a7f..b1d3239 100644
--- a/drivers/net/wireless/ath/ath5k/reset.c
+++ b/drivers/net/wireless/ath/ath5k/reset.c
@@ -851,7 +851,6 @@ static void ath5k_hw_commit_eeprom_settings(struct ath5k_hw *ah,
 			AR5K_PHY_NF_THRESH62,
 			ee->ee_thr_62[ee_mode]);
 
-
 	/* False detect backoff for channels
 	 * that have spur noise. Write the new
 	 * cyclic power RSSI threshold. */
diff --git a/drivers/net/wireless/ath/ath5k/sysfs.c b/drivers/net/wireless/ath/ath5k/sysfs.c
new file mode 100644
index 0000000..90757de
--- /dev/null
+++ b/drivers/net/wireless/ath/ath5k/sysfs.c
@@ -0,0 +1,116 @@
+#include <linux/device.h>
+#include <linux/pci.h>
+
+#include "base.h"
+#include "ath5k.h"
+#include "reg.h"
+
+#define SIMPLE_SHOW_STORE(name, get, set)				\
+static ssize_t ath5k_attr_show_##name(struct device *dev,		\
+			struct device_attribute *attr,			\
+			char *buf)					\
+{									\
+	struct ath5k_softc *sc = dev_get_drvdata(dev);			\
+	return snprintf(buf, PAGE_SIZE, "%d\n", get); 			\
+}									\
+									\
+static ssize_t ath5k_attr_store_##name(struct device *dev,		\
+			struct device_attribute *attr,			\
+			const char *buf, size_t count)			\
+{									\
+	struct ath5k_softc *sc = dev_get_drvdata(dev);			\
+	int val;							\
+									\
+	val = (int)simple_strtoul(buf, NULL, 10);			\
+	set(sc->ah, val);						\
+	return count;							\
+}									\
+static DEVICE_ATTR(name, S_IRUGO | S_IWUSR,				\
+		   ath5k_attr_show_##name, ath5k_attr_store_##name)
+
+#define SIMPLE_SHOW(name, get)						\
+static ssize_t ath5k_attr_show_##name(struct device *dev,		\
+			struct device_attribute *attr,			\
+			char *buf)					\
+{									\
+	struct ath5k_softc *sc = dev_get_drvdata(dev);			\
+	return snprintf(buf, PAGE_SIZE, "%d\n", get); 			\
+}									\
+static DEVICE_ATTR(name, S_IRUGO, ath5k_attr_show_##name, NULL)
+
+/*** ANI ***/
+
+SIMPLE_SHOW_STORE(ani_mode, sc->ani_state.ani_mode, ath5k_ani_init);
+SIMPLE_SHOW_STORE(noise_immunity_level, sc->ani_state.noise_imm_level,
+			ath5k_ani_set_noise_immunity_level);
+SIMPLE_SHOW_STORE(spur_level, sc->ani_state.spur_level,
+			ath5k_ani_set_spur_immunity_level);
+SIMPLE_SHOW_STORE(firstep_level, sc->ani_state.firstep_level,
+			ath5k_ani_set_firstep_level);
+SIMPLE_SHOW_STORE(ofdm_weak_signal_detection, sc->ani_state.ofdm_weak_sig,
+			ath5k_ani_set_ofdm_weak_signal_detection);
+SIMPLE_SHOW_STORE(cck_weak_signal_detection, sc->ani_state.cck_weak_sig,
+			ath5k_ani_set_cck_weak_signal_detection);
+SIMPLE_SHOW(spur_level_max, sc->ani_state.max_spur_level);
+
+static ssize_t ath5k_attr_show_noise_immunity_level_max(struct device *dev,
+			struct device_attribute *attr,
+			char *buf)
+{
+	return snprintf(buf, PAGE_SIZE, "%d\n", ATH5K_ANI_MAX_NOISE_IMM_LVL);
+}
+static DEVICE_ATTR(noise_immunity_level_max, S_IRUGO,
+		   ath5k_attr_show_noise_immunity_level_max, NULL);
+
+static ssize_t ath5k_attr_show_firstep_level_max(struct device *dev,
+			struct device_attribute *attr,
+			char *buf)
+{
+	return snprintf(buf, PAGE_SIZE, "%d\n", ATH5K_ANI_MAX_FIRSTEP_LVL);
+}
+static DEVICE_ATTR(firstep_level_max, S_IRUGO,
+		   ath5k_attr_show_firstep_level_max, NULL);
+
+static struct attribute *ath5k_sysfs_entries_ani[] = {
+	&dev_attr_ani_mode.attr,
+	&dev_attr_noise_immunity_level.attr,
+	&dev_attr_spur_level.attr,
+	&dev_attr_firstep_level.attr,
+	&dev_attr_ofdm_weak_signal_detection.attr,
+	&dev_attr_cck_weak_signal_detection.attr,
+	&dev_attr_noise_immunity_level_max.attr,
+	&dev_attr_spur_level_max.attr,
+	&dev_attr_firstep_level_max.attr,
+	NULL
+};
+
+static struct attribute_group ath5k_attribute_group_ani = {
+	.name = "ani",
+	.attrs = ath5k_sysfs_entries_ani,
+};
+
+
+/*** register / unregister ***/
+
+int
+ath5k_sysfs_register(struct ath5k_softc *sc)
+{
+	struct device *dev = &sc->pdev->dev;
+	int err;
+
+	err = sysfs_create_group(&dev->kobj, &ath5k_attribute_group_ani);
+	if (err) {
+		ATH5K_ERR(sc, "failed to create sysfs group\n");
+		return err;
+	}
+
+	return 0;
+}
+
+void
+ath5k_sysfs_unregister(struct ath5k_softc *sc)
+{
+	struct device *dev = &sc->pdev->dev;
+
+	sysfs_remove_group(&dev->kobj, &ath5k_attribute_group_ani);
+}

