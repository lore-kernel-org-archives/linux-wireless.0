Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga09.intel.com ([134.134.136.24]:22294 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754125AbYICDWz (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 2 Sep 2008 23:22:55 -0400
From: Zhu Yi <yi.zhu@intel.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org,
	Ron Rindjunsky <ron.rindjunsky@intel.com>,
	Tomas Winkler <tomas.winkler@intel.com>,
	Zhu Yi <yi.zhu@intel.com>
Subject: [PATCH 5/9] iwlwifi: fix station mimo power save values
Date: Wed,  3 Sep 2008 11:18:46 +0800
Message-Id: <1220411930-15216-6-git-send-email-yi.zhu@intel.com> (sfid-20080903_052308_001470_E92702DF)
In-Reply-To: <1220411930-15216-5-git-send-email-yi.zhu@intel.com>
References: <1220411930-15216-1-git-send-email-yi.zhu@intel.com>
 <1220411930-15216-2-git-send-email-yi.zhu@intel.com>
 <1220411930-15216-3-git-send-email-yi.zhu@intel.com>
 <1220411930-15216-4-git-send-email-yi.zhu@intel.com>
 <1220411930-15216-5-git-send-email-yi.zhu@intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Ron Rindjunsky <ron.rindjunsky@intel.com>

This patch fixes the wrong use MIMO power save values. Our TX was
configured with our MIMO power save values instead of peer's MIMO power
save values, this may affect connectivity. The peer STA/AP may not sense
our traffic at all as it doesn't have all RX chains opened.

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
index a5feb0c..34928c8 100644
--- a/drivers/net/wireless/iwlwifi/iwl-agn.c
+++ b/drivers/net/wireless/iwlwifi/iwl-agn.c
@@ -586,8 +586,6 @@ static void iwl4965_ht_conf(struct iwl_priv *priv,
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

