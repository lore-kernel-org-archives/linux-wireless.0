Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wolverine01.qualcomm.com ([199.106.114.254]:27539 "EHLO
	wolverine01.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758072AbcDELYX (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 5 Apr 2016 07:24:23 -0400
From: Maya Erez <qca_merez@qca.qualcomm.com>
To: Kalle Valo <kvalo@codeaurora.org>
Cc: Maya Erez <qca_merez@qca.qualcomm.com>,
	linux-wireless@vger.kernel.org, wil6210@qca.qualcomm.com
Subject: [PATCH 6/7] wil6210: prevent deep sleep of 60G device in critical paths
Date: Tue,  5 Apr 2016 14:24:06 +0300
Message-Id: <1459855447-17413-7-git-send-email-qca_merez@qca.qualcomm.com> (sfid-20160405_132431_554040_0C6C110A)
In-Reply-To: <1459855447-17413-1-git-send-email-qca_merez@qca.qualcomm.com>
References: <1459855447-17413-1-git-send-email-qca_merez@qca.qualcomm.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

In idle times 60G device can enter deep sleep and turn off
its XTAL clock.
Host access triggers the device power-up flow which will hold
the AHB during XTAL stabilization until device switches from
slow-clock to XTAL clock.
This behavior can stall the PCIe bus for some arbitrary period
of time.
In order to prevent this stall, host can vote for High Latency
Access Policy (HALP) before reading from PCIe bus.
This vote will wakeup the device from deep sleep and prevent
deep sleep until unvote is done.

Signed-off-by: Maya Erez <qca_merez@qca.qualcomm.com>
---
 drivers/net/wireless/ath/wil6210/debugfs.c   | 22 +++++---
 drivers/net/wireless/ath/wil6210/interrupt.c | 80 ++++++++++++++++++++++------
 drivers/net/wireless/ath/wil6210/main.c      | 75 ++++++++++++++++++++++++--
 drivers/net/wireless/ath/wil6210/wil6210.h   | 29 +++++++++-
 drivers/net/wireless/ath/wil6210/wmi.c       | 20 +++++--
 5 files changed, 194 insertions(+), 32 deletions(-)

diff --git a/drivers/net/wireless/ath/wil6210/debugfs.c b/drivers/net/wireless/ath/wil6210/debugfs.c
index b338a09..5d8823d 100644
--- a/drivers/net/wireless/ath/wil6210/debugfs.c
+++ b/drivers/net/wireless/ath/wil6210/debugfs.c
@@ -171,6 +171,8 @@ static void wil_print_ring(struct seq_file *s, const char *prefix,
 	int rsize;
 	uint i;
 
+	wil_halp_vote(wil);
+
 	wil_memcpy_fromio_32(&r, off, sizeof(r));
 	wil_mbox_ring_le2cpus(&r);
 	/*
@@ -236,6 +238,7 @@ static void wil_print_ring(struct seq_file *s, const char *prefix,
 	}
  out:
 	seq_puts(s, "}\n");
+	wil_halp_unvote(wil);
 }
 
 static int wil_mbox_debugfs_show(struct seq_file *s, void *data)
@@ -500,9 +503,9 @@ static ssize_t wil_read_file_ioblob(struct file *file, char __user *user_buf,
 				    size_t count, loff_t *ppos)
 {
 	enum { max_count = 4096 };
-	struct debugfs_blob_wrapper *blob = file->private_data;
+	struct wil_blob_wrapper *wil_blob = file->private_data;
 	loff_t pos = *ppos;
-	size_t available = blob->size;
+	size_t available = wil_blob->blob.size;
 	void *buf;
 	size_t ret;
 
@@ -521,8 +524,9 @@ static ssize_t wil_read_file_ioblob(struct file *file, char __user *user_buf,
 	if (!buf)
 		return -ENOMEM;
 
-	wil_memcpy_fromio_32(buf, (const volatile void __iomem *)blob->data +
-			     pos, count);
+	wil_memcpy_fromio_halp_vote(wil_blob->wil, buf,
+				    (const volatile void __iomem *)
+				    wil_blob->blob.data + pos, count);
 
 	ret = copy_to_user(user_buf, buf, count);
 	kfree(buf);
@@ -545,9 +549,9 @@ static
 struct dentry *wil_debugfs_create_ioblob(const char *name,
 					 umode_t mode,
 					 struct dentry *parent,
-					 struct debugfs_blob_wrapper *blob)
+					 struct wil_blob_wrapper *wil_blob)
 {
-	return debugfs_create_file(name, mode, parent, blob, &fops_ioblob);
+	return debugfs_create_file(name, mode, parent, wil_blob, &fops_ioblob);
 }
 
 /*---reset---*/
@@ -1445,16 +1449,18 @@ static void wil6210_debugfs_init_blobs(struct wil6210_priv *wil,
 	char name[32];
 
 	for (i = 0; i < ARRAY_SIZE(fw_mapping); i++) {
-		struct debugfs_blob_wrapper *blob = &wil->blobs[i];
+		struct wil_blob_wrapper *wil_blob = &wil->blobs[i];
+		struct debugfs_blob_wrapper *blob = &wil_blob->blob;
 		const struct fw_map *map = &fw_mapping[i];
 
 		if (!map->name)
 			continue;
 
+		wil_blob->wil = wil;
 		blob->data = (void * __force)wil->csr + HOSTADDR(map->host);
 		blob->size = map->to - map->from;
 		snprintf(name, sizeof(name), "blob_%s", map->name);
-		wil_debugfs_create_ioblob(name, S_IRUGO, dbg, blob);
+		wil_debugfs_create_ioblob(name, S_IRUGO, dbg, wil_blob);
 	}
 }
 
diff --git a/drivers/net/wireless/ath/wil6210/interrupt.c b/drivers/net/wireless/ath/wil6210/interrupt.c
index 22592f3..011e741 100644
--- a/drivers/net/wireless/ath/wil6210/interrupt.c
+++ b/drivers/net/wireless/ath/wil6210/interrupt.c
@@ -35,17 +35,19 @@
  *
  */
 
-#define WIL6210_IRQ_DISABLE	(0xFFFFFFFFUL)
+#define WIL6210_IRQ_DISABLE		(0xFFFFFFFFUL)
+#define WIL6210_IRQ_DISABLE_NO_HALP	(0xF7FFFFFFUL)
 #define WIL6210_IMC_RX		(BIT_DMA_EP_RX_ICR_RX_DONE | \
 				 BIT_DMA_EP_RX_ICR_RX_HTRSH)
 #define WIL6210_IMC_RX_NO_RX_HTRSH (WIL6210_IMC_RX & \
 				    (~(BIT_DMA_EP_RX_ICR_RX_HTRSH)))
 #define WIL6210_IMC_TX		(BIT_DMA_EP_TX_ICR_TX_DONE | \
 				BIT_DMA_EP_TX_ICR_TX_DONE_N(0))
