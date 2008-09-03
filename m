Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga01.intel.com ([192.55.52.88]:56324 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755033AbYICDbW (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 2 Sep 2008 23:31:22 -0400
From: Zhu Yi <yi.zhu@intel.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org,
	Ron Rindjunsky <ron.rindjunsky@intel.com>,
	Tomas Winkler <tomas.winkler@intel.com>,
	Zhu Yi <yi.zhu@intel.com>
Subject: [PATCH 20/39] iwlwifi: use station's mimo power save values
Date: Wed,  3 Sep 2008 11:26:40 +0800
Message-Id: <1220412419-15404-21-git-send-email-yi.zhu@intel.com> (sfid-20080903_055040_300075_05B8A060)
In-Reply-To: <1220412419-15404-20-git-send-email-yi.zhu@intel.com>
References: <1220412419-15404-1-git-send-email-yi.zhu@intel.com>
 <1220412419-15404-2-git-send-email-yi.zhu@intel.com>
 <1220412419-15404-3-git-send-email-yi.zhu@intel.com>
 <1220412419-15404-4-git-send-email-yi.zhu@intel.com>
 <1220412419-15404-5-git-send-email-yi.zhu@intel.com>
 <1220412419-15404-6-git-send-email-yi.zhu@intel.com>
 <1220412419-15404-7-git-send-email-yi.zhu@intel.com>
 <1220412419-15404-8-git-send-email-yi.zhu@intel.com>
 <1220412419-15404-9-git-send-email-yi.zhu@intel.com>
 <1220412419-15404-10-git-send-email-yi.zhu@intel.com>
 <1220412419-15404-11-git-send-email-yi.zhu@intel.com>
 <1220412419-15404-12-git-send-email-yi.zhu@intel.com>
 <1220412419-15404-13-git-send-email-yi.zhu@intel.com>
 <1220412419-15404-14-git-send-email-yi.zhu@intel.com>
 <1220412419-15404-15-git-send-email-yi.zhu@intel.com>
 <1220412419-15404-16-git-send-email-yi.zhu@intel.com>
 <1220412419-15404-17-git-send-email-yi.zhu@intel.com>
 <1220412419-15404-18-git-send-email-yi.zhu@intel.com>
 <1220412419-15404-19-git-send-email-yi.zhu@intel.com>
 <1220412419-15404-20-git-send-email-yi.zhu@intel.com>
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
index f3c96ad..326ab01 100644
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
index 5a55c87..ee38697 100644
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

