Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ig0-f178.google.com ([209.85.213.178]:36405 "EHLO
	mail-ig0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932071AbbEFBH1 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 5 May 2015 21:07:27 -0400
Received: by igblo3 with SMTP id lo3so116779516igb.1
        for <linux-wireless@vger.kernel.org>; Tue, 05 May 2015 18:07:26 -0700 (PDT)
MIME-Version: 1.0
From: "Liu CF/TW" <cfliu.tw@gmail.com>
Date: Tue, 5 May 2015 18:06:46 -0700
Message-ID: <CAG5N3qG7090vB6XoUaQSHvQw7GpE+gXvJAbKrv7def3nV0OFJw@mail.gmail.com> (sfid-20150506_030732_812060_D782B7B5)
Subject: [PATCH] ath10k/mac80211: add rawtxrx, nohwcrypt module param for raw
 tx injection, sw crypto support.
To: kvalo@qca.qualcomm.com,
	"ath10k@lists.infradead.org" <ath10k@lists.infradead.org>
Cc: linux-wireless@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

 - ath10k:   add rawtxrx param for 10.2+ firmware to support sw, hw crypto
             engine and raw Tx injection.
 - mac80211: Add IEEE80211_KEY_FLAG_RESERVE_TAILROOM support for TKIP and
             CCMP required by ath10k and add per BSS(vif) based sw_crypto
             control.

This change enables the raw Tx/Rx feature in ath10k 10.2+ firmware with a
module parameter 'rawtxrx'. With rawtxrx=1, the ath10k hardware crypto
engine could be optionally skipped to support use cases such as enabling
mac80211 sw crypto engine, user level crypto engine, raw Tx frame
injection.

ath10k hw supports hw encryption in both native wifi and raw encap mode.
SW may choose to skip hw crypto engine on per Tx frame or per STA
descriptor basis. This change implements per BSS based sw_crypto control
policy by adding the NL80211_ATTR_SW_CRYPTO attribute to nl80211.

This change also implements the classic 'nohwcrypt' module param in
ath9k/5k to globally disable the hardware engine. When sw crypto or raw
tx injection is used, 'rawtxrx=1' module param is required.

- ath10k_core module parameters:

  rawtxrx:   When set to 1, hw uses raw Tx encap (per frame), and raw Rx
                  decap (global, pdev setting) on datapath.

  nohwcrypt: When set to 1, disables HW crypto engine globally.

- mac80211 change:

  Support IEEE80211_KEY_FLAG_RESERVE_TAILROOM. Required for sw crypto
  to work for ath10k.

  Introduce NL80211_ATTR_SW_CRYPTO attribute as a per BSS parameter to
  selectively choose sw or hw crypto engine when BSS is created.

Testing: used QCA988x hw 2.0 with 10.2 firmware.

ath10k    ath10k     nl80211
rawtxrx   nohwcrypt  SW_CRYPTO
param     param      attribute    Testing Status
-------   ---------  ---------    ---------------------------------
   0          0           -         HW CCMP/TKIP tested ok.
   0          1           -         Not supported by ath10k hw.
   1          0           -         HW CCMP/TKIP tested ok.
   1          0           0         BSS 1 tested HW CCMP/TKIP ok.
   1          0           1         BSS 2 can bypass HW engine.
                                    - mac80211 SW crypto tested ok.
                                    - raw Tx frame injection tested ok.
   1          1           -         HW crypto globally disabled.
                                    - mac80211 SW crypto tested ok.
                                    - raw Tx frame injection tested ok.

Signed-off-by: David Liu <cfliu.tw@gmail.com>
---
 drivers/net/wireless/ath/ath10k/core.c   | 12 +++++++
 drivers/net/wireless/ath/ath10k/core.h   |  5 +++
 drivers/net/wireless/ath/ath10k/htt_rx.c |  3 +-
 drivers/net/wireless/ath/ath10k/htt_tx.c |  3 ++
 drivers/net/wireless/ath/ath10k/hw.h     |  2 +-
 drivers/net/wireless/ath/ath10k/mac.c    | 56 +++++++++++++++++++++++++++++---
 drivers/net/wireless/ath/ath10k/wmi.c    |  6 ++--
 include/net/cfg80211.h                   |  4 +++
 include/net/mac80211.h                   |  3 ++
 include/uapi/linux/nl80211.h             |  5 +++
 net/mac80211/cfg.c                       |  7 ++++
 net/mac80211/wpa.c                       | 24 +++++++++++---
 net/wireless/nl80211.c                   |  5 +++
 net/wireless/trace.h                     |  7 ++--
 14 files changed, 125 insertions(+), 17 deletions(-)

diff --git a/drivers/net/wireless/ath/ath10k/core.c
b/drivers/net/wireless/ath/ath10k/core.c
index bcccae1..d31597d 100644
--- a/drivers/net/wireless/ath/ath10k/core.c
+++ b/drivers/net/wireless/ath/ath10k/core.c
@@ -31,16 +31,22 @@
 #include "wmi-ops.h"

 unsigned int ath10k_debug_mask;
+bool ath10k_modparam_nohwcrypt;
+bool ath10k_modparam_rawtxrx;
 static bool uart_print;
 static bool skip_otp;

 module_param_named(debug_mask, ath10k_debug_mask, uint, 0644);
+module_param_named(nohwcrypt, ath10k_modparam_nohwcrypt, bool, 0644);
+module_param_named(rawtxrx, ath10k_modparam_rawtxrx, bool, 0644);
 module_param(uart_print, bool, 0644);
 module_param(skip_otp, bool, 0644);

 MODULE_PARM_DESC(debug_mask, "Debugging mask");
 MODULE_PARM_DESC(uart_print, "Uart target debugging");
 MODULE_PARM_DESC(skip_otp, "Skip otp failure for calibration in testmode");
+MODULE_PARM_DESC(nohwcrypt, "Disable hw crypto globally");
+MODULE_PARM_DESC(rxwtxrx, "Use raw encap/decap mode");

 static const struct ath10k_hw_params ath10k_hw_params_list[] = {
  {
@@ -990,6 +996,12 @@ static int
ath10k_core_init_firmware_features(struct ath10k *ar)
  return -EINVAL;
  }

+ if ((ath10k_modparam_rawtxrx || ath10k_modparam_nohwcrypt) &&
+    !test_bit(ATH10K_FW_FEATURE_WMI_10_2, ar->fw_features)) {
+ ath10k_err(ar, "rawtxrx mode supported only in 10.2+ firmware");
+ return -EINVAL;
+ }
+
  /* Backwards compatibility for firmwares without
  * ATH10K_FW_IE_WMI_OP_VERSION.
  */
diff --git a/drivers/net/wireless/ath/ath10k/core.h
b/drivers/net/wireless/ath/ath10k/core.h
index 827b3d7..1e7a5ca 100644
--- a/drivers/net/wireless/ath/ath10k/core.h
+++ b/drivers/net/wireless/ath/ath10k/core.h
@@ -66,6 +66,9 @@

 struct ath10k;

+extern bool ath10k_modparam_nohwcrypt;
+extern bool ath10k_modparam_rawtxrx;
+
 enum ath10k_bus {
  ATH10K_BUS_PCI,
 };
@@ -91,6 +94,7 @@ struct ath10k_skb_cb {
  u8 tid;
  u16 freq;
  bool is_offchan;
+ bool nohwcrypt;
  struct ath10k_htt_txbuf *txbuf;
  u32 txbuf_paddr;
  } __packed htt;
@@ -349,6 +353,7 @@ struct ath10k_vif {
  } u;

  bool use_cts_prot;
+ bool nohwcrypt;
  int num_legacy_stations;
  int txpower;
  struct wmi_wmm_params_all_arg wmm_params;
diff --git a/drivers/net/wireless/ath/ath10k/htt_rx.c
b/drivers/net/wireless/ath/ath10k/htt_rx.c
index b26e32f..29ec1ec 100644
--- a/drivers/net/wireless/ath/ath10k/htt_rx.c
+++ b/drivers/net/wireless/ath/ath10k/htt_rx.c
@@ -1012,8 +1012,7 @@ static void ath10k_htt_rx_h_undecap_raw(struct ath10k *ar,

  /* In most cases this will be true for sniffed frames. It makes sense
  * to deliver them as-is without stripping the crypto param. This would
- * also make sense for software based decryption (which is not
- * implemented in ath10k).
+ * also make sense for software based decryption.
  *
  * If there's no error then the frame is decrypted. At least that is
  * the case for frames that come in via fragmented rx indication.
diff --git a/drivers/net/wireless/ath/ath10k/htt_tx.c
b/drivers/net/wireless/ath/ath10k/htt_tx.c
index a60ef7d..18446d9 100644
--- a/drivers/net/wireless/ath/ath10k/htt_tx.c
+++ b/drivers/net/wireless/ath/ath10k/htt_tx.c
@@ -508,6 +508,9 @@ int ath10k_htt_tx(struct ath10k_htt *htt, struct
sk_buff *msdu)
  prefetch_len);
  skb_cb->htt.txbuf->htc_hdr.flags = 0;

+ if (skb_cb->htt.nohwcrypt)
+ flags0 |= HTT_DATA_TX_DESC_FLAGS0_NO_ENCRYPT;
+
  if (!skb_cb->is_protected)
  flags0 |= HTT_DATA_TX_DESC_FLAGS0_NO_ENCRYPT;

diff --git a/drivers/net/wireless/ath/ath10k/hw.h
b/drivers/net/wireless/ath/ath10k/hw.h
index 89e09cb..3d3bb9e 100644
--- a/drivers/net/wireless/ath/ath10k/hw.h
+++ b/drivers/net/wireless/ath/ath10k/hw.h
@@ -293,7 +293,7 @@ enum ath10k_hw_rate_cck {
 #define TARGET_10X_RX_SKIP_DEFRAG_TIMEOUT_DUP_DETECTION_CHECK 1
 #define TARGET_10X_VOW_CONFIG 0
 #define TARGET_10X_NUM_MSDU_DESC (1024 + 400)
-#define TARGET_10X_MAX_FRAG_ENTRIES 0
+#define TARGET_10X_MAX_FRAG_ENTRIES 10

 /* 10.2 parameters */
 #define TARGET_10_2_DMA_BURST_SIZE 1
diff --git a/drivers/net/wireless/ath/ath10k/mac.c
b/drivers/net/wireless/ath/ath10k/mac.c
index 425dbe2..8f34e79 100644
--- a/drivers/net/wireless/ath/ath10k/mac.c
+++ b/drivers/net/wireless/ath/ath10k/mac.c
@@ -172,6 +172,7 @@ static int ath10k_send_key(struct ath10k_vif *arvif,
  .key_flags = flags,
  .macaddr = macaddr,
  };
+ int ret;

  lockdep_assert_held(&arvif->ar->conf_mutex);

@@ -184,6 +185,9 @@ static int ath10k_send_key(struct ath10k_vif *arvif,
  arg.key_cipher = WMI_CIPHER_TKIP;
  arg.key_txmic_len = 8;
  arg.key_rxmic_len = 8;
+ if (ath10k_modparam_rawtxrx)
+ key->flags |= IEEE80211_KEY_FLAG_GENERATE_MMIC;
+
  break;
  case WLAN_CIPHER_SUITE_WEP40:
  case WLAN_CIPHER_SUITE_WEP104:
@@ -197,12 +201,24 @@ static int ath10k_send_key(struct ath10k_vif *arvif,
  return -EOPNOTSUPP;
  }

+ if (ath10k_modparam_rawtxrx) {
+ key->flags |= IEEE80211_KEY_FLAG_GENERATE_IV;
+ key->flags |= IEEE80211_KEY_FLAG_RESERVE_TAILROOM;
+ }
+
+ if (arvif->nohwcrypt)
+ cmd = DISABLE_KEY;
+
  if (cmd == DISABLE_KEY) {
  arg.key_cipher = WMI_CIPHER_NONE;
  arg.key_data = NULL;
  }

- return ath10k_wmi_vdev_install_key(arvif->ar, &arg);
+ ret = ath10k_wmi_vdev_install_key(arvif->ar, &arg);
+
+ if (arvif->nohwcrypt && !ret)
+ return -EOPNOTSUPP;
+ return ret;
 }

 static int ath10k_install_key(struct ath10k_vif *arvif,
@@ -3192,9 +3208,24 @@ ath10k_tx_h_get_txmode(struct ath10k *ar,
struct ieee80211_vif *vif,
  if (ieee80211_is_data_present(fc) && sta && sta->tdls)
  return ATH10K_HW_TXRX_ETHERNET;

+ if (ath10k_modparam_rawtxrx)
+ return ATH10K_HW_TXRX_RAW;
+
  return ATH10K_HW_TXRX_NATIVE_WIFI;
 }

+static bool ath10k_tx_h_use_hwcrypto(struct ieee80211_vif *vif,
+     struct sk_buff *skb) {
+ struct ieee80211_tx_info *info = IEEE80211_SKB_CB(skb);
+ const u32 mask = IEEE80211_TX_INTFL_DONT_ENCRYPT |
+ IEEE80211_TX_CTL_INJECTED;
+ if ((info->flags & mask) == mask)
+ return false;
+ if (vif)
+ return !ath10k_vif_to_arvif(vif)->nohwcrypt;
+ return true;
+}
+
 /* HTT Tx uses Native Wifi tx mode which expects 802.11 frames without QoS
  * Control in the header.
  */
@@ -3640,6 +3671,7 @@ static void ath10k_tx(struct ieee80211_hw *hw,
  ATH10K_SKB_CB(skb)->htt.is_offchan = false;
  ATH10K_SKB_CB(skb)->htt.freq = 0;
  ATH10K_SKB_CB(skb)->htt.tid = ath10k_tx_h_get_tid(hdr);
+ ATH10K_SKB_CB(skb)->htt.nohwcrypt = !ath10k_tx_h_use_hwcrypto(vif, skb);
  ATH10K_SKB_CB(skb)->vdev_id = ath10k_tx_h_get_vdev_id(ar, vif);
  ATH10K_SKB_CB(skb)->txmode = ath10k_tx_h_get_txmode(ar, vif, sta, skb);
  ATH10K_SKB_CB(skb)->is_protected = ieee80211_has_protected(fc);
@@ -3655,9 +3687,8 @@ static void ath10k_tx(struct ieee80211_hw *hw,
  ath10k_tx_h_8023(skb);
  break;
  case ATH10K_HW_TXRX_RAW:
- /* FIXME: Packet injection isn't implemented. It should be
- * doable with firmware 10.2 on qca988x.
- */
+ if (ath10k_modparam_rawtxrx)
+ break;
  WARN_ON_ONCE(1);
  ieee80211_free_txskb(hw, skb);
  return;
@@ -4154,6 +4185,7 @@ static int ath10k_add_interface(struct ieee80211_hw *hw,
  int bit;
  int i;
  u32 vdev_param;
+ u32 param_value;

  vif->driver_flags |= IEEE80211_VIF_SUPPORTS_UAPSD;

@@ -4257,6 +4289,14 @@ static int ath10k_add_interface(struct ieee80211_hw *hw,
  }
  }

+ if (ath10k_modparam_nohwcrypt || vif->sw_crypto)
+ arvif->nohwcrypt = true;
+
+ if (arvif->nohwcrypt && !ath10k_modparam_rawtxrx) {
+ ath10k_warn(ar, "rawtxrx module param needed for sw crypto\n");
+ goto err;
+ }
+
  ath10k_dbg(ar, ATH10K_DBG_MAC, "mac vdev create %d (add interface)
type %d subtype %d bcnmode %s\n",
    arvif->vdev_id, arvif->vdev_type, arvif->vdev_subtype,
    arvif->beacon_buf ? "single-buf" : "per-skb");
@@ -4285,8 +4325,14 @@ static int ath10k_add_interface(struct ieee80211_hw *hw,
  arvif->def_wep_key_idx = -1;

  vdev_param = ar->wmi.vdev_param->tx_encap_type;
+ if (ath10k_modparam_rawtxrx)
+ param_value = ATH10K_HW_TXRX_RAW;
+ else
+ param_value = ATH10K_HW_TXRX_NATIVE_WIFI;
+
  ret = ath10k_wmi_vdev_set_param(ar, arvif->vdev_id, vdev_param,
- ATH10K_HW_TXRX_NATIVE_WIFI);
+ param_value);
+
  /* 10.X firmware does not support this VDEV parameter. Do not warn */
  if (ret && ret != -EOPNOTSUPP) {
  ath10k_warn(ar, "failed to set vdev %i TX encapsulation: %d\n",
diff --git a/drivers/net/wireless/ath/ath10k/wmi.c
b/drivers/net/wireless/ath/ath10k/wmi.c
index ebaa096..d7e557b 100644
--- a/drivers/net/wireless/ath/ath10k/wmi.c
+++ b/drivers/net/wireless/ath/ath10k/wmi.c
@@ -507,7 +507,7 @@ static struct wmi_vdev_param_map wmi_10x_vdev_param_map = {
  .txbf = WMI_VDEV_PARAM_UNSUPPORTED,
  .packet_powersave = WMI_VDEV_PARAM_UNSUPPORTED,
  .drop_unencry = WMI_VDEV_PARAM_UNSUPPORTED,
- .tx_encap_type = WMI_VDEV_PARAM_UNSUPPORTED,
+ .tx_encap_type = WMI_10X_VDEV_PARAM_TX_ENCAP_TYPE,
  .ap_detect_out_of_sync_sleeping_sta_time_secs =
  WMI_10X_VDEV_PARAM_AP_DETECT_OUT_OF_SYNC_SLEEPING_STA_TIME_SECS,
 };
@@ -3891,7 +3891,9 @@ static struct sk_buff
*ath10k_wmi_10_2_op_gen_init(struct ath10k *ar)
  config.rx_timeout_pri_vi = __cpu_to_le32(TARGET_10X_RX_TIMEOUT_LO_PRI);
  config.rx_timeout_pri_be = __cpu_to_le32(TARGET_10X_RX_TIMEOUT_LO_PRI);
  config.rx_timeout_pri_bk = __cpu_to_le32(TARGET_10X_RX_TIMEOUT_HI_PRI);
- config.rx_decap_mode = __cpu_to_le32(TARGET_10X_RX_DECAP_MODE);
+ config.rx_decap_mode = __cpu_to_le32(ATH10K_HW_TXRX_NATIVE_WIFI);
+ if (ath10k_modparam_rawtxrx)
+ config.rx_decap_mode = __cpu_to_le32(ATH10K_HW_TXRX_RAW);

  config.scan_max_pending_reqs =
  __cpu_to_le32(TARGET_10X_SCAN_MAX_PENDING_REQS);
diff --git a/include/net/cfg80211.h b/include/net/cfg80211.h
index f8d6813..b41c71c 100644
--- a/include/net/cfg80211.h
+++ b/include/net/cfg80211.h
@@ -711,6 +711,7 @@ struct cfg80211_acl_data {
  * @p2p_opp_ps: P2P opportunistic PS
  * @acl: ACL configuration used by the drivers which has support for
  * MAC address based access control
+ * @sw_crypto: use software crypto engine.*
  */
 struct cfg80211_ap_settings {
  struct cfg80211_chan_def chandef;
@@ -729,6 +730,7 @@ struct cfg80211_ap_settings {
  u8 p2p_ctwindow;
  bool p2p_opp_ps;
  const struct cfg80211_acl_data *acl;
+ int sw_crypto;
 };

 /**
@@ -1210,6 +1212,7 @@ struct mpath_info {
  * @ap_isolate: do not forward packets between connected stations
  * @ht_opmode: HT Operation mode
  * (u16 = opmode, -1 = do not change)
+ * @sw_crypto: Use software crypto instead of hardware.
  * @p2p_ctwindow: P2P CT Window (-1 = no change)
  * @p2p_opp_ps: P2P opportunistic PS (-1 = no change)
  */
@@ -1221,6 +1224,7 @@ struct bss_parameters {
  u8 basic_rates_len;
  int ap_isolate;
  int ht_opmode;
+ int sw_crypto;
  s8 p2p_ctwindow, p2p_opp_ps;
 };

diff --git a/include/net/mac80211.h b/include/net/mac80211.h
index 3314298..5f45d02 100644
--- a/include/net/mac80211.h
+++ b/include/net/mac80211.h
@@ -1344,6 +1344,8 @@ enum ieee80211_vif_flags {
  * @csa_active: marks whether a channel switch is going on. Internally it is
  * write-protected by sdata_lock and local->mtx so holding either is fine
  * for read access.
+ * @sw_crypto: indicates frames on the BSS should be encrypted by software
+ * and bypass hardware crypto engine.
  * @driver_flags: flags/capabilities the driver has for this interface,
  * these need to be set (or cleared) when the interface is added
  * or, if supported by the driver, the interface type is changed
@@ -1368,6 +1370,7 @@ struct ieee80211_vif {
  u8 addr[ETH_ALEN];
  bool p2p;
  bool csa_active;
+ bool sw_crypto;

  u8 cab_queue;
  u8 hw_queue[IEEE80211_NUM_ACS];
diff --git a/include/uapi/linux/nl80211.h b/include/uapi/linux/nl80211.h
index 241220c..cdfa8a8 100644
--- a/include/uapi/linux/nl80211.h
+++ b/include/uapi/linux/nl80211.h
@@ -1761,6 +1761,9 @@ enum nl80211_commands {
  * @NL80211_ATTR_REG_INDOOR: flag attribute, if set indicates that the device
  *      is operating in an indoor environment.
  *
+ * @NL80211_ATTR_SW_CRYPTO: use software crypto instead of hardware crypto for
+ * the BSS.
+ *
  * @NUM_NL80211_ATTR: total number of nl80211_attrs available
  * @NL80211_ATTR_MAX: highest attribute number currently defined
  * @__NL80211_ATTR_AFTER_LAST: internal use
@@ -2130,6 +2133,8 @@ enum nl80211_attrs {

  NL80211_ATTR_REG_INDOOR,

+ NL80211_ATTR_SW_CRYPTO,
+
  /* add attributes here, update the policy in nl80211.c */

  __NL80211_ATTR_AFTER_LAST,
diff --git a/net/mac80211/cfg.c b/net/mac80211/cfg.c
index 72a0178..a50c9226 100644
--- a/net/mac80211/cfg.c
+++ b/net/mac80211/cfg.c
@@ -1889,6 +1889,13 @@ static int ieee80211_change_bss(struct wiphy *wiphy,
  sdata->flags &= ~IEEE80211_SDATA_DONT_BRIDGE_PACKETS;
  }

+ if (params->sw_crypto >= 0) {
+ if (params->sw_crypto)
+ sdata->vif.sw_crypto = true;
+ else
+ sdata->vif.sw_crypto = false;
+ }
+
  if (params->ht_opmode >= 0) {
  sdata->vif.bss_conf.ht_operation_mode =
  (u16) params->ht_opmode;
diff --git a/net/mac80211/wpa.c b/net/mac80211/wpa.c
index 9d63d93..b56f31a 100644
--- a/net/mac80211/wpa.c
+++ b/net/mac80211/wpa.c
@@ -192,7 +192,9 @@ static int tkip_encrypt_skb(struct
ieee80211_tx_data *tx, struct sk_buff *skb)

  if (info->control.hw_key &&
     !(info->control.hw_key->flags & IEEE80211_KEY_FLAG_GENERATE_IV) &&
-    !(info->control.hw_key->flags & IEEE80211_KEY_FLAG_PUT_IV_SPACE)) {
+    !(info->control.hw_key->flags & IEEE80211_KEY_FLAG_PUT_IV_SPACE) &&
+    !(info->control.hw_key->flags &
+      IEEE80211_KEY_FLAG_RESERVE_TAILROOM)) {
  /* hwaccel - with no need for software-generated IV */
  return 0;
  }
@@ -200,7 +202,8 @@ static int tkip_encrypt_skb(struct
ieee80211_tx_data *tx, struct sk_buff *skb)
  hdrlen = ieee80211_hdrlen(hdr->frame_control);
  len = skb->len - hdrlen;

- if (info->control.hw_key)
+ if (info->control.hw_key && !(info->control.hw_key->flags &
+      IEEE80211_KEY_FLAG_RESERVE_TAILROOM))
  tail = 0;
  else
  tail = IEEE80211_TKIP_ICV_LEN;
@@ -227,8 +230,12 @@ static int tkip_encrypt_skb(struct
ieee80211_tx_data *tx, struct sk_buff *skb)
  spin_unlock(&key->u.tkip.txlock);

  /* hwaccel - with software IV */
- if (info->control.hw_key)
+ if (info->control.hw_key) {
+ if (info->control.hw_key->flags &
+    IEEE80211_KEY_FLAG_RESERVE_TAILROOM)
+ skb_put(skb, tail);
  return 0;
+ }

  /* Add room for ICV */
  skb_put(skb, IEEE80211_TKIP_ICV_LEN);
@@ -411,6 +418,8 @@ static int ccmp_encrypt_skb(struct
ieee80211_tx_data *tx, struct sk_buff *skb,
  if (info->control.hw_key &&
     !(info->control.hw_key->flags & IEEE80211_KEY_FLAG_GENERATE_IV) &&
     !(info->control.hw_key->flags & IEEE80211_KEY_FLAG_PUT_IV_SPACE) &&
+    !(info->control.hw_key->flags &
+       IEEE80211_KEY_FLAG_RESERVE_TAILROOM) &&
     !((info->control.hw_key->flags &
        IEEE80211_KEY_FLAG_GENERATE_IV_MGMT) &&
       ieee80211_is_mgmt(hdr->frame_control))) {
@@ -424,7 +433,8 @@ static int ccmp_encrypt_skb(struct
ieee80211_tx_data *tx, struct sk_buff *skb,
  hdrlen = ieee80211_hdrlen(hdr->frame_control);
  len = skb->len - hdrlen;

- if (info->control.hw_key)
+ if (info->control.hw_key && !(info->control.hw_key->flags &
+      IEEE80211_KEY_FLAG_RESERVE_TAILROOM))
  tail = 0;
  else
  tail = mic_len;
@@ -456,8 +466,12 @@ static int ccmp_encrypt_skb(struct
ieee80211_tx_data *tx, struct sk_buff *skb,
  ccmp_pn2hdr(pos, pn, key->conf.keyidx);

  /* hwaccel - with software CCMP header */
- if (info->control.hw_key)
+ if (info->control.hw_key) {
+ if (info->control.hw_key->flags &
+    IEEE80211_KEY_FLAG_RESERVE_TAILROOM)
+ skb_put(skb, tail);
  return 0;
+ }

  pos += IEEE80211_CCMP_HDR_LEN;
  ccmp_special_blocks(skb, pn, b_0, aad);
diff --git a/net/wireless/nl80211.c b/net/wireless/nl80211.c
index 8a33bba..c2dea0e 100644
--- a/net/wireless/nl80211.c
+++ b/net/wireless/nl80211.c
@@ -4851,6 +4851,7 @@ static int nl80211_set_bss(struct sk_buff *skb,
struct genl_info *info)
  params.use_short_preamble = -1;
  params.use_short_slot_time = -1;
  params.ap_isolate = -1;
+ params.sw_crypto = -1;
  params.ht_opmode = -1;
  params.p2p_ctwindow = -1;
  params.p2p_opp_ps = -1;
@@ -4901,6 +4902,10 @@ static int nl80211_set_bss(struct sk_buff *skb,
struct genl_info *info)
     !(rdev->wiphy.features & NL80211_FEATURE_P2P_GO_OPPPS))
  return -EINVAL;
  }
+ if (info->attrs[NL80211_ATTR_SW_CRYPTO]) {
+ params.sw_crypto =
+    !!nla_get_u8(info->attrs[NL80211_ATTR_SW_CRYPTO]);
+ }

  if (!rdev->ops->change_bss)
  return -EOPNOTSUPP;
diff --git a/net/wireless/trace.h b/net/wireless/trace.h
index af3617c..c411a20 100644
--- a/net/wireless/trace.h
+++ b/net/wireless/trace.h
@@ -986,6 +986,7 @@ TRACE_EVENT(rdev_change_bss,
  __field(int, use_short_preamble)
  __field(int, use_short_slot_time)
  __field(int, ap_isolate)
+ __field(int, sw_crypto)
  __field(int, ht_opmode)
  ),
  TP_fast_assign(
@@ -995,14 +996,16 @@ TRACE_EVENT(rdev_change_bss,
  __entry->use_short_preamble = params->use_short_preamble;
  __entry->use_short_slot_time = params->use_short_slot_time;
  __entry->ap_isolate = params->ap_isolate;
+ __entry->sw_crypto = params->sw_crypto;
  __entry->ht_opmode = params->ht_opmode;
  ),
  TP_printk(WIPHY_PR_FMT ", " NETDEV_PR_FMT ", use cts prot: %d, "
   "use short preamble: %d, use short slot time: %d, "
-  "ap isolate: %d, ht opmode: %d",
+  "ap isolate: %d, sw_crypto: %d, ht opmode: %d",
   WIPHY_PR_ARG, NETDEV_PR_ARG, __entry->use_cts_prot,
   __entry->use_short_preamble, __entry->use_short_slot_time,
-  __entry->ap_isolate, __entry->ht_opmode)
+  __entry->ap_isolate, __entry->sw_crypto,
+  __entry->ht_opmode)
 );

 TRACE_EVENT(rdev_set_txq_params,
-- 
2.2.0.rc0.207.ga3a616c
