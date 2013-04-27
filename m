Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from cdptpa-omtalb.mail.rr.com ([75.180.132.120]:65089 "EHLO
	cdptpa-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755520Ab3D0T1q (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 27 Apr 2013 15:27:46 -0400
From: Solomon Peachy <pizza@shaftnet.org>
To: linux-wireless@vger.kernel.org
Cc: Solomon Peachy <pizza@shaftnet.org>
Subject: [PATCH 06/14] cw1200: v6: Debugging hooks and test tool support
Date: Sat, 27 Apr 2013 15:27:19 -0400
Message-Id: <1367090847-11937-7-git-send-email-pizza@shaftnet.org> (sfid-20130427_212750_478694_6EEAB53B)
In-Reply-To: <1367090847-11937-1-git-send-email-pizza@shaftnet.org>
References: <1367090847-11937-1-git-send-email-pizza@shaftnet.org>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Signed-off-by: Solomon Peachy <pizza@shaftnet.org>
---
 drivers/net/wireless/cw1200/debug.c | 664 ++++++++++++++++++++++++++++++++
 drivers/net/wireless/cw1200/debug.h |  98 +++++
 drivers/net/wireless/cw1200/itp.c   | 738 ++++++++++++++++++++++++++++++++++++
 drivers/net/wireless/cw1200/itp.h   | 144 +++++++
 4 files changed, 1644 insertions(+)
 create mode 100644 drivers/net/wireless/cw1200/debug.c
 create mode 100644 drivers/net/wireless/cw1200/debug.h
 create mode 100644 drivers/net/wireless/cw1200/itp.c
 create mode 100644 drivers/net/wireless/cw1200/itp.h

diff --git a/drivers/net/wireless/cw1200/debug.c b/drivers/net/wireless/cw1200/debug.c
new file mode 100644
index 0000000..b815181
--- /dev/null
+++ b/drivers/net/wireless/cw1200/debug.c
@@ -0,0 +1,664 @@
+/*
+ * mac80211 glue code for mac80211 ST-Ericsson CW1200 drivers
+ * DebugFS code
+ *
+ * Copyright (c) 2010, ST-Ericsson
+ * Author: Dmitry Tarnyagin <dmitry.tarnyagin@lockless.no>
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License version 2 as
+ * published by the Free Software Foundation.
+ */
+
+#include <linux/module.h>
+#include <linux/debugfs.h>
+#include <linux/seq_file.h>
+#include "cw1200.h"
+#include "debug.h"
+#include "fwio.h"
+
+/* join_status */
+static const char * const cw1200_debug_join_status[] = {
+	"passive",
+	"monitor",
+	"station (joining)",
+	"station (not authenticated yet)",
+	"station",
+	"adhoc",
+	"access point",
+};
+
+/* WSM_JOIN_PREAMBLE_... */
+static const char * const cw1200_debug_preamble[] = {
+	"long",
+	"short",
+	"long on 1 and 2 Mbps",
+};
+
+
+static const char * const cw1200_debug_link_id[] = {
+	"OFF",
+	"REQ",
+	"SOFT",
+	"HARD",
+};
+
+static const char *cw1200_debug_mode(int mode)
+{
+	switch (mode) {
+	case NL80211_IFTYPE_UNSPECIFIED:
+		return "unspecified";
+	case NL80211_IFTYPE_MONITOR:
+		return "monitor";
+	case NL80211_IFTYPE_STATION:
+		return "station";
+	case NL80211_IFTYPE_ADHOC:
+		return "adhoc";
+	case NL80211_IFTYPE_MESH_POINT:
+		return "mesh point";
+	case NL80211_IFTYPE_AP:
+		return "access point";
+	case NL80211_IFTYPE_P2P_CLIENT:
+		return "p2p client";
+	case NL80211_IFTYPE_P2P_GO:
+		return "p2p go";
+	default:
+		return "unsupported";
+	}
+}
+
+static void cw1200_queue_status_show(struct seq_file *seq,
+				     struct cw1200_queue *q)
+{
+	int i;
+	seq_printf(seq, "Queue       %d:\n", q->queue_id);
+	seq_printf(seq, "  capacity: %zu\n", q->capacity);
+	seq_printf(seq, "  queued:   %zu\n", q->num_queued);
+	seq_printf(seq, "  pending:  %zu\n", q->num_pending);
+	seq_printf(seq, "  sent:     %zu\n", q->num_sent);
+	seq_printf(seq, "  locked:   %s\n", q->tx_locked_cnt ? "yes" : "no");
+	seq_printf(seq, "  overfull: %s\n", q->overfull ? "yes" : "no");
+	seq_puts(seq,   "  link map: 0-> ");
+	for (i = 0; i < q->stats->map_capacity; ++i)
+		seq_printf(seq, "%.2d ", q->link_map_cache[i]);
+	seq_printf(seq, "<-%zu\n", q->stats->map_capacity);
+}
+
+static void cw1200_debug_print_map(struct seq_file *seq,
+				   struct cw1200_common *priv,
+				   const char *label,
+				   u32 map)
+{
+	int i;
+	seq_printf(seq, "%s0-> ", label);
+	for (i = 0; i < priv->tx_queue_stats.map_capacity; ++i)
+		seq_printf(seq, "%s ", (map & BIT(i)) ? "**" : "..");
+	seq_printf(seq, "<-%zu\n", priv->tx_queue_stats.map_capacity - 1);
+}
+
+static int cw1200_status_show(struct seq_file *seq, void *v)
+{
+	int i;
+	struct list_head *item;
+	struct cw1200_common *priv = seq->private;
+	struct cw1200_debug_priv *d = priv->debug;
+
+	seq_puts(seq,   "CW1200 Wireless LAN driver status\n");
+	seq_printf(seq, "Hardware:   %d.%d\n",
+		   priv->wsm_caps.hw_id,
+		   priv->wsm_caps.hw_subid);
+	seq_printf(seq, "Firmware:   %s %d.%d\n",
+		   cw1200_fw_types[priv->wsm_caps.fw_type],
+		   priv->wsm_caps.fw_ver,
+		   priv->wsm_caps.fw_build);
+	seq_printf(seq, "FW API:     %d\n",
+		   priv->wsm_caps.fw_api);
+	seq_printf(seq, "FW caps:    0x%.4X\n",
+		   priv->wsm_caps.fw_cap);
+	seq_printf(seq, "FW label:  '%s'\n",
+		   priv->wsm_caps.fw_label);
+	seq_printf(seq, "Mode:       %s%s\n",
+		   cw1200_debug_mode(priv->mode),
+		   priv->listening ? " (listening)" : "");
+	seq_printf(seq, "Join state: %s\n",
+		   cw1200_debug_join_status[priv->join_status]);
+	if (priv->channel)
+		seq_printf(seq, "Channel:    %d%s\n",
+			   priv->channel->hw_value,
+			   priv->channel_switch_in_progress ?
+			   " (switching)" : "");
+	if (priv->rx_filter.promiscuous)
+		seq_puts(seq,   "Filter:     promisc\n");
+	else if (priv->rx_filter.fcs)
+		seq_puts(seq,   "Filter:     fcs\n");
+	if (priv->rx_filter.bssid)
+		seq_puts(seq,   "Filter:     bssid\n");
+	if (!priv->disable_beacon_filter)
+		seq_puts(seq,   "Filter:     beacons\n");
+
+	if (priv->enable_beacon ||
+	    priv->mode == NL80211_IFTYPE_AP ||
+	    priv->mode == NL80211_IFTYPE_ADHOC ||
+	    priv->mode == NL80211_IFTYPE_MESH_POINT ||
+	    priv->mode == NL80211_IFTYPE_P2P_GO)
+		seq_printf(seq, "Beaconing:  %s\n",
+			   priv->enable_beacon ?
+			   "enabled" : "disabled");
+
+	for (i = 0; i < 4; ++i)
+		seq_printf(seq, "EDCA(%d):    %d, %d, %d, %d, %d\n", i,
+			   priv->edca.params[i].cwmin,
+			   priv->edca.params[i].cwmax,
+			   priv->edca.params[i].aifns,
+			   priv->edca.params[i].txop_limit,
+			   priv->edca.params[i].max_rx_lifetime);
+
+	if (priv->join_status == CW1200_JOIN_STATUS_STA) {
+		static const char *pm_mode = "unknown";
+		switch (priv->powersave_mode.mode) {
+		case WSM_PSM_ACTIVE:
+			pm_mode = "off";
+			break;
+		case WSM_PSM_PS:
+			pm_mode = "on";
+			break;
+		case WSM_PSM_FAST_PS:
+			pm_mode = "dynamic";
+			break;
+		}
+		seq_printf(seq, "Preamble:   %s\n",
+			   cw1200_debug_preamble[priv->association_mode.preamble]);
+		seq_printf(seq, "AMPDU spcn: %d\n",
+			   priv->association_mode.mpdu_start_spacing);
+		seq_printf(seq, "Basic rate: 0x%.8X\n",
+			   le32_to_cpu(priv->association_mode.basic_rate_set));
+		seq_printf(seq, "Bss lost:   %d beacons\n",
+			   priv->bss_params.beacon_lost_count);
+		seq_printf(seq, "AID:        %d\n",
+			   priv->bss_params.aid);
+		seq_printf(seq, "Rates:      0x%.8X\n",
+			   priv->bss_params.operational_rate_set);
+		seq_printf(seq, "Powersave:  %s\n", pm_mode);
+	}
+	seq_printf(seq, "HT:         %s\n",
+		   cw1200_is_ht(&priv->ht_info) ? "on" : "off");
+	if (cw1200_is_ht(&priv->ht_info)) {
+		seq_printf(seq, "Greenfield: %s\n",
+			   cw1200_ht_greenfield(&priv->ht_info) ? "yes" : "no");
+		seq_printf(seq, "AMPDU dens: %d\n",
+			   cw1200_ht_ampdu_density(&priv->ht_info));
+	}
+	seq_printf(seq, "RSSI thold: %d\n",
+		   priv->cqm_rssi_thold);
+	seq_printf(seq, "RSSI hyst:  %d\n",
+		   priv->cqm_rssi_hyst);
+	seq_printf(seq, "Long retr:  %d\n",
+		   priv->long_frame_max_tx_count);
+	seq_printf(seq, "Short retr: %d\n",
+		   priv->short_frame_max_tx_count);
+	spin_lock_bh(&priv->tx_policy_cache.lock);
+	i = 0;
+	list_for_each(item, &priv->tx_policy_cache.used)
+		++i;
+	spin_unlock_bh(&priv->tx_policy_cache.lock);
+	seq_printf(seq, "RC in use:  %d\n", i);
+
+	seq_puts(seq, "\n");
+	for (i = 0; i < 4; ++i) {
+		cw1200_queue_status_show(seq, &priv->tx_queue[i]);
+		seq_puts(seq, "\n");
+	}
+
+	cw1200_debug_print_map(seq, priv, "Link map:   ",
+			       priv->link_id_map);
+	cw1200_debug_print_map(seq, priv, "Asleep map: ",
+			       priv->sta_asleep_mask);
+	cw1200_debug_print_map(seq, priv, "PSPOLL map: ",
+			       priv->pspoll_mask);
+
+	seq_puts(seq, "\n");
+
+	for (i = 0; i < CW1200_MAX_STA_IN_AP_MODE; ++i) {
+		if (priv->link_id_db[i].status) {
+			seq_printf(seq, "Link %d:     %s, %pM\n",
+				   i + 1,
+				   cw1200_debug_link_id[priv->link_id_db[i].status],
+				   priv->link_id_db[i].mac);
+		}
+	}
+
+	seq_puts(seq, "\n");
+
+	seq_printf(seq, "BH status:  %s\n",
+		   atomic_read(&priv->bh_term) ? "terminated" : "alive");
+	seq_printf(seq, "Pending RX: %d\n",
+		   atomic_read(&priv->bh_rx));
+	seq_printf(seq, "Pending TX: %d\n",
+		   atomic_read(&priv->bh_tx));
+	if (priv->bh_error)
+		seq_printf(seq, "BH errcode: %d\n",
+			   priv->bh_error);
+	seq_printf(seq, "TX bufs:    %d x %d bytes\n",
+		   priv->wsm_caps.input_buffers,
+		   priv->wsm_caps.input_buffer_size);
+	seq_printf(seq, "Used bufs:  %d\n",
+		   priv->hw_bufs_used);
+	seq_printf(seq, "Powermgmt:  %s\n",
+		   priv->powersave_enabled ? "on" : "off");
+	seq_printf(seq, "Device:     %s\n",
+		   priv->device_can_sleep ? "asleep" : "awake");
+
+	spin_lock(&priv->wsm_cmd.lock);
+	seq_printf(seq, "WSM status: %s\n",
+		   priv->wsm_cmd.done ? "idle" : "active");
+	seq_printf(seq, "WSM cmd:    0x%.4X (%td bytes)\n",
+		   priv->wsm_cmd.cmd, priv->wsm_cmd.len);
+	seq_printf(seq, "WSM retval: %d\n",
+		   priv->wsm_cmd.ret);
+	spin_unlock(&priv->wsm_cmd.lock);
+
+	seq_printf(seq, "Datapath:   %s\n",
+		   atomic_read(&priv->tx_lock) ? "locked" : "unlocked");
+	if (atomic_read(&priv->tx_lock))
+		seq_printf(seq, "TXlock cnt: %d\n",
+			   atomic_read(&priv->tx_lock));
+
+	seq_printf(seq, "TXed:       %d\n",
+		   d->tx);
+	seq_printf(seq, "AGG TXed:   %d\n",
+		   d->tx_agg);
+	seq_printf(seq, "MULTI TXed: %d (%d)\n",
+		   d->tx_multi, d->tx_multi_frames);
+	seq_printf(seq, "RXed:       %d\n",
+		   d->rx);
+	seq_printf(seq, "AGG RXed:   %d\n",
+		   d->rx_agg);
+	seq_printf(seq, "TX miss:    %d\n",
+		   d->tx_cache_miss);
+	seq_printf(seq, "TX align:   %d\n",
+		   d->tx_align);
+	seq_printf(seq, "TX burst:   %d\n",
+		   d->tx_burst);
+	seq_printf(seq, "TX TTL:     %d\n",
+		   d->tx_ttl);
+	seq_printf(seq, "Scan:       %s\n",
+		   atomic_read(&priv->scan.in_progress) ? "active" : "idle");
+
+	return 0;
+}
+
+static int cw1200_status_open(struct inode *inode, struct file *file)
+{
+	return single_open(file, &cw1200_status_show,
+		inode->i_private);
+}
+
+static const struct file_operations fops_status = {
+	.open = cw1200_status_open,
+	.read = seq_read,
+	.llseek = seq_lseek,
+	.release = single_release,
+	.owner = THIS_MODULE,
+};
+
+static int cw1200_counters_show(struct seq_file *seq, void *v)
+{
+	int ret;
+	struct cw1200_common *priv = seq->private;
+	struct wsm_mib_counters_table counters;
+
+	ret = wsm_get_counters_table(priv, &counters);
+	if (ret)
+		return ret;
+
+#define PUT_COUNTER(tab, name) \
+	seq_printf(seq, "%s:" tab "%d\n", #name, \
+		__le32_to_cpu(counters.name))
+
+	PUT_COUNTER("\t\t", plcp_errors);
+	PUT_COUNTER("\t\t", fcs_errors);
+	PUT_COUNTER("\t\t", tx_packets);
+	PUT_COUNTER("\t\t", rx_packets);
+	PUT_COUNTER("\t\t", rx_packet_errors);
+	PUT_COUNTER("\t",   rx_decryption_failures);
+	PUT_COUNTER("\t\t", rx_mic_failures);
+	PUT_COUNTER("\t",   rx_no_key_failures);
+	PUT_COUNTER("\t",   tx_multicast_frames);
+	PUT_COUNTER("\t",   tx_frames_success);
+	PUT_COUNTER("\t",   tx_frame_failures);
+	PUT_COUNTER("\t",   tx_frames_retried);
+	PUT_COUNTER("\t",   tx_frames_multi_retried);
+	PUT_COUNTER("\t",   rx_frame_duplicates);
+	PUT_COUNTER("\t\t", rts_success);
+	PUT_COUNTER("\t\t", rts_failures);
+	PUT_COUNTER("\t\t", ack_failures);
+	PUT_COUNTER("\t",   rx_multicast_frames);
+	PUT_COUNTER("\t",   rx_frames_success);
+	PUT_COUNTER("\t",   rx_cmac_icv_errors);
+	PUT_COUNTER("\t\t", rx_cmac_replays);
+	PUT_COUNTER("\t",   rx_mgmt_ccmp_replays);
+
+#undef PUT_COUNTER
+
+	return 0;
+}
+
+static int cw1200_counters_open(struct inode *inode, struct file *file)
+{
+	return single_open(file, &cw1200_counters_show,
+		inode->i_private);
+}
+
+static const struct file_operations fops_counters = {
+	.open = cw1200_counters_open,
+	.read = seq_read,
+	.llseek = seq_lseek,
+	.release = single_release,
+	.owner = THIS_MODULE,
+};
+
+static int cw1200_generic_open(struct inode *inode, struct file *file)
+{
+	file->private_data = inode->i_private;
+	return 0;
+}
+
+#ifdef CONFIG_CW1200_ETF
+static int cw1200_etf_out_show(struct seq_file *seq, void *v)
+{
+	struct cw1200_common *priv = seq->private;
+	struct sk_buff *skb;
+	u32 len = 0;
+
+	skb = skb_dequeue(&priv->etf_q);
+
+	if (skb)
+		len = skb->len;
+
+	seq_write(seq, &len, sizeof(len));
+
+	if (skb) {
+		seq_write(seq, skb->data, len);
+		kfree_skb(skb);
+	}
+
+	return 0;
+}
+
+static int cw1200_etf_out_open(struct inode *inode, struct file *file)
+{
+	return single_open(file, &cw1200_etf_out_show,
+			   inode->i_private);
+}
+
+static const struct file_operations fops_etf_out = {
+	.open = cw1200_etf_out_open,
+	.read = seq_read,
+	.llseek = seq_lseek,
+	.release = single_release,
+	.owner = THIS_MODULE,
+};
+
+struct etf_req_msg;
+static int etf_request(struct cw1200_common *priv,
+		       struct etf_req_msg *msg, u32 len);
+
+#define MAX_RX_SZE 2600
+
+struct etf_in_state {
+	struct cw1200_common *priv;
+	u32 total_len;
+	u8 buf[MAX_RX_SZE];
+	u32 written;
+};
+
+static int cw1200_etf_in_open(struct inode *inode, struct file *file)
+{
+	struct etf_in_state *etf = kmalloc(sizeof(struct etf_in_state),
+					   GFP_KERNEL);
+
+	if (!etf)
+		return -ENOMEM;
+
+	etf->written = 0;
+	etf->total_len = 0;
+	etf->priv = inode->i_private;
+
+	file->private_data = etf;
+
+	return 0;
+}
+
+static int cw1200_etf_in_release(struct inode *inode, struct file *file)
+{
+	kfree(file->private_data);
+	return 0;
+}
+
+static ssize_t cw1200_etf_in_write(struct file *file,
+	const char __user *user_buf, size_t count, loff_t *ppos)
+{
+	struct etf_in_state *etf = file->private_data;
+
+	ssize_t written = 0;
+
+	if (!etf->total_len) {
+		if (count < sizeof(etf->total_len)) {
+			pr_err("count < sizeof(total_len)\n");
+			return -EINVAL;
+		}
+
+		if (copy_from_user(&etf->total_len, user_buf,
+				   sizeof(etf->total_len))) {
+			pr_err("copy_from_user (len) failed\n");
+			return -EFAULT;
+		}
+
+		written += sizeof(etf->total_len);
+		count -= sizeof(etf->total_len);
+	}
+
+	if (!count)
+		goto done;
+
+	if (copy_from_user(etf->buf + etf->written, user_buf + written,
+			   count)) {
+		pr_err("copy_from_user (payload %zu) failed\n", count);
+		return -EFAULT;
+	}
+
+	written += count;
+	etf->written += count;
+
+	if (etf->written >= etf->total_len) {
+		if (etf_request(etf->priv, (struct etf_req_msg *)etf->buf,
+				etf->total_len)) {
+			pr_err("etf_request failed\n");
+			return -EIO;
+		}
+	}
+
+done:
+	return written;
+}
+
+static const struct file_operations fops_etf_in = {
+	.open = cw1200_etf_in_open,
+	.release = cw1200_etf_in_release,
+	.write = cw1200_etf_in_write,
+	.llseek = default_llseek,
+	.owner = THIS_MODULE,
+};
+#endif /* CONFIG_CW1200_ETF */
+
+static ssize_t cw1200_wsm_dumps(struct file *file,
+	const char __user *user_buf, size_t count, loff_t *ppos)
+{
+	struct cw1200_common *priv = file->private_data;
+	char buf[1];
+
+	if (!count)
+		return -EINVAL;
+	if (copy_from_user(buf, user_buf, 1))
+		return -EFAULT;
+
+	if (buf[0] == '1')
+		priv->wsm_enable_wsm_dumps = 1;
+	else
+		priv->wsm_enable_wsm_dumps = 0;
+
+	return count;
+}
+
+static const struct file_operations fops_wsm_dumps = {
+	.open = cw1200_generic_open,
+	.write = cw1200_wsm_dumps,
+	.llseek = default_llseek,
+};
+
+int cw1200_debug_init(struct cw1200_common *priv)
+{
+	int ret = -ENOMEM;
+	struct cw1200_debug_priv *d = kzalloc(sizeof(struct cw1200_debug_priv),
+			GFP_KERNEL);
+	priv->debug = d;
+	if (!d)
+		return ret;
+
+	d->debugfs_phy = debugfs_create_dir("cw1200",
+					    priv->hw->wiphy->debugfsdir);
+	if (!d->debugfs_phy)
+		goto err;
+
+	if (!debugfs_create_file("status", S_IRUSR, d->debugfs_phy,
+				 priv, &fops_status))
+		goto err;
+
+	if (!debugfs_create_file("counters", S_IRUSR, d->debugfs_phy,
+				 priv, &fops_counters))
+		goto err;
+
+#ifdef CONFIG_CW1200_ETF
+	if (etf_mode) {
+		skb_queue_head_init(&priv->etf_q);
+
+		if (!debugfs_create_file("etf_out", S_IRUSR, d->debugfs_phy,
+					 priv, &fops_etf_out))
+			goto err;
+		if (!debugfs_create_file("etf_in", S_IWUSR, d->debugfs_phy,
+					 priv, &fops_etf_in))
+			goto err;
+	}
+#endif /* CONFIG_CW1200_ETF */
+
+	if (!debugfs_create_file("wsm_dumps", S_IWUSR, d->debugfs_phy,
+				 priv, &fops_wsm_dumps))
+		goto err;
+
+	ret = cw1200_itp_init(priv);
+	if (ret)
+		goto err;
+
+	return 0;
+
+err:
+	priv->debug = NULL;
+	debugfs_remove_recursive(d->debugfs_phy);
+	kfree(d);
+	return ret;
+}
+
+void cw1200_debug_release(struct cw1200_common *priv)
+{
+	struct cw1200_debug_priv *d = priv->debug;
+	if (d) {
+		cw1200_itp_release(priv);
+		priv->debug = NULL;
+		kfree(d);
+	}
+}
+
+#ifdef CONFIG_CW1200_ETF
+struct cw1200_sdd {
+	u8 id;
+	u8 len;
+	u8 data[];
+};
+
+struct etf_req_msg {
+	u32 id;
+	u32 len;
+	u8 data[];
+};
+
+static int parse_sdd_file(struct cw1200_common *priv, u8 *data, u32 length)
+{
+	struct cw1200_sdd *ie;
+
+	while (length > 0) {
+		ie = (struct cw1200_sdd *)data;
+		if (ie->id == SDD_REFERENCE_FREQUENCY_ELT_ID) {
+			priv->hw_refclk = cpu_to_le16(*((u16 *)ie->data));
+			pr_info("Using Reference clock frequency %d KHz\n",
+				priv->hw_refclk);
+			break;
+		}
+
+		length -= ie->len + sizeof(*ie);
+		data += ie->len + sizeof(*ie);
+	}
+	return 0;
+}
+
+char *etf_firmware;
+
+#define ST90TDS_START_ADAPTER           0x09 /* Loads firmware too */
+#define ST90TDS_STOP_ADAPTER            0x0A
+#define ST90TDS_CONFIG_ADAPTER          0x0E /* Send configuration params */
+#define ST90TDS_SBUS_READ               0x13
+#define ST90TDS_SBUS_WRITE              0x14
+#define ST90TDS_GET_DEVICE_OPTION       0x19
+#define ST90TDS_SET_DEVICE_OPTION       0x1A
+#define ST90TDS_SEND_SDD                0x1D /* SDD File used to find DPLL */
+
+#include "fwio.h"
+
+static int etf_request(struct cw1200_common *priv,
+		       struct etf_req_msg *msg,
+		       u32 len)
+{
+	int rval = -1;
+	switch (msg->id) {
+	case ST90TDS_START_ADAPTER:
+		etf_firmware = "cw1200_etf.bin";
+		pr_info("ETF_START (len %d, '%s')\n", len, etf_firmware);
+		rval = cw1200_load_firmware(priv);
+		break;
+	case ST90TDS_STOP_ADAPTER:
+		pr_info("ETF_STOP (unhandled)\n");
+		break;
+	case ST90TDS_SEND_SDD:
+		pr_info("ETF_SDD\n");
+		rval = parse_sdd_file(priv, msg->data, msg->len);
+		break;
+	case ST90TDS_CONFIG_ADAPTER:
+		pr_info("ETF_CONFIG_ADAP (unhandled)\n");
+		break;
+	case ST90TDS_SBUS_READ:
+		pr_info("ETF_SBUS_READ (unhandled)\n");
+		break;
+	case ST90TDS_SBUS_WRITE:
+		pr_info("ETF_SBUS_WRITE (unhandled)\n");
+		break;
+	case ST90TDS_SET_DEVICE_OPTION:
+		pr_info("ETF_SET_DEV_OPT (unhandled)\n");
+		break;
+	default:
+		pr_info("ETF_PASSTHRU (0x%08x)\n", msg->id);
+		rval = wsm_raw_cmd(priv, (u8 *)msg, len);
+		break;
+	}
+
+	return rval;
+}
+#endif /* CONFIG_CW1200_ETF */
diff --git a/drivers/net/wireless/cw1200/debug.h b/drivers/net/wireless/cw1200/debug.h
new file mode 100644
index 0000000..1fea5b2
--- /dev/null
+++ b/drivers/net/wireless/cw1200/debug.h
@@ -0,0 +1,98 @@
+/*
+ * DebugFS code for ST-Ericsson CW1200 mac80211 driver
+ *
+ * Copyright (c) 2011, ST-Ericsson
+ * Author: Dmitry Tarnyagin <dmitry.tarnyagin@lockless.no>
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License version 2 as
+ * published by the Free Software Foundation.
+ */
+
+#ifndef CW1200_DEBUG_H_INCLUDED
+#define CW1200_DEBUG_H_INCLUDED
+
+#include "itp.h"
+
+struct cw1200_debug_priv {
+	struct dentry *debugfs_phy;
+	int tx;
+	int tx_agg;
+	int rx;
+	int rx_agg;
+	int tx_multi;
+	int tx_multi_frames;
+	int tx_cache_miss;
+	int tx_align;
+	int tx_ttl;
+	int tx_burst;
+	int ba_cnt;
+	int ba_acc;
+	int ba_cnt_rx;
+	int ba_acc_rx;
+#ifdef CONFIG_CW1200_ITP
+	struct cw1200_itp itp;
+#endif /* CONFIG_CW1200_ITP */
+};
+
+int cw1200_debug_init(struct cw1200_common *priv);
+void cw1200_debug_release(struct cw1200_common *priv);
+
+static inline void cw1200_debug_txed(struct cw1200_common *priv)
+{
+	++priv->debug->tx;
+}
+
+static inline void cw1200_debug_txed_agg(struct cw1200_common *priv)
+{
+	++priv->debug->tx_agg;
+}
+
+static inline void cw1200_debug_txed_multi(struct cw1200_common *priv,
+					   int count)
+{
+	++priv->debug->tx_multi;
+	priv->debug->tx_multi_frames += count;
+}
+
+static inline void cw1200_debug_rxed(struct cw1200_common *priv)
+{
+	++priv->debug->rx;
+}
+
+static inline void cw1200_debug_rxed_agg(struct cw1200_common *priv)
+{
+	++priv->debug->rx_agg;
+}
+
+static inline void cw1200_debug_tx_cache_miss(struct cw1200_common *priv)
+{
+	++priv->debug->tx_cache_miss;
+}
+
+static inline void cw1200_debug_tx_align(struct cw1200_common *priv)
+{
+	++priv->debug->tx_align;
+}
+
+static inline void cw1200_debug_tx_ttl(struct cw1200_common *priv)
+{
+	++priv->debug->tx_ttl;
+}
+
+static inline void cw1200_debug_tx_burst(struct cw1200_common *priv)
+{
+	++priv->debug->tx_burst;
+}
+
+static inline void cw1200_debug_ba(struct cw1200_common *priv,
+				   int ba_cnt, int ba_acc,
+				   int ba_cnt_rx, int ba_acc_rx)
+{
+	priv->debug->ba_cnt = ba_cnt;
+	priv->debug->ba_acc = ba_acc;
+	priv->debug->ba_cnt_rx = ba_cnt_rx;
+	priv->debug->ba_acc_rx = ba_acc_rx;
+}
+
+#endif /* CW1200_DEBUG_H_INCLUDED */
diff --git a/drivers/net/wireless/cw1200/itp.c b/drivers/net/wireless/cw1200/itp.c
new file mode 100644
index 0000000..7be3509
--- /dev/null
+++ b/drivers/net/wireless/cw1200/itp.c
@@ -0,0 +1,738 @@
+/*
+ * mac80211 glue code for mac80211 ST-Ericsson CW1200 drivers
+ * ITP code
+ *
+ * Copyright (c) 2010, ST-Ericsson
+ * Author: Dmitry Tarnyagin <dmitry.tarnyagin@lockless.no>
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License version 2 as
+ * published by the Free Software Foundation.
+ */
+
+#include <linux/module.h>
+#include <linux/debugfs.h>
+#include <linux/poll.h>
+#include <linux/time.h>
+#include <linux/kallsyms.h>
+#include <net/mac80211.h>
+#include "cw1200.h"
+#include "debug.h"
+#include "itp.h"
+#include "sta.h"
+
+static int __cw1200_itp_open(struct cw1200_common *priv);
+static int __cw1200_itp_close(struct cw1200_common *priv);
+static void cw1200_itp_rx_start(struct cw1200_common *priv);
+static void cw1200_itp_rx_stop(struct cw1200_common *priv);
+static void cw1200_itp_rx_stats(struct cw1200_common *priv);
+static void cw1200_itp_rx_reset(struct cw1200_common *priv);
+static void cw1200_itp_tx_stop(struct cw1200_common *priv);
+static void cw1200_itp_handle(struct cw1200_common *priv,
+			      struct sk_buff *skb);
+static void cw1200_itp_err(struct cw1200_common *priv,
+			   int err,
+			   int arg);
+static void __cw1200_itp_tx_stop(struct cw1200_common *priv);
+
+static ssize_t cw1200_itp_read(struct file *file,
+	char __user *user_buf, size_t count, loff_t *ppos)
+{
+	struct cw1200_common *priv = file->private_data;
+	struct cw1200_itp *itp = &priv->debug->itp;
+	struct sk_buff *skb;
+	int ret;
+
+	if (skb_queue_empty(&itp->log_queue))
+		return 0;
+
+	skb = skb_dequeue(&itp->log_queue);
+	ret = copy_to_user(user_buf, skb->data, skb->len);
+	*ppos += skb->len;
+	skb->data[skb->len] = 0;
+	pr_debug("[ITP] >>> %s", skb->data);
+	consume_skb(skb);
+
+	return skb->len - ret;
+}
+
+static ssize_t cw1200_itp_write(struct file *file,
+	const char __user *user_buf, size_t count, loff_t *ppos)
+{
+	struct cw1200_common *priv = file->private_data;
+	struct sk_buff *skb;
+
+	if (!count || count > 1024)
+		return -EINVAL;
+	skb = dev_alloc_skb(count + 1);
+	if (!skb)
+		return -ENOMEM;
+	skb_trim(skb, 0);
+	skb_put(skb, count + 1);
+	if (copy_from_user(skb->data, user_buf, count)) {
+		kfree_skb(skb);
+		return -EFAULT;
+	}
+	skb->data[count] = 0;
+
+	cw1200_itp_handle(priv, skb);
+	consume_skb(skb);
+	return count;
+}
+
+static unsigned int cw1200_itp_poll(struct file *file, poll_table *wait)
+{
+	struct cw1200_common *priv = file->private_data;
+	struct cw1200_itp *itp = &priv->debug->itp;
+	unsigned int mask = 0;
+
+	poll_wait(file, &itp->read_wait, wait);
+
+	if (!skb_queue_empty(&itp->log_queue))
+		mask |= POLLIN | POLLRDNORM;
+
+	mask |= POLLOUT | POLLWRNORM;
+
+	return mask;
+}
+
+static int cw1200_itp_open(struct inode *inode, struct file *file)
+{
+	struct cw1200_common *priv = inode->i_private;
+	struct cw1200_itp *itp = &priv->debug->itp;
+	int ret = 0;
+
+	file->private_data = priv;
+	if (atomic_inc_return(&itp->open_count) == 1) {
+		ret = __cw1200_itp_open(priv);
+		if (ret && !atomic_dec_return(&itp->open_count))
+			__cw1200_itp_close(priv);
+	} else {
+		atomic_dec(&itp->open_count);
+		ret = -EBUSY;
+	}
+
+	return ret;
+}
+
+static int cw1200_itp_close(struct inode *inode, struct file *file)
+{
+	struct cw1200_common *priv = file->private_data;
+	struct cw1200_itp *itp = &priv->debug->itp;
+	if (!atomic_dec_return(&itp->open_count)) {
+		__cw1200_itp_close(priv);
+		wake_up(&itp->close_wait);
+	}
+	return 0;
+}
+
+static const struct file_operations fops_itp = {
+	.open = cw1200_itp_open,
+	.read = cw1200_itp_read,
+	.write = cw1200_itp_write,
+	.poll = cw1200_itp_poll,
+	.release = cw1200_itp_close,
+	.llseek = default_llseek,
+	.owner = THIS_MODULE,
+};
+
+static void cw1200_itp_fill_pattern(u8 *data, int size,
+		enum cw1200_itp_data_modes mode)
+{
+	u8 *p = data;
+
+	if (size <= 0)
+		return;
+
+	switch (mode) {
+	default:
+	case ITP_DATA_ZEROS:
+		memset(data, 0x0, size);
+		break;
+	case ITP_DATA_ONES:
+		memset(data, 0xff, size);
+		break;
+	case ITP_DATA_ZERONES:
+		memset(data, 0x55, size);
+		break;
+	case ITP_DATA_RANDOM:
+		while (p < data+size-sizeof(u32)) {
+			(*(u32 *)p) = random32();
+			p += sizeof(u32);
+		}
+		while (p < data+size) {
+			(*p) = random32() & 0xFF;
+			p++;
+		}
+		break;
+	}
+	return;
+}
+
+static void cw1200_itp_tx_work(struct work_struct *work)
+{
+	struct cw1200_itp *itp = container_of(work, struct cw1200_itp,
+		    tx_work.work);
+	struct cw1200_common *priv = itp->priv;
+	atomic_set(&priv->bh_tx, 1);
+	wake_up(&priv->bh_wq);
+}
+
+static void cw1200_itp_tx_finish(struct work_struct *work)
+{
+	struct cw1200_itp *itp = container_of(work, struct cw1200_itp,
+		    tx_finish.work);
+	__cw1200_itp_tx_stop(itp->priv);
+}
+
+int cw1200_itp_init(struct cw1200_common *priv)
+{
+	struct cw1200_itp *itp = &priv->debug->itp;
+
+	itp->priv = priv;
+	atomic_set(&itp->open_count, 0);
+	atomic_set(&itp->stop_tx, 0);
+	atomic_set(&itp->awaiting_confirm, 0);
+	skb_queue_head_init(&itp->log_queue);
+	spin_lock_init(&itp->tx_lock);
+	init_waitqueue_head(&itp->read_wait);
+	init_waitqueue_head(&itp->write_wait);
+	init_waitqueue_head(&itp->close_wait);
+	INIT_DELAYED_WORK(&itp->tx_work, cw1200_itp_tx_work);
+	INIT_DELAYED_WORK(&itp->tx_finish, cw1200_itp_tx_finish);
+	itp->data = NULL;
+	itp->hdr_len = WSM_TX_EXTRA_HEADROOM +
+			sizeof(struct ieee80211_hdr_3addr);
+
+	if (!debugfs_create_file("itp", S_IRUSR | S_IWUSR,
+				 priv->debug->debugfs_phy, priv, &fops_itp))
+		return -ENOMEM;
+
+	return 0;
+}
+
+void cw1200_itp_release(struct cw1200_common *priv)
+{
+	struct cw1200_itp *itp = &priv->debug->itp;
+
+	wait_event_interruptible(itp->close_wait,
+				 !atomic_read(&itp->open_count));
+
+	WARN_ON(atomic_read(&itp->open_count));
+
+	skb_queue_purge(&itp->log_queue);
+	cw1200_itp_tx_stop(priv);
+}
+
+static int __cw1200_itp_open(struct cw1200_common *priv)
+{
+	struct cw1200_itp *itp = &priv->debug->itp;
+
+	if (!priv->vif)
+		return -EINVAL;
+	if (priv->join_status)
+		return -EINVAL;
+	itp->saved_channel = priv->channel;
+	if (!priv->channel)
+		priv->channel = &priv->hw->wiphy->bands[IEEE80211_BAND_2GHZ]->channels[0];
+	wsm_set_bssid_filtering(priv, false);
+	cw1200_itp_rx_reset(priv);
+	return 0;
+}
+
+static int __cw1200_itp_close(struct cw1200_common *priv)
+{
+	struct cw1200_itp *itp = &priv->debug->itp;
+	if (atomic_read(&itp->test_mode) == TEST_MODE_RX_TEST)
+		cw1200_itp_rx_stop(priv);
+	cw1200_itp_tx_stop(priv);
+	cw1200_disable_listening(priv);
+	cw1200_update_filtering(priv);
+	priv->channel = itp->saved_channel;
+	return 0;
+}
+
+bool cw1200_is_itp(struct cw1200_common *priv)
+{
+	struct cw1200_itp *itp = &priv->debug->itp;
+	return atomic_read(&itp->open_count) != 0;
+}
+
+static void cw1200_itp_rx_reset(struct cw1200_common *priv)
+{
+	struct cw1200_itp *itp = &priv->debug->itp;
+	itp->rx_cnt = 0;
+	itp->rx_rssi = 0;
+	itp->rx_rssi_max = -1000;
+	itp->rx_rssi_min = 1000;
+}
+
+static void cw1200_itp_rx_start(struct cw1200_common *priv)
+{
+	struct cw1200_itp *itp = &priv->debug->itp;
+
+	pr_debug("[ITP] RX start, band = %d, ch = %d\n",
+		 itp->band, itp->ch);
+	atomic_set(&itp->test_mode, TEST_MODE_RX_TEST);
+	cw1200_update_listening(priv, false);
+	priv->channel = &priv->hw->
+		wiphy->bands[itp->band]->channels[itp->ch];
+	cw1200_update_listening(priv, true);
+	wsm_set_bssid_filtering(priv, false);
+}
+
+static void cw1200_itp_rx_stop(struct cw1200_common *priv)
+{
+	struct cw1200_itp *itp = &priv->debug->itp;
+	pr_debug("[ITP] RX stop\n");
+	atomic_set(&itp->test_mode, TEST_MODE_NO_TEST);
+	cw1200_itp_rx_reset(priv);
+}
+
+static void cw1200_itp_rx_stats(struct cw1200_common *priv)
+{
+	struct cw1200_itp *itp = &priv->debug->itp;
+	struct sk_buff *skb;
+	char buf[128];
+	int len, ret;
+	struct wsm_mib_counters_table counters;
+
+	ret = wsm_get_counters_table(priv, &counters);
+
+	if (ret)
+		cw1200_itp_err(priv, -EBUSY, 20);
+
+	if (!itp->rx_cnt)
+		len = snprintf(buf, sizeof(buf), "1,0,0,0,0,%d\n",
+			       counters.rx_packet_errors);
+	else
+		len = snprintf(buf, sizeof(buf), "1,%d,%ld,%d,%d,%d\n",
+			       itp->rx_cnt,
+			       itp->rx_cnt ? itp->rx_rssi / itp->rx_cnt : 0,
+			       itp->rx_rssi_min, itp->rx_rssi_max,
+			       counters.rx_packet_errors);
+
+	if (len <= 0) {
+		cw1200_itp_err(priv, -EBUSY, 21);
+		return;
+	}
+
+	skb = dev_alloc_skb(len);
+	if (!skb) {
+		cw1200_itp_err(priv, -ENOMEM, 22);
+		return;
+	}
+
+	itp->rx_cnt = 0;
+	itp->rx_rssi = 0;
+	itp->rx_rssi_max = -1000;
+	itp->rx_rssi_min = 1000;
+
+	skb_trim(skb, 0);
+	skb_put(skb, len);
+
+	memcpy(skb->data, buf, len);
+	skb_queue_tail(&itp->log_queue, skb);
+	wake_up(&itp->read_wait);
+}
+
+static void cw1200_itp_tx_start(struct cw1200_common *priv)
+{
+	struct wsm_tx *tx;
+	struct ieee80211_hdr_3addr *hdr;
+	struct cw1200_itp *itp = &priv->debug->itp;
+	struct wsm_mib_association_mode assoc_mode = {
+		.flags = WSM_ASSOCIATION_MODE_USE_PREAMBLE_TYPE,
+		.preamble = itp->preamble,
+	};
+	int len;
+	u8 da_addr[6] = ITP_DEFAULT_DA_ADDR;
+
+	/* Rates index 4 and 5 are not supported */
+	if (itp->rate > 3)
+		itp->rate += 2;
+
+	pr_debug("[ITP] TX start: band = %d, ch = %d, rate = %d, preamble = %d, number = %d, data_mode = %d, interval = %d, power = %d, data_len = %d\n",
+		 itp->band, itp->ch, itp->rate, itp->preamble,
+		 itp->number, itp->data_mode, itp->interval_us,
+		 itp->power, itp->data_len);
+
+	len = itp->hdr_len + itp->data_len;
+
+	itp->data = kmalloc(len, GFP_KERNEL);
+	tx = (struct wsm_tx *)itp->data;
+	tx->hdr.len = itp->data_len + itp->hdr_len;
+	tx->hdr.id = __cpu_to_le16(0x0004 | 1 << 6);
+	tx->max_tx_rate = itp->rate;
+	tx->queue_id = 3;
+	tx->more = 0;
+	tx->flags = 0xc;
+	tx->packet_id = 0x55ff55;
+	tx->reserved = 0;
+	tx->expire_time = 1;
+
+	if (itp->preamble == ITP_PREAMBLE_GREENFIELD)
+		tx->ht_tx_parameters = WSM_HT_TX_GREENFIELD;
+	else if (itp->preamble == ITP_PREAMBLE_MIXED)
+		tx->ht_tx_parameters = WSM_HT_TX_MIXED;
+
+	hdr = (struct ieee80211_hdr_3addr *)&itp->data[sizeof(struct wsm_tx)];
+	memset(hdr, 0, sizeof(*hdr));
+	hdr->frame_control = cpu_to_le16(IEEE80211_FTYPE_DATA |	IEEE80211_FCTL_TODS);
+	memcpy(hdr->addr1, da_addr, ETH_ALEN);
+	memcpy(hdr->addr2, priv->vif->addr, ETH_ALEN);
+	memcpy(hdr->addr3, da_addr, ETH_ALEN);
+
+	cw1200_itp_fill_pattern(&itp->data[itp->hdr_len],
+				itp->data_len, itp->data_mode);
+
+	cw1200_update_listening(priv, false);
+	priv->channel = &priv->hw->wiphy->bands[itp->band]->channels[itp->ch];
+	WARN_ON(wsm_set_output_power(priv, itp->power));
+	if (itp->preamble == ITP_PREAMBLE_SHORT ||
+	    itp->preamble == ITP_PREAMBLE_LONG)
+		WARN_ON(wsm_set_association_mode(priv,
+						 &assoc_mode));
+	wsm_set_bssid_filtering(priv, false);
+	cw1200_update_listening(priv, true);
+
+	spin_lock_bh(&itp->tx_lock);
+	atomic_set(&itp->test_mode, TEST_MODE_TX_TEST);
+	atomic_set(&itp->awaiting_confirm, 0);
+	atomic_set(&itp->stop_tx, 0);
+	atomic_set(&priv->bh_tx, 1);
+	ktime_get_ts(&itp->last_sent);
+	wake_up(&priv->bh_wq);
+	spin_unlock_bh(&itp->tx_lock);
+}
+
+void __cw1200_itp_tx_stop(struct cw1200_common *priv)
+{
+	struct cw1200_itp *itp = &priv->debug->itp;
+	spin_lock_bh(&itp->tx_lock);
+	kfree(itp->data);
+	itp->data = NULL;
+	atomic_set(&itp->test_mode, TEST_MODE_NO_TEST);
+	spin_unlock_bh(&itp->tx_lock);
+}
+
+static void cw1200_itp_tx_stop(struct cw1200_common *priv)
+{
+	struct cw1200_itp *itp = &priv->debug->itp;
+	pr_debug("[ITP] TX stop\n");
+	atomic_set(&itp->stop_tx, 1);
+	flush_workqueue(priv->workqueue);
+
+	/* time for FW to confirm all tx requests */
+	msleep(500);
+
+	__cw1200_itp_tx_stop(priv);
+}
+
+static int cw1200_print_fw_version(struct cw1200_common *priv,
+				   u8 *buf, size_t len)
+{
+	return snprintf(buf, len, "%s %d.%d",
+			cw1200_fw_types[priv->wsm_caps.fw_type],
+			priv->wsm_caps.fw_ver,
+			priv->wsm_caps.fw_build);
+}
+
+static void cw1200_itp_get_version(struct cw1200_common *priv,
+		enum cw1200_itp_version_type type)
+{
+	struct cw1200_itp *itp = &priv->debug->itp;
+	struct sk_buff *skb;
+	char buf[ITP_BUF_SIZE];
+	size_t size = 0;
+	int len;
+	pr_debug("[ITP] print %s version\n",
+		 type == ITP_CHIP_ID ? "chip" : "firmware");
+
+	len = snprintf(buf, ITP_BUF_SIZE, "2,");
+	if (len <= 0) {
+		cw1200_itp_err(priv, -EINVAL, 40);
+		return;
+	}
+	size += len;
+
+	switch (type) {
+	case ITP_CHIP_ID:
+		len = cw1200_print_fw_version(priv, buf+size,
+				ITP_BUF_SIZE - size);
+
+		if (len <= 0) {
+			cw1200_itp_err(priv, -EINVAL, 41);
+			return;
+		}
+		size += len;
+		break;
+	case ITP_FW_VER:
+		len = snprintf(buf+size, ITP_BUF_SIZE - size,
+				"%d.%d", priv->wsm_caps.hw_id,
+				priv->wsm_caps.hw_subid);
+		if (len <= 0) {
+			cw1200_itp_err(priv, -EINVAL, 42);
+			return;
+		}
+		size += len;
+		break;
+	default:
+		cw1200_itp_err(priv, -EINVAL, 43);
+		break;
+	}
+
+	len = snprintf(buf+size, ITP_BUF_SIZE-size, "\n");
+	if (len <= 0) {
+		cw1200_itp_err(priv, -EINVAL, 44);
+		return;
+	}
+	size += len;
+
+	skb = dev_alloc_skb(size);
+	if (!skb) {
+		cw1200_itp_err(priv, -ENOMEM, 45);
+		return;
+	}
+
+	skb_trim(skb, 0);
+	skb_put(skb, size);
+
+	memcpy(skb->data, buf, size);
+	skb_queue_tail(&itp->log_queue, skb);
+	wake_up(&itp->read_wait);
+}
+
+int cw1200_itp_get_tx(struct cw1200_common *priv, u8 **data,
+		size_t *tx_len, int *burst)
+{
+	struct cw1200_itp *itp;
+	struct timespec now;
+	int time_left_us;
+
+	if (!priv->debug)
+		return 0;
+
+	itp	= &priv->debug->itp;
+
+	if (!itp)
+		return 0;
+
+	spin_lock_bh(&itp->tx_lock);
+	if (atomic_read(&itp->test_mode) != TEST_MODE_TX_TEST)
+		goto out;
+
+	if (atomic_read(&itp->stop_tx))
+		goto out;
+
+	if (itp->number == 0) {
+		atomic_set(&itp->stop_tx, 1);
+		queue_delayed_work(priv->workqueue, &itp->tx_finish, HZ/10);
+		goto out;
+	}
+
+	if (!itp->data)
+		goto out;
+
+	if (priv->hw_bufs_used >= 2) {
+		if (!atomic_read(&priv->bh_rx))
+			atomic_set(&priv->bh_rx, 1);
+		atomic_set(&priv->bh_tx, 1);
+		goto out;
+	}
+
+	ktime_get_ts(&now);
+	time_left_us = (itp->last_sent.tv_sec -	now.tv_sec)*1000000 +
+		(itp->last_sent.tv_nsec - now.tv_nsec)/1000 +
+		itp->interval_us;
+
+	if (time_left_us > ITP_TIME_THRES_US) {
+		queue_delayed_work(priv->workqueue, &itp->tx_work,
+				   ITP_US_TO_MS(time_left_us)*HZ/1000);
+		goto out;
+	}
+
+	if (time_left_us > 50)
+		udelay(time_left_us);
+
+	if (itp->number > 0)
+		itp->number--;
+
+	*data = itp->data;
+	*tx_len = itp->data_len + itp->hdr_len;
+
+	if (itp->data_mode == ITP_DATA_RANDOM)
+		cw1200_itp_fill_pattern(&itp->data[itp->hdr_len],
+					itp->data_len, itp->data_mode);
+	*burst = 2;
+	atomic_set(&priv->bh_tx, 1);
+	ktime_get_ts(&itp->last_sent);
+	atomic_add(1, &itp->awaiting_confirm);
+	spin_unlock_bh(&itp->tx_lock);
+	return 1;
+
+out:
+	spin_unlock_bh(&itp->tx_lock);
+	return 0;
+}
+
+bool cw1200_itp_rxed(struct cw1200_common *priv, struct sk_buff *skb)
+{
+	struct cw1200_itp *itp = &priv->debug->itp;
+	struct ieee80211_rx_status *rx = IEEE80211_SKB_RXCB(skb);
+	int signal;
+
+	if (atomic_read(&itp->test_mode) != TEST_MODE_RX_TEST)
+		return cw1200_is_itp(priv);
+	if (rx->freq != priv->channel->center_freq)
+		return true;
+
+	signal = rx->signal;
+	itp->rx_cnt++;
+	itp->rx_rssi += signal;
+	if (itp->rx_rssi_min > rx->signal)
+		itp->rx_rssi_min = rx->signal;
+	if (itp->rx_rssi_max < rx->signal)
+		itp->rx_rssi_max = rx->signal;
+
+	return true;
+}
+
+void cw1200_itp_wake_up_tx(struct cw1200_common *priv)
+{
+	wake_up(&priv->debug->itp.write_wait);
+}
+
+bool cw1200_itp_tx_running(struct cw1200_common *priv)
+{
+	if (atomic_read(&priv->debug->itp.awaiting_confirm) ||
+	    atomic_read(&priv->debug->itp.test_mode) ==
+	    TEST_MODE_TX_TEST) {
+		atomic_sub(1, &priv->debug->itp.awaiting_confirm);
+		return true;
+	}
+	return false;
+}
+
+static void cw1200_itp_handle(struct cw1200_common *priv,
+			      struct sk_buff *skb)
+{
+	struct cw1200_itp *itp = &priv->debug->itp;
+	const struct wiphy *wiphy = priv->hw->wiphy;
+	int cmd;
+	int ret;
+
+	pr_debug("[ITP] <<< %s", skb->data);
+	if (sscanf(skb->data, "%d", &cmd) != 1) {
+		cw1200_itp_err(priv, -EINVAL, 1);
+		return;
+	}
+
+	switch (cmd) {
+	case 1: /* RX test */
+		if (atomic_read(&itp->test_mode)) {
+			cw1200_itp_err(priv, -EBUSY, 0);
+			return;
+		}
+		ret = sscanf(skb->data, "%d,%d,%d",
+				&cmd, &itp->band, &itp->ch);
+		if (ret != 3) {
+			cw1200_itp_err(priv, -EINVAL, ret + 1);
+			return;
+		}
+		if (itp->band >= 2) {
+			cw1200_itp_err(priv, -EINVAL, 2);
+		} else if (!wiphy->bands[itp->band]) {
+			cw1200_itp_err(priv, -EINVAL, 2);
+		} else if (itp->ch >= wiphy->bands[itp->band]->n_channels) {
+			cw1200_itp_err(priv, -EINVAL, 3);
+		} else {
+			cw1200_itp_rx_stats(priv);
+			cw1200_itp_rx_start(priv);
+		}
+		break;
+	case 2: /* RX stat */
+		cw1200_itp_rx_stats(priv);
+		break;
+	case 3: /* RX/TX stop */
+		if (atomic_read(&itp->test_mode) == TEST_MODE_RX_TEST) {
+			cw1200_itp_rx_stats(priv);
+			cw1200_itp_rx_stop(priv);
+		} else if (atomic_read(&itp->test_mode) == TEST_MODE_TX_TEST) {
+			cw1200_itp_tx_stop(priv);
+		} else {
+			cw1200_itp_err(priv, -EBUSY, 0);
+		}
+		break;
+	case 4: /* TX start */
+		if (atomic_read(&itp->test_mode) != TEST_MODE_NO_TEST) {
+			cw1200_itp_err(priv, -EBUSY, 0);
+			return;
+		}
+		ret = sscanf(skb->data, "%d,%d,%d,%d,%d,%d,%d,%d,%d,%d",
+				&cmd, &itp->band, &itp->ch, &itp->rate,
+				&itp->preamble, &itp->number, &itp->data_mode,
+				&itp->interval_us, &itp->power, &itp->data_len);
+		if (ret != 10) {
+			cw1200_itp_err(priv, -EINVAL, ret + 1);
+			return;
+		}
+		if (itp->band >= 2) {
+			cw1200_itp_err(priv, -EINVAL, 2);
+		} else if (!wiphy->bands[itp->band]) {
+			cw1200_itp_err(priv, -EINVAL, 2);
+		} else if (itp->ch >= wiphy->bands[itp->band]->n_channels) {
+			cw1200_itp_err(priv, -EINVAL, 3);
+		} else if (itp->rate >= 20) {
+			cw1200_itp_err(priv, -EINVAL, 4);
+		} else if (itp->preamble >= ITP_PREAMBLE_MAX) {
+			cw1200_itp_err(priv, -EINVAL, 5);
+		} else if (itp->data_mode >= ITP_DATA_MAX_MODE) {
+			cw1200_itp_err(priv, -EINVAL, 7);
+		} else if (itp->data_len < ITP_MIN_DATA_SIZE ||
+			   itp->data_len > (priv->wsm_caps.input_buffer_size - itp->hdr_len)) {
+			cw1200_itp_err(priv, -EINVAL, 8);
+		} else {
+		    cw1200_itp_tx_start(priv);
+		}
+		break;
+	case 5:
+		cw1200_itp_get_version(priv, ITP_CHIP_ID);
+		break;
+	case 6:
+		cw1200_itp_get_version(priv, ITP_FW_VER);
+		break;
+	}
+}
+
+static void cw1200_itp_err(struct cw1200_common *priv,
+			   int err, int arg)
+{
+	struct cw1200_itp *itp = &priv->debug->itp;
+	struct sk_buff *skb;
+	static char buf[255];
+	int len;
+
+	len = snprintf(buf, sizeof(buf), "%d,%d\n",
+		err, arg);
+	if (len <= 0)
+		return;
+
+	skb = dev_alloc_skb(len);
+	if (!skb)
+		return;
+
+	skb_trim(skb, 0);
+	skb_put(skb, len);
+
+	memcpy(skb->data, buf, len);
+	skb_queue_tail(&itp->log_queue, skb);
+	wake_up(&itp->read_wait);
+
+	len = sprint_symbol(buf,
+			(unsigned long)__builtin_return_address(0));
+	if (len <= 0)
+		return;
+	pr_debug("[ITP] error %d,%d from %s\n",
+		 err, arg, buf);
+}
diff --git a/drivers/net/wireless/cw1200/itp.h b/drivers/net/wireless/cw1200/itp.h
new file mode 100644
index 0000000..1e9dfb7
--- /dev/null
+++ b/drivers/net/wireless/cw1200/itp.h
@@ -0,0 +1,144 @@
+/*
+ * ITP code for ST-Ericsson CW1200 mac80211 driver
+ *
+ * Copyright (c) 2011, ST-Ericsson
+ * Author: Dmitry Tarnyagin <dmitry.tarnyagin@lockless.no>
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License version 2 as
+ * published by the Free Software Foundation.
+ */
+
+#ifndef CW1200_ITP_H_INCLUDED
+#define CW1200_ITP_H_INCLUDED
+
+struct cw200_common;
+struct wsm_tx_confirm;
+struct dentry;
+
+#ifdef CONFIG_CW1200_ITP
+
+/*extern*/ struct ieee80211_channel;
+
+#define TEST_MODE_NO_TEST	(0)
+#define TEST_MODE_RX_TEST	(1)
+#define TEST_MODE_TX_TEST	(2)
+#define ITP_DEFAULT_DA_ADDR {0xff, 0xff, 0xff, 0xff, 0xff, 0xff}
+#define ITP_MIN_DATA_SIZE 6
+#define ITP_MAX_DATA_SIZE 1600
+#define ITP_TIME_THRES_US 10000
+#define ITP_US_TO_MS(x) ((x)/1000)
+#define ITP_MS_TO_US(x) ((x)*1000)
+#define ITP_BUF_SIZE 255
+
+
+enum cw1200_itp_data_modes {
+	ITP_DATA_ZEROS,
+	ITP_DATA_ONES,
+	ITP_DATA_ZERONES,
+	ITP_DATA_RANDOM,
+	ITP_DATA_MAX_MODE,
+};
+
+enum cw1200_itp_version_type {
+	ITP_CHIP_ID,
+	ITP_FW_VER,
+};
+
+enum cw1200_itp_preamble_type {
+	ITP_PREAMBLE_LONG,
+	ITP_PREAMBLE_SHORT,
+	ITP_PREAMBLE_OFDM,
+	ITP_PREAMBLE_MIXED,
+	ITP_PREAMBLE_GREENFIELD,
+	ITP_PREAMBLE_MAX,
+};
+
+
+struct cw1200_itp {
+	struct cw1200_common	*priv;
+	atomic_t		open_count;
+	atomic_t		awaiting_confirm;
+	struct sk_buff_head	log_queue;
+	wait_queue_head_t	read_wait;
+	wait_queue_head_t	write_wait;
+	wait_queue_head_t	close_wait;
+	struct ieee80211_channel *saved_channel;
+	atomic_t		stop_tx;
+	struct delayed_work	tx_work;
+	struct delayed_work	tx_finish;
+	spinlock_t		tx_lock;
+	struct timespec		last_sent;
+	atomic_t		test_mode;
+	int			rx_cnt;
+	long			rx_rssi;
+	int			rx_rssi_max;
+	int			rx_rssi_min;
+	unsigned		band;
+	unsigned		ch;
+	unsigned		rate;
+	unsigned		preamble;
+	unsigned int		number;
+	unsigned		data_mode;
+	int			interval_us;
+	int			power;
+	u8			*data;
+	int			hdr_len;
+	int			data_len;
+};
+
+int cw1200_itp_init(struct cw1200_common *priv);
+void cw1200_itp_release(struct cw1200_common *priv);
+
+bool cw1200_is_itp(struct cw1200_common *priv);
+bool cw1200_itp_rxed(struct cw1200_common *priv, struct sk_buff *skb);
+void cw1200_itp_wake_up_tx(struct cw1200_common *priv);
+int cw1200_itp_get_tx(struct cw1200_common *priv, u8 **data,
+		size_t *tx_len, int *burst);
+bool cw1200_itp_tx_running(struct cw1200_common *priv);
+
+#else /* CONFIG_CW1200_ITP */
+
+static inline int cw1200_itp_init(struct cw1200_common *priv)
+{
+	return 0;
+}
+
+static inline void cw1200_itp_release(struct cw1200_common *priv)
+{
+}
+
+static inline bool cw1200_is_itp(struct cw1200_common *priv)
+{
+	return false;
+}
+
+static inline bool cw1200_itp_rxed(struct cw1200_common *priv,
+				   struct sk_buff *skb)
+{
+	return false;
+}
+
+
+static inline void cw1200_itp_consume_txed(struct cw1200_common *priv)
+{
+}
+
+static inline void cw1200_itp_wake_up_tx(struct cw1200_common *priv)
+{
+}
+
+static inline int cw1200_itp_get_tx(struct cw1200_common *priv, u8 **data,
+				    size_t *tx_len, int *burst)
+{
+	return 0;
+}
+
+static inline bool cw1200_itp_tx_running(struct cw1200_common *priv)
+{
+	return false;
+}
+
+#endif /* CONFIG_CW1200_ITP */
+
+#endif /* CW1200_ITP_H_INCLUDED */
-- 
1.8.1.4