-#define WIL6210_IMC_MISC	(ISR_MISC_FW_READY | \
-				 ISR_MISC_MBOX_EVT | \
-				 ISR_MISC_FW_ERROR)
-
+#define WIL6210_IMC_MISC_NO_HALP	(ISR_MISC_FW_READY | \
+					 ISR_MISC_MBOX_EVT | \
+					 ISR_MISC_FW_ERROR)
+#define WIL6210_IMC_MISC		(WIL6210_IMC_MISC_NO_HALP | \
+					 BIT_DMA_EP_MISC_ICR_HALP)
 #define WIL6210_IRQ_PSEUDO_MASK (u32)(~(BIT_DMA_PSEUDO_CAUSE_RX | \
 					BIT_DMA_PSEUDO_CAUSE_TX | \
 					BIT_DMA_PSEUDO_CAUSE_MISC))
@@ -53,6 +55,7 @@
 #if defined(CONFIG_WIL6210_ISR_COR)
 /* configure to Clear-On-Read mode */
 #define WIL_ICR_ICC_VALUE	(0xFFFFFFFFUL)
+#define WIL_ICR_ICC_MISC_VALUE	(0xF7FFFFFFUL)
 
 static inline void wil_icr_clear(u32 x, void __iomem *addr)
 {
@@ -60,6 +63,7 @@ static inline void wil_icr_clear(u32 x, void __iomem *addr)
 #else /* defined(CONFIG_WIL6210_ISR_COR) */
 /* configure to Write-1-to-Clear mode */
 #define WIL_ICR_ICC_VALUE	(0UL)
+#define WIL_ICR_ICC_MISC_VALUE	(0UL)
 
 static inline void wil_icr_clear(u32 x, void __iomem *addr)
 {
@@ -88,10 +92,21 @@ static void wil6210_mask_irq_rx(struct wil6210_priv *wil)
 	      WIL6210_IRQ_DISABLE);
 }
 
