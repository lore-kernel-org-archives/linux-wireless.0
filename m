Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ie0-f175.google.com ([209.85.223.175]:34507 "EHLO
	mail-ie0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751424AbbFLUJJ (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 12 Jun 2015 16:09:09 -0400
Received: by iebmu5 with SMTP id mu5so30867974ieb.1
        for <linux-wireless@vger.kernel.org>; Fri, 12 Jun 2015 13:09:08 -0700 (PDT)
From: Liu CF/TW <cfliu.tw@gmail.com>
To: kvalo@qca.qualcomm.com, ath10k@lists.infradead.org
Cc: linux-wireless@vger.kernel.org, David Liu <cfliu.tw@gmail.com>,
	Michal Kazior <michal.kazior@tieto.com>
Subject: [PATCH v4] ath10k: enable raw encap mode and software crypto engine.
Date: Fri, 12 Jun 2015 12:56:06 -0700
Message-Id: <1434138966-3652-1-git-send-email-cfliu.tw@gmail.com> (sfid-20150612_220915_056847_B9BB43BE)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: David Liu <cfliu.tw@gmail.com>

  This patch enables raw Rx/Tx encap mode to support software based
  crypto engine. This patch introduces a new module param 'cryptmode'.

   cryptmode:

     0: Use hardware crypto engine globally with native Wi-Fi mode TX/RX
        encapsulation to the firmware. This is the default mode.
     1: Use sofware crypto engine globally with raw mode TX/RX
        encapsulation to the firmware.

   Known limitation:
     A-MSDU must be disabled for RAW Tx encap mode to perform well when
     heavy traffic is applied.

   Testing: (by Michal Kazior <michal.kazior@tieto.com>)

     a) Performance Testing

      cryptmode=1
       ap=qca988x sta=killer1525
        killer1525  ->  qca988x     194.496 mbps [tcp1 ip4]
        killer1525  ->  qca988x     238.309 mbps [tcp5 ip4]
        killer1525  ->  qca988x     266.958 mbps [udp1 ip4]
        killer1525  ->  qca988x     477.468 mbps [udp5 ip4]
        qca988x     ->  killer1525  301.378 mbps [tcp1 ip4]
        qca988x     ->  killer1525  297.949 mbps [tcp5 ip4]
        qca988x     ->  killer1525  331.351 mbps [udp1 ip4]
        qca988x     ->  killer1525  371.528 mbps [udp5 ip4]
       ap=killer1525 sta=qca988x
        qca988x     ->  killer1525  331.447 mbps [tcp1 ip4]
        qca988x     ->  killer1525  328.783 mbps [tcp5 ip4]
        qca988x     ->  killer1525  375.309 mbps [udp1 ip4]
        qca988x     ->  killer1525  403.379 mbps [udp5 ip4]
        killer1525  ->  qca988x     203.689 mbps [tcp1 ip4]
        killer1525  ->  qca988x     222.339 mbps [tcp5 ip4]
        killer1525  ->  qca988x     264.199 mbps [udp1 ip4]
        killer1525  ->  qca988x     479.371 mbps [udp5 ip4]

      Note:
       - only open network tested for RAW vs nwifi performance comparison
       - killer1525 (qca6174 hw2.2) is 2x2 device (hence max 866mbps)
       - used iperf
       - OTA, devices a few cm apart from each other, no shielding
       - tcpX/udpX, X - means number of threads used

      Overview:
       - relative Tx performance drop is seen but is within reasonable and
         expected threshold (A-MSDU must be disabled with RAW Tx)

     b) Connectivity Testing

      cryptmode=1
       ap=iwl6205 sta1=qca988x crypto=open     topology-1ap1sta          OK
       ap=iwl6205 sta1=qca988x crypto=wep1     topology-1ap1sta          OK
       ap=iwl6205 sta1=qca988x crypto=wpa      topology-1ap1sta          OK
       ap=iwl6205 sta1=qca988x crypto=wpa-ccmp topology-1ap1sta          OK
       ap=qca988x sta1=iwl6205 crypto=open     topology-1ap1sta          OK
       ap=qca988x sta1=iwl6205 crypto=wep1     topology-1ap1sta          OK
       ap=qca988x sta1=iwl6205 crypto=wpa      topology-1ap1sta          OK
       ap=qca988x sta1=iwl6205 crypto=wpa-ccmp topology-1ap1sta          OK
       ap=iwl6205 sta1=qca988x crypto=open     topology-1ap1sta2br       OK
       ap=iwl6205 sta1=qca988x crypto=wep1     topology-1ap1sta2br       OK
       ap=iwl6205 sta1=qca988x crypto=wpa      topology-1ap1sta2br       OK
       ap=iwl6205 sta1=qca988x crypto=wpa-ccmp topology-1ap1sta2br       OK
       ap=qca988x sta1=iwl6205 crypto=open     topology-1ap1sta2br       OK
       ap=qca988x sta1=iwl6205 crypto=wep1     topology-1ap1sta2br       OK
       ap=qca988x sta1=iwl6205 crypto=wpa      topology-1ap1sta2br       OK
       ap=qca988x sta1=iwl6205 crypto=wpa-ccmp topology-1ap1sta2br       OK
       ap=iwl6205 sta1=qca988x crypto=open     topology-1ap1sta2br1vlan  OK
       ap=iwl6205 sta1=qca988x crypto=wep1     topology-1ap1sta2br1vlan  OK
       ap=iwl6205 sta1=qca988x crypto=wpa      topology-1ap1sta2br1vlan  OK
       ap=iwl6205 sta1=qca988x crypto=wpa-ccmp topology-1ap1sta2br1vlan  OK
       ap=qca988x sta1=iwl6205 crypto=open     topology-1ap1sta2br1vlan  OK
       ap=qca988x sta1=iwl6205 crypto=wep1     topology-1ap1sta2br1vlan  OK
       ap=qca988x sta1=iwl6205 crypto=wpa      topology-1ap1sta2br1vlan  OK
       ap=qca988x sta1=iwl6205 crypto=wpa-ccmp topology-1ap1sta2br1vlan  OK

      Note:
       - each test takes all possible endpoint pairs and pings
       - each pair-ping flushes arp table
       - ip6 is used

     c) Testbed Topology:

      1ap1sta:
        [ap] ---- [sta]

        endpoints: ap, sta

      1ap1sta2br:
        [veth0] [ap] ---- [sta] [veth2]
           |     |          |     |
        [veth1]  |          \   [veth3]
            \   /            \  /
            [br0]            [br1]

        endpoints: veth0, veth2, br0, br1
        note: STA works in 4addr mode, AP has wds_sta=1

      1ap1sta2br1vlan:
        [veth0] [ap] ---- [sta] [veth2]
           |     |          |     |
        [veth1]  |          \   [veth3]
            \   /            \  /
          [br0]              [br1]
            |                  |
          [vlan0_id2]        [vlan1_id2]

        endpoints: vlan0_id2, vlan1_id2
        note: STA works in 4addr mode, AP has wds_sta=1

  Credits:

    Thanks to Michal Kazior <michal.kazior@tieto.com> who helped find the
    amsdu issue, contributed a workaround (already squashed into this 
    patch), and contributed the throughput and connectivity tests results.

