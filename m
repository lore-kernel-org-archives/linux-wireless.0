Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga09.intel.com ([134.134.136.24]:51544 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755167Ab2CDUnJ (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Sun, 4 Mar 2012 15:43:09 -0500
From: Wey-Yi Guy <wey-yi.w.guy@intel.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org,
	Johannes Berg <johannes.berg@intel.com>,
	Wey-Yi Guy <wey-yi.w.guy@intel.com>
Subject: [PATCH 070/101] iwlwifi: remove unused argument from iwl_init_hw_rates
Date: Sun,  4 Mar 2012 11:29:24 -0800
Message-Id: <1330889395-533-71-git-send-email-wey-yi.w.guy@intel.com> (sfid-20120304_214526_668689_14A0E00D)
In-Reply-To: <1330889395-533-1-git-send-email-wey-yi.w.guy@intel.com>
References: <1330889395-533-1-git-send-email-wey-yi.w.guy@intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Johannes Berg <johannes.berg@intel.com>

The function never uses the priv argument as it
only fills in the passed data, so remove the
argument.

Signed-off-by: Johannes Berg <johannes.berg@intel.com>
Signed-off-by: Wey-Yi Guy <wey-yi.w.guy@intel.com>
---
 drivers/net/wireless/iwlwifi/iwl-agn.c |    5 ++---
 1 files changed, 2 insertions(+), 3 deletions(-)

diff --git a/drivers/net/wireless/iwlwifi/iwl-agn.c b/drivers/net/wireless/iwlwifi/iwl-agn.c
index 4cd375c..397faf9 100644
--- a/drivers/net/wireless/iwlwifi/iwl-agn.c
+++ b/drivers/net/wireless/iwlwifi/iwl-agn.c
@@ -1010,8 +1010,7 @@ void iwl_cancel_deferred_work(struct iwl_priv *priv)
 	del_timer_sync(&priv->ucode_trace);
 }
 
-static void iwl_init_hw_rates(struct iwl_priv *priv,
-			      struct ieee80211_rate *rates)
+static void iwl_init_hw_rates(struct ieee80211_rate *rates)
 {
 	int i;
 
@@ -1090,7 +1089,7 @@ static int iwl_init_drv(struct iwl_priv *priv)
 		IWL_ERR(priv, "initializing geos failed: %d\n", ret);
 		goto err_free_channel_map;
 	}
-	iwl_init_hw_rates(priv, priv->ieee_rates);
+	iwl_init_hw_rates(priv->ieee_rates);
 
 	return 0;
 
-- 
1.7.0.4

