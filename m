Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ie0-f180.google.com ([209.85.223.180]:35382 "EHLO
	mail-ie0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752228AbbFIBNY (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 8 Jun 2015 21:13:24 -0400
Received: by iesa3 with SMTP id a3so4975818ies.2
        for <linux-wireless@vger.kernel.org>; Mon, 08 Jun 2015 18:13:23 -0700 (PDT)
From: Liu CF/TW <cfliu.tw@gmail.com>
To: kvalo@qca.qualcomm.com, ath10k@lists.infradead.org
Cc: linux-wireless@vger.kernel.org, Liu CF/TW <cfliu.tw@gmail.com>
Subject: [PATCH v3] ath10k: add 'cryptmode' param to support raw tx injection and software crypto
Date: Mon,  8 Jun 2015 18:13:02 -0700
Message-Id: <1433812382-10287-1-git-send-email-cfliu.tw@gmail.com> (sfid-20150609_031328_801209_F75D9F2E)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This change supports hardware crypto engine bypass by enabling raw
Rx/Tx encap mode. This enables use cases such as software crypto and raw
tx injection. This change introduces a new module param 'cryptmode'.

cryptmode:

  0: Use hardware crypto engine globally with native Wi-Fi mode TX/RX
     encapsulation to the firmware. This is the default mode.
  1: Use sofware crypto engine globally with raw mode TX/RX encapsulation
     to the firmware.
  2: Supports both hardware and software crypto with raw mode TX/RX
     encapsulation to the firmware. By default hardware crypto engine is
     used. To use software crypto in this mode, set the per ath10k_vif
     'nohwcrypt' flag value to True.*
     *) The patch for setting vif specific 'nohwcrypt' flag when
        cryptmode=2 would be a separate patch to mac80211.

Possible use case examples:

  - Use software crypto engine in mac80211. (cryptmode=1)

  - Support inject raw unencrypted frame on monitor interface and use
    hardware crypto to encrypt the injected Tx frames. (cryptmode=2)

  - Support receive raw hardware decrypted frame with encryption header
    on monitor interface. (cryptmode=2)

  - Support hybrid local & split MAC mode to support tunneling protocols
    such as CAPWAP: Use hardware crypto for BSS in local mode,
    and bypass hardware crypto for BSS in split MAC mode.
    (cryptmode=2, ath10k_vif nohwcrypt=0 for local mode, =1 for split MAC
     mode)

Testing:

  Used QCA988x hw 2.0 with firmware-4.bin_10.2.4.48 with
  backports-20150424.

  All test case tested** with hostapd in both WPA2-PSK-TKIP (11g) and
  WPA2-PSK-CCMP(11n/ac). Verified ping and http to google.com works.

  **) Need to skip ATH10K_FW_FEATURE_RAW_MODE_SUPPORT check in core.c to
  test firmware. After all, none of the existing QCA official firmware
  exports that firmware bit yet.

  Test Case                                        cryptmode value tested
  ---------------------------------------------    ----------------------
  1. ath10k hardware crypto can encrypt/decrypt       0: PASS
     data frames when hostapd config the BSS in       1: Not applicable.
     WPA2-PSK-TKIP and WPA2-PSK-CCMP modes.           2: PASS

  2. mac80211 software crypto can encrypt/decrypt     0: Not applicable
     data frames when hostapd config the BSS in       1: PASS
     WPA2-PSK-TKIP and WPA2-PSK-CCMP modes.           2: PASS, when vif
                                                         nohwcrypt=1

  3. Monitor interface Tx: User application can       0: Not applicable
     inject unencrypted raw Tx frames to monitor      1: PASS (mac80211)
     interface for mac80211 or hardware to encrypt    2: PASS (hardware)
     the frames.

  4. Monitor interface Rx: mac80211 software crypto   0: Not applicable
     engine can decrypt received TKIP/CCMP frames.    1: PASS
     User application see decrypted frames.           2: PASS, when vif
                                                         nohwcrypt=1

  5. CAPWAP-like local and split MAC datapath         0: Not applicable
     tunneling: Setup BSS1=Local MAC mode on wlan0,   1: Not applicable
     BSS2=Split MAC mode on wlan0_monitor interface.  2: PASS
     Test BSS1 data frames can be encrypted and 
     decrypted by ath10k hardware crypto engine 
     while BSS2 data frames can skip both hardware &
     kernel mac80211 crypto engines via monitor
     interface to the user application fot tunneling.

