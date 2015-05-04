Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wolverine02.qualcomm.com ([199.106.114.251]:32329 "EHLO
	wolverine02.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751975AbbEDWMG (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 4 May 2015 18:12:06 -0400
From: Vladimir Kondratiev <QCA_vkondrat@QCA.qualcomm.com>
Cc: Vladimir Kondratiev <QCA_vkondrat@QCA.qualcomm.com>,
	linux-wireless@vger.kernel.org, wil6210@qca.qualcomm.com,
	Vladimir Shulman <QCA_shulmanv@QCA.qualcomm.com>
To: Kalle Valo <kvalo@codeaurora.org>
Subject: [PATCH v3 5/7] wil6210: Add pmc debug mechanism memory management
Date: Tue,  5 May 2015 01:11:54 +0300
Message-Id: <1430777516-439-6-git-send-email-qca_vkondrat@qca.qualcomm.com> (sfid-20150505_001229_880064_168FA824)
In-Reply-To: <1430777516-439-1-git-send-email-qca_vkondrat@qca.qualcomm.com>
References: <1430777516-439-1-git-send-email-qca_vkondrat@qca.qualcomm.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Pmc is a hardware debug mechanism which allows capturing phy data,
packets, and internally generated events and messages synchronized
and time stamped by the hardware. It requires memory buffers
allocated by the driver in order to be used by hardware dma to
upstream real time debug data to host memory.
Driver will handle memory allocation and release, and fetching
the data from the memory to application layer via debug file
system. The configuration of pmc is handled entirely by the
application layer.

Signed-off-by: Vladimir Shulman <qca_shulmanv@qca.qualcomm.com>
Signed-off-by: Vladimir Kondratiev <qca_vkondrat@qca.qualcomm.com>
---
 drivers/net/wireless/ath/wil6210/Makefile  |   1 +
 drivers/net/wireless/ath/wil6210/debugfs.c |  93 +++++++
 drivers/net/wireless/ath/wil6210/pmc.c     | 375 +++++++++++++++++++++++++++++
 drivers/net/wireless/ath/wil6210/pmc.h     |  27 +++
 drivers/net/wireless/ath/wil6210/wil6210.h |  14 ++
 drivers/net/wireless/ath/wil6210/wmi.h     |  15 ++
 6 files changed, 525 insertions(+)
 create mode 100644 drivers/net/wireless/ath/wil6210/pmc.c
 create mode 100644 drivers/net/wireless/ath/wil6210/pmc.h

diff --git a/drivers/net/wireless/ath/wil6210/Makefile b/drivers/net/wireless/ath/wil6210/Makefile
index caa717b..050506f 100644
--- a/drivers/net/wireless/ath/wil6210/Makefile
+++ b/drivers/net/wireless/ath/wil6210/Makefile
@@ -12,6 +12,7 @@ wil6210-y += debug.o
 wil6210-y += rx_reorder.o
 wil6210-y += ioctl.o
 wil6210-y += fw.o
+wil6210-y += pmc.o
 wil6210-$(CONFIG_WIL6210_TRACING) += trace.o
 wil6210-y += wil_platform.o
 wil6210-y += ethtool.o
diff --git a/drivers/net/wireless/ath/wil6210/debugfs.c b/drivers/net/wireless/ath/wil6210/debugfs.c
index bbc22d8..19f77e5 100644
--- a/drivers/net/wireless/ath/wil6210/debugfs.c
+++ b/drivers/net/wireless/ath/wil6210/debugfs.c
@@ -24,6 +24,7 @@
 #include "wil6210.h"
 #include "wmi.h"
 #include "txrx.h"
+#include "pmc.h"
 
 /* Nasty hack. Better have per device instances */
 static u32 mem_addr;
@@ -702,6 +703,89 @@ static const struct file_operations fops_back = {
 	.open  = simple_open,
 };
 
+/* pmc control, write:
+ * - "alloc <num descriptors> <descriptor_size>" to allocate PMC
+ * - "free" to release memory allocated for PMC
+ */
+static ssize_t wil_write_pmccfg(struct file *file, const char __user *buf,
+				size_t len, loff_t *ppos)
+{
+	struct wil6210_priv *wil = file->private_data;
+	int rc;
+	char *kbuf = kmalloc(len + 1, GFP_KERNEL);
+	char cmd[9];
+	int num_descs, desc_size;
+
+	if (!kbuf)
+		return -ENOMEM;
+
+	rc = simple_write_to_buffer(kbuf, len, ppos, buf, len);
+	if (rc != len) {
+		kfree(kbuf);
+		return rc >= 0 ? -EIO : rc;
+	}
+
+	kbuf[len] = '\0';
+	rc = sscanf(kbuf, "%8s %d %d", cmd, &num_descs, &desc_size);
+	kfree(kbuf);
+
+	if (rc < 0)
+		return rc;
+
+	if (rc < 1) {
+		wil_err(wil, "pmccfg: no params given\n");
+		return -EINVAL;
+	}
+
+	if (0 == strcmp(cmd, "alloc")) {
+		if (rc != 3) {
+			wil_err(wil, "pmccfg: alloc requires 2 params\n");
+			return -EINVAL;
+		}
+		wil_pmc_alloc(wil, num_descs, desc_size);
+	} else if (0 == strcmp(cmd, "free")) {
+		if (rc != 1) {
+			wil_err(wil, "pmccfg: free does not have any params\n");
+			return -EINVAL;
+		}
+		wil_pmc_free(wil, true);
+	} else {
+		wil_err(wil, "pmccfg: Unrecognized command \"%s\"\n", cmd);
+		return -EINVAL;
+	}
+
+	return len;
+}
+
+static ssize_t wil_read_pmccfg(struct file *file, char __user *user_buf,
+			       size_t count, loff_t *ppos)
+{
+	struct wil6210_priv *wil = file->private_data;
+	char text[256];
+	char help[] = "pmc control, write:\n"
+	" - \"alloc <num descriptors> <descriptor_size>\" to allocate pmc\n"
+	" - \"free\" to free memory allocated for pmc\n";
+
+	sprintf(text, "Last command status: %d\n\n%s",
+		wil_pmc_last_cmd_status(wil),
+		help);
+
+	return simple_read_from_buffer(user_buf, count, ppos, text,
+				       strlen(text) + 1);
+}
+
+static const struct file_operations fops_pmccfg = {
+	.read = wil_read_pmccfg,
+	.write = wil_write_pmccfg,
+	.open  = simple_open,
+};
+
+static const struct file_operations fops_pmcdata = {
+	.open		= simple_open,
+	.read		= wil_pmc_read,
+	.llseek		= wil_pmc_llseek,
+};
+
 /*---tx_mgmt---*/
 /* Write mgmt frame to this file to send it */
 static ssize_t wil_write_file_txmgmt(struct file *file, const char __user *buf,
@@ -1363,6 +1447,8 @@ static const struct {
 	{"tx_mgmt",		  S_IWUSR,	&fops_txmgmt},
 	{"wmi_send",		  S_IWUSR,	&fops_wmi},
 	{"back",	S_IRUGO | S_IWUSR,	&fops_back},
+	{"pmccfg",	S_IRUGO | S_IWUSR,	&fops_pmccfg},
+	{"pmcdata",	S_IRUGO,		&fops_pmcdata},
 	{"temp",	S_IRUGO,		&fops_temp},
 	{"freq",	S_IRUGO,		&fops_freq},
 	{"link",	S_IRUGO,		&fops_link},
@@ -1440,6 +1526,8 @@ int wil6210_debugfs_init(struct wil6210_priv *wil)
 	if (IS_ERR_OR_NULL(dbg))
 		return -ENODEV;
 
+	wil_pmc_init(wil);
+
 	wil6210_debugfs_init_files(wil, dbg);
 	wil6210_debugfs_init_isr(wil, dbg);
 	wil6210_debugfs_init_blobs(wil, dbg);
@@ -1459,4 +1547,9 @@ void wil6210_debugfs_remove(struct wil6210_priv *wil)
 {
 	debugfs_remove_recursive(wil->debug);
 	wil->debug = NULL;
+
+	/* free pmc memory without sending command to fw, as it will
+	 * be reset on the way down anyway
+	 */
+	wil_pmc_free(wil, false);
 }
diff --git a/drivers/net/wireless/ath/wil6210/pmc.c b/drivers/net/wireless/ath/wil6210/pmc.c
new file mode 100644
index 0000000..d34b084
--- /dev/null
+++ b/drivers/net/wireless/ath/wil6210/pmc.c
@@ -0,0 +1,375 @@
+/*
+ * Copyright (c) 2012-2015 Qualcomm Atheros, Inc.
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
+#include <linux/types.h>
+#include <linux/errno.h>
+#include <linux/fs.h>
+#include "wmi.h"
+#include "wil6210.h"
+#include "txrx.h"
+#include "pmc.h"
+
+struct desc_alloc_info {
+	dma_addr_t pa;
+	void	  *va;
+};
+
+static int wil_is_pmc_allocated(struct pmc_ctx *pmc)
+{
+	return !!pmc->pring_va;
+}
+
+void wil_pmc_init(struct wil6210_priv *wil)
+{
+	memset(&wil->pmc, 0, sizeof(struct pmc_ctx));
+	mutex_init(&wil->pmc.lock);
+}
+
+/**
+ * Allocate the physical ring (p-ring) and the required
+ * number of descriptors of required size.
+ * Initialize the descriptors as required by pmc dma.
+ * The descriptors' buffers dwords are initialized to hold
+ * dword's serial number in the lsw and reserved value
+ * PCM_DATA_INVALID_DW_VAL in the msw.
+ */
+void wil_pmc_alloc(struct wil6210_priv *wil,
+		   int num_descriptors,
+		   int descriptor_size)
+{
+	u32 i;
+	struct pmc_ctx *pmc = &wil->pmc;
+	struct device *dev = wil_to_dev(wil);
+	struct wmi_pmc_cmd pmc_cmd = {0};
+
+	mutex_lock(&pmc->lock);
+
+	if (wil_is_pmc_allocated(pmc)) {
+		/* sanity check */
+		wil_err(wil, "%s: ERROR pmc is already allocated\n", __func__);
+		goto no_release_err;
+	}
+
+	pmc->num_descriptors = num_descriptors;
+	pmc->descriptor_size = descriptor_size;
+
+	wil_dbg_misc(wil, "%s: %d descriptors x %d bytes each\n",
+		     __func__, num_descriptors, descriptor_size);
+
+	/* allocate descriptors info list in pmc context*/
+	pmc->descriptors = kcalloc(num_descriptors,
+				  sizeof(struct desc_alloc_info),
+				  GFP_KERNEL);
+	if (!pmc->descriptors) {
+		wil_err(wil, "%s: ERROR allocating pmc skb list\n", __func__);
+		goto no_release_err;
+	}
+
+	wil_dbg_misc(wil,
+		     "%s: allocated descriptors info list %p\n",
+		     __func__, pmc->descriptors);
+
+	/* Allocate pring buffer and descriptors.
+	 * vring->va should be aligned on its size rounded up to power of 2
+	 * This is granted by the dma_alloc_coherent
+	 */
+	pmc->pring_va = dma_alloc_coherent(dev,
+			sizeof(struct vring_tx_desc) * num_descriptors,
+			&pmc->pring_pa,
+			GFP_KERNEL);
+
+	wil_dbg_misc(wil,
+		     "%s: allocated pring %p => %pad. %zd x %d = total %zd bytes\n",
+		     __func__,
+		     pmc->pring_va, pmc->pring_pa,
+		     sizeof(struct vring_tx_desc),
+		     num_descriptors,
+		     sizeof(struct vring_tx_desc) * num_descriptors);
+
+	if (!pmc->pring_va) {
+		wil_err(wil, "%s: ERROR allocating pmc pring\n", __func__);
+		goto release_pmc_skb_list;
+	}
+
+	/* initially, all descriptors are SW owned
+	 * For Tx, Rx, and PMC, ownership bit is at the same location, thus
+	 * we can use any
+	 */
+	for (i = 0; i < num_descriptors; i++) {
+		struct vring_tx_desc *_d = &pmc->pring_va[i];
+		struct vring_tx_desc dd, *d = &dd;
+		int j = 0;
+
+		pmc->descriptors[i].va = dma_alloc_coherent(dev,
+			descriptor_size,
+			&pmc->descriptors[i].pa,
+			GFP_KERNEL);
+
+		if (unlikely(!pmc->descriptors[i].va)) {
+			wil_err(wil,
+				"%s: ERROR allocating pmc descriptor %d",
+				__func__, i);
+			goto release_pmc_skbs;
+		}
+
+		for (j = 0; j < descriptor_size / sizeof(u32); j++) {
+			u32 *p = (u32 *)pmc->descriptors[i].va + j;
+			*p = PCM_DATA_INVALID_DW_VAL | j;
+		}
+
+		/* configure dma descriptor */
+		d->dma.addr.addr_low =
+			cpu_to_le32(lower_32_bits(pmc->descriptors[i].pa));
+		d->dma.addr.addr_high =
+			cpu_to_le16((u16)upper_32_bits(pmc->descriptors[i].pa));
+		d->dma.status = 0; /* 0 = HW_OWNED */
+		d->dma.length = cpu_to_le16(descriptor_size);
+		d->dma.d0 = BIT(9) | RX_DMA_D0_CMD_DMA_IT;
+		*_d = *d;
+	}
+
+	wil_dbg_misc(wil, "%s: allocated successfully\n", __func__);
+
+	pmc_cmd.op = WMI_PMC_ALLOCATE;
+	pmc_cmd.ring_size = cpu_to_le16(pmc->num_descriptors);
+	pmc_cmd.mem_base = cpu_to_le64(pmc->pring_pa);
+
+	wil_dbg_misc(wil, "%s: send WMI_PMC_CMD with ALLOCATE op\n", __func__);
+	pmc->last_cmd_status = wmi_send(wil,
+					WMI_PMC_CMDID,
+					&pmc_cmd,
+					sizeof(pmc_cmd));
+	if (pmc->last_cmd_status) {
+		wil_err(wil,
+			"%s: WMI_PMC_CMD with ALLOCATE op failed with status %d",
+			__func__, pmc->last_cmd_status);
+		goto release_pmc_skbs;
+	}
+
+	mutex_unlock(&pmc->lock);
+
+	return;
+
+release_pmc_skbs:
+	wil_err(wil, "%s: exit on error: Releasing skbs...\n", __func__);
+	for (i = 0; pmc->descriptors[i].va && i < num_descriptors; i++) {
+		dma_free_coherent(dev,
+				  descriptor_size,
+				  pmc->descriptors[i].va,
+				  pmc->descriptors[i].pa);
+
+		pmc->descriptors[i].va = NULL;
+	}
+	wil_err(wil, "%s: exit on error: Releasing pring...\n", __func__);
+
+	dma_free_coherent(dev,
+			  sizeof(struct vring_tx_desc) * num_descriptors,
+			  pmc->pring_va,
+			  pmc->pring_pa);
+
+	pmc->pring_va = NULL;
+
+release_pmc_skb_list:
+	wil_err(wil, "%s: exit on error: Releasing descriptors info list...\n",
+		__func__);
+	kfree(pmc->descriptors);
+	pmc->descriptors = NULL;
+
+no_release_err:
+	pmc->last_cmd_status = -ENOMEM;
+	mutex_unlock(&pmc->lock);
+}
+
+/**
+ * Traverse the p-ring and release all buffers.
+ * At the end release the p-ring memory
+ */
+void wil_pmc_free(struct wil6210_priv *wil, int send_pmc_cmd)
+{
+	struct pmc_ctx *pmc = &wil->pmc;
+	struct device *dev = wil_to_dev(wil);
+	struct wmi_pmc_cmd pmc_cmd = {0};
+
+	mutex_lock(&pmc->lock);
+
+	pmc->last_cmd_status = 0;
+
+	if (!wil_is_pmc_allocated(pmc)) {
+		wil_dbg_misc(wil, "%s: Error, can't free - not allocated\n",
+			     __func__);
+		pmc->last_cmd_status = -EPERM;
+		mutex_unlock(&pmc->lock);
+		return;
+	}
+
+	if (send_pmc_cmd) {
+		wil_dbg_misc(wil, "%s: send WMI_PMC_CMD with RELEASE op\n",
+			     __func__);
+		pmc_cmd.op = WMI_PMC_RELEASE;
+		pmc->last_cmd_status =
+				wmi_send(wil, WMI_PMC_CMDID, &pmc_cmd,
+					 sizeof(pmc_cmd));
+		if (pmc->last_cmd_status) {
+			wil_err(wil,
+				"%s WMI_PMC_CMD with RELEASE op failed, status %d",
+				__func__, pmc->last_cmd_status);
+			/* There's nothing we can do with this error.
+			 * Normally, it should never occur.
+			 * Continue to freeing all memory allocated for pmc.
+			 */
+		}
+	}
+
+	if (pmc->pring_va) {
+		size_t buf_size = sizeof(struct vring_tx_desc) *
+				  pmc->num_descriptors;
+
+		wil_dbg_misc(wil, "%s: free pring va %p\n",
+			     __func__, pmc->pring_va);
+		dma_free_coherent(dev, buf_size, pmc->pring_va, pmc->pring_pa);
+
+		pmc->pring_va = NULL;
+	} else {
+		pmc->last_cmd_status = -ENOENT;
+	}
+
+	if (pmc->descriptors) {
+		int i;
+
+		for (i = 0;
+		     pmc->descriptors[i].va && i < pmc->num_descriptors; i++) {
+			dma_free_coherent(dev,
+					  pmc->descriptor_size,
+					  pmc->descriptors[i].va,
+					  pmc->descriptors[i].pa);
+			pmc->descriptors[i].va = NULL;
+		}
+		wil_dbg_misc(wil, "%s: free descriptor info %d/%d\n",
+			     __func__, i, pmc->num_descriptors);
+		wil_dbg_misc(wil,
+			     "%s: free pmc descriptors info list %p\n",
+			     __func__, pmc->descriptors);
+		kfree(pmc->descriptors);
+		pmc->descriptors = NULL;
+	} else {
+		pmc->last_cmd_status = -ENOENT;
+	}
+
+	mutex_unlock(&pmc->lock);
+}
+
+/**
+ * Status of the last operation requested via debugfs: alloc/free/read.
+ * 0 - success or negative errno
+ */
+int wil_pmc_last_cmd_status(struct wil6210_priv *wil)
+{
+	wil_dbg_misc(wil, "%s: status %d\n", __func__,
+		     wil->pmc.last_cmd_status);
+
+	return wil->pmc.last_cmd_status;
+}
+
+/**
+ * Read from required position up to the end of current descriptor,
+ * depends on descriptor size configured during alloc request.
+ */
+ssize_t wil_pmc_read(struct file *filp, char __user *buf, size_t count,
+		     loff_t *f_pos)
+{
+	struct wil6210_priv *wil = filp->private_data;
+	struct pmc_ctx *pmc = &wil->pmc;
+	size_t retval = 0;
+	unsigned long long idx;
+	loff_t offset;
+	size_t pmc_size = pmc->descriptor_size * pmc->num_descriptors;
+
+	mutex_lock(&pmc->lock);
+
+	if (!wil_is_pmc_allocated(pmc)) {
+		wil_err(wil, "%s: error, pmc is not allocated!\n", __func__);
+		pmc->last_cmd_status = -EPERM;
+		mutex_unlock(&pmc->lock);
+		return -EPERM;
+	}
+
+	wil_dbg_misc(wil,
+		     "%s: size %u, pos %lld\n",
+		     __func__, (unsigned)count, *f_pos);
+
+	pmc->last_cmd_status = 0;
+
+	idx = *f_pos;
+	do_div(idx, pmc->descriptor_size);
+	offset = *f_pos - (idx * pmc->descriptor_size);
+
+	if (*f_pos >= pmc_size) {
+		wil_dbg_misc(wil, "%s: reached end of pmc buf: %lld >= %u\n",
+			     __func__, *f_pos, (unsigned)pmc_size);
+		pmc->last_cmd_status = -ERANGE;
+		goto out;
+	}
+
+	wil_dbg_misc(wil,
+		     "%s: read from pos %lld (descriptor %llu, offset %llu) %zu bytes\n",
+		     __func__, *f_pos, idx, offset, count);
+
+	/* if no errors, return the copied byte count */
+	retval = simple_read_from_buffer(buf,
+					 count,
+					 &offset,
+					 pmc->descriptors[idx].va,
+					 pmc->descriptor_size);
+	*f_pos += retval;
+out:
+	mutex_unlock(&pmc->lock);
+
+	return retval;
+}
+
+loff_t wil_pmc_llseek(struct file *filp, loff_t off, int whence)
+{
+	loff_t newpos;
+	struct wil6210_priv *wil = filp->private_data;
+	struct pmc_ctx *pmc = &wil->pmc;
+	size_t pmc_size = pmc->descriptor_size * pmc->num_descriptors;
+
+	switch (whence) {
+	case 0: /* SEEK_SET */
+		newpos = off;
+		break;
+
+	case 1: /* SEEK_CUR */
+		newpos = filp->f_pos + off;
+		break;
+
+	case 2: /* SEEK_END */
+		newpos = pmc_size;
+		break;
+
+	default: /* can't happen */
+		return -EINVAL;
+	}
+
+	if (newpos < 0)
+		return -EINVAL;
+	if (newpos > pmc_size)
+		newpos = pmc_size;
+
+	filp->f_pos = newpos;
+
+	return newpos;
+}
diff --git a/drivers/net/wireless/ath/wil6210/pmc.h b/drivers/net/wireless/ath/wil6210/pmc.h
new file mode 100644
index 0000000..bebc8d5
--- /dev/null
+++ b/drivers/net/wireless/ath/wil6210/pmc.h
@@ -0,0 +1,27 @@
+/*
+ * Copyright (c) 2012-2015 Qualcomm Atheros, Inc.
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
+#include <linux/types.h>
+
+#define PCM_DATA_INVALID_DW_VAL (0xB0BA0000)
+
+void wil_pmc_init(struct wil6210_priv *wil);
+void wil_pmc_alloc(struct wil6210_priv *wil,
+		   int num_descriptors, int descriptor_size);
+void wil_pmc_free(struct wil6210_priv *wil, int send_pmc_cmd);
+int wil_pmc_last_cmd_status(struct wil6210_priv *wil);
+ssize_t wil_pmc_read(struct file *, char __user *, size_t, loff_t *);
+loff_t wil_pmc_llseek(struct file *filp, loff_t off, int whence);
diff --git a/drivers/net/wireless/ath/wil6210/wil6210.h b/drivers/net/wireless/ath/wil6210/wil6210.h
index abb2080..9d74bd8 100644
--- a/drivers/net/wireless/ath/wil6210/wil6210.h
+++ b/drivers/net/wireless/ath/wil6210/wil6210.h
@@ -21,6 +21,7 @@
 #include <linux/wireless.h>
 #include <net/cfg80211.h>
 #include <linux/timex.h>
+#include <linux/types.h>
 #include "wil_platform.h"
 
 extern bool no_fw_recovery;
@@ -527,6 +528,17 @@ struct wil_probe_client_req {
 	u8 cid;
 };
 
+struct pmc_ctx {
+	/* alloc, free, and read operations must own the lock */
+	struct mutex		lock;
+	struct vring_tx_desc	*pring_va;
+	dma_addr_t		pring_pa;
+	struct desc_alloc_info  *descriptors;
+	int			last_cmd_status;
+	int			num_descriptors;
+	int			descriptor_size;
+};
+
 struct wil6210_priv {
 	struct pci_dev *pdev;
 	int n_msi;
@@ -611,6 +623,8 @@ struct wil6210_priv {
 
 	void *platform_handle;
 	struct wil_platform_ops platform_ops;
+
+	struct pmc_ctx pmc;
 };
 
 #define wil_to_wiphy(i) (i->wdev->wiphy)
diff --git a/drivers/net/wireless/ath/wil6210/wmi.h b/drivers/net/wireless/ath/wil6210/wmi.h
index b290553..24c253d 100644
--- a/drivers/net/wireless/ath/wil6210/wmi.h
+++ b/drivers/net/wireless/ath/wil6210/wmi.h
@@ -836,6 +836,21 @@ struct wmi_temp_sense_cmd {
 } __packed;
 
 /*
+ * WMI_PMC_CMDID
+ */
+enum wmi_pmc_op_e {
+	WMI_PMC_ALLOCATE = 0,
+	WMI_PMC_RELEASE = 1,
+};
+
+struct wmi_pmc_cmd {
+	u8 op;		/* enum wmi_pmc_cmd_op_type */
+	u8 reserved;
+	__le16 ring_size;
+	__le64 mem_base;
+} __packed;
+
+/*
  * WMI Events
  */
 
-- 
2.1.0