-static void wil6210_mask_irq_misc(struct wil6210_priv *wil)
+static void wil6210_mask_irq_misc(struct wil6210_priv *wil, bool mask_halp)
 {
+	wil_dbg_irq(wil, "%s: mask_halp(%s)\n", __func__,
+		    mask_halp ? "true" : "false");
+
 	wil_w(wil, RGF_DMA_EP_MISC_ICR + offsetof(struct RGF_ICR, IMS),
-	      WIL6210_IRQ_DISABLE);
+	      mask_halp ? WIL6210_IRQ_DISABLE : WIL6210_IRQ_DISABLE_NO_HALP);
+}
+
+static void wil6210_mask_halp(struct wil6210_priv *wil)
+{
+	wil_dbg_irq(wil, "%s()\n", __func__);
+
+	wil_w(wil, RGF_DMA_EP_MISC_ICR + offsetof(struct RGF_ICR, IMS),
+	      BIT_DMA_EP_MISC_ICR_HALP);
 }
 
 static void wil6210_mask_irq_pseudo(struct wil6210_priv *wil)
@@ -117,10 +132,21 @@ void wil6210_unmask_irq_rx(struct wil6210_priv *wil)
 	      unmask_rx_htrsh ? WIL6210_IMC_RX : WIL6210_IMC_RX_NO_RX_HTRSH);
 }
 
-static void wil6210_unmask_irq_misc(struct wil6210_priv *wil)
+static void wil6210_unmask_irq_misc(struct wil6210_priv *wil, bool unmask_halp)
 {
+	wil_dbg_irq(wil, "%s: unmask_halp(%s)\n", __func__,
+		    unmask_halp ? "true" : "false");
+
 	wil_w(wil, RGF_DMA_EP_MISC_ICR + offsetof(struct RGF_ICR, IMC),
-	      WIL6210_IMC_MISC);
+	      unmask_halp ? WIL6210_IMC_MISC : WIL6210_IMC_MISC_NO_HALP);
+}
+
+static void wil6210_unmask_halp(struct wil6210_priv *wil)
+{
+	wil_dbg_irq(wil, "%s()\n", __func__);
+
+	wil_w(wil, RGF_DMA_EP_MISC_ICR + offsetof(struct RGF_ICR, IMC),
+	      BIT_DMA_EP_MISC_ICR_HALP);
 }
 
 static void wil6210_unmask_irq_pseudo(struct wil6210_priv *wil)
@@ -138,7 +164,7 @@ void wil_mask_irq(struct wil6210_priv *wil)
 
 	wil6210_mask_irq_tx(wil);
 	wil6210_mask_irq_rx(wil);
-	wil6210_mask_irq_misc(wil);
+	wil6210_mask_irq_misc(wil, true);
 	wil6210_mask_irq_pseudo(wil);
 }
 
