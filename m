Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wolverine02.qualcomm.com ([199.106.114.251]:21171 "EHLO
	wolverine02.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755190AbaLWHse (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 23 Dec 2014 02:48:34 -0500
From: Vladimir Kondratiev <QCA_vkondrat@QCA.qualcomm.com>
Cc: Vladimir Kondratiev <QCA_vkondrat@QCA.qualcomm.com>,
	linux-wireless@vger.kernel.org, wil6210@qca.qualcomm.com
To: Kalle Valo <kvalo@qca.qualcomm.com>
Subject: [PATCH 17/22] wil6210: add advanced interrupt moderation
Date: Tue, 23 Dec 2014 09:47:19 +0200
Message-Id: <1419320844-23989-18-git-send-email-qca_vkondrat@qca.qualcomm.com> (sfid-20141223_091348_868916_D73EEED1)
In-Reply-To: <1419320844-23989-1-git-send-email-qca_vkondrat@qca.qualcomm.com>
References: <1419320844-23989-1-git-send-email-qca_vkondrat@qca.qualcomm.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Add advanced interrupt moderation support available since "Sparrow B0".
Legacy interrupt moderation used only one counter to moderate tx, rx,
and misc interrupts.
Advanced interrupt moderation bypasses misc, and handles separately tx
and rx interrupts. In addition it has two timers for each interrupt type.
Max burst duration timer which defines how long to postpone interrupt after
first event (receive event for rx and tx complete event for tx), and
interframe timeout which defines how to determine the end of the burst and
issue interrupt even if the first timer still pending.
Capabilities flags in wil_priv is set on initialization according to
HW. The rest of the code checks for advanced interrupt capability bit
in capabilities flags field.
Debugfs is split accordingly: "legacy" interrupt moderation remains
unchanged, new debugs files added for advanced interrupt moderation
support.
Module params are aligned to support advanced interrupt moderation
(tx & rx). When not available (for legacy interrupt moderation) will
use only rx configuration; Tx configuration will be ignored in this
case.

Signed-off-by: Vladimir Kondratiev <qca_vkondrat@qca.qualcomm.com>
---
 drivers/net/wireless/ath/wil6210/debugfs.c   | 49 ++++++++++++++++-
 drivers/net/wireless/ath/wil6210/ethtool.c   | 46 ++++++++++++----
 drivers/net/wireless/ath/wil6210/interrupt.c | 82 +++++++++++++++++++++++++++-
 drivers/net/wireless/ath/wil6210/main.c      | 56 +++++++++++--------
 drivers/net/wireless/ath/wil6210/pcie_bus.c  |  4 ++
 drivers/net/wireless/ath/wil6210/wil6210.h   | 56 +++++++++++++++++--
 6 files changed, 247 insertions(+), 46 deletions(-)

diff --git a/drivers/net/wireless/ath/wil6210/debugfs.c b/drivers/net/wireless/ath/wil6210/debugfs.c
index a36a753..59d764c 100644
--- a/drivers/net/wireless/ath/wil6210/debugfs.c
+++ b/drivers/net/wireless/ath/wil6210/debugfs.c
@@ -390,24 +390,67 @@ static int wil6210_debugfs_create_pseudo_ISR(struct wil6210_priv *wil,
 	return 0;
 }
 
-static const struct dbg_off itr_cnt_off[] = {
+static const struct dbg_off lgc_itr_cnt_off[] = {
 	{"TRSH", S_IRUGO | S_IWUSR, HOSTADDR(RGF_DMA_ITR_CNT_TRSH), doff_io32},
 	{"DATA", S_IRUGO | S_IWUSR, HOSTADDR(RGF_DMA_ITR_CNT_DATA), doff_io32},
 	{"CTL",  S_IRUGO | S_IWUSR, HOSTADDR(RGF_DMA_ITR_CNT_CRL), doff_io32},
 	{},
 };
 
+static const struct dbg_off tx_itr_cnt_off[] = {
+	{"TRSH", S_IRUGO | S_IWUSR, HOSTADDR(RGF_DMA_ITR_TX_CNT_TRSH),
+	 doff_io32},
+	{"DATA", S_IRUGO | S_IWUSR, HOSTADDR(RGF_DMA_ITR_TX_CNT_DATA),
+	 doff_io32},
+	{"CTL",  S_IRUGO | S_IWUSR, HOSTADDR(RGF_DMA_ITR_TX_CNT_CTL),
+	 doff_io32},
+	{"IDL_TRSH", S_IRUGO | S_IWUSR, HOSTADDR(RGF_DMA_ITR_TX_IDL_CNT_TRSH),
+	 doff_io32},
+	{"IDL_DATA", S_IRUGO | S_IWUSR, HOSTADDR(RGF_DMA_ITR_TX_IDL_CNT_DATA),
+	 doff_io32},
+	{"IDL_CTL",  S_IRUGO | S_IWUSR, HOSTADDR(RGF_DMA_ITR_TX_IDL_CNT_CTL),
+	 doff_io32},
+	{},
+};
+
+static const struct dbg_off rx_itr_cnt_off[] = {
+	{"TRSH", S_IRUGO | S_IWUSR, HOSTADDR(RGF_DMA_ITR_RX_CNT_TRSH),
+	 doff_io32},
+	{"DATA", S_IRUGO | S_IWUSR, HOSTADDR(RGF_DMA_ITR_RX_CNT_DATA),
+	 doff_io32},
+	{"CTL",  S_IRUGO | S_IWUSR, HOSTADDR(RGF_DMA_ITR_RX_CNT_CTL),
+	 doff_io32},
+	{"IDL_TRSH", S_IRUGO | S_IWUSR, HOSTADDR(RGF_DMA_ITR_RX_IDL_CNT_TRSH),
+	 doff_io32},
+	{"IDL_DATA", S_IRUGO | S_IWUSR, HOSTADDR(RGF_DMA_ITR_RX_IDL_CNT_DATA),
+	 doff_io32},
+	{"IDL_CTL",  S_IRUGO | S_IWUSR, HOSTADDR(RGF_DMA_ITR_RX_IDL_CNT_CTL),
+	 doff_io32},
+	{},
+};
+
 static int wil6210_debugfs_create_ITR_CNT(struct wil6210_priv *wil,
 					  struct dentry *parent)
 {
-	struct dentry *d = debugfs_create_dir("ITR_CNT", parent);
+	struct dentry *d, *dtx, *drx;
 
+	d = debugfs_create_dir("ITR_CNT", parent);
 	if (IS_ERR_OR_NULL(d))
 		return -ENODEV;
 
+	dtx = debugfs_create_dir("TX", d);
+	drx = debugfs_create_dir("RX", d);
+	if (IS_ERR_OR_NULL(dtx) || IS_ERR_OR_NULL(drx))
+		return -ENODEV;
+
 	wil6210_debugfs_init_offset(wil, d, (void * __force)wil->csr,
-				    itr_cnt_off);
+				    lgc_itr_cnt_off);
+
+	wil6210_debugfs_init_offset(wil, dtx, (void * __force)wil->csr,
+				    tx_itr_cnt_off);
 
+	wil6210_debugfs_init_offset(wil, drx, (void * __force)wil->csr,
+				    rx_itr_cnt_off);
 	return 0;
 }
 
diff --git a/drivers/net/wireless/ath/wil6210/ethtool.c b/drivers/net/wireless/ath/wil6210/ethtool.c
index d686638..4c44a82 100644
--- a/drivers/net/wireless/ath/wil6210/ethtool.c
+++ b/drivers/net/wireless/ath/wil6210/ethtool.c
@@ -45,16 +45,35 @@ static int wil_ethtoolops_get_coalesce(struct net_device *ndev,
 				       struct ethtool_coalesce *cp)
 {
 	struct wil6210_priv *wil = ndev_to_wil(ndev);
-	u32 itr_en, itr_val = 0;
+	u32 tx_itr_en, tx_itr_val = 0;
+	u32 rx_itr_en, rx_itr_val = 0;
 
 	wil_dbg_misc(wil, "%s()\n", __func__);
 
-	itr_en = ioread32(wil->csr + HOSTADDR(RGF_DMA_ITR_CNT_CRL));
-	if (itr_en & BIT_DMA_ITR_CNT_CRL_EN)
-		itr_val = ioread32(wil->csr + HOSTADDR(RGF_DMA_ITR_CNT_TRSH));
-
-	cp->rx_coalesce_usecs = itr_val;
+	if (test_bit(hw_capability_advanced_itr_moderation,
+		     wil->hw_capabilities)) {
+		tx_itr_en = ioread32(wil->csr +
+				     HOSTADDR(RGF_DMA_ITR_TX_CNT_CTL));
+		if (tx_itr_en & BIT_DMA_ITR_TX_CNT_CTL_EN)
+			tx_itr_val =
+				ioread32(wil->csr +
+					 HOSTADDR(RGF_DMA_ITR_TX_CNT_TRSH));
+
+		rx_itr_en = ioread32(wil->csr +
+				     HOSTADDR(RGF_DMA_ITR_RX_CNT_CTL));
+		if (rx_itr_en & BIT_DMA_ITR_RX_CNT_CTL_EN)
+			rx_itr_val =
+				ioread32(wil->csr +
+					 HOSTADDR(RGF_DMA_ITR_RX_CNT_TRSH));
+	} else {
+		rx_itr_en = ioread32(wil->csr + HOSTADDR(RGF_DMA_ITR_CNT_CRL));
+		if (rx_itr_en & BIT_DMA_ITR_CNT_CRL_EN)
+			rx_itr_val = ioread32(wil->csr +
+					      HOSTADDR(RGF_DMA_ITR_CNT_TRSH));
+	}
 
+	cp->tx_coalesce_usecs = tx_itr_val;
+	cp->rx_coalesce_usecs = rx_itr_val;
 	return 0;
 }
 
@@ -63,22 +82,25 @@ static int wil_ethtoolops_set_coalesce(struct net_device *ndev,
 {
 	struct wil6210_priv *wil = ndev_to_wil(ndev);
 
-	wil_dbg_misc(wil, "%s(%d usec)\n", __func__, cp->rx_coalesce_usecs);
+	wil_dbg_misc(wil, "%s(rx %d usec, tx %d usec)\n", __func__,
+		     cp->rx_coalesce_usecs, cp->tx_coalesce_usecs);
 
 	if (wil->wdev->iftype == NL80211_IFTYPE_MONITOR) {
 		wil_dbg_misc(wil, "No IRQ coalescing in monitor mode\n");
 		return -EINVAL;
 	}
 
-	/* only @rx_coalesce_usecs supported, ignore
-	 * other parameters
+	/* only @rx_coalesce_usecs and @tx_coalesce_usecs supported,
+	 * ignore other parameters
 	 */
 
-	if (cp->rx_coalesce_usecs > WIL6210_ITR_TRSH_MAX)
+	if (cp->rx_coalesce_usecs > WIL6210_ITR_TRSH_MAX ||
+	    cp->tx_coalesce_usecs > WIL6210_ITR_TRSH_MAX)
 		goto out_bad;
 
-	wil->itr_trsh = cp->rx_coalesce_usecs;
-	wil_set_itr_trsh(wil);
+	wil->tx_max_burst_duration = cp->tx_coalesce_usecs;
+	wil->rx_max_burst_duration = cp->rx_coalesce_usecs;
+	wil_configure_interrupt_moderation(wil);
 
 	return 0;
 
diff --git a/drivers/net/wireless/ath/wil6210/interrupt.c b/drivers/net/wireless/ath/wil6210/interrupt.c
index 384bb31..a6f9230 100644
--- a/drivers/net/wireless/ath/wil6210/interrupt.c
+++ b/drivers/net/wireless/ath/wil6210/interrupt.c
@@ -157,15 +157,91 @@ void wil_unmask_irq(struct wil6210_priv *wil)
 	iowrite32(WIL_ICR_ICC_VALUE, wil->csr + HOSTADDR(RGF_DMA_EP_MISC_ICR) +
 		  offsetof(struct RGF_ICR, ICC));
 
-	/* interrupt moderation parameters */
-	wil_set_itr_trsh(wil);
-
 	wil6210_unmask_irq_pseudo(wil);
 	wil6210_unmask_irq_tx(wil);
 	wil6210_unmask_irq_rx(wil);
 	wil6210_unmask_irq_misc(wil);
 }
 
+/* target write operation */
+#define W(a, v) do { iowrite32(v, wil->csr + HOSTADDR(a)); wmb(); } while (0)
+
+static
+void wil_configure_interrupt_moderation_new(struct wil6210_priv *wil)
+{
+	/* Disable and clear tx counter before (re)configuration */
+	W(RGF_DMA_ITR_TX_CNT_CTL, BIT_DMA_ITR_TX_CNT_CTL_CLR);
+	W(RGF_DMA_ITR_TX_CNT_TRSH, wil->tx_max_burst_duration);
+	wil_info(wil, "set ITR_TX_CNT_TRSH = %d usec\n",
+		 wil->tx_max_burst_duration);
+	/* Configure TX max burst duration timer to use usec units */
+	W(RGF_DMA_ITR_TX_CNT_CTL,
+	  BIT_DMA_ITR_TX_CNT_CTL_EN | BIT_DMA_ITR_TX_CNT_CTL_EXT_TIC_SEL);
+
+	/* Disable and clear tx idle counter before (re)configuration */
+	W(RGF_DMA_ITR_TX_IDL_CNT_CTL, BIT_DMA_ITR_TX_IDL_CNT_CTL_CLR);
+	W(RGF_DMA_ITR_TX_IDL_CNT_TRSH, wil->tx_interframe_timeout);
+	wil_info(wil, "set ITR_TX_IDL_CNT_TRSH = %d usec\n",
+		 wil->tx_interframe_timeout);
+	/* Configure TX max burst duration timer to use usec units */
+	W(RGF_DMA_ITR_TX_IDL_CNT_CTL, BIT_DMA_ITR_TX_IDL_CNT_CTL_EN |
+				      BIT_DMA_ITR_TX_IDL_CNT_CTL_EXT_TIC_SEL);
+
+	/* Disable and clear rx counter before (re)configuration */
+	W(RGF_DMA_ITR_RX_CNT_CTL, BIT_DMA_ITR_RX_CNT_CTL_CLR);
+	W(RGF_DMA_ITR_RX_CNT_TRSH, wil->rx_max_burst_duration);
+	wil_info(wil, "set ITR_RX_CNT_TRSH = %d usec\n",
+		 wil->rx_max_burst_duration);
+	/* Configure TX max burst duration timer to use usec units */
+	W(RGF_DMA_ITR_RX_CNT_CTL,
+	  BIT_DMA_ITR_RX_CNT_CTL_EN | BIT_DMA_ITR_RX_CNT_CTL_EXT_TIC_SEL);
+
+	/* Disable and clear rx idle counter before (re)configuration */
+	W(RGF_DMA_ITR_RX_IDL_CNT_CTL, BIT_DMA_ITR_RX_IDL_CNT_CTL_CLR);
+	W(RGF_DMA_ITR_RX_IDL_CNT_TRSH, wil->rx_interframe_timeout);
+	wil_info(wil, "set ITR_RX_IDL_CNT_TRSH = %d usec\n",
+		 wil->rx_interframe_timeout);
+	/* Configure TX max burst duration timer to use usec units */
+	W(RGF_DMA_ITR_RX_IDL_CNT_CTL, BIT_DMA_ITR_RX_IDL_CNT_CTL_EN |
+				      BIT_DMA_ITR_RX_IDL_CNT_CTL_EXT_TIC_SEL);
+}
+
+static
+void wil_configure_interrupt_moderation_lgc(struct wil6210_priv *wil)
+{
+	/* disable, use usec resolution */
+	W(RGF_DMA_ITR_CNT_CRL, BIT_DMA_ITR_CNT_CRL_CLR);
+
+	wil_info(wil, "set ITR_TRSH = %d usec\n", wil->rx_max_burst_duration);
+	W(RGF_DMA_ITR_CNT_TRSH, wil->rx_max_burst_duration);
+	/* start it */
+	W(RGF_DMA_ITR_CNT_CRL,
+	  BIT_DMA_ITR_CNT_CRL_EN | BIT_DMA_ITR_CNT_CRL_EXT_TICK);
+}
+
+#undef W
+
+void wil_configure_interrupt_moderation(struct wil6210_priv *wil)
+{
+	wil_dbg_irq(wil, "%s()\n", __func__);
+
+	/* disable interrupt moderation for monitor
+	 * to get better timestamp precision
+	 */
+	if (wil->wdev->iftype == NL80211_IFTYPE_MONITOR)
+		return;
+
+	if (test_bit(hw_capability_advanced_itr_moderation,
+		     wil->hw_capabilities))
+		wil_configure_interrupt_moderation_new(wil);
+	else {
+		/* Advanced interrupt moderation is not available before
+		 * Sparrow v2. Will use legacy interrupt moderation
+		 */
+		wil_configure_interrupt_moderation_lgc(wil);
+	}
+}
+
 static irqreturn_t wil6210_irq_rx(int irq, void *cookie)
 {
 	struct wil6210_priv *wil = cookie;
diff --git a/drivers/net/wireless/ath/wil6210/main.c b/drivers/net/wireless/ath/wil6210/main.c
index fb73ac5..d286153 100644
--- a/drivers/net/wireless/ath/wil6210/main.c
+++ b/drivers/net/wireless/ath/wil6210/main.c
@@ -33,10 +33,34 @@ static bool no_fw_load = true;
 module_param(no_fw_load, bool, S_IRUGO | S_IWUSR);
 MODULE_PARM_DESC(no_fw_load, " do not download FW, use one in on-card flash.");
 
-static unsigned int itr_trsh = WIL6210_ITR_TRSH_DEFAULT;
+static unsigned int tx_interframe_timeout =
+		WIL6210_ITR_TX_INTERFRAME_TIMEOUT_DEFAULT;
+
+module_param(tx_interframe_timeout, uint, S_IRUGO);
+MODULE_PARM_DESC(tx_interframe_timeout,
+		 " Interrupt moderation TX interframe timeout, usecs.");
+
+static unsigned int rx_interframe_timeout =
+		WIL6210_ITR_RX_INTERFRAME_TIMEOUT_DEFAULT;
+
+module_param(rx_interframe_timeout, uint, S_IRUGO);
+MODULE_PARM_DESC(rx_interframe_timeout,
+		 " Interrupt moderation RX interframe timeout, usecs.");
+
+static unsigned int tx_max_burst_duration =
+		WIL6210_ITR_TX_MAX_BURST_DURATION_DEFAULT;
+
+module_param(tx_max_burst_duration, uint, S_IRUGO);
+MODULE_PARM_DESC(tx_max_burst_duration,
+		 " Interrupt moderation TX max burst duration, usecs.");
+
+static unsigned int rx_max_burst_duration =
+		WIL6210_ITR_RX_MAX_BURST_DURATION_DEFAULT;
+
+module_param(rx_max_burst_duration, uint, S_IRUGO);
+MODULE_PARM_DESC(rx_max_burst_duration,
+		 " Interrupt moderation RX max burst duration, usecs.");
 
-module_param(itr_trsh, uint, S_IRUGO);
-MODULE_PARM_DESC(itr_trsh, " Interrupt moderation threshold, usecs.");
 
 /* We allow allocation of more than 1 page buffers to support large packets.
  * It is suboptimal behavior performance wise in case MTU above page size.
@@ -427,7 +451,10 @@ int wil_priv_init(struct wil6210_priv *wil)
 		goto out_wmi_wq;
 
 	wil->last_fw_recovery = jiffies;
-	wil->itr_trsh = itr_trsh;
+	wil->tx_interframe_timeout = tx_interframe_timeout;
+	wil->rx_interframe_timeout = rx_interframe_timeout;
+	wil->tx_max_burst_duration = tx_max_burst_duration;
+	wil->rx_max_burst_duration = rx_max_burst_duration;
 
 	return 0;
 
@@ -585,26 +612,6 @@ static int wil_target_reset(struct wil6210_priv *wil)
 	return 0;
 }
 
-/**
- * wil_set_itr_trsh: - apply interrupt coalescing params
- */
-void wil_set_itr_trsh(struct wil6210_priv *wil)
-{
-	/* disable, use usec resolution */
-	W(RGF_DMA_ITR_CNT_CRL, BIT_DMA_ITR_CNT_CRL_EXT_TICK);
-
-	/* disable interrupt moderation for monitor
-	 * to get better timestamp precision
-	 */
-	if (wil->wdev->iftype == NL80211_IFTYPE_MONITOR)
-		return;
-
-	wil_info(wil, "set ITR_TRSH = %d usec\n", wil->itr_trsh);
-	W(RGF_DMA_ITR_CNT_TRSH, wil->itr_trsh);
-	W(RGF_DMA_ITR_CNT_CRL, BIT_DMA_ITR_CNT_CRL_EN |
-	  BIT_DMA_ITR_CNT_CRL_EXT_TICK); /* start it */
-}
-
 #undef R
 #undef W
 #undef S
@@ -708,6 +715,7 @@ int wil_reset(struct wil6210_priv *wil)
 	reinit_completion(&wil->wmi_ready);
 	reinit_completion(&wil->wmi_call);
 
+	wil_configure_interrupt_moderation(wil);
 	wil_unmask_irq(wil);
 
 	/* we just started MAC, wait for FW ready */
diff --git a/drivers/net/wireless/ath/wil6210/pcie_bus.c b/drivers/net/wireless/ath/wil6210/pcie_bus.c
index 9b1a589..3dd2670 100644
--- a/drivers/net/wireless/ath/wil6210/pcie_bus.c
+++ b/drivers/net/wireless/ath/wil6210/pcie_bus.c
@@ -65,6 +65,10 @@ void wil_set_capabilities(struct wil6210_priv *wil)
 
 	if (wil->hw_version >= HW_VER_SPARROW_A0)
 		set_bit(hw_capability_reset_v2, wil->hw_capabilities);
+
+	if (wil->hw_version >= HW_VER_SPARROW_B0)
+		set_bit(hw_capability_advanced_itr_moderation,
+			wil->hw_capabilities);
 }
 
 void wil_disable_irq(struct wil6210_priv *wil)
diff --git a/drivers/net/wireless/ath/wil6210/wil6210.h b/drivers/net/wireless/ath/wil6210/wil6210.h
index 8a52a5f..a6d63c1 100644
--- a/drivers/net/wireless/ath/wil6210/wil6210.h
+++ b/drivers/net/wireless/ath/wil6210/wil6210.h
@@ -76,7 +76,10 @@ static inline u32 wil_mtu2macbuf(u32 mtu)
 #define WIL_MAX_ETH_MTU		(IEEE80211_MAX_DATA_LEN_DMG - 8)
 /* Max supported by wil6210 value for interrupt threshold is 5sec. */
 #define WIL6210_ITR_TRSH_MAX (5000000)
-#define WIL6210_ITR_TRSH_DEFAULT	(300) /* usec */
+#define WIL6210_ITR_TX_INTERFRAME_TIMEOUT_DEFAULT (15) /* usec */
+#define WIL6210_ITR_RX_INTERFRAME_TIMEOUT_DEFAULT (15) /* usec */
+#define WIL6210_ITR_TX_MAX_BURST_DURATION_DEFAULT (500) /* usec */
+#define WIL6210_ITR_RX_MAX_BURST_DURATION_DEFAULT (500) /* usec */
 #define WIL6210_FW_RECOVERY_RETRIES	(5) /* try to recover this many times */
 #define WIL6210_FW_RECOVERY_TO	msecs_to_jiffies(5000)
 #define WIL6210_SCAN_TO		msecs_to_jiffies(10000)
@@ -152,7 +155,7 @@ struct RGF_ICR {
 	#define BIT_DMA_EP_MISC_ICR_TX_NO_ACT	BIT(1)
 	#define BIT_DMA_EP_MISC_ICR_FW_INT(n)	BIT(28+n) /* n = [0..3] */
 
-/* Interrupt moderation control */
+/* Legacy interrupt moderation control (before Sparrow v2)*/
 #define RGF_DMA_ITR_CNT_TRSH		(0x881c5c)
 #define RGF_DMA_ITR_CNT_DATA		(0x881c60)
 #define RGF_DMA_ITR_CNT_CRL		(0x881c64)
@@ -162,6 +165,46 @@ struct RGF_ICR {
 	#define BIT_DMA_ITR_CNT_CRL_CLR		BIT(3)
 	#define BIT_DMA_ITR_CNT_CRL_REACH_TRSH	BIT(4)
 
+/* New (sparrow v2+) interrupt moderation control */
+#define RGF_DMA_ITR_TX_DESQ_NO_MOD		(0x881d40)
+#define RGF_DMA_ITR_TX_CNT_TRSH			(0x881d34)
+#define RGF_DMA_ITR_TX_CNT_DATA			(0x881d38)
+#define RGF_DMA_ITR_TX_CNT_CTL			(0x881d3c)
+	#define BIT_DMA_ITR_TX_CNT_CTL_EN		BIT(0)
+	#define BIT_DMA_ITR_TX_CNT_CTL_EXT_TIC_SEL	BIT(1)
+	#define BIT_DMA_ITR_TX_CNT_CTL_FOREVER		BIT(2)
+	#define BIT_DMA_ITR_TX_CNT_CTL_CLR		BIT(3)
+	#define BIT_DMA_ITR_TX_CNT_CTL_REACHED_TRESH	BIT(4)
+	#define BIT_DMA_ITR_TX_CNT_CTL_CROSS_EN		BIT(5)
+	#define BIT_DMA_ITR_TX_CNT_CTL_FREE_RUNNIG	BIT(6)
+#define RGF_DMA_ITR_TX_IDL_CNT_TRSH			(0x881d60)
+#define RGF_DMA_ITR_TX_IDL_CNT_DATA			(0x881d64)
+#define RGF_DMA_ITR_TX_IDL_CNT_CTL			(0x881d68)
+	#define BIT_DMA_ITR_TX_IDL_CNT_CTL_EN			BIT(0)
+	#define BIT_DMA_ITR_TX_IDL_CNT_CTL_EXT_TIC_SEL		BIT(1)
+	#define BIT_DMA_ITR_TX_IDL_CNT_CTL_FOREVER		BIT(2)
+	#define BIT_DMA_ITR_TX_IDL_CNT_CTL_CLR			BIT(3)
+	#define BIT_DMA_ITR_TX_IDL_CNT_CTL_REACHED_TRESH	BIT(4)
+#define RGF_DMA_ITR_RX_DESQ_NO_MOD		(0x881d50)
+#define RGF_DMA_ITR_RX_CNT_TRSH			(0x881d44)
+#define RGF_DMA_ITR_RX_CNT_DATA			(0x881d48)
+#define RGF_DMA_ITR_RX_CNT_CTL			(0x881d4c)
+	#define BIT_DMA_ITR_RX_CNT_CTL_EN		BIT(0)
+	#define BIT_DMA_ITR_RX_CNT_CTL_EXT_TIC_SEL	BIT(1)
+	#define BIT_DMA_ITR_RX_CNT_CTL_FOREVER		BIT(2)
+	#define BIT_DMA_ITR_RX_CNT_CTL_CLR		BIT(3)
+	#define BIT_DMA_ITR_RX_CNT_CTL_REACHED_TRESH	BIT(4)
+	#define BIT_DMA_ITR_RX_CNT_CTL_CROSS_EN		BIT(5)
+	#define BIT_DMA_ITR_RX_CNT_CTL_FREE_RUNNIG	BIT(6)
+#define RGF_DMA_ITR_RX_IDL_CNT_TRSH			(0x881d54)
+#define RGF_DMA_ITR_RX_IDL_CNT_DATA			(0x881d58)
+#define RGF_DMA_ITR_RX_IDL_CNT_CTL			(0x881d5c)
+	#define BIT_DMA_ITR_RX_IDL_CNT_CTL_EN			BIT(0)
+	#define BIT_DMA_ITR_RX_IDL_CNT_CTL_EXT_TIC_SEL		BIT(1)
+	#define BIT_DMA_ITR_RX_IDL_CNT_CTL_FOREVER		BIT(2)
+	#define BIT_DMA_ITR_RX_IDL_CNT_CTL_CLR			BIT(3)
+	#define BIT_DMA_ITR_RX_IDL_CNT_CTL_REACHED_TRESH	BIT(4)
+
 #define RGF_DMA_PSEUDO_CAUSE		(0x881c68)
 #define RGF_DMA_PSEUDO_CAUSE_MASK_SW	(0x881c6c)
 #define RGF_DMA_PSEUDO_CAUSE_MASK_FW	(0x881c70)
@@ -435,6 +478,7 @@ enum {
 
 enum {
 	hw_capability_reset_v2 = 0,
+	hw_capability_advanced_itr_moderation = 1,
 	hw_capability_last
 };
 
@@ -475,7 +519,11 @@ struct wil6210_priv {
 	u32 monitor_flags;
 	u32 secure_pcp; /* create secure PCP? */
 	int sinfo_gen;
-	u32 itr_trsh;
+	/* interrupt moderation */
+	u32 tx_max_burst_duration;
+	u32 tx_interframe_timeout;
+	u32 rx_max_burst_duration;
+	u32 rx_interframe_timeout;
 	/* cached ISR registers */
 	u32 isr_misc;
 	/* mailbox related */
@@ -596,7 +644,6 @@ void wil_if_remove(struct wil6210_priv *wil);
 int wil_priv_init(struct wil6210_priv *wil);
 void wil_priv_deinit(struct wil6210_priv *wil);
 int wil_reset(struct wil6210_priv *wil);
-void wil_set_itr_trsh(struct wil6210_priv *wil);
 void wil_fw_error_recovery(struct wil6210_priv *wil);
 void wil_set_recovery_state(struct wil6210_priv *wil, int state);
 void wil_link_on(struct wil6210_priv *wil);
@@ -653,6 +700,7 @@ int wil6210_init_irq(struct wil6210_priv *wil, int irq);
 void wil6210_fini_irq(struct wil6210_priv *wil, int irq);
 void wil_mask_irq(struct wil6210_priv *wil);
 void wil_unmask_irq(struct wil6210_priv *wil);
+void wil_configure_interrupt_moderation(struct wil6210_priv *wil);
 void wil_disable_irq(struct wil6210_priv *wil);
 void wil_enable_irq(struct wil6210_priv *wil);
 int wil_cfg80211_mgmt_tx(struct wiphy *wiphy, struct wireless_dev *wdev,
-- 
2.1.0

