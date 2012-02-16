Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pz0-f46.google.com ([209.85.210.46]:55127 "EHLO
	mail-pz0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752396Ab2BPNlG (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 16 Feb 2012 08:41:06 -0500
Received: by daed14 with SMTP id d14so2038518dae.19
        for <linux-wireless@vger.kernel.org>; Thu, 16 Feb 2012 05:41:06 -0800 (PST)
From: John Li <john.li.mediatek@gmail.com>
To: users@rt2x00.serialmonkey.com
Cc: linux-wireless@vger.kernel.org,
	John Linville <linville@tuxdriver.com>,
	John Li <chen-yang.li@mediatek.com>
Subject: [PATCH] rt2x00:Add VCO recalibration
Date: Thu, 16 Feb 2012 21:40:57 +0800
Message-Id: <1329399657-32029-1-git-send-email-john.li.mediatek@gmail.com> (sfid-20120216_144112_729869_BC2FD632)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: John Li <chen-yang.li@mediatek.com>

Signed-off-by: John Li <chen-yang.li@mediatek.com>
---
 drivers/net/wireless/rt2x00/rt2800.h       |    9 +++
 drivers/net/wireless/rt2x00/rt2800lib.c    |   88 ++++++++++++++++++++++++++++
 drivers/net/wireless/rt2x00/rt2800lib.h    |    1 +
 drivers/net/wireless/rt2x00/rt2800pci.c    |    1 +
 drivers/net/wireless/rt2x00/rt2800usb.c    |    1 +
 drivers/net/wireless/rt2x00/rt2x00.h       |   12 ++++
 drivers/net/wireless/rt2x00/rt2x00config.c |    3 +
 drivers/net/wireless/rt2x00/rt2x00dev.c    |    4 +
 drivers/net/wireless/rt2x00/rt2x00lib.h    |   13 ++++
 drivers/net/wireless/rt2x00/rt2x00link.c   |   39 ++++++++++++
 10 files changed, 171 insertions(+), 0 deletions(-)

diff --git a/drivers/net/wireless/rt2x00/rt2800.h b/drivers/net/wireless/rt2x00/rt2800.h
index 2571a2f..9817688 100644
--- a/drivers/net/wireless/rt2x00/rt2800.h
+++ b/drivers/net/wireless/rt2x00/rt2800.h
@@ -965,6 +965,7 @@
  * TX_PIN_CFG:
  */
 #define TX_PIN_CFG			0x1328
+#define TX_PIN_CFG_PA_PE_DISABLE	0xfcfffff0
 #define TX_PIN_CFG_PA_PE_A0_EN		FIELD32(0x00000001)
 #define TX_PIN_CFG_PA_PE_G0_EN		FIELD32(0x00000002)
 #define TX_PIN_CFG_PA_PE_A1_EN		FIELD32(0x00000004)
@@ -985,6 +986,14 @@
 #define TX_PIN_CFG_RFTR_POL		FIELD32(0x00020000)
 #define TX_PIN_CFG_TRSW_EN		FIELD32(0x00040000)
 #define TX_PIN_CFG_TRSW_POL		FIELD32(0x00080000)
+#define TX_PIN_CFG_PA_PE_A2_EN		FIELD32(0x01000000)
+#define TX_PIN_CFG_PA_PE_G2_EN		FIELD32(0x02000000)
+#define TX_PIN_CFG_PA_PE_A2_POL		FIELD32(0x04000000)
+#define TX_PIN_CFG_PA_PE_G2_POL		FIELD32(0x08000000)
+#define TX_PIN_CFG_LNA_PE_A2_EN		FIELD32(0x10000000)
+#define TX_PIN_CFG_LNA_PE_G2_EN		FIELD32(0x20000000)
+#define TX_PIN_CFG_LNA_PE_A2_POL	FIELD32(0x40000000)
+#define TX_PIN_CFG_LNA_PE_G2_POL	FIELD32(0x80000000)
 
 /*
  * TX_BAND_CFG: 0x1 use upper 20MHz, 0x0 use lower 20MHz
diff --git a/drivers/net/wireless/rt2x00/rt2800lib.c b/drivers/net/wireless/rt2x00/rt2800lib.c
index 22a1a8f..df38273 100644
--- a/drivers/net/wireless/rt2x00/rt2800lib.c
+++ b/drivers/net/wireless/rt2x00/rt2800lib.c
@@ -2414,6 +2414,80 @@ void rt2800_gain_calibration(struct rt2x00_dev *rt2x00dev)
 }
 EXPORT_SYMBOL_GPL(rt2800_gain_calibration);
 
+void rt2800_vco_calibration(struct rt2x00_dev *rt2x00dev)
+{
+	u32	tx_pin;
+	u8	rfcsr;
+
+	/*
+	 * A voltage-controlled oscillator(VCO) is an electronic oscillator
+	 * designed to be controlled in oscillation frequency by a voltage
+	 * input. Maybe the temperature will affect the frequency of
+	 * oscillation to be shifted. The VCO calibration will be called
+	 * periodically to adjust the frequency to be precision.
+	*/
+
+	rt2800_register_read(rt2x00dev, TX_PIN_CFG, &tx_pin);
+	tx_pin &= TX_PIN_CFG_PA_PE_DISABLE;
+	rt2800_register_write(rt2x00dev, TX_PIN_CFG, tx_pin);
+
+	switch (rt2x00dev->chip.rf) {
+	case RF2020:
+	case RF3020:
+	case RF3021:
+	case RF3022:
+	case RF3320:
+	case RF3052:
+		rt2800_rfcsr_read(rt2x00dev, 7, &rfcsr);
+		rt2x00_set_field8(&rfcsr, RFCSR7_RF_TUNING, 1);
+		rt2800_rfcsr_write(rt2x00dev, 7, rfcsr);
+		break;
+	case RF5370:
+	case RF5372:
+	case RF5390:
+		rt2800_rfcsr_read(rt2x00dev, 3, &rfcsr);
+		rt2x00_set_field8(&rfcsr, RFCSR30_RF_CALIBRATION, 1);
+		rt2800_rfcsr_write(rt2x00dev, 3, rfcsr);
+		break;
+	default:
+		return;
+	}
+
+	mdelay(1);
+
+	rt2800_register_read(rt2x00dev, TX_PIN_CFG, &tx_pin);
+	if (rt2x00dev->rf_channel <= 14) {
+		switch (rt2x00dev->default_ant.tx_chain_num) {
+		case 3:
+			rt2x00_set_field32(&tx_pin, TX_PIN_CFG_PA_PE_G2_EN, 1);
+			/* fall through */
+		case 2:
+			rt2x00_set_field32(&tx_pin, TX_PIN_CFG_PA_PE_G1_EN, 1);
+			/* fall through */
+		case 1:
+		default:
+			rt2x00_set_field32(&tx_pin, TX_PIN_CFG_PA_PE_G0_EN, 1);
+			break;
+		}
+	} else {
+		switch (rt2x00dev->default_ant.tx_chain_num) {
+		case 3:
+			rt2x00_set_field32(&tx_pin, TX_PIN_CFG_PA_PE_A2_EN, 1);
+			/* fall through */
+		case 2:
+			rt2x00_set_field32(&tx_pin, TX_PIN_CFG_PA_PE_A1_EN, 1);
+			/* fall through */
+		case 1:
+		default:
+			rt2x00_set_field32(&tx_pin, TX_PIN_CFG_PA_PE_A0_EN, 1);
+			break;
+		}
+	}
+	rt2800_register_write(rt2x00dev, TX_PIN_CFG, tx_pin);
+
+}
+EXPORT_SYMBOL_GPL(rt2800_vco_calibration);
+
 static void rt2800_config_retry_limit(struct rt2x00_dev *rt2x00dev,
 				      struct rt2x00lib_conf *libconf)
 {
@@ -4347,6 +4421,20 @@ int rt2800_probe_hw_mode(struct rt2x00_dev *rt2x00dev)
 		}
 	}
 
