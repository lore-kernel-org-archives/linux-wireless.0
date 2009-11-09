Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.124]:53799 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750928AbZKIX2X (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 9 Nov 2009 18:28:23 -0500
Date: Mon, 09 Nov 2009 17:28:23 -0600
From: Larry Finger <Larry.Finger@lwfinger.net>
To: John W Linville <linville@tuxdriver.com>
Cc: bzolnier@gmail.com,
	Bernhard Schiffner <bernhard@schiffner-limbach.de>,
	linux-wireless@vger.kernel.org
Subject: [RFT 0/6] rtl8187se: Create file rtl8187se.h
Message-ID: <4af8a597.+//pAC+FCJEc4o5j%Larry.Finger@lwfinger.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Create the base header file for rtl8187se.

Signed-off-by: Larry Finger <Larry.Finger@lwfinger.net>
---

Index: wireless-testing/drivers/net/wireless/rtl818x/rtl8187se.h
===================================================================
--- /dev/null
+++ wireless-testing/drivers/net/wireless/rtl818x/rtl8187se.h
@@ -0,0 +1,122 @@
+#ifndef RTL8187SE_H
+#define RTL8187SE_H
+
+#include "rtl818x.h"
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
+
+	/* rtl8187se driver specific */
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
+
+	u32 anaparam;
+	u16 rfparam;
+	u8 csthreshold;
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
+#endif /* RTL8187SE_H */
+
