Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pa0-f41.google.com ([209.85.220.41]:58107 "EHLO
	mail-pa0-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753952AbaCJP06 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 10 Mar 2014 11:26:58 -0400
Received: by mail-pa0-f41.google.com with SMTP id fa1so7392217pad.14
        for <linux-wireless@vger.kernel.org>; Mon, 10 Mar 2014 08:26:57 -0700 (PDT)
From: fariyaf@gmail.com
To: linux-wireless@vger.kernel.org
Cc: Fariya Fatima <fariyaf@gmail.com>
Subject: [PATCH v4 04/11] rsi: Writing packets to device and debugfs.
Date: Mon, 10 Mar 2014 20:56:32 +0530
Message-Id: <1394465199-10042-5-git-send-email-fariyaf@gmail.com> (sfid-20140310_162805_520648_3F5E4A26)
In-Reply-To: <1394465199-10042-1-git-send-email-fariyaf@gmail.com>
References: <1394465199-10042-1-git-send-email-fariyaf@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Fariya Fatima <fariyaf@gmail.com>

Signed-off-by: Fariya Fatima <fariyaf@gmail.com>

This patch adds the files relating to debugfs and relating to writing packets to device.
---
 drivers/net/wireless/rsi/rsi_91x_debugfs.c |  339 ++++++++++++++++++++++++++++
 drivers/net/wireless/rsi/rsi_91x_pkt.c     |  195 ++++++++++++++++
 2 files changed, 534 insertions(+), 0 deletions(-)
 create mode 100644 drivers/net/wireless/rsi/rsi_91x_debugfs.c
 create mode 100644 drivers/net/wireless/rsi/rsi_91x_pkt.c

diff --git a/drivers/net/wireless/rsi/rsi_91x_debugfs.c b/drivers/net/wireless/rsi/rsi_91x_debugfs.c
new file mode 100644
index 0000000..7e4ef45
--- /dev/null
+++ b/drivers/net/wireless/rsi/rsi_91x_debugfs.c
@@ -0,0 +1,339 @@
+/**
+ * Copyright (c) 2014 Redpine Signals Inc.
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
+#include "rsi_debugfs.h"
+#include "rsi_sdio.h"
+
+/**
+ * rsi_sdio_stats_read() - This function returns the sdio status of the driver.
+ * @seq: Pointer to the sequence file structure.
+ * @data: Pointer to the data.
+ *
+ * Return: 0 on success, -1 on failure.
+ */
+static int rsi_sdio_stats_read(struct seq_file *seq, void *data)
+{
+	struct rsi_common *common = seq->private;
+	struct rsi_hw *adapter = common->priv;
+	struct rsi_91x_sdiodev *dev =
+		(struct rsi_91x_sdiodev *)adapter->rsi_dev;
+
+	seq_printf(seq, "total_sdio_interrupts: %d\n",
+		   dev->rx_info.sdio_int_counter);
+	seq_printf(seq, "sdio_msdu_pending_intr_count: %d\n",
+		   dev->rx_info.total_sdio_msdu_pending_intr);
+	seq_printf(seq, "sdio_buff_full_count : %d\n",
+		   dev->rx_info.buf_full_counter);
+	seq_printf(seq, "sdio_buf_semi_full_count %d\n",
+		   dev->rx_info.buf_semi_full_counter);
+	seq_printf(seq, "sdio_unknown_intr_count: %d\n",
+		   dev->rx_info.total_sdio_unknown_intr);
+	/* RX Path Stats */
+	seq_printf(seq, "BUFFER FULL STATUS  : %d\n",
+		   dev->rx_info.buffer_full);
+	seq_printf(seq, "SEMI BUFFER FULL STATUS  : %d\n",
+		   dev->rx_info.semi_buffer_full);
+	seq_printf(seq, "MGMT BUFFER FULL STATUS  : %d\n",
+		   dev->rx_info.mgmt_buffer_full);
+	seq_printf(seq, "BUFFER FULL COUNTER  : %d\n",
+		   dev->rx_info.buf_full_counter);
+	seq_printf(seq, "BUFFER SEMI FULL COUNTER  : %d\n",
+		   dev->rx_info.buf_semi_full_counter);
+	seq_printf(seq, "MGMT BUFFER FULL COUNTER  : %d\n",
+		   dev->rx_info.mgmt_buf_full_counter);
+
+	return 0;
+}
+
+/**
+ * rsi_sdio_stats_open() - This funtion calls single open function of seq_file
+ *			   to open file and read contents from it.
+ * @inode: Pointer to the inode structure.
+ * @file: Pointer to the file structure.
+ *
+ * Return: Pointer to the opened file status: 0 on success, ENOMEM on failure.
+ */
+static int rsi_sdio_stats_open(struct inode *inode,
+			       struct file *file)
+{
+	return single_open(file, rsi_sdio_stats_read, inode->i_private);
+}
+
+/**
+ * rsi_version_read() - This function gives driver and firmware version number.
+ * @seq: Pointer to the sequence file structure.
+ * @data: Pointer to the data.
+ *
+ * Return: 0 on success, -1 on failure.
+ */
+static int rsi_version_read(struct seq_file *seq, void *data)
+{
+	struct rsi_common *common = seq->private;
+
+	common->driver_ver.major = 0;
+	common->driver_ver.minor = 1;
+	common->driver_ver.release_num = 0;
+	common->driver_ver.patch_num = 0;
+	seq_printf(seq, "Driver : %x.%d.%d.%d\nLMAC   : %d.%d.%d.%d\n",
+		   common->driver_ver.major,
+		   common->driver_ver.minor,
+		   common->driver_ver.release_num,
+		   common->driver_ver.patch_num,
+		   common->fw_ver.major,
+		   common->fw_ver.minor,
+		   common->fw_ver.release_num,
+		   common->fw_ver.patch_num);
+	return 0;
+}
+
+/**
+ * rsi_version_open() - This funtion calls single open function of seq_file to
+ *			open file and read contents from it.
+ * @inode: Pointer to the inode structure.
+ * @file: Pointer to the file structure.
+ *
+ * Return: Pointer to the opened file status: 0 on success, ENOMEM on failure.
+ */
+static int rsi_version_open(struct inode *inode,
+				 struct file *file)
+{
+	return single_open(file, rsi_version_read, inode->i_private);
+}
+
+/**
+ * rsi_stats_read() - This function return the status of the driver.
+ * @seq: Pointer to the sequence file structure.
+ * @data: Pointer to the data.
+ *
+ * Return: 0 on success, -1 on failure.
+ */
+static int rsi_stats_read(struct seq_file *seq, void *data)
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
+		   common->tx_stats.total_tx_pkt_send[MGMT_SOFT_Q]);
+	seq_printf(seq, "total_mgmt_pkt_queued : %d\n",
+		   skb_queue_len(&common->tx_queue[4]));
+	seq_printf(seq, "total_mgmt_pkt_freed  : %d\n",
+		   common->tx_stats.total_tx_pkt_freed[MGMT_SOFT_Q]);
+
+	/* Data TX Path Stats */
+	seq_printf(seq, "total_data_vo_pkt_send: %8d\t",
+		   common->tx_stats.total_tx_pkt_send[VO_Q]);
+	seq_printf(seq, "total_data_vo_pkt_queued:  %8d\t",
+		   skb_queue_len(&common->tx_queue[0]));
+	seq_printf(seq, "total_vo_pkt_freed: %8d\n",
+		   common->tx_stats.total_tx_pkt_freed[VO_Q]);
+	seq_printf(seq, "total_data_vi_pkt_send: %8d\t",
+		   common->tx_stats.total_tx_pkt_send[VI_Q]);
+	seq_printf(seq, "total_data_vi_pkt_queued:  %8d\t",
+		   skb_queue_len(&common->tx_queue[1]));
+	seq_printf(seq, "total_vi_pkt_freed: %8d\n",
+		   common->tx_stats.total_tx_pkt_freed[VI_Q]);
+	seq_printf(seq,  "total_data_be_pkt_send: %8d\t",
+		   common->tx_stats.total_tx_pkt_send[BE_Q]);
+	seq_printf(seq, "total_data_be_pkt_queued:  %8d\t",
+		   skb_queue_len(&common->tx_queue[2]));
+	seq_printf(seq, "total_be_pkt_freed: %8d\n",
+		   common->tx_stats.total_tx_pkt_freed[BE_Q]);
+	seq_printf(seq, "total_data_bk_pkt_send: %8d\t",
+		   common->tx_stats.total_tx_pkt_send[BK_Q]);
+	seq_printf(seq, "total_data_bk_pkt_queued:  %8d\t",
+		   skb_queue_len(&common->tx_queue[3]));
+	seq_printf(seq, "total_bk_pkt_freed: %8d\n",
+		   common->tx_stats.total_tx_pkt_freed[BK_Q]);
+
+	seq_puts(seq, "\n");
+	return 0;
+}
+
+/**
+ * rsi_stats_open() - This funtion calls single open function of seq_file to
+ *		      open file and read contents from it.
+ * @inode: Pointer to the inode structure.
+ * @file: Pointer to the file structure.
+ *
+ * Return: Pointer to the opened file status: 0 on success, ENOMEM on failure.
+ */
+static int rsi_stats_open(struct inode *inode,
+			  struct file *file)
+{
+	return single_open(file, rsi_stats_read, inode->i_private);
+}
+
+/**
+ * rsi_debug_zone_read() - This function display the currently enabled debug zones.
+ * @seq: Pointer to the sequence file structure.
+ * @data: Pointer to the data.
+ *
+ * Return: 0 on success, -1 on failure.
+ */
+static int rsi_debug_zone_read(struct seq_file *seq, void *data)
+{
+	rsi_dbg(FSM_ZONE, "%x: rsi_enabled zone", rsi_zone_enabled);
+	seq_printf(seq, "The zones available are %#x\n",
+		   rsi_zone_enabled);
+	return 0;
+}
+
+/**
+ * rsi_debug_read() - This funtion calls single open function of seq_file to
+ *		      open file and read contents from it.
+ * @inode: Pointer to the inode structure.
+ * @file: Pointer to the file structure.
+ *
+ * Return: Pointer to the opened file status: 0 on success, ENOMEM on failure.
+ */
+static int rsi_debug_read(struct inode *inode,
+			  struct file *file)
+{
+	return single_open(file, rsi_debug_zone_read, inode->i_private);
+}
+
+/**
+ * rsi_debug_zone_write() - This function writes into hal queues as per user
+ *			    requirement.
+ * @filp: Pointer to the file structure.
+ * @buff: Pointer to the character buffer.
+ * @len: Length of the data to be written into buffer.
+ * @data: Pointer to the data.
+ *
+ * Return: len: Number of bytes read.
+ */
+static ssize_t rsi_debug_zone_write(struct file *filp,
+				    const char __user *buff,
+				    size_t len,
+				    loff_t *data)
+{
+	unsigned long dbg_zone;
+	int ret;
+
+	if (!len)
+		return 0;
+
+	ret = kstrtoul_from_user(buff, len, 16, &dbg_zone);
+
+	if (ret)
+		return ret;
+
+	rsi_zone_enabled = dbg_zone;
+	return len;
+}
+
+#define FOPS(fopen) { \
+	.owner = THIS_MODULE, \
+	.open = (fopen), \
+	.read = seq_read, \
+	.llseek = seq_lseek, \
+}
+
+#define FOPS_RW(fopen, fwrite) { \
+	.owner = THIS_MODULE, \
+	.open = (fopen), \
+	.read = seq_read, \
+	.llseek = seq_lseek, \
+	.write = (fwrite), \
+}
+
+static const struct rsi_dbg_files dev_debugfs_files[] = {
+	{"version", 0644, FOPS(rsi_version_open),},
+	{"stats", 0644, FOPS(rsi_stats_open),},
+	{"debug_zone", 0666, FOPS_RW(rsi_debug_read, rsi_debug_zone_write),},
+	{"sdio_stats", 0644, FOPS(rsi_sdio_stats_open),},
+};
+
+/**
+ * rsi_init_dbgfs() - This function initializes the dbgfs entry.
+ * @adapter: Pointer to the adapter structure.
+ *
+ * Return: 0 on success, -1 on failure.
+ */
+int rsi_init_dbgfs(struct rsi_hw *adapter)
+{
+	struct rsi_common *common = adapter->priv;
+	struct rsi_debugfs *dev_dbgfs;
+	char devdir[6];
+	int ii;
+	const struct rsi_dbg_files *files;
+
+	dev_dbgfs = kzalloc(sizeof(*dev_dbgfs), GFP_KERNEL);
+	adapter->dfsentry = dev_dbgfs;
+
+	snprintf(devdir, sizeof(devdir), "%s",
+		 wiphy_name(adapter->hw->wiphy));
+	dev_dbgfs->subdir = debugfs_create_dir(devdir, NULL);
+
+	if (IS_ERR(dev_dbgfs->subdir)) {
+		if (dev_dbgfs->subdir == ERR_PTR(-ENODEV))
+			rsi_dbg(ERR_ZONE,
+				"%s:Debugfs has not been mounted\n", __func__);
+		else
+			rsi_dbg(ERR_ZONE, "debugfs:%s not created\n", devdir);
+
+		adapter->dfsentry = NULL;
+		kfree(dev_dbgfs);
+		return (int)PTR_ERR(dev_dbgfs->subdir);
+	} else {
+		for (ii = 0; ii < adapter->num_debugfs_entries; ii++) {
+			files = &dev_debugfs_files[ii];
+			dev_dbgfs->rsi_files[ii] =
+			debugfs_create_file(files->name,
+					    files->perms,
+					    dev_dbgfs->subdir,
+					    common,
+					    &files->fops);
+		}
+	}
+	return 0;
+}
+EXPORT_SYMBOL_GPL(rsi_init_dbgfs);
+
+/**
+ * rsi_remove_dbgfs() - Removes the previously created dbgfs file entries
+ *			in the reverse order of creation.
+ * @adapter: Pointer to the adapter structure.
+ *
+ * Return: None.
+ */
+void rsi_remove_dbgfs(struct rsi_hw *adapter)
+{
+	struct rsi_debugfs *dev_dbgfs = adapter->dfsentry;
+
+	if (!dev_dbgfs)
+		return;
+
+	debugfs_remove_recursive(dev_dbgfs->subdir);
+}
+EXPORT_SYMBOL_GPL(rsi_remove_dbgfs);
diff --git a/drivers/net/wireless/rsi/rsi_91x_pkt.c b/drivers/net/wireless/rsi/rsi_91x_pkt.c
new file mode 100644
index 0000000..717bef1
--- /dev/null
+++ b/drivers/net/wireless/rsi/rsi_91x_pkt.c
@@ -0,0 +1,195 @@
+/**
+ * Copyright (c) 2014 Redpine Signals Inc.
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
+#include "rsi_mgmt.h"
+
+/**
+ * rsi_send_data_pkt() - This function sends the recieved data packet from
+ *			 driver to device.
+ * @common: Pointer to the driver private structure.
+ * @skb: Pointer to the socket buffer structure.
+ *
+ * Return: status: 0 on success, -1 on failure.
+ */
+int rsi_send_data_pkt(struct rsi_common *common, struct sk_buff *skb)
+{
+	struct rsi_hw *adapter = common->priv;
+	struct ieee80211_hdr *tmp_hdr = NULL;
+	struct ieee80211_tx_info *info;
+	struct skb_info *tx_params;
+	struct ieee80211_bss_conf *bss = NULL;
+	int status = -EINVAL;
+	u8 ieee80211_size = MIN_802_11_HDR_LEN;
+	u8 extnd_size = 0;
+	__le16 *frame_desc;
+	u16 seq_num = 0;
+
+	info = IEEE80211_SKB_CB(skb);
+	bss = &info->control.vif->bss_conf;
+	tx_params = (struct skb_info *)info->driver_data;
+
+	if (!bss->assoc)
+		goto err;
+
+	tmp_hdr = (struct ieee80211_hdr *)&skb->data[0];
+	seq_num = (le16_to_cpu(tmp_hdr->seq_ctrl) >> 4);
+
+	extnd_size = ((uintptr_t)skb->data & 0x3);
+
+	if ((FRAME_DESC_SZ + extnd_size) > skb_headroom(skb)) {
+		rsi_dbg(ERR_ZONE, "%s: Unable to send pkt\n", __func__);
+		goto err;
+	}
+
+	skb_push(skb, (FRAME_DESC_SZ + extnd_size));
+	frame_desc = (__le16 *)&skb->data[0];
+	memset((u8 *)frame_desc, 0, FRAME_DESC_SZ);
+
+	if (ieee80211_is_data_qos(tmp_hdr->frame_control)) {
+		ieee80211_size += 2;
+		frame_desc[6] |= cpu_to_le16(BIT(12));
+	}
+
+	if ((!(info->flags & IEEE80211_TX_INTFL_DONT_ENCRYPT)) &&
+	    (common->secinfo.security_enable)) {
+		if (rsi_is_cipher_wep(common))
+			ieee80211_size += 4;
+		else
+			ieee80211_size += 8;
+		frame_desc[6] |= cpu_to_le16(BIT(15));
+	}
+
+	frame_desc[0] = cpu_to_le16((skb->len - FRAME_DESC_SZ) |
+				    (RSI_WIFI_DATA_Q << 12));
+	frame_desc[2] = cpu_to_le16((extnd_size) | (ieee80211_size) << 8);
+
+	if (common->min_rate != 0xffff) {
+		/* Send fixed rate */
+		frame_desc[3] = cpu_to_le16(RATE_INFO_ENABLE);
+		frame_desc[4] = cpu_to_le16(common->min_rate);
+	}
+
+	frame_desc[6] |= cpu_to_le16(seq_num & 0xfff);
+	frame_desc[7] = cpu_to_le16(((tx_params->tid & 0xf) << 4) |
+				    (skb->priority & 0xf) |
+				    (tx_params->sta_id << 8));
+
+	status = adapter->host_intf_write_pkt(common->priv,
+					      skb->data,
+					      skb->len);
+	if (status)
+		rsi_dbg(ERR_ZONE, "%s: Failed to write pkt\n",
+			__func__);
+
+err:
+	++common->tx_stats.total_tx_pkt_freed[skb->priority];
+	rsi_indicate_tx_status(common->priv, skb, status);
+	return status;
+}
+
+/**
+ * rsi_send_mgmt_pkt() - This functions sends the received management packet
+ *			 from driver to device.
+ * @common: Pointer to the driver private structure.
+ * @skb: Pointer to the socket buffer structure.
+ *
+ * Return: status: 0 on success, -1 on failure.
+ */
+int rsi_send_mgmt_pkt(struct rsi_common *common,
+		      struct sk_buff *skb)
+{
+	struct rsi_hw *adapter = common->priv;
+	struct ieee80211_hdr *wh = NULL;
+	struct ieee80211_tx_info *info;
+	struct ieee80211_bss_conf *bss = NULL;
+	struct skb_info *tx_params;
+	int status = -E2BIG;
+	__le16 *msg = NULL;
+	u8 extnd_size = 0;
+	u8 vap_id = 0;
+
+	info = IEEE80211_SKB_CB(skb);
+	tx_params = (struct skb_info *)info->driver_data;
+	extnd_size = ((uintptr_t)skb->data & 0x3);
+
+	if (tx_params->flags & INTERNAL_MGMT_PKT) {
+		if ((extnd_size) > skb_headroom(skb)) {
+			rsi_dbg(ERR_ZONE, "%s: Unable to send pkt\n", __func__);
+			dev_kfree_skb(skb);
+			return -1;
+		}
+		skb_push(skb, extnd_size);
+		skb->data[extnd_size + 4] = extnd_size;
+		status = adapter->host_intf_write_pkt(common->priv,
+						      (u8 *)skb->data,
+						      skb->len);
+		if (status) {
+			rsi_dbg(ERR_ZONE,
+				"%s: Failed to write the packet\n", __func__);
+		}
+		dev_kfree_skb(skb);
+		return status;
+	}
+
+	bss = &info->control.vif->bss_conf;
+	wh = (struct ieee80211_hdr *)&skb->data[0];
+
+	if (FRAME_DESC_SZ > skb_headroom(skb))
+		goto err;
+
+	skb_push(skb, FRAME_DESC_SZ);
+	memset(skb->data, 0, FRAME_DESC_SZ);
+	msg = (__le16 *)skb->data;
+
+	if (skb->len > MAX_MGMT_PKT_SIZE) {
+		rsi_dbg(INFO_ZONE, "%s: Dropping mgmt pkt > 512\n", __func__);
+		goto err;
+	}
+
+	msg[0] = cpu_to_le16((skb->len - FRAME_DESC_SZ) |
+			    (RSI_WIFI_MGMT_Q << 12));
+	msg[1] = cpu_to_le16(TX_DOT11_MGMT);
+	msg[2] = cpu_to_le16(MIN_802_11_HDR_LEN << 8);
+	msg[3] = cpu_to_le16(RATE_INFO_ENABLE);
+	msg[6] = cpu_to_le16(le16_to_cpu(wh->seq_ctrl) >> 4);
+
+	if (wh->addr1[0] & BIT(0))
+		msg[3] |= cpu_to_le16(RSI_BROADCAST_PKT);
+
+	if (common->band == IEEE80211_BAND_2GHZ)
+		msg[4] = cpu_to_le16(RSI_11B_MODE);
+	else
+		msg[4] = cpu_to_le16((RSI_RATE_6 & 0x0f) | RSI_11G_MODE);
+
+	/* Indicate to firmware to give cfm */
+	if ((skb->data[16] == IEEE80211_STYPE_PROBE_REQ) && (!bss->assoc)) {
+		msg[1] |= cpu_to_le16(BIT(10));
+		msg[7] = cpu_to_le16(PROBEREQ_CONFIRM);
+		common->mgmt_q_block = true;
+	}
+
+	msg[7] |= cpu_to_le16(vap_id << 8);
+
+	status = adapter->host_intf_write_pkt(common->priv,
+					      (u8 *)msg,
+					      skb->len);
+	if (status)
+		rsi_dbg(ERR_ZONE, "%s: Failed to write the packet\n", __func__);
+
+err:
+	rsi_indicate_tx_status(common->priv, skb, status);
+	return status;
+}
-- 
1.7.5.4

