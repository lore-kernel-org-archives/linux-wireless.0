Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([5.9.151.49]:55151 "EHLO sipsolutions.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750873AbaLOLgA (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 15 Dec 2014 06:36:00 -0500
From: Johannes Berg <johannes@sipsolutions.net>
To: linux-wireless@vger.kernel.org
Cc: kvalo@adurom.com, pizza@shaftnet.org, luca@coelho.fi,
	Johannes Berg <johannes.berg@intel.com>
Subject: [PATCH] mac80211: move U-APSD enablement to vif flags
Date: Mon, 15 Dec 2014 12:35:54 +0100
Message-Id: <1418643354-5597-1-git-send-email-johannes@sipsolutions.net> (sfid-20141215_123606_679110_53D4BB15)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Johannes Berg <johannes.berg@intel.com>

In order to let drivers have more dynamic U-APSD support,
move the enablement flag to the virtual interface driver
flags. This lets drivers not only set it up differently
for different interfaces, but also enable/disable on the
fly if needed.

Signed-off-by: Johannes Berg <johannes.berg@intel.com>
---
 drivers/net/wireless/ath/ath10k/mac.c       |  3 ++-
 drivers/net/wireless/cw1200/main.c          |  1 -
 drivers/net/wireless/cw1200/sta.c           |  1 +
 drivers/net/wireless/iwlwifi/mvm/mac80211.c | 13 ++++++-------
 drivers/net/wireless/ti/wl1251/main.c       |  5 ++---
 drivers/net/wireless/ti/wlcore/main.c       |  2 +-
 include/net/mac80211.h                      | 15 +++++++--------
 net/mac80211/debugfs.c                      |  2 --
 net/mac80211/main.c                         |  4 ----
 net/mac80211/mlme.c                         |  7 ++++++-
 10 files changed, 25 insertions(+), 28 deletions(-)

diff --git a/drivers/net/wireless/ath/ath10k/mac.c b/drivers/net/wireless/ath/ath10k/mac.c
index c4005670cba2..2619db1e3e74 100644
--- a/drivers/net/wireless/ath/ath10k/mac.c
+++ b/drivers/net/wireless/ath/ath10k/mac.c
@@ -2871,6 +2871,8 @@ static int ath10k_add_interface(struct ieee80211_hw *hw,
 	int bit;
 	u32 vdev_param;
 
+	vif->driver_flags |= IEEE80211_VIF_SUPPORTS_UAPSD;
+
 	mutex_lock(&ar->conf_mutex);
 
 	memset(arvif, 0, sizeof(*arvif));
@@ -5024,7 +5026,6 @@ int ath10k_mac_register(struct ath10k *ar)
 	ar->hw->flags = IEEE80211_HW_SIGNAL_DBM |
 			IEEE80211_HW_SUPPORTS_PS |
 			IEEE80211_HW_SUPPORTS_DYNAMIC_PS |
-			IEEE80211_HW_SUPPORTS_UAPSD |
 			IEEE80211_HW_MFP_CAPABLE |
 			IEEE80211_HW_REPORTS_TX_ACK_STATUS |
 			IEEE80211_HW_HAS_RATE_CONTROL |
diff --git a/drivers/net/wireless/cw1200/main.c b/drivers/net/wireless/cw1200/main.c
index 3e78cc3ccb78..0da6e423da63 100644
--- a/drivers/net/wireless/cw1200/main.c
+++ b/drivers/net/wireless/cw1200/main.c
@@ -282,7 +282,6 @@ static struct ieee80211_hw *cw1200_init_common(const u8 *macaddr,
 		    IEEE80211_HW_SUPPORTS_PS |
 		    IEEE80211_HW_SUPPORTS_DYNAMIC_PS |
 		    IEEE80211_HW_REPORTS_TX_ACK_STATUS |
-		    IEEE80211_HW_SUPPORTS_UAPSD |
 		    IEEE80211_HW_CONNECTION_MONITOR |
 		    IEEE80211_HW_AMPDU_AGGREGATION |
 		    IEEE80211_HW_TX_AMPDU_SETUP_IN_HW |
diff --git a/drivers/net/wireless/cw1200/sta.c b/drivers/net/wireless/cw1200/sta.c
index 5b84664db13b..a1e3237c0be8 100644
--- a/drivers/net/wireless/cw1200/sta.c
+++ b/drivers/net/wireless/cw1200/sta.c
@@ -213,6 +213,7 @@ int cw1200_add_interface(struct ieee80211_hw *dev,
 	/* __le32 auto_calibration_mode = __cpu_to_le32(1); */
 
 	vif->driver_flags |= IEEE80211_VIF_BEACON_FILTER |
+			     IEEE80211_VIF_SUPPORTS_UAPSD |
 			     IEEE80211_VIF_SUPPORTS_CQM_RSSI;
 
 	mutex_lock(&priv->conf_mutex);
diff --git a/drivers/net/wireless/iwlwifi/mvm/mac80211.c b/drivers/net/wireless/iwlwifi/mvm/mac80211.c
index 31a5b3f4266c..346331d3c696 100644
--- a/drivers/net/wireless/iwlwifi/mvm/mac80211.c
+++ b/drivers/net/wireless/iwlwifi/mvm/mac80211.c
@@ -326,6 +326,8 @@ int iwl_mvm_mac_setup_register(struct iwl_mvm *mvm)
 	hw->radiotap_vht_details |= IEEE80211_RADIOTAP_VHT_KNOWN_STBC |
 		IEEE80211_RADIOTAP_VHT_KNOWN_BEAMFORMED;
 	hw->rate_control_algorithm = "iwl-mvm-rs";
+	hw->uapsd_queues = IWL_MVM_UAPSD_QUEUES;
+	hw->uapsd_max_sp_len = IWL_UAPSD_MAX_SP;
 
 	/*
 	 * Enable 11w if advertised by firmware and software crypto
@@ -336,13 +338,6 @@ int iwl_mvm_mac_setup_register(struct iwl_mvm *mvm)
 	    !iwlwifi_mod_params.sw_crypto)
 		hw->flags |= IEEE80211_HW_MFP_CAPABLE;
 
-	if (mvm->fw->ucode_capa.flags & IWL_UCODE_TLV_FLAGS_UAPSD_SUPPORT &&
-	    !iwlwifi_mod_params.uapsd_disable) {
-		hw->flags |= IEEE80211_HW_SUPPORTS_UAPSD;
-		hw->uapsd_queues = IWL_MVM_UAPSD_QUEUES;
-		hw->uapsd_max_sp_len = IWL_UAPSD_MAX_SP;
-	}
-
 	if (mvm->fw->ucode_capa.api[0] & IWL_UCODE_TLV_API_LMAC_SCAN ||
 	    mvm->fw->ucode_capa.capa[0] & IWL_UCODE_TLV_CAPA_UMAC_SCAN) {
 		hw->flags |= IEEE80211_SINGLE_HW_SCAN_ON_ALL_BANDS;
@@ -1147,6 +1142,10 @@ static int iwl_mvm_mac_add_interface(struct ieee80211_hw *hw,
 		mvm->bf_allowed_vif = mvmvif;
 		vif->driver_flags |= IEEE80211_VIF_BEACON_FILTER |
 				     IEEE80211_VIF_SUPPORTS_CQM_RSSI;
+		if (mvm->fw->ucode_capa.flags &
+					IWL_UCODE_TLV_FLAGS_UAPSD_SUPPORT &&
+		    !iwlwifi_mod_params.uapsd_disable)
+			vif->driver_flags |= IEEE80211_VIF_SUPPORTS_UAPSD;
 	}
 
 	/*
diff --git a/drivers/net/wireless/ti/wl1251/main.c b/drivers/net/wireless/ti/wl1251/main.c
index 0b30a7b4d663..d4ba009ac9aa 100644
--- a/drivers/net/wireless/ti/wl1251/main.c
+++ b/drivers/net/wireless/ti/wl1251/main.c
@@ -500,6 +500,7 @@ static int wl1251_op_add_interface(struct ieee80211_hw *hw,
 	int ret = 0;
 
 	vif->driver_flags |= IEEE80211_VIF_BEACON_FILTER |
+			     IEEE80211_VIF_SUPPORTS_UAPSD |
 			     IEEE80211_VIF_SUPPORTS_CQM_RSSI;
 
 	wl1251_debug(DEBUG_MAC80211, "mac80211 add interface type %d mac %pM",
@@ -1480,9 +1481,7 @@ int wl1251_init_ieee80211(struct wl1251 *wl)
 	/* unit us */
 	/* FIXME: find a proper value */
 
-	wl->hw->flags = IEEE80211_HW_SIGNAL_DBM |
-		IEEE80211_HW_SUPPORTS_PS |
-		IEEE80211_HW_SUPPORTS_UAPSD;
+	wl->hw->flags = IEEE80211_HW_SIGNAL_DBM | IEEE80211_HW_SUPPORTS_PS;
 
 	wl->hw->wiphy->interface_modes = BIT(NL80211_IFTYPE_STATION) |
 					 BIT(NL80211_IFTYPE_ADHOC);
diff --git a/drivers/net/wireless/ti/wlcore/main.c b/drivers/net/wireless/ti/wlcore/main.c
index 6ad3fcedab9b..2a99456b6b8f 100644
--- a/drivers/net/wireless/ti/wlcore/main.c
+++ b/drivers/net/wireless/ti/wlcore/main.c
@@ -2508,6 +2508,7 @@ static int wl1271_op_add_interface(struct ieee80211_hw *hw,
 	}
 
 	vif->driver_flags |= IEEE80211_VIF_BEACON_FILTER |
+			     IEEE80211_VIF_SUPPORTS_UAPSD |
 			     IEEE80211_VIF_SUPPORTS_CQM_RSSI;
 
 	wl1271_debug(DEBUG_MAC80211, "mac80211 add interface type %d mac %pM",
@@ -5776,7 +5777,6 @@ static int wl1271_init_ieee80211(struct wl1271 *wl)
 	wl->hw->flags = IEEE80211_HW_SIGNAL_DBM |
 		IEEE80211_HW_SUPPORTS_PS |
 		IEEE80211_HW_SUPPORTS_DYNAMIC_PS |
-		IEEE80211_HW_SUPPORTS_UAPSD |
 		IEEE80211_HW_HAS_RATE_CONTROL |
 		IEEE80211_HW_CONNECTION_MONITOR |
 		IEEE80211_HW_REPORTS_TX_ACK_STATUS |
diff --git a/include/net/mac80211.h b/include/net/mac80211.h
index b24ef577aed9..4913c00539fb 100644
--- a/include/net/mac80211.h
+++ b/include/net/mac80211.h
@@ -1187,10 +1187,15 @@ struct ieee80211_channel_switch {
  *	monitoring on this virtual interface -- i.e. it can monitor
  *	connection quality related parameters, such as the RSSI level and
  *	provide notifications if configured trigger levels are reached.
+ * @IEEE80211_VIF_SUPPORTS_UAPSD: The device can do U-APSD for this
+ *	interface. This flag should be set during interface addition,
+ *	but may be set/cleared as late as authentication to an AP. It is
+ *	only valid for managed/station mode interfaces.
  */
 enum ieee80211_vif_flags {
 	IEEE80211_VIF_BEACON_FILTER		= BIT(0),
 	IEEE80211_VIF_SUPPORTS_CQM_RSSI		= BIT(1),
+	IEEE80211_VIF_SUPPORTS_UAPSD		= BIT(2),
 };
 
 /**
@@ -1589,11 +1594,6 @@ struct ieee80211_tx_control {
  * @IEEE80211_HW_MFP_CAPABLE:
  *	Hardware supports management frame protection (MFP, IEEE 802.11w).
  *
- * @IEEE80211_HW_SUPPORTS_UAPSD:
- *	Hardware supports Unscheduled Automatic Power Save Delivery
- *	(U-APSD) in managed mode. The mode is configured with
- *	conf_tx() operation.
- *
  * @IEEE80211_HW_REPORTS_TX_ACK_STATUS:
  *	Hardware can provide ack status reports of Tx frames to
  *	the stack.
@@ -1679,8 +1679,7 @@ enum ieee80211_hw_flags {
 	IEEE80211_HW_MFP_CAPABLE			= 1<<13,
 	IEEE80211_HW_WANT_MONITOR_VIF			= 1<<14,
 	IEEE80211_HW_NO_AUTO_VIF			= 1<<15,
-	/* free slot */
-	IEEE80211_HW_SUPPORTS_UAPSD			= 1<<17,
+	/* free slots */
 	IEEE80211_HW_REPORTS_TX_ACK_STATUS		= 1<<18,
 	IEEE80211_HW_CONNECTION_MONITOR			= 1<<19,
 	IEEE80211_HW_QUEUE_CONTROL			= 1<<20,
@@ -2032,7 +2031,7 @@ void ieee80211_free_txskb(struct ieee80211_hw *hw, struct sk_buff *skb);
  * enabled whenever user has enabled powersave.
  *
  * Driver informs U-APSD client support by enabling
- * %IEEE80211_HW_SUPPORTS_UAPSD flag. The mode is configured through the
+ * %IEEE80211_VIF_SUPPORTS_UAPSD flag. The mode is configured through the
  * uapsd parameter in conf_tx() operation. Hardware needs to send the QoS
  * Nullfunc frames and stay awake until the service period has ended. To
  * utilize U-APSD, dynamic powersave is disabled for voip AC and all frames
diff --git a/net/mac80211/debugfs.c b/net/mac80211/debugfs.c
index 54a189f0393e..eeb0bbd69d98 100644
--- a/net/mac80211/debugfs.c
+++ b/net/mac80211/debugfs.c
@@ -303,8 +303,6 @@ static ssize_t hwflags_read(struct file *file, char __user *user_buf,
 		sf += scnprintf(buf + sf, mxln - sf, "SUPPORTS_DYNAMIC_PS\n");
 	if (local->hw.flags & IEEE80211_HW_MFP_CAPABLE)
 		sf += scnprintf(buf + sf, mxln - sf, "MFP_CAPABLE\n");
-	if (local->hw.flags & IEEE80211_HW_SUPPORTS_UAPSD)
-		sf += scnprintf(buf + sf, mxln - sf, "SUPPORTS_UAPSD\n");
 	if (local->hw.flags & IEEE80211_HW_REPORTS_TX_ACK_STATUS)
 		sf += scnprintf(buf + sf, mxln - sf,
 				"REPORTS_TX_ACK_STATUS\n");
diff --git a/net/mac80211/main.c b/net/mac80211/main.c
index 6ab99da38db9..d9ce33663c73 100644
--- a/net/mac80211/main.c
+++ b/net/mac80211/main.c
@@ -916,10 +916,6 @@ int ieee80211_register_hw(struct ieee80211_hw *hw)
 		}
 	}
 
-	WARN((local->hw.flags & IEEE80211_HW_SUPPORTS_UAPSD)
-	     && (local->hw.flags & IEEE80211_HW_PS_NULLFUNC_STACK),
-	     "U-APSD not supported with HW_PS_NULLFUNC_STACK\n");
-
 	/*
 	 * Calculate scan IE length -- we need this to alloc
 	 * memory and to subtract from the driver limit. It
diff --git a/net/mac80211/mlme.c b/net/mac80211/mlme.c
index 75a9bf50207e..f495b800b92c 100644
--- a/net/mac80211/mlme.c
+++ b/net/mac80211/mlme.c
@@ -4667,8 +4667,13 @@ int ieee80211_mgd_assoc(struct ieee80211_sub_if_data *sdata,
 		ifmgd->flags |= IEEE80211_STA_DISABLE_VHT;
 	rcu_read_unlock();
 
+	if (WARN((sdata->vif.driver_flags & IEEE80211_VIF_SUPPORTS_UAPSD) &&
+		 (local->hw.flags & IEEE80211_HW_PS_NULLFUNC_STACK),
+	     "U-APSD not supported with HW_PS_NULLFUNC_STACK\n"))
+		sdata->vif.driver_flags &= ~IEEE80211_VIF_SUPPORTS_UAPSD;
+
 	if (bss->wmm_used && bss->uapsd_supported &&
-	    (sdata->local->hw.flags & IEEE80211_HW_SUPPORTS_UAPSD)) {
+	    (sdata->vif.driver_flags & IEEE80211_VIF_SUPPORTS_UAPSD)) {
 		assoc_data->uapsd = true;
 		ifmgd->flags |= IEEE80211_STA_UAPSD_ENABLED;
 	} else {
-- 
2.1.1