@@ -151,12 +177,12 @@ void wil_unmask_irq(struct wil6210_priv *wil)
 	wil_w(wil, RGF_DMA_EP_TX_ICR + offsetof(struct RGF_ICR, ICC),
 	      WIL_ICR_ICC_VALUE);
 	wil_w(wil, RGF_DMA_EP_MISC_ICR + offsetof(struct RGF_ICR, ICC),
-	      WIL_ICR_ICC_VALUE);
+	      WIL_ICR_ICC_MISC_VALUE);
 
 	wil6210_unmask_irq_pseudo(wil);
 	wil6210_unmask_irq_tx(wil);
 	wil6210_unmask_irq_rx(wil);
-	wil6210_unmask_irq_misc(wil);
+	wil6210_unmask_irq_misc(wil, true);
 }
 
 void wil_configure_interrupt_moderation(struct wil6210_priv *wil)
@@ -345,7 +371,7 @@ static irqreturn_t wil6210_irq_misc(int irq, void *cookie)
 		return IRQ_NONE;
 	}
 
-	wil6210_mask_irq_misc(wil);
+	wil6210_mask_irq_misc(wil, false);
 
 	if (isr & ISR_MISC_FW_ERROR) {
 		u32 fw_assert_code = wil_r(wil, RGF_FW_ASSERT_CODE);
@@ -373,12 +399,19 @@ static irqreturn_t wil6210_irq_misc(int irq, void *cookie)
 		isr &= ~ISR_MISC_FW_READY;
 	}
 
+	if (isr & BIT_DMA_EP_MISC_ICR_HALP) {
+		wil_dbg_irq(wil, "%s: HALP IRQ invoked\n", __func__);
+		wil6210_mask_halp(wil);
+		isr &= ~BIT_DMA_EP_MISC_ICR_HALP;
+		complete(&wil->halp.comp);
+	}
+
 	wil->isr_misc = isr;
 
 	if (isr) {
 		return IRQ_WAKE_THREAD;
 	} else {
-		wil6210_unmask_irq_misc(wil);
+		wil6210_unmask_irq_misc(wil, false);
 		return IRQ_HANDLED;
 	}
 }
@@ -415,7 +448,7 @@ static irqreturn_t wil6210_irq_misc_thread(int irq, void *cookie)
 
 	wil->isr_misc = 0;
 
-	wil6210_unmask_irq_misc(wil);
+	wil6210_unmask_irq_misc(wil, false);
 
 	return IRQ_HANDLED;
 }
@@ -557,6 +590,23 @@ void wil6210_clear_irq(struct wil6210_priv *wil)
 	wmb(); /* make sure write completed */
 }
 
