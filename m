Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga11.intel.com ([192.55.52.93]:54843 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752589AbYLSCpO (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 18 Dec 2008 21:45:14 -0500
From: Zhu Yi <yi.zhu@intel.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org,
	ipw3945-devel@lists.sourceforge.net,
	"Winkler, Tomas" <tomas.winkler@intel.com>,
	Zhu Yi <yi.zhu@intel.com>
Subject: [PATCH 16/43] iwlwifi: emliminate iwl3945_mac_get_stats mac80211 handler
Date: Fri, 19 Dec 2008 10:37:16 +0800
Message-Id: <1229654263-21454-17-git-send-email-yi.zhu@intel.com> (sfid-20081219_034541_022757_8EF7E9AA)
In-Reply-To: <1229654263-21454-16-git-send-email-yi.zhu@intel.com>
References: <1229654263-21454-1-git-send-email-yi.zhu@intel.com>
 <1229654263-21454-2-git-send-email-yi.zhu@intel.com>
 <1229654263-21454-3-git-send-email-yi.zhu@intel.com>
 <1229654263-21454-4-git-send-email-yi.zhu@intel.com>
 <1229654263-21454-5-git-send-email-yi.zhu@intel.com>
 <1229654263-21454-6-git-send-email-yi.zhu@intel.com>
 <1229654263-21454-7-git-send-email-yi.zhu@intel.com>
 <1229654263-21454-8-git-send-email-yi.zhu@intel.com>
 <1229654263-21454-9-git-send-email-yi.zhu@intel.com>
 <1229654263-21454-10-git-send-email-yi.zhu@intel.com>
 <1229654263-21454-11-git-send-email-yi.zhu@intel.com>
 <1229654263-21454-12-git-send-email-yi.zhu@intel.com>
 <1229654263-21454-13-git-send-email-yi.zhu@intel.com>
 <1229654263-21454-14-git-send-email-yi.zhu@intel.com>
 <1229654263-21454-15-git-send-email-yi.zhu@intel.com>
 <1229654263-21454-16-git-send-email-yi.zhu@intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Winkler, Tomas <tomas.winkler@intel.com>

This patch removes empty iwl3945_mac_get_stats mac80211 handler.

Signed-off-by: Tomas Winkler <tomas.winkler@intel.com>
Signed-off-by: Zhu Yi <yi.zhu@intel.com>
---
 drivers/net/wireless/iwlwifi/iwl3945-base.c |    7 -------
 1 files changed, 0 insertions(+), 7 deletions(-)

diff --git a/drivers/net/wireless/iwlwifi/iwl3945-base.c b/drivers/net/wireless/iwlwifi/iwl3945-base.c
index 2e51f8f..c651d0d 100644
--- a/drivers/net/wireless/iwlwifi/iwl3945-base.c
+++ b/drivers/net/wireless/iwlwifi/iwl3945-base.c
@@ -7133,12 +7133,6 @@ static int iwl3945_mac_get_tx_stats(struct ieee80211_hw *hw,
 	return 0;
 }
 
-static int iwl3945_mac_get_stats(struct ieee80211_hw *hw,
-			     struct ieee80211_low_level_stats *stats)
-{
-	return 0;
-}
-
 static void iwl3945_mac_reset_tsf(struct ieee80211_hw *hw)
 {
 	struct iwl3945_priv *priv = hw->priv;
@@ -7779,7 +7773,6 @@ static struct ieee80211_ops iwl3945_hw_ops = {
 	.config_interface = iwl3945_mac_config_interface,
 	.configure_filter = iwl3945_configure_filter,
 	.set_key = iwl3945_mac_set_key,
-	.get_stats = iwl3945_mac_get_stats,
 	.get_tx_stats = iwl3945_mac_get_tx_stats,
 	.conf_tx = iwl3945_mac_conf_tx,
 	.reset_tsf = iwl3945_mac_reset_tsf,
-- 
1.5.3.6

