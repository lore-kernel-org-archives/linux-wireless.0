Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from sabertooth01.qualcomm.com ([65.197.215.72]:2790 "EHLO
	sabertooth01.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751070AbaIVMcH (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 22 Sep 2014 08:32:07 -0400
From: Vladimir Kondratiev <qca_vkondrat@qca.qualcomm.com>
To: "John W . Linville" <linville@tuxdriver.com>
CC: Vladimir Kondratiev <qca_vkondrat@qca.qualcomm.com>,
	<linux-wireless@vger.kernel.org>, <wil6210@qca.qualcomm.com>
Subject: [PATCH] wil6210: ethtool ops
Date: Mon, 22 Sep 2014 15:31:41 +0300
Message-ID: <1411389101-4909-1-git-send-email-qca_vkondrat@qca.qualcomm.com> (sfid-20140922_143212_089025_9C6FC004)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Provide ethtool support; with support for interrupt coalescing through
get_coalesce/set_coalesce.
Placeholders for begin/complete will be used by runtime PM
to make sure target is powered up while performing ethtool operations

Signed-off-by: Vladimir Kondratiev <qca_vkondrat@qca.qualcomm.com>
---
 drivers/net/wireless/ath/wil6210/Makefile    |   1 +
 drivers/net/wireless/ath/wil6210/ethtool.c   | 103 +++++++++++++++++++++++++++
 drivers/net/wireless/ath/wil6210/interrupt.c |  12 +---
 drivers/net/wireless/ath/wil6210/main.c      |  26 +++++++
 drivers/net/wireless/ath/wil6210/netdev.c    |   1 +
 drivers/net/wireless/ath/wil6210/wil6210.h   |   7 +-
 6 files changed, 138 insertions(+), 12 deletions(-)
 create mode 100644 drivers/net/wireless/ath/wil6210/ethtool.c

diff --git a/drivers/net/wireless/ath/wil6210/Makefile b/drivers/net/wireless/ath/wil6210/Makefile
index a471d74..05f29a6 100644
--- a/drivers/net/wireless/ath/wil6210/Makefile
+++ b/drivers/net/wireless/ath/wil6210/Makefile
@@ -14,6 +14,7 @@ wil6210-y += fw.o
 wil6210-$(CONFIG_WIL6210_TRACING) += trace.o
 wil6210-y += wil_platform.o
 wil6210-$(CONFIG_WIL6210_PLATFORM_MSM) += wil_platform_msm.o
+wil6210-y += ethtool.o
 
 # for tracing framework to find trace.h
 CFLAGS_trace.o := -I$(src)
diff --git a/drivers/net/wireless/ath/wil6210/ethtool.c b/drivers/net/wireless/ath/wil6210/ethtool.c
new file mode 100644
index 0000000..d686638
--- /dev/null
+++ b/drivers/net/wireless/ath/wil6210/ethtool.c
@@ -0,0 +1,103 @@
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
+#include <linux/etherdevice.h>
+#include <linux/pci.h>
+#include <linux/rtnetlink.h>
+#include <net/cfg80211.h>
+
+#include "wil6210.h"
+
+static int wil_ethtoolops_begin(struct net_device *ndev)
+{
+	struct wil6210_priv *wil = ndev_to_wil(ndev);
+
+	mutex_lock(&wil->mutex);
+
+	wil_dbg_misc(wil, "%s()\n", __func__);
+
+	return 0;
+}
+
+static void wil_ethtoolops_complete(struct net_device *ndev)
+{
+	struct wil6210_priv *wil = ndev_to_wil(ndev);
+
+	wil_dbg_misc(wil, "%s()\n", __func__);
+
+	mutex_unlock(&wil->mutex);
+}
+
+static int wil_ethtoolops_get_coalesce(struct net_device *ndev,
+				       struct ethtool_coalesce *cp)
+{
+	struct wil6210_priv *wil = ndev_to_wil(ndev);
+	u32 itr_en, itr_val = 0;
+
+	wil_dbg_misc(wil, "%s()\n", __func__);
+
+	itr_en = ioread32(wil->csr + HOSTADDR(RGF_DMA_ITR_CNT_CRL));
+	if (itr_en & BIT_DMA_ITR_CNT_CRL_EN)
+		itr_val = ioread32(wil->csr + HOSTADDR(RGF_DMA_ITR_CNT_TRSH));
+
+	cp->rx_coalesce_usecs = itr_val;
+
+	return 0;
+}
+
+static int wil_ethtoolops_set_coalesce(struct net_device *ndev,
+				       struct ethtool_coalesce *cp)
+{
+	struct wil6210_priv *wil = ndev_to_wil(ndev);
+
+	wil_dbg_misc(wil, "%s(%d usec)\n", __func__, cp->rx_coalesce_usecs);
+
+	if (wil->wdev->iftype == NL80211_IFTYPE_MONITOR) {
+		wil_dbg_misc(wil, "No IRQ coalescing in monitor mode\n");
+		return -EINVAL;
+	}
+
+	/* only @rx_coalesce_usecs supported, ignore
+	 * other parameters
+	 */
+
+	if (cp->rx_coalesce_usecs > WIL6210_ITR_TRSH_MAX)
+		goto out_bad;
+
+	wil->itr_trsh = cp->rx_coalesce_usecs;
+	wil_set_itr_trsh(wil);
+
+	return 0;
+
+out_bad:
+	wil_dbg_misc(wil, "Unsupported coalescing params. Raw command:\n");
+	print_hex_dump_debug("DBG[MISC] coal ", DUMP_PREFIX_OFFSET, 16, 4,
+			     cp, sizeof(*cp), false);
+	return -EINVAL;
+}
+
+static const struct ethtool_ops wil_ethtool_ops = {
+	.begin		= wil_ethtoolops_begin,
+	.complete	= wil_ethtoolops_complete,
+	.get_drvinfo	= cfg80211_get_drvinfo,
+	.get_coalesce	= wil_ethtoolops_get_coalesce,
+	.set_coalesce	= wil_ethtoolops_set_coalesce,
+};
+
+void wil_set_ethtoolops(struct net_device *ndev)
+{
+	ndev->ethtool_ops = &wil_ethtool_ops;
+}
diff --git a/drivers/net/wireless/ath/wil6210/interrupt.c b/drivers/net/wireless/ath/wil6210/interrupt.c
index 7269bac..90f416f 100644
--- a/drivers/net/wireless/ath/wil6210/interrupt.c
+++ b/drivers/net/wireless/ath/wil6210/interrupt.c
@@ -157,17 +157,7 @@ void wil_unmask_irq(struct wil6210_priv *wil)
 		  offsetof(struct RGF_ICR, ICC));
 
 	/* interrupt moderation parameters */
-	if (wil->wdev->iftype == NL80211_IFTYPE_MONITOR) {
-		/* disable interrupt moderation for monitor
-		 * to get better timestamp precision
-		 */
-		iowrite32(0, wil->csr + HOSTADDR(RGF_DMA_ITR_CNT_CRL));
-	} else {
-		iowrite32(WIL6210_ITR_TRSH,
-			  wil->csr + HOSTADDR(RGF_DMA_ITR_CNT_TRSH));
-		iowrite32(BIT_DMA_ITR_CNT_CRL_EN,
-			  wil->csr + HOSTADDR(RGF_DMA_ITR_CNT_CRL));
-	}
+	wil_set_itr_trsh(wil);
 
 	wil6210_unmask_irq_pseudo(wil);
 	wil6210_unmask_irq_tx(wil);
diff --git a/drivers/net/wireless/ath/wil6210/main.c b/drivers/net/wireless/ath/wil6210/main.c
index 21667e0..0424763 100644
--- a/drivers/net/wireless/ath/wil6210/main.c
+++ b/drivers/net/wireless/ath/wil6210/main.c
@@ -33,6 +33,11 @@ static bool no_fw_load = true;
 module_param(no_fw_load, bool, S_IRUGO | S_IWUSR);
 MODULE_PARM_DESC(no_fw_load, " do not download FW, use one in on-card flash.");
 
+static unsigned int itr_trsh = WIL6210_ITR_TRSH_DEFAULT;
+
+module_param(itr_trsh, uint, S_IRUGO);
+MODULE_PARM_DESC(itr_trsh, " Interrupt moderation threshold, usecs.");
+
 #define RST_DELAY (20) /* msec, for loop in @wil_target_reset */
 #define RST_COUNT (1 + 1000/RST_DELAY) /* round up to be above 1 sec total */
 
@@ -309,6 +314,7 @@ int wil_priv_init(struct wil6210_priv *wil)
 	}
 
 	wil->last_fw_recovery = jiffies;
