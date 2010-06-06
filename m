Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga01.intel.com ([192.55.52.88]:17575 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752091Ab0FFG4m (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Sun, 6 Jun 2010 02:56:42 -0400
From: Reinette Chatre <reinette.chatre@intel.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org,
	ipw3945-devel@lists.sourceforge.net,
	Johannes Berg <johannes.berg@intel.com>,
	Reinette Chatre <reinette.chatre@intel.com>
Subject: [PATCH 05/23] iwlwifi: use virtual interface address for scan
Date: Sat,  5 Jun 2010 23:56:20 -0700
Message-Id: <1275807398-18184-6-git-send-email-reinette.chatre@intel.com>
In-Reply-To: <1275807398-18184-1-git-send-email-reinette.chatre@intel.com>
References: <1275807398-18184-1-git-send-email-reinette.chatre@intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Johannes Berg <johannes.berg@intel.com>

For probe request frames sent during scan, we
should use the virtual interface's mac address
that the scan was initiated on to avoid issues
when the wrong address is used.

Signed-off-by: Johannes Berg <johannes.berg@intel.com>
Signed-off-by: Reinette Chatre <reinette.chatre@intel.com>
---
 drivers/net/wireless/iwlwifi/iwl-agn-lib.c  |    4 +++-
 drivers/net/wireless/iwlwifi/iwl-core.h     |    2 +-
 drivers/net/wireless/iwlwifi/iwl-scan.c     |    4 ++--
 drivers/net/wireless/iwlwifi/iwl3945-base.c |    4 +++-
 4 files changed, 9 insertions(+), 5 deletions(-)

diff --git a/drivers/net/wireless/iwlwifi/iwl-agn-lib.c b/drivers/net/wireless/iwlwifi/iwl-agn-lib.c
index 57c122d..42e6219 100644
--- a/drivers/net/wireless/iwlwifi/iwl-agn-lib.c
+++ b/drivers/net/wireless/iwlwifi/iwl-agn-lib.c
@@ -1462,13 +1462,15 @@ void iwlagn_request_scan(struct iwl_priv *priv, struct ieee80211_vif *vif)
 	if (!priv->is_internal_short_scan) {
 		cmd_len = iwl_fill_probe_req(priv,
 					(struct ieee80211_mgmt *)scan->data,
+					vif->addr,
 					priv->scan_request->ie,
 					priv->scan_request->ie_len,
 					IWL_MAX_SCAN_SIZE - sizeof(*scan));
 	} else {
+		/* use bcast addr, will not be transmitted but must be valid */
 		cmd_len = iwl_fill_probe_req(priv,
 					(struct ieee80211_mgmt *)scan->data,
-					NULL, 0,
+					iwl_bcast_addr, NULL, 0,
 					IWL_MAX_SCAN_SIZE - sizeof(*scan));
 
 	}
diff --git a/drivers/net/wireless/iwlwifi/iwl-core.h b/drivers/net/wireless/iwlwifi/iwl-core.h
index d3b61dc..69738f1 100644
--- a/drivers/net/wireless/iwlwifi/iwl-core.h
+++ b/drivers/net/wireless/iwlwifi/iwl-core.h
@@ -524,7 +524,7 @@ void iwl_bg_start_internal_scan(struct work_struct *work);
 void iwl_internal_short_hw_scan(struct iwl_priv *priv);
 int iwl_force_reset(struct iwl_priv *priv, int mode);
 u16 iwl_fill_probe_req(struct iwl_priv *priv, struct ieee80211_mgmt *frame,
-		       const u8 *ie, int ie_len, int left);
+		       const u8 *ta, const u8 *ie, int ie_len, int left);
 void iwl_setup_rx_scan_handlers(struct iwl_priv *priv);
 u16 iwl_get_active_dwell_time(struct iwl_priv *priv,
 			      enum ieee80211_band band,
diff --git a/drivers/net/wireless/iwlwifi/iwl-scan.c b/drivers/net/wireless/iwlwifi/iwl-scan.c
index 5d3f51f..0f9cbc2 100644
--- a/drivers/net/wireless/iwlwifi/iwl-scan.c
+++ b/drivers/net/wireless/iwlwifi/iwl-scan.c
@@ -438,7 +438,7 @@ EXPORT_SYMBOL(iwl_bg_scan_check);
  */
 
 u16 iwl_fill_probe_req(struct iwl_priv *priv, struct ieee80211_mgmt *frame,
-		       const u8 *ies, int ie_len, int left)
+		       const u8 *ta, const u8 *ies, int ie_len, int left)
 {
 	int len = 0;
 	u8 *pos = NULL;
@@ -451,7 +451,7 @@ u16 iwl_fill_probe_req(struct iwl_priv *priv, struct ieee80211_mgmt *frame,
 
 	frame->frame_control = cpu_to_le16(IEEE80211_STYPE_PROBE_REQ);
 	memcpy(frame->da, iwl_bcast_addr, ETH_ALEN);
-	memcpy(frame->sa, priv->mac_addr, ETH_ALEN);
+	memcpy(frame->sa, ta, ETH_ALEN);
 	memcpy(frame->bssid, iwl_bcast_addr, ETH_ALEN);
 	frame->seq_ctrl = 0;
 
diff --git a/drivers/net/wireless/iwlwifi/iwl3945-base.c b/drivers/net/wireless/iwlwifi/iwl3945-base.c
index 5976166..35471cf 100644
--- a/drivers/net/wireless/iwlwifi/iwl3945-base.c
+++ b/drivers/net/wireless/iwlwifi/iwl3945-base.c
@@ -2967,14 +2967,16 @@ void iwl3945_request_scan(struct iwl_priv *priv, struct ieee80211_vif *vif)
 		scan->tx_cmd.len = cpu_to_le16(
 			iwl_fill_probe_req(priv,
 				(struct ieee80211_mgmt *)scan->data,
+				vif->addr,
 				priv->scan_request->ie,
 				priv->scan_request->ie_len,
 				IWL_MAX_SCAN_SIZE - sizeof(*scan)));
 	} else {
+		/* use bcast addr, will not be transmitted but must be valid */
 		scan->tx_cmd.len = cpu_to_le16(
 			iwl_fill_probe_req(priv,
 				(struct ieee80211_mgmt *)scan->data,
-				NULL, 0,
+				iwl_bcast_addr, NULL, 0,
 				IWL_MAX_SCAN_SIZE - sizeof(*scan)));
 	}
 	/* select Rx antennas */
-- 
1.7.0.4