+void wil6210_set_halp(struct wil6210_priv *wil)
+{
+	wil_dbg_misc(wil, "%s()\n", __func__);
+
+	wil_w(wil, RGF_DMA_EP_MISC_ICR + offsetof(struct RGF_ICR, ICS),
+	      BIT_DMA_EP_MISC_ICR_HALP);
+}
+
+void wil6210_clear_halp(struct wil6210_priv *wil)
+{
+	wil_dbg_misc(wil, "%s()\n", __func__);
+
+	wil_w(wil, RGF_DMA_EP_MISC_ICR + offsetof(struct RGF_ICR, ICR),
+	      BIT_DMA_EP_MISC_ICR_HALP);
+	wil6210_unmask_halp(wil);
+}
+
 int wil6210_init_irq(struct wil6210_priv *wil, int irq, bool use_msi)
 {
 	int rc;
diff --git a/drivers/net/wireless/ath/wil6210/main.c b/drivers/net/wireless/ath/wil6210/main.c
index 261bdab..f7ed651 100644
--- a/drivers/net/wireless/ath/wil6210/main.c
+++ b/drivers/net/wireless/ath/wil6210/main.c
@@ -23,6 +23,8 @@
 #include "wmi.h"
 #include "boot_loader.h"
 
+#define WAIT_FOR_HALP_VOTE_MS 100
+
 bool debug_fw; /* = false; */
 module_param(debug_fw, bool, S_IRUGO);
 MODULE_PARM_DESC(debug_fw, " do not perform card reset. For FW debug");
@@ -132,6 +134,14 @@ void wil_memcpy_fromio_32(void *dst, const volatile void __iomem *src,
 		*d++ = __raw_readl(s++);
 }
 
+void wil_memcpy_fromio_halp_vote(struct wil6210_priv *wil, void *dst,
+				 const volatile void __iomem *src, size_t count)
+{
+	wil_halp_vote(wil);
+	wil_memcpy_fromio_32(dst, src, count);
+	wil_halp_unvote(wil);
+}
+
 void wil_memcpy_toio_32(volatile void __iomem *dst, const void *src,
 			size_t count)
 {
@@ -142,6 +152,15 @@ void wil_memcpy_toio_32(volatile void __iomem *dst, const void *src,
 		__raw_writel(*s++, d++);
 }
 
+void wil_memcpy_toio_halp_vote(struct wil6210_priv *wil,
+			       volatile void __iomem *dst,
+			       const void *src, size_t count)
+{
+	wil_halp_vote(wil);
+	wil_memcpy_toio_32(dst, src, count);
+	wil_halp_unvote(wil);
+}
+
 static void wil_disconnect_cid(struct wil6210_priv *wil, int cid,
 			       u16 reason_code, bool from_event)
 __acquires(&sta->tid_rx_lock) __releases(&sta->tid_rx_lock)
@@ -474,9 +493,11 @@ int wil_priv_init(struct wil6210_priv *wil)
 	mutex_init(&wil->wmi_mutex);
 	mutex_init(&wil->probe_client_mutex);
 	mutex_init(&wil->p2p_wdev_mutex);
+	mutex_init(&wil->halp.lock);
 
 	init_completion(&wil->wmi_ready);
 	init_completion(&wil->wmi_call);
+	init_completion(&wil->halp.comp);
 
 	wil->bcast_vring = -1;
 	setup_timer(&wil->connect_timer, wil_connect_timer_fn, (ulong)wil);
@@ -572,11 +593,10 @@ static inline void wil_release_cpu(struct wil6210_priv *wil)
 static void wil_set_oob_mode(struct wil6210_priv *wil, bool enable)
 {
 	wil_info(wil, "%s: enable=%d\n", __func__, enable);
-	if (enable) {
+	if (enable)
 		wil_s(wil, RGF_USER_USAGE_6, BIT_USER_OOB_MODE);
-	} else {
+	else
 		wil_c(wil, RGF_USER_USAGE_6, BIT_USER_OOB_MODE);
-	}
 }
 
 static int wil_target_reset(struct wil6210_priv *wil)
@@ -888,6 +908,7 @@ int wil_reset(struct wil6210_priv *wil, bool load_fw)
 	wil->ap_isolate = 0;
 	reinit_completion(&wil->wmi_ready);
 	reinit_completion(&wil->wmi_call);
+	reinit_completion(&wil->halp.comp);
 
 	if (load_fw) {
 		wil_configure_interrupt_moderation(wil);
@@ -1078,3 +1099,51 @@ int wil_find_cid(struct wil6210_priv *wil, const u8 *mac)
 
 	return rc;
 }
+
+void wil_halp_vote(struct wil6210_priv *wil)
+{
+	unsigned long rc;
+	unsigned long to_jiffies = msecs_to_jiffies(WAIT_FOR_HALP_VOTE_MS);
+
+	mutex_lock(&wil->halp.lock);
+
+	wil_dbg_misc(wil, "%s: start, HALP ref_cnt (%d)\n", __func__,
+		     wil->halp.ref_cnt);
+
+	if (++wil->halp.ref_cnt == 1) {
+		wil6210_set_halp(wil);
+		rc = wait_for_completion_timeout(&wil->halp.comp, to_jiffies);
+		if (!rc)
+			wil_err(wil, "%s: HALP vote timed out\n", __func__);
+		else
+			wil_dbg_misc(wil,
+				     "%s: HALP vote completed after %d ms\n",
+				     __func__,
+				     jiffies_to_msecs(to_jiffies - rc));
+	}
+
+	wil_dbg_misc(wil, "%s: end, HALP ref_cnt (%d)\n", __func__,
+		     wil->halp.ref_cnt);
+
+	mutex_unlock(&wil->halp.lock);
+}
+
+void wil_halp_unvote(struct wil6210_priv *wil)
+{
+	WARN_ON(wil->halp.ref_cnt == 0);
+
+	mutex_lock(&wil->halp.lock);
+
+	wil_dbg_misc(wil, "%s: start, HALP ref_cnt (%d)\n", __func__,
+		     wil->halp.ref_cnt);
+
+	if (--wil->halp.ref_cnt == 0) {
+		wil6210_clear_halp(wil);
+		wil_dbg_misc(wil, "%s: HALP unvote\n", __func__);
+	}
+
+	wil_dbg_misc(wil, "%s: end, HALP ref_cnt (%d)\n", __func__,
+		     wil->halp.ref_cnt);
+
+	mutex_unlock(&wil->halp.lock);
+}
diff --git a/drivers/net/wireless/ath/wil6210/wil6210.h b/drivers/net/wireless/ath/wil6210/wil6210.h
index 84b3fa6..32e7348 100644
--- a/drivers/net/wireless/ath/wil6210/wil6210.h
+++ b/drivers/net/wireless/ath/wil6210/wil6210.h
@@ -168,6 +168,7 @@ struct RGF_ICR {
 #define RGF_DMA_EP_MISC_ICR		(0x881bec) /* struct RGF_ICR */
 	#define BIT_DMA_EP_MISC_ICR_RX_HTRSH	BIT(0)
 	#define BIT_DMA_EP_MISC_ICR_TX_NO_ACT	BIT(1)
+	#define BIT_DMA_EP_MISC_ICR_HALP	BIT(27)
 	#define BIT_DMA_EP_MISC_ICR_FW_INT(n)	BIT(28+n) /* n = [0..3] */
 
 /* Legacy interrupt moderation control (before Sparrow v2)*/
@@ -534,6 +535,17 @@ struct pmc_ctx {
 	int			descriptor_size;
 };
 
+struct wil_halp {
+	struct mutex		lock; /* protect halp ref_cnt */
+	unsigned int		ref_cnt;
+	struct completion	comp;
+};
+
+struct wil_blob_wrapper {
+	struct wil6210_priv *wil;
+	struct debugfs_blob_wrapper blob;
+};
+
 struct wil6210_priv {
 	struct pci_dev *pdev;
 	struct wireless_dev *wdev;
@@ -606,7 +618,7 @@ struct wil6210_priv {
 	atomic_t isr_count_rx, isr_count_tx;
 	/* debugfs */
 	struct dentry *debug;
-	struct debugfs_blob_wrapper blobs[ARRAY_SIZE(fw_mapping)];
+	struct wil_blob_wrapper blobs[ARRAY_SIZE(fw_mapping)];
 	u8 discovery_mode;
 
 	void *platform_handle;
@@ -622,6 +634,10 @@ struct wil6210_priv {
 	struct wireless_dev *p2p_wdev;
 	struct mutex p2p_wdev_mutex; /* protect @p2p_wdev */
 	struct wireless_dev *radio_wdev;
+
+	/* High Access Latency Policy voting */
+	struct wil_halp halp;
+
 };
 
 #define wil_to_wiphy(i) (i->wdev->wiphy)
@@ -720,6 +736,12 @@ void wil_memcpy_fromio_32(void *dst, const volatile void __iomem *src,
 			  size_t count);
 void wil_memcpy_toio_32(volatile void __iomem *dst, const void *src,
 			size_t count);
+void wil_memcpy_fromio_halp_vote(struct wil6210_priv *wil, void *dst,
+				 const volatile void __iomem *src,
+				 size_t count);
+void wil_memcpy_toio_halp_vote(struct wil6210_priv *wil,
+			       volatile void __iomem *dst,
+			       const void *src, size_t count);
 
 void *wil_if_alloc(struct device *dev);
 void wil_if_free(struct wil6210_priv *wil);
@@ -856,4 +878,9 @@ int wil_resume(struct wil6210_priv *wil, bool is_runtime);
 int wil_fw_copy_crash_dump(struct wil6210_priv *wil, void *dest, u32 size);
 void wil_fw_core_dump(struct wil6210_priv *wil);
 
+void wil_halp_vote(struct wil6210_priv *wil);
+void wil_halp_unvote(struct wil6210_priv *wil);
+void wil6210_set_halp(struct wil6210_priv *wil);
+void wil6210_clear_halp(struct wil6210_priv *wil);
+
 #endif /* __WIL6210_H__ */
diff --git a/drivers/net/wireless/ath/wil6210/wmi.c b/drivers/net/wireless/ath/wil6210/wmi.c
index 3cc4462..f83bde1 100644
--- a/drivers/net/wireless/ath/wil6210/wmi.c
+++ b/drivers/net/wireless/ath/wil6210/wmi.c
@@ -194,6 +194,7 @@ static int __wmi_send(struct wil6210_priv *wil, u16 cmdid, void *buf, u16 len)
 	void __iomem *dst;
 	void __iomem *head = wmi_addr(wil, r->head);
 	uint retry;
+	int rc = 0;
 
 	if (sizeof(cmd) + len > r->entry_size) {
 		wil_err(wil, "WMI size too large: %d bytes, max is %d\n",
@@ -212,6 +213,9 @@ static int __wmi_send(struct wil6210_priv *wil, u16 cmdid, void *buf, u16 len)
 		wil_err(wil, "WMI head is garbage: 0x%08x\n", r->head);
 		return -EINVAL;
 	}
+
+	wil_halp_vote(wil);
+
 	/* read Tx head till it is not busy */
 	for (retry = 5; retry > 0; retry--) {
 		wil_memcpy_fromio_32(&d_head, head, sizeof(d_head));
@@ -221,7 +225,8 @@ static int __wmi_send(struct wil6210_priv *wil, u16 cmdid, void *buf, u16 len)
 	}
 	if (d_head.sync != 0) {
 		wil_err(wil, "WMI head busy\n");
-		return -EBUSY;
+		rc = -EBUSY;
+		goto out;
 	}
 	/* next head */
 	next_head = r->base + ((r->head - r->base + sizeof(d_head)) % r->size);
@@ -230,7 +235,8 @@ static int __wmi_send(struct wil6210_priv *wil, u16 cmdid, void *buf, u16 len)
 	for (retry = 5; retry > 0; retry--) {
 		if (!test_bit(wil_status_fwready, wil->status)) {
 			wil_err(wil, "WMI: cannot send command while FW not ready\n");
-			return -EAGAIN;
+			rc = -EAGAIN;
+			goto out;
 		}
 		r->tail = wil_r(wil, RGF_MBOX +
 				offsetof(struct wil6210_mbox_ctl, tx.tail));
@@ -240,13 +246,15 @@ static int __wmi_send(struct wil6210_priv *wil, u16 cmdid, void *buf, u16 len)
 	}
 	if (next_head == r->tail) {
 		wil_err(wil, "WMI ring full\n");
-		return -EBUSY;
+		rc = -EBUSY;
+		goto out;
 	}
 	dst = wmi_buffer(wil, d_head.addr);
 	if (!dst) {
 		wil_err(wil, "invalid WMI buffer: 0x%08x\n",
 			le32_to_cpu(d_head.addr));
-		return -EINVAL;
+		rc = -EAGAIN;
+		goto out;
 	}
 	cmd.hdr.seq = cpu_to_le16(++wil->wmi_seq);
 	/* set command */
@@ -269,7 +277,9 @@ static int __wmi_send(struct wil6210_priv *wil, u16 cmdid, void *buf, u16 len)
 	wil_w(wil, RGF_USER_USER_ICR + offsetof(struct RGF_ICR, ICS),
 	      SW_INT_MBOX);
 
-	return 0;
+out:
+	wil_halp_unvote(wil);
+	return rc;
 }
 
 int wmi_send(struct wil6210_priv *wil, u16 cmdid, void *buf, u16 len)
-- 
1.8.5.2

