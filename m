Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga09.intel.com ([134.134.136.24]:31533 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755146Ab2CDUnJ (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Sun, 4 Mar 2012 15:43:09 -0500
From: Wey-Yi Guy <wey-yi.w.guy@intel.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org,
	Johannes Berg <johannes.berg@intel.com>,
	Wey-Yi Guy <wey-yi.w.guy@intel.com>
Subject: [PATCH 066/101] iwlwifi: make iwl_fill_probe_req static
Date: Sun,  4 Mar 2012 11:29:20 -0800
Message-Id: <1330889395-533-67-git-send-email-wey-yi.w.guy@intel.com> (sfid-20120304_214515_202302_B59525B8)
In-Reply-To: <1330889395-533-1-git-send-email-wey-yi.w.guy@intel.com>
References: <1330889395-533-1-git-send-email-wey-yi.w.guy@intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Johannes Berg <johannes.berg@intel.com>

This function is only used in iwl-scan.c, so
if we move it up a little in the file it can
be made static.

Signed-off-by: Johannes Berg <johannes.berg@intel.com>
Signed-off-by: Wey-Yi Guy <wey-yi.w.guy@intel.com>
---
 drivers/net/wireless/iwlwifi/iwl-core.h |    2 -
 drivers/net/wireless/iwlwifi/iwl-scan.c |   98 +++++++++++++++---------------
 2 files changed, 49 insertions(+), 51 deletions(-)

diff --git a/drivers/net/wireless/iwlwifi/iwl-core.h b/drivers/net/wireless/iwlwifi/iwl-core.h
index 7259cbf..e0423c4 100644
--- a/drivers/net/wireless/iwlwifi/iwl-core.h
+++ b/drivers/net/wireless/iwlwifi/iwl-core.h
@@ -202,8 +202,6 @@ void iwl_scan_cancel_timeout(struct iwl_priv *priv, unsigned long ms);
 void iwl_force_scan_end(struct iwl_priv *priv);
 void iwl_internal_short_hw_scan(struct iwl_priv *priv);
 int iwl_force_reset(struct iwl_priv *priv, int mode, bool external);
-u16 iwl_fill_probe_req(struct iwl_priv *priv, struct ieee80211_mgmt *frame,
-		       const u8 *ta, const u8 *ie, int ie_len, int left);
 void iwl_setup_rx_scan_handlers(struct iwl_priv *priv);
 void iwl_setup_scan_deferred_work(struct iwl_priv *priv);
 void iwl_cancel_scan_deferred_work(struct iwl_priv *priv);
diff --git a/drivers/net/wireless/iwlwifi/iwl-scan.c b/drivers/net/wireless/iwlwifi/iwl-scan.c
index 91a1457..8c3fb32 100644
--- a/drivers/net/wireless/iwlwifi/iwl-scan.c
+++ b/drivers/net/wireless/iwlwifi/iwl-scan.c
@@ -572,6 +572,53 @@ static int iwl_get_channels_for_scan(struct iwl_priv *priv,
 	return added;
 }
 
+/**
+ * iwl_fill_probe_req - fill in all required fields and IE for probe request
+ */
+
+static u16 iwl_fill_probe_req(struct ieee80211_mgmt *frame, const u8 *ta,
+			      const u8 *ies, int ie_len, int left)
+{
+	int len = 0;
+	u8 *pos = NULL;
+
+	/* Make sure there is enough space for the probe request,
+	 * two mandatory IEs and the data */
+	left -= 24;
+	if (left < 0)
+		return 0;
+
+	frame->frame_control = cpu_to_le16(IEEE80211_STYPE_PROBE_REQ);
+	memcpy(frame->da, iwl_bcast_addr, ETH_ALEN);
+	memcpy(frame->sa, ta, ETH_ALEN);
+	memcpy(frame->bssid, iwl_bcast_addr, ETH_ALEN);
+	frame->seq_ctrl = 0;
+
+	len += 24;
+
+	/* ...next IE... */
+	pos = &frame->u.probe_req.variable[0];
+
+	/* fill in our indirect SSID IE */
+	left -= 2;
+	if (left < 0)
+		return 0;
+	*pos++ = WLAN_EID_SSID;
+	*pos++ = 0;
+
+	len += 2;
+
+	if (WARN_ON(left < ie_len))
+		return len;
+
+	if (ies && ie_len) {
+		memcpy(pos, ies, ie_len);
+		len += ie_len;
+	}
+
+	return (u16)len;
+}
+
 static int iwlagn_request_scan(struct iwl_priv *priv, struct ieee80211_vif *vif)
 {
 	struct iwl_host_cmd cmd = {
@@ -791,7 +838,7 @@ static int iwlagn_request_scan(struct iwl_priv *priv, struct ieee80211_vif *vif)
 	scan->rx_chain = cpu_to_le16(rx_chain);
 	switch (priv->scan_type) {
 	case IWL_SCAN_NORMAL:
-		cmd_len = iwl_fill_probe_req(priv,
+		cmd_len = iwl_fill_probe_req(
 					(struct ieee80211_mgmt *)scan->data,
 					vif->addr,
 					priv->scan_request->ie,
@@ -801,7 +848,7 @@ static int iwlagn_request_scan(struct iwl_priv *priv, struct ieee80211_vif *vif)
 	case IWL_SCAN_RADIO_RESET:
 	case IWL_SCAN_ROC:
 		/* use bcast addr, will not be transmitted but must be valid */
-		cmd_len = iwl_fill_probe_req(priv,
+		cmd_len = iwl_fill_probe_req(
 					(struct ieee80211_mgmt *)scan->data,
 					iwl_bcast_addr, NULL, 0,
 					IWL_MAX_SCAN_SIZE - sizeof(*scan));
@@ -1004,53 +1051,6 @@ static void iwl_bg_scan_check(struct work_struct *data)
 	mutex_unlock(&priv->mutex);
 }
 
-/**
- * iwl_fill_probe_req - fill in all required fields and IE for probe request
- */
-
-u16 iwl_fill_probe_req(struct iwl_priv *priv, struct ieee80211_mgmt *frame,
-		       const u8 *ta, const u8 *ies, int ie_len, int left)
-{
-	int len = 0;
-	u8 *pos = NULL;
-
-	/* Make sure there is enough space for the probe request,
-	 * two mandatory IEs and the data */
-	left -= 24;
-	if (left < 0)
-		return 0;
-
-	frame->frame_control = cpu_to_le16(IEEE80211_STYPE_PROBE_REQ);
-	memcpy(frame->da, iwl_bcast_addr, ETH_ALEN);
-	memcpy(frame->sa, ta, ETH_ALEN);
-	memcpy(frame->bssid, iwl_bcast_addr, ETH_ALEN);
-	frame->seq_ctrl = 0;
-
-	len += 24;
-
-	/* ...next IE... */
-	pos = &frame->u.probe_req.variable[0];
-
-	/* fill in our indirect SSID IE */
-	left -= 2;
-	if (left < 0)
-		return 0;
-	*pos++ = WLAN_EID_SSID;
-	*pos++ = 0;
-
-	len += 2;
-
-	if (WARN_ON(left < ie_len))
-		return len;
-
-	if (ies && ie_len) {
-		memcpy(pos, ies, ie_len);
-		len += ie_len;
-	}
-
-	return (u16)len;
-}
-
 static void iwl_bg_abort_scan(struct work_struct *work)
 {
 	struct iwl_priv *priv = container_of(work, struct iwl_priv, abort_scan);
-- 
1.7.0.4

