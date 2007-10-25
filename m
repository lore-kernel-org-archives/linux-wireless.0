Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga02.intel.com ([134.134.136.20]:44836 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754219AbXJYJWo (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 25 Oct 2007 05:22:44 -0400
From: Zhu Yi <yi.zhu@intel.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org,
	Tomas Winkler <tomas.winkler@intel.com>,
	Helmut Schaa <hschaa@suse.de>
Subject: [PATCH 12/30] iwlwifi: fix sending probe request in iwl 4965
Date: Thu, 25 Oct 2007 17:15:33 +0800
Message-Id: <11933037692766-git-send-email-yi.zhu@intel.com> (sfid-20071025_104103_935392_4959374F)
In-Reply-To: <11933037674045-git-send-email-yi.zhu@intel.com>
References: <11933037512140-git-send-email-yi.zhu@intel.com>
 <11933037541699-git-send-email-yi.zhu@intel.com>
 <11933037553170-git-send-email-yi.zhu@intel.com>
 <119330375796-git-send-email-yi.zhu@intel.com>
 <11933037584069-git-send-email-yi.zhu@intel.com>
 <11933037601236-git-send-email-yi.zhu@intel.com>
 <11933037613709-git-send-email-yi.zhu@intel.com>
 <1193303762680-git-send-email-yi.zhu@intel.com>
 <11933037641168-git-send-email-yi.zhu@intel.com>
 <11933037663659-git-send-email-yi.zhu@intel.com>
 <11933037674045-git-send-email-yi.zhu@intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Tomas Winkler <tomas.winkler@intel.com>

This patch removeis TSF flag from probe request. TSF should be added only to
probe response.

Signed-off-by: Helmut Schaa <hschaa@suse.de>
Signed-off-by: Tomas Winkler <tomas.winkler@intel.com>
---
 drivers/net/wireless/iwlwifi/iwl-4965.c |    4 +---
 1 files changed, 1 insertions(+), 3 deletions(-)

diff --git a/drivers/net/wireless/iwlwifi/iwl-4965.c b/drivers/net/wireless/iwlwifi/iwl-4965.c
index f86a24e..81760aa 100644
--- a/drivers/net/wireless/iwlwifi/iwl-4965.c
+++ b/drivers/net/wireless/iwlwifi/iwl-4965.c
@@ -3229,9 +3229,7 @@ int iwl4965_tx_cmd(struct iwl_priv *priv, struct iwl_cmd *out_cmd,
 	tx->rate_n_flags = iwl_hw_set_rate_n_flags(iwl_rates[rate_index].plcp,
 						rate_flags);
 
-	if (ieee80211_is_probe_request(fc))
-		tx->tx_flags |= TX_CMD_FLG_TSF_MSK;
-	else if (ieee80211_is_back_request(fc))
+	if (ieee80211_is_back_request(fc))
 		tx->tx_flags |= TX_CMD_FLG_ACK_MSK |
 			TX_CMD_FLG_IMM_BA_RSP_MASK;
 #ifdef CONFIG_IWLWIFI_HT
-- 
1.5.2
