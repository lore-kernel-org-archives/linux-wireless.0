Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wolverine02.qualcomm.com ([199.106.114.251]:3064 "EHLO
	wolverine02.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751275AbbIRH6z (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 18 Sep 2015 03:58:55 -0400
Subject: [PATCH 2/2] ath10k: implement debugfs interface for Transmit Power
 Control stats
To: <ath10k@lists.infradead.org>
From: Kalle Valo <kvalo@qca.qualcomm.com>
CC: <linux-wireless@vger.kernel.org>
Date: Fri, 18 Sep 2015 10:58:47 +0300
Message-ID: <20150918075847.6983.4585.stgit@potku.adurom.net> (sfid-20150918_095859_063551_CD1677AC)
In-Reply-To: <20150918075706.6983.11216.stgit@potku.adurom.net>
References: <20150918075706.6983.11216.stgit@potku.adurom.net>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Maharaja Kennadyrajan <c_mkenna@qti.qualcomm.com>

The Transmit Power Control (TPC) dump will show the power control values for
each rate which makes it easier to debug calibration problems.

Example usage:

# cat /sys/kernel/debug/ieee80211/phy0/ath10k/tpc_stats
TPC config for channel  5180  mode  10

CTL             = 0x10 Reg. Domain              = 58
Antenna Gain    = 1    Reg. Max Antenna Gain    = 0
Power Limit     = 34   Reg. Max Power           = 34
Num tx chains   = 3    Num supported rates      = 155

**********CDD POWER TABLE*******

No.  Preamble Rate_code tpc_valu1 tpc_value2 tpc_value3
0       CCK     0x40       0            0       0
1       CCk     0x41       0            0       0

[...]

154     HTCUP   0x 0       24           0       0
**********STBC POWER TABLE******
No.  Preamble Rate_code tpc_valu1 tpc_value2 tpc_value3
0       CCK     0x40       0            0       0

[...]

154     HTCUP   0x 0       24           24      0
**********TXBF POWER TABLE******

is used to dump the tx power control stats.

Signed-off-by: Maharaja Kennadyrajan <c_mkenna@qti.qualcomm.com>
Signed-off-by: Kalle Valo <kvalo@qca.qualcomm.com>
---
 drivers/net/wireless/ath/ath10k/core.h    |   29 +++
 drivers/net/wireless/ath/ath10k/debug.c   |  233 +++++++++++++++++++++++++
 drivers/net/wireless/ath/ath10k/debug.h   |    8 +
 drivers/net/wireless/ath/ath10k/wmi-ops.h |   19 ++
 drivers/net/wireless/ath/ath10k/wmi.c     |  269 +++++++++++++++++++++++++++++
 drivers/net/wireless/ath/ath10k/wmi.h     |   15 ++
 6 files changed, 572 insertions(+), 1 deletion(-)

diff --git a/drivers/net/wireless/ath/ath10k/core.h b/drivers/net/wireless/ath/ath10k/core.h
index 04e040a06cb1..002de7113e63 100644
--- a/drivers/net/wireless/ath/ath10k/core.h
+++ b/drivers/net/wireless/ath/ath10k/core.h
@@ -250,6 +250,30 @@ struct ath10k_fw_stats {
 	struct list_head peers;
 };
 
+#define ATH10K_TPC_TABLE_TYPE_FLAG	1
+#define ATH10K_TPC_PREAM_TABLE_END	0xFFFF
+
+struct ath10k_tpc_table {
+	u32 pream_idx[WMI_TPC_RATE_MAX];
+	u8 rate_code[WMI_TPC_RATE_MAX];
+	char tpc_value[WMI_TPC_RATE_MAX][WMI_TPC_TX_N_CHAIN * WMI_TPC_BUF_SIZE];
+};
+
+struct ath10k_tpc_stats {
+	u32 reg_domain;
+	u32 chan_freq;
+	u32 phy_mode;
+	u32 twice_antenna_reduction;
+	u32 twice_max_rd_power;
+	s32 twice_antenna_gain;
+	u32 power_limit;
+	u32 num_tx_chain;
+	u32 ctl;
+	u32 rate_max;
+	u8 flag[WMI_TPC_FLAG];
+	struct ath10k_tpc_table tpc_table[WMI_TPC_FLAG];
+};
+
 struct ath10k_dfs_stats {
 	u32 phy_errors;
 	u32 pulses_total;
@@ -378,6 +402,11 @@ struct ath10k_debug {
 	struct ath10k_dfs_stats dfs_stats;
 	struct ath_dfs_pool_stats dfs_pool_stats;
 
+	/* used for tpc-dump storage, protected by data-lock */
+	struct ath10k_tpc_stats *tpc_stats;
+
+	struct completion tpc_complete;
+
 	/* protected by conf_mutex */
 	u32 fw_dbglog_mask;
 	u32 fw_dbglog_level;
diff --git a/drivers/net/wireless/ath/ath10k/debug.c b/drivers/net/wireless/ath/ath10k/debug.c
index bf033f46f8aa..f316efdbd6c3 100644
--- a/drivers/net/wireless/ath/ath10k/debug.c
+++ b/drivers/net/wireless/ath/ath10k/debug.c
@@ -1843,6 +1843,233 @@ static const struct file_operations fops_nf_cal_period = {
 	.llseek = default_llseek,
 };
 
+#define ATH10K_TPC_CONFIG_BUF_SIZE	(1024 * 1024)
+
+static int ath10k_debug_tpc_stats_request(struct ath10k *ar)
+{
+	int ret;
+	unsigned long time_left;
+
+	lockdep_assert_held(&ar->conf_mutex);
+
+	reinit_completion(&ar->debug.tpc_complete);
+
+	ret = ath10k_wmi_pdev_get_tpc_config(ar, WMI_TPC_CONFIG_PARAM);
+	if (ret) {
+		ath10k_warn(ar, "failed to request tpc config: %d\n", ret);
+		return ret;
+	}
+
+	time_left = wait_for_completion_timeout(&ar->debug.tpc_complete,
+						1 * HZ);
+	if (time_left == 0)
+		return -ETIMEDOUT;
+
+	return 0;
+}
+
+void ath10k_debug_tpc_stats_process(struct ath10k *ar,
+				    struct ath10k_tpc_stats *tpc_stats)
+{
+	spin_lock_bh(&ar->data_lock);
+
+	kfree(ar->debug.tpc_stats);
+	ar->debug.tpc_stats = tpc_stats;
+	complete(&ar->debug.tpc_complete);
+
+	spin_unlock_bh(&ar->data_lock);
+}
+
+static void ath10k_tpc_stats_print(struct ath10k_tpc_stats *tpc_stats,
+				   unsigned int j, char *buf, unsigned int *len)
+{
+	unsigned int i, buf_len;
+	static const char table_str[][5] = { "CDD",
+					     "STBC",
+					     "TXBF" };
+	static const char pream_str[][6] = { "CCK",
+					     "OFDM",
+					     "HT20",
+					     "HT40",
+					     "VHT20",
+					     "VHT40",
+					     "VHT80",
+					     "HTCUP" };
+
+	buf_len = ATH10K_TPC_CONFIG_BUF_SIZE;
+	*len += scnprintf(buf + *len, buf_len - *len,
+			  "********************************\n");
+	*len += scnprintf(buf + *len, buf_len - *len,
+			  "******************* %s POWER TABLE ****************\n",
+			  table_str[j]);
+	*len += scnprintf(buf + *len, buf_len - *len,
+			  "********************************\n");
+	*len += scnprintf(buf + *len, buf_len - *len,
+			  "No.  Preamble Rate_code tpc_value1 tpc_value2 tpc_value3\n");
+
+	for (i = 0; i < tpc_stats->rate_max; i++) {
+		*len += scnprintf(buf + *len, buf_len - *len,
+				  "%8d %s 0x%2x %s\n", i,
+				  pream_str[tpc_stats->tpc_table[j].pream_idx[i]],
+				  tpc_stats->tpc_table[j].rate_code[i],
+				  tpc_stats->tpc_table[j].tpc_value[i]);
+	}
+
+	*len += scnprintf(buf + *len, buf_len - *len,
+			  "***********************************\n");
+}
+
+static void ath10k_tpc_stats_fill(struct ath10k *ar,
+				  struct ath10k_tpc_stats *tpc_stats,
+				  char *buf)
+{
+	unsigned int len, j, buf_len;
+
+	len = 0;
+	buf_len = ATH10K_TPC_CONFIG_BUF_SIZE;
+
+	spin_lock_bh(&ar->data_lock);
+
+	if (!tpc_stats) {
+		ath10k_warn(ar, "failed to get tpc stats\n");
+		goto unlock;
+	}
+
+	len += scnprintf(buf + len, buf_len - len, "\n");
+	len += scnprintf(buf + len, buf_len - len,
+			 "*************************************\n");
+	len += scnprintf(buf + len, buf_len - len,
+			 "TPC config for channel %4d mode %d\n",
+			 tpc_stats->chan_freq,
+			 tpc_stats->phy_mode);
+	len += scnprintf(buf + len, buf_len - len,
+			 "*************************************\n");
+	len += scnprintf(buf + len, buf_len - len,
+			 "CTL		=  0x%2x Reg. Domain		= %2d\n",
+			 tpc_stats->ctl,
+			 tpc_stats->reg_domain);
+	len += scnprintf(buf + len, buf_len - len,
+			 "Antenna Gain	= %2d Reg. Max Antenna Gain	=  %2d\n",
+			 tpc_stats->twice_antenna_gain,
+			 tpc_stats->twice_antenna_reduction);
+	len += scnprintf(buf + len, buf_len - len,
+			 "Power Limit	= %2d Reg. Max Power		= %2d\n",
+			 tpc_stats->power_limit,
+			 tpc_stats->twice_max_rd_power / 2);
+	len += scnprintf(buf + len, buf_len - len,
+			 "Num tx chains	= %2d Num supported rates	= %2d\n",
+			 tpc_stats->num_tx_chain,
+			 tpc_stats->rate_max);
+
+	for (j = 0; j < tpc_stats->num_tx_chain ; j++) {
+		switch (j) {
+		case WMI_TPC_TABLE_TYPE_CDD:
+			if (tpc_stats->flag[j] == ATH10K_TPC_TABLE_TYPE_FLAG) {
+				len += scnprintf(buf + len, buf_len - len,
+						 "CDD not supported\n");
+				break;
+			}
+
+			ath10k_tpc_stats_print(tpc_stats, j, buf, &len);
+			break;
+		case WMI_TPC_TABLE_TYPE_STBC:
+			if (tpc_stats->flag[j] == ATH10K_TPC_TABLE_TYPE_FLAG) {
+				len += scnprintf(buf + len, buf_len - len,
+						 "STBC not supported\n");
+				break;
+			}
+
+			ath10k_tpc_stats_print(tpc_stats, j, buf, &len);
+			break;
+		case WMI_TPC_TABLE_TYPE_TXBF:
+			if (tpc_stats->flag[j] == ATH10K_TPC_TABLE_TYPE_FLAG) {
+				len += scnprintf(buf + len, buf_len - len,
+						 "TXBF not supported\n***************************\n");
+				break;
+			}
+
+			ath10k_tpc_stats_print(tpc_stats, j, buf, &len);
+			break;
+		default:
+			len += scnprintf(buf + len, buf_len - len,
+					 "Invalid Type\n");
+			break;
+		}
+	}
+
+unlock:
+	spin_unlock_bh(&ar->data_lock);
+
+	if (len >= buf_len)
+		buf[len - 1] = 0;
+	else
+		buf[len] = 0;
+}
+
+static int ath10k_tpc_stats_open(struct inode *inode, struct file *file)
+{
+	struct ath10k *ar = inode->i_private;
+	void *buf = NULL;
+	int ret;
+
+	mutex_lock(&ar->conf_mutex);
+
+	if (ar->state != ATH10K_STATE_ON) {
+		ret = -ENETDOWN;
+		goto err_unlock;
+	}
+
+	buf = vmalloc(ATH10K_TPC_CONFIG_BUF_SIZE);
+	if (!buf) {
+		ret = -ENOMEM;
+		goto err_unlock;
+	}
+
+	ret = ath10k_debug_tpc_stats_request(ar);
+	if (ret) {
+		ath10k_warn(ar, "failed to request tpc config stats: %d\n",
+			    ret);
+		goto err_free;
+	}
+
+	ath10k_tpc_stats_fill(ar, ar->debug.tpc_stats, buf);
+	file->private_data = buf;
+
+	mutex_unlock(&ar->conf_mutex);
+	return 0;
+
+err_free:
+	vfree(buf);
+
+err_unlock:
+	mutex_unlock(&ar->conf_mutex);
+	return ret;
+}
+
+static int ath10k_tpc_stats_release(struct inode *inode, struct file *file)
+{
+	vfree(file->private_data);
+
+	return 0;
+}
+
+static ssize_t ath10k_tpc_stats_read(struct file *file, char __user *user_buf,
+				     size_t count, loff_t *ppos)
+{
+	const char *buf = file->private_data;
+	unsigned int len = strlen(buf);
+
+	return simple_read_from_buffer(user_buf, count, ppos, buf, len);
+}
+
+static const struct file_operations fops_tpc_stats = {
+	.open = ath10k_tpc_stats_open,
+	.release = ath10k_tpc_stats_release,
+	.read = ath10k_tpc_stats_read,
+	.owner = THIS_MODULE,
+	.llseek = default_llseek,
+};
+
 int ath10k_debug_start(struct ath10k *ar)
 {
 	int ret;
@@ -2111,6 +2338,8 @@ void ath10k_debug_destroy(struct ath10k *ar)
 	ar->debug.fw_crash_data = NULL;
 
 	ath10k_debug_fw_stats_reset(ar);
+
+	kfree(ar->debug.tpc_stats);
 }
 
 int ath10k_debug_register(struct ath10k *ar)
@@ -2127,6 +2356,7 @@ int ath10k_debug_register(struct ath10k *ar)
 	INIT_DELAYED_WORK(&ar->debug.htt_stats_dwork,
 			  ath10k_debug_htt_stats_dwork);
 
+	init_completion(&ar->debug.tpc_complete);
 	init_completion(&ar->debug.fw_stats_complete);
 
 	debugfs_create_file("fw_stats", S_IRUSR, ar->debug.debugfs_phy, ar,
@@ -2195,6 +2425,9 @@ int ath10k_debug_register(struct ath10k *ar)
 	debugfs_create_file("quiet_period", S_IRUGO | S_IWUSR,
 			    ar->debug.debugfs_phy, ar, &fops_quiet_period);
 
+	debugfs_create_file("tpc_stats", S_IRUSR,
+			    ar->debug.debugfs_phy, ar, &fops_tpc_stats);
+
 	return 0;
 }
 
diff --git a/drivers/net/wireless/ath/ath10k/debug.h b/drivers/net/wireless/ath/ath10k/debug.h
index 53bd6a19eab6..b07639e9b082 100644
--- a/drivers/net/wireless/ath/ath10k/debug.h
+++ b/drivers/net/wireless/ath/ath10k/debug.h
@@ -70,6 +70,8 @@ void ath10k_debug_destroy(struct ath10k *ar);
 int ath10k_debug_register(struct ath10k *ar);
 void ath10k_debug_unregister(struct ath10k *ar);
 void ath10k_debug_fw_stats_process(struct ath10k *ar, struct sk_buff *skb);
+void ath10k_debug_tpc_stats_process(struct ath10k *ar,
+				    struct ath10k_tpc_stats *tpc_stats);
 struct ath10k_fw_crash_data *
 ath10k_debug_get_new_fw_crash_data(struct ath10k *ar);
 
@@ -117,6 +119,12 @@ static inline void ath10k_debug_fw_stats_process(struct ath10k *ar,
 {
 }
 
+static inline void ath10k_debug_tpc_stats_process(struct ath10k *ar,
+						  struct ath10k_tpc_stats *tpc_stats)
+{
+	kfree(tpc_stats);
+}
+
 static inline void ath10k_debug_dbglog_add(struct ath10k *ar, u8 *buffer,
 					   int len)
 {
diff --git a/drivers/net/wireless/ath/ath10k/wmi-ops.h b/drivers/net/wireless/ath/ath10k/wmi-ops.h
index 248ffc3d6620..d3bc6df861e4 100644
--- a/drivers/net/wireless/ath/ath10k/wmi-ops.h
+++ b/drivers/net/wireless/ath/ath10k/wmi-ops.h
@@ -177,6 +177,8 @@ struct wmi_ops {
 						const struct wmi_tdls_peer_capab_arg *cap,
 						const struct wmi_channel_arg *chan);
 	struct sk_buff *(*gen_adaptive_qcs)(struct ath10k *ar, bool enable);
+	struct sk_buff *(*gen_pdev_get_tpc_config)(struct ath10k *ar,
+						   u32 param);
 };
 
 int ath10k_wmi_cmd_send(struct ath10k *ar, struct sk_buff *skb, u32 cmd_id);
@@ -1270,4 +1272,21 @@ ath10k_wmi_adaptive_qcs(struct ath10k *ar, bool enable)
 	return ath10k_wmi_cmd_send(ar, skb, ar->wmi.cmd->adaptive_qcs_cmdid);
 }
 
+static inline int
+ath10k_wmi_pdev_get_tpc_config(struct ath10k *ar, u32 param)
+{
+	struct sk_buff *skb;
+
+	if (!ar->wmi.ops->gen_pdev_get_tpc_config)
+		return -EOPNOTSUPP;
+
+	skb = ar->wmi.ops->gen_pdev_get_tpc_config(ar, param);
+
+	if (IS_ERR(skb))
+		return PTR_ERR(skb);
+
+	return ath10k_wmi_cmd_send(ar, skb,
+				   ar->wmi.cmd->pdev_get_tpc_config_cmdid);
+}
+
 #endif
diff --git a/drivers/net/wireless/ath/ath10k/wmi.c b/drivers/net/wireless/ath/ath10k/wmi.c
index 87d9de2aa8c5..b27ac3028525 100644
--- a/drivers/net/wireless/ath/ath10k/wmi.c
+++ b/drivers/net/wireless/ath/ath10k/wmi.c
@@ -3835,9 +3835,258 @@ void ath10k_wmi_event_dcs_interference(struct ath10k *ar, struct sk_buff *skb)
 	ath10k_dbg(ar, ATH10K_DBG_WMI, "WMI_DCS_INTERFERENCE_EVENTID\n");
 }
 
+static u8 ath10k_tpc_config_get_rate(struct ath10k *ar,
+				     struct wmi_pdev_tpc_config_event *ev,
+				     u32 rate_idx, u32 num_chains,
+				     u32 rate_code, u8 type)
+{
+	u8 tpc, num_streams, preamble, ch, stm_idx;
+
+	num_streams = ATH10K_HW_NSS(rate_code);
+	preamble = ATH10K_HW_PREAMBLE(rate_code);
+	ch = num_chains - 1;
+
+	tpc = min_t(u8, ev->rates_array[rate_idx], ev->max_reg_allow_pow[ch]);
+
+	if (__le32_to_cpu(ev->num_tx_chain) <= 1)
+		goto out;
+
+	if (preamble == WMI_RATE_PREAMBLE_CCK)
+		goto out;
+
+	stm_idx = num_streams - 1;
+	if (num_chains <= num_streams)
+		goto out;
+
+	switch (type) {
+	case WMI_TPC_TABLE_TYPE_STBC:
+		tpc = min_t(u8, tpc,
+			    ev->max_reg_allow_pow_agstbc[ch - 1][stm_idx]);
+		break;
+	case WMI_TPC_TABLE_TYPE_TXBF:
+		tpc = min_t(u8, tpc,
+			    ev->max_reg_allow_pow_agtxbf[ch - 1][stm_idx]);
+		break;
+	case WMI_TPC_TABLE_TYPE_CDD:
+		tpc = min_t(u8, tpc,
+			    ev->max_reg_allow_pow_agcdd[ch - 1][stm_idx]);
+		break;
+	default:
+		ath10k_warn(ar, "unknown wmi tpc table type: %d\n", type);
+		tpc = 0;
+		break;
+	}
+
+out:
+	return tpc;
+}
+
+static void ath10k_tpc_config_disp_tables(struct ath10k *ar,
+					  struct wmi_pdev_tpc_config_event *ev,
+					  struct ath10k_tpc_stats *tpc_stats,
+					  u8 *rate_code, u16 *pream_table, u8 type)
+{
+	u32 i, j, pream_idx, flags;
+	u8 tpc[WMI_TPC_TX_N_CHAIN];
+	char tpc_value[WMI_TPC_TX_N_CHAIN * WMI_TPC_BUF_SIZE];
+	char buff[WMI_TPC_BUF_SIZE];
+
+	flags = __le32_to_cpu(ev->flags);
+
+	switch (type) {
+	case WMI_TPC_TABLE_TYPE_CDD:
+		if (!(flags & WMI_TPC_CONFIG_EVENT_FLAG_TABLE_CDD)) {
+			ath10k_dbg(ar, ATH10K_DBG_WMI, "CDD not supported\n");
+			tpc_stats->flag[type] = ATH10K_TPC_TABLE_TYPE_FLAG;
+			return;
+		}
+		break;
+	case WMI_TPC_TABLE_TYPE_STBC:
+		if (!(flags & WMI_TPC_CONFIG_EVENT_FLAG_TABLE_STBC)) {
+			ath10k_dbg(ar, ATH10K_DBG_WMI, "STBC not supported\n");
+			tpc_stats->flag[type] = ATH10K_TPC_TABLE_TYPE_FLAG;
+			return;
+		}
+		break;
+	case WMI_TPC_TABLE_TYPE_TXBF:
+		if (!(flags & WMI_TPC_CONFIG_EVENT_FLAG_TABLE_TXBF)) {
+			ath10k_dbg(ar, ATH10K_DBG_WMI, "TXBF not supported\n");
+			tpc_stats->flag[type] = ATH10K_TPC_TABLE_TYPE_FLAG;
+			return;
+		}
+		break;
+	default:
+		ath10k_dbg(ar, ATH10K_DBG_WMI,
+			   "invalid table type in wmi tpc event: %d\n", type);
+		return;
+	}
+
+	pream_idx = 0;
+	for (i = 0; i < __le32_to_cpu(ev->rate_max); i++) {
+		memset(tpc_value, 0, sizeof(tpc_value));
+		memset(buff, 0, sizeof(buff));
+		if (i == pream_table[pream_idx])
+			pream_idx++;
+
+		for (j = 0; j < WMI_TPC_TX_N_CHAIN; j++) {
+			if (j >= __le32_to_cpu(ev->num_tx_chain))
+				break;
+
+			tpc[j] = ath10k_tpc_config_get_rate(ar, ev, i, j + 1,
+							    rate_code[i],
+							    type);
+			snprintf(buff, sizeof(buff), "%8d ", tpc[j]);
+			strncat(tpc_value, buff, strlen(buff));
+		}
+		tpc_stats->tpc_table[type].pream_idx[i] = pream_idx;
+		tpc_stats->tpc_table[type].rate_code[i] = rate_code[i];
+		memcpy(tpc_stats->tpc_table[type].tpc_value[i],
+		       tpc_value, sizeof(tpc_value));
+	}
+}
+
 void ath10k_wmi_event_pdev_tpc_config(struct ath10k *ar, struct sk_buff *skb)
 {
-	ath10k_dbg(ar, ATH10K_DBG_WMI, "WMI_PDEV_TPC_CONFIG_EVENTID\n");
+	u32 i, j, pream_idx, num_tx_chain;
+	u8 rate_code[WMI_TPC_RATE_MAX], rate_idx;
+	u16 pream_table[WMI_TPC_PREAM_TABLE_MAX];
+	struct wmi_pdev_tpc_config_event *ev;
+	struct ath10k_tpc_stats *tpc_stats;
+
+	ev = (struct wmi_pdev_tpc_config_event *)skb->data;
+
+	tpc_stats = kzalloc(sizeof(*tpc_stats), GFP_ATOMIC);
+	if (!tpc_stats)
+		return;
+
+	/* Create the rate code table based on the chains supported */
+	rate_idx = 0;
+	pream_idx = 0;
+
+	/* Fill CCK rate code */
+	for (i = 0; i < 4; i++) {
+		rate_code[rate_idx] =
+			ATH10K_HW_RATECODE(i, 0, WMI_RATE_PREAMBLE_CCK);
+		rate_idx++;
+	}
+	pream_table[pream_idx] = rate_idx;
+	pream_idx++;
+
+	/* Fill OFDM rate code */
+	for (i = 0; i < 8; i++) {
+		rate_code[rate_idx] =
+			ATH10K_HW_RATECODE(i, 0, WMI_RATE_PREAMBLE_OFDM);
+		rate_idx++;
+	}
+	pream_table[pream_idx] = rate_idx;
+	pream_idx++;
+
+	num_tx_chain = __le32_to_cpu(ev->num_tx_chain);
+
+	/* Fill HT20 rate code */
+	for (i = 0; i < num_tx_chain; i++) {
+		for (j = 0; j < 8; j++) {
+			rate_code[rate_idx] =
+			ATH10K_HW_RATECODE(j, i, WMI_RATE_PREAMBLE_HT);
+			rate_idx++;
+		}
+	}
+	pream_table[pream_idx] = rate_idx;
+	pream_idx++;
+
+	/* Fill HT40 rate code */
+	for (i = 0; i < num_tx_chain; i++) {
+		for (j = 0; j < 8; j++) {
+			rate_code[rate_idx] =
+			ATH10K_HW_RATECODE(j, i, WMI_RATE_PREAMBLE_HT);
+			rate_idx++;
+		}
+	}
+	pream_table[pream_idx] = rate_idx;
+	pream_idx++;
+
+	/* Fill VHT20 rate code */
+	for (i = 0; i < __le32_to_cpu(ev->num_tx_chain); i++) {
+		for (j = 0; j < 10; j++) {
+			rate_code[rate_idx] =
+			ATH10K_HW_RATECODE(j, i, WMI_RATE_PREAMBLE_VHT);
+			rate_idx++;
+		}
+	}
+	pream_table[pream_idx] = rate_idx;
+	pream_idx++;
+
+	/* Fill VHT40 rate code */
+	for (i = 0; i < num_tx_chain; i++) {
+		for (j = 0; j < 10; j++) {
+			rate_code[rate_idx] =
+			ATH10K_HW_RATECODE(j, i, WMI_RATE_PREAMBLE_VHT);
+			rate_idx++;
+		}
+	}
+	pream_table[pream_idx] = rate_idx;
+	pream_idx++;
+
+	/* Fill VHT80 rate code */
+	for (i = 0; i < num_tx_chain; i++) {
+		for (j = 0; j < 10; j++) {
+			rate_code[rate_idx] =
+			ATH10K_HW_RATECODE(j, i, WMI_RATE_PREAMBLE_VHT);
+			rate_idx++;
+		}
+	}
+	pream_table[pream_idx] = rate_idx;
+	pream_idx++;
+
+	rate_code[rate_idx++] =
+		ATH10K_HW_RATECODE(0, 0, WMI_RATE_PREAMBLE_CCK);
+	rate_code[rate_idx++] =
+		ATH10K_HW_RATECODE(0, 0, WMI_RATE_PREAMBLE_OFDM);
+	rate_code[rate_idx++] =
+		ATH10K_HW_RATECODE(0, 0, WMI_RATE_PREAMBLE_CCK);
+	rate_code[rate_idx++] =
+		ATH10K_HW_RATECODE(0, 0, WMI_RATE_PREAMBLE_OFDM);
+	rate_code[rate_idx++] =
+		ATH10K_HW_RATECODE(0, 0, WMI_RATE_PREAMBLE_OFDM);
+
+	pream_table[pream_idx] = ATH10K_TPC_PREAM_TABLE_END;
+
+	tpc_stats->chan_freq = __le32_to_cpu(ev->chan_freq);
+	tpc_stats->phy_mode = __le32_to_cpu(ev->phy_mode);
+	tpc_stats->ctl = __le32_to_cpu(ev->ctl);
+	tpc_stats->reg_domain = __le32_to_cpu(ev->reg_domain);
+	tpc_stats->twice_antenna_gain = a_sle32_to_cpu(ev->twice_antenna_gain);
+	tpc_stats->twice_antenna_reduction =
+		__le32_to_cpu(ev->twice_antenna_reduction);
+	tpc_stats->power_limit = __le32_to_cpu(ev->power_limit);
+	tpc_stats->twice_max_rd_power = __le32_to_cpu(ev->twice_max_rd_power);
+	tpc_stats->num_tx_chain = __le32_to_cpu(ev->num_tx_chain);
+	tpc_stats->rate_max = __le32_to_cpu(ev->rate_max);
+
+	ath10k_tpc_config_disp_tables(ar, ev, tpc_stats,
+				      rate_code, pream_table,
+				      WMI_TPC_TABLE_TYPE_CDD);
+	ath10k_tpc_config_disp_tables(ar, ev,  tpc_stats,
+				      rate_code, pream_table,
+				      WMI_TPC_TABLE_TYPE_STBC);
+	ath10k_tpc_config_disp_tables(ar, ev, tpc_stats,
+				      rate_code, pream_table,
+				      WMI_TPC_TABLE_TYPE_TXBF);
+
+	ath10k_debug_tpc_stats_process(ar, tpc_stats);
+
+	ath10k_dbg(ar, ATH10K_DBG_WMI,
+		   "wmi event tpc config channel %d mode %d ctl %d regd %d gain %d %d limit %d max_power %d tx_chanins %d rates %d\n",
+		   __le32_to_cpu(ev->chan_freq),
+		   __le32_to_cpu(ev->phy_mode),
+		   __le32_to_cpu(ev->ctl),
+		   __le32_to_cpu(ev->reg_domain),
+		   a_sle32_to_cpu(ev->twice_antenna_gain),
+		   __le32_to_cpu(ev->twice_antenna_reduction),
+		   __le32_to_cpu(ev->power_limit),
+		   __le32_to_cpu(ev->twice_max_rd_power) / 2,
+		   __le32_to_cpu(ev->num_tx_chain),
+		   __le32_to_cpu(ev->rate_max));
 }
 
 void ath10k_wmi_event_pdev_ftm_intg(struct ath10k *ar, struct sk_buff *skb)
@@ -6356,6 +6605,23 @@ ath10k_wmi_op_gen_delba_send(struct ath10k *ar, u32 vdev_id, const u8 *mac,
 	return skb;
 }
 
+static struct sk_buff *
+ath10k_wmi_10_2_4_op_gen_pdev_get_tpc_config(struct ath10k *ar, u32 param)
+{
+	struct wmi_pdev_get_tpc_config_cmd *cmd;
+	struct sk_buff *skb;
+
+	skb = ath10k_wmi_alloc_skb(ar, sizeof(*cmd));
+	if (!skb)
+		return ERR_PTR(-ENOMEM);
+
+	cmd = (struct wmi_pdev_get_tpc_config_cmd *)skb->data;
+	cmd->param = __cpu_to_le32(param);
+
+	ath10k_dbg(ar, ATH10K_DBG_WMI,
+		   "wmi pdev get tcp config param:%d\n", param);
+	return skb;
+}
 static const struct wmi_ops wmi_ops = {
 	.rx = ath10k_wmi_op_rx,
 	.map_svc = wmi_main_svc_map,
@@ -6606,6 +6872,7 @@ static const struct wmi_ops wmi_10_2_4_ops = {
 	.gen_addba_send = ath10k_wmi_op_gen_addba_send,
 	.gen_addba_set_resp = ath10k_wmi_op_gen_addba_set_resp,
 	.gen_delba_send = ath10k_wmi_op_gen_delba_send,
+	.gen_pdev_get_tpc_config = ath10k_wmi_10_2_4_op_gen_pdev_get_tpc_config,
 	/* .gen_bcn_tmpl not implemented */
 	/* .gen_prb_tmpl not implemented */
 	/* .gen_p2p_go_bcn_ie not implemented */
diff --git a/drivers/net/wireless/ath/ath10k/wmi.h b/drivers/net/wireless/ath/ath10k/wmi.h
index 95fdc723a996..9e9e222c5a37 100644
--- a/drivers/net/wireless/ath/ath10k/wmi.h
+++ b/drivers/net/wireless/ath/ath10k/wmi.h
@@ -3661,8 +3661,18 @@ struct wmi_pdev_get_tpc_config_cmd {
 	__le32 param;
 } __packed;
 
+#define WMI_TPC_CONFIG_PARAM		1
 #define WMI_TPC_RATE_MAX		160
 #define WMI_TPC_TX_N_CHAIN		4
+#define WMI_TPC_PREAM_TABLE_MAX		10
+#define WMI_TPC_FLAG			3
+#define WMI_TPC_BUF_SIZE		10
+
+enum wmi_tpc_table_type {
+	WMI_TPC_TABLE_TYPE_CDD = 0,
+	WMI_TPC_TABLE_TYPE_STBC = 1,
+	WMI_TPC_TABLE_TYPE_TXBF = 2,
+};
 
 enum wmi_tpc_config_event_flag {
 	WMI_TPC_CONFIG_EVENT_FLAG_TABLE_CDD	= 0x1,
@@ -4272,6 +4282,11 @@ enum wmi_rate_preamble {
 	WMI_RATE_PREAMBLE_VHT,
 };
 
+#define ATH10K_HW_NSS(rate)		(1 + (((rate) >> 4) & 0x3))
+#define ATH10K_HW_PREAMBLE(rate)	(((rate) >> 6) & 0x3)
+#define ATH10K_HW_RATECODE(rate, nss, preamble)	\
+	(((preamble) << 6) | ((nss) << 4) | (rate))
+
 /* Value to disable fixed rate setting */
 #define WMI_FIXED_RATE_NONE    (0xff)
 

