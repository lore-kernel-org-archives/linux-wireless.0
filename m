Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga09.intel.com ([134.134.136.24]:60978 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752296AbYFLBtm (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 11 Jun 2008 21:49:42 -0400
From: Zhu Yi <yi.zhu@intel.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org,
	Emmanuel Grumbach <emmanuel.grumbach@intel.com>,
	Guy Cohen <guy.cohen@intel.com>,
	Tomas Winkler <tomas.winkler@intel.com>
Subject: [PATCH 11/29] iwlwifi: fix bug when moving from 11gn to 11a or 11an to 11g
Date: Thu, 12 Jun 2008 09:47:01 +0800
Message-Id: <1213235239-2954-12-git-send-email-yi.zhu@intel.com> (sfid-20080612_041916_675711_3C7EACD8)
In-Reply-To: <1213235239-2954-11-git-send-email-yi.zhu@intel.com>
References: <1213235239-2954-1-git-send-email-yi.zhu@intel.com>
 <1213235239-2954-2-git-send-email-yi.zhu@intel.com>
 <1213235239-2954-3-git-send-email-yi.zhu@intel.com>
 <1213235239-2954-4-git-send-email-yi.zhu@intel.com>
 <1213235239-2954-5-git-send-email-yi.zhu@intel.com>
 <1213235239-2954-6-git-send-email-yi.zhu@intel.com>
 <1213235239-2954-7-git-send-email-yi.zhu@intel.com>
 <1213235239-2954-8-git-send-email-yi.zhu@intel.com>
 <1213235239-2954-9-git-send-email-yi.zhu@intel.com>
 <1213235239-2954-10-git-send-email-yi.zhu@intel.com>
 <1213235239-2954-11-git-send-email-yi.zhu@intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Emmanuel Grumbach <emmanuel.grumbach@intel.com>

It is wrong to set the rxon channel according to the ht-channel
in case there is a mismatch (e.g. when there is no ht).

Signed-off-by: Guy Cohen <guy.cohen@intel.com>
Signed-off-by: Tomas Winkler <tomas.winkler@intel.com>
---
 drivers/net/wireless/iwlwifi/iwl-core.c |    1 -
 drivers/net/wireless/iwlwifi/iwl-dev.h  |    2 --
 2 files changed, 0 insertions(+), 3 deletions(-)

diff --git a/drivers/net/wireless/iwlwifi/iwl-core.c b/drivers/net/wireless/iwlwifi/iwl-core.c
index fad26f7..7d0a257 100644
--- a/drivers/net/wireless/iwlwifi/iwl-core.c
+++ b/drivers/net/wireless/iwlwifi/iwl-core.c
@@ -597,7 +597,6 @@ void iwl_set_rxon_ht(struct iwl_priv *priv, struct iwl_ht_info *ht_info)
 		IWL_DEBUG_ASSOC("control diff than current %d %d\n",
 				le16_to_cpu(rxon->channel),
 				ht_info->control_channel);
-		rxon->channel = cpu_to_le16(ht_info->control_channel);
 		return;
 	}
 
diff --git a/drivers/net/wireless/iwlwifi/iwl-dev.h b/drivers/net/wireless/iwlwifi/iwl-dev.h
index daa14d9..ac68cce 100644
--- a/drivers/net/wireless/iwlwifi/iwl-dev.h
+++ b/drivers/net/wireless/iwlwifi/iwl-dev.h
@@ -742,8 +742,6 @@ extern void iwl4965_hwrate_to_tx_control(struct iwl_priv *priv,
 extern void iwl4965_init_ht_hw_capab(const struct iwl_priv *priv,
 				struct ieee80211_ht_info *ht_info,
 				enum ieee80211_band band);
-void iwl4965_set_rxon_ht(struct iwl_priv *priv,
-			 struct iwl_ht_info *ht_info);
 int iwl4965_mac_ampdu_action(struct ieee80211_hw *hw,
 				    enum ieee80211_ampdu_mlme_action action,
 				    const u8 *addr, u16 tid, u16 *ssn);
-- 
1.5.3.6

