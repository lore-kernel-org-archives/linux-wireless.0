Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga02.intel.com ([134.134.136.20]:46218 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S935339Ab1KJPth (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 10 Nov 2011 10:49:37 -0500
From: Wey-Yi Guy <wey-yi.w.guy@intel.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org, Wey-Yi Guy <wey-yi.w.guy@intel.com>
Subject: [PATCH RESEND 04/27] iwlagn: check for SMPS mode
Date: Thu, 10 Nov 2011 06:55:04 -0800
Message-Id: <1320936927-9078-5-git-send-email-wey-yi.w.guy@intel.com> (sfid-20111110_164946_238728_9E8F1DB6)
In-Reply-To: <1320936927-9078-1-git-send-email-wey-yi.w.guy@intel.com>
References: <1320936927-9078-1-git-send-email-wey-yi.w.guy@intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Check and report WARN only when its invalid

Signed-off-by: Wey-Yi Guy <wey-yi.w.guy@intel.com>
---
 drivers/net/wireless/iwlwifi/iwl-agn-lib.c  |    1 +
 drivers/net/wireless/iwlwifi/iwl-agn-rxon.c |    3 +++
 2 files changed, 4 insertions(+), 0 deletions(-)

diff --git a/drivers/net/wireless/iwlwifi/iwl-agn-lib.c b/drivers/net/wireless/iwlwifi/iwl-agn-lib.c
index 1a52ed2..6465983 100644
--- a/drivers/net/wireless/iwlwifi/iwl-agn-lib.c
+++ b/drivers/net/wireless/iwlwifi/iwl-agn-lib.c
@@ -827,6 +827,7 @@ static int iwl_get_idle_rx_chain_count(struct iwl_priv *priv, int active_cnt)
 	case IEEE80211_SMPS_STATIC:
 	case IEEE80211_SMPS_DYNAMIC:
 		return IWL_NUM_IDLE_CHAINS_SINGLE;
+	case IEEE80211_SMPS_AUTOMATIC:
 	case IEEE80211_SMPS_OFF:
 		return active_cnt;
 	default:
diff --git a/drivers/net/wireless/iwlwifi/iwl-agn-rxon.c b/drivers/net/wireless/iwlwifi/iwl-agn-rxon.c
index 4c52bee..8e45fba 100644
--- a/drivers/net/wireless/iwlwifi/iwl-agn-rxon.c
+++ b/drivers/net/wireless/iwlwifi/iwl-agn-rxon.c
@@ -542,6 +542,9 @@ int iwlagn_mac_config(struct ieee80211_hw *hw, u32 changed)
 
 	mutex_lock(&priv->shrd->mutex);
 
+	if (test_bit(STATUS_EXIT_PENDING, &priv->shrd->status))
+		goto out;
+
 	if (unlikely(test_bit(STATUS_SCANNING, &priv->shrd->status))) {
 		IWL_DEBUG_MAC80211(priv, "leave - scanning\n");
 		goto out;
-- 
1.7.0.4