+	wil->itr_trsh = itr_trsh;
 
 	return 0;
 }
@@ -437,6 +443,26 @@ static int wil_target_reset(struct wil6210_priv *wil)
 	return 0;
 }
 
+/**
+ * wil_set_itr_trsh: - apply interrupt coalescing params
+ */
+void wil_set_itr_trsh(struct wil6210_priv *wil)
+{
+	/* disable, use usec resolution */
+	W(RGF_DMA_ITR_CNT_CRL, BIT_DMA_ITR_CNT_CRL_EXT_TICK);
+
+	/* disable interrupt moderation for monitor
+	 * to get better timestamp precision
+	 */
+	if (wil->wdev->iftype == NL80211_IFTYPE_MONITOR)
+		return;
+
+	wil_info(wil, "set ITR_TRSH = %d usec\n", wil->itr_trsh);
+	W(RGF_DMA_ITR_CNT_TRSH, wil->itr_trsh);
+	W(RGF_DMA_ITR_CNT_CRL, BIT_DMA_ITR_CNT_CRL_EN |
+	  BIT_DMA_ITR_CNT_CRL_EXT_TICK); /* start it */
+}
+
 #undef R
 #undef W
 #undef S
diff --git a/drivers/net/wireless/ath/wil6210/netdev.c b/drivers/net/wireless/ath/wil6210/netdev.c
index 1c0c77d..c3f0ddf 100644
--- a/drivers/net/wireless/ath/wil6210/netdev.c
+++ b/drivers/net/wireless/ath/wil6210/netdev.c
@@ -149,6 +149,7 @@ void *wil_if_alloc(struct device *dev, void __iomem *csr)
 	}
 
 	ndev->netdev_ops = &wil_netdev_ops;
