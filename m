Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga09.intel.com ([134.134.136.24]:55973 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754894Ab2CDUm5 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Sun, 4 Mar 2012 15:42:57 -0500
From: Wey-Yi Guy <wey-yi.w.guy@intel.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org,
	Johannes Berg <johannes.berg@intel.com>,
	Wey-Yi Guy <wey-yi.w.guy@intel.com>
Subject: [PATCH 005/101] iwlwifi: build some station commands directly
Date: Sun,  4 Mar 2012 11:28:19 -0800
Message-Id: <1330889395-533-6-git-send-email-wey-yi.w.guy@intel.com> (sfid-20120304_214655_880963_8470EEBC)
In-Reply-To: <1330889395-533-1-git-send-email-wey-yi.w.guy@intel.com>
References: <1330889395-533-1-git-send-email-wey-yi.w.guy@intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Johannes Berg <johannes.berg@intel.com>

In the powersave related functions we only need
to set a few parameters for the station command
and can otherwise leave it blank -- there's no
need to copy it from the database.

This allows us to not use the sta lock here.

Signed-off-by: Johannes Berg <johannes.berg@intel.com>
Signed-off-by: Wey-Yi Guy <wey-yi.w.guy@intel.com>
---
 drivers/net/wireless/iwlwifi/iwl-agn-sta.c  |   20 +++++++++-----------
 drivers/net/wireless/iwlwifi/iwl-mac80211.c |   16 ++++++----------
 2 files changed, 15 insertions(+), 21 deletions(-)

diff --git a/drivers/net/wireless/iwlwifi/iwl-agn-sta.c b/drivers/net/wireless/iwlwifi/iwl-agn-sta.c
index 3eb8fd4..6b9af99 100644
--- a/drivers/net/wireless/iwlwifi/iwl-agn-sta.c
+++ b/drivers/net/wireless/iwlwifi/iwl-agn-sta.c
@@ -1437,16 +1437,14 @@ int iwl_sta_rx_agg_stop(struct iwl_priv *priv, struct ieee80211_sta *sta,
 
 void iwl_sta_modify_sleep_tx_count(struct iwl_priv *priv, int sta_id, int cnt)
 {
-	unsigned long flags;
-
-	spin_lock_irqsave(&priv->shrd->sta_lock, flags);
-	priv->stations[sta_id].sta.station_flags |= STA_FLG_PWR_SAVE_MSK;
-	priv->stations[sta_id].sta.station_flags_msk = STA_FLG_PWR_SAVE_MSK;
-	priv->stations[sta_id].sta.sta.modify_mask =
-					STA_MODIFY_SLEEP_TX_COUNT_MSK;
-	priv->stations[sta_id].sta.sleep_tx_count = cpu_to_le16(cnt);
-	priv->stations[sta_id].sta.mode = STA_CONTROL_MODIFY_MSK;
-	iwl_send_add_sta(priv, &priv->stations[sta_id].sta, CMD_ASYNC);
-	spin_unlock_irqrestore(&priv->shrd->sta_lock, flags);
+	struct iwl_addsta_cmd cmd = {
+		.mode = STA_CONTROL_MODIFY_MSK,
+		.station_flags = STA_FLG_PWR_SAVE_MSK,
+		.station_flags_msk = STA_FLG_PWR_SAVE_MSK,
+		.sta.sta_id = sta_id,
+		.sta.modify_mask = STA_MODIFY_SLEEP_TX_COUNT_MSK,
+		.sleep_tx_count = cpu_to_le16(cnt),
+	};
 
+	iwl_send_add_sta(priv, &cmd, CMD_ASYNC);
 }
diff --git a/drivers/net/wireless/iwlwifi/iwl-mac80211.c b/drivers/net/wireless/iwlwifi/iwl-mac80211.c
index 03f7705..9fba532 100644
--- a/drivers/net/wireless/iwlwifi/iwl-mac80211.c
+++ b/drivers/net/wireless/iwlwifi/iwl-mac80211.c
@@ -1505,17 +1505,13 @@ static int iwlagn_mac_sta_remove(struct ieee80211_hw *hw,
 
 static void iwl_sta_modify_ps_wake(struct iwl_priv *priv, int sta_id)
 {
-	unsigned long flags;
-
-	spin_lock_irqsave(&priv->shrd->sta_lock, flags);
-	priv->stations[sta_id].sta.station_flags &= ~STA_FLG_PWR_SAVE_MSK;
-	priv->stations[sta_id].sta.station_flags_msk = STA_FLG_PWR_SAVE_MSK;
-	priv->stations[sta_id].sta.sta.modify_mask = 0;
-	priv->stations[sta_id].sta.sleep_tx_count = 0;
-	priv->stations[sta_id].sta.mode = STA_CONTROL_MODIFY_MSK;
-	iwl_send_add_sta(priv, &priv->stations[sta_id].sta, CMD_ASYNC);
-	spin_unlock_irqrestore(&priv->shrd->sta_lock, flags);
+	struct iwl_addsta_cmd cmd = {
+		.mode = STA_CONTROL_MODIFY_MSK,
+		.station_flags_msk = STA_FLG_PWR_SAVE_MSK,
+		.sta.sta_id = sta_id,
+	};
 
+	iwl_send_add_sta(priv, &cmd, CMD_ASYNC);
 }
 
 static void iwlagn_mac_sta_notify(struct ieee80211_hw *hw,
-- 
1.7.0.4

