Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga02.intel.com ([134.134.136.20]:19551 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759496AbYF3J1O (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 30 Jun 2008 05:27:14 -0400
From: Zhu Yi <yi.zhu@intel.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org,
	Ron Rindjunsky <ron.rindjunsky@intel.com>,
	Tomas Winkler <tomas.winkler@intel.com>,
	Zhu Yi <yi.zhu@intel.com>
Subject: [PATCH 23/33] iwlwifi: eliminate iwl4965_mac_get_tsf
Date: Mon, 30 Jun 2008 17:23:23 +0800
Message-Id: <1214817813-17639-24-git-send-email-yi.zhu@intel.com> (sfid-20080630_113813_215708_94A57311)
In-Reply-To: <1214817813-17639-23-git-send-email-yi.zhu@intel.com>
References: <1214817813-17639-1-git-send-email-yi.zhu@intel.com>
 <1214817813-17639-2-git-send-email-yi.zhu@intel.com>
 <1214817813-17639-3-git-send-email-yi.zhu@intel.com>
 <1214817813-17639-4-git-send-email-yi.zhu@intel.com>
 <1214817813-17639-5-git-send-email-yi.zhu@intel.com>
 <1214817813-17639-6-git-send-email-yi.zhu@intel.com>
 <1214817813-17639-7-git-send-email-yi.zhu@intel.com>
 <1214817813-17639-8-git-send-email-yi.zhu@intel.com>
 <1214817813-17639-9-git-send-email-yi.zhu@intel.com>
 <1214817813-17639-10-git-send-email-yi.zhu@intel.com>
 <1214817813-17639-11-git-send-email-yi.zhu@intel.com>
 <1214817813-17639-12-git-send-email-yi.zhu@intel.com>
 <1214817813-17639-13-git-send-email-yi.zhu@intel.com>
 <1214817813-17639-14-git-send-email-yi.zhu@intel.com>
 <1214817813-17639-15-git-send-email-yi.zhu@intel.com>
 <1214817813-17639-16-git-send-email-yi.zhu@intel.com>
 <1214817813-17639-17-git-send-email-yi.zhu@intel.com>
 <1214817813-17639-18-git-send-email-yi.zhu@intel.com>
 <1214817813-17639-19-git-send-email-yi.zhu@intel.com>
 <1214817813-17639-20-git-send-email-yi.zhu@intel.com>
 <1214817813-17639-21-git-send-email-yi.zhu@intel.com>
 <1214817813-17639-22-git-send-email-yi.zhu@intel.com>
 <1214817813-17639-23-git-send-email-yi.zhu@intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Ron Rindjunsky <ron.rindjunsky@intel.com>

This patch removes iwl4965_mac_get_tsf, as this function does not
currently reports any actual value.

Signed-off-by: Ron Rindjunsky <ron.rindjunsky@intel.com>
Signed-off-by: Tomas Winkler <tomas.winkler@intel.com>
Signed-off-by: Zhu Yi <yi.zhu@intel.com>
---
 drivers/net/wireless/iwlwifi/iwl4965-base.c |   12 ------------
 1 files changed, 0 insertions(+), 12 deletions(-)

diff --git a/drivers/net/wireless/iwlwifi/iwl4965-base.c b/drivers/net/wireless/iwlwifi/iwl4965-base.c
index 7c7b103..f1cf4b1 100644
--- a/drivers/net/wireless/iwlwifi/iwl4965-base.c
+++ b/drivers/net/wireless/iwlwifi/iwl4965-base.c
@@ -3413,17 +3413,6 @@ static int iwl4965_mac_get_stats(struct ieee80211_hw *hw,
 	return 0;
 }
 
-static u64 iwl4965_mac_get_tsf(struct ieee80211_hw *hw)
-{
-	struct iwl_priv *priv;
-
-	priv = hw->priv;
-	IWL_DEBUG_MAC80211("enter\n");
-	IWL_DEBUG_MAC80211("leave\n");
-
-	return 0;
-}
-
 static void iwl4965_mac_reset_tsf(struct ieee80211_hw *hw)
 {
 	struct iwl_priv *priv = hw->priv;
@@ -4114,7 +4103,6 @@ static struct ieee80211_ops iwl4965_hw_ops = {
 	.get_stats = iwl4965_mac_get_stats,
 	.get_tx_stats = iwl4965_mac_get_tx_stats,
 	.conf_tx = iwl4965_mac_conf_tx,
-	.get_tsf = iwl4965_mac_get_tsf,
 	.reset_tsf = iwl4965_mac_reset_tsf,
 	.beacon_update = iwl4965_mac_beacon_update,
 	.bss_info_changed = iwl4965_bss_info_changed,
-- 
1.5.3.6