Signed-off-by: Liu CF/TW <cfliu.tw@gmail.com>
---
 drivers/net/wireless/ath/ath10k/core.c    | 31 ++++++++++++++++++
 drivers/net/wireless/ath/ath10k/core.h    | 33 +++++++++++++++++--
 drivers/net/wireless/ath/ath10k/debug.c   |  5 +--
 drivers/net/wireless/ath/ath10k/htt_rx.c  |  5 ++-
 drivers/net/wireless/ath/ath10k/htt_tx.c  |  9 +++++-
 drivers/net/wireless/ath/ath10k/hw.h      | 11 +++----
 drivers/net/wireless/ath/ath10k/mac.c     | 54 ++++++++++++++++++++++++++-----
 drivers/net/wireless/ath/ath10k/wmi-tlv.c |  2 +-
 drivers/net/wireless/ath/ath10k/wmi.c     |  8 ++---
 9 files changed, 129 insertions(+), 29 deletions(-)

diff --git a/drivers/net/wireless/ath/ath10k/core.c b/drivers/net/wireless/ath/ath10k/core.c
index 59496a9..ea1c43f 100644
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
+MODULE_PARM_DESC(cryptmode, "Crypto mode: 0-hardware, 1-software, 2-both");
 
 static const struct ath10k_hw_params ath10k_hw_params_list[] = {
 	{
@@ -991,6 +994,34 @@ static int ath10k_core_init_firmware_features(struct ath10k *ar)
 		return -EINVAL;
 	}
 
+	ar->wmi.rx_decap_mode = __cpu_to_le32(ATH10K_HW_TXRX_NATIVE_WIFI);
+	switch (ath10k_cryptmode_param) {
+	case ATH10K_CRYPT_MODE_HW:
+		clear_bit(ATH10K_FLAG_RAW_MODE, &ar->dev_flags);
+		clear_bit(ATH10K_FLAG_HW_CRYPTO_DISABLED, &ar->dev_flags);
+		break;
+	case ATH10K_CRYPT_MODE_SW:
+	case ATH10K_CRYPT_MODE_HW_SW:
+		if (!test_bit(ATH10K_FW_FEATURE_RAW_MODE_SUPPORT,
+			      ar->fw_features)) {
+			ath10k_err(ar, "cryptmode > 0 requires raw mode support from firmware");
+			return -EINVAL;
+		}
+
+		set_bit(ATH10K_FLAG_RAW_MODE, &ar->dev_flags);
+
+		if (ath10k_cryptmode_param == ATH10K_CRYPT_MODE_SW)
+			set_bit(ATH10K_FLAG_HW_CRYPTO_DISABLED, &ar->dev_flags);
+		break;
+	default:
+		ath10k_info(ar, "invalid cryptmode: %d\n",
+			    ath10k_cryptmode_param);
+		return -EINVAL;
+	}
+
+	if (test_bit(ATH10K_FLAG_RAW_MODE, &ar->dev_flags))
+		ar->wmi.rx_decap_mode = __cpu_to_le32(ATH10K_HW_TXRX_RAW);
+
 	/* Backwards compatibility for firmwares without
 	 * ATH10K_FW_IE_WMI_OP_VERSION.
 	 */
diff --git a/drivers/net/wireless/ath/ath10k/core.h b/drivers/net/wireless/ath/ath10k/core.h
index 45f9603..72bd19e 100644
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
@@ -461,16 +464,21 @@ enum ath10k_fw_features {
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
@@ -484,6 +492,15 @@ enum ath10k_dev_flags {
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
@@ -492,6 +509,18 @@ enum ath10k_cal_mode {
 	ATH10K_CAL_MODE_DT,
 };
 
+enum ath10k_crypt_mode {
+	/* Only use hardware crypto engine */
+	ATH10K_CRYPT_MODE_HW,
+	/* Only use software crypto engine */
+	ATH10K_CRYPT_MODE_SW,
+	/* Support both hardware and software crypto engines.
+	 * Set the nohwcrypt flag in ath10k_vif to true to use software
+	 * crypto.
+	 */
+	ATH10K_CRYPT_MODE_HW_SW,
+};
+
 static inline const char *ath10k_cal_mode_str(enum ath10k_cal_mode mode)
 {
 	switch (mode) {
diff --git a/drivers/net/wireless/ath/ath10k/debug.c b/drivers/net/wireless/ath/ath10k/debug.c
index 8fa606a..6ad9284 100644
--- a/drivers/net/wireless/ath/ath10k/debug.c
+++ b/drivers/net/wireless/ath/ath10k/debug.c
@@ -124,7 +124,7 @@ EXPORT_SYMBOL(ath10k_info);
 
 void ath10k_print_driver_info(struct ath10k *ar)
 {
-	ath10k_info(ar, "%s (0x%08x, 0x%08x%s%s%s) fw %s api %d htt %d.%d wmi %d cal %s max_sta %d\n",
+	ath10k_info(ar, "%s (0x%08x, 0x%08x%s%s%s) fw %s api %d htt %d.%d wmi %d cal %s max_sta %d flags 0x%lu\n",
 		    ar->hw_params.name,
 		    ar->target_version,
 		    ar->chip_id,
@@ -138,7 +138,8 @@ void ath10k_print_driver_info(struct ath10k *ar)
 		    ar->htt.target_version_minor,
 		    ar->wmi.op_version,
 		    ath10k_cal_mode_str(ar->cal_mode),
-		    ar->max_num_stations);
+		    ar->max_num_stations,
+		    ar->dev_flags);
 	ath10k_info(ar, "debug %d debugfs %d tracing %d dfs %d testmode %d\n",
 		    config_enabled(CONFIG_ATH10K_DEBUG),
 		    config_enabled(CONFIG_ATH10K_DEBUGFS),
diff --git a/drivers/net/wireless/ath/ath10k/htt_rx.c b/drivers/net/wireless/ath/ath10k/htt_rx.c
index 89eb16b..5758e3d 100644
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
diff --git a/drivers/net/wireless/ath/ath10k/htt_tx.c b/drivers/net/wireless/ath/ath10k/htt_tx.c
index a60ef7d..7099e91 100644
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
@@ -508,6 +512,9 @@ int ath10k_htt_tx(struct ath10k_htt *htt, struct sk_buff *msdu)
 			prefetch_len);
 	skb_cb->htt.txbuf->htc_hdr.flags = 0;
 
+	if (skb_cb->htt.nohwcrypt)
+		flags0 |= HTT_DATA_TX_DESC_FLAGS0_NO_ENCRYPT;
+
 	if (!skb_cb->is_protected)
 		flags0 |= HTT_DATA_TX_DESC_FLAGS0_NO_ENCRYPT;
 
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
index f4de717..b6685a8 100644
--- a/drivers/net/wireless/ath/ath10k/mac.c
+++ b/drivers/net/wireless/ath/ath10k/mac.c
@@ -172,6 +172,7 @@ static int ath10k_send_key(struct ath10k_vif *arvif,
 		.key_flags = flags,
 		.macaddr = macaddr,
 	};
+	int ret;
 
 	lockdep_assert_held(&arvif->ar->conf_mutex);
 
@@ -197,12 +198,22 @@ static int ath10k_send_key(struct ath10k_vif *arvif,
 		return -EOPNOTSUPP;
 	}
 
+	if (test_bit(ATH10K_FLAG_RAW_MODE, &ar->dev_flags))
+		key->flags |= IEEE80211_KEY_FLAG_GENERATE_IV;
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
@@ -3168,13 +3179,30 @@ ath10k_tx_h_get_txmode(struct ath10k *ar, struct ieee80211_vif *vif,
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
@@ -3620,6 +3648,7 @@ static void ath10k_tx(struct ieee80211_hw *hw,
 	ATH10K_SKB_CB(skb)->htt.is_offchan = false;
 	ATH10K_SKB_CB(skb)->htt.freq = 0;
 	ATH10K_SKB_CB(skb)->htt.tid = ath10k_tx_h_get_tid(hdr);
+	ATH10K_SKB_CB(skb)->htt.nohwcrypt = !ath10k_tx_h_use_hwcrypto(vif, skb);
 	ATH10K_SKB_CB(skb)->vdev_id = ath10k_tx_h_get_vdev_id(ar, vif);
 	ATH10K_SKB_CB(skb)->txmode = ath10k_tx_h_get_txmode(ar, vif, sta, skb);
 	ATH10K_SKB_CB(skb)->is_protected = ieee80211_has_protected(fc);
@@ -3635,12 +3664,11 @@ static void ath10k_tx(struct ieee80211_hw *hw,
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
@@ -4236,6 +4264,14 @@ static int ath10k_add_interface(struct ieee80211_hw *hw,
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
@@ -6890,7 +6926,6 @@ int ath10k_mac_register(struct ath10k *ar)
 			IEEE80211_HW_HAS_RATE_CONTROL |
 			IEEE80211_HW_AP_LINK_PS |
 			IEEE80211_HW_SPECTRUM_MGMT |
-			IEEE80211_HW_SW_CRYPTO_CONTROL |
 			IEEE80211_HW_CONNECTION_MONITOR |
 			IEEE80211_HW_SUPPORTS_PER_STA_GTK |
 			IEEE80211_HW_WANT_MONITOR_VIF |
@@ -6898,6 +6933,9 @@ int ath10k_mac_register(struct ath10k *ar)
 			IEEE80211_HW_QUEUE_CONTROL |
 			IEEE80211_HW_SUPPORT_FAST_XMIT;
 
+	if (!test_bit(ATH10K_FLAG_RAW_MODE, &ar->dev_flags))
+		ar->hw->flags |= IEEE80211_HW_SW_CRYPTO_CONTROL;
+
 	ar->hw->wiphy->features |= NL80211_FEATURE_STATIC_SMPS;
 	ar->hw->wiphy->flags |= WIPHY_FLAG_IBSS_RSN;
 
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

