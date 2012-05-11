Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:52825 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758203Ab2EKIx1 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 11 May 2012 04:53:27 -0400
From: Johannes Berg <johannes@sipsolutions.net>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org,
	David Spinadel <david.spinadel@intel.com>
Subject: [PATCH 1/4] iwlwifi: fix scan_cmd_size allocation
Date: Fri, 11 May 2012 10:53:15 +0200
Message-Id: <1336726398-13200-2-git-send-email-johannes@sipsolutions.net> (sfid-20120511_105352_657274_1799A6FF)
In-Reply-To: <1336726398-13200-1-git-send-email-johannes@sipsolutions.net>
References: <1336726398-13200-1-git-send-email-johannes@sipsolutions.net>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: David Spinadel <david.spinadel@intel.com>

Allocate scan command with dynamic size based on uCode capability
and num of channels.
This isn't an important fix as the previous allocation was always
too large as it added the scan command size but later subtracted
it (which meant it was supposed to be part of the max scan size.)

Signed-off-by: David Spinadel <david.spinadel@intel.com>
Reviewed-by: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
Signed-off-by: Johannes Berg <johannes.berg@intel.com>
---
 drivers/net/wireless/iwlwifi/iwl-commands.h |    1 -
 drivers/net/wireless/iwlwifi/iwl-scan.c     |   17 ++++++++++++-----
 2 files changed, 12 insertions(+), 6 deletions(-)

diff --git a/drivers/net/wireless/iwlwifi/iwl-commands.h b/drivers/net/wireless/iwlwifi/iwl-commands.h
index 2813a0a..9af6a23 100644
--- a/drivers/net/wireless/iwlwifi/iwl-commands.h
+++ b/drivers/net/wireless/iwlwifi/iwl-commands.h
@@ -2278,7 +2278,6 @@ struct iwl_ssid_ie {
 #define IWL_GOOD_CRC_TH_DISABLED	0
 #define IWL_GOOD_CRC_TH_DEFAULT		cpu_to_le16(1)
 #define IWL_GOOD_CRC_TH_NEVER		cpu_to_le16(0xffff)
-#define IWL_MAX_SCAN_SIZE 1024
 #define IWL_MAX_CMD_SIZE 4096
 
 /*
diff --git a/drivers/net/wireless/iwlwifi/iwl-scan.c b/drivers/net/wireless/iwlwifi/iwl-scan.c
index a8437a6..6f221de 100644
--- a/drivers/net/wireless/iwlwifi/iwl-scan.c
+++ b/drivers/net/wireless/iwlwifi/iwl-scan.c
@@ -52,6 +52,7 @@
 #define IWL_PASSIVE_DWELL_TIME_52   (10)
 #define IWL_PASSIVE_DWELL_BASE      (100)
 #define IWL_CHANNEL_TUNE_TIME       5
+#define MAX_SCAN_CHANNEL	    50
 
 static int iwl_send_scan_abort(struct iwl_priv *priv)
 {
@@ -679,6 +680,13 @@ static int iwlagn_request_scan(struct iwl_priv *priv, struct ieee80211_vif *vif)
 	u8 active_chains;
 	u8 scan_tx_antennas = priv->hw_params.valid_tx_ant;
 	int ret;
+	int scan_cmd_size = sizeof(struct iwl_scan_cmd) +
+			    MAX_SCAN_CHANNEL * sizeof(struct iwl_scan_channel) +
+			    priv->fw->ucode_capa.max_probe_length;
+
+	if (WARN_ON_ONCE(priv->scan_request &&
+			 priv->scan_request->n_channels > MAX_SCAN_CHANNEL))
+		return -EINVAL;
 
 	lockdep_assert_held(&priv->mutex);
 
@@ -686,8 +694,7 @@ static int iwlagn_request_scan(struct iwl_priv *priv, struct ieee80211_vif *vif)
 		ctx = iwl_rxon_ctx_from_vif(vif);
 
 	if (!priv->scan_cmd) {
-		priv->scan_cmd = kmalloc(sizeof(struct iwl_scan_cmd) +
-					 IWL_MAX_SCAN_SIZE, GFP_KERNEL);
+		priv->scan_cmd = kmalloc(scan_cmd_size, GFP_KERNEL);
 		if (!priv->scan_cmd) {
 			IWL_DEBUG_SCAN(priv,
 				       "fail to allocate memory for scan\n");
@@ -695,7 +702,7 @@ static int iwlagn_request_scan(struct iwl_priv *priv, struct ieee80211_vif *vif)
 		}
 	}
 	scan = priv->scan_cmd;
-	memset(scan, 0, sizeof(struct iwl_scan_cmd) + IWL_MAX_SCAN_SIZE);
+	memset(scan, 0, scan_cmd_size);
 
 	scan->quiet_plcp_th = IWL_PLCP_QUIET_THRESH;
 	scan->quiet_time = IWL_ACTIVE_QUIET_TIME;
@@ -883,7 +890,7 @@ static int iwlagn_request_scan(struct iwl_priv *priv, struct ieee80211_vif *vif)
 					vif->addr,
 					priv->scan_request->ie,
 					priv->scan_request->ie_len,
-					IWL_MAX_SCAN_SIZE - sizeof(*scan));
+					scan_cmd_size - sizeof(*scan));
 		break;
 	case IWL_SCAN_RADIO_RESET:
 	case IWL_SCAN_ROC:
@@ -891,7 +898,7 @@ static int iwlagn_request_scan(struct iwl_priv *priv, struct ieee80211_vif *vif)
 		cmd_len = iwl_fill_probe_req(
 					(struct ieee80211_mgmt *)scan->data,
 					iwl_bcast_addr, NULL, 0,
-					IWL_MAX_SCAN_SIZE - sizeof(*scan));
+					scan_cmd_size - sizeof(*scan));
 		break;
 	default:
 		BUG();
-- 
1.7.10

