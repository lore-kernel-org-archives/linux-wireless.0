Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([5.9.151.49]:49046 "EHLO sipsolutions.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753703AbaFXOK6 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 24 Jun 2014 10:10:58 -0400
From: Johannes Berg <johannes@sipsolutions.net>
To: linux-wireless@vger.kernel.org
Cc: David Spinadel <david.spinadel@intel.com>
Subject: [PATCH 1/2] mac80211: support more than one band in scan request
Date: Tue, 24 Jun 2014 16:10:46 +0200
Message-Id: <1403619047-13064-1-git-send-email-johannes@sipsolutions.net> (sfid-20140624_161104_427746_F35C51FF)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: David Spinadel <david.spinadel@intel.com>

Some drivers (such as iwlmvm) can handle multiple bands in a single
HW scan request. Add a HW flag to indicate that the driver support
this. To hold the required data, create a separate structure for
HW scan request that holds cfg scan request and data about
different parts of the scan IEs.

As this changes the mac80211 API, update all drivers using it to
use the correct new function type/argument.

Signed-off-by: David Spinadel <david.spinadel@intel.com>
Signed-off-by: Johannes Berg <johannes.berg@intel.com>
---
 drivers/net/wireless/at76c50x-usb.c         |   3 +-
 drivers/net/wireless/ath/ath10k/mac.c       |   3 +-
 drivers/net/wireless/cw1200/scan.c          |   3 +-
 drivers/net/wireless/cw1200/scan.h          |   2 +-
 drivers/net/wireless/iwlegacy/common.c      |   3 +-
 drivers/net/wireless/iwlegacy/common.h      |   2 +-
 drivers/net/wireless/iwlwifi/dvm/mac80211.c |   3 +-
 drivers/net/wireless/iwlwifi/mvm/mac80211.c |   3 +-
 drivers/net/wireless/mac80211_hwsim.c       |   3 +-
 drivers/net/wireless/ti/wl1251/main.c       |   3 +-
 drivers/net/wireless/ti/wlcore/main.c       |   3 +-
 include/net/mac80211.h                      |  39 ++++++++++-
 net/mac80211/driver-ops.h                   |   2 +-
 net/mac80211/ieee80211_i.h                  |   9 ++-
 net/mac80211/scan.c                         |  85 +++++++++++++++-------
 net/mac80211/util.c                         | 105 +++++++++++++++++++---------
 16 files changed, 198 insertions(+), 73 deletions(-)

diff --git a/drivers/net/wireless/at76c50x-usb.c b/drivers/net/wireless/at76c50x-usb.c
index d48776e4f343..334c2ece855a 100644
--- a/drivers/net/wireless/at76c50x-usb.c
+++ b/drivers/net/wireless/at76c50x-usb.c
@@ -1955,8 +1955,9 @@ static void at76_dwork_hw_scan(struct work_struct *work)
 
 static int at76_hw_scan(struct ieee80211_hw *hw,
 			struct ieee80211_vif *vif,
-			struct cfg80211_scan_request *req)
+			struct ieee80211_scan_request *hw_req)
 {
+	struct cfg80211_scan_request *req = &hw_req->req;
 	struct at76_priv *priv = hw->priv;
 	struct at76_req_scan scan;
 	u8 *ssid = NULL;
diff --git a/drivers/net/wireless/ath/ath10k/mac.c b/drivers/net/wireless/ath/ath10k/mac.c
index a21080028c54..b8314a534972 100644
--- a/drivers/net/wireless/ath/ath10k/mac.c
+++ b/drivers/net/wireless/ath/ath10k/mac.c
@@ -3137,10 +3137,11 @@ exit:
 
 static int ath10k_hw_scan(struct ieee80211_hw *hw,
 			  struct ieee80211_vif *vif,
-			  struct cfg80211_scan_request *req)
+			  struct ieee80211_scan_request *hw_req)
 {
 	struct ath10k *ar = hw->priv;
 	struct ath10k_vif *arvif = ath10k_vif_to_arvif(vif);
+	struct cfg80211_scan_request *req = &hw_req->req;
 	struct wmi_start_scan_arg arg;
 	int ret = 0;
 	int i;
diff --git a/drivers/net/wireless/cw1200/scan.c b/drivers/net/wireless/cw1200/scan.c
index 9afcd4ce3368..b2fb6c632092 100644
--- a/drivers/net/wireless/cw1200/scan.c
+++ b/drivers/net/wireless/cw1200/scan.c
@@ -53,9 +53,10 @@ static int cw1200_scan_start(struct cw1200_common *priv, struct wsm_scan *scan)
 
 int cw1200_hw_scan(struct ieee80211_hw *hw,
 		   struct ieee80211_vif *vif,
-		   struct cfg80211_scan_request *req)
+		   struct ieee80211_scan_request *hw_req)
 {
 	struct cw1200_common *priv = hw->priv;
+	struct cfg80211_scan_request *req = &hw_req->req;
 	struct wsm_template_frame frame = {
 		.frame_type = WSM_FRAME_TYPE_PROBE_REQUEST,
 	};
diff --git a/drivers/net/wireless/cw1200/scan.h b/drivers/net/wireless/cw1200/scan.h
index 5a8296ccfa82..cc75459e5784 100644
--- a/drivers/net/wireless/cw1200/scan.h
+++ b/drivers/net/wireless/cw1200/scan.h
@@ -41,7 +41,7 @@ struct cw1200_scan {
 
 int cw1200_hw_scan(struct ieee80211_hw *hw,
 		   struct ieee80211_vif *vif,
-		   struct cfg80211_scan_request *req);
+		   struct ieee80211_scan_request *hw_req);
 void cw1200_scan_work(struct work_struct *work);
 void cw1200_scan_timeout(struct work_struct *work);
 void cw1200_clear_recent_scan_work(struct work_struct *work);
diff --git a/drivers/net/wireless/iwlegacy/common.c b/drivers/net/wireless/iwlegacy/common.c
index ecc674627e6e..03de7467aecf 100644
--- a/drivers/net/wireless/iwlegacy/common.c
+++ b/drivers/net/wireless/iwlegacy/common.c
@@ -1572,8 +1572,9 @@ il_scan_initiate(struct il_priv *il, struct ieee80211_vif *vif)
 
 int
 il_mac_hw_scan(struct ieee80211_hw *hw, struct ieee80211_vif *vif,
-	       struct cfg80211_scan_request *req)
+	       struct ieee80211_scan_request *hw_req)
 {
+	struct cfg80211_scan_request *req = &hw_req->req;
 	struct il_priv *il = hw->priv;
 	int ret;
 
diff --git a/drivers/net/wireless/iwlegacy/common.h b/drivers/net/wireless/iwlegacy/common.h
index ea5c0f863c4e..5b972798bdff 100644
--- a/drivers/net/wireless/iwlegacy/common.h
+++ b/drivers/net/wireless/iwlegacy/common.h
@@ -1787,7 +1787,7 @@ int il_scan_cancel(struct il_priv *il);
 int il_scan_cancel_timeout(struct il_priv *il, unsigned long ms);
 void il_force_scan_end(struct il_priv *il);
 int il_mac_hw_scan(struct ieee80211_hw *hw, struct ieee80211_vif *vif,
-		   struct cfg80211_scan_request *req);
+		   struct ieee80211_scan_request *hw_req);
 void il_internal_short_hw_scan(struct il_priv *il);
 int il_force_reset(struct il_priv *il, bool external);
 u16 il_fill_probe_req(struct il_priv *il, struct ieee80211_mgmt *frame,
diff --git a/drivers/net/wireless/iwlwifi/dvm/mac80211.c b/drivers/net/wireless/iwlwifi/dvm/mac80211.c
index 29af7b51e370..afb98f4fdaf3 100644
--- a/drivers/net/wireless/iwlwifi/dvm/mac80211.c
+++ b/drivers/net/wireless/iwlwifi/dvm/mac80211.c
@@ -1495,9 +1495,10 @@ static int iwlagn_mac_change_interface(struct ieee80211_hw *hw,
 
 static int iwlagn_mac_hw_scan(struct ieee80211_hw *hw,
 			      struct ieee80211_vif *vif,
-			      struct cfg80211_scan_request *req)
+			      struct ieee80211_scan_request *hw_req)
 {
 	struct iwl_priv *priv = IWL_MAC80211_GET_DVM(hw);
+	struct cfg80211_scan_request *req = &hw_req->req;
 	int ret;
 
 	IWL_DEBUG_MAC80211(priv, "enter\n");
diff --git a/drivers/net/wireless/iwlwifi/mvm/mac80211.c b/drivers/net/wireless/iwlwifi/mvm/mac80211.c
index 7215f5980186..4dc2e05f49ce 100644
--- a/drivers/net/wireless/iwlwifi/mvm/mac80211.c
+++ b/drivers/net/wireless/iwlwifi/mvm/mac80211.c
@@ -1537,9 +1537,10 @@ static void iwl_mvm_bss_info_changed(struct ieee80211_hw *hw,
 
 static int iwl_mvm_mac_hw_scan(struct ieee80211_hw *hw,
 			       struct ieee80211_vif *vif,
-			       struct cfg80211_scan_request *req)
+			       struct ieee80211_scan_request *hw_req)
 {
 	struct iwl_mvm *mvm = IWL_MAC80211_GET_MVM(hw);
+	struct cfg80211_scan_request *req = &hw_req->req;
 	int ret;
 
 	if (req->n_channels == 0 || req->n_channels > MAX_NUM_SCAN_CHANNELS)
diff --git a/drivers/net/wireless/mac80211_hwsim.c b/drivers/net/wireless/mac80211_hwsim.c
index 06a0722164da..eba51460a5de 100644
--- a/drivers/net/wireless/mac80211_hwsim.c
+++ b/drivers/net/wireless/mac80211_hwsim.c
@@ -1736,9 +1736,10 @@ static void hw_scan_work(struct work_struct *work)
 
 static int mac80211_hwsim_hw_scan(struct ieee80211_hw *hw,
 				  struct ieee80211_vif *vif,
-				  struct cfg80211_scan_request *req)
+				  struct ieee80211_scan_request *hw_req)
 {
 	struct mac80211_hwsim_data *hwsim = hw->priv;
+	struct cfg80211_scan_request *req = &hw_req->req;
 
 	mutex_lock(&hwsim->mutex);
 	if (WARN_ON(hwsim->tmp_chan || hwsim->hw_scan_request)) {
diff --git a/drivers/net/wireless/ti/wl1251/main.c b/drivers/net/wireless/ti/wl1251/main.c
index 4e782f18ae34..38234851457e 100644
--- a/drivers/net/wireless/ti/wl1251/main.c
+++ b/drivers/net/wireless/ti/wl1251/main.c
@@ -991,8 +991,9 @@ out:
 
 static int wl1251_op_hw_scan(struct ieee80211_hw *hw,
 			     struct ieee80211_vif *vif,
-			     struct cfg80211_scan_request *req)
+			     struct ieee80211_scan_request *hw_req)
 {
+	struct cfg80211_scan_request *req = &hw_req->req;
 	struct wl1251 *wl = hw->priv;
 	struct sk_buff *skb;
 	size_t ssid_len = 0;
diff --git a/drivers/net/wireless/ti/wlcore/main.c b/drivers/net/wireless/ti/wlcore/main.c
index 3d6028e62750..e5ffb8b91dd4 100644
--- a/drivers/net/wireless/ti/wlcore/main.c
+++ b/drivers/net/wireless/ti/wlcore/main.c
@@ -3540,8 +3540,9 @@ out:
 
 static int wl1271_op_hw_scan(struct ieee80211_hw *hw,
 			     struct ieee80211_vif *vif,
-			     struct cfg80211_scan_request *req)
+			     struct ieee80211_scan_request *hw_req)
 {
+	struct cfg80211_scan_request *req = &hw_req->req;
 	struct wl1271 *wl = hw->priv;
 	int ret;
 	u8 *ssid = NULL;
diff --git a/include/net/mac80211.h b/include/net/mac80211.h
index 18c2bdbaf988..6e49b0e64874 100644
--- a/include/net/mac80211.h
+++ b/include/net/mac80211.h
@@ -768,6 +768,26 @@ struct ieee80211_sched_scan_ies {
 	size_t len[IEEE80211_NUM_BANDS];
 };
 
+/**
+ * struct ieee80211_scan_ies - descriptors for different blocks of IEs
+ *
+ * This structure is used to point to different blocks of IEs in HW scan.
+ * These blocks contain the IEs passed by userspace and the ones generated
+ * by mac80211.
+ *
+ * @ies: pointers to band specific IEs.
+ * @len: lengths of band_specific IEs.
+ * @common_ies: IEs for all bands (especially vendor specific ones)
+ * @common_ie_len: length of the common_ies
+ */
+struct ieee80211_scan_ies {
+	const u8 *ies[IEEE80211_NUM_BANDS];
+	size_t len[IEEE80211_NUM_BANDS];
+	const u8 *common_ies;
+	size_t common_ie_len;
+};
+
+
 static inline struct ieee80211_tx_info *IEEE80211_SKB_CB(struct sk_buff *skb)
 {
 	return (struct ieee80211_tx_info *)skb->cb;
@@ -1606,6 +1626,9 @@ struct ieee80211_tx_control {
  *	on single-channel hardware.  It can also be used as an
  *	optimization in certain channel switch cases with
  *	multi-channel.
+ *
+ * @IEEE80211_SINGLE_HW_SCAN_ON_ALL_BANDS: The HW supports scanning on all bands
+ *	in one command, mac80211 doesn't have to run separate scans per band.
  */
 enum ieee80211_hw_flags {
 	IEEE80211_HW_HAS_RATE_CONTROL			= 1<<0,
@@ -1638,6 +1661,7 @@ enum ieee80211_hw_flags {
 	IEEE80211_HW_SUPPORTS_HT_CCK_RATES		= 1<<27,
 	IEEE80211_HW_CHANCTX_STA_CSA			= 1<<28,
 	IEEE80211_HW_CHANGE_RUNNING_CHANCTX		= 1<<29,
+	IEEE80211_SINGLE_HW_SCAN_ON_ALL_BANDS		= 1<<30,
 };
 
 /**
@@ -1764,6 +1788,19 @@ struct ieee80211_hw {
 };
 
 /**
+ * ieee80211_scan_request - hw scan request
+ *
+ * @ies: pointers different parts of IEs (in req.ie)
+ * @req: cfg80211 request.
+ */
+struct ieee80211_scan_request {
+	struct ieee80211_scan_ies ies;
+
+	/* Keep last */
+	struct cfg80211_scan_request req;
+};
+
+/**
  * wiphy_to_ieee80211_hw - return a mac80211 driver hw struct from a wiphy
  *
  * @wiphy: the &struct wiphy which we want to query
@@ -2874,7 +2911,7 @@ struct ieee80211_ops {
 	void (*set_default_unicast_key)(struct ieee80211_hw *hw,
 					struct ieee80211_vif *vif, int idx);
 	int (*hw_scan)(struct ieee80211_hw *hw, struct ieee80211_vif *vif,
-		       struct cfg80211_scan_request *req);
+		       struct ieee80211_scan_request *req);
 	void (*cancel_hw_scan)(struct ieee80211_hw *hw,
 			       struct ieee80211_vif *vif);
 	int (*sched_scan_start)(struct ieee80211_hw *hw,
diff --git a/net/mac80211/driver-ops.h b/net/mac80211/driver-ops.h
index 2265bd7a44ba..faa0d90f6e80 100644
--- a/net/mac80211/driver-ops.h
+++ b/net/mac80211/driver-ops.h
@@ -314,7 +314,7 @@ static inline void drv_update_tkip_key(struct ieee80211_local *local,
 
 static inline int drv_hw_scan(struct ieee80211_local *local,
 			      struct ieee80211_sub_if_data *sdata,
-			      struct cfg80211_scan_request *req)
+			      struct ieee80211_scan_request *req)
 {
 	int ret;
 
diff --git a/net/mac80211/ieee80211_i.h b/net/mac80211/ieee80211_i.h
index 6c8089429892..f88bd1659cde 100644
--- a/net/mac80211/ieee80211_i.h
+++ b/net/mac80211/ieee80211_i.h
@@ -1152,7 +1152,8 @@ struct ieee80211_local {
 	unsigned long scanning;
 	struct cfg80211_ssid scan_ssid;
 	struct cfg80211_scan_request *int_scan_req;
-	struct cfg80211_scan_request *scan_req, *hw_scan_req;
+	struct cfg80211_scan_request *scan_req;
+	struct ieee80211_scan_request *hw_scan_req;
 	struct cfg80211_chan_def scan_chandef;
 	enum ieee80211_band hw_scan_band;
 	int scan_channel_idx;
@@ -1756,8 +1757,10 @@ void ieee80211_send_deauth_disassoc(struct ieee80211_sub_if_data *sdata,
 				    const u8 *bssid, u16 stype, u16 reason,
 				    bool send_frame, u8 *frame_buf);
 int ieee80211_build_preq_ies(struct ieee80211_local *local, u8 *buffer,
-			     size_t buffer_len, const u8 *ie, size_t ie_len,
-			     enum ieee80211_band band, u32 rate_mask,
+			     size_t buffer_len,
+			     struct ieee80211_scan_ies *ie_desc,
+			     const u8 *ie, size_t ie_len,
+			     u8 bands_used, u32 *rate_masks,
 			     struct cfg80211_chan_def *chandef);
 struct sk_buff *ieee80211_build_probe_req(struct ieee80211_sub_if_data *sdata,
 					  u8 *dst, u32 ratemask,
diff --git a/net/mac80211/scan.c b/net/mac80211/scan.c
index f40661eb75b5..116959e070d0 100644
--- a/net/mac80211/scan.c
+++ b/net/mac80211/scan.c
@@ -235,38 +235,51 @@ static bool ieee80211_prep_hw_scan(struct ieee80211_local *local)
 {
 	struct cfg80211_scan_request *req = local->scan_req;
 	struct cfg80211_chan_def chandef;
-	enum ieee80211_band band;
+	u8 bands_used = 0;
 	int i, ielen, n_chans;
 
 	if (test_bit(SCAN_HW_CANCELLED, &local->scanning))
 		return false;
 
-	do {
-		if (local->hw_scan_band == IEEE80211_NUM_BANDS)
-			return false;
-
-		band = local->hw_scan_band;
-		n_chans = 0;
+	if (local->hw.flags & IEEE80211_SINGLE_HW_SCAN_ON_ALL_BANDS) {
 		for (i = 0; i < req->n_channels; i++) {
-			if (req->channels[i]->band == band) {
-				local->hw_scan_req->channels[n_chans] =
+			local->hw_scan_req->req.channels[i] = req->channels[i];
+			bands_used |= BIT(req->channels[i]->band);
+		}
+
+		n_chans = req->n_channels;
+	} else {
+		do {
+			if (local->hw_scan_band == IEEE80211_NUM_BANDS)
+				return false;
+
+			n_chans = 0;
+
+			for (i = 0; i < req->n_channels; i++) {
+				if (req->channels[i]->band !=
+				    local->hw_scan_band)
+					continue;
+				local->hw_scan_req->req.channels[n_chans] =
 							req->channels[i];
 				n_chans++;
+				bands_used |= BIT(req->channels[i]->band);
 			}
-		}
 
-		local->hw_scan_band++;
-	} while (!n_chans);
+			local->hw_scan_band++;
+		} while (!n_chans);
+	}
 
-	local->hw_scan_req->n_channels = n_chans;
+	local->hw_scan_req->req.n_channels = n_chans;
 	ieee80211_prepare_scan_chandef(&chandef, req->scan_width);
 
-	ielen = ieee80211_build_preq_ies(local, (u8 *)local->hw_scan_req->ie,
+	ielen = ieee80211_build_preq_ies(local,
+					 (u8 *)local->hw_scan_req->req.ie,
 					 local->hw_scan_ies_bufsize,
-					 req->ie, req->ie_len, band,
-					 req->rates[band], &chandef);
-	local->hw_scan_req->ie_len = ielen;
-	local->hw_scan_req->no_cck = req->no_cck;
+					 &local->hw_scan_req->ies,
+					 req->ie, req->ie_len,
+					 bands_used, req->rates, &chandef);
+	local->hw_scan_req->req.ie_len = ielen;
+	local->hw_scan_req->req.no_cck = req->no_cck;
 
 	return true;
 }
@@ -291,7 +304,9 @@ static void __ieee80211_scan_completed(struct ieee80211_hw *hw, bool aborted)
 	if (WARN_ON(!local->scan_req))
 		return;
 
-	if (hw_scan && !aborted && ieee80211_prep_hw_scan(local)) {
+	if (hw_scan && !aborted &&
+	    !(local->hw.flags & IEEE80211_SINGLE_HW_SCAN_ON_ALL_BANDS) &&
+	    ieee80211_prep_hw_scan(local)) {
 		int rc;
 
 		rc = drv_hw_scan(local,
@@ -473,6 +488,21 @@ static int __ieee80211_start_scan(struct ieee80211_sub_if_data *sdata,
 		u8 *ies;
 
 		local->hw_scan_ies_bufsize = local->scan_ies_len + req->ie_len;
+
+		if (local->hw.flags & IEEE80211_SINGLE_HW_SCAN_ON_ALL_BANDS) {
+			int i, n_bands = 0;
+			u8 bands_counted = 0;
+
+			for (i = 0; i < req->n_channels; i++) {
+				if (bands_counted & BIT(req->channels[i]->band))
+					continue;
+				bands_counted |= BIT(req->channels[i]->band);
+				n_bands++;
+			}
+
+			local->hw_scan_ies_bufsize *= n_bands;
+		}
+
 		local->hw_scan_req = kmalloc(
 				sizeof(*local->hw_scan_req) +
 				req->n_channels * sizeof(req->channels[0]) +
@@ -480,13 +510,13 @@ static int __ieee80211_start_scan(struct ieee80211_sub_if_data *sdata,
 		if (!local->hw_scan_req)
 			return -ENOMEM;
 
-		local->hw_scan_req->ssids = req->ssids;
-		local->hw_scan_req->n_ssids = req->n_ssids;
+		local->hw_scan_req->req.ssids = req->ssids;
+		local->hw_scan_req->req.n_ssids = req->n_ssids;
 		ies = (u8 *)local->hw_scan_req +
 			sizeof(*local->hw_scan_req) +
 			req->n_channels * sizeof(req->channels[0]);
-		local->hw_scan_req->ie = ies;
-		local->hw_scan_req->flags = req->flags;
+		local->hw_scan_req->req.ie = ies;
+		local->hw_scan_req->req.flags = req->flags;
 
 		local->hw_scan_band = 0;
 
@@ -976,6 +1006,7 @@ int __ieee80211_request_sched_scan_start(struct ieee80211_sub_if_data *sdata,
 	struct ieee80211_sched_scan_ies sched_scan_ies = {};
 	struct cfg80211_chan_def chandef;
 	int ret, i, iebufsz;
+	struct ieee80211_scan_ies dummy_ie_desc;
 
 	iebufsz = local->scan_ies_len + req->ie_len;
 
@@ -985,6 +1016,8 @@ int __ieee80211_request_sched_scan_start(struct ieee80211_sub_if_data *sdata,
 		return -ENOTSUPP;
 
 	for (i = 0; i < IEEE80211_NUM_BANDS; i++) {
+		u32 rate_masks[IEEE80211_NUM_BANDS] = {};
+
 		if (!local->hw.wiphy->bands[i])
 			continue;
 
@@ -995,11 +1028,13 @@ int __ieee80211_request_sched_scan_start(struct ieee80211_sub_if_data *sdata,
 		}
 
 		ieee80211_prepare_scan_chandef(&chandef, req->scan_width);
+		rate_masks[i] = (u32) -1;
 
 		sched_scan_ies.len[i] =
 			ieee80211_build_preq_ies(local, sched_scan_ies.ie[i],
-						 iebufsz, req->ie, req->ie_len,
-						 i, (u32) -1, &chandef);
+						 iebufsz, &dummy_ie_desc,
+						 req->ie, req->ie_len, BIT(i),
+						 rate_masks, &chandef);
 	}
 
 	ret = drv_sched_scan_start(local, sdata, req, &sched_scan_ies);
diff --git a/net/mac80211/util.c b/net/mac80211/util.c
index 42d448d765b4..e31458201278 100644
--- a/net/mac80211/util.c
+++ b/net/mac80211/util.c
@@ -1219,14 +1219,17 @@ void ieee80211_send_deauth_disassoc(struct ieee80211_sub_if_data *sdata,
 	}
 }
 
-int ieee80211_build_preq_ies(struct ieee80211_local *local, u8 *buffer,
-			     size_t buffer_len, const u8 *ie, size_t ie_len,
-			     enum ieee80211_band band, u32 rate_mask,
-			     struct cfg80211_chan_def *chandef)
+static int ieee80211_build_preq_ies_band(struct ieee80211_local *local,
+					 u8 *buffer, size_t buffer_len,
+					 const u8 *ie, size_t ie_len,
+					 enum ieee80211_band band,
+					 u32 rate_mask,
+					 struct cfg80211_chan_def *chandef,
+					 size_t *offset)
 {
 	struct ieee80211_supported_band *sband;
 	u8 *pos = buffer, *end = buffer + buffer_len;
-	size_t offset = 0, noffset;
+	size_t noffset;
 	int supp_rates_len, i;
 	u8 rates[32];
 	int num_rates;
@@ -1234,6 +1237,8 @@ int ieee80211_build_preq_ies(struct ieee80211_local *local, u8 *buffer,
 	int shift;
 	u32 rate_flags;
 
+	*offset = 0;
+
 	sband = local->hw.wiphy->bands[band];
 	if (WARN_ON_ONCE(!sband))
 		return 0;
@@ -1272,12 +1277,12 @@ int ieee80211_build_preq_ies(struct ieee80211_local *local, u8 *buffer,
 		noffset = ieee80211_ie_split(ie, ie_len,
 					     before_extrates,
 					     ARRAY_SIZE(before_extrates),
-					     offset);
-		if (end - pos < noffset - offset)
+					     *offset);
+		if (end - pos < noffset - *offset)
 			goto out_err;
-		memcpy(pos, ie + offset, noffset - offset);
-		pos += noffset - offset;
-		offset = noffset;
+		memcpy(pos, ie + *offset, noffset - *offset);
+		pos += noffset - *offset;
+		*offset = noffset;
 	}
 
 	ext_rates_len = num_rates - supp_rates_len;
@@ -1311,12 +1316,12 @@ int ieee80211_build_preq_ies(struct ieee80211_local *local, u8 *buffer,
 		};
 		noffset = ieee80211_ie_split(ie, ie_len,
 					     before_ht, ARRAY_SIZE(before_ht),
-					     offset);
-		if (end - pos < noffset - offset)
+					     *offset);
+		if (end - pos < noffset - *offset)
 			goto out_err;
-		memcpy(pos, ie + offset, noffset - offset);
-		pos += noffset - offset;
-		offset = noffset;
+		memcpy(pos, ie + *offset, noffset - *offset);
+		pos += noffset - *offset;
+		*offset = noffset;
 	}
 
 	if (sband->ht_cap.ht_supported) {
@@ -1351,12 +1356,12 @@ int ieee80211_build_preq_ies(struct ieee80211_local *local, u8 *buffer,
 		};
 		noffset = ieee80211_ie_split(ie, ie_len,
 					     before_vht, ARRAY_SIZE(before_vht),
-					     offset);
-		if (end - pos < noffset - offset)
+					     *offset);
+		if (end - pos < noffset - *offset)
 			goto out_err;
-		memcpy(pos, ie + offset, noffset - offset);
-		pos += noffset - offset;
-		offset = noffset;
+		memcpy(pos, ie + *offset, noffset - *offset);
+		pos += noffset - *offset;
+		*offset = noffset;
 	}
 
 	if (sband->vht_cap.vht_supported) {
@@ -1366,21 +1371,54 @@ int ieee80211_build_preq_ies(struct ieee80211_local *local, u8 *buffer,
 						 sband->vht_cap.cap);
 	}
 
-	/* add any remaining custom IEs */
-	if (ie && ie_len) {
-		noffset = ie_len;
-		if (end - pos < noffset - offset)
-			goto out_err;
-		memcpy(pos, ie + offset, noffset - offset);
-		pos += noffset - offset;
-	}
-
 	return pos - buffer;
  out_err:
 	WARN_ONCE(1, "not enough space for preq IEs\n");
 	return pos - buffer;
 }
 
+int ieee80211_build_preq_ies(struct ieee80211_local *local, u8 *buffer,
+			     size_t buffer_len,
+			     struct ieee80211_scan_ies *ie_desc,
+			     const u8 *ie, size_t ie_len,
+			     u8 bands_used, u32 *rate_masks,
+			     struct cfg80211_chan_def *chandef)
+{
+	size_t pos = 0, old_pos = 0, custom_ie_offset = 0;
+	int i;
+
+	memset(ie_desc, 0, sizeof(*ie_desc));
+
+	for (i = 0; i < IEEE80211_NUM_BANDS; i++) {
+		if (bands_used & BIT(i)) {
+			pos += ieee80211_build_preq_ies_band(local,
+							     buffer + pos,
+							     buffer_len - pos,
+							     ie, ie_len, i,
+							     rate_masks[i],
+							     chandef,
+							     &custom_ie_offset);
+			ie_desc->ies[i] = buffer + old_pos;
+			ie_desc->len[i] = pos - old_pos;
+			old_pos = pos;
+		}
+	}
+
+	/* add any remaining custom IEs */
+	if (ie && ie_len) {
+		if (WARN_ONCE(buffer_len - pos < ie_len - custom_ie_offset,
+			      "not enough space for preq custom IEs\n"))
+			return pos;
+		memcpy(buffer + pos, ie + custom_ie_offset,
+		       ie_len - custom_ie_offset);
+		ie_desc->common_ies = buffer + pos;
+		ie_desc->common_ie_len = ie_len - custom_ie_offset;
+		pos += ie_len - custom_ie_offset;
+	}
+
+	return pos;
+};
+
 struct sk_buff *ieee80211_build_probe_req(struct ieee80211_sub_if_data *sdata,
 					  u8 *dst, u32 ratemask,
 					  struct ieee80211_channel *chan,
@@ -1393,6 +1431,8 @@ struct sk_buff *ieee80211_build_probe_req(struct ieee80211_sub_if_data *sdata,
 	struct sk_buff *skb;
 	struct ieee80211_mgmt *mgmt;
 	int ies_len;
+	u32 rate_masks[IEEE80211_NUM_BANDS] = {};
+	struct ieee80211_scan_ies dummy_ie_desc;
 
 	/*
 	 * Do not send DS Channel parameter for directed probe requests
@@ -1410,10 +1450,11 @@ struct sk_buff *ieee80211_build_probe_req(struct ieee80211_sub_if_data *sdata,
 	if (!skb)
 		return NULL;
 
+	rate_masks[chan->band] = ratemask;
 	ies_len = ieee80211_build_preq_ies(local, skb_tail_pointer(skb),
-					   skb_tailroom(skb),
-					   ie, ie_len, chan->band,
-					   ratemask, &chandef);
+					   skb_tailroom(skb), &dummy_ie_desc,
+					   ie, ie_len, BIT(chan->band),
+					   rate_masks, &chandef);
 	skb_put(skb, ies_len);
 
 	if (dst) {
-- 
2.0.0

