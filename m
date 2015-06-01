Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ig0-f181.google.com ([209.85.213.181]:36181 "EHLO
	mail-ig0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750812AbbFAToY (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 1 Jun 2015 15:44:24 -0400
Received: by igbpi8 with SMTP id pi8so70036941igb.1
        for <linux-wireless@vger.kernel.org>; Mon, 01 Jun 2015 12:44:23 -0700 (PDT)
From: David Liu <cfliu.tw@gmail.com>
To: ath10k@lists.infradead.org
Cc: linux-wireless@vger.kernel.org, kvalo@qca.qualcomm.com,
	David Liu <cfliu.tw@gmail.com>
Subject: [PATCH 1/2]     ath10k: add cryptmode param to support sw crypto and raw tx injection.
Date: Mon,  1 Jun 2015 12:44:03 -0700
Message-Id: <1433187843-20698-1-git-send-email-cfliu.tw@gmail.com> (sfid-20150601_214428_313476_DEE9ABA6)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

    This change supports bypassing HW crypto engine by enabling raw Rx/Tx mode.
    This will enable use cases such as sw crypto and raw tx injection.
    This change introduces a new module param 'cryptmode'.

    cryptmode:

       0    Use HW crypto engine. Use native WiFi mode Tx/Rx encap

       1    Use SW crypto engine. Use raw mode Tx/Rx encap

       2    Supports both SW & HW crypto engine. Use raw mode Tx/Rx encap.

    Testing: used QCA988x hw 2.0 with 10.2 firmware.

    ath10k
    cryptmode
    param      Testing Status
    -------    ---------------------------------
       0       HW CCMP/TKIP tested ok.
               Note: HW crypto bypass not supported by ath10k hw in native WiFi
               mode.

       1       - mac80211 SW crypto tested ok. (Req. mac80211 change)
               - raw Tx frame injection tested ok.

       2       HW CCMP/TKIP tested ok.
               - BSS 1 tested HW CCMP/TKIP ok.
               - BSS 2 can bypass HW engine.
                 - Tested mac80211 cam do SW crypto. (Req. mac80211 change)
                 - Tested raw Tx encrypted frame injection.

Signed-off-by: David Liu <cfliu.tw@gmail.com>
---
 drivers/net/wireless/ath/ath10k/core.c   | 17 +++++++++
 drivers/net/wireless/ath/ath10k/core.h   | 24 ++++++++++++-
 drivers/net/wireless/ath/ath10k/htt_rx.c |  3 +-
 drivers/net/wireless/ath/ath10k/htt_tx.c |  3 ++
 drivers/net/wireless/ath/ath10k/hw.h     |  2 +-
 drivers/net/wireless/ath/ath10k/mac.c    | 61 +++++++++++++++++++++++++++-----
 drivers/net/wireless/ath/ath10k/wmi.c    |  6 ++--
 7 files changed, 102 insertions(+), 14 deletions(-)

diff --git a/drivers/net/wireless/ath/ath10k/core.c b/drivers/net/wireless/ath/ath10k/core.c
index 59496a9..e91fc85 100644
--- a/drivers/net/wireless/ath/ath10k/core.c
+++ b/drivers/net/wireless/ath/ath10k/core.c
@@ -31,16 +31,19 @@
 #include "wmi-ops.h"
 
 unsigned int ath10k_debug_mask;
+bool ath10k_cryptmode_param;
 static bool uart_print;
 static bool skip_otp;
 
 module_param_named(debug_mask, ath10k_debug_mask, uint, 0644);
+module_param_named(cryptmode, ath10k_cryptmode_param, bool, 0644);
 module_param(uart_print, bool, 0644);
 module_param(skip_otp, bool, 0644);
 
 MODULE_PARM_DESC(debug_mask, "Debugging mask");
 MODULE_PARM_DESC(uart_print, "Uart target debugging");
 MODULE_PARM_DESC(skip_otp, "Skip otp failure for calibration in testmode");
+MODULE_PARM_DESC(cryptmode, "Crypto mode - 0: HW only, 1: SW only, 2:Both");
 
 static const struct ath10k_hw_params ath10k_hw_params_list[] = {
 	{
@@ -991,6 +994,20 @@ static int ath10k_core_init_firmware_features(struct ath10k *ar)
 		return -EINVAL;
 	}
 
+	if (ath10k_cryptmode_param == ATH10K_CRYPT_MODE_HW) {
+		clear_bit(ATH10K_RAW_MODE, &ar->dev_flags);
+		clear_bit(ATH10K_HW_CRYPTO_DISABLED, &ar->dev_flags);
+	} else {
+		if (!test_bit(ATH10K_FW_FEATURE_RAW_MODE_SUPPORT,
+			      ar->fw_features)) {
+			ath10k_err(ar, "cryptmode > 0 requires raw mode support from firmware");
+			return -EINVAL;
+		}
+		set_bit(ATH10K_RAW_MODE, &ar->dev_flags);
+		if (ath10k_cryptmode_param == ATH10K_CRYPT_MODE_SW)
+			set_bit(ATH10K_HW_CRYPTO_DISABLED, &ar->dev_flags);
+	}
+
 	/* Backwards compatibility for firmwares without
 	 * ATH10K_FW_IE_WMI_OP_VERSION.
 	 */
diff --git a/drivers/net/wireless/ath/ath10k/core.h b/drivers/net/wireless/ath/ath10k/core.h
index 45f9603..13799c8 100644
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
@@ -349,6 +350,7 @@ struct ath10k_vif {
 	} u;
 
 	bool use_cts_prot;
+	bool nohwcrypt;
 	int num_legacy_stations;
 	int txpower;
 	struct wmi_wmm_params_all_arg wmm_params;
@@ -461,7 +463,12 @@ enum ath10k_fw_features {
 	ATH10K_FW_FEATURE_WOWLAN_SUPPORT = 6,
 
 	/* Don't trust error code from otp.bin */
-	ATH10K_FW_FEATURE_IGNORE_OTP_RESULT,
+	ATH10K_FW_FEATURE_IGNORE_OTP_RESULT = 7,
+
+	/* Raw mode support. If supported, FW supports receiving and trasmitting
+	 * frames in raw mode
+	 */
+	ATH10K_FW_FEATURE_RAW_MODE_SUPPORT = 8,
 
 	/* Some firmware revisions pad 4th hw address to 4 byte boundary making
 	 * it 8 bytes long in Native Wifi Rx decap.
@@ -484,6 +491,12 @@ enum ath10k_dev_flags {
 	 * waiters should immediately cancel instead of waiting for a time out.
 	 */
 	ATH10K_FLAG_CRASH_FLUSH,
+
+	/* Use Raw mode for Tx and Rx */
+	ATH10K_RAW_MODE,
+
+	/* Disable HW crypto engine */
+	ATH10K_HW_CRYPTO_DISABLED,
 };
 
 enum ath10k_cal_mode {
@@ -492,6 +505,15 @@ enum ath10k_cal_mode {
 	ATH10K_CAL_MODE_DT,
 };
 
+enum ath10k_crypt_mode {
+	/* Use HW crypto engine only */
+	ATH10K_CRYPT_MODE_HW,
+	/* HW SW crypto engine only (ie. HW crypto engine disabled) */
+	ATH10K_CRYPT_MODE_SW,
+	/* Both SW & HW crypto engine supported */
+	ATH10K_CRYPT_MODE_HW_SW,
+};
+
 static inline const char *ath10k_cal_mode_str(enum ath10k_cal_mode mode)
 {
 	switch (mode) {
diff --git a/drivers/net/wireless/ath/ath10k/htt_rx.c b/drivers/net/wireless/ath/ath10k/htt_rx.c
index 89eb16b..a7df05d 100644
--- a/drivers/net/wireless/ath/ath10k/htt_rx.c
+++ b/drivers/net/wireless/ath/ath10k/htt_rx.c
@@ -1018,8 +1018,7 @@ static void ath10k_htt_rx_h_undecap_raw(struct ath10k *ar,
 
 	/* In most cases this will be true for sniffed frames. It makes sense
 	 * to deliver them as-is without stripping the crypto param. This would
-	 * also make sense for software based decryption (which is not
-	 * implemented in ath10k).
+	 * also make sense for software based decryption.
 	 *
 	 * If there's no error then the frame is decrypted. At least that is
 	 * the case for frames that come in via fragmented rx indication.
diff --git a/drivers/net/wireless/ath/ath10k/htt_tx.c b/drivers/net/wireless/ath/ath10k/htt_tx.c
index a60ef7d..18446d9 100644
--- a/drivers/net/wireless/ath/ath10k/htt_tx.c
+++ b/drivers/net/wireless/ath/ath10k/htt_tx.c
@@ -508,6 +508,9 @@ int ath10k_htt_tx(struct ath10k_htt *htt, struct sk_buff *msdu)
 			prefetch_len);
 	skb_cb->htt.txbuf->htc_hdr.flags = 0;
 
+	if (skb_cb->htt.nohwcrypt)
+		flags0 |= HTT_DATA_TX_DESC_FLAGS0_NO_ENCRYPT;
+
 	if (!skb_cb->is_protected)
 		flags0 |= HTT_DATA_TX_DESC_FLAGS0_NO_ENCRYPT;
 
diff --git a/drivers/net/wireless/ath/ath10k/hw.h b/drivers/net/wireless/ath/ath10k/hw.h
index 85cca29..37fd2f83 100644
--- a/drivers/net/wireless/ath/ath10k/hw.h
+++ b/drivers/net/wireless/ath/ath10k/hw.h
@@ -296,7 +296,7 @@ enum ath10k_hw_rate_cck {
 #define TARGET_10X_RX_SKIP_DEFRAG_TIMEOUT_DUP_DETECTION_CHECK 1
 #define TARGET_10X_VOW_CONFIG			0
 #define TARGET_10X_NUM_MSDU_DESC		(1024 + 400)
-#define TARGET_10X_MAX_FRAG_ENTRIES		0
+#define TARGET_10X_MAX_FRAG_ENTRIES		10
 
 /* 10.2 parameters */
 #define TARGET_10_2_DMA_BURST_SIZE		1
diff --git a/drivers/net/wireless/ath/ath10k/mac.c b/drivers/net/wireless/ath/ath10k/mac.c
index f4de717..d83e933 100644
--- a/drivers/net/wireless/ath/ath10k/mac.c
+++ b/drivers/net/wireless/ath/ath10k/mac.c
@@ -172,6 +172,7 @@ static int ath10k_send_key(struct ath10k_vif *arvif,
 		.key_flags = flags,
 		.macaddr = macaddr,
 	};
+	int ret;
 
 	lockdep_assert_held(&arvif->ar->conf_mutex);
 
@@ -184,6 +185,9 @@ static int ath10k_send_key(struct ath10k_vif *arvif,
 		arg.key_cipher = WMI_CIPHER_TKIP;
 		arg.key_txmic_len = 8;
 		arg.key_rxmic_len = 8;
+		if (test_bit(ATH10K_RAW_MODE, &ar->dev_flags))
+			key->flags |= IEEE80211_KEY_FLAG_GENERATE_MMIC;
+
 		break;
 	case WLAN_CIPHER_SUITE_WEP40:
 	case WLAN_CIPHER_SUITE_WEP104:
@@ -197,12 +201,24 @@ static int ath10k_send_key(struct ath10k_vif *arvif,
 		return -EOPNOTSUPP;
 	}
 
+	if (test_bit(ATH10K_RAW_MODE, &ar->dev_flags)) {
+		key->flags |= IEEE80211_KEY_FLAG_GENERATE_IV;
+		key->flags |= IEEE80211_KEY_FLAG_RESERVE_TAILROOM;
+	}
+
+	if (arvif->nohwcrypt)
+		cmd = DISABLE_KEY;
+
 	if (cmd == DISABLE_KEY) {
 		arg.key_cipher = WMI_CIPHER_NONE;
 		arg.key_data = NULL;
 	}
 
-	return ath10k_wmi_vdev_install_key(arvif->ar, &arg);
+	ret = ath10k_wmi_vdev_install_key(arvif->ar, &arg);
+
+	if (arvif->nohwcrypt && !ret)
+		return -EOPNOTSUPP;
+	return ret;
 }
 
 static int ath10k_install_key(struct ath10k_vif *arvif,
@@ -3172,9 +3188,24 @@ ath10k_tx_h_get_txmode(struct ath10k *ar, struct ieee80211_vif *vif,
 	if (ieee80211_is_data_present(fc) && sta && sta->tdls)
 		return ATH10K_HW_TXRX_ETHERNET;
 
+	if (test_bit(ATH10K_RAW_MODE, &ar->dev_flags))
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
@@ -3620,6 +3651,7 @@ static void ath10k_tx(struct ieee80211_hw *hw,
 	ATH10K_SKB_CB(skb)->htt.is_offchan = false;
 	ATH10K_SKB_CB(skb)->htt.freq = 0;
 	ATH10K_SKB_CB(skb)->htt.tid = ath10k_tx_h_get_tid(hdr);
+	ATH10K_SKB_CB(skb)->htt.nohwcrypt = !ath10k_tx_h_use_hwcrypto(vif, skb);
 	ATH10K_SKB_CB(skb)->vdev_id = ath10k_tx_h_get_vdev_id(ar, vif);
 	ATH10K_SKB_CB(skb)->txmode = ath10k_tx_h_get_txmode(ar, vif, sta, skb);
 	ATH10K_SKB_CB(skb)->is_protected = ieee80211_has_protected(fc);
@@ -3635,12 +3667,11 @@ static void ath10k_tx(struct ieee80211_hw *hw,
 		ath10k_tx_h_8023(skb);
 		break;
 	case ATH10K_HW_TXRX_RAW:
-		/* FIXME: Packet injection isn't implemented. It should be
-		 * doable with firmware 10.2 on qca988x.
-		 */
-		WARN_ON_ONCE(1);
-		ieee80211_free_txskb(hw, skb);
-		return;
+		if (!test_bit(ATH10K_RAW_MODE, &ar->dev_flags)) {
+			WARN_ON_ONCE(1);
+			ieee80211_free_txskb(hw, skb);
+			return;
+		}
 	}
 
 	if (info->flags & IEEE80211_TX_CTL_TX_OFFCHAN) {
@@ -4134,6 +4165,7 @@ static int ath10k_add_interface(struct ieee80211_hw *hw,
 	int bit;
 	int i;
 	u32 vdev_param;
+	u32 param_value;
 
 	vif->driver_flags |= IEEE80211_VIF_SUPPORTS_UAPSD;
 
@@ -4236,6 +4268,13 @@ static int ath10k_add_interface(struct ieee80211_hw *hw,
 			goto err;
 		}
 	}
+	if (test_bit(ATH10K_HW_CRYPTO_DISABLED, &ar->dev_flags))
+		arvif->nohwcrypt = true;
+
+	if (arvif->nohwcrypt && !test_bit(ATH10K_RAW_MODE, &ar->dev_flags)) {
+		ath10k_warn(ar, "cryptmode module param needed for sw crypto\n");
+		goto err;
+	}
 
 	ath10k_dbg(ar, ATH10K_DBG_MAC, "mac vdev create %d (add interface) type %d subtype %d bcnmode %s\n",
 		   arvif->vdev_id, arvif->vdev_type, arvif->vdev_subtype,
@@ -4265,8 +4304,14 @@ static int ath10k_add_interface(struct ieee80211_hw *hw,
 	arvif->def_wep_key_idx = -1;
 
 	vdev_param = ar->wmi.vdev_param->tx_encap_type;
+	if (test_bit(ATH10K_RAW_MODE, &ar->dev_flags))
+		param_value = ATH10K_HW_TXRX_RAW;
+	else
+		param_value = ATH10K_HW_TXRX_NATIVE_WIFI;
+
 	ret = ath10k_wmi_vdev_set_param(ar, arvif->vdev_id, vdev_param,
-					ATH10K_HW_TXRX_NATIVE_WIFI);
+					param_value);
+
 	/* 10.X firmware does not support this VDEV parameter. Do not warn */
 	if (ret && ret != -EOPNOTSUPP) {
 		ath10k_warn(ar, "failed to set vdev %i TX encapsulation: %d\n",
diff --git a/drivers/net/wireless/ath/ath10k/wmi.c b/drivers/net/wireless/ath/ath10k/wmi.c
index 77220b0..1202150 100644
--- a/drivers/net/wireless/ath/ath10k/wmi.c
+++ b/drivers/net/wireless/ath/ath10k/wmi.c
@@ -508,7 +508,7 @@ static struct wmi_vdev_param_map wmi_10x_vdev_param_map = {
 	.txbf = WMI_VDEV_PARAM_UNSUPPORTED,
 	.packet_powersave = WMI_VDEV_PARAM_UNSUPPORTED,
 	.drop_unencry = WMI_VDEV_PARAM_UNSUPPORTED,
-	.tx_encap_type = WMI_VDEV_PARAM_UNSUPPORTED,
+	.tx_encap_type = WMI_10X_VDEV_PARAM_TX_ENCAP_TYPE,
 	.ap_detect_out_of_sync_sleeping_sta_time_secs =
 		WMI_10X_VDEV_PARAM_AP_DETECT_OUT_OF_SYNC_SLEEPING_STA_TIME_SECS,
 };
@@ -3894,7 +3894,9 @@ static struct sk_buff *ath10k_wmi_10_2_op_gen_init(struct ath10k *ar)
 	config.rx_timeout_pri_vi = __cpu_to_le32(TARGET_10X_RX_TIMEOUT_LO_PRI);
 	config.rx_timeout_pri_be = __cpu_to_le32(TARGET_10X_RX_TIMEOUT_LO_PRI);
 	config.rx_timeout_pri_bk = __cpu_to_le32(TARGET_10X_RX_TIMEOUT_HI_PRI);
-	config.rx_decap_mode = __cpu_to_le32(TARGET_10X_RX_DECAP_MODE);
+	config.rx_decap_mode = __cpu_to_le32(ATH10K_HW_TXRX_NATIVE_WIFI);
+	if (test_bit(ATH10K_RAW_MODE, &ar->dev_flags))
+		config.rx_decap_mode = __cpu_to_le32(ATH10K_HW_TXRX_RAW);
 
 	config.scan_max_pending_reqs =
 		__cpu_to_le32(TARGET_10X_SCAN_MAX_PENDING_REQS);
-- 
2.1.4

