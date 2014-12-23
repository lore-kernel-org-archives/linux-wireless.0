Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx0b-0016f401.pphosted.com ([67.231.156.173]:35719 "EHLO
	mx0b-0016f401.pphosted.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751976AbaLWIOp (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 23 Dec 2014 03:14:45 -0500
Received: from pps.filterd (m0045851.ppops.net [127.0.0.1])
	by mx0b-0016f401.pphosted.com (8.14.5/8.14.5) with SMTP id sBN8EZhk010297
	for <linux-wireless@vger.kernel.org>; Tue, 23 Dec 2014 00:14:45 -0800
Received: from sc-owa.marvell.com ([199.233.58.135])
	by mx0b-0016f401.pphosted.com with ESMTP id 1rd602ptag-1
	(version=TLSv1/SSLv3 cipher=AES128-SHA bits=128 verify=NOT)
	for <linux-wireless@vger.kernel.org>; Tue, 23 Dec 2014 00:14:45 -0800
From: Avinash Patil <patila@marvell.com>
To: <linux-wireless@vger.kernel.org>
CC: <akarwar@marvell.com>, <cluo@marvell.com>, <yangyang@marvell.com>,
	<huxm@marvell.com>, Avinash Patil <patila@marvell.com>
Subject: [PATCH 3/8] mwifiex: add rx histogram statistics support
Date: Tue, 23 Dec 2014 19:14:07 +0530
Message-ID: <1419342252-2702-4-git-send-email-patila@marvell.com> (sfid-20141223_091453_020618_F761DF4F)
In-Reply-To: <1419342252-2702-1-git-send-email-patila@marvell.com>
References: <1419342252-2702-1-git-send-email-patila@marvell.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Xinming Hu <huxm@marvell.com>

This patch add a new debugfs item histogram used for reporting
rx data packet statitics(rx rate, snr, noise floor, signal strenth)
to userspace.

Signed-off-by: Xinming Hu <huxm@marvell.com>
Signed-off-by: Cathy Luo <cluo@marvell.com>
Signed-off-by: Avinash Patil <patila@marvell.com>
---
 drivers/net/wireless/mwifiex/cfg80211.c  |  4 ++
 drivers/net/wireless/mwifiex/cfp.c       | 18 ++++++
 drivers/net/wireless/mwifiex/debugfs.c   | 99 ++++++++++++++++++++++++++++++++
 drivers/net/wireless/mwifiex/decl.h      | 24 ++++++++
 drivers/net/wireless/mwifiex/main.c      |  8 +++
 drivers/net/wireless/mwifiex/main.h      | 10 ++++
 drivers/net/wireless/mwifiex/sta_event.c |  4 ++
 drivers/net/wireless/mwifiex/sta_rx.c    |  9 +++
 drivers/net/wireless/mwifiex/uap_event.c |  2 +
 drivers/net/wireless/mwifiex/util.c      | 41 +++++++++++++
 10 files changed, 219 insertions(+)

diff --git a/drivers/net/wireless/mwifiex/cfg80211.c b/drivers/net/wireless/mwifiex/cfg80211.c
index 4a66a655..f8b1ce0 100644
--- a/drivers/net/wireless/mwifiex/cfg80211.c
+++ b/drivers/net/wireless/mwifiex/cfg80211.c
@@ -2386,6 +2386,10 @@ int mwifiex_del_virtual_intf(struct wiphy *wiphy, struct wireless_dev *wdev)
 
 	priv->bss_mode = NL80211_IFTYPE_UNSPECIFIED;
 
+	if (GET_BSS_ROLE(priv) == MWIFIEX_BSS_ROLE_STA ||
+	    GET_BSS_ROLE(priv) == MWIFIEX_BSS_ROLE_UAP)
+		kfree(priv->hist_data);
+
 	return 0;
 }
 EXPORT_SYMBOL_GPL(mwifiex_del_virtual_intf);
diff --git a/drivers/net/wireless/mwifiex/cfp.c b/drivers/net/wireless/mwifiex/cfp.c
index b8242eb..f494fc7 100644
--- a/drivers/net/wireless/mwifiex/cfp.c
+++ b/drivers/net/wireless/mwifiex/cfp.c
@@ -509,3 +509,21 @@ u32 mwifiex_get_supported_rates(struct mwifiex_private *priv, u8 *rates)
 
 	return k;
 }