Signed-off-by: David Liu <cfliu.tw@gmail.com>
Signed-off-by: Michal Kazior <michal.kazior@tieto.com>
Tested-by: Michal Kazior <michal.kazior@tieto.com>
---
 drivers/net/wireless/ath/ath10k/core.c    | 43 +++++++++++++++++++
 drivers/net/wireless/ath/ath10k/core.h    | 31 +++++++++++---
 drivers/net/wireless/ath/ath10k/debug.c   | 21 ++++------
 drivers/net/wireless/ath/ath10k/htt.c     | 23 +++++++++-
 drivers/net/wireless/ath/ath10k/htt.h     |  8 ++++
 drivers/net/wireless/ath/ath10k/htt_rx.c  |  7 ++--
 drivers/net/wireless/ath/ath10k/htt_tx.c  | 12 +++++-
 drivers/net/wireless/ath/ath10k/hw.h      | 11 ++---
 drivers/net/wireless/ath/ath10k/mac.c     | 70 ++++++++++++++++++++++++-------
 drivers/net/wireless/ath/ath10k/wmi-tlv.c |  2 +-
 drivers/net/wireless/ath/ath10k/wmi.c     |  8 ++--
 11 files changed, 184 insertions(+), 52 deletions(-)

diff --git a/drivers/net/wireless/ath/ath10k/core.c b/drivers/net/wireless/ath/ath10k/core.c
index 59496a9..85162f0 100644
--- a/drivers/net/wireless/ath/ath10k/core.c
+++ b/drivers/net/wireless/ath/ath10k/core.c
@@ -31,16 +31,19 @@
 #include "wmi-ops.h"
 
 unsigned int ath10k_debug_mask;
+static unsigned int ath10k_cryptmode_param;
 static bool uart_print;
 static bool skip_otp;
 
 module_param_named(debug_mask, ath10k_debug_mask, uint, 0644);
+module_param_named(cryptmode, ath10k_cryptmode_param, uint, 0644);
 module_param(uart_print, bool, 0644);
 module_param(skip_otp, bool, 0644);
 
 MODULE_PARM_DESC(debug_mask, "Debugging mask");
 MODULE_PARM_DESC(uart_print, "Uart target debugging");
 MODULE_PARM_DESC(skip_otp, "Skip otp failure for calibration in testmode");
