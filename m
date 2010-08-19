Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.atheros.com ([12.36.123.2]:21922 "EHLO mail.atheros.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751018Ab0HSFu7 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 19 Aug 2010 01:50:59 -0400
Received: from mail.atheros.com ([10.10.20.105])
	by sidewinder.atheros.com
	for <linux-wireless@vger.kernel.org>; Wed, 18 Aug 2010 22:50:59 -0700
From: Vivek Natarajan <vnatarajan@atheros.com>
To: <linville@tuxdriver.com>
CC: <linux-wireless@vger.kernel.org>
Subject: [PATCH 2/2 v2] ath9k_htc: Add support for bluetooth coexistence.
Date: Thu, 19 Aug 2010 11:20:45 +0530
Message-ID: <1282197045-4473-2-git-send-email-vnatarajan@atheros.com>
In-Reply-To: <1282197045-4473-1-git-send-email-vnatarajan@atheros.com>
References: <1282197045-4473-1-git-send-email-vnatarajan@atheros.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Signed-off-by: Vivek Natarajan <vnatarajan@atheros.com>
---
 drivers/net/wireless/ath/ath9k/Makefile       |    3 +-
 drivers/net/wireless/ath/ath9k/btcoex.c       |    7 ++
 drivers/net/wireless/ath/ath9k/hif_usb.c      |    3 +-
 drivers/net/wireless/ath/ath9k/htc.h          |   42 ++++++---
 drivers/net/wireless/ath/ath9k/htc_drv_gpio.c |  133 +++++++++++++++++++++++++
 drivers/net/wireless/ath/ath9k/htc_drv_init.c |   42 +++++++-
 drivers/net/wireless/ath/ath9k/htc_drv_main.c |   12 +++
 drivers/net/wireless/ath/ath9k/htc_hst.c      |    4 +-
 drivers/net/wireless/ath/ath9k/htc_hst.h      |    2 +-
 drivers/net/wireless/ath/ath9k/wmi.c          |    2 +
 drivers/net/wireless/ath/ath9k/wmi.h          |    1 +
 11 files changed, 229 insertions(+), 22 deletions(-)
 create mode 100644 drivers/net/wireless/ath/ath9k/htc_drv_gpio.c

diff --git a/drivers/net/wireless/ath/ath9k/Makefile b/drivers/net/wireless/ath/ath9k/Makefile
index 973ae4f..4555e99 100644
--- a/drivers/net/wireless/ath/ath9k/Makefile
+++ b/drivers/net/wireless/ath/ath9k/Makefile
@@ -46,6 +46,7 @@ ath9k_htc-y +=	htc_hst.o \
 		htc_drv_txrx.o \
 		htc_drv_main.o \
 		htc_drv_beacon.o \
-		htc_drv_init.o
+		htc_drv_init.o \
+		htc_drv_gpio.o
 
 obj-$(CONFIG_ATH9K_HTC) += ath9k_htc.o
diff --git a/drivers/net/wireless/ath/ath9k/btcoex.c b/drivers/net/wireless/ath/ath9k/btcoex.c
index fb4ac15..6a92e57 100644
--- a/drivers/net/wireless/ath/ath9k/btcoex.c
+++ b/drivers/net/wireless/ath/ath9k/btcoex.c
@@ -168,6 +168,7 @@ EXPORT_SYMBOL(ath9k_hw_btcoex_set_weight);
 static void ath9k_hw_btcoex_enable_3wire(struct ath_hw *ah)
 {
 	struct ath_btcoex_hw *btcoex_hw = &ah->btcoex_hw;
+	u32  val;
 
 	/*
 	 * Program coex mode and weight registers to
@@ -177,6 +178,12 @@ static void ath9k_hw_btcoex_enable_3wire(struct ath_hw *ah)
 	REG_WRITE(ah, AR_BT_COEX_WEIGHT, btcoex_hw->bt_coex_weights);
 	REG_WRITE(ah, AR_BT_COEX_MODE2, btcoex_hw->bt_coex_mode2);
 
+	if (AR_SREV_9271(ah)) {
+		val = REG_READ(ah, 0x50040);
+		val &= 0xFFFFFEFF;
+		REG_WRITE(ah, 0x50040, val);
+	}
+
 	REG_RMW_FIELD(ah, AR_QUIET1, AR_QUIET1_QUIET_ACK_CTS_ENABLE, 1);
 	REG_RMW_FIELD(ah, AR_PCU_MISC, AR_PCU_BT_ANT_PREVENT_RX, 0);
 
diff --git a/drivers/net/wireless/ath/ath9k/hif_usb.c b/drivers/net/wireless/ath/ath9k/hif_usb.c
index 17e7a9a..495f189 100644
--- a/drivers/net/wireless/ath/ath9k/hif_usb.c
+++ b/drivers/net/wireless/ath/ath9k/hif_usb.c
@@ -920,7 +920,8 @@ static int ath9k_hif_usb_probe(struct usb_interface *interface,
 	}
 
 	ret = ath9k_htc_hw_init(hif_dev->htc_handle,
-				&hif_dev->udev->dev, hif_dev->device_id);
+				&hif_dev->udev->dev, hif_dev->device_id,
+				hif_dev->udev->product);
 	if (ret) {
 		ret = -EINVAL;
 		goto err_htc_hw_init;
diff --git a/drivers/net/wireless/ath/ath9k/htc.h b/drivers/net/wireless/ath/ath9k/htc.h
index 43b9e21..75ecf6a 100644
--- a/drivers/net/wireless/ath/ath9k/htc.h
+++ b/drivers/net/wireless/ath/ath9k/htc.h
@@ -316,17 +316,32 @@ struct htc_beacon_config {
 	u8 dtim_count;
 };
 
-#define OP_INVALID        BIT(0)
-#define OP_SCANNING       BIT(1)
-#define OP_FULL_RESET     BIT(2)
-#define OP_LED_ASSOCIATED BIT(3)
-#define OP_LED_ON         BIT(4)
-#define OP_PREAMBLE_SHORT BIT(5)
-#define OP_PROTECT_ENABLE BIT(6)
-#define OP_ASSOCIATED     BIT(7)
-#define OP_ENABLE_BEACON  BIT(8)
-#define OP_LED_DEINIT     BIT(9)
-#define OP_UNPLUGGED      BIT(10)
+struct ath_btcoex {
+	u32 bt_priority_cnt;
+	unsigned long bt_priority_time;
+	int bt_stomp_type; /* Types of BT stomping */
+	u32 btcoex_no_stomp;
+	u32 btcoex_period;
+	u32 btscan_no_stomp;
+};
+
+void ath_htc_init_btcoex_work(struct ath9k_htc_priv *priv);
+void ath_htc_resume_btcoex_work(struct ath9k_htc_priv *priv);
+void ath_htc_cancel_btcoex_work(struct ath9k_htc_priv *priv);
+
+#define OP_INVALID		   BIT(0)
+#define OP_SCANNING		   BIT(1)
+#define OP_FULL_RESET		   BIT(2)
+#define OP_LED_ASSOCIATED	   BIT(3)
+#define OP_LED_ON		   BIT(4)
+#define OP_PREAMBLE_SHORT	   BIT(5)
+#define OP_PROTECT_ENABLE	   BIT(6)
+#define OP_ASSOCIATED		   BIT(7)
+#define OP_ENABLE_BEACON	   BIT(8)
+#define OP_LED_DEINIT		   BIT(9)
+#define OP_UNPLUGGED		   BIT(10)
+#define OP_BT_PRIORITY_DETECTED	   BIT(11)
+#define OP_BT_SCAN		   BIT(12)
 
 struct ath9k_htc_priv {
 	struct device *dev;
@@ -391,6 +406,9 @@ struct ath9k_htc_priv {
 	int cabq;
 	int hwq_map[WME_NUM_AC];
 
+	struct ath_btcoex btcoex;
+	struct delayed_work coex_period_work;
+	struct delayed_work duty_cycle_work;
 #ifdef CONFIG_ATH9K_HTC_DEBUGFS
 	struct ath9k_debug debug;
 #endif
@@ -443,7 +461,7 @@ void ath9k_init_leds(struct ath9k_htc_priv *priv);
 void ath9k_deinit_leds(struct ath9k_htc_priv *priv);
 
 int ath9k_htc_probe_device(struct htc_target *htc_handle, struct device *dev,
-			   u16 devid);
+			   u16 devid, char *product);
 void ath9k_htc_disconnect_device(struct htc_target *htc_handle, bool hotunplug);
 #ifdef CONFIG_PM
 int ath9k_htc_resume(struct htc_target *htc_handle);
diff --git a/drivers/net/wireless/ath/ath9k/htc_drv_gpio.c b/drivers/net/wireless/ath/ath9k/htc_drv_gpio.c
new file mode 100644
index 0000000..6fca4e0
--- /dev/null
+++ b/drivers/net/wireless/ath/ath9k/htc_drv_gpio.c
@@ -0,0 +1,133 @@
+#include "htc.h"
+
+/******************/
+/*     BTCOEX     */
+/******************/
+
+/*
+ * Detects if there is any priority bt traffic
+ */
+static void ath_detect_bt_priority(struct ath9k_htc_priv *priv)
+{
+	struct ath_btcoex *btcoex = &priv->btcoex;
+	struct ath_hw *ah = priv->ah;
+
+	if (ath9k_hw_gpio_get(ah, ah->btcoex_hw.btpriority_gpio))
+		btcoex->bt_priority_cnt++;
+
+	if (time_after(jiffies, btcoex->bt_priority_time +
+			msecs_to_jiffies(ATH_BT_PRIORITY_TIME_THRESHOLD))) {
+		priv->op_flags &= ~(OP_BT_PRIORITY_DETECTED | OP_BT_SCAN);
+		/* Detect if colocated bt started scanning */
+		if (btcoex->bt_priority_cnt >= ATH_BT_CNT_SCAN_THRESHOLD) {
+			ath_print(ath9k_hw_common(ah), ATH_DBG_BTCOEX,
+				  "BT scan detected");
+			priv->op_flags |= (OP_BT_SCAN |
+					 OP_BT_PRIORITY_DETECTED);
+		} else if (btcoex->bt_priority_cnt >= ATH_BT_CNT_THRESHOLD) {
+			ath_print(ath9k_hw_common(ah), ATH_DBG_BTCOEX,
+				    "BT priority traffic detected");
+			priv->op_flags |= OP_BT_PRIORITY_DETECTED;
+		}
+
+		btcoex->bt_priority_cnt = 0;
+		btcoex->bt_priority_time = jiffies;
+	}
+}
+
+/*
+ * This is the master bt coex work which runs for every
+ * 45ms, bt traffic will be given priority during 55% of this
+ * period while wlan gets remaining 45%
+ */
+static void ath_btcoex_period_work(struct work_struct *work)
+{
+	struct ath9k_htc_priv *priv = container_of(work, struct ath9k_htc_priv,
+						   coex_period_work.work);
+	struct ath_btcoex *btcoex = &priv->btcoex;
+	struct ath_common *common = ath9k_hw_common(priv->ah);
+	u32 timer_period;
+	bool is_btscan;
+	int ret;
+	u8 cmd_rsp, aggr;
+
+	ath_detect_bt_priority(priv);
+
+	is_btscan = !!(priv->op_flags & OP_BT_SCAN);
+
+	aggr = priv->op_flags & OP_BT_PRIORITY_DETECTED;
+
+	WMI_CMD_BUF(WMI_AGGR_LIMIT_CMD, &aggr);
+
+	ath9k_cmn_btcoex_bt_stomp(common, is_btscan ? ATH_BTCOEX_STOMP_ALL :
+			btcoex->bt_stomp_type);
+
+	timer_period = is_btscan ? btcoex->btscan_no_stomp :
+		btcoex->btcoex_no_stomp;
+	ieee80211_queue_delayed_work(priv->hw, &priv->duty_cycle_work,
+				     msecs_to_jiffies(timer_period));
+	ieee80211_queue_delayed_work(priv->hw, &priv->coex_period_work,
+				     msecs_to_jiffies(btcoex->btcoex_period));
+}
+
+/*
+ * Work to time slice between wlan and bt traffic and
+ * configure weight registers
+ */
+static void ath_btcoex_duty_cycle_work(struct work_struct *work)
+{
+	struct ath9k_htc_priv *priv = container_of(work, struct ath9k_htc_priv,
+						   duty_cycle_work.work);
+	struct ath_hw *ah = priv->ah;
+	struct ath_btcoex *btcoex = &priv->btcoex;
+	struct ath_common *common = ath9k_hw_common(ah);
+	bool is_btscan = priv->op_flags & OP_BT_SCAN;
+
+	ath_print(common, ATH_DBG_BTCOEX,
+		  "time slice work for bt and wlan\n");
+
+	if (btcoex->bt_stomp_type == ATH_BTCOEX_STOMP_LOW || is_btscan)
+		ath9k_cmn_btcoex_bt_stomp(common, ATH_BTCOEX_STOMP_NONE);
+	else if (btcoex->bt_stomp_type == ATH_BTCOEX_STOMP_ALL)
+		ath9k_cmn_btcoex_bt_stomp(common, ATH_BTCOEX_STOMP_LOW);
+}
+
+void ath_htc_init_btcoex_work(struct ath9k_htc_priv *priv)
+{
+	struct ath_btcoex *btcoex = &priv->btcoex;
+
+	btcoex->btcoex_period = ATH_BTCOEX_DEF_BT_PERIOD;
+	btcoex->btcoex_no_stomp = (100 - ATH_BTCOEX_DEF_DUTY_CYCLE) *
+		btcoex->btcoex_period / 100;
+	btcoex->btscan_no_stomp = (100 - ATH_BTCOEX_BTSCAN_DUTY_CYCLE) *
+				   btcoex->btcoex_period / 100;
+	INIT_DELAYED_WORK(&priv->coex_period_work, ath_btcoex_period_work);
+	INIT_DELAYED_WORK(&priv->duty_cycle_work, ath_btcoex_duty_cycle_work);
+}
+
+/*
+ * (Re)start btcoex work
+ */
+void ath_htc_resume_btcoex_work(struct ath9k_htc_priv *priv)
+{
+	struct ath_btcoex *btcoex = &priv->btcoex;
+	struct ath_hw *ah = priv->ah;
+
+	ath_print(ath9k_hw_common(ah), ATH_DBG_BTCOEX,
+		  "Starting btcoex work");
+
+	btcoex->bt_priority_cnt = 0;
+	btcoex->bt_priority_time = jiffies;
+	priv->op_flags &= ~(OP_BT_PRIORITY_DETECTED | OP_BT_SCAN);
+	ieee80211_queue_delayed_work(priv->hw, &priv->coex_period_work, 0);
+}
+
+/*
+ * Cancel btcoex and bt duty cycle work.
+ */
+void ath_htc_cancel_btcoex_work(struct ath9k_htc_priv *priv)
+{
+	cancel_delayed_work_sync(&priv->coex_period_work);
+	cancel_delayed_work_sync(&priv->duty_cycle_work);
+
+}
diff --git a/drivers/net/wireless/ath/ath9k/htc_drv_init.c b/drivers/net/wireless/ath/ath9k/htc_drv_init.c
index 2d42791..695e2b0 100644
--- a/drivers/net/wireless/ath/ath9k/htc_drv_init.c
+++ b/drivers/net/wireless/ath/ath9k/htc_drv_init.c
@@ -41,6 +41,8 @@ MODULE_PARM_DESC(nohwcrypt, "Disable hardware encryption");
 	.max_power = 20, \
 }
 
+#define ATH_HTC_BTCOEX_PRODUCT_ID "wb193"
+
 static struct ieee80211_channel ath9k_2ghz_channels[] = {
 	CHAN2G(2412, 0), /* Channel 1 */
 	CHAN2G(2417, 1), /* Channel 2 */
@@ -605,7 +607,31 @@ static void ath9k_init_misc(struct ath9k_htc_priv *priv)
 	priv->ah->opmode = NL80211_IFTYPE_STATION;
 }
 
-static int ath9k_init_priv(struct ath9k_htc_priv *priv, u16 devid)
+static void ath9k_init_btcoex(struct ath9k_htc_priv *priv)
+{
+	int qnum;
+
+	switch (priv->ah->btcoex_hw.scheme) {
+	case ATH_BTCOEX_CFG_NONE:
+		break;
+	case ATH_BTCOEX_CFG_3WIRE:
+		priv->ah->btcoex_hw.btactive_gpio = 7;
+		priv->ah->btcoex_hw.btpriority_gpio = 6;
+		priv->ah->btcoex_hw.wlanactive_gpio = 8;
+		priv->btcoex.bt_stomp_type = ATH_BTCOEX_STOMP_LOW;
+		ath9k_hw_btcoex_init_3wire(priv->ah);
+		ath_htc_init_btcoex_work(priv);
+		qnum = priv->hwq_map[WME_AC_BE];
+		ath9k_hw_init_btcoex_hw(priv->ah, qnum);
+		break;
+	default:
+		WARN_ON(1);
+		break;
+	}
+}
+
+static int ath9k_init_priv(struct ath9k_htc_priv *priv,
+			   u16 devid, char *product)
 {
 	struct ath_hw *ah = NULL;
 	struct ath_common *common;
@@ -672,6 +698,11 @@ static int ath9k_init_priv(struct ath9k_htc_priv *priv, u16 devid)
 	ath9k_init_channels_rates(priv);
 	ath9k_init_misc(priv);
 
+	if (product && strncmp(product, ATH_HTC_BTCOEX_PRODUCT_ID, 5) == 0) {
+		ah->btcoex_hw.scheme = ATH_BTCOEX_CFG_3WIRE;
+		ath9k_init_btcoex(priv);
+	}
+
 	return 0;
 
 err_queues:
@@ -734,7 +765,8 @@ static void ath9k_set_hw_capab(struct ath9k_htc_priv *priv,
 	SET_IEEE80211_PERM_ADDR(hw, common->macaddr);
 }
 
-static int ath9k_init_device(struct ath9k_htc_priv *priv, u16 devid)
+static int ath9k_init_device(struct ath9k_htc_priv *priv,
+			     u16 devid, char *product)
 {
 	struct ieee80211_hw *hw = priv->hw;
 	struct ath_common *common;
@@ -743,7 +775,7 @@ static int ath9k_init_device(struct ath9k_htc_priv *priv, u16 devid)
 	struct ath_regulatory *reg;
 
 	/* Bring up device */
-	error = ath9k_init_priv(priv, devid);
+	error = ath9k_init_priv(priv, devid, product);
 	if (error != 0)
 		goto err_init;
 
@@ -801,7 +833,7 @@ err_init:
 }
 
 int ath9k_htc_probe_device(struct htc_target *htc_handle, struct device *dev,
-			   u16 devid)
+			   u16 devid, char *product)
 {
 	struct ieee80211_hw *hw;
 	struct ath9k_htc_priv *priv;
@@ -835,7 +867,7 @@ int ath9k_htc_probe_device(struct htc_target *htc_handle, struct device *dev,
 	/* The device may have been unplugged earlier. */
 	priv->op_flags &= ~OP_UNPLUGGED;
 
-	ret = ath9k_init_device(priv, devid);
+	ret = ath9k_init_device(priv, devid, product);
 	if (ret)
 		goto err_init;
 
diff --git a/drivers/net/wireless/ath/ath9k/htc_drv_main.c b/drivers/net/wireless/ath/ath9k/htc_drv_main.c
index 4e345be..5e318cb 100644
--- a/drivers/net/wireless/ath/ath9k/htc_drv_main.c
+++ b/drivers/net/wireless/ath/ath9k/htc_drv_main.c
@@ -1210,6 +1210,12 @@ static int ath9k_htc_start(struct ieee80211_hw *hw)
 
 	ieee80211_wake_queues(hw);
 
+	if (ah->btcoex_hw.scheme == ATH_BTCOEX_CFG_3WIRE) {
+		ath9k_hw_btcoex_set_weight(ah, AR_BT_COEX_WGHT,
+					   AR_STOMP_LOW_WLAN_WGHT);
+		ath9k_hw_btcoex_enable(ah);
+		ath_htc_resume_btcoex_work(priv);
+	}
 	mutex_unlock(&priv->mutex);
 
 	return ret;
@@ -1254,6 +1260,12 @@ static void ath9k_htc_stop(struct ieee80211_hw *hw)
 				  "Monitor interface removed\n");
 	}
 
+	if (ah->btcoex_hw.enabled) {
+		ath9k_hw_btcoex_disable(ah);
+		if (ah->btcoex_hw.scheme == ATH_BTCOEX_CFG_3WIRE)
+			ath_htc_cancel_btcoex_work(priv);
+	}
+
 	ath9k_hw_phy_disable(ah);
 	ath9k_hw_disable(ah);
 	ath9k_hw_configpcipowersave(ah, 1, 1);
diff --git a/drivers/net/wireless/ath/ath9k/htc_hst.c b/drivers/net/wireless/ath/ath9k/htc_hst.c
index 705c0f3..861ec92 100644
--- a/drivers/net/wireless/ath/ath9k/htc_hst.c
+++ b/drivers/net/wireless/ath/ath9k/htc_hst.c
@@ -462,9 +462,9 @@ void ath9k_htc_hw_free(struct htc_target *htc)
 }
 
 int ath9k_htc_hw_init(struct htc_target *target,
-		      struct device *dev, u16 devid)
+		      struct device *dev, u16 devid, char *product)
 {
-	if (ath9k_htc_probe_device(target, dev, devid)) {
+	if (ath9k_htc_probe_device(target, dev, devid, product)) {
 		printk(KERN_ERR "Failed to initialize the device\n");
 		return -ENODEV;
 	}
diff --git a/drivers/net/wireless/ath/ath9k/htc_hst.h b/drivers/net/wireless/ath/ath9k/htc_hst.h
index faba679..07b6509 100644
--- a/drivers/net/wireless/ath/ath9k/htc_hst.h
+++ b/drivers/net/wireless/ath/ath9k/htc_hst.h
@@ -239,7 +239,7 @@ struct htc_target *ath9k_htc_hw_alloc(void *hif_handle,
 				      struct device *dev);
 void ath9k_htc_hw_free(struct htc_target *htc);
 int ath9k_htc_hw_init(struct htc_target *target,
-		      struct device *dev, u16 devid);
+		      struct device *dev, u16 devid, char *product);
 void ath9k_htc_hw_deinit(struct htc_target *target, bool hot_unplug);
 
 #endif /* HTC_HST_H */
diff --git a/drivers/net/wireless/ath/ath9k/wmi.c b/drivers/net/wireless/ath/ath9k/wmi.c
index 6260faa..45fe9ca 100644
--- a/drivers/net/wireless/ath/ath9k/wmi.c
+++ b/drivers/net/wireless/ath/ath9k/wmi.c
@@ -85,6 +85,8 @@ static const char *wmi_cmd_to_name(enum wmi_cmd_id wmi_cmd)
 		return "WMI_TGT_DETACH_CMDID";
 	case WMI_TGT_TXQ_ENABLE_CMDID:
 		return "WMI_TGT_TXQ_ENABLE_CMDID";
+	case WMI_AGGR_LIMIT_CMD:
+		return "WMI_AGGR_LIMIT_CMD";
 	}
 
 	return "Bogus";
diff --git a/drivers/net/wireless/ath/ath9k/wmi.h b/drivers/net/wireless/ath/ath9k/wmi.h
index 765db5f..a0bf857 100644
--- a/drivers/net/wireless/ath/ath9k/wmi.h
+++ b/drivers/net/wireless/ath/ath9k/wmi.h
@@ -71,6 +71,7 @@ enum wmi_cmd_id {
 	WMI_TX_AGGR_ENABLE_CMDID,
 	WMI_TGT_DETACH_CMDID,
 	WMI_TGT_TXQ_ENABLE_CMDID,
+	WMI_AGGR_LIMIT_CMD = 0x0026,
 };
 
 enum wmi_event_id {
-- 
1.6.3.3

