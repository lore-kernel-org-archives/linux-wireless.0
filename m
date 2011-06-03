Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga14.intel.com ([143.182.124.37]:19443 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751674Ab1FCPWw (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 3 Jun 2011 11:22:52 -0400
From: Wey-Yi Guy <wey-yi.w.guy@intel.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org,
	ipw3945-devel@lists.sourceforge.net,
	Wey-Yi Guy <wey-yi.w.guy@intel.com>
Subject: [PATCH 1/5] iwlagn: save the latest smps mode
Date: Fri,  3 Jun 2011 07:54:12 -0700
Message-Id: <1307112856-20231-2-git-send-email-wey-yi.w.guy@intel.com> (sfid-20110603_172257_400505_554D9892)
In-Reply-To: <1307112856-20231-1-git-send-email-wey-yi.w.guy@intel.com>
References: <1307112856-20231-1-git-send-email-wey-yi.w.guy@intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

When change smps mode due to bt coex, save it

Signed-off-by: Wey-Yi Guy <wey-yi.w.guy@intel.com>
---
 drivers/net/wireless/iwlwifi/iwl-agn-lib.c |    1 +
 1 files changed, 1 insertions(+), 0 deletions(-)

diff --git a/drivers/net/wireless/iwlwifi/iwl-agn-lib.c b/drivers/net/wireless/iwlwifi/iwl-agn-lib.c
index 4ab77c8..677f73c 100644
--- a/drivers/net/wireless/iwlwifi/iwl-agn-lib.c
+++ b/drivers/net/wireless/iwlwifi/iwl-agn-lib.c
@@ -1797,6 +1797,7 @@ static void iwlagn_bt_traffic_change_work(struct work_struct *work)
 		priv->cfg->ops->lib->update_chain_flags(priv);
 
 	if (smps_request != -1) {
+		priv->current_ht_config.smps = smps_request;
 		for_each_context(priv, ctx) {
 			if (ctx->vif && ctx->vif->type == NL80211_IFTYPE_STATION)
 				ieee80211_request_smps(ctx->vif, smps_request);
-- 
1.7.0.4