+MODULE_PARM_DESC(cryptmode, "Crypto mode: 0-hardware, 1-software");
 
 static const struct ath10k_hw_params ath10k_hw_params_list[] = {
 	{
@@ -991,6 +994,46 @@ static int ath10k_core_init_firmware_features(struct ath10k *ar)
 		return -EINVAL;
 	}
 
+	ar->wmi.rx_decap_mode = ATH10K_HW_TXRX_NATIVE_WIFI;
+	switch (ath10k_cryptmode_param) {
+	case ATH10K_CRYPT_MODE_HW:
+		clear_bit(ATH10K_FLAG_RAW_MODE, &ar->dev_flags);
+		clear_bit(ATH10K_FLAG_HW_CRYPTO_DISABLED, &ar->dev_flags);
+		break;
+	case ATH10K_CRYPT_MODE_SW:
+		if (!test_bit(ATH10K_FW_FEATURE_RAW_MODE_SUPPORT,
+			      ar->fw_features)) {
+			ath10k_err(ar, "cryptmode > 0 requires raw mode support from firmware");
+			return -EINVAL;
+		}
+
+		set_bit(ATH10K_FLAG_RAW_MODE, &ar->dev_flags);
+		set_bit(ATH10K_FLAG_HW_CRYPTO_DISABLED, &ar->dev_flags);
+		break;
+	default:
+		ath10k_info(ar, "invalid cryptmode: %d\n",
+			    ath10k_cryptmode_param);
+		return -EINVAL;
+	}
+
+	ar->htt.max_num_amsdu = ATH10K_HTT_MAX_NUM_AMSDU_DEFAULT;
+	ar->htt.max_num_ampdu = ATH10K_HTT_MAX_NUM_AMPDU_DEFAULT;
+
+	if (test_bit(ATH10K_FLAG_RAW_MODE, &ar->dev_flags)) {
+		ar->wmi.rx_decap_mode = ATH10K_HW_TXRX_RAW;
+
+		/* Workaround:
+		 *
+		 * Firmware A-MSDU aggregation breaks with RAW Tx encap mode
+		 * and causes enormous performance issues (malformed frames,
+		 * etc).
+		 *
+		 * Disabling A-MSDU makes RAW mode stable with heavy traffic
+		 * albeit a bit slower compared to regular operation.
+		 */
+		ar->htt.max_num_amsdu = 1;
+	}
+
 	/* Backwards compatibility for firmwares without
 	 * ATH10K_FW_IE_WMI_OP_VERSION.
 	 */
diff --git a/drivers/net/wireless/ath/ath10k/core.h b/drivers/net/wireless/ath/ath10k/core.h
index 45f9603..38d386d 100644
--- a/drivers/net/wireless/ath/ath10k/core.h
+++ b/drivers/net/wireless/ath/ath10k/core.h
@@ -91,6 +91,7 @@ struct ath10k_skb_cb {
 		u8 tid;
 		u16 freq;
 		bool is_offchan;
+		bool nohwcrypt;
 		struct ath10k_htt_txbuf *txbuf;
 		u32 txbuf_paddr;
 	} __packed htt;
@@ -151,6 +152,7 @@ struct ath10k_wmi {
 	const struct wmi_ops *ops;
 
 	u32 num_mem_chunks;
+	u32 rx_decap_mode;
 	struct ath10k_mem_chunk mem_chunks[WMI_MAX_MEM_REQS];
 };
 
@@ -349,6 +351,7 @@ struct ath10k_vif {
 	} u;
 
 	bool use_cts_prot;
+	bool nohwcrypt;
 	int num_legacy_stations;
 	int txpower;
 	struct wmi_wmm_params_all_arg wmm_params;
@@ -390,9 +393,6 @@ struct ath10k_debug {
 	u32 reg_addr;
 	u32 nf_cal_period;
 
-	u8 htt_max_amsdu;
-	u8 htt_max_ampdu;
-
 	struct ath10k_fw_crash_data *fw_crash_data;
 };
 
@@ -461,16 +461,21 @@ enum ath10k_fw_features {
 	ATH10K_FW_FEATURE_WOWLAN_SUPPORT = 6,
 
 	/* Don't trust error code from otp.bin */
-	ATH10K_FW_FEATURE_IGNORE_OTP_RESULT,
+	ATH10K_FW_FEATURE_IGNORE_OTP_RESULT = 7,
 
 	/* Some firmware revisions pad 4th hw address to 4 byte boundary making
 	 * it 8 bytes long in Native Wifi Rx decap.
 	 */
-	ATH10K_FW_FEATURE_NO_NWIFI_DECAP_4ADDR_PADDING,
+	ATH10K_FW_FEATURE_NO_NWIFI_DECAP_4ADDR_PADDING = 8,
 
 	/* Firmware supports bypassing PLL setting on init. */
 	ATH10K_FW_FEATURE_SUPPORTS_SKIP_CLOCK_INIT = 9,
 
+	/* Raw mode support. If supported, FW supports receiving and trasmitting
+	 * frames in raw mode.
+	 */
+	ATH10K_FW_FEATURE_RAW_MODE_SUPPORT = 10,
+
 	/* keep last */
 	ATH10K_FW_FEATURE_COUNT,
 };
@@ -484,6 +489,15 @@ enum ath10k_dev_flags {
 	 * waiters should immediately cancel instead of waiting for a time out.
 	 */
 	ATH10K_FLAG_CRASH_FLUSH,
+
+	/* Use Raw mode instead of native WiFi Tx/Rx encap mode.
+	 * Raw mode supports both hardware and software crypto. Native WiFi only
+	 * supports hardware crypto.
+	 */
+	ATH10K_FLAG_RAW_MODE,
+
+	/* Disable HW crypto engine */
+	ATH10K_FLAG_HW_CRYPTO_DISABLED,
 };
 
 enum ath10k_cal_mode {
@@ -492,6 +506,13 @@ enum ath10k_cal_mode {
 	ATH10K_CAL_MODE_DT,
 };
 
+enum ath10k_crypt_mode {
+	/* Only use hardware crypto engine */
+	ATH10K_CRYPT_MODE_HW,
+	/* Only use software crypto engine */
+	ATH10K_CRYPT_MODE_SW,
+};
+
 static inline const char *ath10k_cal_mode_str(enum ath10k_cal_mode mode)
 {
 	switch (mode) {
diff --git a/drivers/net/wireless/ath/ath10k/debug.c b/drivers/net/wireless/ath/ath10k/debug.c
index 8fa606a..640f3d1 100644
--- a/drivers/net/wireless/ath/ath10k/debug.c
+++ b/drivers/net/wireless/ath/ath10k/debug.c
@@ -124,7 +124,7 @@ EXPORT_SYMBOL(ath10k_info);
 
 void ath10k_print_driver_info(struct ath10k *ar)
 {
-	ath10k_info(ar, "%s (0x%08x, 0x%08x%s%s%s) fw %s api %d htt %d.%d wmi %d cal %s max_sta %d\n",
+	ath10k_info(ar, "%s (0x%08x, 0x%08x%s%s%s) fw %s api %d htt %d.%d wmi %d cal %s max_sta %d raw %d hwcrypto %d\n",
 		    ar->hw_params.name,
 		    ar->target_version,
 		    ar->chip_id,
@@ -138,7 +138,9 @@ void ath10k_print_driver_info(struct ath10k *ar)
 		    ar->htt.target_version_minor,
 		    ar->wmi.op_version,
 		    ath10k_cal_mode_str(ar->cal_mode),
-		    ar->max_num_stations);
+		    ar->max_num_stations,
+		    test_bit(ATH10K_FLAG_RAW_MODE, &ar->dev_flags),
+		    !test_bit(ATH10K_FLAG_HW_CRYPTO_DISABLED, &ar->dev_flags));
 	ath10k_info(ar, "debug %d debugfs %d tracing %d dfs %d testmode %d\n",
 		    config_enabled(CONFIG_ATH10K_DEBUG),
 		    config_enabled(CONFIG_ATH10K_DEBUGFS),
@@ -1357,12 +1359,8 @@ static ssize_t ath10k_read_htt_max_amsdu_ampdu(struct file *file,
 
 	mutex_lock(&ar->conf_mutex);
 
-	if (ar->debug.htt_max_amsdu)
-		amsdu = ar->debug.htt_max_amsdu;
-
-	if (ar->debug.htt_max_ampdu)
-		ampdu = ar->debug.htt_max_ampdu;
-
+	amsdu = ar->htt.max_num_amsdu;
+	ampdu = ar->htt.max_num_ampdu;
 	mutex_unlock(&ar->conf_mutex);
 
 	len = scnprintf(buf, sizeof(buf), "%u %u\n", amsdu, ampdu);
@@ -1396,8 +1394,8 @@ static ssize_t ath10k_write_htt_max_amsdu_ampdu(struct file *file,
 		goto out;
 
 	res = count;
-	ar->debug.htt_max_amsdu = amsdu;
-	ar->debug.htt_max_ampdu = ampdu;
+	ar->htt.max_num_amsdu = amsdu;
+	ar->htt.max_num_ampdu = ampdu;
 
 out:
 	mutex_unlock(&ar->conf_mutex);
@@ -1899,9 +1897,6 @@ void ath10k_debug_stop(struct ath10k *ar)
 	if (ar->debug.htt_stats_mask != 0)
 		cancel_delayed_work(&ar->debug.htt_stats_dwork);
 
-	ar->debug.htt_max_amsdu = 0;
-	ar->debug.htt_max_ampdu = 0;
-
 	ath10k_wmi_pdev_pktlog_disable(ar);
 }
 
diff --git a/drivers/net/wireless/ath/ath10k/htt.c b/drivers/net/wireless/ath/ath10k/htt.c
index 6da6ef2..a4e1a1b 100644
--- a/drivers/net/wireless/ath/ath10k/htt.c
+++ b/drivers/net/wireless/ath/ath10k/htt.c
@@ -205,8 +205,27 @@ int ath10k_htt_setup(struct ath10k_htt *htt)
 	}
 
 	status = ath10k_htt_verify_version(htt);
-	if (status)
+	if (status) {
+		ath10k_warn(ar, "failed to verify htt version: %d\n",
+			    status);
 		return status;
+	}
+
+	status = ath10k_htt_send_rx_ring_cfg_ll(htt);
+	if (status) {
+		ath10k_warn(ar, "failed to setup rx ring: %d\n",
+			    status);
+		return status;
+	}
 
-	return ath10k_htt_send_rx_ring_cfg_ll(htt);
+	status = ath10k_htt_h2t_aggr_cfg_msg(htt,
+					     htt->max_num_ampdu,
+					     htt->max_num_amsdu);
+	if (status) {
+		ath10k_warn(ar, "failed to setup amsdu/ampdu limit: %d\n",
+			    status);
+		return status;
+	}
+
+	return 0;
 }
diff --git a/drivers/net/wireless/ath/ath10k/htt.h b/drivers/net/wireless/ath/ath10k/htt.h
index 7e8a0d8..58ca533 100644
--- a/drivers/net/wireless/ath/ath10k/htt.h
+++ b/drivers/net/wireless/ath/ath10k/htt.h
@@ -1325,6 +1325,8 @@ struct ath10k_htt {
 	u8 target_version_minor;
 	struct completion target_version_received;
 	enum ath10k_fw_htt_op_version op_version;
+	u8 max_num_amsdu;
+	u8 max_num_ampdu;
 
 	const enum htt_t2h_msg_type *t2h_msg_types;
 	u32 t2h_msg_types_max;
@@ -1482,6 +1484,12 @@ struct htt_rx_desc {
 #define HTT_LOG2_MAX_CACHE_LINE_SIZE 7	/* 2^7 = 128 */
 #define HTT_MAX_CACHE_LINE_SIZE_MASK ((1 << HTT_LOG2_MAX_CACHE_LINE_SIZE) - 1)
 
+/* These values are default in most firmware revisions and apparently are a
+ * sweet spot performance wise.
+ */
+#define ATH10K_HTT_MAX_NUM_AMSDU_DEFAULT 3
+#define ATH10K_HTT_MAX_NUM_AMPDU_DEFAULT 64
+
 int ath10k_htt_connect(struct ath10k_htt *htt);
 int ath10k_htt_init(struct ath10k *ar);
 int ath10k_htt_setup(struct ath10k_htt *htt);
diff --git a/drivers/net/wireless/ath/ath10k/htt_rx.c b/drivers/net/wireless/ath/ath10k/htt_rx.c
index 89eb16b..2a6267e 100644
--- a/drivers/net/wireless/ath/ath10k/htt_rx.c
+++ b/drivers/net/wireless/ath/ath10k/htt_rx.c
@@ -1017,9 +1017,8 @@ static void ath10k_htt_rx_h_undecap_raw(struct ath10k *ar,
 	skb_trim(msdu, msdu->len - FCS_LEN);
 
 	/* In most cases this will be true for sniffed frames. It makes sense
-	 * to deliver them as-is without stripping the crypto param. This would
-	 * also make sense for software based decryption (which is not
-	 * implemented in ath10k).
+	 * to deliver them as-is without stripping the crypto param. This is
+	 * necessary for software based decryption.
 	 *
 	 * If there's no error then the frame is decrypted. At least that is
 	 * the case for frames that come in via fragmented rx indication.
@@ -2074,6 +2073,8 @@ void ath10k_htt_t2h_msg_handler(struct ath10k *ar, struct sk_buff *skb)
 		break;
 	case HTT_T2H_MSG_TYPE_CHAN_CHANGE:
 		break;
+	case HTT_T2H_MSG_TYPE_AGGR_CONF:
+		break;
 	default:
 		ath10k_warn(ar, "htt event (%d) not handled\n",
 			    resp->hdr.msg_type);
diff --git a/drivers/net/wireless/ath/ath10k/htt_tx.c b/drivers/net/wireless/ath/ath10k/htt_tx.c
index a60ef7d..7c81560 100644
--- a/drivers/net/wireless/ath/ath10k/htt_tx.c
+++ b/drivers/net/wireless/ath/ath10k/htt_tx.c
@@ -450,8 +450,12 @@ int ath10k_htt_tx(struct ath10k_htt *htt, struct sk_buff *msdu)
 	if ((ieee80211_is_action(hdr->frame_control) ||
 	     ieee80211_is_deauth(hdr->frame_control) ||
 	     ieee80211_is_disassoc(hdr->frame_control)) &&
-	     ieee80211_has_protected(hdr->frame_control))
+	     ieee80211_has_protected(hdr->frame_control)) {
 		skb_put(msdu, IEEE80211_CCMP_MIC_LEN);
+	} else if (!skb_cb->htt.nohwcrypt &&
+		   skb_cb->txmode == ATH10K_HW_TXRX_RAW) {
+		skb_put(msdu, IEEE80211_CCMP_MIC_LEN);
+	}
 
 	skb_cb->paddr = dma_map_single(dev, msdu->data, msdu->len,
 				       DMA_TO_DEVICE);
@@ -508,12 +512,16 @@ int ath10k_htt_tx(struct ath10k_htt *htt, struct sk_buff *msdu)
 			prefetch_len);
 	skb_cb->htt.txbuf->htc_hdr.flags = 0;
 
+	if (skb_cb->htt.nohwcrypt)
+		flags0 |= HTT_DATA_TX_DESC_FLAGS0_NO_ENCRYPT;
+
 	if (!skb_cb->is_protected)
 		flags0 |= HTT_DATA_TX_DESC_FLAGS0_NO_ENCRYPT;
 
 	flags1 |= SM((u16)vdev_id, HTT_DATA_TX_DESC_FLAGS1_VDEV_ID);
 	flags1 |= SM((u16)tid, HTT_DATA_TX_DESC_FLAGS1_EXT_TID);
-	if (msdu->ip_summed == CHECKSUM_PARTIAL) {
+	if (msdu->ip_summed == CHECKSUM_PARTIAL &&
+	    !test_bit(ATH10K_FLAG_RAW_MODE, &ar->dev_flags)) {
 		flags1 |= HTT_DATA_TX_DESC_FLAGS1_CKSUM_L3_OFFLOAD;
 		flags1 |= HTT_DATA_TX_DESC_FLAGS1_CKSUM_L4_OFFLOAD;
 	}
diff --git a/drivers/net/wireless/ath/ath10k/hw.h b/drivers/net/wireless/ath/ath10k/hw.h
index 85cca29..5175e94 100644
--- a/drivers/net/wireless/ath/ath10k/hw.h
+++ b/drivers/net/wireless/ath/ath10k/hw.h
@@ -176,14 +176,16 @@ void ath10k_hw_fill_survey_time(struct ath10k *ar, struct survey_info *survey,
 #define QCA_REV_6174(ar) ((ar)->hw_rev == ATH10K_HW_QCA6174)
 
 /* Known pecularities:
- *  - current FW doesn't support raw rx mode (last tested v599)
- *  - current FW dumps upon raw tx mode (last tested v599)
  *  - raw appears in nwifi decap, raw and nwifi appear in ethernet decap
  *  - raw have FCS, nwifi doesn't
  *  - ethernet frames have 802.11 header decapped and parts (base hdr, cipher
  *    param, llc/snap) are aligned to 4byte boundaries each */
 enum ath10k_hw_txrx_mode {
 	ATH10K_HW_TXRX_RAW = 0,
+
+	/* Native Wifi decap mode is used to align IP frames to 4-byte
+	 * boundaries and avoid a very expensive re-alignment in mac80211.
+	 */
 	ATH10K_HW_TXRX_NATIVE_WIFI = 1,
 	ATH10K_HW_TXRX_ETHERNET = 2,
 
@@ -245,10 +247,6 @@ enum ath10k_hw_rate_cck {
 #define TARGET_RX_TIMEOUT_LO_PRI		100
 #define TARGET_RX_TIMEOUT_HI_PRI		40
 
-/* Native Wifi decap mode is used to align IP frames to 4-byte boundaries and
- * avoid a very expensive re-alignment in mac80211. */
-#define TARGET_RX_DECAP_MODE			ATH10K_HW_TXRX_NATIVE_WIFI
-
 #define TARGET_SCAN_MAX_PENDING_REQS		4
 #define TARGET_BMISS_OFFLOAD_MAX_VDEV		3
 #define TARGET_ROAM_OFFLOAD_MAX_VDEV		3
@@ -283,7 +281,6 @@ enum ath10k_hw_rate_cck {
 #define TARGET_10X_RX_CHAIN_MASK		(BIT(0) | BIT(1) | BIT(2))
 #define TARGET_10X_RX_TIMEOUT_LO_PRI		100
 #define TARGET_10X_RX_TIMEOUT_HI_PRI		40
-#define TARGET_10X_RX_DECAP_MODE		ATH10K_HW_TXRX_NATIVE_WIFI
 #define TARGET_10X_SCAN_MAX_PENDING_REQS	4
 #define TARGET_10X_BMISS_OFFLOAD_MAX_VDEV	2
 #define TARGET_10X_ROAM_OFFLOAD_MAX_VDEV	2
diff --git a/drivers/net/wireless/ath/ath10k/mac.c b/drivers/net/wireless/ath/ath10k/mac.c
index f4de717..6918cee 100644
--- a/drivers/net/wireless/ath/ath10k/mac.c
+++ b/drivers/net/wireless/ath/ath10k/mac.c
@@ -197,6 +197,10 @@ static int ath10k_send_key(struct ath10k_vif *arvif,
 		return -EOPNOTSUPP;
 	}
 
+	if (test_bit(ATH10K_FLAG_RAW_MODE, &ar->dev_flags)) {
+		key->flags |= IEEE80211_KEY_FLAG_GENERATE_IV;
+	}
+
 	if (cmd == DISABLE_KEY) {
 		arg.key_cipher = WMI_CIPHER_NONE;
 		arg.key_data = NULL;
@@ -218,6 +222,9 @@ static int ath10k_install_key(struct ath10k_vif *arvif,
 
 	reinit_completion(&ar->install_key_done);
 
+	if (arvif->nohwcrypt)
+		return 1;
+
 	ret = ath10k_send_key(arvif, key, cmd, macaddr, flags);
 	if (ret)
 		return ret;
@@ -256,7 +263,7 @@ static int ath10k_install_peer_wep_keys(struct ath10k_vif *arvif,
 
 		ret = ath10k_install_key(arvif, arvif->wep_keys[i], SET_KEY,
 					 addr, flags);
-		if (ret)
+		if (ret < 0)
 			return ret;
 
 		flags = 0;
@@ -264,7 +271,7 @@ static int ath10k_install_peer_wep_keys(struct ath10k_vif *arvif,
 
 		ret = ath10k_install_key(arvif, arvif->wep_keys[i], SET_KEY,
 					 addr, flags);
-		if (ret)
+		if (ret < 0)
 			return ret;
 
 		spin_lock_bh(&ar->data_lock);
@@ -322,10 +329,10 @@ static int ath10k_clear_peer_keys(struct ath10k_vif *arvif,
 		/* key flags are not required to delete the key */
 		ret = ath10k_install_key(arvif, peer->keys[i],
 					 DISABLE_KEY, addr, flags);
-		if (ret && first_errno == 0)
+		if (ret < 0 && first_errno == 0)
 			first_errno = ret;
 
-		if (ret)
+		if (ret < 0)
 			ath10k_warn(ar, "failed to remove peer wep key %d: %d\n",
 				    i, ret);
 
@@ -398,7 +405,7 @@ static int ath10k_clear_vdev_key(struct ath10k_vif *arvif,
 			break;
 		/* key flags are not required to delete the key */
 		ret = ath10k_install_key(arvif, key, DISABLE_KEY, addr, flags);
-		if (ret && first_errno == 0)
+		if (ret < 0 && first_errno == 0)
 			first_errno = ret;
 
 		if (ret)
@@ -3168,13 +3175,30 @@ ath10k_tx_h_get_txmode(struct ath10k *ar, struct ieee80211_vif *vif,
 	 * Some wmi-tlv firmwares for qca6174 have broken Tx key selection for
 	 * NativeWifi txmode - it selects AP key instead of peer key. It seems
 	 * to work with Ethernet txmode so use it.
+	 *
+	 * FIXME: Check if raw mode works with TDLS.
 	 */
 	if (ieee80211_is_data_present(fc) && sta && sta->tdls)
 		return ATH10K_HW_TXRX_ETHERNET;
 
+	if (test_bit(ATH10K_FLAG_RAW_MODE, &ar->dev_flags))
+		return ATH10K_HW_TXRX_RAW;
+
 	return ATH10K_HW_TXRX_NATIVE_WIFI;
 }
 
+static bool ath10k_tx_h_use_hwcrypto(struct ieee80211_vif *vif,
+				     struct sk_buff *skb) {
+	struct ieee80211_tx_info *info = IEEE80211_SKB_CB(skb);
+	const u32 mask = IEEE80211_TX_INTFL_DONT_ENCRYPT |
+			 IEEE80211_TX_CTL_INJECTED;
+	if ((info->flags & mask) == mask)
+		return false;
+	if (vif)
+		return !ath10k_vif_to_arvif(vif)->nohwcrypt;
+	return true;
+}
+
 /* HTT Tx uses Native Wifi tx mode which expects 802.11 frames without QoS
  * Control in the header.
  */
@@ -3620,6 +3644,7 @@ static void ath10k_tx(struct ieee80211_hw *hw,
 	ATH10K_SKB_CB(skb)->htt.is_offchan = false;
 	ATH10K_SKB_CB(skb)->htt.freq = 0;
 	ATH10K_SKB_CB(skb)->htt.tid = ath10k_tx_h_get_tid(hdr);
+	ATH10K_SKB_CB(skb)->htt.nohwcrypt = !ath10k_tx_h_use_hwcrypto(vif, skb);
 	ATH10K_SKB_CB(skb)->vdev_id = ath10k_tx_h_get_vdev_id(ar, vif);
 	ATH10K_SKB_CB(skb)->txmode = ath10k_tx_h_get_txmode(ar, vif, sta, skb);
 	ATH10K_SKB_CB(skb)->is_protected = ieee80211_has_protected(fc);
@@ -3635,12 +3660,11 @@ static void ath10k_tx(struct ieee80211_hw *hw,
 		ath10k_tx_h_8023(skb);
 		break;
 	case ATH10K_HW_TXRX_RAW:
-		/* FIXME: Packet injection isn't implemented. It should be
-		 * doable with firmware 10.2 on qca988x.
-		 */
-		WARN_ON_ONCE(1);
-		ieee80211_free_txskb(hw, skb);
-		return;
+		if (!test_bit(ATH10K_FLAG_RAW_MODE, &ar->dev_flags)) {
+			WARN_ON_ONCE(1);
+			ieee80211_free_txskb(hw, skb);
+			return;
+		}
 	}
 
 	if (info->flags & IEEE80211_TX_CTL_TX_OFFCHAN) {
@@ -4236,6 +4260,14 @@ static int ath10k_add_interface(struct ieee80211_hw *hw,
 			goto err;
 		}
 	}
+	if (test_bit(ATH10K_FLAG_HW_CRYPTO_DISABLED, &ar->dev_flags))
+		arvif->nohwcrypt = true;
+
+	if (arvif->nohwcrypt &&
+	    !test_bit(ATH10K_FLAG_RAW_MODE, &ar->dev_flags)) {
+		ath10k_warn(ar, "cryptmode module param needed for sw crypto\n");
+		goto err;
+	}
 
 	ath10k_dbg(ar, ATH10K_DBG_MAC, "mac vdev create %d (add interface) type %d subtype %d bcnmode %s\n",
 		   arvif->vdev_id, arvif->vdev_type, arvif->vdev_subtype,
@@ -4828,6 +4860,9 @@ static int ath10k_set_key(struct ieee80211_hw *hw, enum set_key_cmd cmd,
 	if (key->cipher == WLAN_CIPHER_SUITE_AES_CMAC)
 		return 1;
 
+	if (arvif->nohwcrypt)
+		return 1;
+
 	if (key->keyidx > WMI_MAX_KEY_INDEX)
 		return -ENOSPC;
 
@@ -4897,6 +4932,7 @@ static int ath10k_set_key(struct ieee80211_hw *hw, enum set_key_cmd cmd,
 
 	ret = ath10k_install_key(arvif, key, cmd, peer_addr, flags);
 	if (ret) {
+		WARN_ON(ret > 0);
 		ath10k_warn(ar, "failed to install key for vdev %i peer %pM: %d\n",
 			    arvif->vdev_id, peer_addr, ret);
 		goto exit;
@@ -4912,13 +4948,16 @@ static int ath10k_set_key(struct ieee80211_hw *hw, enum set_key_cmd cmd,
 
 		ret = ath10k_install_key(arvif, key, cmd, peer_addr, flags2);
 		if (ret) {
+			WARN_ON(ret > 0);
 			ath10k_warn(ar, "failed to install (ucast) key for vdev %i peer %pM: %d\n",
 				    arvif->vdev_id, peer_addr, ret);
 			ret2 = ath10k_install_key(arvif, key, DISABLE_KEY,
 						  peer_addr, flags);
-			if (ret2)
+			if (ret2) {
+				WARN_ON(ret2 > 0);
 				ath10k_warn(ar, "failed to disable (mcast) key for vdev %i peer %pM: %d\n",
 					    arvif->vdev_id, peer_addr, ret2);
+			}
 			goto exit;
 		}
 	}
@@ -6890,7 +6929,6 @@ int ath10k_mac_register(struct ath10k *ar)
 			IEEE80211_HW_HAS_RATE_CONTROL |
 			IEEE80211_HW_AP_LINK_PS |
 			IEEE80211_HW_SPECTRUM_MGMT |
-			IEEE80211_HW_SW_CRYPTO_CONTROL |
 			IEEE80211_HW_CONNECTION_MONITOR |
 			IEEE80211_HW_SUPPORTS_PER_STA_GTK |
 			IEEE80211_HW_WANT_MONITOR_VIF |
@@ -6898,6 +6936,9 @@ int ath10k_mac_register(struct ath10k *ar)
 			IEEE80211_HW_QUEUE_CONTROL |
 			IEEE80211_HW_SUPPORT_FAST_XMIT;
 
+	if (!test_bit(ATH10K_FLAG_RAW_MODE, &ar->dev_flags))
+		ar->hw->flags |= IEEE80211_HW_SW_CRYPTO_CONTROL;
+
 	ar->hw->wiphy->features |= NL80211_FEATURE_STATIC_SMPS;
 	ar->hw->wiphy->flags |= WIPHY_FLAG_IBSS_RSN;
 
@@ -6995,7 +7036,8 @@ int ath10k_mac_register(struct ath10k *ar)
 		goto err_free;
 	}
 
-	ar->hw->netdev_features = NETIF_F_HW_CSUM;
+	if (!test_bit(ATH10K_FLAG_RAW_MODE, &ar->dev_flags))
+		ar->hw->netdev_features = NETIF_F_HW_CSUM;
 
 	if (config_enabled(CONFIG_ATH10K_DFS_CERTIFIED)) {
 		/* Init ath dfs pattern detector */
diff --git a/drivers/net/wireless/ath/ath10k/wmi-tlv.c b/drivers/net/wireless/ath/ath10k/wmi-tlv.c
index 563fde7..20ee5a3 100644
--- a/drivers/net/wireless/ath/ath10k/wmi-tlv.c
+++ b/drivers/net/wireless/ath/ath10k/wmi-tlv.c
@@ -1334,7 +1334,7 @@ static struct sk_buff *ath10k_wmi_tlv_op_gen_init(struct ath10k *ar)
 	cfg->rx_timeout_pri[1] = __cpu_to_le32(0x64);
 	cfg->rx_timeout_pri[2] = __cpu_to_le32(0x64);
 	cfg->rx_timeout_pri[3] = __cpu_to_le32(0x28);
-	cfg->rx_decap_mode = __cpu_to_le32(1);
+	cfg->rx_decap_mode = __cpu_to_le32(ar->wmi.rx_decap_mode);
 	cfg->scan_max_pending_reqs = __cpu_to_le32(4);
 	cfg->bmiss_offload_max_vdev = __cpu_to_le32(TARGET_TLV_NUM_VDEVS);
 	cfg->roam_offload_max_vdev = __cpu_to_le32(TARGET_TLV_NUM_VDEVS);
diff --git a/drivers/net/wireless/ath/ath10k/wmi.c b/drivers/net/wireless/ath/ath10k/wmi.c
index 77220b0..dc12a53 100644
--- a/drivers/net/wireless/ath/ath10k/wmi.c
+++ b/drivers/net/wireless/ath/ath10k/wmi.c
@@ -3759,8 +3759,7 @@ static struct sk_buff *ath10k_wmi_op_gen_init(struct ath10k *ar)
 	config.rx_timeout_pri_vi = __cpu_to_le32(TARGET_RX_TIMEOUT_LO_PRI);
 	config.rx_timeout_pri_be = __cpu_to_le32(TARGET_RX_TIMEOUT_LO_PRI);
 	config.rx_timeout_pri_bk = __cpu_to_le32(TARGET_RX_TIMEOUT_HI_PRI);
-	config.rx_decap_mode = __cpu_to_le32(TARGET_RX_DECAP_MODE);
-
+	config.rx_decap_mode = __cpu_to_le32(ar->wmi.rx_decap_mode);
 	config.scan_max_pending_reqs =
 		__cpu_to_le32(TARGET_SCAN_MAX_PENDING_REQS);
 
@@ -3828,8 +3827,7 @@ static struct sk_buff *ath10k_wmi_10_1_op_gen_init(struct ath10k *ar)
 	config.rx_timeout_pri_vi = __cpu_to_le32(TARGET_10X_RX_TIMEOUT_LO_PRI);
 	config.rx_timeout_pri_be = __cpu_to_le32(TARGET_10X_RX_TIMEOUT_LO_PRI);
 	config.rx_timeout_pri_bk = __cpu_to_le32(TARGET_10X_RX_TIMEOUT_HI_PRI);
-	config.rx_decap_mode = __cpu_to_le32(TARGET_10X_RX_DECAP_MODE);
-
+	config.rx_decap_mode = __cpu_to_le32(ar->wmi.rx_decap_mode);
 	config.scan_max_pending_reqs =
 		__cpu_to_le32(TARGET_10X_SCAN_MAX_PENDING_REQS);
 
@@ -3894,7 +3892,7 @@ static struct sk_buff *ath10k_wmi_10_2_op_gen_init(struct ath10k *ar)
 	config.rx_timeout_pri_vi = __cpu_to_le32(TARGET_10X_RX_TIMEOUT_LO_PRI);
 	config.rx_timeout_pri_be = __cpu_to_le32(TARGET_10X_RX_TIMEOUT_LO_PRI);
 	config.rx_timeout_pri_bk = __cpu_to_le32(TARGET_10X_RX_TIMEOUT_HI_PRI);
-	config.rx_decap_mode = __cpu_to_le32(TARGET_10X_RX_DECAP_MODE);
+	config.rx_decap_mode = __cpu_to_le32(ar->wmi.rx_decap_mode);
 
 	config.scan_max_pending_reqs =
 		__cpu_to_le32(TARGET_10X_SCAN_MAX_PENDING_REQS);
-- 
2.1.4