+
+u8 mwifiex_adjust_data_rate(struct mwifiex_private *priv,
+			    u8 rx_rate, u8 rate_info)
+{
+	u8 rate_index = 0;
+
+	/* HT40 */
+	if ((rate_info & BIT(0)) && (rate_info & BIT(1)))
+		rate_index = MWIFIEX_RATE_INDEX_MCS0 +
+			     MWIFIEX_BW20_MCS_NUM + rx_rate;
+	else if (rate_info & BIT(0)) /* HT20 */
+		rate_index = MWIFIEX_RATE_INDEX_MCS0 + rx_rate;
+	else
+		rate_index = (rx_rate > MWIFIEX_RATE_INDEX_OFDM0) ?
+			      rx_rate - 1 : rx_rate;
+
+	return rate_index;
+}
diff --git a/drivers/net/wireless/mwifiex/debugfs.c b/drivers/net/wireless/mwifiex/debugfs.c
index 3d2fb9a..fe1eb74 100644
--- a/drivers/net/wireless/mwifiex/debugfs.c
+++ b/drivers/net/wireless/mwifiex/debugfs.c
@@ -366,6 +366,103 @@ free_and_exit:
 	return ret;
 }
 
+/* Sysfs histogram file read handler.
+ *
+ * This function is called when the 'histogram' file is opened for reading
+ * It prints the following histogram information -
+ *      - Number of histogram samples
+ *      - Receive packet number of each rx_rate
+ *      - Receive packet number of each snr
+ *      - Receive packet number of each nosie_flr
+ *      - Receive packet number of each signal streath
+ */
+static ssize_t
+mwifiex_histogram_read(struct file *file, char __user *ubuf,
+		       size_t count, loff_t *ppos)
+{
+	struct mwifiex_private *priv =
+		(struct mwifiex_private *)file->private_data;
+	ssize_t ret;
+	struct mwifiex_histogram_data *phist_data;
+	int i, value;
+	unsigned long page = get_zeroed_page(GFP_KERNEL);
+	char *p = (char *)page;
+
+	if (!p)
+		return -ENOMEM;
+
+	if (!priv || !priv->hist_data)
+		return -EFAULT;
+	phist_data = priv->hist_data;
+
+	p += sprintf(p, "\n"
+		     "total samples = %d\n",
+		     atomic_read(&phist_data->num_samples));
+
+	p += sprintf(p, "rx rates (in Mbps): 0=1M   1=2M");
+	p += sprintf(p, "2=5.5M  3=11M   4=6M   5=9M  6=12M\n");
+	p += sprintf(p, "7=18M  8=24M  9=36M  10=48M  11=54M");
+	p += sprintf(p, "12-27=MCS0-15(BW20) 28-43=MCS0-15(BW40)\n");
+
+	if (ISSUPP_11ACENABLED(priv->adapter->fw_cap_info)) {
+		p += sprintf(p, "44-53=MCS0-9(VHT:BW20)");
+		p += sprintf(p, "54-63=MCS0-9(VHT:BW40)");
+		p += sprintf(p, "64-73=MCS0-9(VHT:BW80)\n\n");
+	} else {
+		p += sprintf(p, "\n");
+	}
+
+	for (i = 0; i < MWIFIEX_MAX_RX_RATES; i++) {
+		value = atomic_read(&phist_data->rx_rate[i]);
+		if (value)
+			p += sprintf(p, "rx_rate[%02d] = %d\n", i, value);
+	}
+
+	if (ISSUPP_11ACENABLED(priv->adapter->fw_cap_info)) {
+		for (i = MWIFIEX_MAX_RX_RATES; i < MWIFIEX_MAX_AC_RX_RATES;
+		     i++) {
+			value = atomic_read(&phist_data->rx_rate[i]);
+			if (value)
+				p += sprintf(p, "rx_rate[%02d] = %d\n",
+					   i, value);
+		}
+	}
+
+	for (i = 0; i < MWIFIEX_MAX_SNR; i++) {
+		value =  atomic_read(&phist_data->snr[i]);
+		if (value)
+			p += sprintf(p, "snr[%02ddB] = %d\n", i, value);
+	}
+	for (i = 0; i < MWIFIEX_MAX_NOISE_FLR; i++) {
+		value = atomic_read(&phist_data->noise_flr[i]);
+		if (value)
+			p += sprintf(p, "noise_flr[-%02ddBm] = %d\n",
+				(int)(i-128), value);
+	}
+	for (i = 0; i < MWIFIEX_MAX_SIG_STRENGTH; i++) {
+		value = atomic_read(&phist_data->sig_str[i]);
+		if (value)
+			p += sprintf(p, "sig_strength[-%02ddBm] = %d\n",
+				i, value);
+	}
+
+	ret = simple_read_from_buffer(ubuf, count, ppos, (char *)page,
+				      (unsigned long)p - page);
+
+	return ret;
+}
+
+static ssize_t
+mwifiex_histogram_write(struct file *file, const char __user *ubuf,
+			size_t count, loff_t *ppos)
+{
+	struct mwifiex_private *priv = (void *)file->private_data;
+
+	if (priv && priv->hist_data)
+		mwifiex_hist_data_reset(priv);
+	return 0;
+}
+
 static struct mwifiex_debug_info info;
 
 /*
@@ -832,6 +929,7 @@ MWIFIEX_DFS_FILE_READ_OPS(fw_dump);
 MWIFIEX_DFS_FILE_OPS(regrdwr);
 MWIFIEX_DFS_FILE_OPS(rdeeprom);
 MWIFIEX_DFS_FILE_OPS(hscfg);
+MWIFIEX_DFS_FILE_OPS(histogram);
 
 /*
  * This function creates the debug FS directory structure and the files.
@@ -855,6 +953,7 @@ mwifiex_dev_debugfs_init(struct mwifiex_private *priv)
 	MWIFIEX_DFS_ADD_FILE(rdeeprom);
 	MWIFIEX_DFS_ADD_FILE(fw_dump);
 	MWIFIEX_DFS_ADD_FILE(hscfg);
+	MWIFIEX_DFS_ADD_FILE(histogram);
 }
 
 /*
diff --git a/drivers/net/wireless/mwifiex/decl.h b/drivers/net/wireless/mwifiex/decl.h
index 817c496..7aa988e 100644
--- a/drivers/net/wireless/mwifiex/decl.h
+++ b/drivers/net/wireless/mwifiex/decl.h
@@ -96,6 +96,14 @@
 #define MWIFIEX_TDLS_MAX_FAIL_COUNT      4
 #define MWIFIEX_AUTO_TDLS_IDLE_TIME     10
 
+/* 54M rates, index from 0 to 11 */
+#define MWIFIEX_RATE_INDEX_MCS0 12
+/* 12-27=MCS0-15(BW20) */
+#define MWIFIEX_BW20_MCS_NUM 15
+
+/* Rate index for OFDM 0 */
+#define MWIFIEX_RATE_INDEX_OFDM0   4
+
 enum mwifiex_bss_type {
 	MWIFIEX_BSS_TYPE_STA = 0,
 	MWIFIEX_BSS_TYPE_UAP = 1,
@@ -208,4 +216,20 @@ struct mwifiex_chan_stats {
 	u16 cca_scan_dur;
 	u16 cca_busy_dur;
 } __packed;
+
+#define MWIFIEX_HIST_MAX_SAMPLES	1048576
+#define MWIFIEX_MAX_RX_RATES		     44
+#define MWIFIEX_MAX_AC_RX_RATES		     74
+#define MWIFIEX_MAX_SNR			    256
+#define MWIFIEX_MAX_NOISE_FLR		    256
+#define MWIFIEX_MAX_SIG_STRENGTH	    256
+
+struct mwifiex_histogram_data {
+	atomic_t rx_rate[MWIFIEX_MAX_AC_RX_RATES];
+	atomic_t snr[MWIFIEX_MAX_SNR];
+	atomic_t noise_flr[MWIFIEX_MAX_NOISE_FLR];
+	atomic_t sig_str[MWIFIEX_MAX_SIG_STRENGTH];
+	atomic_t num_samples;
+};
+
 #endif /* !_MWIFIEX_DECL_H_ */
diff --git a/drivers/net/wireless/mwifiex/main.c b/drivers/net/wireless/mwifiex/main.c
index d4d2223..0c44c5ee 100644
--- a/drivers/net/wireless/mwifiex/main.c
+++ b/drivers/net/wireless/mwifiex/main.c
@@ -847,6 +847,7 @@ static const struct net_device_ops mwifiex_netdev_ops = {
  *      - Nick name             : Set to null
  *      - Number of Tx timeout  : Set to 0
  *      - Device address        : Set to current address
+ *      - Rx histogram statistc : Set to 0
  *
  * In addition, the CFG80211 work queue is also created.
  */
@@ -867,6 +868,13 @@ void mwifiex_init_priv_params(struct mwifiex_private *priv,
 	priv->rsn_idx = MWIFIEX_AUTO_IDX_MASK;
 	priv->num_tx_timeout = 0;
 	memcpy(dev->dev_addr, priv->curr_addr, ETH_ALEN);
+
+	if (GET_BSS_ROLE(priv) == MWIFIEX_BSS_ROLE_STA ||
+	    GET_BSS_ROLE(priv) == MWIFIEX_BSS_ROLE_UAP) {
+		priv->hist_data = kmalloc(sizeof(*priv->hist_data), GFP_KERNEL);
+		if (priv->hist_data)
+			mwifiex_hist_data_reset(priv);
+	}
 }
 
 /*
diff --git a/drivers/net/wireless/mwifiex/main.h b/drivers/net/wireless/mwifiex/main.h
index b3e23f6..6f7e060 100644
--- a/drivers/net/wireless/mwifiex/main.h
+++ b/drivers/net/wireless/mwifiex/main.h
@@ -582,6 +582,8 @@ struct mwifiex_private {
 	struct idr ack_status_frames;
 	/* spin lock for ack status */
 	spinlock_t ack_status_lock;
+	/** rx histogram data */
+	struct mwifiex_histogram_data *hist_data;
 };
 
 enum mwifiex_ba_status {
@@ -1350,6 +1352,14 @@ struct sk_buff *
 mwifiex_clone_skb_for_tx_status(struct mwifiex_private *priv,
 				struct sk_buff *skb, u8 flag, u64 *cookie);
 
+void mwifiex_hist_data_set(struct mwifiex_private *priv, u8 rx_rate, s8 snr,
+			   s8 nflr);
+void mwifiex_hist_data_reset(struct mwifiex_private *priv);
+void mwifiex_hist_data_add(struct mwifiex_private *priv,
+			   u8 rx_rate, s8 snr, s8 nflr);
+u8 mwifiex_adjust_data_rate(struct mwifiex_private *priv,
+			    u8 rx_rate, u8 ht_info);
+
 #ifdef CONFIG_DEBUG_FS
 void mwifiex_debugfs_init(void);
 void mwifiex_debugfs_remove(void);
diff --git a/drivers/net/wireless/mwifiex/sta_event.c b/drivers/net/wireless/mwifiex/sta_event.c
index b8c171d..fbec95b 100644
--- a/drivers/net/wireless/mwifiex/sta_event.c
+++ b/drivers/net/wireless/mwifiex/sta_event.c
@@ -90,6 +90,10 @@ mwifiex_reset_connect_state(struct mwifiex_private *priv, u16 reason_code)
 	priv->is_data_rate_auto = true;
 	priv->data_rate = 0;
 
+	if ((GET_BSS_ROLE(priv) == MWIFIEX_BSS_ROLE_STA ||
+	     GET_BSS_ROLE(priv) == MWIFIEX_BSS_ROLE_UAP) && priv->hist_data)
+		mwifiex_hist_data_reset(priv);
+
 	if (priv->bss_mode == NL80211_IFTYPE_ADHOC) {
 		priv->adhoc_state = ADHOC_IDLE;
 		priv->adhoc_is_link_sensed = false;
diff --git a/drivers/net/wireless/mwifiex/sta_rx.c b/drivers/net/wireless/mwifiex/sta_rx.c
index c2ad3b6..b8729c9 100644
--- a/drivers/net/wireless/mwifiex/sta_rx.c
+++ b/drivers/net/wireless/mwifiex/sta_rx.c
@@ -90,6 +90,7 @@ int mwifiex_process_rx_packet(struct mwifiex_private *priv,
 	struct ethhdr *eth;
 	u16 rx_pkt_off, rx_pkt_len;
 	u8 *offset;
+	u8 adj_rx_rate = 0;
 
 	local_rx_pd = (struct rxpd *) (skb->data);
 
@@ -155,6 +156,14 @@ int mwifiex_process_rx_packet(struct mwifiex_private *priv,
 
 	priv->rxpd_htinfo = local_rx_pd->ht_info;
 
+	if (GET_BSS_ROLE(priv) == MWIFIEX_BSS_ROLE_STA ||
+	    GET_BSS_ROLE(priv) == MWIFIEX_BSS_ROLE_UAP) {
+		adj_rx_rate = mwifiex_adjust_data_rate(priv, priv->rxpd_rate,
+						       priv->rxpd_htinfo);
+		mwifiex_hist_data_add(priv, adj_rx_rate, local_rx_pd->snr,
+				      local_rx_pd->nf);
+	}
+
 	ret = mwifiex_recv_packet(priv, skb);
 	if (ret == -1)
 		dev_err(priv->adapter->dev, "recv packet failed\n");
diff --git a/drivers/net/wireless/mwifiex/uap_event.c b/drivers/net/wireless/mwifiex/uap_event.c
index c54a537..f31086c 100644
--- a/drivers/net/wireless/mwifiex/uap_event.c
+++ b/drivers/net/wireless/mwifiex/uap_event.c
@@ -132,6 +132,8 @@ int mwifiex_process_uap_event(struct mwifiex_private *priv)
 		dev_dbg(adapter->dev, "AP EVENT: event id: %#x\n", eventcause);
 		memcpy(priv->netdev->dev_addr, adapter->event_body + 2,
 		       ETH_ALEN);
+		if (priv->hist_data)
+			mwifiex_hist_data_reset(priv);
 		break;
 	case EVENT_UAP_MIC_COUNTERMEASURES:
 		/* For future development */
diff --git a/drivers/net/wireless/mwifiex/util.c b/drivers/net/wireless/mwifiex/util.c
index 3bd9179..6a83c04 100644
--- a/drivers/net/wireless/mwifiex/util.c
+++ b/drivers/net/wireless/mwifiex/util.c
@@ -406,3 +406,44 @@ void mwifiex_del_all_sta_list(struct mwifiex_private *priv)
 	spin_unlock_irqrestore(&priv->sta_list_spinlock, flags);
 	return;
 }
+
+/* This function adds histogram data to histogram array*/
+void mwifiex_hist_data_add(struct mwifiex_private *priv,
+			   u8 rx_rate, s8 snr, s8 nflr)
+{
+	struct mwifiex_histogram_data *phist_data = priv->hist_data;
+
+	if (atomic_read(&phist_data->num_samples) > MWIFIEX_HIST_MAX_SAMPLES)
+		mwifiex_hist_data_reset(priv);
+	mwifiex_hist_data_set(priv, rx_rate, snr, nflr);
+}
+
+/* function to add histogram record */
+void mwifiex_hist_data_set(struct mwifiex_private *priv, u8 rx_rate, s8 snr,
+			   s8 nflr)
+{
+	struct mwifiex_histogram_data *phist_data = priv->hist_data;
+
+	atomic_inc(&phist_data->num_samples);
+	atomic_inc(&phist_data->rx_rate[rx_rate]);
+	atomic_inc(&phist_data->snr[snr]);
+	atomic_inc(&phist_data->noise_flr[128 + nflr]);
+	atomic_inc(&phist_data->sig_str[nflr - snr]);
+}
+
+/* function to reset histogram data during init/reset */
+void mwifiex_hist_data_reset(struct mwifiex_private *priv)
+{
+	int ix;
+	struct mwifiex_histogram_data *phist_data = priv->hist_data;
+
+	atomic_set(&phist_data->num_samples, 0);
+	for (ix = 0; ix < MWIFIEX_MAX_AC_RX_RATES; ix++)
+		atomic_set(&phist_data->rx_rate[ix], 0);
+	for (ix = 0; ix < MWIFIEX_MAX_SNR; ix++)
+		atomic_set(&phist_data->snr[ix], 0);
+	for (ix = 0; ix < MWIFIEX_MAX_NOISE_FLR; ix++)
+		atomic_set(&phist_data->noise_flr[ix], 0);
+	for (ix = 0; ix < MWIFIEX_MAX_SIG_STRENGTH; ix++)
+		atomic_set(&phist_data->sig_str[ix], 0);
+}
-- 
1.8.1.4

