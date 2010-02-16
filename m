Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.123]:53661 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757013Ab0BPR4x (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 16 Feb 2010 12:56:53 -0500
Date: Tue, 16 Feb 2010 11:56:50 -0600
From: Larry Finger <Larry.Finger@lwfinger.net>
To: John W Linville <linville@tuxdriver.com>
Cc: linux-wireless@vger.kernel.org,
	Bernhard Schiffner <bernhard@schiffner-limbach.de>
Subject: [PATCH 2/5] rtl8187se: Initial commit of device-specific header
Message-ID: <4b7adc62.sIGNUxz6G1v7Qmjn%Larry.Finger@lwfinger.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Create the device-specific header file for the RTL8187SE.

Signed-off-by: Larry Finger <Larry.Finger@lwfinger.net>
---

 rtl8187se.h |  167 ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
 1 file changed, 167 insertions(+)

Index: wireless-testing/drivers/net/wireless/rtl818x/rtl8187se.h
===================================================================
--- /dev/null
+++ wireless-testing/drivers/net/wireless/rtl818x/rtl8187se.h
@@ -0,0 +1,167 @@
+/*
+ * Definitions for RTL8187SE hardware
+ *
+ * Copyright 2010 Larry Finger <Larry.Finger@lwfinger.net>
+ *
+ * Based on the r8187 driver, which is:
+ * Copyright 2005 Andrea Merello <andreamrl@tiscali.it>, et al.
+ *
+ * Also based on the rtl8187 driver, which is:
+ * Copyright 2007 Michael Wu <flamingice@sourmilk.net>
+ * Copyright 2007 Andrea Merello <andreamrl@tiscali.it>
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License version 2 as
+ * published by the Free Software Foundation.
+ */
+
+#ifndef RTL8187SE_H
+#define RTL8187SE_H
+
+#include "rtl818x.h"
+#define PFX "rtl8187se: "
+
+#define MAX_RX_SIZE IEEE80211_MAX_RTS_THRESHOLD
+
+#define RF_PARAM_ANALOGPHY	(1 << 0)
+#define RF_PARAM_ANTBDEFAULT	(1 << 1)
+#define RF_PARAM_CARRIERSENSE1	(1 << 2)
+#define RF_PARAM_CARRIERSENSE2	(1 << 3)
+
+#define BB_ANTATTEN_CHAN14	0x0C
+#define BB_ANTENNA_B 		0x40
+
+#define BB_HOST_BANG 		(1 << 30)
+#define BB_HOST_BANG_EN 	(1 << 2)
+#define BB_HOST_BANG_CLK 	(1 << 1)
+#define BB_HOST_BANG_DATA	1
+
+#define ANAPARAM_TXDACOFF_SHIFT	27
+#define ANAPARAM_PWR0_SHIFT	28
+#define ANAPARAM_PWR0_MASK 	(0x07 << ANAPARAM_PWR0_SHIFT)
+#define ANAPARAM_PWR1_SHIFT	20
+#define ANAPARAM_PWR1_MASK	(0x7F << ANAPARAM_PWR1_SHIFT)
+#define ANAPARM_ASIC_ON		0xB0054D00
+#define ANAPARM2_ASIC_ON	0x000004C6
+
+#define RATE_FALLBACK_CTL_ENABLE	((1 << 7))
+#define RATE_FALLBACK_CTL_AUTO_STEP1	0x01
+
+struct rtl8187se_tx_desc {
+	__le32 flags;
+	__le16 rts_duration;
+	__le16 plcp_len;
+	__le32 tx_buf;
+	__le32 frame_len;
+	__le32 next_tx_desc;
+	u8 cw;
+	u8 retry_limit;
+	u8 agc;
+	u8 flags2;
+	u32 reserved[2];
+} __attribute__ ((packed));
+
+struct rtl8187se_rx_desc {
+	__le32 flags;
+	__le32 flags2;
+	union {
+		__le32 rx_buf;
+		__le64 tsft;
+	};
+} __attribute__ ((packed));
+
+struct rtl8187se_tx_ring {
+	struct rtl8187se_tx_desc *desc;
+	dma_addr_t dma;
+	unsigned int idx;
+	unsigned int entries;
+	struct sk_buff_head queue;
+};
+
+struct rtl8187se_priv {
+	/* common between rtl818x drivers */
+	struct rtl818x_csr __iomem *map;
+	const struct rtl818x_rf_ops *rf;
+	struct ieee80211_vif *vif;
+	int mode;
+	u32 IntMask;
+
+	/* rtl8187se driver specific */
+	struct mutex conf_mutex;
+	spinlock_t lock;
+	struct rtl8187se_rx_desc *rx_ring;
+	dma_addr_t rx_ring_dma;
+	unsigned int rx_idx;
+	struct sk_buff *rx_buf[32];
+	struct rtl8187se_tx_ring tx_ring[4];
+	struct ieee80211_channel channels[14];
+	struct ieee80211_rate rates[12];
+	struct ieee80211_supported_band band;
+	struct pci_dev *pdev;
+	u32 rx_conf;
+	u32 rx_config;
+	u32 anaparam;
+	u16 rfparam;
+	u16 therm_meter;
+	u8 ofdm_txpwr_base;
+	u8 cck_txpwr_base;
+	u8 csthreshold;
+	u8 xtal_cal_out;
+	u8 xtal_cal_in;
+	u8 init_gain;
+	u8 init_gain_bkup;
+	u8 rf_prog_type;
+	u8 cur_ant;
+	u8 def_antenna;
+	bool rfkill_off;
+	bool ant_diver;
+	bool xtal_cal;
+	bool tx_pwr_track;
+};
+
+void rtl8187se_write_phy(struct ieee80211_hw *dev, u8 addr, u32 data);
+void rtl8187se_set_anaparam(struct rtl8187se_priv *priv, u32 anaparam);
+
+static inline u8 rtl818x_ioread8(struct rtl8187se_priv *priv, u8 __iomem *addr)
+{
+	return ioread8(addr);
+}
+
+static inline u16 rtl818x_ioread16(struct rtl8187se_priv *priv,
+				   __le16 __iomem *addr)
+{
+	return ioread16(addr);
+}
+
+static inline u32 rtl818x_ioread32(struct rtl8187se_priv *priv,
+				    __le32 __iomem *addr)
+{
+	return ioread32(addr);
+}
+
+static inline void rtl818x_iowrite8(struct rtl8187se_priv *priv,
+				    u8 __iomem *addr, u8 val)
+{
+	iowrite8(val, addr);
+}
+
+static inline void rtl818x_iowrite16(struct rtl8187se_priv *priv,
+				     __le16 __iomem *addr, u16 val)
+{
+	iowrite16(val, addr);
+}
+
+static inline void rtl818x_iowrite32(struct rtl8187se_priv *priv,
+				     __le32 __iomem *addr, u32 val)
+{
+	iowrite32(val, addr);
+}
+
+static inline void force_pci_posting(struct rtl8187se_priv *priv)
+{
+	rtl818x_ioread8(priv, &priv->map->EEPROM_CMD);
+	mb();
+}
+
+#endif /* RTL8187SE_H */
+
