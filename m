Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga11.intel.com ([192.55.52.93]:31149 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751276Ab1JJPQ2 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 10 Oct 2011 11:16:28 -0400
From: Wey-Yi Guy <wey-yi.w.guy@intel.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org, Wey-Yi Guy <wey-yi.w.guy@intel.com>
Subject: [PATCH 14/34] iwlagn: set rts retry limit
Date: Mon, 10 Oct 2011 07:26:59 -0700
Message-Id: <1318256839-31837-15-git-send-email-wey-yi.w.guy@intel.com> (sfid-20111010_171736_369123_42D69EC0)
In-Reply-To: <1318256839-31837-1-git-send-email-wey-yi.w.guy@intel.com>
References: <1318256839-31837-1-git-send-email-wey-yi.w.guy@intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

setup the rts rety limit for tx command

Signed-off-by: Wey-Yi Guy <wey-yi.w.guy@intel.com>
---
 drivers/net/wireless/iwlwifi/iwl-agn-hw.h |    5 ++++-
 drivers/net/wireless/iwlwifi/iwl-agn-tx.c |   18 +++++++++---------
 2 files changed, 13 insertions(+), 10 deletions(-)

diff --git a/drivers/net/wireless/iwlwifi/iwl-agn-hw.h b/drivers/net/wireless/iwlwifi/iwl-agn-hw.h
index 33951a1..64e3417 100644
--- a/drivers/net/wireless/iwlwifi/iwl-agn-hw.h
+++ b/drivers/net/wireless/iwlwifi/iwl-agn-hw.h
@@ -81,7 +81,10 @@
 /* RSSI to dBm */
 #define IWLAGN_RSSI_OFFSET	44
 
-#define IWLAGN_DEFAULT_TX_RETRY  15
+#define IWLAGN_DEFAULT_TX_RETRY			15
+#define IWLAGN_MGMT_DFAULT_RETRY_LIMIT		3
+#define IWLAGN_RTS_DFAULT_RETRY_LIMIT		60
+#define IWLAGN_BAR_DFAULT_RETRY_LIMIT		60
 
 /* Limit range of txpower output target to be between these values */
 #define IWLAGN_TX_POWER_TARGET_POWER_MIN	(0)	/* 0 dBm: 1 milliwatt */
diff --git a/drivers/net/wireless/iwlwifi/iwl-agn-tx.c b/drivers/net/wireless/iwlwifi/iwl-agn-tx.c
index dcb3bd6..2584f6f 100644
--- a/drivers/net/wireless/iwlwifi/iwl-agn-tx.c
+++ b/drivers/net/wireless/iwlwifi/iwl-agn-tx.c
@@ -113,8 +113,6 @@ static void iwlagn_tx_cmd_build_basic(struct iwl_priv *priv,
 	tx_cmd->next_frame_len = 0;
 }
 
-#define RTS_DFAULT_RETRY_LIMIT		60
-
 static void iwlagn_tx_cmd_build_rate(struct iwl_priv *priv,
 				     struct iwl_tx_cmd *tx_cmd,
 				     struct ieee80211_tx_info *info,
@@ -126,17 +124,19 @@ static void iwlagn_tx_cmd_build_rate(struct iwl_priv *priv,
 	u8 data_retry_limit;
 	u8 rate_plcp;
 
+	/* Set retry limit on RTS packets */
+	rts_retry_limit = IWLAGN_RTS_DFAULT_RETRY_LIMIT;
+
 	/* Set retry limit on DATA packets and Probe Responses*/
-	if (ieee80211_is_probe_resp(fc))
-		data_retry_limit = 3;
+	if (ieee80211_is_probe_resp(fc)) {
+		data_retry_limit = IWLAGN_MGMT_DFAULT_RETRY_LIMIT;
+		rts_retry_limit = min(data_retry_limit, rts_retry_limit);
+	} else if (ieee80211_is_back_req(fc))
+		data_retry_limit = IWLAGN_BAR_DFAULT_RETRY_LIMIT;
 	else
 		data_retry_limit = IWLAGN_DEFAULT_TX_RETRY;
-	tx_cmd->data_retry_limit = data_retry_limit;
 
-	/* Set retry limit on RTS packets */
-	rts_retry_limit = RTS_DFAULT_RETRY_LIMIT;
-	if (data_retry_limit < rts_retry_limit)
-		rts_retry_limit = data_retry_limit;
+	tx_cmd->data_retry_limit = data_retry_limit;
 	tx_cmd->rts_retry_limit = rts_retry_limit;
 
 	/* DATA packets will use the uCode station table for rate/antenna
-- 
1.7.0.4

