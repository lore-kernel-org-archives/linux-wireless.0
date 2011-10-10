Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga11.intel.com ([192.55.52.93]:61902 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751310Ab1JJPQ3 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 10 Oct 2011 11:16:29 -0400
From: Wey-Yi Guy <wey-yi.w.guy@intel.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org, Wey-Yi Guy <wey-yi.w.guy@intel.com>
Subject: [PATCH 21/34] iwlagn: use low retry limit for WoWLAN
Date: Mon, 10 Oct 2011 07:27:06 -0700
Message-Id: <1318256839-31837-22-git-send-email-wey-yi.w.guy@intel.com> (sfid-20111010_171654_601096_B0238118)
In-Reply-To: <1318256839-31837-1-git-send-email-wey-yi.w.guy@intel.com>
References: <1318256839-31837-1-git-send-email-wey-yi.w.guy@intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

When in D3 state, use low retry limit for both data and rts

Signed-off-by: Wey-Yi Guy <wey-yi.w.guy@intel.com>
---
 drivers/net/wireless/iwlwifi/iwl-agn-hw.h |    1 +
 drivers/net/wireless/iwlwifi/iwl-agn-tx.c |   28 +++++++++++++++++-----------
 2 files changed, 18 insertions(+), 11 deletions(-)

diff --git a/drivers/net/wireless/iwlwifi/iwl-agn-hw.h b/drivers/net/wireless/iwlwifi/iwl-agn-hw.h
index 64e3417..ac039d4 100644
--- a/drivers/net/wireless/iwlwifi/iwl-agn-hw.h
+++ b/drivers/net/wireless/iwlwifi/iwl-agn-hw.h
@@ -85,6 +85,7 @@
 #define IWLAGN_MGMT_DFAULT_RETRY_LIMIT		3
 #define IWLAGN_RTS_DFAULT_RETRY_LIMIT		60
 #define IWLAGN_BAR_DFAULT_RETRY_LIMIT		60
+#define IWLAGN_LOW_RETRY_LIMIT			7
 
 /* Limit range of txpower output target to be between these values */
 #define IWLAGN_TX_POWER_TARGET_POWER_MIN	(0)	/* 0 dBm: 1 milliwatt */
diff --git a/drivers/net/wireless/iwlwifi/iwl-agn-tx.c b/drivers/net/wireless/iwlwifi/iwl-agn-tx.c
index 2584f6f..f849097 100644
--- a/drivers/net/wireless/iwlwifi/iwl-agn-tx.c
+++ b/drivers/net/wireless/iwlwifi/iwl-agn-tx.c
@@ -124,17 +124,23 @@ static void iwlagn_tx_cmd_build_rate(struct iwl_priv *priv,
 	u8 data_retry_limit;
 	u8 rate_plcp;
 
-	/* Set retry limit on RTS packets */
-	rts_retry_limit = IWLAGN_RTS_DFAULT_RETRY_LIMIT;
-
-	/* Set retry limit on DATA packets and Probe Responses*/
-	if (ieee80211_is_probe_resp(fc)) {
-		data_retry_limit = IWLAGN_MGMT_DFAULT_RETRY_LIMIT;
-		rts_retry_limit = min(data_retry_limit, rts_retry_limit);
-	} else if (ieee80211_is_back_req(fc))
-		data_retry_limit = IWLAGN_BAR_DFAULT_RETRY_LIMIT;
-	else
-		data_retry_limit = IWLAGN_DEFAULT_TX_RETRY;
+	if (priv->shrd->wowlan) {
+		rts_retry_limit = IWLAGN_LOW_RETRY_LIMIT;
+		data_retry_limit = IWLAGN_LOW_RETRY_LIMIT;
+	} else {
+		/* Set retry limit on RTS packets */
+		rts_retry_limit = IWLAGN_RTS_DFAULT_RETRY_LIMIT;
+
+		/* Set retry limit on DATA packets and Probe Responses*/
+		if (ieee80211_is_probe_resp(fc)) {
+			data_retry_limit = IWLAGN_MGMT_DFAULT_RETRY_LIMIT;
+			rts_retry_limit =
+				min(data_retry_limit, rts_retry_limit);
+		} else if (ieee80211_is_back_req(fc))
+			data_retry_limit = IWLAGN_BAR_DFAULT_RETRY_LIMIT;
+		else
+			data_retry_limit = IWLAGN_DEFAULT_TX_RETRY;
+	}
 
 	tx_cmd->data_retry_limit = data_retry_limit;
 	tx_cmd->rts_retry_limit = rts_retry_limit;
-- 
1.7.0.4

