Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from sabertooth02.qualcomm.com ([65.197.215.38]:55170 "EHLO
	sabertooth02.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751718AbaHDIW3 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 4 Aug 2014 04:22:29 -0400
From: Dedy Lansky <qca_dlansky@qualcomm.com>
Cc: Dedy Lansky <qca_dlansky@qualcomm.com>,
	<linux-wireless@vger.kernel.org>, <wil6210@qca.qualcomm.com>,
	Vladimir Kondratiev <qca_vkondrat@qca.qualcomm.com>
To: "John W . Linville" <linville@tuxdriver.com>
Subject: [PATCH 04/14] wil6210: Optimization for Interrupt moderation threshold value
Date: Mon, 4 Aug 2014 11:20:44 +0300
Message-ID: <1407140454-31639-5-git-send-email-qca_dlansky@qca.qualcomm.com> (sfid-20140804_102233_221817_35325E31)
In-Reply-To: <1407140454-31639-1-git-send-email-qca_dlansky@qca.qualcomm.com>
References: <1407140454-31639-1-git-send-email-qca_dlansky@qca.qualcomm.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Default value was changed to 50000 (~3 IRQs/msec) in order to reduce
significantly CPU usage without degradation in throughput.
Added module parameter named "itr_trsh" that allows the user to change
default value through insmod.
Added entry in debugfs (itr_trsh_val) for changing interrupt moderation
threshold in a single operation.

Signed-off-by: Dedy Lansky <qca_dlansky@qca.qualcomm.com>
---
 drivers/net/wireless/ath/wil6210/debugfs.c   | 50 +++++++++++++++++++++++++++-
 drivers/net/wireless/ath/wil6210/interrupt.c |  8 ++++-
 drivers/net/wireless/ath/wil6210/wil6210.h   |  2 +-
 3 files changed, 57 insertions(+), 3 deletions(-)

diff --git a/drivers/net/wireless/ath/wil6210/debugfs.c b/drivers/net/wireless/ath/wil6210/debugfs.c
index fb802bd..3990a2d 100644
--- a/drivers/net/wireless/ath/wil6210/debugfs.c
+++ b/drivers/net/wireless/ath/wil6210/debugfs.c
@@ -24,6 +24,12 @@
 #include "wil6210.h"
 #include "txrx.h"
 
+/* Max threshold supported value by wil6210 is 5sec.
+ * The interrupt moderation counter counts down every clock tick of 6nsec.
+ * Therefore max value for ITR_CNT_TRSH can be 5sec/6nsec = 833333333
+ */
+#define WIL6210_ITR_TRSH_MAX 833333333
+
 /* Nasty hack. Better have per device instances */
 static u32 mem_addr;
 static u32 dbg_txdesc_index;
@@ -270,6 +276,48 @@ static struct dentry *wil_debugfs_create_ulong(const char *name, umode_t mode,
 	return debugfs_create_file(name, mode, parent, value, &wil_fops_ulong);
 }
 
+static int wil_debugfs_itr_trsh_set(void *data, u64 val)
+{
+	struct wil6210_priv *wil = data;
+
+	/* Check value is smaller than max val limitation
+	 * (covers also negative values)
+	 */
+	if (val > WIL6210_ITR_TRSH_MAX)
+		return -EINVAL;
+
+	/* Perform interrupt moderation threshold update procedure */
+	iowrite32(0, wil->csr + HOSTADDR(RGF_DMA_ITR_CNT_CRL));
+	wmb(); /* make sure write propagated to HW */
+
+	iowrite32((u32)val, wil->csr + HOSTADDR(RGF_DMA_ITR_CNT_TRSH));
+	wmb(); /* make sure write propagated to HW */
+
+	iowrite32(BIT_DMA_ITR_CNT_CRL_EN,
+		  wil->csr + HOSTADDR(RGF_DMA_ITR_CNT_CRL));
+	wmb(); /* make sure write propagated to HW */
+
+	return 0;
+}
+
+static int wil_debugfs_itr_trsh_get(void *data, u64 *val)
+{
+	struct wil6210_priv *wil = data;
+	*val = ioread32(wil->csr + HOSTADDR(RGF_DMA_ITR_CNT_TRSH));
+	return 0;
+}
+
+DEFINE_SIMPLE_ATTRIBUTE(fops_itr_trsh, wil_debugfs_itr_trsh_get,
+			wil_debugfs_itr_trsh_set, "0x%08llx\n");
+
+static struct dentry *debugfs_create_itr_trsh(const char *name,
+					      umode_t mode,
+					      struct dentry *parent,
+					      struct wil6210_priv *wil)
+{
+	return debugfs_create_file(name, mode, parent, wil, &fops_itr_trsh);
+}
+
 static int wil6210_debugfs_create_ISR(struct wil6210_priv *wil,
 				      const char *name,
 				      struct dentry *parent, u32 off)
@@ -1024,7 +1072,7 @@ int wil6210_debugfs_init(struct wil6210_priv *wil)
 	wil_debugfs_create_iomem_x32("MAC_MTRL_COUNTER_0", S_IRUGO, dbg,
 				     wil->csr +
 				     HOSTADDR(RGF_MAC_MTRL_COUNTER_0));
-
+	debugfs_create_itr_trsh("itr_trsh_val", S_IRUGO | S_IWUSR, dbg, wil);
 	wil_debugfs_create_iomem_x32("RGF_USER_USAGE_1", S_IRUGO, dbg,
 				     wil->csr +
 				     HOSTADDR(RGF_USER_USAGE_1));
diff --git a/drivers/net/wireless/ath/wil6210/interrupt.c b/drivers/net/wireless/ath/wil6210/interrupt.c
index 98bfbb6..1f18e86 100644
--- a/drivers/net/wireless/ath/wil6210/interrupt.c
+++ b/drivers/net/wireless/ath/wil6210/interrupt.c
@@ -18,6 +18,12 @@
 
 #include "wil6210.h"
 #include "trace.h"
+#include <linux/moduleparam.h>
+
+static unsigned int itr_trsh = WIL6210_ITR_TRSH;
+
+module_param(itr_trsh, uint, S_IRUGO);
+MODULE_PARM_DESC(itr_trsh, " Interrupt moderation threshold value.");
 
 /**
  * Theory of operation:
@@ -163,7 +169,7 @@ void wil6210_enable_irq(struct wil6210_priv *wil)
 		 */
 		iowrite32(0, wil->csr + HOSTADDR(RGF_DMA_ITR_CNT_CRL));
 	} else {
-		iowrite32(WIL6210_ITR_TRSH,
+		iowrite32((u32)itr_trsh,
 			  wil->csr + HOSTADDR(RGF_DMA_ITR_CNT_TRSH));
 		iowrite32(BIT_DMA_ITR_CNT_CRL_EN,
 			  wil->csr + HOSTADDR(RGF_DMA_ITR_CNT_CRL));
diff --git a/drivers/net/wireless/ath/wil6210/wil6210.h b/drivers/net/wireless/ath/wil6210/wil6210.h
index 0097300..47d656a 100644
--- a/drivers/net/wireless/ath/wil6210/wil6210.h
+++ b/drivers/net/wireless/ath/wil6210/wil6210.h
@@ -47,7 +47,7 @@ static inline u32 WIL_GET_BITS(u32 x, int b0, int b1)
 #define WIL6210_MAX_TX_RINGS	(24) /* HW limit */
 #define WIL6210_MAX_CID		(8) /* HW limit */
 #define WIL6210_NAPI_BUDGET	(16) /* arbitrary */
-#define WIL6210_ITR_TRSH	(10000) /* arbitrary - about 15 IRQs/msec */
+#define WIL6210_ITR_TRSH	(50000) /* about 3 IRQs/msec */
 #define WIL6210_FW_RECOVERY_RETRIES	(5) /* try to recover this many times */
 #define WIL6210_FW_RECOVERY_TO	msecs_to_jiffies(5000)
 #define WIL6210_SCAN_TO		msecs_to_jiffies(10000)
-- 
1.8.5.2