+	wil_set_ethtoolops(ndev);
 	ndev->ieee80211_ptr = wdev;
 	ndev->hw_features = NETIF_F_HW_CSUM | NETIF_F_RXCSUM |
 			    NETIF_F_SG | NETIF_F_GRO;
diff --git a/drivers/net/wireless/ath/wil6210/wil6210.h b/drivers/net/wireless/ath/wil6210/wil6210.h
index 133eeb8..00c4f0a 100644
--- a/drivers/net/wireless/ath/wil6210/wil6210.h
+++ b/drivers/net/wireless/ath/wil6210/wil6210.h
@@ -52,7 +52,9 @@ static inline u32 WIL_GET_BITS(u32 x, int b0, int b1)
 #define WIL6210_MAX_TX_RINGS	(24) /* HW limit */
 #define WIL6210_MAX_CID		(8) /* HW limit */
 #define WIL6210_NAPI_BUDGET	(16) /* arbitrary */
-#define WIL6210_ITR_TRSH	(10000) /* arbitrary - about 15 IRQs/msec */
+/* Max supported by wil6210 value for interrupt threshold is 5sec. */
+#define WIL6210_ITR_TRSH_MAX (5000000)
+#define WIL6210_ITR_TRSH_DEFAULT	(300) /* usec */
 #define WIL6210_FW_RECOVERY_RETRIES	(5) /* try to recover this many times */
 #define WIL6210_FW_RECOVERY_TO	msecs_to_jiffies(5000)
 #define WIL6210_SCAN_TO		msecs_to_jiffies(10000)
@@ -393,6 +395,7 @@ struct wil6210_priv {
 	u32 monitor_flags;
 	u32 secure_pcp; /* create secure PCP? */
 	int sinfo_gen;
+	u32 itr_trsh;
 	/* cached ISR registers */
 	u32 isr_misc;
 	/* mailbox related */
@@ -502,6 +505,7 @@ void wil_if_remove(struct wil6210_priv *wil);
 int wil_priv_init(struct wil6210_priv *wil);
 void wil_priv_deinit(struct wil6210_priv *wil);
 int wil_reset(struct wil6210_priv *wil);
+void wil_set_itr_trsh(struct wil6210_priv *wil);
 void wil_fw_error_recovery(struct wil6210_priv *wil);
 void wil_link_on(struct wil6210_priv *wil);
 void wil_link_off(struct wil6210_priv *wil);
@@ -511,6 +515,7 @@ int wil_down(struct wil6210_priv *wil);
 int __wil_down(struct wil6210_priv *wil);
 void wil_mbox_ring_le2cpus(struct wil6210_mbox_ring *r);
 int wil_find_cid(struct wil6210_priv *wil, const u8 *mac);
+void wil_set_ethtoolops(struct net_device *ndev);
 
 void __iomem *wmi_buffer(struct wil6210_priv *wil, __le32 ptr);
 void __iomem *wmi_addr(struct wil6210_priv *wil, u32 ptr);
-- 
1.9.1

