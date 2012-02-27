Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga14.intel.com ([143.182.124.37]:30285 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755313Ab2B0XTF (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 27 Feb 2012 18:19:05 -0500
From: Wey-Yi Guy <wey-yi.w.guy@intel.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org,
	Emmanuel Grumbach <emmanuel.grumbach@intel.com>,
	Wey-Yi Guy <wey-yi.w.guy@intel.com>
Subject: [PATCH 07/24] iwlwifi: virtualize the op_mode
Date: Mon, 27 Feb 2012 14:07:31 -0800
Message-Id: <1330380468-17674-8-git-send-email-wey-yi.w.guy@intel.com> (sfid-20120228_002022_893183_241771FB)
In-Reply-To: <1330380468-17674-1-git-send-email-wey-yi.w.guy@intel.com>
References: <1330380468-17674-1-git-send-email-wey-yi.w.guy@intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Emmanuel Grumbach <emmanuel.grumbach@intel.com>

Define the op_mode as an interface with its ops. All the functions
of the op_mode are "private", but its ops is made public in
iwl-op-mode.h.
The drv object starts the op_mode by using the start function in the
public ops.

Signed-off-by: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
Signed-off-by: Wey-Yi Guy <wey-yi.w.guy@intel.com>
---
 drivers/net/wireless/iwlwifi/iwl-agn-lib.c  |    2 +-
 drivers/net/wireless/iwlwifi/iwl-agn-rs.c   |   16 +++-
 drivers/net/wireless/iwlwifi/iwl-agn-rxon.c |    4 +-
 drivers/net/wireless/iwlwifi/iwl-agn.c      |   32 +++++---
 drivers/net/wireless/iwlwifi/iwl-dev.h      |    8 ++
 drivers/net/wireless/iwlwifi/iwl-drv.c      |    6 +-
 drivers/net/wireless/iwlwifi/iwl-mac80211.c |   62 ++++++++-------
 drivers/net/wireless/iwlwifi/iwl-op-mode.h  |  108 +++++++++++++++++++++++++++
 drivers/net/wireless/iwlwifi/iwl-shared.h   |    4 -
 drivers/net/wireless/iwlwifi/iwl-testmode.c |   20 +++---
 drivers/net/wireless/iwlwifi/iwl-ucode.c    |    5 +-
 drivers/net/wireless/iwlwifi/iwl-wifi.h     |    2 +
 12 files changed, 204 insertions(+), 65 deletions(-)
 create mode 100644 drivers/net/wireless/iwlwifi/iwl-op-mode.h

diff --git a/drivers/net/wireless/iwlwifi/iwl-agn-lib.c b/drivers/net/wireless/iwlwifi/iwl-agn-lib.c
index c368433..5be0d36 100644
--- a/drivers/net/wireless/iwlwifi/iwl-agn-lib.c
+++ b/drivers/net/wireless/iwlwifi/iwl-agn-lib.c
@@ -959,7 +959,7 @@ static void iwlagn_wowlan_program_keys(struct ieee80211_hw *hw,
 			       struct ieee80211_key_conf *key,
 			       void *_data)
 {
-	struct iwl_priv *priv = hw->priv;
+	struct iwl_priv *priv = IWL_MAC80211_GET_DVM(hw);
 	struct wowlan_key_data *data = _data;
 	struct iwl_rxon_context *ctx = data->ctx;
 	struct aes_sc *aes_sc, *aes_tx_sc = NULL;
diff --git a/drivers/net/wireless/iwlwifi/iwl-agn-rs.c b/drivers/net/wireless/iwlwifi/iwl-agn-rs.c
index f88e2e3..a7d6713 100644
--- a/drivers/net/wireless/iwlwifi/iwl-agn-rs.c
+++ b/drivers/net/wireless/iwlwifi/iwl-agn-rs.c
@@ -38,6 +38,7 @@
 #include "iwl-dev.h"
 #include "iwl-core.h"
 #include "iwl-agn.h"
+#include "iwl-op-mode.h"
 
 #define RS_NAME "iwl-agn-rs"
 
@@ -909,7 +910,8 @@ static void rs_tx_status(void *priv_r, struct ieee80211_supported_band *sband,
 	struct iwl_lq_sta *lq_sta = priv_sta;
 	struct iwl_link_quality_cmd *table;
 	struct ieee80211_hdr *hdr = (struct ieee80211_hdr *)skb->data;
-	struct iwl_priv *priv = (struct iwl_priv *)priv_r;
+	struct iwl_op_mode *op_mode = (struct iwl_op_mode *)priv_r;
+	struct iwl_priv *priv = IWL_OP_MODE_GET_DVM(op_mode);
 	struct ieee80211_tx_info *info = IEEE80211_SKB_CB(skb);
 	enum mac80211_rate_control_flags mac_flags;
 	u32 tx_rate;
@@ -2737,7 +2739,9 @@ static void rs_get_rate(void *priv_r, struct ieee80211_sta *sta, void *priv_sta,
 
 	struct sk_buff *skb = txrc->skb;
 	struct ieee80211_supported_band *sband = txrc->sband;
-	struct iwl_priv *priv __maybe_unused = (struct iwl_priv *)priv_r;
+	struct iwl_op_mode *op_mode __maybe_unused =
+			(struct iwl_op_mode *)priv_r;
+	struct iwl_priv *priv __maybe_unused = IWL_OP_MODE_GET_DVM(op_mode);
 	struct ieee80211_tx_info *info = IEEE80211_SKB_CB(skb);
 	struct iwl_lq_sta *lq_sta = priv_sta;
 	int rate_idx;
@@ -2805,9 +2809,10 @@ static void *rs_alloc_sta(void *priv_rate, struct ieee80211_sta *sta,
 			  gfp_t gfp)
 {
 	struct iwl_station_priv *sta_priv = (struct iwl_station_priv *) sta->drv_priv;
-	struct iwl_priv *priv;
+	struct iwl_op_mode *op_mode __maybe_unused =
+			(struct iwl_op_mode *)priv_rate;
+	struct iwl_priv *priv __maybe_unused = IWL_OP_MODE_GET_DVM(op_mode);
 
-	priv = (struct iwl_priv *)priv_rate;
 	IWL_DEBUG_RATE(priv, "create station rate scale window\n");
 
 	return &sta_priv->lq_sta;
@@ -3074,7 +3079,8 @@ static void rs_free(void *priv_rate)
 static void rs_free_sta(void *priv_r, struct ieee80211_sta *sta,
 			void *priv_sta)
 {
-	struct iwl_priv *priv __maybe_unused = priv_r;
+	struct iwl_op_mode *op_mode __maybe_unused = priv_r;
+	struct iwl_priv *priv __maybe_unused = IWL_OP_MODE_GET_DVM(op_mode);
 
 	IWL_DEBUG_RATE(priv, "enter\n");
 	IWL_DEBUG_RATE(priv, "leave\n");
diff --git a/drivers/net/wireless/iwlwifi/iwl-agn-rxon.c b/drivers/net/wireless/iwlwifi/iwl-agn-rxon.c
index 35dd7e3..73653a6 100644
--- a/drivers/net/wireless/iwlwifi/iwl-agn-rxon.c
+++ b/drivers/net/wireless/iwlwifi/iwl-agn-rxon.c
@@ -549,7 +549,7 @@ void iwlagn_config_ht40(struct ieee80211_conf *conf,
 
 int iwlagn_mac_config(struct ieee80211_hw *hw, u32 changed)
 {
-	struct iwl_priv *priv = hw->priv;
+	struct iwl_priv *priv = IWL_MAC80211_GET_DVM(hw);
 	struct iwl_rxon_context *ctx;
 	struct ieee80211_conf *conf = &hw->conf;
 	struct ieee80211_channel *channel = conf->channel;
@@ -805,7 +805,7 @@ void iwlagn_bss_info_changed(struct ieee80211_hw *hw,
 			     struct ieee80211_bss_conf *bss_conf,
 			     u32 changes)
 {
-	struct iwl_priv *priv = hw->priv;
+	struct iwl_priv *priv = IWL_MAC80211_GET_DVM(hw);
 	struct iwl_rxon_context *ctx = iwl_rxon_ctx_from_vif(vif);
 	int ret;
 	bool force = false;
diff --git a/drivers/net/wireless/iwlwifi/iwl-agn.c b/drivers/net/wireless/iwlwifi/iwl-agn.c
index 09f343c..dbef0f4 100644
--- a/drivers/net/wireless/iwlwifi/iwl-agn.c
+++ b/drivers/net/wireless/iwlwifi/iwl-agn.c
@@ -52,6 +52,7 @@
 #include "iwl-shared.h"
 #include "iwl-bus.h"
 #include "iwl-trans.h"
+#include "iwl-op-mode.h"
 
 /******************************************************************************
  *
@@ -1142,14 +1143,13 @@ static void iwl_debug_config(struct iwl_priv *priv)
 #endif
 }
 
-int iwl_op_mode_dvm_start(struct iwl_bus *bus,
-			  const struct iwl_trans_ops *trans_ops,
-			  struct iwl_cfg *cfg)
+static struct iwl_op_mode *iwl_op_mode_dvm_start(struct iwl_trans *trans)
 {
-	struct iwl_fw *fw = &nic(bus)->fw;
+	struct iwl_fw *fw = &nic(trans)->fw;
 	int err = 0;
 	struct iwl_priv *priv;
 	struct ieee80211_hw *hw;
+	struct iwl_op_mode *op_mode;
 	u16 num_mac;
 	u32 ucode_flags;
 
@@ -1158,18 +1158,21 @@ int iwl_op_mode_dvm_start(struct iwl_bus *bus,
 	 ************************/
 	hw = iwl_alloc_all();
 	if (!hw) {
-		pr_err("%s: Cannot allocate network device\n", cfg->name);
+		pr_err("%s: Cannot allocate network device\n",
+				cfg(trans)->name);
 		err = -ENOMEM;
 		goto out;
 	}
 
-	priv = hw->priv;
-	priv->shrd = bus->shrd;
+	op_mode = hw->priv;
+	op_mode->ops = &iwl_dvm_ops;
+	priv = IWL_OP_MODE_GET_DVM(op_mode);
+	priv->shrd = trans->shrd;
 	priv->shrd->priv = priv;
 
 	/* At this point both hw and priv are allocated. */
 
-	SET_IEEE80211_DEV(hw, trans(priv)->dev);
+	SET_IEEE80211_DEV(priv->hw, trans(priv)->dev);
 
 	/* show what debugging capabilities we have */
 	iwl_debug_config(priv);
@@ -1316,7 +1319,7 @@ int iwl_op_mode_dvm_start(struct iwl_bus *bus,
 			"failed to create debugfs files. Ignoring error: %d\n",
 			err);
 
-	return 0;
+	return op_mode;
 
 out_destroy_workqueue:
 	destroy_workqueue(priv->workqueue);
@@ -1328,11 +1331,14 @@ out_free_traffic_mem:
 	iwl_free_traffic_mem(priv);
 	ieee80211_free_hw(priv->hw);
 out:
-	return err;
+	op_mode = NULL;
+	return op_mode;
 }
 
-void iwl_op_mode_dvm_stop(struct iwl_priv *priv)
+static void iwl_op_mode_dvm_stop(struct iwl_op_mode *op_mode)
 {
+	struct iwl_priv *priv = IWL_OP_MODE_GET_DVM(op_mode);
+
 	wait_for_completion(&nic(priv)->request_firmware_complete);
 
 	IWL_DEBUG_INFO(priv, "*** UNLOAD DRIVER ***\n");
@@ -1374,6 +1380,10 @@ void iwl_op_mode_dvm_stop(struct iwl_priv *priv)
 	ieee80211_free_hw(priv->hw);
 }
 
+const struct iwl_op_mode_ops iwl_dvm_ops = {
+	.start = iwl_op_mode_dvm_start,
+	.stop = iwl_op_mode_dvm_stop,
+};
 
 /*****************************************************************************
  *
diff --git a/drivers/net/wireless/iwlwifi/iwl-dev.h b/drivers/net/wireless/iwlwifi/iwl-dev.h
index 494c696..479d328 100644
--- a/drivers/net/wireless/iwlwifi/iwl-dev.h
+++ b/drivers/net/wireless/iwlwifi/iwl-dev.h
@@ -50,6 +50,7 @@
 #include "iwl-bus.h"
 #include "iwl-trans.h"
 #include "iwl-shared.h"
+#include "iwl-op-mode.h"
 
 struct iwl_tx_queue;
 
@@ -710,6 +711,13 @@ struct iwl_wipan_noa_data {
 	u8 data[];
 };
 
+#define IWL_OP_MODE_GET_DVM(_iwl_op_mode) \
+	((struct iwl_priv *) ((_iwl_op_mode)->op_mode_specific))
+
+#define IWL_MAC80211_GET_DVM(_hw) \
+	((struct iwl_priv *) ((struct iwl_op_mode *) \
+	(_hw)->priv)->op_mode_specific)
+
 struct iwl_priv {
 
 	/*data shared among all the driver's layers */
diff --git a/drivers/net/wireless/iwlwifi/iwl-drv.c b/drivers/net/wireless/iwlwifi/iwl-drv.c
index db430c7..8ff5256 100644
--- a/drivers/net/wireless/iwlwifi/iwl-drv.c
+++ b/drivers/net/wireless/iwlwifi/iwl-drv.c
@@ -65,6 +65,7 @@
 #include "iwl-drv.h"
 #include "iwl-trans.h"
 #include "iwl-wifi.h"
+#include "iwl-op-mode.h"
 
 int iwl_drv_start(struct iwl_shared *shrd,
 		  struct iwl_trans *trans, struct iwl_cfg *cfg)
@@ -94,8 +95,9 @@ int iwl_drv_start(struct iwl_shared *shrd,
 
 void iwl_drv_stop(struct iwl_shared *shrd)
 {
-	iwl_op_mode_dvm_stop(shrd->priv);
+	/* op_mode can be NULL if its start failed */
+	if (shrd->nic->op_mode)
+		iwl_op_mode_stop(shrd->nic->op_mode);
 
 	kfree(shrd->nic);
 }
-
diff --git a/drivers/net/wireless/iwlwifi/iwl-mac80211.c b/drivers/net/wireless/iwlwifi/iwl-mac80211.c
index 9c29234..3ca89ab 100644
--- a/drivers/net/wireless/iwlwifi/iwl-mac80211.c
+++ b/drivers/net/wireless/iwlwifi/iwl-mac80211.c
@@ -53,6 +53,7 @@
 #include "iwl-shared.h"
 #include "iwl-bus.h"
 #include "iwl-trans.h"
+#include "iwl-op-mode.h"
 
 /*****************************************************************************
  *
@@ -305,7 +306,7 @@ static int __iwl_up(struct iwl_priv *priv)
 
 static int iwlagn_mac_start(struct ieee80211_hw *hw)
 {
-	struct iwl_priv *priv = hw->priv;
+	struct iwl_priv *priv = IWL_MAC80211_GET_DVM(hw);
 	int ret;
 
 	IWL_DEBUG_MAC80211(priv, "enter\n");
@@ -332,7 +333,7 @@ static int iwlagn_mac_start(struct ieee80211_hw *hw)
 
 static void iwlagn_mac_stop(struct ieee80211_hw *hw)
 {
-	struct iwl_priv *priv = hw->priv;
+	struct iwl_priv *priv = IWL_MAC80211_GET_DVM(hw);
 
 	IWL_DEBUG_MAC80211(priv, "enter\n");
 
@@ -362,7 +363,7 @@ static void iwlagn_mac_set_rekey_data(struct ieee80211_hw *hw,
 				      struct ieee80211_vif *vif,
 				      struct cfg80211_gtk_rekey_data *data)
 {
-	struct iwl_priv *priv = hw->priv;
+	struct iwl_priv *priv = IWL_MAC80211_GET_DVM(hw);
 
 	if (iwlagn_mod_params.sw_crypto)
 		return;
@@ -389,7 +390,7 @@ static void iwlagn_mac_set_rekey_data(struct ieee80211_hw *hw,
 static int iwlagn_mac_suspend(struct ieee80211_hw *hw,
 			      struct cfg80211_wowlan *wowlan)
 {
-	struct iwl_priv *priv = hw->priv;
+	struct iwl_priv *priv = IWL_MAC80211_GET_DVM(hw);
 	struct iwl_rxon_context *ctx = &priv->contexts[IWL_RXON_CTX_BSS];
 	int ret;
 
@@ -431,7 +432,7 @@ static int iwlagn_mac_suspend(struct ieee80211_hw *hw,
 
 static int iwlagn_mac_resume(struct ieee80211_hw *hw)
 {
-	struct iwl_priv *priv = hw->priv;
+	struct iwl_priv *priv = IWL_MAC80211_GET_DVM(hw);
 	struct iwl_rxon_context *ctx = &priv->contexts[IWL_RXON_CTX_BSS];
 	struct ieee80211_vif *vif;
 	unsigned long flags;
@@ -497,7 +498,7 @@ static int iwlagn_mac_resume(struct ieee80211_hw *hw)
 
 static void iwlagn_mac_tx(struct ieee80211_hw *hw, struct sk_buff *skb)
 {
-	struct iwl_priv *priv = hw->priv;
+	struct iwl_priv *priv = IWL_MAC80211_GET_DVM(hw);
 
 	IWL_DEBUG_TX(priv, "dev->xmit(%d bytes) at rate 0x%02x\n", skb->len,
 		     ieee80211_get_tx_rate(hw, IEEE80211_SKB_CB(skb))->bitrate);
@@ -512,7 +513,7 @@ static void iwlagn_mac_update_tkip_key(struct ieee80211_hw *hw,
 				       struct ieee80211_sta *sta,
 				       u32 iv32, u16 *phase1key)
 {
-	struct iwl_priv *priv = hw->priv;
+	struct iwl_priv *priv = IWL_MAC80211_GET_DVM(hw);
 
 	iwl_update_tkip_key(priv, vif, keyconf, sta, iv32, phase1key);
 }
@@ -522,7 +523,7 @@ static int iwlagn_mac_set_key(struct ieee80211_hw *hw, enum set_key_cmd cmd,
 			      struct ieee80211_sta *sta,
 			      struct ieee80211_key_conf *key)
 {
-	struct iwl_priv *priv = hw->priv;
+	struct iwl_priv *priv = IWL_MAC80211_GET_DVM(hw);
 	struct iwl_vif_priv *vif_priv = (void *)vif->drv_priv;
 	struct iwl_rxon_context *ctx = vif_priv->ctx;
 	int ret;
@@ -626,7 +627,7 @@ static int iwlagn_mac_ampdu_action(struct ieee80211_hw *hw,
 				   struct ieee80211_sta *sta, u16 tid, u16 *ssn,
 				   u8 buf_size)
 {
-	struct iwl_priv *priv = hw->priv;
+	struct iwl_priv *priv = IWL_MAC80211_GET_DVM(hw);
 	int ret = -EINVAL;
 	struct iwl_station_priv *sta_priv = (void *) sta->drv_priv;
 
@@ -692,7 +693,7 @@ static int iwlagn_mac_sta_add(struct ieee80211_hw *hw,
 			      struct ieee80211_vif *vif,
 			      struct ieee80211_sta *sta)
 {
-	struct iwl_priv *priv = hw->priv;
+	struct iwl_priv *priv = IWL_MAC80211_GET_DVM(hw);
 	struct iwl_station_priv *sta_priv = (void *)sta->drv_priv;
 	struct iwl_vif_priv *vif_priv = (void *)vif->drv_priv;
 	bool is_ap = vif->type == NL80211_IFTYPE_STATION;
@@ -735,7 +736,7 @@ static int iwlagn_mac_sta_add(struct ieee80211_hw *hw,
 static void iwlagn_mac_channel_switch(struct ieee80211_hw *hw,
 				struct ieee80211_channel_switch *ch_switch)
 {
-	struct iwl_priv *priv = hw->priv;
+	struct iwl_priv *priv = IWL_MAC80211_GET_DVM(hw);
 	const struct iwl_channel_info *ch_info;
 	struct ieee80211_conf *conf = &hw->conf;
 	struct ieee80211_channel *channel = ch_switch->channel;
@@ -822,7 +823,7 @@ static void iwlagn_configure_filter(struct ieee80211_hw *hw,
 				    unsigned int *total_flags,
 				    u64 multicast)
 {
-	struct iwl_priv *priv = hw->priv;
+	struct iwl_priv *priv = IWL_MAC80211_GET_DVM(hw);
 	__le32 filter_or = 0, filter_nand = 0;
 	struct iwl_rxon_context *ctx;
 
@@ -869,7 +870,7 @@ static void iwlagn_configure_filter(struct ieee80211_hw *hw,
 
 static void iwlagn_mac_flush(struct ieee80211_hw *hw, bool drop)
 {
-	struct iwl_priv *priv = hw->priv;
+	struct iwl_priv *priv = IWL_MAC80211_GET_DVM(hw);
 
 	mutex_lock(&priv->shrd->mutex);
 	IWL_DEBUG_MAC80211(priv, "enter\n");
@@ -906,7 +907,7 @@ static int iwlagn_mac_remain_on_channel(struct ieee80211_hw *hw,
 				     enum nl80211_channel_type channel_type,
 				     int duration)
 {
-	struct iwl_priv *priv = hw->priv;
+	struct iwl_priv *priv = IWL_MAC80211_GET_DVM(hw);
 	struct iwl_rxon_context *ctx = &priv->contexts[IWL_RXON_CTX_PAN];
 	int err = 0;
 
@@ -996,7 +997,7 @@ static int iwlagn_mac_remain_on_channel(struct ieee80211_hw *hw,
 
 static int iwlagn_mac_cancel_remain_on_channel(struct ieee80211_hw *hw)
 {
-	struct iwl_priv *priv = hw->priv;
+	struct iwl_priv *priv = IWL_MAC80211_GET_DVM(hw);
 
 	if (!(priv->shrd->valid_contexts & BIT(IWL_RXON_CTX_PAN)))
 		return -EOPNOTSUPP;
@@ -1016,7 +1017,7 @@ static int iwlagn_mac_tx_sync(struct ieee80211_hw *hw,
 			      const u8 *bssid,
 			      enum ieee80211_tx_sync_type type)
 {
-	struct iwl_priv *priv = hw->priv;
+	struct iwl_priv *priv = IWL_MAC80211_GET_DVM(hw);
 	struct iwl_vif_priv *vif_priv = (void *)vif->drv_priv;
 	struct iwl_rxon_context *ctx = vif_priv->ctx;
 	int ret;
@@ -1070,7 +1071,7 @@ static void iwlagn_mac_finish_tx_sync(struct ieee80211_hw *hw,
 				   const u8 *bssid,
 				   enum ieee80211_tx_sync_type type)
 {
-	struct iwl_priv *priv = hw->priv;
+	struct iwl_priv *priv = IWL_MAC80211_GET_DVM(hw);
 	struct iwl_vif_priv *vif_priv = (void *)vif->drv_priv;
 	struct iwl_rxon_context *ctx = vif_priv->ctx;
 
@@ -1094,7 +1095,7 @@ static void iwlagn_mac_finish_tx_sync(struct ieee80211_hw *hw,
 static void iwlagn_mac_rssi_callback(struct ieee80211_hw *hw,
 			   enum ieee80211_rssi_event rssi_event)
 {
-	struct iwl_priv *priv = hw->priv;
+	struct iwl_priv *priv = IWL_MAC80211_GET_DVM(hw);
 
 	IWL_DEBUG_MAC80211(priv, "enter\n");
 	mutex_lock(&priv->shrd->mutex);
@@ -1119,7 +1120,7 @@ static void iwlagn_mac_rssi_callback(struct ieee80211_hw *hw,
 static int iwlagn_mac_set_tim(struct ieee80211_hw *hw,
 			   struct ieee80211_sta *sta, bool set)
 {
-	struct iwl_priv *priv = hw->priv;
+	struct iwl_priv *priv = IWL_MAC80211_GET_DVM(hw);
 
 	queue_work(priv->workqueue, &priv->beacon_update);
 
@@ -1130,7 +1131,7 @@ static int iwlagn_mac_conf_tx(struct ieee80211_hw *hw,
 		    struct ieee80211_vif *vif, u16 queue,
 		    const struct ieee80211_tx_queue_params *params)
 {
-	struct iwl_priv *priv = hw->priv;
+	struct iwl_priv *priv = IWL_MAC80211_GET_DVM(hw);
 	struct iwl_vif_priv *vif_priv = (void *)vif->drv_priv;
 	struct iwl_rxon_context *ctx = vif_priv->ctx;
 	unsigned long flags;
@@ -1173,7 +1174,7 @@ static int iwlagn_mac_conf_tx(struct ieee80211_hw *hw,
 
 static int iwlagn_mac_tx_last_beacon(struct ieee80211_hw *hw)
 {
-	struct iwl_priv *priv = hw->priv;
+	struct iwl_priv *priv = IWL_MAC80211_GET_DVM(hw);
 
 	return priv->ibss_manager == IWL_IBSS_MANAGER;
 }
@@ -1227,7 +1228,7 @@ static int iwl_setup_interface(struct iwl_priv *priv,
 static int iwlagn_mac_add_interface(struct ieee80211_hw *hw,
 			     struct ieee80211_vif *vif)
 {
-	struct iwl_priv *priv = hw->priv;
+	struct iwl_priv *priv = IWL_MAC80211_GET_DVM(hw);
 	struct iwl_vif_priv *vif_priv = (void *)vif->drv_priv;
 	struct iwl_rxon_context *tmp, *ctx = NULL;
 	int err;
@@ -1324,7 +1325,7 @@ static void iwl_teardown_interface(struct iwl_priv *priv,
 static void iwlagn_mac_remove_interface(struct ieee80211_hw *hw,
 			      struct ieee80211_vif *vif)
 {
-	struct iwl_priv *priv = hw->priv;
+	struct iwl_priv *priv = IWL_MAC80211_GET_DVM(hw);
 	struct iwl_rxon_context *ctx = iwl_rxon_ctx_from_vif(vif);
 
 	IWL_DEBUG_MAC80211(priv, "enter\n");
@@ -1352,7 +1353,7 @@ static int iwlagn_mac_change_interface(struct ieee80211_hw *hw,
 				struct ieee80211_vif *vif,
 				enum nl80211_iftype newtype, bool newp2p)
 {
-	struct iwl_priv *priv = hw->priv;
+	struct iwl_priv *priv = IWL_MAC80211_GET_DVM(hw);
 	struct iwl_rxon_context *ctx = iwl_rxon_ctx_from_vif(vif);
 	struct iwl_rxon_context *bss_ctx = &priv->contexts[IWL_RXON_CTX_BSS];
 	struct iwl_rxon_context *tmp;
@@ -1438,7 +1439,7 @@ static int iwlagn_mac_hw_scan(struct ieee80211_hw *hw,
 		    struct ieee80211_vif *vif,
 		    struct cfg80211_scan_request *req)
 {
-	struct iwl_priv *priv = hw->priv;
+	struct iwl_priv *priv = IWL_MAC80211_GET_DVM(hw);
 	int ret;
 
 	IWL_DEBUG_MAC80211(priv, "enter\n");
@@ -1484,7 +1485,7 @@ static int iwlagn_mac_sta_remove(struct ieee80211_hw *hw,
 		       struct ieee80211_vif *vif,
 		       struct ieee80211_sta *sta)
 {
-	struct iwl_priv *priv = hw->priv;
+	struct iwl_priv *priv = IWL_MAC80211_GET_DVM(hw);
 	struct iwl_station_priv *sta_priv = (void *)sta->drv_priv;
 	int ret;
 
@@ -1523,7 +1524,7 @@ static void iwlagn_mac_sta_notify(struct ieee80211_hw *hw,
 			   enum sta_notify_cmd cmd,
 			   struct ieee80211_sta *sta)
 {
-	struct iwl_priv *priv = hw->priv;
+	struct iwl_priv *priv = IWL_MAC80211_GET_DVM(hw);
 	struct iwl_station_priv *sta_priv = (void *)sta->drv_priv;
 	int sta_id;
 
@@ -1591,15 +1592,18 @@ struct ieee80211_ops iwlagn_hw_ops = {
 struct ieee80211_hw *iwl_alloc_all(void)
 {
 	struct iwl_priv *priv;
+	struct iwl_op_mode *op_mode;
 	/* mac80211 allocates memory for this device instance, including
 	 *   space for this driver's private structure */
 	struct ieee80211_hw *hw;
 
-	hw = ieee80211_alloc_hw(sizeof(struct iwl_priv), &iwlagn_hw_ops);
+	hw = ieee80211_alloc_hw(sizeof(struct iwl_priv) +
+				sizeof(struct iwl_op_mode), &iwlagn_hw_ops);
 	if (!hw)
 		goto out;
 
-	priv = hw->priv;
+	op_mode = hw->priv;
+	priv = IWL_OP_MODE_GET_DVM(op_mode);
 	priv->hw = hw;
 
 out:
diff --git a/drivers/net/wireless/iwlwifi/iwl-op-mode.h b/drivers/net/wireless/iwlwifi/iwl-op-mode.h
new file mode 100644
index 0000000..c85c8dc
--- /dev/null
+++ b/drivers/net/wireless/iwlwifi/iwl-op-mode.h
@@ -0,0 +1,108 @@
+/******************************************************************************
+ *
+ * This file is provided under a dual BSD/GPLv2 license.  When using or
+ * redistributing this file, you may do so under either license.
+ *
+ * GPL LICENSE SUMMARY
+ *
+ * Copyright(c) 2007 - 2012 Intel Corporation. All rights reserved.
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of version 2 of the GNU General Public License as
+ * published by the Free Software Foundation.
+ *
+ * This program is distributed in the hope that it will be useful, but
+ * WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
+ * General Public License for more details.
+ *
+ * You should have received a copy of the GNU General Public License
+ * along with this program; if not, write to the Free Software
+ * Foundation, Inc., 51 Franklin Street, Fifth Floor, Boston, MA 02110,
+ * USA
+ *
+ * The full GNU General Public License is included in this distribution
+ * in the file called LICENSE.GPL.
+ *
+ * Contact Information:
+ *  Intel Linux Wireless <ilw@linux.intel.com>
+ * Intel Corporation, 5200 N.E. Elam Young Parkway, Hillsboro, OR 97124-6497
+ *
+ * BSD LICENSE
+ *
+ * Copyright(c) 2005 - 2012 Intel Corporation. All rights reserved.
+ * All rights reserved.
+ *
+ * Redistribution and use in source and binary forms, with or without
+ * modification, are permitted provided that the following conditions
+ * are met:
+ *
+ *  * Redistributions of source code must retain the above copyright
+ *    notice, this list of conditions and the following disclaimer.
+ *  * Redistributions in binary form must reproduce the above copyright
+ *    notice, this list of conditions and the following disclaimer in
+ *    the documentation and/or other materials provided with the
+ *    distribution.
+ *  * Neither the name Intel Corporation nor the names of its
+ *    contributors may be used to endorse or promote products derived
+ *    from this software without specific prior written permission.
+ *
+ * THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS
+ * "AS IS" AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT
+ * LIMITED TO, THE IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR
+ * A PARTICULAR PURPOSE ARE DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT
+ * OWNER OR CONTRIBUTORS BE LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL,
+ * SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT
+ * LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; LOSS OF USE,
+ * DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON ANY
+ * THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT
+ * (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE
+ * OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
+ *
+ *****************************************************************************/
+#ifndef __iwl_op_mode_h__
+#define __iwl_op_mode_h__
+
+struct iwl_op_mode;
+struct iwl_trans;
+
+/**
+ * struct iwl_op_mode_ops - op_mode specific operations
+ *
+ * All the handlers MUST be implemented
+ *
+ * @start: start the op_mode
+ *	May sleep
+ * @stop: stop the op_mode
+ *	May sleep
+ */
+struct iwl_op_mode_ops {
+	struct iwl_op_mode *(*start)(struct iwl_trans *trans);
+	void (*stop)(struct iwl_op_mode *op_mode);
+};
+
+/**
+ * struct iwl_op_mode - operational mode
+ *
+ * This holds an implementation of the mac80211 / fw API.
+ *
+ * @ops - pointer to its own ops
+ */
+struct iwl_op_mode {
+	const struct iwl_op_mode_ops *ops;
+	const struct iwl_trans *trans;
+
+	char op_mode_specific[0] __aligned(sizeof(void *));
+};
+
+static inline void iwl_op_mode_stop(struct iwl_op_mode *op_mode)
+{
+	op_mode->ops->stop(op_mode);
+}
+
+/*****************************************************
+* Op mode layers implementations
+******************************************************/
+extern const struct iwl_op_mode_ops iwl_dvm_ops;
+
+#endif /* __iwl_op_mode_h__ */
diff --git a/drivers/net/wireless/iwlwifi/iwl-shared.h b/drivers/net/wireless/iwlwifi/iwl-shared.h
index 392b33a..635e3eb 100644
--- a/drivers/net/wireless/iwlwifi/iwl-shared.h
+++ b/drivers/net/wireless/iwlwifi/iwl-shared.h
@@ -532,10 +532,6 @@ enum iwl_rxon_context_id {
 	NUM_IWL_RXON_CTX
 };
 
-int iwl_op_mode_dvm_start(struct iwl_bus *bus,
-			  const struct iwl_trans_ops *trans_ops,
-			  struct iwl_cfg *cfg);
-void iwl_op_mode_dvm_stop(struct iwl_priv *priv);
 struct iwl_device_cmd;
 int __must_check iwl_rx_dispatch(struct iwl_priv *priv,
 				 struct iwl_rx_mem_buffer *rxb,
diff --git a/drivers/net/wireless/iwlwifi/iwl-testmode.c b/drivers/net/wireless/iwlwifi/iwl-testmode.c
index 80955ed..e3cca66 100644
--- a/drivers/net/wireless/iwlwifi/iwl-testmode.c
+++ b/drivers/net/wireless/iwlwifi/iwl-testmode.c
@@ -255,7 +255,7 @@ void iwl_testmode_cleanup(struct iwl_priv *priv)
  */
 static int iwl_testmode_ucode(struct ieee80211_hw *hw, struct nlattr **tb)
 {
-	struct iwl_priv *priv = hw->priv;
+	struct iwl_priv *priv = IWL_MAC80211_GET_DVM(hw);
 	struct iwl_host_cmd cmd;
 	struct iwl_rx_packet *pkt;
 	struct sk_buff *skb;
@@ -341,7 +341,7 @@ nla_put_failure:
  */
 static int iwl_testmode_reg(struct ieee80211_hw *hw, struct nlattr **tb)
 {
-	struct iwl_priv *priv = hw->priv;
+	struct iwl_priv *priv = IWL_MAC80211_GET_DVM(hw);
 	u32 ofs, val32, cmd;
 	u8 val8;
 	struct sk_buff *skb;
@@ -458,7 +458,7 @@ cfg_init_calib_error:
  */
 static int iwl_testmode_driver(struct ieee80211_hw *hw, struct nlattr **tb)
 {
-	struct iwl_priv *priv = hw->priv;
+	struct iwl_priv *priv = IWL_MAC80211_GET_DVM(hw);
 	struct iwl_trans *trans = trans(priv);
 	struct sk_buff *skb;
 	unsigned char *rsp_data_ptr = NULL;
@@ -643,7 +643,7 @@ nla_put_failure:
  */
 static int iwl_testmode_trace(struct ieee80211_hw *hw, struct nlattr **tb)
 {
-	struct iwl_priv *priv = hw->priv;
+	struct iwl_priv *priv = IWL_MAC80211_GET_DVM(hw);
 	struct sk_buff *skb;
 	int status = 0;
 	struct device *dev = trans(priv)->dev;
@@ -718,7 +718,7 @@ static int iwl_testmode_trace_dump(struct ieee80211_hw *hw, struct nlattr **tb,
 				   struct sk_buff *skb,
 				   struct netlink_callback *cb)
 {
-	struct iwl_priv *priv = hw->priv;
+	struct iwl_priv *priv = IWL_MAC80211_GET_DVM(hw);
 	int idx, length;
 
 	if (priv->testmode_trace.trace_enabled &&
@@ -762,7 +762,7 @@ static int iwl_testmode_trace_dump(struct ieee80211_hw *hw, struct nlattr **tb,
  */
 static int iwl_testmode_ownership(struct ieee80211_hw *hw, struct nlattr **tb)
 {
-	struct iwl_priv *priv = hw->priv;
+	struct iwl_priv *priv = IWL_MAC80211_GET_DVM(hw);
 	u8 owner;
 
 	if (!tb[IWL_TM_ATTR_UCODE_OWNER]) {
@@ -876,7 +876,7 @@ static int iwl_testmode_indirect_write(struct iwl_priv *priv, u32 addr,
 static int iwl_testmode_indirect_mem(struct ieee80211_hw *hw,
 	struct nlattr **tb)
 {
-	struct iwl_priv *priv = hw->priv;
+	struct iwl_priv *priv = IWL_MAC80211_GET_DVM(hw);
 	u32 addr, size, cmd;
 	unsigned char *buf;
 
@@ -910,7 +910,7 @@ static int iwl_testmode_buffer_dump(struct ieee80211_hw *hw, struct nlattr **tb,
 				   struct sk_buff *skb,
 				   struct netlink_callback *cb)
 {
-	struct iwl_priv *priv = hw->priv;
+	struct iwl_priv *priv = IWL_MAC80211_GET_DVM(hw);
 	int idx, length;
 
 	if (priv->testmode_mem.read_in_progress) {
@@ -961,7 +961,7 @@ static int iwl_testmode_buffer_dump(struct ieee80211_hw *hw, struct nlattr **tb,
 int iwlagn_mac_testmode_cmd(struct ieee80211_hw *hw, void *data, int len)
 {
 	struct nlattr *tb[IWL_TM_ATTR_MAX];
-	struct iwl_priv *priv = hw->priv;
+	struct iwl_priv *priv = IWL_MAC80211_GET_DVM(hw);
 	int result;
 
 	result = nla_parse(tb, IWL_TM_ATTR_MAX - 1, data, len,
@@ -1038,7 +1038,7 @@ int iwlagn_mac_testmode_dump(struct ieee80211_hw *hw, struct sk_buff *skb,
 		      void *data, int len)
 {
 	struct nlattr *tb[IWL_TM_ATTR_MAX];
-	struct iwl_priv *priv = hw->priv;
+	struct iwl_priv *priv = IWL_MAC80211_GET_DVM(hw);
 	int result;
 	u32 cmd;
 
diff --git a/drivers/net/wireless/iwlwifi/iwl-ucode.c b/drivers/net/wireless/iwlwifi/iwl-ucode.c
index 3645bf3..b16efc0 100644
--- a/drivers/net/wireless/iwlwifi/iwl-ucode.c
+++ b/drivers/net/wireless/iwlwifi/iwl-ucode.c
@@ -44,6 +44,7 @@
 #include "iwl-agn-calib.h"
 #include "iwl-trans.h"
 #include "iwl-fh.h"
+#include "iwl-op-mode.h"
 
 static struct iwl_wimax_coex_event_entry cu_priorities[COEX_NUM_OF_EVENTS] = {
 	{COEX_CU_UNASSOC_IDLE_RP, COEX_CU_UNASSOC_IDLE_WP,
@@ -1240,7 +1241,9 @@ static void iwl_ucode_callback(const struct firmware *ucode_raw, void *context)
 	release_firmware(ucode_raw);
 	complete(&nic->request_firmware_complete);
 
-	if (iwl_op_mode_dvm_start(bus(nic), trans(nic)->ops, cfg))
+	nic->op_mode = iwl_dvm_ops.start(nic->shrd->trans);
+
+	if (!nic->op_mode)
 		goto out_unbind;
 
 	return;
diff --git a/drivers/net/wireless/iwlwifi/iwl-wifi.h b/drivers/net/wireless/iwlwifi/iwl-wifi.h
index a78120e..d5cba07 100644
--- a/drivers/net/wireless/iwlwifi/iwl-wifi.h
+++ b/drivers/net/wireless/iwlwifi/iwl-wifi.h
@@ -72,6 +72,7 @@
  * struct iwl_nic - nic common data
  * @fw: the iwl_fw structure
  * @shrd: pointer to common shared structure
+ * @op_mode: the running op_mode
  * @fw_index: firmware revision to try loading
  * @firmware_name: composite filename of ucode file to load
  * @init_evtlog_ptr: event log offset for init ucode.
@@ -86,6 +87,7 @@ struct iwl_nic {
 	struct iwl_fw fw;
 
 	struct iwl_shared *shrd;
+	struct iwl_op_mode *op_mode;
 
 	int fw_index;                   /* firmware we're trying to load */
 	char firmware_name[25];         /* name of firmware file to load */
-- 
1.7.0.4

