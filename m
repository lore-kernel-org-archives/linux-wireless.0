Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([5.9.151.49]:49048 "EHLO sipsolutions.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753705AbaFXOK6 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 24 Jun 2014 10:10:58 -0400
From: Johannes Berg <johannes@sipsolutions.net>
To: linux-wireless@vger.kernel.org
Cc: David Spinadel <david.spinadel@intel.com>
Subject: [PATCH 2/2] mac80211: split sched scan IEs
Date: Tue, 24 Jun 2014 16:10:47 +0200
Message-Id: <1403619047-13064-2-git-send-email-johannes@sipsolutions.net> (sfid-20140624_161106_975243_E4B65C33)
In-Reply-To: <1403619047-13064-1-git-send-email-johannes@sipsolutions.net>
References: <1403619047-13064-1-git-send-email-johannes@sipsolutions.net>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: David Spinadel <david.spinadel@intel.com>

Split sched scan IEs to band specific and not band specific
blocks. Common IEs blocks may be sent to the FW once per command,
instead of per band.

This allows optimization of size of the command, which may be
required by some drivers (eg. iwlmvm with newer firmware version).

As this changes the mac80211 API, update all drivers to use the
new version correctly, even if they don't (yet) make use of the
split data.

Signed-off-by: David Spinadel <david.spinadel@intel.com>
Reviewed-by: Alexander Bondar <alexander.bondar@intel.com>
Signed-off-by: Johannes Berg <johannes.berg@intel.com>
---
 drivers/net/wireless/iwlwifi/mvm/mac80211.c |  2 +-
 drivers/net/wireless/iwlwifi/mvm/mvm.h      |  2 +-
 drivers/net/wireless/iwlwifi/mvm/scan.c     | 27 +++++++++++------
 drivers/net/wireless/ti/wl12xx/scan.c       | 20 +++++++-----
 drivers/net/wireless/ti/wl12xx/scan.h       |  2 +-
 drivers/net/wireless/ti/wl18xx/scan.c       | 16 +++++++---
 drivers/net/wireless/ti/wl18xx/scan.h       |  2 +-
 drivers/net/wireless/ti/wlcore/cmd.c        | 11 ++++---
 drivers/net/wireless/ti/wlcore/cmd.h        |  3 +-
 drivers/net/wireless/ti/wlcore/main.c       |  2 +-
 drivers/net/wireless/ti/wlcore/scan.h       |  2 +-
 drivers/net/wireless/ti/wlcore/wlcore.h     |  2 +-
 include/net/mac80211.h                      | 23 +++-----------
 net/mac80211/driver-ops.h                   |  2 +-
 net/mac80211/scan.c                         | 47 +++++++++++++++--------------
 15 files changed, 88 insertions(+), 75 deletions(-)

diff --git a/drivers/net/wireless/iwlwifi/mvm/mac80211.c b/drivers/net/wireless/iwlwifi/mvm/mac80211.c
index 4dc2e05f49ce..7dd363dd3ad3 100644
--- a/drivers/net/wireless/iwlwifi/mvm/mac80211.c
+++ b/drivers/net/wireless/iwlwifi/mvm/mac80211.c
@@ -1828,7 +1828,7 @@ static void iwl_mvm_mac_mgd_prepare_tx(struct ieee80211_hw *hw,
 static int iwl_mvm_mac_sched_scan_start(struct ieee80211_hw *hw,
 					struct ieee80211_vif *vif,
 					struct cfg80211_sched_scan_request *req,
-					struct ieee80211_sched_scan_ies *ies)
+					struct ieee80211_scan_ies *ies)
 {
 	struct iwl_mvm *mvm = IWL_MAC80211_GET_MVM(hw);
 	int ret;
diff --git a/drivers/net/wireless/iwlwifi/mvm/mvm.h b/drivers/net/wireless/iwlwifi/mvm/mvm.h
index fcc6c29482d0..97630f9a7cb9 100644
--- a/drivers/net/wireless/iwlwifi/mvm/mvm.h
+++ b/drivers/net/wireless/iwlwifi/mvm/mvm.h
@@ -854,7 +854,7 @@ int iwl_mvm_rx_scan_offload_complete_notif(struct iwl_mvm *mvm,
 int iwl_mvm_config_sched_scan(struct iwl_mvm *mvm,
 			      struct ieee80211_vif *vif,
 			      struct cfg80211_sched_scan_request *req,
-			      struct ieee80211_sched_scan_ies *ies);
+			      struct ieee80211_scan_ies *ies);
 int iwl_mvm_config_sched_scan_profiles(struct iwl_mvm *mvm,
 				       struct cfg80211_sched_scan_request *req);
 int iwl_mvm_sched_scan_start(struct iwl_mvm *mvm,
diff --git a/drivers/net/wireless/iwlwifi/mvm/scan.c b/drivers/net/wireless/iwlwifi/mvm/scan.c
index 4b6c7d4bd199..3206fa097255 100644
--- a/drivers/net/wireless/iwlwifi/mvm/scan.c
+++ b/drivers/net/wireless/iwlwifi/mvm/scan.c
@@ -204,7 +204,8 @@ static void iwl_mvm_scan_fill_channels(struct iwl_scan_cmd *cmd,
  */
 static u16 iwl_mvm_fill_probe_req(struct ieee80211_mgmt *frame, const u8 *ta,
 				  int n_ssids, const u8 *ssid, int ssid_len,
-				  const u8 *ie, int ie_len,
+				  const u8 *band_ie, int band_ie_len,
+				  const u8 *common_ie, int common_ie_len,
 				  int left)
 {
 	int len = 0;
@@ -244,12 +245,19 @@ static u16 iwl_mvm_fill_probe_req(struct ieee80211_mgmt *frame, const u8 *ta,
 
 	len += ssid_len + 2;
 
-	if (WARN_ON(left < ie_len))
+	if (WARN_ON(left < band_ie_len + common_ie_len))
 		return len;
 
-	if (ie && ie_len) {
-		memcpy(pos, ie, ie_len);
-		len += ie_len;
+	if (band_ie && band_ie_len) {
+		memcpy(pos, band_ie, band_ie_len);
+		pos += band_ie_len;
+		len += band_ie_len;
+	}
+
+	if (common_ie && common_ie_len) {
+		memcpy(pos, common_ie, common_ie_len);
+		pos += common_ie_len;
+		len += common_ie_len;
 	}
 
 	return (u16)len;
@@ -382,7 +390,7 @@ int iwl_mvm_scan_request(struct iwl_mvm *mvm,
 			    (struct ieee80211_mgmt *)cmd->data,
 			    vif->addr,
 			    req->n_ssids, ssid, ssid_len,
-			    req->ie, req->ie_len,
+			    req->ie, req->ie_len, NULL, 0,
 			    mvm->fw->ucode_capa.max_probe_length));
 
 	iwl_mvm_scan_fill_channels(cmd, req, basic_ssid, &params);
@@ -561,7 +569,7 @@ int iwl_mvm_rx_scan_offload_complete_notif(struct iwl_mvm *mvm,
 
 static void iwl_scan_offload_build_tx_cmd(struct iwl_mvm *mvm,
 					  struct ieee80211_vif *vif,
-					  struct ieee80211_sched_scan_ies *ies,
+					  struct ieee80211_scan_ies *ies,
 					  enum ieee80211_band band,
 					  struct iwl_tx_cmd *cmd,
 					  u8 *data)
@@ -577,7 +585,8 @@ static void iwl_scan_offload_build_tx_cmd(struct iwl_mvm *mvm,
 	cmd_len = iwl_mvm_fill_probe_req((struct ieee80211_mgmt *)data,
 					 vif->addr,
 					 1, NULL, 0,
-					 ies->ie[band], ies->len[band],
+					 ies->ies[band], ies->len[band],
+					 ies->common_ies, ies->common_ie_len,
 					 SCAN_OFFLOAD_PROBE_REQ_SIZE);
 	cmd->len = cpu_to_le16(cmd_len);
 }
@@ -735,7 +744,7 @@ static void iwl_build_channel_cfg(struct iwl_mvm *mvm,
 int iwl_mvm_config_sched_scan(struct iwl_mvm *mvm,
 			      struct ieee80211_vif *vif,
 			      struct cfg80211_sched_scan_request *req,
-			      struct ieee80211_sched_scan_ies *ies)
+			      struct ieee80211_scan_ies *ies)
 {
 	int band_2ghz = mvm->nvm_data->bands[IEEE80211_BAND_2GHZ].n_channels;
 	int band_5ghz = mvm->nvm_data->bands[IEEE80211_BAND_5GHZ].n_channels;
diff --git a/drivers/net/wireless/ti/wl12xx/scan.c b/drivers/net/wireless/ti/wl12xx/scan.c
index 7541bd1a4a4b..0c0d5cd98514 100644
--- a/drivers/net/wireless/ti/wl12xx/scan.c
+++ b/drivers/net/wireless/ti/wl12xx/scan.c
@@ -156,7 +156,7 @@ static int wl1271_scan_send(struct wl1271 *wl, struct wl12xx_vif *wlvif,
 					 cmd->params.role_id, band,
 					 wl->scan.ssid, wl->scan.ssid_len,
 					 wl->scan.req->ie,
-					 wl->scan.req->ie_len, false);
+					 wl->scan.req->ie_len, NULL, 0, false);
 	if (ret < 0) {
 		wl1271_error("PROBE request template failed");
 		goto out;
@@ -317,7 +317,7 @@ static void wl12xx_adjust_channels(struct wl1271_cmd_sched_scan_config *cmd,
 int wl1271_scan_sched_scan_config(struct wl1271 *wl,
 				  struct wl12xx_vif *wlvif,
 				  struct cfg80211_sched_scan_request *req,
-				  struct ieee80211_sched_scan_ies *ies)
+				  struct ieee80211_scan_ies *ies)
 {
 	struct wl1271_cmd_sched_scan_config *cfg = NULL;
 	struct wlcore_scan_channels *cfg_channels = NULL;
@@ -378,8 +378,11 @@ int wl1271_scan_sched_scan_config(struct wl1271 *wl,
 						 wlvif->role_id, band,
 						 req->ssids[0].ssid,
 						 req->ssids[0].ssid_len,
-						 ies->ie[band],
-						 ies->len[band], true);
+						 ies->ies[band],
+						 ies->len[band],
+						 ies->common_ies,
+						 ies->common_ie_len,
+						 true);
 		if (ret < 0) {
 			wl1271_error("2.4GHz PROBE request template failed");
 			goto out;
@@ -392,8 +395,11 @@ int wl1271_scan_sched_scan_config(struct wl1271 *wl,
 						 wlvif->role_id, band,
 						 req->ssids[0].ssid,
 						 req->ssids[0].ssid_len,
-						 ies->ie[band],
-						 ies->len[band], true);
+						 ies->ies[band],
+						 ies->len[band],
+						 ies->common_ies,
+						 ies->common_ie_len,
+						 true);
 		if (ret < 0) {
 			wl1271_error("5GHz PROBE request template failed");
 			goto out;
@@ -449,7 +455,7 @@ out_free:
 
 int wl12xx_sched_scan_start(struct wl1271 *wl, struct wl12xx_vif  *wlvif,
 			    struct cfg80211_sched_scan_request *req,
-			    struct ieee80211_sched_scan_ies *ies)
+			    struct ieee80211_scan_ies *ies)
 {
 	int ret;
 
diff --git a/drivers/net/wireless/ti/wl12xx/scan.h b/drivers/net/wireless/ti/wl12xx/scan.h
index 264af7ac2785..427f9af85a00 100644
--- a/drivers/net/wireless/ti/wl12xx/scan.h
+++ b/drivers/net/wireless/ti/wl12xx/scan.h
@@ -135,6 +135,6 @@ int wl12xx_scan_stop(struct wl1271 *wl, struct wl12xx_vif *wlvif);
 void wl12xx_scan_completed(struct wl1271 *wl, struct wl12xx_vif *wlvif);
 int wl12xx_sched_scan_start(struct wl1271 *wl, struct wl12xx_vif  *wlvif,
 			    struct cfg80211_sched_scan_request *req,
-			    struct ieee80211_sched_scan_ies *ies);
+			    struct ieee80211_scan_ies *ies);
 void wl12xx_scan_sched_scan_stop(struct wl1271 *wl,  struct wl12xx_vif *wlvif);
 #endif
diff --git a/drivers/net/wireless/ti/wl18xx/scan.c b/drivers/net/wireless/ti/wl18xx/scan.c
index 2b642f8c9266..98666f235a12 100644
--- a/drivers/net/wireless/ti/wl18xx/scan.c
+++ b/drivers/net/wireless/ti/wl18xx/scan.c
@@ -113,6 +113,8 @@ static int wl18xx_scan_send(struct wl1271 *wl, struct wl12xx_vif *wlvif,
 				 req->ssids ? req->ssids[0].ssid_len : 0,
 				 req->ie,
 				 req->ie_len,
+				 NULL,
+				 0,
 				 false);
 		if (ret < 0) {
 			wl1271_error("2.4GHz PROBE request template failed");
@@ -128,6 +130,8 @@ static int wl18xx_scan_send(struct wl1271 *wl, struct wl12xx_vif *wlvif,
 				 req->ssids ? req->ssids[0].ssid_len : 0,
 				 req->ie,
 				 req->ie_len,
+				 NULL,
+				 0,
 				 false);
 		if (ret < 0) {
 			wl1271_error("5GHz PROBE request template failed");
@@ -161,7 +165,7 @@ static
 int wl18xx_scan_sched_scan_config(struct wl1271 *wl,
 				  struct wl12xx_vif *wlvif,
 				  struct cfg80211_sched_scan_request *req,
-				  struct ieee80211_sched_scan_ies *ies)
+				  struct ieee80211_scan_ies *ies)
 {
 	struct wl18xx_cmd_scan_params *cmd;
 	struct wlcore_scan_channels *cmd_channels = NULL;
@@ -237,8 +241,10 @@ int wl18xx_scan_sched_scan_config(struct wl1271 *wl,
 				 cmd->role_id, band,
 				 req->ssids ? req->ssids[0].ssid : NULL,
 				 req->ssids ? req->ssids[0].ssid_len : 0,
-				 ies->ie[band],
+				 ies->ies[band],
 				 ies->len[band],
+				 ies->common_ies,
+				 ies->common_ie_len,
 				 true);
 		if (ret < 0) {
 			wl1271_error("2.4GHz PROBE request template failed");
@@ -252,8 +258,10 @@ int wl18xx_scan_sched_scan_config(struct wl1271 *wl,
 				 cmd->role_id, band,
 				 req->ssids ? req->ssids[0].ssid : NULL,
 				 req->ssids ? req->ssids[0].ssid_len : 0,
-				 ies->ie[band],
+				 ies->ies[band],
 				 ies->len[band],
+				 ies->common_ies,
+				 ies->common_ie_len,
 				 true);
 		if (ret < 0) {
 			wl1271_error("5GHz PROBE request template failed");
@@ -277,7 +285,7 @@ out:
 
 int wl18xx_sched_scan_start(struct wl1271 *wl, struct wl12xx_vif *wlvif,
 			    struct cfg80211_sched_scan_request *req,
-			    struct ieee80211_sched_scan_ies *ies)
+			    struct ieee80211_scan_ies *ies)
 {
 	return wl18xx_scan_sched_scan_config(wl, wlvif, req, ies);
 }
diff --git a/drivers/net/wireless/ti/wl18xx/scan.h b/drivers/net/wireless/ti/wl18xx/scan.h
index eadee42689d1..2e636aa5dba9 100644
--- a/drivers/net/wireless/ti/wl18xx/scan.h
+++ b/drivers/net/wireless/ti/wl18xx/scan.h
@@ -122,6 +122,6 @@ int wl18xx_scan_stop(struct wl1271 *wl, struct wl12xx_vif *wlvif);
 void wl18xx_scan_completed(struct wl1271 *wl, struct wl12xx_vif *wlvif);
 int wl18xx_sched_scan_start(struct wl1271 *wl, struct wl12xx_vif *wlvif,
 			    struct cfg80211_sched_scan_request *req,
-			    struct ieee80211_sched_scan_ies *ies);
+			    struct ieee80211_scan_ies *ies);
 void wl18xx_scan_sched_scan_stop(struct wl1271 *wl, struct wl12xx_vif *wlvif);
 #endif
diff --git a/drivers/net/wireless/ti/wlcore/cmd.c b/drivers/net/wireless/ti/wlcore/cmd.c
index 40dc30f4faaa..e269c0a57017 100644
--- a/drivers/net/wireless/ti/wlcore/cmd.c
+++ b/drivers/net/wireless/ti/wlcore/cmd.c
@@ -1124,7 +1124,8 @@ out:
 int wl12xx_cmd_build_probe_req(struct wl1271 *wl, struct wl12xx_vif *wlvif,
 			       u8 role_id, u8 band,
 			       const u8 *ssid, size_t ssid_len,
-			       const u8 *ie, size_t ie_len, bool sched_scan)
+			       const u8 *ie0, size_t ie0_len, const u8 *ie1,
+			       size_t ie1_len, bool sched_scan)
 {
 	struct ieee80211_vif *vif = wl12xx_wlvif_to_vif(wlvif);
 	struct sk_buff *skb;
@@ -1136,13 +1137,15 @@ int wl12xx_cmd_build_probe_req(struct wl1271 *wl, struct wl12xx_vif *wlvif,
 	wl1271_debug(DEBUG_SCAN, "build probe request band %d", band);
 
 	skb = ieee80211_probereq_get(wl->hw, vif, ssid, ssid_len,
-				     ie_len);
+				     ie0_len + ie1_len);
 	if (!skb) {
 		ret = -ENOMEM;
 		goto out;
 	}
-	if (ie_len)
-		memcpy(skb_put(skb, ie_len), ie, ie_len);
+	if (ie0_len)
+		memcpy(skb_put(skb, ie0_len), ie0, ie0_len);
+	if (ie1_len)
+		memcpy(skb_put(skb, ie1_len), ie1, ie1_len);
 
 	if (sched_scan &&
 	    (wl->quirks & WLCORE_QUIRK_DUAL_PROBE_TMPL)) {
diff --git a/drivers/net/wireless/ti/wlcore/cmd.h b/drivers/net/wireless/ti/wlcore/cmd.h
index b084830a61cf..6788d7356ca5 100644
--- a/drivers/net/wireless/ti/wlcore/cmd.h
+++ b/drivers/net/wireless/ti/wlcore/cmd.h
@@ -64,7 +64,8 @@ int wl1271_cmd_build_ps_poll(struct wl1271 *wl, struct wl12xx_vif *wlvif,
 int wl12xx_cmd_build_probe_req(struct wl1271 *wl, struct wl12xx_vif *wlvif,
 			       u8 role_id, u8 band,
 			       const u8 *ssid, size_t ssid_len,
-			       const u8 *ie, size_t ie_len, bool sched_scan);
+			       const u8 *ie, size_t ie_len, const u8 *common_ie,
+			       size_t common_ie_len, bool sched_scan);
 struct sk_buff *wl1271_cmd_build_ap_probe_req(struct wl1271 *wl,
 					      struct wl12xx_vif *wlvif,
 					      struct sk_buff *skb);
diff --git a/drivers/net/wireless/ti/wlcore/main.c b/drivers/net/wireless/ti/wlcore/main.c
index e5ffb8b91dd4..48f83868f9cb 100644
--- a/drivers/net/wireless/ti/wlcore/main.c
+++ b/drivers/net/wireless/ti/wlcore/main.c
@@ -3637,7 +3637,7 @@ out:
 static int wl1271_op_sched_scan_start(struct ieee80211_hw *hw,
 				      struct ieee80211_vif *vif,
 				      struct cfg80211_sched_scan_request *req,
-				      struct ieee80211_sched_scan_ies *ies)
+				      struct ieee80211_scan_ies *ies)
 {
 	struct wl1271 *wl = hw->priv;
 	struct wl12xx_vif *wlvif = wl12xx_vif_to_data(vif);
diff --git a/drivers/net/wireless/ti/wlcore/scan.h b/drivers/net/wireless/ti/wlcore/scan.h
index a6ab24b5c0f9..4dadd0c62cde 100644
--- a/drivers/net/wireless/ti/wlcore/scan.h
+++ b/drivers/net/wireless/ti/wlcore/scan.h
@@ -37,7 +37,7 @@ void wl1271_scan_complete_work(struct work_struct *work);
 int wl1271_scan_sched_scan_config(struct wl1271 *wl,
 				     struct wl12xx_vif *wlvif,
 				     struct cfg80211_sched_scan_request *req,
-				     struct ieee80211_sched_scan_ies *ies);
+				     struct ieee80211_scan_ies *ies);
 int wl1271_scan_sched_scan_start(struct wl1271 *wl, struct wl12xx_vif *wlvif);
 void wlcore_scan_sched_scan_results(struct wl1271 *wl);
 
diff --git a/drivers/net/wireless/ti/wlcore/wlcore.h b/drivers/net/wireless/ti/wlcore/wlcore.h
index 95a54504f0cc..71320509b56d 100644
--- a/drivers/net/wireless/ti/wlcore/wlcore.h
+++ b/drivers/net/wireless/ti/wlcore/wlcore.h
@@ -95,7 +95,7 @@ struct wlcore_ops {
 	int (*scan_stop)(struct wl1271 *wl, struct wl12xx_vif *wlvif);
 	int (*sched_scan_start)(struct wl1271 *wl, struct wl12xx_vif *wlvif,
 				struct cfg80211_sched_scan_request *req,
-				struct ieee80211_sched_scan_ies *ies);
+				struct ieee80211_scan_ies *ies);
 	void (*sched_scan_stop)(struct wl1271 *wl, struct wl12xx_vif *wlvif);
 	int (*get_spare_blocks)(struct wl1271 *wl, bool is_gem);
 	int (*set_key)(struct wl1271 *wl, enum set_key_cmd cmd,
diff --git a/include/net/mac80211.h b/include/net/mac80211.h
index 6e49b0e64874..1046ba2a996c 100644
--- a/include/net/mac80211.h
+++ b/include/net/mac80211.h
@@ -754,26 +754,11 @@ struct ieee80211_tx_info {
 };
 
 /**
- * struct ieee80211_sched_scan_ies - scheduled scan IEs
- *
- * This structure is used to pass the appropriate IEs to be used in scheduled
- * scans for all bands.  It contains both the IEs passed from the userspace
- * and the ones generated by mac80211.
- *
- * @ie: array with the IEs for each supported band
- * @len: array with the total length of the IEs for each band
- */
-struct ieee80211_sched_scan_ies {
-	u8 *ie[IEEE80211_NUM_BANDS];
-	size_t len[IEEE80211_NUM_BANDS];
-};
-
-/**
  * struct ieee80211_scan_ies - descriptors for different blocks of IEs
  *
- * This structure is used to point to different blocks of IEs in HW scan.
- * These blocks contain the IEs passed by userspace and the ones generated
- * by mac80211.
+ * This structure is used to point to different blocks of IEs in HW scan
+ * and scheduled scan. These blocks contain the IEs passed by userspace
+ * and the ones generated by mac80211.
  *
  * @ies: pointers to band specific IEs.
  * @len: lengths of band_specific IEs.
@@ -2917,7 +2902,7 @@ struct ieee80211_ops {
 	int (*sched_scan_start)(struct ieee80211_hw *hw,
 				struct ieee80211_vif *vif,
 				struct cfg80211_sched_scan_request *req,
-				struct ieee80211_sched_scan_ies *ies);
+				struct ieee80211_scan_ies *ies);
 	int (*sched_scan_stop)(struct ieee80211_hw *hw,
 			       struct ieee80211_vif *vif);
 	void (*sw_scan_start)(struct ieee80211_hw *hw);
diff --git a/net/mac80211/driver-ops.h b/net/mac80211/driver-ops.h
index faa0d90f6e80..11423958116a 100644
--- a/net/mac80211/driver-ops.h
+++ b/net/mac80211/driver-ops.h
@@ -346,7 +346,7 @@ static inline int
 drv_sched_scan_start(struct ieee80211_local *local,
 		     struct ieee80211_sub_if_data *sdata,
 		     struct cfg80211_sched_scan_request *req,
-		     struct ieee80211_sched_scan_ies *ies)
+		     struct ieee80211_scan_ies *ies)
 {
 	int ret;
 
diff --git a/net/mac80211/scan.c b/net/mac80211/scan.c
index 116959e070d0..a0a938145dcc 100644
--- a/net/mac80211/scan.c
+++ b/net/mac80211/scan.c
@@ -1003,10 +1003,13 @@ int __ieee80211_request_sched_scan_start(struct ieee80211_sub_if_data *sdata,
 					struct cfg80211_sched_scan_request *req)
 {
 	struct ieee80211_local *local = sdata->local;
-	struct ieee80211_sched_scan_ies sched_scan_ies = {};
+	struct ieee80211_scan_ies sched_scan_ies = {};
 	struct cfg80211_chan_def chandef;
-	int ret, i, iebufsz;
-	struct ieee80211_scan_ies dummy_ie_desc;
+	int ret, i, iebufsz, num_bands = 0;
+	u32 rate_masks[IEEE80211_NUM_BANDS] = {};
+	u8 bands_used = 0;
+	u8 *ie;
+	size_t len;
 
 	iebufsz = local->scan_ies_len + req->ie_len;
 
@@ -1016,37 +1019,35 @@ int __ieee80211_request_sched_scan_start(struct ieee80211_sub_if_data *sdata,
 		return -ENOTSUPP;
 
 	for (i = 0; i < IEEE80211_NUM_BANDS; i++) {
-		u32 rate_masks[IEEE80211_NUM_BANDS] = {};
-
-		if (!local->hw.wiphy->bands[i])
-			continue;
-
-		sched_scan_ies.ie[i] = kzalloc(iebufsz, GFP_KERNEL);
-		if (!sched_scan_ies.ie[i]) {
-			ret = -ENOMEM;
-			goto out_free;
+		if (local->hw.wiphy->bands[i]) {
+			bands_used |= BIT(i);
+			rate_masks[i] = (u32) -1;
+			num_bands++;
 		}
+	}
 
-		ieee80211_prepare_scan_chandef(&chandef, req->scan_width);
-		rate_masks[i] = (u32) -1;
-
-		sched_scan_ies.len[i] =
-			ieee80211_build_preq_ies(local, sched_scan_ies.ie[i],
-						 iebufsz, &dummy_ie_desc,
-						 req->ie, req->ie_len, BIT(i),
-						 rate_masks, &chandef);
+	ie = kzalloc(num_bands * iebufsz, GFP_KERNEL);
+	if (!ie) {
+		ret = -ENOMEM;
+		goto out;
 	}
 
+	ieee80211_prepare_scan_chandef(&chandef, req->scan_width);
+
+	len = ieee80211_build_preq_ies(local, ie, num_bands * iebufsz,
+				       &sched_scan_ies, req->ie,
+				       req->ie_len, bands_used,
+				       rate_masks, &chandef);
+
 	ret = drv_sched_scan_start(local, sdata, req, &sched_scan_ies);
 	if (ret == 0) {
 		rcu_assign_pointer(local->sched_scan_sdata, sdata);
 		local->sched_scan_req = req;
 	}
 
-out_free:
-	while (i > 0)
-		kfree(sched_scan_ies.ie[--i]);
+	kfree(ie);
 
+out:
 	if (ret) {
 		/* Clean in case of failure after HW restart or upon resume. */
 		RCU_INIT_POINTER(local->sched_scan_sdata, NULL);
-- 
2.0.0

