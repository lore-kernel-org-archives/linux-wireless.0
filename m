Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga11.intel.com ([192.55.52.93]:61902 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751148Ab1JJPQ1 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 10 Oct 2011 11:16:27 -0400
From: Wey-Yi Guy <wey-yi.w.guy@intel.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org,
	Johannes Berg <johannes.berg@intel.com>,
	Wey-Yi Guy <wey-yi.w.guy@intel.com>
Subject: [PATCH 07/34] iwlagn: update beacon smarter
Date: Mon, 10 Oct 2011 07:26:52 -0700
Message-Id: <1318256839-31837-8-git-send-email-wey-yi.w.guy@intel.com> (sfid-20111010_171727_756818_46348FE4)
In-Reply-To: <1318256839-31837-1-git-send-email-wey-yi.w.guy@intel.com>
References: <1318256839-31837-1-git-send-email-wey-yi.w.guy@intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Johannes Berg <johannes.berg@intel.com>

Updating the beacon every time right after one was
transmitted is pointless, most of the time we might
not even have to update it. We will update it every
time it changes, which includes from set_tim(), a
callback iwlwifi didn't implement so far.

This also reduces latency for clients, previously
we would update the beacon right after the previous
one was transmitted, and then a TIM change would
only take effect after that again -- updating the
beacon right after the TIM changes makes the TIM
change go out to the air faster.

Signed-off-by: Johannes Berg <johannes.berg@intel.com>
Signed-off-by: Wey-Yi Guy <wey-yi.w.guy@intel.com>
---
 drivers/net/wireless/iwlwifi/iwl-agn.c |   11 +++++++++++
 drivers/net/wireless/iwlwifi/iwl-rx.c  |    2 --
 2 files changed, 11 insertions(+), 2 deletions(-)

diff --git a/drivers/net/wireless/iwlwifi/iwl-agn.c b/drivers/net/wireless/iwlwifi/iwl-agn.c
index d0fd6f0..74ac478 100644
--- a/drivers/net/wireless/iwlwifi/iwl-agn.c
+++ b/drivers/net/wireless/iwlwifi/iwl-agn.c
@@ -3074,6 +3074,16 @@ static void iwl_mac_rssi_callback(struct ieee80211_hw *hw,
 	mutex_unlock(&priv->shrd->mutex);
 }
 
+static int iwl_mac_set_tim(struct ieee80211_hw *hw,
+			   struct ieee80211_sta *sta, bool set)
+{
+	struct iwl_priv *priv = hw->priv;
+
+	queue_work(priv->shrd->workqueue, &priv->beacon_update);
+
+	return 0;
+}
+
 struct ieee80211_ops iwlagn_hw_ops = {
 	.tx = iwlagn_mac_tx,
 	.start = iwlagn_mac_start,
@@ -3107,6 +3117,7 @@ struct ieee80211_ops iwlagn_hw_ops = {
 	CFG80211_TESTMODE_DUMP(iwl_testmode_dump)
 	.tx_sync = iwl_mac_tx_sync,
 	.finish_tx_sync = iwl_mac_finish_tx_sync,
+	.set_tim = iwl_mac_set_tim,
 };
 
 static u32 iwl_hw_detect(struct iwl_priv *priv)
diff --git a/drivers/net/wireless/iwlwifi/iwl-rx.c b/drivers/net/wireless/iwlwifi/iwl-rx.c
index bbd6740..1d781bc 100644
--- a/drivers/net/wireless/iwlwifi/iwl-rx.c
+++ b/drivers/net/wireless/iwlwifi/iwl-rx.c
@@ -243,8 +243,6 @@ static int iwl_rx_beacon_notif(struct iwl_priv *priv,
 
 	priv->ibss_manager = le32_to_cpu(beacon->ibss_mgr_status);
 
-	if (!test_bit(STATUS_EXIT_PENDING, &priv->shrd->status))
-		queue_work(priv->shrd->workqueue, &priv->beacon_update);
 	return 0;
 }
 
-- 
1.7.0.4

