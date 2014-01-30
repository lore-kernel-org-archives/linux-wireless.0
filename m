Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.redpinesignals.com ([203.196.161.92]:60528 "EHLO
	mail.redpinesignals.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753273AbaA3QAA (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 30 Jan 2014 11:00:00 -0500
Message-ID: <52EA759D.8050809@redpinesignals.com> (sfid-20140130_170007_973159_5D8E3EA6)
Date: Thu, 30 Jan 2014 21:24:05 +0530
From: Jahnavi <jahnavi.meher@redpinesignals.com>
MIME-Version: 1.0
To: linux-wireless@vger.kernel.org
Subject: [PATCH 3.13.1 2/9] rsi: OS dependent functions
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Jahnavi Meher <jahnavi.meher@redpinesignals.com>

This file contains all the os related functions, like thread 
operations and file operations.

Signed-off-by: Jahnavi Meher <jahnavi.meher@redpinesignals.com>
---

common/Makefile           |    9 
common/rsi_osd_ops.c      |  629 ++++++++++++++++++++++++++++++++++++++++++++++
include/rsi_boot_params.h |  183 +++++++++++++
include/rsi_common.h      |  302 ++++++++++++++++++++++
4 files changed, 1123 insertions(+)

diff -uprN a/drivers/net/wireless/rsi/common/Makefile b/drivers/net/wireless/rsi/common/Makefile
--- a/drivers/net/wireless/rsi/common/Makefile	1970-01-01 05:30:00.000000000 +0530
+++ b/drivers/net/wireless/rsi/common/Makefile	2014-01-30 16:07:10.602854883 +0530
@@ -0,0 +1,9 @@
+rsi_common-y := rsi_core.o rsi_osd_ops.o
+ifeq ($(CONFIG_RSI_USB), y)
+	rsi_common-y += rsi_usb.o
+	ccflags-y =-DUSE_USB_INTF
+else
+	rsi_common-y += rsi_sdio.o
+	ccflags-y =-DUSE_SDIO_INTF
+endif
+obj-$(CONFIG_RSI_91x) := rsi_common.o
diff -uprN a/drivers/net/wireless/rsi/common/rsi_osd_ops.c b/drivers/net/wireless/rsi/common/rsi_osd_ops.c
--- a/drivers/net/wireless/rsi/common/rsi_osd_ops.c	1970-01-01 05:30:00.000000000 +0530
+++ b/drivers/net/wireless/rsi/common/rsi_osd_ops.c	2014-01-30 16:07:10.605855265 +0530
@@ -0,0 +1,629 @@
+/**
+ * @file rsi_osd_ops.c
+ * @author
+ * @version 1.0
+ *
+ * @section LICENSE
+ * Copyright (c) 2013 Redpine Signals Inc.
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
+ *
+ * @section DESCRIPTION
+ *
+ * This file contains all the Linux specific code for driver.
+ */
+
+#include <linux/fs.h>
+#include <linux/kthread.h>
+#include <linux/proc_fs.h>
+#include "../include/rsi_main.h"
+#include "../include/rsi_device_ops.h"
+
+/**
+ * This function kills tx/rx thread depending upon type
+ *
+ * @param  common Pointer to the driver private structure.
+ * @return Thread stop return code.
+ */
+static int rsi_kill_thread(struct rsi_common *common, unsigned char type)
+{
+	struct rsi_thread *handle;
+
+	if (type) {
+		handle = &common->tx_thread;
+		/* Kill tx thread */
+		atomic_inc(&common->tx_thread_done);
+		rsi_set_event(&common->tx_event);
+	} else {
+#ifdef USE_USB_INTF
+		handle = &common->rx_thread;
+		atomic_inc(&common->rx_thread_done);
+		rsi_set_event(&common->rx_event);
+#endif
+	}
+
+	wait_for_completion(&handle->completion);
+	return kthread_stop(handle->task);
+}
+
+/**
+ * This function creates a kernel thread.
+ *
+ * @param  common Pointer to the driver private structure.
+ * @param  thread Thread handler type (rx/tx).
+ * @param  func_ptr Type of interface thread to be created(like sdio/usb).
+ * @param  name Name of thread.
+ * @return 0 on thread creation.
+ */
+static int rsi_create_kthread(struct rsi_common *common,
+			      struct rsi_thread *thread,
+			      void *func_ptr,
+			      unsigned char *name)
+{
+	init_completion(&thread->completion);
+	thread->task = kthread_run(func_ptr, common, name);
+	return 0;
+}
+
+/**
+ * This function gives the driver and firmware version number.
+ *
+ * @param  seq Pointer to the sequence file structure.
+ * @param  data Pointer to the data.
+ * @return 0 on success, -1 on failure.
+ */
+static int rsi_proc_version_read(struct seq_file *seq, void *data)
+{
+	struct rsi_common *common = seq->private;
+
+	common->driver_ver.major = 0;
+	common->driver_ver.minor = 1;
+	common->driver_ver.release_num = 0;
+	common->driver_ver.patch_num = 0;
+	seq_printf(seq, "Driver : %x.%d.%d.%d\nLMAC   : %d.%d.%d.%d.%d\n",
+		   common->driver_ver.major,
+		   common->driver_ver.minor,
+		   common->driver_ver.release_num,
+		   common->driver_ver.patch_num,
+		   common->fw_ver.major,
+		   common->fw_ver.minor,
+		   common->fw_ver.release_num,
+		   common->fw_ver.patch_num,
+		   common->fw_ver.info.fw_ver[0]);
+	return 0;
+}
+
+/**
+ * This funtion calls single open function of seq_file to open file and
+ * read contents from it.
+ *
+ * @param  inode Pointer to the inode structure.
+ * @param  file Pointer to the file structure.
+ * @return Pointer to the opened file status: 0 on success, ENOMEM on failure.
+ */
+static int rsi_version_proc_open(struct inode *inode,
+				 struct file *file)
+{
+	return single_open(file, rsi_proc_version_read, PDE_DATA(inode));
+}
+
+static const struct file_operations rsi_version_proc_fops = {
+	.open = rsi_version_proc_open,
+	.read = seq_read,
+	.llseek = seq_lseek,
+	.release = single_release,
+};
+
+/**
+ * This function return the sdio status of the driver.
+ *
+ * @param  seq Pointer to the sequence file structure.
+ * @param  data Pointer to the data.
+ * @return 0 on success, -1 on failure.
+ */
+#ifdef USE_SDIO_INTF
+static int rsi_proc_sdio_stats_read(struct seq_file *seq, void *data)
+{
+	struct rsi_common *common = seq->private;
+
+	seq_printf(seq, "total_sdio_interrupts: %d\n",
+		   common->rx_info.sdio_int_counter);
+	seq_printf(seq, "sdio_msdu_pending_intr_count: %d\n",
+		   common->rx_info.total_sdio_msdu_pending_intr);
+	seq_printf(seq, "sdio_buff_full_count : %d\n",
+		   common->rx_info.buf_full_counter);
+	seq_printf(seq, "sdio_buf_semi_full_count %d\n",
+		   common->rx_info.buf_semi_full_counter);
+	seq_printf(seq, "sdio_unknown_intr_count: %d\n",
+		   common->rx_info.total_sdio_unknown_intr);
+	/* RX Path Stats */
+	seq_printf(seq, "BUFFER FULL STATUS  : %d\n",
+		   common->rx_info.buffer_full);
+	seq_printf(seq, "SEMI BUFFER FULL STATUS  : %d\n",
+		   common->rx_info.semi_buffer_full);
+	seq_printf(seq, "MGMT BUFFER FULL STATUS  : %d\n",
+		   common->rx_info.mgmt_buffer_full);
+	seq_printf(seq, "BUFFER FULL COUNTER  : %d\n",
+		   common->rx_info.buf_full_counter);
+	seq_printf(seq, "BUFFER SEMI FULL COUNTER  : %d\n",
+		   common->rx_info.buf_semi_full_counter);
+	seq_printf(seq, "MGMT BUFFER FULL COUNTER  : %d\n",
+		   common->rx_info.mgmt_buf_full_counter);
+
+	return 0;
+}
+
+/**
+ * This funtion calls single open function of seq_file to open file and
+ * read contents from it.
+ *
+ * @param  inode Pointer to the inode structure.
+ * @param  file Pointer to the file structure.
+ * @return Pointer to the opened file status: 0 on success, ENOMEM on failure.
+ */
+static int rsi_sdio_stats_proc_open(struct inode *inode,
+				    struct file *file)
+{
+	return single_open(file, rsi_proc_sdio_stats_read, PDE_DATA(inode));
+}
+
+static const struct file_operations rsi_sdio_stats_proc_fops = {
+	.open = rsi_sdio_stats_proc_open,
+	.read = seq_read,
+	.llseek = seq_lseek,
+	.release = seq_release,
+};
+#endif
+
+/**
+ * This function return the status of the driver.
+ *
+ * @param  seq Pointer to the sequence file structure.
+ * @param  data Pointer to the data.
+ * @return 0 on success, -1 on failure.
+ */
+static int rsi_proc_stats_read(struct seq_file *seq, void *data)
+{
+	struct rsi_common *common = seq->private;
+
+	unsigned char fsm_state[][32] = {
+		"FSM_CARD_NOT_READY",
+		"FSM_BOOT_PARAMS_SENT",
+		"FSM_EEPROM_READ_MAC_ADDR",
+		"FSM_RESET_MAC_SENT",
+		"FSM_RADIO_CAPS_SENT",
+		"FSM_BB_RF_PROG_SENT",
+		"FSM_MAC_INIT_DONE"
+	};
+	seq_puts(seq, "==> RSI STA DRIVER STATUS <==\n");
+	seq_puts(seq, "DRIVER_FSM_STATE: ");
+
+	if (common->fsm_state <= FSM_MAC_INIT_DONE)
+		seq_printf(seq, "%s", fsm_state[common->fsm_state]);
+
+	seq_printf(seq, "(%d)\n\n", common->fsm_state);
+
+	/* Mgmt TX Path Stats */
+	seq_printf(seq, "total_mgmt_pkt_send : %d\n",
+		   common->tx_stats.total_mgmt_pkt_send);
+	seq_printf(seq, "total_mgmt_pkt_queued : %d\n",
+		   skb_queue_len(&common->tx_queue[4]));
+	seq_printf(seq, "total_mgmt_pkt_freed  : %d\n",
+		   common->tx_stats.total_mgmt_pkt_freed);
+
+	/* Data TX Path Stats */
+	seq_printf(seq, "total_data_vo_pkt_send: %8d\t",
+		   common->tx_stats.total_data_pkt_send[VO_Q]);
+	seq_printf(seq, "total_data_vo_pkt_queued:  %8d\t",
+		   skb_queue_len(&common->tx_queue[0]));
+	seq_printf(seq, "total_vo_pkt_freed: %8d\n",
+		   common->tx_stats.total_data_pkt_freed[VO_Q]);
+	seq_printf(seq, "total_data_vi_pkt_send: %8d\t",
+		   common->tx_stats.total_data_pkt_send[VI_Q]);
+	seq_printf(seq, "total_data_vi_pkt_queued:  %8d\t",
+		   skb_queue_len(&common->tx_queue[1]));
+	seq_printf(seq, "total_vi_pkt_freed: %8d\n",
+		   common->tx_stats.total_data_pkt_freed[VI_Q]);
+	seq_printf(seq,  "total_data_be_pkt_send: %8d\t",
+		   common->tx_stats.total_data_pkt_send[BE_Q]);
+	seq_printf(seq, "total_data_be_pkt_queued:  %8d\t",
+		   skb_queue_len(&common->tx_queue[2]));
+	seq_printf(seq, "total_be_pkt_freed: %8d\n",
+		   common->tx_stats.total_data_pkt_freed[BE_Q]);
+	seq_printf(seq, "total_data_bk_pkt_send: %8d\t",
+		   common->tx_stats.total_data_pkt_send[BK_Q]);
+	seq_printf(seq, "total_data_bk_pkt_queued:  %8d\t",
+		   skb_queue_len(&common->tx_queue[3]));
+	seq_printf(seq, "total_bk_pkt_freed: %8d\n",
+		   common->tx_stats.total_data_pkt_freed[BK_Q]);
+
+	seq_puts(seq, "\n");
+	return 0;
+}
+
+/**
+ * This funtion calls single open function of seq_file to open file and
+ * read contents from it.
+ *
+ * @param  inode Pointer to the inode structure.
+ * @param  file Pointer to the file structure.
+ * @return Pointer to the opened file status: 0 on success, ENOMEM on failure.
+ */
+static int rsi_stats_proc_open(struct inode *inode,
+			       struct file *file)
+{
+	return single_open(file, rsi_proc_stats_read, PDE_DATA(inode));
+}
+
+static const struct file_operations rsi_stats_proc_fops = {
+	.open = rsi_stats_proc_open,
+	.read = seq_read,
+	.llseek = seq_lseek,
+	.release = single_release,
+};
+
+/**
+ * This function display the currently enabled debug zones.
+ *
+ * @param  seq Pointer to the sequence file structure.
+ * @param  data Pointer to the data.
+ * @return 0 on success, -1 on failure.
+ */
+static int rsi_proc_debug_zone_read(struct seq_file *seq,
+				    void *data)
+{
+	rsi_dbg(FSM_ZONE, "%x: rsi_enabled zone", rsi_zone_enabled);
+	seq_printf(seq, "The zones available are %#x\n",
+		   rsi_zone_enabled);
+	return 0;
+}
+
+/**
+ * This funtion calls single open function of seq_file to open file and
+ * read contents from it.
+ *
+ * @param  inode Pointer to the inode structure.
+ * @param  file Pointer to the file structure.
+ * @return Pointer to the opened file status: 0 on success, ENOMEM on failure.
+ */
+static int rsi_debug_proc_read(struct inode *inode,
+			       struct file *file)
+{
+	return single_open(file, rsi_proc_debug_zone_read, PDE_DATA(inode));
+}
+
+/**
+ * This function writes into hal queues as per user requirement.
+ *
+ * @param  filp Pointer to the file structure.
+ * @param  buff Pointer to the character buffer.
+ * @param  len Length of the data to be written into buffer.
+ * @param  data Pointer to the data.
+ * @return len: Number of bytes read.
+ */
+static ssize_t rsi_proc_debug_zone_write(struct file *filp,
+				     const char __user *buff,
+				     size_t len,
+				     loff_t *data)
+{
+	unsigned long dbg_zone;
+
+	if (!len)
+		return 0;
+
+	if (len > 20)
+		return -EINVAL;
+
+	if (kstrtoul_from_user(buff, len, 16, &dbg_zone))
+		return -1;
+	else
+		rsi_zone_enabled = dbg_zone;
+	return 0;
+}
+
+static const struct file_operations rsi_debug_proc_fops = {
+	.open = rsi_debug_proc_read,
+	.read = seq_read,
+	.llseek = seq_lseek,
+	.write = rsi_proc_debug_zone_write,
+};
+
+/**
+ * Removes the previously created proc file entries in the reverse order of
+ * creation.
+ *
+ * @param  adapter Pointer to adapter structure.
+ * @return None.
+ */
+static void rsi_proc_remove(struct rsi_hw *adapter)
+{
+	if (!adapter->proc_entry)
+		return;
+
+	remove_proc_subtree("driver/rsi-mobile", NULL);
+	return;
+}
+
+/**
+ * This function initializes the proc file system entry.
+ *
+ * @param  adapter Pointer to the adapter structure.
+ * @return 0 on success, -1 on failure.
+ */
+static int rsi_init_proc_fs(struct rsi_hw *adapter)
+{
+	struct proc_dir_entry *entry = NULL;
+	struct rsi_common *common = adapter->priv;
+
+	adapter->proc_entry = proc_mkdir("driver/rsi-mobile", NULL);
+	if (adapter->proc_entry == NULL) {
+		rsi_dbg(ERR_ZONE, "%s: Unable to create dir entry", __func__);
+		return -1;
+	} else {
+		entry = proc_create_data("version",
+					 0,
+					 adapter->proc_entry,
+					 &rsi_version_proc_fops,
+					 common);
+		if (entry == NULL) {
+			rsi_dbg(ERR_ZONE, "%s: Unable to create version entry",
+				__func__);
+			goto fail;
+		}
+		entry = proc_create_data("stats",
+					 0,
+					 adapter->proc_entry,
+					 &rsi_stats_proc_fops,
+					 (void *)common);
+		if (entry == NULL) {
+			rsi_dbg(ERR_ZONE, "%s: Unable to create stats entry",
+				__func__);
+			goto fail;
+		}
+
+#ifdef USE_SDIO_INTF
+		entry = proc_create_data("sdio_stats",
+					 0,
+					 adapter->proc_entry,
+					 &rsi_sdio_stats_proc_fops,
+					 (void *)common);
+		if (entry == NULL) {
+			rsi_dbg(ERR_ZONE, "%s: Unable to create sdio stats entry",
+				__func__);
+			goto fail;
+		}
+#endif
+		entry = proc_create_data("debug_zone",
+					 0,
+					 adapter->proc_entry,
+					 &rsi_debug_proc_fops,
+					 (void *)common);
+		if (entry == NULL) {
+			rsi_dbg(ERR_ZONE,
+				"%s: Unable to create debug zone entry",
+				__func__);
+			goto fail;
+		}
+	}
+	return 0;
+
+fail:
+	remove_proc_subtree("driver/rsi-mobile", NULL);
+	return -1;
+}
+
+/**
+ * This function initializes device event.
+ *
+ * @param  pevent Pointer to the event data structure.
+ * @return 0 on success.
+ */
+static int rsi_init_event(struct rsi_event *pevent)
+{
+	atomic_set(&pevent->event_condition, 1);
+	init_waitqueue_head(&pevent->event_queue);
+	return 0;
+}
+
+/**
+ * This function is used to put the current execution in a queue
+ * and reschedules itself for execution on "timeout" or when a
+ * wakeup is generated.
+ *
+ * @param  event Pointer to the event structure.
+ * @param  timeout Timeout value in msecs.
+ * @return status: 0 on success, -1 on failure.
+ */
+int rsi_wait_event(struct rsi_event *event, unsigned int timeout)
+{
+	int status = 0;
+
+	if (!timeout)
+		status = wait_event_interruptible(event->event_queue,
+				(atomic_read(&event->event_condition) == 0));
+	else
+		status = wait_event_interruptible_timeout(event->event_queue,
+				(atomic_read(&event->event_condition) == 0),
+				timeout);
+	return status;
+}
+
+/**
+ * This function handles the set event functionality.
+ *
+ * @param  event Pointer to the event structure.
+ * @return None.
+ */
+void rsi_set_event(struct rsi_event *event)
+{
+	atomic_set(&event->event_condition, 0);
+	wake_up_interruptible(&event->event_queue);
+}
+
+/**
+ * This function handle the reset event functionality.
+ *
+ * @param  event Pointer to the event structure.
+ * @return None.
+ */
+void rsi_reset_event(struct rsi_event *event)
+{
+	atomic_set(&event->event_condition, 1);
+}
+
+/**
+ * This function dumps the given data on to the screen, provided the
+ * debug zone is enabled.
+ *
+ * @param  zone Type of Debug zone.
+ * @param  vdata Pointer to data that has to dump.
+ * @param  len Length of the data to dump.
+ * @return None.
+ */
+void rsi_print(int zone, unsigned char *vdata, int len)
+{
+	unsigned short ii;
+
+	if (!(zone & rsi_zone_enabled))
+		return;
+
+	if (!vdata)
+		return;
+
+	for (ii = 0; ii < len; ii++) {
+		if (!(ii % 16))
+			pr_info("\n");
+		pr_info("%02x ", (vdata[ii]));
+	}
+	pr_info("\n");
+}
+
+/**
+ * This function initializes os interface operations.
+ *
+ * @param void.
+ * @return Pointer to the adapter structure on success, NULL on failure .
+ */
+struct rsi_hw *rsi_init_os_intf_ops(void)
+{
+	struct rsi_hw *adapter = NULL;
+	struct rsi_common *common = NULL;
+	unsigned char ii = 0;
+
+	adapter = kzalloc(sizeof(*adapter), GFP_KERNEL);
+	if (!adapter)
+		return NULL;
+
+	adapter->priv = kzalloc(sizeof(*common), GFP_KERNEL);
+	if (adapter->priv == NULL) {
+		rsi_dbg(ERR_ZONE, "%s: Failed in allocation of memory\n",
+			__func__);
+		kfree(adapter);
+		return NULL;
+	} else {
+		common = adapter->priv;
+		common->priv = adapter;
+	}
+
+	common->common_ops = rsi_get_common_ops();
+
+	for (ii = 0; ii < NUM_SOFT_QUEUES; ii++)
+		skb_queue_head_init(&common->tx_queue[ii]);
+
+#ifdef USE_USB_INTF
+	rsi_init_event(&common->rx_event);
+#endif
+
+	rsi_init_event(&common->tx_event);
+	mutex_init(&common->mutex);
+	mutex_init(&common->tx_rxlock);
+
+	if (rsi_create_kthread(common,
+			       &common->tx_thread,
+			       rsi_tx_scheduler_thread,
+			       "Thread")) {
+		rsi_dbg(ERR_ZONE, "%s: Unable to init tx thrd\n", __func__);
+		goto err;
+	}
+
+#ifdef USE_USB_INTF
+	if (rsi_create_kthread(common,
+			       &common->rx_thread,
+			       rsi_usb_rx_thread,
+			       "RX-Thread")) {
+		rsi_dbg(ERR_ZONE, "%s: Unable to init rx thrd\n", __func__);
+		goto err1;
+	}
+#endif
+
+	if (rsi_init_proc_fs(adapter)) {
+		rsi_dbg(ERR_ZONE, "\n%s: Failed to initialize procfs\n",
+			__func__);
+		goto err2;
+	}
+
+#ifdef USE_USB_INTF
+	common->rx_data_pkt = kmalloc(2048, GFP_KERNEL);
+	if (!common->rx_data_pkt) {
+		rsi_dbg(ERR_ZONE, "%s: Failed to allocate memory\n",
+			__func__);
+		rsi_proc_remove(adapter);
+		goto err2;
+	}
+#endif
+
+	common->init_done = 1;
+	return adapter;
+
+err2:
+#ifdef USE_USB_INTF
+	rsi_kill_thread(common, 0);
+err1:
+#endif
+	rsi_kill_thread(common, 1);
+err:
+	kfree(common);
+	kfree(adapter);
+	return NULL;
+}
+
+/**
+ * This function de-intializes os interface operations.
+ *
+ * @param  adapter Pointer to the adapter structure.
+ * @return None.
+ */
+void rsi_deinit_os_intf_ops(struct rsi_hw *adapter)
+{
+	unsigned char ii;
+	struct rsi_common *common = adapter->priv;
+
+	rsi_dbg(INFO_ZONE, "%s: Performing deinit os ops\n", __func__);
+#ifdef USE_USB_INTF
+	rsi_kill_thread(common, 0);
+#endif
+	rsi_kill_thread(common, 1);
+
+	rsi_proc_remove(adapter);
+
+	for (ii = 0; ii < NUM_SOFT_QUEUES; ii++)
+		skb_queue_purge(&common->tx_queue[ii]);
+	common->init_done = 0;
+
+#ifdef USE_USB_INTF
+	kfree(common->rx_data_pkt);
+#endif
+	kfree(common);
+	kfree(adapter);
+	return;
+}
diff -uprN a/drivers/net/wireless/rsi/include/rsi_boot_params.h b/drivers/net/wireless/rsi/include/rsi_boot_params.h
--- a/drivers/net/wireless/rsi/include/rsi_boot_params.h	1970-01-01 05:30:00.000000000 +0530
+++ b/drivers/net/wireless/rsi/include/rsi_boot_params.h	2014-01-30 16:07:10.607855519 +0530
@@ -0,0 +1,183 @@
+/**
+ * @file rsi_boot_params.h
+ * @author
+ * @version 1.0
+ *
+ * @section LICENSE
+ * Copyright (c) 2013 Redpine Signals Inc.
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
+ *
+ * @section DESCRIPTION
+ *
+ * This file contians the bootup parameters to be loaded to firmware.
+ */
+
+#ifndef __RSI_BOOTPARAMS_HEADER_H__
+#define __RSI_BOOTPARAMS_HEADER_H__
+
+#define CRYSTAL_GOOD_TIME                BIT(0)
+#define BOOTUP_MODE_INFO                 BIT(1)
+#define DIGITAL_LOOP_BACK_PARAMS         BIT(2)
+#define RTLS_TIMESTAMP_EN                BIT(3)
+#define HOST_SPI_INTR_CFG                BIT(4)
+#define WIFI_TAPLL_CONFIGS               BIT(5)
+#define WIFI_PLL960_CONFIGS              BIT(6)
+#define WIFI_AFEPLL_CONFIGS              BIT(7)
+#define WIFI_SWITCH_CLK_CONFIGS          BIT(8)
+#define BT_TAPLL_CONFIGS                 BIT(9)
+#define BT_PLL960_CONFIGS                BIT(10)
+#define BT_AFEPLL_CONFIGS                BIT(11)
+#define BT_SWITCH_CLK_CONFIGS            BIT(12)
+#define ZB_TAPLL_CONFIGS                 BIT(13)
+#define ZB_PLL960_CONFIGS                BIT(14)
+#define ZB_AFEPLL_CONFIGS                BIT(15)
+#define ZB_SWITCH_CLK_CONFIGS            BIT(16)
+#define BUCKBOOST_WAIT_INFO              BIT(17)
+#define PMU_WAKEUP_SHUTDOWN_W            BIT(18)
+#define WDT_PROG_VALUES                  BIT(19)
+#define WDT_RESET_DELAY_VALUE            BIT(20)
+#define DCDC_OPERATION_MODE_VALID        BIT(21)
+#define PMU_SLP_CLKOUT_SEL               BIT(22)
+#define SOC_RESET_WAIT_CNT               BIT(23)
+
+#define LOADED_TOKEN                     0x5AA5
+#define ROM_TOKEN                        0x55AA
+
+#define TA_PLL_DIS_20                    BIT(5)
+#define TA_PLL_M_VAL_20                  8
+#define TA_PLL_N_VAL_20                  1
+#define TA_PLL_P_VAL_20                  4
+
+#define PLL960_DIS_20                    (0x9 << 4)
+#define PLL960_M_VAL_20                  0x14
+#define PLL960_N_VAL_20                  0
+#define PLL960_P_VAL_20                  5
+
+#define BBP_CLK_DIV_FAC_20               1
+#define LMAC_CLK_DIV_FAC_20              1
+#define AFE_CLK_DIV_FAC_20               1
+#define BB_LMAC_160_80_20                BIT(12)
+#define CLK_2_SPARE_GATES_20             (BIT(14) | BIT(13))
+#define UMAC_CLK_40MHZ                   40
+
+#define TA_PLL_DIS_40                    BIT(5)
+#define TA_PLL_M_VAL_40                  46
+#define TA_PLL_N_VAL_40                  3
+#define TA_PLL_P_VAL_40                  3
+
+#define PLL960_DIS_40                    (0x9 << 4)
+#define PLL960_M_VAL_40                  0x14
+#define PLL960_N_VAL_40                  0
+#define PLL960_P_VAL_40                  5
+
+#define BBP_CLK_DIV_FAC_40               1
+#define LMAC_CLK_DIV_FAC_40              1
+#define AFE_CLK_DIV_FAC_40               1
+#define BB_LMAC_160_80_40                BIT(12)
+#define CLK_2_SPARE_GATES_40             (BIT(14) | BIT(13))
+
+#define UMAC_CLK_20BW \
+	(((TA_PLL_M_VAL_20 + 1) * 40) / \
+	 ((TA_PLL_N_VAL_20 + 1) * (TA_PLL_P_VAL_20 + 1)))
+#define VALID_20 \
+	(WIFI_PLL960_CONFIGS | WIFI_AFEPLL_CONFIGS | WIFI_SWITCH_CLK_CONFIGS)
+#define UMAC_CLK_40BW   \
+	(((TA_PLL_M_VAL_40 + 1) * 40) / \
+	 ((TA_PLL_N_VAL_40 + 1) * (TA_PLL_P_VAL_40 + 1)))
+#define VALID_40 \
+	(WIFI_PLL960_CONFIGS | WIFI_AFEPLL_CONFIGS | WIFI_SWITCH_CLK_CONFIGS | \
+	 WIFI_TAPLL_CONFIGS | CRYSTAL_GOOD_TIME | BOOTUP_MODE_INFO)
+
+/* structure to store configs related to TAPLL programming */
+struct tapll_info {
+	unsigned int pll_reg_1:16;
+	unsigned int pll_reg_2:16;
+} __packed;
+
+/* structure to store configs related to PLL960 programming */
+struct pll960_info {
+	unsigned int pll_reg_1:16;
+	unsigned int pll_reg_2:16;
+	unsigned int pll_reg_3:16;
+} __packed;
+
+/* structure to store configs related to AFEPLL programming */
+struct afepll_info {
+	unsigned int pll_reg:16;
+} __packed;
+
+/* structure to store configs related to pll configs */
+struct pll_config {
+	struct tapll_info tapll_info_g;
+	struct pll960_info pll960_info_g;
+	struct afepll_info afepll_info_g;
+} __packed;
+
+/* structure to store configs related to UMAC clk programming */
+struct switch_clk {
+	/* If set rest is valid */
+	unsigned int switch_umac_clk:1;
+	/* If set qspi clk will be changed */
+	unsigned int switch_qspi_clk:1;
+	/* If set sleep clk will be changed to 32MHz */
+	unsigned int switch_slp_clk_2_32:1;
+	/* If set program the bbp lmac clock reg val into the
+	 * BBP_LMAC_CLOCK_REG
+	 */
+	unsigned int switch_bbp_lmac_clk_reg:1;
+	/* If set config mem_ctrl for 120Mhz support */
+	unsigned int switch_mem_ctrl_cfg:1;
+	unsigned int reserved:11;
+	/* If switch_bbp_lmac_clk_reg is set then this value will be programmed
+	 * into reg
+	 */
+	unsigned int bbp_lmac_clk_reg_val:16;
+	/* if switch_umac_clk is set then this value will be programmed */
+	unsigned int umac_clock_reg_config:16;
+	/* if switch_qspi_clk is set then this value will be programmed */
+	unsigned int qspi_uart_clock_reg_config:16;
+};
+
+struct device_clk_info {
+	struct pll_config pll_config_g;
+	struct switch_clk switch_clk_g;
+};
+
+struct bootup_params {
+	unsigned short magic_number;
+	unsigned short crystal_good_time;
+	unsigned int valid;
+	unsigned int reserved_for_valids;
+	unsigned short bootup_mode_info;
+	/* configuration used for digital loop back */
+	unsigned short digital_loop_back_params;
+	unsigned short rtls_timestamp_en;
+	unsigned short host_spi_intr_cfg;
+	struct device_clk_info device_clk_info[3];
+	/* ulp buckboost wait time  */
+	unsigned int buckboost_wakeup_cnt;
+	/* pmu wakeup wait time & WDT EN info */
+	unsigned short pmu_wakeup_wait;
+	unsigned char shutdown_wait_time;
+	/* Sleep clock source selection */
+	unsigned char pmu_slp_clkout_sel;
+	/* WDT programming values */
+	unsigned int wdt_prog_value;
+	/* WDT soc reset delay */
+	unsigned int wdt_soc_rst_delay;
+	/* dcdc modes configs */
+	unsigned int dcdc_operation_mode;
+	unsigned int soc_reset_wait_cnt;
+};
+#endif
diff -uprN a/drivers/net/wireless/rsi/include/rsi_common.h b/drivers/net/wireless/rsi/include/rsi_common.h
--- a/drivers/net/wireless/rsi/include/rsi_common.h	1970-01-01 05:30:00.000000000 +0530
+++ b/drivers/net/wireless/rsi/include/rsi_common.h	2014-01-30 16:07:10.609855773 +0530
@@ -0,0 +1,302 @@
+/**
+ * @file rsi_common.h
+ * @author
+ * @version 1.0
+ *
+ * @section LICENSE
+ * Copyright (c) 2013 Redpine Signals Inc.
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
+ *
+ * @section DESCRIPTION
+ *
+ * This file contians the data structures and variables/ macros commonly
+ * used in the driver .
+ */
+
+#ifndef __RSI_COMMON_H__
+#define __RSI_COMMON_H__
+
+#include <linux/bitops.h>
+#include <linux/string.h>
+#include <linux/skbuff.h>
+
+#define ERR_ZONE                        BIT(0)  /* For Error Msgs             */
+#define INFO_ZONE                       BIT(1)  /* For General Status Msgs    */
+#define INIT_ZONE                       BIT(2)  /* For Driver Init Seq Msgs   */
+#define MGMT_TX_ZONE                    BIT(3)  /* For TX Mgmt Path Msgs      */
+#define MGMT_RX_ZONE                    BIT(4)  /* For RX Mgmt Path Msgs      */
+#define DATA_TX_ZONE                    BIT(5)  /* For TX Data Path Msgs      */
+#define DATA_RX_ZONE                    BIT(6)  /* For RX Data Path Msgs      */
+#define FSM_ZONE                        BIT(7)  /* For State Machine Msgs     */
+#define ISR_ZONE                        BIT(8) /* For Interrupt Msgs         */
+
+#define FSM_CARD_NOT_READY              0
+#define FSM_BOOT_PARAMS_SENT            1
+#define FSM_EEPROM_READ_MAC_ADDR        2
+#define FSM_RESET_MAC_SENT              3
+#define FSM_RADIO_CAPS_SENT             4
+#define FSM_BB_RF_PROG_SENT             5
+#define FSM_MAC_INIT_DONE               6
+
+#define EVENT_WAIT_FOREVER              (0x00)
+extern unsigned int rsi_zone_enabled;
+
+static inline void rsi_dbg(unsigned int zone, const char *fmt, ...)
+{
+	struct va_format vaf;
+	va_list args;
+
+	va_start(args, fmt);
+
+	vaf.fmt = fmt;
+	vaf.va = &args;
+
+	if (zone & rsi_zone_enabled)
+		pr_info("%pV", &vaf);
+	va_end(args);
+}
+
+#define FRAME_DESC_SZ                   16
+#define DATA_QUEUE_WATER_MARK           400
+#define MIN_DATA_QUEUE_WATER_MARK       300
+#define MULTICAST_WATER_MARK            200
+#define MAC_80211_HDR_FRAME_CONTROL     0
+#define LMAC_VER_OFFSET                 0x200
+#define RSI_MAX_VIFS                    1
+#define NUM_EDCA_QUEUES                 4
+#define IEEE80211_ADDR_LEN              6
+#define WME_NUM_AC                      4
+#define NUM_SOFT_QUEUES                 5
+#define MAX_HW_QUEUES                   8
+#define INVALID_QUEUE                   0xff
+
+#define RSI_PAIRWISE_KEY                1
+#define RSI_GROUP_KEY                   2
+
+/* Queue information */
+#define RSI_WIFI_MGMT_Q                 0x4
+#define RSI_WIFI_DATA_Q                 0x5
+#define IEEE80211_MGMT_FRAME            0x00
+#define IEEE80211_CTL_FRAME             0x04
+
+#define IEEE80211_QOS_TID               0x0f
+#define IEEE80211_NONQOS_TID            16
+#define IEEE80211_QOS_ENABLED           0x80
+#define IEEE80211_MIC_LEN		8
+#define WMM_SHORT_SLOT_TIME             9
+#define SIFS_DURATION                   16
+#define MAX_RTS_THRESHOLD               2346
+#define MAX_FRAG_LEN                    2346
+
+#define TID_TO_WME_AC(_tid) (      \
+	((_tid) == 0 || (_tid) == 3) ? BE_Q : \
+	((_tid) < 3) ? BK_Q : \
+	((_tid) < 6) ? VI_Q : \
+	VO_Q)
+
+#define WME_AC(_q) (    \
+	((_q) == BK_Q) ? IEEE80211_AC_BK : \
+	((_q) == BE_Q) ? IEEE80211_AC_BE : \
+	((_q) == VI_Q) ? IEEE80211_AC_VI : \
+	IEEE80211_AC_VO)
+
+#define KEY_TYPE_CLEAR                  0
+
+/* EPPROM_READ_ADDRESS */
+#define WLAN_MAC_EEPROM_ADDR               40
+#define WLAN_MAC_MAGIC_WORD_LEN            0x01
+#define WLAN_HOST_MODE_LEN                 0x04
+#define MAGIC_WORD                         0x5A
+
+enum sta_notify_events {
+	STA_CONNECTED = 0,
+	STA_DISCONNECTED,
+	STA_TX_ADDBA_DONE,
+	STA_TX_DELBA,
+	STA_RX_ADDBA_DONE,
+	STA_RX_DELBA
+};
+
+struct version_info {
+	unsigned short major;
+	unsigned short minor;
+	unsigned char release_num;
+	unsigned char patch_num;
+	struct {
+		unsigned char fw_ver[8];
+	} info;
+};
+
+struct skb_info {
+	char rssi;
+	unsigned int flags;
+	unsigned short channel;
+	char tid;
+	char sta_id;
+};
+
+enum EDCA_QUEUE {
+	BK_Q,
+	BE_Q,
+	VI_Q,
+	VO_Q,
+	MGMT_SOFT_Q
+};
+
+/* RF Types */
+enum rf_type {
+	RSI_RF_8230,
+	RSI_RF_8111
+};
+
+struct security_info {
+	bool security_enable;
+	unsigned int ptk_cipher;
+	unsigned int gtk_cipher;
+};
+
+struct wmm_qinfo {
+	int weight;
+	int wme_params;
+	int pkt_contended;
+};
+
+struct transmit_q_stats {
+	unsigned int total_data_pkt_send[NUM_EDCA_QUEUES];
+	unsigned int total_data_pkt_freed[NUM_EDCA_QUEUES];
+	unsigned int total_mgmt_pkt_send;
+	unsigned int total_mgmt_pkt_freed;
+};
+
+struct receive_info {
+	bool buffer_full;
+	bool semi_buffer_full;
+	bool mgmt_buffer_full;
+	unsigned int mgmt_buf_full_counter;
+	unsigned int buf_semi_full_counter;
+#ifdef USE_SDIO_INTF
+	unsigned char watch_bufferfull_count;
+	unsigned int sdio_intr_status_zero;
+	unsigned int sdio_int_counter;
+	unsigned int total_sdio_msdu_pending_intr;
+	unsigned int total_sdio_unknown_intr;
+#endif
+	unsigned int buf_full_counter;
+	unsigned int buf_avilable_counter;
+};
+
+struct vif_priv {
+	bool is_ht;
+	bool sgi;
+};
+
+typedef void (*thread_function)(void *);
+
+struct rsi_thread {
+	thread_function function_ptr;
+	struct completion completion;
+	struct task_struct *task;
+};
+
+struct rsi_event {
+	atomic_t event_condition;
+	wait_queue_head_t event_queue;
+};
+
+struct rsi_common {
+	struct rsi_hw *priv;
+	struct rsi_common_ops *common_ops;
+	struct vif_priv vif_info[RSI_MAX_VIFS];
+
+	struct timer_list scan_timer;
+	bool mgmt_q_block;
+	struct version_info driver_ver;
+	struct version_info fw_ver;
+
+	struct rsi_thread tx_thread;
+#ifdef USE_USB_INTF
+	struct rsi_thread rx_thread;
+#endif
+	struct sk_buff_head tx_queue[NUM_EDCA_QUEUES + 1];
+	struct rsi_event tx_event;
+	struct rsi_event rx_event;
+	/* Mutex declaration */
+	struct mutex mutex;
+	/* Mutex used between tx/rx threads */
+	struct mutex tx_rxlock;
+	atomic_t tx_thread_done;
+	atomic_t rx_thread_done;
+	unsigned char endpoint;
+
+	/* Channel/band related */
+	unsigned char band;
+	unsigned char channel_width;
+
+	unsigned short rts_threshold;
+	unsigned short bitrate_mask[2];
+	unsigned int fixedrate_mask[2];
+
+	unsigned char rf_reset;
+	enum rf_type rftype;
+	struct transmit_q_stats tx_stats;
+	struct security_info secinfo;
+	struct wmm_qinfo tx_qinfo[NUM_EDCA_QUEUES];
+	struct receive_info rx_info;
+	struct ieee80211_tx_queue_params edca_params[NUM_EDCA_QUEUES];
+	unsigned char mac_addr[IEEE80211_ADDR_LEN];
+
+	/* state related */
+	unsigned int fsm_state;
+	unsigned int init_done;
+	unsigned char bb_rf_prog_count;
+	bool iface_down;
+
+	/* Generic */
+	unsigned char channel;
+	unsigned char *rx_data_pkt;
+	unsigned char mac_id;
+	unsigned char radio_id;
+	unsigned short rate_pwr[20];
+	unsigned short min_rate;
+} __packed;
+
+struct rsi_hw;
+struct rsi_common_ops {
+	int (*wait_queue_event)(struct rsi_event *event, unsigned int timeout);
+	void (*set_event)(struct rsi_event *event);
+	void (*reset_event)(struct rsi_event *event);
+	int (*host_intf_write_pkt)(struct rsi_hw *adapter, unsigned char *pkt,
+				   unsigned int len);
+	int (*load_firmware)(struct rsi_hw *adapter, unsigned int addr,
+			     unsigned char *data, unsigned int count);
+#ifdef USE_USB_INTF
+	int (*rx_urb_submit)(struct rsi_hw *adapter);
+#else
+	int (*write_register)(struct rsi_hw *adapter, unsigned char reg_dmn,
+			      unsigned int addr, unsigned char *data);
+	int (*read_register)(struct rsi_hw *adapter,
+			     unsigned int addr, unsigned char *data);
+	int (*host_intf_read_pkt)(struct rsi_hw *adapter, unsigned char *pkt,
+				  unsigned int len);
+	void (*ack_interrupt)(struct rsi_hw *adapter, unsigned char int_bit);
+	int (*write_reg_multiple)(struct rsi_hw *adapter, unsigned int addr,
+				  unsigned char *data, unsigned int count);
+	int (*read_reg_multiple)(struct rsi_hw *adapter, unsigned int addr,
+				 unsigned int count, unsigned char *data);
+#endif
+	void (*qos_processor)(struct rsi_common *common);
+	int (*core_xmit)(struct rsi_common *common, struct sk_buff *skb);
+	void (*print)(int zone, unsigned char *vdata, int len);
+};
+#endif


