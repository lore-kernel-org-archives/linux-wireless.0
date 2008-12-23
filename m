Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.atheros.com ([12.36.123.2]:22678 "EHLO mail.atheros.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751487AbYLWX7Y (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 23 Dec 2008 18:59:24 -0500
Received: from mail.atheros.com ([10.10.20.108])
	by sidewinder.atheros.com
	for <linux-wireless@vger.kernel.org>; Tue, 23 Dec 2008 15:59:24 -0800
From: "Luis R. Rodriguez" <lrodriguez@atheros.com>
To: <linville@tuxdriver.com>, <linville@tuxdriver.com>
CC: "Luis R. Rodriguez" <lrodriguez@atheros.com>,
	<linux-wireless@vger.kernel.org>, <ath9k-devel@lists.ath9k.org>
Subject: [PATCH v3 09/16] iwlwifi: make use of conf_is_ht*() helpers
Date: Tue, 23 Dec 2008 15:58:44 -0800
Message-ID: <1230076731-22946-10-git-send-email-lrodriguez@atheros.com> (sfid-20081224_005926_735729_0B0EAAB8)
In-Reply-To: <1230076731-22946-9-git-send-email-lrodriguez@atheros.com>
References: <1230076731-22946-1-git-send-email-lrodriguez@atheros.com>
 <1230076731-22946-2-git-send-email-lrodriguez@atheros.com>
 <1230076731-22946-3-git-send-email-lrodriguez@atheros.com>
 <1230076731-22946-4-git-send-email-lrodriguez@atheros.com>
 <1230076731-22946-5-git-send-email-lrodriguez@atheros.com>
 <1230076731-22946-6-git-send-email-lrodriguez@atheros.com>
 <1230076731-22946-7-git-send-email-lrodriguez@atheros.com>
 <1230076731-22946-8-git-send-email-lrodriguez@atheros.com>
 <1230076731-22946-9-git-send-email-lrodriguez@atheros.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Signed-off-by: Luis R. Rodriguez <lrodriguez@atheros.com>
Acked-by: Johannes Berg <johannes@sipsolutions.net>
---
 drivers/net/wireless/iwlwifi/iwl-agn-rs.c |    6 +++---
 drivers/net/wireless/iwlwifi/iwl-agn.c    |    6 +++---
 2 files changed, 6 insertions(+), 6 deletions(-)

diff --git a/drivers/net/wireless/iwlwifi/iwl-agn-rs.c b/drivers/net/wireless/iwlwifi/iwl-agn-rs.c
index f032167..59d4e11 100644
--- a/drivers/net/wireless/iwlwifi/iwl-agn-rs.c
+++ b/drivers/net/wireless/iwlwifi/iwl-agn-rs.c
@@ -1131,7 +1131,7 @@ static int rs_switch_to_mimo2(struct iwl_priv *priv,
 	s32 rate;
 	s8 is_green = lq_sta->is_green;
 
-	if (!conf->ht.enabled || !sta->ht_cap.ht_supported)
+	if (!conf_is_ht(conf) || !sta->ht_cap.ht_supported)
 		return -1;
 
 	if (((sta->ht_cap.cap & IEEE80211_HT_CAP_SM_PS) >> 2)
@@ -1198,7 +1198,7 @@ static int rs_switch_to_siso(struct iwl_priv *priv,
 	u8 is_green = lq_sta->is_green;
 	s32 rate;
 
-	if (!conf->ht.enabled || !sta->ht_cap.ht_supported)
+	if (!conf_is_ht(conf) || !sta->ht_cap.ht_supported)
 		return -1;
 
 	IWL_DEBUG_RATE("LQ: try to switch to SISO\n");
@@ -1998,7 +1998,7 @@ lq_update:
 		 * stay with best antenna legacy modulation for a while
 		 * before next round of mode comparisons. */
 		tbl1 = &(lq_sta->lq_info[lq_sta->active_tbl]);
-		if (is_legacy(tbl1->lq_type) && !conf->ht.enabled &&
+		if (is_legacy(tbl1->lq_type) && !conf_is_ht(conf) &&
 		    lq_sta->action_counter >= 1) {
 			lq_sta->action_counter = 0;
 			IWL_DEBUG_RATE("LQ: STAY in legacy table\n");
diff --git a/drivers/net/wireless/iwlwifi/iwl-agn.c b/drivers/net/wireless/iwlwifi/iwl-agn.c
index 002a151..b2b566e 100644
--- a/drivers/net/wireless/iwlwifi/iwl-agn.c
+++ b/drivers/net/wireless/iwlwifi/iwl-agn.c
@@ -523,9 +523,9 @@ static void iwl_ht_conf(struct iwl_priv *priv,
 	 */
 
 	iwl_conf->extension_chan_offset = IEEE80211_HT_PARAM_CHA_SEC_NONE;
-	if (priv->hw->conf.ht.channel_type == NL80211_CHAN_HT40MINUS)
+	if (conf_is_ht40_minus(&priv->hw->conf))
 		iwl_conf->extension_chan_offset = IEEE80211_HT_PARAM_CHA_SEC_BELOW;
-	else if(priv->hw->conf.ht.channel_type == NL80211_CHAN_HT40PLUS)
+	else if (conf_is_ht40_plus(&priv->hw->conf))
 		iwl_conf->extension_chan_offset = IEEE80211_HT_PARAM_CHA_SEC_ABOVE;
 
 	/* If no above or below channel supplied disable FAT channel */
@@ -2553,7 +2553,7 @@ static int iwl_mac_config(struct ieee80211_hw *hw, u32 changed)
 	mutex_lock(&priv->mutex);
 	IWL_DEBUG_MAC80211("enter to channel %d\n", conf->channel->hw_value);
 
-	priv->current_ht_config.is_ht = conf->ht.enabled;
+	priv->current_ht_config.is_ht = conf_is_ht(conf);
 
 	if (conf->radio_enabled && iwl_radio_kill_sw_enable_radio(priv)) {
 		IWL_DEBUG_MAC80211("leave - RF-KILL - waiting for uCode\n");
-- 
1.6.1.rc3.51.g5832d

