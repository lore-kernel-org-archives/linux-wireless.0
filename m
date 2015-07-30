Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from sabertooth02.qualcomm.com ([65.197.215.38]:64261 "EHLO
	sabertooth02.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755513AbbG3Kyt (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 30 Jul 2015 06:54:49 -0400
From: Vladimir Kondratiev <QCA_vkondrat@QCA.qualcomm.com>
Cc: Vladimir Kondratiev <QCA_vkondrat@QCA.qualcomm.com>,
	linux-wireless@vger.kernel.org, wil6210@qca.qualcomm.com
To: Kalle Valo <kvalo@codeaurora.org>
Subject: [PATCH v3 15/19] wil6210: use inline functions for register access
Date: Thu, 30 Jul 2015 13:52:03 +0300
Message-Id: <1438253527-3372-16-git-send-email-qca_vkondrat@qca.qualcomm.com> (sfid-20150730_125500_271288_F2AF3169)
In-Reply-To: <1438253527-3372-1-git-send-email-qca_vkondrat@qca.qualcomm.com>
References: <1438253527-3372-1-git-send-email-qca_vkondrat@qca.qualcomm.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Replace macros like "R", "W", "S", "C", defined multiple times,
with inline functions "wil_[rwsc]".

Use "readl" and "writel" instead of "ioread32" and "iowrite32"
since it is granted that memory transactions are used,
not port ones like IN/OUT

Signed-off-by: Vladimir Kondratiev <qca_vkondrat@qca.qualcomm.com>
---
 drivers/net/wireless/ath/wil6210/debugfs.c   |   8 +-
 drivers/net/wireless/ath/wil6210/ethtool.c   |  14 +---
 drivers/net/wireless/ath/wil6210/fw.c        |  10 ---
 drivers/net/wireless/ath/wil6210/fw_inc.c    |  16 ++--
 drivers/net/wireless/ath/wil6210/interrupt.c | 110 ++++++++++++---------------
 drivers/net/wireless/ath/wil6210/ioctl.c     |   4 +-
 drivers/net/wireless/ath/wil6210/main.c      |  94 ++++++++++-------------
 drivers/net/wireless/ath/wil6210/pcie_bus.c  |   2 +-
 drivers/net/wireless/ath/wil6210/txrx.c      |   6 +-
 drivers/net/wireless/ath/wil6210/wil6210.h   |  31 +++++++-
 drivers/net/wireless/ath/wil6210/wmi.c       |  26 +++----
 11 files changed, 151 insertions(+), 170 deletions(-)

diff --git a/drivers/net/wireless/ath/wil6210/debugfs.c b/drivers/net/wireless/ath/wil6210/debugfs.c
index 05b550f..613ca2b 100644
--- a/drivers/net/wireless/ath/wil6210/debugfs.c
+++ b/drivers/net/wireless/ath/wil6210/debugfs.c
@@ -62,7 +62,7 @@ static void wil_print_vring(struct seq_file *s, struct wil6210_priv *wil,
 	seq_printf(s, "  swhead = %d\n", vring->swhead);
 	seq_printf(s, "  hwtail = [0x%08x] -> ", vring->hwtail);
 	if (x) {
-		v = ioread32(x);
+		v = readl(x);
 		seq_printf(s, "0x%08x = %d\n", v, v);
 	} else {
 		seq_puts(s, "???\n");
@@ -268,7 +268,7 @@ static const struct file_operations fops_mbox = {
 
 static int wil_debugfs_iomem_x32_set(void *data, u64 val)
 {
-	iowrite32(val, (void __iomem *)data);
+	writel(val, (void __iomem *)data);
 	wmb(); /* make sure write propagated to HW */
 
 	return 0;
@@ -276,7 +276,7 @@ static int wil_debugfs_iomem_x32_set(void *data, u64 val)
 
 static int wil_debugfs_iomem_x32_get(void *data, u64 *val)
 {
-	*val = ioread32((void __iomem *)data);
+	*val = readl((void __iomem *)data);
 
 	return 0;
 }
@@ -477,7 +477,7 @@ static int wil_memread_debugfs_show(struct seq_file *s, void *data)
 	void __iomem *a = wmi_buffer(wil, cpu_to_le32(mem_addr));
 
 	if (a)
-		seq_printf(s, "[0x%08x] = 0x%08x\n", mem_addr, ioread32(a));
+		seq_printf(s, "[0x%08x] = 0x%08x\n", mem_addr, readl(a));
 	else
 		seq_printf(s, "[0x%08x] = INVALID\n", mem_addr);
 
diff --git a/drivers/net/wireless/ath/wil6210/ethtool.c b/drivers/net/wireless/ath/wil6210/ethtool.c
index 0ea695f..7053b62 100644
--- a/drivers/net/wireless/ath/wil6210/ethtool.c
+++ b/drivers/net/wireless/ath/wil6210/ethtool.c
@@ -50,19 +50,13 @@ static int wil_ethtoolops_get_coalesce(struct net_device *ndev,
 
 	wil_dbg_misc(wil, "%s()\n", __func__);
 
-	tx_itr_en = ioread32(wil->csr +
-			     HOSTADDR(RGF_DMA_ITR_TX_CNT_CTL));
+	tx_itr_en = wil_r(wil, RGF_DMA_ITR_TX_CNT_CTL);
 	if (tx_itr_en & BIT_DMA_ITR_TX_CNT_CTL_EN)
-		tx_itr_val =
-			ioread32(wil->csr +
-				 HOSTADDR(RGF_DMA_ITR_TX_CNT_TRSH));
+		tx_itr_val = wil_r(wil, RGF_DMA_ITR_TX_CNT_TRSH);
 
-	rx_itr_en = ioread32(wil->csr +
-			     HOSTADDR(RGF_DMA_ITR_RX_CNT_CTL));
+	rx_itr_en = wil_r(wil, RGF_DMA_ITR_RX_CNT_CTL);
 	if (rx_itr_en & BIT_DMA_ITR_RX_CNT_CTL_EN)
-		rx_itr_val =
-			ioread32(wil->csr +
-				 HOSTADDR(RGF_DMA_ITR_RX_CNT_TRSH));
+		rx_itr_val = wil_r(wil, RGF_DMA_ITR_RX_CNT_TRSH);
 
 	cp->tx_coalesce_usecs = tx_itr_val;
 	cp->rx_coalesce_usecs = rx_itr_val;
diff --git a/drivers/net/wireless/ath/wil6210/fw.c b/drivers/net/wireless/ath/wil6210/fw.c
index 4428345..82aae2d 100644
--- a/drivers/net/wireless/ath/wil6210/fw.c
+++ b/drivers/net/wireless/ath/wil6210/fw.c
@@ -22,16 +22,6 @@
 MODULE_FIRMWARE(WIL_FW_NAME);
 MODULE_FIRMWARE(WIL_FW2_NAME);
 
-/* target operations */
-/* register read */
-#define R(a) ioread32(wil->csr + HOSTADDR(a))
-/* register write. wmb() to make sure it is completed */
-#define W(a, v) do { iowrite32(v, wil->csr + HOSTADDR(a)); wmb(); } while (0)
-/* register set = read, OR, write */
-#define S(a, v) W(a, R(a) | v)
-/* register clear = read, AND with inverted, write */
-#define C(a, v) W(a, R(a) & ~v)
-
 static
 void wil_memset_toio_32(volatile void __iomem *dst, u32 val,
 			size_t count)
diff --git a/drivers/net/wireless/ath/wil6210/fw_inc.c b/drivers/net/wireless/ath/wil6210/fw_inc.c
index 157f5ef..d30657e 100644
--- a/drivers/net/wireless/ath/wil6210/fw_inc.c
+++ b/drivers/net/wireless/ath/wil6210/fw_inc.c
@@ -221,12 +221,12 @@ static int fw_handle_direct_write(struct wil6210_priv *wil, const void *data,
 
 		FW_ADDR_CHECK(dst, block[i].addr, "address");
 
-		x = ioread32(dst);
+		x = readl(dst);
 		y = (x & m) | (v & ~m);
 		wil_dbg_fw(wil, "write [0x%08x] <== 0x%08x "
 			   "(old 0x%08x val 0x%08x mask 0x%08x)\n",
 			   le32_to_cpu(block[i].addr), y, x, v, m);
-		iowrite32(y, dst);
+		writel(y, dst);
 		wmb(); /* finish before processing next record */
 	}
 
@@ -239,18 +239,18 @@ static int gw_write(struct wil6210_priv *wil, void __iomem *gwa_addr,
 {
 	unsigned delay = 0;
 
-	iowrite32(a, gwa_addr);
-	iowrite32(gw_cmd, gwa_cmd);
+	writel(a, gwa_addr);
+	writel(gw_cmd, gwa_cmd);
 	wmb(); /* finish before activate gw */
 
-	iowrite32(WIL_FW_GW_CTL_RUN, gwa_ctl); /* activate gw */
+	writel(WIL_FW_GW_CTL_RUN, gwa_ctl); /* activate gw */
 	do {
 		udelay(1); /* typical time is few usec */
 		if (delay++ > 100) {
 			wil_err_fw(wil, "gw timeout\n");
 			return -EINVAL;
 		}
-	} while (ioread32(gwa_ctl) & WIL_FW_GW_CTL_BUSY); /* gw done? */
+	} while (readl(gwa_ctl) & WIL_FW_GW_CTL_BUSY); /* gw done? */
 
 	return 0;
 }
@@ -305,7 +305,7 @@ static int fw_handle_gateway_data(struct wil6210_priv *wil, const void *data,
 		wil_dbg_fw(wil, "  gw write[%3d] [0x%08x] <== 0x%08x\n",
 			   i, a, v);
 
-		iowrite32(v, gwa_val);
+		writel(v, gwa_val);
 		rc = gw_write(wil, gwa_addr, gwa_cmd, gwa_ctl, gw_cmd, a);
 		if (rc)
 			return rc;
@@ -372,7 +372,7 @@ static int fw_handle_gateway_data4(struct wil6210_priv *wil, const void *data,
 				sizeof(v), false);
 
 		for (k = 0; k < ARRAY_SIZE(block->value); k++)
-			iowrite32(v[k], gwa_val[k]);
+			writel(v[k], gwa_val[k]);
 		rc = gw_write(wil, gwa_addr, gwa_cmd, gwa_ctl, gw_cmd, a);
 		if (rc)
 			return rc;
diff --git a/drivers/net/wireless/ath/wil6210/interrupt.c b/drivers/net/wireless/ath/wil6210/interrupt.c
index 596d09b..a371f03 100644
--- a/drivers/net/wireless/ath/wil6210/interrupt.c
+++ b/drivers/net/wireless/ath/wil6210/interrupt.c
@@ -61,13 +61,13 @@ static inline void wil_icr_clear(u32 x, void __iomem *addr)
 
 static inline void wil_icr_clear(u32 x, void __iomem *addr)
 {
-	iowrite32(x, addr);
+	writel(x, addr);
 }
 #endif /* defined(CONFIG_WIL6210_ISR_COR) */
 
 static inline u32 wil_ioread32_and_clear(void __iomem *addr)
 {
-	u32 x = ioread32(addr);
+	u32 x = readl(addr);
 
 	wil_icr_clear(x, addr);
 
@@ -76,54 +76,47 @@ static inline u32 wil_ioread32_and_clear(void __iomem *addr)
 
 static void wil6210_mask_irq_tx(struct wil6210_priv *wil)
 {
-	iowrite32(WIL6210_IRQ_DISABLE, wil->csr +
-		  HOSTADDR(RGF_DMA_EP_TX_ICR) +
-		  offsetof(struct RGF_ICR, IMS));
+	wil_w(wil, RGF_DMA_EP_TX_ICR + offsetof(struct RGF_ICR, IMS),
+	      WIL6210_IRQ_DISABLE);
 }
 
 static void wil6210_mask_irq_rx(struct wil6210_priv *wil)
 {
-	iowrite32(WIL6210_IRQ_DISABLE, wil->csr +
-		  HOSTADDR(RGF_DMA_EP_RX_ICR) +
-		  offsetof(struct RGF_ICR, IMS));
+	wil_w(wil, RGF_DMA_EP_RX_ICR + offsetof(struct RGF_ICR, IMS),
+	      WIL6210_IRQ_DISABLE);
 }
 
 static void wil6210_mask_irq_misc(struct wil6210_priv *wil)
 {
-	iowrite32(WIL6210_IRQ_DISABLE, wil->csr +
-		  HOSTADDR(RGF_DMA_EP_MISC_ICR) +
-		  offsetof(struct RGF_ICR, IMS));
+	wil_w(wil, RGF_DMA_EP_MISC_ICR + offsetof(struct RGF_ICR, IMS),
+	      WIL6210_IRQ_DISABLE);
 }
 
 static void wil6210_mask_irq_pseudo(struct wil6210_priv *wil)
 {
 	wil_dbg_irq(wil, "%s()\n", __func__);
 
-	iowrite32(WIL6210_IRQ_DISABLE, wil->csr +
-		  HOSTADDR(RGF_DMA_PSEUDO_CAUSE_MASK_SW));
+	wil_w(wil, RGF_DMA_PSEUDO_CAUSE_MASK_SW, WIL6210_IRQ_DISABLE);
 
 	clear_bit(wil_status_irqen, wil->status);
 }
 
 void wil6210_unmask_irq_tx(struct wil6210_priv *wil)
 {
-	iowrite32(WIL6210_IMC_TX, wil->csr +
-		  HOSTADDR(RGF_DMA_EP_TX_ICR) +
-		  offsetof(struct RGF_ICR, IMC));
+	wil_w(wil, RGF_DMA_EP_TX_ICR + offsetof(struct RGF_ICR, IMC),
+	      WIL6210_IMC_TX);
 }
 
 void wil6210_unmask_irq_rx(struct wil6210_priv *wil)
 {
-	iowrite32(WIL6210_IMC_RX, wil->csr +
-		  HOSTADDR(RGF_DMA_EP_RX_ICR) +
-		  offsetof(struct RGF_ICR, IMC));
+	wil_w(wil, RGF_DMA_EP_RX_ICR + offsetof(struct RGF_ICR, IMC),
+	      WIL6210_IMC_RX);
 }
 
 static void wil6210_unmask_irq_misc(struct wil6210_priv *wil)
 {
-	iowrite32(WIL6210_IMC_MISC, wil->csr +
-		  HOSTADDR(RGF_DMA_EP_MISC_ICR) +
-		  offsetof(struct RGF_ICR, IMC));
+	wil_w(wil, RGF_DMA_EP_MISC_ICR + offsetof(struct RGF_ICR, IMC),
+	      WIL6210_IMC_MISC);
 }
 
 static void wil6210_unmask_irq_pseudo(struct wil6210_priv *wil)
@@ -132,8 +125,7 @@ static void wil6210_unmask_irq_pseudo(struct wil6210_priv *wil)
 
 	set_bit(wil_status_irqen, wil->status);
 
-	iowrite32(WIL6210_IRQ_PSEUDO_MASK, wil->csr +
-		  HOSTADDR(RGF_DMA_PSEUDO_CAUSE_MASK_SW));
+	wil_w(wil, RGF_DMA_PSEUDO_CAUSE_MASK_SW, WIL6210_IRQ_PSEUDO_MASK);
 }
 
 void wil_mask_irq(struct wil6210_priv *wil)
@@ -150,12 +142,12 @@ void wil_unmask_irq(struct wil6210_priv *wil)
 {
 	wil_dbg_irq(wil, "%s()\n", __func__);
 
-	iowrite32(WIL_ICR_ICC_VALUE, wil->csr + HOSTADDR(RGF_DMA_EP_RX_ICR) +
-		  offsetof(struct RGF_ICR, ICC));
-	iowrite32(WIL_ICR_ICC_VALUE, wil->csr + HOSTADDR(RGF_DMA_EP_TX_ICR) +
-		  offsetof(struct RGF_ICR, ICC));
-	iowrite32(WIL_ICR_ICC_VALUE, wil->csr + HOSTADDR(RGF_DMA_EP_MISC_ICR) +
-		  offsetof(struct RGF_ICR, ICC));
+	wil_w(wil, RGF_DMA_EP_RX_ICR + offsetof(struct RGF_ICR, ICC),
+	      WIL_ICR_ICC_VALUE);
+	wil_w(wil, RGF_DMA_EP_TX_ICR + offsetof(struct RGF_ICR, ICC),
+	      WIL_ICR_ICC_VALUE);
+	wil_w(wil, RGF_DMA_EP_MISC_ICR + offsetof(struct RGF_ICR, ICC),
+	      WIL_ICR_ICC_VALUE);
 
 	wil6210_unmask_irq_pseudo(wil);
 	wil6210_unmask_irq_tx(wil);
@@ -163,9 +155,6 @@ void wil_unmask_irq(struct wil6210_priv *wil)
 	wil6210_unmask_irq_misc(wil);
 }
 
-/* target write operation */
-#define W(a, v) do { iowrite32(v, wil->csr + HOSTADDR(a)); wmb(); } while (0)
-
 void wil_configure_interrupt_moderation(struct wil6210_priv *wil)
 {
 	wil_dbg_irq(wil, "%s()\n", __func__);
@@ -177,44 +166,42 @@ void wil_configure_interrupt_moderation(struct wil6210_priv *wil)
 		return;
 
 	/* Disable and clear tx counter before (re)configuration */
-	W(RGF_DMA_ITR_TX_CNT_CTL, BIT_DMA_ITR_TX_CNT_CTL_CLR);
-	W(RGF_DMA_ITR_TX_CNT_TRSH, wil->tx_max_burst_duration);
+	wil_w(wil, RGF_DMA_ITR_TX_CNT_CTL, BIT_DMA_ITR_TX_CNT_CTL_CLR);
+	wil_w(wil, RGF_DMA_ITR_TX_CNT_TRSH, wil->tx_max_burst_duration);
 	wil_info(wil, "set ITR_TX_CNT_TRSH = %d usec\n",
 		 wil->tx_max_burst_duration);
 	/* Configure TX max burst duration timer to use usec units */
-	W(RGF_DMA_ITR_TX_CNT_CTL,
-	  BIT_DMA_ITR_TX_CNT_CTL_EN | BIT_DMA_ITR_TX_CNT_CTL_EXT_TIC_SEL);
+	wil_w(wil, RGF_DMA_ITR_TX_CNT_CTL,
+	      BIT_DMA_ITR_TX_CNT_CTL_EN | BIT_DMA_ITR_TX_CNT_CTL_EXT_TIC_SEL);
 
 	/* Disable and clear tx idle counter before (re)configuration */
-	W(RGF_DMA_ITR_TX_IDL_CNT_CTL, BIT_DMA_ITR_TX_IDL_CNT_CTL_CLR);
-	W(RGF_DMA_ITR_TX_IDL_CNT_TRSH, wil->tx_interframe_timeout);
+	wil_w(wil, RGF_DMA_ITR_TX_IDL_CNT_CTL, BIT_DMA_ITR_TX_IDL_CNT_CTL_CLR);
+	wil_w(wil, RGF_DMA_ITR_TX_IDL_CNT_TRSH, wil->tx_interframe_timeout);
 	wil_info(wil, "set ITR_TX_IDL_CNT_TRSH = %d usec\n",
 		 wil->tx_interframe_timeout);
 	/* Configure TX max burst duration timer to use usec units */
-	W(RGF_DMA_ITR_TX_IDL_CNT_CTL, BIT_DMA_ITR_TX_IDL_CNT_CTL_EN |
-				      BIT_DMA_ITR_TX_IDL_CNT_CTL_EXT_TIC_SEL);
+	wil_w(wil, RGF_DMA_ITR_TX_IDL_CNT_CTL, BIT_DMA_ITR_TX_IDL_CNT_CTL_EN |
+	      BIT_DMA_ITR_TX_IDL_CNT_CTL_EXT_TIC_SEL);
 
 	/* Disable and clear rx counter before (re)configuration */
-	W(RGF_DMA_ITR_RX_CNT_CTL, BIT_DMA_ITR_RX_CNT_CTL_CLR);
-	W(RGF_DMA_ITR_RX_CNT_TRSH, wil->rx_max_burst_duration);
+	wil_w(wil, RGF_DMA_ITR_RX_CNT_CTL, BIT_DMA_ITR_RX_CNT_CTL_CLR);
+	wil_w(wil, RGF_DMA_ITR_RX_CNT_TRSH, wil->rx_max_burst_duration);
 	wil_info(wil, "set ITR_RX_CNT_TRSH = %d usec\n",
 		 wil->rx_max_burst_duration);
 	/* Configure TX max burst duration timer to use usec units */
-	W(RGF_DMA_ITR_RX_CNT_CTL,
-	  BIT_DMA_ITR_RX_CNT_CTL_EN | BIT_DMA_ITR_RX_CNT_CTL_EXT_TIC_SEL);
+	wil_w(wil, RGF_DMA_ITR_RX_CNT_CTL,
+	      BIT_DMA_ITR_RX_CNT_CTL_EN | BIT_DMA_ITR_RX_CNT_CTL_EXT_TIC_SEL);
 
 	/* Disable and clear rx idle counter before (re)configuration */
-	W(RGF_DMA_ITR_RX_IDL_CNT_CTL, BIT_DMA_ITR_RX_IDL_CNT_CTL_CLR);
-	W(RGF_DMA_ITR_RX_IDL_CNT_TRSH, wil->rx_interframe_timeout);
+	wil_w(wil, RGF_DMA_ITR_RX_IDL_CNT_CTL, BIT_DMA_ITR_RX_IDL_CNT_CTL_CLR);
+	wil_w(wil, RGF_DMA_ITR_RX_IDL_CNT_TRSH, wil->rx_interframe_timeout);
 	wil_info(wil, "set ITR_RX_IDL_CNT_TRSH = %d usec\n",
 		 wil->rx_interframe_timeout);
 	/* Configure TX max burst duration timer to use usec units */
-	W(RGF_DMA_ITR_RX_IDL_CNT_CTL, BIT_DMA_ITR_RX_IDL_CNT_CTL_EN |
-				      BIT_DMA_ITR_RX_IDL_CNT_CTL_EXT_TIC_SEL);
+	wil_w(wil, RGF_DMA_ITR_RX_IDL_CNT_CTL, BIT_DMA_ITR_RX_IDL_CNT_CTL_EN |
+	      BIT_DMA_ITR_RX_IDL_CNT_CTL_EXT_TIC_SEL);
 }
 
-#undef W
-
 static irqreturn_t wil6210_irq_rx(int irq, void *cookie)
 {
 	struct wil6210_priv *wil = cookie;
@@ -452,27 +439,24 @@ static int wil6210_debug_irq_mask(struct wil6210_priv *wil, u32 pseudo_cause)
 		u32 icr_rx = wil_ioread32_and_clear(wil->csr +
 				HOSTADDR(RGF_DMA_EP_RX_ICR) +
 				offsetof(struct RGF_ICR, ICR));
-		u32 imv_rx = ioread32(wil->csr +
-				HOSTADDR(RGF_DMA_EP_RX_ICR) +
-				offsetof(struct RGF_ICR, IMV));
+		u32 imv_rx = wil_r(wil, RGF_DMA_EP_RX_ICR +
+				   offsetof(struct RGF_ICR, IMV));
 		u32 icm_tx = wil_ioread32_and_clear(wil->csr +
 				HOSTADDR(RGF_DMA_EP_TX_ICR) +
 				offsetof(struct RGF_ICR, ICM));
 		u32 icr_tx = wil_ioread32_and_clear(wil->csr +
 				HOSTADDR(RGF_DMA_EP_TX_ICR) +
 				offsetof(struct RGF_ICR, ICR));
-		u32 imv_tx = ioread32(wil->csr +
-				HOSTADDR(RGF_DMA_EP_TX_ICR) +
-				offsetof(struct RGF_ICR, IMV));
+		u32 imv_tx = wil_r(wil, RGF_DMA_EP_TX_ICR +
+				   offsetof(struct RGF_ICR, IMV));
 		u32 icm_misc = wil_ioread32_and_clear(wil->csr +
 				HOSTADDR(RGF_DMA_EP_MISC_ICR) +
 				offsetof(struct RGF_ICR, ICM));
 		u32 icr_misc = wil_ioread32_and_clear(wil->csr +
 				HOSTADDR(RGF_DMA_EP_MISC_ICR) +
 				offsetof(struct RGF_ICR, ICR));
-		u32 imv_misc = ioread32(wil->csr +
-				HOSTADDR(RGF_DMA_EP_MISC_ICR) +
-				offsetof(struct RGF_ICR, IMV));
+		u32 imv_misc = wil_r(wil, RGF_DMA_EP_MISC_ICR +
+				     offsetof(struct RGF_ICR, IMV));
 		wil_err(wil, "IRQ when it should be masked: pseudo 0x%08x\n"
 				"Rx   icm:icr:imv 0x%08x 0x%08x 0x%08x\n"
 				"Tx   icm:icr:imv 0x%08x 0x%08x 0x%08x\n"
@@ -492,7 +476,7 @@ static irqreturn_t wil6210_hardirq(int irq, void *cookie)
 {
 	irqreturn_t rc = IRQ_HANDLED;
 	struct wil6210_priv *wil = cookie;
-	u32 pseudo_cause = ioread32(wil->csr + HOSTADDR(RGF_DMA_PSEUDO_CAUSE));
+	u32 pseudo_cause = wil_r(wil, RGF_DMA_PSEUDO_CAUSE);
 
 	/**
 	 * pseudo_cause is Clear-On-Read, no need to ACK
@@ -544,9 +528,9 @@ static irqreturn_t wil6210_hardirq(int irq, void *cookie)
 /* can't use wil_ioread32_and_clear because ICC value is not set yet */
 static inline void wil_clear32(void __iomem *addr)
 {
-	u32 x = ioread32(addr);
+	u32 x = readl(addr);
 
-	iowrite32(x, addr);
+	writel(x, addr);
 }
 
 void wil6210_clear_irq(struct wil6210_priv *wil)
diff --git a/drivers/net/wireless/ath/wil6210/ioctl.c b/drivers/net/wireless/ath/wil6210/ioctl.c
index e9c0673..f7f9486 100644
--- a/drivers/net/wireless/ath/wil6210/ioctl.c
+++ b/drivers/net/wireless/ath/wil6210/ioctl.c
@@ -76,11 +76,11 @@ static int wil_ioc_memio_dword(struct wil6210_priv *wil, void __user *data)
 	/* operation */
 	switch (io.op & wil_mmio_op_mask) {
 	case wil_mmio_read:
-		io.val = ioread32(a);
+		io.val = readl(a);
 		need_copy = true;
 		break;
 	case wil_mmio_write:
-		iowrite32(io.val, a);
+		writel(io.val, a);
 		wmb(); /* make sure write propagated to HW */
 		break;
 	default:
diff --git a/drivers/net/wireless/ath/wil6210/main.c b/drivers/net/wireless/ath/wil6210/main.c
index 33a3e9b..4422323 100644
--- a/drivers/net/wireless/ath/wil6210/main.c
+++ b/drivers/net/wireless/ath/wil6210/main.c
@@ -528,26 +528,16 @@ void wil_priv_deinit(struct wil6210_priv *wil)
 	destroy_workqueue(wil->wmi_wq);
 }
 
-/* target operations */
-/* register read */
-#define R(a) ioread32(wil->csr + HOSTADDR(a))
-/* register write. wmb() to make sure it is completed */
-#define W(a, v) do { iowrite32(v, wil->csr + HOSTADDR(a)); wmb(); } while (0)
-/* register set = read, OR, write */
-#define S(a, v) W(a, R(a) | v)
-/* register clear = read, AND with inverted, write */
-#define C(a, v) W(a, R(a) & ~v)
-
 static inline void wil_halt_cpu(struct wil6210_priv *wil)
 {
-	W(RGF_USER_USER_CPU_0, BIT_USER_USER_CPU_MAN_RST);
-	W(RGF_USER_MAC_CPU_0,  BIT_USER_MAC_CPU_MAN_RST);
+	wil_w(wil, RGF_USER_USER_CPU_0, BIT_USER_USER_CPU_MAN_RST);
+	wil_w(wil, RGF_USER_MAC_CPU_0,  BIT_USER_MAC_CPU_MAN_RST);
 }
 
 static inline void wil_release_cpu(struct wil6210_priv *wil)
 {
 	/* Start CPU */
-	W(RGF_USER_USER_CPU_0, 1);
+	wil_w(wil, RGF_USER_USER_CPU_0, 1);
 }
 
 static int wil_target_reset(struct wil6210_priv *wil)
@@ -558,58 +548,60 @@ static int wil_target_reset(struct wil6210_priv *wil)
 	wil_dbg_misc(wil, "Resetting \"%s\"...\n", wil->hw_name);
 
 	/* Clear MAC link up */
-	S(RGF_HP_CTRL, BIT(15));
-	S(RGF_USER_CLKS_CTL_SW_RST_MASK_0, BIT_HPAL_PERST_FROM_PAD);
-	S(RGF_USER_CLKS_CTL_SW_RST_MASK_0, BIT_CAR_PERST_RST);
+	wil_s(wil, RGF_HP_CTRL, BIT(15));
+	wil_s(wil, RGF_USER_CLKS_CTL_SW_RST_MASK_0, BIT_HPAL_PERST_FROM_PAD);
+	wil_s(wil, RGF_USER_CLKS_CTL_SW_RST_MASK_0, BIT_CAR_PERST_RST);
 
 	wil_halt_cpu(wil);
 
 	/* clear all boot loader "ready" bits */
-	W(RGF_USER_BL +
-	  offsetof(struct bl_dedicated_registers_v0, boot_loader_ready), 0);
+	wil_w(wil, RGF_USER_BL +
+	      offsetof(struct bl_dedicated_registers_v0, boot_loader_ready), 0);
 	/* Clear Fw Download notification */
-	C(RGF_USER_USAGE_6, BIT(0));
+	wil_c(wil, RGF_USER_USAGE_6, BIT(0));
 
-	S(RGF_CAF_OSC_CONTROL, BIT_CAF_OSC_XTAL_EN);
+	wil_s(wil, RGF_CAF_OSC_CONTROL, BIT_CAF_OSC_XTAL_EN);
 	/* XTAL stabilization should take about 3ms */
 	usleep_range(5000, 7000);
-	x = R(RGF_CAF_PLL_LOCK_STATUS);
+	x = wil_r(wil, RGF_CAF_PLL_LOCK_STATUS);
 	if (!(x & BIT_CAF_OSC_DIG_XTAL_STABLE)) {
 		wil_err(wil, "Xtal stabilization timeout\n"
 			"RGF_CAF_PLL_LOCK_STATUS = 0x%08x\n", x);
 		return -ETIME;
 	}
 	/* switch 10k to XTAL*/
-	C(RGF_USER_SPARROW_M_4, BIT_SPARROW_M_4_SEL_SLEEP_OR_REF);
+	wil_c(wil, RGF_USER_SPARROW_M_4, BIT_SPARROW_M_4_SEL_SLEEP_OR_REF);
 	/* 40 MHz */
-	C(RGF_USER_CLKS_CTL_0, BIT_USER_CLKS_CAR_AHB_SW_SEL);
+	wil_c(wil, RGF_USER_CLKS_CTL_0, BIT_USER_CLKS_CAR_AHB_SW_SEL);
 
-	W(RGF_USER_CLKS_CTL_EXT_SW_RST_VEC_0, 0x3ff81f);
-	W(RGF_USER_CLKS_CTL_EXT_SW_RST_VEC_1, 0xf);
+	wil_w(wil, RGF_USER_CLKS_CTL_EXT_SW_RST_VEC_0, 0x3ff81f);
+	wil_w(wil, RGF_USER_CLKS_CTL_EXT_SW_RST_VEC_1, 0xf);
 
-	W(RGF_USER_CLKS_CTL_SW_RST_VEC_2, 0xFE000000);
-	W(RGF_USER_CLKS_CTL_SW_RST_VEC_1, 0x0000003F);
-	W(RGF_USER_CLKS_CTL_SW_RST_VEC_3, 0x000000f0);
-	W(RGF_USER_CLKS_CTL_SW_RST_VEC_0, 0xFFE7FE00);
+	wil_w(wil, RGF_USER_CLKS_CTL_SW_RST_VEC_2, 0xFE000000);
+	wil_w(wil, RGF_USER_CLKS_CTL_SW_RST_VEC_1, 0x0000003F);
+	wil_w(wil, RGF_USER_CLKS_CTL_SW_RST_VEC_3, 0x000000f0);
+	wil_w(wil, RGF_USER_CLKS_CTL_SW_RST_VEC_0, 0xFFE7FE00);
 
-	W(RGF_USER_CLKS_CTL_EXT_SW_RST_VEC_0, 0x0);
-	W(RGF_USER_CLKS_CTL_EXT_SW_RST_VEC_1, 0x0);
+	wil_w(wil, RGF_USER_CLKS_CTL_EXT_SW_RST_VEC_0, 0x0);
+	wil_w(wil, RGF_USER_CLKS_CTL_EXT_SW_RST_VEC_1, 0x0);
 
-	W(RGF_USER_CLKS_CTL_SW_RST_VEC_3, 0);
-	W(RGF_USER_CLKS_CTL_SW_RST_VEC_2, 0);
-	W(RGF_USER_CLKS_CTL_SW_RST_VEC_1, 0);
-	W(RGF_USER_CLKS_CTL_SW_RST_VEC_0, 0);
+	wil_w(wil, RGF_USER_CLKS_CTL_SW_RST_VEC_3, 0);
+	wil_w(wil, RGF_USER_CLKS_CTL_SW_RST_VEC_2, 0);
+	wil_w(wil, RGF_USER_CLKS_CTL_SW_RST_VEC_1, 0);
+	wil_w(wil, RGF_USER_CLKS_CTL_SW_RST_VEC_0, 0);
 
-	W(RGF_USER_CLKS_CTL_SW_RST_VEC_3, 0x00000003);
-	W(RGF_USER_CLKS_CTL_SW_RST_VEC_2, 0x00008000); /* reset A2 PCIE AHB */
+	wil_w(wil, RGF_USER_CLKS_CTL_SW_RST_VEC_3, 0x00000003);
+	/* reset A2 PCIE AHB */
+	wil_w(wil, RGF_USER_CLKS_CTL_SW_RST_VEC_2, 0x00008000);
 
-	W(RGF_USER_CLKS_CTL_SW_RST_VEC_0, 0);
+	wil_w(wil, RGF_USER_CLKS_CTL_SW_RST_VEC_0, 0);
 
 	/* wait until device ready. typical time is 20..80 msec */
 	do {
 		msleep(RST_DELAY);
-		x = R(RGF_USER_BL + offsetof(struct bl_dedicated_registers_v0,
-					     boot_loader_ready));
+		x = wil_r(wil, RGF_USER_BL +
+			  offsetof(struct bl_dedicated_registers_v0,
+				   boot_loader_ready));
 		if (x1 != x) {
 			wil_dbg_misc(wil, "BL.ready 0x%08x => 0x%08x\n", x1, x);
 			x1 = x;
@@ -621,11 +613,11 @@ static int wil_target_reset(struct wil6210_priv *wil)
 		}
 	} while (x != BL_READY);
 
-	C(RGF_USER_CLKS_CTL_0, BIT_USER_CLKS_RST_PWGD);
+	wil_c(wil, RGF_USER_CLKS_CTL_0, BIT_USER_CLKS_RST_PWGD);
 
 	/* enable fix for HW bug related to the SA/DA swap in AP Rx */
-	S(RGF_DMA_OFUL_NID_0, BIT_DMA_OFUL_NID_0_RX_EXT_TR_EN |
-	  BIT_DMA_OFUL_NID_0_RX_EXT_A3_SRC);
+	wil_s(wil, RGF_DMA_OFUL_NID_0, BIT_DMA_OFUL_NID_0_RX_EXT_TR_EN |
+	      BIT_DMA_OFUL_NID_0_RX_EXT_A3_SRC);
 
 	wil_dbg_misc(wil, "Reset completed in %d ms\n", delay * RST_DELAY);
 	return 0;
@@ -651,8 +643,9 @@ static int wil_get_bl_info(struct wil6210_priv *wil)
 	u8 *mac;
 	u16 rf_status;
 
-	bl_ver = R(RGF_USER_BL + offsetof(struct bl_dedicated_registers_v0,
-					  boot_loader_struct_version));
+	bl_ver = wil_r(wil, RGF_USER_BL +
+		       offsetof(struct bl_dedicated_registers_v0,
+				boot_loader_struct_version));
 	switch (bl_ver) {
 	case 0:
 		wil_memcpy_fromio_32(&bl, wil->csr + HOSTADDR(RGF_USER_BL),
@@ -802,7 +795,7 @@ int wil_reset(struct wil6210_priv *wil, bool load_fw)
 			return rc;
 
 		/* Mark FW as loaded from host */
-		S(RGF_USER_USAGE_6, 1);
+		wil_s(wil, RGF_USER_USAGE_6, 1);
 
 		/* clear any interrupts which on-card-firmware
 		 * may have set
@@ -810,8 +803,8 @@ int wil_reset(struct wil6210_priv *wil, bool load_fw)
 		wil6210_clear_irq(wil);
 		/* CAF_ICR - clear and mask */
 		/* it is W1C, clear by writing back same value */
-		S(RGF_CAF_ICR + offsetof(struct RGF_ICR, ICR), 0);
-		W(RGF_CAF_ICR + offsetof(struct RGF_ICR, IMV), ~0);
+		wil_s(wil, RGF_CAF_ICR + offsetof(struct RGF_ICR, ICR), 0);
+		wil_w(wil, RGF_CAF_ICR + offsetof(struct RGF_ICR, IMV), ~0);
 
 		wil_release_cpu(wil);
 	}
@@ -835,11 +828,6 @@ int wil_reset(struct wil6210_priv *wil, bool load_fw)
 	return rc;
 }
 
-#undef R
-#undef W
-#undef S
-#undef C
-
 void wil_fw_error_recovery(struct wil6210_priv *wil)
 {
 	wil_dbg_misc(wil, "starting fw error recovery\n");
diff --git a/drivers/net/wireless/ath/wil6210/pcie_bus.c b/drivers/net/wireless/ath/wil6210/pcie_bus.c
index d065b79..c37838d 100644
--- a/drivers/net/wireless/ath/wil6210/pcie_bus.c
+++ b/drivers/net/wireless/ath/wil6210/pcie_bus.c
@@ -28,7 +28,7 @@ MODULE_PARM_DESC(use_msi, " Use MSI interrupt, default - true");
 static
 void wil_set_capabilities(struct wil6210_priv *wil)
 {
-	u32 rev_id = ioread32(wil->csr + HOSTADDR(RGF_USER_JTAG_DEV_ID));
+	u32 rev_id = wil_r(wil, RGF_USER_JTAG_DEV_ID);
 
 	bitmap_zero(wil->hw_capabilities, hw_capability_last);
 
diff --git a/drivers/net/wireless/ath/wil6210/txrx.c b/drivers/net/wireless/ath/wil6210/txrx.c
index 7722df7..359121f 100644
--- a/drivers/net/wireless/ath/wil6210/txrx.c
+++ b/drivers/net/wireless/ath/wil6210/txrx.c
@@ -509,7 +509,7 @@ static int wil_rx_refill(struct wil6210_priv *wil, int count)
 			break;
 		}
 	}
-	iowrite32(v->swtail, wil->csr + HOSTADDR(v->hwtail));
+	wil_w(wil, v->hwtail, v->swtail);
 
 	return rc;
 }
@@ -1422,7 +1422,7 @@ static int __wil_tx_vring_tso(struct wil6210_priv *wil, struct vring *vring,
 	 */
 	wmb();
 
-	iowrite32(vring->swhead, wil->csr + HOSTADDR(vring->hwtail));
+	wil_w(wil, vring->hwtail, vring->swhead);
 	return 0;
 
 dma_error:
@@ -1565,7 +1565,7 @@ static int __wil_tx_vring(struct wil6210_priv *wil, struct vring *vring,
 	 */
 	wmb();
 
-	iowrite32(vring->swhead, wil->csr + HOSTADDR(vring->hwtail));
+	wil_w(wil, vring->hwtail, vring->swhead);
 
 	return 0;
  dma_error:
diff --git a/drivers/net/wireless/ath/wil6210/wil6210.h b/drivers/net/wireless/ath/wil6210/wil6210.h
index 3c22178..c6b0fa2 100644
--- a/drivers/net/wireless/ath/wil6210/wil6210.h
+++ b/drivers/net/wireless/ath/wil6210/wil6210.h
@@ -252,9 +252,8 @@ enum {
 };
 
 /* popular locations */
-#define HOST_MBOX   HOSTADDR(RGF_USER_USER_SCRATCH_PAD)
-#define HOST_SW_INT (HOSTADDR(RGF_USER_USER_ICR) + \
-	offsetof(struct RGF_ICR, ICS))
+#define RGF_MBOX   RGF_USER_USER_SCRATCH_PAD
+#define HOST_MBOX   HOSTADDR(RGF_MBOX)
 #define SW_INT_MBOX BIT_USER_USER_ICR_SW_INT_2
 
 /* ISR register bits */
@@ -649,6 +648,32 @@ void wil_info(struct wil6210_priv *wil, const char *fmt, ...);
 #define wil_dbg_wmi(wil, fmt, arg...) wil_dbg(wil, "DBG[ WMI]" fmt, ##arg)
 #define wil_dbg_misc(wil, fmt, arg...) wil_dbg(wil, "DBG[MISC]" fmt, ##arg)
 
+/* target operations */
+/* register read */
+static inline u32 wil_r(struct wil6210_priv *wil, u32 reg)
+{
+	return readl(wil->csr + HOSTADDR(reg));
+}
+
+/* register write. wmb() to make sure it is completed */
+static inline void wil_w(struct wil6210_priv *wil, u32 reg, u32 val)
+{
+	writel(val, wil->csr + HOSTADDR(reg));
+	wmb(); /* wait for write to propagate to the HW */
+}
+
+/* register set = read, OR, write */
+static inline void wil_s(struct wil6210_priv *wil, u32 reg, u32 val)
+{
+	wil_w(wil, reg, wil_r(wil, reg) | val);
+}
+
+/* register clear = read, AND with inverted, write */
+static inline void wil_c(struct wil6210_priv *wil, u32 reg, u32 val)
+{
+	wil_w(wil, reg, wil_r(wil, reg) & ~val);
+}
+
 #if defined(CONFIG_DYNAMIC_DEBUG)
 #define wil_hex_dump_txrx(prefix_str, prefix_type, rowsize,	\
 			  groupsize, buf, len, ascii)		\
diff --git a/drivers/net/wireless/ath/wil6210/wmi.c b/drivers/net/wireless/ath/wil6210/wmi.c
index b9cf9a6..7a25736 100644
--- a/drivers/net/wireless/ath/wil6210/wmi.c
+++ b/drivers/net/wireless/ath/wil6210/wmi.c
@@ -228,8 +228,8 @@ static int __wmi_send(struct wil6210_priv *wil, u16 cmdid, void *buf, u16 len)
 	wil_dbg_wmi(wil, "Head 0x%08x -> 0x%08x\n", r->head, next_head);
 	/* wait till FW finish with previous command */
 	for (retry = 5; retry > 0; retry--) {
-		r->tail = ioread32(wil->csr + HOST_MBOX +
-				   offsetof(struct wil6210_mbox_ctl, tx.tail));
+		r->tail = wil_r(wil, RGF_MBOX +
+				offsetof(struct wil6210_mbox_ctl, tx.tail));
 		if (next_head != r->tail)
 			break;
 		msleep(20);
@@ -254,16 +254,16 @@ static int __wmi_send(struct wil6210_priv *wil, u16 cmdid, void *buf, u16 len)
 	wil_memcpy_toio_32(dst, &cmd, sizeof(cmd));
 	wil_memcpy_toio_32(dst + sizeof(cmd), buf, len);
 	/* mark entry as full */
-	iowrite32(1, wil->csr + HOSTADDR(r->head) +
-		  offsetof(struct wil6210_mbox_ring_desc, sync));
+	wil_w(wil, r->head + offsetof(struct wil6210_mbox_ring_desc, sync), 1);
 	/* advance next ptr */
-	iowrite32(r->head = next_head, wil->csr + HOST_MBOX +
-		  offsetof(struct wil6210_mbox_ctl, tx.head));
+	wil_w(wil, RGF_MBOX + offsetof(struct wil6210_mbox_ctl, tx.head),
+	      r->head = next_head);
 
 	trace_wil6210_wmi_cmd(&cmd.wmi, buf, len);
 
 	/* interrupt to FW */
-	iowrite32(SW_INT_MBOX, wil->csr + HOST_SW_INT);
+	wil_w(wil, RGF_USER_USER_ICR + offsetof(struct RGF_ICR, ICS),
+	      SW_INT_MBOX);
 
 	return 0;
 }
@@ -729,8 +729,8 @@ void wmi_recv_cmd(struct wil6210_priv *wil)
 		u16 len;
 		bool q;
 
-		r->head = ioread32(wil->csr + HOST_MBOX +
-				   offsetof(struct wil6210_mbox_ctl, rx.head));
+		r->head = wil_r(wil, RGF_MBOX +
+				offsetof(struct wil6210_mbox_ctl, rx.head));
 		if (r->tail == r->head)
 			break;
 
@@ -768,8 +768,8 @@ void wmi_recv_cmd(struct wil6210_priv *wil)
 		cmd = (void *)&evt->event.wmi;
 		wil_memcpy_fromio_32(cmd, src, len);
 		/* mark entry as empty */
-		iowrite32(0, wil->csr + HOSTADDR(r->tail) +
-			  offsetof(struct wil6210_mbox_ring_desc, sync));
+		wil_w(wil, r->tail +
+		      offsetof(struct wil6210_mbox_ring_desc, sync), 0);
 		/* indicate */
 		if ((hdr.type == WIL_MBOX_HDR_TYPE_WMI) &&
 		    (len >= sizeof(struct wil6210_mbox_hdr_wmi))) {
@@ -788,8 +788,8 @@ void wmi_recv_cmd(struct wil6210_priv *wil)
 		/* advance tail */
 		r->tail = r->base + ((r->tail - r->base +
 			  sizeof(struct wil6210_mbox_ring_desc)) % r->size);
-		iowrite32(r->tail, wil->csr + HOST_MBOX +
-			  offsetof(struct wil6210_mbox_ctl, rx.tail));
+		wil_w(wil, RGF_MBOX +
+		      offsetof(struct wil6210_mbox_ctl, rx.tail), r->tail);
 
 		/* add to the pending list */
 		spin_lock_irqsave(&wil->wmi_ev_lock, flags);
-- 
2.1.4

