Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga02.intel.com ([134.134.136.20]:63195 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S966105Ab2DLV6K (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 12 Apr 2012 17:58:10 -0400
From: Wey-Yi Guy <wey-yi.w.guy@intel.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org,
	Meenakshi Venkataraman <meenakshi.venkataraman@intel.com>,
	Wey-Yi Guy <wey-yi.w.guy@intel.com>
Subject: [PATCH 18/24] iwlwifi: move iwl_send_statistics_request to iwl-agn.c
Date: Thu, 12 Apr 2012 14:54:15 -0700
Message-Id: <1334267661-14654-19-git-send-email-wey-yi.w.guy@intel.com> (sfid-20120412_235904_206538_4A0CA5D8)
In-Reply-To: <1334267661-14654-1-git-send-email-wey-yi.w.guy@intel.com>
References: <1334267661-14654-1-git-send-email-wey-yi.w.guy@intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Meenakshi Venkataraman <meenakshi.venkataraman@intel.com>

Move this as part of iwl-core.c cleanup.

Signed-off-by: Meenakshi Venkataraman <meenakshi.venkataraman@intel.com>
Signed-off-by: Wey-Yi Guy <wey-yi.w.guy@intel.com>
---
 drivers/net/wireless/iwlwifi/iwl-agn.c  |   19 +++++++++++++++++++
 drivers/net/wireless/iwlwifi/iwl-agn.h  |    2 ++
 drivers/net/wireless/iwlwifi/iwl-core.c |   20 --------------------
 drivers/net/wireless/iwlwifi/iwl-core.h |    3 ---
 4 files changed, 21 insertions(+), 23 deletions(-)

diff --git a/drivers/net/wireless/iwlwifi/iwl-agn.c b/drivers/net/wireless/iwlwifi/iwl-agn.c
index 3d3302a..09367d4 100644
--- a/drivers/net/wireless/iwlwifi/iwl-agn.c
+++ b/drivers/net/wireless/iwlwifi/iwl-agn.c
@@ -289,6 +289,25 @@ out:
 	mutex_unlock(&priv->mutex);
 }
 
+int iwl_send_statistics_request(struct iwl_priv *priv, u8 flags, bool clear)
+{
+	struct iwl_statistics_cmd statistics_cmd = {
+		.configuration_flags =
+			clear ? IWL_STATS_CONF_CLEAR_STATS : 0,
+	};
+
+	if (flags & CMD_ASYNC)
+		return iwl_dvm_send_cmd_pdu(priv, REPLY_STATISTICS_CMD,
+					CMD_ASYNC,
+					sizeof(struct iwl_statistics_cmd),
+					&statistics_cmd);
+	else
+		return iwl_dvm_send_cmd_pdu(priv, REPLY_STATISTICS_CMD,
+					CMD_SYNC,
+					sizeof(struct iwl_statistics_cmd),
+					&statistics_cmd);
+}
+
 /**
  * iwl_bg_statistics_periodic - Timer callback to queue statistics
  *
diff --git a/drivers/net/wireless/iwlwifi/iwl-agn.h b/drivers/net/wireless/iwlwifi/iwl-agn.h
index 4552319..a2f68d5 100644
--- a/drivers/net/wireless/iwlwifi/iwl-agn.h
+++ b/drivers/net/wireless/iwlwifi/iwl-agn.h
@@ -159,6 +159,8 @@ void iwlagn_temperature(struct iwl_priv *priv);
 int iwlagn_txfifo_flush(struct iwl_priv *priv, u16 flush_control);
 void iwlagn_dev_txfifo_flush(struct iwl_priv *priv, u16 flush_control);
 int iwlagn_send_beacon_cmd(struct iwl_priv *priv);
+int iwl_send_statistics_request(struct iwl_priv *priv,
+				u8 flags, bool clear);
 #ifdef CONFIG_PM_SLEEP
 int iwlagn_send_patterns(struct iwl_priv *priv,
 			 struct cfg80211_wowlan *wowlan);
diff --git a/drivers/net/wireless/iwlwifi/iwl-core.c b/drivers/net/wireless/iwlwifi/iwl-core.c
index e839719..ae542b7 100644
--- a/drivers/net/wireless/iwlwifi/iwl-core.c
+++ b/drivers/net/wireless/iwlwifi/iwl-core.c
@@ -43,26 +43,6 @@
 
 const u8 iwl_bcast_addr[ETH_ALEN] = { 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF };
 
-int iwl_send_statistics_request(struct iwl_priv *priv, u8 flags, bool clear)
-{
-	struct iwl_statistics_cmd statistics_cmd = {
-		.configuration_flags =
-			clear ? IWL_STATS_CONF_CLEAR_STATS : 0,
-	};
-
-	if (flags & CMD_ASYNC)
-		return iwl_dvm_send_cmd_pdu(priv, REPLY_STATISTICS_CMD,
-					      CMD_ASYNC,
-					       sizeof(struct iwl_statistics_cmd),
-					       &statistics_cmd);
-	else
-		return iwl_dvm_send_cmd_pdu(priv, REPLY_STATISTICS_CMD,
-					CMD_SYNC,
-					sizeof(struct iwl_statistics_cmd),
-					&statistics_cmd);
-}
-
-
 
 
 #ifdef CONFIG_IWLWIFI_DEBUGFS
diff --git a/drivers/net/wireless/iwlwifi/iwl-core.h b/drivers/net/wireless/iwlwifi/iwl-core.h
index 4d17b85..db340ce 100644
--- a/drivers/net/wireless/iwlwifi/iwl-core.h
+++ b/drivers/net/wireless/iwlwifi/iwl-core.h
@@ -153,9 +153,6 @@ int __must_check iwl_scan_initiate(struct iwl_priv *priv,
  *   S e n d i n g     H o s t     C o m m a n d s   *
  *****************************************************/
 
-extern int iwl_send_statistics_request(struct iwl_priv *priv,
-				       u8 flags, bool clear);
-
 static inline const struct ieee80211_supported_band *iwl_get_hw_mode(
 			struct iwl_priv *priv, enum ieee80211_band band)
 {
-- 
1.7.0.4