+	switch (rt2x00dev->chip.rf) {
+	case RF2020:
+	case RF3020:
+	case RF3021:
+	case RF3022:
+	case RF3320:
+	case RF3052:
+	case RF5370:
+	case RF5372:
+	case RF5390:
+		__set_bit(CAPABILITY_VCO_RECALIBRATION, &rt2x00dev->cap_flags);
+		break;
+	}
+
 	return 0;
 }
 EXPORT_SYMBOL_GPL(rt2800_probe_hw_mode);
diff --git a/drivers/net/wireless/rt2x00/rt2800lib.h b/drivers/net/wireless/rt2x00/rt2800lib.h
index 8c3c281..419e36c 100644
--- a/drivers/net/wireless/rt2x00/rt2800lib.h
+++ b/drivers/net/wireless/rt2x00/rt2800lib.h
@@ -184,6 +184,7 @@ void rt2800_reset_tuner(struct rt2x00_dev *rt2x00dev, struct link_qual *qual);
 void rt2800_link_tuner(struct rt2x00_dev *rt2x00dev, struct link_qual *qual,
 		       const u32 count);
 void rt2800_gain_calibration(struct rt2x00_dev *rt2x00dev);
+void rt2800_vco_calibration(struct rt2x00_dev *rt2x00dev);
 
 int rt2800_enable_radio(struct rt2x00_dev *rt2x00dev);
 void rt2800_disable_radio(struct rt2x00_dev *rt2x00dev);
