Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga14.intel.com ([143.182.124.37]:39824 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751441AbYHYGbe (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 25 Aug 2008 02:31:34 -0400
From: Zhu Yi <yi.zhu@intel.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org,
	Ron Rindjunsky <ron.rindjunsky@intel.com>,
	Tomas Winkler <tomas.winkler@intel.com>,
	Zhu Yi <yi.zhu@intel.com>
Subject: [PATCH 2.6.27] iwlwifi: use station's mimo power save values
Date: Mon, 25 Aug 2008 14:27:41 +0800
Message-Id: <1219645661-8166-1-git-send-email-yi.zhu@intel.com> (sfid-20080825_083138_922634_DB92FC4A)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Ron Rindjunsky <ron.rindjunsky@intel.com>

This patch fixes the wrong use of self mimo power save values instead of
peer's mimo power save values.

Signed-off-by: Ron Rindjunsky <ron.rindjunsky@intel.com>
Signed-off-by: Tomas Winkler <tomas.winkler@intel.com>
Signed-off-by: Zhu Yi <yi.zhu@intel.com>
---
 drivers/net/wireless/iwlwifi/iwl-agn-rs.c |    3 ++-
 drivers/net/wireless/iwlwifi/iwl-agn.c    |    2 --
 drivers/net/wireless/iwlwifi/iwl-dev.h    |    1 -
 3 files changed, 2 insertions(+), 4 deletions(-)

diff --git a/drivers/net/wireless/iwlwifi/iwl-agn-rs.c b/drivers/net/wireless/iwlwifi/iwl-agn-rs.c
index 754fef5..90a2b6d 100644
--- a/drivers/net/wireless/iwlwifi/iwl-agn-rs.c
+++ b/drivers/net/wireless/iwlwifi/iwl-agn-rs.c
@@ -1153,7 +1153,8 @@ static int rs_switch_to_mimo2(struct iwl_priv *priv,
 	    !sta->ht_info.ht_supported)
 		return -1;
 
-	if (priv->current_ht_config.tx_mimo_ps_mode == IWL_MIMO_PS_STATIC)
+	if (((sta->ht_info.cap & IEEE80211_HT_CAP_MIMO_PS) >> 2)
+						== IWL_MIMO_PS_STATIC)
 		return -1;
 
 	/* Need both Tx chains/antennas to support MIMO */
diff --git a/drivers/net/wireless/iwlwifi/iwl-agn.c b/drivers/net/wireless/iwlwifi/iwl-agn.c
index 3cec88e..cd403d1 100644
--- a/drivers/net/wireless/iwlwifi/iwl-agn.c
+++ b/drivers/net/wireless/iwlwifi/iwl-agn.c
@@ -587,8 +587,6 @@ static void iwl4965_ht_conf(struct iwl_priv *priv,
 		iwl_conf->supported_chan_width = 0;
 	}
 
-	iwl_conf->tx_mimo_ps_mode =
-		(u8)((ht_conf->cap & IEEE80211_HT_CAP_MIMO_PS) >> 2);
 	memcpy(iwl_conf->supp_mcs_set, ht_conf->supp_mcs_set, 16);
 
 	iwl_conf->control_channel = ht_bss_conf->primary_channel;
diff --git a/drivers/net/wireless/iwlwifi/iwl-dev.h b/drivers/net/wireless/iwlwifi/iwl-dev.h
index b00acf4..deec634 100644
--- a/drivers/net/wireless/iwlwifi/iwl-dev.h
+++ b/drivers/net/wireless/iwlwifi/iwl-dev.h
@@ -412,7 +412,6 @@ struct iwl_ht_info {
 	/* self configuration data */
 	u8 is_ht;
 	u8 supported_chan_width;
-	u16 tx_mimo_ps_mode;
 	u8 is_green_field;
 	u8 sgf;			/* HT_SHORT_GI_* short guard interval */
 	u8 max_amsdu_size;
-- 
1.5.3.6

