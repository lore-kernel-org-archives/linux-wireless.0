Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.125]:62834 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751777AbZFWPjh (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 23 Jun 2009 11:39:37 -0400
Date: Tue, 23 Jun 2009 10:39:45 -0500
From: Larry Finger <Larry.Finger@lwfinger.net>
To: John W Linville <linville@tuxdriver.com>, chunkeey@web.de
Cc: linux-wireless@vger.kernel.org
Subject: [PATCH 8/8] p54: Modify p54 files for new organization
Message-ID: <4a40f741.0qPsXxY4NQ0toaFq%Larry.Finger@lwfinger.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Christian Lamparter <chunkeey@web.de>

Modify the remaining p54 files to account for the new file organization.

Signed-off-by: Christian Lamparter <chunkeey@web.de>
Signed-off-by: Larry Finger <Larry.Finger@lwfinger.net>
---

John,

This patch should also include the following git statements:

git rm drivers/net/wireless/p54/p54common.c
git rm drivers/net/wireless/p54/p54common.h

Larry
---

diff --git a/drivers/net/wireless/p54/Makefile b/drivers/net/wireless/p54/Makefile
index c2050de..b542e68 100644
--- a/drivers/net/wireless/p54/Makefile
+++ b/drivers/net/wireless/p54/Makefile
@@ -1,3 +1,6 @@
+p54common-objs			:= eeprom.o fwio.o txrx.o main.o
+p54common-$(CONFIG_P54_LEDS)	+= led.o
+
 obj-$(CONFIG_P54_COMMON)	+= p54common.o
 obj-$(CONFIG_P54_USB)		+= p54usb.o
 obj-$(CONFIG_P54_PCI)		+= p54pci.o
diff --git a/drivers/net/wireless/p54/p54.h b/drivers/net/wireless/p54/p54.h
index db3df94..19d085c 100644
--- a/drivers/net/wireless/p54/p54.h
+++ b/drivers/net/wireless/p54/p54.h
@@ -1,6 +1,3 @@
-#ifndef P54_H
-#define P54_H
-
 /*
  * Shared defines for all mac80211 Prism54 code
  *
@@ -14,39 +11,78 @@
  * published by the Free Software Foundation.
  */
 
+#ifndef P54_H
+#define P54_H
+
 #ifdef CONFIG_P54_LEDS
 #include <linux/leds.h>
 #endif /* CONFIG_P54_LEDS */
 
-enum p54_control_frame_types {
-	P54_CONTROL_TYPE_SETUP = 0,
-	P54_CONTROL_TYPE_SCAN,
-	P54_CONTROL_TYPE_TRAP,
-	P54_CONTROL_TYPE_DCFINIT,
-	P54_CONTROL_TYPE_RX_KEYCACHE,
-	P54_CONTROL_TYPE_TIM,
-	P54_CONTROL_TYPE_PSM,
-	P54_CONTROL_TYPE_TXCANCEL,
-	P54_CONTROL_TYPE_TXDONE,
-	P54_CONTROL_TYPE_BURST,
-	P54_CONTROL_TYPE_STAT_READBACK,
-	P54_CONTROL_TYPE_BBP,
-	P54_CONTROL_TYPE_EEPROM_READBACK,
-	P54_CONTROL_TYPE_LED,
-	P54_CONTROL_TYPE_GPIO,
-	P54_CONTROL_TYPE_TIMER,
-	P54_CONTROL_TYPE_MODULATION,
-	P54_CONTROL_TYPE_SYNTH_CONFIG,
-	P54_CONTROL_TYPE_DETECTOR_VALUE,
-	P54_CONTROL_TYPE_XBOW_SYNTH_CFG,
-	P54_CONTROL_TYPE_CCE_QUIET,
-	P54_CONTROL_TYPE_PSM_STA_UNLOCK,
-	P54_CONTROL_TYPE_PCS,
-	P54_CONTROL_TYPE_BT_BALANCER = 28,
-	P54_CONTROL_TYPE_GROUP_ADDRESS_TABLE = 30,
-	P54_CONTROL_TYPE_ARPTABLE = 31,
-	P54_CONTROL_TYPE_BT_OPTIONS = 35
-};
+#define ISL38XX_DEV_FIRMWARE_ADDR 0x20000
+
+#define BR_CODE_MIN			0x80000000
+#define BR_CODE_COMPONENT_ID		0x80000001
+#define BR_CODE_COMPONENT_VERSION	0x80000002
+#define BR_CODE_DEPENDENT_IF		0x80000003
+#define BR_CODE_EXPOSED_IF		0x80000004
+#define BR_CODE_DESCR			0x80000101
+#define BR_CODE_MAX			0x8FFFFFFF
+#define BR_CODE_END_OF_BRA		0xFF0000FF
+#define LEGACY_BR_CODE_END_OF_BRA	0xFFFFFFFF
+
+struct bootrec {
+	__le32 code;
+	__le32 len;
+	u32 data[10];
+} __packed;
+
+/* Interface role definitions */
+#define BR_INTERFACE_ROLE_SERVER	0x0000
+#define BR_INTERFACE_ROLE_CLIENT	0x8000
+
+#define BR_DESC_PRIV_CAP_WEP		BIT(0)
+#define BR_DESC_PRIV_CAP_TKIP		BIT(1)
+#define BR_DESC_PRIV_CAP_MICHAEL	BIT(2)
+#define BR_DESC_PRIV_CAP_CCX_CP		BIT(3)
+#define BR_DESC_PRIV_CAP_CCX_MIC	BIT(4)
+#define BR_DESC_PRIV_CAP_AESCCMP	BIT(5)
+
+struct bootrec_desc {
+	__le16 modes;
+	__le16 flags;
+	__le32 rx_start;
+	__le32 rx_end;
+	u8 headroom;
+	u8 tailroom;
+	u8 tx_queues;
+	u8 tx_depth;
+	u8 privacy_caps;
+	u8 rx_keycache_size;
+	u8 time_size;
+	u8 padding;
+	u8 rates[16];
+	u8 padding2[4];
+	__le16 rx_mtu;
+} __packed;
+
+#define FW_FMAC 0x464d4143
+#define FW_LM86 0x4c4d3836
+#define FW_LM87 0x4c4d3837
+#define FW_LM20 0x4c4d3230
+
+struct bootrec_comp_id {
+	__le32 fw_variant;
+} __packed;
+
+struct bootrec_comp_ver {
+	char fw_version[24];
+} __packed;
+
+struct bootrec_end {
+	__le16 crc;
+	u8 padding[2];
+	u8 md5[16];
+} __packed;
 
 /* provide 16 bytes for the transport back-end */
 #define P54_TX_INFO_DATA_SIZE		16
@@ -55,34 +91,30 @@ enum p54_control_frame_types {
 struct p54_tx_info {
 	u32 start_addr;
 	u32 end_addr;
-	void *data[P54_TX_INFO_DATA_SIZE / sizeof(void *)];
+	union {
+		void *data[P54_TX_INFO_DATA_SIZE / sizeof(void *)];
+		struct {
+			u32 extra_len;
+		};
+	};
 };
 
 #define P54_MAX_CTRL_FRAME_LEN		0x1000
 
-#define P54_HDR_FLAG_CONTROL		BIT(15)
-#define P54_HDR_FLAG_CONTROL_OPSET	(BIT(15) + BIT(0))
-
-struct p54_hdr {
-	__le16 flags;
-	__le16 len;
-	__le32 req_id;
-	__le16 type;	/* enum p54_control_frame_types */
-	u8 rts_tries;
-	u8 tries;
-	u8 data[0];
-} __attribute__ ((packed));
-
-#define FREE_AFTER_TX(skb)						\
-	((((struct p54_hdr *) ((struct sk_buff *) skb)->data)->		\
-	flags) == cpu_to_le16(P54_HDR_FLAG_CONTROL_OPSET))
+#define P54_SET_QUEUE(queue, ai_fs, cw_min, cw_max, _txop)	\
+do {								\
+	queue.aifs = cpu_to_le16(ai_fs);			\
+	queue.cwmin = cpu_to_le16(cw_min);			\
+	queue.cwmax = cpu_to_le16(cw_max);			\
+	queue.txop = cpu_to_le16(_txop);			\
+} while (0)
 
 struct p54_edcf_queue_param {
 	__le16 aifs;
 	__le16 cwmin;
 	__le16 cwmax;
 	__le16 txop;
-} __attribute__ ((packed));
+} __packed;
 
 struct p54_rssi_linear_approximation {
 	s16 mul;
@@ -101,13 +133,6 @@ struct p54_cal_database {
 
 #define EEPROM_READBACK_LEN 0x3fc
 
-#define ISL38XX_DEV_FIRMWARE_ADDR 0x20000
-
-#define FW_FMAC 0x464d4143
-#define FW_LM86 0x4c4d3836
-#define FW_LM87 0x4c4d3837
-#define FW_LM20 0x4c4d3230
-
 enum fw_state {
 	FW_STATE_OFF,
 	FW_STATE_BOOTING,
@@ -138,6 +163,7 @@ struct p54_common {
 	void (*tx)(struct ieee80211_hw *dev, struct sk_buff *skb);
 	int (*open)(struct ieee80211_hw *dev);
 	void (*stop)(struct ieee80211_hw *dev);
+	struct sk_buff_head tx_pending;
 	struct sk_buff_head tx_queue;
 	struct mutex conf_mutex;
 
@@ -156,6 +182,7 @@ struct p54_common {
 
 	/* (e)DCF / QOS state */
 	bool use_short_slot;
+	spinlock_t tx_stats_lock;
 	struct ieee80211_tx_queue_stats tx_stats[8];
 	struct p54_edcf_queue_param qos_params[8];
 
@@ -181,7 +208,7 @@ struct p54_common {
 	u32 tsf_low32, tsf_high32;
 	u32 basic_rate_mask;
 	u16 aid;
-	struct sk_buff *cached_beacon;
+	__le32 beacon_req_id;
 
 	/* cryptographic engine information */
 	u8 privacy_caps;
@@ -202,15 +229,20 @@ struct p54_common {
 	/* eeprom handling */
 	void *eeprom;
 	struct completion eeprom_comp;
+	struct mutex eeprom_mutex;
 };
 
+/* interfaces for the drivers */
 int p54_rx(struct ieee80211_hw *dev, struct sk_buff *skb);
 void p54_free_skb(struct ieee80211_hw *dev, struct sk_buff *skb);
 int p54_parse_firmware(struct ieee80211_hw *dev, const struct firmware *fw);
 int p54_parse_eeprom(struct ieee80211_hw *dev, void *eeprom, int len);
 int p54_read_eeprom(struct ieee80211_hw *dev);
+
 struct ieee80211_hw *p54_init_common(size_t priv_data_len);
 int p54_register_common(struct ieee80211_hw *dev, struct device *pdev);
 void p54_free_common(struct ieee80211_hw *dev);
 
+void p54_unregister_common(struct ieee80211_hw *dev);
+
 #endif /* P54_H */
diff --git a/drivers/net/wireless/p54/p54pci.c b/drivers/net/wireless/p54/p54pci.c
index b1610ea..d348c26 100644
--- a/drivers/net/wireless/p54/p54pci.c
+++ b/drivers/net/wireless/p54/p54pci.c
@@ -22,6 +22,7 @@
 #include <net/mac80211.h>
 
 #include "p54.h"
+#include "lmac.h"
 #include "p54pci.h"
 
 MODULE_AUTHOR("Michael Wu <flamingice@sourmilk.net>");
@@ -564,7 +565,6 @@ static int __devinit p54p_probe(struct pci_dev *pdev,
 
  err_free_common:
 	release_firmware(priv->firmware);
-	p54_free_common(dev);
 	pci_free_consistent(pdev, sizeof(*priv->ring_control),
 			    priv->ring_control, priv->ring_control_dma);
 
@@ -573,7 +573,7 @@ static int __devinit p54p_probe(struct pci_dev *pdev,
 
  err_free_dev:
 	pci_set_drvdata(pdev, NULL);
-	ieee80211_free_hw(dev);
+	p54_free_common(dev);
 
  err_free_reg:
 	pci_release_regions(pdev);
@@ -590,16 +590,15 @@ static void __devexit p54p_remove(struct pci_dev *pdev)
 	if (!dev)
 		return;
 
-	ieee80211_unregister_hw(dev);
+	p54_unregister_common(dev);
 	priv = dev->priv;
 	release_firmware(priv->firmware);
 	pci_free_consistent(pdev, sizeof(*priv->ring_control),
 			    priv->ring_control, priv->ring_control_dma);
-	p54_free_common(dev);
 	iounmap(priv->map);
 	pci_release_regions(pdev);
 	pci_disable_device(pdev);
-	ieee80211_free_hw(dev);
+	p54_free_common(dev);
 }
 
 #ifdef CONFIG_PM
diff --git a/drivers/net/wireless/p54/p54spi.c b/drivers/net/wireless/p54/p54spi.c
index 83116ba..7ef191a 100644
--- a/drivers/net/wireless/p54/p54spi.c
+++ b/drivers/net/wireless/p54/p54spi.c
@@ -34,7 +34,7 @@
 #include "p54spi_eeprom.h"
 #include "p54.h"
 
-#include "p54common.h"
+#include "lmac.h"
 
 MODULE_FIRMWARE("3826.arm");
 MODULE_ALIAS("stlc45xx");
@@ -713,7 +713,7 @@ static int __devexit p54spi_remove(struct spi_device *spi)
 {
 	struct p54s_priv *priv = dev_get_drvdata(&spi->dev);
 
-	ieee80211_unregister_hw(priv->hw);
+	p54_unregister_common(priv->hw);
 
 	free_irq(gpio_to_irq(p54spi_gpio_irq), spi);
 
@@ -724,7 +724,6 @@ static int __devexit p54spi_remove(struct spi_device *spi)
 	mutex_destroy(&priv->mutex);
 
 	p54_free_common(priv->hw);
-	ieee80211_free_hw(priv->hw);
 
 	return 0;
 }
diff --git a/drivers/net/wireless/p54/p54usb.c b/drivers/net/wireless/p54/p54usb.c
index 0e877a1..461d88f 100644
--- a/drivers/net/wireless/p54/p54usb.c
+++ b/drivers/net/wireless/p54/p54usb.c
@@ -22,6 +22,7 @@
 #include <net/mac80211.h>
 
 #include "p54.h"
+#include "lmac.h"
 #include "p54usb.h"
 
 MODULE_AUTHOR("Michael Wu <flamingice@sourmilk.net>");
@@ -961,7 +962,7 @@ err_free_fw:
 	release_firmware(priv->fw);
 
 err_free_dev:
-	ieee80211_free_hw(dev);
+	p54_free_common(dev);
 	usb_set_intfdata(intf, NULL);
 	usb_put_dev(udev);
 	return err;
@@ -975,13 +976,12 @@ static void __devexit p54u_disconnect(struct usb_interface *intf)
 	if (!dev)
 		return;
 
-	ieee80211_unregister_hw(dev);
+	p54_unregister_common(dev);
 
 	priv = dev->priv;
 	usb_put_dev(interface_to_usbdev(intf));
 	release_firmware(priv->fw);
 	p54_free_common(dev);
-	ieee80211_free_hw(dev);
 }
 
 static int p54u_pre_reset(struct usb_interface *intf)