diff --git a/drivers/net/wireless/rt2x00/rt2800pci.c b/drivers/net/wireless/rt2x00/rt2800pci.c
index 837b460..25fd45c 100644
--- a/drivers/net/wireless/rt2x00/rt2800pci.c
+++ b/drivers/net/wireless/rt2x00/rt2800pci.c
@@ -1050,6 +1050,7 @@ static const struct rt2x00lib_ops rt2800pci_rt2x00_ops = {
 	.reset_tuner		= rt2800_reset_tuner,
 	.link_tuner		= rt2800_link_tuner,
 	.gain_calibration	= rt2800_gain_calibration,
+	.vco_calibration	= rt2800_vco_calibration,
 	.start_queue		= rt2800pci_start_queue,
 	.kick_queue		= rt2800pci_kick_queue,
 	.stop_queue		= rt2800pci_stop_queue,
diff --git a/drivers/net/wireless/rt2x00/rt2800usb.c b/drivers/net/wireless/rt2x00/rt2800usb.c
index 7f21005..2fab90e 100644
--- a/drivers/net/wireless/rt2x00/rt2800usb.c
+++ b/drivers/net/wireless/rt2x00/rt2800usb.c
@@ -783,6 +783,7 @@ static const struct rt2x00lib_ops rt2800usb_rt2x00_ops = {
 	.reset_tuner		= rt2800_reset_tuner,
 	.link_tuner		= rt2800_link_tuner,
 	.gain_calibration	= rt2800_gain_calibration,
+	.vco_calibration	= rt2800_vco_calibration,
 	.watchdog		= rt2800usb_watchdog,
 	.start_queue		= rt2800usb_start_queue,
 	.kick_queue		= rt2x00usb_kick_queue,
diff --git a/drivers/net/wireless/rt2x00/rt2x00.h b/drivers/net/wireless/rt2x00/rt2x00.h
index b03b22c..4e878ff 100644
--- a/drivers/net/wireless/rt2x00/rt2x00.h
+++ b/drivers/net/wireless/rt2x00/rt2x00.h
@@ -355,6 +355,11 @@ struct link {
 	 * Work structure for scheduling periodic AGC adjustments.
 	 */
 	struct delayed_work agc_work;
+
+	/*
+	 * Work structure for scheduling periodic VCO calibration.
+	 */
+	struct delayed_work vco_work;
 };
 
 enum rt2x00_delayed_flags {
@@ -579,6 +584,7 @@ struct rt2x00lib_ops {
 	void (*link_tuner) (struct rt2x00_dev *rt2x00dev,
 			    struct link_qual *qual, const u32 count);
 	void (*gain_calibration) (struct rt2x00_dev *rt2x00dev);
+	void (*vco_calibration) (struct rt2x00_dev *rt2x00dev);
 
 	/*
 	 * Data queue handlers.
@@ -721,6 +727,7 @@ enum rt2x00_capability_flags {
 	CAPABILITY_EXTERNAL_LNA_BG,
 	CAPABILITY_DOUBLE_ANTENNA,
 	CAPABILITY_BT_COEXIST,
+	CAPABILITY_VCO_RECALIBRATION,
 };
 
 /*
@@ -979,6 +986,11 @@ struct rt2x00_dev {
 	struct tasklet_struct autowake_tasklet;
 
 	/*
+	 * Used for VCO periodic calibration.
+	 */
+	int rf_channel;
+
+	/*
 	 * Protect the interrupt mask register.
 	 */
 	spinlock_t irqmask_lock;
diff --git a/drivers/net/wireless/rt2x00/rt2x00config.c b/drivers/net/wireless/rt2x00/rt2x00config.c
index b704e5b..d7c0f86 100644
--- a/drivers/net/wireless/rt2x00/rt2x00config.c
+++ b/drivers/net/wireless/rt2x00/rt2x00config.c
@@ -232,6 +232,9 @@ void rt2x00lib_config(struct rt2x00_dev *rt2x00dev,
 		memcpy(&libconf.channel,
 		       &rt2x00dev->spec.channels_info[hw_value],
 		       sizeof(libconf.channel));
+
+		/* Used for VCO periodic calibration */
+		rt2x00dev->rf_channel = libconf.rf.channel;
 	}
 
 	if (test_bit(REQUIRE_PS_AUTOWAKE, &rt2x00dev->cap_flags) &&
diff --git a/drivers/net/wireless/rt2x00/rt2x00dev.c b/drivers/net/wireless/rt2x00/rt2x00dev.c
index c3e1aa7..bb708ac 100644
--- a/drivers/net/wireless/rt2x00/rt2x00dev.c
+++ b/drivers/net/wireless/rt2x00/rt2x00dev.c
@@ -88,6 +88,8 @@ int rt2x00lib_enable_radio(struct rt2x00_dev *rt2x00dev)
 	rt2x00queue_start_queues(rt2x00dev);
 	rt2x00link_start_tuner(rt2x00dev);
 	rt2x00link_start_agc(rt2x00dev);
+	if (test_bit(CAPABILITY_VCO_RECALIBRATION, &rt2x00dev->cap_flags))
+		rt2x00link_start_vcocal(rt2x00dev);
 
 	/*
 	 * Start watchdog monitoring.
@@ -111,6 +113,8 @@ void rt2x00lib_disable_radio(struct rt2x00_dev *rt2x00dev)
 	 * Stop all queues
 	 */
 	rt2x00link_stop_agc(rt2x00dev);
+	if (test_bit(CAPABILITY_VCO_RECALIBRATION, &rt2x00dev->cap_flags))
+		rt2x00link_stop_vcocal(rt2x00dev);
 	rt2x00link_stop_tuner(rt2x00dev);
 	rt2x00queue_stop_queues(rt2x00dev);
 	rt2x00queue_flush_queues(rt2x00dev, true);
diff --git a/drivers/net/wireless/rt2x00/rt2x00lib.h b/drivers/net/wireless/rt2x00/rt2x00lib.h
index 4cdf247..78bd43b 100644
--- a/drivers/net/wireless/rt2x00/rt2x00lib.h
+++ b/drivers/net/wireless/rt2x00/rt2x00lib.h
@@ -33,6 +33,7 @@
 #define WATCHDOG_INTERVAL	round_jiffies_relative(HZ)
 #define LINK_TUNE_INTERVAL	round_jiffies_relative(HZ)
 #define AGC_INTERVAL		round_jiffies_relative(4 * HZ)
+#define VCO_INTERVAL		round_jiffies_relative(10 * HZ) /* 10 sec */
 
 /*
  * rt2x00_rate: Per rate device information
@@ -278,12 +279,24 @@ void rt2x00link_stop_watchdog(struct rt2x00_dev *rt2x00dev);
 void rt2x00link_start_agc(struct rt2x00_dev *rt2x00dev);
 
 /**
+ * rt2x00link_start_vcocal - Start periodic VCO calibration
+ * @rt2x00dev: Pointer to &struct rt2x00_dev.
+ */
+void rt2x00link_start_vcocal(struct rt2x00_dev *rt2x00dev);
+
+/**
  * rt2x00link_stop_agc - Stop periodic gain calibration
  * @rt2x00dev: Pointer to &struct rt2x00_dev.
  */
 void rt2x00link_stop_agc(struct rt2x00_dev *rt2x00dev);
 
 /**
+ * rt2x00link_stop_vcocal - Stop periodic VCO calibration
+ * @rt2x00dev: Pointer to &struct rt2x00_dev.
+ */
+void rt2x00link_stop_vcocal(struct rt2x00_dev *rt2x00dev);
+
+/**
  * rt2x00link_register - Initialize link tuning & watchdog functionality
  * @rt2x00dev: Pointer to &struct rt2x00_dev.
  *
diff --git a/drivers/net/wireless/rt2x00/rt2x00link.c b/drivers/net/wireless/rt2x00/rt2x00link.c
index ea10b00..8368aab 100644
--- a/drivers/net/wireless/rt2x00/rt2x00link.c
+++ b/drivers/net/wireless/rt2x00/rt2x00link.c
@@ -447,11 +447,27 @@ void rt2x00link_start_agc(struct rt2x00_dev *rt2x00dev)
 					     AGC_INTERVAL);
 }
 
+void rt2x00link_start_vcocal(struct rt2x00_dev *rt2x00dev)
+{
+	struct link *link = &rt2x00dev->link;
+
+	if (test_bit(DEVICE_STATE_PRESENT, &rt2x00dev->flags) &&
+	    rt2x00dev->ops->lib->vco_calibration)
+		ieee80211_queue_delayed_work(rt2x00dev->hw,
+					     &link->vco_work,
+					     VCO_INTERVAL);
+}
+
 void rt2x00link_stop_agc(struct rt2x00_dev *rt2x00dev)
 {
 	cancel_delayed_work_sync(&rt2x00dev->link.agc_work);
 }
 
+void rt2x00link_stop_vcocal(struct rt2x00_dev *rt2x00dev)
+{
+	cancel_delayed_work_sync(&rt2x00dev->link.vco_work);
+}
+
 static void rt2x00link_agc(struct work_struct *work)
 {
 	struct rt2x00_dev *rt2x00dev =
@@ -473,9 +489,32 @@ static void rt2x00link_agc(struct work_struct *work)
 					     AGC_INTERVAL);
 }
 
+static void rt2x00link_vcocal(struct work_struct *work)
+{
+	struct rt2x00_dev *rt2x00dev =
+	    container_of(work, struct rt2x00_dev, link.vco_work.work);
+	struct link *link = &rt2x00dev->link;
+
+	/*
+	 * When the radio is shutting down we should
+	 * immediately cease the VCO calibration.
+	 */
+	if (!test_bit(DEVICE_STATE_ENABLED_RADIO, &rt2x00dev->flags))
+		return;
+
+	rt2x00dev->ops->lib->vco_calibration(rt2x00dev);
+
+	if (test_bit(DEVICE_STATE_PRESENT, &rt2x00dev->flags))
+		ieee80211_queue_delayed_work(rt2x00dev->hw,
+					     &link->vco_work,
+					     VCO_INTERVAL);
+}
+
 void rt2x00link_register(struct rt2x00_dev *rt2x00dev)
 {
 	INIT_DELAYED_WORK(&rt2x00dev->link.agc_work, rt2x00link_agc);
+	if (test_bit(CAPABILITY_VCO_RECALIBRATION, &rt2x00dev->cap_flags))
+		INIT_DELAYED_WORK(&rt2x00dev->link.vco_work, rt2x00link_vcocal);
 	INIT_DELAYED_WORK(&rt2x00dev->link.watchdog_work, rt2x00link_watchdog);
 	INIT_DELAYED_WORK(&rt2x00dev->link.work, rt2x00link_tuner);
 }
-- 
1.7.6.5

